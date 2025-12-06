
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 a3 05 00 00       	call   8005d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_dynalloc_datastruct>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_dynalloc_datastruct(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_dynalloc_datastruct+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 60 44 80 00       	push   $0x804460
  80005a:	e8 f8 09 00 00       	call   800a57 <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_dynalloc_datastruct+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_dynalloc_datastruct+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 90 44 80 00       	push   $0x804490
  8000aa:	e8 a8 09 00 00       	call   800a57 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	81 ec a4 00 00 00    	sub    $0xa4,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000ca:	a1 40 60 80 00       	mov    0x806040,%eax
  8000cf:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  8000d5:	a1 40 60 80 00       	mov    0x806040,%eax
  8000da:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e0:	39 c2                	cmp    %eax,%edx
  8000e2:	72 14                	jb     8000f8 <_main+0x38>
			panic("Please increase the WS size");
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	68 c9 44 80 00       	push   $0x8044c9
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 e5 44 80 00       	push   $0x8044e5
  8000f3:	e8 91 06 00 00       	call   800789 <_panic>
#endif

	/*=================================================*/


	int eval = 0;
  8000f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800106:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  80010d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800114:	e8 f3 31 00 00       	call   80330c <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 a0 31 00 00       	call   8032c1 <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 fc 44 80 00       	push   $0x8044fc
  80012c:	e8 26 09 00 00       	call   800a57 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800134:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
  80013b:	c7 45 e0 04 00 00 80 	movl   $0x80000004,-0x20(%ebp)
		curTotalSize = sizeof(int);
  800142:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  800149:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800150:	e9 b6 01 00 00       	jmp    80030b <_main+0x24b>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  800155:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80015c:	e9 9a 01 00 00       	jmp    8002fb <_main+0x23b>
			{
				actualSize = allocSizes[i] - sizeOfMetaData;
  800161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800164:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  80016b:	83 e8 08             	sub    $0x8,%eax
  80016e:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	ff 75 bc             	pushl  -0x44(%ebp)
  800177:	e8 9d 18 00 00       	call   801a19 <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 c2                	mov    %eax,%edx
  800181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800184:	89 14 85 a0 e0 81 00 	mov    %edx,0x81e0a0(,%eax,4)
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	8b 04 85 a0 e0 81 00 	mov    0x81e0a0(,%eax,4),%eax
  800195:	89 45 b8             	mov    %eax,-0x48(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  800198:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80019b:	d1 e8                	shr    %eax
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a2:	01 c2                	add    %eax,%edx
  8001a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a7:	89 14 85 a0 0c 82 00 	mov    %edx,0x820ca0(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001ae:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001b1:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b7:	01 c2                	add    %eax,%edx
  8001b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bc:	89 14 85 a0 f6 81 00 	mov    %edx,0x81f6a0(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c6:	83 c0 04             	add    $0x4,%eax
  8001c9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				expectedSize = allocSizes[i];
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  8001d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				curTotalSize += allocSizes[i] ;
  8001d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001dc:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  8001e3:	01 45 e4             	add    %eax,-0x1c(%ebp)
				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA & curTotalSize to skip this area
				roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8001e6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8001ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	48                   	dec    %eax
  8001f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800201:	f7 75 b0             	divl   -0x50(%ebp)
  800204:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800207:	29 d0                	sub    %edx,%eax
  800209:	89 45 a8             	mov    %eax,-0x58(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80020c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80020f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800212:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData  + sizeof(int) /*END block*/))
  800215:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  800219:	7e 60                	jle    80027b <_main+0x1bb>
  80021b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80021e:	83 f8 13             	cmp    $0x13,%eax
  800221:	77 58                	ja     80027b <_main+0x1bb>
				{
					cprintf("%~\n FRAGMENTATION @allocSize#%d: curVA = %x diff = %d\n", i, curVA, diff);
  800223:	ff 75 a4             	pushl  -0x5c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	68 58 45 80 00       	push   $0x804558
  800231:	e8 21 08 00 00       	call   800a57 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800239:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  800240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800243:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	48                   	dec    %eax
  800249:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80024c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024f:	ba 00 00 00 00       	mov    $0x0,%edx
  800254:	f7 75 a0             	divl   -0x60(%ebp)
  800257:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80025a:	29 d0                	sub    %edx,%eax
  80025c:	83 e8 04             	sub    $0x4,%eax
  80025f:	89 45 e0             	mov    %eax,-0x20(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  800262:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800265:	83 e8 04             	sub    $0x4,%eax
  800268:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  80026b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80026e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	83 e8 04             	sub    $0x4,%eax
  800276:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800279:	eb 0d                	jmp    800288 <_main+0x1c8>
				}
				else
				{
					curVA += allocSizes[i] ;
  80027b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80027e:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  800285:	01 45 e0             	add    %eax,-0x20(%ebp)
				}
				//============================================================
				if (is_correct)
  800288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80028c:	74 37                	je     8002c5 <_main+0x205>
				{
					if (check_dynalloc_datastruct(va, expectedVA, expectedSize, 1) == 0)
  80028e:	6a 01                	push   $0x1
  800290:	ff 75 e8             	pushl  -0x18(%ebp)
  800293:	ff 75 b4             	pushl  -0x4c(%ebp)
  800296:	ff 75 b8             	pushl  -0x48(%ebp)
  800299:	e8 9a fd ff ff       	call   800038 <check_dynalloc_datastruct>
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	75 20                	jne    8002c5 <_main+0x205>
					{
						if (is_correct)
  8002a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002a9:	74 1a                	je     8002c5 <_main+0x205>
						{
							is_correct = 0;
  8002ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
							cprintf("alloc_block_xx #1.%d: WRONG ALLOC\n", idx);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8002b8:	68 90 45 80 00       	push   $0x804590
  8002bd:	e8 95 07 00 00       	call   800a57 <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
						}
					}
				}
				*(startVAs[idx]) = idx ;
  8002c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c8:	8b 14 85 a0 e0 81 00 	mov    0x81e0a0(,%eax,4),%edx
  8002cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d2:	66 89 02             	mov    %ax,(%edx)
				*(midVAs[idx]) = idx ;
  8002d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d8:	8b 14 85 a0 0c 82 00 	mov    0x820ca0(,%eax,4),%edx
  8002df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e2:	66 89 02             	mov    %ax,(%edx)
				*(endVAs[idx]) = idx ;
  8002e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e8:	8b 14 85 a0 f6 81 00 	mov    0x81f6a0(,%eax,4),%edx
  8002ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f2:	66 89 02             	mov    %ax,(%edx)
				idx++;
  8002f5:	ff 45 ec             	incl   -0x14(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8002f8:	ff 45 d8             	incl   -0x28(%ebp)
  8002fb:	81 7d d8 c7 00 00 00 	cmpl   $0xc7,-0x28(%ebp)
  800302:	0f 8e 59 fe ff ff    	jle    800161 <_main+0xa1>
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
  800308:	ff 45 dc             	incl   -0x24(%ebp)
  80030b:	83 7d dc 06          	cmpl   $0x6,-0x24(%ebp)
  80030f:	0f 8e 40 fe ff ff    	jle    800155 <_main+0x95>
				idx++;
			}
			//if (is_correct == 0)
			//break;
		}
		if (is_correct)
  800315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800319:	74 04                	je     80031f <_main+0x25f>
		{
			eval += 30;
  80031b:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	68 b4 45 80 00       	push   $0x8045b4
  800327:	e8 2b 07 00 00       	call   800a57 <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80032f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		for (int i = 0; i < idx; ++i)
  800336:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80033d:	eb 5b                	jmp    80039a <_main+0x2da>
		{
			if (*(startVAs[i]) != i || *(midVAs[i]) != i ||	*(endVAs[i]) != i)
  80033f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800342:	8b 04 85 a0 e0 81 00 	mov    0x81e0a0(,%eax,4),%eax
  800349:	66 8b 00             	mov    (%eax),%ax
  80034c:	98                   	cwtl   
  80034d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800350:	75 26                	jne    800378 <_main+0x2b8>
  800352:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800355:	8b 04 85 a0 0c 82 00 	mov    0x820ca0(,%eax,4),%eax
  80035c:	66 8b 00             	mov    (%eax),%ax
  80035f:	98                   	cwtl   
  800360:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800363:	75 13                	jne    800378 <_main+0x2b8>
  800365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800368:	8b 04 85 a0 f6 81 00 	mov    0x81f6a0(,%eax,4),%eax
  80036f:	66 8b 00             	mov    (%eax),%ax
  800372:	98                   	cwtl   
  800373:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800376:	74 1f                	je     800397 <_main+0x2d7>
			{
				is_correct = 0;
  800378:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 d4             	pushl  -0x2c(%ebp)
  800385:	ff 75 d4             	pushl  -0x2c(%ebp)
  800388:	68 f0 45 80 00       	push   $0x8045f0
  80038d:	e8 c5 06 00 00       	call   800a57 <cprintf>
  800392:	83 c4 10             	add    $0x10,%esp
				break;
  800395:	eb 0b                	jmp    8003a2 <_main+0x2e2>
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
	{
		is_correct = 1;

		for (int i = 0; i < idx; ++i)
  800397:	ff 45 d4             	incl   -0x2c(%ebp)
  80039a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8003a0:	7c 9d                	jl     80033f <_main+0x27f>
				is_correct = 0;
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
				break;
			}
		}
		if (is_correct)
  8003a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003a6:	74 04                	je     8003ac <_main+0x2ec>
		{
			eval += 30;
  8003a8:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	/*Check page file*/
	cprintf("%~\n3: Check page file size (nothing should be allocated) [10%]\n") ;
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	68 40 46 80 00       	push   $0x804640
  8003b4:	e8 9e 06 00 00       	call   800a57 <cprintf>
  8003b9:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003c3:	e8 44 2f 00 00       	call   80330c <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003cb:	74 17                	je     8003e4 <_main+0x324>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	68 80 46 80 00       	push   $0x804680
  8003d5:	e8 7d 06 00 00       	call   800a57 <cprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8003dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8003e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003e8:	74 04                	je     8003ee <_main+0x32e>
		{
			eval += 10;
  8003ea:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  8003ee:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
//	for (int i = 0; i < numOfAllocs; ++i)
//	{
//		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
//	}
//	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
	expectedAllocatedSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8003f5:	c7 45 94 00 10 00 00 	movl   $0x1000,-0x6c(%ebp)
  8003fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	48                   	dec    %eax
  800405:	89 45 90             	mov    %eax,-0x70(%ebp)
  800408:	8b 45 90             	mov    -0x70(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	f7 75 94             	divl   -0x6c(%ebp)
  800413:	8b 45 90             	mov    -0x70(%ebp),%eax
  800416:	29 d0                	sub    %edx,%eax
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	c1 e8 0c             	shr    $0xc,%eax
  800421:	89 45 8c             	mov    %eax,-0x74(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  800424:	c7 45 88 00 00 40 00 	movl   $0x400000,-0x78(%ebp)
  80042b:	8b 55 98             	mov    -0x68(%ebp),%edx
  80042e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800431:	01 d0                	add    %edx,%eax
  800433:	48                   	dec    %eax
  800434:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800437:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80043a:	ba 00 00 00 00       	mov    $0x0,%edx
  80043f:	f7 75 88             	divl   -0x78(%ebp)
  800442:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800445:	29 d0                	sub    %edx,%eax
  800447:	c1 e8 16             	shr    $0x16,%eax
  80044a:	89 45 80             	mov    %eax,-0x80(%ebp)
	uint32 expectedAllocNumOfPagesForWS = ROUNDUP(expectedAllocNumOfPages * (sizeof(struct WorkingSetElement) + sizeOfMetaData), PAGE_SIZE) / PAGE_SIZE; 				/*# pages*/
  80044d:	c7 85 7c ff ff ff 00 	movl   $0x1000,-0x84(%ebp)
  800454:	10 00 00 
  800457:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80045a:	c1 e0 05             	shl    $0x5,%eax
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800465:	01 d0                	add    %edx,%eax
  800467:	48                   	dec    %eax
  800468:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  80046e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800474:	ba 00 00 00 00       	mov    $0x0,%edx
  800479:	f7 b5 7c ff ff ff    	divl   -0x84(%ebp)
  80047f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800485:	29 d0                	sub    %edx,%eax
  800487:	c1 e8 0c             	shr    $0xc,%eax
  80048a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	/*Check memory allocation*/
	cprintf("%~\n4: Check total allocation in RAM (for pages, tables & WS) [10%]\n") ;
  800490:	83 ec 0c             	sub    $0xc,%esp
  800493:	68 bc 46 80 00       	push   $0x8046bc
  800498:	e8 ba 05 00 00       	call   800a57 <cprintf>
  80049d:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8004a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32 expected = expectedAllocNumOfPages + expectedAllocNumOfTables  + expectedAllocNumOfPagesForWS;
  8004a7:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8004aa:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004ad:	01 c2                	add    %eax,%edx
  8004af:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		uint32 actual = (freeFrames - sys_calculate_free_frames()) ;
  8004bd:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004c0:	e8 fc 2d 00 00       	call   8032c1 <sys_calculate_free_frames>
  8004c5:	29 c3                	sub    %eax,%ebx
  8004c7:	89 d8                	mov    %ebx,%eax
  8004c9:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		if (expected != actual)
  8004cf:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8004d5:	3b 85 6c ff ff ff    	cmp    -0x94(%ebp),%eax
  8004db:	74 23                	je     800500 <_main+0x440>
		{
			cprintf("number of allocated pages in MEMORY not correct. Expected %d, Actual %d\n", expected, actual);
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  8004e6:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  8004ec:	68 00 47 80 00       	push   $0x804700
  8004f1:	e8 61 05 00 00       	call   800a57 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8004f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800500:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800504:	74 04                	je     80050a <_main+0x44a>
		{
			eval += 10;
  800506:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	/*Check WS elements*/
	cprintf("%~\n5: Check content of WS [20%]\n") ;
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	68 4c 47 80 00       	push   $0x80474c
  800512:	e8 40 05 00 00       	call   800a57 <cprintf>
  800517:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80051a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800521:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800524:	c1 e0 02             	shl    $0x2,%eax
  800527:	83 ec 0c             	sub    $0xc,%esp
  80052a:	50                   	push   %eax
  80052b:	e8 e9 14 00 00       	call   801a19 <malloc>
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		int i = 0;
  800539:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800540:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  800547:	eb 24                	jmp    80056d <_main+0x4ad>
		{
			expectedVAs[i++] = va;
  800549:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80054c:	8d 50 01             	lea    0x1(%eax),%edx
  80054f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800559:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80055f:	01 c2                	add    %eax,%edx
  800561:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800564:	89 02                	mov    %eax,(%edx)
	cprintf("%~\n5: Check content of WS [20%]\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800566:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  80056d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800570:	05 00 00 00 80       	add    $0x80000000,%eax
  800575:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800578:	77 cf                	ja     800549 <_main+0x489>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  80057a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80057d:	6a 02                	push   $0x2
  80057f:	6a 00                	push   $0x0
  800581:	50                   	push   %eax
  800582:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800588:	e8 f6 30 00 00       	call   803683 <sys_check_WS_list>
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  800596:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  80059d:	74 17                	je     8005b6 <_main+0x4f6>
		{
			cprintf("malloc: page is not added to WS\n");
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	68 70 47 80 00       	push   $0x804770
  8005a7:	e8 ab 04 00 00       	call   800a57 <cprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8005af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8005b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005ba:	74 04                	je     8005c0 <_main+0x500>
		{
			eval += 20;
  8005bc:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
		}
	}

	cprintf("%~\ntest malloc (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c6:	68 94 47 80 00       	push   $0x804794
  8005cb:	e8 87 04 00 00       	call   800a57 <cprintf>
  8005d0:	83 c4 10             	add    $0x10,%esp

	return;
  8005d3:	90                   	nop
}
  8005d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	57                   	push   %edi
  8005dd:	56                   	push   %esi
  8005de:	53                   	push   %ebx
  8005df:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8005e2:	e8 a3 2e 00 00       	call   80348a <sys_getenvindex>
  8005e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ed:	89 d0                	mov    %edx,%eax
  8005ef:	c1 e0 03             	shl    $0x3,%eax
  8005f2:	01 d0                	add    %edx,%eax
  8005f4:	c1 e0 02             	shl    $0x2,%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800600:	01 d0                	add    %edx,%eax
  800602:	c1 e0 03             	shl    $0x3,%eax
  800605:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060a:	a3 40 60 80 00       	mov    %eax,0x806040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80060f:	a1 40 60 80 00       	mov    0x806040,%eax
  800614:	8a 40 20             	mov    0x20(%eax),%al
  800617:	84 c0                	test   %al,%al
  800619:	74 0d                	je     800628 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80061b:	a1 40 60 80 00       	mov    0x806040,%eax
  800620:	83 c0 20             	add    $0x20,%eax
  800623:	a3 20 60 80 00       	mov    %eax,0x806020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800628:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80062c:	7e 0a                	jle    800638 <libmain+0x5f>
		binaryname = argv[0];
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	a3 20 60 80 00       	mov    %eax,0x806020

	// call user main routine
	_main(argc, argv);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	ff 75 08             	pushl  0x8(%ebp)
  800641:	e8 7a fa ff ff       	call   8000c0 <_main>
  800646:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800649:	a1 1c 60 80 00       	mov    0x80601c,%eax
  80064e:	85 c0                	test   %eax,%eax
  800650:	0f 84 01 01 00 00    	je     800757 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800656:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80065c:	bb d4 48 80 00       	mov    $0x8048d4,%ebx
  800661:	ba 0e 00 00 00       	mov    $0xe,%edx
  800666:	89 c7                	mov    %eax,%edi
  800668:	89 de                	mov    %ebx,%esi
  80066a:	89 d1                	mov    %edx,%ecx
  80066c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80066e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800671:	b9 56 00 00 00       	mov    $0x56,%ecx
  800676:	b0 00                	mov    $0x0,%al
  800678:	89 d7                	mov    %edx,%edi
  80067a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80067c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800683:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	50                   	push   %eax
  80068a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800690:	50                   	push   %eax
  800691:	e8 2a 30 00 00       	call   8036c0 <sys_utilities>
  800696:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800699:	e8 73 2b 00 00       	call   803211 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	68 f4 47 80 00       	push   $0x8047f4
  8006a6:	e8 ac 03 00 00       	call   800a57 <cprintf>
  8006ab:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b1:	85 c0                	test   %eax,%eax
  8006b3:	74 18                	je     8006cd <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006b5:	e8 24 30 00 00       	call   8036de <sys_get_optimal_num_faults>
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	50                   	push   %eax
  8006be:	68 1c 48 80 00       	push   $0x80481c
  8006c3:	e8 8f 03 00 00       	call   800a57 <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	eb 59                	jmp    800726 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006cd:	a1 40 60 80 00       	mov    0x806040,%eax
  8006d2:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8006d8:	a1 40 60 80 00       	mov    0x806040,%eax
  8006dd:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8006e3:	83 ec 04             	sub    $0x4,%esp
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	68 40 48 80 00       	push   $0x804840
  8006ed:	e8 65 03 00 00       	call   800a57 <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f5:	a1 40 60 80 00       	mov    0x806040,%eax
  8006fa:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800700:	a1 40 60 80 00       	mov    0x806040,%eax
  800705:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80070b:	a1 40 60 80 00       	mov    0x806040,%eax
  800710:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	50                   	push   %eax
  800719:	68 68 48 80 00       	push   $0x804868
  80071e:	e8 34 03 00 00       	call   800a57 <cprintf>
  800723:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800726:	a1 40 60 80 00       	mov    0x806040,%eax
  80072b:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	50                   	push   %eax
  800735:	68 c0 48 80 00       	push   $0x8048c0
  80073a:	e8 18 03 00 00       	call   800a57 <cprintf>
  80073f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800742:	83 ec 0c             	sub    $0xc,%esp
  800745:	68 f4 47 80 00       	push   $0x8047f4
  80074a:	e8 08 03 00 00       	call   800a57 <cprintf>
  80074f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800752:	e8 d4 2a 00 00       	call   80322b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800757:	e8 1f 00 00 00       	call   80077b <exit>
}
  80075c:	90                   	nop
  80075d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800760:	5b                   	pop    %ebx
  800761:	5e                   	pop    %esi
  800762:	5f                   	pop    %edi
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80076b:	83 ec 0c             	sub    $0xc,%esp
  80076e:	6a 00                	push   $0x0
  800770:	e8 e1 2c 00 00       	call   803456 <sys_destroy_env>
  800775:	83 c4 10             	add    $0x10,%esp
}
  800778:	90                   	nop
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <exit>:

void
exit(void)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800781:	e8 36 2d 00 00       	call   8034bc <sys_exit_env>
}
  800786:	90                   	nop
  800787:	c9                   	leave  
  800788:	c3                   	ret    

00800789 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80078f:	8d 45 10             	lea    0x10(%ebp),%eax
  800792:	83 c0 04             	add    $0x4,%eax
  800795:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800798:	a1 58 a3 83 00       	mov    0x83a358,%eax
  80079d:	85 c0                	test   %eax,%eax
  80079f:	74 16                	je     8007b7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a1:	a1 58 a3 83 00       	mov    0x83a358,%eax
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	50                   	push   %eax
  8007aa:	68 38 49 80 00       	push   $0x804938
  8007af:	e8 a3 02 00 00       	call   800a57 <cprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8007bc:	83 ec 0c             	sub    $0xc,%esp
  8007bf:	ff 75 0c             	pushl  0xc(%ebp)
  8007c2:	ff 75 08             	pushl  0x8(%ebp)
  8007c5:	50                   	push   %eax
  8007c6:	68 40 49 80 00       	push   $0x804940
  8007cb:	6a 74                	push   $0x74
  8007cd:	e8 b2 02 00 00       	call   800a84 <cprintf_colored>
  8007d2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 f4             	pushl  -0xc(%ebp)
  8007de:	50                   	push   %eax
  8007df:	e8 04 02 00 00       	call   8009e8 <vcprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	6a 00                	push   $0x0
  8007ec:	68 68 49 80 00       	push   $0x804968
  8007f1:	e8 f2 01 00 00       	call   8009e8 <vcprintf>
  8007f6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007f9:	e8 7d ff ff ff       	call   80077b <exit>

	// should not return here
	while (1) ;
  8007fe:	eb fe                	jmp    8007fe <_panic+0x75>

00800800 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800806:	a1 40 60 80 00       	mov    0x806040,%eax
  80080b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 6c 49 80 00       	push   $0x80496c
  800820:	6a 26                	push   $0x26
  800822:	68 b8 49 80 00       	push   $0x8049b8
  800827:	e8 5d ff ff ff       	call   800789 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c5 00 00 00       	jmp    800904 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a5 00 00 00       	jmp    800901 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 40 60 80 00       	mov    0x806040,%eax
  800871:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 40 60 80 00       	mov    0x806040,%eax
  800891:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 15                	jmp    8008e7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 40 60 80 00       	mov    0x806040,%eax
  8008da:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 85                	ja     80086c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008eb:	75 14                	jne    800901 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008ed:	83 ec 04             	sub    $0x4,%esp
  8008f0:	68 c4 49 80 00       	push   $0x8049c4
  8008f5:	6a 3a                	push   $0x3a
  8008f7:	68 b8 49 80 00       	push   $0x8049b8
  8008fc:	e8 88 fe ff ff       	call   800789 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800901:	ff 45 f0             	incl   -0x10(%ebp)
  800904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800907:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80090a:	0f 8c 2f ff ff ff    	jl     80083f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800910:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800917:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091e:	eb 26                	jmp    800946 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800920:	a1 40 60 80 00       	mov    0x806040,%eax
  800925:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80092b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092e:	89 d0                	mov    %edx,%eax
  800930:	01 c0                	add    %eax,%eax
  800932:	01 d0                	add    %edx,%eax
  800934:	c1 e0 03             	shl    $0x3,%eax
  800937:	01 c8                	add    %ecx,%eax
  800939:	8a 40 04             	mov    0x4(%eax),%al
  80093c:	3c 01                	cmp    $0x1,%al
  80093e:	75 03                	jne    800943 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800940:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800943:	ff 45 e0             	incl   -0x20(%ebp)
  800946:	a1 40 60 80 00       	mov    0x806040,%eax
  80094b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	39 c2                	cmp    %eax,%edx
  800956:	77 c8                	ja     800920 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80095e:	74 14                	je     800974 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800960:	83 ec 04             	sub    $0x4,%esp
  800963:	68 18 4a 80 00       	push   $0x804a18
  800968:	6a 44                	push   $0x44
  80096a:	68 b8 49 80 00       	push   $0x8049b8
  80096f:	e8 15 fe ff ff       	call   800789 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800974:	90                   	nop
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	8d 48 01             	lea    0x1(%eax),%ecx
  800986:	8b 55 0c             	mov    0xc(%ebp),%edx
  800989:	89 0a                	mov    %ecx,(%edx)
  80098b:	8b 55 08             	mov    0x8(%ebp),%edx
  80098e:	88 d1                	mov    %dl,%cl
  800990:	8b 55 0c             	mov    0xc(%ebp),%edx
  800993:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a1:	75 30                	jne    8009d3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009a3:	8b 15 5c a3 83 00    	mov    0x83a35c,%edx
  8009a9:	a0 84 e0 81 00       	mov    0x81e084,%al
  8009ae:	0f b6 c0             	movzbl %al,%eax
  8009b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b4:	8b 09                	mov    (%ecx),%ecx
  8009b6:	89 cb                	mov    %ecx,%ebx
  8009b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bb:	83 c1 08             	add    $0x8,%ecx
  8009be:	52                   	push   %edx
  8009bf:	50                   	push   %eax
  8009c0:	53                   	push   %ebx
  8009c1:	51                   	push   %ecx
  8009c2:	e8 06 28 00 00       	call   8031cd <sys_cputs>
  8009c7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d6:	8b 40 04             	mov    0x4(%eax),%eax
  8009d9:	8d 50 01             	lea    0x1(%eax),%edx
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e2:	90                   	nop
  8009e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e6:	c9                   	leave  
  8009e7:	c3                   	ret    

008009e8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f8:	00 00 00 
	b.cnt = 0;
  8009fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a02:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	ff 75 08             	pushl  0x8(%ebp)
  800a0b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a11:	50                   	push   %eax
  800a12:	68 77 09 80 00       	push   $0x800977
  800a17:	e8 5a 02 00 00       	call   800c76 <vprintfmt>
  800a1c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a1f:	8b 15 5c a3 83 00    	mov    0x83a35c,%edx
  800a25:	a0 84 e0 81 00       	mov    0x81e084,%al
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a33:	52                   	push   %edx
  800a34:	50                   	push   %eax
  800a35:	51                   	push   %ecx
  800a36:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a3c:	83 c0 08             	add    $0x8,%eax
  800a3f:	50                   	push   %eax
  800a40:	e8 88 27 00 00       	call   8031cd <sys_cputs>
  800a45:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a48:	c6 05 84 e0 81 00 00 	movb   $0x0,0x81e084
	return b.cnt;
  800a4f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a5d:	c6 05 84 e0 81 00 01 	movb   $0x1,0x81e084
	va_start(ap, fmt);
  800a64:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 f4             	pushl  -0xc(%ebp)
  800a73:	50                   	push   %eax
  800a74:	e8 6f ff ff ff       	call   8009e8 <vcprintf>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a8a:	c6 05 84 e0 81 00 01 	movb   $0x1,0x81e084
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	c1 e0 08             	shl    $0x8,%eax
  800a97:	a3 5c a3 83 00       	mov    %eax,0x83a35c
	va_start(ap, fmt);
  800a9c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a9f:	83 c0 04             	add    $0x4,%eax
  800aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 f4             	pushl  -0xc(%ebp)
  800aae:	50                   	push   %eax
  800aaf:	e8 34 ff ff ff       	call   8009e8 <vcprintf>
  800ab4:	83 c4 10             	add    $0x10,%esp
  800ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800aba:	c7 05 5c a3 83 00 00 	movl   $0x700,0x83a35c
  800ac1:	07 00 00 

	return cnt;
  800ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800acf:	e8 3d 27 00 00       	call   803211 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ad4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	e8 ff fe ff ff       	call   8009e8 <vcprintf>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800aef:	e8 37 27 00 00       	call   80322b <sys_unlock_cons>
	return cnt;
  800af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	53                   	push   %ebx
  800afd:	83 ec 14             	sub    $0x14,%esp
  800b00:	8b 45 10             	mov    0x10(%ebp),%eax
  800b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b06:	8b 45 14             	mov    0x14(%ebp),%eax
  800b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b0c:	8b 45 18             	mov    0x18(%ebp),%eax
  800b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b14:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b17:	77 55                	ja     800b6e <printnum+0x75>
  800b19:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b1c:	72 05                	jb     800b23 <printnum+0x2a>
  800b1e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b21:	77 4b                	ja     800b6e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b23:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b26:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b29:	8b 45 18             	mov    0x18(%ebp),%eax
  800b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b31:	52                   	push   %edx
  800b32:	50                   	push   %eax
  800b33:	ff 75 f4             	pushl  -0xc(%ebp)
  800b36:	ff 75 f0             	pushl  -0x10(%ebp)
  800b39:	e8 a6 36 00 00       	call   8041e4 <__udivdi3>
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	ff 75 20             	pushl  0x20(%ebp)
  800b47:	53                   	push   %ebx
  800b48:	ff 75 18             	pushl  0x18(%ebp)
  800b4b:	52                   	push   %edx
  800b4c:	50                   	push   %eax
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 a1 ff ff ff       	call   800af9 <printnum>
  800b58:	83 c4 20             	add    $0x20,%esp
  800b5b:	eb 1a                	jmp    800b77 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	ff 75 20             	pushl  0x20(%ebp)
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	ff d0                	call   *%eax
  800b6b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b6e:	ff 4d 1c             	decl   0x1c(%ebp)
  800b71:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b75:	7f e6                	jg     800b5d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b77:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b85:	53                   	push   %ebx
  800b86:	51                   	push   %ecx
  800b87:	52                   	push   %edx
  800b88:	50                   	push   %eax
  800b89:	e8 66 37 00 00       	call   8042f4 <__umoddi3>
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	05 94 4c 80 00       	add    $0x804c94,%eax
  800b96:	8a 00                	mov    (%eax),%al
  800b98:	0f be c0             	movsbl %al,%eax
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
}
  800baa:	90                   	nop
  800bab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb7:	7e 1c                	jle    800bd5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	8d 50 08             	lea    0x8(%eax),%edx
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	89 10                	mov    %edx,(%eax)
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	83 e8 08             	sub    $0x8,%eax
  800bce:	8b 50 04             	mov    0x4(%eax),%edx
  800bd1:	8b 00                	mov    (%eax),%eax
  800bd3:	eb 40                	jmp    800c15 <getuint+0x65>
	else if (lflag)
  800bd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd9:	74 1e                	je     800bf9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 00                	mov    (%eax),%eax
  800be0:	8d 50 04             	lea    0x4(%eax),%edx
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	89 10                	mov    %edx,(%eax)
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	83 e8 04             	sub    $0x4,%eax
  800bf0:	8b 00                	mov    (%eax),%eax
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	eb 1c                	jmp    800c15 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	8d 50 04             	lea    0x4(%eax),%edx
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	89 10                	mov    %edx,(%eax)
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	83 e8 04             	sub    $0x4,%eax
  800c0e:	8b 00                	mov    (%eax),%eax
  800c10:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c1e:	7e 1c                	jle    800c3c <getint+0x25>
		return va_arg(*ap, long long);
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	8d 50 08             	lea    0x8(%eax),%edx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 10                	mov    %edx,(%eax)
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	83 e8 08             	sub    $0x8,%eax
  800c35:	8b 50 04             	mov    0x4(%eax),%edx
  800c38:	8b 00                	mov    (%eax),%eax
  800c3a:	eb 38                	jmp    800c74 <getint+0x5d>
	else if (lflag)
  800c3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c40:	74 1a                	je     800c5c <getint+0x45>
		return va_arg(*ap, long);
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	8d 50 04             	lea    0x4(%eax),%edx
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 10                	mov    %edx,(%eax)
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8b 00                	mov    (%eax),%eax
  800c54:	83 e8 04             	sub    $0x4,%eax
  800c57:	8b 00                	mov    (%eax),%eax
  800c59:	99                   	cltd   
  800c5a:	eb 18                	jmp    800c74 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	8b 00                	mov    (%eax),%eax
  800c61:	8d 50 04             	lea    0x4(%eax),%edx
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 10                	mov    %edx,(%eax)
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 00                	mov    (%eax),%eax
  800c6e:	83 e8 04             	sub    $0x4,%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	99                   	cltd   
}
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c7e:	eb 17                	jmp    800c97 <vprintfmt+0x21>
			if (ch == '\0')
  800c80:	85 db                	test   %ebx,%ebx
  800c82:	0f 84 c1 03 00 00    	je     801049 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c88:	83 ec 08             	sub    $0x8,%esp
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	53                   	push   %ebx
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	8d 50 01             	lea    0x1(%eax),%edx
  800c9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	0f b6 d8             	movzbl %al,%ebx
  800ca5:	83 fb 25             	cmp    $0x25,%ebx
  800ca8:	75 d6                	jne    800c80 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800caa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cb5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cbc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cc3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 01             	lea    0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f b6 d8             	movzbl %al,%ebx
  800cd8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cdb:	83 f8 5b             	cmp    $0x5b,%eax
  800cde:	0f 87 3d 03 00 00    	ja     801021 <vprintfmt+0x3ab>
  800ce4:	8b 04 85 b8 4c 80 00 	mov    0x804cb8(,%eax,4),%eax
  800ceb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ced:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cf1:	eb d7                	jmp    800cca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cf3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cf7:	eb d1                	jmp    800cca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d03:	89 d0                	mov    %edx,%eax
  800d05:	c1 e0 02             	shl    $0x2,%eax
  800d08:	01 d0                	add    %edx,%eax
  800d0a:	01 c0                	add    %eax,%eax
  800d0c:	01 d8                	add    %ebx,%eax
  800d0e:	83 e8 30             	sub    $0x30,%eax
  800d11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d14:	8b 45 10             	mov    0x10(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800d1f:	7e 3e                	jle    800d5f <vprintfmt+0xe9>
  800d21:	83 fb 39             	cmp    $0x39,%ebx
  800d24:	7f 39                	jg     800d5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d29:	eb d5                	jmp    800d00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2e:	83 c0 04             	add    $0x4,%eax
  800d31:	89 45 14             	mov    %eax,0x14(%ebp)
  800d34:	8b 45 14             	mov    0x14(%ebp),%eax
  800d37:	83 e8 04             	sub    $0x4,%eax
  800d3a:	8b 00                	mov    (%eax),%eax
  800d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d3f:	eb 1f                	jmp    800d60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d45:	79 83                	jns    800cca <vprintfmt+0x54>
				width = 0;
  800d47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d4e:	e9 77 ff ff ff       	jmp    800cca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d5a:	e9 6b ff ff ff       	jmp    800cca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d64:	0f 89 60 ff ff ff    	jns    800cca <vprintfmt+0x54>
				width = precision, precision = -1;
  800d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d77:	e9 4e ff ff ff       	jmp    800cca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d7f:	e9 46 ff ff ff       	jmp    800cca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d84:	8b 45 14             	mov    0x14(%ebp),%eax
  800d87:	83 c0 04             	add    $0x4,%eax
  800d8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d90:	83 e8 04             	sub    $0x4,%eax
  800d93:	8b 00                	mov    (%eax),%eax
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	50                   	push   %eax
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	ff d0                	call   *%eax
  800da1:	83 c4 10             	add    $0x10,%esp
			break;
  800da4:	e9 9b 02 00 00       	jmp    801044 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800da9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 14             	mov    %eax,0x14(%ebp)
  800db2:	8b 45 14             	mov    0x14(%ebp),%eax
  800db5:	83 e8 04             	sub    $0x4,%eax
  800db8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dba:	85 db                	test   %ebx,%ebx
  800dbc:	79 02                	jns    800dc0 <vprintfmt+0x14a>
				err = -err;
  800dbe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dc0:	83 fb 64             	cmp    $0x64,%ebx
  800dc3:	7f 0b                	jg     800dd0 <vprintfmt+0x15a>
  800dc5:	8b 34 9d 00 4b 80 00 	mov    0x804b00(,%ebx,4),%esi
  800dcc:	85 f6                	test   %esi,%esi
  800dce:	75 19                	jne    800de9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dd0:	53                   	push   %ebx
  800dd1:	68 a5 4c 80 00       	push   $0x804ca5
  800dd6:	ff 75 0c             	pushl  0xc(%ebp)
  800dd9:	ff 75 08             	pushl  0x8(%ebp)
  800ddc:	e8 70 02 00 00       	call   801051 <printfmt>
  800de1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800de4:	e9 5b 02 00 00       	jmp    801044 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800de9:	56                   	push   %esi
  800dea:	68 ae 4c 80 00       	push   $0x804cae
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	ff 75 08             	pushl  0x8(%ebp)
  800df5:	e8 57 02 00 00       	call   801051 <printfmt>
  800dfa:	83 c4 10             	add    $0x10,%esp
			break;
  800dfd:	e9 42 02 00 00       	jmp    801044 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e02:	8b 45 14             	mov    0x14(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 30                	mov    (%eax),%esi
  800e13:	85 f6                	test   %esi,%esi
  800e15:	75 05                	jne    800e1c <vprintfmt+0x1a6>
				p = "(null)";
  800e17:	be b1 4c 80 00       	mov    $0x804cb1,%esi
			if (width > 0 && padc != '-')
  800e1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e20:	7e 6d                	jle    800e8f <vprintfmt+0x219>
  800e22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e26:	74 67                	je     800e8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e2b:	83 ec 08             	sub    $0x8,%esp
  800e2e:	50                   	push   %eax
  800e2f:	56                   	push   %esi
  800e30:	e8 1e 03 00 00       	call   801153 <strnlen>
  800e35:	83 c4 10             	add    $0x10,%esp
  800e38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e3b:	eb 16                	jmp    800e53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	50                   	push   %eax
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	ff d0                	call   *%eax
  800e4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e50:	ff 4d e4             	decl   -0x1c(%ebp)
  800e53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e57:	7f e4                	jg     800e3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e59:	eb 34                	jmp    800e8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e5f:	74 1c                	je     800e7d <vprintfmt+0x207>
  800e61:	83 fb 1f             	cmp    $0x1f,%ebx
  800e64:	7e 05                	jle    800e6b <vprintfmt+0x1f5>
  800e66:	83 fb 7e             	cmp    $0x7e,%ebx
  800e69:	7e 12                	jle    800e7d <vprintfmt+0x207>
					putch('?', putdat);
  800e6b:	83 ec 08             	sub    $0x8,%esp
  800e6e:	ff 75 0c             	pushl  0xc(%ebp)
  800e71:	6a 3f                	push   $0x3f
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	ff d0                	call   *%eax
  800e78:	83 c4 10             	add    $0x10,%esp
  800e7b:	eb 0f                	jmp    800e8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e7d:	83 ec 08             	sub    $0x8,%esp
  800e80:	ff 75 0c             	pushl  0xc(%ebp)
  800e83:	53                   	push   %ebx
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	ff d0                	call   *%eax
  800e89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800e8f:	89 f0                	mov    %esi,%eax
  800e91:	8d 70 01             	lea    0x1(%eax),%esi
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f be d8             	movsbl %al,%ebx
  800e99:	85 db                	test   %ebx,%ebx
  800e9b:	74 24                	je     800ec1 <vprintfmt+0x24b>
  800e9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ea1:	78 b8                	js     800e5b <vprintfmt+0x1e5>
  800ea3:	ff 4d e0             	decl   -0x20(%ebp)
  800ea6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eaa:	79 af                	jns    800e5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eac:	eb 13                	jmp    800ec1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	6a 20                	push   $0x20
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	ff d0                	call   *%eax
  800ebb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ebe:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec5:	7f e7                	jg     800eae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ec7:	e9 78 01 00 00       	jmp    801044 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed5:	50                   	push   %eax
  800ed6:	e8 3c fd ff ff       	call   800c17 <getint>
  800edb:	83 c4 10             	add    $0x10,%esp
  800ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eea:	85 d2                	test   %edx,%edx
  800eec:	79 23                	jns    800f11 <vprintfmt+0x29b>
				putch('-', putdat);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	ff 75 0c             	pushl  0xc(%ebp)
  800ef4:	6a 2d                	push   $0x2d
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	ff d0                	call   *%eax
  800efb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f04:	f7 d8                	neg    %eax
  800f06:	83 d2 00             	adc    $0x0,%edx
  800f09:	f7 da                	neg    %edx
  800f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f18:	e9 bc 00 00 00       	jmp    800fd9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f1d:	83 ec 08             	sub    $0x8,%esp
  800f20:	ff 75 e8             	pushl  -0x18(%ebp)
  800f23:	8d 45 14             	lea    0x14(%ebp),%eax
  800f26:	50                   	push   %eax
  800f27:	e8 84 fc ff ff       	call   800bb0 <getuint>
  800f2c:	83 c4 10             	add    $0x10,%esp
  800f2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3c:	e9 98 00 00 00       	jmp    800fd9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	6a 58                	push   $0x58
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	ff d0                	call   *%eax
  800f4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 0c             	pushl  0xc(%ebp)
  800f57:	6a 58                	push   $0x58
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	ff d0                	call   *%eax
  800f5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	ff 75 0c             	pushl  0xc(%ebp)
  800f67:	6a 58                	push   $0x58
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	ff d0                	call   *%eax
  800f6e:	83 c4 10             	add    $0x10,%esp
			break;
  800f71:	e9 ce 00 00 00       	jmp    801044 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 30                	push   $0x30
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	6a 78                	push   $0x78
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	ff d0                	call   *%eax
  800f93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f96:	8b 45 14             	mov    0x14(%ebp),%eax
  800f99:	83 c0 04             	add    $0x4,%eax
  800f9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa2:	83 e8 04             	sub    $0x4,%eax
  800fa5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fb8:	eb 1f                	jmp    800fd9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fba:	83 ec 08             	sub    $0x8,%esp
  800fbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc3:	50                   	push   %eax
  800fc4:	e8 e7 fb ff ff       	call   800bb0 <getuint>
  800fc9:	83 c4 10             	add    $0x10,%esp
  800fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	52                   	push   %edx
  800fe4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe7:	50                   	push   %eax
  800fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  800feb:	ff 75 f0             	pushl  -0x10(%ebp)
  800fee:	ff 75 0c             	pushl  0xc(%ebp)
  800ff1:	ff 75 08             	pushl  0x8(%ebp)
  800ff4:	e8 00 fb ff ff       	call   800af9 <printnum>
  800ff9:	83 c4 20             	add    $0x20,%esp
			break;
  800ffc:	eb 46                	jmp    801044 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	53                   	push   %ebx
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
			break;
  80100d:	eb 35                	jmp    801044 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80100f:	c6 05 84 e0 81 00 00 	movb   $0x0,0x81e084
			break;
  801016:	eb 2c                	jmp    801044 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801018:	c6 05 84 e0 81 00 01 	movb   $0x1,0x81e084
			break;
  80101f:	eb 23                	jmp    801044 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801021:	83 ec 08             	sub    $0x8,%esp
  801024:	ff 75 0c             	pushl  0xc(%ebp)
  801027:	6a 25                	push   $0x25
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	ff d0                	call   *%eax
  80102e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801031:	ff 4d 10             	decl   0x10(%ebp)
  801034:	eb 03                	jmp    801039 <vprintfmt+0x3c3>
  801036:	ff 4d 10             	decl   0x10(%ebp)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	48                   	dec    %eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 25                	cmp    $0x25,%al
  801041:	75 f3                	jne    801036 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801043:	90                   	nop
		}
	}
  801044:	e9 35 fc ff ff       	jmp    800c7e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801049:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80104a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    

00801051 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801057:	8d 45 10             	lea    0x10(%ebp),%eax
  80105a:	83 c0 04             	add    $0x4,%eax
  80105d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	ff 75 f4             	pushl  -0xc(%ebp)
  801066:	50                   	push   %eax
  801067:	ff 75 0c             	pushl  0xc(%ebp)
  80106a:	ff 75 08             	pushl  0x8(%ebp)
  80106d:	e8 04 fc ff ff       	call   800c76 <vprintfmt>
  801072:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801075:	90                   	nop
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8b 40 08             	mov    0x8(%eax),%eax
  801081:	8d 50 01             	lea    0x1(%eax),%edx
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	8b 10                	mov    (%eax),%edx
  80108f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801092:	8b 40 04             	mov    0x4(%eax),%eax
  801095:	39 c2                	cmp    %eax,%edx
  801097:	73 12                	jae    8010ab <sprintputch+0x33>
		*b->buf++ = ch;
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	8b 00                	mov    (%eax),%eax
  80109e:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a4:	89 0a                	mov    %ecx,(%edx)
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	88 10                	mov    %dl,(%eax)
}
  8010ab:	90                   	nop
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    

008010ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d3:	74 06                	je     8010db <vsnprintf+0x2d>
  8010d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d9:	7f 07                	jg     8010e2 <vsnprintf+0x34>
		return -E_INVAL;
  8010db:	b8 03 00 00 00       	mov    $0x3,%eax
  8010e0:	eb 20                	jmp    801102 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010e2:	ff 75 14             	pushl  0x14(%ebp)
  8010e5:	ff 75 10             	pushl  0x10(%ebp)
  8010e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010eb:	50                   	push   %eax
  8010ec:	68 78 10 80 00       	push   $0x801078
  8010f1:	e8 80 fb ff ff       	call   800c76 <vprintfmt>
  8010f6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010fc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80110a:	8d 45 10             	lea    0x10(%ebp),%eax
  80110d:	83 c0 04             	add    $0x4,%eax
  801110:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	ff 75 f4             	pushl  -0xc(%ebp)
  801119:	50                   	push   %eax
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	ff 75 08             	pushl  0x8(%ebp)
  801120:	e8 89 ff ff ff       	call   8010ae <vsnprintf>
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80112b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80113d:	eb 06                	jmp    801145 <strlen+0x15>
		n++;
  80113f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801142:	ff 45 08             	incl   0x8(%ebp)
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 f1                	jne    80113f <strlen+0xf>
		n++;
	return n;
  80114e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801160:	eb 09                	jmp    80116b <strnlen+0x18>
		n++;
  801162:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 4d 0c             	decl   0xc(%ebp)
  80116b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116f:	74 09                	je     80117a <strnlen+0x27>
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	84 c0                	test   %al,%al
  801178:	75 e8                	jne    801162 <strnlen+0xf>
		n++;
	return n;
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80118b:	90                   	nop
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 08             	mov    %edx,0x8(%ebp)
  801195:	8b 55 0c             	mov    0xc(%ebp),%edx
  801198:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80119e:	8a 12                	mov    (%edx),%dl
  8011a0:	88 10                	mov    %dl,(%eax)
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	75 e4                	jne    80118c <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c0:	eb 1f                	jmp    8011e1 <strncpy+0x34>
		*dst++ = *src;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8d 50 01             	lea    0x1(%eax),%edx
  8011c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ce:	8a 12                	mov    (%edx),%dl
  8011d0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	84 c0                	test   %al,%al
  8011d9:	74 03                	je     8011de <strncpy+0x31>
			src++;
  8011db:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011de:	ff 45 fc             	incl   -0x4(%ebp)
  8011e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011e7:	72 d9                	jb     8011c2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fe:	74 30                	je     801230 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801200:	eb 16                	jmp    801218 <strlcpy+0x2a>
			*dst++ = *src++;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8d 50 01             	lea    0x1(%eax),%edx
  801208:	89 55 08             	mov    %edx,0x8(%ebp)
  80120b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801211:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801214:	8a 12                	mov    (%edx),%dl
  801216:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801218:	ff 4d 10             	decl   0x10(%ebp)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	74 09                	je     80122a <strlcpy+0x3c>
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	84 c0                	test   %al,%al
  801228:	75 d8                	jne    801202 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801230:	8b 55 08             	mov    0x8(%ebp),%edx
  801233:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801236:	29 c2                	sub    %eax,%edx
  801238:	89 d0                	mov    %edx,%eax
}
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80123f:	eb 06                	jmp    801247 <strcmp+0xb>
		p++, q++;
  801241:	ff 45 08             	incl   0x8(%ebp)
  801244:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	84 c0                	test   %al,%al
  80124e:	74 0e                	je     80125e <strcmp+0x22>
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 10                	mov    (%eax),%dl
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	38 c2                	cmp    %al,%dl
  80125c:	74 e3                	je     801241 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	0f b6 d0             	movzbl %al,%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	0f b6 c0             	movzbl %al,%eax
  80126e:	29 c2                	sub    %eax,%edx
  801270:	89 d0                	mov    %edx,%eax
}
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801277:	eb 09                	jmp    801282 <strncmp+0xe>
		n--, p++, q++;
  801279:	ff 4d 10             	decl   0x10(%ebp)
  80127c:	ff 45 08             	incl   0x8(%ebp)
  80127f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801286:	74 17                	je     80129f <strncmp+0x2b>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	84 c0                	test   %al,%al
  80128f:	74 0e                	je     80129f <strncmp+0x2b>
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 10                	mov    (%eax),%dl
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	38 c2                	cmp    %al,%dl
  80129d:	74 da                	je     801279 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80129f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a3:	75 07                	jne    8012ac <strncmp+0x38>
		return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012aa:	eb 14                	jmp    8012c0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	0f b6 d0             	movzbl %al,%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f b6 c0             	movzbl %al,%eax
  8012bc:	29 c2                	sub    %eax,%edx
  8012be:	89 d0                	mov    %edx,%eax
}
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    

008012c2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	83 ec 04             	sub    $0x4,%esp
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012ce:	eb 12                	jmp    8012e2 <strchr+0x20>
		if (*s == c)
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012d8:	75 05                	jne    8012df <strchr+0x1d>
			return (char *) s;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	eb 11                	jmp    8012f0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 e5                	jne    8012d0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 04             	sub    $0x4,%esp
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012fe:	eb 0d                	jmp    80130d <strfind+0x1b>
		if (*s == c)
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801308:	74 0e                	je     801318 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80130a:	ff 45 08             	incl   0x8(%ebp)
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	84 c0                	test   %al,%al
  801314:	75 ea                	jne    801300 <strfind+0xe>
  801316:	eb 01                	jmp    801319 <strfind+0x27>
		if (*s == c)
			break;
  801318:	90                   	nop
	return (char *) s;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80132a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80132e:	76 63                	jbe    801393 <memset+0x75>
		uint64 data_block = c;
  801330:	8b 45 0c             	mov    0xc(%ebp),%eax
  801333:	99                   	cltd   
  801334:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801337:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80133a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801340:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801344:	c1 e0 08             	shl    $0x8,%eax
  801347:	09 45 f0             	or     %eax,-0x10(%ebp)
  80134a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801353:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801357:	c1 e0 10             	shl    $0x10,%eax
  80135a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80135d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801366:	89 c2                	mov    %eax,%edx
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
  80136d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801370:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801373:	eb 18                	jmp    80138d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801375:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801378:	8d 41 08             	lea    0x8(%ecx),%eax
  80137b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80137e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801384:	89 01                	mov    %eax,(%ecx)
  801386:	89 51 04             	mov    %edx,0x4(%ecx)
  801389:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80138d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801391:	77 e2                	ja     801375 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801393:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801397:	74 23                	je     8013bc <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80139f:	eb 0e                	jmp    8013af <memset+0x91>
			*p8++ = (uint8)c;
  8013a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a4:	8d 50 01             	lea    0x1(%eax),%edx
  8013a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8013af:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	75 e5                	jne    8013a1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8013d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013d7:	76 24                	jbe    8013fd <memcpy+0x3c>
		while(n >= 8){
  8013d9:	eb 1c                	jmp    8013f7 <memcpy+0x36>
			*d64 = *s64;
  8013db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013de:	8b 50 04             	mov    0x4(%eax),%edx
  8013e1:	8b 00                	mov    (%eax),%eax
  8013e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e6:	89 01                	mov    %eax,(%ecx)
  8013e8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8013eb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8013ef:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8013f3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8013f7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013fb:	77 de                	ja     8013db <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8013fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801401:	74 31                	je     801434 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801409:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80140f:	eb 16                	jmp    801427 <memcpy+0x66>
			*d8++ = *s8++;
  801411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801414:	8d 50 01             	lea    0x1(%eax),%edx
  801417:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80141a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801420:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801423:	8a 12                	mov    (%edx),%dl
  801425:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801427:	8b 45 10             	mov    0x10(%ebp),%eax
  80142a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80142d:	89 55 10             	mov    %edx,0x10(%ebp)
  801430:	85 c0                	test   %eax,%eax
  801432:	75 dd                	jne    801411 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80144b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801451:	73 50                	jae    8014a3 <memmove+0x6a>
  801453:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801456:	8b 45 10             	mov    0x10(%ebp),%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80145e:	76 43                	jbe    8014a3 <memmove+0x6a>
		s += n;
  801460:	8b 45 10             	mov    0x10(%ebp),%eax
  801463:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801466:	8b 45 10             	mov    0x10(%ebp),%eax
  801469:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80146c:	eb 10                	jmp    80147e <memmove+0x45>
			*--d = *--s;
  80146e:	ff 4d f8             	decl   -0x8(%ebp)
  801471:	ff 4d fc             	decl   -0x4(%ebp)
  801474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801477:	8a 10                	mov    (%eax),%dl
  801479:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80147e:	8b 45 10             	mov    0x10(%ebp),%eax
  801481:	8d 50 ff             	lea    -0x1(%eax),%edx
  801484:	89 55 10             	mov    %edx,0x10(%ebp)
  801487:	85 c0                	test   %eax,%eax
  801489:	75 e3                	jne    80146e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80148b:	eb 23                	jmp    8014b0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80148d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801490:	8d 50 01             	lea    0x1(%eax),%edx
  801493:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801496:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801499:	8d 4a 01             	lea    0x1(%edx),%ecx
  80149c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80149f:	8a 12                	mov    (%edx),%dl
  8014a1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	75 dd                	jne    80148d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014c7:	eb 2a                	jmp    8014f3 <memcmp+0x3e>
		if (*s1 != *s2)
  8014c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cc:	8a 10                	mov    (%eax),%dl
  8014ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d1:	8a 00                	mov    (%eax),%al
  8014d3:	38 c2                	cmp    %al,%dl
  8014d5:	74 16                	je     8014ed <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	0f b6 d0             	movzbl %al,%edx
  8014df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	0f b6 c0             	movzbl %al,%eax
  8014e7:	29 c2                	sub    %eax,%edx
  8014e9:	89 d0                	mov    %edx,%eax
  8014eb:	eb 18                	jmp    801505 <memcmp+0x50>
		s1++, s2++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
  8014f0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8014f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	75 c9                	jne    8014c9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80150d:	8b 55 08             	mov    0x8(%ebp),%edx
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	01 d0                	add    %edx,%eax
  801515:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801518:	eb 15                	jmp    80152f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	0f b6 d0             	movzbl %al,%edx
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	0f b6 c0             	movzbl %al,%eax
  801528:	39 c2                	cmp    %eax,%edx
  80152a:	74 0d                	je     801539 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80152c:	ff 45 08             	incl   0x8(%ebp)
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801535:	72 e3                	jb     80151a <memfind+0x13>
  801537:	eb 01                	jmp    80153a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801539:	90                   	nop
	return (void *) s;
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801545:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80154c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801553:	eb 03                	jmp    801558 <strtol+0x19>
		s++;
  801555:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	3c 20                	cmp    $0x20,%al
  80155f:	74 f4                	je     801555 <strtol+0x16>
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	3c 09                	cmp    $0x9,%al
  801568:	74 eb                	je     801555 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	3c 2b                	cmp    $0x2b,%al
  801571:	75 05                	jne    801578 <strtol+0x39>
		s++;
  801573:	ff 45 08             	incl   0x8(%ebp)
  801576:	eb 13                	jmp    80158b <strtol+0x4c>
	else if (*s == '-')
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	8a 00                	mov    (%eax),%al
  80157d:	3c 2d                	cmp    $0x2d,%al
  80157f:	75 0a                	jne    80158b <strtol+0x4c>
		s++, neg = 1;
  801581:	ff 45 08             	incl   0x8(%ebp)
  801584:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80158b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158f:	74 06                	je     801597 <strtol+0x58>
  801591:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801595:	75 20                	jne    8015b7 <strtol+0x78>
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	3c 30                	cmp    $0x30,%al
  80159e:	75 17                	jne    8015b7 <strtol+0x78>
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	40                   	inc    %eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	3c 78                	cmp    $0x78,%al
  8015a8:	75 0d                	jne    8015b7 <strtol+0x78>
		s += 2, base = 16;
  8015aa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015ae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015b5:	eb 28                	jmp    8015df <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015bb:	75 15                	jne    8015d2 <strtol+0x93>
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	8a 00                	mov    (%eax),%al
  8015c2:	3c 30                	cmp    $0x30,%al
  8015c4:	75 0c                	jne    8015d2 <strtol+0x93>
		s++, base = 8;
  8015c6:	ff 45 08             	incl   0x8(%ebp)
  8015c9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015d0:	eb 0d                	jmp    8015df <strtol+0xa0>
	else if (base == 0)
  8015d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d6:	75 07                	jne    8015df <strtol+0xa0>
		base = 10;
  8015d8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8a 00                	mov    (%eax),%al
  8015e4:	3c 2f                	cmp    $0x2f,%al
  8015e6:	7e 19                	jle    801601 <strtol+0xc2>
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	3c 39                	cmp    $0x39,%al
  8015ef:	7f 10                	jg     801601 <strtol+0xc2>
			dig = *s - '0';
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	8a 00                	mov    (%eax),%al
  8015f6:	0f be c0             	movsbl %al,%eax
  8015f9:	83 e8 30             	sub    $0x30,%eax
  8015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015ff:	eb 42                	jmp    801643 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	3c 60                	cmp    $0x60,%al
  801608:	7e 19                	jle    801623 <strtol+0xe4>
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	3c 7a                	cmp    $0x7a,%al
  801611:	7f 10                	jg     801623 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	0f be c0             	movsbl %al,%eax
  80161b:	83 e8 57             	sub    $0x57,%eax
  80161e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801621:	eb 20                	jmp    801643 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	3c 40                	cmp    $0x40,%al
  80162a:	7e 39                	jle    801665 <strtol+0x126>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 5a                	cmp    $0x5a,%al
  801633:	7f 30                	jg     801665 <strtol+0x126>
			dig = *s - 'A' + 10;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	0f be c0             	movsbl %al,%eax
  80163d:	83 e8 37             	sub    $0x37,%eax
  801640:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801646:	3b 45 10             	cmp    0x10(%ebp),%eax
  801649:	7d 19                	jge    801664 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80164b:	ff 45 08             	incl   0x8(%ebp)
  80164e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801651:	0f af 45 10          	imul   0x10(%ebp),%eax
  801655:	89 c2                	mov    %eax,%edx
  801657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165a:	01 d0                	add    %edx,%eax
  80165c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80165f:	e9 7b ff ff ff       	jmp    8015df <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801664:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801665:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801669:	74 08                	je     801673 <strtol+0x134>
		*endptr = (char *) s;
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8b 55 08             	mov    0x8(%ebp),%edx
  801671:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801673:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801677:	74 07                	je     801680 <strtol+0x141>
  801679:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167c:	f7 d8                	neg    %eax
  80167e:	eb 03                	jmp    801683 <strtol+0x144>
  801680:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <ltostr>:

void
ltostr(long value, char *str)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80168b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801692:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801699:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80169d:	79 13                	jns    8016b2 <ltostr+0x2d>
	{
		neg = 1;
  80169f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016ac:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016af:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016ba:	99                   	cltd   
  8016bb:	f7 f9                	idiv   %ecx
  8016bd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c3:	8d 50 01             	lea    0x1(%eax),%edx
  8016c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ce:	01 d0                	add    %edx,%eax
  8016d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d3:	83 c2 30             	add    $0x30,%edx
  8016d6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016e0:	f7 e9                	imul   %ecx
  8016e2:	c1 fa 02             	sar    $0x2,%edx
  8016e5:	89 c8                	mov    %ecx,%eax
  8016e7:	c1 f8 1f             	sar    $0x1f,%eax
  8016ea:	29 c2                	sub    %eax,%edx
  8016ec:	89 d0                	mov    %edx,%eax
  8016ee:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8016f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f5:	75 bb                	jne    8016b2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8016f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8016fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801701:	48                   	dec    %eax
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801705:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801709:	74 3d                	je     801748 <ltostr+0xc3>
		start = 1 ;
  80170b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801712:	eb 34                	jmp    801748 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171a:	01 d0                	add    %edx,%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801724:	8b 45 0c             	mov    0xc(%ebp),%eax
  801727:	01 c2                	add    %eax,%edx
  801729:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80172c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172f:	01 c8                	add    %ecx,%eax
  801731:	8a 00                	mov    (%eax),%al
  801733:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801735:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173b:	01 c2                	add    %eax,%edx
  80173d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801740:	88 02                	mov    %al,(%edx)
		start++ ;
  801742:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801745:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80174e:	7c c4                	jl     801714 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801750:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801753:	8b 45 0c             	mov    0xc(%ebp),%eax
  801756:	01 d0                	add    %edx,%eax
  801758:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80175b:	90                   	nop
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801764:	ff 75 08             	pushl  0x8(%ebp)
  801767:	e8 c4 f9 ff ff       	call   801130 <strlen>
  80176c:	83 c4 04             	add    $0x4,%esp
  80176f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801772:	ff 75 0c             	pushl  0xc(%ebp)
  801775:	e8 b6 f9 ff ff       	call   801130 <strlen>
  80177a:	83 c4 04             	add    $0x4,%esp
  80177d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801780:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801787:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80178e:	eb 17                	jmp    8017a7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801790:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801793:	8b 45 10             	mov    0x10(%ebp),%eax
  801796:	01 c2                	add    %eax,%edx
  801798:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	01 c8                	add    %ecx,%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017a4:	ff 45 fc             	incl   -0x4(%ebp)
  8017a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017ad:	7c e1                	jl     801790 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017bd:	eb 1f                	jmp    8017de <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	89 c2                	mov    %eax,%edx
  8017ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cd:	01 c2                	add    %eax,%edx
  8017cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8017d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d5:	01 c8                	add    %ecx,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8017db:	ff 45 f8             	incl   -0x8(%ebp)
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017e4:	7c d9                	jl     8017bf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8017e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ec:	01 d0                	add    %edx,%eax
  8017ee:	c6 00 00             	movb   $0x0,(%eax)
}
  8017f1:	90                   	nop
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8017f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801800:	8b 45 14             	mov    0x14(%ebp),%eax
  801803:	8b 00                	mov    (%eax),%eax
  801805:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	01 d0                	add    %edx,%eax
  801811:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801817:	eb 0c                	jmp    801825 <strsplit+0x31>
			*string++ = 0;
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8d 50 01             	lea    0x1(%eax),%edx
  80181f:	89 55 08             	mov    %edx,0x8(%ebp)
  801822:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	84 c0                	test   %al,%al
  80182c:	74 18                	je     801846 <strsplit+0x52>
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	0f be c0             	movsbl %al,%eax
  801836:	50                   	push   %eax
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	e8 83 fa ff ff       	call   8012c2 <strchr>
  80183f:	83 c4 08             	add    $0x8,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	75 d3                	jne    801819 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	84 c0                	test   %al,%al
  80184d:	74 5a                	je     8018a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	8b 00                	mov    (%eax),%eax
  801854:	83 f8 0f             	cmp    $0xf,%eax
  801857:	75 07                	jne    801860 <strsplit+0x6c>
		{
			return 0;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
  80185e:	eb 66                	jmp    8018c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	8b 00                	mov    (%eax),%eax
  801865:	8d 48 01             	lea    0x1(%eax),%ecx
  801868:	8b 55 14             	mov    0x14(%ebp),%edx
  80186b:	89 0a                	mov    %ecx,(%edx)
  80186d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801874:	8b 45 10             	mov    0x10(%ebp),%eax
  801877:	01 c2                	add    %eax,%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80187e:	eb 03                	jmp    801883 <strsplit+0x8f>
			string++;
  801880:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8a 00                	mov    (%eax),%al
  801888:	84 c0                	test   %al,%al
  80188a:	74 8b                	je     801817 <strsplit+0x23>
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	8a 00                	mov    (%eax),%al
  801891:	0f be c0             	movsbl %al,%eax
  801894:	50                   	push   %eax
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	e8 25 fa ff ff       	call   8012c2 <strchr>
  80189d:	83 c4 08             	add    $0x8,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	74 dc                	je     801880 <strsplit+0x8c>
			string++;
	}
  8018a4:	e9 6e ff ff ff       	jmp    801817 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b9:	01 d0                	add    %edx,%eax
  8018bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8018d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018db:	eb 4a                	jmp    801927 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8018dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	01 c2                	add    %eax,%edx
  8018e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018eb:	01 c8                	add    %ecx,%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8018f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	01 d0                	add    %edx,%eax
  8018f9:	8a 00                	mov    (%eax),%al
  8018fb:	3c 40                	cmp    $0x40,%al
  8018fd:	7e 25                	jle    801924 <str2lower+0x5c>
  8018ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	01 d0                	add    %edx,%eax
  801907:	8a 00                	mov    (%eax),%al
  801909:	3c 5a                	cmp    $0x5a,%al
  80190b:	7f 17                	jg     801924 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80190d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	01 d0                	add    %edx,%eax
  801915:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801918:	8b 55 08             	mov    0x8(%ebp),%edx
  80191b:	01 ca                	add    %ecx,%edx
  80191d:	8a 12                	mov    (%edx),%dl
  80191f:	83 c2 20             	add    $0x20,%edx
  801922:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801924:	ff 45 fc             	incl   -0x4(%ebp)
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	e8 01 f8 ff ff       	call   801130 <strlen>
  80192f:	83 c4 04             	add    $0x4,%esp
  801932:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801935:	7f a6                	jg     8018dd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801937:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801942:	a1 24 60 80 00       	mov    0x806024,%eax
  801947:	85 c0                	test   %eax,%eax
  801949:	74 42                	je     80198d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80194b:	83 ec 08             	sub    $0x8,%esp
  80194e:	68 00 00 00 82       	push   $0x82000000
  801953:	68 00 00 00 80       	push   $0x80000000
  801958:	e8 b0 1e 00 00       	call   80380d <initialize_dynamic_allocator>
  80195d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801960:	e8 96 1c 00 00       	call   8035fb <sys_get_uheap_strategy>
  801965:	a3 a0 a2 83 00       	mov    %eax,0x83a2a0
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80196a:	a1 80 e0 81 00       	mov    0x81e080,%eax
  80196f:	05 00 10 00 00       	add    $0x1000,%eax
  801974:	a3 50 a3 83 00       	mov    %eax,0x83a350
		uheapPageAllocBreak = uheapPageAllocStart;
  801979:	a1 50 a3 83 00       	mov    0x83a350,%eax
  80197e:	a3 a8 a2 83 00       	mov    %eax,0x83a2a8

		__firstTimeFlag = 0;
  801983:	c7 05 24 60 80 00 00 	movl   $0x0,0x806024
  80198a:	00 00 00 
	}
}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019a4:	83 ec 08             	sub    $0x8,%esp
  8019a7:	68 06 04 00 00       	push   $0x406
  8019ac:	50                   	push   %eax
  8019ad:	e8 93 18 00 00       	call   803245 <__sys_allocate_page>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8019b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019bc:	79 14                	jns    8019d2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8019be:	83 ec 04             	sub    $0x4,%esp
  8019c1:	68 28 4e 80 00       	push   $0x804e28
  8019c6:	6a 1f                	push   $0x1f
  8019c8:	68 64 4e 80 00       	push   $0x804e64
  8019cd:	e8 b7 ed ff ff       	call   800789 <_panic>
	return 0;
  8019d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	50                   	push   %eax
  8019f1:	e8 96 18 00 00       	call   80328c <__sys_unmap_frame>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8019fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a00:	79 14                	jns    801a16 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	68 70 4e 80 00       	push   $0x804e70
  801a0a:	6a 2a                	push   $0x2a
  801a0c:	68 64 4e 80 00       	push   $0x804e64
  801a11:	e8 73 ed ff ff       	call   800789 <_panic>
}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801a1f:	e8 18 ff ff ff       	call   80193c <uheap_init>
	if (size == 0) return NULL ;
  801a24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a28:	75 0a                	jne    801a34 <malloc+0x1b>
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2f:	e9 43 03 00 00       	jmp    801d77 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801a34:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801a3b:	77 13                	ja     801a50 <malloc+0x37>
    {
        return alloc_block(size);
  801a3d:	83 ec 0c             	sub    $0xc,%esp
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	e8 78 20 00 00       	call   803ac0 <alloc_block>
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	e9 27 03 00 00       	jmp    801d77 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801a50:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	48                   	dec    %eax
  801a60:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a63:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a66:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6b:	f7 75 dc             	divl   -0x24(%ebp)
  801a6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a71:	29 d0                	sub    %edx,%eax
  801a73:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801a76:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	75 0a                	jne    801a89 <malloc+0x70>
    {
        uhp_inited = 1;
  801a7f:	c7 05 60 e0 81 00 01 	movl   $0x1,0x81e060
  801a86:	00 00 00 
    }

    int exactIdx = -1;
  801a89:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801a90:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801a97:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a9e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801aa5:	e9 85 00 00 00       	jmp    801b2f <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801aaa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aad:	89 d0                	mov    %edx,%eax
  801aaf:	01 c0                	add    %eax,%eax
  801ab1:	01 d0                	add    %edx,%eax
  801ab3:	c1 e0 02             	shl    $0x2,%eax
  801ab6:	05 68 20 81 00       	add    $0x812068,%eax
  801abb:	8a 00                	mov    (%eax),%al
  801abd:	84 c0                	test   %al,%al
  801abf:	74 20                	je     801ae1 <malloc+0xc8>
  801ac1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	01 c0                	add    %eax,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	c1 e0 02             	shl    $0x2,%eax
  801acd:	05 64 20 81 00       	add    $0x812064,%eax
  801ad2:	8b 00                	mov    (%eax),%eax
  801ad4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ad7:	75 08                	jne    801ae1 <malloc+0xc8>
        {
            exactIdx = i;
  801ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801adf:	eb 5b                	jmp    801b3c <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801ae1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ae4:	89 d0                	mov    %edx,%eax
  801ae6:	01 c0                	add    %eax,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	c1 e0 02             	shl    $0x2,%eax
  801aed:	05 68 20 81 00       	add    $0x812068,%eax
  801af2:	8a 00                	mov    (%eax),%al
  801af4:	84 c0                	test   %al,%al
  801af6:	74 34                	je     801b2c <malloc+0x113>
  801af8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801afb:	89 d0                	mov    %edx,%eax
  801afd:	01 c0                	add    %eax,%eax
  801aff:	01 d0                	add    %edx,%eax
  801b01:	c1 e0 02             	shl    $0x2,%eax
  801b04:	05 64 20 81 00       	add    $0x812064,%eax
  801b09:	8b 00                	mov    (%eax),%eax
  801b0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801b0e:	76 1c                	jbe    801b2c <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801b10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b13:	89 d0                	mov    %edx,%eax
  801b15:	01 c0                	add    %eax,%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	c1 e0 02             	shl    $0x2,%eax
  801b1c:	05 64 20 81 00       	add    $0x812064,%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b2c:	ff 45 e8             	incl   -0x18(%ebp)
  801b2f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801b36:	0f 8e 6e ff ff ff    	jle    801aaa <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801b3c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801b43:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801b47:	74 7d                	je     801bc6 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801b49:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b53:	89 d0                	mov    %edx,%eax
  801b55:	01 c0                	add    %eax,%eax
  801b57:	01 d0                	add    %edx,%eax
  801b59:	c1 e0 02             	shl    $0x2,%eax
  801b5c:	05 60 20 81 00       	add    $0x812060,%eax
  801b61:	8b 10                	mov    (%eax),%edx
  801b63:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801b66:	01 d0                	add    %edx,%eax
  801b68:	48                   	dec    %eax
  801b69:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801b6c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b74:	f7 75 bc             	divl   -0x44(%ebp)
  801b77:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b7a:	29 d0                	sub    %edx,%eax
  801b7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b82:	89 d0                	mov    %edx,%eax
  801b84:	01 c0                	add    %eax,%eax
  801b86:	01 d0                	add    %edx,%eax
  801b88:	c1 e0 02             	shl    $0x2,%eax
  801b8b:	05 68 20 81 00       	add    $0x812068,%eax
  801b90:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b96:	89 d0                	mov    %edx,%eax
  801b98:	01 c0                	add    %eax,%eax
  801b9a:	01 d0                	add    %edx,%eax
  801b9c:	c1 e0 02             	shl    $0x2,%eax
  801b9f:	05 64 20 81 00       	add    $0x812064,%eax
  801ba4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bad:	89 d0                	mov    %edx,%eax
  801baf:	01 c0                	add    %eax,%eax
  801bb1:	01 d0                	add    %edx,%eax
  801bb3:	c1 e0 02             	shl    $0x2,%eax
  801bb6:	05 60 20 81 00       	add    $0x812060,%eax
  801bbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bc1:	e9 2d 01 00 00       	jmp    801cf3 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801bc6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801bca:	0f 84 ce 00 00 00    	je     801c9e <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801bd0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801bd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bda:	89 d0                	mov    %edx,%eax
  801bdc:	01 c0                	add    %eax,%eax
  801bde:	01 d0                	add    %edx,%eax
  801be0:	c1 e0 02             	shl    $0x2,%eax
  801be3:	05 60 20 81 00       	add    $0x812060,%eax
  801be8:	8b 10                	mov    (%eax),%edx
  801bea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801bed:	01 d0                	add    %edx,%eax
  801bef:	48                   	dec    %eax
  801bf0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801bf3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bf6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfb:	f7 75 c4             	divl   -0x3c(%ebp)
  801bfe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c01:	29 d0                	sub    %edx,%eax
  801c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801c06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c09:	89 d0                	mov    %edx,%eax
  801c0b:	01 c0                	add    %eax,%eax
  801c0d:	01 d0                	add    %edx,%eax
  801c0f:	c1 e0 02             	shl    $0x2,%eax
  801c12:	05 64 20 81 00       	add    $0x812064,%eax
  801c17:	8b 00                	mov    (%eax),%eax
  801c19:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c1c:	75 47                	jne    801c65 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801c1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c21:	89 d0                	mov    %edx,%eax
  801c23:	01 c0                	add    %eax,%eax
  801c25:	01 d0                	add    %edx,%eax
  801c27:	c1 e0 02             	shl    $0x2,%eax
  801c2a:	05 68 20 81 00       	add    $0x812068,%eax
  801c2f:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801c32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c35:	89 d0                	mov    %edx,%eax
  801c37:	01 c0                	add    %eax,%eax
  801c39:	01 d0                	add    %edx,%eax
  801c3b:	c1 e0 02             	shl    $0x2,%eax
  801c3e:	05 64 20 81 00       	add    $0x812064,%eax
  801c43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801c49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c4c:	89 d0                	mov    %edx,%eax
  801c4e:	01 c0                	add    %eax,%eax
  801c50:	01 d0                	add    %edx,%eax
  801c52:	c1 e0 02             	shl    $0x2,%eax
  801c55:	05 60 20 81 00       	add    $0x812060,%eax
  801c5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c60:	e9 8e 00 00 00       	jmp    801cf3 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801c65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c6b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801c6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c71:	89 d0                	mov    %edx,%eax
  801c73:	01 c0                	add    %eax,%eax
  801c75:	01 d0                	add    %edx,%eax
  801c77:	c1 e0 02             	shl    $0x2,%eax
  801c7a:	05 60 20 81 00       	add    $0x812060,%eax
  801c7f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c84:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c87:	89 c2                	mov    %eax,%edx
  801c89:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c8c:	89 c8                	mov    %ecx,%eax
  801c8e:	01 c0                	add    %eax,%eax
  801c90:	01 c8                	add    %ecx,%eax
  801c92:	c1 e0 02             	shl    $0x2,%eax
  801c95:	05 64 20 81 00       	add    $0x812064,%eax
  801c9a:	89 10                	mov    %edx,(%eax)
  801c9c:	eb 55                	jmp    801cf3 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801c9e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801ca5:	8b 15 a8 a2 83 00    	mov    0x83a2a8,%edx
  801cab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cae:	01 d0                	add    %edx,%eax
  801cb0:	48                   	dec    %eax
  801cb1:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801cb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbc:	f7 75 d0             	divl   -0x30(%ebp)
  801cbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cc2:	29 d0                	sub    %edx,%eax
  801cc4:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801cc7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801cca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ccd:	01 d0                	add    %edx,%eax
  801ccf:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801cd4:	76 0a                	jbe    801ce0 <malloc+0x2c7>
            return NULL;
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdb:	e9 97 00 00 00       	jmp    801d77 <malloc+0x35e>
        va = start;
  801ce0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ce3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801ce6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ce9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cec:	01 d0                	add    %edx,%eax
  801cee:	a3 a8 a2 83 00       	mov    %eax,0x83a2a8
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801cf3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801cfa:	eb 5e                	jmp    801d5a <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801cfc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cff:	89 d0                	mov    %edx,%eax
  801d01:	01 c0                	add    %eax,%eax
  801d03:	01 d0                	add    %edx,%eax
  801d05:	c1 e0 02             	shl    $0x2,%eax
  801d08:	05 68 60 80 00       	add    $0x806068,%eax
  801d0d:	8a 00                	mov    (%eax),%al
  801d0f:	84 c0                	test   %al,%al
  801d11:	75 44                	jne    801d57 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801d13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d16:	89 d0                	mov    %edx,%eax
  801d18:	01 c0                	add    %eax,%eax
  801d1a:	01 d0                	add    %edx,%eax
  801d1c:	c1 e0 02             	shl    $0x2,%eax
  801d1f:	8d 90 60 60 80 00    	lea    0x806060(%eax),%edx
  801d25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d28:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801d2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d2d:	89 d0                	mov    %edx,%eax
  801d2f:	01 c0                	add    %eax,%eax
  801d31:	01 d0                	add    %edx,%eax
  801d33:	c1 e0 02             	shl    $0x2,%eax
  801d36:	8d 90 64 60 80 00    	lea    0x806064(%eax),%edx
  801d3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d3f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801d41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d44:	89 d0                	mov    %edx,%eax
  801d46:	01 c0                	add    %eax,%eax
  801d48:	01 d0                	add    %edx,%eax
  801d4a:	c1 e0 02             	shl    $0x2,%eax
  801d4d:	05 68 60 80 00       	add    $0x806068,%eax
  801d52:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801d55:	eb 0c                	jmp    801d63 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d57:	ff 45 e0             	incl   -0x20(%ebp)
  801d5a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801d61:	7e 99                	jle    801cfc <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	ff 75 d4             	pushl  -0x2c(%ebp)
  801d69:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d6c:	e8 a2 19 00 00       	call   803713 <sys_allocate_user_mem>
  801d71:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801d7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d83:	0f 84 fa 03 00 00    	je     802183 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801d8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d92:	85 c0                	test   %eax,%eax
  801d94:	79 1c                	jns    801db2 <free+0x39>
  801d96:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801d9d:	77 13                	ja     801db2 <free+0x39>
    {
        free_block(virtual_address);
  801d9f:	83 ec 0c             	sub    $0xc,%esp
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	e8 09 21 00 00       	call   803eb3 <free_block>
  801daa:	83 c4 10             	add    $0x10,%esp
        return;
  801dad:	e9 d2 03 00 00       	jmp    802184 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801db2:	a1 50 a3 83 00       	mov    0x83a350,%eax
  801db7:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801dba:	72 09                	jb     801dc5 <free+0x4c>
  801dbc:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801dc3:	76 17                	jbe    801ddc <free+0x63>
        panic("free: invalid address");
  801dc5:	83 ec 04             	sub    $0x4,%esp
  801dc8:	68 ad 4e 80 00       	push   $0x804ead
  801dcd:	68 9b 00 00 00       	push   $0x9b
  801dd2:	68 64 4e 80 00       	push   $0x804e64
  801dd7:	e8 ad e9 ff ff       	call   800789 <_panic>

    uint32 size = 0;
  801ddc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801de3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801dea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801df1:	eb 50                	jmp    801e43 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801df3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801df6:	89 d0                	mov    %edx,%eax
  801df8:	01 c0                	add    %eax,%eax
  801dfa:	01 d0                	add    %edx,%eax
  801dfc:	c1 e0 02             	shl    $0x2,%eax
  801dff:	05 68 60 80 00       	add    $0x806068,%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	84 c0                	test   %al,%al
  801e08:	74 36                	je     801e40 <free+0xc7>
  801e0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e0d:	89 d0                	mov    %edx,%eax
  801e0f:	01 c0                	add    %eax,%eax
  801e11:	01 d0                	add    %edx,%eax
  801e13:	c1 e0 02             	shl    $0x2,%eax
  801e16:	05 60 60 80 00       	add    $0x806060,%eax
  801e1b:	8b 00                	mov    (%eax),%eax
  801e1d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e20:	75 1e                	jne    801e40 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801e22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e25:	89 d0                	mov    %edx,%eax
  801e27:	01 c0                	add    %eax,%eax
  801e29:	01 d0                	add    %edx,%eax
  801e2b:	c1 e0 02             	shl    $0x2,%eax
  801e2e:	05 64 60 80 00       	add    $0x806064,%eax
  801e33:	8b 00                	mov    (%eax),%eax
  801e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801e38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801e3e:	eb 0c                	jmp    801e4c <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e40:	ff 45 ec             	incl   -0x14(%ebp)
  801e43:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801e4a:	7e a7                	jle    801df3 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801e4c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e50:	74 06                	je     801e58 <free+0xdf>
  801e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e56:	75 17                	jne    801e6f <free+0xf6>
        panic("free: unknown block");
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	68 c3 4e 80 00       	push   $0x804ec3
  801e60:	68 a9 00 00 00       	push   $0xa9
  801e65:	68 64 4e 80 00       	push   $0x804e64
  801e6a:	e8 1a e9 ff ff       	call   800789 <_panic>

    uhp_allocs[idx].used = 0;
  801e6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e72:	89 d0                	mov    %edx,%eax
  801e74:	01 c0                	add    %eax,%eax
  801e76:	01 d0                	add    %edx,%eax
  801e78:	c1 e0 02             	shl    $0x2,%eax
  801e7b:	05 68 60 80 00       	add    $0x806068,%eax
  801e80:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801e83:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801e91:	eb 64                	jmp    801ef7 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801e93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e96:	89 d0                	mov    %edx,%eax
  801e98:	01 c0                	add    %eax,%eax
  801e9a:	01 d0                	add    %edx,%eax
  801e9c:	c1 e0 02             	shl    $0x2,%eax
  801e9f:	05 68 20 81 00       	add    $0x812068,%eax
  801ea4:	8a 00                	mov    (%eax),%al
  801ea6:	84 c0                	test   %al,%al
  801ea8:	75 4a                	jne    801ef4 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801eaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ead:	89 d0                	mov    %edx,%eax
  801eaf:	01 c0                	add    %eax,%eax
  801eb1:	01 d0                	add    %edx,%eax
  801eb3:	c1 e0 02             	shl    $0x2,%eax
  801eb6:	8d 90 60 20 81 00    	lea    0x812060(%eax),%edx
  801ebc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ebf:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801ec1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ec4:	89 d0                	mov    %edx,%eax
  801ec6:	01 c0                	add    %eax,%eax
  801ec8:	01 d0                	add    %edx,%eax
  801eca:	c1 e0 02             	shl    $0x2,%eax
  801ecd:	8d 90 64 20 81 00    	lea    0x812064(%eax),%edx
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	01 c0                	add    %eax,%eax
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	c1 e0 02             	shl    $0x2,%eax
  801ee4:	05 68 20 81 00       	add    $0x812068,%eax
  801ee9:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801eec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eef:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801ef2:	eb 0c                	jmp    801f00 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ef4:	ff 45 e4             	incl   -0x1c(%ebp)
  801ef7:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801efe:	7e 93                	jle    801e93 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801f00:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801f04:	0f 84 f1 01 00 00    	je     8020fb <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f11:	e9 d8 01 00 00       	jmp    8020ee <free+0x375>
        {
            if (i == fidx) continue;
  801f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f19:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f1c:	0f 84 c8 01 00 00    	je     8020ea <free+0x371>
            if (uhp_frees[i].free)
  801f22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f25:	89 d0                	mov    %edx,%eax
  801f27:	01 c0                	add    %eax,%eax
  801f29:	01 d0                	add    %edx,%eax
  801f2b:	c1 e0 02             	shl    $0x2,%eax
  801f2e:	05 68 20 81 00       	add    $0x812068,%eax
  801f33:	8a 00                	mov    (%eax),%al
  801f35:	84 c0                	test   %al,%al
  801f37:	0f 84 ae 01 00 00    	je     8020eb <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801f3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f40:	89 d0                	mov    %edx,%eax
  801f42:	01 c0                	add    %eax,%eax
  801f44:	01 d0                	add    %edx,%eax
  801f46:	c1 e0 02             	shl    $0x2,%eax
  801f49:	05 60 20 81 00       	add    $0x812060,%eax
  801f4e:	8b 08                	mov    (%eax),%ecx
  801f50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f53:	89 d0                	mov    %edx,%eax
  801f55:	01 c0                	add    %eax,%eax
  801f57:	01 d0                	add    %edx,%eax
  801f59:	c1 e0 02             	shl    $0x2,%eax
  801f5c:	05 64 20 81 00       	add    $0x812064,%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	01 c1                	add    %eax,%ecx
  801f65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f68:	89 d0                	mov    %edx,%eax
  801f6a:	01 c0                	add    %eax,%eax
  801f6c:	01 d0                	add    %edx,%eax
  801f6e:	c1 e0 02             	shl    $0x2,%eax
  801f71:	05 60 20 81 00       	add    $0x812060,%eax
  801f76:	8b 00                	mov    (%eax),%eax
  801f78:	39 c1                	cmp    %eax,%ecx
  801f7a:	0f 85 a8 00 00 00    	jne    802028 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801f80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f83:	89 d0                	mov    %edx,%eax
  801f85:	01 c0                	add    %eax,%eax
  801f87:	01 d0                	add    %edx,%eax
  801f89:	c1 e0 02             	shl    $0x2,%eax
  801f8c:	05 60 20 81 00       	add    $0x812060,%eax
  801f91:	8b 10                	mov    (%eax),%edx
  801f93:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801f96:	89 c8                	mov    %ecx,%eax
  801f98:	01 c0                	add    %eax,%eax
  801f9a:	01 c8                	add    %ecx,%eax
  801f9c:	c1 e0 02             	shl    $0x2,%eax
  801f9f:	05 60 20 81 00       	add    $0x812060,%eax
  801fa4:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801fa6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fa9:	89 d0                	mov    %edx,%eax
  801fab:	01 c0                	add    %eax,%eax
  801fad:	01 d0                	add    %edx,%eax
  801faf:	c1 e0 02             	shl    $0x2,%eax
  801fb2:	05 64 20 81 00       	add    $0x812064,%eax
  801fb7:	8b 08                	mov    (%eax),%ecx
  801fb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fbc:	89 d0                	mov    %edx,%eax
  801fbe:	01 c0                	add    %eax,%eax
  801fc0:	01 d0                	add    %edx,%eax
  801fc2:	c1 e0 02             	shl    $0x2,%eax
  801fc5:	05 64 20 81 00       	add    $0x812064,%eax
  801fca:	8b 00                	mov    (%eax),%eax
  801fcc:	01 c1                	add    %eax,%ecx
  801fce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fd1:	89 d0                	mov    %edx,%eax
  801fd3:	01 c0                	add    %eax,%eax
  801fd5:	01 d0                	add    %edx,%eax
  801fd7:	c1 e0 02             	shl    $0x2,%eax
  801fda:	05 64 20 81 00       	add    $0x812064,%eax
  801fdf:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801fe1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fe4:	89 d0                	mov    %edx,%eax
  801fe6:	01 c0                	add    %eax,%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	c1 e0 02             	shl    $0x2,%eax
  801fed:	05 68 20 81 00       	add    $0x812068,%eax
  801ff2:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801ff5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ff8:	89 d0                	mov    %edx,%eax
  801ffa:	01 c0                	add    %eax,%eax
  801ffc:	01 d0                	add    %edx,%eax
  801ffe:	c1 e0 02             	shl    $0x2,%eax
  802001:	05 60 20 81 00       	add    $0x812060,%eax
  802006:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  80200c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80200f:	89 d0                	mov    %edx,%eax
  802011:	01 c0                	add    %eax,%eax
  802013:	01 d0                	add    %edx,%eax
  802015:	c1 e0 02             	shl    $0x2,%eax
  802018:	05 64 20 81 00       	add    $0x812064,%eax
  80201d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802023:	e9 c3 00 00 00       	jmp    8020eb <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  802028:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80202b:	89 d0                	mov    %edx,%eax
  80202d:	01 c0                	add    %eax,%eax
  80202f:	01 d0                	add    %edx,%eax
  802031:	c1 e0 02             	shl    $0x2,%eax
  802034:	05 60 20 81 00       	add    $0x812060,%eax
  802039:	8b 08                	mov    (%eax),%ecx
  80203b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80203e:	89 d0                	mov    %edx,%eax
  802040:	01 c0                	add    %eax,%eax
  802042:	01 d0                	add    %edx,%eax
  802044:	c1 e0 02             	shl    $0x2,%eax
  802047:	05 64 20 81 00       	add    $0x812064,%eax
  80204c:	8b 00                	mov    (%eax),%eax
  80204e:	01 c1                	add    %eax,%ecx
  802050:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802053:	89 d0                	mov    %edx,%eax
  802055:	01 c0                	add    %eax,%eax
  802057:	01 d0                	add    %edx,%eax
  802059:	c1 e0 02             	shl    $0x2,%eax
  80205c:	05 60 20 81 00       	add    $0x812060,%eax
  802061:	8b 00                	mov    (%eax),%eax
  802063:	39 c1                	cmp    %eax,%ecx
  802065:	0f 85 80 00 00 00    	jne    8020eb <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80206b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80206e:	89 d0                	mov    %edx,%eax
  802070:	01 c0                	add    %eax,%eax
  802072:	01 d0                	add    %edx,%eax
  802074:	c1 e0 02             	shl    $0x2,%eax
  802077:	05 64 20 81 00       	add    $0x812064,%eax
  80207c:	8b 08                	mov    (%eax),%ecx
  80207e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802081:	89 d0                	mov    %edx,%eax
  802083:	01 c0                	add    %eax,%eax
  802085:	01 d0                	add    %edx,%eax
  802087:	c1 e0 02             	shl    $0x2,%eax
  80208a:	05 64 20 81 00       	add    $0x812064,%eax
  80208f:	8b 00                	mov    (%eax),%eax
  802091:	01 c1                	add    %eax,%ecx
  802093:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802096:	89 d0                	mov    %edx,%eax
  802098:	01 c0                	add    %eax,%eax
  80209a:	01 d0                	add    %edx,%eax
  80209c:	c1 e0 02             	shl    $0x2,%eax
  80209f:	05 64 20 81 00       	add    $0x812064,%eax
  8020a4:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8020a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020a9:	89 d0                	mov    %edx,%eax
  8020ab:	01 c0                	add    %eax,%eax
  8020ad:	01 d0                	add    %edx,%eax
  8020af:	c1 e0 02             	shl    $0x2,%eax
  8020b2:	05 68 20 81 00       	add    $0x812068,%eax
  8020b7:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8020ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020bd:	89 d0                	mov    %edx,%eax
  8020bf:	01 c0                	add    %eax,%eax
  8020c1:	01 d0                	add    %edx,%eax
  8020c3:	c1 e0 02             	shl    $0x2,%eax
  8020c6:	05 60 20 81 00       	add    $0x812060,%eax
  8020cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8020d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020d4:	89 d0                	mov    %edx,%eax
  8020d6:	01 c0                	add    %eax,%eax
  8020d8:	01 d0                	add    %edx,%eax
  8020da:	c1 e0 02             	shl    $0x2,%eax
  8020dd:	05 64 20 81 00       	add    $0x812064,%eax
  8020e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020e8:	eb 01                	jmp    8020eb <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  8020ea:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020eb:	ff 45 e0             	incl   -0x20(%ebp)
  8020ee:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8020f5:	0f 8e 1b fe ff ff    	jle    801f16 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  8020fb:	a1 50 a3 83 00       	mov    0x83a350,%eax
  802100:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802103:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80210a:	eb 53                	jmp    80215f <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  80210c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80210f:	89 d0                	mov    %edx,%eax
  802111:	01 c0                	add    %eax,%eax
  802113:	01 d0                	add    %edx,%eax
  802115:	c1 e0 02             	shl    $0x2,%eax
  802118:	05 68 60 80 00       	add    $0x806068,%eax
  80211d:	8a 00                	mov    (%eax),%al
  80211f:	84 c0                	test   %al,%al
  802121:	74 39                	je     80215c <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802123:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802126:	89 d0                	mov    %edx,%eax
  802128:	01 c0                	add    %eax,%eax
  80212a:	01 d0                	add    %edx,%eax
  80212c:	c1 e0 02             	shl    $0x2,%eax
  80212f:	05 60 60 80 00       	add    $0x806060,%eax
  802134:	8b 08                	mov    (%eax),%ecx
  802136:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802139:	89 d0                	mov    %edx,%eax
  80213b:	01 c0                	add    %eax,%eax
  80213d:	01 d0                	add    %edx,%eax
  80213f:	c1 e0 02             	shl    $0x2,%eax
  802142:	05 64 60 80 00       	add    $0x806064,%eax
  802147:	8b 00                	mov    (%eax),%eax
  802149:	01 c8                	add    %ecx,%eax
  80214b:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  80214e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802151:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802154:	76 06                	jbe    80215c <free+0x3e3>
  802156:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802159:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80215c:	ff 45 d8             	incl   -0x28(%ebp)
  80215f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802166:	7e a4                	jle    80210c <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802168:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80216b:	a3 a8 a2 83 00       	mov    %eax,0x83a2a8

    sys_free_user_mem(va, size);
  802170:	83 ec 08             	sub    $0x8,%esp
  802173:	ff 75 f4             	pushl  -0xc(%ebp)
  802176:	ff 75 d4             	pushl  -0x2c(%ebp)
  802179:	e8 79 15 00 00       	call   8036f7 <sys_free_user_mem>
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	eb 01                	jmp    802184 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802183:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 68             	sub    $0x68,%esp
  80218c:	8b 45 10             	mov    0x10(%ebp),%eax
  80218f:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802192:	e8 a5 f7 ff ff       	call   80193c <uheap_init>
	if (size == 0) return NULL ;
  802197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80219b:	75 0a                	jne    8021a7 <smalloc+0x21>
  80219d:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a2:	e9 37 03 00 00       	jmp    8024de <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8021a7:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021b4:	01 d0                	add    %edx,%eax
  8021b6:	48                   	dec    %eax
  8021b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c2:	f7 75 dc             	divl   -0x24(%ebp)
  8021c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021c8:	29 d0                	sub    %edx,%eax
  8021ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  8021cd:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8021d4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8021db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8021e9:	e9 85 00 00 00       	jmp    802273 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8021ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021f1:	89 d0                	mov    %edx,%eax
  8021f3:	01 c0                	add    %eax,%eax
  8021f5:	01 d0                	add    %edx,%eax
  8021f7:	c1 e0 02             	shl    $0x2,%eax
  8021fa:	05 68 20 81 00       	add    $0x812068,%eax
  8021ff:	8a 00                	mov    (%eax),%al
  802201:	84 c0                	test   %al,%al
  802203:	74 20                	je     802225 <smalloc+0x9f>
  802205:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802208:	89 d0                	mov    %edx,%eax
  80220a:	01 c0                	add    %eax,%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c1 e0 02             	shl    $0x2,%eax
  802211:	05 64 20 81 00       	add    $0x812064,%eax
  802216:	8b 00                	mov    (%eax),%eax
  802218:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80221b:	75 08                	jne    802225 <smalloc+0x9f>
        {
            exactIdx = i;
  80221d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802220:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802223:	eb 5b                	jmp    802280 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802225:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802228:	89 d0                	mov    %edx,%eax
  80222a:	01 c0                	add    %eax,%eax
  80222c:	01 d0                	add    %edx,%eax
  80222e:	c1 e0 02             	shl    $0x2,%eax
  802231:	05 68 20 81 00       	add    $0x812068,%eax
  802236:	8a 00                	mov    (%eax),%al
  802238:	84 c0                	test   %al,%al
  80223a:	74 34                	je     802270 <smalloc+0xea>
  80223c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80223f:	89 d0                	mov    %edx,%eax
  802241:	01 c0                	add    %eax,%eax
  802243:	01 d0                	add    %edx,%eax
  802245:	c1 e0 02             	shl    $0x2,%eax
  802248:	05 64 20 81 00       	add    $0x812064,%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802252:	76 1c                	jbe    802270 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802254:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802257:	89 d0                	mov    %edx,%eax
  802259:	01 c0                	add    %eax,%eax
  80225b:	01 d0                	add    %edx,%eax
  80225d:	c1 e0 02             	shl    $0x2,%eax
  802260:	05 64 20 81 00       	add    $0x812064,%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80226a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80226d:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802270:	ff 45 e8             	incl   -0x18(%ebp)
  802273:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80227a:	0f 8e 6e ff ff ff    	jle    8021ee <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802280:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802287:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80228b:	74 7d                	je     80230a <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80228d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802297:	89 d0                	mov    %edx,%eax
  802299:	01 c0                	add    %eax,%eax
  80229b:	01 d0                	add    %edx,%eax
  80229d:	c1 e0 02             	shl    $0x2,%eax
  8022a0:	05 60 20 81 00       	add    $0x812060,%eax
  8022a5:	8b 10                	mov    (%eax),%edx
  8022a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	48                   	dec    %eax
  8022ad:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8022b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8022b8:	f7 75 bc             	divl   -0x44(%ebp)
  8022bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022be:	29 d0                	sub    %edx,%eax
  8022c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8022c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c6:	89 d0                	mov    %edx,%eax
  8022c8:	01 c0                	add    %eax,%eax
  8022ca:	01 d0                	add    %edx,%eax
  8022cc:	c1 e0 02             	shl    $0x2,%eax
  8022cf:	05 68 20 81 00       	add    $0x812068,%eax
  8022d4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8022d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022da:	89 d0                	mov    %edx,%eax
  8022dc:	01 c0                	add    %eax,%eax
  8022de:	01 d0                	add    %edx,%eax
  8022e0:	c1 e0 02             	shl    $0x2,%eax
  8022e3:	05 64 20 81 00       	add    $0x812064,%eax
  8022e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8022ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f1:	89 d0                	mov    %edx,%eax
  8022f3:	01 c0                	add    %eax,%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c1 e0 02             	shl    $0x2,%eax
  8022fa:	05 60 20 81 00       	add    $0x812060,%eax
  8022ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802305:	e9 2d 01 00 00       	jmp    802437 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  80230a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80230e:	0f 84 ce 00 00 00    	je     8023e2 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802314:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80231b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80231e:	89 d0                	mov    %edx,%eax
  802320:	01 c0                	add    %eax,%eax
  802322:	01 d0                	add    %edx,%eax
  802324:	c1 e0 02             	shl    $0x2,%eax
  802327:	05 60 20 81 00       	add    $0x812060,%eax
  80232c:	8b 10                	mov    (%eax),%edx
  80232e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802331:	01 d0                	add    %edx,%eax
  802333:	48                   	dec    %eax
  802334:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802337:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80233a:	ba 00 00 00 00       	mov    $0x0,%edx
  80233f:	f7 75 c4             	divl   -0x3c(%ebp)
  802342:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802345:	29 d0                	sub    %edx,%eax
  802347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80234a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234d:	89 d0                	mov    %edx,%eax
  80234f:	01 c0                	add    %eax,%eax
  802351:	01 d0                	add    %edx,%eax
  802353:	c1 e0 02             	shl    $0x2,%eax
  802356:	05 64 20 81 00       	add    $0x812064,%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802360:	75 47                	jne    8023a9 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802362:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802365:	89 d0                	mov    %edx,%eax
  802367:	01 c0                	add    %eax,%eax
  802369:	01 d0                	add    %edx,%eax
  80236b:	c1 e0 02             	shl    $0x2,%eax
  80236e:	05 68 20 81 00       	add    $0x812068,%eax
  802373:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802376:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802379:	89 d0                	mov    %edx,%eax
  80237b:	01 c0                	add    %eax,%eax
  80237d:	01 d0                	add    %edx,%eax
  80237f:	c1 e0 02             	shl    $0x2,%eax
  802382:	05 64 20 81 00       	add    $0x812064,%eax
  802387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80238d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802390:	89 d0                	mov    %edx,%eax
  802392:	01 c0                	add    %eax,%eax
  802394:	01 d0                	add    %edx,%eax
  802396:	c1 e0 02             	shl    $0x2,%eax
  802399:	05 60 20 81 00       	add    $0x812060,%eax
  80239e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a4:	e9 8e 00 00 00       	jmp    802437 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8023a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023af:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8023b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b5:	89 d0                	mov    %edx,%eax
  8023b7:	01 c0                	add    %eax,%eax
  8023b9:	01 d0                	add    %edx,%eax
  8023bb:	c1 e0 02             	shl    $0x2,%eax
  8023be:	05 60 20 81 00       	add    $0x812060,%eax
  8023c3:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8023c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8023cb:	89 c2                	mov    %eax,%edx
  8023cd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8023d0:	89 c8                	mov    %ecx,%eax
  8023d2:	01 c0                	add    %eax,%eax
  8023d4:	01 c8                	add    %ecx,%eax
  8023d6:	c1 e0 02             	shl    $0x2,%eax
  8023d9:	05 64 20 81 00       	add    $0x812064,%eax
  8023de:	89 10                	mov    %edx,(%eax)
  8023e0:	eb 55                	jmp    802437 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8023e2:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8023e9:	8b 15 a8 a2 83 00    	mov    0x83a2a8,%edx
  8023ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f2:	01 d0                	add    %edx,%eax
  8023f4:	48                   	dec    %eax
  8023f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8023f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802400:	f7 75 d0             	divl   -0x30(%ebp)
  802403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802406:	29 d0                	sub    %edx,%eax
  802408:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80240b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80240e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802411:	01 d0                	add    %edx,%eax
  802413:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802418:	76 0a                	jbe    802424 <smalloc+0x29e>
            return NULL;
  80241a:	b8 00 00 00 00       	mov    $0x0,%eax
  80241f:	e9 ba 00 00 00       	jmp    8024de <smalloc+0x358>
        va = start;
  802424:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80242a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80242d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802430:	01 d0                	add    %edx,%eax
  802432:	a3 a8 a2 83 00       	mov    %eax,0x83a2a8
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802437:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80243e:	eb 5e                	jmp    80249e <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802440:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802443:	89 d0                	mov    %edx,%eax
  802445:	01 c0                	add    %eax,%eax
  802447:	01 d0                	add    %edx,%eax
  802449:	c1 e0 02             	shl    $0x2,%eax
  80244c:	05 68 60 80 00       	add    $0x806068,%eax
  802451:	8a 00                	mov    (%eax),%al
  802453:	84 c0                	test   %al,%al
  802455:	75 44                	jne    80249b <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802457:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80245a:	89 d0                	mov    %edx,%eax
  80245c:	01 c0                	add    %eax,%eax
  80245e:	01 d0                	add    %edx,%eax
  802460:	c1 e0 02             	shl    $0x2,%eax
  802463:	8d 90 60 60 80 00    	lea    0x806060(%eax),%edx
  802469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80246e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802471:	89 d0                	mov    %edx,%eax
  802473:	01 c0                	add    %eax,%eax
  802475:	01 d0                	add    %edx,%eax
  802477:	c1 e0 02             	shl    $0x2,%eax
  80247a:	8d 90 64 60 80 00    	lea    0x806064(%eax),%edx
  802480:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802483:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802485:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802488:	89 d0                	mov    %edx,%eax
  80248a:	01 c0                	add    %eax,%eax
  80248c:	01 d0                	add    %edx,%eax
  80248e:	c1 e0 02             	shl    $0x2,%eax
  802491:	05 68 60 80 00       	add    $0x806068,%eax
  802496:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802499:	eb 0c                	jmp    8024a7 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80249b:	ff 45 e0             	incl   -0x20(%ebp)
  80249e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8024a5:	7e 99                	jle    802440 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8024a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024aa:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8024ae:	52                   	push   %edx
  8024af:	50                   	push   %eax
  8024b0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8024b3:	ff 75 08             	pushl  0x8(%ebp)
  8024b6:	e8 de 0e 00 00       	call   803399 <sys_create_shared_object>
  8024bb:	83 c4 10             	add    $0x10,%esp
  8024be:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8024c1:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8024c5:	75 07                	jne    8024ce <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8024c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8024cc:	eb 10                	jmp    8024de <smalloc+0x358>
    if (r < 0)
  8024ce:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8024d2:	79 07                	jns    8024db <smalloc+0x355>
        return NULL;
  8024d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d9:	eb 03                	jmp    8024de <smalloc+0x358>
    return (void*)va;
  8024db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024e6:	e8 51 f4 ff ff       	call   80193c <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8024eb:	83 ec 08             	sub    $0x8,%esp
  8024ee:	ff 75 0c             	pushl  0xc(%ebp)
  8024f1:	ff 75 08             	pushl  0x8(%ebp)
  8024f4:	e8 ca 0e 00 00       	call   8033c3 <sys_size_of_shared_object>
  8024f9:	83 c4 10             	add    $0x10,%esp
  8024fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8024ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802503:	7f 0a                	jg     80250f <sget+0x2f>
        return NULL;
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
  80250a:	e9 28 03 00 00       	jmp    802837 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80250f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802516:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802519:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80251c:	01 d0                	add    %edx,%eax
  80251e:	48                   	dec    %eax
  80251f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802522:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802525:	ba 00 00 00 00       	mov    $0x0,%edx
  80252a:	f7 75 d8             	divl   -0x28(%ebp)
  80252d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802530:	29 d0                	sub    %edx,%eax
  802532:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802535:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80253c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802543:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80254a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802551:	e9 85 00 00 00       	jmp    8025db <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802556:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802559:	89 d0                	mov    %edx,%eax
  80255b:	01 c0                	add    %eax,%eax
  80255d:	01 d0                	add    %edx,%eax
  80255f:	c1 e0 02             	shl    $0x2,%eax
  802562:	05 68 20 81 00       	add    $0x812068,%eax
  802567:	8a 00                	mov    (%eax),%al
  802569:	84 c0                	test   %al,%al
  80256b:	74 20                	je     80258d <sget+0xad>
  80256d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802570:	89 d0                	mov    %edx,%eax
  802572:	01 c0                	add    %eax,%eax
  802574:	01 d0                	add    %edx,%eax
  802576:	c1 e0 02             	shl    $0x2,%eax
  802579:	05 64 20 81 00       	add    $0x812064,%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802583:	75 08                	jne    80258d <sget+0xad>
        {
            exactIdx = i;
  802585:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802588:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80258b:	eb 5b                	jmp    8025e8 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80258d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802590:	89 d0                	mov    %edx,%eax
  802592:	01 c0                	add    %eax,%eax
  802594:	01 d0                	add    %edx,%eax
  802596:	c1 e0 02             	shl    $0x2,%eax
  802599:	05 68 20 81 00       	add    $0x812068,%eax
  80259e:	8a 00                	mov    (%eax),%al
  8025a0:	84 c0                	test   %al,%al
  8025a2:	74 34                	je     8025d8 <sget+0xf8>
  8025a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025a7:	89 d0                	mov    %edx,%eax
  8025a9:	01 c0                	add    %eax,%eax
  8025ab:	01 d0                	add    %edx,%eax
  8025ad:	c1 e0 02             	shl    $0x2,%eax
  8025b0:	05 64 20 81 00       	add    $0x812064,%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025ba:	76 1c                	jbe    8025d8 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8025bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025bf:	89 d0                	mov    %edx,%eax
  8025c1:	01 c0                	add    %eax,%eax
  8025c3:	01 d0                	add    %edx,%eax
  8025c5:	c1 e0 02             	shl    $0x2,%eax
  8025c8:	05 64 20 81 00       	add    $0x812064,%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8025d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8025d8:	ff 45 e8             	incl   -0x18(%ebp)
  8025db:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8025e2:	0f 8e 6e ff ff ff    	jle    802556 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8025e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8025ef:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8025f3:	74 7d                	je     802672 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8025f5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8025fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ff:	89 d0                	mov    %edx,%eax
  802601:	01 c0                	add    %eax,%eax
  802603:	01 d0                	add    %edx,%eax
  802605:	c1 e0 02             	shl    $0x2,%eax
  802608:	05 60 20 81 00       	add    $0x812060,%eax
  80260d:	8b 10                	mov    (%eax),%edx
  80260f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802612:	01 d0                	add    %edx,%eax
  802614:	48                   	dec    %eax
  802615:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802618:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80261b:	ba 00 00 00 00       	mov    $0x0,%edx
  802620:	f7 75 b8             	divl   -0x48(%ebp)
  802623:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802626:	29 d0                	sub    %edx,%eax
  802628:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80262b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262e:	89 d0                	mov    %edx,%eax
  802630:	01 c0                	add    %eax,%eax
  802632:	01 d0                	add    %edx,%eax
  802634:	c1 e0 02             	shl    $0x2,%eax
  802637:	05 68 20 81 00       	add    $0x812068,%eax
  80263c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80263f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802642:	89 d0                	mov    %edx,%eax
  802644:	01 c0                	add    %eax,%eax
  802646:	01 d0                	add    %edx,%eax
  802648:	c1 e0 02             	shl    $0x2,%eax
  80264b:	05 64 20 81 00       	add    $0x812064,%eax
  802650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802659:	89 d0                	mov    %edx,%eax
  80265b:	01 c0                	add    %eax,%eax
  80265d:	01 d0                	add    %edx,%eax
  80265f:	c1 e0 02             	shl    $0x2,%eax
  802662:	05 60 20 81 00       	add    $0x812060,%eax
  802667:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266d:	e9 2d 01 00 00       	jmp    80279f <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802672:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802676:	0f 84 ce 00 00 00    	je     80274a <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80267c:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802683:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802686:	89 d0                	mov    %edx,%eax
  802688:	01 c0                	add    %eax,%eax
  80268a:	01 d0                	add    %edx,%eax
  80268c:	c1 e0 02             	shl    $0x2,%eax
  80268f:	05 60 20 81 00       	add    $0x812060,%eax
  802694:	8b 10                	mov    (%eax),%edx
  802696:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802699:	01 d0                	add    %edx,%eax
  80269b:	48                   	dec    %eax
  80269c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80269f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a7:	f7 75 c0             	divl   -0x40(%ebp)
  8026aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026ad:	29 d0                	sub    %edx,%eax
  8026af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8026b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b5:	89 d0                	mov    %edx,%eax
  8026b7:	01 c0                	add    %eax,%eax
  8026b9:	01 d0                	add    %edx,%eax
  8026bb:	c1 e0 02             	shl    $0x2,%eax
  8026be:	05 64 20 81 00       	add    $0x812064,%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8026c8:	75 47                	jne    802711 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8026ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026cd:	89 d0                	mov    %edx,%eax
  8026cf:	01 c0                	add    %eax,%eax
  8026d1:	01 d0                	add    %edx,%eax
  8026d3:	c1 e0 02             	shl    $0x2,%eax
  8026d6:	05 68 20 81 00       	add    $0x812068,%eax
  8026db:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8026de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e1:	89 d0                	mov    %edx,%eax
  8026e3:	01 c0                	add    %eax,%eax
  8026e5:	01 d0                	add    %edx,%eax
  8026e7:	c1 e0 02             	shl    $0x2,%eax
  8026ea:	05 64 20 81 00       	add    $0x812064,%eax
  8026ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8026f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f8:	89 d0                	mov    %edx,%eax
  8026fa:	01 c0                	add    %eax,%eax
  8026fc:	01 d0                	add    %edx,%eax
  8026fe:	c1 e0 02             	shl    $0x2,%eax
  802701:	05 60 20 81 00       	add    $0x812060,%eax
  802706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270c:	e9 8e 00 00 00       	jmp    80279f <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802711:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802714:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802717:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80271a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271d:	89 d0                	mov    %edx,%eax
  80271f:	01 c0                	add    %eax,%eax
  802721:	01 d0                	add    %edx,%eax
  802723:	c1 e0 02             	shl    $0x2,%eax
  802726:	05 60 20 81 00       	add    $0x812060,%eax
  80272b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80272d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802730:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802733:	89 c2                	mov    %eax,%edx
  802735:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802738:	89 c8                	mov    %ecx,%eax
  80273a:	01 c0                	add    %eax,%eax
  80273c:	01 c8                	add    %ecx,%eax
  80273e:	c1 e0 02             	shl    $0x2,%eax
  802741:	05 64 20 81 00       	add    $0x812064,%eax
  802746:	89 10                	mov    %edx,(%eax)
  802748:	eb 55                	jmp    80279f <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80274a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802751:	8b 15 a8 a2 83 00    	mov    0x83a2a8,%edx
  802757:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275a:	01 d0                	add    %edx,%eax
  80275c:	48                   	dec    %eax
  80275d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802760:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802763:	ba 00 00 00 00       	mov    $0x0,%edx
  802768:	f7 75 cc             	divl   -0x34(%ebp)
  80276b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80276e:	29 d0                	sub    %edx,%eax
  802770:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802773:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802776:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802779:	01 d0                	add    %edx,%eax
  80277b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802780:	76 0a                	jbe    80278c <sget+0x2ac>
            return NULL;
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
  802787:	e9 ab 00 00 00       	jmp    802837 <sget+0x357>
        va = start;
  80278c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80278f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802792:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802795:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802798:	01 d0                	add    %edx,%eax
  80279a:	a3 a8 a2 83 00       	mov    %eax,0x83a2a8
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80279f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027a6:	eb 5e                	jmp    802806 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8027a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ab:	89 d0                	mov    %edx,%eax
  8027ad:	01 c0                	add    %eax,%eax
  8027af:	01 d0                	add    %edx,%eax
  8027b1:	c1 e0 02             	shl    $0x2,%eax
  8027b4:	05 68 60 80 00       	add    $0x806068,%eax
  8027b9:	8a 00                	mov    (%eax),%al
  8027bb:	84 c0                	test   %al,%al
  8027bd:	75 44                	jne    802803 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8027bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c2:	89 d0                	mov    %edx,%eax
  8027c4:	01 c0                	add    %eax,%eax
  8027c6:	01 d0                	add    %edx,%eax
  8027c8:	c1 e0 02             	shl    $0x2,%eax
  8027cb:	8d 90 60 60 80 00    	lea    0x806060(%eax),%edx
  8027d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8027d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027d9:	89 d0                	mov    %edx,%eax
  8027db:	01 c0                	add    %eax,%eax
  8027dd:	01 d0                	add    %edx,%eax
  8027df:	c1 e0 02             	shl    $0x2,%eax
  8027e2:	8d 90 64 60 80 00    	lea    0x806064(%eax),%edx
  8027e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027eb:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8027ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027f0:	89 d0                	mov    %edx,%eax
  8027f2:	01 c0                	add    %eax,%eax
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	c1 e0 02             	shl    $0x2,%eax
  8027f9:	05 68 60 80 00       	add    $0x806068,%eax
  8027fe:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802801:	eb 0c                	jmp    80280f <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802803:	ff 45 e0             	incl   -0x20(%ebp)
  802806:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80280d:	7e 99                	jle    8027a8 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80280f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802812:	83 ec 04             	sub    $0x4,%esp
  802815:	50                   	push   %eax
  802816:	ff 75 0c             	pushl  0xc(%ebp)
  802819:	ff 75 08             	pushl  0x8(%ebp)
  80281c:	e8 bf 0b 00 00       	call   8033e0 <sys_get_shared_object>
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802827:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80282b:	79 07                	jns    802834 <sget+0x354>
        return NULL;
  80282d:	b8 00 00 00 00       	mov    $0x0,%eax
  802832:	eb 03                	jmp    802837 <sget+0x357>
    return (void*)va;
  802834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80283f:	e8 f8 f0 ff ff       	call   80193c <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802844:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802848:	75 13                	jne    80285d <realloc+0x24>
		return malloc(new_size);
  80284a:	83 ec 0c             	sub    $0xc,%esp
  80284d:	ff 75 0c             	pushl  0xc(%ebp)
  802850:	e8 c4 f1 ff ff       	call   801a19 <malloc>
  802855:	83 c4 10             	add    $0x10,%esp
  802858:	e9 f4 05 00 00       	jmp    802e51 <realloc+0x618>
	if (new_size == 0)
  80285d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802861:	75 18                	jne    80287b <realloc+0x42>
	{
		free(virtual_address);
  802863:	83 ec 0c             	sub    $0xc,%esp
  802866:	ff 75 08             	pushl  0x8(%ebp)
  802869:	e8 0b f5 ff ff       	call   801d79 <free>
  80286e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802871:	b8 00 00 00 00       	mov    $0x0,%eax
  802876:	e9 d6 05 00 00       	jmp    802e51 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  80287b:	8b 45 08             	mov    0x8(%ebp),%eax
  80287e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802881:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802884:	85 c0                	test   %eax,%eax
  802886:	79 74                	jns    8028fc <realloc+0xc3>
  802888:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80288f:	77 6b                	ja     8028fc <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802891:	83 ec 0c             	sub    $0xc,%esp
  802894:	ff 75 0c             	pushl  0xc(%ebp)
  802897:	e8 7d f1 ff ff       	call   801a19 <malloc>
  80289c:	83 c4 10             	add    $0x10,%esp
  80289f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8028a2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8028a6:	75 0a                	jne    8028b2 <realloc+0x79>
			return NULL;
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ad:	e9 9f 05 00 00       	jmp    802e51 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8028b2:	83 ec 0c             	sub    $0xc,%esp
  8028b5:	ff 75 08             	pushl  0x8(%ebp)
  8028b8:	e8 e0 11 00 00       	call   803a9d <get_block_size>
  8028bd:	83 c4 10             	add    $0x10,%esp
  8028c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8028c3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8028c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c9:	39 d0                	cmp    %edx,%eax
  8028cb:	76 02                	jbe    8028cf <realloc+0x96>
  8028cd:	89 d0                	mov    %edx,%eax
  8028cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	ff 75 c0             	pushl  -0x40(%ebp)
  8028d8:	ff 75 08             	pushl  0x8(%ebp)
  8028db:	ff 75 c8             	pushl  -0x38(%ebp)
  8028de:	e8 56 eb ff ff       	call   801439 <memmove>
  8028e3:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8028e6:	83 ec 0c             	sub    $0xc,%esp
  8028e9:	ff 75 08             	pushl  0x8(%ebp)
  8028ec:	e8 88 f4 ff ff       	call   801d79 <free>
  8028f1:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8028f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028f7:	e9 55 05 00 00       	jmp    802e51 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8028fc:	a1 50 a3 83 00       	mov    0x83a350,%eax
  802901:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802904:	72 09                	jb     80290f <realloc+0xd6>
  802906:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80290d:	76 0a                	jbe    802919 <realloc+0xe0>
		return NULL;
  80290f:	b8 00 00 00 00       	mov    $0x0,%eax
  802914:	e9 38 05 00 00       	jmp    802e51 <realloc+0x618>
	uint32 oldsz = 0;
  802919:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802920:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802927:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80292e:	eb 50                	jmp    802980 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802930:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802933:	89 d0                	mov    %edx,%eax
  802935:	01 c0                	add    %eax,%eax
  802937:	01 d0                	add    %edx,%eax
  802939:	c1 e0 02             	shl    $0x2,%eax
  80293c:	05 68 60 80 00       	add    $0x806068,%eax
  802941:	8a 00                	mov    (%eax),%al
  802943:	84 c0                	test   %al,%al
  802945:	74 36                	je     80297d <realloc+0x144>
  802947:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80294a:	89 d0                	mov    %edx,%eax
  80294c:	01 c0                	add    %eax,%eax
  80294e:	01 d0                	add    %edx,%eax
  802950:	c1 e0 02             	shl    $0x2,%eax
  802953:	05 60 60 80 00       	add    $0x806060,%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80295d:	75 1e                	jne    80297d <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80295f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802962:	89 d0                	mov    %edx,%eax
  802964:	01 c0                	add    %eax,%eax
  802966:	01 d0                	add    %edx,%eax
  802968:	c1 e0 02             	shl    $0x2,%eax
  80296b:	05 64 60 80 00       	add    $0x806064,%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802978:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80297b:	eb 0c                	jmp    802989 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80297d:	ff 45 ec             	incl   -0x14(%ebp)
  802980:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802987:	7e a7                	jle    802930 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802989:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80298d:	75 0a                	jne    802999 <realloc+0x160>
		return NULL;
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
  802994:	e9 b8 04 00 00       	jmp    802e51 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802999:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8029a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029a6:	01 d0                	add    %edx,%eax
  8029a8:	48                   	dec    %eax
  8029a9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8029ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029af:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b4:	f7 75 bc             	divl   -0x44(%ebp)
  8029b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029ba:	29 d0                	sub    %edx,%eax
  8029bc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8029bf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8029c5:	75 08                	jne    8029cf <realloc+0x196>
		return virtual_address;
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	e9 82 04 00 00       	jmp    802e51 <realloc+0x618>
	if (req < oldsz)
  8029cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8029d5:	0f 83 cd 02 00 00    	jae    802ca8 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8029e1:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8029e4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029ea:	01 d0                	add    %edx,%eax
  8029ec:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8029ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f2:	89 d0                	mov    %edx,%eax
  8029f4:	01 c0                	add    %eax,%eax
  8029f6:	01 d0                	add    %edx,%eax
  8029f8:	c1 e0 02             	shl    $0x2,%eax
  8029fb:	8d 90 64 60 80 00    	lea    0x806064(%eax),%edx
  802a01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a04:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802a06:	83 ec 08             	sub    $0x8,%esp
  802a09:	ff 75 b0             	pushl  -0x50(%ebp)
  802a0c:	ff 75 ac             	pushl  -0x54(%ebp)
  802a0f:	e8 e3 0c 00 00       	call   8036f7 <sys_free_user_mem>
  802a14:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802a17:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802a25:	eb 64                	jmp    802a8b <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a2a:	89 d0                	mov    %edx,%eax
  802a2c:	01 c0                	add    %eax,%eax
  802a2e:	01 d0                	add    %edx,%eax
  802a30:	c1 e0 02             	shl    $0x2,%eax
  802a33:	05 68 20 81 00       	add    $0x812068,%eax
  802a38:	8a 00                	mov    (%eax),%al
  802a3a:	84 c0                	test   %al,%al
  802a3c:	75 4a                	jne    802a88 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802a3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a41:	89 d0                	mov    %edx,%eax
  802a43:	01 c0                	add    %eax,%eax
  802a45:	01 d0                	add    %edx,%eax
  802a47:	c1 e0 02             	shl    $0x2,%eax
  802a4a:	8d 90 60 20 81 00    	lea    0x812060(%eax),%edx
  802a50:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a53:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802a55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a58:	89 d0                	mov    %edx,%eax
  802a5a:	01 c0                	add    %eax,%eax
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	c1 e0 02             	shl    $0x2,%eax
  802a61:	8d 90 64 20 81 00    	lea    0x812064(%eax),%edx
  802a67:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6a:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802a6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a6f:	89 d0                	mov    %edx,%eax
  802a71:	01 c0                	add    %eax,%eax
  802a73:	01 d0                	add    %edx,%eax
  802a75:	c1 e0 02             	shl    $0x2,%eax
  802a78:	05 68 20 81 00       	add    $0x812068,%eax
  802a7d:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a83:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802a86:	eb 0c                	jmp    802a94 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a88:	ff 45 e4             	incl   -0x1c(%ebp)
  802a8b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802a92:	7e 93                	jle    802a27 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802a94:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802a98:	0f 84 8d 01 00 00    	je     802c2b <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802a9e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802aa5:	e9 74 01 00 00       	jmp    802c1e <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802aaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aad:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ab0:	0f 84 64 01 00 00    	je     802c1a <realloc+0x3e1>
				if (uhp_frees[k].free)
  802ab6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ab9:	89 d0                	mov    %edx,%eax
  802abb:	01 c0                	add    %eax,%eax
  802abd:	01 d0                	add    %edx,%eax
  802abf:	c1 e0 02             	shl    $0x2,%eax
  802ac2:	05 68 20 81 00       	add    $0x812068,%eax
  802ac7:	8a 00                	mov    (%eax),%al
  802ac9:	84 c0                	test   %al,%al
  802acb:	0f 84 4a 01 00 00    	je     802c1b <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802ad1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ad4:	89 d0                	mov    %edx,%eax
  802ad6:	01 c0                	add    %eax,%eax
  802ad8:	01 d0                	add    %edx,%eax
  802ada:	c1 e0 02             	shl    $0x2,%eax
  802add:	05 60 20 81 00       	add    $0x812060,%eax
  802ae2:	8b 08                	mov    (%eax),%ecx
  802ae4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ae7:	89 d0                	mov    %edx,%eax
  802ae9:	01 c0                	add    %eax,%eax
  802aeb:	01 d0                	add    %edx,%eax
  802aed:	c1 e0 02             	shl    $0x2,%eax
  802af0:	05 64 20 81 00       	add    $0x812064,%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	01 c1                	add    %eax,%ecx
  802af9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802afc:	89 d0                	mov    %edx,%eax
  802afe:	01 c0                	add    %eax,%eax
  802b00:	01 d0                	add    %edx,%eax
  802b02:	c1 e0 02             	shl    $0x2,%eax
  802b05:	05 60 20 81 00       	add    $0x812060,%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	39 c1                	cmp    %eax,%ecx
  802b0e:	75 7a                	jne    802b8a <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802b10:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b13:	89 d0                	mov    %edx,%eax
  802b15:	01 c0                	add    %eax,%eax
  802b17:	01 d0                	add    %edx,%eax
  802b19:	c1 e0 02             	shl    $0x2,%eax
  802b1c:	05 60 20 81 00       	add    $0x812060,%eax
  802b21:	8b 10                	mov    (%eax),%edx
  802b23:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802b26:	89 c8                	mov    %ecx,%eax
  802b28:	01 c0                	add    %eax,%eax
  802b2a:	01 c8                	add    %ecx,%eax
  802b2c:	c1 e0 02             	shl    $0x2,%eax
  802b2f:	05 60 20 81 00       	add    $0x812060,%eax
  802b34:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802b36:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b39:	89 d0                	mov    %edx,%eax
  802b3b:	01 c0                	add    %eax,%eax
  802b3d:	01 d0                	add    %edx,%eax
  802b3f:	c1 e0 02             	shl    $0x2,%eax
  802b42:	05 64 20 81 00       	add    $0x812064,%eax
  802b47:	8b 08                	mov    (%eax),%ecx
  802b49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b4c:	89 d0                	mov    %edx,%eax
  802b4e:	01 c0                	add    %eax,%eax
  802b50:	01 d0                	add    %edx,%eax
  802b52:	c1 e0 02             	shl    $0x2,%eax
  802b55:	05 64 20 81 00       	add    $0x812064,%eax
  802b5a:	8b 00                	mov    (%eax),%eax
  802b5c:	01 c1                	add    %eax,%ecx
  802b5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b61:	89 d0                	mov    %edx,%eax
  802b63:	01 c0                	add    %eax,%eax
  802b65:	01 d0                	add    %edx,%eax
  802b67:	c1 e0 02             	shl    $0x2,%eax
  802b6a:	05 64 20 81 00       	add    $0x812064,%eax
  802b6f:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802b71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b74:	89 d0                	mov    %edx,%eax
  802b76:	01 c0                	add    %eax,%eax
  802b78:	01 d0                	add    %edx,%eax
  802b7a:	c1 e0 02             	shl    $0x2,%eax
  802b7d:	05 68 20 81 00       	add    $0x812068,%eax
  802b82:	c6 00 00             	movb   $0x0,(%eax)
  802b85:	e9 91 00 00 00       	jmp    802c1b <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802b8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b8d:	89 d0                	mov    %edx,%eax
  802b8f:	01 c0                	add    %eax,%eax
  802b91:	01 d0                	add    %edx,%eax
  802b93:	c1 e0 02             	shl    $0x2,%eax
  802b96:	05 60 20 81 00       	add    $0x812060,%eax
  802b9b:	8b 08                	mov    (%eax),%ecx
  802b9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba0:	89 d0                	mov    %edx,%eax
  802ba2:	01 c0                	add    %eax,%eax
  802ba4:	01 d0                	add    %edx,%eax
  802ba6:	c1 e0 02             	shl    $0x2,%eax
  802ba9:	05 64 20 81 00       	add    $0x812064,%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	01 c1                	add    %eax,%ecx
  802bb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bb5:	89 d0                	mov    %edx,%eax
  802bb7:	01 c0                	add    %eax,%eax
  802bb9:	01 d0                	add    %edx,%eax
  802bbb:	c1 e0 02             	shl    $0x2,%eax
  802bbe:	05 60 20 81 00       	add    $0x812060,%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	39 c1                	cmp    %eax,%ecx
  802bc7:	75 52                	jne    802c1b <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802bc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bcc:	89 d0                	mov    %edx,%eax
  802bce:	01 c0                	add    %eax,%eax
  802bd0:	01 d0                	add    %edx,%eax
  802bd2:	c1 e0 02             	shl    $0x2,%eax
  802bd5:	05 64 20 81 00       	add    $0x812064,%eax
  802bda:	8b 08                	mov    (%eax),%ecx
  802bdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bdf:	89 d0                	mov    %edx,%eax
  802be1:	01 c0                	add    %eax,%eax
  802be3:	01 d0                	add    %edx,%eax
  802be5:	c1 e0 02             	shl    $0x2,%eax
  802be8:	05 64 20 81 00       	add    $0x812064,%eax
  802bed:	8b 00                	mov    (%eax),%eax
  802bef:	01 c1                	add    %eax,%ecx
  802bf1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf4:	89 d0                	mov    %edx,%eax
  802bf6:	01 c0                	add    %eax,%eax
  802bf8:	01 d0                	add    %edx,%eax
  802bfa:	c1 e0 02             	shl    $0x2,%eax
  802bfd:	05 64 20 81 00       	add    $0x812064,%eax
  802c02:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802c04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c07:	89 d0                	mov    %edx,%eax
  802c09:	01 c0                	add    %eax,%eax
  802c0b:	01 d0                	add    %edx,%eax
  802c0d:	c1 e0 02             	shl    $0x2,%eax
  802c10:	05 68 20 81 00       	add    $0x812068,%eax
  802c15:	c6 00 00             	movb   $0x0,(%eax)
  802c18:	eb 01                	jmp    802c1b <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802c1a:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c1b:	ff 45 e0             	incl   -0x20(%ebp)
  802c1e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802c25:	0f 8e 7f fe ff ff    	jle    802aaa <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802c2b:	a1 50 a3 83 00       	mov    0x83a350,%eax
  802c30:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c33:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802c3a:	eb 53                	jmp    802c8f <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802c3c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c3f:	89 d0                	mov    %edx,%eax
  802c41:	01 c0                	add    %eax,%eax
  802c43:	01 d0                	add    %edx,%eax
  802c45:	c1 e0 02             	shl    $0x2,%eax
  802c48:	05 68 60 80 00       	add    $0x806068,%eax
  802c4d:	8a 00                	mov    (%eax),%al
  802c4f:	84 c0                	test   %al,%al
  802c51:	74 39                	je     802c8c <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802c53:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c56:	89 d0                	mov    %edx,%eax
  802c58:	01 c0                	add    %eax,%eax
  802c5a:	01 d0                	add    %edx,%eax
  802c5c:	c1 e0 02             	shl    $0x2,%eax
  802c5f:	05 60 60 80 00       	add    $0x806060,%eax
  802c64:	8b 08                	mov    (%eax),%ecx
  802c66:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c69:	89 d0                	mov    %edx,%eax
  802c6b:	01 c0                	add    %eax,%eax
  802c6d:	01 d0                	add    %edx,%eax
  802c6f:	c1 e0 02             	shl    $0x2,%eax
  802c72:	05 64 60 80 00       	add    $0x806064,%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	01 c8                	add    %ecx,%eax
  802c7b:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802c7e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c81:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c84:	76 06                	jbe    802c8c <realloc+0x453>
  802c86:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c89:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c8c:	ff 45 d8             	incl   -0x28(%ebp)
  802c8f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802c96:	7e a4                	jle    802c3c <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802c98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c9b:	a3 a8 a2 83 00       	mov    %eax,0x83a2a8
		return virtual_address;
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	e9 a9 01 00 00       	jmp    802e51 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802ca8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	01 d0                	add    %edx,%eax
  802cb0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802cb3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802cba:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802cc1:	eb 57                	jmp    802d1a <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802cc3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802cc6:	89 d0                	mov    %edx,%eax
  802cc8:	01 c0                	add    %eax,%eax
  802cca:	01 d0                	add    %edx,%eax
  802ccc:	c1 e0 02             	shl    $0x2,%eax
  802ccf:	05 68 20 81 00       	add    $0x812068,%eax
  802cd4:	8a 00                	mov    (%eax),%al
  802cd6:	84 c0                	test   %al,%al
  802cd8:	74 3d                	je     802d17 <realloc+0x4de>
  802cda:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802cdd:	89 d0                	mov    %edx,%eax
  802cdf:	01 c0                	add    %eax,%eax
  802ce1:	01 d0                	add    %edx,%eax
  802ce3:	c1 e0 02             	shl    $0x2,%eax
  802ce6:	05 60 20 81 00       	add    $0x812060,%eax
  802ceb:	8b 00                	mov    (%eax),%eax
  802ced:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cf0:	75 25                	jne    802d17 <realloc+0x4de>
  802cf2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802cf5:	89 d0                	mov    %edx,%eax
  802cf7:	01 c0                	add    %eax,%eax
  802cf9:	01 d0                	add    %edx,%eax
  802cfb:	c1 e0 02             	shl    $0x2,%eax
  802cfe:	05 64 20 81 00       	add    $0x812064,%eax
  802d03:	8b 10                	mov    (%eax),%edx
  802d05:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d08:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d0b:	39 c2                	cmp    %eax,%edx
  802d0d:	72 08                	jb     802d17 <realloc+0x4de>
		{
			adjIdx = j; break;
  802d0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d12:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d15:	eb 0c                	jmp    802d23 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802d17:	ff 45 d0             	incl   -0x30(%ebp)
  802d1a:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802d21:	7e a0                	jle    802cc3 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802d23:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802d27:	0f 84 d6 00 00 00    	je     802e03 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802d2d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d30:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d33:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802d36:	83 ec 08             	sub    $0x8,%esp
  802d39:	ff 75 a0             	pushl  -0x60(%ebp)
  802d3c:	ff 75 a4             	pushl  -0x5c(%ebp)
  802d3f:	e8 cf 09 00 00       	call   803713 <sys_allocate_user_mem>
  802d44:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802d47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4a:	89 d0                	mov    %edx,%eax
  802d4c:	01 c0                	add    %eax,%eax
  802d4e:	01 d0                	add    %edx,%eax
  802d50:	c1 e0 02             	shl    $0x2,%eax
  802d53:	8d 90 64 60 80 00    	lea    0x806064(%eax),%edx
  802d59:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d5c:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802d5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d61:	89 d0                	mov    %edx,%eax
  802d63:	01 c0                	add    %eax,%eax
  802d65:	01 d0                	add    %edx,%eax
  802d67:	c1 e0 02             	shl    $0x2,%eax
  802d6a:	05 60 20 81 00       	add    $0x812060,%eax
  802d6f:	8b 10                	mov    (%eax),%edx
  802d71:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802d74:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802d77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d7a:	89 d0                	mov    %edx,%eax
  802d7c:	01 c0                	add    %eax,%eax
  802d7e:	01 d0                	add    %edx,%eax
  802d80:	c1 e0 02             	shl    $0x2,%eax
  802d83:	05 60 20 81 00       	add    $0x812060,%eax
  802d88:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802d8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d8d:	89 d0                	mov    %edx,%eax
  802d8f:	01 c0                	add    %eax,%eax
  802d91:	01 d0                	add    %edx,%eax
  802d93:	c1 e0 02             	shl    $0x2,%eax
  802d96:	05 64 20 81 00       	add    $0x812064,%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802da0:	89 c2                	mov    %eax,%edx
  802da2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802da5:	89 c8                	mov    %ecx,%eax
  802da7:	01 c0                	add    %eax,%eax
  802da9:	01 c8                	add    %ecx,%eax
  802dab:	c1 e0 02             	shl    $0x2,%eax
  802dae:	05 64 20 81 00       	add    $0x812064,%eax
  802db3:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802db5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802db8:	89 d0                	mov    %edx,%eax
  802dba:	01 c0                	add    %eax,%eax
  802dbc:	01 d0                	add    %edx,%eax
  802dbe:	c1 e0 02             	shl    $0x2,%eax
  802dc1:	05 64 20 81 00       	add    $0x812064,%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	75 14                	jne    802de0 <realloc+0x5a7>
  802dcc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802dcf:	89 d0                	mov    %edx,%eax
  802dd1:	01 c0                	add    %eax,%eax
  802dd3:	01 d0                	add    %edx,%eax
  802dd5:	c1 e0 02             	shl    $0x2,%eax
  802dd8:	05 68 20 81 00       	add    $0x812068,%eax
  802ddd:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802de0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802de3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802de6:	01 c2                	add    %eax,%edx
  802de8:	a1 a8 a2 83 00       	mov    0x83a2a8,%eax
  802ded:	39 c2                	cmp    %eax,%edx
  802def:	76 0d                	jbe    802dfe <realloc+0x5c5>
  802df1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802df4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802df7:	01 d0                	add    %edx,%eax
  802df9:	a3 a8 a2 83 00       	mov    %eax,0x83a2a8
		return virtual_address;
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	eb 4e                	jmp    802e51 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802e03:	83 ec 0c             	sub    $0xc,%esp
  802e06:	ff 75 0c             	pushl  0xc(%ebp)
  802e09:	e8 0b ec ff ff       	call   801a19 <malloc>
  802e0e:	83 c4 10             	add    $0x10,%esp
  802e11:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802e14:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802e18:	75 07                	jne    802e21 <realloc+0x5e8>
		return NULL;
  802e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1f:	eb 30                	jmp    802e51 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e27:	39 d0                	cmp    %edx,%eax
  802e29:	76 02                	jbe    802e2d <realloc+0x5f4>
  802e2b:	89 d0                	mov    %edx,%eax
  802e2d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802e30:	83 ec 04             	sub    $0x4,%esp
  802e33:	50                   	push   %eax
  802e34:	52                   	push   %edx
  802e35:	ff 75 cc             	pushl  -0x34(%ebp)
  802e38:	e8 cf 06 00 00       	call   80350c <sys_move_user_mem>
  802e3d:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802e40:	83 ec 0c             	sub    $0xc,%esp
  802e43:	ff 75 08             	pushl  0x8(%ebp)
  802e46:	e8 2e ef ff ff       	call   801d79 <free>
  802e4b:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802e4e:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802e51:	c9                   	leave  
  802e52:	c3                   	ret    

00802e53 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802e53:	55                   	push   %ebp
  802e54:	89 e5                	mov    %esp,%ebp
  802e56:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802e5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e63:	0f 84 33 03 00 00    	je     80319c <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802e69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e6c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802e71:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802e74:	83 ec 08             	sub    $0x8,%esp
  802e77:	ff 75 08             	pushl  0x8(%ebp)
  802e7a:	ff 75 d8             	pushl  -0x28(%ebp)
  802e7d:	e8 7d 05 00 00       	call   8033ff <sys_delete_shared_object>
  802e82:	83 c4 10             	add    $0x10,%esp
  802e85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802e88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e8c:	0f 88 0d 03 00 00    	js     80319f <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e99:	e9 ef 02 00 00       	jmp    80318d <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea1:	89 d0                	mov    %edx,%eax
  802ea3:	01 c0                	add    %eax,%eax
  802ea5:	01 d0                	add    %edx,%eax
  802ea7:	c1 e0 02             	shl    $0x2,%eax
  802eaa:	05 68 60 80 00       	add    $0x806068,%eax
  802eaf:	8a 00                	mov    (%eax),%al
  802eb1:	84 c0                	test   %al,%al
  802eb3:	0f 84 d1 02 00 00    	je     80318a <sfree+0x337>
  802eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebc:	89 d0                	mov    %edx,%eax
  802ebe:	01 c0                	add    %eax,%eax
  802ec0:	01 d0                	add    %edx,%eax
  802ec2:	c1 e0 02             	shl    $0x2,%eax
  802ec5:	05 60 60 80 00       	add    $0x806060,%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802ecf:	0f 85 b5 02 00 00    	jne    80318a <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed8:	89 d0                	mov    %edx,%eax
  802eda:	01 c0                	add    %eax,%eax
  802edc:	01 d0                	add    %edx,%eax
  802ede:	c1 e0 02             	shl    $0x2,%eax
  802ee1:	05 64 60 80 00       	add    $0x806064,%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eee:	89 d0                	mov    %edx,%eax
  802ef0:	01 c0                	add    %eax,%eax
  802ef2:	01 d0                	add    %edx,%eax
  802ef4:	c1 e0 02             	shl    $0x2,%eax
  802ef7:	05 68 60 80 00       	add    $0x806068,%eax
  802efc:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802eff:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802f06:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802f0d:	eb 64                	jmp    802f73 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802f0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f12:	89 d0                	mov    %edx,%eax
  802f14:	01 c0                	add    %eax,%eax
  802f16:	01 d0                	add    %edx,%eax
  802f18:	c1 e0 02             	shl    $0x2,%eax
  802f1b:	05 68 20 81 00       	add    $0x812068,%eax
  802f20:	8a 00                	mov    (%eax),%al
  802f22:	84 c0                	test   %al,%al
  802f24:	75 4a                	jne    802f70 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802f26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f29:	89 d0                	mov    %edx,%eax
  802f2b:	01 c0                	add    %eax,%eax
  802f2d:	01 d0                	add    %edx,%eax
  802f2f:	c1 e0 02             	shl    $0x2,%eax
  802f32:	8d 90 60 20 81 00    	lea    0x812060(%eax),%edx
  802f38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3b:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802f3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f40:	89 d0                	mov    %edx,%eax
  802f42:	01 c0                	add    %eax,%eax
  802f44:	01 d0                	add    %edx,%eax
  802f46:	c1 e0 02             	shl    $0x2,%eax
  802f49:	8d 90 64 20 81 00    	lea    0x812064(%eax),%edx
  802f4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f52:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802f54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f57:	89 d0                	mov    %edx,%eax
  802f59:	01 c0                	add    %eax,%eax
  802f5b:	01 d0                	add    %edx,%eax
  802f5d:	c1 e0 02             	shl    $0x2,%eax
  802f60:	05 68 20 81 00       	add    $0x812068,%eax
  802f65:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802f6e:	eb 0c                	jmp    802f7c <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802f70:	ff 45 ec             	incl   -0x14(%ebp)
  802f73:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802f7a:	7e 93                	jle    802f0f <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802f7c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802f80:	0f 84 8d 01 00 00    	je     803113 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802f86:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f8d:	e9 74 01 00 00       	jmp    803106 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f95:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f98:	0f 84 64 01 00 00    	je     803102 <sfree+0x2af>
					if (uhp_frees[k].free)
  802f9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa1:	89 d0                	mov    %edx,%eax
  802fa3:	01 c0                	add    %eax,%eax
  802fa5:	01 d0                	add    %edx,%eax
  802fa7:	c1 e0 02             	shl    $0x2,%eax
  802faa:	05 68 20 81 00       	add    $0x812068,%eax
  802faf:	8a 00                	mov    (%eax),%al
  802fb1:	84 c0                	test   %al,%al
  802fb3:	0f 84 4a 01 00 00    	je     803103 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802fb9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fbc:	89 d0                	mov    %edx,%eax
  802fbe:	01 c0                	add    %eax,%eax
  802fc0:	01 d0                	add    %edx,%eax
  802fc2:	c1 e0 02             	shl    $0x2,%eax
  802fc5:	05 60 20 81 00       	add    $0x812060,%eax
  802fca:	8b 08                	mov    (%eax),%ecx
  802fcc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fcf:	89 d0                	mov    %edx,%eax
  802fd1:	01 c0                	add    %eax,%eax
  802fd3:	01 d0                	add    %edx,%eax
  802fd5:	c1 e0 02             	shl    $0x2,%eax
  802fd8:	05 64 20 81 00       	add    $0x812064,%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	01 c1                	add    %eax,%ecx
  802fe1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe4:	89 d0                	mov    %edx,%eax
  802fe6:	01 c0                	add    %eax,%eax
  802fe8:	01 d0                	add    %edx,%eax
  802fea:	c1 e0 02             	shl    $0x2,%eax
  802fed:	05 60 20 81 00       	add    $0x812060,%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	39 c1                	cmp    %eax,%ecx
  802ff6:	75 7a                	jne    803072 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802ff8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ffb:	89 d0                	mov    %edx,%eax
  802ffd:	01 c0                	add    %eax,%eax
  802fff:	01 d0                	add    %edx,%eax
  803001:	c1 e0 02             	shl    $0x2,%eax
  803004:	05 60 20 81 00       	add    $0x812060,%eax
  803009:	8b 10                	mov    (%eax),%edx
  80300b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80300e:	89 c8                	mov    %ecx,%eax
  803010:	01 c0                	add    %eax,%eax
  803012:	01 c8                	add    %ecx,%eax
  803014:	c1 e0 02             	shl    $0x2,%eax
  803017:	05 60 20 81 00       	add    $0x812060,%eax
  80301c:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  80301e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803021:	89 d0                	mov    %edx,%eax
  803023:	01 c0                	add    %eax,%eax
  803025:	01 d0                	add    %edx,%eax
  803027:	c1 e0 02             	shl    $0x2,%eax
  80302a:	05 64 20 81 00       	add    $0x812064,%eax
  80302f:	8b 08                	mov    (%eax),%ecx
  803031:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803034:	89 d0                	mov    %edx,%eax
  803036:	01 c0                	add    %eax,%eax
  803038:	01 d0                	add    %edx,%eax
  80303a:	c1 e0 02             	shl    $0x2,%eax
  80303d:	05 64 20 81 00       	add    $0x812064,%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	01 c1                	add    %eax,%ecx
  803046:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803049:	89 d0                	mov    %edx,%eax
  80304b:	01 c0                	add    %eax,%eax
  80304d:	01 d0                	add    %edx,%eax
  80304f:	c1 e0 02             	shl    $0x2,%eax
  803052:	05 64 20 81 00       	add    $0x812064,%eax
  803057:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803059:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305c:	89 d0                	mov    %edx,%eax
  80305e:	01 c0                	add    %eax,%eax
  803060:	01 d0                	add    %edx,%eax
  803062:	c1 e0 02             	shl    $0x2,%eax
  803065:	05 68 20 81 00       	add    $0x812068,%eax
  80306a:	c6 00 00             	movb   $0x0,(%eax)
  80306d:	e9 91 00 00 00       	jmp    803103 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803072:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803075:	89 d0                	mov    %edx,%eax
  803077:	01 c0                	add    %eax,%eax
  803079:	01 d0                	add    %edx,%eax
  80307b:	c1 e0 02             	shl    $0x2,%eax
  80307e:	05 60 20 81 00       	add    $0x812060,%eax
  803083:	8b 08                	mov    (%eax),%ecx
  803085:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803088:	89 d0                	mov    %edx,%eax
  80308a:	01 c0                	add    %eax,%eax
  80308c:	01 d0                	add    %edx,%eax
  80308e:	c1 e0 02             	shl    $0x2,%eax
  803091:	05 64 20 81 00       	add    $0x812064,%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	01 c1                	add    %eax,%ecx
  80309a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309d:	89 d0                	mov    %edx,%eax
  80309f:	01 c0                	add    %eax,%eax
  8030a1:	01 d0                	add    %edx,%eax
  8030a3:	c1 e0 02             	shl    $0x2,%eax
  8030a6:	05 60 20 81 00       	add    $0x812060,%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	39 c1                	cmp    %eax,%ecx
  8030af:	75 52                	jne    803103 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  8030b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030b4:	89 d0                	mov    %edx,%eax
  8030b6:	01 c0                	add    %eax,%eax
  8030b8:	01 d0                	add    %edx,%eax
  8030ba:	c1 e0 02             	shl    $0x2,%eax
  8030bd:	05 64 20 81 00       	add    $0x812064,%eax
  8030c2:	8b 08                	mov    (%eax),%ecx
  8030c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c7:	89 d0                	mov    %edx,%eax
  8030c9:	01 c0                	add    %eax,%eax
  8030cb:	01 d0                	add    %edx,%eax
  8030cd:	c1 e0 02             	shl    $0x2,%eax
  8030d0:	05 64 20 81 00       	add    $0x812064,%eax
  8030d5:	8b 00                	mov    (%eax),%eax
  8030d7:	01 c1                	add    %eax,%ecx
  8030d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030dc:	89 d0                	mov    %edx,%eax
  8030de:	01 c0                	add    %eax,%eax
  8030e0:	01 d0                	add    %edx,%eax
  8030e2:	c1 e0 02             	shl    $0x2,%eax
  8030e5:	05 64 20 81 00       	add    $0x812064,%eax
  8030ea:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8030ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ef:	89 d0                	mov    %edx,%eax
  8030f1:	01 c0                	add    %eax,%eax
  8030f3:	01 d0                	add    %edx,%eax
  8030f5:	c1 e0 02             	shl    $0x2,%eax
  8030f8:	05 68 20 81 00       	add    $0x812068,%eax
  8030fd:	c6 00 00             	movb   $0x0,(%eax)
  803100:	eb 01                	jmp    803103 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  803102:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803103:	ff 45 e8             	incl   -0x18(%ebp)
  803106:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80310d:	0f 8e 7f fe ff ff    	jle    802f92 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803113:	a1 50 a3 83 00       	mov    0x83a350,%eax
  803118:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80311b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803122:	eb 53                	jmp    803177 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803124:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803127:	89 d0                	mov    %edx,%eax
  803129:	01 c0                	add    %eax,%eax
  80312b:	01 d0                	add    %edx,%eax
  80312d:	c1 e0 02             	shl    $0x2,%eax
  803130:	05 68 60 80 00       	add    $0x806068,%eax
  803135:	8a 00                	mov    (%eax),%al
  803137:	84 c0                	test   %al,%al
  803139:	74 39                	je     803174 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80313b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80313e:	89 d0                	mov    %edx,%eax
  803140:	01 c0                	add    %eax,%eax
  803142:	01 d0                	add    %edx,%eax
  803144:	c1 e0 02             	shl    $0x2,%eax
  803147:	05 60 60 80 00       	add    $0x806060,%eax
  80314c:	8b 08                	mov    (%eax),%ecx
  80314e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803151:	89 d0                	mov    %edx,%eax
  803153:	01 c0                	add    %eax,%eax
  803155:	01 d0                	add    %edx,%eax
  803157:	c1 e0 02             	shl    $0x2,%eax
  80315a:	05 64 60 80 00       	add    $0x806064,%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	01 c8                	add    %ecx,%eax
  803163:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803166:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803169:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80316c:	76 06                	jbe    803174 <sfree+0x321>
  80316e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803171:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803174:	ff 45 e0             	incl   -0x20(%ebp)
  803177:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80317e:	7e a4                	jle    803124 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803183:	a3 a8 a2 83 00       	mov    %eax,0x83a2a8
			break;
  803188:	eb 16                	jmp    8031a0 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80318a:	ff 45 f4             	incl   -0xc(%ebp)
  80318d:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803194:	0f 8e 04 fd ff ff    	jle    802e9e <sfree+0x4b>
  80319a:	eb 04                	jmp    8031a0 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  80319c:	90                   	nop
  80319d:	eb 01                	jmp    8031a0 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  80319f:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  8031a0:	c9                   	leave  
  8031a1:	c3                   	ret    

008031a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8031a2:	55                   	push   %ebp
  8031a3:	89 e5                	mov    %esp,%ebp
  8031a5:	57                   	push   %edi
  8031a6:	56                   	push   %esi
  8031a7:	53                   	push   %ebx
  8031a8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031b7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8031ba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8031bd:	cd 30                	int    $0x30
  8031bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8031c5:	83 c4 10             	add    $0x10,%esp
  8031c8:	5b                   	pop    %ebx
  8031c9:	5e                   	pop    %esi
  8031ca:	5f                   	pop    %edi
  8031cb:	5d                   	pop    %ebp
  8031cc:	c3                   	ret    

008031cd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8031cd:	55                   	push   %ebp
  8031ce:	89 e5                	mov    %esp,%ebp
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8031d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8031d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	6a 00                	push   $0x0
  8031e5:	51                   	push   %ecx
  8031e6:	52                   	push   %edx
  8031e7:	ff 75 0c             	pushl  0xc(%ebp)
  8031ea:	50                   	push   %eax
  8031eb:	6a 00                	push   $0x0
  8031ed:	e8 b0 ff ff ff       	call   8031a2 <syscall>
  8031f2:	83 c4 18             	add    $0x18,%esp
}
  8031f5:	90                   	nop
  8031f6:	c9                   	leave  
  8031f7:	c3                   	ret    

008031f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8031f8:	55                   	push   %ebp
  8031f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8031fb:	6a 00                	push   $0x0
  8031fd:	6a 00                	push   $0x0
  8031ff:	6a 00                	push   $0x0
  803201:	6a 00                	push   $0x0
  803203:	6a 00                	push   $0x0
  803205:	6a 02                	push   $0x2
  803207:	e8 96 ff ff ff       	call   8031a2 <syscall>
  80320c:	83 c4 18             	add    $0x18,%esp
}
  80320f:	c9                   	leave  
  803210:	c3                   	ret    

00803211 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803211:	55                   	push   %ebp
  803212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	6a 00                	push   $0x0
  80321a:	6a 00                	push   $0x0
  80321c:	6a 00                	push   $0x0
  80321e:	6a 03                	push   $0x3
  803220:	e8 7d ff ff ff       	call   8031a2 <syscall>
  803225:	83 c4 18             	add    $0x18,%esp
}
  803228:	90                   	nop
  803229:	c9                   	leave  
  80322a:	c3                   	ret    

0080322b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80322b:	55                   	push   %ebp
  80322c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 04                	push   $0x4
  80323a:	e8 63 ff ff ff       	call   8031a2 <syscall>
  80323f:	83 c4 18             	add    $0x18,%esp
}
  803242:	90                   	nop
  803243:	c9                   	leave  
  803244:	c3                   	ret    

00803245 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803245:	55                   	push   %ebp
  803246:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803248:	8b 55 0c             	mov    0xc(%ebp),%edx
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	6a 00                	push   $0x0
  803250:	6a 00                	push   $0x0
  803252:	6a 00                	push   $0x0
  803254:	52                   	push   %edx
  803255:	50                   	push   %eax
  803256:	6a 08                	push   $0x8
  803258:	e8 45 ff ff ff       	call   8031a2 <syscall>
  80325d:	83 c4 18             	add    $0x18,%esp
}
  803260:	c9                   	leave  
  803261:	c3                   	ret    

00803262 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803262:	55                   	push   %ebp
  803263:	89 e5                	mov    %esp,%ebp
  803265:	56                   	push   %esi
  803266:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803267:	8b 75 18             	mov    0x18(%ebp),%esi
  80326a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80326d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803270:	8b 55 0c             	mov    0xc(%ebp),%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	56                   	push   %esi
  803277:	53                   	push   %ebx
  803278:	51                   	push   %ecx
  803279:	52                   	push   %edx
  80327a:	50                   	push   %eax
  80327b:	6a 09                	push   $0x9
  80327d:	e8 20 ff ff ff       	call   8031a2 <syscall>
  803282:	83 c4 18             	add    $0x18,%esp
}
  803285:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803288:	5b                   	pop    %ebx
  803289:	5e                   	pop    %esi
  80328a:	5d                   	pop    %ebp
  80328b:	c3                   	ret    

0080328c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80328f:	6a 00                	push   $0x0
  803291:	6a 00                	push   $0x0
  803293:	6a 00                	push   $0x0
  803295:	6a 00                	push   $0x0
  803297:	ff 75 08             	pushl  0x8(%ebp)
  80329a:	6a 0a                	push   $0xa
  80329c:	e8 01 ff ff ff       	call   8031a2 <syscall>
  8032a1:	83 c4 18             	add    $0x18,%esp
}
  8032a4:	c9                   	leave  
  8032a5:	c3                   	ret    

008032a6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8032a6:	55                   	push   %ebp
  8032a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	ff 75 0c             	pushl  0xc(%ebp)
  8032b2:	ff 75 08             	pushl  0x8(%ebp)
  8032b5:	6a 0b                	push   $0xb
  8032b7:	e8 e6 fe ff ff       	call   8031a2 <syscall>
  8032bc:	83 c4 18             	add    $0x18,%esp
}
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	6a 00                	push   $0x0
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 0c                	push   $0xc
  8032d0:	e8 cd fe ff ff       	call   8031a2 <syscall>
  8032d5:	83 c4 18             	add    $0x18,%esp
}
  8032d8:	c9                   	leave  
  8032d9:	c3                   	ret    

008032da <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8032dd:	6a 00                	push   $0x0
  8032df:	6a 00                	push   $0x0
  8032e1:	6a 00                	push   $0x0
  8032e3:	6a 00                	push   $0x0
  8032e5:	6a 00                	push   $0x0
  8032e7:	6a 0d                	push   $0xd
  8032e9:	e8 b4 fe ff ff       	call   8031a2 <syscall>
  8032ee:	83 c4 18             	add    $0x18,%esp
}
  8032f1:	c9                   	leave  
  8032f2:	c3                   	ret    

008032f3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8032f3:	55                   	push   %ebp
  8032f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8032f6:	6a 00                	push   $0x0
  8032f8:	6a 00                	push   $0x0
  8032fa:	6a 00                	push   $0x0
  8032fc:	6a 00                	push   $0x0
  8032fe:	6a 00                	push   $0x0
  803300:	6a 0e                	push   $0xe
  803302:	e8 9b fe ff ff       	call   8031a2 <syscall>
  803307:	83 c4 18             	add    $0x18,%esp
}
  80330a:	c9                   	leave  
  80330b:	c3                   	ret    

0080330c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80330c:	55                   	push   %ebp
  80330d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80330f:	6a 00                	push   $0x0
  803311:	6a 00                	push   $0x0
  803313:	6a 00                	push   $0x0
  803315:	6a 00                	push   $0x0
  803317:	6a 00                	push   $0x0
  803319:	6a 0f                	push   $0xf
  80331b:	e8 82 fe ff ff       	call   8031a2 <syscall>
  803320:	83 c4 18             	add    $0x18,%esp
}
  803323:	c9                   	leave  
  803324:	c3                   	ret    

00803325 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803325:	55                   	push   %ebp
  803326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803328:	6a 00                	push   $0x0
  80332a:	6a 00                	push   $0x0
  80332c:	6a 00                	push   $0x0
  80332e:	6a 00                	push   $0x0
  803330:	ff 75 08             	pushl  0x8(%ebp)
  803333:	6a 10                	push   $0x10
  803335:	e8 68 fe ff ff       	call   8031a2 <syscall>
  80333a:	83 c4 18             	add    $0x18,%esp
}
  80333d:	c9                   	leave  
  80333e:	c3                   	ret    

0080333f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80333f:	55                   	push   %ebp
  803340:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803342:	6a 00                	push   $0x0
  803344:	6a 00                	push   $0x0
  803346:	6a 00                	push   $0x0
  803348:	6a 00                	push   $0x0
  80334a:	6a 00                	push   $0x0
  80334c:	6a 11                	push   $0x11
  80334e:	e8 4f fe ff ff       	call   8031a2 <syscall>
  803353:	83 c4 18             	add    $0x18,%esp
}
  803356:	90                   	nop
  803357:	c9                   	leave  
  803358:	c3                   	ret    

00803359 <sys_cputc>:

void
sys_cputc(const char c)
{
  803359:	55                   	push   %ebp
  80335a:	89 e5                	mov    %esp,%ebp
  80335c:	83 ec 04             	sub    $0x4,%esp
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803365:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803369:	6a 00                	push   $0x0
  80336b:	6a 00                	push   $0x0
  80336d:	6a 00                	push   $0x0
  80336f:	6a 00                	push   $0x0
  803371:	50                   	push   %eax
  803372:	6a 01                	push   $0x1
  803374:	e8 29 fe ff ff       	call   8031a2 <syscall>
  803379:	83 c4 18             	add    $0x18,%esp
}
  80337c:	90                   	nop
  80337d:	c9                   	leave  
  80337e:	c3                   	ret    

0080337f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80337f:	55                   	push   %ebp
  803380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803382:	6a 00                	push   $0x0
  803384:	6a 00                	push   $0x0
  803386:	6a 00                	push   $0x0
  803388:	6a 00                	push   $0x0
  80338a:	6a 00                	push   $0x0
  80338c:	6a 14                	push   $0x14
  80338e:	e8 0f fe ff ff       	call   8031a2 <syscall>
  803393:	83 c4 18             	add    $0x18,%esp
}
  803396:	90                   	nop
  803397:	c9                   	leave  
  803398:	c3                   	ret    

00803399 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803399:	55                   	push   %ebp
  80339a:	89 e5                	mov    %esp,%ebp
  80339c:	83 ec 04             	sub    $0x4,%esp
  80339f:	8b 45 10             	mov    0x10(%ebp),%eax
  8033a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8033a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8033a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	6a 00                	push   $0x0
  8033b1:	51                   	push   %ecx
  8033b2:	52                   	push   %edx
  8033b3:	ff 75 0c             	pushl  0xc(%ebp)
  8033b6:	50                   	push   %eax
  8033b7:	6a 15                	push   $0x15
  8033b9:	e8 e4 fd ff ff       	call   8031a2 <syscall>
  8033be:	83 c4 18             	add    $0x18,%esp
}
  8033c1:	c9                   	leave  
  8033c2:	c3                   	ret    

008033c3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8033c3:	55                   	push   %ebp
  8033c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8033c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cc:	6a 00                	push   $0x0
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	52                   	push   %edx
  8033d3:	50                   	push   %eax
  8033d4:	6a 16                	push   $0x16
  8033d6:	e8 c7 fd ff ff       	call   8031a2 <syscall>
  8033db:	83 c4 18             	add    $0x18,%esp
}
  8033de:	c9                   	leave  
  8033df:	c3                   	ret    

008033e0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8033e0:	55                   	push   %ebp
  8033e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8033e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	6a 00                	push   $0x0
  8033ee:	6a 00                	push   $0x0
  8033f0:	51                   	push   %ecx
  8033f1:	52                   	push   %edx
  8033f2:	50                   	push   %eax
  8033f3:	6a 17                	push   $0x17
  8033f5:	e8 a8 fd ff ff       	call   8031a2 <syscall>
  8033fa:	83 c4 18             	add    $0x18,%esp
}
  8033fd:	c9                   	leave  
  8033fe:	c3                   	ret    

008033ff <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8033ff:	55                   	push   %ebp
  803400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803402:	8b 55 0c             	mov    0xc(%ebp),%edx
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	6a 00                	push   $0x0
  80340e:	52                   	push   %edx
  80340f:	50                   	push   %eax
  803410:	6a 18                	push   $0x18
  803412:	e8 8b fd ff ff       	call   8031a2 <syscall>
  803417:	83 c4 18             	add    $0x18,%esp
}
  80341a:	c9                   	leave  
  80341b:	c3                   	ret    

0080341c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80341c:	55                   	push   %ebp
  80341d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	6a 00                	push   $0x0
  803424:	ff 75 14             	pushl  0x14(%ebp)
  803427:	ff 75 10             	pushl  0x10(%ebp)
  80342a:	ff 75 0c             	pushl  0xc(%ebp)
  80342d:	50                   	push   %eax
  80342e:	6a 19                	push   $0x19
  803430:	e8 6d fd ff ff       	call   8031a2 <syscall>
  803435:	83 c4 18             	add    $0x18,%esp
}
  803438:	c9                   	leave  
  803439:	c3                   	ret    

0080343a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80343a:	55                   	push   %ebp
  80343b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	6a 00                	push   $0x0
  803442:	6a 00                	push   $0x0
  803444:	6a 00                	push   $0x0
  803446:	6a 00                	push   $0x0
  803448:	50                   	push   %eax
  803449:	6a 1a                	push   $0x1a
  80344b:	e8 52 fd ff ff       	call   8031a2 <syscall>
  803450:	83 c4 18             	add    $0x18,%esp
}
  803453:	90                   	nop
  803454:	c9                   	leave  
  803455:	c3                   	ret    

00803456 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803456:	55                   	push   %ebp
  803457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	6a 00                	push   $0x0
  80345e:	6a 00                	push   $0x0
  803460:	6a 00                	push   $0x0
  803462:	6a 00                	push   $0x0
  803464:	50                   	push   %eax
  803465:	6a 1b                	push   $0x1b
  803467:	e8 36 fd ff ff       	call   8031a2 <syscall>
  80346c:	83 c4 18             	add    $0x18,%esp
}
  80346f:	c9                   	leave  
  803470:	c3                   	ret    

00803471 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803471:	55                   	push   %ebp
  803472:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803474:	6a 00                	push   $0x0
  803476:	6a 00                	push   $0x0
  803478:	6a 00                	push   $0x0
  80347a:	6a 00                	push   $0x0
  80347c:	6a 00                	push   $0x0
  80347e:	6a 05                	push   $0x5
  803480:	e8 1d fd ff ff       	call   8031a2 <syscall>
  803485:	83 c4 18             	add    $0x18,%esp
}
  803488:	c9                   	leave  
  803489:	c3                   	ret    

0080348a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80348a:	55                   	push   %ebp
  80348b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80348d:	6a 00                	push   $0x0
  80348f:	6a 00                	push   $0x0
  803491:	6a 00                	push   $0x0
  803493:	6a 00                	push   $0x0
  803495:	6a 00                	push   $0x0
  803497:	6a 06                	push   $0x6
  803499:	e8 04 fd ff ff       	call   8031a2 <syscall>
  80349e:	83 c4 18             	add    $0x18,%esp
}
  8034a1:	c9                   	leave  
  8034a2:	c3                   	ret    

008034a3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8034a3:	55                   	push   %ebp
  8034a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8034a6:	6a 00                	push   $0x0
  8034a8:	6a 00                	push   $0x0
  8034aa:	6a 00                	push   $0x0
  8034ac:	6a 00                	push   $0x0
  8034ae:	6a 00                	push   $0x0
  8034b0:	6a 07                	push   $0x7
  8034b2:	e8 eb fc ff ff       	call   8031a2 <syscall>
  8034b7:	83 c4 18             	add    $0x18,%esp
}
  8034ba:	c9                   	leave  
  8034bb:	c3                   	ret    

008034bc <sys_exit_env>:


void sys_exit_env(void)
{
  8034bc:	55                   	push   %ebp
  8034bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8034bf:	6a 00                	push   $0x0
  8034c1:	6a 00                	push   $0x0
  8034c3:	6a 00                	push   $0x0
  8034c5:	6a 00                	push   $0x0
  8034c7:	6a 00                	push   $0x0
  8034c9:	6a 1c                	push   $0x1c
  8034cb:	e8 d2 fc ff ff       	call   8031a2 <syscall>
  8034d0:	83 c4 18             	add    $0x18,%esp
}
  8034d3:	90                   	nop
  8034d4:	c9                   	leave  
  8034d5:	c3                   	ret    

008034d6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8034d6:	55                   	push   %ebp
  8034d7:	89 e5                	mov    %esp,%ebp
  8034d9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8034dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8034df:	8d 50 04             	lea    0x4(%eax),%edx
  8034e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8034e5:	6a 00                	push   $0x0
  8034e7:	6a 00                	push   $0x0
  8034e9:	6a 00                	push   $0x0
  8034eb:	52                   	push   %edx
  8034ec:	50                   	push   %eax
  8034ed:	6a 1d                	push   $0x1d
  8034ef:	e8 ae fc ff ff       	call   8031a2 <syscall>
  8034f4:	83 c4 18             	add    $0x18,%esp
	return result;
  8034f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8034fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8034fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803500:	89 01                	mov    %eax,(%ecx)
  803502:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	c9                   	leave  
  803509:	c2 04 00             	ret    $0x4

0080350c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80350c:	55                   	push   %ebp
  80350d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80350f:	6a 00                	push   $0x0
  803511:	6a 00                	push   $0x0
  803513:	ff 75 10             	pushl  0x10(%ebp)
  803516:	ff 75 0c             	pushl  0xc(%ebp)
  803519:	ff 75 08             	pushl  0x8(%ebp)
  80351c:	6a 13                	push   $0x13
  80351e:	e8 7f fc ff ff       	call   8031a2 <syscall>
  803523:	83 c4 18             	add    $0x18,%esp
	return ;
  803526:	90                   	nop
}
  803527:	c9                   	leave  
  803528:	c3                   	ret    

00803529 <sys_rcr2>:
uint32 sys_rcr2()
{
  803529:	55                   	push   %ebp
  80352a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80352c:	6a 00                	push   $0x0
  80352e:	6a 00                	push   $0x0
  803530:	6a 00                	push   $0x0
  803532:	6a 00                	push   $0x0
  803534:	6a 00                	push   $0x0
  803536:	6a 1e                	push   $0x1e
  803538:	e8 65 fc ff ff       	call   8031a2 <syscall>
  80353d:	83 c4 18             	add    $0x18,%esp
}
  803540:	c9                   	leave  
  803541:	c3                   	ret    

00803542 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803542:	55                   	push   %ebp
  803543:	89 e5                	mov    %esp,%ebp
  803545:	83 ec 04             	sub    $0x4,%esp
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80354e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803552:	6a 00                	push   $0x0
  803554:	6a 00                	push   $0x0
  803556:	6a 00                	push   $0x0
  803558:	6a 00                	push   $0x0
  80355a:	50                   	push   %eax
  80355b:	6a 1f                	push   $0x1f
  80355d:	e8 40 fc ff ff       	call   8031a2 <syscall>
  803562:	83 c4 18             	add    $0x18,%esp
	return ;
  803565:	90                   	nop
}
  803566:	c9                   	leave  
  803567:	c3                   	ret    

00803568 <rsttst>:
void rsttst()
{
  803568:	55                   	push   %ebp
  803569:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80356b:	6a 00                	push   $0x0
  80356d:	6a 00                	push   $0x0
  80356f:	6a 00                	push   $0x0
  803571:	6a 00                	push   $0x0
  803573:	6a 00                	push   $0x0
  803575:	6a 21                	push   $0x21
  803577:	e8 26 fc ff ff       	call   8031a2 <syscall>
  80357c:	83 c4 18             	add    $0x18,%esp
	return ;
  80357f:	90                   	nop
}
  803580:	c9                   	leave  
  803581:	c3                   	ret    

00803582 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803582:	55                   	push   %ebp
  803583:	89 e5                	mov    %esp,%ebp
  803585:	83 ec 04             	sub    $0x4,%esp
  803588:	8b 45 14             	mov    0x14(%ebp),%eax
  80358b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80358e:	8b 55 18             	mov    0x18(%ebp),%edx
  803591:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803595:	52                   	push   %edx
  803596:	50                   	push   %eax
  803597:	ff 75 10             	pushl  0x10(%ebp)
  80359a:	ff 75 0c             	pushl  0xc(%ebp)
  80359d:	ff 75 08             	pushl  0x8(%ebp)
  8035a0:	6a 20                	push   $0x20
  8035a2:	e8 fb fb ff ff       	call   8031a2 <syscall>
  8035a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8035aa:	90                   	nop
}
  8035ab:	c9                   	leave  
  8035ac:	c3                   	ret    

008035ad <chktst>:
void chktst(uint32 n)
{
  8035ad:	55                   	push   %ebp
  8035ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8035b0:	6a 00                	push   $0x0
  8035b2:	6a 00                	push   $0x0
  8035b4:	6a 00                	push   $0x0
  8035b6:	6a 00                	push   $0x0
  8035b8:	ff 75 08             	pushl  0x8(%ebp)
  8035bb:	6a 22                	push   $0x22
  8035bd:	e8 e0 fb ff ff       	call   8031a2 <syscall>
  8035c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8035c5:	90                   	nop
}
  8035c6:	c9                   	leave  
  8035c7:	c3                   	ret    

008035c8 <inctst>:

void inctst()
{
  8035c8:	55                   	push   %ebp
  8035c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8035cb:	6a 00                	push   $0x0
  8035cd:	6a 00                	push   $0x0
  8035cf:	6a 00                	push   $0x0
  8035d1:	6a 00                	push   $0x0
  8035d3:	6a 00                	push   $0x0
  8035d5:	6a 23                	push   $0x23
  8035d7:	e8 c6 fb ff ff       	call   8031a2 <syscall>
  8035dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8035df:	90                   	nop
}
  8035e0:	c9                   	leave  
  8035e1:	c3                   	ret    

008035e2 <gettst>:
uint32 gettst()
{
  8035e2:	55                   	push   %ebp
  8035e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8035e5:	6a 00                	push   $0x0
  8035e7:	6a 00                	push   $0x0
  8035e9:	6a 00                	push   $0x0
  8035eb:	6a 00                	push   $0x0
  8035ed:	6a 00                	push   $0x0
  8035ef:	6a 24                	push   $0x24
  8035f1:	e8 ac fb ff ff       	call   8031a2 <syscall>
  8035f6:	83 c4 18             	add    $0x18,%esp
}
  8035f9:	c9                   	leave  
  8035fa:	c3                   	ret    

008035fb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8035fb:	55                   	push   %ebp
  8035fc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8035fe:	6a 00                	push   $0x0
  803600:	6a 00                	push   $0x0
  803602:	6a 00                	push   $0x0
  803604:	6a 00                	push   $0x0
  803606:	6a 00                	push   $0x0
  803608:	6a 25                	push   $0x25
  80360a:	e8 93 fb ff ff       	call   8031a2 <syscall>
  80360f:	83 c4 18             	add    $0x18,%esp
  803612:	a3 a0 a2 83 00       	mov    %eax,0x83a2a0
	return uheapPlaceStrategy ;
  803617:	a1 a0 a2 83 00       	mov    0x83a2a0,%eax
}
  80361c:	c9                   	leave  
  80361d:	c3                   	ret    

0080361e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80361e:	55                   	push   %ebp
  80361f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803621:	8b 45 08             	mov    0x8(%ebp),%eax
  803624:	a3 a0 a2 83 00       	mov    %eax,0x83a2a0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803629:	6a 00                	push   $0x0
  80362b:	6a 00                	push   $0x0
  80362d:	6a 00                	push   $0x0
  80362f:	6a 00                	push   $0x0
  803631:	ff 75 08             	pushl  0x8(%ebp)
  803634:	6a 26                	push   $0x26
  803636:	e8 67 fb ff ff       	call   8031a2 <syscall>
  80363b:	83 c4 18             	add    $0x18,%esp
	return ;
  80363e:	90                   	nop
}
  80363f:	c9                   	leave  
  803640:	c3                   	ret    

00803641 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803641:	55                   	push   %ebp
  803642:	89 e5                	mov    %esp,%ebp
  803644:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803645:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803648:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80364b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	6a 00                	push   $0x0
  803653:	53                   	push   %ebx
  803654:	51                   	push   %ecx
  803655:	52                   	push   %edx
  803656:	50                   	push   %eax
  803657:	6a 27                	push   $0x27
  803659:	e8 44 fb ff ff       	call   8031a2 <syscall>
  80365e:	83 c4 18             	add    $0x18,%esp
}
  803661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803664:	c9                   	leave  
  803665:	c3                   	ret    

00803666 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803666:	55                   	push   %ebp
  803667:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80366c:	8b 45 08             	mov    0x8(%ebp),%eax
  80366f:	6a 00                	push   $0x0
  803671:	6a 00                	push   $0x0
  803673:	6a 00                	push   $0x0
  803675:	52                   	push   %edx
  803676:	50                   	push   %eax
  803677:	6a 28                	push   $0x28
  803679:	e8 24 fb ff ff       	call   8031a2 <syscall>
  80367e:	83 c4 18             	add    $0x18,%esp
}
  803681:	c9                   	leave  
  803682:	c3                   	ret    

00803683 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803683:	55                   	push   %ebp
  803684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803686:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	6a 00                	push   $0x0
  803691:	51                   	push   %ecx
  803692:	ff 75 10             	pushl  0x10(%ebp)
  803695:	52                   	push   %edx
  803696:	50                   	push   %eax
  803697:	6a 29                	push   $0x29
  803699:	e8 04 fb ff ff       	call   8031a2 <syscall>
  80369e:	83 c4 18             	add    $0x18,%esp
}
  8036a1:	c9                   	leave  
  8036a2:	c3                   	ret    

008036a3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8036a3:	55                   	push   %ebp
  8036a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8036a6:	6a 00                	push   $0x0
  8036a8:	6a 00                	push   $0x0
  8036aa:	ff 75 10             	pushl  0x10(%ebp)
  8036ad:	ff 75 0c             	pushl  0xc(%ebp)
  8036b0:	ff 75 08             	pushl  0x8(%ebp)
  8036b3:	6a 12                	push   $0x12
  8036b5:	e8 e8 fa ff ff       	call   8031a2 <syscall>
  8036ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8036bd:	90                   	nop
}
  8036be:	c9                   	leave  
  8036bf:	c3                   	ret    

008036c0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8036c0:	55                   	push   %ebp
  8036c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8036c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c9:	6a 00                	push   $0x0
  8036cb:	6a 00                	push   $0x0
  8036cd:	6a 00                	push   $0x0
  8036cf:	52                   	push   %edx
  8036d0:	50                   	push   %eax
  8036d1:	6a 2a                	push   $0x2a
  8036d3:	e8 ca fa ff ff       	call   8031a2 <syscall>
  8036d8:	83 c4 18             	add    $0x18,%esp
	return;
  8036db:	90                   	nop
}
  8036dc:	c9                   	leave  
  8036dd:	c3                   	ret    

008036de <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8036de:	55                   	push   %ebp
  8036df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8036e1:	6a 00                	push   $0x0
  8036e3:	6a 00                	push   $0x0
  8036e5:	6a 00                	push   $0x0
  8036e7:	6a 00                	push   $0x0
  8036e9:	6a 00                	push   $0x0
  8036eb:	6a 2b                	push   $0x2b
  8036ed:	e8 b0 fa ff ff       	call   8031a2 <syscall>
  8036f2:	83 c4 18             	add    $0x18,%esp
}
  8036f5:	c9                   	leave  
  8036f6:	c3                   	ret    

008036f7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8036f7:	55                   	push   %ebp
  8036f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8036fa:	6a 00                	push   $0x0
  8036fc:	6a 00                	push   $0x0
  8036fe:	6a 00                	push   $0x0
  803700:	ff 75 0c             	pushl  0xc(%ebp)
  803703:	ff 75 08             	pushl  0x8(%ebp)
  803706:	6a 2d                	push   $0x2d
  803708:	e8 95 fa ff ff       	call   8031a2 <syscall>
  80370d:	83 c4 18             	add    $0x18,%esp
	return;
  803710:	90                   	nop
}
  803711:	c9                   	leave  
  803712:	c3                   	ret    

00803713 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803713:	55                   	push   %ebp
  803714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803716:	6a 00                	push   $0x0
  803718:	6a 00                	push   $0x0
  80371a:	6a 00                	push   $0x0
  80371c:	ff 75 0c             	pushl  0xc(%ebp)
  80371f:	ff 75 08             	pushl  0x8(%ebp)
  803722:	6a 2c                	push   $0x2c
  803724:	e8 79 fa ff ff       	call   8031a2 <syscall>
  803729:	83 c4 18             	add    $0x18,%esp
	return ;
  80372c:	90                   	nop
}
  80372d:	c9                   	leave  
  80372e:	c3                   	ret    

0080372f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80372f:	55                   	push   %ebp
  803730:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803732:	8b 55 0c             	mov    0xc(%ebp),%edx
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	6a 00                	push   $0x0
  80373a:	6a 00                	push   $0x0
  80373c:	6a 00                	push   $0x0
  80373e:	52                   	push   %edx
  80373f:	50                   	push   %eax
  803740:	6a 2e                	push   $0x2e
  803742:	e8 5b fa ff ff       	call   8031a2 <syscall>
  803747:	83 c4 18             	add    $0x18,%esp
}
  80374a:	90                   	nop
  80374b:	c9                   	leave  
  80374c:	c3                   	ret    

0080374d <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80374d:	55                   	push   %ebp
  80374e:	89 e5                	mov    %esp,%ebp
  803750:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803753:	81 7d 08 a0 22 82 00 	cmpl   $0x8222a0,0x8(%ebp)
  80375a:	72 09                	jb     803765 <to_page_va+0x18>
  80375c:	81 7d 08 a0 a2 83 00 	cmpl   $0x83a2a0,0x8(%ebp)
  803763:	72 14                	jb     803779 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803765:	83 ec 04             	sub    $0x4,%esp
  803768:	68 d8 4e 80 00       	push   $0x804ed8
  80376d:	6a 15                	push   $0x15
  80376f:	68 03 4f 80 00       	push   $0x804f03
  803774:	e8 10 d0 ff ff       	call   800789 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	ba a0 22 82 00       	mov    $0x8222a0,%edx
  803781:	29 d0                	sub    %edx,%eax
  803783:	c1 f8 02             	sar    $0x2,%eax
  803786:	89 c2                	mov    %eax,%edx
  803788:	89 d0                	mov    %edx,%eax
  80378a:	c1 e0 02             	shl    $0x2,%eax
  80378d:	01 d0                	add    %edx,%eax
  80378f:	c1 e0 02             	shl    $0x2,%eax
  803792:	01 d0                	add    %edx,%eax
  803794:	c1 e0 02             	shl    $0x2,%eax
  803797:	01 d0                	add    %edx,%eax
  803799:	89 c1                	mov    %eax,%ecx
  80379b:	c1 e1 08             	shl    $0x8,%ecx
  80379e:	01 c8                	add    %ecx,%eax
  8037a0:	89 c1                	mov    %eax,%ecx
  8037a2:	c1 e1 10             	shl    $0x10,%ecx
  8037a5:	01 c8                	add    %ecx,%eax
  8037a7:	01 c0                	add    %eax,%eax
  8037a9:	01 d0                	add    %edx,%eax
  8037ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8037ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b1:	c1 e0 0c             	shl    $0xc,%eax
  8037b4:	89 c2                	mov    %eax,%edx
  8037b6:	a1 a4 a2 83 00       	mov    0x83a2a4,%eax
  8037bb:	01 d0                	add    %edx,%eax
}
  8037bd:	c9                   	leave  
  8037be:	c3                   	ret    

008037bf <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8037bf:	55                   	push   %ebp
  8037c0:	89 e5                	mov    %esp,%ebp
  8037c2:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8037c5:	a1 a4 a2 83 00       	mov    0x83a2a4,%eax
  8037ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8037cd:	29 c2                	sub    %eax,%edx
  8037cf:	89 d0                	mov    %edx,%eax
  8037d1:	c1 e8 0c             	shr    $0xc,%eax
  8037d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8037d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037db:	78 09                	js     8037e6 <to_page_info+0x27>
  8037dd:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8037e4:	7e 14                	jle    8037fa <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8037e6:	83 ec 04             	sub    $0x4,%esp
  8037e9:	68 1c 4f 80 00       	push   $0x804f1c
  8037ee:	6a 21                	push   $0x21
  8037f0:	68 03 4f 80 00       	push   $0x804f03
  8037f5:	e8 8f cf ff ff       	call   800789 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8037fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037fd:	89 d0                	mov    %edx,%eax
  8037ff:	01 c0                	add    %eax,%eax
  803801:	01 d0                	add    %edx,%eax
  803803:	c1 e0 02             	shl    $0x2,%eax
  803806:	05 a0 22 82 00       	add    $0x8222a0,%eax
}
  80380b:	c9                   	leave  
  80380c:	c3                   	ret    

0080380d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80380d:	55                   	push   %ebp
  80380e:	89 e5                	mov    %esp,%ebp
  803810:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803813:	8b 45 08             	mov    0x8(%ebp),%eax
  803816:	05 00 00 00 02       	add    $0x2000000,%eax
  80381b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80381e:	73 16                	jae    803836 <initialize_dynamic_allocator+0x29>
  803820:	68 40 4f 80 00       	push   $0x804f40
  803825:	68 66 4f 80 00       	push   $0x804f66
  80382a:	6a 2f                	push   $0x2f
  80382c:	68 03 4f 80 00       	push   $0x804f03
  803831:	e8 53 cf ff ff       	call   800789 <_panic>
	dynAllocStart = daStart;
  803836:	8b 45 08             	mov    0x8(%ebp),%eax
  803839:	a3 a4 a2 83 00       	mov    %eax,0x83a2a4
	dynAllocEnd = daEnd;
  80383e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803841:	a3 80 e0 81 00       	mov    %eax,0x81e080

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803846:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80384d:	eb 36                	jmp    803885 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80384f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803852:	c1 e0 04             	shl    $0x4,%eax
  803855:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  80385a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803863:	c1 e0 04             	shl    $0x4,%eax
  803866:	05 c4 a2 83 00       	add    $0x83a2c4,%eax
  80386b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803874:	c1 e0 04             	shl    $0x4,%eax
  803877:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  80387c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803882:	ff 45 f4             	incl   -0xc(%ebp)
  803885:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803889:	7e c4                	jle    80384f <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  80388b:	c7 05 88 e0 81 00 00 	movl   $0x0,0x81e088
  803892:	00 00 00 
  803895:	c7 05 8c e0 81 00 00 	movl   $0x0,0x81e08c
  80389c:	00 00 00 
  80389f:	c7 05 94 e0 81 00 00 	movl   $0x0,0x81e094
  8038a6:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8038a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8038b0:	e9 1b 01 00 00       	jmp    8039d0 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8038b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038b8:	89 d0                	mov    %edx,%eax
  8038ba:	01 c0                	add    %eax,%eax
  8038bc:	01 d0                	add    %edx,%eax
  8038be:	c1 e0 02             	shl    $0x2,%eax
  8038c1:	05 a8 22 82 00       	add    $0x8222a8,%eax
  8038c6:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8038cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038ce:	89 d0                	mov    %edx,%eax
  8038d0:	01 c0                	add    %eax,%eax
  8038d2:	01 d0                	add    %edx,%eax
  8038d4:	c1 e0 02             	shl    $0x2,%eax
  8038d7:	05 aa 22 82 00       	add    $0x8222aa,%eax
  8038dc:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8038e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e4:	89 d0                	mov    %edx,%eax
  8038e6:	01 c0                	add    %eax,%eax
  8038e8:	01 d0                	add    %edx,%eax
  8038ea:	c1 e0 02             	shl    $0x2,%eax
  8038ed:	05 a0 22 82 00       	add    $0x8222a0,%eax
  8038f2:	8b 00                	mov    (%eax),%eax
  8038f4:	85 c0                	test   %eax,%eax
  8038f6:	74 2b                	je     803923 <initialize_dynamic_allocator+0x116>
  8038f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038fb:	89 d0                	mov    %edx,%eax
  8038fd:	01 c0                	add    %eax,%eax
  8038ff:	01 d0                	add    %edx,%eax
  803901:	c1 e0 02             	shl    $0x2,%eax
  803904:	05 a0 22 82 00       	add    $0x8222a0,%eax
  803909:	8b 10                	mov    (%eax),%edx
  80390b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80390e:	89 c8                	mov    %ecx,%eax
  803910:	01 c0                	add    %eax,%eax
  803912:	01 c8                	add    %ecx,%eax
  803914:	c1 e0 02             	shl    $0x2,%eax
  803917:	05 a4 22 82 00       	add    $0x8222a4,%eax
  80391c:	8b 00                	mov    (%eax),%eax
  80391e:	89 42 04             	mov    %eax,0x4(%edx)
  803921:	eb 18                	jmp    80393b <initialize_dynamic_allocator+0x12e>
  803923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803926:	89 d0                	mov    %edx,%eax
  803928:	01 c0                	add    %eax,%eax
  80392a:	01 d0                	add    %edx,%eax
  80392c:	c1 e0 02             	shl    $0x2,%eax
  80392f:	05 a4 22 82 00       	add    $0x8222a4,%eax
  803934:	8b 00                	mov    (%eax),%eax
  803936:	a3 8c e0 81 00       	mov    %eax,0x81e08c
  80393b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80393e:	89 d0                	mov    %edx,%eax
  803940:	01 c0                	add    %eax,%eax
  803942:	01 d0                	add    %edx,%eax
  803944:	c1 e0 02             	shl    $0x2,%eax
  803947:	05 a4 22 82 00       	add    $0x8222a4,%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 2a                	je     80397c <initialize_dynamic_allocator+0x16f>
  803952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803955:	89 d0                	mov    %edx,%eax
  803957:	01 c0                	add    %eax,%eax
  803959:	01 d0                	add    %edx,%eax
  80395b:	c1 e0 02             	shl    $0x2,%eax
  80395e:	05 a4 22 82 00       	add    $0x8222a4,%eax
  803963:	8b 10                	mov    (%eax),%edx
  803965:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803968:	89 c8                	mov    %ecx,%eax
  80396a:	01 c0                	add    %eax,%eax
  80396c:	01 c8                	add    %ecx,%eax
  80396e:	c1 e0 02             	shl    $0x2,%eax
  803971:	05 a0 22 82 00       	add    $0x8222a0,%eax
  803976:	8b 00                	mov    (%eax),%eax
  803978:	89 02                	mov    %eax,(%edx)
  80397a:	eb 18                	jmp    803994 <initialize_dynamic_allocator+0x187>
  80397c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80397f:	89 d0                	mov    %edx,%eax
  803981:	01 c0                	add    %eax,%eax
  803983:	01 d0                	add    %edx,%eax
  803985:	c1 e0 02             	shl    $0x2,%eax
  803988:	05 a0 22 82 00       	add    $0x8222a0,%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	a3 88 e0 81 00       	mov    %eax,0x81e088
  803994:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803997:	89 d0                	mov    %edx,%eax
  803999:	01 c0                	add    %eax,%eax
  80399b:	01 d0                	add    %edx,%eax
  80399d:	c1 e0 02             	shl    $0x2,%eax
  8039a0:	05 a0 22 82 00       	add    $0x8222a0,%eax
  8039a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ae:	89 d0                	mov    %edx,%eax
  8039b0:	01 c0                	add    %eax,%eax
  8039b2:	01 d0                	add    %edx,%eax
  8039b4:	c1 e0 02             	shl    $0x2,%eax
  8039b7:	05 a4 22 82 00       	add    $0x8222a4,%eax
  8039bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c2:	a1 94 e0 81 00       	mov    0x81e094,%eax
  8039c7:	48                   	dec    %eax
  8039c8:	a3 94 e0 81 00       	mov    %eax,0x81e094

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8039cd:	ff 45 f0             	incl   -0x10(%ebp)
  8039d0:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8039d7:	0f 8e d8 fe ff ff    	jle    8038b5 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8039dd:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8039e4:	e9 9d 00 00 00       	jmp    803a86 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8039e9:	8b 15 88 e0 81 00    	mov    0x81e088,%edx
  8039ef:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8039f2:	89 c8                	mov    %ecx,%eax
  8039f4:	01 c0                	add    %eax,%eax
  8039f6:	01 c8                	add    %ecx,%eax
  8039f8:	c1 e0 02             	shl    $0x2,%eax
  8039fb:	05 a0 22 82 00       	add    $0x8222a0,%eax
  803a00:	89 10                	mov    %edx,(%eax)
  803a02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a05:	89 d0                	mov    %edx,%eax
  803a07:	01 c0                	add    %eax,%eax
  803a09:	01 d0                	add    %edx,%eax
  803a0b:	c1 e0 02             	shl    $0x2,%eax
  803a0e:	05 a0 22 82 00       	add    $0x8222a0,%eax
  803a13:	8b 00                	mov    (%eax),%eax
  803a15:	85 c0                	test   %eax,%eax
  803a17:	74 1c                	je     803a35 <initialize_dynamic_allocator+0x228>
  803a19:	8b 15 88 e0 81 00    	mov    0x81e088,%edx
  803a1f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803a22:	89 c8                	mov    %ecx,%eax
  803a24:	01 c0                	add    %eax,%eax
  803a26:	01 c8                	add    %ecx,%eax
  803a28:	c1 e0 02             	shl    $0x2,%eax
  803a2b:	05 a0 22 82 00       	add    $0x8222a0,%eax
  803a30:	89 42 04             	mov    %eax,0x4(%edx)
  803a33:	eb 16                	jmp    803a4b <initialize_dynamic_allocator+0x23e>
  803a35:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a38:	89 d0                	mov    %edx,%eax
  803a3a:	01 c0                	add    %eax,%eax
  803a3c:	01 d0                	add    %edx,%eax
  803a3e:	c1 e0 02             	shl    $0x2,%eax
  803a41:	05 a0 22 82 00       	add    $0x8222a0,%eax
  803a46:	a3 8c e0 81 00       	mov    %eax,0x81e08c
  803a4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a4e:	89 d0                	mov    %edx,%eax
  803a50:	01 c0                	add    %eax,%eax
  803a52:	01 d0                	add    %edx,%eax
  803a54:	c1 e0 02             	shl    $0x2,%eax
  803a57:	05 a0 22 82 00       	add    $0x8222a0,%eax
  803a5c:	a3 88 e0 81 00       	mov    %eax,0x81e088
  803a61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a64:	89 d0                	mov    %edx,%eax
  803a66:	01 c0                	add    %eax,%eax
  803a68:	01 d0                	add    %edx,%eax
  803a6a:	c1 e0 02             	shl    $0x2,%eax
  803a6d:	05 a4 22 82 00       	add    $0x8222a4,%eax
  803a72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a78:	a1 94 e0 81 00       	mov    0x81e094,%eax
  803a7d:	40                   	inc    %eax
  803a7e:	a3 94 e0 81 00       	mov    %eax,0x81e094
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803a83:	ff 4d ec             	decl   -0x14(%ebp)
  803a86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a8a:	0f 89 59 ff ff ff    	jns    8039e9 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803a90:	c7 05 64 e0 81 00 01 	movl   $0x1,0x81e064
  803a97:	00 00 00 
}
  803a9a:	90                   	nop
  803a9b:	c9                   	leave  
  803a9c:	c3                   	ret    

00803a9d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803a9d:	55                   	push   %ebp
  803a9e:	89 e5                	mov    %esp,%ebp
  803aa0:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa6:	83 ec 0c             	sub    $0xc,%esp
  803aa9:	50                   	push   %eax
  803aaa:	e8 10 fd ff ff       	call   8037bf <to_page_info>
  803aaf:	83 c4 10             	add    $0x10,%esp
  803ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab8:	8b 40 08             	mov    0x8(%eax),%eax
  803abb:	0f b7 c0             	movzwl %ax,%eax
}
  803abe:	c9                   	leave  
  803abf:	c3                   	ret    

00803ac0 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803ac0:	55                   	push   %ebp
  803ac1:	89 e5                	mov    %esp,%ebp
  803ac3:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803ac6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803acd:	76 16                	jbe    803ae5 <alloc_block+0x25>
  803acf:	68 7c 4f 80 00       	push   $0x804f7c
  803ad4:	68 66 4f 80 00       	push   $0x804f66
  803ad9:	6a 59                	push   $0x59
  803adb:	68 03 4f 80 00       	push   $0x804f03
  803ae0:	e8 a4 cc ff ff       	call   800789 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803ae5:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803aec:	eb 08                	jmp    803af6 <alloc_block+0x36>
		allocSize <<= 1;
  803aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af1:	01 c0                	add    %eax,%eax
  803af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af9:	3b 45 08             	cmp    0x8(%ebp),%eax
  803afc:	73 09                	jae    803b07 <alloc_block+0x47>
  803afe:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803b05:	76 e7                	jbe    803aee <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803b07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803b0e:	eb 03                	jmp    803b13 <alloc_block+0x53>
		listIndex++;
  803b10:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b16:	ba 08 00 00 00       	mov    $0x8,%edx
  803b1b:	88 c1                	mov    %al,%cl
  803b1d:	d3 e2                	shl    %cl,%edx
  803b1f:	89 d0                	mov    %edx,%eax
  803b21:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803b24:	72 ea                	jb     803b10 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b2c:	e9 f4 00 00 00       	jmp    803c25 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b34:	c1 e0 04             	shl    $0x4,%eax
  803b37:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  803b3c:	8b 00                	mov    (%eax),%eax
  803b3e:	85 c0                	test   %eax,%eax
  803b40:	0f 84 dc 00 00 00    	je     803c22 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b49:	c1 e0 04             	shl    $0x4,%eax
  803b4c:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  803b51:	8b 00                	mov    (%eax),%eax
  803b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803b56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b5a:	75 14                	jne    803b70 <alloc_block+0xb0>
  803b5c:	83 ec 04             	sub    $0x4,%esp
  803b5f:	68 9d 4f 80 00       	push   $0x804f9d
  803b64:	6a 6b                	push   $0x6b
  803b66:	68 03 4f 80 00       	push   $0x804f03
  803b6b:	e8 19 cc ff ff       	call   800789 <_panic>
  803b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b73:	8b 00                	mov    (%eax),%eax
  803b75:	85 c0                	test   %eax,%eax
  803b77:	74 10                	je     803b89 <alloc_block+0xc9>
  803b79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7c:	8b 00                	mov    (%eax),%eax
  803b7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b81:	8b 52 04             	mov    0x4(%edx),%edx
  803b84:	89 50 04             	mov    %edx,0x4(%eax)
  803b87:	eb 14                	jmp    803b9d <alloc_block+0xdd>
  803b89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b8c:	8b 40 04             	mov    0x4(%eax),%eax
  803b8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b92:	c1 e2 04             	shl    $0x4,%edx
  803b95:	81 c2 c4 a2 83 00    	add    $0x83a2c4,%edx
  803b9b:	89 02                	mov    %eax,(%edx)
  803b9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba0:	8b 40 04             	mov    0x4(%eax),%eax
  803ba3:	85 c0                	test   %eax,%eax
  803ba5:	74 0f                	je     803bb6 <alloc_block+0xf6>
  803ba7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803baa:	8b 40 04             	mov    0x4(%eax),%eax
  803bad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bb0:	8b 12                	mov    (%edx),%edx
  803bb2:	89 10                	mov    %edx,(%eax)
  803bb4:	eb 13                	jmp    803bc9 <alloc_block+0x109>
  803bb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb9:	8b 00                	mov    (%eax),%eax
  803bbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bbe:	c1 e2 04             	shl    $0x4,%edx
  803bc1:	81 c2 c0 a2 83 00    	add    $0x83a2c0,%edx
  803bc7:	89 02                	mov    %eax,(%edx)
  803bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bdf:	c1 e0 04             	shl    $0x4,%eax
  803be2:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  803be7:	8b 00                	mov    (%eax),%eax
  803be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bef:	c1 e0 04             	shl    $0x4,%eax
  803bf2:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  803bf7:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfc:	83 ec 0c             	sub    $0xc,%esp
  803bff:	50                   	push   %eax
  803c00:	e8 ba fb ff ff       	call   8037bf <to_page_info>
  803c05:	83 c4 10             	add    $0x10,%esp
  803c08:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803c0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c0e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c12:	48                   	dec    %eax
  803c13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c16:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1d:	e9 8f 02 00 00       	jmp    803eb1 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803c22:	ff 45 ec             	incl   -0x14(%ebp)
  803c25:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c29:	0f 8e 02 ff ff ff    	jle    803b31 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803c2f:	a1 88 e0 81 00       	mov    0x81e088,%eax
  803c34:	85 c0                	test   %eax,%eax
  803c36:	75 14                	jne    803c4c <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803c38:	83 ec 04             	sub    $0x4,%esp
  803c3b:	68 bc 4f 80 00       	push   $0x804fbc
  803c40:	6a 77                	push   $0x77
  803c42:	68 03 4f 80 00       	push   $0x804f03
  803c47:	e8 3d cb ff ff       	call   800789 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803c4c:	a1 88 e0 81 00       	mov    0x81e088,%eax
  803c51:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803c54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c58:	75 14                	jne    803c6e <alloc_block+0x1ae>
  803c5a:	83 ec 04             	sub    $0x4,%esp
  803c5d:	68 9d 4f 80 00       	push   $0x804f9d
  803c62:	6a 7a                	push   $0x7a
  803c64:	68 03 4f 80 00       	push   $0x804f03
  803c69:	e8 1b cb ff ff       	call   800789 <_panic>
  803c6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c71:	8b 00                	mov    (%eax),%eax
  803c73:	85 c0                	test   %eax,%eax
  803c75:	74 10                	je     803c87 <alloc_block+0x1c7>
  803c77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c7a:	8b 00                	mov    (%eax),%eax
  803c7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c7f:	8b 52 04             	mov    0x4(%edx),%edx
  803c82:	89 50 04             	mov    %edx,0x4(%eax)
  803c85:	eb 0b                	jmp    803c92 <alloc_block+0x1d2>
  803c87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c8a:	8b 40 04             	mov    0x4(%eax),%eax
  803c8d:	a3 8c e0 81 00       	mov    %eax,0x81e08c
  803c92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c95:	8b 40 04             	mov    0x4(%eax),%eax
  803c98:	85 c0                	test   %eax,%eax
  803c9a:	74 0f                	je     803cab <alloc_block+0x1eb>
  803c9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c9f:	8b 40 04             	mov    0x4(%eax),%eax
  803ca2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ca5:	8b 12                	mov    (%edx),%edx
  803ca7:	89 10                	mov    %edx,(%eax)
  803ca9:	eb 0a                	jmp    803cb5 <alloc_block+0x1f5>
  803cab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cae:	8b 00                	mov    (%eax),%eax
  803cb0:	a3 88 e0 81 00       	mov    %eax,0x81e088
  803cb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cc8:	a1 94 e0 81 00       	mov    0x81e094,%eax
  803ccd:	48                   	dec    %eax
  803cce:	a3 94 e0 81 00       	mov    %eax,0x81e094

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803cd3:	83 ec 0c             	sub    $0xc,%esp
  803cd6:	ff 75 dc             	pushl  -0x24(%ebp)
  803cd9:	e8 6f fa ff ff       	call   80374d <to_page_va>
  803cde:	83 c4 10             	add    $0x10,%esp
  803ce1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803ce4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ce7:	83 ec 0c             	sub    $0xc,%esp
  803cea:	50                   	push   %eax
  803ceb:	e8 a0 dc ff ff       	call   801990 <get_page>
  803cf0:	83 c4 10             	add    $0x10,%esp
  803cf3:	85 c0                	test   %eax,%eax
  803cf5:	74 14                	je     803d0b <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803cf7:	83 ec 04             	sub    $0x4,%esp
  803cfa:	68 e4 4f 80 00       	push   $0x804fe4
  803cff:	6a 7f                	push   $0x7f
  803d01:	68 03 4f 80 00       	push   $0x804f03
  803d06:	e8 7e ca ff ff       	call   800789 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d11:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803d15:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  803d1f:	f7 75 f4             	divl   -0xc(%ebp)
  803d22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d25:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803d29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803d30:	e9 a7 00 00 00       	jmp    803ddc <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803d35:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3b:	01 d0                	add    %edx,%eax
  803d3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803d40:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d44:	75 17                	jne    803d5d <alloc_block+0x29d>
  803d46:	83 ec 04             	sub    $0x4,%esp
  803d49:	68 0c 50 80 00       	push   $0x80500c
  803d4e:	68 88 00 00 00       	push   $0x88
  803d53:	68 03 4f 80 00       	push   $0x804f03
  803d58:	e8 2c ca ff ff       	call   800789 <_panic>
  803d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d60:	c1 e0 04             	shl    $0x4,%eax
  803d63:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  803d68:	8b 10                	mov    (%eax),%edx
  803d6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d6d:	89 10                	mov    %edx,(%eax)
  803d6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d72:	8b 00                	mov    (%eax),%eax
  803d74:	85 c0                	test   %eax,%eax
  803d76:	74 15                	je     803d8d <alloc_block+0x2cd>
  803d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7b:	c1 e0 04             	shl    $0x4,%eax
  803d7e:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  803d83:	8b 00                	mov    (%eax),%eax
  803d85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d88:	89 50 04             	mov    %edx,0x4(%eax)
  803d8b:	eb 11                	jmp    803d9e <alloc_block+0x2de>
  803d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d90:	c1 e0 04             	shl    $0x4,%eax
  803d93:	8d 90 c4 a2 83 00    	lea    0x83a2c4(%eax),%edx
  803d99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d9c:	89 02                	mov    %eax,(%edx)
  803d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803da1:	c1 e0 04             	shl    $0x4,%eax
  803da4:	8d 90 c0 a2 83 00    	lea    0x83a2c0(%eax),%edx
  803daa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dad:	89 02                	mov    %eax,(%edx)
  803daf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbc:	c1 e0 04             	shl    $0x4,%eax
  803dbf:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  803dc4:	8b 00                	mov    (%eax),%eax
  803dc6:	8d 50 01             	lea    0x1(%eax),%edx
  803dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dcc:	c1 e0 04             	shl    $0x4,%eax
  803dcf:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  803dd4:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd9:	01 45 e8             	add    %eax,-0x18(%ebp)
  803ddc:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803de3:	0f 86 4c ff ff ff    	jbe    803d35 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dec:	c1 e0 04             	shl    $0x4,%eax
  803def:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  803df4:	8b 00                	mov    (%eax),%eax
  803df6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803df9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803dfd:	75 17                	jne    803e16 <alloc_block+0x356>
  803dff:	83 ec 04             	sub    $0x4,%esp
  803e02:	68 9d 4f 80 00       	push   $0x804f9d
  803e07:	68 8d 00 00 00       	push   $0x8d
  803e0c:	68 03 4f 80 00       	push   $0x804f03
  803e11:	e8 73 c9 ff ff       	call   800789 <_panic>
  803e16:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e19:	8b 00                	mov    (%eax),%eax
  803e1b:	85 c0                	test   %eax,%eax
  803e1d:	74 10                	je     803e2f <alloc_block+0x36f>
  803e1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e22:	8b 00                	mov    (%eax),%eax
  803e24:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803e27:	8b 52 04             	mov    0x4(%edx),%edx
  803e2a:	89 50 04             	mov    %edx,0x4(%eax)
  803e2d:	eb 14                	jmp    803e43 <alloc_block+0x383>
  803e2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e32:	8b 40 04             	mov    0x4(%eax),%eax
  803e35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e38:	c1 e2 04             	shl    $0x4,%edx
  803e3b:	81 c2 c4 a2 83 00    	add    $0x83a2c4,%edx
  803e41:	89 02                	mov    %eax,(%edx)
  803e43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e46:	8b 40 04             	mov    0x4(%eax),%eax
  803e49:	85 c0                	test   %eax,%eax
  803e4b:	74 0f                	je     803e5c <alloc_block+0x39c>
  803e4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e50:	8b 40 04             	mov    0x4(%eax),%eax
  803e53:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803e56:	8b 12                	mov    (%edx),%edx
  803e58:	89 10                	mov    %edx,(%eax)
  803e5a:	eb 13                	jmp    803e6f <alloc_block+0x3af>
  803e5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e5f:	8b 00                	mov    (%eax),%eax
  803e61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e64:	c1 e2 04             	shl    $0x4,%edx
  803e67:	81 c2 c0 a2 83 00    	add    $0x83a2c0,%edx
  803e6d:	89 02                	mov    %eax,(%edx)
  803e6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e85:	c1 e0 04             	shl    $0x4,%eax
  803e88:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  803e8d:	8b 00                	mov    (%eax),%eax
  803e8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e95:	c1 e0 04             	shl    $0x4,%eax
  803e98:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  803e9d:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803e9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ea2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ea6:	48                   	dec    %eax
  803ea7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803eaa:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803eae:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803eb1:	c9                   	leave  
  803eb2:	c3                   	ret    

00803eb3 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803eb3:	55                   	push   %ebp
  803eb4:	89 e5                	mov    %esp,%ebp
  803eb6:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  803ebc:	a1 a4 a2 83 00       	mov    0x83a2a4,%eax
  803ec1:	39 c2                	cmp    %eax,%edx
  803ec3:	72 0c                	jb     803ed1 <free_block+0x1e>
  803ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  803ec8:	a1 80 e0 81 00       	mov    0x81e080,%eax
  803ecd:	39 c2                	cmp    %eax,%edx
  803ecf:	72 19                	jb     803eea <free_block+0x37>
  803ed1:	68 30 50 80 00       	push   $0x805030
  803ed6:	68 66 4f 80 00       	push   $0x804f66
  803edb:	68 98 00 00 00       	push   $0x98
  803ee0:	68 03 4f 80 00       	push   $0x804f03
  803ee5:	e8 9f c8 ff ff       	call   800789 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803eea:	8b 45 08             	mov    0x8(%ebp),%eax
  803eed:	83 ec 0c             	sub    $0xc,%esp
  803ef0:	50                   	push   %eax
  803ef1:	e8 c9 f8 ff ff       	call   8037bf <to_page_info>
  803ef6:	83 c4 10             	add    $0x10,%esp
  803ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eff:	8b 40 08             	mov    0x8(%eax),%eax
  803f02:	0f b7 c0             	movzwl %ax,%eax
  803f05:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803f08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803f0f:	eb 03                	jmp    803f14 <free_block+0x61>
		listIndex++;
  803f11:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f17:	ba 08 00 00 00       	mov    $0x8,%edx
  803f1c:	88 c1                	mov    %al,%cl
  803f1e:	d3 e2                	shl    %cl,%edx
  803f20:	89 d0                	mov    %edx,%eax
  803f22:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f25:	72 ea                	jb     803f11 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803f27:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803f2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f31:	75 17                	jne    803f4a <free_block+0x97>
  803f33:	83 ec 04             	sub    $0x4,%esp
  803f36:	68 0c 50 80 00       	push   $0x80500c
  803f3b:	68 a2 00 00 00       	push   $0xa2
  803f40:	68 03 4f 80 00       	push   $0x804f03
  803f45:	e8 3f c8 ff ff       	call   800789 <_panic>
  803f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4d:	c1 e0 04             	shl    $0x4,%eax
  803f50:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  803f55:	8b 10                	mov    (%eax),%edx
  803f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5a:	89 10                	mov    %edx,(%eax)
  803f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5f:	8b 00                	mov    (%eax),%eax
  803f61:	85 c0                	test   %eax,%eax
  803f63:	74 15                	je     803f7a <free_block+0xc7>
  803f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f68:	c1 e0 04             	shl    $0x4,%eax
  803f6b:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  803f70:	8b 00                	mov    (%eax),%eax
  803f72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f75:	89 50 04             	mov    %edx,0x4(%eax)
  803f78:	eb 11                	jmp    803f8b <free_block+0xd8>
  803f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7d:	c1 e0 04             	shl    $0x4,%eax
  803f80:	8d 90 c4 a2 83 00    	lea    0x83a2c4(%eax),%edx
  803f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f89:	89 02                	mov    %eax,(%edx)
  803f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8e:	c1 e0 04             	shl    $0x4,%eax
  803f91:	8d 90 c0 a2 83 00    	lea    0x83a2c0(%eax),%edx
  803f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9a:	89 02                	mov    %eax,(%edx)
  803f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa9:	c1 e0 04             	shl    $0x4,%eax
  803fac:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  803fb1:	8b 00                	mov    (%eax),%eax
  803fb3:	8d 50 01             	lea    0x1(%eax),%edx
  803fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb9:	c1 e0 04             	shl    $0x4,%eax
  803fbc:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  803fc1:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fc6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803fca:	40                   	inc    %eax
  803fcb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fce:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fd5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803fd9:	0f b7 c8             	movzwl %ax,%ecx
  803fdc:	b8 00 10 00 00       	mov    $0x1000,%eax
  803fe1:	ba 00 00 00 00       	mov    $0x0,%edx
  803fe6:	f7 75 e8             	divl   -0x18(%ebp)
  803fe9:	39 c1                	cmp    %eax,%ecx
  803feb:	0f 85 ed 01 00 00    	jne    8041de <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff4:	c1 e0 04             	shl    $0x4,%eax
  803ff7:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  803ffc:	8b 00                	mov    (%eax),%eax
  803ffe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804001:	eb 2a                	jmp    80402d <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  804003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804006:	83 ec 0c             	sub    $0xc,%esp
  804009:	50                   	push   %eax
  80400a:	e8 b0 f7 ff ff       	call   8037bf <to_page_info>
  80400f:	83 c4 10             	add    $0x10,%esp
  804012:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804015:	75 06                	jne    80401d <free_block+0x16a>
				tmp = b;
  804017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  80401d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804020:	c1 e0 04             	shl    $0x4,%eax
  804023:	05 c8 a2 83 00       	add    $0x83a2c8,%eax
  804028:	8b 00                	mov    (%eax),%eax
  80402a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80402d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804031:	74 07                	je     80403a <free_block+0x187>
  804033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804036:	8b 00                	mov    (%eax),%eax
  804038:	eb 05                	jmp    80403f <free_block+0x18c>
  80403a:	b8 00 00 00 00       	mov    $0x0,%eax
  80403f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804042:	c1 e2 04             	shl    $0x4,%edx
  804045:	81 c2 c8 a2 83 00    	add    $0x83a2c8,%edx
  80404b:	89 02                	mov    %eax,(%edx)
  80404d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804050:	c1 e0 04             	shl    $0x4,%eax
  804053:	05 c8 a2 83 00       	add    $0x83a2c8,%eax
  804058:	8b 00                	mov    (%eax),%eax
  80405a:	85 c0                	test   %eax,%eax
  80405c:	75 a5                	jne    804003 <free_block+0x150>
  80405e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804062:	75 9f                	jne    804003 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804067:	c1 e0 04             	shl    $0x4,%eax
  80406a:	05 c0 a2 83 00       	add    $0x83a2c0,%eax
  80406f:	8b 00                	mov    (%eax),%eax
  804071:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804074:	e9 cc 00 00 00       	jmp    804145 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  804079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80407c:	8b 00                	mov    (%eax),%eax
  80407e:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804084:	83 ec 0c             	sub    $0xc,%esp
  804087:	50                   	push   %eax
  804088:	e8 32 f7 ff ff       	call   8037bf <to_page_info>
  80408d:	83 c4 10             	add    $0x10,%esp
  804090:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804093:	0f 85 a6 00 00 00    	jne    80413f <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  804099:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80409d:	75 17                	jne    8040b6 <free_block+0x203>
  80409f:	83 ec 04             	sub    $0x4,%esp
  8040a2:	68 9d 4f 80 00       	push   $0x804f9d
  8040a7:	68 b5 00 00 00       	push   $0xb5
  8040ac:	68 03 4f 80 00       	push   $0x804f03
  8040b1:	e8 d3 c6 ff ff       	call   800789 <_panic>
  8040b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b9:	8b 00                	mov    (%eax),%eax
  8040bb:	85 c0                	test   %eax,%eax
  8040bd:	74 10                	je     8040cf <free_block+0x21c>
  8040bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040c2:	8b 00                	mov    (%eax),%eax
  8040c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040c7:	8b 52 04             	mov    0x4(%edx),%edx
  8040ca:	89 50 04             	mov    %edx,0x4(%eax)
  8040cd:	eb 14                	jmp    8040e3 <free_block+0x230>
  8040cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040d2:	8b 40 04             	mov    0x4(%eax),%eax
  8040d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040d8:	c1 e2 04             	shl    $0x4,%edx
  8040db:	81 c2 c4 a2 83 00    	add    $0x83a2c4,%edx
  8040e1:	89 02                	mov    %eax,(%edx)
  8040e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040e6:	8b 40 04             	mov    0x4(%eax),%eax
  8040e9:	85 c0                	test   %eax,%eax
  8040eb:	74 0f                	je     8040fc <free_block+0x249>
  8040ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040f0:	8b 40 04             	mov    0x4(%eax),%eax
  8040f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040f6:	8b 12                	mov    (%edx),%edx
  8040f8:	89 10                	mov    %edx,(%eax)
  8040fa:	eb 13                	jmp    80410f <free_block+0x25c>
  8040fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040ff:	8b 00                	mov    (%eax),%eax
  804101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804104:	c1 e2 04             	shl    $0x4,%edx
  804107:	81 c2 c0 a2 83 00    	add    $0x83a2c0,%edx
  80410d:	89 02                	mov    %eax,(%edx)
  80410f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80411b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804125:	c1 e0 04             	shl    $0x4,%eax
  804128:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  80412d:	8b 00                	mov    (%eax),%eax
  80412f:	8d 50 ff             	lea    -0x1(%eax),%edx
  804132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804135:	c1 e0 04             	shl    $0x4,%eax
  804138:	05 cc a2 83 00       	add    $0x83a2cc,%eax
  80413d:	89 10                	mov    %edx,(%eax)
			b = next;
  80413f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804142:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804145:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804149:	0f 85 2a ff ff ff    	jne    804079 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  80414f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804152:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80415b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804161:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804165:	75 17                	jne    80417e <free_block+0x2cb>
  804167:	83 ec 04             	sub    $0x4,%esp
  80416a:	68 0c 50 80 00       	push   $0x80500c
  80416f:	68 bc 00 00 00       	push   $0xbc
  804174:	68 03 4f 80 00       	push   $0x804f03
  804179:	e8 0b c6 ff ff       	call   800789 <_panic>
  80417e:	8b 15 88 e0 81 00    	mov    0x81e088,%edx
  804184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804187:	89 10                	mov    %edx,(%eax)
  804189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80418c:	8b 00                	mov    (%eax),%eax
  80418e:	85 c0                	test   %eax,%eax
  804190:	74 0d                	je     80419f <free_block+0x2ec>
  804192:	a1 88 e0 81 00       	mov    0x81e088,%eax
  804197:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80419a:	89 50 04             	mov    %edx,0x4(%eax)
  80419d:	eb 08                	jmp    8041a7 <free_block+0x2f4>
  80419f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041a2:	a3 8c e0 81 00       	mov    %eax,0x81e08c
  8041a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041aa:	a3 88 e0 81 00       	mov    %eax,0x81e088
  8041af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041b9:	a1 94 e0 81 00       	mov    0x81e094,%eax
  8041be:	40                   	inc    %eax
  8041bf:	a3 94 e0 81 00       	mov    %eax,0x81e094

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  8041c4:	83 ec 0c             	sub    $0xc,%esp
  8041c7:	ff 75 ec             	pushl  -0x14(%ebp)
  8041ca:	e8 7e f5 ff ff       	call   80374d <to_page_va>
  8041cf:	83 c4 10             	add    $0x10,%esp
  8041d2:	83 ec 0c             	sub    $0xc,%esp
  8041d5:	50                   	push   %eax
  8041d6:	e8 fe d7 ff ff       	call   8019d9 <return_page>
  8041db:	83 c4 10             	add    $0x10,%esp
	}
}
  8041de:	90                   	nop
  8041df:	c9                   	leave  
  8041e0:	c3                   	ret    
  8041e1:	66 90                	xchg   %ax,%ax
  8041e3:	90                   	nop

008041e4 <__udivdi3>:
  8041e4:	55                   	push   %ebp
  8041e5:	57                   	push   %edi
  8041e6:	56                   	push   %esi
  8041e7:	53                   	push   %ebx
  8041e8:	83 ec 1c             	sub    $0x1c,%esp
  8041eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041fb:	89 ca                	mov    %ecx,%edx
  8041fd:	89 f8                	mov    %edi,%eax
  8041ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804203:	85 f6                	test   %esi,%esi
  804205:	75 2d                	jne    804234 <__udivdi3+0x50>
  804207:	39 cf                	cmp    %ecx,%edi
  804209:	77 65                	ja     804270 <__udivdi3+0x8c>
  80420b:	89 fd                	mov    %edi,%ebp
  80420d:	85 ff                	test   %edi,%edi
  80420f:	75 0b                	jne    80421c <__udivdi3+0x38>
  804211:	b8 01 00 00 00       	mov    $0x1,%eax
  804216:	31 d2                	xor    %edx,%edx
  804218:	f7 f7                	div    %edi
  80421a:	89 c5                	mov    %eax,%ebp
  80421c:	31 d2                	xor    %edx,%edx
  80421e:	89 c8                	mov    %ecx,%eax
  804220:	f7 f5                	div    %ebp
  804222:	89 c1                	mov    %eax,%ecx
  804224:	89 d8                	mov    %ebx,%eax
  804226:	f7 f5                	div    %ebp
  804228:	89 cf                	mov    %ecx,%edi
  80422a:	89 fa                	mov    %edi,%edx
  80422c:	83 c4 1c             	add    $0x1c,%esp
  80422f:	5b                   	pop    %ebx
  804230:	5e                   	pop    %esi
  804231:	5f                   	pop    %edi
  804232:	5d                   	pop    %ebp
  804233:	c3                   	ret    
  804234:	39 ce                	cmp    %ecx,%esi
  804236:	77 28                	ja     804260 <__udivdi3+0x7c>
  804238:	0f bd fe             	bsr    %esi,%edi
  80423b:	83 f7 1f             	xor    $0x1f,%edi
  80423e:	75 40                	jne    804280 <__udivdi3+0x9c>
  804240:	39 ce                	cmp    %ecx,%esi
  804242:	72 0a                	jb     80424e <__udivdi3+0x6a>
  804244:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804248:	0f 87 9e 00 00 00    	ja     8042ec <__udivdi3+0x108>
  80424e:	b8 01 00 00 00       	mov    $0x1,%eax
  804253:	89 fa                	mov    %edi,%edx
  804255:	83 c4 1c             	add    $0x1c,%esp
  804258:	5b                   	pop    %ebx
  804259:	5e                   	pop    %esi
  80425a:	5f                   	pop    %edi
  80425b:	5d                   	pop    %ebp
  80425c:	c3                   	ret    
  80425d:	8d 76 00             	lea    0x0(%esi),%esi
  804260:	31 ff                	xor    %edi,%edi
  804262:	31 c0                	xor    %eax,%eax
  804264:	89 fa                	mov    %edi,%edx
  804266:	83 c4 1c             	add    $0x1c,%esp
  804269:	5b                   	pop    %ebx
  80426a:	5e                   	pop    %esi
  80426b:	5f                   	pop    %edi
  80426c:	5d                   	pop    %ebp
  80426d:	c3                   	ret    
  80426e:	66 90                	xchg   %ax,%ax
  804270:	89 d8                	mov    %ebx,%eax
  804272:	f7 f7                	div    %edi
  804274:	31 ff                	xor    %edi,%edi
  804276:	89 fa                	mov    %edi,%edx
  804278:	83 c4 1c             	add    $0x1c,%esp
  80427b:	5b                   	pop    %ebx
  80427c:	5e                   	pop    %esi
  80427d:	5f                   	pop    %edi
  80427e:	5d                   	pop    %ebp
  80427f:	c3                   	ret    
  804280:	bd 20 00 00 00       	mov    $0x20,%ebp
  804285:	89 eb                	mov    %ebp,%ebx
  804287:	29 fb                	sub    %edi,%ebx
  804289:	89 f9                	mov    %edi,%ecx
  80428b:	d3 e6                	shl    %cl,%esi
  80428d:	89 c5                	mov    %eax,%ebp
  80428f:	88 d9                	mov    %bl,%cl
  804291:	d3 ed                	shr    %cl,%ebp
  804293:	89 e9                	mov    %ebp,%ecx
  804295:	09 f1                	or     %esi,%ecx
  804297:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80429b:	89 f9                	mov    %edi,%ecx
  80429d:	d3 e0                	shl    %cl,%eax
  80429f:	89 c5                	mov    %eax,%ebp
  8042a1:	89 d6                	mov    %edx,%esi
  8042a3:	88 d9                	mov    %bl,%cl
  8042a5:	d3 ee                	shr    %cl,%esi
  8042a7:	89 f9                	mov    %edi,%ecx
  8042a9:	d3 e2                	shl    %cl,%edx
  8042ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042af:	88 d9                	mov    %bl,%cl
  8042b1:	d3 e8                	shr    %cl,%eax
  8042b3:	09 c2                	or     %eax,%edx
  8042b5:	89 d0                	mov    %edx,%eax
  8042b7:	89 f2                	mov    %esi,%edx
  8042b9:	f7 74 24 0c          	divl   0xc(%esp)
  8042bd:	89 d6                	mov    %edx,%esi
  8042bf:	89 c3                	mov    %eax,%ebx
  8042c1:	f7 e5                	mul    %ebp
  8042c3:	39 d6                	cmp    %edx,%esi
  8042c5:	72 19                	jb     8042e0 <__udivdi3+0xfc>
  8042c7:	74 0b                	je     8042d4 <__udivdi3+0xf0>
  8042c9:	89 d8                	mov    %ebx,%eax
  8042cb:	31 ff                	xor    %edi,%edi
  8042cd:	e9 58 ff ff ff       	jmp    80422a <__udivdi3+0x46>
  8042d2:	66 90                	xchg   %ax,%ax
  8042d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8042d8:	89 f9                	mov    %edi,%ecx
  8042da:	d3 e2                	shl    %cl,%edx
  8042dc:	39 c2                	cmp    %eax,%edx
  8042de:	73 e9                	jae    8042c9 <__udivdi3+0xe5>
  8042e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042e3:	31 ff                	xor    %edi,%edi
  8042e5:	e9 40 ff ff ff       	jmp    80422a <__udivdi3+0x46>
  8042ea:	66 90                	xchg   %ax,%ax
  8042ec:	31 c0                	xor    %eax,%eax
  8042ee:	e9 37 ff ff ff       	jmp    80422a <__udivdi3+0x46>
  8042f3:	90                   	nop

008042f4 <__umoddi3>:
  8042f4:	55                   	push   %ebp
  8042f5:	57                   	push   %edi
  8042f6:	56                   	push   %esi
  8042f7:	53                   	push   %ebx
  8042f8:	83 ec 1c             	sub    $0x1c,%esp
  8042fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  804303:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804307:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80430b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80430f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804313:	89 f3                	mov    %esi,%ebx
  804315:	89 fa                	mov    %edi,%edx
  804317:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80431b:	89 34 24             	mov    %esi,(%esp)
  80431e:	85 c0                	test   %eax,%eax
  804320:	75 1a                	jne    80433c <__umoddi3+0x48>
  804322:	39 f7                	cmp    %esi,%edi
  804324:	0f 86 a2 00 00 00    	jbe    8043cc <__umoddi3+0xd8>
  80432a:	89 c8                	mov    %ecx,%eax
  80432c:	89 f2                	mov    %esi,%edx
  80432e:	f7 f7                	div    %edi
  804330:	89 d0                	mov    %edx,%eax
  804332:	31 d2                	xor    %edx,%edx
  804334:	83 c4 1c             	add    $0x1c,%esp
  804337:	5b                   	pop    %ebx
  804338:	5e                   	pop    %esi
  804339:	5f                   	pop    %edi
  80433a:	5d                   	pop    %ebp
  80433b:	c3                   	ret    
  80433c:	39 f0                	cmp    %esi,%eax
  80433e:	0f 87 ac 00 00 00    	ja     8043f0 <__umoddi3+0xfc>
  804344:	0f bd e8             	bsr    %eax,%ebp
  804347:	83 f5 1f             	xor    $0x1f,%ebp
  80434a:	0f 84 ac 00 00 00    	je     8043fc <__umoddi3+0x108>
  804350:	bf 20 00 00 00       	mov    $0x20,%edi
  804355:	29 ef                	sub    %ebp,%edi
  804357:	89 fe                	mov    %edi,%esi
  804359:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80435d:	89 e9                	mov    %ebp,%ecx
  80435f:	d3 e0                	shl    %cl,%eax
  804361:	89 d7                	mov    %edx,%edi
  804363:	89 f1                	mov    %esi,%ecx
  804365:	d3 ef                	shr    %cl,%edi
  804367:	09 c7                	or     %eax,%edi
  804369:	89 e9                	mov    %ebp,%ecx
  80436b:	d3 e2                	shl    %cl,%edx
  80436d:	89 14 24             	mov    %edx,(%esp)
  804370:	89 d8                	mov    %ebx,%eax
  804372:	d3 e0                	shl    %cl,%eax
  804374:	89 c2                	mov    %eax,%edx
  804376:	8b 44 24 08          	mov    0x8(%esp),%eax
  80437a:	d3 e0                	shl    %cl,%eax
  80437c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804380:	8b 44 24 08          	mov    0x8(%esp),%eax
  804384:	89 f1                	mov    %esi,%ecx
  804386:	d3 e8                	shr    %cl,%eax
  804388:	09 d0                	or     %edx,%eax
  80438a:	d3 eb                	shr    %cl,%ebx
  80438c:	89 da                	mov    %ebx,%edx
  80438e:	f7 f7                	div    %edi
  804390:	89 d3                	mov    %edx,%ebx
  804392:	f7 24 24             	mull   (%esp)
  804395:	89 c6                	mov    %eax,%esi
  804397:	89 d1                	mov    %edx,%ecx
  804399:	39 d3                	cmp    %edx,%ebx
  80439b:	0f 82 87 00 00 00    	jb     804428 <__umoddi3+0x134>
  8043a1:	0f 84 91 00 00 00    	je     804438 <__umoddi3+0x144>
  8043a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8043ab:	29 f2                	sub    %esi,%edx
  8043ad:	19 cb                	sbb    %ecx,%ebx
  8043af:	89 d8                	mov    %ebx,%eax
  8043b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8043b5:	d3 e0                	shl    %cl,%eax
  8043b7:	89 e9                	mov    %ebp,%ecx
  8043b9:	d3 ea                	shr    %cl,%edx
  8043bb:	09 d0                	or     %edx,%eax
  8043bd:	89 e9                	mov    %ebp,%ecx
  8043bf:	d3 eb                	shr    %cl,%ebx
  8043c1:	89 da                	mov    %ebx,%edx
  8043c3:	83 c4 1c             	add    $0x1c,%esp
  8043c6:	5b                   	pop    %ebx
  8043c7:	5e                   	pop    %esi
  8043c8:	5f                   	pop    %edi
  8043c9:	5d                   	pop    %ebp
  8043ca:	c3                   	ret    
  8043cb:	90                   	nop
  8043cc:	89 fd                	mov    %edi,%ebp
  8043ce:	85 ff                	test   %edi,%edi
  8043d0:	75 0b                	jne    8043dd <__umoddi3+0xe9>
  8043d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8043d7:	31 d2                	xor    %edx,%edx
  8043d9:	f7 f7                	div    %edi
  8043db:	89 c5                	mov    %eax,%ebp
  8043dd:	89 f0                	mov    %esi,%eax
  8043df:	31 d2                	xor    %edx,%edx
  8043e1:	f7 f5                	div    %ebp
  8043e3:	89 c8                	mov    %ecx,%eax
  8043e5:	f7 f5                	div    %ebp
  8043e7:	89 d0                	mov    %edx,%eax
  8043e9:	e9 44 ff ff ff       	jmp    804332 <__umoddi3+0x3e>
  8043ee:	66 90                	xchg   %ax,%ax
  8043f0:	89 c8                	mov    %ecx,%eax
  8043f2:	89 f2                	mov    %esi,%edx
  8043f4:	83 c4 1c             	add    $0x1c,%esp
  8043f7:	5b                   	pop    %ebx
  8043f8:	5e                   	pop    %esi
  8043f9:	5f                   	pop    %edi
  8043fa:	5d                   	pop    %ebp
  8043fb:	c3                   	ret    
  8043fc:	3b 04 24             	cmp    (%esp),%eax
  8043ff:	72 06                	jb     804407 <__umoddi3+0x113>
  804401:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804405:	77 0f                	ja     804416 <__umoddi3+0x122>
  804407:	89 f2                	mov    %esi,%edx
  804409:	29 f9                	sub    %edi,%ecx
  80440b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80440f:	89 14 24             	mov    %edx,(%esp)
  804412:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804416:	8b 44 24 04          	mov    0x4(%esp),%eax
  80441a:	8b 14 24             	mov    (%esp),%edx
  80441d:	83 c4 1c             	add    $0x1c,%esp
  804420:	5b                   	pop    %ebx
  804421:	5e                   	pop    %esi
  804422:	5f                   	pop    %edi
  804423:	5d                   	pop    %ebp
  804424:	c3                   	ret    
  804425:	8d 76 00             	lea    0x0(%esi),%esi
  804428:	2b 04 24             	sub    (%esp),%eax
  80442b:	19 fa                	sbb    %edi,%edx
  80442d:	89 d1                	mov    %edx,%ecx
  80442f:	89 c6                	mov    %eax,%esi
  804431:	e9 71 ff ff ff       	jmp    8043a7 <__umoddi3+0xb3>
  804436:	66 90                	xchg   %ax,%ax
  804438:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80443c:	72 ea                	jb     804428 <__umoddi3+0x134>
  80443e:	89 d9                	mov    %ebx,%ecx
  804440:	e9 62 ff ff ff       	jmp    8043a7 <__umoddi3+0xb3>
