
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 73 03 00 00       	call   8003a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
//#endif
//	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f0 00 10 00 82 	movl   $0x82001000,-0x10(%ebp)

	cprintf("STEP A: checking the creation of shared variables...\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 42 80 00       	push   $0x804220
  80004e:	e8 d4 07 00 00       	call   800827 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800056:	e8 36 30 00 00       	call   803091 <sys_calculate_free_frames>
  80005b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	68 00 10 00 00       	push   $0x1000
  800068:	68 56 42 80 00       	push   $0x804256
  80006d:	e8 e4 1e 00 00       	call   801f56 <smalloc>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != (uint32*)pagealloc_start) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80007e:	74 14                	je     800094 <_main+0x5c>
  800080:	83 ec 04             	sub    $0x4,%esp
  800083:	68 58 42 80 00       	push   $0x804258
  800088:	6a 1a                	push   $0x1a
  80008a:	68 c4 42 80 00       	push   $0x8042c4
  80008f:	e8 c5 04 00 00       	call   800559 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800094:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80009b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80009e:	e8 ee 2f 00 00       	call   803091 <sys_calculate_free_frames>
  8000a3:	29 c3                	sub    %eax,%ebx
  8000a5:	89 d8                	mov    %ebx,%eax
  8000a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000b0:	72 0d                	jb     8000bf <_main+0x87>
  8000b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b5:	8d 50 02             	lea    0x2(%eax),%edx
  8000b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000bb:	39 c2                	cmp    %eax,%edx
  8000bd:	73 24                	jae    8000e3 <_main+0xab>
  8000bf:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000c2:	e8 ca 2f 00 00       	call   803091 <sys_calculate_free_frames>
  8000c7:	29 c3                	sub    %eax,%ebx
  8000c9:	89 d8                	mov    %ebx,%eax
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d1:	50                   	push   %eax
  8000d2:	68 dc 42 80 00       	push   $0x8042dc
  8000d7:	6a 1d                	push   $0x1d
  8000d9:	68 c4 42 80 00       	push   $0x8042c4
  8000de:	e8 76 04 00 00       	call   800559 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8000e3:	e8 a9 2f 00 00       	call   803091 <sys_calculate_free_frames>
  8000e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	6a 01                	push   $0x1
  8000f0:	68 04 10 00 00       	push   $0x1004
  8000f5:	68 74 43 80 00       	push   $0x804374
  8000fa:	e8 57 1e 00 00       	call   801f56 <smalloc>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800108:	05 00 10 00 00       	add    $0x1000,%eax
  80010d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800110:	74 14                	je     800126 <_main+0xee>
  800112:	83 ec 04             	sub    $0x4,%esp
  800115:	68 58 42 80 00       	push   $0x804258
  80011a:	6a 21                	push   $0x21
  80011c:	68 c4 42 80 00       	push   $0x8042c4
  800121:	e8 33 04 00 00       	call   800559 <_panic>
		expected = 2 ; /*2pages*/
  800126:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80012d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800130:	e8 5c 2f 00 00       	call   803091 <sys_calculate_free_frames>
  800135:	29 c3                	sub    %eax,%ebx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80013c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	72 0d                	jb     800151 <_main+0x119>
  800144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800147:	8d 50 02             	lea    0x2(%eax),%edx
  80014a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	73 24                	jae    800175 <_main+0x13d>
  800151:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800154:	e8 38 2f 00 00       	call   803091 <sys_calculate_free_frames>
  800159:	29 c3                	sub    %eax,%ebx
  80015b:	89 d8                	mov    %ebx,%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	ff 75 e4             	pushl  -0x1c(%ebp)
  800163:	50                   	push   %eax
  800164:	68 dc 42 80 00       	push   $0x8042dc
  800169:	6a 24                	push   $0x24
  80016b:	68 c4 42 80 00       	push   $0x8042c4
  800170:	e8 e4 03 00 00       	call   800559 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800175:	e8 17 2f 00 00       	call   803091 <sys_calculate_free_frames>
  80017a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = smalloc("y", 4, 1);
  80017d:	83 ec 04             	sub    $0x4,%esp
  800180:	6a 01                	push   $0x1
  800182:	6a 04                	push   $0x4
  800184:	68 76 43 80 00       	push   $0x804376
  800189:	e8 c8 1d 00 00       	call   801f56 <smalloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800197:	05 00 30 00 00       	add    $0x3000,%eax
  80019c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80019f:	74 14                	je     8001b5 <_main+0x17d>
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	68 58 42 80 00       	push   $0x804258
  8001a9:	6a 28                	push   $0x28
  8001ab:	68 c4 42 80 00       	push   $0x8042c4
  8001b0:	e8 a4 03 00 00       	call   800559 <_panic>
		expected = 1 ; /*1page*/
  8001b5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001bc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001bf:	e8 cd 2e 00 00       	call   803091 <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001d1:	72 0d                	jb     8001e0 <_main+0x1a8>
  8001d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d6:	8d 50 02             	lea    0x2(%eax),%edx
  8001d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001dc:	39 c2                	cmp    %eax,%edx
  8001de:	73 24                	jae    800204 <_main+0x1cc>
  8001e0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001e3:	e8 a9 2e 00 00       	call   803091 <sys_calculate_free_frames>
  8001e8:	29 c3                	sub    %eax,%ebx
  8001ea:	89 d8                	mov    %ebx,%eax
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	50                   	push   %eax
  8001f3:	68 dc 42 80 00       	push   $0x8042dc
  8001f8:	6a 2b                	push   $0x2b
  8001fa:	68 c4 42 80 00       	push   $0x8042c4
  8001ff:	e8 55 03 00 00       	call   800559 <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	68 78 43 80 00       	push   $0x804378
  80020c:	e8 16 06 00 00       	call   800827 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	68 90 43 80 00       	push   $0x804390
  80021c:	e8 06 06 00 00       	call   800827 <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  800224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  80022b:	eb 2d                	jmp    80025a <_main+0x222>
		{
			x[i] = -1;
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80024f:	01 d0                	add    %edx,%eax
  800251:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800257:	ff 45 f4             	incl   -0xc(%ebp)
  80025a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  800261:	7e ca                	jle    80022d <_main+0x1f5>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80026a:	eb 18                	jmp    800284 <_main+0x24c>
		{
			z[i] = -1;
  80026c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800276:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800279:	01 d0                	add    %edx,%eax
  80027b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800281:	ff 45 f4             	incl   -0xc(%ebp)
  800284:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80028b:	7e df                	jle    80026c <_main+0x234>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80028d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800290:	8b 00                	mov    (%eax),%eax
  800292:	83 f8 ff             	cmp    $0xffffffff,%eax
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 b8 43 80 00       	push   $0x8043b8
  80029f:	6a 3f                	push   $0x3f
  8002a1:	68 c4 42 80 00       	push   $0x8042c4
  8002a6:	e8 ae 02 00 00       	call   800559 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b8:	74 14                	je     8002ce <_main+0x296>
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 b8 43 80 00       	push   $0x8043b8
  8002c2:	6a 40                	push   $0x40
  8002c4:	68 c4 42 80 00       	push   $0x8042c4
  8002c9:	e8 8b 02 00 00       	call   800559 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d1:	8b 00                	mov    (%eax),%eax
  8002d3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d6:	74 14                	je     8002ec <_main+0x2b4>
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	68 b8 43 80 00       	push   $0x8043b8
  8002e0:	6a 42                	push   $0x42
  8002e2:	68 c4 42 80 00       	push   $0x8042c4
  8002e7:	e8 6d 02 00 00       	call   800559 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ef:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002f4:	8b 00                	mov    (%eax),%eax
  8002f6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f9:	74 14                	je     80030f <_main+0x2d7>
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	68 b8 43 80 00       	push   $0x8043b8
  800303:	6a 43                	push   $0x43
  800305:	68 c4 42 80 00       	push   $0x8042c4
  80030a:	e8 4a 02 00 00       	call   800559 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 f8 ff             	cmp    $0xffffffff,%eax
  800317:	74 14                	je     80032d <_main+0x2f5>
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	68 b8 43 80 00       	push   $0x8043b8
  800321:	6a 45                	push   $0x45
  800323:	68 c4 42 80 00       	push   $0x8042c4
  800328:	e8 2c 02 00 00       	call   800559 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  80032d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800330:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	83 f8 ff             	cmp    $0xffffffff,%eax
  80033a:	74 14                	je     800350 <_main+0x318>
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	68 b8 43 80 00       	push   $0x8043b8
  800344:	6a 46                	push   $0x46
  800346:	68 c4 42 80 00       	push   $0x8042c4
  80034b:	e8 09 02 00 00       	call   800559 <_panic>
	}

	cprintf("test sharing 1 [Create] is finished!!\n\n\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 e4 43 80 00       	push   $0x8043e4
  800358:	e8 ca 04 00 00       	call   800827 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800360:	e8 0e 2f 00 00       	call   803273 <sys_getparentenvid>
  800365:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(parentenvID > 0)
  800368:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80036c:	7e 35                	jle    8003a3 <_main+0x36b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80036e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	68 0d 44 80 00       	push   $0x80440d
  80037d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800380:	e8 2b 1f 00 00       	call   8022b0 <sget>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 d0             	mov    %eax,-0x30(%ebp)
		sys_lock_cons();
  80038b:	e8 51 2c 00 00       	call   802fe1 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800390:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	8d 50 01             	lea    0x1(%eax),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80039d:	e8 59 2c 00 00       	call   802ffb <sys_unlock_cons>
	}

	return;
  8003a2:	90                   	nop
  8003a3:	90                   	nop
}
  8003a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003b2:	e8 a3 2e 00 00       	call   80325a <sys_getenvindex>
  8003b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8003ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	c1 e0 03             	shl    $0x3,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	c1 e0 02             	shl    $0x2,%eax
  8003c7:	01 d0                	add    %edx,%eax
  8003c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	c1 e0 03             	shl    $0x3,%eax
  8003d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003da:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003df:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e4:	8a 40 20             	mov    0x20(%eax),%al
  8003e7:	84 c0                	test   %al,%al
  8003e9:	74 0d                	je     8003f8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8003eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f0:	83 c0 20             	add    $0x20,%eax
  8003f3:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003fc:	7e 0a                	jle    800408 <libmain+0x5f>
		binaryname = argv[0];
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	ff 75 0c             	pushl  0xc(%ebp)
  80040e:	ff 75 08             	pushl  0x8(%ebp)
  800411:	e8 22 fc ff ff       	call   800038 <_main>
  800416:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800419:	a1 00 50 80 00       	mov    0x805000,%eax
  80041e:	85 c0                	test   %eax,%eax
  800420:	0f 84 01 01 00 00    	je     800527 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800426:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80042c:	bb 14 45 80 00       	mov    $0x804514,%ebx
  800431:	ba 0e 00 00 00       	mov    $0xe,%edx
  800436:	89 c7                	mov    %eax,%edi
  800438:	89 de                	mov    %ebx,%esi
  80043a:	89 d1                	mov    %edx,%ecx
  80043c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80043e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800441:	b9 56 00 00 00       	mov    $0x56,%ecx
  800446:	b0 00                	mov    $0x0,%al
  800448:	89 d7                	mov    %edx,%edi
  80044a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80044c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800453:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	50                   	push   %eax
  80045a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800460:	50                   	push   %eax
  800461:	e8 2a 30 00 00       	call   803490 <sys_utilities>
  800466:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800469:	e8 73 2b 00 00       	call   802fe1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80046e:	83 ec 0c             	sub    $0xc,%esp
  800471:	68 34 44 80 00       	push   $0x804434
  800476:	e8 ac 03 00 00       	call   800827 <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80047e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	74 18                	je     80049d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800485:	e8 24 30 00 00       	call   8034ae <sys_get_optimal_num_faults>
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	50                   	push   %eax
  80048e:	68 5c 44 80 00       	push   $0x80445c
  800493:	e8 8f 03 00 00       	call   800827 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	eb 59                	jmp    8004f6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80049d:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a2:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8004a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ad:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8004b3:	83 ec 04             	sub    $0x4,%esp
  8004b6:	52                   	push   %edx
  8004b7:	50                   	push   %eax
  8004b8:	68 80 44 80 00       	push   $0x804480
  8004bd:	e8 65 03 00 00       	call   800827 <cprintf>
  8004c2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ca:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8004d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d5:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8004db:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e0:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004e6:	51                   	push   %ecx
  8004e7:	52                   	push   %edx
  8004e8:	50                   	push   %eax
  8004e9:	68 a8 44 80 00       	push   $0x8044a8
  8004ee:	e8 34 03 00 00       	call   800827 <cprintf>
  8004f3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fb:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	50                   	push   %eax
  800505:	68 00 45 80 00       	push   $0x804500
  80050a:	e8 18 03 00 00       	call   800827 <cprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800512:	83 ec 0c             	sub    $0xc,%esp
  800515:	68 34 44 80 00       	push   $0x804434
  80051a:	e8 08 03 00 00       	call   800827 <cprintf>
  80051f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800522:	e8 d4 2a 00 00       	call   802ffb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800527:	e8 1f 00 00 00       	call   80054b <exit>
}
  80052c:	90                   	nop
  80052d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800530:	5b                   	pop    %ebx
  800531:	5e                   	pop    %esi
  800532:	5f                   	pop    %edi
  800533:	5d                   	pop    %ebp
  800534:	c3                   	ret    

00800535 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80053b:	83 ec 0c             	sub    $0xc,%esp
  80053e:	6a 00                	push   $0x0
  800540:	e8 e1 2c 00 00       	call   803226 <sys_destroy_env>
  800545:	83 c4 10             	add    $0x10,%esp
}
  800548:	90                   	nop
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <exit>:

void
exit(void)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800551:	e8 36 2d 00 00       	call   80328c <sys_exit_env>
}
  800556:	90                   	nop
  800557:	c9                   	leave  
  800558:	c3                   	ret    

00800559 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800559:	55                   	push   %ebp
  80055a:	89 e5                	mov    %esp,%ebp
  80055c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80055f:	8d 45 10             	lea    0x10(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800568:	a1 38 51 83 00       	mov    0x835138,%eax
  80056d:	85 c0                	test   %eax,%eax
  80056f:	74 16                	je     800587 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800571:	a1 38 51 83 00       	mov    0x835138,%eax
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	50                   	push   %eax
  80057a:	68 78 45 80 00       	push   $0x804578
  80057f:	e8 a3 02 00 00       	call   800827 <cprintf>
  800584:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800587:	a1 04 50 80 00       	mov    0x805004,%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	ff 75 0c             	pushl  0xc(%ebp)
  800592:	ff 75 08             	pushl  0x8(%ebp)
  800595:	50                   	push   %eax
  800596:	68 80 45 80 00       	push   $0x804580
  80059b:	6a 74                	push   $0x74
  80059d:	e8 b2 02 00 00       	call   800854 <cprintf_colored>
  8005a2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8005a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ae:	50                   	push   %eax
  8005af:	e8 04 02 00 00       	call   8007b8 <vcprintf>
  8005b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	6a 00                	push   $0x0
  8005bc:	68 a8 45 80 00       	push   $0x8045a8
  8005c1:	e8 f2 01 00 00       	call   8007b8 <vcprintf>
  8005c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005c9:	e8 7d ff ff ff       	call   80054b <exit>

	// should not return here
	while (1) ;
  8005ce:	eb fe                	jmp    8005ce <_panic+0x75>

008005d0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005db:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 14                	je     8005fc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 ac 45 80 00       	push   $0x8045ac
  8005f0:	6a 26                	push   $0x26
  8005f2:	68 f8 45 80 00       	push   $0x8045f8
  8005f7:	e8 5d ff ff ff       	call   800559 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800603:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060a:	e9 c5 00 00 00       	jmp    8006d4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	85 c0                	test   %eax,%eax
  800622:	75 08                	jne    80062c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800624:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800627:	e9 a5 00 00 00       	jmp    8006d1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80062c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80063a:	eb 69                	jmp    8006a5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80063c:	a1 20 50 80 00       	mov    0x805020,%eax
  800641:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800647:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80064a:	89 d0                	mov    %edx,%eax
  80064c:	01 c0                	add    %eax,%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	c1 e0 03             	shl    $0x3,%eax
  800653:	01 c8                	add    %ecx,%eax
  800655:	8a 40 04             	mov    0x4(%eax),%al
  800658:	84 c0                	test   %al,%al
  80065a:	75 46                	jne    8006a2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80065c:	a1 20 50 80 00       	mov    0x805020,%eax
  800661:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800667:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80066a:	89 d0                	mov    %edx,%eax
  80066c:	01 c0                	add    %eax,%eax
  80066e:	01 d0                	add    %edx,%eax
  800670:	c1 e0 03             	shl    $0x3,%eax
  800673:	01 c8                	add    %ecx,%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80067a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80067d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800682:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800687:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	01 c8                	add    %ecx,%eax
  800693:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800695:	39 c2                	cmp    %eax,%edx
  800697:	75 09                	jne    8006a2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800699:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006a0:	eb 15                	jmp    8006b7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a2:	ff 45 e8             	incl   -0x18(%ebp)
  8006a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8006aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006b3:	39 c2                	cmp    %eax,%edx
  8006b5:	77 85                	ja     80063c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006bb:	75 14                	jne    8006d1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006bd:	83 ec 04             	sub    $0x4,%esp
  8006c0:	68 04 46 80 00       	push   $0x804604
  8006c5:	6a 3a                	push   $0x3a
  8006c7:	68 f8 45 80 00       	push   $0x8045f8
  8006cc:	e8 88 fe ff ff       	call   800559 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006d1:	ff 45 f0             	incl   -0x10(%ebp)
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006da:	0f 8c 2f ff ff ff    	jl     80060f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006ee:	eb 26                	jmp    800716 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006fe:	89 d0                	mov    %edx,%eax
  800700:	01 c0                	add    %eax,%eax
  800702:	01 d0                	add    %edx,%eax
  800704:	c1 e0 03             	shl    $0x3,%eax
  800707:	01 c8                	add    %ecx,%eax
  800709:	8a 40 04             	mov    0x4(%eax),%al
  80070c:	3c 01                	cmp    $0x1,%al
  80070e:	75 03                	jne    800713 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800710:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800713:	ff 45 e0             	incl   -0x20(%ebp)
  800716:	a1 20 50 80 00       	mov    0x805020,%eax
  80071b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800721:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800724:	39 c2                	cmp    %eax,%edx
  800726:	77 c8                	ja     8006f0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80072e:	74 14                	je     800744 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800730:	83 ec 04             	sub    $0x4,%esp
  800733:	68 58 46 80 00       	push   $0x804658
  800738:	6a 44                	push   $0x44
  80073a:	68 f8 45 80 00       	push   $0x8045f8
  80073f:	e8 15 fe ff ff       	call   800559 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800744:	90                   	nop
  800745:	c9                   	leave  
  800746:	c3                   	ret    

00800747 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	53                   	push   %ebx
  80074b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80074e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	8d 48 01             	lea    0x1(%eax),%ecx
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
  800759:	89 0a                	mov    %ecx,(%edx)
  80075b:	8b 55 08             	mov    0x8(%ebp),%edx
  80075e:	88 d1                	mov    %dl,%cl
  800760:	8b 55 0c             	mov    0xc(%ebp),%edx
  800763:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800767:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800771:	75 30                	jne    8007a3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800773:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800779:	a0 64 d0 81 00       	mov    0x81d064,%al
  80077e:	0f b6 c0             	movzbl %al,%eax
  800781:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800784:	8b 09                	mov    (%ecx),%ecx
  800786:	89 cb                	mov    %ecx,%ebx
  800788:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80078b:	83 c1 08             	add    $0x8,%ecx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	53                   	push   %ebx
  800791:	51                   	push   %ecx
  800792:	e8 06 28 00 00       	call   802f9d <sys_cputs>
  800797:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80079a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a6:	8b 40 04             	mov    0x4(%eax),%eax
  8007a9:	8d 50 01             	lea    0x1(%eax),%edx
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007b2:	90                   	nop
  8007b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007c8:	00 00 00 
	b.cnt = 0;
  8007cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007d2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007d5:	ff 75 0c             	pushl  0xc(%ebp)
  8007d8:	ff 75 08             	pushl  0x8(%ebp)
  8007db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e1:	50                   	push   %eax
  8007e2:	68 47 07 80 00       	push   $0x800747
  8007e7:	e8 5a 02 00 00       	call   800a46 <vprintfmt>
  8007ec:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8007ef:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8007f5:	a0 64 d0 81 00       	mov    0x81d064,%al
  8007fa:	0f b6 c0             	movzbl %al,%eax
  8007fd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800803:	52                   	push   %edx
  800804:	50                   	push   %eax
  800805:	51                   	push   %ecx
  800806:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80080c:	83 c0 08             	add    $0x8,%eax
  80080f:	50                   	push   %eax
  800810:	e8 88 27 00 00       	call   802f9d <sys_cputs>
  800815:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800818:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  80081f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80082d:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800834:	8d 45 0c             	lea    0xc(%ebp),%eax
  800837:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 f4             	pushl  -0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	e8 6f ff ff ff       	call   8007b8 <vcprintf>
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80085a:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	c1 e0 08             	shl    $0x8,%eax
  800867:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  80086c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80086f:	83 c0 04             	add    $0x4,%eax
  800872:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800875:	8b 45 0c             	mov    0xc(%ebp),%eax
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	ff 75 f4             	pushl  -0xc(%ebp)
  80087e:	50                   	push   %eax
  80087f:	e8 34 ff ff ff       	call   8007b8 <vcprintf>
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80088a:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  800891:	07 00 00 

	return cnt;
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800897:	c9                   	leave  
  800898:	c3                   	ret    

00800899 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80089f:	e8 3d 27 00 00       	call   802fe1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8008a4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b3:	50                   	push   %eax
  8008b4:	e8 ff fe ff ff       	call   8007b8 <vcprintf>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008bf:	e8 37 27 00 00       	call   802ffb <sys_unlock_cons>
	return cnt;
  8008c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	53                   	push   %ebx
  8008cd:	83 ec 14             	sub    $0x14,%esp
  8008d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008dc:	8b 45 18             	mov    0x18(%ebp),%eax
  8008df:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e7:	77 55                	ja     80093e <printnum+0x75>
  8008e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008ec:	72 05                	jb     8008f3 <printnum+0x2a>
  8008ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008f1:	77 4b                	ja     80093e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008f3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008f6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	52                   	push   %edx
  800902:	50                   	push   %eax
  800903:	ff 75 f4             	pushl  -0xc(%ebp)
  800906:	ff 75 f0             	pushl  -0x10(%ebp)
  800909:	e8 a6 36 00 00       	call   803fb4 <__udivdi3>
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	83 ec 04             	sub    $0x4,%esp
  800914:	ff 75 20             	pushl  0x20(%ebp)
  800917:	53                   	push   %ebx
  800918:	ff 75 18             	pushl  0x18(%ebp)
  80091b:	52                   	push   %edx
  80091c:	50                   	push   %eax
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	e8 a1 ff ff ff       	call   8008c9 <printnum>
  800928:	83 c4 20             	add    $0x20,%esp
  80092b:	eb 1a                	jmp    800947 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	ff 75 0c             	pushl  0xc(%ebp)
  800933:	ff 75 20             	pushl  0x20(%ebp)
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80093e:	ff 4d 1c             	decl   0x1c(%ebp)
  800941:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800945:	7f e6                	jg     80092d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800947:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80094a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80094f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800955:	53                   	push   %ebx
  800956:	51                   	push   %ecx
  800957:	52                   	push   %edx
  800958:	50                   	push   %eax
  800959:	e8 66 37 00 00       	call   8040c4 <__umoddi3>
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	05 d4 48 80 00       	add    $0x8048d4,%eax
  800966:	8a 00                	mov    (%eax),%al
  800968:	0f be c0             	movsbl %al,%eax
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	50                   	push   %eax
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	ff d0                	call   *%eax
  800977:	83 c4 10             	add    $0x10,%esp
}
  80097a:	90                   	nop
  80097b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800983:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800987:	7e 1c                	jle    8009a5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	8d 50 08             	lea    0x8(%eax),%edx
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	89 10                	mov    %edx,(%eax)
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	83 e8 08             	sub    $0x8,%eax
  80099e:	8b 50 04             	mov    0x4(%eax),%edx
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	eb 40                	jmp    8009e5 <getuint+0x65>
	else if (lflag)
  8009a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a9:	74 1e                	je     8009c9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	8d 50 04             	lea    0x4(%eax),%edx
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	89 10                	mov    %edx,(%eax)
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	83 e8 04             	sub    $0x4,%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	eb 1c                	jmp    8009e5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	8d 50 04             	lea    0x4(%eax),%edx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	89 10                	mov    %edx,(%eax)
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	83 e8 04             	sub    $0x4,%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009ea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009ee:	7e 1c                	jle    800a0c <getint+0x25>
		return va_arg(*ap, long long);
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	8d 50 08             	lea    0x8(%eax),%edx
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	89 10                	mov    %edx,(%eax)
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8b 00                	mov    (%eax),%eax
  800a02:	83 e8 08             	sub    $0x8,%eax
  800a05:	8b 50 04             	mov    0x4(%eax),%edx
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	eb 38                	jmp    800a44 <getint+0x5d>
	else if (lflag)
  800a0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a10:	74 1a                	je     800a2c <getint+0x45>
		return va_arg(*ap, long);
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	8d 50 04             	lea    0x4(%eax),%edx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	89 10                	mov    %edx,(%eax)
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	83 e8 04             	sub    $0x4,%eax
  800a27:	8b 00                	mov    (%eax),%eax
  800a29:	99                   	cltd   
  800a2a:	eb 18                	jmp    800a44 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 00                	mov    (%eax),%eax
  800a31:	8d 50 04             	lea    0x4(%eax),%edx
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	89 10                	mov    %edx,(%eax)
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 00                	mov    (%eax),%eax
  800a3e:	83 e8 04             	sub    $0x4,%eax
  800a41:	8b 00                	mov    (%eax),%eax
  800a43:	99                   	cltd   
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	56                   	push   %esi
  800a4a:	53                   	push   %ebx
  800a4b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4e:	eb 17                	jmp    800a67 <vprintfmt+0x21>
			if (ch == '\0')
  800a50:	85 db                	test   %ebx,%ebx
  800a52:	0f 84 c1 03 00 00    	je     800e19 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a67:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6a:	8d 50 01             	lea    0x1(%eax),%edx
  800a6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	0f b6 d8             	movzbl %al,%ebx
  800a75:	83 fb 25             	cmp    $0x25,%ebx
  800a78:	75 d6                	jne    800a50 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a7a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a7e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a85:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	8d 50 01             	lea    0x1(%eax),%edx
  800aa0:	89 55 10             	mov    %edx,0x10(%ebp)
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	0f b6 d8             	movzbl %al,%ebx
  800aa8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aab:	83 f8 5b             	cmp    $0x5b,%eax
  800aae:	0f 87 3d 03 00 00    	ja     800df1 <vprintfmt+0x3ab>
  800ab4:	8b 04 85 f8 48 80 00 	mov    0x8048f8(,%eax,4),%eax
  800abb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800abd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ac1:	eb d7                	jmp    800a9a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ac7:	eb d1                	jmp    800a9a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ad0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ad3:	89 d0                	mov    %edx,%eax
  800ad5:	c1 e0 02             	shl    $0x2,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	01 c0                	add    %eax,%eax
  800adc:	01 d8                	add    %ebx,%eax
  800ade:	83 e8 30             	sub    $0x30,%eax
  800ae1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ae4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aec:	83 fb 2f             	cmp    $0x2f,%ebx
  800aef:	7e 3e                	jle    800b2f <vprintfmt+0xe9>
  800af1:	83 fb 39             	cmp    $0x39,%ebx
  800af4:	7f 39                	jg     800b2f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af9:	eb d5                	jmp    800ad0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 c0 04             	add    $0x4,%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	83 e8 04             	sub    $0x4,%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b0f:	eb 1f                	jmp    800b30 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b15:	79 83                	jns    800a9a <vprintfmt+0x54>
				width = 0;
  800b17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b1e:	e9 77 ff ff ff       	jmp    800a9a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b23:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b2a:	e9 6b ff ff ff       	jmp    800a9a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b2f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	0f 89 60 ff ff ff    	jns    800a9a <vprintfmt+0x54>
				width = precision, precision = -1;
  800b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b40:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b47:	e9 4e ff ff ff       	jmp    800a9a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b4c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b4f:	e9 46 ff ff ff       	jmp    800a9a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 c0 04             	add    $0x4,%eax
  800b5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	83 e8 04             	sub    $0x4,%eax
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	50                   	push   %eax
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
			break;
  800b74:	e9 9b 02 00 00       	jmp    800e14 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 c0 04             	add    $0x4,%eax
  800b7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b82:	8b 45 14             	mov    0x14(%ebp),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b8a:	85 db                	test   %ebx,%ebx
  800b8c:	79 02                	jns    800b90 <vprintfmt+0x14a>
				err = -err;
  800b8e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b90:	83 fb 64             	cmp    $0x64,%ebx
  800b93:	7f 0b                	jg     800ba0 <vprintfmt+0x15a>
  800b95:	8b 34 9d 40 47 80 00 	mov    0x804740(,%ebx,4),%esi
  800b9c:	85 f6                	test   %esi,%esi
  800b9e:	75 19                	jne    800bb9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ba0:	53                   	push   %ebx
  800ba1:	68 e5 48 80 00       	push   $0x8048e5
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	ff 75 08             	pushl  0x8(%ebp)
  800bac:	e8 70 02 00 00       	call   800e21 <printfmt>
  800bb1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bb4:	e9 5b 02 00 00       	jmp    800e14 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb9:	56                   	push   %esi
  800bba:	68 ee 48 80 00       	push   $0x8048ee
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	ff 75 08             	pushl  0x8(%ebp)
  800bc5:	e8 57 02 00 00       	call   800e21 <printfmt>
  800bca:	83 c4 10             	add    $0x10,%esp
			break;
  800bcd:	e9 42 02 00 00       	jmp    800e14 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 c0 04             	add    $0x4,%eax
  800bd8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bde:	83 e8 04             	sub    $0x4,%eax
  800be1:	8b 30                	mov    (%eax),%esi
  800be3:	85 f6                	test   %esi,%esi
  800be5:	75 05                	jne    800bec <vprintfmt+0x1a6>
				p = "(null)";
  800be7:	be f1 48 80 00       	mov    $0x8048f1,%esi
			if (width > 0 && padc != '-')
  800bec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf0:	7e 6d                	jle    800c5f <vprintfmt+0x219>
  800bf2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bf6:	74 67                	je     800c5f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	50                   	push   %eax
  800bff:	56                   	push   %esi
  800c00:	e8 1e 03 00 00       	call   800f23 <strnlen>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c0b:	eb 16                	jmp    800c23 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c0d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c11:	83 ec 08             	sub    $0x8,%esp
  800c14:	ff 75 0c             	pushl  0xc(%ebp)
  800c17:	50                   	push   %eax
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c20:	ff 4d e4             	decl   -0x1c(%ebp)
  800c23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c27:	7f e4                	jg     800c0d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c29:	eb 34                	jmp    800c5f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c2f:	74 1c                	je     800c4d <vprintfmt+0x207>
  800c31:	83 fb 1f             	cmp    $0x1f,%ebx
  800c34:	7e 05                	jle    800c3b <vprintfmt+0x1f5>
  800c36:	83 fb 7e             	cmp    $0x7e,%ebx
  800c39:	7e 12                	jle    800c4d <vprintfmt+0x207>
					putch('?', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 3f                	push   $0x3f
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
  800c4b:	eb 0f                	jmp    800c5c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	ff 75 0c             	pushl  0xc(%ebp)
  800c53:	53                   	push   %ebx
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	ff d0                	call   *%eax
  800c59:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800c5f:	89 f0                	mov    %esi,%eax
  800c61:	8d 70 01             	lea    0x1(%eax),%esi
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	0f be d8             	movsbl %al,%ebx
  800c69:	85 db                	test   %ebx,%ebx
  800c6b:	74 24                	je     800c91 <vprintfmt+0x24b>
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	78 b8                	js     800c2b <vprintfmt+0x1e5>
  800c73:	ff 4d e0             	decl   -0x20(%ebp)
  800c76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c7a:	79 af                	jns    800c2b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c7c:	eb 13                	jmp    800c91 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 20                	push   $0x20
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800c91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c95:	7f e7                	jg     800c7e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c97:	e9 78 01 00 00       	jmp    800e14 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca5:	50                   	push   %eax
  800ca6:	e8 3c fd ff ff       	call   8009e7 <getint>
  800cab:	83 c4 10             	add    $0x10,%esp
  800cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cba:	85 d2                	test   %edx,%edx
  800cbc:	79 23                	jns    800ce1 <vprintfmt+0x29b>
				putch('-', putdat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	6a 2d                	push   $0x2d
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd4:	f7 d8                	neg    %eax
  800cd6:	83 d2 00             	adc    $0x0,%edx
  800cd9:	f7 da                	neg    %edx
  800cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ce1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ce8:	e9 bc 00 00 00       	jmp    800da9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf3:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf6:	50                   	push   %eax
  800cf7:	e8 84 fc ff ff       	call   800980 <getuint>
  800cfc:	83 c4 10             	add    $0x10,%esp
  800cff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d05:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d0c:	e9 98 00 00 00       	jmp    800da9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	6a 58                	push   $0x58
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	6a 58                	push   $0x58
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	ff d0                	call   *%eax
  800d2e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d31:	83 ec 08             	sub    $0x8,%esp
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	6a 58                	push   $0x58
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	ff d0                	call   *%eax
  800d3e:	83 c4 10             	add    $0x10,%esp
			break;
  800d41:	e9 ce 00 00 00       	jmp    800e14 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	6a 30                	push   $0x30
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d56:	83 ec 08             	sub    $0x8,%esp
  800d59:	ff 75 0c             	pushl  0xc(%ebp)
  800d5c:	6a 78                	push   $0x78
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	ff d0                	call   *%eax
  800d63:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 c0 04             	add    $0x4,%eax
  800d6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d72:	83 e8 04             	sub    $0x4,%eax
  800d75:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d81:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d88:	eb 1f                	jmp    800da9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800d90:	8d 45 14             	lea    0x14(%ebp),%eax
  800d93:	50                   	push   %eax
  800d94:	e8 e7 fb ff ff       	call   800980 <getuint>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800da2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db0:	83 ec 04             	sub    $0x4,%esp
  800db3:	52                   	push   %edx
  800db4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800db7:	50                   	push   %eax
  800db8:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	ff 75 08             	pushl  0x8(%ebp)
  800dc4:	e8 00 fb ff ff       	call   8008c9 <printnum>
  800dc9:	83 c4 20             	add    $0x20,%esp
			break;
  800dcc:	eb 46                	jmp    800e14 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dce:	83 ec 08             	sub    $0x8,%esp
  800dd1:	ff 75 0c             	pushl  0xc(%ebp)
  800dd4:	53                   	push   %ebx
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	ff d0                	call   *%eax
  800dda:	83 c4 10             	add    $0x10,%esp
			break;
  800ddd:	eb 35                	jmp    800e14 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ddf:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800de6:	eb 2c                	jmp    800e14 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800de8:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800def:	eb 23                	jmp    800e14 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	6a 25                	push   $0x25
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	ff d0                	call   *%eax
  800dfe:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e01:	ff 4d 10             	decl   0x10(%ebp)
  800e04:	eb 03                	jmp    800e09 <vprintfmt+0x3c3>
  800e06:	ff 4d 10             	decl   0x10(%ebp)
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	48                   	dec    %eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	3c 25                	cmp    $0x25,%al
  800e11:	75 f3                	jne    800e06 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e13:	90                   	nop
		}
	}
  800e14:	e9 35 fc ff ff       	jmp    800a4e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e19:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e27:	8d 45 10             	lea    0x10(%ebp),%eax
  800e2a:	83 c0 04             	add    $0x4,%eax
  800e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	ff 75 f4             	pushl  -0xc(%ebp)
  800e36:	50                   	push   %eax
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	ff 75 08             	pushl  0x8(%ebp)
  800e3d:	e8 04 fc ff ff       	call   800a46 <vprintfmt>
  800e42:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e45:	90                   	nop
  800e46:	c9                   	leave  
  800e47:	c3                   	ret    

00800e48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	8b 40 08             	mov    0x8(%eax),%eax
  800e51:	8d 50 01             	lea    0x1(%eax),%edx
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	8b 10                	mov    (%eax),%edx
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	8b 40 04             	mov    0x4(%eax),%eax
  800e65:	39 c2                	cmp    %eax,%edx
  800e67:	73 12                	jae    800e7b <sprintputch+0x33>
		*b->buf++ = ch;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8b 00                	mov    (%eax),%eax
  800e6e:	8d 48 01             	lea    0x1(%eax),%ecx
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	89 0a                	mov    %ecx,(%edx)
  800e76:	8b 55 08             	mov    0x8(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
}
  800e7b:	90                   	nop
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	01 d0                	add    %edx,%eax
  800e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea3:	74 06                	je     800eab <vsnprintf+0x2d>
  800ea5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea9:	7f 07                	jg     800eb2 <vsnprintf+0x34>
		return -E_INVAL;
  800eab:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb0:	eb 20                	jmp    800ed2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800eb2:	ff 75 14             	pushl  0x14(%ebp)
  800eb5:	ff 75 10             	pushl  0x10(%ebp)
  800eb8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ebb:	50                   	push   %eax
  800ebc:	68 48 0e 80 00       	push   $0x800e48
  800ec1:	e8 80 fb ff ff       	call   800a46 <vprintfmt>
  800ec6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800eda:	8d 45 10             	lea    0x10(%ebp),%eax
  800edd:	83 c0 04             	add    $0x4,%eax
  800ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee9:	50                   	push   %eax
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	ff 75 08             	pushl  0x8(%ebp)
  800ef0:	e8 89 ff ff ff       	call   800e7e <vsnprintf>
  800ef5:	83 c4 10             	add    $0x10,%esp
  800ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0d:	eb 06                	jmp    800f15 <strlen+0x15>
		n++;
  800f0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f12:	ff 45 08             	incl   0x8(%ebp)
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	84 c0                	test   %al,%al
  800f1c:	75 f1                	jne    800f0f <strlen+0xf>
		n++;
	return n;
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f30:	eb 09                	jmp    800f3b <strnlen+0x18>
		n++;
  800f32:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	ff 4d 0c             	decl   0xc(%ebp)
  800f3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f3f:	74 09                	je     800f4a <strnlen+0x27>
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	84 c0                	test   %al,%al
  800f48:	75 e8                	jne    800f32 <strnlen+0xf>
		n++;
	return n;
  800f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f5b:	90                   	nop
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 08             	mov    %edx,0x8(%ebp)
  800f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	84 c0                	test   %al,%al
  800f76:	75 e4                	jne    800f5c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f7b:	c9                   	leave  
  800f7c:	c3                   	ret    

00800f7d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f90:	eb 1f                	jmp    800fb1 <strncpy+0x34>
		*dst++ = *src;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8d 50 01             	lea    0x1(%eax),%edx
  800f98:	89 55 08             	mov    %edx,0x8(%ebp)
  800f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9e:	8a 12                	mov    (%edx),%dl
  800fa0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	84 c0                	test   %al,%al
  800fa9:	74 03                	je     800fae <strncpy+0x31>
			src++;
  800fab:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fb7:	72 d9                	jb     800f92 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	74 30                	je     801000 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fd0:	eb 16                	jmp    800fe8 <strlcpy+0x2a>
			*dst++ = *src++;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8d 50 01             	lea    0x1(%eax),%edx
  800fd8:	89 55 08             	mov    %edx,0x8(%ebp)
  800fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fde:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fe4:	8a 12                	mov    (%edx),%dl
  800fe6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fe8:	ff 4d 10             	decl   0x10(%ebp)
  800feb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fef:	74 09                	je     800ffa <strlcpy+0x3c>
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 d8                	jne    800fd2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801006:	29 c2                	sub    %eax,%edx
  801008:	89 d0                	mov    %edx,%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80100f:	eb 06                	jmp    801017 <strcmp+0xb>
		p++, q++;
  801011:	ff 45 08             	incl   0x8(%ebp)
  801014:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	84 c0                	test   %al,%al
  80101e:	74 0e                	je     80102e <strcmp+0x22>
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 10                	mov    (%eax),%dl
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	38 c2                	cmp    %al,%dl
  80102c:	74 e3                	je     801011 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	0f b6 d0             	movzbl %al,%edx
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 c0             	movzbl %al,%eax
  80103e:	29 c2                	sub    %eax,%edx
  801040:	89 d0                	mov    %edx,%eax
}
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801047:	eb 09                	jmp    801052 <strncmp+0xe>
		n--, p++, q++;
  801049:	ff 4d 10             	decl   0x10(%ebp)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801052:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801056:	74 17                	je     80106f <strncmp+0x2b>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	74 0e                	je     80106f <strncmp+0x2b>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 10                	mov    (%eax),%dl
  801066:	8b 45 0c             	mov    0xc(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	38 c2                	cmp    %al,%dl
  80106d:	74 da                	je     801049 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80106f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801073:	75 07                	jne    80107c <strncmp+0x38>
		return 0;
  801075:	b8 00 00 00 00       	mov    $0x0,%eax
  80107a:	eb 14                	jmp    801090 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	0f b6 d0             	movzbl %al,%edx
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	0f b6 c0             	movzbl %al,%eax
  80108c:	29 c2                	sub    %eax,%edx
  80108e:	89 d0                	mov    %edx,%eax
}
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    

00801092 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80109e:	eb 12                	jmp    8010b2 <strchr+0x20>
		if (*s == c)
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010a8:	75 05                	jne    8010af <strchr+0x1d>
			return (char *) s;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	eb 11                	jmp    8010c0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010af:	ff 45 08             	incl   0x8(%ebp)
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 e5                	jne    8010a0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	83 ec 04             	sub    $0x4,%esp
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010ce:	eb 0d                	jmp    8010dd <strfind+0x1b>
		if (*s == c)
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010d8:	74 0e                	je     8010e8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010da:	ff 45 08             	incl   0x8(%ebp)
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	84 c0                	test   %al,%al
  8010e4:	75 ea                	jne    8010d0 <strfind+0xe>
  8010e6:	eb 01                	jmp    8010e9 <strfind+0x27>
		if (*s == c)
			break;
  8010e8:	90                   	nop
	return (char *) s;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8010fa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fe:	76 63                	jbe    801163 <memset+0x75>
		uint64 data_block = c;
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	99                   	cltd   
  801104:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801107:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80110a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801110:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801114:	c1 e0 08             	shl    $0x8,%eax
  801117:	09 45 f0             	or     %eax,-0x10(%ebp)
  80111a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80111d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801120:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801123:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801127:	c1 e0 10             	shl    $0x10,%eax
  80112a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80112d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801133:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801136:	89 c2                	mov    %eax,%edx
  801138:	b8 00 00 00 00       	mov    $0x0,%eax
  80113d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801140:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801143:	eb 18                	jmp    80115d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801145:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801148:	8d 41 08             	lea    0x8(%ecx),%eax
  80114b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80114e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801154:	89 01                	mov    %eax,(%ecx)
  801156:	89 51 04             	mov    %edx,0x4(%ecx)
  801159:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80115d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801161:	77 e2                	ja     801145 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801163:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801167:	74 23                	je     80118c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116f:	eb 0e                	jmp    80117f <memset+0x91>
			*p8++ = (uint8)c;
  801171:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801174:	8d 50 01             	lea    0x1(%eax),%edx
  801177:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80117a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	8d 50 ff             	lea    -0x1(%eax),%edx
  801185:	89 55 10             	mov    %edx,0x10(%ebp)
  801188:	85 c0                	test   %eax,%eax
  80118a:	75 e5                	jne    801171 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8011a3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011a7:	76 24                	jbe    8011cd <memcpy+0x3c>
		while(n >= 8){
  8011a9:	eb 1c                	jmp    8011c7 <memcpy+0x36>
			*d64 = *s64;
  8011ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ae:	8b 50 04             	mov    0x4(%eax),%edx
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b6:	89 01                	mov    %eax,(%ecx)
  8011b8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8011bb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8011bf:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8011c3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8011c7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011cb:	77 de                	ja     8011ab <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d1:	74 31                	je     801204 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8011d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8011df:	eb 16                	jmp    8011f7 <memcpy+0x66>
			*d8++ = *s8++;
  8011e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e4:	8d 50 01             	lea    0x1(%eax),%edx
  8011e7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8011ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8011f3:	8a 12                	mov    (%edx),%dl
  8011f5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8011f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011fd:	89 55 10             	mov    %edx,0x10(%ebp)
  801200:	85 c0                	test   %eax,%eax
  801202:	75 dd                	jne    8011e1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80121b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801221:	73 50                	jae    801273 <memmove+0x6a>
  801223:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	01 d0                	add    %edx,%eax
  80122b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80122e:	76 43                	jbe    801273 <memmove+0x6a>
		s += n;
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80123c:	eb 10                	jmp    80124e <memmove+0x45>
			*--d = *--s;
  80123e:	ff 4d f8             	decl   -0x8(%ebp)
  801241:	ff 4d fc             	decl   -0x4(%ebp)
  801244:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801247:	8a 10                	mov    (%eax),%dl
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	8d 50 ff             	lea    -0x1(%eax),%edx
  801254:	89 55 10             	mov    %edx,0x10(%ebp)
  801257:	85 c0                	test   %eax,%eax
  801259:	75 e3                	jne    80123e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80125b:	eb 23                	jmp    801280 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801266:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801269:	8d 4a 01             	lea    0x1(%edx),%ecx
  80126c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80126f:	8a 12                	mov    (%edx),%dl
  801271:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	8d 50 ff             	lea    -0x1(%eax),%edx
  801279:	89 55 10             	mov    %edx,0x10(%ebp)
  80127c:	85 c0                	test   %eax,%eax
  80127e:	75 dd                	jne    80125d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801297:	eb 2a                	jmp    8012c3 <memcmp+0x3e>
		if (*s1 != *s2)
  801299:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129c:	8a 10                	mov    (%eax),%dl
  80129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	38 c2                	cmp    %al,%dl
  8012a5:	74 16                	je     8012bd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	0f b6 d0             	movzbl %al,%edx
  8012af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	0f b6 c0             	movzbl %al,%eax
  8012b7:	29 c2                	sub    %eax,%edx
  8012b9:	89 d0                	mov    %edx,%eax
  8012bb:	eb 18                	jmp    8012d5 <memcmp+0x50>
		s1++, s2++;
  8012bd:	ff 45 fc             	incl   -0x4(%ebp)
  8012c0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	75 c9                	jne    801299 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 d0                	add    %edx,%eax
  8012e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012e8:	eb 15                	jmp    8012ff <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f b6 d0             	movzbl %al,%edx
  8012f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f5:	0f b6 c0             	movzbl %al,%eax
  8012f8:	39 c2                	cmp    %eax,%edx
  8012fa:	74 0d                	je     801309 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012fc:	ff 45 08             	incl   0x8(%ebp)
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801305:	72 e3                	jb     8012ea <memfind+0x13>
  801307:	eb 01                	jmp    80130a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801309:	90                   	nop
	return (void *) s;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801315:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80131c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801323:	eb 03                	jmp    801328 <strtol+0x19>
		s++;
  801325:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	3c 20                	cmp    $0x20,%al
  80132f:	74 f4                	je     801325 <strtol+0x16>
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	3c 09                	cmp    $0x9,%al
  801338:	74 eb                	je     801325 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	3c 2b                	cmp    $0x2b,%al
  801341:	75 05                	jne    801348 <strtol+0x39>
		s++;
  801343:	ff 45 08             	incl   0x8(%ebp)
  801346:	eb 13                	jmp    80135b <strtol+0x4c>
	else if (*s == '-')
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	3c 2d                	cmp    $0x2d,%al
  80134f:	75 0a                	jne    80135b <strtol+0x4c>
		s++, neg = 1;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80135b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135f:	74 06                	je     801367 <strtol+0x58>
  801361:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801365:	75 20                	jne    801387 <strtol+0x78>
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	3c 30                	cmp    $0x30,%al
  80136e:	75 17                	jne    801387 <strtol+0x78>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	40                   	inc    %eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	3c 78                	cmp    $0x78,%al
  801378:	75 0d                	jne    801387 <strtol+0x78>
		s += 2, base = 16;
  80137a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80137e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801385:	eb 28                	jmp    8013af <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801387:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138b:	75 15                	jne    8013a2 <strtol+0x93>
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	3c 30                	cmp    $0x30,%al
  801394:	75 0c                	jne    8013a2 <strtol+0x93>
		s++, base = 8;
  801396:	ff 45 08             	incl   0x8(%ebp)
  801399:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013a0:	eb 0d                	jmp    8013af <strtol+0xa0>
	else if (base == 0)
  8013a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a6:	75 07                	jne    8013af <strtol+0xa0>
		base = 10;
  8013a8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	3c 2f                	cmp    $0x2f,%al
  8013b6:	7e 19                	jle    8013d1 <strtol+0xc2>
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	3c 39                	cmp    $0x39,%al
  8013bf:	7f 10                	jg     8013d1 <strtol+0xc2>
			dig = *s - '0';
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	0f be c0             	movsbl %al,%eax
  8013c9:	83 e8 30             	sub    $0x30,%eax
  8013cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cf:	eb 42                	jmp    801413 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	3c 60                	cmp    $0x60,%al
  8013d8:	7e 19                	jle    8013f3 <strtol+0xe4>
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	3c 7a                	cmp    $0x7a,%al
  8013e1:	7f 10                	jg     8013f3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	0f be c0             	movsbl %al,%eax
  8013eb:	83 e8 57             	sub    $0x57,%eax
  8013ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013f1:	eb 20                	jmp    801413 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	3c 40                	cmp    $0x40,%al
  8013fa:	7e 39                	jle    801435 <strtol+0x126>
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	3c 5a                	cmp    $0x5a,%al
  801403:	7f 30                	jg     801435 <strtol+0x126>
			dig = *s - 'A' + 10;
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	0f be c0             	movsbl %al,%eax
  80140d:	83 e8 37             	sub    $0x37,%eax
  801410:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801416:	3b 45 10             	cmp    0x10(%ebp),%eax
  801419:	7d 19                	jge    801434 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80141b:	ff 45 08             	incl   0x8(%ebp)
  80141e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801421:	0f af 45 10          	imul   0x10(%ebp),%eax
  801425:	89 c2                	mov    %eax,%edx
  801427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80142f:	e9 7b ff ff ff       	jmp    8013af <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801434:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801435:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801439:	74 08                	je     801443 <strtol+0x134>
		*endptr = (char *) s;
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	8b 55 08             	mov    0x8(%ebp),%edx
  801441:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801443:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801447:	74 07                	je     801450 <strtol+0x141>
  801449:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144c:	f7 d8                	neg    %eax
  80144e:	eb 03                	jmp    801453 <strtol+0x144>
  801450:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <ltostr>:

void
ltostr(long value, char *str)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80145b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801462:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801469:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146d:	79 13                	jns    801482 <ltostr+0x2d>
	{
		neg = 1;
  80146f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80147c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80147f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80148a:	99                   	cltd   
  80148b:	f7 f9                	idiv   %ecx
  80148d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801493:	8d 50 01             	lea    0x1(%eax),%edx
  801496:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801499:	89 c2                	mov    %eax,%edx
  80149b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149e:	01 d0                	add    %edx,%eax
  8014a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014a3:	83 c2 30             	add    $0x30,%edx
  8014a6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ab:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014b0:	f7 e9                	imul   %ecx
  8014b2:	c1 fa 02             	sar    $0x2,%edx
  8014b5:	89 c8                	mov    %ecx,%eax
  8014b7:	c1 f8 1f             	sar    $0x1f,%eax
  8014ba:	29 c2                	sub    %eax,%edx
  8014bc:	89 d0                	mov    %edx,%eax
  8014be:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c5:	75 bb                	jne    801482 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d1:	48                   	dec    %eax
  8014d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8014d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014d9:	74 3d                	je     801518 <ltostr+0xc3>
		start = 1 ;
  8014db:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8014e2:	eb 34                	jmp    801518 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8014e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	01 c2                	add    %eax,%edx
  8014f9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	01 c8                	add    %ecx,%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801505:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	01 c2                	add    %eax,%edx
  80150d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801510:	88 02                	mov    %al,(%edx)
		start++ ;
  801512:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801515:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80151e:	7c c4                	jl     8014e4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801520:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801523:	8b 45 0c             	mov    0xc(%ebp),%eax
  801526:	01 d0                	add    %edx,%eax
  801528:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80152b:	90                   	nop
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801534:	ff 75 08             	pushl  0x8(%ebp)
  801537:	e8 c4 f9 ff ff       	call   800f00 <strlen>
  80153c:	83 c4 04             	add    $0x4,%esp
  80153f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	e8 b6 f9 ff ff       	call   800f00 <strlen>
  80154a:	83 c4 04             	add    $0x4,%esp
  80154d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801550:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801557:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155e:	eb 17                	jmp    801577 <strcconcat+0x49>
		final[s] = str1[s] ;
  801560:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801563:	8b 45 10             	mov    0x10(%ebp),%eax
  801566:	01 c2                	add    %eax,%edx
  801568:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	01 c8                	add    %ecx,%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801574:	ff 45 fc             	incl   -0x4(%ebp)
  801577:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80157d:	7c e1                	jl     801560 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80157f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801586:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80158d:	eb 1f                	jmp    8015ae <strcconcat+0x80>
		final[s++] = str2[i] ;
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801598:	89 c2                	mov    %eax,%edx
  80159a:	8b 45 10             	mov    0x10(%ebp),%eax
  80159d:	01 c2                	add    %eax,%edx
  80159f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a5:	01 c8                	add    %ecx,%eax
  8015a7:	8a 00                	mov    (%eax),%al
  8015a9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015ab:	ff 45 f8             	incl   -0x8(%ebp)
  8015ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015b4:	7c d9                	jl     80158f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bc:	01 d0                	add    %edx,%eax
  8015be:	c6 00 00             	movb   $0x0,(%eax)
}
  8015c1:	90                   	nop
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015e7:	eb 0c                	jmp    8015f5 <strsplit+0x31>
			*string++ = 0;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8d 50 01             	lea    0x1(%eax),%edx
  8015ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8015f2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 18                	je     801616 <strsplit+0x52>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	0f be c0             	movsbl %al,%eax
  801606:	50                   	push   %eax
  801607:	ff 75 0c             	pushl  0xc(%ebp)
  80160a:	e8 83 fa ff ff       	call   801092 <strchr>
  80160f:	83 c4 08             	add    $0x8,%esp
  801612:	85 c0                	test   %eax,%eax
  801614:	75 d3                	jne    8015e9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8a 00                	mov    (%eax),%al
  80161b:	84 c0                	test   %al,%al
  80161d:	74 5a                	je     801679 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80161f:	8b 45 14             	mov    0x14(%ebp),%eax
  801622:	8b 00                	mov    (%eax),%eax
  801624:	83 f8 0f             	cmp    $0xf,%eax
  801627:	75 07                	jne    801630 <strsplit+0x6c>
		{
			return 0;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
  80162e:	eb 66                	jmp    801696 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801630:	8b 45 14             	mov    0x14(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	8d 48 01             	lea    0x1(%eax),%ecx
  801638:	8b 55 14             	mov    0x14(%ebp),%edx
  80163b:	89 0a                	mov    %ecx,(%edx)
  80163d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801644:	8b 45 10             	mov    0x10(%ebp),%eax
  801647:	01 c2                	add    %eax,%edx
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80164e:	eb 03                	jmp    801653 <strsplit+0x8f>
			string++;
  801650:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8a 00                	mov    (%eax),%al
  801658:	84 c0                	test   %al,%al
  80165a:	74 8b                	je     8015e7 <strsplit+0x23>
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8a 00                	mov    (%eax),%al
  801661:	0f be c0             	movsbl %al,%eax
  801664:	50                   	push   %eax
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	e8 25 fa ff ff       	call   801092 <strchr>
  80166d:	83 c4 08             	add    $0x8,%esp
  801670:	85 c0                	test   %eax,%eax
  801672:	74 dc                	je     801650 <strsplit+0x8c>
			string++;
	}
  801674:	e9 6e ff ff ff       	jmp    8015e7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801679:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80167a:	8b 45 14             	mov    0x14(%ebp),%eax
  80167d:	8b 00                	mov    (%eax),%eax
  80167f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	01 d0                	add    %edx,%eax
  80168b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801691:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8016a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ab:	eb 4a                	jmp    8016f7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8016ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	01 c2                	add    %eax,%edx
  8016b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bb:	01 c8                	add    %ecx,%eax
  8016bd:	8a 00                	mov    (%eax),%al
  8016bf:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8016c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c7:	01 d0                	add    %edx,%eax
  8016c9:	8a 00                	mov    (%eax),%al
  8016cb:	3c 40                	cmp    $0x40,%al
  8016cd:	7e 25                	jle    8016f4 <str2lower+0x5c>
  8016cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	3c 5a                	cmp    $0x5a,%al
  8016db:	7f 17                	jg     8016f4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8016dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	01 d0                	add    %edx,%eax
  8016e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016eb:	01 ca                	add    %ecx,%edx
  8016ed:	8a 12                	mov    (%edx),%dl
  8016ef:	83 c2 20             	add    $0x20,%edx
  8016f2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8016f4:	ff 45 fc             	incl   -0x4(%ebp)
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	e8 01 f8 ff ff       	call   800f00 <strlen>
  8016ff:	83 c4 04             	add    $0x4,%esp
  801702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801705:	7f a6                	jg     8016ad <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801707:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801712:	a1 08 50 80 00       	mov    0x805008,%eax
  801717:	85 c0                	test   %eax,%eax
  801719:	74 42                	je     80175d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	68 00 00 00 82       	push   $0x82000000
  801723:	68 00 00 00 80       	push   $0x80000000
  801728:	e8 b0 1e 00 00       	call   8035dd <initialize_dynamic_allocator>
  80172d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801730:	e8 96 1c 00 00       	call   8033cb <sys_get_uheap_strategy>
  801735:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80173a:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80173f:	05 00 10 00 00       	add    $0x1000,%eax
  801744:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801749:	a1 30 51 83 00       	mov    0x835130,%eax
  80174e:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801753:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80175a:	00 00 00 
	}
}
  80175d:	90                   	nop
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	68 06 04 00 00       	push   $0x406
  80177c:	50                   	push   %eax
  80177d:	e8 93 18 00 00       	call   803015 <__sys_allocate_page>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80178c:	79 14                	jns    8017a2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	68 68 4a 80 00       	push   $0x804a68
  801796:	6a 1f                	push   $0x1f
  801798:	68 a4 4a 80 00       	push   $0x804aa4
  80179d:	e8 b7 ed ff ff       	call   800559 <_panic>
	return 0;
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017bd:	83 ec 0c             	sub    $0xc,%esp
  8017c0:	50                   	push   %eax
  8017c1:	e8 96 18 00 00       	call   80305c <__sys_unmap_frame>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017d0:	79 14                	jns    8017e6 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	68 b0 4a 80 00       	push   $0x804ab0
  8017da:	6a 2a                	push   $0x2a
  8017dc:	68 a4 4a 80 00       	push   $0x804aa4
  8017e1:	e8 73 ed ff ff       	call   800559 <_panic>
}
  8017e6:	90                   	nop
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017ef:	e8 18 ff ff ff       	call   80170c <uheap_init>
	if (size == 0) return NULL ;
  8017f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017f8:	75 0a                	jne    801804 <malloc+0x1b>
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ff:	e9 43 03 00 00       	jmp    801b47 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801804:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80180b:	77 13                	ja     801820 <malloc+0x37>
    {
        return alloc_block(size);
  80180d:	83 ec 0c             	sub    $0xc,%esp
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	e8 78 20 00 00       	call   803890 <alloc_block>
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	e9 27 03 00 00       	jmp    801b47 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801820:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801827:	8b 55 08             	mov    0x8(%ebp),%edx
  80182a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	48                   	dec    %eax
  801830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801833:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801836:	ba 00 00 00 00       	mov    $0x0,%edx
  80183b:	f7 75 dc             	divl   -0x24(%ebp)
  80183e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801841:	29 d0                	sub    %edx,%eax
  801843:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801846:	a1 40 d0 81 00       	mov    0x81d040,%eax
  80184b:	85 c0                	test   %eax,%eax
  80184d:	75 0a                	jne    801859 <malloc+0x70>
    {
        uhp_inited = 1;
  80184f:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801856:	00 00 00 
    }

    int exactIdx = -1;
  801859:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801860:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801867:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80186e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801875:	e9 85 00 00 00       	jmp    8018ff <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80187a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80187d:	89 d0                	mov    %edx,%eax
  80187f:	01 c0                	add    %eax,%eax
  801881:	01 d0                	add    %edx,%eax
  801883:	c1 e0 02             	shl    $0x2,%eax
  801886:	05 48 10 81 00       	add    $0x811048,%eax
  80188b:	8a 00                	mov    (%eax),%al
  80188d:	84 c0                	test   %al,%al
  80188f:	74 20                	je     8018b1 <malloc+0xc8>
  801891:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801894:	89 d0                	mov    %edx,%eax
  801896:	01 c0                	add    %eax,%eax
  801898:	01 d0                	add    %edx,%eax
  80189a:	c1 e0 02             	shl    $0x2,%eax
  80189d:	05 44 10 81 00       	add    $0x811044,%eax
  8018a2:	8b 00                	mov    (%eax),%eax
  8018a4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8018a7:	75 08                	jne    8018b1 <malloc+0xc8>
        {
            exactIdx = i;
  8018a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8018af:	eb 5b                	jmp    80190c <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8018b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018b4:	89 d0                	mov    %edx,%eax
  8018b6:	01 c0                	add    %eax,%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	c1 e0 02             	shl    $0x2,%eax
  8018bd:	05 48 10 81 00       	add    $0x811048,%eax
  8018c2:	8a 00                	mov    (%eax),%al
  8018c4:	84 c0                	test   %al,%al
  8018c6:	74 34                	je     8018fc <malloc+0x113>
  8018c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018cb:	89 d0                	mov    %edx,%eax
  8018cd:	01 c0                	add    %eax,%eax
  8018cf:	01 d0                	add    %edx,%eax
  8018d1:	c1 e0 02             	shl    $0x2,%eax
  8018d4:	05 44 10 81 00       	add    $0x811044,%eax
  8018d9:	8b 00                	mov    (%eax),%eax
  8018db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8018de:	76 1c                	jbe    8018fc <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8018e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018e3:	89 d0                	mov    %edx,%eax
  8018e5:	01 c0                	add    %eax,%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	c1 e0 02             	shl    $0x2,%eax
  8018ec:	05 44 10 81 00       	add    $0x811044,%eax
  8018f1:	8b 00                	mov    (%eax),%eax
  8018f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8018f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8018fc:	ff 45 e8             	incl   -0x18(%ebp)
  8018ff:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801906:	0f 8e 6e ff ff ff    	jle    80187a <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  80190c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801913:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801917:	74 7d                	je     801996 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801919:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801920:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801923:	89 d0                	mov    %edx,%eax
  801925:	01 c0                	add    %eax,%eax
  801927:	01 d0                	add    %edx,%eax
  801929:	c1 e0 02             	shl    $0x2,%eax
  80192c:	05 40 10 81 00       	add    $0x811040,%eax
  801931:	8b 10                	mov    (%eax),%edx
  801933:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801936:	01 d0                	add    %edx,%eax
  801938:	48                   	dec    %eax
  801939:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80193c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80193f:	ba 00 00 00 00       	mov    $0x0,%edx
  801944:	f7 75 bc             	divl   -0x44(%ebp)
  801947:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80194a:	29 d0                	sub    %edx,%eax
  80194c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80194f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801952:	89 d0                	mov    %edx,%eax
  801954:	01 c0                	add    %eax,%eax
  801956:	01 d0                	add    %edx,%eax
  801958:	c1 e0 02             	shl    $0x2,%eax
  80195b:	05 48 10 81 00       	add    $0x811048,%eax
  801960:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801963:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801966:	89 d0                	mov    %edx,%eax
  801968:	01 c0                	add    %eax,%eax
  80196a:	01 d0                	add    %edx,%eax
  80196c:	c1 e0 02             	shl    $0x2,%eax
  80196f:	05 44 10 81 00       	add    $0x811044,%eax
  801974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80197a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197d:	89 d0                	mov    %edx,%eax
  80197f:	01 c0                	add    %eax,%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c1 e0 02             	shl    $0x2,%eax
  801986:	05 40 10 81 00       	add    $0x811040,%eax
  80198b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801991:	e9 2d 01 00 00       	jmp    801ac3 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801996:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80199a:	0f 84 ce 00 00 00    	je     801a6e <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8019a0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8019a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019aa:	89 d0                	mov    %edx,%eax
  8019ac:	01 c0                	add    %eax,%eax
  8019ae:	01 d0                	add    %edx,%eax
  8019b0:	c1 e0 02             	shl    $0x2,%eax
  8019b3:	05 40 10 81 00       	add    $0x811040,%eax
  8019b8:	8b 10                	mov    (%eax),%edx
  8019ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019bd:	01 d0                	add    %edx,%eax
  8019bf:	48                   	dec    %eax
  8019c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8019c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cb:	f7 75 c4             	divl   -0x3c(%ebp)
  8019ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019d1:	29 d0                	sub    %edx,%eax
  8019d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8019d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d9:	89 d0                	mov    %edx,%eax
  8019db:	01 c0                	add    %eax,%eax
  8019dd:	01 d0                	add    %edx,%eax
  8019df:	c1 e0 02             	shl    $0x2,%eax
  8019e2:	05 44 10 81 00       	add    $0x811044,%eax
  8019e7:	8b 00                	mov    (%eax),%eax
  8019e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8019ec:	75 47                	jne    801a35 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8019ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019f1:	89 d0                	mov    %edx,%eax
  8019f3:	01 c0                	add    %eax,%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	c1 e0 02             	shl    $0x2,%eax
  8019fa:	05 48 10 81 00       	add    $0x811048,%eax
  8019ff:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801a02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a05:	89 d0                	mov    %edx,%eax
  801a07:	01 c0                	add    %eax,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	c1 e0 02             	shl    $0x2,%eax
  801a0e:	05 44 10 81 00       	add    $0x811044,%eax
  801a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801a19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a1c:	89 d0                	mov    %edx,%eax
  801a1e:	01 c0                	add    %eax,%eax
  801a20:	01 d0                	add    %edx,%eax
  801a22:	c1 e0 02             	shl    $0x2,%eax
  801a25:	05 40 10 81 00       	add    $0x811040,%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a30:	e9 8e 00 00 00       	jmp    801ac3 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801a35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a3b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801a3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a41:	89 d0                	mov    %edx,%eax
  801a43:	01 c0                	add    %eax,%eax
  801a45:	01 d0                	add    %edx,%eax
  801a47:	c1 e0 02             	shl    $0x2,%eax
  801a4a:	05 40 10 81 00       	add    $0x811040,%eax
  801a4f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a54:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801a57:	89 c2                	mov    %eax,%edx
  801a59:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a5c:	89 c8                	mov    %ecx,%eax
  801a5e:	01 c0                	add    %eax,%eax
  801a60:	01 c8                	add    %ecx,%eax
  801a62:	c1 e0 02             	shl    $0x2,%eax
  801a65:	05 44 10 81 00       	add    $0x811044,%eax
  801a6a:	89 10                	mov    %edx,(%eax)
  801a6c:	eb 55                	jmp    801ac3 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801a6e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801a75:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801a7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a7e:	01 d0                	add    %edx,%eax
  801a80:	48                   	dec    %eax
  801a81:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801a84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	f7 75 d0             	divl   -0x30(%ebp)
  801a8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a92:	29 d0                	sub    %edx,%eax
  801a94:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801a97:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801a9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a9d:	01 d0                	add    %edx,%eax
  801a9f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801aa4:	76 0a                	jbe    801ab0 <malloc+0x2c7>
            return NULL;
  801aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801aab:	e9 97 00 00 00       	jmp    801b47 <malloc+0x35e>
        va = start;
  801ab0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ab3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801ab6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ab9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801abc:	01 d0                	add    %edx,%eax
  801abe:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ac3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801aca:	eb 5e                	jmp    801b2a <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801acc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801acf:	89 d0                	mov    %edx,%eax
  801ad1:	01 c0                	add    %eax,%eax
  801ad3:	01 d0                	add    %edx,%eax
  801ad5:	c1 e0 02             	shl    $0x2,%eax
  801ad8:	05 48 50 80 00       	add    $0x805048,%eax
  801add:	8a 00                	mov    (%eax),%al
  801adf:	84 c0                	test   %al,%al
  801ae1:	75 44                	jne    801b27 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801ae3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae6:	89 d0                	mov    %edx,%eax
  801ae8:	01 c0                	add    %eax,%eax
  801aea:	01 d0                	add    %edx,%eax
  801aec:	c1 e0 02             	shl    $0x2,%eax
  801aef:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801af8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801afa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801afd:	89 d0                	mov    %edx,%eax
  801aff:	01 c0                	add    %eax,%eax
  801b01:	01 d0                	add    %edx,%eax
  801b03:	c1 e0 02             	shl    $0x2,%eax
  801b06:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801b0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b0f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801b11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b14:	89 d0                	mov    %edx,%eax
  801b16:	01 c0                	add    %eax,%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	c1 e0 02             	shl    $0x2,%eax
  801b1d:	05 48 50 80 00       	add    $0x805048,%eax
  801b22:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801b25:	eb 0c                	jmp    801b33 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b27:	ff 45 e0             	incl   -0x20(%ebp)
  801b2a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801b31:	7e 99                	jle    801acc <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801b33:	83 ec 08             	sub    $0x8,%esp
  801b36:	ff 75 d4             	pushl  -0x2c(%ebp)
  801b39:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b3c:	e8 a2 19 00 00       	call   8034e3 <sys_allocate_user_mem>
  801b41:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801b44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801b4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b53:	0f 84 fa 03 00 00    	je     801f53 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801b5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b62:	85 c0                	test   %eax,%eax
  801b64:	79 1c                	jns    801b82 <free+0x39>
  801b66:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801b6d:	77 13                	ja     801b82 <free+0x39>
    {
        free_block(virtual_address);
  801b6f:	83 ec 0c             	sub    $0xc,%esp
  801b72:	ff 75 08             	pushl  0x8(%ebp)
  801b75:	e8 09 21 00 00       	call   803c83 <free_block>
  801b7a:	83 c4 10             	add    $0x10,%esp
        return;
  801b7d:	e9 d2 03 00 00       	jmp    801f54 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801b82:	a1 30 51 83 00       	mov    0x835130,%eax
  801b87:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801b8a:	72 09                	jb     801b95 <free+0x4c>
  801b8c:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801b93:	76 17                	jbe    801bac <free+0x63>
        panic("free: invalid address");
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 ed 4a 80 00       	push   $0x804aed
  801b9d:	68 9b 00 00 00       	push   $0x9b
  801ba2:	68 a4 4a 80 00       	push   $0x804aa4
  801ba7:	e8 ad e9 ff ff       	call   800559 <_panic>

    uint32 size = 0;
  801bac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801bb3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801bba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801bc1:	eb 50                	jmp    801c13 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801bc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bc6:	89 d0                	mov    %edx,%eax
  801bc8:	01 c0                	add    %eax,%eax
  801bca:	01 d0                	add    %edx,%eax
  801bcc:	c1 e0 02             	shl    $0x2,%eax
  801bcf:	05 48 50 80 00       	add    $0x805048,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	84 c0                	test   %al,%al
  801bd8:	74 36                	je     801c10 <free+0xc7>
  801bda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bdd:	89 d0                	mov    %edx,%eax
  801bdf:	01 c0                	add    %eax,%eax
  801be1:	01 d0                	add    %edx,%eax
  801be3:	c1 e0 02             	shl    $0x2,%eax
  801be6:	05 40 50 80 00       	add    $0x805040,%eax
  801beb:	8b 00                	mov    (%eax),%eax
  801bed:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801bf0:	75 1e                	jne    801c10 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801bf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bf5:	89 d0                	mov    %edx,%eax
  801bf7:	01 c0                	add    %eax,%eax
  801bf9:	01 d0                	add    %edx,%eax
  801bfb:	c1 e0 02             	shl    $0x2,%eax
  801bfe:	05 44 50 80 00       	add    $0x805044,%eax
  801c03:	8b 00                	mov    (%eax),%eax
  801c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801c0e:	eb 0c                	jmp    801c1c <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c10:	ff 45 ec             	incl   -0x14(%ebp)
  801c13:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801c1a:	7e a7                	jle    801bc3 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801c1c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c20:	74 06                	je     801c28 <free+0xdf>
  801c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c26:	75 17                	jne    801c3f <free+0xf6>
        panic("free: unknown block");
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	68 03 4b 80 00       	push   $0x804b03
  801c30:	68 a9 00 00 00       	push   $0xa9
  801c35:	68 a4 4a 80 00       	push   $0x804aa4
  801c3a:	e8 1a e9 ff ff       	call   800559 <_panic>

    uhp_allocs[idx].used = 0;
  801c3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c42:	89 d0                	mov    %edx,%eax
  801c44:	01 c0                	add    %eax,%eax
  801c46:	01 d0                	add    %edx,%eax
  801c48:	c1 e0 02             	shl    $0x2,%eax
  801c4b:	05 48 50 80 00       	add    $0x805048,%eax
  801c50:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801c53:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801c61:	eb 64                	jmp    801cc7 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801c63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c66:	89 d0                	mov    %edx,%eax
  801c68:	01 c0                	add    %eax,%eax
  801c6a:	01 d0                	add    %edx,%eax
  801c6c:	c1 e0 02             	shl    $0x2,%eax
  801c6f:	05 48 10 81 00       	add    $0x811048,%eax
  801c74:	8a 00                	mov    (%eax),%al
  801c76:	84 c0                	test   %al,%al
  801c78:	75 4a                	jne    801cc4 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c7d:	89 d0                	mov    %edx,%eax
  801c7f:	01 c0                	add    %eax,%eax
  801c81:	01 d0                	add    %edx,%eax
  801c83:	c1 e0 02             	shl    $0x2,%eax
  801c86:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801c8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c8f:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801c91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c94:	89 d0                	mov    %edx,%eax
  801c96:	01 c0                	add    %eax,%eax
  801c98:	01 d0                	add    %edx,%eax
  801c9a:	c1 e0 02             	shl    $0x2,%eax
  801c9d:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca6:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801ca8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cab:	89 d0                	mov    %edx,%eax
  801cad:	01 c0                	add    %eax,%eax
  801caf:	01 d0                	add    %edx,%eax
  801cb1:	c1 e0 02             	shl    $0x2,%eax
  801cb4:	05 48 10 81 00       	add    $0x811048,%eax
  801cb9:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801cc2:	eb 0c                	jmp    801cd0 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cc4:	ff 45 e4             	incl   -0x1c(%ebp)
  801cc7:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801cce:	7e 93                	jle    801c63 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801cd0:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801cd4:	0f 84 f1 01 00 00    	je     801ecb <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cda:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ce1:	e9 d8 01 00 00       	jmp    801ebe <free+0x375>
        {
            if (i == fidx) continue;
  801ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801cec:	0f 84 c8 01 00 00    	je     801eba <free+0x371>
            if (uhp_frees[i].free)
  801cf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf5:	89 d0                	mov    %edx,%eax
  801cf7:	01 c0                	add    %eax,%eax
  801cf9:	01 d0                	add    %edx,%eax
  801cfb:	c1 e0 02             	shl    $0x2,%eax
  801cfe:	05 48 10 81 00       	add    $0x811048,%eax
  801d03:	8a 00                	mov    (%eax),%al
  801d05:	84 c0                	test   %al,%al
  801d07:	0f 84 ae 01 00 00    	je     801ebb <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801d0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d10:	89 d0                	mov    %edx,%eax
  801d12:	01 c0                	add    %eax,%eax
  801d14:	01 d0                	add    %edx,%eax
  801d16:	c1 e0 02             	shl    $0x2,%eax
  801d19:	05 40 10 81 00       	add    $0x811040,%eax
  801d1e:	8b 08                	mov    (%eax),%ecx
  801d20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	01 d0                	add    %edx,%eax
  801d29:	c1 e0 02             	shl    $0x2,%eax
  801d2c:	05 44 10 81 00       	add    $0x811044,%eax
  801d31:	8b 00                	mov    (%eax),%eax
  801d33:	01 c1                	add    %eax,%ecx
  801d35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d38:	89 d0                	mov    %edx,%eax
  801d3a:	01 c0                	add    %eax,%eax
  801d3c:	01 d0                	add    %edx,%eax
  801d3e:	c1 e0 02             	shl    $0x2,%eax
  801d41:	05 40 10 81 00       	add    $0x811040,%eax
  801d46:	8b 00                	mov    (%eax),%eax
  801d48:	39 c1                	cmp    %eax,%ecx
  801d4a:	0f 85 a8 00 00 00    	jne    801df8 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801d50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d53:	89 d0                	mov    %edx,%eax
  801d55:	01 c0                	add    %eax,%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c1 e0 02             	shl    $0x2,%eax
  801d5c:	05 40 10 81 00       	add    $0x811040,%eax
  801d61:	8b 10                	mov    (%eax),%edx
  801d63:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801d66:	89 c8                	mov    %ecx,%eax
  801d68:	01 c0                	add    %eax,%eax
  801d6a:	01 c8                	add    %ecx,%eax
  801d6c:	c1 e0 02             	shl    $0x2,%eax
  801d6f:	05 40 10 81 00       	add    $0x811040,%eax
  801d74:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d79:	89 d0                	mov    %edx,%eax
  801d7b:	01 c0                	add    %eax,%eax
  801d7d:	01 d0                	add    %edx,%eax
  801d7f:	c1 e0 02             	shl    $0x2,%eax
  801d82:	05 44 10 81 00       	add    $0x811044,%eax
  801d87:	8b 08                	mov    (%eax),%ecx
  801d89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d8c:	89 d0                	mov    %edx,%eax
  801d8e:	01 c0                	add    %eax,%eax
  801d90:	01 d0                	add    %edx,%eax
  801d92:	c1 e0 02             	shl    $0x2,%eax
  801d95:	05 44 10 81 00       	add    $0x811044,%eax
  801d9a:	8b 00                	mov    (%eax),%eax
  801d9c:	01 c1                	add    %eax,%ecx
  801d9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801da1:	89 d0                	mov    %edx,%eax
  801da3:	01 c0                	add    %eax,%eax
  801da5:	01 d0                	add    %edx,%eax
  801da7:	c1 e0 02             	shl    $0x2,%eax
  801daa:	05 44 10 81 00       	add    $0x811044,%eax
  801daf:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801db1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db4:	89 d0                	mov    %edx,%eax
  801db6:	01 c0                	add    %eax,%eax
  801db8:	01 d0                	add    %edx,%eax
  801dba:	c1 e0 02             	shl    $0x2,%eax
  801dbd:	05 48 10 81 00       	add    $0x811048,%eax
  801dc2:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801dc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc8:	89 d0                	mov    %edx,%eax
  801dca:	01 c0                	add    %eax,%eax
  801dcc:	01 d0                	add    %edx,%eax
  801dce:	c1 e0 02             	shl    $0x2,%eax
  801dd1:	05 40 10 81 00       	add    $0x811040,%eax
  801dd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801ddc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ddf:	89 d0                	mov    %edx,%eax
  801de1:	01 c0                	add    %eax,%eax
  801de3:	01 d0                	add    %edx,%eax
  801de5:	c1 e0 02             	shl    $0x2,%eax
  801de8:	05 44 10 81 00       	add    $0x811044,%eax
  801ded:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801df3:	e9 c3 00 00 00       	jmp    801ebb <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801df8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dfb:	89 d0                	mov    %edx,%eax
  801dfd:	01 c0                	add    %eax,%eax
  801dff:	01 d0                	add    %edx,%eax
  801e01:	c1 e0 02             	shl    $0x2,%eax
  801e04:	05 40 10 81 00       	add    $0x811040,%eax
  801e09:	8b 08                	mov    (%eax),%ecx
  801e0b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	01 c0                	add    %eax,%eax
  801e12:	01 d0                	add    %edx,%eax
  801e14:	c1 e0 02             	shl    $0x2,%eax
  801e17:	05 44 10 81 00       	add    $0x811044,%eax
  801e1c:	8b 00                	mov    (%eax),%eax
  801e1e:	01 c1                	add    %eax,%ecx
  801e20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e23:	89 d0                	mov    %edx,%eax
  801e25:	01 c0                	add    %eax,%eax
  801e27:	01 d0                	add    %edx,%eax
  801e29:	c1 e0 02             	shl    $0x2,%eax
  801e2c:	05 40 10 81 00       	add    $0x811040,%eax
  801e31:	8b 00                	mov    (%eax),%eax
  801e33:	39 c1                	cmp    %eax,%ecx
  801e35:	0f 85 80 00 00 00    	jne    801ebb <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801e3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e3e:	89 d0                	mov    %edx,%eax
  801e40:	01 c0                	add    %eax,%eax
  801e42:	01 d0                	add    %edx,%eax
  801e44:	c1 e0 02             	shl    $0x2,%eax
  801e47:	05 44 10 81 00       	add    $0x811044,%eax
  801e4c:	8b 08                	mov    (%eax),%ecx
  801e4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e51:	89 d0                	mov    %edx,%eax
  801e53:	01 c0                	add    %eax,%eax
  801e55:	01 d0                	add    %edx,%eax
  801e57:	c1 e0 02             	shl    $0x2,%eax
  801e5a:	05 44 10 81 00       	add    $0x811044,%eax
  801e5f:	8b 00                	mov    (%eax),%eax
  801e61:	01 c1                	add    %eax,%ecx
  801e63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e66:	89 d0                	mov    %edx,%eax
  801e68:	01 c0                	add    %eax,%eax
  801e6a:	01 d0                	add    %edx,%eax
  801e6c:	c1 e0 02             	shl    $0x2,%eax
  801e6f:	05 44 10 81 00       	add    $0x811044,%eax
  801e74:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801e76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e79:	89 d0                	mov    %edx,%eax
  801e7b:	01 c0                	add    %eax,%eax
  801e7d:	01 d0                	add    %edx,%eax
  801e7f:	c1 e0 02             	shl    $0x2,%eax
  801e82:	05 48 10 81 00       	add    $0x811048,%eax
  801e87:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801e8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e8d:	89 d0                	mov    %edx,%eax
  801e8f:	01 c0                	add    %eax,%eax
  801e91:	01 d0                	add    %edx,%eax
  801e93:	c1 e0 02             	shl    $0x2,%eax
  801e96:	05 40 10 81 00       	add    $0x811040,%eax
  801e9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801ea1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ea4:	89 d0                	mov    %edx,%eax
  801ea6:	01 c0                	add    %eax,%eax
  801ea8:	01 d0                	add    %edx,%eax
  801eaa:	c1 e0 02             	shl    $0x2,%eax
  801ead:	05 44 10 81 00       	add    $0x811044,%eax
  801eb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eb8:	eb 01                	jmp    801ebb <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801eba:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ebb:	ff 45 e0             	incl   -0x20(%ebp)
  801ebe:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801ec5:	0f 8e 1b fe ff ff    	jle    801ce6 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801ecb:	a1 30 51 83 00       	mov    0x835130,%eax
  801ed0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ed3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801eda:	eb 53                	jmp    801f2f <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801edc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801edf:	89 d0                	mov    %edx,%eax
  801ee1:	01 c0                	add    %eax,%eax
  801ee3:	01 d0                	add    %edx,%eax
  801ee5:	c1 e0 02             	shl    $0x2,%eax
  801ee8:	05 48 50 80 00       	add    $0x805048,%eax
  801eed:	8a 00                	mov    (%eax),%al
  801eef:	84 c0                	test   %al,%al
  801ef1:	74 39                	je     801f2c <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801ef3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ef6:	89 d0                	mov    %edx,%eax
  801ef8:	01 c0                	add    %eax,%eax
  801efa:	01 d0                	add    %edx,%eax
  801efc:	c1 e0 02             	shl    $0x2,%eax
  801eff:	05 40 50 80 00       	add    $0x805040,%eax
  801f04:	8b 08                	mov    (%eax),%ecx
  801f06:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f09:	89 d0                	mov    %edx,%eax
  801f0b:	01 c0                	add    %eax,%eax
  801f0d:	01 d0                	add    %edx,%eax
  801f0f:	c1 e0 02             	shl    $0x2,%eax
  801f12:	05 44 50 80 00       	add    $0x805044,%eax
  801f17:	8b 00                	mov    (%eax),%eax
  801f19:	01 c8                	add    %ecx,%eax
  801f1b:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801f1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f21:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f24:	76 06                	jbe    801f2c <free+0x3e3>
  801f26:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f29:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f2c:	ff 45 d8             	incl   -0x28(%ebp)
  801f2f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801f36:	7e a4                	jle    801edc <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801f38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f3b:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801f40:	83 ec 08             	sub    $0x8,%esp
  801f43:	ff 75 f4             	pushl  -0xc(%ebp)
  801f46:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f49:	e8 79 15 00 00       	call   8034c7 <sys_free_user_mem>
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	eb 01                	jmp    801f54 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801f53:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 68             	sub    $0x68,%esp
  801f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5f:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f62:	e8 a5 f7 ff ff       	call   80170c <uheap_init>
	if (size == 0) return NULL ;
  801f67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f6b:	75 0a                	jne    801f77 <smalloc+0x21>
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	e9 37 03 00 00       	jmp    8022ae <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801f77:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f84:	01 d0                	add    %edx,%eax
  801f86:	48                   	dec    %eax
  801f87:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f92:	f7 75 dc             	divl   -0x24(%ebp)
  801f95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f98:	29 d0                	sub    %edx,%eax
  801f9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801f9d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801fa4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801fab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801fb2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801fb9:	e9 85 00 00 00       	jmp    802043 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801fbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fc1:	89 d0                	mov    %edx,%eax
  801fc3:	01 c0                	add    %eax,%eax
  801fc5:	01 d0                	add    %edx,%eax
  801fc7:	c1 e0 02             	shl    $0x2,%eax
  801fca:	05 48 10 81 00       	add    $0x811048,%eax
  801fcf:	8a 00                	mov    (%eax),%al
  801fd1:	84 c0                	test   %al,%al
  801fd3:	74 20                	je     801ff5 <smalloc+0x9f>
  801fd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fd8:	89 d0                	mov    %edx,%eax
  801fda:	01 c0                	add    %eax,%eax
  801fdc:	01 d0                	add    %edx,%eax
  801fde:	c1 e0 02             	shl    $0x2,%eax
  801fe1:	05 44 10 81 00       	add    $0x811044,%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801feb:	75 08                	jne    801ff5 <smalloc+0x9f>
        {
            exactIdx = i;
  801fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801ff3:	eb 5b                	jmp    802050 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801ff5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ff8:	89 d0                	mov    %edx,%eax
  801ffa:	01 c0                	add    %eax,%eax
  801ffc:	01 d0                	add    %edx,%eax
  801ffe:	c1 e0 02             	shl    $0x2,%eax
  802001:	05 48 10 81 00       	add    $0x811048,%eax
  802006:	8a 00                	mov    (%eax),%al
  802008:	84 c0                	test   %al,%al
  80200a:	74 34                	je     802040 <smalloc+0xea>
  80200c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80200f:	89 d0                	mov    %edx,%eax
  802011:	01 c0                	add    %eax,%eax
  802013:	01 d0                	add    %edx,%eax
  802015:	c1 e0 02             	shl    $0x2,%eax
  802018:	05 44 10 81 00       	add    $0x811044,%eax
  80201d:	8b 00                	mov    (%eax),%eax
  80201f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802022:	76 1c                	jbe    802040 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802024:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802027:	89 d0                	mov    %edx,%eax
  802029:	01 c0                	add    %eax,%eax
  80202b:	01 d0                	add    %edx,%eax
  80202d:	c1 e0 02             	shl    $0x2,%eax
  802030:	05 44 10 81 00       	add    $0x811044,%eax
  802035:	8b 00                	mov    (%eax),%eax
  802037:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80203a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80203d:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802040:	ff 45 e8             	incl   -0x18(%ebp)
  802043:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80204a:	0f 8e 6e ff ff ff    	jle    801fbe <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802050:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802057:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80205b:	74 7d                	je     8020da <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80205d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802067:	89 d0                	mov    %edx,%eax
  802069:	01 c0                	add    %eax,%eax
  80206b:	01 d0                	add    %edx,%eax
  80206d:	c1 e0 02             	shl    $0x2,%eax
  802070:	05 40 10 81 00       	add    $0x811040,%eax
  802075:	8b 10                	mov    (%eax),%edx
  802077:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80207a:	01 d0                	add    %edx,%eax
  80207c:	48                   	dec    %eax
  80207d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802080:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802083:	ba 00 00 00 00       	mov    $0x0,%edx
  802088:	f7 75 bc             	divl   -0x44(%ebp)
  80208b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80208e:	29 d0                	sub    %edx,%eax
  802090:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802096:	89 d0                	mov    %edx,%eax
  802098:	01 c0                	add    %eax,%eax
  80209a:	01 d0                	add    %edx,%eax
  80209c:	c1 e0 02             	shl    $0x2,%eax
  80209f:	05 48 10 81 00       	add    $0x811048,%eax
  8020a4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8020a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020aa:	89 d0                	mov    %edx,%eax
  8020ac:	01 c0                	add    %eax,%eax
  8020ae:	01 d0                	add    %edx,%eax
  8020b0:	c1 e0 02             	shl    $0x2,%eax
  8020b3:	05 44 10 81 00       	add    $0x811044,%eax
  8020b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8020be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c1:	89 d0                	mov    %edx,%eax
  8020c3:	01 c0                	add    %eax,%eax
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	c1 e0 02             	shl    $0x2,%eax
  8020ca:	05 40 10 81 00       	add    $0x811040,%eax
  8020cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020d5:	e9 2d 01 00 00       	jmp    802207 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8020da:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020de:	0f 84 ce 00 00 00    	je     8021b2 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8020e4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8020eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ee:	89 d0                	mov    %edx,%eax
  8020f0:	01 c0                	add    %eax,%eax
  8020f2:	01 d0                	add    %edx,%eax
  8020f4:	c1 e0 02             	shl    $0x2,%eax
  8020f7:	05 40 10 81 00       	add    $0x811040,%eax
  8020fc:	8b 10                	mov    (%eax),%edx
  8020fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802101:	01 d0                	add    %edx,%eax
  802103:	48                   	dec    %eax
  802104:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802107:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80210a:	ba 00 00 00 00       	mov    $0x0,%edx
  80210f:	f7 75 c4             	divl   -0x3c(%ebp)
  802112:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802115:	29 d0                	sub    %edx,%eax
  802117:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80211a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80211d:	89 d0                	mov    %edx,%eax
  80211f:	01 c0                	add    %eax,%eax
  802121:	01 d0                	add    %edx,%eax
  802123:	c1 e0 02             	shl    $0x2,%eax
  802126:	05 44 10 81 00       	add    $0x811044,%eax
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802130:	75 47                	jne    802179 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802132:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802135:	89 d0                	mov    %edx,%eax
  802137:	01 c0                	add    %eax,%eax
  802139:	01 d0                	add    %edx,%eax
  80213b:	c1 e0 02             	shl    $0x2,%eax
  80213e:	05 48 10 81 00       	add    $0x811048,%eax
  802143:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802146:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802149:	89 d0                	mov    %edx,%eax
  80214b:	01 c0                	add    %eax,%eax
  80214d:	01 d0                	add    %edx,%eax
  80214f:	c1 e0 02             	shl    $0x2,%eax
  802152:	05 44 10 81 00       	add    $0x811044,%eax
  802157:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80215d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802160:	89 d0                	mov    %edx,%eax
  802162:	01 c0                	add    %eax,%eax
  802164:	01 d0                	add    %edx,%eax
  802166:	c1 e0 02             	shl    $0x2,%eax
  802169:	05 40 10 81 00       	add    $0x811040,%eax
  80216e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802174:	e9 8e 00 00 00       	jmp    802207 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802179:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80217c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80217f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802182:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802185:	89 d0                	mov    %edx,%eax
  802187:	01 c0                	add    %eax,%eax
  802189:	01 d0                	add    %edx,%eax
  80218b:	c1 e0 02             	shl    $0x2,%eax
  80218e:	05 40 10 81 00       	add    $0x811040,%eax
  802193:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802198:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80219b:	89 c2                	mov    %eax,%edx
  80219d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8021a0:	89 c8                	mov    %ecx,%eax
  8021a2:	01 c0                	add    %eax,%eax
  8021a4:	01 c8                	add    %ecx,%eax
  8021a6:	c1 e0 02             	shl    $0x2,%eax
  8021a9:	05 44 10 81 00       	add    $0x811044,%eax
  8021ae:	89 10                	mov    %edx,(%eax)
  8021b0:	eb 55                	jmp    802207 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8021b2:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8021b9:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8021bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021c2:	01 d0                	add    %edx,%eax
  8021c4:	48                   	dec    %eax
  8021c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8021c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d0:	f7 75 d0             	divl   -0x30(%ebp)
  8021d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021d6:	29 d0                	sub    %edx,%eax
  8021d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8021db:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8021de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e1:	01 d0                	add    %edx,%eax
  8021e3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8021e8:	76 0a                	jbe    8021f4 <smalloc+0x29e>
            return NULL;
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ef:	e9 ba 00 00 00       	jmp    8022ae <smalloc+0x358>
        va = start;
  8021f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8021f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8021fa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8021fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802200:	01 d0                	add    %edx,%eax
  802202:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802207:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80220e:	eb 5e                	jmp    80226e <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802210:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802213:	89 d0                	mov    %edx,%eax
  802215:	01 c0                	add    %eax,%eax
  802217:	01 d0                	add    %edx,%eax
  802219:	c1 e0 02             	shl    $0x2,%eax
  80221c:	05 48 50 80 00       	add    $0x805048,%eax
  802221:	8a 00                	mov    (%eax),%al
  802223:	84 c0                	test   %al,%al
  802225:	75 44                	jne    80226b <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802227:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	01 c0                	add    %eax,%eax
  80222e:	01 d0                	add    %edx,%eax
  802230:	c1 e0 02             	shl    $0x2,%eax
  802233:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80223c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80223e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802241:	89 d0                	mov    %edx,%eax
  802243:	01 c0                	add    %eax,%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	c1 e0 02             	shl    $0x2,%eax
  80224a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802250:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802253:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802255:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802258:	89 d0                	mov    %edx,%eax
  80225a:	01 c0                	add    %eax,%eax
  80225c:	01 d0                	add    %edx,%eax
  80225e:	c1 e0 02             	shl    $0x2,%eax
  802261:	05 48 50 80 00       	add    $0x805048,%eax
  802266:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802269:	eb 0c                	jmp    802277 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80226b:	ff 45 e0             	incl   -0x20(%ebp)
  80226e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802275:	7e 99                	jle    802210 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802277:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80227a:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80227e:	52                   	push   %edx
  80227f:	50                   	push   %eax
  802280:	ff 75 d4             	pushl  -0x2c(%ebp)
  802283:	ff 75 08             	pushl  0x8(%ebp)
  802286:	e8 de 0e 00 00       	call   803169 <sys_create_shared_object>
  80228b:	83 c4 10             	add    $0x10,%esp
  80228e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802291:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802295:	75 07                	jne    80229e <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802297:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80229c:	eb 10                	jmp    8022ae <smalloc+0x358>
    if (r < 0)
  80229e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8022a2:	79 07                	jns    8022ab <smalloc+0x355>
        return NULL;
  8022a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a9:	eb 03                	jmp    8022ae <smalloc+0x358>
    return (void*)va;
  8022ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8022b6:	e8 51 f4 ff ff       	call   80170c <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8022bb:	83 ec 08             	sub    $0x8,%esp
  8022be:	ff 75 0c             	pushl  0xc(%ebp)
  8022c1:	ff 75 08             	pushl  0x8(%ebp)
  8022c4:	e8 ca 0e 00 00       	call   803193 <sys_size_of_shared_object>
  8022c9:	83 c4 10             	add    $0x10,%esp
  8022cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8022cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8022d3:	7f 0a                	jg     8022df <sget+0x2f>
        return NULL;
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	e9 28 03 00 00       	jmp    802607 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8022df:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8022e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8022e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022ec:	01 d0                	add    %edx,%eax
  8022ee:	48                   	dec    %eax
  8022ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8022f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8022fa:	f7 75 d8             	divl   -0x28(%ebp)
  8022fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802300:	29 d0                	sub    %edx,%eax
  802302:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802305:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80230c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802313:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80231a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802321:	e9 85 00 00 00       	jmp    8023ab <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802326:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802329:	89 d0                	mov    %edx,%eax
  80232b:	01 c0                	add    %eax,%eax
  80232d:	01 d0                	add    %edx,%eax
  80232f:	c1 e0 02             	shl    $0x2,%eax
  802332:	05 48 10 81 00       	add    $0x811048,%eax
  802337:	8a 00                	mov    (%eax),%al
  802339:	84 c0                	test   %al,%al
  80233b:	74 20                	je     80235d <sget+0xad>
  80233d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802340:	89 d0                	mov    %edx,%eax
  802342:	01 c0                	add    %eax,%eax
  802344:	01 d0                	add    %edx,%eax
  802346:	c1 e0 02             	shl    $0x2,%eax
  802349:	05 44 10 81 00       	add    $0x811044,%eax
  80234e:	8b 00                	mov    (%eax),%eax
  802350:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802353:	75 08                	jne    80235d <sget+0xad>
        {
            exactIdx = i;
  802355:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802358:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80235b:	eb 5b                	jmp    8023b8 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80235d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802360:	89 d0                	mov    %edx,%eax
  802362:	01 c0                	add    %eax,%eax
  802364:	01 d0                	add    %edx,%eax
  802366:	c1 e0 02             	shl    $0x2,%eax
  802369:	05 48 10 81 00       	add    $0x811048,%eax
  80236e:	8a 00                	mov    (%eax),%al
  802370:	84 c0                	test   %al,%al
  802372:	74 34                	je     8023a8 <sget+0xf8>
  802374:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802377:	89 d0                	mov    %edx,%eax
  802379:	01 c0                	add    %eax,%eax
  80237b:	01 d0                	add    %edx,%eax
  80237d:	c1 e0 02             	shl    $0x2,%eax
  802380:	05 44 10 81 00       	add    $0x811044,%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80238a:	76 1c                	jbe    8023a8 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80238c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80238f:	89 d0                	mov    %edx,%eax
  802391:	01 c0                	add    %eax,%eax
  802393:	01 d0                	add    %edx,%eax
  802395:	c1 e0 02             	shl    $0x2,%eax
  802398:	05 44 10 81 00       	add    $0x811044,%eax
  80239d:	8b 00                	mov    (%eax),%eax
  80239f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8023a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8023a8:	ff 45 e8             	incl   -0x18(%ebp)
  8023ab:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8023b2:	0f 8e 6e ff ff ff    	jle    802326 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8023b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8023bf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8023c3:	74 7d                	je     802442 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8023c5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8023cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cf:	89 d0                	mov    %edx,%eax
  8023d1:	01 c0                	add    %eax,%eax
  8023d3:	01 d0                	add    %edx,%eax
  8023d5:	c1 e0 02             	shl    $0x2,%eax
  8023d8:	05 40 10 81 00       	add    $0x811040,%eax
  8023dd:	8b 10                	mov    (%eax),%edx
  8023df:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023e2:	01 d0                	add    %edx,%eax
  8023e4:	48                   	dec    %eax
  8023e5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8023e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8023eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f0:	f7 75 b8             	divl   -0x48(%ebp)
  8023f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8023f6:	29 d0                	sub    %edx,%eax
  8023f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8023fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fe:	89 d0                	mov    %edx,%eax
  802400:	01 c0                	add    %eax,%eax
  802402:	01 d0                	add    %edx,%eax
  802404:	c1 e0 02             	shl    $0x2,%eax
  802407:	05 48 10 81 00       	add    $0x811048,%eax
  80240c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80240f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802412:	89 d0                	mov    %edx,%eax
  802414:	01 c0                	add    %eax,%eax
  802416:	01 d0                	add    %edx,%eax
  802418:	c1 e0 02             	shl    $0x2,%eax
  80241b:	05 44 10 81 00       	add    $0x811044,%eax
  802420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802429:	89 d0                	mov    %edx,%eax
  80242b:	01 c0                	add    %eax,%eax
  80242d:	01 d0                	add    %edx,%eax
  80242f:	c1 e0 02             	shl    $0x2,%eax
  802432:	05 40 10 81 00       	add    $0x811040,%eax
  802437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80243d:	e9 2d 01 00 00       	jmp    80256f <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802442:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802446:	0f 84 ce 00 00 00    	je     80251a <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80244c:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802453:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802456:	89 d0                	mov    %edx,%eax
  802458:	01 c0                	add    %eax,%eax
  80245a:	01 d0                	add    %edx,%eax
  80245c:	c1 e0 02             	shl    $0x2,%eax
  80245f:	05 40 10 81 00       	add    $0x811040,%eax
  802464:	8b 10                	mov    (%eax),%edx
  802466:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802469:	01 d0                	add    %edx,%eax
  80246b:	48                   	dec    %eax
  80246c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80246f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802472:	ba 00 00 00 00       	mov    $0x0,%edx
  802477:	f7 75 c0             	divl   -0x40(%ebp)
  80247a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80247d:	29 d0                	sub    %edx,%eax
  80247f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802482:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802485:	89 d0                	mov    %edx,%eax
  802487:	01 c0                	add    %eax,%eax
  802489:	01 d0                	add    %edx,%eax
  80248b:	c1 e0 02             	shl    $0x2,%eax
  80248e:	05 44 10 81 00       	add    $0x811044,%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802498:	75 47                	jne    8024e1 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80249a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80249d:	89 d0                	mov    %edx,%eax
  80249f:	01 c0                	add    %eax,%eax
  8024a1:	01 d0                	add    %edx,%eax
  8024a3:	c1 e0 02             	shl    $0x2,%eax
  8024a6:	05 48 10 81 00       	add    $0x811048,%eax
  8024ab:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8024ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b1:	89 d0                	mov    %edx,%eax
  8024b3:	01 c0                	add    %eax,%eax
  8024b5:	01 d0                	add    %edx,%eax
  8024b7:	c1 e0 02             	shl    $0x2,%eax
  8024ba:	05 44 10 81 00       	add    $0x811044,%eax
  8024bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8024c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c8:	89 d0                	mov    %edx,%eax
  8024ca:	01 c0                	add    %eax,%eax
  8024cc:	01 d0                	add    %edx,%eax
  8024ce:	c1 e0 02             	shl    $0x2,%eax
  8024d1:	05 40 10 81 00       	add    $0x811040,%eax
  8024d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024dc:	e9 8e 00 00 00       	jmp    80256f <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8024e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024e7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8024ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ed:	89 d0                	mov    %edx,%eax
  8024ef:	01 c0                	add    %eax,%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c1 e0 02             	shl    $0x2,%eax
  8024f6:	05 40 10 81 00       	add    $0x811040,%eax
  8024fb:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8024fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802500:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802503:	89 c2                	mov    %eax,%edx
  802505:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	01 c0                	add    %eax,%eax
  80250c:	01 c8                	add    %ecx,%eax
  80250e:	c1 e0 02             	shl    $0x2,%eax
  802511:	05 44 10 81 00       	add    $0x811044,%eax
  802516:	89 10                	mov    %edx,(%eax)
  802518:	eb 55                	jmp    80256f <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80251a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802521:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802527:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80252a:	01 d0                	add    %edx,%eax
  80252c:	48                   	dec    %eax
  80252d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802530:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802533:	ba 00 00 00 00       	mov    $0x0,%edx
  802538:	f7 75 cc             	divl   -0x34(%ebp)
  80253b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80253e:	29 d0                	sub    %edx,%eax
  802540:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802543:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802546:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802549:	01 d0                	add    %edx,%eax
  80254b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802550:	76 0a                	jbe    80255c <sget+0x2ac>
            return NULL;
  802552:	b8 00 00 00 00       	mov    $0x0,%eax
  802557:	e9 ab 00 00 00       	jmp    802607 <sget+0x357>
        va = start;
  80255c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80255f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802562:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802565:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802568:	01 d0                	add    %edx,%eax
  80256a:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80256f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802576:	eb 5e                	jmp    8025d6 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802578:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80257b:	89 d0                	mov    %edx,%eax
  80257d:	01 c0                	add    %eax,%eax
  80257f:	01 d0                	add    %edx,%eax
  802581:	c1 e0 02             	shl    $0x2,%eax
  802584:	05 48 50 80 00       	add    $0x805048,%eax
  802589:	8a 00                	mov    (%eax),%al
  80258b:	84 c0                	test   %al,%al
  80258d:	75 44                	jne    8025d3 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80258f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802592:	89 d0                	mov    %edx,%eax
  802594:	01 c0                	add    %eax,%eax
  802596:	01 d0                	add    %edx,%eax
  802598:	c1 e0 02             	shl    $0x2,%eax
  80259b:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8025a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8025a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025a9:	89 d0                	mov    %edx,%eax
  8025ab:	01 c0                	add    %eax,%eax
  8025ad:	01 d0                	add    %edx,%eax
  8025af:	c1 e0 02             	shl    $0x2,%eax
  8025b2:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8025b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025bb:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8025bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025c0:	89 d0                	mov    %edx,%eax
  8025c2:	01 c0                	add    %eax,%eax
  8025c4:	01 d0                	add    %edx,%eax
  8025c6:	c1 e0 02             	shl    $0x2,%eax
  8025c9:	05 48 50 80 00       	add    $0x805048,%eax
  8025ce:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8025d1:	eb 0c                	jmp    8025df <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025d3:	ff 45 e0             	incl   -0x20(%ebp)
  8025d6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8025dd:	7e 99                	jle    802578 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8025df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e2:	83 ec 04             	sub    $0x4,%esp
  8025e5:	50                   	push   %eax
  8025e6:	ff 75 0c             	pushl  0xc(%ebp)
  8025e9:	ff 75 08             	pushl  0x8(%ebp)
  8025ec:	e8 bf 0b 00 00       	call   8031b0 <sys_get_shared_object>
  8025f1:	83 c4 10             	add    $0x10,%esp
  8025f4:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8025f7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025fb:	79 07                	jns    802604 <sget+0x354>
        return NULL;
  8025fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802602:	eb 03                	jmp    802607 <sget+0x357>
    return (void*)va;
  802604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80260f:	e8 f8 f0 ff ff       	call   80170c <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802618:	75 13                	jne    80262d <realloc+0x24>
		return malloc(new_size);
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	ff 75 0c             	pushl  0xc(%ebp)
  802620:	e8 c4 f1 ff ff       	call   8017e9 <malloc>
  802625:	83 c4 10             	add    $0x10,%esp
  802628:	e9 f4 05 00 00       	jmp    802c21 <realloc+0x618>
	if (new_size == 0)
  80262d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802631:	75 18                	jne    80264b <realloc+0x42>
	{
		free(virtual_address);
  802633:	83 ec 0c             	sub    $0xc,%esp
  802636:	ff 75 08             	pushl  0x8(%ebp)
  802639:	e8 0b f5 ff ff       	call   801b49 <free>
  80263e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
  802646:	e9 d6 05 00 00       	jmp    802c21 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802651:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	79 74                	jns    8026cc <realloc+0xc3>
  802658:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80265f:	77 6b                	ja     8026cc <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802661:	83 ec 0c             	sub    $0xc,%esp
  802664:	ff 75 0c             	pushl  0xc(%ebp)
  802667:	e8 7d f1 ff ff       	call   8017e9 <malloc>
  80266c:	83 c4 10             	add    $0x10,%esp
  80266f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802672:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802676:	75 0a                	jne    802682 <realloc+0x79>
			return NULL;
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
  80267d:	e9 9f 05 00 00       	jmp    802c21 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802682:	83 ec 0c             	sub    $0xc,%esp
  802685:	ff 75 08             	pushl  0x8(%ebp)
  802688:	e8 e0 11 00 00       	call   80386d <get_block_size>
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802693:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802696:	8b 45 0c             	mov    0xc(%ebp),%eax
  802699:	39 d0                	cmp    %edx,%eax
  80269b:	76 02                	jbe    80269f <realloc+0x96>
  80269d:	89 d0                	mov    %edx,%eax
  80269f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8026a2:	83 ec 04             	sub    $0x4,%esp
  8026a5:	ff 75 c0             	pushl  -0x40(%ebp)
  8026a8:	ff 75 08             	pushl  0x8(%ebp)
  8026ab:	ff 75 c8             	pushl  -0x38(%ebp)
  8026ae:	e8 56 eb ff ff       	call   801209 <memmove>
  8026b3:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	ff 75 08             	pushl  0x8(%ebp)
  8026bc:	e8 88 f4 ff ff       	call   801b49 <free>
  8026c1:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8026c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026c7:	e9 55 05 00 00       	jmp    802c21 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8026cc:	a1 30 51 83 00       	mov    0x835130,%eax
  8026d1:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8026d4:	72 09                	jb     8026df <realloc+0xd6>
  8026d6:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8026dd:	76 0a                	jbe    8026e9 <realloc+0xe0>
		return NULL;
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	e9 38 05 00 00       	jmp    802c21 <realloc+0x618>
	uint32 oldsz = 0;
  8026e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8026f0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8026f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026fe:	eb 50                	jmp    802750 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802700:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802703:	89 d0                	mov    %edx,%eax
  802705:	01 c0                	add    %eax,%eax
  802707:	01 d0                	add    %edx,%eax
  802709:	c1 e0 02             	shl    $0x2,%eax
  80270c:	05 48 50 80 00       	add    $0x805048,%eax
  802711:	8a 00                	mov    (%eax),%al
  802713:	84 c0                	test   %al,%al
  802715:	74 36                	je     80274d <realloc+0x144>
  802717:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80271a:	89 d0                	mov    %edx,%eax
  80271c:	01 c0                	add    %eax,%eax
  80271e:	01 d0                	add    %edx,%eax
  802720:	c1 e0 02             	shl    $0x2,%eax
  802723:	05 40 50 80 00       	add    $0x805040,%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80272d:	75 1e                	jne    80274d <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80272f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802732:	89 d0                	mov    %edx,%eax
  802734:	01 c0                	add    %eax,%eax
  802736:	01 d0                	add    %edx,%eax
  802738:	c1 e0 02             	shl    $0x2,%eax
  80273b:	05 44 50 80 00       	add    $0x805044,%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802748:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80274b:	eb 0c                	jmp    802759 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80274d:	ff 45 ec             	incl   -0x14(%ebp)
  802750:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802757:	7e a7                	jle    802700 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802759:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80275d:	75 0a                	jne    802769 <realloc+0x160>
		return NULL;
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	e9 b8 04 00 00       	jmp    802c21 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802769:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802770:	8b 55 0c             	mov    0xc(%ebp),%edx
  802773:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802776:	01 d0                	add    %edx,%eax
  802778:	48                   	dec    %eax
  802779:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80277c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80277f:	ba 00 00 00 00       	mov    $0x0,%edx
  802784:	f7 75 bc             	divl   -0x44(%ebp)
  802787:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80278a:	29 d0                	sub    %edx,%eax
  80278c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80278f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802792:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802795:	75 08                	jne    80279f <realloc+0x196>
		return virtual_address;
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	e9 82 04 00 00       	jmp    802c21 <realloc+0x618>
	if (req < oldsz)
  80279f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027a5:	0f 83 cd 02 00 00    	jae    802a78 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8027b1:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8027b4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027ba:	01 d0                	add    %edx,%eax
  8027bc:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8027bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c2:	89 d0                	mov    %edx,%eax
  8027c4:	01 c0                	add    %eax,%eax
  8027c6:	01 d0                	add    %edx,%eax
  8027c8:	c1 e0 02             	shl    $0x2,%eax
  8027cb:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8027d1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027d4:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8027d6:	83 ec 08             	sub    $0x8,%esp
  8027d9:	ff 75 b0             	pushl  -0x50(%ebp)
  8027dc:	ff 75 ac             	pushl  -0x54(%ebp)
  8027df:	e8 e3 0c 00 00       	call   8034c7 <sys_free_user_mem>
  8027e4:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8027e7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8027ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8027f5:	eb 64                	jmp    80285b <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8027f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027fa:	89 d0                	mov    %edx,%eax
  8027fc:	01 c0                	add    %eax,%eax
  8027fe:	01 d0                	add    %edx,%eax
  802800:	c1 e0 02             	shl    $0x2,%eax
  802803:	05 48 10 81 00       	add    $0x811048,%eax
  802808:	8a 00                	mov    (%eax),%al
  80280a:	84 c0                	test   %al,%al
  80280c:	75 4a                	jne    802858 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  80280e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802811:	89 d0                	mov    %edx,%eax
  802813:	01 c0                	add    %eax,%eax
  802815:	01 d0                	add    %edx,%eax
  802817:	c1 e0 02             	shl    $0x2,%eax
  80281a:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802820:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802823:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802825:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802828:	89 d0                	mov    %edx,%eax
  80282a:	01 c0                	add    %eax,%eax
  80282c:	01 d0                	add    %edx,%eax
  80282e:	c1 e0 02             	shl    $0x2,%eax
  802831:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802837:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80283a:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80283c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80283f:	89 d0                	mov    %edx,%eax
  802841:	01 c0                	add    %eax,%eax
  802843:	01 d0                	add    %edx,%eax
  802845:	c1 e0 02             	shl    $0x2,%eax
  802848:	05 48 10 81 00       	add    $0x811048,%eax
  80284d:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802853:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802856:	eb 0c                	jmp    802864 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802858:	ff 45 e4             	incl   -0x1c(%ebp)
  80285b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802862:	7e 93                	jle    8027f7 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802864:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802868:	0f 84 8d 01 00 00    	je     8029fb <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80286e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802875:	e9 74 01 00 00       	jmp    8029ee <realloc+0x3e5>
			{
				if (k == fidx) continue;
  80287a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802880:	0f 84 64 01 00 00    	je     8029ea <realloc+0x3e1>
				if (uhp_frees[k].free)
  802886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802889:	89 d0                	mov    %edx,%eax
  80288b:	01 c0                	add    %eax,%eax
  80288d:	01 d0                	add    %edx,%eax
  80288f:	c1 e0 02             	shl    $0x2,%eax
  802892:	05 48 10 81 00       	add    $0x811048,%eax
  802897:	8a 00                	mov    (%eax),%al
  802899:	84 c0                	test   %al,%al
  80289b:	0f 84 4a 01 00 00    	je     8029eb <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8028a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028a4:	89 d0                	mov    %edx,%eax
  8028a6:	01 c0                	add    %eax,%eax
  8028a8:	01 d0                	add    %edx,%eax
  8028aa:	c1 e0 02             	shl    $0x2,%eax
  8028ad:	05 40 10 81 00       	add    $0x811040,%eax
  8028b2:	8b 08                	mov    (%eax),%ecx
  8028b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b7:	89 d0                	mov    %edx,%eax
  8028b9:	01 c0                	add    %eax,%eax
  8028bb:	01 d0                	add    %edx,%eax
  8028bd:	c1 e0 02             	shl    $0x2,%eax
  8028c0:	05 44 10 81 00       	add    $0x811044,%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	01 c1                	add    %eax,%ecx
  8028c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028cc:	89 d0                	mov    %edx,%eax
  8028ce:	01 c0                	add    %eax,%eax
  8028d0:	01 d0                	add    %edx,%eax
  8028d2:	c1 e0 02             	shl    $0x2,%eax
  8028d5:	05 40 10 81 00       	add    $0x811040,%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	39 c1                	cmp    %eax,%ecx
  8028de:	75 7a                	jne    80295a <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8028e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028e3:	89 d0                	mov    %edx,%eax
  8028e5:	01 c0                	add    %eax,%eax
  8028e7:	01 d0                	add    %edx,%eax
  8028e9:	c1 e0 02             	shl    $0x2,%eax
  8028ec:	05 40 10 81 00       	add    $0x811040,%eax
  8028f1:	8b 10                	mov    (%eax),%edx
  8028f3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8028f6:	89 c8                	mov    %ecx,%eax
  8028f8:	01 c0                	add    %eax,%eax
  8028fa:	01 c8                	add    %ecx,%eax
  8028fc:	c1 e0 02             	shl    $0x2,%eax
  8028ff:	05 40 10 81 00       	add    $0x811040,%eax
  802904:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802906:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802909:	89 d0                	mov    %edx,%eax
  80290b:	01 c0                	add    %eax,%eax
  80290d:	01 d0                	add    %edx,%eax
  80290f:	c1 e0 02             	shl    $0x2,%eax
  802912:	05 44 10 81 00       	add    $0x811044,%eax
  802917:	8b 08                	mov    (%eax),%ecx
  802919:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80291c:	89 d0                	mov    %edx,%eax
  80291e:	01 c0                	add    %eax,%eax
  802920:	01 d0                	add    %edx,%eax
  802922:	c1 e0 02             	shl    $0x2,%eax
  802925:	05 44 10 81 00       	add    $0x811044,%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	01 c1                	add    %eax,%ecx
  80292e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802931:	89 d0                	mov    %edx,%eax
  802933:	01 c0                	add    %eax,%eax
  802935:	01 d0                	add    %edx,%eax
  802937:	c1 e0 02             	shl    $0x2,%eax
  80293a:	05 44 10 81 00       	add    $0x811044,%eax
  80293f:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802944:	89 d0                	mov    %edx,%eax
  802946:	01 c0                	add    %eax,%eax
  802948:	01 d0                	add    %edx,%eax
  80294a:	c1 e0 02             	shl    $0x2,%eax
  80294d:	05 48 10 81 00       	add    $0x811048,%eax
  802952:	c6 00 00             	movb   $0x0,(%eax)
  802955:	e9 91 00 00 00       	jmp    8029eb <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80295a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80295d:	89 d0                	mov    %edx,%eax
  80295f:	01 c0                	add    %eax,%eax
  802961:	01 d0                	add    %edx,%eax
  802963:	c1 e0 02             	shl    $0x2,%eax
  802966:	05 40 10 81 00       	add    $0x811040,%eax
  80296b:	8b 08                	mov    (%eax),%ecx
  80296d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802970:	89 d0                	mov    %edx,%eax
  802972:	01 c0                	add    %eax,%eax
  802974:	01 d0                	add    %edx,%eax
  802976:	c1 e0 02             	shl    $0x2,%eax
  802979:	05 44 10 81 00       	add    $0x811044,%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	01 c1                	add    %eax,%ecx
  802982:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802985:	89 d0                	mov    %edx,%eax
  802987:	01 c0                	add    %eax,%eax
  802989:	01 d0                	add    %edx,%eax
  80298b:	c1 e0 02             	shl    $0x2,%eax
  80298e:	05 40 10 81 00       	add    $0x811040,%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	39 c1                	cmp    %eax,%ecx
  802997:	75 52                	jne    8029eb <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802999:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80299c:	89 d0                	mov    %edx,%eax
  80299e:	01 c0                	add    %eax,%eax
  8029a0:	01 d0                	add    %edx,%eax
  8029a2:	c1 e0 02             	shl    $0x2,%eax
  8029a5:	05 44 10 81 00       	add    $0x811044,%eax
  8029aa:	8b 08                	mov    (%eax),%ecx
  8029ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029af:	89 d0                	mov    %edx,%eax
  8029b1:	01 c0                	add    %eax,%eax
  8029b3:	01 d0                	add    %edx,%eax
  8029b5:	c1 e0 02             	shl    $0x2,%eax
  8029b8:	05 44 10 81 00       	add    $0x811044,%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	01 c1                	add    %eax,%ecx
  8029c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c4:	89 d0                	mov    %edx,%eax
  8029c6:	01 c0                	add    %eax,%eax
  8029c8:	01 d0                	add    %edx,%eax
  8029ca:	c1 e0 02             	shl    $0x2,%eax
  8029cd:	05 44 10 81 00       	add    $0x811044,%eax
  8029d2:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8029d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029d7:	89 d0                	mov    %edx,%eax
  8029d9:	01 c0                	add    %eax,%eax
  8029db:	01 d0                	add    %edx,%eax
  8029dd:	c1 e0 02             	shl    $0x2,%eax
  8029e0:	05 48 10 81 00       	add    $0x811048,%eax
  8029e5:	c6 00 00             	movb   $0x0,(%eax)
  8029e8:	eb 01                	jmp    8029eb <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8029ea:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8029eb:	ff 45 e0             	incl   -0x20(%ebp)
  8029ee:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8029f5:	0f 8e 7f fe ff ff    	jle    80287a <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  8029fb:	a1 30 51 83 00       	mov    0x835130,%eax
  802a00:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802a03:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802a0a:	eb 53                	jmp    802a5f <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802a0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a0f:	89 d0                	mov    %edx,%eax
  802a11:	01 c0                	add    %eax,%eax
  802a13:	01 d0                	add    %edx,%eax
  802a15:	c1 e0 02             	shl    $0x2,%eax
  802a18:	05 48 50 80 00       	add    $0x805048,%eax
  802a1d:	8a 00                	mov    (%eax),%al
  802a1f:	84 c0                	test   %al,%al
  802a21:	74 39                	je     802a5c <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802a23:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a26:	89 d0                	mov    %edx,%eax
  802a28:	01 c0                	add    %eax,%eax
  802a2a:	01 d0                	add    %edx,%eax
  802a2c:	c1 e0 02             	shl    $0x2,%eax
  802a2f:	05 40 50 80 00       	add    $0x805040,%eax
  802a34:	8b 08                	mov    (%eax),%ecx
  802a36:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a39:	89 d0                	mov    %edx,%eax
  802a3b:	01 c0                	add    %eax,%eax
  802a3d:	01 d0                	add    %edx,%eax
  802a3f:	c1 e0 02             	shl    $0x2,%eax
  802a42:	05 44 50 80 00       	add    $0x805044,%eax
  802a47:	8b 00                	mov    (%eax),%eax
  802a49:	01 c8                	add    %ecx,%eax
  802a4b:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802a4e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a51:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802a54:	76 06                	jbe    802a5c <realloc+0x453>
  802a56:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a59:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802a5c:	ff 45 d8             	incl   -0x28(%ebp)
  802a5f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802a66:	7e a4                	jle    802a0c <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802a68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a6b:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	e9 a9 01 00 00       	jmp    802c21 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802a78:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	01 d0                	add    %edx,%eax
  802a80:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802a83:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a8a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802a91:	eb 57                	jmp    802aea <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802a93:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a96:	89 d0                	mov    %edx,%eax
  802a98:	01 c0                	add    %eax,%eax
  802a9a:	01 d0                	add    %edx,%eax
  802a9c:	c1 e0 02             	shl    $0x2,%eax
  802a9f:	05 48 10 81 00       	add    $0x811048,%eax
  802aa4:	8a 00                	mov    (%eax),%al
  802aa6:	84 c0                	test   %al,%al
  802aa8:	74 3d                	je     802ae7 <realloc+0x4de>
  802aaa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802aad:	89 d0                	mov    %edx,%eax
  802aaf:	01 c0                	add    %eax,%eax
  802ab1:	01 d0                	add    %edx,%eax
  802ab3:	c1 e0 02             	shl    $0x2,%eax
  802ab6:	05 40 10 81 00       	add    $0x811040,%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ac0:	75 25                	jne    802ae7 <realloc+0x4de>
  802ac2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ac5:	89 d0                	mov    %edx,%eax
  802ac7:	01 c0                	add    %eax,%eax
  802ac9:	01 d0                	add    %edx,%eax
  802acb:	c1 e0 02             	shl    $0x2,%eax
  802ace:	05 44 10 81 00       	add    $0x811044,%eax
  802ad3:	8b 10                	mov    (%eax),%edx
  802ad5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ad8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802adb:	39 c2                	cmp    %eax,%edx
  802add:	72 08                	jb     802ae7 <realloc+0x4de>
		{
			adjIdx = j; break;
  802adf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ae2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ae5:	eb 0c                	jmp    802af3 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ae7:	ff 45 d0             	incl   -0x30(%ebp)
  802aea:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802af1:	7e a0                	jle    802a93 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802af3:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802af7:	0f 84 d6 00 00 00    	je     802bd3 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802afd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b00:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b03:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802b06:	83 ec 08             	sub    $0x8,%esp
  802b09:	ff 75 a0             	pushl  -0x60(%ebp)
  802b0c:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b0f:	e8 cf 09 00 00       	call   8034e3 <sys_allocate_user_mem>
  802b14:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802b17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1a:	89 d0                	mov    %edx,%eax
  802b1c:	01 c0                	add    %eax,%eax
  802b1e:	01 d0                	add    %edx,%eax
  802b20:	c1 e0 02             	shl    $0x2,%eax
  802b23:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802b29:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b2c:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802b2e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b31:	89 d0                	mov    %edx,%eax
  802b33:	01 c0                	add    %eax,%eax
  802b35:	01 d0                	add    %edx,%eax
  802b37:	c1 e0 02             	shl    $0x2,%eax
  802b3a:	05 40 10 81 00       	add    $0x811040,%eax
  802b3f:	8b 10                	mov    (%eax),%edx
  802b41:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802b44:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802b47:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b4a:	89 d0                	mov    %edx,%eax
  802b4c:	01 c0                	add    %eax,%eax
  802b4e:	01 d0                	add    %edx,%eax
  802b50:	c1 e0 02             	shl    $0x2,%eax
  802b53:	05 40 10 81 00       	add    $0x811040,%eax
  802b58:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802b5a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b5d:	89 d0                	mov    %edx,%eax
  802b5f:	01 c0                	add    %eax,%eax
  802b61:	01 d0                	add    %edx,%eax
  802b63:	c1 e0 02             	shl    $0x2,%eax
  802b66:	05 44 10 81 00       	add    $0x811044,%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802b70:	89 c2                	mov    %eax,%edx
  802b72:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802b75:	89 c8                	mov    %ecx,%eax
  802b77:	01 c0                	add    %eax,%eax
  802b79:	01 c8                	add    %ecx,%eax
  802b7b:	c1 e0 02             	shl    $0x2,%eax
  802b7e:	05 44 10 81 00       	add    $0x811044,%eax
  802b83:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802b85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b88:	89 d0                	mov    %edx,%eax
  802b8a:	01 c0                	add    %eax,%eax
  802b8c:	01 d0                	add    %edx,%eax
  802b8e:	c1 e0 02             	shl    $0x2,%eax
  802b91:	05 44 10 81 00       	add    $0x811044,%eax
  802b96:	8b 00                	mov    (%eax),%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	75 14                	jne    802bb0 <realloc+0x5a7>
  802b9c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b9f:	89 d0                	mov    %edx,%eax
  802ba1:	01 c0                	add    %eax,%eax
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	c1 e0 02             	shl    $0x2,%eax
  802ba8:	05 48 10 81 00       	add    $0x811048,%eax
  802bad:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802bb0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bb3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bb6:	01 c2                	add    %eax,%edx
  802bb8:	a1 88 50 83 00       	mov    0x835088,%eax
  802bbd:	39 c2                	cmp    %eax,%edx
  802bbf:	76 0d                	jbe    802bce <realloc+0x5c5>
  802bc1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bc4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bc7:	01 d0                	add    %edx,%eax
  802bc9:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	eb 4e                	jmp    802c21 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802bd3:	83 ec 0c             	sub    $0xc,%esp
  802bd6:	ff 75 0c             	pushl  0xc(%ebp)
  802bd9:	e8 0b ec ff ff       	call   8017e9 <malloc>
  802bde:	83 c4 10             	add    $0x10,%esp
  802be1:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802be4:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802be8:	75 07                	jne    802bf1 <realloc+0x5e8>
		return NULL;
  802bea:	b8 00 00 00 00       	mov    $0x0,%eax
  802bef:	eb 30                	jmp    802c21 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bf7:	39 d0                	cmp    %edx,%eax
  802bf9:	76 02                	jbe    802bfd <realloc+0x5f4>
  802bfb:	89 d0                	mov    %edx,%eax
  802bfd:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	50                   	push   %eax
  802c04:	52                   	push   %edx
  802c05:	ff 75 cc             	pushl  -0x34(%ebp)
  802c08:	e8 cf 06 00 00       	call   8032dc <sys_move_user_mem>
  802c0d:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802c10:	83 ec 0c             	sub    $0xc,%esp
  802c13:	ff 75 08             	pushl  0x8(%ebp)
  802c16:	e8 2e ef ff ff       	call   801b49 <free>
  802c1b:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802c1e:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802c21:	c9                   	leave  
  802c22:	c3                   	ret    

00802c23 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
  802c26:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802c2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c33:	0f 84 33 03 00 00    	je     802f6c <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802c41:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802c44:	83 ec 08             	sub    $0x8,%esp
  802c47:	ff 75 08             	pushl  0x8(%ebp)
  802c4a:	ff 75 d8             	pushl  -0x28(%ebp)
  802c4d:	e8 7d 05 00 00       	call   8031cf <sys_delete_shared_object>
  802c52:	83 c4 10             	add    $0x10,%esp
  802c55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802c58:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802c5c:	0f 88 0d 03 00 00    	js     802f6f <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c69:	e9 ef 02 00 00       	jmp    802f5d <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c71:	89 d0                	mov    %edx,%eax
  802c73:	01 c0                	add    %eax,%eax
  802c75:	01 d0                	add    %edx,%eax
  802c77:	c1 e0 02             	shl    $0x2,%eax
  802c7a:	05 48 50 80 00       	add    $0x805048,%eax
  802c7f:	8a 00                	mov    (%eax),%al
  802c81:	84 c0                	test   %al,%al
  802c83:	0f 84 d1 02 00 00    	je     802f5a <sfree+0x337>
  802c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8c:	89 d0                	mov    %edx,%eax
  802c8e:	01 c0                	add    %eax,%eax
  802c90:	01 d0                	add    %edx,%eax
  802c92:	c1 e0 02             	shl    $0x2,%eax
  802c95:	05 40 50 80 00       	add    $0x805040,%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c9f:	0f 85 b5 02 00 00    	jne    802f5a <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca8:	89 d0                	mov    %edx,%eax
  802caa:	01 c0                	add    %eax,%eax
  802cac:	01 d0                	add    %edx,%eax
  802cae:	c1 e0 02             	shl    $0x2,%eax
  802cb1:	05 44 50 80 00       	add    $0x805044,%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbe:	89 d0                	mov    %edx,%eax
  802cc0:	01 c0                	add    %eax,%eax
  802cc2:	01 d0                	add    %edx,%eax
  802cc4:	c1 e0 02             	shl    $0x2,%eax
  802cc7:	05 48 50 80 00       	add    $0x805048,%eax
  802ccc:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802ccf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802cd6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802cdd:	eb 64                	jmp    802d43 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802cdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce2:	89 d0                	mov    %edx,%eax
  802ce4:	01 c0                	add    %eax,%eax
  802ce6:	01 d0                	add    %edx,%eax
  802ce8:	c1 e0 02             	shl    $0x2,%eax
  802ceb:	05 48 10 81 00       	add    $0x811048,%eax
  802cf0:	8a 00                	mov    (%eax),%al
  802cf2:	84 c0                	test   %al,%al
  802cf4:	75 4a                	jne    802d40 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802cf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cf9:	89 d0                	mov    %edx,%eax
  802cfb:	01 c0                	add    %eax,%eax
  802cfd:	01 d0                	add    %edx,%eax
  802cff:	c1 e0 02             	shl    $0x2,%eax
  802d02:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802d08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d0b:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802d0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d10:	89 d0                	mov    %edx,%eax
  802d12:	01 c0                	add    %eax,%eax
  802d14:	01 d0                	add    %edx,%eax
  802d16:	c1 e0 02             	shl    $0x2,%eax
  802d19:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802d1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d22:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802d24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d27:	89 d0                	mov    %edx,%eax
  802d29:	01 c0                	add    %eax,%eax
  802d2b:	01 d0                	add    %edx,%eax
  802d2d:	c1 e0 02             	shl    $0x2,%eax
  802d30:	05 48 10 81 00       	add    $0x811048,%eax
  802d35:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802d3e:	eb 0c                	jmp    802d4c <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802d40:	ff 45 ec             	incl   -0x14(%ebp)
  802d43:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802d4a:	7e 93                	jle    802cdf <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802d4c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802d50:	0f 84 8d 01 00 00    	je     802ee3 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802d56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802d5d:	e9 74 01 00 00       	jmp    802ed6 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802d62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d68:	0f 84 64 01 00 00    	je     802ed2 <sfree+0x2af>
					if (uhp_frees[k].free)
  802d6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d71:	89 d0                	mov    %edx,%eax
  802d73:	01 c0                	add    %eax,%eax
  802d75:	01 d0                	add    %edx,%eax
  802d77:	c1 e0 02             	shl    $0x2,%eax
  802d7a:	05 48 10 81 00       	add    $0x811048,%eax
  802d7f:	8a 00                	mov    (%eax),%al
  802d81:	84 c0                	test   %al,%al
  802d83:	0f 84 4a 01 00 00    	je     802ed3 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802d89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d8c:	89 d0                	mov    %edx,%eax
  802d8e:	01 c0                	add    %eax,%eax
  802d90:	01 d0                	add    %edx,%eax
  802d92:	c1 e0 02             	shl    $0x2,%eax
  802d95:	05 40 10 81 00       	add    $0x811040,%eax
  802d9a:	8b 08                	mov    (%eax),%ecx
  802d9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9f:	89 d0                	mov    %edx,%eax
  802da1:	01 c0                	add    %eax,%eax
  802da3:	01 d0                	add    %edx,%eax
  802da5:	c1 e0 02             	shl    $0x2,%eax
  802da8:	05 44 10 81 00       	add    $0x811044,%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	01 c1                	add    %eax,%ecx
  802db1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db4:	89 d0                	mov    %edx,%eax
  802db6:	01 c0                	add    %eax,%eax
  802db8:	01 d0                	add    %edx,%eax
  802dba:	c1 e0 02             	shl    $0x2,%eax
  802dbd:	05 40 10 81 00       	add    $0x811040,%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	39 c1                	cmp    %eax,%ecx
  802dc6:	75 7a                	jne    802e42 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802dc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dcb:	89 d0                	mov    %edx,%eax
  802dcd:	01 c0                	add    %eax,%eax
  802dcf:	01 d0                	add    %edx,%eax
  802dd1:	c1 e0 02             	shl    $0x2,%eax
  802dd4:	05 40 10 81 00       	add    $0x811040,%eax
  802dd9:	8b 10                	mov    (%eax),%edx
  802ddb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802dde:	89 c8                	mov    %ecx,%eax
  802de0:	01 c0                	add    %eax,%eax
  802de2:	01 c8                	add    %ecx,%eax
  802de4:	c1 e0 02             	shl    $0x2,%eax
  802de7:	05 40 10 81 00       	add    $0x811040,%eax
  802dec:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802dee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df1:	89 d0                	mov    %edx,%eax
  802df3:	01 c0                	add    %eax,%eax
  802df5:	01 d0                	add    %edx,%eax
  802df7:	c1 e0 02             	shl    $0x2,%eax
  802dfa:	05 44 10 81 00       	add    $0x811044,%eax
  802dff:	8b 08                	mov    (%eax),%ecx
  802e01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e04:	89 d0                	mov    %edx,%eax
  802e06:	01 c0                	add    %eax,%eax
  802e08:	01 d0                	add    %edx,%eax
  802e0a:	c1 e0 02             	shl    $0x2,%eax
  802e0d:	05 44 10 81 00       	add    $0x811044,%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	01 c1                	add    %eax,%ecx
  802e16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e19:	89 d0                	mov    %edx,%eax
  802e1b:	01 c0                	add    %eax,%eax
  802e1d:	01 d0                	add    %edx,%eax
  802e1f:	c1 e0 02             	shl    $0x2,%eax
  802e22:	05 44 10 81 00       	add    $0x811044,%eax
  802e27:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802e29:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e2c:	89 d0                	mov    %edx,%eax
  802e2e:	01 c0                	add    %eax,%eax
  802e30:	01 d0                	add    %edx,%eax
  802e32:	c1 e0 02             	shl    $0x2,%eax
  802e35:	05 48 10 81 00       	add    $0x811048,%eax
  802e3a:	c6 00 00             	movb   $0x0,(%eax)
  802e3d:	e9 91 00 00 00       	jmp    802ed3 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802e42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e45:	89 d0                	mov    %edx,%eax
  802e47:	01 c0                	add    %eax,%eax
  802e49:	01 d0                	add    %edx,%eax
  802e4b:	c1 e0 02             	shl    $0x2,%eax
  802e4e:	05 40 10 81 00       	add    $0x811040,%eax
  802e53:	8b 08                	mov    (%eax),%ecx
  802e55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e58:	89 d0                	mov    %edx,%eax
  802e5a:	01 c0                	add    %eax,%eax
  802e5c:	01 d0                	add    %edx,%eax
  802e5e:	c1 e0 02             	shl    $0x2,%eax
  802e61:	05 44 10 81 00       	add    $0x811044,%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	01 c1                	add    %eax,%ecx
  802e6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e6d:	89 d0                	mov    %edx,%eax
  802e6f:	01 c0                	add    %eax,%eax
  802e71:	01 d0                	add    %edx,%eax
  802e73:	c1 e0 02             	shl    $0x2,%eax
  802e76:	05 40 10 81 00       	add    $0x811040,%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	39 c1                	cmp    %eax,%ecx
  802e7f:	75 52                	jne    802ed3 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802e81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e84:	89 d0                	mov    %edx,%eax
  802e86:	01 c0                	add    %eax,%eax
  802e88:	01 d0                	add    %edx,%eax
  802e8a:	c1 e0 02             	shl    $0x2,%eax
  802e8d:	05 44 10 81 00       	add    $0x811044,%eax
  802e92:	8b 08                	mov    (%eax),%ecx
  802e94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e97:	89 d0                	mov    %edx,%eax
  802e99:	01 c0                	add    %eax,%eax
  802e9b:	01 d0                	add    %edx,%eax
  802e9d:	c1 e0 02             	shl    $0x2,%eax
  802ea0:	05 44 10 81 00       	add    $0x811044,%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	01 c1                	add    %eax,%ecx
  802ea9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eac:	89 d0                	mov    %edx,%eax
  802eae:	01 c0                	add    %eax,%eax
  802eb0:	01 d0                	add    %edx,%eax
  802eb2:	c1 e0 02             	shl    $0x2,%eax
  802eb5:	05 44 10 81 00       	add    $0x811044,%eax
  802eba:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802ebc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ebf:	89 d0                	mov    %edx,%eax
  802ec1:	01 c0                	add    %eax,%eax
  802ec3:	01 d0                	add    %edx,%eax
  802ec5:	c1 e0 02             	shl    $0x2,%eax
  802ec8:	05 48 10 81 00       	add    $0x811048,%eax
  802ecd:	c6 00 00             	movb   $0x0,(%eax)
  802ed0:	eb 01                	jmp    802ed3 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802ed2:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ed3:	ff 45 e8             	incl   -0x18(%ebp)
  802ed6:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802edd:	0f 8e 7f fe ff ff    	jle    802d62 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802ee3:	a1 30 51 83 00       	mov    0x835130,%eax
  802ee8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802eeb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802ef2:	eb 53                	jmp    802f47 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802ef4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef7:	89 d0                	mov    %edx,%eax
  802ef9:	01 c0                	add    %eax,%eax
  802efb:	01 d0                	add    %edx,%eax
  802efd:	c1 e0 02             	shl    $0x2,%eax
  802f00:	05 48 50 80 00       	add    $0x805048,%eax
  802f05:	8a 00                	mov    (%eax),%al
  802f07:	84 c0                	test   %al,%al
  802f09:	74 39                	je     802f44 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802f0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f0e:	89 d0                	mov    %edx,%eax
  802f10:	01 c0                	add    %eax,%eax
  802f12:	01 d0                	add    %edx,%eax
  802f14:	c1 e0 02             	shl    $0x2,%eax
  802f17:	05 40 50 80 00       	add    $0x805040,%eax
  802f1c:	8b 08                	mov    (%eax),%ecx
  802f1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f21:	89 d0                	mov    %edx,%eax
  802f23:	01 c0                	add    %eax,%eax
  802f25:	01 d0                	add    %edx,%eax
  802f27:	c1 e0 02             	shl    $0x2,%eax
  802f2a:	05 44 50 80 00       	add    $0x805044,%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	01 c8                	add    %ecx,%eax
  802f33:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802f36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f39:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f3c:	76 06                	jbe    802f44 <sfree+0x321>
  802f3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802f44:	ff 45 e0             	incl   -0x20(%ebp)
  802f47:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802f4e:	7e a4                	jle    802ef4 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802f50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f53:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802f58:	eb 16                	jmp    802f70 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802f5a:	ff 45 f4             	incl   -0xc(%ebp)
  802f5d:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802f64:	0f 8e 04 fd ff ff    	jle    802c6e <sfree+0x4b>
  802f6a:	eb 04                	jmp    802f70 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802f6c:	90                   	nop
  802f6d:	eb 01                	jmp    802f70 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802f6f:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802f70:	c9                   	leave  
  802f71:	c3                   	ret    

00802f72 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802f72:	55                   	push   %ebp
  802f73:	89 e5                	mov    %esp,%ebp
  802f75:	57                   	push   %edi
  802f76:	56                   	push   %esi
  802f77:	53                   	push   %ebx
  802f78:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f87:	8b 7d 18             	mov    0x18(%ebp),%edi
  802f8a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802f8d:	cd 30                	int    $0x30
  802f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802f95:	83 c4 10             	add    $0x10,%esp
  802f98:	5b                   	pop    %ebx
  802f99:	5e                   	pop    %esi
  802f9a:	5f                   	pop    %edi
  802f9b:	5d                   	pop    %ebp
  802f9c:	c3                   	ret    

00802f9d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802f9d:	55                   	push   %ebp
  802f9e:	89 e5                	mov    %esp,%ebp
  802fa0:	83 ec 04             	sub    $0x4,%esp
  802fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  802fa6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802fa9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	6a 00                	push   $0x0
  802fb5:	51                   	push   %ecx
  802fb6:	52                   	push   %edx
  802fb7:	ff 75 0c             	pushl  0xc(%ebp)
  802fba:	50                   	push   %eax
  802fbb:	6a 00                	push   $0x0
  802fbd:	e8 b0 ff ff ff       	call   802f72 <syscall>
  802fc2:	83 c4 18             	add    $0x18,%esp
}
  802fc5:	90                   	nop
  802fc6:	c9                   	leave  
  802fc7:	c3                   	ret    

00802fc8 <sys_cgetc>:

int
sys_cgetc(void)
{
  802fc8:	55                   	push   %ebp
  802fc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802fcb:	6a 00                	push   $0x0
  802fcd:	6a 00                	push   $0x0
  802fcf:	6a 00                	push   $0x0
  802fd1:	6a 00                	push   $0x0
  802fd3:	6a 00                	push   $0x0
  802fd5:	6a 02                	push   $0x2
  802fd7:	e8 96 ff ff ff       	call   802f72 <syscall>
  802fdc:	83 c4 18             	add    $0x18,%esp
}
  802fdf:	c9                   	leave  
  802fe0:	c3                   	ret    

00802fe1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802fe1:	55                   	push   %ebp
  802fe2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802fe4:	6a 00                	push   $0x0
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 00                	push   $0x0
  802fec:	6a 00                	push   $0x0
  802fee:	6a 03                	push   $0x3
  802ff0:	e8 7d ff ff ff       	call   802f72 <syscall>
  802ff5:	83 c4 18             	add    $0x18,%esp
}
  802ff8:	90                   	nop
  802ff9:	c9                   	leave  
  802ffa:	c3                   	ret    

00802ffb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802ffb:	55                   	push   %ebp
  802ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	6a 04                	push   $0x4
  80300a:	e8 63 ff ff ff       	call   802f72 <syscall>
  80300f:	83 c4 18             	add    $0x18,%esp
}
  803012:	90                   	nop
  803013:	c9                   	leave  
  803014:	c3                   	ret    

00803015 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803015:	55                   	push   %ebp
  803016:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	52                   	push   %edx
  803025:	50                   	push   %eax
  803026:	6a 08                	push   $0x8
  803028:	e8 45 ff ff ff       	call   802f72 <syscall>
  80302d:	83 c4 18             	add    $0x18,%esp
}
  803030:	c9                   	leave  
  803031:	c3                   	ret    

00803032 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803032:	55                   	push   %ebp
  803033:	89 e5                	mov    %esp,%ebp
  803035:	56                   	push   %esi
  803036:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803037:	8b 75 18             	mov    0x18(%ebp),%esi
  80303a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80303d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803040:	8b 55 0c             	mov    0xc(%ebp),%edx
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	56                   	push   %esi
  803047:	53                   	push   %ebx
  803048:	51                   	push   %ecx
  803049:	52                   	push   %edx
  80304a:	50                   	push   %eax
  80304b:	6a 09                	push   $0x9
  80304d:	e8 20 ff ff ff       	call   802f72 <syscall>
  803052:	83 c4 18             	add    $0x18,%esp
}
  803055:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803058:	5b                   	pop    %ebx
  803059:	5e                   	pop    %esi
  80305a:	5d                   	pop    %ebp
  80305b:	c3                   	ret    

0080305c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80305c:	55                   	push   %ebp
  80305d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80305f:	6a 00                	push   $0x0
  803061:	6a 00                	push   $0x0
  803063:	6a 00                	push   $0x0
  803065:	6a 00                	push   $0x0
  803067:	ff 75 08             	pushl  0x8(%ebp)
  80306a:	6a 0a                	push   $0xa
  80306c:	e8 01 ff ff ff       	call   802f72 <syscall>
  803071:	83 c4 18             	add    $0x18,%esp
}
  803074:	c9                   	leave  
  803075:	c3                   	ret    

00803076 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803076:	55                   	push   %ebp
  803077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803079:	6a 00                	push   $0x0
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	ff 75 0c             	pushl  0xc(%ebp)
  803082:	ff 75 08             	pushl  0x8(%ebp)
  803085:	6a 0b                	push   $0xb
  803087:	e8 e6 fe ff ff       	call   802f72 <syscall>
  80308c:	83 c4 18             	add    $0x18,%esp
}
  80308f:	c9                   	leave  
  803090:	c3                   	ret    

00803091 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803091:	55                   	push   %ebp
  803092:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803094:	6a 00                	push   $0x0
  803096:	6a 00                	push   $0x0
  803098:	6a 00                	push   $0x0
  80309a:	6a 00                	push   $0x0
  80309c:	6a 00                	push   $0x0
  80309e:	6a 0c                	push   $0xc
  8030a0:	e8 cd fe ff ff       	call   802f72 <syscall>
  8030a5:	83 c4 18             	add    $0x18,%esp
}
  8030a8:	c9                   	leave  
  8030a9:	c3                   	ret    

008030aa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 0d                	push   $0xd
  8030b9:	e8 b4 fe ff ff       	call   802f72 <syscall>
  8030be:	83 c4 18             	add    $0x18,%esp
}
  8030c1:	c9                   	leave  
  8030c2:	c3                   	ret    

008030c3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8030c6:	6a 00                	push   $0x0
  8030c8:	6a 00                	push   $0x0
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 0e                	push   $0xe
  8030d2:	e8 9b fe ff ff       	call   802f72 <syscall>
  8030d7:	83 c4 18             	add    $0x18,%esp
}
  8030da:	c9                   	leave  
  8030db:	c3                   	ret    

008030dc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8030dc:	55                   	push   %ebp
  8030dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 0f                	push   $0xf
  8030eb:	e8 82 fe ff ff       	call   802f72 <syscall>
  8030f0:	83 c4 18             	add    $0x18,%esp
}
  8030f3:	c9                   	leave  
  8030f4:	c3                   	ret    

008030f5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8030f5:	55                   	push   %ebp
  8030f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 00                	push   $0x0
  8030fe:	6a 00                	push   $0x0
  803100:	ff 75 08             	pushl  0x8(%ebp)
  803103:	6a 10                	push   $0x10
  803105:	e8 68 fe ff ff       	call   802f72 <syscall>
  80310a:	83 c4 18             	add    $0x18,%esp
}
  80310d:	c9                   	leave  
  80310e:	c3                   	ret    

0080310f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80310f:	55                   	push   %ebp
  803110:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803112:	6a 00                	push   $0x0
  803114:	6a 00                	push   $0x0
  803116:	6a 00                	push   $0x0
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 11                	push   $0x11
  80311e:	e8 4f fe ff ff       	call   802f72 <syscall>
  803123:	83 c4 18             	add    $0x18,%esp
}
  803126:	90                   	nop
  803127:	c9                   	leave  
  803128:	c3                   	ret    

00803129 <sys_cputc>:

void
sys_cputc(const char c)
{
  803129:	55                   	push   %ebp
  80312a:	89 e5                	mov    %esp,%ebp
  80312c:	83 ec 04             	sub    $0x4,%esp
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803135:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803139:	6a 00                	push   $0x0
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	50                   	push   %eax
  803142:	6a 01                	push   $0x1
  803144:	e8 29 fe ff ff       	call   802f72 <syscall>
  803149:	83 c4 18             	add    $0x18,%esp
}
  80314c:	90                   	nop
  80314d:	c9                   	leave  
  80314e:	c3                   	ret    

0080314f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80314f:	55                   	push   %ebp
  803150:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 00                	push   $0x0
  803158:	6a 00                	push   $0x0
  80315a:	6a 00                	push   $0x0
  80315c:	6a 14                	push   $0x14
  80315e:	e8 0f fe ff ff       	call   802f72 <syscall>
  803163:	83 c4 18             	add    $0x18,%esp
}
  803166:	90                   	nop
  803167:	c9                   	leave  
  803168:	c3                   	ret    

00803169 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803169:	55                   	push   %ebp
  80316a:	89 e5                	mov    %esp,%ebp
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	8b 45 10             	mov    0x10(%ebp),%eax
  803172:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803175:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803178:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	6a 00                	push   $0x0
  803181:	51                   	push   %ecx
  803182:	52                   	push   %edx
  803183:	ff 75 0c             	pushl  0xc(%ebp)
  803186:	50                   	push   %eax
  803187:	6a 15                	push   $0x15
  803189:	e8 e4 fd ff ff       	call   802f72 <syscall>
  80318e:	83 c4 18             	add    $0x18,%esp
}
  803191:	c9                   	leave  
  803192:	c3                   	ret    

00803193 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803193:	55                   	push   %ebp
  803194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803196:	8b 55 0c             	mov    0xc(%ebp),%edx
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	6a 00                	push   $0x0
  80319e:	6a 00                	push   $0x0
  8031a0:	6a 00                	push   $0x0
  8031a2:	52                   	push   %edx
  8031a3:	50                   	push   %eax
  8031a4:	6a 16                	push   $0x16
  8031a6:	e8 c7 fd ff ff       	call   802f72 <syscall>
  8031ab:	83 c4 18             	add    $0x18,%esp
}
  8031ae:	c9                   	leave  
  8031af:	c3                   	ret    

008031b0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8031b0:	55                   	push   %ebp
  8031b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8031b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	51                   	push   %ecx
  8031c1:	52                   	push   %edx
  8031c2:	50                   	push   %eax
  8031c3:	6a 17                	push   $0x17
  8031c5:	e8 a8 fd ff ff       	call   802f72 <syscall>
  8031ca:	83 c4 18             	add    $0x18,%esp
}
  8031cd:	c9                   	leave  
  8031ce:	c3                   	ret    

008031cf <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8031cf:	55                   	push   %ebp
  8031d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8031d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	52                   	push   %edx
  8031df:	50                   	push   %eax
  8031e0:	6a 18                	push   $0x18
  8031e2:	e8 8b fd ff ff       	call   802f72 <syscall>
  8031e7:	83 c4 18             	add    $0x18,%esp
}
  8031ea:	c9                   	leave  
  8031eb:	c3                   	ret    

008031ec <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8031ec:	55                   	push   %ebp
  8031ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	6a 00                	push   $0x0
  8031f4:	ff 75 14             	pushl  0x14(%ebp)
  8031f7:	ff 75 10             	pushl  0x10(%ebp)
  8031fa:	ff 75 0c             	pushl  0xc(%ebp)
  8031fd:	50                   	push   %eax
  8031fe:	6a 19                	push   $0x19
  803200:	e8 6d fd ff ff       	call   802f72 <syscall>
  803205:	83 c4 18             	add    $0x18,%esp
}
  803208:	c9                   	leave  
  803209:	c3                   	ret    

0080320a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80320a:	55                   	push   %ebp
  80320b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	6a 00                	push   $0x0
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	50                   	push   %eax
  803219:	6a 1a                	push   $0x1a
  80321b:	e8 52 fd ff ff       	call   802f72 <syscall>
  803220:	83 c4 18             	add    $0x18,%esp
}
  803223:	90                   	nop
  803224:	c9                   	leave  
  803225:	c3                   	ret    

00803226 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803226:	55                   	push   %ebp
  803227:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	50                   	push   %eax
  803235:	6a 1b                	push   $0x1b
  803237:	e8 36 fd ff ff       	call   802f72 <syscall>
  80323c:	83 c4 18             	add    $0x18,%esp
}
  80323f:	c9                   	leave  
  803240:	c3                   	ret    

00803241 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803241:	55                   	push   %ebp
  803242:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803244:	6a 00                	push   $0x0
  803246:	6a 00                	push   $0x0
  803248:	6a 00                	push   $0x0
  80324a:	6a 00                	push   $0x0
  80324c:	6a 00                	push   $0x0
  80324e:	6a 05                	push   $0x5
  803250:	e8 1d fd ff ff       	call   802f72 <syscall>
  803255:	83 c4 18             	add    $0x18,%esp
}
  803258:	c9                   	leave  
  803259:	c3                   	ret    

0080325a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80325a:	55                   	push   %ebp
  80325b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80325d:	6a 00                	push   $0x0
  80325f:	6a 00                	push   $0x0
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	6a 06                	push   $0x6
  803269:	e8 04 fd ff ff       	call   802f72 <syscall>
  80326e:	83 c4 18             	add    $0x18,%esp
}
  803271:	c9                   	leave  
  803272:	c3                   	ret    

00803273 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803273:	55                   	push   %ebp
  803274:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803276:	6a 00                	push   $0x0
  803278:	6a 00                	push   $0x0
  80327a:	6a 00                	push   $0x0
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 07                	push   $0x7
  803282:	e8 eb fc ff ff       	call   802f72 <syscall>
  803287:	83 c4 18             	add    $0x18,%esp
}
  80328a:	c9                   	leave  
  80328b:	c3                   	ret    

0080328c <sys_exit_env>:


void sys_exit_env(void)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80328f:	6a 00                	push   $0x0
  803291:	6a 00                	push   $0x0
  803293:	6a 00                	push   $0x0
  803295:	6a 00                	push   $0x0
  803297:	6a 00                	push   $0x0
  803299:	6a 1c                	push   $0x1c
  80329b:	e8 d2 fc ff ff       	call   802f72 <syscall>
  8032a0:	83 c4 18             	add    $0x18,%esp
}
  8032a3:	90                   	nop
  8032a4:	c9                   	leave  
  8032a5:	c3                   	ret    

008032a6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8032a6:	55                   	push   %ebp
  8032a7:	89 e5                	mov    %esp,%ebp
  8032a9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032ac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032af:	8d 50 04             	lea    0x4(%eax),%edx
  8032b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032b5:	6a 00                	push   $0x0
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	52                   	push   %edx
  8032bc:	50                   	push   %eax
  8032bd:	6a 1d                	push   $0x1d
  8032bf:	e8 ae fc ff ff       	call   802f72 <syscall>
  8032c4:	83 c4 18             	add    $0x18,%esp
	return result;
  8032c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8032cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032d0:	89 01                	mov    %eax,(%ecx)
  8032d2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	c9                   	leave  
  8032d9:	c2 04 00             	ret    $0x4

008032dc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8032dc:	55                   	push   %ebp
  8032dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8032df:	6a 00                	push   $0x0
  8032e1:	6a 00                	push   $0x0
  8032e3:	ff 75 10             	pushl  0x10(%ebp)
  8032e6:	ff 75 0c             	pushl  0xc(%ebp)
  8032e9:	ff 75 08             	pushl  0x8(%ebp)
  8032ec:	6a 13                	push   $0x13
  8032ee:	e8 7f fc ff ff       	call   802f72 <syscall>
  8032f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8032f6:	90                   	nop
}
  8032f7:	c9                   	leave  
  8032f8:	c3                   	ret    

008032f9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8032f9:	55                   	push   %ebp
  8032fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8032fc:	6a 00                	push   $0x0
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	6a 00                	push   $0x0
  803306:	6a 1e                	push   $0x1e
  803308:	e8 65 fc ff ff       	call   802f72 <syscall>
  80330d:	83 c4 18             	add    $0x18,%esp
}
  803310:	c9                   	leave  
  803311:	c3                   	ret    

00803312 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803312:	55                   	push   %ebp
  803313:	89 e5                	mov    %esp,%ebp
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80331e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803322:	6a 00                	push   $0x0
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	6a 00                	push   $0x0
  80332a:	50                   	push   %eax
  80332b:	6a 1f                	push   $0x1f
  80332d:	e8 40 fc ff ff       	call   802f72 <syscall>
  803332:	83 c4 18             	add    $0x18,%esp
	return ;
  803335:	90                   	nop
}
  803336:	c9                   	leave  
  803337:	c3                   	ret    

00803338 <rsttst>:
void rsttst()
{
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80333b:	6a 00                	push   $0x0
  80333d:	6a 00                	push   $0x0
  80333f:	6a 00                	push   $0x0
  803341:	6a 00                	push   $0x0
  803343:	6a 00                	push   $0x0
  803345:	6a 21                	push   $0x21
  803347:	e8 26 fc ff ff       	call   802f72 <syscall>
  80334c:	83 c4 18             	add    $0x18,%esp
	return ;
  80334f:	90                   	nop
}
  803350:	c9                   	leave  
  803351:	c3                   	ret    

00803352 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803352:	55                   	push   %ebp
  803353:	89 e5                	mov    %esp,%ebp
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	8b 45 14             	mov    0x14(%ebp),%eax
  80335b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80335e:	8b 55 18             	mov    0x18(%ebp),%edx
  803361:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803365:	52                   	push   %edx
  803366:	50                   	push   %eax
  803367:	ff 75 10             	pushl  0x10(%ebp)
  80336a:	ff 75 0c             	pushl  0xc(%ebp)
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	6a 20                	push   $0x20
  803372:	e8 fb fb ff ff       	call   802f72 <syscall>
  803377:	83 c4 18             	add    $0x18,%esp
	return ;
  80337a:	90                   	nop
}
  80337b:	c9                   	leave  
  80337c:	c3                   	ret    

0080337d <chktst>:
void chktst(uint32 n)
{
  80337d:	55                   	push   %ebp
  80337e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803380:	6a 00                	push   $0x0
  803382:	6a 00                	push   $0x0
  803384:	6a 00                	push   $0x0
  803386:	6a 00                	push   $0x0
  803388:	ff 75 08             	pushl  0x8(%ebp)
  80338b:	6a 22                	push   $0x22
  80338d:	e8 e0 fb ff ff       	call   802f72 <syscall>
  803392:	83 c4 18             	add    $0x18,%esp
	return ;
  803395:	90                   	nop
}
  803396:	c9                   	leave  
  803397:	c3                   	ret    

00803398 <inctst>:

void inctst()
{
  803398:	55                   	push   %ebp
  803399:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 00                	push   $0x0
  8033a5:	6a 23                	push   $0x23
  8033a7:	e8 c6 fb ff ff       	call   802f72 <syscall>
  8033ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8033af:	90                   	nop
}
  8033b0:	c9                   	leave  
  8033b1:	c3                   	ret    

008033b2 <gettst>:
uint32 gettst()
{
  8033b2:	55                   	push   %ebp
  8033b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033b5:	6a 00                	push   $0x0
  8033b7:	6a 00                	push   $0x0
  8033b9:	6a 00                	push   $0x0
  8033bb:	6a 00                	push   $0x0
  8033bd:	6a 00                	push   $0x0
  8033bf:	6a 24                	push   $0x24
  8033c1:	e8 ac fb ff ff       	call   802f72 <syscall>
  8033c6:	83 c4 18             	add    $0x18,%esp
}
  8033c9:	c9                   	leave  
  8033ca:	c3                   	ret    

008033cb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8033cb:	55                   	push   %ebp
  8033cc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 00                	push   $0x0
  8033d6:	6a 00                	push   $0x0
  8033d8:	6a 25                	push   $0x25
  8033da:	e8 93 fb ff ff       	call   802f72 <syscall>
  8033df:	83 c4 18             	add    $0x18,%esp
  8033e2:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8033e7:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8033ec:	c9                   	leave  
  8033ed:	c3                   	ret    

008033ee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8033ee:	55                   	push   %ebp
  8033ef:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8033f9:	6a 00                	push   $0x0
  8033fb:	6a 00                	push   $0x0
  8033fd:	6a 00                	push   $0x0
  8033ff:	6a 00                	push   $0x0
  803401:	ff 75 08             	pushl  0x8(%ebp)
  803404:	6a 26                	push   $0x26
  803406:	e8 67 fb ff ff       	call   802f72 <syscall>
  80340b:	83 c4 18             	add    $0x18,%esp
	return ;
  80340e:	90                   	nop
}
  80340f:	c9                   	leave  
  803410:	c3                   	ret    

00803411 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803411:	55                   	push   %ebp
  803412:	89 e5                	mov    %esp,%ebp
  803414:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803415:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803418:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80341b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	6a 00                	push   $0x0
  803423:	53                   	push   %ebx
  803424:	51                   	push   %ecx
  803425:	52                   	push   %edx
  803426:	50                   	push   %eax
  803427:	6a 27                	push   $0x27
  803429:	e8 44 fb ff ff       	call   802f72 <syscall>
  80342e:	83 c4 18             	add    $0x18,%esp
}
  803431:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803434:	c9                   	leave  
  803435:	c3                   	ret    

00803436 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803436:	55                   	push   %ebp
  803437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	6a 00                	push   $0x0
  803441:	6a 00                	push   $0x0
  803443:	6a 00                	push   $0x0
  803445:	52                   	push   %edx
  803446:	50                   	push   %eax
  803447:	6a 28                	push   $0x28
  803449:	e8 24 fb ff ff       	call   802f72 <syscall>
  80344e:	83 c4 18             	add    $0x18,%esp
}
  803451:	c9                   	leave  
  803452:	c3                   	ret    

00803453 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803453:	55                   	push   %ebp
  803454:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803456:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	6a 00                	push   $0x0
  803461:	51                   	push   %ecx
  803462:	ff 75 10             	pushl  0x10(%ebp)
  803465:	52                   	push   %edx
  803466:	50                   	push   %eax
  803467:	6a 29                	push   $0x29
  803469:	e8 04 fb ff ff       	call   802f72 <syscall>
  80346e:	83 c4 18             	add    $0x18,%esp
}
  803471:	c9                   	leave  
  803472:	c3                   	ret    

00803473 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803473:	55                   	push   %ebp
  803474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803476:	6a 00                	push   $0x0
  803478:	6a 00                	push   $0x0
  80347a:	ff 75 10             	pushl  0x10(%ebp)
  80347d:	ff 75 0c             	pushl  0xc(%ebp)
  803480:	ff 75 08             	pushl  0x8(%ebp)
  803483:	6a 12                	push   $0x12
  803485:	e8 e8 fa ff ff       	call   802f72 <syscall>
  80348a:	83 c4 18             	add    $0x18,%esp
	return ;
  80348d:	90                   	nop
}
  80348e:	c9                   	leave  
  80348f:	c3                   	ret    

00803490 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803490:	55                   	push   %ebp
  803491:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803493:	8b 55 0c             	mov    0xc(%ebp),%edx
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	6a 00                	push   $0x0
  80349b:	6a 00                	push   $0x0
  80349d:	6a 00                	push   $0x0
  80349f:	52                   	push   %edx
  8034a0:	50                   	push   %eax
  8034a1:	6a 2a                	push   $0x2a
  8034a3:	e8 ca fa ff ff       	call   802f72 <syscall>
  8034a8:	83 c4 18             	add    $0x18,%esp
	return;
  8034ab:	90                   	nop
}
  8034ac:	c9                   	leave  
  8034ad:	c3                   	ret    

008034ae <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8034ae:	55                   	push   %ebp
  8034af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8034b1:	6a 00                	push   $0x0
  8034b3:	6a 00                	push   $0x0
  8034b5:	6a 00                	push   $0x0
  8034b7:	6a 00                	push   $0x0
  8034b9:	6a 00                	push   $0x0
  8034bb:	6a 2b                	push   $0x2b
  8034bd:	e8 b0 fa ff ff       	call   802f72 <syscall>
  8034c2:	83 c4 18             	add    $0x18,%esp
}
  8034c5:	c9                   	leave  
  8034c6:	c3                   	ret    

008034c7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8034c7:	55                   	push   %ebp
  8034c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8034ca:	6a 00                	push   $0x0
  8034cc:	6a 00                	push   $0x0
  8034ce:	6a 00                	push   $0x0
  8034d0:	ff 75 0c             	pushl  0xc(%ebp)
  8034d3:	ff 75 08             	pushl  0x8(%ebp)
  8034d6:	6a 2d                	push   $0x2d
  8034d8:	e8 95 fa ff ff       	call   802f72 <syscall>
  8034dd:	83 c4 18             	add    $0x18,%esp
	return;
  8034e0:	90                   	nop
}
  8034e1:	c9                   	leave  
  8034e2:	c3                   	ret    

008034e3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8034e3:	55                   	push   %ebp
  8034e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8034e6:	6a 00                	push   $0x0
  8034e8:	6a 00                	push   $0x0
  8034ea:	6a 00                	push   $0x0
  8034ec:	ff 75 0c             	pushl  0xc(%ebp)
  8034ef:	ff 75 08             	pushl  0x8(%ebp)
  8034f2:	6a 2c                	push   $0x2c
  8034f4:	e8 79 fa ff ff       	call   802f72 <syscall>
  8034f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8034fc:	90                   	nop
}
  8034fd:	c9                   	leave  
  8034fe:	c3                   	ret    

008034ff <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8034ff:	55                   	push   %ebp
  803500:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803502:	8b 55 0c             	mov    0xc(%ebp),%edx
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	6a 00                	push   $0x0
  80350a:	6a 00                	push   $0x0
  80350c:	6a 00                	push   $0x0
  80350e:	52                   	push   %edx
  80350f:	50                   	push   %eax
  803510:	6a 2e                	push   $0x2e
  803512:	e8 5b fa ff ff       	call   802f72 <syscall>
  803517:	83 c4 18             	add    $0x18,%esp
}
  80351a:	90                   	nop
  80351b:	c9                   	leave  
  80351c:	c3                   	ret    

0080351d <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80351d:	55                   	push   %ebp
  80351e:	89 e5                	mov    %esp,%ebp
  803520:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803523:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  80352a:	72 09                	jb     803535 <to_page_va+0x18>
  80352c:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803533:	72 14                	jb     803549 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803535:	83 ec 04             	sub    $0x4,%esp
  803538:	68 18 4b 80 00       	push   $0x804b18
  80353d:	6a 15                	push   $0x15
  80353f:	68 43 4b 80 00       	push   $0x804b43
  803544:	e8 10 d0 ff ff       	call   800559 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803551:	29 d0                	sub    %edx,%eax
  803553:	c1 f8 02             	sar    $0x2,%eax
  803556:	89 c2                	mov    %eax,%edx
  803558:	89 d0                	mov    %edx,%eax
  80355a:	c1 e0 02             	shl    $0x2,%eax
  80355d:	01 d0                	add    %edx,%eax
  80355f:	c1 e0 02             	shl    $0x2,%eax
  803562:	01 d0                	add    %edx,%eax
  803564:	c1 e0 02             	shl    $0x2,%eax
  803567:	01 d0                	add    %edx,%eax
  803569:	89 c1                	mov    %eax,%ecx
  80356b:	c1 e1 08             	shl    $0x8,%ecx
  80356e:	01 c8                	add    %ecx,%eax
  803570:	89 c1                	mov    %eax,%ecx
  803572:	c1 e1 10             	shl    $0x10,%ecx
  803575:	01 c8                	add    %ecx,%eax
  803577:	01 c0                	add    %eax,%eax
  803579:	01 d0                	add    %edx,%eax
  80357b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	c1 e0 0c             	shl    $0xc,%eax
  803584:	89 c2                	mov    %eax,%edx
  803586:	a1 84 50 83 00       	mov    0x835084,%eax
  80358b:	01 d0                	add    %edx,%eax
}
  80358d:	c9                   	leave  
  80358e:	c3                   	ret    

0080358f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80358f:	55                   	push   %ebp
  803590:	89 e5                	mov    %esp,%ebp
  803592:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803595:	a1 84 50 83 00       	mov    0x835084,%eax
  80359a:	8b 55 08             	mov    0x8(%ebp),%edx
  80359d:	29 c2                	sub    %eax,%edx
  80359f:	89 d0                	mov    %edx,%eax
  8035a1:	c1 e8 0c             	shr    $0xc,%eax
  8035a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8035a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ab:	78 09                	js     8035b6 <to_page_info+0x27>
  8035ad:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8035b4:	7e 14                	jle    8035ca <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8035b6:	83 ec 04             	sub    $0x4,%esp
  8035b9:	68 5c 4b 80 00       	push   $0x804b5c
  8035be:	6a 21                	push   $0x21
  8035c0:	68 43 4b 80 00       	push   $0x804b43
  8035c5:	e8 8f cf ff ff       	call   800559 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8035ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035cd:	89 d0                	mov    %edx,%eax
  8035cf:	01 c0                	add    %eax,%eax
  8035d1:	01 d0                	add    %edx,%eax
  8035d3:	c1 e0 02             	shl    $0x2,%eax
  8035d6:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8035db:	c9                   	leave  
  8035dc:	c3                   	ret    

008035dd <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8035dd:	55                   	push   %ebp
  8035de:	89 e5                	mov    %esp,%ebp
  8035e0:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	05 00 00 00 02       	add    $0x2000000,%eax
  8035eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035ee:	73 16                	jae    803606 <initialize_dynamic_allocator+0x29>
  8035f0:	68 80 4b 80 00       	push   $0x804b80
  8035f5:	68 a6 4b 80 00       	push   $0x804ba6
  8035fa:	6a 2f                	push   $0x2f
  8035fc:	68 43 4b 80 00       	push   $0x804b43
  803601:	e8 53 cf ff ff       	call   800559 <_panic>
	dynAllocStart = daStart;
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  80360e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803611:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803616:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80361d:	eb 36                	jmp    803655 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	c1 e0 04             	shl    $0x4,%eax
  803625:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80362a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803633:	c1 e0 04             	shl    $0x4,%eax
  803636:	05 a4 50 83 00       	add    $0x8350a4,%eax
  80363b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803644:	c1 e0 04             	shl    $0x4,%eax
  803647:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80364c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803652:	ff 45 f4             	incl   -0xc(%ebp)
  803655:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803659:	7e c4                	jle    80361f <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  80365b:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803662:	00 00 00 
  803665:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  80366c:	00 00 00 
  80366f:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803676:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803679:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803680:	e9 1b 01 00 00       	jmp    8037a0 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803685:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803688:	89 d0                	mov    %edx,%eax
  80368a:	01 c0                	add    %eax,%eax
  80368c:	01 d0                	add    %edx,%eax
  80368e:	c1 e0 02             	shl    $0x2,%eax
  803691:	05 88 d0 81 00       	add    $0x81d088,%eax
  803696:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80369b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80369e:	89 d0                	mov    %edx,%eax
  8036a0:	01 c0                	add    %eax,%eax
  8036a2:	01 d0                	add    %edx,%eax
  8036a4:	c1 e0 02             	shl    $0x2,%eax
  8036a7:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8036ac:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8036b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036b4:	89 d0                	mov    %edx,%eax
  8036b6:	01 c0                	add    %eax,%eax
  8036b8:	01 d0                	add    %edx,%eax
  8036ba:	c1 e0 02             	shl    $0x2,%eax
  8036bd:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036c2:	8b 00                	mov    (%eax),%eax
  8036c4:	85 c0                	test   %eax,%eax
  8036c6:	74 2b                	je     8036f3 <initialize_dynamic_allocator+0x116>
  8036c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036cb:	89 d0                	mov    %edx,%eax
  8036cd:	01 c0                	add    %eax,%eax
  8036cf:	01 d0                	add    %edx,%eax
  8036d1:	c1 e0 02             	shl    $0x2,%eax
  8036d4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036d9:	8b 10                	mov    (%eax),%edx
  8036db:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8036de:	89 c8                	mov    %ecx,%eax
  8036e0:	01 c0                	add    %eax,%eax
  8036e2:	01 c8                	add    %ecx,%eax
  8036e4:	c1 e0 02             	shl    $0x2,%eax
  8036e7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036ec:	8b 00                	mov    (%eax),%eax
  8036ee:	89 42 04             	mov    %eax,0x4(%edx)
  8036f1:	eb 18                	jmp    80370b <initialize_dynamic_allocator+0x12e>
  8036f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036f6:	89 d0                	mov    %edx,%eax
  8036f8:	01 c0                	add    %eax,%eax
  8036fa:	01 d0                	add    %edx,%eax
  8036fc:	c1 e0 02             	shl    $0x2,%eax
  8036ff:	05 84 d0 81 00       	add    $0x81d084,%eax
  803704:	8b 00                	mov    (%eax),%eax
  803706:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80370b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80370e:	89 d0                	mov    %edx,%eax
  803710:	01 c0                	add    %eax,%eax
  803712:	01 d0                	add    %edx,%eax
  803714:	c1 e0 02             	shl    $0x2,%eax
  803717:	05 84 d0 81 00       	add    $0x81d084,%eax
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	85 c0                	test   %eax,%eax
  803720:	74 2a                	je     80374c <initialize_dynamic_allocator+0x16f>
  803722:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803725:	89 d0                	mov    %edx,%eax
  803727:	01 c0                	add    %eax,%eax
  803729:	01 d0                	add    %edx,%eax
  80372b:	c1 e0 02             	shl    $0x2,%eax
  80372e:	05 84 d0 81 00       	add    $0x81d084,%eax
  803733:	8b 10                	mov    (%eax),%edx
  803735:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803738:	89 c8                	mov    %ecx,%eax
  80373a:	01 c0                	add    %eax,%eax
  80373c:	01 c8                	add    %ecx,%eax
  80373e:	c1 e0 02             	shl    $0x2,%eax
  803741:	05 80 d0 81 00       	add    $0x81d080,%eax
  803746:	8b 00                	mov    (%eax),%eax
  803748:	89 02                	mov    %eax,(%edx)
  80374a:	eb 18                	jmp    803764 <initialize_dynamic_allocator+0x187>
  80374c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80374f:	89 d0                	mov    %edx,%eax
  803751:	01 c0                	add    %eax,%eax
  803753:	01 d0                	add    %edx,%eax
  803755:	c1 e0 02             	shl    $0x2,%eax
  803758:	05 80 d0 81 00       	add    $0x81d080,%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803764:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803767:	89 d0                	mov    %edx,%eax
  803769:	01 c0                	add    %eax,%eax
  80376b:	01 d0                	add    %edx,%eax
  80376d:	c1 e0 02             	shl    $0x2,%eax
  803770:	05 80 d0 81 00       	add    $0x81d080,%eax
  803775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80377e:	89 d0                	mov    %edx,%eax
  803780:	01 c0                	add    %eax,%eax
  803782:	01 d0                	add    %edx,%eax
  803784:	c1 e0 02             	shl    $0x2,%eax
  803787:	05 84 d0 81 00       	add    $0x81d084,%eax
  80378c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803792:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803797:	48                   	dec    %eax
  803798:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80379d:	ff 45 f0             	incl   -0x10(%ebp)
  8037a0:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8037a7:	0f 8e d8 fe ff ff    	jle    803685 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8037ad:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8037b4:	e9 9d 00 00 00       	jmp    803856 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8037b9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8037bf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8037c2:	89 c8                	mov    %ecx,%eax
  8037c4:	01 c0                	add    %eax,%eax
  8037c6:	01 c8                	add    %ecx,%eax
  8037c8:	c1 e0 02             	shl    $0x2,%eax
  8037cb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037d0:	89 10                	mov    %edx,(%eax)
  8037d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037d5:	89 d0                	mov    %edx,%eax
  8037d7:	01 c0                	add    %eax,%eax
  8037d9:	01 d0                	add    %edx,%eax
  8037db:	c1 e0 02             	shl    $0x2,%eax
  8037de:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037e3:	8b 00                	mov    (%eax),%eax
  8037e5:	85 c0                	test   %eax,%eax
  8037e7:	74 1c                	je     803805 <initialize_dynamic_allocator+0x228>
  8037e9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8037ef:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8037f2:	89 c8                	mov    %ecx,%eax
  8037f4:	01 c0                	add    %eax,%eax
  8037f6:	01 c8                	add    %ecx,%eax
  8037f8:	c1 e0 02             	shl    $0x2,%eax
  8037fb:	05 80 d0 81 00       	add    $0x81d080,%eax
  803800:	89 42 04             	mov    %eax,0x4(%edx)
  803803:	eb 16                	jmp    80381b <initialize_dynamic_allocator+0x23e>
  803805:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803808:	89 d0                	mov    %edx,%eax
  80380a:	01 c0                	add    %eax,%eax
  80380c:	01 d0                	add    %edx,%eax
  80380e:	c1 e0 02             	shl    $0x2,%eax
  803811:	05 80 d0 81 00       	add    $0x81d080,%eax
  803816:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80381b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80381e:	89 d0                	mov    %edx,%eax
  803820:	01 c0                	add    %eax,%eax
  803822:	01 d0                	add    %edx,%eax
  803824:	c1 e0 02             	shl    $0x2,%eax
  803827:	05 80 d0 81 00       	add    $0x81d080,%eax
  80382c:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803831:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803834:	89 d0                	mov    %edx,%eax
  803836:	01 c0                	add    %eax,%eax
  803838:	01 d0                	add    %edx,%eax
  80383a:	c1 e0 02             	shl    $0x2,%eax
  80383d:	05 84 d0 81 00       	add    $0x81d084,%eax
  803842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803848:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80384d:	40                   	inc    %eax
  80384e:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803853:	ff 4d ec             	decl   -0x14(%ebp)
  803856:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80385a:	0f 89 59 ff ff ff    	jns    8037b9 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803860:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803867:	00 00 00 
}
  80386a:	90                   	nop
  80386b:	c9                   	leave  
  80386c:	c3                   	ret    

0080386d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80386d:	55                   	push   %ebp
  80386e:	89 e5                	mov    %esp,%ebp
  803870:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803873:	8b 45 08             	mov    0x8(%ebp),%eax
  803876:	83 ec 0c             	sub    $0xc,%esp
  803879:	50                   	push   %eax
  80387a:	e8 10 fd ff ff       	call   80358f <to_page_info>
  80387f:	83 c4 10             	add    $0x10,%esp
  803882:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803888:	8b 40 08             	mov    0x8(%eax),%eax
  80388b:	0f b7 c0             	movzwl %ax,%eax
}
  80388e:	c9                   	leave  
  80388f:	c3                   	ret    

00803890 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803890:	55                   	push   %ebp
  803891:	89 e5                	mov    %esp,%ebp
  803893:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803896:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80389d:	76 16                	jbe    8038b5 <alloc_block+0x25>
  80389f:	68 bc 4b 80 00       	push   $0x804bbc
  8038a4:	68 a6 4b 80 00       	push   $0x804ba6
  8038a9:	6a 59                	push   $0x59
  8038ab:	68 43 4b 80 00       	push   $0x804b43
  8038b0:	e8 a4 cc ff ff       	call   800559 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8038b5:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8038bc:	eb 08                	jmp    8038c6 <alloc_block+0x36>
		allocSize <<= 1;
  8038be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c1:	01 c0                	add    %eax,%eax
  8038c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8038c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038cc:	73 09                	jae    8038d7 <alloc_block+0x47>
  8038ce:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8038d5:	76 e7                	jbe    8038be <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8038d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8038de:	eb 03                	jmp    8038e3 <alloc_block+0x53>
		listIndex++;
  8038e0:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8038e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e6:	ba 08 00 00 00       	mov    $0x8,%edx
  8038eb:	88 c1                	mov    %al,%cl
  8038ed:	d3 e2                	shl    %cl,%edx
  8038ef:	89 d0                	mov    %edx,%eax
  8038f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8038f4:	72 ea                	jb     8038e0 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8038f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8038fc:	e9 f4 00 00 00       	jmp    8039f5 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803904:	c1 e0 04             	shl    $0x4,%eax
  803907:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	85 c0                	test   %eax,%eax
  803910:	0f 84 dc 00 00 00    	je     8039f2 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803919:	c1 e0 04             	shl    $0x4,%eax
  80391c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803921:	8b 00                	mov    (%eax),%eax
  803923:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803926:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80392a:	75 14                	jne    803940 <alloc_block+0xb0>
  80392c:	83 ec 04             	sub    $0x4,%esp
  80392f:	68 dd 4b 80 00       	push   $0x804bdd
  803934:	6a 6b                	push   $0x6b
  803936:	68 43 4b 80 00       	push   $0x804b43
  80393b:	e8 19 cc ff ff       	call   800559 <_panic>
  803940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803943:	8b 00                	mov    (%eax),%eax
  803945:	85 c0                	test   %eax,%eax
  803947:	74 10                	je     803959 <alloc_block+0xc9>
  803949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803951:	8b 52 04             	mov    0x4(%edx),%edx
  803954:	89 50 04             	mov    %edx,0x4(%eax)
  803957:	eb 14                	jmp    80396d <alloc_block+0xdd>
  803959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395c:	8b 40 04             	mov    0x4(%eax),%eax
  80395f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803962:	c1 e2 04             	shl    $0x4,%edx
  803965:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80396b:	89 02                	mov    %eax,(%edx)
  80396d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803970:	8b 40 04             	mov    0x4(%eax),%eax
  803973:	85 c0                	test   %eax,%eax
  803975:	74 0f                	je     803986 <alloc_block+0xf6>
  803977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397a:	8b 40 04             	mov    0x4(%eax),%eax
  80397d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803980:	8b 12                	mov    (%edx),%edx
  803982:	89 10                	mov    %edx,(%eax)
  803984:	eb 13                	jmp    803999 <alloc_block+0x109>
  803986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80398e:	c1 e2 04             	shl    $0x4,%edx
  803991:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803997:	89 02                	mov    %eax,(%edx)
  803999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039af:	c1 e0 04             	shl    $0x4,%eax
  8039b2:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039b7:	8b 00                	mov    (%eax),%eax
  8039b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039bf:	c1 e0 04             	shl    $0x4,%eax
  8039c2:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039c7:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8039c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cc:	83 ec 0c             	sub    $0xc,%esp
  8039cf:	50                   	push   %eax
  8039d0:	e8 ba fb ff ff       	call   80358f <to_page_info>
  8039d5:	83 c4 10             	add    $0x10,%esp
  8039d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8039db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039de:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8039e2:	48                   	dec    %eax
  8039e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039e6:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8039ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ed:	e9 8f 02 00 00       	jmp    803c81 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8039f2:	ff 45 ec             	incl   -0x14(%ebp)
  8039f5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8039f9:	0f 8e 02 ff ff ff    	jle    803901 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8039ff:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803a04:	85 c0                	test   %eax,%eax
  803a06:	75 14                	jne    803a1c <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803a08:	83 ec 04             	sub    $0x4,%esp
  803a0b:	68 fc 4b 80 00       	push   $0x804bfc
  803a10:	6a 77                	push   $0x77
  803a12:	68 43 4b 80 00       	push   $0x804b43
  803a17:	e8 3d cb ff ff       	call   800559 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803a1c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803a21:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803a24:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a28:	75 14                	jne    803a3e <alloc_block+0x1ae>
  803a2a:	83 ec 04             	sub    $0x4,%esp
  803a2d:	68 dd 4b 80 00       	push   $0x804bdd
  803a32:	6a 7a                	push   $0x7a
  803a34:	68 43 4b 80 00       	push   $0x804b43
  803a39:	e8 1b cb ff ff       	call   800559 <_panic>
  803a3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a41:	8b 00                	mov    (%eax),%eax
  803a43:	85 c0                	test   %eax,%eax
  803a45:	74 10                	je     803a57 <alloc_block+0x1c7>
  803a47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a4f:	8b 52 04             	mov    0x4(%edx),%edx
  803a52:	89 50 04             	mov    %edx,0x4(%eax)
  803a55:	eb 0b                	jmp    803a62 <alloc_block+0x1d2>
  803a57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a5a:	8b 40 04             	mov    0x4(%eax),%eax
  803a5d:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a65:	8b 40 04             	mov    0x4(%eax),%eax
  803a68:	85 c0                	test   %eax,%eax
  803a6a:	74 0f                	je     803a7b <alloc_block+0x1eb>
  803a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a6f:	8b 40 04             	mov    0x4(%eax),%eax
  803a72:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a75:	8b 12                	mov    (%edx),%edx
  803a77:	89 10                	mov    %edx,(%eax)
  803a79:	eb 0a                	jmp    803a85 <alloc_block+0x1f5>
  803a7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a7e:	8b 00                	mov    (%eax),%eax
  803a80:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803a85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a98:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803a9d:	48                   	dec    %eax
  803a9e:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803aa3:	83 ec 0c             	sub    $0xc,%esp
  803aa6:	ff 75 dc             	pushl  -0x24(%ebp)
  803aa9:	e8 6f fa ff ff       	call   80351d <to_page_va>
  803aae:	83 c4 10             	add    $0x10,%esp
  803ab1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803ab4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ab7:	83 ec 0c             	sub    $0xc,%esp
  803aba:	50                   	push   %eax
  803abb:	e8 a0 dc ff ff       	call   801760 <get_page>
  803ac0:	83 c4 10             	add    $0x10,%esp
  803ac3:	85 c0                	test   %eax,%eax
  803ac5:	74 14                	je     803adb <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803ac7:	83 ec 04             	sub    $0x4,%esp
  803aca:	68 24 4c 80 00       	push   $0x804c24
  803acf:	6a 7f                	push   $0x7f
  803ad1:	68 43 4b 80 00       	push   $0x804b43
  803ad6:	e8 7e ca ff ff       	call   800559 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ade:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ae1:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803ae5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803aea:	ba 00 00 00 00       	mov    $0x0,%edx
  803aef:	f7 75 f4             	divl   -0xc(%ebp)
  803af2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803af5:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b00:	e9 a7 00 00 00       	jmp    803bac <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803b05:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0b:	01 d0                	add    %edx,%eax
  803b0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803b10:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b14:	75 17                	jne    803b2d <alloc_block+0x29d>
  803b16:	83 ec 04             	sub    $0x4,%esp
  803b19:	68 4c 4c 80 00       	push   $0x804c4c
  803b1e:	68 88 00 00 00       	push   $0x88
  803b23:	68 43 4b 80 00       	push   $0x804b43
  803b28:	e8 2c ca ff ff       	call   800559 <_panic>
  803b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b30:	c1 e0 04             	shl    $0x4,%eax
  803b33:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b38:	8b 10                	mov    (%eax),%edx
  803b3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b3d:	89 10                	mov    %edx,(%eax)
  803b3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b42:	8b 00                	mov    (%eax),%eax
  803b44:	85 c0                	test   %eax,%eax
  803b46:	74 15                	je     803b5d <alloc_block+0x2cd>
  803b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b4b:	c1 e0 04             	shl    $0x4,%eax
  803b4e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b53:	8b 00                	mov    (%eax),%eax
  803b55:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b58:	89 50 04             	mov    %edx,0x4(%eax)
  803b5b:	eb 11                	jmp    803b6e <alloc_block+0x2de>
  803b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b60:	c1 e0 04             	shl    $0x4,%eax
  803b63:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6c:	89 02                	mov    %eax,(%edx)
  803b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b71:	c1 e0 04             	shl    $0x4,%eax
  803b74:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803b7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7d:	89 02                	mov    %eax,(%edx)
  803b7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8c:	c1 e0 04             	shl    $0x4,%eax
  803b8f:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b94:	8b 00                	mov    (%eax),%eax
  803b96:	8d 50 01             	lea    0x1(%eax),%edx
  803b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9c:	c1 e0 04             	shl    $0x4,%eax
  803b9f:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ba4:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba9:	01 45 e8             	add    %eax,-0x18(%ebp)
  803bac:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803bb3:	0f 86 4c ff ff ff    	jbe    803b05 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbc:	c1 e0 04             	shl    $0x4,%eax
  803bbf:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bc4:	8b 00                	mov    (%eax),%eax
  803bc6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803bc9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803bcd:	75 17                	jne    803be6 <alloc_block+0x356>
  803bcf:	83 ec 04             	sub    $0x4,%esp
  803bd2:	68 dd 4b 80 00       	push   $0x804bdd
  803bd7:	68 8d 00 00 00       	push   $0x8d
  803bdc:	68 43 4b 80 00       	push   $0x804b43
  803be1:	e8 73 c9 ff ff       	call   800559 <_panic>
  803be6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803be9:	8b 00                	mov    (%eax),%eax
  803beb:	85 c0                	test   %eax,%eax
  803bed:	74 10                	je     803bff <alloc_block+0x36f>
  803bef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803bf2:	8b 00                	mov    (%eax),%eax
  803bf4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803bf7:	8b 52 04             	mov    0x4(%edx),%edx
  803bfa:	89 50 04             	mov    %edx,0x4(%eax)
  803bfd:	eb 14                	jmp    803c13 <alloc_block+0x383>
  803bff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c02:	8b 40 04             	mov    0x4(%eax),%eax
  803c05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c08:	c1 e2 04             	shl    $0x4,%edx
  803c0b:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c11:	89 02                	mov    %eax,(%edx)
  803c13:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c16:	8b 40 04             	mov    0x4(%eax),%eax
  803c19:	85 c0                	test   %eax,%eax
  803c1b:	74 0f                	je     803c2c <alloc_block+0x39c>
  803c1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c20:	8b 40 04             	mov    0x4(%eax),%eax
  803c23:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803c26:	8b 12                	mov    (%edx),%edx
  803c28:	89 10                	mov    %edx,(%eax)
  803c2a:	eb 13                	jmp    803c3f <alloc_block+0x3af>
  803c2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c2f:	8b 00                	mov    (%eax),%eax
  803c31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c34:	c1 e2 04             	shl    $0x4,%edx
  803c37:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803c3d:	89 02                	mov    %eax,(%edx)
  803c3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c55:	c1 e0 04             	shl    $0x4,%eax
  803c58:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c5d:	8b 00                	mov    (%eax),%eax
  803c5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c65:	c1 e0 04             	shl    $0x4,%eax
  803c68:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c6d:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803c6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c72:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c76:	48                   	dec    %eax
  803c77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c7a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803c7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803c81:	c9                   	leave  
  803c82:	c3                   	ret    

00803c83 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803c83:	55                   	push   %ebp
  803c84:	89 e5                	mov    %esp,%ebp
  803c86:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803c89:	8b 55 08             	mov    0x8(%ebp),%edx
  803c8c:	a1 84 50 83 00       	mov    0x835084,%eax
  803c91:	39 c2                	cmp    %eax,%edx
  803c93:	72 0c                	jb     803ca1 <free_block+0x1e>
  803c95:	8b 55 08             	mov    0x8(%ebp),%edx
  803c98:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803c9d:	39 c2                	cmp    %eax,%edx
  803c9f:	72 19                	jb     803cba <free_block+0x37>
  803ca1:	68 70 4c 80 00       	push   $0x804c70
  803ca6:	68 a6 4b 80 00       	push   $0x804ba6
  803cab:	68 98 00 00 00       	push   $0x98
  803cb0:	68 43 4b 80 00       	push   $0x804b43
  803cb5:	e8 9f c8 ff ff       	call   800559 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803cba:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbd:	83 ec 0c             	sub    $0xc,%esp
  803cc0:	50                   	push   %eax
  803cc1:	e8 c9 f8 ff ff       	call   80358f <to_page_info>
  803cc6:	83 c4 10             	add    $0x10,%esp
  803cc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ccf:	8b 40 08             	mov    0x8(%eax),%eax
  803cd2:	0f b7 c0             	movzwl %ax,%eax
  803cd5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803cdf:	eb 03                	jmp    803ce4 <free_block+0x61>
		listIndex++;
  803ce1:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce7:	ba 08 00 00 00       	mov    $0x8,%edx
  803cec:	88 c1                	mov    %al,%cl
  803cee:	d3 e2                	shl    %cl,%edx
  803cf0:	89 d0                	mov    %edx,%eax
  803cf2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cf5:	72 ea                	jb     803ce1 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803cfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d01:	75 17                	jne    803d1a <free_block+0x97>
  803d03:	83 ec 04             	sub    $0x4,%esp
  803d06:	68 4c 4c 80 00       	push   $0x804c4c
  803d0b:	68 a2 00 00 00       	push   $0xa2
  803d10:	68 43 4b 80 00       	push   $0x804b43
  803d15:	e8 3f c8 ff ff       	call   800559 <_panic>
  803d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1d:	c1 e0 04             	shl    $0x4,%eax
  803d20:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d25:	8b 10                	mov    (%eax),%edx
  803d27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2a:	89 10                	mov    %edx,(%eax)
  803d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2f:	8b 00                	mov    (%eax),%eax
  803d31:	85 c0                	test   %eax,%eax
  803d33:	74 15                	je     803d4a <free_block+0xc7>
  803d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d38:	c1 e0 04             	shl    $0x4,%eax
  803d3b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d40:	8b 00                	mov    (%eax),%eax
  803d42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d45:	89 50 04             	mov    %edx,0x4(%eax)
  803d48:	eb 11                	jmp    803d5b <free_block+0xd8>
  803d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4d:	c1 e0 04             	shl    $0x4,%eax
  803d50:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d59:	89 02                	mov    %eax,(%edx)
  803d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5e:	c1 e0 04             	shl    $0x4,%eax
  803d61:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803d67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6a:	89 02                	mov    %eax,(%edx)
  803d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d79:	c1 e0 04             	shl    $0x4,%eax
  803d7c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d81:	8b 00                	mov    (%eax),%eax
  803d83:	8d 50 01             	lea    0x1(%eax),%edx
  803d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d89:	c1 e0 04             	shl    $0x4,%eax
  803d8c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d91:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d96:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803d9a:	40                   	inc    %eax
  803d9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d9e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803da9:	0f b7 c8             	movzwl %ax,%ecx
  803dac:	b8 00 10 00 00       	mov    $0x1000,%eax
  803db1:	ba 00 00 00 00       	mov    $0x0,%edx
  803db6:	f7 75 e8             	divl   -0x18(%ebp)
  803db9:	39 c1                	cmp    %eax,%ecx
  803dbb:	0f 85 ed 01 00 00    	jne    803fae <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc4:	c1 e0 04             	shl    $0x4,%eax
  803dc7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803dcc:	8b 00                	mov    (%eax),%eax
  803dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803dd1:	eb 2a                	jmp    803dfd <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd6:	83 ec 0c             	sub    $0xc,%esp
  803dd9:	50                   	push   %eax
  803dda:	e8 b0 f7 ff ff       	call   80358f <to_page_info>
  803ddf:	83 c4 10             	add    $0x10,%esp
  803de2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803de5:	75 06                	jne    803ded <free_block+0x16a>
				tmp = b;
  803de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dea:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df0:	c1 e0 04             	shl    $0x4,%eax
  803df3:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803df8:	8b 00                	mov    (%eax),%eax
  803dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e01:	74 07                	je     803e0a <free_block+0x187>
  803e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e06:	8b 00                	mov    (%eax),%eax
  803e08:	eb 05                	jmp    803e0f <free_block+0x18c>
  803e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e12:	c1 e2 04             	shl    $0x4,%edx
  803e15:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803e1b:	89 02                	mov    %eax,(%edx)
  803e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e20:	c1 e0 04             	shl    $0x4,%eax
  803e23:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803e28:	8b 00                	mov    (%eax),%eax
  803e2a:	85 c0                	test   %eax,%eax
  803e2c:	75 a5                	jne    803dd3 <free_block+0x150>
  803e2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e32:	75 9f                	jne    803dd3 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e37:	c1 e0 04             	shl    $0x4,%eax
  803e3a:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803e3f:	8b 00                	mov    (%eax),%eax
  803e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803e44:	e9 cc 00 00 00       	jmp    803f15 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e4c:	8b 00                	mov    (%eax),%eax
  803e4e:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e54:	83 ec 0c             	sub    $0xc,%esp
  803e57:	50                   	push   %eax
  803e58:	e8 32 f7 ff ff       	call   80358f <to_page_info>
  803e5d:	83 c4 10             	add    $0x10,%esp
  803e60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803e63:	0f 85 a6 00 00 00    	jne    803f0f <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803e69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e6d:	75 17                	jne    803e86 <free_block+0x203>
  803e6f:	83 ec 04             	sub    $0x4,%esp
  803e72:	68 dd 4b 80 00       	push   $0x804bdd
  803e77:	68 b5 00 00 00       	push   $0xb5
  803e7c:	68 43 4b 80 00       	push   $0x804b43
  803e81:	e8 d3 c6 ff ff       	call   800559 <_panic>
  803e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e89:	8b 00                	mov    (%eax),%eax
  803e8b:	85 c0                	test   %eax,%eax
  803e8d:	74 10                	je     803e9f <free_block+0x21c>
  803e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e92:	8b 00                	mov    (%eax),%eax
  803e94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e97:	8b 52 04             	mov    0x4(%edx),%edx
  803e9a:	89 50 04             	mov    %edx,0x4(%eax)
  803e9d:	eb 14                	jmp    803eb3 <free_block+0x230>
  803e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea2:	8b 40 04             	mov    0x4(%eax),%eax
  803ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ea8:	c1 e2 04             	shl    $0x4,%edx
  803eab:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803eb1:	89 02                	mov    %eax,(%edx)
  803eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb6:	8b 40 04             	mov    0x4(%eax),%eax
  803eb9:	85 c0                	test   %eax,%eax
  803ebb:	74 0f                	je     803ecc <free_block+0x249>
  803ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ec0:	8b 40 04             	mov    0x4(%eax),%eax
  803ec3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ec6:	8b 12                	mov    (%edx),%edx
  803ec8:	89 10                	mov    %edx,(%eax)
  803eca:	eb 13                	jmp    803edf <free_block+0x25c>
  803ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ecf:	8b 00                	mov    (%eax),%eax
  803ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ed4:	c1 e2 04             	shl    $0x4,%edx
  803ed7:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803edd:	89 02                	mov    %eax,(%edx)
  803edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef5:	c1 e0 04             	shl    $0x4,%eax
  803ef8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803efd:	8b 00                	mov    (%eax),%eax
  803eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f05:	c1 e0 04             	shl    $0x4,%eax
  803f08:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803f0d:	89 10                	mov    %edx,(%eax)
			b = next;
  803f0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f12:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803f15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f19:	0f 85 2a ff ff ff    	jne    803e49 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f22:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f2b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803f31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803f35:	75 17                	jne    803f4e <free_block+0x2cb>
  803f37:	83 ec 04             	sub    $0x4,%esp
  803f3a:	68 4c 4c 80 00       	push   $0x804c4c
  803f3f:	68 bc 00 00 00       	push   $0xbc
  803f44:	68 43 4b 80 00       	push   $0x804b43
  803f49:	e8 0b c6 ff ff       	call   800559 <_panic>
  803f4e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f57:	89 10                	mov    %edx,(%eax)
  803f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f5c:	8b 00                	mov    (%eax),%eax
  803f5e:	85 c0                	test   %eax,%eax
  803f60:	74 0d                	je     803f6f <free_block+0x2ec>
  803f62:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803f67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f6a:	89 50 04             	mov    %edx,0x4(%eax)
  803f6d:	eb 08                	jmp    803f77 <free_block+0x2f4>
  803f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f72:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f7a:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f89:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803f8e:	40                   	inc    %eax
  803f8f:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803f94:	83 ec 0c             	sub    $0xc,%esp
  803f97:	ff 75 ec             	pushl  -0x14(%ebp)
  803f9a:	e8 7e f5 ff ff       	call   80351d <to_page_va>
  803f9f:	83 c4 10             	add    $0x10,%esp
  803fa2:	83 ec 0c             	sub    $0xc,%esp
  803fa5:	50                   	push   %eax
  803fa6:	e8 fe d7 ff ff       	call   8017a9 <return_page>
  803fab:	83 c4 10             	add    $0x10,%esp
	}
}
  803fae:	90                   	nop
  803faf:	c9                   	leave  
  803fb0:	c3                   	ret    
  803fb1:	66 90                	xchg   %ax,%ax
  803fb3:	90                   	nop

00803fb4 <__udivdi3>:
  803fb4:	55                   	push   %ebp
  803fb5:	57                   	push   %edi
  803fb6:	56                   	push   %esi
  803fb7:	53                   	push   %ebx
  803fb8:	83 ec 1c             	sub    $0x1c,%esp
  803fbb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fbf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fc7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fcb:	89 ca                	mov    %ecx,%edx
  803fcd:	89 f8                	mov    %edi,%eax
  803fcf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fd3:	85 f6                	test   %esi,%esi
  803fd5:	75 2d                	jne    804004 <__udivdi3+0x50>
  803fd7:	39 cf                	cmp    %ecx,%edi
  803fd9:	77 65                	ja     804040 <__udivdi3+0x8c>
  803fdb:	89 fd                	mov    %edi,%ebp
  803fdd:	85 ff                	test   %edi,%edi
  803fdf:	75 0b                	jne    803fec <__udivdi3+0x38>
  803fe1:	b8 01 00 00 00       	mov    $0x1,%eax
  803fe6:	31 d2                	xor    %edx,%edx
  803fe8:	f7 f7                	div    %edi
  803fea:	89 c5                	mov    %eax,%ebp
  803fec:	31 d2                	xor    %edx,%edx
  803fee:	89 c8                	mov    %ecx,%eax
  803ff0:	f7 f5                	div    %ebp
  803ff2:	89 c1                	mov    %eax,%ecx
  803ff4:	89 d8                	mov    %ebx,%eax
  803ff6:	f7 f5                	div    %ebp
  803ff8:	89 cf                	mov    %ecx,%edi
  803ffa:	89 fa                	mov    %edi,%edx
  803ffc:	83 c4 1c             	add    $0x1c,%esp
  803fff:	5b                   	pop    %ebx
  804000:	5e                   	pop    %esi
  804001:	5f                   	pop    %edi
  804002:	5d                   	pop    %ebp
  804003:	c3                   	ret    
  804004:	39 ce                	cmp    %ecx,%esi
  804006:	77 28                	ja     804030 <__udivdi3+0x7c>
  804008:	0f bd fe             	bsr    %esi,%edi
  80400b:	83 f7 1f             	xor    $0x1f,%edi
  80400e:	75 40                	jne    804050 <__udivdi3+0x9c>
  804010:	39 ce                	cmp    %ecx,%esi
  804012:	72 0a                	jb     80401e <__udivdi3+0x6a>
  804014:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804018:	0f 87 9e 00 00 00    	ja     8040bc <__udivdi3+0x108>
  80401e:	b8 01 00 00 00       	mov    $0x1,%eax
  804023:	89 fa                	mov    %edi,%edx
  804025:	83 c4 1c             	add    $0x1c,%esp
  804028:	5b                   	pop    %ebx
  804029:	5e                   	pop    %esi
  80402a:	5f                   	pop    %edi
  80402b:	5d                   	pop    %ebp
  80402c:	c3                   	ret    
  80402d:	8d 76 00             	lea    0x0(%esi),%esi
  804030:	31 ff                	xor    %edi,%edi
  804032:	31 c0                	xor    %eax,%eax
  804034:	89 fa                	mov    %edi,%edx
  804036:	83 c4 1c             	add    $0x1c,%esp
  804039:	5b                   	pop    %ebx
  80403a:	5e                   	pop    %esi
  80403b:	5f                   	pop    %edi
  80403c:	5d                   	pop    %ebp
  80403d:	c3                   	ret    
  80403e:	66 90                	xchg   %ax,%ax
  804040:	89 d8                	mov    %ebx,%eax
  804042:	f7 f7                	div    %edi
  804044:	31 ff                	xor    %edi,%edi
  804046:	89 fa                	mov    %edi,%edx
  804048:	83 c4 1c             	add    $0x1c,%esp
  80404b:	5b                   	pop    %ebx
  80404c:	5e                   	pop    %esi
  80404d:	5f                   	pop    %edi
  80404e:	5d                   	pop    %ebp
  80404f:	c3                   	ret    
  804050:	bd 20 00 00 00       	mov    $0x20,%ebp
  804055:	89 eb                	mov    %ebp,%ebx
  804057:	29 fb                	sub    %edi,%ebx
  804059:	89 f9                	mov    %edi,%ecx
  80405b:	d3 e6                	shl    %cl,%esi
  80405d:	89 c5                	mov    %eax,%ebp
  80405f:	88 d9                	mov    %bl,%cl
  804061:	d3 ed                	shr    %cl,%ebp
  804063:	89 e9                	mov    %ebp,%ecx
  804065:	09 f1                	or     %esi,%ecx
  804067:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80406b:	89 f9                	mov    %edi,%ecx
  80406d:	d3 e0                	shl    %cl,%eax
  80406f:	89 c5                	mov    %eax,%ebp
  804071:	89 d6                	mov    %edx,%esi
  804073:	88 d9                	mov    %bl,%cl
  804075:	d3 ee                	shr    %cl,%esi
  804077:	89 f9                	mov    %edi,%ecx
  804079:	d3 e2                	shl    %cl,%edx
  80407b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80407f:	88 d9                	mov    %bl,%cl
  804081:	d3 e8                	shr    %cl,%eax
  804083:	09 c2                	or     %eax,%edx
  804085:	89 d0                	mov    %edx,%eax
  804087:	89 f2                	mov    %esi,%edx
  804089:	f7 74 24 0c          	divl   0xc(%esp)
  80408d:	89 d6                	mov    %edx,%esi
  80408f:	89 c3                	mov    %eax,%ebx
  804091:	f7 e5                	mul    %ebp
  804093:	39 d6                	cmp    %edx,%esi
  804095:	72 19                	jb     8040b0 <__udivdi3+0xfc>
  804097:	74 0b                	je     8040a4 <__udivdi3+0xf0>
  804099:	89 d8                	mov    %ebx,%eax
  80409b:	31 ff                	xor    %edi,%edi
  80409d:	e9 58 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040a2:	66 90                	xchg   %ax,%ax
  8040a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040a8:	89 f9                	mov    %edi,%ecx
  8040aa:	d3 e2                	shl    %cl,%edx
  8040ac:	39 c2                	cmp    %eax,%edx
  8040ae:	73 e9                	jae    804099 <__udivdi3+0xe5>
  8040b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040b3:	31 ff                	xor    %edi,%edi
  8040b5:	e9 40 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040ba:	66 90                	xchg   %ax,%ax
  8040bc:	31 c0                	xor    %eax,%eax
  8040be:	e9 37 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040c3:	90                   	nop

008040c4 <__umoddi3>:
  8040c4:	55                   	push   %ebp
  8040c5:	57                   	push   %edi
  8040c6:	56                   	push   %esi
  8040c7:	53                   	push   %ebx
  8040c8:	83 ec 1c             	sub    $0x1c,%esp
  8040cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040e3:	89 f3                	mov    %esi,%ebx
  8040e5:	89 fa                	mov    %edi,%edx
  8040e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040eb:	89 34 24             	mov    %esi,(%esp)
  8040ee:	85 c0                	test   %eax,%eax
  8040f0:	75 1a                	jne    80410c <__umoddi3+0x48>
  8040f2:	39 f7                	cmp    %esi,%edi
  8040f4:	0f 86 a2 00 00 00    	jbe    80419c <__umoddi3+0xd8>
  8040fa:	89 c8                	mov    %ecx,%eax
  8040fc:	89 f2                	mov    %esi,%edx
  8040fe:	f7 f7                	div    %edi
  804100:	89 d0                	mov    %edx,%eax
  804102:	31 d2                	xor    %edx,%edx
  804104:	83 c4 1c             	add    $0x1c,%esp
  804107:	5b                   	pop    %ebx
  804108:	5e                   	pop    %esi
  804109:	5f                   	pop    %edi
  80410a:	5d                   	pop    %ebp
  80410b:	c3                   	ret    
  80410c:	39 f0                	cmp    %esi,%eax
  80410e:	0f 87 ac 00 00 00    	ja     8041c0 <__umoddi3+0xfc>
  804114:	0f bd e8             	bsr    %eax,%ebp
  804117:	83 f5 1f             	xor    $0x1f,%ebp
  80411a:	0f 84 ac 00 00 00    	je     8041cc <__umoddi3+0x108>
  804120:	bf 20 00 00 00       	mov    $0x20,%edi
  804125:	29 ef                	sub    %ebp,%edi
  804127:	89 fe                	mov    %edi,%esi
  804129:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80412d:	89 e9                	mov    %ebp,%ecx
  80412f:	d3 e0                	shl    %cl,%eax
  804131:	89 d7                	mov    %edx,%edi
  804133:	89 f1                	mov    %esi,%ecx
  804135:	d3 ef                	shr    %cl,%edi
  804137:	09 c7                	or     %eax,%edi
  804139:	89 e9                	mov    %ebp,%ecx
  80413b:	d3 e2                	shl    %cl,%edx
  80413d:	89 14 24             	mov    %edx,(%esp)
  804140:	89 d8                	mov    %ebx,%eax
  804142:	d3 e0                	shl    %cl,%eax
  804144:	89 c2                	mov    %eax,%edx
  804146:	8b 44 24 08          	mov    0x8(%esp),%eax
  80414a:	d3 e0                	shl    %cl,%eax
  80414c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804150:	8b 44 24 08          	mov    0x8(%esp),%eax
  804154:	89 f1                	mov    %esi,%ecx
  804156:	d3 e8                	shr    %cl,%eax
  804158:	09 d0                	or     %edx,%eax
  80415a:	d3 eb                	shr    %cl,%ebx
  80415c:	89 da                	mov    %ebx,%edx
  80415e:	f7 f7                	div    %edi
  804160:	89 d3                	mov    %edx,%ebx
  804162:	f7 24 24             	mull   (%esp)
  804165:	89 c6                	mov    %eax,%esi
  804167:	89 d1                	mov    %edx,%ecx
  804169:	39 d3                	cmp    %edx,%ebx
  80416b:	0f 82 87 00 00 00    	jb     8041f8 <__umoddi3+0x134>
  804171:	0f 84 91 00 00 00    	je     804208 <__umoddi3+0x144>
  804177:	8b 54 24 04          	mov    0x4(%esp),%edx
  80417b:	29 f2                	sub    %esi,%edx
  80417d:	19 cb                	sbb    %ecx,%ebx
  80417f:	89 d8                	mov    %ebx,%eax
  804181:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804185:	d3 e0                	shl    %cl,%eax
  804187:	89 e9                	mov    %ebp,%ecx
  804189:	d3 ea                	shr    %cl,%edx
  80418b:	09 d0                	or     %edx,%eax
  80418d:	89 e9                	mov    %ebp,%ecx
  80418f:	d3 eb                	shr    %cl,%ebx
  804191:	89 da                	mov    %ebx,%edx
  804193:	83 c4 1c             	add    $0x1c,%esp
  804196:	5b                   	pop    %ebx
  804197:	5e                   	pop    %esi
  804198:	5f                   	pop    %edi
  804199:	5d                   	pop    %ebp
  80419a:	c3                   	ret    
  80419b:	90                   	nop
  80419c:	89 fd                	mov    %edi,%ebp
  80419e:	85 ff                	test   %edi,%edi
  8041a0:	75 0b                	jne    8041ad <__umoddi3+0xe9>
  8041a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041a7:	31 d2                	xor    %edx,%edx
  8041a9:	f7 f7                	div    %edi
  8041ab:	89 c5                	mov    %eax,%ebp
  8041ad:	89 f0                	mov    %esi,%eax
  8041af:	31 d2                	xor    %edx,%edx
  8041b1:	f7 f5                	div    %ebp
  8041b3:	89 c8                	mov    %ecx,%eax
  8041b5:	f7 f5                	div    %ebp
  8041b7:	89 d0                	mov    %edx,%eax
  8041b9:	e9 44 ff ff ff       	jmp    804102 <__umoddi3+0x3e>
  8041be:	66 90                	xchg   %ax,%ax
  8041c0:	89 c8                	mov    %ecx,%eax
  8041c2:	89 f2                	mov    %esi,%edx
  8041c4:	83 c4 1c             	add    $0x1c,%esp
  8041c7:	5b                   	pop    %ebx
  8041c8:	5e                   	pop    %esi
  8041c9:	5f                   	pop    %edi
  8041ca:	5d                   	pop    %ebp
  8041cb:	c3                   	ret    
  8041cc:	3b 04 24             	cmp    (%esp),%eax
  8041cf:	72 06                	jb     8041d7 <__umoddi3+0x113>
  8041d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041d5:	77 0f                	ja     8041e6 <__umoddi3+0x122>
  8041d7:	89 f2                	mov    %esi,%edx
  8041d9:	29 f9                	sub    %edi,%ecx
  8041db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041df:	89 14 24             	mov    %edx,(%esp)
  8041e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041ea:	8b 14 24             	mov    (%esp),%edx
  8041ed:	83 c4 1c             	add    $0x1c,%esp
  8041f0:	5b                   	pop    %ebx
  8041f1:	5e                   	pop    %esi
  8041f2:	5f                   	pop    %edi
  8041f3:	5d                   	pop    %ebp
  8041f4:	c3                   	ret    
  8041f5:	8d 76 00             	lea    0x0(%esi),%esi
  8041f8:	2b 04 24             	sub    (%esp),%eax
  8041fb:	19 fa                	sbb    %edi,%edx
  8041fd:	89 d1                	mov    %edx,%ecx
  8041ff:	89 c6                	mov    %eax,%esi
  804201:	e9 71 ff ff ff       	jmp    804177 <__umoddi3+0xb3>
  804206:	66 90                	xchg   %ax,%ax
  804208:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80420c:	72 ea                	jb     8041f8 <__umoddi3+0x134>
  80420e:	89 d9                	mov    %ebx,%ecx
  804210:	e9 62 ff ff ff       	jmp    804177 <__umoddi3+0xb3>
