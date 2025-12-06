
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 b7 02 00 00       	call   8002ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	 *********************************************************/
#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 50 80 00       	mov    0x805020,%eax
  800048:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004e:	a1 20 50 80 00       	mov    0x805020,%eax
  800053:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 60 41 80 00       	push   $0x804160
  800065:	6a 11                	push   $0x11
  800067:	68 7c 41 80 00       	push   $0x80417c
  80006c:	e8 2c 04 00 00       	call   80049d <_panic>
	//	malloc(0);
	/*=================================================*/
#else
	panic("not handled!");
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 14 2f 00 00       	call   802fd5 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 57 2f 00 00       	call   803020 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 50 16 00 00       	call   80172d <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 98 41 80 00       	push   $0x804198
  8000f9:	6a 32                	push   $0x32
  8000fb:	68 7c 41 80 00       	push   $0x80417c
  800100:	e8 98 03 00 00       	call   80049d <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 16 2f 00 00       	call   803020 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 c8 41 80 00       	push   $0x8041c8
  800117:	6a 33                	push   $0x33
  800119:	68 7c 41 80 00       	push   $0x80417c
  80011e:	e8 7a 03 00 00       	call   80049d <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 ad 2e 00 00       	call   802fd5 <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 71 2e 00 00       	call   802fd5 <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 f8 41 80 00       	push   $0x8041f8
  800181:	6a 3d                	push   $0x3d
  800183:	68 7c 41 80 00       	push   $0x80417c
  800188:	e8 10 03 00 00       	call   80049d <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 cb 31 00 00       	call   803397 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 74 42 80 00       	push   $0x804274
  8001e0:	6a 41                	push   $0x41
  8001e2:	68 7c 41 80 00       	push   $0x80417c
  8001e7:	e8 b1 02 00 00       	call   80049d <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 e4 2d 00 00       	call   802fd5 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 27 2e 00 00       	call   803020 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 82 18 00 00       	call   801a8d <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 0d 2e 00 00       	call   803020 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 94 42 80 00       	push   $0x804294
  800220:	6a 4e                	push   $0x4e
  800222:	68 7c 41 80 00       	push   $0x80417c
  800227:	e8 71 02 00 00       	call   80049d <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 a4 2d 00 00       	call   802fd5 <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 d0 42 80 00       	push   $0x8042d0
  800247:	6a 4f                	push   $0x4f
  800249:	68 7c 41 80 00       	push   $0x80417c
  80024e:	e8 4a 02 00 00       	call   80049d <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 05 31 00 00       	call   803397 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 1c 43 80 00       	push   $0x80431c
  8002a6:	6a 52                	push   $0x52
  8002a8:	68 7c 41 80 00       	push   $0x80417c
  8002ad:	e8 eb 01 00 00       	call   80049d <_panic>
		}
	}
	inctst(); //to ensure that it reached here
  8002b2:	e8 25 30 00 00       	call   8032dc <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 39 30 00 00       	call   8032f6 <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area but NOT ACCESSED Before (processes should be killed by the validation of the fault handler)
	{
		byteArr[8*kilo] = minByte ;
  8002c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c5:	c1 e0 03             	shl    $0x3,%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002cd:	01 c2                	add    %eax,%edx
  8002cf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8002d2:	88 02                	mov    %al,(%edx)
		inctst();
  8002d4:	e8 03 30 00 00       	call   8032dc <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	68 40 43 80 00       	push   $0x804340
  8002e1:	6a 5e                	push   $0x5e
  8002e3:	68 7c 41 80 00       	push   $0x80417c
  8002e8:	e8 b0 01 00 00       	call   80049d <_panic>

008002ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002f6:	e8 a3 2e 00 00       	call   80319e <sys_getenvindex>
  8002fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800301:	89 d0                	mov    %edx,%eax
  800303:	c1 e0 03             	shl    $0x3,%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c1 e0 02             	shl    $0x2,%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800314:	01 d0                	add    %edx,%eax
  800316:	c1 e0 03             	shl    $0x3,%eax
  800319:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80031e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800323:	a1 20 50 80 00       	mov    0x805020,%eax
  800328:	8a 40 20             	mov    0x20(%eax),%al
  80032b:	84 c0                	test   %al,%al
  80032d:	74 0d                	je     80033c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80032f:	a1 20 50 80 00       	mov    0x805020,%eax
  800334:	83 c0 20             	add    $0x20,%eax
  800337:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800340:	7e 0a                	jle    80034c <libmain+0x5f>
		binaryname = argv[0];
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	8b 00                	mov    (%eax),%eax
  800347:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	ff 75 0c             	pushl  0xc(%ebp)
  800352:	ff 75 08             	pushl  0x8(%ebp)
  800355:	e8 de fc ff ff       	call   800038 <_main>
  80035a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80035d:	a1 00 50 80 00       	mov    0x805000,%eax
  800362:	85 c0                	test   %eax,%eax
  800364:	0f 84 01 01 00 00    	je     80046b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80036a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800370:	bb 84 44 80 00       	mov    $0x804484,%ebx
  800375:	ba 0e 00 00 00       	mov    $0xe,%edx
  80037a:	89 c7                	mov    %eax,%edi
  80037c:	89 de                	mov    %ebx,%esi
  80037e:	89 d1                	mov    %edx,%ecx
  800380:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800382:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800385:	b9 56 00 00 00       	mov    $0x56,%ecx
  80038a:	b0 00                	mov    $0x0,%al
  80038c:	89 d7                	mov    %edx,%edi
  80038e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800390:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800397:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	50                   	push   %eax
  80039e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003a4:	50                   	push   %eax
  8003a5:	e8 2a 30 00 00       	call   8033d4 <sys_utilities>
  8003aa:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003ad:	e8 73 2b 00 00       	call   802f25 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003b2:	83 ec 0c             	sub    $0xc,%esp
  8003b5:	68 a4 43 80 00       	push   $0x8043a4
  8003ba:	e8 ac 03 00 00       	call   80076b <cprintf>
  8003bf:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c5:	85 c0                	test   %eax,%eax
  8003c7:	74 18                	je     8003e1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003c9:	e8 24 30 00 00       	call   8033f2 <sys_get_optimal_num_faults>
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	50                   	push   %eax
  8003d2:	68 cc 43 80 00       	push   $0x8043cc
  8003d7:	e8 8f 03 00 00       	call   80076b <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 59                	jmp    80043a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e6:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8003ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f1:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003f7:	83 ec 04             	sub    $0x4,%esp
  8003fa:	52                   	push   %edx
  8003fb:	50                   	push   %eax
  8003fc:	68 f0 43 80 00       	push   $0x8043f0
  800401:	e8 65 03 00 00       	call   80076b <cprintf>
  800406:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800409:	a1 20 50 80 00       	mov    0x805020,%eax
  80040e:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800414:	a1 20 50 80 00       	mov    0x805020,%eax
  800419:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80041f:	a1 20 50 80 00       	mov    0x805020,%eax
  800424:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80042a:	51                   	push   %ecx
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	68 18 44 80 00       	push   $0x804418
  800432:	e8 34 03 00 00       	call   80076b <cprintf>
  800437:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043a:	a1 20 50 80 00       	mov    0x805020,%eax
  80043f:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	50                   	push   %eax
  800449:	68 70 44 80 00       	push   $0x804470
  80044e:	e8 18 03 00 00       	call   80076b <cprintf>
  800453:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800456:	83 ec 0c             	sub    $0xc,%esp
  800459:	68 a4 43 80 00       	push   $0x8043a4
  80045e:	e8 08 03 00 00       	call   80076b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800466:	e8 d4 2a 00 00       	call   802f3f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80046b:	e8 1f 00 00 00       	call   80048f <exit>
}
  800470:	90                   	nop
  800471:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800474:	5b                   	pop    %ebx
  800475:	5e                   	pop    %esi
  800476:	5f                   	pop    %edi
  800477:	5d                   	pop    %ebp
  800478:	c3                   	ret    

00800479 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	6a 00                	push   $0x0
  800484:	e8 e1 2c 00 00       	call   80316a <sys_destroy_env>
  800489:	83 c4 10             	add    $0x10,%esp
}
  80048c:	90                   	nop
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <exit>:

void
exit(void)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800495:	e8 36 2d 00 00       	call   8031d0 <sys_exit_env>
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a6:	83 c0 04             	add    $0x4,%eax
  8004a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ac:	a1 38 51 83 00       	mov    0x835138,%eax
  8004b1:	85 c0                	test   %eax,%eax
  8004b3:	74 16                	je     8004cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b5:	a1 38 51 83 00       	mov    0x835138,%eax
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	50                   	push   %eax
  8004be:	68 e8 44 80 00       	push   $0x8044e8
  8004c3:	e8 a3 02 00 00       	call   80076b <cprintf>
  8004c8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004cb:	a1 04 50 80 00       	mov    0x805004,%eax
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	50                   	push   %eax
  8004da:	68 f0 44 80 00       	push   $0x8044f0
  8004df:	6a 74                	push   $0x74
  8004e1:	e8 b2 02 00 00       	call   800798 <cprintf_colored>
  8004e6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f2:	50                   	push   %eax
  8004f3:	e8 04 02 00 00       	call   8006fc <vcprintf>
  8004f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	6a 00                	push   $0x0
  800500:	68 18 45 80 00       	push   $0x804518
  800505:	e8 f2 01 00 00       	call   8006fc <vcprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80050d:	e8 7d ff ff ff       	call   80048f <exit>

	// should not return here
	while (1) ;
  800512:	eb fe                	jmp    800512 <_panic+0x75>

00800514 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800514:	55                   	push   %ebp
  800515:	89 e5                	mov    %esp,%ebp
  800517:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051a:	a1 20 50 80 00       	mov    0x805020,%eax
  80051f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	74 14                	je     800540 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052c:	83 ec 04             	sub    $0x4,%esp
  80052f:	68 1c 45 80 00       	push   $0x80451c
  800534:	6a 26                	push   $0x26
  800536:	68 68 45 80 00       	push   $0x804568
  80053b:	e8 5d ff ff ff       	call   80049d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800547:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80054e:	e9 c5 00 00 00       	jmp    800618 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	85 c0                	test   %eax,%eax
  800566:	75 08                	jne    800570 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800568:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056b:	e9 a5 00 00 00       	jmp    800615 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800570:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80057e:	eb 69                	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800580:	a1 20 50 80 00       	mov    0x805020,%eax
  800585:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80058b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	84 c0                	test   %al,%al
  80059e:	75 46                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ae:	89 d0                	mov    %edx,%eax
  8005b0:	01 c0                	add    %eax,%eax
  8005b2:	01 d0                	add    %edx,%eax
  8005b4:	c1 e0 03             	shl    $0x3,%eax
  8005b7:	01 c8                	add    %ecx,%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	01 c8                	add    %ecx,%eax
  8005d7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d9:	39 c2                	cmp    %eax,%edx
  8005db:	75 09                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005dd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e4:	eb 15                	jmp    8005fb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e6:	ff 45 e8             	incl   -0x18(%ebp)
  8005e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	77 85                	ja     800580 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005ff:	75 14                	jne    800615 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800601:	83 ec 04             	sub    $0x4,%esp
  800604:	68 74 45 80 00       	push   $0x804574
  800609:	6a 3a                	push   $0x3a
  80060b:	68 68 45 80 00       	push   $0x804568
  800610:	e8 88 fe ff ff       	call   80049d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800615:	ff 45 f0             	incl   -0x10(%ebp)
  800618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061e:	0f 8c 2f ff ff ff    	jl     800553 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800624:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800632:	eb 26                	jmp    80065a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800634:	a1 20 50 80 00       	mov    0x805020,%eax
  800639:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80063f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800642:	89 d0                	mov    %edx,%eax
  800644:	01 c0                	add    %eax,%eax
  800646:	01 d0                	add    %edx,%eax
  800648:	c1 e0 03             	shl    $0x3,%eax
  80064b:	01 c8                	add    %ecx,%eax
  80064d:	8a 40 04             	mov    0x4(%eax),%al
  800650:	3c 01                	cmp    $0x1,%al
  800652:	75 03                	jne    800657 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800654:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800657:	ff 45 e0             	incl   -0x20(%ebp)
  80065a:	a1 20 50 80 00       	mov    0x805020,%eax
  80065f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800668:	39 c2                	cmp    %eax,%edx
  80066a:	77 c8                	ja     800634 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800672:	74 14                	je     800688 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800674:	83 ec 04             	sub    $0x4,%esp
  800677:	68 c8 45 80 00       	push   $0x8045c8
  80067c:	6a 44                	push   $0x44
  80067e:	68 68 45 80 00       	push   $0x804568
  800683:	e8 15 fe ff ff       	call   80049d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800688:	90                   	nop
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	53                   	push   %ebx
  80068f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800692:	8b 45 0c             	mov    0xc(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	8d 48 01             	lea    0x1(%eax),%ecx
  80069a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069d:	89 0a                	mov    %ecx,(%edx)
  80069f:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a2:	88 d1                	mov    %dl,%cl
  8006a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b5:	75 30                	jne    8006e7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b7:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006bd:	a0 64 d0 81 00       	mov    0x81d064,%al
  8006c2:	0f b6 c0             	movzbl %al,%eax
  8006c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c8:	8b 09                	mov    (%ecx),%ecx
  8006ca:	89 cb                	mov    %ecx,%ebx
  8006cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006cf:	83 c1 08             	add    $0x8,%ecx
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	53                   	push   %ebx
  8006d5:	51                   	push   %ecx
  8006d6:	e8 06 28 00 00       	call   802ee1 <sys_cputs>
  8006db:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	8b 40 04             	mov    0x4(%eax),%eax
  8006ed:	8d 50 01             	lea    0x1(%eax),%edx
  8006f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f6:	90                   	nop
  8006f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800705:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80070c:	00 00 00 
	b.cnt = 0;
  80070f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800716:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	ff 75 08             	pushl  0x8(%ebp)
  80071f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800725:	50                   	push   %eax
  800726:	68 8b 06 80 00       	push   $0x80068b
  80072b:	e8 5a 02 00 00       	call   80098a <vprintfmt>
  800730:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800733:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800739:	a0 64 d0 81 00       	mov    0x81d064,%al
  80073e:	0f b6 c0             	movzbl %al,%eax
  800741:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800747:	52                   	push   %edx
  800748:	50                   	push   %eax
  800749:	51                   	push   %ecx
  80074a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800750:	83 c0 08             	add    $0x8,%eax
  800753:	50                   	push   %eax
  800754:	e8 88 27 00 00       	call   802ee1 <sys_cputs>
  800759:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80075c:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800763:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    

0080076b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800771:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800778:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 f4             	pushl  -0xc(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 6f ff ff ff       	call   8006fc <vcprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80079e:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	c1 e0 08             	shl    $0x8,%eax
  8007ab:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  8007b0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b3:	83 c0 04             	add    $0x4,%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 34 ff ff ff       	call   8006fc <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ce:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  8007d5:	07 00 00 

	return cnt;
  8007d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    

008007dd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e3:	e8 3d 27 00 00       	call   802f25 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	e8 ff fe ff ff       	call   8006fc <vcprintf>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800803:	e8 37 27 00 00       	call   802f3f <sys_unlock_cons>
	return cnt;
  800808:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    

0080080d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	53                   	push   %ebx
  800811:	83 ec 14             	sub    $0x14,%esp
  800814:	8b 45 10             	mov    0x10(%ebp),%eax
  800817:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800820:	8b 45 18             	mov    0x18(%ebp),%eax
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
  800828:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082b:	77 55                	ja     800882 <printnum+0x75>
  80082d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800830:	72 05                	jb     800837 <printnum+0x2a>
  800832:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800835:	77 4b                	ja     800882 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800837:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80083a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083d:	8b 45 18             	mov    0x18(%ebp),%eax
  800840:	ba 00 00 00 00       	mov    $0x0,%edx
  800845:	52                   	push   %edx
  800846:	50                   	push   %eax
  800847:	ff 75 f4             	pushl  -0xc(%ebp)
  80084a:	ff 75 f0             	pushl  -0x10(%ebp)
  80084d:	e8 a6 36 00 00       	call   803ef8 <__udivdi3>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	83 ec 04             	sub    $0x4,%esp
  800858:	ff 75 20             	pushl  0x20(%ebp)
  80085b:	53                   	push   %ebx
  80085c:	ff 75 18             	pushl  0x18(%ebp)
  80085f:	52                   	push   %edx
  800860:	50                   	push   %eax
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	ff 75 08             	pushl  0x8(%ebp)
  800867:	e8 a1 ff ff ff       	call   80080d <printnum>
  80086c:	83 c4 20             	add    $0x20,%esp
  80086f:	eb 1a                	jmp    80088b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 20             	pushl  0x20(%ebp)
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800882:	ff 4d 1c             	decl   0x1c(%ebp)
  800885:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800889:	7f e6                	jg     800871 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800896:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800899:	53                   	push   %ebx
  80089a:	51                   	push   %ecx
  80089b:	52                   	push   %edx
  80089c:	50                   	push   %eax
  80089d:	e8 66 37 00 00       	call   804008 <__umoddi3>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	05 34 48 80 00       	add    $0x804834,%eax
  8008aa:	8a 00                	mov    (%eax),%al
  8008ac:	0f be c0             	movsbl %al,%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	50                   	push   %eax
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
}
  8008be:	90                   	nop
  8008bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cb:	7e 1c                	jle    8008e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	8d 50 08             	lea    0x8(%eax),%edx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	89 10                	mov    %edx,(%eax)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	83 e8 08             	sub    $0x8,%eax
  8008e2:	8b 50 04             	mov    0x4(%eax),%edx
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	eb 40                	jmp    800929 <getuint+0x65>
	else if (lflag)
  8008e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ed:	74 1e                	je     80090d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 50 04             	lea    0x4(%eax),%edx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	89 10                	mov    %edx,(%eax)
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	83 e8 04             	sub    $0x4,%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
  80090b:	eb 1c                	jmp    800929 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800932:	7e 1c                	jle    800950 <getint+0x25>
		return va_arg(*ap, long long);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 08             	lea    0x8(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 08             	sub    $0x8,%eax
  800949:	8b 50 04             	mov    0x4(%eax),%edx
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	eb 38                	jmp    800988 <getint+0x5d>
	else if (lflag)
  800950:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800954:	74 1a                	je     800970 <getint+0x45>
		return va_arg(*ap, long);
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	8d 50 04             	lea    0x4(%eax),%edx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	89 10                	mov    %edx,(%eax)
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	99                   	cltd   
  80096e:	eb 18                	jmp    800988 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	8d 50 04             	lea    0x4(%eax),%edx
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	89 10                	mov    %edx,(%eax)
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	83 e8 04             	sub    $0x4,%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	99                   	cltd   
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800992:	eb 17                	jmp    8009ab <vprintfmt+0x21>
			if (ch == '\0')
  800994:	85 db                	test   %ebx,%ebx
  800996:	0f 84 c1 03 00 00    	je     800d5d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	53                   	push   %ebx
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	ff d0                	call   *%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ae:	8d 50 01             	lea    0x1(%eax),%edx
  8009b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	0f b6 d8             	movzbl %al,%ebx
  8009b9:	83 fb 25             	cmp    $0x25,%ebx
  8009bc:	75 d6                	jne    800994 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009de:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e1:	8d 50 01             	lea    0x1(%eax),%edx
  8009e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	0f b6 d8             	movzbl %al,%ebx
  8009ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ef:	83 f8 5b             	cmp    $0x5b,%eax
  8009f2:	0f 87 3d 03 00 00    	ja     800d35 <vprintfmt+0x3ab>
  8009f8:	8b 04 85 58 48 80 00 	mov    0x804858(,%eax,4),%eax
  8009ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a01:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a05:	eb d7                	jmp    8009de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a07:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0b:	eb d1                	jmp    8009de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a17:	89 d0                	mov    %edx,%eax
  800a19:	c1 e0 02             	shl    $0x2,%eax
  800a1c:	01 d0                	add    %edx,%eax
  800a1e:	01 c0                	add    %eax,%eax
  800a20:	01 d8                	add    %ebx,%eax
  800a22:	83 e8 30             	sub    $0x30,%eax
  800a25:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a28:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a30:	83 fb 2f             	cmp    $0x2f,%ebx
  800a33:	7e 3e                	jle    800a73 <vprintfmt+0xe9>
  800a35:	83 fb 39             	cmp    $0x39,%ebx
  800a38:	7f 39                	jg     800a73 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3d:	eb d5                	jmp    800a14 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	83 c0 04             	add    $0x4,%eax
  800a45:	89 45 14             	mov    %eax,0x14(%ebp)
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 e8 04             	sub    $0x4,%eax
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a53:	eb 1f                	jmp    800a74 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a59:	79 83                	jns    8009de <vprintfmt+0x54>
				width = 0;
  800a5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a62:	e9 77 ff ff ff       	jmp    8009de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a67:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6e:	e9 6b ff ff ff       	jmp    8009de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a73:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a78:	0f 89 60 ff ff ff    	jns    8009de <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a84:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8b:	e9 4e ff ff ff       	jmp    8009de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a90:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a93:	e9 46 ff ff ff       	jmp    8009de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 c0 04             	add    $0x4,%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 e8 04             	sub    $0x4,%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	50                   	push   %eax
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			break;
  800ab8:	e9 9b 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	83 c0 04             	add    $0x4,%eax
  800ac3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 e8 04             	sub    $0x4,%eax
  800acc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ace:	85 db                	test   %ebx,%ebx
  800ad0:	79 02                	jns    800ad4 <vprintfmt+0x14a>
				err = -err;
  800ad2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad4:	83 fb 64             	cmp    $0x64,%ebx
  800ad7:	7f 0b                	jg     800ae4 <vprintfmt+0x15a>
  800ad9:	8b 34 9d a0 46 80 00 	mov    0x8046a0(,%ebx,4),%esi
  800ae0:	85 f6                	test   %esi,%esi
  800ae2:	75 19                	jne    800afd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae4:	53                   	push   %ebx
  800ae5:	68 45 48 80 00       	push   $0x804845
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	ff 75 08             	pushl  0x8(%ebp)
  800af0:	e8 70 02 00 00       	call   800d65 <printfmt>
  800af5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af8:	e9 5b 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afd:	56                   	push   %esi
  800afe:	68 4e 48 80 00       	push   $0x80484e
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 57 02 00 00       	call   800d65 <printfmt>
  800b0e:	83 c4 10             	add    $0x10,%esp
			break;
  800b11:	e9 42 02 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 30                	mov    (%eax),%esi
  800b27:	85 f6                	test   %esi,%esi
  800b29:	75 05                	jne    800b30 <vprintfmt+0x1a6>
				p = "(null)";
  800b2b:	be 51 48 80 00       	mov    $0x804851,%esi
			if (width > 0 && padc != '-')
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	7e 6d                	jle    800ba3 <vprintfmt+0x219>
  800b36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b3a:	74 67                	je     800ba3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	50                   	push   %eax
  800b43:	56                   	push   %esi
  800b44:	e8 1e 03 00 00       	call   800e67 <strnlen>
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4f:	eb 16                	jmp    800b67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b64:	ff 4d e4             	decl   -0x1c(%ebp)
  800b67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6b:	7f e4                	jg     800b51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	eb 34                	jmp    800ba3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b73:	74 1c                	je     800b91 <vprintfmt+0x207>
  800b75:	83 fb 1f             	cmp    $0x1f,%ebx
  800b78:	7e 05                	jle    800b7f <vprintfmt+0x1f5>
  800b7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7d:	7e 12                	jle    800b91 <vprintfmt+0x207>
					putch('?', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	6a 3f                	push   $0x3f
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	eb 0f                	jmp    800ba0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	53                   	push   %ebx
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba3:	89 f0                	mov    %esi,%eax
  800ba5:	8d 70 01             	lea    0x1(%eax),%esi
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	0f be d8             	movsbl %al,%ebx
  800bad:	85 db                	test   %ebx,%ebx
  800baf:	74 24                	je     800bd5 <vprintfmt+0x24b>
  800bb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb5:	78 b8                	js     800b6f <vprintfmt+0x1e5>
  800bb7:	ff 4d e0             	decl   -0x20(%ebp)
  800bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbe:	79 af                	jns    800b6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc0:	eb 13                	jmp    800bd5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	6a 20                	push   $0x20
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	ff d0                	call   *%eax
  800bcf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd9:	7f e7                	jg     800bc2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bdb:	e9 78 01 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 e8             	pushl  -0x18(%ebp)
  800be6:	8d 45 14             	lea    0x14(%ebp),%eax
  800be9:	50                   	push   %eax
  800bea:	e8 3c fd ff ff       	call   80092b <getint>
  800bef:	83 c4 10             	add    $0x10,%esp
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfe:	85 d2                	test   %edx,%edx
  800c00:	79 23                	jns    800c25 <vprintfmt+0x29b>
				putch('-', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 2d                	push   $0x2d
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c18:	f7 d8                	neg    %eax
  800c1a:	83 d2 00             	adc    $0x0,%edx
  800c1d:	f7 da                	neg    %edx
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2c:	e9 bc 00 00 00       	jmp    800ced <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 e8             	pushl  -0x18(%ebp)
  800c37:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3a:	50                   	push   %eax
  800c3b:	e8 84 fc ff ff       	call   8008c4 <getuint>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c50:	e9 98 00 00 00       	jmp    800ced <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	6a 58                	push   $0x58
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff d0                	call   *%eax
  800c62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	ff 75 0c             	pushl  0xc(%ebp)
  800c6b:	6a 58                	push   $0x58
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	ff d0                	call   *%eax
  800c72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 58                	push   $0x58
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			break;
  800c85:	e9 ce 00 00 00       	jmp    800d58 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	6a 30                	push   $0x30
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	ff d0                	call   *%eax
  800c97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	6a 78                	push   $0x78
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	ff d0                	call   *%eax
  800ca7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	83 c0 04             	add    $0x4,%eax
  800cb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 e8 04             	sub    $0x4,%eax
  800cb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccc:	eb 1f                	jmp    800ced <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd7:	50                   	push   %eax
  800cd8:	e8 e7 fb ff ff       	call   8008c4 <getuint>
  800cdd:	83 c4 10             	add    $0x10,%esp
  800ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ced:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf4:	83 ec 04             	sub    $0x4,%esp
  800cf7:	52                   	push   %edx
  800cf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800cff:	ff 75 f0             	pushl  -0x10(%ebp)
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	ff 75 08             	pushl  0x8(%ebp)
  800d08:	e8 00 fb ff ff       	call   80080d <printnum>
  800d0d:	83 c4 20             	add    $0x20,%esp
			break;
  800d10:	eb 46                	jmp    800d58 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	53                   	push   %ebx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			break;
  800d21:	eb 35                	jmp    800d58 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d23:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800d2a:	eb 2c                	jmp    800d58 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d2c:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800d33:	eb 23                	jmp    800d58 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	6a 25                	push   $0x25
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	ff d0                	call   *%eax
  800d42:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	eb 03                	jmp    800d4d <vprintfmt+0x3c3>
  800d4a:	ff 4d 10             	decl   0x10(%ebp)
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	48                   	dec    %eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3c 25                	cmp    $0x25,%al
  800d55:	75 f3                	jne    800d4a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d57:	90                   	nop
		}
	}
  800d58:	e9 35 fc ff ff       	jmp    800992 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d5d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d6e:	83 c0 04             	add    $0x4,%eax
  800d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d74:	8b 45 10             	mov    0x10(%ebp),%eax
  800d77:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7a:	50                   	push   %eax
  800d7b:	ff 75 0c             	pushl  0xc(%ebp)
  800d7e:	ff 75 08             	pushl  0x8(%ebp)
  800d81:	e8 04 fc ff ff       	call   80098a <vprintfmt>
  800d86:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d89:	90                   	nop
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8b 40 08             	mov    0x8(%eax),%eax
  800d95:	8d 50 01             	lea    0x1(%eax),%edx
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	8b 10                	mov    (%eax),%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8b 40 04             	mov    0x4(%eax),%eax
  800da9:	39 c2                	cmp    %eax,%edx
  800dab:	73 12                	jae    800dbf <sprintputch+0x33>
		*b->buf++ = ch;
  800dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db0:	8b 00                	mov    (%eax),%eax
  800db2:	8d 48 01             	lea    0x1(%eax),%ecx
  800db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db8:	89 0a                	mov    %ecx,(%edx)
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	88 10                	mov    %dl,(%eax)
}
  800dbf:	90                   	nop
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	01 d0                	add    %edx,%eax
  800dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de7:	74 06                	je     800def <vsnprintf+0x2d>
  800de9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ded:	7f 07                	jg     800df6 <vsnprintf+0x34>
		return -E_INVAL;
  800def:	b8 03 00 00 00       	mov    $0x3,%eax
  800df4:	eb 20                	jmp    800e16 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df6:	ff 75 14             	pushl  0x14(%ebp)
  800df9:	ff 75 10             	pushl  0x10(%ebp)
  800dfc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dff:	50                   	push   %eax
  800e00:	68 8c 0d 80 00       	push   $0x800d8c
  800e05:	e8 80 fb ff ff       	call   80098a <vprintfmt>
  800e0a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e10:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e1e:	8d 45 10             	lea    0x10(%ebp),%eax
  800e21:	83 c0 04             	add    $0x4,%eax
  800e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2d:	50                   	push   %eax
  800e2e:	ff 75 0c             	pushl  0xc(%ebp)
  800e31:	ff 75 08             	pushl  0x8(%ebp)
  800e34:	e8 89 ff ff ff       	call   800dc2 <vsnprintf>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e51:	eb 06                	jmp    800e59 <strlen+0x15>
		n++;
  800e53:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e56:	ff 45 08             	incl   0x8(%ebp)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	84 c0                	test   %al,%al
  800e60:	75 f1                	jne    800e53 <strlen+0xf>
		n++;
	return n;
  800e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e74:	eb 09                	jmp    800e7f <strnlen+0x18>
		n++;
  800e76:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e79:	ff 45 08             	incl   0x8(%ebp)
  800e7c:	ff 4d 0c             	decl   0xc(%ebp)
  800e7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e83:	74 09                	je     800e8e <strnlen+0x27>
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e8                	jne    800e76 <strnlen+0xf>
		n++;
	return n;
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e91:	c9                   	leave  
  800e92:	c3                   	ret    

00800e93 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e9f:	90                   	nop
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8d 50 01             	lea    0x1(%eax),%edx
  800ea6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eac:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eaf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb2:	8a 12                	mov    (%edx),%dl
  800eb4:	88 10                	mov    %dl,(%eax)
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	84 c0                	test   %al,%al
  800eba:	75 e4                	jne    800ea0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed4:	eb 1f                	jmp    800ef5 <strncpy+0x34>
		*dst++ = *src;
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 08             	mov    %edx,0x8(%ebp)
  800edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee2:	8a 12                	mov    (%edx),%dl
  800ee4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 03                	je     800ef2 <strncpy+0x31>
			src++;
  800eef:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef2:	ff 45 fc             	incl   -0x4(%ebp)
  800ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800efb:	72 d9                	jb     800ed6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f12:	74 30                	je     800f44 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f14:	eb 16                	jmp    800f2c <strlcpy+0x2a>
			*dst++ = *src++;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8d 50 01             	lea    0x1(%eax),%edx
  800f1c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f22:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f25:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f28:	8a 12                	mov    (%edx),%dl
  800f2a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2c:	ff 4d 10             	decl   0x10(%ebp)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 09                	je     800f3e <strlcpy+0x3c>
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	75 d8                	jne    800f16 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f44:	8b 55 08             	mov    0x8(%ebp),%edx
  800f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f53:	eb 06                	jmp    800f5b <strcmp+0xb>
		p++, q++;
  800f55:	ff 45 08             	incl   0x8(%ebp)
  800f58:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	84 c0                	test   %al,%al
  800f62:	74 0e                	je     800f72 <strcmp+0x22>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 10                	mov    (%eax),%dl
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	38 c2                	cmp    %al,%dl
  800f70:	74 e3                	je     800f55 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	0f b6 d0             	movzbl %al,%edx
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	0f b6 c0             	movzbl %al,%eax
  800f82:	29 c2                	sub    %eax,%edx
  800f84:	89 d0                	mov    %edx,%eax
}
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    

00800f88 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f8b:	eb 09                	jmp    800f96 <strncmp+0xe>
		n--, p++, q++;
  800f8d:	ff 4d 10             	decl   0x10(%ebp)
  800f90:	ff 45 08             	incl   0x8(%ebp)
  800f93:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9a:	74 17                	je     800fb3 <strncmp+0x2b>
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	74 0e                	je     800fb3 <strncmp+0x2b>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 10                	mov    (%eax),%dl
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	38 c2                	cmp    %al,%dl
  800fb1:	74 da                	je     800f8d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	75 07                	jne    800fc0 <strncmp+0x38>
		return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbe:	eb 14                	jmp    800fd4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f b6 d0             	movzbl %al,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	0f b6 c0             	movzbl %al,%eax
  800fd0:	29 c2                	sub    %eax,%edx
  800fd2:	89 d0                	mov    %edx,%eax
}
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe2:	eb 12                	jmp    800ff6 <strchr+0x20>
		if (*s == c)
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fec:	75 05                	jne    800ff3 <strchr+0x1d>
			return (char *) s;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	eb 11                	jmp    801004 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ff3:	ff 45 08             	incl   0x8(%ebp)
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	84 c0                	test   %al,%al
  800ffd:	75 e5                	jne    800fe4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 04             	sub    $0x4,%esp
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801012:	eb 0d                	jmp    801021 <strfind+0x1b>
		if (*s == c)
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101c:	74 0e                	je     80102c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	84 c0                	test   %al,%al
  801028:	75 ea                	jne    801014 <strfind+0xe>
  80102a:	eb 01                	jmp    80102d <strfind+0x27>
		if (*s == c)
			break;
  80102c:	90                   	nop
	return (char *) s;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80103e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801042:	76 63                	jbe    8010a7 <memset+0x75>
		uint64 data_block = c;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	99                   	cltd   
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80104e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801054:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801058:	c1 e0 08             	shl    $0x8,%eax
  80105b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801067:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80106b:	c1 e0 10             	shl    $0x10,%eax
  80106e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801071:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	b8 00 00 00 00       	mov    $0x0,%eax
  801081:	09 45 f0             	or     %eax,-0x10(%ebp)
  801084:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801087:	eb 18                	jmp    8010a1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801089:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108c:	8d 41 08             	lea    0x8(%ecx),%eax
  80108f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801098:	89 01                	mov    %eax,(%ecx)
  80109a:	89 51 04             	mov    %edx,0x4(%ecx)
  80109d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010a1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a5:	77 e2                	ja     801089 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	74 23                	je     8010d0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b3:	eb 0e                	jmp    8010c3 <memset+0x91>
			*p8++ = (uint8)c;
  8010b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b8:	8d 50 01             	lea    0x1(%eax),%edx
  8010bb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	75 e5                	jne    8010b5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010e7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010eb:	76 24                	jbe    801111 <memcpy+0x3c>
		while(n >= 8){
  8010ed:	eb 1c                	jmp    80110b <memcpy+0x36>
			*d64 = *s64;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f2:	8b 50 04             	mov    0x4(%eax),%edx
  8010f5:	8b 00                	mov    (%eax),%eax
  8010f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010fa:	89 01                	mov    %eax,(%ecx)
  8010fc:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010ff:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801103:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801107:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80110b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80110f:	77 de                	ja     8010ef <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801111:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801115:	74 31                	je     801148 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80111d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801120:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801123:	eb 16                	jmp    80113b <memcpy+0x66>
			*d8++ = *s8++;
  801125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801128:	8d 50 01             	lea    0x1(%eax),%edx
  80112b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80112e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801131:	8d 4a 01             	lea    0x1(%edx),%ecx
  801134:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801137:	8a 12                	mov    (%edx),%dl
  801139:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801141:	89 55 10             	mov    %edx,0x10(%ebp)
  801144:	85 c0                	test   %eax,%eax
  801146:	75 dd                	jne    801125 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801153:	8b 45 0c             	mov    0xc(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801162:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801165:	73 50                	jae    8011b7 <memmove+0x6a>
  801167:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116a:	8b 45 10             	mov    0x10(%ebp),%eax
  80116d:	01 d0                	add    %edx,%eax
  80116f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801172:	76 43                	jbe    8011b7 <memmove+0x6a>
		s += n;
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801180:	eb 10                	jmp    801192 <memmove+0x45>
			*--d = *--s;
  801182:	ff 4d f8             	decl   -0x8(%ebp)
  801185:	ff 4d fc             	decl   -0x4(%ebp)
  801188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118b:	8a 10                	mov    (%eax),%dl
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	8d 50 ff             	lea    -0x1(%eax),%edx
  801198:	89 55 10             	mov    %edx,0x10(%ebp)
  80119b:	85 c0                	test   %eax,%eax
  80119d:	75 e3                	jne    801182 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80119f:	eb 23                	jmp    8011c4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	8d 50 01             	lea    0x1(%eax),%edx
  8011a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011b3:	8a 12                	mov    (%edx),%dl
  8011b5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	75 dd                	jne    8011a1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011db:	eb 2a                	jmp    801207 <memcmp+0x3e>
		if (*s1 != *s2)
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 10                	mov    (%eax),%dl
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	38 c2                	cmp    %al,%dl
  8011e9:	74 16                	je     801201 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	0f b6 d0             	movzbl %al,%edx
  8011f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f b6 c0             	movzbl %al,%eax
  8011fb:	29 c2                	sub    %eax,%edx
  8011fd:	89 d0                	mov    %edx,%eax
  8011ff:	eb 18                	jmp    801219 <memcmp+0x50>
		s1++, s2++;
  801201:	ff 45 fc             	incl   -0x4(%ebp)
  801204:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801207:	8b 45 10             	mov    0x10(%ebp),%eax
  80120a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120d:	89 55 10             	mov    %edx,0x10(%ebp)
  801210:	85 c0                	test   %eax,%eax
  801212:	75 c9                	jne    8011dd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801214:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801221:	8b 55 08             	mov    0x8(%ebp),%edx
  801224:	8b 45 10             	mov    0x10(%ebp),%eax
  801227:	01 d0                	add    %edx,%eax
  801229:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80122c:	eb 15                	jmp    801243 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	0f b6 d0             	movzbl %al,%edx
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	0f b6 c0             	movzbl %al,%eax
  80123c:	39 c2                	cmp    %eax,%edx
  80123e:	74 0d                	je     80124d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801240:	ff 45 08             	incl   0x8(%ebp)
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801249:	72 e3                	jb     80122e <memfind+0x13>
  80124b:	eb 01                	jmp    80124e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80124d:	90                   	nop
	return (void *) s;
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801260:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801267:	eb 03                	jmp    80126c <strtol+0x19>
		s++;
  801269:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 20                	cmp    $0x20,%al
  801273:	74 f4                	je     801269 <strtol+0x16>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 09                	cmp    $0x9,%al
  80127c:	74 eb                	je     801269 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2b                	cmp    $0x2b,%al
  801285:	75 05                	jne    80128c <strtol+0x39>
		s++;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	eb 13                	jmp    80129f <strtol+0x4c>
	else if (*s == '-')
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 2d                	cmp    $0x2d,%al
  801293:	75 0a                	jne    80129f <strtol+0x4c>
		s++, neg = 1;
  801295:	ff 45 08             	incl   0x8(%ebp)
  801298:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80129f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a3:	74 06                	je     8012ab <strtol+0x58>
  8012a5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012a9:	75 20                	jne    8012cb <strtol+0x78>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 30                	cmp    $0x30,%al
  8012b2:	75 17                	jne    8012cb <strtol+0x78>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	40                   	inc    %eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	3c 78                	cmp    $0x78,%al
  8012bc:	75 0d                	jne    8012cb <strtol+0x78>
		s += 2, base = 16;
  8012be:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012c2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012c9:	eb 28                	jmp    8012f3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	75 15                	jne    8012e6 <strtol+0x93>
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	3c 30                	cmp    $0x30,%al
  8012d8:	75 0c                	jne    8012e6 <strtol+0x93>
		s++, base = 8;
  8012da:	ff 45 08             	incl   0x8(%ebp)
  8012dd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012e4:	eb 0d                	jmp    8012f3 <strtol+0xa0>
	else if (base == 0)
  8012e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ea:	75 07                	jne    8012f3 <strtol+0xa0>
		base = 10;
  8012ec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	3c 2f                	cmp    $0x2f,%al
  8012fa:	7e 19                	jle    801315 <strtol+0xc2>
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 39                	cmp    $0x39,%al
  801303:	7f 10                	jg     801315 <strtol+0xc2>
			dig = *s - '0';
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f be c0             	movsbl %al,%eax
  80130d:	83 e8 30             	sub    $0x30,%eax
  801310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801313:	eb 42                	jmp    801357 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	8a 00                	mov    (%eax),%al
  80131a:	3c 60                	cmp    $0x60,%al
  80131c:	7e 19                	jle    801337 <strtol+0xe4>
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	3c 7a                	cmp    $0x7a,%al
  801325:	7f 10                	jg     801337 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	0f be c0             	movsbl %al,%eax
  80132f:	83 e8 57             	sub    $0x57,%eax
  801332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801335:	eb 20                	jmp    801357 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	3c 40                	cmp    $0x40,%al
  80133e:	7e 39                	jle    801379 <strtol+0x126>
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	3c 5a                	cmp    $0x5a,%al
  801347:	7f 30                	jg     801379 <strtol+0x126>
			dig = *s - 'A' + 10;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	0f be c0             	movsbl %al,%eax
  801351:	83 e8 37             	sub    $0x37,%eax
  801354:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80135d:	7d 19                	jge    801378 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80135f:	ff 45 08             	incl   0x8(%ebp)
  801362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801365:	0f af 45 10          	imul   0x10(%ebp),%eax
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801373:	e9 7b ff ff ff       	jmp    8012f3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801378:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137d:	74 08                	je     801387 <strtol+0x134>
		*endptr = (char *) s;
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801387:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80138b:	74 07                	je     801394 <strtol+0x141>
  80138d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801390:	f7 d8                	neg    %eax
  801392:	eb 03                	jmp    801397 <strtol+0x144>
  801394:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <ltostr>:

void
ltostr(long value, char *str)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80139f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b1:	79 13                	jns    8013c6 <ltostr+0x2d>
	{
		neg = 1;
  8013b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013ce:	99                   	cltd   
  8013cf:	f7 f9                	idiv   %ecx
  8013d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d7:	8d 50 01             	lea    0x1(%eax),%edx
  8013da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013dd:	89 c2                	mov    %eax,%edx
  8013df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013e7:	83 c2 30             	add    $0x30,%edx
  8013ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f4:	f7 e9                	imul   %ecx
  8013f6:	c1 fa 02             	sar    $0x2,%edx
  8013f9:	89 c8                	mov    %ecx,%eax
  8013fb:	c1 f8 1f             	sar    $0x1f,%eax
  8013fe:	29 c2                	sub    %eax,%edx
  801400:	89 d0                	mov    %edx,%eax
  801402:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801409:	75 bb                	jne    8013c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80140b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801412:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801415:	48                   	dec    %eax
  801416:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801419:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141d:	74 3d                	je     80145c <ltostr+0xc3>
		start = 1 ;
  80141f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801426:	eb 34                	jmp    80145c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	01 d0                	add    %edx,%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801435:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	01 c2                	add    %eax,%edx
  80143d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	01 c8                	add    %ecx,%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801449:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144f:	01 c2                	add    %eax,%edx
  801451:	8a 45 eb             	mov    -0x15(%ebp),%al
  801454:	88 02                	mov    %al,(%edx)
		start++ ;
  801456:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801459:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80145c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801462:	7c c4                	jl     801428 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801464:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	01 d0                	add    %edx,%eax
  80146c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80146f:	90                   	nop
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801478:	ff 75 08             	pushl  0x8(%ebp)
  80147b:	e8 c4 f9 ff ff       	call   800e44 <strlen>
  801480:	83 c4 04             	add    $0x4,%esp
  801483:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	e8 b6 f9 ff ff       	call   800e44 <strlen>
  80148e:	83 c4 04             	add    $0x4,%esp
  801491:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801494:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80149b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a2:	eb 17                	jmp    8014bb <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014aa:	01 c2                	add    %eax,%edx
  8014ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	01 c8                	add    %ecx,%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014b8:	ff 45 fc             	incl   -0x4(%ebp)
  8014bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c1:	7c e1                	jl     8014a4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d1:	eb 1f                	jmp    8014f2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d6:	8d 50 01             	lea    0x1(%eax),%edx
  8014d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014dc:	89 c2                	mov    %eax,%edx
  8014de:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e1:	01 c2                	add    %eax,%edx
  8014e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	01 c8                	add    %ecx,%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014ef:	ff 45 f8             	incl   -0x8(%ebp)
  8014f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014f8:	7c d9                	jl     8014d3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801500:	01 d0                	add    %edx,%eax
  801502:	c6 00 00             	movb   $0x0,(%eax)
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80150b:	8b 45 14             	mov    0x14(%ebp),%eax
  80150e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801514:	8b 45 14             	mov    0x14(%ebp),%eax
  801517:	8b 00                	mov    (%eax),%eax
  801519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801520:	8b 45 10             	mov    0x10(%ebp),%eax
  801523:	01 d0                	add    %edx,%eax
  801525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152b:	eb 0c                	jmp    801539 <strsplit+0x31>
			*string++ = 0;
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8d 50 01             	lea    0x1(%eax),%edx
  801533:	89 55 08             	mov    %edx,0x8(%ebp)
  801536:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	84 c0                	test   %al,%al
  801540:	74 18                	je     80155a <strsplit+0x52>
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f be c0             	movsbl %al,%eax
  80154a:	50                   	push   %eax
  80154b:	ff 75 0c             	pushl  0xc(%ebp)
  80154e:	e8 83 fa ff ff       	call   800fd6 <strchr>
  801553:	83 c4 08             	add    $0x8,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	75 d3                	jne    80152d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	84 c0                	test   %al,%al
  801561:	74 5a                	je     8015bd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801563:	8b 45 14             	mov    0x14(%ebp),%eax
  801566:	8b 00                	mov    (%eax),%eax
  801568:	83 f8 0f             	cmp    $0xf,%eax
  80156b:	75 07                	jne    801574 <strsplit+0x6c>
		{
			return 0;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
  801572:	eb 66                	jmp    8015da <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	8d 48 01             	lea    0x1(%eax),%ecx
  80157c:	8b 55 14             	mov    0x14(%ebp),%edx
  80157f:	89 0a                	mov    %ecx,(%edx)
  801581:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801588:	8b 45 10             	mov    0x10(%ebp),%eax
  80158b:	01 c2                	add    %eax,%edx
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801592:	eb 03                	jmp    801597 <strsplit+0x8f>
			string++;
  801594:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	84 c0                	test   %al,%al
  80159e:	74 8b                	je     80152b <strsplit+0x23>
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	0f be c0             	movsbl %al,%eax
  8015a8:	50                   	push   %eax
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	e8 25 fa ff ff       	call   800fd6 <strchr>
  8015b1:	83 c4 08             	add    $0x8,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	74 dc                	je     801594 <strsplit+0x8c>
			string++;
	}
  8015b8:	e9 6e ff ff ff       	jmp    80152b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015bd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015be:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c1:	8b 00                	mov    (%eax),%eax
  8015c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cd:	01 d0                	add    %edx,%eax
  8015cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ef:	eb 4a                	jmp    80163b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	01 c2                	add    %eax,%edx
  8015f9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	01 c8                	add    %ecx,%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801605:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160b:	01 d0                	add    %edx,%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	3c 40                	cmp    $0x40,%al
  801611:	7e 25                	jle    801638 <str2lower+0x5c>
  801613:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801616:	8b 45 0c             	mov    0xc(%ebp),%eax
  801619:	01 d0                	add    %edx,%eax
  80161b:	8a 00                	mov    (%eax),%al
  80161d:	3c 5a                	cmp    $0x5a,%al
  80161f:	7f 17                	jg     801638 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801621:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162c:	8b 55 08             	mov    0x8(%ebp),%edx
  80162f:	01 ca                	add    %ecx,%edx
  801631:	8a 12                	mov    (%edx),%dl
  801633:	83 c2 20             	add    $0x20,%edx
  801636:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	e8 01 f8 ff ff       	call   800e44 <strlen>
  801643:	83 c4 04             	add    $0x4,%esp
  801646:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801649:	7f a6                	jg     8015f1 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80164b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801656:	a1 08 50 80 00       	mov    0x805008,%eax
  80165b:	85 c0                	test   %eax,%eax
  80165d:	74 42                	je     8016a1 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	68 00 00 00 82       	push   $0x82000000
  801667:	68 00 00 00 80       	push   $0x80000000
  80166c:	e8 b0 1e 00 00       	call   803521 <initialize_dynamic_allocator>
  801671:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801674:	e8 96 1c 00 00       	call   80330f <sys_get_uheap_strategy>
  801679:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80167e:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801683:	05 00 10 00 00       	add    $0x1000,%eax
  801688:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  80168d:	a1 30 51 83 00       	mov    0x835130,%eax
  801692:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801697:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80169e:	00 00 00 
	}
}
  8016a1:	90                   	nop
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b8:	83 ec 08             	sub    $0x8,%esp
  8016bb:	68 06 04 00 00       	push   $0x406
  8016c0:	50                   	push   %eax
  8016c1:	e8 93 18 00 00       	call   802f59 <__sys_allocate_page>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d0:	79 14                	jns    8016e6 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	68 c8 49 80 00       	push   $0x8049c8
  8016da:	6a 1f                	push   $0x1f
  8016dc:	68 04 4a 80 00       	push   $0x804a04
  8016e1:	e8 b7 ed ff ff       	call   80049d <_panic>
	return 0;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801701:	83 ec 0c             	sub    $0xc,%esp
  801704:	50                   	push   %eax
  801705:	e8 96 18 00 00       	call   802fa0 <__sys_unmap_frame>
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801710:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801714:	79 14                	jns    80172a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	68 10 4a 80 00       	push   $0x804a10
  80171e:	6a 2a                	push   $0x2a
  801720:	68 04 4a 80 00       	push   $0x804a04
  801725:	e8 73 ed ff ff       	call   80049d <_panic>
}
  80172a:	90                   	nop
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801733:	e8 18 ff ff ff       	call   801650 <uheap_init>
	if (size == 0) return NULL ;
  801738:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80173c:	75 0a                	jne    801748 <malloc+0x1b>
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
  801743:	e9 43 03 00 00       	jmp    801a8b <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801748:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80174f:	77 13                	ja     801764 <malloc+0x37>
    {
        return alloc_block(size);
  801751:	83 ec 0c             	sub    $0xc,%esp
  801754:	ff 75 08             	pushl  0x8(%ebp)
  801757:	e8 78 20 00 00       	call   8037d4 <alloc_block>
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	e9 27 03 00 00       	jmp    801a8b <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801764:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	48                   	dec    %eax
  801774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801777:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80177a:	ba 00 00 00 00       	mov    $0x0,%edx
  80177f:	f7 75 dc             	divl   -0x24(%ebp)
  801782:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801785:	29 d0                	sub    %edx,%eax
  801787:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80178a:	a1 40 d0 81 00       	mov    0x81d040,%eax
  80178f:	85 c0                	test   %eax,%eax
  801791:	75 0a                	jne    80179d <malloc+0x70>
    {
        uhp_inited = 1;
  801793:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  80179a:	00 00 00 
    }

    int exactIdx = -1;
  80179d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8017a4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8017ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8017b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017b9:	e9 85 00 00 00       	jmp    801843 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8017be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c1:	89 d0                	mov    %edx,%eax
  8017c3:	01 c0                	add    %eax,%eax
  8017c5:	01 d0                	add    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	05 48 10 81 00       	add    $0x811048,%eax
  8017cf:	8a 00                	mov    (%eax),%al
  8017d1:	84 c0                	test   %al,%al
  8017d3:	74 20                	je     8017f5 <malloc+0xc8>
  8017d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017d8:	89 d0                	mov    %edx,%eax
  8017da:	01 c0                	add    %eax,%eax
  8017dc:	01 d0                	add    %edx,%eax
  8017de:	c1 e0 02             	shl    $0x2,%eax
  8017e1:	05 44 10 81 00       	add    $0x811044,%eax
  8017e6:	8b 00                	mov    (%eax),%eax
  8017e8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017eb:	75 08                	jne    8017f5 <malloc+0xc8>
        {
            exactIdx = i;
  8017ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8017f3:	eb 5b                	jmp    801850 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8017f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017f8:	89 d0                	mov    %edx,%eax
  8017fa:	01 c0                	add    %eax,%eax
  8017fc:	01 d0                	add    %edx,%eax
  8017fe:	c1 e0 02             	shl    $0x2,%eax
  801801:	05 48 10 81 00       	add    $0x811048,%eax
  801806:	8a 00                	mov    (%eax),%al
  801808:	84 c0                	test   %al,%al
  80180a:	74 34                	je     801840 <malloc+0x113>
  80180c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80180f:	89 d0                	mov    %edx,%eax
  801811:	01 c0                	add    %eax,%eax
  801813:	01 d0                	add    %edx,%eax
  801815:	c1 e0 02             	shl    $0x2,%eax
  801818:	05 44 10 81 00       	add    $0x811044,%eax
  80181d:	8b 00                	mov    (%eax),%eax
  80181f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801822:	76 1c                	jbe    801840 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801827:	89 d0                	mov    %edx,%eax
  801829:	01 c0                	add    %eax,%eax
  80182b:	01 d0                	add    %edx,%eax
  80182d:	c1 e0 02             	shl    $0x2,%eax
  801830:	05 44 10 81 00       	add    $0x811044,%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80183a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801840:	ff 45 e8             	incl   -0x18(%ebp)
  801843:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80184a:	0f 8e 6e ff ff ff    	jle    8017be <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801850:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801857:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80185b:	74 7d                	je     8018da <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80185d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801864:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801867:	89 d0                	mov    %edx,%eax
  801869:	01 c0                	add    %eax,%eax
  80186b:	01 d0                	add    %edx,%eax
  80186d:	c1 e0 02             	shl    $0x2,%eax
  801870:	05 40 10 81 00       	add    $0x811040,%eax
  801875:	8b 10                	mov    (%eax),%edx
  801877:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80187a:	01 d0                	add    %edx,%eax
  80187c:	48                   	dec    %eax
  80187d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801880:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801883:	ba 00 00 00 00       	mov    $0x0,%edx
  801888:	f7 75 bc             	divl   -0x44(%ebp)
  80188b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80188e:	29 d0                	sub    %edx,%eax
  801890:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	01 c0                	add    %eax,%eax
  80189a:	01 d0                	add    %edx,%eax
  80189c:	c1 e0 02             	shl    $0x2,%eax
  80189f:	05 48 10 81 00       	add    $0x811048,%eax
  8018a4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8018a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018aa:	89 d0                	mov    %edx,%eax
  8018ac:	01 c0                	add    %eax,%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	c1 e0 02             	shl    $0x2,%eax
  8018b3:	05 44 10 81 00       	add    $0x811044,%eax
  8018b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	89 d0                	mov    %edx,%eax
  8018c3:	01 c0                	add    %eax,%eax
  8018c5:	01 d0                	add    %edx,%eax
  8018c7:	c1 e0 02             	shl    $0x2,%eax
  8018ca:	05 40 10 81 00       	add    $0x811040,%eax
  8018cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018d5:	e9 2d 01 00 00       	jmp    801a07 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8018da:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018de:	0f 84 ce 00 00 00    	je     8019b2 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8018e4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8018eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ee:	89 d0                	mov    %edx,%eax
  8018f0:	01 c0                	add    %eax,%eax
  8018f2:	01 d0                	add    %edx,%eax
  8018f4:	c1 e0 02             	shl    $0x2,%eax
  8018f7:	05 40 10 81 00       	add    $0x811040,%eax
  8018fc:	8b 10                	mov    (%eax),%edx
  8018fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801901:	01 d0                	add    %edx,%eax
  801903:	48                   	dec    %eax
  801904:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801907:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80190a:	ba 00 00 00 00       	mov    $0x0,%edx
  80190f:	f7 75 c4             	divl   -0x3c(%ebp)
  801912:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801915:	29 d0                	sub    %edx,%eax
  801917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80191a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191d:	89 d0                	mov    %edx,%eax
  80191f:	01 c0                	add    %eax,%eax
  801921:	01 d0                	add    %edx,%eax
  801923:	c1 e0 02             	shl    $0x2,%eax
  801926:	05 44 10 81 00       	add    $0x811044,%eax
  80192b:	8b 00                	mov    (%eax),%eax
  80192d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801930:	75 47                	jne    801979 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801932:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801935:	89 d0                	mov    %edx,%eax
  801937:	01 c0                	add    %eax,%eax
  801939:	01 d0                	add    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	05 48 10 81 00       	add    $0x811048,%eax
  801943:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801949:	89 d0                	mov    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d0                	add    %edx,%eax
  80194f:	c1 e0 02             	shl    $0x2,%eax
  801952:	05 44 10 81 00       	add    $0x811044,%eax
  801957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80195d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801960:	89 d0                	mov    %edx,%eax
  801962:	01 c0                	add    %eax,%eax
  801964:	01 d0                	add    %edx,%eax
  801966:	c1 e0 02             	shl    $0x2,%eax
  801969:	05 40 10 81 00       	add    $0x811040,%eax
  80196e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801974:	e9 8e 00 00 00       	jmp    801a07 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801979:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80197c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80197f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801982:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801985:	89 d0                	mov    %edx,%eax
  801987:	01 c0                	add    %eax,%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c1 e0 02             	shl    $0x2,%eax
  80198e:	05 40 10 81 00       	add    $0x811040,%eax
  801993:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801998:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80199b:	89 c2                	mov    %eax,%edx
  80199d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a0:	89 c8                	mov    %ecx,%eax
  8019a2:	01 c0                	add    %eax,%eax
  8019a4:	01 c8                	add    %ecx,%eax
  8019a6:	c1 e0 02             	shl    $0x2,%eax
  8019a9:	05 44 10 81 00       	add    $0x811044,%eax
  8019ae:	89 10                	mov    %edx,(%eax)
  8019b0:	eb 55                	jmp    801a07 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8019b2:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8019b9:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8019bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019c2:	01 d0                	add    %edx,%eax
  8019c4:	48                   	dec    %eax
  8019c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8019c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d0:	f7 75 d0             	divl   -0x30(%ebp)
  8019d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019d6:	29 d0                	sub    %edx,%eax
  8019d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8019db:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019e1:	01 d0                	add    %edx,%eax
  8019e3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019e8:	76 0a                	jbe    8019f4 <malloc+0x2c7>
            return NULL;
  8019ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ef:	e9 97 00 00 00       	jmp    801a8b <malloc+0x35e>
        va = start;
  8019f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8019fa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a00:	01 d0                	add    %edx,%eax
  801a02:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a0e:	eb 5e                	jmp    801a6e <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801a10:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a13:	89 d0                	mov    %edx,%eax
  801a15:	01 c0                	add    %eax,%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c1 e0 02             	shl    $0x2,%eax
  801a1c:	05 48 50 80 00       	add    $0x805048,%eax
  801a21:	8a 00                	mov    (%eax),%al
  801a23:	84 c0                	test   %al,%al
  801a25:	75 44                	jne    801a6b <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801a27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a2a:	89 d0                	mov    %edx,%eax
  801a2c:	01 c0                	add    %eax,%eax
  801a2e:	01 d0                	add    %edx,%eax
  801a30:	c1 e0 02             	shl    $0x2,%eax
  801a33:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a3c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a41:	89 d0                	mov    %edx,%eax
  801a43:	01 c0                	add    %eax,%eax
  801a45:	01 d0                	add    %edx,%eax
  801a47:	c1 e0 02             	shl    $0x2,%eax
  801a4a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a53:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a58:	89 d0                	mov    %edx,%eax
  801a5a:	01 c0                	add    %eax,%eax
  801a5c:	01 d0                	add    %edx,%eax
  801a5e:	c1 e0 02             	shl    $0x2,%eax
  801a61:	05 48 50 80 00       	add    $0x805048,%eax
  801a66:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a69:	eb 0c                	jmp    801a77 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a6b:	ff 45 e0             	incl   -0x20(%ebp)
  801a6e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a75:	7e 99                	jle    801a10 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a77:	83 ec 08             	sub    $0x8,%esp
  801a7a:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a80:	e8 a2 19 00 00       	call   803427 <sys_allocate_user_mem>
  801a85:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a97:	0f 84 fa 03 00 00    	je     801e97 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801aa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	79 1c                	jns    801ac6 <free+0x39>
  801aaa:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801ab1:	77 13                	ja     801ac6 <free+0x39>
    {
        free_block(virtual_address);
  801ab3:	83 ec 0c             	sub    $0xc,%esp
  801ab6:	ff 75 08             	pushl  0x8(%ebp)
  801ab9:	e8 09 21 00 00       	call   803bc7 <free_block>
  801abe:	83 c4 10             	add    $0x10,%esp
        return;
  801ac1:	e9 d2 03 00 00       	jmp    801e98 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801ac6:	a1 30 51 83 00       	mov    0x835130,%eax
  801acb:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801ace:	72 09                	jb     801ad9 <free+0x4c>
  801ad0:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801ad7:	76 17                	jbe    801af0 <free+0x63>
        panic("free: invalid address");
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	68 4d 4a 80 00       	push   $0x804a4d
  801ae1:	68 9b 00 00 00       	push   $0x9b
  801ae6:	68 04 4a 80 00       	push   $0x804a04
  801aeb:	e8 ad e9 ff ff       	call   80049d <_panic>

    uint32 size = 0;
  801af0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801af7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801afe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801b05:	eb 50                	jmp    801b57 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801b07:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b0a:	89 d0                	mov    %edx,%eax
  801b0c:	01 c0                	add    %eax,%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	c1 e0 02             	shl    $0x2,%eax
  801b13:	05 48 50 80 00       	add    $0x805048,%eax
  801b18:	8a 00                	mov    (%eax),%al
  801b1a:	84 c0                	test   %al,%al
  801b1c:	74 36                	je     801b54 <free+0xc7>
  801b1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b21:	89 d0                	mov    %edx,%eax
  801b23:	01 c0                	add    %eax,%eax
  801b25:	01 d0                	add    %edx,%eax
  801b27:	c1 e0 02             	shl    $0x2,%eax
  801b2a:	05 40 50 80 00       	add    $0x805040,%eax
  801b2f:	8b 00                	mov    (%eax),%eax
  801b31:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b34:	75 1e                	jne    801b54 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801b36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b39:	89 d0                	mov    %edx,%eax
  801b3b:	01 c0                	add    %eax,%eax
  801b3d:	01 d0                	add    %edx,%eax
  801b3f:	c1 e0 02             	shl    $0x2,%eax
  801b42:	05 44 50 80 00       	add    $0x805044,%eax
  801b47:	8b 00                	mov    (%eax),%eax
  801b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b52:	eb 0c                	jmp    801b60 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b54:	ff 45 ec             	incl   -0x14(%ebp)
  801b57:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b5e:	7e a7                	jle    801b07 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b60:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b64:	74 06                	je     801b6c <free+0xdf>
  801b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b6a:	75 17                	jne    801b83 <free+0xf6>
        panic("free: unknown block");
  801b6c:	83 ec 04             	sub    $0x4,%esp
  801b6f:	68 63 4a 80 00       	push   $0x804a63
  801b74:	68 a9 00 00 00       	push   $0xa9
  801b79:	68 04 4a 80 00       	push   $0x804a04
  801b7e:	e8 1a e9 ff ff       	call   80049d <_panic>

    uhp_allocs[idx].used = 0;
  801b83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b86:	89 d0                	mov    %edx,%eax
  801b88:	01 c0                	add    %eax,%eax
  801b8a:	01 d0                	add    %edx,%eax
  801b8c:	c1 e0 02             	shl    $0x2,%eax
  801b8f:	05 48 50 80 00       	add    $0x805048,%eax
  801b94:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b97:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b9e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801ba5:	eb 64                	jmp    801c0b <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801ba7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801baa:	89 d0                	mov    %edx,%eax
  801bac:	01 c0                	add    %eax,%eax
  801bae:	01 d0                	add    %edx,%eax
  801bb0:	c1 e0 02             	shl    $0x2,%eax
  801bb3:	05 48 10 81 00       	add    $0x811048,%eax
  801bb8:	8a 00                	mov    (%eax),%al
  801bba:	84 c0                	test   %al,%al
  801bbc:	75 4a                	jne    801c08 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801bbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bc1:	89 d0                	mov    %edx,%eax
  801bc3:	01 c0                	add    %eax,%eax
  801bc5:	01 d0                	add    %edx,%eax
  801bc7:	c1 e0 02             	shl    $0x2,%eax
  801bca:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801bd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bd3:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801bd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bd8:	89 d0                	mov    %edx,%eax
  801bda:	01 c0                	add    %eax,%eax
  801bdc:	01 d0                	add    %edx,%eax
  801bde:	c1 e0 02             	shl    $0x2,%eax
  801be1:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bea:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801bec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bef:	89 d0                	mov    %edx,%eax
  801bf1:	01 c0                	add    %eax,%eax
  801bf3:	01 d0                	add    %edx,%eax
  801bf5:	c1 e0 02             	shl    $0x2,%eax
  801bf8:	05 48 10 81 00       	add    $0x811048,%eax
  801bfd:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c03:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801c06:	eb 0c                	jmp    801c14 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c08:	ff 45 e4             	incl   -0x1c(%ebp)
  801c0b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801c12:	7e 93                	jle    801ba7 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801c14:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801c18:	0f 84 f1 01 00 00    	je     801e0f <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c25:	e9 d8 01 00 00       	jmp    801e02 <free+0x375>
        {
            if (i == fidx) continue;
  801c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c30:	0f 84 c8 01 00 00    	je     801dfe <free+0x371>
            if (uhp_frees[i].free)
  801c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c39:	89 d0                	mov    %edx,%eax
  801c3b:	01 c0                	add    %eax,%eax
  801c3d:	01 d0                	add    %edx,%eax
  801c3f:	c1 e0 02             	shl    $0x2,%eax
  801c42:	05 48 10 81 00       	add    $0x811048,%eax
  801c47:	8a 00                	mov    (%eax),%al
  801c49:	84 c0                	test   %al,%al
  801c4b:	0f 84 ae 01 00 00    	je     801dff <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c54:	89 d0                	mov    %edx,%eax
  801c56:	01 c0                	add    %eax,%eax
  801c58:	01 d0                	add    %edx,%eax
  801c5a:	c1 e0 02             	shl    $0x2,%eax
  801c5d:	05 40 10 81 00       	add    $0x811040,%eax
  801c62:	8b 08                	mov    (%eax),%ecx
  801c64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c67:	89 d0                	mov    %edx,%eax
  801c69:	01 c0                	add    %eax,%eax
  801c6b:	01 d0                	add    %edx,%eax
  801c6d:	c1 e0 02             	shl    $0x2,%eax
  801c70:	05 44 10 81 00       	add    $0x811044,%eax
  801c75:	8b 00                	mov    (%eax),%eax
  801c77:	01 c1                	add    %eax,%ecx
  801c79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c7c:	89 d0                	mov    %edx,%eax
  801c7e:	01 c0                	add    %eax,%eax
  801c80:	01 d0                	add    %edx,%eax
  801c82:	c1 e0 02             	shl    $0x2,%eax
  801c85:	05 40 10 81 00       	add    $0x811040,%eax
  801c8a:	8b 00                	mov    (%eax),%eax
  801c8c:	39 c1                	cmp    %eax,%ecx
  801c8e:	0f 85 a8 00 00 00    	jne    801d3c <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c97:	89 d0                	mov    %edx,%eax
  801c99:	01 c0                	add    %eax,%eax
  801c9b:	01 d0                	add    %edx,%eax
  801c9d:	c1 e0 02             	shl    $0x2,%eax
  801ca0:	05 40 10 81 00       	add    $0x811040,%eax
  801ca5:	8b 10                	mov    (%eax),%edx
  801ca7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801caa:	89 c8                	mov    %ecx,%eax
  801cac:	01 c0                	add    %eax,%eax
  801cae:	01 c8                	add    %ecx,%eax
  801cb0:	c1 e0 02             	shl    $0x2,%eax
  801cb3:	05 40 10 81 00       	add    $0x811040,%eax
  801cb8:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801cba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cbd:	89 d0                	mov    %edx,%eax
  801cbf:	01 c0                	add    %eax,%eax
  801cc1:	01 d0                	add    %edx,%eax
  801cc3:	c1 e0 02             	shl    $0x2,%eax
  801cc6:	05 44 10 81 00       	add    $0x811044,%eax
  801ccb:	8b 08                	mov    (%eax),%ecx
  801ccd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cd0:	89 d0                	mov    %edx,%eax
  801cd2:	01 c0                	add    %eax,%eax
  801cd4:	01 d0                	add    %edx,%eax
  801cd6:	c1 e0 02             	shl    $0x2,%eax
  801cd9:	05 44 10 81 00       	add    $0x811044,%eax
  801cde:	8b 00                	mov    (%eax),%eax
  801ce0:	01 c1                	add    %eax,%ecx
  801ce2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ce5:	89 d0                	mov    %edx,%eax
  801ce7:	01 c0                	add    %eax,%eax
  801ce9:	01 d0                	add    %edx,%eax
  801ceb:	c1 e0 02             	shl    $0x2,%eax
  801cee:	05 44 10 81 00       	add    $0x811044,%eax
  801cf3:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801cf5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf8:	89 d0                	mov    %edx,%eax
  801cfa:	01 c0                	add    %eax,%eax
  801cfc:	01 d0                	add    %edx,%eax
  801cfe:	c1 e0 02             	shl    $0x2,%eax
  801d01:	05 48 10 81 00       	add    $0x811048,%eax
  801d06:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801d09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d0c:	89 d0                	mov    %edx,%eax
  801d0e:	01 c0                	add    %eax,%eax
  801d10:	01 d0                	add    %edx,%eax
  801d12:	c1 e0 02             	shl    $0x2,%eax
  801d15:	05 40 10 81 00       	add    $0x811040,%eax
  801d1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	01 d0                	add    %edx,%eax
  801d29:	c1 e0 02             	shl    $0x2,%eax
  801d2c:	05 44 10 81 00       	add    $0x811044,%eax
  801d31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d37:	e9 c3 00 00 00       	jmp    801dff <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d3f:	89 d0                	mov    %edx,%eax
  801d41:	01 c0                	add    %eax,%eax
  801d43:	01 d0                	add    %edx,%eax
  801d45:	c1 e0 02             	shl    $0x2,%eax
  801d48:	05 40 10 81 00       	add    $0x811040,%eax
  801d4d:	8b 08                	mov    (%eax),%ecx
  801d4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d52:	89 d0                	mov    %edx,%eax
  801d54:	01 c0                	add    %eax,%eax
  801d56:	01 d0                	add    %edx,%eax
  801d58:	c1 e0 02             	shl    $0x2,%eax
  801d5b:	05 44 10 81 00       	add    $0x811044,%eax
  801d60:	8b 00                	mov    (%eax),%eax
  801d62:	01 c1                	add    %eax,%ecx
  801d64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d67:	89 d0                	mov    %edx,%eax
  801d69:	01 c0                	add    %eax,%eax
  801d6b:	01 d0                	add    %edx,%eax
  801d6d:	c1 e0 02             	shl    $0x2,%eax
  801d70:	05 40 10 81 00       	add    $0x811040,%eax
  801d75:	8b 00                	mov    (%eax),%eax
  801d77:	39 c1                	cmp    %eax,%ecx
  801d79:	0f 85 80 00 00 00    	jne    801dff <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d7f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d82:	89 d0                	mov    %edx,%eax
  801d84:	01 c0                	add    %eax,%eax
  801d86:	01 d0                	add    %edx,%eax
  801d88:	c1 e0 02             	shl    $0x2,%eax
  801d8b:	05 44 10 81 00       	add    $0x811044,%eax
  801d90:	8b 08                	mov    (%eax),%ecx
  801d92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d95:	89 d0                	mov    %edx,%eax
  801d97:	01 c0                	add    %eax,%eax
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	c1 e0 02             	shl    $0x2,%eax
  801d9e:	05 44 10 81 00       	add    $0x811044,%eax
  801da3:	8b 00                	mov    (%eax),%eax
  801da5:	01 c1                	add    %eax,%ecx
  801da7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801daa:	89 d0                	mov    %edx,%eax
  801dac:	01 c0                	add    %eax,%eax
  801dae:	01 d0                	add    %edx,%eax
  801db0:	c1 e0 02             	shl    $0x2,%eax
  801db3:	05 44 10 81 00       	add    $0x811044,%eax
  801db8:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801dba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dbd:	89 d0                	mov    %edx,%eax
  801dbf:	01 c0                	add    %eax,%eax
  801dc1:	01 d0                	add    %edx,%eax
  801dc3:	c1 e0 02             	shl    $0x2,%eax
  801dc6:	05 48 10 81 00       	add    $0x811048,%eax
  801dcb:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801dce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dd1:	89 d0                	mov    %edx,%eax
  801dd3:	01 c0                	add    %eax,%eax
  801dd5:	01 d0                	add    %edx,%eax
  801dd7:	c1 e0 02             	shl    $0x2,%eax
  801dda:	05 40 10 81 00       	add    $0x811040,%eax
  801ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801de5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801de8:	89 d0                	mov    %edx,%eax
  801dea:	01 c0                	add    %eax,%eax
  801dec:	01 d0                	add    %edx,%eax
  801dee:	c1 e0 02             	shl    $0x2,%eax
  801df1:	05 44 10 81 00       	add    $0x811044,%eax
  801df6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dfc:	eb 01                	jmp    801dff <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801dfe:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dff:	ff 45 e0             	incl   -0x20(%ebp)
  801e02:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801e09:	0f 8e 1b fe ff ff    	jle    801c2a <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801e0f:	a1 30 51 83 00       	mov    0x835130,%eax
  801e14:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e17:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e1e:	eb 53                	jmp    801e73 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801e20:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e23:	89 d0                	mov    %edx,%eax
  801e25:	01 c0                	add    %eax,%eax
  801e27:	01 d0                	add    %edx,%eax
  801e29:	c1 e0 02             	shl    $0x2,%eax
  801e2c:	05 48 50 80 00       	add    $0x805048,%eax
  801e31:	8a 00                	mov    (%eax),%al
  801e33:	84 c0                	test   %al,%al
  801e35:	74 39                	je     801e70 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801e37:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e3a:	89 d0                	mov    %edx,%eax
  801e3c:	01 c0                	add    %eax,%eax
  801e3e:	01 d0                	add    %edx,%eax
  801e40:	c1 e0 02             	shl    $0x2,%eax
  801e43:	05 40 50 80 00       	add    $0x805040,%eax
  801e48:	8b 08                	mov    (%eax),%ecx
  801e4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e4d:	89 d0                	mov    %edx,%eax
  801e4f:	01 c0                	add    %eax,%eax
  801e51:	01 d0                	add    %edx,%eax
  801e53:	c1 e0 02             	shl    $0x2,%eax
  801e56:	05 44 50 80 00       	add    $0x805044,%eax
  801e5b:	8b 00                	mov    (%eax),%eax
  801e5d:	01 c8                	add    %ecx,%eax
  801e5f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e65:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e68:	76 06                	jbe    801e70 <free+0x3e3>
  801e6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e70:	ff 45 d8             	incl   -0x28(%ebp)
  801e73:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e7a:	7e a4                	jle    801e20 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e7f:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e84:	83 ec 08             	sub    $0x8,%esp
  801e87:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8a:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e8d:	e8 79 15 00 00       	call   80340b <sys_free_user_mem>
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	eb 01                	jmp    801e98 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e97:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 68             	sub    $0x68,%esp
  801ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea3:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ea6:	e8 a5 f7 ff ff       	call   801650 <uheap_init>
	if (size == 0) return NULL ;
  801eab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eaf:	75 0a                	jne    801ebb <smalloc+0x21>
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	e9 37 03 00 00       	jmp    8021f2 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801ebb:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ec8:	01 d0                	add    %edx,%eax
  801eca:	48                   	dec    %eax
  801ecb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ece:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed6:	f7 75 dc             	divl   -0x24(%ebp)
  801ed9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801edc:	29 d0                	sub    %edx,%eax
  801ede:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801ee1:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ee8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801eef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ef6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801efd:	e9 85 00 00 00       	jmp    801f87 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801f02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f05:	89 d0                	mov    %edx,%eax
  801f07:	01 c0                	add    %eax,%eax
  801f09:	01 d0                	add    %edx,%eax
  801f0b:	c1 e0 02             	shl    $0x2,%eax
  801f0e:	05 48 10 81 00       	add    $0x811048,%eax
  801f13:	8a 00                	mov    (%eax),%al
  801f15:	84 c0                	test   %al,%al
  801f17:	74 20                	je     801f39 <smalloc+0x9f>
  801f19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f1c:	89 d0                	mov    %edx,%eax
  801f1e:	01 c0                	add    %eax,%eax
  801f20:	01 d0                	add    %edx,%eax
  801f22:	c1 e0 02             	shl    $0x2,%eax
  801f25:	05 44 10 81 00       	add    $0x811044,%eax
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f2f:	75 08                	jne    801f39 <smalloc+0x9f>
        {
            exactIdx = i;
  801f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f37:	eb 5b                	jmp    801f94 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f3c:	89 d0                	mov    %edx,%eax
  801f3e:	01 c0                	add    %eax,%eax
  801f40:	01 d0                	add    %edx,%eax
  801f42:	c1 e0 02             	shl    $0x2,%eax
  801f45:	05 48 10 81 00       	add    $0x811048,%eax
  801f4a:	8a 00                	mov    (%eax),%al
  801f4c:	84 c0                	test   %al,%al
  801f4e:	74 34                	je     801f84 <smalloc+0xea>
  801f50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f53:	89 d0                	mov    %edx,%eax
  801f55:	01 c0                	add    %eax,%eax
  801f57:	01 d0                	add    %edx,%eax
  801f59:	c1 e0 02             	shl    $0x2,%eax
  801f5c:	05 44 10 81 00       	add    $0x811044,%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f66:	76 1c                	jbe    801f84 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f6b:	89 d0                	mov    %edx,%eax
  801f6d:	01 c0                	add    %eax,%eax
  801f6f:	01 d0                	add    %edx,%eax
  801f71:	c1 e0 02             	shl    $0x2,%eax
  801f74:	05 44 10 81 00       	add    $0x811044,%eax
  801f79:	8b 00                	mov    (%eax),%eax
  801f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f81:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f84:	ff 45 e8             	incl   -0x18(%ebp)
  801f87:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f8e:	0f 8e 6e ff ff ff    	jle    801f02 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f9b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f9f:	74 7d                	je     80201e <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801fa1:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801fa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fab:	89 d0                	mov    %edx,%eax
  801fad:	01 c0                	add    %eax,%eax
  801faf:	01 d0                	add    %edx,%eax
  801fb1:	c1 e0 02             	shl    $0x2,%eax
  801fb4:	05 40 10 81 00       	add    $0x811040,%eax
  801fb9:	8b 10                	mov    (%eax),%edx
  801fbb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	48                   	dec    %eax
  801fc1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801fc4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fcc:	f7 75 bc             	divl   -0x44(%ebp)
  801fcf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fd2:	29 d0                	sub    %edx,%eax
  801fd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fda:	89 d0                	mov    %edx,%eax
  801fdc:	01 c0                	add    %eax,%eax
  801fde:	01 d0                	add    %edx,%eax
  801fe0:	c1 e0 02             	shl    $0x2,%eax
  801fe3:	05 48 10 81 00       	add    $0x811048,%eax
  801fe8:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801feb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fee:	89 d0                	mov    %edx,%eax
  801ff0:	01 c0                	add    %eax,%eax
  801ff2:	01 d0                	add    %edx,%eax
  801ff4:	c1 e0 02             	shl    $0x2,%eax
  801ff7:	05 44 10 81 00       	add    $0x811044,%eax
  801ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802002:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802005:	89 d0                	mov    %edx,%eax
  802007:	01 c0                	add    %eax,%eax
  802009:	01 d0                	add    %edx,%eax
  80200b:	c1 e0 02             	shl    $0x2,%eax
  80200e:	05 40 10 81 00       	add    $0x811040,%eax
  802013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802019:	e9 2d 01 00 00       	jmp    80214b <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  80201e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802022:	0f 84 ce 00 00 00    	je     8020f6 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802028:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80202f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802032:	89 d0                	mov    %edx,%eax
  802034:	01 c0                	add    %eax,%eax
  802036:	01 d0                	add    %edx,%eax
  802038:	c1 e0 02             	shl    $0x2,%eax
  80203b:	05 40 10 81 00       	add    $0x811040,%eax
  802040:	8b 10                	mov    (%eax),%edx
  802042:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802045:	01 d0                	add    %edx,%eax
  802047:	48                   	dec    %eax
  802048:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80204b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80204e:	ba 00 00 00 00       	mov    $0x0,%edx
  802053:	f7 75 c4             	divl   -0x3c(%ebp)
  802056:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802059:	29 d0                	sub    %edx,%eax
  80205b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80205e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802061:	89 d0                	mov    %edx,%eax
  802063:	01 c0                	add    %eax,%eax
  802065:	01 d0                	add    %edx,%eax
  802067:	c1 e0 02             	shl    $0x2,%eax
  80206a:	05 44 10 81 00       	add    $0x811044,%eax
  80206f:	8b 00                	mov    (%eax),%eax
  802071:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802074:	75 47                	jne    8020bd <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802079:	89 d0                	mov    %edx,%eax
  80207b:	01 c0                	add    %eax,%eax
  80207d:	01 d0                	add    %edx,%eax
  80207f:	c1 e0 02             	shl    $0x2,%eax
  802082:	05 48 10 81 00       	add    $0x811048,%eax
  802087:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80208a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80208d:	89 d0                	mov    %edx,%eax
  80208f:	01 c0                	add    %eax,%eax
  802091:	01 d0                	add    %edx,%eax
  802093:	c1 e0 02             	shl    $0x2,%eax
  802096:	05 44 10 81 00       	add    $0x811044,%eax
  80209b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8020a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a4:	89 d0                	mov    %edx,%eax
  8020a6:	01 c0                	add    %eax,%eax
  8020a8:	01 d0                	add    %edx,%eax
  8020aa:	c1 e0 02             	shl    $0x2,%eax
  8020ad:	05 40 10 81 00       	add    $0x811040,%eax
  8020b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020b8:	e9 8e 00 00 00       	jmp    80214b <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8020bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020c3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	01 c0                	add    %eax,%eax
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	c1 e0 02             	shl    $0x2,%eax
  8020d2:	05 40 10 81 00       	add    $0x811040,%eax
  8020d7:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020dc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020df:	89 c2                	mov    %eax,%edx
  8020e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020e4:	89 c8                	mov    %ecx,%eax
  8020e6:	01 c0                	add    %eax,%eax
  8020e8:	01 c8                	add    %ecx,%eax
  8020ea:	c1 e0 02             	shl    $0x2,%eax
  8020ed:	05 44 10 81 00       	add    $0x811044,%eax
  8020f2:	89 10                	mov    %edx,(%eax)
  8020f4:	eb 55                	jmp    80214b <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020f6:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020fd:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802103:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802106:	01 d0                	add    %edx,%eax
  802108:	48                   	dec    %eax
  802109:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80210c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80210f:	ba 00 00 00 00       	mov    $0x0,%edx
  802114:	f7 75 d0             	divl   -0x30(%ebp)
  802117:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80211a:	29 d0                	sub    %edx,%eax
  80211c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80211f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802122:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802125:	01 d0                	add    %edx,%eax
  802127:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80212c:	76 0a                	jbe    802138 <smalloc+0x29e>
            return NULL;
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
  802133:	e9 ba 00 00 00       	jmp    8021f2 <smalloc+0x358>
        va = start;
  802138:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80213b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80213e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802141:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802144:	01 d0                	add    %edx,%eax
  802146:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80214b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802152:	eb 5e                	jmp    8021b2 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802154:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802157:	89 d0                	mov    %edx,%eax
  802159:	01 c0                	add    %eax,%eax
  80215b:	01 d0                	add    %edx,%eax
  80215d:	c1 e0 02             	shl    $0x2,%eax
  802160:	05 48 50 80 00       	add    $0x805048,%eax
  802165:	8a 00                	mov    (%eax),%al
  802167:	84 c0                	test   %al,%al
  802169:	75 44                	jne    8021af <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80216b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80216e:	89 d0                	mov    %edx,%eax
  802170:	01 c0                	add    %eax,%eax
  802172:	01 d0                	add    %edx,%eax
  802174:	c1 e0 02             	shl    $0x2,%eax
  802177:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80217d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802180:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802182:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802185:	89 d0                	mov    %edx,%eax
  802187:	01 c0                	add    %eax,%eax
  802189:	01 d0                	add    %edx,%eax
  80218b:	c1 e0 02             	shl    $0x2,%eax
  80218e:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802194:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802197:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802199:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80219c:	89 d0                	mov    %edx,%eax
  80219e:	01 c0                	add    %eax,%eax
  8021a0:	01 d0                	add    %edx,%eax
  8021a2:	c1 e0 02             	shl    $0x2,%eax
  8021a5:	05 48 50 80 00       	add    $0x805048,%eax
  8021aa:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8021ad:	eb 0c                	jmp    8021bb <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8021af:	ff 45 e0             	incl   -0x20(%ebp)
  8021b2:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8021b9:	7e 99                	jle    802154 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8021bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021be:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8021c2:	52                   	push   %edx
  8021c3:	50                   	push   %eax
  8021c4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021c7:	ff 75 08             	pushl  0x8(%ebp)
  8021ca:	e8 de 0e 00 00       	call   8030ad <sys_create_shared_object>
  8021cf:	83 c4 10             	add    $0x10,%esp
  8021d2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8021d5:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8021d9:	75 07                	jne    8021e2 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8021db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021e0:	eb 10                	jmp    8021f2 <smalloc+0x358>
    if (r < 0)
  8021e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8021e6:	79 07                	jns    8021ef <smalloc+0x355>
        return NULL;
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ed:	eb 03                	jmp    8021f2 <smalloc+0x358>
    return (void*)va;
  8021ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021fa:	e8 51 f4 ff ff       	call   801650 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021ff:	83 ec 08             	sub    $0x8,%esp
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	e8 ca 0e 00 00       	call   8030d7 <sys_size_of_shared_object>
  80220d:	83 c4 10             	add    $0x10,%esp
  802210:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802213:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802217:	7f 0a                	jg     802223 <sget+0x2f>
        return NULL;
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
  80221e:	e9 28 03 00 00       	jmp    80254b <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802223:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80222a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80222d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802230:	01 d0                	add    %edx,%eax
  802232:	48                   	dec    %eax
  802233:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802236:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802239:	ba 00 00 00 00       	mov    $0x0,%edx
  80223e:	f7 75 d8             	divl   -0x28(%ebp)
  802241:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802244:	29 d0                	sub    %edx,%eax
  802246:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802249:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802250:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802257:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80225e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802265:	e9 85 00 00 00       	jmp    8022ef <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80226a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80226d:	89 d0                	mov    %edx,%eax
  80226f:	01 c0                	add    %eax,%eax
  802271:	01 d0                	add    %edx,%eax
  802273:	c1 e0 02             	shl    $0x2,%eax
  802276:	05 48 10 81 00       	add    $0x811048,%eax
  80227b:	8a 00                	mov    (%eax),%al
  80227d:	84 c0                	test   %al,%al
  80227f:	74 20                	je     8022a1 <sget+0xad>
  802281:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802284:	89 d0                	mov    %edx,%eax
  802286:	01 c0                	add    %eax,%eax
  802288:	01 d0                	add    %edx,%eax
  80228a:	c1 e0 02             	shl    $0x2,%eax
  80228d:	05 44 10 81 00       	add    $0x811044,%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802297:	75 08                	jne    8022a1 <sget+0xad>
        {
            exactIdx = i;
  802299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80229c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80229f:	eb 5b                	jmp    8022fc <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8022a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a4:	89 d0                	mov    %edx,%eax
  8022a6:	01 c0                	add    %eax,%eax
  8022a8:	01 d0                	add    %edx,%eax
  8022aa:	c1 e0 02             	shl    $0x2,%eax
  8022ad:	05 48 10 81 00       	add    $0x811048,%eax
  8022b2:	8a 00                	mov    (%eax),%al
  8022b4:	84 c0                	test   %al,%al
  8022b6:	74 34                	je     8022ec <sget+0xf8>
  8022b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022bb:	89 d0                	mov    %edx,%eax
  8022bd:	01 c0                	add    %eax,%eax
  8022bf:	01 d0                	add    %edx,%eax
  8022c1:	c1 e0 02             	shl    $0x2,%eax
  8022c4:	05 44 10 81 00       	add    $0x811044,%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022ce:	76 1c                	jbe    8022ec <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8022d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022d3:	89 d0                	mov    %edx,%eax
  8022d5:	01 c0                	add    %eax,%eax
  8022d7:	01 d0                	add    %edx,%eax
  8022d9:	c1 e0 02             	shl    $0x2,%eax
  8022dc:	05 44 10 81 00       	add    $0x811044,%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8022e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022ec:	ff 45 e8             	incl   -0x18(%ebp)
  8022ef:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8022f6:	0f 8e 6e ff ff ff    	jle    80226a <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8022fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802303:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802307:	74 7d                	je     802386 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802309:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802313:	89 d0                	mov    %edx,%eax
  802315:	01 c0                	add    %eax,%eax
  802317:	01 d0                	add    %edx,%eax
  802319:	c1 e0 02             	shl    $0x2,%eax
  80231c:	05 40 10 81 00       	add    $0x811040,%eax
  802321:	8b 10                	mov    (%eax),%edx
  802323:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802326:	01 d0                	add    %edx,%eax
  802328:	48                   	dec    %eax
  802329:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80232c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80232f:	ba 00 00 00 00       	mov    $0x0,%edx
  802334:	f7 75 b8             	divl   -0x48(%ebp)
  802337:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80233a:	29 d0                	sub    %edx,%eax
  80233c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80233f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802342:	89 d0                	mov    %edx,%eax
  802344:	01 c0                	add    %eax,%eax
  802346:	01 d0                	add    %edx,%eax
  802348:	c1 e0 02             	shl    $0x2,%eax
  80234b:	05 48 10 81 00       	add    $0x811048,%eax
  802350:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802356:	89 d0                	mov    %edx,%eax
  802358:	01 c0                	add    %eax,%eax
  80235a:	01 d0                	add    %edx,%eax
  80235c:	c1 e0 02             	shl    $0x2,%eax
  80235f:	05 44 10 81 00       	add    $0x811044,%eax
  802364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80236a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236d:	89 d0                	mov    %edx,%eax
  80236f:	01 c0                	add    %eax,%eax
  802371:	01 d0                	add    %edx,%eax
  802373:	c1 e0 02             	shl    $0x2,%eax
  802376:	05 40 10 81 00       	add    $0x811040,%eax
  80237b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802381:	e9 2d 01 00 00       	jmp    8024b3 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802386:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80238a:	0f 84 ce 00 00 00    	je     80245e <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802390:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802397:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	01 c0                	add    %eax,%eax
  80239e:	01 d0                	add    %edx,%eax
  8023a0:	c1 e0 02             	shl    $0x2,%eax
  8023a3:	05 40 10 81 00       	add    $0x811040,%eax
  8023a8:	8b 10                	mov    (%eax),%edx
  8023aa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023ad:	01 d0                	add    %edx,%eax
  8023af:	48                   	dec    %eax
  8023b0:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8023b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023bb:	f7 75 c0             	divl   -0x40(%ebp)
  8023be:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023c1:	29 d0                	sub    %edx,%eax
  8023c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8023c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c9:	89 d0                	mov    %edx,%eax
  8023cb:	01 c0                	add    %eax,%eax
  8023cd:	01 d0                	add    %edx,%eax
  8023cf:	c1 e0 02             	shl    $0x2,%eax
  8023d2:	05 44 10 81 00       	add    $0x811044,%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023dc:	75 47                	jne    802425 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8023de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e1:	89 d0                	mov    %edx,%eax
  8023e3:	01 c0                	add    %eax,%eax
  8023e5:	01 d0                	add    %edx,%eax
  8023e7:	c1 e0 02             	shl    $0x2,%eax
  8023ea:	05 48 10 81 00       	add    $0x811048,%eax
  8023ef:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8023f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f5:	89 d0                	mov    %edx,%eax
  8023f7:	01 c0                	add    %eax,%eax
  8023f9:	01 d0                	add    %edx,%eax
  8023fb:	c1 e0 02             	shl    $0x2,%eax
  8023fe:	05 44 10 81 00       	add    $0x811044,%eax
  802403:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802409:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80240c:	89 d0                	mov    %edx,%eax
  80240e:	01 c0                	add    %eax,%eax
  802410:	01 d0                	add    %edx,%eax
  802412:	c1 e0 02             	shl    $0x2,%eax
  802415:	05 40 10 81 00       	add    $0x811040,%eax
  80241a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802420:	e9 8e 00 00 00       	jmp    8024b3 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802425:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802428:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80242b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80242e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802431:	89 d0                	mov    %edx,%eax
  802433:	01 c0                	add    %eax,%eax
  802435:	01 d0                	add    %edx,%eax
  802437:	c1 e0 02             	shl    $0x2,%eax
  80243a:	05 40 10 81 00       	add    $0x811040,%eax
  80243f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802441:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802444:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802447:	89 c2                	mov    %eax,%edx
  802449:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80244c:	89 c8                	mov    %ecx,%eax
  80244e:	01 c0                	add    %eax,%eax
  802450:	01 c8                	add    %ecx,%eax
  802452:	c1 e0 02             	shl    $0x2,%eax
  802455:	05 44 10 81 00       	add    $0x811044,%eax
  80245a:	89 10                	mov    %edx,(%eax)
  80245c:	eb 55                	jmp    8024b3 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80245e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802465:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80246b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80246e:	01 d0                	add    %edx,%eax
  802470:	48                   	dec    %eax
  802471:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802474:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802477:	ba 00 00 00 00       	mov    $0x0,%edx
  80247c:	f7 75 cc             	divl   -0x34(%ebp)
  80247f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802482:	29 d0                	sub    %edx,%eax
  802484:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802487:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80248a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80248d:	01 d0                	add    %edx,%eax
  80248f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802494:	76 0a                	jbe    8024a0 <sget+0x2ac>
            return NULL;
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
  80249b:	e9 ab 00 00 00       	jmp    80254b <sget+0x357>
        va = start;
  8024a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8024a6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8024a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024ac:	01 d0                	add    %edx,%eax
  8024ae:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024b3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8024ba:	eb 5e                	jmp    80251a <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8024bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024bf:	89 d0                	mov    %edx,%eax
  8024c1:	01 c0                	add    %eax,%eax
  8024c3:	01 d0                	add    %edx,%eax
  8024c5:	c1 e0 02             	shl    $0x2,%eax
  8024c8:	05 48 50 80 00       	add    $0x805048,%eax
  8024cd:	8a 00                	mov    (%eax),%al
  8024cf:	84 c0                	test   %al,%al
  8024d1:	75 44                	jne    802517 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8024d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024d6:	89 d0                	mov    %edx,%eax
  8024d8:	01 c0                	add    %eax,%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	c1 e0 02             	shl    $0x2,%eax
  8024df:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8024e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8024ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024ed:	89 d0                	mov    %edx,%eax
  8024ef:	01 c0                	add    %eax,%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c1 e0 02             	shl    $0x2,%eax
  8024f6:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024ff:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802501:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802504:	89 d0                	mov    %edx,%eax
  802506:	01 c0                	add    %eax,%eax
  802508:	01 d0                	add    %edx,%eax
  80250a:	c1 e0 02             	shl    $0x2,%eax
  80250d:	05 48 50 80 00       	add    $0x805048,%eax
  802512:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802515:	eb 0c                	jmp    802523 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802517:	ff 45 e0             	incl   -0x20(%ebp)
  80251a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802521:	7e 99                	jle    8024bc <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	50                   	push   %eax
  80252a:	ff 75 0c             	pushl  0xc(%ebp)
  80252d:	ff 75 08             	pushl  0x8(%ebp)
  802530:	e8 bf 0b 00 00       	call   8030f4 <sys_get_shared_object>
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  80253b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80253f:	79 07                	jns    802548 <sget+0x354>
        return NULL;
  802541:	b8 00 00 00 00       	mov    $0x0,%eax
  802546:	eb 03                	jmp    80254b <sget+0x357>
    return (void*)va;
  802548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
  802550:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802553:	e8 f8 f0 ff ff       	call   801650 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802558:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80255c:	75 13                	jne    802571 <realloc+0x24>
		return malloc(new_size);
  80255e:	83 ec 0c             	sub    $0xc,%esp
  802561:	ff 75 0c             	pushl  0xc(%ebp)
  802564:	e8 c4 f1 ff ff       	call   80172d <malloc>
  802569:	83 c4 10             	add    $0x10,%esp
  80256c:	e9 f4 05 00 00       	jmp    802b65 <realloc+0x618>
	if (new_size == 0)
  802571:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802575:	75 18                	jne    80258f <realloc+0x42>
	{
		free(virtual_address);
  802577:	83 ec 0c             	sub    $0xc,%esp
  80257a:	ff 75 08             	pushl  0x8(%ebp)
  80257d:	e8 0b f5 ff ff       	call   801a8d <free>
  802582:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
  80258a:	e9 d6 05 00 00       	jmp    802b65 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802595:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	79 74                	jns    802610 <realloc+0xc3>
  80259c:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8025a3:	77 6b                	ja     802610 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	ff 75 0c             	pushl  0xc(%ebp)
  8025ab:	e8 7d f1 ff ff       	call   80172d <malloc>
  8025b0:	83 c4 10             	add    $0x10,%esp
  8025b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8025b6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8025ba:	75 0a                	jne    8025c6 <realloc+0x79>
			return NULL;
  8025bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c1:	e9 9f 05 00 00       	jmp    802b65 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8025c6:	83 ec 0c             	sub    $0xc,%esp
  8025c9:	ff 75 08             	pushl  0x8(%ebp)
  8025cc:	e8 e0 11 00 00       	call   8037b1 <get_block_size>
  8025d1:	83 c4 10             	add    $0x10,%esp
  8025d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8025d7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025dd:	39 d0                	cmp    %edx,%eax
  8025df:	76 02                	jbe    8025e3 <realloc+0x96>
  8025e1:	89 d0                	mov    %edx,%eax
  8025e3:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	ff 75 c0             	pushl  -0x40(%ebp)
  8025ec:	ff 75 08             	pushl  0x8(%ebp)
  8025ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8025f2:	e8 56 eb ff ff       	call   80114d <memmove>
  8025f7:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	ff 75 08             	pushl  0x8(%ebp)
  802600:	e8 88 f4 ff ff       	call   801a8d <free>
  802605:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802608:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80260b:	e9 55 05 00 00       	jmp    802b65 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802610:	a1 30 51 83 00       	mov    0x835130,%eax
  802615:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802618:	72 09                	jb     802623 <realloc+0xd6>
  80261a:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802621:	76 0a                	jbe    80262d <realloc+0xe0>
		return NULL;
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
  802628:	e9 38 05 00 00       	jmp    802b65 <realloc+0x618>
	uint32 oldsz = 0;
  80262d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802634:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80263b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802642:	eb 50                	jmp    802694 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802644:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802647:	89 d0                	mov    %edx,%eax
  802649:	01 c0                	add    %eax,%eax
  80264b:	01 d0                	add    %edx,%eax
  80264d:	c1 e0 02             	shl    $0x2,%eax
  802650:	05 48 50 80 00       	add    $0x805048,%eax
  802655:	8a 00                	mov    (%eax),%al
  802657:	84 c0                	test   %al,%al
  802659:	74 36                	je     802691 <realloc+0x144>
  80265b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80265e:	89 d0                	mov    %edx,%eax
  802660:	01 c0                	add    %eax,%eax
  802662:	01 d0                	add    %edx,%eax
  802664:	c1 e0 02             	shl    $0x2,%eax
  802667:	05 40 50 80 00       	add    $0x805040,%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802671:	75 1e                	jne    802691 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802673:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802676:	89 d0                	mov    %edx,%eax
  802678:	01 c0                	add    %eax,%eax
  80267a:	01 d0                	add    %edx,%eax
  80267c:	c1 e0 02             	shl    $0x2,%eax
  80267f:	05 44 50 80 00       	add    $0x805044,%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80268f:	eb 0c                	jmp    80269d <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802691:	ff 45 ec             	incl   -0x14(%ebp)
  802694:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80269b:	7e a7                	jle    802644 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  80269d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026a1:	75 0a                	jne    8026ad <realloc+0x160>
		return NULL;
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	e9 b8 04 00 00       	jmp    802b65 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8026ad:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8026b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026ba:	01 d0                	add    %edx,%eax
  8026bc:	48                   	dec    %eax
  8026bd:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8026c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c8:	f7 75 bc             	divl   -0x44(%ebp)
  8026cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026ce:	29 d0                	sub    %edx,%eax
  8026d0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8026d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026d9:	75 08                	jne    8026e3 <realloc+0x196>
		return virtual_address;
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	e9 82 04 00 00       	jmp    802b65 <realloc+0x618>
	if (req < oldsz)
  8026e3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026e9:	0f 83 cd 02 00 00    	jae    8029bc <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8026f5:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8026f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026fe:	01 d0                	add    %edx,%eax
  802700:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802703:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802706:	89 d0                	mov    %edx,%eax
  802708:	01 c0                	add    %eax,%eax
  80270a:	01 d0                	add    %edx,%eax
  80270c:	c1 e0 02             	shl    $0x2,%eax
  80270f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802715:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802718:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  80271a:	83 ec 08             	sub    $0x8,%esp
  80271d:	ff 75 b0             	pushl  -0x50(%ebp)
  802720:	ff 75 ac             	pushl  -0x54(%ebp)
  802723:	e8 e3 0c 00 00       	call   80340b <sys_free_user_mem>
  802728:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  80272b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802732:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802739:	eb 64                	jmp    80279f <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  80273b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273e:	89 d0                	mov    %edx,%eax
  802740:	01 c0                	add    %eax,%eax
  802742:	01 d0                	add    %edx,%eax
  802744:	c1 e0 02             	shl    $0x2,%eax
  802747:	05 48 10 81 00       	add    $0x811048,%eax
  80274c:	8a 00                	mov    (%eax),%al
  80274e:	84 c0                	test   %al,%al
  802750:	75 4a                	jne    80279c <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802752:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802755:	89 d0                	mov    %edx,%eax
  802757:	01 c0                	add    %eax,%eax
  802759:	01 d0                	add    %edx,%eax
  80275b:	c1 e0 02             	shl    $0x2,%eax
  80275e:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802764:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802767:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802769:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80276c:	89 d0                	mov    %edx,%eax
  80276e:	01 c0                	add    %eax,%eax
  802770:	01 d0                	add    %edx,%eax
  802772:	c1 e0 02             	shl    $0x2,%eax
  802775:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80277b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80277e:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802783:	89 d0                	mov    %edx,%eax
  802785:	01 c0                	add    %eax,%eax
  802787:	01 d0                	add    %edx,%eax
  802789:	c1 e0 02             	shl    $0x2,%eax
  80278c:	05 48 10 81 00       	add    $0x811048,%eax
  802791:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802797:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80279a:	eb 0c                	jmp    8027a8 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80279c:	ff 45 e4             	incl   -0x1c(%ebp)
  80279f:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8027a6:	7e 93                	jle    80273b <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8027a8:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8027ac:	0f 84 8d 01 00 00    	je     80293f <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8027b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027b9:	e9 74 01 00 00       	jmp    802932 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8027be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027c4:	0f 84 64 01 00 00    	je     80292e <realloc+0x3e1>
				if (uhp_frees[k].free)
  8027ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027cd:	89 d0                	mov    %edx,%eax
  8027cf:	01 c0                	add    %eax,%eax
  8027d1:	01 d0                	add    %edx,%eax
  8027d3:	c1 e0 02             	shl    $0x2,%eax
  8027d6:	05 48 10 81 00       	add    $0x811048,%eax
  8027db:	8a 00                	mov    (%eax),%al
  8027dd:	84 c0                	test   %al,%al
  8027df:	0f 84 4a 01 00 00    	je     80292f <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8027e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e8:	89 d0                	mov    %edx,%eax
  8027ea:	01 c0                	add    %eax,%eax
  8027ec:	01 d0                	add    %edx,%eax
  8027ee:	c1 e0 02             	shl    $0x2,%eax
  8027f1:	05 40 10 81 00       	add    $0x811040,%eax
  8027f6:	8b 08                	mov    (%eax),%ecx
  8027f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027fb:	89 d0                	mov    %edx,%eax
  8027fd:	01 c0                	add    %eax,%eax
  8027ff:	01 d0                	add    %edx,%eax
  802801:	c1 e0 02             	shl    $0x2,%eax
  802804:	05 44 10 81 00       	add    $0x811044,%eax
  802809:	8b 00                	mov    (%eax),%eax
  80280b:	01 c1                	add    %eax,%ecx
  80280d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802810:	89 d0                	mov    %edx,%eax
  802812:	01 c0                	add    %eax,%eax
  802814:	01 d0                	add    %edx,%eax
  802816:	c1 e0 02             	shl    $0x2,%eax
  802819:	05 40 10 81 00       	add    $0x811040,%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	39 c1                	cmp    %eax,%ecx
  802822:	75 7a                	jne    80289e <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802824:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802827:	89 d0                	mov    %edx,%eax
  802829:	01 c0                	add    %eax,%eax
  80282b:	01 d0                	add    %edx,%eax
  80282d:	c1 e0 02             	shl    $0x2,%eax
  802830:	05 40 10 81 00       	add    $0x811040,%eax
  802835:	8b 10                	mov    (%eax),%edx
  802837:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80283a:	89 c8                	mov    %ecx,%eax
  80283c:	01 c0                	add    %eax,%eax
  80283e:	01 c8                	add    %ecx,%eax
  802840:	c1 e0 02             	shl    $0x2,%eax
  802843:	05 40 10 81 00       	add    $0x811040,%eax
  802848:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80284a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80284d:	89 d0                	mov    %edx,%eax
  80284f:	01 c0                	add    %eax,%eax
  802851:	01 d0                	add    %edx,%eax
  802853:	c1 e0 02             	shl    $0x2,%eax
  802856:	05 44 10 81 00       	add    $0x811044,%eax
  80285b:	8b 08                	mov    (%eax),%ecx
  80285d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802860:	89 d0                	mov    %edx,%eax
  802862:	01 c0                	add    %eax,%eax
  802864:	01 d0                	add    %edx,%eax
  802866:	c1 e0 02             	shl    $0x2,%eax
  802869:	05 44 10 81 00       	add    $0x811044,%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	01 c1                	add    %eax,%ecx
  802872:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802875:	89 d0                	mov    %edx,%eax
  802877:	01 c0                	add    %eax,%eax
  802879:	01 d0                	add    %edx,%eax
  80287b:	c1 e0 02             	shl    $0x2,%eax
  80287e:	05 44 10 81 00       	add    $0x811044,%eax
  802883:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802885:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802888:	89 d0                	mov    %edx,%eax
  80288a:	01 c0                	add    %eax,%eax
  80288c:	01 d0                	add    %edx,%eax
  80288e:	c1 e0 02             	shl    $0x2,%eax
  802891:	05 48 10 81 00       	add    $0x811048,%eax
  802896:	c6 00 00             	movb   $0x0,(%eax)
  802899:	e9 91 00 00 00       	jmp    80292f <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80289e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a1:	89 d0                	mov    %edx,%eax
  8028a3:	01 c0                	add    %eax,%eax
  8028a5:	01 d0                	add    %edx,%eax
  8028a7:	c1 e0 02             	shl    $0x2,%eax
  8028aa:	05 40 10 81 00       	add    $0x811040,%eax
  8028af:	8b 08                	mov    (%eax),%ecx
  8028b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028b4:	89 d0                	mov    %edx,%eax
  8028b6:	01 c0                	add    %eax,%eax
  8028b8:	01 d0                	add    %edx,%eax
  8028ba:	c1 e0 02             	shl    $0x2,%eax
  8028bd:	05 44 10 81 00       	add    $0x811044,%eax
  8028c2:	8b 00                	mov    (%eax),%eax
  8028c4:	01 c1                	add    %eax,%ecx
  8028c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028c9:	89 d0                	mov    %edx,%eax
  8028cb:	01 c0                	add    %eax,%eax
  8028cd:	01 d0                	add    %edx,%eax
  8028cf:	c1 e0 02             	shl    $0x2,%eax
  8028d2:	05 40 10 81 00       	add    $0x811040,%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	39 c1                	cmp    %eax,%ecx
  8028db:	75 52                	jne    80292f <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8028dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028e0:	89 d0                	mov    %edx,%eax
  8028e2:	01 c0                	add    %eax,%eax
  8028e4:	01 d0                	add    %edx,%eax
  8028e6:	c1 e0 02             	shl    $0x2,%eax
  8028e9:	05 44 10 81 00       	add    $0x811044,%eax
  8028ee:	8b 08                	mov    (%eax),%ecx
  8028f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028f3:	89 d0                	mov    %edx,%eax
  8028f5:	01 c0                	add    %eax,%eax
  8028f7:	01 d0                	add    %edx,%eax
  8028f9:	c1 e0 02             	shl    $0x2,%eax
  8028fc:	05 44 10 81 00       	add    $0x811044,%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	01 c1                	add    %eax,%ecx
  802905:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802908:	89 d0                	mov    %edx,%eax
  80290a:	01 c0                	add    %eax,%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	c1 e0 02             	shl    $0x2,%eax
  802911:	05 44 10 81 00       	add    $0x811044,%eax
  802916:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802918:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80291b:	89 d0                	mov    %edx,%eax
  80291d:	01 c0                	add    %eax,%eax
  80291f:	01 d0                	add    %edx,%eax
  802921:	c1 e0 02             	shl    $0x2,%eax
  802924:	05 48 10 81 00       	add    $0x811048,%eax
  802929:	c6 00 00             	movb   $0x0,(%eax)
  80292c:	eb 01                	jmp    80292f <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  80292e:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80292f:	ff 45 e0             	incl   -0x20(%ebp)
  802932:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802939:	0f 8e 7f fe ff ff    	jle    8027be <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  80293f:	a1 30 51 83 00       	mov    0x835130,%eax
  802944:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802947:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80294e:	eb 53                	jmp    8029a3 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802950:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802953:	89 d0                	mov    %edx,%eax
  802955:	01 c0                	add    %eax,%eax
  802957:	01 d0                	add    %edx,%eax
  802959:	c1 e0 02             	shl    $0x2,%eax
  80295c:	05 48 50 80 00       	add    $0x805048,%eax
  802961:	8a 00                	mov    (%eax),%al
  802963:	84 c0                	test   %al,%al
  802965:	74 39                	je     8029a0 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802967:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80296a:	89 d0                	mov    %edx,%eax
  80296c:	01 c0                	add    %eax,%eax
  80296e:	01 d0                	add    %edx,%eax
  802970:	c1 e0 02             	shl    $0x2,%eax
  802973:	05 40 50 80 00       	add    $0x805040,%eax
  802978:	8b 08                	mov    (%eax),%ecx
  80297a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80297d:	89 d0                	mov    %edx,%eax
  80297f:	01 c0                	add    %eax,%eax
  802981:	01 d0                	add    %edx,%eax
  802983:	c1 e0 02             	shl    $0x2,%eax
  802986:	05 44 50 80 00       	add    $0x805044,%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	01 c8                	add    %ecx,%eax
  80298f:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802992:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802995:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802998:	76 06                	jbe    8029a0 <realloc+0x453>
  80299a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80299d:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8029a0:	ff 45 d8             	incl   -0x28(%ebp)
  8029a3:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8029aa:	7e a4                	jle    802950 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8029ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029af:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	e9 a9 01 00 00       	jmp    802b65 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8029bc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	01 d0                	add    %edx,%eax
  8029c4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8029c7:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029ce:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8029d5:	eb 57                	jmp    802a2e <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8029d7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029da:	89 d0                	mov    %edx,%eax
  8029dc:	01 c0                	add    %eax,%eax
  8029de:	01 d0                	add    %edx,%eax
  8029e0:	c1 e0 02             	shl    $0x2,%eax
  8029e3:	05 48 10 81 00       	add    $0x811048,%eax
  8029e8:	8a 00                	mov    (%eax),%al
  8029ea:	84 c0                	test   %al,%al
  8029ec:	74 3d                	je     802a2b <realloc+0x4de>
  8029ee:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029f1:	89 d0                	mov    %edx,%eax
  8029f3:	01 c0                	add    %eax,%eax
  8029f5:	01 d0                	add    %edx,%eax
  8029f7:	c1 e0 02             	shl    $0x2,%eax
  8029fa:	05 40 10 81 00       	add    $0x811040,%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a04:	75 25                	jne    802a2b <realloc+0x4de>
  802a06:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a09:	89 d0                	mov    %edx,%eax
  802a0b:	01 c0                	add    %eax,%eax
  802a0d:	01 d0                	add    %edx,%eax
  802a0f:	c1 e0 02             	shl    $0x2,%eax
  802a12:	05 44 10 81 00       	add    $0x811044,%eax
  802a17:	8b 10                	mov    (%eax),%edx
  802a19:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a1c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a1f:	39 c2                	cmp    %eax,%edx
  802a21:	72 08                	jb     802a2b <realloc+0x4de>
		{
			adjIdx = j; break;
  802a23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a26:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a29:	eb 0c                	jmp    802a37 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a2b:	ff 45 d0             	incl   -0x30(%ebp)
  802a2e:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802a35:	7e a0                	jle    8029d7 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802a37:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802a3b:	0f 84 d6 00 00 00    	je     802b17 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a41:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a44:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a47:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a4a:	83 ec 08             	sub    $0x8,%esp
  802a4d:	ff 75 a0             	pushl  -0x60(%ebp)
  802a50:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a53:	e8 cf 09 00 00       	call   803427 <sys_allocate_user_mem>
  802a58:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5e:	89 d0                	mov    %edx,%eax
  802a60:	01 c0                	add    %eax,%eax
  802a62:	01 d0                	add    %edx,%eax
  802a64:	c1 e0 02             	shl    $0x2,%eax
  802a67:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a6d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a70:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a72:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a75:	89 d0                	mov    %edx,%eax
  802a77:	01 c0                	add    %eax,%eax
  802a79:	01 d0                	add    %edx,%eax
  802a7b:	c1 e0 02             	shl    $0x2,%eax
  802a7e:	05 40 10 81 00       	add    $0x811040,%eax
  802a83:	8b 10                	mov    (%eax),%edx
  802a85:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a88:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a8e:	89 d0                	mov    %edx,%eax
  802a90:	01 c0                	add    %eax,%eax
  802a92:	01 d0                	add    %edx,%eax
  802a94:	c1 e0 02             	shl    $0x2,%eax
  802a97:	05 40 10 81 00       	add    $0x811040,%eax
  802a9c:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a9e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802aa1:	89 d0                	mov    %edx,%eax
  802aa3:	01 c0                	add    %eax,%eax
  802aa5:	01 d0                	add    %edx,%eax
  802aa7:	c1 e0 02             	shl    $0x2,%eax
  802aaa:	05 44 10 81 00       	add    $0x811044,%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802ab4:	89 c2                	mov    %eax,%edx
  802ab6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802ab9:	89 c8                	mov    %ecx,%eax
  802abb:	01 c0                	add    %eax,%eax
  802abd:	01 c8                	add    %ecx,%eax
  802abf:	c1 e0 02             	shl    $0x2,%eax
  802ac2:	05 44 10 81 00       	add    $0x811044,%eax
  802ac7:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802ac9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802acc:	89 d0                	mov    %edx,%eax
  802ace:	01 c0                	add    %eax,%eax
  802ad0:	01 d0                	add    %edx,%eax
  802ad2:	c1 e0 02             	shl    $0x2,%eax
  802ad5:	05 44 10 81 00       	add    $0x811044,%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	75 14                	jne    802af4 <realloc+0x5a7>
  802ae0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ae3:	89 d0                	mov    %edx,%eax
  802ae5:	01 c0                	add    %eax,%eax
  802ae7:	01 d0                	add    %edx,%eax
  802ae9:	c1 e0 02             	shl    $0x2,%eax
  802aec:	05 48 10 81 00       	add    $0x811048,%eax
  802af1:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802af4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802afa:	01 c2                	add    %eax,%edx
  802afc:	a1 88 50 83 00       	mov    0x835088,%eax
  802b01:	39 c2                	cmp    %eax,%edx
  802b03:	76 0d                	jbe    802b12 <realloc+0x5c5>
  802b05:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b08:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b0b:	01 d0                	add    %edx,%eax
  802b0d:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	eb 4e                	jmp    802b65 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802b17:	83 ec 0c             	sub    $0xc,%esp
  802b1a:	ff 75 0c             	pushl  0xc(%ebp)
  802b1d:	e8 0b ec ff ff       	call   80172d <malloc>
  802b22:	83 c4 10             	add    $0x10,%esp
  802b25:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802b28:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802b2c:	75 07                	jne    802b35 <realloc+0x5e8>
		return NULL;
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b33:	eb 30                	jmp    802b65 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b38:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b3b:	39 d0                	cmp    %edx,%eax
  802b3d:	76 02                	jbe    802b41 <realloc+0x5f4>
  802b3f:	89 d0                	mov    %edx,%eax
  802b41:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	50                   	push   %eax
  802b48:	52                   	push   %edx
  802b49:	ff 75 cc             	pushl  -0x34(%ebp)
  802b4c:	e8 cf 06 00 00       	call   803220 <sys_move_user_mem>
  802b51:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b54:	83 ec 0c             	sub    $0xc,%esp
  802b57:	ff 75 08             	pushl  0x8(%ebp)
  802b5a:	e8 2e ef ff ff       	call   801a8d <free>
  802b5f:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b62:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b65:	c9                   	leave  
  802b66:	c3                   	ret    

00802b67 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b67:	55                   	push   %ebp
  802b68:	89 e5                	mov    %esp,%ebp
  802b6a:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b73:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b77:	0f 84 33 03 00 00    	je     802eb0 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b80:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b85:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b88:	83 ec 08             	sub    $0x8,%esp
  802b8b:	ff 75 08             	pushl  0x8(%ebp)
  802b8e:	ff 75 d8             	pushl  -0x28(%ebp)
  802b91:	e8 7d 05 00 00       	call   803113 <sys_delete_shared_object>
  802b96:	83 c4 10             	add    $0x10,%esp
  802b99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b9c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802ba0:	0f 88 0d 03 00 00    	js     802eb3 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802ba6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bad:	e9 ef 02 00 00       	jmp    802ea1 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb5:	89 d0                	mov    %edx,%eax
  802bb7:	01 c0                	add    %eax,%eax
  802bb9:	01 d0                	add    %edx,%eax
  802bbb:	c1 e0 02             	shl    $0x2,%eax
  802bbe:	05 48 50 80 00       	add    $0x805048,%eax
  802bc3:	8a 00                	mov    (%eax),%al
  802bc5:	84 c0                	test   %al,%al
  802bc7:	0f 84 d1 02 00 00    	je     802e9e <sfree+0x337>
  802bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd0:	89 d0                	mov    %edx,%eax
  802bd2:	01 c0                	add    %eax,%eax
  802bd4:	01 d0                	add    %edx,%eax
  802bd6:	c1 e0 02             	shl    $0x2,%eax
  802bd9:	05 40 50 80 00       	add    $0x805040,%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802be3:	0f 85 b5 02 00 00    	jne    802e9e <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bec:	89 d0                	mov    %edx,%eax
  802bee:	01 c0                	add    %eax,%eax
  802bf0:	01 d0                	add    %edx,%eax
  802bf2:	c1 e0 02             	shl    $0x2,%eax
  802bf5:	05 44 50 80 00       	add    $0x805044,%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802bff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c02:	89 d0                	mov    %edx,%eax
  802c04:	01 c0                	add    %eax,%eax
  802c06:	01 d0                	add    %edx,%eax
  802c08:	c1 e0 02             	shl    $0x2,%eax
  802c0b:	05 48 50 80 00       	add    $0x805048,%eax
  802c10:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802c13:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c1a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c21:	eb 64                	jmp    802c87 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802c23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c26:	89 d0                	mov    %edx,%eax
  802c28:	01 c0                	add    %eax,%eax
  802c2a:	01 d0                	add    %edx,%eax
  802c2c:	c1 e0 02             	shl    $0x2,%eax
  802c2f:	05 48 10 81 00       	add    $0x811048,%eax
  802c34:	8a 00                	mov    (%eax),%al
  802c36:	84 c0                	test   %al,%al
  802c38:	75 4a                	jne    802c84 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802c3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3d:	89 d0                	mov    %edx,%eax
  802c3f:	01 c0                	add    %eax,%eax
  802c41:	01 d0                	add    %edx,%eax
  802c43:	c1 e0 02             	shl    $0x2,%eax
  802c46:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c4f:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c54:	89 d0                	mov    %edx,%eax
  802c56:	01 c0                	add    %eax,%eax
  802c58:	01 d0                	add    %edx,%eax
  802c5a:	c1 e0 02             	shl    $0x2,%eax
  802c5d:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c66:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6b:	89 d0                	mov    %edx,%eax
  802c6d:	01 c0                	add    %eax,%eax
  802c6f:	01 d0                	add    %edx,%eax
  802c71:	c1 e0 02             	shl    $0x2,%eax
  802c74:	05 48 10 81 00       	add    $0x811048,%eax
  802c79:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c82:	eb 0c                	jmp    802c90 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c84:	ff 45 ec             	incl   -0x14(%ebp)
  802c87:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c8e:	7e 93                	jle    802c23 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c90:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c94:	0f 84 8d 01 00 00    	je     802e27 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c9a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802ca1:	e9 74 01 00 00       	jmp    802e1a <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cac:	0f 84 64 01 00 00    	je     802e16 <sfree+0x2af>
					if (uhp_frees[k].free)
  802cb2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cb5:	89 d0                	mov    %edx,%eax
  802cb7:	01 c0                	add    %eax,%eax
  802cb9:	01 d0                	add    %edx,%eax
  802cbb:	c1 e0 02             	shl    $0x2,%eax
  802cbe:	05 48 10 81 00       	add    $0x811048,%eax
  802cc3:	8a 00                	mov    (%eax),%al
  802cc5:	84 c0                	test   %al,%al
  802cc7:	0f 84 4a 01 00 00    	je     802e17 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802ccd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd0:	89 d0                	mov    %edx,%eax
  802cd2:	01 c0                	add    %eax,%eax
  802cd4:	01 d0                	add    %edx,%eax
  802cd6:	c1 e0 02             	shl    $0x2,%eax
  802cd9:	05 40 10 81 00       	add    $0x811040,%eax
  802cde:	8b 08                	mov    (%eax),%ecx
  802ce0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ce3:	89 d0                	mov    %edx,%eax
  802ce5:	01 c0                	add    %eax,%eax
  802ce7:	01 d0                	add    %edx,%eax
  802ce9:	c1 e0 02             	shl    $0x2,%eax
  802cec:	05 44 10 81 00       	add    $0x811044,%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	01 c1                	add    %eax,%ecx
  802cf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf8:	89 d0                	mov    %edx,%eax
  802cfa:	01 c0                	add    %eax,%eax
  802cfc:	01 d0                	add    %edx,%eax
  802cfe:	c1 e0 02             	shl    $0x2,%eax
  802d01:	05 40 10 81 00       	add    $0x811040,%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	39 c1                	cmp    %eax,%ecx
  802d0a:	75 7a                	jne    802d86 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802d0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d0f:	89 d0                	mov    %edx,%eax
  802d11:	01 c0                	add    %eax,%eax
  802d13:	01 d0                	add    %edx,%eax
  802d15:	c1 e0 02             	shl    $0x2,%eax
  802d18:	05 40 10 81 00       	add    $0x811040,%eax
  802d1d:	8b 10                	mov    (%eax),%edx
  802d1f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d22:	89 c8                	mov    %ecx,%eax
  802d24:	01 c0                	add    %eax,%eax
  802d26:	01 c8                	add    %ecx,%eax
  802d28:	c1 e0 02             	shl    $0x2,%eax
  802d2b:	05 40 10 81 00       	add    $0x811040,%eax
  802d30:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d35:	89 d0                	mov    %edx,%eax
  802d37:	01 c0                	add    %eax,%eax
  802d39:	01 d0                	add    %edx,%eax
  802d3b:	c1 e0 02             	shl    $0x2,%eax
  802d3e:	05 44 10 81 00       	add    $0x811044,%eax
  802d43:	8b 08                	mov    (%eax),%ecx
  802d45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d48:	89 d0                	mov    %edx,%eax
  802d4a:	01 c0                	add    %eax,%eax
  802d4c:	01 d0                	add    %edx,%eax
  802d4e:	c1 e0 02             	shl    $0x2,%eax
  802d51:	05 44 10 81 00       	add    $0x811044,%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	01 c1                	add    %eax,%ecx
  802d5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5d:	89 d0                	mov    %edx,%eax
  802d5f:	01 c0                	add    %eax,%eax
  802d61:	01 d0                	add    %edx,%eax
  802d63:	c1 e0 02             	shl    $0x2,%eax
  802d66:	05 44 10 81 00       	add    $0x811044,%eax
  802d6b:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d70:	89 d0                	mov    %edx,%eax
  802d72:	01 c0                	add    %eax,%eax
  802d74:	01 d0                	add    %edx,%eax
  802d76:	c1 e0 02             	shl    $0x2,%eax
  802d79:	05 48 10 81 00       	add    $0x811048,%eax
  802d7e:	c6 00 00             	movb   $0x0,(%eax)
  802d81:	e9 91 00 00 00       	jmp    802e17 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d89:	89 d0                	mov    %edx,%eax
  802d8b:	01 c0                	add    %eax,%eax
  802d8d:	01 d0                	add    %edx,%eax
  802d8f:	c1 e0 02             	shl    $0x2,%eax
  802d92:	05 40 10 81 00       	add    $0x811040,%eax
  802d97:	8b 08                	mov    (%eax),%ecx
  802d99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d9c:	89 d0                	mov    %edx,%eax
  802d9e:	01 c0                	add    %eax,%eax
  802da0:	01 d0                	add    %edx,%eax
  802da2:	c1 e0 02             	shl    $0x2,%eax
  802da5:	05 44 10 81 00       	add    $0x811044,%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	01 c1                	add    %eax,%ecx
  802dae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db1:	89 d0                	mov    %edx,%eax
  802db3:	01 c0                	add    %eax,%eax
  802db5:	01 d0                	add    %edx,%eax
  802db7:	c1 e0 02             	shl    $0x2,%eax
  802dba:	05 40 10 81 00       	add    $0x811040,%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	39 c1                	cmp    %eax,%ecx
  802dc3:	75 52                	jne    802e17 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802dc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc8:	89 d0                	mov    %edx,%eax
  802dca:	01 c0                	add    %eax,%eax
  802dcc:	01 d0                	add    %edx,%eax
  802dce:	c1 e0 02             	shl    $0x2,%eax
  802dd1:	05 44 10 81 00       	add    $0x811044,%eax
  802dd6:	8b 08                	mov    (%eax),%ecx
  802dd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ddb:	89 d0                	mov    %edx,%eax
  802ddd:	01 c0                	add    %eax,%eax
  802ddf:	01 d0                	add    %edx,%eax
  802de1:	c1 e0 02             	shl    $0x2,%eax
  802de4:	05 44 10 81 00       	add    $0x811044,%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	01 c1                	add    %eax,%ecx
  802ded:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df0:	89 d0                	mov    %edx,%eax
  802df2:	01 c0                	add    %eax,%eax
  802df4:	01 d0                	add    %edx,%eax
  802df6:	c1 e0 02             	shl    $0x2,%eax
  802df9:	05 44 10 81 00       	add    $0x811044,%eax
  802dfe:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802e00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e03:	89 d0                	mov    %edx,%eax
  802e05:	01 c0                	add    %eax,%eax
  802e07:	01 d0                	add    %edx,%eax
  802e09:	c1 e0 02             	shl    $0x2,%eax
  802e0c:	05 48 10 81 00       	add    $0x811048,%eax
  802e11:	c6 00 00             	movb   $0x0,(%eax)
  802e14:	eb 01                	jmp    802e17 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802e16:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e17:	ff 45 e8             	incl   -0x18(%ebp)
  802e1a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802e21:	0f 8e 7f fe ff ff    	jle    802ca6 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802e27:	a1 30 51 83 00       	mov    0x835130,%eax
  802e2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e36:	eb 53                	jmp    802e8b <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802e38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3b:	89 d0                	mov    %edx,%eax
  802e3d:	01 c0                	add    %eax,%eax
  802e3f:	01 d0                	add    %edx,%eax
  802e41:	c1 e0 02             	shl    $0x2,%eax
  802e44:	05 48 50 80 00       	add    $0x805048,%eax
  802e49:	8a 00                	mov    (%eax),%al
  802e4b:	84 c0                	test   %al,%al
  802e4d:	74 39                	je     802e88 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e52:	89 d0                	mov    %edx,%eax
  802e54:	01 c0                	add    %eax,%eax
  802e56:	01 d0                	add    %edx,%eax
  802e58:	c1 e0 02             	shl    $0x2,%eax
  802e5b:	05 40 50 80 00       	add    $0x805040,%eax
  802e60:	8b 08                	mov    (%eax),%ecx
  802e62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e65:	89 d0                	mov    %edx,%eax
  802e67:	01 c0                	add    %eax,%eax
  802e69:	01 d0                	add    %edx,%eax
  802e6b:	c1 e0 02             	shl    $0x2,%eax
  802e6e:	05 44 50 80 00       	add    $0x805044,%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	01 c8                	add    %ecx,%eax
  802e77:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e80:	76 06                	jbe    802e88 <sfree+0x321>
  802e82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e88:	ff 45 e0             	incl   -0x20(%ebp)
  802e8b:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e92:	7e a4                	jle    802e38 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e97:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e9c:	eb 16                	jmp    802eb4 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e9e:	ff 45 f4             	incl   -0xc(%ebp)
  802ea1:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802ea8:	0f 8e 04 fd ff ff    	jle    802bb2 <sfree+0x4b>
  802eae:	eb 04                	jmp    802eb4 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802eb0:	90                   	nop
  802eb1:	eb 01                	jmp    802eb4 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802eb3:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802eb4:	c9                   	leave  
  802eb5:	c3                   	ret    

00802eb6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802eb6:	55                   	push   %ebp
  802eb7:	89 e5                	mov    %esp,%ebp
  802eb9:	57                   	push   %edi
  802eba:	56                   	push   %esi
  802ebb:	53                   	push   %ebx
  802ebc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ec8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ecb:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ece:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ed1:	cd 30                	int    $0x30
  802ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ed9:	83 c4 10             	add    $0x10,%esp
  802edc:	5b                   	pop    %ebx
  802edd:	5e                   	pop    %esi
  802ede:	5f                   	pop    %edi
  802edf:	5d                   	pop    %ebp
  802ee0:	c3                   	ret    

00802ee1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ee1:	55                   	push   %ebp
  802ee2:	89 e5                	mov    %esp,%ebp
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  802eea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802eed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ef0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	6a 00                	push   $0x0
  802ef9:	51                   	push   %ecx
  802efa:	52                   	push   %edx
  802efb:	ff 75 0c             	pushl  0xc(%ebp)
  802efe:	50                   	push   %eax
  802eff:	6a 00                	push   $0x0
  802f01:	e8 b0 ff ff ff       	call   802eb6 <syscall>
  802f06:	83 c4 18             	add    $0x18,%esp
}
  802f09:	90                   	nop
  802f0a:	c9                   	leave  
  802f0b:	c3                   	ret    

00802f0c <sys_cgetc>:

int
sys_cgetc(void)
{
  802f0c:	55                   	push   %ebp
  802f0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	6a 00                	push   $0x0
  802f17:	6a 00                	push   $0x0
  802f19:	6a 02                	push   $0x2
  802f1b:	e8 96 ff ff ff       	call   802eb6 <syscall>
  802f20:	83 c4 18             	add    $0x18,%esp
}
  802f23:	c9                   	leave  
  802f24:	c3                   	ret    

00802f25 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802f25:	55                   	push   %ebp
  802f26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802f28:	6a 00                	push   $0x0
  802f2a:	6a 00                	push   $0x0
  802f2c:	6a 00                	push   $0x0
  802f2e:	6a 00                	push   $0x0
  802f30:	6a 00                	push   $0x0
  802f32:	6a 03                	push   $0x3
  802f34:	e8 7d ff ff ff       	call   802eb6 <syscall>
  802f39:	83 c4 18             	add    $0x18,%esp
}
  802f3c:	90                   	nop
  802f3d:	c9                   	leave  
  802f3e:	c3                   	ret    

00802f3f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f3f:	55                   	push   %ebp
  802f40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 04                	push   $0x4
  802f4e:	e8 63 ff ff ff       	call   802eb6 <syscall>
  802f53:	83 c4 18             	add    $0x18,%esp
}
  802f56:	90                   	nop
  802f57:	c9                   	leave  
  802f58:	c3                   	ret    

00802f59 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f59:	55                   	push   %ebp
  802f5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	6a 00                	push   $0x0
  802f68:	52                   	push   %edx
  802f69:	50                   	push   %eax
  802f6a:	6a 08                	push   $0x8
  802f6c:	e8 45 ff ff ff       	call   802eb6 <syscall>
  802f71:	83 c4 18             	add    $0x18,%esp
}
  802f74:	c9                   	leave  
  802f75:	c3                   	ret    

00802f76 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f76:	55                   	push   %ebp
  802f77:	89 e5                	mov    %esp,%ebp
  802f79:	56                   	push   %esi
  802f7a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f7b:	8b 75 18             	mov    0x18(%ebp),%esi
  802f7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	56                   	push   %esi
  802f8b:	53                   	push   %ebx
  802f8c:	51                   	push   %ecx
  802f8d:	52                   	push   %edx
  802f8e:	50                   	push   %eax
  802f8f:	6a 09                	push   $0x9
  802f91:	e8 20 ff ff ff       	call   802eb6 <syscall>
  802f96:	83 c4 18             	add    $0x18,%esp
}
  802f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f9c:	5b                   	pop    %ebx
  802f9d:	5e                   	pop    %esi
  802f9e:	5d                   	pop    %ebp
  802f9f:	c3                   	ret    

00802fa0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802fa0:	55                   	push   %ebp
  802fa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802fa3:	6a 00                	push   $0x0
  802fa5:	6a 00                	push   $0x0
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	ff 75 08             	pushl  0x8(%ebp)
  802fae:	6a 0a                	push   $0xa
  802fb0:	e8 01 ff ff ff       	call   802eb6 <syscall>
  802fb5:	83 c4 18             	add    $0x18,%esp
}
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802fbd:	6a 00                	push   $0x0
  802fbf:	6a 00                	push   $0x0
  802fc1:	6a 00                	push   $0x0
  802fc3:	ff 75 0c             	pushl  0xc(%ebp)
  802fc6:	ff 75 08             	pushl  0x8(%ebp)
  802fc9:	6a 0b                	push   $0xb
  802fcb:	e8 e6 fe ff ff       	call   802eb6 <syscall>
  802fd0:	83 c4 18             	add    $0x18,%esp
}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 0c                	push   $0xc
  802fe4:	e8 cd fe ff ff       	call   802eb6 <syscall>
  802fe9:	83 c4 18             	add    $0x18,%esp
}
  802fec:	c9                   	leave  
  802fed:	c3                   	ret    

00802fee <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 0d                	push   $0xd
  802ffd:	e8 b4 fe ff ff       	call   802eb6 <syscall>
  803002:	83 c4 18             	add    $0x18,%esp
}
  803005:	c9                   	leave  
  803006:	c3                   	ret    

00803007 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803007:	55                   	push   %ebp
  803008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80300a:	6a 00                	push   $0x0
  80300c:	6a 00                	push   $0x0
  80300e:	6a 00                	push   $0x0
  803010:	6a 00                	push   $0x0
  803012:	6a 00                	push   $0x0
  803014:	6a 0e                	push   $0xe
  803016:	e8 9b fe ff ff       	call   802eb6 <syscall>
  80301b:	83 c4 18             	add    $0x18,%esp
}
  80301e:	c9                   	leave  
  80301f:	c3                   	ret    

00803020 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803020:	55                   	push   %ebp
  803021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	6a 00                	push   $0x0
  803029:	6a 00                	push   $0x0
  80302b:	6a 00                	push   $0x0
  80302d:	6a 0f                	push   $0xf
  80302f:	e8 82 fe ff ff       	call   802eb6 <syscall>
  803034:	83 c4 18             	add    $0x18,%esp
}
  803037:	c9                   	leave  
  803038:	c3                   	ret    

00803039 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803039:	55                   	push   %ebp
  80303a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	6a 00                	push   $0x0
  803042:	6a 00                	push   $0x0
  803044:	ff 75 08             	pushl  0x8(%ebp)
  803047:	6a 10                	push   $0x10
  803049:	e8 68 fe ff ff       	call   802eb6 <syscall>
  80304e:	83 c4 18             	add    $0x18,%esp
}
  803051:	c9                   	leave  
  803052:	c3                   	ret    

00803053 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803053:	55                   	push   %ebp
  803054:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	6a 00                	push   $0x0
  803060:	6a 11                	push   $0x11
  803062:	e8 4f fe ff ff       	call   802eb6 <syscall>
  803067:	83 c4 18             	add    $0x18,%esp
}
  80306a:	90                   	nop
  80306b:	c9                   	leave  
  80306c:	c3                   	ret    

0080306d <sys_cputc>:

void
sys_cputc(const char c)
{
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803079:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 00                	push   $0x0
  803083:	6a 00                	push   $0x0
  803085:	50                   	push   %eax
  803086:	6a 01                	push   $0x1
  803088:	e8 29 fe ff ff       	call   802eb6 <syscall>
  80308d:	83 c4 18             	add    $0x18,%esp
}
  803090:	90                   	nop
  803091:	c9                   	leave  
  803092:	c3                   	ret    

00803093 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803093:	55                   	push   %ebp
  803094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803096:	6a 00                	push   $0x0
  803098:	6a 00                	push   $0x0
  80309a:	6a 00                	push   $0x0
  80309c:	6a 00                	push   $0x0
  80309e:	6a 00                	push   $0x0
  8030a0:	6a 14                	push   $0x14
  8030a2:	e8 0f fe ff ff       	call   802eb6 <syscall>
  8030a7:	83 c4 18             	add    $0x18,%esp
}
  8030aa:	90                   	nop
  8030ab:	c9                   	leave  
  8030ac:	c3                   	ret    

008030ad <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8030ad:	55                   	push   %ebp
  8030ae:	89 e5                	mov    %esp,%ebp
  8030b0:	83 ec 04             	sub    $0x4,%esp
  8030b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8030b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8030b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030bc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	6a 00                	push   $0x0
  8030c5:	51                   	push   %ecx
  8030c6:	52                   	push   %edx
  8030c7:	ff 75 0c             	pushl  0xc(%ebp)
  8030ca:	50                   	push   %eax
  8030cb:	6a 15                	push   $0x15
  8030cd:	e8 e4 fd ff ff       	call   802eb6 <syscall>
  8030d2:	83 c4 18             	add    $0x18,%esp
}
  8030d5:	c9                   	leave  
  8030d6:	c3                   	ret    

008030d7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8030d7:	55                   	push   %ebp
  8030d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8030da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	6a 00                	push   $0x0
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	52                   	push   %edx
  8030e7:	50                   	push   %eax
  8030e8:	6a 16                	push   $0x16
  8030ea:	e8 c7 fd ff ff       	call   802eb6 <syscall>
  8030ef:	83 c4 18             	add    $0x18,%esp
}
  8030f2:	c9                   	leave  
  8030f3:	c3                   	ret    

008030f4 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8030f4:	55                   	push   %ebp
  8030f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	51                   	push   %ecx
  803105:	52                   	push   %edx
  803106:	50                   	push   %eax
  803107:	6a 17                	push   $0x17
  803109:	e8 a8 fd ff ff       	call   802eb6 <syscall>
  80310e:	83 c4 18             	add    $0x18,%esp
}
  803111:	c9                   	leave  
  803112:	c3                   	ret    

00803113 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803113:	55                   	push   %ebp
  803114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803116:	8b 55 0c             	mov    0xc(%ebp),%edx
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	6a 00                	push   $0x0
  80311e:	6a 00                	push   $0x0
  803120:	6a 00                	push   $0x0
  803122:	52                   	push   %edx
  803123:	50                   	push   %eax
  803124:	6a 18                	push   $0x18
  803126:	e8 8b fd ff ff       	call   802eb6 <syscall>
  80312b:	83 c4 18             	add    $0x18,%esp
}
  80312e:	c9                   	leave  
  80312f:	c3                   	ret    

00803130 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803130:	55                   	push   %ebp
  803131:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	6a 00                	push   $0x0
  803138:	ff 75 14             	pushl  0x14(%ebp)
  80313b:	ff 75 10             	pushl  0x10(%ebp)
  80313e:	ff 75 0c             	pushl  0xc(%ebp)
  803141:	50                   	push   %eax
  803142:	6a 19                	push   $0x19
  803144:	e8 6d fd ff ff       	call   802eb6 <syscall>
  803149:	83 c4 18             	add    $0x18,%esp
}
  80314c:	c9                   	leave  
  80314d:	c3                   	ret    

0080314e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80314e:	55                   	push   %ebp
  80314f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	6a 00                	push   $0x0
  803156:	6a 00                	push   $0x0
  803158:	6a 00                	push   $0x0
  80315a:	6a 00                	push   $0x0
  80315c:	50                   	push   %eax
  80315d:	6a 1a                	push   $0x1a
  80315f:	e8 52 fd ff ff       	call   802eb6 <syscall>
  803164:	83 c4 18             	add    $0x18,%esp
}
  803167:	90                   	nop
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	6a 00                	push   $0x0
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	50                   	push   %eax
  803179:	6a 1b                	push   $0x1b
  80317b:	e8 36 fd ff ff       	call   802eb6 <syscall>
  803180:	83 c4 18             	add    $0x18,%esp
}
  803183:	c9                   	leave  
  803184:	c3                   	ret    

00803185 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803185:	55                   	push   %ebp
  803186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803188:	6a 00                	push   $0x0
  80318a:	6a 00                	push   $0x0
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	6a 00                	push   $0x0
  803192:	6a 05                	push   $0x5
  803194:	e8 1d fd ff ff       	call   802eb6 <syscall>
  803199:	83 c4 18             	add    $0x18,%esp
}
  80319c:	c9                   	leave  
  80319d:	c3                   	ret    

0080319e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80319e:	55                   	push   %ebp
  80319f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	6a 00                	push   $0x0
  8031a9:	6a 00                	push   $0x0
  8031ab:	6a 06                	push   $0x6
  8031ad:	e8 04 fd ff ff       	call   802eb6 <syscall>
  8031b2:	83 c4 18             	add    $0x18,%esp
}
  8031b5:	c9                   	leave  
  8031b6:	c3                   	ret    

008031b7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8031b7:	55                   	push   %ebp
  8031b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 00                	push   $0x0
  8031c2:	6a 00                	push   $0x0
  8031c4:	6a 07                	push   $0x7
  8031c6:	e8 eb fc ff ff       	call   802eb6 <syscall>
  8031cb:	83 c4 18             	add    $0x18,%esp
}
  8031ce:	c9                   	leave  
  8031cf:	c3                   	ret    

008031d0 <sys_exit_env>:


void sys_exit_env(void)
{
  8031d0:	55                   	push   %ebp
  8031d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8031d3:	6a 00                	push   $0x0
  8031d5:	6a 00                	push   $0x0
  8031d7:	6a 00                	push   $0x0
  8031d9:	6a 00                	push   $0x0
  8031db:	6a 00                	push   $0x0
  8031dd:	6a 1c                	push   $0x1c
  8031df:	e8 d2 fc ff ff       	call   802eb6 <syscall>
  8031e4:	83 c4 18             	add    $0x18,%esp
}
  8031e7:	90                   	nop
  8031e8:	c9                   	leave  
  8031e9:	c3                   	ret    

008031ea <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8031ea:	55                   	push   %ebp
  8031eb:	89 e5                	mov    %esp,%ebp
  8031ed:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031f3:	8d 50 04             	lea    0x4(%eax),%edx
  8031f6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031f9:	6a 00                	push   $0x0
  8031fb:	6a 00                	push   $0x0
  8031fd:	6a 00                	push   $0x0
  8031ff:	52                   	push   %edx
  803200:	50                   	push   %eax
  803201:	6a 1d                	push   $0x1d
  803203:	e8 ae fc ff ff       	call   802eb6 <syscall>
  803208:	83 c4 18             	add    $0x18,%esp
	return result;
  80320b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80320e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803211:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803214:	89 01                	mov    %eax,(%ecx)
  803216:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	c9                   	leave  
  80321d:	c2 04 00             	ret    $0x4

00803220 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803220:	55                   	push   %ebp
  803221:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803223:	6a 00                	push   $0x0
  803225:	6a 00                	push   $0x0
  803227:	ff 75 10             	pushl  0x10(%ebp)
  80322a:	ff 75 0c             	pushl  0xc(%ebp)
  80322d:	ff 75 08             	pushl  0x8(%ebp)
  803230:	6a 13                	push   $0x13
  803232:	e8 7f fc ff ff       	call   802eb6 <syscall>
  803237:	83 c4 18             	add    $0x18,%esp
	return ;
  80323a:	90                   	nop
}
  80323b:	c9                   	leave  
  80323c:	c3                   	ret    

0080323d <sys_rcr2>:
uint32 sys_rcr2()
{
  80323d:	55                   	push   %ebp
  80323e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803240:	6a 00                	push   $0x0
  803242:	6a 00                	push   $0x0
  803244:	6a 00                	push   $0x0
  803246:	6a 00                	push   $0x0
  803248:	6a 00                	push   $0x0
  80324a:	6a 1e                	push   $0x1e
  80324c:	e8 65 fc ff ff       	call   802eb6 <syscall>
  803251:	83 c4 18             	add    $0x18,%esp
}
  803254:	c9                   	leave  
  803255:	c3                   	ret    

00803256 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803256:	55                   	push   %ebp
  803257:	89 e5                	mov    %esp,%ebp
  803259:	83 ec 04             	sub    $0x4,%esp
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803262:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803266:	6a 00                	push   $0x0
  803268:	6a 00                	push   $0x0
  80326a:	6a 00                	push   $0x0
  80326c:	6a 00                	push   $0x0
  80326e:	50                   	push   %eax
  80326f:	6a 1f                	push   $0x1f
  803271:	e8 40 fc ff ff       	call   802eb6 <syscall>
  803276:	83 c4 18             	add    $0x18,%esp
	return ;
  803279:	90                   	nop
}
  80327a:	c9                   	leave  
  80327b:	c3                   	ret    

0080327c <rsttst>:
void rsttst()
{
  80327c:	55                   	push   %ebp
  80327d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80327f:	6a 00                	push   $0x0
  803281:	6a 00                	push   $0x0
  803283:	6a 00                	push   $0x0
  803285:	6a 00                	push   $0x0
  803287:	6a 00                	push   $0x0
  803289:	6a 21                	push   $0x21
  80328b:	e8 26 fc ff ff       	call   802eb6 <syscall>
  803290:	83 c4 18             	add    $0x18,%esp
	return ;
  803293:	90                   	nop
}
  803294:	c9                   	leave  
  803295:	c3                   	ret    

00803296 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803296:	55                   	push   %ebp
  803297:	89 e5                	mov    %esp,%ebp
  803299:	83 ec 04             	sub    $0x4,%esp
  80329c:	8b 45 14             	mov    0x14(%ebp),%eax
  80329f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8032a2:	8b 55 18             	mov    0x18(%ebp),%edx
  8032a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8032a9:	52                   	push   %edx
  8032aa:	50                   	push   %eax
  8032ab:	ff 75 10             	pushl  0x10(%ebp)
  8032ae:	ff 75 0c             	pushl  0xc(%ebp)
  8032b1:	ff 75 08             	pushl  0x8(%ebp)
  8032b4:	6a 20                	push   $0x20
  8032b6:	e8 fb fb ff ff       	call   802eb6 <syscall>
  8032bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8032be:	90                   	nop
}
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <chktst>:
void chktst(uint32 n)
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	6a 00                	push   $0x0
  8032cc:	ff 75 08             	pushl  0x8(%ebp)
  8032cf:	6a 22                	push   $0x22
  8032d1:	e8 e0 fb ff ff       	call   802eb6 <syscall>
  8032d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8032d9:	90                   	nop
}
  8032da:	c9                   	leave  
  8032db:	c3                   	ret    

008032dc <inctst>:

void inctst()
{
  8032dc:	55                   	push   %ebp
  8032dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8032df:	6a 00                	push   $0x0
  8032e1:	6a 00                	push   $0x0
  8032e3:	6a 00                	push   $0x0
  8032e5:	6a 00                	push   $0x0
  8032e7:	6a 00                	push   $0x0
  8032e9:	6a 23                	push   $0x23
  8032eb:	e8 c6 fb ff ff       	call   802eb6 <syscall>
  8032f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032f3:	90                   	nop
}
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <gettst>:
uint32 gettst()
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032f9:	6a 00                	push   $0x0
  8032fb:	6a 00                	push   $0x0
  8032fd:	6a 00                	push   $0x0
  8032ff:	6a 00                	push   $0x0
  803301:	6a 00                	push   $0x0
  803303:	6a 24                	push   $0x24
  803305:	e8 ac fb ff ff       	call   802eb6 <syscall>
  80330a:	83 c4 18             	add    $0x18,%esp
}
  80330d:	c9                   	leave  
  80330e:	c3                   	ret    

0080330f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80330f:	55                   	push   %ebp
  803310:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803312:	6a 00                	push   $0x0
  803314:	6a 00                	push   $0x0
  803316:	6a 00                	push   $0x0
  803318:	6a 00                	push   $0x0
  80331a:	6a 00                	push   $0x0
  80331c:	6a 25                	push   $0x25
  80331e:	e8 93 fb ff ff       	call   802eb6 <syscall>
  803323:	83 c4 18             	add    $0x18,%esp
  803326:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  80332b:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803330:	c9                   	leave  
  803331:	c3                   	ret    

00803332 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803332:	55                   	push   %ebp
  803333:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80333d:	6a 00                	push   $0x0
  80333f:	6a 00                	push   $0x0
  803341:	6a 00                	push   $0x0
  803343:	6a 00                	push   $0x0
  803345:	ff 75 08             	pushl  0x8(%ebp)
  803348:	6a 26                	push   $0x26
  80334a:	e8 67 fb ff ff       	call   802eb6 <syscall>
  80334f:	83 c4 18             	add    $0x18,%esp
	return ;
  803352:	90                   	nop
}
  803353:	c9                   	leave  
  803354:	c3                   	ret    

00803355 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803355:	55                   	push   %ebp
  803356:	89 e5                	mov    %esp,%ebp
  803358:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803359:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80335c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80335f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	6a 00                	push   $0x0
  803367:	53                   	push   %ebx
  803368:	51                   	push   %ecx
  803369:	52                   	push   %edx
  80336a:	50                   	push   %eax
  80336b:	6a 27                	push   $0x27
  80336d:	e8 44 fb ff ff       	call   802eb6 <syscall>
  803372:	83 c4 18             	add    $0x18,%esp
}
  803375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803378:	c9                   	leave  
  803379:	c3                   	ret    

0080337a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80337a:	55                   	push   %ebp
  80337b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80337d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	6a 00                	push   $0x0
  803385:	6a 00                	push   $0x0
  803387:	6a 00                	push   $0x0
  803389:	52                   	push   %edx
  80338a:	50                   	push   %eax
  80338b:	6a 28                	push   $0x28
  80338d:	e8 24 fb ff ff       	call   802eb6 <syscall>
  803392:	83 c4 18             	add    $0x18,%esp
}
  803395:	c9                   	leave  
  803396:	c3                   	ret    

00803397 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803397:	55                   	push   %ebp
  803398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80339a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80339d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	6a 00                	push   $0x0
  8033a5:	51                   	push   %ecx
  8033a6:	ff 75 10             	pushl  0x10(%ebp)
  8033a9:	52                   	push   %edx
  8033aa:	50                   	push   %eax
  8033ab:	6a 29                	push   $0x29
  8033ad:	e8 04 fb ff ff       	call   802eb6 <syscall>
  8033b2:	83 c4 18             	add    $0x18,%esp
}
  8033b5:	c9                   	leave  
  8033b6:	c3                   	ret    

008033b7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8033ba:	6a 00                	push   $0x0
  8033bc:	6a 00                	push   $0x0
  8033be:	ff 75 10             	pushl  0x10(%ebp)
  8033c1:	ff 75 0c             	pushl  0xc(%ebp)
  8033c4:	ff 75 08             	pushl  0x8(%ebp)
  8033c7:	6a 12                	push   $0x12
  8033c9:	e8 e8 fa ff ff       	call   802eb6 <syscall>
  8033ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8033d1:	90                   	nop
}
  8033d2:	c9                   	leave  
  8033d3:	c3                   	ret    

008033d4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8033d4:	55                   	push   %ebp
  8033d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8033d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033da:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dd:	6a 00                	push   $0x0
  8033df:	6a 00                	push   $0x0
  8033e1:	6a 00                	push   $0x0
  8033e3:	52                   	push   %edx
  8033e4:	50                   	push   %eax
  8033e5:	6a 2a                	push   $0x2a
  8033e7:	e8 ca fa ff ff       	call   802eb6 <syscall>
  8033ec:	83 c4 18             	add    $0x18,%esp
	return;
  8033ef:	90                   	nop
}
  8033f0:	c9                   	leave  
  8033f1:	c3                   	ret    

008033f2 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8033f2:	55                   	push   %ebp
  8033f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8033f5:	6a 00                	push   $0x0
  8033f7:	6a 00                	push   $0x0
  8033f9:	6a 00                	push   $0x0
  8033fb:	6a 00                	push   $0x0
  8033fd:	6a 00                	push   $0x0
  8033ff:	6a 2b                	push   $0x2b
  803401:	e8 b0 fa ff ff       	call   802eb6 <syscall>
  803406:	83 c4 18             	add    $0x18,%esp
}
  803409:	c9                   	leave  
  80340a:	c3                   	ret    

0080340b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80340b:	55                   	push   %ebp
  80340c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80340e:	6a 00                	push   $0x0
  803410:	6a 00                	push   $0x0
  803412:	6a 00                	push   $0x0
  803414:	ff 75 0c             	pushl  0xc(%ebp)
  803417:	ff 75 08             	pushl  0x8(%ebp)
  80341a:	6a 2d                	push   $0x2d
  80341c:	e8 95 fa ff ff       	call   802eb6 <syscall>
  803421:	83 c4 18             	add    $0x18,%esp
	return;
  803424:	90                   	nop
}
  803425:	c9                   	leave  
  803426:	c3                   	ret    

00803427 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803427:	55                   	push   %ebp
  803428:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80342a:	6a 00                	push   $0x0
  80342c:	6a 00                	push   $0x0
  80342e:	6a 00                	push   $0x0
  803430:	ff 75 0c             	pushl  0xc(%ebp)
  803433:	ff 75 08             	pushl  0x8(%ebp)
  803436:	6a 2c                	push   $0x2c
  803438:	e8 79 fa ff ff       	call   802eb6 <syscall>
  80343d:	83 c4 18             	add    $0x18,%esp
	return ;
  803440:	90                   	nop
}
  803441:	c9                   	leave  
  803442:	c3                   	ret    

00803443 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803443:	55                   	push   %ebp
  803444:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803446:	8b 55 0c             	mov    0xc(%ebp),%edx
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	6a 00                	push   $0x0
  80344e:	6a 00                	push   $0x0
  803450:	6a 00                	push   $0x0
  803452:	52                   	push   %edx
  803453:	50                   	push   %eax
  803454:	6a 2e                	push   $0x2e
  803456:	e8 5b fa ff ff       	call   802eb6 <syscall>
  80345b:	83 c4 18             	add    $0x18,%esp
}
  80345e:	90                   	nop
  80345f:	c9                   	leave  
  803460:	c3                   	ret    

00803461 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803461:	55                   	push   %ebp
  803462:	89 e5                	mov    %esp,%ebp
  803464:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803467:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  80346e:	72 09                	jb     803479 <to_page_va+0x18>
  803470:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803477:	72 14                	jb     80348d <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803479:	83 ec 04             	sub    $0x4,%esp
  80347c:	68 78 4a 80 00       	push   $0x804a78
  803481:	6a 15                	push   $0x15
  803483:	68 a3 4a 80 00       	push   $0x804aa3
  803488:	e8 10 d0 ff ff       	call   80049d <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803495:	29 d0                	sub    %edx,%eax
  803497:	c1 f8 02             	sar    $0x2,%eax
  80349a:	89 c2                	mov    %eax,%edx
  80349c:	89 d0                	mov    %edx,%eax
  80349e:	c1 e0 02             	shl    $0x2,%eax
  8034a1:	01 d0                	add    %edx,%eax
  8034a3:	c1 e0 02             	shl    $0x2,%eax
  8034a6:	01 d0                	add    %edx,%eax
  8034a8:	c1 e0 02             	shl    $0x2,%eax
  8034ab:	01 d0                	add    %edx,%eax
  8034ad:	89 c1                	mov    %eax,%ecx
  8034af:	c1 e1 08             	shl    $0x8,%ecx
  8034b2:	01 c8                	add    %ecx,%eax
  8034b4:	89 c1                	mov    %eax,%ecx
  8034b6:	c1 e1 10             	shl    $0x10,%ecx
  8034b9:	01 c8                	add    %ecx,%eax
  8034bb:	01 c0                	add    %eax,%eax
  8034bd:	01 d0                	add    %edx,%eax
  8034bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	c1 e0 0c             	shl    $0xc,%eax
  8034c8:	89 c2                	mov    %eax,%edx
  8034ca:	a1 84 50 83 00       	mov    0x835084,%eax
  8034cf:	01 d0                	add    %edx,%eax
}
  8034d1:	c9                   	leave  
  8034d2:	c3                   	ret    

008034d3 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8034d3:	55                   	push   %ebp
  8034d4:	89 e5                	mov    %esp,%ebp
  8034d6:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8034d9:	a1 84 50 83 00       	mov    0x835084,%eax
  8034de:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e1:	29 c2                	sub    %eax,%edx
  8034e3:	89 d0                	mov    %edx,%eax
  8034e5:	c1 e8 0c             	shr    $0xc,%eax
  8034e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8034eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ef:	78 09                	js     8034fa <to_page_info+0x27>
  8034f1:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8034f8:	7e 14                	jle    80350e <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8034fa:	83 ec 04             	sub    $0x4,%esp
  8034fd:	68 bc 4a 80 00       	push   $0x804abc
  803502:	6a 21                	push   $0x21
  803504:	68 a3 4a 80 00       	push   $0x804aa3
  803509:	e8 8f cf ff ff       	call   80049d <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80350e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803511:	89 d0                	mov    %edx,%eax
  803513:	01 c0                	add    %eax,%eax
  803515:	01 d0                	add    %edx,%eax
  803517:	c1 e0 02             	shl    $0x2,%eax
  80351a:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80351f:	c9                   	leave  
  803520:	c3                   	ret    

00803521 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803521:	55                   	push   %ebp
  803522:	89 e5                	mov    %esp,%ebp
  803524:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	05 00 00 00 02       	add    $0x2000000,%eax
  80352f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803532:	73 16                	jae    80354a <initialize_dynamic_allocator+0x29>
  803534:	68 e0 4a 80 00       	push   $0x804ae0
  803539:	68 06 4b 80 00       	push   $0x804b06
  80353e:	6a 2f                	push   $0x2f
  803540:	68 a3 4a 80 00       	push   $0x804aa3
  803545:	e8 53 cf ff ff       	call   80049d <_panic>
	dynAllocStart = daStart;
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803552:	8b 45 0c             	mov    0xc(%ebp),%eax
  803555:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80355a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803561:	eb 36                	jmp    803599 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	c1 e0 04             	shl    $0x4,%eax
  803569:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80356e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	c1 e0 04             	shl    $0x4,%eax
  80357a:	05 a4 50 83 00       	add    $0x8350a4,%eax
  80357f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	c1 e0 04             	shl    $0x4,%eax
  80358b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803596:	ff 45 f4             	incl   -0xc(%ebp)
  803599:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80359d:	7e c4                	jle    803563 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  80359f:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8035a6:	00 00 00 
  8035a9:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8035b0:	00 00 00 
  8035b3:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8035ba:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8035bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035c4:	e9 1b 01 00 00       	jmp    8036e4 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8035c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035cc:	89 d0                	mov    %edx,%eax
  8035ce:	01 c0                	add    %eax,%eax
  8035d0:	01 d0                	add    %edx,%eax
  8035d2:	c1 e0 02             	shl    $0x2,%eax
  8035d5:	05 88 d0 81 00       	add    $0x81d088,%eax
  8035da:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8035df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e2:	89 d0                	mov    %edx,%eax
  8035e4:	01 c0                	add    %eax,%eax
  8035e6:	01 d0                	add    %edx,%eax
  8035e8:	c1 e0 02             	shl    $0x2,%eax
  8035eb:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8035f0:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8035f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f8:	89 d0                	mov    %edx,%eax
  8035fa:	01 c0                	add    %eax,%eax
  8035fc:	01 d0                	add    %edx,%eax
  8035fe:	c1 e0 02             	shl    $0x2,%eax
  803601:	05 80 d0 81 00       	add    $0x81d080,%eax
  803606:	8b 00                	mov    (%eax),%eax
  803608:	85 c0                	test   %eax,%eax
  80360a:	74 2b                	je     803637 <initialize_dynamic_allocator+0x116>
  80360c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80360f:	89 d0                	mov    %edx,%eax
  803611:	01 c0                	add    %eax,%eax
  803613:	01 d0                	add    %edx,%eax
  803615:	c1 e0 02             	shl    $0x2,%eax
  803618:	05 80 d0 81 00       	add    $0x81d080,%eax
  80361d:	8b 10                	mov    (%eax),%edx
  80361f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803622:	89 c8                	mov    %ecx,%eax
  803624:	01 c0                	add    %eax,%eax
  803626:	01 c8                	add    %ecx,%eax
  803628:	c1 e0 02             	shl    $0x2,%eax
  80362b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803630:	8b 00                	mov    (%eax),%eax
  803632:	89 42 04             	mov    %eax,0x4(%edx)
  803635:	eb 18                	jmp    80364f <initialize_dynamic_allocator+0x12e>
  803637:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80363a:	89 d0                	mov    %edx,%eax
  80363c:	01 c0                	add    %eax,%eax
  80363e:	01 d0                	add    %edx,%eax
  803640:	c1 e0 02             	shl    $0x2,%eax
  803643:	05 84 d0 81 00       	add    $0x81d084,%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80364f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803652:	89 d0                	mov    %edx,%eax
  803654:	01 c0                	add    %eax,%eax
  803656:	01 d0                	add    %edx,%eax
  803658:	c1 e0 02             	shl    $0x2,%eax
  80365b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803660:	8b 00                	mov    (%eax),%eax
  803662:	85 c0                	test   %eax,%eax
  803664:	74 2a                	je     803690 <initialize_dynamic_allocator+0x16f>
  803666:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803669:	89 d0                	mov    %edx,%eax
  80366b:	01 c0                	add    %eax,%eax
  80366d:	01 d0                	add    %edx,%eax
  80366f:	c1 e0 02             	shl    $0x2,%eax
  803672:	05 84 d0 81 00       	add    $0x81d084,%eax
  803677:	8b 10                	mov    (%eax),%edx
  803679:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80367c:	89 c8                	mov    %ecx,%eax
  80367e:	01 c0                	add    %eax,%eax
  803680:	01 c8                	add    %ecx,%eax
  803682:	c1 e0 02             	shl    $0x2,%eax
  803685:	05 80 d0 81 00       	add    $0x81d080,%eax
  80368a:	8b 00                	mov    (%eax),%eax
  80368c:	89 02                	mov    %eax,(%edx)
  80368e:	eb 18                	jmp    8036a8 <initialize_dynamic_allocator+0x187>
  803690:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803693:	89 d0                	mov    %edx,%eax
  803695:	01 c0                	add    %eax,%eax
  803697:	01 d0                	add    %edx,%eax
  803699:	c1 e0 02             	shl    $0x2,%eax
  80369c:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036a1:	8b 00                	mov    (%eax),%eax
  8036a3:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8036a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ab:	89 d0                	mov    %edx,%eax
  8036ad:	01 c0                	add    %eax,%eax
  8036af:	01 d0                	add    %edx,%eax
  8036b1:	c1 e0 02             	shl    $0x2,%eax
  8036b4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036c2:	89 d0                	mov    %edx,%eax
  8036c4:	01 c0                	add    %eax,%eax
  8036c6:	01 d0                	add    %edx,%eax
  8036c8:	c1 e0 02             	shl    $0x2,%eax
  8036cb:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d6:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036db:	48                   	dec    %eax
  8036dc:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036e1:	ff 45 f0             	incl   -0x10(%ebp)
  8036e4:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8036eb:	0f 8e d8 fe ff ff    	jle    8035c9 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036f1:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8036f8:	e9 9d 00 00 00       	jmp    80379a <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8036fd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803703:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803706:	89 c8                	mov    %ecx,%eax
  803708:	01 c0                	add    %eax,%eax
  80370a:	01 c8                	add    %ecx,%eax
  80370c:	c1 e0 02             	shl    $0x2,%eax
  80370f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803714:	89 10                	mov    %edx,(%eax)
  803716:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803719:	89 d0                	mov    %edx,%eax
  80371b:	01 c0                	add    %eax,%eax
  80371d:	01 d0                	add    %edx,%eax
  80371f:	c1 e0 02             	shl    $0x2,%eax
  803722:	05 80 d0 81 00       	add    $0x81d080,%eax
  803727:	8b 00                	mov    (%eax),%eax
  803729:	85 c0                	test   %eax,%eax
  80372b:	74 1c                	je     803749 <initialize_dynamic_allocator+0x228>
  80372d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803733:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803736:	89 c8                	mov    %ecx,%eax
  803738:	01 c0                	add    %eax,%eax
  80373a:	01 c8                	add    %ecx,%eax
  80373c:	c1 e0 02             	shl    $0x2,%eax
  80373f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803744:	89 42 04             	mov    %eax,0x4(%edx)
  803747:	eb 16                	jmp    80375f <initialize_dynamic_allocator+0x23e>
  803749:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80374c:	89 d0                	mov    %edx,%eax
  80374e:	01 c0                	add    %eax,%eax
  803750:	01 d0                	add    %edx,%eax
  803752:	c1 e0 02             	shl    $0x2,%eax
  803755:	05 80 d0 81 00       	add    $0x81d080,%eax
  80375a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80375f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803762:	89 d0                	mov    %edx,%eax
  803764:	01 c0                	add    %eax,%eax
  803766:	01 d0                	add    %edx,%eax
  803768:	c1 e0 02             	shl    $0x2,%eax
  80376b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803770:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803775:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803778:	89 d0                	mov    %edx,%eax
  80377a:	01 c0                	add    %eax,%eax
  80377c:	01 d0                	add    %edx,%eax
  80377e:	c1 e0 02             	shl    $0x2,%eax
  803781:	05 84 d0 81 00       	add    $0x81d084,%eax
  803786:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378c:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803791:	40                   	inc    %eax
  803792:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803797:	ff 4d ec             	decl   -0x14(%ebp)
  80379a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80379e:	0f 89 59 ff ff ff    	jns    8036fd <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8037a4:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8037ab:	00 00 00 
}
  8037ae:	90                   	nop
  8037af:	c9                   	leave  
  8037b0:	c3                   	ret    

008037b1 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8037b1:	55                   	push   %ebp
  8037b2:	89 e5                	mov    %esp,%ebp
  8037b4:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8037b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ba:	83 ec 0c             	sub    $0xc,%esp
  8037bd:	50                   	push   %eax
  8037be:	e8 10 fd ff ff       	call   8034d3 <to_page_info>
  8037c3:	83 c4 10             	add    $0x10,%esp
  8037c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8037c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cc:	8b 40 08             	mov    0x8(%eax),%eax
  8037cf:	0f b7 c0             	movzwl %ax,%eax
}
  8037d2:	c9                   	leave  
  8037d3:	c3                   	ret    

008037d4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037d4:	55                   	push   %ebp
  8037d5:	89 e5                	mov    %esp,%ebp
  8037d7:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037da:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037e1:	76 16                	jbe    8037f9 <alloc_block+0x25>
  8037e3:	68 1c 4b 80 00       	push   $0x804b1c
  8037e8:	68 06 4b 80 00       	push   $0x804b06
  8037ed:	6a 59                	push   $0x59
  8037ef:	68 a3 4a 80 00       	push   $0x804aa3
  8037f4:	e8 a4 cc ff ff       	call   80049d <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8037f9:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803800:	eb 08                	jmp    80380a <alloc_block+0x36>
		allocSize <<= 1;
  803802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803805:	01 c0                	add    %eax,%eax
  803807:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80380a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803810:	73 09                	jae    80381b <alloc_block+0x47>
  803812:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803819:	76 e7                	jbe    803802 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  80381b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803822:	eb 03                	jmp    803827 <alloc_block+0x53>
		listIndex++;
  803824:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382a:	ba 08 00 00 00       	mov    $0x8,%edx
  80382f:	88 c1                	mov    %al,%cl
  803831:	d3 e2                	shl    %cl,%edx
  803833:	89 d0                	mov    %edx,%eax
  803835:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803838:	72 ea                	jb     803824 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80383a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803840:	e9 f4 00 00 00       	jmp    803939 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803848:	c1 e0 04             	shl    $0x4,%eax
  80384b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803850:	8b 00                	mov    (%eax),%eax
  803852:	85 c0                	test   %eax,%eax
  803854:	0f 84 dc 00 00 00    	je     803936 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80385a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385d:	c1 e0 04             	shl    $0x4,%eax
  803860:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803865:	8b 00                	mov    (%eax),%eax
  803867:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80386a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80386e:	75 14                	jne    803884 <alloc_block+0xb0>
  803870:	83 ec 04             	sub    $0x4,%esp
  803873:	68 3d 4b 80 00       	push   $0x804b3d
  803878:	6a 6b                	push   $0x6b
  80387a:	68 a3 4a 80 00       	push   $0x804aa3
  80387f:	e8 19 cc ff ff       	call   80049d <_panic>
  803884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803887:	8b 00                	mov    (%eax),%eax
  803889:	85 c0                	test   %eax,%eax
  80388b:	74 10                	je     80389d <alloc_block+0xc9>
  80388d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803890:	8b 00                	mov    (%eax),%eax
  803892:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803895:	8b 52 04             	mov    0x4(%edx),%edx
  803898:	89 50 04             	mov    %edx,0x4(%eax)
  80389b:	eb 14                	jmp    8038b1 <alloc_block+0xdd>
  80389d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a0:	8b 40 04             	mov    0x4(%eax),%eax
  8038a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038a6:	c1 e2 04             	shl    $0x4,%edx
  8038a9:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8038af:	89 02                	mov    %eax,(%edx)
  8038b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b4:	8b 40 04             	mov    0x4(%eax),%eax
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	74 0f                	je     8038ca <alloc_block+0xf6>
  8038bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038be:	8b 40 04             	mov    0x4(%eax),%eax
  8038c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c4:	8b 12                	mov    (%edx),%edx
  8038c6:	89 10                	mov    %edx,(%eax)
  8038c8:	eb 13                	jmp    8038dd <alloc_block+0x109>
  8038ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cd:	8b 00                	mov    (%eax),%eax
  8038cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038d2:	c1 e2 04             	shl    $0x4,%edx
  8038d5:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8038db:	89 02                	mov    %eax,(%edx)
  8038dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f3:	c1 e0 04             	shl    $0x4,%eax
  8038f6:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038fb:	8b 00                	mov    (%eax),%eax
  8038fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803903:	c1 e0 04             	shl    $0x4,%eax
  803906:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80390b:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  80390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803910:	83 ec 0c             	sub    $0xc,%esp
  803913:	50                   	push   %eax
  803914:	e8 ba fb ff ff       	call   8034d3 <to_page_info>
  803919:	83 c4 10             	add    $0x10,%esp
  80391c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80391f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803922:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803926:	48                   	dec    %eax
  803927:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80392a:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  80392e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803931:	e9 8f 02 00 00       	jmp    803bc5 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803936:	ff 45 ec             	incl   -0x14(%ebp)
  803939:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80393d:	0f 8e 02 ff ff ff    	jle    803845 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803943:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803948:	85 c0                	test   %eax,%eax
  80394a:	75 14                	jne    803960 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  80394c:	83 ec 04             	sub    $0x4,%esp
  80394f:	68 5c 4b 80 00       	push   $0x804b5c
  803954:	6a 77                	push   $0x77
  803956:	68 a3 4a 80 00       	push   $0x804aa3
  80395b:	e8 3d cb ff ff       	call   80049d <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803960:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803965:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803968:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80396c:	75 14                	jne    803982 <alloc_block+0x1ae>
  80396e:	83 ec 04             	sub    $0x4,%esp
  803971:	68 3d 4b 80 00       	push   $0x804b3d
  803976:	6a 7a                	push   $0x7a
  803978:	68 a3 4a 80 00       	push   $0x804aa3
  80397d:	e8 1b cb ff ff       	call   80049d <_panic>
  803982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803985:	8b 00                	mov    (%eax),%eax
  803987:	85 c0                	test   %eax,%eax
  803989:	74 10                	je     80399b <alloc_block+0x1c7>
  80398b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398e:	8b 00                	mov    (%eax),%eax
  803990:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803993:	8b 52 04             	mov    0x4(%edx),%edx
  803996:	89 50 04             	mov    %edx,0x4(%eax)
  803999:	eb 0b                	jmp    8039a6 <alloc_block+0x1d2>
  80399b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399e:	8b 40 04             	mov    0x4(%eax),%eax
  8039a1:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8039a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a9:	8b 40 04             	mov    0x4(%eax),%eax
  8039ac:	85 c0                	test   %eax,%eax
  8039ae:	74 0f                	je     8039bf <alloc_block+0x1eb>
  8039b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b3:	8b 40 04             	mov    0x4(%eax),%eax
  8039b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039b9:	8b 12                	mov    (%edx),%edx
  8039bb:	89 10                	mov    %edx,(%eax)
  8039bd:	eb 0a                	jmp    8039c9 <alloc_block+0x1f5>
  8039bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c2:	8b 00                	mov    (%eax),%eax
  8039c4:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8039c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039dc:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8039e1:	48                   	dec    %eax
  8039e2:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8039e7:	83 ec 0c             	sub    $0xc,%esp
  8039ea:	ff 75 dc             	pushl  -0x24(%ebp)
  8039ed:	e8 6f fa ff ff       	call   803461 <to_page_va>
  8039f2:	83 c4 10             	add    $0x10,%esp
  8039f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8039f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039fb:	83 ec 0c             	sub    $0xc,%esp
  8039fe:	50                   	push   %eax
  8039ff:	e8 a0 dc ff ff       	call   8016a4 <get_page>
  803a04:	83 c4 10             	add    $0x10,%esp
  803a07:	85 c0                	test   %eax,%eax
  803a09:	74 14                	je     803a1f <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803a0b:	83 ec 04             	sub    $0x4,%esp
  803a0e:	68 84 4b 80 00       	push   $0x804b84
  803a13:	6a 7f                	push   $0x7f
  803a15:	68 a3 4a 80 00       	push   $0x804aa3
  803a1a:	e8 7e ca ff ff       	call   80049d <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a25:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803a29:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  803a33:	f7 75 f4             	divl   -0xc(%ebp)
  803a36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a39:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a3d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a44:	e9 a7 00 00 00       	jmp    803af0 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a49:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4f:	01 d0                	add    %edx,%eax
  803a51:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a54:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a58:	75 17                	jne    803a71 <alloc_block+0x29d>
  803a5a:	83 ec 04             	sub    $0x4,%esp
  803a5d:	68 ac 4b 80 00       	push   $0x804bac
  803a62:	68 88 00 00 00       	push   $0x88
  803a67:	68 a3 4a 80 00       	push   $0x804aa3
  803a6c:	e8 2c ca ff ff       	call   80049d <_panic>
  803a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a74:	c1 e0 04             	shl    $0x4,%eax
  803a77:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a7c:	8b 10                	mov    (%eax),%edx
  803a7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a81:	89 10                	mov    %edx,(%eax)
  803a83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a86:	8b 00                	mov    (%eax),%eax
  803a88:	85 c0                	test   %eax,%eax
  803a8a:	74 15                	je     803aa1 <alloc_block+0x2cd>
  803a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8f:	c1 e0 04             	shl    $0x4,%eax
  803a92:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a97:	8b 00                	mov    (%eax),%eax
  803a99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a9c:	89 50 04             	mov    %edx,0x4(%eax)
  803a9f:	eb 11                	jmp    803ab2 <alloc_block+0x2de>
  803aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa4:	c1 e0 04             	shl    $0x4,%eax
  803aa7:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803aad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab0:	89 02                	mov    %eax,(%edx)
  803ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab5:	c1 e0 04             	shl    $0x4,%eax
  803ab8:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803abe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ac1:	89 02                	mov    %eax,(%edx)
  803ac3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ac6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad0:	c1 e0 04             	shl    $0x4,%eax
  803ad3:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ad8:	8b 00                	mov    (%eax),%eax
  803ada:	8d 50 01             	lea    0x1(%eax),%edx
  803add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae0:	c1 e0 04             	shl    $0x4,%eax
  803ae3:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ae8:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aed:	01 45 e8             	add    %eax,-0x18(%ebp)
  803af0:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803af7:	0f 86 4c ff ff ff    	jbe    803a49 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b00:	c1 e0 04             	shl    $0x4,%eax
  803b03:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b08:	8b 00                	mov    (%eax),%eax
  803b0a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803b0d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b11:	75 17                	jne    803b2a <alloc_block+0x356>
  803b13:	83 ec 04             	sub    $0x4,%esp
  803b16:	68 3d 4b 80 00       	push   $0x804b3d
  803b1b:	68 8d 00 00 00       	push   $0x8d
  803b20:	68 a3 4a 80 00       	push   $0x804aa3
  803b25:	e8 73 c9 ff ff       	call   80049d <_panic>
  803b2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b2d:	8b 00                	mov    (%eax),%eax
  803b2f:	85 c0                	test   %eax,%eax
  803b31:	74 10                	je     803b43 <alloc_block+0x36f>
  803b33:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b36:	8b 00                	mov    (%eax),%eax
  803b38:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b3b:	8b 52 04             	mov    0x4(%edx),%edx
  803b3e:	89 50 04             	mov    %edx,0x4(%eax)
  803b41:	eb 14                	jmp    803b57 <alloc_block+0x383>
  803b43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b46:	8b 40 04             	mov    0x4(%eax),%eax
  803b49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b4c:	c1 e2 04             	shl    $0x4,%edx
  803b4f:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803b55:	89 02                	mov    %eax,(%edx)
  803b57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b5a:	8b 40 04             	mov    0x4(%eax),%eax
  803b5d:	85 c0                	test   %eax,%eax
  803b5f:	74 0f                	je     803b70 <alloc_block+0x39c>
  803b61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b64:	8b 40 04             	mov    0x4(%eax),%eax
  803b67:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b6a:	8b 12                	mov    (%edx),%edx
  803b6c:	89 10                	mov    %edx,(%eax)
  803b6e:	eb 13                	jmp    803b83 <alloc_block+0x3af>
  803b70:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b73:	8b 00                	mov    (%eax),%eax
  803b75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b78:	c1 e2 04             	shl    $0x4,%edx
  803b7b:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b81:	89 02                	mov    %eax,(%edx)
  803b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b8c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b99:	c1 e0 04             	shl    $0x4,%eax
  803b9c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ba1:	8b 00                	mov    (%eax),%eax
  803ba3:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ba9:	c1 e0 04             	shl    $0x4,%eax
  803bac:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bb1:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803bb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bb6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803bba:	48                   	dec    %eax
  803bbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bbe:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803bc2:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803bc5:	c9                   	leave  
  803bc6:	c3                   	ret    

00803bc7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803bc7:	55                   	push   %ebp
  803bc8:	89 e5                	mov    %esp,%ebp
  803bca:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803bcd:	8b 55 08             	mov    0x8(%ebp),%edx
  803bd0:	a1 84 50 83 00       	mov    0x835084,%eax
  803bd5:	39 c2                	cmp    %eax,%edx
  803bd7:	72 0c                	jb     803be5 <free_block+0x1e>
  803bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  803bdc:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803be1:	39 c2                	cmp    %eax,%edx
  803be3:	72 19                	jb     803bfe <free_block+0x37>
  803be5:	68 d0 4b 80 00       	push   $0x804bd0
  803bea:	68 06 4b 80 00       	push   $0x804b06
  803bef:	68 98 00 00 00       	push   $0x98
  803bf4:	68 a3 4a 80 00       	push   $0x804aa3
  803bf9:	e8 9f c8 ff ff       	call   80049d <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  803c01:	83 ec 0c             	sub    $0xc,%esp
  803c04:	50                   	push   %eax
  803c05:	e8 c9 f8 ff ff       	call   8034d3 <to_page_info>
  803c0a:	83 c4 10             	add    $0x10,%esp
  803c0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c13:	8b 40 08             	mov    0x8(%eax),%eax
  803c16:	0f b7 c0             	movzwl %ax,%eax
  803c19:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c23:	eb 03                	jmp    803c28 <free_block+0x61>
		listIndex++;
  803c25:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2b:	ba 08 00 00 00       	mov    $0x8,%edx
  803c30:	88 c1                	mov    %al,%cl
  803c32:	d3 e2                	shl    %cl,%edx
  803c34:	89 d0                	mov    %edx,%eax
  803c36:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c39:	72 ea                	jb     803c25 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c45:	75 17                	jne    803c5e <free_block+0x97>
  803c47:	83 ec 04             	sub    $0x4,%esp
  803c4a:	68 ac 4b 80 00       	push   $0x804bac
  803c4f:	68 a2 00 00 00       	push   $0xa2
  803c54:	68 a3 4a 80 00       	push   $0x804aa3
  803c59:	e8 3f c8 ff ff       	call   80049d <_panic>
  803c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c61:	c1 e0 04             	shl    $0x4,%eax
  803c64:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c69:	8b 10                	mov    (%eax),%edx
  803c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6e:	89 10                	mov    %edx,(%eax)
  803c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c73:	8b 00                	mov    (%eax),%eax
  803c75:	85 c0                	test   %eax,%eax
  803c77:	74 15                	je     803c8e <free_block+0xc7>
  803c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7c:	c1 e0 04             	shl    $0x4,%eax
  803c7f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c84:	8b 00                	mov    (%eax),%eax
  803c86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c89:	89 50 04             	mov    %edx,0x4(%eax)
  803c8c:	eb 11                	jmp    803c9f <free_block+0xd8>
  803c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c91:	c1 e0 04             	shl    $0x4,%eax
  803c94:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9d:	89 02                	mov    %eax,(%edx)
  803c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca2:	c1 e0 04             	shl    $0x4,%eax
  803ca5:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803cab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cae:	89 02                	mov    %eax,(%edx)
  803cb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbd:	c1 e0 04             	shl    $0x4,%eax
  803cc0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cc5:	8b 00                	mov    (%eax),%eax
  803cc7:	8d 50 01             	lea    0x1(%eax),%edx
  803cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccd:	c1 e0 04             	shl    $0x4,%eax
  803cd0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cd5:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cda:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cde:	40                   	inc    %eax
  803cdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ce2:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ce9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ced:	0f b7 c8             	movzwl %ax,%ecx
  803cf0:	b8 00 10 00 00       	mov    $0x1000,%eax
  803cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  803cfa:	f7 75 e8             	divl   -0x18(%ebp)
  803cfd:	39 c1                	cmp    %eax,%ecx
  803cff:	0f 85 ed 01 00 00    	jne    803ef2 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d08:	c1 e0 04             	shl    $0x4,%eax
  803d0b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d10:	8b 00                	mov    (%eax),%eax
  803d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d15:	eb 2a                	jmp    803d41 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1a:	83 ec 0c             	sub    $0xc,%esp
  803d1d:	50                   	push   %eax
  803d1e:	e8 b0 f7 ff ff       	call   8034d3 <to_page_info>
  803d23:	83 c4 10             	add    $0x10,%esp
  803d26:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d29:	75 06                	jne    803d31 <free_block+0x16a>
				tmp = b;
  803d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d34:	c1 e0 04             	shl    $0x4,%eax
  803d37:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d3c:	8b 00                	mov    (%eax),%eax
  803d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d45:	74 07                	je     803d4e <free_block+0x187>
  803d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d4a:	8b 00                	mov    (%eax),%eax
  803d4c:	eb 05                	jmp    803d53 <free_block+0x18c>
  803d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d56:	c1 e2 04             	shl    $0x4,%edx
  803d59:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d5f:	89 02                	mov    %eax,(%edx)
  803d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d64:	c1 e0 04             	shl    $0x4,%eax
  803d67:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d6c:	8b 00                	mov    (%eax),%eax
  803d6e:	85 c0                	test   %eax,%eax
  803d70:	75 a5                	jne    803d17 <free_block+0x150>
  803d72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d76:	75 9f                	jne    803d17 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7b:	c1 e0 04             	shl    $0x4,%eax
  803d7e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d83:	8b 00                	mov    (%eax),%eax
  803d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d88:	e9 cc 00 00 00       	jmp    803e59 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d90:	8b 00                	mov    (%eax),%eax
  803d92:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d98:	83 ec 0c             	sub    $0xc,%esp
  803d9b:	50                   	push   %eax
  803d9c:	e8 32 f7 ff ff       	call   8034d3 <to_page_info>
  803da1:	83 c4 10             	add    $0x10,%esp
  803da4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803da7:	0f 85 a6 00 00 00    	jne    803e53 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803dad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803db1:	75 17                	jne    803dca <free_block+0x203>
  803db3:	83 ec 04             	sub    $0x4,%esp
  803db6:	68 3d 4b 80 00       	push   $0x804b3d
  803dbb:	68 b5 00 00 00       	push   $0xb5
  803dc0:	68 a3 4a 80 00       	push   $0x804aa3
  803dc5:	e8 d3 c6 ff ff       	call   80049d <_panic>
  803dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dcd:	8b 00                	mov    (%eax),%eax
  803dcf:	85 c0                	test   %eax,%eax
  803dd1:	74 10                	je     803de3 <free_block+0x21c>
  803dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd6:	8b 00                	mov    (%eax),%eax
  803dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ddb:	8b 52 04             	mov    0x4(%edx),%edx
  803dde:	89 50 04             	mov    %edx,0x4(%eax)
  803de1:	eb 14                	jmp    803df7 <free_block+0x230>
  803de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de6:	8b 40 04             	mov    0x4(%eax),%eax
  803de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dec:	c1 e2 04             	shl    $0x4,%edx
  803def:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803df5:	89 02                	mov    %eax,(%edx)
  803df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfa:	8b 40 04             	mov    0x4(%eax),%eax
  803dfd:	85 c0                	test   %eax,%eax
  803dff:	74 0f                	je     803e10 <free_block+0x249>
  803e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e04:	8b 40 04             	mov    0x4(%eax),%eax
  803e07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e0a:	8b 12                	mov    (%edx),%edx
  803e0c:	89 10                	mov    %edx,(%eax)
  803e0e:	eb 13                	jmp    803e23 <free_block+0x25c>
  803e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e13:	8b 00                	mov    (%eax),%eax
  803e15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e18:	c1 e2 04             	shl    $0x4,%edx
  803e1b:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803e21:	89 02                	mov    %eax,(%edx)
  803e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e39:	c1 e0 04             	shl    $0x4,%eax
  803e3c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e41:	8b 00                	mov    (%eax),%eax
  803e43:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e49:	c1 e0 04             	shl    $0x4,%eax
  803e4c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e51:	89 10                	mov    %edx,(%eax)
			b = next;
  803e53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e5d:	0f 85 2a ff ff ff    	jne    803d8d <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e66:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e6f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e79:	75 17                	jne    803e92 <free_block+0x2cb>
  803e7b:	83 ec 04             	sub    $0x4,%esp
  803e7e:	68 ac 4b 80 00       	push   $0x804bac
  803e83:	68 bc 00 00 00       	push   $0xbc
  803e88:	68 a3 4a 80 00       	push   $0x804aa3
  803e8d:	e8 0b c6 ff ff       	call   80049d <_panic>
  803e92:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e9b:	89 10                	mov    %edx,(%eax)
  803e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ea0:	8b 00                	mov    (%eax),%eax
  803ea2:	85 c0                	test   %eax,%eax
  803ea4:	74 0d                	je     803eb3 <free_block+0x2ec>
  803ea6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803eab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803eae:	89 50 04             	mov    %edx,0x4(%eax)
  803eb1:	eb 08                	jmp    803ebb <free_block+0x2f4>
  803eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eb6:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ebe:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803ec3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ecd:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803ed2:	40                   	inc    %eax
  803ed3:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803ed8:	83 ec 0c             	sub    $0xc,%esp
  803edb:	ff 75 ec             	pushl  -0x14(%ebp)
  803ede:	e8 7e f5 ff ff       	call   803461 <to_page_va>
  803ee3:	83 c4 10             	add    $0x10,%esp
  803ee6:	83 ec 0c             	sub    $0xc,%esp
  803ee9:	50                   	push   %eax
  803eea:	e8 fe d7 ff ff       	call   8016ed <return_page>
  803eef:	83 c4 10             	add    $0x10,%esp
	}
}
  803ef2:	90                   	nop
  803ef3:	c9                   	leave  
  803ef4:	c3                   	ret    
  803ef5:	66 90                	xchg   %ax,%ax
  803ef7:	90                   	nop

00803ef8 <__udivdi3>:
  803ef8:	55                   	push   %ebp
  803ef9:	57                   	push   %edi
  803efa:	56                   	push   %esi
  803efb:	53                   	push   %ebx
  803efc:	83 ec 1c             	sub    $0x1c,%esp
  803eff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f0f:	89 ca                	mov    %ecx,%edx
  803f11:	89 f8                	mov    %edi,%eax
  803f13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f17:	85 f6                	test   %esi,%esi
  803f19:	75 2d                	jne    803f48 <__udivdi3+0x50>
  803f1b:	39 cf                	cmp    %ecx,%edi
  803f1d:	77 65                	ja     803f84 <__udivdi3+0x8c>
  803f1f:	89 fd                	mov    %edi,%ebp
  803f21:	85 ff                	test   %edi,%edi
  803f23:	75 0b                	jne    803f30 <__udivdi3+0x38>
  803f25:	b8 01 00 00 00       	mov    $0x1,%eax
  803f2a:	31 d2                	xor    %edx,%edx
  803f2c:	f7 f7                	div    %edi
  803f2e:	89 c5                	mov    %eax,%ebp
  803f30:	31 d2                	xor    %edx,%edx
  803f32:	89 c8                	mov    %ecx,%eax
  803f34:	f7 f5                	div    %ebp
  803f36:	89 c1                	mov    %eax,%ecx
  803f38:	89 d8                	mov    %ebx,%eax
  803f3a:	f7 f5                	div    %ebp
  803f3c:	89 cf                	mov    %ecx,%edi
  803f3e:	89 fa                	mov    %edi,%edx
  803f40:	83 c4 1c             	add    $0x1c,%esp
  803f43:	5b                   	pop    %ebx
  803f44:	5e                   	pop    %esi
  803f45:	5f                   	pop    %edi
  803f46:	5d                   	pop    %ebp
  803f47:	c3                   	ret    
  803f48:	39 ce                	cmp    %ecx,%esi
  803f4a:	77 28                	ja     803f74 <__udivdi3+0x7c>
  803f4c:	0f bd fe             	bsr    %esi,%edi
  803f4f:	83 f7 1f             	xor    $0x1f,%edi
  803f52:	75 40                	jne    803f94 <__udivdi3+0x9c>
  803f54:	39 ce                	cmp    %ecx,%esi
  803f56:	72 0a                	jb     803f62 <__udivdi3+0x6a>
  803f58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f5c:	0f 87 9e 00 00 00    	ja     804000 <__udivdi3+0x108>
  803f62:	b8 01 00 00 00       	mov    $0x1,%eax
  803f67:	89 fa                	mov    %edi,%edx
  803f69:	83 c4 1c             	add    $0x1c,%esp
  803f6c:	5b                   	pop    %ebx
  803f6d:	5e                   	pop    %esi
  803f6e:	5f                   	pop    %edi
  803f6f:	5d                   	pop    %ebp
  803f70:	c3                   	ret    
  803f71:	8d 76 00             	lea    0x0(%esi),%esi
  803f74:	31 ff                	xor    %edi,%edi
  803f76:	31 c0                	xor    %eax,%eax
  803f78:	89 fa                	mov    %edi,%edx
  803f7a:	83 c4 1c             	add    $0x1c,%esp
  803f7d:	5b                   	pop    %ebx
  803f7e:	5e                   	pop    %esi
  803f7f:	5f                   	pop    %edi
  803f80:	5d                   	pop    %ebp
  803f81:	c3                   	ret    
  803f82:	66 90                	xchg   %ax,%ax
  803f84:	89 d8                	mov    %ebx,%eax
  803f86:	f7 f7                	div    %edi
  803f88:	31 ff                	xor    %edi,%edi
  803f8a:	89 fa                	mov    %edi,%edx
  803f8c:	83 c4 1c             	add    $0x1c,%esp
  803f8f:	5b                   	pop    %ebx
  803f90:	5e                   	pop    %esi
  803f91:	5f                   	pop    %edi
  803f92:	5d                   	pop    %ebp
  803f93:	c3                   	ret    
  803f94:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f99:	89 eb                	mov    %ebp,%ebx
  803f9b:	29 fb                	sub    %edi,%ebx
  803f9d:	89 f9                	mov    %edi,%ecx
  803f9f:	d3 e6                	shl    %cl,%esi
  803fa1:	89 c5                	mov    %eax,%ebp
  803fa3:	88 d9                	mov    %bl,%cl
  803fa5:	d3 ed                	shr    %cl,%ebp
  803fa7:	89 e9                	mov    %ebp,%ecx
  803fa9:	09 f1                	or     %esi,%ecx
  803fab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803faf:	89 f9                	mov    %edi,%ecx
  803fb1:	d3 e0                	shl    %cl,%eax
  803fb3:	89 c5                	mov    %eax,%ebp
  803fb5:	89 d6                	mov    %edx,%esi
  803fb7:	88 d9                	mov    %bl,%cl
  803fb9:	d3 ee                	shr    %cl,%esi
  803fbb:	89 f9                	mov    %edi,%ecx
  803fbd:	d3 e2                	shl    %cl,%edx
  803fbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fc3:	88 d9                	mov    %bl,%cl
  803fc5:	d3 e8                	shr    %cl,%eax
  803fc7:	09 c2                	or     %eax,%edx
  803fc9:	89 d0                	mov    %edx,%eax
  803fcb:	89 f2                	mov    %esi,%edx
  803fcd:	f7 74 24 0c          	divl   0xc(%esp)
  803fd1:	89 d6                	mov    %edx,%esi
  803fd3:	89 c3                	mov    %eax,%ebx
  803fd5:	f7 e5                	mul    %ebp
  803fd7:	39 d6                	cmp    %edx,%esi
  803fd9:	72 19                	jb     803ff4 <__udivdi3+0xfc>
  803fdb:	74 0b                	je     803fe8 <__udivdi3+0xf0>
  803fdd:	89 d8                	mov    %ebx,%eax
  803fdf:	31 ff                	xor    %edi,%edi
  803fe1:	e9 58 ff ff ff       	jmp    803f3e <__udivdi3+0x46>
  803fe6:	66 90                	xchg   %ax,%ax
  803fe8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803fec:	89 f9                	mov    %edi,%ecx
  803fee:	d3 e2                	shl    %cl,%edx
  803ff0:	39 c2                	cmp    %eax,%edx
  803ff2:	73 e9                	jae    803fdd <__udivdi3+0xe5>
  803ff4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ff7:	31 ff                	xor    %edi,%edi
  803ff9:	e9 40 ff ff ff       	jmp    803f3e <__udivdi3+0x46>
  803ffe:	66 90                	xchg   %ax,%ax
  804000:	31 c0                	xor    %eax,%eax
  804002:	e9 37 ff ff ff       	jmp    803f3e <__udivdi3+0x46>
  804007:	90                   	nop

00804008 <__umoddi3>:
  804008:	55                   	push   %ebp
  804009:	57                   	push   %edi
  80400a:	56                   	push   %esi
  80400b:	53                   	push   %ebx
  80400c:	83 ec 1c             	sub    $0x1c,%esp
  80400f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804013:	8b 74 24 34          	mov    0x34(%esp),%esi
  804017:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80401b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80401f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804023:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804027:	89 f3                	mov    %esi,%ebx
  804029:	89 fa                	mov    %edi,%edx
  80402b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80402f:	89 34 24             	mov    %esi,(%esp)
  804032:	85 c0                	test   %eax,%eax
  804034:	75 1a                	jne    804050 <__umoddi3+0x48>
  804036:	39 f7                	cmp    %esi,%edi
  804038:	0f 86 a2 00 00 00    	jbe    8040e0 <__umoddi3+0xd8>
  80403e:	89 c8                	mov    %ecx,%eax
  804040:	89 f2                	mov    %esi,%edx
  804042:	f7 f7                	div    %edi
  804044:	89 d0                	mov    %edx,%eax
  804046:	31 d2                	xor    %edx,%edx
  804048:	83 c4 1c             	add    $0x1c,%esp
  80404b:	5b                   	pop    %ebx
  80404c:	5e                   	pop    %esi
  80404d:	5f                   	pop    %edi
  80404e:	5d                   	pop    %ebp
  80404f:	c3                   	ret    
  804050:	39 f0                	cmp    %esi,%eax
  804052:	0f 87 ac 00 00 00    	ja     804104 <__umoddi3+0xfc>
  804058:	0f bd e8             	bsr    %eax,%ebp
  80405b:	83 f5 1f             	xor    $0x1f,%ebp
  80405e:	0f 84 ac 00 00 00    	je     804110 <__umoddi3+0x108>
  804064:	bf 20 00 00 00       	mov    $0x20,%edi
  804069:	29 ef                	sub    %ebp,%edi
  80406b:	89 fe                	mov    %edi,%esi
  80406d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804071:	89 e9                	mov    %ebp,%ecx
  804073:	d3 e0                	shl    %cl,%eax
  804075:	89 d7                	mov    %edx,%edi
  804077:	89 f1                	mov    %esi,%ecx
  804079:	d3 ef                	shr    %cl,%edi
  80407b:	09 c7                	or     %eax,%edi
  80407d:	89 e9                	mov    %ebp,%ecx
  80407f:	d3 e2                	shl    %cl,%edx
  804081:	89 14 24             	mov    %edx,(%esp)
  804084:	89 d8                	mov    %ebx,%eax
  804086:	d3 e0                	shl    %cl,%eax
  804088:	89 c2                	mov    %eax,%edx
  80408a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80408e:	d3 e0                	shl    %cl,%eax
  804090:	89 44 24 04          	mov    %eax,0x4(%esp)
  804094:	8b 44 24 08          	mov    0x8(%esp),%eax
  804098:	89 f1                	mov    %esi,%ecx
  80409a:	d3 e8                	shr    %cl,%eax
  80409c:	09 d0                	or     %edx,%eax
  80409e:	d3 eb                	shr    %cl,%ebx
  8040a0:	89 da                	mov    %ebx,%edx
  8040a2:	f7 f7                	div    %edi
  8040a4:	89 d3                	mov    %edx,%ebx
  8040a6:	f7 24 24             	mull   (%esp)
  8040a9:	89 c6                	mov    %eax,%esi
  8040ab:	89 d1                	mov    %edx,%ecx
  8040ad:	39 d3                	cmp    %edx,%ebx
  8040af:	0f 82 87 00 00 00    	jb     80413c <__umoddi3+0x134>
  8040b5:	0f 84 91 00 00 00    	je     80414c <__umoddi3+0x144>
  8040bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040bf:	29 f2                	sub    %esi,%edx
  8040c1:	19 cb                	sbb    %ecx,%ebx
  8040c3:	89 d8                	mov    %ebx,%eax
  8040c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040c9:	d3 e0                	shl    %cl,%eax
  8040cb:	89 e9                	mov    %ebp,%ecx
  8040cd:	d3 ea                	shr    %cl,%edx
  8040cf:	09 d0                	or     %edx,%eax
  8040d1:	89 e9                	mov    %ebp,%ecx
  8040d3:	d3 eb                	shr    %cl,%ebx
  8040d5:	89 da                	mov    %ebx,%edx
  8040d7:	83 c4 1c             	add    $0x1c,%esp
  8040da:	5b                   	pop    %ebx
  8040db:	5e                   	pop    %esi
  8040dc:	5f                   	pop    %edi
  8040dd:	5d                   	pop    %ebp
  8040de:	c3                   	ret    
  8040df:	90                   	nop
  8040e0:	89 fd                	mov    %edi,%ebp
  8040e2:	85 ff                	test   %edi,%edi
  8040e4:	75 0b                	jne    8040f1 <__umoddi3+0xe9>
  8040e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8040eb:	31 d2                	xor    %edx,%edx
  8040ed:	f7 f7                	div    %edi
  8040ef:	89 c5                	mov    %eax,%ebp
  8040f1:	89 f0                	mov    %esi,%eax
  8040f3:	31 d2                	xor    %edx,%edx
  8040f5:	f7 f5                	div    %ebp
  8040f7:	89 c8                	mov    %ecx,%eax
  8040f9:	f7 f5                	div    %ebp
  8040fb:	89 d0                	mov    %edx,%eax
  8040fd:	e9 44 ff ff ff       	jmp    804046 <__umoddi3+0x3e>
  804102:	66 90                	xchg   %ax,%ax
  804104:	89 c8                	mov    %ecx,%eax
  804106:	89 f2                	mov    %esi,%edx
  804108:	83 c4 1c             	add    $0x1c,%esp
  80410b:	5b                   	pop    %ebx
  80410c:	5e                   	pop    %esi
  80410d:	5f                   	pop    %edi
  80410e:	5d                   	pop    %ebp
  80410f:	c3                   	ret    
  804110:	3b 04 24             	cmp    (%esp),%eax
  804113:	72 06                	jb     80411b <__umoddi3+0x113>
  804115:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804119:	77 0f                	ja     80412a <__umoddi3+0x122>
  80411b:	89 f2                	mov    %esi,%edx
  80411d:	29 f9                	sub    %edi,%ecx
  80411f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804123:	89 14 24             	mov    %edx,(%esp)
  804126:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80412a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80412e:	8b 14 24             	mov    (%esp),%edx
  804131:	83 c4 1c             	add    $0x1c,%esp
  804134:	5b                   	pop    %ebx
  804135:	5e                   	pop    %esi
  804136:	5f                   	pop    %edi
  804137:	5d                   	pop    %ebp
  804138:	c3                   	ret    
  804139:	8d 76 00             	lea    0x0(%esi),%esi
  80413c:	2b 04 24             	sub    (%esp),%eax
  80413f:	19 fa                	sbb    %edi,%edx
  804141:	89 d1                	mov    %edx,%ecx
  804143:	89 c6                	mov    %eax,%esi
  804145:	e9 71 ff ff ff       	jmp    8040bb <__umoddi3+0xb3>
  80414a:	66 90                	xchg   %ax,%ax
  80414c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804150:	72 ea                	jb     80413c <__umoddi3+0x134>
  804152:	89 d9                	mov    %ebx,%ecx
  804154:	e9 62 ff ff ff       	jmp    8040bb <__umoddi3+0xb3>
