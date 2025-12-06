
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 d5 03 00 00       	call   80040b <libmain>
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
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ac 00 00 00    	sub    $0xac,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800044:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80004b:	e8 a3 30 00 00       	call   8030f3 <sys_calculate_free_frames>
  800050:	89 45 e0             	mov    %eax,-0x20(%ebp)
	x = smalloc("x", 4, 0);
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	6a 00                	push   $0x0
  800058:	6a 04                	push   $0x4
  80005a:	68 40 43 80 00       	push   $0x804340
  80005f:	e8 54 1f 00 00       	call   801fb8 <smalloc>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)pagealloc_start) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80006a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80006d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  800070:	74 14                	je     800086 <_main+0x4e>
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	68 44 43 80 00       	push   $0x804344
  80007a:	6a 1a                	push   $0x1a
  80007c:	68 a7 43 80 00       	push   $0x8043a7
  800081:	e8 35 05 00 00       	call   8005bb <_panic>
	expected = 1+1 ; /*1page +1table*/
  800086:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80008d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800090:	e8 5e 30 00 00       	call   8030f3 <sys_calculate_free_frames>
  800095:	29 c3                	sub    %eax,%ebx
  800097:	89 d8                	mov    %ebx,%eax
  800099:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80009c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80009f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8000a2:	7c 0b                	jl     8000af <_main+0x77>
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	83 c0 02             	add    $0x2,%eax
  8000aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8000ad:	7d 24                	jge    8000d3 <_main+0x9b>
  8000af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000b2:	e8 3c 30 00 00       	call   8030f3 <sys_calculate_free_frames>
  8000b7:	29 c3                	sub    %eax,%ebx
  8000b9:	89 d8                	mov    %ebx,%eax
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	ff 75 d8             	pushl  -0x28(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	68 c8 43 80 00       	push   $0x8043c8
  8000c7:	6a 1d                	push   $0x1d
  8000c9:	68 a7 43 80 00       	push   $0x8043a7
  8000ce:	e8 e8 04 00 00       	call   8005bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  8000d3:	e8 1b 30 00 00       	call   8030f3 <sys_calculate_free_frames>
  8000d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	y = smalloc("y", 4, 0);
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	6a 00                	push   $0x0
  8000e0:	6a 04                	push   $0x4
  8000e2:	68 60 44 80 00       	push   $0x804460
  8000e7:	e8 cc 1e 00 00       	call   801fb8 <smalloc>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f5:	05 00 10 00 00       	add    $0x1000,%eax
  8000fa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 44 43 80 00       	push   $0x804344
  800107:	6a 22                	push   $0x22
  800109:	68 a7 43 80 00       	push   $0x8043a7
  80010e:	e8 a8 04 00 00       	call   8005bb <_panic>
	expected = 1 ; /*1page*/
  800113:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80011a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80011d:	e8 d1 2f 00 00       	call   8030f3 <sys_calculate_free_frames>
  800122:	29 c3                	sub    %eax,%ebx
  800124:	89 d8                	mov    %ebx,%eax
  800126:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800129:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80012f:	7c 0b                	jl     80013c <_main+0x104>
  800131:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800134:	83 c0 02             	add    $0x2,%eax
  800137:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80013a:	7d 24                	jge    800160 <_main+0x128>
  80013c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80013f:	e8 af 2f 00 00       	call   8030f3 <sys_calculate_free_frames>
  800144:	29 c3                	sub    %eax,%ebx
  800146:	89 d8                	mov    %ebx,%eax
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	ff 75 d8             	pushl  -0x28(%ebp)
  80014e:	50                   	push   %eax
  80014f:	68 c8 43 80 00       	push   $0x8043c8
  800154:	6a 25                	push   $0x25
  800156:	68 a7 43 80 00       	push   $0x8043a7
  80015b:	e8 5b 04 00 00       	call   8005bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800160:	e8 8e 2f 00 00       	call   8030f3 <sys_calculate_free_frames>
  800165:	89 45 e0             	mov    %eax,-0x20(%ebp)
	z = smalloc("z", 4, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	6a 04                	push   $0x4
  80016f:	68 62 44 80 00       	push   $0x804462
  800174:	e8 3f 1e 00 00       	call   801fb8 <smalloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80017f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800182:	05 00 20 00 00       	add    $0x2000,%eax
  800187:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80018a:	74 14                	je     8001a0 <_main+0x168>
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	68 44 43 80 00       	push   $0x804344
  800194:	6a 2a                	push   $0x2a
  800196:	68 a7 43 80 00       	push   $0x8043a7
  80019b:	e8 1b 04 00 00       	call   8005bb <_panic>
	expected = 1 ; /*1page*/
  8001a0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001aa:	e8 44 2f 00 00       	call   8030f3 <sys_calculate_free_frames>
  8001af:	29 c3                	sub    %eax,%ebx
  8001b1:	89 d8                	mov    %ebx,%eax
  8001b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001b9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001bc:	7c 0b                	jl     8001c9 <_main+0x191>
  8001be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001c1:	83 c0 02             	add    $0x2,%eax
  8001c4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001c7:	7d 24                	jge    8001ed <_main+0x1b5>
  8001c9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001cc:	e8 22 2f 00 00       	call   8030f3 <sys_calculate_free_frames>
  8001d1:	29 c3                	sub    %eax,%ebx
  8001d3:	89 d8                	mov    %ebx,%eax
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001db:	50                   	push   %eax
  8001dc:	68 c8 43 80 00       	push   $0x8043c8
  8001e1:	6a 2d                	push   $0x2d
  8001e3:	68 a7 43 80 00       	push   $0x8043a7
  8001e8:	e8 ce 03 00 00       	call   8005bb <_panic>

	*x = 10 ;
  8001ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f0:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001f9:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800204:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	a1 20 50 80 00       	mov    0x805020,%eax
  800211:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800217:	6a 32                	push   $0x32
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 64 44 80 00       	push   $0x804464
  800220:	e8 29 30 00 00       	call   80324e <sys_create_env>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 45 c8             	mov    %eax,-0x38(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80022b:	a1 20 50 80 00       	mov    0x805020,%eax
  800230:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	a1 20 50 80 00       	mov    0x805020,%eax
  80023d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800243:	6a 32                	push   $0x32
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 64 44 80 00       	push   $0x804464
  80024c:	e8 fd 2f 00 00       	call   80324e <sys_create_env>
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800257:	a1 20 50 80 00       	mov    0x805020,%eax
  80025c:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800262:	89 c2                	mov    %eax,%edx
  800264:	a1 20 50 80 00       	mov    0x805020,%eax
  800269:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80026f:	6a 32                	push   $0x32
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	68 64 44 80 00       	push   $0x804464
  800278:	e8 d1 2f 00 00       	call   80324e <sys_create_env>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800283:	e8 12 31 00 00       	call   80339a <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	6a 01                	push   $0x1
  80028d:	6a 04                	push   $0x4
  80028f:	68 72 44 80 00       	push   $0x804472
  800294:	e8 1f 1d 00 00       	call   801fb8 <smalloc>
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	89 45 bc             	mov    %eax,-0x44(%ebp)

	sys_run_env(id1);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 c8             	pushl  -0x38(%ebp)
  8002a5:	e8 c2 2f 00 00       	call   80326c <sys_run_env>
  8002aa:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002b3:	e8 b4 2f 00 00       	call   80326c <sys_run_env>
  8002b8:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	ff 75 c0             	pushl  -0x40(%ebp)
  8002c1:	e8 a6 2f 00 00       	call   80326c <sys_run_env>
  8002c6:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	68 98 3a 00 00       	push   $0x3a98
  8002d1:	e8 3d 3d 00 00       	call   804013 <env_sleep>
  8002d6:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ; //panic("test failed");
  8002d9:	90                   	nop
  8002da:	e8 35 31 00 00       	call   803414 <gettst>
  8002df:	83 f8 03             	cmp    $0x3,%eax
  8002e2:	75 f6                	jne    8002da <_main+0x2a2>


	if (*z != 30)
  8002e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002e7:	8b 00                	mov    (%eax),%eax
  8002e9:	83 f8 1e             	cmp    $0x1e,%eax
  8002ec:	74 14                	je     800302 <_main+0x2ca>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 84 44 80 00       	push   $0x804484
  8002f6:	6a 47                	push   $0x47
  8002f8:	68 a7 43 80 00       	push   $0x8043a7
  8002fd:	e8 b9 02 00 00       	call   8005bb <_panic>
	else
		cprintf("test sharing 2 [Create & Get] is finished. Now, it'll destroy its children...\n\n");
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	68 d4 44 80 00       	push   $0x8044d4
  80030a:	e8 7a 05 00 00       	call   800889 <cprintf>
  80030f:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800312:	e8 be 2f 00 00       	call   8032d5 <sys_getparentenvid>
  800317:	85 c0                	test   %eax,%eax
  800319:	0f 8e e3 00 00 00    	jle    800402 <_main+0x3ca>
		//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
		//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
		//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
		//	2. changing the # free frames

		char changeIntCmd[100] = "__changeInterruptStatus__";
  80031f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800325:	bb da 45 80 00       	mov    $0x8045da,%ebx
  80032a:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800337:	8d 95 6e ff ff ff    	lea    -0x92(%ebp),%edx
  80033d:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800342:	b0 00                	mov    $0x0,%al
  800344:	89 d7                	mov    %edx,%edi
  800346:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(changeIntCmd, 0);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	6a 00                	push   $0x0
  80034d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800353:	50                   	push   %eax
  800354:	e8 99 31 00 00       	call   8034f2 <sys_utilities>
  800359:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(id1);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	ff 75 c8             	pushl  -0x38(%ebp)
  800362:	e8 21 2f 00 00       	call   803288 <sys_destroy_env>
  800367:	83 c4 10             	add    $0x10,%esp
			cprintf("[1] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	68 24 45 80 00       	push   $0x804524
  800372:	e8 12 05 00 00       	call   800889 <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id2);
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	ff 75 c4             	pushl  -0x3c(%ebp)
  800380:	e8 03 2f 00 00       	call   803288 <sys_destroy_env>
  800385:	83 c4 10             	add    $0x10,%esp
			cprintf("[2] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	68 5c 45 80 00       	push   $0x80455c
  800390:	e8 f4 04 00 00       	call   800889 <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id3);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	ff 75 c0             	pushl  -0x40(%ebp)
  80039e:	e8 e5 2e 00 00       	call   803288 <sys_destroy_env>
  8003a3:	83 c4 10             	add    $0x10,%esp
			cprintf("[3] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 94 45 80 00       	push   $0x804594
  8003ae:	e8 d6 04 00 00       	call   800889 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	e8 2b 31 00 00       	call   8034f2 <sys_utilities>
  8003c7:	83 c4 10             	add    $0x10,%esp

		int *finishedCount = NULL;
  8003ca:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8003d1:	e8 ff 2e 00 00       	call   8032d5 <sys_getparentenvid>
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	68 cc 45 80 00       	push   $0x8045cc
  8003de:	50                   	push   %eax
  8003df:	e8 2e 1f 00 00       	call   802312 <sget>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		sys_lock_cons();
  8003ea:	e8 54 2c 00 00       	call   803043 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  8003ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	8d 50 01             	lea    0x1(%eax),%edx
  8003f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003fa:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8003fc:	e8 5c 2c 00 00       	call   80305d <sys_unlock_cons>
	}
	return;
  800401:	90                   	nop
  800402:	90                   	nop
}
  800403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5f                   	pop    %edi
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	57                   	push   %edi
  80040f:	56                   	push   %esi
  800410:	53                   	push   %ebx
  800411:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800414:	e8 a3 2e 00 00       	call   8032bc <sys_getenvindex>
  800419:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80041c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	c1 e0 02             	shl    $0x2,%eax
  800429:	01 d0                	add    %edx,%eax
  80042b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800432:	01 d0                	add    %edx,%eax
  800434:	c1 e0 03             	shl    $0x3,%eax
  800437:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800441:	a1 20 50 80 00       	mov    0x805020,%eax
  800446:	8a 40 20             	mov    0x20(%eax),%al
  800449:	84 c0                	test   %al,%al
  80044b:	74 0d                	je     80045a <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80044d:	a1 20 50 80 00       	mov    0x805020,%eax
  800452:	83 c0 20             	add    $0x20,%eax
  800455:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80045e:	7e 0a                	jle    80046a <libmain+0x5f>
		binaryname = argv[0];
  800460:	8b 45 0c             	mov    0xc(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 0c             	pushl  0xc(%ebp)
  800470:	ff 75 08             	pushl  0x8(%ebp)
  800473:	e8 c0 fb ff ff       	call   800038 <_main>
  800478:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80047b:	a1 00 50 80 00       	mov    0x805000,%eax
  800480:	85 c0                	test   %eax,%eax
  800482:	0f 84 01 01 00 00    	je     800589 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800488:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80048e:	bb 38 47 80 00       	mov    $0x804738,%ebx
  800493:	ba 0e 00 00 00       	mov    $0xe,%edx
  800498:	89 c7                	mov    %eax,%edi
  80049a:	89 de                	mov    %ebx,%esi
  80049c:	89 d1                	mov    %edx,%ecx
  80049e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004a0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004a3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004a8:	b0 00                	mov    $0x0,%al
  8004aa:	89 d7                	mov    %edx,%edi
  8004ac:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004b8:	83 ec 08             	sub    $0x8,%esp
  8004bb:	50                   	push   %eax
  8004bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004c2:	50                   	push   %eax
  8004c3:	e8 2a 30 00 00       	call   8034f2 <sys_utilities>
  8004c8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004cb:	e8 73 2b 00 00       	call   803043 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	68 58 46 80 00       	push   $0x804658
  8004d8:	e8 ac 03 00 00       	call   800889 <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	74 18                	je     8004ff <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004e7:	e8 24 30 00 00       	call   803510 <sys_get_optimal_num_faults>
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	50                   	push   %eax
  8004f0:	68 80 46 80 00       	push   $0x804680
  8004f5:	e8 8f 03 00 00       	call   800889 <cprintf>
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	eb 59                	jmp    800558 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800504:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80050a:	a1 20 50 80 00       	mov    0x805020,%eax
  80050f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	52                   	push   %edx
  800519:	50                   	push   %eax
  80051a:	68 a4 46 80 00       	push   $0x8046a4
  80051f:	e8 65 03 00 00       	call   800889 <cprintf>
  800524:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800527:	a1 20 50 80 00       	mov    0x805020,%eax
  80052c:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800532:	a1 20 50 80 00       	mov    0x805020,%eax
  800537:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80053d:	a1 20 50 80 00       	mov    0x805020,%eax
  800542:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800548:	51                   	push   %ecx
  800549:	52                   	push   %edx
  80054a:	50                   	push   %eax
  80054b:	68 cc 46 80 00       	push   $0x8046cc
  800550:	e8 34 03 00 00       	call   800889 <cprintf>
  800555:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800558:	a1 20 50 80 00       	mov    0x805020,%eax
  80055d:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	50                   	push   %eax
  800567:	68 24 47 80 00       	push   $0x804724
  80056c:	e8 18 03 00 00       	call   800889 <cprintf>
  800571:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800574:	83 ec 0c             	sub    $0xc,%esp
  800577:	68 58 46 80 00       	push   $0x804658
  80057c:	e8 08 03 00 00       	call   800889 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800584:	e8 d4 2a 00 00       	call   80305d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800589:	e8 1f 00 00 00       	call   8005ad <exit>
}
  80058e:	90                   	nop
  80058f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800592:	5b                   	pop    %ebx
  800593:	5e                   	pop    %esi
  800594:	5f                   	pop    %edi
  800595:	5d                   	pop    %ebp
  800596:	c3                   	ret    

00800597 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80059d:	83 ec 0c             	sub    $0xc,%esp
  8005a0:	6a 00                	push   $0x0
  8005a2:	e8 e1 2c 00 00       	call   803288 <sys_destroy_env>
  8005a7:	83 c4 10             	add    $0x10,%esp
}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <exit>:

void
exit(void)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005b3:	e8 36 2d 00 00       	call   8032ee <sys_exit_env>
}
  8005b8:	90                   	nop
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8005c4:	83 c0 04             	add    $0x4,%eax
  8005c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005ca:	a1 38 51 83 00       	mov    0x835138,%eax
  8005cf:	85 c0                	test   %eax,%eax
  8005d1:	74 16                	je     8005e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005d3:	a1 38 51 83 00       	mov    0x835138,%eax
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	50                   	push   %eax
  8005dc:	68 9c 47 80 00       	push   $0x80479c
  8005e1:	e8 a3 02 00 00       	call   800889 <cprintf>
  8005e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8005e9:	a1 04 50 80 00       	mov    0x805004,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	ff 75 0c             	pushl  0xc(%ebp)
  8005f4:	ff 75 08             	pushl  0x8(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	68 a4 47 80 00       	push   $0x8047a4
  8005fd:	6a 74                	push   $0x74
  8005ff:	e8 b2 02 00 00       	call   8008b6 <cprintf_colored>
  800604:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800607:	8b 45 10             	mov    0x10(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 04 02 00 00       	call   80081a <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	6a 00                	push   $0x0
  80061e:	68 cc 47 80 00       	push   $0x8047cc
  800623:	e8 f2 01 00 00       	call   80081a <vcprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80062b:	e8 7d ff ff ff       	call   8005ad <exit>

	// should not return here
	while (1) ;
  800630:	eb fe                	jmp    800630 <_panic+0x75>

00800632 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800638:	a1 20 50 80 00       	mov    0x805020,%eax
  80063d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800643:	8b 45 0c             	mov    0xc(%ebp),%eax
  800646:	39 c2                	cmp    %eax,%edx
  800648:	74 14                	je     80065e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80064a:	83 ec 04             	sub    $0x4,%esp
  80064d:	68 d0 47 80 00       	push   $0x8047d0
  800652:	6a 26                	push   $0x26
  800654:	68 1c 48 80 00       	push   $0x80481c
  800659:	e8 5d ff ff ff       	call   8005bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80065e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800665:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80066c:	e9 c5 00 00 00       	jmp    800736 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800674:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	01 d0                	add    %edx,%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	85 c0                	test   %eax,%eax
  800684:	75 08                	jne    80068e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800686:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800689:	e9 a5 00 00 00       	jmp    800733 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80068e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800695:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80069c:	eb 69                	jmp    800707 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80069e:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006ac:	89 d0                	mov    %edx,%eax
  8006ae:	01 c0                	add    %eax,%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	c1 e0 03             	shl    $0x3,%eax
  8006b5:	01 c8                	add    %ecx,%eax
  8006b7:	8a 40 04             	mov    0x4(%eax),%al
  8006ba:	84 c0                	test   %al,%al
  8006bc:	75 46                	jne    800704 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006be:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006cc:	89 d0                	mov    %edx,%eax
  8006ce:	01 c0                	add    %eax,%eax
  8006d0:	01 d0                	add    %edx,%eax
  8006d2:	c1 e0 03             	shl    $0x3,%eax
  8006d5:	01 c8                	add    %ecx,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	01 c8                	add    %ecx,%eax
  8006f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006f7:	39 c2                	cmp    %eax,%edx
  8006f9:	75 09                	jne    800704 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800702:	eb 15                	jmp    800719 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800704:	ff 45 e8             	incl   -0x18(%ebp)
  800707:	a1 20 50 80 00       	mov    0x805020,%eax
  80070c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800715:	39 c2                	cmp    %eax,%edx
  800717:	77 85                	ja     80069e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800719:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80071d:	75 14                	jne    800733 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80071f:	83 ec 04             	sub    $0x4,%esp
  800722:	68 28 48 80 00       	push   $0x804828
  800727:	6a 3a                	push   $0x3a
  800729:	68 1c 48 80 00       	push   $0x80481c
  80072e:	e8 88 fe ff ff       	call   8005bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800733:	ff 45 f0             	incl   -0x10(%ebp)
  800736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800739:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073c:	0f 8c 2f ff ff ff    	jl     800671 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800742:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800749:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800750:	eb 26                	jmp    800778 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800752:	a1 20 50 80 00       	mov    0x805020,%eax
  800757:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80075d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800760:	89 d0                	mov    %edx,%eax
  800762:	01 c0                	add    %eax,%eax
  800764:	01 d0                	add    %edx,%eax
  800766:	c1 e0 03             	shl    $0x3,%eax
  800769:	01 c8                	add    %ecx,%eax
  80076b:	8a 40 04             	mov    0x4(%eax),%al
  80076e:	3c 01                	cmp    $0x1,%al
  800770:	75 03                	jne    800775 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800772:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800775:	ff 45 e0             	incl   -0x20(%ebp)
  800778:	a1 20 50 80 00       	mov    0x805020,%eax
  80077d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800783:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	77 c8                	ja     800752 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800790:	74 14                	je     8007a6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800792:	83 ec 04             	sub    $0x4,%esp
  800795:	68 7c 48 80 00       	push   $0x80487c
  80079a:	6a 44                	push   $0x44
  80079c:	68 1c 48 80 00       	push   $0x80481c
  8007a1:	e8 15 fe ff ff       	call   8005bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007a6:	90                   	nop
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    

008007a9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	53                   	push   %ebx
  8007ad:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8007b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bb:	89 0a                	mov    %ecx,(%edx)
  8007bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c0:	88 d1                	mov    %dl,%cl
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007d3:	75 30                	jne    800805 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8007d5:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8007db:	a0 64 d0 81 00       	mov    0x81d064,%al
  8007e0:	0f b6 c0             	movzbl %al,%eax
  8007e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e6:	8b 09                	mov    (%ecx),%ecx
  8007e8:	89 cb                	mov    %ecx,%ebx
  8007ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ed:	83 c1 08             	add    $0x8,%ecx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	53                   	push   %ebx
  8007f3:	51                   	push   %ecx
  8007f4:	e8 06 28 00 00       	call   802fff <sys_cputs>
  8007f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800805:	8b 45 0c             	mov    0xc(%ebp),%eax
  800808:	8b 40 04             	mov    0x4(%eax),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	89 50 04             	mov    %edx,0x4(%eax)
}
  800814:	90                   	nop
  800815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800818:	c9                   	leave  
  800819:	c3                   	ret    

0080081a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800823:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80082a:	00 00 00 
	b.cnt = 0;
  80082d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800834:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	ff 75 08             	pushl  0x8(%ebp)
  80083d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800843:	50                   	push   %eax
  800844:	68 a9 07 80 00       	push   $0x8007a9
  800849:	e8 5a 02 00 00       	call   800aa8 <vprintfmt>
  80084e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800851:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800857:	a0 64 d0 81 00       	mov    0x81d064,%al
  80085c:	0f b6 c0             	movzbl %al,%eax
  80085f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800865:	52                   	push   %edx
  800866:	50                   	push   %eax
  800867:	51                   	push   %ecx
  800868:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80086e:	83 c0 08             	add    $0x8,%eax
  800871:	50                   	push   %eax
  800872:	e8 88 27 00 00       	call   802fff <sys_cputs>
  800877:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80087a:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800881:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80088f:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800896:	8d 45 0c             	lea    0xc(%ebp),%eax
  800899:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a5:	50                   	push   %eax
  8008a6:	e8 6f ff ff ff       	call   80081a <vcprintf>
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    

008008b6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008bc:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	c1 e0 08             	shl    $0x8,%eax
  8008c9:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  8008ce:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e0:	50                   	push   %eax
  8008e1:	e8 34 ff ff ff       	call   80081a <vcprintf>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8008ec:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  8008f3:	07 00 00 

	return cnt;
  8008f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    

008008fb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800901:	e8 3d 27 00 00       	call   803043 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800906:	8d 45 0c             	lea    0xc(%ebp),%eax
  800909:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 f4             	pushl  -0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	e8 ff fe ff ff       	call   80081a <vcprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800921:	e8 37 27 00 00       	call   80305d <sys_unlock_cons>
	return cnt;
  800926:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800929:	c9                   	leave  
  80092a:	c3                   	ret    

0080092b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	83 ec 14             	sub    $0x14,%esp
  800932:	8b 45 10             	mov    0x10(%ebp),%eax
  800935:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80093e:	8b 45 18             	mov    0x18(%ebp),%eax
  800941:	ba 00 00 00 00       	mov    $0x0,%edx
  800946:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800949:	77 55                	ja     8009a0 <printnum+0x75>
  80094b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80094e:	72 05                	jb     800955 <printnum+0x2a>
  800950:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800953:	77 4b                	ja     8009a0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800955:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800958:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80095b:	8b 45 18             	mov    0x18(%ebp),%eax
  80095e:	ba 00 00 00 00       	mov    $0x0,%edx
  800963:	52                   	push   %edx
  800964:	50                   	push   %eax
  800965:	ff 75 f4             	pushl  -0xc(%ebp)
  800968:	ff 75 f0             	pushl  -0x10(%ebp)
  80096b:	e8 64 37 00 00       	call   8040d4 <__udivdi3>
  800970:	83 c4 10             	add    $0x10,%esp
  800973:	83 ec 04             	sub    $0x4,%esp
  800976:	ff 75 20             	pushl  0x20(%ebp)
  800979:	53                   	push   %ebx
  80097a:	ff 75 18             	pushl  0x18(%ebp)
  80097d:	52                   	push   %edx
  80097e:	50                   	push   %eax
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	ff 75 08             	pushl  0x8(%ebp)
  800985:	e8 a1 ff ff ff       	call   80092b <printnum>
  80098a:	83 c4 20             	add    $0x20,%esp
  80098d:	eb 1a                	jmp    8009a9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	ff 75 20             	pushl  0x20(%ebp)
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	ff d0                	call   *%eax
  80099d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a0:	ff 4d 1c             	decl   0x1c(%ebp)
  8009a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009a7:	7f e6                	jg     80098f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009a9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b7:	53                   	push   %ebx
  8009b8:	51                   	push   %ecx
  8009b9:	52                   	push   %edx
  8009ba:	50                   	push   %eax
  8009bb:	e8 24 38 00 00       	call   8041e4 <__umoddi3>
  8009c0:	83 c4 10             	add    $0x10,%esp
  8009c3:	05 f4 4a 80 00       	add    $0x804af4,%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	0f be c0             	movsbl %al,%eax
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	50                   	push   %eax
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	ff d0                	call   *%eax
  8009d9:	83 c4 10             	add    $0x10,%esp
}
  8009dc:	90                   	nop
  8009dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e9:	7e 1c                	jle    800a07 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 00                	mov    (%eax),%eax
  8009f0:	8d 50 08             	lea    0x8(%eax),%edx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	89 10                	mov    %edx,(%eax)
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 00                	mov    (%eax),%eax
  8009fd:	83 e8 08             	sub    $0x8,%eax
  800a00:	8b 50 04             	mov    0x4(%eax),%edx
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	eb 40                	jmp    800a47 <getuint+0x65>
	else if (lflag)
  800a07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0b:	74 1e                	je     800a2b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 00                	mov    (%eax),%eax
  800a12:	8d 50 04             	lea    0x4(%eax),%edx
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	89 10                	mov    %edx,(%eax)
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 00                	mov    (%eax),%eax
  800a1f:	83 e8 04             	sub    $0x4,%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	ba 00 00 00 00       	mov    $0x0,%edx
  800a29:	eb 1c                	jmp    800a47 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 00                	mov    (%eax),%eax
  800a30:	8d 50 04             	lea    0x4(%eax),%edx
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	89 10                	mov    %edx,(%eax)
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	8b 00                	mov    (%eax),%eax
  800a3d:	83 e8 04             	sub    $0x4,%eax
  800a40:	8b 00                	mov    (%eax),%eax
  800a42:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a4c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a50:	7e 1c                	jle    800a6e <getint+0x25>
		return va_arg(*ap, long long);
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 00                	mov    (%eax),%eax
  800a57:	8d 50 08             	lea    0x8(%eax),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	89 10                	mov    %edx,(%eax)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	83 e8 08             	sub    $0x8,%eax
  800a67:	8b 50 04             	mov    0x4(%eax),%edx
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	eb 38                	jmp    800aa6 <getint+0x5d>
	else if (lflag)
  800a6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a72:	74 1a                	je     800a8e <getint+0x45>
		return va_arg(*ap, long);
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8b 00                	mov    (%eax),%eax
  800a79:	8d 50 04             	lea    0x4(%eax),%edx
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	89 10                	mov    %edx,(%eax)
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8b 00                	mov    (%eax),%eax
  800a86:	83 e8 04             	sub    $0x4,%eax
  800a89:	8b 00                	mov    (%eax),%eax
  800a8b:	99                   	cltd   
  800a8c:	eb 18                	jmp    800aa6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8b 00                	mov    (%eax),%eax
  800a93:	8d 50 04             	lea    0x4(%eax),%edx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	89 10                	mov    %edx,(%eax)
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 00                	mov    (%eax),%eax
  800aa0:	83 e8 04             	sub    $0x4,%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	99                   	cltd   
}
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	56                   	push   %esi
  800aac:	53                   	push   %ebx
  800aad:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab0:	eb 17                	jmp    800ac9 <vprintfmt+0x21>
			if (ch == '\0')
  800ab2:	85 db                	test   %ebx,%ebx
  800ab4:	0f 84 c1 03 00 00    	je     800e7b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	53                   	push   %ebx
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	ff d0                	call   *%eax
  800ac6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	8d 50 01             	lea    0x1(%eax),%edx
  800acf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	0f b6 d8             	movzbl %al,%ebx
  800ad7:	83 fb 25             	cmp    $0x25,%ebx
  800ada:	75 d6                	jne    800ab2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800adc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ae0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ae7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800aee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800af5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	8d 50 01             	lea    0x1(%eax),%edx
  800b02:	89 55 10             	mov    %edx,0x10(%ebp)
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	0f b6 d8             	movzbl %al,%ebx
  800b0a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b0d:	83 f8 5b             	cmp    $0x5b,%eax
  800b10:	0f 87 3d 03 00 00    	ja     800e53 <vprintfmt+0x3ab>
  800b16:	8b 04 85 18 4b 80 00 	mov    0x804b18(,%eax,4),%eax
  800b1d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b1f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b23:	eb d7                	jmp    800afc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b25:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b29:	eb d1                	jmp    800afc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b35:	89 d0                	mov    %edx,%eax
  800b37:	c1 e0 02             	shl    $0x2,%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	01 c0                	add    %eax,%eax
  800b3e:	01 d8                	add    %ebx,%eax
  800b40:	83 e8 30             	sub    $0x30,%eax
  800b43:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b46:	8b 45 10             	mov    0x10(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b4e:	83 fb 2f             	cmp    $0x2f,%ebx
  800b51:	7e 3e                	jle    800b91 <vprintfmt+0xe9>
  800b53:	83 fb 39             	cmp    $0x39,%ebx
  800b56:	7f 39                	jg     800b91 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b58:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b5b:	eb d5                	jmp    800b32 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	83 c0 04             	add    $0x4,%eax
  800b63:	89 45 14             	mov    %eax,0x14(%ebp)
  800b66:	8b 45 14             	mov    0x14(%ebp),%eax
  800b69:	83 e8 04             	sub    $0x4,%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b71:	eb 1f                	jmp    800b92 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b77:	79 83                	jns    800afc <vprintfmt+0x54>
				width = 0;
  800b79:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b80:	e9 77 ff ff ff       	jmp    800afc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b85:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b8c:	e9 6b ff ff ff       	jmp    800afc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b91:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b96:	0f 89 60 ff ff ff    	jns    800afc <vprintfmt+0x54>
				width = precision, precision = -1;
  800b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ba2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ba9:	e9 4e ff ff ff       	jmp    800afc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bae:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bb1:	e9 46 ff ff ff       	jmp    800afc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	83 e8 04             	sub    $0x4,%eax
  800bc5:	8b 00                	mov    (%eax),%eax
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	50                   	push   %eax
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	ff d0                	call   *%eax
  800bd3:	83 c4 10             	add    $0x10,%esp
			break;
  800bd6:	e9 9b 02 00 00       	jmp    800e76 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 14             	mov    %eax,0x14(%ebp)
  800be4:	8b 45 14             	mov    0x14(%ebp),%eax
  800be7:	83 e8 04             	sub    $0x4,%eax
  800bea:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bec:	85 db                	test   %ebx,%ebx
  800bee:	79 02                	jns    800bf2 <vprintfmt+0x14a>
				err = -err;
  800bf0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bf2:	83 fb 64             	cmp    $0x64,%ebx
  800bf5:	7f 0b                	jg     800c02 <vprintfmt+0x15a>
  800bf7:	8b 34 9d 60 49 80 00 	mov    0x804960(,%ebx,4),%esi
  800bfe:	85 f6                	test   %esi,%esi
  800c00:	75 19                	jne    800c1b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c02:	53                   	push   %ebx
  800c03:	68 05 4b 80 00       	push   $0x804b05
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	e8 70 02 00 00       	call   800e83 <printfmt>
  800c13:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c16:	e9 5b 02 00 00       	jmp    800e76 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c1b:	56                   	push   %esi
  800c1c:	68 0e 4b 80 00       	push   $0x804b0e
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	ff 75 08             	pushl  0x8(%ebp)
  800c27:	e8 57 02 00 00       	call   800e83 <printfmt>
  800c2c:	83 c4 10             	add    $0x10,%esp
			break;
  800c2f:	e9 42 02 00 00       	jmp    800e76 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c34:	8b 45 14             	mov    0x14(%ebp),%eax
  800c37:	83 c0 04             	add    $0x4,%eax
  800c3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c40:	83 e8 04             	sub    $0x4,%eax
  800c43:	8b 30                	mov    (%eax),%esi
  800c45:	85 f6                	test   %esi,%esi
  800c47:	75 05                	jne    800c4e <vprintfmt+0x1a6>
				p = "(null)";
  800c49:	be 11 4b 80 00       	mov    $0x804b11,%esi
			if (width > 0 && padc != '-')
  800c4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c52:	7e 6d                	jle    800cc1 <vprintfmt+0x219>
  800c54:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c58:	74 67                	je     800cc1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c5d:	83 ec 08             	sub    $0x8,%esp
  800c60:	50                   	push   %eax
  800c61:	56                   	push   %esi
  800c62:	e8 1e 03 00 00       	call   800f85 <strnlen>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c6d:	eb 16                	jmp    800c85 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c6f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c73:	83 ec 08             	sub    $0x8,%esp
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	50                   	push   %eax
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c82:	ff 4d e4             	decl   -0x1c(%ebp)
  800c85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c89:	7f e4                	jg     800c6f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c8b:	eb 34                	jmp    800cc1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c91:	74 1c                	je     800caf <vprintfmt+0x207>
  800c93:	83 fb 1f             	cmp    $0x1f,%ebx
  800c96:	7e 05                	jle    800c9d <vprintfmt+0x1f5>
  800c98:	83 fb 7e             	cmp    $0x7e,%ebx
  800c9b:	7e 12                	jle    800caf <vprintfmt+0x207>
					putch('?', putdat);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	6a 3f                	push   $0x3f
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	ff d0                	call   *%eax
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	eb 0f                	jmp    800cbe <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800cc1:	89 f0                	mov    %esi,%eax
  800cc3:	8d 70 01             	lea    0x1(%eax),%esi
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	0f be d8             	movsbl %al,%ebx
  800ccb:	85 db                	test   %ebx,%ebx
  800ccd:	74 24                	je     800cf3 <vprintfmt+0x24b>
  800ccf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cd3:	78 b8                	js     800c8d <vprintfmt+0x1e5>
  800cd5:	ff 4d e0             	decl   -0x20(%ebp)
  800cd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cdc:	79 af                	jns    800c8d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cde:	eb 13                	jmp    800cf3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	ff 75 0c             	pushl  0xc(%ebp)
  800ce6:	6a 20                	push   $0x20
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	ff d0                	call   *%eax
  800ced:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf0:	ff 4d e4             	decl   -0x1c(%ebp)
  800cf3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf7:	7f e7                	jg     800ce0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cf9:	e9 78 01 00 00       	jmp    800e76 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	ff 75 e8             	pushl  -0x18(%ebp)
  800d04:	8d 45 14             	lea    0x14(%ebp),%eax
  800d07:	50                   	push   %eax
  800d08:	e8 3c fd ff ff       	call   800a49 <getint>
  800d0d:	83 c4 10             	add    $0x10,%esp
  800d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d1c:	85 d2                	test   %edx,%edx
  800d1e:	79 23                	jns    800d43 <vprintfmt+0x29b>
				putch('-', putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	6a 2d                	push   $0x2d
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	ff d0                	call   *%eax
  800d2d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d36:	f7 d8                	neg    %eax
  800d38:	83 d2 00             	adc    $0x0,%edx
  800d3b:	f7 da                	neg    %edx
  800d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d43:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d4a:	e9 bc 00 00 00       	jmp    800e0b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d4f:	83 ec 08             	sub    $0x8,%esp
  800d52:	ff 75 e8             	pushl  -0x18(%ebp)
  800d55:	8d 45 14             	lea    0x14(%ebp),%eax
  800d58:	50                   	push   %eax
  800d59:	e8 84 fc ff ff       	call   8009e2 <getuint>
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d6e:	e9 98 00 00 00       	jmp    800e0b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d73:	83 ec 08             	sub    $0x8,%esp
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	6a 58                	push   $0x58
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	ff d0                	call   *%eax
  800d80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d83:	83 ec 08             	sub    $0x8,%esp
  800d86:	ff 75 0c             	pushl  0xc(%ebp)
  800d89:	6a 58                	push   $0x58
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	ff d0                	call   *%eax
  800d90:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	6a 58                	push   $0x58
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	ff d0                	call   *%eax
  800da0:	83 c4 10             	add    $0x10,%esp
			break;
  800da3:	e9 ce 00 00 00       	jmp    800e76 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	6a 30                	push   $0x30
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	ff d0                	call   *%eax
  800db5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800db8:	83 ec 08             	sub    $0x8,%esp
  800dbb:	ff 75 0c             	pushl  0xc(%ebp)
  800dbe:	6a 78                	push   $0x78
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	ff d0                	call   *%eax
  800dc5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcb:	83 c0 04             	add    $0x4,%eax
  800dce:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd4:	83 e8 04             	sub    $0x4,%eax
  800dd7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800de3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800dea:	eb 1f                	jmp    800e0b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 e8             	pushl  -0x18(%ebp)
  800df2:	8d 45 14             	lea    0x14(%ebp),%eax
  800df5:	50                   	push   %eax
  800df6:	e8 e7 fb ff ff       	call   8009e2 <getuint>
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e04:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e0b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	52                   	push   %edx
  800e16:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	ff 75 08             	pushl  0x8(%ebp)
  800e26:	e8 00 fb ff ff       	call   80092b <printnum>
  800e2b:	83 c4 20             	add    $0x20,%esp
			break;
  800e2e:	eb 46                	jmp    800e76 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			break;
  800e3f:	eb 35                	jmp    800e76 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e41:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800e48:	eb 2c                	jmp    800e76 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e4a:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800e51:	eb 23                	jmp    800e76 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 0c             	pushl  0xc(%ebp)
  800e59:	6a 25                	push   $0x25
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	ff d0                	call   *%eax
  800e60:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e63:	ff 4d 10             	decl   0x10(%ebp)
  800e66:	eb 03                	jmp    800e6b <vprintfmt+0x3c3>
  800e68:	ff 4d 10             	decl   0x10(%ebp)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	48                   	dec    %eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3c 25                	cmp    $0x25,%al
  800e73:	75 f3                	jne    800e68 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e75:	90                   	nop
		}
	}
  800e76:	e9 35 fc ff ff       	jmp    800ab0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e7b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e89:	8d 45 10             	lea    0x10(%ebp),%eax
  800e8c:	83 c0 04             	add    $0x4,%eax
  800e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	ff 75 f4             	pushl  -0xc(%ebp)
  800e98:	50                   	push   %eax
  800e99:	ff 75 0c             	pushl  0xc(%ebp)
  800e9c:	ff 75 08             	pushl  0x8(%ebp)
  800e9f:	e8 04 fc ff ff       	call   800aa8 <vprintfmt>
  800ea4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ea7:	90                   	nop
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	8b 40 08             	mov    0x8(%eax),%eax
  800eb3:	8d 50 01             	lea    0x1(%eax),%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	8b 10                	mov    (%eax),%edx
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	8b 40 04             	mov    0x4(%eax),%eax
  800ec7:	39 c2                	cmp    %eax,%edx
  800ec9:	73 12                	jae    800edd <sprintputch+0x33>
		*b->buf++ = ch;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	8b 00                	mov    (%eax),%eax
  800ed0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed6:	89 0a                	mov    %ecx,(%edx)
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	88 10                	mov    %dl,(%eax)
}
  800edd:	90                   	nop
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f05:	74 06                	je     800f0d <vsnprintf+0x2d>
  800f07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0b:	7f 07                	jg     800f14 <vsnprintf+0x34>
		return -E_INVAL;
  800f0d:	b8 03 00 00 00       	mov    $0x3,%eax
  800f12:	eb 20                	jmp    800f34 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f14:	ff 75 14             	pushl  0x14(%ebp)
  800f17:	ff 75 10             	pushl  0x10(%ebp)
  800f1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	68 aa 0e 80 00       	push   $0x800eaa
  800f23:	e8 80 fb ff ff       	call   800aa8 <vprintfmt>
  800f28:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f2e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    

00800f36 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f3f:	83 c0 04             	add    $0x4,%eax
  800f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f45:	8b 45 10             	mov    0x10(%ebp),%eax
  800f48:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	ff 75 08             	pushl  0x8(%ebp)
  800f52:	e8 89 ff ff ff       	call   800ee0 <vsnprintf>
  800f57:	83 c4 10             	add    $0x10,%esp
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f6f:	eb 06                	jmp    800f77 <strlen+0x15>
		n++;
  800f71:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	84 c0                	test   %al,%al
  800f7e:	75 f1                	jne    800f71 <strlen+0xf>
		n++;
	return n;
  800f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f92:	eb 09                	jmp    800f9d <strnlen+0x18>
		n++;
  800f94:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f97:	ff 45 08             	incl   0x8(%ebp)
  800f9a:	ff 4d 0c             	decl   0xc(%ebp)
  800f9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa1:	74 09                	je     800fac <strnlen+0x27>
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e8                	jne    800f94 <strnlen+0xf>
		n++;
	return n;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fbd:	90                   	nop
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8d 50 01             	lea    0x1(%eax),%edx
  800fc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fcd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fd0:	8a 12                	mov    (%edx),%dl
  800fd2:	88 10                	mov    %dl,(%eax)
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	84 c0                	test   %al,%al
  800fd8:	75 e4                	jne    800fbe <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800feb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff2:	eb 1f                	jmp    801013 <strncpy+0x34>
		*dst++ = *src;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8d 50 01             	lea    0x1(%eax),%edx
  800ffa:	89 55 08             	mov    %edx,0x8(%ebp)
  800ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801000:	8a 12                	mov    (%edx),%dl
  801002:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	84 c0                	test   %al,%al
  80100b:	74 03                	je     801010 <strncpy+0x31>
			src++;
  80100d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801010:	ff 45 fc             	incl   -0x4(%ebp)
  801013:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801016:	3b 45 10             	cmp    0x10(%ebp),%eax
  801019:	72 d9                	jb     800ff4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80102c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801030:	74 30                	je     801062 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801032:	eb 16                	jmp    80104a <strlcpy+0x2a>
			*dst++ = *src++;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8d 50 01             	lea    0x1(%eax),%edx
  80103a:	89 55 08             	mov    %edx,0x8(%ebp)
  80103d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801040:	8d 4a 01             	lea    0x1(%edx),%ecx
  801043:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801046:	8a 12                	mov    (%edx),%dl
  801048:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80104a:	ff 4d 10             	decl   0x10(%ebp)
  80104d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801051:	74 09                	je     80105c <strlcpy+0x3c>
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	84 c0                	test   %al,%al
  80105a:	75 d8                	jne    801034 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801062:	8b 55 08             	mov    0x8(%ebp),%edx
  801065:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801068:	29 c2                	sub    %eax,%edx
  80106a:	89 d0                	mov    %edx,%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801071:	eb 06                	jmp    801079 <strcmp+0xb>
		p++, q++;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	84 c0                	test   %al,%al
  801080:	74 0e                	je     801090 <strcmp+0x22>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 10                	mov    (%eax),%dl
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	38 c2                	cmp    %al,%dl
  80108e:	74 e3                	je     801073 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f b6 d0             	movzbl %al,%edx
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	0f b6 c0             	movzbl %al,%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
}
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010a9:	eb 09                	jmp    8010b4 <strncmp+0xe>
		n--, p++, q++;
  8010ab:	ff 4d 10             	decl   0x10(%ebp)
  8010ae:	ff 45 08             	incl   0x8(%ebp)
  8010b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b8:	74 17                	je     8010d1 <strncmp+0x2b>
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	84 c0                	test   %al,%al
  8010c1:	74 0e                	je     8010d1 <strncmp+0x2b>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 10                	mov    (%eax),%dl
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	38 c2                	cmp    %al,%dl
  8010cf:	74 da                	je     8010ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d5:	75 07                	jne    8010de <strncmp+0x38>
		return 0;
  8010d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010dc:	eb 14                	jmp    8010f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f b6 d0             	movzbl %al,%edx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	0f b6 c0             	movzbl %al,%eax
  8010ee:	29 c2                	sub    %eax,%edx
  8010f0:	89 d0                	mov    %edx,%eax
}
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 04             	sub    $0x4,%esp
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801100:	eb 12                	jmp    801114 <strchr+0x20>
		if (*s == c)
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80110a:	75 05                	jne    801111 <strchr+0x1d>
			return (char *) s;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	eb 11                	jmp    801122 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	84 c0                	test   %al,%al
  80111b:	75 e5                	jne    801102 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801130:	eb 0d                	jmp    80113f <strfind+0x1b>
		if (*s == c)
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80113a:	74 0e                	je     80114a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80113c:	ff 45 08             	incl   0x8(%ebp)
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	84 c0                	test   %al,%al
  801146:	75 ea                	jne    801132 <strfind+0xe>
  801148:	eb 01                	jmp    80114b <strfind+0x27>
		if (*s == c)
			break;
  80114a:	90                   	nop
	return (char *) s;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80115c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801160:	76 63                	jbe    8011c5 <memset+0x75>
		uint64 data_block = c;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	99                   	cltd   
  801166:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801169:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80116c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801172:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801176:	c1 e0 08             	shl    $0x8,%eax
  801179:	09 45 f0             	or     %eax,-0x10(%ebp)
  80117c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80117f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801185:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801189:	c1 e0 10             	shl    $0x10,%eax
  80118c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80118f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801198:	89 c2                	mov    %eax,%edx
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
  80119f:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011a2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011a5:	eb 18                	jmp    8011bf <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011aa:	8d 41 08             	lea    0x8(%ecx),%eax
  8011ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b6:	89 01                	mov    %eax,(%ecx)
  8011b8:	89 51 04             	mov    %edx,0x4(%ecx)
  8011bb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8011bf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011c3:	77 e2                	ja     8011a7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8011c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c9:	74 23                	je     8011ee <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8011cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011d1:	eb 0e                	jmp    8011e1 <memset+0x91>
			*p8++ = (uint8)c;
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	8d 50 01             	lea    0x1(%eax),%edx
  8011d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011df:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	75 e5                	jne    8011d3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801205:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801209:	76 24                	jbe    80122f <memcpy+0x3c>
		while(n >= 8){
  80120b:	eb 1c                	jmp    801229 <memcpy+0x36>
			*d64 = *s64;
  80120d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801210:	8b 50 04             	mov    0x4(%eax),%edx
  801213:	8b 00                	mov    (%eax),%eax
  801215:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801218:	89 01                	mov    %eax,(%ecx)
  80121a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80121d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801221:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801225:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801229:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80122d:	77 de                	ja     80120d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80122f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801233:	74 31                	je     801266 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801235:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801238:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80123b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801241:	eb 16                	jmp    801259 <memcpy+0x66>
			*d8++ = *s8++;
  801243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80124c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801252:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801255:	8a 12                	mov    (%edx),%dl
  801257:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125f:	89 55 10             	mov    %edx,0x10(%ebp)
  801262:	85 c0                	test   %eax,%eax
  801264:	75 dd                	jne    801243 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80127d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801280:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801283:	73 50                	jae    8012d5 <memmove+0x6a>
  801285:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801290:	76 43                	jbe    8012d5 <memmove+0x6a>
		s += n;
  801292:	8b 45 10             	mov    0x10(%ebp),%eax
  801295:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80129e:	eb 10                	jmp    8012b0 <memmove+0x45>
			*--d = *--s;
  8012a0:	ff 4d f8             	decl   -0x8(%ebp)
  8012a3:	ff 4d fc             	decl   -0x4(%ebp)
  8012a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a9:	8a 10                	mov    (%eax),%dl
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ae:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	75 e3                	jne    8012a0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012bd:	eb 23                	jmp    8012e2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c2:	8d 50 01             	lea    0x1(%eax),%edx
  8012c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d1:	8a 12                	mov    (%edx),%dl
  8012d3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 dd                	jne    8012bf <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012f9:	eb 2a                	jmp    801325 <memcmp+0x3e>
		if (*s1 != *s2)
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	8a 10                	mov    (%eax),%dl
  801300:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	38 c2                	cmp    %al,%dl
  801307:	74 16                	je     80131f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801309:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	0f b6 d0             	movzbl %al,%edx
  801311:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	0f b6 c0             	movzbl %al,%eax
  801319:	29 c2                	sub    %eax,%edx
  80131b:	89 d0                	mov    %edx,%eax
  80131d:	eb 18                	jmp    801337 <memcmp+0x50>
		s1++, s2++;
  80131f:	ff 45 fc             	incl   -0x4(%ebp)
  801322:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132b:	89 55 10             	mov    %edx,0x10(%ebp)
  80132e:	85 c0                	test   %eax,%eax
  801330:	75 c9                	jne    8012fb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80133f:	8b 55 08             	mov    0x8(%ebp),%edx
  801342:	8b 45 10             	mov    0x10(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80134a:	eb 15                	jmp    801361 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	0f b6 c0             	movzbl %al,%eax
  80135a:	39 c2                	cmp    %eax,%edx
  80135c:	74 0d                	je     80136b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80135e:	ff 45 08             	incl   0x8(%ebp)
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801367:	72 e3                	jb     80134c <memfind+0x13>
  801369:	eb 01                	jmp    80136c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80136b:	90                   	nop
	return (void *) s;
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801377:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80137e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801385:	eb 03                	jmp    80138a <strtol+0x19>
		s++;
  801387:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	3c 20                	cmp    $0x20,%al
  801391:	74 f4                	je     801387 <strtol+0x16>
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	3c 09                	cmp    $0x9,%al
  80139a:	74 eb                	je     801387 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	3c 2b                	cmp    $0x2b,%al
  8013a3:	75 05                	jne    8013aa <strtol+0x39>
		s++;
  8013a5:	ff 45 08             	incl   0x8(%ebp)
  8013a8:	eb 13                	jmp    8013bd <strtol+0x4c>
	else if (*s == '-')
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	3c 2d                	cmp    $0x2d,%al
  8013b1:	75 0a                	jne    8013bd <strtol+0x4c>
		s++, neg = 1;
  8013b3:	ff 45 08             	incl   0x8(%ebp)
  8013b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c1:	74 06                	je     8013c9 <strtol+0x58>
  8013c3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013c7:	75 20                	jne    8013e9 <strtol+0x78>
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3c 30                	cmp    $0x30,%al
  8013d0:	75 17                	jne    8013e9 <strtol+0x78>
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	40                   	inc    %eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	3c 78                	cmp    $0x78,%al
  8013da:	75 0d                	jne    8013e9 <strtol+0x78>
		s += 2, base = 16;
  8013dc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013e7:	eb 28                	jmp    801411 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ed:	75 15                	jne    801404 <strtol+0x93>
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	3c 30                	cmp    $0x30,%al
  8013f6:	75 0c                	jne    801404 <strtol+0x93>
		s++, base = 8;
  8013f8:	ff 45 08             	incl   0x8(%ebp)
  8013fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801402:	eb 0d                	jmp    801411 <strtol+0xa0>
	else if (base == 0)
  801404:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801408:	75 07                	jne    801411 <strtol+0xa0>
		base = 10;
  80140a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 2f                	cmp    $0x2f,%al
  801418:	7e 19                	jle    801433 <strtol+0xc2>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 39                	cmp    $0x39,%al
  801421:	7f 10                	jg     801433 <strtol+0xc2>
			dig = *s - '0';
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	0f be c0             	movsbl %al,%eax
  80142b:	83 e8 30             	sub    $0x30,%eax
  80142e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801431:	eb 42                	jmp    801475 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	3c 60                	cmp    $0x60,%al
  80143a:	7e 19                	jle    801455 <strtol+0xe4>
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	3c 7a                	cmp    $0x7a,%al
  801443:	7f 10                	jg     801455 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f be c0             	movsbl %al,%eax
  80144d:	83 e8 57             	sub    $0x57,%eax
  801450:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801453:	eb 20                	jmp    801475 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	3c 40                	cmp    $0x40,%al
  80145c:	7e 39                	jle    801497 <strtol+0x126>
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	3c 5a                	cmp    $0x5a,%al
  801465:	7f 30                	jg     801497 <strtol+0x126>
			dig = *s - 'A' + 10;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	0f be c0             	movsbl %al,%eax
  80146f:	83 e8 37             	sub    $0x37,%eax
  801472:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801478:	3b 45 10             	cmp    0x10(%ebp),%eax
  80147b:	7d 19                	jge    801496 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80147d:	ff 45 08             	incl   0x8(%ebp)
  801480:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801483:	0f af 45 10          	imul   0x10(%ebp),%eax
  801487:	89 c2                	mov    %eax,%edx
  801489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148c:	01 d0                	add    %edx,%eax
  80148e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801491:	e9 7b ff ff ff       	jmp    801411 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801496:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801497:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80149b:	74 08                	je     8014a5 <strtol+0x134>
		*endptr = (char *) s;
  80149d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014a9:	74 07                	je     8014b2 <strtol+0x141>
  8014ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ae:	f7 d8                	neg    %eax
  8014b0:	eb 03                	jmp    8014b5 <strtol+0x144>
  8014b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <ltostr>:

void
ltostr(long value, char *str)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014cf:	79 13                	jns    8014e4 <ltostr+0x2d>
	{
		neg = 1;
  8014d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014de:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014ec:	99                   	cltd   
  8014ed:	f7 f9                	idiv   %ecx
  8014ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014fb:	89 c2                	mov    %eax,%edx
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	01 d0                	add    %edx,%eax
  801502:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801505:	83 c2 30             	add    $0x30,%edx
  801508:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80150a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80150d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801512:	f7 e9                	imul   %ecx
  801514:	c1 fa 02             	sar    $0x2,%edx
  801517:	89 c8                	mov    %ecx,%eax
  801519:	c1 f8 1f             	sar    $0x1f,%eax
  80151c:	29 c2                	sub    %eax,%edx
  80151e:	89 d0                	mov    %edx,%eax
  801520:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801523:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801527:	75 bb                	jne    8014e4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801529:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801533:	48                   	dec    %eax
  801534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801537:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80153b:	74 3d                	je     80157a <ltostr+0xc3>
		start = 1 ;
  80153d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801544:	eb 34                	jmp    80157a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	01 c2                	add    %eax,%edx
  80155b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80155e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801561:	01 c8                	add    %ecx,%eax
  801563:	8a 00                	mov    (%eax),%al
  801565:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801567:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	01 c2                	add    %eax,%edx
  80156f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801572:	88 02                	mov    %al,(%edx)
		start++ ;
  801574:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801577:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80157a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801580:	7c c4                	jl     801546 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801582:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	01 d0                	add    %edx,%eax
  80158a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80158d:	90                   	nop
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	e8 c4 f9 ff ff       	call   800f62 <strlen>
  80159e:	83 c4 04             	add    $0x4,%esp
  8015a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015a4:	ff 75 0c             	pushl  0xc(%ebp)
  8015a7:	e8 b6 f9 ff ff       	call   800f62 <strlen>
  8015ac:	83 c4 04             	add    $0x4,%esp
  8015af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c0:	eb 17                	jmp    8015d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	01 c2                	add    %eax,%edx
  8015ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	01 c8                	add    %ecx,%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015d6:	ff 45 fc             	incl   -0x4(%ebp)
  8015d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015df:	7c e1                	jl     8015c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015ef:	eb 1f                	jmp    801610 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f4:	8d 50 01             	lea    0x1(%eax),%edx
  8015f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015fa:	89 c2                	mov    %eax,%edx
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	01 c2                	add    %eax,%edx
  801601:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	01 c8                	add    %ecx,%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80160d:	ff 45 f8             	incl   -0x8(%ebp)
  801610:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801613:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801616:	7c d9                	jl     8015f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801618:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161b:	8b 45 10             	mov    0x10(%ebp),%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	c6 00 00             	movb   $0x0,(%eax)
}
  801623:	90                   	nop
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801632:	8b 45 14             	mov    0x14(%ebp),%eax
  801635:	8b 00                	mov    (%eax),%eax
  801637:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801649:	eb 0c                	jmp    801657 <strsplit+0x31>
			*string++ = 0;
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8d 50 01             	lea    0x1(%eax),%edx
  801651:	89 55 08             	mov    %edx,0x8(%ebp)
  801654:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	84 c0                	test   %al,%al
  80165e:	74 18                	je     801678 <strsplit+0x52>
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	0f be c0             	movsbl %al,%eax
  801668:	50                   	push   %eax
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	e8 83 fa ff ff       	call   8010f4 <strchr>
  801671:	83 c4 08             	add    $0x8,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	75 d3                	jne    80164b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	8a 00                	mov    (%eax),%al
  80167d:	84 c0                	test   %al,%al
  80167f:	74 5a                	je     8016db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801681:	8b 45 14             	mov    0x14(%ebp),%eax
  801684:	8b 00                	mov    (%eax),%eax
  801686:	83 f8 0f             	cmp    $0xf,%eax
  801689:	75 07                	jne    801692 <strsplit+0x6c>
		{
			return 0;
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
  801690:	eb 66                	jmp    8016f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801692:	8b 45 14             	mov    0x14(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 14             	mov    0x14(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	01 c2                	add    %eax,%edx
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b0:	eb 03                	jmp    8016b5 <strsplit+0x8f>
			string++;
  8016b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	84 c0                	test   %al,%al
  8016bc:	74 8b                	je     801649 <strsplit+0x23>
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	0f be c0             	movsbl %al,%eax
  8016c6:	50                   	push   %eax
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	e8 25 fa ff ff       	call   8010f4 <strchr>
  8016cf:	83 c4 08             	add    $0x8,%esp
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	74 dc                	je     8016b2 <strsplit+0x8c>
			string++;
	}
  8016d6:	e9 6e ff ff ff       	jmp    801649 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016df:	8b 00                	mov    (%eax),%eax
  8016e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016eb:	01 d0                	add    %edx,%eax
  8016ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801706:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80170d:	eb 4a                	jmp    801759 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80170f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	01 c2                	add    %eax,%edx
  801717:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	01 c8                	add    %ecx,%eax
  80171f:	8a 00                	mov    (%eax),%al
  801721:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801723:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801726:	8b 45 0c             	mov    0xc(%ebp),%eax
  801729:	01 d0                	add    %edx,%eax
  80172b:	8a 00                	mov    (%eax),%al
  80172d:	3c 40                	cmp    $0x40,%al
  80172f:	7e 25                	jle    801756 <str2lower+0x5c>
  801731:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801734:	8b 45 0c             	mov    0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	3c 5a                	cmp    $0x5a,%al
  80173d:	7f 17                	jg     801756 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80173f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80174a:	8b 55 08             	mov    0x8(%ebp),%edx
  80174d:	01 ca                	add    %ecx,%edx
  80174f:	8a 12                	mov    (%edx),%dl
  801751:	83 c2 20             	add    $0x20,%edx
  801754:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801756:	ff 45 fc             	incl   -0x4(%ebp)
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	e8 01 f8 ff ff       	call   800f62 <strlen>
  801761:	83 c4 04             	add    $0x4,%esp
  801764:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801767:	7f a6                	jg     80170f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801769:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801774:	a1 08 50 80 00       	mov    0x805008,%eax
  801779:	85 c0                	test   %eax,%eax
  80177b:	74 42                	je     8017bf <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80177d:	83 ec 08             	sub    $0x8,%esp
  801780:	68 00 00 00 82       	push   $0x82000000
  801785:	68 00 00 00 80       	push   $0x80000000
  80178a:	e8 b0 1e 00 00       	call   80363f <initialize_dynamic_allocator>
  80178f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801792:	e8 96 1c 00 00       	call   80342d <sys_get_uheap_strategy>
  801797:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80179c:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8017a1:	05 00 10 00 00       	add    $0x1000,%eax
  8017a6:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8017ab:	a1 30 51 83 00       	mov    0x835130,%eax
  8017b0:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8017b5:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8017bc:	00 00 00 
	}
}
  8017bf:	90                   	nop
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	68 06 04 00 00       	push   $0x406
  8017de:	50                   	push   %eax
  8017df:	e8 93 18 00 00       	call   803077 <__sys_allocate_page>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ee:	79 14                	jns    801804 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 88 4c 80 00       	push   $0x804c88
  8017f8:	6a 1f                	push   $0x1f
  8017fa:	68 c4 4c 80 00       	push   $0x804cc4
  8017ff:	e8 b7 ed ff ff       	call   8005bb <_panic>
	return 0;
  801804:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	50                   	push   %eax
  801823:	e8 96 18 00 00       	call   8030be <__sys_unmap_frame>
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80182e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801832:	79 14                	jns    801848 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 d0 4c 80 00       	push   $0x804cd0
  80183c:	6a 2a                	push   $0x2a
  80183e:	68 c4 4c 80 00       	push   $0x804cc4
  801843:	e8 73 ed ff ff       	call   8005bb <_panic>
}
  801848:	90                   	nop
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801851:	e8 18 ff ff ff       	call   80176e <uheap_init>
	if (size == 0) return NULL ;
  801856:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80185a:	75 0a                	jne    801866 <malloc+0x1b>
  80185c:	b8 00 00 00 00       	mov    $0x0,%eax
  801861:	e9 43 03 00 00       	jmp    801ba9 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801866:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80186d:	77 13                	ja     801882 <malloc+0x37>
    {
        return alloc_block(size);
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	e8 78 20 00 00       	call   8038f2 <alloc_block>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	e9 27 03 00 00       	jmp    801ba9 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801882:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801889:	8b 55 08             	mov    0x8(%ebp),%edx
  80188c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80188f:	01 d0                	add    %edx,%eax
  801891:	48                   	dec    %eax
  801892:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801895:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801898:	ba 00 00 00 00       	mov    $0x0,%edx
  80189d:	f7 75 dc             	divl   -0x24(%ebp)
  8018a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018a3:	29 d0                	sub    %edx,%eax
  8018a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8018a8:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 0a                	jne    8018bb <malloc+0x70>
    {
        uhp_inited = 1;
  8018b1:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8018b8:	00 00 00 
    }

    int exactIdx = -1;
  8018bb:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8018c2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8018c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8018d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018d7:	e9 85 00 00 00       	jmp    801961 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8018dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018df:	89 d0                	mov    %edx,%eax
  8018e1:	01 c0                	add    %eax,%eax
  8018e3:	01 d0                	add    %edx,%eax
  8018e5:	c1 e0 02             	shl    $0x2,%eax
  8018e8:	05 48 10 81 00       	add    $0x811048,%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	84 c0                	test   %al,%al
  8018f1:	74 20                	je     801913 <malloc+0xc8>
  8018f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018f6:	89 d0                	mov    %edx,%eax
  8018f8:	01 c0                	add    %eax,%eax
  8018fa:	01 d0                	add    %edx,%eax
  8018fc:	c1 e0 02             	shl    $0x2,%eax
  8018ff:	05 44 10 81 00       	add    $0x811044,%eax
  801904:	8b 00                	mov    (%eax),%eax
  801906:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801909:	75 08                	jne    801913 <malloc+0xc8>
        {
            exactIdx = i;
  80190b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801911:	eb 5b                	jmp    80196e <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801913:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801916:	89 d0                	mov    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	01 d0                	add    %edx,%eax
  80191c:	c1 e0 02             	shl    $0x2,%eax
  80191f:	05 48 10 81 00       	add    $0x811048,%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	84 c0                	test   %al,%al
  801928:	74 34                	je     80195e <malloc+0x113>
  80192a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80192d:	89 d0                	mov    %edx,%eax
  80192f:	01 c0                	add    %eax,%eax
  801931:	01 d0                	add    %edx,%eax
  801933:	c1 e0 02             	shl    $0x2,%eax
  801936:	05 44 10 81 00       	add    $0x811044,%eax
  80193b:	8b 00                	mov    (%eax),%eax
  80193d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801940:	76 1c                	jbe    80195e <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801942:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801945:	89 d0                	mov    %edx,%eax
  801947:	01 c0                	add    %eax,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	c1 e0 02             	shl    $0x2,%eax
  80194e:	05 44 10 81 00       	add    $0x811044,%eax
  801953:	8b 00                	mov    (%eax),%eax
  801955:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80195e:	ff 45 e8             	incl   -0x18(%ebp)
  801961:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801968:	0f 8e 6e ff ff ff    	jle    8018dc <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  80196e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801975:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801979:	74 7d                	je     8019f8 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80197b:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801985:	89 d0                	mov    %edx,%eax
  801987:	01 c0                	add    %eax,%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c1 e0 02             	shl    $0x2,%eax
  80198e:	05 40 10 81 00       	add    $0x811040,%eax
  801993:	8b 10                	mov    (%eax),%edx
  801995:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801998:	01 d0                	add    %edx,%eax
  80199a:	48                   	dec    %eax
  80199b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80199e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a6:	f7 75 bc             	divl   -0x44(%ebp)
  8019a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019ac:	29 d0                	sub    %edx,%eax
  8019ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8019b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	01 c0                	add    %eax,%eax
  8019b8:	01 d0                	add    %edx,%eax
  8019ba:	c1 e0 02             	shl    $0x2,%eax
  8019bd:	05 48 10 81 00       	add    $0x811048,%eax
  8019c2:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8019c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c8:	89 d0                	mov    %edx,%eax
  8019ca:	01 c0                	add    %eax,%eax
  8019cc:	01 d0                	add    %edx,%eax
  8019ce:	c1 e0 02             	shl    $0x2,%eax
  8019d1:	05 44 10 81 00       	add    $0x811044,%eax
  8019d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8019dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019df:	89 d0                	mov    %edx,%eax
  8019e1:	01 c0                	add    %eax,%eax
  8019e3:	01 d0                	add    %edx,%eax
  8019e5:	c1 e0 02             	shl    $0x2,%eax
  8019e8:	05 40 10 81 00       	add    $0x811040,%eax
  8019ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019f3:	e9 2d 01 00 00       	jmp    801b25 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8019f8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019fc:	0f 84 ce 00 00 00    	je     801ad0 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801a02:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801a09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0c:	89 d0                	mov    %edx,%eax
  801a0e:	01 c0                	add    %eax,%eax
  801a10:	01 d0                	add    %edx,%eax
  801a12:	c1 e0 02             	shl    $0x2,%eax
  801a15:	05 40 10 81 00       	add    $0x811040,%eax
  801a1a:	8b 10                	mov    (%eax),%edx
  801a1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a1f:	01 d0                	add    %edx,%eax
  801a21:	48                   	dec    %eax
  801a22:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801a25:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a28:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2d:	f7 75 c4             	divl   -0x3c(%ebp)
  801a30:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a33:	29 d0                	sub    %edx,%eax
  801a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a3b:	89 d0                	mov    %edx,%eax
  801a3d:	01 c0                	add    %eax,%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	c1 e0 02             	shl    $0x2,%eax
  801a44:	05 44 10 81 00       	add    $0x811044,%eax
  801a49:	8b 00                	mov    (%eax),%eax
  801a4b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a4e:	75 47                	jne    801a97 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801a50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a53:	89 d0                	mov    %edx,%eax
  801a55:	01 c0                	add    %eax,%eax
  801a57:	01 d0                	add    %edx,%eax
  801a59:	c1 e0 02             	shl    $0x2,%eax
  801a5c:	05 48 10 81 00       	add    $0x811048,%eax
  801a61:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801a64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a67:	89 d0                	mov    %edx,%eax
  801a69:	01 c0                	add    %eax,%eax
  801a6b:	01 d0                	add    %edx,%eax
  801a6d:	c1 e0 02             	shl    $0x2,%eax
  801a70:	05 44 10 81 00       	add    $0x811044,%eax
  801a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a7e:	89 d0                	mov    %edx,%eax
  801a80:	01 c0                	add    %eax,%eax
  801a82:	01 d0                	add    %edx,%eax
  801a84:	c1 e0 02             	shl    $0x2,%eax
  801a87:	05 40 10 81 00       	add    $0x811040,%eax
  801a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a92:	e9 8e 00 00 00       	jmp    801b25 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801a97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a9d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801aa0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa3:	89 d0                	mov    %edx,%eax
  801aa5:	01 c0                	add    %eax,%eax
  801aa7:	01 d0                	add    %edx,%eax
  801aa9:	c1 e0 02             	shl    $0x2,%eax
  801aac:	05 40 10 81 00       	add    $0x811040,%eax
  801ab1:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab6:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ab9:	89 c2                	mov    %eax,%edx
  801abb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801abe:	89 c8                	mov    %ecx,%eax
  801ac0:	01 c0                	add    %eax,%eax
  801ac2:	01 c8                	add    %ecx,%eax
  801ac4:	c1 e0 02             	shl    $0x2,%eax
  801ac7:	05 44 10 81 00       	add    $0x811044,%eax
  801acc:	89 10                	mov    %edx,(%eax)
  801ace:	eb 55                	jmp    801b25 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801ad0:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801ad7:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801add:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ae0:	01 d0                	add    %edx,%eax
  801ae2:	48                   	dec    %eax
  801ae3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ae6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  801aee:	f7 75 d0             	divl   -0x30(%ebp)
  801af1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801af4:	29 d0                	sub    %edx,%eax
  801af6:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801af9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801afc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801aff:	01 d0                	add    %edx,%eax
  801b01:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801b06:	76 0a                	jbe    801b12 <malloc+0x2c7>
            return NULL;
  801b08:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0d:	e9 97 00 00 00       	jmp    801ba9 <malloc+0x35e>
        va = start;
  801b12:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801b18:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b1e:	01 d0                	add    %edx,%eax
  801b20:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b2c:	eb 5e                	jmp    801b8c <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801b2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b31:	89 d0                	mov    %edx,%eax
  801b33:	01 c0                	add    %eax,%eax
  801b35:	01 d0                	add    %edx,%eax
  801b37:	c1 e0 02             	shl    $0x2,%eax
  801b3a:	05 48 50 80 00       	add    $0x805048,%eax
  801b3f:	8a 00                	mov    (%eax),%al
  801b41:	84 c0                	test   %al,%al
  801b43:	75 44                	jne    801b89 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801b45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b48:	89 d0                	mov    %edx,%eax
  801b4a:	01 c0                	add    %eax,%eax
  801b4c:	01 d0                	add    %edx,%eax
  801b4e:	c1 e0 02             	shl    $0x2,%eax
  801b51:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801b5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b5f:	89 d0                	mov    %edx,%eax
  801b61:	01 c0                	add    %eax,%eax
  801b63:	01 d0                	add    %edx,%eax
  801b65:	c1 e0 02             	shl    $0x2,%eax
  801b68:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801b6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b71:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801b73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b76:	89 d0                	mov    %edx,%eax
  801b78:	01 c0                	add    %eax,%eax
  801b7a:	01 d0                	add    %edx,%eax
  801b7c:	c1 e0 02             	shl    $0x2,%eax
  801b7f:	05 48 50 80 00       	add    $0x805048,%eax
  801b84:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801b87:	eb 0c                	jmp    801b95 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b89:	ff 45 e0             	incl   -0x20(%ebp)
  801b8c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801b93:	7e 99                	jle    801b2e <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	ff 75 d4             	pushl  -0x2c(%ebp)
  801b9b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b9e:	e8 a2 19 00 00       	call   803545 <sys_allocate_user_mem>
  801ba3:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801bb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bb5:	0f 84 fa 03 00 00    	je     801fb5 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801bc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	79 1c                	jns    801be4 <free+0x39>
  801bc8:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801bcf:	77 13                	ja     801be4 <free+0x39>
    {
        free_block(virtual_address);
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	e8 09 21 00 00       	call   803ce5 <free_block>
  801bdc:	83 c4 10             	add    $0x10,%esp
        return;
  801bdf:	e9 d2 03 00 00       	jmp    801fb6 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801be4:	a1 30 51 83 00       	mov    0x835130,%eax
  801be9:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801bec:	72 09                	jb     801bf7 <free+0x4c>
  801bee:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801bf5:	76 17                	jbe    801c0e <free+0x63>
        panic("free: invalid address");
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	68 0d 4d 80 00       	push   $0x804d0d
  801bff:	68 9b 00 00 00       	push   $0x9b
  801c04:	68 c4 4c 80 00       	push   $0x804cc4
  801c09:	e8 ad e9 ff ff       	call   8005bb <_panic>

    uint32 size = 0;
  801c0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801c15:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801c23:	eb 50                	jmp    801c75 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801c25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c28:	89 d0                	mov    %edx,%eax
  801c2a:	01 c0                	add    %eax,%eax
  801c2c:	01 d0                	add    %edx,%eax
  801c2e:	c1 e0 02             	shl    $0x2,%eax
  801c31:	05 48 50 80 00       	add    $0x805048,%eax
  801c36:	8a 00                	mov    (%eax),%al
  801c38:	84 c0                	test   %al,%al
  801c3a:	74 36                	je     801c72 <free+0xc7>
  801c3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c3f:	89 d0                	mov    %edx,%eax
  801c41:	01 c0                	add    %eax,%eax
  801c43:	01 d0                	add    %edx,%eax
  801c45:	c1 e0 02             	shl    $0x2,%eax
  801c48:	05 40 50 80 00       	add    $0x805040,%eax
  801c4d:	8b 00                	mov    (%eax),%eax
  801c4f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c52:	75 1e                	jne    801c72 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801c54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c57:	89 d0                	mov    %edx,%eax
  801c59:	01 c0                	add    %eax,%eax
  801c5b:	01 d0                	add    %edx,%eax
  801c5d:	c1 e0 02             	shl    $0x2,%eax
  801c60:	05 44 50 80 00       	add    $0x805044,%eax
  801c65:	8b 00                	mov    (%eax),%eax
  801c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801c70:	eb 0c                	jmp    801c7e <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c72:	ff 45 ec             	incl   -0x14(%ebp)
  801c75:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801c7c:	7e a7                	jle    801c25 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801c7e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c82:	74 06                	je     801c8a <free+0xdf>
  801c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c88:	75 17                	jne    801ca1 <free+0xf6>
        panic("free: unknown block");
  801c8a:	83 ec 04             	sub    $0x4,%esp
  801c8d:	68 23 4d 80 00       	push   $0x804d23
  801c92:	68 a9 00 00 00       	push   $0xa9
  801c97:	68 c4 4c 80 00       	push   $0x804cc4
  801c9c:	e8 1a e9 ff ff       	call   8005bb <_panic>

    uhp_allocs[idx].used = 0;
  801ca1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca4:	89 d0                	mov    %edx,%eax
  801ca6:	01 c0                	add    %eax,%eax
  801ca8:	01 d0                	add    %edx,%eax
  801caa:	c1 e0 02             	shl    $0x2,%eax
  801cad:	05 48 50 80 00       	add    $0x805048,%eax
  801cb2:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801cb5:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cbc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801cc3:	eb 64                	jmp    801d29 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801cc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cc8:	89 d0                	mov    %edx,%eax
  801cca:	01 c0                	add    %eax,%eax
  801ccc:	01 d0                	add    %edx,%eax
  801cce:	c1 e0 02             	shl    $0x2,%eax
  801cd1:	05 48 10 81 00       	add    $0x811048,%eax
  801cd6:	8a 00                	mov    (%eax),%al
  801cd8:	84 c0                	test   %al,%al
  801cda:	75 4a                	jne    801d26 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801cdc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cdf:	89 d0                	mov    %edx,%eax
  801ce1:	01 c0                	add    %eax,%eax
  801ce3:	01 d0                	add    %edx,%eax
  801ce5:	c1 e0 02             	shl    $0x2,%eax
  801ce8:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801cee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cf1:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801cf3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cf6:	89 d0                	mov    %edx,%eax
  801cf8:	01 c0                	add    %eax,%eax
  801cfa:	01 d0                	add    %edx,%eax
  801cfc:	c1 e0 02             	shl    $0x2,%eax
  801cff:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d08:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d0d:	89 d0                	mov    %edx,%eax
  801d0f:	01 c0                	add    %eax,%eax
  801d11:	01 d0                	add    %edx,%eax
  801d13:	c1 e0 02             	shl    $0x2,%eax
  801d16:	05 48 10 81 00       	add    $0x811048,%eax
  801d1b:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d21:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801d24:	eb 0c                	jmp    801d32 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d26:	ff 45 e4             	incl   -0x1c(%ebp)
  801d29:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801d30:	7e 93                	jle    801cc5 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801d32:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801d36:	0f 84 f1 01 00 00    	je     801f2d <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d43:	e9 d8 01 00 00       	jmp    801f20 <free+0x375>
        {
            if (i == fidx) continue;
  801d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d4e:	0f 84 c8 01 00 00    	je     801f1c <free+0x371>
            if (uhp_frees[i].free)
  801d54:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d57:	89 d0                	mov    %edx,%eax
  801d59:	01 c0                	add    %eax,%eax
  801d5b:	01 d0                	add    %edx,%eax
  801d5d:	c1 e0 02             	shl    $0x2,%eax
  801d60:	05 48 10 81 00       	add    $0x811048,%eax
  801d65:	8a 00                	mov    (%eax),%al
  801d67:	84 c0                	test   %al,%al
  801d69:	0f 84 ae 01 00 00    	je     801f1d <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d72:	89 d0                	mov    %edx,%eax
  801d74:	01 c0                	add    %eax,%eax
  801d76:	01 d0                	add    %edx,%eax
  801d78:	c1 e0 02             	shl    $0x2,%eax
  801d7b:	05 40 10 81 00       	add    $0x811040,%eax
  801d80:	8b 08                	mov    (%eax),%ecx
  801d82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d85:	89 d0                	mov    %edx,%eax
  801d87:	01 c0                	add    %eax,%eax
  801d89:	01 d0                	add    %edx,%eax
  801d8b:	c1 e0 02             	shl    $0x2,%eax
  801d8e:	05 44 10 81 00       	add    $0x811044,%eax
  801d93:	8b 00                	mov    (%eax),%eax
  801d95:	01 c1                	add    %eax,%ecx
  801d97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d9a:	89 d0                	mov    %edx,%eax
  801d9c:	01 c0                	add    %eax,%eax
  801d9e:	01 d0                	add    %edx,%eax
  801da0:	c1 e0 02             	shl    $0x2,%eax
  801da3:	05 40 10 81 00       	add    $0x811040,%eax
  801da8:	8b 00                	mov    (%eax),%eax
  801daa:	39 c1                	cmp    %eax,%ecx
  801dac:	0f 85 a8 00 00 00    	jne    801e5a <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801db2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db5:	89 d0                	mov    %edx,%eax
  801db7:	01 c0                	add    %eax,%eax
  801db9:	01 d0                	add    %edx,%eax
  801dbb:	c1 e0 02             	shl    $0x2,%eax
  801dbe:	05 40 10 81 00       	add    $0x811040,%eax
  801dc3:	8b 10                	mov    (%eax),%edx
  801dc5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801dc8:	89 c8                	mov    %ecx,%eax
  801dca:	01 c0                	add    %eax,%eax
  801dcc:	01 c8                	add    %ecx,%eax
  801dce:	c1 e0 02             	shl    $0x2,%eax
  801dd1:	05 40 10 81 00       	add    $0x811040,%eax
  801dd6:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801dd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ddb:	89 d0                	mov    %edx,%eax
  801ddd:	01 c0                	add    %eax,%eax
  801ddf:	01 d0                	add    %edx,%eax
  801de1:	c1 e0 02             	shl    $0x2,%eax
  801de4:	05 44 10 81 00       	add    $0x811044,%eax
  801de9:	8b 08                	mov    (%eax),%ecx
  801deb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dee:	89 d0                	mov    %edx,%eax
  801df0:	01 c0                	add    %eax,%eax
  801df2:	01 d0                	add    %edx,%eax
  801df4:	c1 e0 02             	shl    $0x2,%eax
  801df7:	05 44 10 81 00       	add    $0x811044,%eax
  801dfc:	8b 00                	mov    (%eax),%eax
  801dfe:	01 c1                	add    %eax,%ecx
  801e00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e03:	89 d0                	mov    %edx,%eax
  801e05:	01 c0                	add    %eax,%eax
  801e07:	01 d0                	add    %edx,%eax
  801e09:	c1 e0 02             	shl    $0x2,%eax
  801e0c:	05 44 10 81 00       	add    $0x811044,%eax
  801e11:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801e13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e16:	89 d0                	mov    %edx,%eax
  801e18:	01 c0                	add    %eax,%eax
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	c1 e0 02             	shl    $0x2,%eax
  801e1f:	05 48 10 81 00       	add    $0x811048,%eax
  801e24:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801e27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e2a:	89 d0                	mov    %edx,%eax
  801e2c:	01 c0                	add    %eax,%eax
  801e2e:	01 d0                	add    %edx,%eax
  801e30:	c1 e0 02             	shl    $0x2,%eax
  801e33:	05 40 10 81 00       	add    $0x811040,%eax
  801e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801e3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e41:	89 d0                	mov    %edx,%eax
  801e43:	01 c0                	add    %eax,%eax
  801e45:	01 d0                	add    %edx,%eax
  801e47:	c1 e0 02             	shl    $0x2,%eax
  801e4a:	05 44 10 81 00       	add    $0x811044,%eax
  801e4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e55:	e9 c3 00 00 00       	jmp    801f1d <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801e5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	01 c0                	add    %eax,%eax
  801e61:	01 d0                	add    %edx,%eax
  801e63:	c1 e0 02             	shl    $0x2,%eax
  801e66:	05 40 10 81 00       	add    $0x811040,%eax
  801e6b:	8b 08                	mov    (%eax),%ecx
  801e6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e70:	89 d0                	mov    %edx,%eax
  801e72:	01 c0                	add    %eax,%eax
  801e74:	01 d0                	add    %edx,%eax
  801e76:	c1 e0 02             	shl    $0x2,%eax
  801e79:	05 44 10 81 00       	add    $0x811044,%eax
  801e7e:	8b 00                	mov    (%eax),%eax
  801e80:	01 c1                	add    %eax,%ecx
  801e82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e85:	89 d0                	mov    %edx,%eax
  801e87:	01 c0                	add    %eax,%eax
  801e89:	01 d0                	add    %edx,%eax
  801e8b:	c1 e0 02             	shl    $0x2,%eax
  801e8e:	05 40 10 81 00       	add    $0x811040,%eax
  801e93:	8b 00                	mov    (%eax),%eax
  801e95:	39 c1                	cmp    %eax,%ecx
  801e97:	0f 85 80 00 00 00    	jne    801f1d <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801e9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ea0:	89 d0                	mov    %edx,%eax
  801ea2:	01 c0                	add    %eax,%eax
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	c1 e0 02             	shl    $0x2,%eax
  801ea9:	05 44 10 81 00       	add    $0x811044,%eax
  801eae:	8b 08                	mov    (%eax),%ecx
  801eb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb3:	89 d0                	mov    %edx,%eax
  801eb5:	01 c0                	add    %eax,%eax
  801eb7:	01 d0                	add    %edx,%eax
  801eb9:	c1 e0 02             	shl    $0x2,%eax
  801ebc:	05 44 10 81 00       	add    $0x811044,%eax
  801ec1:	8b 00                	mov    (%eax),%eax
  801ec3:	01 c1                	add    %eax,%ecx
  801ec5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ec8:	89 d0                	mov    %edx,%eax
  801eca:	01 c0                	add    %eax,%eax
  801ecc:	01 d0                	add    %edx,%eax
  801ece:	c1 e0 02             	shl    $0x2,%eax
  801ed1:	05 44 10 81 00       	add    $0x811044,%eax
  801ed6:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801ed8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	01 c0                	add    %eax,%eax
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	c1 e0 02             	shl    $0x2,%eax
  801ee4:	05 48 10 81 00       	add    $0x811048,%eax
  801ee9:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801eec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	01 c0                	add    %eax,%eax
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	c1 e0 02             	shl    $0x2,%eax
  801ef8:	05 40 10 81 00       	add    $0x811040,%eax
  801efd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801f03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	01 c0                	add    %eax,%eax
  801f0a:	01 d0                	add    %edx,%eax
  801f0c:	c1 e0 02             	shl    $0x2,%eax
  801f0f:	05 44 10 81 00       	add    $0x811044,%eax
  801f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f1a:	eb 01                	jmp    801f1d <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801f1c:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f1d:	ff 45 e0             	incl   -0x20(%ebp)
  801f20:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f27:	0f 8e 1b fe ff ff    	jle    801d48 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801f2d:	a1 30 51 83 00       	mov    0x835130,%eax
  801f32:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f35:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801f3c:	eb 53                	jmp    801f91 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801f3e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f41:	89 d0                	mov    %edx,%eax
  801f43:	01 c0                	add    %eax,%eax
  801f45:	01 d0                	add    %edx,%eax
  801f47:	c1 e0 02             	shl    $0x2,%eax
  801f4a:	05 48 50 80 00       	add    $0x805048,%eax
  801f4f:	8a 00                	mov    (%eax),%al
  801f51:	84 c0                	test   %al,%al
  801f53:	74 39                	je     801f8e <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801f55:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f58:	89 d0                	mov    %edx,%eax
  801f5a:	01 c0                	add    %eax,%eax
  801f5c:	01 d0                	add    %edx,%eax
  801f5e:	c1 e0 02             	shl    $0x2,%eax
  801f61:	05 40 50 80 00       	add    $0x805040,%eax
  801f66:	8b 08                	mov    (%eax),%ecx
  801f68:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f6b:	89 d0                	mov    %edx,%eax
  801f6d:	01 c0                	add    %eax,%eax
  801f6f:	01 d0                	add    %edx,%eax
  801f71:	c1 e0 02             	shl    $0x2,%eax
  801f74:	05 44 50 80 00       	add    $0x805044,%eax
  801f79:	8b 00                	mov    (%eax),%eax
  801f7b:	01 c8                	add    %ecx,%eax
  801f7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801f80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f83:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f86:	76 06                	jbe    801f8e <free+0x3e3>
  801f88:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f8e:	ff 45 d8             	incl   -0x28(%ebp)
  801f91:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801f98:	7e a4                	jle    801f3e <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f9d:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801fa2:	83 ec 08             	sub    $0x8,%esp
  801fa5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa8:	ff 75 d4             	pushl  -0x2c(%ebp)
  801fab:	e8 79 15 00 00       	call   803529 <sys_free_user_mem>
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	eb 01                	jmp    801fb6 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801fb5:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 68             	sub    $0x68,%esp
  801fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc1:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fc4:	e8 a5 f7 ff ff       	call   80176e <uheap_init>
	if (size == 0) return NULL ;
  801fc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fcd:	75 0a                	jne    801fd9 <smalloc+0x21>
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	e9 37 03 00 00       	jmp    802310 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801fd9:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fe6:	01 d0                	add    %edx,%eax
  801fe8:	48                   	dec    %eax
  801fe9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fef:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff4:	f7 75 dc             	divl   -0x24(%ebp)
  801ff7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ffa:	29 d0                	sub    %edx,%eax
  801ffc:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801fff:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802006:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80200d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802014:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80201b:	e9 85 00 00 00       	jmp    8020a5 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802020:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802023:	89 d0                	mov    %edx,%eax
  802025:	01 c0                	add    %eax,%eax
  802027:	01 d0                	add    %edx,%eax
  802029:	c1 e0 02             	shl    $0x2,%eax
  80202c:	05 48 10 81 00       	add    $0x811048,%eax
  802031:	8a 00                	mov    (%eax),%al
  802033:	84 c0                	test   %al,%al
  802035:	74 20                	je     802057 <smalloc+0x9f>
  802037:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80203a:	89 d0                	mov    %edx,%eax
  80203c:	01 c0                	add    %eax,%eax
  80203e:	01 d0                	add    %edx,%eax
  802040:	c1 e0 02             	shl    $0x2,%eax
  802043:	05 44 10 81 00       	add    $0x811044,%eax
  802048:	8b 00                	mov    (%eax),%eax
  80204a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80204d:	75 08                	jne    802057 <smalloc+0x9f>
        {
            exactIdx = i;
  80204f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802052:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802055:	eb 5b                	jmp    8020b2 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802057:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80205a:	89 d0                	mov    %edx,%eax
  80205c:	01 c0                	add    %eax,%eax
  80205e:	01 d0                	add    %edx,%eax
  802060:	c1 e0 02             	shl    $0x2,%eax
  802063:	05 48 10 81 00       	add    $0x811048,%eax
  802068:	8a 00                	mov    (%eax),%al
  80206a:	84 c0                	test   %al,%al
  80206c:	74 34                	je     8020a2 <smalloc+0xea>
  80206e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802071:	89 d0                	mov    %edx,%eax
  802073:	01 c0                	add    %eax,%eax
  802075:	01 d0                	add    %edx,%eax
  802077:	c1 e0 02             	shl    $0x2,%eax
  80207a:	05 44 10 81 00       	add    $0x811044,%eax
  80207f:	8b 00                	mov    (%eax),%eax
  802081:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802084:	76 1c                	jbe    8020a2 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802086:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802089:	89 d0                	mov    %edx,%eax
  80208b:	01 c0                	add    %eax,%eax
  80208d:	01 d0                	add    %edx,%eax
  80208f:	c1 e0 02             	shl    $0x2,%eax
  802092:	05 44 10 81 00       	add    $0x811044,%eax
  802097:	8b 00                	mov    (%eax),%eax
  802099:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80209c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80209f:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020a2:	ff 45 e8             	incl   -0x18(%ebp)
  8020a5:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8020ac:	0f 8e 6e ff ff ff    	jle    802020 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8020b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8020b9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8020bd:	74 7d                	je     80213c <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8020bf:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8020c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	01 c0                	add    %eax,%eax
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	c1 e0 02             	shl    $0x2,%eax
  8020d2:	05 40 10 81 00       	add    $0x811040,%eax
  8020d7:	8b 10                	mov    (%eax),%edx
  8020d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020dc:	01 d0                	add    %edx,%eax
  8020de:	48                   	dec    %eax
  8020df:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8020e2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ea:	f7 75 bc             	divl   -0x44(%ebp)
  8020ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020f0:	29 d0                	sub    %edx,%eax
  8020f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8020f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f8:	89 d0                	mov    %edx,%eax
  8020fa:	01 c0                	add    %eax,%eax
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	c1 e0 02             	shl    $0x2,%eax
  802101:	05 48 10 81 00       	add    $0x811048,%eax
  802106:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210c:	89 d0                	mov    %edx,%eax
  80210e:	01 c0                	add    %eax,%eax
  802110:	01 d0                	add    %edx,%eax
  802112:	c1 e0 02             	shl    $0x2,%eax
  802115:	05 44 10 81 00       	add    $0x811044,%eax
  80211a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802120:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802123:	89 d0                	mov    %edx,%eax
  802125:	01 c0                	add    %eax,%eax
  802127:	01 d0                	add    %edx,%eax
  802129:	c1 e0 02             	shl    $0x2,%eax
  80212c:	05 40 10 81 00       	add    $0x811040,%eax
  802131:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802137:	e9 2d 01 00 00       	jmp    802269 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  80213c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802140:	0f 84 ce 00 00 00    	je     802214 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802146:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80214d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802150:	89 d0                	mov    %edx,%eax
  802152:	01 c0                	add    %eax,%eax
  802154:	01 d0                	add    %edx,%eax
  802156:	c1 e0 02             	shl    $0x2,%eax
  802159:	05 40 10 81 00       	add    $0x811040,%eax
  80215e:	8b 10                	mov    (%eax),%edx
  802160:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802163:	01 d0                	add    %edx,%eax
  802165:	48                   	dec    %eax
  802166:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802169:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80216c:	ba 00 00 00 00       	mov    $0x0,%edx
  802171:	f7 75 c4             	divl   -0x3c(%ebp)
  802174:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802177:	29 d0                	sub    %edx,%eax
  802179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80217c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80217f:	89 d0                	mov    %edx,%eax
  802181:	01 c0                	add    %eax,%eax
  802183:	01 d0                	add    %edx,%eax
  802185:	c1 e0 02             	shl    $0x2,%eax
  802188:	05 44 10 81 00       	add    $0x811044,%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802192:	75 47                	jne    8021db <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802197:	89 d0                	mov    %edx,%eax
  802199:	01 c0                	add    %eax,%eax
  80219b:	01 d0                	add    %edx,%eax
  80219d:	c1 e0 02             	shl    $0x2,%eax
  8021a0:	05 48 10 81 00       	add    $0x811048,%eax
  8021a5:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8021a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ab:	89 d0                	mov    %edx,%eax
  8021ad:	01 c0                	add    %eax,%eax
  8021af:	01 d0                	add    %edx,%eax
  8021b1:	c1 e0 02             	shl    $0x2,%eax
  8021b4:	05 44 10 81 00       	add    $0x811044,%eax
  8021b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8021bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c2:	89 d0                	mov    %edx,%eax
  8021c4:	01 c0                	add    %eax,%eax
  8021c6:	01 d0                	add    %edx,%eax
  8021c8:	c1 e0 02             	shl    $0x2,%eax
  8021cb:	05 40 10 81 00       	add    $0x811040,%eax
  8021d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d6:	e9 8e 00 00 00       	jmp    802269 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8021db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8021e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e7:	89 d0                	mov    %edx,%eax
  8021e9:	01 c0                	add    %eax,%eax
  8021eb:	01 d0                	add    %edx,%eax
  8021ed:	c1 e0 02             	shl    $0x2,%eax
  8021f0:	05 40 10 81 00       	add    $0x811040,%eax
  8021f5:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8021f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fa:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8021fd:	89 c2                	mov    %eax,%edx
  8021ff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802202:	89 c8                	mov    %ecx,%eax
  802204:	01 c0                	add    %eax,%eax
  802206:	01 c8                	add    %ecx,%eax
  802208:	c1 e0 02             	shl    $0x2,%eax
  80220b:	05 44 10 81 00       	add    $0x811044,%eax
  802210:	89 10                	mov    %edx,(%eax)
  802212:	eb 55                	jmp    802269 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802214:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80221b:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802221:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802224:	01 d0                	add    %edx,%eax
  802226:	48                   	dec    %eax
  802227:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80222a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80222d:	ba 00 00 00 00       	mov    $0x0,%edx
  802232:	f7 75 d0             	divl   -0x30(%ebp)
  802235:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802238:	29 d0                	sub    %edx,%eax
  80223a:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80223d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802240:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802243:	01 d0                	add    %edx,%eax
  802245:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80224a:	76 0a                	jbe    802256 <smalloc+0x29e>
            return NULL;
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
  802251:	e9 ba 00 00 00       	jmp    802310 <smalloc+0x358>
        va = start;
  802256:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80225c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80225f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802262:	01 d0                	add    %edx,%eax
  802264:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802269:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802270:	eb 5e                	jmp    8022d0 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802272:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802275:	89 d0                	mov    %edx,%eax
  802277:	01 c0                	add    %eax,%eax
  802279:	01 d0                	add    %edx,%eax
  80227b:	c1 e0 02             	shl    $0x2,%eax
  80227e:	05 48 50 80 00       	add    $0x805048,%eax
  802283:	8a 00                	mov    (%eax),%al
  802285:	84 c0                	test   %al,%al
  802287:	75 44                	jne    8022cd <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802289:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80228c:	89 d0                	mov    %edx,%eax
  80228e:	01 c0                	add    %eax,%eax
  802290:	01 d0                	add    %edx,%eax
  802292:	c1 e0 02             	shl    $0x2,%eax
  802295:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80229b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80229e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8022a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022a3:	89 d0                	mov    %edx,%eax
  8022a5:	01 c0                	add    %eax,%eax
  8022a7:	01 d0                	add    %edx,%eax
  8022a9:	c1 e0 02             	shl    $0x2,%eax
  8022ac:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8022b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022b5:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8022b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022ba:	89 d0                	mov    %edx,%eax
  8022bc:	01 c0                	add    %eax,%eax
  8022be:	01 d0                	add    %edx,%eax
  8022c0:	c1 e0 02             	shl    $0x2,%eax
  8022c3:	05 48 50 80 00       	add    $0x805048,%eax
  8022c8:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8022cb:	eb 0c                	jmp    8022d9 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022cd:	ff 45 e0             	incl   -0x20(%ebp)
  8022d0:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8022d7:	7e 99                	jle    802272 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8022d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022dc:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8022e0:	52                   	push   %edx
  8022e1:	50                   	push   %eax
  8022e2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8022e5:	ff 75 08             	pushl  0x8(%ebp)
  8022e8:	e8 de 0e 00 00       	call   8031cb <sys_create_shared_object>
  8022ed:	83 c4 10             	add    $0x10,%esp
  8022f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8022f3:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8022f7:	75 07                	jne    802300 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8022f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022fe:	eb 10                	jmp    802310 <smalloc+0x358>
    if (r < 0)
  802300:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802304:	79 07                	jns    80230d <smalloc+0x355>
        return NULL;
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
  80230b:	eb 03                	jmp    802310 <smalloc+0x358>
    return (void*)va;
  80230d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802318:	e8 51 f4 ff ff       	call   80176e <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80231d:	83 ec 08             	sub    $0x8,%esp
  802320:	ff 75 0c             	pushl  0xc(%ebp)
  802323:	ff 75 08             	pushl  0x8(%ebp)
  802326:	e8 ca 0e 00 00       	call   8031f5 <sys_size_of_shared_object>
  80232b:	83 c4 10             	add    $0x10,%esp
  80232e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802331:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802335:	7f 0a                	jg     802341 <sget+0x2f>
        return NULL;
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
  80233c:	e9 28 03 00 00       	jmp    802669 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802341:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802348:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80234b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80234e:	01 d0                	add    %edx,%eax
  802350:	48                   	dec    %eax
  802351:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802354:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802357:	ba 00 00 00 00       	mov    $0x0,%edx
  80235c:	f7 75 d8             	divl   -0x28(%ebp)
  80235f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802362:	29 d0                	sub    %edx,%eax
  802364:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802367:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80236e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80237c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802383:	e9 85 00 00 00       	jmp    80240d <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80238b:	89 d0                	mov    %edx,%eax
  80238d:	01 c0                	add    %eax,%eax
  80238f:	01 d0                	add    %edx,%eax
  802391:	c1 e0 02             	shl    $0x2,%eax
  802394:	05 48 10 81 00       	add    $0x811048,%eax
  802399:	8a 00                	mov    (%eax),%al
  80239b:	84 c0                	test   %al,%al
  80239d:	74 20                	je     8023bf <sget+0xad>
  80239f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023a2:	89 d0                	mov    %edx,%eax
  8023a4:	01 c0                	add    %eax,%eax
  8023a6:	01 d0                	add    %edx,%eax
  8023a8:	c1 e0 02             	shl    $0x2,%eax
  8023ab:	05 44 10 81 00       	add    $0x811044,%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023b5:	75 08                	jne    8023bf <sget+0xad>
        {
            exactIdx = i;
  8023b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8023bd:	eb 5b                	jmp    80241a <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8023bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023c2:	89 d0                	mov    %edx,%eax
  8023c4:	01 c0                	add    %eax,%eax
  8023c6:	01 d0                	add    %edx,%eax
  8023c8:	c1 e0 02             	shl    $0x2,%eax
  8023cb:	05 48 10 81 00       	add    $0x811048,%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	84 c0                	test   %al,%al
  8023d4:	74 34                	je     80240a <sget+0xf8>
  8023d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023d9:	89 d0                	mov    %edx,%eax
  8023db:	01 c0                	add    %eax,%eax
  8023dd:	01 d0                	add    %edx,%eax
  8023df:	c1 e0 02             	shl    $0x2,%eax
  8023e2:	05 44 10 81 00       	add    $0x811044,%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023ec:	76 1c                	jbe    80240a <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8023ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023f1:	89 d0                	mov    %edx,%eax
  8023f3:	01 c0                	add    %eax,%eax
  8023f5:	01 d0                	add    %edx,%eax
  8023f7:	c1 e0 02             	shl    $0x2,%eax
  8023fa:	05 44 10 81 00       	add    $0x811044,%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802407:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80240a:	ff 45 e8             	incl   -0x18(%ebp)
  80240d:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802414:	0f 8e 6e ff ff ff    	jle    802388 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80241a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802421:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802425:	74 7d                	je     8024a4 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802427:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80242e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802431:	89 d0                	mov    %edx,%eax
  802433:	01 c0                	add    %eax,%eax
  802435:	01 d0                	add    %edx,%eax
  802437:	c1 e0 02             	shl    $0x2,%eax
  80243a:	05 40 10 81 00       	add    $0x811040,%eax
  80243f:	8b 10                	mov    (%eax),%edx
  802441:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802444:	01 d0                	add    %edx,%eax
  802446:	48                   	dec    %eax
  802447:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80244a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80244d:	ba 00 00 00 00       	mov    $0x0,%edx
  802452:	f7 75 b8             	divl   -0x48(%ebp)
  802455:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802458:	29 d0                	sub    %edx,%eax
  80245a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80245d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802460:	89 d0                	mov    %edx,%eax
  802462:	01 c0                	add    %eax,%eax
  802464:	01 d0                	add    %edx,%eax
  802466:	c1 e0 02             	shl    $0x2,%eax
  802469:	05 48 10 81 00       	add    $0x811048,%eax
  80246e:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802474:	89 d0                	mov    %edx,%eax
  802476:	01 c0                	add    %eax,%eax
  802478:	01 d0                	add    %edx,%eax
  80247a:	c1 e0 02             	shl    $0x2,%eax
  80247d:	05 44 10 81 00       	add    $0x811044,%eax
  802482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802488:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248b:	89 d0                	mov    %edx,%eax
  80248d:	01 c0                	add    %eax,%eax
  80248f:	01 d0                	add    %edx,%eax
  802491:	c1 e0 02             	shl    $0x2,%eax
  802494:	05 40 10 81 00       	add    $0x811040,%eax
  802499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249f:	e9 2d 01 00 00       	jmp    8025d1 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8024a4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024a8:	0f 84 ce 00 00 00    	je     80257c <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8024ae:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8024b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b8:	89 d0                	mov    %edx,%eax
  8024ba:	01 c0                	add    %eax,%eax
  8024bc:	01 d0                	add    %edx,%eax
  8024be:	c1 e0 02             	shl    $0x2,%eax
  8024c1:	05 40 10 81 00       	add    $0x811040,%eax
  8024c6:	8b 10                	mov    (%eax),%edx
  8024c8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024cb:	01 d0                	add    %edx,%eax
  8024cd:	48                   	dec    %eax
  8024ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8024d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d9:	f7 75 c0             	divl   -0x40(%ebp)
  8024dc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024df:	29 d0                	sub    %edx,%eax
  8024e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8024e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e7:	89 d0                	mov    %edx,%eax
  8024e9:	01 c0                	add    %eax,%eax
  8024eb:	01 d0                	add    %edx,%eax
  8024ed:	c1 e0 02             	shl    $0x2,%eax
  8024f0:	05 44 10 81 00       	add    $0x811044,%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8024fa:	75 47                	jne    802543 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8024fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ff:	89 d0                	mov    %edx,%eax
  802501:	01 c0                	add    %eax,%eax
  802503:	01 d0                	add    %edx,%eax
  802505:	c1 e0 02             	shl    $0x2,%eax
  802508:	05 48 10 81 00       	add    $0x811048,%eax
  80250d:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802513:	89 d0                	mov    %edx,%eax
  802515:	01 c0                	add    %eax,%eax
  802517:	01 d0                	add    %edx,%eax
  802519:	c1 e0 02             	shl    $0x2,%eax
  80251c:	05 44 10 81 00       	add    $0x811044,%eax
  802521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802527:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252a:	89 d0                	mov    %edx,%eax
  80252c:	01 c0                	add    %eax,%eax
  80252e:	01 d0                	add    %edx,%eax
  802530:	c1 e0 02             	shl    $0x2,%eax
  802533:	05 40 10 81 00       	add    $0x811040,%eax
  802538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253e:	e9 8e 00 00 00       	jmp    8025d1 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802543:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802546:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802549:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80254c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254f:	89 d0                	mov    %edx,%eax
  802551:	01 c0                	add    %eax,%eax
  802553:	01 d0                	add    %edx,%eax
  802555:	c1 e0 02             	shl    $0x2,%eax
  802558:	05 40 10 81 00       	add    $0x811040,%eax
  80255d:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802565:	89 c2                	mov    %eax,%edx
  802567:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80256a:	89 c8                	mov    %ecx,%eax
  80256c:	01 c0                	add    %eax,%eax
  80256e:	01 c8                	add    %ecx,%eax
  802570:	c1 e0 02             	shl    $0x2,%eax
  802573:	05 44 10 81 00       	add    $0x811044,%eax
  802578:	89 10                	mov    %edx,(%eax)
  80257a:	eb 55                	jmp    8025d1 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80257c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802583:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802589:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80258c:	01 d0                	add    %edx,%eax
  80258e:	48                   	dec    %eax
  80258f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802592:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802595:	ba 00 00 00 00       	mov    $0x0,%edx
  80259a:	f7 75 cc             	divl   -0x34(%ebp)
  80259d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025a0:	29 d0                	sub    %edx,%eax
  8025a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8025a5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025ab:	01 d0                	add    %edx,%eax
  8025ad:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8025b2:	76 0a                	jbe    8025be <sget+0x2ac>
            return NULL;
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b9:	e9 ab 00 00 00       	jmp    802669 <sget+0x357>
        va = start;
  8025be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8025c4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025ca:	01 d0                	add    %edx,%eax
  8025cc:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8025d8:	eb 5e                	jmp    802638 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8025da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025dd:	89 d0                	mov    %edx,%eax
  8025df:	01 c0                	add    %eax,%eax
  8025e1:	01 d0                	add    %edx,%eax
  8025e3:	c1 e0 02             	shl    $0x2,%eax
  8025e6:	05 48 50 80 00       	add    $0x805048,%eax
  8025eb:	8a 00                	mov    (%eax),%al
  8025ed:	84 c0                	test   %al,%al
  8025ef:	75 44                	jne    802635 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8025f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025f4:	89 d0                	mov    %edx,%eax
  8025f6:	01 c0                	add    %eax,%eax
  8025f8:	01 d0                	add    %edx,%eax
  8025fa:	c1 e0 02             	shl    $0x2,%eax
  8025fd:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802606:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802608:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80260b:	89 d0                	mov    %edx,%eax
  80260d:	01 c0                	add    %eax,%eax
  80260f:	01 d0                	add    %edx,%eax
  802611:	c1 e0 02             	shl    $0x2,%eax
  802614:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80261a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80261d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80261f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802622:	89 d0                	mov    %edx,%eax
  802624:	01 c0                	add    %eax,%eax
  802626:	01 d0                	add    %edx,%eax
  802628:	c1 e0 02             	shl    $0x2,%eax
  80262b:	05 48 50 80 00       	add    $0x805048,%eax
  802630:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802633:	eb 0c                	jmp    802641 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802635:	ff 45 e0             	incl   -0x20(%ebp)
  802638:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80263f:	7e 99                	jle    8025da <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802644:	83 ec 04             	sub    $0x4,%esp
  802647:	50                   	push   %eax
  802648:	ff 75 0c             	pushl  0xc(%ebp)
  80264b:	ff 75 08             	pushl  0x8(%ebp)
  80264e:	e8 bf 0b 00 00       	call   803212 <sys_get_shared_object>
  802653:	83 c4 10             	add    $0x10,%esp
  802656:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802659:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80265d:	79 07                	jns    802666 <sget+0x354>
        return NULL;
  80265f:	b8 00 00 00 00       	mov    $0x0,%eax
  802664:	eb 03                	jmp    802669 <sget+0x357>
    return (void*)va;
  802666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802671:	e8 f8 f0 ff ff       	call   80176e <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802676:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267a:	75 13                	jne    80268f <realloc+0x24>
		return malloc(new_size);
  80267c:	83 ec 0c             	sub    $0xc,%esp
  80267f:	ff 75 0c             	pushl  0xc(%ebp)
  802682:	e8 c4 f1 ff ff       	call   80184b <malloc>
  802687:	83 c4 10             	add    $0x10,%esp
  80268a:	e9 f4 05 00 00       	jmp    802c83 <realloc+0x618>
	if (new_size == 0)
  80268f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802693:	75 18                	jne    8026ad <realloc+0x42>
	{
		free(virtual_address);
  802695:	83 ec 0c             	sub    $0xc,%esp
  802698:	ff 75 08             	pushl  0x8(%ebp)
  80269b:	e8 0b f5 ff ff       	call   801bab <free>
  8026a0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	e9 d6 05 00 00       	jmp    802c83 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8026b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	79 74                	jns    80272e <realloc+0xc3>
  8026ba:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8026c1:	77 6b                	ja     80272e <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8026c3:	83 ec 0c             	sub    $0xc,%esp
  8026c6:	ff 75 0c             	pushl  0xc(%ebp)
  8026c9:	e8 7d f1 ff ff       	call   80184b <malloc>
  8026ce:	83 c4 10             	add    $0x10,%esp
  8026d1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8026d4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8026d8:	75 0a                	jne    8026e4 <realloc+0x79>
			return NULL;
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
  8026df:	e9 9f 05 00 00       	jmp    802c83 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8026e4:	83 ec 0c             	sub    $0xc,%esp
  8026e7:	ff 75 08             	pushl  0x8(%ebp)
  8026ea:	e8 e0 11 00 00       	call   8038cf <get_block_size>
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8026f5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8026f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fb:	39 d0                	cmp    %edx,%eax
  8026fd:	76 02                	jbe    802701 <realloc+0x96>
  8026ff:	89 d0                	mov    %edx,%eax
  802701:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802704:	83 ec 04             	sub    $0x4,%esp
  802707:	ff 75 c0             	pushl  -0x40(%ebp)
  80270a:	ff 75 08             	pushl  0x8(%ebp)
  80270d:	ff 75 c8             	pushl  -0x38(%ebp)
  802710:	e8 56 eb ff ff       	call   80126b <memmove>
  802715:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802718:	83 ec 0c             	sub    $0xc,%esp
  80271b:	ff 75 08             	pushl  0x8(%ebp)
  80271e:	e8 88 f4 ff ff       	call   801bab <free>
  802723:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802726:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802729:	e9 55 05 00 00       	jmp    802c83 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80272e:	a1 30 51 83 00       	mov    0x835130,%eax
  802733:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802736:	72 09                	jb     802741 <realloc+0xd6>
  802738:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80273f:	76 0a                	jbe    80274b <realloc+0xe0>
		return NULL;
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
  802746:	e9 38 05 00 00       	jmp    802c83 <realloc+0x618>
	uint32 oldsz = 0;
  80274b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802752:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802759:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802760:	eb 50                	jmp    8027b2 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802762:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802765:	89 d0                	mov    %edx,%eax
  802767:	01 c0                	add    %eax,%eax
  802769:	01 d0                	add    %edx,%eax
  80276b:	c1 e0 02             	shl    $0x2,%eax
  80276e:	05 48 50 80 00       	add    $0x805048,%eax
  802773:	8a 00                	mov    (%eax),%al
  802775:	84 c0                	test   %al,%al
  802777:	74 36                	je     8027af <realloc+0x144>
  802779:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277c:	89 d0                	mov    %edx,%eax
  80277e:	01 c0                	add    %eax,%eax
  802780:	01 d0                	add    %edx,%eax
  802782:	c1 e0 02             	shl    $0x2,%eax
  802785:	05 40 50 80 00       	add    $0x805040,%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80278f:	75 1e                	jne    8027af <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802791:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802794:	89 d0                	mov    %edx,%eax
  802796:	01 c0                	add    %eax,%eax
  802798:	01 d0                	add    %edx,%eax
  80279a:	c1 e0 02             	shl    $0x2,%eax
  80279d:	05 44 50 80 00       	add    $0x805044,%eax
  8027a2:	8b 00                	mov    (%eax),%eax
  8027a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8027a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8027ad:	eb 0c                	jmp    8027bb <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8027af:	ff 45 ec             	incl   -0x14(%ebp)
  8027b2:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8027b9:	7e a7                	jle    802762 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8027bb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8027bf:	75 0a                	jne    8027cb <realloc+0x160>
		return NULL;
  8027c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c6:	e9 b8 04 00 00       	jmp    802c83 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8027cb:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8027d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027d8:	01 d0                	add    %edx,%eax
  8027da:	48                   	dec    %eax
  8027db:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8027de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e6:	f7 75 bc             	divl   -0x44(%ebp)
  8027e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027ec:	29 d0                	sub    %edx,%eax
  8027ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8027f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027f7:	75 08                	jne    802801 <realloc+0x196>
		return virtual_address;
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	e9 82 04 00 00       	jmp    802c83 <realloc+0x618>
	if (req < oldsz)
  802801:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802804:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802807:	0f 83 cd 02 00 00    	jae    802ada <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802813:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802816:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802819:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80281c:	01 d0                	add    %edx,%eax
  80281e:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802821:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802824:	89 d0                	mov    %edx,%eax
  802826:	01 c0                	add    %eax,%eax
  802828:	01 d0                	add    %edx,%eax
  80282a:	c1 e0 02             	shl    $0x2,%eax
  80282d:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802833:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802836:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802838:	83 ec 08             	sub    $0x8,%esp
  80283b:	ff 75 b0             	pushl  -0x50(%ebp)
  80283e:	ff 75 ac             	pushl  -0x54(%ebp)
  802841:	e8 e3 0c 00 00       	call   803529 <sys_free_user_mem>
  802846:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802849:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802850:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802857:	eb 64                	jmp    8028bd <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802859:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80285c:	89 d0                	mov    %edx,%eax
  80285e:	01 c0                	add    %eax,%eax
  802860:	01 d0                	add    %edx,%eax
  802862:	c1 e0 02             	shl    $0x2,%eax
  802865:	05 48 10 81 00       	add    $0x811048,%eax
  80286a:	8a 00                	mov    (%eax),%al
  80286c:	84 c0                	test   %al,%al
  80286e:	75 4a                	jne    8028ba <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802873:	89 d0                	mov    %edx,%eax
  802875:	01 c0                	add    %eax,%eax
  802877:	01 d0                	add    %edx,%eax
  802879:	c1 e0 02             	shl    $0x2,%eax
  80287c:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802882:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802885:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802887:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80288a:	89 d0                	mov    %edx,%eax
  80288c:	01 c0                	add    %eax,%eax
  80288e:	01 d0                	add    %edx,%eax
  802890:	c1 e0 02             	shl    $0x2,%eax
  802893:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802899:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80289c:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80289e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a1:	89 d0                	mov    %edx,%eax
  8028a3:	01 c0                	add    %eax,%eax
  8028a5:	01 d0                	add    %edx,%eax
  8028a7:	c1 e0 02             	shl    $0x2,%eax
  8028aa:	05 48 10 81 00       	add    $0x811048,%eax
  8028af:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8028b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8028b8:	eb 0c                	jmp    8028c6 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028ba:	ff 45 e4             	incl   -0x1c(%ebp)
  8028bd:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8028c4:	7e 93                	jle    802859 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8028c6:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8028ca:	0f 84 8d 01 00 00    	je     802a5d <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8028d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8028d7:	e9 74 01 00 00       	jmp    802a50 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8028dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028df:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028e2:	0f 84 64 01 00 00    	je     802a4c <realloc+0x3e1>
				if (uhp_frees[k].free)
  8028e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028eb:	89 d0                	mov    %edx,%eax
  8028ed:	01 c0                	add    %eax,%eax
  8028ef:	01 d0                	add    %edx,%eax
  8028f1:	c1 e0 02             	shl    $0x2,%eax
  8028f4:	05 48 10 81 00       	add    $0x811048,%eax
  8028f9:	8a 00                	mov    (%eax),%al
  8028fb:	84 c0                	test   %al,%al
  8028fd:	0f 84 4a 01 00 00    	je     802a4d <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802903:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802906:	89 d0                	mov    %edx,%eax
  802908:	01 c0                	add    %eax,%eax
  80290a:	01 d0                	add    %edx,%eax
  80290c:	c1 e0 02             	shl    $0x2,%eax
  80290f:	05 40 10 81 00       	add    $0x811040,%eax
  802914:	8b 08                	mov    (%eax),%ecx
  802916:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802919:	89 d0                	mov    %edx,%eax
  80291b:	01 c0                	add    %eax,%eax
  80291d:	01 d0                	add    %edx,%eax
  80291f:	c1 e0 02             	shl    $0x2,%eax
  802922:	05 44 10 81 00       	add    $0x811044,%eax
  802927:	8b 00                	mov    (%eax),%eax
  802929:	01 c1                	add    %eax,%ecx
  80292b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80292e:	89 d0                	mov    %edx,%eax
  802930:	01 c0                	add    %eax,%eax
  802932:	01 d0                	add    %edx,%eax
  802934:	c1 e0 02             	shl    $0x2,%eax
  802937:	05 40 10 81 00       	add    $0x811040,%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	39 c1                	cmp    %eax,%ecx
  802940:	75 7a                	jne    8029bc <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802942:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802945:	89 d0                	mov    %edx,%eax
  802947:	01 c0                	add    %eax,%eax
  802949:	01 d0                	add    %edx,%eax
  80294b:	c1 e0 02             	shl    $0x2,%eax
  80294e:	05 40 10 81 00       	add    $0x811040,%eax
  802953:	8b 10                	mov    (%eax),%edx
  802955:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802958:	89 c8                	mov    %ecx,%eax
  80295a:	01 c0                	add    %eax,%eax
  80295c:	01 c8                	add    %ecx,%eax
  80295e:	c1 e0 02             	shl    $0x2,%eax
  802961:	05 40 10 81 00       	add    $0x811040,%eax
  802966:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802968:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296b:	89 d0                	mov    %edx,%eax
  80296d:	01 c0                	add    %eax,%eax
  80296f:	01 d0                	add    %edx,%eax
  802971:	c1 e0 02             	shl    $0x2,%eax
  802974:	05 44 10 81 00       	add    $0x811044,%eax
  802979:	8b 08                	mov    (%eax),%ecx
  80297b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80297e:	89 d0                	mov    %edx,%eax
  802980:	01 c0                	add    %eax,%eax
  802982:	01 d0                	add    %edx,%eax
  802984:	c1 e0 02             	shl    $0x2,%eax
  802987:	05 44 10 81 00       	add    $0x811044,%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	01 c1                	add    %eax,%ecx
  802990:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802993:	89 d0                	mov    %edx,%eax
  802995:	01 c0                	add    %eax,%eax
  802997:	01 d0                	add    %edx,%eax
  802999:	c1 e0 02             	shl    $0x2,%eax
  80299c:	05 44 10 81 00       	add    $0x811044,%eax
  8029a1:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8029a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029a6:	89 d0                	mov    %edx,%eax
  8029a8:	01 c0                	add    %eax,%eax
  8029aa:	01 d0                	add    %edx,%eax
  8029ac:	c1 e0 02             	shl    $0x2,%eax
  8029af:	05 48 10 81 00       	add    $0x811048,%eax
  8029b4:	c6 00 00             	movb   $0x0,(%eax)
  8029b7:	e9 91 00 00 00       	jmp    802a4d <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8029bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029bf:	89 d0                	mov    %edx,%eax
  8029c1:	01 c0                	add    %eax,%eax
  8029c3:	01 d0                	add    %edx,%eax
  8029c5:	c1 e0 02             	shl    $0x2,%eax
  8029c8:	05 40 10 81 00       	add    $0x811040,%eax
  8029cd:	8b 08                	mov    (%eax),%ecx
  8029cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029d2:	89 d0                	mov    %edx,%eax
  8029d4:	01 c0                	add    %eax,%eax
  8029d6:	01 d0                	add    %edx,%eax
  8029d8:	c1 e0 02             	shl    $0x2,%eax
  8029db:	05 44 10 81 00       	add    $0x811044,%eax
  8029e0:	8b 00                	mov    (%eax),%eax
  8029e2:	01 c1                	add    %eax,%ecx
  8029e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029e7:	89 d0                	mov    %edx,%eax
  8029e9:	01 c0                	add    %eax,%eax
  8029eb:	01 d0                	add    %edx,%eax
  8029ed:	c1 e0 02             	shl    $0x2,%eax
  8029f0:	05 40 10 81 00       	add    $0x811040,%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	39 c1                	cmp    %eax,%ecx
  8029f9:	75 52                	jne    802a4d <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8029fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029fe:	89 d0                	mov    %edx,%eax
  802a00:	01 c0                	add    %eax,%eax
  802a02:	01 d0                	add    %edx,%eax
  802a04:	c1 e0 02             	shl    $0x2,%eax
  802a07:	05 44 10 81 00       	add    $0x811044,%eax
  802a0c:	8b 08                	mov    (%eax),%ecx
  802a0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a11:	89 d0                	mov    %edx,%eax
  802a13:	01 c0                	add    %eax,%eax
  802a15:	01 d0                	add    %edx,%eax
  802a17:	c1 e0 02             	shl    $0x2,%eax
  802a1a:	05 44 10 81 00       	add    $0x811044,%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	01 c1                	add    %eax,%ecx
  802a23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a26:	89 d0                	mov    %edx,%eax
  802a28:	01 c0                	add    %eax,%eax
  802a2a:	01 d0                	add    %edx,%eax
  802a2c:	c1 e0 02             	shl    $0x2,%eax
  802a2f:	05 44 10 81 00       	add    $0x811044,%eax
  802a34:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802a36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a39:	89 d0                	mov    %edx,%eax
  802a3b:	01 c0                	add    %eax,%eax
  802a3d:	01 d0                	add    %edx,%eax
  802a3f:	c1 e0 02             	shl    $0x2,%eax
  802a42:	05 48 10 81 00       	add    $0x811048,%eax
  802a47:	c6 00 00             	movb   $0x0,(%eax)
  802a4a:	eb 01                	jmp    802a4d <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802a4c:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802a4d:	ff 45 e0             	incl   -0x20(%ebp)
  802a50:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802a57:	0f 8e 7f fe ff ff    	jle    8028dc <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802a5d:	a1 30 51 83 00       	mov    0x835130,%eax
  802a62:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802a65:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802a6c:	eb 53                	jmp    802ac1 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802a6e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a71:	89 d0                	mov    %edx,%eax
  802a73:	01 c0                	add    %eax,%eax
  802a75:	01 d0                	add    %edx,%eax
  802a77:	c1 e0 02             	shl    $0x2,%eax
  802a7a:	05 48 50 80 00       	add    $0x805048,%eax
  802a7f:	8a 00                	mov    (%eax),%al
  802a81:	84 c0                	test   %al,%al
  802a83:	74 39                	je     802abe <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802a85:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a88:	89 d0                	mov    %edx,%eax
  802a8a:	01 c0                	add    %eax,%eax
  802a8c:	01 d0                	add    %edx,%eax
  802a8e:	c1 e0 02             	shl    $0x2,%eax
  802a91:	05 40 50 80 00       	add    $0x805040,%eax
  802a96:	8b 08                	mov    (%eax),%ecx
  802a98:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a9b:	89 d0                	mov    %edx,%eax
  802a9d:	01 c0                	add    %eax,%eax
  802a9f:	01 d0                	add    %edx,%eax
  802aa1:	c1 e0 02             	shl    $0x2,%eax
  802aa4:	05 44 50 80 00       	add    $0x805044,%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	01 c8                	add    %ecx,%eax
  802aad:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802ab0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ab3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802ab6:	76 06                	jbe    802abe <realloc+0x453>
  802ab8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802abb:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802abe:	ff 45 d8             	incl   -0x28(%ebp)
  802ac1:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802ac8:	7e a4                	jle    802a6e <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802aca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802acd:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	e9 a9 01 00 00       	jmp    802c83 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802ada:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	01 d0                	add    %edx,%eax
  802ae2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802ae5:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802aec:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802af3:	eb 57                	jmp    802b4c <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802af5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802af8:	89 d0                	mov    %edx,%eax
  802afa:	01 c0                	add    %eax,%eax
  802afc:	01 d0                	add    %edx,%eax
  802afe:	c1 e0 02             	shl    $0x2,%eax
  802b01:	05 48 10 81 00       	add    $0x811048,%eax
  802b06:	8a 00                	mov    (%eax),%al
  802b08:	84 c0                	test   %al,%al
  802b0a:	74 3d                	je     802b49 <realloc+0x4de>
  802b0c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b0f:	89 d0                	mov    %edx,%eax
  802b11:	01 c0                	add    %eax,%eax
  802b13:	01 d0                	add    %edx,%eax
  802b15:	c1 e0 02             	shl    $0x2,%eax
  802b18:	05 40 10 81 00       	add    $0x811040,%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b22:	75 25                	jne    802b49 <realloc+0x4de>
  802b24:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b27:	89 d0                	mov    %edx,%eax
  802b29:	01 c0                	add    %eax,%eax
  802b2b:	01 d0                	add    %edx,%eax
  802b2d:	c1 e0 02             	shl    $0x2,%eax
  802b30:	05 44 10 81 00       	add    $0x811044,%eax
  802b35:	8b 10                	mov    (%eax),%edx
  802b37:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b3a:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b3d:	39 c2                	cmp    %eax,%edx
  802b3f:	72 08                	jb     802b49 <realloc+0x4de>
		{
			adjIdx = j; break;
  802b41:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b44:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b47:	eb 0c                	jmp    802b55 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b49:	ff 45 d0             	incl   -0x30(%ebp)
  802b4c:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802b53:	7e a0                	jle    802af5 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802b55:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802b59:	0f 84 d6 00 00 00    	je     802c35 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802b5f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b62:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b65:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802b68:	83 ec 08             	sub    $0x8,%esp
  802b6b:	ff 75 a0             	pushl  -0x60(%ebp)
  802b6e:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b71:	e8 cf 09 00 00       	call   803545 <sys_allocate_user_mem>
  802b76:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802b79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7c:	89 d0                	mov    %edx,%eax
  802b7e:	01 c0                	add    %eax,%eax
  802b80:	01 d0                	add    %edx,%eax
  802b82:	c1 e0 02             	shl    $0x2,%eax
  802b85:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802b8b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b8e:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802b90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b93:	89 d0                	mov    %edx,%eax
  802b95:	01 c0                	add    %eax,%eax
  802b97:	01 d0                	add    %edx,%eax
  802b99:	c1 e0 02             	shl    $0x2,%eax
  802b9c:	05 40 10 81 00       	add    $0x811040,%eax
  802ba1:	8b 10                	mov    (%eax),%edx
  802ba3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802ba6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802ba9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bac:	89 d0                	mov    %edx,%eax
  802bae:	01 c0                	add    %eax,%eax
  802bb0:	01 d0                	add    %edx,%eax
  802bb2:	c1 e0 02             	shl    $0x2,%eax
  802bb5:	05 40 10 81 00       	add    $0x811040,%eax
  802bba:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802bbc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bbf:	89 d0                	mov    %edx,%eax
  802bc1:	01 c0                	add    %eax,%eax
  802bc3:	01 d0                	add    %edx,%eax
  802bc5:	c1 e0 02             	shl    $0x2,%eax
  802bc8:	05 44 10 81 00       	add    $0x811044,%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802bd2:	89 c2                	mov    %eax,%edx
  802bd4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802bd7:	89 c8                	mov    %ecx,%eax
  802bd9:	01 c0                	add    %eax,%eax
  802bdb:	01 c8                	add    %ecx,%eax
  802bdd:	c1 e0 02             	shl    $0x2,%eax
  802be0:	05 44 10 81 00       	add    $0x811044,%eax
  802be5:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802be7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bea:	89 d0                	mov    %edx,%eax
  802bec:	01 c0                	add    %eax,%eax
  802bee:	01 d0                	add    %edx,%eax
  802bf0:	c1 e0 02             	shl    $0x2,%eax
  802bf3:	05 44 10 81 00       	add    $0x811044,%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	75 14                	jne    802c12 <realloc+0x5a7>
  802bfe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c01:	89 d0                	mov    %edx,%eax
  802c03:	01 c0                	add    %eax,%eax
  802c05:	01 d0                	add    %edx,%eax
  802c07:	c1 e0 02             	shl    $0x2,%eax
  802c0a:	05 48 10 81 00       	add    $0x811048,%eax
  802c0f:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802c12:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c15:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c18:	01 c2                	add    %eax,%edx
  802c1a:	a1 88 50 83 00       	mov    0x835088,%eax
  802c1f:	39 c2                	cmp    %eax,%edx
  802c21:	76 0d                	jbe    802c30 <realloc+0x5c5>
  802c23:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c26:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c29:	01 d0                	add    %edx,%eax
  802c2b:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	eb 4e                	jmp    802c83 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802c35:	83 ec 0c             	sub    $0xc,%esp
  802c38:	ff 75 0c             	pushl  0xc(%ebp)
  802c3b:	e8 0b ec ff ff       	call   80184b <malloc>
  802c40:	83 c4 10             	add    $0x10,%esp
  802c43:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802c46:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802c4a:	75 07                	jne    802c53 <realloc+0x5e8>
		return NULL;
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	eb 30                	jmp    802c83 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c59:	39 d0                	cmp    %edx,%eax
  802c5b:	76 02                	jbe    802c5f <realloc+0x5f4>
  802c5d:	89 d0                	mov    %edx,%eax
  802c5f:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802c62:	83 ec 04             	sub    $0x4,%esp
  802c65:	50                   	push   %eax
  802c66:	52                   	push   %edx
  802c67:	ff 75 cc             	pushl  -0x34(%ebp)
  802c6a:	e8 cf 06 00 00       	call   80333e <sys_move_user_mem>
  802c6f:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802c72:	83 ec 0c             	sub    $0xc,%esp
  802c75:	ff 75 08             	pushl  0x8(%ebp)
  802c78:	e8 2e ef ff ff       	call   801bab <free>
  802c7d:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802c80:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

00802c85 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802c85:	55                   	push   %ebp
  802c86:	89 e5                	mov    %esp,%ebp
  802c88:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802c91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c95:	0f 84 33 03 00 00    	je     802fce <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802c9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c9e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802ca3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802ca6:	83 ec 08             	sub    $0x8,%esp
  802ca9:	ff 75 08             	pushl  0x8(%ebp)
  802cac:	ff 75 d8             	pushl  -0x28(%ebp)
  802caf:	e8 7d 05 00 00       	call   803231 <sys_delete_shared_object>
  802cb4:	83 c4 10             	add    $0x10,%esp
  802cb7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802cba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802cbe:	0f 88 0d 03 00 00    	js     802fd1 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ccb:	e9 ef 02 00 00       	jmp    802fbf <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802cd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd3:	89 d0                	mov    %edx,%eax
  802cd5:	01 c0                	add    %eax,%eax
  802cd7:	01 d0                	add    %edx,%eax
  802cd9:	c1 e0 02             	shl    $0x2,%eax
  802cdc:	05 48 50 80 00       	add    $0x805048,%eax
  802ce1:	8a 00                	mov    (%eax),%al
  802ce3:	84 c0                	test   %al,%al
  802ce5:	0f 84 d1 02 00 00    	je     802fbc <sfree+0x337>
  802ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cee:	89 d0                	mov    %edx,%eax
  802cf0:	01 c0                	add    %eax,%eax
  802cf2:	01 d0                	add    %edx,%eax
  802cf4:	c1 e0 02             	shl    $0x2,%eax
  802cf7:	05 40 50 80 00       	add    $0x805040,%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d01:	0f 85 b5 02 00 00    	jne    802fbc <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0a:	89 d0                	mov    %edx,%eax
  802d0c:	01 c0                	add    %eax,%eax
  802d0e:	01 d0                	add    %edx,%eax
  802d10:	c1 e0 02             	shl    $0x2,%eax
  802d13:	05 44 50 80 00       	add    $0x805044,%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802d1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d20:	89 d0                	mov    %edx,%eax
  802d22:	01 c0                	add    %eax,%eax
  802d24:	01 d0                	add    %edx,%eax
  802d26:	c1 e0 02             	shl    $0x2,%eax
  802d29:	05 48 50 80 00       	add    $0x805048,%eax
  802d2e:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802d31:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802d38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802d3f:	eb 64                	jmp    802da5 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802d41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d44:	89 d0                	mov    %edx,%eax
  802d46:	01 c0                	add    %eax,%eax
  802d48:	01 d0                	add    %edx,%eax
  802d4a:	c1 e0 02             	shl    $0x2,%eax
  802d4d:	05 48 10 81 00       	add    $0x811048,%eax
  802d52:	8a 00                	mov    (%eax),%al
  802d54:	84 c0                	test   %al,%al
  802d56:	75 4a                	jne    802da2 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802d58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d5b:	89 d0                	mov    %edx,%eax
  802d5d:	01 c0                	add    %eax,%eax
  802d5f:	01 d0                	add    %edx,%eax
  802d61:	c1 e0 02             	shl    $0x2,%eax
  802d64:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802d6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6d:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802d6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d72:	89 d0                	mov    %edx,%eax
  802d74:	01 c0                	add    %eax,%eax
  802d76:	01 d0                	add    %edx,%eax
  802d78:	c1 e0 02             	shl    $0x2,%eax
  802d7b:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802d81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d84:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802d86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d89:	89 d0                	mov    %edx,%eax
  802d8b:	01 c0                	add    %eax,%eax
  802d8d:	01 d0                	add    %edx,%eax
  802d8f:	c1 e0 02             	shl    $0x2,%eax
  802d92:	05 48 10 81 00       	add    $0x811048,%eax
  802d97:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802da0:	eb 0c                	jmp    802dae <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802da2:	ff 45 ec             	incl   -0x14(%ebp)
  802da5:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802dac:	7e 93                	jle    802d41 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802dae:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802db2:	0f 84 8d 01 00 00    	je     802f45 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802db8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802dbf:	e9 74 01 00 00       	jmp    802f38 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802dc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dca:	0f 84 64 01 00 00    	je     802f34 <sfree+0x2af>
					if (uhp_frees[k].free)
  802dd0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd3:	89 d0                	mov    %edx,%eax
  802dd5:	01 c0                	add    %eax,%eax
  802dd7:	01 d0                	add    %edx,%eax
  802dd9:	c1 e0 02             	shl    $0x2,%eax
  802ddc:	05 48 10 81 00       	add    $0x811048,%eax
  802de1:	8a 00                	mov    (%eax),%al
  802de3:	84 c0                	test   %al,%al
  802de5:	0f 84 4a 01 00 00    	je     802f35 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802deb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dee:	89 d0                	mov    %edx,%eax
  802df0:	01 c0                	add    %eax,%eax
  802df2:	01 d0                	add    %edx,%eax
  802df4:	c1 e0 02             	shl    $0x2,%eax
  802df7:	05 40 10 81 00       	add    $0x811040,%eax
  802dfc:	8b 08                	mov    (%eax),%ecx
  802dfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e01:	89 d0                	mov    %edx,%eax
  802e03:	01 c0                	add    %eax,%eax
  802e05:	01 d0                	add    %edx,%eax
  802e07:	c1 e0 02             	shl    $0x2,%eax
  802e0a:	05 44 10 81 00       	add    $0x811044,%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	01 c1                	add    %eax,%ecx
  802e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e16:	89 d0                	mov    %edx,%eax
  802e18:	01 c0                	add    %eax,%eax
  802e1a:	01 d0                	add    %edx,%eax
  802e1c:	c1 e0 02             	shl    $0x2,%eax
  802e1f:	05 40 10 81 00       	add    $0x811040,%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	39 c1                	cmp    %eax,%ecx
  802e28:	75 7a                	jne    802ea4 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802e2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e2d:	89 d0                	mov    %edx,%eax
  802e2f:	01 c0                	add    %eax,%eax
  802e31:	01 d0                	add    %edx,%eax
  802e33:	c1 e0 02             	shl    $0x2,%eax
  802e36:	05 40 10 81 00       	add    $0x811040,%eax
  802e3b:	8b 10                	mov    (%eax),%edx
  802e3d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e40:	89 c8                	mov    %ecx,%eax
  802e42:	01 c0                	add    %eax,%eax
  802e44:	01 c8                	add    %ecx,%eax
  802e46:	c1 e0 02             	shl    $0x2,%eax
  802e49:	05 40 10 81 00       	add    $0x811040,%eax
  802e4e:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802e50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e53:	89 d0                	mov    %edx,%eax
  802e55:	01 c0                	add    %eax,%eax
  802e57:	01 d0                	add    %edx,%eax
  802e59:	c1 e0 02             	shl    $0x2,%eax
  802e5c:	05 44 10 81 00       	add    $0x811044,%eax
  802e61:	8b 08                	mov    (%eax),%ecx
  802e63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e66:	89 d0                	mov    %edx,%eax
  802e68:	01 c0                	add    %eax,%eax
  802e6a:	01 d0                	add    %edx,%eax
  802e6c:	c1 e0 02             	shl    $0x2,%eax
  802e6f:	05 44 10 81 00       	add    $0x811044,%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	01 c1                	add    %eax,%ecx
  802e78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7b:	89 d0                	mov    %edx,%eax
  802e7d:	01 c0                	add    %eax,%eax
  802e7f:	01 d0                	add    %edx,%eax
  802e81:	c1 e0 02             	shl    $0x2,%eax
  802e84:	05 44 10 81 00       	add    $0x811044,%eax
  802e89:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802e8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e8e:	89 d0                	mov    %edx,%eax
  802e90:	01 c0                	add    %eax,%eax
  802e92:	01 d0                	add    %edx,%eax
  802e94:	c1 e0 02             	shl    $0x2,%eax
  802e97:	05 48 10 81 00       	add    $0x811048,%eax
  802e9c:	c6 00 00             	movb   $0x0,(%eax)
  802e9f:	e9 91 00 00 00       	jmp    802f35 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802ea4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea7:	89 d0                	mov    %edx,%eax
  802ea9:	01 c0                	add    %eax,%eax
  802eab:	01 d0                	add    %edx,%eax
  802ead:	c1 e0 02             	shl    $0x2,%eax
  802eb0:	05 40 10 81 00       	add    $0x811040,%eax
  802eb5:	8b 08                	mov    (%eax),%ecx
  802eb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eba:	89 d0                	mov    %edx,%eax
  802ebc:	01 c0                	add    %eax,%eax
  802ebe:	01 d0                	add    %edx,%eax
  802ec0:	c1 e0 02             	shl    $0x2,%eax
  802ec3:	05 44 10 81 00       	add    $0x811044,%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	01 c1                	add    %eax,%ecx
  802ecc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ecf:	89 d0                	mov    %edx,%eax
  802ed1:	01 c0                	add    %eax,%eax
  802ed3:	01 d0                	add    %edx,%eax
  802ed5:	c1 e0 02             	shl    $0x2,%eax
  802ed8:	05 40 10 81 00       	add    $0x811040,%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	39 c1                	cmp    %eax,%ecx
  802ee1:	75 52                	jne    802f35 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee6:	89 d0                	mov    %edx,%eax
  802ee8:	01 c0                	add    %eax,%eax
  802eea:	01 d0                	add    %edx,%eax
  802eec:	c1 e0 02             	shl    $0x2,%eax
  802eef:	05 44 10 81 00       	add    $0x811044,%eax
  802ef4:	8b 08                	mov    (%eax),%ecx
  802ef6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef9:	89 d0                	mov    %edx,%eax
  802efb:	01 c0                	add    %eax,%eax
  802efd:	01 d0                	add    %edx,%eax
  802eff:	c1 e0 02             	shl    $0x2,%eax
  802f02:	05 44 10 81 00       	add    $0x811044,%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	01 c1                	add    %eax,%ecx
  802f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0e:	89 d0                	mov    %edx,%eax
  802f10:	01 c0                	add    %eax,%eax
  802f12:	01 d0                	add    %edx,%eax
  802f14:	c1 e0 02             	shl    $0x2,%eax
  802f17:	05 44 10 81 00       	add    $0x811044,%eax
  802f1c:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802f1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f21:	89 d0                	mov    %edx,%eax
  802f23:	01 c0                	add    %eax,%eax
  802f25:	01 d0                	add    %edx,%eax
  802f27:	c1 e0 02             	shl    $0x2,%eax
  802f2a:	05 48 10 81 00       	add    $0x811048,%eax
  802f2f:	c6 00 00             	movb   $0x0,(%eax)
  802f32:	eb 01                	jmp    802f35 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802f34:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802f35:	ff 45 e8             	incl   -0x18(%ebp)
  802f38:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802f3f:	0f 8e 7f fe ff ff    	jle    802dc4 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802f45:	a1 30 51 83 00       	mov    0x835130,%eax
  802f4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802f4d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802f54:	eb 53                	jmp    802fa9 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802f56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f59:	89 d0                	mov    %edx,%eax
  802f5b:	01 c0                	add    %eax,%eax
  802f5d:	01 d0                	add    %edx,%eax
  802f5f:	c1 e0 02             	shl    $0x2,%eax
  802f62:	05 48 50 80 00       	add    $0x805048,%eax
  802f67:	8a 00                	mov    (%eax),%al
  802f69:	84 c0                	test   %al,%al
  802f6b:	74 39                	je     802fa6 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802f6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f70:	89 d0                	mov    %edx,%eax
  802f72:	01 c0                	add    %eax,%eax
  802f74:	01 d0                	add    %edx,%eax
  802f76:	c1 e0 02             	shl    $0x2,%eax
  802f79:	05 40 50 80 00       	add    $0x805040,%eax
  802f7e:	8b 08                	mov    (%eax),%ecx
  802f80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f83:	89 d0                	mov    %edx,%eax
  802f85:	01 c0                	add    %eax,%eax
  802f87:	01 d0                	add    %edx,%eax
  802f89:	c1 e0 02             	shl    $0x2,%eax
  802f8c:	05 44 50 80 00       	add    $0x805044,%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	01 c8                	add    %ecx,%eax
  802f95:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802f98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f9b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f9e:	76 06                	jbe    802fa6 <sfree+0x321>
  802fa0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802fa6:	ff 45 e0             	incl   -0x20(%ebp)
  802fa9:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802fb0:	7e a4                	jle    802f56 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb5:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802fba:	eb 16                	jmp    802fd2 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802fbc:	ff 45 f4             	incl   -0xc(%ebp)
  802fbf:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802fc6:	0f 8e 04 fd ff ff    	jle    802cd0 <sfree+0x4b>
  802fcc:	eb 04                	jmp    802fd2 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802fce:	90                   	nop
  802fcf:	eb 01                	jmp    802fd2 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802fd1:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802fd2:	c9                   	leave  
  802fd3:	c3                   	ret    

00802fd4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802fd4:	55                   	push   %ebp
  802fd5:	89 e5                	mov    %esp,%ebp
  802fd7:	57                   	push   %edi
  802fd8:	56                   	push   %esi
  802fd9:	53                   	push   %ebx
  802fda:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fe6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fe9:	8b 7d 18             	mov    0x18(%ebp),%edi
  802fec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802fef:	cd 30                	int    $0x30
  802ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ff7:	83 c4 10             	add    $0x10,%esp
  802ffa:	5b                   	pop    %ebx
  802ffb:	5e                   	pop    %esi
  802ffc:	5f                   	pop    %edi
  802ffd:	5d                   	pop    %ebp
  802ffe:	c3                   	ret    

00802fff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802fff:	55                   	push   %ebp
  803000:	89 e5                	mov    %esp,%ebp
  803002:	83 ec 04             	sub    $0x4,%esp
  803005:	8b 45 10             	mov    0x10(%ebp),%eax
  803008:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80300b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80300e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	6a 00                	push   $0x0
  803017:	51                   	push   %ecx
  803018:	52                   	push   %edx
  803019:	ff 75 0c             	pushl  0xc(%ebp)
  80301c:	50                   	push   %eax
  80301d:	6a 00                	push   $0x0
  80301f:	e8 b0 ff ff ff       	call   802fd4 <syscall>
  803024:	83 c4 18             	add    $0x18,%esp
}
  803027:	90                   	nop
  803028:	c9                   	leave  
  803029:	c3                   	ret    

0080302a <sys_cgetc>:

int
sys_cgetc(void)
{
  80302a:	55                   	push   %ebp
  80302b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80302d:	6a 00                	push   $0x0
  80302f:	6a 00                	push   $0x0
  803031:	6a 00                	push   $0x0
  803033:	6a 00                	push   $0x0
  803035:	6a 00                	push   $0x0
  803037:	6a 02                	push   $0x2
  803039:	e8 96 ff ff ff       	call   802fd4 <syscall>
  80303e:	83 c4 18             	add    $0x18,%esp
}
  803041:	c9                   	leave  
  803042:	c3                   	ret    

00803043 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803043:	55                   	push   %ebp
  803044:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 03                	push   $0x3
  803052:	e8 7d ff ff ff       	call   802fd4 <syscall>
  803057:	83 c4 18             	add    $0x18,%esp
}
  80305a:	90                   	nop
  80305b:	c9                   	leave  
  80305c:	c3                   	ret    

0080305d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80305d:	55                   	push   %ebp
  80305e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803060:	6a 00                	push   $0x0
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	6a 00                	push   $0x0
  80306a:	6a 04                	push   $0x4
  80306c:	e8 63 ff ff ff       	call   802fd4 <syscall>
  803071:	83 c4 18             	add    $0x18,%esp
}
  803074:	90                   	nop
  803075:	c9                   	leave  
  803076:	c3                   	ret    

00803077 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80307a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	6a 00                	push   $0x0
  803086:	52                   	push   %edx
  803087:	50                   	push   %eax
  803088:	6a 08                	push   $0x8
  80308a:	e8 45 ff ff ff       	call   802fd4 <syscall>
  80308f:	83 c4 18             	add    $0x18,%esp
}
  803092:	c9                   	leave  
  803093:	c3                   	ret    

00803094 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803094:	55                   	push   %ebp
  803095:	89 e5                	mov    %esp,%ebp
  803097:	56                   	push   %esi
  803098:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803099:	8b 75 18             	mov    0x18(%ebp),%esi
  80309c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80309f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	56                   	push   %esi
  8030a9:	53                   	push   %ebx
  8030aa:	51                   	push   %ecx
  8030ab:	52                   	push   %edx
  8030ac:	50                   	push   %eax
  8030ad:	6a 09                	push   $0x9
  8030af:	e8 20 ff ff ff       	call   802fd4 <syscall>
  8030b4:	83 c4 18             	add    $0x18,%esp
}
  8030b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030ba:	5b                   	pop    %ebx
  8030bb:	5e                   	pop    %esi
  8030bc:	5d                   	pop    %ebp
  8030bd:	c3                   	ret    

008030be <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8030be:	55                   	push   %ebp
  8030bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8030c1:	6a 00                	push   $0x0
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	ff 75 08             	pushl  0x8(%ebp)
  8030cc:	6a 0a                	push   $0xa
  8030ce:	e8 01 ff ff ff       	call   802fd4 <syscall>
  8030d3:	83 c4 18             	add    $0x18,%esp
}
  8030d6:	c9                   	leave  
  8030d7:	c3                   	ret    

008030d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8030d8:	55                   	push   %ebp
  8030d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8030db:	6a 00                	push   $0x0
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	ff 75 0c             	pushl  0xc(%ebp)
  8030e4:	ff 75 08             	pushl  0x8(%ebp)
  8030e7:	6a 0b                	push   $0xb
  8030e9:	e8 e6 fe ff ff       	call   802fd4 <syscall>
  8030ee:	83 c4 18             	add    $0x18,%esp
}
  8030f1:	c9                   	leave  
  8030f2:	c3                   	ret    

008030f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 00                	push   $0x0
  8030fe:	6a 00                	push   $0x0
  803100:	6a 0c                	push   $0xc
  803102:	e8 cd fe ff ff       	call   802fd4 <syscall>
  803107:	83 c4 18             	add    $0x18,%esp
}
  80310a:	c9                   	leave  
  80310b:	c3                   	ret    

0080310c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80310c:	55                   	push   %ebp
  80310d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	6a 00                	push   $0x0
  803119:	6a 0d                	push   $0xd
  80311b:	e8 b4 fe ff ff       	call   802fd4 <syscall>
  803120:	83 c4 18             	add    $0x18,%esp
}
  803123:	c9                   	leave  
  803124:	c3                   	ret    

00803125 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803125:	55                   	push   %ebp
  803126:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 0e                	push   $0xe
  803134:	e8 9b fe ff ff       	call   802fd4 <syscall>
  803139:	83 c4 18             	add    $0x18,%esp
}
  80313c:	c9                   	leave  
  80313d:	c3                   	ret    

0080313e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80313e:	55                   	push   %ebp
  80313f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803141:	6a 00                	push   $0x0
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 00                	push   $0x0
  80314b:	6a 0f                	push   $0xf
  80314d:	e8 82 fe ff ff       	call   802fd4 <syscall>
  803152:	83 c4 18             	add    $0x18,%esp
}
  803155:	c9                   	leave  
  803156:	c3                   	ret    

00803157 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803157:	55                   	push   %ebp
  803158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80315a:	6a 00                	push   $0x0
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 00                	push   $0x0
  803162:	ff 75 08             	pushl  0x8(%ebp)
  803165:	6a 10                	push   $0x10
  803167:	e8 68 fe ff ff       	call   802fd4 <syscall>
  80316c:	83 c4 18             	add    $0x18,%esp
}
  80316f:	c9                   	leave  
  803170:	c3                   	ret    

00803171 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803171:	55                   	push   %ebp
  803172:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 00                	push   $0x0
  80317e:	6a 11                	push   $0x11
  803180:	e8 4f fe ff ff       	call   802fd4 <syscall>
  803185:	83 c4 18             	add    $0x18,%esp
}
  803188:	90                   	nop
  803189:	c9                   	leave  
  80318a:	c3                   	ret    

0080318b <sys_cputc>:

void
sys_cputc(const char c)
{
  80318b:	55                   	push   %ebp
  80318c:	89 e5                	mov    %esp,%ebp
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803197:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80319b:	6a 00                	push   $0x0
  80319d:	6a 00                	push   $0x0
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 00                	push   $0x0
  8031a3:	50                   	push   %eax
  8031a4:	6a 01                	push   $0x1
  8031a6:	e8 29 fe ff ff       	call   802fd4 <syscall>
  8031ab:	83 c4 18             	add    $0x18,%esp
}
  8031ae:	90                   	nop
  8031af:	c9                   	leave  
  8031b0:	c3                   	ret    

008031b1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8031b1:	55                   	push   %ebp
  8031b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8031b4:	6a 00                	push   $0x0
  8031b6:	6a 00                	push   $0x0
  8031b8:	6a 00                	push   $0x0
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 14                	push   $0x14
  8031c0:	e8 0f fe ff ff       	call   802fd4 <syscall>
  8031c5:	83 c4 18             	add    $0x18,%esp
}
  8031c8:	90                   	nop
  8031c9:	c9                   	leave  
  8031ca:	c3                   	ret    

008031cb <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8031cb:	55                   	push   %ebp
  8031cc:	89 e5                	mov    %esp,%ebp
  8031ce:	83 ec 04             	sub    $0x4,%esp
  8031d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8031d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8031d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	6a 00                	push   $0x0
  8031e3:	51                   	push   %ecx
  8031e4:	52                   	push   %edx
  8031e5:	ff 75 0c             	pushl  0xc(%ebp)
  8031e8:	50                   	push   %eax
  8031e9:	6a 15                	push   $0x15
  8031eb:	e8 e4 fd ff ff       	call   802fd4 <syscall>
  8031f0:	83 c4 18             	add    $0x18,%esp
}
  8031f3:	c9                   	leave  
  8031f4:	c3                   	ret    

008031f5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8031f5:	55                   	push   %ebp
  8031f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	6a 00                	push   $0x0
  803200:	6a 00                	push   $0x0
  803202:	6a 00                	push   $0x0
  803204:	52                   	push   %edx
  803205:	50                   	push   %eax
  803206:	6a 16                	push   $0x16
  803208:	e8 c7 fd ff ff       	call   802fd4 <syscall>
  80320d:	83 c4 18             	add    $0x18,%esp
}
  803210:	c9                   	leave  
  803211:	c3                   	ret    

00803212 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803212:	55                   	push   %ebp
  803213:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803215:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	6a 00                	push   $0x0
  803220:	6a 00                	push   $0x0
  803222:	51                   	push   %ecx
  803223:	52                   	push   %edx
  803224:	50                   	push   %eax
  803225:	6a 17                	push   $0x17
  803227:	e8 a8 fd ff ff       	call   802fd4 <syscall>
  80322c:	83 c4 18             	add    $0x18,%esp
}
  80322f:	c9                   	leave  
  803230:	c3                   	ret    

00803231 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803231:	55                   	push   %ebp
  803232:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803234:	8b 55 0c             	mov    0xc(%ebp),%edx
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	52                   	push   %edx
  803241:	50                   	push   %eax
  803242:	6a 18                	push   $0x18
  803244:	e8 8b fd ff ff       	call   802fd4 <syscall>
  803249:	83 c4 18             	add    $0x18,%esp
}
  80324c:	c9                   	leave  
  80324d:	c3                   	ret    

0080324e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80324e:	55                   	push   %ebp
  80324f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	6a 00                	push   $0x0
  803256:	ff 75 14             	pushl  0x14(%ebp)
  803259:	ff 75 10             	pushl  0x10(%ebp)
  80325c:	ff 75 0c             	pushl  0xc(%ebp)
  80325f:	50                   	push   %eax
  803260:	6a 19                	push   $0x19
  803262:	e8 6d fd ff ff       	call   802fd4 <syscall>
  803267:	83 c4 18             	add    $0x18,%esp
}
  80326a:	c9                   	leave  
  80326b:	c3                   	ret    

0080326c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	6a 00                	push   $0x0
  803274:	6a 00                	push   $0x0
  803276:	6a 00                	push   $0x0
  803278:	6a 00                	push   $0x0
  80327a:	50                   	push   %eax
  80327b:	6a 1a                	push   $0x1a
  80327d:	e8 52 fd ff ff       	call   802fd4 <syscall>
  803282:	83 c4 18             	add    $0x18,%esp
}
  803285:	90                   	nop
  803286:	c9                   	leave  
  803287:	c3                   	ret    

00803288 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803288:	55                   	push   %ebp
  803289:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	6a 00                	push   $0x0
  803290:	6a 00                	push   $0x0
  803292:	6a 00                	push   $0x0
  803294:	6a 00                	push   $0x0
  803296:	50                   	push   %eax
  803297:	6a 1b                	push   $0x1b
  803299:	e8 36 fd ff ff       	call   802fd4 <syscall>
  80329e:	83 c4 18             	add    $0x18,%esp
}
  8032a1:	c9                   	leave  
  8032a2:	c3                   	ret    

008032a3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8032a3:	55                   	push   %ebp
  8032a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8032a6:	6a 00                	push   $0x0
  8032a8:	6a 00                	push   $0x0
  8032aa:	6a 00                	push   $0x0
  8032ac:	6a 00                	push   $0x0
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 05                	push   $0x5
  8032b2:	e8 1d fd ff ff       	call   802fd4 <syscall>
  8032b7:	83 c4 18             	add    $0x18,%esp
}
  8032ba:	c9                   	leave  
  8032bb:	c3                   	ret    

008032bc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8032bc:	55                   	push   %ebp
  8032bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8032bf:	6a 00                	push   $0x0
  8032c1:	6a 00                	push   $0x0
  8032c3:	6a 00                	push   $0x0
  8032c5:	6a 00                	push   $0x0
  8032c7:	6a 00                	push   $0x0
  8032c9:	6a 06                	push   $0x6
  8032cb:	e8 04 fd ff ff       	call   802fd4 <syscall>
  8032d0:	83 c4 18             	add    $0x18,%esp
}
  8032d3:	c9                   	leave  
  8032d4:	c3                   	ret    

008032d5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8032d5:	55                   	push   %ebp
  8032d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8032d8:	6a 00                	push   $0x0
  8032da:	6a 00                	push   $0x0
  8032dc:	6a 00                	push   $0x0
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 07                	push   $0x7
  8032e4:	e8 eb fc ff ff       	call   802fd4 <syscall>
  8032e9:	83 c4 18             	add    $0x18,%esp
}
  8032ec:	c9                   	leave  
  8032ed:	c3                   	ret    

008032ee <sys_exit_env>:


void sys_exit_env(void)
{
  8032ee:	55                   	push   %ebp
  8032ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032f1:	6a 00                	push   $0x0
  8032f3:	6a 00                	push   $0x0
  8032f5:	6a 00                	push   $0x0
  8032f7:	6a 00                	push   $0x0
  8032f9:	6a 00                	push   $0x0
  8032fb:	6a 1c                	push   $0x1c
  8032fd:	e8 d2 fc ff ff       	call   802fd4 <syscall>
  803302:	83 c4 18             	add    $0x18,%esp
}
  803305:	90                   	nop
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803308:	55                   	push   %ebp
  803309:	89 e5                	mov    %esp,%ebp
  80330b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80330e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803311:	8d 50 04             	lea    0x4(%eax),%edx
  803314:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803317:	6a 00                	push   $0x0
  803319:	6a 00                	push   $0x0
  80331b:	6a 00                	push   $0x0
  80331d:	52                   	push   %edx
  80331e:	50                   	push   %eax
  80331f:	6a 1d                	push   $0x1d
  803321:	e8 ae fc ff ff       	call   802fd4 <syscall>
  803326:	83 c4 18             	add    $0x18,%esp
	return result;
  803329:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80332c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80332f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803332:	89 01                	mov    %eax,(%ecx)
  803334:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	c9                   	leave  
  80333b:	c2 04 00             	ret    $0x4

0080333e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80333e:	55                   	push   %ebp
  80333f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803341:	6a 00                	push   $0x0
  803343:	6a 00                	push   $0x0
  803345:	ff 75 10             	pushl  0x10(%ebp)
  803348:	ff 75 0c             	pushl  0xc(%ebp)
  80334b:	ff 75 08             	pushl  0x8(%ebp)
  80334e:	6a 13                	push   $0x13
  803350:	e8 7f fc ff ff       	call   802fd4 <syscall>
  803355:	83 c4 18             	add    $0x18,%esp
	return ;
  803358:	90                   	nop
}
  803359:	c9                   	leave  
  80335a:	c3                   	ret    

0080335b <sys_rcr2>:
uint32 sys_rcr2()
{
  80335b:	55                   	push   %ebp
  80335c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80335e:	6a 00                	push   $0x0
  803360:	6a 00                	push   $0x0
  803362:	6a 00                	push   $0x0
  803364:	6a 00                	push   $0x0
  803366:	6a 00                	push   $0x0
  803368:	6a 1e                	push   $0x1e
  80336a:	e8 65 fc ff ff       	call   802fd4 <syscall>
  80336f:	83 c4 18             	add    $0x18,%esp
}
  803372:	c9                   	leave  
  803373:	c3                   	ret    

00803374 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803374:	55                   	push   %ebp
  803375:	89 e5                	mov    %esp,%ebp
  803377:	83 ec 04             	sub    $0x4,%esp
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803380:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803384:	6a 00                	push   $0x0
  803386:	6a 00                	push   $0x0
  803388:	6a 00                	push   $0x0
  80338a:	6a 00                	push   $0x0
  80338c:	50                   	push   %eax
  80338d:	6a 1f                	push   $0x1f
  80338f:	e8 40 fc ff ff       	call   802fd4 <syscall>
  803394:	83 c4 18             	add    $0x18,%esp
	return ;
  803397:	90                   	nop
}
  803398:	c9                   	leave  
  803399:	c3                   	ret    

0080339a <rsttst>:
void rsttst()
{
  80339a:	55                   	push   %ebp
  80339b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80339d:	6a 00                	push   $0x0
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 00                	push   $0x0
  8033a5:	6a 00                	push   $0x0
  8033a7:	6a 21                	push   $0x21
  8033a9:	e8 26 fc ff ff       	call   802fd4 <syscall>
  8033ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8033b1:	90                   	nop
}
  8033b2:	c9                   	leave  
  8033b3:	c3                   	ret    

008033b4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8033b4:	55                   	push   %ebp
  8033b5:	89 e5                	mov    %esp,%ebp
  8033b7:	83 ec 04             	sub    $0x4,%esp
  8033ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8033bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8033c0:	8b 55 18             	mov    0x18(%ebp),%edx
  8033c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8033c7:	52                   	push   %edx
  8033c8:	50                   	push   %eax
  8033c9:	ff 75 10             	pushl  0x10(%ebp)
  8033cc:	ff 75 0c             	pushl  0xc(%ebp)
  8033cf:	ff 75 08             	pushl  0x8(%ebp)
  8033d2:	6a 20                	push   $0x20
  8033d4:	e8 fb fb ff ff       	call   802fd4 <syscall>
  8033d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8033dc:	90                   	nop
}
  8033dd:	c9                   	leave  
  8033de:	c3                   	ret    

008033df <chktst>:
void chktst(uint32 n)
{
  8033df:	55                   	push   %ebp
  8033e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 00                	push   $0x0
  8033e8:	6a 00                	push   $0x0
  8033ea:	ff 75 08             	pushl  0x8(%ebp)
  8033ed:	6a 22                	push   $0x22
  8033ef:	e8 e0 fb ff ff       	call   802fd4 <syscall>
  8033f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8033f7:	90                   	nop
}
  8033f8:	c9                   	leave  
  8033f9:	c3                   	ret    

008033fa <inctst>:

void inctst()
{
  8033fa:	55                   	push   %ebp
  8033fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033fd:	6a 00                	push   $0x0
  8033ff:	6a 00                	push   $0x0
  803401:	6a 00                	push   $0x0
  803403:	6a 00                	push   $0x0
  803405:	6a 00                	push   $0x0
  803407:	6a 23                	push   $0x23
  803409:	e8 c6 fb ff ff       	call   802fd4 <syscall>
  80340e:	83 c4 18             	add    $0x18,%esp
	return ;
  803411:	90                   	nop
}
  803412:	c9                   	leave  
  803413:	c3                   	ret    

00803414 <gettst>:
uint32 gettst()
{
  803414:	55                   	push   %ebp
  803415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803417:	6a 00                	push   $0x0
  803419:	6a 00                	push   $0x0
  80341b:	6a 00                	push   $0x0
  80341d:	6a 00                	push   $0x0
  80341f:	6a 00                	push   $0x0
  803421:	6a 24                	push   $0x24
  803423:	e8 ac fb ff ff       	call   802fd4 <syscall>
  803428:	83 c4 18             	add    $0x18,%esp
}
  80342b:	c9                   	leave  
  80342c:	c3                   	ret    

0080342d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80342d:	55                   	push   %ebp
  80342e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803430:	6a 00                	push   $0x0
  803432:	6a 00                	push   $0x0
  803434:	6a 00                	push   $0x0
  803436:	6a 00                	push   $0x0
  803438:	6a 00                	push   $0x0
  80343a:	6a 25                	push   $0x25
  80343c:	e8 93 fb ff ff       	call   802fd4 <syscall>
  803441:	83 c4 18             	add    $0x18,%esp
  803444:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803449:	a1 80 50 83 00       	mov    0x835080,%eax
}
  80344e:	c9                   	leave  
  80344f:	c3                   	ret    

00803450 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803450:	55                   	push   %ebp
  803451:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803453:	8b 45 08             	mov    0x8(%ebp),%eax
  803456:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80345b:	6a 00                	push   $0x0
  80345d:	6a 00                	push   $0x0
  80345f:	6a 00                	push   $0x0
  803461:	6a 00                	push   $0x0
  803463:	ff 75 08             	pushl  0x8(%ebp)
  803466:	6a 26                	push   $0x26
  803468:	e8 67 fb ff ff       	call   802fd4 <syscall>
  80346d:	83 c4 18             	add    $0x18,%esp
	return ;
  803470:	90                   	nop
}
  803471:	c9                   	leave  
  803472:	c3                   	ret    

00803473 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803473:	55                   	push   %ebp
  803474:	89 e5                	mov    %esp,%ebp
  803476:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803477:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80347a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80347d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	6a 00                	push   $0x0
  803485:	53                   	push   %ebx
  803486:	51                   	push   %ecx
  803487:	52                   	push   %edx
  803488:	50                   	push   %eax
  803489:	6a 27                	push   $0x27
  80348b:	e8 44 fb ff ff       	call   802fd4 <syscall>
  803490:	83 c4 18             	add    $0x18,%esp
}
  803493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803496:	c9                   	leave  
  803497:	c3                   	ret    

00803498 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803498:	55                   	push   %ebp
  803499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80349b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	6a 00                	push   $0x0
  8034a3:	6a 00                	push   $0x0
  8034a5:	6a 00                	push   $0x0
  8034a7:	52                   	push   %edx
  8034a8:	50                   	push   %eax
  8034a9:	6a 28                	push   $0x28
  8034ab:	e8 24 fb ff ff       	call   802fd4 <syscall>
  8034b0:	83 c4 18             	add    $0x18,%esp
}
  8034b3:	c9                   	leave  
  8034b4:	c3                   	ret    

008034b5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8034b5:	55                   	push   %ebp
  8034b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8034b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8034bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	6a 00                	push   $0x0
  8034c3:	51                   	push   %ecx
  8034c4:	ff 75 10             	pushl  0x10(%ebp)
  8034c7:	52                   	push   %edx
  8034c8:	50                   	push   %eax
  8034c9:	6a 29                	push   $0x29
  8034cb:	e8 04 fb ff ff       	call   802fd4 <syscall>
  8034d0:	83 c4 18             	add    $0x18,%esp
}
  8034d3:	c9                   	leave  
  8034d4:	c3                   	ret    

008034d5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8034d5:	55                   	push   %ebp
  8034d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8034d8:	6a 00                	push   $0x0
  8034da:	6a 00                	push   $0x0
  8034dc:	ff 75 10             	pushl  0x10(%ebp)
  8034df:	ff 75 0c             	pushl  0xc(%ebp)
  8034e2:	ff 75 08             	pushl  0x8(%ebp)
  8034e5:	6a 12                	push   $0x12
  8034e7:	e8 e8 fa ff ff       	call   802fd4 <syscall>
  8034ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8034ef:	90                   	nop
}
  8034f0:	c9                   	leave  
  8034f1:	c3                   	ret    

008034f2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8034f2:	55                   	push   %ebp
  8034f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8034f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	6a 00                	push   $0x0
  8034fd:	6a 00                	push   $0x0
  8034ff:	6a 00                	push   $0x0
  803501:	52                   	push   %edx
  803502:	50                   	push   %eax
  803503:	6a 2a                	push   $0x2a
  803505:	e8 ca fa ff ff       	call   802fd4 <syscall>
  80350a:	83 c4 18             	add    $0x18,%esp
	return;
  80350d:	90                   	nop
}
  80350e:	c9                   	leave  
  80350f:	c3                   	ret    

00803510 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803510:	55                   	push   %ebp
  803511:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803513:	6a 00                	push   $0x0
  803515:	6a 00                	push   $0x0
  803517:	6a 00                	push   $0x0
  803519:	6a 00                	push   $0x0
  80351b:	6a 00                	push   $0x0
  80351d:	6a 2b                	push   $0x2b
  80351f:	e8 b0 fa ff ff       	call   802fd4 <syscall>
  803524:	83 c4 18             	add    $0x18,%esp
}
  803527:	c9                   	leave  
  803528:	c3                   	ret    

00803529 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803529:	55                   	push   %ebp
  80352a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80352c:	6a 00                	push   $0x0
  80352e:	6a 00                	push   $0x0
  803530:	6a 00                	push   $0x0
  803532:	ff 75 0c             	pushl  0xc(%ebp)
  803535:	ff 75 08             	pushl  0x8(%ebp)
  803538:	6a 2d                	push   $0x2d
  80353a:	e8 95 fa ff ff       	call   802fd4 <syscall>
  80353f:	83 c4 18             	add    $0x18,%esp
	return;
  803542:	90                   	nop
}
  803543:	c9                   	leave  
  803544:	c3                   	ret    

00803545 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803545:	55                   	push   %ebp
  803546:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803548:	6a 00                	push   $0x0
  80354a:	6a 00                	push   $0x0
  80354c:	6a 00                	push   $0x0
  80354e:	ff 75 0c             	pushl  0xc(%ebp)
  803551:	ff 75 08             	pushl  0x8(%ebp)
  803554:	6a 2c                	push   $0x2c
  803556:	e8 79 fa ff ff       	call   802fd4 <syscall>
  80355b:	83 c4 18             	add    $0x18,%esp
	return ;
  80355e:	90                   	nop
}
  80355f:	c9                   	leave  
  803560:	c3                   	ret    

00803561 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803561:	55                   	push   %ebp
  803562:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803564:	8b 55 0c             	mov    0xc(%ebp),%edx
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	6a 00                	push   $0x0
  80356c:	6a 00                	push   $0x0
  80356e:	6a 00                	push   $0x0
  803570:	52                   	push   %edx
  803571:	50                   	push   %eax
  803572:	6a 2e                	push   $0x2e
  803574:	e8 5b fa ff ff       	call   802fd4 <syscall>
  803579:	83 c4 18             	add    $0x18,%esp
}
  80357c:	90                   	nop
  80357d:	c9                   	leave  
  80357e:	c3                   	ret    

0080357f <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80357f:	55                   	push   %ebp
  803580:	89 e5                	mov    %esp,%ebp
  803582:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803585:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  80358c:	72 09                	jb     803597 <to_page_va+0x18>
  80358e:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803595:	72 14                	jb     8035ab <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803597:	83 ec 04             	sub    $0x4,%esp
  80359a:	68 38 4d 80 00       	push   $0x804d38
  80359f:	6a 15                	push   $0x15
  8035a1:	68 63 4d 80 00       	push   $0x804d63
  8035a6:	e8 10 d0 ff ff       	call   8005bb <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8035b3:	29 d0                	sub    %edx,%eax
  8035b5:	c1 f8 02             	sar    $0x2,%eax
  8035b8:	89 c2                	mov    %eax,%edx
  8035ba:	89 d0                	mov    %edx,%eax
  8035bc:	c1 e0 02             	shl    $0x2,%eax
  8035bf:	01 d0                	add    %edx,%eax
  8035c1:	c1 e0 02             	shl    $0x2,%eax
  8035c4:	01 d0                	add    %edx,%eax
  8035c6:	c1 e0 02             	shl    $0x2,%eax
  8035c9:	01 d0                	add    %edx,%eax
  8035cb:	89 c1                	mov    %eax,%ecx
  8035cd:	c1 e1 08             	shl    $0x8,%ecx
  8035d0:	01 c8                	add    %ecx,%eax
  8035d2:	89 c1                	mov    %eax,%ecx
  8035d4:	c1 e1 10             	shl    $0x10,%ecx
  8035d7:	01 c8                	add    %ecx,%eax
  8035d9:	01 c0                	add    %eax,%eax
  8035db:	01 d0                	add    %edx,%eax
  8035dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8035e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e3:	c1 e0 0c             	shl    $0xc,%eax
  8035e6:	89 c2                	mov    %eax,%edx
  8035e8:	a1 84 50 83 00       	mov    0x835084,%eax
  8035ed:	01 d0                	add    %edx,%eax
}
  8035ef:	c9                   	leave  
  8035f0:	c3                   	ret    

008035f1 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8035f1:	55                   	push   %ebp
  8035f2:	89 e5                	mov    %esp,%ebp
  8035f4:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8035f7:	a1 84 50 83 00       	mov    0x835084,%eax
  8035fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ff:	29 c2                	sub    %eax,%edx
  803601:	89 d0                	mov    %edx,%eax
  803603:	c1 e8 0c             	shr    $0xc,%eax
  803606:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360d:	78 09                	js     803618 <to_page_info+0x27>
  80360f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803616:	7e 14                	jle    80362c <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	68 7c 4d 80 00       	push   $0x804d7c
  803620:	6a 21                	push   $0x21
  803622:	68 63 4d 80 00       	push   $0x804d63
  803627:	e8 8f cf ff ff       	call   8005bb <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80362c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80362f:	89 d0                	mov    %edx,%eax
  803631:	01 c0                	add    %eax,%eax
  803633:	01 d0                	add    %edx,%eax
  803635:	c1 e0 02             	shl    $0x2,%eax
  803638:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80363d:	c9                   	leave  
  80363e:	c3                   	ret    

0080363f <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80363f:	55                   	push   %ebp
  803640:	89 e5                	mov    %esp,%ebp
  803642:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	05 00 00 00 02       	add    $0x2000000,%eax
  80364d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803650:	73 16                	jae    803668 <initialize_dynamic_allocator+0x29>
  803652:	68 a0 4d 80 00       	push   $0x804da0
  803657:	68 c6 4d 80 00       	push   $0x804dc6
  80365c:	6a 2f                	push   $0x2f
  80365e:	68 63 4d 80 00       	push   $0x804d63
  803663:	e8 53 cf ff ff       	call   8005bb <_panic>
	dynAllocStart = daStart;
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803670:	8b 45 0c             	mov    0xc(%ebp),%eax
  803673:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803678:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80367f:	eb 36                	jmp    8036b7 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803684:	c1 e0 04             	shl    $0x4,%eax
  803687:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80368c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	c1 e0 04             	shl    $0x4,%eax
  803698:	05 a4 50 83 00       	add    $0x8350a4,%eax
  80369d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	c1 e0 04             	shl    $0x4,%eax
  8036a9:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8036ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036b4:	ff 45 f4             	incl   -0xc(%ebp)
  8036b7:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8036bb:	7e c4                	jle    803681 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8036bd:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8036c4:	00 00 00 
  8036c7:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8036ce:	00 00 00 
  8036d1:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8036d8:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8036e2:	e9 1b 01 00 00       	jmp    803802 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8036e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ea:	89 d0                	mov    %edx,%eax
  8036ec:	01 c0                	add    %eax,%eax
  8036ee:	01 d0                	add    %edx,%eax
  8036f0:	c1 e0 02             	shl    $0x2,%eax
  8036f3:	05 88 d0 81 00       	add    $0x81d088,%eax
  8036f8:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8036fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803700:	89 d0                	mov    %edx,%eax
  803702:	01 c0                	add    %eax,%eax
  803704:	01 d0                	add    %edx,%eax
  803706:	c1 e0 02             	shl    $0x2,%eax
  803709:	05 8a d0 81 00       	add    $0x81d08a,%eax
  80370e:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803713:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803716:	89 d0                	mov    %edx,%eax
  803718:	01 c0                	add    %eax,%eax
  80371a:	01 d0                	add    %edx,%eax
  80371c:	c1 e0 02             	shl    $0x2,%eax
  80371f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803724:	8b 00                	mov    (%eax),%eax
  803726:	85 c0                	test   %eax,%eax
  803728:	74 2b                	je     803755 <initialize_dynamic_allocator+0x116>
  80372a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80372d:	89 d0                	mov    %edx,%eax
  80372f:	01 c0                	add    %eax,%eax
  803731:	01 d0                	add    %edx,%eax
  803733:	c1 e0 02             	shl    $0x2,%eax
  803736:	05 80 d0 81 00       	add    $0x81d080,%eax
  80373b:	8b 10                	mov    (%eax),%edx
  80373d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803740:	89 c8                	mov    %ecx,%eax
  803742:	01 c0                	add    %eax,%eax
  803744:	01 c8                	add    %ecx,%eax
  803746:	c1 e0 02             	shl    $0x2,%eax
  803749:	05 84 d0 81 00       	add    $0x81d084,%eax
  80374e:	8b 00                	mov    (%eax),%eax
  803750:	89 42 04             	mov    %eax,0x4(%edx)
  803753:	eb 18                	jmp    80376d <initialize_dynamic_allocator+0x12e>
  803755:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803758:	89 d0                	mov    %edx,%eax
  80375a:	01 c0                	add    %eax,%eax
  80375c:	01 d0                	add    %edx,%eax
  80375e:	c1 e0 02             	shl    $0x2,%eax
  803761:	05 84 d0 81 00       	add    $0x81d084,%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80376d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803770:	89 d0                	mov    %edx,%eax
  803772:	01 c0                	add    %eax,%eax
  803774:	01 d0                	add    %edx,%eax
  803776:	c1 e0 02             	shl    $0x2,%eax
  803779:	05 84 d0 81 00       	add    $0x81d084,%eax
  80377e:	8b 00                	mov    (%eax),%eax
  803780:	85 c0                	test   %eax,%eax
  803782:	74 2a                	je     8037ae <initialize_dynamic_allocator+0x16f>
  803784:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803787:	89 d0                	mov    %edx,%eax
  803789:	01 c0                	add    %eax,%eax
  80378b:	01 d0                	add    %edx,%eax
  80378d:	c1 e0 02             	shl    $0x2,%eax
  803790:	05 84 d0 81 00       	add    $0x81d084,%eax
  803795:	8b 10                	mov    (%eax),%edx
  803797:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80379a:	89 c8                	mov    %ecx,%eax
  80379c:	01 c0                	add    %eax,%eax
  80379e:	01 c8                	add    %ecx,%eax
  8037a0:	c1 e0 02             	shl    $0x2,%eax
  8037a3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	89 02                	mov    %eax,(%edx)
  8037ac:	eb 18                	jmp    8037c6 <initialize_dynamic_allocator+0x187>
  8037ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037b1:	89 d0                	mov    %edx,%eax
  8037b3:	01 c0                	add    %eax,%eax
  8037b5:	01 d0                	add    %edx,%eax
  8037b7:	c1 e0 02             	shl    $0x2,%eax
  8037ba:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037bf:	8b 00                	mov    (%eax),%eax
  8037c1:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8037c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037c9:	89 d0                	mov    %edx,%eax
  8037cb:	01 c0                	add    %eax,%eax
  8037cd:	01 d0                	add    %edx,%eax
  8037cf:	c1 e0 02             	shl    $0x2,%eax
  8037d2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037e0:	89 d0                	mov    %edx,%eax
  8037e2:	01 c0                	add    %eax,%eax
  8037e4:	01 d0                	add    %edx,%eax
  8037e6:	c1 e0 02             	shl    $0x2,%eax
  8037e9:	05 84 d0 81 00       	add    $0x81d084,%eax
  8037ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f4:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8037f9:	48                   	dec    %eax
  8037fa:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8037ff:	ff 45 f0             	incl   -0x10(%ebp)
  803802:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803809:	0f 8e d8 fe ff ff    	jle    8036e7 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80380f:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803816:	e9 9d 00 00 00       	jmp    8038b8 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  80381b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803821:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803824:	89 c8                	mov    %ecx,%eax
  803826:	01 c0                	add    %eax,%eax
  803828:	01 c8                	add    %ecx,%eax
  80382a:	c1 e0 02             	shl    $0x2,%eax
  80382d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803832:	89 10                	mov    %edx,(%eax)
  803834:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803837:	89 d0                	mov    %edx,%eax
  803839:	01 c0                	add    %eax,%eax
  80383b:	01 d0                	add    %edx,%eax
  80383d:	c1 e0 02             	shl    $0x2,%eax
  803840:	05 80 d0 81 00       	add    $0x81d080,%eax
  803845:	8b 00                	mov    (%eax),%eax
  803847:	85 c0                	test   %eax,%eax
  803849:	74 1c                	je     803867 <initialize_dynamic_allocator+0x228>
  80384b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803851:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803854:	89 c8                	mov    %ecx,%eax
  803856:	01 c0                	add    %eax,%eax
  803858:	01 c8                	add    %ecx,%eax
  80385a:	c1 e0 02             	shl    $0x2,%eax
  80385d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803862:	89 42 04             	mov    %eax,0x4(%edx)
  803865:	eb 16                	jmp    80387d <initialize_dynamic_allocator+0x23e>
  803867:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80386a:	89 d0                	mov    %edx,%eax
  80386c:	01 c0                	add    %eax,%eax
  80386e:	01 d0                	add    %edx,%eax
  803870:	c1 e0 02             	shl    $0x2,%eax
  803873:	05 80 d0 81 00       	add    $0x81d080,%eax
  803878:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80387d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803880:	89 d0                	mov    %edx,%eax
  803882:	01 c0                	add    %eax,%eax
  803884:	01 d0                	add    %edx,%eax
  803886:	c1 e0 02             	shl    $0x2,%eax
  803889:	05 80 d0 81 00       	add    $0x81d080,%eax
  80388e:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803893:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803896:	89 d0                	mov    %edx,%eax
  803898:	01 c0                	add    %eax,%eax
  80389a:	01 d0                	add    %edx,%eax
  80389c:	c1 e0 02             	shl    $0x2,%eax
  80389f:	05 84 d0 81 00       	add    $0x81d084,%eax
  8038a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038aa:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8038af:	40                   	inc    %eax
  8038b0:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8038b5:	ff 4d ec             	decl   -0x14(%ebp)
  8038b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038bc:	0f 89 59 ff ff ff    	jns    80381b <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8038c2:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8038c9:	00 00 00 
}
  8038cc:	90                   	nop
  8038cd:	c9                   	leave  
  8038ce:	c3                   	ret    

008038cf <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8038cf:	55                   	push   %ebp
  8038d0:	89 e5                	mov    %esp,%ebp
  8038d2:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8038d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d8:	83 ec 0c             	sub    $0xc,%esp
  8038db:	50                   	push   %eax
  8038dc:	e8 10 fd ff ff       	call   8035f1 <to_page_info>
  8038e1:	83 c4 10             	add    $0x10,%esp
  8038e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8038e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ea:	8b 40 08             	mov    0x8(%eax),%eax
  8038ed:	0f b7 c0             	movzwl %ax,%eax
}
  8038f0:	c9                   	leave  
  8038f1:	c3                   	ret    

008038f2 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8038f2:	55                   	push   %ebp
  8038f3:	89 e5                	mov    %esp,%ebp
  8038f5:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8038f8:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8038ff:	76 16                	jbe    803917 <alloc_block+0x25>
  803901:	68 dc 4d 80 00       	push   $0x804ddc
  803906:	68 c6 4d 80 00       	push   $0x804dc6
  80390b:	6a 59                	push   $0x59
  80390d:	68 63 4d 80 00       	push   $0x804d63
  803912:	e8 a4 cc ff ff       	call   8005bb <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803917:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80391e:	eb 08                	jmp    803928 <alloc_block+0x36>
		allocSize <<= 1;
  803920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803923:	01 c0                	add    %eax,%eax
  803925:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80392e:	73 09                	jae    803939 <alloc_block+0x47>
  803930:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803937:	76 e7                	jbe    803920 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803939:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803940:	eb 03                	jmp    803945 <alloc_block+0x53>
		listIndex++;
  803942:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803948:	ba 08 00 00 00       	mov    $0x8,%edx
  80394d:	88 c1                	mov    %al,%cl
  80394f:	d3 e2                	shl    %cl,%edx
  803951:	89 d0                	mov    %edx,%eax
  803953:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803956:	72 ea                	jb     803942 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80395e:	e9 f4 00 00 00       	jmp    803a57 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803963:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803966:	c1 e0 04             	shl    $0x4,%eax
  803969:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80396e:	8b 00                	mov    (%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	0f 84 dc 00 00 00    	je     803a54 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80397b:	c1 e0 04             	shl    $0x4,%eax
  80397e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803983:	8b 00                	mov    (%eax),%eax
  803985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803988:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80398c:	75 14                	jne    8039a2 <alloc_block+0xb0>
  80398e:	83 ec 04             	sub    $0x4,%esp
  803991:	68 fd 4d 80 00       	push   $0x804dfd
  803996:	6a 6b                	push   $0x6b
  803998:	68 63 4d 80 00       	push   $0x804d63
  80399d:	e8 19 cc ff ff       	call   8005bb <_panic>
  8039a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a5:	8b 00                	mov    (%eax),%eax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	74 10                	je     8039bb <alloc_block+0xc9>
  8039ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ae:	8b 00                	mov    (%eax),%eax
  8039b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b3:	8b 52 04             	mov    0x4(%edx),%edx
  8039b6:	89 50 04             	mov    %edx,0x4(%eax)
  8039b9:	eb 14                	jmp    8039cf <alloc_block+0xdd>
  8039bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039be:	8b 40 04             	mov    0x4(%eax),%eax
  8039c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039c4:	c1 e2 04             	shl    $0x4,%edx
  8039c7:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8039cd:	89 02                	mov    %eax,(%edx)
  8039cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d2:	8b 40 04             	mov    0x4(%eax),%eax
  8039d5:	85 c0                	test   %eax,%eax
  8039d7:	74 0f                	je     8039e8 <alloc_block+0xf6>
  8039d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039dc:	8b 40 04             	mov    0x4(%eax),%eax
  8039df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e2:	8b 12                	mov    (%edx),%edx
  8039e4:	89 10                	mov    %edx,(%eax)
  8039e6:	eb 13                	jmp    8039fb <alloc_block+0x109>
  8039e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039eb:	8b 00                	mov    (%eax),%eax
  8039ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039f0:	c1 e2 04             	shl    $0x4,%edx
  8039f3:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8039f9:	89 02                	mov    %eax,(%edx)
  8039fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a11:	c1 e0 04             	shl    $0x4,%eax
  803a14:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a19:	8b 00                	mov    (%eax),%eax
  803a1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a21:	c1 e0 04             	shl    $0x4,%eax
  803a24:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a29:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2e:	83 ec 0c             	sub    $0xc,%esp
  803a31:	50                   	push   %eax
  803a32:	e8 ba fb ff ff       	call   8035f1 <to_page_info>
  803a37:	83 c4 10             	add    $0x10,%esp
  803a3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a40:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a44:	48                   	dec    %eax
  803a45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a48:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4f:	e9 8f 02 00 00       	jmp    803ce3 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a54:	ff 45 ec             	incl   -0x14(%ebp)
  803a57:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803a5b:	0f 8e 02 ff ff ff    	jle    803963 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803a61:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803a66:	85 c0                	test   %eax,%eax
  803a68:	75 14                	jne    803a7e <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803a6a:	83 ec 04             	sub    $0x4,%esp
  803a6d:	68 1c 4e 80 00       	push   $0x804e1c
  803a72:	6a 77                	push   $0x77
  803a74:	68 63 4d 80 00       	push   $0x804d63
  803a79:	e8 3d cb ff ff       	call   8005bb <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803a7e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803a83:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803a86:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a8a:	75 14                	jne    803aa0 <alloc_block+0x1ae>
  803a8c:	83 ec 04             	sub    $0x4,%esp
  803a8f:	68 fd 4d 80 00       	push   $0x804dfd
  803a94:	6a 7a                	push   $0x7a
  803a96:	68 63 4d 80 00       	push   $0x804d63
  803a9b:	e8 1b cb ff ff       	call   8005bb <_panic>
  803aa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aa3:	8b 00                	mov    (%eax),%eax
  803aa5:	85 c0                	test   %eax,%eax
  803aa7:	74 10                	je     803ab9 <alloc_block+0x1c7>
  803aa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aac:	8b 00                	mov    (%eax),%eax
  803aae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ab1:	8b 52 04             	mov    0x4(%edx),%edx
  803ab4:	89 50 04             	mov    %edx,0x4(%eax)
  803ab7:	eb 0b                	jmp    803ac4 <alloc_block+0x1d2>
  803ab9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803abc:	8b 40 04             	mov    0x4(%eax),%eax
  803abf:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803ac4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ac7:	8b 40 04             	mov    0x4(%eax),%eax
  803aca:	85 c0                	test   %eax,%eax
  803acc:	74 0f                	je     803add <alloc_block+0x1eb>
  803ace:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad1:	8b 40 04             	mov    0x4(%eax),%eax
  803ad4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ad7:	8b 12                	mov    (%edx),%edx
  803ad9:	89 10                	mov    %edx,(%eax)
  803adb:	eb 0a                	jmp    803ae7 <alloc_block+0x1f5>
  803add:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ae0:	8b 00                	mov    (%eax),%eax
  803ae2:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803ae7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803af3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803afa:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803aff:	48                   	dec    %eax
  803b00:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803b05:	83 ec 0c             	sub    $0xc,%esp
  803b08:	ff 75 dc             	pushl  -0x24(%ebp)
  803b0b:	e8 6f fa ff ff       	call   80357f <to_page_va>
  803b10:	83 c4 10             	add    $0x10,%esp
  803b13:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803b16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b19:	83 ec 0c             	sub    $0xc,%esp
  803b1c:	50                   	push   %eax
  803b1d:	e8 a0 dc ff ff       	call   8017c2 <get_page>
  803b22:	83 c4 10             	add    $0x10,%esp
  803b25:	85 c0                	test   %eax,%eax
  803b27:	74 14                	je     803b3d <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803b29:	83 ec 04             	sub    $0x4,%esp
  803b2c:	68 44 4e 80 00       	push   $0x804e44
  803b31:	6a 7f                	push   $0x7f
  803b33:	68 63 4d 80 00       	push   $0x804d63
  803b38:	e8 7e ca ff ff       	call   8005bb <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b43:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803b47:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  803b51:	f7 75 f4             	divl   -0xc(%ebp)
  803b54:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b57:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803b5b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b62:	e9 a7 00 00 00       	jmp    803c0e <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803b67:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6d:	01 d0                	add    %edx,%eax
  803b6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803b72:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b76:	75 17                	jne    803b8f <alloc_block+0x29d>
  803b78:	83 ec 04             	sub    $0x4,%esp
  803b7b:	68 6c 4e 80 00       	push   $0x804e6c
  803b80:	68 88 00 00 00       	push   $0x88
  803b85:	68 63 4d 80 00       	push   $0x804d63
  803b8a:	e8 2c ca ff ff       	call   8005bb <_panic>
  803b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b92:	c1 e0 04             	shl    $0x4,%eax
  803b95:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b9a:	8b 10                	mov    (%eax),%edx
  803b9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b9f:	89 10                	mov    %edx,(%eax)
  803ba1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba4:	8b 00                	mov    (%eax),%eax
  803ba6:	85 c0                	test   %eax,%eax
  803ba8:	74 15                	je     803bbf <alloc_block+0x2cd>
  803baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bad:	c1 e0 04             	shl    $0x4,%eax
  803bb0:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bb5:	8b 00                	mov    (%eax),%eax
  803bb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bba:	89 50 04             	mov    %edx,0x4(%eax)
  803bbd:	eb 11                	jmp    803bd0 <alloc_block+0x2de>
  803bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc2:	c1 e0 04             	shl    $0x4,%eax
  803bc5:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803bcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bce:	89 02                	mov    %eax,(%edx)
  803bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bd3:	c1 e0 04             	shl    $0x4,%eax
  803bd6:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803bdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdf:	89 02                	mov    %eax,(%edx)
  803be1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bee:	c1 e0 04             	shl    $0x4,%eax
  803bf1:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bf6:	8b 00                	mov    (%eax),%eax
  803bf8:	8d 50 01             	lea    0x1(%eax),%edx
  803bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bfe:	c1 e0 04             	shl    $0x4,%eax
  803c01:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c06:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0b:	01 45 e8             	add    %eax,-0x18(%ebp)
  803c0e:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803c15:	0f 86 4c ff ff ff    	jbe    803b67 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c1e:	c1 e0 04             	shl    $0x4,%eax
  803c21:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c26:	8b 00                	mov    (%eax),%eax
  803c28:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803c2b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c2f:	75 17                	jne    803c48 <alloc_block+0x356>
  803c31:	83 ec 04             	sub    $0x4,%esp
  803c34:	68 fd 4d 80 00       	push   $0x804dfd
  803c39:	68 8d 00 00 00       	push   $0x8d
  803c3e:	68 63 4d 80 00       	push   $0x804d63
  803c43:	e8 73 c9 ff ff       	call   8005bb <_panic>
  803c48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c4b:	8b 00                	mov    (%eax),%eax
  803c4d:	85 c0                	test   %eax,%eax
  803c4f:	74 10                	je     803c61 <alloc_block+0x36f>
  803c51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c54:	8b 00                	mov    (%eax),%eax
  803c56:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803c59:	8b 52 04             	mov    0x4(%edx),%edx
  803c5c:	89 50 04             	mov    %edx,0x4(%eax)
  803c5f:	eb 14                	jmp    803c75 <alloc_block+0x383>
  803c61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c64:	8b 40 04             	mov    0x4(%eax),%eax
  803c67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c6a:	c1 e2 04             	shl    $0x4,%edx
  803c6d:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c73:	89 02                	mov    %eax,(%edx)
  803c75:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c78:	8b 40 04             	mov    0x4(%eax),%eax
  803c7b:	85 c0                	test   %eax,%eax
  803c7d:	74 0f                	je     803c8e <alloc_block+0x39c>
  803c7f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c82:	8b 40 04             	mov    0x4(%eax),%eax
  803c85:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803c88:	8b 12                	mov    (%edx),%edx
  803c8a:	89 10                	mov    %edx,(%eax)
  803c8c:	eb 13                	jmp    803ca1 <alloc_block+0x3af>
  803c8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c91:	8b 00                	mov    (%eax),%eax
  803c93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c96:	c1 e2 04             	shl    $0x4,%edx
  803c99:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803c9f:	89 02                	mov    %eax,(%edx)
  803ca1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ca4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803caa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb7:	c1 e0 04             	shl    $0x4,%eax
  803cba:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cbf:	8b 00                	mov    (%eax),%eax
  803cc1:	8d 50 ff             	lea    -0x1(%eax),%edx
  803cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc7:	c1 e0 04             	shl    $0x4,%eax
  803cca:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ccf:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803cd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cd4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cd8:	48                   	dec    %eax
  803cd9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803cdc:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803ce0:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803ce3:	c9                   	leave  
  803ce4:	c3                   	ret    

00803ce5 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803ce5:	55                   	push   %ebp
  803ce6:	89 e5                	mov    %esp,%ebp
  803ce8:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  803cee:	a1 84 50 83 00       	mov    0x835084,%eax
  803cf3:	39 c2                	cmp    %eax,%edx
  803cf5:	72 0c                	jb     803d03 <free_block+0x1e>
  803cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  803cfa:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803cff:	39 c2                	cmp    %eax,%edx
  803d01:	72 19                	jb     803d1c <free_block+0x37>
  803d03:	68 90 4e 80 00       	push   $0x804e90
  803d08:	68 c6 4d 80 00       	push   $0x804dc6
  803d0d:	68 98 00 00 00       	push   $0x98
  803d12:	68 63 4d 80 00       	push   $0x804d63
  803d17:	e8 9f c8 ff ff       	call   8005bb <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1f:	83 ec 0c             	sub    $0xc,%esp
  803d22:	50                   	push   %eax
  803d23:	e8 c9 f8 ff ff       	call   8035f1 <to_page_info>
  803d28:	83 c4 10             	add    $0x10,%esp
  803d2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d31:	8b 40 08             	mov    0x8(%eax),%eax
  803d34:	0f b7 c0             	movzwl %ax,%eax
  803d37:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803d3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803d41:	eb 03                	jmp    803d46 <free_block+0x61>
		listIndex++;
  803d43:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d49:	ba 08 00 00 00       	mov    $0x8,%edx
  803d4e:	88 c1                	mov    %al,%cl
  803d50:	d3 e2                	shl    %cl,%edx
  803d52:	89 d0                	mov    %edx,%eax
  803d54:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d57:	72 ea                	jb     803d43 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803d59:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803d5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d63:	75 17                	jne    803d7c <free_block+0x97>
  803d65:	83 ec 04             	sub    $0x4,%esp
  803d68:	68 6c 4e 80 00       	push   $0x804e6c
  803d6d:	68 a2 00 00 00       	push   $0xa2
  803d72:	68 63 4d 80 00       	push   $0x804d63
  803d77:	e8 3f c8 ff ff       	call   8005bb <_panic>
  803d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7f:	c1 e0 04             	shl    $0x4,%eax
  803d82:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d87:	8b 10                	mov    (%eax),%edx
  803d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8c:	89 10                	mov    %edx,(%eax)
  803d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d91:	8b 00                	mov    (%eax),%eax
  803d93:	85 c0                	test   %eax,%eax
  803d95:	74 15                	je     803dac <free_block+0xc7>
  803d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9a:	c1 e0 04             	shl    $0x4,%eax
  803d9d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803da2:	8b 00                	mov    (%eax),%eax
  803da4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da7:	89 50 04             	mov    %edx,0x4(%eax)
  803daa:	eb 11                	jmp    803dbd <free_block+0xd8>
  803dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803daf:	c1 e0 04             	shl    $0x4,%eax
  803db2:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbb:	89 02                	mov    %eax,(%edx)
  803dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc0:	c1 e0 04             	shl    $0x4,%eax
  803dc3:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcc:	89 02                	mov    %eax,(%edx)
  803dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddb:	c1 e0 04             	shl    $0x4,%eax
  803dde:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803de3:	8b 00                	mov    (%eax),%eax
  803de5:	8d 50 01             	lea    0x1(%eax),%edx
  803de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803deb:	c1 e0 04             	shl    $0x4,%eax
  803dee:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803df3:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df8:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803dfc:	40                   	inc    %eax
  803dfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e00:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e07:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e0b:	0f b7 c8             	movzwl %ax,%ecx
  803e0e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e13:	ba 00 00 00 00       	mov    $0x0,%edx
  803e18:	f7 75 e8             	divl   -0x18(%ebp)
  803e1b:	39 c1                	cmp    %eax,%ecx
  803e1d:	0f 85 ed 01 00 00    	jne    804010 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e26:	c1 e0 04             	shl    $0x4,%eax
  803e29:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803e2e:	8b 00                	mov    (%eax),%eax
  803e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803e33:	eb 2a                	jmp    803e5f <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e38:	83 ec 0c             	sub    $0xc,%esp
  803e3b:	50                   	push   %eax
  803e3c:	e8 b0 f7 ff ff       	call   8035f1 <to_page_info>
  803e41:	83 c4 10             	add    $0x10,%esp
  803e44:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803e47:	75 06                	jne    803e4f <free_block+0x16a>
				tmp = b;
  803e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e52:	c1 e0 04             	shl    $0x4,%eax
  803e55:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803e5a:	8b 00                	mov    (%eax),%eax
  803e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803e5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e63:	74 07                	je     803e6c <free_block+0x187>
  803e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e68:	8b 00                	mov    (%eax),%eax
  803e6a:	eb 05                	jmp    803e71 <free_block+0x18c>
  803e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e74:	c1 e2 04             	shl    $0x4,%edx
  803e77:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803e7d:	89 02                	mov    %eax,(%edx)
  803e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e82:	c1 e0 04             	shl    $0x4,%eax
  803e85:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803e8a:	8b 00                	mov    (%eax),%eax
  803e8c:	85 c0                	test   %eax,%eax
  803e8e:	75 a5                	jne    803e35 <free_block+0x150>
  803e90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e94:	75 9f                	jne    803e35 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e99:	c1 e0 04             	shl    $0x4,%eax
  803e9c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ea1:	8b 00                	mov    (%eax),%eax
  803ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803ea6:	e9 cc 00 00 00       	jmp    803f77 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eae:	8b 00                	mov    (%eax),%eax
  803eb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb6:	83 ec 0c             	sub    $0xc,%esp
  803eb9:	50                   	push   %eax
  803eba:	e8 32 f7 ff ff       	call   8035f1 <to_page_info>
  803ebf:	83 c4 10             	add    $0x10,%esp
  803ec2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803ec5:	0f 85 a6 00 00 00    	jne    803f71 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ecf:	75 17                	jne    803ee8 <free_block+0x203>
  803ed1:	83 ec 04             	sub    $0x4,%esp
  803ed4:	68 fd 4d 80 00       	push   $0x804dfd
  803ed9:	68 b5 00 00 00       	push   $0xb5
  803ede:	68 63 4d 80 00       	push   $0x804d63
  803ee3:	e8 d3 c6 ff ff       	call   8005bb <_panic>
  803ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eeb:	8b 00                	mov    (%eax),%eax
  803eed:	85 c0                	test   %eax,%eax
  803eef:	74 10                	je     803f01 <free_block+0x21c>
  803ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef4:	8b 00                	mov    (%eax),%eax
  803ef6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ef9:	8b 52 04             	mov    0x4(%edx),%edx
  803efc:	89 50 04             	mov    %edx,0x4(%eax)
  803eff:	eb 14                	jmp    803f15 <free_block+0x230>
  803f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f04:	8b 40 04             	mov    0x4(%eax),%eax
  803f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f0a:	c1 e2 04             	shl    $0x4,%edx
  803f0d:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803f13:	89 02                	mov    %eax,(%edx)
  803f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f18:	8b 40 04             	mov    0x4(%eax),%eax
  803f1b:	85 c0                	test   %eax,%eax
  803f1d:	74 0f                	je     803f2e <free_block+0x249>
  803f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f22:	8b 40 04             	mov    0x4(%eax),%eax
  803f25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f28:	8b 12                	mov    (%edx),%edx
  803f2a:	89 10                	mov    %edx,(%eax)
  803f2c:	eb 13                	jmp    803f41 <free_block+0x25c>
  803f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f31:	8b 00                	mov    (%eax),%eax
  803f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f36:	c1 e2 04             	shl    $0x4,%edx
  803f39:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803f3f:	89 02                	mov    %eax,(%edx)
  803f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f57:	c1 e0 04             	shl    $0x4,%eax
  803f5a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803f5f:	8b 00                	mov    (%eax),%eax
  803f61:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f67:	c1 e0 04             	shl    $0x4,%eax
  803f6a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803f6f:	89 10                	mov    %edx,(%eax)
			b = next;
  803f71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803f77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f7b:	0f 85 2a ff ff ff    	jne    803eab <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f84:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f8d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803f93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803f97:	75 17                	jne    803fb0 <free_block+0x2cb>
  803f99:	83 ec 04             	sub    $0x4,%esp
  803f9c:	68 6c 4e 80 00       	push   $0x804e6c
  803fa1:	68 bc 00 00 00       	push   $0xbc
  803fa6:	68 63 4d 80 00       	push   $0x804d63
  803fab:	e8 0b c6 ff ff       	call   8005bb <_panic>
  803fb0:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fb9:	89 10                	mov    %edx,(%eax)
  803fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fbe:	8b 00                	mov    (%eax),%eax
  803fc0:	85 c0                	test   %eax,%eax
  803fc2:	74 0d                	je     803fd1 <free_block+0x2ec>
  803fc4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803fc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fcc:	89 50 04             	mov    %edx,0x4(%eax)
  803fcf:	eb 08                	jmp    803fd9 <free_block+0x2f4>
  803fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fd4:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803fd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fdc:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fe4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803feb:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803ff0:	40                   	inc    %eax
  803ff1:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803ff6:	83 ec 0c             	sub    $0xc,%esp
  803ff9:	ff 75 ec             	pushl  -0x14(%ebp)
  803ffc:	e8 7e f5 ff ff       	call   80357f <to_page_va>
  804001:	83 c4 10             	add    $0x10,%esp
  804004:	83 ec 0c             	sub    $0xc,%esp
  804007:	50                   	push   %eax
  804008:	e8 fe d7 ff ff       	call   80180b <return_page>
  80400d:	83 c4 10             	add    $0x10,%esp
	}
}
  804010:	90                   	nop
  804011:	c9                   	leave  
  804012:	c3                   	ret    

00804013 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804013:	55                   	push   %ebp
  804014:	89 e5                	mov    %esp,%ebp
  804016:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804019:	8b 55 08             	mov    0x8(%ebp),%edx
  80401c:	89 d0                	mov    %edx,%eax
  80401e:	c1 e0 02             	shl    $0x2,%eax
  804021:	01 d0                	add    %edx,%eax
  804023:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80402a:	01 d0                	add    %edx,%eax
  80402c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804033:	01 d0                	add    %edx,%eax
  804035:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80403c:	01 d0                	add    %edx,%eax
  80403e:	c1 e0 04             	shl    $0x4,%eax
  804041:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  804044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80404b:	0f 31                	rdtsc  
  80404d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804050:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804056:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804059:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80405c:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80405f:	eb 46                	jmp    8040a7 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804061:	0f 31                	rdtsc  
  804063:	89 45 d0             	mov    %eax,-0x30(%ebp)
  804066:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804069:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80406c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80406f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  804072:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804075:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80407b:	29 c2                	sub    %eax,%edx
  80407d:	89 d0                	mov    %edx,%eax
  80407f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804082:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804088:	89 d1                	mov    %edx,%ecx
  80408a:	29 c1                	sub    %eax,%ecx
  80408c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80408f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804092:	39 c2                	cmp    %eax,%edx
  804094:	0f 97 c0             	seta   %al
  804097:	0f b6 c0             	movzbl %al,%eax
  80409a:	29 c1                	sub    %eax,%ecx
  80409c:	89 c8                	mov    %ecx,%eax
  80409e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8040a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8040a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8040a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8040aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8040ad:	72 b2                	jb     804061 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8040af:	90                   	nop
  8040b0:	c9                   	leave  
  8040b1:	c3                   	ret    

008040b2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8040b2:	55                   	push   %ebp
  8040b3:	89 e5                	mov    %esp,%ebp
  8040b5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8040b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8040bf:	eb 03                	jmp    8040c4 <busy_wait+0x12>
  8040c1:	ff 45 fc             	incl   -0x4(%ebp)
  8040c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8040c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040ca:	72 f5                	jb     8040c1 <busy_wait+0xf>
	return i;
  8040cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8040cf:	c9                   	leave  
  8040d0:	c3                   	ret    
  8040d1:	66 90                	xchg   %ax,%ax
  8040d3:	90                   	nop

008040d4 <__udivdi3>:
  8040d4:	55                   	push   %ebp
  8040d5:	57                   	push   %edi
  8040d6:	56                   	push   %esi
  8040d7:	53                   	push   %ebx
  8040d8:	83 ec 1c             	sub    $0x1c,%esp
  8040db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040eb:	89 ca                	mov    %ecx,%edx
  8040ed:	89 f8                	mov    %edi,%eax
  8040ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040f3:	85 f6                	test   %esi,%esi
  8040f5:	75 2d                	jne    804124 <__udivdi3+0x50>
  8040f7:	39 cf                	cmp    %ecx,%edi
  8040f9:	77 65                	ja     804160 <__udivdi3+0x8c>
  8040fb:	89 fd                	mov    %edi,%ebp
  8040fd:	85 ff                	test   %edi,%edi
  8040ff:	75 0b                	jne    80410c <__udivdi3+0x38>
  804101:	b8 01 00 00 00       	mov    $0x1,%eax
  804106:	31 d2                	xor    %edx,%edx
  804108:	f7 f7                	div    %edi
  80410a:	89 c5                	mov    %eax,%ebp
  80410c:	31 d2                	xor    %edx,%edx
  80410e:	89 c8                	mov    %ecx,%eax
  804110:	f7 f5                	div    %ebp
  804112:	89 c1                	mov    %eax,%ecx
  804114:	89 d8                	mov    %ebx,%eax
  804116:	f7 f5                	div    %ebp
  804118:	89 cf                	mov    %ecx,%edi
  80411a:	89 fa                	mov    %edi,%edx
  80411c:	83 c4 1c             	add    $0x1c,%esp
  80411f:	5b                   	pop    %ebx
  804120:	5e                   	pop    %esi
  804121:	5f                   	pop    %edi
  804122:	5d                   	pop    %ebp
  804123:	c3                   	ret    
  804124:	39 ce                	cmp    %ecx,%esi
  804126:	77 28                	ja     804150 <__udivdi3+0x7c>
  804128:	0f bd fe             	bsr    %esi,%edi
  80412b:	83 f7 1f             	xor    $0x1f,%edi
  80412e:	75 40                	jne    804170 <__udivdi3+0x9c>
  804130:	39 ce                	cmp    %ecx,%esi
  804132:	72 0a                	jb     80413e <__udivdi3+0x6a>
  804134:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804138:	0f 87 9e 00 00 00    	ja     8041dc <__udivdi3+0x108>
  80413e:	b8 01 00 00 00       	mov    $0x1,%eax
  804143:	89 fa                	mov    %edi,%edx
  804145:	83 c4 1c             	add    $0x1c,%esp
  804148:	5b                   	pop    %ebx
  804149:	5e                   	pop    %esi
  80414a:	5f                   	pop    %edi
  80414b:	5d                   	pop    %ebp
  80414c:	c3                   	ret    
  80414d:	8d 76 00             	lea    0x0(%esi),%esi
  804150:	31 ff                	xor    %edi,%edi
  804152:	31 c0                	xor    %eax,%eax
  804154:	89 fa                	mov    %edi,%edx
  804156:	83 c4 1c             	add    $0x1c,%esp
  804159:	5b                   	pop    %ebx
  80415a:	5e                   	pop    %esi
  80415b:	5f                   	pop    %edi
  80415c:	5d                   	pop    %ebp
  80415d:	c3                   	ret    
  80415e:	66 90                	xchg   %ax,%ax
  804160:	89 d8                	mov    %ebx,%eax
  804162:	f7 f7                	div    %edi
  804164:	31 ff                	xor    %edi,%edi
  804166:	89 fa                	mov    %edi,%edx
  804168:	83 c4 1c             	add    $0x1c,%esp
  80416b:	5b                   	pop    %ebx
  80416c:	5e                   	pop    %esi
  80416d:	5f                   	pop    %edi
  80416e:	5d                   	pop    %ebp
  80416f:	c3                   	ret    
  804170:	bd 20 00 00 00       	mov    $0x20,%ebp
  804175:	89 eb                	mov    %ebp,%ebx
  804177:	29 fb                	sub    %edi,%ebx
  804179:	89 f9                	mov    %edi,%ecx
  80417b:	d3 e6                	shl    %cl,%esi
  80417d:	89 c5                	mov    %eax,%ebp
  80417f:	88 d9                	mov    %bl,%cl
  804181:	d3 ed                	shr    %cl,%ebp
  804183:	89 e9                	mov    %ebp,%ecx
  804185:	09 f1                	or     %esi,%ecx
  804187:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80418b:	89 f9                	mov    %edi,%ecx
  80418d:	d3 e0                	shl    %cl,%eax
  80418f:	89 c5                	mov    %eax,%ebp
  804191:	89 d6                	mov    %edx,%esi
  804193:	88 d9                	mov    %bl,%cl
  804195:	d3 ee                	shr    %cl,%esi
  804197:	89 f9                	mov    %edi,%ecx
  804199:	d3 e2                	shl    %cl,%edx
  80419b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80419f:	88 d9                	mov    %bl,%cl
  8041a1:	d3 e8                	shr    %cl,%eax
  8041a3:	09 c2                	or     %eax,%edx
  8041a5:	89 d0                	mov    %edx,%eax
  8041a7:	89 f2                	mov    %esi,%edx
  8041a9:	f7 74 24 0c          	divl   0xc(%esp)
  8041ad:	89 d6                	mov    %edx,%esi
  8041af:	89 c3                	mov    %eax,%ebx
  8041b1:	f7 e5                	mul    %ebp
  8041b3:	39 d6                	cmp    %edx,%esi
  8041b5:	72 19                	jb     8041d0 <__udivdi3+0xfc>
  8041b7:	74 0b                	je     8041c4 <__udivdi3+0xf0>
  8041b9:	89 d8                	mov    %ebx,%eax
  8041bb:	31 ff                	xor    %edi,%edi
  8041bd:	e9 58 ff ff ff       	jmp    80411a <__udivdi3+0x46>
  8041c2:	66 90                	xchg   %ax,%ax
  8041c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041c8:	89 f9                	mov    %edi,%ecx
  8041ca:	d3 e2                	shl    %cl,%edx
  8041cc:	39 c2                	cmp    %eax,%edx
  8041ce:	73 e9                	jae    8041b9 <__udivdi3+0xe5>
  8041d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041d3:	31 ff                	xor    %edi,%edi
  8041d5:	e9 40 ff ff ff       	jmp    80411a <__udivdi3+0x46>
  8041da:	66 90                	xchg   %ax,%ax
  8041dc:	31 c0                	xor    %eax,%eax
  8041de:	e9 37 ff ff ff       	jmp    80411a <__udivdi3+0x46>
  8041e3:	90                   	nop

008041e4 <__umoddi3>:
  8041e4:	55                   	push   %ebp
  8041e5:	57                   	push   %edi
  8041e6:	56                   	push   %esi
  8041e7:	53                   	push   %ebx
  8041e8:	83 ec 1c             	sub    $0x1c,%esp
  8041eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804203:	89 f3                	mov    %esi,%ebx
  804205:	89 fa                	mov    %edi,%edx
  804207:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80420b:	89 34 24             	mov    %esi,(%esp)
  80420e:	85 c0                	test   %eax,%eax
  804210:	75 1a                	jne    80422c <__umoddi3+0x48>
  804212:	39 f7                	cmp    %esi,%edi
  804214:	0f 86 a2 00 00 00    	jbe    8042bc <__umoddi3+0xd8>
  80421a:	89 c8                	mov    %ecx,%eax
  80421c:	89 f2                	mov    %esi,%edx
  80421e:	f7 f7                	div    %edi
  804220:	89 d0                	mov    %edx,%eax
  804222:	31 d2                	xor    %edx,%edx
  804224:	83 c4 1c             	add    $0x1c,%esp
  804227:	5b                   	pop    %ebx
  804228:	5e                   	pop    %esi
  804229:	5f                   	pop    %edi
  80422a:	5d                   	pop    %ebp
  80422b:	c3                   	ret    
  80422c:	39 f0                	cmp    %esi,%eax
  80422e:	0f 87 ac 00 00 00    	ja     8042e0 <__umoddi3+0xfc>
  804234:	0f bd e8             	bsr    %eax,%ebp
  804237:	83 f5 1f             	xor    $0x1f,%ebp
  80423a:	0f 84 ac 00 00 00    	je     8042ec <__umoddi3+0x108>
  804240:	bf 20 00 00 00       	mov    $0x20,%edi
  804245:	29 ef                	sub    %ebp,%edi
  804247:	89 fe                	mov    %edi,%esi
  804249:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80424d:	89 e9                	mov    %ebp,%ecx
  80424f:	d3 e0                	shl    %cl,%eax
  804251:	89 d7                	mov    %edx,%edi
  804253:	89 f1                	mov    %esi,%ecx
  804255:	d3 ef                	shr    %cl,%edi
  804257:	09 c7                	or     %eax,%edi
  804259:	89 e9                	mov    %ebp,%ecx
  80425b:	d3 e2                	shl    %cl,%edx
  80425d:	89 14 24             	mov    %edx,(%esp)
  804260:	89 d8                	mov    %ebx,%eax
  804262:	d3 e0                	shl    %cl,%eax
  804264:	89 c2                	mov    %eax,%edx
  804266:	8b 44 24 08          	mov    0x8(%esp),%eax
  80426a:	d3 e0                	shl    %cl,%eax
  80426c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804270:	8b 44 24 08          	mov    0x8(%esp),%eax
  804274:	89 f1                	mov    %esi,%ecx
  804276:	d3 e8                	shr    %cl,%eax
  804278:	09 d0                	or     %edx,%eax
  80427a:	d3 eb                	shr    %cl,%ebx
  80427c:	89 da                	mov    %ebx,%edx
  80427e:	f7 f7                	div    %edi
  804280:	89 d3                	mov    %edx,%ebx
  804282:	f7 24 24             	mull   (%esp)
  804285:	89 c6                	mov    %eax,%esi
  804287:	89 d1                	mov    %edx,%ecx
  804289:	39 d3                	cmp    %edx,%ebx
  80428b:	0f 82 87 00 00 00    	jb     804318 <__umoddi3+0x134>
  804291:	0f 84 91 00 00 00    	je     804328 <__umoddi3+0x144>
  804297:	8b 54 24 04          	mov    0x4(%esp),%edx
  80429b:	29 f2                	sub    %esi,%edx
  80429d:	19 cb                	sbb    %ecx,%ebx
  80429f:	89 d8                	mov    %ebx,%eax
  8042a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042a5:	d3 e0                	shl    %cl,%eax
  8042a7:	89 e9                	mov    %ebp,%ecx
  8042a9:	d3 ea                	shr    %cl,%edx
  8042ab:	09 d0                	or     %edx,%eax
  8042ad:	89 e9                	mov    %ebp,%ecx
  8042af:	d3 eb                	shr    %cl,%ebx
  8042b1:	89 da                	mov    %ebx,%edx
  8042b3:	83 c4 1c             	add    $0x1c,%esp
  8042b6:	5b                   	pop    %ebx
  8042b7:	5e                   	pop    %esi
  8042b8:	5f                   	pop    %edi
  8042b9:	5d                   	pop    %ebp
  8042ba:	c3                   	ret    
  8042bb:	90                   	nop
  8042bc:	89 fd                	mov    %edi,%ebp
  8042be:	85 ff                	test   %edi,%edi
  8042c0:	75 0b                	jne    8042cd <__umoddi3+0xe9>
  8042c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8042c7:	31 d2                	xor    %edx,%edx
  8042c9:	f7 f7                	div    %edi
  8042cb:	89 c5                	mov    %eax,%ebp
  8042cd:	89 f0                	mov    %esi,%eax
  8042cf:	31 d2                	xor    %edx,%edx
  8042d1:	f7 f5                	div    %ebp
  8042d3:	89 c8                	mov    %ecx,%eax
  8042d5:	f7 f5                	div    %ebp
  8042d7:	89 d0                	mov    %edx,%eax
  8042d9:	e9 44 ff ff ff       	jmp    804222 <__umoddi3+0x3e>
  8042de:	66 90                	xchg   %ax,%ax
  8042e0:	89 c8                	mov    %ecx,%eax
  8042e2:	89 f2                	mov    %esi,%edx
  8042e4:	83 c4 1c             	add    $0x1c,%esp
  8042e7:	5b                   	pop    %ebx
  8042e8:	5e                   	pop    %esi
  8042e9:	5f                   	pop    %edi
  8042ea:	5d                   	pop    %ebp
  8042eb:	c3                   	ret    
  8042ec:	3b 04 24             	cmp    (%esp),%eax
  8042ef:	72 06                	jb     8042f7 <__umoddi3+0x113>
  8042f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042f5:	77 0f                	ja     804306 <__umoddi3+0x122>
  8042f7:	89 f2                	mov    %esi,%edx
  8042f9:	29 f9                	sub    %edi,%ecx
  8042fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042ff:	89 14 24             	mov    %edx,(%esp)
  804302:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804306:	8b 44 24 04          	mov    0x4(%esp),%eax
  80430a:	8b 14 24             	mov    (%esp),%edx
  80430d:	83 c4 1c             	add    $0x1c,%esp
  804310:	5b                   	pop    %ebx
  804311:	5e                   	pop    %esi
  804312:	5f                   	pop    %edi
  804313:	5d                   	pop    %ebp
  804314:	c3                   	ret    
  804315:	8d 76 00             	lea    0x0(%esi),%esi
  804318:	2b 04 24             	sub    (%esp),%eax
  80431b:	19 fa                	sbb    %edi,%edx
  80431d:	89 d1                	mov    %edx,%ecx
  80431f:	89 c6                	mov    %eax,%esi
  804321:	e9 71 ff ff ff       	jmp    804297 <__umoddi3+0xb3>
  804326:	66 90                	xchg   %ax,%ax
  804328:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80432c:	72 ea                	jb     804318 <__umoddi3+0x134>
  80432e:	89 d9                	mov    %ebx,%ecx
  804330:	e9 62 ff ff ff       	jmp    804297 <__umoddi3+0xb3>
