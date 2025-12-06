
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 7e 16 00 00       	call   8016b4 <libmain>
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
  80005e:	81 ec b0 01 00 00    	sub    $0x1b0,%esp

#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800064:	a1 20 80 80 00       	mov    0x808020,%eax
  800069:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80006f:	a1 20 80 80 00       	mov    0x808020,%eax
  800074:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 e0 55 80 00       	push   $0x8055e0
  800086:	6a 1e                	push   $0x1e
  800088:	68 fc 55 80 00       	push   $0x8055fc
  80008d:	e8 d2 17 00 00       	call   801864 <_panic>
	}
	/*=================================================*/
#else
	panic("not handled!");
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800092:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int eval = 0;
  800099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

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
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	bool found;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 c0 42 00 00       	call   80439c <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 10 56 80 00       	push   $0x805610
  8000e7:	e8 46 1a 00 00       	call   801b32 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
	void* ptr_allocations[20] = {0};
  8000ef:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  8000f5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800103:	e8 94 42 00 00       	call   80439c <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 d7 42 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 d0 29 00 00       	call   802af4 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 6c 56 80 00       	push   $0x80566c
  800147:	e8 e6 19 00 00       	call   801b32 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 3e 42 00 00       	call   80439c <sys_calculate_free_frames>
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
  800195:	68 a0 56 80 00       	push   $0x8056a0
  80019a:	e8 93 19 00 00       	call   801b32 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 40 42 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 10 57 80 00       	push   $0x805710
  8001bb:	e8 72 19 00 00       	call   801b32 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 d4 41 00 00       	call   80439c <sys_calculate_free_frames>
  8001c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	01 c0                	add    %eax,%eax
  8001d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d3:	48                   	dec    %eax
  8001d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			byteArr = (char *) ptr_allocations[0];
  8001d7:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
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
  8001ff:	e8 98 41 00 00       	call   80439c <sys_calculate_free_frames>
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
  800237:	68 44 57 80 00       	push   $0x805744
  80023c:	e8 f1 18 00 00       	call   801b32 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800244:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800247:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80024a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80024d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800252:	89 85 b4 fe ff ff    	mov    %eax,-0x14c(%ebp)
  800258:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80025b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026b:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800271:	6a 02                	push   $0x2
  800273:	6a 00                	push   $0x0
  800275:	6a 02                	push   $0x2
  800277:	8d 85 b4 fe ff ff    	lea    -0x14c(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 db 44 00 00       	call   80475e <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 c4 57 80 00       	push   $0x8057c4
  80029e:	e8 8f 18 00 00       	call   801b32 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 f1 40 00 00       	call   80439c <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 34 41 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  8002b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002b9:	01 c0                	add    %eax,%eax
  8002bb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	50                   	push   %eax
  8002c2:	e8 2d 28 00 00       	call   802af4 <malloc>
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("2 Wrong start address for the allocated space... \n");}
  8002d0:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  8002d6:	89 c2                	mov    %eax,%edx
  8002d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002db:	01 c0                	add    %eax,%eax
  8002dd:	89 c1                	mov    %eax,%ecx
  8002df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e2:	01 c8                	add    %ecx,%eax
  8002e4:	39 c2                	cmp    %eax,%edx
  8002e6:	74 17                	je     8002ff <_main+0x2a6>
  8002e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	68 e8 57 80 00       	push   $0x8057e8
  8002f7:	e8 36 18 00 00       	call   801b32 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 8e 40 00 00       	call   80439c <sys_calculate_free_frames>
  80030e:	29 c3                	sub    %eax,%ebx
  800310:	89 d8                	mov    %ebx,%eax
  800312:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800315:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800318:	83 c0 02             	add    $0x2,%eax
  80031b:	83 ec 04             	sub    $0x4,%esp
  80031e:	50                   	push   %eax
  80031f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800322:	ff 75 c0             	pushl  -0x40(%ebp)
  800325:	e8 0e fd ff ff       	call   800038 <inRange>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	75 21                	jne    800352 <_main+0x2f9>
			{is_correct = 0; cprintf("2 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800338:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80033b:	83 c0 02             	add    $0x2,%eax
  80033e:	ff 75 c0             	pushl  -0x40(%ebp)
  800341:	50                   	push   %eax
  800342:	ff 75 c4             	pushl  -0x3c(%ebp)
  800345:	68 1c 58 80 00       	push   $0x80581c
  80034a:	e8 e3 17 00 00       	call   801b32 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 90 40 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 8c 58 80 00       	push   $0x80588c
  80036b:	e8 c2 17 00 00       	call   801b32 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 24 40 00 00       	call   80439c <sys_calculate_free_frames>
  800378:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80037b:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800381:	89 45 a8             	mov    %eax,-0x58(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800387:	01 c0                	add    %eax,%eax
  800389:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80038c:	d1 e8                	shr    %eax
  80038e:	48                   	dec    %eax
  80038f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			shortArr[0] = minShort;
  800392:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800398:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  80039b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039e:	01 c0                	add    %eax,%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a5:	01 c2                	add    %eax,%edx
  8003a7:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8003ab:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 ;
  8003ae:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003b5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003b8:	e8 df 3f 00 00       	call   80439c <sys_calculate_free_frames>
  8003bd:	29 c3                	sub    %eax,%ebx
  8003bf:	89 d8                	mov    %ebx,%eax
  8003c1:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8003c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003c7:	83 c0 02             	add    $0x2,%eax
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	50                   	push   %eax
  8003ce:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <inRange>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	75 1d                	jne    8003fd <_main+0x3a4>
			{ is_correct = 0; cprintf("2 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8003e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	ff 75 c0             	pushl  -0x40(%ebp)
  8003ed:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f0:	68 c0 58 80 00       	push   $0x8058c0
  8003f5:	e8 38 17 00 00       	call   801b32 <cprintf>
  8003fa:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  8003fd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800400:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800403:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040b:	89 85 ac fe ff ff    	mov    %eax,-0x154(%ebp)
  800411:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800414:	01 c0                	add    %eax,%eax
  800416:	89 c2                	mov    %eax,%edx
  800418:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80041b:	01 d0                	add    %edx,%eax
  80041d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800420:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800423:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800428:	89 85 b0 fe ff ff    	mov    %eax,-0x150(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80042e:	6a 02                	push   $0x2
  800430:	6a 00                	push   $0x0
  800432:	6a 02                	push   $0x2
  800434:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  80043a:	50                   	push   %eax
  80043b:	e8 1e 43 00 00       	call   80475e <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 40 59 80 00       	push   $0x805940
  80045b:	e8 d2 16 00 00       	call   801b32 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 7f 3f 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800468:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80046b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046e:	89 c2                	mov    %eax,%edx
  800470:	01 d2                	add    %edx,%edx
  800472:	01 d0                	add    %edx,%eax
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	50                   	push   %eax
  800478:	e8 77 26 00 00       	call   802af4 <malloc>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("3 Wrong start address for the allocated space... \n");}
  800486:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  80048c:	89 c2                	mov    %eax,%edx
  80048e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800491:	c1 e0 02             	shl    $0x2,%eax
  800494:	89 c1                	mov    %eax,%ecx
  800496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800499:	01 c8                	add    %ecx,%eax
  80049b:	39 c2                	cmp    %eax,%edx
  80049d:	74 17                	je     8004b6 <_main+0x45d>
  80049f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	68 64 59 80 00       	push   $0x805964
  8004ae:	e8 7f 16 00 00       	call   801b32 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 d7 3e 00 00       	call   80439c <sys_calculate_free_frames>
  8004c5:	29 c3                	sub    %eax,%ebx
  8004c7:	89 d8                	mov    %ebx,%eax
  8004c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8004cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004cf:	83 c0 02             	add    $0x2,%eax
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004d9:	ff 75 c0             	pushl  -0x40(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <inRange>
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	85 c0                	test   %eax,%eax
  8004e6:	75 21                	jne    800509 <_main+0x4b0>
			{is_correct = 0; cprintf("3 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  8004e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f2:	83 c0 02             	add    $0x2,%eax
  8004f5:	ff 75 c0             	pushl  -0x40(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004fc:	68 98 59 80 00       	push   $0x805998
  800501:	e8 2c 16 00 00       	call   801b32 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 d9 3e 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 08 5a 80 00       	push   $0x805a08
  800522:	e8 0b 16 00 00       	call   801b32 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 6d 3e 00 00       	call   80439c <sys_calculate_free_frames>
  80052f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			intArr = (int *) ptr_allocations[2];
  800532:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  800538:	89 45 98             	mov    %eax,-0x68(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80053b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	c1 e8 02             	shr    $0x2,%eax
  800543:	48                   	dec    %eax
  800544:	89 45 94             	mov    %eax,-0x6c(%ebp)
			intArr[0] = minInt;
  800547:	8b 45 98             	mov    -0x68(%ebp),%eax
  80054a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80054d:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  80054f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800559:	8b 45 98             	mov    -0x68(%ebp),%eax
  80055c:	01 c2                	add    %eax,%edx
  80055e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800561:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800563:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80056a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80056d:	e8 2a 3e 00 00       	call   80439c <sys_calculate_free_frames>
  800572:	29 c3                	sub    %eax,%ebx
  800574:	89 d8                	mov    %ebx,%eax
  800576:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800579:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80057c:	83 c0 02             	add    $0x2,%eax
  80057f:	83 ec 04             	sub    $0x4,%esp
  800582:	50                   	push   %eax
  800583:	ff 75 c4             	pushl  -0x3c(%ebp)
  800586:	ff 75 c0             	pushl  -0x40(%ebp)
  800589:	e8 aa fa ff ff       	call   800038 <inRange>
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	85 c0                	test   %eax,%eax
  800593:	75 1d                	jne    8005b2 <_main+0x559>
			{ is_correct = 0; cprintf("3 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800595:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	ff 75 c0             	pushl  -0x40(%ebp)
  8005a2:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005a5:	68 3c 5a 80 00       	push   $0x805a3c
  8005aa:	e8 83 15 00 00       	call   801b32 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  8005b2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005b5:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005b8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c0:	89 85 a4 fe ff ff    	mov    %eax,-0x15c(%ebp)
  8005c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005d8:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e0:	89 85 a8 fe ff ff    	mov    %eax,-0x158(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8005e6:	6a 02                	push   $0x2
  8005e8:	6a 00                	push   $0x0
  8005ea:	6a 02                	push   $0x2
  8005ec:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  8005f2:	50                   	push   %eax
  8005f3:	e8 66 41 00 00       	call   80475e <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 bc 5a 80 00       	push   $0x805abc
  800613:	e8 1a 15 00 00       	call   801b32 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 c7 3d 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800620:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800626:	89 c2                	mov    %eax,%edx
  800628:	01 d2                	add    %edx,%edx
  80062a:	01 d0                	add    %edx,%eax
  80062c:	83 ec 0c             	sub    $0xc,%esp
  80062f:	50                   	push   %eax
  800630:	e8 bf 24 00 00       	call   802af4 <malloc>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) { is_correct = 0; cprintf("4 Wrong start address for the allocated space... \n");}
  80063e:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800644:	89 c2                	mov    %eax,%edx
  800646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800649:	c1 e0 02             	shl    $0x2,%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800651:	c1 e0 02             	shl    $0x2,%eax
  800654:	01 c1                	add    %eax,%ecx
  800656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800659:	01 c8                	add    %ecx,%eax
  80065b:	39 c2                	cmp    %eax,%edx
  80065d:	74 17                	je     800676 <_main+0x61d>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 e0 5a 80 00       	push   $0x805ae0
  80066e:	e8 bf 14 00 00       	call   801b32 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 6c 3d 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 14 5b 80 00       	push   $0x805b14
  80068f:	e8 9e 14 00 00       	call   801b32 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 00 3d 00 00       	call   80439c <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 43 3d 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  8006a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006aa:	89 d0                	mov    %edx,%eax
  8006ac:	01 c0                	add    %eax,%eax
  8006ae:	01 d0                	add    %edx,%eax
  8006b0:	01 c0                	add    %eax,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	50                   	push   %eax
  8006b8:	e8 37 24 00 00       	call   802af4 <malloc>
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) { is_correct = 0; cprintf("5 Wrong start address for the allocated space... \n");}
  8006c6:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8006cc:	89 c2                	mov    %eax,%edx
  8006ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006d1:	c1 e0 02             	shl    $0x2,%eax
  8006d4:	89 c1                	mov    %eax,%ecx
  8006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d9:	c1 e0 03             	shl    $0x3,%eax
  8006dc:	01 c1                	add    %eax,%ecx
  8006de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e1:	01 c8                	add    %ecx,%eax
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	74 17                	je     8006fe <_main+0x6a5>
  8006e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	68 48 5b 80 00       	push   $0x805b48
  8006f6:	e8 37 14 00 00       	call   801b32 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 8f 3c 00 00       	call   80439c <sys_calculate_free_frames>
  80070d:	29 c3                	sub    %eax,%ebx
  80070f:	89 d8                	mov    %ebx,%eax
  800711:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800714:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800717:	83 c0 02             	add    $0x2,%eax
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	50                   	push   %eax
  80071e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800721:	ff 75 c0             	pushl  -0x40(%ebp)
  800724:	e8 0f f9 ff ff       	call   800038 <inRange>
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	85 c0                	test   %eax,%eax
  80072e:	75 21                	jne    800751 <_main+0x6f8>
			{is_correct = 0; cprintf("5 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800737:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80073a:	83 c0 02             	add    $0x2,%eax
  80073d:	ff 75 c0             	pushl  -0x40(%ebp)
  800740:	50                   	push   %eax
  800741:	ff 75 c4             	pushl  -0x3c(%ebp)
  800744:	68 7c 5b 80 00       	push   $0x805b7c
  800749:	e8 e4 13 00 00       	call   801b32 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 91 3c 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 ec 5b 80 00       	push   $0x805bec
  80076a:	e8 c3 13 00 00       	call   801b32 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 25 3c 00 00       	call   80439c <sys_calculate_free_frames>
  800777:	89 45 cc             	mov    %eax,-0x34(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  80077a:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800780:	89 45 88             	mov    %eax,-0x78(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800786:	89 d0                	mov    %edx,%eax
  800788:	01 c0                	add    %eax,%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	01 c0                	add    %eax,%eax
  80078e:	01 d0                	add    %edx,%eax
  800790:	c1 e8 03             	shr    $0x3,%eax
  800793:	48                   	dec    %eax
  800794:	89 45 84             	mov    %eax,-0x7c(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800797:	8b 45 88             	mov    -0x78(%ebp),%eax
  80079a:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  80079d:	88 10                	mov    %dl,(%eax)
  80079f:	8b 55 88             	mov    -0x78(%ebp),%edx
  8007a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a5:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007a9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007af:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8007b2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007bc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007bf:	01 c2                	add    %eax,%edx
  8007c1:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8007c4:	88 02                	mov    %al,(%edx)
  8007c6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007d0:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007d3:	01 c2                	add    %eax,%edx
  8007d5:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8007d9:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007dd:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007e7:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ea:	01 c2                	add    %eax,%edx
  8007ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007ef:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  8007f2:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8007f9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8007fc:	e8 9b 3b 00 00       	call   80439c <sys_calculate_free_frames>
  800801:	29 c3                	sub    %eax,%ebx
  800803:	89 d8                	mov    %ebx,%eax
  800805:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800808:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80080b:	83 c0 02             	add    $0x2,%eax
  80080e:	83 ec 04             	sub    $0x4,%esp
  800811:	50                   	push   %eax
  800812:	ff 75 c4             	pushl  -0x3c(%ebp)
  800815:	ff 75 c0             	pushl  -0x40(%ebp)
  800818:	e8 1b f8 ff ff       	call   800038 <inRange>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	85 c0                	test   %eax,%eax
  800822:	75 1d                	jne    800841 <_main+0x7e8>
			{ is_correct = 0; cprintf("5 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800824:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	ff 75 c0             	pushl  -0x40(%ebp)
  800831:	ff 75 c4             	pushl  -0x3c(%ebp)
  800834:	68 20 5c 80 00       	push   $0x805c20
  800839:	e8 f4 12 00 00       	call   801b32 <cprintf>
  80083e:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800841:	8b 45 88             	mov    -0x78(%ebp),%eax
  800844:	89 45 80             	mov    %eax,-0x80(%ebp)
  800847:	8b 45 80             	mov    -0x80(%ebp),%eax
  80084a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80084f:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
  800855:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800858:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80085f:	8b 45 88             	mov    -0x78(%ebp),%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80086a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800875:	89 85 a0 fe ff ff    	mov    %eax,-0x160(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80087b:	6a 02                	push   $0x2
  80087d:	6a 00                	push   $0x0
  80087f:	6a 02                	push   $0x2
  800881:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  800887:	50                   	push   %eax
  800888:	e8 d1 3e 00 00       	call   80475e <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 a0 5c 80 00       	push   $0x805ca0
  8008a8:	e8 85 12 00 00       	call   801b32 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 e7 3a 00 00       	call   80439c <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 2a 3b 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  8008bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  8008c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c3:	89 c2                	mov    %eax,%edx
  8008c5:	01 d2                	add    %edx,%edx
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	50                   	push   %eax
  8008d0:	e8 1f 22 00 00       	call   802af4 <malloc>
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) { is_correct = 0; cprintf("6 Wrong start address for the allocated space... \n");}
  8008de:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  8008e4:	89 c2                	mov    %eax,%edx
  8008e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e9:	c1 e0 02             	shl    $0x2,%eax
  8008ec:	89 c1                	mov    %eax,%ecx
  8008ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008f1:	c1 e0 04             	shl    $0x4,%eax
  8008f4:	01 c1                	add    %eax,%ecx
  8008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f9:	01 c8                	add    %ecx,%eax
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	74 17                	je     800916 <_main+0x8bd>
  8008ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800906:	83 ec 0c             	sub    $0xc,%esp
  800909:	68 c4 5c 80 00       	push   $0x805cc4
  80090e:	e8 1f 12 00 00       	call   801b32 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 77 3a 00 00       	call   80439c <sys_calculate_free_frames>
  800925:	29 c3                	sub    %eax,%ebx
  800927:	89 d8                	mov    %ebx,%eax
  800929:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80092c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80092f:	83 c0 02             	add    $0x2,%eax
  800932:	83 ec 04             	sub    $0x4,%esp
  800935:	50                   	push   %eax
  800936:	ff 75 c4             	pushl  -0x3c(%ebp)
  800939:	ff 75 c0             	pushl  -0x40(%ebp)
  80093c:	e8 f7 f6 ff ff       	call   800038 <inRange>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	75 21                	jne    800969 <_main+0x910>
			{is_correct = 0; cprintf("6 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800948:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800952:	83 c0 02             	add    $0x2,%eax
  800955:	ff 75 c0             	pushl  -0x40(%ebp)
  800958:	50                   	push   %eax
  800959:	ff 75 c4             	pushl  -0x3c(%ebp)
  80095c:	68 f8 5c 80 00       	push   $0x805cf8
  800961:	e8 cc 11 00 00       	call   801b32 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 79 3a 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 68 5d 80 00       	push   $0x805d68
  800982:	e8 ab 11 00 00       	call   801b32 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 0d 3a 00 00       	call   80439c <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 50 3a 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800997:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  80099a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80099d:	89 d0                	mov    %edx,%eax
  80099f:	01 c0                	add    %eax,%eax
  8009a1:	01 d0                	add    %edx,%eax
  8009a3:	01 c0                	add    %eax,%eax
  8009a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009a8:	83 ec 0c             	sub    $0xc,%esp
  8009ab:	50                   	push   %eax
  8009ac:	e8 43 21 00 00       	call   802af4 <malloc>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) { is_correct = 0; cprintf("7 Wrong start address for the allocated space... \n");}
  8009ba:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8009c0:	89 c1                	mov    %eax,%ecx
  8009c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	01 c0                	add    %eax,%eax
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	01 c0                	add    %eax,%eax
  8009cd:	01 d0                	add    %edx,%eax
  8009cf:	89 c2                	mov    %eax,%edx
  8009d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009d4:	c1 e0 04             	shl    $0x4,%eax
  8009d7:	01 c2                	add    %eax,%edx
  8009d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009dc:	01 d0                	add    %edx,%eax
  8009de:	39 c1                	cmp    %eax,%ecx
  8009e0:	74 17                	je     8009f9 <_main+0x9a0>
  8009e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009e9:	83 ec 0c             	sub    $0xc,%esp
  8009ec:	68 9c 5d 80 00       	push   $0x805d9c
  8009f1:	e8 3c 11 00 00       	call   801b32 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 94 39 00 00       	call   80439c <sys_calculate_free_frames>
  800a08:	29 c3                	sub    %eax,%ebx
  800a0a:	89 d8                	mov    %ebx,%eax
  800a0c:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800a0f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a12:	83 c0 02             	add    $0x2,%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	50                   	push   %eax
  800a19:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a1c:	ff 75 c0             	pushl  -0x40(%ebp)
  800a1f:	e8 14 f6 ff ff       	call   800038 <inRange>
  800a24:	83 c4 10             	add    $0x10,%esp
  800a27:	85 c0                	test   %eax,%eax
  800a29:	75 21                	jne    800a4c <_main+0x9f3>
			{is_correct = 0; cprintf("7 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800a2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a35:	83 c0 02             	add    $0x2,%eax
  800a38:	ff 75 c0             	pushl  -0x40(%ebp)
  800a3b:	50                   	push   %eax
  800a3c:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a3f:	68 d0 5d 80 00       	push   $0x805dd0
  800a44:	e8 e9 10 00 00       	call   801b32 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 96 39 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 40 5e 80 00       	push   $0x805e40
  800a65:	e8 c8 10 00 00       	call   801b32 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 2a 39 00 00       	call   80439c <sys_calculate_free_frames>
  800a72:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a78:	89 d0                	mov    %edx,%eax
  800a7a:	01 c0                	add    %eax,%eax
  800a7c:	01 d0                	add    %edx,%eax
  800a7e:	01 c0                	add    %eax,%eax
  800a80:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800a83:	48                   	dec    %eax
  800a84:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  800a8a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800a90:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			byteArr2[0] = minByte ;
  800a96:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a9c:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  800a9f:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800aa1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800aa7:	89 c2                	mov    %eax,%edx
  800aa9:	c1 ea 1f             	shr    $0x1f,%edx
  800aac:	01 d0                	add    %edx,%eax
  800aae:	d1 f8                	sar    %eax
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ab8:	01 c2                	add    %eax,%edx
  800aba:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800abd:	88 c1                	mov    %al,%cl
  800abf:	c0 e9 07             	shr    $0x7,%cl
  800ac2:	01 c8                	add    %ecx,%eax
  800ac4:	d0 f8                	sar    %al
  800ac6:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800ac8:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800ace:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ad4:	01 c2                	add    %eax,%edx
  800ad6:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800ad9:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 ;
  800adb:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800ae2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800ae5:	e8 b2 38 00 00       	call   80439c <sys_calculate_free_frames>
  800aea:	29 c3                	sub    %eax,%ebx
  800aec:	89 d8                	mov    %ebx,%eax
  800aee:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800af1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800af4:	83 c0 02             	add    $0x2,%eax
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800afe:	ff 75 c0             	pushl  -0x40(%ebp)
  800b01:	e8 32 f5 ff ff       	call   800038 <inRange>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	85 c0                	test   %eax,%eax
  800b0b:	75 1d                	jne    800b2a <_main+0xad1>
			{ is_correct = 0; cprintf("7 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800b0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b14:	83 ec 04             	sub    $0x4,%esp
  800b17:	ff 75 c0             	pushl  -0x40(%ebp)
  800b1a:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b1d:	68 74 5e 80 00       	push   $0x805e74
  800b22:	e8 0b 10 00 00       	call   801b32 <cprintf>
  800b27:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800b2a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b30:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800b36:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b41:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
  800b47:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	c1 ea 1f             	shr    $0x1f,%edx
  800b52:	01 d0                	add    %edx,%eax
  800b54:	d1 f8                	sar    %eax
  800b56:	89 c2                	mov    %eax,%edx
  800b58:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800b66:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b71:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
  800b77:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800b7d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b83:	01 d0                	add    %edx,%eax
  800b85:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800b8b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b96:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800b9c:	6a 02                	push   $0x2
  800b9e:	6a 00                	push   $0x0
  800ba0:	6a 03                	push   $0x3
  800ba2:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 b0 3b 00 00       	call   80475e <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 f4 5e 80 00       	push   $0x805ef4
  800bc9:	e8 64 0f 00 00       	call   801b32 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 c6 37 00 00       	call   80439c <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 09 38 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800be4:	89 d0                	mov    %edx,%eax
  800be6:	01 c0                	add    %eax,%eax
  800be8:	01 d0                	add    %edx,%eax
  800bea:	01 c0                	add    %eax,%eax
  800bec:	01 d0                	add    %edx,%eax
  800bee:	01 c0                	add    %eax,%eax
  800bf0:	83 ec 0c             	sub    $0xc,%esp
  800bf3:	50                   	push   %eax
  800bf4:	e8 fb 1e 00 00       	call   802af4 <malloc>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) { is_correct = 0; cprintf("8 Wrong start address for the allocated space... \n");}
  800c02:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800c08:	89 c1                	mov    %eax,%ecx
  800c0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c0d:	89 d0                	mov    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	01 d0                	add    %edx,%eax
  800c18:	89 c2                	mov    %eax,%edx
  800c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c1d:	c1 e0 04             	shl    $0x4,%eax
  800c20:	01 c2                	add    %eax,%edx
  800c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c25:	01 d0                	add    %edx,%eax
  800c27:	39 c1                	cmp    %eax,%ecx
  800c29:	74 17                	je     800c42 <_main+0xbe9>
  800c2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	68 18 5f 80 00       	push   $0x805f18
  800c3a:	e8 f3 0e 00 00       	call   801b32 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 4b 37 00 00       	call   80439c <sys_calculate_free_frames>
  800c51:	29 c3                	sub    %eax,%ebx
  800c53:	89 d8                	mov    %ebx,%eax
  800c55:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800c58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c5b:	83 c0 02             	add    $0x2,%eax
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	50                   	push   %eax
  800c62:	ff 75 c4             	pushl  -0x3c(%ebp)
  800c65:	ff 75 c0             	pushl  -0x40(%ebp)
  800c68:	e8 cb f3 ff ff       	call   800038 <inRange>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	85 c0                	test   %eax,%eax
  800c72:	75 21                	jne    800c95 <_main+0xc3c>
			{is_correct = 0; cprintf("8 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c7b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c7e:	83 c0 02             	add    $0x2,%eax
  800c81:	ff 75 c0             	pushl  -0x40(%ebp)
  800c84:	50                   	push   %eax
  800c85:	ff 75 c4             	pushl  -0x3c(%ebp)
  800c88:	68 4c 5f 80 00       	push   $0x805f4c
  800c8d:	e8 a0 0e 00 00       	call   801b32 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 4d 37 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 bc 5f 80 00       	push   $0x805fbc
  800cae:	e8 7f 0e 00 00       	call   801b32 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 e1 36 00 00       	call   80439c <sys_calculate_free_frames>
  800cbb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800cbe:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800cc4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ccd:	89 d0                	mov    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	01 d0                	add    %edx,%eax
  800cd7:	01 c0                	add    %eax,%eax
  800cd9:	d1 e8                	shr    %eax
  800cdb:	48                   	dec    %eax
  800cdc:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			shortArr2[0] = minShort;
  800ce2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ceb:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800cee:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800cf4:	89 c2                	mov    %eax,%edx
  800cf6:	c1 ea 1f             	shr    $0x1f,%edx
  800cf9:	01 d0                	add    %edx,%eax
  800cfb:	d1 f8                	sar    %eax
  800cfd:	01 c0                	add    %eax,%eax
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d07:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800d0a:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	66 c1 ea 0f          	shr    $0xf,%dx
  800d14:	01 d0                	add    %edx,%eax
  800d16:	66 d1 f8             	sar    %ax
  800d19:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800d1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d22:	01 c0                	add    %eax,%eax
  800d24:	89 c2                	mov    %eax,%edx
  800d26:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d2c:	01 c2                	add    %eax,%edx
  800d2e:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d32:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800d35:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800d3c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800d3f:	e8 58 36 00 00       	call   80439c <sys_calculate_free_frames>
  800d44:	29 c3                	sub    %eax,%ebx
  800d46:	89 d8                	mov    %ebx,%eax
  800d48:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800d4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d4e:	83 c0 02             	add    $0x2,%eax
  800d51:	83 ec 04             	sub    $0x4,%esp
  800d54:	50                   	push   %eax
  800d55:	ff 75 c4             	pushl  -0x3c(%ebp)
  800d58:	ff 75 c0             	pushl  -0x40(%ebp)
  800d5b:	e8 d8 f2 ff ff       	call   800038 <inRange>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 1d                	jne    800d84 <_main+0xd2b>
			{ is_correct = 0; cprintf("8 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800d67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d6e:	83 ec 04             	sub    $0x4,%esp
  800d71:	ff 75 c0             	pushl  -0x40(%ebp)
  800d74:	ff 75 c4             	pushl  -0x3c(%ebp)
  800d77:	68 f0 5f 80 00       	push   $0x805ff0
  800d7c:	e8 b1 0d 00 00       	call   801b32 <cprintf>
  800d81:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800d84:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d8a:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800d90:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800d96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d9b:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
  800da1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800da7:	89 c2                	mov    %eax,%edx
  800da9:	c1 ea 1f             	shr    $0x1f,%edx
  800dac:	01 d0                	add    %edx,%eax
  800dae:	d1 f8                	sar    %eax
  800db0:	01 c0                	add    %eax,%eax
  800db2:	89 c2                	mov    %eax,%edx
  800db4:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800dba:	01 d0                	add    %edx,%eax
  800dbc:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800dc2:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800dc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcd:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
  800dd3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800dd9:	01 c0                	add    %eax,%eax
  800ddb:	89 c2                	mov    %eax,%edx
  800ddd:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800deb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800df1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800df6:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800dfc:	6a 02                	push   $0x2
  800dfe:	6a 00                	push   $0x0
  800e00:	6a 03                	push   $0x3
  800e02:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	e8 50 39 00 00       	call   80475e <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 70 60 80 00       	push   $0x806070
  800e29:	e8 04 0d 00 00       	call   801b32 <cprintf>
  800e2e:	83 c4 10             	add    $0x10,%esp
		}
	}
	uint32 pagealloc_end = pagealloc_start + 13*Mega + 32*kilo ;
  800e31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e34:	89 d0                	mov    %edx,%eax
  800e36:	01 c0                	add    %eax,%eax
  800e38:	01 d0                	add    %edx,%eax
  800e3a:	c1 e0 02             	shl    $0x2,%eax
  800e3d:	01 d0                	add    %edx,%eax
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e44:	c1 e0 05             	shl    $0x5,%eax
  800e47:	01 c2                	add    %eax,%edx
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	01 d0                	add    %edx,%eax
  800e4e:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)


	is_correct = 1;
  800e54:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//FREE ALL
	cprintf("\n%~[2] Free all the allocated spaces from PAGE ALLOCATOR \[70%]\n");
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	68 94 60 80 00       	push   $0x806094
  800e63:	e8 ca 0c 00 00       	call   801b32 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 2c 35 00 00       	call   80439c <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 6f 35 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 ca 1f 00 00       	call   802e54 <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 55 35 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 d4 60 80 00       	push   $0x8060d4
  800ea6:	e8 87 0c 00 00       	call   801b32 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 e9 34 00 00       	call   80439c <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 14 61 80 00       	push   $0x806114
  800ed0:	e8 5d 0c 00 00       	call   801b32 <cprintf>
  800ed5:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800ed8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800edb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800ee1:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800ee7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eec:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
  800ef2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ef5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ef8:	01 d0                	add    %edx,%eax
  800efa:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800f00:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800f06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f0b:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800f11:	6a 03                	push   $0x3
  800f13:	6a 00                	push   $0x0
  800f15:	6a 02                	push   $0x2
  800f17:	8d 85 7c fe ff ff    	lea    -0x184(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	e8 3b 38 00 00       	call   80475e <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 64 61 80 00       	push   $0x806164
  800f44:	e8 e9 0b 00 00       	call   801b32 <cprintf>
  800f49:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800f4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f50:	74 04                	je     800f56 <_main+0xefd>
		{
			eval += 10;
  800f52:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  800f56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 2nd 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800f5d:	e8 3a 34 00 00       	call   80439c <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 7d 34 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 d8 1e 00 00       	call   802e54 <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 63 34 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 8c 61 80 00       	push   $0x80618c
  800f98:	e8 95 0b 00 00       	call   801b32 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 f7 33 00 00       	call   80439c <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 cc 61 80 00       	push   $0x8061cc
  800fc2:	e8 6b 0b 00 00       	call   801b32 <cprintf>
  800fc7:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800fca:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800fcd:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800fd3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800fd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fde:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
  800fe4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800fe7:	01 c0                	add    %eax,%eax
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ff6:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ffc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801001:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  801007:	6a 03                	push   $0x3
  801009:	6a 00                	push   $0x0
  80100b:	6a 02                	push   $0x2
  80100d:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  801013:	50                   	push   %eax
  801014:	e8 45 37 00 00       	call   80475e <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 1c 62 80 00       	push   $0x80621c
  80103a:	e8 f3 0a 00 00       	call   801b32 <cprintf>
  80103f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801046:	74 04                	je     80104c <_main+0xff3>
		{
			eval += 10;
  801048:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80104c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  801053:	e8 44 33 00 00       	call   80439c <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 87 33 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 e2 1d 00 00       	call   802e54 <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 6d 33 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 44 62 80 00       	push   $0x806244
  80108e:	e8 9f 0a 00 00       	call   801b32 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 01 33 00 00       	call   80439c <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 84 62 80 00       	push   $0x806284
  8010b8:	e8 75 0a 00 00       	call   801b32 <cprintf>
  8010bd:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  8010c0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8010c6:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  8010cc:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8010d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d7:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
  8010dd:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 1f             	shr    $0x1f,%edx
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	d1 f8                	sar    %eax
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8010f4:	01 d0                	add    %edx,%eax
  8010f6:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  8010fc:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  801102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801107:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
  80110d:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  801113:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801119:	01 d0                	add    %edx,%eax
  80111b:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  801121:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801127:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112c:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801132:	6a 03                	push   $0x3
  801134:	6a 00                	push   $0x0
  801136:	6a 03                	push   $0x3
  801138:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	e8 1a 36 00 00       	call   80475e <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 d4 62 80 00       	push   $0x8062d4
  801165:	e8 c8 09 00 00       	call   801b32 <cprintf>
  80116a:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  80116d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801171:	74 04                	je     801177 <_main+0x111e>
		{
			eval += 10;
  801173:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  801177:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80117e:	e8 19 32 00 00       	call   80439c <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 5c 32 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 b7 1c 00 00       	call   802e54 <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 42 32 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 fc 62 80 00       	push   $0x8062fc
  8011b9:	e8 74 09 00 00       	call   801b32 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 d6 31 00 00       	call   80439c <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 3c 63 80 00       	push   $0x80633c
  8011e3:	e8 4a 09 00 00       	call   801b32 <cprintf>
  8011e8:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  8011eb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8011ee:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  8011f4:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ff:	89 85 60 fe ff ff    	mov    %eax,-0x1a0(%ebp)
  801205:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801208:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80120f:	8b 45 88             	mov    -0x78(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  80121a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801220:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801225:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  80122b:	6a 03                	push   $0x3
  80122d:	6a 00                	push   $0x0
  80122f:	6a 02                	push   $0x2
  801231:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	e8 21 35 00 00       	call   80475e <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 8c 63 80 00       	push   $0x80638c
  80125e:	e8 cf 08 00 00       	call   801b32 <cprintf>
  801263:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 04                	je     801270 <_main+0x1217>
		{
			eval += 10;
  80126c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  801270:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  801277:	e8 20 31 00 00       	call   80439c <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 63 31 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 be 1b 00 00       	call   802e54 <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 49 31 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 b4 63 80 00       	push   $0x8063b4
  8012b2:	e8 7b 08 00 00       	call   801b32 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 dd 30 00 00       	call   80439c <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 f4 63 80 00       	push   $0x8063f4
  8012d7:	e8 56 08 00 00       	call   801b32 <cprintf>
  8012dc:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8012df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e3:	74 04                	je     8012e9 <_main+0x1290>
		{
			eval += 5;
  8012e5:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}

		is_correct = 1;
  8012e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 1st 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8012f0:	e8 a7 30 00 00       	call   80439c <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 ea 30 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 45 1b 00 00       	call   802e54 <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 d0 30 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 38 64 80 00       	push   $0x806438
  80132b:	e8 02 08 00 00       	call   801b32 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 64 30 00 00       	call   80439c <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 78 64 80 00       	push   $0x806478
  801355:	e8 d8 07 00 00       	call   801b32 <cprintf>
  80135a:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  80135d:	8b 45 98             	mov    -0x68(%ebp),%eax
  801360:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801366:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80136c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801371:	89 85 58 fe ff ff    	mov    %eax,-0x1a8(%ebp)
  801377:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80137a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801381:	8b 45 98             	mov    -0x68(%ebp),%eax
  801384:	01 d0                	add    %edx,%eax
  801386:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80138c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801397:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  80139d:	6a 03                	push   $0x3
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 02                	push   $0x2
  8013a3:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	e8 af 33 00 00       	call   80475e <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 c8 64 80 00       	push   $0x8064c8
  8013d0:	e8 5d 07 00 00       	call   801b32 <cprintf>
  8013d5:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8013d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013dc:	74 04                	je     8013e2 <_main+0x1389>
		{
			eval += 10;
  8013de:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8013e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 2nd 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8013e9:	e8 ae 2f 00 00       	call   80439c <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 f1 2f 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 4c 1a 00 00       	call   802e54 <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 d7 2f 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 f0 64 80 00       	push   $0x8064f0
  801424:	e8 09 07 00 00       	call   801b32 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 6b 2f 00 00       	call   80439c <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 30 65 80 00       	push   $0x806530
  801449:	e8 e4 06 00 00       	call   801b32 <cprintf>
  80144e:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 04                	je     80145b <_main+0x1402>
		{
			eval += 5;
  801457:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}

		is_correct = 1;
  80145b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free last 14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  801462:	e8 35 2f 00 00       	call   80439c <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 78 2f 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 d3 19 00 00       	call   802e54 <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 5e 2f 00 00       	call   8043e7 <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 80 65 80 00       	push   $0x806580
  80149d:	e8 90 06 00 00       	call   801b32 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 f2 2e 00 00       	call   80439c <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 c0 65 80 00       	push   $0x8065c0
  8014c7:	e8 66 06 00 00       	call   801b32 <cprintf>
  8014cc:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  8014cf:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8014d5:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  8014db:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  8014e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e6:	89 85 4c fe ff ff    	mov    %eax,-0x1b4(%ebp)
  8014ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	c1 ea 1f             	shr    $0x1f,%edx
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	d1 f8                	sar    %eax
  8014fb:	01 c0                	add    %eax,%eax
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  80150d:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  801513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801518:	89 85 50 fe ff ff    	mov    %eax,-0x1b0(%ebp)
  80151e:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801524:	01 c0                	add    %eax,%eax
  801526:	89 c2                	mov    %eax,%edx
  801528:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  801536:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80153c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801541:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801547:	6a 03                	push   $0x3
  801549:	6a 00                	push   $0x0
  80154b:	6a 03                	push   $0x3
  80154d:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	e8 05 32 00 00       	call   80475e <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 10 66 80 00       	push   $0x806610
  80157a:	e8 b3 05 00 00       	call   801b32 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801582:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801586:	74 04                	je     80158c <_main+0x1533>
		{
			eval += 10;
  801588:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80158c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	is_correct = 1;
  801593:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	cprintf("\n%~[3] Test accessing a freed area (processes should be killed by the validation of the fault handler) [30%]\n");
  80159a:	83 ec 0c             	sub    $0xc,%esp
  80159d:	68 38 66 80 00       	push   $0x806638
  8015a2:	e8 8b 05 00 00       	call   801b32 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 94 30 00 00       	call   804643 <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8015af:	a1 20 80 80 00       	mov    0x808020,%eax
  8015b4:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8015ba:	a1 20 80 80 00       	mov    0x808020,%eax
  8015bf:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8015c5:	89 c1                	mov    %eax,%ecx
  8015c7:	a1 20 80 80 00       	mov    0x808020,%eax
  8015cc:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8015d2:	52                   	push   %edx
  8015d3:	51                   	push   %ecx
  8015d4:	50                   	push   %eax
  8015d5:	68 a6 66 80 00       	push   $0x8066a6
  8015da:	e8 18 2f 00 00       	call   8044f7 <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 1f 2f 00 00       	call   804515 <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 be 30 00 00       	call   8046bd <gettst>
  8015ff:	83 f8 01             	cmp    $0x1,%eax
  801602:	75 f6                	jne    8015fa <_main+0x15a1>

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801604:	a1 20 80 80 00       	mov    0x808020,%eax
  801609:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80160f:	a1 20 80 80 00       	mov    0x808020,%eax
  801614:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80161a:	89 c1                	mov    %eax,%ecx
  80161c:	a1 20 80 80 00       	mov    0x808020,%eax
  801621:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801627:	52                   	push   %edx
  801628:	51                   	push   %ecx
  801629:	50                   	push   %eax
  80162a:	68 b1 66 80 00       	push   $0x8066b1
  80162f:	e8 c3 2e 00 00       	call   8044f7 <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 ca 2e 00 00       	call   804515 <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 69 30 00 00       	call   8046bd <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 45 30 00 00       	call   8046a3 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 51 3c 00 00       	call   8052bc <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 4a 30 00 00       	call   8046bd <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 bc 66 80 00       	push   $0x8066bc
  801687:	e8 a6 04 00 00       	call   801b32 <cprintf>
  80168c:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  80168f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801693:	74 04                	je     801699 <_main+0x1640>
	{
		eval += 30;
  801695:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf("%~\ntest free [1] [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 f4             	pushl  -0xc(%ebp)
  80169f:	68 4c 67 80 00       	push   $0x80674c
  8016a4:	e8 89 04 00 00       	call   801b32 <cprintf>
  8016a9:	83 c4 10             	add    $0x10,%esp

	return;
  8016ac:	90                   	nop
}
  8016ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5f                   	pop    %edi
  8016b2:	5d                   	pop    %ebp
  8016b3:	c3                   	ret    

008016b4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	57                   	push   %edi
  8016b8:	56                   	push   %esi
  8016b9:	53                   	push   %ebx
  8016ba:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8016bd:	e8 a3 2e 00 00       	call   804565 <sys_getenvindex>
  8016c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8016c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016c8:	89 d0                	mov    %edx,%eax
  8016ca:	c1 e0 03             	shl    $0x3,%eax
  8016cd:	01 d0                	add    %edx,%eax
  8016cf:	c1 e0 02             	shl    $0x2,%eax
  8016d2:	01 d0                	add    %edx,%eax
  8016d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016db:	01 d0                	add    %edx,%eax
  8016dd:	c1 e0 03             	shl    $0x3,%eax
  8016e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016e5:	a3 20 80 80 00       	mov    %eax,0x808020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8016ea:	a1 20 80 80 00       	mov    0x808020,%eax
  8016ef:	8a 40 20             	mov    0x20(%eax),%al
  8016f2:	84 c0                	test   %al,%al
  8016f4:	74 0d                	je     801703 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8016f6:	a1 20 80 80 00       	mov    0x808020,%eax
  8016fb:	83 c0 20             	add    $0x20,%eax
  8016fe:	a3 04 80 80 00       	mov    %eax,0x808004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801703:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801707:	7e 0a                	jle    801713 <libmain+0x5f>
		binaryname = argv[0];
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	a3 04 80 80 00       	mov    %eax,0x808004

	// call user main routine
	_main(argc, argv);
  801713:	83 ec 08             	sub    $0x8,%esp
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	e8 38 e9 ff ff       	call   800059 <_main>
  801721:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801724:	a1 00 80 80 00       	mov    0x808000,%eax
  801729:	85 c0                	test   %eax,%eax
  80172b:	0f 84 01 01 00 00    	je     801832 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801731:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801737:	bb 80 68 80 00       	mov    $0x806880,%ebx
  80173c:	ba 0e 00 00 00       	mov    $0xe,%edx
  801741:	89 c7                	mov    %eax,%edi
  801743:	89 de                	mov    %ebx,%esi
  801745:	89 d1                	mov    %edx,%ecx
  801747:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801749:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80174c:	b9 56 00 00 00       	mov    $0x56,%ecx
  801751:	b0 00                	mov    $0x0,%al
  801753:	89 d7                	mov    %edx,%edi
  801755:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801757:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80175e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	50                   	push   %eax
  801765:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80176b:	50                   	push   %eax
  80176c:	e8 2a 30 00 00       	call   80479b <sys_utilities>
  801771:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801774:	e8 73 2b 00 00       	call   8042ec <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	68 a0 67 80 00       	push   $0x8067a0
  801781:	e8 ac 03 00 00       	call   801b32 <cprintf>
  801786:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801789:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80178c:	85 c0                	test   %eax,%eax
  80178e:	74 18                	je     8017a8 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801790:	e8 24 30 00 00       	call   8047b9 <sys_get_optimal_num_faults>
  801795:	83 ec 08             	sub    $0x8,%esp
  801798:	50                   	push   %eax
  801799:	68 c8 67 80 00       	push   $0x8067c8
  80179e:	e8 8f 03 00 00       	call   801b32 <cprintf>
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	eb 59                	jmp    801801 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8017a8:	a1 20 80 80 00       	mov    0x808020,%eax
  8017ad:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8017b3:	a1 20 80 80 00       	mov    0x808020,%eax
  8017b8:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	52                   	push   %edx
  8017c2:	50                   	push   %eax
  8017c3:	68 ec 67 80 00       	push   $0x8067ec
  8017c8:	e8 65 03 00 00       	call   801b32 <cprintf>
  8017cd:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8017d0:	a1 20 80 80 00       	mov    0x808020,%eax
  8017d5:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8017db:	a1 20 80 80 00       	mov    0x808020,%eax
  8017e0:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8017e6:	a1 20 80 80 00       	mov    0x808020,%eax
  8017eb:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8017f1:	51                   	push   %ecx
  8017f2:	52                   	push   %edx
  8017f3:	50                   	push   %eax
  8017f4:	68 14 68 80 00       	push   $0x806814
  8017f9:	e8 34 03 00 00       	call   801b32 <cprintf>
  8017fe:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801801:	a1 20 80 80 00       	mov    0x808020,%eax
  801806:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80180c:	83 ec 08             	sub    $0x8,%esp
  80180f:	50                   	push   %eax
  801810:	68 6c 68 80 00       	push   $0x80686c
  801815:	e8 18 03 00 00       	call   801b32 <cprintf>
  80181a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	68 a0 67 80 00       	push   $0x8067a0
  801825:	e8 08 03 00 00       	call   801b32 <cprintf>
  80182a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80182d:	e8 d4 2a 00 00       	call   804306 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801832:	e8 1f 00 00 00       	call   801856 <exit>
}
  801837:	90                   	nop
  801838:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5f                   	pop    %edi
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	6a 00                	push   $0x0
  80184b:	e8 e1 2c 00 00       	call   804531 <sys_destroy_env>
  801850:	83 c4 10             	add    $0x10,%esp
}
  801853:	90                   	nop
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <exit>:

void
exit(void)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80185c:	e8 36 2d 00 00       	call   804597 <sys_exit_env>
}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80186a:	8d 45 10             	lea    0x10(%ebp),%eax
  80186d:	83 c0 04             	add    $0x4,%eax
  801870:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801873:	a1 38 81 83 00       	mov    0x838138,%eax
  801878:	85 c0                	test   %eax,%eax
  80187a:	74 16                	je     801892 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80187c:	a1 38 81 83 00       	mov    0x838138,%eax
  801881:	83 ec 08             	sub    $0x8,%esp
  801884:	50                   	push   %eax
  801885:	68 e4 68 80 00       	push   $0x8068e4
  80188a:	e8 a3 02 00 00       	call   801b32 <cprintf>
  80188f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801892:	a1 04 80 80 00       	mov    0x808004,%eax
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	50                   	push   %eax
  8018a1:	68 ec 68 80 00       	push   $0x8068ec
  8018a6:	6a 74                	push   $0x74
  8018a8:	e8 b2 02 00 00       	call   801b5f <cprintf_colored>
  8018ad:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8018b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b3:	83 ec 08             	sub    $0x8,%esp
  8018b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b9:	50                   	push   %eax
  8018ba:	e8 04 02 00 00       	call   801ac3 <vcprintf>
  8018bf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	6a 00                	push   $0x0
  8018c7:	68 14 69 80 00       	push   $0x806914
  8018cc:	e8 f2 01 00 00       	call   801ac3 <vcprintf>
  8018d1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018d4:	e8 7d ff ff ff       	call   801856 <exit>

	// should not return here
	while (1) ;
  8018d9:	eb fe                	jmp    8018d9 <_panic+0x75>

008018db <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018e1:	a1 20 80 80 00       	mov    0x808020,%eax
  8018e6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ef:	39 c2                	cmp    %eax,%edx
  8018f1:	74 14                	je     801907 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	68 18 69 80 00       	push   $0x806918
  8018fb:	6a 26                	push   $0x26
  8018fd:	68 64 69 80 00       	push   $0x806964
  801902:	e8 5d ff ff ff       	call   801864 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80190e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801915:	e9 c5 00 00 00       	jmp    8019df <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80191a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	01 d0                	add    %edx,%eax
  801929:	8b 00                	mov    (%eax),%eax
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 08                	jne    801937 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80192f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801932:	e9 a5 00 00 00       	jmp    8019dc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801937:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80193e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801945:	eb 69                	jmp    8019b0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801947:	a1 20 80 80 00       	mov    0x808020,%eax
  80194c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801952:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801955:	89 d0                	mov    %edx,%eax
  801957:	01 c0                	add    %eax,%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	c1 e0 03             	shl    $0x3,%eax
  80195e:	01 c8                	add    %ecx,%eax
  801960:	8a 40 04             	mov    0x4(%eax),%al
  801963:	84 c0                	test   %al,%al
  801965:	75 46                	jne    8019ad <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801967:	a1 20 80 80 00       	mov    0x808020,%eax
  80196c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801972:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801975:	89 d0                	mov    %edx,%eax
  801977:	01 c0                	add    %eax,%eax
  801979:	01 d0                	add    %edx,%eax
  80197b:	c1 e0 03             	shl    $0x3,%eax
  80197e:	01 c8                	add    %ecx,%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801985:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801988:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80198d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801992:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	01 c8                	add    %ecx,%eax
  80199e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019a0:	39 c2                	cmp    %eax,%edx
  8019a2:	75 09                	jne    8019ad <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8019a4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019ab:	eb 15                	jmp    8019c2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019ad:	ff 45 e8             	incl   -0x18(%ebp)
  8019b0:	a1 20 80 80 00       	mov    0x808020,%eax
  8019b5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019be:	39 c2                	cmp    %eax,%edx
  8019c0:	77 85                	ja     801947 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019c6:	75 14                	jne    8019dc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8019c8:	83 ec 04             	sub    $0x4,%esp
  8019cb:	68 70 69 80 00       	push   $0x806970
  8019d0:	6a 3a                	push   $0x3a
  8019d2:	68 64 69 80 00       	push   $0x806964
  8019d7:	e8 88 fe ff ff       	call   801864 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019dc:	ff 45 f0             	incl   -0x10(%ebp)
  8019df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019e5:	0f 8c 2f ff ff ff    	jl     80191a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019f9:	eb 26                	jmp    801a21 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8019fb:	a1 20 80 80 00       	mov    0x808020,%eax
  801a00:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801a06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a09:	89 d0                	mov    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	01 d0                	add    %edx,%eax
  801a0f:	c1 e0 03             	shl    $0x3,%eax
  801a12:	01 c8                	add    %ecx,%eax
  801a14:	8a 40 04             	mov    0x4(%eax),%al
  801a17:	3c 01                	cmp    $0x1,%al
  801a19:	75 03                	jne    801a1e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a1b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a1e:	ff 45 e0             	incl   -0x20(%ebp)
  801a21:	a1 20 80 80 00       	mov    0x808020,%eax
  801a26:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a2f:	39 c2                	cmp    %eax,%edx
  801a31:	77 c8                	ja     8019fb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a36:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a39:	74 14                	je     801a4f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	68 c4 69 80 00       	push   $0x8069c4
  801a43:	6a 44                	push   $0x44
  801a45:	68 64 69 80 00       	push   $0x806964
  801a4a:	e8 15 fe ff ff       	call   801864 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a4f:	90                   	nop
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	53                   	push   %ebx
  801a56:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5c:	8b 00                	mov    (%eax),%eax
  801a5e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	89 0a                	mov    %ecx,(%edx)
  801a66:	8b 55 08             	mov    0x8(%ebp),%edx
  801a69:	88 d1                	mov    %dl,%cl
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	8b 00                	mov    (%eax),%eax
  801a77:	3d ff 00 00 00       	cmp    $0xff,%eax
  801a7c:	75 30                	jne    801aae <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801a7e:	8b 15 3c 81 83 00    	mov    0x83813c,%edx
  801a84:	a0 64 00 82 00       	mov    0x820064,%al
  801a89:	0f b6 c0             	movzbl %al,%eax
  801a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8f:	8b 09                	mov    (%ecx),%ecx
  801a91:	89 cb                	mov    %ecx,%ebx
  801a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a96:	83 c1 08             	add    $0x8,%ecx
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	53                   	push   %ebx
  801a9c:	51                   	push   %ecx
  801a9d:	e8 06 28 00 00       	call   8042a8 <sys_cputs>
  801aa2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab1:	8b 40 04             	mov    0x4(%eax),%eax
  801ab4:	8d 50 01             	lea    0x1(%eax),%edx
  801ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aba:	89 50 04             	mov    %edx,0x4(%eax)
}
  801abd:	90                   	nop
  801abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801acc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ad3:	00 00 00 
	b.cnt = 0;
  801ad6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801add:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801aec:	50                   	push   %eax
  801aed:	68 52 1a 80 00       	push   $0x801a52
  801af2:	e8 5a 02 00 00       	call   801d51 <vprintfmt>
  801af7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801afa:	8b 15 3c 81 83 00    	mov    0x83813c,%edx
  801b00:	a0 64 00 82 00       	mov    0x820064,%al
  801b05:	0f b6 c0             	movzbl %al,%eax
  801b08:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	51                   	push   %ecx
  801b11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801b17:	83 c0 08             	add    $0x8,%eax
  801b1a:	50                   	push   %eax
  801b1b:	e8 88 27 00 00       	call   8042a8 <sys_cputs>
  801b20:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801b23:	c6 05 64 00 82 00 00 	movb   $0x0,0x820064
	return b.cnt;
  801b2a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801b38:	c6 05 64 00 82 00 01 	movb   $0x1,0x820064
	va_start(ap, fmt);
  801b3f:	8d 45 0c             	lea    0xc(%ebp),%eax
  801b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	83 ec 08             	sub    $0x8,%esp
  801b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4e:	50                   	push   %eax
  801b4f:	e8 6f ff ff ff       	call   801ac3 <vcprintf>
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801b65:	c6 05 64 00 82 00 01 	movb   $0x1,0x820064
	curTextClr = (textClr << 8) ; //set text color by the given value
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	c1 e0 08             	shl    $0x8,%eax
  801b72:	a3 3c 81 83 00       	mov    %eax,0x83813c
	va_start(ap, fmt);
  801b77:	8d 45 0c             	lea    0xc(%ebp),%eax
  801b7a:	83 c0 04             	add    $0x4,%eax
  801b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	ff 75 f4             	pushl  -0xc(%ebp)
  801b89:	50                   	push   %eax
  801b8a:	e8 34 ff ff ff       	call   801ac3 <vcprintf>
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801b95:	c7 05 3c 81 83 00 00 	movl   $0x700,0x83813c
  801b9c:	07 00 00 

	return cnt;
  801b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801baa:	e8 3d 27 00 00       	call   8042ec <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801baf:	8d 45 0c             	lea    0xc(%ebp),%eax
  801bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	e8 ff fe ff ff       	call   801ac3 <vcprintf>
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801bca:	e8 37 27 00 00       	call   804306 <sys_unlock_cons>
	return cnt;
  801bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	53                   	push   %ebx
  801bd8:	83 ec 14             	sub    $0x14,%esp
  801bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801be1:	8b 45 14             	mov    0x14(%ebp),%eax
  801be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801be7:	8b 45 18             	mov    0x18(%ebp),%eax
  801bea:	ba 00 00 00 00       	mov    $0x0,%edx
  801bef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801bf2:	77 55                	ja     801c49 <printnum+0x75>
  801bf4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801bf7:	72 05                	jb     801bfe <printnum+0x2a>
  801bf9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bfc:	77 4b                	ja     801c49 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801bfe:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801c01:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c04:	8b 45 18             	mov    0x18(%ebp),%eax
  801c07:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0c:	52                   	push   %edx
  801c0d:	50                   	push   %eax
  801c0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c11:	ff 75 f0             	pushl  -0x10(%ebp)
  801c14:	e8 63 37 00 00       	call   80537c <__udivdi3>
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	83 ec 04             	sub    $0x4,%esp
  801c1f:	ff 75 20             	pushl  0x20(%ebp)
  801c22:	53                   	push   %ebx
  801c23:	ff 75 18             	pushl  0x18(%ebp)
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	ff 75 0c             	pushl  0xc(%ebp)
  801c2b:	ff 75 08             	pushl  0x8(%ebp)
  801c2e:	e8 a1 ff ff ff       	call   801bd4 <printnum>
  801c33:	83 c4 20             	add    $0x20,%esp
  801c36:	eb 1a                	jmp    801c52 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c38:	83 ec 08             	sub    $0x8,%esp
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	ff 75 20             	pushl  0x20(%ebp)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	ff d0                	call   *%eax
  801c46:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801c49:	ff 4d 1c             	decl   0x1c(%ebp)
  801c4c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801c50:	7f e6                	jg     801c38 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801c52:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801c55:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c60:	53                   	push   %ebx
  801c61:	51                   	push   %ecx
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	e8 23 38 00 00       	call   80548c <__umoddi3>
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	05 34 6c 80 00       	add    $0x806c34,%eax
  801c71:	8a 00                	mov    (%eax),%al
  801c73:	0f be c0             	movsbl %al,%eax
  801c76:	83 ec 08             	sub    $0x8,%esp
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	50                   	push   %eax
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	ff d0                	call   *%eax
  801c82:	83 c4 10             	add    $0x10,%esp
}
  801c85:	90                   	nop
  801c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c8e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c92:	7e 1c                	jle    801cb0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	8b 00                	mov    (%eax),%eax
  801c99:	8d 50 08             	lea    0x8(%eax),%edx
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	89 10                	mov    %edx,(%eax)
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	8b 00                	mov    (%eax),%eax
  801ca6:	83 e8 08             	sub    $0x8,%eax
  801ca9:	8b 50 04             	mov    0x4(%eax),%edx
  801cac:	8b 00                	mov    (%eax),%eax
  801cae:	eb 40                	jmp    801cf0 <getuint+0x65>
	else if (lflag)
  801cb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cb4:	74 1e                	je     801cd4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	8b 00                	mov    (%eax),%eax
  801cbb:	8d 50 04             	lea    0x4(%eax),%edx
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	89 10                	mov    %edx,(%eax)
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8b 00                	mov    (%eax),%eax
  801cc8:	83 e8 04             	sub    $0x4,%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd2:	eb 1c                	jmp    801cf0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	8b 00                	mov    (%eax),%eax
  801cd9:	8d 50 04             	lea    0x4(%eax),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	89 10                	mov    %edx,(%eax)
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	8b 00                	mov    (%eax),%eax
  801ce6:	83 e8 04             	sub    $0x4,%eax
  801ce9:	8b 00                	mov    (%eax),%eax
  801ceb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    

00801cf2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801cf5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801cf9:	7e 1c                	jle    801d17 <getint+0x25>
		return va_arg(*ap, long long);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	8d 50 08             	lea    0x8(%eax),%edx
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	89 10                	mov    %edx,(%eax)
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	8b 00                	mov    (%eax),%eax
  801d0d:	83 e8 08             	sub    $0x8,%eax
  801d10:	8b 50 04             	mov    0x4(%eax),%edx
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	eb 38                	jmp    801d4f <getint+0x5d>
	else if (lflag)
  801d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d1b:	74 1a                	je     801d37 <getint+0x45>
		return va_arg(*ap, long);
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	8d 50 04             	lea    0x4(%eax),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 10                	mov    %edx,(%eax)
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	83 e8 04             	sub    $0x4,%eax
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	99                   	cltd   
  801d35:	eb 18                	jmp    801d4f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	8b 00                	mov    (%eax),%eax
  801d3c:	8d 50 04             	lea    0x4(%eax),%edx
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	89 10                	mov    %edx,(%eax)
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	8b 00                	mov    (%eax),%eax
  801d49:	83 e8 04             	sub    $0x4,%eax
  801d4c:	8b 00                	mov    (%eax),%eax
  801d4e:	99                   	cltd   
}
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	56                   	push   %esi
  801d55:	53                   	push   %ebx
  801d56:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d59:	eb 17                	jmp    801d72 <vprintfmt+0x21>
			if (ch == '\0')
  801d5b:	85 db                	test   %ebx,%ebx
  801d5d:	0f 84 c1 03 00 00    	je     802124 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	53                   	push   %ebx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	ff d0                	call   *%eax
  801d6f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d72:	8b 45 10             	mov    0x10(%ebp),%eax
  801d75:	8d 50 01             	lea    0x1(%eax),%edx
  801d78:	89 55 10             	mov    %edx,0x10(%ebp)
  801d7b:	8a 00                	mov    (%eax),%al
  801d7d:	0f b6 d8             	movzbl %al,%ebx
  801d80:	83 fb 25             	cmp    $0x25,%ebx
  801d83:	75 d6                	jne    801d5b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801d85:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801d89:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801d90:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d97:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801d9e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801da5:	8b 45 10             	mov    0x10(%ebp),%eax
  801da8:	8d 50 01             	lea    0x1(%eax),%edx
  801dab:	89 55 10             	mov    %edx,0x10(%ebp)
  801dae:	8a 00                	mov    (%eax),%al
  801db0:	0f b6 d8             	movzbl %al,%ebx
  801db3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801db6:	83 f8 5b             	cmp    $0x5b,%eax
  801db9:	0f 87 3d 03 00 00    	ja     8020fc <vprintfmt+0x3ab>
  801dbf:	8b 04 85 58 6c 80 00 	mov    0x806c58(,%eax,4),%eax
  801dc6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801dc8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801dcc:	eb d7                	jmp    801da5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801dce:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801dd2:	eb d1                	jmp    801da5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801dd4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dde:	89 d0                	mov    %edx,%eax
  801de0:	c1 e0 02             	shl    $0x2,%eax
  801de3:	01 d0                	add    %edx,%eax
  801de5:	01 c0                	add    %eax,%eax
  801de7:	01 d8                	add    %ebx,%eax
  801de9:	83 e8 30             	sub    $0x30,%eax
  801dec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801def:	8b 45 10             	mov    0x10(%ebp),%eax
  801df2:	8a 00                	mov    (%eax),%al
  801df4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801df7:	83 fb 2f             	cmp    $0x2f,%ebx
  801dfa:	7e 3e                	jle    801e3a <vprintfmt+0xe9>
  801dfc:	83 fb 39             	cmp    $0x39,%ebx
  801dff:	7f 39                	jg     801e3a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e01:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801e04:	eb d5                	jmp    801ddb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e06:	8b 45 14             	mov    0x14(%ebp),%eax
  801e09:	83 c0 04             	add    $0x4,%eax
  801e0c:	89 45 14             	mov    %eax,0x14(%ebp)
  801e0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e12:	83 e8 04             	sub    $0x4,%eax
  801e15:	8b 00                	mov    (%eax),%eax
  801e17:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801e1a:	eb 1f                	jmp    801e3b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801e1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e20:	79 83                	jns    801da5 <vprintfmt+0x54>
				width = 0;
  801e22:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801e29:	e9 77 ff ff ff       	jmp    801da5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801e2e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801e35:	e9 6b ff ff ff       	jmp    801da5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801e3a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801e3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e3f:	0f 89 60 ff ff ff    	jns    801da5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801e45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e4b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801e52:	e9 4e ff ff ff       	jmp    801da5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801e57:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801e5a:	e9 46 ff ff ff       	jmp    801da5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801e5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e62:	83 c0 04             	add    $0x4,%eax
  801e65:	89 45 14             	mov    %eax,0x14(%ebp)
  801e68:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6b:	83 e8 04             	sub    $0x4,%eax
  801e6e:	8b 00                	mov    (%eax),%eax
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	ff 75 0c             	pushl  0xc(%ebp)
  801e76:	50                   	push   %eax
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	ff d0                	call   *%eax
  801e7c:	83 c4 10             	add    $0x10,%esp
			break;
  801e7f:	e9 9b 02 00 00       	jmp    80211f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801e84:	8b 45 14             	mov    0x14(%ebp),%eax
  801e87:	83 c0 04             	add    $0x4,%eax
  801e8a:	89 45 14             	mov    %eax,0x14(%ebp)
  801e8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e90:	83 e8 04             	sub    $0x4,%eax
  801e93:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801e95:	85 db                	test   %ebx,%ebx
  801e97:	79 02                	jns    801e9b <vprintfmt+0x14a>
				err = -err;
  801e99:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801e9b:	83 fb 64             	cmp    $0x64,%ebx
  801e9e:	7f 0b                	jg     801eab <vprintfmt+0x15a>
  801ea0:	8b 34 9d a0 6a 80 00 	mov    0x806aa0(,%ebx,4),%esi
  801ea7:	85 f6                	test   %esi,%esi
  801ea9:	75 19                	jne    801ec4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801eab:	53                   	push   %ebx
  801eac:	68 45 6c 80 00       	push   $0x806c45
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	ff 75 08             	pushl  0x8(%ebp)
  801eb7:	e8 70 02 00 00       	call   80212c <printfmt>
  801ebc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801ebf:	e9 5b 02 00 00       	jmp    80211f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801ec4:	56                   	push   %esi
  801ec5:	68 4e 6c 80 00       	push   $0x806c4e
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	e8 57 02 00 00       	call   80212c <printfmt>
  801ed5:	83 c4 10             	add    $0x10,%esp
			break;
  801ed8:	e9 42 02 00 00       	jmp    80211f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801edd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee0:	83 c0 04             	add    $0x4,%eax
  801ee3:	89 45 14             	mov    %eax,0x14(%ebp)
  801ee6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee9:	83 e8 04             	sub    $0x4,%eax
  801eec:	8b 30                	mov    (%eax),%esi
  801eee:	85 f6                	test   %esi,%esi
  801ef0:	75 05                	jne    801ef7 <vprintfmt+0x1a6>
				p = "(null)";
  801ef2:	be 51 6c 80 00       	mov    $0x806c51,%esi
			if (width > 0 && padc != '-')
  801ef7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801efb:	7e 6d                	jle    801f6a <vprintfmt+0x219>
  801efd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801f01:	74 67                	je     801f6a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f06:	83 ec 08             	sub    $0x8,%esp
  801f09:	50                   	push   %eax
  801f0a:	56                   	push   %esi
  801f0b:	e8 1e 03 00 00       	call   80222e <strnlen>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801f16:	eb 16                	jmp    801f2e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801f18:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801f1c:	83 ec 08             	sub    $0x8,%esp
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	50                   	push   %eax
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	ff d0                	call   *%eax
  801f28:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801f2b:	ff 4d e4             	decl   -0x1c(%ebp)
  801f2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f32:	7f e4                	jg     801f18 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f34:	eb 34                	jmp    801f6a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801f36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f3a:	74 1c                	je     801f58 <vprintfmt+0x207>
  801f3c:	83 fb 1f             	cmp    $0x1f,%ebx
  801f3f:	7e 05                	jle    801f46 <vprintfmt+0x1f5>
  801f41:	83 fb 7e             	cmp    $0x7e,%ebx
  801f44:	7e 12                	jle    801f58 <vprintfmt+0x207>
					putch('?', putdat);
  801f46:	83 ec 08             	sub    $0x8,%esp
  801f49:	ff 75 0c             	pushl  0xc(%ebp)
  801f4c:	6a 3f                	push   $0x3f
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	ff d0                	call   *%eax
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	eb 0f                	jmp    801f67 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801f58:	83 ec 08             	sub    $0x8,%esp
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	53                   	push   %ebx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	ff d0                	call   *%eax
  801f64:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f67:	ff 4d e4             	decl   -0x1c(%ebp)
  801f6a:	89 f0                	mov    %esi,%eax
  801f6c:	8d 70 01             	lea    0x1(%eax),%esi
  801f6f:	8a 00                	mov    (%eax),%al
  801f71:	0f be d8             	movsbl %al,%ebx
  801f74:	85 db                	test   %ebx,%ebx
  801f76:	74 24                	je     801f9c <vprintfmt+0x24b>
  801f78:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f7c:	78 b8                	js     801f36 <vprintfmt+0x1e5>
  801f7e:	ff 4d e0             	decl   -0x20(%ebp)
  801f81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f85:	79 af                	jns    801f36 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801f87:	eb 13                	jmp    801f9c <vprintfmt+0x24b>
				putch(' ', putdat);
  801f89:	83 ec 08             	sub    $0x8,%esp
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	6a 20                	push   $0x20
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	ff d0                	call   *%eax
  801f96:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801f99:	ff 4d e4             	decl   -0x1c(%ebp)
  801f9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fa0:	7f e7                	jg     801f89 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801fa2:	e9 78 01 00 00       	jmp    80211f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801fa7:	83 ec 08             	sub    $0x8,%esp
  801faa:	ff 75 e8             	pushl  -0x18(%ebp)
  801fad:	8d 45 14             	lea    0x14(%ebp),%eax
  801fb0:	50                   	push   %eax
  801fb1:	e8 3c fd ff ff       	call   801cf2 <getint>
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc5:	85 d2                	test   %edx,%edx
  801fc7:	79 23                	jns    801fec <vprintfmt+0x29b>
				putch('-', putdat);
  801fc9:	83 ec 08             	sub    $0x8,%esp
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	6a 2d                	push   $0x2d
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	ff d0                	call   *%eax
  801fd6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdf:	f7 d8                	neg    %eax
  801fe1:	83 d2 00             	adc    $0x0,%edx
  801fe4:	f7 da                	neg    %edx
  801fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fe9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801fec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ff3:	e9 bc 00 00 00       	jmp    8020b4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801ff8:	83 ec 08             	sub    $0x8,%esp
  801ffb:	ff 75 e8             	pushl  -0x18(%ebp)
  801ffe:	8d 45 14             	lea    0x14(%ebp),%eax
  802001:	50                   	push   %eax
  802002:	e8 84 fc ff ff       	call   801c8b <getuint>
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80200d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802010:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802017:	e9 98 00 00 00       	jmp    8020b4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80201c:	83 ec 08             	sub    $0x8,%esp
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	6a 58                	push   $0x58
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	ff d0                	call   *%eax
  802029:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80202c:	83 ec 08             	sub    $0x8,%esp
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	6a 58                	push   $0x58
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	ff d0                	call   *%eax
  802039:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80203c:	83 ec 08             	sub    $0x8,%esp
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	6a 58                	push   $0x58
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	ff d0                	call   *%eax
  802049:	83 c4 10             	add    $0x10,%esp
			break;
  80204c:	e9 ce 00 00 00       	jmp    80211f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  802051:	83 ec 08             	sub    $0x8,%esp
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	6a 30                	push   $0x30
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	ff d0                	call   *%eax
  80205e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  802061:	83 ec 08             	sub    $0x8,%esp
  802064:	ff 75 0c             	pushl  0xc(%ebp)
  802067:	6a 78                	push   $0x78
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	ff d0                	call   *%eax
  80206e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  802071:	8b 45 14             	mov    0x14(%ebp),%eax
  802074:	83 c0 04             	add    $0x4,%eax
  802077:	89 45 14             	mov    %eax,0x14(%ebp)
  80207a:	8b 45 14             	mov    0x14(%ebp),%eax
  80207d:	83 e8 04             	sub    $0x4,%eax
  802080:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802082:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802085:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80208c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  802093:	eb 1f                	jmp    8020b4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802095:	83 ec 08             	sub    $0x8,%esp
  802098:	ff 75 e8             	pushl  -0x18(%ebp)
  80209b:	8d 45 14             	lea    0x14(%ebp),%eax
  80209e:	50                   	push   %eax
  80209f:	e8 e7 fb ff ff       	call   801c8b <getuint>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8020ad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8020b4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8020b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bb:	83 ec 04             	sub    $0x4,%esp
  8020be:	52                   	push   %edx
  8020bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020c2:	50                   	push   %eax
  8020c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	ff 75 08             	pushl  0x8(%ebp)
  8020cf:	e8 00 fb ff ff       	call   801bd4 <printnum>
  8020d4:	83 c4 20             	add    $0x20,%esp
			break;
  8020d7:	eb 46                	jmp    80211f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8020d9:	83 ec 08             	sub    $0x8,%esp
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	53                   	push   %ebx
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	ff d0                	call   *%eax
  8020e5:	83 c4 10             	add    $0x10,%esp
			break;
  8020e8:	eb 35                	jmp    80211f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8020ea:	c6 05 64 00 82 00 00 	movb   $0x0,0x820064
			break;
  8020f1:	eb 2c                	jmp    80211f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8020f3:	c6 05 64 00 82 00 01 	movb   $0x1,0x820064
			break;
  8020fa:	eb 23                	jmp    80211f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	ff 75 0c             	pushl  0xc(%ebp)
  802102:	6a 25                	push   $0x25
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	ff d0                	call   *%eax
  802109:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80210c:	ff 4d 10             	decl   0x10(%ebp)
  80210f:	eb 03                	jmp    802114 <vprintfmt+0x3c3>
  802111:	ff 4d 10             	decl   0x10(%ebp)
  802114:	8b 45 10             	mov    0x10(%ebp),%eax
  802117:	48                   	dec    %eax
  802118:	8a 00                	mov    (%eax),%al
  80211a:	3c 25                	cmp    $0x25,%al
  80211c:	75 f3                	jne    802111 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80211e:	90                   	nop
		}
	}
  80211f:	e9 35 fc ff ff       	jmp    801d59 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802124:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802125:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802128:	5b                   	pop    %ebx
  802129:	5e                   	pop    %esi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    

0080212c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802132:	8d 45 10             	lea    0x10(%ebp),%eax
  802135:	83 c0 04             	add    $0x4,%eax
  802138:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80213b:	8b 45 10             	mov    0x10(%ebp),%eax
  80213e:	ff 75 f4             	pushl  -0xc(%ebp)
  802141:	50                   	push   %eax
  802142:	ff 75 0c             	pushl  0xc(%ebp)
  802145:	ff 75 08             	pushl  0x8(%ebp)
  802148:	e8 04 fc ff ff       	call   801d51 <vprintfmt>
  80214d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802150:	90                   	nop
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802156:	8b 45 0c             	mov    0xc(%ebp),%eax
  802159:	8b 40 08             	mov    0x8(%eax),%eax
  80215c:	8d 50 01             	lea    0x1(%eax),%edx
  80215f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802162:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  802165:	8b 45 0c             	mov    0xc(%ebp),%eax
  802168:	8b 10                	mov    (%eax),%edx
  80216a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216d:	8b 40 04             	mov    0x4(%eax),%eax
  802170:	39 c2                	cmp    %eax,%edx
  802172:	73 12                	jae    802186 <sprintputch+0x33>
		*b->buf++ = ch;
  802174:	8b 45 0c             	mov    0xc(%ebp),%eax
  802177:	8b 00                	mov    (%eax),%eax
  802179:	8d 48 01             	lea    0x1(%eax),%ecx
  80217c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217f:	89 0a                	mov    %ecx,(%edx)
  802181:	8b 55 08             	mov    0x8(%ebp),%edx
  802184:	88 10                	mov    %dl,(%eax)
}
  802186:	90                   	nop
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    

00802189 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802195:	8b 45 0c             	mov    0xc(%ebp),%eax
  802198:	8d 50 ff             	lea    -0x1(%eax),%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	01 d0                	add    %edx,%eax
  8021a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ae:	74 06                	je     8021b6 <vsnprintf+0x2d>
  8021b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021b4:	7f 07                	jg     8021bd <vsnprintf+0x34>
		return -E_INVAL;
  8021b6:	b8 03 00 00 00       	mov    $0x3,%eax
  8021bb:	eb 20                	jmp    8021dd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8021bd:	ff 75 14             	pushl  0x14(%ebp)
  8021c0:	ff 75 10             	pushl  0x10(%ebp)
  8021c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021c6:	50                   	push   %eax
  8021c7:	68 53 21 80 00       	push   $0x802153
  8021cc:	e8 80 fb ff ff       	call   801d51 <vprintfmt>
  8021d1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8021d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8021e5:	8d 45 10             	lea    0x10(%ebp),%eax
  8021e8:	83 c0 04             	add    $0x4,%eax
  8021eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8021ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f4:	50                   	push   %eax
  8021f5:	ff 75 0c             	pushl  0xc(%ebp)
  8021f8:	ff 75 08             	pushl  0x8(%ebp)
  8021fb:	e8 89 ff ff ff       	call   802189 <vsnprintf>
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802218:	eb 06                	jmp    802220 <strlen+0x15>
		n++;
  80221a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80221d:	ff 45 08             	incl   0x8(%ebp)
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	8a 00                	mov    (%eax),%al
  802225:	84 c0                	test   %al,%al
  802227:	75 f1                	jne    80221a <strlen+0xf>
		n++;
	return n;
  802229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80223b:	eb 09                	jmp    802246 <strnlen+0x18>
		n++;
  80223d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802240:	ff 45 08             	incl   0x8(%ebp)
  802243:	ff 4d 0c             	decl   0xc(%ebp)
  802246:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80224a:	74 09                	je     802255 <strnlen+0x27>
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	8a 00                	mov    (%eax),%al
  802251:	84 c0                	test   %al,%al
  802253:	75 e8                	jne    80223d <strnlen+0xf>
		n++;
	return n;
  802255:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  802266:	90                   	nop
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8d 50 01             	lea    0x1(%eax),%edx
  80226d:	89 55 08             	mov    %edx,0x8(%ebp)
  802270:	8b 55 0c             	mov    0xc(%ebp),%edx
  802273:	8d 4a 01             	lea    0x1(%edx),%ecx
  802276:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802279:	8a 12                	mov    (%edx),%dl
  80227b:	88 10                	mov    %dl,(%eax)
  80227d:	8a 00                	mov    (%eax),%al
  80227f:	84 c0                	test   %al,%al
  802281:	75 e4                	jne    802267 <strcpy+0xd>
		/* do nothing */;
	return ret;
  802283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  802294:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80229b:	eb 1f                	jmp    8022bc <strncpy+0x34>
		*dst++ = *src;
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	8d 50 01             	lea    0x1(%eax),%edx
  8022a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8022a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a9:	8a 12                	mov    (%edx),%dl
  8022ab:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8022ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b0:	8a 00                	mov    (%eax),%al
  8022b2:	84 c0                	test   %al,%al
  8022b4:	74 03                	je     8022b9 <strncpy+0x31>
			src++;
  8022b6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8022b9:	ff 45 fc             	incl   -0x4(%ebp)
  8022bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022bf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8022c2:	72 d9                	jb     80229d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8022c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8022d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d9:	74 30                	je     80230b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8022db:	eb 16                	jmp    8022f3 <strlcpy+0x2a>
			*dst++ = *src++;
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	8d 50 01             	lea    0x1(%eax),%edx
  8022e3:	89 55 08             	mov    %edx,0x8(%ebp)
  8022e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022ec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8022ef:	8a 12                	mov    (%edx),%dl
  8022f1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8022f3:	ff 4d 10             	decl   0x10(%ebp)
  8022f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022fa:	74 09                	je     802305 <strlcpy+0x3c>
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	8a 00                	mov    (%eax),%al
  802301:	84 c0                	test   %al,%al
  802303:	75 d8                	jne    8022dd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80230b:	8b 55 08             	mov    0x8(%ebp),%edx
  80230e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802311:	29 c2                	sub    %eax,%edx
  802313:	89 d0                	mov    %edx,%eax
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80231a:	eb 06                	jmp    802322 <strcmp+0xb>
		p++, q++;
  80231c:	ff 45 08             	incl   0x8(%ebp)
  80231f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	8a 00                	mov    (%eax),%al
  802327:	84 c0                	test   %al,%al
  802329:	74 0e                	je     802339 <strcmp+0x22>
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	8a 10                	mov    (%eax),%dl
  802330:	8b 45 0c             	mov    0xc(%ebp),%eax
  802333:	8a 00                	mov    (%eax),%al
  802335:	38 c2                	cmp    %al,%dl
  802337:	74 e3                	je     80231c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	8a 00                	mov    (%eax),%al
  80233e:	0f b6 d0             	movzbl %al,%edx
  802341:	8b 45 0c             	mov    0xc(%ebp),%eax
  802344:	8a 00                	mov    (%eax),%al
  802346:	0f b6 c0             	movzbl %al,%eax
  802349:	29 c2                	sub    %eax,%edx
  80234b:	89 d0                	mov    %edx,%eax
}
  80234d:	5d                   	pop    %ebp
  80234e:	c3                   	ret    

0080234f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802352:	eb 09                	jmp    80235d <strncmp+0xe>
		n--, p++, q++;
  802354:	ff 4d 10             	decl   0x10(%ebp)
  802357:	ff 45 08             	incl   0x8(%ebp)
  80235a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80235d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802361:	74 17                	je     80237a <strncmp+0x2b>
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8a 00                	mov    (%eax),%al
  802368:	84 c0                	test   %al,%al
  80236a:	74 0e                	je     80237a <strncmp+0x2b>
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	8a 10                	mov    (%eax),%dl
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	8a 00                	mov    (%eax),%al
  802376:	38 c2                	cmp    %al,%dl
  802378:	74 da                	je     802354 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80237a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80237e:	75 07                	jne    802387 <strncmp+0x38>
		return 0;
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
  802385:	eb 14                	jmp    80239b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	8a 00                	mov    (%eax),%al
  80238c:	0f b6 d0             	movzbl %al,%edx
  80238f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802392:	8a 00                	mov    (%eax),%al
  802394:	0f b6 c0             	movzbl %al,%eax
  802397:	29 c2                	sub    %eax,%edx
  802399:	89 d0                	mov    %edx,%eax
}
  80239b:	5d                   	pop    %ebp
  80239c:	c3                   	ret    

0080239d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8023a9:	eb 12                	jmp    8023bd <strchr+0x20>
		if (*s == c)
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	8a 00                	mov    (%eax),%al
  8023b0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8023b3:	75 05                	jne    8023ba <strchr+0x1d>
			return (char *) s;
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	eb 11                	jmp    8023cb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8023ba:	ff 45 08             	incl   0x8(%ebp)
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	8a 00                	mov    (%eax),%al
  8023c2:	84 c0                	test   %al,%al
  8023c4:	75 e5                	jne    8023ab <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8023d9:	eb 0d                	jmp    8023e8 <strfind+0x1b>
		if (*s == c)
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	8a 00                	mov    (%eax),%al
  8023e0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8023e3:	74 0e                	je     8023f3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8023e5:	ff 45 08             	incl   0x8(%ebp)
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	8a 00                	mov    (%eax),%al
  8023ed:	84 c0                	test   %al,%al
  8023ef:	75 ea                	jne    8023db <strfind+0xe>
  8023f1:	eb 01                	jmp    8023f4 <strfind+0x27>
		if (*s == c)
			break;
  8023f3:	90                   	nop
	return (char *) s;
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  802405:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802409:	76 63                	jbe    80246e <memset+0x75>
		uint64 data_block = c;
  80240b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240e:	99                   	cltd   
  80240f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802412:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80241f:	c1 e0 08             	shl    $0x8,%eax
  802422:	09 45 f0             	or     %eax,-0x10(%ebp)
  802425:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  802428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802432:	c1 e0 10             	shl    $0x10,%eax
  802435:	09 45 f0             	or     %eax,-0x10(%ebp)
  802438:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80243b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802441:	89 c2                	mov    %eax,%edx
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
  802448:	09 45 f0             	or     %eax,-0x10(%ebp)
  80244b:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80244e:	eb 18                	jmp    802468 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802450:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802453:	8d 41 08             	lea    0x8(%ecx),%eax
  802456:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245f:	89 01                	mov    %eax,(%ecx)
  802461:	89 51 04             	mov    %edx,0x4(%ecx)
  802464:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  802468:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80246c:	77 e2                	ja     802450 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80246e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802472:	74 23                	je     802497 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802477:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80247a:	eb 0e                	jmp    80248a <memset+0x91>
			*p8++ = (uint8)c;
  80247c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80247f:	8d 50 01             	lea    0x1(%eax),%edx
  802482:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802485:	8b 55 0c             	mov    0xc(%ebp),%edx
  802488:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80248a:	8b 45 10             	mov    0x10(%ebp),%eax
  80248d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802490:	89 55 10             	mov    %edx,0x10(%ebp)
  802493:	85 c0                	test   %eax,%eax
  802495:	75 e5                	jne    80247c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8024a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8024a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8024ae:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8024b2:	76 24                	jbe    8024d8 <memcpy+0x3c>
		while(n >= 8){
  8024b4:	eb 1c                	jmp    8024d2 <memcpy+0x36>
			*d64 = *s64;
  8024b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024b9:	8b 50 04             	mov    0x4(%eax),%edx
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024c1:	89 01                	mov    %eax,(%ecx)
  8024c3:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8024c6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8024ca:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8024ce:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8024d2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8024d6:	77 de                	ja     8024b6 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8024d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024dc:	74 31                	je     80250f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8024de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8024e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8024ea:	eb 16                	jmp    802502 <memcpy+0x66>
			*d8++ = *s8++;
  8024ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ef:	8d 50 01             	lea    0x1(%eax),%edx
  8024f2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024fb:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8024fe:	8a 12                	mov    (%edx),%dl
  802500:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802502:	8b 45 10             	mov    0x10(%ebp),%eax
  802505:	8d 50 ff             	lea    -0x1(%eax),%edx
  802508:	89 55 10             	mov    %edx,0x10(%ebp)
  80250b:	85 c0                	test   %eax,%eax
  80250d:	75 dd                	jne    8024ec <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80251a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802526:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802529:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80252c:	73 50                	jae    80257e <memmove+0x6a>
  80252e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802531:	8b 45 10             	mov    0x10(%ebp),%eax
  802534:	01 d0                	add    %edx,%eax
  802536:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802539:	76 43                	jbe    80257e <memmove+0x6a>
		s += n;
  80253b:	8b 45 10             	mov    0x10(%ebp),%eax
  80253e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802541:	8b 45 10             	mov    0x10(%ebp),%eax
  802544:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802547:	eb 10                	jmp    802559 <memmove+0x45>
			*--d = *--s;
  802549:	ff 4d f8             	decl   -0x8(%ebp)
  80254c:	ff 4d fc             	decl   -0x4(%ebp)
  80254f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802552:	8a 10                	mov    (%eax),%dl
  802554:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802557:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802559:	8b 45 10             	mov    0x10(%ebp),%eax
  80255c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80255f:	89 55 10             	mov    %edx,0x10(%ebp)
  802562:	85 c0                	test   %eax,%eax
  802564:	75 e3                	jne    802549 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802566:	eb 23                	jmp    80258b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802568:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80256b:	8d 50 01             	lea    0x1(%eax),%edx
  80256e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802571:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802574:	8d 4a 01             	lea    0x1(%edx),%ecx
  802577:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80257a:	8a 12                	mov    (%edx),%dl
  80257c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80257e:	8b 45 10             	mov    0x10(%ebp),%eax
  802581:	8d 50 ff             	lea    -0x1(%eax),%edx
  802584:	89 55 10             	mov    %edx,0x10(%ebp)
  802587:	85 c0                	test   %eax,%eax
  802589:	75 dd                	jne    802568 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80259c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8025a2:	eb 2a                	jmp    8025ce <memcmp+0x3e>
		if (*s1 != *s2)
  8025a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a7:	8a 10                	mov    (%eax),%dl
  8025a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ac:	8a 00                	mov    (%eax),%al
  8025ae:	38 c2                	cmp    %al,%dl
  8025b0:	74 16                	je     8025c8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8025b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b5:	8a 00                	mov    (%eax),%al
  8025b7:	0f b6 d0             	movzbl %al,%edx
  8025ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025bd:	8a 00                	mov    (%eax),%al
  8025bf:	0f b6 c0             	movzbl %al,%eax
  8025c2:	29 c2                	sub    %eax,%edx
  8025c4:	89 d0                	mov    %edx,%eax
  8025c6:	eb 18                	jmp    8025e0 <memcmp+0x50>
		s1++, s2++;
  8025c8:	ff 45 fc             	incl   -0x4(%ebp)
  8025cb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8025ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	75 c9                	jne    8025a4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8025e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ee:	01 d0                	add    %edx,%eax
  8025f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8025f3:	eb 15                	jmp    80260a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	8a 00                	mov    (%eax),%al
  8025fa:	0f b6 d0             	movzbl %al,%edx
  8025fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802600:	0f b6 c0             	movzbl %al,%eax
  802603:	39 c2                	cmp    %eax,%edx
  802605:	74 0d                	je     802614 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802607:	ff 45 08             	incl   0x8(%ebp)
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802610:	72 e3                	jb     8025f5 <memfind+0x13>
  802612:	eb 01                	jmp    802615 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802614:	90                   	nop
	return (void *) s;
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802620:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802627:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80262e:	eb 03                	jmp    802633 <strtol+0x19>
		s++;
  802630:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	8a 00                	mov    (%eax),%al
  802638:	3c 20                	cmp    $0x20,%al
  80263a:	74 f4                	je     802630 <strtol+0x16>
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	8a 00                	mov    (%eax),%al
  802641:	3c 09                	cmp    $0x9,%al
  802643:	74 eb                	je     802630 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	8a 00                	mov    (%eax),%al
  80264a:	3c 2b                	cmp    $0x2b,%al
  80264c:	75 05                	jne    802653 <strtol+0x39>
		s++;
  80264e:	ff 45 08             	incl   0x8(%ebp)
  802651:	eb 13                	jmp    802666 <strtol+0x4c>
	else if (*s == '-')
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	8a 00                	mov    (%eax),%al
  802658:	3c 2d                	cmp    $0x2d,%al
  80265a:	75 0a                	jne    802666 <strtol+0x4c>
		s++, neg = 1;
  80265c:	ff 45 08             	incl   0x8(%ebp)
  80265f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802666:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80266a:	74 06                	je     802672 <strtol+0x58>
  80266c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802670:	75 20                	jne    802692 <strtol+0x78>
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	8a 00                	mov    (%eax),%al
  802677:	3c 30                	cmp    $0x30,%al
  802679:	75 17                	jne    802692 <strtol+0x78>
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	40                   	inc    %eax
  80267f:	8a 00                	mov    (%eax),%al
  802681:	3c 78                	cmp    $0x78,%al
  802683:	75 0d                	jne    802692 <strtol+0x78>
		s += 2, base = 16;
  802685:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802689:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802690:	eb 28                	jmp    8026ba <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802692:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802696:	75 15                	jne    8026ad <strtol+0x93>
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	8a 00                	mov    (%eax),%al
  80269d:	3c 30                	cmp    $0x30,%al
  80269f:	75 0c                	jne    8026ad <strtol+0x93>
		s++, base = 8;
  8026a1:	ff 45 08             	incl   0x8(%ebp)
  8026a4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8026ab:	eb 0d                	jmp    8026ba <strtol+0xa0>
	else if (base == 0)
  8026ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026b1:	75 07                	jne    8026ba <strtol+0xa0>
		base = 10;
  8026b3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	8a 00                	mov    (%eax),%al
  8026bf:	3c 2f                	cmp    $0x2f,%al
  8026c1:	7e 19                	jle    8026dc <strtol+0xc2>
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	8a 00                	mov    (%eax),%al
  8026c8:	3c 39                	cmp    $0x39,%al
  8026ca:	7f 10                	jg     8026dc <strtol+0xc2>
			dig = *s - '0';
  8026cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cf:	8a 00                	mov    (%eax),%al
  8026d1:	0f be c0             	movsbl %al,%eax
  8026d4:	83 e8 30             	sub    $0x30,%eax
  8026d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026da:	eb 42                	jmp    80271e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	8a 00                	mov    (%eax),%al
  8026e1:	3c 60                	cmp    $0x60,%al
  8026e3:	7e 19                	jle    8026fe <strtol+0xe4>
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e8:	8a 00                	mov    (%eax),%al
  8026ea:	3c 7a                	cmp    $0x7a,%al
  8026ec:	7f 10                	jg     8026fe <strtol+0xe4>
			dig = *s - 'a' + 10;
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	8a 00                	mov    (%eax),%al
  8026f3:	0f be c0             	movsbl %al,%eax
  8026f6:	83 e8 57             	sub    $0x57,%eax
  8026f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fc:	eb 20                	jmp    80271e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	8a 00                	mov    (%eax),%al
  802703:	3c 40                	cmp    $0x40,%al
  802705:	7e 39                	jle    802740 <strtol+0x126>
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	8a 00                	mov    (%eax),%al
  80270c:	3c 5a                	cmp    $0x5a,%al
  80270e:	7f 30                	jg     802740 <strtol+0x126>
			dig = *s - 'A' + 10;
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	8a 00                	mov    (%eax),%al
  802715:	0f be c0             	movsbl %al,%eax
  802718:	83 e8 37             	sub    $0x37,%eax
  80271b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	3b 45 10             	cmp    0x10(%ebp),%eax
  802724:	7d 19                	jge    80273f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802726:	ff 45 08             	incl   0x8(%ebp)
  802729:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80272c:	0f af 45 10          	imul   0x10(%ebp),%eax
  802730:	89 c2                	mov    %eax,%edx
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	01 d0                	add    %edx,%eax
  802737:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80273a:	e9 7b ff ff ff       	jmp    8026ba <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80273f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802740:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802744:	74 08                	je     80274e <strtol+0x134>
		*endptr = (char *) s;
  802746:	8b 45 0c             	mov    0xc(%ebp),%eax
  802749:	8b 55 08             	mov    0x8(%ebp),%edx
  80274c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80274e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802752:	74 07                	je     80275b <strtol+0x141>
  802754:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802757:	f7 d8                	neg    %eax
  802759:	eb 03                	jmp    80275e <strtol+0x144>
  80275b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <ltostr>:

void
ltostr(long value, char *str)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802766:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80276d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802774:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802778:	79 13                	jns    80278d <ltostr+0x2d>
	{
		neg = 1;
  80277a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802781:	8b 45 0c             	mov    0xc(%ebp),%eax
  802784:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802787:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80278a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802795:	99                   	cltd   
  802796:	f7 f9                	idiv   %ecx
  802798:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80279b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80279e:	8d 50 01             	lea    0x1(%eax),%edx
  8027a1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8027a4:	89 c2                	mov    %eax,%edx
  8027a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a9:	01 d0                	add    %edx,%eax
  8027ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ae:	83 c2 30             	add    $0x30,%edx
  8027b1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8027b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027b6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8027bb:	f7 e9                	imul   %ecx
  8027bd:	c1 fa 02             	sar    $0x2,%edx
  8027c0:	89 c8                	mov    %ecx,%eax
  8027c2:	c1 f8 1f             	sar    $0x1f,%eax
  8027c5:	29 c2                	sub    %eax,%edx
  8027c7:	89 d0                	mov    %edx,%eax
  8027c9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8027cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027d0:	75 bb                	jne    80278d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8027d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8027d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027dc:	48                   	dec    %eax
  8027dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8027e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027e4:	74 3d                	je     802823 <ltostr+0xc3>
		start = 1 ;
  8027e6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8027ed:	eb 34                	jmp    802823 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f5:	01 d0                	add    %edx,%eax
  8027f7:	8a 00                	mov    (%eax),%al
  8027f9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8027fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802802:	01 c2                	add    %eax,%edx
  802804:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280a:	01 c8                	add    %ecx,%eax
  80280c:	8a 00                	mov    (%eax),%al
  80280e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802810:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802813:	8b 45 0c             	mov    0xc(%ebp),%eax
  802816:	01 c2                	add    %eax,%edx
  802818:	8a 45 eb             	mov    -0x15(%ebp),%al
  80281b:	88 02                	mov    %al,(%edx)
		start++ ;
  80281d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802820:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802829:	7c c4                	jl     8027ef <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80282b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80282e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802831:	01 d0                	add    %edx,%eax
  802833:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802836:	90                   	nop
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80283f:	ff 75 08             	pushl  0x8(%ebp)
  802842:	e8 c4 f9 ff ff       	call   80220b <strlen>
  802847:	83 c4 04             	add    $0x4,%esp
  80284a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80284d:	ff 75 0c             	pushl  0xc(%ebp)
  802850:	e8 b6 f9 ff ff       	call   80220b <strlen>
  802855:	83 c4 04             	add    $0x4,%esp
  802858:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80285b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802862:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802869:	eb 17                	jmp    802882 <strcconcat+0x49>
		final[s] = str1[s] ;
  80286b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80286e:	8b 45 10             	mov    0x10(%ebp),%eax
  802871:	01 c2                	add    %eax,%edx
  802873:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	01 c8                	add    %ecx,%eax
  80287b:	8a 00                	mov    (%eax),%al
  80287d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80287f:	ff 45 fc             	incl   -0x4(%ebp)
  802882:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802885:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802888:	7c e1                	jl     80286b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80288a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802891:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802898:	eb 1f                	jmp    8028b9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80289a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80289d:	8d 50 01             	lea    0x1(%eax),%edx
  8028a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8028a3:	89 c2                	mov    %eax,%edx
  8028a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8028a8:	01 c2                	add    %eax,%edx
  8028aa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8028ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b0:	01 c8                	add    %ecx,%eax
  8028b2:	8a 00                	mov    (%eax),%al
  8028b4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8028b6:	ff 45 f8             	incl   -0x8(%ebp)
  8028b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028bf:	7c d9                	jl     80289a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8028c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c7:	01 d0                	add    %edx,%eax
  8028c9:	c6 00 00             	movb   $0x0,(%eax)
}
  8028cc:	90                   	nop
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    

008028cf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8028cf:	55                   	push   %ebp
  8028d0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8028d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8028d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8028db:	8b 45 14             	mov    0x14(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ea:	01 d0                	add    %edx,%eax
  8028ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028f2:	eb 0c                	jmp    802900 <strsplit+0x31>
			*string++ = 0;
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8d 50 01             	lea    0x1(%eax),%edx
  8028fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8028fd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	8a 00                	mov    (%eax),%al
  802905:	84 c0                	test   %al,%al
  802907:	74 18                	je     802921 <strsplit+0x52>
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	8a 00                	mov    (%eax),%al
  80290e:	0f be c0             	movsbl %al,%eax
  802911:	50                   	push   %eax
  802912:	ff 75 0c             	pushl  0xc(%ebp)
  802915:	e8 83 fa ff ff       	call   80239d <strchr>
  80291a:	83 c4 08             	add    $0x8,%esp
  80291d:	85 c0                	test   %eax,%eax
  80291f:	75 d3                	jne    8028f4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	8a 00                	mov    (%eax),%al
  802926:	84 c0                	test   %al,%al
  802928:	74 5a                	je     802984 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80292a:	8b 45 14             	mov    0x14(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	83 f8 0f             	cmp    $0xf,%eax
  802932:	75 07                	jne    80293b <strsplit+0x6c>
		{
			return 0;
  802934:	b8 00 00 00 00       	mov    $0x0,%eax
  802939:	eb 66                	jmp    8029a1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80293b:	8b 45 14             	mov    0x14(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	8d 48 01             	lea    0x1(%eax),%ecx
  802943:	8b 55 14             	mov    0x14(%ebp),%edx
  802946:	89 0a                	mov    %ecx,(%edx)
  802948:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80294f:	8b 45 10             	mov    0x10(%ebp),%eax
  802952:	01 c2                	add    %eax,%edx
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802959:	eb 03                	jmp    80295e <strsplit+0x8f>
			string++;
  80295b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	8a 00                	mov    (%eax),%al
  802963:	84 c0                	test   %al,%al
  802965:	74 8b                	je     8028f2 <strsplit+0x23>
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8a 00                	mov    (%eax),%al
  80296c:	0f be c0             	movsbl %al,%eax
  80296f:	50                   	push   %eax
  802970:	ff 75 0c             	pushl  0xc(%ebp)
  802973:	e8 25 fa ff ff       	call   80239d <strchr>
  802978:	83 c4 08             	add    $0x8,%esp
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 dc                	je     80295b <strsplit+0x8c>
			string++;
	}
  80297f:	e9 6e ff ff ff       	jmp    8028f2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802984:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802985:	8b 45 14             	mov    0x14(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802991:	8b 45 10             	mov    0x10(%ebp),%eax
  802994:	01 d0                	add    %edx,%eax
  802996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80299c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8029a1:	c9                   	leave  
  8029a2:	c3                   	ret    

008029a3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8029a3:	55                   	push   %ebp
  8029a4:	89 e5                	mov    %esp,%ebp
  8029a6:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8029af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8029b6:	eb 4a                	jmp    802a02 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8029b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	01 c2                	add    %eax,%edx
  8029c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8029c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c6:	01 c8                	add    %ecx,%eax
  8029c8:	8a 00                	mov    (%eax),%al
  8029ca:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8029cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d2:	01 d0                	add    %edx,%eax
  8029d4:	8a 00                	mov    (%eax),%al
  8029d6:	3c 40                	cmp    $0x40,%al
  8029d8:	7e 25                	jle    8029ff <str2lower+0x5c>
  8029da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e0:	01 d0                	add    %edx,%eax
  8029e2:	8a 00                	mov    (%eax),%al
  8029e4:	3c 5a                	cmp    $0x5a,%al
  8029e6:	7f 17                	jg     8029ff <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8029e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	01 d0                	add    %edx,%eax
  8029f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8029f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f6:	01 ca                	add    %ecx,%edx
  8029f8:	8a 12                	mov    (%edx),%dl
  8029fa:	83 c2 20             	add    $0x20,%edx
  8029fd:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8029ff:	ff 45 fc             	incl   -0x4(%ebp)
  802a02:	ff 75 0c             	pushl  0xc(%ebp)
  802a05:	e8 01 f8 ff ff       	call   80220b <strlen>
  802a0a:	83 c4 04             	add    $0x4,%esp
  802a0d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802a10:	7f a6                	jg     8029b8 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802a12:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
  802a1a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802a1d:	a1 08 80 80 00       	mov    0x808008,%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 42                	je     802a68 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802a26:	83 ec 08             	sub    $0x8,%esp
  802a29:	68 00 00 00 82       	push   $0x82000000
  802a2e:	68 00 00 00 80       	push   $0x80000000
  802a33:	e8 b0 1e 00 00       	call   8048e8 <initialize_dynamic_allocator>
  802a38:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802a3b:	e8 96 1c 00 00       	call   8046d6 <sys_get_uheap_strategy>
  802a40:	a3 80 80 83 00       	mov    %eax,0x838080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802a45:	a1 60 00 82 00       	mov    0x820060,%eax
  802a4a:	05 00 10 00 00       	add    $0x1000,%eax
  802a4f:	a3 30 81 83 00       	mov    %eax,0x838130
		uheapPageAllocBreak = uheapPageAllocStart;
  802a54:	a1 30 81 83 00       	mov    0x838130,%eax
  802a59:	a3 88 80 83 00       	mov    %eax,0x838088

		__firstTimeFlag = 0;
  802a5e:	c7 05 08 80 80 00 00 	movl   $0x0,0x808008
  802a65:	00 00 00 
	}
}
  802a68:	90                   	nop
  802a69:	c9                   	leave  
  802a6a:	c3                   	ret    

00802a6b <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802a6b:	55                   	push   %ebp
  802a6c:	89 e5                	mov    %esp,%ebp
  802a6e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a7f:	83 ec 08             	sub    $0x8,%esp
  802a82:	68 06 04 00 00       	push   $0x406
  802a87:	50                   	push   %eax
  802a88:	e8 93 18 00 00       	call   804320 <__sys_allocate_page>
  802a8d:	83 c4 10             	add    $0x10,%esp
  802a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802a93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a97:	79 14                	jns    802aad <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 c8 6d 80 00       	push   $0x806dc8
  802aa1:	6a 1f                	push   $0x1f
  802aa3:	68 04 6e 80 00       	push   $0x806e04
  802aa8:	e8 b7 ed ff ff       	call   801864 <_panic>
	return 0;
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ac8:	83 ec 0c             	sub    $0xc,%esp
  802acb:	50                   	push   %eax
  802acc:	e8 96 18 00 00       	call   804367 <__sys_unmap_frame>
  802ad1:	83 c4 10             	add    $0x10,%esp
  802ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802ad7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adb:	79 14                	jns    802af1 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	68 10 6e 80 00       	push   $0x806e10
  802ae5:	6a 2a                	push   $0x2a
  802ae7:	68 04 6e 80 00       	push   $0x806e04
  802aec:	e8 73 ed ff ff       	call   801864 <_panic>
}
  802af1:	90                   	nop
  802af2:	c9                   	leave  
  802af3:	c3                   	ret    

00802af4 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
  802af7:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802afa:	e8 18 ff ff ff       	call   802a17 <uheap_init>
	if (size == 0) return NULL ;
  802aff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b03:	75 0a                	jne    802b0f <malloc+0x1b>
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	e9 43 03 00 00       	jmp    802e52 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  802b0f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802b16:	77 13                	ja     802b2b <malloc+0x37>
    {
        return alloc_block(size);
  802b18:	83 ec 0c             	sub    $0xc,%esp
  802b1b:	ff 75 08             	pushl  0x8(%ebp)
  802b1e:	e8 78 20 00 00       	call   804b9b <alloc_block>
  802b23:	83 c4 10             	add    $0x10,%esp
  802b26:	e9 27 03 00 00       	jmp    802e52 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802b2b:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802b32:	8b 55 08             	mov    0x8(%ebp),%edx
  802b35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b38:	01 d0                	add    %edx,%eax
  802b3a:	48                   	dec    %eax
  802b3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802b3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b41:	ba 00 00 00 00       	mov    $0x0,%edx
  802b46:	f7 75 dc             	divl   -0x24(%ebp)
  802b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b4c:	29 d0                	sub    %edx,%eax
  802b4e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  802b51:	a1 40 00 82 00       	mov    0x820040,%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	75 0a                	jne    802b64 <malloc+0x70>
    {
        uhp_inited = 1;
  802b5a:	c7 05 40 00 82 00 01 	movl   $0x1,0x820040
  802b61:	00 00 00 
    }

    int exactIdx = -1;
  802b64:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802b6b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802b72:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802b79:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802b80:	e9 85 00 00 00       	jmp    802c0a <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802b85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b88:	89 d0                	mov    %edx,%eax
  802b8a:	01 c0                	add    %eax,%eax
  802b8c:	01 d0                	add    %edx,%eax
  802b8e:	c1 e0 02             	shl    $0x2,%eax
  802b91:	05 48 40 81 00       	add    $0x814048,%eax
  802b96:	8a 00                	mov    (%eax),%al
  802b98:	84 c0                	test   %al,%al
  802b9a:	74 20                	je     802bbc <malloc+0xc8>
  802b9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b9f:	89 d0                	mov    %edx,%eax
  802ba1:	01 c0                	add    %eax,%eax
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	c1 e0 02             	shl    $0x2,%eax
  802ba8:	05 44 40 81 00       	add    $0x814044,%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802bb2:	75 08                	jne    802bbc <malloc+0xc8>
        {
            exactIdx = i;
  802bb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802bba:	eb 5b                	jmp    802c17 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802bbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bbf:	89 d0                	mov    %edx,%eax
  802bc1:	01 c0                	add    %eax,%eax
  802bc3:	01 d0                	add    %edx,%eax
  802bc5:	c1 e0 02             	shl    $0x2,%eax
  802bc8:	05 48 40 81 00       	add    $0x814048,%eax
  802bcd:	8a 00                	mov    (%eax),%al
  802bcf:	84 c0                	test   %al,%al
  802bd1:	74 34                	je     802c07 <malloc+0x113>
  802bd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bd6:	89 d0                	mov    %edx,%eax
  802bd8:	01 c0                	add    %eax,%eax
  802bda:	01 d0                	add    %edx,%eax
  802bdc:	c1 e0 02             	shl    $0x2,%eax
  802bdf:	05 44 40 81 00       	add    $0x814044,%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802be9:	76 1c                	jbe    802c07 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  802beb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bee:	89 d0                	mov    %edx,%eax
  802bf0:	01 c0                	add    %eax,%eax
  802bf2:	01 d0                	add    %edx,%eax
  802bf4:	c1 e0 02             	shl    $0x2,%eax
  802bf7:	05 44 40 81 00       	add    $0x814044,%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802c07:	ff 45 e8             	incl   -0x18(%ebp)
  802c0a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802c11:	0f 8e 6e ff ff ff    	jle    802b85 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  802c17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802c1e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802c22:	74 7d                	je     802ca1 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802c24:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2e:	89 d0                	mov    %edx,%eax
  802c30:	01 c0                	add    %eax,%eax
  802c32:	01 d0                	add    %edx,%eax
  802c34:	c1 e0 02             	shl    $0x2,%eax
  802c37:	05 40 40 81 00       	add    $0x814040,%eax
  802c3c:	8b 10                	mov    (%eax),%edx
  802c3e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c41:	01 d0                	add    %edx,%eax
  802c43:	48                   	dec    %eax
  802c44:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802c47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c4f:	f7 75 bc             	divl   -0x44(%ebp)
  802c52:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c55:	29 d0                	sub    %edx,%eax
  802c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5d:	89 d0                	mov    %edx,%eax
  802c5f:	01 c0                	add    %eax,%eax
  802c61:	01 d0                	add    %edx,%eax
  802c63:	c1 e0 02             	shl    $0x2,%eax
  802c66:	05 48 40 81 00       	add    $0x814048,%eax
  802c6b:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c71:	89 d0                	mov    %edx,%eax
  802c73:	01 c0                	add    %eax,%eax
  802c75:	01 d0                	add    %edx,%eax
  802c77:	c1 e0 02             	shl    $0x2,%eax
  802c7a:	05 44 40 81 00       	add    $0x814044,%eax
  802c7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c88:	89 d0                	mov    %edx,%eax
  802c8a:	01 c0                	add    %eax,%eax
  802c8c:	01 d0                	add    %edx,%eax
  802c8e:	c1 e0 02             	shl    $0x2,%eax
  802c91:	05 40 40 81 00       	add    $0x814040,%eax
  802c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9c:	e9 2d 01 00 00       	jmp    802dce <malloc+0x2da>
    }
    else if (worstIdx != -1)
  802ca1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ca5:	0f 84 ce 00 00 00    	je     802d79 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802cab:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb5:	89 d0                	mov    %edx,%eax
  802cb7:	01 c0                	add    %eax,%eax
  802cb9:	01 d0                	add    %edx,%eax
  802cbb:	c1 e0 02             	shl    $0x2,%eax
  802cbe:	05 40 40 81 00       	add    $0x814040,%eax
  802cc3:	8b 10                	mov    (%eax),%edx
  802cc5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cc8:	01 d0                	add    %edx,%eax
  802cca:	48                   	dec    %eax
  802ccb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd6:	f7 75 c4             	divl   -0x3c(%ebp)
  802cd9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cdc:	29 d0                	sub    %edx,%eax
  802cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802ce1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce4:	89 d0                	mov    %edx,%eax
  802ce6:	01 c0                	add    %eax,%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	c1 e0 02             	shl    $0x2,%eax
  802ced:	05 44 40 81 00       	add    $0x814044,%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802cf7:	75 47                	jne    802d40 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  802cf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfc:	89 d0                	mov    %edx,%eax
  802cfe:	01 c0                	add    %eax,%eax
  802d00:	01 d0                	add    %edx,%eax
  802d02:	c1 e0 02             	shl    $0x2,%eax
  802d05:	05 48 40 81 00       	add    $0x814048,%eax
  802d0a:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802d0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d10:	89 d0                	mov    %edx,%eax
  802d12:	01 c0                	add    %eax,%eax
  802d14:	01 d0                	add    %edx,%eax
  802d16:	c1 e0 02             	shl    $0x2,%eax
  802d19:	05 44 40 81 00       	add    $0x814044,%eax
  802d1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802d24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d27:	89 d0                	mov    %edx,%eax
  802d29:	01 c0                	add    %eax,%eax
  802d2b:	01 d0                	add    %edx,%eax
  802d2d:	c1 e0 02             	shl    $0x2,%eax
  802d30:	05 40 40 81 00       	add    $0x814040,%eax
  802d35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3b:	e9 8e 00 00 00       	jmp    802dce <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d46:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802d49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4c:	89 d0                	mov    %edx,%eax
  802d4e:	01 c0                	add    %eax,%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	c1 e0 02             	shl    $0x2,%eax
  802d55:	05 40 40 81 00       	add    $0x814040,%eax
  802d5a:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802d62:	89 c2                	mov    %eax,%edx
  802d64:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d67:	89 c8                	mov    %ecx,%eax
  802d69:	01 c0                	add    %eax,%eax
  802d6b:	01 c8                	add    %ecx,%eax
  802d6d:	c1 e0 02             	shl    $0x2,%eax
  802d70:	05 44 40 81 00       	add    $0x814044,%eax
  802d75:	89 10                	mov    %edx,(%eax)
  802d77:	eb 55                	jmp    802dce <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802d79:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802d80:	8b 15 88 80 83 00    	mov    0x838088,%edx
  802d86:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d89:	01 d0                	add    %edx,%eax
  802d8b:	48                   	dec    %eax
  802d8c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802d8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d92:	ba 00 00 00 00       	mov    $0x0,%edx
  802d97:	f7 75 d0             	divl   -0x30(%ebp)
  802d9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d9d:	29 d0                	sub    %edx,%eax
  802d9f:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802da2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802da5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802da8:	01 d0                	add    %edx,%eax
  802daa:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802daf:	76 0a                	jbe    802dbb <malloc+0x2c7>
            return NULL;
  802db1:	b8 00 00 00 00       	mov    $0x0,%eax
  802db6:	e9 97 00 00 00       	jmp    802e52 <malloc+0x35e>
        va = start;
  802dbb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802dc1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dc7:	01 d0                	add    %edx,%eax
  802dc9:	a3 88 80 83 00       	mov    %eax,0x838088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802dce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802dd5:	eb 5e                	jmp    802e35 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  802dd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dda:	89 d0                	mov    %edx,%eax
  802ddc:	01 c0                	add    %eax,%eax
  802dde:	01 d0                	add    %edx,%eax
  802de0:	c1 e0 02             	shl    $0x2,%eax
  802de3:	05 48 80 80 00       	add    $0x808048,%eax
  802de8:	8a 00                	mov    (%eax),%al
  802dea:	84 c0                	test   %al,%al
  802dec:	75 44                	jne    802e32 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  802dee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802df1:	89 d0                	mov    %edx,%eax
  802df3:	01 c0                	add    %eax,%eax
  802df5:	01 d0                	add    %edx,%eax
  802df7:	c1 e0 02             	shl    $0x2,%eax
  802dfa:	8d 90 40 80 80 00    	lea    0x808040(%eax),%edx
  802e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e03:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802e05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e08:	89 d0                	mov    %edx,%eax
  802e0a:	01 c0                	add    %eax,%eax
  802e0c:	01 d0                	add    %edx,%eax
  802e0e:	c1 e0 02             	shl    $0x2,%eax
  802e11:	8d 90 44 80 80 00    	lea    0x808044(%eax),%edx
  802e17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e1a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802e1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e1f:	89 d0                	mov    %edx,%eax
  802e21:	01 c0                	add    %eax,%eax
  802e23:	01 d0                	add    %edx,%eax
  802e25:	c1 e0 02             	shl    $0x2,%eax
  802e28:	05 48 80 80 00       	add    $0x808048,%eax
  802e2d:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802e30:	eb 0c                	jmp    802e3e <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e32:	ff 45 e0             	incl   -0x20(%ebp)
  802e35:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e3c:	7e 99                	jle    802dd7 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  802e3e:	83 ec 08             	sub    $0x8,%esp
  802e41:	ff 75 d4             	pushl  -0x2c(%ebp)
  802e44:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e47:	e8 a2 19 00 00       	call   8047ee <sys_allocate_user_mem>
  802e4c:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  802e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802e52:	c9                   	leave  
  802e53:	c3                   	ret    

00802e54 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
  802e57:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  802e5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5e:	0f 84 fa 03 00 00    	je     80325e <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802e6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	79 1c                	jns    802e8d <free+0x39>
  802e71:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  802e78:	77 13                	ja     802e8d <free+0x39>
    {
        free_block(virtual_address);
  802e7a:	83 ec 0c             	sub    $0xc,%esp
  802e7d:	ff 75 08             	pushl  0x8(%ebp)
  802e80:	e8 09 21 00 00       	call   804f8e <free_block>
  802e85:	83 c4 10             	add    $0x10,%esp
        return;
  802e88:	e9 d2 03 00 00       	jmp    80325f <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802e8d:	a1 30 81 83 00       	mov    0x838130,%eax
  802e92:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  802e95:	72 09                	jb     802ea0 <free+0x4c>
  802e97:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  802e9e:	76 17                	jbe    802eb7 <free+0x63>
        panic("free: invalid address");
  802ea0:	83 ec 04             	sub    $0x4,%esp
  802ea3:	68 4d 6e 80 00       	push   $0x806e4d
  802ea8:	68 9b 00 00 00       	push   $0x9b
  802ead:	68 04 6e 80 00       	push   $0x806e04
  802eb2:	e8 ad e9 ff ff       	call   801864 <_panic>

    uint32 size = 0;
  802eb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  802ebe:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802ec5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802ecc:	eb 50                	jmp    802f1e <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802ece:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ed1:	89 d0                	mov    %edx,%eax
  802ed3:	01 c0                	add    %eax,%eax
  802ed5:	01 d0                	add    %edx,%eax
  802ed7:	c1 e0 02             	shl    $0x2,%eax
  802eda:	05 48 80 80 00       	add    $0x808048,%eax
  802edf:	8a 00                	mov    (%eax),%al
  802ee1:	84 c0                	test   %al,%al
  802ee3:	74 36                	je     802f1b <free+0xc7>
  802ee5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ee8:	89 d0                	mov    %edx,%eax
  802eea:	01 c0                	add    %eax,%eax
  802eec:	01 d0                	add    %edx,%eax
  802eee:	c1 e0 02             	shl    $0x2,%eax
  802ef1:	05 40 80 80 00       	add    $0x808040,%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802efb:	75 1e                	jne    802f1b <free+0xc7>
        {
            size = uhp_allocs[i].size;
  802efd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f00:	89 d0                	mov    %edx,%eax
  802f02:	01 c0                	add    %eax,%eax
  802f04:	01 d0                	add    %edx,%eax
  802f06:	c1 e0 02             	shl    $0x2,%eax
  802f09:	05 44 80 80 00       	add    $0x808044,%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  802f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  802f19:	eb 0c                	jmp    802f27 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802f1b:	ff 45 ec             	incl   -0x14(%ebp)
  802f1e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802f25:	7e a7                	jle    802ece <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  802f27:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802f2b:	74 06                	je     802f33 <free+0xdf>
  802f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f31:	75 17                	jne    802f4a <free+0xf6>
        panic("free: unknown block");
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	68 63 6e 80 00       	push   $0x806e63
  802f3b:	68 a9 00 00 00       	push   $0xa9
  802f40:	68 04 6e 80 00       	push   $0x806e04
  802f45:	e8 1a e9 ff ff       	call   801864 <_panic>

    uhp_allocs[idx].used = 0;
  802f4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f4d:	89 d0                	mov    %edx,%eax
  802f4f:	01 c0                	add    %eax,%eax
  802f51:	01 d0                	add    %edx,%eax
  802f53:	c1 e0 02             	shl    $0x2,%eax
  802f56:	05 48 80 80 00       	add    $0x808048,%eax
  802f5b:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  802f5e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802f65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802f6c:	eb 64                	jmp    802fd2 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  802f6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f71:	89 d0                	mov    %edx,%eax
  802f73:	01 c0                	add    %eax,%eax
  802f75:	01 d0                	add    %edx,%eax
  802f77:	c1 e0 02             	shl    $0x2,%eax
  802f7a:	05 48 40 81 00       	add    $0x814048,%eax
  802f7f:	8a 00                	mov    (%eax),%al
  802f81:	84 c0                	test   %al,%al
  802f83:	75 4a                	jne    802fcf <free+0x17b>
        {
            uhp_frees[i].va = va;
  802f85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f88:	89 d0                	mov    %edx,%eax
  802f8a:	01 c0                	add    %eax,%eax
  802f8c:	01 d0                	add    %edx,%eax
  802f8e:	c1 e0 02             	shl    $0x2,%eax
  802f91:	8d 90 40 40 81 00    	lea    0x814040(%eax),%edx
  802f97:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f9a:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802f9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f9f:	89 d0                	mov    %edx,%eax
  802fa1:	01 c0                	add    %eax,%eax
  802fa3:	01 d0                	add    %edx,%eax
  802fa5:	c1 e0 02             	shl    $0x2,%eax
  802fa8:	8d 90 44 40 81 00    	lea    0x814044(%eax),%edx
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  802fb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fb6:	89 d0                	mov    %edx,%eax
  802fb8:	01 c0                	add    %eax,%eax
  802fba:	01 d0                	add    %edx,%eax
  802fbc:	c1 e0 02             	shl    $0x2,%eax
  802fbf:	05 48 40 81 00       	add    $0x814048,%eax
  802fc4:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802fc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fca:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802fcd:	eb 0c                	jmp    802fdb <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802fcf:	ff 45 e4             	incl   -0x1c(%ebp)
  802fd2:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802fd9:	7e 93                	jle    802f6e <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  802fdb:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802fdf:	0f 84 f1 01 00 00    	je     8031d6 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802fe5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802fec:	e9 d8 01 00 00       	jmp    8031c9 <free+0x375>
        {
            if (i == fidx) continue;
  802ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ff7:	0f 84 c8 01 00 00    	je     8031c5 <free+0x371>
            if (uhp_frees[i].free)
  802ffd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803000:	89 d0                	mov    %edx,%eax
  803002:	01 c0                	add    %eax,%eax
  803004:	01 d0                	add    %edx,%eax
  803006:	c1 e0 02             	shl    $0x2,%eax
  803009:	05 48 40 81 00       	add    $0x814048,%eax
  80300e:	8a 00                	mov    (%eax),%al
  803010:	84 c0                	test   %al,%al
  803012:	0f 84 ae 01 00 00    	je     8031c6 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  803018:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80301b:	89 d0                	mov    %edx,%eax
  80301d:	01 c0                	add    %eax,%eax
  80301f:	01 d0                	add    %edx,%eax
  803021:	c1 e0 02             	shl    $0x2,%eax
  803024:	05 40 40 81 00       	add    $0x814040,%eax
  803029:	8b 08                	mov    (%eax),%ecx
  80302b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80302e:	89 d0                	mov    %edx,%eax
  803030:	01 c0                	add    %eax,%eax
  803032:	01 d0                	add    %edx,%eax
  803034:	c1 e0 02             	shl    $0x2,%eax
  803037:	05 44 40 81 00       	add    $0x814044,%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	01 c1                	add    %eax,%ecx
  803040:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803043:	89 d0                	mov    %edx,%eax
  803045:	01 c0                	add    %eax,%eax
  803047:	01 d0                	add    %edx,%eax
  803049:	c1 e0 02             	shl    $0x2,%eax
  80304c:	05 40 40 81 00       	add    $0x814040,%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	39 c1                	cmp    %eax,%ecx
  803055:	0f 85 a8 00 00 00    	jne    803103 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  80305b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80305e:	89 d0                	mov    %edx,%eax
  803060:	01 c0                	add    %eax,%eax
  803062:	01 d0                	add    %edx,%eax
  803064:	c1 e0 02             	shl    $0x2,%eax
  803067:	05 40 40 81 00       	add    $0x814040,%eax
  80306c:	8b 10                	mov    (%eax),%edx
  80306e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803071:	89 c8                	mov    %ecx,%eax
  803073:	01 c0                	add    %eax,%eax
  803075:	01 c8                	add    %ecx,%eax
  803077:	c1 e0 02             	shl    $0x2,%eax
  80307a:	05 40 40 81 00       	add    $0x814040,%eax
  80307f:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  803081:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803084:	89 d0                	mov    %edx,%eax
  803086:	01 c0                	add    %eax,%eax
  803088:	01 d0                	add    %edx,%eax
  80308a:	c1 e0 02             	shl    $0x2,%eax
  80308d:	05 44 40 81 00       	add    $0x814044,%eax
  803092:	8b 08                	mov    (%eax),%ecx
  803094:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803097:	89 d0                	mov    %edx,%eax
  803099:	01 c0                	add    %eax,%eax
  80309b:	01 d0                	add    %edx,%eax
  80309d:	c1 e0 02             	shl    $0x2,%eax
  8030a0:	05 44 40 81 00       	add    $0x814044,%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	01 c1                	add    %eax,%ecx
  8030a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ac:	89 d0                	mov    %edx,%eax
  8030ae:	01 c0                	add    %eax,%eax
  8030b0:	01 d0                	add    %edx,%eax
  8030b2:	c1 e0 02             	shl    $0x2,%eax
  8030b5:	05 44 40 81 00       	add    $0x814044,%eax
  8030ba:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8030bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030bf:	89 d0                	mov    %edx,%eax
  8030c1:	01 c0                	add    %eax,%eax
  8030c3:	01 d0                	add    %edx,%eax
  8030c5:	c1 e0 02             	shl    $0x2,%eax
  8030c8:	05 48 40 81 00       	add    $0x814048,%eax
  8030cd:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8030d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030d3:	89 d0                	mov    %edx,%eax
  8030d5:	01 c0                	add    %eax,%eax
  8030d7:	01 d0                	add    %edx,%eax
  8030d9:	c1 e0 02             	shl    $0x2,%eax
  8030dc:	05 40 40 81 00       	add    $0x814040,%eax
  8030e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8030e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ea:	89 d0                	mov    %edx,%eax
  8030ec:	01 c0                	add    %eax,%eax
  8030ee:	01 d0                	add    %edx,%eax
  8030f0:	c1 e0 02             	shl    $0x2,%eax
  8030f3:	05 44 40 81 00       	add    $0x814044,%eax
  8030f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fe:	e9 c3 00 00 00       	jmp    8031c6 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  803103:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803106:	89 d0                	mov    %edx,%eax
  803108:	01 c0                	add    %eax,%eax
  80310a:	01 d0                	add    %edx,%eax
  80310c:	c1 e0 02             	shl    $0x2,%eax
  80310f:	05 40 40 81 00       	add    $0x814040,%eax
  803114:	8b 08                	mov    (%eax),%ecx
  803116:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803119:	89 d0                	mov    %edx,%eax
  80311b:	01 c0                	add    %eax,%eax
  80311d:	01 d0                	add    %edx,%eax
  80311f:	c1 e0 02             	shl    $0x2,%eax
  803122:	05 44 40 81 00       	add    $0x814044,%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	01 c1                	add    %eax,%ecx
  80312b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80312e:	89 d0                	mov    %edx,%eax
  803130:	01 c0                	add    %eax,%eax
  803132:	01 d0                	add    %edx,%eax
  803134:	c1 e0 02             	shl    $0x2,%eax
  803137:	05 40 40 81 00       	add    $0x814040,%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	39 c1                	cmp    %eax,%ecx
  803140:	0f 85 80 00 00 00    	jne    8031c6 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  803146:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803149:	89 d0                	mov    %edx,%eax
  80314b:	01 c0                	add    %eax,%eax
  80314d:	01 d0                	add    %edx,%eax
  80314f:	c1 e0 02             	shl    $0x2,%eax
  803152:	05 44 40 81 00       	add    $0x814044,%eax
  803157:	8b 08                	mov    (%eax),%ecx
  803159:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80315c:	89 d0                	mov    %edx,%eax
  80315e:	01 c0                	add    %eax,%eax
  803160:	01 d0                	add    %edx,%eax
  803162:	c1 e0 02             	shl    $0x2,%eax
  803165:	05 44 40 81 00       	add    $0x814044,%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	01 c1                	add    %eax,%ecx
  80316e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803171:	89 d0                	mov    %edx,%eax
  803173:	01 c0                	add    %eax,%eax
  803175:	01 d0                	add    %edx,%eax
  803177:	c1 e0 02             	shl    $0x2,%eax
  80317a:	05 44 40 81 00       	add    $0x814044,%eax
  80317f:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  803181:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803184:	89 d0                	mov    %edx,%eax
  803186:	01 c0                	add    %eax,%eax
  803188:	01 d0                	add    %edx,%eax
  80318a:	c1 e0 02             	shl    $0x2,%eax
  80318d:	05 48 40 81 00       	add    $0x814048,%eax
  803192:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  803195:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803198:	89 d0                	mov    %edx,%eax
  80319a:	01 c0                	add    %eax,%eax
  80319c:	01 d0                	add    %edx,%eax
  80319e:	c1 e0 02             	shl    $0x2,%eax
  8031a1:	05 40 40 81 00       	add    $0x814040,%eax
  8031a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8031ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031af:	89 d0                	mov    %edx,%eax
  8031b1:	01 c0                	add    %eax,%eax
  8031b3:	01 d0                	add    %edx,%eax
  8031b5:	c1 e0 02             	shl    $0x2,%eax
  8031b8:	05 44 40 81 00       	add    $0x814044,%eax
  8031bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c3:	eb 01                	jmp    8031c6 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  8031c5:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8031c6:	ff 45 e0             	incl   -0x20(%ebp)
  8031c9:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8031d0:	0f 8e 1b fe ff ff    	jle    802ff1 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  8031d6:	a1 30 81 83 00       	mov    0x838130,%eax
  8031db:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8031de:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8031e5:	eb 53                	jmp    80323a <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  8031e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031ea:	89 d0                	mov    %edx,%eax
  8031ec:	01 c0                	add    %eax,%eax
  8031ee:	01 d0                	add    %edx,%eax
  8031f0:	c1 e0 02             	shl    $0x2,%eax
  8031f3:	05 48 80 80 00       	add    $0x808048,%eax
  8031f8:	8a 00                	mov    (%eax),%al
  8031fa:	84 c0                	test   %al,%al
  8031fc:	74 39                	je     803237 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  8031fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803201:	89 d0                	mov    %edx,%eax
  803203:	01 c0                	add    %eax,%eax
  803205:	01 d0                	add    %edx,%eax
  803207:	c1 e0 02             	shl    $0x2,%eax
  80320a:	05 40 80 80 00       	add    $0x808040,%eax
  80320f:	8b 08                	mov    (%eax),%ecx
  803211:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803214:	89 d0                	mov    %edx,%eax
  803216:	01 c0                	add    %eax,%eax
  803218:	01 d0                	add    %edx,%eax
  80321a:	c1 e0 02             	shl    $0x2,%eax
  80321d:	05 44 80 80 00       	add    $0x808044,%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	01 c8                	add    %ecx,%eax
  803226:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  803229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80322c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80322f:	76 06                	jbe    803237 <free+0x3e3>
  803231:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803234:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803237:	ff 45 d8             	incl   -0x28(%ebp)
  80323a:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  803241:	7e a4                	jle    8031e7 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  803243:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803246:	a3 88 80 83 00       	mov    %eax,0x838088

    sys_free_user_mem(va, size);
  80324b:	83 ec 08             	sub    $0x8,%esp
  80324e:	ff 75 f4             	pushl  -0xc(%ebp)
  803251:	ff 75 d4             	pushl  -0x2c(%ebp)
  803254:	e8 79 15 00 00       	call   8047d2 <sys_free_user_mem>
  803259:	83 c4 10             	add    $0x10,%esp
  80325c:	eb 01                	jmp    80325f <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  80325e:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  80325f:	c9                   	leave  
  803260:	c3                   	ret    

00803261 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  803261:	55                   	push   %ebp
  803262:	89 e5                	mov    %esp,%ebp
  803264:	83 ec 68             	sub    $0x68,%esp
  803267:	8b 45 10             	mov    0x10(%ebp),%eax
  80326a:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80326d:	e8 a5 f7 ff ff       	call   802a17 <uheap_init>
	if (size == 0) return NULL ;
  803272:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803276:	75 0a                	jne    803282 <smalloc+0x21>
  803278:	b8 00 00 00 00       	mov    $0x0,%eax
  80327d:	e9 37 03 00 00       	jmp    8035b9 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  803282:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  803289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80328c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328f:	01 d0                	add    %edx,%eax
  803291:	48                   	dec    %eax
  803292:	89 45 d8             	mov    %eax,-0x28(%ebp)
  803295:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803298:	ba 00 00 00 00       	mov    $0x0,%edx
  80329d:	f7 75 dc             	divl   -0x24(%ebp)
  8032a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032a3:	29 d0                	sub    %edx,%eax
  8032a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  8032a8:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8032af:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8032b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8032bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8032c4:	e9 85 00 00 00       	jmp    80334e <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8032c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cc:	89 d0                	mov    %edx,%eax
  8032ce:	01 c0                	add    %eax,%eax
  8032d0:	01 d0                	add    %edx,%eax
  8032d2:	c1 e0 02             	shl    $0x2,%eax
  8032d5:	05 48 40 81 00       	add    $0x814048,%eax
  8032da:	8a 00                	mov    (%eax),%al
  8032dc:	84 c0                	test   %al,%al
  8032de:	74 20                	je     803300 <smalloc+0x9f>
  8032e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e3:	89 d0                	mov    %edx,%eax
  8032e5:	01 c0                	add    %eax,%eax
  8032e7:	01 d0                	add    %edx,%eax
  8032e9:	c1 e0 02             	shl    $0x2,%eax
  8032ec:	05 44 40 81 00       	add    $0x814044,%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032f6:	75 08                	jne    803300 <smalloc+0x9f>
        {
            exactIdx = i;
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8032fe:	eb 5b                	jmp    80335b <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  803300:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803303:	89 d0                	mov    %edx,%eax
  803305:	01 c0                	add    %eax,%eax
  803307:	01 d0                	add    %edx,%eax
  803309:	c1 e0 02             	shl    $0x2,%eax
  80330c:	05 48 40 81 00       	add    $0x814048,%eax
  803311:	8a 00                	mov    (%eax),%al
  803313:	84 c0                	test   %al,%al
  803315:	74 34                	je     80334b <smalloc+0xea>
  803317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331a:	89 d0                	mov    %edx,%eax
  80331c:	01 c0                	add    %eax,%eax
  80331e:	01 d0                	add    %edx,%eax
  803320:	c1 e0 02             	shl    $0x2,%eax
  803323:	05 44 40 81 00       	add    $0x814044,%eax
  803328:	8b 00                	mov    (%eax),%eax
  80332a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80332d:	76 1c                	jbe    80334b <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  80332f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803332:	89 d0                	mov    %edx,%eax
  803334:	01 c0                	add    %eax,%eax
  803336:	01 d0                	add    %edx,%eax
  803338:	c1 e0 02             	shl    $0x2,%eax
  80333b:	05 44 40 81 00       	add    $0x814044,%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80334b:	ff 45 e8             	incl   -0x18(%ebp)
  80334e:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803355:	0f 8e 6e ff ff ff    	jle    8032c9 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80335b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  803362:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  803366:	74 7d                	je     8033e5 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  803368:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80336f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803372:	89 d0                	mov    %edx,%eax
  803374:	01 c0                	add    %eax,%eax
  803376:	01 d0                	add    %edx,%eax
  803378:	c1 e0 02             	shl    $0x2,%eax
  80337b:	05 40 40 81 00       	add    $0x814040,%eax
  803380:	8b 10                	mov    (%eax),%edx
  803382:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803385:	01 d0                	add    %edx,%eax
  803387:	48                   	dec    %eax
  803388:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80338b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80338e:	ba 00 00 00 00       	mov    $0x0,%edx
  803393:	f7 75 bc             	divl   -0x44(%ebp)
  803396:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803399:	29 d0                	sub    %edx,%eax
  80339b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80339e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a1:	89 d0                	mov    %edx,%eax
  8033a3:	01 c0                	add    %eax,%eax
  8033a5:	01 d0                	add    %edx,%eax
  8033a7:	c1 e0 02             	shl    $0x2,%eax
  8033aa:	05 48 40 81 00       	add    $0x814048,%eax
  8033af:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8033b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b5:	89 d0                	mov    %edx,%eax
  8033b7:	01 c0                	add    %eax,%eax
  8033b9:	01 d0                	add    %edx,%eax
  8033bb:	c1 e0 02             	shl    $0x2,%eax
  8033be:	05 44 40 81 00       	add    $0x814044,%eax
  8033c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8033c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033cc:	89 d0                	mov    %edx,%eax
  8033ce:	01 c0                	add    %eax,%eax
  8033d0:	01 d0                	add    %edx,%eax
  8033d2:	c1 e0 02             	shl    $0x2,%eax
  8033d5:	05 40 40 81 00       	add    $0x814040,%eax
  8033da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e0:	e9 2d 01 00 00       	jmp    803512 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8033e5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8033e9:	0f 84 ce 00 00 00    	je     8034bd <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8033ef:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8033f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f9:	89 d0                	mov    %edx,%eax
  8033fb:	01 c0                	add    %eax,%eax
  8033fd:	01 d0                	add    %edx,%eax
  8033ff:	c1 e0 02             	shl    $0x2,%eax
  803402:	05 40 40 81 00       	add    $0x814040,%eax
  803407:	8b 10                	mov    (%eax),%edx
  803409:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80340c:	01 d0                	add    %edx,%eax
  80340e:	48                   	dec    %eax
  80340f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803412:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803415:	ba 00 00 00 00       	mov    $0x0,%edx
  80341a:	f7 75 c4             	divl   -0x3c(%ebp)
  80341d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803420:	29 d0                	sub    %edx,%eax
  803422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  803425:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803428:	89 d0                	mov    %edx,%eax
  80342a:	01 c0                	add    %eax,%eax
  80342c:	01 d0                	add    %edx,%eax
  80342e:	c1 e0 02             	shl    $0x2,%eax
  803431:	05 44 40 81 00       	add    $0x814044,%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80343b:	75 47                	jne    803484 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80343d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803440:	89 d0                	mov    %edx,%eax
  803442:	01 c0                	add    %eax,%eax
  803444:	01 d0                	add    %edx,%eax
  803446:	c1 e0 02             	shl    $0x2,%eax
  803449:	05 48 40 81 00       	add    $0x814048,%eax
  80344e:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  803451:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803454:	89 d0                	mov    %edx,%eax
  803456:	01 c0                	add    %eax,%eax
  803458:	01 d0                	add    %edx,%eax
  80345a:	c1 e0 02             	shl    $0x2,%eax
  80345d:	05 44 40 81 00       	add    $0x814044,%eax
  803462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  803468:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80346b:	89 d0                	mov    %edx,%eax
  80346d:	01 c0                	add    %eax,%eax
  80346f:	01 d0                	add    %edx,%eax
  803471:	c1 e0 02             	shl    $0x2,%eax
  803474:	05 40 40 81 00       	add    $0x814040,%eax
  803479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347f:	e9 8e 00 00 00       	jmp    803512 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  803484:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803487:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80348d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803490:	89 d0                	mov    %edx,%eax
  803492:	01 c0                	add    %eax,%eax
  803494:	01 d0                	add    %edx,%eax
  803496:	c1 e0 02             	shl    $0x2,%eax
  803499:	05 40 40 81 00       	add    $0x814040,%eax
  80349e:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8034a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a3:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8034a6:	89 c2                	mov    %eax,%edx
  8034a8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034ab:	89 c8                	mov    %ecx,%eax
  8034ad:	01 c0                	add    %eax,%eax
  8034af:	01 c8                	add    %ecx,%eax
  8034b1:	c1 e0 02             	shl    $0x2,%eax
  8034b4:	05 44 40 81 00       	add    $0x814044,%eax
  8034b9:	89 10                	mov    %edx,(%eax)
  8034bb:	eb 55                	jmp    803512 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8034bd:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8034c4:	8b 15 88 80 83 00    	mov    0x838088,%edx
  8034ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034cd:	01 d0                	add    %edx,%eax
  8034cf:	48                   	dec    %eax
  8034d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8034d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8034db:	f7 75 d0             	divl   -0x30(%ebp)
  8034de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034e1:	29 d0                	sub    %edx,%eax
  8034e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8034e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ec:	01 d0                	add    %edx,%eax
  8034ee:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8034f3:	76 0a                	jbe    8034ff <smalloc+0x29e>
            return NULL;
  8034f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fa:	e9 ba 00 00 00       	jmp    8035b9 <smalloc+0x358>
        va = start;
  8034ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  803505:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350b:	01 d0                	add    %edx,%eax
  80350d:	a3 88 80 83 00       	mov    %eax,0x838088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803512:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803519:	eb 5e                	jmp    803579 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  80351b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80351e:	89 d0                	mov    %edx,%eax
  803520:	01 c0                	add    %eax,%eax
  803522:	01 d0                	add    %edx,%eax
  803524:	c1 e0 02             	shl    $0x2,%eax
  803527:	05 48 80 80 00       	add    $0x808048,%eax
  80352c:	8a 00                	mov    (%eax),%al
  80352e:	84 c0                	test   %al,%al
  803530:	75 44                	jne    803576 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  803532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803535:	89 d0                	mov    %edx,%eax
  803537:	01 c0                	add    %eax,%eax
  803539:	01 d0                	add    %edx,%eax
  80353b:	c1 e0 02             	shl    $0x2,%eax
  80353e:	8d 90 40 80 80 00    	lea    0x808040(%eax),%edx
  803544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803547:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  803549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80354c:	89 d0                	mov    %edx,%eax
  80354e:	01 c0                	add    %eax,%eax
  803550:	01 d0                	add    %edx,%eax
  803552:	c1 e0 02             	shl    $0x2,%eax
  803555:	8d 90 44 80 80 00    	lea    0x808044(%eax),%edx
  80355b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  803560:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803563:	89 d0                	mov    %edx,%eax
  803565:	01 c0                	add    %eax,%eax
  803567:	01 d0                	add    %edx,%eax
  803569:	c1 e0 02             	shl    $0x2,%eax
  80356c:	05 48 80 80 00       	add    $0x808048,%eax
  803571:	c6 00 01             	movb   $0x1,(%eax)
            break;
  803574:	eb 0c                	jmp    803582 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803576:	ff 45 e0             	incl   -0x20(%ebp)
  803579:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803580:	7e 99                	jle    80351b <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  803582:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803585:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  803589:	52                   	push   %edx
  80358a:	50                   	push   %eax
  80358b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80358e:	ff 75 08             	pushl  0x8(%ebp)
  803591:	e8 de 0e 00 00       	call   804474 <sys_create_shared_object>
  803596:	83 c4 10             	add    $0x10,%esp
  803599:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  80359c:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8035a0:	75 07                	jne    8035a9 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8035a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8035a7:	eb 10                	jmp    8035b9 <smalloc+0x358>
    if (r < 0)
  8035a9:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8035ad:	79 07                	jns    8035b6 <smalloc+0x355>
        return NULL;
  8035af:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b4:	eb 03                	jmp    8035b9 <smalloc+0x358>
    return (void*)va;
  8035b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8035b9:	c9                   	leave  
  8035ba:	c3                   	ret    

008035bb <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8035bb:	55                   	push   %ebp
  8035bc:	89 e5                	mov    %esp,%ebp
  8035be:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8035c1:	e8 51 f4 ff ff       	call   802a17 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8035c6:	83 ec 08             	sub    $0x8,%esp
  8035c9:	ff 75 0c             	pushl  0xc(%ebp)
  8035cc:	ff 75 08             	pushl  0x8(%ebp)
  8035cf:	e8 ca 0e 00 00       	call   80449e <sys_size_of_shared_object>
  8035d4:	83 c4 10             	add    $0x10,%esp
  8035d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8035da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035de:	7f 0a                	jg     8035ea <sget+0x2f>
        return NULL;
  8035e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e5:	e9 28 03 00 00       	jmp    803912 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8035ea:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8035f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035f7:	01 d0                	add    %edx,%eax
  8035f9:	48                   	dec    %eax
  8035fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8035fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803600:	ba 00 00 00 00       	mov    $0x0,%edx
  803605:	f7 75 d8             	divl   -0x28(%ebp)
  803608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360b:	29 d0                	sub    %edx,%eax
  80360d:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  803610:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  803617:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80361e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  803625:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80362c:	e9 85 00 00 00       	jmp    8036b6 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  803631:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803634:	89 d0                	mov    %edx,%eax
  803636:	01 c0                	add    %eax,%eax
  803638:	01 d0                	add    %edx,%eax
  80363a:	c1 e0 02             	shl    $0x2,%eax
  80363d:	05 48 40 81 00       	add    $0x814048,%eax
  803642:	8a 00                	mov    (%eax),%al
  803644:	84 c0                	test   %al,%al
  803646:	74 20                	je     803668 <sget+0xad>
  803648:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80364b:	89 d0                	mov    %edx,%eax
  80364d:	01 c0                	add    %eax,%eax
  80364f:	01 d0                	add    %edx,%eax
  803651:	c1 e0 02             	shl    $0x2,%eax
  803654:	05 44 40 81 00       	add    $0x814044,%eax
  803659:	8b 00                	mov    (%eax),%eax
  80365b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80365e:	75 08                	jne    803668 <sget+0xad>
        {
            exactIdx = i;
  803660:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803663:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  803666:	eb 5b                	jmp    8036c3 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  803668:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80366b:	89 d0                	mov    %edx,%eax
  80366d:	01 c0                	add    %eax,%eax
  80366f:	01 d0                	add    %edx,%eax
  803671:	c1 e0 02             	shl    $0x2,%eax
  803674:	05 48 40 81 00       	add    $0x814048,%eax
  803679:	8a 00                	mov    (%eax),%al
  80367b:	84 c0                	test   %al,%al
  80367d:	74 34                	je     8036b3 <sget+0xf8>
  80367f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803682:	89 d0                	mov    %edx,%eax
  803684:	01 c0                	add    %eax,%eax
  803686:	01 d0                	add    %edx,%eax
  803688:	c1 e0 02             	shl    $0x2,%eax
  80368b:	05 44 40 81 00       	add    $0x814044,%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803695:	76 1c                	jbe    8036b3 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  803697:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80369a:	89 d0                	mov    %edx,%eax
  80369c:	01 c0                	add    %eax,%eax
  80369e:	01 d0                	add    %edx,%eax
  8036a0:	c1 e0 02             	shl    $0x2,%eax
  8036a3:	05 44 40 81 00       	add    $0x814044,%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8036ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8036b3:	ff 45 e8             	incl   -0x18(%ebp)
  8036b6:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8036bd:	0f 8e 6e ff ff ff    	jle    803631 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8036c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8036ca:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8036ce:	74 7d                	je     80374d <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8036d0:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8036d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036da:	89 d0                	mov    %edx,%eax
  8036dc:	01 c0                	add    %eax,%eax
  8036de:	01 d0                	add    %edx,%eax
  8036e0:	c1 e0 02             	shl    $0x2,%eax
  8036e3:	05 40 40 81 00       	add    $0x814040,%eax
  8036e8:	8b 10                	mov    (%eax),%edx
  8036ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036ed:	01 d0                	add    %edx,%eax
  8036ef:	48                   	dec    %eax
  8036f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8036f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8036f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8036fb:	f7 75 b8             	divl   -0x48(%ebp)
  8036fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803701:	29 d0                	sub    %edx,%eax
  803703:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  803706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803709:	89 d0                	mov    %edx,%eax
  80370b:	01 c0                	add    %eax,%eax
  80370d:	01 d0                	add    %edx,%eax
  80370f:	c1 e0 02             	shl    $0x2,%eax
  803712:	05 48 40 81 00       	add    $0x814048,%eax
  803717:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80371a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80371d:	89 d0                	mov    %edx,%eax
  80371f:	01 c0                	add    %eax,%eax
  803721:	01 d0                	add    %edx,%eax
  803723:	c1 e0 02             	shl    $0x2,%eax
  803726:	05 44 40 81 00       	add    $0x814044,%eax
  80372b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  803731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803734:	89 d0                	mov    %edx,%eax
  803736:	01 c0                	add    %eax,%eax
  803738:	01 d0                	add    %edx,%eax
  80373a:	c1 e0 02             	shl    $0x2,%eax
  80373d:	05 40 40 81 00       	add    $0x814040,%eax
  803742:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803748:	e9 2d 01 00 00       	jmp    80387a <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80374d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803751:	0f 84 ce 00 00 00    	je     803825 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  803757:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80375e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803761:	89 d0                	mov    %edx,%eax
  803763:	01 c0                	add    %eax,%eax
  803765:	01 d0                	add    %edx,%eax
  803767:	c1 e0 02             	shl    $0x2,%eax
  80376a:	05 40 40 81 00       	add    $0x814040,%eax
  80376f:	8b 10                	mov    (%eax),%edx
  803771:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803774:	01 d0                	add    %edx,%eax
  803776:	48                   	dec    %eax
  803777:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80377a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80377d:	ba 00 00 00 00       	mov    $0x0,%edx
  803782:	f7 75 c0             	divl   -0x40(%ebp)
  803785:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803788:	29 d0                	sub    %edx,%eax
  80378a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80378d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803790:	89 d0                	mov    %edx,%eax
  803792:	01 c0                	add    %eax,%eax
  803794:	01 d0                	add    %edx,%eax
  803796:	c1 e0 02             	shl    $0x2,%eax
  803799:	05 44 40 81 00       	add    $0x814044,%eax
  80379e:	8b 00                	mov    (%eax),%eax
  8037a0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8037a3:	75 47                	jne    8037ec <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8037a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037a8:	89 d0                	mov    %edx,%eax
  8037aa:	01 c0                	add    %eax,%eax
  8037ac:	01 d0                	add    %edx,%eax
  8037ae:	c1 e0 02             	shl    $0x2,%eax
  8037b1:	05 48 40 81 00       	add    $0x814048,%eax
  8037b6:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8037b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037bc:	89 d0                	mov    %edx,%eax
  8037be:	01 c0                	add    %eax,%eax
  8037c0:	01 d0                	add    %edx,%eax
  8037c2:	c1 e0 02             	shl    $0x2,%eax
  8037c5:	05 44 40 81 00       	add    $0x814044,%eax
  8037ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8037d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037d3:	89 d0                	mov    %edx,%eax
  8037d5:	01 c0                	add    %eax,%eax
  8037d7:	01 d0                	add    %edx,%eax
  8037d9:	c1 e0 02             	shl    $0x2,%eax
  8037dc:	05 40 40 81 00       	add    $0x814040,%eax
  8037e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e7:	e9 8e 00 00 00       	jmp    80387a <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8037ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037f2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8037f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f8:	89 d0                	mov    %edx,%eax
  8037fa:	01 c0                	add    %eax,%eax
  8037fc:	01 d0                	add    %edx,%eax
  8037fe:	c1 e0 02             	shl    $0x2,%eax
  803801:	05 40 40 81 00       	add    $0x814040,%eax
  803806:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  803808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380b:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80380e:	89 c2                	mov    %eax,%edx
  803810:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803813:	89 c8                	mov    %ecx,%eax
  803815:	01 c0                	add    %eax,%eax
  803817:	01 c8                	add    %ecx,%eax
  803819:	c1 e0 02             	shl    $0x2,%eax
  80381c:	05 44 40 81 00       	add    $0x814044,%eax
  803821:	89 10                	mov    %edx,(%eax)
  803823:	eb 55                	jmp    80387a <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  803825:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80382c:	8b 15 88 80 83 00    	mov    0x838088,%edx
  803832:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803835:	01 d0                	add    %edx,%eax
  803837:	48                   	dec    %eax
  803838:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80383b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80383e:	ba 00 00 00 00       	mov    $0x0,%edx
  803843:	f7 75 cc             	divl   -0x34(%ebp)
  803846:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803849:	29 d0                	sub    %edx,%eax
  80384b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80384e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803851:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803854:	01 d0                	add    %edx,%eax
  803856:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80385b:	76 0a                	jbe    803867 <sget+0x2ac>
            return NULL;
  80385d:	b8 00 00 00 00       	mov    $0x0,%eax
  803862:	e9 ab 00 00 00       	jmp    803912 <sget+0x357>
        va = start;
  803867:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80386a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80386d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  803870:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803873:	01 d0                	add    %edx,%eax
  803875:	a3 88 80 83 00       	mov    %eax,0x838088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80387a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803881:	eb 5e                	jmp    8038e1 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  803883:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803886:	89 d0                	mov    %edx,%eax
  803888:	01 c0                	add    %eax,%eax
  80388a:	01 d0                	add    %edx,%eax
  80388c:	c1 e0 02             	shl    $0x2,%eax
  80388f:	05 48 80 80 00       	add    $0x808048,%eax
  803894:	8a 00                	mov    (%eax),%al
  803896:	84 c0                	test   %al,%al
  803898:	75 44                	jne    8038de <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80389a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80389d:	89 d0                	mov    %edx,%eax
  80389f:	01 c0                	add    %eax,%eax
  8038a1:	01 d0                	add    %edx,%eax
  8038a3:	c1 e0 02             	shl    $0x2,%eax
  8038a6:	8d 90 40 80 80 00    	lea    0x808040(%eax),%edx
  8038ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038af:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8038b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038b4:	89 d0                	mov    %edx,%eax
  8038b6:	01 c0                	add    %eax,%eax
  8038b8:	01 d0                	add    %edx,%eax
  8038ba:	c1 e0 02             	shl    $0x2,%eax
  8038bd:	8d 90 44 80 80 00    	lea    0x808044(%eax),%edx
  8038c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038c6:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8038c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038cb:	89 d0                	mov    %edx,%eax
  8038cd:	01 c0                	add    %eax,%eax
  8038cf:	01 d0                	add    %edx,%eax
  8038d1:	c1 e0 02             	shl    $0x2,%eax
  8038d4:	05 48 80 80 00       	add    $0x808048,%eax
  8038d9:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8038dc:	eb 0c                	jmp    8038ea <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8038de:	ff 45 e0             	incl   -0x20(%ebp)
  8038e1:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8038e8:	7e 99                	jle    803883 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	83 ec 04             	sub    $0x4,%esp
  8038f0:	50                   	push   %eax
  8038f1:	ff 75 0c             	pushl  0xc(%ebp)
  8038f4:	ff 75 08             	pushl  0x8(%ebp)
  8038f7:	e8 bf 0b 00 00       	call   8044bb <sys_get_shared_object>
  8038fc:	83 c4 10             	add    $0x10,%esp
  8038ff:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  803902:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803906:	79 07                	jns    80390f <sget+0x354>
        return NULL;
  803908:	b8 00 00 00 00       	mov    $0x0,%eax
  80390d:	eb 03                	jmp    803912 <sget+0x357>
    return (void*)va;
  80390f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803912:	c9                   	leave  
  803913:	c3                   	ret    

00803914 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803914:	55                   	push   %ebp
  803915:	89 e5                	mov    %esp,%ebp
  803917:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80391a:	e8 f8 f0 ff ff       	call   802a17 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80391f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803923:	75 13                	jne    803938 <realloc+0x24>
		return malloc(new_size);
  803925:	83 ec 0c             	sub    $0xc,%esp
  803928:	ff 75 0c             	pushl  0xc(%ebp)
  80392b:	e8 c4 f1 ff ff       	call   802af4 <malloc>
  803930:	83 c4 10             	add    $0x10,%esp
  803933:	e9 f4 05 00 00       	jmp    803f2c <realloc+0x618>
	if (new_size == 0)
  803938:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80393c:	75 18                	jne    803956 <realloc+0x42>
	{
		free(virtual_address);
  80393e:	83 ec 0c             	sub    $0xc,%esp
  803941:	ff 75 08             	pushl  0x8(%ebp)
  803944:	e8 0b f5 ff ff       	call   802e54 <free>
  803949:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80394c:	b8 00 00 00 00       	mov    $0x0,%eax
  803951:	e9 d6 05 00 00       	jmp    803f2c <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  803956:	8b 45 08             	mov    0x8(%ebp),%eax
  803959:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80395c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80395f:	85 c0                	test   %eax,%eax
  803961:	79 74                	jns    8039d7 <realloc+0xc3>
  803963:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80396a:	77 6b                	ja     8039d7 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80396c:	83 ec 0c             	sub    $0xc,%esp
  80396f:	ff 75 0c             	pushl  0xc(%ebp)
  803972:	e8 7d f1 ff ff       	call   802af4 <malloc>
  803977:	83 c4 10             	add    $0x10,%esp
  80397a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80397d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803981:	75 0a                	jne    80398d <realloc+0x79>
			return NULL;
  803983:	b8 00 00 00 00       	mov    $0x0,%eax
  803988:	e9 9f 05 00 00       	jmp    803f2c <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80398d:	83 ec 0c             	sub    $0xc,%esp
  803990:	ff 75 08             	pushl  0x8(%ebp)
  803993:	e8 e0 11 00 00       	call   804b78 <get_block_size>
  803998:	83 c4 10             	add    $0x10,%esp
  80399b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80399e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8039a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039a4:	39 d0                	cmp    %edx,%eax
  8039a6:	76 02                	jbe    8039aa <realloc+0x96>
  8039a8:	89 d0                	mov    %edx,%eax
  8039aa:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8039ad:	83 ec 04             	sub    $0x4,%esp
  8039b0:	ff 75 c0             	pushl  -0x40(%ebp)
  8039b3:	ff 75 08             	pushl  0x8(%ebp)
  8039b6:	ff 75 c8             	pushl  -0x38(%ebp)
  8039b9:	e8 56 eb ff ff       	call   802514 <memmove>
  8039be:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8039c1:	83 ec 0c             	sub    $0xc,%esp
  8039c4:	ff 75 08             	pushl  0x8(%ebp)
  8039c7:	e8 88 f4 ff ff       	call   802e54 <free>
  8039cc:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8039cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039d2:	e9 55 05 00 00       	jmp    803f2c <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8039d7:	a1 30 81 83 00       	mov    0x838130,%eax
  8039dc:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8039df:	72 09                	jb     8039ea <realloc+0xd6>
  8039e1:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8039e8:	76 0a                	jbe    8039f4 <realloc+0xe0>
		return NULL;
  8039ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ef:	e9 38 05 00 00       	jmp    803f2c <realloc+0x618>
	uint32 oldsz = 0;
  8039f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8039fb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803a02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803a09:	eb 50                	jmp    803a5b <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803a0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a0e:	89 d0                	mov    %edx,%eax
  803a10:	01 c0                	add    %eax,%eax
  803a12:	01 d0                	add    %edx,%eax
  803a14:	c1 e0 02             	shl    $0x2,%eax
  803a17:	05 48 80 80 00       	add    $0x808048,%eax
  803a1c:	8a 00                	mov    (%eax),%al
  803a1e:	84 c0                	test   %al,%al
  803a20:	74 36                	je     803a58 <realloc+0x144>
  803a22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a25:	89 d0                	mov    %edx,%eax
  803a27:	01 c0                	add    %eax,%eax
  803a29:	01 d0                	add    %edx,%eax
  803a2b:	c1 e0 02             	shl    $0x2,%eax
  803a2e:	05 40 80 80 00       	add    $0x808040,%eax
  803a33:	8b 00                	mov    (%eax),%eax
  803a35:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  803a38:	75 1e                	jne    803a58 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  803a3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a3d:	89 d0                	mov    %edx,%eax
  803a3f:	01 c0                	add    %eax,%eax
  803a41:	01 d0                	add    %edx,%eax
  803a43:	c1 e0 02             	shl    $0x2,%eax
  803a46:	05 44 80 80 00       	add    $0x808044,%eax
  803a4b:	8b 00                	mov    (%eax),%eax
  803a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  803a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  803a56:	eb 0c                	jmp    803a64 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803a58:	ff 45 ec             	incl   -0x14(%ebp)
  803a5b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803a62:	7e a7                	jle    803a0b <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  803a64:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803a68:	75 0a                	jne    803a74 <realloc+0x160>
		return NULL;
  803a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a6f:	e9 b8 04 00 00       	jmp    803f2c <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  803a74:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  803a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803a81:	01 d0                	add    %edx,%eax
  803a83:	48                   	dec    %eax
  803a84:	89 45 b8             	mov    %eax,-0x48(%ebp)
  803a87:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  803a8f:	f7 75 bc             	divl   -0x44(%ebp)
  803a92:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a95:	29 d0                	sub    %edx,%eax
  803a97:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  803a9a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803a9d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803aa0:	75 08                	jne    803aaa <realloc+0x196>
		return virtual_address;
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa5:	e9 82 04 00 00       	jmp    803f2c <realloc+0x618>
	if (req < oldsz)
  803aaa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803aad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803ab0:	0f 83 cd 02 00 00    	jae    803d83 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  803ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab9:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  803abc:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  803abf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803ac2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803ac5:	01 d0                	add    %edx,%eax
  803ac7:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  803aca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803acd:	89 d0                	mov    %edx,%eax
  803acf:	01 c0                	add    %eax,%eax
  803ad1:	01 d0                	add    %edx,%eax
  803ad3:	c1 e0 02             	shl    $0x2,%eax
  803ad6:	8d 90 44 80 80 00    	lea    0x808044(%eax),%edx
  803adc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803adf:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  803ae1:	83 ec 08             	sub    $0x8,%esp
  803ae4:	ff 75 b0             	pushl  -0x50(%ebp)
  803ae7:	ff 75 ac             	pushl  -0x54(%ebp)
  803aea:	e8 e3 0c 00 00       	call   8047d2 <sys_free_user_mem>
  803aef:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  803af2:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803af9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  803b00:	eb 64                	jmp    803b66 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  803b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b05:	89 d0                	mov    %edx,%eax
  803b07:	01 c0                	add    %eax,%eax
  803b09:	01 d0                	add    %edx,%eax
  803b0b:	c1 e0 02             	shl    $0x2,%eax
  803b0e:	05 48 40 81 00       	add    $0x814048,%eax
  803b13:	8a 00                	mov    (%eax),%al
  803b15:	84 c0                	test   %al,%al
  803b17:	75 4a                	jne    803b63 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  803b19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b1c:	89 d0                	mov    %edx,%eax
  803b1e:	01 c0                	add    %eax,%eax
  803b20:	01 d0                	add    %edx,%eax
  803b22:	c1 e0 02             	shl    $0x2,%eax
  803b25:	8d 90 40 40 81 00    	lea    0x814040(%eax),%edx
  803b2b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803b2e:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  803b30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b33:	89 d0                	mov    %edx,%eax
  803b35:	01 c0                	add    %eax,%eax
  803b37:	01 d0                	add    %edx,%eax
  803b39:	c1 e0 02             	shl    $0x2,%eax
  803b3c:	8d 90 44 40 81 00    	lea    0x814044(%eax),%edx
  803b42:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803b45:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  803b47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b4a:	89 d0                	mov    %edx,%eax
  803b4c:	01 c0                	add    %eax,%eax
  803b4e:	01 d0                	add    %edx,%eax
  803b50:	c1 e0 02             	shl    $0x2,%eax
  803b53:	05 48 40 81 00       	add    $0x814048,%eax
  803b58:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  803b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  803b61:	eb 0c                	jmp    803b6f <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803b63:	ff 45 e4             	incl   -0x1c(%ebp)
  803b66:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  803b6d:	7e 93                	jle    803b02 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  803b6f:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  803b73:	0f 84 8d 01 00 00    	je     803d06 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803b79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b80:	e9 74 01 00 00       	jmp    803cf9 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  803b85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b88:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b8b:	0f 84 64 01 00 00    	je     803cf5 <realloc+0x3e1>
				if (uhp_frees[k].free)
  803b91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b94:	89 d0                	mov    %edx,%eax
  803b96:	01 c0                	add    %eax,%eax
  803b98:	01 d0                	add    %edx,%eax
  803b9a:	c1 e0 02             	shl    $0x2,%eax
  803b9d:	05 48 40 81 00       	add    $0x814048,%eax
  803ba2:	8a 00                	mov    (%eax),%al
  803ba4:	84 c0                	test   %al,%al
  803ba6:	0f 84 4a 01 00 00    	je     803cf6 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  803bac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803baf:	89 d0                	mov    %edx,%eax
  803bb1:	01 c0                	add    %eax,%eax
  803bb3:	01 d0                	add    %edx,%eax
  803bb5:	c1 e0 02             	shl    $0x2,%eax
  803bb8:	05 40 40 81 00       	add    $0x814040,%eax
  803bbd:	8b 08                	mov    (%eax),%ecx
  803bbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bc2:	89 d0                	mov    %edx,%eax
  803bc4:	01 c0                	add    %eax,%eax
  803bc6:	01 d0                	add    %edx,%eax
  803bc8:	c1 e0 02             	shl    $0x2,%eax
  803bcb:	05 44 40 81 00       	add    $0x814044,%eax
  803bd0:	8b 00                	mov    (%eax),%eax
  803bd2:	01 c1                	add    %eax,%ecx
  803bd4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bd7:	89 d0                	mov    %edx,%eax
  803bd9:	01 c0                	add    %eax,%eax
  803bdb:	01 d0                	add    %edx,%eax
  803bdd:	c1 e0 02             	shl    $0x2,%eax
  803be0:	05 40 40 81 00       	add    $0x814040,%eax
  803be5:	8b 00                	mov    (%eax),%eax
  803be7:	39 c1                	cmp    %eax,%ecx
  803be9:	75 7a                	jne    803c65 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  803beb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bee:	89 d0                	mov    %edx,%eax
  803bf0:	01 c0                	add    %eax,%eax
  803bf2:	01 d0                	add    %edx,%eax
  803bf4:	c1 e0 02             	shl    $0x2,%eax
  803bf7:	05 40 40 81 00       	add    $0x814040,%eax
  803bfc:	8b 10                	mov    (%eax),%edx
  803bfe:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803c01:	89 c8                	mov    %ecx,%eax
  803c03:	01 c0                	add    %eax,%eax
  803c05:	01 c8                	add    %ecx,%eax
  803c07:	c1 e0 02             	shl    $0x2,%eax
  803c0a:	05 40 40 81 00       	add    $0x814040,%eax
  803c0f:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  803c11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c14:	89 d0                	mov    %edx,%eax
  803c16:	01 c0                	add    %eax,%eax
  803c18:	01 d0                	add    %edx,%eax
  803c1a:	c1 e0 02             	shl    $0x2,%eax
  803c1d:	05 44 40 81 00       	add    $0x814044,%eax
  803c22:	8b 08                	mov    (%eax),%ecx
  803c24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c27:	89 d0                	mov    %edx,%eax
  803c29:	01 c0                	add    %eax,%eax
  803c2b:	01 d0                	add    %edx,%eax
  803c2d:	c1 e0 02             	shl    $0x2,%eax
  803c30:	05 44 40 81 00       	add    $0x814044,%eax
  803c35:	8b 00                	mov    (%eax),%eax
  803c37:	01 c1                	add    %eax,%ecx
  803c39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c3c:	89 d0                	mov    %edx,%eax
  803c3e:	01 c0                	add    %eax,%eax
  803c40:	01 d0                	add    %edx,%eax
  803c42:	c1 e0 02             	shl    $0x2,%eax
  803c45:	05 44 40 81 00       	add    $0x814044,%eax
  803c4a:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  803c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c4f:	89 d0                	mov    %edx,%eax
  803c51:	01 c0                	add    %eax,%eax
  803c53:	01 d0                	add    %edx,%eax
  803c55:	c1 e0 02             	shl    $0x2,%eax
  803c58:	05 48 40 81 00       	add    $0x814048,%eax
  803c5d:	c6 00 00             	movb   $0x0,(%eax)
  803c60:	e9 91 00 00 00       	jmp    803cf6 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803c65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c68:	89 d0                	mov    %edx,%eax
  803c6a:	01 c0                	add    %eax,%eax
  803c6c:	01 d0                	add    %edx,%eax
  803c6e:	c1 e0 02             	shl    $0x2,%eax
  803c71:	05 40 40 81 00       	add    $0x814040,%eax
  803c76:	8b 08                	mov    (%eax),%ecx
  803c78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c7b:	89 d0                	mov    %edx,%eax
  803c7d:	01 c0                	add    %eax,%eax
  803c7f:	01 d0                	add    %edx,%eax
  803c81:	c1 e0 02             	shl    $0x2,%eax
  803c84:	05 44 40 81 00       	add    $0x814044,%eax
  803c89:	8b 00                	mov    (%eax),%eax
  803c8b:	01 c1                	add    %eax,%ecx
  803c8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c90:	89 d0                	mov    %edx,%eax
  803c92:	01 c0                	add    %eax,%eax
  803c94:	01 d0                	add    %edx,%eax
  803c96:	c1 e0 02             	shl    $0x2,%eax
  803c99:	05 40 40 81 00       	add    $0x814040,%eax
  803c9e:	8b 00                	mov    (%eax),%eax
  803ca0:	39 c1                	cmp    %eax,%ecx
  803ca2:	75 52                	jne    803cf6 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  803ca4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ca7:	89 d0                	mov    %edx,%eax
  803ca9:	01 c0                	add    %eax,%eax
  803cab:	01 d0                	add    %edx,%eax
  803cad:	c1 e0 02             	shl    $0x2,%eax
  803cb0:	05 44 40 81 00       	add    $0x814044,%eax
  803cb5:	8b 08                	mov    (%eax),%ecx
  803cb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cba:	89 d0                	mov    %edx,%eax
  803cbc:	01 c0                	add    %eax,%eax
  803cbe:	01 d0                	add    %edx,%eax
  803cc0:	c1 e0 02             	shl    $0x2,%eax
  803cc3:	05 44 40 81 00       	add    $0x814044,%eax
  803cc8:	8b 00                	mov    (%eax),%eax
  803cca:	01 c1                	add    %eax,%ecx
  803ccc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ccf:	89 d0                	mov    %edx,%eax
  803cd1:	01 c0                	add    %eax,%eax
  803cd3:	01 d0                	add    %edx,%eax
  803cd5:	c1 e0 02             	shl    $0x2,%eax
  803cd8:	05 44 40 81 00       	add    $0x814044,%eax
  803cdd:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  803cdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ce2:	89 d0                	mov    %edx,%eax
  803ce4:	01 c0                	add    %eax,%eax
  803ce6:	01 d0                	add    %edx,%eax
  803ce8:	c1 e0 02             	shl    $0x2,%eax
  803ceb:	05 48 40 81 00       	add    $0x814048,%eax
  803cf0:	c6 00 00             	movb   $0x0,(%eax)
  803cf3:	eb 01                	jmp    803cf6 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  803cf5:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803cf6:	ff 45 e0             	incl   -0x20(%ebp)
  803cf9:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803d00:	0f 8e 7f fe ff ff    	jle    803b85 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  803d06:	a1 30 81 83 00       	mov    0x838130,%eax
  803d0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803d0e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  803d15:	eb 53                	jmp    803d6a <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  803d17:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d1a:	89 d0                	mov    %edx,%eax
  803d1c:	01 c0                	add    %eax,%eax
  803d1e:	01 d0                	add    %edx,%eax
  803d20:	c1 e0 02             	shl    $0x2,%eax
  803d23:	05 48 80 80 00       	add    $0x808048,%eax
  803d28:	8a 00                	mov    (%eax),%al
  803d2a:	84 c0                	test   %al,%al
  803d2c:	74 39                	je     803d67 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803d2e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d31:	89 d0                	mov    %edx,%eax
  803d33:	01 c0                	add    %eax,%eax
  803d35:	01 d0                	add    %edx,%eax
  803d37:	c1 e0 02             	shl    $0x2,%eax
  803d3a:	05 40 80 80 00       	add    $0x808040,%eax
  803d3f:	8b 08                	mov    (%eax),%ecx
  803d41:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d44:	89 d0                	mov    %edx,%eax
  803d46:	01 c0                	add    %eax,%eax
  803d48:	01 d0                	add    %edx,%eax
  803d4a:	c1 e0 02             	shl    $0x2,%eax
  803d4d:	05 44 80 80 00       	add    $0x808044,%eax
  803d52:	8b 00                	mov    (%eax),%eax
  803d54:	01 c8                	add    %ecx,%eax
  803d56:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  803d59:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803d5c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803d5f:	76 06                	jbe    803d67 <realloc+0x453>
  803d61:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803d64:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803d67:	ff 45 d8             	incl   -0x28(%ebp)
  803d6a:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  803d71:	7e a4                	jle    803d17 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  803d73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d76:	a3 88 80 83 00       	mov    %eax,0x838088
		return virtual_address;
  803d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7e:	e9 a9 01 00 00       	jmp    803f2c <realloc+0x618>
	}
	uint32 end = va + oldsz;
  803d83:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d89:	01 d0                	add    %edx,%eax
  803d8b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  803d8e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803d95:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  803d9c:	eb 57                	jmp    803df5 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  803d9e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803da1:	89 d0                	mov    %edx,%eax
  803da3:	01 c0                	add    %eax,%eax
  803da5:	01 d0                	add    %edx,%eax
  803da7:	c1 e0 02             	shl    $0x2,%eax
  803daa:	05 48 40 81 00       	add    $0x814048,%eax
  803daf:	8a 00                	mov    (%eax),%al
  803db1:	84 c0                	test   %al,%al
  803db3:	74 3d                	je     803df2 <realloc+0x4de>
  803db5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803db8:	89 d0                	mov    %edx,%eax
  803dba:	01 c0                	add    %eax,%eax
  803dbc:	01 d0                	add    %edx,%eax
  803dbe:	c1 e0 02             	shl    $0x2,%eax
  803dc1:	05 40 40 81 00       	add    $0x814040,%eax
  803dc6:	8b 00                	mov    (%eax),%eax
  803dc8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803dcb:	75 25                	jne    803df2 <realloc+0x4de>
  803dcd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803dd0:	89 d0                	mov    %edx,%eax
  803dd2:	01 c0                	add    %eax,%eax
  803dd4:	01 d0                	add    %edx,%eax
  803dd6:	c1 e0 02             	shl    $0x2,%eax
  803dd9:	05 44 40 81 00       	add    $0x814044,%eax
  803dde:	8b 10                	mov    (%eax),%edx
  803de0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803de3:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803de6:	39 c2                	cmp    %eax,%edx
  803de8:	72 08                	jb     803df2 <realloc+0x4de>
		{
			adjIdx = j; break;
  803dea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ded:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803df0:	eb 0c                	jmp    803dfe <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803df2:	ff 45 d0             	incl   -0x30(%ebp)
  803df5:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  803dfc:	7e a0                	jle    803d9e <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  803dfe:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  803e02:	0f 84 d6 00 00 00    	je     803ede <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  803e08:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803e0b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803e0e:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  803e11:	83 ec 08             	sub    $0x8,%esp
  803e14:	ff 75 a0             	pushl  -0x60(%ebp)
  803e17:	ff 75 a4             	pushl  -0x5c(%ebp)
  803e1a:	e8 cf 09 00 00       	call   8047ee <sys_allocate_user_mem>
  803e1f:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  803e22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e25:	89 d0                	mov    %edx,%eax
  803e27:	01 c0                	add    %eax,%eax
  803e29:	01 d0                	add    %edx,%eax
  803e2b:	c1 e0 02             	shl    $0x2,%eax
  803e2e:	8d 90 44 80 80 00    	lea    0x808044(%eax),%edx
  803e34:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803e37:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  803e39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e3c:	89 d0                	mov    %edx,%eax
  803e3e:	01 c0                	add    %eax,%eax
  803e40:	01 d0                	add    %edx,%eax
  803e42:	c1 e0 02             	shl    $0x2,%eax
  803e45:	05 40 40 81 00       	add    $0x814040,%eax
  803e4a:	8b 10                	mov    (%eax),%edx
  803e4c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803e4f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  803e52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e55:	89 d0                	mov    %edx,%eax
  803e57:	01 c0                	add    %eax,%eax
  803e59:	01 d0                	add    %edx,%eax
  803e5b:	c1 e0 02             	shl    $0x2,%eax
  803e5e:	05 40 40 81 00       	add    $0x814040,%eax
  803e63:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  803e65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e68:	89 d0                	mov    %edx,%eax
  803e6a:	01 c0                	add    %eax,%eax
  803e6c:	01 d0                	add    %edx,%eax
  803e6e:	c1 e0 02             	shl    $0x2,%eax
  803e71:	05 44 40 81 00       	add    $0x814044,%eax
  803e76:	8b 00                	mov    (%eax),%eax
  803e78:	2b 45 a0             	sub    -0x60(%ebp),%eax
  803e7b:	89 c2                	mov    %eax,%edx
  803e7d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803e80:	89 c8                	mov    %ecx,%eax
  803e82:	01 c0                	add    %eax,%eax
  803e84:	01 c8                	add    %ecx,%eax
  803e86:	c1 e0 02             	shl    $0x2,%eax
  803e89:	05 44 40 81 00       	add    $0x814044,%eax
  803e8e:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  803e90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e93:	89 d0                	mov    %edx,%eax
  803e95:	01 c0                	add    %eax,%eax
  803e97:	01 d0                	add    %edx,%eax
  803e99:	c1 e0 02             	shl    $0x2,%eax
  803e9c:	05 44 40 81 00       	add    $0x814044,%eax
  803ea1:	8b 00                	mov    (%eax),%eax
  803ea3:	85 c0                	test   %eax,%eax
  803ea5:	75 14                	jne    803ebb <realloc+0x5a7>
  803ea7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803eaa:	89 d0                	mov    %edx,%eax
  803eac:	01 c0                	add    %eax,%eax
  803eae:	01 d0                	add    %edx,%eax
  803eb0:	c1 e0 02             	shl    $0x2,%eax
  803eb3:	05 48 40 81 00       	add    $0x814048,%eax
  803eb8:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  803ebb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803ebe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803ec1:	01 c2                	add    %eax,%edx
  803ec3:	a1 88 80 83 00       	mov    0x838088,%eax
  803ec8:	39 c2                	cmp    %eax,%edx
  803eca:	76 0d                	jbe    803ed9 <realloc+0x5c5>
  803ecc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803ecf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803ed2:	01 d0                	add    %edx,%eax
  803ed4:	a3 88 80 83 00       	mov    %eax,0x838088
		return virtual_address;
  803ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  803edc:	eb 4e                	jmp    803f2c <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  803ede:	83 ec 0c             	sub    $0xc,%esp
  803ee1:	ff 75 0c             	pushl  0xc(%ebp)
  803ee4:	e8 0b ec ff ff       	call   802af4 <malloc>
  803ee9:	83 c4 10             	add    $0x10,%esp
  803eec:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  803eef:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  803ef3:	75 07                	jne    803efc <realloc+0x5e8>
		return NULL;
  803ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  803efa:	eb 30                	jmp    803f2c <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  803efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803f02:	39 d0                	cmp    %edx,%eax
  803f04:	76 02                	jbe    803f08 <realloc+0x5f4>
  803f06:	89 d0                	mov    %edx,%eax
  803f08:	8b 55 9c             	mov    -0x64(%ebp),%edx
  803f0b:	83 ec 04             	sub    $0x4,%esp
  803f0e:	50                   	push   %eax
  803f0f:	52                   	push   %edx
  803f10:	ff 75 cc             	pushl  -0x34(%ebp)
  803f13:	e8 cf 06 00 00       	call   8045e7 <sys_move_user_mem>
  803f18:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  803f1b:	83 ec 0c             	sub    $0xc,%esp
  803f1e:	ff 75 08             	pushl  0x8(%ebp)
  803f21:	e8 2e ef ff ff       	call   802e54 <free>
  803f26:	83 c4 10             	add    $0x10,%esp
	return newptr;
  803f29:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  803f2c:	c9                   	leave  
  803f2d:	c3                   	ret    

00803f2e <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803f2e:	55                   	push   %ebp
  803f2f:	89 e5                	mov    %esp,%ebp
  803f31:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  803f34:	8b 45 08             	mov    0x8(%ebp),%eax
  803f37:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  803f3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f3e:	0f 84 33 03 00 00    	je     804277 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  803f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f47:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  803f4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  803f4f:	83 ec 08             	sub    $0x8,%esp
  803f52:	ff 75 08             	pushl  0x8(%ebp)
  803f55:	ff 75 d8             	pushl  -0x28(%ebp)
  803f58:	e8 7d 05 00 00       	call   8044da <sys_delete_shared_object>
  803f5d:	83 c4 10             	add    $0x10,%esp
  803f60:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  803f63:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f67:	0f 88 0d 03 00 00    	js     80427a <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803f6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803f74:	e9 ef 02 00 00       	jmp    804268 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f7c:	89 d0                	mov    %edx,%eax
  803f7e:	01 c0                	add    %eax,%eax
  803f80:	01 d0                	add    %edx,%eax
  803f82:	c1 e0 02             	shl    $0x2,%eax
  803f85:	05 48 80 80 00       	add    $0x808048,%eax
  803f8a:	8a 00                	mov    (%eax),%al
  803f8c:	84 c0                	test   %al,%al
  803f8e:	0f 84 d1 02 00 00    	je     804265 <sfree+0x337>
  803f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f97:	89 d0                	mov    %edx,%eax
  803f99:	01 c0                	add    %eax,%eax
  803f9b:	01 d0                	add    %edx,%eax
  803f9d:	c1 e0 02             	shl    $0x2,%eax
  803fa0:	05 40 80 80 00       	add    $0x808040,%eax
  803fa5:	8b 00                	mov    (%eax),%eax
  803fa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803faa:	0f 85 b5 02 00 00    	jne    804265 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fb3:	89 d0                	mov    %edx,%eax
  803fb5:	01 c0                	add    %eax,%eax
  803fb7:	01 d0                	add    %edx,%eax
  803fb9:	c1 e0 02             	shl    $0x2,%eax
  803fbc:	05 44 80 80 00       	add    $0x808044,%eax
  803fc1:	8b 00                	mov    (%eax),%eax
  803fc3:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fc9:	89 d0                	mov    %edx,%eax
  803fcb:	01 c0                	add    %eax,%eax
  803fcd:	01 d0                	add    %edx,%eax
  803fcf:	c1 e0 02             	shl    $0x2,%eax
  803fd2:	05 48 80 80 00       	add    $0x808048,%eax
  803fd7:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  803fda:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803fe1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803fe8:	eb 64                	jmp    80404e <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  803fea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fed:	89 d0                	mov    %edx,%eax
  803fef:	01 c0                	add    %eax,%eax
  803ff1:	01 d0                	add    %edx,%eax
  803ff3:	c1 e0 02             	shl    $0x2,%eax
  803ff6:	05 48 40 81 00       	add    $0x814048,%eax
  803ffb:	8a 00                	mov    (%eax),%al
  803ffd:	84 c0                	test   %al,%al
  803fff:	75 4a                	jne    80404b <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  804001:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804004:	89 d0                	mov    %edx,%eax
  804006:	01 c0                	add    %eax,%eax
  804008:	01 d0                	add    %edx,%eax
  80400a:	c1 e0 02             	shl    $0x2,%eax
  80400d:	8d 90 40 40 81 00    	lea    0x814040(%eax),%edx
  804013:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804016:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  804018:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80401b:	89 d0                	mov    %edx,%eax
  80401d:	01 c0                	add    %eax,%eax
  80401f:	01 d0                	add    %edx,%eax
  804021:	c1 e0 02             	shl    $0x2,%eax
  804024:	8d 90 44 40 81 00    	lea    0x814044(%eax),%edx
  80402a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80402d:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  80402f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804032:	89 d0                	mov    %edx,%eax
  804034:	01 c0                	add    %eax,%eax
  804036:	01 d0                	add    %edx,%eax
  804038:	c1 e0 02             	shl    $0x2,%eax
  80403b:	05 48 40 81 00       	add    $0x814048,%eax
  804040:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  804043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804046:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  804049:	eb 0c                	jmp    804057 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80404b:	ff 45 ec             	incl   -0x14(%ebp)
  80404e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  804055:	7e 93                	jle    803fea <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  804057:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80405b:	0f 84 8d 01 00 00    	je     8041ee <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  804061:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804068:	e9 74 01 00 00       	jmp    8041e1 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  80406d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804070:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804073:	0f 84 64 01 00 00    	je     8041dd <sfree+0x2af>
					if (uhp_frees[k].free)
  804079:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80407c:	89 d0                	mov    %edx,%eax
  80407e:	01 c0                	add    %eax,%eax
  804080:	01 d0                	add    %edx,%eax
  804082:	c1 e0 02             	shl    $0x2,%eax
  804085:	05 48 40 81 00       	add    $0x814048,%eax
  80408a:	8a 00                	mov    (%eax),%al
  80408c:	84 c0                	test   %al,%al
  80408e:	0f 84 4a 01 00 00    	je     8041de <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  804094:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804097:	89 d0                	mov    %edx,%eax
  804099:	01 c0                	add    %eax,%eax
  80409b:	01 d0                	add    %edx,%eax
  80409d:	c1 e0 02             	shl    $0x2,%eax
  8040a0:	05 40 40 81 00       	add    $0x814040,%eax
  8040a5:	8b 08                	mov    (%eax),%ecx
  8040a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8040aa:	89 d0                	mov    %edx,%eax
  8040ac:	01 c0                	add    %eax,%eax
  8040ae:	01 d0                	add    %edx,%eax
  8040b0:	c1 e0 02             	shl    $0x2,%eax
  8040b3:	05 44 40 81 00       	add    $0x814044,%eax
  8040b8:	8b 00                	mov    (%eax),%eax
  8040ba:	01 c1                	add    %eax,%ecx
  8040bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040bf:	89 d0                	mov    %edx,%eax
  8040c1:	01 c0                	add    %eax,%eax
  8040c3:	01 d0                	add    %edx,%eax
  8040c5:	c1 e0 02             	shl    $0x2,%eax
  8040c8:	05 40 40 81 00       	add    $0x814040,%eax
  8040cd:	8b 00                	mov    (%eax),%eax
  8040cf:	39 c1                	cmp    %eax,%ecx
  8040d1:	75 7a                	jne    80414d <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  8040d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8040d6:	89 d0                	mov    %edx,%eax
  8040d8:	01 c0                	add    %eax,%eax
  8040da:	01 d0                	add    %edx,%eax
  8040dc:	c1 e0 02             	shl    $0x2,%eax
  8040df:	05 40 40 81 00       	add    $0x814040,%eax
  8040e4:	8b 10                	mov    (%eax),%edx
  8040e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8040e9:	89 c8                	mov    %ecx,%eax
  8040eb:	01 c0                	add    %eax,%eax
  8040ed:	01 c8                	add    %ecx,%eax
  8040ef:	c1 e0 02             	shl    $0x2,%eax
  8040f2:	05 40 40 81 00       	add    $0x814040,%eax
  8040f7:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  8040f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040fc:	89 d0                	mov    %edx,%eax
  8040fe:	01 c0                	add    %eax,%eax
  804100:	01 d0                	add    %edx,%eax
  804102:	c1 e0 02             	shl    $0x2,%eax
  804105:	05 44 40 81 00       	add    $0x814044,%eax
  80410a:	8b 08                	mov    (%eax),%ecx
  80410c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80410f:	89 d0                	mov    %edx,%eax
  804111:	01 c0                	add    %eax,%eax
  804113:	01 d0                	add    %edx,%eax
  804115:	c1 e0 02             	shl    $0x2,%eax
  804118:	05 44 40 81 00       	add    $0x814044,%eax
  80411d:	8b 00                	mov    (%eax),%eax
  80411f:	01 c1                	add    %eax,%ecx
  804121:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804124:	89 d0                	mov    %edx,%eax
  804126:	01 c0                	add    %eax,%eax
  804128:	01 d0                	add    %edx,%eax
  80412a:	c1 e0 02             	shl    $0x2,%eax
  80412d:	05 44 40 81 00       	add    $0x814044,%eax
  804132:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  804134:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804137:	89 d0                	mov    %edx,%eax
  804139:	01 c0                	add    %eax,%eax
  80413b:	01 d0                	add    %edx,%eax
  80413d:	c1 e0 02             	shl    $0x2,%eax
  804140:	05 48 40 81 00       	add    $0x814048,%eax
  804145:	c6 00 00             	movb   $0x0,(%eax)
  804148:	e9 91 00 00 00       	jmp    8041de <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80414d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804150:	89 d0                	mov    %edx,%eax
  804152:	01 c0                	add    %eax,%eax
  804154:	01 d0                	add    %edx,%eax
  804156:	c1 e0 02             	shl    $0x2,%eax
  804159:	05 40 40 81 00       	add    $0x814040,%eax
  80415e:	8b 08                	mov    (%eax),%ecx
  804160:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804163:	89 d0                	mov    %edx,%eax
  804165:	01 c0                	add    %eax,%eax
  804167:	01 d0                	add    %edx,%eax
  804169:	c1 e0 02             	shl    $0x2,%eax
  80416c:	05 44 40 81 00       	add    $0x814044,%eax
  804171:	8b 00                	mov    (%eax),%eax
  804173:	01 c1                	add    %eax,%ecx
  804175:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804178:	89 d0                	mov    %edx,%eax
  80417a:	01 c0                	add    %eax,%eax
  80417c:	01 d0                	add    %edx,%eax
  80417e:	c1 e0 02             	shl    $0x2,%eax
  804181:	05 40 40 81 00       	add    $0x814040,%eax
  804186:	8b 00                	mov    (%eax),%eax
  804188:	39 c1                	cmp    %eax,%ecx
  80418a:	75 52                	jne    8041de <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  80418c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80418f:	89 d0                	mov    %edx,%eax
  804191:	01 c0                	add    %eax,%eax
  804193:	01 d0                	add    %edx,%eax
  804195:	c1 e0 02             	shl    $0x2,%eax
  804198:	05 44 40 81 00       	add    $0x814044,%eax
  80419d:	8b 08                	mov    (%eax),%ecx
  80419f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041a2:	89 d0                	mov    %edx,%eax
  8041a4:	01 c0                	add    %eax,%eax
  8041a6:	01 d0                	add    %edx,%eax
  8041a8:	c1 e0 02             	shl    $0x2,%eax
  8041ab:	05 44 40 81 00       	add    $0x814044,%eax
  8041b0:	8b 00                	mov    (%eax),%eax
  8041b2:	01 c1                	add    %eax,%ecx
  8041b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041b7:	89 d0                	mov    %edx,%eax
  8041b9:	01 c0                	add    %eax,%eax
  8041bb:	01 d0                	add    %edx,%eax
  8041bd:	c1 e0 02             	shl    $0x2,%eax
  8041c0:	05 44 40 81 00       	add    $0x814044,%eax
  8041c5:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8041c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041ca:	89 d0                	mov    %edx,%eax
  8041cc:	01 c0                	add    %eax,%eax
  8041ce:	01 d0                	add    %edx,%eax
  8041d0:	c1 e0 02             	shl    $0x2,%eax
  8041d3:	05 48 40 81 00       	add    $0x814048,%eax
  8041d8:	c6 00 00             	movb   $0x0,(%eax)
  8041db:	eb 01                	jmp    8041de <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  8041dd:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8041de:	ff 45 e8             	incl   -0x18(%ebp)
  8041e1:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8041e8:	0f 8e 7f fe ff ff    	jle    80406d <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  8041ee:	a1 30 81 83 00       	mov    0x838130,%eax
  8041f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8041f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8041fd:	eb 53                	jmp    804252 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  8041ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804202:	89 d0                	mov    %edx,%eax
  804204:	01 c0                	add    %eax,%eax
  804206:	01 d0                	add    %edx,%eax
  804208:	c1 e0 02             	shl    $0x2,%eax
  80420b:	05 48 80 80 00       	add    $0x808048,%eax
  804210:	8a 00                	mov    (%eax),%al
  804212:	84 c0                	test   %al,%al
  804214:	74 39                	je     80424f <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  804216:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804219:	89 d0                	mov    %edx,%eax
  80421b:	01 c0                	add    %eax,%eax
  80421d:	01 d0                	add    %edx,%eax
  80421f:	c1 e0 02             	shl    $0x2,%eax
  804222:	05 40 80 80 00       	add    $0x808040,%eax
  804227:	8b 08                	mov    (%eax),%ecx
  804229:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80422c:	89 d0                	mov    %edx,%eax
  80422e:	01 c0                	add    %eax,%eax
  804230:	01 d0                	add    %edx,%eax
  804232:	c1 e0 02             	shl    $0x2,%eax
  804235:	05 44 80 80 00       	add    $0x808044,%eax
  80423a:	8b 00                	mov    (%eax),%eax
  80423c:	01 c8                	add    %ecx,%eax
  80423e:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  804241:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804244:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804247:	76 06                	jbe    80424f <sfree+0x321>
  804249:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80424c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80424f:	ff 45 e0             	incl   -0x20(%ebp)
  804252:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  804259:	7e a4                	jle    8041ff <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  80425b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80425e:	a3 88 80 83 00       	mov    %eax,0x838088
			break;
  804263:	eb 16                	jmp    80427b <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  804265:	ff 45 f4             	incl   -0xc(%ebp)
  804268:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  80426f:	0f 8e 04 fd ff ff    	jle    803f79 <sfree+0x4b>
  804275:	eb 04                	jmp    80427b <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  804277:	90                   	nop
  804278:	eb 01                	jmp    80427b <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  80427a:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  80427b:	c9                   	leave  
  80427c:	c3                   	ret    

0080427d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80427d:	55                   	push   %ebp
  80427e:	89 e5                	mov    %esp,%ebp
  804280:	57                   	push   %edi
  804281:	56                   	push   %esi
  804282:	53                   	push   %ebx
  804283:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804286:	8b 45 08             	mov    0x8(%ebp),%eax
  804289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80428c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80428f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804292:	8b 7d 18             	mov    0x18(%ebp),%edi
  804295:	8b 75 1c             	mov    0x1c(%ebp),%esi
  804298:	cd 30                	int    $0x30
  80429a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80429d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8042a0:	83 c4 10             	add    $0x10,%esp
  8042a3:	5b                   	pop    %ebx
  8042a4:	5e                   	pop    %esi
  8042a5:	5f                   	pop    %edi
  8042a6:	5d                   	pop    %ebp
  8042a7:	c3                   	ret    

008042a8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8042a8:	55                   	push   %ebp
  8042a9:	89 e5                	mov    %esp,%ebp
  8042ab:	83 ec 04             	sub    $0x4,%esp
  8042ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8042b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8042b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8042b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8042bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8042be:	6a 00                	push   $0x0
  8042c0:	51                   	push   %ecx
  8042c1:	52                   	push   %edx
  8042c2:	ff 75 0c             	pushl  0xc(%ebp)
  8042c5:	50                   	push   %eax
  8042c6:	6a 00                	push   $0x0
  8042c8:	e8 b0 ff ff ff       	call   80427d <syscall>
  8042cd:	83 c4 18             	add    $0x18,%esp
}
  8042d0:	90                   	nop
  8042d1:	c9                   	leave  
  8042d2:	c3                   	ret    

008042d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8042d3:	55                   	push   %ebp
  8042d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8042d6:	6a 00                	push   $0x0
  8042d8:	6a 00                	push   $0x0
  8042da:	6a 00                	push   $0x0
  8042dc:	6a 00                	push   $0x0
  8042de:	6a 00                	push   $0x0
  8042e0:	6a 02                	push   $0x2
  8042e2:	e8 96 ff ff ff       	call   80427d <syscall>
  8042e7:	83 c4 18             	add    $0x18,%esp
}
  8042ea:	c9                   	leave  
  8042eb:	c3                   	ret    

008042ec <sys_lock_cons>:

void sys_lock_cons(void)
{
  8042ec:	55                   	push   %ebp
  8042ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8042ef:	6a 00                	push   $0x0
  8042f1:	6a 00                	push   $0x0
  8042f3:	6a 00                	push   $0x0
  8042f5:	6a 00                	push   $0x0
  8042f7:	6a 00                	push   $0x0
  8042f9:	6a 03                	push   $0x3
  8042fb:	e8 7d ff ff ff       	call   80427d <syscall>
  804300:	83 c4 18             	add    $0x18,%esp
}
  804303:	90                   	nop
  804304:	c9                   	leave  
  804305:	c3                   	ret    

00804306 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  804306:	55                   	push   %ebp
  804307:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  804309:	6a 00                	push   $0x0
  80430b:	6a 00                	push   $0x0
  80430d:	6a 00                	push   $0x0
  80430f:	6a 00                	push   $0x0
  804311:	6a 00                	push   $0x0
  804313:	6a 04                	push   $0x4
  804315:	e8 63 ff ff ff       	call   80427d <syscall>
  80431a:	83 c4 18             	add    $0x18,%esp
}
  80431d:	90                   	nop
  80431e:	c9                   	leave  
  80431f:	c3                   	ret    

00804320 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  804320:	55                   	push   %ebp
  804321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  804323:	8b 55 0c             	mov    0xc(%ebp),%edx
  804326:	8b 45 08             	mov    0x8(%ebp),%eax
  804329:	6a 00                	push   $0x0
  80432b:	6a 00                	push   $0x0
  80432d:	6a 00                	push   $0x0
  80432f:	52                   	push   %edx
  804330:	50                   	push   %eax
  804331:	6a 08                	push   $0x8
  804333:	e8 45 ff ff ff       	call   80427d <syscall>
  804338:	83 c4 18             	add    $0x18,%esp
}
  80433b:	c9                   	leave  
  80433c:	c3                   	ret    

0080433d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80433d:	55                   	push   %ebp
  80433e:	89 e5                	mov    %esp,%ebp
  804340:	56                   	push   %esi
  804341:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  804342:	8b 75 18             	mov    0x18(%ebp),%esi
  804345:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804348:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80434b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80434e:	8b 45 08             	mov    0x8(%ebp),%eax
  804351:	56                   	push   %esi
  804352:	53                   	push   %ebx
  804353:	51                   	push   %ecx
  804354:	52                   	push   %edx
  804355:	50                   	push   %eax
  804356:	6a 09                	push   $0x9
  804358:	e8 20 ff ff ff       	call   80427d <syscall>
  80435d:	83 c4 18             	add    $0x18,%esp
}
  804360:	8d 65 f8             	lea    -0x8(%ebp),%esp
  804363:	5b                   	pop    %ebx
  804364:	5e                   	pop    %esi
  804365:	5d                   	pop    %ebp
  804366:	c3                   	ret    

00804367 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  804367:	55                   	push   %ebp
  804368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80436a:	6a 00                	push   $0x0
  80436c:	6a 00                	push   $0x0
  80436e:	6a 00                	push   $0x0
  804370:	6a 00                	push   $0x0
  804372:	ff 75 08             	pushl  0x8(%ebp)
  804375:	6a 0a                	push   $0xa
  804377:	e8 01 ff ff ff       	call   80427d <syscall>
  80437c:	83 c4 18             	add    $0x18,%esp
}
  80437f:	c9                   	leave  
  804380:	c3                   	ret    

00804381 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  804381:	55                   	push   %ebp
  804382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  804384:	6a 00                	push   $0x0
  804386:	6a 00                	push   $0x0
  804388:	6a 00                	push   $0x0
  80438a:	ff 75 0c             	pushl  0xc(%ebp)
  80438d:	ff 75 08             	pushl  0x8(%ebp)
  804390:	6a 0b                	push   $0xb
  804392:	e8 e6 fe ff ff       	call   80427d <syscall>
  804397:	83 c4 18             	add    $0x18,%esp
}
  80439a:	c9                   	leave  
  80439b:	c3                   	ret    

0080439c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80439c:	55                   	push   %ebp
  80439d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80439f:	6a 00                	push   $0x0
  8043a1:	6a 00                	push   $0x0
  8043a3:	6a 00                	push   $0x0
  8043a5:	6a 00                	push   $0x0
  8043a7:	6a 00                	push   $0x0
  8043a9:	6a 0c                	push   $0xc
  8043ab:	e8 cd fe ff ff       	call   80427d <syscall>
  8043b0:	83 c4 18             	add    $0x18,%esp
}
  8043b3:	c9                   	leave  
  8043b4:	c3                   	ret    

008043b5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8043b5:	55                   	push   %ebp
  8043b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8043b8:	6a 00                	push   $0x0
  8043ba:	6a 00                	push   $0x0
  8043bc:	6a 00                	push   $0x0
  8043be:	6a 00                	push   $0x0
  8043c0:	6a 00                	push   $0x0
  8043c2:	6a 0d                	push   $0xd
  8043c4:	e8 b4 fe ff ff       	call   80427d <syscall>
  8043c9:	83 c4 18             	add    $0x18,%esp
}
  8043cc:	c9                   	leave  
  8043cd:	c3                   	ret    

008043ce <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8043ce:	55                   	push   %ebp
  8043cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8043d1:	6a 00                	push   $0x0
  8043d3:	6a 00                	push   $0x0
  8043d5:	6a 00                	push   $0x0
  8043d7:	6a 00                	push   $0x0
  8043d9:	6a 00                	push   $0x0
  8043db:	6a 0e                	push   $0xe
  8043dd:	e8 9b fe ff ff       	call   80427d <syscall>
  8043e2:	83 c4 18             	add    $0x18,%esp
}
  8043e5:	c9                   	leave  
  8043e6:	c3                   	ret    

008043e7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8043e7:	55                   	push   %ebp
  8043e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8043ea:	6a 00                	push   $0x0
  8043ec:	6a 00                	push   $0x0
  8043ee:	6a 00                	push   $0x0
  8043f0:	6a 00                	push   $0x0
  8043f2:	6a 00                	push   $0x0
  8043f4:	6a 0f                	push   $0xf
  8043f6:	e8 82 fe ff ff       	call   80427d <syscall>
  8043fb:	83 c4 18             	add    $0x18,%esp
}
  8043fe:	c9                   	leave  
  8043ff:	c3                   	ret    

00804400 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  804400:	55                   	push   %ebp
  804401:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  804403:	6a 00                	push   $0x0
  804405:	6a 00                	push   $0x0
  804407:	6a 00                	push   $0x0
  804409:	6a 00                	push   $0x0
  80440b:	ff 75 08             	pushl  0x8(%ebp)
  80440e:	6a 10                	push   $0x10
  804410:	e8 68 fe ff ff       	call   80427d <syscall>
  804415:	83 c4 18             	add    $0x18,%esp
}
  804418:	c9                   	leave  
  804419:	c3                   	ret    

0080441a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80441a:	55                   	push   %ebp
  80441b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80441d:	6a 00                	push   $0x0
  80441f:	6a 00                	push   $0x0
  804421:	6a 00                	push   $0x0
  804423:	6a 00                	push   $0x0
  804425:	6a 00                	push   $0x0
  804427:	6a 11                	push   $0x11
  804429:	e8 4f fe ff ff       	call   80427d <syscall>
  80442e:	83 c4 18             	add    $0x18,%esp
}
  804431:	90                   	nop
  804432:	c9                   	leave  
  804433:	c3                   	ret    

00804434 <sys_cputc>:

void
sys_cputc(const char c)
{
  804434:	55                   	push   %ebp
  804435:	89 e5                	mov    %esp,%ebp
  804437:	83 ec 04             	sub    $0x4,%esp
  80443a:	8b 45 08             	mov    0x8(%ebp),%eax
  80443d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  804440:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  804444:	6a 00                	push   $0x0
  804446:	6a 00                	push   $0x0
  804448:	6a 00                	push   $0x0
  80444a:	6a 00                	push   $0x0
  80444c:	50                   	push   %eax
  80444d:	6a 01                	push   $0x1
  80444f:	e8 29 fe ff ff       	call   80427d <syscall>
  804454:	83 c4 18             	add    $0x18,%esp
}
  804457:	90                   	nop
  804458:	c9                   	leave  
  804459:	c3                   	ret    

0080445a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80445a:	55                   	push   %ebp
  80445b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80445d:	6a 00                	push   $0x0
  80445f:	6a 00                	push   $0x0
  804461:	6a 00                	push   $0x0
  804463:	6a 00                	push   $0x0
  804465:	6a 00                	push   $0x0
  804467:	6a 14                	push   $0x14
  804469:	e8 0f fe ff ff       	call   80427d <syscall>
  80446e:	83 c4 18             	add    $0x18,%esp
}
  804471:	90                   	nop
  804472:	c9                   	leave  
  804473:	c3                   	ret    

00804474 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  804474:	55                   	push   %ebp
  804475:	89 e5                	mov    %esp,%ebp
  804477:	83 ec 04             	sub    $0x4,%esp
  80447a:	8b 45 10             	mov    0x10(%ebp),%eax
  80447d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  804480:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804483:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  804487:	8b 45 08             	mov    0x8(%ebp),%eax
  80448a:	6a 00                	push   $0x0
  80448c:	51                   	push   %ecx
  80448d:	52                   	push   %edx
  80448e:	ff 75 0c             	pushl  0xc(%ebp)
  804491:	50                   	push   %eax
  804492:	6a 15                	push   $0x15
  804494:	e8 e4 fd ff ff       	call   80427d <syscall>
  804499:	83 c4 18             	add    $0x18,%esp
}
  80449c:	c9                   	leave  
  80449d:	c3                   	ret    

0080449e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80449e:	55                   	push   %ebp
  80449f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8044a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044a7:	6a 00                	push   $0x0
  8044a9:	6a 00                	push   $0x0
  8044ab:	6a 00                	push   $0x0
  8044ad:	52                   	push   %edx
  8044ae:	50                   	push   %eax
  8044af:	6a 16                	push   $0x16
  8044b1:	e8 c7 fd ff ff       	call   80427d <syscall>
  8044b6:	83 c4 18             	add    $0x18,%esp
}
  8044b9:	c9                   	leave  
  8044ba:	c3                   	ret    

008044bb <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8044bb:	55                   	push   %ebp
  8044bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8044be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8044c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c7:	6a 00                	push   $0x0
  8044c9:	6a 00                	push   $0x0
  8044cb:	51                   	push   %ecx
  8044cc:	52                   	push   %edx
  8044cd:	50                   	push   %eax
  8044ce:	6a 17                	push   $0x17
  8044d0:	e8 a8 fd ff ff       	call   80427d <syscall>
  8044d5:	83 c4 18             	add    $0x18,%esp
}
  8044d8:	c9                   	leave  
  8044d9:	c3                   	ret    

008044da <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8044da:	55                   	push   %ebp
  8044db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8044dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8044e3:	6a 00                	push   $0x0
  8044e5:	6a 00                	push   $0x0
  8044e7:	6a 00                	push   $0x0
  8044e9:	52                   	push   %edx
  8044ea:	50                   	push   %eax
  8044eb:	6a 18                	push   $0x18
  8044ed:	e8 8b fd ff ff       	call   80427d <syscall>
  8044f2:	83 c4 18             	add    $0x18,%esp
}
  8044f5:	c9                   	leave  
  8044f6:	c3                   	ret    

008044f7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8044f7:	55                   	push   %ebp
  8044f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8044fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8044fd:	6a 00                	push   $0x0
  8044ff:	ff 75 14             	pushl  0x14(%ebp)
  804502:	ff 75 10             	pushl  0x10(%ebp)
  804505:	ff 75 0c             	pushl  0xc(%ebp)
  804508:	50                   	push   %eax
  804509:	6a 19                	push   $0x19
  80450b:	e8 6d fd ff ff       	call   80427d <syscall>
  804510:	83 c4 18             	add    $0x18,%esp
}
  804513:	c9                   	leave  
  804514:	c3                   	ret    

00804515 <sys_run_env>:

void sys_run_env(int32 envId)
{
  804515:	55                   	push   %ebp
  804516:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  804518:	8b 45 08             	mov    0x8(%ebp),%eax
  80451b:	6a 00                	push   $0x0
  80451d:	6a 00                	push   $0x0
  80451f:	6a 00                	push   $0x0
  804521:	6a 00                	push   $0x0
  804523:	50                   	push   %eax
  804524:	6a 1a                	push   $0x1a
  804526:	e8 52 fd ff ff       	call   80427d <syscall>
  80452b:	83 c4 18             	add    $0x18,%esp
}
  80452e:	90                   	nop
  80452f:	c9                   	leave  
  804530:	c3                   	ret    

00804531 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  804531:	55                   	push   %ebp
  804532:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  804534:	8b 45 08             	mov    0x8(%ebp),%eax
  804537:	6a 00                	push   $0x0
  804539:	6a 00                	push   $0x0
  80453b:	6a 00                	push   $0x0
  80453d:	6a 00                	push   $0x0
  80453f:	50                   	push   %eax
  804540:	6a 1b                	push   $0x1b
  804542:	e8 36 fd ff ff       	call   80427d <syscall>
  804547:	83 c4 18             	add    $0x18,%esp
}
  80454a:	c9                   	leave  
  80454b:	c3                   	ret    

0080454c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80454c:	55                   	push   %ebp
  80454d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80454f:	6a 00                	push   $0x0
  804551:	6a 00                	push   $0x0
  804553:	6a 00                	push   $0x0
  804555:	6a 00                	push   $0x0
  804557:	6a 00                	push   $0x0
  804559:	6a 05                	push   $0x5
  80455b:	e8 1d fd ff ff       	call   80427d <syscall>
  804560:	83 c4 18             	add    $0x18,%esp
}
  804563:	c9                   	leave  
  804564:	c3                   	ret    

00804565 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  804565:	55                   	push   %ebp
  804566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  804568:	6a 00                	push   $0x0
  80456a:	6a 00                	push   $0x0
  80456c:	6a 00                	push   $0x0
  80456e:	6a 00                	push   $0x0
  804570:	6a 00                	push   $0x0
  804572:	6a 06                	push   $0x6
  804574:	e8 04 fd ff ff       	call   80427d <syscall>
  804579:	83 c4 18             	add    $0x18,%esp
}
  80457c:	c9                   	leave  
  80457d:	c3                   	ret    

0080457e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80457e:	55                   	push   %ebp
  80457f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  804581:	6a 00                	push   $0x0
  804583:	6a 00                	push   $0x0
  804585:	6a 00                	push   $0x0
  804587:	6a 00                	push   $0x0
  804589:	6a 00                	push   $0x0
  80458b:	6a 07                	push   $0x7
  80458d:	e8 eb fc ff ff       	call   80427d <syscall>
  804592:	83 c4 18             	add    $0x18,%esp
}
  804595:	c9                   	leave  
  804596:	c3                   	ret    

00804597 <sys_exit_env>:


void sys_exit_env(void)
{
  804597:	55                   	push   %ebp
  804598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80459a:	6a 00                	push   $0x0
  80459c:	6a 00                	push   $0x0
  80459e:	6a 00                	push   $0x0
  8045a0:	6a 00                	push   $0x0
  8045a2:	6a 00                	push   $0x0
  8045a4:	6a 1c                	push   $0x1c
  8045a6:	e8 d2 fc ff ff       	call   80427d <syscall>
  8045ab:	83 c4 18             	add    $0x18,%esp
}
  8045ae:	90                   	nop
  8045af:	c9                   	leave  
  8045b0:	c3                   	ret    

008045b1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8045b1:	55                   	push   %ebp
  8045b2:	89 e5                	mov    %esp,%ebp
  8045b4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8045b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8045ba:	8d 50 04             	lea    0x4(%eax),%edx
  8045bd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8045c0:	6a 00                	push   $0x0
  8045c2:	6a 00                	push   $0x0
  8045c4:	6a 00                	push   $0x0
  8045c6:	52                   	push   %edx
  8045c7:	50                   	push   %eax
  8045c8:	6a 1d                	push   $0x1d
  8045ca:	e8 ae fc ff ff       	call   80427d <syscall>
  8045cf:	83 c4 18             	add    $0x18,%esp
	return result;
  8045d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8045d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8045d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8045db:	89 01                	mov    %eax,(%ecx)
  8045dd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8045e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e3:	c9                   	leave  
  8045e4:	c2 04 00             	ret    $0x4

008045e7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8045e7:	55                   	push   %ebp
  8045e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8045ea:	6a 00                	push   $0x0
  8045ec:	6a 00                	push   $0x0
  8045ee:	ff 75 10             	pushl  0x10(%ebp)
  8045f1:	ff 75 0c             	pushl  0xc(%ebp)
  8045f4:	ff 75 08             	pushl  0x8(%ebp)
  8045f7:	6a 13                	push   $0x13
  8045f9:	e8 7f fc ff ff       	call   80427d <syscall>
  8045fe:	83 c4 18             	add    $0x18,%esp
	return ;
  804601:	90                   	nop
}
  804602:	c9                   	leave  
  804603:	c3                   	ret    

00804604 <sys_rcr2>:
uint32 sys_rcr2()
{
  804604:	55                   	push   %ebp
  804605:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  804607:	6a 00                	push   $0x0
  804609:	6a 00                	push   $0x0
  80460b:	6a 00                	push   $0x0
  80460d:	6a 00                	push   $0x0
  80460f:	6a 00                	push   $0x0
  804611:	6a 1e                	push   $0x1e
  804613:	e8 65 fc ff ff       	call   80427d <syscall>
  804618:	83 c4 18             	add    $0x18,%esp
}
  80461b:	c9                   	leave  
  80461c:	c3                   	ret    

0080461d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80461d:	55                   	push   %ebp
  80461e:	89 e5                	mov    %esp,%ebp
  804620:	83 ec 04             	sub    $0x4,%esp
  804623:	8b 45 08             	mov    0x8(%ebp),%eax
  804626:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  804629:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80462d:	6a 00                	push   $0x0
  80462f:	6a 00                	push   $0x0
  804631:	6a 00                	push   $0x0
  804633:	6a 00                	push   $0x0
  804635:	50                   	push   %eax
  804636:	6a 1f                	push   $0x1f
  804638:	e8 40 fc ff ff       	call   80427d <syscall>
  80463d:	83 c4 18             	add    $0x18,%esp
	return ;
  804640:	90                   	nop
}
  804641:	c9                   	leave  
  804642:	c3                   	ret    

00804643 <rsttst>:
void rsttst()
{
  804643:	55                   	push   %ebp
  804644:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  804646:	6a 00                	push   $0x0
  804648:	6a 00                	push   $0x0
  80464a:	6a 00                	push   $0x0
  80464c:	6a 00                	push   $0x0
  80464e:	6a 00                	push   $0x0
  804650:	6a 21                	push   $0x21
  804652:	e8 26 fc ff ff       	call   80427d <syscall>
  804657:	83 c4 18             	add    $0x18,%esp
	return ;
  80465a:	90                   	nop
}
  80465b:	c9                   	leave  
  80465c:	c3                   	ret    

0080465d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80465d:	55                   	push   %ebp
  80465e:	89 e5                	mov    %esp,%ebp
  804660:	83 ec 04             	sub    $0x4,%esp
  804663:	8b 45 14             	mov    0x14(%ebp),%eax
  804666:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  804669:	8b 55 18             	mov    0x18(%ebp),%edx
  80466c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  804670:	52                   	push   %edx
  804671:	50                   	push   %eax
  804672:	ff 75 10             	pushl  0x10(%ebp)
  804675:	ff 75 0c             	pushl  0xc(%ebp)
  804678:	ff 75 08             	pushl  0x8(%ebp)
  80467b:	6a 20                	push   $0x20
  80467d:	e8 fb fb ff ff       	call   80427d <syscall>
  804682:	83 c4 18             	add    $0x18,%esp
	return ;
  804685:	90                   	nop
}
  804686:	c9                   	leave  
  804687:	c3                   	ret    

00804688 <chktst>:
void chktst(uint32 n)
{
  804688:	55                   	push   %ebp
  804689:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80468b:	6a 00                	push   $0x0
  80468d:	6a 00                	push   $0x0
  80468f:	6a 00                	push   $0x0
  804691:	6a 00                	push   $0x0
  804693:	ff 75 08             	pushl  0x8(%ebp)
  804696:	6a 22                	push   $0x22
  804698:	e8 e0 fb ff ff       	call   80427d <syscall>
  80469d:	83 c4 18             	add    $0x18,%esp
	return ;
  8046a0:	90                   	nop
}
  8046a1:	c9                   	leave  
  8046a2:	c3                   	ret    

008046a3 <inctst>:

void inctst()
{
  8046a3:	55                   	push   %ebp
  8046a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8046a6:	6a 00                	push   $0x0
  8046a8:	6a 00                	push   $0x0
  8046aa:	6a 00                	push   $0x0
  8046ac:	6a 00                	push   $0x0
  8046ae:	6a 00                	push   $0x0
  8046b0:	6a 23                	push   $0x23
  8046b2:	e8 c6 fb ff ff       	call   80427d <syscall>
  8046b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8046ba:	90                   	nop
}
  8046bb:	c9                   	leave  
  8046bc:	c3                   	ret    

008046bd <gettst>:
uint32 gettst()
{
  8046bd:	55                   	push   %ebp
  8046be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8046c0:	6a 00                	push   $0x0
  8046c2:	6a 00                	push   $0x0
  8046c4:	6a 00                	push   $0x0
  8046c6:	6a 00                	push   $0x0
  8046c8:	6a 00                	push   $0x0
  8046ca:	6a 24                	push   $0x24
  8046cc:	e8 ac fb ff ff       	call   80427d <syscall>
  8046d1:	83 c4 18             	add    $0x18,%esp
}
  8046d4:	c9                   	leave  
  8046d5:	c3                   	ret    

008046d6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8046d6:	55                   	push   %ebp
  8046d7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8046d9:	6a 00                	push   $0x0
  8046db:	6a 00                	push   $0x0
  8046dd:	6a 00                	push   $0x0
  8046df:	6a 00                	push   $0x0
  8046e1:	6a 00                	push   $0x0
  8046e3:	6a 25                	push   $0x25
  8046e5:	e8 93 fb ff ff       	call   80427d <syscall>
  8046ea:	83 c4 18             	add    $0x18,%esp
  8046ed:	a3 80 80 83 00       	mov    %eax,0x838080
	return uheapPlaceStrategy ;
  8046f2:	a1 80 80 83 00       	mov    0x838080,%eax
}
  8046f7:	c9                   	leave  
  8046f8:	c3                   	ret    

008046f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8046f9:	55                   	push   %ebp
  8046fa:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8046fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8046ff:	a3 80 80 83 00       	mov    %eax,0x838080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  804704:	6a 00                	push   $0x0
  804706:	6a 00                	push   $0x0
  804708:	6a 00                	push   $0x0
  80470a:	6a 00                	push   $0x0
  80470c:	ff 75 08             	pushl  0x8(%ebp)
  80470f:	6a 26                	push   $0x26
  804711:	e8 67 fb ff ff       	call   80427d <syscall>
  804716:	83 c4 18             	add    $0x18,%esp
	return ;
  804719:	90                   	nop
}
  80471a:	c9                   	leave  
  80471b:	c3                   	ret    

0080471c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80471c:	55                   	push   %ebp
  80471d:	89 e5                	mov    %esp,%ebp
  80471f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  804720:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804723:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804726:	8b 55 0c             	mov    0xc(%ebp),%edx
  804729:	8b 45 08             	mov    0x8(%ebp),%eax
  80472c:	6a 00                	push   $0x0
  80472e:	53                   	push   %ebx
  80472f:	51                   	push   %ecx
  804730:	52                   	push   %edx
  804731:	50                   	push   %eax
  804732:	6a 27                	push   $0x27
  804734:	e8 44 fb ff ff       	call   80427d <syscall>
  804739:	83 c4 18             	add    $0x18,%esp
}
  80473c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80473f:	c9                   	leave  
  804740:	c3                   	ret    

00804741 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  804741:	55                   	push   %ebp
  804742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  804744:	8b 55 0c             	mov    0xc(%ebp),%edx
  804747:	8b 45 08             	mov    0x8(%ebp),%eax
  80474a:	6a 00                	push   $0x0
  80474c:	6a 00                	push   $0x0
  80474e:	6a 00                	push   $0x0
  804750:	52                   	push   %edx
  804751:	50                   	push   %eax
  804752:	6a 28                	push   $0x28
  804754:	e8 24 fb ff ff       	call   80427d <syscall>
  804759:	83 c4 18             	add    $0x18,%esp
}
  80475c:	c9                   	leave  
  80475d:	c3                   	ret    

0080475e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80475e:	55                   	push   %ebp
  80475f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  804761:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804764:	8b 55 0c             	mov    0xc(%ebp),%edx
  804767:	8b 45 08             	mov    0x8(%ebp),%eax
  80476a:	6a 00                	push   $0x0
  80476c:	51                   	push   %ecx
  80476d:	ff 75 10             	pushl  0x10(%ebp)
  804770:	52                   	push   %edx
  804771:	50                   	push   %eax
  804772:	6a 29                	push   $0x29
  804774:	e8 04 fb ff ff       	call   80427d <syscall>
  804779:	83 c4 18             	add    $0x18,%esp
}
  80477c:	c9                   	leave  
  80477d:	c3                   	ret    

0080477e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80477e:	55                   	push   %ebp
  80477f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  804781:	6a 00                	push   $0x0
  804783:	6a 00                	push   $0x0
  804785:	ff 75 10             	pushl  0x10(%ebp)
  804788:	ff 75 0c             	pushl  0xc(%ebp)
  80478b:	ff 75 08             	pushl  0x8(%ebp)
  80478e:	6a 12                	push   $0x12
  804790:	e8 e8 fa ff ff       	call   80427d <syscall>
  804795:	83 c4 18             	add    $0x18,%esp
	return ;
  804798:	90                   	nop
}
  804799:	c9                   	leave  
  80479a:	c3                   	ret    

0080479b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80479b:	55                   	push   %ebp
  80479c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80479e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8047a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8047a4:	6a 00                	push   $0x0
  8047a6:	6a 00                	push   $0x0
  8047a8:	6a 00                	push   $0x0
  8047aa:	52                   	push   %edx
  8047ab:	50                   	push   %eax
  8047ac:	6a 2a                	push   $0x2a
  8047ae:	e8 ca fa ff ff       	call   80427d <syscall>
  8047b3:	83 c4 18             	add    $0x18,%esp
	return;
  8047b6:	90                   	nop
}
  8047b7:	c9                   	leave  
  8047b8:	c3                   	ret    

008047b9 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8047b9:	55                   	push   %ebp
  8047ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8047bc:	6a 00                	push   $0x0
  8047be:	6a 00                	push   $0x0
  8047c0:	6a 00                	push   $0x0
  8047c2:	6a 00                	push   $0x0
  8047c4:	6a 00                	push   $0x0
  8047c6:	6a 2b                	push   $0x2b
  8047c8:	e8 b0 fa ff ff       	call   80427d <syscall>
  8047cd:	83 c4 18             	add    $0x18,%esp
}
  8047d0:	c9                   	leave  
  8047d1:	c3                   	ret    

008047d2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8047d2:	55                   	push   %ebp
  8047d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8047d5:	6a 00                	push   $0x0
  8047d7:	6a 00                	push   $0x0
  8047d9:	6a 00                	push   $0x0
  8047db:	ff 75 0c             	pushl  0xc(%ebp)
  8047de:	ff 75 08             	pushl  0x8(%ebp)
  8047e1:	6a 2d                	push   $0x2d
  8047e3:	e8 95 fa ff ff       	call   80427d <syscall>
  8047e8:	83 c4 18             	add    $0x18,%esp
	return;
  8047eb:	90                   	nop
}
  8047ec:	c9                   	leave  
  8047ed:	c3                   	ret    

008047ee <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8047ee:	55                   	push   %ebp
  8047ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8047f1:	6a 00                	push   $0x0
  8047f3:	6a 00                	push   $0x0
  8047f5:	6a 00                	push   $0x0
  8047f7:	ff 75 0c             	pushl  0xc(%ebp)
  8047fa:	ff 75 08             	pushl  0x8(%ebp)
  8047fd:	6a 2c                	push   $0x2c
  8047ff:	e8 79 fa ff ff       	call   80427d <syscall>
  804804:	83 c4 18             	add    $0x18,%esp
	return ;
  804807:	90                   	nop
}
  804808:	c9                   	leave  
  804809:	c3                   	ret    

0080480a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80480a:	55                   	push   %ebp
  80480b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80480d:	8b 55 0c             	mov    0xc(%ebp),%edx
  804810:	8b 45 08             	mov    0x8(%ebp),%eax
  804813:	6a 00                	push   $0x0
  804815:	6a 00                	push   $0x0
  804817:	6a 00                	push   $0x0
  804819:	52                   	push   %edx
  80481a:	50                   	push   %eax
  80481b:	6a 2e                	push   $0x2e
  80481d:	e8 5b fa ff ff       	call   80427d <syscall>
  804822:	83 c4 18             	add    $0x18,%esp
}
  804825:	90                   	nop
  804826:	c9                   	leave  
  804827:	c3                   	ret    

00804828 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  804828:	55                   	push   %ebp
  804829:	89 e5                	mov    %esp,%ebp
  80482b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80482e:	81 7d 08 80 00 82 00 	cmpl   $0x820080,0x8(%ebp)
  804835:	72 09                	jb     804840 <to_page_va+0x18>
  804837:	81 7d 08 80 80 83 00 	cmpl   $0x838080,0x8(%ebp)
  80483e:	72 14                	jb     804854 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  804840:	83 ec 04             	sub    $0x4,%esp
  804843:	68 78 6e 80 00       	push   $0x806e78
  804848:	6a 15                	push   $0x15
  80484a:	68 a3 6e 80 00       	push   $0x806ea3
  80484f:	e8 10 d0 ff ff       	call   801864 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  804854:	8b 45 08             	mov    0x8(%ebp),%eax
  804857:	ba 80 00 82 00       	mov    $0x820080,%edx
  80485c:	29 d0                	sub    %edx,%eax
  80485e:	c1 f8 02             	sar    $0x2,%eax
  804861:	89 c2                	mov    %eax,%edx
  804863:	89 d0                	mov    %edx,%eax
  804865:	c1 e0 02             	shl    $0x2,%eax
  804868:	01 d0                	add    %edx,%eax
  80486a:	c1 e0 02             	shl    $0x2,%eax
  80486d:	01 d0                	add    %edx,%eax
  80486f:	c1 e0 02             	shl    $0x2,%eax
  804872:	01 d0                	add    %edx,%eax
  804874:	89 c1                	mov    %eax,%ecx
  804876:	c1 e1 08             	shl    $0x8,%ecx
  804879:	01 c8                	add    %ecx,%eax
  80487b:	89 c1                	mov    %eax,%ecx
  80487d:	c1 e1 10             	shl    $0x10,%ecx
  804880:	01 c8                	add    %ecx,%eax
  804882:	01 c0                	add    %eax,%eax
  804884:	01 d0                	add    %edx,%eax
  804886:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  804889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80488c:	c1 e0 0c             	shl    $0xc,%eax
  80488f:	89 c2                	mov    %eax,%edx
  804891:	a1 84 80 83 00       	mov    0x838084,%eax
  804896:	01 d0                	add    %edx,%eax
}
  804898:	c9                   	leave  
  804899:	c3                   	ret    

0080489a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80489a:	55                   	push   %ebp
  80489b:	89 e5                	mov    %esp,%ebp
  80489d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8048a0:	a1 84 80 83 00       	mov    0x838084,%eax
  8048a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8048a8:	29 c2                	sub    %eax,%edx
  8048aa:	89 d0                	mov    %edx,%eax
  8048ac:	c1 e8 0c             	shr    $0xc,%eax
  8048af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8048b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8048b6:	78 09                	js     8048c1 <to_page_info+0x27>
  8048b8:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8048bf:	7e 14                	jle    8048d5 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8048c1:	83 ec 04             	sub    $0x4,%esp
  8048c4:	68 bc 6e 80 00       	push   $0x806ebc
  8048c9:	6a 21                	push   $0x21
  8048cb:	68 a3 6e 80 00       	push   $0x806ea3
  8048d0:	e8 8f cf ff ff       	call   801864 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8048d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8048d8:	89 d0                	mov    %edx,%eax
  8048da:	01 c0                	add    %eax,%eax
  8048dc:	01 d0                	add    %edx,%eax
  8048de:	c1 e0 02             	shl    $0x2,%eax
  8048e1:	05 80 00 82 00       	add    $0x820080,%eax
}
  8048e6:	c9                   	leave  
  8048e7:	c3                   	ret    

008048e8 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8048e8:	55                   	push   %ebp
  8048e9:	89 e5                	mov    %esp,%ebp
  8048eb:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8048ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8048f1:	05 00 00 00 02       	add    $0x2000000,%eax
  8048f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8048f9:	73 16                	jae    804911 <initialize_dynamic_allocator+0x29>
  8048fb:	68 e0 6e 80 00       	push   $0x806ee0
  804900:	68 06 6f 80 00       	push   $0x806f06
  804905:	6a 2f                	push   $0x2f
  804907:	68 a3 6e 80 00       	push   $0x806ea3
  80490c:	e8 53 cf ff ff       	call   801864 <_panic>
	dynAllocStart = daStart;
  804911:	8b 45 08             	mov    0x8(%ebp),%eax
  804914:	a3 84 80 83 00       	mov    %eax,0x838084
	dynAllocEnd = daEnd;
  804919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80491c:	a3 60 00 82 00       	mov    %eax,0x820060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804921:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804928:	eb 36                	jmp    804960 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80492a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80492d:	c1 e0 04             	shl    $0x4,%eax
  804930:	05 a0 80 83 00       	add    $0x8380a0,%eax
  804935:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80493b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80493e:	c1 e0 04             	shl    $0x4,%eax
  804941:	05 a4 80 83 00       	add    $0x8380a4,%eax
  804946:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80494c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80494f:	c1 e0 04             	shl    $0x4,%eax
  804952:	05 ac 80 83 00       	add    $0x8380ac,%eax
  804957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80495d:	ff 45 f4             	incl   -0xc(%ebp)
  804960:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  804964:	7e c4                	jle    80492a <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  804966:	c7 05 68 00 82 00 00 	movl   $0x0,0x820068
  80496d:	00 00 00 
  804970:	c7 05 6c 00 82 00 00 	movl   $0x0,0x82006c
  804977:	00 00 00 
  80497a:	c7 05 74 00 82 00 00 	movl   $0x0,0x820074
  804981:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  804984:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80498b:	e9 1b 01 00 00       	jmp    804aab <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  804990:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804993:	89 d0                	mov    %edx,%eax
  804995:	01 c0                	add    %eax,%eax
  804997:	01 d0                	add    %edx,%eax
  804999:	c1 e0 02             	shl    $0x2,%eax
  80499c:	05 88 00 82 00       	add    $0x820088,%eax
  8049a1:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8049a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049a9:	89 d0                	mov    %edx,%eax
  8049ab:	01 c0                	add    %eax,%eax
  8049ad:	01 d0                	add    %edx,%eax
  8049af:	c1 e0 02             	shl    $0x2,%eax
  8049b2:	05 8a 00 82 00       	add    $0x82008a,%eax
  8049b7:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8049bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049bf:	89 d0                	mov    %edx,%eax
  8049c1:	01 c0                	add    %eax,%eax
  8049c3:	01 d0                	add    %edx,%eax
  8049c5:	c1 e0 02             	shl    $0x2,%eax
  8049c8:	05 80 00 82 00       	add    $0x820080,%eax
  8049cd:	8b 00                	mov    (%eax),%eax
  8049cf:	85 c0                	test   %eax,%eax
  8049d1:	74 2b                	je     8049fe <initialize_dynamic_allocator+0x116>
  8049d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049d6:	89 d0                	mov    %edx,%eax
  8049d8:	01 c0                	add    %eax,%eax
  8049da:	01 d0                	add    %edx,%eax
  8049dc:	c1 e0 02             	shl    $0x2,%eax
  8049df:	05 80 00 82 00       	add    $0x820080,%eax
  8049e4:	8b 10                	mov    (%eax),%edx
  8049e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8049e9:	89 c8                	mov    %ecx,%eax
  8049eb:	01 c0                	add    %eax,%eax
  8049ed:	01 c8                	add    %ecx,%eax
  8049ef:	c1 e0 02             	shl    $0x2,%eax
  8049f2:	05 84 00 82 00       	add    $0x820084,%eax
  8049f7:	8b 00                	mov    (%eax),%eax
  8049f9:	89 42 04             	mov    %eax,0x4(%edx)
  8049fc:	eb 18                	jmp    804a16 <initialize_dynamic_allocator+0x12e>
  8049fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804a01:	89 d0                	mov    %edx,%eax
  804a03:	01 c0                	add    %eax,%eax
  804a05:	01 d0                	add    %edx,%eax
  804a07:	c1 e0 02             	shl    $0x2,%eax
  804a0a:	05 84 00 82 00       	add    $0x820084,%eax
  804a0f:	8b 00                	mov    (%eax),%eax
  804a11:	a3 6c 00 82 00       	mov    %eax,0x82006c
  804a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804a19:	89 d0                	mov    %edx,%eax
  804a1b:	01 c0                	add    %eax,%eax
  804a1d:	01 d0                	add    %edx,%eax
  804a1f:	c1 e0 02             	shl    $0x2,%eax
  804a22:	05 84 00 82 00       	add    $0x820084,%eax
  804a27:	8b 00                	mov    (%eax),%eax
  804a29:	85 c0                	test   %eax,%eax
  804a2b:	74 2a                	je     804a57 <initialize_dynamic_allocator+0x16f>
  804a2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804a30:	89 d0                	mov    %edx,%eax
  804a32:	01 c0                	add    %eax,%eax
  804a34:	01 d0                	add    %edx,%eax
  804a36:	c1 e0 02             	shl    $0x2,%eax
  804a39:	05 84 00 82 00       	add    $0x820084,%eax
  804a3e:	8b 10                	mov    (%eax),%edx
  804a40:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804a43:	89 c8                	mov    %ecx,%eax
  804a45:	01 c0                	add    %eax,%eax
  804a47:	01 c8                	add    %ecx,%eax
  804a49:	c1 e0 02             	shl    $0x2,%eax
  804a4c:	05 80 00 82 00       	add    $0x820080,%eax
  804a51:	8b 00                	mov    (%eax),%eax
  804a53:	89 02                	mov    %eax,(%edx)
  804a55:	eb 18                	jmp    804a6f <initialize_dynamic_allocator+0x187>
  804a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804a5a:	89 d0                	mov    %edx,%eax
  804a5c:	01 c0                	add    %eax,%eax
  804a5e:	01 d0                	add    %edx,%eax
  804a60:	c1 e0 02             	shl    $0x2,%eax
  804a63:	05 80 00 82 00       	add    $0x820080,%eax
  804a68:	8b 00                	mov    (%eax),%eax
  804a6a:	a3 68 00 82 00       	mov    %eax,0x820068
  804a6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804a72:	89 d0                	mov    %edx,%eax
  804a74:	01 c0                	add    %eax,%eax
  804a76:	01 d0                	add    %edx,%eax
  804a78:	c1 e0 02             	shl    $0x2,%eax
  804a7b:	05 80 00 82 00       	add    $0x820080,%eax
  804a80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804a89:	89 d0                	mov    %edx,%eax
  804a8b:	01 c0                	add    %eax,%eax
  804a8d:	01 d0                	add    %edx,%eax
  804a8f:	c1 e0 02             	shl    $0x2,%eax
  804a92:	05 84 00 82 00       	add    $0x820084,%eax
  804a97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a9d:	a1 74 00 82 00       	mov    0x820074,%eax
  804aa2:	48                   	dec    %eax
  804aa3:	a3 74 00 82 00       	mov    %eax,0x820074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  804aa8:	ff 45 f0             	incl   -0x10(%ebp)
  804aab:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  804ab2:	0f 8e d8 fe ff ff    	jle    804990 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  804ab8:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  804abf:	e9 9d 00 00 00       	jmp    804b61 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  804ac4:	8b 15 68 00 82 00    	mov    0x820068,%edx
  804aca:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  804acd:	89 c8                	mov    %ecx,%eax
  804acf:	01 c0                	add    %eax,%eax
  804ad1:	01 c8                	add    %ecx,%eax
  804ad3:	c1 e0 02             	shl    $0x2,%eax
  804ad6:	05 80 00 82 00       	add    $0x820080,%eax
  804adb:	89 10                	mov    %edx,(%eax)
  804add:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804ae0:	89 d0                	mov    %edx,%eax
  804ae2:	01 c0                	add    %eax,%eax
  804ae4:	01 d0                	add    %edx,%eax
  804ae6:	c1 e0 02             	shl    $0x2,%eax
  804ae9:	05 80 00 82 00       	add    $0x820080,%eax
  804aee:	8b 00                	mov    (%eax),%eax
  804af0:	85 c0                	test   %eax,%eax
  804af2:	74 1c                	je     804b10 <initialize_dynamic_allocator+0x228>
  804af4:	8b 15 68 00 82 00    	mov    0x820068,%edx
  804afa:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  804afd:	89 c8                	mov    %ecx,%eax
  804aff:	01 c0                	add    %eax,%eax
  804b01:	01 c8                	add    %ecx,%eax
  804b03:	c1 e0 02             	shl    $0x2,%eax
  804b06:	05 80 00 82 00       	add    $0x820080,%eax
  804b0b:	89 42 04             	mov    %eax,0x4(%edx)
  804b0e:	eb 16                	jmp    804b26 <initialize_dynamic_allocator+0x23e>
  804b10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804b13:	89 d0                	mov    %edx,%eax
  804b15:	01 c0                	add    %eax,%eax
  804b17:	01 d0                	add    %edx,%eax
  804b19:	c1 e0 02             	shl    $0x2,%eax
  804b1c:	05 80 00 82 00       	add    $0x820080,%eax
  804b21:	a3 6c 00 82 00       	mov    %eax,0x82006c
  804b26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804b29:	89 d0                	mov    %edx,%eax
  804b2b:	01 c0                	add    %eax,%eax
  804b2d:	01 d0                	add    %edx,%eax
  804b2f:	c1 e0 02             	shl    $0x2,%eax
  804b32:	05 80 00 82 00       	add    $0x820080,%eax
  804b37:	a3 68 00 82 00       	mov    %eax,0x820068
  804b3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804b3f:	89 d0                	mov    %edx,%eax
  804b41:	01 c0                	add    %eax,%eax
  804b43:	01 d0                	add    %edx,%eax
  804b45:	c1 e0 02             	shl    $0x2,%eax
  804b48:	05 84 00 82 00       	add    $0x820084,%eax
  804b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b53:	a1 74 00 82 00       	mov    0x820074,%eax
  804b58:	40                   	inc    %eax
  804b59:	a3 74 00 82 00       	mov    %eax,0x820074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  804b5e:	ff 4d ec             	decl   -0x14(%ebp)
  804b61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804b65:	0f 89 59 ff ff ff    	jns    804ac4 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  804b6b:	c7 05 44 00 82 00 01 	movl   $0x1,0x820044
  804b72:	00 00 00 
}
  804b75:	90                   	nop
  804b76:	c9                   	leave  
  804b77:	c3                   	ret    

00804b78 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  804b78:	55                   	push   %ebp
  804b79:	89 e5                	mov    %esp,%ebp
  804b7b:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  804b81:	83 ec 0c             	sub    $0xc,%esp
  804b84:	50                   	push   %eax
  804b85:	e8 10 fd ff ff       	call   80489a <to_page_info>
  804b8a:	83 c4 10             	add    $0x10,%esp
  804b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  804b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b93:	8b 40 08             	mov    0x8(%eax),%eax
  804b96:	0f b7 c0             	movzwl %ax,%eax
}
  804b99:	c9                   	leave  
  804b9a:	c3                   	ret    

00804b9b <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  804b9b:	55                   	push   %ebp
  804b9c:	89 e5                	mov    %esp,%ebp
  804b9e:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  804ba1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  804ba8:	76 16                	jbe    804bc0 <alloc_block+0x25>
  804baa:	68 1c 6f 80 00       	push   $0x806f1c
  804baf:	68 06 6f 80 00       	push   $0x806f06
  804bb4:	6a 59                	push   $0x59
  804bb6:	68 a3 6e 80 00       	push   $0x806ea3
  804bbb:	e8 a4 cc ff ff       	call   801864 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  804bc0:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  804bc7:	eb 08                	jmp    804bd1 <alloc_block+0x36>
		allocSize <<= 1;
  804bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804bcc:	01 c0                	add    %eax,%eax
  804bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  804bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804bd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  804bd7:	73 09                	jae    804be2 <alloc_block+0x47>
  804bd9:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  804be0:	76 e7                	jbe    804bc9 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  804be2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  804be9:	eb 03                	jmp    804bee <alloc_block+0x53>
		listIndex++;
  804beb:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  804bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804bf1:	ba 08 00 00 00       	mov    $0x8,%edx
  804bf6:	88 c1                	mov    %al,%cl
  804bf8:	d3 e2                	shl    %cl,%edx
  804bfa:	89 d0                	mov    %edx,%eax
  804bfc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804bff:	72 ea                	jb     804beb <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804c07:	e9 f4 00 00 00       	jmp    804d00 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  804c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c0f:	c1 e0 04             	shl    $0x4,%eax
  804c12:	05 a0 80 83 00       	add    $0x8380a0,%eax
  804c17:	8b 00                	mov    (%eax),%eax
  804c19:	85 c0                	test   %eax,%eax
  804c1b:	0f 84 dc 00 00 00    	je     804cfd <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804c24:	c1 e0 04             	shl    $0x4,%eax
  804c27:	05 a0 80 83 00       	add    $0x8380a0,%eax
  804c2c:	8b 00                	mov    (%eax),%eax
  804c2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  804c31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804c35:	75 14                	jne    804c4b <alloc_block+0xb0>
  804c37:	83 ec 04             	sub    $0x4,%esp
  804c3a:	68 3d 6f 80 00       	push   $0x806f3d
  804c3f:	6a 6b                	push   $0x6b
  804c41:	68 a3 6e 80 00       	push   $0x806ea3
  804c46:	e8 19 cc ff ff       	call   801864 <_panic>
  804c4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c4e:	8b 00                	mov    (%eax),%eax
  804c50:	85 c0                	test   %eax,%eax
  804c52:	74 10                	je     804c64 <alloc_block+0xc9>
  804c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c57:	8b 00                	mov    (%eax),%eax
  804c59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c5c:	8b 52 04             	mov    0x4(%edx),%edx
  804c5f:	89 50 04             	mov    %edx,0x4(%eax)
  804c62:	eb 14                	jmp    804c78 <alloc_block+0xdd>
  804c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c67:	8b 40 04             	mov    0x4(%eax),%eax
  804c6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c6d:	c1 e2 04             	shl    $0x4,%edx
  804c70:	81 c2 a4 80 83 00    	add    $0x8380a4,%edx
  804c76:	89 02                	mov    %eax,(%edx)
  804c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c7b:	8b 40 04             	mov    0x4(%eax),%eax
  804c7e:	85 c0                	test   %eax,%eax
  804c80:	74 0f                	je     804c91 <alloc_block+0xf6>
  804c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c85:	8b 40 04             	mov    0x4(%eax),%eax
  804c88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c8b:	8b 12                	mov    (%edx),%edx
  804c8d:	89 10                	mov    %edx,(%eax)
  804c8f:	eb 13                	jmp    804ca4 <alloc_block+0x109>
  804c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c94:	8b 00                	mov    (%eax),%eax
  804c96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804c99:	c1 e2 04             	shl    $0x4,%edx
  804c9c:	81 c2 a0 80 83 00    	add    $0x8380a0,%edx
  804ca2:	89 02                	mov    %eax,(%edx)
  804ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ca7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cba:	c1 e0 04             	shl    $0x4,%eax
  804cbd:	05 ac 80 83 00       	add    $0x8380ac,%eax
  804cc2:	8b 00                	mov    (%eax),%eax
  804cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  804cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804cca:	c1 e0 04             	shl    $0x4,%eax
  804ccd:	05 ac 80 83 00       	add    $0x8380ac,%eax
  804cd2:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  804cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cd7:	83 ec 0c             	sub    $0xc,%esp
  804cda:	50                   	push   %eax
  804cdb:	e8 ba fb ff ff       	call   80489a <to_page_info>
  804ce0:	83 c4 10             	add    $0x10,%esp
  804ce3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  804ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804ce9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804ced:	48                   	dec    %eax
  804cee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804cf1:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  804cf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804cf8:	e9 8f 02 00 00       	jmp    804f8c <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804cfd:	ff 45 ec             	incl   -0x14(%ebp)
  804d00:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804d04:	0f 8e 02 ff ff ff    	jle    804c0c <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  804d0a:	a1 68 00 82 00       	mov    0x820068,%eax
  804d0f:	85 c0                	test   %eax,%eax
  804d11:	75 14                	jne    804d27 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  804d13:	83 ec 04             	sub    $0x4,%esp
  804d16:	68 5c 6f 80 00       	push   $0x806f5c
  804d1b:	6a 77                	push   $0x77
  804d1d:	68 a3 6e 80 00       	push   $0x806ea3
  804d22:	e8 3d cb ff ff       	call   801864 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  804d27:	a1 68 00 82 00       	mov    0x820068,%eax
  804d2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  804d2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804d33:	75 14                	jne    804d49 <alloc_block+0x1ae>
  804d35:	83 ec 04             	sub    $0x4,%esp
  804d38:	68 3d 6f 80 00       	push   $0x806f3d
  804d3d:	6a 7a                	push   $0x7a
  804d3f:	68 a3 6e 80 00       	push   $0x806ea3
  804d44:	e8 1b cb ff ff       	call   801864 <_panic>
  804d49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d4c:	8b 00                	mov    (%eax),%eax
  804d4e:	85 c0                	test   %eax,%eax
  804d50:	74 10                	je     804d62 <alloc_block+0x1c7>
  804d52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d55:	8b 00                	mov    (%eax),%eax
  804d57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804d5a:	8b 52 04             	mov    0x4(%edx),%edx
  804d5d:	89 50 04             	mov    %edx,0x4(%eax)
  804d60:	eb 0b                	jmp    804d6d <alloc_block+0x1d2>
  804d62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d65:	8b 40 04             	mov    0x4(%eax),%eax
  804d68:	a3 6c 00 82 00       	mov    %eax,0x82006c
  804d6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d70:	8b 40 04             	mov    0x4(%eax),%eax
  804d73:	85 c0                	test   %eax,%eax
  804d75:	74 0f                	je     804d86 <alloc_block+0x1eb>
  804d77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d7a:	8b 40 04             	mov    0x4(%eax),%eax
  804d7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804d80:	8b 12                	mov    (%edx),%edx
  804d82:	89 10                	mov    %edx,(%eax)
  804d84:	eb 0a                	jmp    804d90 <alloc_block+0x1f5>
  804d86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d89:	8b 00                	mov    (%eax),%eax
  804d8b:	a3 68 00 82 00       	mov    %eax,0x820068
  804d90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804da3:	a1 74 00 82 00       	mov    0x820074,%eax
  804da8:	48                   	dec    %eax
  804da9:	a3 74 00 82 00       	mov    %eax,0x820074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  804dae:	83 ec 0c             	sub    $0xc,%esp
  804db1:	ff 75 dc             	pushl  -0x24(%ebp)
  804db4:	e8 6f fa ff ff       	call   804828 <to_page_va>
  804db9:	83 c4 10             	add    $0x10,%esp
  804dbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  804dbf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804dc2:	83 ec 0c             	sub    $0xc,%esp
  804dc5:	50                   	push   %eax
  804dc6:	e8 a0 dc ff ff       	call   802a6b <get_page>
  804dcb:	83 c4 10             	add    $0x10,%esp
  804dce:	85 c0                	test   %eax,%eax
  804dd0:	74 14                	je     804de6 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  804dd2:	83 ec 04             	sub    $0x4,%esp
  804dd5:	68 84 6f 80 00       	push   $0x806f84
  804dda:	6a 7f                	push   $0x7f
  804ddc:	68 a3 6e 80 00       	push   $0x806ea3
  804de1:	e8 7e ca ff ff       	call   801864 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  804de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804de9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804dec:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  804df0:	b8 00 10 00 00       	mov    $0x1000,%eax
  804df5:	ba 00 00 00 00       	mov    $0x0,%edx
  804dfa:	f7 75 f4             	divl   -0xc(%ebp)
  804dfd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804e00:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  804e04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804e0b:	e9 a7 00 00 00       	jmp    804eb7 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  804e10:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e16:	01 d0                	add    %edx,%eax
  804e18:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  804e1b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804e1f:	75 17                	jne    804e38 <alloc_block+0x29d>
  804e21:	83 ec 04             	sub    $0x4,%esp
  804e24:	68 ac 6f 80 00       	push   $0x806fac
  804e29:	68 88 00 00 00       	push   $0x88
  804e2e:	68 a3 6e 80 00       	push   $0x806ea3
  804e33:	e8 2c ca ff ff       	call   801864 <_panic>
  804e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804e3b:	c1 e0 04             	shl    $0x4,%eax
  804e3e:	05 a0 80 83 00       	add    $0x8380a0,%eax
  804e43:	8b 10                	mov    (%eax),%edx
  804e45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804e48:	89 10                	mov    %edx,(%eax)
  804e4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804e4d:	8b 00                	mov    (%eax),%eax
  804e4f:	85 c0                	test   %eax,%eax
  804e51:	74 15                	je     804e68 <alloc_block+0x2cd>
  804e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804e56:	c1 e0 04             	shl    $0x4,%eax
  804e59:	05 a0 80 83 00       	add    $0x8380a0,%eax
  804e5e:	8b 00                	mov    (%eax),%eax
  804e60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804e63:	89 50 04             	mov    %edx,0x4(%eax)
  804e66:	eb 11                	jmp    804e79 <alloc_block+0x2de>
  804e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804e6b:	c1 e0 04             	shl    $0x4,%eax
  804e6e:	8d 90 a4 80 83 00    	lea    0x8380a4(%eax),%edx
  804e74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804e77:	89 02                	mov    %eax,(%edx)
  804e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804e7c:	c1 e0 04             	shl    $0x4,%eax
  804e7f:	8d 90 a0 80 83 00    	lea    0x8380a0(%eax),%edx
  804e85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804e88:	89 02                	mov    %eax,(%edx)
  804e8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804e97:	c1 e0 04             	shl    $0x4,%eax
  804e9a:	05 ac 80 83 00       	add    $0x8380ac,%eax
  804e9f:	8b 00                	mov    (%eax),%eax
  804ea1:	8d 50 01             	lea    0x1(%eax),%edx
  804ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804ea7:	c1 e0 04             	shl    $0x4,%eax
  804eaa:	05 ac 80 83 00       	add    $0x8380ac,%eax
  804eaf:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  804eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804eb4:	01 45 e8             	add    %eax,-0x18(%ebp)
  804eb7:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  804ebe:	0f 86 4c ff ff ff    	jbe    804e10 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  804ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804ec7:	c1 e0 04             	shl    $0x4,%eax
  804eca:	05 a0 80 83 00       	add    $0x8380a0,%eax
  804ecf:	8b 00                	mov    (%eax),%eax
  804ed1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  804ed4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804ed8:	75 17                	jne    804ef1 <alloc_block+0x356>
  804eda:	83 ec 04             	sub    $0x4,%esp
  804edd:	68 3d 6f 80 00       	push   $0x806f3d
  804ee2:	68 8d 00 00 00       	push   $0x8d
  804ee7:	68 a3 6e 80 00       	push   $0x806ea3
  804eec:	e8 73 c9 ff ff       	call   801864 <_panic>
  804ef1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804ef4:	8b 00                	mov    (%eax),%eax
  804ef6:	85 c0                	test   %eax,%eax
  804ef8:	74 10                	je     804f0a <alloc_block+0x36f>
  804efa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804efd:	8b 00                	mov    (%eax),%eax
  804eff:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804f02:	8b 52 04             	mov    0x4(%edx),%edx
  804f05:	89 50 04             	mov    %edx,0x4(%eax)
  804f08:	eb 14                	jmp    804f1e <alloc_block+0x383>
  804f0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804f0d:	8b 40 04             	mov    0x4(%eax),%eax
  804f10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804f13:	c1 e2 04             	shl    $0x4,%edx
  804f16:	81 c2 a4 80 83 00    	add    $0x8380a4,%edx
  804f1c:	89 02                	mov    %eax,(%edx)
  804f1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804f21:	8b 40 04             	mov    0x4(%eax),%eax
  804f24:	85 c0                	test   %eax,%eax
  804f26:	74 0f                	je     804f37 <alloc_block+0x39c>
  804f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804f2b:	8b 40 04             	mov    0x4(%eax),%eax
  804f2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804f31:	8b 12                	mov    (%edx),%edx
  804f33:	89 10                	mov    %edx,(%eax)
  804f35:	eb 13                	jmp    804f4a <alloc_block+0x3af>
  804f37:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804f3a:	8b 00                	mov    (%eax),%eax
  804f3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804f3f:	c1 e2 04             	shl    $0x4,%edx
  804f42:	81 c2 a0 80 83 00    	add    $0x8380a0,%edx
  804f48:	89 02                	mov    %eax,(%edx)
  804f4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804f4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804f53:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804f56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804f60:	c1 e0 04             	shl    $0x4,%eax
  804f63:	05 ac 80 83 00       	add    $0x8380ac,%eax
  804f68:	8b 00                	mov    (%eax),%eax
  804f6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  804f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804f70:	c1 e0 04             	shl    $0x4,%eax
  804f73:	05 ac 80 83 00       	add    $0x8380ac,%eax
  804f78:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  804f7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804f7d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804f81:	48                   	dec    %eax
  804f82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804f85:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  804f89:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804f8c:	c9                   	leave  
  804f8d:	c3                   	ret    

00804f8e <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804f8e:	55                   	push   %ebp
  804f8f:	89 e5                	mov    %esp,%ebp
  804f91:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804f94:	8b 55 08             	mov    0x8(%ebp),%edx
  804f97:	a1 84 80 83 00       	mov    0x838084,%eax
  804f9c:	39 c2                	cmp    %eax,%edx
  804f9e:	72 0c                	jb     804fac <free_block+0x1e>
  804fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  804fa3:	a1 60 00 82 00       	mov    0x820060,%eax
  804fa8:	39 c2                	cmp    %eax,%edx
  804faa:	72 19                	jb     804fc5 <free_block+0x37>
  804fac:	68 d0 6f 80 00       	push   $0x806fd0
  804fb1:	68 06 6f 80 00       	push   $0x806f06
  804fb6:	68 98 00 00 00       	push   $0x98
  804fbb:	68 a3 6e 80 00       	push   $0x806ea3
  804fc0:	e8 9f c8 ff ff       	call   801864 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  804fc8:	83 ec 0c             	sub    $0xc,%esp
  804fcb:	50                   	push   %eax
  804fcc:	e8 c9 f8 ff ff       	call   80489a <to_page_info>
  804fd1:	83 c4 10             	add    $0x10,%esp
  804fd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804fda:	8b 40 08             	mov    0x8(%eax),%eax
  804fdd:	0f b7 c0             	movzwl %ax,%eax
  804fe0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  804fe3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804fea:	eb 03                	jmp    804fef <free_block+0x61>
		listIndex++;
  804fec:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ff2:	ba 08 00 00 00       	mov    $0x8,%edx
  804ff7:	88 c1                	mov    %al,%cl
  804ff9:	d3 e2                	shl    %cl,%edx
  804ffb:	89 d0                	mov    %edx,%eax
  804ffd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  805000:	72 ea                	jb     804fec <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  805002:	8b 45 08             	mov    0x8(%ebp),%eax
  805005:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  805008:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80500c:	75 17                	jne    805025 <free_block+0x97>
  80500e:	83 ec 04             	sub    $0x4,%esp
  805011:	68 ac 6f 80 00       	push   $0x806fac
  805016:	68 a2 00 00 00       	push   $0xa2
  80501b:	68 a3 6e 80 00       	push   $0x806ea3
  805020:	e8 3f c8 ff ff       	call   801864 <_panic>
  805025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805028:	c1 e0 04             	shl    $0x4,%eax
  80502b:	05 a0 80 83 00       	add    $0x8380a0,%eax
  805030:	8b 10                	mov    (%eax),%edx
  805032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  805035:	89 10                	mov    %edx,(%eax)
  805037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80503a:	8b 00                	mov    (%eax),%eax
  80503c:	85 c0                	test   %eax,%eax
  80503e:	74 15                	je     805055 <free_block+0xc7>
  805040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805043:	c1 e0 04             	shl    $0x4,%eax
  805046:	05 a0 80 83 00       	add    $0x8380a0,%eax
  80504b:	8b 00                	mov    (%eax),%eax
  80504d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  805050:	89 50 04             	mov    %edx,0x4(%eax)
  805053:	eb 11                	jmp    805066 <free_block+0xd8>
  805055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805058:	c1 e0 04             	shl    $0x4,%eax
  80505b:	8d 90 a4 80 83 00    	lea    0x8380a4(%eax),%edx
  805061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  805064:	89 02                	mov    %eax,(%edx)
  805066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805069:	c1 e0 04             	shl    $0x4,%eax
  80506c:	8d 90 a0 80 83 00    	lea    0x8380a0(%eax),%edx
  805072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  805075:	89 02                	mov    %eax,(%edx)
  805077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80507a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  805081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805084:	c1 e0 04             	shl    $0x4,%eax
  805087:	05 ac 80 83 00       	add    $0x8380ac,%eax
  80508c:	8b 00                	mov    (%eax),%eax
  80508e:	8d 50 01             	lea    0x1(%eax),%edx
  805091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805094:	c1 e0 04             	shl    $0x4,%eax
  805097:	05 ac 80 83 00       	add    $0x8380ac,%eax
  80509c:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  80509e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8050a1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8050a5:	40                   	inc    %eax
  8050a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8050a9:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  8050ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8050b0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8050b4:	0f b7 c8             	movzwl %ax,%ecx
  8050b7:	b8 00 10 00 00       	mov    $0x1000,%eax
  8050bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8050c1:	f7 75 e8             	divl   -0x18(%ebp)
  8050c4:	39 c1                	cmp    %eax,%ecx
  8050c6:	0f 85 ed 01 00 00    	jne    8052b9 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8050cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8050cf:	c1 e0 04             	shl    $0x4,%eax
  8050d2:	05 a0 80 83 00       	add    $0x8380a0,%eax
  8050d7:	8b 00                	mov    (%eax),%eax
  8050d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8050dc:	eb 2a                	jmp    805108 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  8050de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8050e1:	83 ec 0c             	sub    $0xc,%esp
  8050e4:	50                   	push   %eax
  8050e5:	e8 b0 f7 ff ff       	call   80489a <to_page_info>
  8050ea:	83 c4 10             	add    $0x10,%esp
  8050ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8050f0:	75 06                	jne    8050f8 <free_block+0x16a>
				tmp = b;
  8050f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8050f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8050f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8050fb:	c1 e0 04             	shl    $0x4,%eax
  8050fe:	05 a8 80 83 00       	add    $0x8380a8,%eax
  805103:	8b 00                	mov    (%eax),%eax
  805105:	89 45 f0             	mov    %eax,-0x10(%ebp)
  805108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80510c:	74 07                	je     805115 <free_block+0x187>
  80510e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805111:	8b 00                	mov    (%eax),%eax
  805113:	eb 05                	jmp    80511a <free_block+0x18c>
  805115:	b8 00 00 00 00       	mov    $0x0,%eax
  80511a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80511d:	c1 e2 04             	shl    $0x4,%edx
  805120:	81 c2 a8 80 83 00    	add    $0x8380a8,%edx
  805126:	89 02                	mov    %eax,(%edx)
  805128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80512b:	c1 e0 04             	shl    $0x4,%eax
  80512e:	05 a8 80 83 00       	add    $0x8380a8,%eax
  805133:	8b 00                	mov    (%eax),%eax
  805135:	85 c0                	test   %eax,%eax
  805137:	75 a5                	jne    8050de <free_block+0x150>
  805139:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80513d:	75 9f                	jne    8050de <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  80513f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805142:	c1 e0 04             	shl    $0x4,%eax
  805145:	05 a0 80 83 00       	add    $0x8380a0,%eax
  80514a:	8b 00                	mov    (%eax),%eax
  80514c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  80514f:	e9 cc 00 00 00       	jmp    805220 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  805154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805157:	8b 00                	mov    (%eax),%eax
  805159:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  80515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80515f:	83 ec 0c             	sub    $0xc,%esp
  805162:	50                   	push   %eax
  805163:	e8 32 f7 ff ff       	call   80489a <to_page_info>
  805168:	83 c4 10             	add    $0x10,%esp
  80516b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80516e:	0f 85 a6 00 00 00    	jne    80521a <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  805174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  805178:	75 17                	jne    805191 <free_block+0x203>
  80517a:	83 ec 04             	sub    $0x4,%esp
  80517d:	68 3d 6f 80 00       	push   $0x806f3d
  805182:	68 b5 00 00 00       	push   $0xb5
  805187:	68 a3 6e 80 00       	push   $0x806ea3
  80518c:	e8 d3 c6 ff ff       	call   801864 <_panic>
  805191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805194:	8b 00                	mov    (%eax),%eax
  805196:	85 c0                	test   %eax,%eax
  805198:	74 10                	je     8051aa <free_block+0x21c>
  80519a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80519d:	8b 00                	mov    (%eax),%eax
  80519f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8051a2:	8b 52 04             	mov    0x4(%edx),%edx
  8051a5:	89 50 04             	mov    %edx,0x4(%eax)
  8051a8:	eb 14                	jmp    8051be <free_block+0x230>
  8051aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8051ad:	8b 40 04             	mov    0x4(%eax),%eax
  8051b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8051b3:	c1 e2 04             	shl    $0x4,%edx
  8051b6:	81 c2 a4 80 83 00    	add    $0x8380a4,%edx
  8051bc:	89 02                	mov    %eax,(%edx)
  8051be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8051c1:	8b 40 04             	mov    0x4(%eax),%eax
  8051c4:	85 c0                	test   %eax,%eax
  8051c6:	74 0f                	je     8051d7 <free_block+0x249>
  8051c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8051cb:	8b 40 04             	mov    0x4(%eax),%eax
  8051ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8051d1:	8b 12                	mov    (%edx),%edx
  8051d3:	89 10                	mov    %edx,(%eax)
  8051d5:	eb 13                	jmp    8051ea <free_block+0x25c>
  8051d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8051da:	8b 00                	mov    (%eax),%eax
  8051dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8051df:	c1 e2 04             	shl    $0x4,%edx
  8051e2:	81 c2 a0 80 83 00    	add    $0x8380a0,%edx
  8051e8:	89 02                	mov    %eax,(%edx)
  8051ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8051ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8051f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8051f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8051fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805200:	c1 e0 04             	shl    $0x4,%eax
  805203:	05 ac 80 83 00       	add    $0x8380ac,%eax
  805208:	8b 00                	mov    (%eax),%eax
  80520a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80520d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805210:	c1 e0 04             	shl    $0x4,%eax
  805213:	05 ac 80 83 00       	add    $0x8380ac,%eax
  805218:	89 10                	mov    %edx,(%eax)
			b = next;
  80521a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80521d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  805220:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  805224:	0f 85 2a ff ff ff    	jne    805154 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  80522a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80522d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  805233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805236:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  80523c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  805240:	75 17                	jne    805259 <free_block+0x2cb>
  805242:	83 ec 04             	sub    $0x4,%esp
  805245:	68 ac 6f 80 00       	push   $0x806fac
  80524a:	68 bc 00 00 00       	push   $0xbc
  80524f:	68 a3 6e 80 00       	push   $0x806ea3
  805254:	e8 0b c6 ff ff       	call   801864 <_panic>
  805259:	8b 15 68 00 82 00    	mov    0x820068,%edx
  80525f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805262:	89 10                	mov    %edx,(%eax)
  805264:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805267:	8b 00                	mov    (%eax),%eax
  805269:	85 c0                	test   %eax,%eax
  80526b:	74 0d                	je     80527a <free_block+0x2ec>
  80526d:	a1 68 00 82 00       	mov    0x820068,%eax
  805272:	8b 55 ec             	mov    -0x14(%ebp),%edx
  805275:	89 50 04             	mov    %edx,0x4(%eax)
  805278:	eb 08                	jmp    805282 <free_block+0x2f4>
  80527a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80527d:	a3 6c 00 82 00       	mov    %eax,0x82006c
  805282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  805285:	a3 68 00 82 00       	mov    %eax,0x820068
  80528a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80528d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  805294:	a1 74 00 82 00       	mov    0x820074,%eax
  805299:	40                   	inc    %eax
  80529a:	a3 74 00 82 00       	mov    %eax,0x820074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  80529f:	83 ec 0c             	sub    $0xc,%esp
  8052a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8052a5:	e8 7e f5 ff ff       	call   804828 <to_page_va>
  8052aa:	83 c4 10             	add    $0x10,%esp
  8052ad:	83 ec 0c             	sub    $0xc,%esp
  8052b0:	50                   	push   %eax
  8052b1:	e8 fe d7 ff ff       	call   802ab4 <return_page>
  8052b6:	83 c4 10             	add    $0x10,%esp
	}
}
  8052b9:	90                   	nop
  8052ba:	c9                   	leave  
  8052bb:	c3                   	ret    

008052bc <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8052bc:	55                   	push   %ebp
  8052bd:	89 e5                	mov    %esp,%ebp
  8052bf:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8052c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8052c5:	89 d0                	mov    %edx,%eax
  8052c7:	c1 e0 02             	shl    $0x2,%eax
  8052ca:	01 d0                	add    %edx,%eax
  8052cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8052d3:	01 d0                	add    %edx,%eax
  8052d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8052dc:	01 d0                	add    %edx,%eax
  8052de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8052e5:	01 d0                	add    %edx,%eax
  8052e7:	c1 e0 04             	shl    $0x4,%eax
  8052ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8052ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8052f4:	0f 31                	rdtsc  
  8052f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8052f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8052fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8052ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  805302:	89 45 f0             	mov    %eax,-0x10(%ebp)
  805305:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  805308:	eb 46                	jmp    805350 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80530a:	0f 31                	rdtsc  
  80530c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80530f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  805312:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805315:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  805318:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80531b:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80531e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  805321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  805324:	29 c2                	sub    %eax,%edx
  805326:	89 d0                	mov    %edx,%eax
  805328:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80532b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80532e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805331:	89 d1                	mov    %edx,%ecx
  805333:	29 c1                	sub    %eax,%ecx
  805335:	8b 55 d8             	mov    -0x28(%ebp),%edx
  805338:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80533b:	39 c2                	cmp    %eax,%edx
  80533d:	0f 97 c0             	seta   %al
  805340:	0f b6 c0             	movzbl %al,%eax
  805343:	29 c1                	sub    %eax,%ecx
  805345:	89 c8                	mov    %ecx,%eax
  805347:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80534a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80534d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  805350:	8b 45 fc             	mov    -0x4(%ebp),%eax
  805353:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  805356:	72 b2                	jb     80530a <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  805358:	90                   	nop
  805359:	c9                   	leave  
  80535a:	c3                   	ret    

0080535b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80535b:	55                   	push   %ebp
  80535c:	89 e5                	mov    %esp,%ebp
  80535e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  805361:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  805368:	eb 03                	jmp    80536d <busy_wait+0x12>
  80536a:	ff 45 fc             	incl   -0x4(%ebp)
  80536d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  805370:	3b 45 08             	cmp    0x8(%ebp),%eax
  805373:	72 f5                	jb     80536a <busy_wait+0xf>
	return i;
  805375:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  805378:	c9                   	leave  
  805379:	c3                   	ret    
  80537a:	66 90                	xchg   %ax,%ax

0080537c <__udivdi3>:
  80537c:	55                   	push   %ebp
  80537d:	57                   	push   %edi
  80537e:	56                   	push   %esi
  80537f:	53                   	push   %ebx
  805380:	83 ec 1c             	sub    $0x1c,%esp
  805383:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  805387:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80538b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80538f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  805393:	89 ca                	mov    %ecx,%edx
  805395:	89 f8                	mov    %edi,%eax
  805397:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80539b:	85 f6                	test   %esi,%esi
  80539d:	75 2d                	jne    8053cc <__udivdi3+0x50>
  80539f:	39 cf                	cmp    %ecx,%edi
  8053a1:	77 65                	ja     805408 <__udivdi3+0x8c>
  8053a3:	89 fd                	mov    %edi,%ebp
  8053a5:	85 ff                	test   %edi,%edi
  8053a7:	75 0b                	jne    8053b4 <__udivdi3+0x38>
  8053a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8053ae:	31 d2                	xor    %edx,%edx
  8053b0:	f7 f7                	div    %edi
  8053b2:	89 c5                	mov    %eax,%ebp
  8053b4:	31 d2                	xor    %edx,%edx
  8053b6:	89 c8                	mov    %ecx,%eax
  8053b8:	f7 f5                	div    %ebp
  8053ba:	89 c1                	mov    %eax,%ecx
  8053bc:	89 d8                	mov    %ebx,%eax
  8053be:	f7 f5                	div    %ebp
  8053c0:	89 cf                	mov    %ecx,%edi
  8053c2:	89 fa                	mov    %edi,%edx
  8053c4:	83 c4 1c             	add    $0x1c,%esp
  8053c7:	5b                   	pop    %ebx
  8053c8:	5e                   	pop    %esi
  8053c9:	5f                   	pop    %edi
  8053ca:	5d                   	pop    %ebp
  8053cb:	c3                   	ret    
  8053cc:	39 ce                	cmp    %ecx,%esi
  8053ce:	77 28                	ja     8053f8 <__udivdi3+0x7c>
  8053d0:	0f bd fe             	bsr    %esi,%edi
  8053d3:	83 f7 1f             	xor    $0x1f,%edi
  8053d6:	75 40                	jne    805418 <__udivdi3+0x9c>
  8053d8:	39 ce                	cmp    %ecx,%esi
  8053da:	72 0a                	jb     8053e6 <__udivdi3+0x6a>
  8053dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8053e0:	0f 87 9e 00 00 00    	ja     805484 <__udivdi3+0x108>
  8053e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8053eb:	89 fa                	mov    %edi,%edx
  8053ed:	83 c4 1c             	add    $0x1c,%esp
  8053f0:	5b                   	pop    %ebx
  8053f1:	5e                   	pop    %esi
  8053f2:	5f                   	pop    %edi
  8053f3:	5d                   	pop    %ebp
  8053f4:	c3                   	ret    
  8053f5:	8d 76 00             	lea    0x0(%esi),%esi
  8053f8:	31 ff                	xor    %edi,%edi
  8053fa:	31 c0                	xor    %eax,%eax
  8053fc:	89 fa                	mov    %edi,%edx
  8053fe:	83 c4 1c             	add    $0x1c,%esp
  805401:	5b                   	pop    %ebx
  805402:	5e                   	pop    %esi
  805403:	5f                   	pop    %edi
  805404:	5d                   	pop    %ebp
  805405:	c3                   	ret    
  805406:	66 90                	xchg   %ax,%ax
  805408:	89 d8                	mov    %ebx,%eax
  80540a:	f7 f7                	div    %edi
  80540c:	31 ff                	xor    %edi,%edi
  80540e:	89 fa                	mov    %edi,%edx
  805410:	83 c4 1c             	add    $0x1c,%esp
  805413:	5b                   	pop    %ebx
  805414:	5e                   	pop    %esi
  805415:	5f                   	pop    %edi
  805416:	5d                   	pop    %ebp
  805417:	c3                   	ret    
  805418:	bd 20 00 00 00       	mov    $0x20,%ebp
  80541d:	89 eb                	mov    %ebp,%ebx
  80541f:	29 fb                	sub    %edi,%ebx
  805421:	89 f9                	mov    %edi,%ecx
  805423:	d3 e6                	shl    %cl,%esi
  805425:	89 c5                	mov    %eax,%ebp
  805427:	88 d9                	mov    %bl,%cl
  805429:	d3 ed                	shr    %cl,%ebp
  80542b:	89 e9                	mov    %ebp,%ecx
  80542d:	09 f1                	or     %esi,%ecx
  80542f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  805433:	89 f9                	mov    %edi,%ecx
  805435:	d3 e0                	shl    %cl,%eax
  805437:	89 c5                	mov    %eax,%ebp
  805439:	89 d6                	mov    %edx,%esi
  80543b:	88 d9                	mov    %bl,%cl
  80543d:	d3 ee                	shr    %cl,%esi
  80543f:	89 f9                	mov    %edi,%ecx
  805441:	d3 e2                	shl    %cl,%edx
  805443:	8b 44 24 08          	mov    0x8(%esp),%eax
  805447:	88 d9                	mov    %bl,%cl
  805449:	d3 e8                	shr    %cl,%eax
  80544b:	09 c2                	or     %eax,%edx
  80544d:	89 d0                	mov    %edx,%eax
  80544f:	89 f2                	mov    %esi,%edx
  805451:	f7 74 24 0c          	divl   0xc(%esp)
  805455:	89 d6                	mov    %edx,%esi
  805457:	89 c3                	mov    %eax,%ebx
  805459:	f7 e5                	mul    %ebp
  80545b:	39 d6                	cmp    %edx,%esi
  80545d:	72 19                	jb     805478 <__udivdi3+0xfc>
  80545f:	74 0b                	je     80546c <__udivdi3+0xf0>
  805461:	89 d8                	mov    %ebx,%eax
  805463:	31 ff                	xor    %edi,%edi
  805465:	e9 58 ff ff ff       	jmp    8053c2 <__udivdi3+0x46>
  80546a:	66 90                	xchg   %ax,%ax
  80546c:	8b 54 24 08          	mov    0x8(%esp),%edx
  805470:	89 f9                	mov    %edi,%ecx
  805472:	d3 e2                	shl    %cl,%edx
  805474:	39 c2                	cmp    %eax,%edx
  805476:	73 e9                	jae    805461 <__udivdi3+0xe5>
  805478:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80547b:	31 ff                	xor    %edi,%edi
  80547d:	e9 40 ff ff ff       	jmp    8053c2 <__udivdi3+0x46>
  805482:	66 90                	xchg   %ax,%ax
  805484:	31 c0                	xor    %eax,%eax
  805486:	e9 37 ff ff ff       	jmp    8053c2 <__udivdi3+0x46>
  80548b:	90                   	nop

0080548c <__umoddi3>:
  80548c:	55                   	push   %ebp
  80548d:	57                   	push   %edi
  80548e:	56                   	push   %esi
  80548f:	53                   	push   %ebx
  805490:	83 ec 1c             	sub    $0x1c,%esp
  805493:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  805497:	8b 74 24 34          	mov    0x34(%esp),%esi
  80549b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80549f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8054a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8054a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8054ab:	89 f3                	mov    %esi,%ebx
  8054ad:	89 fa                	mov    %edi,%edx
  8054af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8054b3:	89 34 24             	mov    %esi,(%esp)
  8054b6:	85 c0                	test   %eax,%eax
  8054b8:	75 1a                	jne    8054d4 <__umoddi3+0x48>
  8054ba:	39 f7                	cmp    %esi,%edi
  8054bc:	0f 86 a2 00 00 00    	jbe    805564 <__umoddi3+0xd8>
  8054c2:	89 c8                	mov    %ecx,%eax
  8054c4:	89 f2                	mov    %esi,%edx
  8054c6:	f7 f7                	div    %edi
  8054c8:	89 d0                	mov    %edx,%eax
  8054ca:	31 d2                	xor    %edx,%edx
  8054cc:	83 c4 1c             	add    $0x1c,%esp
  8054cf:	5b                   	pop    %ebx
  8054d0:	5e                   	pop    %esi
  8054d1:	5f                   	pop    %edi
  8054d2:	5d                   	pop    %ebp
  8054d3:	c3                   	ret    
  8054d4:	39 f0                	cmp    %esi,%eax
  8054d6:	0f 87 ac 00 00 00    	ja     805588 <__umoddi3+0xfc>
  8054dc:	0f bd e8             	bsr    %eax,%ebp
  8054df:	83 f5 1f             	xor    $0x1f,%ebp
  8054e2:	0f 84 ac 00 00 00    	je     805594 <__umoddi3+0x108>
  8054e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8054ed:	29 ef                	sub    %ebp,%edi
  8054ef:	89 fe                	mov    %edi,%esi
  8054f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8054f5:	89 e9                	mov    %ebp,%ecx
  8054f7:	d3 e0                	shl    %cl,%eax
  8054f9:	89 d7                	mov    %edx,%edi
  8054fb:	89 f1                	mov    %esi,%ecx
  8054fd:	d3 ef                	shr    %cl,%edi
  8054ff:	09 c7                	or     %eax,%edi
  805501:	89 e9                	mov    %ebp,%ecx
  805503:	d3 e2                	shl    %cl,%edx
  805505:	89 14 24             	mov    %edx,(%esp)
  805508:	89 d8                	mov    %ebx,%eax
  80550a:	d3 e0                	shl    %cl,%eax
  80550c:	89 c2                	mov    %eax,%edx
  80550e:	8b 44 24 08          	mov    0x8(%esp),%eax
  805512:	d3 e0                	shl    %cl,%eax
  805514:	89 44 24 04          	mov    %eax,0x4(%esp)
  805518:	8b 44 24 08          	mov    0x8(%esp),%eax
  80551c:	89 f1                	mov    %esi,%ecx
  80551e:	d3 e8                	shr    %cl,%eax
  805520:	09 d0                	or     %edx,%eax
  805522:	d3 eb                	shr    %cl,%ebx
  805524:	89 da                	mov    %ebx,%edx
  805526:	f7 f7                	div    %edi
  805528:	89 d3                	mov    %edx,%ebx
  80552a:	f7 24 24             	mull   (%esp)
  80552d:	89 c6                	mov    %eax,%esi
  80552f:	89 d1                	mov    %edx,%ecx
  805531:	39 d3                	cmp    %edx,%ebx
  805533:	0f 82 87 00 00 00    	jb     8055c0 <__umoddi3+0x134>
  805539:	0f 84 91 00 00 00    	je     8055d0 <__umoddi3+0x144>
  80553f:	8b 54 24 04          	mov    0x4(%esp),%edx
  805543:	29 f2                	sub    %esi,%edx
  805545:	19 cb                	sbb    %ecx,%ebx
  805547:	89 d8                	mov    %ebx,%eax
  805549:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80554d:	d3 e0                	shl    %cl,%eax
  80554f:	89 e9                	mov    %ebp,%ecx
  805551:	d3 ea                	shr    %cl,%edx
  805553:	09 d0                	or     %edx,%eax
  805555:	89 e9                	mov    %ebp,%ecx
  805557:	d3 eb                	shr    %cl,%ebx
  805559:	89 da                	mov    %ebx,%edx
  80555b:	83 c4 1c             	add    $0x1c,%esp
  80555e:	5b                   	pop    %ebx
  80555f:	5e                   	pop    %esi
  805560:	5f                   	pop    %edi
  805561:	5d                   	pop    %ebp
  805562:	c3                   	ret    
  805563:	90                   	nop
  805564:	89 fd                	mov    %edi,%ebp
  805566:	85 ff                	test   %edi,%edi
  805568:	75 0b                	jne    805575 <__umoddi3+0xe9>
  80556a:	b8 01 00 00 00       	mov    $0x1,%eax
  80556f:	31 d2                	xor    %edx,%edx
  805571:	f7 f7                	div    %edi
  805573:	89 c5                	mov    %eax,%ebp
  805575:	89 f0                	mov    %esi,%eax
  805577:	31 d2                	xor    %edx,%edx
  805579:	f7 f5                	div    %ebp
  80557b:	89 c8                	mov    %ecx,%eax
  80557d:	f7 f5                	div    %ebp
  80557f:	89 d0                	mov    %edx,%eax
  805581:	e9 44 ff ff ff       	jmp    8054ca <__umoddi3+0x3e>
  805586:	66 90                	xchg   %ax,%ax
  805588:	89 c8                	mov    %ecx,%eax
  80558a:	89 f2                	mov    %esi,%edx
  80558c:	83 c4 1c             	add    $0x1c,%esp
  80558f:	5b                   	pop    %ebx
  805590:	5e                   	pop    %esi
  805591:	5f                   	pop    %edi
  805592:	5d                   	pop    %ebp
  805593:	c3                   	ret    
  805594:	3b 04 24             	cmp    (%esp),%eax
  805597:	72 06                	jb     80559f <__umoddi3+0x113>
  805599:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80559d:	77 0f                	ja     8055ae <__umoddi3+0x122>
  80559f:	89 f2                	mov    %esi,%edx
  8055a1:	29 f9                	sub    %edi,%ecx
  8055a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8055a7:	89 14 24             	mov    %edx,(%esp)
  8055aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8055ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8055b2:	8b 14 24             	mov    (%esp),%edx
  8055b5:	83 c4 1c             	add    $0x1c,%esp
  8055b8:	5b                   	pop    %ebx
  8055b9:	5e                   	pop    %esi
  8055ba:	5f                   	pop    %edi
  8055bb:	5d                   	pop    %ebp
  8055bc:	c3                   	ret    
  8055bd:	8d 76 00             	lea    0x0(%esi),%esi
  8055c0:	2b 04 24             	sub    (%esp),%eax
  8055c3:	19 fa                	sbb    %edi,%edx
  8055c5:	89 d1                	mov    %edx,%ecx
  8055c7:	89 c6                	mov    %eax,%esi
  8055c9:	e9 71 ff ff ff       	jmp    80553f <__umoddi3+0xb3>
  8055ce:	66 90                	xchg   %ax,%ax
  8055d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8055d4:	72 ea                	jb     8055c0 <__umoddi3+0x134>
  8055d6:	89 d9                	mov    %ebx,%ecx
  8055d8:	e9 62 ff ff ff       	jmp    80553f <__umoddi3+0xb3>
