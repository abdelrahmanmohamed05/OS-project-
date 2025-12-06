
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 d1 10 00 00       	call   801107 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <inRange>:
	char a;
	short b;
	int c;
};
int inRange(int val, int min, int max)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	return (val >= min && val <= max) ? 1 : 0;
  80003b:	8b 45 08             	mov    0x8(%ebp),%eax
  80003e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800041:	7c 0f                	jl     800052 <inRange+0x1a>
  800043:	8b 45 08             	mov    0x8(%ebp),%eax
  800046:	3b 45 10             	cmp    0x10(%ebp),%eax
  800049:	7f 07                	jg     800052 <inRange+0x1a>
  80004b:	b8 01 00 00 00       	mov    $0x1,%eax
  800050:	eb 05                	jmp    800057 <inRange+0x1f>
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800057:	5d                   	pop    %ebp
  800058:	c3                   	ret    

00800059 <_main>:
void _main(void)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	53                   	push   %ebx
  80005e:	81 ec 30 01 00 00    	sub    $0x130,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800064:	a1 20 70 80 00       	mov    0x807020,%eax
  800069:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80006f:	a1 20 70 80 00       	mov    0x807020,%eax
  800074:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 80 4f 80 00       	push   $0x804f80
  800086:	6a 1f                	push   $0x1f
  800088:	68 9c 4f 80 00       	push   $0x804f9c
  80008d:	e8 25 12 00 00       	call   8012b7 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	//cprintf("2\n");
	int eval = 0;
  800092:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800099:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  8000a0:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int Mega = 1024*1024;
  8000a7:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000ae:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	char minByte = 1<<7;
  8000b5:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
	char maxByte = 0x7F;
  8000b9:	c6 45 e2 7f          	movb   $0x7f,-0x1e(%ebp)
	short minShort = 1<<15 ;
  8000bd:	66 c7 45 e0 00 80    	movw   $0x8000,-0x20(%ebp)
	short maxShort = 0x7FFF;
  8000c3:	66 c7 45 de ff 7f    	movw   $0x7fff,-0x22(%ebp)
	int minInt = 1<<31 ;
  8000c9:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d0:	c7 45 d4 ff ff ff 7f 	movl   $0x7fffffff,-0x2c(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 13 3d 00 00       	call   803def <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, found;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them [70%]\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 b0 4f 80 00       	push   $0x804fb0
  8000e7:	e8 99 14 00 00       	call   801585 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
	void* ptr_allocations[20] = {0};
  8000ef:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
  8000f5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800103:	e8 e7 3c 00 00       	call   803def <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 2a 3d 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 23 24 00 00       	call   802547 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 10 50 80 00       	push   $0x805010
  800147:	e8 39 14 00 00       	call   801585 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 91 3c 00 00       	call   803def <sys_calculate_free_frames>
  80015e:	29 c3                	sub    %eax,%ebx
  800160:	89 d8                	mov    %ebx,%eax
  800162:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800165:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800168:	83 c0 02             	add    $0x2,%eax
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800172:	ff 75 c0             	pushl  -0x40(%ebp)
  800175:	e8 be fe ff ff       	call   800038 <inRange>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	85 c0                	test   %eax,%eax
  80017f:	75 21                	jne    8001a2 <_main+0x149>
			{is_correct = 0; cprintf("1 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800181:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800188:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80018b:	83 c0 02             	add    $0x2,%eax
  80018e:	ff 75 c0             	pushl  -0x40(%ebp)
  800191:	50                   	push   %eax
  800192:	ff 75 c4             	pushl  -0x3c(%ebp)
  800195:	68 44 50 80 00       	push   $0x805044
  80019a:	e8 e6 13 00 00       	call   801585 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 93 3c 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 b4 50 80 00       	push   $0x8050b4
  8001bb:	e8 c5 13 00 00       	call   801585 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 27 3c 00 00       	call   803def <sys_calculate_free_frames>
  8001c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	01 c0                	add    %eax,%eax
  8001d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d3:	48                   	dec    %eax
  8001d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			byteArr = (char *) ptr_allocations[0];
  8001d7:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8001dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
			byteArr[0] = minByte ;
  8001e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001e3:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  8001e6:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  8001e8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8001eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001ee:	01 c2                	add    %eax,%edx
  8001f0:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8001f3:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  8001f5:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8001fc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8001ff:	e8 eb 3b 00 00       	call   803def <sys_calculate_free_frames>
  800204:	29 c3                	sub    %eax,%ebx
  800206:	89 d8                	mov    %ebx,%eax
  800208:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80020b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80020e:	83 c0 02             	add    $0x2,%eax
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	50                   	push   %eax
  800215:	ff 75 c4             	pushl  -0x3c(%ebp)
  800218:	ff 75 c0             	pushl  -0x40(%ebp)
  80021b:	e8 18 fe ff ff       	call   800038 <inRange>
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	85 c0                	test   %eax,%eax
  800225:	75 1d                	jne    800244 <_main+0x1eb>
			{ is_correct = 0; cprintf("1 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800227:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	ff 75 c0             	pushl  -0x40(%ebp)
  800234:	ff 75 c4             	pushl  -0x3c(%ebp)
  800237:	68 e8 50 80 00       	push   $0x8050e8
  80023c:	e8 44 13 00 00       	call   801585 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800244:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800247:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80024a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80024d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800252:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  800258:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80025b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026b:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800271:	6a 02                	push   $0x2
  800273:	6a 00                	push   $0x0
  800275:	6a 02                	push   $0x2
  800277:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 2e 3f 00 00       	call   8041b1 <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 68 51 80 00       	push   $0x805168
  80029e:	e8 e2 12 00 00       	call   801585 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("4\n");
		if (is_correct)
  8002a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002aa:	74 04                	je     8002b0 <_main+0x257>
		{
			eval += 10;
  8002ac:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8002b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002b7:	e8 33 3b 00 00       	call   803def <sys_calculate_free_frames>
  8002bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002bf:	e8 76 3b 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  8002c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ca:	01 c0                	add    %eax,%eax
  8002cc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	50                   	push   %eax
  8002d3:	e8 6f 22 00 00       	call   802547 <malloc>
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("2 Wrong start address for the allocated space... \n");}
  8002e1:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  8002e7:	89 c2                	mov    %eax,%edx
  8002e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	89 c1                	mov    %eax,%ecx
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	01 c8                	add    %ecx,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 17                	je     800310 <_main+0x2b7>
  8002f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	68 8c 51 80 00       	push   $0x80518c
  800308:	e8 78 12 00 00       	call   801585 <cprintf>
  80030d:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  800310:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800317:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80031a:	e8 d0 3a 00 00       	call   803def <sys_calculate_free_frames>
  80031f:	29 c3                	sub    %eax,%ebx
  800321:	89 d8                	mov    %ebx,%eax
  800323:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800326:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800329:	83 c0 02             	add    $0x2,%eax
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	50                   	push   %eax
  800330:	ff 75 c4             	pushl  -0x3c(%ebp)
  800333:	ff 75 c0             	pushl  -0x40(%ebp)
  800336:	e8 fd fc ff ff       	call   800038 <inRange>
  80033b:	83 c4 10             	add    $0x10,%esp
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 21                	jne    800363 <_main+0x30a>
			{is_correct = 0; cprintf("2 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800342:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800349:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80034c:	83 c0 02             	add    $0x2,%eax
  80034f:	ff 75 c0             	pushl  -0x40(%ebp)
  800352:	50                   	push   %eax
  800353:	ff 75 c4             	pushl  -0x3c(%ebp)
  800356:	68 c0 51 80 00       	push   $0x8051c0
  80035b:	e8 25 12 00 00       	call   801585 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800363:	e8 d2 3a 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800368:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80036b:	74 17                	je     800384 <_main+0x32b>
  80036d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 30 52 80 00       	push   $0x805230
  80037c:	e8 04 12 00 00       	call   801585 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800384:	e8 66 3a 00 00       	call   803def <sys_calculate_free_frames>
  800389:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80038c:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  800392:	89 45 a8             	mov    %eax,-0x58(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80039d:	d1 e8                	shr    %eax
  80039f:	48                   	dec    %eax
  8003a0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			shortArr[0] = minShort;
  8003a3:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8003a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a9:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  8003ac:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	89 c2                	mov    %eax,%edx
  8003b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003b6:	01 c2                	add    %eax,%edx
  8003b8:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8003bc:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 ;
  8003bf:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003c6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003c9:	e8 21 3a 00 00       	call   803def <sys_calculate_free_frames>
  8003ce:	29 c3                	sub    %eax,%ebx
  8003d0:	89 d8                	mov    %ebx,%eax
  8003d2:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8003d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003d8:	83 c0 02             	add    $0x2,%eax
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	50                   	push   %eax
  8003df:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003e2:	ff 75 c0             	pushl  -0x40(%ebp)
  8003e5:	e8 4e fc ff ff       	call   800038 <inRange>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	75 1d                	jne    80040e <_main+0x3b5>
			{ is_correct = 0; cprintf("2 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8003f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	ff 75 c0             	pushl  -0x40(%ebp)
  8003fe:	ff 75 c4             	pushl  -0x3c(%ebp)
  800401:	68 64 52 80 00       	push   $0x805264
  800406:	e8 7a 11 00 00       	call   801585 <cprintf>
  80040b:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  80040e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800411:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800414:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800417:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041c:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  800422:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	89 c2                	mov    %eax,%edx
  800429:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800431:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800434:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800439:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80043f:	6a 02                	push   $0x2
  800441:	6a 00                	push   $0x0
  800443:	6a 02                	push   $0x2
  800445:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80044b:	50                   	push   %eax
  80044c:	e8 60 3d 00 00       	call   8041b1 <sys_check_WS_list>
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800457:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80045b:	74 17                	je     800474 <_main+0x41b>
  80045d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	68 e4 52 80 00       	push   $0x8052e4
  80046c:	e8 14 11 00 00       	call   801585 <cprintf>
  800471:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("5\n");
		if (is_correct)
  800474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800478:	74 04                	je     80047e <_main+0x425>
		{
			eval += 10;
  80047a:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80047e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800485:	e8 b0 39 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  80048a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80048d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800490:	89 c2                	mov    %eax,%edx
  800492:	01 d2                	add    %edx,%edx
  800494:	01 d0                	add    %edx,%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 a8 20 00 00       	call   802547 <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("3 Wrong start address for the allocated space... \n");}
  8004a8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8004ae:	89 c2                	mov    %eax,%edx
  8004b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b3:	c1 e0 02             	shl    $0x2,%eax
  8004b6:	89 c1                	mov    %eax,%ecx
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	01 c8                	add    %ecx,%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x47f>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 08 53 80 00       	push   $0x805308
  8004d0:	e8 b0 10 00 00       	call   801585 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004d8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004df:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e2:	e8 08 39 00 00       	call   803def <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8004ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f1:	83 c0 02             	add    $0x2,%eax
  8004f4:	83 ec 04             	sub    $0x4,%esp
  8004f7:	50                   	push   %eax
  8004f8:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004fb:	ff 75 c0             	pushl  -0x40(%ebp)
  8004fe:	e8 35 fb ff ff       	call   800038 <inRange>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	85 c0                	test   %eax,%eax
  800508:	75 21                	jne    80052b <_main+0x4d2>
			{is_correct = 0; cprintf("3 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80050a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800511:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800514:	83 c0 02             	add    $0x2,%eax
  800517:	ff 75 c0             	pushl  -0x40(%ebp)
  80051a:	50                   	push   %eax
  80051b:	ff 75 c4             	pushl  -0x3c(%ebp)
  80051e:	68 3c 53 80 00       	push   $0x80533c
  800523:	e8 5d 10 00 00       	call   801585 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  80052b:	e8 0a 39 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800530:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800533:	74 17                	je     80054c <_main+0x4f3>
  800535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	68 ac 53 80 00       	push   $0x8053ac
  800544:	e8 3c 10 00 00       	call   801585 <cprintf>
  800549:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80054c:	e8 9e 38 00 00       	call   803def <sys_calculate_free_frames>
  800551:	89 45 cc             	mov    %eax,-0x34(%ebp)
			intArr = (int *) ptr_allocations[2];
  800554:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  80055a:	89 45 98             	mov    %eax,-0x68(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80055d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800560:	01 c0                	add    %eax,%eax
  800562:	c1 e8 02             	shr    $0x2,%eax
  800565:	48                   	dec    %eax
  800566:	89 45 94             	mov    %eax,-0x6c(%ebp)
			intArr[0] = minInt;
  800569:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056f:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  800571:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800574:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80057e:	01 c2                	add    %eax,%edx
  800580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800583:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800585:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80058c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80058f:	e8 5b 38 00 00       	call   803def <sys_calculate_free_frames>
  800594:	29 c3                	sub    %eax,%ebx
  800596:	89 d8                	mov    %ebx,%eax
  800598:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80059b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80059e:	83 c0 02             	add    $0x2,%eax
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	50                   	push   %eax
  8005a5:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005a8:	ff 75 c0             	pushl  -0x40(%ebp)
  8005ab:	e8 88 fa ff ff       	call   800038 <inRange>
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	75 1d                	jne    8005d4 <_main+0x57b>
			{ is_correct = 0; cprintf("3 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8005b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005be:	83 ec 04             	sub    $0x4,%esp
  8005c1:	ff 75 c0             	pushl  -0x40(%ebp)
  8005c4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005c7:	68 e0 53 80 00       	push   $0x8053e0
  8005cc:	e8 b4 0f 00 00       	call   801585 <cprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  8005d4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005d7:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005da:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e2:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8005e8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005f5:	01 d0                	add    %edx,%eax
  8005f7:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005fa:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800602:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800608:	6a 02                	push   $0x2
  80060a:	6a 00                	push   $0x0
  80060c:	6a 02                	push   $0x2
  80060e:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800614:	50                   	push   %eax
  800615:	e8 97 3b 00 00       	call   8041b1 <sys_check_WS_list>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  800620:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800624:	74 17                	je     80063d <_main+0x5e4>
  800626:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80062d:	83 ec 0c             	sub    $0xc,%esp
  800630:	68 60 54 80 00       	push   $0x805460
  800635:	e8 4b 0f 00 00       	call   801585 <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80063d:	e8 f8 37 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800642:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800648:	89 c2                	mov    %eax,%edx
  80064a:	01 d2                	add    %edx,%edx
  80064c:	01 d0                	add    %edx,%eax
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	50                   	push   %eax
  800652:	e8 f0 1e 00 00       	call   802547 <malloc>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) { is_correct = 0; cprintf("4 Wrong start address for the allocated space... \n");}
  800660:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80066b:	c1 e0 02             	shl    $0x2,%eax
  80066e:	89 c1                	mov    %eax,%ecx
  800670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800673:	c1 e0 02             	shl    $0x2,%eax
  800676:	01 c1                	add    %eax,%ecx
  800678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80067b:	01 c8                	add    %ecx,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x63f>
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	68 84 54 80 00       	push   $0x805484
  800690:	e8 f0 0e 00 00       	call   801585 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800698:	e8 9d 37 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x660>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 b8 54 80 00       	push   $0x8054b8
  8006b1:	e8 cf 0e 00 00       	call   801585 <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8006b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006bd:	74 04                	je     8006c3 <_main+0x66a>
		{
			eval += 10;
  8006bf:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8006c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8006ca:	e8 20 37 00 00       	call   803def <sys_calculate_free_frames>
  8006cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006d2:	e8 63 37 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  8006d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  8006da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	01 c0                	add    %eax,%eax
  8006e1:	01 d0                	add    %edx,%eax
  8006e3:	01 c0                	add    %eax,%eax
  8006e5:	01 d0                	add    %edx,%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 57 1e 00 00       	call   802547 <malloc>
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) { is_correct = 0; cprintf("5 Wrong start address for the allocated space... \n");}
  8006f9:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8006ff:	89 c2                	mov    %eax,%edx
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800704:	c1 e0 02             	shl    $0x2,%eax
  800707:	89 c1                	mov    %eax,%ecx
  800709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80070c:	c1 e0 03             	shl    $0x3,%eax
  80070f:	01 c1                	add    %eax,%ecx
  800711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800714:	01 c8                	add    %ecx,%eax
  800716:	39 c2                	cmp    %eax,%edx
  800718:	74 17                	je     800731 <_main+0x6d8>
  80071a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	68 ec 54 80 00       	push   $0x8054ec
  800729:	e8 57 0e 00 00       	call   801585 <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800731:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800738:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80073b:	e8 af 36 00 00       	call   803def <sys_calculate_free_frames>
  800740:	29 c3                	sub    %eax,%ebx
  800742:	89 d8                	mov    %ebx,%eax
  800744:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800747:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80074a:	83 c0 02             	add    $0x2,%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	50                   	push   %eax
  800751:	ff 75 c4             	pushl  -0x3c(%ebp)
  800754:	ff 75 c0             	pushl  -0x40(%ebp)
  800757:	e8 dc f8 ff ff       	call   800038 <inRange>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 21                	jne    800784 <_main+0x72b>
			{is_correct = 0; cprintf("5 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80076a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80076d:	83 c0 02             	add    $0x2,%eax
  800770:	ff 75 c0             	pushl  -0x40(%ebp)
  800773:	50                   	push   %eax
  800774:	ff 75 c4             	pushl  -0x3c(%ebp)
  800777:	68 20 55 80 00       	push   $0x805520
  80077c:	e8 04 0e 00 00       	call   801585 <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800784:	e8 b1 36 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800789:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80078c:	74 17                	je     8007a5 <_main+0x74c>
  80078e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	68 90 55 80 00       	push   $0x805590
  80079d:	e8 e3 0d 00 00       	call   801585 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8007a5:	e8 45 36 00 00       	call   803def <sys_calculate_free_frames>
  8007aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  8007ad:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8007b3:	89 45 88             	mov    %eax,-0x78(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8007b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b9:	89 d0                	mov    %edx,%eax
  8007bb:	01 c0                	add    %eax,%eax
  8007bd:	01 d0                	add    %edx,%eax
  8007bf:	01 c0                	add    %eax,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	c1 e8 03             	shr    $0x3,%eax
  8007c6:	48                   	dec    %eax
  8007c7:	89 45 84             	mov    %eax,-0x7c(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8007ca:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007cd:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  8007d0:	88 10                	mov    %dl,(%eax)
  8007d2:	8b 55 88             	mov    -0x78(%ebp),%edx
  8007d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d8:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007dc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e2:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8007e5:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007ef:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007f2:	01 c2                	add    %eax,%edx
  8007f4:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8007f7:	88 02                	mov    %al,(%edx)
  8007f9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800803:	8b 45 88             	mov    -0x78(%ebp),%eax
  800806:	01 c2                	add    %eax,%edx
  800808:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  80080c:	66 89 42 02          	mov    %ax,0x2(%edx)
  800810:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800813:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80081a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80081d:	01 c2                	add    %eax,%edx
  80081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800822:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  800825:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80082c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80082f:	e8 bb 35 00 00       	call   803def <sys_calculate_free_frames>
  800834:	29 c3                	sub    %eax,%ebx
  800836:	89 d8                	mov    %ebx,%eax
  800838:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80083b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80083e:	83 c0 02             	add    $0x2,%eax
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	50                   	push   %eax
  800845:	ff 75 c4             	pushl  -0x3c(%ebp)
  800848:	ff 75 c0             	pushl  -0x40(%ebp)
  80084b:	e8 e8 f7 ff ff       	call   800038 <inRange>
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	85 c0                	test   %eax,%eax
  800855:	75 1d                	jne    800874 <_main+0x81b>
			{ is_correct = 0; cprintf("5 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800857:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 c0             	pushl  -0x40(%ebp)
  800864:	ff 75 c4             	pushl  -0x3c(%ebp)
  800867:	68 c4 55 80 00       	push   $0x8055c4
  80086c:	e8 14 0d 00 00       	call   801585 <cprintf>
  800871:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800874:	8b 45 88             	mov    -0x78(%ebp),%eax
  800877:	89 45 80             	mov    %eax,-0x80(%ebp)
  80087a:	8b 45 80             	mov    -0x80(%ebp),%eax
  80087d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800882:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  800888:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80088b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800892:	8b 45 88             	mov    -0x78(%ebp),%eax
  800895:	01 d0                	add    %edx,%eax
  800897:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80089d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8008ae:	6a 02                	push   $0x2
  8008b0:	6a 00                	push   $0x0
  8008b2:	6a 02                	push   $0x2
  8008b4:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
  8008ba:	50                   	push   %eax
  8008bb:	e8 f1 38 00 00       	call   8041b1 <sys_check_WS_list>
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  8008c6:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  8008ca:	74 17                	je     8008e3 <_main+0x88a>
  8008cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 44 56 80 00       	push   $0x805644
  8008db:	e8 a5 0c 00 00       	call   801585 <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8008e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8008e7:	74 04                	je     8008ed <_main+0x894>
		{
			eval += 10;
  8008e9:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8008ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008f4:	e8 f6 34 00 00       	call   803def <sys_calculate_free_frames>
  8008f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008fc:	e8 39 35 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800901:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  800904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800907:	89 c2                	mov    %eax,%edx
  800909:	01 d2                	add    %edx,%edx
  80090b:	01 d0                	add    %edx,%eax
  80090d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	50                   	push   %eax
  800914:	e8 2e 1c 00 00       	call   802547 <malloc>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) { is_correct = 0; cprintf("6 Wrong start address for the allocated space... \n");}
  800922:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800928:	89 c2                	mov    %eax,%edx
  80092a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80092d:	c1 e0 02             	shl    $0x2,%eax
  800930:	89 c1                	mov    %eax,%ecx
  800932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800935:	c1 e0 04             	shl    $0x4,%eax
  800938:	01 c1                	add    %eax,%ecx
  80093a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093d:	01 c8                	add    %ecx,%eax
  80093f:	39 c2                	cmp    %eax,%edx
  800941:	74 17                	je     80095a <_main+0x901>
  800943:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094a:	83 ec 0c             	sub    $0xc,%esp
  80094d:	68 68 56 80 00       	push   $0x805668
  800952:	e8 2e 0c 00 00       	call   801585 <cprintf>
  800957:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  80095a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800961:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800964:	e8 86 34 00 00       	call   803def <sys_calculate_free_frames>
  800969:	29 c3                	sub    %eax,%ebx
  80096b:	89 d8                	mov    %ebx,%eax
  80096d:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800970:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800973:	83 c0 02             	add    $0x2,%eax
  800976:	83 ec 04             	sub    $0x4,%esp
  800979:	50                   	push   %eax
  80097a:	ff 75 c4             	pushl  -0x3c(%ebp)
  80097d:	ff 75 c0             	pushl  -0x40(%ebp)
  800980:	e8 b3 f6 ff ff       	call   800038 <inRange>
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	85 c0                	test   %eax,%eax
  80098a:	75 21                	jne    8009ad <_main+0x954>
			{is_correct = 0; cprintf("6 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80098c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800993:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800996:	83 c0 02             	add    $0x2,%eax
  800999:	ff 75 c0             	pushl  -0x40(%ebp)
  80099c:	50                   	push   %eax
  80099d:	ff 75 c4             	pushl  -0x3c(%ebp)
  8009a0:	68 9c 56 80 00       	push   $0x80569c
  8009a5:	e8 db 0b 00 00       	call   801585 <cprintf>
  8009aa:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  8009ad:	e8 88 34 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  8009b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8009b5:	74 17                	je     8009ce <_main+0x975>
  8009b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009be:	83 ec 0c             	sub    $0xc,%esp
  8009c1:	68 0c 57 80 00       	push   $0x80570c
  8009c6:	e8 ba 0b 00 00       	call   801585 <cprintf>
  8009cb:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8009ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009d2:	74 04                	je     8009d8 <_main+0x97f>
		{
			eval += 10;
  8009d4:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8009d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8009df:	e8 0b 34 00 00       	call   803def <sys_calculate_free_frames>
  8009e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8009e7:	e8 4e 34 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  8009ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  8009ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	01 c0                	add    %eax,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009fd:	83 ec 0c             	sub    $0xc,%esp
  800a00:	50                   	push   %eax
  800a01:	e8 41 1b 00 00       	call   802547 <malloc>
  800a06:	83 c4 10             	add    $0x10,%esp
  800a09:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) { is_correct = 0; cprintf("7 Wrong start address for the allocated space... \n");}
  800a0f:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800a15:	89 c1                	mov    %eax,%ecx
  800a17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a1a:	89 d0                	mov    %edx,%eax
  800a1c:	01 c0                	add    %eax,%eax
  800a1e:	01 d0                	add    %edx,%eax
  800a20:	01 c0                	add    %eax,%eax
  800a22:	01 d0                	add    %edx,%eax
  800a24:	89 c2                	mov    %eax,%edx
  800a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a29:	c1 e0 04             	shl    $0x4,%eax
  800a2c:	01 c2                	add    %eax,%edx
  800a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	39 c1                	cmp    %eax,%ecx
  800a35:	74 17                	je     800a4e <_main+0x9f5>
  800a37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a3e:	83 ec 0c             	sub    $0xc,%esp
  800a41:	68 40 57 80 00       	push   $0x805740
  800a46:	e8 3a 0b 00 00       	call   801585 <cprintf>
  800a4b:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  800a4e:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a55:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a58:	e8 92 33 00 00       	call   803def <sys_calculate_free_frames>
  800a5d:	29 c3                	sub    %eax,%ebx
  800a5f:	89 d8                	mov    %ebx,%eax
  800a61:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800a64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a67:	83 c0 02             	add    $0x2,%eax
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	50                   	push   %eax
  800a6e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a71:	ff 75 c0             	pushl  -0x40(%ebp)
  800a74:	e8 bf f5 ff ff       	call   800038 <inRange>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	75 21                	jne    800aa1 <_main+0xa48>
			{is_correct = 0; cprintf("7 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800a80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a8a:	83 c0 02             	add    $0x2,%eax
  800a8d:	ff 75 c0             	pushl  -0x40(%ebp)
  800a90:	50                   	push   %eax
  800a91:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a94:	68 74 57 80 00       	push   $0x805774
  800a99:	e8 e7 0a 00 00       	call   801585 <cprintf>
  800a9e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800aa1:	e8 94 33 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800aa6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800aa9:	74 17                	je     800ac2 <_main+0xa69>
  800aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	68 e4 57 80 00       	push   $0x8057e4
  800aba:	e8 c6 0a 00 00       	call   801585 <cprintf>
  800abf:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800ac2:	e8 28 33 00 00       	call   803def <sys_calculate_free_frames>
  800ac7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800aca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800acd:	89 d0                	mov    %edx,%eax
  800acf:	01 c0                	add    %eax,%eax
  800ad1:	01 d0                	add    %edx,%eax
  800ad3:	01 c0                	add    %eax,%eax
  800ad5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ad8:	48                   	dec    %eax
  800ad9:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  800adf:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ae5:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			byteArr2[0] = minByte ;
  800aeb:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800af1:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  800af4:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800af6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	c1 ea 1f             	shr    $0x1f,%edx
  800b01:	01 d0                	add    %edx,%eax
  800b03:	d1 f8                	sar    %eax
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b0d:	01 c2                	add    %eax,%edx
  800b0f:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800b12:	88 c1                	mov    %al,%cl
  800b14:	c0 e9 07             	shr    $0x7,%cl
  800b17:	01 c8                	add    %ecx,%eax
  800b19:	d0 f8                	sar    %al
  800b1b:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800b1d:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800b23:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b29:	01 c2                	add    %eax,%edx
  800b2b:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800b2e:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 ;
  800b30:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800b37:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800b3a:	e8 b0 32 00 00       	call   803def <sys_calculate_free_frames>
  800b3f:	29 c3                	sub    %eax,%ebx
  800b41:	89 d8                	mov    %ebx,%eax
  800b43:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800b46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b49:	83 c0 02             	add    $0x2,%eax
  800b4c:	83 ec 04             	sub    $0x4,%esp
  800b4f:	50                   	push   %eax
  800b50:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b53:	ff 75 c0             	pushl  -0x40(%ebp)
  800b56:	e8 dd f4 ff ff       	call   800038 <inRange>
  800b5b:	83 c4 10             	add    $0x10,%esp
  800b5e:	85 c0                	test   %eax,%eax
  800b60:	75 1d                	jne    800b7f <_main+0xb26>
			{ is_correct = 0; cprintf("7 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800b62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b69:	83 ec 04             	sub    $0x4,%esp
  800b6c:	ff 75 c0             	pushl  -0x40(%ebp)
  800b6f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b72:	68 18 58 80 00       	push   $0x805818
  800b77:	e8 09 0a 00 00       	call   801585 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800b7f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b85:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800b8b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b96:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  800b9c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800ba2:	89 c2                	mov    %eax,%edx
  800ba4:	c1 ea 1f             	shr    $0x1f,%edx
  800ba7:	01 d0                	add    %edx,%eax
  800ba9:	d1 f8                	sar    %eax
  800bab:	89 c2                	mov    %eax,%edx
  800bad:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800bb3:	01 d0                	add    %edx,%eax
  800bb5:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800bbb:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800bc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc6:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  800bcc:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800bd2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800bd8:	01 d0                	add    %edx,%eax
  800bda:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800be0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800beb:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800bf1:	6a 02                	push   $0x2
  800bf3:	6a 00                	push   $0x0
  800bf5:	6a 03                	push   $0x3
  800bf7:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800bfd:	50                   	push   %eax
  800bfe:	e8 ae 35 00 00       	call   8041b1 <sys_check_WS_list>
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800c09:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800c0d:	74 17                	je     800c26 <_main+0xbcd>
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	68 98 58 80 00       	push   $0x805898
  800c1e:	e8 62 09 00 00       	call   801585 <cprintf>
  800c23:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c2a:	74 04                	je     800c30 <_main+0xbd7>
		{
			eval += 10;
  800c2c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  800c30:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800c37:	e8 b3 31 00 00       	call   803def <sys_calculate_free_frames>
  800c3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c3f:	e8 f6 31 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800c44:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800c47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c4a:	89 d0                	mov    %edx,%eax
  800c4c:	01 c0                	add    %eax,%eax
  800c4e:	01 d0                	add    %edx,%eax
  800c50:	01 c0                	add    %eax,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	e8 e8 18 00 00       	call   802547 <malloc>
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) { is_correct = 0; cprintf("8 Wrong start address for the allocated space... \n");}
  800c68:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800c6e:	89 c1                	mov    %eax,%ecx
  800c70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c73:	89 d0                	mov    %edx,%eax
  800c75:	01 c0                	add    %eax,%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	c1 e0 02             	shl    $0x2,%eax
  800c7c:	01 d0                	add    %edx,%eax
  800c7e:	89 c2                	mov    %eax,%edx
  800c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c83:	c1 e0 04             	shl    $0x4,%eax
  800c86:	01 c2                	add    %eax,%edx
  800c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8b:	01 d0                	add    %edx,%eax
  800c8d:	39 c1                	cmp    %eax,%ecx
  800c8f:	74 17                	je     800ca8 <_main+0xc4f>
  800c91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	68 bc 58 80 00       	push   $0x8058bc
  800ca0:	e8 e0 08 00 00       	call   801585 <cprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800ca8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800caf:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800cb2:	e8 38 31 00 00       	call   803def <sys_calculate_free_frames>
  800cb7:	29 c3                	sub    %eax,%ebx
  800cb9:	89 d8                	mov    %ebx,%eax
  800cbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800cbe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800cc1:	83 c0 02             	add    $0x2,%eax
  800cc4:	83 ec 04             	sub    $0x4,%esp
  800cc7:	50                   	push   %eax
  800cc8:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ccb:	ff 75 c0             	pushl  -0x40(%ebp)
  800cce:	e8 65 f3 ff ff       	call   800038 <inRange>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	75 21                	jne    800cfb <_main+0xca2>
			{is_correct = 0; cprintf("8 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800cda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ce1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ce4:	83 c0 02             	add    $0x2,%eax
  800ce7:	ff 75 c0             	pushl  -0x40(%ebp)
  800cea:	50                   	push   %eax
  800ceb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800cee:	68 f0 58 80 00       	push   $0x8058f0
  800cf3:	e8 8d 08 00 00       	call   801585 <cprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800cfb:	e8 3a 31 00 00       	call   803e3a <sys_pf_calculate_allocated_pages>
  800d00:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800d03:	74 17                	je     800d1c <_main+0xcc3>
  800d05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	68 60 59 80 00       	push   $0x805960
  800d14:	e8 6c 08 00 00       	call   801585 <cprintf>
  800d19:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800d1c:	e8 ce 30 00 00       	call   803def <sys_calculate_free_frames>
  800d21:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800d24:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800d2a:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d33:	89 d0                	mov    %edx,%eax
  800d35:	01 c0                	add    %eax,%eax
  800d37:	01 d0                	add    %edx,%eax
  800d39:	01 c0                	add    %eax,%eax
  800d3b:	01 d0                	add    %edx,%eax
  800d3d:	01 c0                	add    %eax,%eax
  800d3f:	d1 e8                	shr    %eax
  800d41:	48                   	dec    %eax
  800d42:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			shortArr2[0] = minShort;
  800d48:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d51:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800d54:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d5a:	89 c2                	mov    %eax,%edx
  800d5c:	c1 ea 1f             	shr    $0x1f,%edx
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	d1 f8                	sar    %eax
  800d63:	01 c0                	add    %eax,%eax
  800d65:	89 c2                	mov    %eax,%edx
  800d67:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d6d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800d70:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d74:	89 c2                	mov    %eax,%edx
  800d76:	66 c1 ea 0f          	shr    $0xf,%dx
  800d7a:	01 d0                	add    %edx,%eax
  800d7c:	66 d1 f8             	sar    %ax
  800d7f:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800d82:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d88:	01 c0                	add    %eax,%eax
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d92:	01 c2                	add    %eax,%edx
  800d94:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d98:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800d9b:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800da2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800da5:	e8 45 30 00 00       	call   803def <sys_calculate_free_frames>
  800daa:	29 c3                	sub    %eax,%ebx
  800dac:	89 d8                	mov    %ebx,%eax
  800dae:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800db1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800db4:	83 c0 02             	add    $0x2,%eax
  800db7:	83 ec 04             	sub    $0x4,%esp
  800dba:	50                   	push   %eax
  800dbb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800dbe:	ff 75 c0             	pushl  -0x40(%ebp)
  800dc1:	e8 72 f2 ff ff       	call   800038 <inRange>
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	75 1d                	jne    800dea <_main+0xd91>
			{ is_correct = 0; cprintf("8 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800dcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd4:	83 ec 04             	sub    $0x4,%esp
  800dd7:	ff 75 c0             	pushl  -0x40(%ebp)
  800dda:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ddd:	68 94 59 80 00       	push   $0x805994
  800de2:	e8 9e 07 00 00       	call   801585 <cprintf>
  800de7:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800dea:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800df0:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800df6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e01:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  800e07:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	c1 ea 1f             	shr    $0x1f,%edx
  800e12:	01 d0                	add    %edx,%eax
  800e14:	d1 f8                	sar    %eax
  800e16:	01 c0                	add    %eax,%eax
  800e18:	89 c2                	mov    %eax,%edx
  800e1a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800e20:	01 d0                	add    %edx,%eax
  800e22:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800e28:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800e2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e33:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  800e39:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800e3f:	01 c0                	add    %eax,%eax
  800e41:	89 c2                	mov    %eax,%edx
  800e43:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800e49:	01 d0                	add    %edx,%eax
  800e4b:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800e51:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e5c:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800e62:	6a 02                	push   $0x2
  800e64:	6a 00                	push   $0x0
  800e66:	6a 03                	push   $0x3
  800e68:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800e6e:	50                   	push   %eax
  800e6f:	e8 3d 33 00 00       	call   8041b1 <sys_check_WS_list>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e7a:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e7e:	74 17                	je     800e97 <_main+0xe3e>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 14 5a 80 00       	push   $0x805a14
  800e8f:	e8 f1 06 00 00       	call   801585 <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp
		}
	}
	if (is_correct)
  800e97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e9b:	74 04                	je     800ea1 <_main+0xe48>
	{
		eval += 10;
  800e9d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}
	is_correct = 1;
  800ea1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Check that the values are successfully stored
	cprintf("\n%~[2] Check that the values are successfully stored [30%]\n");
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	68 38 5a 80 00       	push   $0x805a38
  800eb0:	e8 d0 06 00 00       	call   801585 <cprintf>
  800eb5:	83 c4 10             	add    $0x10,%esp
	{
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) { is_correct = 0; cprintf("9 Wrong allocation: stored values are wrongly changed!\n");}
  800eb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  800ec0:	75 0f                	jne    800ed1 <_main+0xe78>
  800ec2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	01 d0                	add    %edx,%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  800ecf:	74 17                	je     800ee8 <_main+0xe8f>
  800ed1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	68 74 5a 80 00       	push   $0x805a74
  800ee0:	e8 a0 06 00 00       	call   801585 <cprintf>
  800ee5:	83 c4 10             	add    $0x10,%esp
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) { is_correct = 0; cprintf("10 Wrong allocation: stored values are wrongly changed!\n");}
  800ee8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800eeb:	66 8b 00             	mov    (%eax),%ax
  800eee:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  800ef2:	75 15                	jne    800f09 <_main+0xeb0>
  800ef4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	89 c2                	mov    %eax,%edx
  800efb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800efe:	01 d0                	add    %edx,%eax
  800f00:	66 8b 00             	mov    (%eax),%ax
  800f03:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  800f07:	74 17                	je     800f20 <_main+0xec7>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	83 ec 0c             	sub    $0xc,%esp
  800f13:	68 ac 5a 80 00       	push   $0x805aac
  800f18:	e8 68 06 00 00       	call   801585 <cprintf>
  800f1d:	83 c4 10             	add    $0x10,%esp
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) { is_correct = 0; cprintf("11 Wrong allocation: stored values are wrongly changed!\n");}
  800f20:	8b 45 98             	mov    -0x68(%ebp),%eax
  800f23:	8b 00                	mov    (%eax),%eax
  800f25:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f28:	75 16                	jne    800f40 <_main+0xee7>
  800f2a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f34:	8b 45 98             	mov    -0x68(%ebp),%eax
  800f37:	01 d0                	add    %edx,%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f3e:	74 17                	je     800f57 <_main+0xefe>
  800f40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	68 e8 5a 80 00       	push   $0x805ae8
  800f4f:	e8 31 06 00 00       	call   801585 <cprintf>
  800f54:	83 c4 10             	add    $0x10,%esp

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	{ is_correct = 0; cprintf("12 Wrong allocation: stored values are wrongly changed!\n");}
  800f57:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  800f5f:	75 16                	jne    800f77 <_main+0xf1e>
  800f61:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f64:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800f6b:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f6e:	01 d0                	add    %edx,%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  800f75:	74 17                	je     800f8e <_main+0xf35>
  800f77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	68 24 5b 80 00       	push   $0x805b24
  800f86:	e8 fa 05 00 00       	call   801585 <cprintf>
  800f8b:	83 c4 10             	add    $0x10,%esp
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	{ is_correct = 0; cprintf("13 Wrong allocation: stored values are wrongly changed!\n");}
  800f8e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f91:	66 8b 40 02          	mov    0x2(%eax),%ax
  800f95:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  800f99:	75 19                	jne    800fb4 <_main+0xf5b>
  800f9b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f9e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fa5:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	66 8b 40 02          	mov    0x2(%eax),%ax
  800fae:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  800fb2:	74 17                	je     800fcb <_main+0xf72>
  800fb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	68 60 5b 80 00       	push   $0x805b60
  800fc3:	e8 bd 05 00 00       	call   801585 <cprintf>
  800fc8:	83 c4 10             	add    $0x10,%esp
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	{ is_correct = 0; cprintf("14 Wrong allocation: stored values are wrongly changed!\n");}
  800fcb:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fce:	8b 40 04             	mov    0x4(%eax),%eax
  800fd1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800fd4:	75 17                	jne    800fed <_main+0xf94>
  800fd6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800fd9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fe0:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fe3:	01 d0                	add    %edx,%eax
  800fe5:	8b 40 04             	mov    0x4(%eax),%eax
  800fe8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800feb:	74 17                	je     801004 <_main+0xfab>
  800fed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	68 9c 5b 80 00       	push   $0x805b9c
  800ffc:	e8 84 05 00 00       	call   801585 <cprintf>
  801001:	83 c4 10             	add    $0x10,%esp

		if (byteArr2[0]  != minByte  || byteArr2[lastIndexOfByte2/2]   != maxByte/2 	|| byteArr2[lastIndexOfByte2] 	!= maxByte) { is_correct = 0; cprintf("15 Wrong allocation: stored values are wrongly changed!\n");}
  801004:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  80100f:	75 40                	jne    801051 <_main+0xff8>
  801011:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801017:	89 c2                	mov    %eax,%edx
  801019:	c1 ea 1f             	shr    $0x1f,%edx
  80101c:	01 d0                	add    %edx,%eax
  80101e:	d1 f8                	sar    %eax
  801020:	89 c2                	mov    %eax,%edx
  801022:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	8a 10                	mov    (%eax),%dl
  80102c:	8a 45 e2             	mov    -0x1e(%ebp),%al
  80102f:	88 c1                	mov    %al,%cl
  801031:	c0 e9 07             	shr    $0x7,%cl
  801034:	01 c8                	add    %ecx,%eax
  801036:	d0 f8                	sar    %al
  801038:	38 c2                	cmp    %al,%dl
  80103a:	75 15                	jne    801051 <_main+0xff8>
  80103c:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  801042:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  80104f:	74 17                	je     801068 <_main+0x100f>
  801051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801058:	83 ec 0c             	sub    $0xc,%esp
  80105b:	68 d8 5b 80 00       	push   $0x805bd8
  801060:	e8 20 05 00 00       	call   801585 <cprintf>
  801065:	83 c4 10             	add    $0x10,%esp
		if (shortArr2[0] != minShort || shortArr2[lastIndexOfShort2/2] != maxShort/2 || shortArr2[lastIndexOfShort2] 	!= maxShort) { is_correct = 0; cprintf("16 Wrong allocation: stored values are wrongly changed!\n");}
  801068:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80106e:	66 8b 00             	mov    (%eax),%ax
  801071:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  801075:	75 4d                	jne    8010c4 <_main+0x106b>
  801077:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	c1 ea 1f             	shr    $0x1f,%edx
  801082:	01 d0                	add    %edx,%eax
  801084:	d1 f8                	sar    %eax
  801086:	01 c0                	add    %eax,%eax
  801088:	89 c2                	mov    %eax,%edx
  80108a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	66 8b 10             	mov    (%eax),%dx
  801095:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  801099:	89 c1                	mov    %eax,%ecx
  80109b:	66 c1 e9 0f          	shr    $0xf,%cx
  80109f:	01 c8                	add    %ecx,%eax
  8010a1:	66 d1 f8             	sar    %ax
  8010a4:	66 39 c2             	cmp    %ax,%dx
  8010a7:	75 1b                	jne    8010c4 <_main+0x106b>
  8010a9:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8010af:	01 c0                	add    %eax,%eax
  8010b1:	89 c2                	mov    %eax,%edx
  8010b3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	66 8b 00             	mov    (%eax),%ax
  8010be:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  8010c2:	74 17                	je     8010db <_main+0x1082>
  8010c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010cb:	83 ec 0c             	sub    $0xc,%esp
  8010ce:	68 14 5c 80 00       	push   $0x805c14
  8010d3:	e8 ad 04 00 00       	call   801585 <cprintf>
  8010d8:	83 c4 10             	add    $0x10,%esp

	}
	if (is_correct)
  8010db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010df:	74 04                	je     8010e5 <_main+0x108c>
	{
		eval += 30;
  8010e1:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}

	is_correct = 1;
  8010e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("%~\nTest malloc (1) [PAGE ALLOCATOR] completed. Eval = %d\n", eval);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f2:	68 50 5c 80 00       	push   $0x805c50
  8010f7:	e8 89 04 00 00       	call   801585 <cprintf>
  8010fc:	83 c4 10             	add    $0x10,%esp

	return;
  8010ff:	90                   	nop
}
  801100:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801103:	5b                   	pop    %ebx
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
  80110d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801110:	e8 a3 2e 00 00       	call   803fb8 <sys_getenvindex>
  801115:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801118:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80111b:	89 d0                	mov    %edx,%eax
  80111d:	c1 e0 03             	shl    $0x3,%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	c1 e0 02             	shl    $0x2,%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80112e:	01 d0                	add    %edx,%eax
  801130:	c1 e0 03             	shl    $0x3,%eax
  801133:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801138:	a3 20 70 80 00       	mov    %eax,0x807020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80113d:	a1 20 70 80 00       	mov    0x807020,%eax
  801142:	8a 40 20             	mov    0x20(%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	74 0d                	je     801156 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801149:	a1 20 70 80 00       	mov    0x807020,%eax
  80114e:	83 c0 20             	add    $0x20,%eax
  801151:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801156:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115a:	7e 0a                	jle    801166 <libmain+0x5f>
		binaryname = argv[0];
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	8b 00                	mov    (%eax),%eax
  801161:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801166:	83 ec 08             	sub    $0x8,%esp
  801169:	ff 75 0c             	pushl  0xc(%ebp)
  80116c:	ff 75 08             	pushl  0x8(%ebp)
  80116f:	e8 e5 ee ff ff       	call   800059 <_main>
  801174:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801177:	a1 00 70 80 00       	mov    0x807000,%eax
  80117c:	85 c0                	test   %eax,%eax
  80117e:	0f 84 01 01 00 00    	je     801285 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801184:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80118a:	bb 84 5d 80 00       	mov    $0x805d84,%ebx
  80118f:	ba 0e 00 00 00       	mov    $0xe,%edx
  801194:	89 c7                	mov    %eax,%edi
  801196:	89 de                	mov    %ebx,%esi
  801198:	89 d1                	mov    %edx,%ecx
  80119a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80119c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80119f:	b9 56 00 00 00       	mov    $0x56,%ecx
  8011a4:	b0 00                	mov    $0x0,%al
  8011a6:	89 d7                	mov    %edx,%edi
  8011a8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8011aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8011b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	50                   	push   %eax
  8011b8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011be:	50                   	push   %eax
  8011bf:	e8 2a 30 00 00       	call   8041ee <sys_utilities>
  8011c4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8011c7:	e8 73 2b 00 00       	call   803d3f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	68 a4 5c 80 00       	push   $0x805ca4
  8011d4:	e8 ac 03 00 00       	call   801585 <cprintf>
  8011d9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8011dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	74 18                	je     8011fb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8011e3:	e8 24 30 00 00       	call   80420c <sys_get_optimal_num_faults>
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	50                   	push   %eax
  8011ec:	68 cc 5c 80 00       	push   $0x805ccc
  8011f1:	e8 8f 03 00 00       	call   801585 <cprintf>
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	eb 59                	jmp    801254 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011fb:	a1 20 70 80 00       	mov    0x807020,%eax
  801200:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  801206:	a1 20 70 80 00       	mov    0x807020,%eax
  80120b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  801211:	83 ec 04             	sub    $0x4,%esp
  801214:	52                   	push   %edx
  801215:	50                   	push   %eax
  801216:	68 f0 5c 80 00       	push   $0x805cf0
  80121b:	e8 65 03 00 00       	call   801585 <cprintf>
  801220:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801223:	a1 20 70 80 00       	mov    0x807020,%eax
  801228:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80122e:	a1 20 70 80 00       	mov    0x807020,%eax
  801233:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  801239:	a1 20 70 80 00       	mov    0x807020,%eax
  80123e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801244:	51                   	push   %ecx
  801245:	52                   	push   %edx
  801246:	50                   	push   %eax
  801247:	68 18 5d 80 00       	push   $0x805d18
  80124c:	e8 34 03 00 00       	call   801585 <cprintf>
  801251:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801254:	a1 20 70 80 00       	mov    0x807020,%eax
  801259:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	50                   	push   %eax
  801263:	68 70 5d 80 00       	push   $0x805d70
  801268:	e8 18 03 00 00       	call   801585 <cprintf>
  80126d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	68 a4 5c 80 00       	push   $0x805ca4
  801278:	e8 08 03 00 00       	call   801585 <cprintf>
  80127d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801280:	e8 d4 2a 00 00       	call   803d59 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801285:	e8 1f 00 00 00       	call   8012a9 <exit>
}
  80128a:	90                   	nop
  80128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801299:	83 ec 0c             	sub    $0xc,%esp
  80129c:	6a 00                	push   $0x0
  80129e:	e8 e1 2c 00 00       	call   803f84 <sys_destroy_env>
  8012a3:	83 c4 10             	add    $0x10,%esp
}
  8012a6:	90                   	nop
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <exit>:

void
exit(void)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012af:	e8 36 2d 00 00       	call   803fea <sys_exit_env>
}
  8012b4:	90                   	nop
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012bd:	8d 45 10             	lea    0x10(%ebp),%eax
  8012c0:	83 c0 04             	add    $0x4,%eax
  8012c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012c6:	a1 38 71 83 00       	mov    0x837138,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 16                	je     8012e5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012cf:	a1 38 71 83 00       	mov    0x837138,%eax
  8012d4:	83 ec 08             	sub    $0x8,%esp
  8012d7:	50                   	push   %eax
  8012d8:	68 e8 5d 80 00       	push   $0x805de8
  8012dd:	e8 a3 02 00 00       	call   801585 <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8012e5:	a1 04 70 80 00       	mov    0x807004,%eax
  8012ea:	83 ec 0c             	sub    $0xc,%esp
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	ff 75 08             	pushl  0x8(%ebp)
  8012f3:	50                   	push   %eax
  8012f4:	68 f0 5d 80 00       	push   $0x805df0
  8012f9:	6a 74                	push   $0x74
  8012fb:	e8 b2 02 00 00       	call   8015b2 <cprintf_colored>
  801300:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	ff 75 f4             	pushl  -0xc(%ebp)
  80130c:	50                   	push   %eax
  80130d:	e8 04 02 00 00       	call   801516 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	6a 00                	push   $0x0
  80131a:	68 18 5e 80 00       	push   $0x805e18
  80131f:	e8 f2 01 00 00       	call   801516 <vcprintf>
  801324:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801327:	e8 7d ff ff ff       	call   8012a9 <exit>

	// should not return here
	while (1) ;
  80132c:	eb fe                	jmp    80132c <_panic+0x75>

0080132e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801334:	a1 20 70 80 00       	mov    0x807020,%eax
  801339:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	39 c2                	cmp    %eax,%edx
  801344:	74 14                	je     80135a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	68 1c 5e 80 00       	push   $0x805e1c
  80134e:	6a 26                	push   $0x26
  801350:	68 68 5e 80 00       	push   $0x805e68
  801355:	e8 5d ff ff ff       	call   8012b7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80135a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801368:	e9 c5 00 00 00       	jmp    801432 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	01 d0                	add    %edx,%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	75 08                	jne    80138a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801382:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801385:	e9 a5 00 00 00       	jmp    80142f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80138a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801391:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801398:	eb 69                	jmp    801403 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80139a:	a1 20 70 80 00       	mov    0x807020,%eax
  80139f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8013a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013a8:	89 d0                	mov    %edx,%eax
  8013aa:	01 c0                	add    %eax,%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	c1 e0 03             	shl    $0x3,%eax
  8013b1:	01 c8                	add    %ecx,%eax
  8013b3:	8a 40 04             	mov    0x4(%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	75 46                	jne    801400 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013ba:	a1 20 70 80 00       	mov    0x807020,%eax
  8013bf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8013c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013c8:	89 d0                	mov    %edx,%eax
  8013ca:	01 c0                	add    %eax,%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c1 e0 03             	shl    $0x3,%eax
  8013d1:	01 c8                	add    %ecx,%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013f3:	39 c2                	cmp    %eax,%edx
  8013f5:	75 09                	jne    801400 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8013f7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013fe:	eb 15                	jmp    801415 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801400:	ff 45 e8             	incl   -0x18(%ebp)
  801403:	a1 20 70 80 00       	mov    0x807020,%eax
  801408:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80140e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801411:	39 c2                	cmp    %eax,%edx
  801413:	77 85                	ja     80139a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801415:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801419:	75 14                	jne    80142f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	68 74 5e 80 00       	push   $0x805e74
  801423:	6a 3a                	push   $0x3a
  801425:	68 68 5e 80 00       	push   $0x805e68
  80142a:	e8 88 fe ff ff       	call   8012b7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80142f:	ff 45 f0             	incl   -0x10(%ebp)
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801438:	0f 8c 2f ff ff ff    	jl     80136d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80143e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801445:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80144c:	eb 26                	jmp    801474 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80144e:	a1 20 70 80 00       	mov    0x807020,%eax
  801453:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801459:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80145c:	89 d0                	mov    %edx,%eax
  80145e:	01 c0                	add    %eax,%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	c1 e0 03             	shl    $0x3,%eax
  801465:	01 c8                	add    %ecx,%eax
  801467:	8a 40 04             	mov    0x4(%eax),%al
  80146a:	3c 01                	cmp    $0x1,%al
  80146c:	75 03                	jne    801471 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80146e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801471:	ff 45 e0             	incl   -0x20(%ebp)
  801474:	a1 20 70 80 00       	mov    0x807020,%eax
  801479:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	39 c2                	cmp    %eax,%edx
  801484:	77 c8                	ja     80144e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801489:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80148c:	74 14                	je     8014a2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	68 c8 5e 80 00       	push   $0x805ec8
  801496:	6a 44                	push   $0x44
  801498:	68 68 5e 80 00       	push   $0x805e68
  80149d:	e8 15 fe ff ff       	call   8012b7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8014a2:	90                   	nop
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	53                   	push   %ebx
  8014a9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bc:	88 d1                	mov    %dl,%cl
  8014be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 00                	mov    (%eax),%eax
  8014ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014cf:	75 30                	jne    801501 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8014d1:	8b 15 3c 71 83 00    	mov    0x83713c,%edx
  8014d7:	a0 64 f0 81 00       	mov    0x81f064,%al
  8014dc:	0f b6 c0             	movzbl %al,%eax
  8014df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e2:	8b 09                	mov    (%ecx),%ecx
  8014e4:	89 cb                	mov    %ecx,%ebx
  8014e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e9:	83 c1 08             	add    $0x8,%ecx
  8014ec:	52                   	push   %edx
  8014ed:	50                   	push   %eax
  8014ee:	53                   	push   %ebx
  8014ef:	51                   	push   %ecx
  8014f0:	e8 06 28 00 00       	call   803cfb <sys_cputs>
  8014f5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	8b 40 04             	mov    0x4(%eax),%eax
  801507:	8d 50 01             	lea    0x1(%eax),%edx
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801510:	90                   	nop
  801511:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80151f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801526:	00 00 00 
	b.cnt = 0;
  801529:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801530:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	68 a5 14 80 00       	push   $0x8014a5
  801545:	e8 5a 02 00 00       	call   8017a4 <vprintfmt>
  80154a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80154d:	8b 15 3c 71 83 00    	mov    0x83713c,%edx
  801553:	a0 64 f0 81 00       	mov    0x81f064,%al
  801558:	0f b6 c0             	movzbl %al,%eax
  80155b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801561:	52                   	push   %edx
  801562:	50                   	push   %eax
  801563:	51                   	push   %ecx
  801564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80156a:	83 c0 08             	add    $0x8,%eax
  80156d:	50                   	push   %eax
  80156e:	e8 88 27 00 00       	call   803cfb <sys_cputs>
  801573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801576:	c6 05 64 f0 81 00 00 	movb   $0x0,0x81f064
	return b.cnt;
  80157d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80158b:	c6 05 64 f0 81 00 01 	movb   $0x1,0x81f064
	va_start(ap, fmt);
  801592:	8d 45 0c             	lea    0xc(%ebp),%eax
  801595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	83 ec 08             	sub    $0x8,%esp
  80159e:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a1:	50                   	push   %eax
  8015a2:	e8 6f ff ff ff       	call   801516 <vcprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015b8:	c6 05 64 f0 81 00 01 	movb   $0x1,0x81f064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	c1 e0 08             	shl    $0x8,%eax
  8015c5:	a3 3c 71 83 00       	mov    %eax,0x83713c
	va_start(ap, fmt);
  8015ca:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015cd:	83 c0 04             	add    $0x4,%eax
  8015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	83 ec 08             	sub    $0x8,%esp
  8015d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015dc:	50                   	push   %eax
  8015dd:	e8 34 ff ff ff       	call   801516 <vcprintf>
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8015e8:	c7 05 3c 71 83 00 00 	movl   $0x700,0x83713c
  8015ef:	07 00 00 

	return cnt;
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8015fd:	e8 3d 27 00 00       	call   803d3f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801602:	8d 45 0c             	lea    0xc(%ebp),%eax
  801605:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	ff 75 f4             	pushl  -0xc(%ebp)
  801611:	50                   	push   %eax
  801612:	e8 ff fe ff ff       	call   801516 <vcprintf>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80161d:	e8 37 27 00 00       	call   803d59 <sys_unlock_cons>
	return cnt;
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	53                   	push   %ebx
  80162b:	83 ec 14             	sub    $0x14,%esp
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801634:	8b 45 14             	mov    0x14(%ebp),%eax
  801637:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80163a:	8b 45 18             	mov    0x18(%ebp),%eax
  80163d:	ba 00 00 00 00       	mov    $0x0,%edx
  801642:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801645:	77 55                	ja     80169c <printnum+0x75>
  801647:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80164a:	72 05                	jb     801651 <printnum+0x2a>
  80164c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80164f:	77 4b                	ja     80169c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801651:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801654:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801657:	8b 45 18             	mov    0x18(%ebp),%eax
  80165a:	ba 00 00 00 00       	mov    $0x0,%edx
  80165f:	52                   	push   %edx
  801660:	50                   	push   %eax
  801661:	ff 75 f4             	pushl  -0xc(%ebp)
  801664:	ff 75 f0             	pushl  -0x10(%ebp)
  801667:	e8 a4 36 00 00       	call   804d10 <__udivdi3>
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	ff 75 20             	pushl  0x20(%ebp)
  801675:	53                   	push   %ebx
  801676:	ff 75 18             	pushl  0x18(%ebp)
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	ff 75 08             	pushl  0x8(%ebp)
  801681:	e8 a1 ff ff ff       	call   801627 <printnum>
  801686:	83 c4 20             	add    $0x20,%esp
  801689:	eb 1a                	jmp    8016a5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	ff 75 20             	pushl  0x20(%ebp)
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	ff d0                	call   *%eax
  801699:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80169c:	ff 4d 1c             	decl   0x1c(%ebp)
  80169f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8016a3:	7f e6                	jg     80168b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016a5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8016a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b3:	53                   	push   %ebx
  8016b4:	51                   	push   %ecx
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	e8 64 37 00 00       	call   804e20 <__umoddi3>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	05 34 61 80 00       	add    $0x806134,%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	0f be c0             	movsbl %al,%eax
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	50                   	push   %eax
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	ff d0                	call   *%eax
  8016d5:	83 c4 10             	add    $0x10,%esp
}
  8016d8:	90                   	nop
  8016d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e5:	7e 1c                	jle    801703 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8b 00                	mov    (%eax),%eax
  8016ec:	8d 50 08             	lea    0x8(%eax),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 10                	mov    %edx,(%eax)
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	83 e8 08             	sub    $0x8,%eax
  8016fc:	8b 50 04             	mov    0x4(%eax),%edx
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	eb 40                	jmp    801743 <getuint+0x65>
	else if (lflag)
  801703:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801707:	74 1e                	je     801727 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	8d 50 04             	lea    0x4(%eax),%edx
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	89 10                	mov    %edx,(%eax)
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	83 e8 04             	sub    $0x4,%eax
  80171e:	8b 00                	mov    (%eax),%eax
  801720:	ba 00 00 00 00       	mov    $0x0,%edx
  801725:	eb 1c                	jmp    801743 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	8b 00                	mov    (%eax),%eax
  80172c:	8d 50 04             	lea    0x4(%eax),%edx
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	89 10                	mov    %edx,(%eax)
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	8b 00                	mov    (%eax),%eax
  801739:	83 e8 04             	sub    $0x4,%eax
  80173c:	8b 00                	mov    (%eax),%eax
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    

00801745 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801748:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80174c:	7e 1c                	jle    80176a <getint+0x25>
		return va_arg(*ap, long long);
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8b 00                	mov    (%eax),%eax
  801753:	8d 50 08             	lea    0x8(%eax),%edx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	89 10                	mov    %edx,(%eax)
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8b 00                	mov    (%eax),%eax
  801760:	83 e8 08             	sub    $0x8,%eax
  801763:	8b 50 04             	mov    0x4(%eax),%edx
  801766:	8b 00                	mov    (%eax),%eax
  801768:	eb 38                	jmp    8017a2 <getint+0x5d>
	else if (lflag)
  80176a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176e:	74 1a                	je     80178a <getint+0x45>
		return va_arg(*ap, long);
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8b 00                	mov    (%eax),%eax
  801775:	8d 50 04             	lea    0x4(%eax),%edx
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	89 10                	mov    %edx,(%eax)
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8b 00                	mov    (%eax),%eax
  801782:	83 e8 04             	sub    $0x4,%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	99                   	cltd   
  801788:	eb 18                	jmp    8017a2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	8b 00                	mov    (%eax),%eax
  80178f:	8d 50 04             	lea    0x4(%eax),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	89 10                	mov    %edx,(%eax)
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	83 e8 04             	sub    $0x4,%eax
  80179f:	8b 00                	mov    (%eax),%eax
  8017a1:	99                   	cltd   
}
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    

008017a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017ac:	eb 17                	jmp    8017c5 <vprintfmt+0x21>
			if (ch == '\0')
  8017ae:	85 db                	test   %ebx,%ebx
  8017b0:	0f 84 c1 03 00 00    	je     801b77 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8017b6:	83 ec 08             	sub    $0x8,%esp
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	53                   	push   %ebx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	ff d0                	call   *%eax
  8017c2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8017c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c8:	8d 50 01             	lea    0x1(%eax),%edx
  8017cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	0f b6 d8             	movzbl %al,%ebx
  8017d3:	83 fb 25             	cmp    $0x25,%ebx
  8017d6:	75 d6                	jne    8017ae <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8017d8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8017dc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8017e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8017f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8017f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fb:	8d 50 01             	lea    0x1(%eax),%edx
  8017fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801801:	8a 00                	mov    (%eax),%al
  801803:	0f b6 d8             	movzbl %al,%ebx
  801806:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801809:	83 f8 5b             	cmp    $0x5b,%eax
  80180c:	0f 87 3d 03 00 00    	ja     801b4f <vprintfmt+0x3ab>
  801812:	8b 04 85 58 61 80 00 	mov    0x806158(,%eax,4),%eax
  801819:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80181b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80181f:	eb d7                	jmp    8017f8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801821:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801825:	eb d1                	jmp    8017f8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801827:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80182e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801831:	89 d0                	mov    %edx,%eax
  801833:	c1 e0 02             	shl    $0x2,%eax
  801836:	01 d0                	add    %edx,%eax
  801838:	01 c0                	add    %eax,%eax
  80183a:	01 d8                	add    %ebx,%eax
  80183c:	83 e8 30             	sub    $0x30,%eax
  80183f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801842:	8b 45 10             	mov    0x10(%ebp),%eax
  801845:	8a 00                	mov    (%eax),%al
  801847:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80184a:	83 fb 2f             	cmp    $0x2f,%ebx
  80184d:	7e 3e                	jle    80188d <vprintfmt+0xe9>
  80184f:	83 fb 39             	cmp    $0x39,%ebx
  801852:	7f 39                	jg     80188d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801854:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801857:	eb d5                	jmp    80182e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801859:	8b 45 14             	mov    0x14(%ebp),%eax
  80185c:	83 c0 04             	add    $0x4,%eax
  80185f:	89 45 14             	mov    %eax,0x14(%ebp)
  801862:	8b 45 14             	mov    0x14(%ebp),%eax
  801865:	83 e8 04             	sub    $0x4,%eax
  801868:	8b 00                	mov    (%eax),%eax
  80186a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80186d:	eb 1f                	jmp    80188e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80186f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801873:	79 83                	jns    8017f8 <vprintfmt+0x54>
				width = 0;
  801875:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80187c:	e9 77 ff ff ff       	jmp    8017f8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801881:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801888:	e9 6b ff ff ff       	jmp    8017f8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80188d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80188e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801892:	0f 89 60 ff ff ff    	jns    8017f8 <vprintfmt+0x54>
				width = precision, precision = -1;
  801898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80189e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8018a5:	e9 4e ff ff ff       	jmp    8017f8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8018aa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8018ad:	e9 46 ff ff ff       	jmp    8017f8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8018b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b5:	83 c0 04             	add    $0x4,%eax
  8018b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8018bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018be:	83 e8 04             	sub    $0x4,%eax
  8018c1:	8b 00                	mov    (%eax),%eax
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	50                   	push   %eax
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	ff d0                	call   *%eax
  8018cf:	83 c4 10             	add    $0x10,%esp
			break;
  8018d2:	e9 9b 02 00 00       	jmp    801b72 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8018d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018da:	83 c0 04             	add    $0x4,%eax
  8018dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8018e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e3:	83 e8 04             	sub    $0x4,%eax
  8018e6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8018e8:	85 db                	test   %ebx,%ebx
  8018ea:	79 02                	jns    8018ee <vprintfmt+0x14a>
				err = -err;
  8018ec:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8018ee:	83 fb 64             	cmp    $0x64,%ebx
  8018f1:	7f 0b                	jg     8018fe <vprintfmt+0x15a>
  8018f3:	8b 34 9d a0 5f 80 00 	mov    0x805fa0(,%ebx,4),%esi
  8018fa:	85 f6                	test   %esi,%esi
  8018fc:	75 19                	jne    801917 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8018fe:	53                   	push   %ebx
  8018ff:	68 45 61 80 00       	push   $0x806145
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	ff 75 08             	pushl  0x8(%ebp)
  80190a:	e8 70 02 00 00       	call   801b7f <printfmt>
  80190f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801912:	e9 5b 02 00 00       	jmp    801b72 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801917:	56                   	push   %esi
  801918:	68 4e 61 80 00       	push   $0x80614e
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	e8 57 02 00 00       	call   801b7f <printfmt>
  801928:	83 c4 10             	add    $0x10,%esp
			break;
  80192b:	e9 42 02 00 00       	jmp    801b72 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801930:	8b 45 14             	mov    0x14(%ebp),%eax
  801933:	83 c0 04             	add    $0x4,%eax
  801936:	89 45 14             	mov    %eax,0x14(%ebp)
  801939:	8b 45 14             	mov    0x14(%ebp),%eax
  80193c:	83 e8 04             	sub    $0x4,%eax
  80193f:	8b 30                	mov    (%eax),%esi
  801941:	85 f6                	test   %esi,%esi
  801943:	75 05                	jne    80194a <vprintfmt+0x1a6>
				p = "(null)";
  801945:	be 51 61 80 00       	mov    $0x806151,%esi
			if (width > 0 && padc != '-')
  80194a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80194e:	7e 6d                	jle    8019bd <vprintfmt+0x219>
  801950:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801954:	74 67                	je     8019bd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801956:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	50                   	push   %eax
  80195d:	56                   	push   %esi
  80195e:	e8 1e 03 00 00       	call   801c81 <strnlen>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801969:	eb 16                	jmp    801981 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80196b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	50                   	push   %eax
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	ff d0                	call   *%eax
  80197b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80197e:	ff 4d e4             	decl   -0x1c(%ebp)
  801981:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801985:	7f e4                	jg     80196b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801987:	eb 34                	jmp    8019bd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801989:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80198d:	74 1c                	je     8019ab <vprintfmt+0x207>
  80198f:	83 fb 1f             	cmp    $0x1f,%ebx
  801992:	7e 05                	jle    801999 <vprintfmt+0x1f5>
  801994:	83 fb 7e             	cmp    $0x7e,%ebx
  801997:	7e 12                	jle    8019ab <vprintfmt+0x207>
					putch('?', putdat);
  801999:	83 ec 08             	sub    $0x8,%esp
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	6a 3f                	push   $0x3f
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	ff d0                	call   *%eax
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	eb 0f                	jmp    8019ba <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8019ab:	83 ec 08             	sub    $0x8,%esp
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	53                   	push   %ebx
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	ff d0                	call   *%eax
  8019b7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019ba:	ff 4d e4             	decl   -0x1c(%ebp)
  8019bd:	89 f0                	mov    %esi,%eax
  8019bf:	8d 70 01             	lea    0x1(%eax),%esi
  8019c2:	8a 00                	mov    (%eax),%al
  8019c4:	0f be d8             	movsbl %al,%ebx
  8019c7:	85 db                	test   %ebx,%ebx
  8019c9:	74 24                	je     8019ef <vprintfmt+0x24b>
  8019cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019cf:	78 b8                	js     801989 <vprintfmt+0x1e5>
  8019d1:	ff 4d e0             	decl   -0x20(%ebp)
  8019d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019d8:	79 af                	jns    801989 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8019da:	eb 13                	jmp    8019ef <vprintfmt+0x24b>
				putch(' ', putdat);
  8019dc:	83 ec 08             	sub    $0x8,%esp
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	6a 20                	push   $0x20
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	ff d0                	call   *%eax
  8019e9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8019ec:	ff 4d e4             	decl   -0x1c(%ebp)
  8019ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019f3:	7f e7                	jg     8019dc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8019f5:	e9 78 01 00 00       	jmp    801b72 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8019fa:	83 ec 08             	sub    $0x8,%esp
  8019fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801a00:	8d 45 14             	lea    0x14(%ebp),%eax
  801a03:	50                   	push   %eax
  801a04:	e8 3c fd ff ff       	call   801745 <getint>
  801a09:	83 c4 10             	add    $0x10,%esp
  801a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a18:	85 d2                	test   %edx,%edx
  801a1a:	79 23                	jns    801a3f <vprintfmt+0x29b>
				putch('-', putdat);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	6a 2d                	push   $0x2d
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	ff d0                	call   *%eax
  801a29:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a32:	f7 d8                	neg    %eax
  801a34:	83 d2 00             	adc    $0x0,%edx
  801a37:	f7 da                	neg    %edx
  801a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801a3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a46:	e9 bc 00 00 00       	jmp    801b07 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801a4b:	83 ec 08             	sub    $0x8,%esp
  801a4e:	ff 75 e8             	pushl  -0x18(%ebp)
  801a51:	8d 45 14             	lea    0x14(%ebp),%eax
  801a54:	50                   	push   %eax
  801a55:	e8 84 fc ff ff       	call   8016de <getuint>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801a63:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801a6a:	e9 98 00 00 00       	jmp    801b07 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a6f:	83 ec 08             	sub    $0x8,%esp
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	6a 58                	push   $0x58
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	ff d0                	call   *%eax
  801a7c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	6a 58                	push   $0x58
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	ff d0                	call   *%eax
  801a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	6a 58                	push   $0x58
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	ff d0                	call   *%eax
  801a9c:	83 c4 10             	add    $0x10,%esp
			break;
  801a9f:	e9 ce 00 00 00       	jmp    801b72 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801aa4:	83 ec 08             	sub    $0x8,%esp
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	6a 30                	push   $0x30
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	ff d0                	call   *%eax
  801ab1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	6a 78                	push   $0x78
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	ff d0                	call   *%eax
  801ac1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac7:	83 c0 04             	add    $0x4,%eax
  801aca:	89 45 14             	mov    %eax,0x14(%ebp)
  801acd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad0:	83 e8 04             	sub    $0x4,%eax
  801ad3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ad8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801adf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801ae6:	eb 1f                	jmp    801b07 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	ff 75 e8             	pushl  -0x18(%ebp)
  801aee:	8d 45 14             	lea    0x14(%ebp),%eax
  801af1:	50                   	push   %eax
  801af2:	e8 e7 fb ff ff       	call   8016de <getuint>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801afd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801b00:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801b07:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	52                   	push   %edx
  801b12:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b15:	50                   	push   %eax
  801b16:	ff 75 f4             	pushl  -0xc(%ebp)
  801b19:	ff 75 f0             	pushl  -0x10(%ebp)
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	e8 00 fb ff ff       	call   801627 <printnum>
  801b27:	83 c4 20             	add    $0x20,%esp
			break;
  801b2a:	eb 46                	jmp    801b72 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801b2c:	83 ec 08             	sub    $0x8,%esp
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	53                   	push   %ebx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	ff d0                	call   *%eax
  801b38:	83 c4 10             	add    $0x10,%esp
			break;
  801b3b:	eb 35                	jmp    801b72 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801b3d:	c6 05 64 f0 81 00 00 	movb   $0x0,0x81f064
			break;
  801b44:	eb 2c                	jmp    801b72 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801b46:	c6 05 64 f0 81 00 01 	movb   $0x1,0x81f064
			break;
  801b4d:	eb 23                	jmp    801b72 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801b4f:	83 ec 08             	sub    $0x8,%esp
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	6a 25                	push   $0x25
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	ff d0                	call   *%eax
  801b5c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b5f:	ff 4d 10             	decl   0x10(%ebp)
  801b62:	eb 03                	jmp    801b67 <vprintfmt+0x3c3>
  801b64:	ff 4d 10             	decl   0x10(%ebp)
  801b67:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6a:	48                   	dec    %eax
  801b6b:	8a 00                	mov    (%eax),%al
  801b6d:	3c 25                	cmp    $0x25,%al
  801b6f:	75 f3                	jne    801b64 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801b71:	90                   	nop
		}
	}
  801b72:	e9 35 fc ff ff       	jmp    8017ac <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801b77:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801b78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b85:	8d 45 10             	lea    0x10(%ebp),%eax
  801b88:	83 c0 04             	add    $0x4,%eax
  801b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b91:	ff 75 f4             	pushl  -0xc(%ebp)
  801b94:	50                   	push   %eax
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	e8 04 fc ff ff       	call   8017a4 <vprintfmt>
  801ba0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ba3:	90                   	nop
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bac:	8b 40 08             	mov    0x8(%eax),%eax
  801baf:	8d 50 01             	lea    0x1(%eax),%edx
  801bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbb:	8b 10                	mov    (%eax),%edx
  801bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc0:	8b 40 04             	mov    0x4(%eax),%eax
  801bc3:	39 c2                	cmp    %eax,%edx
  801bc5:	73 12                	jae    801bd9 <sprintputch+0x33>
		*b->buf++ = ch;
  801bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bca:	8b 00                	mov    (%eax),%eax
  801bcc:	8d 48 01             	lea    0x1(%eax),%ecx
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	89 0a                	mov    %ecx,(%edx)
  801bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd7:	88 10                	mov    %dl,(%eax)
}
  801bd9:	90                   	nop
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    

00801bdc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801beb:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	01 d0                	add    %edx,%eax
  801bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c01:	74 06                	je     801c09 <vsnprintf+0x2d>
  801c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c07:	7f 07                	jg     801c10 <vsnprintf+0x34>
		return -E_INVAL;
  801c09:	b8 03 00 00 00       	mov    $0x3,%eax
  801c0e:	eb 20                	jmp    801c30 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c10:	ff 75 14             	pushl  0x14(%ebp)
  801c13:	ff 75 10             	pushl  0x10(%ebp)
  801c16:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c19:	50                   	push   %eax
  801c1a:	68 a6 1b 80 00       	push   $0x801ba6
  801c1f:	e8 80 fb ff ff       	call   8017a4 <vprintfmt>
  801c24:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c38:	8d 45 10             	lea    0x10(%ebp),%eax
  801c3b:	83 c0 04             	add    $0x4,%eax
  801c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801c41:	8b 45 10             	mov    0x10(%ebp),%eax
  801c44:	ff 75 f4             	pushl  -0xc(%ebp)
  801c47:	50                   	push   %eax
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	e8 89 ff ff ff       	call   801bdc <vsnprintf>
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801c64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c6b:	eb 06                	jmp    801c73 <strlen+0x15>
		n++;
  801c6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801c70:	ff 45 08             	incl   0x8(%ebp)
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	8a 00                	mov    (%eax),%al
  801c78:	84 c0                	test   %al,%al
  801c7a:	75 f1                	jne    801c6d <strlen+0xf>
		n++;
	return n;
  801c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c8e:	eb 09                	jmp    801c99 <strnlen+0x18>
		n++;
  801c90:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c93:	ff 45 08             	incl   0x8(%ebp)
  801c96:	ff 4d 0c             	decl   0xc(%ebp)
  801c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c9d:	74 09                	je     801ca8 <strnlen+0x27>
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	8a 00                	mov    (%eax),%al
  801ca4:	84 c0                	test   %al,%al
  801ca6:	75 e8                	jne    801c90 <strnlen+0xf>
		n++;
	return n;
  801ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801cb9:	90                   	nop
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	8d 50 01             	lea    0x1(%eax),%edx
  801cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ccc:	8a 12                	mov    (%edx),%dl
  801cce:	88 10                	mov    %dl,(%eax)
  801cd0:	8a 00                	mov    (%eax),%al
  801cd2:	84 c0                	test   %al,%al
  801cd4:	75 e4                	jne    801cba <strcpy+0xd>
		/* do nothing */;
	return ret;
  801cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801ce7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cee:	eb 1f                	jmp    801d0f <strncpy+0x34>
		*dst++ = *src;
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	8d 50 01             	lea    0x1(%eax),%edx
  801cf6:	89 55 08             	mov    %edx,0x8(%ebp)
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8a 12                	mov    (%edx),%dl
  801cfe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	8a 00                	mov    (%eax),%al
  801d05:	84 c0                	test   %al,%al
  801d07:	74 03                	je     801d0c <strncpy+0x31>
			src++;
  801d09:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d0c:	ff 45 fc             	incl   -0x4(%ebp)
  801d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d12:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d15:	72 d9                	jb     801cf0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d2c:	74 30                	je     801d5e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801d2e:	eb 16                	jmp    801d46 <strlcpy+0x2a>
			*dst++ = *src++;
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	8d 50 01             	lea    0x1(%eax),%edx
  801d36:	89 55 08             	mov    %edx,0x8(%ebp)
  801d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d3f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d42:	8a 12                	mov    (%edx),%dl
  801d44:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801d46:	ff 4d 10             	decl   0x10(%ebp)
  801d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d4d:	74 09                	je     801d58 <strlcpy+0x3c>
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	8a 00                	mov    (%eax),%al
  801d54:	84 c0                	test   %al,%al
  801d56:	75 d8                	jne    801d30 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d64:	29 c2                	sub    %eax,%edx
  801d66:	89 d0                	mov    %edx,%eax
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801d6d:	eb 06                	jmp    801d75 <strcmp+0xb>
		p++, q++;
  801d6f:	ff 45 08             	incl   0x8(%ebp)
  801d72:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	8a 00                	mov    (%eax),%al
  801d7a:	84 c0                	test   %al,%al
  801d7c:	74 0e                	je     801d8c <strcmp+0x22>
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	8a 10                	mov    (%eax),%dl
  801d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d86:	8a 00                	mov    (%eax),%al
  801d88:	38 c2                	cmp    %al,%dl
  801d8a:	74 e3                	je     801d6f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	8a 00                	mov    (%eax),%al
  801d91:	0f b6 d0             	movzbl %al,%edx
  801d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d97:	8a 00                	mov    (%eax),%al
  801d99:	0f b6 c0             	movzbl %al,%eax
  801d9c:	29 c2                	sub    %eax,%edx
  801d9e:	89 d0                	mov    %edx,%eax
}
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    

00801da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801da5:	eb 09                	jmp    801db0 <strncmp+0xe>
		n--, p++, q++;
  801da7:	ff 4d 10             	decl   0x10(%ebp)
  801daa:	ff 45 08             	incl   0x8(%ebp)
  801dad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801db4:	74 17                	je     801dcd <strncmp+0x2b>
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	8a 00                	mov    (%eax),%al
  801dbb:	84 c0                	test   %al,%al
  801dbd:	74 0e                	je     801dcd <strncmp+0x2b>
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	8a 10                	mov    (%eax),%dl
  801dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc7:	8a 00                	mov    (%eax),%al
  801dc9:	38 c2                	cmp    %al,%dl
  801dcb:	74 da                	je     801da7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dd1:	75 07                	jne    801dda <strncmp+0x38>
		return 0;
  801dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd8:	eb 14                	jmp    801dee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	8a 00                	mov    (%eax),%al
  801ddf:	0f b6 d0             	movzbl %al,%edx
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	8a 00                	mov    (%eax),%al
  801de7:	0f b6 c0             	movzbl %al,%eax
  801dea:	29 c2                	sub    %eax,%edx
  801dec:	89 d0                	mov    %edx,%eax
}
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 04             	sub    $0x4,%esp
  801df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dfc:	eb 12                	jmp    801e10 <strchr+0x20>
		if (*s == c)
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	8a 00                	mov    (%eax),%al
  801e03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e06:	75 05                	jne    801e0d <strchr+0x1d>
			return (char *) s;
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	eb 11                	jmp    801e1e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801e0d:	ff 45 08             	incl   0x8(%ebp)
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	8a 00                	mov    (%eax),%al
  801e15:	84 c0                	test   %al,%al
  801e17:	75 e5                	jne    801dfe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e29:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e2c:	eb 0d                	jmp    801e3b <strfind+0x1b>
		if (*s == c)
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	8a 00                	mov    (%eax),%al
  801e33:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e36:	74 0e                	je     801e46 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801e38:	ff 45 08             	incl   0x8(%ebp)
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	8a 00                	mov    (%eax),%al
  801e40:	84 c0                	test   %al,%al
  801e42:	75 ea                	jne    801e2e <strfind+0xe>
  801e44:	eb 01                	jmp    801e47 <strfind+0x27>
		if (*s == c)
			break;
  801e46:	90                   	nop
	return (char *) s;
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801e58:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801e5c:	76 63                	jbe    801ec1 <memset+0x75>
		uint64 data_block = c;
  801e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e61:	99                   	cltd   
  801e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e65:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801e72:	c1 e0 08             	shl    $0x8,%eax
  801e75:	09 45 f0             	or     %eax,-0x10(%ebp)
  801e78:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e81:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801e85:	c1 e0 10             	shl    $0x10,%eax
  801e88:	09 45 f0             	or     %eax,-0x10(%ebp)
  801e8b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e94:	89 c2                	mov    %eax,%edx
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	09 45 f0             	or     %eax,-0x10(%ebp)
  801e9e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801ea1:	eb 18                	jmp    801ebb <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801ea3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ea6:	8d 41 08             	lea    0x8(%ecx),%eax
  801ea9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb2:	89 01                	mov    %eax,(%ecx)
  801eb4:	89 51 04             	mov    %edx,0x4(%ecx)
  801eb7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801ebb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ebf:	77 e2                	ja     801ea3 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801ec1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec5:	74 23                	je     801eea <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eca:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801ecd:	eb 0e                	jmp    801edd <memset+0x91>
			*p8++ = (uint8)c;
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8d 50 01             	lea    0x1(%eax),%edx
  801ed5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801edd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee0:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ee3:	89 55 10             	mov    %edx,0x10(%ebp)
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	75 e5                	jne    801ecf <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801f01:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f05:	76 24                	jbe    801f2b <memcpy+0x3c>
		while(n >= 8){
  801f07:	eb 1c                	jmp    801f25 <memcpy+0x36>
			*d64 = *s64;
  801f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0c:	8b 50 04             	mov    0x4(%eax),%edx
  801f0f:	8b 00                	mov    (%eax),%eax
  801f11:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f14:	89 01                	mov    %eax,(%ecx)
  801f16:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801f19:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801f1d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801f21:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801f25:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f29:	77 de                	ja     801f09 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801f2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f2f:	74 31                	je     801f62 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801f3d:	eb 16                	jmp    801f55 <memcpy+0x66>
			*d8++ = *s8++;
  801f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f42:	8d 50 01             	lea    0x1(%eax),%edx
  801f45:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f4e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801f51:	8a 12                	mov    (%edx),%dl
  801f53:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801f55:	8b 45 10             	mov    0x10(%ebp),%eax
  801f58:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f5b:	89 55 10             	mov    %edx,0x10(%ebp)
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	75 dd                	jne    801f3f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f7f:	73 50                	jae    801fd1 <memmove+0x6a>
  801f81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f84:	8b 45 10             	mov    0x10(%ebp),%eax
  801f87:	01 d0                	add    %edx,%eax
  801f89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f8c:	76 43                	jbe    801fd1 <memmove+0x6a>
		s += n;
  801f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f91:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f9a:	eb 10                	jmp    801fac <memmove+0x45>
			*--d = *--s;
  801f9c:	ff 4d f8             	decl   -0x8(%ebp)
  801f9f:	ff 4d fc             	decl   -0x4(%ebp)
  801fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa5:	8a 10                	mov    (%eax),%dl
  801fa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801faa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801fac:	8b 45 10             	mov    0x10(%ebp),%eax
  801faf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fb2:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	75 e3                	jne    801f9c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801fb9:	eb 23                	jmp    801fde <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fbe:	8d 50 01             	lea    0x1(%eax),%edx
  801fc1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fca:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fcd:	8a 12                	mov    (%edx),%dl
  801fcf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	75 dd                	jne    801fbb <memmove+0x54>
			*d++ = *s++;

	return dst;
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ff5:	eb 2a                	jmp    802021 <memcmp+0x3e>
		if (*s1 != *s2)
  801ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffa:	8a 10                	mov    (%eax),%dl
  801ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fff:	8a 00                	mov    (%eax),%al
  802001:	38 c2                	cmp    %al,%dl
  802003:	74 16                	je     80201b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802005:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802008:	8a 00                	mov    (%eax),%al
  80200a:	0f b6 d0             	movzbl %al,%edx
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8a 00                	mov    (%eax),%al
  802012:	0f b6 c0             	movzbl %al,%eax
  802015:	29 c2                	sub    %eax,%edx
  802017:	89 d0                	mov    %edx,%eax
  802019:	eb 18                	jmp    802033 <memcmp+0x50>
		s1++, s2++;
  80201b:	ff 45 fc             	incl   -0x4(%ebp)
  80201e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802021:	8b 45 10             	mov    0x10(%ebp),%eax
  802024:	8d 50 ff             	lea    -0x1(%eax),%edx
  802027:	89 55 10             	mov    %edx,0x10(%ebp)
  80202a:	85 c0                	test   %eax,%eax
  80202c:	75 c9                	jne    801ff7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80203b:	8b 55 08             	mov    0x8(%ebp),%edx
  80203e:	8b 45 10             	mov    0x10(%ebp),%eax
  802041:	01 d0                	add    %edx,%eax
  802043:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802046:	eb 15                	jmp    80205d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	8a 00                	mov    (%eax),%al
  80204d:	0f b6 d0             	movzbl %al,%edx
  802050:	8b 45 0c             	mov    0xc(%ebp),%eax
  802053:	0f b6 c0             	movzbl %al,%eax
  802056:	39 c2                	cmp    %eax,%edx
  802058:	74 0d                	je     802067 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80205a:	ff 45 08             	incl   0x8(%ebp)
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802063:	72 e3                	jb     802048 <memfind+0x13>
  802065:	eb 01                	jmp    802068 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802067:	90                   	nop
	return (void *) s;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802073:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80207a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802081:	eb 03                	jmp    802086 <strtol+0x19>
		s++;
  802083:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8a 00                	mov    (%eax),%al
  80208b:	3c 20                	cmp    $0x20,%al
  80208d:	74 f4                	je     802083 <strtol+0x16>
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	8a 00                	mov    (%eax),%al
  802094:	3c 09                	cmp    $0x9,%al
  802096:	74 eb                	je     802083 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	8a 00                	mov    (%eax),%al
  80209d:	3c 2b                	cmp    $0x2b,%al
  80209f:	75 05                	jne    8020a6 <strtol+0x39>
		s++;
  8020a1:	ff 45 08             	incl   0x8(%ebp)
  8020a4:	eb 13                	jmp    8020b9 <strtol+0x4c>
	else if (*s == '-')
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	8a 00                	mov    (%eax),%al
  8020ab:	3c 2d                	cmp    $0x2d,%al
  8020ad:	75 0a                	jne    8020b9 <strtol+0x4c>
		s++, neg = 1;
  8020af:	ff 45 08             	incl   0x8(%ebp)
  8020b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020bd:	74 06                	je     8020c5 <strtol+0x58>
  8020bf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8020c3:	75 20                	jne    8020e5 <strtol+0x78>
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8a 00                	mov    (%eax),%al
  8020ca:	3c 30                	cmp    $0x30,%al
  8020cc:	75 17                	jne    8020e5 <strtol+0x78>
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	40                   	inc    %eax
  8020d2:	8a 00                	mov    (%eax),%al
  8020d4:	3c 78                	cmp    $0x78,%al
  8020d6:	75 0d                	jne    8020e5 <strtol+0x78>
		s += 2, base = 16;
  8020d8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8020dc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8020e3:	eb 28                	jmp    80210d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8020e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e9:	75 15                	jne    802100 <strtol+0x93>
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8a 00                	mov    (%eax),%al
  8020f0:	3c 30                	cmp    $0x30,%al
  8020f2:	75 0c                	jne    802100 <strtol+0x93>
		s++, base = 8;
  8020f4:	ff 45 08             	incl   0x8(%ebp)
  8020f7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8020fe:	eb 0d                	jmp    80210d <strtol+0xa0>
	else if (base == 0)
  802100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802104:	75 07                	jne    80210d <strtol+0xa0>
		base = 10;
  802106:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8a 00                	mov    (%eax),%al
  802112:	3c 2f                	cmp    $0x2f,%al
  802114:	7e 19                	jle    80212f <strtol+0xc2>
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	8a 00                	mov    (%eax),%al
  80211b:	3c 39                	cmp    $0x39,%al
  80211d:	7f 10                	jg     80212f <strtol+0xc2>
			dig = *s - '0';
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8a 00                	mov    (%eax),%al
  802124:	0f be c0             	movsbl %al,%eax
  802127:	83 e8 30             	sub    $0x30,%eax
  80212a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212d:	eb 42                	jmp    802171 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	8a 00                	mov    (%eax),%al
  802134:	3c 60                	cmp    $0x60,%al
  802136:	7e 19                	jle    802151 <strtol+0xe4>
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	8a 00                	mov    (%eax),%al
  80213d:	3c 7a                	cmp    $0x7a,%al
  80213f:	7f 10                	jg     802151 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8a 00                	mov    (%eax),%al
  802146:	0f be c0             	movsbl %al,%eax
  802149:	83 e8 57             	sub    $0x57,%eax
  80214c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214f:	eb 20                	jmp    802171 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8a 00                	mov    (%eax),%al
  802156:	3c 40                	cmp    $0x40,%al
  802158:	7e 39                	jle    802193 <strtol+0x126>
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8a 00                	mov    (%eax),%al
  80215f:	3c 5a                	cmp    $0x5a,%al
  802161:	7f 30                	jg     802193 <strtol+0x126>
			dig = *s - 'A' + 10;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	8a 00                	mov    (%eax),%al
  802168:	0f be c0             	movsbl %al,%eax
  80216b:	83 e8 37             	sub    $0x37,%eax
  80216e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	3b 45 10             	cmp    0x10(%ebp),%eax
  802177:	7d 19                	jge    802192 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802179:	ff 45 08             	incl   0x8(%ebp)
  80217c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80217f:	0f af 45 10          	imul   0x10(%ebp),%eax
  802183:	89 c2                	mov    %eax,%edx
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	01 d0                	add    %edx,%eax
  80218a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80218d:	e9 7b ff ff ff       	jmp    80210d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802192:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802193:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802197:	74 08                	je     8021a1 <strtol+0x134>
		*endptr = (char *) s;
  802199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219c:	8b 55 08             	mov    0x8(%ebp),%edx
  80219f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a5:	74 07                	je     8021ae <strtol+0x141>
  8021a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021aa:	f7 d8                	neg    %eax
  8021ac:	eb 03                	jmp    8021b1 <strtol+0x144>
  8021ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <ltostr>:

void
ltostr(long value, char *str)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8021b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8021c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8021c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cb:	79 13                	jns    8021e0 <ltostr+0x2d>
	{
		neg = 1;
  8021cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8021da:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8021dd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8021e8:	99                   	cltd   
  8021e9:	f7 f9                	idiv   %ecx
  8021eb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8021ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f1:	8d 50 01             	lea    0x1(%eax),%edx
  8021f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021f7:	89 c2                	mov    %eax,%edx
  8021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fc:	01 d0                	add    %edx,%eax
  8021fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802201:	83 c2 30             	add    $0x30,%edx
  802204:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802206:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802209:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80220e:	f7 e9                	imul   %ecx
  802210:	c1 fa 02             	sar    $0x2,%edx
  802213:	89 c8                	mov    %ecx,%eax
  802215:	c1 f8 1f             	sar    $0x1f,%eax
  802218:	29 c2                	sub    %eax,%edx
  80221a:	89 d0                	mov    %edx,%eax
  80221c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80221f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802223:	75 bb                	jne    8021e0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802225:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80222c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80222f:	48                   	dec    %eax
  802230:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802233:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802237:	74 3d                	je     802276 <ltostr+0xc3>
		start = 1 ;
  802239:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802240:	eb 34                	jmp    802276 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802242:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802245:	8b 45 0c             	mov    0xc(%ebp),%eax
  802248:	01 d0                	add    %edx,%eax
  80224a:	8a 00                	mov    (%eax),%al
  80224c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80224f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802252:	8b 45 0c             	mov    0xc(%ebp),%eax
  802255:	01 c2                	add    %eax,%edx
  802257:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80225a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225d:	01 c8                	add    %ecx,%eax
  80225f:	8a 00                	mov    (%eax),%al
  802261:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802263:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802266:	8b 45 0c             	mov    0xc(%ebp),%eax
  802269:	01 c2                	add    %eax,%edx
  80226b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80226e:	88 02                	mov    %al,(%edx)
		start++ ;
  802270:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802273:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80227c:	7c c4                	jl     802242 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80227e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	01 d0                	add    %edx,%eax
  802286:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802289:	90                   	nop
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802292:	ff 75 08             	pushl  0x8(%ebp)
  802295:	e8 c4 f9 ff ff       	call   801c5e <strlen>
  80229a:	83 c4 04             	add    $0x4,%esp
  80229d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	e8 b6 f9 ff ff       	call   801c5e <strlen>
  8022a8:	83 c4 04             	add    $0x4,%esp
  8022ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8022ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8022b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022bc:	eb 17                	jmp    8022d5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8022be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c4:	01 c2                	add    %eax,%edx
  8022c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	01 c8                	add    %ecx,%eax
  8022ce:	8a 00                	mov    (%eax),%al
  8022d0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8022d2:	ff 45 fc             	incl   -0x4(%ebp)
  8022d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022db:	7c e1                	jl     8022be <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8022dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8022e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8022eb:	eb 1f                	jmp    80230c <strcconcat+0x80>
		final[s++] = str2[i] ;
  8022ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f0:	8d 50 01             	lea    0x1(%eax),%edx
  8022f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8022f6:	89 c2                	mov    %eax,%edx
  8022f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fb:	01 c2                	add    %eax,%edx
  8022fd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802300:	8b 45 0c             	mov    0xc(%ebp),%eax
  802303:	01 c8                	add    %ecx,%eax
  802305:	8a 00                	mov    (%eax),%al
  802307:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802309:	ff 45 f8             	incl   -0x8(%ebp)
  80230c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80230f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802312:	7c d9                	jl     8022ed <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802314:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802317:	8b 45 10             	mov    0x10(%ebp),%eax
  80231a:	01 d0                	add    %edx,%eax
  80231c:	c6 00 00             	movb   $0x0,(%eax)
}
  80231f:	90                   	nop
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802325:	8b 45 14             	mov    0x14(%ebp),%eax
  802328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80232e:	8b 45 14             	mov    0x14(%ebp),%eax
  802331:	8b 00                	mov    (%eax),%eax
  802333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80233a:	8b 45 10             	mov    0x10(%ebp),%eax
  80233d:	01 d0                	add    %edx,%eax
  80233f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802345:	eb 0c                	jmp    802353 <strsplit+0x31>
			*string++ = 0;
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	8d 50 01             	lea    0x1(%eax),%edx
  80234d:	89 55 08             	mov    %edx,0x8(%ebp)
  802350:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8a 00                	mov    (%eax),%al
  802358:	84 c0                	test   %al,%al
  80235a:	74 18                	je     802374 <strsplit+0x52>
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	8a 00                	mov    (%eax),%al
  802361:	0f be c0             	movsbl %al,%eax
  802364:	50                   	push   %eax
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	e8 83 fa ff ff       	call   801df0 <strchr>
  80236d:	83 c4 08             	add    $0x8,%esp
  802370:	85 c0                	test   %eax,%eax
  802372:	75 d3                	jne    802347 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8a 00                	mov    (%eax),%al
  802379:	84 c0                	test   %al,%al
  80237b:	74 5a                	je     8023d7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80237d:	8b 45 14             	mov    0x14(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	83 f8 0f             	cmp    $0xf,%eax
  802385:	75 07                	jne    80238e <strsplit+0x6c>
		{
			return 0;
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	eb 66                	jmp    8023f4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80238e:	8b 45 14             	mov    0x14(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	8d 48 01             	lea    0x1(%eax),%ecx
  802396:	8b 55 14             	mov    0x14(%ebp),%edx
  802399:	89 0a                	mov    %ecx,(%edx)
  80239b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a5:	01 c2                	add    %eax,%edx
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023ac:	eb 03                	jmp    8023b1 <strsplit+0x8f>
			string++;
  8023ae:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8a 00                	mov    (%eax),%al
  8023b6:	84 c0                	test   %al,%al
  8023b8:	74 8b                	je     802345 <strsplit+0x23>
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	8a 00                	mov    (%eax),%al
  8023bf:	0f be c0             	movsbl %al,%eax
  8023c2:	50                   	push   %eax
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	e8 25 fa ff ff       	call   801df0 <strchr>
  8023cb:	83 c4 08             	add    $0x8,%esp
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	74 dc                	je     8023ae <strsplit+0x8c>
			string++;
	}
  8023d2:	e9 6e ff ff ff       	jmp    802345 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8023d7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8023d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e7:	01 d0                	add    %edx,%eax
  8023e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8023ef:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802409:	eb 4a                	jmp    802455 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80240b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	01 c2                	add    %eax,%edx
  802413:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802416:	8b 45 0c             	mov    0xc(%ebp),%eax
  802419:	01 c8                	add    %ecx,%eax
  80241b:	8a 00                	mov    (%eax),%al
  80241d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80241f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802422:	8b 45 0c             	mov    0xc(%ebp),%eax
  802425:	01 d0                	add    %edx,%eax
  802427:	8a 00                	mov    (%eax),%al
  802429:	3c 40                	cmp    $0x40,%al
  80242b:	7e 25                	jle    802452 <str2lower+0x5c>
  80242d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802430:	8b 45 0c             	mov    0xc(%ebp),%eax
  802433:	01 d0                	add    %edx,%eax
  802435:	8a 00                	mov    (%eax),%al
  802437:	3c 5a                	cmp    $0x5a,%al
  802439:	7f 17                	jg     802452 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80243b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	01 d0                	add    %edx,%eax
  802443:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802446:	8b 55 08             	mov    0x8(%ebp),%edx
  802449:	01 ca                	add    %ecx,%edx
  80244b:	8a 12                	mov    (%edx),%dl
  80244d:	83 c2 20             	add    $0x20,%edx
  802450:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802452:	ff 45 fc             	incl   -0x4(%ebp)
  802455:	ff 75 0c             	pushl  0xc(%ebp)
  802458:	e8 01 f8 ff ff       	call   801c5e <strlen>
  80245d:	83 c4 04             	add    $0x4,%esp
  802460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802463:	7f a6                	jg     80240b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802465:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802470:	a1 08 70 80 00       	mov    0x807008,%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	74 42                	je     8024bb <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802479:	83 ec 08             	sub    $0x8,%esp
  80247c:	68 00 00 00 82       	push   $0x82000000
  802481:	68 00 00 00 80       	push   $0x80000000
  802486:	e8 b0 1e 00 00       	call   80433b <initialize_dynamic_allocator>
  80248b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80248e:	e8 96 1c 00 00       	call   804129 <sys_get_uheap_strategy>
  802493:	a3 80 70 83 00       	mov    %eax,0x837080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802498:	a1 60 f0 81 00       	mov    0x81f060,%eax
  80249d:	05 00 10 00 00       	add    $0x1000,%eax
  8024a2:	a3 30 71 83 00       	mov    %eax,0x837130
		uheapPageAllocBreak = uheapPageAllocStart;
  8024a7:	a1 30 71 83 00       	mov    0x837130,%eax
  8024ac:	a3 88 70 83 00       	mov    %eax,0x837088

		__firstTimeFlag = 0;
  8024b1:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  8024b8:	00 00 00 
	}
}
  8024bb:	90                   	nop
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024d2:	83 ec 08             	sub    $0x8,%esp
  8024d5:	68 06 04 00 00       	push   $0x406
  8024da:	50                   	push   %eax
  8024db:	e8 93 18 00 00       	call   803d73 <__sys_allocate_page>
  8024e0:	83 c4 10             	add    $0x10,%esp
  8024e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8024e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ea:	79 14                	jns    802500 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8024ec:	83 ec 04             	sub    $0x4,%esp
  8024ef:	68 c8 62 80 00       	push   $0x8062c8
  8024f4:	6a 1f                	push   $0x1f
  8024f6:	68 04 63 80 00       	push   $0x806304
  8024fb:	e8 b7 ed ff ff       	call   8012b7 <_panic>
	return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80251b:	83 ec 0c             	sub    $0xc,%esp
  80251e:	50                   	push   %eax
  80251f:	e8 96 18 00 00       	call   803dba <__sys_unmap_frame>
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80252a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80252e:	79 14                	jns    802544 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	68 10 63 80 00       	push   $0x806310
  802538:	6a 2a                	push   $0x2a
  80253a:	68 04 63 80 00       	push   $0x806304
  80253f:	e8 73 ed ff ff       	call   8012b7 <_panic>
}
  802544:	90                   	nop
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80254d:	e8 18 ff ff ff       	call   80246a <uheap_init>
	if (size == 0) return NULL ;
  802552:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802556:	75 0a                	jne    802562 <malloc+0x1b>
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
  80255d:	e9 43 03 00 00       	jmp    8028a5 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  802562:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802569:	77 13                	ja     80257e <malloc+0x37>
    {
        return alloc_block(size);
  80256b:	83 ec 0c             	sub    $0xc,%esp
  80256e:	ff 75 08             	pushl  0x8(%ebp)
  802571:	e8 78 20 00 00       	call   8045ee <alloc_block>
  802576:	83 c4 10             	add    $0x10,%esp
  802579:	e9 27 03 00 00       	jmp    8028a5 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80257e:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802585:	8b 55 08             	mov    0x8(%ebp),%edx
  802588:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80258b:	01 d0                	add    %edx,%eax
  80258d:	48                   	dec    %eax
  80258e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802591:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802594:	ba 00 00 00 00       	mov    $0x0,%edx
  802599:	f7 75 dc             	divl   -0x24(%ebp)
  80259c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80259f:	29 d0                	sub    %edx,%eax
  8025a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8025a4:	a1 40 f0 81 00       	mov    0x81f040,%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	75 0a                	jne    8025b7 <malloc+0x70>
    {
        uhp_inited = 1;
  8025ad:	c7 05 40 f0 81 00 01 	movl   $0x1,0x81f040
  8025b4:	00 00 00 
    }

    int exactIdx = -1;
  8025b7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8025be:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8025c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8025cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8025d3:	e9 85 00 00 00       	jmp    80265d <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8025d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025db:	89 d0                	mov    %edx,%eax
  8025dd:	01 c0                	add    %eax,%eax
  8025df:	01 d0                	add    %edx,%eax
  8025e1:	c1 e0 02             	shl    $0x2,%eax
  8025e4:	05 48 30 81 00       	add    $0x813048,%eax
  8025e9:	8a 00                	mov    (%eax),%al
  8025eb:	84 c0                	test   %al,%al
  8025ed:	74 20                	je     80260f <malloc+0xc8>
  8025ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025f2:	89 d0                	mov    %edx,%eax
  8025f4:	01 c0                	add    %eax,%eax
  8025f6:	01 d0                	add    %edx,%eax
  8025f8:	c1 e0 02             	shl    $0x2,%eax
  8025fb:	05 44 30 81 00       	add    $0x813044,%eax
  802600:	8b 00                	mov    (%eax),%eax
  802602:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802605:	75 08                	jne    80260f <malloc+0xc8>
        {
            exactIdx = i;
  802607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80260d:	eb 5b                	jmp    80266a <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80260f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802612:	89 d0                	mov    %edx,%eax
  802614:	01 c0                	add    %eax,%eax
  802616:	01 d0                	add    %edx,%eax
  802618:	c1 e0 02             	shl    $0x2,%eax
  80261b:	05 48 30 81 00       	add    $0x813048,%eax
  802620:	8a 00                	mov    (%eax),%al
  802622:	84 c0                	test   %al,%al
  802624:	74 34                	je     80265a <malloc+0x113>
  802626:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802629:	89 d0                	mov    %edx,%eax
  80262b:	01 c0                	add    %eax,%eax
  80262d:	01 d0                	add    %edx,%eax
  80262f:	c1 e0 02             	shl    $0x2,%eax
  802632:	05 44 30 81 00       	add    $0x813044,%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80263c:	76 1c                	jbe    80265a <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  80263e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802641:	89 d0                	mov    %edx,%eax
  802643:	01 c0                	add    %eax,%eax
  802645:	01 d0                	add    %edx,%eax
  802647:	c1 e0 02             	shl    $0x2,%eax
  80264a:	05 44 30 81 00       	add    $0x813044,%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802654:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802657:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80265a:	ff 45 e8             	incl   -0x18(%ebp)
  80265d:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802664:	0f 8e 6e ff ff ff    	jle    8025d8 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  80266a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802671:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802675:	74 7d                	je     8026f4 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802677:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80267e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802681:	89 d0                	mov    %edx,%eax
  802683:	01 c0                	add    %eax,%eax
  802685:	01 d0                	add    %edx,%eax
  802687:	c1 e0 02             	shl    $0x2,%eax
  80268a:	05 40 30 81 00       	add    $0x813040,%eax
  80268f:	8b 10                	mov    (%eax),%edx
  802691:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802694:	01 d0                	add    %edx,%eax
  802696:	48                   	dec    %eax
  802697:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80269a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80269d:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a2:	f7 75 bc             	divl   -0x44(%ebp)
  8026a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026a8:	29 d0                	sub    %edx,%eax
  8026aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8026ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b0:	89 d0                	mov    %edx,%eax
  8026b2:	01 c0                	add    %eax,%eax
  8026b4:	01 d0                	add    %edx,%eax
  8026b6:	c1 e0 02             	shl    $0x2,%eax
  8026b9:	05 48 30 81 00       	add    $0x813048,%eax
  8026be:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8026c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c4:	89 d0                	mov    %edx,%eax
  8026c6:	01 c0                	add    %eax,%eax
  8026c8:	01 d0                	add    %edx,%eax
  8026ca:	c1 e0 02             	shl    $0x2,%eax
  8026cd:	05 44 30 81 00       	add    $0x813044,%eax
  8026d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8026d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026db:	89 d0                	mov    %edx,%eax
  8026dd:	01 c0                	add    %eax,%eax
  8026df:	01 d0                	add    %edx,%eax
  8026e1:	c1 e0 02             	shl    $0x2,%eax
  8026e4:	05 40 30 81 00       	add    $0x813040,%eax
  8026e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ef:	e9 2d 01 00 00       	jmp    802821 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8026f4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026f8:	0f 84 ce 00 00 00    	je     8027cc <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8026fe:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802705:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802708:	89 d0                	mov    %edx,%eax
  80270a:	01 c0                	add    %eax,%eax
  80270c:	01 d0                	add    %edx,%eax
  80270e:	c1 e0 02             	shl    $0x2,%eax
  802711:	05 40 30 81 00       	add    $0x813040,%eax
  802716:	8b 10                	mov    (%eax),%edx
  802718:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80271b:	01 d0                	add    %edx,%eax
  80271d:	48                   	dec    %eax
  80271e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802721:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802724:	ba 00 00 00 00       	mov    $0x0,%edx
  802729:	f7 75 c4             	divl   -0x3c(%ebp)
  80272c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80272f:	29 d0                	sub    %edx,%eax
  802731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802734:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802737:	89 d0                	mov    %edx,%eax
  802739:	01 c0                	add    %eax,%eax
  80273b:	01 d0                	add    %edx,%eax
  80273d:	c1 e0 02             	shl    $0x2,%eax
  802740:	05 44 30 81 00       	add    $0x813044,%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80274a:	75 47                	jne    802793 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80274c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80274f:	89 d0                	mov    %edx,%eax
  802751:	01 c0                	add    %eax,%eax
  802753:	01 d0                	add    %edx,%eax
  802755:	c1 e0 02             	shl    $0x2,%eax
  802758:	05 48 30 81 00       	add    $0x813048,%eax
  80275d:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802760:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802763:	89 d0                	mov    %edx,%eax
  802765:	01 c0                	add    %eax,%eax
  802767:	01 d0                	add    %edx,%eax
  802769:	c1 e0 02             	shl    $0x2,%eax
  80276c:	05 44 30 81 00       	add    $0x813044,%eax
  802771:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802777:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277a:	89 d0                	mov    %edx,%eax
  80277c:	01 c0                	add    %eax,%eax
  80277e:	01 d0                	add    %edx,%eax
  802780:	c1 e0 02             	shl    $0x2,%eax
  802783:	05 40 30 81 00       	add    $0x813040,%eax
  802788:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278e:	e9 8e 00 00 00       	jmp    802821 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802796:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802799:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80279c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80279f:	89 d0                	mov    %edx,%eax
  8027a1:	01 c0                	add    %eax,%eax
  8027a3:	01 d0                	add    %edx,%eax
  8027a5:	c1 e0 02             	shl    $0x2,%eax
  8027a8:	05 40 30 81 00       	add    $0x813040,%eax
  8027ad:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8027af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8027b5:	89 c2                	mov    %eax,%edx
  8027b7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027ba:	89 c8                	mov    %ecx,%eax
  8027bc:	01 c0                	add    %eax,%eax
  8027be:	01 c8                	add    %ecx,%eax
  8027c0:	c1 e0 02             	shl    $0x2,%eax
  8027c3:	05 44 30 81 00       	add    $0x813044,%eax
  8027c8:	89 10                	mov    %edx,(%eax)
  8027ca:	eb 55                	jmp    802821 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8027cc:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8027d3:	8b 15 88 70 83 00    	mov    0x837088,%edx
  8027d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027dc:	01 d0                	add    %edx,%eax
  8027de:	48                   	dec    %eax
  8027df:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8027e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ea:	f7 75 d0             	divl   -0x30(%ebp)
  8027ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f0:	29 d0                	sub    %edx,%eax
  8027f2:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8027f5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8027f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027fb:	01 d0                	add    %edx,%eax
  8027fd:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802802:	76 0a                	jbe    80280e <malloc+0x2c7>
            return NULL;
  802804:	b8 00 00 00 00       	mov    $0x0,%eax
  802809:	e9 97 00 00 00       	jmp    8028a5 <malloc+0x35e>
        va = start;
  80280e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802811:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802814:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802817:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80281a:	01 d0                	add    %edx,%eax
  80281c:	a3 88 70 83 00       	mov    %eax,0x837088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802821:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802828:	eb 5e                	jmp    802888 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  80282a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80282d:	89 d0                	mov    %edx,%eax
  80282f:	01 c0                	add    %eax,%eax
  802831:	01 d0                	add    %edx,%eax
  802833:	c1 e0 02             	shl    $0x2,%eax
  802836:	05 48 70 80 00       	add    $0x807048,%eax
  80283b:	8a 00                	mov    (%eax),%al
  80283d:	84 c0                	test   %al,%al
  80283f:	75 44                	jne    802885 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  802841:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802844:	89 d0                	mov    %edx,%eax
  802846:	01 c0                	add    %eax,%eax
  802848:	01 d0                	add    %edx,%eax
  80284a:	c1 e0 02             	shl    $0x2,%eax
  80284d:	8d 90 40 70 80 00    	lea    0x807040(%eax),%edx
  802853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802856:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802858:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80285b:	89 d0                	mov    %edx,%eax
  80285d:	01 c0                	add    %eax,%eax
  80285f:	01 d0                	add    %edx,%eax
  802861:	c1 e0 02             	shl    $0x2,%eax
  802864:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  80286a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80286f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	01 c0                	add    %eax,%eax
  802876:	01 d0                	add    %edx,%eax
  802878:	c1 e0 02             	shl    $0x2,%eax
  80287b:	05 48 70 80 00       	add    $0x807048,%eax
  802880:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802883:	eb 0c                	jmp    802891 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802885:	ff 45 e0             	incl   -0x20(%ebp)
  802888:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80288f:	7e 99                	jle    80282a <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  802891:	83 ec 08             	sub    $0x8,%esp
  802894:	ff 75 d4             	pushl  -0x2c(%ebp)
  802897:	ff 75 e4             	pushl  -0x1c(%ebp)
  80289a:	e8 a2 19 00 00       	call   804241 <sys_allocate_user_mem>
  80289f:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8028a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8028a5:	c9                   	leave  
  8028a6:	c3                   	ret    

008028a7 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8028a7:	55                   	push   %ebp
  8028a8:	89 e5                	mov    %esp,%ebp
  8028aa:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8028ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b1:	0f 84 fa 03 00 00    	je     802cb1 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8028bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	79 1c                	jns    8028e0 <free+0x39>
  8028c4:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  8028cb:	77 13                	ja     8028e0 <free+0x39>
    {
        free_block(virtual_address);
  8028cd:	83 ec 0c             	sub    $0xc,%esp
  8028d0:	ff 75 08             	pushl  0x8(%ebp)
  8028d3:	e8 09 21 00 00       	call   8049e1 <free_block>
  8028d8:	83 c4 10             	add    $0x10,%esp
        return;
  8028db:	e9 d2 03 00 00       	jmp    802cb2 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8028e0:	a1 30 71 83 00       	mov    0x837130,%eax
  8028e5:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8028e8:	72 09                	jb     8028f3 <free+0x4c>
  8028ea:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  8028f1:	76 17                	jbe    80290a <free+0x63>
        panic("free: invalid address");
  8028f3:	83 ec 04             	sub    $0x4,%esp
  8028f6:	68 4d 63 80 00       	push   $0x80634d
  8028fb:	68 9b 00 00 00       	push   $0x9b
  802900:	68 04 63 80 00       	push   $0x806304
  802905:	e8 ad e9 ff ff       	call   8012b7 <_panic>

    uint32 size = 0;
  80290a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  802911:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802918:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80291f:	eb 50                	jmp    802971 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802921:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802924:	89 d0                	mov    %edx,%eax
  802926:	01 c0                	add    %eax,%eax
  802928:	01 d0                	add    %edx,%eax
  80292a:	c1 e0 02             	shl    $0x2,%eax
  80292d:	05 48 70 80 00       	add    $0x807048,%eax
  802932:	8a 00                	mov    (%eax),%al
  802934:	84 c0                	test   %al,%al
  802936:	74 36                	je     80296e <free+0xc7>
  802938:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80293b:	89 d0                	mov    %edx,%eax
  80293d:	01 c0                	add    %eax,%eax
  80293f:	01 d0                	add    %edx,%eax
  802941:	c1 e0 02             	shl    $0x2,%eax
  802944:	05 40 70 80 00       	add    $0x807040,%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80294e:	75 1e                	jne    80296e <free+0xc7>
        {
            size = uhp_allocs[i].size;
  802950:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802953:	89 d0                	mov    %edx,%eax
  802955:	01 c0                	add    %eax,%eax
  802957:	01 d0                	add    %edx,%eax
  802959:	c1 e0 02             	shl    $0x2,%eax
  80295c:	05 44 70 80 00       	add    $0x807044,%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  802966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802969:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  80296c:	eb 0c                	jmp    80297a <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80296e:	ff 45 ec             	incl   -0x14(%ebp)
  802971:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802978:	7e a7                	jle    802921 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  80297a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80297e:	74 06                	je     802986 <free+0xdf>
  802980:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802984:	75 17                	jne    80299d <free+0xf6>
        panic("free: unknown block");
  802986:	83 ec 04             	sub    $0x4,%esp
  802989:	68 63 63 80 00       	push   $0x806363
  80298e:	68 a9 00 00 00       	push   $0xa9
  802993:	68 04 63 80 00       	push   $0x806304
  802998:	e8 1a e9 ff ff       	call   8012b7 <_panic>

    uhp_allocs[idx].used = 0;
  80299d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a0:	89 d0                	mov    %edx,%eax
  8029a2:	01 c0                	add    %eax,%eax
  8029a4:	01 d0                	add    %edx,%eax
  8029a6:	c1 e0 02             	shl    $0x2,%eax
  8029a9:	05 48 70 80 00       	add    $0x807048,%eax
  8029ae:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8029b1:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8029b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8029bf:	eb 64                	jmp    802a25 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8029c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029c4:	89 d0                	mov    %edx,%eax
  8029c6:	01 c0                	add    %eax,%eax
  8029c8:	01 d0                	add    %edx,%eax
  8029ca:	c1 e0 02             	shl    $0x2,%eax
  8029cd:	05 48 30 81 00       	add    $0x813048,%eax
  8029d2:	8a 00                	mov    (%eax),%al
  8029d4:	84 c0                	test   %al,%al
  8029d6:	75 4a                	jne    802a22 <free+0x17b>
        {
            uhp_frees[i].va = va;
  8029d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029db:	89 d0                	mov    %edx,%eax
  8029dd:	01 c0                	add    %eax,%eax
  8029df:	01 d0                	add    %edx,%eax
  8029e1:	c1 e0 02             	shl    $0x2,%eax
  8029e4:	8d 90 40 30 81 00    	lea    0x813040(%eax),%edx
  8029ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029ed:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  8029ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029f2:	89 d0                	mov    %edx,%eax
  8029f4:	01 c0                	add    %eax,%eax
  8029f6:	01 d0                	add    %edx,%eax
  8029f8:	c1 e0 02             	shl    $0x2,%eax
  8029fb:	8d 90 44 30 81 00    	lea    0x813044(%eax),%edx
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  802a06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a09:	89 d0                	mov    %edx,%eax
  802a0b:	01 c0                	add    %eax,%eax
  802a0d:	01 d0                	add    %edx,%eax
  802a0f:	c1 e0 02             	shl    $0x2,%eax
  802a12:	05 48 30 81 00       	add    $0x813048,%eax
  802a17:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802a20:	eb 0c                	jmp    802a2e <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802a22:	ff 45 e4             	incl   -0x1c(%ebp)
  802a25:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802a2c:	7e 93                	jle    8029c1 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  802a2e:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802a32:	0f 84 f1 01 00 00    	je     802c29 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802a38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802a3f:	e9 d8 01 00 00       	jmp    802c1c <free+0x375>
        {
            if (i == fidx) continue;
  802a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a47:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a4a:	0f 84 c8 01 00 00    	je     802c18 <free+0x371>
            if (uhp_frees[i].free)
  802a50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a53:	89 d0                	mov    %edx,%eax
  802a55:	01 c0                	add    %eax,%eax
  802a57:	01 d0                	add    %edx,%eax
  802a59:	c1 e0 02             	shl    $0x2,%eax
  802a5c:	05 48 30 81 00       	add    $0x813048,%eax
  802a61:	8a 00                	mov    (%eax),%al
  802a63:	84 c0                	test   %al,%al
  802a65:	0f 84 ae 01 00 00    	je     802c19 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  802a6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a6e:	89 d0                	mov    %edx,%eax
  802a70:	01 c0                	add    %eax,%eax
  802a72:	01 d0                	add    %edx,%eax
  802a74:	c1 e0 02             	shl    $0x2,%eax
  802a77:	05 40 30 81 00       	add    $0x813040,%eax
  802a7c:	8b 08                	mov    (%eax),%ecx
  802a7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a81:	89 d0                	mov    %edx,%eax
  802a83:	01 c0                	add    %eax,%eax
  802a85:	01 d0                	add    %edx,%eax
  802a87:	c1 e0 02             	shl    $0x2,%eax
  802a8a:	05 44 30 81 00       	add    $0x813044,%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	01 c1                	add    %eax,%ecx
  802a93:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a96:	89 d0                	mov    %edx,%eax
  802a98:	01 c0                	add    %eax,%eax
  802a9a:	01 d0                	add    %edx,%eax
  802a9c:	c1 e0 02             	shl    $0x2,%eax
  802a9f:	05 40 30 81 00       	add    $0x813040,%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	39 c1                	cmp    %eax,%ecx
  802aa8:	0f 85 a8 00 00 00    	jne    802b56 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802aae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ab1:	89 d0                	mov    %edx,%eax
  802ab3:	01 c0                	add    %eax,%eax
  802ab5:	01 d0                	add    %edx,%eax
  802ab7:	c1 e0 02             	shl    $0x2,%eax
  802aba:	05 40 30 81 00       	add    $0x813040,%eax
  802abf:	8b 10                	mov    (%eax),%edx
  802ac1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802ac4:	89 c8                	mov    %ecx,%eax
  802ac6:	01 c0                	add    %eax,%eax
  802ac8:	01 c8                	add    %ecx,%eax
  802aca:	c1 e0 02             	shl    $0x2,%eax
  802acd:	05 40 30 81 00       	add    $0x813040,%eax
  802ad2:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802ad4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad7:	89 d0                	mov    %edx,%eax
  802ad9:	01 c0                	add    %eax,%eax
  802adb:	01 d0                	add    %edx,%eax
  802add:	c1 e0 02             	shl    $0x2,%eax
  802ae0:	05 44 30 81 00       	add    $0x813044,%eax
  802ae5:	8b 08                	mov    (%eax),%ecx
  802ae7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aea:	89 d0                	mov    %edx,%eax
  802aec:	01 c0                	add    %eax,%eax
  802aee:	01 d0                	add    %edx,%eax
  802af0:	c1 e0 02             	shl    $0x2,%eax
  802af3:	05 44 30 81 00       	add    $0x813044,%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	01 c1                	add    %eax,%ecx
  802afc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aff:	89 d0                	mov    %edx,%eax
  802b01:	01 c0                	add    %eax,%eax
  802b03:	01 d0                	add    %edx,%eax
  802b05:	c1 e0 02             	shl    $0x2,%eax
  802b08:	05 44 30 81 00       	add    $0x813044,%eax
  802b0d:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802b0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b12:	89 d0                	mov    %edx,%eax
  802b14:	01 c0                	add    %eax,%eax
  802b16:	01 d0                	add    %edx,%eax
  802b18:	c1 e0 02             	shl    $0x2,%eax
  802b1b:	05 48 30 81 00       	add    $0x813048,%eax
  802b20:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802b23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b26:	89 d0                	mov    %edx,%eax
  802b28:	01 c0                	add    %eax,%eax
  802b2a:	01 d0                	add    %edx,%eax
  802b2c:	c1 e0 02             	shl    $0x2,%eax
  802b2f:	05 40 30 81 00       	add    $0x813040,%eax
  802b34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802b3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b3d:	89 d0                	mov    %edx,%eax
  802b3f:	01 c0                	add    %eax,%eax
  802b41:	01 d0                	add    %edx,%eax
  802b43:	c1 e0 02             	shl    $0x2,%eax
  802b46:	05 44 30 81 00       	add    $0x813044,%eax
  802b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b51:	e9 c3 00 00 00       	jmp    802c19 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  802b56:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b59:	89 d0                	mov    %edx,%eax
  802b5b:	01 c0                	add    %eax,%eax
  802b5d:	01 d0                	add    %edx,%eax
  802b5f:	c1 e0 02             	shl    $0x2,%eax
  802b62:	05 40 30 81 00       	add    $0x813040,%eax
  802b67:	8b 08                	mov    (%eax),%ecx
  802b69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b6c:	89 d0                	mov    %edx,%eax
  802b6e:	01 c0                	add    %eax,%eax
  802b70:	01 d0                	add    %edx,%eax
  802b72:	c1 e0 02             	shl    $0x2,%eax
  802b75:	05 44 30 81 00       	add    $0x813044,%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	01 c1                	add    %eax,%ecx
  802b7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b81:	89 d0                	mov    %edx,%eax
  802b83:	01 c0                	add    %eax,%eax
  802b85:	01 d0                	add    %edx,%eax
  802b87:	c1 e0 02             	shl    $0x2,%eax
  802b8a:	05 40 30 81 00       	add    $0x813040,%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	39 c1                	cmp    %eax,%ecx
  802b93:	0f 85 80 00 00 00    	jne    802c19 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802b99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b9c:	89 d0                	mov    %edx,%eax
  802b9e:	01 c0                	add    %eax,%eax
  802ba0:	01 d0                	add    %edx,%eax
  802ba2:	c1 e0 02             	shl    $0x2,%eax
  802ba5:	05 44 30 81 00       	add    $0x813044,%eax
  802baa:	8b 08                	mov    (%eax),%ecx
  802bac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802baf:	89 d0                	mov    %edx,%eax
  802bb1:	01 c0                	add    %eax,%eax
  802bb3:	01 d0                	add    %edx,%eax
  802bb5:	c1 e0 02             	shl    $0x2,%eax
  802bb8:	05 44 30 81 00       	add    $0x813044,%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	01 c1                	add    %eax,%ecx
  802bc1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc4:	89 d0                	mov    %edx,%eax
  802bc6:	01 c0                	add    %eax,%eax
  802bc8:	01 d0                	add    %edx,%eax
  802bca:	c1 e0 02             	shl    $0x2,%eax
  802bcd:	05 44 30 81 00       	add    $0x813044,%eax
  802bd2:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802bd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bd7:	89 d0                	mov    %edx,%eax
  802bd9:	01 c0                	add    %eax,%eax
  802bdb:	01 d0                	add    %edx,%eax
  802bdd:	c1 e0 02             	shl    $0x2,%eax
  802be0:	05 48 30 81 00       	add    $0x813048,%eax
  802be5:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802be8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802beb:	89 d0                	mov    %edx,%eax
  802bed:	01 c0                	add    %eax,%eax
  802bef:	01 d0                	add    %edx,%eax
  802bf1:	c1 e0 02             	shl    $0x2,%eax
  802bf4:	05 40 30 81 00       	add    $0x813040,%eax
  802bf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802bff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c02:	89 d0                	mov    %edx,%eax
  802c04:	01 c0                	add    %eax,%eax
  802c06:	01 d0                	add    %edx,%eax
  802c08:	c1 e0 02             	shl    $0x2,%eax
  802c0b:	05 44 30 81 00       	add    $0x813044,%eax
  802c10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c16:	eb 01                	jmp    802c19 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  802c18:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802c19:	ff 45 e0             	incl   -0x20(%ebp)
  802c1c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802c23:	0f 8e 1b fe ff ff    	jle    802a44 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802c29:	a1 30 71 83 00       	mov    0x837130,%eax
  802c2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c31:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802c38:	eb 53                	jmp    802c8d <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802c3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c3d:	89 d0                	mov    %edx,%eax
  802c3f:	01 c0                	add    %eax,%eax
  802c41:	01 d0                	add    %edx,%eax
  802c43:	c1 e0 02             	shl    $0x2,%eax
  802c46:	05 48 70 80 00       	add    $0x807048,%eax
  802c4b:	8a 00                	mov    (%eax),%al
  802c4d:	84 c0                	test   %al,%al
  802c4f:	74 39                	je     802c8a <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802c51:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c54:	89 d0                	mov    %edx,%eax
  802c56:	01 c0                	add    %eax,%eax
  802c58:	01 d0                	add    %edx,%eax
  802c5a:	c1 e0 02             	shl    $0x2,%eax
  802c5d:	05 40 70 80 00       	add    $0x807040,%eax
  802c62:	8b 08                	mov    (%eax),%ecx
  802c64:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c67:	89 d0                	mov    %edx,%eax
  802c69:	01 c0                	add    %eax,%eax
  802c6b:	01 d0                	add    %edx,%eax
  802c6d:	c1 e0 02             	shl    $0x2,%eax
  802c70:	05 44 70 80 00       	add    $0x807044,%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	01 c8                	add    %ecx,%eax
  802c79:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  802c7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c7f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c82:	76 06                	jbe    802c8a <free+0x3e3>
  802c84:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c87:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c8a:	ff 45 d8             	incl   -0x28(%ebp)
  802c8d:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802c94:	7e a4                	jle    802c3a <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802c96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c99:	a3 88 70 83 00       	mov    %eax,0x837088

    sys_free_user_mem(va, size);
  802c9e:	83 ec 08             	sub    $0x8,%esp
  802ca1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ca4:	ff 75 d4             	pushl  -0x2c(%ebp)
  802ca7:	e8 79 15 00 00       	call   804225 <sys_free_user_mem>
  802cac:	83 c4 10             	add    $0x10,%esp
  802caf:	eb 01                	jmp    802cb2 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802cb1:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802cb2:	c9                   	leave  
  802cb3:	c3                   	ret    

00802cb4 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802cb4:	55                   	push   %ebp
  802cb5:	89 e5                	mov    %esp,%ebp
  802cb7:	83 ec 68             	sub    $0x68,%esp
  802cba:	8b 45 10             	mov    0x10(%ebp),%eax
  802cbd:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802cc0:	e8 a5 f7 ff ff       	call   80246a <uheap_init>
	if (size == 0) return NULL ;
  802cc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc9:	75 0a                	jne    802cd5 <smalloc+0x21>
  802ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd0:	e9 37 03 00 00       	jmp    80300c <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802cd5:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802cdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce2:	01 d0                	add    %edx,%eax
  802ce4:	48                   	dec    %eax
  802ce5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802ce8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf0:	f7 75 dc             	divl   -0x24(%ebp)
  802cf3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cf6:	29 d0                	sub    %edx,%eax
  802cf8:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802cfb:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802d02:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802d09:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802d10:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802d17:	e9 85 00 00 00       	jmp    802da1 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802d1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d1f:	89 d0                	mov    %edx,%eax
  802d21:	01 c0                	add    %eax,%eax
  802d23:	01 d0                	add    %edx,%eax
  802d25:	c1 e0 02             	shl    $0x2,%eax
  802d28:	05 48 30 81 00       	add    $0x813048,%eax
  802d2d:	8a 00                	mov    (%eax),%al
  802d2f:	84 c0                	test   %al,%al
  802d31:	74 20                	je     802d53 <smalloc+0x9f>
  802d33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d36:	89 d0                	mov    %edx,%eax
  802d38:	01 c0                	add    %eax,%eax
  802d3a:	01 d0                	add    %edx,%eax
  802d3c:	c1 e0 02             	shl    $0x2,%eax
  802d3f:	05 44 30 81 00       	add    $0x813044,%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802d49:	75 08                	jne    802d53 <smalloc+0x9f>
        {
            exactIdx = i;
  802d4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802d51:	eb 5b                	jmp    802dae <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802d53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d56:	89 d0                	mov    %edx,%eax
  802d58:	01 c0                	add    %eax,%eax
  802d5a:	01 d0                	add    %edx,%eax
  802d5c:	c1 e0 02             	shl    $0x2,%eax
  802d5f:	05 48 30 81 00       	add    $0x813048,%eax
  802d64:	8a 00                	mov    (%eax),%al
  802d66:	84 c0                	test   %al,%al
  802d68:	74 34                	je     802d9e <smalloc+0xea>
  802d6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d6d:	89 d0                	mov    %edx,%eax
  802d6f:	01 c0                	add    %eax,%eax
  802d71:	01 d0                	add    %edx,%eax
  802d73:	c1 e0 02             	shl    $0x2,%eax
  802d76:	05 44 30 81 00       	add    $0x813044,%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d80:	76 1c                	jbe    802d9e <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802d82:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d85:	89 d0                	mov    %edx,%eax
  802d87:	01 c0                	add    %eax,%eax
  802d89:	01 d0                	add    %edx,%eax
  802d8b:	c1 e0 02             	shl    $0x2,%eax
  802d8e:	05 44 30 81 00       	add    $0x813044,%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802d9e:	ff 45 e8             	incl   -0x18(%ebp)
  802da1:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802da8:	0f 8e 6e ff ff ff    	jle    802d1c <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802dae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802db5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802db9:	74 7d                	je     802e38 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802dbb:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802dc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc5:	89 d0                	mov    %edx,%eax
  802dc7:	01 c0                	add    %eax,%eax
  802dc9:	01 d0                	add    %edx,%eax
  802dcb:	c1 e0 02             	shl    $0x2,%eax
  802dce:	05 40 30 81 00       	add    $0x813040,%eax
  802dd3:	8b 10                	mov    (%eax),%edx
  802dd5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dd8:	01 d0                	add    %edx,%eax
  802dda:	48                   	dec    %eax
  802ddb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802dde:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802de1:	ba 00 00 00 00       	mov    $0x0,%edx
  802de6:	f7 75 bc             	divl   -0x44(%ebp)
  802de9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802dec:	29 d0                	sub    %edx,%eax
  802dee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df4:	89 d0                	mov    %edx,%eax
  802df6:	01 c0                	add    %eax,%eax
  802df8:	01 d0                	add    %edx,%eax
  802dfa:	c1 e0 02             	shl    $0x2,%eax
  802dfd:	05 48 30 81 00       	add    $0x813048,%eax
  802e02:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e08:	89 d0                	mov    %edx,%eax
  802e0a:	01 c0                	add    %eax,%eax
  802e0c:	01 d0                	add    %edx,%eax
  802e0e:	c1 e0 02             	shl    $0x2,%eax
  802e11:	05 44 30 81 00       	add    $0x813044,%eax
  802e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e1f:	89 d0                	mov    %edx,%eax
  802e21:	01 c0                	add    %eax,%eax
  802e23:	01 d0                	add    %edx,%eax
  802e25:	c1 e0 02             	shl    $0x2,%eax
  802e28:	05 40 30 81 00       	add    $0x813040,%eax
  802e2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e33:	e9 2d 01 00 00       	jmp    802f65 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802e38:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e3c:	0f 84 ce 00 00 00    	je     802f10 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802e42:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4c:	89 d0                	mov    %edx,%eax
  802e4e:	01 c0                	add    %eax,%eax
  802e50:	01 d0                	add    %edx,%eax
  802e52:	c1 e0 02             	shl    $0x2,%eax
  802e55:	05 40 30 81 00       	add    $0x813040,%eax
  802e5a:	8b 10                	mov    (%eax),%edx
  802e5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e5f:	01 d0                	add    %edx,%eax
  802e61:	48                   	dec    %eax
  802e62:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e65:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e68:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6d:	f7 75 c4             	divl   -0x3c(%ebp)
  802e70:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e73:	29 d0                	sub    %edx,%eax
  802e75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802e78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7b:	89 d0                	mov    %edx,%eax
  802e7d:	01 c0                	add    %eax,%eax
  802e7f:	01 d0                	add    %edx,%eax
  802e81:	c1 e0 02             	shl    $0x2,%eax
  802e84:	05 44 30 81 00       	add    $0x813044,%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802e8e:	75 47                	jne    802ed7 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802e90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e93:	89 d0                	mov    %edx,%eax
  802e95:	01 c0                	add    %eax,%eax
  802e97:	01 d0                	add    %edx,%eax
  802e99:	c1 e0 02             	shl    $0x2,%eax
  802e9c:	05 48 30 81 00       	add    $0x813048,%eax
  802ea1:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802ea4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea7:	89 d0                	mov    %edx,%eax
  802ea9:	01 c0                	add    %eax,%eax
  802eab:	01 d0                	add    %edx,%eax
  802ead:	c1 e0 02             	shl    $0x2,%eax
  802eb0:	05 44 30 81 00       	add    $0x813044,%eax
  802eb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802ebb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ebe:	89 d0                	mov    %edx,%eax
  802ec0:	01 c0                	add    %eax,%eax
  802ec2:	01 d0                	add    %edx,%eax
  802ec4:	c1 e0 02             	shl    $0x2,%eax
  802ec7:	05 40 30 81 00       	add    $0x813040,%eax
  802ecc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed2:	e9 8e 00 00 00       	jmp    802f65 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802ed7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802edd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802ee0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee3:	89 d0                	mov    %edx,%eax
  802ee5:	01 c0                	add    %eax,%eax
  802ee7:	01 d0                	add    %edx,%eax
  802ee9:	c1 e0 02             	shl    $0x2,%eax
  802eec:	05 40 30 81 00       	add    $0x813040,%eax
  802ef1:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef6:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802ef9:	89 c2                	mov    %eax,%edx
  802efb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802efe:	89 c8                	mov    %ecx,%eax
  802f00:	01 c0                	add    %eax,%eax
  802f02:	01 c8                	add    %ecx,%eax
  802f04:	c1 e0 02             	shl    $0x2,%eax
  802f07:	05 44 30 81 00       	add    $0x813044,%eax
  802f0c:	89 10                	mov    %edx,(%eax)
  802f0e:	eb 55                	jmp    802f65 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802f10:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802f17:	8b 15 88 70 83 00    	mov    0x837088,%edx
  802f1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f20:	01 d0                	add    %edx,%eax
  802f22:	48                   	dec    %eax
  802f23:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802f26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f29:	ba 00 00 00 00       	mov    $0x0,%edx
  802f2e:	f7 75 d0             	divl   -0x30(%ebp)
  802f31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f34:	29 d0                	sub    %edx,%eax
  802f36:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802f39:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f3f:	01 d0                	add    %edx,%eax
  802f41:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802f46:	76 0a                	jbe    802f52 <smalloc+0x29e>
            return NULL;
  802f48:	b8 00 00 00 00       	mov    $0x0,%eax
  802f4d:	e9 ba 00 00 00       	jmp    80300c <smalloc+0x358>
        va = start;
  802f52:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802f58:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f5e:	01 d0                	add    %edx,%eax
  802f60:	a3 88 70 83 00       	mov    %eax,0x837088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802f65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802f6c:	eb 5e                	jmp    802fcc <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802f6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f71:	89 d0                	mov    %edx,%eax
  802f73:	01 c0                	add    %eax,%eax
  802f75:	01 d0                	add    %edx,%eax
  802f77:	c1 e0 02             	shl    $0x2,%eax
  802f7a:	05 48 70 80 00       	add    $0x807048,%eax
  802f7f:	8a 00                	mov    (%eax),%al
  802f81:	84 c0                	test   %al,%al
  802f83:	75 44                	jne    802fc9 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802f85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f88:	89 d0                	mov    %edx,%eax
  802f8a:	01 c0                	add    %eax,%eax
  802f8c:	01 d0                	add    %edx,%eax
  802f8e:	c1 e0 02             	shl    $0x2,%eax
  802f91:	8d 90 40 70 80 00    	lea    0x807040(%eax),%edx
  802f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802f9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f9f:	89 d0                	mov    %edx,%eax
  802fa1:	01 c0                	add    %eax,%eax
  802fa3:	01 d0                	add    %edx,%eax
  802fa5:	c1 e0 02             	shl    $0x2,%eax
  802fa8:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  802fae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fb1:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802fb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb6:	89 d0                	mov    %edx,%eax
  802fb8:	01 c0                	add    %eax,%eax
  802fba:	01 d0                	add    %edx,%eax
  802fbc:	c1 e0 02             	shl    $0x2,%eax
  802fbf:	05 48 70 80 00       	add    $0x807048,%eax
  802fc4:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802fc7:	eb 0c                	jmp    802fd5 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802fc9:	ff 45 e0             	incl   -0x20(%ebp)
  802fcc:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802fd3:	7e 99                	jle    802f6e <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802fd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fd8:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802fdc:	52                   	push   %edx
  802fdd:	50                   	push   %eax
  802fde:	ff 75 d4             	pushl  -0x2c(%ebp)
  802fe1:	ff 75 08             	pushl  0x8(%ebp)
  802fe4:	e8 de 0e 00 00       	call   803ec7 <sys_create_shared_object>
  802fe9:	83 c4 10             	add    $0x10,%esp
  802fec:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802fef:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802ff3:	75 07                	jne    802ffc <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802ff5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802ffa:	eb 10                	jmp    80300c <smalloc+0x358>
    if (r < 0)
  802ffc:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  803000:	79 07                	jns    803009 <smalloc+0x355>
        return NULL;
  803002:	b8 00 00 00 00       	mov    $0x0,%eax
  803007:	eb 03                	jmp    80300c <smalloc+0x358>
    return (void*)va;
  803009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80300c:	c9                   	leave  
  80300d:	c3                   	ret    

0080300e <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80300e:	55                   	push   %ebp
  80300f:	89 e5                	mov    %esp,%ebp
  803011:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803014:	e8 51 f4 ff ff       	call   80246a <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  803019:	83 ec 08             	sub    $0x8,%esp
  80301c:	ff 75 0c             	pushl  0xc(%ebp)
  80301f:	ff 75 08             	pushl  0x8(%ebp)
  803022:	e8 ca 0e 00 00       	call   803ef1 <sys_size_of_shared_object>
  803027:	83 c4 10             	add    $0x10,%esp
  80302a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80302d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803031:	7f 0a                	jg     80303d <sget+0x2f>
        return NULL;
  803033:	b8 00 00 00 00       	mov    $0x0,%eax
  803038:	e9 28 03 00 00       	jmp    803365 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80303d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803044:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803047:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80304a:	01 d0                	add    %edx,%eax
  80304c:	48                   	dec    %eax
  80304d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803050:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803053:	ba 00 00 00 00       	mov    $0x0,%edx
  803058:	f7 75 d8             	divl   -0x28(%ebp)
  80305b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80305e:	29 d0                	sub    %edx,%eax
  803060:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  803063:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80306a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  803071:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  803078:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80307f:	e9 85 00 00 00       	jmp    803109 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  803084:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803087:	89 d0                	mov    %edx,%eax
  803089:	01 c0                	add    %eax,%eax
  80308b:	01 d0                	add    %edx,%eax
  80308d:	c1 e0 02             	shl    $0x2,%eax
  803090:	05 48 30 81 00       	add    $0x813048,%eax
  803095:	8a 00                	mov    (%eax),%al
  803097:	84 c0                	test   %al,%al
  803099:	74 20                	je     8030bb <sget+0xad>
  80309b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309e:	89 d0                	mov    %edx,%eax
  8030a0:	01 c0                	add    %eax,%eax
  8030a2:	01 d0                	add    %edx,%eax
  8030a4:	c1 e0 02             	shl    $0x2,%eax
  8030a7:	05 44 30 81 00       	add    $0x813044,%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8030b1:	75 08                	jne    8030bb <sget+0xad>
        {
            exactIdx = i;
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8030b9:	eb 5b                	jmp    803116 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8030bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030be:	89 d0                	mov    %edx,%eax
  8030c0:	01 c0                	add    %eax,%eax
  8030c2:	01 d0                	add    %edx,%eax
  8030c4:	c1 e0 02             	shl    $0x2,%eax
  8030c7:	05 48 30 81 00       	add    $0x813048,%eax
  8030cc:	8a 00                	mov    (%eax),%al
  8030ce:	84 c0                	test   %al,%al
  8030d0:	74 34                	je     803106 <sget+0xf8>
  8030d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d5:	89 d0                	mov    %edx,%eax
  8030d7:	01 c0                	add    %eax,%eax
  8030d9:	01 d0                	add    %edx,%eax
  8030db:	c1 e0 02             	shl    $0x2,%eax
  8030de:	05 44 30 81 00       	add    $0x813044,%eax
  8030e3:	8b 00                	mov    (%eax),%eax
  8030e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8030e8:	76 1c                	jbe    803106 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8030ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ed:	89 d0                	mov    %edx,%eax
  8030ef:	01 c0                	add    %eax,%eax
  8030f1:	01 d0                	add    %edx,%eax
  8030f3:	c1 e0 02             	shl    $0x2,%eax
  8030f6:	05 44 30 81 00       	add    $0x813044,%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  803106:	ff 45 e8             	incl   -0x18(%ebp)
  803109:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803110:	0f 8e 6e ff ff ff    	jle    803084 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  803116:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80311d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  803121:	74 7d                	je     8031a0 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  803123:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80312a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80312d:	89 d0                	mov    %edx,%eax
  80312f:	01 c0                	add    %eax,%eax
  803131:	01 d0                	add    %edx,%eax
  803133:	c1 e0 02             	shl    $0x2,%eax
  803136:	05 40 30 81 00       	add    $0x813040,%eax
  80313b:	8b 10                	mov    (%eax),%edx
  80313d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803140:	01 d0                	add    %edx,%eax
  803142:	48                   	dec    %eax
  803143:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803146:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803149:	ba 00 00 00 00       	mov    $0x0,%edx
  80314e:	f7 75 b8             	divl   -0x48(%ebp)
  803151:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803154:	29 d0                	sub    %edx,%eax
  803156:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  803159:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80315c:	89 d0                	mov    %edx,%eax
  80315e:	01 c0                	add    %eax,%eax
  803160:	01 d0                	add    %edx,%eax
  803162:	c1 e0 02             	shl    $0x2,%eax
  803165:	05 48 30 81 00       	add    $0x813048,%eax
  80316a:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80316d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803170:	89 d0                	mov    %edx,%eax
  803172:	01 c0                	add    %eax,%eax
  803174:	01 d0                	add    %edx,%eax
  803176:	c1 e0 02             	shl    $0x2,%eax
  803179:	05 44 30 81 00       	add    $0x813044,%eax
  80317e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  803184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803187:	89 d0                	mov    %edx,%eax
  803189:	01 c0                	add    %eax,%eax
  80318b:	01 d0                	add    %edx,%eax
  80318d:	c1 e0 02             	shl    $0x2,%eax
  803190:	05 40 30 81 00       	add    $0x813040,%eax
  803195:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319b:	e9 2d 01 00 00       	jmp    8032cd <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8031a0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8031a4:	0f 84 ce 00 00 00    	je     803278 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8031aa:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8031b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b4:	89 d0                	mov    %edx,%eax
  8031b6:	01 c0                	add    %eax,%eax
  8031b8:	01 d0                	add    %edx,%eax
  8031ba:	c1 e0 02             	shl    $0x2,%eax
  8031bd:	05 40 30 81 00       	add    $0x813040,%eax
  8031c2:	8b 10                	mov    (%eax),%edx
  8031c4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031c7:	01 d0                	add    %edx,%eax
  8031c9:	48                   	dec    %eax
  8031ca:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8031cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8031d5:	f7 75 c0             	divl   -0x40(%ebp)
  8031d8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031db:	29 d0                	sub    %edx,%eax
  8031dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8031e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e3:	89 d0                	mov    %edx,%eax
  8031e5:	01 c0                	add    %eax,%eax
  8031e7:	01 d0                	add    %edx,%eax
  8031e9:	c1 e0 02             	shl    $0x2,%eax
  8031ec:	05 44 30 81 00       	add    $0x813044,%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8031f6:	75 47                	jne    80323f <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8031f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031fb:	89 d0                	mov    %edx,%eax
  8031fd:	01 c0                	add    %eax,%eax
  8031ff:	01 d0                	add    %edx,%eax
  803201:	c1 e0 02             	shl    $0x2,%eax
  803204:	05 48 30 81 00       	add    $0x813048,%eax
  803209:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80320c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320f:	89 d0                	mov    %edx,%eax
  803211:	01 c0                	add    %eax,%eax
  803213:	01 d0                	add    %edx,%eax
  803215:	c1 e0 02             	shl    $0x2,%eax
  803218:	05 44 30 81 00       	add    $0x813044,%eax
  80321d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  803223:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803226:	89 d0                	mov    %edx,%eax
  803228:	01 c0                	add    %eax,%eax
  80322a:	01 d0                	add    %edx,%eax
  80322c:	c1 e0 02             	shl    $0x2,%eax
  80322f:	05 40 30 81 00       	add    $0x813040,%eax
  803234:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323a:	e9 8e 00 00 00       	jmp    8032cd <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80323f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803242:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803245:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  803248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324b:	89 d0                	mov    %edx,%eax
  80324d:	01 c0                	add    %eax,%eax
  80324f:	01 d0                	add    %edx,%eax
  803251:	c1 e0 02             	shl    $0x2,%eax
  803254:	05 40 30 81 00       	add    $0x813040,%eax
  803259:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80325b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325e:	2b 45 d0             	sub    -0x30(%ebp),%eax
  803261:	89 c2                	mov    %eax,%edx
  803263:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803266:	89 c8                	mov    %ecx,%eax
  803268:	01 c0                	add    %eax,%eax
  80326a:	01 c8                	add    %ecx,%eax
  80326c:	c1 e0 02             	shl    $0x2,%eax
  80326f:	05 44 30 81 00       	add    $0x813044,%eax
  803274:	89 10                	mov    %edx,(%eax)
  803276:	eb 55                	jmp    8032cd <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  803278:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80327f:	8b 15 88 70 83 00    	mov    0x837088,%edx
  803285:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803288:	01 d0                	add    %edx,%eax
  80328a:	48                   	dec    %eax
  80328b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80328e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803291:	ba 00 00 00 00       	mov    $0x0,%edx
  803296:	f7 75 cc             	divl   -0x34(%ebp)
  803299:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80329c:	29 d0                	sub    %edx,%eax
  80329e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8032a1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8032a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032a7:	01 d0                	add    %edx,%eax
  8032a9:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8032ae:	76 0a                	jbe    8032ba <sget+0x2ac>
            return NULL;
  8032b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b5:	e9 ab 00 00 00       	jmp    803365 <sget+0x357>
        va = start;
  8032ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8032c0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8032c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032c6:	01 d0                	add    %edx,%eax
  8032c8:	a3 88 70 83 00       	mov    %eax,0x837088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8032cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032d4:	eb 5e                	jmp    803334 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8032d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032d9:	89 d0                	mov    %edx,%eax
  8032db:	01 c0                	add    %eax,%eax
  8032dd:	01 d0                	add    %edx,%eax
  8032df:	c1 e0 02             	shl    $0x2,%eax
  8032e2:	05 48 70 80 00       	add    $0x807048,%eax
  8032e7:	8a 00                	mov    (%eax),%al
  8032e9:	84 c0                	test   %al,%al
  8032eb:	75 44                	jne    803331 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8032ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032f0:	89 d0                	mov    %edx,%eax
  8032f2:	01 c0                	add    %eax,%eax
  8032f4:	01 d0                	add    %edx,%eax
  8032f6:	c1 e0 02             	shl    $0x2,%eax
  8032f9:	8d 90 40 70 80 00    	lea    0x807040(%eax),%edx
  8032ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803302:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  803304:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803307:	89 d0                	mov    %edx,%eax
  803309:	01 c0                	add    %eax,%eax
  80330b:	01 d0                	add    %edx,%eax
  80330d:	c1 e0 02             	shl    $0x2,%eax
  803310:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  803316:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803319:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80331b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80331e:	89 d0                	mov    %edx,%eax
  803320:	01 c0                	add    %eax,%eax
  803322:	01 d0                	add    %edx,%eax
  803324:	c1 e0 02             	shl    $0x2,%eax
  803327:	05 48 70 80 00       	add    $0x807048,%eax
  80332c:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80332f:	eb 0c                	jmp    80333d <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803331:	ff 45 e0             	incl   -0x20(%ebp)
  803334:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80333b:	7e 99                	jle    8032d6 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80333d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	50                   	push   %eax
  803344:	ff 75 0c             	pushl  0xc(%ebp)
  803347:	ff 75 08             	pushl  0x8(%ebp)
  80334a:	e8 bf 0b 00 00       	call   803f0e <sys_get_shared_object>
  80334f:	83 c4 10             	add    $0x10,%esp
  803352:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  803355:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803359:	79 07                	jns    803362 <sget+0x354>
        return NULL;
  80335b:	b8 00 00 00 00       	mov    $0x0,%eax
  803360:	eb 03                	jmp    803365 <sget+0x357>
    return (void*)va;
  803362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803365:	c9                   	leave  
  803366:	c3                   	ret    

00803367 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803367:	55                   	push   %ebp
  803368:	89 e5                	mov    %esp,%ebp
  80336a:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80336d:	e8 f8 f0 ff ff       	call   80246a <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  803372:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803376:	75 13                	jne    80338b <realloc+0x24>
		return malloc(new_size);
  803378:	83 ec 0c             	sub    $0xc,%esp
  80337b:	ff 75 0c             	pushl  0xc(%ebp)
  80337e:	e8 c4 f1 ff ff       	call   802547 <malloc>
  803383:	83 c4 10             	add    $0x10,%esp
  803386:	e9 f4 05 00 00       	jmp    80397f <realloc+0x618>
	if (new_size == 0)
  80338b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80338f:	75 18                	jne    8033a9 <realloc+0x42>
	{
		free(virtual_address);
  803391:	83 ec 0c             	sub    $0xc,%esp
  803394:	ff 75 08             	pushl  0x8(%ebp)
  803397:	e8 0b f5 ff ff       	call   8028a7 <free>
  80339c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80339f:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a4:	e9 d6 05 00 00       	jmp    80397f <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8033af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	79 74                	jns    80342a <realloc+0xc3>
  8033b6:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8033bd:	77 6b                	ja     80342a <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8033bf:	83 ec 0c             	sub    $0xc,%esp
  8033c2:	ff 75 0c             	pushl  0xc(%ebp)
  8033c5:	e8 7d f1 ff ff       	call   802547 <malloc>
  8033ca:	83 c4 10             	add    $0x10,%esp
  8033cd:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8033d0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033d4:	75 0a                	jne    8033e0 <realloc+0x79>
			return NULL;
  8033d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033db:	e9 9f 05 00 00       	jmp    80397f <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8033e0:	83 ec 0c             	sub    $0xc,%esp
  8033e3:	ff 75 08             	pushl  0x8(%ebp)
  8033e6:	e8 e0 11 00 00       	call   8045cb <get_block_size>
  8033eb:	83 c4 10             	add    $0x10,%esp
  8033ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8033f1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8033f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f7:	39 d0                	cmp    %edx,%eax
  8033f9:	76 02                	jbe    8033fd <realloc+0x96>
  8033fb:	89 d0                	mov    %edx,%eax
  8033fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  803400:	83 ec 04             	sub    $0x4,%esp
  803403:	ff 75 c0             	pushl  -0x40(%ebp)
  803406:	ff 75 08             	pushl  0x8(%ebp)
  803409:	ff 75 c8             	pushl  -0x38(%ebp)
  80340c:	e8 56 eb ff ff       	call   801f67 <memmove>
  803411:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  803414:	83 ec 0c             	sub    $0xc,%esp
  803417:	ff 75 08             	pushl  0x8(%ebp)
  80341a:	e8 88 f4 ff ff       	call   8028a7 <free>
  80341f:	83 c4 10             	add    $0x10,%esp
		return newptr;
  803422:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803425:	e9 55 05 00 00       	jmp    80397f <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80342a:	a1 30 71 83 00       	mov    0x837130,%eax
  80342f:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  803432:	72 09                	jb     80343d <realloc+0xd6>
  803434:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80343b:	76 0a                	jbe    803447 <realloc+0xe0>
		return NULL;
  80343d:	b8 00 00 00 00       	mov    $0x0,%eax
  803442:	e9 38 05 00 00       	jmp    80397f <realloc+0x618>
	uint32 oldsz = 0;
  803447:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  80344e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803455:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80345c:	eb 50                	jmp    8034ae <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80345e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803461:	89 d0                	mov    %edx,%eax
  803463:	01 c0                	add    %eax,%eax
  803465:	01 d0                	add    %edx,%eax
  803467:	c1 e0 02             	shl    $0x2,%eax
  80346a:	05 48 70 80 00       	add    $0x807048,%eax
  80346f:	8a 00                	mov    (%eax),%al
  803471:	84 c0                	test   %al,%al
  803473:	74 36                	je     8034ab <realloc+0x144>
  803475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803478:	89 d0                	mov    %edx,%eax
  80347a:	01 c0                	add    %eax,%eax
  80347c:	01 d0                	add    %edx,%eax
  80347e:	c1 e0 02             	shl    $0x2,%eax
  803481:	05 40 70 80 00       	add    $0x807040,%eax
  803486:	8b 00                	mov    (%eax),%eax
  803488:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80348b:	75 1e                	jne    8034ab <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80348d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803490:	89 d0                	mov    %edx,%eax
  803492:	01 c0                	add    %eax,%eax
  803494:	01 d0                	add    %edx,%eax
  803496:	c1 e0 02             	shl    $0x2,%eax
  803499:	05 44 70 80 00       	add    $0x807044,%eax
  80349e:	8b 00                	mov    (%eax),%eax
  8034a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8034a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8034a9:	eb 0c                	jmp    8034b7 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8034ab:	ff 45 ec             	incl   -0x14(%ebp)
  8034ae:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8034b5:	7e a7                	jle    80345e <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8034b7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8034bb:	75 0a                	jne    8034c7 <realloc+0x160>
		return NULL;
  8034bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c2:	e9 b8 04 00 00       	jmp    80397f <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8034c7:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8034ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8034d4:	01 d0                	add    %edx,%eax
  8034d6:	48                   	dec    %eax
  8034d7:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8034da:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8034dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e2:	f7 75 bc             	divl   -0x44(%ebp)
  8034e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8034e8:	29 d0                	sub    %edx,%eax
  8034ea:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8034ed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8034f3:	75 08                	jne    8034fd <realloc+0x196>
		return virtual_address;
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	e9 82 04 00 00       	jmp    80397f <realloc+0x618>
	if (req < oldsz)
  8034fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803500:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803503:	0f 83 cd 02 00 00    	jae    8037d6 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  803509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350c:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  80350f:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  803512:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803515:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803518:	01 d0                	add    %edx,%eax
  80351a:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  80351d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803520:	89 d0                	mov    %edx,%eax
  803522:	01 c0                	add    %eax,%eax
  803524:	01 d0                	add    %edx,%eax
  803526:	c1 e0 02             	shl    $0x2,%eax
  803529:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  80352f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803532:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  803534:	83 ec 08             	sub    $0x8,%esp
  803537:	ff 75 b0             	pushl  -0x50(%ebp)
  80353a:	ff 75 ac             	pushl  -0x54(%ebp)
  80353d:	e8 e3 0c 00 00       	call   804225 <sys_free_user_mem>
  803542:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  803545:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80354c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  803553:	eb 64                	jmp    8035b9 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  803555:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803558:	89 d0                	mov    %edx,%eax
  80355a:	01 c0                	add    %eax,%eax
  80355c:	01 d0                	add    %edx,%eax
  80355e:	c1 e0 02             	shl    $0x2,%eax
  803561:	05 48 30 81 00       	add    $0x813048,%eax
  803566:	8a 00                	mov    (%eax),%al
  803568:	84 c0                	test   %al,%al
  80356a:	75 4a                	jne    8035b6 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  80356c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80356f:	89 d0                	mov    %edx,%eax
  803571:	01 c0                	add    %eax,%eax
  803573:	01 d0                	add    %edx,%eax
  803575:	c1 e0 02             	shl    $0x2,%eax
  803578:	8d 90 40 30 81 00    	lea    0x813040(%eax),%edx
  80357e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803581:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  803583:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803586:	89 d0                	mov    %edx,%eax
  803588:	01 c0                	add    %eax,%eax
  80358a:	01 d0                	add    %edx,%eax
  80358c:	c1 e0 02             	shl    $0x2,%eax
  80358f:	8d 90 44 30 81 00    	lea    0x813044(%eax),%edx
  803595:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803598:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80359a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80359d:	89 d0                	mov    %edx,%eax
  80359f:	01 c0                	add    %eax,%eax
  8035a1:	01 d0                	add    %edx,%eax
  8035a3:	c1 e0 02             	shl    $0x2,%eax
  8035a6:	05 48 30 81 00       	add    $0x813048,%eax
  8035ab:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8035ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8035b4:	eb 0c                	jmp    8035c2 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8035b6:	ff 45 e4             	incl   -0x1c(%ebp)
  8035b9:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8035c0:	7e 93                	jle    803555 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8035c2:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8035c6:	0f 84 8d 01 00 00    	je     803759 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8035cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8035d3:	e9 74 01 00 00       	jmp    80374c <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8035d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035db:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035de:	0f 84 64 01 00 00    	je     803748 <realloc+0x3e1>
				if (uhp_frees[k].free)
  8035e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035e7:	89 d0                	mov    %edx,%eax
  8035e9:	01 c0                	add    %eax,%eax
  8035eb:	01 d0                	add    %edx,%eax
  8035ed:	c1 e0 02             	shl    $0x2,%eax
  8035f0:	05 48 30 81 00       	add    $0x813048,%eax
  8035f5:	8a 00                	mov    (%eax),%al
  8035f7:	84 c0                	test   %al,%al
  8035f9:	0f 84 4a 01 00 00    	je     803749 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8035ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803602:	89 d0                	mov    %edx,%eax
  803604:	01 c0                	add    %eax,%eax
  803606:	01 d0                	add    %edx,%eax
  803608:	c1 e0 02             	shl    $0x2,%eax
  80360b:	05 40 30 81 00       	add    $0x813040,%eax
  803610:	8b 08                	mov    (%eax),%ecx
  803612:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803615:	89 d0                	mov    %edx,%eax
  803617:	01 c0                	add    %eax,%eax
  803619:	01 d0                	add    %edx,%eax
  80361b:	c1 e0 02             	shl    $0x2,%eax
  80361e:	05 44 30 81 00       	add    $0x813044,%eax
  803623:	8b 00                	mov    (%eax),%eax
  803625:	01 c1                	add    %eax,%ecx
  803627:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80362a:	89 d0                	mov    %edx,%eax
  80362c:	01 c0                	add    %eax,%eax
  80362e:	01 d0                	add    %edx,%eax
  803630:	c1 e0 02             	shl    $0x2,%eax
  803633:	05 40 30 81 00       	add    $0x813040,%eax
  803638:	8b 00                	mov    (%eax),%eax
  80363a:	39 c1                	cmp    %eax,%ecx
  80363c:	75 7a                	jne    8036b8 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  80363e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803641:	89 d0                	mov    %edx,%eax
  803643:	01 c0                	add    %eax,%eax
  803645:	01 d0                	add    %edx,%eax
  803647:	c1 e0 02             	shl    $0x2,%eax
  80364a:	05 40 30 81 00       	add    $0x813040,%eax
  80364f:	8b 10                	mov    (%eax),%edx
  803651:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803654:	89 c8                	mov    %ecx,%eax
  803656:	01 c0                	add    %eax,%eax
  803658:	01 c8                	add    %ecx,%eax
  80365a:	c1 e0 02             	shl    $0x2,%eax
  80365d:	05 40 30 81 00       	add    $0x813040,%eax
  803662:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  803664:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803667:	89 d0                	mov    %edx,%eax
  803669:	01 c0                	add    %eax,%eax
  80366b:	01 d0                	add    %edx,%eax
  80366d:	c1 e0 02             	shl    $0x2,%eax
  803670:	05 44 30 81 00       	add    $0x813044,%eax
  803675:	8b 08                	mov    (%eax),%ecx
  803677:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80367a:	89 d0                	mov    %edx,%eax
  80367c:	01 c0                	add    %eax,%eax
  80367e:	01 d0                	add    %edx,%eax
  803680:	c1 e0 02             	shl    $0x2,%eax
  803683:	05 44 30 81 00       	add    $0x813044,%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	01 c1                	add    %eax,%ecx
  80368c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80368f:	89 d0                	mov    %edx,%eax
  803691:	01 c0                	add    %eax,%eax
  803693:	01 d0                	add    %edx,%eax
  803695:	c1 e0 02             	shl    $0x2,%eax
  803698:	05 44 30 81 00       	add    $0x813044,%eax
  80369d:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80369f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036a2:	89 d0                	mov    %edx,%eax
  8036a4:	01 c0                	add    %eax,%eax
  8036a6:	01 d0                	add    %edx,%eax
  8036a8:	c1 e0 02             	shl    $0x2,%eax
  8036ab:	05 48 30 81 00       	add    $0x813048,%eax
  8036b0:	c6 00 00             	movb   $0x0,(%eax)
  8036b3:	e9 91 00 00 00       	jmp    803749 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8036b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036bb:	89 d0                	mov    %edx,%eax
  8036bd:	01 c0                	add    %eax,%eax
  8036bf:	01 d0                	add    %edx,%eax
  8036c1:	c1 e0 02             	shl    $0x2,%eax
  8036c4:	05 40 30 81 00       	add    $0x813040,%eax
  8036c9:	8b 08                	mov    (%eax),%ecx
  8036cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ce:	89 d0                	mov    %edx,%eax
  8036d0:	01 c0                	add    %eax,%eax
  8036d2:	01 d0                	add    %edx,%eax
  8036d4:	c1 e0 02             	shl    $0x2,%eax
  8036d7:	05 44 30 81 00       	add    $0x813044,%eax
  8036dc:	8b 00                	mov    (%eax),%eax
  8036de:	01 c1                	add    %eax,%ecx
  8036e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036e3:	89 d0                	mov    %edx,%eax
  8036e5:	01 c0                	add    %eax,%eax
  8036e7:	01 d0                	add    %edx,%eax
  8036e9:	c1 e0 02             	shl    $0x2,%eax
  8036ec:	05 40 30 81 00       	add    $0x813040,%eax
  8036f1:	8b 00                	mov    (%eax),%eax
  8036f3:	39 c1                	cmp    %eax,%ecx
  8036f5:	75 52                	jne    803749 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8036f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036fa:	89 d0                	mov    %edx,%eax
  8036fc:	01 c0                	add    %eax,%eax
  8036fe:	01 d0                	add    %edx,%eax
  803700:	c1 e0 02             	shl    $0x2,%eax
  803703:	05 44 30 81 00       	add    $0x813044,%eax
  803708:	8b 08                	mov    (%eax),%ecx
  80370a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80370d:	89 d0                	mov    %edx,%eax
  80370f:	01 c0                	add    %eax,%eax
  803711:	01 d0                	add    %edx,%eax
  803713:	c1 e0 02             	shl    $0x2,%eax
  803716:	05 44 30 81 00       	add    $0x813044,%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	01 c1                	add    %eax,%ecx
  80371f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803722:	89 d0                	mov    %edx,%eax
  803724:	01 c0                	add    %eax,%eax
  803726:	01 d0                	add    %edx,%eax
  803728:	c1 e0 02             	shl    $0x2,%eax
  80372b:	05 44 30 81 00       	add    $0x813044,%eax
  803730:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  803732:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803735:	89 d0                	mov    %edx,%eax
  803737:	01 c0                	add    %eax,%eax
  803739:	01 d0                	add    %edx,%eax
  80373b:	c1 e0 02             	shl    $0x2,%eax
  80373e:	05 48 30 81 00       	add    $0x813048,%eax
  803743:	c6 00 00             	movb   $0x0,(%eax)
  803746:	eb 01                	jmp    803749 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  803748:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803749:	ff 45 e0             	incl   -0x20(%ebp)
  80374c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803753:	0f 8e 7f fe ff ff    	jle    8035d8 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  803759:	a1 30 71 83 00       	mov    0x837130,%eax
  80375e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803761:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  803768:	eb 53                	jmp    8037bd <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  80376a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80376d:	89 d0                	mov    %edx,%eax
  80376f:	01 c0                	add    %eax,%eax
  803771:	01 d0                	add    %edx,%eax
  803773:	c1 e0 02             	shl    $0x2,%eax
  803776:	05 48 70 80 00       	add    $0x807048,%eax
  80377b:	8a 00                	mov    (%eax),%al
  80377d:	84 c0                	test   %al,%al
  80377f:	74 39                	je     8037ba <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803781:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803784:	89 d0                	mov    %edx,%eax
  803786:	01 c0                	add    %eax,%eax
  803788:	01 d0                	add    %edx,%eax
  80378a:	c1 e0 02             	shl    $0x2,%eax
  80378d:	05 40 70 80 00       	add    $0x807040,%eax
  803792:	8b 08                	mov    (%eax),%ecx
  803794:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803797:	89 d0                	mov    %edx,%eax
  803799:	01 c0                	add    %eax,%eax
  80379b:	01 d0                	add    %edx,%eax
  80379d:	c1 e0 02             	shl    $0x2,%eax
  8037a0:	05 44 70 80 00       	add    $0x807044,%eax
  8037a5:	8b 00                	mov    (%eax),%eax
  8037a7:	01 c8                	add    %ecx,%eax
  8037a9:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8037ac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8037af:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8037b2:	76 06                	jbe    8037ba <realloc+0x453>
  8037b4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8037b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8037ba:	ff 45 d8             	incl   -0x28(%ebp)
  8037bd:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8037c4:	7e a4                	jle    80376a <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8037c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c9:	a3 88 70 83 00       	mov    %eax,0x837088
		return virtual_address;
  8037ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d1:	e9 a9 01 00 00       	jmp    80397f <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8037d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dc:	01 d0                	add    %edx,%eax
  8037de:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8037e1:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8037e8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8037ef:	eb 57                	jmp    803848 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8037f1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8037f4:	89 d0                	mov    %edx,%eax
  8037f6:	01 c0                	add    %eax,%eax
  8037f8:	01 d0                	add    %edx,%eax
  8037fa:	c1 e0 02             	shl    $0x2,%eax
  8037fd:	05 48 30 81 00       	add    $0x813048,%eax
  803802:	8a 00                	mov    (%eax),%al
  803804:	84 c0                	test   %al,%al
  803806:	74 3d                	je     803845 <realloc+0x4de>
  803808:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80380b:	89 d0                	mov    %edx,%eax
  80380d:	01 c0                	add    %eax,%eax
  80380f:	01 d0                	add    %edx,%eax
  803811:	c1 e0 02             	shl    $0x2,%eax
  803814:	05 40 30 81 00       	add    $0x813040,%eax
  803819:	8b 00                	mov    (%eax),%eax
  80381b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80381e:	75 25                	jne    803845 <realloc+0x4de>
  803820:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803823:	89 d0                	mov    %edx,%eax
  803825:	01 c0                	add    %eax,%eax
  803827:	01 d0                	add    %edx,%eax
  803829:	c1 e0 02             	shl    $0x2,%eax
  80382c:	05 44 30 81 00       	add    $0x813044,%eax
  803831:	8b 10                	mov    (%eax),%edx
  803833:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803836:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803839:	39 c2                	cmp    %eax,%edx
  80383b:	72 08                	jb     803845 <realloc+0x4de>
		{
			adjIdx = j; break;
  80383d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803840:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803843:	eb 0c                	jmp    803851 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803845:	ff 45 d0             	incl   -0x30(%ebp)
  803848:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  80384f:	7e a0                	jle    8037f1 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  803851:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  803855:	0f 84 d6 00 00 00    	je     803931 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  80385b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80385e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803861:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  803864:	83 ec 08             	sub    $0x8,%esp
  803867:	ff 75 a0             	pushl  -0x60(%ebp)
  80386a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80386d:	e8 cf 09 00 00       	call   804241 <sys_allocate_user_mem>
  803872:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  803875:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803878:	89 d0                	mov    %edx,%eax
  80387a:	01 c0                	add    %eax,%eax
  80387c:	01 d0                	add    %edx,%eax
  80387e:	c1 e0 02             	shl    $0x2,%eax
  803881:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  803887:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80388a:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  80388c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80388f:	89 d0                	mov    %edx,%eax
  803891:	01 c0                	add    %eax,%eax
  803893:	01 d0                	add    %edx,%eax
  803895:	c1 e0 02             	shl    $0x2,%eax
  803898:	05 40 30 81 00       	add    $0x813040,%eax
  80389d:	8b 10                	mov    (%eax),%edx
  80389f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8038a2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8038a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038a8:	89 d0                	mov    %edx,%eax
  8038aa:	01 c0                	add    %eax,%eax
  8038ac:	01 d0                	add    %edx,%eax
  8038ae:	c1 e0 02             	shl    $0x2,%eax
  8038b1:	05 40 30 81 00       	add    $0x813040,%eax
  8038b6:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8038b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038bb:	89 d0                	mov    %edx,%eax
  8038bd:	01 c0                	add    %eax,%eax
  8038bf:	01 d0                	add    %edx,%eax
  8038c1:	c1 e0 02             	shl    $0x2,%eax
  8038c4:	05 44 30 81 00       	add    $0x813044,%eax
  8038c9:	8b 00                	mov    (%eax),%eax
  8038cb:	2b 45 a0             	sub    -0x60(%ebp),%eax
  8038ce:	89 c2                	mov    %eax,%edx
  8038d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8038d3:	89 c8                	mov    %ecx,%eax
  8038d5:	01 c0                	add    %eax,%eax
  8038d7:	01 c8                	add    %ecx,%eax
  8038d9:	c1 e0 02             	shl    $0x2,%eax
  8038dc:	05 44 30 81 00       	add    $0x813044,%eax
  8038e1:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  8038e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038e6:	89 d0                	mov    %edx,%eax
  8038e8:	01 c0                	add    %eax,%eax
  8038ea:	01 d0                	add    %edx,%eax
  8038ec:	c1 e0 02             	shl    $0x2,%eax
  8038ef:	05 44 30 81 00       	add    $0x813044,%eax
  8038f4:	8b 00                	mov    (%eax),%eax
  8038f6:	85 c0                	test   %eax,%eax
  8038f8:	75 14                	jne    80390e <realloc+0x5a7>
  8038fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038fd:	89 d0                	mov    %edx,%eax
  8038ff:	01 c0                	add    %eax,%eax
  803901:	01 d0                	add    %edx,%eax
  803903:	c1 e0 02             	shl    $0x2,%eax
  803906:	05 48 30 81 00       	add    $0x813048,%eax
  80390b:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  80390e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803911:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803914:	01 c2                	add    %eax,%edx
  803916:	a1 88 70 83 00       	mov    0x837088,%eax
  80391b:	39 c2                	cmp    %eax,%edx
  80391d:	76 0d                	jbe    80392c <realloc+0x5c5>
  80391f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803922:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803925:	01 d0                	add    %edx,%eax
  803927:	a3 88 70 83 00       	mov    %eax,0x837088
		return virtual_address;
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	eb 4e                	jmp    80397f <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  803931:	83 ec 0c             	sub    $0xc,%esp
  803934:	ff 75 0c             	pushl  0xc(%ebp)
  803937:	e8 0b ec ff ff       	call   802547 <malloc>
  80393c:	83 c4 10             	add    $0x10,%esp
  80393f:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  803942:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  803946:	75 07                	jne    80394f <realloc+0x5e8>
		return NULL;
  803948:	b8 00 00 00 00       	mov    $0x0,%eax
  80394d:	eb 30                	jmp    80397f <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  80394f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803952:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803955:	39 d0                	cmp    %edx,%eax
  803957:	76 02                	jbe    80395b <realloc+0x5f4>
  803959:	89 d0                	mov    %edx,%eax
  80395b:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80395e:	83 ec 04             	sub    $0x4,%esp
  803961:	50                   	push   %eax
  803962:	52                   	push   %edx
  803963:	ff 75 cc             	pushl  -0x34(%ebp)
  803966:	e8 cf 06 00 00       	call   80403a <sys_move_user_mem>
  80396b:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  80396e:	83 ec 0c             	sub    $0xc,%esp
  803971:	ff 75 08             	pushl  0x8(%ebp)
  803974:	e8 2e ef ff ff       	call   8028a7 <free>
  803979:	83 c4 10             	add    $0x10,%esp
	return newptr;
  80397c:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  80397f:	c9                   	leave  
  803980:	c3                   	ret    

00803981 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803981:	55                   	push   %ebp
  803982:	89 e5                	mov    %esp,%ebp
  803984:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  803987:	8b 45 08             	mov    0x8(%ebp),%eax
  80398a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  80398d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803991:	0f 84 33 03 00 00    	je     803cca <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  803997:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  80399f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8039a2:	83 ec 08             	sub    $0x8,%esp
  8039a5:	ff 75 08             	pushl  0x8(%ebp)
  8039a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8039ab:	e8 7d 05 00 00       	call   803f2d <sys_delete_shared_object>
  8039b0:	83 c4 10             	add    $0x10,%esp
  8039b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8039b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039ba:	0f 88 0d 03 00 00    	js     803ccd <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8039c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8039c7:	e9 ef 02 00 00       	jmp    803cbb <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8039cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039cf:	89 d0                	mov    %edx,%eax
  8039d1:	01 c0                	add    %eax,%eax
  8039d3:	01 d0                	add    %edx,%eax
  8039d5:	c1 e0 02             	shl    $0x2,%eax
  8039d8:	05 48 70 80 00       	add    $0x807048,%eax
  8039dd:	8a 00                	mov    (%eax),%al
  8039df:	84 c0                	test   %al,%al
  8039e1:	0f 84 d1 02 00 00    	je     803cb8 <sfree+0x337>
  8039e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039ea:	89 d0                	mov    %edx,%eax
  8039ec:	01 c0                	add    %eax,%eax
  8039ee:	01 d0                	add    %edx,%eax
  8039f0:	c1 e0 02             	shl    $0x2,%eax
  8039f3:	05 40 70 80 00       	add    $0x807040,%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8039fd:	0f 85 b5 02 00 00    	jne    803cb8 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803a03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a06:	89 d0                	mov    %edx,%eax
  803a08:	01 c0                	add    %eax,%eax
  803a0a:	01 d0                	add    %edx,%eax
  803a0c:	c1 e0 02             	shl    $0x2,%eax
  803a0f:	05 44 70 80 00       	add    $0x807044,%eax
  803a14:	8b 00                	mov    (%eax),%eax
  803a16:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a1c:	89 d0                	mov    %edx,%eax
  803a1e:	01 c0                	add    %eax,%eax
  803a20:	01 d0                	add    %edx,%eax
  803a22:	c1 e0 02             	shl    $0x2,%eax
  803a25:	05 48 70 80 00       	add    $0x807048,%eax
  803a2a:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  803a2d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803a34:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803a3b:	eb 64                	jmp    803aa1 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  803a3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a40:	89 d0                	mov    %edx,%eax
  803a42:	01 c0                	add    %eax,%eax
  803a44:	01 d0                	add    %edx,%eax
  803a46:	c1 e0 02             	shl    $0x2,%eax
  803a49:	05 48 30 81 00       	add    $0x813048,%eax
  803a4e:	8a 00                	mov    (%eax),%al
  803a50:	84 c0                	test   %al,%al
  803a52:	75 4a                	jne    803a9e <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  803a54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a57:	89 d0                	mov    %edx,%eax
  803a59:	01 c0                	add    %eax,%eax
  803a5b:	01 d0                	add    %edx,%eax
  803a5d:	c1 e0 02             	shl    $0x2,%eax
  803a60:	8d 90 40 30 81 00    	lea    0x813040(%eax),%edx
  803a66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a69:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  803a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a6e:	89 d0                	mov    %edx,%eax
  803a70:	01 c0                	add    %eax,%eax
  803a72:	01 d0                	add    %edx,%eax
  803a74:	c1 e0 02             	shl    $0x2,%eax
  803a77:	8d 90 44 30 81 00    	lea    0x813044(%eax),%edx
  803a7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a80:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  803a82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a85:	89 d0                	mov    %edx,%eax
  803a87:	01 c0                	add    %eax,%eax
  803a89:	01 d0                	add    %edx,%eax
  803a8b:	c1 e0 02             	shl    $0x2,%eax
  803a8e:	05 48 30 81 00       	add    $0x813048,%eax
  803a93:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  803a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  803a9c:	eb 0c                	jmp    803aaa <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803a9e:	ff 45 ec             	incl   -0x14(%ebp)
  803aa1:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803aa8:	7e 93                	jle    803a3d <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  803aaa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803aae:	0f 84 8d 01 00 00    	je     803c41 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803ab4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803abb:	e9 74 01 00 00       	jmp    803c34 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  803ac0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803ac6:	0f 84 64 01 00 00    	je     803c30 <sfree+0x2af>
					if (uhp_frees[k].free)
  803acc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803acf:	89 d0                	mov    %edx,%eax
  803ad1:	01 c0                	add    %eax,%eax
  803ad3:	01 d0                	add    %edx,%eax
  803ad5:	c1 e0 02             	shl    $0x2,%eax
  803ad8:	05 48 30 81 00       	add    $0x813048,%eax
  803add:	8a 00                	mov    (%eax),%al
  803adf:	84 c0                	test   %al,%al
  803ae1:	0f 84 4a 01 00 00    	je     803c31 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  803ae7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aea:	89 d0                	mov    %edx,%eax
  803aec:	01 c0                	add    %eax,%eax
  803aee:	01 d0                	add    %edx,%eax
  803af0:	c1 e0 02             	shl    $0x2,%eax
  803af3:	05 40 30 81 00       	add    $0x813040,%eax
  803af8:	8b 08                	mov    (%eax),%ecx
  803afa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803afd:	89 d0                	mov    %edx,%eax
  803aff:	01 c0                	add    %eax,%eax
  803b01:	01 d0                	add    %edx,%eax
  803b03:	c1 e0 02             	shl    $0x2,%eax
  803b06:	05 44 30 81 00       	add    $0x813044,%eax
  803b0b:	8b 00                	mov    (%eax),%eax
  803b0d:	01 c1                	add    %eax,%ecx
  803b0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b12:	89 d0                	mov    %edx,%eax
  803b14:	01 c0                	add    %eax,%eax
  803b16:	01 d0                	add    %edx,%eax
  803b18:	c1 e0 02             	shl    $0x2,%eax
  803b1b:	05 40 30 81 00       	add    $0x813040,%eax
  803b20:	8b 00                	mov    (%eax),%eax
  803b22:	39 c1                	cmp    %eax,%ecx
  803b24:	75 7a                	jne    803ba0 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  803b26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b29:	89 d0                	mov    %edx,%eax
  803b2b:	01 c0                	add    %eax,%eax
  803b2d:	01 d0                	add    %edx,%eax
  803b2f:	c1 e0 02             	shl    $0x2,%eax
  803b32:	05 40 30 81 00       	add    $0x813040,%eax
  803b37:	8b 10                	mov    (%eax),%edx
  803b39:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b3c:	89 c8                	mov    %ecx,%eax
  803b3e:	01 c0                	add    %eax,%eax
  803b40:	01 c8                	add    %ecx,%eax
  803b42:	c1 e0 02             	shl    $0x2,%eax
  803b45:	05 40 30 81 00       	add    $0x813040,%eax
  803b4a:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  803b4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b4f:	89 d0                	mov    %edx,%eax
  803b51:	01 c0                	add    %eax,%eax
  803b53:	01 d0                	add    %edx,%eax
  803b55:	c1 e0 02             	shl    $0x2,%eax
  803b58:	05 44 30 81 00       	add    $0x813044,%eax
  803b5d:	8b 08                	mov    (%eax),%ecx
  803b5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b62:	89 d0                	mov    %edx,%eax
  803b64:	01 c0                	add    %eax,%eax
  803b66:	01 d0                	add    %edx,%eax
  803b68:	c1 e0 02             	shl    $0x2,%eax
  803b6b:	05 44 30 81 00       	add    $0x813044,%eax
  803b70:	8b 00                	mov    (%eax),%eax
  803b72:	01 c1                	add    %eax,%ecx
  803b74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b77:	89 d0                	mov    %edx,%eax
  803b79:	01 c0                	add    %eax,%eax
  803b7b:	01 d0                	add    %edx,%eax
  803b7d:	c1 e0 02             	shl    $0x2,%eax
  803b80:	05 44 30 81 00       	add    $0x813044,%eax
  803b85:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803b87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b8a:	89 d0                	mov    %edx,%eax
  803b8c:	01 c0                	add    %eax,%eax
  803b8e:	01 d0                	add    %edx,%eax
  803b90:	c1 e0 02             	shl    $0x2,%eax
  803b93:	05 48 30 81 00       	add    $0x813048,%eax
  803b98:	c6 00 00             	movb   $0x0,(%eax)
  803b9b:	e9 91 00 00 00       	jmp    803c31 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803ba0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ba3:	89 d0                	mov    %edx,%eax
  803ba5:	01 c0                	add    %eax,%eax
  803ba7:	01 d0                	add    %edx,%eax
  803ba9:	c1 e0 02             	shl    $0x2,%eax
  803bac:	05 40 30 81 00       	add    $0x813040,%eax
  803bb1:	8b 08                	mov    (%eax),%ecx
  803bb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bb6:	89 d0                	mov    %edx,%eax
  803bb8:	01 c0                	add    %eax,%eax
  803bba:	01 d0                	add    %edx,%eax
  803bbc:	c1 e0 02             	shl    $0x2,%eax
  803bbf:	05 44 30 81 00       	add    $0x813044,%eax
  803bc4:	8b 00                	mov    (%eax),%eax
  803bc6:	01 c1                	add    %eax,%ecx
  803bc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bcb:	89 d0                	mov    %edx,%eax
  803bcd:	01 c0                	add    %eax,%eax
  803bcf:	01 d0                	add    %edx,%eax
  803bd1:	c1 e0 02             	shl    $0x2,%eax
  803bd4:	05 40 30 81 00       	add    $0x813040,%eax
  803bd9:	8b 00                	mov    (%eax),%eax
  803bdb:	39 c1                	cmp    %eax,%ecx
  803bdd:	75 52                	jne    803c31 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803bdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803be2:	89 d0                	mov    %edx,%eax
  803be4:	01 c0                	add    %eax,%eax
  803be6:	01 d0                	add    %edx,%eax
  803be8:	c1 e0 02             	shl    $0x2,%eax
  803beb:	05 44 30 81 00       	add    $0x813044,%eax
  803bf0:	8b 08                	mov    (%eax),%ecx
  803bf2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bf5:	89 d0                	mov    %edx,%eax
  803bf7:	01 c0                	add    %eax,%eax
  803bf9:	01 d0                	add    %edx,%eax
  803bfb:	c1 e0 02             	shl    $0x2,%eax
  803bfe:	05 44 30 81 00       	add    $0x813044,%eax
  803c03:	8b 00                	mov    (%eax),%eax
  803c05:	01 c1                	add    %eax,%ecx
  803c07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c0a:	89 d0                	mov    %edx,%eax
  803c0c:	01 c0                	add    %eax,%eax
  803c0e:	01 d0                	add    %edx,%eax
  803c10:	c1 e0 02             	shl    $0x2,%eax
  803c13:	05 44 30 81 00       	add    $0x813044,%eax
  803c18:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803c1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c1d:	89 d0                	mov    %edx,%eax
  803c1f:	01 c0                	add    %eax,%eax
  803c21:	01 d0                	add    %edx,%eax
  803c23:	c1 e0 02             	shl    $0x2,%eax
  803c26:	05 48 30 81 00       	add    $0x813048,%eax
  803c2b:	c6 00 00             	movb   $0x0,(%eax)
  803c2e:	eb 01                	jmp    803c31 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  803c30:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803c31:	ff 45 e8             	incl   -0x18(%ebp)
  803c34:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803c3b:	0f 8e 7f fe ff ff    	jle    803ac0 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803c41:	a1 30 71 83 00       	mov    0x837130,%eax
  803c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803c49:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c50:	eb 53                	jmp    803ca5 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803c52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c55:	89 d0                	mov    %edx,%eax
  803c57:	01 c0                	add    %eax,%eax
  803c59:	01 d0                	add    %edx,%eax
  803c5b:	c1 e0 02             	shl    $0x2,%eax
  803c5e:	05 48 70 80 00       	add    $0x807048,%eax
  803c63:	8a 00                	mov    (%eax),%al
  803c65:	84 c0                	test   %al,%al
  803c67:	74 39                	je     803ca2 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803c69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c6c:	89 d0                	mov    %edx,%eax
  803c6e:	01 c0                	add    %eax,%eax
  803c70:	01 d0                	add    %edx,%eax
  803c72:	c1 e0 02             	shl    $0x2,%eax
  803c75:	05 40 70 80 00       	add    $0x807040,%eax
  803c7a:	8b 08                	mov    (%eax),%ecx
  803c7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c7f:	89 d0                	mov    %edx,%eax
  803c81:	01 c0                	add    %eax,%eax
  803c83:	01 d0                	add    %edx,%eax
  803c85:	c1 e0 02             	shl    $0x2,%eax
  803c88:	05 44 70 80 00       	add    $0x807044,%eax
  803c8d:	8b 00                	mov    (%eax),%eax
  803c8f:	01 c8                	add    %ecx,%eax
  803c91:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803c94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c97:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c9a:	76 06                	jbe    803ca2 <sfree+0x321>
  803c9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803ca2:	ff 45 e0             	incl   -0x20(%ebp)
  803ca5:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803cac:	7e a4                	jle    803c52 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb1:	a3 88 70 83 00       	mov    %eax,0x837088
			break;
  803cb6:	eb 16                	jmp    803cce <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803cb8:	ff 45 f4             	incl   -0xc(%ebp)
  803cbb:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803cc2:	0f 8e 04 fd ff ff    	jle    8039cc <sfree+0x4b>
  803cc8:	eb 04                	jmp    803cce <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803cca:	90                   	nop
  803ccb:	eb 01                	jmp    803cce <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803ccd:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803cce:	c9                   	leave  
  803ccf:	c3                   	ret    

00803cd0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803cd0:	55                   	push   %ebp
  803cd1:	89 e5                	mov    %esp,%ebp
  803cd3:	57                   	push   %edi
  803cd4:	56                   	push   %esi
  803cd5:	53                   	push   %ebx
  803cd6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803ce2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803ce5:	8b 7d 18             	mov    0x18(%ebp),%edi
  803ce8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803ceb:	cd 30                	int    $0x30
  803ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803cf3:	83 c4 10             	add    $0x10,%esp
  803cf6:	5b                   	pop    %ebx
  803cf7:	5e                   	pop    %esi
  803cf8:	5f                   	pop    %edi
  803cf9:	5d                   	pop    %ebp
  803cfa:	c3                   	ret    

00803cfb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803cfb:	55                   	push   %ebp
  803cfc:	89 e5                	mov    %esp,%ebp
  803cfe:	83 ec 04             	sub    $0x4,%esp
  803d01:	8b 45 10             	mov    0x10(%ebp),%eax
  803d04:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803d07:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803d0a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d11:	6a 00                	push   $0x0
  803d13:	51                   	push   %ecx
  803d14:	52                   	push   %edx
  803d15:	ff 75 0c             	pushl  0xc(%ebp)
  803d18:	50                   	push   %eax
  803d19:	6a 00                	push   $0x0
  803d1b:	e8 b0 ff ff ff       	call   803cd0 <syscall>
  803d20:	83 c4 18             	add    $0x18,%esp
}
  803d23:	90                   	nop
  803d24:	c9                   	leave  
  803d25:	c3                   	ret    

00803d26 <sys_cgetc>:

int
sys_cgetc(void)
{
  803d26:	55                   	push   %ebp
  803d27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803d29:	6a 00                	push   $0x0
  803d2b:	6a 00                	push   $0x0
  803d2d:	6a 00                	push   $0x0
  803d2f:	6a 00                	push   $0x0
  803d31:	6a 00                	push   $0x0
  803d33:	6a 02                	push   $0x2
  803d35:	e8 96 ff ff ff       	call   803cd0 <syscall>
  803d3a:	83 c4 18             	add    $0x18,%esp
}
  803d3d:	c9                   	leave  
  803d3e:	c3                   	ret    

00803d3f <sys_lock_cons>:

void sys_lock_cons(void)
{
  803d3f:	55                   	push   %ebp
  803d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803d42:	6a 00                	push   $0x0
  803d44:	6a 00                	push   $0x0
  803d46:	6a 00                	push   $0x0
  803d48:	6a 00                	push   $0x0
  803d4a:	6a 00                	push   $0x0
  803d4c:	6a 03                	push   $0x3
  803d4e:	e8 7d ff ff ff       	call   803cd0 <syscall>
  803d53:	83 c4 18             	add    $0x18,%esp
}
  803d56:	90                   	nop
  803d57:	c9                   	leave  
  803d58:	c3                   	ret    

00803d59 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803d59:	55                   	push   %ebp
  803d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803d5c:	6a 00                	push   $0x0
  803d5e:	6a 00                	push   $0x0
  803d60:	6a 00                	push   $0x0
  803d62:	6a 00                	push   $0x0
  803d64:	6a 00                	push   $0x0
  803d66:	6a 04                	push   $0x4
  803d68:	e8 63 ff ff ff       	call   803cd0 <syscall>
  803d6d:	83 c4 18             	add    $0x18,%esp
}
  803d70:	90                   	nop
  803d71:	c9                   	leave  
  803d72:	c3                   	ret    

00803d73 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803d73:	55                   	push   %ebp
  803d74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d79:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7c:	6a 00                	push   $0x0
  803d7e:	6a 00                	push   $0x0
  803d80:	6a 00                	push   $0x0
  803d82:	52                   	push   %edx
  803d83:	50                   	push   %eax
  803d84:	6a 08                	push   $0x8
  803d86:	e8 45 ff ff ff       	call   803cd0 <syscall>
  803d8b:	83 c4 18             	add    $0x18,%esp
}
  803d8e:	c9                   	leave  
  803d8f:	c3                   	ret    

00803d90 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803d90:	55                   	push   %ebp
  803d91:	89 e5                	mov    %esp,%ebp
  803d93:	56                   	push   %esi
  803d94:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803d95:	8b 75 18             	mov    0x18(%ebp),%esi
  803d98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803d9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803da1:	8b 45 08             	mov    0x8(%ebp),%eax
  803da4:	56                   	push   %esi
  803da5:	53                   	push   %ebx
  803da6:	51                   	push   %ecx
  803da7:	52                   	push   %edx
  803da8:	50                   	push   %eax
  803da9:	6a 09                	push   $0x9
  803dab:	e8 20 ff ff ff       	call   803cd0 <syscall>
  803db0:	83 c4 18             	add    $0x18,%esp
}
  803db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803db6:	5b                   	pop    %ebx
  803db7:	5e                   	pop    %esi
  803db8:	5d                   	pop    %ebp
  803db9:	c3                   	ret    

00803dba <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803dba:	55                   	push   %ebp
  803dbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803dbd:	6a 00                	push   $0x0
  803dbf:	6a 00                	push   $0x0
  803dc1:	6a 00                	push   $0x0
  803dc3:	6a 00                	push   $0x0
  803dc5:	ff 75 08             	pushl  0x8(%ebp)
  803dc8:	6a 0a                	push   $0xa
  803dca:	e8 01 ff ff ff       	call   803cd0 <syscall>
  803dcf:	83 c4 18             	add    $0x18,%esp
}
  803dd2:	c9                   	leave  
  803dd3:	c3                   	ret    

00803dd4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803dd4:	55                   	push   %ebp
  803dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803dd7:	6a 00                	push   $0x0
  803dd9:	6a 00                	push   $0x0
  803ddb:	6a 00                	push   $0x0
  803ddd:	ff 75 0c             	pushl  0xc(%ebp)
  803de0:	ff 75 08             	pushl  0x8(%ebp)
  803de3:	6a 0b                	push   $0xb
  803de5:	e8 e6 fe ff ff       	call   803cd0 <syscall>
  803dea:	83 c4 18             	add    $0x18,%esp
}
  803ded:	c9                   	leave  
  803dee:	c3                   	ret    

00803def <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803def:	55                   	push   %ebp
  803df0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803df2:	6a 00                	push   $0x0
  803df4:	6a 00                	push   $0x0
  803df6:	6a 00                	push   $0x0
  803df8:	6a 00                	push   $0x0
  803dfa:	6a 00                	push   $0x0
  803dfc:	6a 0c                	push   $0xc
  803dfe:	e8 cd fe ff ff       	call   803cd0 <syscall>
  803e03:	83 c4 18             	add    $0x18,%esp
}
  803e06:	c9                   	leave  
  803e07:	c3                   	ret    

00803e08 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803e08:	55                   	push   %ebp
  803e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803e0b:	6a 00                	push   $0x0
  803e0d:	6a 00                	push   $0x0
  803e0f:	6a 00                	push   $0x0
  803e11:	6a 00                	push   $0x0
  803e13:	6a 00                	push   $0x0
  803e15:	6a 0d                	push   $0xd
  803e17:	e8 b4 fe ff ff       	call   803cd0 <syscall>
  803e1c:	83 c4 18             	add    $0x18,%esp
}
  803e1f:	c9                   	leave  
  803e20:	c3                   	ret    

00803e21 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803e21:	55                   	push   %ebp
  803e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803e24:	6a 00                	push   $0x0
  803e26:	6a 00                	push   $0x0
  803e28:	6a 00                	push   $0x0
  803e2a:	6a 00                	push   $0x0
  803e2c:	6a 00                	push   $0x0
  803e2e:	6a 0e                	push   $0xe
  803e30:	e8 9b fe ff ff       	call   803cd0 <syscall>
  803e35:	83 c4 18             	add    $0x18,%esp
}
  803e38:	c9                   	leave  
  803e39:	c3                   	ret    

00803e3a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803e3a:	55                   	push   %ebp
  803e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803e3d:	6a 00                	push   $0x0
  803e3f:	6a 00                	push   $0x0
  803e41:	6a 00                	push   $0x0
  803e43:	6a 00                	push   $0x0
  803e45:	6a 00                	push   $0x0
  803e47:	6a 0f                	push   $0xf
  803e49:	e8 82 fe ff ff       	call   803cd0 <syscall>
  803e4e:	83 c4 18             	add    $0x18,%esp
}
  803e51:	c9                   	leave  
  803e52:	c3                   	ret    

00803e53 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803e53:	55                   	push   %ebp
  803e54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803e56:	6a 00                	push   $0x0
  803e58:	6a 00                	push   $0x0
  803e5a:	6a 00                	push   $0x0
  803e5c:	6a 00                	push   $0x0
  803e5e:	ff 75 08             	pushl  0x8(%ebp)
  803e61:	6a 10                	push   $0x10
  803e63:	e8 68 fe ff ff       	call   803cd0 <syscall>
  803e68:	83 c4 18             	add    $0x18,%esp
}
  803e6b:	c9                   	leave  
  803e6c:	c3                   	ret    

00803e6d <sys_scarce_memory>:

void sys_scarce_memory()
{
  803e6d:	55                   	push   %ebp
  803e6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803e70:	6a 00                	push   $0x0
  803e72:	6a 00                	push   $0x0
  803e74:	6a 00                	push   $0x0
  803e76:	6a 00                	push   $0x0
  803e78:	6a 00                	push   $0x0
  803e7a:	6a 11                	push   $0x11
  803e7c:	e8 4f fe ff ff       	call   803cd0 <syscall>
  803e81:	83 c4 18             	add    $0x18,%esp
}
  803e84:	90                   	nop
  803e85:	c9                   	leave  
  803e86:	c3                   	ret    

00803e87 <sys_cputc>:

void
sys_cputc(const char c)
{
  803e87:	55                   	push   %ebp
  803e88:	89 e5                	mov    %esp,%ebp
  803e8a:	83 ec 04             	sub    $0x4,%esp
  803e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e90:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803e93:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803e97:	6a 00                	push   $0x0
  803e99:	6a 00                	push   $0x0
  803e9b:	6a 00                	push   $0x0
  803e9d:	6a 00                	push   $0x0
  803e9f:	50                   	push   %eax
  803ea0:	6a 01                	push   $0x1
  803ea2:	e8 29 fe ff ff       	call   803cd0 <syscall>
  803ea7:	83 c4 18             	add    $0x18,%esp
}
  803eaa:	90                   	nop
  803eab:	c9                   	leave  
  803eac:	c3                   	ret    

00803ead <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803ead:	55                   	push   %ebp
  803eae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803eb0:	6a 00                	push   $0x0
  803eb2:	6a 00                	push   $0x0
  803eb4:	6a 00                	push   $0x0
  803eb6:	6a 00                	push   $0x0
  803eb8:	6a 00                	push   $0x0
  803eba:	6a 14                	push   $0x14
  803ebc:	e8 0f fe ff ff       	call   803cd0 <syscall>
  803ec1:	83 c4 18             	add    $0x18,%esp
}
  803ec4:	90                   	nop
  803ec5:	c9                   	leave  
  803ec6:	c3                   	ret    

00803ec7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803ec7:	55                   	push   %ebp
  803ec8:	89 e5                	mov    %esp,%ebp
  803eca:	83 ec 04             	sub    $0x4,%esp
  803ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  803ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803ed3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803ed6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803eda:	8b 45 08             	mov    0x8(%ebp),%eax
  803edd:	6a 00                	push   $0x0
  803edf:	51                   	push   %ecx
  803ee0:	52                   	push   %edx
  803ee1:	ff 75 0c             	pushl  0xc(%ebp)
  803ee4:	50                   	push   %eax
  803ee5:	6a 15                	push   $0x15
  803ee7:	e8 e4 fd ff ff       	call   803cd0 <syscall>
  803eec:	83 c4 18             	add    $0x18,%esp
}
  803eef:	c9                   	leave  
  803ef0:	c3                   	ret    

00803ef1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803ef1:	55                   	push   %ebp
  803ef2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  803efa:	6a 00                	push   $0x0
  803efc:	6a 00                	push   $0x0
  803efe:	6a 00                	push   $0x0
  803f00:	52                   	push   %edx
  803f01:	50                   	push   %eax
  803f02:	6a 16                	push   $0x16
  803f04:	e8 c7 fd ff ff       	call   803cd0 <syscall>
  803f09:	83 c4 18             	add    $0x18,%esp
}
  803f0c:	c9                   	leave  
  803f0d:	c3                   	ret    

00803f0e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803f0e:	55                   	push   %ebp
  803f0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803f11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f17:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1a:	6a 00                	push   $0x0
  803f1c:	6a 00                	push   $0x0
  803f1e:	51                   	push   %ecx
  803f1f:	52                   	push   %edx
  803f20:	50                   	push   %eax
  803f21:	6a 17                	push   $0x17
  803f23:	e8 a8 fd ff ff       	call   803cd0 <syscall>
  803f28:	83 c4 18             	add    $0x18,%esp
}
  803f2b:	c9                   	leave  
  803f2c:	c3                   	ret    

00803f2d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803f2d:	55                   	push   %ebp
  803f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f33:	8b 45 08             	mov    0x8(%ebp),%eax
  803f36:	6a 00                	push   $0x0
  803f38:	6a 00                	push   $0x0
  803f3a:	6a 00                	push   $0x0
  803f3c:	52                   	push   %edx
  803f3d:	50                   	push   %eax
  803f3e:	6a 18                	push   $0x18
  803f40:	e8 8b fd ff ff       	call   803cd0 <syscall>
  803f45:	83 c4 18             	add    $0x18,%esp
}
  803f48:	c9                   	leave  
  803f49:	c3                   	ret    

00803f4a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803f4a:	55                   	push   %ebp
  803f4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f50:	6a 00                	push   $0x0
  803f52:	ff 75 14             	pushl  0x14(%ebp)
  803f55:	ff 75 10             	pushl  0x10(%ebp)
  803f58:	ff 75 0c             	pushl  0xc(%ebp)
  803f5b:	50                   	push   %eax
  803f5c:	6a 19                	push   $0x19
  803f5e:	e8 6d fd ff ff       	call   803cd0 <syscall>
  803f63:	83 c4 18             	add    $0x18,%esp
}
  803f66:	c9                   	leave  
  803f67:	c3                   	ret    

00803f68 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803f68:	55                   	push   %ebp
  803f69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6e:	6a 00                	push   $0x0
  803f70:	6a 00                	push   $0x0
  803f72:	6a 00                	push   $0x0
  803f74:	6a 00                	push   $0x0
  803f76:	50                   	push   %eax
  803f77:	6a 1a                	push   $0x1a
  803f79:	e8 52 fd ff ff       	call   803cd0 <syscall>
  803f7e:	83 c4 18             	add    $0x18,%esp
}
  803f81:	90                   	nop
  803f82:	c9                   	leave  
  803f83:	c3                   	ret    

00803f84 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803f84:	55                   	push   %ebp
  803f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803f87:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8a:	6a 00                	push   $0x0
  803f8c:	6a 00                	push   $0x0
  803f8e:	6a 00                	push   $0x0
  803f90:	6a 00                	push   $0x0
  803f92:	50                   	push   %eax
  803f93:	6a 1b                	push   $0x1b
  803f95:	e8 36 fd ff ff       	call   803cd0 <syscall>
  803f9a:	83 c4 18             	add    $0x18,%esp
}
  803f9d:	c9                   	leave  
  803f9e:	c3                   	ret    

00803f9f <sys_getenvid>:

int32 sys_getenvid(void)
{
  803f9f:	55                   	push   %ebp
  803fa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803fa2:	6a 00                	push   $0x0
  803fa4:	6a 00                	push   $0x0
  803fa6:	6a 00                	push   $0x0
  803fa8:	6a 00                	push   $0x0
  803faa:	6a 00                	push   $0x0
  803fac:	6a 05                	push   $0x5
  803fae:	e8 1d fd ff ff       	call   803cd0 <syscall>
  803fb3:	83 c4 18             	add    $0x18,%esp
}
  803fb6:	c9                   	leave  
  803fb7:	c3                   	ret    

00803fb8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803fb8:	55                   	push   %ebp
  803fb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803fbb:	6a 00                	push   $0x0
  803fbd:	6a 00                	push   $0x0
  803fbf:	6a 00                	push   $0x0
  803fc1:	6a 00                	push   $0x0
  803fc3:	6a 00                	push   $0x0
  803fc5:	6a 06                	push   $0x6
  803fc7:	e8 04 fd ff ff       	call   803cd0 <syscall>
  803fcc:	83 c4 18             	add    $0x18,%esp
}
  803fcf:	c9                   	leave  
  803fd0:	c3                   	ret    

00803fd1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803fd1:	55                   	push   %ebp
  803fd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803fd4:	6a 00                	push   $0x0
  803fd6:	6a 00                	push   $0x0
  803fd8:	6a 00                	push   $0x0
  803fda:	6a 00                	push   $0x0
  803fdc:	6a 00                	push   $0x0
  803fde:	6a 07                	push   $0x7
  803fe0:	e8 eb fc ff ff       	call   803cd0 <syscall>
  803fe5:	83 c4 18             	add    $0x18,%esp
}
  803fe8:	c9                   	leave  
  803fe9:	c3                   	ret    

00803fea <sys_exit_env>:


void sys_exit_env(void)
{
  803fea:	55                   	push   %ebp
  803feb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803fed:	6a 00                	push   $0x0
  803fef:	6a 00                	push   $0x0
  803ff1:	6a 00                	push   $0x0
  803ff3:	6a 00                	push   $0x0
  803ff5:	6a 00                	push   $0x0
  803ff7:	6a 1c                	push   $0x1c
  803ff9:	e8 d2 fc ff ff       	call   803cd0 <syscall>
  803ffe:	83 c4 18             	add    $0x18,%esp
}
  804001:	90                   	nop
  804002:	c9                   	leave  
  804003:	c3                   	ret    

00804004 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  804004:	55                   	push   %ebp
  804005:	89 e5                	mov    %esp,%ebp
  804007:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80400a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80400d:	8d 50 04             	lea    0x4(%eax),%edx
  804010:	8d 45 f8             	lea    -0x8(%ebp),%eax
  804013:	6a 00                	push   $0x0
  804015:	6a 00                	push   $0x0
  804017:	6a 00                	push   $0x0
  804019:	52                   	push   %edx
  80401a:	50                   	push   %eax
  80401b:	6a 1d                	push   $0x1d
  80401d:	e8 ae fc ff ff       	call   803cd0 <syscall>
  804022:	83 c4 18             	add    $0x18,%esp
	return result;
  804025:	8b 4d 08             	mov    0x8(%ebp),%ecx
  804028:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80402b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80402e:	89 01                	mov    %eax,(%ecx)
  804030:	89 51 04             	mov    %edx,0x4(%ecx)
}
  804033:	8b 45 08             	mov    0x8(%ebp),%eax
  804036:	c9                   	leave  
  804037:	c2 04 00             	ret    $0x4

0080403a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80403a:	55                   	push   %ebp
  80403b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80403d:	6a 00                	push   $0x0
  80403f:	6a 00                	push   $0x0
  804041:	ff 75 10             	pushl  0x10(%ebp)
  804044:	ff 75 0c             	pushl  0xc(%ebp)
  804047:	ff 75 08             	pushl  0x8(%ebp)
  80404a:	6a 13                	push   $0x13
  80404c:	e8 7f fc ff ff       	call   803cd0 <syscall>
  804051:	83 c4 18             	add    $0x18,%esp
	return ;
  804054:	90                   	nop
}
  804055:	c9                   	leave  
  804056:	c3                   	ret    

00804057 <sys_rcr2>:
uint32 sys_rcr2()
{
  804057:	55                   	push   %ebp
  804058:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80405a:	6a 00                	push   $0x0
  80405c:	6a 00                	push   $0x0
  80405e:	6a 00                	push   $0x0
  804060:	6a 00                	push   $0x0
  804062:	6a 00                	push   $0x0
  804064:	6a 1e                	push   $0x1e
  804066:	e8 65 fc ff ff       	call   803cd0 <syscall>
  80406b:	83 c4 18             	add    $0x18,%esp
}
  80406e:	c9                   	leave  
  80406f:	c3                   	ret    

00804070 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  804070:	55                   	push   %ebp
  804071:	89 e5                	mov    %esp,%ebp
  804073:	83 ec 04             	sub    $0x4,%esp
  804076:	8b 45 08             	mov    0x8(%ebp),%eax
  804079:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80407c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  804080:	6a 00                	push   $0x0
  804082:	6a 00                	push   $0x0
  804084:	6a 00                	push   $0x0
  804086:	6a 00                	push   $0x0
  804088:	50                   	push   %eax
  804089:	6a 1f                	push   $0x1f
  80408b:	e8 40 fc ff ff       	call   803cd0 <syscall>
  804090:	83 c4 18             	add    $0x18,%esp
	return ;
  804093:	90                   	nop
}
  804094:	c9                   	leave  
  804095:	c3                   	ret    

00804096 <rsttst>:
void rsttst()
{
  804096:	55                   	push   %ebp
  804097:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  804099:	6a 00                	push   $0x0
  80409b:	6a 00                	push   $0x0
  80409d:	6a 00                	push   $0x0
  80409f:	6a 00                	push   $0x0
  8040a1:	6a 00                	push   $0x0
  8040a3:	6a 21                	push   $0x21
  8040a5:	e8 26 fc ff ff       	call   803cd0 <syscall>
  8040aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8040ad:	90                   	nop
}
  8040ae:	c9                   	leave  
  8040af:	c3                   	ret    

008040b0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8040b0:	55                   	push   %ebp
  8040b1:	89 e5                	mov    %esp,%ebp
  8040b3:	83 ec 04             	sub    $0x4,%esp
  8040b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8040b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8040bc:	8b 55 18             	mov    0x18(%ebp),%edx
  8040bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8040c3:	52                   	push   %edx
  8040c4:	50                   	push   %eax
  8040c5:	ff 75 10             	pushl  0x10(%ebp)
  8040c8:	ff 75 0c             	pushl  0xc(%ebp)
  8040cb:	ff 75 08             	pushl  0x8(%ebp)
  8040ce:	6a 20                	push   $0x20
  8040d0:	e8 fb fb ff ff       	call   803cd0 <syscall>
  8040d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8040d8:	90                   	nop
}
  8040d9:	c9                   	leave  
  8040da:	c3                   	ret    

008040db <chktst>:
void chktst(uint32 n)
{
  8040db:	55                   	push   %ebp
  8040dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8040de:	6a 00                	push   $0x0
  8040e0:	6a 00                	push   $0x0
  8040e2:	6a 00                	push   $0x0
  8040e4:	6a 00                	push   $0x0
  8040e6:	ff 75 08             	pushl  0x8(%ebp)
  8040e9:	6a 22                	push   $0x22
  8040eb:	e8 e0 fb ff ff       	call   803cd0 <syscall>
  8040f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8040f3:	90                   	nop
}
  8040f4:	c9                   	leave  
  8040f5:	c3                   	ret    

008040f6 <inctst>:

void inctst()
{
  8040f6:	55                   	push   %ebp
  8040f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8040f9:	6a 00                	push   $0x0
  8040fb:	6a 00                	push   $0x0
  8040fd:	6a 00                	push   $0x0
  8040ff:	6a 00                	push   $0x0
  804101:	6a 00                	push   $0x0
  804103:	6a 23                	push   $0x23
  804105:	e8 c6 fb ff ff       	call   803cd0 <syscall>
  80410a:	83 c4 18             	add    $0x18,%esp
	return ;
  80410d:	90                   	nop
}
  80410e:	c9                   	leave  
  80410f:	c3                   	ret    

00804110 <gettst>:
uint32 gettst()
{
  804110:	55                   	push   %ebp
  804111:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  804113:	6a 00                	push   $0x0
  804115:	6a 00                	push   $0x0
  804117:	6a 00                	push   $0x0
  804119:	6a 00                	push   $0x0
  80411b:	6a 00                	push   $0x0
  80411d:	6a 24                	push   $0x24
  80411f:	e8 ac fb ff ff       	call   803cd0 <syscall>
  804124:	83 c4 18             	add    $0x18,%esp
}
  804127:	c9                   	leave  
  804128:	c3                   	ret    

00804129 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  804129:	55                   	push   %ebp
  80412a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80412c:	6a 00                	push   $0x0
  80412e:	6a 00                	push   $0x0
  804130:	6a 00                	push   $0x0
  804132:	6a 00                	push   $0x0
  804134:	6a 00                	push   $0x0
  804136:	6a 25                	push   $0x25
  804138:	e8 93 fb ff ff       	call   803cd0 <syscall>
  80413d:	83 c4 18             	add    $0x18,%esp
  804140:	a3 80 70 83 00       	mov    %eax,0x837080
	return uheapPlaceStrategy ;
  804145:	a1 80 70 83 00       	mov    0x837080,%eax
}
  80414a:	c9                   	leave  
  80414b:	c3                   	ret    

0080414c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80414c:	55                   	push   %ebp
  80414d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80414f:	8b 45 08             	mov    0x8(%ebp),%eax
  804152:	a3 80 70 83 00       	mov    %eax,0x837080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  804157:	6a 00                	push   $0x0
  804159:	6a 00                	push   $0x0
  80415b:	6a 00                	push   $0x0
  80415d:	6a 00                	push   $0x0
  80415f:	ff 75 08             	pushl  0x8(%ebp)
  804162:	6a 26                	push   $0x26
  804164:	e8 67 fb ff ff       	call   803cd0 <syscall>
  804169:	83 c4 18             	add    $0x18,%esp
	return ;
  80416c:	90                   	nop
}
  80416d:	c9                   	leave  
  80416e:	c3                   	ret    

0080416f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80416f:	55                   	push   %ebp
  804170:	89 e5                	mov    %esp,%ebp
  804172:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  804173:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804176:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80417c:	8b 45 08             	mov    0x8(%ebp),%eax
  80417f:	6a 00                	push   $0x0
  804181:	53                   	push   %ebx
  804182:	51                   	push   %ecx
  804183:	52                   	push   %edx
  804184:	50                   	push   %eax
  804185:	6a 27                	push   $0x27
  804187:	e8 44 fb ff ff       	call   803cd0 <syscall>
  80418c:	83 c4 18             	add    $0x18,%esp
}
  80418f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804192:	c9                   	leave  
  804193:	c3                   	ret    

00804194 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  804194:	55                   	push   %ebp
  804195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  804197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80419a:	8b 45 08             	mov    0x8(%ebp),%eax
  80419d:	6a 00                	push   $0x0
  80419f:	6a 00                	push   $0x0
  8041a1:	6a 00                	push   $0x0
  8041a3:	52                   	push   %edx
  8041a4:	50                   	push   %eax
  8041a5:	6a 28                	push   $0x28
  8041a7:	e8 24 fb ff ff       	call   803cd0 <syscall>
  8041ac:	83 c4 18             	add    $0x18,%esp
}
  8041af:	c9                   	leave  
  8041b0:	c3                   	ret    

008041b1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8041b1:	55                   	push   %ebp
  8041b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8041b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8041b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8041bd:	6a 00                	push   $0x0
  8041bf:	51                   	push   %ecx
  8041c0:	ff 75 10             	pushl  0x10(%ebp)
  8041c3:	52                   	push   %edx
  8041c4:	50                   	push   %eax
  8041c5:	6a 29                	push   $0x29
  8041c7:	e8 04 fb ff ff       	call   803cd0 <syscall>
  8041cc:	83 c4 18             	add    $0x18,%esp
}
  8041cf:	c9                   	leave  
  8041d0:	c3                   	ret    

008041d1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8041d1:	55                   	push   %ebp
  8041d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8041d4:	6a 00                	push   $0x0
  8041d6:	6a 00                	push   $0x0
  8041d8:	ff 75 10             	pushl  0x10(%ebp)
  8041db:	ff 75 0c             	pushl  0xc(%ebp)
  8041de:	ff 75 08             	pushl  0x8(%ebp)
  8041e1:	6a 12                	push   $0x12
  8041e3:	e8 e8 fa ff ff       	call   803cd0 <syscall>
  8041e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8041eb:	90                   	nop
}
  8041ec:	c9                   	leave  
  8041ed:	c3                   	ret    

008041ee <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8041ee:	55                   	push   %ebp
  8041ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8041f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f7:	6a 00                	push   $0x0
  8041f9:	6a 00                	push   $0x0
  8041fb:	6a 00                	push   $0x0
  8041fd:	52                   	push   %edx
  8041fe:	50                   	push   %eax
  8041ff:	6a 2a                	push   $0x2a
  804201:	e8 ca fa ff ff       	call   803cd0 <syscall>
  804206:	83 c4 18             	add    $0x18,%esp
	return;
  804209:	90                   	nop
}
  80420a:	c9                   	leave  
  80420b:	c3                   	ret    

0080420c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80420c:	55                   	push   %ebp
  80420d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80420f:	6a 00                	push   $0x0
  804211:	6a 00                	push   $0x0
  804213:	6a 00                	push   $0x0
  804215:	6a 00                	push   $0x0
  804217:	6a 00                	push   $0x0
  804219:	6a 2b                	push   $0x2b
  80421b:	e8 b0 fa ff ff       	call   803cd0 <syscall>
  804220:	83 c4 18             	add    $0x18,%esp
}
  804223:	c9                   	leave  
  804224:	c3                   	ret    

00804225 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  804225:	55                   	push   %ebp
  804226:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  804228:	6a 00                	push   $0x0
  80422a:	6a 00                	push   $0x0
  80422c:	6a 00                	push   $0x0
  80422e:	ff 75 0c             	pushl  0xc(%ebp)
  804231:	ff 75 08             	pushl  0x8(%ebp)
  804234:	6a 2d                	push   $0x2d
  804236:	e8 95 fa ff ff       	call   803cd0 <syscall>
  80423b:	83 c4 18             	add    $0x18,%esp
	return;
  80423e:	90                   	nop
}
  80423f:	c9                   	leave  
  804240:	c3                   	ret    

00804241 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  804241:	55                   	push   %ebp
  804242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  804244:	6a 00                	push   $0x0
  804246:	6a 00                	push   $0x0
  804248:	6a 00                	push   $0x0
  80424a:	ff 75 0c             	pushl  0xc(%ebp)
  80424d:	ff 75 08             	pushl  0x8(%ebp)
  804250:	6a 2c                	push   $0x2c
  804252:	e8 79 fa ff ff       	call   803cd0 <syscall>
  804257:	83 c4 18             	add    $0x18,%esp
	return ;
  80425a:	90                   	nop
}
  80425b:	c9                   	leave  
  80425c:	c3                   	ret    

0080425d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80425d:	55                   	push   %ebp
  80425e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  804260:	8b 55 0c             	mov    0xc(%ebp),%edx
  804263:	8b 45 08             	mov    0x8(%ebp),%eax
  804266:	6a 00                	push   $0x0
  804268:	6a 00                	push   $0x0
  80426a:	6a 00                	push   $0x0
  80426c:	52                   	push   %edx
  80426d:	50                   	push   %eax
  80426e:	6a 2e                	push   $0x2e
  804270:	e8 5b fa ff ff       	call   803cd0 <syscall>
  804275:	83 c4 18             	add    $0x18,%esp
}
  804278:	90                   	nop
  804279:	c9                   	leave  
  80427a:	c3                   	ret    

0080427b <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80427b:	55                   	push   %ebp
  80427c:	89 e5                	mov    %esp,%ebp
  80427e:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  804281:	81 7d 08 80 f0 81 00 	cmpl   $0x81f080,0x8(%ebp)
  804288:	72 09                	jb     804293 <to_page_va+0x18>
  80428a:	81 7d 08 80 70 83 00 	cmpl   $0x837080,0x8(%ebp)
  804291:	72 14                	jb     8042a7 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  804293:	83 ec 04             	sub    $0x4,%esp
  804296:	68 78 63 80 00       	push   $0x806378
  80429b:	6a 15                	push   $0x15
  80429d:	68 a3 63 80 00       	push   $0x8063a3
  8042a2:	e8 10 d0 ff ff       	call   8012b7 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8042a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042aa:	ba 80 f0 81 00       	mov    $0x81f080,%edx
  8042af:	29 d0                	sub    %edx,%eax
  8042b1:	c1 f8 02             	sar    $0x2,%eax
  8042b4:	89 c2                	mov    %eax,%edx
  8042b6:	89 d0                	mov    %edx,%eax
  8042b8:	c1 e0 02             	shl    $0x2,%eax
  8042bb:	01 d0                	add    %edx,%eax
  8042bd:	c1 e0 02             	shl    $0x2,%eax
  8042c0:	01 d0                	add    %edx,%eax
  8042c2:	c1 e0 02             	shl    $0x2,%eax
  8042c5:	01 d0                	add    %edx,%eax
  8042c7:	89 c1                	mov    %eax,%ecx
  8042c9:	c1 e1 08             	shl    $0x8,%ecx
  8042cc:	01 c8                	add    %ecx,%eax
  8042ce:	89 c1                	mov    %eax,%ecx
  8042d0:	c1 e1 10             	shl    $0x10,%ecx
  8042d3:	01 c8                	add    %ecx,%eax
  8042d5:	01 c0                	add    %eax,%eax
  8042d7:	01 d0                	add    %edx,%eax
  8042d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8042dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042df:	c1 e0 0c             	shl    $0xc,%eax
  8042e2:	89 c2                	mov    %eax,%edx
  8042e4:	a1 84 70 83 00       	mov    0x837084,%eax
  8042e9:	01 d0                	add    %edx,%eax
}
  8042eb:	c9                   	leave  
  8042ec:	c3                   	ret    

008042ed <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8042ed:	55                   	push   %ebp
  8042ee:	89 e5                	mov    %esp,%ebp
  8042f0:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8042f3:	a1 84 70 83 00       	mov    0x837084,%eax
  8042f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8042fb:	29 c2                	sub    %eax,%edx
  8042fd:	89 d0                	mov    %edx,%eax
  8042ff:	c1 e8 0c             	shr    $0xc,%eax
  804302:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  804305:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804309:	78 09                	js     804314 <to_page_info+0x27>
  80430b:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  804312:	7e 14                	jle    804328 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  804314:	83 ec 04             	sub    $0x4,%esp
  804317:	68 bc 63 80 00       	push   $0x8063bc
  80431c:	6a 21                	push   $0x21
  80431e:	68 a3 63 80 00       	push   $0x8063a3
  804323:	e8 8f cf ff ff       	call   8012b7 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  804328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80432b:	89 d0                	mov    %edx,%eax
  80432d:	01 c0                	add    %eax,%eax
  80432f:	01 d0                	add    %edx,%eax
  804331:	c1 e0 02             	shl    $0x2,%eax
  804334:	05 80 f0 81 00       	add    $0x81f080,%eax
}
  804339:	c9                   	leave  
  80433a:	c3                   	ret    

0080433b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80433b:	55                   	push   %ebp
  80433c:	89 e5                	mov    %esp,%ebp
  80433e:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  804341:	8b 45 08             	mov    0x8(%ebp),%eax
  804344:	05 00 00 00 02       	add    $0x2000000,%eax
  804349:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80434c:	73 16                	jae    804364 <initialize_dynamic_allocator+0x29>
  80434e:	68 e0 63 80 00       	push   $0x8063e0
  804353:	68 06 64 80 00       	push   $0x806406
  804358:	6a 2f                	push   $0x2f
  80435a:	68 a3 63 80 00       	push   $0x8063a3
  80435f:	e8 53 cf ff ff       	call   8012b7 <_panic>
	dynAllocStart = daStart;
  804364:	8b 45 08             	mov    0x8(%ebp),%eax
  804367:	a3 84 70 83 00       	mov    %eax,0x837084
	dynAllocEnd = daEnd;
  80436c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80436f:	a3 60 f0 81 00       	mov    %eax,0x81f060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804374:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80437b:	eb 36                	jmp    8043b3 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80437d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804380:	c1 e0 04             	shl    $0x4,%eax
  804383:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80438e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804391:	c1 e0 04             	shl    $0x4,%eax
  804394:	05 a4 70 83 00       	add    $0x8370a4,%eax
  804399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80439f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a2:	c1 e0 04             	shl    $0x4,%eax
  8043a5:	05 ac 70 83 00       	add    $0x8370ac,%eax
  8043aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8043b0:	ff 45 f4             	incl   -0xc(%ebp)
  8043b3:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8043b7:	7e c4                	jle    80437d <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8043b9:	c7 05 68 f0 81 00 00 	movl   $0x0,0x81f068
  8043c0:	00 00 00 
  8043c3:	c7 05 6c f0 81 00 00 	movl   $0x0,0x81f06c
  8043ca:	00 00 00 
  8043cd:	c7 05 74 f0 81 00 00 	movl   $0x0,0x81f074
  8043d4:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8043d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8043de:	e9 1b 01 00 00       	jmp    8044fe <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8043e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043e6:	89 d0                	mov    %edx,%eax
  8043e8:	01 c0                	add    %eax,%eax
  8043ea:	01 d0                	add    %edx,%eax
  8043ec:	c1 e0 02             	shl    $0x2,%eax
  8043ef:	05 88 f0 81 00       	add    $0x81f088,%eax
  8043f4:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8043f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043fc:	89 d0                	mov    %edx,%eax
  8043fe:	01 c0                	add    %eax,%eax
  804400:	01 d0                	add    %edx,%eax
  804402:	c1 e0 02             	shl    $0x2,%eax
  804405:	05 8a f0 81 00       	add    $0x81f08a,%eax
  80440a:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  80440f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804412:	89 d0                	mov    %edx,%eax
  804414:	01 c0                	add    %eax,%eax
  804416:	01 d0                	add    %edx,%eax
  804418:	c1 e0 02             	shl    $0x2,%eax
  80441b:	05 80 f0 81 00       	add    $0x81f080,%eax
  804420:	8b 00                	mov    (%eax),%eax
  804422:	85 c0                	test   %eax,%eax
  804424:	74 2b                	je     804451 <initialize_dynamic_allocator+0x116>
  804426:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804429:	89 d0                	mov    %edx,%eax
  80442b:	01 c0                	add    %eax,%eax
  80442d:	01 d0                	add    %edx,%eax
  80442f:	c1 e0 02             	shl    $0x2,%eax
  804432:	05 80 f0 81 00       	add    $0x81f080,%eax
  804437:	8b 10                	mov    (%eax),%edx
  804439:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80443c:	89 c8                	mov    %ecx,%eax
  80443e:	01 c0                	add    %eax,%eax
  804440:	01 c8                	add    %ecx,%eax
  804442:	c1 e0 02             	shl    $0x2,%eax
  804445:	05 84 f0 81 00       	add    $0x81f084,%eax
  80444a:	8b 00                	mov    (%eax),%eax
  80444c:	89 42 04             	mov    %eax,0x4(%edx)
  80444f:	eb 18                	jmp    804469 <initialize_dynamic_allocator+0x12e>
  804451:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804454:	89 d0                	mov    %edx,%eax
  804456:	01 c0                	add    %eax,%eax
  804458:	01 d0                	add    %edx,%eax
  80445a:	c1 e0 02             	shl    $0x2,%eax
  80445d:	05 84 f0 81 00       	add    $0x81f084,%eax
  804462:	8b 00                	mov    (%eax),%eax
  804464:	a3 6c f0 81 00       	mov    %eax,0x81f06c
  804469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80446c:	89 d0                	mov    %edx,%eax
  80446e:	01 c0                	add    %eax,%eax
  804470:	01 d0                	add    %edx,%eax
  804472:	c1 e0 02             	shl    $0x2,%eax
  804475:	05 84 f0 81 00       	add    $0x81f084,%eax
  80447a:	8b 00                	mov    (%eax),%eax
  80447c:	85 c0                	test   %eax,%eax
  80447e:	74 2a                	je     8044aa <initialize_dynamic_allocator+0x16f>
  804480:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804483:	89 d0                	mov    %edx,%eax
  804485:	01 c0                	add    %eax,%eax
  804487:	01 d0                	add    %edx,%eax
  804489:	c1 e0 02             	shl    $0x2,%eax
  80448c:	05 84 f0 81 00       	add    $0x81f084,%eax
  804491:	8b 10                	mov    (%eax),%edx
  804493:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804496:	89 c8                	mov    %ecx,%eax
  804498:	01 c0                	add    %eax,%eax
  80449a:	01 c8                	add    %ecx,%eax
  80449c:	c1 e0 02             	shl    $0x2,%eax
  80449f:	05 80 f0 81 00       	add    $0x81f080,%eax
  8044a4:	8b 00                	mov    (%eax),%eax
  8044a6:	89 02                	mov    %eax,(%edx)
  8044a8:	eb 18                	jmp    8044c2 <initialize_dynamic_allocator+0x187>
  8044aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044ad:	89 d0                	mov    %edx,%eax
  8044af:	01 c0                	add    %eax,%eax
  8044b1:	01 d0                	add    %edx,%eax
  8044b3:	c1 e0 02             	shl    $0x2,%eax
  8044b6:	05 80 f0 81 00       	add    $0x81f080,%eax
  8044bb:	8b 00                	mov    (%eax),%eax
  8044bd:	a3 68 f0 81 00       	mov    %eax,0x81f068
  8044c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044c5:	89 d0                	mov    %edx,%eax
  8044c7:	01 c0                	add    %eax,%eax
  8044c9:	01 d0                	add    %edx,%eax
  8044cb:	c1 e0 02             	shl    $0x2,%eax
  8044ce:	05 80 f0 81 00       	add    $0x81f080,%eax
  8044d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044dc:	89 d0                	mov    %edx,%eax
  8044de:	01 c0                	add    %eax,%eax
  8044e0:	01 d0                	add    %edx,%eax
  8044e2:	c1 e0 02             	shl    $0x2,%eax
  8044e5:	05 84 f0 81 00       	add    $0x81f084,%eax
  8044ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044f0:	a1 74 f0 81 00       	mov    0x81f074,%eax
  8044f5:	48                   	dec    %eax
  8044f6:	a3 74 f0 81 00       	mov    %eax,0x81f074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8044fb:	ff 45 f0             	incl   -0x10(%ebp)
  8044fe:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  804505:	0f 8e d8 fe ff ff    	jle    8043e3 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80450b:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  804512:	e9 9d 00 00 00       	jmp    8045b4 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  804517:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  80451d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  804520:	89 c8                	mov    %ecx,%eax
  804522:	01 c0                	add    %eax,%eax
  804524:	01 c8                	add    %ecx,%eax
  804526:	c1 e0 02             	shl    $0x2,%eax
  804529:	05 80 f0 81 00       	add    $0x81f080,%eax
  80452e:	89 10                	mov    %edx,(%eax)
  804530:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804533:	89 d0                	mov    %edx,%eax
  804535:	01 c0                	add    %eax,%eax
  804537:	01 d0                	add    %edx,%eax
  804539:	c1 e0 02             	shl    $0x2,%eax
  80453c:	05 80 f0 81 00       	add    $0x81f080,%eax
  804541:	8b 00                	mov    (%eax),%eax
  804543:	85 c0                	test   %eax,%eax
  804545:	74 1c                	je     804563 <initialize_dynamic_allocator+0x228>
  804547:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  80454d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  804550:	89 c8                	mov    %ecx,%eax
  804552:	01 c0                	add    %eax,%eax
  804554:	01 c8                	add    %ecx,%eax
  804556:	c1 e0 02             	shl    $0x2,%eax
  804559:	05 80 f0 81 00       	add    $0x81f080,%eax
  80455e:	89 42 04             	mov    %eax,0x4(%edx)
  804561:	eb 16                	jmp    804579 <initialize_dynamic_allocator+0x23e>
  804563:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804566:	89 d0                	mov    %edx,%eax
  804568:	01 c0                	add    %eax,%eax
  80456a:	01 d0                	add    %edx,%eax
  80456c:	c1 e0 02             	shl    $0x2,%eax
  80456f:	05 80 f0 81 00       	add    $0x81f080,%eax
  804574:	a3 6c f0 81 00       	mov    %eax,0x81f06c
  804579:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80457c:	89 d0                	mov    %edx,%eax
  80457e:	01 c0                	add    %eax,%eax
  804580:	01 d0                	add    %edx,%eax
  804582:	c1 e0 02             	shl    $0x2,%eax
  804585:	05 80 f0 81 00       	add    $0x81f080,%eax
  80458a:	a3 68 f0 81 00       	mov    %eax,0x81f068
  80458f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804592:	89 d0                	mov    %edx,%eax
  804594:	01 c0                	add    %eax,%eax
  804596:	01 d0                	add    %edx,%eax
  804598:	c1 e0 02             	shl    $0x2,%eax
  80459b:	05 84 f0 81 00       	add    $0x81f084,%eax
  8045a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045a6:	a1 74 f0 81 00       	mov    0x81f074,%eax
  8045ab:	40                   	inc    %eax
  8045ac:	a3 74 f0 81 00       	mov    %eax,0x81f074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8045b1:	ff 4d ec             	decl   -0x14(%ebp)
  8045b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8045b8:	0f 89 59 ff ff ff    	jns    804517 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8045be:	c7 05 44 f0 81 00 01 	movl   $0x1,0x81f044
  8045c5:	00 00 00 
}
  8045c8:	90                   	nop
  8045c9:	c9                   	leave  
  8045ca:	c3                   	ret    

008045cb <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8045cb:	55                   	push   %ebp
  8045cc:	89 e5                	mov    %esp,%ebp
  8045ce:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8045d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8045d4:	83 ec 0c             	sub    $0xc,%esp
  8045d7:	50                   	push   %eax
  8045d8:	e8 10 fd ff ff       	call   8042ed <to_page_info>
  8045dd:	83 c4 10             	add    $0x10,%esp
  8045e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8045e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e6:	8b 40 08             	mov    0x8(%eax),%eax
  8045e9:	0f b7 c0             	movzwl %ax,%eax
}
  8045ec:	c9                   	leave  
  8045ed:	c3                   	ret    

008045ee <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8045ee:	55                   	push   %ebp
  8045ef:	89 e5                	mov    %esp,%ebp
  8045f1:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8045f4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8045fb:	76 16                	jbe    804613 <alloc_block+0x25>
  8045fd:	68 1c 64 80 00       	push   $0x80641c
  804602:	68 06 64 80 00       	push   $0x806406
  804607:	6a 59                	push   $0x59
  804609:	68 a3 63 80 00       	push   $0x8063a3
  80460e:	e8 a4 cc ff ff       	call   8012b7 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  804613:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80461a:	eb 08                	jmp    804624 <alloc_block+0x36>
		allocSize <<= 1;
  80461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80461f:	01 c0                	add    %eax,%eax
  804621:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  804624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804627:	3b 45 08             	cmp    0x8(%ebp),%eax
  80462a:	73 09                	jae    804635 <alloc_block+0x47>
  80462c:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  804633:	76 e7                	jbe    80461c <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  804635:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80463c:	eb 03                	jmp    804641 <alloc_block+0x53>
		listIndex++;
  80463e:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  804641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804644:	ba 08 00 00 00       	mov    $0x8,%edx
  804649:	88 c1                	mov    %al,%cl
  80464b:	d3 e2                	shl    %cl,%edx
  80464d:	89 d0                	mov    %edx,%eax
  80464f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804652:	72 ea                	jb     80463e <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804657:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80465a:	e9 f4 00 00 00       	jmp    804753 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80465f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804662:	c1 e0 04             	shl    $0x4,%eax
  804665:	05 a0 70 83 00       	add    $0x8370a0,%eax
  80466a:	8b 00                	mov    (%eax),%eax
  80466c:	85 c0                	test   %eax,%eax
  80466e:	0f 84 dc 00 00 00    	je     804750 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804677:	c1 e0 04             	shl    $0x4,%eax
  80467a:	05 a0 70 83 00       	add    $0x8370a0,%eax
  80467f:	8b 00                	mov    (%eax),%eax
  804681:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  804684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804688:	75 14                	jne    80469e <alloc_block+0xb0>
  80468a:	83 ec 04             	sub    $0x4,%esp
  80468d:	68 3d 64 80 00       	push   $0x80643d
  804692:	6a 6b                	push   $0x6b
  804694:	68 a3 63 80 00       	push   $0x8063a3
  804699:	e8 19 cc ff ff       	call   8012b7 <_panic>
  80469e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046a1:	8b 00                	mov    (%eax),%eax
  8046a3:	85 c0                	test   %eax,%eax
  8046a5:	74 10                	je     8046b7 <alloc_block+0xc9>
  8046a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046aa:	8b 00                	mov    (%eax),%eax
  8046ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046af:	8b 52 04             	mov    0x4(%edx),%edx
  8046b2:	89 50 04             	mov    %edx,0x4(%eax)
  8046b5:	eb 14                	jmp    8046cb <alloc_block+0xdd>
  8046b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046ba:	8b 40 04             	mov    0x4(%eax),%eax
  8046bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8046c0:	c1 e2 04             	shl    $0x4,%edx
  8046c3:	81 c2 a4 70 83 00    	add    $0x8370a4,%edx
  8046c9:	89 02                	mov    %eax,(%edx)
  8046cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046ce:	8b 40 04             	mov    0x4(%eax),%eax
  8046d1:	85 c0                	test   %eax,%eax
  8046d3:	74 0f                	je     8046e4 <alloc_block+0xf6>
  8046d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046d8:	8b 40 04             	mov    0x4(%eax),%eax
  8046db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046de:	8b 12                	mov    (%edx),%edx
  8046e0:	89 10                	mov    %edx,(%eax)
  8046e2:	eb 13                	jmp    8046f7 <alloc_block+0x109>
  8046e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046e7:	8b 00                	mov    (%eax),%eax
  8046e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8046ec:	c1 e2 04             	shl    $0x4,%edx
  8046ef:	81 c2 a0 70 83 00    	add    $0x8370a0,%edx
  8046f5:	89 02                	mov    %eax,(%edx)
  8046f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804703:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80470a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80470d:	c1 e0 04             	shl    $0x4,%eax
  804710:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804715:	8b 00                	mov    (%eax),%eax
  804717:	8d 50 ff             	lea    -0x1(%eax),%edx
  80471a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80471d:	c1 e0 04             	shl    $0x4,%eax
  804720:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804725:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  804727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80472a:	83 ec 0c             	sub    $0xc,%esp
  80472d:	50                   	push   %eax
  80472e:	e8 ba fb ff ff       	call   8042ed <to_page_info>
  804733:	83 c4 10             	add    $0x10,%esp
  804736:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  804739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80473c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804740:	48                   	dec    %eax
  804741:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804744:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  804748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80474b:	e9 8f 02 00 00       	jmp    8049df <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804750:	ff 45 ec             	incl   -0x14(%ebp)
  804753:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804757:	0f 8e 02 ff ff ff    	jle    80465f <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  80475d:	a1 68 f0 81 00       	mov    0x81f068,%eax
  804762:	85 c0                	test   %eax,%eax
  804764:	75 14                	jne    80477a <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  804766:	83 ec 04             	sub    $0x4,%esp
  804769:	68 5c 64 80 00       	push   $0x80645c
  80476e:	6a 77                	push   $0x77
  804770:	68 a3 63 80 00       	push   $0x8063a3
  804775:	e8 3d cb ff ff       	call   8012b7 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  80477a:	a1 68 f0 81 00       	mov    0x81f068,%eax
  80477f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  804782:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804786:	75 14                	jne    80479c <alloc_block+0x1ae>
  804788:	83 ec 04             	sub    $0x4,%esp
  80478b:	68 3d 64 80 00       	push   $0x80643d
  804790:	6a 7a                	push   $0x7a
  804792:	68 a3 63 80 00       	push   $0x8063a3
  804797:	e8 1b cb ff ff       	call   8012b7 <_panic>
  80479c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80479f:	8b 00                	mov    (%eax),%eax
  8047a1:	85 c0                	test   %eax,%eax
  8047a3:	74 10                	je     8047b5 <alloc_block+0x1c7>
  8047a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8047a8:	8b 00                	mov    (%eax),%eax
  8047aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8047ad:	8b 52 04             	mov    0x4(%edx),%edx
  8047b0:	89 50 04             	mov    %edx,0x4(%eax)
  8047b3:	eb 0b                	jmp    8047c0 <alloc_block+0x1d2>
  8047b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8047b8:	8b 40 04             	mov    0x4(%eax),%eax
  8047bb:	a3 6c f0 81 00       	mov    %eax,0x81f06c
  8047c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8047c3:	8b 40 04             	mov    0x4(%eax),%eax
  8047c6:	85 c0                	test   %eax,%eax
  8047c8:	74 0f                	je     8047d9 <alloc_block+0x1eb>
  8047ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8047cd:	8b 40 04             	mov    0x4(%eax),%eax
  8047d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8047d3:	8b 12                	mov    (%edx),%edx
  8047d5:	89 10                	mov    %edx,(%eax)
  8047d7:	eb 0a                	jmp    8047e3 <alloc_block+0x1f5>
  8047d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8047dc:	8b 00                	mov    (%eax),%eax
  8047de:	a3 68 f0 81 00       	mov    %eax,0x81f068
  8047e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8047e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8047ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047f6:	a1 74 f0 81 00       	mov    0x81f074,%eax
  8047fb:	48                   	dec    %eax
  8047fc:	a3 74 f0 81 00       	mov    %eax,0x81f074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  804801:	83 ec 0c             	sub    $0xc,%esp
  804804:	ff 75 dc             	pushl  -0x24(%ebp)
  804807:	e8 6f fa ff ff       	call   80427b <to_page_va>
  80480c:	83 c4 10             	add    $0x10,%esp
  80480f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  804812:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804815:	83 ec 0c             	sub    $0xc,%esp
  804818:	50                   	push   %eax
  804819:	e8 a0 dc ff ff       	call   8024be <get_page>
  80481e:	83 c4 10             	add    $0x10,%esp
  804821:	85 c0                	test   %eax,%eax
  804823:	74 14                	je     804839 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  804825:	83 ec 04             	sub    $0x4,%esp
  804828:	68 84 64 80 00       	push   $0x806484
  80482d:	6a 7f                	push   $0x7f
  80482f:	68 a3 63 80 00       	push   $0x8063a3
  804834:	e8 7e ca ff ff       	call   8012b7 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  804839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80483c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80483f:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  804843:	b8 00 10 00 00       	mov    $0x1000,%eax
  804848:	ba 00 00 00 00       	mov    $0x0,%edx
  80484d:	f7 75 f4             	divl   -0xc(%ebp)
  804850:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804853:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  804857:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80485e:	e9 a7 00 00 00       	jmp    80490a <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  804863:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804869:	01 d0                	add    %edx,%eax
  80486b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  80486e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804872:	75 17                	jne    80488b <alloc_block+0x29d>
  804874:	83 ec 04             	sub    $0x4,%esp
  804877:	68 ac 64 80 00       	push   $0x8064ac
  80487c:	68 88 00 00 00       	push   $0x88
  804881:	68 a3 63 80 00       	push   $0x8063a3
  804886:	e8 2c ca ff ff       	call   8012b7 <_panic>
  80488b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80488e:	c1 e0 04             	shl    $0x4,%eax
  804891:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804896:	8b 10                	mov    (%eax),%edx
  804898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80489b:	89 10                	mov    %edx,(%eax)
  80489d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048a0:	8b 00                	mov    (%eax),%eax
  8048a2:	85 c0                	test   %eax,%eax
  8048a4:	74 15                	je     8048bb <alloc_block+0x2cd>
  8048a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8048a9:	c1 e0 04             	shl    $0x4,%eax
  8048ac:	05 a0 70 83 00       	add    $0x8370a0,%eax
  8048b1:	8b 00                	mov    (%eax),%eax
  8048b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8048b6:	89 50 04             	mov    %edx,0x4(%eax)
  8048b9:	eb 11                	jmp    8048cc <alloc_block+0x2de>
  8048bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8048be:	c1 e0 04             	shl    $0x4,%eax
  8048c1:	8d 90 a4 70 83 00    	lea    0x8370a4(%eax),%edx
  8048c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048ca:	89 02                	mov    %eax,(%edx)
  8048cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8048cf:	c1 e0 04             	shl    $0x4,%eax
  8048d2:	8d 90 a0 70 83 00    	lea    0x8370a0(%eax),%edx
  8048d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048db:	89 02                	mov    %eax,(%edx)
  8048dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8048ea:	c1 e0 04             	shl    $0x4,%eax
  8048ed:	05 ac 70 83 00       	add    $0x8370ac,%eax
  8048f2:	8b 00                	mov    (%eax),%eax
  8048f4:	8d 50 01             	lea    0x1(%eax),%edx
  8048f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8048fa:	c1 e0 04             	shl    $0x4,%eax
  8048fd:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804902:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  804904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804907:	01 45 e8             	add    %eax,-0x18(%ebp)
  80490a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  804911:	0f 86 4c ff ff ff    	jbe    804863 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  804917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80491a:	c1 e0 04             	shl    $0x4,%eax
  80491d:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804922:	8b 00                	mov    (%eax),%eax
  804924:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  804927:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80492b:	75 17                	jne    804944 <alloc_block+0x356>
  80492d:	83 ec 04             	sub    $0x4,%esp
  804930:	68 3d 64 80 00       	push   $0x80643d
  804935:	68 8d 00 00 00       	push   $0x8d
  80493a:	68 a3 63 80 00       	push   $0x8063a3
  80493f:	e8 73 c9 ff ff       	call   8012b7 <_panic>
  804944:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804947:	8b 00                	mov    (%eax),%eax
  804949:	85 c0                	test   %eax,%eax
  80494b:	74 10                	je     80495d <alloc_block+0x36f>
  80494d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804950:	8b 00                	mov    (%eax),%eax
  804952:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804955:	8b 52 04             	mov    0x4(%edx),%edx
  804958:	89 50 04             	mov    %edx,0x4(%eax)
  80495b:	eb 14                	jmp    804971 <alloc_block+0x383>
  80495d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804960:	8b 40 04             	mov    0x4(%eax),%eax
  804963:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804966:	c1 e2 04             	shl    $0x4,%edx
  804969:	81 c2 a4 70 83 00    	add    $0x8370a4,%edx
  80496f:	89 02                	mov    %eax,(%edx)
  804971:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804974:	8b 40 04             	mov    0x4(%eax),%eax
  804977:	85 c0                	test   %eax,%eax
  804979:	74 0f                	je     80498a <alloc_block+0x39c>
  80497b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80497e:	8b 40 04             	mov    0x4(%eax),%eax
  804981:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804984:	8b 12                	mov    (%edx),%edx
  804986:	89 10                	mov    %edx,(%eax)
  804988:	eb 13                	jmp    80499d <alloc_block+0x3af>
  80498a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80498d:	8b 00                	mov    (%eax),%eax
  80498f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804992:	c1 e2 04             	shl    $0x4,%edx
  804995:	81 c2 a0 70 83 00    	add    $0x8370a0,%edx
  80499b:	89 02                	mov    %eax,(%edx)
  80499d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8049a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8049a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8049a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049b3:	c1 e0 04             	shl    $0x4,%eax
  8049b6:	05 ac 70 83 00       	add    $0x8370ac,%eax
  8049bb:	8b 00                	mov    (%eax),%eax
  8049bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8049c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049c3:	c1 e0 04             	shl    $0x4,%eax
  8049c6:	05 ac 70 83 00       	add    $0x8370ac,%eax
  8049cb:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8049cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8049d0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8049d4:	48                   	dec    %eax
  8049d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8049d8:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  8049dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8049df:	c9                   	leave  
  8049e0:	c3                   	ret    

008049e1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8049e1:	55                   	push   %ebp
  8049e2:	89 e5                	mov    %esp,%ebp
  8049e4:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8049e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8049ea:	a1 84 70 83 00       	mov    0x837084,%eax
  8049ef:	39 c2                	cmp    %eax,%edx
  8049f1:	72 0c                	jb     8049ff <free_block+0x1e>
  8049f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8049f6:	a1 60 f0 81 00       	mov    0x81f060,%eax
  8049fb:	39 c2                	cmp    %eax,%edx
  8049fd:	72 19                	jb     804a18 <free_block+0x37>
  8049ff:	68 d0 64 80 00       	push   $0x8064d0
  804a04:	68 06 64 80 00       	push   $0x806406
  804a09:	68 98 00 00 00       	push   $0x98
  804a0e:	68 a3 63 80 00       	push   $0x8063a3
  804a13:	e8 9f c8 ff ff       	call   8012b7 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804a18:	8b 45 08             	mov    0x8(%ebp),%eax
  804a1b:	83 ec 0c             	sub    $0xc,%esp
  804a1e:	50                   	push   %eax
  804a1f:	e8 c9 f8 ff ff       	call   8042ed <to_page_info>
  804a24:	83 c4 10             	add    $0x10,%esp
  804a27:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a2d:	8b 40 08             	mov    0x8(%eax),%eax
  804a30:	0f b7 c0             	movzwl %ax,%eax
  804a33:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  804a36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804a3d:	eb 03                	jmp    804a42 <free_block+0x61>
		listIndex++;
  804a3f:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a45:	ba 08 00 00 00       	mov    $0x8,%edx
  804a4a:	88 c1                	mov    %al,%cl
  804a4c:	d3 e2                	shl    %cl,%edx
  804a4e:	89 d0                	mov    %edx,%eax
  804a50:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804a53:	72 ea                	jb     804a3f <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  804a55:	8b 45 08             	mov    0x8(%ebp),%eax
  804a58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  804a5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804a5f:	75 17                	jne    804a78 <free_block+0x97>
  804a61:	83 ec 04             	sub    $0x4,%esp
  804a64:	68 ac 64 80 00       	push   $0x8064ac
  804a69:	68 a2 00 00 00       	push   $0xa2
  804a6e:	68 a3 63 80 00       	push   $0x8063a3
  804a73:	e8 3f c8 ff ff       	call   8012b7 <_panic>
  804a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a7b:	c1 e0 04             	shl    $0x4,%eax
  804a7e:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804a83:	8b 10                	mov    (%eax),%edx
  804a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a88:	89 10                	mov    %edx,(%eax)
  804a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a8d:	8b 00                	mov    (%eax),%eax
  804a8f:	85 c0                	test   %eax,%eax
  804a91:	74 15                	je     804aa8 <free_block+0xc7>
  804a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a96:	c1 e0 04             	shl    $0x4,%eax
  804a99:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804a9e:	8b 00                	mov    (%eax),%eax
  804aa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804aa3:	89 50 04             	mov    %edx,0x4(%eax)
  804aa6:	eb 11                	jmp    804ab9 <free_block+0xd8>
  804aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aab:	c1 e0 04             	shl    $0x4,%eax
  804aae:	8d 90 a4 70 83 00    	lea    0x8370a4(%eax),%edx
  804ab4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ab7:	89 02                	mov    %eax,(%edx)
  804ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804abc:	c1 e0 04             	shl    $0x4,%eax
  804abf:	8d 90 a0 70 83 00    	lea    0x8370a0(%eax),%edx
  804ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ac8:	89 02                	mov    %eax,(%edx)
  804aca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804acd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ad7:	c1 e0 04             	shl    $0x4,%eax
  804ada:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804adf:	8b 00                	mov    (%eax),%eax
  804ae1:	8d 50 01             	lea    0x1(%eax),%edx
  804ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ae7:	c1 e0 04             	shl    $0x4,%eax
  804aea:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804aef:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804af4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804af8:	40                   	inc    %eax
  804af9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804afc:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804b03:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804b07:	0f b7 c8             	movzwl %ax,%ecx
  804b0a:	b8 00 10 00 00       	mov    $0x1000,%eax
  804b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  804b14:	f7 75 e8             	divl   -0x18(%ebp)
  804b17:	39 c1                	cmp    %eax,%ecx
  804b19:	0f 85 ed 01 00 00    	jne    804d0c <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b22:	c1 e0 04             	shl    $0x4,%eax
  804b25:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804b2a:	8b 00                	mov    (%eax),%eax
  804b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804b2f:	eb 2a                	jmp    804b5b <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  804b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b34:	83 ec 0c             	sub    $0xc,%esp
  804b37:	50                   	push   %eax
  804b38:	e8 b0 f7 ff ff       	call   8042ed <to_page_info>
  804b3d:	83 c4 10             	add    $0x10,%esp
  804b40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804b43:	75 06                	jne    804b4b <free_block+0x16a>
				tmp = b;
  804b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b48:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b4e:	c1 e0 04             	shl    $0x4,%eax
  804b51:	05 a8 70 83 00       	add    $0x8370a8,%eax
  804b56:	8b 00                	mov    (%eax),%eax
  804b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804b5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804b5f:	74 07                	je     804b68 <free_block+0x187>
  804b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b64:	8b 00                	mov    (%eax),%eax
  804b66:	eb 05                	jmp    804b6d <free_block+0x18c>
  804b68:	b8 00 00 00 00       	mov    $0x0,%eax
  804b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804b70:	c1 e2 04             	shl    $0x4,%edx
  804b73:	81 c2 a8 70 83 00    	add    $0x8370a8,%edx
  804b79:	89 02                	mov    %eax,(%edx)
  804b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b7e:	c1 e0 04             	shl    $0x4,%eax
  804b81:	05 a8 70 83 00       	add    $0x8370a8,%eax
  804b86:	8b 00                	mov    (%eax),%eax
  804b88:	85 c0                	test   %eax,%eax
  804b8a:	75 a5                	jne    804b31 <free_block+0x150>
  804b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804b90:	75 9f                	jne    804b31 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b95:	c1 e0 04             	shl    $0x4,%eax
  804b98:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804b9d:	8b 00                	mov    (%eax),%eax
  804b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804ba2:	e9 cc 00 00 00       	jmp    804c73 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  804ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804baa:	8b 00                	mov    (%eax),%eax
  804bac:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804bb2:	83 ec 0c             	sub    $0xc,%esp
  804bb5:	50                   	push   %eax
  804bb6:	e8 32 f7 ff ff       	call   8042ed <to_page_info>
  804bbb:	83 c4 10             	add    $0x10,%esp
  804bbe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804bc1:	0f 85 a6 00 00 00    	jne    804c6d <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  804bc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804bcb:	75 17                	jne    804be4 <free_block+0x203>
  804bcd:	83 ec 04             	sub    $0x4,%esp
  804bd0:	68 3d 64 80 00       	push   $0x80643d
  804bd5:	68 b5 00 00 00       	push   $0xb5
  804bda:	68 a3 63 80 00       	push   $0x8063a3
  804bdf:	e8 d3 c6 ff ff       	call   8012b7 <_panic>
  804be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804be7:	8b 00                	mov    (%eax),%eax
  804be9:	85 c0                	test   %eax,%eax
  804beb:	74 10                	je     804bfd <free_block+0x21c>
  804bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804bf0:	8b 00                	mov    (%eax),%eax
  804bf2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804bf5:	8b 52 04             	mov    0x4(%edx),%edx
  804bf8:	89 50 04             	mov    %edx,0x4(%eax)
  804bfb:	eb 14                	jmp    804c11 <free_block+0x230>
  804bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c00:	8b 40 04             	mov    0x4(%eax),%eax
  804c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804c06:	c1 e2 04             	shl    $0x4,%edx
  804c09:	81 c2 a4 70 83 00    	add    $0x8370a4,%edx
  804c0f:	89 02                	mov    %eax,(%edx)
  804c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c14:	8b 40 04             	mov    0x4(%eax),%eax
  804c17:	85 c0                	test   %eax,%eax
  804c19:	74 0f                	je     804c2a <free_block+0x249>
  804c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c1e:	8b 40 04             	mov    0x4(%eax),%eax
  804c21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804c24:	8b 12                	mov    (%edx),%edx
  804c26:	89 10                	mov    %edx,(%eax)
  804c28:	eb 13                	jmp    804c3d <free_block+0x25c>
  804c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c2d:	8b 00                	mov    (%eax),%eax
  804c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804c32:	c1 e2 04             	shl    $0x4,%edx
  804c35:	81 c2 a0 70 83 00    	add    $0x8370a0,%edx
  804c3b:	89 02                	mov    %eax,(%edx)
  804c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c53:	c1 e0 04             	shl    $0x4,%eax
  804c56:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804c5b:	8b 00                	mov    (%eax),%eax
  804c5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c63:	c1 e0 04             	shl    $0x4,%eax
  804c66:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804c6b:	89 10                	mov    %edx,(%eax)
			b = next;
  804c6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804c77:	0f 85 2a ff ff ff    	jne    804ba7 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  804c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c80:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c89:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804c8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804c93:	75 17                	jne    804cac <free_block+0x2cb>
  804c95:	83 ec 04             	sub    $0x4,%esp
  804c98:	68 ac 64 80 00       	push   $0x8064ac
  804c9d:	68 bc 00 00 00       	push   $0xbc
  804ca2:	68 a3 63 80 00       	push   $0x8063a3
  804ca7:	e8 0b c6 ff ff       	call   8012b7 <_panic>
  804cac:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  804cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cb5:	89 10                	mov    %edx,(%eax)
  804cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cba:	8b 00                	mov    (%eax),%eax
  804cbc:	85 c0                	test   %eax,%eax
  804cbe:	74 0d                	je     804ccd <free_block+0x2ec>
  804cc0:	a1 68 f0 81 00       	mov    0x81f068,%eax
  804cc5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804cc8:	89 50 04             	mov    %edx,0x4(%eax)
  804ccb:	eb 08                	jmp    804cd5 <free_block+0x2f4>
  804ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cd0:	a3 6c f0 81 00       	mov    %eax,0x81f06c
  804cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cd8:	a3 68 f0 81 00       	mov    %eax,0x81f068
  804cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804ce7:	a1 74 f0 81 00       	mov    0x81f074,%eax
  804cec:	40                   	inc    %eax
  804ced:	a3 74 f0 81 00       	mov    %eax,0x81f074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804cf2:	83 ec 0c             	sub    $0xc,%esp
  804cf5:	ff 75 ec             	pushl  -0x14(%ebp)
  804cf8:	e8 7e f5 ff ff       	call   80427b <to_page_va>
  804cfd:	83 c4 10             	add    $0x10,%esp
  804d00:	83 ec 0c             	sub    $0xc,%esp
  804d03:	50                   	push   %eax
  804d04:	e8 fe d7 ff ff       	call   802507 <return_page>
  804d09:	83 c4 10             	add    $0x10,%esp
	}
}
  804d0c:	90                   	nop
  804d0d:	c9                   	leave  
  804d0e:	c3                   	ret    
  804d0f:	90                   	nop

00804d10 <__udivdi3>:
  804d10:	55                   	push   %ebp
  804d11:	57                   	push   %edi
  804d12:	56                   	push   %esi
  804d13:	53                   	push   %ebx
  804d14:	83 ec 1c             	sub    $0x1c,%esp
  804d17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804d1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804d1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804d23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804d27:	89 ca                	mov    %ecx,%edx
  804d29:	89 f8                	mov    %edi,%eax
  804d2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804d2f:	85 f6                	test   %esi,%esi
  804d31:	75 2d                	jne    804d60 <__udivdi3+0x50>
  804d33:	39 cf                	cmp    %ecx,%edi
  804d35:	77 65                	ja     804d9c <__udivdi3+0x8c>
  804d37:	89 fd                	mov    %edi,%ebp
  804d39:	85 ff                	test   %edi,%edi
  804d3b:	75 0b                	jne    804d48 <__udivdi3+0x38>
  804d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  804d42:	31 d2                	xor    %edx,%edx
  804d44:	f7 f7                	div    %edi
  804d46:	89 c5                	mov    %eax,%ebp
  804d48:	31 d2                	xor    %edx,%edx
  804d4a:	89 c8                	mov    %ecx,%eax
  804d4c:	f7 f5                	div    %ebp
  804d4e:	89 c1                	mov    %eax,%ecx
  804d50:	89 d8                	mov    %ebx,%eax
  804d52:	f7 f5                	div    %ebp
  804d54:	89 cf                	mov    %ecx,%edi
  804d56:	89 fa                	mov    %edi,%edx
  804d58:	83 c4 1c             	add    $0x1c,%esp
  804d5b:	5b                   	pop    %ebx
  804d5c:	5e                   	pop    %esi
  804d5d:	5f                   	pop    %edi
  804d5e:	5d                   	pop    %ebp
  804d5f:	c3                   	ret    
  804d60:	39 ce                	cmp    %ecx,%esi
  804d62:	77 28                	ja     804d8c <__udivdi3+0x7c>
  804d64:	0f bd fe             	bsr    %esi,%edi
  804d67:	83 f7 1f             	xor    $0x1f,%edi
  804d6a:	75 40                	jne    804dac <__udivdi3+0x9c>
  804d6c:	39 ce                	cmp    %ecx,%esi
  804d6e:	72 0a                	jb     804d7a <__udivdi3+0x6a>
  804d70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804d74:	0f 87 9e 00 00 00    	ja     804e18 <__udivdi3+0x108>
  804d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  804d7f:	89 fa                	mov    %edi,%edx
  804d81:	83 c4 1c             	add    $0x1c,%esp
  804d84:	5b                   	pop    %ebx
  804d85:	5e                   	pop    %esi
  804d86:	5f                   	pop    %edi
  804d87:	5d                   	pop    %ebp
  804d88:	c3                   	ret    
  804d89:	8d 76 00             	lea    0x0(%esi),%esi
  804d8c:	31 ff                	xor    %edi,%edi
  804d8e:	31 c0                	xor    %eax,%eax
  804d90:	89 fa                	mov    %edi,%edx
  804d92:	83 c4 1c             	add    $0x1c,%esp
  804d95:	5b                   	pop    %ebx
  804d96:	5e                   	pop    %esi
  804d97:	5f                   	pop    %edi
  804d98:	5d                   	pop    %ebp
  804d99:	c3                   	ret    
  804d9a:	66 90                	xchg   %ax,%ax
  804d9c:	89 d8                	mov    %ebx,%eax
  804d9e:	f7 f7                	div    %edi
  804da0:	31 ff                	xor    %edi,%edi
  804da2:	89 fa                	mov    %edi,%edx
  804da4:	83 c4 1c             	add    $0x1c,%esp
  804da7:	5b                   	pop    %ebx
  804da8:	5e                   	pop    %esi
  804da9:	5f                   	pop    %edi
  804daa:	5d                   	pop    %ebp
  804dab:	c3                   	ret    
  804dac:	bd 20 00 00 00       	mov    $0x20,%ebp
  804db1:	89 eb                	mov    %ebp,%ebx
  804db3:	29 fb                	sub    %edi,%ebx
  804db5:	89 f9                	mov    %edi,%ecx
  804db7:	d3 e6                	shl    %cl,%esi
  804db9:	89 c5                	mov    %eax,%ebp
  804dbb:	88 d9                	mov    %bl,%cl
  804dbd:	d3 ed                	shr    %cl,%ebp
  804dbf:	89 e9                	mov    %ebp,%ecx
  804dc1:	09 f1                	or     %esi,%ecx
  804dc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804dc7:	89 f9                	mov    %edi,%ecx
  804dc9:	d3 e0                	shl    %cl,%eax
  804dcb:	89 c5                	mov    %eax,%ebp
  804dcd:	89 d6                	mov    %edx,%esi
  804dcf:	88 d9                	mov    %bl,%cl
  804dd1:	d3 ee                	shr    %cl,%esi
  804dd3:	89 f9                	mov    %edi,%ecx
  804dd5:	d3 e2                	shl    %cl,%edx
  804dd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  804ddb:	88 d9                	mov    %bl,%cl
  804ddd:	d3 e8                	shr    %cl,%eax
  804ddf:	09 c2                	or     %eax,%edx
  804de1:	89 d0                	mov    %edx,%eax
  804de3:	89 f2                	mov    %esi,%edx
  804de5:	f7 74 24 0c          	divl   0xc(%esp)
  804de9:	89 d6                	mov    %edx,%esi
  804deb:	89 c3                	mov    %eax,%ebx
  804ded:	f7 e5                	mul    %ebp
  804def:	39 d6                	cmp    %edx,%esi
  804df1:	72 19                	jb     804e0c <__udivdi3+0xfc>
  804df3:	74 0b                	je     804e00 <__udivdi3+0xf0>
  804df5:	89 d8                	mov    %ebx,%eax
  804df7:	31 ff                	xor    %edi,%edi
  804df9:	e9 58 ff ff ff       	jmp    804d56 <__udivdi3+0x46>
  804dfe:	66 90                	xchg   %ax,%ax
  804e00:	8b 54 24 08          	mov    0x8(%esp),%edx
  804e04:	89 f9                	mov    %edi,%ecx
  804e06:	d3 e2                	shl    %cl,%edx
  804e08:	39 c2                	cmp    %eax,%edx
  804e0a:	73 e9                	jae    804df5 <__udivdi3+0xe5>
  804e0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804e0f:	31 ff                	xor    %edi,%edi
  804e11:	e9 40 ff ff ff       	jmp    804d56 <__udivdi3+0x46>
  804e16:	66 90                	xchg   %ax,%ax
  804e18:	31 c0                	xor    %eax,%eax
  804e1a:	e9 37 ff ff ff       	jmp    804d56 <__udivdi3+0x46>
  804e1f:	90                   	nop

00804e20 <__umoddi3>:
  804e20:	55                   	push   %ebp
  804e21:	57                   	push   %edi
  804e22:	56                   	push   %esi
  804e23:	53                   	push   %ebx
  804e24:	83 ec 1c             	sub    $0x1c,%esp
  804e27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804e2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  804e2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804e33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804e37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804e3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804e3f:	89 f3                	mov    %esi,%ebx
  804e41:	89 fa                	mov    %edi,%edx
  804e43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804e47:	89 34 24             	mov    %esi,(%esp)
  804e4a:	85 c0                	test   %eax,%eax
  804e4c:	75 1a                	jne    804e68 <__umoddi3+0x48>
  804e4e:	39 f7                	cmp    %esi,%edi
  804e50:	0f 86 a2 00 00 00    	jbe    804ef8 <__umoddi3+0xd8>
  804e56:	89 c8                	mov    %ecx,%eax
  804e58:	89 f2                	mov    %esi,%edx
  804e5a:	f7 f7                	div    %edi
  804e5c:	89 d0                	mov    %edx,%eax
  804e5e:	31 d2                	xor    %edx,%edx
  804e60:	83 c4 1c             	add    $0x1c,%esp
  804e63:	5b                   	pop    %ebx
  804e64:	5e                   	pop    %esi
  804e65:	5f                   	pop    %edi
  804e66:	5d                   	pop    %ebp
  804e67:	c3                   	ret    
  804e68:	39 f0                	cmp    %esi,%eax
  804e6a:	0f 87 ac 00 00 00    	ja     804f1c <__umoddi3+0xfc>
  804e70:	0f bd e8             	bsr    %eax,%ebp
  804e73:	83 f5 1f             	xor    $0x1f,%ebp
  804e76:	0f 84 ac 00 00 00    	je     804f28 <__umoddi3+0x108>
  804e7c:	bf 20 00 00 00       	mov    $0x20,%edi
  804e81:	29 ef                	sub    %ebp,%edi
  804e83:	89 fe                	mov    %edi,%esi
  804e85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804e89:	89 e9                	mov    %ebp,%ecx
  804e8b:	d3 e0                	shl    %cl,%eax
  804e8d:	89 d7                	mov    %edx,%edi
  804e8f:	89 f1                	mov    %esi,%ecx
  804e91:	d3 ef                	shr    %cl,%edi
  804e93:	09 c7                	or     %eax,%edi
  804e95:	89 e9                	mov    %ebp,%ecx
  804e97:	d3 e2                	shl    %cl,%edx
  804e99:	89 14 24             	mov    %edx,(%esp)
  804e9c:	89 d8                	mov    %ebx,%eax
  804e9e:	d3 e0                	shl    %cl,%eax
  804ea0:	89 c2                	mov    %eax,%edx
  804ea2:	8b 44 24 08          	mov    0x8(%esp),%eax
  804ea6:	d3 e0                	shl    %cl,%eax
  804ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  804eac:	8b 44 24 08          	mov    0x8(%esp),%eax
  804eb0:	89 f1                	mov    %esi,%ecx
  804eb2:	d3 e8                	shr    %cl,%eax
  804eb4:	09 d0                	or     %edx,%eax
  804eb6:	d3 eb                	shr    %cl,%ebx
  804eb8:	89 da                	mov    %ebx,%edx
  804eba:	f7 f7                	div    %edi
  804ebc:	89 d3                	mov    %edx,%ebx
  804ebe:	f7 24 24             	mull   (%esp)
  804ec1:	89 c6                	mov    %eax,%esi
  804ec3:	89 d1                	mov    %edx,%ecx
  804ec5:	39 d3                	cmp    %edx,%ebx
  804ec7:	0f 82 87 00 00 00    	jb     804f54 <__umoddi3+0x134>
  804ecd:	0f 84 91 00 00 00    	je     804f64 <__umoddi3+0x144>
  804ed3:	8b 54 24 04          	mov    0x4(%esp),%edx
  804ed7:	29 f2                	sub    %esi,%edx
  804ed9:	19 cb                	sbb    %ecx,%ebx
  804edb:	89 d8                	mov    %ebx,%eax
  804edd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804ee1:	d3 e0                	shl    %cl,%eax
  804ee3:	89 e9                	mov    %ebp,%ecx
  804ee5:	d3 ea                	shr    %cl,%edx
  804ee7:	09 d0                	or     %edx,%eax
  804ee9:	89 e9                	mov    %ebp,%ecx
  804eeb:	d3 eb                	shr    %cl,%ebx
  804eed:	89 da                	mov    %ebx,%edx
  804eef:	83 c4 1c             	add    $0x1c,%esp
  804ef2:	5b                   	pop    %ebx
  804ef3:	5e                   	pop    %esi
  804ef4:	5f                   	pop    %edi
  804ef5:	5d                   	pop    %ebp
  804ef6:	c3                   	ret    
  804ef7:	90                   	nop
  804ef8:	89 fd                	mov    %edi,%ebp
  804efa:	85 ff                	test   %edi,%edi
  804efc:	75 0b                	jne    804f09 <__umoddi3+0xe9>
  804efe:	b8 01 00 00 00       	mov    $0x1,%eax
  804f03:	31 d2                	xor    %edx,%edx
  804f05:	f7 f7                	div    %edi
  804f07:	89 c5                	mov    %eax,%ebp
  804f09:	89 f0                	mov    %esi,%eax
  804f0b:	31 d2                	xor    %edx,%edx
  804f0d:	f7 f5                	div    %ebp
  804f0f:	89 c8                	mov    %ecx,%eax
  804f11:	f7 f5                	div    %ebp
  804f13:	89 d0                	mov    %edx,%eax
  804f15:	e9 44 ff ff ff       	jmp    804e5e <__umoddi3+0x3e>
  804f1a:	66 90                	xchg   %ax,%ax
  804f1c:	89 c8                	mov    %ecx,%eax
  804f1e:	89 f2                	mov    %esi,%edx
  804f20:	83 c4 1c             	add    $0x1c,%esp
  804f23:	5b                   	pop    %ebx
  804f24:	5e                   	pop    %esi
  804f25:	5f                   	pop    %edi
  804f26:	5d                   	pop    %ebp
  804f27:	c3                   	ret    
  804f28:	3b 04 24             	cmp    (%esp),%eax
  804f2b:	72 06                	jb     804f33 <__umoddi3+0x113>
  804f2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804f31:	77 0f                	ja     804f42 <__umoddi3+0x122>
  804f33:	89 f2                	mov    %esi,%edx
  804f35:	29 f9                	sub    %edi,%ecx
  804f37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804f3b:	89 14 24             	mov    %edx,(%esp)
  804f3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804f42:	8b 44 24 04          	mov    0x4(%esp),%eax
  804f46:	8b 14 24             	mov    (%esp),%edx
  804f49:	83 c4 1c             	add    $0x1c,%esp
  804f4c:	5b                   	pop    %ebx
  804f4d:	5e                   	pop    %esi
  804f4e:	5f                   	pop    %edi
  804f4f:	5d                   	pop    %ebp
  804f50:	c3                   	ret    
  804f51:	8d 76 00             	lea    0x0(%esi),%esi
  804f54:	2b 04 24             	sub    (%esp),%eax
  804f57:	19 fa                	sbb    %edi,%edx
  804f59:	89 d1                	mov    %edx,%ecx
  804f5b:	89 c6                	mov    %eax,%esi
  804f5d:	e9 71 ff ff ff       	jmp    804ed3 <__umoddi3+0xb3>
  804f62:	66 90                	xchg   %ax,%ax
  804f64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804f68:	72 ea                	jb     804f54 <__umoddi3+0x134>
  804f6a:	89 d9                	mov    %ebx,%ecx
  804f6c:	e9 62 ff ff ff       	jmp    804ed3 <__umoddi3+0xb3>
