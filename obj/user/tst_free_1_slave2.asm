
obj/user/tst_free_1_slave2:     file format elf32-i386


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
  800031:	e8 ad 02 00 00       	call   8002e3 <libmain>
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
  800065:	6a 12                	push   $0x12
  800067:	68 7c 41 80 00       	push   $0x80417c
  80006c:	e8 22 04 00 00       	call   800493 <_panic>
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
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
  8000bc:	e8 0a 2f 00 00       	call   802fcb <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 4d 2f 00 00       	call   803016 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 46 16 00 00       	call   801723 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 98 41 80 00       	push   $0x804198
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 7c 41 80 00       	push   $0x80417c
  800100:	e8 8e 03 00 00       	call   800493 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 0c 2f 00 00       	call   803016 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 c8 41 80 00       	push   $0x8041c8
  800117:	6a 32                	push   $0x32
  800119:	68 7c 41 80 00       	push   $0x80417c
  80011e:	e8 70 03 00 00       	call   800493 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 a3 2e 00 00       	call   802fcb <sys_calculate_free_frames>
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
  80015f:	e8 67 2e 00 00       	call   802fcb <sys_calculate_free_frames>
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
  800181:	6a 3c                	push   $0x3c
  800183:	68 7c 41 80 00       	push   $0x80417c
  800188:	e8 06 03 00 00       	call   800493 <_panic>

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
  8001c7:	e8 c1 31 00 00       	call   80338d <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 74 42 80 00       	push   $0x804274
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 7c 41 80 00       	push   $0x80417c
  8001e7:	e8 a7 02 00 00       	call   800493 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 da 2d 00 00       	call   802fcb <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 1d 2e 00 00       	call   803016 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 78 18 00 00       	call   801a83 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 03 2e 00 00       	call   803016 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 94 42 80 00       	push   $0x804294
  800220:	6a 4d                	push   $0x4d
  800222:	68 7c 41 80 00       	push   $0x80417c
  800227:	e8 67 02 00 00       	call   800493 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 9a 2d 00 00       	call   802fcb <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 d0 42 80 00       	push   $0x8042d0
  800247:	6a 4e                	push   $0x4e
  800249:	68 7c 41 80 00       	push   $0x80417c
  80024e:	e8 40 02 00 00       	call   800493 <_panic>
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
  80028d:	e8 fb 30 00 00       	call   80338d <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 1c 43 80 00       	push   $0x80431c
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 7c 41 80 00       	push   $0x80417c
  8002ad:	e8 e1 01 00 00       	call   800493 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 1b 30 00 00       	call   8032d2 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 2f 30 00 00       	call   8032ec <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 03 30 00 00       	call   8032d2 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 40 43 80 00       	push   $0x804340
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 7c 41 80 00       	push   $0x80417c
  8002de:	e8 b0 01 00 00       	call   800493 <_panic>

008002e3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
  8002e9:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ec:	e8 a3 2e 00 00       	call   803194 <sys_getenvindex>
  8002f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002f7:	89 d0                	mov    %edx,%eax
  8002f9:	c1 e0 03             	shl    $0x3,%eax
  8002fc:	01 d0                	add    %edx,%eax
  8002fe:	c1 e0 02             	shl    $0x2,%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030a:	01 d0                	add    %edx,%eax
  80030c:	c1 e0 03             	shl    $0x3,%eax
  80030f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800314:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800319:	a1 20 50 80 00       	mov    0x805020,%eax
  80031e:	8a 40 20             	mov    0x20(%eax),%al
  800321:	84 c0                	test   %al,%al
  800323:	74 0d                	je     800332 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800325:	a1 20 50 80 00       	mov    0x805020,%eax
  80032a:	83 c0 20             	add    $0x20,%eax
  80032d:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800332:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800336:	7e 0a                	jle    800342 <libmain+0x5f>
		binaryname = argv[0];
  800338:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033b:	8b 00                	mov    (%eax),%eax
  80033d:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	ff 75 0c             	pushl  0xc(%ebp)
  800348:	ff 75 08             	pushl  0x8(%ebp)
  80034b:	e8 e8 fc ff ff       	call   800038 <_main>
  800350:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800353:	a1 00 50 80 00       	mov    0x805000,%eax
  800358:	85 c0                	test   %eax,%eax
  80035a:	0f 84 01 01 00 00    	je     800461 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800360:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800366:	bb 84 44 80 00       	mov    $0x804484,%ebx
  80036b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800370:	89 c7                	mov    %eax,%edi
  800372:	89 de                	mov    %ebx,%esi
  800374:	89 d1                	mov    %edx,%ecx
  800376:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800378:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80037b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800380:	b0 00                	mov    $0x0,%al
  800382:	89 d7                	mov    %edx,%edi
  800384:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800386:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80038d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	50                   	push   %eax
  800394:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80039a:	50                   	push   %eax
  80039b:	e8 2a 30 00 00       	call   8033ca <sys_utilities>
  8003a0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003a3:	e8 73 2b 00 00       	call   802f1b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 a4 43 80 00       	push   $0x8043a4
  8003b0:	e8 ac 03 00 00       	call   800761 <cprintf>
  8003b5:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	74 18                	je     8003d7 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003bf:	e8 24 30 00 00       	call   8033e8 <sys_get_optimal_num_faults>
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	50                   	push   %eax
  8003c8:	68 cc 43 80 00       	push   $0x8043cc
  8003cd:	e8 8f 03 00 00       	call   800761 <cprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
  8003d5:	eb 59                	jmp    800430 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8003dc:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8003e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	52                   	push   %edx
  8003f1:	50                   	push   %eax
  8003f2:	68 f0 43 80 00       	push   $0x8043f0
  8003f7:	e8 65 03 00 00       	call   800761 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800404:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80040a:	a1 20 50 80 00       	mov    0x805020,%eax
  80040f:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800415:	a1 20 50 80 00       	mov    0x805020,%eax
  80041a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800420:	51                   	push   %ecx
  800421:	52                   	push   %edx
  800422:	50                   	push   %eax
  800423:	68 18 44 80 00       	push   $0x804418
  800428:	e8 34 03 00 00       	call   800761 <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800430:	a1 20 50 80 00       	mov    0x805020,%eax
  800435:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	50                   	push   %eax
  80043f:	68 70 44 80 00       	push   $0x804470
  800444:	e8 18 03 00 00       	call   800761 <cprintf>
  800449:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	68 a4 43 80 00       	push   $0x8043a4
  800454:	e8 08 03 00 00       	call   800761 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80045c:	e8 d4 2a 00 00       	call   802f35 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800461:	e8 1f 00 00 00       	call   800485 <exit>
}
  800466:	90                   	nop
  800467:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046a:	5b                   	pop    %ebx
  80046b:	5e                   	pop    %esi
  80046c:	5f                   	pop    %edi
  80046d:	5d                   	pop    %ebp
  80046e:	c3                   	ret    

0080046f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	6a 00                	push   $0x0
  80047a:	e8 e1 2c 00 00       	call   803160 <sys_destroy_env>
  80047f:	83 c4 10             	add    $0x10,%esp
}
  800482:	90                   	nop
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <exit>:

void
exit(void)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048b:	e8 36 2d 00 00       	call   8031c6 <sys_exit_env>
}
  800490:	90                   	nop
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800499:	8d 45 10             	lea    0x10(%ebp),%eax
  80049c:	83 c0 04             	add    $0x4,%eax
  80049f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a2:	a1 38 51 83 00       	mov    0x835138,%eax
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	74 16                	je     8004c1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ab:	a1 38 51 83 00       	mov    0x835138,%eax
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	50                   	push   %eax
  8004b4:	68 e8 44 80 00       	push   $0x8044e8
  8004b9:	e8 a3 02 00 00       	call   800761 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004c1:	a1 04 50 80 00       	mov    0x805004,%eax
  8004c6:	83 ec 0c             	sub    $0xc,%esp
  8004c9:	ff 75 0c             	pushl  0xc(%ebp)
  8004cc:	ff 75 08             	pushl  0x8(%ebp)
  8004cf:	50                   	push   %eax
  8004d0:	68 f0 44 80 00       	push   $0x8044f0
  8004d5:	6a 74                	push   $0x74
  8004d7:	e8 b2 02 00 00       	call   80078e <cprintf_colored>
  8004dc:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004df:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e8:	50                   	push   %eax
  8004e9:	e8 04 02 00 00       	call   8006f2 <vcprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	6a 00                	push   $0x0
  8004f6:	68 18 45 80 00       	push   $0x804518
  8004fb:	e8 f2 01 00 00       	call   8006f2 <vcprintf>
  800500:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800503:	e8 7d ff ff ff       	call   800485 <exit>

	// should not return here
	while (1) ;
  800508:	eb fe                	jmp    800508 <_panic+0x75>

0080050a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050a:	55                   	push   %ebp
  80050b:	89 e5                	mov    %esp,%ebp
  80050d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800510:	a1 20 50 80 00       	mov    0x805020,%eax
  800515:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	39 c2                	cmp    %eax,%edx
  800520:	74 14                	je     800536 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	68 1c 45 80 00       	push   $0x80451c
  80052a:	6a 26                	push   $0x26
  80052c:	68 68 45 80 00       	push   $0x804568
  800531:	e8 5d ff ff ff       	call   800493 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800544:	e9 c5 00 00 00       	jmp    80060e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	01 d0                	add    %edx,%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	85 c0                	test   %eax,%eax
  80055c:	75 08                	jne    800566 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80055e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800561:	e9 a5 00 00 00       	jmp    80060b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800566:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800574:	eb 69                	jmp    8005df <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800576:	a1 20 50 80 00       	mov    0x805020,%eax
  80057b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800581:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800584:	89 d0                	mov    %edx,%eax
  800586:	01 c0                	add    %eax,%eax
  800588:	01 d0                	add    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 c8                	add    %ecx,%eax
  80058f:	8a 40 04             	mov    0x4(%eax),%al
  800592:	84 c0                	test   %al,%al
  800594:	75 46                	jne    8005dc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800596:	a1 20 50 80 00       	mov    0x805020,%eax
  80059b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	01 c8                	add    %ecx,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cf:	39 c2                	cmp    %eax,%edx
  8005d1:	75 09                	jne    8005dc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005da:	eb 15                	jmp    8005f1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005dc:	ff 45 e8             	incl   -0x18(%ebp)
  8005df:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ed:	39 c2                	cmp    %eax,%edx
  8005ef:	77 85                	ja     800576 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f5:	75 14                	jne    80060b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005f7:	83 ec 04             	sub    $0x4,%esp
  8005fa:	68 74 45 80 00       	push   $0x804574
  8005ff:	6a 3a                	push   $0x3a
  800601:	68 68 45 80 00       	push   $0x804568
  800606:	e8 88 fe ff ff       	call   800493 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060b:	ff 45 f0             	incl   -0x10(%ebp)
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800614:	0f 8c 2f ff ff ff    	jl     800549 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80061a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800621:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800628:	eb 26                	jmp    800650 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80062a:	a1 20 50 80 00       	mov    0x805020,%eax
  80062f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800635:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800638:	89 d0                	mov    %edx,%eax
  80063a:	01 c0                	add    %eax,%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	c1 e0 03             	shl    $0x3,%eax
  800641:	01 c8                	add    %ecx,%eax
  800643:	8a 40 04             	mov    0x4(%eax),%al
  800646:	3c 01                	cmp    $0x1,%al
  800648:	75 03                	jne    80064d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80064a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80064d:	ff 45 e0             	incl   -0x20(%ebp)
  800650:	a1 20 50 80 00       	mov    0x805020,%eax
  800655:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80065b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065e:	39 c2                	cmp    %eax,%edx
  800660:	77 c8                	ja     80062a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800665:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800668:	74 14                	je     80067e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80066a:	83 ec 04             	sub    $0x4,%esp
  80066d:	68 c8 45 80 00       	push   $0x8045c8
  800672:	6a 44                	push   $0x44
  800674:	68 68 45 80 00       	push   $0x804568
  800679:	e8 15 fe ff ff       	call   800493 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80067e:	90                   	nop
  80067f:	c9                   	leave  
  800680:	c3                   	ret    

00800681 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800681:	55                   	push   %ebp
  800682:	89 e5                	mov    %esp,%ebp
  800684:	53                   	push   %ebx
  800685:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 48 01             	lea    0x1(%eax),%ecx
  800690:	8b 55 0c             	mov    0xc(%ebp),%edx
  800693:	89 0a                	mov    %ecx,(%edx)
  800695:	8b 55 08             	mov    0x8(%ebp),%edx
  800698:	88 d1                	mov    %dl,%cl
  80069a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ab:	75 30                	jne    8006dd <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006ad:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006b3:	a0 64 d0 81 00       	mov    0x81d064,%al
  8006b8:	0f b6 c0             	movzbl %al,%eax
  8006bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006be:	8b 09                	mov    (%ecx),%ecx
  8006c0:	89 cb                	mov    %ecx,%ebx
  8006c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c5:	83 c1 08             	add    $0x8,%ecx
  8006c8:	52                   	push   %edx
  8006c9:	50                   	push   %eax
  8006ca:	53                   	push   %ebx
  8006cb:	51                   	push   %ecx
  8006cc:	e8 06 28 00 00       	call   802ed7 <sys_cputs>
  8006d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	8b 40 04             	mov    0x4(%eax),%eax
  8006e3:	8d 50 01             	lea    0x1(%eax),%edx
  8006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ec:	90                   	nop
  8006ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f0:	c9                   	leave  
  8006f1:	c3                   	ret    

008006f2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800702:	00 00 00 
	b.cnt = 0;
  800705:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	ff 75 08             	pushl  0x8(%ebp)
  800715:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071b:	50                   	push   %eax
  80071c:	68 81 06 80 00       	push   $0x800681
  800721:	e8 5a 02 00 00       	call   800980 <vprintfmt>
  800726:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800729:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80072f:	a0 64 d0 81 00       	mov    0x81d064,%al
  800734:	0f b6 c0             	movzbl %al,%eax
  800737:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	51                   	push   %ecx
  800740:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800746:	83 c0 08             	add    $0x8,%eax
  800749:	50                   	push   %eax
  80074a:	e8 88 27 00 00       	call   802ed7 <sys_cputs>
  80074f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800752:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800759:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800767:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  80076e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 f4             	pushl  -0xc(%ebp)
  80077d:	50                   	push   %eax
  80077e:	e8 6f ff ff ff       	call   8006f2 <vcprintf>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078c:	c9                   	leave  
  80078d:	c3                   	ret    

0080078e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800794:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	c1 e0 08             	shl    $0x8,%eax
  8007a1:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  8007a6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a9:	83 c0 04             	add    $0x4,%eax
  8007ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	e8 34 ff ff ff       	call   8006f2 <vcprintf>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007c4:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  8007cb:	07 00 00 

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007d9:	e8 3d 27 00 00       	call   802f1b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 ff fe ff ff       	call   8006f2 <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007f9:	e8 37 27 00 00       	call   802f35 <sys_unlock_cons>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 a4 36 00 00       	call   803eec <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 64 37 00 00       	call   803ffc <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 34 48 80 00       	add    $0x804834,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 c1 03 00 00    	je     800d53 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 5b             	cmp    $0x5b,%eax
  8009e8:	0f 87 3d 03 00 00    	ja     800d2b <vprintfmt+0x3ab>
  8009ee:	8b 04 85 58 48 80 00 	mov    0x804858(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 9b 02 00 00       	jmp    800d4e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d a0 46 80 00 	mov    0x8046a0(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 45 48 80 00       	push   $0x804845
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 70 02 00 00       	call   800d5b <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 5b 02 00 00       	jmp    800d4e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 4e 48 80 00       	push   $0x80484e
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 57 02 00 00       	call   800d5b <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 42 02 00 00       	jmp    800d4e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be 51 48 80 00       	mov    $0x804851,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 1e 03 00 00       	call   800e5d <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 78 01 00 00       	jmp    800d4e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 ce 00 00 00       	jmp    800d4e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 46                	jmp    800d4e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 35                	jmp    800d4e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d19:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800d20:	eb 2c                	jmp    800d4e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d22:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800d29:	eb 23                	jmp    800d4e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2b:	83 ec 08             	sub    $0x8,%esp
  800d2e:	ff 75 0c             	pushl  0xc(%ebp)
  800d31:	6a 25                	push   $0x25
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	ff d0                	call   *%eax
  800d38:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3b:	ff 4d 10             	decl   0x10(%ebp)
  800d3e:	eb 03                	jmp    800d43 <vprintfmt+0x3c3>
  800d40:	ff 4d 10             	decl   0x10(%ebp)
  800d43:	8b 45 10             	mov    0x10(%ebp),%eax
  800d46:	48                   	dec    %eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	3c 25                	cmp    $0x25,%al
  800d4b:	75 f3                	jne    800d40 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d4d:	90                   	nop
		}
	}
  800d4e:	e9 35 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d53:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d61:	8d 45 10             	lea    0x10(%ebp),%eax
  800d64:	83 c0 04             	add    $0x4,%eax
  800d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d70:	50                   	push   %eax
  800d71:	ff 75 0c             	pushl  0xc(%ebp)
  800d74:	ff 75 08             	pushl  0x8(%ebp)
  800d77:	e8 04 fc ff ff       	call   800980 <vprintfmt>
  800d7c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d7f:	90                   	nop
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8b 40 08             	mov    0x8(%eax),%eax
  800d8b:	8d 50 01             	lea    0x1(%eax),%edx
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8b 10                	mov    (%eax),%edx
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 40 04             	mov    0x4(%eax),%eax
  800d9f:	39 c2                	cmp    %eax,%edx
  800da1:	73 12                	jae    800db5 <sprintputch+0x33>
		*b->buf++ = ch;
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8b 00                	mov    (%eax),%eax
  800da8:	8d 48 01             	lea    0x1(%eax),%ecx
  800dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dae:	89 0a                	mov    %ecx,(%edx)
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	88 10                	mov    %dl,(%eax)
}
  800db5:	90                   	nop
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	01 d0                	add    %edx,%eax
  800dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ddd:	74 06                	je     800de5 <vsnprintf+0x2d>
  800ddf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de3:	7f 07                	jg     800dec <vsnprintf+0x34>
		return -E_INVAL;
  800de5:	b8 03 00 00 00       	mov    $0x3,%eax
  800dea:	eb 20                	jmp    800e0c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dec:	ff 75 14             	pushl  0x14(%ebp)
  800def:	ff 75 10             	pushl  0x10(%ebp)
  800df2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df5:	50                   	push   %eax
  800df6:	68 82 0d 80 00       	push   $0x800d82
  800dfb:	e8 80 fb ff ff       	call   800980 <vprintfmt>
  800e00:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e06:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e14:	8d 45 10             	lea    0x10(%ebp),%eax
  800e17:	83 c0 04             	add    $0x4,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e20:	ff 75 f4             	pushl  -0xc(%ebp)
  800e23:	50                   	push   %eax
  800e24:	ff 75 0c             	pushl  0xc(%ebp)
  800e27:	ff 75 08             	pushl  0x8(%ebp)
  800e2a:	e8 89 ff ff ff       	call   800db8 <vsnprintf>
  800e2f:	83 c4 10             	add    $0x10,%esp
  800e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e47:	eb 06                	jmp    800e4f <strlen+0x15>
		n++;
  800e49:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4c:	ff 45 08             	incl   0x8(%ebp)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	84 c0                	test   %al,%al
  800e56:	75 f1                	jne    800e49 <strlen+0xf>
		n++;
	return n;
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6a:	eb 09                	jmp    800e75 <strnlen+0x18>
		n++;
  800e6c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6f:	ff 45 08             	incl   0x8(%ebp)
  800e72:	ff 4d 0c             	decl   0xc(%ebp)
  800e75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e79:	74 09                	je     800e84 <strnlen+0x27>
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e8                	jne    800e6c <strnlen+0xf>
		n++;
	return n;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e95:	90                   	nop
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	84 c0                	test   %al,%al
  800eb0:	75 e4                	jne    800e96 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eca:	eb 1f                	jmp    800eeb <strncpy+0x34>
		*dst++ = *src;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8d 50 01             	lea    0x1(%eax),%edx
  800ed2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed8:	8a 12                	mov    (%edx),%dl
  800eda:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	74 03                	je     800ee8 <strncpy+0x31>
			src++;
  800ee5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee8:	ff 45 fc             	incl   -0x4(%ebp)
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef1:	72 d9                	jb     800ecc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f08:	74 30                	je     800f3a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f0a:	eb 16                	jmp    800f22 <strlcpy+0x2a>
			*dst++ = *src++;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8d 50 01             	lea    0x1(%eax),%edx
  800f12:	89 55 08             	mov    %edx,0x8(%ebp)
  800f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f22:	ff 4d 10             	decl   0x10(%ebp)
  800f25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f29:	74 09                	je     800f34 <strlcpy+0x3c>
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	84 c0                	test   %al,%al
  800f32:	75 d8                	jne    800f0c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f40:	29 c2                	sub    %eax,%edx
  800f42:	89 d0                	mov    %edx,%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f49:	eb 06                	jmp    800f51 <strcmp+0xb>
		p++, q++;
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	84 c0                	test   %al,%al
  800f58:	74 0e                	je     800f68 <strcmp+0x22>
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 10                	mov    (%eax),%dl
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	38 c2                	cmp    %al,%dl
  800f66:	74 e3                	je     800f4b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	0f b6 d0             	movzbl %al,%edx
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f b6 c0             	movzbl %al,%eax
  800f78:	29 c2                	sub    %eax,%edx
  800f7a:	89 d0                	mov    %edx,%eax
}
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f81:	eb 09                	jmp    800f8c <strncmp+0xe>
		n--, p++, q++;
  800f83:	ff 4d 10             	decl   0x10(%ebp)
  800f86:	ff 45 08             	incl   0x8(%ebp)
  800f89:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f90:	74 17                	je     800fa9 <strncmp+0x2b>
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	84 c0                	test   %al,%al
  800f99:	74 0e                	je     800fa9 <strncmp+0x2b>
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 10                	mov    (%eax),%dl
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	38 c2                	cmp    %al,%dl
  800fa7:	74 da                	je     800f83 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fad:	75 07                	jne    800fb6 <strncmp+0x38>
		return 0;
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb4:	eb 14                	jmp    800fca <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 d0             	movzbl %al,%edx
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 c0             	movzbl %al,%eax
  800fc6:	29 c2                	sub    %eax,%edx
  800fc8:	89 d0                	mov    %edx,%eax
}
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd8:	eb 12                	jmp    800fec <strchr+0x20>
		if (*s == c)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe2:	75 05                	jne    800fe9 <strchr+0x1d>
			return (char *) s;
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	eb 11                	jmp    800ffa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fe9:	ff 45 08             	incl   0x8(%ebp)
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	84 c0                	test   %al,%al
  800ff3:	75 e5                	jne    800fda <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 04             	sub    $0x4,%esp
  801002:	8b 45 0c             	mov    0xc(%ebp),%eax
  801005:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801008:	eb 0d                	jmp    801017 <strfind+0x1b>
		if (*s == c)
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801012:	74 0e                	je     801022 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801014:	ff 45 08             	incl   0x8(%ebp)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	84 c0                	test   %al,%al
  80101e:	75 ea                	jne    80100a <strfind+0xe>
  801020:	eb 01                	jmp    801023 <strfind+0x27>
		if (*s == c)
			break;
  801022:	90                   	nop
	return (char *) s;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801034:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801038:	76 63                	jbe    80109d <memset+0x75>
		uint64 data_block = c;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	99                   	cltd   
  80103e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801041:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104a:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80104e:	c1 e0 08             	shl    $0x8,%eax
  801051:	09 45 f0             	or     %eax,-0x10(%ebp)
  801054:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105d:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801061:	c1 e0 10             	shl    $0x10,%eax
  801064:	09 45 f0             	or     %eax,-0x10(%ebp)
  801067:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80106a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801070:	89 c2                	mov    %eax,%edx
  801072:	b8 00 00 00 00       	mov    $0x0,%eax
  801077:	09 45 f0             	or     %eax,-0x10(%ebp)
  80107a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80107d:	eb 18                	jmp    801097 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80107f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801082:	8d 41 08             	lea    0x8(%ecx),%eax
  801085:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108e:	89 01                	mov    %eax,(%ecx)
  801090:	89 51 04             	mov    %edx,0x4(%ecx)
  801093:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801097:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109b:	77 e2                	ja     80107f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80109d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a1:	74 23                	je     8010c6 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010a9:	eb 0e                	jmp    8010b9 <memset+0x91>
			*p8++ = (uint8)c;
  8010ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b7:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	75 e5                	jne    8010ab <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

008010cb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010dd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e1:	76 24                	jbe    801107 <memcpy+0x3c>
		while(n >= 8){
  8010e3:	eb 1c                	jmp    801101 <memcpy+0x36>
			*d64 = *s64;
  8010e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e8:	8b 50 04             	mov    0x4(%eax),%edx
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f0:	89 01                	mov    %eax,(%ecx)
  8010f2:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010f5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010f9:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010fd:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801101:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801105:	77 de                	ja     8010e5 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801107:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110b:	74 31                	je     80113e <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80110d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801110:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801119:	eb 16                	jmp    801131 <memcpy+0x66>
			*d8++ = *s8++;
  80111b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111e:	8d 50 01             	lea    0x1(%eax),%edx
  801121:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801127:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	8d 50 ff             	lea    -0x1(%eax),%edx
  801137:	89 55 10             	mov    %edx,0x10(%ebp)
  80113a:	85 c0                	test   %eax,%eax
  80113c:	75 dd                	jne    80111b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801155:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801158:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115b:	73 50                	jae    8011ad <memmove+0x6a>
  80115d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	01 d0                	add    %edx,%eax
  801165:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801168:	76 43                	jbe    8011ad <memmove+0x6a>
		s += n;
  80116a:	8b 45 10             	mov    0x10(%ebp),%eax
  80116d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801176:	eb 10                	jmp    801188 <memmove+0x45>
			*--d = *--s;
  801178:	ff 4d f8             	decl   -0x8(%ebp)
  80117b:	ff 4d fc             	decl   -0x4(%ebp)
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	8a 10                	mov    (%eax),%dl
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118e:	89 55 10             	mov    %edx,0x10(%ebp)
  801191:	85 c0                	test   %eax,%eax
  801193:	75 e3                	jne    801178 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801195:	eb 23                	jmp    8011ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	8d 50 01             	lea    0x1(%eax),%edx
  80119d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a9:	8a 12                	mov    (%edx),%dl
  8011ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 dd                	jne    801197 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011d1:	eb 2a                	jmp    8011fd <memcmp+0x3e>
		if (*s1 != *s2)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	8a 10                	mov    (%eax),%dl
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	38 c2                	cmp    %al,%dl
  8011df:	74 16                	je     8011f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f b6 d0             	movzbl %al,%edx
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	0f b6 c0             	movzbl %al,%eax
  8011f1:	29 c2                	sub    %eax,%edx
  8011f3:	89 d0                	mov    %edx,%eax
  8011f5:	eb 18                	jmp    80120f <memcmp+0x50>
		s1++, s2++;
  8011f7:	ff 45 fc             	incl   -0x4(%ebp)
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	8d 50 ff             	lea    -0x1(%eax),%edx
  801203:	89 55 10             	mov    %edx,0x10(%ebp)
  801206:	85 c0                	test   %eax,%eax
  801208:	75 c9                	jne    8011d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801217:	8b 55 08             	mov    0x8(%ebp),%edx
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	01 d0                	add    %edx,%eax
  80121f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801222:	eb 15                	jmp    801239 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	0f b6 d0             	movzbl %al,%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	0f b6 c0             	movzbl %al,%eax
  801232:	39 c2                	cmp    %eax,%edx
  801234:	74 0d                	je     801243 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123f:	72 e3                	jb     801224 <memfind+0x13>
  801241:	eb 01                	jmp    801244 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801243:	90                   	nop
	return (void *) s;
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801256:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125d:	eb 03                	jmp    801262 <strtol+0x19>
		s++;
  80125f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	3c 20                	cmp    $0x20,%al
  801269:	74 f4                	je     80125f <strtol+0x16>
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 09                	cmp    $0x9,%al
  801272:	74 eb                	je     80125f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 2b                	cmp    $0x2b,%al
  80127b:	75 05                	jne    801282 <strtol+0x39>
		s++;
  80127d:	ff 45 08             	incl   0x8(%ebp)
  801280:	eb 13                	jmp    801295 <strtol+0x4c>
	else if (*s == '-')
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 2d                	cmp    $0x2d,%al
  801289:	75 0a                	jne    801295 <strtol+0x4c>
		s++, neg = 1;
  80128b:	ff 45 08             	incl   0x8(%ebp)
  80128e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801299:	74 06                	je     8012a1 <strtol+0x58>
  80129b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129f:	75 20                	jne    8012c1 <strtol+0x78>
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 30                	cmp    $0x30,%al
  8012a8:	75 17                	jne    8012c1 <strtol+0x78>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	40                   	inc    %eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 78                	cmp    $0x78,%al
  8012b2:	75 0d                	jne    8012c1 <strtol+0x78>
		s += 2, base = 16;
  8012b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bf:	eb 28                	jmp    8012e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c5:	75 15                	jne    8012dc <strtol+0x93>
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3c 30                	cmp    $0x30,%al
  8012ce:	75 0c                	jne    8012dc <strtol+0x93>
		s++, base = 8;
  8012d0:	ff 45 08             	incl   0x8(%ebp)
  8012d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012da:	eb 0d                	jmp    8012e9 <strtol+0xa0>
	else if (base == 0)
  8012dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e0:	75 07                	jne    8012e9 <strtol+0xa0>
		base = 10;
  8012e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	3c 2f                	cmp    $0x2f,%al
  8012f0:	7e 19                	jle    80130b <strtol+0xc2>
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 39                	cmp    $0x39,%al
  8012f9:	7f 10                	jg     80130b <strtol+0xc2>
			dig = *s - '0';
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	0f be c0             	movsbl %al,%eax
  801303:	83 e8 30             	sub    $0x30,%eax
  801306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801309:	eb 42                	jmp    80134d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	3c 60                	cmp    $0x60,%al
  801312:	7e 19                	jle    80132d <strtol+0xe4>
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	3c 7a                	cmp    $0x7a,%al
  80131b:	7f 10                	jg     80132d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	0f be c0             	movsbl %al,%eax
  801325:	83 e8 57             	sub    $0x57,%eax
  801328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132b:	eb 20                	jmp    80134d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	3c 40                	cmp    $0x40,%al
  801334:	7e 39                	jle    80136f <strtol+0x126>
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	3c 5a                	cmp    $0x5a,%al
  80133d:	7f 30                	jg     80136f <strtol+0x126>
			dig = *s - 'A' + 10;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	0f be c0             	movsbl %al,%eax
  801347:	83 e8 37             	sub    $0x37,%eax
  80134a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801350:	3b 45 10             	cmp    0x10(%ebp),%eax
  801353:	7d 19                	jge    80136e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801355:	ff 45 08             	incl   0x8(%ebp)
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135f:	89 c2                	mov    %eax,%edx
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801369:	e9 7b ff ff ff       	jmp    8012e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801373:	74 08                	je     80137d <strtol+0x134>
		*endptr = (char *) s;
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8b 55 08             	mov    0x8(%ebp),%edx
  80137b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80137d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801381:	74 07                	je     80138a <strtol+0x141>
  801383:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801386:	f7 d8                	neg    %eax
  801388:	eb 03                	jmp    80138d <strtol+0x144>
  80138a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <ltostr>:

void
ltostr(long value, char *str)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80139c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a7:	79 13                	jns    8013bc <ltostr+0x2d>
	{
		neg = 1;
  8013a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c4:	99                   	cltd   
  8013c5:	f7 f9                	idiv   %ecx
  8013c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cd:	8d 50 01             	lea    0x1(%eax),%edx
  8013d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013dd:	83 c2 30             	add    $0x30,%edx
  8013e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ea:	f7 e9                	imul   %ecx
  8013ec:	c1 fa 02             	sar    $0x2,%edx
  8013ef:	89 c8                	mov    %ecx,%eax
  8013f1:	c1 f8 1f             	sar    $0x1f,%eax
  8013f4:	29 c2                	sub    %eax,%edx
  8013f6:	89 d0                	mov    %edx,%eax
  8013f8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ff:	75 bb                	jne    8013bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140b:	48                   	dec    %eax
  80140c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80140f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801413:	74 3d                	je     801452 <ltostr+0xc3>
		start = 1 ;
  801415:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80141c:	eb 34                	jmp    801452 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80141e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80142b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	01 c2                	add    %eax,%edx
  801433:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	01 c8                	add    %ecx,%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80143f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c2                	add    %eax,%edx
  801447:	8a 45 eb             	mov    -0x15(%ebp),%al
  80144a:	88 02                	mov    %al,(%edx)
		start++ ;
  80144c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80144f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801455:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801458:	7c c4                	jl     80141e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80145a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801465:	90                   	nop
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80146e:	ff 75 08             	pushl  0x8(%ebp)
  801471:	e8 c4 f9 ff ff       	call   800e3a <strlen>
  801476:	83 c4 04             	add    $0x4,%esp
  801479:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80147c:	ff 75 0c             	pushl  0xc(%ebp)
  80147f:	e8 b6 f9 ff ff       	call   800e3a <strlen>
  801484:	83 c4 04             	add    $0x4,%esp
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80148a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801498:	eb 17                	jmp    8014b1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80149a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a0:	01 c2                	add    %eax,%edx
  8014a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	01 c8                	add    %ecx,%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ae:	ff 45 fc             	incl   -0x4(%ebp)
  8014b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014b7:	7c e1                	jl     80149a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014c7:	eb 1f                	jmp    8014e8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cc:	8d 50 01             	lea    0x1(%eax),%edx
  8014cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d7:	01 c2                	add    %eax,%edx
  8014d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	01 c8                	add    %ecx,%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014e5:	ff 45 f8             	incl   -0x8(%ebp)
  8014e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ee:	7c d9                	jl     8014c9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f6:	01 d0                	add    %edx,%eax
  8014f8:	c6 00 00             	movb   $0x0,(%eax)
}
  8014fb:	90                   	nop
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801501:	8b 45 14             	mov    0x14(%ebp),%eax
  801504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80150a:	8b 45 14             	mov    0x14(%ebp),%eax
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 d0                	add    %edx,%eax
  80151b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801521:	eb 0c                	jmp    80152f <strsplit+0x31>
			*string++ = 0;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8d 50 01             	lea    0x1(%eax),%edx
  801529:	89 55 08             	mov    %edx,0x8(%ebp)
  80152c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	84 c0                	test   %al,%al
  801536:	74 18                	je     801550 <strsplit+0x52>
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	0f be c0             	movsbl %al,%eax
  801540:	50                   	push   %eax
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	e8 83 fa ff ff       	call   800fcc <strchr>
  801549:	83 c4 08             	add    $0x8,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	75 d3                	jne    801523 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	84 c0                	test   %al,%al
  801557:	74 5a                	je     8015b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	83 f8 0f             	cmp    $0xf,%eax
  801561:	75 07                	jne    80156a <strsplit+0x6c>
		{
			return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	eb 66                	jmp    8015d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 48 01             	lea    0x1(%eax),%ecx
  801572:	8b 55 14             	mov    0x14(%ebp),%edx
  801575:	89 0a                	mov    %ecx,(%edx)
  801577:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80157e:	8b 45 10             	mov    0x10(%ebp),%eax
  801581:	01 c2                	add    %eax,%edx
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801588:	eb 03                	jmp    80158d <strsplit+0x8f>
			string++;
  80158a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	84 c0                	test   %al,%al
  801594:	74 8b                	je     801521 <strsplit+0x23>
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	0f be c0             	movsbl %al,%eax
  80159e:	50                   	push   %eax
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	e8 25 fa ff ff       	call   800fcc <strchr>
  8015a7:	83 c4 08             	add    $0x8,%esp
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	74 dc                	je     80158a <strsplit+0x8c>
			string++;
	}
  8015ae:	e9 6e ff ff ff       	jmp    801521 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b7:	8b 00                	mov    (%eax),%eax
  8015b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 4a                	jmp    801631 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	8a 00                	mov    (%eax),%al
  801605:	3c 40                	cmp    $0x40,%al
  801607:	7e 25                	jle    80162e <str2lower+0x5c>
  801609:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160f:	01 d0                	add    %edx,%eax
  801611:	8a 00                	mov    (%eax),%al
  801613:	3c 5a                	cmp    $0x5a,%al
  801615:	7f 17                	jg     80162e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801617:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801622:	8b 55 08             	mov    0x8(%ebp),%edx
  801625:	01 ca                	add    %ecx,%edx
  801627:	8a 12                	mov    (%edx),%dl
  801629:	83 c2 20             	add    $0x20,%edx
  80162c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80162e:	ff 45 fc             	incl   -0x4(%ebp)
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	e8 01 f8 ff ff       	call   800e3a <strlen>
  801639:	83 c4 04             	add    $0x4,%esp
  80163c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80163f:	7f a6                	jg     8015e7 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801641:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80164c:	a1 08 50 80 00       	mov    0x805008,%eax
  801651:	85 c0                	test   %eax,%eax
  801653:	74 42                	je     801697 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	68 00 00 00 82       	push   $0x82000000
  80165d:	68 00 00 00 80       	push   $0x80000000
  801662:	e8 b0 1e 00 00       	call   803517 <initialize_dynamic_allocator>
  801667:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80166a:	e8 96 1c 00 00       	call   803305 <sys_get_uheap_strategy>
  80166f:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801674:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801679:	05 00 10 00 00       	add    $0x1000,%eax
  80167e:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801683:	a1 30 51 83 00       	mov    0x835130,%eax
  801688:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  80168d:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801694:	00 00 00 
	}
}
  801697:	90                   	nop
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	68 06 04 00 00       	push   $0x406
  8016b6:	50                   	push   %eax
  8016b7:	e8 93 18 00 00       	call   802f4f <__sys_allocate_page>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016c6:	79 14                	jns    8016dc <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	68 c8 49 80 00       	push   $0x8049c8
  8016d0:	6a 1f                	push   $0x1f
  8016d2:	68 04 4a 80 00       	push   $0x804a04
  8016d7:	e8 b7 ed ff ff       	call   800493 <_panic>
	return 0;
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	50                   	push   %eax
  8016fb:	e8 96 18 00 00       	call   802f96 <__sys_unmap_frame>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80170a:	79 14                	jns    801720 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80170c:	83 ec 04             	sub    $0x4,%esp
  80170f:	68 10 4a 80 00       	push   $0x804a10
  801714:	6a 2a                	push   $0x2a
  801716:	68 04 4a 80 00       	push   $0x804a04
  80171b:	e8 73 ed ff ff       	call   800493 <_panic>
}
  801720:	90                   	nop
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801729:	e8 18 ff ff ff       	call   801646 <uheap_init>
	if (size == 0) return NULL ;
  80172e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801732:	75 0a                	jne    80173e <malloc+0x1b>
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
  801739:	e9 43 03 00 00       	jmp    801a81 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80173e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801745:	77 13                	ja     80175a <malloc+0x37>
    {
        return alloc_block(size);
  801747:	83 ec 0c             	sub    $0xc,%esp
  80174a:	ff 75 08             	pushl  0x8(%ebp)
  80174d:	e8 78 20 00 00       	call   8037ca <alloc_block>
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	e9 27 03 00 00       	jmp    801a81 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80175a:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801761:	8b 55 08             	mov    0x8(%ebp),%edx
  801764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801767:	01 d0                	add    %edx,%eax
  801769:	48                   	dec    %eax
  80176a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80176d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801770:	ba 00 00 00 00       	mov    $0x0,%edx
  801775:	f7 75 dc             	divl   -0x24(%ebp)
  801778:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80177b:	29 d0                	sub    %edx,%eax
  80177d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801780:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801785:	85 c0                	test   %eax,%eax
  801787:	75 0a                	jne    801793 <malloc+0x70>
    {
        uhp_inited = 1;
  801789:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801790:	00 00 00 
    }

    int exactIdx = -1;
  801793:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80179a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8017a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8017a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017af:	e9 85 00 00 00       	jmp    801839 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8017b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017b7:	89 d0                	mov    %edx,%eax
  8017b9:	01 c0                	add    %eax,%eax
  8017bb:	01 d0                	add    %edx,%eax
  8017bd:	c1 e0 02             	shl    $0x2,%eax
  8017c0:	05 48 10 81 00       	add    $0x811048,%eax
  8017c5:	8a 00                	mov    (%eax),%al
  8017c7:	84 c0                	test   %al,%al
  8017c9:	74 20                	je     8017eb <malloc+0xc8>
  8017cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ce:	89 d0                	mov    %edx,%eax
  8017d0:	01 c0                	add    %eax,%eax
  8017d2:	01 d0                	add    %edx,%eax
  8017d4:	c1 e0 02             	shl    $0x2,%eax
  8017d7:	05 44 10 81 00       	add    $0x811044,%eax
  8017dc:	8b 00                	mov    (%eax),%eax
  8017de:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017e1:	75 08                	jne    8017eb <malloc+0xc8>
        {
            exactIdx = i;
  8017e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8017e9:	eb 5b                	jmp    801846 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8017eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ee:	89 d0                	mov    %edx,%eax
  8017f0:	01 c0                	add    %eax,%eax
  8017f2:	01 d0                	add    %edx,%eax
  8017f4:	c1 e0 02             	shl    $0x2,%eax
  8017f7:	05 48 10 81 00       	add    $0x811048,%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	84 c0                	test   %al,%al
  801800:	74 34                	je     801836 <malloc+0x113>
  801802:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801805:	89 d0                	mov    %edx,%eax
  801807:	01 c0                	add    %eax,%eax
  801809:	01 d0                	add    %edx,%eax
  80180b:	c1 e0 02             	shl    $0x2,%eax
  80180e:	05 44 10 81 00       	add    $0x811044,%eax
  801813:	8b 00                	mov    (%eax),%eax
  801815:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801818:	76 1c                	jbe    801836 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  80181a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80181d:	89 d0                	mov    %edx,%eax
  80181f:	01 c0                	add    %eax,%eax
  801821:	01 d0                	add    %edx,%eax
  801823:	c1 e0 02             	shl    $0x2,%eax
  801826:	05 44 10 81 00       	add    $0x811044,%eax
  80182b:	8b 00                	mov    (%eax),%eax
  80182d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801830:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801836:	ff 45 e8             	incl   -0x18(%ebp)
  801839:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801840:	0f 8e 6e ff ff ff    	jle    8017b4 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801846:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80184d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801851:	74 7d                	je     8018d0 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801853:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80185a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185d:	89 d0                	mov    %edx,%eax
  80185f:	01 c0                	add    %eax,%eax
  801861:	01 d0                	add    %edx,%eax
  801863:	c1 e0 02             	shl    $0x2,%eax
  801866:	05 40 10 81 00       	add    $0x811040,%eax
  80186b:	8b 10                	mov    (%eax),%edx
  80186d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801870:	01 d0                	add    %edx,%eax
  801872:	48                   	dec    %eax
  801873:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801876:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801879:	ba 00 00 00 00       	mov    $0x0,%edx
  80187e:	f7 75 bc             	divl   -0x44(%ebp)
  801881:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801884:	29 d0                	sub    %edx,%eax
  801886:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188c:	89 d0                	mov    %edx,%eax
  80188e:	01 c0                	add    %eax,%eax
  801890:	01 d0                	add    %edx,%eax
  801892:	c1 e0 02             	shl    $0x2,%eax
  801895:	05 48 10 81 00       	add    $0x811048,%eax
  80189a:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80189d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a0:	89 d0                	mov    %edx,%eax
  8018a2:	01 c0                	add    %eax,%eax
  8018a4:	01 d0                	add    %edx,%eax
  8018a6:	c1 e0 02             	shl    $0x2,%eax
  8018a9:	05 44 10 81 00       	add    $0x811044,%eax
  8018ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8018b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b7:	89 d0                	mov    %edx,%eax
  8018b9:	01 c0                	add    %eax,%eax
  8018bb:	01 d0                	add    %edx,%eax
  8018bd:	c1 e0 02             	shl    $0x2,%eax
  8018c0:	05 40 10 81 00       	add    $0x811040,%eax
  8018c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018cb:	e9 2d 01 00 00       	jmp    8019fd <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8018d0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018d4:	0f 84 ce 00 00 00    	je     8019a8 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8018da:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8018e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018e4:	89 d0                	mov    %edx,%eax
  8018e6:	01 c0                	add    %eax,%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	c1 e0 02             	shl    $0x2,%eax
  8018ed:	05 40 10 81 00       	add    $0x811040,%eax
  8018f2:	8b 10                	mov    (%eax),%edx
  8018f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018f7:	01 d0                	add    %edx,%eax
  8018f9:	48                   	dec    %eax
  8018fa:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8018fd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801900:	ba 00 00 00 00       	mov    $0x0,%edx
  801905:	f7 75 c4             	divl   -0x3c(%ebp)
  801908:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80190b:	29 d0                	sub    %edx,%eax
  80190d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801910:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801913:	89 d0                	mov    %edx,%eax
  801915:	01 c0                	add    %eax,%eax
  801917:	01 d0                	add    %edx,%eax
  801919:	c1 e0 02             	shl    $0x2,%eax
  80191c:	05 44 10 81 00       	add    $0x811044,%eax
  801921:	8b 00                	mov    (%eax),%eax
  801923:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801926:	75 47                	jne    80196f <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801928:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192b:	89 d0                	mov    %edx,%eax
  80192d:	01 c0                	add    %eax,%eax
  80192f:	01 d0                	add    %edx,%eax
  801931:	c1 e0 02             	shl    $0x2,%eax
  801934:	05 48 10 81 00       	add    $0x811048,%eax
  801939:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80193c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80193f:	89 d0                	mov    %edx,%eax
  801941:	01 c0                	add    %eax,%eax
  801943:	01 d0                	add    %edx,%eax
  801945:	c1 e0 02             	shl    $0x2,%eax
  801948:	05 44 10 81 00       	add    $0x811044,%eax
  80194d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801953:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801956:	89 d0                	mov    %edx,%eax
  801958:	01 c0                	add    %eax,%eax
  80195a:	01 d0                	add    %edx,%eax
  80195c:	c1 e0 02             	shl    $0x2,%eax
  80195f:	05 40 10 81 00       	add    $0x811040,%eax
  801964:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80196a:	e9 8e 00 00 00       	jmp    8019fd <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80196f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801972:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801975:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801978:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80197b:	89 d0                	mov    %edx,%eax
  80197d:	01 c0                	add    %eax,%eax
  80197f:	01 d0                	add    %edx,%eax
  801981:	c1 e0 02             	shl    $0x2,%eax
  801984:	05 40 10 81 00       	add    $0x811040,%eax
  801989:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80198b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801991:	89 c2                	mov    %eax,%edx
  801993:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801996:	89 c8                	mov    %ecx,%eax
  801998:	01 c0                	add    %eax,%eax
  80199a:	01 c8                	add    %ecx,%eax
  80199c:	c1 e0 02             	shl    $0x2,%eax
  80199f:	05 44 10 81 00       	add    $0x811044,%eax
  8019a4:	89 10                	mov    %edx,(%eax)
  8019a6:	eb 55                	jmp    8019fd <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8019a8:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8019af:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8019b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019b8:	01 d0                	add    %edx,%eax
  8019ba:	48                   	dec    %eax
  8019bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8019be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c6:	f7 75 d0             	divl   -0x30(%ebp)
  8019c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019cc:	29 d0                	sub    %edx,%eax
  8019ce:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8019d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019d7:	01 d0                	add    %edx,%eax
  8019d9:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019de:	76 0a                	jbe    8019ea <malloc+0x2c7>
            return NULL;
  8019e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e5:	e9 97 00 00 00       	jmp    801a81 <malloc+0x35e>
        va = start;
  8019ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8019f0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019f6:	01 d0                	add    %edx,%eax
  8019f8:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a04:	eb 5e                	jmp    801a64 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801a06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a09:	89 d0                	mov    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	01 d0                	add    %edx,%eax
  801a0f:	c1 e0 02             	shl    $0x2,%eax
  801a12:	05 48 50 80 00       	add    $0x805048,%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	84 c0                	test   %al,%al
  801a1b:	75 44                	jne    801a61 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801a1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a20:	89 d0                	mov    %edx,%eax
  801a22:	01 c0                	add    %eax,%eax
  801a24:	01 d0                	add    %edx,%eax
  801a26:	c1 e0 02             	shl    $0x2,%eax
  801a29:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a32:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a37:	89 d0                	mov    %edx,%eax
  801a39:	01 c0                	add    %eax,%eax
  801a3b:	01 d0                	add    %edx,%eax
  801a3d:	c1 e0 02             	shl    $0x2,%eax
  801a40:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a46:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a49:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a4e:	89 d0                	mov    %edx,%eax
  801a50:	01 c0                	add    %eax,%eax
  801a52:	01 d0                	add    %edx,%eax
  801a54:	c1 e0 02             	shl    $0x2,%eax
  801a57:	05 48 50 80 00       	add    $0x805048,%eax
  801a5c:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a5f:	eb 0c                	jmp    801a6d <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a61:	ff 45 e0             	incl   -0x20(%ebp)
  801a64:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a6b:	7e 99                	jle    801a06 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a76:	e8 a2 19 00 00       	call   80341d <sys_allocate_user_mem>
  801a7b:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a8d:	0f 84 fa 03 00 00    	je     801e8d <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	79 1c                	jns    801abc <free+0x39>
  801aa0:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801aa7:	77 13                	ja     801abc <free+0x39>
    {
        free_block(virtual_address);
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	e8 09 21 00 00       	call   803bbd <free_block>
  801ab4:	83 c4 10             	add    $0x10,%esp
        return;
  801ab7:	e9 d2 03 00 00       	jmp    801e8e <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801abc:	a1 30 51 83 00       	mov    0x835130,%eax
  801ac1:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801ac4:	72 09                	jb     801acf <free+0x4c>
  801ac6:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801acd:	76 17                	jbe    801ae6 <free+0x63>
        panic("free: invalid address");
  801acf:	83 ec 04             	sub    $0x4,%esp
  801ad2:	68 4d 4a 80 00       	push   $0x804a4d
  801ad7:	68 9b 00 00 00       	push   $0x9b
  801adc:	68 04 4a 80 00       	push   $0x804a04
  801ae1:	e8 ad e9 ff ff       	call   800493 <_panic>

    uint32 size = 0;
  801ae6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801aed:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801af4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801afb:	eb 50                	jmp    801b4d <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801afd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b00:	89 d0                	mov    %edx,%eax
  801b02:	01 c0                	add    %eax,%eax
  801b04:	01 d0                	add    %edx,%eax
  801b06:	c1 e0 02             	shl    $0x2,%eax
  801b09:	05 48 50 80 00       	add    $0x805048,%eax
  801b0e:	8a 00                	mov    (%eax),%al
  801b10:	84 c0                	test   %al,%al
  801b12:	74 36                	je     801b4a <free+0xc7>
  801b14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b17:	89 d0                	mov    %edx,%eax
  801b19:	01 c0                	add    %eax,%eax
  801b1b:	01 d0                	add    %edx,%eax
  801b1d:	c1 e0 02             	shl    $0x2,%eax
  801b20:	05 40 50 80 00       	add    $0x805040,%eax
  801b25:	8b 00                	mov    (%eax),%eax
  801b27:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b2a:	75 1e                	jne    801b4a <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801b2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b2f:	89 d0                	mov    %edx,%eax
  801b31:	01 c0                	add    %eax,%eax
  801b33:	01 d0                	add    %edx,%eax
  801b35:	c1 e0 02             	shl    $0x2,%eax
  801b38:	05 44 50 80 00       	add    $0x805044,%eax
  801b3d:	8b 00                	mov    (%eax),%eax
  801b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b48:	eb 0c                	jmp    801b56 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b4a:	ff 45 ec             	incl   -0x14(%ebp)
  801b4d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b54:	7e a7                	jle    801afd <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b56:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b5a:	74 06                	je     801b62 <free+0xdf>
  801b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b60:	75 17                	jne    801b79 <free+0xf6>
        panic("free: unknown block");
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	68 63 4a 80 00       	push   $0x804a63
  801b6a:	68 a9 00 00 00       	push   $0xa9
  801b6f:	68 04 4a 80 00       	push   $0x804a04
  801b74:	e8 1a e9 ff ff       	call   800493 <_panic>

    uhp_allocs[idx].used = 0;
  801b79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b7c:	89 d0                	mov    %edx,%eax
  801b7e:	01 c0                	add    %eax,%eax
  801b80:	01 d0                	add    %edx,%eax
  801b82:	c1 e0 02             	shl    $0x2,%eax
  801b85:	05 48 50 80 00       	add    $0x805048,%eax
  801b8a:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b8d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b9b:	eb 64                	jmp    801c01 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ba0:	89 d0                	mov    %edx,%eax
  801ba2:	01 c0                	add    %eax,%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	c1 e0 02             	shl    $0x2,%eax
  801ba9:	05 48 10 81 00       	add    $0x811048,%eax
  801bae:	8a 00                	mov    (%eax),%al
  801bb0:	84 c0                	test   %al,%al
  801bb2:	75 4a                	jne    801bfe <free+0x17b>
        {
            uhp_frees[i].va = va;
  801bb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb7:	89 d0                	mov    %edx,%eax
  801bb9:	01 c0                	add    %eax,%eax
  801bbb:	01 d0                	add    %edx,%eax
  801bbd:	c1 e0 02             	shl    $0x2,%eax
  801bc0:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801bc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bc9:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801bcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bce:	89 d0                	mov    %edx,%eax
  801bd0:	01 c0                	add    %eax,%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	c1 e0 02             	shl    $0x2,%eax
  801bd7:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be0:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801be2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801be5:	89 d0                	mov    %edx,%eax
  801be7:	01 c0                	add    %eax,%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c1 e0 02             	shl    $0x2,%eax
  801bee:	05 48 10 81 00       	add    $0x811048,%eax
  801bf3:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801bf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bf9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801bfc:	eb 0c                	jmp    801c0a <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bfe:	ff 45 e4             	incl   -0x1c(%ebp)
  801c01:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801c08:	7e 93                	jle    801b9d <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801c0a:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801c0e:	0f 84 f1 01 00 00    	je     801e05 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c1b:	e9 d8 01 00 00       	jmp    801df8 <free+0x375>
        {
            if (i == fidx) continue;
  801c20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c23:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c26:	0f 84 c8 01 00 00    	je     801df4 <free+0x371>
            if (uhp_frees[i].free)
  801c2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c2f:	89 d0                	mov    %edx,%eax
  801c31:	01 c0                	add    %eax,%eax
  801c33:	01 d0                	add    %edx,%eax
  801c35:	c1 e0 02             	shl    $0x2,%eax
  801c38:	05 48 10 81 00       	add    $0x811048,%eax
  801c3d:	8a 00                	mov    (%eax),%al
  801c3f:	84 c0                	test   %al,%al
  801c41:	0f 84 ae 01 00 00    	je     801df5 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c4a:	89 d0                	mov    %edx,%eax
  801c4c:	01 c0                	add    %eax,%eax
  801c4e:	01 d0                	add    %edx,%eax
  801c50:	c1 e0 02             	shl    $0x2,%eax
  801c53:	05 40 10 81 00       	add    $0x811040,%eax
  801c58:	8b 08                	mov    (%eax),%ecx
  801c5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c5d:	89 d0                	mov    %edx,%eax
  801c5f:	01 c0                	add    %eax,%eax
  801c61:	01 d0                	add    %edx,%eax
  801c63:	c1 e0 02             	shl    $0x2,%eax
  801c66:	05 44 10 81 00       	add    $0x811044,%eax
  801c6b:	8b 00                	mov    (%eax),%eax
  801c6d:	01 c1                	add    %eax,%ecx
  801c6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c72:	89 d0                	mov    %edx,%eax
  801c74:	01 c0                	add    %eax,%eax
  801c76:	01 d0                	add    %edx,%eax
  801c78:	c1 e0 02             	shl    $0x2,%eax
  801c7b:	05 40 10 81 00       	add    $0x811040,%eax
  801c80:	8b 00                	mov    (%eax),%eax
  801c82:	39 c1                	cmp    %eax,%ecx
  801c84:	0f 85 a8 00 00 00    	jne    801d32 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8d:	89 d0                	mov    %edx,%eax
  801c8f:	01 c0                	add    %eax,%eax
  801c91:	01 d0                	add    %edx,%eax
  801c93:	c1 e0 02             	shl    $0x2,%eax
  801c96:	05 40 10 81 00       	add    $0x811040,%eax
  801c9b:	8b 10                	mov    (%eax),%edx
  801c9d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801ca0:	89 c8                	mov    %ecx,%eax
  801ca2:	01 c0                	add    %eax,%eax
  801ca4:	01 c8                	add    %ecx,%eax
  801ca6:	c1 e0 02             	shl    $0x2,%eax
  801ca9:	05 40 10 81 00       	add    $0x811040,%eax
  801cae:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801cb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cb3:	89 d0                	mov    %edx,%eax
  801cb5:	01 c0                	add    %eax,%eax
  801cb7:	01 d0                	add    %edx,%eax
  801cb9:	c1 e0 02             	shl    $0x2,%eax
  801cbc:	05 44 10 81 00       	add    $0x811044,%eax
  801cc1:	8b 08                	mov    (%eax),%ecx
  801cc3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cc6:	89 d0                	mov    %edx,%eax
  801cc8:	01 c0                	add    %eax,%eax
  801cca:	01 d0                	add    %edx,%eax
  801ccc:	c1 e0 02             	shl    $0x2,%eax
  801ccf:	05 44 10 81 00       	add    $0x811044,%eax
  801cd4:	8b 00                	mov    (%eax),%eax
  801cd6:	01 c1                	add    %eax,%ecx
  801cd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cdb:	89 d0                	mov    %edx,%eax
  801cdd:	01 c0                	add    %eax,%eax
  801cdf:	01 d0                	add    %edx,%eax
  801ce1:	c1 e0 02             	shl    $0x2,%eax
  801ce4:	05 44 10 81 00       	add    $0x811044,%eax
  801ce9:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801ceb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cee:	89 d0                	mov    %edx,%eax
  801cf0:	01 c0                	add    %eax,%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	c1 e0 02             	shl    $0x2,%eax
  801cf7:	05 48 10 81 00       	add    $0x811048,%eax
  801cfc:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801cff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d02:	89 d0                	mov    %edx,%eax
  801d04:	01 c0                	add    %eax,%eax
  801d06:	01 d0                	add    %edx,%eax
  801d08:	c1 e0 02             	shl    $0x2,%eax
  801d0b:	05 40 10 81 00       	add    $0x811040,%eax
  801d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d16:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d19:	89 d0                	mov    %edx,%eax
  801d1b:	01 c0                	add    %eax,%eax
  801d1d:	01 d0                	add    %edx,%eax
  801d1f:	c1 e0 02             	shl    $0x2,%eax
  801d22:	05 44 10 81 00       	add    $0x811044,%eax
  801d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d2d:	e9 c3 00 00 00       	jmp    801df5 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d35:	89 d0                	mov    %edx,%eax
  801d37:	01 c0                	add    %eax,%eax
  801d39:	01 d0                	add    %edx,%eax
  801d3b:	c1 e0 02             	shl    $0x2,%eax
  801d3e:	05 40 10 81 00       	add    $0x811040,%eax
  801d43:	8b 08                	mov    (%eax),%ecx
  801d45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d48:	89 d0                	mov    %edx,%eax
  801d4a:	01 c0                	add    %eax,%eax
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	c1 e0 02             	shl    $0x2,%eax
  801d51:	05 44 10 81 00       	add    $0x811044,%eax
  801d56:	8b 00                	mov    (%eax),%eax
  801d58:	01 c1                	add    %eax,%ecx
  801d5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d5d:	89 d0                	mov    %edx,%eax
  801d5f:	01 c0                	add    %eax,%eax
  801d61:	01 d0                	add    %edx,%eax
  801d63:	c1 e0 02             	shl    $0x2,%eax
  801d66:	05 40 10 81 00       	add    $0x811040,%eax
  801d6b:	8b 00                	mov    (%eax),%eax
  801d6d:	39 c1                	cmp    %eax,%ecx
  801d6f:	0f 85 80 00 00 00    	jne    801df5 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d78:	89 d0                	mov    %edx,%eax
  801d7a:	01 c0                	add    %eax,%eax
  801d7c:	01 d0                	add    %edx,%eax
  801d7e:	c1 e0 02             	shl    $0x2,%eax
  801d81:	05 44 10 81 00       	add    $0x811044,%eax
  801d86:	8b 08                	mov    (%eax),%ecx
  801d88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	01 c0                	add    %eax,%eax
  801d8f:	01 d0                	add    %edx,%eax
  801d91:	c1 e0 02             	shl    $0x2,%eax
  801d94:	05 44 10 81 00       	add    $0x811044,%eax
  801d99:	8b 00                	mov    (%eax),%eax
  801d9b:	01 c1                	add    %eax,%ecx
  801d9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801da0:	89 d0                	mov    %edx,%eax
  801da2:	01 c0                	add    %eax,%eax
  801da4:	01 d0                	add    %edx,%eax
  801da6:	c1 e0 02             	shl    $0x2,%eax
  801da9:	05 44 10 81 00       	add    $0x811044,%eax
  801dae:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801db0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db3:	89 d0                	mov    %edx,%eax
  801db5:	01 c0                	add    %eax,%eax
  801db7:	01 d0                	add    %edx,%eax
  801db9:	c1 e0 02             	shl    $0x2,%eax
  801dbc:	05 48 10 81 00       	add    $0x811048,%eax
  801dc1:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801dc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc7:	89 d0                	mov    %edx,%eax
  801dc9:	01 c0                	add    %eax,%eax
  801dcb:	01 d0                	add    %edx,%eax
  801dcd:	c1 e0 02             	shl    $0x2,%eax
  801dd0:	05 40 10 81 00       	add    $0x811040,%eax
  801dd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dde:	89 d0                	mov    %edx,%eax
  801de0:	01 c0                	add    %eax,%eax
  801de2:	01 d0                	add    %edx,%eax
  801de4:	c1 e0 02             	shl    $0x2,%eax
  801de7:	05 44 10 81 00       	add    $0x811044,%eax
  801dec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801df2:	eb 01                	jmp    801df5 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801df4:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801df5:	ff 45 e0             	incl   -0x20(%ebp)
  801df8:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801dff:	0f 8e 1b fe ff ff    	jle    801c20 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801e05:	a1 30 51 83 00       	mov    0x835130,%eax
  801e0a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e0d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e14:	eb 53                	jmp    801e69 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801e16:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e19:	89 d0                	mov    %edx,%eax
  801e1b:	01 c0                	add    %eax,%eax
  801e1d:	01 d0                	add    %edx,%eax
  801e1f:	c1 e0 02             	shl    $0x2,%eax
  801e22:	05 48 50 80 00       	add    $0x805048,%eax
  801e27:	8a 00                	mov    (%eax),%al
  801e29:	84 c0                	test   %al,%al
  801e2b:	74 39                	je     801e66 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801e2d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e30:	89 d0                	mov    %edx,%eax
  801e32:	01 c0                	add    %eax,%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c1 e0 02             	shl    $0x2,%eax
  801e39:	05 40 50 80 00       	add    $0x805040,%eax
  801e3e:	8b 08                	mov    (%eax),%ecx
  801e40:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	01 c0                	add    %eax,%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c1 e0 02             	shl    $0x2,%eax
  801e4c:	05 44 50 80 00       	add    $0x805044,%eax
  801e51:	8b 00                	mov    (%eax),%eax
  801e53:	01 c8                	add    %ecx,%eax
  801e55:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e5b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e5e:	76 06                	jbe    801e66 <free+0x3e3>
  801e60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e63:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e66:	ff 45 d8             	incl   -0x28(%ebp)
  801e69:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e70:	7e a4                	jle    801e16 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e75:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e7a:	83 ec 08             	sub    $0x8,%esp
  801e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e80:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e83:	e8 79 15 00 00       	call   803401 <sys_free_user_mem>
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	eb 01                	jmp    801e8e <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e8d:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 68             	sub    $0x68,%esp
  801e96:	8b 45 10             	mov    0x10(%ebp),%eax
  801e99:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e9c:	e8 a5 f7 ff ff       	call   801646 <uheap_init>
	if (size == 0) return NULL ;
  801ea1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea5:	75 0a                	jne    801eb1 <smalloc+0x21>
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	e9 37 03 00 00       	jmp    8021e8 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801eb1:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ebe:	01 d0                	add    %edx,%eax
  801ec0:	48                   	dec    %eax
  801ec1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ec4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ec7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ecc:	f7 75 dc             	divl   -0x24(%ebp)
  801ecf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ed2:	29 d0                	sub    %edx,%eax
  801ed4:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801ed7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ede:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801ee5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801eec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ef3:	e9 85 00 00 00       	jmp    801f7d <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ef8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801efb:	89 d0                	mov    %edx,%eax
  801efd:	01 c0                	add    %eax,%eax
  801eff:	01 d0                	add    %edx,%eax
  801f01:	c1 e0 02             	shl    $0x2,%eax
  801f04:	05 48 10 81 00       	add    $0x811048,%eax
  801f09:	8a 00                	mov    (%eax),%al
  801f0b:	84 c0                	test   %al,%al
  801f0d:	74 20                	je     801f2f <smalloc+0x9f>
  801f0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f12:	89 d0                	mov    %edx,%eax
  801f14:	01 c0                	add    %eax,%eax
  801f16:	01 d0                	add    %edx,%eax
  801f18:	c1 e0 02             	shl    $0x2,%eax
  801f1b:	05 44 10 81 00       	add    $0x811044,%eax
  801f20:	8b 00                	mov    (%eax),%eax
  801f22:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f25:	75 08                	jne    801f2f <smalloc+0x9f>
        {
            exactIdx = i;
  801f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f2d:	eb 5b                	jmp    801f8a <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f32:	89 d0                	mov    %edx,%eax
  801f34:	01 c0                	add    %eax,%eax
  801f36:	01 d0                	add    %edx,%eax
  801f38:	c1 e0 02             	shl    $0x2,%eax
  801f3b:	05 48 10 81 00       	add    $0x811048,%eax
  801f40:	8a 00                	mov    (%eax),%al
  801f42:	84 c0                	test   %al,%al
  801f44:	74 34                	je     801f7a <smalloc+0xea>
  801f46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f49:	89 d0                	mov    %edx,%eax
  801f4b:	01 c0                	add    %eax,%eax
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	c1 e0 02             	shl    $0x2,%eax
  801f52:	05 44 10 81 00       	add    $0x811044,%eax
  801f57:	8b 00                	mov    (%eax),%eax
  801f59:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f5c:	76 1c                	jbe    801f7a <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f61:	89 d0                	mov    %edx,%eax
  801f63:	01 c0                	add    %eax,%eax
  801f65:	01 d0                	add    %edx,%eax
  801f67:	c1 e0 02             	shl    $0x2,%eax
  801f6a:	05 44 10 81 00       	add    $0x811044,%eax
  801f6f:	8b 00                	mov    (%eax),%eax
  801f71:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f77:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f7a:	ff 45 e8             	incl   -0x18(%ebp)
  801f7d:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f84:	0f 8e 6e ff ff ff    	jle    801ef8 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f91:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f95:	74 7d                	je     802014 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f97:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa1:	89 d0                	mov    %edx,%eax
  801fa3:	01 c0                	add    %eax,%eax
  801fa5:	01 d0                	add    %edx,%eax
  801fa7:	c1 e0 02             	shl    $0x2,%eax
  801faa:	05 40 10 81 00       	add    $0x811040,%eax
  801faf:	8b 10                	mov    (%eax),%edx
  801fb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801fb4:	01 d0                	add    %edx,%eax
  801fb6:	48                   	dec    %eax
  801fb7:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801fba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc2:	f7 75 bc             	divl   -0x44(%ebp)
  801fc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fc8:	29 d0                	sub    %edx,%eax
  801fca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801fcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd0:	89 d0                	mov    %edx,%eax
  801fd2:	01 c0                	add    %eax,%eax
  801fd4:	01 d0                	add    %edx,%eax
  801fd6:	c1 e0 02             	shl    $0x2,%eax
  801fd9:	05 48 10 81 00       	add    $0x811048,%eax
  801fde:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fe1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe4:	89 d0                	mov    %edx,%eax
  801fe6:	01 c0                	add    %eax,%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	c1 e0 02             	shl    $0x2,%eax
  801fed:	05 44 10 81 00       	add    $0x811044,%eax
  801ff2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801ff8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffb:	89 d0                	mov    %edx,%eax
  801ffd:	01 c0                	add    %eax,%eax
  801fff:	01 d0                	add    %edx,%eax
  802001:	c1 e0 02             	shl    $0x2,%eax
  802004:	05 40 10 81 00       	add    $0x811040,%eax
  802009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80200f:	e9 2d 01 00 00       	jmp    802141 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802014:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802018:	0f 84 ce 00 00 00    	je     8020ec <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80201e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802025:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802028:	89 d0                	mov    %edx,%eax
  80202a:	01 c0                	add    %eax,%eax
  80202c:	01 d0                	add    %edx,%eax
  80202e:	c1 e0 02             	shl    $0x2,%eax
  802031:	05 40 10 81 00       	add    $0x811040,%eax
  802036:	8b 10                	mov    (%eax),%edx
  802038:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80203b:	01 d0                	add    %edx,%eax
  80203d:	48                   	dec    %eax
  80203e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802041:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802044:	ba 00 00 00 00       	mov    $0x0,%edx
  802049:	f7 75 c4             	divl   -0x3c(%ebp)
  80204c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80204f:	29 d0                	sub    %edx,%eax
  802051:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802054:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802057:	89 d0                	mov    %edx,%eax
  802059:	01 c0                	add    %eax,%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	c1 e0 02             	shl    $0x2,%eax
  802060:	05 44 10 81 00       	add    $0x811044,%eax
  802065:	8b 00                	mov    (%eax),%eax
  802067:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80206a:	75 47                	jne    8020b3 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80206c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80206f:	89 d0                	mov    %edx,%eax
  802071:	01 c0                	add    %eax,%eax
  802073:	01 d0                	add    %edx,%eax
  802075:	c1 e0 02             	shl    $0x2,%eax
  802078:	05 48 10 81 00       	add    $0x811048,%eax
  80207d:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802080:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802083:	89 d0                	mov    %edx,%eax
  802085:	01 c0                	add    %eax,%eax
  802087:	01 d0                	add    %edx,%eax
  802089:	c1 e0 02             	shl    $0x2,%eax
  80208c:	05 44 10 81 00       	add    $0x811044,%eax
  802091:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802097:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80209a:	89 d0                	mov    %edx,%eax
  80209c:	01 c0                	add    %eax,%eax
  80209e:	01 d0                	add    %edx,%eax
  8020a0:	c1 e0 02             	shl    $0x2,%eax
  8020a3:	05 40 10 81 00       	add    $0x811040,%eax
  8020a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ae:	e9 8e 00 00 00       	jmp    802141 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8020b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020b9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020bf:	89 d0                	mov    %edx,%eax
  8020c1:	01 c0                	add    %eax,%eax
  8020c3:	01 d0                	add    %edx,%eax
  8020c5:	c1 e0 02             	shl    $0x2,%eax
  8020c8:	05 40 10 81 00       	add    $0x811040,%eax
  8020cd:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020d5:	89 c2                	mov    %eax,%edx
  8020d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020da:	89 c8                	mov    %ecx,%eax
  8020dc:	01 c0                	add    %eax,%eax
  8020de:	01 c8                	add    %ecx,%eax
  8020e0:	c1 e0 02             	shl    $0x2,%eax
  8020e3:	05 44 10 81 00       	add    $0x811044,%eax
  8020e8:	89 10                	mov    %edx,(%eax)
  8020ea:	eb 55                	jmp    802141 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020ec:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020f3:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8020f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	48                   	dec    %eax
  8020ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802102:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802105:	ba 00 00 00 00       	mov    $0x0,%edx
  80210a:	f7 75 d0             	divl   -0x30(%ebp)
  80210d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802110:	29 d0                	sub    %edx,%eax
  802112:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802115:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802118:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80211b:	01 d0                	add    %edx,%eax
  80211d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802122:	76 0a                	jbe    80212e <smalloc+0x29e>
            return NULL;
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
  802129:	e9 ba 00 00 00       	jmp    8021e8 <smalloc+0x358>
        va = start;
  80212e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802134:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802137:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802141:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802148:	eb 5e                	jmp    8021a8 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  80214a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80214d:	89 d0                	mov    %edx,%eax
  80214f:	01 c0                	add    %eax,%eax
  802151:	01 d0                	add    %edx,%eax
  802153:	c1 e0 02             	shl    $0x2,%eax
  802156:	05 48 50 80 00       	add    $0x805048,%eax
  80215b:	8a 00                	mov    (%eax),%al
  80215d:	84 c0                	test   %al,%al
  80215f:	75 44                	jne    8021a5 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802161:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802164:	89 d0                	mov    %edx,%eax
  802166:	01 c0                	add    %eax,%eax
  802168:	01 d0                	add    %edx,%eax
  80216a:	c1 e0 02             	shl    $0x2,%eax
  80216d:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802176:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802178:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80217b:	89 d0                	mov    %edx,%eax
  80217d:	01 c0                	add    %eax,%eax
  80217f:	01 d0                	add    %edx,%eax
  802181:	c1 e0 02             	shl    $0x2,%eax
  802184:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80218a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80218d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80218f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802192:	89 d0                	mov    %edx,%eax
  802194:	01 c0                	add    %eax,%eax
  802196:	01 d0                	add    %edx,%eax
  802198:	c1 e0 02             	shl    $0x2,%eax
  80219b:	05 48 50 80 00       	add    $0x805048,%eax
  8021a0:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8021a3:	eb 0c                	jmp    8021b1 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8021a5:	ff 45 e0             	incl   -0x20(%ebp)
  8021a8:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8021af:	7e 99                	jle    80214a <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8021b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021b4:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8021b8:	52                   	push   %edx
  8021b9:	50                   	push   %eax
  8021ba:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021bd:	ff 75 08             	pushl  0x8(%ebp)
  8021c0:	e8 de 0e 00 00       	call   8030a3 <sys_create_shared_object>
  8021c5:	83 c4 10             	add    $0x10,%esp
  8021c8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8021cb:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8021cf:	75 07                	jne    8021d8 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8021d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021d6:	eb 10                	jmp    8021e8 <smalloc+0x358>
    if (r < 0)
  8021d8:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8021dc:	79 07                	jns    8021e5 <smalloc+0x355>
        return NULL;
  8021de:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e3:	eb 03                	jmp    8021e8 <smalloc+0x358>
    return (void*)va;
  8021e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021f0:	e8 51 f4 ff ff       	call   801646 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021f5:	83 ec 08             	sub    $0x8,%esp
  8021f8:	ff 75 0c             	pushl  0xc(%ebp)
  8021fb:	ff 75 08             	pushl  0x8(%ebp)
  8021fe:	e8 ca 0e 00 00       	call   8030cd <sys_size_of_shared_object>
  802203:	83 c4 10             	add    $0x10,%esp
  802206:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802209:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80220d:	7f 0a                	jg     802219 <sget+0x2f>
        return NULL;
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	e9 28 03 00 00       	jmp    802541 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802219:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802223:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802226:	01 d0                	add    %edx,%eax
  802228:	48                   	dec    %eax
  802229:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80222c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80222f:	ba 00 00 00 00       	mov    $0x0,%edx
  802234:	f7 75 d8             	divl   -0x28(%ebp)
  802237:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80223a:	29 d0                	sub    %edx,%eax
  80223c:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80223f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802246:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80224d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802254:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80225b:	e9 85 00 00 00       	jmp    8022e5 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802260:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802263:	89 d0                	mov    %edx,%eax
  802265:	01 c0                	add    %eax,%eax
  802267:	01 d0                	add    %edx,%eax
  802269:	c1 e0 02             	shl    $0x2,%eax
  80226c:	05 48 10 81 00       	add    $0x811048,%eax
  802271:	8a 00                	mov    (%eax),%al
  802273:	84 c0                	test   %al,%al
  802275:	74 20                	je     802297 <sget+0xad>
  802277:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80227a:	89 d0                	mov    %edx,%eax
  80227c:	01 c0                	add    %eax,%eax
  80227e:	01 d0                	add    %edx,%eax
  802280:	c1 e0 02             	shl    $0x2,%eax
  802283:	05 44 10 81 00       	add    $0x811044,%eax
  802288:	8b 00                	mov    (%eax),%eax
  80228a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80228d:	75 08                	jne    802297 <sget+0xad>
        {
            exactIdx = i;
  80228f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802292:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802295:	eb 5b                	jmp    8022f2 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802297:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80229a:	89 d0                	mov    %edx,%eax
  80229c:	01 c0                	add    %eax,%eax
  80229e:	01 d0                	add    %edx,%eax
  8022a0:	c1 e0 02             	shl    $0x2,%eax
  8022a3:	05 48 10 81 00       	add    $0x811048,%eax
  8022a8:	8a 00                	mov    (%eax),%al
  8022aa:	84 c0                	test   %al,%al
  8022ac:	74 34                	je     8022e2 <sget+0xf8>
  8022ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022b1:	89 d0                	mov    %edx,%eax
  8022b3:	01 c0                	add    %eax,%eax
  8022b5:	01 d0                	add    %edx,%eax
  8022b7:	c1 e0 02             	shl    $0x2,%eax
  8022ba:	05 44 10 81 00       	add    $0x811044,%eax
  8022bf:	8b 00                	mov    (%eax),%eax
  8022c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022c4:	76 1c                	jbe    8022e2 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8022c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022c9:	89 d0                	mov    %edx,%eax
  8022cb:	01 c0                	add    %eax,%eax
  8022cd:	01 d0                	add    %edx,%eax
  8022cf:	c1 e0 02             	shl    $0x2,%eax
  8022d2:	05 44 10 81 00       	add    $0x811044,%eax
  8022d7:	8b 00                	mov    (%eax),%eax
  8022d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8022dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022e2:	ff 45 e8             	incl   -0x18(%ebp)
  8022e5:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8022ec:	0f 8e 6e ff ff ff    	jle    802260 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8022f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8022f9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8022fd:	74 7d                	je     80237c <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8022ff:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802309:	89 d0                	mov    %edx,%eax
  80230b:	01 c0                	add    %eax,%eax
  80230d:	01 d0                	add    %edx,%eax
  80230f:	c1 e0 02             	shl    $0x2,%eax
  802312:	05 40 10 81 00       	add    $0x811040,%eax
  802317:	8b 10                	mov    (%eax),%edx
  802319:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80231c:	01 d0                	add    %edx,%eax
  80231e:	48                   	dec    %eax
  80231f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802322:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802325:	ba 00 00 00 00       	mov    $0x0,%edx
  80232a:	f7 75 b8             	divl   -0x48(%ebp)
  80232d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802330:	29 d0                	sub    %edx,%eax
  802332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802335:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802338:	89 d0                	mov    %edx,%eax
  80233a:	01 c0                	add    %eax,%eax
  80233c:	01 d0                	add    %edx,%eax
  80233e:	c1 e0 02             	shl    $0x2,%eax
  802341:	05 48 10 81 00       	add    $0x811048,%eax
  802346:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802349:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234c:	89 d0                	mov    %edx,%eax
  80234e:	01 c0                	add    %eax,%eax
  802350:	01 d0                	add    %edx,%eax
  802352:	c1 e0 02             	shl    $0x2,%eax
  802355:	05 44 10 81 00       	add    $0x811044,%eax
  80235a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802363:	89 d0                	mov    %edx,%eax
  802365:	01 c0                	add    %eax,%eax
  802367:	01 d0                	add    %edx,%eax
  802369:	c1 e0 02             	shl    $0x2,%eax
  80236c:	05 40 10 81 00       	add    $0x811040,%eax
  802371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802377:	e9 2d 01 00 00       	jmp    8024a9 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80237c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802380:	0f 84 ce 00 00 00    	je     802454 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802386:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80238d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802390:	89 d0                	mov    %edx,%eax
  802392:	01 c0                	add    %eax,%eax
  802394:	01 d0                	add    %edx,%eax
  802396:	c1 e0 02             	shl    $0x2,%eax
  802399:	05 40 10 81 00       	add    $0x811040,%eax
  80239e:	8b 10                	mov    (%eax),%edx
  8023a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023a3:	01 d0                	add    %edx,%eax
  8023a5:	48                   	dec    %eax
  8023a6:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8023a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b1:	f7 75 c0             	divl   -0x40(%ebp)
  8023b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023b7:	29 d0                	sub    %edx,%eax
  8023b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8023bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023bf:	89 d0                	mov    %edx,%eax
  8023c1:	01 c0                	add    %eax,%eax
  8023c3:	01 d0                	add    %edx,%eax
  8023c5:	c1 e0 02             	shl    $0x2,%eax
  8023c8:	05 44 10 81 00       	add    $0x811044,%eax
  8023cd:	8b 00                	mov    (%eax),%eax
  8023cf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023d2:	75 47                	jne    80241b <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8023d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d7:	89 d0                	mov    %edx,%eax
  8023d9:	01 c0                	add    %eax,%eax
  8023db:	01 d0                	add    %edx,%eax
  8023dd:	c1 e0 02             	shl    $0x2,%eax
  8023e0:	05 48 10 81 00       	add    $0x811048,%eax
  8023e5:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8023e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	01 c0                	add    %eax,%eax
  8023ef:	01 d0                	add    %edx,%eax
  8023f1:	c1 e0 02             	shl    $0x2,%eax
  8023f4:	05 44 10 81 00       	add    $0x811044,%eax
  8023f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8023ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802402:	89 d0                	mov    %edx,%eax
  802404:	01 c0                	add    %eax,%eax
  802406:	01 d0                	add    %edx,%eax
  802408:	c1 e0 02             	shl    $0x2,%eax
  80240b:	05 40 10 81 00       	add    $0x811040,%eax
  802410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802416:	e9 8e 00 00 00       	jmp    8024a9 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80241b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80241e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802421:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802424:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802427:	89 d0                	mov    %edx,%eax
  802429:	01 c0                	add    %eax,%eax
  80242b:	01 d0                	add    %edx,%eax
  80242d:	c1 e0 02             	shl    $0x2,%eax
  802430:	05 40 10 81 00       	add    $0x811040,%eax
  802435:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80243d:	89 c2                	mov    %eax,%edx
  80243f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802442:	89 c8                	mov    %ecx,%eax
  802444:	01 c0                	add    %eax,%eax
  802446:	01 c8                	add    %ecx,%eax
  802448:	c1 e0 02             	shl    $0x2,%eax
  80244b:	05 44 10 81 00       	add    $0x811044,%eax
  802450:	89 10                	mov    %edx,(%eax)
  802452:	eb 55                	jmp    8024a9 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802454:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80245b:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802461:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802464:	01 d0                	add    %edx,%eax
  802466:	48                   	dec    %eax
  802467:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80246a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80246d:	ba 00 00 00 00       	mov    $0x0,%edx
  802472:	f7 75 cc             	divl   -0x34(%ebp)
  802475:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802478:	29 d0                	sub    %edx,%eax
  80247a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80247d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802480:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802483:	01 d0                	add    %edx,%eax
  802485:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80248a:	76 0a                	jbe    802496 <sget+0x2ac>
            return NULL;
  80248c:	b8 00 00 00 00       	mov    $0x0,%eax
  802491:	e9 ab 00 00 00       	jmp    802541 <sget+0x357>
        va = start;
  802496:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80249c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80249f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024a2:	01 d0                	add    %edx,%eax
  8024a4:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8024b0:	eb 5e                	jmp    802510 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8024b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024b5:	89 d0                	mov    %edx,%eax
  8024b7:	01 c0                	add    %eax,%eax
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	c1 e0 02             	shl    $0x2,%eax
  8024be:	05 48 50 80 00       	add    $0x805048,%eax
  8024c3:	8a 00                	mov    (%eax),%al
  8024c5:	84 c0                	test   %al,%al
  8024c7:	75 44                	jne    80250d <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8024c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024cc:	89 d0                	mov    %edx,%eax
  8024ce:	01 c0                	add    %eax,%eax
  8024d0:	01 d0                	add    %edx,%eax
  8024d2:	c1 e0 02             	shl    $0x2,%eax
  8024d5:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8024db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024de:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8024e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024e3:	89 d0                	mov    %edx,%eax
  8024e5:	01 c0                	add    %eax,%eax
  8024e7:	01 d0                	add    %edx,%eax
  8024e9:	c1 e0 02             	shl    $0x2,%eax
  8024ec:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024f5:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8024f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024fa:	89 d0                	mov    %edx,%eax
  8024fc:	01 c0                	add    %eax,%eax
  8024fe:	01 d0                	add    %edx,%eax
  802500:	c1 e0 02             	shl    $0x2,%eax
  802503:	05 48 50 80 00       	add    $0x805048,%eax
  802508:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80250b:	eb 0c                	jmp    802519 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80250d:	ff 45 e0             	incl   -0x20(%ebp)
  802510:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802517:	7e 99                	jle    8024b2 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	50                   	push   %eax
  802520:	ff 75 0c             	pushl  0xc(%ebp)
  802523:	ff 75 08             	pushl  0x8(%ebp)
  802526:	e8 bf 0b 00 00       	call   8030ea <sys_get_shared_object>
  80252b:	83 c4 10             	add    $0x10,%esp
  80252e:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802531:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802535:	79 07                	jns    80253e <sget+0x354>
        return NULL;
  802537:	b8 00 00 00 00       	mov    $0x0,%eax
  80253c:	eb 03                	jmp    802541 <sget+0x357>
    return (void*)va;
  80253e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
  802546:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802549:	e8 f8 f0 ff ff       	call   801646 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80254e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802552:	75 13                	jne    802567 <realloc+0x24>
		return malloc(new_size);
  802554:	83 ec 0c             	sub    $0xc,%esp
  802557:	ff 75 0c             	pushl  0xc(%ebp)
  80255a:	e8 c4 f1 ff ff       	call   801723 <malloc>
  80255f:	83 c4 10             	add    $0x10,%esp
  802562:	e9 f4 05 00 00       	jmp    802b5b <realloc+0x618>
	if (new_size == 0)
  802567:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80256b:	75 18                	jne    802585 <realloc+0x42>
	{
		free(virtual_address);
  80256d:	83 ec 0c             	sub    $0xc,%esp
  802570:	ff 75 08             	pushl  0x8(%ebp)
  802573:	e8 0b f5 ff ff       	call   801a83 <free>
  802578:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80257b:	b8 00 00 00 00       	mov    $0x0,%eax
  802580:	e9 d6 05 00 00       	jmp    802b5b <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80258b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	79 74                	jns    802606 <realloc+0xc3>
  802592:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802599:	77 6b                	ja     802606 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80259b:	83 ec 0c             	sub    $0xc,%esp
  80259e:	ff 75 0c             	pushl  0xc(%ebp)
  8025a1:	e8 7d f1 ff ff       	call   801723 <malloc>
  8025a6:	83 c4 10             	add    $0x10,%esp
  8025a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8025ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8025b0:	75 0a                	jne    8025bc <realloc+0x79>
			return NULL;
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b7:	e9 9f 05 00 00       	jmp    802b5b <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8025bc:	83 ec 0c             	sub    $0xc,%esp
  8025bf:	ff 75 08             	pushl  0x8(%ebp)
  8025c2:	e8 e0 11 00 00       	call   8037a7 <get_block_size>
  8025c7:	83 c4 10             	add    $0x10,%esp
  8025ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8025cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d3:	39 d0                	cmp    %edx,%eax
  8025d5:	76 02                	jbe    8025d9 <realloc+0x96>
  8025d7:	89 d0                	mov    %edx,%eax
  8025d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8025dc:	83 ec 04             	sub    $0x4,%esp
  8025df:	ff 75 c0             	pushl  -0x40(%ebp)
  8025e2:	ff 75 08             	pushl  0x8(%ebp)
  8025e5:	ff 75 c8             	pushl  -0x38(%ebp)
  8025e8:	e8 56 eb ff ff       	call   801143 <memmove>
  8025ed:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8025f0:	83 ec 0c             	sub    $0xc,%esp
  8025f3:	ff 75 08             	pushl  0x8(%ebp)
  8025f6:	e8 88 f4 ff ff       	call   801a83 <free>
  8025fb:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8025fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802601:	e9 55 05 00 00       	jmp    802b5b <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802606:	a1 30 51 83 00       	mov    0x835130,%eax
  80260b:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  80260e:	72 09                	jb     802619 <realloc+0xd6>
  802610:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802617:	76 0a                	jbe    802623 <realloc+0xe0>
		return NULL;
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	e9 38 05 00 00       	jmp    802b5b <realloc+0x618>
	uint32 oldsz = 0;
  802623:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  80262a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802631:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802638:	eb 50                	jmp    80268a <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80263a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80263d:	89 d0                	mov    %edx,%eax
  80263f:	01 c0                	add    %eax,%eax
  802641:	01 d0                	add    %edx,%eax
  802643:	c1 e0 02             	shl    $0x2,%eax
  802646:	05 48 50 80 00       	add    $0x805048,%eax
  80264b:	8a 00                	mov    (%eax),%al
  80264d:	84 c0                	test   %al,%al
  80264f:	74 36                	je     802687 <realloc+0x144>
  802651:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802654:	89 d0                	mov    %edx,%eax
  802656:	01 c0                	add    %eax,%eax
  802658:	01 d0                	add    %edx,%eax
  80265a:	c1 e0 02             	shl    $0x2,%eax
  80265d:	05 40 50 80 00       	add    $0x805040,%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802667:	75 1e                	jne    802687 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802669:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80266c:	89 d0                	mov    %edx,%eax
  80266e:	01 c0                	add    %eax,%eax
  802670:	01 d0                	add    %edx,%eax
  802672:	c1 e0 02             	shl    $0x2,%eax
  802675:	05 44 50 80 00       	add    $0x805044,%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80267f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802682:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802685:	eb 0c                	jmp    802693 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802687:	ff 45 ec             	incl   -0x14(%ebp)
  80268a:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802691:	7e a7                	jle    80263a <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802693:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802697:	75 0a                	jne    8026a3 <realloc+0x160>
		return NULL;
  802699:	b8 00 00 00 00       	mov    $0x0,%eax
  80269e:	e9 b8 04 00 00       	jmp    802b5b <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8026a3:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8026aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	48                   	dec    %eax
  8026b3:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8026b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026be:	f7 75 bc             	divl   -0x44(%ebp)
  8026c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026c4:	29 d0                	sub    %edx,%eax
  8026c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8026c9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026cf:	75 08                	jne    8026d9 <realloc+0x196>
		return virtual_address;
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	e9 82 04 00 00       	jmp    802b5b <realloc+0x618>
	if (req < oldsz)
  8026d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026df:	0f 83 cd 02 00 00    	jae    8029b2 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8026eb:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8026ee:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026f4:	01 d0                	add    %edx,%eax
  8026f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8026f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026fc:	89 d0                	mov    %edx,%eax
  8026fe:	01 c0                	add    %eax,%eax
  802700:	01 d0                	add    %edx,%eax
  802702:	c1 e0 02             	shl    $0x2,%eax
  802705:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80270b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80270e:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802710:	83 ec 08             	sub    $0x8,%esp
  802713:	ff 75 b0             	pushl  -0x50(%ebp)
  802716:	ff 75 ac             	pushl  -0x54(%ebp)
  802719:	e8 e3 0c 00 00       	call   803401 <sys_free_user_mem>
  80271e:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802721:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802728:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80272f:	eb 64                	jmp    802795 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802731:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802734:	89 d0                	mov    %edx,%eax
  802736:	01 c0                	add    %eax,%eax
  802738:	01 d0                	add    %edx,%eax
  80273a:	c1 e0 02             	shl    $0x2,%eax
  80273d:	05 48 10 81 00       	add    $0x811048,%eax
  802742:	8a 00                	mov    (%eax),%al
  802744:	84 c0                	test   %al,%al
  802746:	75 4a                	jne    802792 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80274b:	89 d0                	mov    %edx,%eax
  80274d:	01 c0                	add    %eax,%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	c1 e0 02             	shl    $0x2,%eax
  802754:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  80275a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80275d:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80275f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802762:	89 d0                	mov    %edx,%eax
  802764:	01 c0                	add    %eax,%eax
  802766:	01 d0                	add    %edx,%eax
  802768:	c1 e0 02             	shl    $0x2,%eax
  80276b:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802771:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802774:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802779:	89 d0                	mov    %edx,%eax
  80277b:	01 c0                	add    %eax,%eax
  80277d:	01 d0                	add    %edx,%eax
  80277f:	c1 e0 02             	shl    $0x2,%eax
  802782:	05 48 10 81 00       	add    $0x811048,%eax
  802787:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  80278a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802790:	eb 0c                	jmp    80279e <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802792:	ff 45 e4             	incl   -0x1c(%ebp)
  802795:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80279c:	7e 93                	jle    802731 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80279e:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8027a2:	0f 84 8d 01 00 00    	je     802935 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8027a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027af:	e9 74 01 00 00       	jmp    802928 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8027b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027ba:	0f 84 64 01 00 00    	je     802924 <realloc+0x3e1>
				if (uhp_frees[k].free)
  8027c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c3:	89 d0                	mov    %edx,%eax
  8027c5:	01 c0                	add    %eax,%eax
  8027c7:	01 d0                	add    %edx,%eax
  8027c9:	c1 e0 02             	shl    $0x2,%eax
  8027cc:	05 48 10 81 00       	add    $0x811048,%eax
  8027d1:	8a 00                	mov    (%eax),%al
  8027d3:	84 c0                	test   %al,%al
  8027d5:	0f 84 4a 01 00 00    	je     802925 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8027db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027de:	89 d0                	mov    %edx,%eax
  8027e0:	01 c0                	add    %eax,%eax
  8027e2:	01 d0                	add    %edx,%eax
  8027e4:	c1 e0 02             	shl    $0x2,%eax
  8027e7:	05 40 10 81 00       	add    $0x811040,%eax
  8027ec:	8b 08                	mov    (%eax),%ecx
  8027ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027f1:	89 d0                	mov    %edx,%eax
  8027f3:	01 c0                	add    %eax,%eax
  8027f5:	01 d0                	add    %edx,%eax
  8027f7:	c1 e0 02             	shl    $0x2,%eax
  8027fa:	05 44 10 81 00       	add    $0x811044,%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	01 c1                	add    %eax,%ecx
  802803:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802806:	89 d0                	mov    %edx,%eax
  802808:	01 c0                	add    %eax,%eax
  80280a:	01 d0                	add    %edx,%eax
  80280c:	c1 e0 02             	shl    $0x2,%eax
  80280f:	05 40 10 81 00       	add    $0x811040,%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	39 c1                	cmp    %eax,%ecx
  802818:	75 7a                	jne    802894 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  80281a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80281d:	89 d0                	mov    %edx,%eax
  80281f:	01 c0                	add    %eax,%eax
  802821:	01 d0                	add    %edx,%eax
  802823:	c1 e0 02             	shl    $0x2,%eax
  802826:	05 40 10 81 00       	add    $0x811040,%eax
  80282b:	8b 10                	mov    (%eax),%edx
  80282d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802830:	89 c8                	mov    %ecx,%eax
  802832:	01 c0                	add    %eax,%eax
  802834:	01 c8                	add    %ecx,%eax
  802836:	c1 e0 02             	shl    $0x2,%eax
  802839:	05 40 10 81 00       	add    $0x811040,%eax
  80283e:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802840:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802843:	89 d0                	mov    %edx,%eax
  802845:	01 c0                	add    %eax,%eax
  802847:	01 d0                	add    %edx,%eax
  802849:	c1 e0 02             	shl    $0x2,%eax
  80284c:	05 44 10 81 00       	add    $0x811044,%eax
  802851:	8b 08                	mov    (%eax),%ecx
  802853:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802856:	89 d0                	mov    %edx,%eax
  802858:	01 c0                	add    %eax,%eax
  80285a:	01 d0                	add    %edx,%eax
  80285c:	c1 e0 02             	shl    $0x2,%eax
  80285f:	05 44 10 81 00       	add    $0x811044,%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	01 c1                	add    %eax,%ecx
  802868:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80286b:	89 d0                	mov    %edx,%eax
  80286d:	01 c0                	add    %eax,%eax
  80286f:	01 d0                	add    %edx,%eax
  802871:	c1 e0 02             	shl    $0x2,%eax
  802874:	05 44 10 81 00       	add    $0x811044,%eax
  802879:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80287b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80287e:	89 d0                	mov    %edx,%eax
  802880:	01 c0                	add    %eax,%eax
  802882:	01 d0                	add    %edx,%eax
  802884:	c1 e0 02             	shl    $0x2,%eax
  802887:	05 48 10 81 00       	add    $0x811048,%eax
  80288c:	c6 00 00             	movb   $0x0,(%eax)
  80288f:	e9 91 00 00 00       	jmp    802925 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802894:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802897:	89 d0                	mov    %edx,%eax
  802899:	01 c0                	add    %eax,%eax
  80289b:	01 d0                	add    %edx,%eax
  80289d:	c1 e0 02             	shl    $0x2,%eax
  8028a0:	05 40 10 81 00       	add    $0x811040,%eax
  8028a5:	8b 08                	mov    (%eax),%ecx
  8028a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028aa:	89 d0                	mov    %edx,%eax
  8028ac:	01 c0                	add    %eax,%eax
  8028ae:	01 d0                	add    %edx,%eax
  8028b0:	c1 e0 02             	shl    $0x2,%eax
  8028b3:	05 44 10 81 00       	add    $0x811044,%eax
  8028b8:	8b 00                	mov    (%eax),%eax
  8028ba:	01 c1                	add    %eax,%ecx
  8028bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028bf:	89 d0                	mov    %edx,%eax
  8028c1:	01 c0                	add    %eax,%eax
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	c1 e0 02             	shl    $0x2,%eax
  8028c8:	05 40 10 81 00       	add    $0x811040,%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	39 c1                	cmp    %eax,%ecx
  8028d1:	75 52                	jne    802925 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8028d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d6:	89 d0                	mov    %edx,%eax
  8028d8:	01 c0                	add    %eax,%eax
  8028da:	01 d0                	add    %edx,%eax
  8028dc:	c1 e0 02             	shl    $0x2,%eax
  8028df:	05 44 10 81 00       	add    $0x811044,%eax
  8028e4:	8b 08                	mov    (%eax),%ecx
  8028e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028e9:	89 d0                	mov    %edx,%eax
  8028eb:	01 c0                	add    %eax,%eax
  8028ed:	01 d0                	add    %edx,%eax
  8028ef:	c1 e0 02             	shl    $0x2,%eax
  8028f2:	05 44 10 81 00       	add    $0x811044,%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	01 c1                	add    %eax,%ecx
  8028fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028fe:	89 d0                	mov    %edx,%eax
  802900:	01 c0                	add    %eax,%eax
  802902:	01 d0                	add    %edx,%eax
  802904:	c1 e0 02             	shl    $0x2,%eax
  802907:	05 44 10 81 00       	add    $0x811044,%eax
  80290c:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80290e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802911:	89 d0                	mov    %edx,%eax
  802913:	01 c0                	add    %eax,%eax
  802915:	01 d0                	add    %edx,%eax
  802917:	c1 e0 02             	shl    $0x2,%eax
  80291a:	05 48 10 81 00       	add    $0x811048,%eax
  80291f:	c6 00 00             	movb   $0x0,(%eax)
  802922:	eb 01                	jmp    802925 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802924:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802925:	ff 45 e0             	incl   -0x20(%ebp)
  802928:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80292f:	0f 8e 7f fe ff ff    	jle    8027b4 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802935:	a1 30 51 83 00       	mov    0x835130,%eax
  80293a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80293d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802944:	eb 53                	jmp    802999 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802946:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802949:	89 d0                	mov    %edx,%eax
  80294b:	01 c0                	add    %eax,%eax
  80294d:	01 d0                	add    %edx,%eax
  80294f:	c1 e0 02             	shl    $0x2,%eax
  802952:	05 48 50 80 00       	add    $0x805048,%eax
  802957:	8a 00                	mov    (%eax),%al
  802959:	84 c0                	test   %al,%al
  80295b:	74 39                	je     802996 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80295d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802960:	89 d0                	mov    %edx,%eax
  802962:	01 c0                	add    %eax,%eax
  802964:	01 d0                	add    %edx,%eax
  802966:	c1 e0 02             	shl    $0x2,%eax
  802969:	05 40 50 80 00       	add    $0x805040,%eax
  80296e:	8b 08                	mov    (%eax),%ecx
  802970:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802973:	89 d0                	mov    %edx,%eax
  802975:	01 c0                	add    %eax,%eax
  802977:	01 d0                	add    %edx,%eax
  802979:	c1 e0 02             	shl    $0x2,%eax
  80297c:	05 44 50 80 00       	add    $0x805044,%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	01 c8                	add    %ecx,%eax
  802985:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802988:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80298b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80298e:	76 06                	jbe    802996 <realloc+0x453>
  802990:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802993:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802996:	ff 45 d8             	incl   -0x28(%ebp)
  802999:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8029a0:	7e a4                	jle    802946 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8029a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029a5:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	e9 a9 01 00 00       	jmp    802b5b <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8029b2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	01 d0                	add    %edx,%eax
  8029ba:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8029bd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029c4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8029cb:	eb 57                	jmp    802a24 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8029cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029d0:	89 d0                	mov    %edx,%eax
  8029d2:	01 c0                	add    %eax,%eax
  8029d4:	01 d0                	add    %edx,%eax
  8029d6:	c1 e0 02             	shl    $0x2,%eax
  8029d9:	05 48 10 81 00       	add    $0x811048,%eax
  8029de:	8a 00                	mov    (%eax),%al
  8029e0:	84 c0                	test   %al,%al
  8029e2:	74 3d                	je     802a21 <realloc+0x4de>
  8029e4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029e7:	89 d0                	mov    %edx,%eax
  8029e9:	01 c0                	add    %eax,%eax
  8029eb:	01 d0                	add    %edx,%eax
  8029ed:	c1 e0 02             	shl    $0x2,%eax
  8029f0:	05 40 10 81 00       	add    $0x811040,%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029fa:	75 25                	jne    802a21 <realloc+0x4de>
  8029fc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029ff:	89 d0                	mov    %edx,%eax
  802a01:	01 c0                	add    %eax,%eax
  802a03:	01 d0                	add    %edx,%eax
  802a05:	c1 e0 02             	shl    $0x2,%eax
  802a08:	05 44 10 81 00       	add    $0x811044,%eax
  802a0d:	8b 10                	mov    (%eax),%edx
  802a0f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a12:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a15:	39 c2                	cmp    %eax,%edx
  802a17:	72 08                	jb     802a21 <realloc+0x4de>
		{
			adjIdx = j; break;
  802a19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a1f:	eb 0c                	jmp    802a2d <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a21:	ff 45 d0             	incl   -0x30(%ebp)
  802a24:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802a2b:	7e a0                	jle    8029cd <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802a2d:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802a31:	0f 84 d6 00 00 00    	je     802b0d <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a37:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a3a:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a3d:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a40:	83 ec 08             	sub    $0x8,%esp
  802a43:	ff 75 a0             	pushl  -0x60(%ebp)
  802a46:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a49:	e8 cf 09 00 00       	call   80341d <sys_allocate_user_mem>
  802a4e:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a54:	89 d0                	mov    %edx,%eax
  802a56:	01 c0                	add    %eax,%eax
  802a58:	01 d0                	add    %edx,%eax
  802a5a:	c1 e0 02             	shl    $0x2,%eax
  802a5d:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a63:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a66:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a6b:	89 d0                	mov    %edx,%eax
  802a6d:	01 c0                	add    %eax,%eax
  802a6f:	01 d0                	add    %edx,%eax
  802a71:	c1 e0 02             	shl    $0x2,%eax
  802a74:	05 40 10 81 00       	add    $0x811040,%eax
  802a79:	8b 10                	mov    (%eax),%edx
  802a7b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a7e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a81:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a84:	89 d0                	mov    %edx,%eax
  802a86:	01 c0                	add    %eax,%eax
  802a88:	01 d0                	add    %edx,%eax
  802a8a:	c1 e0 02             	shl    $0x2,%eax
  802a8d:	05 40 10 81 00       	add    $0x811040,%eax
  802a92:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a94:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a97:	89 d0                	mov    %edx,%eax
  802a99:	01 c0                	add    %eax,%eax
  802a9b:	01 d0                	add    %edx,%eax
  802a9d:	c1 e0 02             	shl    $0x2,%eax
  802aa0:	05 44 10 81 00       	add    $0x811044,%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802aaa:	89 c2                	mov    %eax,%edx
  802aac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802aaf:	89 c8                	mov    %ecx,%eax
  802ab1:	01 c0                	add    %eax,%eax
  802ab3:	01 c8                	add    %ecx,%eax
  802ab5:	c1 e0 02             	shl    $0x2,%eax
  802ab8:	05 44 10 81 00       	add    $0x811044,%eax
  802abd:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802abf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ac2:	89 d0                	mov    %edx,%eax
  802ac4:	01 c0                	add    %eax,%eax
  802ac6:	01 d0                	add    %edx,%eax
  802ac8:	c1 e0 02             	shl    $0x2,%eax
  802acb:	05 44 10 81 00       	add    $0x811044,%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	75 14                	jne    802aea <realloc+0x5a7>
  802ad6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ad9:	89 d0                	mov    %edx,%eax
  802adb:	01 c0                	add    %eax,%eax
  802add:	01 d0                	add    %edx,%eax
  802adf:	c1 e0 02             	shl    $0x2,%eax
  802ae2:	05 48 10 81 00       	add    $0x811048,%eax
  802ae7:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802aea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802af0:	01 c2                	add    %eax,%edx
  802af2:	a1 88 50 83 00       	mov    0x835088,%eax
  802af7:	39 c2                	cmp    %eax,%edx
  802af9:	76 0d                	jbe    802b08 <realloc+0x5c5>
  802afb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802afe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b01:	01 d0                	add    %edx,%eax
  802b03:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	eb 4e                	jmp    802b5b <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802b0d:	83 ec 0c             	sub    $0xc,%esp
  802b10:	ff 75 0c             	pushl  0xc(%ebp)
  802b13:	e8 0b ec ff ff       	call   801723 <malloc>
  802b18:	83 c4 10             	add    $0x10,%esp
  802b1b:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802b1e:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802b22:	75 07                	jne    802b2b <realloc+0x5e8>
		return NULL;
  802b24:	b8 00 00 00 00       	mov    $0x0,%eax
  802b29:	eb 30                	jmp    802b5b <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b31:	39 d0                	cmp    %edx,%eax
  802b33:	76 02                	jbe    802b37 <realloc+0x5f4>
  802b35:	89 d0                	mov    %edx,%eax
  802b37:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b3a:	83 ec 04             	sub    $0x4,%esp
  802b3d:	50                   	push   %eax
  802b3e:	52                   	push   %edx
  802b3f:	ff 75 cc             	pushl  -0x34(%ebp)
  802b42:	e8 cf 06 00 00       	call   803216 <sys_move_user_mem>
  802b47:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b4a:	83 ec 0c             	sub    $0xc,%esp
  802b4d:	ff 75 08             	pushl  0x8(%ebp)
  802b50:	e8 2e ef ff ff       	call   801a83 <free>
  802b55:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b58:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b5b:	c9                   	leave  
  802b5c:	c3                   	ret    

00802b5d <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b5d:	55                   	push   %ebp
  802b5e:	89 e5                	mov    %esp,%ebp
  802b60:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b69:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b6d:	0f 84 33 03 00 00    	je     802ea6 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b76:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b7e:	83 ec 08             	sub    $0x8,%esp
  802b81:	ff 75 08             	pushl  0x8(%ebp)
  802b84:	ff 75 d8             	pushl  -0x28(%ebp)
  802b87:	e8 7d 05 00 00       	call   803109 <sys_delete_shared_object>
  802b8c:	83 c4 10             	add    $0x10,%esp
  802b8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b92:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b96:	0f 88 0d 03 00 00    	js     802ea9 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ba3:	e9 ef 02 00 00       	jmp    802e97 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bab:	89 d0                	mov    %edx,%eax
  802bad:	01 c0                	add    %eax,%eax
  802baf:	01 d0                	add    %edx,%eax
  802bb1:	c1 e0 02             	shl    $0x2,%eax
  802bb4:	05 48 50 80 00       	add    $0x805048,%eax
  802bb9:	8a 00                	mov    (%eax),%al
  802bbb:	84 c0                	test   %al,%al
  802bbd:	0f 84 d1 02 00 00    	je     802e94 <sfree+0x337>
  802bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc6:	89 d0                	mov    %edx,%eax
  802bc8:	01 c0                	add    %eax,%eax
  802bca:	01 d0                	add    %edx,%eax
  802bcc:	c1 e0 02             	shl    $0x2,%eax
  802bcf:	05 40 50 80 00       	add    $0x805040,%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bd9:	0f 85 b5 02 00 00    	jne    802e94 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802bdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be2:	89 d0                	mov    %edx,%eax
  802be4:	01 c0                	add    %eax,%eax
  802be6:	01 d0                	add    %edx,%eax
  802be8:	c1 e0 02             	shl    $0x2,%eax
  802beb:	05 44 50 80 00       	add    $0x805044,%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf8:	89 d0                	mov    %edx,%eax
  802bfa:	01 c0                	add    %eax,%eax
  802bfc:	01 d0                	add    %edx,%eax
  802bfe:	c1 e0 02             	shl    $0x2,%eax
  802c01:	05 48 50 80 00       	add    $0x805048,%eax
  802c06:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802c09:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c10:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c17:	eb 64                	jmp    802c7d <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802c19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c1c:	89 d0                	mov    %edx,%eax
  802c1e:	01 c0                	add    %eax,%eax
  802c20:	01 d0                	add    %edx,%eax
  802c22:	c1 e0 02             	shl    $0x2,%eax
  802c25:	05 48 10 81 00       	add    $0x811048,%eax
  802c2a:	8a 00                	mov    (%eax),%al
  802c2c:	84 c0                	test   %al,%al
  802c2e:	75 4a                	jne    802c7a <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802c30:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c33:	89 d0                	mov    %edx,%eax
  802c35:	01 c0                	add    %eax,%eax
  802c37:	01 d0                	add    %edx,%eax
  802c39:	c1 e0 02             	shl    $0x2,%eax
  802c3c:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c45:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c4a:	89 d0                	mov    %edx,%eax
  802c4c:	01 c0                	add    %eax,%eax
  802c4e:	01 d0                	add    %edx,%eax
  802c50:	c1 e0 02             	shl    $0x2,%eax
  802c53:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c5c:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c61:	89 d0                	mov    %edx,%eax
  802c63:	01 c0                	add    %eax,%eax
  802c65:	01 d0                	add    %edx,%eax
  802c67:	c1 e0 02             	shl    $0x2,%eax
  802c6a:	05 48 10 81 00       	add    $0x811048,%eax
  802c6f:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c78:	eb 0c                	jmp    802c86 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c7a:	ff 45 ec             	incl   -0x14(%ebp)
  802c7d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c84:	7e 93                	jle    802c19 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c86:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c8a:	0f 84 8d 01 00 00    	je     802e1d <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c97:	e9 74 01 00 00       	jmp    802e10 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ca2:	0f 84 64 01 00 00    	je     802e0c <sfree+0x2af>
					if (uhp_frees[k].free)
  802ca8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cab:	89 d0                	mov    %edx,%eax
  802cad:	01 c0                	add    %eax,%eax
  802caf:	01 d0                	add    %edx,%eax
  802cb1:	c1 e0 02             	shl    $0x2,%eax
  802cb4:	05 48 10 81 00       	add    $0x811048,%eax
  802cb9:	8a 00                	mov    (%eax),%al
  802cbb:	84 c0                	test   %al,%al
  802cbd:	0f 84 4a 01 00 00    	je     802e0d <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cc6:	89 d0                	mov    %edx,%eax
  802cc8:	01 c0                	add    %eax,%eax
  802cca:	01 d0                	add    %edx,%eax
  802ccc:	c1 e0 02             	shl    $0x2,%eax
  802ccf:	05 40 10 81 00       	add    $0x811040,%eax
  802cd4:	8b 08                	mov    (%eax),%ecx
  802cd6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd9:	89 d0                	mov    %edx,%eax
  802cdb:	01 c0                	add    %eax,%eax
  802cdd:	01 d0                	add    %edx,%eax
  802cdf:	c1 e0 02             	shl    $0x2,%eax
  802ce2:	05 44 10 81 00       	add    $0x811044,%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	01 c1                	add    %eax,%ecx
  802ceb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cee:	89 d0                	mov    %edx,%eax
  802cf0:	01 c0                	add    %eax,%eax
  802cf2:	01 d0                	add    %edx,%eax
  802cf4:	c1 e0 02             	shl    $0x2,%eax
  802cf7:	05 40 10 81 00       	add    $0x811040,%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	39 c1                	cmp    %eax,%ecx
  802d00:	75 7a                	jne    802d7c <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802d02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d05:	89 d0                	mov    %edx,%eax
  802d07:	01 c0                	add    %eax,%eax
  802d09:	01 d0                	add    %edx,%eax
  802d0b:	c1 e0 02             	shl    $0x2,%eax
  802d0e:	05 40 10 81 00       	add    $0x811040,%eax
  802d13:	8b 10                	mov    (%eax),%edx
  802d15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d18:	89 c8                	mov    %ecx,%eax
  802d1a:	01 c0                	add    %eax,%eax
  802d1c:	01 c8                	add    %ecx,%eax
  802d1e:	c1 e0 02             	shl    $0x2,%eax
  802d21:	05 40 10 81 00       	add    $0x811040,%eax
  802d26:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2b:	89 d0                	mov    %edx,%eax
  802d2d:	01 c0                	add    %eax,%eax
  802d2f:	01 d0                	add    %edx,%eax
  802d31:	c1 e0 02             	shl    $0x2,%eax
  802d34:	05 44 10 81 00       	add    $0x811044,%eax
  802d39:	8b 08                	mov    (%eax),%ecx
  802d3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d3e:	89 d0                	mov    %edx,%eax
  802d40:	01 c0                	add    %eax,%eax
  802d42:	01 d0                	add    %edx,%eax
  802d44:	c1 e0 02             	shl    $0x2,%eax
  802d47:	05 44 10 81 00       	add    $0x811044,%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	01 c1                	add    %eax,%ecx
  802d50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d53:	89 d0                	mov    %edx,%eax
  802d55:	01 c0                	add    %eax,%eax
  802d57:	01 d0                	add    %edx,%eax
  802d59:	c1 e0 02             	shl    $0x2,%eax
  802d5c:	05 44 10 81 00       	add    $0x811044,%eax
  802d61:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d66:	89 d0                	mov    %edx,%eax
  802d68:	01 c0                	add    %eax,%eax
  802d6a:	01 d0                	add    %edx,%eax
  802d6c:	c1 e0 02             	shl    $0x2,%eax
  802d6f:	05 48 10 81 00       	add    $0x811048,%eax
  802d74:	c6 00 00             	movb   $0x0,(%eax)
  802d77:	e9 91 00 00 00       	jmp    802e0d <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7f:	89 d0                	mov    %edx,%eax
  802d81:	01 c0                	add    %eax,%eax
  802d83:	01 d0                	add    %edx,%eax
  802d85:	c1 e0 02             	shl    $0x2,%eax
  802d88:	05 40 10 81 00       	add    $0x811040,%eax
  802d8d:	8b 08                	mov    (%eax),%ecx
  802d8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d92:	89 d0                	mov    %edx,%eax
  802d94:	01 c0                	add    %eax,%eax
  802d96:	01 d0                	add    %edx,%eax
  802d98:	c1 e0 02             	shl    $0x2,%eax
  802d9b:	05 44 10 81 00       	add    $0x811044,%eax
  802da0:	8b 00                	mov    (%eax),%eax
  802da2:	01 c1                	add    %eax,%ecx
  802da4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da7:	89 d0                	mov    %edx,%eax
  802da9:	01 c0                	add    %eax,%eax
  802dab:	01 d0                	add    %edx,%eax
  802dad:	c1 e0 02             	shl    $0x2,%eax
  802db0:	05 40 10 81 00       	add    $0x811040,%eax
  802db5:	8b 00                	mov    (%eax),%eax
  802db7:	39 c1                	cmp    %eax,%ecx
  802db9:	75 52                	jne    802e0d <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802dbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbe:	89 d0                	mov    %edx,%eax
  802dc0:	01 c0                	add    %eax,%eax
  802dc2:	01 d0                	add    %edx,%eax
  802dc4:	c1 e0 02             	shl    $0x2,%eax
  802dc7:	05 44 10 81 00       	add    $0x811044,%eax
  802dcc:	8b 08                	mov    (%eax),%ecx
  802dce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd1:	89 d0                	mov    %edx,%eax
  802dd3:	01 c0                	add    %eax,%eax
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	c1 e0 02             	shl    $0x2,%eax
  802dda:	05 44 10 81 00       	add    $0x811044,%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	01 c1                	add    %eax,%ecx
  802de3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de6:	89 d0                	mov    %edx,%eax
  802de8:	01 c0                	add    %eax,%eax
  802dea:	01 d0                	add    %edx,%eax
  802dec:	c1 e0 02             	shl    $0x2,%eax
  802def:	05 44 10 81 00       	add    $0x811044,%eax
  802df4:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802df6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802df9:	89 d0                	mov    %edx,%eax
  802dfb:	01 c0                	add    %eax,%eax
  802dfd:	01 d0                	add    %edx,%eax
  802dff:	c1 e0 02             	shl    $0x2,%eax
  802e02:	05 48 10 81 00       	add    $0x811048,%eax
  802e07:	c6 00 00             	movb   $0x0,(%eax)
  802e0a:	eb 01                	jmp    802e0d <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802e0c:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e0d:	ff 45 e8             	incl   -0x18(%ebp)
  802e10:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802e17:	0f 8e 7f fe ff ff    	jle    802c9c <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802e1d:	a1 30 51 83 00       	mov    0x835130,%eax
  802e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e2c:	eb 53                	jmp    802e81 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802e2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e31:	89 d0                	mov    %edx,%eax
  802e33:	01 c0                	add    %eax,%eax
  802e35:	01 d0                	add    %edx,%eax
  802e37:	c1 e0 02             	shl    $0x2,%eax
  802e3a:	05 48 50 80 00       	add    $0x805048,%eax
  802e3f:	8a 00                	mov    (%eax),%al
  802e41:	84 c0                	test   %al,%al
  802e43:	74 39                	je     802e7e <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e48:	89 d0                	mov    %edx,%eax
  802e4a:	01 c0                	add    %eax,%eax
  802e4c:	01 d0                	add    %edx,%eax
  802e4e:	c1 e0 02             	shl    $0x2,%eax
  802e51:	05 40 50 80 00       	add    $0x805040,%eax
  802e56:	8b 08                	mov    (%eax),%ecx
  802e58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e5b:	89 d0                	mov    %edx,%eax
  802e5d:	01 c0                	add    %eax,%eax
  802e5f:	01 d0                	add    %edx,%eax
  802e61:	c1 e0 02             	shl    $0x2,%eax
  802e64:	05 44 50 80 00       	add    $0x805044,%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	01 c8                	add    %ecx,%eax
  802e6d:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e73:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e76:	76 06                	jbe    802e7e <sfree+0x321>
  802e78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e7e:	ff 45 e0             	incl   -0x20(%ebp)
  802e81:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e88:	7e a4                	jle    802e2e <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8d:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e92:	eb 16                	jmp    802eaa <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e94:	ff 45 f4             	incl   -0xc(%ebp)
  802e97:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e9e:	0f 8e 04 fd ff ff    	jle    802ba8 <sfree+0x4b>
  802ea4:	eb 04                	jmp    802eaa <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802ea6:	90                   	nop
  802ea7:	eb 01                	jmp    802eaa <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802ea9:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802eaa:	c9                   	leave  
  802eab:	c3                   	ret    

00802eac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802eac:	55                   	push   %ebp
  802ead:	89 e5                	mov    %esp,%ebp
  802eaf:	57                   	push   %edi
  802eb0:	56                   	push   %esi
  802eb1:	53                   	push   %ebx
  802eb2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ebe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ec1:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ec4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ec7:	cd 30                	int    $0x30
  802ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ecf:	83 c4 10             	add    $0x10,%esp
  802ed2:	5b                   	pop    %ebx
  802ed3:	5e                   	pop    %esi
  802ed4:	5f                   	pop    %edi
  802ed5:	5d                   	pop    %ebp
  802ed6:	c3                   	ret    

00802ed7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ed7:	55                   	push   %ebp
  802ed8:	89 e5                	mov    %esp,%ebp
  802eda:	83 ec 04             	sub    $0x4,%esp
  802edd:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ee3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ee6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	6a 00                	push   $0x0
  802eef:	51                   	push   %ecx
  802ef0:	52                   	push   %edx
  802ef1:	ff 75 0c             	pushl  0xc(%ebp)
  802ef4:	50                   	push   %eax
  802ef5:	6a 00                	push   $0x0
  802ef7:	e8 b0 ff ff ff       	call   802eac <syscall>
  802efc:	83 c4 18             	add    $0x18,%esp
}
  802eff:	90                   	nop
  802f00:	c9                   	leave  
  802f01:	c3                   	ret    

00802f02 <sys_cgetc>:

int
sys_cgetc(void)
{
  802f02:	55                   	push   %ebp
  802f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 02                	push   $0x2
  802f11:	e8 96 ff ff ff       	call   802eac <syscall>
  802f16:	83 c4 18             	add    $0x18,%esp
}
  802f19:	c9                   	leave  
  802f1a:	c3                   	ret    

00802f1b <sys_lock_cons>:

void sys_lock_cons(void)
{
  802f1b:	55                   	push   %ebp
  802f1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 00                	push   $0x0
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	6a 00                	push   $0x0
  802f28:	6a 03                	push   $0x3
  802f2a:	e8 7d ff ff ff       	call   802eac <syscall>
  802f2f:	83 c4 18             	add    $0x18,%esp
}
  802f32:	90                   	nop
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    

00802f35 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f35:	55                   	push   %ebp
  802f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 04                	push   $0x4
  802f44:	e8 63 ff ff ff       	call   802eac <syscall>
  802f49:	83 c4 18             	add    $0x18,%esp
}
  802f4c:	90                   	nop
  802f4d:	c9                   	leave  
  802f4e:	c3                   	ret    

00802f4f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	6a 00                	push   $0x0
  802f5a:	6a 00                	push   $0x0
  802f5c:	6a 00                	push   $0x0
  802f5e:	52                   	push   %edx
  802f5f:	50                   	push   %eax
  802f60:	6a 08                	push   $0x8
  802f62:	e8 45 ff ff ff       	call   802eac <syscall>
  802f67:	83 c4 18             	add    $0x18,%esp
}
  802f6a:	c9                   	leave  
  802f6b:	c3                   	ret    

00802f6c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f6c:	55                   	push   %ebp
  802f6d:	89 e5                	mov    %esp,%ebp
  802f6f:	56                   	push   %esi
  802f70:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f71:	8b 75 18             	mov    0x18(%ebp),%esi
  802f74:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f77:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	56                   	push   %esi
  802f81:	53                   	push   %ebx
  802f82:	51                   	push   %ecx
  802f83:	52                   	push   %edx
  802f84:	50                   	push   %eax
  802f85:	6a 09                	push   $0x9
  802f87:	e8 20 ff ff ff       	call   802eac <syscall>
  802f8c:	83 c4 18             	add    $0x18,%esp
}
  802f8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f92:	5b                   	pop    %ebx
  802f93:	5e                   	pop    %esi
  802f94:	5d                   	pop    %ebp
  802f95:	c3                   	ret    

00802f96 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f96:	55                   	push   %ebp
  802f97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	ff 75 08             	pushl  0x8(%ebp)
  802fa4:	6a 0a                	push   $0xa
  802fa6:	e8 01 ff ff ff       	call   802eac <syscall>
  802fab:	83 c4 18             	add    $0x18,%esp
}
  802fae:	c9                   	leave  
  802faf:	c3                   	ret    

00802fb0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802fb0:	55                   	push   %ebp
  802fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	ff 75 0c             	pushl  0xc(%ebp)
  802fbc:	ff 75 08             	pushl  0x8(%ebp)
  802fbf:	6a 0b                	push   $0xb
  802fc1:	e8 e6 fe ff ff       	call   802eac <syscall>
  802fc6:	83 c4 18             	add    $0x18,%esp
}
  802fc9:	c9                   	leave  
  802fca:	c3                   	ret    

00802fcb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802fcb:	55                   	push   %ebp
  802fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802fce:	6a 00                	push   $0x0
  802fd0:	6a 00                	push   $0x0
  802fd2:	6a 00                	push   $0x0
  802fd4:	6a 00                	push   $0x0
  802fd6:	6a 00                	push   $0x0
  802fd8:	6a 0c                	push   $0xc
  802fda:	e8 cd fe ff ff       	call   802eac <syscall>
  802fdf:	83 c4 18             	add    $0x18,%esp
}
  802fe2:	c9                   	leave  
  802fe3:	c3                   	ret    

00802fe4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fe4:	55                   	push   %ebp
  802fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fe7:	6a 00                	push   $0x0
  802fe9:	6a 00                	push   $0x0
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	6a 00                	push   $0x0
  802ff1:	6a 0d                	push   $0xd
  802ff3:	e8 b4 fe ff ff       	call   802eac <syscall>
  802ff8:	83 c4 18             	add    $0x18,%esp
}
  802ffb:	c9                   	leave  
  802ffc:	c3                   	ret    

00802ffd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ffd:	55                   	push   %ebp
  802ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	6a 00                	push   $0x0
  80300a:	6a 0e                	push   $0xe
  80300c:	e8 9b fe ff ff       	call   802eac <syscall>
  803011:	83 c4 18             	add    $0x18,%esp
}
  803014:	c9                   	leave  
  803015:	c3                   	ret    

00803016 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803016:	55                   	push   %ebp
  803017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803019:	6a 00                	push   $0x0
  80301b:	6a 00                	push   $0x0
  80301d:	6a 00                	push   $0x0
  80301f:	6a 00                	push   $0x0
  803021:	6a 00                	push   $0x0
  803023:	6a 0f                	push   $0xf
  803025:	e8 82 fe ff ff       	call   802eac <syscall>
  80302a:	83 c4 18             	add    $0x18,%esp
}
  80302d:	c9                   	leave  
  80302e:	c3                   	ret    

0080302f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80302f:	55                   	push   %ebp
  803030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	ff 75 08             	pushl  0x8(%ebp)
  80303d:	6a 10                	push   $0x10
  80303f:	e8 68 fe ff ff       	call   802eac <syscall>
  803044:	83 c4 18             	add    $0x18,%esp
}
  803047:	c9                   	leave  
  803048:	c3                   	ret    

00803049 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803049:	55                   	push   %ebp
  80304a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 11                	push   $0x11
  803058:	e8 4f fe ff ff       	call   802eac <syscall>
  80305d:	83 c4 18             	add    $0x18,%esp
}
  803060:	90                   	nop
  803061:	c9                   	leave  
  803062:	c3                   	ret    

00803063 <sys_cputc>:

void
sys_cputc(const char c)
{
  803063:	55                   	push   %ebp
  803064:	89 e5                	mov    %esp,%ebp
  803066:	83 ec 04             	sub    $0x4,%esp
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80306f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803073:	6a 00                	push   $0x0
  803075:	6a 00                	push   $0x0
  803077:	6a 00                	push   $0x0
  803079:	6a 00                	push   $0x0
  80307b:	50                   	push   %eax
  80307c:	6a 01                	push   $0x1
  80307e:	e8 29 fe ff ff       	call   802eac <syscall>
  803083:	83 c4 18             	add    $0x18,%esp
}
  803086:	90                   	nop
  803087:	c9                   	leave  
  803088:	c3                   	ret    

00803089 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803089:	55                   	push   %ebp
  80308a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80308c:	6a 00                	push   $0x0
  80308e:	6a 00                	push   $0x0
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	6a 00                	push   $0x0
  803096:	6a 14                	push   $0x14
  803098:	e8 0f fe ff ff       	call   802eac <syscall>
  80309d:	83 c4 18             	add    $0x18,%esp
}
  8030a0:	90                   	nop
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
  8030a6:	83 ec 04             	sub    $0x4,%esp
  8030a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8030ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8030af:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030b2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	6a 00                	push   $0x0
  8030bb:	51                   	push   %ecx
  8030bc:	52                   	push   %edx
  8030bd:	ff 75 0c             	pushl  0xc(%ebp)
  8030c0:	50                   	push   %eax
  8030c1:	6a 15                	push   $0x15
  8030c3:	e8 e4 fd ff ff       	call   802eac <syscall>
  8030c8:	83 c4 18             	add    $0x18,%esp
}
  8030cb:	c9                   	leave  
  8030cc:	c3                   	ret    

008030cd <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8030cd:	55                   	push   %ebp
  8030ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8030d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	6a 00                	push   $0x0
  8030d8:	6a 00                	push   $0x0
  8030da:	6a 00                	push   $0x0
  8030dc:	52                   	push   %edx
  8030dd:	50                   	push   %eax
  8030de:	6a 16                	push   $0x16
  8030e0:	e8 c7 fd ff ff       	call   802eac <syscall>
  8030e5:	83 c4 18             	add    $0x18,%esp
}
  8030e8:	c9                   	leave  
  8030e9:	c3                   	ret    

008030ea <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8030ea:	55                   	push   %ebp
  8030eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	51                   	push   %ecx
  8030fb:	52                   	push   %edx
  8030fc:	50                   	push   %eax
  8030fd:	6a 17                	push   $0x17
  8030ff:	e8 a8 fd ff ff       	call   802eac <syscall>
  803104:	83 c4 18             	add    $0x18,%esp
}
  803107:	c9                   	leave  
  803108:	c3                   	ret    

00803109 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803109:	55                   	push   %ebp
  80310a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80310c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	6a 00                	push   $0x0
  803114:	6a 00                	push   $0x0
  803116:	6a 00                	push   $0x0
  803118:	52                   	push   %edx
  803119:	50                   	push   %eax
  80311a:	6a 18                	push   $0x18
  80311c:	e8 8b fd ff ff       	call   802eac <syscall>
  803121:	83 c4 18             	add    $0x18,%esp
}
  803124:	c9                   	leave  
  803125:	c3                   	ret    

00803126 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803126:	55                   	push   %ebp
  803127:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	6a 00                	push   $0x0
  80312e:	ff 75 14             	pushl  0x14(%ebp)
  803131:	ff 75 10             	pushl  0x10(%ebp)
  803134:	ff 75 0c             	pushl  0xc(%ebp)
  803137:	50                   	push   %eax
  803138:	6a 19                	push   $0x19
  80313a:	e8 6d fd ff ff       	call   802eac <syscall>
  80313f:	83 c4 18             	add    $0x18,%esp
}
  803142:	c9                   	leave  
  803143:	c3                   	ret    

00803144 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803144:	55                   	push   %ebp
  803145:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	6a 00                	push   $0x0
  80314c:	6a 00                	push   $0x0
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	50                   	push   %eax
  803153:	6a 1a                	push   $0x1a
  803155:	e8 52 fd ff ff       	call   802eac <syscall>
  80315a:	83 c4 18             	add    $0x18,%esp
}
  80315d:	90                   	nop
  80315e:	c9                   	leave  
  80315f:	c3                   	ret    

00803160 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803160:	55                   	push   %ebp
  803161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	6a 00                	push   $0x0
  80316c:	6a 00                	push   $0x0
  80316e:	50                   	push   %eax
  80316f:	6a 1b                	push   $0x1b
  803171:	e8 36 fd ff ff       	call   802eac <syscall>
  803176:	83 c4 18             	add    $0x18,%esp
}
  803179:	c9                   	leave  
  80317a:	c3                   	ret    

0080317b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80317b:	55                   	push   %ebp
  80317c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80317e:	6a 00                	push   $0x0
  803180:	6a 00                	push   $0x0
  803182:	6a 00                	push   $0x0
  803184:	6a 00                	push   $0x0
  803186:	6a 00                	push   $0x0
  803188:	6a 05                	push   $0x5
  80318a:	e8 1d fd ff ff       	call   802eac <syscall>
  80318f:	83 c4 18             	add    $0x18,%esp
}
  803192:	c9                   	leave  
  803193:	c3                   	ret    

00803194 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803194:	55                   	push   %ebp
  803195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803197:	6a 00                	push   $0x0
  803199:	6a 00                	push   $0x0
  80319b:	6a 00                	push   $0x0
  80319d:	6a 00                	push   $0x0
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 06                	push   $0x6
  8031a3:	e8 04 fd ff ff       	call   802eac <syscall>
  8031a8:	83 c4 18             	add    $0x18,%esp
}
  8031ab:	c9                   	leave  
  8031ac:	c3                   	ret    

008031ad <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8031ad:	55                   	push   %ebp
  8031ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	6a 00                	push   $0x0
  8031b6:	6a 00                	push   $0x0
  8031b8:	6a 00                	push   $0x0
  8031ba:	6a 07                	push   $0x7
  8031bc:	e8 eb fc ff ff       	call   802eac <syscall>
  8031c1:	83 c4 18             	add    $0x18,%esp
}
  8031c4:	c9                   	leave  
  8031c5:	c3                   	ret    

008031c6 <sys_exit_env>:


void sys_exit_env(void)
{
  8031c6:	55                   	push   %ebp
  8031c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8031c9:	6a 00                	push   $0x0
  8031cb:	6a 00                	push   $0x0
  8031cd:	6a 00                	push   $0x0
  8031cf:	6a 00                	push   $0x0
  8031d1:	6a 00                	push   $0x0
  8031d3:	6a 1c                	push   $0x1c
  8031d5:	e8 d2 fc ff ff       	call   802eac <syscall>
  8031da:	83 c4 18             	add    $0x18,%esp
}
  8031dd:	90                   	nop
  8031de:	c9                   	leave  
  8031df:	c3                   	ret    

008031e0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8031e0:	55                   	push   %ebp
  8031e1:	89 e5                	mov    %esp,%ebp
  8031e3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031e6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031e9:	8d 50 04             	lea    0x4(%eax),%edx
  8031ec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	52                   	push   %edx
  8031f6:	50                   	push   %eax
  8031f7:	6a 1d                	push   $0x1d
  8031f9:	e8 ae fc ff ff       	call   802eac <syscall>
  8031fe:	83 c4 18             	add    $0x18,%esp
	return result;
  803201:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803207:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80320a:	89 01                	mov    %eax,(%ecx)
  80320c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	c9                   	leave  
  803213:	c2 04 00             	ret    $0x4

00803216 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803219:	6a 00                	push   $0x0
  80321b:	6a 00                	push   $0x0
  80321d:	ff 75 10             	pushl  0x10(%ebp)
  803220:	ff 75 0c             	pushl  0xc(%ebp)
  803223:	ff 75 08             	pushl  0x8(%ebp)
  803226:	6a 13                	push   $0x13
  803228:	e8 7f fc ff ff       	call   802eac <syscall>
  80322d:	83 c4 18             	add    $0x18,%esp
	return ;
  803230:	90                   	nop
}
  803231:	c9                   	leave  
  803232:	c3                   	ret    

00803233 <sys_rcr2>:
uint32 sys_rcr2()
{
  803233:	55                   	push   %ebp
  803234:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803236:	6a 00                	push   $0x0
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	6a 1e                	push   $0x1e
  803242:	e8 65 fc ff ff       	call   802eac <syscall>
  803247:	83 c4 18             	add    $0x18,%esp
}
  80324a:	c9                   	leave  
  80324b:	c3                   	ret    

0080324c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80324c:	55                   	push   %ebp
  80324d:	89 e5                	mov    %esp,%ebp
  80324f:	83 ec 04             	sub    $0x4,%esp
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803258:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80325c:	6a 00                	push   $0x0
  80325e:	6a 00                	push   $0x0
  803260:	6a 00                	push   $0x0
  803262:	6a 00                	push   $0x0
  803264:	50                   	push   %eax
  803265:	6a 1f                	push   $0x1f
  803267:	e8 40 fc ff ff       	call   802eac <syscall>
  80326c:	83 c4 18             	add    $0x18,%esp
	return ;
  80326f:	90                   	nop
}
  803270:	c9                   	leave  
  803271:	c3                   	ret    

00803272 <rsttst>:
void rsttst()
{
  803272:	55                   	push   %ebp
  803273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803275:	6a 00                	push   $0x0
  803277:	6a 00                	push   $0x0
  803279:	6a 00                	push   $0x0
  80327b:	6a 00                	push   $0x0
  80327d:	6a 00                	push   $0x0
  80327f:	6a 21                	push   $0x21
  803281:	e8 26 fc ff ff       	call   802eac <syscall>
  803286:	83 c4 18             	add    $0x18,%esp
	return ;
  803289:	90                   	nop
}
  80328a:	c9                   	leave  
  80328b:	c3                   	ret    

0080328c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	8b 45 14             	mov    0x14(%ebp),%eax
  803295:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803298:	8b 55 18             	mov    0x18(%ebp),%edx
  80329b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80329f:	52                   	push   %edx
  8032a0:	50                   	push   %eax
  8032a1:	ff 75 10             	pushl  0x10(%ebp)
  8032a4:	ff 75 0c             	pushl  0xc(%ebp)
  8032a7:	ff 75 08             	pushl  0x8(%ebp)
  8032aa:	6a 20                	push   $0x20
  8032ac:	e8 fb fb ff ff       	call   802eac <syscall>
  8032b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b4:	90                   	nop
}
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    

008032b7 <chktst>:
void chktst(uint32 n)
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8032ba:	6a 00                	push   $0x0
  8032bc:	6a 00                	push   $0x0
  8032be:	6a 00                	push   $0x0
  8032c0:	6a 00                	push   $0x0
  8032c2:	ff 75 08             	pushl  0x8(%ebp)
  8032c5:	6a 22                	push   $0x22
  8032c7:	e8 e0 fb ff ff       	call   802eac <syscall>
  8032cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8032cf:	90                   	nop
}
  8032d0:	c9                   	leave  
  8032d1:	c3                   	ret    

008032d2 <inctst>:

void inctst()
{
  8032d2:	55                   	push   %ebp
  8032d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8032d5:	6a 00                	push   $0x0
  8032d7:	6a 00                	push   $0x0
  8032d9:	6a 00                	push   $0x0
  8032db:	6a 00                	push   $0x0
  8032dd:	6a 00                	push   $0x0
  8032df:	6a 23                	push   $0x23
  8032e1:	e8 c6 fb ff ff       	call   802eac <syscall>
  8032e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8032e9:	90                   	nop
}
  8032ea:	c9                   	leave  
  8032eb:	c3                   	ret    

008032ec <gettst>:
uint32 gettst()
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032ef:	6a 00                	push   $0x0
  8032f1:	6a 00                	push   $0x0
  8032f3:	6a 00                	push   $0x0
  8032f5:	6a 00                	push   $0x0
  8032f7:	6a 00                	push   $0x0
  8032f9:	6a 24                	push   $0x24
  8032fb:	e8 ac fb ff ff       	call   802eac <syscall>
  803300:	83 c4 18             	add    $0x18,%esp
}
  803303:	c9                   	leave  
  803304:	c3                   	ret    

00803305 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803305:	55                   	push   %ebp
  803306:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803308:	6a 00                	push   $0x0
  80330a:	6a 00                	push   $0x0
  80330c:	6a 00                	push   $0x0
  80330e:	6a 00                	push   $0x0
  803310:	6a 00                	push   $0x0
  803312:	6a 25                	push   $0x25
  803314:	e8 93 fb ff ff       	call   802eac <syscall>
  803319:	83 c4 18             	add    $0x18,%esp
  80331c:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803321:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803326:	c9                   	leave  
  803327:	c3                   	ret    

00803328 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803328:	55                   	push   %ebp
  803329:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803333:	6a 00                	push   $0x0
  803335:	6a 00                	push   $0x0
  803337:	6a 00                	push   $0x0
  803339:	6a 00                	push   $0x0
  80333b:	ff 75 08             	pushl  0x8(%ebp)
  80333e:	6a 26                	push   $0x26
  803340:	e8 67 fb ff ff       	call   802eac <syscall>
  803345:	83 c4 18             	add    $0x18,%esp
	return ;
  803348:	90                   	nop
}
  803349:	c9                   	leave  
  80334a:	c3                   	ret    

0080334b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80334b:	55                   	push   %ebp
  80334c:	89 e5                	mov    %esp,%ebp
  80334e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80334f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803352:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803355:	8b 55 0c             	mov    0xc(%ebp),%edx
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	6a 00                	push   $0x0
  80335d:	53                   	push   %ebx
  80335e:	51                   	push   %ecx
  80335f:	52                   	push   %edx
  803360:	50                   	push   %eax
  803361:	6a 27                	push   $0x27
  803363:	e8 44 fb ff ff       	call   802eac <syscall>
  803368:	83 c4 18             	add    $0x18,%esp
}
  80336b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80336e:	c9                   	leave  
  80336f:	c3                   	ret    

00803370 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803370:	55                   	push   %ebp
  803371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803373:	8b 55 0c             	mov    0xc(%ebp),%edx
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	6a 00                	push   $0x0
  80337b:	6a 00                	push   $0x0
  80337d:	6a 00                	push   $0x0
  80337f:	52                   	push   %edx
  803380:	50                   	push   %eax
  803381:	6a 28                	push   $0x28
  803383:	e8 24 fb ff ff       	call   802eac <syscall>
  803388:	83 c4 18             	add    $0x18,%esp
}
  80338b:	c9                   	leave  
  80338c:	c3                   	ret    

0080338d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80338d:	55                   	push   %ebp
  80338e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803390:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803393:	8b 55 0c             	mov    0xc(%ebp),%edx
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	6a 00                	push   $0x0
  80339b:	51                   	push   %ecx
  80339c:	ff 75 10             	pushl  0x10(%ebp)
  80339f:	52                   	push   %edx
  8033a0:	50                   	push   %eax
  8033a1:	6a 29                	push   $0x29
  8033a3:	e8 04 fb ff ff       	call   802eac <syscall>
  8033a8:	83 c4 18             	add    $0x18,%esp
}
  8033ab:	c9                   	leave  
  8033ac:	c3                   	ret    

008033ad <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8033ad:	55                   	push   %ebp
  8033ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8033b0:	6a 00                	push   $0x0
  8033b2:	6a 00                	push   $0x0
  8033b4:	ff 75 10             	pushl  0x10(%ebp)
  8033b7:	ff 75 0c             	pushl  0xc(%ebp)
  8033ba:	ff 75 08             	pushl  0x8(%ebp)
  8033bd:	6a 12                	push   $0x12
  8033bf:	e8 e8 fa ff ff       	call   802eac <syscall>
  8033c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8033c7:	90                   	nop
}
  8033c8:	c9                   	leave  
  8033c9:	c3                   	ret    

008033ca <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8033ca:	55                   	push   %ebp
  8033cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8033cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	6a 00                	push   $0x0
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	52                   	push   %edx
  8033da:	50                   	push   %eax
  8033db:	6a 2a                	push   $0x2a
  8033dd:	e8 ca fa ff ff       	call   802eac <syscall>
  8033e2:	83 c4 18             	add    $0x18,%esp
	return;
  8033e5:	90                   	nop
}
  8033e6:	c9                   	leave  
  8033e7:	c3                   	ret    

008033e8 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8033e8:	55                   	push   %ebp
  8033e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8033eb:	6a 00                	push   $0x0
  8033ed:	6a 00                	push   $0x0
  8033ef:	6a 00                	push   $0x0
  8033f1:	6a 00                	push   $0x0
  8033f3:	6a 00                	push   $0x0
  8033f5:	6a 2b                	push   $0x2b
  8033f7:	e8 b0 fa ff ff       	call   802eac <syscall>
  8033fc:	83 c4 18             	add    $0x18,%esp
}
  8033ff:	c9                   	leave  
  803400:	c3                   	ret    

00803401 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803401:	55                   	push   %ebp
  803402:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803404:	6a 00                	push   $0x0
  803406:	6a 00                	push   $0x0
  803408:	6a 00                	push   $0x0
  80340a:	ff 75 0c             	pushl  0xc(%ebp)
  80340d:	ff 75 08             	pushl  0x8(%ebp)
  803410:	6a 2d                	push   $0x2d
  803412:	e8 95 fa ff ff       	call   802eac <syscall>
  803417:	83 c4 18             	add    $0x18,%esp
	return;
  80341a:	90                   	nop
}
  80341b:	c9                   	leave  
  80341c:	c3                   	ret    

0080341d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80341d:	55                   	push   %ebp
  80341e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803420:	6a 00                	push   $0x0
  803422:	6a 00                	push   $0x0
  803424:	6a 00                	push   $0x0
  803426:	ff 75 0c             	pushl  0xc(%ebp)
  803429:	ff 75 08             	pushl  0x8(%ebp)
  80342c:	6a 2c                	push   $0x2c
  80342e:	e8 79 fa ff ff       	call   802eac <syscall>
  803433:	83 c4 18             	add    $0x18,%esp
	return ;
  803436:	90                   	nop
}
  803437:	c9                   	leave  
  803438:	c3                   	ret    

00803439 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803439:	55                   	push   %ebp
  80343a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80343c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	6a 00                	push   $0x0
  803444:	6a 00                	push   $0x0
  803446:	6a 00                	push   $0x0
  803448:	52                   	push   %edx
  803449:	50                   	push   %eax
  80344a:	6a 2e                	push   $0x2e
  80344c:	e8 5b fa ff ff       	call   802eac <syscall>
  803451:	83 c4 18             	add    $0x18,%esp
}
  803454:	90                   	nop
  803455:	c9                   	leave  
  803456:	c3                   	ret    

00803457 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803457:	55                   	push   %ebp
  803458:	89 e5                	mov    %esp,%ebp
  80345a:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80345d:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803464:	72 09                	jb     80346f <to_page_va+0x18>
  803466:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80346d:	72 14                	jb     803483 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80346f:	83 ec 04             	sub    $0x4,%esp
  803472:	68 78 4a 80 00       	push   $0x804a78
  803477:	6a 15                	push   $0x15
  803479:	68 a3 4a 80 00       	push   $0x804aa3
  80347e:	e8 10 d0 ff ff       	call   800493 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  80348b:	29 d0                	sub    %edx,%eax
  80348d:	c1 f8 02             	sar    $0x2,%eax
  803490:	89 c2                	mov    %eax,%edx
  803492:	89 d0                	mov    %edx,%eax
  803494:	c1 e0 02             	shl    $0x2,%eax
  803497:	01 d0                	add    %edx,%eax
  803499:	c1 e0 02             	shl    $0x2,%eax
  80349c:	01 d0                	add    %edx,%eax
  80349e:	c1 e0 02             	shl    $0x2,%eax
  8034a1:	01 d0                	add    %edx,%eax
  8034a3:	89 c1                	mov    %eax,%ecx
  8034a5:	c1 e1 08             	shl    $0x8,%ecx
  8034a8:	01 c8                	add    %ecx,%eax
  8034aa:	89 c1                	mov    %eax,%ecx
  8034ac:	c1 e1 10             	shl    $0x10,%ecx
  8034af:	01 c8                	add    %ecx,%eax
  8034b1:	01 c0                	add    %eax,%eax
  8034b3:	01 d0                	add    %edx,%eax
  8034b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8034b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bb:	c1 e0 0c             	shl    $0xc,%eax
  8034be:	89 c2                	mov    %eax,%edx
  8034c0:	a1 84 50 83 00       	mov    0x835084,%eax
  8034c5:	01 d0                	add    %edx,%eax
}
  8034c7:	c9                   	leave  
  8034c8:	c3                   	ret    

008034c9 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8034c9:	55                   	push   %ebp
  8034ca:	89 e5                	mov    %esp,%ebp
  8034cc:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8034cf:	a1 84 50 83 00       	mov    0x835084,%eax
  8034d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d7:	29 c2                	sub    %eax,%edx
  8034d9:	89 d0                	mov    %edx,%eax
  8034db:	c1 e8 0c             	shr    $0xc,%eax
  8034de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8034e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e5:	78 09                	js     8034f0 <to_page_info+0x27>
  8034e7:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8034ee:	7e 14                	jle    803504 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8034f0:	83 ec 04             	sub    $0x4,%esp
  8034f3:	68 bc 4a 80 00       	push   $0x804abc
  8034f8:	6a 21                	push   $0x21
  8034fa:	68 a3 4a 80 00       	push   $0x804aa3
  8034ff:	e8 8f cf ff ff       	call   800493 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803507:	89 d0                	mov    %edx,%eax
  803509:	01 c0                	add    %eax,%eax
  80350b:	01 d0                	add    %edx,%eax
  80350d:	c1 e0 02             	shl    $0x2,%eax
  803510:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803515:	c9                   	leave  
  803516:	c3                   	ret    

00803517 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803517:	55                   	push   %ebp
  803518:	89 e5                	mov    %esp,%ebp
  80351a:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	05 00 00 00 02       	add    $0x2000000,%eax
  803525:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803528:	73 16                	jae    803540 <initialize_dynamic_allocator+0x29>
  80352a:	68 e0 4a 80 00       	push   $0x804ae0
  80352f:	68 06 4b 80 00       	push   $0x804b06
  803534:	6a 2f                	push   $0x2f
  803536:	68 a3 4a 80 00       	push   $0x804aa3
  80353b:	e8 53 cf ff ff       	call   800493 <_panic>
	dynAllocStart = daStart;
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354b:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803550:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803557:	eb 36                	jmp    80358f <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	c1 e0 04             	shl    $0x4,%eax
  80355f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356d:	c1 e0 04             	shl    $0x4,%eax
  803570:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803575:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357e:	c1 e0 04             	shl    $0x4,%eax
  803581:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803586:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80358c:	ff 45 f4             	incl   -0xc(%ebp)
  80358f:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803593:	7e c4                	jle    803559 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803595:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80359c:	00 00 00 
  80359f:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8035a6:	00 00 00 
  8035a9:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8035b0:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8035b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035ba:	e9 1b 01 00 00       	jmp    8036da <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8035bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035c2:	89 d0                	mov    %edx,%eax
  8035c4:	01 c0                	add    %eax,%eax
  8035c6:	01 d0                	add    %edx,%eax
  8035c8:	c1 e0 02             	shl    $0x2,%eax
  8035cb:	05 88 d0 81 00       	add    $0x81d088,%eax
  8035d0:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8035d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d8:	89 d0                	mov    %edx,%eax
  8035da:	01 c0                	add    %eax,%eax
  8035dc:	01 d0                	add    %edx,%eax
  8035de:	c1 e0 02             	shl    $0x2,%eax
  8035e1:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8035e6:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8035eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ee:	89 d0                	mov    %edx,%eax
  8035f0:	01 c0                	add    %eax,%eax
  8035f2:	01 d0                	add    %edx,%eax
  8035f4:	c1 e0 02             	shl    $0x2,%eax
  8035f7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	85 c0                	test   %eax,%eax
  803600:	74 2b                	je     80362d <initialize_dynamic_allocator+0x116>
  803602:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803605:	89 d0                	mov    %edx,%eax
  803607:	01 c0                	add    %eax,%eax
  803609:	01 d0                	add    %edx,%eax
  80360b:	c1 e0 02             	shl    $0x2,%eax
  80360e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803613:	8b 10                	mov    (%eax),%edx
  803615:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803618:	89 c8                	mov    %ecx,%eax
  80361a:	01 c0                	add    %eax,%eax
  80361c:	01 c8                	add    %ecx,%eax
  80361e:	c1 e0 02             	shl    $0x2,%eax
  803621:	05 84 d0 81 00       	add    $0x81d084,%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	89 42 04             	mov    %eax,0x4(%edx)
  80362b:	eb 18                	jmp    803645 <initialize_dynamic_allocator+0x12e>
  80362d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803630:	89 d0                	mov    %edx,%eax
  803632:	01 c0                	add    %eax,%eax
  803634:	01 d0                	add    %edx,%eax
  803636:	c1 e0 02             	shl    $0x2,%eax
  803639:	05 84 d0 81 00       	add    $0x81d084,%eax
  80363e:	8b 00                	mov    (%eax),%eax
  803640:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803645:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803648:	89 d0                	mov    %edx,%eax
  80364a:	01 c0                	add    %eax,%eax
  80364c:	01 d0                	add    %edx,%eax
  80364e:	c1 e0 02             	shl    $0x2,%eax
  803651:	05 84 d0 81 00       	add    $0x81d084,%eax
  803656:	8b 00                	mov    (%eax),%eax
  803658:	85 c0                	test   %eax,%eax
  80365a:	74 2a                	je     803686 <initialize_dynamic_allocator+0x16f>
  80365c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80365f:	89 d0                	mov    %edx,%eax
  803661:	01 c0                	add    %eax,%eax
  803663:	01 d0                	add    %edx,%eax
  803665:	c1 e0 02             	shl    $0x2,%eax
  803668:	05 84 d0 81 00       	add    $0x81d084,%eax
  80366d:	8b 10                	mov    (%eax),%edx
  80366f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803672:	89 c8                	mov    %ecx,%eax
  803674:	01 c0                	add    %eax,%eax
  803676:	01 c8                	add    %ecx,%eax
  803678:	c1 e0 02             	shl    $0x2,%eax
  80367b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	89 02                	mov    %eax,(%edx)
  803684:	eb 18                	jmp    80369e <initialize_dynamic_allocator+0x187>
  803686:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803689:	89 d0                	mov    %edx,%eax
  80368b:	01 c0                	add    %eax,%eax
  80368d:	01 d0                	add    %edx,%eax
  80368f:	c1 e0 02             	shl    $0x2,%eax
  803692:	05 80 d0 81 00       	add    $0x81d080,%eax
  803697:	8b 00                	mov    (%eax),%eax
  803699:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80369e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a1:	89 d0                	mov    %edx,%eax
  8036a3:	01 c0                	add    %eax,%eax
  8036a5:	01 d0                	add    %edx,%eax
  8036a7:	c1 e0 02             	shl    $0x2,%eax
  8036aa:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036b8:	89 d0                	mov    %edx,%eax
  8036ba:	01 c0                	add    %eax,%eax
  8036bc:	01 d0                	add    %edx,%eax
  8036be:	c1 e0 02             	shl    $0x2,%eax
  8036c1:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036cc:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036d1:	48                   	dec    %eax
  8036d2:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036d7:	ff 45 f0             	incl   -0x10(%ebp)
  8036da:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8036e1:	0f 8e d8 fe ff ff    	jle    8035bf <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036e7:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8036ee:	e9 9d 00 00 00       	jmp    803790 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8036f3:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036f9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036fc:	89 c8                	mov    %ecx,%eax
  8036fe:	01 c0                	add    %eax,%eax
  803700:	01 c8                	add    %ecx,%eax
  803702:	c1 e0 02             	shl    $0x2,%eax
  803705:	05 80 d0 81 00       	add    $0x81d080,%eax
  80370a:	89 10                	mov    %edx,(%eax)
  80370c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80370f:	89 d0                	mov    %edx,%eax
  803711:	01 c0                	add    %eax,%eax
  803713:	01 d0                	add    %edx,%eax
  803715:	c1 e0 02             	shl    $0x2,%eax
  803718:	05 80 d0 81 00       	add    $0x81d080,%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	74 1c                	je     80373f <initialize_dynamic_allocator+0x228>
  803723:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803729:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80372c:	89 c8                	mov    %ecx,%eax
  80372e:	01 c0                	add    %eax,%eax
  803730:	01 c8                	add    %ecx,%eax
  803732:	c1 e0 02             	shl    $0x2,%eax
  803735:	05 80 d0 81 00       	add    $0x81d080,%eax
  80373a:	89 42 04             	mov    %eax,0x4(%edx)
  80373d:	eb 16                	jmp    803755 <initialize_dynamic_allocator+0x23e>
  80373f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803742:	89 d0                	mov    %edx,%eax
  803744:	01 c0                	add    %eax,%eax
  803746:	01 d0                	add    %edx,%eax
  803748:	c1 e0 02             	shl    $0x2,%eax
  80374b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803750:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803755:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803758:	89 d0                	mov    %edx,%eax
  80375a:	01 c0                	add    %eax,%eax
  80375c:	01 d0                	add    %edx,%eax
  80375e:	c1 e0 02             	shl    $0x2,%eax
  803761:	05 80 d0 81 00       	add    $0x81d080,%eax
  803766:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80376b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80376e:	89 d0                	mov    %edx,%eax
  803770:	01 c0                	add    %eax,%eax
  803772:	01 d0                	add    %edx,%eax
  803774:	c1 e0 02             	shl    $0x2,%eax
  803777:	05 84 d0 81 00       	add    $0x81d084,%eax
  80377c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803782:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803787:	40                   	inc    %eax
  803788:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80378d:	ff 4d ec             	decl   -0x14(%ebp)
  803790:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803794:	0f 89 59 ff ff ff    	jns    8036f3 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  80379a:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8037a1:	00 00 00 
}
  8037a4:	90                   	nop
  8037a5:	c9                   	leave  
  8037a6:	c3                   	ret    

008037a7 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8037a7:	55                   	push   %ebp
  8037a8:	89 e5                	mov    %esp,%ebp
  8037aa:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	83 ec 0c             	sub    $0xc,%esp
  8037b3:	50                   	push   %eax
  8037b4:	e8 10 fd ff ff       	call   8034c9 <to_page_info>
  8037b9:	83 c4 10             	add    $0x10,%esp
  8037bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8037bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c2:	8b 40 08             	mov    0x8(%eax),%eax
  8037c5:	0f b7 c0             	movzwl %ax,%eax
}
  8037c8:	c9                   	leave  
  8037c9:	c3                   	ret    

008037ca <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037ca:	55                   	push   %ebp
  8037cb:	89 e5                	mov    %esp,%ebp
  8037cd:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037d0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037d7:	76 16                	jbe    8037ef <alloc_block+0x25>
  8037d9:	68 1c 4b 80 00       	push   $0x804b1c
  8037de:	68 06 4b 80 00       	push   $0x804b06
  8037e3:	6a 59                	push   $0x59
  8037e5:	68 a3 4a 80 00       	push   $0x804aa3
  8037ea:	e8 a4 cc ff ff       	call   800493 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8037ef:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037f6:	eb 08                	jmp    803800 <alloc_block+0x36>
		allocSize <<= 1;
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	01 c0                	add    %eax,%eax
  8037fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	3b 45 08             	cmp    0x8(%ebp),%eax
  803806:	73 09                	jae    803811 <alloc_block+0x47>
  803808:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80380f:	76 e7                	jbe    8037f8 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803811:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803818:	eb 03                	jmp    80381d <alloc_block+0x53>
		listIndex++;
  80381a:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80381d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803820:	ba 08 00 00 00       	mov    $0x8,%edx
  803825:	88 c1                	mov    %al,%cl
  803827:	d3 e2                	shl    %cl,%edx
  803829:	89 d0                	mov    %edx,%eax
  80382b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80382e:	72 ea                	jb     80381a <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803833:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803836:	e9 f4 00 00 00       	jmp    80392f <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80383b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80383e:	c1 e0 04             	shl    $0x4,%eax
  803841:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803846:	8b 00                	mov    (%eax),%eax
  803848:	85 c0                	test   %eax,%eax
  80384a:	0f 84 dc 00 00 00    	je     80392c <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803853:	c1 e0 04             	shl    $0x4,%eax
  803856:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803860:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803864:	75 14                	jne    80387a <alloc_block+0xb0>
  803866:	83 ec 04             	sub    $0x4,%esp
  803869:	68 3d 4b 80 00       	push   $0x804b3d
  80386e:	6a 6b                	push   $0x6b
  803870:	68 a3 4a 80 00       	push   $0x804aa3
  803875:	e8 19 cc ff ff       	call   800493 <_panic>
  80387a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387d:	8b 00                	mov    (%eax),%eax
  80387f:	85 c0                	test   %eax,%eax
  803881:	74 10                	je     803893 <alloc_block+0xc9>
  803883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803886:	8b 00                	mov    (%eax),%eax
  803888:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80388b:	8b 52 04             	mov    0x4(%edx),%edx
  80388e:	89 50 04             	mov    %edx,0x4(%eax)
  803891:	eb 14                	jmp    8038a7 <alloc_block+0xdd>
  803893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803896:	8b 40 04             	mov    0x4(%eax),%eax
  803899:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80389c:	c1 e2 04             	shl    $0x4,%edx
  80389f:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8038a5:	89 02                	mov    %eax,(%edx)
  8038a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038aa:	8b 40 04             	mov    0x4(%eax),%eax
  8038ad:	85 c0                	test   %eax,%eax
  8038af:	74 0f                	je     8038c0 <alloc_block+0xf6>
  8038b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b4:	8b 40 04             	mov    0x4(%eax),%eax
  8038b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ba:	8b 12                	mov    (%edx),%edx
  8038bc:	89 10                	mov    %edx,(%eax)
  8038be:	eb 13                	jmp    8038d3 <alloc_block+0x109>
  8038c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c3:	8b 00                	mov    (%eax),%eax
  8038c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038c8:	c1 e2 04             	shl    $0x4,%edx
  8038cb:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8038d1:	89 02                	mov    %eax,(%edx)
  8038d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038e9:	c1 e0 04             	shl    $0x4,%eax
  8038ec:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f9:	c1 e0 04             	shl    $0x4,%eax
  8038fc:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803901:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803906:	83 ec 0c             	sub    $0xc,%esp
  803909:	50                   	push   %eax
  80390a:	e8 ba fb ff ff       	call   8034c9 <to_page_info>
  80390f:	83 c4 10             	add    $0x10,%esp
  803912:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803915:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803918:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80391c:	48                   	dec    %eax
  80391d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803920:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803927:	e9 8f 02 00 00       	jmp    803bbb <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80392c:	ff 45 ec             	incl   -0x14(%ebp)
  80392f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803933:	0f 8e 02 ff ff ff    	jle    80383b <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803939:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80393e:	85 c0                	test   %eax,%eax
  803940:	75 14                	jne    803956 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803942:	83 ec 04             	sub    $0x4,%esp
  803945:	68 5c 4b 80 00       	push   $0x804b5c
  80394a:	6a 77                	push   $0x77
  80394c:	68 a3 4a 80 00       	push   $0x804aa3
  803951:	e8 3d cb ff ff       	call   800493 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803956:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80395b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80395e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803962:	75 14                	jne    803978 <alloc_block+0x1ae>
  803964:	83 ec 04             	sub    $0x4,%esp
  803967:	68 3d 4b 80 00       	push   $0x804b3d
  80396c:	6a 7a                	push   $0x7a
  80396e:	68 a3 4a 80 00       	push   $0x804aa3
  803973:	e8 1b cb ff ff       	call   800493 <_panic>
  803978:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397b:	8b 00                	mov    (%eax),%eax
  80397d:	85 c0                	test   %eax,%eax
  80397f:	74 10                	je     803991 <alloc_block+0x1c7>
  803981:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803984:	8b 00                	mov    (%eax),%eax
  803986:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803989:	8b 52 04             	mov    0x4(%edx),%edx
  80398c:	89 50 04             	mov    %edx,0x4(%eax)
  80398f:	eb 0b                	jmp    80399c <alloc_block+0x1d2>
  803991:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803994:	8b 40 04             	mov    0x4(%eax),%eax
  803997:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80399c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399f:	8b 40 04             	mov    0x4(%eax),%eax
  8039a2:	85 c0                	test   %eax,%eax
  8039a4:	74 0f                	je     8039b5 <alloc_block+0x1eb>
  8039a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a9:	8b 40 04             	mov    0x4(%eax),%eax
  8039ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039af:	8b 12                	mov    (%edx),%edx
  8039b1:	89 10                	mov    %edx,(%eax)
  8039b3:	eb 0a                	jmp    8039bf <alloc_block+0x1f5>
  8039b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b8:	8b 00                	mov    (%eax),%eax
  8039ba:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8039bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d2:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8039d7:	48                   	dec    %eax
  8039d8:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8039dd:	83 ec 0c             	sub    $0xc,%esp
  8039e0:	ff 75 dc             	pushl  -0x24(%ebp)
  8039e3:	e8 6f fa ff ff       	call   803457 <to_page_va>
  8039e8:	83 c4 10             	add    $0x10,%esp
  8039eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8039ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039f1:	83 ec 0c             	sub    $0xc,%esp
  8039f4:	50                   	push   %eax
  8039f5:	e8 a0 dc ff ff       	call   80169a <get_page>
  8039fa:	83 c4 10             	add    $0x10,%esp
  8039fd:	85 c0                	test   %eax,%eax
  8039ff:	74 14                	je     803a15 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803a01:	83 ec 04             	sub    $0x4,%esp
  803a04:	68 84 4b 80 00       	push   $0x804b84
  803a09:	6a 7f                	push   $0x7f
  803a0b:	68 a3 4a 80 00       	push   $0x804aa3
  803a10:	e8 7e ca ff ff       	call   800493 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a18:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a1b:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803a1f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a24:	ba 00 00 00 00       	mov    $0x0,%edx
  803a29:	f7 75 f4             	divl   -0xc(%ebp)
  803a2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a2f:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a33:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a3a:	e9 a7 00 00 00       	jmp    803ae6 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a3f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a45:	01 d0                	add    %edx,%eax
  803a47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a4a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a4e:	75 17                	jne    803a67 <alloc_block+0x29d>
  803a50:	83 ec 04             	sub    $0x4,%esp
  803a53:	68 ac 4b 80 00       	push   $0x804bac
  803a58:	68 88 00 00 00       	push   $0x88
  803a5d:	68 a3 4a 80 00       	push   $0x804aa3
  803a62:	e8 2c ca ff ff       	call   800493 <_panic>
  803a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6a:	c1 e0 04             	shl    $0x4,%eax
  803a6d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a72:	8b 10                	mov    (%eax),%edx
  803a74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a77:	89 10                	mov    %edx,(%eax)
  803a79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a7c:	8b 00                	mov    (%eax),%eax
  803a7e:	85 c0                	test   %eax,%eax
  803a80:	74 15                	je     803a97 <alloc_block+0x2cd>
  803a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a85:	c1 e0 04             	shl    $0x4,%eax
  803a88:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a8d:	8b 00                	mov    (%eax),%eax
  803a8f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a92:	89 50 04             	mov    %edx,0x4(%eax)
  803a95:	eb 11                	jmp    803aa8 <alloc_block+0x2de>
  803a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a9a:	c1 e0 04             	shl    $0x4,%eax
  803a9d:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803aa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa6:	89 02                	mov    %eax,(%edx)
  803aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aab:	c1 e0 04             	shl    $0x4,%eax
  803aae:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803ab4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab7:	89 02                	mov    %eax,(%edx)
  803ab9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac6:	c1 e0 04             	shl    $0x4,%eax
  803ac9:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ace:	8b 00                	mov    (%eax),%eax
  803ad0:	8d 50 01             	lea    0x1(%eax),%edx
  803ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad6:	c1 e0 04             	shl    $0x4,%eax
  803ad9:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ade:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae3:	01 45 e8             	add    %eax,-0x18(%ebp)
  803ae6:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803aed:	0f 86 4c ff ff ff    	jbe    803a3f <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af6:	c1 e0 04             	shl    $0x4,%eax
  803af9:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803afe:	8b 00                	mov    (%eax),%eax
  803b00:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803b03:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b07:	75 17                	jne    803b20 <alloc_block+0x356>
  803b09:	83 ec 04             	sub    $0x4,%esp
  803b0c:	68 3d 4b 80 00       	push   $0x804b3d
  803b11:	68 8d 00 00 00       	push   $0x8d
  803b16:	68 a3 4a 80 00       	push   $0x804aa3
  803b1b:	e8 73 c9 ff ff       	call   800493 <_panic>
  803b20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b23:	8b 00                	mov    (%eax),%eax
  803b25:	85 c0                	test   %eax,%eax
  803b27:	74 10                	je     803b39 <alloc_block+0x36f>
  803b29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b2c:	8b 00                	mov    (%eax),%eax
  803b2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b31:	8b 52 04             	mov    0x4(%edx),%edx
  803b34:	89 50 04             	mov    %edx,0x4(%eax)
  803b37:	eb 14                	jmp    803b4d <alloc_block+0x383>
  803b39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b3c:	8b 40 04             	mov    0x4(%eax),%eax
  803b3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b42:	c1 e2 04             	shl    $0x4,%edx
  803b45:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803b4b:	89 02                	mov    %eax,(%edx)
  803b4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b50:	8b 40 04             	mov    0x4(%eax),%eax
  803b53:	85 c0                	test   %eax,%eax
  803b55:	74 0f                	je     803b66 <alloc_block+0x39c>
  803b57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b5a:	8b 40 04             	mov    0x4(%eax),%eax
  803b5d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b60:	8b 12                	mov    (%edx),%edx
  803b62:	89 10                	mov    %edx,(%eax)
  803b64:	eb 13                	jmp    803b79 <alloc_block+0x3af>
  803b66:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b69:	8b 00                	mov    (%eax),%eax
  803b6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b6e:	c1 e2 04             	shl    $0x4,%edx
  803b71:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b77:	89 02                	mov    %eax,(%edx)
  803b79:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8f:	c1 e0 04             	shl    $0x4,%eax
  803b92:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b97:	8b 00                	mov    (%eax),%eax
  803b99:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9f:	c1 e0 04             	shl    $0x4,%eax
  803ba2:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ba7:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bac:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803bb0:	48                   	dec    %eax
  803bb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bb4:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803bb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803bbb:	c9                   	leave  
  803bbc:	c3                   	ret    

00803bbd <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803bbd:	55                   	push   %ebp
  803bbe:	89 e5                	mov    %esp,%ebp
  803bc0:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803bc3:	8b 55 08             	mov    0x8(%ebp),%edx
  803bc6:	a1 84 50 83 00       	mov    0x835084,%eax
  803bcb:	39 c2                	cmp    %eax,%edx
  803bcd:	72 0c                	jb     803bdb <free_block+0x1e>
  803bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  803bd2:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803bd7:	39 c2                	cmp    %eax,%edx
  803bd9:	72 19                	jb     803bf4 <free_block+0x37>
  803bdb:	68 d0 4b 80 00       	push   $0x804bd0
  803be0:	68 06 4b 80 00       	push   $0x804b06
  803be5:	68 98 00 00 00       	push   $0x98
  803bea:	68 a3 4a 80 00       	push   $0x804aa3
  803bef:	e8 9f c8 ff ff       	call   800493 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf7:	83 ec 0c             	sub    $0xc,%esp
  803bfa:	50                   	push   %eax
  803bfb:	e8 c9 f8 ff ff       	call   8034c9 <to_page_info>
  803c00:	83 c4 10             	add    $0x10,%esp
  803c03:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c09:	8b 40 08             	mov    0x8(%eax),%eax
  803c0c:	0f b7 c0             	movzwl %ax,%eax
  803c0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c19:	eb 03                	jmp    803c1e <free_block+0x61>
		listIndex++;
  803c1b:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c21:	ba 08 00 00 00       	mov    $0x8,%edx
  803c26:	88 c1                	mov    %al,%cl
  803c28:	d3 e2                	shl    %cl,%edx
  803c2a:	89 d0                	mov    %edx,%eax
  803c2c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c2f:	72 ea                	jb     803c1b <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803c31:	8b 45 08             	mov    0x8(%ebp),%eax
  803c34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c3b:	75 17                	jne    803c54 <free_block+0x97>
  803c3d:	83 ec 04             	sub    $0x4,%esp
  803c40:	68 ac 4b 80 00       	push   $0x804bac
  803c45:	68 a2 00 00 00       	push   $0xa2
  803c4a:	68 a3 4a 80 00       	push   $0x804aa3
  803c4f:	e8 3f c8 ff ff       	call   800493 <_panic>
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	c1 e0 04             	shl    $0x4,%eax
  803c5a:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c5f:	8b 10                	mov    (%eax),%edx
  803c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c64:	89 10                	mov    %edx,(%eax)
  803c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c69:	8b 00                	mov    (%eax),%eax
  803c6b:	85 c0                	test   %eax,%eax
  803c6d:	74 15                	je     803c84 <free_block+0xc7>
  803c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c72:	c1 e0 04             	shl    $0x4,%eax
  803c75:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c7a:	8b 00                	mov    (%eax),%eax
  803c7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c7f:	89 50 04             	mov    %edx,0x4(%eax)
  803c82:	eb 11                	jmp    803c95 <free_block+0xd8>
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	c1 e0 04             	shl    $0x4,%eax
  803c8a:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c93:	89 02                	mov    %eax,(%edx)
  803c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c98:	c1 e0 04             	shl    $0x4,%eax
  803c9b:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803ca1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca4:	89 02                	mov    %eax,(%edx)
  803ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb3:	c1 e0 04             	shl    $0x4,%eax
  803cb6:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cbb:	8b 00                	mov    (%eax),%eax
  803cbd:	8d 50 01             	lea    0x1(%eax),%edx
  803cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc3:	c1 e0 04             	shl    $0x4,%eax
  803cc6:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ccb:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cd0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cd4:	40                   	inc    %eax
  803cd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cd8:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cdf:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ce3:	0f b7 c8             	movzwl %ax,%ecx
  803ce6:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  803cf0:	f7 75 e8             	divl   -0x18(%ebp)
  803cf3:	39 c1                	cmp    %eax,%ecx
  803cf5:	0f 85 ed 01 00 00    	jne    803ee8 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfe:	c1 e0 04             	shl    $0x4,%eax
  803d01:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d06:	8b 00                	mov    (%eax),%eax
  803d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d0b:	eb 2a                	jmp    803d37 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d10:	83 ec 0c             	sub    $0xc,%esp
  803d13:	50                   	push   %eax
  803d14:	e8 b0 f7 ff ff       	call   8034c9 <to_page_info>
  803d19:	83 c4 10             	add    $0x10,%esp
  803d1c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d1f:	75 06                	jne    803d27 <free_block+0x16a>
				tmp = b;
  803d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d24:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2a:	c1 e0 04             	shl    $0x4,%eax
  803d2d:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d32:	8b 00                	mov    (%eax),%eax
  803d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d3b:	74 07                	je     803d44 <free_block+0x187>
  803d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d40:	8b 00                	mov    (%eax),%eax
  803d42:	eb 05                	jmp    803d49 <free_block+0x18c>
  803d44:	b8 00 00 00 00       	mov    $0x0,%eax
  803d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d4c:	c1 e2 04             	shl    $0x4,%edx
  803d4f:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d55:	89 02                	mov    %eax,(%edx)
  803d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5a:	c1 e0 04             	shl    $0x4,%eax
  803d5d:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d62:	8b 00                	mov    (%eax),%eax
  803d64:	85 c0                	test   %eax,%eax
  803d66:	75 a5                	jne    803d0d <free_block+0x150>
  803d68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d6c:	75 9f                	jne    803d0d <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d71:	c1 e0 04             	shl    $0x4,%eax
  803d74:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d79:	8b 00                	mov    (%eax),%eax
  803d7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d7e:	e9 cc 00 00 00       	jmp    803e4f <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d86:	8b 00                	mov    (%eax),%eax
  803d88:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d8e:	83 ec 0c             	sub    $0xc,%esp
  803d91:	50                   	push   %eax
  803d92:	e8 32 f7 ff ff       	call   8034c9 <to_page_info>
  803d97:	83 c4 10             	add    $0x10,%esp
  803d9a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d9d:	0f 85 a6 00 00 00    	jne    803e49 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803da3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803da7:	75 17                	jne    803dc0 <free_block+0x203>
  803da9:	83 ec 04             	sub    $0x4,%esp
  803dac:	68 3d 4b 80 00       	push   $0x804b3d
  803db1:	68 b5 00 00 00       	push   $0xb5
  803db6:	68 a3 4a 80 00       	push   $0x804aa3
  803dbb:	e8 d3 c6 ff ff       	call   800493 <_panic>
  803dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc3:	8b 00                	mov    (%eax),%eax
  803dc5:	85 c0                	test   %eax,%eax
  803dc7:	74 10                	je     803dd9 <free_block+0x21c>
  803dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dcc:	8b 00                	mov    (%eax),%eax
  803dce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dd1:	8b 52 04             	mov    0x4(%edx),%edx
  803dd4:	89 50 04             	mov    %edx,0x4(%eax)
  803dd7:	eb 14                	jmp    803ded <free_block+0x230>
  803dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddc:	8b 40 04             	mov    0x4(%eax),%eax
  803ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803de2:	c1 e2 04             	shl    $0x4,%edx
  803de5:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803deb:	89 02                	mov    %eax,(%edx)
  803ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df0:	8b 40 04             	mov    0x4(%eax),%eax
  803df3:	85 c0                	test   %eax,%eax
  803df5:	74 0f                	je     803e06 <free_block+0x249>
  803df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfa:	8b 40 04             	mov    0x4(%eax),%eax
  803dfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e00:	8b 12                	mov    (%edx),%edx
  803e02:	89 10                	mov    %edx,(%eax)
  803e04:	eb 13                	jmp    803e19 <free_block+0x25c>
  803e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e09:	8b 00                	mov    (%eax),%eax
  803e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e0e:	c1 e2 04             	shl    $0x4,%edx
  803e11:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803e17:	89 02                	mov    %eax,(%edx)
  803e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2f:	c1 e0 04             	shl    $0x4,%eax
  803e32:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e37:	8b 00                	mov    (%eax),%eax
  803e39:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3f:	c1 e0 04             	shl    $0x4,%eax
  803e42:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e47:	89 10                	mov    %edx,(%eax)
			b = next;
  803e49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e53:	0f 85 2a ff ff ff    	jne    803d83 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e5c:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e65:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e6f:	75 17                	jne    803e88 <free_block+0x2cb>
  803e71:	83 ec 04             	sub    $0x4,%esp
  803e74:	68 ac 4b 80 00       	push   $0x804bac
  803e79:	68 bc 00 00 00       	push   $0xbc
  803e7e:	68 a3 4a 80 00       	push   $0x804aa3
  803e83:	e8 0b c6 ff ff       	call   800493 <_panic>
  803e88:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e91:	89 10                	mov    %edx,(%eax)
  803e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e96:	8b 00                	mov    (%eax),%eax
  803e98:	85 c0                	test   %eax,%eax
  803e9a:	74 0d                	je     803ea9 <free_block+0x2ec>
  803e9c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803ea1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ea4:	89 50 04             	mov    %edx,0x4(%eax)
  803ea7:	eb 08                	jmp    803eb1 <free_block+0x2f4>
  803ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eac:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eb4:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ec3:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803ec8:	40                   	inc    %eax
  803ec9:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803ece:	83 ec 0c             	sub    $0xc,%esp
  803ed1:	ff 75 ec             	pushl  -0x14(%ebp)
  803ed4:	e8 7e f5 ff ff       	call   803457 <to_page_va>
  803ed9:	83 c4 10             	add    $0x10,%esp
  803edc:	83 ec 0c             	sub    $0xc,%esp
  803edf:	50                   	push   %eax
  803ee0:	e8 fe d7 ff ff       	call   8016e3 <return_page>
  803ee5:	83 c4 10             	add    $0x10,%esp
	}
}
  803ee8:	90                   	nop
  803ee9:	c9                   	leave  
  803eea:	c3                   	ret    
  803eeb:	90                   	nop

00803eec <__udivdi3>:
  803eec:	55                   	push   %ebp
  803eed:	57                   	push   %edi
  803eee:	56                   	push   %esi
  803eef:	53                   	push   %ebx
  803ef0:	83 ec 1c             	sub    $0x1c,%esp
  803ef3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ef7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803efb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803eff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f03:	89 ca                	mov    %ecx,%edx
  803f05:	89 f8                	mov    %edi,%eax
  803f07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f0b:	85 f6                	test   %esi,%esi
  803f0d:	75 2d                	jne    803f3c <__udivdi3+0x50>
  803f0f:	39 cf                	cmp    %ecx,%edi
  803f11:	77 65                	ja     803f78 <__udivdi3+0x8c>
  803f13:	89 fd                	mov    %edi,%ebp
  803f15:	85 ff                	test   %edi,%edi
  803f17:	75 0b                	jne    803f24 <__udivdi3+0x38>
  803f19:	b8 01 00 00 00       	mov    $0x1,%eax
  803f1e:	31 d2                	xor    %edx,%edx
  803f20:	f7 f7                	div    %edi
  803f22:	89 c5                	mov    %eax,%ebp
  803f24:	31 d2                	xor    %edx,%edx
  803f26:	89 c8                	mov    %ecx,%eax
  803f28:	f7 f5                	div    %ebp
  803f2a:	89 c1                	mov    %eax,%ecx
  803f2c:	89 d8                	mov    %ebx,%eax
  803f2e:	f7 f5                	div    %ebp
  803f30:	89 cf                	mov    %ecx,%edi
  803f32:	89 fa                	mov    %edi,%edx
  803f34:	83 c4 1c             	add    $0x1c,%esp
  803f37:	5b                   	pop    %ebx
  803f38:	5e                   	pop    %esi
  803f39:	5f                   	pop    %edi
  803f3a:	5d                   	pop    %ebp
  803f3b:	c3                   	ret    
  803f3c:	39 ce                	cmp    %ecx,%esi
  803f3e:	77 28                	ja     803f68 <__udivdi3+0x7c>
  803f40:	0f bd fe             	bsr    %esi,%edi
  803f43:	83 f7 1f             	xor    $0x1f,%edi
  803f46:	75 40                	jne    803f88 <__udivdi3+0x9c>
  803f48:	39 ce                	cmp    %ecx,%esi
  803f4a:	72 0a                	jb     803f56 <__udivdi3+0x6a>
  803f4c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f50:	0f 87 9e 00 00 00    	ja     803ff4 <__udivdi3+0x108>
  803f56:	b8 01 00 00 00       	mov    $0x1,%eax
  803f5b:	89 fa                	mov    %edi,%edx
  803f5d:	83 c4 1c             	add    $0x1c,%esp
  803f60:	5b                   	pop    %ebx
  803f61:	5e                   	pop    %esi
  803f62:	5f                   	pop    %edi
  803f63:	5d                   	pop    %ebp
  803f64:	c3                   	ret    
  803f65:	8d 76 00             	lea    0x0(%esi),%esi
  803f68:	31 ff                	xor    %edi,%edi
  803f6a:	31 c0                	xor    %eax,%eax
  803f6c:	89 fa                	mov    %edi,%edx
  803f6e:	83 c4 1c             	add    $0x1c,%esp
  803f71:	5b                   	pop    %ebx
  803f72:	5e                   	pop    %esi
  803f73:	5f                   	pop    %edi
  803f74:	5d                   	pop    %ebp
  803f75:	c3                   	ret    
  803f76:	66 90                	xchg   %ax,%ax
  803f78:	89 d8                	mov    %ebx,%eax
  803f7a:	f7 f7                	div    %edi
  803f7c:	31 ff                	xor    %edi,%edi
  803f7e:	89 fa                	mov    %edi,%edx
  803f80:	83 c4 1c             	add    $0x1c,%esp
  803f83:	5b                   	pop    %ebx
  803f84:	5e                   	pop    %esi
  803f85:	5f                   	pop    %edi
  803f86:	5d                   	pop    %ebp
  803f87:	c3                   	ret    
  803f88:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f8d:	89 eb                	mov    %ebp,%ebx
  803f8f:	29 fb                	sub    %edi,%ebx
  803f91:	89 f9                	mov    %edi,%ecx
  803f93:	d3 e6                	shl    %cl,%esi
  803f95:	89 c5                	mov    %eax,%ebp
  803f97:	88 d9                	mov    %bl,%cl
  803f99:	d3 ed                	shr    %cl,%ebp
  803f9b:	89 e9                	mov    %ebp,%ecx
  803f9d:	09 f1                	or     %esi,%ecx
  803f9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803fa3:	89 f9                	mov    %edi,%ecx
  803fa5:	d3 e0                	shl    %cl,%eax
  803fa7:	89 c5                	mov    %eax,%ebp
  803fa9:	89 d6                	mov    %edx,%esi
  803fab:	88 d9                	mov    %bl,%cl
  803fad:	d3 ee                	shr    %cl,%esi
  803faf:	89 f9                	mov    %edi,%ecx
  803fb1:	d3 e2                	shl    %cl,%edx
  803fb3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fb7:	88 d9                	mov    %bl,%cl
  803fb9:	d3 e8                	shr    %cl,%eax
  803fbb:	09 c2                	or     %eax,%edx
  803fbd:	89 d0                	mov    %edx,%eax
  803fbf:	89 f2                	mov    %esi,%edx
  803fc1:	f7 74 24 0c          	divl   0xc(%esp)
  803fc5:	89 d6                	mov    %edx,%esi
  803fc7:	89 c3                	mov    %eax,%ebx
  803fc9:	f7 e5                	mul    %ebp
  803fcb:	39 d6                	cmp    %edx,%esi
  803fcd:	72 19                	jb     803fe8 <__udivdi3+0xfc>
  803fcf:	74 0b                	je     803fdc <__udivdi3+0xf0>
  803fd1:	89 d8                	mov    %ebx,%eax
  803fd3:	31 ff                	xor    %edi,%edi
  803fd5:	e9 58 ff ff ff       	jmp    803f32 <__udivdi3+0x46>
  803fda:	66 90                	xchg   %ax,%ax
  803fdc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803fe0:	89 f9                	mov    %edi,%ecx
  803fe2:	d3 e2                	shl    %cl,%edx
  803fe4:	39 c2                	cmp    %eax,%edx
  803fe6:	73 e9                	jae    803fd1 <__udivdi3+0xe5>
  803fe8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803feb:	31 ff                	xor    %edi,%edi
  803fed:	e9 40 ff ff ff       	jmp    803f32 <__udivdi3+0x46>
  803ff2:	66 90                	xchg   %ax,%ax
  803ff4:	31 c0                	xor    %eax,%eax
  803ff6:	e9 37 ff ff ff       	jmp    803f32 <__udivdi3+0x46>
  803ffb:	90                   	nop

00803ffc <__umoddi3>:
  803ffc:	55                   	push   %ebp
  803ffd:	57                   	push   %edi
  803ffe:	56                   	push   %esi
  803fff:	53                   	push   %ebx
  804000:	83 ec 1c             	sub    $0x1c,%esp
  804003:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804007:	8b 74 24 34          	mov    0x34(%esp),%esi
  80400b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80400f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804013:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804017:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80401b:	89 f3                	mov    %esi,%ebx
  80401d:	89 fa                	mov    %edi,%edx
  80401f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804023:	89 34 24             	mov    %esi,(%esp)
  804026:	85 c0                	test   %eax,%eax
  804028:	75 1a                	jne    804044 <__umoddi3+0x48>
  80402a:	39 f7                	cmp    %esi,%edi
  80402c:	0f 86 a2 00 00 00    	jbe    8040d4 <__umoddi3+0xd8>
  804032:	89 c8                	mov    %ecx,%eax
  804034:	89 f2                	mov    %esi,%edx
  804036:	f7 f7                	div    %edi
  804038:	89 d0                	mov    %edx,%eax
  80403a:	31 d2                	xor    %edx,%edx
  80403c:	83 c4 1c             	add    $0x1c,%esp
  80403f:	5b                   	pop    %ebx
  804040:	5e                   	pop    %esi
  804041:	5f                   	pop    %edi
  804042:	5d                   	pop    %ebp
  804043:	c3                   	ret    
  804044:	39 f0                	cmp    %esi,%eax
  804046:	0f 87 ac 00 00 00    	ja     8040f8 <__umoddi3+0xfc>
  80404c:	0f bd e8             	bsr    %eax,%ebp
  80404f:	83 f5 1f             	xor    $0x1f,%ebp
  804052:	0f 84 ac 00 00 00    	je     804104 <__umoddi3+0x108>
  804058:	bf 20 00 00 00       	mov    $0x20,%edi
  80405d:	29 ef                	sub    %ebp,%edi
  80405f:	89 fe                	mov    %edi,%esi
  804061:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804065:	89 e9                	mov    %ebp,%ecx
  804067:	d3 e0                	shl    %cl,%eax
  804069:	89 d7                	mov    %edx,%edi
  80406b:	89 f1                	mov    %esi,%ecx
  80406d:	d3 ef                	shr    %cl,%edi
  80406f:	09 c7                	or     %eax,%edi
  804071:	89 e9                	mov    %ebp,%ecx
  804073:	d3 e2                	shl    %cl,%edx
  804075:	89 14 24             	mov    %edx,(%esp)
  804078:	89 d8                	mov    %ebx,%eax
  80407a:	d3 e0                	shl    %cl,%eax
  80407c:	89 c2                	mov    %eax,%edx
  80407e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804082:	d3 e0                	shl    %cl,%eax
  804084:	89 44 24 04          	mov    %eax,0x4(%esp)
  804088:	8b 44 24 08          	mov    0x8(%esp),%eax
  80408c:	89 f1                	mov    %esi,%ecx
  80408e:	d3 e8                	shr    %cl,%eax
  804090:	09 d0                	or     %edx,%eax
  804092:	d3 eb                	shr    %cl,%ebx
  804094:	89 da                	mov    %ebx,%edx
  804096:	f7 f7                	div    %edi
  804098:	89 d3                	mov    %edx,%ebx
  80409a:	f7 24 24             	mull   (%esp)
  80409d:	89 c6                	mov    %eax,%esi
  80409f:	89 d1                	mov    %edx,%ecx
  8040a1:	39 d3                	cmp    %edx,%ebx
  8040a3:	0f 82 87 00 00 00    	jb     804130 <__umoddi3+0x134>
  8040a9:	0f 84 91 00 00 00    	je     804140 <__umoddi3+0x144>
  8040af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040b3:	29 f2                	sub    %esi,%edx
  8040b5:	19 cb                	sbb    %ecx,%ebx
  8040b7:	89 d8                	mov    %ebx,%eax
  8040b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040bd:	d3 e0                	shl    %cl,%eax
  8040bf:	89 e9                	mov    %ebp,%ecx
  8040c1:	d3 ea                	shr    %cl,%edx
  8040c3:	09 d0                	or     %edx,%eax
  8040c5:	89 e9                	mov    %ebp,%ecx
  8040c7:	d3 eb                	shr    %cl,%ebx
  8040c9:	89 da                	mov    %ebx,%edx
  8040cb:	83 c4 1c             	add    $0x1c,%esp
  8040ce:	5b                   	pop    %ebx
  8040cf:	5e                   	pop    %esi
  8040d0:	5f                   	pop    %edi
  8040d1:	5d                   	pop    %ebp
  8040d2:	c3                   	ret    
  8040d3:	90                   	nop
  8040d4:	89 fd                	mov    %edi,%ebp
  8040d6:	85 ff                	test   %edi,%edi
  8040d8:	75 0b                	jne    8040e5 <__umoddi3+0xe9>
  8040da:	b8 01 00 00 00       	mov    $0x1,%eax
  8040df:	31 d2                	xor    %edx,%edx
  8040e1:	f7 f7                	div    %edi
  8040e3:	89 c5                	mov    %eax,%ebp
  8040e5:	89 f0                	mov    %esi,%eax
  8040e7:	31 d2                	xor    %edx,%edx
  8040e9:	f7 f5                	div    %ebp
  8040eb:	89 c8                	mov    %ecx,%eax
  8040ed:	f7 f5                	div    %ebp
  8040ef:	89 d0                	mov    %edx,%eax
  8040f1:	e9 44 ff ff ff       	jmp    80403a <__umoddi3+0x3e>
  8040f6:	66 90                	xchg   %ax,%ax
  8040f8:	89 c8                	mov    %ecx,%eax
  8040fa:	89 f2                	mov    %esi,%edx
  8040fc:	83 c4 1c             	add    $0x1c,%esp
  8040ff:	5b                   	pop    %ebx
  804100:	5e                   	pop    %esi
  804101:	5f                   	pop    %edi
  804102:	5d                   	pop    %ebp
  804103:	c3                   	ret    
  804104:	3b 04 24             	cmp    (%esp),%eax
  804107:	72 06                	jb     80410f <__umoddi3+0x113>
  804109:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80410d:	77 0f                	ja     80411e <__umoddi3+0x122>
  80410f:	89 f2                	mov    %esi,%edx
  804111:	29 f9                	sub    %edi,%ecx
  804113:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804117:	89 14 24             	mov    %edx,(%esp)
  80411a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80411e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804122:	8b 14 24             	mov    (%esp),%edx
  804125:	83 c4 1c             	add    $0x1c,%esp
  804128:	5b                   	pop    %ebx
  804129:	5e                   	pop    %esi
  80412a:	5f                   	pop    %edi
  80412b:	5d                   	pop    %ebp
  80412c:	c3                   	ret    
  80412d:	8d 76 00             	lea    0x0(%esi),%esi
  804130:	2b 04 24             	sub    (%esp),%eax
  804133:	19 fa                	sbb    %edi,%edx
  804135:	89 d1                	mov    %edx,%ecx
  804137:	89 c6                	mov    %eax,%esi
  804139:	e9 71 ff ff ff       	jmp    8040af <__umoddi3+0xb3>
  80413e:	66 90                	xchg   %ax,%ax
  804140:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804144:	72 ea                	jb     804130 <__umoddi3+0x134>
  804146:	89 d9                	mov    %ebx,%ecx
  804148:	e9 62 ff ff ff       	jmp    8040af <__umoddi3+0xb3>
