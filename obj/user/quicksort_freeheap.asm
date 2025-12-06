
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 35 34 00 00       	call   803483 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 47 34 00 00       	call   80349c <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_lock_cons();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 20 46 80 00       	push   $0x804620
  80006c:	e8 79 10 00 00       	call   8010ea <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 7a 16 00 00       	call   801701 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 3f 1b 00 00       	call   801bdb <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 40 46 80 00       	push   $0x804640
  8000aa:	e8 62 09 00 00       	call   800a11 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 63 46 80 00       	push   $0x804663
  8000ba:	e8 52 09 00 00       	call   800a11 <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 71 46 80 00       	push   $0x804671
  8000ca:	e8 42 09 00 00       	call   800a11 <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 80 46 80 00       	push   $0x804680
  8000da:	e8 32 09 00 00       	call   800a11 <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 90 46 80 00       	push   $0x804690
  8000ea:	e8 22 09 00 00       	call   800a11 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 7f 04 00 00       	call   800576 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 50 04 00 00       	call   800557 <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 43 04 00 00       	call   800557 <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeIdentical>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 9c 46 80 00       	push   $0x80469c
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 be 46 80 00       	push   $0x8046be
  8001c0:	e8 7e 05 00 00       	call   800743 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 d8 46 80 00       	push   $0x8046d8
  8001cd:	e8 3f 08 00 00       	call   800a11 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 0c 47 80 00       	push   $0x80470c
  8001dd:	e8 2f 08 00 00       	call   800a11 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 40 47 80 00       	push   $0x804740
  8001ed:	e8 1f 08 00 00       	call   800a11 <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 72 47 80 00       	push   $0x804772
  8001fd:	e8 0f 08 00 00       	call   800a11 <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_lock_cons();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 88 47 80 00       	push   $0x804788
  80020d:	e8 ff 07 00 00       	call   800a11 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 5c 03 00 00       	call   800576 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 2d 03 00 00       	call   800557 <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 20 03 00 00       	call   800557 <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 13 03 00 00       	call   800557 <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_unlock_cons();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800492:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800496:	75 07                	jne    80049f <InitializeSemiRandom+0x27>
			Repetition = 3;
  800498:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80049f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004a6:	eb 1e                	jmp    8004c6 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8004a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bb:	99                   	cltd   
  8004bc:	f7 7d f8             	idivl  -0x8(%ebp)
  8004bf:	89 d0                	mov    %edx,%eax
  8004c1:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c3:	ff 45 fc             	incl   -0x4(%ebp)
  8004c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cc:	7c da                	jl     8004a8 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004ce:	90                   	nop
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    

008004d1 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004d7:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e5:	eb 42                	jmp    800529 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	99                   	cltd   
  8004eb:	f7 7d f0             	idivl  -0x10(%ebp)
  8004ee:	89 d0                	mov    %edx,%eax
  8004f0:	85 c0                	test   %eax,%eax
  8004f2:	75 10                	jne    800504 <PrintElements+0x33>
			cprintf("\n");
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	68 a6 47 80 00       	push   $0x8047a6
  8004fc:	e8 10 05 00 00       	call   800a11 <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	01 d0                	add    %edx,%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	50                   	push   %eax
  800519:	68 a8 47 80 00       	push   $0x8047a8
  80051e:	e8 ee 04 00 00       	call   800a11 <cprintf>
  800523:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800526:	ff 45 f4             	incl   -0xc(%ebp)
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	48                   	dec    %eax
  80052d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800530:	7f b5                	jg     8004e7 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800535:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	8b 00                	mov    (%eax),%eax
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	50                   	push   %eax
  800547:	68 ad 47 80 00       	push   $0x8047ad
  80054c:	e8 c0 04 00 00       	call   800a11 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp
}
  800554:	90                   	nop
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800563:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	50                   	push   %eax
  80056b:	e8 ab 2f 00 00       	call   80351b <sys_cputc>
  800570:	83 c4 10             	add    $0x10,%esp
}
  800573:	90                   	nop
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <getchar>:


int
getchar(void)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80057c:	e8 39 2e 00 00       	call   8033ba <sys_cgetc>
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800584:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <iscons>:

int iscons(int fdnum)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80058c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800591:	5d                   	pop    %ebp
  800592:	c3                   	ret    

00800593 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	57                   	push   %edi
  800597:	56                   	push   %esi
  800598:	53                   	push   %ebx
  800599:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80059c:	e8 ab 30 00 00       	call   80364c <sys_getenvindex>
  8005a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005a7:	89 d0                	mov    %edx,%eax
  8005a9:	c1 e0 03             	shl    $0x3,%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	c1 e0 02             	shl    $0x2,%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	c1 e0 03             	shl    $0x3,%eax
  8005bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c4:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c9:	a1 24 60 80 00       	mov    0x806024,%eax
  8005ce:	8a 40 20             	mov    0x20(%eax),%al
  8005d1:	84 c0                	test   %al,%al
  8005d3:	74 0d                	je     8005e2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8005d5:	a1 24 60 80 00       	mov    0x806024,%eax
  8005da:	83 c0 20             	add    $0x20,%eax
  8005dd:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e6:	7e 0a                	jle    8005f2 <libmain+0x5f>
		binaryname = argv[0];
  8005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 38 fa ff ff       	call   800038 <_main>
  800600:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800603:	a1 00 60 80 00       	mov    0x806000,%eax
  800608:	85 c0                	test   %eax,%eax
  80060a:	0f 84 01 01 00 00    	je     800711 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800610:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800616:	bb ac 48 80 00       	mov    $0x8048ac,%ebx
  80061b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800620:	89 c7                	mov    %eax,%edi
  800622:	89 de                	mov    %ebx,%esi
  800624:	89 d1                	mov    %edx,%ecx
  800626:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800628:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80062b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800630:	b0 00                	mov    $0x0,%al
  800632:	89 d7                	mov    %edx,%edi
  800634:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800636:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80063d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	50                   	push   %eax
  800644:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80064a:	50                   	push   %eax
  80064b:	e8 32 32 00 00       	call   803882 <sys_utilities>
  800650:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800653:	e8 7b 2d 00 00       	call   8033d3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 cc 47 80 00       	push   $0x8047cc
  800660:	e8 ac 03 00 00       	call   800a11 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066b:	85 c0                	test   %eax,%eax
  80066d:	74 18                	je     800687 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80066f:	e8 2c 32 00 00       	call   8038a0 <sys_get_optimal_num_faults>
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	50                   	push   %eax
  800678:	68 f4 47 80 00       	push   $0x8047f4
  80067d:	e8 8f 03 00 00       	call   800a11 <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	eb 59                	jmp    8006e0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800687:	a1 24 60 80 00       	mov    0x806024,%eax
  80068c:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800692:	a1 24 60 80 00       	mov    0x806024,%eax
  800697:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80069d:	83 ec 04             	sub    $0x4,%esp
  8006a0:	52                   	push   %edx
  8006a1:	50                   	push   %eax
  8006a2:	68 18 48 80 00       	push   $0x804818
  8006a7:	e8 65 03 00 00       	call   800a11 <cprintf>
  8006ac:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006af:	a1 24 60 80 00       	mov    0x806024,%eax
  8006b4:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8006ba:	a1 24 60 80 00       	mov    0x806024,%eax
  8006bf:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8006c5:	a1 24 60 80 00       	mov    0x806024,%eax
  8006ca:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006d0:	51                   	push   %ecx
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	68 40 48 80 00       	push   $0x804840
  8006d8:	e8 34 03 00 00       	call   800a11 <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 60 80 00       	mov    0x806024,%eax
  8006e5:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 98 48 80 00       	push   $0x804898
  8006f4:	e8 18 03 00 00       	call   800a11 <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 cc 47 80 00       	push   $0x8047cc
  800704:	e8 08 03 00 00       	call   800a11 <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80070c:	e8 dc 2c 00 00       	call   8033ed <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800711:	e8 1f 00 00 00       	call   800735 <exit>
}
  800716:	90                   	nop
  800717:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 00                	push   $0x0
  80072a:	e8 e9 2e 00 00       	call   803618 <sys_destroy_env>
  80072f:	83 c4 10             	add    $0x10,%esp
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <exit>:

void
exit(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80073b:	e8 3e 2f 00 00       	call   80367e <sys_exit_env>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800749:	8d 45 10             	lea    0x10(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800752:	a1 38 61 83 00       	mov    0x836138,%eax
  800757:	85 c0                	test   %eax,%eax
  800759:	74 16                	je     800771 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80075b:	a1 38 61 83 00       	mov    0x836138,%eax
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	50                   	push   %eax
  800764:	68 10 49 80 00       	push   $0x804910
  800769:	e8 a3 02 00 00       	call   800a11 <cprintf>
  80076e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800771:	a1 04 60 80 00       	mov    0x806004,%eax
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	ff 75 08             	pushl  0x8(%ebp)
  80077f:	50                   	push   %eax
  800780:	68 18 49 80 00       	push   $0x804918
  800785:	6a 74                	push   $0x74
  800787:	e8 b2 02 00 00       	call   800a3e <cprintf_colored>
  80078c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80078f:	8b 45 10             	mov    0x10(%ebp),%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 f4             	pushl  -0xc(%ebp)
  800798:	50                   	push   %eax
  800799:	e8 04 02 00 00       	call   8009a2 <vcprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	6a 00                	push   $0x0
  8007a6:	68 40 49 80 00       	push   $0x804940
  8007ab:	e8 f2 01 00 00       	call   8009a2 <vcprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007b3:	e8 7d ff ff ff       	call   800735 <exit>

	// should not return here
	while (1) ;
  8007b8:	eb fe                	jmp    8007b8 <_panic+0x75>

008007ba <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007c0:	a1 24 60 80 00       	mov    0x806024,%eax
  8007c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	39 c2                	cmp    %eax,%edx
  8007d0:	74 14                	je     8007e6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007d2:	83 ec 04             	sub    $0x4,%esp
  8007d5:	68 44 49 80 00       	push   $0x804944
  8007da:	6a 26                	push   $0x26
  8007dc:	68 90 49 80 00       	push   $0x804990
  8007e1:	e8 5d ff ff ff       	call   800743 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007f4:	e9 c5 00 00 00       	jmp    8008be <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	01 d0                	add    %edx,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	85 c0                	test   %eax,%eax
  80080c:	75 08                	jne    800816 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80080e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800811:	e9 a5 00 00 00       	jmp    8008bb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800816:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80081d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800824:	eb 69                	jmp    80088f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800826:	a1 24 60 80 00       	mov    0x806024,%eax
  80082b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800831:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800834:	89 d0                	mov    %edx,%eax
  800836:	01 c0                	add    %eax,%eax
  800838:	01 d0                	add    %edx,%eax
  80083a:	c1 e0 03             	shl    $0x3,%eax
  80083d:	01 c8                	add    %ecx,%eax
  80083f:	8a 40 04             	mov    0x4(%eax),%al
  800842:	84 c0                	test   %al,%al
  800844:	75 46                	jne    80088c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800846:	a1 24 60 80 00       	mov    0x806024,%eax
  80084b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800851:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800854:	89 d0                	mov    %edx,%eax
  800856:	01 c0                	add    %eax,%eax
  800858:	01 d0                	add    %edx,%eax
  80085a:	c1 e0 03             	shl    $0x3,%eax
  80085d:	01 c8                	add    %ecx,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800864:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800867:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80086c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80086e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800871:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	01 c8                	add    %ecx,%eax
  80087d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	75 09                	jne    80088c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800883:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80088a:	eb 15                	jmp    8008a1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088c:	ff 45 e8             	incl   -0x18(%ebp)
  80088f:	a1 24 60 80 00       	mov    0x806024,%eax
  800894:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80089a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089d:	39 c2                	cmp    %eax,%edx
  80089f:	77 85                	ja     800826 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008a5:	75 14                	jne    8008bb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008a7:	83 ec 04             	sub    $0x4,%esp
  8008aa:	68 9c 49 80 00       	push   $0x80499c
  8008af:	6a 3a                	push   $0x3a
  8008b1:	68 90 49 80 00       	push   $0x804990
  8008b6:	e8 88 fe ff ff       	call   800743 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008bb:	ff 45 f0             	incl   -0x10(%ebp)
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008c4:	0f 8c 2f ff ff ff    	jl     8007f9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008d8:	eb 26                	jmp    800900 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008da:	a1 24 60 80 00       	mov    0x806024,%eax
  8008df:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e8:	89 d0                	mov    %edx,%eax
  8008ea:	01 c0                	add    %eax,%eax
  8008ec:	01 d0                	add    %edx,%eax
  8008ee:	c1 e0 03             	shl    $0x3,%eax
  8008f1:	01 c8                	add    %ecx,%eax
  8008f3:	8a 40 04             	mov    0x4(%eax),%al
  8008f6:	3c 01                	cmp    $0x1,%al
  8008f8:	75 03                	jne    8008fd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008fa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e0             	incl   -0x20(%ebp)
  800900:	a1 24 60 80 00       	mov    0x806024,%eax
  800905:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80090b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090e:	39 c2                	cmp    %eax,%edx
  800910:	77 c8                	ja     8008da <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800915:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800918:	74 14                	je     80092e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 f0 49 80 00       	push   $0x8049f0
  800922:	6a 44                	push   $0x44
  800924:	68 90 49 80 00       	push   $0x804990
  800929:	e8 15 fe ff ff       	call   800743 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80092e:	90                   	nop
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	53                   	push   %ebx
  800935:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	8d 48 01             	lea    0x1(%eax),%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	89 0a                	mov    %ecx,(%edx)
  800945:	8b 55 08             	mov    0x8(%ebp),%edx
  800948:	88 d1                	mov    %dl,%cl
  80094a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	3d ff 00 00 00       	cmp    $0xff,%eax
  80095b:	75 30                	jne    80098d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80095d:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800963:	a0 64 e0 81 00       	mov    0x81e064,%al
  800968:	0f b6 c0             	movzbl %al,%eax
  80096b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096e:	8b 09                	mov    (%ecx),%ecx
  800970:	89 cb                	mov    %ecx,%ebx
  800972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800975:	83 c1 08             	add    $0x8,%ecx
  800978:	52                   	push   %edx
  800979:	50                   	push   %eax
  80097a:	53                   	push   %ebx
  80097b:	51                   	push   %ecx
  80097c:	e8 0e 2a 00 00       	call   80338f <sys_cputs>
  800981:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800984:	8b 45 0c             	mov    0xc(%ebp),%eax
  800987:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	8b 40 04             	mov    0x4(%eax),%eax
  800993:	8d 50 01             	lea    0x1(%eax),%edx
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099c:	90                   	nop
  80099d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 31 09 80 00       	push   $0x800931
  8009d1:	e8 5a 02 00 00       	call   800c30 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8009d9:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  8009df:	a0 64 e0 81 00       	mov    0x81e064,%al
  8009e4:	0f b6 c0             	movzbl %al,%eax
  8009e7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8009ed:	52                   	push   %edx
  8009ee:	50                   	push   %eax
  8009ef:	51                   	push   %ecx
  8009f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f6:	83 c0 08             	add    $0x8,%eax
  8009f9:	50                   	push   %eax
  8009fa:	e8 90 29 00 00       	call   80338f <sys_cputs>
  8009ff:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a02:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800a09:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a17:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800a1e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2d:	50                   	push   %eax
  800a2e:	e8 6f ff ff ff       	call   8009a2 <vcprintf>
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a3c:	c9                   	leave  
  800a3d:	c3                   	ret    

00800a3e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a44:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	c1 e0 08             	shl    $0x8,%eax
  800a51:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800a56:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a59:	83 c0 04             	add    $0x4,%eax
  800a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 f4             	pushl  -0xc(%ebp)
  800a68:	50                   	push   %eax
  800a69:	e8 34 ff ff ff       	call   8009a2 <vcprintf>
  800a6e:	83 c4 10             	add    $0x10,%esp
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800a74:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800a7b:	07 00 00 

	return cnt;
  800a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a89:	e8 45 29 00 00       	call   8033d3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9d:	50                   	push   %eax
  800a9e:	e8 ff fe ff ff       	call   8009a2 <vcprintf>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800aa9:	e8 3f 29 00 00       	call   8033ed <sys_unlock_cons>
	return cnt;
  800aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab1:	c9                   	leave  
  800ab2:	c3                   	ret    

00800ab3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	53                   	push   %ebx
  800ab7:	83 ec 14             	sub    $0x14,%esp
  800aba:	8b 45 10             	mov    0x10(%ebp),%eax
  800abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ac6:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ace:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ad1:	77 55                	ja     800b28 <printnum+0x75>
  800ad3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ad6:	72 05                	jb     800add <printnum+0x2a>
  800ad8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800adb:	77 4b                	ja     800b28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800add:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ae0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ae3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aeb:	52                   	push   %edx
  800aec:	50                   	push   %eax
  800aed:	ff 75 f4             	pushl  -0xc(%ebp)
  800af0:	ff 75 f0             	pushl  -0x10(%ebp)
  800af3:	e8 ac 38 00 00       	call   8043a4 <__udivdi3>
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	ff 75 20             	pushl  0x20(%ebp)
  800b01:	53                   	push   %ebx
  800b02:	ff 75 18             	pushl  0x18(%ebp)
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	ff 75 08             	pushl  0x8(%ebp)
  800b0d:	e8 a1 ff ff ff       	call   800ab3 <printnum>
  800b12:	83 c4 20             	add    $0x20,%esp
  800b15:	eb 1a                	jmp    800b31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 0c             	pushl  0xc(%ebp)
  800b1d:	ff 75 20             	pushl  0x20(%ebp)
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b28:	ff 4d 1c             	decl   0x1c(%ebp)
  800b2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b2f:	7f e6                	jg     800b17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3f:	53                   	push   %ebx
  800b40:	51                   	push   %ecx
  800b41:	52                   	push   %edx
  800b42:	50                   	push   %eax
  800b43:	e8 6c 39 00 00       	call   8044b4 <__umoddi3>
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	05 54 4c 80 00       	add    $0x804c54,%eax
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	0f be c0             	movsbl %al,%eax
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
}
  800b64:	90                   	nop
  800b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b71:	7e 1c                	jle    800b8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 08             	lea    0x8(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 08             	sub    $0x8,%eax
  800b88:	8b 50 04             	mov    0x4(%eax),%edx
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	eb 40                	jmp    800bcf <getuint+0x65>
	else if (lflag)
  800b8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b93:	74 1e                	je     800bb3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	8d 50 04             	lea    0x4(%eax),%edx
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	89 10                	mov    %edx,(%eax)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	83 e8 04             	sub    $0x4,%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	eb 1c                	jmp    800bcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd8:	7e 1c                	jle    800bf6 <getint+0x25>
		return va_arg(*ap, long long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 08             	lea    0x8(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 08             	sub    $0x8,%eax
  800bef:	8b 50 04             	mov    0x4(%eax),%edx
  800bf2:	8b 00                	mov    (%eax),%eax
  800bf4:	eb 38                	jmp    800c2e <getint+0x5d>
	else if (lflag)
  800bf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfa:	74 1a                	je     800c16 <getint+0x45>
		return va_arg(*ap, long);
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	8d 50 04             	lea    0x4(%eax),%edx
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	89 10                	mov    %edx,(%eax)
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	83 e8 04             	sub    $0x4,%eax
  800c11:	8b 00                	mov    (%eax),%eax
  800c13:	99                   	cltd   
  800c14:	eb 18                	jmp    800c2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
}
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c38:	eb 17                	jmp    800c51 <vprintfmt+0x21>
			if (ch == '\0')
  800c3a:	85 db                	test   %ebx,%ebx
  800c3c:	0f 84 c1 03 00 00    	je     801003 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	53                   	push   %ebx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	8d 50 01             	lea    0x1(%eax),%edx
  800c57:	89 55 10             	mov    %edx,0x10(%ebp)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	0f b6 d8             	movzbl %al,%ebx
  800c5f:	83 fb 25             	cmp    $0x25,%ebx
  800c62:	75 d6                	jne    800c3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	8d 50 01             	lea    0x1(%eax),%edx
  800c8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	0f b6 d8             	movzbl %al,%ebx
  800c92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c95:	83 f8 5b             	cmp    $0x5b,%eax
  800c98:	0f 87 3d 03 00 00    	ja     800fdb <vprintfmt+0x3ab>
  800c9e:	8b 04 85 78 4c 80 00 	mov    0x804c78(,%eax,4),%eax
  800ca5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cab:	eb d7                	jmp    800c84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cad:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cb1:	eb d1                	jmp    800c84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cbd:	89 d0                	mov    %edx,%eax
  800cbf:	c1 e0 02             	shl    $0x2,%eax
  800cc2:	01 d0                	add    %edx,%eax
  800cc4:	01 c0                	add    %eax,%eax
  800cc6:	01 d8                	add    %ebx,%eax
  800cc8:	83 e8 30             	sub    $0x30,%eax
  800ccb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd6:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd9:	7e 3e                	jle    800d19 <vprintfmt+0xe9>
  800cdb:	83 fb 39             	cmp    $0x39,%ebx
  800cde:	7f 39                	jg     800d19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce3:	eb d5                	jmp    800cba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	83 c0 04             	add    $0x4,%eax
  800ceb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cee:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf1:	83 e8 04             	sub    $0x4,%eax
  800cf4:	8b 00                	mov    (%eax),%eax
  800cf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf9:	eb 1f                	jmp    800d1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cff:	79 83                	jns    800c84 <vprintfmt+0x54>
				width = 0;
  800d01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d08:	e9 77 ff ff ff       	jmp    800c84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d14:	e9 6b ff ff ff       	jmp    800c84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d1e:	0f 89 60 ff ff ff    	jns    800c84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d31:	e9 4e ff ff ff       	jmp    800c84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d39:	e9 46 ff ff ff       	jmp    800c84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d41:	83 c0 04             	add    $0x4,%eax
  800d44:	89 45 14             	mov    %eax,0x14(%ebp)
  800d47:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4a:	83 e8 04             	sub    $0x4,%eax
  800d4d:	8b 00                	mov    (%eax),%eax
  800d4f:	83 ec 08             	sub    $0x8,%esp
  800d52:	ff 75 0c             	pushl  0xc(%ebp)
  800d55:	50                   	push   %eax
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	ff d0                	call   *%eax
  800d5b:	83 c4 10             	add    $0x10,%esp
			break;
  800d5e:	e9 9b 02 00 00       	jmp    800ffe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d63:	8b 45 14             	mov    0x14(%ebp),%eax
  800d66:	83 c0 04             	add    $0x4,%eax
  800d69:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6f:	83 e8 04             	sub    $0x4,%eax
  800d72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d74:	85 db                	test   %ebx,%ebx
  800d76:	79 02                	jns    800d7a <vprintfmt+0x14a>
				err = -err;
  800d78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d7a:	83 fb 64             	cmp    $0x64,%ebx
  800d7d:	7f 0b                	jg     800d8a <vprintfmt+0x15a>
  800d7f:	8b 34 9d c0 4a 80 00 	mov    0x804ac0(,%ebx,4),%esi
  800d86:	85 f6                	test   %esi,%esi
  800d88:	75 19                	jne    800da3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d8a:	53                   	push   %ebx
  800d8b:	68 65 4c 80 00       	push   $0x804c65
  800d90:	ff 75 0c             	pushl  0xc(%ebp)
  800d93:	ff 75 08             	pushl  0x8(%ebp)
  800d96:	e8 70 02 00 00       	call   80100b <printfmt>
  800d9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d9e:	e9 5b 02 00 00       	jmp    800ffe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800da3:	56                   	push   %esi
  800da4:	68 6e 4c 80 00       	push   $0x804c6e
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 57 02 00 00       	call   80100b <printfmt>
  800db4:	83 c4 10             	add    $0x10,%esp
			break;
  800db7:	e9 42 02 00 00       	jmp    800ffe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbf:	83 c0 04             	add    $0x4,%eax
  800dc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc8:	83 e8 04             	sub    $0x4,%eax
  800dcb:	8b 30                	mov    (%eax),%esi
  800dcd:	85 f6                	test   %esi,%esi
  800dcf:	75 05                	jne    800dd6 <vprintfmt+0x1a6>
				p = "(null)";
  800dd1:	be 71 4c 80 00       	mov    $0x804c71,%esi
			if (width > 0 && padc != '-')
  800dd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dda:	7e 6d                	jle    800e49 <vprintfmt+0x219>
  800ddc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800de0:	74 67                	je     800e49 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	50                   	push   %eax
  800de9:	56                   	push   %esi
  800dea:	e8 26 05 00 00       	call   801315 <strnlen>
  800def:	83 c4 10             	add    $0x10,%esp
  800df2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800df5:	eb 16                	jmp    800e0d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dfb:	83 ec 08             	sub    $0x8,%esp
  800dfe:	ff 75 0c             	pushl  0xc(%ebp)
  800e01:	50                   	push   %eax
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e11:	7f e4                	jg     800df7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e13:	eb 34                	jmp    800e49 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e19:	74 1c                	je     800e37 <vprintfmt+0x207>
  800e1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800e1e:	7e 05                	jle    800e25 <vprintfmt+0x1f5>
  800e20:	83 fb 7e             	cmp    $0x7e,%ebx
  800e23:	7e 12                	jle    800e37 <vprintfmt+0x207>
					putch('?', putdat);
  800e25:	83 ec 08             	sub    $0x8,%esp
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	6a 3f                	push   $0x3f
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
  800e35:	eb 0f                	jmp    800e46 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	ff 75 0c             	pushl  0xc(%ebp)
  800e3d:	53                   	push   %ebx
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	ff d0                	call   *%eax
  800e43:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e46:	ff 4d e4             	decl   -0x1c(%ebp)
  800e49:	89 f0                	mov    %esi,%eax
  800e4b:	8d 70 01             	lea    0x1(%eax),%esi
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	0f be d8             	movsbl %al,%ebx
  800e53:	85 db                	test   %ebx,%ebx
  800e55:	74 24                	je     800e7b <vprintfmt+0x24b>
  800e57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5b:	78 b8                	js     800e15 <vprintfmt+0x1e5>
  800e5d:	ff 4d e0             	decl   -0x20(%ebp)
  800e60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e64:	79 af                	jns    800e15 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e66:	eb 13                	jmp    800e7b <vprintfmt+0x24b>
				putch(' ', putdat);
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	6a 20                	push   $0x20
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	ff d0                	call   *%eax
  800e75:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e78:	ff 4d e4             	decl   -0x1c(%ebp)
  800e7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7f:	7f e7                	jg     800e68 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e81:	e9 78 01 00 00       	jmp    800ffe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8f:	50                   	push   %eax
  800e90:	e8 3c fd ff ff       	call   800bd1 <getint>
  800e95:	83 c4 10             	add    $0x10,%esp
  800e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea4:	85 d2                	test   %edx,%edx
  800ea6:	79 23                	jns    800ecb <vprintfmt+0x29b>
				putch('-', putdat);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	6a 2d                	push   $0x2d
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	ff d0                	call   *%eax
  800eb5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	f7 d8                	neg    %eax
  800ec0:	83 d2 00             	adc    $0x0,%edx
  800ec3:	f7 da                	neg    %edx
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ecb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed2:	e9 bc 00 00 00       	jmp    800f93 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	ff 75 e8             	pushl  -0x18(%ebp)
  800edd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 84 fc ff ff       	call   800b6a <getuint>
  800ee6:	83 c4 10             	add    $0x10,%esp
  800ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800eef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ef6:	e9 98 00 00 00       	jmp    800f93 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800efb:	83 ec 08             	sub    $0x8,%esp
  800efe:	ff 75 0c             	pushl  0xc(%ebp)
  800f01:	6a 58                	push   $0x58
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	ff d0                	call   *%eax
  800f08:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0b:	83 ec 08             	sub    $0x8,%esp
  800f0e:	ff 75 0c             	pushl  0xc(%ebp)
  800f11:	6a 58                	push   $0x58
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	ff d0                	call   *%eax
  800f18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	ff 75 0c             	pushl  0xc(%ebp)
  800f21:	6a 58                	push   $0x58
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	ff d0                	call   *%eax
  800f28:	83 c4 10             	add    $0x10,%esp
			break;
  800f2b:	e9 ce 00 00 00       	jmp    800ffe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	6a 30                	push   $0x30
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	ff d0                	call   *%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f40:	83 ec 08             	sub    $0x8,%esp
  800f43:	ff 75 0c             	pushl  0xc(%ebp)
  800f46:	6a 78                	push   $0x78
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f50:	8b 45 14             	mov    0x14(%ebp),%eax
  800f53:	83 c0 04             	add    $0x4,%eax
  800f56:	89 45 14             	mov    %eax,0x14(%ebp)
  800f59:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5c:	83 e8 04             	sub    $0x4,%eax
  800f5f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f72:	eb 1f                	jmp    800f93 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f7d:	50                   	push   %eax
  800f7e:	e8 e7 fb ff ff       	call   800b6a <getuint>
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f8c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f93:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f9a:	83 ec 04             	sub    $0x4,%esp
  800f9d:	52                   	push   %edx
  800f9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa8:	ff 75 0c             	pushl  0xc(%ebp)
  800fab:	ff 75 08             	pushl  0x8(%ebp)
  800fae:	e8 00 fb ff ff       	call   800ab3 <printnum>
  800fb3:	83 c4 20             	add    $0x20,%esp
			break;
  800fb6:	eb 46                	jmp    800ffe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	53                   	push   %ebx
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	ff d0                	call   *%eax
  800fc4:	83 c4 10             	add    $0x10,%esp
			break;
  800fc7:	eb 35                	jmp    800ffe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800fc9:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  800fd0:	eb 2c                	jmp    800ffe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800fd2:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  800fd9:	eb 23                	jmp    800ffe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fdb:	83 ec 08             	sub    $0x8,%esp
  800fde:	ff 75 0c             	pushl  0xc(%ebp)
  800fe1:	6a 25                	push   $0x25
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	ff d0                	call   *%eax
  800fe8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800feb:	ff 4d 10             	decl   0x10(%ebp)
  800fee:	eb 03                	jmp    800ff3 <vprintfmt+0x3c3>
  800ff0:	ff 4d 10             	decl   0x10(%ebp)
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	48                   	dec    %eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 25                	cmp    $0x25,%al
  800ffb:	75 f3                	jne    800ff0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ffd:	90                   	nop
		}
	}
  800ffe:	e9 35 fc ff ff       	jmp    800c38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801003:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801004:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801011:	8d 45 10             	lea    0x10(%ebp),%eax
  801014:	83 c0 04             	add    $0x4,%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	ff 75 f4             	pushl  -0xc(%ebp)
  801020:	50                   	push   %eax
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	ff 75 08             	pushl  0x8(%ebp)
  801027:	e8 04 fc ff ff       	call   800c30 <vprintfmt>
  80102c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	8b 40 08             	mov    0x8(%eax),%eax
  80103b:	8d 50 01             	lea    0x1(%eax),%edx
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 10                	mov    (%eax),%edx
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	8b 40 04             	mov    0x4(%eax),%eax
  80104f:	39 c2                	cmp    %eax,%edx
  801051:	73 12                	jae    801065 <sprintputch+0x33>
		*b->buf++ = ch;
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	8b 00                	mov    (%eax),%eax
  801058:	8d 48 01             	lea    0x1(%eax),%ecx
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105e:	89 0a                	mov    %ecx,(%edx)
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	88 10                	mov    %dl,(%eax)
}
  801065:	90                   	nop
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	01 d0                	add    %edx,%eax
  80107f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801082:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80108d:	74 06                	je     801095 <vsnprintf+0x2d>
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	7f 07                	jg     80109c <vsnprintf+0x34>
		return -E_INVAL;
  801095:	b8 03 00 00 00       	mov    $0x3,%eax
  80109a:	eb 20                	jmp    8010bc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80109c:	ff 75 14             	pushl  0x14(%ebp)
  80109f:	ff 75 10             	pushl  0x10(%ebp)
  8010a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010a5:	50                   	push   %eax
  8010a6:	68 32 10 80 00       	push   $0x801032
  8010ab:	e8 80 fb ff ff       	call   800c30 <vprintfmt>
  8010b0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010b6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010c4:	8d 45 10             	lea    0x10(%ebp),%eax
  8010c7:	83 c0 04             	add    $0x4,%eax
  8010ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d3:	50                   	push   %eax
  8010d4:	ff 75 0c             	pushl  0xc(%ebp)
  8010d7:	ff 75 08             	pushl  0x8(%ebp)
  8010da:	e8 89 ff ff ff       	call   801068 <vsnprintf>
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    

008010ea <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8010f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f4:	74 13                	je     801109 <readline+0x1f>
		cprintf("%s", prompt);
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	ff 75 08             	pushl  0x8(%ebp)
  8010fc:	68 e8 4d 80 00       	push   $0x804de8
  801101:	e8 0b f9 ff ff       	call   800a11 <cprintf>
  801106:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801109:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801110:	83 ec 0c             	sub    $0xc,%esp
  801113:	6a 00                	push   $0x0
  801115:	e8 6f f4 ff ff       	call   800589 <iscons>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801120:	e8 51 f4 ff ff       	call   800576 <getchar>
  801125:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801128:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80112c:	79 22                	jns    801150 <readline+0x66>
			if (c != -E_EOF)
  80112e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801132:	0f 84 ad 00 00 00    	je     8011e5 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 ec             	pushl  -0x14(%ebp)
  80113e:	68 eb 4d 80 00       	push   $0x804deb
  801143:	e8 c9 f8 ff ff       	call   800a11 <cprintf>
  801148:	83 c4 10             	add    $0x10,%esp
			break;
  80114b:	e9 95 00 00 00       	jmp    8011e5 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801150:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801154:	7e 34                	jle    80118a <readline+0xa0>
  801156:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80115d:	7f 2b                	jg     80118a <readline+0xa0>
			if (echoing)
  80115f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801163:	74 0e                	je     801173 <readline+0x89>
				cputchar(c);
  801165:	83 ec 0c             	sub    $0xc,%esp
  801168:	ff 75 ec             	pushl  -0x14(%ebp)
  80116b:	e8 e7 f3 ff ff       	call   800557 <cputchar>
  801170:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801176:	8d 50 01             	lea    0x1(%eax),%edx
  801179:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80117c:	89 c2                	mov    %eax,%edx
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
  801188:	eb 56                	jmp    8011e0 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80118a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80118e:	75 1f                	jne    8011af <readline+0xc5>
  801190:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801194:	7e 19                	jle    8011af <readline+0xc5>
			if (echoing)
  801196:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80119a:	74 0e                	je     8011aa <readline+0xc0>
				cputchar(c);
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a2:	e8 b0 f3 ff ff       	call   800557 <cputchar>
  8011a7:	83 c4 10             	add    $0x10,%esp

			i--;
  8011aa:	ff 4d f4             	decl   -0xc(%ebp)
  8011ad:	eb 31                	jmp    8011e0 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011af:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011b3:	74 0a                	je     8011bf <readline+0xd5>
  8011b5:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011b9:	0f 85 61 ff ff ff    	jne    801120 <readline+0x36>
			if (echoing)
  8011bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011c3:	74 0e                	je     8011d3 <readline+0xe9>
				cputchar(c);
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8011cb:	e8 87 f3 ff ff       	call   800557 <cputchar>
  8011d0:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8011de:	eb 06                	jmp    8011e6 <readline+0xfc>
		}
	}
  8011e0:	e9 3b ff ff ff       	jmp    801120 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8011e5:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8011ef:	e8 df 21 00 00       	call   8033d3 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f8:	74 13                	je     80120d <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	68 e8 4d 80 00       	push   $0x804de8
  801205:	e8 07 f8 ff ff       	call   800a11 <cprintf>
  80120a:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80120d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801214:	83 ec 0c             	sub    $0xc,%esp
  801217:	6a 00                	push   $0x0
  801219:	e8 6b f3 ff ff       	call   800589 <iscons>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801224:	e8 4d f3 ff ff       	call   800576 <getchar>
  801229:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80122c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801230:	79 22                	jns    801254 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801232:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801236:	0f 84 ad 00 00 00    	je     8012e9 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	ff 75 ec             	pushl  -0x14(%ebp)
  801242:	68 eb 4d 80 00       	push   $0x804deb
  801247:	e8 c5 f7 ff ff       	call   800a11 <cprintf>
  80124c:	83 c4 10             	add    $0x10,%esp
				break;
  80124f:	e9 95 00 00 00       	jmp    8012e9 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801254:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801258:	7e 34                	jle    80128e <atomic_readline+0xa5>
  80125a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801261:	7f 2b                	jg     80128e <atomic_readline+0xa5>
				if (echoing)
  801263:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801267:	74 0e                	je     801277 <atomic_readline+0x8e>
					cputchar(c);
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	ff 75 ec             	pushl  -0x14(%ebp)
  80126f:	e8 e3 f2 ff ff       	call   800557 <cputchar>
  801274:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127a:	8d 50 01             	lea    0x1(%eax),%edx
  80127d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801280:	89 c2                	mov    %eax,%edx
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80128a:	88 10                	mov    %dl,(%eax)
  80128c:	eb 56                	jmp    8012e4 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80128e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801292:	75 1f                	jne    8012b3 <atomic_readline+0xca>
  801294:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801298:	7e 19                	jle    8012b3 <atomic_readline+0xca>
				if (echoing)
  80129a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80129e:	74 0e                	je     8012ae <atomic_readline+0xc5>
					cputchar(c);
  8012a0:	83 ec 0c             	sub    $0xc,%esp
  8012a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a6:	e8 ac f2 ff ff       	call   800557 <cputchar>
  8012ab:	83 c4 10             	add    $0x10,%esp
				i--;
  8012ae:	ff 4d f4             	decl   -0xc(%ebp)
  8012b1:	eb 31                	jmp    8012e4 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012b3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012b7:	74 0a                	je     8012c3 <atomic_readline+0xda>
  8012b9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012bd:	0f 85 61 ff ff ff    	jne    801224 <atomic_readline+0x3b>
				if (echoing)
  8012c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c7:	74 0e                	je     8012d7 <atomic_readline+0xee>
					cputchar(c);
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8012cf:	e8 83 f2 ff ff       	call   800557 <cputchar>
  8012d4:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8012d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	01 d0                	add    %edx,%eax
  8012df:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8012e2:	eb 06                	jmp    8012ea <atomic_readline+0x101>
			}
		}
  8012e4:	e9 3b ff ff ff       	jmp    801224 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8012e9:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8012ea:	e8 fe 20 00 00       	call   8033ed <sys_unlock_cons>
}
  8012ef:	90                   	nop
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ff:	eb 06                	jmp    801307 <strlen+0x15>
		n++;
  801301:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801304:	ff 45 08             	incl   0x8(%ebp)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	84 c0                	test   %al,%al
  80130e:	75 f1                	jne    801301 <strlen+0xf>
		n++;
	return n;
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801322:	eb 09                	jmp    80132d <strnlen+0x18>
		n++;
  801324:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801327:	ff 45 08             	incl   0x8(%ebp)
  80132a:	ff 4d 0c             	decl   0xc(%ebp)
  80132d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801331:	74 09                	je     80133c <strnlen+0x27>
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 e8                	jne    801324 <strnlen+0xf>
		n++;
	return n;
  80133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80134d:	90                   	nop
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801360:	8a 12                	mov    (%edx),%dl
  801362:	88 10                	mov    %dl,(%eax)
  801364:	8a 00                	mov    (%eax),%al
  801366:	84 c0                	test   %al,%al
  801368:	75 e4                	jne    80134e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80136a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80137b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801382:	eb 1f                	jmp    8013a3 <strncpy+0x34>
		*dst++ = *src;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8d 50 01             	lea    0x1(%eax),%edx
  80138a:	89 55 08             	mov    %edx,0x8(%ebp)
  80138d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801390:	8a 12                	mov    (%edx),%dl
  801392:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	84 c0                	test   %al,%al
  80139b:	74 03                	je     8013a0 <strncpy+0x31>
			src++;
  80139d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013a0:	ff 45 fc             	incl   -0x4(%ebp)
  8013a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013a9:	72 d9                	jb     801384 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c0:	74 30                	je     8013f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013c2:	eb 16                	jmp    8013da <strlcpy+0x2a>
			*dst++ = *src++;
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8013cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013d6:	8a 12                	mov    (%edx),%dl
  8013d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013da:	ff 4d 10             	decl   0x10(%ebp)
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	74 09                	je     8013ec <strlcpy+0x3c>
  8013e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	84 c0                	test   %al,%al
  8013ea:	75 d8                	jne    8013c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f8:	29 c2                	sub    %eax,%edx
  8013fa:	89 d0                	mov    %edx,%eax
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801401:	eb 06                	jmp    801409 <strcmp+0xb>
		p++, q++;
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	84 c0                	test   %al,%al
  801410:	74 0e                	je     801420 <strcmp+0x22>
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 10                	mov    (%eax),%dl
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	38 c2                	cmp    %al,%dl
  80141e:	74 e3                	je     801403 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	0f b6 d0             	movzbl %al,%edx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	0f b6 c0             	movzbl %al,%eax
  801430:	29 c2                	sub    %eax,%edx
  801432:	89 d0                	mov    %edx,%eax
}
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    

00801436 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801439:	eb 09                	jmp    801444 <strncmp+0xe>
		n--, p++, q++;
  80143b:	ff 4d 10             	decl   0x10(%ebp)
  80143e:	ff 45 08             	incl   0x8(%ebp)
  801441:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801444:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801448:	74 17                	je     801461 <strncmp+0x2b>
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	84 c0                	test   %al,%al
  801451:	74 0e                	je     801461 <strncmp+0x2b>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 10                	mov    (%eax),%dl
  801458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	38 c2                	cmp    %al,%dl
  80145f:	74 da                	je     80143b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801461:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801465:	75 07                	jne    80146e <strncmp+0x38>
		return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
  80146c:	eb 14                	jmp    801482 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	0f b6 d0             	movzbl %al,%edx
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	0f b6 c0             	movzbl %al,%eax
  80147e:	29 c2                	sub    %eax,%edx
  801480:	89 d0                	mov    %edx,%eax
}
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801490:	eb 12                	jmp    8014a4 <strchr+0x20>
		if (*s == c)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80149a:	75 05                	jne    8014a1 <strchr+0x1d>
			return (char *) s;
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	eb 11                	jmp    8014b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014a1:	ff 45 08             	incl   0x8(%ebp)
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	84 c0                	test   %al,%al
  8014ab:	75 e5                	jne    801492 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014c0:	eb 0d                	jmp    8014cf <strfind+0x1b>
		if (*s == c)
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014ca:	74 0e                	je     8014da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014cc:	ff 45 08             	incl   0x8(%ebp)
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	75 ea                	jne    8014c2 <strfind+0xe>
  8014d8:	eb 01                	jmp    8014db <strfind+0x27>
		if (*s == c)
			break;
  8014da:	90                   	nop
	return (char *) s;
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014ec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014f0:	76 63                	jbe    801555 <memset+0x75>
		uint64 data_block = c;
  8014f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f5:	99                   	cltd   
  8014f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801502:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801506:	c1 e0 08             	shl    $0x8,%eax
  801509:	09 45 f0             	or     %eax,-0x10(%ebp)
  80150c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80150f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801512:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801515:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801519:	c1 e0 10             	shl    $0x10,%eax
  80151c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80151f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801528:	89 c2                	mov    %eax,%edx
  80152a:	b8 00 00 00 00       	mov    $0x0,%eax
  80152f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801532:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801535:	eb 18                	jmp    80154f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801537:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80153a:	8d 41 08             	lea    0x8(%ecx),%eax
  80153d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	89 01                	mov    %eax,(%ecx)
  801548:	89 51 04             	mov    %edx,0x4(%ecx)
  80154b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80154f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801553:	77 e2                	ja     801537 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801555:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801559:	74 23                	je     80157e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80155b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801561:	eb 0e                	jmp    801571 <memset+0x91>
			*p8++ = (uint8)c;
  801563:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801566:	8d 50 01             	lea    0x1(%eax),%edx
  801569:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80156c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801571:	8b 45 10             	mov    0x10(%ebp),%eax
  801574:	8d 50 ff             	lea    -0x1(%eax),%edx
  801577:	89 55 10             	mov    %edx,0x10(%ebp)
  80157a:	85 c0                	test   %eax,%eax
  80157c:	75 e5                	jne    801563 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801595:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801599:	76 24                	jbe    8015bf <memcpy+0x3c>
		while(n >= 8){
  80159b:	eb 1c                	jmp    8015b9 <memcpy+0x36>
			*d64 = *s64;
  80159d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a0:	8b 50 04             	mov    0x4(%eax),%edx
  8015a3:	8b 00                	mov    (%eax),%eax
  8015a5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015a8:	89 01                	mov    %eax,(%ecx)
  8015aa:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015ad:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015b1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015b5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015b9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015bd:	77 de                	ja     80159d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c3:	74 31                	je     8015f6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015d1:	eb 16                	jmp    8015e9 <memcpy+0x66>
			*d8++ = *s8++;
  8015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015e5:	8a 12                	mov    (%edx),%dl
  8015e7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	75 dd                	jne    8015d3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80160d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801610:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801613:	73 50                	jae    801665 <memmove+0x6a>
  801615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801618:	8b 45 10             	mov    0x10(%ebp),%eax
  80161b:	01 d0                	add    %edx,%eax
  80161d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801620:	76 43                	jbe    801665 <memmove+0x6a>
		s += n;
  801622:	8b 45 10             	mov    0x10(%ebp),%eax
  801625:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801628:	8b 45 10             	mov    0x10(%ebp),%eax
  80162b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80162e:	eb 10                	jmp    801640 <memmove+0x45>
			*--d = *--s;
  801630:	ff 4d f8             	decl   -0x8(%ebp)
  801633:	ff 4d fc             	decl   -0x4(%ebp)
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	8a 10                	mov    (%eax),%dl
  80163b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	8d 50 ff             	lea    -0x1(%eax),%edx
  801646:	89 55 10             	mov    %edx,0x10(%ebp)
  801649:	85 c0                	test   %eax,%eax
  80164b:	75 e3                	jne    801630 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80164d:	eb 23                	jmp    801672 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80164f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801658:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801661:	8a 12                	mov    (%edx),%dl
  801663:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801665:	8b 45 10             	mov    0x10(%ebp),%eax
  801668:	8d 50 ff             	lea    -0x1(%eax),%edx
  80166b:	89 55 10             	mov    %edx,0x10(%ebp)
  80166e:	85 c0                	test   %eax,%eax
  801670:	75 dd                	jne    80164f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801689:	eb 2a                	jmp    8016b5 <memcmp+0x3e>
		if (*s1 != *s2)
  80168b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168e:	8a 10                	mov    (%eax),%dl
  801690:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	38 c2                	cmp    %al,%dl
  801697:	74 16                	je     8016af <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801699:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	0f b6 d0             	movzbl %al,%edx
  8016a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	0f b6 c0             	movzbl %al,%eax
  8016a9:	29 c2                	sub    %eax,%edx
  8016ab:	89 d0                	mov    %edx,%eax
  8016ad:	eb 18                	jmp    8016c7 <memcmp+0x50>
		s1++, s2++;
  8016af:	ff 45 fc             	incl   -0x4(%ebp)
  8016b2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	75 c9                	jne    80168b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016da:	eb 15                	jmp    8016f1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	0f b6 d0             	movzbl %al,%edx
  8016e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e7:	0f b6 c0             	movzbl %al,%eax
  8016ea:	39 c2                	cmp    %eax,%edx
  8016ec:	74 0d                	je     8016fb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ee:	ff 45 08             	incl   0x8(%ebp)
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016f7:	72 e3                	jb     8016dc <memfind+0x13>
  8016f9:	eb 01                	jmp    8016fc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016fb:	90                   	nop
	return (void *) s;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801707:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80170e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801715:	eb 03                	jmp    80171a <strtol+0x19>
		s++;
  801717:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 20                	cmp    $0x20,%al
  801721:	74 f4                	je     801717 <strtol+0x16>
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	3c 09                	cmp    $0x9,%al
  80172a:	74 eb                	je     801717 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	3c 2b                	cmp    $0x2b,%al
  801733:	75 05                	jne    80173a <strtol+0x39>
		s++;
  801735:	ff 45 08             	incl   0x8(%ebp)
  801738:	eb 13                	jmp    80174d <strtol+0x4c>
	else if (*s == '-')
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	3c 2d                	cmp    $0x2d,%al
  801741:	75 0a                	jne    80174d <strtol+0x4c>
		s++, neg = 1;
  801743:	ff 45 08             	incl   0x8(%ebp)
  801746:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80174d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801751:	74 06                	je     801759 <strtol+0x58>
  801753:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801757:	75 20                	jne    801779 <strtol+0x78>
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	8a 00                	mov    (%eax),%al
  80175e:	3c 30                	cmp    $0x30,%al
  801760:	75 17                	jne    801779 <strtol+0x78>
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	40                   	inc    %eax
  801766:	8a 00                	mov    (%eax),%al
  801768:	3c 78                	cmp    $0x78,%al
  80176a:	75 0d                	jne    801779 <strtol+0x78>
		s += 2, base = 16;
  80176c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801770:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801777:	eb 28                	jmp    8017a1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801779:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177d:	75 15                	jne    801794 <strtol+0x93>
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 30                	cmp    $0x30,%al
  801786:	75 0c                	jne    801794 <strtol+0x93>
		s++, base = 8;
  801788:	ff 45 08             	incl   0x8(%ebp)
  80178b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801792:	eb 0d                	jmp    8017a1 <strtol+0xa0>
	else if (base == 0)
  801794:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801798:	75 07                	jne    8017a1 <strtol+0xa0>
		base = 10;
  80179a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 2f                	cmp    $0x2f,%al
  8017a8:	7e 19                	jle    8017c3 <strtol+0xc2>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 39                	cmp    $0x39,%al
  8017b1:	7f 10                	jg     8017c3 <strtol+0xc2>
			dig = *s - '0';
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 30             	sub    $0x30,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017c1:	eb 42                	jmp    801805 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	3c 60                	cmp    $0x60,%al
  8017ca:	7e 19                	jle    8017e5 <strtol+0xe4>
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	8a 00                	mov    (%eax),%al
  8017d1:	3c 7a                	cmp    $0x7a,%al
  8017d3:	7f 10                	jg     8017e5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	0f be c0             	movsbl %al,%eax
  8017dd:	83 e8 57             	sub    $0x57,%eax
  8017e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e3:	eb 20                	jmp    801805 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	3c 40                	cmp    $0x40,%al
  8017ec:	7e 39                	jle    801827 <strtol+0x126>
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	8a 00                	mov    (%eax),%al
  8017f3:	3c 5a                	cmp    $0x5a,%al
  8017f5:	7f 30                	jg     801827 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	8a 00                	mov    (%eax),%al
  8017fc:	0f be c0             	movsbl %al,%eax
  8017ff:	83 e8 37             	sub    $0x37,%eax
  801802:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	3b 45 10             	cmp    0x10(%ebp),%eax
  80180b:	7d 19                	jge    801826 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801813:	0f af 45 10          	imul   0x10(%ebp),%eax
  801817:	89 c2                	mov    %eax,%edx
  801819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181c:	01 d0                	add    %edx,%eax
  80181e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801821:	e9 7b ff ff ff       	jmp    8017a1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801826:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801827:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80182b:	74 08                	je     801835 <strtol+0x134>
		*endptr = (char *) s;
  80182d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801830:	8b 55 08             	mov    0x8(%ebp),%edx
  801833:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801835:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801839:	74 07                	je     801842 <strtol+0x141>
  80183b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80183e:	f7 d8                	neg    %eax
  801840:	eb 03                	jmp    801845 <strtol+0x144>
  801842:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <ltostr>:

void
ltostr(long value, char *str)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80184d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801854:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80185b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80185f:	79 13                	jns    801874 <ltostr+0x2d>
	{
		neg = 1;
  801861:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80186e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801871:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80187c:	99                   	cltd   
  80187d:	f7 f9                	idiv   %ecx
  80187f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80188b:	89 c2                	mov    %eax,%edx
  80188d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801890:	01 d0                	add    %edx,%eax
  801892:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801895:	83 c2 30             	add    $0x30,%edx
  801898:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80189a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018a2:	f7 e9                	imul   %ecx
  8018a4:	c1 fa 02             	sar    $0x2,%edx
  8018a7:	89 c8                	mov    %ecx,%eax
  8018a9:	c1 f8 1f             	sar    $0x1f,%eax
  8018ac:	29 c2                	sub    %eax,%edx
  8018ae:	89 d0                	mov    %edx,%eax
  8018b0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018b7:	75 bb                	jne    801874 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c3:	48                   	dec    %eax
  8018c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018cb:	74 3d                	je     80190a <ltostr+0xc3>
		start = 1 ;
  8018cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018d4:	eb 34                	jmp    80190a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dc:	01 d0                	add    %edx,%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e9:	01 c2                	add    %eax,%edx
  8018eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	01 c8                	add    %ecx,%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fd:	01 c2                	add    %eax,%edx
  8018ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801902:	88 02                	mov    %al,(%edx)
		start++ ;
  801904:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801907:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801910:	7c c4                	jl     8018d6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801912:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801915:	8b 45 0c             	mov    0xc(%ebp),%eax
  801918:	01 d0                	add    %edx,%eax
  80191a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80191d:	90                   	nop
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801926:	ff 75 08             	pushl  0x8(%ebp)
  801929:	e8 c4 f9 ff ff       	call   8012f2 <strlen>
  80192e:	83 c4 04             	add    $0x4,%esp
  801931:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	e8 b6 f9 ff ff       	call   8012f2 <strlen>
  80193c:	83 c4 04             	add    $0x4,%esp
  80193f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801942:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801949:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801950:	eb 17                	jmp    801969 <strcconcat+0x49>
		final[s] = str1[s] ;
  801952:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	01 c2                	add    %eax,%edx
  80195a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	01 c8                	add    %ecx,%eax
  801962:	8a 00                	mov    (%eax),%al
  801964:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801966:	ff 45 fc             	incl   -0x4(%ebp)
  801969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80196f:	7c e1                	jl     801952 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801971:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801978:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80197f:	eb 1f                	jmp    8019a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801984:	8d 50 01             	lea    0x1(%eax),%edx
  801987:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80198a:	89 c2                	mov    %eax,%edx
  80198c:	8b 45 10             	mov    0x10(%ebp),%eax
  80198f:	01 c2                	add    %eax,%edx
  801991:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 c8                	add    %ecx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80199d:	ff 45 f8             	incl   -0x8(%ebp)
  8019a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a6:	7c d9                	jl     801981 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ae:	01 d0                	add    %edx,%eax
  8019b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c5:	8b 00                	mov    (%eax),%eax
  8019c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d1:	01 d0                	add    %edx,%eax
  8019d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d9:	eb 0c                	jmp    8019e7 <strsplit+0x31>
			*string++ = 0;
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	8d 50 01             	lea    0x1(%eax),%edx
  8019e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8019e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	8a 00                	mov    (%eax),%al
  8019ec:	84 c0                	test   %al,%al
  8019ee:	74 18                	je     801a08 <strsplit+0x52>
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	0f be c0             	movsbl %al,%eax
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	e8 83 fa ff ff       	call   801484 <strchr>
  801a01:	83 c4 08             	add    $0x8,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	75 d3                	jne    8019db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	84 c0                	test   %al,%al
  801a0f:	74 5a                	je     801a6b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a11:	8b 45 14             	mov    0x14(%ebp),%eax
  801a14:	8b 00                	mov    (%eax),%eax
  801a16:	83 f8 0f             	cmp    $0xf,%eax
  801a19:	75 07                	jne    801a22 <strsplit+0x6c>
		{
			return 0;
  801a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a20:	eb 66                	jmp    801a88 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	8b 00                	mov    (%eax),%eax
  801a27:	8d 48 01             	lea    0x1(%eax),%ecx
  801a2a:	8b 55 14             	mov    0x14(%ebp),%edx
  801a2d:	89 0a                	mov    %ecx,(%edx)
  801a2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a36:	8b 45 10             	mov    0x10(%ebp),%eax
  801a39:	01 c2                	add    %eax,%edx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a40:	eb 03                	jmp    801a45 <strsplit+0x8f>
			string++;
  801a42:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	8a 00                	mov    (%eax),%al
  801a4a:	84 c0                	test   %al,%al
  801a4c:	74 8b                	je     8019d9 <strsplit+0x23>
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	8a 00                	mov    (%eax),%al
  801a53:	0f be c0             	movsbl %al,%eax
  801a56:	50                   	push   %eax
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	e8 25 fa ff ff       	call   801484 <strchr>
  801a5f:	83 c4 08             	add    $0x8,%esp
  801a62:	85 c0                	test   %eax,%eax
  801a64:	74 dc                	je     801a42 <strsplit+0x8c>
			string++;
	}
  801a66:	e9 6e ff ff ff       	jmp    8019d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a6b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6f:	8b 00                	mov    (%eax),%eax
  801a71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a78:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7b:	01 d0                	add    %edx,%eax
  801a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a83:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a9d:	eb 4a                	jmp    801ae9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	01 c2                	add    %eax,%edx
  801aa7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aad:	01 c8                	add    %ecx,%eax
  801aaf:	8a 00                	mov    (%eax),%al
  801ab1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ab3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab9:	01 d0                	add    %edx,%eax
  801abb:	8a 00                	mov    (%eax),%al
  801abd:	3c 40                	cmp    $0x40,%al
  801abf:	7e 25                	jle    801ae6 <str2lower+0x5c>
  801ac1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac7:	01 d0                	add    %edx,%eax
  801ac9:	8a 00                	mov    (%eax),%al
  801acb:	3c 5a                	cmp    $0x5a,%al
  801acd:	7f 17                	jg     801ae6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801acf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	01 d0                	add    %edx,%eax
  801ad7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ada:	8b 55 08             	mov    0x8(%ebp),%edx
  801add:	01 ca                	add    %ecx,%edx
  801adf:	8a 12                	mov    (%edx),%dl
  801ae1:	83 c2 20             	add    $0x20,%edx
  801ae4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ae6:	ff 45 fc             	incl   -0x4(%ebp)
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	e8 01 f8 ff ff       	call   8012f2 <strlen>
  801af1:	83 c4 04             	add    $0x4,%esp
  801af4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801af7:	7f a6                	jg     801a9f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b04:	a1 08 60 80 00       	mov    0x806008,%eax
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	74 42                	je     801b4f <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	68 00 00 00 82       	push   $0x82000000
  801b15:	68 00 00 00 80       	push   $0x80000000
  801b1a:	e8 b0 1e 00 00       	call   8039cf <initialize_dynamic_allocator>
  801b1f:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b22:	e8 96 1c 00 00       	call   8037bd <sys_get_uheap_strategy>
  801b27:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b2c:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801b31:	05 00 10 00 00       	add    $0x1000,%eax
  801b36:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801b3b:	a1 30 61 83 00       	mov    0x836130,%eax
  801b40:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801b45:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801b4c:	00 00 00 
	}
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b66:	83 ec 08             	sub    $0x8,%esp
  801b69:	68 06 04 00 00       	push   $0x406
  801b6e:	50                   	push   %eax
  801b6f:	e8 93 18 00 00       	call   803407 <__sys_allocate_page>
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b7e:	79 14                	jns    801b94 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	68 fc 4d 80 00       	push   $0x804dfc
  801b88:	6a 1f                	push   $0x1f
  801b8a:	68 38 4e 80 00       	push   $0x804e38
  801b8f:	e8 af eb ff ff       	call   800743 <_panic>
	return 0;
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	50                   	push   %eax
  801bb3:	e8 96 18 00 00       	call   80344e <__sys_unmap_frame>
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bc2:	79 14                	jns    801bd8 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	68 44 4e 80 00       	push   $0x804e44
  801bcc:	6a 2a                	push   $0x2a
  801bce:	68 38 4e 80 00       	push   $0x804e38
  801bd3:	e8 6b eb ff ff       	call   800743 <_panic>
}
  801bd8:	90                   	nop
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801be1:	e8 18 ff ff ff       	call   801afe <uheap_init>
	if (size == 0) return NULL ;
  801be6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bea:	75 0a                	jne    801bf6 <malloc+0x1b>
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf1:	e9 43 03 00 00       	jmp    801f39 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801bf6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801bfd:	77 13                	ja     801c12 <malloc+0x37>
    {
        return alloc_block(size);
  801bff:	83 ec 0c             	sub    $0xc,%esp
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 78 20 00 00       	call   803c82 <alloc_block>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	e9 27 03 00 00       	jmp    801f39 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801c12:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c19:	8b 55 08             	mov    0x8(%ebp),%edx
  801c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c1f:	01 d0                	add    %edx,%eax
  801c21:	48                   	dec    %eax
  801c22:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c28:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2d:	f7 75 dc             	divl   -0x24(%ebp)
  801c30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c33:	29 d0                	sub    %edx,%eax
  801c35:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801c38:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	75 0a                	jne    801c4b <malloc+0x70>
    {
        uhp_inited = 1;
  801c41:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801c48:	00 00 00 
    }

    int exactIdx = -1;
  801c4b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801c52:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801c59:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c60:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801c67:	e9 85 00 00 00       	jmp    801cf1 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801c6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c6f:	89 d0                	mov    %edx,%eax
  801c71:	01 c0                	add    %eax,%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c1 e0 02             	shl    $0x2,%eax
  801c78:	05 48 20 81 00       	add    $0x812048,%eax
  801c7d:	8a 00                	mov    (%eax),%al
  801c7f:	84 c0                	test   %al,%al
  801c81:	74 20                	je     801ca3 <malloc+0xc8>
  801c83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c86:	89 d0                	mov    %edx,%eax
  801c88:	01 c0                	add    %eax,%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c1 e0 02             	shl    $0x2,%eax
  801c8f:	05 44 20 81 00       	add    $0x812044,%eax
  801c94:	8b 00                	mov    (%eax),%eax
  801c96:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c99:	75 08                	jne    801ca3 <malloc+0xc8>
        {
            exactIdx = i;
  801c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801ca1:	eb 5b                	jmp    801cfe <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801ca3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	01 c0                	add    %eax,%eax
  801caa:	01 d0                	add    %edx,%eax
  801cac:	c1 e0 02             	shl    $0x2,%eax
  801caf:	05 48 20 81 00       	add    $0x812048,%eax
  801cb4:	8a 00                	mov    (%eax),%al
  801cb6:	84 c0                	test   %al,%al
  801cb8:	74 34                	je     801cee <malloc+0x113>
  801cba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cbd:	89 d0                	mov    %edx,%eax
  801cbf:	01 c0                	add    %eax,%eax
  801cc1:	01 d0                	add    %edx,%eax
  801cc3:	c1 e0 02             	shl    $0x2,%eax
  801cc6:	05 44 20 81 00       	add    $0x812044,%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801cd0:	76 1c                	jbe    801cee <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801cd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cd5:	89 d0                	mov    %edx,%eax
  801cd7:	01 c0                	add    %eax,%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c1 e0 02             	shl    $0x2,%eax
  801cde:	05 44 20 81 00       	add    $0x812044,%eax
  801ce3:	8b 00                	mov    (%eax),%eax
  801ce5:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cee:	ff 45 e8             	incl   -0x18(%ebp)
  801cf1:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801cf8:	0f 8e 6e ff ff ff    	jle    801c6c <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801cfe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801d05:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801d09:	74 7d                	je     801d88 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801d0b:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d15:	89 d0                	mov    %edx,%eax
  801d17:	01 c0                	add    %eax,%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	c1 e0 02             	shl    $0x2,%eax
  801d1e:	05 40 20 81 00       	add    $0x812040,%eax
  801d23:	8b 10                	mov    (%eax),%edx
  801d25:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d28:	01 d0                	add    %edx,%eax
  801d2a:	48                   	dec    %eax
  801d2b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d2e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d31:	ba 00 00 00 00       	mov    $0x0,%edx
  801d36:	f7 75 bc             	divl   -0x44(%ebp)
  801d39:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d3c:	29 d0                	sub    %edx,%eax
  801d3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d44:	89 d0                	mov    %edx,%eax
  801d46:	01 c0                	add    %eax,%eax
  801d48:	01 d0                	add    %edx,%eax
  801d4a:	c1 e0 02             	shl    $0x2,%eax
  801d4d:	05 48 20 81 00       	add    $0x812048,%eax
  801d52:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d58:	89 d0                	mov    %edx,%eax
  801d5a:	01 c0                	add    %eax,%eax
  801d5c:	01 d0                	add    %edx,%eax
  801d5e:	c1 e0 02             	shl    $0x2,%eax
  801d61:	05 44 20 81 00       	add    $0x812044,%eax
  801d66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6f:	89 d0                	mov    %edx,%eax
  801d71:	01 c0                	add    %eax,%eax
  801d73:	01 d0                	add    %edx,%eax
  801d75:	c1 e0 02             	shl    $0x2,%eax
  801d78:	05 40 20 81 00       	add    $0x812040,%eax
  801d7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d83:	e9 2d 01 00 00       	jmp    801eb5 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801d88:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d8c:	0f 84 ce 00 00 00    	je     801e60 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801d92:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801d99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d9c:	89 d0                	mov    %edx,%eax
  801d9e:	01 c0                	add    %eax,%eax
  801da0:	01 d0                	add    %edx,%eax
  801da2:	c1 e0 02             	shl    $0x2,%eax
  801da5:	05 40 20 81 00       	add    $0x812040,%eax
  801daa:	8b 10                	mov    (%eax),%edx
  801dac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801daf:	01 d0                	add    %edx,%eax
  801db1:	48                   	dec    %eax
  801db2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801db5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801db8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbd:	f7 75 c4             	divl   -0x3c(%ebp)
  801dc0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dc3:	29 d0                	sub    %edx,%eax
  801dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	01 c0                	add    %eax,%eax
  801dcf:	01 d0                	add    %edx,%eax
  801dd1:	c1 e0 02             	shl    $0x2,%eax
  801dd4:	05 44 20 81 00       	add    $0x812044,%eax
  801dd9:	8b 00                	mov    (%eax),%eax
  801ddb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801dde:	75 47                	jne    801e27 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801de0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801de3:	89 d0                	mov    %edx,%eax
  801de5:	01 c0                	add    %eax,%eax
  801de7:	01 d0                	add    %edx,%eax
  801de9:	c1 e0 02             	shl    $0x2,%eax
  801dec:	05 48 20 81 00       	add    $0x812048,%eax
  801df1:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801df4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801df7:	89 d0                	mov    %edx,%eax
  801df9:	01 c0                	add    %eax,%eax
  801dfb:	01 d0                	add    %edx,%eax
  801dfd:	c1 e0 02             	shl    $0x2,%eax
  801e00:	05 44 20 81 00       	add    $0x812044,%eax
  801e05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801e0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	01 c0                	add    %eax,%eax
  801e12:	01 d0                	add    %edx,%eax
  801e14:	c1 e0 02             	shl    $0x2,%eax
  801e17:	05 40 20 81 00       	add    $0x812040,%eax
  801e1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e22:	e9 8e 00 00 00       	jmp    801eb5 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801e27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e2d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e33:	89 d0                	mov    %edx,%eax
  801e35:	01 c0                	add    %eax,%eax
  801e37:	01 d0                	add    %edx,%eax
  801e39:	c1 e0 02             	shl    $0x2,%eax
  801e3c:	05 40 20 81 00       	add    $0x812040,%eax
  801e41:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e46:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e49:	89 c2                	mov    %eax,%edx
  801e4b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e4e:	89 c8                	mov    %ecx,%eax
  801e50:	01 c0                	add    %eax,%eax
  801e52:	01 c8                	add    %ecx,%eax
  801e54:	c1 e0 02             	shl    $0x2,%eax
  801e57:	05 44 20 81 00       	add    $0x812044,%eax
  801e5c:	89 10                	mov    %edx,(%eax)
  801e5e:	eb 55                	jmp    801eb5 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801e60:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e67:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801e6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e70:	01 d0                	add    %edx,%eax
  801e72:	48                   	dec    %eax
  801e73:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e79:	ba 00 00 00 00       	mov    $0x0,%edx
  801e7e:	f7 75 d0             	divl   -0x30(%ebp)
  801e81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e84:	29 d0                	sub    %edx,%eax
  801e86:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801e89:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801e8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8f:	01 d0                	add    %edx,%eax
  801e91:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801e96:	76 0a                	jbe    801ea2 <malloc+0x2c7>
            return NULL;
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9d:	e9 97 00 00 00       	jmp    801f39 <malloc+0x35e>
        va = start;
  801ea2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ea5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801ea8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801eab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801eae:	01 d0                	add    %edx,%eax
  801eb0:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801eb5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ebc:	eb 5e                	jmp    801f1c <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801ebe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ec1:	89 d0                	mov    %edx,%eax
  801ec3:	01 c0                	add    %eax,%eax
  801ec5:	01 d0                	add    %edx,%eax
  801ec7:	c1 e0 02             	shl    $0x2,%eax
  801eca:	05 48 60 80 00       	add    $0x806048,%eax
  801ecf:	8a 00                	mov    (%eax),%al
  801ed1:	84 c0                	test   %al,%al
  801ed3:	75 44                	jne    801f19 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801ed5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ed8:	89 d0                	mov    %edx,%eax
  801eda:	01 c0                	add    %eax,%eax
  801edc:	01 d0                	add    %edx,%eax
  801ede:	c1 e0 02             	shl    $0x2,%eax
  801ee1:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eea:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801eec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	01 c0                	add    %eax,%eax
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	c1 e0 02             	shl    $0x2,%eax
  801ef8:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801efe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f01:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801f03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	01 c0                	add    %eax,%eax
  801f0a:	01 d0                	add    %edx,%eax
  801f0c:	c1 e0 02             	shl    $0x2,%eax
  801f0f:	05 48 60 80 00       	add    $0x806048,%eax
  801f14:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801f17:	eb 0c                	jmp    801f25 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f19:	ff 45 e0             	incl   -0x20(%ebp)
  801f1c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f23:	7e 99                	jle    801ebe <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801f25:	83 ec 08             	sub    $0x8,%esp
  801f28:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f2b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f2e:	e8 a2 19 00 00       	call   8038d5 <sys_allocate_user_mem>
  801f33:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801f41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f45:	0f 84 fa 03 00 00    	je     802345 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801f51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f54:	85 c0                	test   %eax,%eax
  801f56:	79 1c                	jns    801f74 <free+0x39>
  801f58:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801f5f:	77 13                	ja     801f74 <free+0x39>
    {
        free_block(virtual_address);
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	e8 09 21 00 00       	call   804075 <free_block>
  801f6c:	83 c4 10             	add    $0x10,%esp
        return;
  801f6f:	e9 d2 03 00 00       	jmp    802346 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801f74:	a1 30 61 83 00       	mov    0x836130,%eax
  801f79:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801f7c:	72 09                	jb     801f87 <free+0x4c>
  801f7e:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801f85:	76 17                	jbe    801f9e <free+0x63>
        panic("free: invalid address");
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	68 81 4e 80 00       	push   $0x804e81
  801f8f:	68 9b 00 00 00       	push   $0x9b
  801f94:	68 38 4e 80 00       	push   $0x804e38
  801f99:	e8 a5 e7 ff ff       	call   800743 <_panic>

    uint32 size = 0;
  801f9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801fa5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801fb3:	eb 50                	jmp    802005 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801fb5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fb8:	89 d0                	mov    %edx,%eax
  801fba:	01 c0                	add    %eax,%eax
  801fbc:	01 d0                	add    %edx,%eax
  801fbe:	c1 e0 02             	shl    $0x2,%eax
  801fc1:	05 48 60 80 00       	add    $0x806048,%eax
  801fc6:	8a 00                	mov    (%eax),%al
  801fc8:	84 c0                	test   %al,%al
  801fca:	74 36                	je     802002 <free+0xc7>
  801fcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fcf:	89 d0                	mov    %edx,%eax
  801fd1:	01 c0                	add    %eax,%eax
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	c1 e0 02             	shl    $0x2,%eax
  801fd8:	05 40 60 80 00       	add    $0x806040,%eax
  801fdd:	8b 00                	mov    (%eax),%eax
  801fdf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fe2:	75 1e                	jne    802002 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801fe4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fe7:	89 d0                	mov    %edx,%eax
  801fe9:	01 c0                	add    %eax,%eax
  801feb:	01 d0                	add    %edx,%eax
  801fed:	c1 e0 02             	shl    $0x2,%eax
  801ff0:	05 44 60 80 00       	add    $0x806044,%eax
  801ff5:	8b 00                	mov    (%eax),%eax
  801ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  802000:	eb 0c                	jmp    80200e <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802002:	ff 45 ec             	incl   -0x14(%ebp)
  802005:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80200c:	7e a7                	jle    801fb5 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  80200e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802012:	74 06                	je     80201a <free+0xdf>
  802014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802018:	75 17                	jne    802031 <free+0xf6>
        panic("free: unknown block");
  80201a:	83 ec 04             	sub    $0x4,%esp
  80201d:	68 97 4e 80 00       	push   $0x804e97
  802022:	68 a9 00 00 00       	push   $0xa9
  802027:	68 38 4e 80 00       	push   $0x804e38
  80202c:	e8 12 e7 ff ff       	call   800743 <_panic>

    uhp_allocs[idx].used = 0;
  802031:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802034:	89 d0                	mov    %edx,%eax
  802036:	01 c0                	add    %eax,%eax
  802038:	01 d0                	add    %edx,%eax
  80203a:	c1 e0 02             	shl    $0x2,%eax
  80203d:	05 48 60 80 00       	add    $0x806048,%eax
  802042:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  802045:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80204c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802053:	eb 64                	jmp    8020b9 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  802055:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802058:	89 d0                	mov    %edx,%eax
  80205a:	01 c0                	add    %eax,%eax
  80205c:	01 d0                	add    %edx,%eax
  80205e:	c1 e0 02             	shl    $0x2,%eax
  802061:	05 48 20 81 00       	add    $0x812048,%eax
  802066:	8a 00                	mov    (%eax),%al
  802068:	84 c0                	test   %al,%al
  80206a:	75 4a                	jne    8020b6 <free+0x17b>
        {
            uhp_frees[i].va = va;
  80206c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80206f:	89 d0                	mov    %edx,%eax
  802071:	01 c0                	add    %eax,%eax
  802073:	01 d0                	add    %edx,%eax
  802075:	c1 e0 02             	shl    $0x2,%eax
  802078:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  80207e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802081:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802083:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802086:	89 d0                	mov    %edx,%eax
  802088:	01 c0                	add    %eax,%eax
  80208a:	01 d0                	add    %edx,%eax
  80208c:	c1 e0 02             	shl    $0x2,%eax
  80208f:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802098:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  80209a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80209d:	89 d0                	mov    %edx,%eax
  80209f:	01 c0                	add    %eax,%eax
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	c1 e0 02             	shl    $0x2,%eax
  8020a6:	05 48 20 81 00       	add    $0x812048,%eax
  8020ab:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  8020ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  8020b4:	eb 0c                	jmp    8020c2 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020b6:	ff 45 e4             	incl   -0x1c(%ebp)
  8020b9:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8020c0:	7e 93                	jle    802055 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  8020c2:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8020c6:	0f 84 f1 01 00 00    	je     8022bd <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020d3:	e9 d8 01 00 00       	jmp    8022b0 <free+0x375>
        {
            if (i == fidx) continue;
  8020d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020db:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020de:	0f 84 c8 01 00 00    	je     8022ac <free+0x371>
            if (uhp_frees[i].free)
  8020e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020e7:	89 d0                	mov    %edx,%eax
  8020e9:	01 c0                	add    %eax,%eax
  8020eb:	01 d0                	add    %edx,%eax
  8020ed:	c1 e0 02             	shl    $0x2,%eax
  8020f0:	05 48 20 81 00       	add    $0x812048,%eax
  8020f5:	8a 00                	mov    (%eax),%al
  8020f7:	84 c0                	test   %al,%al
  8020f9:	0f 84 ae 01 00 00    	je     8022ad <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  8020ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802102:	89 d0                	mov    %edx,%eax
  802104:	01 c0                	add    %eax,%eax
  802106:	01 d0                	add    %edx,%eax
  802108:	c1 e0 02             	shl    $0x2,%eax
  80210b:	05 40 20 81 00       	add    $0x812040,%eax
  802110:	8b 08                	mov    (%eax),%ecx
  802112:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802115:	89 d0                	mov    %edx,%eax
  802117:	01 c0                	add    %eax,%eax
  802119:	01 d0                	add    %edx,%eax
  80211b:	c1 e0 02             	shl    $0x2,%eax
  80211e:	05 44 20 81 00       	add    $0x812044,%eax
  802123:	8b 00                	mov    (%eax),%eax
  802125:	01 c1                	add    %eax,%ecx
  802127:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80212a:	89 d0                	mov    %edx,%eax
  80212c:	01 c0                	add    %eax,%eax
  80212e:	01 d0                	add    %edx,%eax
  802130:	c1 e0 02             	shl    $0x2,%eax
  802133:	05 40 20 81 00       	add    $0x812040,%eax
  802138:	8b 00                	mov    (%eax),%eax
  80213a:	39 c1                	cmp    %eax,%ecx
  80213c:	0f 85 a8 00 00 00    	jne    8021ea <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802142:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802145:	89 d0                	mov    %edx,%eax
  802147:	01 c0                	add    %eax,%eax
  802149:	01 d0                	add    %edx,%eax
  80214b:	c1 e0 02             	shl    $0x2,%eax
  80214e:	05 40 20 81 00       	add    $0x812040,%eax
  802153:	8b 10                	mov    (%eax),%edx
  802155:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802158:	89 c8                	mov    %ecx,%eax
  80215a:	01 c0                	add    %eax,%eax
  80215c:	01 c8                	add    %ecx,%eax
  80215e:	c1 e0 02             	shl    $0x2,%eax
  802161:	05 40 20 81 00       	add    $0x812040,%eax
  802166:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802168:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80216b:	89 d0                	mov    %edx,%eax
  80216d:	01 c0                	add    %eax,%eax
  80216f:	01 d0                	add    %edx,%eax
  802171:	c1 e0 02             	shl    $0x2,%eax
  802174:	05 44 20 81 00       	add    $0x812044,%eax
  802179:	8b 08                	mov    (%eax),%ecx
  80217b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80217e:	89 d0                	mov    %edx,%eax
  802180:	01 c0                	add    %eax,%eax
  802182:	01 d0                	add    %edx,%eax
  802184:	c1 e0 02             	shl    $0x2,%eax
  802187:	05 44 20 81 00       	add    $0x812044,%eax
  80218c:	8b 00                	mov    (%eax),%eax
  80218e:	01 c1                	add    %eax,%ecx
  802190:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802193:	89 d0                	mov    %edx,%eax
  802195:	01 c0                	add    %eax,%eax
  802197:	01 d0                	add    %edx,%eax
  802199:	c1 e0 02             	shl    $0x2,%eax
  80219c:	05 44 20 81 00       	add    $0x812044,%eax
  8021a1:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8021a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021a6:	89 d0                	mov    %edx,%eax
  8021a8:	01 c0                	add    %eax,%eax
  8021aa:	01 d0                	add    %edx,%eax
  8021ac:	c1 e0 02             	shl    $0x2,%eax
  8021af:	05 48 20 81 00       	add    $0x812048,%eax
  8021b4:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8021b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021ba:	89 d0                	mov    %edx,%eax
  8021bc:	01 c0                	add    %eax,%eax
  8021be:	01 d0                	add    %edx,%eax
  8021c0:	c1 e0 02             	shl    $0x2,%eax
  8021c3:	05 40 20 81 00       	add    $0x812040,%eax
  8021c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8021ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021d1:	89 d0                	mov    %edx,%eax
  8021d3:	01 c0                	add    %eax,%eax
  8021d5:	01 d0                	add    %edx,%eax
  8021d7:	c1 e0 02             	shl    $0x2,%eax
  8021da:	05 44 20 81 00       	add    $0x812044,%eax
  8021df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021e5:	e9 c3 00 00 00       	jmp    8022ad <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  8021ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021ed:	89 d0                	mov    %edx,%eax
  8021ef:	01 c0                	add    %eax,%eax
  8021f1:	01 d0                	add    %edx,%eax
  8021f3:	c1 e0 02             	shl    $0x2,%eax
  8021f6:	05 40 20 81 00       	add    $0x812040,%eax
  8021fb:	8b 08                	mov    (%eax),%ecx
  8021fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802200:	89 d0                	mov    %edx,%eax
  802202:	01 c0                	add    %eax,%eax
  802204:	01 d0                	add    %edx,%eax
  802206:	c1 e0 02             	shl    $0x2,%eax
  802209:	05 44 20 81 00       	add    $0x812044,%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	01 c1                	add    %eax,%ecx
  802212:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802215:	89 d0                	mov    %edx,%eax
  802217:	01 c0                	add    %eax,%eax
  802219:	01 d0                	add    %edx,%eax
  80221b:	c1 e0 02             	shl    $0x2,%eax
  80221e:	05 40 20 81 00       	add    $0x812040,%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	39 c1                	cmp    %eax,%ecx
  802227:	0f 85 80 00 00 00    	jne    8022ad <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80222d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802230:	89 d0                	mov    %edx,%eax
  802232:	01 c0                	add    %eax,%eax
  802234:	01 d0                	add    %edx,%eax
  802236:	c1 e0 02             	shl    $0x2,%eax
  802239:	05 44 20 81 00       	add    $0x812044,%eax
  80223e:	8b 08                	mov    (%eax),%ecx
  802240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802243:	89 d0                	mov    %edx,%eax
  802245:	01 c0                	add    %eax,%eax
  802247:	01 d0                	add    %edx,%eax
  802249:	c1 e0 02             	shl    $0x2,%eax
  80224c:	05 44 20 81 00       	add    $0x812044,%eax
  802251:	8b 00                	mov    (%eax),%eax
  802253:	01 c1                	add    %eax,%ecx
  802255:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802258:	89 d0                	mov    %edx,%eax
  80225a:	01 c0                	add    %eax,%eax
  80225c:	01 d0                	add    %edx,%eax
  80225e:	c1 e0 02             	shl    $0x2,%eax
  802261:	05 44 20 81 00       	add    $0x812044,%eax
  802266:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802268:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80226b:	89 d0                	mov    %edx,%eax
  80226d:	01 c0                	add    %eax,%eax
  80226f:	01 d0                	add    %edx,%eax
  802271:	c1 e0 02             	shl    $0x2,%eax
  802274:	05 48 20 81 00       	add    $0x812048,%eax
  802279:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80227c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80227f:	89 d0                	mov    %edx,%eax
  802281:	01 c0                	add    %eax,%eax
  802283:	01 d0                	add    %edx,%eax
  802285:	c1 e0 02             	shl    $0x2,%eax
  802288:	05 40 20 81 00       	add    $0x812040,%eax
  80228d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802293:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802296:	89 d0                	mov    %edx,%eax
  802298:	01 c0                	add    %eax,%eax
  80229a:	01 d0                	add    %edx,%eax
  80229c:	c1 e0 02             	shl    $0x2,%eax
  80229f:	05 44 20 81 00       	add    $0x812044,%eax
  8022a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022aa:	eb 01                	jmp    8022ad <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  8022ac:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022ad:	ff 45 e0             	incl   -0x20(%ebp)
  8022b0:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8022b7:	0f 8e 1b fe ff ff    	jle    8020d8 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  8022bd:	a1 30 61 83 00       	mov    0x836130,%eax
  8022c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022c5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8022cc:	eb 53                	jmp    802321 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  8022ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022d1:	89 d0                	mov    %edx,%eax
  8022d3:	01 c0                	add    %eax,%eax
  8022d5:	01 d0                	add    %edx,%eax
  8022d7:	c1 e0 02             	shl    $0x2,%eax
  8022da:	05 48 60 80 00       	add    $0x806048,%eax
  8022df:	8a 00                	mov    (%eax),%al
  8022e1:	84 c0                	test   %al,%al
  8022e3:	74 39                	je     80231e <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  8022e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022e8:	89 d0                	mov    %edx,%eax
  8022ea:	01 c0                	add    %eax,%eax
  8022ec:	01 d0                	add    %edx,%eax
  8022ee:	c1 e0 02             	shl    $0x2,%eax
  8022f1:	05 40 60 80 00       	add    $0x806040,%eax
  8022f6:	8b 08                	mov    (%eax),%ecx
  8022f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022fb:	89 d0                	mov    %edx,%eax
  8022fd:	01 c0                	add    %eax,%eax
  8022ff:	01 d0                	add    %edx,%eax
  802301:	c1 e0 02             	shl    $0x2,%eax
  802304:	05 44 60 80 00       	add    $0x806044,%eax
  802309:	8b 00                	mov    (%eax),%eax
  80230b:	01 c8                	add    %ecx,%eax
  80230d:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  802310:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802313:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802316:	76 06                	jbe    80231e <free+0x3e3>
  802318:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80231b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80231e:	ff 45 d8             	incl   -0x28(%ebp)
  802321:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802328:	7e a4                	jle    8022ce <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  80232a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80232d:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  802332:	83 ec 08             	sub    $0x8,%esp
  802335:	ff 75 f4             	pushl  -0xc(%ebp)
  802338:	ff 75 d4             	pushl  -0x2c(%ebp)
  80233b:	e8 79 15 00 00       	call   8038b9 <sys_free_user_mem>
  802340:	83 c4 10             	add    $0x10,%esp
  802343:	eb 01                	jmp    802346 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802345:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	83 ec 68             	sub    $0x68,%esp
  80234e:	8b 45 10             	mov    0x10(%ebp),%eax
  802351:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802354:	e8 a5 f7 ff ff       	call   801afe <uheap_init>
	if (size == 0) return NULL ;
  802359:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80235d:	75 0a                	jne    802369 <smalloc+0x21>
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
  802364:	e9 37 03 00 00       	jmp    8026a0 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802369:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802370:	8b 55 0c             	mov    0xc(%ebp),%edx
  802373:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802376:	01 d0                	add    %edx,%eax
  802378:	48                   	dec    %eax
  802379:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80237c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80237f:	ba 00 00 00 00       	mov    $0x0,%edx
  802384:	f7 75 dc             	divl   -0x24(%ebp)
  802387:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80238a:	29 d0                	sub    %edx,%eax
  80238c:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  80238f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802396:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80239d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8023a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8023ab:	e9 85 00 00 00       	jmp    802435 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8023b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023b3:	89 d0                	mov    %edx,%eax
  8023b5:	01 c0                	add    %eax,%eax
  8023b7:	01 d0                	add    %edx,%eax
  8023b9:	c1 e0 02             	shl    $0x2,%eax
  8023bc:	05 48 20 81 00       	add    $0x812048,%eax
  8023c1:	8a 00                	mov    (%eax),%al
  8023c3:	84 c0                	test   %al,%al
  8023c5:	74 20                	je     8023e7 <smalloc+0x9f>
  8023c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023ca:	89 d0                	mov    %edx,%eax
  8023cc:	01 c0                	add    %eax,%eax
  8023ce:	01 d0                	add    %edx,%eax
  8023d0:	c1 e0 02             	shl    $0x2,%eax
  8023d3:	05 44 20 81 00       	add    $0x812044,%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8023dd:	75 08                	jne    8023e7 <smalloc+0x9f>
        {
            exactIdx = i;
  8023df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8023e5:	eb 5b                	jmp    802442 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8023e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023ea:	89 d0                	mov    %edx,%eax
  8023ec:	01 c0                	add    %eax,%eax
  8023ee:	01 d0                	add    %edx,%eax
  8023f0:	c1 e0 02             	shl    $0x2,%eax
  8023f3:	05 48 20 81 00       	add    $0x812048,%eax
  8023f8:	8a 00                	mov    (%eax),%al
  8023fa:	84 c0                	test   %al,%al
  8023fc:	74 34                	je     802432 <smalloc+0xea>
  8023fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802401:	89 d0                	mov    %edx,%eax
  802403:	01 c0                	add    %eax,%eax
  802405:	01 d0                	add    %edx,%eax
  802407:	c1 e0 02             	shl    $0x2,%eax
  80240a:	05 44 20 81 00       	add    $0x812044,%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802414:	76 1c                	jbe    802432 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802416:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802419:	89 d0                	mov    %edx,%eax
  80241b:	01 c0                	add    %eax,%eax
  80241d:	01 d0                	add    %edx,%eax
  80241f:	c1 e0 02             	shl    $0x2,%eax
  802422:	05 44 20 81 00       	add    $0x812044,%eax
  802427:	8b 00                	mov    (%eax),%eax
  802429:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80242c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80242f:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802432:	ff 45 e8             	incl   -0x18(%ebp)
  802435:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80243c:	0f 8e 6e ff ff ff    	jle    8023b0 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802442:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802449:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80244d:	74 7d                	je     8024cc <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80244f:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802456:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802459:	89 d0                	mov    %edx,%eax
  80245b:	01 c0                	add    %eax,%eax
  80245d:	01 d0                	add    %edx,%eax
  80245f:	c1 e0 02             	shl    $0x2,%eax
  802462:	05 40 20 81 00       	add    $0x812040,%eax
  802467:	8b 10                	mov    (%eax),%edx
  802469:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80246c:	01 d0                	add    %edx,%eax
  80246e:	48                   	dec    %eax
  80246f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802472:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802475:	ba 00 00 00 00       	mov    $0x0,%edx
  80247a:	f7 75 bc             	divl   -0x44(%ebp)
  80247d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802480:	29 d0                	sub    %edx,%eax
  802482:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802485:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802488:	89 d0                	mov    %edx,%eax
  80248a:	01 c0                	add    %eax,%eax
  80248c:	01 d0                	add    %edx,%eax
  80248e:	c1 e0 02             	shl    $0x2,%eax
  802491:	05 48 20 81 00       	add    $0x812048,%eax
  802496:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249c:	89 d0                	mov    %edx,%eax
  80249e:	01 c0                	add    %eax,%eax
  8024a0:	01 d0                	add    %edx,%eax
  8024a2:	c1 e0 02             	shl    $0x2,%eax
  8024a5:	05 44 20 81 00       	add    $0x812044,%eax
  8024aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8024b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b3:	89 d0                	mov    %edx,%eax
  8024b5:	01 c0                	add    %eax,%eax
  8024b7:	01 d0                	add    %edx,%eax
  8024b9:	c1 e0 02             	shl    $0x2,%eax
  8024bc:	05 40 20 81 00       	add    $0x812040,%eax
  8024c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c7:	e9 2d 01 00 00       	jmp    8025f9 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8024cc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024d0:	0f 84 ce 00 00 00    	je     8025a4 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8024d6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8024dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e0:	89 d0                	mov    %edx,%eax
  8024e2:	01 c0                	add    %eax,%eax
  8024e4:	01 d0                	add    %edx,%eax
  8024e6:	c1 e0 02             	shl    $0x2,%eax
  8024e9:	05 40 20 81 00       	add    $0x812040,%eax
  8024ee:	8b 10                	mov    (%eax),%edx
  8024f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024f3:	01 d0                	add    %edx,%eax
  8024f5:	48                   	dec    %eax
  8024f6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8024f9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802501:	f7 75 c4             	divl   -0x3c(%ebp)
  802504:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802507:	29 d0                	sub    %edx,%eax
  802509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80250c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250f:	89 d0                	mov    %edx,%eax
  802511:	01 c0                	add    %eax,%eax
  802513:	01 d0                	add    %edx,%eax
  802515:	c1 e0 02             	shl    $0x2,%eax
  802518:	05 44 20 81 00       	add    $0x812044,%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802522:	75 47                	jne    80256b <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802524:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802527:	89 d0                	mov    %edx,%eax
  802529:	01 c0                	add    %eax,%eax
  80252b:	01 d0                	add    %edx,%eax
  80252d:	c1 e0 02             	shl    $0x2,%eax
  802530:	05 48 20 81 00       	add    $0x812048,%eax
  802535:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80253b:	89 d0                	mov    %edx,%eax
  80253d:	01 c0                	add    %eax,%eax
  80253f:	01 d0                	add    %edx,%eax
  802541:	c1 e0 02             	shl    $0x2,%eax
  802544:	05 44 20 81 00       	add    $0x812044,%eax
  802549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80254f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802552:	89 d0                	mov    %edx,%eax
  802554:	01 c0                	add    %eax,%eax
  802556:	01 d0                	add    %edx,%eax
  802558:	c1 e0 02             	shl    $0x2,%eax
  80255b:	05 40 20 81 00       	add    $0x812040,%eax
  802560:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802566:	e9 8e 00 00 00       	jmp    8025f9 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80256b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80256e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802571:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802574:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802577:	89 d0                	mov    %edx,%eax
  802579:	01 c0                	add    %eax,%eax
  80257b:	01 d0                	add    %edx,%eax
  80257d:	c1 e0 02             	shl    $0x2,%eax
  802580:	05 40 20 81 00       	add    $0x812040,%eax
  802585:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80258d:	89 c2                	mov    %eax,%edx
  80258f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802592:	89 c8                	mov    %ecx,%eax
  802594:	01 c0                	add    %eax,%eax
  802596:	01 c8                	add    %ecx,%eax
  802598:	c1 e0 02             	shl    $0x2,%eax
  80259b:	05 44 20 81 00       	add    $0x812044,%eax
  8025a0:	89 10                	mov    %edx,(%eax)
  8025a2:	eb 55                	jmp    8025f9 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8025a4:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8025ab:	8b 15 88 60 83 00    	mov    0x836088,%edx
  8025b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025b4:	01 d0                	add    %edx,%eax
  8025b6:	48                   	dec    %eax
  8025b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8025ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c2:	f7 75 d0             	divl   -0x30(%ebp)
  8025c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025c8:	29 d0                	sub    %edx,%eax
  8025ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8025cd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8025d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d3:	01 d0                	add    %edx,%eax
  8025d5:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8025da:	76 0a                	jbe    8025e6 <smalloc+0x29e>
            return NULL;
  8025dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e1:	e9 ba 00 00 00       	jmp    8026a0 <smalloc+0x358>
        va = start;
  8025e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8025ec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8025ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f2:	01 d0                	add    %edx,%eax
  8025f4:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802600:	eb 5e                	jmp    802660 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802602:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802605:	89 d0                	mov    %edx,%eax
  802607:	01 c0                	add    %eax,%eax
  802609:	01 d0                	add    %edx,%eax
  80260b:	c1 e0 02             	shl    $0x2,%eax
  80260e:	05 48 60 80 00       	add    $0x806048,%eax
  802613:	8a 00                	mov    (%eax),%al
  802615:	84 c0                	test   %al,%al
  802617:	75 44                	jne    80265d <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802619:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80261c:	89 d0                	mov    %edx,%eax
  80261e:	01 c0                	add    %eax,%eax
  802620:	01 d0                	add    %edx,%eax
  802622:	c1 e0 02             	shl    $0x2,%eax
  802625:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80262b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802633:	89 d0                	mov    %edx,%eax
  802635:	01 c0                	add    %eax,%eax
  802637:	01 d0                	add    %edx,%eax
  802639:	c1 e0 02             	shl    $0x2,%eax
  80263c:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802642:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802645:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802647:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80264a:	89 d0                	mov    %edx,%eax
  80264c:	01 c0                	add    %eax,%eax
  80264e:	01 d0                	add    %edx,%eax
  802650:	c1 e0 02             	shl    $0x2,%eax
  802653:	05 48 60 80 00       	add    $0x806048,%eax
  802658:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80265b:	eb 0c                	jmp    802669 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80265d:	ff 45 e0             	incl   -0x20(%ebp)
  802660:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802667:	7e 99                	jle    802602 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802669:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80266c:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802670:	52                   	push   %edx
  802671:	50                   	push   %eax
  802672:	ff 75 d4             	pushl  -0x2c(%ebp)
  802675:	ff 75 08             	pushl  0x8(%ebp)
  802678:	e8 de 0e 00 00       	call   80355b <sys_create_shared_object>
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802683:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802687:	75 07                	jne    802690 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802689:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80268e:	eb 10                	jmp    8026a0 <smalloc+0x358>
    if (r < 0)
  802690:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802694:	79 07                	jns    80269d <smalloc+0x355>
        return NULL;
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
  80269b:	eb 03                	jmp    8026a0 <smalloc+0x358>
    return (void*)va;
  80269d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026a8:	e8 51 f4 ff ff       	call   801afe <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8026ad:	83 ec 08             	sub    $0x8,%esp
  8026b0:	ff 75 0c             	pushl  0xc(%ebp)
  8026b3:	ff 75 08             	pushl  0x8(%ebp)
  8026b6:	e8 ca 0e 00 00       	call   803585 <sys_size_of_shared_object>
  8026bb:	83 c4 10             	add    $0x10,%esp
  8026be:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8026c1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8026c5:	7f 0a                	jg     8026d1 <sget+0x2f>
        return NULL;
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cc:	e9 28 03 00 00       	jmp    8029f9 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8026d1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026de:	01 d0                	add    %edx,%eax
  8026e0:	48                   	dec    %eax
  8026e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ec:	f7 75 d8             	divl   -0x28(%ebp)
  8026ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f2:	29 d0                	sub    %edx,%eax
  8026f4:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8026f7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8026fe:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802705:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80270c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802713:	e9 85 00 00 00       	jmp    80279d <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802718:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80271b:	89 d0                	mov    %edx,%eax
  80271d:	01 c0                	add    %eax,%eax
  80271f:	01 d0                	add    %edx,%eax
  802721:	c1 e0 02             	shl    $0x2,%eax
  802724:	05 48 20 81 00       	add    $0x812048,%eax
  802729:	8a 00                	mov    (%eax),%al
  80272b:	84 c0                	test   %al,%al
  80272d:	74 20                	je     80274f <sget+0xad>
  80272f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802732:	89 d0                	mov    %edx,%eax
  802734:	01 c0                	add    %eax,%eax
  802736:	01 d0                	add    %edx,%eax
  802738:	c1 e0 02             	shl    $0x2,%eax
  80273b:	05 44 20 81 00       	add    $0x812044,%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802745:	75 08                	jne    80274f <sget+0xad>
        {
            exactIdx = i;
  802747:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80274d:	eb 5b                	jmp    8027aa <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80274f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802752:	89 d0                	mov    %edx,%eax
  802754:	01 c0                	add    %eax,%eax
  802756:	01 d0                	add    %edx,%eax
  802758:	c1 e0 02             	shl    $0x2,%eax
  80275b:	05 48 20 81 00       	add    $0x812048,%eax
  802760:	8a 00                	mov    (%eax),%al
  802762:	84 c0                	test   %al,%al
  802764:	74 34                	je     80279a <sget+0xf8>
  802766:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802769:	89 d0                	mov    %edx,%eax
  80276b:	01 c0                	add    %eax,%eax
  80276d:	01 d0                	add    %edx,%eax
  80276f:	c1 e0 02             	shl    $0x2,%eax
  802772:	05 44 20 81 00       	add    $0x812044,%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80277c:	76 1c                	jbe    80279a <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80277e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802781:	89 d0                	mov    %edx,%eax
  802783:	01 c0                	add    %eax,%eax
  802785:	01 d0                	add    %edx,%eax
  802787:	c1 e0 02             	shl    $0x2,%eax
  80278a:	05 44 20 81 00       	add    $0x812044,%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802794:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802797:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80279a:	ff 45 e8             	incl   -0x18(%ebp)
  80279d:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8027a4:	0f 8e 6e ff ff ff    	jle    802718 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8027aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8027b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8027b5:	74 7d                	je     802834 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8027b7:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8027be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c1:	89 d0                	mov    %edx,%eax
  8027c3:	01 c0                	add    %eax,%eax
  8027c5:	01 d0                	add    %edx,%eax
  8027c7:	c1 e0 02             	shl    $0x2,%eax
  8027ca:	05 40 20 81 00       	add    $0x812040,%eax
  8027cf:	8b 10                	mov    (%eax),%edx
  8027d1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027d4:	01 d0                	add    %edx,%eax
  8027d6:	48                   	dec    %eax
  8027d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8027da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e2:	f7 75 b8             	divl   -0x48(%ebp)
  8027e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027e8:	29 d0                	sub    %edx,%eax
  8027ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8027ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f0:	89 d0                	mov    %edx,%eax
  8027f2:	01 c0                	add    %eax,%eax
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	c1 e0 02             	shl    $0x2,%eax
  8027f9:	05 48 20 81 00       	add    $0x812048,%eax
  8027fe:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802804:	89 d0                	mov    %edx,%eax
  802806:	01 c0                	add    %eax,%eax
  802808:	01 d0                	add    %edx,%eax
  80280a:	c1 e0 02             	shl    $0x2,%eax
  80280d:	05 44 20 81 00       	add    $0x812044,%eax
  802812:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281b:	89 d0                	mov    %edx,%eax
  80281d:	01 c0                	add    %eax,%eax
  80281f:	01 d0                	add    %edx,%eax
  802821:	c1 e0 02             	shl    $0x2,%eax
  802824:	05 40 20 81 00       	add    $0x812040,%eax
  802829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282f:	e9 2d 01 00 00       	jmp    802961 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802834:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802838:	0f 84 ce 00 00 00    	je     80290c <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80283e:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802845:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802848:	89 d0                	mov    %edx,%eax
  80284a:	01 c0                	add    %eax,%eax
  80284c:	01 d0                	add    %edx,%eax
  80284e:	c1 e0 02             	shl    $0x2,%eax
  802851:	05 40 20 81 00       	add    $0x812040,%eax
  802856:	8b 10                	mov    (%eax),%edx
  802858:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80285b:	01 d0                	add    %edx,%eax
  80285d:	48                   	dec    %eax
  80285e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802861:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802864:	ba 00 00 00 00       	mov    $0x0,%edx
  802869:	f7 75 c0             	divl   -0x40(%ebp)
  80286c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80286f:	29 d0                	sub    %edx,%eax
  802871:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802874:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802877:	89 d0                	mov    %edx,%eax
  802879:	01 c0                	add    %eax,%eax
  80287b:	01 d0                	add    %edx,%eax
  80287d:	c1 e0 02             	shl    $0x2,%eax
  802880:	05 44 20 81 00       	add    $0x812044,%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80288a:	75 47                	jne    8028d3 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80288c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288f:	89 d0                	mov    %edx,%eax
  802891:	01 c0                	add    %eax,%eax
  802893:	01 d0                	add    %edx,%eax
  802895:	c1 e0 02             	shl    $0x2,%eax
  802898:	05 48 20 81 00       	add    $0x812048,%eax
  80289d:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8028a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a3:	89 d0                	mov    %edx,%eax
  8028a5:	01 c0                	add    %eax,%eax
  8028a7:	01 d0                	add    %edx,%eax
  8028a9:	c1 e0 02             	shl    $0x2,%eax
  8028ac:	05 44 20 81 00       	add    $0x812044,%eax
  8028b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8028b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ba:	89 d0                	mov    %edx,%eax
  8028bc:	01 c0                	add    %eax,%eax
  8028be:	01 d0                	add    %edx,%eax
  8028c0:	c1 e0 02             	shl    $0x2,%eax
  8028c3:	05 40 20 81 00       	add    $0x812040,%eax
  8028c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ce:	e9 8e 00 00 00       	jmp    802961 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8028d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028d9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028df:	89 d0                	mov    %edx,%eax
  8028e1:	01 c0                	add    %eax,%eax
  8028e3:	01 d0                	add    %edx,%eax
  8028e5:	c1 e0 02             	shl    $0x2,%eax
  8028e8:	05 40 20 81 00       	add    $0x812040,%eax
  8028ed:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8028ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f2:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8028f5:	89 c2                	mov    %eax,%edx
  8028f7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028fa:	89 c8                	mov    %ecx,%eax
  8028fc:	01 c0                	add    %eax,%eax
  8028fe:	01 c8                	add    %ecx,%eax
  802900:	c1 e0 02             	shl    $0x2,%eax
  802903:	05 44 20 81 00       	add    $0x812044,%eax
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	eb 55                	jmp    802961 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80290c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802913:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802919:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80291c:	01 d0                	add    %edx,%eax
  80291e:	48                   	dec    %eax
  80291f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802922:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802925:	ba 00 00 00 00       	mov    $0x0,%edx
  80292a:	f7 75 cc             	divl   -0x34(%ebp)
  80292d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802930:	29 d0                	sub    %edx,%eax
  802932:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802935:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802938:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80293b:	01 d0                	add    %edx,%eax
  80293d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802942:	76 0a                	jbe    80294e <sget+0x2ac>
            return NULL;
  802944:	b8 00 00 00 00       	mov    $0x0,%eax
  802949:	e9 ab 00 00 00       	jmp    8029f9 <sget+0x357>
        va = start;
  80294e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802951:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802954:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80295a:	01 d0                	add    %edx,%eax
  80295c:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802961:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802968:	eb 5e                	jmp    8029c8 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  80296a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80296d:	89 d0                	mov    %edx,%eax
  80296f:	01 c0                	add    %eax,%eax
  802971:	01 d0                	add    %edx,%eax
  802973:	c1 e0 02             	shl    $0x2,%eax
  802976:	05 48 60 80 00       	add    $0x806048,%eax
  80297b:	8a 00                	mov    (%eax),%al
  80297d:	84 c0                	test   %al,%al
  80297f:	75 44                	jne    8029c5 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802981:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802984:	89 d0                	mov    %edx,%eax
  802986:	01 c0                	add    %eax,%eax
  802988:	01 d0                	add    %edx,%eax
  80298a:	c1 e0 02             	shl    $0x2,%eax
  80298d:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802996:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802998:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80299b:	89 d0                	mov    %edx,%eax
  80299d:	01 c0                	add    %eax,%eax
  80299f:	01 d0                	add    %edx,%eax
  8029a1:	c1 e0 02             	shl    $0x2,%eax
  8029a4:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8029aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029ad:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8029af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029b2:	89 d0                	mov    %edx,%eax
  8029b4:	01 c0                	add    %eax,%eax
  8029b6:	01 d0                	add    %edx,%eax
  8029b8:	c1 e0 02             	shl    $0x2,%eax
  8029bb:	05 48 60 80 00       	add    $0x806048,%eax
  8029c0:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8029c3:	eb 0c                	jmp    8029d1 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029c5:	ff 45 e0             	incl   -0x20(%ebp)
  8029c8:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8029cf:	7e 99                	jle    80296a <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8029d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d4:	83 ec 04             	sub    $0x4,%esp
  8029d7:	50                   	push   %eax
  8029d8:	ff 75 0c             	pushl  0xc(%ebp)
  8029db:	ff 75 08             	pushl  0x8(%ebp)
  8029de:	e8 bf 0b 00 00       	call   8035a2 <sys_get_shared_object>
  8029e3:	83 c4 10             	add    $0x10,%esp
  8029e6:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8029e9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029ed:	79 07                	jns    8029f6 <sget+0x354>
        return NULL;
  8029ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f4:	eb 03                	jmp    8029f9 <sget+0x357>
    return (void*)va;
  8029f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
  8029fe:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a01:	e8 f8 f0 ff ff       	call   801afe <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802a06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a0a:	75 13                	jne    802a1f <realloc+0x24>
		return malloc(new_size);
  802a0c:	83 ec 0c             	sub    $0xc,%esp
  802a0f:	ff 75 0c             	pushl  0xc(%ebp)
  802a12:	e8 c4 f1 ff ff       	call   801bdb <malloc>
  802a17:	83 c4 10             	add    $0x10,%esp
  802a1a:	e9 f4 05 00 00       	jmp    803013 <realloc+0x618>
	if (new_size == 0)
  802a1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a23:	75 18                	jne    802a3d <realloc+0x42>
	{
		free(virtual_address);
  802a25:	83 ec 0c             	sub    $0xc,%esp
  802a28:	ff 75 08             	pushl  0x8(%ebp)
  802a2b:	e8 0b f5 ff ff       	call   801f3b <free>
  802a30:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	e9 d6 05 00 00       	jmp    803013 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802a43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	79 74                	jns    802abe <realloc+0xc3>
  802a4a:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802a51:	77 6b                	ja     802abe <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802a53:	83 ec 0c             	sub    $0xc,%esp
  802a56:	ff 75 0c             	pushl  0xc(%ebp)
  802a59:	e8 7d f1 ff ff       	call   801bdb <malloc>
  802a5e:	83 c4 10             	add    $0x10,%esp
  802a61:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802a64:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802a68:	75 0a                	jne    802a74 <realloc+0x79>
			return NULL;
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	e9 9f 05 00 00       	jmp    803013 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802a74:	83 ec 0c             	sub    $0xc,%esp
  802a77:	ff 75 08             	pushl  0x8(%ebp)
  802a7a:	e8 e0 11 00 00       	call   803c5f <get_block_size>
  802a7f:	83 c4 10             	add    $0x10,%esp
  802a82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802a85:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a8b:	39 d0                	cmp    %edx,%eax
  802a8d:	76 02                	jbe    802a91 <realloc+0x96>
  802a8f:	89 d0                	mov    %edx,%eax
  802a91:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802a94:	83 ec 04             	sub    $0x4,%esp
  802a97:	ff 75 c0             	pushl  -0x40(%ebp)
  802a9a:	ff 75 08             	pushl  0x8(%ebp)
  802a9d:	ff 75 c8             	pushl  -0x38(%ebp)
  802aa0:	e8 56 eb ff ff       	call   8015fb <memmove>
  802aa5:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802aa8:	83 ec 0c             	sub    $0xc,%esp
  802aab:	ff 75 08             	pushl  0x8(%ebp)
  802aae:	e8 88 f4 ff ff       	call   801f3b <free>
  802ab3:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802ab6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ab9:	e9 55 05 00 00       	jmp    803013 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802abe:	a1 30 61 83 00       	mov    0x836130,%eax
  802ac3:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802ac6:	72 09                	jb     802ad1 <realloc+0xd6>
  802ac8:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802acf:	76 0a                	jbe    802adb <realloc+0xe0>
		return NULL;
  802ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad6:	e9 38 05 00 00       	jmp    803013 <realloc+0x618>
	uint32 oldsz = 0;
  802adb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802ae2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802ae9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802af0:	eb 50                	jmp    802b42 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802af2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af5:	89 d0                	mov    %edx,%eax
  802af7:	01 c0                	add    %eax,%eax
  802af9:	01 d0                	add    %edx,%eax
  802afb:	c1 e0 02             	shl    $0x2,%eax
  802afe:	05 48 60 80 00       	add    $0x806048,%eax
  802b03:	8a 00                	mov    (%eax),%al
  802b05:	84 c0                	test   %al,%al
  802b07:	74 36                	je     802b3f <realloc+0x144>
  802b09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b0c:	89 d0                	mov    %edx,%eax
  802b0e:	01 c0                	add    %eax,%eax
  802b10:	01 d0                	add    %edx,%eax
  802b12:	c1 e0 02             	shl    $0x2,%eax
  802b15:	05 40 60 80 00       	add    $0x806040,%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802b1f:	75 1e                	jne    802b3f <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b24:	89 d0                	mov    %edx,%eax
  802b26:	01 c0                	add    %eax,%eax
  802b28:	01 d0                	add    %edx,%eax
  802b2a:	c1 e0 02             	shl    $0x2,%eax
  802b2d:	05 44 60 80 00       	add    $0x806044,%eax
  802b32:	8b 00                	mov    (%eax),%eax
  802b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802b3d:	eb 0c                	jmp    802b4b <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b3f:	ff 45 ec             	incl   -0x14(%ebp)
  802b42:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b49:	7e a7                	jle    802af2 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802b4b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b4f:	75 0a                	jne    802b5b <realloc+0x160>
		return NULL;
  802b51:	b8 00 00 00 00       	mov    $0x0,%eax
  802b56:	e9 b8 04 00 00       	jmp    803013 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802b5b:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b68:	01 d0                	add    %edx,%eax
  802b6a:	48                   	dec    %eax
  802b6b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802b6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b71:	ba 00 00 00 00       	mov    $0x0,%edx
  802b76:	f7 75 bc             	divl   -0x44(%ebp)
  802b79:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b7c:	29 d0                	sub    %edx,%eax
  802b7e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802b81:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b84:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b87:	75 08                	jne    802b91 <realloc+0x196>
		return virtual_address;
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	e9 82 04 00 00       	jmp    803013 <realloc+0x618>
	if (req < oldsz)
  802b91:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b97:	0f 83 cd 02 00 00    	jae    802e6a <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802ba3:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802ba6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ba9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bac:	01 d0                	add    %edx,%eax
  802bae:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802bb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb4:	89 d0                	mov    %edx,%eax
  802bb6:	01 c0                	add    %eax,%eax
  802bb8:	01 d0                	add    %edx,%eax
  802bba:	c1 e0 02             	shl    $0x2,%eax
  802bbd:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802bc3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bc6:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802bc8:	83 ec 08             	sub    $0x8,%esp
  802bcb:	ff 75 b0             	pushl  -0x50(%ebp)
  802bce:	ff 75 ac             	pushl  -0x54(%ebp)
  802bd1:	e8 e3 0c 00 00       	call   8038b9 <sys_free_user_mem>
  802bd6:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802bd9:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802be0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802be7:	eb 64                	jmp    802c4d <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802be9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bec:	89 d0                	mov    %edx,%eax
  802bee:	01 c0                	add    %eax,%eax
  802bf0:	01 d0                	add    %edx,%eax
  802bf2:	c1 e0 02             	shl    $0x2,%eax
  802bf5:	05 48 20 81 00       	add    $0x812048,%eax
  802bfa:	8a 00                	mov    (%eax),%al
  802bfc:	84 c0                	test   %al,%al
  802bfe:	75 4a                	jne    802c4a <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802c00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c03:	89 d0                	mov    %edx,%eax
  802c05:	01 c0                	add    %eax,%eax
  802c07:	01 d0                	add    %edx,%eax
  802c09:	c1 e0 02             	shl    $0x2,%eax
  802c0c:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802c12:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c15:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802c17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c1a:	89 d0                	mov    %edx,%eax
  802c1c:	01 c0                	add    %eax,%eax
  802c1e:	01 d0                	add    %edx,%eax
  802c20:	c1 e0 02             	shl    $0x2,%eax
  802c23:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802c29:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2c:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802c2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c31:	89 d0                	mov    %edx,%eax
  802c33:	01 c0                	add    %eax,%eax
  802c35:	01 d0                	add    %edx,%eax
  802c37:	c1 e0 02             	shl    $0x2,%eax
  802c3a:	05 48 20 81 00       	add    $0x812048,%eax
  802c3f:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c45:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802c48:	eb 0c                	jmp    802c56 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c4a:	ff 45 e4             	incl   -0x1c(%ebp)
  802c4d:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802c54:	7e 93                	jle    802be9 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802c56:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802c5a:	0f 84 8d 01 00 00    	je     802ded <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c60:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c67:	e9 74 01 00 00       	jmp    802de0 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802c6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c72:	0f 84 64 01 00 00    	je     802ddc <realloc+0x3e1>
				if (uhp_frees[k].free)
  802c78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c7b:	89 d0                	mov    %edx,%eax
  802c7d:	01 c0                	add    %eax,%eax
  802c7f:	01 d0                	add    %edx,%eax
  802c81:	c1 e0 02             	shl    $0x2,%eax
  802c84:	05 48 20 81 00       	add    $0x812048,%eax
  802c89:	8a 00                	mov    (%eax),%al
  802c8b:	84 c0                	test   %al,%al
  802c8d:	0f 84 4a 01 00 00    	je     802ddd <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c96:	89 d0                	mov    %edx,%eax
  802c98:	01 c0                	add    %eax,%eax
  802c9a:	01 d0                	add    %edx,%eax
  802c9c:	c1 e0 02             	shl    $0x2,%eax
  802c9f:	05 40 20 81 00       	add    $0x812040,%eax
  802ca4:	8b 08                	mov    (%eax),%ecx
  802ca6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ca9:	89 d0                	mov    %edx,%eax
  802cab:	01 c0                	add    %eax,%eax
  802cad:	01 d0                	add    %edx,%eax
  802caf:	c1 e0 02             	shl    $0x2,%eax
  802cb2:	05 44 20 81 00       	add    $0x812044,%eax
  802cb7:	8b 00                	mov    (%eax),%eax
  802cb9:	01 c1                	add    %eax,%ecx
  802cbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cbe:	89 d0                	mov    %edx,%eax
  802cc0:	01 c0                	add    %eax,%eax
  802cc2:	01 d0                	add    %edx,%eax
  802cc4:	c1 e0 02             	shl    $0x2,%eax
  802cc7:	05 40 20 81 00       	add    $0x812040,%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	39 c1                	cmp    %eax,%ecx
  802cd0:	75 7a                	jne    802d4c <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802cd2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cd5:	89 d0                	mov    %edx,%eax
  802cd7:	01 c0                	add    %eax,%eax
  802cd9:	01 d0                	add    %edx,%eax
  802cdb:	c1 e0 02             	shl    $0x2,%eax
  802cde:	05 40 20 81 00       	add    $0x812040,%eax
  802ce3:	8b 10                	mov    (%eax),%edx
  802ce5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802ce8:	89 c8                	mov    %ecx,%eax
  802cea:	01 c0                	add    %eax,%eax
  802cec:	01 c8                	add    %ecx,%eax
  802cee:	c1 e0 02             	shl    $0x2,%eax
  802cf1:	05 40 20 81 00       	add    $0x812040,%eax
  802cf6:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802cf8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cfb:	89 d0                	mov    %edx,%eax
  802cfd:	01 c0                	add    %eax,%eax
  802cff:	01 d0                	add    %edx,%eax
  802d01:	c1 e0 02             	shl    $0x2,%eax
  802d04:	05 44 20 81 00       	add    $0x812044,%eax
  802d09:	8b 08                	mov    (%eax),%ecx
  802d0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d0e:	89 d0                	mov    %edx,%eax
  802d10:	01 c0                	add    %eax,%eax
  802d12:	01 d0                	add    %edx,%eax
  802d14:	c1 e0 02             	shl    $0x2,%eax
  802d17:	05 44 20 81 00       	add    $0x812044,%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	01 c1                	add    %eax,%ecx
  802d20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d23:	89 d0                	mov    %edx,%eax
  802d25:	01 c0                	add    %eax,%eax
  802d27:	01 d0                	add    %edx,%eax
  802d29:	c1 e0 02             	shl    $0x2,%eax
  802d2c:	05 44 20 81 00       	add    $0x812044,%eax
  802d31:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802d33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d36:	89 d0                	mov    %edx,%eax
  802d38:	01 c0                	add    %eax,%eax
  802d3a:	01 d0                	add    %edx,%eax
  802d3c:	c1 e0 02             	shl    $0x2,%eax
  802d3f:	05 48 20 81 00       	add    $0x812048,%eax
  802d44:	c6 00 00             	movb   $0x0,(%eax)
  802d47:	e9 91 00 00 00       	jmp    802ddd <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d4f:	89 d0                	mov    %edx,%eax
  802d51:	01 c0                	add    %eax,%eax
  802d53:	01 d0                	add    %edx,%eax
  802d55:	c1 e0 02             	shl    $0x2,%eax
  802d58:	05 40 20 81 00       	add    $0x812040,%eax
  802d5d:	8b 08                	mov    (%eax),%ecx
  802d5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d62:	89 d0                	mov    %edx,%eax
  802d64:	01 c0                	add    %eax,%eax
  802d66:	01 d0                	add    %edx,%eax
  802d68:	c1 e0 02             	shl    $0x2,%eax
  802d6b:	05 44 20 81 00       	add    $0x812044,%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	01 c1                	add    %eax,%ecx
  802d74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d77:	89 d0                	mov    %edx,%eax
  802d79:	01 c0                	add    %eax,%eax
  802d7b:	01 d0                	add    %edx,%eax
  802d7d:	c1 e0 02             	shl    $0x2,%eax
  802d80:	05 40 20 81 00       	add    $0x812040,%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	39 c1                	cmp    %eax,%ecx
  802d89:	75 52                	jne    802ddd <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802d8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d8e:	89 d0                	mov    %edx,%eax
  802d90:	01 c0                	add    %eax,%eax
  802d92:	01 d0                	add    %edx,%eax
  802d94:	c1 e0 02             	shl    $0x2,%eax
  802d97:	05 44 20 81 00       	add    $0x812044,%eax
  802d9c:	8b 08                	mov    (%eax),%ecx
  802d9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802da1:	89 d0                	mov    %edx,%eax
  802da3:	01 c0                	add    %eax,%eax
  802da5:	01 d0                	add    %edx,%eax
  802da7:	c1 e0 02             	shl    $0x2,%eax
  802daa:	05 44 20 81 00       	add    $0x812044,%eax
  802daf:	8b 00                	mov    (%eax),%eax
  802db1:	01 c1                	add    %eax,%ecx
  802db3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db6:	89 d0                	mov    %edx,%eax
  802db8:	01 c0                	add    %eax,%eax
  802dba:	01 d0                	add    %edx,%eax
  802dbc:	c1 e0 02             	shl    $0x2,%eax
  802dbf:	05 44 20 81 00       	add    $0x812044,%eax
  802dc4:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802dc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dc9:	89 d0                	mov    %edx,%eax
  802dcb:	01 c0                	add    %eax,%eax
  802dcd:	01 d0                	add    %edx,%eax
  802dcf:	c1 e0 02             	shl    $0x2,%eax
  802dd2:	05 48 20 81 00       	add    $0x812048,%eax
  802dd7:	c6 00 00             	movb   $0x0,(%eax)
  802dda:	eb 01                	jmp    802ddd <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802ddc:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ddd:	ff 45 e0             	incl   -0x20(%ebp)
  802de0:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802de7:	0f 8e 7f fe ff ff    	jle    802c6c <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802ded:	a1 30 61 83 00       	mov    0x836130,%eax
  802df2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802df5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802dfc:	eb 53                	jmp    802e51 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802dfe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e01:	89 d0                	mov    %edx,%eax
  802e03:	01 c0                	add    %eax,%eax
  802e05:	01 d0                	add    %edx,%eax
  802e07:	c1 e0 02             	shl    $0x2,%eax
  802e0a:	05 48 60 80 00       	add    $0x806048,%eax
  802e0f:	8a 00                	mov    (%eax),%al
  802e11:	84 c0                	test   %al,%al
  802e13:	74 39                	je     802e4e <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e15:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e18:	89 d0                	mov    %edx,%eax
  802e1a:	01 c0                	add    %eax,%eax
  802e1c:	01 d0                	add    %edx,%eax
  802e1e:	c1 e0 02             	shl    $0x2,%eax
  802e21:	05 40 60 80 00       	add    $0x806040,%eax
  802e26:	8b 08                	mov    (%eax),%ecx
  802e28:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e2b:	89 d0                	mov    %edx,%eax
  802e2d:	01 c0                	add    %eax,%eax
  802e2f:	01 d0                	add    %edx,%eax
  802e31:	c1 e0 02             	shl    $0x2,%eax
  802e34:	05 44 60 80 00       	add    $0x806044,%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	01 c8                	add    %ecx,%eax
  802e3d:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802e40:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e43:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802e46:	76 06                	jbe    802e4e <realloc+0x453>
  802e48:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e4e:	ff 45 d8             	incl   -0x28(%ebp)
  802e51:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802e58:	7e a4                	jle    802dfe <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802e5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e5d:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	e9 a9 01 00 00       	jmp    803013 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802e6a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	01 d0                	add    %edx,%eax
  802e72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802e75:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e7c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802e83:	eb 57                	jmp    802edc <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802e85:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e88:	89 d0                	mov    %edx,%eax
  802e8a:	01 c0                	add    %eax,%eax
  802e8c:	01 d0                	add    %edx,%eax
  802e8e:	c1 e0 02             	shl    $0x2,%eax
  802e91:	05 48 20 81 00       	add    $0x812048,%eax
  802e96:	8a 00                	mov    (%eax),%al
  802e98:	84 c0                	test   %al,%al
  802e9a:	74 3d                	je     802ed9 <realloc+0x4de>
  802e9c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e9f:	89 d0                	mov    %edx,%eax
  802ea1:	01 c0                	add    %eax,%eax
  802ea3:	01 d0                	add    %edx,%eax
  802ea5:	c1 e0 02             	shl    $0x2,%eax
  802ea8:	05 40 20 81 00       	add    $0x812040,%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eb2:	75 25                	jne    802ed9 <realloc+0x4de>
  802eb4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802eb7:	89 d0                	mov    %edx,%eax
  802eb9:	01 c0                	add    %eax,%eax
  802ebb:	01 d0                	add    %edx,%eax
  802ebd:	c1 e0 02             	shl    $0x2,%eax
  802ec0:	05 44 20 81 00       	add    $0x812044,%eax
  802ec5:	8b 10                	mov    (%eax),%edx
  802ec7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802eca:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ecd:	39 c2                	cmp    %eax,%edx
  802ecf:	72 08                	jb     802ed9 <realloc+0x4de>
		{
			adjIdx = j; break;
  802ed1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ed4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ed7:	eb 0c                	jmp    802ee5 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ed9:	ff 45 d0             	incl   -0x30(%ebp)
  802edc:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802ee3:	7e a0                	jle    802e85 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802ee5:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802ee9:	0f 84 d6 00 00 00    	je     802fc5 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802eef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ef2:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ef5:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802ef8:	83 ec 08             	sub    $0x8,%esp
  802efb:	ff 75 a0             	pushl  -0x60(%ebp)
  802efe:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f01:	e8 cf 09 00 00       	call   8038d5 <sys_allocate_user_mem>
  802f06:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802f09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0c:	89 d0                	mov    %edx,%eax
  802f0e:	01 c0                	add    %eax,%eax
  802f10:	01 d0                	add    %edx,%eax
  802f12:	c1 e0 02             	shl    $0x2,%eax
  802f15:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802f1b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f1e:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802f20:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f23:	89 d0                	mov    %edx,%eax
  802f25:	01 c0                	add    %eax,%eax
  802f27:	01 d0                	add    %edx,%eax
  802f29:	c1 e0 02             	shl    $0x2,%eax
  802f2c:	05 40 20 81 00       	add    $0x812040,%eax
  802f31:	8b 10                	mov    (%eax),%edx
  802f33:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f36:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802f39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f3c:	89 d0                	mov    %edx,%eax
  802f3e:	01 c0                	add    %eax,%eax
  802f40:	01 d0                	add    %edx,%eax
  802f42:	c1 e0 02             	shl    $0x2,%eax
  802f45:	05 40 20 81 00       	add    $0x812040,%eax
  802f4a:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802f4c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f4f:	89 d0                	mov    %edx,%eax
  802f51:	01 c0                	add    %eax,%eax
  802f53:	01 d0                	add    %edx,%eax
  802f55:	c1 e0 02             	shl    $0x2,%eax
  802f58:	05 44 20 81 00       	add    $0x812044,%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802f62:	89 c2                	mov    %eax,%edx
  802f64:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802f67:	89 c8                	mov    %ecx,%eax
  802f69:	01 c0                	add    %eax,%eax
  802f6b:	01 c8                	add    %ecx,%eax
  802f6d:	c1 e0 02             	shl    $0x2,%eax
  802f70:	05 44 20 81 00       	add    $0x812044,%eax
  802f75:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802f77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f7a:	89 d0                	mov    %edx,%eax
  802f7c:	01 c0                	add    %eax,%eax
  802f7e:	01 d0                	add    %edx,%eax
  802f80:	c1 e0 02             	shl    $0x2,%eax
  802f83:	05 44 20 81 00       	add    $0x812044,%eax
  802f88:	8b 00                	mov    (%eax),%eax
  802f8a:	85 c0                	test   %eax,%eax
  802f8c:	75 14                	jne    802fa2 <realloc+0x5a7>
  802f8e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f91:	89 d0                	mov    %edx,%eax
  802f93:	01 c0                	add    %eax,%eax
  802f95:	01 d0                	add    %edx,%eax
  802f97:	c1 e0 02             	shl    $0x2,%eax
  802f9a:	05 48 20 81 00       	add    $0x812048,%eax
  802f9f:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802fa2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fa5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fa8:	01 c2                	add    %eax,%edx
  802faa:	a1 88 60 83 00       	mov    0x836088,%eax
  802faf:	39 c2                	cmp    %eax,%edx
  802fb1:	76 0d                	jbe    802fc0 <realloc+0x5c5>
  802fb3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fb6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fb9:	01 d0                	add    %edx,%eax
  802fbb:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	eb 4e                	jmp    803013 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802fc5:	83 ec 0c             	sub    $0xc,%esp
  802fc8:	ff 75 0c             	pushl  0xc(%ebp)
  802fcb:	e8 0b ec ff ff       	call   801bdb <malloc>
  802fd0:	83 c4 10             	add    $0x10,%esp
  802fd3:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802fd6:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802fda:	75 07                	jne    802fe3 <realloc+0x5e8>
		return NULL;
  802fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe1:	eb 30                	jmp    803013 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802fe3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fe9:	39 d0                	cmp    %edx,%eax
  802feb:	76 02                	jbe    802fef <realloc+0x5f4>
  802fed:	89 d0                	mov    %edx,%eax
  802fef:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802ff2:	83 ec 04             	sub    $0x4,%esp
  802ff5:	50                   	push   %eax
  802ff6:	52                   	push   %edx
  802ff7:	ff 75 cc             	pushl  -0x34(%ebp)
  802ffa:	e8 cf 06 00 00       	call   8036ce <sys_move_user_mem>
  802fff:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  803002:	83 ec 0c             	sub    $0xc,%esp
  803005:	ff 75 08             	pushl  0x8(%ebp)
  803008:	e8 2e ef ff ff       	call   801f3b <free>
  80300d:	83 c4 10             	add    $0x10,%esp
	return newptr;
  803010:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  803013:	c9                   	leave  
  803014:	c3                   	ret    

00803015 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803015:	55                   	push   %ebp
  803016:	89 e5                	mov    %esp,%ebp
  803018:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  803021:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803025:	0f 84 33 03 00 00    	je     80335e <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  80302b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  803033:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  803036:	83 ec 08             	sub    $0x8,%esp
  803039:	ff 75 08             	pushl  0x8(%ebp)
  80303c:	ff 75 d8             	pushl  -0x28(%ebp)
  80303f:	e8 7d 05 00 00       	call   8035c1 <sys_delete_shared_object>
  803044:	83 c4 10             	add    $0x10,%esp
  803047:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  80304a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80304e:	0f 88 0d 03 00 00    	js     803361 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803054:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80305b:	e9 ef 02 00 00       	jmp    80334f <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803063:	89 d0                	mov    %edx,%eax
  803065:	01 c0                	add    %eax,%eax
  803067:	01 d0                	add    %edx,%eax
  803069:	c1 e0 02             	shl    $0x2,%eax
  80306c:	05 48 60 80 00       	add    $0x806048,%eax
  803071:	8a 00                	mov    (%eax),%al
  803073:	84 c0                	test   %al,%al
  803075:	0f 84 d1 02 00 00    	je     80334c <sfree+0x337>
  80307b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307e:	89 d0                	mov    %edx,%eax
  803080:	01 c0                	add    %eax,%eax
  803082:	01 d0                	add    %edx,%eax
  803084:	c1 e0 02             	shl    $0x2,%eax
  803087:	05 40 60 80 00       	add    $0x806040,%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803091:	0f 85 b5 02 00 00    	jne    80334c <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309a:	89 d0                	mov    %edx,%eax
  80309c:	01 c0                	add    %eax,%eax
  80309e:	01 d0                	add    %edx,%eax
  8030a0:	c1 e0 02             	shl    $0x2,%eax
  8030a3:	05 44 60 80 00       	add    $0x806044,%eax
  8030a8:	8b 00                	mov    (%eax),%eax
  8030aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  8030ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b0:	89 d0                	mov    %edx,%eax
  8030b2:	01 c0                	add    %eax,%eax
  8030b4:	01 d0                	add    %edx,%eax
  8030b6:	c1 e0 02             	shl    $0x2,%eax
  8030b9:	05 48 60 80 00       	add    $0x806048,%eax
  8030be:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  8030c1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8030c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8030cf:	eb 64                	jmp    803135 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  8030d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030d4:	89 d0                	mov    %edx,%eax
  8030d6:	01 c0                	add    %eax,%eax
  8030d8:	01 d0                	add    %edx,%eax
  8030da:	c1 e0 02             	shl    $0x2,%eax
  8030dd:	05 48 20 81 00       	add    $0x812048,%eax
  8030e2:	8a 00                	mov    (%eax),%al
  8030e4:	84 c0                	test   %al,%al
  8030e6:	75 4a                	jne    803132 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  8030e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030eb:	89 d0                	mov    %edx,%eax
  8030ed:	01 c0                	add    %eax,%eax
  8030ef:	01 d0                	add    %edx,%eax
  8030f1:	c1 e0 02             	shl    $0x2,%eax
  8030f4:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8030fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fd:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  8030ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803102:	89 d0                	mov    %edx,%eax
  803104:	01 c0                	add    %eax,%eax
  803106:	01 d0                	add    %edx,%eax
  803108:	c1 e0 02             	shl    $0x2,%eax
  80310b:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  803111:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803114:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  803116:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803119:	89 d0                	mov    %edx,%eax
  80311b:	01 c0                	add    %eax,%eax
  80311d:	01 d0                	add    %edx,%eax
  80311f:	c1 e0 02             	shl    $0x2,%eax
  803122:	05 48 20 81 00       	add    $0x812048,%eax
  803127:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  80312a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  803130:	eb 0c                	jmp    80313e <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803132:	ff 45 ec             	incl   -0x14(%ebp)
  803135:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80313c:	7e 93                	jle    8030d1 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  80313e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803142:	0f 84 8d 01 00 00    	je     8032d5 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803148:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80314f:	e9 74 01 00 00       	jmp    8032c8 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80315a:	0f 84 64 01 00 00    	je     8032c4 <sfree+0x2af>
					if (uhp_frees[k].free)
  803160:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803163:	89 d0                	mov    %edx,%eax
  803165:	01 c0                	add    %eax,%eax
  803167:	01 d0                	add    %edx,%eax
  803169:	c1 e0 02             	shl    $0x2,%eax
  80316c:	05 48 20 81 00       	add    $0x812048,%eax
  803171:	8a 00                	mov    (%eax),%al
  803173:	84 c0                	test   %al,%al
  803175:	0f 84 4a 01 00 00    	je     8032c5 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80317b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317e:	89 d0                	mov    %edx,%eax
  803180:	01 c0                	add    %eax,%eax
  803182:	01 d0                	add    %edx,%eax
  803184:	c1 e0 02             	shl    $0x2,%eax
  803187:	05 40 20 81 00       	add    $0x812040,%eax
  80318c:	8b 08                	mov    (%eax),%ecx
  80318e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803191:	89 d0                	mov    %edx,%eax
  803193:	01 c0                	add    %eax,%eax
  803195:	01 d0                	add    %edx,%eax
  803197:	c1 e0 02             	shl    $0x2,%eax
  80319a:	05 44 20 81 00       	add    $0x812044,%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	01 c1                	add    %eax,%ecx
  8031a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a6:	89 d0                	mov    %edx,%eax
  8031a8:	01 c0                	add    %eax,%eax
  8031aa:	01 d0                	add    %edx,%eax
  8031ac:	c1 e0 02             	shl    $0x2,%eax
  8031af:	05 40 20 81 00       	add    $0x812040,%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	39 c1                	cmp    %eax,%ecx
  8031b8:	75 7a                	jne    803234 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  8031ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bd:	89 d0                	mov    %edx,%eax
  8031bf:	01 c0                	add    %eax,%eax
  8031c1:	01 d0                	add    %edx,%eax
  8031c3:	c1 e0 02             	shl    $0x2,%eax
  8031c6:	05 40 20 81 00       	add    $0x812040,%eax
  8031cb:	8b 10                	mov    (%eax),%edx
  8031cd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8031d0:	89 c8                	mov    %ecx,%eax
  8031d2:	01 c0                	add    %eax,%eax
  8031d4:	01 c8                	add    %ecx,%eax
  8031d6:	c1 e0 02             	shl    $0x2,%eax
  8031d9:	05 40 20 81 00       	add    $0x812040,%eax
  8031de:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  8031e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e3:	89 d0                	mov    %edx,%eax
  8031e5:	01 c0                	add    %eax,%eax
  8031e7:	01 d0                	add    %edx,%eax
  8031e9:	c1 e0 02             	shl    $0x2,%eax
  8031ec:	05 44 20 81 00       	add    $0x812044,%eax
  8031f1:	8b 08                	mov    (%eax),%ecx
  8031f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f6:	89 d0                	mov    %edx,%eax
  8031f8:	01 c0                	add    %eax,%eax
  8031fa:	01 d0                	add    %edx,%eax
  8031fc:	c1 e0 02             	shl    $0x2,%eax
  8031ff:	05 44 20 81 00       	add    $0x812044,%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	01 c1                	add    %eax,%ecx
  803208:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320b:	89 d0                	mov    %edx,%eax
  80320d:	01 c0                	add    %eax,%eax
  80320f:	01 d0                	add    %edx,%eax
  803211:	c1 e0 02             	shl    $0x2,%eax
  803214:	05 44 20 81 00       	add    $0x812044,%eax
  803219:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  80321b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80321e:	89 d0                	mov    %edx,%eax
  803220:	01 c0                	add    %eax,%eax
  803222:	01 d0                	add    %edx,%eax
  803224:	c1 e0 02             	shl    $0x2,%eax
  803227:	05 48 20 81 00       	add    $0x812048,%eax
  80322c:	c6 00 00             	movb   $0x0,(%eax)
  80322f:	e9 91 00 00 00       	jmp    8032c5 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803234:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803237:	89 d0                	mov    %edx,%eax
  803239:	01 c0                	add    %eax,%eax
  80323b:	01 d0                	add    %edx,%eax
  80323d:	c1 e0 02             	shl    $0x2,%eax
  803240:	05 40 20 81 00       	add    $0x812040,%eax
  803245:	8b 08                	mov    (%eax),%ecx
  803247:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324a:	89 d0                	mov    %edx,%eax
  80324c:	01 c0                	add    %eax,%eax
  80324e:	01 d0                	add    %edx,%eax
  803250:	c1 e0 02             	shl    $0x2,%eax
  803253:	05 44 20 81 00       	add    $0x812044,%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	01 c1                	add    %eax,%ecx
  80325c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325f:	89 d0                	mov    %edx,%eax
  803261:	01 c0                	add    %eax,%eax
  803263:	01 d0                	add    %edx,%eax
  803265:	c1 e0 02             	shl    $0x2,%eax
  803268:	05 40 20 81 00       	add    $0x812040,%eax
  80326d:	8b 00                	mov    (%eax),%eax
  80326f:	39 c1                	cmp    %eax,%ecx
  803271:	75 52                	jne    8032c5 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803273:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803276:	89 d0                	mov    %edx,%eax
  803278:	01 c0                	add    %eax,%eax
  80327a:	01 d0                	add    %edx,%eax
  80327c:	c1 e0 02             	shl    $0x2,%eax
  80327f:	05 44 20 81 00       	add    $0x812044,%eax
  803284:	8b 08                	mov    (%eax),%ecx
  803286:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803289:	89 d0                	mov    %edx,%eax
  80328b:	01 c0                	add    %eax,%eax
  80328d:	01 d0                	add    %edx,%eax
  80328f:	c1 e0 02             	shl    $0x2,%eax
  803292:	05 44 20 81 00       	add    $0x812044,%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	01 c1                	add    %eax,%ecx
  80329b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80329e:	89 d0                	mov    %edx,%eax
  8032a0:	01 c0                	add    %eax,%eax
  8032a2:	01 d0                	add    %edx,%eax
  8032a4:	c1 e0 02             	shl    $0x2,%eax
  8032a7:	05 44 20 81 00       	add    $0x812044,%eax
  8032ac:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8032ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b1:	89 d0                	mov    %edx,%eax
  8032b3:	01 c0                	add    %eax,%eax
  8032b5:	01 d0                	add    %edx,%eax
  8032b7:	c1 e0 02             	shl    $0x2,%eax
  8032ba:	05 48 20 81 00       	add    $0x812048,%eax
  8032bf:	c6 00 00             	movb   $0x0,(%eax)
  8032c2:	eb 01                	jmp    8032c5 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  8032c4:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8032c5:	ff 45 e8             	incl   -0x18(%ebp)
  8032c8:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8032cf:	0f 8e 7f fe ff ff    	jle    803154 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  8032d5:	a1 30 61 83 00       	mov    0x836130,%eax
  8032da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8032dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032e4:	eb 53                	jmp    803339 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  8032e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032e9:	89 d0                	mov    %edx,%eax
  8032eb:	01 c0                	add    %eax,%eax
  8032ed:	01 d0                	add    %edx,%eax
  8032ef:	c1 e0 02             	shl    $0x2,%eax
  8032f2:	05 48 60 80 00       	add    $0x806048,%eax
  8032f7:	8a 00                	mov    (%eax),%al
  8032f9:	84 c0                	test   %al,%al
  8032fb:	74 39                	je     803336 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8032fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803300:	89 d0                	mov    %edx,%eax
  803302:	01 c0                	add    %eax,%eax
  803304:	01 d0                	add    %edx,%eax
  803306:	c1 e0 02             	shl    $0x2,%eax
  803309:	05 40 60 80 00       	add    $0x806040,%eax
  80330e:	8b 08                	mov    (%eax),%ecx
  803310:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803313:	89 d0                	mov    %edx,%eax
  803315:	01 c0                	add    %eax,%eax
  803317:	01 d0                	add    %edx,%eax
  803319:	c1 e0 02             	shl    $0x2,%eax
  80331c:	05 44 60 80 00       	add    $0x806044,%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	01 c8                	add    %ecx,%eax
  803325:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803328:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80332b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80332e:	76 06                	jbe    803336 <sfree+0x321>
  803330:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803336:	ff 45 e0             	incl   -0x20(%ebp)
  803339:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803340:	7e a4                	jle    8032e6 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803345:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  80334a:	eb 16                	jmp    803362 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80334c:	ff 45 f4             	incl   -0xc(%ebp)
  80334f:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803356:	0f 8e 04 fd ff ff    	jle    803060 <sfree+0x4b>
  80335c:	eb 04                	jmp    803362 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  80335e:	90                   	nop
  80335f:	eb 01                	jmp    803362 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803361:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803362:	c9                   	leave  
  803363:	c3                   	ret    

00803364 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803364:	55                   	push   %ebp
  803365:	89 e5                	mov    %esp,%ebp
  803367:	57                   	push   %edi
  803368:	56                   	push   %esi
  803369:	53                   	push   %ebx
  80336a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	8b 55 0c             	mov    0xc(%ebp),%edx
  803373:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803376:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803379:	8b 7d 18             	mov    0x18(%ebp),%edi
  80337c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80337f:	cd 30                	int    $0x30
  803381:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803387:	83 c4 10             	add    $0x10,%esp
  80338a:	5b                   	pop    %ebx
  80338b:	5e                   	pop    %esi
  80338c:	5f                   	pop    %edi
  80338d:	5d                   	pop    %ebp
  80338e:	c3                   	ret    

0080338f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80338f:	55                   	push   %ebp
  803390:	89 e5                	mov    %esp,%ebp
  803392:	83 ec 04             	sub    $0x4,%esp
  803395:	8b 45 10             	mov    0x10(%ebp),%eax
  803398:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80339b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80339e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	6a 00                	push   $0x0
  8033a7:	51                   	push   %ecx
  8033a8:	52                   	push   %edx
  8033a9:	ff 75 0c             	pushl  0xc(%ebp)
  8033ac:	50                   	push   %eax
  8033ad:	6a 00                	push   $0x0
  8033af:	e8 b0 ff ff ff       	call   803364 <syscall>
  8033b4:	83 c4 18             	add    $0x18,%esp
}
  8033b7:	90                   	nop
  8033b8:	c9                   	leave  
  8033b9:	c3                   	ret    

008033ba <sys_cgetc>:

int
sys_cgetc(void)
{
  8033ba:	55                   	push   %ebp
  8033bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8033bd:	6a 00                	push   $0x0
  8033bf:	6a 00                	push   $0x0
  8033c1:	6a 00                	push   $0x0
  8033c3:	6a 00                	push   $0x0
  8033c5:	6a 00                	push   $0x0
  8033c7:	6a 02                	push   $0x2
  8033c9:	e8 96 ff ff ff       	call   803364 <syscall>
  8033ce:	83 c4 18             	add    $0x18,%esp
}
  8033d1:	c9                   	leave  
  8033d2:	c3                   	ret    

008033d3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8033d3:	55                   	push   %ebp
  8033d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8033d6:	6a 00                	push   $0x0
  8033d8:	6a 00                	push   $0x0
  8033da:	6a 00                	push   $0x0
  8033dc:	6a 00                	push   $0x0
  8033de:	6a 00                	push   $0x0
  8033e0:	6a 03                	push   $0x3
  8033e2:	e8 7d ff ff ff       	call   803364 <syscall>
  8033e7:	83 c4 18             	add    $0x18,%esp
}
  8033ea:	90                   	nop
  8033eb:	c9                   	leave  
  8033ec:	c3                   	ret    

008033ed <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8033ed:	55                   	push   %ebp
  8033ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8033f0:	6a 00                	push   $0x0
  8033f2:	6a 00                	push   $0x0
  8033f4:	6a 00                	push   $0x0
  8033f6:	6a 00                	push   $0x0
  8033f8:	6a 00                	push   $0x0
  8033fa:	6a 04                	push   $0x4
  8033fc:	e8 63 ff ff ff       	call   803364 <syscall>
  803401:	83 c4 18             	add    $0x18,%esp
}
  803404:	90                   	nop
  803405:	c9                   	leave  
  803406:	c3                   	ret    

00803407 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803407:	55                   	push   %ebp
  803408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80340a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	6a 00                	push   $0x0
  803412:	6a 00                	push   $0x0
  803414:	6a 00                	push   $0x0
  803416:	52                   	push   %edx
  803417:	50                   	push   %eax
  803418:	6a 08                	push   $0x8
  80341a:	e8 45 ff ff ff       	call   803364 <syscall>
  80341f:	83 c4 18             	add    $0x18,%esp
}
  803422:	c9                   	leave  
  803423:	c3                   	ret    

00803424 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803424:	55                   	push   %ebp
  803425:	89 e5                	mov    %esp,%ebp
  803427:	56                   	push   %esi
  803428:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803429:	8b 75 18             	mov    0x18(%ebp),%esi
  80342c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80342f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803432:	8b 55 0c             	mov    0xc(%ebp),%edx
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	56                   	push   %esi
  803439:	53                   	push   %ebx
  80343a:	51                   	push   %ecx
  80343b:	52                   	push   %edx
  80343c:	50                   	push   %eax
  80343d:	6a 09                	push   $0x9
  80343f:	e8 20 ff ff ff       	call   803364 <syscall>
  803444:	83 c4 18             	add    $0x18,%esp
}
  803447:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80344a:	5b                   	pop    %ebx
  80344b:	5e                   	pop    %esi
  80344c:	5d                   	pop    %ebp
  80344d:	c3                   	ret    

0080344e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80344e:	55                   	push   %ebp
  80344f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803451:	6a 00                	push   $0x0
  803453:	6a 00                	push   $0x0
  803455:	6a 00                	push   $0x0
  803457:	6a 00                	push   $0x0
  803459:	ff 75 08             	pushl  0x8(%ebp)
  80345c:	6a 0a                	push   $0xa
  80345e:	e8 01 ff ff ff       	call   803364 <syscall>
  803463:	83 c4 18             	add    $0x18,%esp
}
  803466:	c9                   	leave  
  803467:	c3                   	ret    

00803468 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803468:	55                   	push   %ebp
  803469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80346b:	6a 00                	push   $0x0
  80346d:	6a 00                	push   $0x0
  80346f:	6a 00                	push   $0x0
  803471:	ff 75 0c             	pushl  0xc(%ebp)
  803474:	ff 75 08             	pushl  0x8(%ebp)
  803477:	6a 0b                	push   $0xb
  803479:	e8 e6 fe ff ff       	call   803364 <syscall>
  80347e:	83 c4 18             	add    $0x18,%esp
}
  803481:	c9                   	leave  
  803482:	c3                   	ret    

00803483 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803483:	55                   	push   %ebp
  803484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803486:	6a 00                	push   $0x0
  803488:	6a 00                	push   $0x0
  80348a:	6a 00                	push   $0x0
  80348c:	6a 00                	push   $0x0
  80348e:	6a 00                	push   $0x0
  803490:	6a 0c                	push   $0xc
  803492:	e8 cd fe ff ff       	call   803364 <syscall>
  803497:	83 c4 18             	add    $0x18,%esp
}
  80349a:	c9                   	leave  
  80349b:	c3                   	ret    

0080349c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80349c:	55                   	push   %ebp
  80349d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80349f:	6a 00                	push   $0x0
  8034a1:	6a 00                	push   $0x0
  8034a3:	6a 00                	push   $0x0
  8034a5:	6a 00                	push   $0x0
  8034a7:	6a 00                	push   $0x0
  8034a9:	6a 0d                	push   $0xd
  8034ab:	e8 b4 fe ff ff       	call   803364 <syscall>
  8034b0:	83 c4 18             	add    $0x18,%esp
}
  8034b3:	c9                   	leave  
  8034b4:	c3                   	ret    

008034b5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8034b5:	55                   	push   %ebp
  8034b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8034b8:	6a 00                	push   $0x0
  8034ba:	6a 00                	push   $0x0
  8034bc:	6a 00                	push   $0x0
  8034be:	6a 00                	push   $0x0
  8034c0:	6a 00                	push   $0x0
  8034c2:	6a 0e                	push   $0xe
  8034c4:	e8 9b fe ff ff       	call   803364 <syscall>
  8034c9:	83 c4 18             	add    $0x18,%esp
}
  8034cc:	c9                   	leave  
  8034cd:	c3                   	ret    

008034ce <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8034ce:	55                   	push   %ebp
  8034cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8034d1:	6a 00                	push   $0x0
  8034d3:	6a 00                	push   $0x0
  8034d5:	6a 00                	push   $0x0
  8034d7:	6a 00                	push   $0x0
  8034d9:	6a 00                	push   $0x0
  8034db:	6a 0f                	push   $0xf
  8034dd:	e8 82 fe ff ff       	call   803364 <syscall>
  8034e2:	83 c4 18             	add    $0x18,%esp
}
  8034e5:	c9                   	leave  
  8034e6:	c3                   	ret    

008034e7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8034e7:	55                   	push   %ebp
  8034e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8034ea:	6a 00                	push   $0x0
  8034ec:	6a 00                	push   $0x0
  8034ee:	6a 00                	push   $0x0
  8034f0:	6a 00                	push   $0x0
  8034f2:	ff 75 08             	pushl  0x8(%ebp)
  8034f5:	6a 10                	push   $0x10
  8034f7:	e8 68 fe ff ff       	call   803364 <syscall>
  8034fc:	83 c4 18             	add    $0x18,%esp
}
  8034ff:	c9                   	leave  
  803500:	c3                   	ret    

00803501 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803501:	55                   	push   %ebp
  803502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803504:	6a 00                	push   $0x0
  803506:	6a 00                	push   $0x0
  803508:	6a 00                	push   $0x0
  80350a:	6a 00                	push   $0x0
  80350c:	6a 00                	push   $0x0
  80350e:	6a 11                	push   $0x11
  803510:	e8 4f fe ff ff       	call   803364 <syscall>
  803515:	83 c4 18             	add    $0x18,%esp
}
  803518:	90                   	nop
  803519:	c9                   	leave  
  80351a:	c3                   	ret    

0080351b <sys_cputc>:

void
sys_cputc(const char c)
{
  80351b:	55                   	push   %ebp
  80351c:	89 e5                	mov    %esp,%ebp
  80351e:	83 ec 04             	sub    $0x4,%esp
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803527:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80352b:	6a 00                	push   $0x0
  80352d:	6a 00                	push   $0x0
  80352f:	6a 00                	push   $0x0
  803531:	6a 00                	push   $0x0
  803533:	50                   	push   %eax
  803534:	6a 01                	push   $0x1
  803536:	e8 29 fe ff ff       	call   803364 <syscall>
  80353b:	83 c4 18             	add    $0x18,%esp
}
  80353e:	90                   	nop
  80353f:	c9                   	leave  
  803540:	c3                   	ret    

00803541 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803541:	55                   	push   %ebp
  803542:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803544:	6a 00                	push   $0x0
  803546:	6a 00                	push   $0x0
  803548:	6a 00                	push   $0x0
  80354a:	6a 00                	push   $0x0
  80354c:	6a 00                	push   $0x0
  80354e:	6a 14                	push   $0x14
  803550:	e8 0f fe ff ff       	call   803364 <syscall>
  803555:	83 c4 18             	add    $0x18,%esp
}
  803558:	90                   	nop
  803559:	c9                   	leave  
  80355a:	c3                   	ret    

0080355b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80355b:	55                   	push   %ebp
  80355c:	89 e5                	mov    %esp,%ebp
  80355e:	83 ec 04             	sub    $0x4,%esp
  803561:	8b 45 10             	mov    0x10(%ebp),%eax
  803564:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803567:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80356a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	6a 00                	push   $0x0
  803573:	51                   	push   %ecx
  803574:	52                   	push   %edx
  803575:	ff 75 0c             	pushl  0xc(%ebp)
  803578:	50                   	push   %eax
  803579:	6a 15                	push   $0x15
  80357b:	e8 e4 fd ff ff       	call   803364 <syscall>
  803580:	83 c4 18             	add    $0x18,%esp
}
  803583:	c9                   	leave  
  803584:	c3                   	ret    

00803585 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803585:	55                   	push   %ebp
  803586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	6a 00                	push   $0x0
  803590:	6a 00                	push   $0x0
  803592:	6a 00                	push   $0x0
  803594:	52                   	push   %edx
  803595:	50                   	push   %eax
  803596:	6a 16                	push   $0x16
  803598:	e8 c7 fd ff ff       	call   803364 <syscall>
  80359d:	83 c4 18             	add    $0x18,%esp
}
  8035a0:	c9                   	leave  
  8035a1:	c3                   	ret    

008035a2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8035a2:	55                   	push   %ebp
  8035a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8035a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8035a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	6a 00                	push   $0x0
  8035b0:	6a 00                	push   $0x0
  8035b2:	51                   	push   %ecx
  8035b3:	52                   	push   %edx
  8035b4:	50                   	push   %eax
  8035b5:	6a 17                	push   $0x17
  8035b7:	e8 a8 fd ff ff       	call   803364 <syscall>
  8035bc:	83 c4 18             	add    $0x18,%esp
}
  8035bf:	c9                   	leave  
  8035c0:	c3                   	ret    

008035c1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8035c1:	55                   	push   %ebp
  8035c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8035c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	6a 00                	push   $0x0
  8035cc:	6a 00                	push   $0x0
  8035ce:	6a 00                	push   $0x0
  8035d0:	52                   	push   %edx
  8035d1:	50                   	push   %eax
  8035d2:	6a 18                	push   $0x18
  8035d4:	e8 8b fd ff ff       	call   803364 <syscall>
  8035d9:	83 c4 18             	add    $0x18,%esp
}
  8035dc:	c9                   	leave  
  8035dd:	c3                   	ret    

008035de <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8035de:	55                   	push   %ebp
  8035df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	6a 00                	push   $0x0
  8035e6:	ff 75 14             	pushl  0x14(%ebp)
  8035e9:	ff 75 10             	pushl  0x10(%ebp)
  8035ec:	ff 75 0c             	pushl  0xc(%ebp)
  8035ef:	50                   	push   %eax
  8035f0:	6a 19                	push   $0x19
  8035f2:	e8 6d fd ff ff       	call   803364 <syscall>
  8035f7:	83 c4 18             	add    $0x18,%esp
}
  8035fa:	c9                   	leave  
  8035fb:	c3                   	ret    

008035fc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8035fc:	55                   	push   %ebp
  8035fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	6a 00                	push   $0x0
  803604:	6a 00                	push   $0x0
  803606:	6a 00                	push   $0x0
  803608:	6a 00                	push   $0x0
  80360a:	50                   	push   %eax
  80360b:	6a 1a                	push   $0x1a
  80360d:	e8 52 fd ff ff       	call   803364 <syscall>
  803612:	83 c4 18             	add    $0x18,%esp
}
  803615:	90                   	nop
  803616:	c9                   	leave  
  803617:	c3                   	ret    

00803618 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803618:	55                   	push   %ebp
  803619:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	6a 00                	push   $0x0
  803620:	6a 00                	push   $0x0
  803622:	6a 00                	push   $0x0
  803624:	6a 00                	push   $0x0
  803626:	50                   	push   %eax
  803627:	6a 1b                	push   $0x1b
  803629:	e8 36 fd ff ff       	call   803364 <syscall>
  80362e:	83 c4 18             	add    $0x18,%esp
}
  803631:	c9                   	leave  
  803632:	c3                   	ret    

00803633 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803633:	55                   	push   %ebp
  803634:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803636:	6a 00                	push   $0x0
  803638:	6a 00                	push   $0x0
  80363a:	6a 00                	push   $0x0
  80363c:	6a 00                	push   $0x0
  80363e:	6a 00                	push   $0x0
  803640:	6a 05                	push   $0x5
  803642:	e8 1d fd ff ff       	call   803364 <syscall>
  803647:	83 c4 18             	add    $0x18,%esp
}
  80364a:	c9                   	leave  
  80364b:	c3                   	ret    

0080364c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80364c:	55                   	push   %ebp
  80364d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80364f:	6a 00                	push   $0x0
  803651:	6a 00                	push   $0x0
  803653:	6a 00                	push   $0x0
  803655:	6a 00                	push   $0x0
  803657:	6a 00                	push   $0x0
  803659:	6a 06                	push   $0x6
  80365b:	e8 04 fd ff ff       	call   803364 <syscall>
  803660:	83 c4 18             	add    $0x18,%esp
}
  803663:	c9                   	leave  
  803664:	c3                   	ret    

00803665 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803665:	55                   	push   %ebp
  803666:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803668:	6a 00                	push   $0x0
  80366a:	6a 00                	push   $0x0
  80366c:	6a 00                	push   $0x0
  80366e:	6a 00                	push   $0x0
  803670:	6a 00                	push   $0x0
  803672:	6a 07                	push   $0x7
  803674:	e8 eb fc ff ff       	call   803364 <syscall>
  803679:	83 c4 18             	add    $0x18,%esp
}
  80367c:	c9                   	leave  
  80367d:	c3                   	ret    

0080367e <sys_exit_env>:


void sys_exit_env(void)
{
  80367e:	55                   	push   %ebp
  80367f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803681:	6a 00                	push   $0x0
  803683:	6a 00                	push   $0x0
  803685:	6a 00                	push   $0x0
  803687:	6a 00                	push   $0x0
  803689:	6a 00                	push   $0x0
  80368b:	6a 1c                	push   $0x1c
  80368d:	e8 d2 fc ff ff       	call   803364 <syscall>
  803692:	83 c4 18             	add    $0x18,%esp
}
  803695:	90                   	nop
  803696:	c9                   	leave  
  803697:	c3                   	ret    

00803698 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803698:	55                   	push   %ebp
  803699:	89 e5                	mov    %esp,%ebp
  80369b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80369e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8036a1:	8d 50 04             	lea    0x4(%eax),%edx
  8036a4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8036a7:	6a 00                	push   $0x0
  8036a9:	6a 00                	push   $0x0
  8036ab:	6a 00                	push   $0x0
  8036ad:	52                   	push   %edx
  8036ae:	50                   	push   %eax
  8036af:	6a 1d                	push   $0x1d
  8036b1:	e8 ae fc ff ff       	call   803364 <syscall>
  8036b6:	83 c4 18             	add    $0x18,%esp
	return result;
  8036b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8036bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8036bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036c2:	89 01                	mov    %eax,(%ecx)
  8036c4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	c9                   	leave  
  8036cb:	c2 04 00             	ret    $0x4

008036ce <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8036ce:	55                   	push   %ebp
  8036cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8036d1:	6a 00                	push   $0x0
  8036d3:	6a 00                	push   $0x0
  8036d5:	ff 75 10             	pushl  0x10(%ebp)
  8036d8:	ff 75 0c             	pushl  0xc(%ebp)
  8036db:	ff 75 08             	pushl  0x8(%ebp)
  8036de:	6a 13                	push   $0x13
  8036e0:	e8 7f fc ff ff       	call   803364 <syscall>
  8036e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8036e8:	90                   	nop
}
  8036e9:	c9                   	leave  
  8036ea:	c3                   	ret    

008036eb <sys_rcr2>:
uint32 sys_rcr2()
{
  8036eb:	55                   	push   %ebp
  8036ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8036ee:	6a 00                	push   $0x0
  8036f0:	6a 00                	push   $0x0
  8036f2:	6a 00                	push   $0x0
  8036f4:	6a 00                	push   $0x0
  8036f6:	6a 00                	push   $0x0
  8036f8:	6a 1e                	push   $0x1e
  8036fa:	e8 65 fc ff ff       	call   803364 <syscall>
  8036ff:	83 c4 18             	add    $0x18,%esp
}
  803702:	c9                   	leave  
  803703:	c3                   	ret    

00803704 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803704:	55                   	push   %ebp
  803705:	89 e5                	mov    %esp,%ebp
  803707:	83 ec 04             	sub    $0x4,%esp
  80370a:	8b 45 08             	mov    0x8(%ebp),%eax
  80370d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803710:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803714:	6a 00                	push   $0x0
  803716:	6a 00                	push   $0x0
  803718:	6a 00                	push   $0x0
  80371a:	6a 00                	push   $0x0
  80371c:	50                   	push   %eax
  80371d:	6a 1f                	push   $0x1f
  80371f:	e8 40 fc ff ff       	call   803364 <syscall>
  803724:	83 c4 18             	add    $0x18,%esp
	return ;
  803727:	90                   	nop
}
  803728:	c9                   	leave  
  803729:	c3                   	ret    

0080372a <rsttst>:
void rsttst()
{
  80372a:	55                   	push   %ebp
  80372b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80372d:	6a 00                	push   $0x0
  80372f:	6a 00                	push   $0x0
  803731:	6a 00                	push   $0x0
  803733:	6a 00                	push   $0x0
  803735:	6a 00                	push   $0x0
  803737:	6a 21                	push   $0x21
  803739:	e8 26 fc ff ff       	call   803364 <syscall>
  80373e:	83 c4 18             	add    $0x18,%esp
	return ;
  803741:	90                   	nop
}
  803742:	c9                   	leave  
  803743:	c3                   	ret    

00803744 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803744:	55                   	push   %ebp
  803745:	89 e5                	mov    %esp,%ebp
  803747:	83 ec 04             	sub    $0x4,%esp
  80374a:	8b 45 14             	mov    0x14(%ebp),%eax
  80374d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803750:	8b 55 18             	mov    0x18(%ebp),%edx
  803753:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803757:	52                   	push   %edx
  803758:	50                   	push   %eax
  803759:	ff 75 10             	pushl  0x10(%ebp)
  80375c:	ff 75 0c             	pushl  0xc(%ebp)
  80375f:	ff 75 08             	pushl  0x8(%ebp)
  803762:	6a 20                	push   $0x20
  803764:	e8 fb fb ff ff       	call   803364 <syscall>
  803769:	83 c4 18             	add    $0x18,%esp
	return ;
  80376c:	90                   	nop
}
  80376d:	c9                   	leave  
  80376e:	c3                   	ret    

0080376f <chktst>:
void chktst(uint32 n)
{
  80376f:	55                   	push   %ebp
  803770:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803772:	6a 00                	push   $0x0
  803774:	6a 00                	push   $0x0
  803776:	6a 00                	push   $0x0
  803778:	6a 00                	push   $0x0
  80377a:	ff 75 08             	pushl  0x8(%ebp)
  80377d:	6a 22                	push   $0x22
  80377f:	e8 e0 fb ff ff       	call   803364 <syscall>
  803784:	83 c4 18             	add    $0x18,%esp
	return ;
  803787:	90                   	nop
}
  803788:	c9                   	leave  
  803789:	c3                   	ret    

0080378a <inctst>:

void inctst()
{
  80378a:	55                   	push   %ebp
  80378b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80378d:	6a 00                	push   $0x0
  80378f:	6a 00                	push   $0x0
  803791:	6a 00                	push   $0x0
  803793:	6a 00                	push   $0x0
  803795:	6a 00                	push   $0x0
  803797:	6a 23                	push   $0x23
  803799:	e8 c6 fb ff ff       	call   803364 <syscall>
  80379e:	83 c4 18             	add    $0x18,%esp
	return ;
  8037a1:	90                   	nop
}
  8037a2:	c9                   	leave  
  8037a3:	c3                   	ret    

008037a4 <gettst>:
uint32 gettst()
{
  8037a4:	55                   	push   %ebp
  8037a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8037a7:	6a 00                	push   $0x0
  8037a9:	6a 00                	push   $0x0
  8037ab:	6a 00                	push   $0x0
  8037ad:	6a 00                	push   $0x0
  8037af:	6a 00                	push   $0x0
  8037b1:	6a 24                	push   $0x24
  8037b3:	e8 ac fb ff ff       	call   803364 <syscall>
  8037b8:	83 c4 18             	add    $0x18,%esp
}
  8037bb:	c9                   	leave  
  8037bc:	c3                   	ret    

008037bd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8037bd:	55                   	push   %ebp
  8037be:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8037c0:	6a 00                	push   $0x0
  8037c2:	6a 00                	push   $0x0
  8037c4:	6a 00                	push   $0x0
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	6a 25                	push   $0x25
  8037cc:	e8 93 fb ff ff       	call   803364 <syscall>
  8037d1:	83 c4 18             	add    $0x18,%esp
  8037d4:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  8037d9:	a1 80 60 83 00       	mov    0x836080,%eax
}
  8037de:	c9                   	leave  
  8037df:	c3                   	ret    

008037e0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8037e0:	55                   	push   %ebp
  8037e1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8037eb:	6a 00                	push   $0x0
  8037ed:	6a 00                	push   $0x0
  8037ef:	6a 00                	push   $0x0
  8037f1:	6a 00                	push   $0x0
  8037f3:	ff 75 08             	pushl  0x8(%ebp)
  8037f6:	6a 26                	push   $0x26
  8037f8:	e8 67 fb ff ff       	call   803364 <syscall>
  8037fd:	83 c4 18             	add    $0x18,%esp
	return ;
  803800:	90                   	nop
}
  803801:	c9                   	leave  
  803802:	c3                   	ret    

00803803 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803803:	55                   	push   %ebp
  803804:	89 e5                	mov    %esp,%ebp
  803806:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803807:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80380a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80380d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	6a 00                	push   $0x0
  803815:	53                   	push   %ebx
  803816:	51                   	push   %ecx
  803817:	52                   	push   %edx
  803818:	50                   	push   %eax
  803819:	6a 27                	push   $0x27
  80381b:	e8 44 fb ff ff       	call   803364 <syscall>
  803820:	83 c4 18             	add    $0x18,%esp
}
  803823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803826:	c9                   	leave  
  803827:	c3                   	ret    

00803828 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803828:	55                   	push   %ebp
  803829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80382b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80382e:	8b 45 08             	mov    0x8(%ebp),%eax
  803831:	6a 00                	push   $0x0
  803833:	6a 00                	push   $0x0
  803835:	6a 00                	push   $0x0
  803837:	52                   	push   %edx
  803838:	50                   	push   %eax
  803839:	6a 28                	push   $0x28
  80383b:	e8 24 fb ff ff       	call   803364 <syscall>
  803840:	83 c4 18             	add    $0x18,%esp
}
  803843:	c9                   	leave  
  803844:	c3                   	ret    

00803845 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803845:	55                   	push   %ebp
  803846:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803848:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80384b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	6a 00                	push   $0x0
  803853:	51                   	push   %ecx
  803854:	ff 75 10             	pushl  0x10(%ebp)
  803857:	52                   	push   %edx
  803858:	50                   	push   %eax
  803859:	6a 29                	push   $0x29
  80385b:	e8 04 fb ff ff       	call   803364 <syscall>
  803860:	83 c4 18             	add    $0x18,%esp
}
  803863:	c9                   	leave  
  803864:	c3                   	ret    

00803865 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803865:	55                   	push   %ebp
  803866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803868:	6a 00                	push   $0x0
  80386a:	6a 00                	push   $0x0
  80386c:	ff 75 10             	pushl  0x10(%ebp)
  80386f:	ff 75 0c             	pushl  0xc(%ebp)
  803872:	ff 75 08             	pushl  0x8(%ebp)
  803875:	6a 12                	push   $0x12
  803877:	e8 e8 fa ff ff       	call   803364 <syscall>
  80387c:	83 c4 18             	add    $0x18,%esp
	return ;
  80387f:	90                   	nop
}
  803880:	c9                   	leave  
  803881:	c3                   	ret    

00803882 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803882:	55                   	push   %ebp
  803883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803885:	8b 55 0c             	mov    0xc(%ebp),%edx
  803888:	8b 45 08             	mov    0x8(%ebp),%eax
  80388b:	6a 00                	push   $0x0
  80388d:	6a 00                	push   $0x0
  80388f:	6a 00                	push   $0x0
  803891:	52                   	push   %edx
  803892:	50                   	push   %eax
  803893:	6a 2a                	push   $0x2a
  803895:	e8 ca fa ff ff       	call   803364 <syscall>
  80389a:	83 c4 18             	add    $0x18,%esp
	return;
  80389d:	90                   	nop
}
  80389e:	c9                   	leave  
  80389f:	c3                   	ret    

008038a0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8038a0:	55                   	push   %ebp
  8038a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8038a3:	6a 00                	push   $0x0
  8038a5:	6a 00                	push   $0x0
  8038a7:	6a 00                	push   $0x0
  8038a9:	6a 00                	push   $0x0
  8038ab:	6a 00                	push   $0x0
  8038ad:	6a 2b                	push   $0x2b
  8038af:	e8 b0 fa ff ff       	call   803364 <syscall>
  8038b4:	83 c4 18             	add    $0x18,%esp
}
  8038b7:	c9                   	leave  
  8038b8:	c3                   	ret    

008038b9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8038b9:	55                   	push   %ebp
  8038ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8038bc:	6a 00                	push   $0x0
  8038be:	6a 00                	push   $0x0
  8038c0:	6a 00                	push   $0x0
  8038c2:	ff 75 0c             	pushl  0xc(%ebp)
  8038c5:	ff 75 08             	pushl  0x8(%ebp)
  8038c8:	6a 2d                	push   $0x2d
  8038ca:	e8 95 fa ff ff       	call   803364 <syscall>
  8038cf:	83 c4 18             	add    $0x18,%esp
	return;
  8038d2:	90                   	nop
}
  8038d3:	c9                   	leave  
  8038d4:	c3                   	ret    

008038d5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8038d5:	55                   	push   %ebp
  8038d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8038d8:	6a 00                	push   $0x0
  8038da:	6a 00                	push   $0x0
  8038dc:	6a 00                	push   $0x0
  8038de:	ff 75 0c             	pushl  0xc(%ebp)
  8038e1:	ff 75 08             	pushl  0x8(%ebp)
  8038e4:	6a 2c                	push   $0x2c
  8038e6:	e8 79 fa ff ff       	call   803364 <syscall>
  8038eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8038ee:	90                   	nop
}
  8038ef:	c9                   	leave  
  8038f0:	c3                   	ret    

008038f1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8038f1:	55                   	push   %ebp
  8038f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8038f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fa:	6a 00                	push   $0x0
  8038fc:	6a 00                	push   $0x0
  8038fe:	6a 00                	push   $0x0
  803900:	52                   	push   %edx
  803901:	50                   	push   %eax
  803902:	6a 2e                	push   $0x2e
  803904:	e8 5b fa ff ff       	call   803364 <syscall>
  803909:	83 c4 18             	add    $0x18,%esp
}
  80390c:	90                   	nop
  80390d:	c9                   	leave  
  80390e:	c3                   	ret    

0080390f <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80390f:	55                   	push   %ebp
  803910:	89 e5                	mov    %esp,%ebp
  803912:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803915:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  80391c:	72 09                	jb     803927 <to_page_va+0x18>
  80391e:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803925:	72 14                	jb     80393b <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803927:	83 ec 04             	sub    $0x4,%esp
  80392a:	68 ac 4e 80 00       	push   $0x804eac
  80392f:	6a 15                	push   $0x15
  803931:	68 d7 4e 80 00       	push   $0x804ed7
  803936:	e8 08 ce ff ff       	call   800743 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803943:	29 d0                	sub    %edx,%eax
  803945:	c1 f8 02             	sar    $0x2,%eax
  803948:	89 c2                	mov    %eax,%edx
  80394a:	89 d0                	mov    %edx,%eax
  80394c:	c1 e0 02             	shl    $0x2,%eax
  80394f:	01 d0                	add    %edx,%eax
  803951:	c1 e0 02             	shl    $0x2,%eax
  803954:	01 d0                	add    %edx,%eax
  803956:	c1 e0 02             	shl    $0x2,%eax
  803959:	01 d0                	add    %edx,%eax
  80395b:	89 c1                	mov    %eax,%ecx
  80395d:	c1 e1 08             	shl    $0x8,%ecx
  803960:	01 c8                	add    %ecx,%eax
  803962:	89 c1                	mov    %eax,%ecx
  803964:	c1 e1 10             	shl    $0x10,%ecx
  803967:	01 c8                	add    %ecx,%eax
  803969:	01 c0                	add    %eax,%eax
  80396b:	01 d0                	add    %edx,%eax
  80396d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803973:	c1 e0 0c             	shl    $0xc,%eax
  803976:	89 c2                	mov    %eax,%edx
  803978:	a1 84 60 83 00       	mov    0x836084,%eax
  80397d:	01 d0                	add    %edx,%eax
}
  80397f:	c9                   	leave  
  803980:	c3                   	ret    

00803981 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803981:	55                   	push   %ebp
  803982:	89 e5                	mov    %esp,%ebp
  803984:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803987:	a1 84 60 83 00       	mov    0x836084,%eax
  80398c:	8b 55 08             	mov    0x8(%ebp),%edx
  80398f:	29 c2                	sub    %eax,%edx
  803991:	89 d0                	mov    %edx,%eax
  803993:	c1 e8 0c             	shr    $0xc,%eax
  803996:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80399d:	78 09                	js     8039a8 <to_page_info+0x27>
  80399f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8039a6:	7e 14                	jle    8039bc <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8039a8:	83 ec 04             	sub    $0x4,%esp
  8039ab:	68 f0 4e 80 00       	push   $0x804ef0
  8039b0:	6a 21                	push   $0x21
  8039b2:	68 d7 4e 80 00       	push   $0x804ed7
  8039b7:	e8 87 cd ff ff       	call   800743 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8039bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039bf:	89 d0                	mov    %edx,%eax
  8039c1:	01 c0                	add    %eax,%eax
  8039c3:	01 d0                	add    %edx,%eax
  8039c5:	c1 e0 02             	shl    $0x2,%eax
  8039c8:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  8039cd:	c9                   	leave  
  8039ce:	c3                   	ret    

008039cf <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8039cf:	55                   	push   %ebp
  8039d0:	89 e5                	mov    %esp,%ebp
  8039d2:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8039d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d8:	05 00 00 00 02       	add    $0x2000000,%eax
  8039dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039e0:	73 16                	jae    8039f8 <initialize_dynamic_allocator+0x29>
  8039e2:	68 14 4f 80 00       	push   $0x804f14
  8039e7:	68 3a 4f 80 00       	push   $0x804f3a
  8039ec:	6a 2f                	push   $0x2f
  8039ee:	68 d7 4e 80 00       	push   $0x804ed7
  8039f3:	e8 4b cd ff ff       	call   800743 <_panic>
	dynAllocStart = daStart;
  8039f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fb:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a03:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a0f:	eb 36                	jmp    803a47 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a14:	c1 e0 04             	shl    $0x4,%eax
  803a17:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803a1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a25:	c1 e0 04             	shl    $0x4,%eax
  803a28:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a36:	c1 e0 04             	shl    $0x4,%eax
  803a39:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a44:	ff 45 f4             	incl   -0xc(%ebp)
  803a47:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803a4b:	7e c4                	jle    803a11 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803a4d:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803a54:	00 00 00 
  803a57:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803a5e:	00 00 00 
  803a61:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803a68:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803a6b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a72:	e9 1b 01 00 00       	jmp    803b92 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803a77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a7a:	89 d0                	mov    %edx,%eax
  803a7c:	01 c0                	add    %eax,%eax
  803a7e:	01 d0                	add    %edx,%eax
  803a80:	c1 e0 02             	shl    $0x2,%eax
  803a83:	05 88 e0 81 00       	add    $0x81e088,%eax
  803a88:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803a8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a90:	89 d0                	mov    %edx,%eax
  803a92:	01 c0                	add    %eax,%eax
  803a94:	01 d0                	add    %edx,%eax
  803a96:	c1 e0 02             	shl    $0x2,%eax
  803a99:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803a9e:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803aa3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aa6:	89 d0                	mov    %edx,%eax
  803aa8:	01 c0                	add    %eax,%eax
  803aaa:	01 d0                	add    %edx,%eax
  803aac:	c1 e0 02             	shl    $0x2,%eax
  803aaf:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ab4:	8b 00                	mov    (%eax),%eax
  803ab6:	85 c0                	test   %eax,%eax
  803ab8:	74 2b                	je     803ae5 <initialize_dynamic_allocator+0x116>
  803aba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803abd:	89 d0                	mov    %edx,%eax
  803abf:	01 c0                	add    %eax,%eax
  803ac1:	01 d0                	add    %edx,%eax
  803ac3:	c1 e0 02             	shl    $0x2,%eax
  803ac6:	05 80 e0 81 00       	add    $0x81e080,%eax
  803acb:	8b 10                	mov    (%eax),%edx
  803acd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803ad0:	89 c8                	mov    %ecx,%eax
  803ad2:	01 c0                	add    %eax,%eax
  803ad4:	01 c8                	add    %ecx,%eax
  803ad6:	c1 e0 02             	shl    $0x2,%eax
  803ad9:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ade:	8b 00                	mov    (%eax),%eax
  803ae0:	89 42 04             	mov    %eax,0x4(%edx)
  803ae3:	eb 18                	jmp    803afd <initialize_dynamic_allocator+0x12e>
  803ae5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ae8:	89 d0                	mov    %edx,%eax
  803aea:	01 c0                	add    %eax,%eax
  803aec:	01 d0                	add    %edx,%eax
  803aee:	c1 e0 02             	shl    $0x2,%eax
  803af1:	05 84 e0 81 00       	add    $0x81e084,%eax
  803af6:	8b 00                	mov    (%eax),%eax
  803af8:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803afd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b00:	89 d0                	mov    %edx,%eax
  803b02:	01 c0                	add    %eax,%eax
  803b04:	01 d0                	add    %edx,%eax
  803b06:	c1 e0 02             	shl    $0x2,%eax
  803b09:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b0e:	8b 00                	mov    (%eax),%eax
  803b10:	85 c0                	test   %eax,%eax
  803b12:	74 2a                	je     803b3e <initialize_dynamic_allocator+0x16f>
  803b14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b17:	89 d0                	mov    %edx,%eax
  803b19:	01 c0                	add    %eax,%eax
  803b1b:	01 d0                	add    %edx,%eax
  803b1d:	c1 e0 02             	shl    $0x2,%eax
  803b20:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b25:	8b 10                	mov    (%eax),%edx
  803b27:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b2a:	89 c8                	mov    %ecx,%eax
  803b2c:	01 c0                	add    %eax,%eax
  803b2e:	01 c8                	add    %ecx,%eax
  803b30:	c1 e0 02             	shl    $0x2,%eax
  803b33:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b38:	8b 00                	mov    (%eax),%eax
  803b3a:	89 02                	mov    %eax,(%edx)
  803b3c:	eb 18                	jmp    803b56 <initialize_dynamic_allocator+0x187>
  803b3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b41:	89 d0                	mov    %edx,%eax
  803b43:	01 c0                	add    %eax,%eax
  803b45:	01 d0                	add    %edx,%eax
  803b47:	c1 e0 02             	shl    $0x2,%eax
  803b4a:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b4f:	8b 00                	mov    (%eax),%eax
  803b51:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803b56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b59:	89 d0                	mov    %edx,%eax
  803b5b:	01 c0                	add    %eax,%eax
  803b5d:	01 d0                	add    %edx,%eax
  803b5f:	c1 e0 02             	shl    $0x2,%eax
  803b62:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b70:	89 d0                	mov    %edx,%eax
  803b72:	01 c0                	add    %eax,%eax
  803b74:	01 d0                	add    %edx,%eax
  803b76:	c1 e0 02             	shl    $0x2,%eax
  803b79:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b84:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803b89:	48                   	dec    %eax
  803b8a:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803b8f:	ff 45 f0             	incl   -0x10(%ebp)
  803b92:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803b99:	0f 8e d8 fe ff ff    	jle    803a77 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803b9f:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803ba6:	e9 9d 00 00 00       	jmp    803c48 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803bab:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803bb1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803bb4:	89 c8                	mov    %ecx,%eax
  803bb6:	01 c0                	add    %eax,%eax
  803bb8:	01 c8                	add    %ecx,%eax
  803bba:	c1 e0 02             	shl    $0x2,%eax
  803bbd:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bc2:	89 10                	mov    %edx,(%eax)
  803bc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bc7:	89 d0                	mov    %edx,%eax
  803bc9:	01 c0                	add    %eax,%eax
  803bcb:	01 d0                	add    %edx,%eax
  803bcd:	c1 e0 02             	shl    $0x2,%eax
  803bd0:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bd5:	8b 00                	mov    (%eax),%eax
  803bd7:	85 c0                	test   %eax,%eax
  803bd9:	74 1c                	je     803bf7 <initialize_dynamic_allocator+0x228>
  803bdb:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803be1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803be4:	89 c8                	mov    %ecx,%eax
  803be6:	01 c0                	add    %eax,%eax
  803be8:	01 c8                	add    %ecx,%eax
  803bea:	c1 e0 02             	shl    $0x2,%eax
  803bed:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bf2:	89 42 04             	mov    %eax,0x4(%edx)
  803bf5:	eb 16                	jmp    803c0d <initialize_dynamic_allocator+0x23e>
  803bf7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bfa:	89 d0                	mov    %edx,%eax
  803bfc:	01 c0                	add    %eax,%eax
  803bfe:	01 d0                	add    %edx,%eax
  803c00:	c1 e0 02             	shl    $0x2,%eax
  803c03:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c08:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803c0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c10:	89 d0                	mov    %edx,%eax
  803c12:	01 c0                	add    %eax,%eax
  803c14:	01 d0                	add    %edx,%eax
  803c16:	c1 e0 02             	shl    $0x2,%eax
  803c19:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c1e:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803c23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c26:	89 d0                	mov    %edx,%eax
  803c28:	01 c0                	add    %eax,%eax
  803c2a:	01 d0                	add    %edx,%eax
  803c2c:	c1 e0 02             	shl    $0x2,%eax
  803c2f:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c3a:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803c3f:	40                   	inc    %eax
  803c40:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803c45:	ff 4d ec             	decl   -0x14(%ebp)
  803c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c4c:	0f 89 59 ff ff ff    	jns    803bab <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803c52:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803c59:	00 00 00 
}
  803c5c:	90                   	nop
  803c5d:	c9                   	leave  
  803c5e:	c3                   	ret    

00803c5f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803c5f:	55                   	push   %ebp
  803c60:	89 e5                	mov    %esp,%ebp
  803c62:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803c65:	8b 45 08             	mov    0x8(%ebp),%eax
  803c68:	83 ec 0c             	sub    $0xc,%esp
  803c6b:	50                   	push   %eax
  803c6c:	e8 10 fd ff ff       	call   803981 <to_page_info>
  803c71:	83 c4 10             	add    $0x10,%esp
  803c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7a:	8b 40 08             	mov    0x8(%eax),%eax
  803c7d:	0f b7 c0             	movzwl %ax,%eax
}
  803c80:	c9                   	leave  
  803c81:	c3                   	ret    

00803c82 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803c82:	55                   	push   %ebp
  803c83:	89 e5                	mov    %esp,%ebp
  803c85:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c88:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c8f:	76 16                	jbe    803ca7 <alloc_block+0x25>
  803c91:	68 50 4f 80 00       	push   $0x804f50
  803c96:	68 3a 4f 80 00       	push   $0x804f3a
  803c9b:	6a 59                	push   $0x59
  803c9d:	68 d7 4e 80 00       	push   $0x804ed7
  803ca2:	e8 9c ca ff ff       	call   800743 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803ca7:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803cae:	eb 08                	jmp    803cb8 <alloc_block+0x36>
		allocSize <<= 1;
  803cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb3:	01 c0                	add    %eax,%eax
  803cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cbe:	73 09                	jae    803cc9 <alloc_block+0x47>
  803cc0:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803cc7:	76 e7                	jbe    803cb0 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803cc9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803cd0:	eb 03                	jmp    803cd5 <alloc_block+0x53>
		listIndex++;
  803cd2:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd8:	ba 08 00 00 00       	mov    $0x8,%edx
  803cdd:	88 c1                	mov    %al,%cl
  803cdf:	d3 e2                	shl    %cl,%edx
  803ce1:	89 d0                	mov    %edx,%eax
  803ce3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803ce6:	72 ea                	jb     803cd2 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ceb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803cee:	e9 f4 00 00 00       	jmp    803de7 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cf6:	c1 e0 04             	shl    $0x4,%eax
  803cf9:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803cfe:	8b 00                	mov    (%eax),%eax
  803d00:	85 c0                	test   %eax,%eax
  803d02:	0f 84 dc 00 00 00    	je     803de4 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d0b:	c1 e0 04             	shl    $0x4,%eax
  803d0e:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d13:	8b 00                	mov    (%eax),%eax
  803d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803d18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d1c:	75 14                	jne    803d32 <alloc_block+0xb0>
  803d1e:	83 ec 04             	sub    $0x4,%esp
  803d21:	68 71 4f 80 00       	push   $0x804f71
  803d26:	6a 6b                	push   $0x6b
  803d28:	68 d7 4e 80 00       	push   $0x804ed7
  803d2d:	e8 11 ca ff ff       	call   800743 <_panic>
  803d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d35:	8b 00                	mov    (%eax),%eax
  803d37:	85 c0                	test   %eax,%eax
  803d39:	74 10                	je     803d4b <alloc_block+0xc9>
  803d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3e:	8b 00                	mov    (%eax),%eax
  803d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d43:	8b 52 04             	mov    0x4(%edx),%edx
  803d46:	89 50 04             	mov    %edx,0x4(%eax)
  803d49:	eb 14                	jmp    803d5f <alloc_block+0xdd>
  803d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4e:	8b 40 04             	mov    0x4(%eax),%eax
  803d51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d54:	c1 e2 04             	shl    $0x4,%edx
  803d57:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803d5d:	89 02                	mov    %eax,(%edx)
  803d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d62:	8b 40 04             	mov    0x4(%eax),%eax
  803d65:	85 c0                	test   %eax,%eax
  803d67:	74 0f                	je     803d78 <alloc_block+0xf6>
  803d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6c:	8b 40 04             	mov    0x4(%eax),%eax
  803d6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d72:	8b 12                	mov    (%edx),%edx
  803d74:	89 10                	mov    %edx,(%eax)
  803d76:	eb 13                	jmp    803d8b <alloc_block+0x109>
  803d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7b:	8b 00                	mov    (%eax),%eax
  803d7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d80:	c1 e2 04             	shl    $0x4,%edx
  803d83:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803d89:	89 02                	mov    %eax,(%edx)
  803d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da1:	c1 e0 04             	shl    $0x4,%eax
  803da4:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803da9:	8b 00                	mov    (%eax),%eax
  803dab:	8d 50 ff             	lea    -0x1(%eax),%edx
  803dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803db1:	c1 e0 04             	shl    $0x4,%eax
  803db4:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803db9:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbe:	83 ec 0c             	sub    $0xc,%esp
  803dc1:	50                   	push   %eax
  803dc2:	e8 ba fb ff ff       	call   803981 <to_page_info>
  803dc7:	83 c4 10             	add    $0x10,%esp
  803dca:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dd0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803dd4:	48                   	dec    %eax
  803dd5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803dd8:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ddf:	e9 8f 02 00 00       	jmp    804073 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803de4:	ff 45 ec             	incl   -0x14(%ebp)
  803de7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803deb:	0f 8e 02 ff ff ff    	jle    803cf3 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803df1:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803df6:	85 c0                	test   %eax,%eax
  803df8:	75 14                	jne    803e0e <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803dfa:	83 ec 04             	sub    $0x4,%esp
  803dfd:	68 90 4f 80 00       	push   $0x804f90
  803e02:	6a 77                	push   $0x77
  803e04:	68 d7 4e 80 00       	push   $0x804ed7
  803e09:	e8 35 c9 ff ff       	call   800743 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803e0e:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803e13:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803e16:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e1a:	75 14                	jne    803e30 <alloc_block+0x1ae>
  803e1c:	83 ec 04             	sub    $0x4,%esp
  803e1f:	68 71 4f 80 00       	push   $0x804f71
  803e24:	6a 7a                	push   $0x7a
  803e26:	68 d7 4e 80 00       	push   $0x804ed7
  803e2b:	e8 13 c9 ff ff       	call   800743 <_panic>
  803e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e33:	8b 00                	mov    (%eax),%eax
  803e35:	85 c0                	test   %eax,%eax
  803e37:	74 10                	je     803e49 <alloc_block+0x1c7>
  803e39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3c:	8b 00                	mov    (%eax),%eax
  803e3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e41:	8b 52 04             	mov    0x4(%edx),%edx
  803e44:	89 50 04             	mov    %edx,0x4(%eax)
  803e47:	eb 0b                	jmp    803e54 <alloc_block+0x1d2>
  803e49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4c:	8b 40 04             	mov    0x4(%eax),%eax
  803e4f:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e57:	8b 40 04             	mov    0x4(%eax),%eax
  803e5a:	85 c0                	test   %eax,%eax
  803e5c:	74 0f                	je     803e6d <alloc_block+0x1eb>
  803e5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e61:	8b 40 04             	mov    0x4(%eax),%eax
  803e64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e67:	8b 12                	mov    (%edx),%edx
  803e69:	89 10                	mov    %edx,(%eax)
  803e6b:	eb 0a                	jmp    803e77 <alloc_block+0x1f5>
  803e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e70:	8b 00                	mov    (%eax),%eax
  803e72:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e8a:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803e8f:	48                   	dec    %eax
  803e90:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803e95:	83 ec 0c             	sub    $0xc,%esp
  803e98:	ff 75 dc             	pushl  -0x24(%ebp)
  803e9b:	e8 6f fa ff ff       	call   80390f <to_page_va>
  803ea0:	83 c4 10             	add    $0x10,%esp
  803ea3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803ea6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ea9:	83 ec 0c             	sub    $0xc,%esp
  803eac:	50                   	push   %eax
  803ead:	e8 a0 dc ff ff       	call   801b52 <get_page>
  803eb2:	83 c4 10             	add    $0x10,%esp
  803eb5:	85 c0                	test   %eax,%eax
  803eb7:	74 14                	je     803ecd <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803eb9:	83 ec 04             	sub    $0x4,%esp
  803ebc:	68 b8 4f 80 00       	push   $0x804fb8
  803ec1:	6a 7f                	push   $0x7f
  803ec3:	68 d7 4e 80 00       	push   $0x804ed7
  803ec8:	e8 76 c8 ff ff       	call   800743 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ed3:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803ed7:	b8 00 10 00 00       	mov    $0x1000,%eax
  803edc:	ba 00 00 00 00       	mov    $0x0,%edx
  803ee1:	f7 75 f4             	divl   -0xc(%ebp)
  803ee4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ee7:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803eeb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ef2:	e9 a7 00 00 00       	jmp    803f9e <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803ef7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803efd:	01 d0                	add    %edx,%eax
  803eff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803f02:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f06:	75 17                	jne    803f1f <alloc_block+0x29d>
  803f08:	83 ec 04             	sub    $0x4,%esp
  803f0b:	68 e0 4f 80 00       	push   $0x804fe0
  803f10:	68 88 00 00 00       	push   $0x88
  803f15:	68 d7 4e 80 00       	push   $0x804ed7
  803f1a:	e8 24 c8 ff ff       	call   800743 <_panic>
  803f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f22:	c1 e0 04             	shl    $0x4,%eax
  803f25:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f2a:	8b 10                	mov    (%eax),%edx
  803f2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f2f:	89 10                	mov    %edx,(%eax)
  803f31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f34:	8b 00                	mov    (%eax),%eax
  803f36:	85 c0                	test   %eax,%eax
  803f38:	74 15                	je     803f4f <alloc_block+0x2cd>
  803f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3d:	c1 e0 04             	shl    $0x4,%eax
  803f40:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f45:	8b 00                	mov    (%eax),%eax
  803f47:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f4a:	89 50 04             	mov    %edx,0x4(%eax)
  803f4d:	eb 11                	jmp    803f60 <alloc_block+0x2de>
  803f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f52:	c1 e0 04             	shl    $0x4,%eax
  803f55:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803f5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f5e:	89 02                	mov    %eax,(%edx)
  803f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f63:	c1 e0 04             	shl    $0x4,%eax
  803f66:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803f6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f6f:	89 02                	mov    %eax,(%edx)
  803f71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f7e:	c1 e0 04             	shl    $0x4,%eax
  803f81:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f86:	8b 00                	mov    (%eax),%eax
  803f88:	8d 50 01             	lea    0x1(%eax),%edx
  803f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f8e:	c1 e0 04             	shl    $0x4,%eax
  803f91:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f96:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9b:	01 45 e8             	add    %eax,-0x18(%ebp)
  803f9e:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803fa5:	0f 86 4c ff ff ff    	jbe    803ef7 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fae:	c1 e0 04             	shl    $0x4,%eax
  803fb1:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803fb6:	8b 00                	mov    (%eax),%eax
  803fb8:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803fbb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803fbf:	75 17                	jne    803fd8 <alloc_block+0x356>
  803fc1:	83 ec 04             	sub    $0x4,%esp
  803fc4:	68 71 4f 80 00       	push   $0x804f71
  803fc9:	68 8d 00 00 00       	push   $0x8d
  803fce:	68 d7 4e 80 00       	push   $0x804ed7
  803fd3:	e8 6b c7 ff ff       	call   800743 <_panic>
  803fd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fdb:	8b 00                	mov    (%eax),%eax
  803fdd:	85 c0                	test   %eax,%eax
  803fdf:	74 10                	je     803ff1 <alloc_block+0x36f>
  803fe1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fe4:	8b 00                	mov    (%eax),%eax
  803fe6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803fe9:	8b 52 04             	mov    0x4(%edx),%edx
  803fec:	89 50 04             	mov    %edx,0x4(%eax)
  803fef:	eb 14                	jmp    804005 <alloc_block+0x383>
  803ff1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ff4:	8b 40 04             	mov    0x4(%eax),%eax
  803ff7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ffa:	c1 e2 04             	shl    $0x4,%edx
  803ffd:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804003:	89 02                	mov    %eax,(%edx)
  804005:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804008:	8b 40 04             	mov    0x4(%eax),%eax
  80400b:	85 c0                	test   %eax,%eax
  80400d:	74 0f                	je     80401e <alloc_block+0x39c>
  80400f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804012:	8b 40 04             	mov    0x4(%eax),%eax
  804015:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804018:	8b 12                	mov    (%edx),%edx
  80401a:	89 10                	mov    %edx,(%eax)
  80401c:	eb 13                	jmp    804031 <alloc_block+0x3af>
  80401e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804021:	8b 00                	mov    (%eax),%eax
  804023:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804026:	c1 e2 04             	shl    $0x4,%edx
  804029:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  80402f:	89 02                	mov    %eax,(%edx)
  804031:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80403a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80403d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804047:	c1 e0 04             	shl    $0x4,%eax
  80404a:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80404f:	8b 00                	mov    (%eax),%eax
  804051:	8d 50 ff             	lea    -0x1(%eax),%edx
  804054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804057:	c1 e0 04             	shl    $0x4,%eax
  80405a:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80405f:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  804061:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804064:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804068:	48                   	dec    %eax
  804069:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80406c:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  804070:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804073:	c9                   	leave  
  804074:	c3                   	ret    

00804075 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804075:	55                   	push   %ebp
  804076:	89 e5                	mov    %esp,%ebp
  804078:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80407b:	8b 55 08             	mov    0x8(%ebp),%edx
  80407e:	a1 84 60 83 00       	mov    0x836084,%eax
  804083:	39 c2                	cmp    %eax,%edx
  804085:	72 0c                	jb     804093 <free_block+0x1e>
  804087:	8b 55 08             	mov    0x8(%ebp),%edx
  80408a:	a1 60 e0 81 00       	mov    0x81e060,%eax
  80408f:	39 c2                	cmp    %eax,%edx
  804091:	72 19                	jb     8040ac <free_block+0x37>
  804093:	68 04 50 80 00       	push   $0x805004
  804098:	68 3a 4f 80 00       	push   $0x804f3a
  80409d:	68 98 00 00 00       	push   $0x98
  8040a2:	68 d7 4e 80 00       	push   $0x804ed7
  8040a7:	e8 97 c6 ff ff       	call   800743 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8040ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8040af:	83 ec 0c             	sub    $0xc,%esp
  8040b2:	50                   	push   %eax
  8040b3:	e8 c9 f8 ff ff       	call   803981 <to_page_info>
  8040b8:	83 c4 10             	add    $0x10,%esp
  8040bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  8040be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040c1:	8b 40 08             	mov    0x8(%eax),%eax
  8040c4:	0f b7 c0             	movzwl %ax,%eax
  8040c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  8040ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8040d1:	eb 03                	jmp    8040d6 <free_block+0x61>
		listIndex++;
  8040d3:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8040d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d9:	ba 08 00 00 00       	mov    $0x8,%edx
  8040de:	88 c1                	mov    %al,%cl
  8040e0:	d3 e2                	shl    %cl,%edx
  8040e2:	89 d0                	mov    %edx,%eax
  8040e4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8040e7:	72 ea                	jb     8040d3 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  8040e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  8040ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040f3:	75 17                	jne    80410c <free_block+0x97>
  8040f5:	83 ec 04             	sub    $0x4,%esp
  8040f8:	68 e0 4f 80 00       	push   $0x804fe0
  8040fd:	68 a2 00 00 00       	push   $0xa2
  804102:	68 d7 4e 80 00       	push   $0x804ed7
  804107:	e8 37 c6 ff ff       	call   800743 <_panic>
  80410c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80410f:	c1 e0 04             	shl    $0x4,%eax
  804112:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804117:	8b 10                	mov    (%eax),%edx
  804119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411c:	89 10                	mov    %edx,(%eax)
  80411e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804121:	8b 00                	mov    (%eax),%eax
  804123:	85 c0                	test   %eax,%eax
  804125:	74 15                	je     80413c <free_block+0xc7>
  804127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80412a:	c1 e0 04             	shl    $0x4,%eax
  80412d:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804132:	8b 00                	mov    (%eax),%eax
  804134:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804137:	89 50 04             	mov    %edx,0x4(%eax)
  80413a:	eb 11                	jmp    80414d <free_block+0xd8>
  80413c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80413f:	c1 e0 04             	shl    $0x4,%eax
  804142:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  804148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80414b:	89 02                	mov    %eax,(%edx)
  80414d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804150:	c1 e0 04             	shl    $0x4,%eax
  804153:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  804159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80415c:	89 02                	mov    %eax,(%edx)
  80415e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804161:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80416b:	c1 e0 04             	shl    $0x4,%eax
  80416e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804173:	8b 00                	mov    (%eax),%eax
  804175:	8d 50 01             	lea    0x1(%eax),%edx
  804178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80417b:	c1 e0 04             	shl    $0x4,%eax
  80417e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804183:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804188:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80418c:	40                   	inc    %eax
  80418d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804190:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804194:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804197:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80419b:	0f b7 c8             	movzwl %ax,%ecx
  80419e:	b8 00 10 00 00       	mov    $0x1000,%eax
  8041a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8041a8:	f7 75 e8             	divl   -0x18(%ebp)
  8041ab:	39 c1                	cmp    %eax,%ecx
  8041ad:	0f 85 ed 01 00 00    	jne    8043a0 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8041b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b6:	c1 e0 04             	shl    $0x4,%eax
  8041b9:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041be:	8b 00                	mov    (%eax),%eax
  8041c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041c3:	eb 2a                	jmp    8041ef <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  8041c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041c8:	83 ec 0c             	sub    $0xc,%esp
  8041cb:	50                   	push   %eax
  8041cc:	e8 b0 f7 ff ff       	call   803981 <to_page_info>
  8041d1:	83 c4 10             	add    $0x10,%esp
  8041d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8041d7:	75 06                	jne    8041df <free_block+0x16a>
				tmp = b;
  8041d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8041df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041e2:	c1 e0 04             	shl    $0x4,%eax
  8041e5:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8041ea:	8b 00                	mov    (%eax),%eax
  8041ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041f3:	74 07                	je     8041fc <free_block+0x187>
  8041f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041f8:	8b 00                	mov    (%eax),%eax
  8041fa:	eb 05                	jmp    804201 <free_block+0x18c>
  8041fc:	b8 00 00 00 00       	mov    $0x0,%eax
  804201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804204:	c1 e2 04             	shl    $0x4,%edx
  804207:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  80420d:	89 02                	mov    %eax,(%edx)
  80420f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804212:	c1 e0 04             	shl    $0x4,%eax
  804215:	05 a8 60 83 00       	add    $0x8360a8,%eax
  80421a:	8b 00                	mov    (%eax),%eax
  80421c:	85 c0                	test   %eax,%eax
  80421e:	75 a5                	jne    8041c5 <free_block+0x150>
  804220:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804224:	75 9f                	jne    8041c5 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804229:	c1 e0 04             	shl    $0x4,%eax
  80422c:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804231:	8b 00                	mov    (%eax),%eax
  804233:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804236:	e9 cc 00 00 00       	jmp    804307 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  80423b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80423e:	8b 00                	mov    (%eax),%eax
  804240:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804246:	83 ec 0c             	sub    $0xc,%esp
  804249:	50                   	push   %eax
  80424a:	e8 32 f7 ff ff       	call   803981 <to_page_info>
  80424f:	83 c4 10             	add    $0x10,%esp
  804252:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804255:	0f 85 a6 00 00 00    	jne    804301 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  80425b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80425f:	75 17                	jne    804278 <free_block+0x203>
  804261:	83 ec 04             	sub    $0x4,%esp
  804264:	68 71 4f 80 00       	push   $0x804f71
  804269:	68 b5 00 00 00       	push   $0xb5
  80426e:	68 d7 4e 80 00       	push   $0x804ed7
  804273:	e8 cb c4 ff ff       	call   800743 <_panic>
  804278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80427b:	8b 00                	mov    (%eax),%eax
  80427d:	85 c0                	test   %eax,%eax
  80427f:	74 10                	je     804291 <free_block+0x21c>
  804281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804284:	8b 00                	mov    (%eax),%eax
  804286:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804289:	8b 52 04             	mov    0x4(%edx),%edx
  80428c:	89 50 04             	mov    %edx,0x4(%eax)
  80428f:	eb 14                	jmp    8042a5 <free_block+0x230>
  804291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804294:	8b 40 04             	mov    0x4(%eax),%eax
  804297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80429a:	c1 e2 04             	shl    $0x4,%edx
  80429d:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  8042a3:	89 02                	mov    %eax,(%edx)
  8042a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a8:	8b 40 04             	mov    0x4(%eax),%eax
  8042ab:	85 c0                	test   %eax,%eax
  8042ad:	74 0f                	je     8042be <free_block+0x249>
  8042af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b2:	8b 40 04             	mov    0x4(%eax),%eax
  8042b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042b8:	8b 12                	mov    (%edx),%edx
  8042ba:	89 10                	mov    %edx,(%eax)
  8042bc:	eb 13                	jmp    8042d1 <free_block+0x25c>
  8042be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042c1:	8b 00                	mov    (%eax),%eax
  8042c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042c6:	c1 e2 04             	shl    $0x4,%edx
  8042c9:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8042cf:	89 02                	mov    %eax,(%edx)
  8042d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042e7:	c1 e0 04             	shl    $0x4,%eax
  8042ea:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042ef:	8b 00                	mov    (%eax),%eax
  8042f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8042f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f7:	c1 e0 04             	shl    $0x4,%eax
  8042fa:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042ff:	89 10                	mov    %edx,(%eax)
			b = next;
  804301:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804304:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804307:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80430b:	0f 85 2a ff ff ff    	jne    80423b <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  804311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804314:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80431a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80431d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804323:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804327:	75 17                	jne    804340 <free_block+0x2cb>
  804329:	83 ec 04             	sub    $0x4,%esp
  80432c:	68 e0 4f 80 00       	push   $0x804fe0
  804331:	68 bc 00 00 00       	push   $0xbc
  804336:	68 d7 4e 80 00       	push   $0x804ed7
  80433b:	e8 03 c4 ff ff       	call   800743 <_panic>
  804340:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  804346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804349:	89 10                	mov    %edx,(%eax)
  80434b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80434e:	8b 00                	mov    (%eax),%eax
  804350:	85 c0                	test   %eax,%eax
  804352:	74 0d                	je     804361 <free_block+0x2ec>
  804354:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804359:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80435c:	89 50 04             	mov    %edx,0x4(%eax)
  80435f:	eb 08                	jmp    804369 <free_block+0x2f4>
  804361:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804364:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  804369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80436c:	a3 68 e0 81 00       	mov    %eax,0x81e068
  804371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804374:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80437b:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804380:	40                   	inc    %eax
  804381:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804386:	83 ec 0c             	sub    $0xc,%esp
  804389:	ff 75 ec             	pushl  -0x14(%ebp)
  80438c:	e8 7e f5 ff ff       	call   80390f <to_page_va>
  804391:	83 c4 10             	add    $0x10,%esp
  804394:	83 ec 0c             	sub    $0xc,%esp
  804397:	50                   	push   %eax
  804398:	e8 fe d7 ff ff       	call   801b9b <return_page>
  80439d:	83 c4 10             	add    $0x10,%esp
	}
}
  8043a0:	90                   	nop
  8043a1:	c9                   	leave  
  8043a2:	c3                   	ret    
  8043a3:	90                   	nop

008043a4 <__udivdi3>:
  8043a4:	55                   	push   %ebp
  8043a5:	57                   	push   %edi
  8043a6:	56                   	push   %esi
  8043a7:	53                   	push   %ebx
  8043a8:	83 ec 1c             	sub    $0x1c,%esp
  8043ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8043b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043bb:	89 ca                	mov    %ecx,%edx
  8043bd:	89 f8                	mov    %edi,%eax
  8043bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043c3:	85 f6                	test   %esi,%esi
  8043c5:	75 2d                	jne    8043f4 <__udivdi3+0x50>
  8043c7:	39 cf                	cmp    %ecx,%edi
  8043c9:	77 65                	ja     804430 <__udivdi3+0x8c>
  8043cb:	89 fd                	mov    %edi,%ebp
  8043cd:	85 ff                	test   %edi,%edi
  8043cf:	75 0b                	jne    8043dc <__udivdi3+0x38>
  8043d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8043d6:	31 d2                	xor    %edx,%edx
  8043d8:	f7 f7                	div    %edi
  8043da:	89 c5                	mov    %eax,%ebp
  8043dc:	31 d2                	xor    %edx,%edx
  8043de:	89 c8                	mov    %ecx,%eax
  8043e0:	f7 f5                	div    %ebp
  8043e2:	89 c1                	mov    %eax,%ecx
  8043e4:	89 d8                	mov    %ebx,%eax
  8043e6:	f7 f5                	div    %ebp
  8043e8:	89 cf                	mov    %ecx,%edi
  8043ea:	89 fa                	mov    %edi,%edx
  8043ec:	83 c4 1c             	add    $0x1c,%esp
  8043ef:	5b                   	pop    %ebx
  8043f0:	5e                   	pop    %esi
  8043f1:	5f                   	pop    %edi
  8043f2:	5d                   	pop    %ebp
  8043f3:	c3                   	ret    
  8043f4:	39 ce                	cmp    %ecx,%esi
  8043f6:	77 28                	ja     804420 <__udivdi3+0x7c>
  8043f8:	0f bd fe             	bsr    %esi,%edi
  8043fb:	83 f7 1f             	xor    $0x1f,%edi
  8043fe:	75 40                	jne    804440 <__udivdi3+0x9c>
  804400:	39 ce                	cmp    %ecx,%esi
  804402:	72 0a                	jb     80440e <__udivdi3+0x6a>
  804404:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804408:	0f 87 9e 00 00 00    	ja     8044ac <__udivdi3+0x108>
  80440e:	b8 01 00 00 00       	mov    $0x1,%eax
  804413:	89 fa                	mov    %edi,%edx
  804415:	83 c4 1c             	add    $0x1c,%esp
  804418:	5b                   	pop    %ebx
  804419:	5e                   	pop    %esi
  80441a:	5f                   	pop    %edi
  80441b:	5d                   	pop    %ebp
  80441c:	c3                   	ret    
  80441d:	8d 76 00             	lea    0x0(%esi),%esi
  804420:	31 ff                	xor    %edi,%edi
  804422:	31 c0                	xor    %eax,%eax
  804424:	89 fa                	mov    %edi,%edx
  804426:	83 c4 1c             	add    $0x1c,%esp
  804429:	5b                   	pop    %ebx
  80442a:	5e                   	pop    %esi
  80442b:	5f                   	pop    %edi
  80442c:	5d                   	pop    %ebp
  80442d:	c3                   	ret    
  80442e:	66 90                	xchg   %ax,%ax
  804430:	89 d8                	mov    %ebx,%eax
  804432:	f7 f7                	div    %edi
  804434:	31 ff                	xor    %edi,%edi
  804436:	89 fa                	mov    %edi,%edx
  804438:	83 c4 1c             	add    $0x1c,%esp
  80443b:	5b                   	pop    %ebx
  80443c:	5e                   	pop    %esi
  80443d:	5f                   	pop    %edi
  80443e:	5d                   	pop    %ebp
  80443f:	c3                   	ret    
  804440:	bd 20 00 00 00       	mov    $0x20,%ebp
  804445:	89 eb                	mov    %ebp,%ebx
  804447:	29 fb                	sub    %edi,%ebx
  804449:	89 f9                	mov    %edi,%ecx
  80444b:	d3 e6                	shl    %cl,%esi
  80444d:	89 c5                	mov    %eax,%ebp
  80444f:	88 d9                	mov    %bl,%cl
  804451:	d3 ed                	shr    %cl,%ebp
  804453:	89 e9                	mov    %ebp,%ecx
  804455:	09 f1                	or     %esi,%ecx
  804457:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80445b:	89 f9                	mov    %edi,%ecx
  80445d:	d3 e0                	shl    %cl,%eax
  80445f:	89 c5                	mov    %eax,%ebp
  804461:	89 d6                	mov    %edx,%esi
  804463:	88 d9                	mov    %bl,%cl
  804465:	d3 ee                	shr    %cl,%esi
  804467:	89 f9                	mov    %edi,%ecx
  804469:	d3 e2                	shl    %cl,%edx
  80446b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80446f:	88 d9                	mov    %bl,%cl
  804471:	d3 e8                	shr    %cl,%eax
  804473:	09 c2                	or     %eax,%edx
  804475:	89 d0                	mov    %edx,%eax
  804477:	89 f2                	mov    %esi,%edx
  804479:	f7 74 24 0c          	divl   0xc(%esp)
  80447d:	89 d6                	mov    %edx,%esi
  80447f:	89 c3                	mov    %eax,%ebx
  804481:	f7 e5                	mul    %ebp
  804483:	39 d6                	cmp    %edx,%esi
  804485:	72 19                	jb     8044a0 <__udivdi3+0xfc>
  804487:	74 0b                	je     804494 <__udivdi3+0xf0>
  804489:	89 d8                	mov    %ebx,%eax
  80448b:	31 ff                	xor    %edi,%edi
  80448d:	e9 58 ff ff ff       	jmp    8043ea <__udivdi3+0x46>
  804492:	66 90                	xchg   %ax,%ax
  804494:	8b 54 24 08          	mov    0x8(%esp),%edx
  804498:	89 f9                	mov    %edi,%ecx
  80449a:	d3 e2                	shl    %cl,%edx
  80449c:	39 c2                	cmp    %eax,%edx
  80449e:	73 e9                	jae    804489 <__udivdi3+0xe5>
  8044a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8044a3:	31 ff                	xor    %edi,%edi
  8044a5:	e9 40 ff ff ff       	jmp    8043ea <__udivdi3+0x46>
  8044aa:	66 90                	xchg   %ax,%ax
  8044ac:	31 c0                	xor    %eax,%eax
  8044ae:	e9 37 ff ff ff       	jmp    8043ea <__udivdi3+0x46>
  8044b3:	90                   	nop

008044b4 <__umoddi3>:
  8044b4:	55                   	push   %ebp
  8044b5:	57                   	push   %edi
  8044b6:	56                   	push   %esi
  8044b7:	53                   	push   %ebx
  8044b8:	83 ec 1c             	sub    $0x1c,%esp
  8044bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044d3:	89 f3                	mov    %esi,%ebx
  8044d5:	89 fa                	mov    %edi,%edx
  8044d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044db:	89 34 24             	mov    %esi,(%esp)
  8044de:	85 c0                	test   %eax,%eax
  8044e0:	75 1a                	jne    8044fc <__umoddi3+0x48>
  8044e2:	39 f7                	cmp    %esi,%edi
  8044e4:	0f 86 a2 00 00 00    	jbe    80458c <__umoddi3+0xd8>
  8044ea:	89 c8                	mov    %ecx,%eax
  8044ec:	89 f2                	mov    %esi,%edx
  8044ee:	f7 f7                	div    %edi
  8044f0:	89 d0                	mov    %edx,%eax
  8044f2:	31 d2                	xor    %edx,%edx
  8044f4:	83 c4 1c             	add    $0x1c,%esp
  8044f7:	5b                   	pop    %ebx
  8044f8:	5e                   	pop    %esi
  8044f9:	5f                   	pop    %edi
  8044fa:	5d                   	pop    %ebp
  8044fb:	c3                   	ret    
  8044fc:	39 f0                	cmp    %esi,%eax
  8044fe:	0f 87 ac 00 00 00    	ja     8045b0 <__umoddi3+0xfc>
  804504:	0f bd e8             	bsr    %eax,%ebp
  804507:	83 f5 1f             	xor    $0x1f,%ebp
  80450a:	0f 84 ac 00 00 00    	je     8045bc <__umoddi3+0x108>
  804510:	bf 20 00 00 00       	mov    $0x20,%edi
  804515:	29 ef                	sub    %ebp,%edi
  804517:	89 fe                	mov    %edi,%esi
  804519:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80451d:	89 e9                	mov    %ebp,%ecx
  80451f:	d3 e0                	shl    %cl,%eax
  804521:	89 d7                	mov    %edx,%edi
  804523:	89 f1                	mov    %esi,%ecx
  804525:	d3 ef                	shr    %cl,%edi
  804527:	09 c7                	or     %eax,%edi
  804529:	89 e9                	mov    %ebp,%ecx
  80452b:	d3 e2                	shl    %cl,%edx
  80452d:	89 14 24             	mov    %edx,(%esp)
  804530:	89 d8                	mov    %ebx,%eax
  804532:	d3 e0                	shl    %cl,%eax
  804534:	89 c2                	mov    %eax,%edx
  804536:	8b 44 24 08          	mov    0x8(%esp),%eax
  80453a:	d3 e0                	shl    %cl,%eax
  80453c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804540:	8b 44 24 08          	mov    0x8(%esp),%eax
  804544:	89 f1                	mov    %esi,%ecx
  804546:	d3 e8                	shr    %cl,%eax
  804548:	09 d0                	or     %edx,%eax
  80454a:	d3 eb                	shr    %cl,%ebx
  80454c:	89 da                	mov    %ebx,%edx
  80454e:	f7 f7                	div    %edi
  804550:	89 d3                	mov    %edx,%ebx
  804552:	f7 24 24             	mull   (%esp)
  804555:	89 c6                	mov    %eax,%esi
  804557:	89 d1                	mov    %edx,%ecx
  804559:	39 d3                	cmp    %edx,%ebx
  80455b:	0f 82 87 00 00 00    	jb     8045e8 <__umoddi3+0x134>
  804561:	0f 84 91 00 00 00    	je     8045f8 <__umoddi3+0x144>
  804567:	8b 54 24 04          	mov    0x4(%esp),%edx
  80456b:	29 f2                	sub    %esi,%edx
  80456d:	19 cb                	sbb    %ecx,%ebx
  80456f:	89 d8                	mov    %ebx,%eax
  804571:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804575:	d3 e0                	shl    %cl,%eax
  804577:	89 e9                	mov    %ebp,%ecx
  804579:	d3 ea                	shr    %cl,%edx
  80457b:	09 d0                	or     %edx,%eax
  80457d:	89 e9                	mov    %ebp,%ecx
  80457f:	d3 eb                	shr    %cl,%ebx
  804581:	89 da                	mov    %ebx,%edx
  804583:	83 c4 1c             	add    $0x1c,%esp
  804586:	5b                   	pop    %ebx
  804587:	5e                   	pop    %esi
  804588:	5f                   	pop    %edi
  804589:	5d                   	pop    %ebp
  80458a:	c3                   	ret    
  80458b:	90                   	nop
  80458c:	89 fd                	mov    %edi,%ebp
  80458e:	85 ff                	test   %edi,%edi
  804590:	75 0b                	jne    80459d <__umoddi3+0xe9>
  804592:	b8 01 00 00 00       	mov    $0x1,%eax
  804597:	31 d2                	xor    %edx,%edx
  804599:	f7 f7                	div    %edi
  80459b:	89 c5                	mov    %eax,%ebp
  80459d:	89 f0                	mov    %esi,%eax
  80459f:	31 d2                	xor    %edx,%edx
  8045a1:	f7 f5                	div    %ebp
  8045a3:	89 c8                	mov    %ecx,%eax
  8045a5:	f7 f5                	div    %ebp
  8045a7:	89 d0                	mov    %edx,%eax
  8045a9:	e9 44 ff ff ff       	jmp    8044f2 <__umoddi3+0x3e>
  8045ae:	66 90                	xchg   %ax,%ax
  8045b0:	89 c8                	mov    %ecx,%eax
  8045b2:	89 f2                	mov    %esi,%edx
  8045b4:	83 c4 1c             	add    $0x1c,%esp
  8045b7:	5b                   	pop    %ebx
  8045b8:	5e                   	pop    %esi
  8045b9:	5f                   	pop    %edi
  8045ba:	5d                   	pop    %ebp
  8045bb:	c3                   	ret    
  8045bc:	3b 04 24             	cmp    (%esp),%eax
  8045bf:	72 06                	jb     8045c7 <__umoddi3+0x113>
  8045c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045c5:	77 0f                	ja     8045d6 <__umoddi3+0x122>
  8045c7:	89 f2                	mov    %esi,%edx
  8045c9:	29 f9                	sub    %edi,%ecx
  8045cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045cf:	89 14 24             	mov    %edx,(%esp)
  8045d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045da:	8b 14 24             	mov    (%esp),%edx
  8045dd:	83 c4 1c             	add    $0x1c,%esp
  8045e0:	5b                   	pop    %ebx
  8045e1:	5e                   	pop    %esi
  8045e2:	5f                   	pop    %edi
  8045e3:	5d                   	pop    %ebp
  8045e4:	c3                   	ret    
  8045e5:	8d 76 00             	lea    0x0(%esi),%esi
  8045e8:	2b 04 24             	sub    (%esp),%eax
  8045eb:	19 fa                	sbb    %edi,%edx
  8045ed:	89 d1                	mov    %edx,%ecx
  8045ef:	89 c6                	mov    %eax,%esi
  8045f1:	e9 71 ff ff ff       	jmp    804567 <__umoddi3+0xb3>
  8045f6:	66 90                	xchg   %ax,%ax
  8045f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045fc:	72 ea                	jb     8045e8 <__umoddi3+0x134>
  8045fe:	89 d9                	mov    %ebx,%ecx
  804600:	e9 62 ff ff ff       	jmp    804567 <__umoddi3+0xb3>
