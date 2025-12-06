
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 d7 03 00 00       	call   80040d <libmain>
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
  80005c:	68 80 42 80 00       	push   $0x804280
  800061:	6a 13                	push   $0x13
  800063:	68 9c 42 80 00       	push   $0x80429c
  800068:	e8 50 05 00 00       	call   8005bd <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)

	cprintf("STEP A: checking the creation of shared variables... [60%]\n");
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	68 b4 42 80 00       	push   $0x8042b4
  80008a:	e8 fc 07 00 00       	call   80088b <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 57 30 00 00       	call   8030f5 <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 f0 42 80 00       	push   $0x8042f0
  8000b0:	e8 05 1f 00 00       	call   801fba <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 f4 42 80 00       	push   $0x8042f4
  8000d2:	e8 b4 07 00 00       	call   80088b <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 0c 30 00 00       	call   8030f5 <sys_calculate_free_frames>
  8000e9:	29 c3                	sub    %eax,%ebx
  8000eb:	89 d8                	mov    %ebx,%eax
  8000ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000f3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8000f6:	72 0d                	jb     800105 <_main+0xcd>
  8000f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000fb:	8d 50 02             	lea    0x2(%eax),%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	73 27                	jae    80012c <_main+0xf4>
  800105:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80010f:	e8 e1 2f 00 00       	call   8030f5 <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 60 43 80 00       	push   $0x804360
  800124:	e8 62 07 00 00       	call   80088b <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 b3 2f 00 00       	call   8030f5 <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 f8 43 80 00       	push   $0x8043f8
  800154:	e8 61 1e 00 00       	call   801fba <smalloc>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80015f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800162:	05 00 10 00 00       	add    $0x1000,%eax
  800167:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80016a:	74 17                	je     800183 <_main+0x14b>
  80016c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 f4 42 80 00       	push   $0x8042f4
  80017b:	e8 0b 07 00 00       	call   80088b <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 63 2f 00 00       	call   8030f5 <sys_calculate_free_frames>
  800192:	29 c3                	sub    %eax,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800199:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80019c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80019f:	72 0d                	jb     8001ae <_main+0x176>
  8001a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a4:	8d 50 02             	lea    0x2(%eax),%edx
  8001a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001aa:	39 c2                	cmp    %eax,%edx
  8001ac:	73 27                	jae    8001d5 <_main+0x19d>
  8001ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001b8:	e8 38 2f 00 00       	call   8030f5 <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 60 43 80 00       	push   $0x804360
  8001cd:	e8 b9 06 00 00       	call   80088b <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 0a 2f 00 00       	call   8030f5 <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 fa 43 80 00       	push   $0x8043fa
  8001fa:	e8 bb 1d 00 00       	call   801fba <smalloc>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800208:	05 00 30 00 00       	add    $0x3000,%eax
  80020d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800210:	74 17                	je     800229 <_main+0x1f1>
  800212:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 f4 42 80 00       	push   $0x8042f4
  800221:	e8 65 06 00 00       	call   80088b <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 bd 2e 00 00       	call   8030f5 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80023f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800242:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800245:	72 0d                	jb     800254 <_main+0x21c>
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	8d 50 02             	lea    0x2(%eax),%edx
  80024d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800250:	39 c2                	cmp    %eax,%edx
  800252:	73 27                	jae    80027b <_main+0x243>
  800254:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80025e:	e8 92 2e 00 00       	call   8030f5 <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 60 43 80 00       	push   $0x804360
  800273:	e8 13 06 00 00       	call   80088b <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 fc 43 80 00       	push   $0x8043fc
  80028d:	e8 f9 05 00 00       	call   80088b <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 24 44 80 00       	push   $0x804424
  8002a4:	e8 e2 05 00 00       	call   80088b <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8002ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  8002b3:	eb 2d                	jmp    8002e2 <_main+0x2aa>
		{
			x[i] = -1;
  8002b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  8002ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d7:	01 d0                	add    %edx,%eax
  8002d9:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

	is_correct = 1;
	cprintf("STEP B: checking reading & writing... [40%]\n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  8002df:	ff 45 ec             	incl   -0x14(%ebp)
  8002e2:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  8002e9:	7e ca                	jle    8002b5 <_main+0x27d>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  8002eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  8002f2:	eb 18                	jmp    80030c <_main+0x2d4>
		{
			z[i] = -1;
  8002f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800309:	ff 45 ec             	incl   -0x14(%ebp)
  80030c:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800313:	7e df                	jle    8002f4 <_main+0x2bc>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800315:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80031d:	74 17                	je     800336 <_main+0x2fe>
  80031f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	68 54 44 80 00       	push   $0x804454
  80032e:	e8 58 05 00 00       	call   80088b <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800339:	05 fc 0f 00 00       	add    $0xffc,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	83 f8 ff             	cmp    $0xffffffff,%eax
  800343:	74 17                	je     80035c <_main+0x324>
  800345:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 54 44 80 00       	push   $0x804454
  800354:	e8 32 05 00 00       	call   80088b <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp

		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 54 44 80 00       	push   $0x804454
  800375:	e8 11 05 00 00       	call   80088b <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80037d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800380:	05 fc 0f 00 00       	add    $0xffc,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	83 f8 ff             	cmp    $0xffffffff,%eax
  80038a:	74 17                	je     8003a3 <_main+0x36b>
  80038c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	68 54 44 80 00       	push   $0x804454
  80039b:	e8 eb 04 00 00       	call   80088b <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 54 44 80 00       	push   $0x804454
  8003bc:	e8 ca 04 00 00       	call   80088b <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c7:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003d1:	74 17                	je     8003ea <_main+0x3b2>
  8003d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 54 44 80 00       	push   $0x804454
  8003e2:	e8 a4 04 00 00       	call   80088b <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8003ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003ee:	74 04                	je     8003f4 <_main+0x3bc>
		eval += 40 ;
  8003f0:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf("\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003fa:	68 80 44 80 00       	push   $0x804480
  8003ff:	e8 87 04 00 00       	call   80088b <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp

	return;
  800407:	90                   	nop
}
  800408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	57                   	push   %edi
  800411:	56                   	push   %esi
  800412:	53                   	push   %ebx
  800413:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800416:	e8 a3 2e 00 00       	call   8032be <sys_getenvindex>
  80041b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80041e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800421:	89 d0                	mov    %edx,%eax
  800423:	c1 e0 03             	shl    $0x3,%eax
  800426:	01 d0                	add    %edx,%eax
  800428:	c1 e0 02             	shl    $0x2,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	c1 e0 03             	shl    $0x3,%eax
  800439:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800443:	a1 20 50 80 00       	mov    0x805020,%eax
  800448:	8a 40 20             	mov    0x20(%eax),%al
  80044b:	84 c0                	test   %al,%al
  80044d:	74 0d                	je     80045c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80044f:	a1 20 50 80 00       	mov    0x805020,%eax
  800454:	83 c0 20             	add    $0x20,%eax
  800457:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800460:	7e 0a                	jle    80046c <libmain+0x5f>
		binaryname = argv[0];
  800462:	8b 45 0c             	mov    0xc(%ebp),%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 0c             	pushl  0xc(%ebp)
  800472:	ff 75 08             	pushl  0x8(%ebp)
  800475:	e8 be fb ff ff       	call   800038 <_main>
  80047a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80047d:	a1 00 50 80 00       	mov    0x805000,%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	0f 84 01 01 00 00    	je     80058b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80048a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800490:	bb bc 45 80 00       	mov    $0x8045bc,%ebx
  800495:	ba 0e 00 00 00       	mov    $0xe,%edx
  80049a:	89 c7                	mov    %eax,%edi
  80049c:	89 de                	mov    %ebx,%esi
  80049e:	89 d1                	mov    %edx,%ecx
  8004a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004a2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004a5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004aa:	b0 00                	mov    $0x0,%al
  8004ac:	89 d7                	mov    %edx,%edi
  8004ae:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004b0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	50                   	push   %eax
  8004be:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004c4:	50                   	push   %eax
  8004c5:	e8 2a 30 00 00       	call   8034f4 <sys_utilities>
  8004ca:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004cd:	e8 73 2b 00 00       	call   803045 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	68 dc 44 80 00       	push   $0x8044dc
  8004da:	e8 ac 03 00 00       	call   80088b <cprintf>
  8004df:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	85 c0                	test   %eax,%eax
  8004e7:	74 18                	je     800501 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004e9:	e8 24 30 00 00       	call   803512 <sys_get_optimal_num_faults>
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	50                   	push   %eax
  8004f2:	68 04 45 80 00       	push   $0x804504
  8004f7:	e8 8f 03 00 00       	call   80088b <cprintf>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	eb 59                	jmp    80055a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800501:	a1 20 50 80 00       	mov    0x805020,%eax
  800506:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80050c:	a1 20 50 80 00       	mov    0x805020,%eax
  800511:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	52                   	push   %edx
  80051b:	50                   	push   %eax
  80051c:	68 28 45 80 00       	push   $0x804528
  800521:	e8 65 03 00 00       	call   80088b <cprintf>
  800526:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800529:	a1 20 50 80 00       	mov    0x805020,%eax
  80052e:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800534:	a1 20 50 80 00       	mov    0x805020,%eax
  800539:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80053f:	a1 20 50 80 00       	mov    0x805020,%eax
  800544:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	50                   	push   %eax
  80054d:	68 50 45 80 00       	push   $0x804550
  800552:	e8 34 03 00 00       	call   80088b <cprintf>
  800557:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80055a:	a1 20 50 80 00       	mov    0x805020,%eax
  80055f:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	50                   	push   %eax
  800569:	68 a8 45 80 00       	push   $0x8045a8
  80056e:	e8 18 03 00 00       	call   80088b <cprintf>
  800573:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800576:	83 ec 0c             	sub    $0xc,%esp
  800579:	68 dc 44 80 00       	push   $0x8044dc
  80057e:	e8 08 03 00 00       	call   80088b <cprintf>
  800583:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800586:	e8 d4 2a 00 00       	call   80305f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80058b:	e8 1f 00 00 00       	call   8005af <exit>
}
  800590:	90                   	nop
  800591:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800594:	5b                   	pop    %ebx
  800595:	5e                   	pop    %esi
  800596:	5f                   	pop    %edi
  800597:	5d                   	pop    %ebp
  800598:	c3                   	ret    

00800599 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800599:	55                   	push   %ebp
  80059a:	89 e5                	mov    %esp,%ebp
  80059c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	6a 00                	push   $0x0
  8005a4:	e8 e1 2c 00 00       	call   80328a <sys_destroy_env>
  8005a9:	83 c4 10             	add    $0x10,%esp
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <exit>:

void
exit(void)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005b5:	e8 36 2d 00 00       	call   8032f0 <sys_exit_env>
}
  8005ba:	90                   	nop
  8005bb:	c9                   	leave  
  8005bc:	c3                   	ret    

008005bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005bd:	55                   	push   %ebp
  8005be:	89 e5                	mov    %esp,%ebp
  8005c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8005c6:	83 c0 04             	add    $0x4,%eax
  8005c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005cc:	a1 38 51 83 00       	mov    0x835138,%eax
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	74 16                	je     8005eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005d5:	a1 38 51 83 00       	mov    0x835138,%eax
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	50                   	push   %eax
  8005de:	68 20 46 80 00       	push   $0x804620
  8005e3:	e8 a3 02 00 00       	call   80088b <cprintf>
  8005e8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8005eb:	a1 04 50 80 00       	mov    0x805004,%eax
  8005f0:	83 ec 0c             	sub    $0xc,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	ff 75 08             	pushl  0x8(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	68 28 46 80 00       	push   $0x804628
  8005ff:	6a 74                	push   $0x74
  800601:	e8 b2 02 00 00       	call   8008b8 <cprintf_colored>
  800606:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800609:	8b 45 10             	mov    0x10(%ebp),%eax
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	ff 75 f4             	pushl  -0xc(%ebp)
  800612:	50                   	push   %eax
  800613:	e8 04 02 00 00       	call   80081c <vcprintf>
  800618:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	6a 00                	push   $0x0
  800620:	68 50 46 80 00       	push   $0x804650
  800625:	e8 f2 01 00 00       	call   80081c <vcprintf>
  80062a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80062d:	e8 7d ff ff ff       	call   8005af <exit>

	// should not return here
	while (1) ;
  800632:	eb fe                	jmp    800632 <_panic+0x75>

00800634 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80063a:	a1 20 50 80 00       	mov    0x805020,%eax
  80063f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	39 c2                	cmp    %eax,%edx
  80064a:	74 14                	je     800660 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80064c:	83 ec 04             	sub    $0x4,%esp
  80064f:	68 54 46 80 00       	push   $0x804654
  800654:	6a 26                	push   $0x26
  800656:	68 a0 46 80 00       	push   $0x8046a0
  80065b:	e8 5d ff ff ff       	call   8005bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800660:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800667:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80066e:	e9 c5 00 00 00       	jmp    800738 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800676:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	01 d0                	add    %edx,%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	85 c0                	test   %eax,%eax
  800686:	75 08                	jne    800690 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800688:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80068b:	e9 a5 00 00 00       	jmp    800735 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800690:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800697:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80069e:	eb 69                	jmp    800709 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006ae:	89 d0                	mov    %edx,%eax
  8006b0:	01 c0                	add    %eax,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	c1 e0 03             	shl    $0x3,%eax
  8006b7:	01 c8                	add    %ecx,%eax
  8006b9:	8a 40 04             	mov    0x4(%eax),%al
  8006bc:	84 c0                	test   %al,%al
  8006be:	75 46                	jne    800706 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006ce:	89 d0                	mov    %edx,%eax
  8006d0:	01 c0                	add    %eax,%eax
  8006d2:	01 d0                	add    %edx,%eax
  8006d4:	c1 e0 03             	shl    $0x3,%eax
  8006d7:	01 c8                	add    %ecx,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006e6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	01 c8                	add    %ecx,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006f9:	39 c2                	cmp    %eax,%edx
  8006fb:	75 09                	jne    800706 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006fd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800704:	eb 15                	jmp    80071b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800706:	ff 45 e8             	incl   -0x18(%ebp)
  800709:	a1 20 50 80 00       	mov    0x805020,%eax
  80070e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800717:	39 c2                	cmp    %eax,%edx
  800719:	77 85                	ja     8006a0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80071b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80071f:	75 14                	jne    800735 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800721:	83 ec 04             	sub    $0x4,%esp
  800724:	68 ac 46 80 00       	push   $0x8046ac
  800729:	6a 3a                	push   $0x3a
  80072b:	68 a0 46 80 00       	push   $0x8046a0
  800730:	e8 88 fe ff ff       	call   8005bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800735:	ff 45 f0             	incl   -0x10(%ebp)
  800738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073e:	0f 8c 2f ff ff ff    	jl     800673 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800744:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80074b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800752:	eb 26                	jmp    80077a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800754:	a1 20 50 80 00       	mov    0x805020,%eax
  800759:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80075f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800762:	89 d0                	mov    %edx,%eax
  800764:	01 c0                	add    %eax,%eax
  800766:	01 d0                	add    %edx,%eax
  800768:	c1 e0 03             	shl    $0x3,%eax
  80076b:	01 c8                	add    %ecx,%eax
  80076d:	8a 40 04             	mov    0x4(%eax),%al
  800770:	3c 01                	cmp    $0x1,%al
  800772:	75 03                	jne    800777 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800774:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800777:	ff 45 e0             	incl   -0x20(%ebp)
  80077a:	a1 20 50 80 00       	mov    0x805020,%eax
  80077f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800788:	39 c2                	cmp    %eax,%edx
  80078a:	77 c8                	ja     800754 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800792:	74 14                	je     8007a8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 00 47 80 00       	push   $0x804700
  80079c:	6a 44                	push   $0x44
  80079e:	68 a0 46 80 00       	push   $0x8046a0
  8007a3:	e8 15 fe ff ff       	call   8005bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007a8:	90                   	nop
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	8d 48 01             	lea    0x1(%eax),%ecx
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bd:	89 0a                	mov    %ecx,(%edx)
  8007bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c2:	88 d1                	mov    %dl,%cl
  8007c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007d5:	75 30                	jne    800807 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8007d7:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8007dd:	a0 64 d0 81 00       	mov    0x81d064,%al
  8007e2:	0f b6 c0             	movzbl %al,%eax
  8007e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e8:	8b 09                	mov    (%ecx),%ecx
  8007ea:	89 cb                	mov    %ecx,%ebx
  8007ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ef:	83 c1 08             	add    $0x8,%ecx
  8007f2:	52                   	push   %edx
  8007f3:	50                   	push   %eax
  8007f4:	53                   	push   %ebx
  8007f5:	51                   	push   %ecx
  8007f6:	e8 06 28 00 00       	call   803001 <sys_cputs>
  8007fb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800801:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80080a:	8b 40 04             	mov    0x4(%eax),%eax
  80080d:	8d 50 01             	lea    0x1(%eax),%edx
  800810:	8b 45 0c             	mov    0xc(%ebp),%eax
  800813:	89 50 04             	mov    %edx,0x4(%eax)
}
  800816:	90                   	nop
  800817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    

0080081c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800825:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80082c:	00 00 00 
	b.cnt = 0;
  80082f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800836:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 08             	pushl  0x8(%ebp)
  80083f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800845:	50                   	push   %eax
  800846:	68 ab 07 80 00       	push   $0x8007ab
  80084b:	e8 5a 02 00 00       	call   800aaa <vprintfmt>
  800850:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800853:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800859:	a0 64 d0 81 00       	mov    0x81d064,%al
  80085e:	0f b6 c0             	movzbl %al,%eax
  800861:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800867:	52                   	push   %edx
  800868:	50                   	push   %eax
  800869:	51                   	push   %ecx
  80086a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800870:	83 c0 08             	add    $0x8,%eax
  800873:	50                   	push   %eax
  800874:	e8 88 27 00 00       	call   803001 <sys_cputs>
  800879:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80087c:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800883:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800889:	c9                   	leave  
  80088a:	c3                   	ret    

0080088b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800891:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800898:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a7:	50                   	push   %eax
  8008a8:	e8 6f ff ff ff       	call   80081c <vcprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    

008008b8 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008be:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	c1 e0 08             	shl    $0x8,%eax
  8008cb:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  8008d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	e8 34 ff ff ff       	call   80081c <vcprintf>
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8008ee:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  8008f5:	07 00 00 

	return cnt;
  8008f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    

008008fd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800903:	e8 3d 27 00 00       	call   803045 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800908:	8d 45 0c             	lea    0xc(%ebp),%eax
  80090b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 f4             	pushl  -0xc(%ebp)
  800917:	50                   	push   %eax
  800918:	e8 ff fe ff ff       	call   80081c <vcprintf>
  80091d:	83 c4 10             	add    $0x10,%esp
  800920:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800923:	e8 37 27 00 00       	call   80305f <sys_unlock_cons>
	return cnt;
  800928:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	83 ec 14             	sub    $0x14,%esp
  800934:	8b 45 10             	mov    0x10(%ebp),%eax
  800937:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800940:	8b 45 18             	mov    0x18(%ebp),%eax
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
  800948:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80094b:	77 55                	ja     8009a2 <printnum+0x75>
  80094d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800950:	72 05                	jb     800957 <printnum+0x2a>
  800952:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800955:	77 4b                	ja     8009a2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800957:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80095a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80095d:	8b 45 18             	mov    0x18(%ebp),%eax
  800960:	ba 00 00 00 00       	mov    $0x0,%edx
  800965:	52                   	push   %edx
  800966:	50                   	push   %eax
  800967:	ff 75 f4             	pushl  -0xc(%ebp)
  80096a:	ff 75 f0             	pushl  -0x10(%ebp)
  80096d:	e8 a6 36 00 00       	call   804018 <__udivdi3>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	83 ec 04             	sub    $0x4,%esp
  800978:	ff 75 20             	pushl  0x20(%ebp)
  80097b:	53                   	push   %ebx
  80097c:	ff 75 18             	pushl  0x18(%ebp)
  80097f:	52                   	push   %edx
  800980:	50                   	push   %eax
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	ff 75 08             	pushl  0x8(%ebp)
  800987:	e8 a1 ff ff ff       	call   80092d <printnum>
  80098c:	83 c4 20             	add    $0x20,%esp
  80098f:	eb 1a                	jmp    8009ab <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	ff 75 20             	pushl  0x20(%ebp)
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	ff d0                	call   *%eax
  80099f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a2:	ff 4d 1c             	decl   0x1c(%ebp)
  8009a5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009a9:	7f e6                	jg     800991 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009ab:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b9:	53                   	push   %ebx
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	e8 66 37 00 00       	call   804128 <__umoddi3>
  8009c2:	83 c4 10             	add    $0x10,%esp
  8009c5:	05 74 49 80 00       	add    $0x804974,%eax
  8009ca:	8a 00                	mov    (%eax),%al
  8009cc:	0f be c0             	movsbl %al,%eax
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	50                   	push   %eax
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	ff d0                	call   *%eax
  8009db:	83 c4 10             	add    $0x10,%esp
}
  8009de:	90                   	nop
  8009df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009eb:	7e 1c                	jle    800a09 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	8d 50 08             	lea    0x8(%eax),%edx
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	89 10                	mov    %edx,(%eax)
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	83 e8 08             	sub    $0x8,%eax
  800a02:	8b 50 04             	mov    0x4(%eax),%edx
  800a05:	8b 00                	mov    (%eax),%eax
  800a07:	eb 40                	jmp    800a49 <getuint+0x65>
	else if (lflag)
  800a09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0d:	74 1e                	je     800a2d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	8d 50 04             	lea    0x4(%eax),%edx
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	89 10                	mov    %edx,(%eax)
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	83 e8 04             	sub    $0x4,%eax
  800a24:	8b 00                	mov    (%eax),%eax
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	eb 1c                	jmp    800a49 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	8d 50 04             	lea    0x4(%eax),%edx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	89 10                	mov    %edx,(%eax)
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	83 e8 04             	sub    $0x4,%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a4e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a52:	7e 1c                	jle    800a70 <getint+0x25>
		return va_arg(*ap, long long);
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	8d 50 08             	lea    0x8(%eax),%edx
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	89 10                	mov    %edx,(%eax)
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 00                	mov    (%eax),%eax
  800a66:	83 e8 08             	sub    $0x8,%eax
  800a69:	8b 50 04             	mov    0x4(%eax),%edx
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	eb 38                	jmp    800aa8 <getint+0x5d>
	else if (lflag)
  800a70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a74:	74 1a                	je     800a90 <getint+0x45>
		return va_arg(*ap, long);
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	8d 50 04             	lea    0x4(%eax),%edx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	89 10                	mov    %edx,(%eax)
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax
  800a8d:	99                   	cltd   
  800a8e:	eb 18                	jmp    800aa8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	8d 50 04             	lea    0x4(%eax),%edx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	89 10                	mov    %edx,(%eax)
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 00                	mov    (%eax),%eax
  800aa2:	83 e8 04             	sub    $0x4,%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	99                   	cltd   
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
  800aaf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab2:	eb 17                	jmp    800acb <vprintfmt+0x21>
			if (ch == '\0')
  800ab4:	85 db                	test   %ebx,%ebx
  800ab6:	0f 84 c1 03 00 00    	je     800e7d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	53                   	push   %ebx
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800acb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ace:	8d 50 01             	lea    0x1(%eax),%edx
  800ad1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f b6 d8             	movzbl %al,%ebx
  800ad9:	83 fb 25             	cmp    $0x25,%ebx
  800adc:	75 d6                	jne    800ab4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ade:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ae2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ae9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800af0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800af7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800afe:	8b 45 10             	mov    0x10(%ebp),%eax
  800b01:	8d 50 01             	lea    0x1(%eax),%edx
  800b04:	89 55 10             	mov    %edx,0x10(%ebp)
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f b6 d8             	movzbl %al,%ebx
  800b0c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b0f:	83 f8 5b             	cmp    $0x5b,%eax
  800b12:	0f 87 3d 03 00 00    	ja     800e55 <vprintfmt+0x3ab>
  800b18:	8b 04 85 98 49 80 00 	mov    0x804998(,%eax,4),%eax
  800b1f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b21:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b25:	eb d7                	jmp    800afe <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b27:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b2b:	eb d1                	jmp    800afe <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b37:	89 d0                	mov    %edx,%eax
  800b39:	c1 e0 02             	shl    $0x2,%eax
  800b3c:	01 d0                	add    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d8                	add    %ebx,%eax
  800b42:	83 e8 30             	sub    $0x30,%eax
  800b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b48:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4b:	8a 00                	mov    (%eax),%al
  800b4d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b50:	83 fb 2f             	cmp    $0x2f,%ebx
  800b53:	7e 3e                	jle    800b93 <vprintfmt+0xe9>
  800b55:	83 fb 39             	cmp    $0x39,%ebx
  800b58:	7f 39                	jg     800b93 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b5a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b5d:	eb d5                	jmp    800b34 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b62:	83 c0 04             	add    $0x4,%eax
  800b65:	89 45 14             	mov    %eax,0x14(%ebp)
  800b68:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6b:	83 e8 04             	sub    $0x4,%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b73:	eb 1f                	jmp    800b94 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b79:	79 83                	jns    800afe <vprintfmt+0x54>
				width = 0;
  800b7b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b82:	e9 77 ff ff ff       	jmp    800afe <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b87:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b8e:	e9 6b ff ff ff       	jmp    800afe <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b93:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	0f 89 60 ff ff ff    	jns    800afe <vprintfmt+0x54>
				width = precision, precision = -1;
  800b9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ba4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bab:	e9 4e ff ff ff       	jmp    800afe <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bb0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bb3:	e9 46 ff ff ff       	jmp    800afe <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbb:	83 c0 04             	add    $0x4,%eax
  800bbe:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc4:	83 e8 04             	sub    $0x4,%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	ff 75 0c             	pushl  0xc(%ebp)
  800bcf:	50                   	push   %eax
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	ff d0                	call   *%eax
  800bd5:	83 c4 10             	add    $0x10,%esp
			break;
  800bd8:	e9 9b 02 00 00       	jmp    800e78 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800be0:	83 c0 04             	add    $0x4,%eax
  800be3:	89 45 14             	mov    %eax,0x14(%ebp)
  800be6:	8b 45 14             	mov    0x14(%ebp),%eax
  800be9:	83 e8 04             	sub    $0x4,%eax
  800bec:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bee:	85 db                	test   %ebx,%ebx
  800bf0:	79 02                	jns    800bf4 <vprintfmt+0x14a>
				err = -err;
  800bf2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bf4:	83 fb 64             	cmp    $0x64,%ebx
  800bf7:	7f 0b                	jg     800c04 <vprintfmt+0x15a>
  800bf9:	8b 34 9d e0 47 80 00 	mov    0x8047e0(,%ebx,4),%esi
  800c00:	85 f6                	test   %esi,%esi
  800c02:	75 19                	jne    800c1d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c04:	53                   	push   %ebx
  800c05:	68 85 49 80 00       	push   $0x804985
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 70 02 00 00       	call   800e85 <printfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c18:	e9 5b 02 00 00       	jmp    800e78 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c1d:	56                   	push   %esi
  800c1e:	68 8e 49 80 00       	push   $0x80498e
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	ff 75 08             	pushl  0x8(%ebp)
  800c29:	e8 57 02 00 00       	call   800e85 <printfmt>
  800c2e:	83 c4 10             	add    $0x10,%esp
			break;
  800c31:	e9 42 02 00 00       	jmp    800e78 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 30                	mov    (%eax),%esi
  800c47:	85 f6                	test   %esi,%esi
  800c49:	75 05                	jne    800c50 <vprintfmt+0x1a6>
				p = "(null)";
  800c4b:	be 91 49 80 00       	mov    $0x804991,%esi
			if (width > 0 && padc != '-')
  800c50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c54:	7e 6d                	jle    800cc3 <vprintfmt+0x219>
  800c56:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c5a:	74 67                	je     800cc3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	50                   	push   %eax
  800c63:	56                   	push   %esi
  800c64:	e8 1e 03 00 00       	call   800f87 <strnlen>
  800c69:	83 c4 10             	add    $0x10,%esp
  800c6c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c6f:	eb 16                	jmp    800c87 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c71:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	50                   	push   %eax
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c84:	ff 4d e4             	decl   -0x1c(%ebp)
  800c87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8b:	7f e4                	jg     800c71 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c8d:	eb 34                	jmp    800cc3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c93:	74 1c                	je     800cb1 <vprintfmt+0x207>
  800c95:	83 fb 1f             	cmp    $0x1f,%ebx
  800c98:	7e 05                	jle    800c9f <vprintfmt+0x1f5>
  800c9a:	83 fb 7e             	cmp    $0x7e,%ebx
  800c9d:	7e 12                	jle    800cb1 <vprintfmt+0x207>
					putch('?', putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	6a 3f                	push   $0x3f
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	ff d0                	call   *%eax
  800cac:	83 c4 10             	add    $0x10,%esp
  800caf:	eb 0f                	jmp    800cc0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	53                   	push   %ebx
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cc0:	ff 4d e4             	decl   -0x1c(%ebp)
  800cc3:	89 f0                	mov    %esi,%eax
  800cc5:	8d 70 01             	lea    0x1(%eax),%esi
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	0f be d8             	movsbl %al,%ebx
  800ccd:	85 db                	test   %ebx,%ebx
  800ccf:	74 24                	je     800cf5 <vprintfmt+0x24b>
  800cd1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cd5:	78 b8                	js     800c8f <vprintfmt+0x1e5>
  800cd7:	ff 4d e0             	decl   -0x20(%ebp)
  800cda:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cde:	79 af                	jns    800c8f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce0:	eb 13                	jmp    800cf5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 20                	push   $0x20
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf2:	ff 4d e4             	decl   -0x1c(%ebp)
  800cf5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf9:	7f e7                	jg     800ce2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cfb:	e9 78 01 00 00       	jmp    800e78 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d00:	83 ec 08             	sub    $0x8,%esp
  800d03:	ff 75 e8             	pushl  -0x18(%ebp)
  800d06:	8d 45 14             	lea    0x14(%ebp),%eax
  800d09:	50                   	push   %eax
  800d0a:	e8 3c fd ff ff       	call   800a4b <getint>
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d15:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d1e:	85 d2                	test   %edx,%edx
  800d20:	79 23                	jns    800d45 <vprintfmt+0x29b>
				putch('-', putdat);
  800d22:	83 ec 08             	sub    $0x8,%esp
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	6a 2d                	push   $0x2d
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	ff d0                	call   *%eax
  800d2f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d38:	f7 d8                	neg    %eax
  800d3a:	83 d2 00             	adc    $0x0,%edx
  800d3d:	f7 da                	neg    %edx
  800d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d45:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d4c:	e9 bc 00 00 00       	jmp    800e0d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	ff 75 e8             	pushl  -0x18(%ebp)
  800d57:	8d 45 14             	lea    0x14(%ebp),%eax
  800d5a:	50                   	push   %eax
  800d5b:	e8 84 fc ff ff       	call   8009e4 <getuint>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d69:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d70:	e9 98 00 00 00       	jmp    800e0d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 0c             	pushl  0xc(%ebp)
  800d7b:	6a 58                	push   $0x58
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d85:	83 ec 08             	sub    $0x8,%esp
  800d88:	ff 75 0c             	pushl  0xc(%ebp)
  800d8b:	6a 58                	push   $0x58
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	ff d0                	call   *%eax
  800d92:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 58                	push   $0x58
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			break;
  800da5:	e9 ce 00 00 00       	jmp    800e78 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	6a 30                	push   $0x30
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	ff d0                	call   *%eax
  800db7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	6a 78                	push   $0x78
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800dca:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcd:	83 c0 04             	add    $0x4,%eax
  800dd0:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	83 e8 04             	sub    $0x4,%eax
  800dd9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800de5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800dec:	eb 1f                	jmp    800e0d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 e8             	pushl  -0x18(%ebp)
  800df4:	8d 45 14             	lea    0x14(%ebp),%eax
  800df7:	50                   	push   %eax
  800df8:	e8 e7 fb ff ff       	call   8009e4 <getuint>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e06:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e0d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e14:	83 ec 04             	sub    $0x4,%esp
  800e17:	52                   	push   %edx
  800e18:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	ff 75 08             	pushl  0x8(%ebp)
  800e28:	e8 00 fb ff ff       	call   80092d <printnum>
  800e2d:	83 c4 20             	add    $0x20,%esp
			break;
  800e30:	eb 46                	jmp    800e78 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	53                   	push   %ebx
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	ff d0                	call   *%eax
  800e3e:	83 c4 10             	add    $0x10,%esp
			break;
  800e41:	eb 35                	jmp    800e78 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e43:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800e4a:	eb 2c                	jmp    800e78 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e4c:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800e53:	eb 23                	jmp    800e78 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e55:	83 ec 08             	sub    $0x8,%esp
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	6a 25                	push   $0x25
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	ff d0                	call   *%eax
  800e62:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e65:	ff 4d 10             	decl   0x10(%ebp)
  800e68:	eb 03                	jmp    800e6d <vprintfmt+0x3c3>
  800e6a:	ff 4d 10             	decl   0x10(%ebp)
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	48                   	dec    %eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	3c 25                	cmp    $0x25,%al
  800e75:	75 f3                	jne    800e6a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e77:	90                   	nop
		}
	}
  800e78:	e9 35 fc ff ff       	jmp    800ab2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e7d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e8b:	8d 45 10             	lea    0x10(%ebp),%eax
  800e8e:	83 c0 04             	add    $0x4,%eax
  800e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e94:	8b 45 10             	mov    0x10(%ebp),%eax
  800e97:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9a:	50                   	push   %eax
  800e9b:	ff 75 0c             	pushl  0xc(%ebp)
  800e9e:	ff 75 08             	pushl  0x8(%ebp)
  800ea1:	e8 04 fc ff ff       	call   800aaa <vprintfmt>
  800ea6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ea9:	90                   	nop
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	8b 40 08             	mov    0x8(%eax),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 10                	mov    (%eax),%edx
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	8b 40 04             	mov    0x4(%eax),%eax
  800ec9:	39 c2                	cmp    %eax,%edx
  800ecb:	73 12                	jae    800edf <sprintputch+0x33>
		*b->buf++ = ch;
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	8b 00                	mov    (%eax),%eax
  800ed2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed8:	89 0a                	mov    %ecx,(%edx)
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	88 10                	mov    %dl,(%eax)
}
  800edf:	90                   	nop
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    

00800ee2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	01 d0                	add    %edx,%eax
  800ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f07:	74 06                	je     800f0f <vsnprintf+0x2d>
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	7f 07                	jg     800f16 <vsnprintf+0x34>
		return -E_INVAL;
  800f0f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f14:	eb 20                	jmp    800f36 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f16:	ff 75 14             	pushl  0x14(%ebp)
  800f19:	ff 75 10             	pushl  0x10(%ebp)
  800f1c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f1f:	50                   	push   %eax
  800f20:	68 ac 0e 80 00       	push   $0x800eac
  800f25:	e8 80 fb ff ff       	call   800aaa <vprintfmt>
  800f2a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f30:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 89 ff ff ff       	call   800ee2 <vsnprintf>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f71:	eb 06                	jmp    800f79 <strlen+0x15>
		n++;
  800f73:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f76:	ff 45 08             	incl   0x8(%ebp)
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	84 c0                	test   %al,%al
  800f80:	75 f1                	jne    800f73 <strlen+0xf>
		n++;
	return n;
  800f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    

00800f87 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f94:	eb 09                	jmp    800f9f <strnlen+0x18>
		n++;
  800f96:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	ff 4d 0c             	decl   0xc(%ebp)
  800f9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa3:	74 09                	je     800fae <strnlen+0x27>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	75 e8                	jne    800f96 <strnlen+0xf>
		n++;
	return n;
  800fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fbf:	90                   	nop
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8d 50 01             	lea    0x1(%eax),%edx
  800fc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fcf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fd2:	8a 12                	mov    (%edx),%dl
  800fd4:	88 10                	mov    %dl,(%eax)
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	84 c0                	test   %al,%al
  800fda:	75 e4                	jne    800fc0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff4:	eb 1f                	jmp    801015 <strncpy+0x34>
		*dst++ = *src;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8d 50 01             	lea    0x1(%eax),%edx
  800ffc:	89 55 08             	mov    %edx,0x8(%ebp)
  800fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801002:	8a 12                	mov    (%edx),%dl
  801004:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	74 03                	je     801012 <strncpy+0x31>
			src++;
  80100f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801012:	ff 45 fc             	incl   -0x4(%ebp)
  801015:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801018:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101b:	72 d9                	jb     800ff6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80102e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801032:	74 30                	je     801064 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801034:	eb 16                	jmp    80104c <strlcpy+0x2a>
			*dst++ = *src++;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8d 50 01             	lea    0x1(%eax),%edx
  80103c:	89 55 08             	mov    %edx,0x8(%ebp)
  80103f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801042:	8d 4a 01             	lea    0x1(%edx),%ecx
  801045:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801048:	8a 12                	mov    (%edx),%dl
  80104a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80104c:	ff 4d 10             	decl   0x10(%ebp)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	74 09                	je     80105e <strlcpy+0x3c>
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	84 c0                	test   %al,%al
  80105c:	75 d8                	jne    801036 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106a:	29 c2                	sub    %eax,%edx
  80106c:	89 d0                	mov    %edx,%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801073:	eb 06                	jmp    80107b <strcmp+0xb>
		p++, q++;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	84 c0                	test   %al,%al
  801082:	74 0e                	je     801092 <strcmp+0x22>
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 10                	mov    (%eax),%dl
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	38 c2                	cmp    %al,%dl
  801090:	74 e3                	je     801075 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	0f b6 d0             	movzbl %al,%edx
  80109a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	0f b6 c0             	movzbl %al,%eax
  8010a2:	29 c2                	sub    %eax,%edx
  8010a4:	89 d0                	mov    %edx,%eax
}
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010ab:	eb 09                	jmp    8010b6 <strncmp+0xe>
		n--, p++, q++;
  8010ad:	ff 4d 10             	decl   0x10(%ebp)
  8010b0:	ff 45 08             	incl   0x8(%ebp)
  8010b3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ba:	74 17                	je     8010d3 <strncmp+0x2b>
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	84 c0                	test   %al,%al
  8010c3:	74 0e                	je     8010d3 <strncmp+0x2b>
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8a 10                	mov    (%eax),%dl
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	38 c2                	cmp    %al,%dl
  8010d1:	74 da                	je     8010ad <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d7:	75 07                	jne    8010e0 <strncmp+0x38>
		return 0;
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010de:	eb 14                	jmp    8010f4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	0f b6 d0             	movzbl %al,%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f b6 c0             	movzbl %al,%eax
  8010f0:	29 c2                	sub    %eax,%edx
  8010f2:	89 d0                	mov    %edx,%eax
}
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801102:	eb 12                	jmp    801116 <strchr+0x20>
		if (*s == c)
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80110c:	75 05                	jne    801113 <strchr+0x1d>
			return (char *) s;
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	eb 11                	jmp    801124 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801113:	ff 45 08             	incl   0x8(%ebp)
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	84 c0                	test   %al,%al
  80111d:	75 e5                	jne    801104 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80111f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 04             	sub    $0x4,%esp
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801132:	eb 0d                	jmp    801141 <strfind+0x1b>
		if (*s == c)
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80113c:	74 0e                	je     80114c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	75 ea                	jne    801134 <strfind+0xe>
  80114a:	eb 01                	jmp    80114d <strfind+0x27>
		if (*s == c)
			break;
  80114c:	90                   	nop
	return (char *) s;
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80115e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801162:	76 63                	jbe    8011c7 <memset+0x75>
		uint64 data_block = c;
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	99                   	cltd   
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80116e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801174:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801178:	c1 e0 08             	shl    $0x8,%eax
  80117b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80117e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801187:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80118b:	c1 e0 10             	shl    $0x10,%eax
  80118e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801191:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119a:	89 c2                	mov    %eax,%edx
  80119c:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011a4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011a7:	eb 18                	jmp    8011c1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ac:	8d 41 08             	lea    0x8(%ecx),%eax
  8011af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b8:	89 01                	mov    %eax,(%ecx)
  8011ba:	89 51 04             	mov    %edx,0x4(%ecx)
  8011bd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8011c1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011c5:	77 e2                	ja     8011a9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8011c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cb:	74 23                	je     8011f0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011d3:	eb 0e                	jmp    8011e3 <memset+0x91>
			*p8++ = (uint8)c;
  8011d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d8:	8d 50 01             	lea    0x1(%eax),%edx
  8011db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	75 e5                	jne    8011d5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801207:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80120b:	76 24                	jbe    801231 <memcpy+0x3c>
		while(n >= 8){
  80120d:	eb 1c                	jmp    80122b <memcpy+0x36>
			*d64 = *s64;
  80120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801212:	8b 50 04             	mov    0x4(%eax),%edx
  801215:	8b 00                	mov    (%eax),%eax
  801217:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80121a:	89 01                	mov    %eax,(%ecx)
  80121c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80121f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801223:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801227:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80122b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80122f:	77 de                	ja     80120f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801231:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801235:	74 31                	je     801268 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801237:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801243:	eb 16                	jmp    80125b <memcpy+0x66>
			*d8++ = *s8++;
  801245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80124e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801251:	8d 4a 01             	lea    0x1(%edx),%ecx
  801254:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801257:	8a 12                	mov    (%edx),%dl
  801259:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801261:	89 55 10             	mov    %edx,0x10(%ebp)
  801264:	85 c0                	test   %eax,%eax
  801266:	75 dd                	jne    801245 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80127f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801282:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801285:	73 50                	jae    8012d7 <memmove+0x6a>
  801287:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128a:	8b 45 10             	mov    0x10(%ebp),%eax
  80128d:	01 d0                	add    %edx,%eax
  80128f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801292:	76 43                	jbe    8012d7 <memmove+0x6a>
		s += n;
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129a:	8b 45 10             	mov    0x10(%ebp),%eax
  80129d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a0:	eb 10                	jmp    8012b2 <memmove+0x45>
			*--d = *--s;
  8012a2:	ff 4d f8             	decl   -0x8(%ebp)
  8012a5:	ff 4d fc             	decl   -0x4(%ebp)
  8012a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ab:	8a 10                	mov    (%eax),%dl
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	75 e3                	jne    8012a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012bf:	eb 23                	jmp    8012e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012fb:	eb 2a                	jmp    801327 <memcmp+0x3e>
		if (*s1 != *s2)
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 10                	mov    (%eax),%dl
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8a 00                	mov    (%eax),%al
  801307:	38 c2                	cmp    %al,%dl
  801309:	74 16                	je     801321 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	0f b6 d0             	movzbl %al,%edx
  801313:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f b6 c0             	movzbl %al,%eax
  80131b:	29 c2                	sub    %eax,%edx
  80131d:	89 d0                	mov    %edx,%eax
  80131f:	eb 18                	jmp    801339 <memcmp+0x50>
		s1++, s2++;
  801321:	ff 45 fc             	incl   -0x4(%ebp)
  801324:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132d:	89 55 10             	mov    %edx,0x10(%ebp)
  801330:	85 c0                	test   %eax,%eax
  801332:	75 c9                	jne    8012fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801334:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801341:	8b 55 08             	mov    0x8(%ebp),%edx
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80134c:	eb 15                	jmp    801363 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	0f b6 d0             	movzbl %al,%edx
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	39 c2                	cmp    %eax,%edx
  80135e:	74 0d                	je     80136d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801360:	ff 45 08             	incl   0x8(%ebp)
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801369:	72 e3                	jb     80134e <memfind+0x13>
  80136b:	eb 01                	jmp    80136e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80136d:	90                   	nop
	return (void *) s;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801379:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801380:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801387:	eb 03                	jmp    80138c <strtol+0x19>
		s++;
  801389:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	3c 20                	cmp    $0x20,%al
  801393:	74 f4                	je     801389 <strtol+0x16>
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	3c 09                	cmp    $0x9,%al
  80139c:	74 eb                	je     801389 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2b                	cmp    $0x2b,%al
  8013a5:	75 05                	jne    8013ac <strtol+0x39>
		s++;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	eb 13                	jmp    8013bf <strtol+0x4c>
	else if (*s == '-')
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	3c 2d                	cmp    $0x2d,%al
  8013b3:	75 0a                	jne    8013bf <strtol+0x4c>
		s++, neg = 1;
  8013b5:	ff 45 08             	incl   0x8(%ebp)
  8013b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c3:	74 06                	je     8013cb <strtol+0x58>
  8013c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013c9:	75 20                	jne    8013eb <strtol+0x78>
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	3c 30                	cmp    $0x30,%al
  8013d2:	75 17                	jne    8013eb <strtol+0x78>
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	40                   	inc    %eax
  8013d8:	8a 00                	mov    (%eax),%al
  8013da:	3c 78                	cmp    $0x78,%al
  8013dc:	75 0d                	jne    8013eb <strtol+0x78>
		s += 2, base = 16;
  8013de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013e9:	eb 28                	jmp    801413 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ef:	75 15                	jne    801406 <strtol+0x93>
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	3c 30                	cmp    $0x30,%al
  8013f8:	75 0c                	jne    801406 <strtol+0x93>
		s++, base = 8;
  8013fa:	ff 45 08             	incl   0x8(%ebp)
  8013fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801404:	eb 0d                	jmp    801413 <strtol+0xa0>
	else if (base == 0)
  801406:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140a:	75 07                	jne    801413 <strtol+0xa0>
		base = 10;
  80140c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 2f                	cmp    $0x2f,%al
  80141a:	7e 19                	jle    801435 <strtol+0xc2>
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	3c 39                	cmp    $0x39,%al
  801423:	7f 10                	jg     801435 <strtol+0xc2>
			dig = *s - '0';
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	0f be c0             	movsbl %al,%eax
  80142d:	83 e8 30             	sub    $0x30,%eax
  801430:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801433:	eb 42                	jmp    801477 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	3c 60                	cmp    $0x60,%al
  80143c:	7e 19                	jle    801457 <strtol+0xe4>
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	3c 7a                	cmp    $0x7a,%al
  801445:	7f 10                	jg     801457 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	0f be c0             	movsbl %al,%eax
  80144f:	83 e8 57             	sub    $0x57,%eax
  801452:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801455:	eb 20                	jmp    801477 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	3c 40                	cmp    $0x40,%al
  80145e:	7e 39                	jle    801499 <strtol+0x126>
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	3c 5a                	cmp    $0x5a,%al
  801467:	7f 30                	jg     801499 <strtol+0x126>
			dig = *s - 'A' + 10;
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	0f be c0             	movsbl %al,%eax
  801471:	83 e8 37             	sub    $0x37,%eax
  801474:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80147d:	7d 19                	jge    801498 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80147f:	ff 45 08             	incl   0x8(%ebp)
  801482:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801485:	0f af 45 10          	imul   0x10(%ebp),%eax
  801489:	89 c2                	mov    %eax,%edx
  80148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801493:	e9 7b ff ff ff       	jmp    801413 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801498:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801499:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80149d:	74 08                	je     8014a7 <strtol+0x134>
		*endptr = (char *) s;
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ab:	74 07                	je     8014b4 <strtol+0x141>
  8014ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b0:	f7 d8                	neg    %eax
  8014b2:	eb 03                	jmp    8014b7 <strtol+0x144>
  8014b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d1:	79 13                	jns    8014e6 <ltostr+0x2d>
	{
		neg = 1;
  8014d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014ee:	99                   	cltd   
  8014ef:	f7 f9                	idiv   %ecx
  8014f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f7:	8d 50 01             	lea    0x1(%eax),%edx
  8014fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801502:	01 d0                	add    %edx,%eax
  801504:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801507:	83 c2 30             	add    $0x30,%edx
  80150a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80150c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801514:	f7 e9                	imul   %ecx
  801516:	c1 fa 02             	sar    $0x2,%edx
  801519:	89 c8                	mov    %ecx,%eax
  80151b:	c1 f8 1f             	sar    $0x1f,%eax
  80151e:	29 c2                	sub    %eax,%edx
  801520:	89 d0                	mov    %edx,%eax
  801522:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801525:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801529:	75 bb                	jne    8014e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80152b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801532:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801535:	48                   	dec    %eax
  801536:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801539:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80153d:	74 3d                	je     80157c <ltostr+0xc3>
		start = 1 ;
  80153f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801546:	eb 34                	jmp    80157c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	01 d0                	add    %edx,%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801555:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	01 c2                	add    %eax,%edx
  80155d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801560:	8b 45 0c             	mov    0xc(%ebp),%eax
  801563:	01 c8                	add    %ecx,%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801569:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	01 c2                	add    %eax,%edx
  801571:	8a 45 eb             	mov    -0x15(%ebp),%al
  801574:	88 02                	mov    %al,(%edx)
		start++ ;
  801576:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801579:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801582:	7c c4                	jl     801548 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801584:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	01 d0                	add    %edx,%eax
  80158c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80158f:	90                   	nop
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 c4 f9 ff ff       	call   800f64 <strlen>
  8015a0:	83 c4 04             	add    $0x4,%esp
  8015a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015a6:	ff 75 0c             	pushl  0xc(%ebp)
  8015a9:	e8 b6 f9 ff ff       	call   800f64 <strlen>
  8015ae:	83 c4 04             	add    $0x4,%esp
  8015b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c2:	eb 17                	jmp    8015db <strcconcat+0x49>
		final[s] = str1[s] ;
  8015c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	01 c2                	add    %eax,%edx
  8015cc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	01 c8                	add    %ecx,%eax
  8015d4:	8a 00                	mov    (%eax),%al
  8015d6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015d8:	ff 45 fc             	incl   -0x4(%ebp)
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015e1:	7c e1                	jl     8015c4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015f1:	eb 1f                	jmp    801612 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f6:	8d 50 01             	lea    0x1(%eax),%edx
  8015f9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015fc:	89 c2                	mov    %eax,%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 c2                	add    %eax,%edx
  801603:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	01 c8                	add    %ecx,%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80160f:	ff 45 f8             	incl   -0x8(%ebp)
  801612:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801615:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801618:	7c d9                	jl     8015f3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80161a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161d:	8b 45 10             	mov    0x10(%ebp),%eax
  801620:	01 d0                	add    %edx,%eax
  801622:	c6 00 00             	movb   $0x0,(%eax)
}
  801625:	90                   	nop
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80162b:	8b 45 14             	mov    0x14(%ebp),%eax
  80162e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801634:	8b 45 14             	mov    0x14(%ebp),%eax
  801637:	8b 00                	mov    (%eax),%eax
  801639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164b:	eb 0c                	jmp    801659 <strsplit+0x31>
			*string++ = 0;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	8d 50 01             	lea    0x1(%eax),%edx
  801653:	89 55 08             	mov    %edx,0x8(%ebp)
  801656:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8a 00                	mov    (%eax),%al
  80165e:	84 c0                	test   %al,%al
  801660:	74 18                	je     80167a <strsplit+0x52>
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f be c0             	movsbl %al,%eax
  80166a:	50                   	push   %eax
  80166b:	ff 75 0c             	pushl  0xc(%ebp)
  80166e:	e8 83 fa ff ff       	call   8010f6 <strchr>
  801673:	83 c4 08             	add    $0x8,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	75 d3                	jne    80164d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8a 00                	mov    (%eax),%al
  80167f:	84 c0                	test   %al,%al
  801681:	74 5a                	je     8016dd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801683:	8b 45 14             	mov    0x14(%ebp),%eax
  801686:	8b 00                	mov    (%eax),%eax
  801688:	83 f8 0f             	cmp    $0xf,%eax
  80168b:	75 07                	jne    801694 <strsplit+0x6c>
		{
			return 0;
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
  801692:	eb 66                	jmp    8016fa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 48 01             	lea    0x1(%eax),%ecx
  80169c:	8b 55 14             	mov    0x14(%ebp),%edx
  80169f:	89 0a                	mov    %ecx,(%edx)
  8016a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ab:	01 c2                	add    %eax,%edx
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b2:	eb 03                	jmp    8016b7 <strsplit+0x8f>
			string++;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	84 c0                	test   %al,%al
  8016be:	74 8b                	je     80164b <strsplit+0x23>
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	0f be c0             	movsbl %al,%eax
  8016c8:	50                   	push   %eax
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	e8 25 fa ff ff       	call   8010f6 <strchr>
  8016d1:	83 c4 08             	add    $0x8,%esp
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	74 dc                	je     8016b4 <strsplit+0x8c>
			string++;
	}
  8016d8:	e9 6e ff ff ff       	jmp    80164b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016dd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016de:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e1:	8b 00                	mov    (%eax),%eax
  8016e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ed:	01 d0                	add    %edx,%eax
  8016ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016f5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801708:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80170f:	eb 4a                	jmp    80175b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801711:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	01 c2                	add    %eax,%edx
  801719:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	01 c8                	add    %ecx,%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801725:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	01 d0                	add    %edx,%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	3c 40                	cmp    $0x40,%al
  801731:	7e 25                	jle    801758 <str2lower+0x5c>
  801733:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801736:	8b 45 0c             	mov    0xc(%ebp),%eax
  801739:	01 d0                	add    %edx,%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	3c 5a                	cmp    $0x5a,%al
  80173f:	7f 17                	jg     801758 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801741:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80174c:	8b 55 08             	mov    0x8(%ebp),%edx
  80174f:	01 ca                	add    %ecx,%edx
  801751:	8a 12                	mov    (%edx),%dl
  801753:	83 c2 20             	add    $0x20,%edx
  801756:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801758:	ff 45 fc             	incl   -0x4(%ebp)
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	e8 01 f8 ff ff       	call   800f64 <strlen>
  801763:	83 c4 04             	add    $0x4,%esp
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	7f a6                	jg     801711 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80176b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801776:	a1 08 50 80 00       	mov    0x805008,%eax
  80177b:	85 c0                	test   %eax,%eax
  80177d:	74 42                	je     8017c1 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80177f:	83 ec 08             	sub    $0x8,%esp
  801782:	68 00 00 00 82       	push   $0x82000000
  801787:	68 00 00 00 80       	push   $0x80000000
  80178c:	e8 b0 1e 00 00       	call   803641 <initialize_dynamic_allocator>
  801791:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801794:	e8 96 1c 00 00       	call   80342f <sys_get_uheap_strategy>
  801799:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80179e:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8017a3:	05 00 10 00 00       	add    $0x1000,%eax
  8017a8:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8017ad:	a1 30 51 83 00       	mov    0x835130,%eax
  8017b2:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8017b7:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8017be:	00 00 00 
	}
}
  8017c1:	90                   	nop
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d8:	83 ec 08             	sub    $0x8,%esp
  8017db:	68 06 04 00 00       	push   $0x406
  8017e0:	50                   	push   %eax
  8017e1:	e8 93 18 00 00       	call   803079 <__sys_allocate_page>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f0:	79 14                	jns    801806 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 08 4b 80 00       	push   $0x804b08
  8017fa:	6a 1f                	push   $0x1f
  8017fc:	68 44 4b 80 00       	push   $0x804b44
  801801:	e8 b7 ed ff ff       	call   8005bd <_panic>
	return 0;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	50                   	push   %eax
  801825:	e8 96 18 00 00       	call   8030c0 <__sys_unmap_frame>
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801830:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801834:	79 14                	jns    80184a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	68 50 4b 80 00       	push   $0x804b50
  80183e:	6a 2a                	push   $0x2a
  801840:	68 44 4b 80 00       	push   $0x804b44
  801845:	e8 73 ed ff ff       	call   8005bd <_panic>
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801853:	e8 18 ff ff ff       	call   801770 <uheap_init>
	if (size == 0) return NULL ;
  801858:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80185c:	75 0a                	jne    801868 <malloc+0x1b>
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
  801863:	e9 43 03 00 00       	jmp    801bab <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801868:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80186f:	77 13                	ja     801884 <malloc+0x37>
    {
        return alloc_block(size);
  801871:	83 ec 0c             	sub    $0xc,%esp
  801874:	ff 75 08             	pushl  0x8(%ebp)
  801877:	e8 78 20 00 00       	call   8038f4 <alloc_block>
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	e9 27 03 00 00       	jmp    801bab <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801884:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80188b:	8b 55 08             	mov    0x8(%ebp),%edx
  80188e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	48                   	dec    %eax
  801894:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801897:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80189a:	ba 00 00 00 00       	mov    $0x0,%edx
  80189f:	f7 75 dc             	divl   -0x24(%ebp)
  8018a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018a5:	29 d0                	sub    %edx,%eax
  8018a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8018aa:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 0a                	jne    8018bd <malloc+0x70>
    {
        uhp_inited = 1;
  8018b3:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8018ba:	00 00 00 
    }

    int exactIdx = -1;
  8018bd:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8018c4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8018cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8018d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018d9:	e9 85 00 00 00       	jmp    801963 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8018de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018e1:	89 d0                	mov    %edx,%eax
  8018e3:	01 c0                	add    %eax,%eax
  8018e5:	01 d0                	add    %edx,%eax
  8018e7:	c1 e0 02             	shl    $0x2,%eax
  8018ea:	05 48 10 81 00       	add    $0x811048,%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	74 20                	je     801915 <malloc+0xc8>
  8018f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	01 c0                	add    %eax,%eax
  8018fc:	01 d0                	add    %edx,%eax
  8018fe:	c1 e0 02             	shl    $0x2,%eax
  801901:	05 44 10 81 00       	add    $0x811044,%eax
  801906:	8b 00                	mov    (%eax),%eax
  801908:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80190b:	75 08                	jne    801915 <malloc+0xc8>
        {
            exactIdx = i;
  80190d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801910:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801913:	eb 5b                	jmp    801970 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801915:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801918:	89 d0                	mov    %edx,%eax
  80191a:	01 c0                	add    %eax,%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c1 e0 02             	shl    $0x2,%eax
  801921:	05 48 10 81 00       	add    $0x811048,%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	84 c0                	test   %al,%al
  80192a:	74 34                	je     801960 <malloc+0x113>
  80192c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80192f:	89 d0                	mov    %edx,%eax
  801931:	01 c0                	add    %eax,%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	c1 e0 02             	shl    $0x2,%eax
  801938:	05 44 10 81 00       	add    $0x811044,%eax
  80193d:	8b 00                	mov    (%eax),%eax
  80193f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801942:	76 1c                	jbe    801960 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801944:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801947:	89 d0                	mov    %edx,%eax
  801949:	01 c0                	add    %eax,%eax
  80194b:	01 d0                	add    %edx,%eax
  80194d:	c1 e0 02             	shl    $0x2,%eax
  801950:	05 44 10 81 00       	add    $0x811044,%eax
  801955:	8b 00                	mov    (%eax),%eax
  801957:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80195a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801960:	ff 45 e8             	incl   -0x18(%ebp)
  801963:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80196a:	0f 8e 6e ff ff ff    	jle    8018de <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801970:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801977:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80197b:	74 7d                	je     8019fa <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80197d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801984:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801987:	89 d0                	mov    %edx,%eax
  801989:	01 c0                	add    %eax,%eax
  80198b:	01 d0                	add    %edx,%eax
  80198d:	c1 e0 02             	shl    $0x2,%eax
  801990:	05 40 10 81 00       	add    $0x811040,%eax
  801995:	8b 10                	mov    (%eax),%edx
  801997:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80199a:	01 d0                	add    %edx,%eax
  80199c:	48                   	dec    %eax
  80199d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8019a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a8:	f7 75 bc             	divl   -0x44(%ebp)
  8019ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019ae:	29 d0                	sub    %edx,%eax
  8019b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8019b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b6:	89 d0                	mov    %edx,%eax
  8019b8:	01 c0                	add    %eax,%eax
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	c1 e0 02             	shl    $0x2,%eax
  8019bf:	05 48 10 81 00       	add    $0x811048,%eax
  8019c4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8019c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ca:	89 d0                	mov    %edx,%eax
  8019cc:	01 c0                	add    %eax,%eax
  8019ce:	01 d0                	add    %edx,%eax
  8019d0:	c1 e0 02             	shl    $0x2,%eax
  8019d3:	05 44 10 81 00       	add    $0x811044,%eax
  8019d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8019de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e1:	89 d0                	mov    %edx,%eax
  8019e3:	01 c0                	add    %eax,%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	c1 e0 02             	shl    $0x2,%eax
  8019ea:	05 40 10 81 00       	add    $0x811040,%eax
  8019ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019f5:	e9 2d 01 00 00       	jmp    801b27 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8019fa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019fe:	0f 84 ce 00 00 00    	je     801ad2 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801a04:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801a0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0e:	89 d0                	mov    %edx,%eax
  801a10:	01 c0                	add    %eax,%eax
  801a12:	01 d0                	add    %edx,%eax
  801a14:	c1 e0 02             	shl    $0x2,%eax
  801a17:	05 40 10 81 00       	add    $0x811040,%eax
  801a1c:	8b 10                	mov    (%eax),%edx
  801a1e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a21:	01 d0                	add    %edx,%eax
  801a23:	48                   	dec    %eax
  801a24:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801a27:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2f:	f7 75 c4             	divl   -0x3c(%ebp)
  801a32:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a35:	29 d0                	sub    %edx,%eax
  801a37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801a3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a3d:	89 d0                	mov    %edx,%eax
  801a3f:	01 c0                	add    %eax,%eax
  801a41:	01 d0                	add    %edx,%eax
  801a43:	c1 e0 02             	shl    $0x2,%eax
  801a46:	05 44 10 81 00       	add    $0x811044,%eax
  801a4b:	8b 00                	mov    (%eax),%eax
  801a4d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a50:	75 47                	jne    801a99 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801a52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a55:	89 d0                	mov    %edx,%eax
  801a57:	01 c0                	add    %eax,%eax
  801a59:	01 d0                	add    %edx,%eax
  801a5b:	c1 e0 02             	shl    $0x2,%eax
  801a5e:	05 48 10 81 00       	add    $0x811048,%eax
  801a63:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801a66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a69:	89 d0                	mov    %edx,%eax
  801a6b:	01 c0                	add    %eax,%eax
  801a6d:	01 d0                	add    %edx,%eax
  801a6f:	c1 e0 02             	shl    $0x2,%eax
  801a72:	05 44 10 81 00       	add    $0x811044,%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801a7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a80:	89 d0                	mov    %edx,%eax
  801a82:	01 c0                	add    %eax,%eax
  801a84:	01 d0                	add    %edx,%eax
  801a86:	c1 e0 02             	shl    $0x2,%eax
  801a89:	05 40 10 81 00       	add    $0x811040,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a94:	e9 8e 00 00 00       	jmp    801b27 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801a99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a9f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801aa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa5:	89 d0                	mov    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	01 d0                	add    %edx,%eax
  801aab:	c1 e0 02             	shl    $0x2,%eax
  801aae:	05 40 10 81 00       	add    $0x811040,%eax
  801ab3:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801abb:	89 c2                	mov    %eax,%edx
  801abd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ac0:	89 c8                	mov    %ecx,%eax
  801ac2:	01 c0                	add    %eax,%eax
  801ac4:	01 c8                	add    %ecx,%eax
  801ac6:	c1 e0 02             	shl    $0x2,%eax
  801ac9:	05 44 10 81 00       	add    $0x811044,%eax
  801ace:	89 10                	mov    %edx,(%eax)
  801ad0:	eb 55                	jmp    801b27 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801ad2:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801ad9:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801adf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ae2:	01 d0                	add    %edx,%eax
  801ae4:	48                   	dec    %eax
  801ae5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ae8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801af0:	f7 75 d0             	divl   -0x30(%ebp)
  801af3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801af6:	29 d0                	sub    %edx,%eax
  801af8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801afb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801afe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b01:	01 d0                	add    %edx,%eax
  801b03:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801b08:	76 0a                	jbe    801b14 <malloc+0x2c7>
            return NULL;
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0f:	e9 97 00 00 00       	jmp    801bab <malloc+0x35e>
        va = start;
  801b14:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801b1a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b20:	01 d0                	add    %edx,%eax
  801b22:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b27:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b2e:	eb 5e                	jmp    801b8e <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801b30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b33:	89 d0                	mov    %edx,%eax
  801b35:	01 c0                	add    %eax,%eax
  801b37:	01 d0                	add    %edx,%eax
  801b39:	c1 e0 02             	shl    $0x2,%eax
  801b3c:	05 48 50 80 00       	add    $0x805048,%eax
  801b41:	8a 00                	mov    (%eax),%al
  801b43:	84 c0                	test   %al,%al
  801b45:	75 44                	jne    801b8b <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801b47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b4a:	89 d0                	mov    %edx,%eax
  801b4c:	01 c0                	add    %eax,%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	c1 e0 02             	shl    $0x2,%eax
  801b53:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801b5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b61:	89 d0                	mov    %edx,%eax
  801b63:	01 c0                	add    %eax,%eax
  801b65:	01 d0                	add    %edx,%eax
  801b67:	c1 e0 02             	shl    $0x2,%eax
  801b6a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801b70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b73:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801b75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b78:	89 d0                	mov    %edx,%eax
  801b7a:	01 c0                	add    %eax,%eax
  801b7c:	01 d0                	add    %edx,%eax
  801b7e:	c1 e0 02             	shl    $0x2,%eax
  801b81:	05 48 50 80 00       	add    $0x805048,%eax
  801b86:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801b89:	eb 0c                	jmp    801b97 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b8b:	ff 45 e0             	incl   -0x20(%ebp)
  801b8e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801b95:	7e 99                	jle    801b30 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801b97:	83 ec 08             	sub    $0x8,%esp
  801b9a:	ff 75 d4             	pushl  -0x2c(%ebp)
  801b9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ba0:	e8 a2 19 00 00       	call   803547 <sys_allocate_user_mem>
  801ba5:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801bb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bb7:	0f 84 fa 03 00 00    	je     801fb7 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801bc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	79 1c                	jns    801be6 <free+0x39>
  801bca:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801bd1:	77 13                	ja     801be6 <free+0x39>
    {
        free_block(virtual_address);
  801bd3:	83 ec 0c             	sub    $0xc,%esp
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	e8 09 21 00 00       	call   803ce7 <free_block>
  801bde:	83 c4 10             	add    $0x10,%esp
        return;
  801be1:	e9 d2 03 00 00       	jmp    801fb8 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801be6:	a1 30 51 83 00       	mov    0x835130,%eax
  801beb:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801bee:	72 09                	jb     801bf9 <free+0x4c>
  801bf0:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801bf7:	76 17                	jbe    801c10 <free+0x63>
        panic("free: invalid address");
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	68 8d 4b 80 00       	push   $0x804b8d
  801c01:	68 9b 00 00 00       	push   $0x9b
  801c06:	68 44 4b 80 00       	push   $0x804b44
  801c0b:	e8 ad e9 ff ff       	call   8005bd <_panic>

    uint32 size = 0;
  801c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801c17:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c1e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801c25:	eb 50                	jmp    801c77 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801c27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c2a:	89 d0                	mov    %edx,%eax
  801c2c:	01 c0                	add    %eax,%eax
  801c2e:	01 d0                	add    %edx,%eax
  801c30:	c1 e0 02             	shl    $0x2,%eax
  801c33:	05 48 50 80 00       	add    $0x805048,%eax
  801c38:	8a 00                	mov    (%eax),%al
  801c3a:	84 c0                	test   %al,%al
  801c3c:	74 36                	je     801c74 <free+0xc7>
  801c3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c41:	89 d0                	mov    %edx,%eax
  801c43:	01 c0                	add    %eax,%eax
  801c45:	01 d0                	add    %edx,%eax
  801c47:	c1 e0 02             	shl    $0x2,%eax
  801c4a:	05 40 50 80 00       	add    $0x805040,%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c54:	75 1e                	jne    801c74 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801c56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c59:	89 d0                	mov    %edx,%eax
  801c5b:	01 c0                	add    %eax,%eax
  801c5d:	01 d0                	add    %edx,%eax
  801c5f:	c1 e0 02             	shl    $0x2,%eax
  801c62:	05 44 50 80 00       	add    $0x805044,%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801c72:	eb 0c                	jmp    801c80 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c74:	ff 45 ec             	incl   -0x14(%ebp)
  801c77:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801c7e:	7e a7                	jle    801c27 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801c80:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c84:	74 06                	je     801c8c <free+0xdf>
  801c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c8a:	75 17                	jne    801ca3 <free+0xf6>
        panic("free: unknown block");
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	68 a3 4b 80 00       	push   $0x804ba3
  801c94:	68 a9 00 00 00       	push   $0xa9
  801c99:	68 44 4b 80 00       	push   $0x804b44
  801c9e:	e8 1a e9 ff ff       	call   8005bd <_panic>

    uhp_allocs[idx].used = 0;
  801ca3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	01 c0                	add    %eax,%eax
  801caa:	01 d0                	add    %edx,%eax
  801cac:	c1 e0 02             	shl    $0x2,%eax
  801caf:	05 48 50 80 00       	add    $0x805048,%eax
  801cb4:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801cb7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cbe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801cc5:	eb 64                	jmp    801d2b <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801cc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cca:	89 d0                	mov    %edx,%eax
  801ccc:	01 c0                	add    %eax,%eax
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	c1 e0 02             	shl    $0x2,%eax
  801cd3:	05 48 10 81 00       	add    $0x811048,%eax
  801cd8:	8a 00                	mov    (%eax),%al
  801cda:	84 c0                	test   %al,%al
  801cdc:	75 4a                	jne    801d28 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801cde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ce1:	89 d0                	mov    %edx,%eax
  801ce3:	01 c0                	add    %eax,%eax
  801ce5:	01 d0                	add    %edx,%eax
  801ce7:	c1 e0 02             	shl    $0x2,%eax
  801cea:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801cf0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cf3:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cf8:	89 d0                	mov    %edx,%eax
  801cfa:	01 c0                	add    %eax,%eax
  801cfc:	01 d0                	add    %edx,%eax
  801cfe:	c1 e0 02             	shl    $0x2,%eax
  801d01:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801d0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	01 c0                	add    %eax,%eax
  801d13:	01 d0                	add    %edx,%eax
  801d15:	c1 e0 02             	shl    $0x2,%eax
  801d18:	05 48 10 81 00       	add    $0x811048,%eax
  801d1d:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d23:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801d26:	eb 0c                	jmp    801d34 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d28:	ff 45 e4             	incl   -0x1c(%ebp)
  801d2b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801d32:	7e 93                	jle    801cc7 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801d34:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801d38:	0f 84 f1 01 00 00    	je     801f2f <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d45:	e9 d8 01 00 00       	jmp    801f22 <free+0x375>
        {
            if (i == fidx) continue;
  801d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d50:	0f 84 c8 01 00 00    	je     801f1e <free+0x371>
            if (uhp_frees[i].free)
  801d56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d59:	89 d0                	mov    %edx,%eax
  801d5b:	01 c0                	add    %eax,%eax
  801d5d:	01 d0                	add    %edx,%eax
  801d5f:	c1 e0 02             	shl    $0x2,%eax
  801d62:	05 48 10 81 00       	add    $0x811048,%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	84 c0                	test   %al,%al
  801d6b:	0f 84 ae 01 00 00    	je     801f1f <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801d71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d74:	89 d0                	mov    %edx,%eax
  801d76:	01 c0                	add    %eax,%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c1 e0 02             	shl    $0x2,%eax
  801d7d:	05 40 10 81 00       	add    $0x811040,%eax
  801d82:	8b 08                	mov    (%eax),%ecx
  801d84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d87:	89 d0                	mov    %edx,%eax
  801d89:	01 c0                	add    %eax,%eax
  801d8b:	01 d0                	add    %edx,%eax
  801d8d:	c1 e0 02             	shl    $0x2,%eax
  801d90:	05 44 10 81 00       	add    $0x811044,%eax
  801d95:	8b 00                	mov    (%eax),%eax
  801d97:	01 c1                	add    %eax,%ecx
  801d99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d9c:	89 d0                	mov    %edx,%eax
  801d9e:	01 c0                	add    %eax,%eax
  801da0:	01 d0                	add    %edx,%eax
  801da2:	c1 e0 02             	shl    $0x2,%eax
  801da5:	05 40 10 81 00       	add    $0x811040,%eax
  801daa:	8b 00                	mov    (%eax),%eax
  801dac:	39 c1                	cmp    %eax,%ecx
  801dae:	0f 85 a8 00 00 00    	jne    801e5c <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801db4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db7:	89 d0                	mov    %edx,%eax
  801db9:	01 c0                	add    %eax,%eax
  801dbb:	01 d0                	add    %edx,%eax
  801dbd:	c1 e0 02             	shl    $0x2,%eax
  801dc0:	05 40 10 81 00       	add    $0x811040,%eax
  801dc5:	8b 10                	mov    (%eax),%edx
  801dc7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801dca:	89 c8                	mov    %ecx,%eax
  801dcc:	01 c0                	add    %eax,%eax
  801dce:	01 c8                	add    %ecx,%eax
  801dd0:	c1 e0 02             	shl    $0x2,%eax
  801dd3:	05 40 10 81 00       	add    $0x811040,%eax
  801dd8:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801dda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ddd:	89 d0                	mov    %edx,%eax
  801ddf:	01 c0                	add    %eax,%eax
  801de1:	01 d0                	add    %edx,%eax
  801de3:	c1 e0 02             	shl    $0x2,%eax
  801de6:	05 44 10 81 00       	add    $0x811044,%eax
  801deb:	8b 08                	mov    (%eax),%ecx
  801ded:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df0:	89 d0                	mov    %edx,%eax
  801df2:	01 c0                	add    %eax,%eax
  801df4:	01 d0                	add    %edx,%eax
  801df6:	c1 e0 02             	shl    $0x2,%eax
  801df9:	05 44 10 81 00       	add    $0x811044,%eax
  801dfe:	8b 00                	mov    (%eax),%eax
  801e00:	01 c1                	add    %eax,%ecx
  801e02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e05:	89 d0                	mov    %edx,%eax
  801e07:	01 c0                	add    %eax,%eax
  801e09:	01 d0                	add    %edx,%eax
  801e0b:	c1 e0 02             	shl    $0x2,%eax
  801e0e:	05 44 10 81 00       	add    $0x811044,%eax
  801e13:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801e15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e18:	89 d0                	mov    %edx,%eax
  801e1a:	01 c0                	add    %eax,%eax
  801e1c:	01 d0                	add    %edx,%eax
  801e1e:	c1 e0 02             	shl    $0x2,%eax
  801e21:	05 48 10 81 00       	add    $0x811048,%eax
  801e26:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801e29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e2c:	89 d0                	mov    %edx,%eax
  801e2e:	01 c0                	add    %eax,%eax
  801e30:	01 d0                	add    %edx,%eax
  801e32:	c1 e0 02             	shl    $0x2,%eax
  801e35:	05 40 10 81 00       	add    $0x811040,%eax
  801e3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801e40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	01 c0                	add    %eax,%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c1 e0 02             	shl    $0x2,%eax
  801e4c:	05 44 10 81 00       	add    $0x811044,%eax
  801e51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e57:	e9 c3 00 00 00       	jmp    801f1f <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801e5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e5f:	89 d0                	mov    %edx,%eax
  801e61:	01 c0                	add    %eax,%eax
  801e63:	01 d0                	add    %edx,%eax
  801e65:	c1 e0 02             	shl    $0x2,%eax
  801e68:	05 40 10 81 00       	add    $0x811040,%eax
  801e6d:	8b 08                	mov    (%eax),%ecx
  801e6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e72:	89 d0                	mov    %edx,%eax
  801e74:	01 c0                	add    %eax,%eax
  801e76:	01 d0                	add    %edx,%eax
  801e78:	c1 e0 02             	shl    $0x2,%eax
  801e7b:	05 44 10 81 00       	add    $0x811044,%eax
  801e80:	8b 00                	mov    (%eax),%eax
  801e82:	01 c1                	add    %eax,%ecx
  801e84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e87:	89 d0                	mov    %edx,%eax
  801e89:	01 c0                	add    %eax,%eax
  801e8b:	01 d0                	add    %edx,%eax
  801e8d:	c1 e0 02             	shl    $0x2,%eax
  801e90:	05 40 10 81 00       	add    $0x811040,%eax
  801e95:	8b 00                	mov    (%eax),%eax
  801e97:	39 c1                	cmp    %eax,%ecx
  801e99:	0f 85 80 00 00 00    	jne    801f1f <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801e9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ea2:	89 d0                	mov    %edx,%eax
  801ea4:	01 c0                	add    %eax,%eax
  801ea6:	01 d0                	add    %edx,%eax
  801ea8:	c1 e0 02             	shl    $0x2,%eax
  801eab:	05 44 10 81 00       	add    $0x811044,%eax
  801eb0:	8b 08                	mov    (%eax),%ecx
  801eb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb5:	89 d0                	mov    %edx,%eax
  801eb7:	01 c0                	add    %eax,%eax
  801eb9:	01 d0                	add    %edx,%eax
  801ebb:	c1 e0 02             	shl    $0x2,%eax
  801ebe:	05 44 10 81 00       	add    $0x811044,%eax
  801ec3:	8b 00                	mov    (%eax),%eax
  801ec5:	01 c1                	add    %eax,%ecx
  801ec7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eca:	89 d0                	mov    %edx,%eax
  801ecc:	01 c0                	add    %eax,%eax
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	c1 e0 02             	shl    $0x2,%eax
  801ed3:	05 44 10 81 00       	add    $0x811044,%eax
  801ed8:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801eda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801edd:	89 d0                	mov    %edx,%eax
  801edf:	01 c0                	add    %eax,%eax
  801ee1:	01 d0                	add    %edx,%eax
  801ee3:	c1 e0 02             	shl    $0x2,%eax
  801ee6:	05 48 10 81 00       	add    $0x811048,%eax
  801eeb:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801eee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ef1:	89 d0                	mov    %edx,%eax
  801ef3:	01 c0                	add    %eax,%eax
  801ef5:	01 d0                	add    %edx,%eax
  801ef7:	c1 e0 02             	shl    $0x2,%eax
  801efa:	05 40 10 81 00       	add    $0x811040,%eax
  801eff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801f05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f08:	89 d0                	mov    %edx,%eax
  801f0a:	01 c0                	add    %eax,%eax
  801f0c:	01 d0                	add    %edx,%eax
  801f0e:	c1 e0 02             	shl    $0x2,%eax
  801f11:	05 44 10 81 00       	add    $0x811044,%eax
  801f16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f1c:	eb 01                	jmp    801f1f <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801f1e:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f1f:	ff 45 e0             	incl   -0x20(%ebp)
  801f22:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f29:	0f 8e 1b fe ff ff    	jle    801d4a <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801f2f:	a1 30 51 83 00       	mov    0x835130,%eax
  801f34:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f37:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801f3e:	eb 53                	jmp    801f93 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801f40:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f43:	89 d0                	mov    %edx,%eax
  801f45:	01 c0                	add    %eax,%eax
  801f47:	01 d0                	add    %edx,%eax
  801f49:	c1 e0 02             	shl    $0x2,%eax
  801f4c:	05 48 50 80 00       	add    $0x805048,%eax
  801f51:	8a 00                	mov    (%eax),%al
  801f53:	84 c0                	test   %al,%al
  801f55:	74 39                	je     801f90 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801f57:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f5a:	89 d0                	mov    %edx,%eax
  801f5c:	01 c0                	add    %eax,%eax
  801f5e:	01 d0                	add    %edx,%eax
  801f60:	c1 e0 02             	shl    $0x2,%eax
  801f63:	05 40 50 80 00       	add    $0x805040,%eax
  801f68:	8b 08                	mov    (%eax),%ecx
  801f6a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	01 c0                	add    %eax,%eax
  801f71:	01 d0                	add    %edx,%eax
  801f73:	c1 e0 02             	shl    $0x2,%eax
  801f76:	05 44 50 80 00       	add    $0x805044,%eax
  801f7b:	8b 00                	mov    (%eax),%eax
  801f7d:	01 c8                	add    %ecx,%eax
  801f7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801f82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f85:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f88:	76 06                	jbe    801f90 <free+0x3e3>
  801f8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f90:	ff 45 d8             	incl   -0x28(%ebp)
  801f93:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801f9a:	7e a4                	jle    801f40 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801f9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f9f:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801fa4:	83 ec 08             	sub    $0x8,%esp
  801fa7:	ff 75 f4             	pushl  -0xc(%ebp)
  801faa:	ff 75 d4             	pushl  -0x2c(%ebp)
  801fad:	e8 79 15 00 00       	call   80352b <sys_free_user_mem>
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	eb 01                	jmp    801fb8 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801fb7:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 68             	sub    $0x68,%esp
  801fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc3:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fc6:	e8 a5 f7 ff ff       	call   801770 <uheap_init>
	if (size == 0) return NULL ;
  801fcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fcf:	75 0a                	jne    801fdb <smalloc+0x21>
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd6:	e9 37 03 00 00       	jmp    802312 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801fdb:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	48                   	dec    %eax
  801feb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ff1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff6:	f7 75 dc             	divl   -0x24(%ebp)
  801ff9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ffc:	29 d0                	sub    %edx,%eax
  801ffe:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802001:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802008:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80200f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802016:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80201d:	e9 85 00 00 00       	jmp    8020a7 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802022:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802025:	89 d0                	mov    %edx,%eax
  802027:	01 c0                	add    %eax,%eax
  802029:	01 d0                	add    %edx,%eax
  80202b:	c1 e0 02             	shl    $0x2,%eax
  80202e:	05 48 10 81 00       	add    $0x811048,%eax
  802033:	8a 00                	mov    (%eax),%al
  802035:	84 c0                	test   %al,%al
  802037:	74 20                	je     802059 <smalloc+0x9f>
  802039:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80203c:	89 d0                	mov    %edx,%eax
  80203e:	01 c0                	add    %eax,%eax
  802040:	01 d0                	add    %edx,%eax
  802042:	c1 e0 02             	shl    $0x2,%eax
  802045:	05 44 10 81 00       	add    $0x811044,%eax
  80204a:	8b 00                	mov    (%eax),%eax
  80204c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80204f:	75 08                	jne    802059 <smalloc+0x9f>
        {
            exactIdx = i;
  802051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802057:	eb 5b                	jmp    8020b4 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802059:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80205c:	89 d0                	mov    %edx,%eax
  80205e:	01 c0                	add    %eax,%eax
  802060:	01 d0                	add    %edx,%eax
  802062:	c1 e0 02             	shl    $0x2,%eax
  802065:	05 48 10 81 00       	add    $0x811048,%eax
  80206a:	8a 00                	mov    (%eax),%al
  80206c:	84 c0                	test   %al,%al
  80206e:	74 34                	je     8020a4 <smalloc+0xea>
  802070:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802073:	89 d0                	mov    %edx,%eax
  802075:	01 c0                	add    %eax,%eax
  802077:	01 d0                	add    %edx,%eax
  802079:	c1 e0 02             	shl    $0x2,%eax
  80207c:	05 44 10 81 00       	add    $0x811044,%eax
  802081:	8b 00                	mov    (%eax),%eax
  802083:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802086:	76 1c                	jbe    8020a4 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802088:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80208b:	89 d0                	mov    %edx,%eax
  80208d:	01 c0                	add    %eax,%eax
  80208f:	01 d0                	add    %edx,%eax
  802091:	c1 e0 02             	shl    $0x2,%eax
  802094:	05 44 10 81 00       	add    $0x811044,%eax
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80209e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a1:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020a4:	ff 45 e8             	incl   -0x18(%ebp)
  8020a7:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8020ae:	0f 8e 6e ff ff ff    	jle    802022 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8020b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8020bb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8020bf:	74 7d                	je     80213e <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8020c1:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8020c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cb:	89 d0                	mov    %edx,%eax
  8020cd:	01 c0                	add    %eax,%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	c1 e0 02             	shl    $0x2,%eax
  8020d4:	05 40 10 81 00       	add    $0x811040,%eax
  8020d9:	8b 10                	mov    (%eax),%edx
  8020db:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	48                   	dec    %eax
  8020e1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8020e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ec:	f7 75 bc             	divl   -0x44(%ebp)
  8020ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020f2:	29 d0                	sub    %edx,%eax
  8020f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8020f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fa:	89 d0                	mov    %edx,%eax
  8020fc:	01 c0                	add    %eax,%eax
  8020fe:	01 d0                	add    %edx,%eax
  802100:	c1 e0 02             	shl    $0x2,%eax
  802103:	05 48 10 81 00       	add    $0x811048,%eax
  802108:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80210b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210e:	89 d0                	mov    %edx,%eax
  802110:	01 c0                	add    %eax,%eax
  802112:	01 d0                	add    %edx,%eax
  802114:	c1 e0 02             	shl    $0x2,%eax
  802117:	05 44 10 81 00       	add    $0x811044,%eax
  80211c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	89 d0                	mov    %edx,%eax
  802127:	01 c0                	add    %eax,%eax
  802129:	01 d0                	add    %edx,%eax
  80212b:	c1 e0 02             	shl    $0x2,%eax
  80212e:	05 40 10 81 00       	add    $0x811040,%eax
  802133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802139:	e9 2d 01 00 00       	jmp    80226b <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  80213e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802142:	0f 84 ce 00 00 00    	je     802216 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802148:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80214f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802152:	89 d0                	mov    %edx,%eax
  802154:	01 c0                	add    %eax,%eax
  802156:	01 d0                	add    %edx,%eax
  802158:	c1 e0 02             	shl    $0x2,%eax
  80215b:	05 40 10 81 00       	add    $0x811040,%eax
  802160:	8b 10                	mov    (%eax),%edx
  802162:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802165:	01 d0                	add    %edx,%eax
  802167:	48                   	dec    %eax
  802168:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80216b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80216e:	ba 00 00 00 00       	mov    $0x0,%edx
  802173:	f7 75 c4             	divl   -0x3c(%ebp)
  802176:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802179:	29 d0                	sub    %edx,%eax
  80217b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80217e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802181:	89 d0                	mov    %edx,%eax
  802183:	01 c0                	add    %eax,%eax
  802185:	01 d0                	add    %edx,%eax
  802187:	c1 e0 02             	shl    $0x2,%eax
  80218a:	05 44 10 81 00       	add    $0x811044,%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802194:	75 47                	jne    8021dd <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802196:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802199:	89 d0                	mov    %edx,%eax
  80219b:	01 c0                	add    %eax,%eax
  80219d:	01 d0                	add    %edx,%eax
  80219f:	c1 e0 02             	shl    $0x2,%eax
  8021a2:	05 48 10 81 00       	add    $0x811048,%eax
  8021a7:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8021aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ad:	89 d0                	mov    %edx,%eax
  8021af:	01 c0                	add    %eax,%eax
  8021b1:	01 d0                	add    %edx,%eax
  8021b3:	c1 e0 02             	shl    $0x2,%eax
  8021b6:	05 44 10 81 00       	add    $0x811044,%eax
  8021bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8021c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c4:	89 d0                	mov    %edx,%eax
  8021c6:	01 c0                	add    %eax,%eax
  8021c8:	01 d0                	add    %edx,%eax
  8021ca:	c1 e0 02             	shl    $0x2,%eax
  8021cd:	05 40 10 81 00       	add    $0x811040,%eax
  8021d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d8:	e9 8e 00 00 00       	jmp    80226b <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8021dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8021e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	01 c0                	add    %eax,%eax
  8021ed:	01 d0                	add    %edx,%eax
  8021ef:	c1 e0 02             	shl    $0x2,%eax
  8021f2:	05 40 10 81 00       	add    $0x811040,%eax
  8021f7:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8021ff:	89 c2                	mov    %eax,%edx
  802201:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802204:	89 c8                	mov    %ecx,%eax
  802206:	01 c0                	add    %eax,%eax
  802208:	01 c8                	add    %ecx,%eax
  80220a:	c1 e0 02             	shl    $0x2,%eax
  80220d:	05 44 10 81 00       	add    $0x811044,%eax
  802212:	89 10                	mov    %edx,(%eax)
  802214:	eb 55                	jmp    80226b <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802216:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80221d:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802223:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802226:	01 d0                	add    %edx,%eax
  802228:	48                   	dec    %eax
  802229:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80222c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80222f:	ba 00 00 00 00       	mov    $0x0,%edx
  802234:	f7 75 d0             	divl   -0x30(%ebp)
  802237:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80223a:	29 d0                	sub    %edx,%eax
  80223c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80223f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80224c:	76 0a                	jbe    802258 <smalloc+0x29e>
            return NULL;
  80224e:	b8 00 00 00 00       	mov    $0x0,%eax
  802253:	e9 ba 00 00 00       	jmp    802312 <smalloc+0x358>
        va = start;
  802258:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80225b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80225e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802261:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802264:	01 d0                	add    %edx,%eax
  802266:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80226b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802272:	eb 5e                	jmp    8022d2 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802274:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802277:	89 d0                	mov    %edx,%eax
  802279:	01 c0                	add    %eax,%eax
  80227b:	01 d0                	add    %edx,%eax
  80227d:	c1 e0 02             	shl    $0x2,%eax
  802280:	05 48 50 80 00       	add    $0x805048,%eax
  802285:	8a 00                	mov    (%eax),%al
  802287:	84 c0                	test   %al,%al
  802289:	75 44                	jne    8022cf <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80228b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80228e:	89 d0                	mov    %edx,%eax
  802290:	01 c0                	add    %eax,%eax
  802292:	01 d0                	add    %edx,%eax
  802294:	c1 e0 02             	shl    $0x2,%eax
  802297:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80229d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8022a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022a5:	89 d0                	mov    %edx,%eax
  8022a7:	01 c0                	add    %eax,%eax
  8022a9:	01 d0                	add    %edx,%eax
  8022ab:	c1 e0 02             	shl    $0x2,%eax
  8022ae:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8022b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022b7:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8022b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022bc:	89 d0                	mov    %edx,%eax
  8022be:	01 c0                	add    %eax,%eax
  8022c0:	01 d0                	add    %edx,%eax
  8022c2:	c1 e0 02             	shl    $0x2,%eax
  8022c5:	05 48 50 80 00       	add    $0x805048,%eax
  8022ca:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8022cd:	eb 0c                	jmp    8022db <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022cf:	ff 45 e0             	incl   -0x20(%ebp)
  8022d2:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8022d9:	7e 99                	jle    802274 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8022db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022de:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8022e2:	52                   	push   %edx
  8022e3:	50                   	push   %eax
  8022e4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8022e7:	ff 75 08             	pushl  0x8(%ebp)
  8022ea:	e8 de 0e 00 00       	call   8031cd <sys_create_shared_object>
  8022ef:	83 c4 10             	add    $0x10,%esp
  8022f2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8022f5:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8022f9:	75 07                	jne    802302 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8022fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802300:	eb 10                	jmp    802312 <smalloc+0x358>
    if (r < 0)
  802302:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802306:	79 07                	jns    80230f <smalloc+0x355>
        return NULL;
  802308:	b8 00 00 00 00       	mov    $0x0,%eax
  80230d:	eb 03                	jmp    802312 <smalloc+0x358>
    return (void*)va;
  80230f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80231a:	e8 51 f4 ff ff       	call   801770 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80231f:	83 ec 08             	sub    $0x8,%esp
  802322:	ff 75 0c             	pushl  0xc(%ebp)
  802325:	ff 75 08             	pushl  0x8(%ebp)
  802328:	e8 ca 0e 00 00       	call   8031f7 <sys_size_of_shared_object>
  80232d:	83 c4 10             	add    $0x10,%esp
  802330:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802333:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802337:	7f 0a                	jg     802343 <sget+0x2f>
        return NULL;
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	e9 28 03 00 00       	jmp    80266b <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802343:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80234a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80234d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802350:	01 d0                	add    %edx,%eax
  802352:	48                   	dec    %eax
  802353:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802356:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802359:	ba 00 00 00 00       	mov    $0x0,%edx
  80235e:	f7 75 d8             	divl   -0x28(%ebp)
  802361:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802364:	29 d0                	sub    %edx,%eax
  802366:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802369:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802370:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802377:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80237e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802385:	e9 85 00 00 00       	jmp    80240f <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80238a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80238d:	89 d0                	mov    %edx,%eax
  80238f:	01 c0                	add    %eax,%eax
  802391:	01 d0                	add    %edx,%eax
  802393:	c1 e0 02             	shl    $0x2,%eax
  802396:	05 48 10 81 00       	add    $0x811048,%eax
  80239b:	8a 00                	mov    (%eax),%al
  80239d:	84 c0                	test   %al,%al
  80239f:	74 20                	je     8023c1 <sget+0xad>
  8023a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023a4:	89 d0                	mov    %edx,%eax
  8023a6:	01 c0                	add    %eax,%eax
  8023a8:	01 d0                	add    %edx,%eax
  8023aa:	c1 e0 02             	shl    $0x2,%eax
  8023ad:	05 44 10 81 00       	add    $0x811044,%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023b7:	75 08                	jne    8023c1 <sget+0xad>
        {
            exactIdx = i;
  8023b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8023bf:	eb 5b                	jmp    80241c <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8023c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023c4:	89 d0                	mov    %edx,%eax
  8023c6:	01 c0                	add    %eax,%eax
  8023c8:	01 d0                	add    %edx,%eax
  8023ca:	c1 e0 02             	shl    $0x2,%eax
  8023cd:	05 48 10 81 00       	add    $0x811048,%eax
  8023d2:	8a 00                	mov    (%eax),%al
  8023d4:	84 c0                	test   %al,%al
  8023d6:	74 34                	je     80240c <sget+0xf8>
  8023d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023db:	89 d0                	mov    %edx,%eax
  8023dd:	01 c0                	add    %eax,%eax
  8023df:	01 d0                	add    %edx,%eax
  8023e1:	c1 e0 02             	shl    $0x2,%eax
  8023e4:	05 44 10 81 00       	add    $0x811044,%eax
  8023e9:	8b 00                	mov    (%eax),%eax
  8023eb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023ee:	76 1c                	jbe    80240c <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8023f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023f3:	89 d0                	mov    %edx,%eax
  8023f5:	01 c0                	add    %eax,%eax
  8023f7:	01 d0                	add    %edx,%eax
  8023f9:	c1 e0 02             	shl    $0x2,%eax
  8023fc:	05 44 10 81 00       	add    $0x811044,%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802409:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80240c:	ff 45 e8             	incl   -0x18(%ebp)
  80240f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802416:	0f 8e 6e ff ff ff    	jle    80238a <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80241c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802423:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802427:	74 7d                	je     8024a6 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802429:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802430:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802433:	89 d0                	mov    %edx,%eax
  802435:	01 c0                	add    %eax,%eax
  802437:	01 d0                	add    %edx,%eax
  802439:	c1 e0 02             	shl    $0x2,%eax
  80243c:	05 40 10 81 00       	add    $0x811040,%eax
  802441:	8b 10                	mov    (%eax),%edx
  802443:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802446:	01 d0                	add    %edx,%eax
  802448:	48                   	dec    %eax
  802449:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80244c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80244f:	ba 00 00 00 00       	mov    $0x0,%edx
  802454:	f7 75 b8             	divl   -0x48(%ebp)
  802457:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80245a:	29 d0                	sub    %edx,%eax
  80245c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80245f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802462:	89 d0                	mov    %edx,%eax
  802464:	01 c0                	add    %eax,%eax
  802466:	01 d0                	add    %edx,%eax
  802468:	c1 e0 02             	shl    $0x2,%eax
  80246b:	05 48 10 81 00       	add    $0x811048,%eax
  802470:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802476:	89 d0                	mov    %edx,%eax
  802478:	01 c0                	add    %eax,%eax
  80247a:	01 d0                	add    %edx,%eax
  80247c:	c1 e0 02             	shl    $0x2,%eax
  80247f:	05 44 10 81 00       	add    $0x811044,%eax
  802484:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80248a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248d:	89 d0                	mov    %edx,%eax
  80248f:	01 c0                	add    %eax,%eax
  802491:	01 d0                	add    %edx,%eax
  802493:	c1 e0 02             	shl    $0x2,%eax
  802496:	05 40 10 81 00       	add    $0x811040,%eax
  80249b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a1:	e9 2d 01 00 00       	jmp    8025d3 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8024a6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024aa:	0f 84 ce 00 00 00    	je     80257e <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8024b0:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8024b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ba:	89 d0                	mov    %edx,%eax
  8024bc:	01 c0                	add    %eax,%eax
  8024be:	01 d0                	add    %edx,%eax
  8024c0:	c1 e0 02             	shl    $0x2,%eax
  8024c3:	05 40 10 81 00       	add    $0x811040,%eax
  8024c8:	8b 10                	mov    (%eax),%edx
  8024ca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024cd:	01 d0                	add    %edx,%eax
  8024cf:	48                   	dec    %eax
  8024d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8024d3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8024db:	f7 75 c0             	divl   -0x40(%ebp)
  8024de:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024e1:	29 d0                	sub    %edx,%eax
  8024e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8024e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e9:	89 d0                	mov    %edx,%eax
  8024eb:	01 c0                	add    %eax,%eax
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	c1 e0 02             	shl    $0x2,%eax
  8024f2:	05 44 10 81 00       	add    $0x811044,%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8024fc:	75 47                	jne    802545 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8024fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802501:	89 d0                	mov    %edx,%eax
  802503:	01 c0                	add    %eax,%eax
  802505:	01 d0                	add    %edx,%eax
  802507:	c1 e0 02             	shl    $0x2,%eax
  80250a:	05 48 10 81 00       	add    $0x811048,%eax
  80250f:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802515:	89 d0                	mov    %edx,%eax
  802517:	01 c0                	add    %eax,%eax
  802519:	01 d0                	add    %edx,%eax
  80251b:	c1 e0 02             	shl    $0x2,%eax
  80251e:	05 44 10 81 00       	add    $0x811044,%eax
  802523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802529:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252c:	89 d0                	mov    %edx,%eax
  80252e:	01 c0                	add    %eax,%eax
  802530:	01 d0                	add    %edx,%eax
  802532:	c1 e0 02             	shl    $0x2,%eax
  802535:	05 40 10 81 00       	add    $0x811040,%eax
  80253a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802540:	e9 8e 00 00 00       	jmp    8025d3 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802545:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802548:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80254b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80254e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802551:	89 d0                	mov    %edx,%eax
  802553:	01 c0                	add    %eax,%eax
  802555:	01 d0                	add    %edx,%eax
  802557:	c1 e0 02             	shl    $0x2,%eax
  80255a:	05 40 10 81 00       	add    $0x811040,%eax
  80255f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802564:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802567:	89 c2                	mov    %eax,%edx
  802569:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80256c:	89 c8                	mov    %ecx,%eax
  80256e:	01 c0                	add    %eax,%eax
  802570:	01 c8                	add    %ecx,%eax
  802572:	c1 e0 02             	shl    $0x2,%eax
  802575:	05 44 10 81 00       	add    $0x811044,%eax
  80257a:	89 10                	mov    %edx,(%eax)
  80257c:	eb 55                	jmp    8025d3 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80257e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802585:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80258b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80258e:	01 d0                	add    %edx,%eax
  802590:	48                   	dec    %eax
  802591:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802594:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802597:	ba 00 00 00 00       	mov    $0x0,%edx
  80259c:	f7 75 cc             	divl   -0x34(%ebp)
  80259f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025a2:	29 d0                	sub    %edx,%eax
  8025a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8025a7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025ad:	01 d0                	add    %edx,%eax
  8025af:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8025b4:	76 0a                	jbe    8025c0 <sget+0x2ac>
            return NULL;
  8025b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bb:	e9 ab 00 00 00       	jmp    80266b <sget+0x357>
        va = start;
  8025c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8025c6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025cc:	01 d0                	add    %edx,%eax
  8025ce:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8025da:	eb 5e                	jmp    80263a <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8025dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025df:	89 d0                	mov    %edx,%eax
  8025e1:	01 c0                	add    %eax,%eax
  8025e3:	01 d0                	add    %edx,%eax
  8025e5:	c1 e0 02             	shl    $0x2,%eax
  8025e8:	05 48 50 80 00       	add    $0x805048,%eax
  8025ed:	8a 00                	mov    (%eax),%al
  8025ef:	84 c0                	test   %al,%al
  8025f1:	75 44                	jne    802637 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8025f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025f6:	89 d0                	mov    %edx,%eax
  8025f8:	01 c0                	add    %eax,%eax
  8025fa:	01 d0                	add    %edx,%eax
  8025fc:	c1 e0 02             	shl    $0x2,%eax
  8025ff:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802608:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80260a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80260d:	89 d0                	mov    %edx,%eax
  80260f:	01 c0                	add    %eax,%eax
  802611:	01 d0                	add    %edx,%eax
  802613:	c1 e0 02             	shl    $0x2,%eax
  802616:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80261c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80261f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802621:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802624:	89 d0                	mov    %edx,%eax
  802626:	01 c0                	add    %eax,%eax
  802628:	01 d0                	add    %edx,%eax
  80262a:	c1 e0 02             	shl    $0x2,%eax
  80262d:	05 48 50 80 00       	add    $0x805048,%eax
  802632:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802635:	eb 0c                	jmp    802643 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802637:	ff 45 e0             	incl   -0x20(%ebp)
  80263a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802641:	7e 99                	jle    8025dc <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802646:	83 ec 04             	sub    $0x4,%esp
  802649:	50                   	push   %eax
  80264a:	ff 75 0c             	pushl  0xc(%ebp)
  80264d:	ff 75 08             	pushl  0x8(%ebp)
  802650:	e8 bf 0b 00 00       	call   803214 <sys_get_shared_object>
  802655:	83 c4 10             	add    $0x10,%esp
  802658:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  80265b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80265f:	79 07                	jns    802668 <sget+0x354>
        return NULL;
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
  802666:	eb 03                	jmp    80266b <sget+0x357>
    return (void*)va;
  802668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802673:	e8 f8 f0 ff ff       	call   801770 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802678:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267c:	75 13                	jne    802691 <realloc+0x24>
		return malloc(new_size);
  80267e:	83 ec 0c             	sub    $0xc,%esp
  802681:	ff 75 0c             	pushl  0xc(%ebp)
  802684:	e8 c4 f1 ff ff       	call   80184d <malloc>
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	e9 f4 05 00 00       	jmp    802c85 <realloc+0x618>
	if (new_size == 0)
  802691:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802695:	75 18                	jne    8026af <realloc+0x42>
	{
		free(virtual_address);
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	ff 75 08             	pushl  0x8(%ebp)
  80269d:	e8 0b f5 ff ff       	call   801bad <free>
  8026a2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8026a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026aa:	e9 d6 05 00 00       	jmp    802c85 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8026b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	79 74                	jns    802730 <realloc+0xc3>
  8026bc:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8026c3:	77 6b                	ja     802730 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8026c5:	83 ec 0c             	sub    $0xc,%esp
  8026c8:	ff 75 0c             	pushl  0xc(%ebp)
  8026cb:	e8 7d f1 ff ff       	call   80184d <malloc>
  8026d0:	83 c4 10             	add    $0x10,%esp
  8026d3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8026d6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8026da:	75 0a                	jne    8026e6 <realloc+0x79>
			return NULL;
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e1:	e9 9f 05 00 00       	jmp    802c85 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	ff 75 08             	pushl  0x8(%ebp)
  8026ec:	e8 e0 11 00 00       	call   8038d1 <get_block_size>
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8026f7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8026fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fd:	39 d0                	cmp    %edx,%eax
  8026ff:	76 02                	jbe    802703 <realloc+0x96>
  802701:	89 d0                	mov    %edx,%eax
  802703:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802706:	83 ec 04             	sub    $0x4,%esp
  802709:	ff 75 c0             	pushl  -0x40(%ebp)
  80270c:	ff 75 08             	pushl  0x8(%ebp)
  80270f:	ff 75 c8             	pushl  -0x38(%ebp)
  802712:	e8 56 eb ff ff       	call   80126d <memmove>
  802717:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  80271a:	83 ec 0c             	sub    $0xc,%esp
  80271d:	ff 75 08             	pushl  0x8(%ebp)
  802720:	e8 88 f4 ff ff       	call   801bad <free>
  802725:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802728:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80272b:	e9 55 05 00 00       	jmp    802c85 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802730:	a1 30 51 83 00       	mov    0x835130,%eax
  802735:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802738:	72 09                	jb     802743 <realloc+0xd6>
  80273a:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802741:	76 0a                	jbe    80274d <realloc+0xe0>
		return NULL;
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
  802748:	e9 38 05 00 00       	jmp    802c85 <realloc+0x618>
	uint32 oldsz = 0;
  80274d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802754:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80275b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802762:	eb 50                	jmp    8027b4 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802764:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802767:	89 d0                	mov    %edx,%eax
  802769:	01 c0                	add    %eax,%eax
  80276b:	01 d0                	add    %edx,%eax
  80276d:	c1 e0 02             	shl    $0x2,%eax
  802770:	05 48 50 80 00       	add    $0x805048,%eax
  802775:	8a 00                	mov    (%eax),%al
  802777:	84 c0                	test   %al,%al
  802779:	74 36                	je     8027b1 <realloc+0x144>
  80277b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277e:	89 d0                	mov    %edx,%eax
  802780:	01 c0                	add    %eax,%eax
  802782:	01 d0                	add    %edx,%eax
  802784:	c1 e0 02             	shl    $0x2,%eax
  802787:	05 40 50 80 00       	add    $0x805040,%eax
  80278c:	8b 00                	mov    (%eax),%eax
  80278e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802791:	75 1e                	jne    8027b1 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802793:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802796:	89 d0                	mov    %edx,%eax
  802798:	01 c0                	add    %eax,%eax
  80279a:	01 d0                	add    %edx,%eax
  80279c:	c1 e0 02             	shl    $0x2,%eax
  80279f:	05 44 50 80 00       	add    $0x805044,%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8027a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8027af:	eb 0c                	jmp    8027bd <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8027b1:	ff 45 ec             	incl   -0x14(%ebp)
  8027b4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8027bb:	7e a7                	jle    802764 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8027bd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8027c1:	75 0a                	jne    8027cd <realloc+0x160>
		return NULL;
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c8:	e9 b8 04 00 00       	jmp    802c85 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8027cd:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8027d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027da:	01 d0                	add    %edx,%eax
  8027dc:	48                   	dec    %eax
  8027dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8027e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e8:	f7 75 bc             	divl   -0x44(%ebp)
  8027eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027ee:	29 d0                	sub    %edx,%eax
  8027f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8027f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027f9:	75 08                	jne    802803 <realloc+0x196>
		return virtual_address;
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	e9 82 04 00 00       	jmp    802c85 <realloc+0x618>
	if (req < oldsz)
  802803:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802806:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802809:	0f 83 cd 02 00 00    	jae    802adc <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802815:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802818:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80281b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80281e:	01 d0                	add    %edx,%eax
  802820:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802823:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802826:	89 d0                	mov    %edx,%eax
  802828:	01 c0                	add    %eax,%eax
  80282a:	01 d0                	add    %edx,%eax
  80282c:	c1 e0 02             	shl    $0x2,%eax
  80282f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802835:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802838:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  80283a:	83 ec 08             	sub    $0x8,%esp
  80283d:	ff 75 b0             	pushl  -0x50(%ebp)
  802840:	ff 75 ac             	pushl  -0x54(%ebp)
  802843:	e8 e3 0c 00 00       	call   80352b <sys_free_user_mem>
  802848:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  80284b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802852:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802859:	eb 64                	jmp    8028bf <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  80285b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80285e:	89 d0                	mov    %edx,%eax
  802860:	01 c0                	add    %eax,%eax
  802862:	01 d0                	add    %edx,%eax
  802864:	c1 e0 02             	shl    $0x2,%eax
  802867:	05 48 10 81 00       	add    $0x811048,%eax
  80286c:	8a 00                	mov    (%eax),%al
  80286e:	84 c0                	test   %al,%al
  802870:	75 4a                	jne    8028bc <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802872:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802875:	89 d0                	mov    %edx,%eax
  802877:	01 c0                	add    %eax,%eax
  802879:	01 d0                	add    %edx,%eax
  80287b:	c1 e0 02             	shl    $0x2,%eax
  80287e:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802884:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802887:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802889:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80288c:	89 d0                	mov    %edx,%eax
  80288e:	01 c0                	add    %eax,%eax
  802890:	01 d0                	add    %edx,%eax
  802892:	c1 e0 02             	shl    $0x2,%eax
  802895:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80289b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80289e:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8028a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a3:	89 d0                	mov    %edx,%eax
  8028a5:	01 c0                	add    %eax,%eax
  8028a7:	01 d0                	add    %edx,%eax
  8028a9:	c1 e0 02             	shl    $0x2,%eax
  8028ac:	05 48 10 81 00       	add    $0x811048,%eax
  8028b1:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8028b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8028ba:	eb 0c                	jmp    8028c8 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028bc:	ff 45 e4             	incl   -0x1c(%ebp)
  8028bf:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8028c6:	7e 93                	jle    80285b <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8028c8:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8028cc:	0f 84 8d 01 00 00    	je     802a5f <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8028d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8028d9:	e9 74 01 00 00       	jmp    802a52 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8028de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028e4:	0f 84 64 01 00 00    	je     802a4e <realloc+0x3e1>
				if (uhp_frees[k].free)
  8028ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028ed:	89 d0                	mov    %edx,%eax
  8028ef:	01 c0                	add    %eax,%eax
  8028f1:	01 d0                	add    %edx,%eax
  8028f3:	c1 e0 02             	shl    $0x2,%eax
  8028f6:	05 48 10 81 00       	add    $0x811048,%eax
  8028fb:	8a 00                	mov    (%eax),%al
  8028fd:	84 c0                	test   %al,%al
  8028ff:	0f 84 4a 01 00 00    	je     802a4f <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802905:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802908:	89 d0                	mov    %edx,%eax
  80290a:	01 c0                	add    %eax,%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	c1 e0 02             	shl    $0x2,%eax
  802911:	05 40 10 81 00       	add    $0x811040,%eax
  802916:	8b 08                	mov    (%eax),%ecx
  802918:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80291b:	89 d0                	mov    %edx,%eax
  80291d:	01 c0                	add    %eax,%eax
  80291f:	01 d0                	add    %edx,%eax
  802921:	c1 e0 02             	shl    $0x2,%eax
  802924:	05 44 10 81 00       	add    $0x811044,%eax
  802929:	8b 00                	mov    (%eax),%eax
  80292b:	01 c1                	add    %eax,%ecx
  80292d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802930:	89 d0                	mov    %edx,%eax
  802932:	01 c0                	add    %eax,%eax
  802934:	01 d0                	add    %edx,%eax
  802936:	c1 e0 02             	shl    $0x2,%eax
  802939:	05 40 10 81 00       	add    $0x811040,%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	39 c1                	cmp    %eax,%ecx
  802942:	75 7a                	jne    8029be <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802944:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802947:	89 d0                	mov    %edx,%eax
  802949:	01 c0                	add    %eax,%eax
  80294b:	01 d0                	add    %edx,%eax
  80294d:	c1 e0 02             	shl    $0x2,%eax
  802950:	05 40 10 81 00       	add    $0x811040,%eax
  802955:	8b 10                	mov    (%eax),%edx
  802957:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80295a:	89 c8                	mov    %ecx,%eax
  80295c:	01 c0                	add    %eax,%eax
  80295e:	01 c8                	add    %ecx,%eax
  802960:	c1 e0 02             	shl    $0x2,%eax
  802963:	05 40 10 81 00       	add    $0x811040,%eax
  802968:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80296a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296d:	89 d0                	mov    %edx,%eax
  80296f:	01 c0                	add    %eax,%eax
  802971:	01 d0                	add    %edx,%eax
  802973:	c1 e0 02             	shl    $0x2,%eax
  802976:	05 44 10 81 00       	add    $0x811044,%eax
  80297b:	8b 08                	mov    (%eax),%ecx
  80297d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802980:	89 d0                	mov    %edx,%eax
  802982:	01 c0                	add    %eax,%eax
  802984:	01 d0                	add    %edx,%eax
  802986:	c1 e0 02             	shl    $0x2,%eax
  802989:	05 44 10 81 00       	add    $0x811044,%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	01 c1                	add    %eax,%ecx
  802992:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802995:	89 d0                	mov    %edx,%eax
  802997:	01 c0                	add    %eax,%eax
  802999:	01 d0                	add    %edx,%eax
  80299b:	c1 e0 02             	shl    $0x2,%eax
  80299e:	05 44 10 81 00       	add    $0x811044,%eax
  8029a3:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8029a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029a8:	89 d0                	mov    %edx,%eax
  8029aa:	01 c0                	add    %eax,%eax
  8029ac:	01 d0                	add    %edx,%eax
  8029ae:	c1 e0 02             	shl    $0x2,%eax
  8029b1:	05 48 10 81 00       	add    $0x811048,%eax
  8029b6:	c6 00 00             	movb   $0x0,(%eax)
  8029b9:	e9 91 00 00 00       	jmp    802a4f <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8029be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c1:	89 d0                	mov    %edx,%eax
  8029c3:	01 c0                	add    %eax,%eax
  8029c5:	01 d0                	add    %edx,%eax
  8029c7:	c1 e0 02             	shl    $0x2,%eax
  8029ca:	05 40 10 81 00       	add    $0x811040,%eax
  8029cf:	8b 08                	mov    (%eax),%ecx
  8029d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029d4:	89 d0                	mov    %edx,%eax
  8029d6:	01 c0                	add    %eax,%eax
  8029d8:	01 d0                	add    %edx,%eax
  8029da:	c1 e0 02             	shl    $0x2,%eax
  8029dd:	05 44 10 81 00       	add    $0x811044,%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	01 c1                	add    %eax,%ecx
  8029e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029e9:	89 d0                	mov    %edx,%eax
  8029eb:	01 c0                	add    %eax,%eax
  8029ed:	01 d0                	add    %edx,%eax
  8029ef:	c1 e0 02             	shl    $0x2,%eax
  8029f2:	05 40 10 81 00       	add    $0x811040,%eax
  8029f7:	8b 00                	mov    (%eax),%eax
  8029f9:	39 c1                	cmp    %eax,%ecx
  8029fb:	75 52                	jne    802a4f <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8029fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a00:	89 d0                	mov    %edx,%eax
  802a02:	01 c0                	add    %eax,%eax
  802a04:	01 d0                	add    %edx,%eax
  802a06:	c1 e0 02             	shl    $0x2,%eax
  802a09:	05 44 10 81 00       	add    $0x811044,%eax
  802a0e:	8b 08                	mov    (%eax),%ecx
  802a10:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a13:	89 d0                	mov    %edx,%eax
  802a15:	01 c0                	add    %eax,%eax
  802a17:	01 d0                	add    %edx,%eax
  802a19:	c1 e0 02             	shl    $0x2,%eax
  802a1c:	05 44 10 81 00       	add    $0x811044,%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	01 c1                	add    %eax,%ecx
  802a25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a28:	89 d0                	mov    %edx,%eax
  802a2a:	01 c0                	add    %eax,%eax
  802a2c:	01 d0                	add    %edx,%eax
  802a2e:	c1 e0 02             	shl    $0x2,%eax
  802a31:	05 44 10 81 00       	add    $0x811044,%eax
  802a36:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802a38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a3b:	89 d0                	mov    %edx,%eax
  802a3d:	01 c0                	add    %eax,%eax
  802a3f:	01 d0                	add    %edx,%eax
  802a41:	c1 e0 02             	shl    $0x2,%eax
  802a44:	05 48 10 81 00       	add    $0x811048,%eax
  802a49:	c6 00 00             	movb   $0x0,(%eax)
  802a4c:	eb 01                	jmp    802a4f <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802a4e:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802a4f:	ff 45 e0             	incl   -0x20(%ebp)
  802a52:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802a59:	0f 8e 7f fe ff ff    	jle    8028de <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802a5f:	a1 30 51 83 00       	mov    0x835130,%eax
  802a64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802a67:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802a6e:	eb 53                	jmp    802ac3 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802a70:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a73:	89 d0                	mov    %edx,%eax
  802a75:	01 c0                	add    %eax,%eax
  802a77:	01 d0                	add    %edx,%eax
  802a79:	c1 e0 02             	shl    $0x2,%eax
  802a7c:	05 48 50 80 00       	add    $0x805048,%eax
  802a81:	8a 00                	mov    (%eax),%al
  802a83:	84 c0                	test   %al,%al
  802a85:	74 39                	je     802ac0 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802a87:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a8a:	89 d0                	mov    %edx,%eax
  802a8c:	01 c0                	add    %eax,%eax
  802a8e:	01 d0                	add    %edx,%eax
  802a90:	c1 e0 02             	shl    $0x2,%eax
  802a93:	05 40 50 80 00       	add    $0x805040,%eax
  802a98:	8b 08                	mov    (%eax),%ecx
  802a9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a9d:	89 d0                	mov    %edx,%eax
  802a9f:	01 c0                	add    %eax,%eax
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	c1 e0 02             	shl    $0x2,%eax
  802aa6:	05 44 50 80 00       	add    $0x805044,%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	01 c8                	add    %ecx,%eax
  802aaf:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802ab2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ab5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802ab8:	76 06                	jbe    802ac0 <realloc+0x453>
  802aba:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802abd:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802ac0:	ff 45 d8             	incl   -0x28(%ebp)
  802ac3:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802aca:	7e a4                	jle    802a70 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802acc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802acf:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	e9 a9 01 00 00       	jmp    802c85 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802adc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	01 d0                	add    %edx,%eax
  802ae4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802ae7:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802aee:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802af5:	eb 57                	jmp    802b4e <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802af7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802afa:	89 d0                	mov    %edx,%eax
  802afc:	01 c0                	add    %eax,%eax
  802afe:	01 d0                	add    %edx,%eax
  802b00:	c1 e0 02             	shl    $0x2,%eax
  802b03:	05 48 10 81 00       	add    $0x811048,%eax
  802b08:	8a 00                	mov    (%eax),%al
  802b0a:	84 c0                	test   %al,%al
  802b0c:	74 3d                	je     802b4b <realloc+0x4de>
  802b0e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b11:	89 d0                	mov    %edx,%eax
  802b13:	01 c0                	add    %eax,%eax
  802b15:	01 d0                	add    %edx,%eax
  802b17:	c1 e0 02             	shl    $0x2,%eax
  802b1a:	05 40 10 81 00       	add    $0x811040,%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b24:	75 25                	jne    802b4b <realloc+0x4de>
  802b26:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b29:	89 d0                	mov    %edx,%eax
  802b2b:	01 c0                	add    %eax,%eax
  802b2d:	01 d0                	add    %edx,%eax
  802b2f:	c1 e0 02             	shl    $0x2,%eax
  802b32:	05 44 10 81 00       	add    $0x811044,%eax
  802b37:	8b 10                	mov    (%eax),%edx
  802b39:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b3c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b3f:	39 c2                	cmp    %eax,%edx
  802b41:	72 08                	jb     802b4b <realloc+0x4de>
		{
			adjIdx = j; break;
  802b43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b46:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b49:	eb 0c                	jmp    802b57 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b4b:	ff 45 d0             	incl   -0x30(%ebp)
  802b4e:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802b55:	7e a0                	jle    802af7 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802b57:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802b5b:	0f 84 d6 00 00 00    	je     802c37 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802b61:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b64:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b67:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802b6a:	83 ec 08             	sub    $0x8,%esp
  802b6d:	ff 75 a0             	pushl  -0x60(%ebp)
  802b70:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b73:	e8 cf 09 00 00       	call   803547 <sys_allocate_user_mem>
  802b78:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802b7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7e:	89 d0                	mov    %edx,%eax
  802b80:	01 c0                	add    %eax,%eax
  802b82:	01 d0                	add    %edx,%eax
  802b84:	c1 e0 02             	shl    $0x2,%eax
  802b87:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802b8d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b90:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802b92:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b95:	89 d0                	mov    %edx,%eax
  802b97:	01 c0                	add    %eax,%eax
  802b99:	01 d0                	add    %edx,%eax
  802b9b:	c1 e0 02             	shl    $0x2,%eax
  802b9e:	05 40 10 81 00       	add    $0x811040,%eax
  802ba3:	8b 10                	mov    (%eax),%edx
  802ba5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802ba8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802bab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bae:	89 d0                	mov    %edx,%eax
  802bb0:	01 c0                	add    %eax,%eax
  802bb2:	01 d0                	add    %edx,%eax
  802bb4:	c1 e0 02             	shl    $0x2,%eax
  802bb7:	05 40 10 81 00       	add    $0x811040,%eax
  802bbc:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802bbe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bc1:	89 d0                	mov    %edx,%eax
  802bc3:	01 c0                	add    %eax,%eax
  802bc5:	01 d0                	add    %edx,%eax
  802bc7:	c1 e0 02             	shl    $0x2,%eax
  802bca:	05 44 10 81 00       	add    $0x811044,%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802bd4:	89 c2                	mov    %eax,%edx
  802bd6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802bd9:	89 c8                	mov    %ecx,%eax
  802bdb:	01 c0                	add    %eax,%eax
  802bdd:	01 c8                	add    %ecx,%eax
  802bdf:	c1 e0 02             	shl    $0x2,%eax
  802be2:	05 44 10 81 00       	add    $0x811044,%eax
  802be7:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802be9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bec:	89 d0                	mov    %edx,%eax
  802bee:	01 c0                	add    %eax,%eax
  802bf0:	01 d0                	add    %edx,%eax
  802bf2:	c1 e0 02             	shl    $0x2,%eax
  802bf5:	05 44 10 81 00       	add    $0x811044,%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	75 14                	jne    802c14 <realloc+0x5a7>
  802c00:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c03:	89 d0                	mov    %edx,%eax
  802c05:	01 c0                	add    %eax,%eax
  802c07:	01 d0                	add    %edx,%eax
  802c09:	c1 e0 02             	shl    $0x2,%eax
  802c0c:	05 48 10 81 00       	add    $0x811048,%eax
  802c11:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802c14:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c17:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c1a:	01 c2                	add    %eax,%edx
  802c1c:	a1 88 50 83 00       	mov    0x835088,%eax
  802c21:	39 c2                	cmp    %eax,%edx
  802c23:	76 0d                	jbe    802c32 <realloc+0x5c5>
  802c25:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c28:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c2b:	01 d0                	add    %edx,%eax
  802c2d:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	eb 4e                	jmp    802c85 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802c37:	83 ec 0c             	sub    $0xc,%esp
  802c3a:	ff 75 0c             	pushl  0xc(%ebp)
  802c3d:	e8 0b ec ff ff       	call   80184d <malloc>
  802c42:	83 c4 10             	add    $0x10,%esp
  802c45:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802c48:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802c4c:	75 07                	jne    802c55 <realloc+0x5e8>
		return NULL;
  802c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c53:	eb 30                	jmp    802c85 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802c55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c58:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c5b:	39 d0                	cmp    %edx,%eax
  802c5d:	76 02                	jbe    802c61 <realloc+0x5f4>
  802c5f:	89 d0                	mov    %edx,%eax
  802c61:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	50                   	push   %eax
  802c68:	52                   	push   %edx
  802c69:	ff 75 cc             	pushl  -0x34(%ebp)
  802c6c:	e8 cf 06 00 00       	call   803340 <sys_move_user_mem>
  802c71:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802c74:	83 ec 0c             	sub    $0xc,%esp
  802c77:	ff 75 08             	pushl  0x8(%ebp)
  802c7a:	e8 2e ef ff ff       	call   801bad <free>
  802c7f:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802c82:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802c85:	c9                   	leave  
  802c86:	c3                   	ret    

00802c87 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802c87:	55                   	push   %ebp
  802c88:	89 e5                	mov    %esp,%ebp
  802c8a:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802c93:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c97:	0f 84 33 03 00 00    	je     802fd0 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802c9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca0:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802ca5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802ca8:	83 ec 08             	sub    $0x8,%esp
  802cab:	ff 75 08             	pushl  0x8(%ebp)
  802cae:	ff 75 d8             	pushl  -0x28(%ebp)
  802cb1:	e8 7d 05 00 00       	call   803233 <sys_delete_shared_object>
  802cb6:	83 c4 10             	add    $0x10,%esp
  802cb9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802cbc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802cc0:	0f 88 0d 03 00 00    	js     802fd3 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ccd:	e9 ef 02 00 00       	jmp    802fc1 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802cd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd5:	89 d0                	mov    %edx,%eax
  802cd7:	01 c0                	add    %eax,%eax
  802cd9:	01 d0                	add    %edx,%eax
  802cdb:	c1 e0 02             	shl    $0x2,%eax
  802cde:	05 48 50 80 00       	add    $0x805048,%eax
  802ce3:	8a 00                	mov    (%eax),%al
  802ce5:	84 c0                	test   %al,%al
  802ce7:	0f 84 d1 02 00 00    	je     802fbe <sfree+0x337>
  802ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf0:	89 d0                	mov    %edx,%eax
  802cf2:	01 c0                	add    %eax,%eax
  802cf4:	01 d0                	add    %edx,%eax
  802cf6:	c1 e0 02             	shl    $0x2,%eax
  802cf9:	05 40 50 80 00       	add    $0x805040,%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d03:	0f 85 b5 02 00 00    	jne    802fbe <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0c:	89 d0                	mov    %edx,%eax
  802d0e:	01 c0                	add    %eax,%eax
  802d10:	01 d0                	add    %edx,%eax
  802d12:	c1 e0 02             	shl    $0x2,%eax
  802d15:	05 44 50 80 00       	add    $0x805044,%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802d1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d22:	89 d0                	mov    %edx,%eax
  802d24:	01 c0                	add    %eax,%eax
  802d26:	01 d0                	add    %edx,%eax
  802d28:	c1 e0 02             	shl    $0x2,%eax
  802d2b:	05 48 50 80 00       	add    $0x805048,%eax
  802d30:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802d33:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802d3a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802d41:	eb 64                	jmp    802da7 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802d43:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d46:	89 d0                	mov    %edx,%eax
  802d48:	01 c0                	add    %eax,%eax
  802d4a:	01 d0                	add    %edx,%eax
  802d4c:	c1 e0 02             	shl    $0x2,%eax
  802d4f:	05 48 10 81 00       	add    $0x811048,%eax
  802d54:	8a 00                	mov    (%eax),%al
  802d56:	84 c0                	test   %al,%al
  802d58:	75 4a                	jne    802da4 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802d5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d5d:	89 d0                	mov    %edx,%eax
  802d5f:	01 c0                	add    %eax,%eax
  802d61:	01 d0                	add    %edx,%eax
  802d63:	c1 e0 02             	shl    $0x2,%eax
  802d66:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802d6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6f:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802d71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d74:	89 d0                	mov    %edx,%eax
  802d76:	01 c0                	add    %eax,%eax
  802d78:	01 d0                	add    %edx,%eax
  802d7a:	c1 e0 02             	shl    $0x2,%eax
  802d7d:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802d83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d86:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802d88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d8b:	89 d0                	mov    %edx,%eax
  802d8d:	01 c0                	add    %eax,%eax
  802d8f:	01 d0                	add    %edx,%eax
  802d91:	c1 e0 02             	shl    $0x2,%eax
  802d94:	05 48 10 81 00       	add    $0x811048,%eax
  802d99:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802da2:	eb 0c                	jmp    802db0 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802da4:	ff 45 ec             	incl   -0x14(%ebp)
  802da7:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802dae:	7e 93                	jle    802d43 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802db0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802db4:	0f 84 8d 01 00 00    	je     802f47 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802dba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802dc1:	e9 74 01 00 00       	jmp    802f3a <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802dc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dcc:	0f 84 64 01 00 00    	je     802f36 <sfree+0x2af>
					if (uhp_frees[k].free)
  802dd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd5:	89 d0                	mov    %edx,%eax
  802dd7:	01 c0                	add    %eax,%eax
  802dd9:	01 d0                	add    %edx,%eax
  802ddb:	c1 e0 02             	shl    $0x2,%eax
  802dde:	05 48 10 81 00       	add    $0x811048,%eax
  802de3:	8a 00                	mov    (%eax),%al
  802de5:	84 c0                	test   %al,%al
  802de7:	0f 84 4a 01 00 00    	je     802f37 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802ded:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802df0:	89 d0                	mov    %edx,%eax
  802df2:	01 c0                	add    %eax,%eax
  802df4:	01 d0                	add    %edx,%eax
  802df6:	c1 e0 02             	shl    $0x2,%eax
  802df9:	05 40 10 81 00       	add    $0x811040,%eax
  802dfe:	8b 08                	mov    (%eax),%ecx
  802e00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e03:	89 d0                	mov    %edx,%eax
  802e05:	01 c0                	add    %eax,%eax
  802e07:	01 d0                	add    %edx,%eax
  802e09:	c1 e0 02             	shl    $0x2,%eax
  802e0c:	05 44 10 81 00       	add    $0x811044,%eax
  802e11:	8b 00                	mov    (%eax),%eax
  802e13:	01 c1                	add    %eax,%ecx
  802e15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e18:	89 d0                	mov    %edx,%eax
  802e1a:	01 c0                	add    %eax,%eax
  802e1c:	01 d0                	add    %edx,%eax
  802e1e:	c1 e0 02             	shl    $0x2,%eax
  802e21:	05 40 10 81 00       	add    $0x811040,%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	39 c1                	cmp    %eax,%ecx
  802e2a:	75 7a                	jne    802ea6 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802e2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e2f:	89 d0                	mov    %edx,%eax
  802e31:	01 c0                	add    %eax,%eax
  802e33:	01 d0                	add    %edx,%eax
  802e35:	c1 e0 02             	shl    $0x2,%eax
  802e38:	05 40 10 81 00       	add    $0x811040,%eax
  802e3d:	8b 10                	mov    (%eax),%edx
  802e3f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e42:	89 c8                	mov    %ecx,%eax
  802e44:	01 c0                	add    %eax,%eax
  802e46:	01 c8                	add    %ecx,%eax
  802e48:	c1 e0 02             	shl    $0x2,%eax
  802e4b:	05 40 10 81 00       	add    $0x811040,%eax
  802e50:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802e52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e55:	89 d0                	mov    %edx,%eax
  802e57:	01 c0                	add    %eax,%eax
  802e59:	01 d0                	add    %edx,%eax
  802e5b:	c1 e0 02             	shl    $0x2,%eax
  802e5e:	05 44 10 81 00       	add    $0x811044,%eax
  802e63:	8b 08                	mov    (%eax),%ecx
  802e65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e68:	89 d0                	mov    %edx,%eax
  802e6a:	01 c0                	add    %eax,%eax
  802e6c:	01 d0                	add    %edx,%eax
  802e6e:	c1 e0 02             	shl    $0x2,%eax
  802e71:	05 44 10 81 00       	add    $0x811044,%eax
  802e76:	8b 00                	mov    (%eax),%eax
  802e78:	01 c1                	add    %eax,%ecx
  802e7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7d:	89 d0                	mov    %edx,%eax
  802e7f:	01 c0                	add    %eax,%eax
  802e81:	01 d0                	add    %edx,%eax
  802e83:	c1 e0 02             	shl    $0x2,%eax
  802e86:	05 44 10 81 00       	add    $0x811044,%eax
  802e8b:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802e8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e90:	89 d0                	mov    %edx,%eax
  802e92:	01 c0                	add    %eax,%eax
  802e94:	01 d0                	add    %edx,%eax
  802e96:	c1 e0 02             	shl    $0x2,%eax
  802e99:	05 48 10 81 00       	add    $0x811048,%eax
  802e9e:	c6 00 00             	movb   $0x0,(%eax)
  802ea1:	e9 91 00 00 00       	jmp    802f37 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802ea6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea9:	89 d0                	mov    %edx,%eax
  802eab:	01 c0                	add    %eax,%eax
  802ead:	01 d0                	add    %edx,%eax
  802eaf:	c1 e0 02             	shl    $0x2,%eax
  802eb2:	05 40 10 81 00       	add    $0x811040,%eax
  802eb7:	8b 08                	mov    (%eax),%ecx
  802eb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ebc:	89 d0                	mov    %edx,%eax
  802ebe:	01 c0                	add    %eax,%eax
  802ec0:	01 d0                	add    %edx,%eax
  802ec2:	c1 e0 02             	shl    $0x2,%eax
  802ec5:	05 44 10 81 00       	add    $0x811044,%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	01 c1                	add    %eax,%ecx
  802ece:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed1:	89 d0                	mov    %edx,%eax
  802ed3:	01 c0                	add    %eax,%eax
  802ed5:	01 d0                	add    %edx,%eax
  802ed7:	c1 e0 02             	shl    $0x2,%eax
  802eda:	05 40 10 81 00       	add    $0x811040,%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	39 c1                	cmp    %eax,%ecx
  802ee3:	75 52                	jne    802f37 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802ee5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee8:	89 d0                	mov    %edx,%eax
  802eea:	01 c0                	add    %eax,%eax
  802eec:	01 d0                	add    %edx,%eax
  802eee:	c1 e0 02             	shl    $0x2,%eax
  802ef1:	05 44 10 81 00       	add    $0x811044,%eax
  802ef6:	8b 08                	mov    (%eax),%ecx
  802ef8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802efb:	89 d0                	mov    %edx,%eax
  802efd:	01 c0                	add    %eax,%eax
  802eff:	01 d0                	add    %edx,%eax
  802f01:	c1 e0 02             	shl    $0x2,%eax
  802f04:	05 44 10 81 00       	add    $0x811044,%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	01 c1                	add    %eax,%ecx
  802f0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f10:	89 d0                	mov    %edx,%eax
  802f12:	01 c0                	add    %eax,%eax
  802f14:	01 d0                	add    %edx,%eax
  802f16:	c1 e0 02             	shl    $0x2,%eax
  802f19:	05 44 10 81 00       	add    $0x811044,%eax
  802f1e:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802f20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f23:	89 d0                	mov    %edx,%eax
  802f25:	01 c0                	add    %eax,%eax
  802f27:	01 d0                	add    %edx,%eax
  802f29:	c1 e0 02             	shl    $0x2,%eax
  802f2c:	05 48 10 81 00       	add    $0x811048,%eax
  802f31:	c6 00 00             	movb   $0x0,(%eax)
  802f34:	eb 01                	jmp    802f37 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802f36:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802f37:	ff 45 e8             	incl   -0x18(%ebp)
  802f3a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802f41:	0f 8e 7f fe ff ff    	jle    802dc6 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802f47:	a1 30 51 83 00       	mov    0x835130,%eax
  802f4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802f4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802f56:	eb 53                	jmp    802fab <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802f58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f5b:	89 d0                	mov    %edx,%eax
  802f5d:	01 c0                	add    %eax,%eax
  802f5f:	01 d0                	add    %edx,%eax
  802f61:	c1 e0 02             	shl    $0x2,%eax
  802f64:	05 48 50 80 00       	add    $0x805048,%eax
  802f69:	8a 00                	mov    (%eax),%al
  802f6b:	84 c0                	test   %al,%al
  802f6d:	74 39                	je     802fa8 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802f6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f72:	89 d0                	mov    %edx,%eax
  802f74:	01 c0                	add    %eax,%eax
  802f76:	01 d0                	add    %edx,%eax
  802f78:	c1 e0 02             	shl    $0x2,%eax
  802f7b:	05 40 50 80 00       	add    $0x805040,%eax
  802f80:	8b 08                	mov    (%eax),%ecx
  802f82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f85:	89 d0                	mov    %edx,%eax
  802f87:	01 c0                	add    %eax,%eax
  802f89:	01 d0                	add    %edx,%eax
  802f8b:	c1 e0 02             	shl    $0x2,%eax
  802f8e:	05 44 50 80 00       	add    $0x805044,%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	01 c8                	add    %ecx,%eax
  802f97:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802f9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f9d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802fa0:	76 06                	jbe    802fa8 <sfree+0x321>
  802fa2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802fa8:	ff 45 e0             	incl   -0x20(%ebp)
  802fab:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802fb2:	7e a4                	jle    802f58 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb7:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802fbc:	eb 16                	jmp    802fd4 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802fbe:	ff 45 f4             	incl   -0xc(%ebp)
  802fc1:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802fc8:	0f 8e 04 fd ff ff    	jle    802cd2 <sfree+0x4b>
  802fce:	eb 04                	jmp    802fd4 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802fd0:	90                   	nop
  802fd1:	eb 01                	jmp    802fd4 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802fd3:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802fd4:	c9                   	leave  
  802fd5:	c3                   	ret    

00802fd6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802fd6:	55                   	push   %ebp
  802fd7:	89 e5                	mov    %esp,%ebp
  802fd9:	57                   	push   %edi
  802fda:	56                   	push   %esi
  802fdb:	53                   	push   %ebx
  802fdc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fe8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802feb:	8b 7d 18             	mov    0x18(%ebp),%edi
  802fee:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ff1:	cd 30                	int    $0x30
  802ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ff9:	83 c4 10             	add    $0x10,%esp
  802ffc:	5b                   	pop    %ebx
  802ffd:	5e                   	pop    %esi
  802ffe:	5f                   	pop    %edi
  802fff:	5d                   	pop    %ebp
  803000:	c3                   	ret    

00803001 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803001:	55                   	push   %ebp
  803002:	89 e5                	mov    %esp,%ebp
  803004:	83 ec 04             	sub    $0x4,%esp
  803007:	8b 45 10             	mov    0x10(%ebp),%eax
  80300a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80300d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803010:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	6a 00                	push   $0x0
  803019:	51                   	push   %ecx
  80301a:	52                   	push   %edx
  80301b:	ff 75 0c             	pushl  0xc(%ebp)
  80301e:	50                   	push   %eax
  80301f:	6a 00                	push   $0x0
  803021:	e8 b0 ff ff ff       	call   802fd6 <syscall>
  803026:	83 c4 18             	add    $0x18,%esp
}
  803029:	90                   	nop
  80302a:	c9                   	leave  
  80302b:	c3                   	ret    

0080302c <sys_cgetc>:

int
sys_cgetc(void)
{
  80302c:	55                   	push   %ebp
  80302d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80302f:	6a 00                	push   $0x0
  803031:	6a 00                	push   $0x0
  803033:	6a 00                	push   $0x0
  803035:	6a 00                	push   $0x0
  803037:	6a 00                	push   $0x0
  803039:	6a 02                	push   $0x2
  80303b:	e8 96 ff ff ff       	call   802fd6 <syscall>
  803040:	83 c4 18             	add    $0x18,%esp
}
  803043:	c9                   	leave  
  803044:	c3                   	ret    

00803045 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803045:	55                   	push   %ebp
  803046:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	6a 03                	push   $0x3
  803054:	e8 7d ff ff ff       	call   802fd6 <syscall>
  803059:	83 c4 18             	add    $0x18,%esp
}
  80305c:	90                   	nop
  80305d:	c9                   	leave  
  80305e:	c3                   	ret    

0080305f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80305f:	55                   	push   %ebp
  803060:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	6a 00                	push   $0x0
  80306a:	6a 00                	push   $0x0
  80306c:	6a 04                	push   $0x4
  80306e:	e8 63 ff ff ff       	call   802fd6 <syscall>
  803073:	83 c4 18             	add    $0x18,%esp
}
  803076:	90                   	nop
  803077:	c9                   	leave  
  803078:	c3                   	ret    

00803079 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803079:	55                   	push   %ebp
  80307a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80307c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	6a 00                	push   $0x0
  803084:	6a 00                	push   $0x0
  803086:	6a 00                	push   $0x0
  803088:	52                   	push   %edx
  803089:	50                   	push   %eax
  80308a:	6a 08                	push   $0x8
  80308c:	e8 45 ff ff ff       	call   802fd6 <syscall>
  803091:	83 c4 18             	add    $0x18,%esp
}
  803094:	c9                   	leave  
  803095:	c3                   	ret    

00803096 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803096:	55                   	push   %ebp
  803097:	89 e5                	mov    %esp,%ebp
  803099:	56                   	push   %esi
  80309a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80309b:	8b 75 18             	mov    0x18(%ebp),%esi
  80309e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8030a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	56                   	push   %esi
  8030ab:	53                   	push   %ebx
  8030ac:	51                   	push   %ecx
  8030ad:	52                   	push   %edx
  8030ae:	50                   	push   %eax
  8030af:	6a 09                	push   $0x9
  8030b1:	e8 20 ff ff ff       	call   802fd6 <syscall>
  8030b6:	83 c4 18             	add    $0x18,%esp
}
  8030b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030bc:	5b                   	pop    %ebx
  8030bd:	5e                   	pop    %esi
  8030be:	5d                   	pop    %ebp
  8030bf:	c3                   	ret    

008030c0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8030c0:	55                   	push   %ebp
  8030c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	ff 75 08             	pushl  0x8(%ebp)
  8030ce:	6a 0a                	push   $0xa
  8030d0:	e8 01 ff ff ff       	call   802fd6 <syscall>
  8030d5:	83 c4 18             	add    $0x18,%esp
}
  8030d8:	c9                   	leave  
  8030d9:	c3                   	ret    

008030da <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8030da:	55                   	push   %ebp
  8030db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 00                	push   $0x0
  8030e3:	ff 75 0c             	pushl  0xc(%ebp)
  8030e6:	ff 75 08             	pushl  0x8(%ebp)
  8030e9:	6a 0b                	push   $0xb
  8030eb:	e8 e6 fe ff ff       	call   802fd6 <syscall>
  8030f0:	83 c4 18             	add    $0x18,%esp
}
  8030f3:	c9                   	leave  
  8030f4:	c3                   	ret    

008030f5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8030f5:	55                   	push   %ebp
  8030f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 00                	push   $0x0
  8030fe:	6a 00                	push   $0x0
  803100:	6a 00                	push   $0x0
  803102:	6a 0c                	push   $0xc
  803104:	e8 cd fe ff ff       	call   802fd6 <syscall>
  803109:	83 c4 18             	add    $0x18,%esp
}
  80310c:	c9                   	leave  
  80310d:	c3                   	ret    

0080310e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80310e:	55                   	push   %ebp
  80310f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	6a 00                	push   $0x0
  803119:	6a 00                	push   $0x0
  80311b:	6a 0d                	push   $0xd
  80311d:	e8 b4 fe ff ff       	call   802fd6 <syscall>
  803122:	83 c4 18             	add    $0x18,%esp
}
  803125:	c9                   	leave  
  803126:	c3                   	ret    

00803127 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803127:	55                   	push   %ebp
  803128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 00                	push   $0x0
  803134:	6a 0e                	push   $0xe
  803136:	e8 9b fe ff ff       	call   802fd6 <syscall>
  80313b:	83 c4 18             	add    $0x18,%esp
}
  80313e:	c9                   	leave  
  80313f:	c3                   	ret    

00803140 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803140:	55                   	push   %ebp
  803141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 00                	push   $0x0
  80314b:	6a 00                	push   $0x0
  80314d:	6a 0f                	push   $0xf
  80314f:	e8 82 fe ff ff       	call   802fd6 <syscall>
  803154:	83 c4 18             	add    $0x18,%esp
}
  803157:	c9                   	leave  
  803158:	c3                   	ret    

00803159 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803159:	55                   	push   %ebp
  80315a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 00                	push   $0x0
  803162:	6a 00                	push   $0x0
  803164:	ff 75 08             	pushl  0x8(%ebp)
  803167:	6a 10                	push   $0x10
  803169:	e8 68 fe ff ff       	call   802fd6 <syscall>
  80316e:	83 c4 18             	add    $0x18,%esp
}
  803171:	c9                   	leave  
  803172:	c3                   	ret    

00803173 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803173:	55                   	push   %ebp
  803174:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 00                	push   $0x0
  80317e:	6a 00                	push   $0x0
  803180:	6a 11                	push   $0x11
  803182:	e8 4f fe ff ff       	call   802fd6 <syscall>
  803187:	83 c4 18             	add    $0x18,%esp
}
  80318a:	90                   	nop
  80318b:	c9                   	leave  
  80318c:	c3                   	ret    

0080318d <sys_cputc>:

void
sys_cputc(const char c)
{
  80318d:	55                   	push   %ebp
  80318e:	89 e5                	mov    %esp,%ebp
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803199:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80319d:	6a 00                	push   $0x0
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	50                   	push   %eax
  8031a6:	6a 01                	push   $0x1
  8031a8:	e8 29 fe ff ff       	call   802fd6 <syscall>
  8031ad:	83 c4 18             	add    $0x18,%esp
}
  8031b0:	90                   	nop
  8031b1:	c9                   	leave  
  8031b2:	c3                   	ret    

008031b3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8031b3:	55                   	push   %ebp
  8031b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8031b6:	6a 00                	push   $0x0
  8031b8:	6a 00                	push   $0x0
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 14                	push   $0x14
  8031c2:	e8 0f fe ff ff       	call   802fd6 <syscall>
  8031c7:	83 c4 18             	add    $0x18,%esp
}
  8031ca:	90                   	nop
  8031cb:	c9                   	leave  
  8031cc:	c3                   	ret    

008031cd <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8031cd:	55                   	push   %ebp
  8031ce:	89 e5                	mov    %esp,%ebp
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8031d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8031d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	6a 00                	push   $0x0
  8031e5:	51                   	push   %ecx
  8031e6:	52                   	push   %edx
  8031e7:	ff 75 0c             	pushl  0xc(%ebp)
  8031ea:	50                   	push   %eax
  8031eb:	6a 15                	push   $0x15
  8031ed:	e8 e4 fd ff ff       	call   802fd6 <syscall>
  8031f2:	83 c4 18             	add    $0x18,%esp
}
  8031f5:	c9                   	leave  
  8031f6:	c3                   	ret    

008031f7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8031f7:	55                   	push   %ebp
  8031f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	6a 00                	push   $0x0
  803202:	6a 00                	push   $0x0
  803204:	6a 00                	push   $0x0
  803206:	52                   	push   %edx
  803207:	50                   	push   %eax
  803208:	6a 16                	push   $0x16
  80320a:	e8 c7 fd ff ff       	call   802fd6 <syscall>
  80320f:	83 c4 18             	add    $0x18,%esp
}
  803212:	c9                   	leave  
  803213:	c3                   	ret    

00803214 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803214:	55                   	push   %ebp
  803215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803217:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80321a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	51                   	push   %ecx
  803225:	52                   	push   %edx
  803226:	50                   	push   %eax
  803227:	6a 17                	push   $0x17
  803229:	e8 a8 fd ff ff       	call   802fd6 <syscall>
  80322e:	83 c4 18             	add    $0x18,%esp
}
  803231:	c9                   	leave  
  803232:	c3                   	ret    

00803233 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803233:	55                   	push   %ebp
  803234:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803236:	8b 55 0c             	mov    0xc(%ebp),%edx
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	6a 00                	push   $0x0
  803242:	52                   	push   %edx
  803243:	50                   	push   %eax
  803244:	6a 18                	push   $0x18
  803246:	e8 8b fd ff ff       	call   802fd6 <syscall>
  80324b:	83 c4 18             	add    $0x18,%esp
}
  80324e:	c9                   	leave  
  80324f:	c3                   	ret    

00803250 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803250:	55                   	push   %ebp
  803251:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	6a 00                	push   $0x0
  803258:	ff 75 14             	pushl  0x14(%ebp)
  80325b:	ff 75 10             	pushl  0x10(%ebp)
  80325e:	ff 75 0c             	pushl  0xc(%ebp)
  803261:	50                   	push   %eax
  803262:	6a 19                	push   $0x19
  803264:	e8 6d fd ff ff       	call   802fd6 <syscall>
  803269:	83 c4 18             	add    $0x18,%esp
}
  80326c:	c9                   	leave  
  80326d:	c3                   	ret    

0080326e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80326e:	55                   	push   %ebp
  80326f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	6a 00                	push   $0x0
  803276:	6a 00                	push   $0x0
  803278:	6a 00                	push   $0x0
  80327a:	6a 00                	push   $0x0
  80327c:	50                   	push   %eax
  80327d:	6a 1a                	push   $0x1a
  80327f:	e8 52 fd ff ff       	call   802fd6 <syscall>
  803284:	83 c4 18             	add    $0x18,%esp
}
  803287:	90                   	nop
  803288:	c9                   	leave  
  803289:	c3                   	ret    

0080328a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80328a:	55                   	push   %ebp
  80328b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	6a 00                	push   $0x0
  803292:	6a 00                	push   $0x0
  803294:	6a 00                	push   $0x0
  803296:	6a 00                	push   $0x0
  803298:	50                   	push   %eax
  803299:	6a 1b                	push   $0x1b
  80329b:	e8 36 fd ff ff       	call   802fd6 <syscall>
  8032a0:	83 c4 18             	add    $0x18,%esp
}
  8032a3:	c9                   	leave  
  8032a4:	c3                   	ret    

008032a5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8032a5:	55                   	push   %ebp
  8032a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8032a8:	6a 00                	push   $0x0
  8032aa:	6a 00                	push   $0x0
  8032ac:	6a 00                	push   $0x0
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 05                	push   $0x5
  8032b4:	e8 1d fd ff ff       	call   802fd6 <syscall>
  8032b9:	83 c4 18             	add    $0x18,%esp
}
  8032bc:	c9                   	leave  
  8032bd:	c3                   	ret    

008032be <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8032be:	55                   	push   %ebp
  8032bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8032c1:	6a 00                	push   $0x0
  8032c3:	6a 00                	push   $0x0
  8032c5:	6a 00                	push   $0x0
  8032c7:	6a 00                	push   $0x0
  8032c9:	6a 00                	push   $0x0
  8032cb:	6a 06                	push   $0x6
  8032cd:	e8 04 fd ff ff       	call   802fd6 <syscall>
  8032d2:	83 c4 18             	add    $0x18,%esp
}
  8032d5:	c9                   	leave  
  8032d6:	c3                   	ret    

008032d7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8032d7:	55                   	push   %ebp
  8032d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8032da:	6a 00                	push   $0x0
  8032dc:	6a 00                	push   $0x0
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 00                	push   $0x0
  8032e4:	6a 07                	push   $0x7
  8032e6:	e8 eb fc ff ff       	call   802fd6 <syscall>
  8032eb:	83 c4 18             	add    $0x18,%esp
}
  8032ee:	c9                   	leave  
  8032ef:	c3                   	ret    

008032f0 <sys_exit_env>:


void sys_exit_env(void)
{
  8032f0:	55                   	push   %ebp
  8032f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032f3:	6a 00                	push   $0x0
  8032f5:	6a 00                	push   $0x0
  8032f7:	6a 00                	push   $0x0
  8032f9:	6a 00                	push   $0x0
  8032fb:	6a 00                	push   $0x0
  8032fd:	6a 1c                	push   $0x1c
  8032ff:	e8 d2 fc ff ff       	call   802fd6 <syscall>
  803304:	83 c4 18             	add    $0x18,%esp
}
  803307:	90                   	nop
  803308:	c9                   	leave  
  803309:	c3                   	ret    

0080330a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80330a:	55                   	push   %ebp
  80330b:	89 e5                	mov    %esp,%ebp
  80330d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803310:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803313:	8d 50 04             	lea    0x4(%eax),%edx
  803316:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803319:	6a 00                	push   $0x0
  80331b:	6a 00                	push   $0x0
  80331d:	6a 00                	push   $0x0
  80331f:	52                   	push   %edx
  803320:	50                   	push   %eax
  803321:	6a 1d                	push   $0x1d
  803323:	e8 ae fc ff ff       	call   802fd6 <syscall>
  803328:	83 c4 18             	add    $0x18,%esp
	return result;
  80332b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80332e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803331:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803334:	89 01                	mov    %eax,(%ecx)
  803336:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	c9                   	leave  
  80333d:	c2 04 00             	ret    $0x4

00803340 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803340:	55                   	push   %ebp
  803341:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803343:	6a 00                	push   $0x0
  803345:	6a 00                	push   $0x0
  803347:	ff 75 10             	pushl  0x10(%ebp)
  80334a:	ff 75 0c             	pushl  0xc(%ebp)
  80334d:	ff 75 08             	pushl  0x8(%ebp)
  803350:	6a 13                	push   $0x13
  803352:	e8 7f fc ff ff       	call   802fd6 <syscall>
  803357:	83 c4 18             	add    $0x18,%esp
	return ;
  80335a:	90                   	nop
}
  80335b:	c9                   	leave  
  80335c:	c3                   	ret    

0080335d <sys_rcr2>:
uint32 sys_rcr2()
{
  80335d:	55                   	push   %ebp
  80335e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803360:	6a 00                	push   $0x0
  803362:	6a 00                	push   $0x0
  803364:	6a 00                	push   $0x0
  803366:	6a 00                	push   $0x0
  803368:	6a 00                	push   $0x0
  80336a:	6a 1e                	push   $0x1e
  80336c:	e8 65 fc ff ff       	call   802fd6 <syscall>
  803371:	83 c4 18             	add    $0x18,%esp
}
  803374:	c9                   	leave  
  803375:	c3                   	ret    

00803376 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803376:	55                   	push   %ebp
  803377:	89 e5                	mov    %esp,%ebp
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803382:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803386:	6a 00                	push   $0x0
  803388:	6a 00                	push   $0x0
  80338a:	6a 00                	push   $0x0
  80338c:	6a 00                	push   $0x0
  80338e:	50                   	push   %eax
  80338f:	6a 1f                	push   $0x1f
  803391:	e8 40 fc ff ff       	call   802fd6 <syscall>
  803396:	83 c4 18             	add    $0x18,%esp
	return ;
  803399:	90                   	nop
}
  80339a:	c9                   	leave  
  80339b:	c3                   	ret    

0080339c <rsttst>:
void rsttst()
{
  80339c:	55                   	push   %ebp
  80339d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 00                	push   $0x0
  8033a5:	6a 00                	push   $0x0
  8033a7:	6a 00                	push   $0x0
  8033a9:	6a 21                	push   $0x21
  8033ab:	e8 26 fc ff ff       	call   802fd6 <syscall>
  8033b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8033b3:	90                   	nop
}
  8033b4:	c9                   	leave  
  8033b5:	c3                   	ret    

008033b6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8033b6:	55                   	push   %ebp
  8033b7:	89 e5                	mov    %esp,%ebp
  8033b9:	83 ec 04             	sub    $0x4,%esp
  8033bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8033bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8033c2:	8b 55 18             	mov    0x18(%ebp),%edx
  8033c5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8033c9:	52                   	push   %edx
  8033ca:	50                   	push   %eax
  8033cb:	ff 75 10             	pushl  0x10(%ebp)
  8033ce:	ff 75 0c             	pushl  0xc(%ebp)
  8033d1:	ff 75 08             	pushl  0x8(%ebp)
  8033d4:	6a 20                	push   $0x20
  8033d6:	e8 fb fb ff ff       	call   802fd6 <syscall>
  8033db:	83 c4 18             	add    $0x18,%esp
	return ;
  8033de:	90                   	nop
}
  8033df:	c9                   	leave  
  8033e0:	c3                   	ret    

008033e1 <chktst>:
void chktst(uint32 n)
{
  8033e1:	55                   	push   %ebp
  8033e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 00                	push   $0x0
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 00                	push   $0x0
  8033ec:	ff 75 08             	pushl  0x8(%ebp)
  8033ef:	6a 22                	push   $0x22
  8033f1:	e8 e0 fb ff ff       	call   802fd6 <syscall>
  8033f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8033f9:	90                   	nop
}
  8033fa:	c9                   	leave  
  8033fb:	c3                   	ret    

008033fc <inctst>:

void inctst()
{
  8033fc:	55                   	push   %ebp
  8033fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033ff:	6a 00                	push   $0x0
  803401:	6a 00                	push   $0x0
  803403:	6a 00                	push   $0x0
  803405:	6a 00                	push   $0x0
  803407:	6a 00                	push   $0x0
  803409:	6a 23                	push   $0x23
  80340b:	e8 c6 fb ff ff       	call   802fd6 <syscall>
  803410:	83 c4 18             	add    $0x18,%esp
	return ;
  803413:	90                   	nop
}
  803414:	c9                   	leave  
  803415:	c3                   	ret    

00803416 <gettst>:
uint32 gettst()
{
  803416:	55                   	push   %ebp
  803417:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803419:	6a 00                	push   $0x0
  80341b:	6a 00                	push   $0x0
  80341d:	6a 00                	push   $0x0
  80341f:	6a 00                	push   $0x0
  803421:	6a 00                	push   $0x0
  803423:	6a 24                	push   $0x24
  803425:	e8 ac fb ff ff       	call   802fd6 <syscall>
  80342a:	83 c4 18             	add    $0x18,%esp
}
  80342d:	c9                   	leave  
  80342e:	c3                   	ret    

0080342f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80342f:	55                   	push   %ebp
  803430:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803432:	6a 00                	push   $0x0
  803434:	6a 00                	push   $0x0
  803436:	6a 00                	push   $0x0
  803438:	6a 00                	push   $0x0
  80343a:	6a 00                	push   $0x0
  80343c:	6a 25                	push   $0x25
  80343e:	e8 93 fb ff ff       	call   802fd6 <syscall>
  803443:	83 c4 18             	add    $0x18,%esp
  803446:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  80344b:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803450:	c9                   	leave  
  803451:	c3                   	ret    

00803452 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803452:	55                   	push   %ebp
  803453:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80345d:	6a 00                	push   $0x0
  80345f:	6a 00                	push   $0x0
  803461:	6a 00                	push   $0x0
  803463:	6a 00                	push   $0x0
  803465:	ff 75 08             	pushl  0x8(%ebp)
  803468:	6a 26                	push   $0x26
  80346a:	e8 67 fb ff ff       	call   802fd6 <syscall>
  80346f:	83 c4 18             	add    $0x18,%esp
	return ;
  803472:	90                   	nop
}
  803473:	c9                   	leave  
  803474:	c3                   	ret    

00803475 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803475:	55                   	push   %ebp
  803476:	89 e5                	mov    %esp,%ebp
  803478:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803479:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80347c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80347f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803482:	8b 45 08             	mov    0x8(%ebp),%eax
  803485:	6a 00                	push   $0x0
  803487:	53                   	push   %ebx
  803488:	51                   	push   %ecx
  803489:	52                   	push   %edx
  80348a:	50                   	push   %eax
  80348b:	6a 27                	push   $0x27
  80348d:	e8 44 fb ff ff       	call   802fd6 <syscall>
  803492:	83 c4 18             	add    $0x18,%esp
}
  803495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803498:	c9                   	leave  
  803499:	c3                   	ret    

0080349a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80349a:	55                   	push   %ebp
  80349b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80349d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	6a 00                	push   $0x0
  8034a5:	6a 00                	push   $0x0
  8034a7:	6a 00                	push   $0x0
  8034a9:	52                   	push   %edx
  8034aa:	50                   	push   %eax
  8034ab:	6a 28                	push   $0x28
  8034ad:	e8 24 fb ff ff       	call   802fd6 <syscall>
  8034b2:	83 c4 18             	add    $0x18,%esp
}
  8034b5:	c9                   	leave  
  8034b6:	c3                   	ret    

008034b7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8034b7:	55                   	push   %ebp
  8034b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8034ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8034bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	6a 00                	push   $0x0
  8034c5:	51                   	push   %ecx
  8034c6:	ff 75 10             	pushl  0x10(%ebp)
  8034c9:	52                   	push   %edx
  8034ca:	50                   	push   %eax
  8034cb:	6a 29                	push   $0x29
  8034cd:	e8 04 fb ff ff       	call   802fd6 <syscall>
  8034d2:	83 c4 18             	add    $0x18,%esp
}
  8034d5:	c9                   	leave  
  8034d6:	c3                   	ret    

008034d7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8034d7:	55                   	push   %ebp
  8034d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8034da:	6a 00                	push   $0x0
  8034dc:	6a 00                	push   $0x0
  8034de:	ff 75 10             	pushl  0x10(%ebp)
  8034e1:	ff 75 0c             	pushl  0xc(%ebp)
  8034e4:	ff 75 08             	pushl  0x8(%ebp)
  8034e7:	6a 12                	push   $0x12
  8034e9:	e8 e8 fa ff ff       	call   802fd6 <syscall>
  8034ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8034f1:	90                   	nop
}
  8034f2:	c9                   	leave  
  8034f3:	c3                   	ret    

008034f4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8034f4:	55                   	push   %ebp
  8034f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8034f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	6a 00                	push   $0x0
  8034ff:	6a 00                	push   $0x0
  803501:	6a 00                	push   $0x0
  803503:	52                   	push   %edx
  803504:	50                   	push   %eax
  803505:	6a 2a                	push   $0x2a
  803507:	e8 ca fa ff ff       	call   802fd6 <syscall>
  80350c:	83 c4 18             	add    $0x18,%esp
	return;
  80350f:	90                   	nop
}
  803510:	c9                   	leave  
  803511:	c3                   	ret    

00803512 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803512:	55                   	push   %ebp
  803513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803515:	6a 00                	push   $0x0
  803517:	6a 00                	push   $0x0
  803519:	6a 00                	push   $0x0
  80351b:	6a 00                	push   $0x0
  80351d:	6a 00                	push   $0x0
  80351f:	6a 2b                	push   $0x2b
  803521:	e8 b0 fa ff ff       	call   802fd6 <syscall>
  803526:	83 c4 18             	add    $0x18,%esp
}
  803529:	c9                   	leave  
  80352a:	c3                   	ret    

0080352b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80352b:	55                   	push   %ebp
  80352c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80352e:	6a 00                	push   $0x0
  803530:	6a 00                	push   $0x0
  803532:	6a 00                	push   $0x0
  803534:	ff 75 0c             	pushl  0xc(%ebp)
  803537:	ff 75 08             	pushl  0x8(%ebp)
  80353a:	6a 2d                	push   $0x2d
  80353c:	e8 95 fa ff ff       	call   802fd6 <syscall>
  803541:	83 c4 18             	add    $0x18,%esp
	return;
  803544:	90                   	nop
}
  803545:	c9                   	leave  
  803546:	c3                   	ret    

00803547 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803547:	55                   	push   %ebp
  803548:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80354a:	6a 00                	push   $0x0
  80354c:	6a 00                	push   $0x0
  80354e:	6a 00                	push   $0x0
  803550:	ff 75 0c             	pushl  0xc(%ebp)
  803553:	ff 75 08             	pushl  0x8(%ebp)
  803556:	6a 2c                	push   $0x2c
  803558:	e8 79 fa ff ff       	call   802fd6 <syscall>
  80355d:	83 c4 18             	add    $0x18,%esp
	return ;
  803560:	90                   	nop
}
  803561:	c9                   	leave  
  803562:	c3                   	ret    

00803563 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803563:	55                   	push   %ebp
  803564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803566:	8b 55 0c             	mov    0xc(%ebp),%edx
  803569:	8b 45 08             	mov    0x8(%ebp),%eax
  80356c:	6a 00                	push   $0x0
  80356e:	6a 00                	push   $0x0
  803570:	6a 00                	push   $0x0
  803572:	52                   	push   %edx
  803573:	50                   	push   %eax
  803574:	6a 2e                	push   $0x2e
  803576:	e8 5b fa ff ff       	call   802fd6 <syscall>
  80357b:	83 c4 18             	add    $0x18,%esp
}
  80357e:	90                   	nop
  80357f:	c9                   	leave  
  803580:	c3                   	ret    

00803581 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803581:	55                   	push   %ebp
  803582:	89 e5                	mov    %esp,%ebp
  803584:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803587:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  80358e:	72 09                	jb     803599 <to_page_va+0x18>
  803590:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803597:	72 14                	jb     8035ad <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803599:	83 ec 04             	sub    $0x4,%esp
  80359c:	68 b8 4b 80 00       	push   $0x804bb8
  8035a1:	6a 15                	push   $0x15
  8035a3:	68 e3 4b 80 00       	push   $0x804be3
  8035a8:	e8 10 d0 ff ff       	call   8005bd <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8035b5:	29 d0                	sub    %edx,%eax
  8035b7:	c1 f8 02             	sar    $0x2,%eax
  8035ba:	89 c2                	mov    %eax,%edx
  8035bc:	89 d0                	mov    %edx,%eax
  8035be:	c1 e0 02             	shl    $0x2,%eax
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	c1 e0 02             	shl    $0x2,%eax
  8035c6:	01 d0                	add    %edx,%eax
  8035c8:	c1 e0 02             	shl    $0x2,%eax
  8035cb:	01 d0                	add    %edx,%eax
  8035cd:	89 c1                	mov    %eax,%ecx
  8035cf:	c1 e1 08             	shl    $0x8,%ecx
  8035d2:	01 c8                	add    %ecx,%eax
  8035d4:	89 c1                	mov    %eax,%ecx
  8035d6:	c1 e1 10             	shl    $0x10,%ecx
  8035d9:	01 c8                	add    %ecx,%eax
  8035db:	01 c0                	add    %eax,%eax
  8035dd:	01 d0                	add    %edx,%eax
  8035df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	c1 e0 0c             	shl    $0xc,%eax
  8035e8:	89 c2                	mov    %eax,%edx
  8035ea:	a1 84 50 83 00       	mov    0x835084,%eax
  8035ef:	01 d0                	add    %edx,%eax
}
  8035f1:	c9                   	leave  
  8035f2:	c3                   	ret    

008035f3 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8035f3:	55                   	push   %ebp
  8035f4:	89 e5                	mov    %esp,%ebp
  8035f6:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8035f9:	a1 84 50 83 00       	mov    0x835084,%eax
  8035fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803601:	29 c2                	sub    %eax,%edx
  803603:	89 d0                	mov    %edx,%eax
  803605:	c1 e8 0c             	shr    $0xc,%eax
  803608:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80360b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360f:	78 09                	js     80361a <to_page_info+0x27>
  803611:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803618:	7e 14                	jle    80362e <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80361a:	83 ec 04             	sub    $0x4,%esp
  80361d:	68 fc 4b 80 00       	push   $0x804bfc
  803622:	6a 21                	push   $0x21
  803624:	68 e3 4b 80 00       	push   $0x804be3
  803629:	e8 8f cf ff ff       	call   8005bd <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80362e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803631:	89 d0                	mov    %edx,%eax
  803633:	01 c0                	add    %eax,%eax
  803635:	01 d0                	add    %edx,%eax
  803637:	c1 e0 02             	shl    $0x2,%eax
  80363a:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80363f:	c9                   	leave  
  803640:	c3                   	ret    

00803641 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803641:	55                   	push   %ebp
  803642:	89 e5                	mov    %esp,%ebp
  803644:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	05 00 00 00 02       	add    $0x2000000,%eax
  80364f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803652:	73 16                	jae    80366a <initialize_dynamic_allocator+0x29>
  803654:	68 20 4c 80 00       	push   $0x804c20
  803659:	68 46 4c 80 00       	push   $0x804c46
  80365e:	6a 2f                	push   $0x2f
  803660:	68 e3 4b 80 00       	push   $0x804be3
  803665:	e8 53 cf ff ff       	call   8005bd <_panic>
	dynAllocStart = daStart;
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803672:	8b 45 0c             	mov    0xc(%ebp),%eax
  803675:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80367a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803681:	eb 36                	jmp    8036b9 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	c1 e0 04             	shl    $0x4,%eax
  803689:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80368e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	c1 e0 04             	shl    $0x4,%eax
  80369a:	05 a4 50 83 00       	add    $0x8350a4,%eax
  80369f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a8:	c1 e0 04             	shl    $0x4,%eax
  8036ab:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8036b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036b6:	ff 45 f4             	incl   -0xc(%ebp)
  8036b9:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8036bd:	7e c4                	jle    803683 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8036bf:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8036c6:	00 00 00 
  8036c9:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8036d0:	00 00 00 
  8036d3:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8036da:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8036e4:	e9 1b 01 00 00       	jmp    803804 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8036e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ec:	89 d0                	mov    %edx,%eax
  8036ee:	01 c0                	add    %eax,%eax
  8036f0:	01 d0                	add    %edx,%eax
  8036f2:	c1 e0 02             	shl    $0x2,%eax
  8036f5:	05 88 d0 81 00       	add    $0x81d088,%eax
  8036fa:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8036ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803702:	89 d0                	mov    %edx,%eax
  803704:	01 c0                	add    %eax,%eax
  803706:	01 d0                	add    %edx,%eax
  803708:	c1 e0 02             	shl    $0x2,%eax
  80370b:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803710:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803715:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803718:	89 d0                	mov    %edx,%eax
  80371a:	01 c0                	add    %eax,%eax
  80371c:	01 d0                	add    %edx,%eax
  80371e:	c1 e0 02             	shl    $0x2,%eax
  803721:	05 80 d0 81 00       	add    $0x81d080,%eax
  803726:	8b 00                	mov    (%eax),%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	74 2b                	je     803757 <initialize_dynamic_allocator+0x116>
  80372c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80372f:	89 d0                	mov    %edx,%eax
  803731:	01 c0                	add    %eax,%eax
  803733:	01 d0                	add    %edx,%eax
  803735:	c1 e0 02             	shl    $0x2,%eax
  803738:	05 80 d0 81 00       	add    $0x81d080,%eax
  80373d:	8b 10                	mov    (%eax),%edx
  80373f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803742:	89 c8                	mov    %ecx,%eax
  803744:	01 c0                	add    %eax,%eax
  803746:	01 c8                	add    %ecx,%eax
  803748:	c1 e0 02             	shl    $0x2,%eax
  80374b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803750:	8b 00                	mov    (%eax),%eax
  803752:	89 42 04             	mov    %eax,0x4(%edx)
  803755:	eb 18                	jmp    80376f <initialize_dynamic_allocator+0x12e>
  803757:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80375a:	89 d0                	mov    %edx,%eax
  80375c:	01 c0                	add    %eax,%eax
  80375e:	01 d0                	add    %edx,%eax
  803760:	c1 e0 02             	shl    $0x2,%eax
  803763:	05 84 d0 81 00       	add    $0x81d084,%eax
  803768:	8b 00                	mov    (%eax),%eax
  80376a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80376f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803772:	89 d0                	mov    %edx,%eax
  803774:	01 c0                	add    %eax,%eax
  803776:	01 d0                	add    %edx,%eax
  803778:	c1 e0 02             	shl    $0x2,%eax
  80377b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	85 c0                	test   %eax,%eax
  803784:	74 2a                	je     8037b0 <initialize_dynamic_allocator+0x16f>
  803786:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803789:	89 d0                	mov    %edx,%eax
  80378b:	01 c0                	add    %eax,%eax
  80378d:	01 d0                	add    %edx,%eax
  80378f:	c1 e0 02             	shl    $0x2,%eax
  803792:	05 84 d0 81 00       	add    $0x81d084,%eax
  803797:	8b 10                	mov    (%eax),%edx
  803799:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80379c:	89 c8                	mov    %ecx,%eax
  80379e:	01 c0                	add    %eax,%eax
  8037a0:	01 c8                	add    %ecx,%eax
  8037a2:	c1 e0 02             	shl    $0x2,%eax
  8037a5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037aa:	8b 00                	mov    (%eax),%eax
  8037ac:	89 02                	mov    %eax,(%edx)
  8037ae:	eb 18                	jmp    8037c8 <initialize_dynamic_allocator+0x187>
  8037b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037b3:	89 d0                	mov    %edx,%eax
  8037b5:	01 c0                	add    %eax,%eax
  8037b7:	01 d0                	add    %edx,%eax
  8037b9:	c1 e0 02             	shl    $0x2,%eax
  8037bc:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8037c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037cb:	89 d0                	mov    %edx,%eax
  8037cd:	01 c0                	add    %eax,%eax
  8037cf:	01 d0                	add    %edx,%eax
  8037d1:	c1 e0 02             	shl    $0x2,%eax
  8037d4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037e2:	89 d0                	mov    %edx,%eax
  8037e4:	01 c0                	add    %eax,%eax
  8037e6:	01 d0                	add    %edx,%eax
  8037e8:	c1 e0 02             	shl    $0x2,%eax
  8037eb:	05 84 d0 81 00       	add    $0x81d084,%eax
  8037f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f6:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8037fb:	48                   	dec    %eax
  8037fc:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803801:	ff 45 f0             	incl   -0x10(%ebp)
  803804:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  80380b:	0f 8e d8 fe ff ff    	jle    8036e9 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803811:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803818:	e9 9d 00 00 00       	jmp    8038ba <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  80381d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803823:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803826:	89 c8                	mov    %ecx,%eax
  803828:	01 c0                	add    %eax,%eax
  80382a:	01 c8                	add    %ecx,%eax
  80382c:	c1 e0 02             	shl    $0x2,%eax
  80382f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803834:	89 10                	mov    %edx,(%eax)
  803836:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803839:	89 d0                	mov    %edx,%eax
  80383b:	01 c0                	add    %eax,%eax
  80383d:	01 d0                	add    %edx,%eax
  80383f:	c1 e0 02             	shl    $0x2,%eax
  803842:	05 80 d0 81 00       	add    $0x81d080,%eax
  803847:	8b 00                	mov    (%eax),%eax
  803849:	85 c0                	test   %eax,%eax
  80384b:	74 1c                	je     803869 <initialize_dynamic_allocator+0x228>
  80384d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803853:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803856:	89 c8                	mov    %ecx,%eax
  803858:	01 c0                	add    %eax,%eax
  80385a:	01 c8                	add    %ecx,%eax
  80385c:	c1 e0 02             	shl    $0x2,%eax
  80385f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803864:	89 42 04             	mov    %eax,0x4(%edx)
  803867:	eb 16                	jmp    80387f <initialize_dynamic_allocator+0x23e>
  803869:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80386c:	89 d0                	mov    %edx,%eax
  80386e:	01 c0                	add    %eax,%eax
  803870:	01 d0                	add    %edx,%eax
  803872:	c1 e0 02             	shl    $0x2,%eax
  803875:	05 80 d0 81 00       	add    $0x81d080,%eax
  80387a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80387f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803882:	89 d0                	mov    %edx,%eax
  803884:	01 c0                	add    %eax,%eax
  803886:	01 d0                	add    %edx,%eax
  803888:	c1 e0 02             	shl    $0x2,%eax
  80388b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803890:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803895:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803898:	89 d0                	mov    %edx,%eax
  80389a:	01 c0                	add    %eax,%eax
  80389c:	01 d0                	add    %edx,%eax
  80389e:	c1 e0 02             	shl    $0x2,%eax
  8038a1:	05 84 d0 81 00       	add    $0x81d084,%eax
  8038a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ac:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8038b1:	40                   	inc    %eax
  8038b2:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8038b7:	ff 4d ec             	decl   -0x14(%ebp)
  8038ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038be:	0f 89 59 ff ff ff    	jns    80381d <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8038c4:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8038cb:	00 00 00 
}
  8038ce:	90                   	nop
  8038cf:	c9                   	leave  
  8038d0:	c3                   	ret    

008038d1 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8038d1:	55                   	push   %ebp
  8038d2:	89 e5                	mov    %esp,%ebp
  8038d4:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	83 ec 0c             	sub    $0xc,%esp
  8038dd:	50                   	push   %eax
  8038de:	e8 10 fd ff ff       	call   8035f3 <to_page_info>
  8038e3:	83 c4 10             	add    $0x10,%esp
  8038e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8038e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ec:	8b 40 08             	mov    0x8(%eax),%eax
  8038ef:	0f b7 c0             	movzwl %ax,%eax
}
  8038f2:	c9                   	leave  
  8038f3:	c3                   	ret    

008038f4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8038f4:	55                   	push   %ebp
  8038f5:	89 e5                	mov    %esp,%ebp
  8038f7:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8038fa:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803901:	76 16                	jbe    803919 <alloc_block+0x25>
  803903:	68 5c 4c 80 00       	push   $0x804c5c
  803908:	68 46 4c 80 00       	push   $0x804c46
  80390d:	6a 59                	push   $0x59
  80390f:	68 e3 4b 80 00       	push   $0x804be3
  803914:	e8 a4 cc ff ff       	call   8005bd <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803919:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803920:	eb 08                	jmp    80392a <alloc_block+0x36>
		allocSize <<= 1;
  803922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803925:	01 c0                	add    %eax,%eax
  803927:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80392a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803930:	73 09                	jae    80393b <alloc_block+0x47>
  803932:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803939:	76 e7                	jbe    803922 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  80393b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803942:	eb 03                	jmp    803947 <alloc_block+0x53>
		listIndex++;
  803944:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394a:	ba 08 00 00 00       	mov    $0x8,%edx
  80394f:	88 c1                	mov    %al,%cl
  803951:	d3 e2                	shl    %cl,%edx
  803953:	89 d0                	mov    %edx,%eax
  803955:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803958:	72 ea                	jb     803944 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80395a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803960:	e9 f4 00 00 00       	jmp    803a59 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803968:	c1 e0 04             	shl    $0x4,%eax
  80396b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	85 c0                	test   %eax,%eax
  803974:	0f 84 dc 00 00 00    	je     803a56 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80397a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80397d:	c1 e0 04             	shl    $0x4,%eax
  803980:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803985:	8b 00                	mov    (%eax),%eax
  803987:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80398a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80398e:	75 14                	jne    8039a4 <alloc_block+0xb0>
  803990:	83 ec 04             	sub    $0x4,%esp
  803993:	68 7d 4c 80 00       	push   $0x804c7d
  803998:	6a 6b                	push   $0x6b
  80399a:	68 e3 4b 80 00       	push   $0x804be3
  80399f:	e8 19 cc ff ff       	call   8005bd <_panic>
  8039a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	85 c0                	test   %eax,%eax
  8039ab:	74 10                	je     8039bd <alloc_block+0xc9>
  8039ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b0:	8b 00                	mov    (%eax),%eax
  8039b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b5:	8b 52 04             	mov    0x4(%edx),%edx
  8039b8:	89 50 04             	mov    %edx,0x4(%eax)
  8039bb:	eb 14                	jmp    8039d1 <alloc_block+0xdd>
  8039bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c0:	8b 40 04             	mov    0x4(%eax),%eax
  8039c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039c6:	c1 e2 04             	shl    $0x4,%edx
  8039c9:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8039cf:	89 02                	mov    %eax,(%edx)
  8039d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d4:	8b 40 04             	mov    0x4(%eax),%eax
  8039d7:	85 c0                	test   %eax,%eax
  8039d9:	74 0f                	je     8039ea <alloc_block+0xf6>
  8039db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039de:	8b 40 04             	mov    0x4(%eax),%eax
  8039e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e4:	8b 12                	mov    (%edx),%edx
  8039e6:	89 10                	mov    %edx,(%eax)
  8039e8:	eb 13                	jmp    8039fd <alloc_block+0x109>
  8039ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ed:	8b 00                	mov    (%eax),%eax
  8039ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039f2:	c1 e2 04             	shl    $0x4,%edx
  8039f5:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8039fb:	89 02                	mov    %eax,(%edx)
  8039fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a13:	c1 e0 04             	shl    $0x4,%eax
  803a16:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a1b:	8b 00                	mov    (%eax),%eax
  803a1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a23:	c1 e0 04             	shl    $0x4,%eax
  803a26:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a2b:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a30:	83 ec 0c             	sub    $0xc,%esp
  803a33:	50                   	push   %eax
  803a34:	e8 ba fb ff ff       	call   8035f3 <to_page_info>
  803a39:	83 c4 10             	add    $0x10,%esp
  803a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a42:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a46:	48                   	dec    %eax
  803a47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a4a:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a51:	e9 8f 02 00 00       	jmp    803ce5 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a56:	ff 45 ec             	incl   -0x14(%ebp)
  803a59:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803a5d:	0f 8e 02 ff ff ff    	jle    803965 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803a63:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803a68:	85 c0                	test   %eax,%eax
  803a6a:	75 14                	jne    803a80 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803a6c:	83 ec 04             	sub    $0x4,%esp
  803a6f:	68 9c 4c 80 00       	push   $0x804c9c
  803a74:	6a 77                	push   $0x77
  803a76:	68 e3 4b 80 00       	push   $0x804be3
  803a7b:	e8 3d cb ff ff       	call   8005bd <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803a80:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803a85:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803a88:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a8c:	75 14                	jne    803aa2 <alloc_block+0x1ae>
  803a8e:	83 ec 04             	sub    $0x4,%esp
  803a91:	68 7d 4c 80 00       	push   $0x804c7d
  803a96:	6a 7a                	push   $0x7a
  803a98:	68 e3 4b 80 00       	push   $0x804be3
  803a9d:	e8 1b cb ff ff       	call   8005bd <_panic>
  803aa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	85 c0                	test   %eax,%eax
  803aa9:	74 10                	je     803abb <alloc_block+0x1c7>
  803aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aae:	8b 00                	mov    (%eax),%eax
  803ab0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ab3:	8b 52 04             	mov    0x4(%edx),%edx
  803ab6:	89 50 04             	mov    %edx,0x4(%eax)
  803ab9:	eb 0b                	jmp    803ac6 <alloc_block+0x1d2>
  803abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803abe:	8b 40 04             	mov    0x4(%eax),%eax
  803ac1:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803ac6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ac9:	8b 40 04             	mov    0x4(%eax),%eax
  803acc:	85 c0                	test   %eax,%eax
  803ace:	74 0f                	je     803adf <alloc_block+0x1eb>
  803ad0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad3:	8b 40 04             	mov    0x4(%eax),%eax
  803ad6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ad9:	8b 12                	mov    (%edx),%edx
  803adb:	89 10                	mov    %edx,(%eax)
  803add:	eb 0a                	jmp    803ae9 <alloc_block+0x1f5>
  803adf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ae2:	8b 00                	mov    (%eax),%eax
  803ae4:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803ae9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803af5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803afc:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803b01:	48                   	dec    %eax
  803b02:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803b07:	83 ec 0c             	sub    $0xc,%esp
  803b0a:	ff 75 dc             	pushl  -0x24(%ebp)
  803b0d:	e8 6f fa ff ff       	call   803581 <to_page_va>
  803b12:	83 c4 10             	add    $0x10,%esp
  803b15:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803b18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b1b:	83 ec 0c             	sub    $0xc,%esp
  803b1e:	50                   	push   %eax
  803b1f:	e8 a0 dc ff ff       	call   8017c4 <get_page>
  803b24:	83 c4 10             	add    $0x10,%esp
  803b27:	85 c0                	test   %eax,%eax
  803b29:	74 14                	je     803b3f <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803b2b:	83 ec 04             	sub    $0x4,%esp
  803b2e:	68 c4 4c 80 00       	push   $0x804cc4
  803b33:	6a 7f                	push   $0x7f
  803b35:	68 e3 4b 80 00       	push   $0x804be3
  803b3a:	e8 7e ca ff ff       	call   8005bd <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b42:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b45:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803b49:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  803b53:	f7 75 f4             	divl   -0xc(%ebp)
  803b56:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b59:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803b5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b64:	e9 a7 00 00 00       	jmp    803c10 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803b69:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6f:	01 d0                	add    %edx,%eax
  803b71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803b74:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b78:	75 17                	jne    803b91 <alloc_block+0x29d>
  803b7a:	83 ec 04             	sub    $0x4,%esp
  803b7d:	68 ec 4c 80 00       	push   $0x804cec
  803b82:	68 88 00 00 00       	push   $0x88
  803b87:	68 e3 4b 80 00       	push   $0x804be3
  803b8c:	e8 2c ca ff ff       	call   8005bd <_panic>
  803b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b94:	c1 e0 04             	shl    $0x4,%eax
  803b97:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b9c:	8b 10                	mov    (%eax),%edx
  803b9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba1:	89 10                	mov    %edx,(%eax)
  803ba3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba6:	8b 00                	mov    (%eax),%eax
  803ba8:	85 c0                	test   %eax,%eax
  803baa:	74 15                	je     803bc1 <alloc_block+0x2cd>
  803bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803baf:	c1 e0 04             	shl    $0x4,%eax
  803bb2:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bb7:	8b 00                	mov    (%eax),%eax
  803bb9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bbc:	89 50 04             	mov    %edx,0x4(%eax)
  803bbf:	eb 11                	jmp    803bd2 <alloc_block+0x2de>
  803bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc4:	c1 e0 04             	shl    $0x4,%eax
  803bc7:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803bcd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd0:	89 02                	mov    %eax,(%edx)
  803bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bd5:	c1 e0 04             	shl    $0x4,%eax
  803bd8:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803bde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be1:	89 02                	mov    %eax,(%edx)
  803be3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf0:	c1 e0 04             	shl    $0x4,%eax
  803bf3:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bf8:	8b 00                	mov    (%eax),%eax
  803bfa:	8d 50 01             	lea    0x1(%eax),%edx
  803bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c00:	c1 e0 04             	shl    $0x4,%eax
  803c03:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c08:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0d:	01 45 e8             	add    %eax,-0x18(%ebp)
  803c10:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803c17:	0f 86 4c ff ff ff    	jbe    803b69 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c20:	c1 e0 04             	shl    $0x4,%eax
  803c23:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c28:	8b 00                	mov    (%eax),%eax
  803c2a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803c2d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c31:	75 17                	jne    803c4a <alloc_block+0x356>
  803c33:	83 ec 04             	sub    $0x4,%esp
  803c36:	68 7d 4c 80 00       	push   $0x804c7d
  803c3b:	68 8d 00 00 00       	push   $0x8d
  803c40:	68 e3 4b 80 00       	push   $0x804be3
  803c45:	e8 73 c9 ff ff       	call   8005bd <_panic>
  803c4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c4d:	8b 00                	mov    (%eax),%eax
  803c4f:	85 c0                	test   %eax,%eax
  803c51:	74 10                	je     803c63 <alloc_block+0x36f>
  803c53:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c56:	8b 00                	mov    (%eax),%eax
  803c58:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803c5b:	8b 52 04             	mov    0x4(%edx),%edx
  803c5e:	89 50 04             	mov    %edx,0x4(%eax)
  803c61:	eb 14                	jmp    803c77 <alloc_block+0x383>
  803c63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c66:	8b 40 04             	mov    0x4(%eax),%eax
  803c69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c6c:	c1 e2 04             	shl    $0x4,%edx
  803c6f:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c75:	89 02                	mov    %eax,(%edx)
  803c77:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c7a:	8b 40 04             	mov    0x4(%eax),%eax
  803c7d:	85 c0                	test   %eax,%eax
  803c7f:	74 0f                	je     803c90 <alloc_block+0x39c>
  803c81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c84:	8b 40 04             	mov    0x4(%eax),%eax
  803c87:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803c8a:	8b 12                	mov    (%edx),%edx
  803c8c:	89 10                	mov    %edx,(%eax)
  803c8e:	eb 13                	jmp    803ca3 <alloc_block+0x3af>
  803c90:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c93:	8b 00                	mov    (%eax),%eax
  803c95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c98:	c1 e2 04             	shl    $0x4,%edx
  803c9b:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803ca1:	89 02                	mov    %eax,(%edx)
  803ca3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803caf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb9:	c1 e0 04             	shl    $0x4,%eax
  803cbc:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cc1:	8b 00                	mov    (%eax),%eax
  803cc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  803cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc9:	c1 e0 04             	shl    $0x4,%eax
  803ccc:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cd1:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803cd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cd6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cda:	48                   	dec    %eax
  803cdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803cde:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803ce2:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803ce5:	c9                   	leave  
  803ce6:	c3                   	ret    

00803ce7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803ce7:	55                   	push   %ebp
  803ce8:	89 e5                	mov    %esp,%ebp
  803cea:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803ced:	8b 55 08             	mov    0x8(%ebp),%edx
  803cf0:	a1 84 50 83 00       	mov    0x835084,%eax
  803cf5:	39 c2                	cmp    %eax,%edx
  803cf7:	72 0c                	jb     803d05 <free_block+0x1e>
  803cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  803cfc:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803d01:	39 c2                	cmp    %eax,%edx
  803d03:	72 19                	jb     803d1e <free_block+0x37>
  803d05:	68 10 4d 80 00       	push   $0x804d10
  803d0a:	68 46 4c 80 00       	push   $0x804c46
  803d0f:	68 98 00 00 00       	push   $0x98
  803d14:	68 e3 4b 80 00       	push   $0x804be3
  803d19:	e8 9f c8 ff ff       	call   8005bd <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d21:	83 ec 0c             	sub    $0xc,%esp
  803d24:	50                   	push   %eax
  803d25:	e8 c9 f8 ff ff       	call   8035f3 <to_page_info>
  803d2a:	83 c4 10             	add    $0x10,%esp
  803d2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d33:	8b 40 08             	mov    0x8(%eax),%eax
  803d36:	0f b7 c0             	movzwl %ax,%eax
  803d39:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803d3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803d43:	eb 03                	jmp    803d48 <free_block+0x61>
		listIndex++;
  803d45:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4b:	ba 08 00 00 00       	mov    $0x8,%edx
  803d50:	88 c1                	mov    %al,%cl
  803d52:	d3 e2                	shl    %cl,%edx
  803d54:	89 d0                	mov    %edx,%eax
  803d56:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d59:	72 ea                	jb     803d45 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803d61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d65:	75 17                	jne    803d7e <free_block+0x97>
  803d67:	83 ec 04             	sub    $0x4,%esp
  803d6a:	68 ec 4c 80 00       	push   $0x804cec
  803d6f:	68 a2 00 00 00       	push   $0xa2
  803d74:	68 e3 4b 80 00       	push   $0x804be3
  803d79:	e8 3f c8 ff ff       	call   8005bd <_panic>
  803d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d81:	c1 e0 04             	shl    $0x4,%eax
  803d84:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d89:	8b 10                	mov    (%eax),%edx
  803d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8e:	89 10                	mov    %edx,(%eax)
  803d90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d93:	8b 00                	mov    (%eax),%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	74 15                	je     803dae <free_block+0xc7>
  803d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9c:	c1 e0 04             	shl    $0x4,%eax
  803d9f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803da4:	8b 00                	mov    (%eax),%eax
  803da6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da9:	89 50 04             	mov    %edx,0x4(%eax)
  803dac:	eb 11                	jmp    803dbf <free_block+0xd8>
  803dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db1:	c1 e0 04             	shl    $0x4,%eax
  803db4:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbd:	89 02                	mov    %eax,(%edx)
  803dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc2:	c1 e0 04             	shl    $0x4,%eax
  803dc5:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dce:	89 02                	mov    %eax,(%edx)
  803dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddd:	c1 e0 04             	shl    $0x4,%eax
  803de0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803de5:	8b 00                	mov    (%eax),%eax
  803de7:	8d 50 01             	lea    0x1(%eax),%edx
  803dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ded:	c1 e0 04             	shl    $0x4,%eax
  803df0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803df5:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dfa:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803dfe:	40                   	inc    %eax
  803dff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e02:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e09:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e0d:	0f b7 c8             	movzwl %ax,%ecx
  803e10:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e15:	ba 00 00 00 00       	mov    $0x0,%edx
  803e1a:	f7 75 e8             	divl   -0x18(%ebp)
  803e1d:	39 c1                	cmp    %eax,%ecx
  803e1f:	0f 85 ed 01 00 00    	jne    804012 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e28:	c1 e0 04             	shl    $0x4,%eax
  803e2b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803e30:	8b 00                	mov    (%eax),%eax
  803e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803e35:	eb 2a                	jmp    803e61 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e3a:	83 ec 0c             	sub    $0xc,%esp
  803e3d:	50                   	push   %eax
  803e3e:	e8 b0 f7 ff ff       	call   8035f3 <to_page_info>
  803e43:	83 c4 10             	add    $0x10,%esp
  803e46:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803e49:	75 06                	jne    803e51 <free_block+0x16a>
				tmp = b;
  803e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e54:	c1 e0 04             	shl    $0x4,%eax
  803e57:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803e5c:	8b 00                	mov    (%eax),%eax
  803e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803e61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e65:	74 07                	je     803e6e <free_block+0x187>
  803e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6a:	8b 00                	mov    (%eax),%eax
  803e6c:	eb 05                	jmp    803e73 <free_block+0x18c>
  803e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e76:	c1 e2 04             	shl    $0x4,%edx
  803e79:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803e7f:	89 02                	mov    %eax,(%edx)
  803e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e84:	c1 e0 04             	shl    $0x4,%eax
  803e87:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803e8c:	8b 00                	mov    (%eax),%eax
  803e8e:	85 c0                	test   %eax,%eax
  803e90:	75 a5                	jne    803e37 <free_block+0x150>
  803e92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e96:	75 9f                	jne    803e37 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9b:	c1 e0 04             	shl    $0x4,%eax
  803e9e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ea3:	8b 00                	mov    (%eax),%eax
  803ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803ea8:	e9 cc 00 00 00       	jmp    803f79 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb0:	8b 00                	mov    (%eax),%eax
  803eb2:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb8:	83 ec 0c             	sub    $0xc,%esp
  803ebb:	50                   	push   %eax
  803ebc:	e8 32 f7 ff ff       	call   8035f3 <to_page_info>
  803ec1:	83 c4 10             	add    $0x10,%esp
  803ec4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803ec7:	0f 85 a6 00 00 00    	jne    803f73 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803ecd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ed1:	75 17                	jne    803eea <free_block+0x203>
  803ed3:	83 ec 04             	sub    $0x4,%esp
  803ed6:	68 7d 4c 80 00       	push   $0x804c7d
  803edb:	68 b5 00 00 00       	push   $0xb5
  803ee0:	68 e3 4b 80 00       	push   $0x804be3
  803ee5:	e8 d3 c6 ff ff       	call   8005bd <_panic>
  803eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eed:	8b 00                	mov    (%eax),%eax
  803eef:	85 c0                	test   %eax,%eax
  803ef1:	74 10                	je     803f03 <free_block+0x21c>
  803ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef6:	8b 00                	mov    (%eax),%eax
  803ef8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803efb:	8b 52 04             	mov    0x4(%edx),%edx
  803efe:	89 50 04             	mov    %edx,0x4(%eax)
  803f01:	eb 14                	jmp    803f17 <free_block+0x230>
  803f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f06:	8b 40 04             	mov    0x4(%eax),%eax
  803f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f0c:	c1 e2 04             	shl    $0x4,%edx
  803f0f:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803f15:	89 02                	mov    %eax,(%edx)
  803f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f1a:	8b 40 04             	mov    0x4(%eax),%eax
  803f1d:	85 c0                	test   %eax,%eax
  803f1f:	74 0f                	je     803f30 <free_block+0x249>
  803f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f24:	8b 40 04             	mov    0x4(%eax),%eax
  803f27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f2a:	8b 12                	mov    (%edx),%edx
  803f2c:	89 10                	mov    %edx,(%eax)
  803f2e:	eb 13                	jmp    803f43 <free_block+0x25c>
  803f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f33:	8b 00                	mov    (%eax),%eax
  803f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f38:	c1 e2 04             	shl    $0x4,%edx
  803f3b:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803f41:	89 02                	mov    %eax,(%edx)
  803f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f59:	c1 e0 04             	shl    $0x4,%eax
  803f5c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803f61:	8b 00                	mov    (%eax),%eax
  803f63:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f69:	c1 e0 04             	shl    $0x4,%eax
  803f6c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803f71:	89 10                	mov    %edx,(%eax)
			b = next;
  803f73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803f79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f7d:	0f 85 2a ff ff ff    	jne    803ead <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f86:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f8f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803f95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803f99:	75 17                	jne    803fb2 <free_block+0x2cb>
  803f9b:	83 ec 04             	sub    $0x4,%esp
  803f9e:	68 ec 4c 80 00       	push   $0x804cec
  803fa3:	68 bc 00 00 00       	push   $0xbc
  803fa8:	68 e3 4b 80 00       	push   $0x804be3
  803fad:	e8 0b c6 ff ff       	call   8005bd <_panic>
  803fb2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fbb:	89 10                	mov    %edx,(%eax)
  803fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fc0:	8b 00                	mov    (%eax),%eax
  803fc2:	85 c0                	test   %eax,%eax
  803fc4:	74 0d                	je     803fd3 <free_block+0x2ec>
  803fc6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803fcb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fce:	89 50 04             	mov    %edx,0x4(%eax)
  803fd1:	eb 08                	jmp    803fdb <free_block+0x2f4>
  803fd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fd6:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fde:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fe6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fed:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803ff2:	40                   	inc    %eax
  803ff3:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803ff8:	83 ec 0c             	sub    $0xc,%esp
  803ffb:	ff 75 ec             	pushl  -0x14(%ebp)
  803ffe:	e8 7e f5 ff ff       	call   803581 <to_page_va>
  804003:	83 c4 10             	add    $0x10,%esp
  804006:	83 ec 0c             	sub    $0xc,%esp
  804009:	50                   	push   %eax
  80400a:	e8 fe d7 ff ff       	call   80180d <return_page>
  80400f:	83 c4 10             	add    $0x10,%esp
	}
}
  804012:	90                   	nop
  804013:	c9                   	leave  
  804014:	c3                   	ret    
  804015:	66 90                	xchg   %ax,%ax
  804017:	90                   	nop

00804018 <__udivdi3>:
  804018:	55                   	push   %ebp
  804019:	57                   	push   %edi
  80401a:	56                   	push   %esi
  80401b:	53                   	push   %ebx
  80401c:	83 ec 1c             	sub    $0x1c,%esp
  80401f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804023:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804027:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80402b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80402f:	89 ca                	mov    %ecx,%edx
  804031:	89 f8                	mov    %edi,%eax
  804033:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804037:	85 f6                	test   %esi,%esi
  804039:	75 2d                	jne    804068 <__udivdi3+0x50>
  80403b:	39 cf                	cmp    %ecx,%edi
  80403d:	77 65                	ja     8040a4 <__udivdi3+0x8c>
  80403f:	89 fd                	mov    %edi,%ebp
  804041:	85 ff                	test   %edi,%edi
  804043:	75 0b                	jne    804050 <__udivdi3+0x38>
  804045:	b8 01 00 00 00       	mov    $0x1,%eax
  80404a:	31 d2                	xor    %edx,%edx
  80404c:	f7 f7                	div    %edi
  80404e:	89 c5                	mov    %eax,%ebp
  804050:	31 d2                	xor    %edx,%edx
  804052:	89 c8                	mov    %ecx,%eax
  804054:	f7 f5                	div    %ebp
  804056:	89 c1                	mov    %eax,%ecx
  804058:	89 d8                	mov    %ebx,%eax
  80405a:	f7 f5                	div    %ebp
  80405c:	89 cf                	mov    %ecx,%edi
  80405e:	89 fa                	mov    %edi,%edx
  804060:	83 c4 1c             	add    $0x1c,%esp
  804063:	5b                   	pop    %ebx
  804064:	5e                   	pop    %esi
  804065:	5f                   	pop    %edi
  804066:	5d                   	pop    %ebp
  804067:	c3                   	ret    
  804068:	39 ce                	cmp    %ecx,%esi
  80406a:	77 28                	ja     804094 <__udivdi3+0x7c>
  80406c:	0f bd fe             	bsr    %esi,%edi
  80406f:	83 f7 1f             	xor    $0x1f,%edi
  804072:	75 40                	jne    8040b4 <__udivdi3+0x9c>
  804074:	39 ce                	cmp    %ecx,%esi
  804076:	72 0a                	jb     804082 <__udivdi3+0x6a>
  804078:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80407c:	0f 87 9e 00 00 00    	ja     804120 <__udivdi3+0x108>
  804082:	b8 01 00 00 00       	mov    $0x1,%eax
  804087:	89 fa                	mov    %edi,%edx
  804089:	83 c4 1c             	add    $0x1c,%esp
  80408c:	5b                   	pop    %ebx
  80408d:	5e                   	pop    %esi
  80408e:	5f                   	pop    %edi
  80408f:	5d                   	pop    %ebp
  804090:	c3                   	ret    
  804091:	8d 76 00             	lea    0x0(%esi),%esi
  804094:	31 ff                	xor    %edi,%edi
  804096:	31 c0                	xor    %eax,%eax
  804098:	89 fa                	mov    %edi,%edx
  80409a:	83 c4 1c             	add    $0x1c,%esp
  80409d:	5b                   	pop    %ebx
  80409e:	5e                   	pop    %esi
  80409f:	5f                   	pop    %edi
  8040a0:	5d                   	pop    %ebp
  8040a1:	c3                   	ret    
  8040a2:	66 90                	xchg   %ax,%ax
  8040a4:	89 d8                	mov    %ebx,%eax
  8040a6:	f7 f7                	div    %edi
  8040a8:	31 ff                	xor    %edi,%edi
  8040aa:	89 fa                	mov    %edi,%edx
  8040ac:	83 c4 1c             	add    $0x1c,%esp
  8040af:	5b                   	pop    %ebx
  8040b0:	5e                   	pop    %esi
  8040b1:	5f                   	pop    %edi
  8040b2:	5d                   	pop    %ebp
  8040b3:	c3                   	ret    
  8040b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040b9:	89 eb                	mov    %ebp,%ebx
  8040bb:	29 fb                	sub    %edi,%ebx
  8040bd:	89 f9                	mov    %edi,%ecx
  8040bf:	d3 e6                	shl    %cl,%esi
  8040c1:	89 c5                	mov    %eax,%ebp
  8040c3:	88 d9                	mov    %bl,%cl
  8040c5:	d3 ed                	shr    %cl,%ebp
  8040c7:	89 e9                	mov    %ebp,%ecx
  8040c9:	09 f1                	or     %esi,%ecx
  8040cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040cf:	89 f9                	mov    %edi,%ecx
  8040d1:	d3 e0                	shl    %cl,%eax
  8040d3:	89 c5                	mov    %eax,%ebp
  8040d5:	89 d6                	mov    %edx,%esi
  8040d7:	88 d9                	mov    %bl,%cl
  8040d9:	d3 ee                	shr    %cl,%esi
  8040db:	89 f9                	mov    %edi,%ecx
  8040dd:	d3 e2                	shl    %cl,%edx
  8040df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040e3:	88 d9                	mov    %bl,%cl
  8040e5:	d3 e8                	shr    %cl,%eax
  8040e7:	09 c2                	or     %eax,%edx
  8040e9:	89 d0                	mov    %edx,%eax
  8040eb:	89 f2                	mov    %esi,%edx
  8040ed:	f7 74 24 0c          	divl   0xc(%esp)
  8040f1:	89 d6                	mov    %edx,%esi
  8040f3:	89 c3                	mov    %eax,%ebx
  8040f5:	f7 e5                	mul    %ebp
  8040f7:	39 d6                	cmp    %edx,%esi
  8040f9:	72 19                	jb     804114 <__udivdi3+0xfc>
  8040fb:	74 0b                	je     804108 <__udivdi3+0xf0>
  8040fd:	89 d8                	mov    %ebx,%eax
  8040ff:	31 ff                	xor    %edi,%edi
  804101:	e9 58 ff ff ff       	jmp    80405e <__udivdi3+0x46>
  804106:	66 90                	xchg   %ax,%ax
  804108:	8b 54 24 08          	mov    0x8(%esp),%edx
  80410c:	89 f9                	mov    %edi,%ecx
  80410e:	d3 e2                	shl    %cl,%edx
  804110:	39 c2                	cmp    %eax,%edx
  804112:	73 e9                	jae    8040fd <__udivdi3+0xe5>
  804114:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804117:	31 ff                	xor    %edi,%edi
  804119:	e9 40 ff ff ff       	jmp    80405e <__udivdi3+0x46>
  80411e:	66 90                	xchg   %ax,%ax
  804120:	31 c0                	xor    %eax,%eax
  804122:	e9 37 ff ff ff       	jmp    80405e <__udivdi3+0x46>
  804127:	90                   	nop

00804128 <__umoddi3>:
  804128:	55                   	push   %ebp
  804129:	57                   	push   %edi
  80412a:	56                   	push   %esi
  80412b:	53                   	push   %ebx
  80412c:	83 ec 1c             	sub    $0x1c,%esp
  80412f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804133:	8b 74 24 34          	mov    0x34(%esp),%esi
  804137:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80413b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80413f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804143:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804147:	89 f3                	mov    %esi,%ebx
  804149:	89 fa                	mov    %edi,%edx
  80414b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80414f:	89 34 24             	mov    %esi,(%esp)
  804152:	85 c0                	test   %eax,%eax
  804154:	75 1a                	jne    804170 <__umoddi3+0x48>
  804156:	39 f7                	cmp    %esi,%edi
  804158:	0f 86 a2 00 00 00    	jbe    804200 <__umoddi3+0xd8>
  80415e:	89 c8                	mov    %ecx,%eax
  804160:	89 f2                	mov    %esi,%edx
  804162:	f7 f7                	div    %edi
  804164:	89 d0                	mov    %edx,%eax
  804166:	31 d2                	xor    %edx,%edx
  804168:	83 c4 1c             	add    $0x1c,%esp
  80416b:	5b                   	pop    %ebx
  80416c:	5e                   	pop    %esi
  80416d:	5f                   	pop    %edi
  80416e:	5d                   	pop    %ebp
  80416f:	c3                   	ret    
  804170:	39 f0                	cmp    %esi,%eax
  804172:	0f 87 ac 00 00 00    	ja     804224 <__umoddi3+0xfc>
  804178:	0f bd e8             	bsr    %eax,%ebp
  80417b:	83 f5 1f             	xor    $0x1f,%ebp
  80417e:	0f 84 ac 00 00 00    	je     804230 <__umoddi3+0x108>
  804184:	bf 20 00 00 00       	mov    $0x20,%edi
  804189:	29 ef                	sub    %ebp,%edi
  80418b:	89 fe                	mov    %edi,%esi
  80418d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804191:	89 e9                	mov    %ebp,%ecx
  804193:	d3 e0                	shl    %cl,%eax
  804195:	89 d7                	mov    %edx,%edi
  804197:	89 f1                	mov    %esi,%ecx
  804199:	d3 ef                	shr    %cl,%edi
  80419b:	09 c7                	or     %eax,%edi
  80419d:	89 e9                	mov    %ebp,%ecx
  80419f:	d3 e2                	shl    %cl,%edx
  8041a1:	89 14 24             	mov    %edx,(%esp)
  8041a4:	89 d8                	mov    %ebx,%eax
  8041a6:	d3 e0                	shl    %cl,%eax
  8041a8:	89 c2                	mov    %eax,%edx
  8041aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041ae:	d3 e0                	shl    %cl,%eax
  8041b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041b8:	89 f1                	mov    %esi,%ecx
  8041ba:	d3 e8                	shr    %cl,%eax
  8041bc:	09 d0                	or     %edx,%eax
  8041be:	d3 eb                	shr    %cl,%ebx
  8041c0:	89 da                	mov    %ebx,%edx
  8041c2:	f7 f7                	div    %edi
  8041c4:	89 d3                	mov    %edx,%ebx
  8041c6:	f7 24 24             	mull   (%esp)
  8041c9:	89 c6                	mov    %eax,%esi
  8041cb:	89 d1                	mov    %edx,%ecx
  8041cd:	39 d3                	cmp    %edx,%ebx
  8041cf:	0f 82 87 00 00 00    	jb     80425c <__umoddi3+0x134>
  8041d5:	0f 84 91 00 00 00    	je     80426c <__umoddi3+0x144>
  8041db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041df:	29 f2                	sub    %esi,%edx
  8041e1:	19 cb                	sbb    %ecx,%ebx
  8041e3:	89 d8                	mov    %ebx,%eax
  8041e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041e9:	d3 e0                	shl    %cl,%eax
  8041eb:	89 e9                	mov    %ebp,%ecx
  8041ed:	d3 ea                	shr    %cl,%edx
  8041ef:	09 d0                	or     %edx,%eax
  8041f1:	89 e9                	mov    %ebp,%ecx
  8041f3:	d3 eb                	shr    %cl,%ebx
  8041f5:	89 da                	mov    %ebx,%edx
  8041f7:	83 c4 1c             	add    $0x1c,%esp
  8041fa:	5b                   	pop    %ebx
  8041fb:	5e                   	pop    %esi
  8041fc:	5f                   	pop    %edi
  8041fd:	5d                   	pop    %ebp
  8041fe:	c3                   	ret    
  8041ff:	90                   	nop
  804200:	89 fd                	mov    %edi,%ebp
  804202:	85 ff                	test   %edi,%edi
  804204:	75 0b                	jne    804211 <__umoddi3+0xe9>
  804206:	b8 01 00 00 00       	mov    $0x1,%eax
  80420b:	31 d2                	xor    %edx,%edx
  80420d:	f7 f7                	div    %edi
  80420f:	89 c5                	mov    %eax,%ebp
  804211:	89 f0                	mov    %esi,%eax
  804213:	31 d2                	xor    %edx,%edx
  804215:	f7 f5                	div    %ebp
  804217:	89 c8                	mov    %ecx,%eax
  804219:	f7 f5                	div    %ebp
  80421b:	89 d0                	mov    %edx,%eax
  80421d:	e9 44 ff ff ff       	jmp    804166 <__umoddi3+0x3e>
  804222:	66 90                	xchg   %ax,%ax
  804224:	89 c8                	mov    %ecx,%eax
  804226:	89 f2                	mov    %esi,%edx
  804228:	83 c4 1c             	add    $0x1c,%esp
  80422b:	5b                   	pop    %ebx
  80422c:	5e                   	pop    %esi
  80422d:	5f                   	pop    %edi
  80422e:	5d                   	pop    %ebp
  80422f:	c3                   	ret    
  804230:	3b 04 24             	cmp    (%esp),%eax
  804233:	72 06                	jb     80423b <__umoddi3+0x113>
  804235:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804239:	77 0f                	ja     80424a <__umoddi3+0x122>
  80423b:	89 f2                	mov    %esi,%edx
  80423d:	29 f9                	sub    %edi,%ecx
  80423f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804243:	89 14 24             	mov    %edx,(%esp)
  804246:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80424a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80424e:	8b 14 24             	mov    (%esp),%edx
  804251:	83 c4 1c             	add    $0x1c,%esp
  804254:	5b                   	pop    %ebx
  804255:	5e                   	pop    %esi
  804256:	5f                   	pop    %edi
  804257:	5d                   	pop    %ebp
  804258:	c3                   	ret    
  804259:	8d 76 00             	lea    0x0(%esi),%esi
  80425c:	2b 04 24             	sub    (%esp),%eax
  80425f:	19 fa                	sbb    %edi,%edx
  804261:	89 d1                	mov    %edx,%ecx
  804263:	89 c6                	mov    %eax,%esi
  804265:	e9 71 ff ff ff       	jmp    8041db <__umoddi3+0xb3>
  80426a:	66 90                	xchg   %ax,%ax
  80426c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804270:	72 ea                	jb     80425c <__umoddi3+0x134>
  804272:	89 d9                	mov    %ebx,%ecx
  804274:	e9 62 ff ff ff       	jmp    8041db <__umoddi3+0xb3>
