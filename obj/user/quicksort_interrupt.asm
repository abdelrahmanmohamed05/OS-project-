
obj/user/quicksort_interrupt:     file format elf32-i386


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
  800031:	e8 8f 05 00 00       	call   8005c5 <libmain>
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
  800049:	e8 67 34 00 00       	call   8034b5 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 79 34 00 00       	call   8034ce <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();

		sys_lock_cons();
  80005d:	e8 a3 33 00 00       	call   803405 <sys_lock_cons>
			readline("Enter the number of elements: ", Line);
  800062:	83 ec 08             	sub    $0x8,%esp
  800065:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  80006b:	50                   	push   %eax
  80006c:	68 40 46 80 00       	push   $0x804640
  800071:	e8 a6 10 00 00       	call   80111c <readline>
  800076:	83 c4 10             	add    $0x10,%esp
			int NumOfElements = strtol(Line, NULL, 10) ;
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 0a                	push   $0xa
  80007e:	6a 00                	push   $0x0
  800080:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 a7 16 00 00       	call   801733 <strtol>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	50                   	push   %eax
  80009c:	e8 6c 1b 00 00       	call   801c0d <malloc>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	68 60 46 80 00       	push   $0x804660
  8000af:	e8 8f 09 00 00       	call   800a43 <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 83 46 80 00       	push   $0x804683
  8000bf:	e8 7f 09 00 00       	call   800a43 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 91 46 80 00       	push   $0x804691
  8000cf:	e8 6f 09 00 00       	call   800a43 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 a0 46 80 00       	push   $0x8046a0
  8000df:	e8 5f 09 00 00       	call   800a43 <cprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 b0 46 80 00       	push   $0x8046b0
  8000ef:	e8 4f 09 00 00       	call   800a43 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000f7:	e8 ac 04 00 00       	call   8005a8 <getchar>
  8000fc:	88 45 e7             	mov    %al,-0x19(%ebp)
				cputchar(Chose);
  8000ff:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	50                   	push   %eax
  800107:	e8 7d 04 00 00       	call   800589 <cputchar>
  80010c:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	6a 0a                	push   $0xa
  800114:	e8 70 04 00 00       	call   800589 <cputchar>
  800119:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80011c:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  800120:	74 0c                	je     80012e <_main+0xf6>
  800122:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800126:	74 06                	je     80012e <_main+0xf6>
  800128:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  80012c:	75 b9                	jne    8000e7 <_main+0xaf>
		sys_unlock_cons();
  80012e:	e8 ec 32 00 00       	call   80341f <sys_unlock_cons>
			//sys_unlock_cons();
			int  i ;
		switch (Chose)
  800133:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800137:	83 f8 62             	cmp    $0x62,%eax
  80013a:	74 1d                	je     800159 <_main+0x121>
  80013c:	83 f8 63             	cmp    $0x63,%eax
  80013f:	74 2b                	je     80016c <_main+0x134>
  800141:	83 f8 61             	cmp    $0x61,%eax
  800144:	75 39                	jne    80017f <_main+0x147>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800146:	83 ec 08             	sub    $0x8,%esp
  800149:	ff 75 ec             	pushl  -0x14(%ebp)
  80014c:	ff 75 e8             	pushl  -0x18(%ebp)
  80014f:	e8 e6 02 00 00       	call   80043a <InitializeAscending>
  800154:	83 c4 10             	add    $0x10,%esp
			break ;
  800157:	eb 37                	jmp    800190 <_main+0x158>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	ff 75 ec             	pushl  -0x14(%ebp)
  80015f:	ff 75 e8             	pushl  -0x18(%ebp)
  800162:	e8 04 03 00 00       	call   80046b <InitializeIdentical>
  800167:	83 c4 10             	add    $0x10,%esp
			break ;
  80016a:	eb 24                	jmp    800190 <_main+0x158>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 ec             	pushl  -0x14(%ebp)
  800172:	ff 75 e8             	pushl  -0x18(%ebp)
  800175:	e8 26 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80017a:	83 c4 10             	add    $0x10,%esp
			break ;
  80017d:	eb 11                	jmp    800190 <_main+0x158>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 ec             	pushl  -0x14(%ebp)
  800185:	ff 75 e8             	pushl  -0x18(%ebp)
  800188:	e8 13 03 00 00       	call   8004a0 <InitializeSemiRandom>
  80018d:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 e1 00 00 00       	call   80027f <QuickSort>
  80019e:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 e1 01 00 00       	call   800390 <CheckSorted>
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001b9:	75 14                	jne    8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 bc 46 80 00       	push   $0x8046bc
  8001c3:	6a 46                	push   $0x46
  8001c5:	68 de 46 80 00       	push   $0x8046de
  8001ca:	e8 a6 05 00 00       	call   800775 <_panic>
		else
		{
			sys_lock_cons();
  8001cf:	e8 31 32 00 00       	call   803405 <sys_lock_cons>
				cprintf("\n===============================================\n") ;
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	68 fc 46 80 00       	push   $0x8046fc
  8001dc:	e8 62 08 00 00       	call   800a43 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 30 47 80 00       	push   $0x804730
  8001ec:	e8 52 08 00 00       	call   800a43 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 64 47 80 00       	push   $0x804764
  8001fc:	e8 42 08 00 00       	call   800a43 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  800204:	e8 16 32 00 00       	call   80341f <sys_unlock_cons>
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		sys_lock_cons();
  800209:	e8 f7 31 00 00       	call   803405 <sys_lock_cons>
			cprintf("Freeing the Heap...\n\n") ;
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	68 96 47 80 00       	push   $0x804796
  800216:	e8 28 08 00 00       	call   800a43 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  80021e:	e8 fc 31 00 00       	call   80341f <sys_unlock_cons>

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		sys_lock_cons();
  800223:	e8 dd 31 00 00       	call   803405 <sys_lock_cons>
			cprintf("Do you want to repeat (y/n): ") ;
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	68 ac 47 80 00       	push   $0x8047ac
  800230:	e8 0e 08 00 00       	call   800a43 <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800238:	e8 6b 03 00 00       	call   8005a8 <getchar>
  80023d:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  800240:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	e8 3c 03 00 00       	call   800589 <cputchar>
  80024d:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 0a                	push   $0xa
  800255:	e8 2f 03 00 00       	call   800589 <cputchar>
  80025a:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	6a 0a                	push   $0xa
  800262:	e8 22 03 00 00       	call   800589 <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		sys_unlock_cons();
  80026a:	e8 b0 31 00 00       	call   80341f <sys_unlock_cons>

	} while (Chose == 'y');
  80026f:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  800273:	0f 84 d0 fd ff ff    	je     800049 <_main+0x11>

}
  800279:	90                   	nop
  80027a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	48                   	dec    %eax
  800289:	50                   	push   %eax
  80028a:	6a 00                	push   $0x0
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 06 00 00 00       	call   80029d <QSort>
  800297:	83 c4 10             	add    $0x10,%esp
}
  80029a:	90                   	nop
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a6:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a9:	0f 8d de 00 00 00    	jge    80038d <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002af:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b2:	40                   	inc    %eax
  8002b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002bc:	e9 80 00 00 00       	jmp    800341 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002c1:	ff 45 f4             	incl   -0xc(%ebp)
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ca:	7f 2b                	jg     8002f7 <QSort+0x5a>
  8002cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	01 c8                	add    %ecx,%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	39 c2                	cmp    %eax,%edx
  8002f0:	7d cf                	jge    8002c1 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002f2:	eb 03                	jmp    8002f7 <QSort+0x5a>
  8002f4:	ff 4d f0             	decl   -0x10(%ebp)
  8002f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002fd:	7e 26                	jle    800325 <QSort+0x88>
  8002ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800302:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	01 d0                	add    %edx,%eax
  80030e:	8b 10                	mov    (%eax),%edx
  800310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800313:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	01 c8                	add    %ecx,%eax
  80031f:	8b 00                	mov    (%eax),%eax
  800321:	39 c2                	cmp    %eax,%edx
  800323:	7e cf                	jle    8002f4 <QSort+0x57>

		if (i <= j)
  800325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800328:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80032b:	7f 14                	jg     800341 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80032d:	83 ec 04             	sub    $0x4,%esp
  800330:	ff 75 f0             	pushl  -0x10(%ebp)
  800333:	ff 75 f4             	pushl  -0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	e8 a9 00 00 00       	call   8003e7 <Swap>
  80033e:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800347:	0f 8e 77 ff ff ff    	jle    8002c4 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	ff 75 f0             	pushl  -0x10(%ebp)
  800353:	ff 75 10             	pushl  0x10(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	e8 89 00 00 00       	call   8003e7 <Swap>
  80035e:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	48                   	dec    %eax
  800365:	50                   	push   %eax
  800366:	ff 75 10             	pushl  0x10(%ebp)
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	ff 75 08             	pushl  0x8(%ebp)
  80036f:	e8 29 ff ff ff       	call   80029d <QSort>
  800374:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800377:	ff 75 14             	pushl  0x14(%ebp)
  80037a:	ff 75 f4             	pushl  -0xc(%ebp)
  80037d:	ff 75 0c             	pushl  0xc(%ebp)
  800380:	ff 75 08             	pushl  0x8(%ebp)
  800383:	e8 15 ff ff ff       	call   80029d <QSort>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	eb 01                	jmp    80038e <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80038d:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800396:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80039d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003a4:	eb 33                	jmp    8003d9 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	8b 10                	mov    (%eax),%edx
  8003b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ba:	40                   	inc    %eax
  8003bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	7e 09                	jle    8003d6 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003d4:	eb 0c                	jmp    8003e2 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003d6:	ff 45 f8             	incl   -0x8(%ebp)
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	48                   	dec    %eax
  8003dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003e0:	7f c4                	jg     8003a6 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	01 d0                	add    %edx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800401:	8b 45 0c             	mov    0xc(%ebp),%eax
  800404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	01 c2                	add    %eax,%edx
  800410:	8b 45 10             	mov    0x10(%ebp),%eax
  800413:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	01 c2                	add    %eax,%edx
  800432:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800435:	89 02                	mov    %eax,(%edx)
}
  800437:	90                   	nop
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800447:	eb 17                	jmp    800460 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c2                	add    %eax,%edx
  800458:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045b:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80045d:	ff 45 fc             	incl   -0x4(%ebp)
  800460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800463:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800466:	7c e1                	jl     800449 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800468:	90                   	nop
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800478:	eb 1b                	jmp    800495 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80047a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	01 c2                	add    %eax,%edx
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80048f:	48                   	dec    %eax
  800490:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	ff 45 fc             	incl   -0x4(%ebp)
  800495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800498:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049b:	7c dd                	jl     80047a <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80049d:	90                   	nop
  80049e:	c9                   	leave  
  80049f:	c3                   	ret    

008004a0 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a9:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ae:	f7 e9                	imul   %ecx
  8004b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8004b3:	89 d0                	mov    %edx,%eax
  8004b5:	29 c8                	sub    %ecx,%eax
  8004b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8004be:	75 07                	jne    8004c7 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8004c0:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004ce:	eb 1e                	jmp    8004ee <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8004d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e3:	99                   	cltd   
  8004e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8004e7:	89 d0                	mov    %edx,%eax
  8004e9:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  8004eb:	ff 45 fc             	incl   -0x4(%ebp)
  8004ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	7c da                	jl     8004d0 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004f6:	90                   	nop
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8004ff:	e8 01 2f 00 00       	call   803405 <sys_lock_cons>
		int i ;
		int NumsPerLine = 20 ;
  800504:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  80050b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800512:	eb 42                	jmp    800556 <PrintElements+0x5d>
		{
			if (i%NumsPerLine == 0)
  800514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800517:	99                   	cltd   
  800518:	f7 7d f0             	idivl  -0x10(%ebp)
  80051b:	89 d0                	mov    %edx,%eax
  80051d:	85 c0                	test   %eax,%eax
  80051f:	75 10                	jne    800531 <PrintElements+0x38>
				cprintf("\n");
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	68 ca 47 80 00       	push   $0x8047ca
  800529:	e8 15 05 00 00       	call   800a43 <cprintf>
  80052e:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 d0                	add    %edx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	50                   	push   %eax
  800546:	68 cc 47 80 00       	push   $0x8047cc
  80054b:	e8 f3 04 00 00       	call   800a43 <cprintf>
  800550:	83 c4 10             	add    $0x10,%esp
void PrintElements(int *Elements, int NumOfElements)
{
	sys_lock_cons();
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  800553:	ff 45 f4             	incl   -0xc(%ebp)
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	48                   	dec    %eax
  80055a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80055d:	7f b5                	jg     800514 <PrintElements+0x1b>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  80055f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800562:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	01 d0                	add    %edx,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	50                   	push   %eax
  800574:	68 d1 47 80 00       	push   $0x8047d1
  800579:	e8 c5 04 00 00       	call   800a43 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	sys_unlock_cons();
  800581:	e8 99 2e 00 00       	call   80341f <sys_unlock_cons>
}
  800586:	90                   	nop
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800595:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800599:	83 ec 0c             	sub    $0xc,%esp
  80059c:	50                   	push   %eax
  80059d:	e8 ab 2f 00 00       	call   80354d <sys_cputc>
  8005a2:	83 c4 10             	add    $0x10,%esp
}
  8005a5:	90                   	nop
  8005a6:	c9                   	leave  
  8005a7:	c3                   	ret    

008005a8 <getchar>:


int
getchar(void)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005ae:	e8 39 2e 00 00       	call   8033ec <sys_cgetc>
  8005b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <iscons>:

int iscons(int fdnum)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005c3:	5d                   	pop    %ebp
  8005c4:	c3                   	ret    

008005c5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	57                   	push   %edi
  8005c9:	56                   	push   %esi
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8005ce:	e8 ab 30 00 00       	call   80367e <sys_getenvindex>
  8005d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8005d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d9:	89 d0                	mov    %edx,%eax
  8005db:	c1 e0 03             	shl    $0x3,%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	c1 e0 02             	shl    $0x2,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	c1 e0 03             	shl    $0x3,%eax
  8005f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005f6:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005fb:	a1 24 60 80 00       	mov    0x806024,%eax
  800600:	8a 40 20             	mov    0x20(%eax),%al
  800603:	84 c0                	test   %al,%al
  800605:	74 0d                	je     800614 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800607:	a1 24 60 80 00       	mov    0x806024,%eax
  80060c:	83 c0 20             	add    $0x20,%eax
  80060f:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800618:	7e 0a                	jle    800624 <libmain+0x5f>
		binaryname = argv[0];
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	ff 75 08             	pushl  0x8(%ebp)
  80062d:	e8 06 fa ff ff       	call   800038 <_main>
  800632:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800635:	a1 00 60 80 00       	mov    0x806000,%eax
  80063a:	85 c0                	test   %eax,%eax
  80063c:	0f 84 01 01 00 00    	je     800743 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800642:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800648:	bb d0 48 80 00       	mov    $0x8048d0,%ebx
  80064d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800652:	89 c7                	mov    %eax,%edi
  800654:	89 de                	mov    %ebx,%esi
  800656:	89 d1                	mov    %edx,%ecx
  800658:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80065a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80065d:	b9 56 00 00 00       	mov    $0x56,%ecx
  800662:	b0 00                	mov    $0x0,%al
  800664:	89 d7                	mov    %edx,%edi
  800666:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800668:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80066f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	50                   	push   %eax
  800676:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80067c:	50                   	push   %eax
  80067d:	e8 32 32 00 00       	call   8038b4 <sys_utilities>
  800682:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800685:	e8 7b 2d 00 00       	call   803405 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80068a:	83 ec 0c             	sub    $0xc,%esp
  80068d:	68 f0 47 80 00       	push   $0x8047f0
  800692:	e8 ac 03 00 00       	call   800a43 <cprintf>
  800697:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80069a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069d:	85 c0                	test   %eax,%eax
  80069f:	74 18                	je     8006b9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006a1:	e8 2c 32 00 00       	call   8038d2 <sys_get_optimal_num_faults>
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	50                   	push   %eax
  8006aa:	68 18 48 80 00       	push   $0x804818
  8006af:	e8 8f 03 00 00       	call   800a43 <cprintf>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	eb 59                	jmp    800712 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006b9:	a1 24 60 80 00       	mov    0x806024,%eax
  8006be:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8006c4:	a1 24 60 80 00       	mov    0x806024,%eax
  8006c9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	68 3c 48 80 00       	push   $0x80483c
  8006d9:	e8 65 03 00 00       	call   800a43 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006e1:	a1 24 60 80 00       	mov    0x806024,%eax
  8006e6:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8006ec:	a1 24 60 80 00       	mov    0x806024,%eax
  8006f1:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8006f7:	a1 24 60 80 00       	mov    0x806024,%eax
  8006fc:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800702:	51                   	push   %ecx
  800703:	52                   	push   %edx
  800704:	50                   	push   %eax
  800705:	68 64 48 80 00       	push   $0x804864
  80070a:	e8 34 03 00 00       	call   800a43 <cprintf>
  80070f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800712:	a1 24 60 80 00       	mov    0x806024,%eax
  800717:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	50                   	push   %eax
  800721:	68 bc 48 80 00       	push   $0x8048bc
  800726:	e8 18 03 00 00       	call   800a43 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80072e:	83 ec 0c             	sub    $0xc,%esp
  800731:	68 f0 47 80 00       	push   $0x8047f0
  800736:	e8 08 03 00 00       	call   800a43 <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80073e:	e8 dc 2c 00 00       	call   80341f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800743:	e8 1f 00 00 00       	call   800767 <exit>
}
  800748:	90                   	nop
  800749:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074c:	5b                   	pop    %ebx
  80074d:	5e                   	pop    %esi
  80074e:	5f                   	pop    %edi
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800757:	83 ec 0c             	sub    $0xc,%esp
  80075a:	6a 00                	push   $0x0
  80075c:	e8 e9 2e 00 00       	call   80364a <sys_destroy_env>
  800761:	83 c4 10             	add    $0x10,%esp
}
  800764:	90                   	nop
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <exit>:

void
exit(void)
{
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80076d:	e8 3e 2f 00 00       	call   8036b0 <sys_exit_env>
}
  800772:	90                   	nop
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80077b:	8d 45 10             	lea    0x10(%ebp),%eax
  80077e:	83 c0 04             	add    $0x4,%eax
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800784:	a1 38 61 83 00       	mov    0x836138,%eax
  800789:	85 c0                	test   %eax,%eax
  80078b:	74 16                	je     8007a3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80078d:	a1 38 61 83 00       	mov    0x836138,%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	50                   	push   %eax
  800796:	68 34 49 80 00       	push   $0x804934
  80079b:	e8 a3 02 00 00       	call   800a43 <cprintf>
  8007a0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007a3:	a1 04 60 80 00       	mov    0x806004,%eax
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	ff 75 08             	pushl  0x8(%ebp)
  8007b1:	50                   	push   %eax
  8007b2:	68 3c 49 80 00       	push   $0x80493c
  8007b7:	6a 74                	push   $0x74
  8007b9:	e8 b2 02 00 00       	call   800a70 <cprintf_colored>
  8007be:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	e8 04 02 00 00       	call   8009d4 <vcprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	6a 00                	push   $0x0
  8007d8:	68 64 49 80 00       	push   $0x804964
  8007dd:	e8 f2 01 00 00       	call   8009d4 <vcprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007e5:	e8 7d ff ff ff       	call   800767 <exit>

	// should not return here
	while (1) ;
  8007ea:	eb fe                	jmp    8007ea <_panic+0x75>

008007ec <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f2:	a1 24 60 80 00       	mov    0x806024,%eax
  8007f7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800800:	39 c2                	cmp    %eax,%edx
  800802:	74 14                	je     800818 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800804:	83 ec 04             	sub    $0x4,%esp
  800807:	68 68 49 80 00       	push   $0x804968
  80080c:	6a 26                	push   $0x26
  80080e:	68 b4 49 80 00       	push   $0x8049b4
  800813:	e8 5d ff ff ff       	call   800775 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80081f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800826:	e9 c5 00 00 00       	jmp    8008f0 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80082b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	01 d0                	add    %edx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	85 c0                	test   %eax,%eax
  80083e:	75 08                	jne    800848 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800840:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800843:	e9 a5 00 00 00       	jmp    8008ed <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800848:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80084f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800856:	eb 69                	jmp    8008c1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800858:	a1 24 60 80 00       	mov    0x806024,%eax
  80085d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800863:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800866:	89 d0                	mov    %edx,%eax
  800868:	01 c0                	add    %eax,%eax
  80086a:	01 d0                	add    %edx,%eax
  80086c:	c1 e0 03             	shl    $0x3,%eax
  80086f:	01 c8                	add    %ecx,%eax
  800871:	8a 40 04             	mov    0x4(%eax),%al
  800874:	84 c0                	test   %al,%al
  800876:	75 46                	jne    8008be <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800878:	a1 24 60 80 00       	mov    0x806024,%eax
  80087d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800883:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800886:	89 d0                	mov    %edx,%eax
  800888:	01 c0                	add    %eax,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	c1 e0 03             	shl    $0x3,%eax
  80088f:	01 c8                	add    %ecx,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800896:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800899:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80089e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b1:	39 c2                	cmp    %eax,%edx
  8008b3:	75 09                	jne    8008be <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008b5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bc:	eb 15                	jmp    8008d3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008be:	ff 45 e8             	incl   -0x18(%ebp)
  8008c1:	a1 24 60 80 00       	mov    0x806024,%eax
  8008c6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 85                	ja     800858 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 c0 49 80 00       	push   $0x8049c0
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 b4 49 80 00       	push   $0x8049b4
  8008e8:	e8 88 fe ff ff       	call   800775 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 2f ff ff ff    	jl     80082b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 60 80 00       	mov    0x806024,%eax
  800911:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 60 80 00       	mov    0x806024,%eax
  800937:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80093d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800940:	39 c2                	cmp    %eax,%edx
  800942:	77 c8                	ja     80090c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800947:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80094a:	74 14                	je     800960 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80094c:	83 ec 04             	sub    $0x4,%esp
  80094f:	68 14 4a 80 00       	push   $0x804a14
  800954:	6a 44                	push   $0x44
  800956:	68 b4 49 80 00       	push   $0x8049b4
  80095b:	e8 15 fe ff ff       	call   800775 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800960:	90                   	nop
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	53                   	push   %ebx
  800967:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	8d 48 01             	lea    0x1(%eax),%ecx
  800972:	8b 55 0c             	mov    0xc(%ebp),%edx
  800975:	89 0a                	mov    %ecx,(%edx)
  800977:	8b 55 08             	mov    0x8(%ebp),%edx
  80097a:	88 d1                	mov    %dl,%cl
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	3d ff 00 00 00       	cmp    $0xff,%eax
  80098d:	75 30                	jne    8009bf <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80098f:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800995:	a0 64 e0 81 00       	mov    0x81e064,%al
  80099a:	0f b6 c0             	movzbl %al,%eax
  80099d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a0:	8b 09                	mov    (%ecx),%ecx
  8009a2:	89 cb                	mov    %ecx,%ebx
  8009a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a7:	83 c1 08             	add    $0x8,%ecx
  8009aa:	52                   	push   %edx
  8009ab:	50                   	push   %eax
  8009ac:	53                   	push   %ebx
  8009ad:	51                   	push   %ecx
  8009ae:	e8 0e 2a 00 00       	call   8033c1 <sys_cputs>
  8009b3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	8b 40 04             	mov    0x4(%eax),%eax
  8009c5:	8d 50 01             	lea    0x1(%eax),%edx
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009ce:	90                   	nop
  8009cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d2:	c9                   	leave  
  8009d3:	c3                   	ret    

008009d4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009e4:	00 00 00 
	b.cnt = 0;
  8009e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009ee:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009fd:	50                   	push   %eax
  8009fe:	68 63 09 80 00       	push   $0x800963
  800a03:	e8 5a 02 00 00       	call   800c62 <vprintfmt>
  800a08:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a0b:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800a11:	a0 64 e0 81 00       	mov    0x81e064,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a1f:	52                   	push   %edx
  800a20:	50                   	push   %eax
  800a21:	51                   	push   %ecx
  800a22:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a28:	83 c0 08             	add    $0x8,%eax
  800a2b:	50                   	push   %eax
  800a2c:	e8 90 29 00 00       	call   8033c1 <sys_cputs>
  800a31:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a34:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800a3b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a41:	c9                   	leave  
  800a42:	c3                   	ret    

00800a43 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a49:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800a50:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	e8 6f ff ff ff       	call   8009d4 <vcprintf>
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	c1 e0 08             	shl    $0x8,%eax
  800a83:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800a88:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8b:	83 c0 04             	add    $0x4,%eax
  800a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	e8 34 ff ff ff       	call   8009d4 <vcprintf>
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800aa6:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800aad:	07 00 00 

	return cnt;
  800ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800abb:	e8 45 29 00 00       	call   803405 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ac0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 f4             	pushl  -0xc(%ebp)
  800acf:	50                   	push   %eax
  800ad0:	e8 ff fe ff ff       	call   8009d4 <vcprintf>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800adb:	e8 3f 29 00 00       	call   80341f <sys_unlock_cons>
	return cnt;
  800ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae3:	c9                   	leave  
  800ae4:	c3                   	ret    

00800ae5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	53                   	push   %ebx
  800ae9:	83 ec 14             	sub    $0x14,%esp
  800aec:	8b 45 10             	mov    0x10(%ebp),%eax
  800aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800af8:	8b 45 18             	mov    0x18(%ebp),%eax
  800afb:	ba 00 00 00 00       	mov    $0x0,%edx
  800b00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b03:	77 55                	ja     800b5a <printnum+0x75>
  800b05:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b08:	72 05                	jb     800b0f <printnum+0x2a>
  800b0a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b0d:	77 4b                	ja     800b5a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b0f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b12:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b15:	8b 45 18             	mov    0x18(%ebp),%eax
  800b18:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1d:	52                   	push   %edx
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	ff 75 f0             	pushl  -0x10(%ebp)
  800b25:	e8 ae 38 00 00       	call   8043d8 <__udivdi3>
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	ff 75 20             	pushl  0x20(%ebp)
  800b33:	53                   	push   %ebx
  800b34:	ff 75 18             	pushl  0x18(%ebp)
  800b37:	52                   	push   %edx
  800b38:	50                   	push   %eax
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 a1 ff ff ff       	call   800ae5 <printnum>
  800b44:	83 c4 20             	add    $0x20,%esp
  800b47:	eb 1a                	jmp    800b63 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	ff 75 20             	pushl  0x20(%ebp)
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b5a:	ff 4d 1c             	decl   0x1c(%ebp)
  800b5d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b61:	7f e6                	jg     800b49 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b63:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b71:	53                   	push   %ebx
  800b72:	51                   	push   %ecx
  800b73:	52                   	push   %edx
  800b74:	50                   	push   %eax
  800b75:	e8 6e 39 00 00       	call   8044e8 <__umoddi3>
  800b7a:	83 c4 10             	add    $0x10,%esp
  800b7d:	05 74 4c 80 00       	add    $0x804c74,%eax
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be c0             	movsbl %al,%eax
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	50                   	push   %eax
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
}
  800b96:	90                   	nop
  800b97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b9f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ba3:	7e 1c                	jle    800bc1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 00                	mov    (%eax),%eax
  800baa:	8d 50 08             	lea    0x8(%eax),%edx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	89 10                	mov    %edx,(%eax)
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8b 00                	mov    (%eax),%eax
  800bb7:	83 e8 08             	sub    $0x8,%eax
  800bba:	8b 50 04             	mov    0x4(%eax),%edx
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	eb 40                	jmp    800c01 <getuint+0x65>
	else if (lflag)
  800bc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc5:	74 1e                	je     800be5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	8d 50 04             	lea    0x4(%eax),%edx
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 10                	mov    %edx,(%eax)
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	83 e8 04             	sub    $0x4,%eax
  800bdc:	8b 00                	mov    (%eax),%eax
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	eb 1c                	jmp    800c01 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8b 00                	mov    (%eax),%eax
  800bea:	8d 50 04             	lea    0x4(%eax),%edx
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	89 10                	mov    %edx,(%eax)
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8b 00                	mov    (%eax),%eax
  800bf7:	83 e8 04             	sub    $0x4,%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c06:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c0a:	7e 1c                	jle    800c28 <getint+0x25>
		return va_arg(*ap, long long);
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	8d 50 08             	lea    0x8(%eax),%edx
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 10                	mov    %edx,(%eax)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	83 e8 08             	sub    $0x8,%eax
  800c21:	8b 50 04             	mov    0x4(%eax),%edx
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	eb 38                	jmp    800c60 <getint+0x5d>
	else if (lflag)
  800c28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2c:	74 1a                	je     800c48 <getint+0x45>
		return va_arg(*ap, long);
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	8d 50 04             	lea    0x4(%eax),%edx
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	89 10                	mov    %edx,(%eax)
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8b 00                	mov    (%eax),%eax
  800c40:	83 e8 04             	sub    $0x4,%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	99                   	cltd   
  800c46:	eb 18                	jmp    800c60 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 00                	mov    (%eax),%eax
  800c4d:	8d 50 04             	lea    0x4(%eax),%edx
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 10                	mov    %edx,(%eax)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	83 e8 04             	sub    $0x4,%eax
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	99                   	cltd   
}
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
  800c67:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6a:	eb 17                	jmp    800c83 <vprintfmt+0x21>
			if (ch == '\0')
  800c6c:	85 db                	test   %ebx,%ebx
  800c6e:	0f 84 c1 03 00 00    	je     801035 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	53                   	push   %ebx
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	ff d0                	call   *%eax
  800c80:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	8d 50 01             	lea    0x1(%eax),%edx
  800c89:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	0f b6 d8             	movzbl %al,%ebx
  800c91:	83 fb 25             	cmp    $0x25,%ebx
  800c94:	75 d6                	jne    800c6c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c96:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c9a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ca1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ca8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800caf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	8d 50 01             	lea    0x1(%eax),%edx
  800cbc:	89 55 10             	mov    %edx,0x10(%ebp)
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	0f b6 d8             	movzbl %al,%ebx
  800cc4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cc7:	83 f8 5b             	cmp    $0x5b,%eax
  800cca:	0f 87 3d 03 00 00    	ja     80100d <vprintfmt+0x3ab>
  800cd0:	8b 04 85 98 4c 80 00 	mov    0x804c98(,%eax,4),%eax
  800cd7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cd9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cdd:	eb d7                	jmp    800cb6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cdf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ce3:	eb d1                	jmp    800cb6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cef:	89 d0                	mov    %edx,%eax
  800cf1:	c1 e0 02             	shl    $0x2,%eax
  800cf4:	01 d0                	add    %edx,%eax
  800cf6:	01 c0                	add    %eax,%eax
  800cf8:	01 d8                	add    %ebx,%eax
  800cfa:	83 e8 30             	sub    $0x30,%eax
  800cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d00:	8b 45 10             	mov    0x10(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d08:	83 fb 2f             	cmp    $0x2f,%ebx
  800d0b:	7e 3e                	jle    800d4b <vprintfmt+0xe9>
  800d0d:	83 fb 39             	cmp    $0x39,%ebx
  800d10:	7f 39                	jg     800d4b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d12:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d15:	eb d5                	jmp    800cec <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d17:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1a:	83 c0 04             	add    $0x4,%eax
  800d1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d20:	8b 45 14             	mov    0x14(%ebp),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d2b:	eb 1f                	jmp    800d4c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d31:	79 83                	jns    800cb6 <vprintfmt+0x54>
				width = 0;
  800d33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d3a:	e9 77 ff ff ff       	jmp    800cb6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d3f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d46:	e9 6b ff ff ff       	jmp    800cb6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d4b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	0f 89 60 ff ff ff    	jns    800cb6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d63:	e9 4e ff ff ff       	jmp    800cb6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d68:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d6b:	e9 46 ff ff ff       	jmp    800cb6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d70:	8b 45 14             	mov    0x14(%ebp),%eax
  800d73:	83 c0 04             	add    $0x4,%eax
  800d76:	89 45 14             	mov    %eax,0x14(%ebp)
  800d79:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7c:	83 e8 04             	sub    $0x4,%eax
  800d7f:	8b 00                	mov    (%eax),%eax
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 0c             	pushl  0xc(%ebp)
  800d87:	50                   	push   %eax
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	ff d0                	call   *%eax
  800d8d:	83 c4 10             	add    $0x10,%esp
			break;
  800d90:	e9 9b 02 00 00       	jmp    801030 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d95:	8b 45 14             	mov    0x14(%ebp),%eax
  800d98:	83 c0 04             	add    $0x4,%eax
  800d9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800da1:	83 e8 04             	sub    $0x4,%eax
  800da4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800da6:	85 db                	test   %ebx,%ebx
  800da8:	79 02                	jns    800dac <vprintfmt+0x14a>
				err = -err;
  800daa:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dac:	83 fb 64             	cmp    $0x64,%ebx
  800daf:	7f 0b                	jg     800dbc <vprintfmt+0x15a>
  800db1:	8b 34 9d e0 4a 80 00 	mov    0x804ae0(,%ebx,4),%esi
  800db8:	85 f6                	test   %esi,%esi
  800dba:	75 19                	jne    800dd5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dbc:	53                   	push   %ebx
  800dbd:	68 85 4c 80 00       	push   $0x804c85
  800dc2:	ff 75 0c             	pushl  0xc(%ebp)
  800dc5:	ff 75 08             	pushl  0x8(%ebp)
  800dc8:	e8 70 02 00 00       	call   80103d <printfmt>
  800dcd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dd0:	e9 5b 02 00 00       	jmp    801030 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dd5:	56                   	push   %esi
  800dd6:	68 8e 4c 80 00       	push   $0x804c8e
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 57 02 00 00       	call   80103d <printfmt>
  800de6:	83 c4 10             	add    $0x10,%esp
			break;
  800de9:	e9 42 02 00 00       	jmp    801030 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dee:	8b 45 14             	mov    0x14(%ebp),%eax
  800df1:	83 c0 04             	add    $0x4,%eax
  800df4:	89 45 14             	mov    %eax,0x14(%ebp)
  800df7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfa:	83 e8 04             	sub    $0x4,%eax
  800dfd:	8b 30                	mov    (%eax),%esi
  800dff:	85 f6                	test   %esi,%esi
  800e01:	75 05                	jne    800e08 <vprintfmt+0x1a6>
				p = "(null)";
  800e03:	be 91 4c 80 00       	mov    $0x804c91,%esi
			if (width > 0 && padc != '-')
  800e08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0c:	7e 6d                	jle    800e7b <vprintfmt+0x219>
  800e0e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e12:	74 67                	je     800e7b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e17:	83 ec 08             	sub    $0x8,%esp
  800e1a:	50                   	push   %eax
  800e1b:	56                   	push   %esi
  800e1c:	e8 26 05 00 00       	call   801347 <strnlen>
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e27:	eb 16                	jmp    800e3f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e29:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	50                   	push   %eax
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e3c:	ff 4d e4             	decl   -0x1c(%ebp)
  800e3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e43:	7f e4                	jg     800e29 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e45:	eb 34                	jmp    800e7b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e47:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e4b:	74 1c                	je     800e69 <vprintfmt+0x207>
  800e4d:	83 fb 1f             	cmp    $0x1f,%ebx
  800e50:	7e 05                	jle    800e57 <vprintfmt+0x1f5>
  800e52:	83 fb 7e             	cmp    $0x7e,%ebx
  800e55:	7e 12                	jle    800e69 <vprintfmt+0x207>
					putch('?', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 3f                	push   $0x3f
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
  800e67:	eb 0f                	jmp    800e78 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	ff 75 0c             	pushl  0xc(%ebp)
  800e6f:	53                   	push   %ebx
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	ff d0                	call   *%eax
  800e75:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e78:	ff 4d e4             	decl   -0x1c(%ebp)
  800e7b:	89 f0                	mov    %esi,%eax
  800e7d:	8d 70 01             	lea    0x1(%eax),%esi
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	0f be d8             	movsbl %al,%ebx
  800e85:	85 db                	test   %ebx,%ebx
  800e87:	74 24                	je     800ead <vprintfmt+0x24b>
  800e89:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e8d:	78 b8                	js     800e47 <vprintfmt+0x1e5>
  800e8f:	ff 4d e0             	decl   -0x20(%ebp)
  800e92:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e96:	79 af                	jns    800e47 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e98:	eb 13                	jmp    800ead <vprintfmt+0x24b>
				putch(' ', putdat);
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ea0:	6a 20                	push   $0x20
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	ff d0                	call   *%eax
  800ea7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eaa:	ff 4d e4             	decl   -0x1c(%ebp)
  800ead:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb1:	7f e7                	jg     800e9a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800eb3:	e9 78 01 00 00       	jmp    801030 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebe:	8d 45 14             	lea    0x14(%ebp),%eax
  800ec1:	50                   	push   %eax
  800ec2:	e8 3c fd ff ff       	call   800c03 <getint>
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ecd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed6:	85 d2                	test   %edx,%edx
  800ed8:	79 23                	jns    800efd <vprintfmt+0x29b>
				putch('-', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 2d                	push   $0x2d
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef0:	f7 d8                	neg    %eax
  800ef2:	83 d2 00             	adc    $0x0,%edx
  800ef5:	f7 da                	neg    %edx
  800ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800efd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f04:	e9 bc 00 00 00       	jmp    800fc5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f0f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f12:	50                   	push   %eax
  800f13:	e8 84 fc ff ff       	call   800b9c <getuint>
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f21:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f28:	e9 98 00 00 00       	jmp    800fc5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f2d:	83 ec 08             	sub    $0x8,%esp
  800f30:	ff 75 0c             	pushl  0xc(%ebp)
  800f33:	6a 58                	push   $0x58
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	ff d0                	call   *%eax
  800f3a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f3d:	83 ec 08             	sub    $0x8,%esp
  800f40:	ff 75 0c             	pushl  0xc(%ebp)
  800f43:	6a 58                	push   $0x58
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	ff d0                	call   *%eax
  800f4a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 58                	push   $0x58
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			break;
  800f5d:	e9 ce 00 00 00       	jmp    801030 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	ff 75 0c             	pushl  0xc(%ebp)
  800f68:	6a 30                	push   $0x30
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	ff d0                	call   *%eax
  800f6f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	ff 75 0c             	pushl  0xc(%ebp)
  800f78:	6a 78                	push   $0x78
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	ff d0                	call   *%eax
  800f7f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f82:	8b 45 14             	mov    0x14(%ebp),%eax
  800f85:	83 c0 04             	add    $0x4,%eax
  800f88:	89 45 14             	mov    %eax,0x14(%ebp)
  800f8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8e:	83 e8 04             	sub    $0x4,%eax
  800f91:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fa4:	eb 1f                	jmp    800fc5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fa6:	83 ec 08             	sub    $0x8,%esp
  800fa9:	ff 75 e8             	pushl  -0x18(%ebp)
  800fac:	8d 45 14             	lea    0x14(%ebp),%eax
  800faf:	50                   	push   %eax
  800fb0:	e8 e7 fb ff ff       	call   800b9c <getuint>
  800fb5:	83 c4 10             	add    $0x10,%esp
  800fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fbe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fc5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	52                   	push   %edx
  800fd0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fd3:	50                   	push   %eax
  800fd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd7:	ff 75 f0             	pushl  -0x10(%ebp)
  800fda:	ff 75 0c             	pushl  0xc(%ebp)
  800fdd:	ff 75 08             	pushl  0x8(%ebp)
  800fe0:	e8 00 fb ff ff       	call   800ae5 <printnum>
  800fe5:	83 c4 20             	add    $0x20,%esp
			break;
  800fe8:	eb 46                	jmp    801030 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	53                   	push   %ebx
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	ff d0                	call   *%eax
  800ff6:	83 c4 10             	add    $0x10,%esp
			break;
  800ff9:	eb 35                	jmp    801030 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ffb:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  801002:	eb 2c                	jmp    801030 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801004:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  80100b:	eb 23                	jmp    801030 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80100d:	83 ec 08             	sub    $0x8,%esp
  801010:	ff 75 0c             	pushl  0xc(%ebp)
  801013:	6a 25                	push   $0x25
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	ff d0                	call   *%eax
  80101a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80101d:	ff 4d 10             	decl   0x10(%ebp)
  801020:	eb 03                	jmp    801025 <vprintfmt+0x3c3>
  801022:	ff 4d 10             	decl   0x10(%ebp)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	48                   	dec    %eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 25                	cmp    $0x25,%al
  80102d:	75 f3                	jne    801022 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80102f:	90                   	nop
		}
	}
  801030:	e9 35 fc ff ff       	jmp    800c6a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801035:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801036:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801043:	8d 45 10             	lea    0x10(%ebp),%eax
  801046:	83 c0 04             	add    $0x4,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80104c:	8b 45 10             	mov    0x10(%ebp),%eax
  80104f:	ff 75 f4             	pushl  -0xc(%ebp)
  801052:	50                   	push   %eax
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	ff 75 08             	pushl  0x8(%ebp)
  801059:	e8 04 fc ff ff       	call   800c62 <vprintfmt>
  80105e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801061:	90                   	nop
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	8b 40 08             	mov    0x8(%eax),%eax
  80106d:	8d 50 01             	lea    0x1(%eax),%edx
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	8b 10                	mov    (%eax),%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8b 40 04             	mov    0x4(%eax),%eax
  801081:	39 c2                	cmp    %eax,%edx
  801083:	73 12                	jae    801097 <sprintputch+0x33>
		*b->buf++ = ch;
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	8b 00                	mov    (%eax),%eax
  80108a:	8d 48 01             	lea    0x1(%eax),%ecx
  80108d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801090:	89 0a                	mov    %ecx,(%edx)
  801092:	8b 55 08             	mov    0x8(%ebp),%edx
  801095:	88 10                	mov    %dl,(%eax)
}
  801097:	90                   	nop
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	01 d0                	add    %edx,%eax
  8010b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bf:	74 06                	je     8010c7 <vsnprintf+0x2d>
  8010c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010c5:	7f 07                	jg     8010ce <vsnprintf+0x34>
		return -E_INVAL;
  8010c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8010cc:	eb 20                	jmp    8010ee <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010ce:	ff 75 14             	pushl  0x14(%ebp)
  8010d1:	ff 75 10             	pushl  0x10(%ebp)
  8010d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010d7:	50                   	push   %eax
  8010d8:	68 64 10 80 00       	push   $0x801064
  8010dd:	e8 80 fb ff ff       	call   800c62 <vprintfmt>
  8010e2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f9:	83 c0 04             	add    $0x4,%eax
  8010fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	ff 75 f4             	pushl  -0xc(%ebp)
  801105:	50                   	push   %eax
  801106:	ff 75 0c             	pushl  0xc(%ebp)
  801109:	ff 75 08             	pushl  0x8(%ebp)
  80110c:	e8 89 ff ff ff       	call   80109a <vsnprintf>
  801111:	83 c4 10             	add    $0x10,%esp
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801117:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801126:	74 13                	je     80113b <readline+0x1f>
		cprintf("%s", prompt);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	68 08 4e 80 00       	push   $0x804e08
  801133:	e8 0b f9 ff ff       	call   800a43 <cprintf>
  801138:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	6a 00                	push   $0x0
  801147:	e8 6f f4 ff ff       	call   8005bb <iscons>
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801152:	e8 51 f4 ff ff       	call   8005a8 <getchar>
  801157:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80115a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80115e:	79 22                	jns    801182 <readline+0x66>
			if (c != -E_EOF)
  801160:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801164:	0f 84 ad 00 00 00    	je     801217 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 ec             	pushl  -0x14(%ebp)
  801170:	68 0b 4e 80 00       	push   $0x804e0b
  801175:	e8 c9 f8 ff ff       	call   800a43 <cprintf>
  80117a:	83 c4 10             	add    $0x10,%esp
			break;
  80117d:	e9 95 00 00 00       	jmp    801217 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801182:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801186:	7e 34                	jle    8011bc <readline+0xa0>
  801188:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80118f:	7f 2b                	jg     8011bc <readline+0xa0>
			if (echoing)
  801191:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801195:	74 0e                	je     8011a5 <readline+0x89>
				cputchar(c);
  801197:	83 ec 0c             	sub    $0xc,%esp
  80119a:	ff 75 ec             	pushl  -0x14(%ebp)
  80119d:	e8 e7 f3 ff ff       	call   800589 <cputchar>
  8011a2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a8:	8d 50 01             	lea    0x1(%eax),%edx
  8011ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011b8:	88 10                	mov    %dl,(%eax)
  8011ba:	eb 56                	jmp    801212 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011bc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011c0:	75 1f                	jne    8011e1 <readline+0xc5>
  8011c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011c6:	7e 19                	jle    8011e1 <readline+0xc5>
			if (echoing)
  8011c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011cc:	74 0e                	je     8011dc <readline+0xc0>
				cputchar(c);
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8011d4:	e8 b0 f3 ff ff       	call   800589 <cputchar>
  8011d9:	83 c4 10             	add    $0x10,%esp

			i--;
  8011dc:	ff 4d f4             	decl   -0xc(%ebp)
  8011df:	eb 31                	jmp    801212 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011e1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011e5:	74 0a                	je     8011f1 <readline+0xd5>
  8011e7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011eb:	0f 85 61 ff ff ff    	jne    801152 <readline+0x36>
			if (echoing)
  8011f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011f5:	74 0e                	je     801205 <readline+0xe9>
				cputchar(c);
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8011fd:	e8 87 f3 ff ff       	call   800589 <cputchar>
  801202:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 d0                	add    %edx,%eax
  80120d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801210:	eb 06                	jmp    801218 <readline+0xfc>
		}
	}
  801212:	e9 3b ff ff ff       	jmp    801152 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801217:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801218:	90                   	nop
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801221:	e8 df 21 00 00       	call   803405 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80122a:	74 13                	je     80123f <atomic_readline+0x24>
			cprintf("%s", prompt);
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	68 08 4e 80 00       	push   $0x804e08
  801237:	e8 07 f8 ff ff       	call   800a43 <cprintf>
  80123c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80123f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	6a 00                	push   $0x0
  80124b:	e8 6b f3 ff ff       	call   8005bb <iscons>
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801256:	e8 4d f3 ff ff       	call   8005a8 <getchar>
  80125b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80125e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801262:	79 22                	jns    801286 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801264:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801268:	0f 84 ad 00 00 00    	je     80131b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 ec             	pushl  -0x14(%ebp)
  801274:	68 0b 4e 80 00       	push   $0x804e0b
  801279:	e8 c5 f7 ff ff       	call   800a43 <cprintf>
  80127e:	83 c4 10             	add    $0x10,%esp
				break;
  801281:	e9 95 00 00 00       	jmp    80131b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801286:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80128a:	7e 34                	jle    8012c0 <atomic_readline+0xa5>
  80128c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801293:	7f 2b                	jg     8012c0 <atomic_readline+0xa5>
				if (echoing)
  801295:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801299:	74 0e                	je     8012a9 <atomic_readline+0x8e>
					cputchar(c);
  80129b:	83 ec 0c             	sub    $0xc,%esp
  80129e:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a1:	e8 e3 f2 ff ff       	call   800589 <cputchar>
  8012a6:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ac:	8d 50 01             	lea    0x1(%eax),%edx
  8012af:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012bc:	88 10                	mov    %dl,(%eax)
  8012be:	eb 56                	jmp    801316 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012c0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012c4:	75 1f                	jne    8012e5 <atomic_readline+0xca>
  8012c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012ca:	7e 19                	jle    8012e5 <atomic_readline+0xca>
				if (echoing)
  8012cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012d0:	74 0e                	je     8012e0 <atomic_readline+0xc5>
					cputchar(c);
  8012d2:	83 ec 0c             	sub    $0xc,%esp
  8012d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012d8:	e8 ac f2 ff ff       	call   800589 <cputchar>
  8012dd:	83 c4 10             	add    $0x10,%esp
				i--;
  8012e0:	ff 4d f4             	decl   -0xc(%ebp)
  8012e3:	eb 31                	jmp    801316 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012e5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012e9:	74 0a                	je     8012f5 <atomic_readline+0xda>
  8012eb:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012ef:	0f 85 61 ff ff ff    	jne    801256 <atomic_readline+0x3b>
				if (echoing)
  8012f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f9:	74 0e                	je     801309 <atomic_readline+0xee>
					cputchar(c);
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801301:	e8 83 f2 ff ff       	call   800589 <cputchar>
  801306:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801309:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801314:	eb 06                	jmp    80131c <atomic_readline+0x101>
			}
		}
  801316:	e9 3b ff ff ff       	jmp    801256 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80131b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80131c:	e8 fe 20 00 00       	call   80341f <sys_unlock_cons>
}
  801321:	90                   	nop
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80132a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801331:	eb 06                	jmp    801339 <strlen+0x15>
		n++;
  801333:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	84 c0                	test   %al,%al
  801340:	75 f1                	jne    801333 <strlen+0xf>
		n++;
	return n;
  801342:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80134d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801354:	eb 09                	jmp    80135f <strnlen+0x18>
		n++;
  801356:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801359:	ff 45 08             	incl   0x8(%ebp)
  80135c:	ff 4d 0c             	decl   0xc(%ebp)
  80135f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801363:	74 09                	je     80136e <strnlen+0x27>
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	84 c0                	test   %al,%al
  80136c:	75 e8                	jne    801356 <strnlen+0xf>
		n++;
	return n;
  80136e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80137f:	90                   	nop
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8d 50 01             	lea    0x1(%eax),%edx
  801386:	89 55 08             	mov    %edx,0x8(%ebp)
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801392:	8a 12                	mov    (%edx),%dl
  801394:	88 10                	mov    %dl,(%eax)
  801396:	8a 00                	mov    (%eax),%al
  801398:	84 c0                	test   %al,%al
  80139a:	75 e4                	jne    801380 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80139c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b4:	eb 1f                	jmp    8013d5 <strncpy+0x34>
		*dst++ = *src;
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8d 50 01             	lea    0x1(%eax),%edx
  8013bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8013bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c2:	8a 12                	mov    (%edx),%dl
  8013c4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 03                	je     8013d2 <strncpy+0x31>
			src++;
  8013cf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013d2:	ff 45 fc             	incl   -0x4(%ebp)
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013db:	72 d9                	jb     8013b6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f2:	74 30                	je     801424 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013f4:	eb 16                	jmp    80140c <strlcpy+0x2a>
			*dst++ = *src++;
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8d 50 01             	lea    0x1(%eax),%edx
  8013fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801402:	8d 4a 01             	lea    0x1(%edx),%ecx
  801405:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801408:	8a 12                	mov    (%edx),%dl
  80140a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80140c:	ff 4d 10             	decl   0x10(%ebp)
  80140f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801413:	74 09                	je     80141e <strlcpy+0x3c>
  801415:	8b 45 0c             	mov    0xc(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	84 c0                	test   %al,%al
  80141c:	75 d8                	jne    8013f6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801424:	8b 55 08             	mov    0x8(%ebp),%edx
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	29 c2                	sub    %eax,%edx
  80142c:	89 d0                	mov    %edx,%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801433:	eb 06                	jmp    80143b <strcmp+0xb>
		p++, q++;
  801435:	ff 45 08             	incl   0x8(%ebp)
  801438:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	84 c0                	test   %al,%al
  801442:	74 0e                	je     801452 <strcmp+0x22>
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 10                	mov    (%eax),%dl
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	38 c2                	cmp    %al,%dl
  801450:	74 e3                	je     801435 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	0f b6 d0             	movzbl %al,%edx
  80145a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	0f b6 c0             	movzbl %al,%eax
  801462:	29 c2                	sub    %eax,%edx
  801464:	89 d0                	mov    %edx,%eax
}
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    

00801468 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80146b:	eb 09                	jmp    801476 <strncmp+0xe>
		n--, p++, q++;
  80146d:	ff 4d 10             	decl   0x10(%ebp)
  801470:	ff 45 08             	incl   0x8(%ebp)
  801473:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801476:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147a:	74 17                	je     801493 <strncmp+0x2b>
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	84 c0                	test   %al,%al
  801483:	74 0e                	je     801493 <strncmp+0x2b>
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 10                	mov    (%eax),%dl
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	38 c2                	cmp    %al,%dl
  801491:	74 da                	je     80146d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801493:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801497:	75 07                	jne    8014a0 <strncmp+0x38>
		return 0;
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
  80149e:	eb 14                	jmp    8014b4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	0f b6 d0             	movzbl %al,%edx
  8014a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	0f b6 c0             	movzbl %al,%eax
  8014b0:	29 c2                	sub    %eax,%edx
  8014b2:	89 d0                	mov    %edx,%eax
}
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    

008014b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014c2:	eb 12                	jmp    8014d6 <strchr+0x20>
		if (*s == c)
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014cc:	75 05                	jne    8014d3 <strchr+0x1d>
			return (char *) s;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	eb 11                	jmp    8014e4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014d3:	ff 45 08             	incl   0x8(%ebp)
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	84 c0                	test   %al,%al
  8014dd:	75 e5                	jne    8014c4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 04             	sub    $0x4,%esp
  8014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014f2:	eb 0d                	jmp    801501 <strfind+0x1b>
		if (*s == c)
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014fc:	74 0e                	je     80150c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014fe:	ff 45 08             	incl   0x8(%ebp)
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8a 00                	mov    (%eax),%al
  801506:	84 c0                	test   %al,%al
  801508:	75 ea                	jne    8014f4 <strfind+0xe>
  80150a:	eb 01                	jmp    80150d <strfind+0x27>
		if (*s == c)
			break;
  80150c:	90                   	nop
	return (char *) s;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80151e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801522:	76 63                	jbe    801587 <memset+0x75>
		uint64 data_block = c;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	99                   	cltd   
  801528:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80152b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801534:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801538:	c1 e0 08             	shl    $0x8,%eax
  80153b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80153e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801547:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80154b:	c1 e0 10             	shl    $0x10,%eax
  80154e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801551:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155a:	89 c2                	mov    %eax,%edx
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	09 45 f0             	or     %eax,-0x10(%ebp)
  801564:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801567:	eb 18                	jmp    801581 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801569:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80156c:	8d 41 08             	lea    0x8(%ecx),%eax
  80156f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801578:	89 01                	mov    %eax,(%ecx)
  80157a:	89 51 04             	mov    %edx,0x4(%ecx)
  80157d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801581:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801585:	77 e2                	ja     801569 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801587:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158b:	74 23                	je     8015b0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80158d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801590:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801593:	eb 0e                	jmp    8015a3 <memset+0x91>
			*p8++ = (uint8)c;
  801595:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801598:	8d 50 01             	lea    0x1(%eax),%edx
  80159b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80159e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	75 e5                	jne    801595 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8015c7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015cb:	76 24                	jbe    8015f1 <memcpy+0x3c>
		while(n >= 8){
  8015cd:	eb 1c                	jmp    8015eb <memcpy+0x36>
			*d64 = *s64;
  8015cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d2:	8b 50 04             	mov    0x4(%eax),%edx
  8015d5:	8b 00                	mov    (%eax),%eax
  8015d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015da:	89 01                	mov    %eax,(%ecx)
  8015dc:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015df:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015e3:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015e7:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015eb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015ef:	77 de                	ja     8015cf <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f5:	74 31                	je     801628 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801600:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801603:	eb 16                	jmp    80161b <memcpy+0x66>
			*d8++ = *s8++;
  801605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801608:	8d 50 01             	lea    0x1(%eax),%edx
  80160b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80160e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801611:	8d 4a 01             	lea    0x1(%edx),%ecx
  801614:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801617:	8a 12                	mov    (%edx),%dl
  801619:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80161b:	8b 45 10             	mov    0x10(%ebp),%eax
  80161e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801621:	89 55 10             	mov    %edx,0x10(%ebp)
  801624:	85 c0                	test   %eax,%eax
  801626:	75 dd                	jne    801605 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801633:	8b 45 0c             	mov    0xc(%ebp),%eax
  801636:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801645:	73 50                	jae    801697 <memmove+0x6a>
  801647:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164a:	8b 45 10             	mov    0x10(%ebp),%eax
  80164d:	01 d0                	add    %edx,%eax
  80164f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801652:	76 43                	jbe    801697 <memmove+0x6a>
		s += n;
  801654:	8b 45 10             	mov    0x10(%ebp),%eax
  801657:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801660:	eb 10                	jmp    801672 <memmove+0x45>
			*--d = *--s;
  801662:	ff 4d f8             	decl   -0x8(%ebp)
  801665:	ff 4d fc             	decl   -0x4(%ebp)
  801668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166b:	8a 10                	mov    (%eax),%dl
  80166d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801670:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	8d 50 ff             	lea    -0x1(%eax),%edx
  801678:	89 55 10             	mov    %edx,0x10(%ebp)
  80167b:	85 c0                	test   %eax,%eax
  80167d:	75 e3                	jne    801662 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80167f:	eb 23                	jmp    8016a4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801681:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801684:	8d 50 01             	lea    0x1(%eax),%edx
  801687:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80168a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801690:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801693:	8a 12                	mov    (%edx),%dl
  801695:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801697:	8b 45 10             	mov    0x10(%ebp),%eax
  80169a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169d:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	75 dd                	jne    801681 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016bb:	eb 2a                	jmp    8016e7 <memcmp+0x3e>
		if (*s1 != *s2)
  8016bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c0:	8a 10                	mov    (%eax),%dl
  8016c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	38 c2                	cmp    %al,%dl
  8016c9:	74 16                	je     8016e1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ce:	8a 00                	mov    (%eax),%al
  8016d0:	0f b6 d0             	movzbl %al,%edx
  8016d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	0f b6 c0             	movzbl %al,%eax
  8016db:	29 c2                	sub    %eax,%edx
  8016dd:	89 d0                	mov    %edx,%eax
  8016df:	eb 18                	jmp    8016f9 <memcmp+0x50>
		s1++, s2++;
  8016e1:	ff 45 fc             	incl   -0x4(%ebp)
  8016e4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	75 c9                	jne    8016bd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801701:	8b 55 08             	mov    0x8(%ebp),%edx
  801704:	8b 45 10             	mov    0x10(%ebp),%eax
  801707:	01 d0                	add    %edx,%eax
  801709:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80170c:	eb 15                	jmp    801723 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	0f b6 c0             	movzbl %al,%eax
  80171c:	39 c2                	cmp    %eax,%edx
  80171e:	74 0d                	je     80172d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801720:	ff 45 08             	incl   0x8(%ebp)
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801729:	72 e3                	jb     80170e <memfind+0x13>
  80172b:	eb 01                	jmp    80172e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80172d:	90                   	nop
	return (void *) s;
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801739:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801740:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801747:	eb 03                	jmp    80174c <strtol+0x19>
		s++;
  801749:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	8a 00                	mov    (%eax),%al
  801751:	3c 20                	cmp    $0x20,%al
  801753:	74 f4                	je     801749 <strtol+0x16>
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	3c 09                	cmp    $0x9,%al
  80175c:	74 eb                	je     801749 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	8a 00                	mov    (%eax),%al
  801763:	3c 2b                	cmp    $0x2b,%al
  801765:	75 05                	jne    80176c <strtol+0x39>
		s++;
  801767:	ff 45 08             	incl   0x8(%ebp)
  80176a:	eb 13                	jmp    80177f <strtol+0x4c>
	else if (*s == '-')
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8a 00                	mov    (%eax),%al
  801771:	3c 2d                	cmp    $0x2d,%al
  801773:	75 0a                	jne    80177f <strtol+0x4c>
		s++, neg = 1;
  801775:	ff 45 08             	incl   0x8(%ebp)
  801778:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80177f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801783:	74 06                	je     80178b <strtol+0x58>
  801785:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801789:	75 20                	jne    8017ab <strtol+0x78>
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	3c 30                	cmp    $0x30,%al
  801792:	75 17                	jne    8017ab <strtol+0x78>
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	40                   	inc    %eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 78                	cmp    $0x78,%al
  80179c:	75 0d                	jne    8017ab <strtol+0x78>
		s += 2, base = 16;
  80179e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017a9:	eb 28                	jmp    8017d3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017af:	75 15                	jne    8017c6 <strtol+0x93>
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8a 00                	mov    (%eax),%al
  8017b6:	3c 30                	cmp    $0x30,%al
  8017b8:	75 0c                	jne    8017c6 <strtol+0x93>
		s++, base = 8;
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017c4:	eb 0d                	jmp    8017d3 <strtol+0xa0>
	else if (base == 0)
  8017c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ca:	75 07                	jne    8017d3 <strtol+0xa0>
		base = 10;
  8017cc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8a 00                	mov    (%eax),%al
  8017d8:	3c 2f                	cmp    $0x2f,%al
  8017da:	7e 19                	jle    8017f5 <strtol+0xc2>
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	8a 00                	mov    (%eax),%al
  8017e1:	3c 39                	cmp    $0x39,%al
  8017e3:	7f 10                	jg     8017f5 <strtol+0xc2>
			dig = *s - '0';
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	0f be c0             	movsbl %al,%eax
  8017ed:	83 e8 30             	sub    $0x30,%eax
  8017f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f3:	eb 42                	jmp    801837 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 60                	cmp    $0x60,%al
  8017fc:	7e 19                	jle    801817 <strtol+0xe4>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3c 7a                	cmp    $0x7a,%al
  801805:	7f 10                	jg     801817 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8a 00                	mov    (%eax),%al
  80180c:	0f be c0             	movsbl %al,%eax
  80180f:	83 e8 57             	sub    $0x57,%eax
  801812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801815:	eb 20                	jmp    801837 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	8a 00                	mov    (%eax),%al
  80181c:	3c 40                	cmp    $0x40,%al
  80181e:	7e 39                	jle    801859 <strtol+0x126>
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	3c 5a                	cmp    $0x5a,%al
  801827:	7f 30                	jg     801859 <strtol+0x126>
			dig = *s - 'A' + 10;
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	0f be c0             	movsbl %al,%eax
  801831:	83 e8 37             	sub    $0x37,%eax
  801834:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80183d:	7d 19                	jge    801858 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80183f:	ff 45 08             	incl   0x8(%ebp)
  801842:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801845:	0f af 45 10          	imul   0x10(%ebp),%eax
  801849:	89 c2                	mov    %eax,%edx
  80184b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184e:	01 d0                	add    %edx,%eax
  801850:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801853:	e9 7b ff ff ff       	jmp    8017d3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801858:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801859:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80185d:	74 08                	je     801867 <strtol+0x134>
		*endptr = (char *) s;
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8b 55 08             	mov    0x8(%ebp),%edx
  801865:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801867:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80186b:	74 07                	je     801874 <strtol+0x141>
  80186d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801870:	f7 d8                	neg    %eax
  801872:	eb 03                	jmp    801877 <strtol+0x144>
  801874:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <ltostr>:

void
ltostr(long value, char *str)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80187f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801886:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80188d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801891:	79 13                	jns    8018a6 <ltostr+0x2d>
	{
		neg = 1;
  801893:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ae:	99                   	cltd   
  8018af:	f7 f9                	idiv   %ecx
  8018b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b7:	8d 50 01             	lea    0x1(%eax),%edx
  8018ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018bd:	89 c2                	mov    %eax,%edx
  8018bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c2:	01 d0                	add    %edx,%eax
  8018c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c7:	83 c2 30             	add    $0x30,%edx
  8018ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018d4:	f7 e9                	imul   %ecx
  8018d6:	c1 fa 02             	sar    $0x2,%edx
  8018d9:	89 c8                	mov    %ecx,%eax
  8018db:	c1 f8 1f             	sar    $0x1f,%eax
  8018de:	29 c2                	sub    %eax,%edx
  8018e0:	89 d0                	mov    %edx,%eax
  8018e2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018e9:	75 bb                	jne    8018a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f5:	48                   	dec    %eax
  8018f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018fd:	74 3d                	je     80193c <ltostr+0xc3>
		start = 1 ;
  8018ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801906:	eb 34                	jmp    80193c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	8a 00                	mov    (%eax),%al
  801912:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801915:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191b:	01 c2                	add    %eax,%edx
  80191d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 c8                	add    %ecx,%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801929:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192f:	01 c2                	add    %eax,%edx
  801931:	8a 45 eb             	mov    -0x15(%ebp),%al
  801934:	88 02                	mov    %al,(%edx)
		start++ ;
  801936:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801939:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80193c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801942:	7c c4                	jl     801908 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801944:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194a:	01 d0                	add    %edx,%eax
  80194c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80194f:	90                   	nop
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	e8 c4 f9 ff ff       	call   801324 <strlen>
  801960:	83 c4 04             	add    $0x4,%esp
  801963:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	e8 b6 f9 ff ff       	call   801324 <strlen>
  80196e:	83 c4 04             	add    $0x4,%esp
  801971:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80197b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801982:	eb 17                	jmp    80199b <strcconcat+0x49>
		final[s] = str1[s] ;
  801984:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801987:	8b 45 10             	mov    0x10(%ebp),%eax
  80198a:	01 c2                	add    %eax,%edx
  80198c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	01 c8                	add    %ecx,%eax
  801994:	8a 00                	mov    (%eax),%al
  801996:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801998:	ff 45 fc             	incl   -0x4(%ebp)
  80199b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80199e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019a1:	7c e1                	jl     801984 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019b1:	eb 1f                	jmp    8019d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b6:	8d 50 01             	lea    0x1(%eax),%edx
  8019b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019bc:	89 c2                	mov    %eax,%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019cf:	ff 45 f8             	incl   -0x8(%ebp)
  8019d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019d8:	7c d9                	jl     8019b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	01 d0                	add    %edx,%eax
  801a05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a0b:	eb 0c                	jmp    801a19 <strsplit+0x31>
			*string++ = 0;
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	8d 50 01             	lea    0x1(%eax),%edx
  801a13:	89 55 08             	mov    %edx,0x8(%ebp)
  801a16:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	8a 00                	mov    (%eax),%al
  801a1e:	84 c0                	test   %al,%al
  801a20:	74 18                	je     801a3a <strsplit+0x52>
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f be c0             	movsbl %al,%eax
  801a2a:	50                   	push   %eax
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	e8 83 fa ff ff       	call   8014b6 <strchr>
  801a33:	83 c4 08             	add    $0x8,%esp
  801a36:	85 c0                	test   %eax,%eax
  801a38:	75 d3                	jne    801a0d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8a 00                	mov    (%eax),%al
  801a3f:	84 c0                	test   %al,%al
  801a41:	74 5a                	je     801a9d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	8b 00                	mov    (%eax),%eax
  801a48:	83 f8 0f             	cmp    $0xf,%eax
  801a4b:	75 07                	jne    801a54 <strsplit+0x6c>
		{
			return 0;
  801a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a52:	eb 66                	jmp    801aba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a54:	8b 45 14             	mov    0x14(%ebp),%eax
  801a57:	8b 00                	mov    (%eax),%eax
  801a59:	8d 48 01             	lea    0x1(%eax),%ecx
  801a5c:	8b 55 14             	mov    0x14(%ebp),%edx
  801a5f:	89 0a                	mov    %ecx,(%edx)
  801a61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a68:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6b:	01 c2                	add    %eax,%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a72:	eb 03                	jmp    801a77 <strsplit+0x8f>
			string++;
  801a74:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	84 c0                	test   %al,%al
  801a7e:	74 8b                	je     801a0b <strsplit+0x23>
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	0f be c0             	movsbl %al,%eax
  801a88:	50                   	push   %eax
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	e8 25 fa ff ff       	call   8014b6 <strchr>
  801a91:	83 c4 08             	add    $0x8,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	74 dc                	je     801a74 <strsplit+0x8c>
			string++;
	}
  801a98:	e9 6e ff ff ff       	jmp    801a0b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a9d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa1:	8b 00                	mov    (%eax),%eax
  801aa3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801aad:	01 d0                	add    %edx,%eax
  801aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ab5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801ac8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801acf:	eb 4a                	jmp    801b1b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801ad1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	01 c2                	add    %eax,%edx
  801ad9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adf:	01 c8                	add    %ecx,%eax
  801ae1:	8a 00                	mov    (%eax),%al
  801ae3:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ae5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aeb:	01 d0                	add    %edx,%eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 40                	cmp    $0x40,%al
  801af1:	7e 25                	jle    801b18 <str2lower+0x5c>
  801af3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af9:	01 d0                	add    %edx,%eax
  801afb:	8a 00                	mov    (%eax),%al
  801afd:	3c 5a                	cmp    $0x5a,%al
  801aff:	7f 17                	jg     801b18 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	01 d0                	add    %edx,%eax
  801b09:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b0c:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0f:	01 ca                	add    %ecx,%edx
  801b11:	8a 12                	mov    (%edx),%dl
  801b13:	83 c2 20             	add    $0x20,%edx
  801b16:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b18:	ff 45 fc             	incl   -0x4(%ebp)
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	e8 01 f8 ff ff       	call   801324 <strlen>
  801b23:	83 c4 04             	add    $0x4,%esp
  801b26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b29:	7f a6                	jg     801ad1 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b36:	a1 08 60 80 00       	mov    0x806008,%eax
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	74 42                	je     801b81 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	68 00 00 00 82       	push   $0x82000000
  801b47:	68 00 00 00 80       	push   $0x80000000
  801b4c:	e8 b0 1e 00 00       	call   803a01 <initialize_dynamic_allocator>
  801b51:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b54:	e8 96 1c 00 00       	call   8037ef <sys_get_uheap_strategy>
  801b59:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b5e:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801b63:	05 00 10 00 00       	add    $0x1000,%eax
  801b68:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801b6d:	a1 30 61 83 00       	mov    0x836130,%eax
  801b72:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801b77:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801b7e:	00 00 00 
	}
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	68 06 04 00 00       	push   $0x406
  801ba0:	50                   	push   %eax
  801ba1:	e8 93 18 00 00       	call   803439 <__sys_allocate_page>
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb0:	79 14                	jns    801bc6 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	68 1c 4e 80 00       	push   $0x804e1c
  801bba:	6a 1f                	push   $0x1f
  801bbc:	68 58 4e 80 00       	push   $0x804e58
  801bc1:	e8 af eb ff ff       	call   800775 <_panic>
	return 0;
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801be1:	83 ec 0c             	sub    $0xc,%esp
  801be4:	50                   	push   %eax
  801be5:	e8 96 18 00 00       	call   803480 <__sys_unmap_frame>
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf4:	79 14                	jns    801c0a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	68 64 4e 80 00       	push   $0x804e64
  801bfe:	6a 2a                	push   $0x2a
  801c00:	68 58 4e 80 00       	push   $0x804e58
  801c05:	e8 6b eb ff ff       	call   800775 <_panic>
}
  801c0a:	90                   	nop
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c13:	e8 18 ff ff ff       	call   801b30 <uheap_init>
	if (size == 0) return NULL ;
  801c18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c1c:	75 0a                	jne    801c28 <malloc+0x1b>
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c23:	e9 43 03 00 00       	jmp    801f6b <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c28:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c2f:	77 13                	ja     801c44 <malloc+0x37>
    {
        return alloc_block(size);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	ff 75 08             	pushl  0x8(%ebp)
  801c37:	e8 78 20 00 00       	call   803cb4 <alloc_block>
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	e9 27 03 00 00       	jmp    801f6b <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801c44:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c51:	01 d0                	add    %edx,%eax
  801c53:	48                   	dec    %eax
  801c54:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5f:	f7 75 dc             	divl   -0x24(%ebp)
  801c62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c65:	29 d0                	sub    %edx,%eax
  801c67:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801c6a:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	75 0a                	jne    801c7d <malloc+0x70>
    {
        uhp_inited = 1;
  801c73:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801c7a:	00 00 00 
    }

    int exactIdx = -1;
  801c7d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801c84:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801c8b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c92:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801c99:	e9 85 00 00 00       	jmp    801d23 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801c9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca1:	89 d0                	mov    %edx,%eax
  801ca3:	01 c0                	add    %eax,%eax
  801ca5:	01 d0                	add    %edx,%eax
  801ca7:	c1 e0 02             	shl    $0x2,%eax
  801caa:	05 48 20 81 00       	add    $0x812048,%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	84 c0                	test   %al,%al
  801cb3:	74 20                	je     801cd5 <malloc+0xc8>
  801cb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cb8:	89 d0                	mov    %edx,%eax
  801cba:	01 c0                	add    %eax,%eax
  801cbc:	01 d0                	add    %edx,%eax
  801cbe:	c1 e0 02             	shl    $0x2,%eax
  801cc1:	05 44 20 81 00       	add    $0x812044,%eax
  801cc6:	8b 00                	mov    (%eax),%eax
  801cc8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ccb:	75 08                	jne    801cd5 <malloc+0xc8>
        {
            exactIdx = i;
  801ccd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801cd3:	eb 5b                	jmp    801d30 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801cd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cd8:	89 d0                	mov    %edx,%eax
  801cda:	01 c0                	add    %eax,%eax
  801cdc:	01 d0                	add    %edx,%eax
  801cde:	c1 e0 02             	shl    $0x2,%eax
  801ce1:	05 48 20 81 00       	add    $0x812048,%eax
  801ce6:	8a 00                	mov    (%eax),%al
  801ce8:	84 c0                	test   %al,%al
  801cea:	74 34                	je     801d20 <malloc+0x113>
  801cec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cef:	89 d0                	mov    %edx,%eax
  801cf1:	01 c0                	add    %eax,%eax
  801cf3:	01 d0                	add    %edx,%eax
  801cf5:	c1 e0 02             	shl    $0x2,%eax
  801cf8:	05 44 20 81 00       	add    $0x812044,%eax
  801cfd:	8b 00                	mov    (%eax),%eax
  801cff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d02:	76 1c                	jbe    801d20 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801d04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	01 c0                	add    %eax,%eax
  801d0b:	01 d0                	add    %edx,%eax
  801d0d:	c1 e0 02             	shl    $0x2,%eax
  801d10:	05 44 20 81 00       	add    $0x812044,%eax
  801d15:	8b 00                	mov    (%eax),%eax
  801d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d20:	ff 45 e8             	incl   -0x18(%ebp)
  801d23:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801d2a:	0f 8e 6e ff ff ff    	jle    801c9e <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801d30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801d37:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801d3b:	74 7d                	je     801dba <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801d3d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d47:	89 d0                	mov    %edx,%eax
  801d49:	01 c0                	add    %eax,%eax
  801d4b:	01 d0                	add    %edx,%eax
  801d4d:	c1 e0 02             	shl    $0x2,%eax
  801d50:	05 40 20 81 00       	add    $0x812040,%eax
  801d55:	8b 10                	mov    (%eax),%edx
  801d57:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	48                   	dec    %eax
  801d5d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d60:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d63:	ba 00 00 00 00       	mov    $0x0,%edx
  801d68:	f7 75 bc             	divl   -0x44(%ebp)
  801d6b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d6e:	29 d0                	sub    %edx,%eax
  801d70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d76:	89 d0                	mov    %edx,%eax
  801d78:	01 c0                	add    %eax,%eax
  801d7a:	01 d0                	add    %edx,%eax
  801d7c:	c1 e0 02             	shl    $0x2,%eax
  801d7f:	05 48 20 81 00       	add    $0x812048,%eax
  801d84:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8a:	89 d0                	mov    %edx,%eax
  801d8c:	01 c0                	add    %eax,%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c1 e0 02             	shl    $0x2,%eax
  801d93:	05 44 20 81 00       	add    $0x812044,%eax
  801d98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801d9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da1:	89 d0                	mov    %edx,%eax
  801da3:	01 c0                	add    %eax,%eax
  801da5:	01 d0                	add    %edx,%eax
  801da7:	c1 e0 02             	shl    $0x2,%eax
  801daa:	05 40 20 81 00       	add    $0x812040,%eax
  801daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801db5:	e9 2d 01 00 00       	jmp    801ee7 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801dba:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801dbe:	0f 84 ce 00 00 00    	je     801e92 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801dc4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801dcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dce:	89 d0                	mov    %edx,%eax
  801dd0:	01 c0                	add    %eax,%eax
  801dd2:	01 d0                	add    %edx,%eax
  801dd4:	c1 e0 02             	shl    $0x2,%eax
  801dd7:	05 40 20 81 00       	add    $0x812040,%eax
  801ddc:	8b 10                	mov    (%eax),%edx
  801dde:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801de1:	01 d0                	add    %edx,%eax
  801de3:	48                   	dec    %eax
  801de4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801de7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dea:	ba 00 00 00 00       	mov    $0x0,%edx
  801def:	f7 75 c4             	divl   -0x3c(%ebp)
  801df2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801df5:	29 d0                	sub    %edx,%eax
  801df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801dfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dfd:	89 d0                	mov    %edx,%eax
  801dff:	01 c0                	add    %eax,%eax
  801e01:	01 d0                	add    %edx,%eax
  801e03:	c1 e0 02             	shl    $0x2,%eax
  801e06:	05 44 20 81 00       	add    $0x812044,%eax
  801e0b:	8b 00                	mov    (%eax),%eax
  801e0d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e10:	75 47                	jne    801e59 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801e12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e15:	89 d0                	mov    %edx,%eax
  801e17:	01 c0                	add    %eax,%eax
  801e19:	01 d0                	add    %edx,%eax
  801e1b:	c1 e0 02             	shl    $0x2,%eax
  801e1e:	05 48 20 81 00       	add    $0x812048,%eax
  801e23:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801e26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e29:	89 d0                	mov    %edx,%eax
  801e2b:	01 c0                	add    %eax,%eax
  801e2d:	01 d0                	add    %edx,%eax
  801e2f:	c1 e0 02             	shl    $0x2,%eax
  801e32:	05 44 20 81 00       	add    $0x812044,%eax
  801e37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801e3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e40:	89 d0                	mov    %edx,%eax
  801e42:	01 c0                	add    %eax,%eax
  801e44:	01 d0                	add    %edx,%eax
  801e46:	c1 e0 02             	shl    $0x2,%eax
  801e49:	05 40 20 81 00       	add    $0x812040,%eax
  801e4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e54:	e9 8e 00 00 00       	jmp    801ee7 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801e59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e65:	89 d0                	mov    %edx,%eax
  801e67:	01 c0                	add    %eax,%eax
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	c1 e0 02             	shl    $0x2,%eax
  801e6e:	05 40 20 81 00       	add    $0x812040,%eax
  801e73:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e78:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e7b:	89 c2                	mov    %eax,%edx
  801e7d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e80:	89 c8                	mov    %ecx,%eax
  801e82:	01 c0                	add    %eax,%eax
  801e84:	01 c8                	add    %ecx,%eax
  801e86:	c1 e0 02             	shl    $0x2,%eax
  801e89:	05 44 20 81 00       	add    $0x812044,%eax
  801e8e:	89 10                	mov    %edx,(%eax)
  801e90:	eb 55                	jmp    801ee7 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801e92:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e99:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801e9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ea2:	01 d0                	add    %edx,%eax
  801ea4:	48                   	dec    %eax
  801ea5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ea8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801eab:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb0:	f7 75 d0             	divl   -0x30(%ebp)
  801eb3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801eb6:	29 d0                	sub    %edx,%eax
  801eb8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801ebb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ebe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ec1:	01 d0                	add    %edx,%eax
  801ec3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801ec8:	76 0a                	jbe    801ed4 <malloc+0x2c7>
            return NULL;
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecf:	e9 97 00 00 00       	jmp    801f6b <malloc+0x35e>
        va = start;
  801ed4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ed7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801eda:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801edd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ee0:	01 d0                	add    %edx,%eax
  801ee2:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ee7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801eee:	eb 5e                	jmp    801f4e <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ef3:	89 d0                	mov    %edx,%eax
  801ef5:	01 c0                	add    %eax,%eax
  801ef7:	01 d0                	add    %edx,%eax
  801ef9:	c1 e0 02             	shl    $0x2,%eax
  801efc:	05 48 60 80 00       	add    $0x806048,%eax
  801f01:	8a 00                	mov    (%eax),%al
  801f03:	84 c0                	test   %al,%al
  801f05:	75 44                	jne    801f4b <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801f07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f0a:	89 d0                	mov    %edx,%eax
  801f0c:	01 c0                	add    %eax,%eax
  801f0e:	01 d0                	add    %edx,%eax
  801f10:	c1 e0 02             	shl    $0x2,%eax
  801f13:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801f19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f1c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801f1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f21:	89 d0                	mov    %edx,%eax
  801f23:	01 c0                	add    %eax,%eax
  801f25:	01 d0                	add    %edx,%eax
  801f27:	c1 e0 02             	shl    $0x2,%eax
  801f2a:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801f30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f33:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801f35:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f38:	89 d0                	mov    %edx,%eax
  801f3a:	01 c0                	add    %eax,%eax
  801f3c:	01 d0                	add    %edx,%eax
  801f3e:	c1 e0 02             	shl    $0x2,%eax
  801f41:	05 48 60 80 00       	add    $0x806048,%eax
  801f46:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801f49:	eb 0c                	jmp    801f57 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f4b:	ff 45 e0             	incl   -0x20(%ebp)
  801f4e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f55:	7e 99                	jle    801ef0 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801f57:	83 ec 08             	sub    $0x8,%esp
  801f5a:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f5d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f60:	e8 a2 19 00 00       	call   803907 <sys_allocate_user_mem>
  801f65:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801f73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f77:	0f 84 fa 03 00 00    	je     802377 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801f83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	79 1c                	jns    801fa6 <free+0x39>
  801f8a:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801f91:	77 13                	ja     801fa6 <free+0x39>
    {
        free_block(virtual_address);
  801f93:	83 ec 0c             	sub    $0xc,%esp
  801f96:	ff 75 08             	pushl  0x8(%ebp)
  801f99:	e8 09 21 00 00       	call   8040a7 <free_block>
  801f9e:	83 c4 10             	add    $0x10,%esp
        return;
  801fa1:	e9 d2 03 00 00       	jmp    802378 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801fa6:	a1 30 61 83 00       	mov    0x836130,%eax
  801fab:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801fae:	72 09                	jb     801fb9 <free+0x4c>
  801fb0:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801fb7:	76 17                	jbe    801fd0 <free+0x63>
        panic("free: invalid address");
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 a1 4e 80 00       	push   $0x804ea1
  801fc1:	68 9b 00 00 00       	push   $0x9b
  801fc6:	68 58 4e 80 00       	push   $0x804e58
  801fcb:	e8 a5 e7 ff ff       	call   800775 <_panic>

    uint32 size = 0;
  801fd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801fd7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fde:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801fe5:	eb 50                	jmp    802037 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801fe7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fea:	89 d0                	mov    %edx,%eax
  801fec:	01 c0                	add    %eax,%eax
  801fee:	01 d0                	add    %edx,%eax
  801ff0:	c1 e0 02             	shl    $0x2,%eax
  801ff3:	05 48 60 80 00       	add    $0x806048,%eax
  801ff8:	8a 00                	mov    (%eax),%al
  801ffa:	84 c0                	test   %al,%al
  801ffc:	74 36                	je     802034 <free+0xc7>
  801ffe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802001:	89 d0                	mov    %edx,%eax
  802003:	01 c0                	add    %eax,%eax
  802005:	01 d0                	add    %edx,%eax
  802007:	c1 e0 02             	shl    $0x2,%eax
  80200a:	05 40 60 80 00       	add    $0x806040,%eax
  80200f:	8b 00                	mov    (%eax),%eax
  802011:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802014:	75 1e                	jne    802034 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  802016:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802019:	89 d0                	mov    %edx,%eax
  80201b:	01 c0                	add    %eax,%eax
  80201d:	01 d0                	add    %edx,%eax
  80201f:	c1 e0 02             	shl    $0x2,%eax
  802022:	05 44 60 80 00       	add    $0x806044,%eax
  802027:	8b 00                	mov    (%eax),%eax
  802029:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  80202c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  802032:	eb 0c                	jmp    802040 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802034:	ff 45 ec             	incl   -0x14(%ebp)
  802037:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80203e:	7e a7                	jle    801fe7 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  802040:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802044:	74 06                	je     80204c <free+0xdf>
  802046:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204a:	75 17                	jne    802063 <free+0xf6>
        panic("free: unknown block");
  80204c:	83 ec 04             	sub    $0x4,%esp
  80204f:	68 b7 4e 80 00       	push   $0x804eb7
  802054:	68 a9 00 00 00       	push   $0xa9
  802059:	68 58 4e 80 00       	push   $0x804e58
  80205e:	e8 12 e7 ff ff       	call   800775 <_panic>

    uhp_allocs[idx].used = 0;
  802063:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802066:	89 d0                	mov    %edx,%eax
  802068:	01 c0                	add    %eax,%eax
  80206a:	01 d0                	add    %edx,%eax
  80206c:	c1 e0 02             	shl    $0x2,%eax
  80206f:	05 48 60 80 00       	add    $0x806048,%eax
  802074:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  802077:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80207e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802085:	eb 64                	jmp    8020eb <free+0x17e>
    {
        if (!uhp_frees[i].free)
  802087:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80208a:	89 d0                	mov    %edx,%eax
  80208c:	01 c0                	add    %eax,%eax
  80208e:	01 d0                	add    %edx,%eax
  802090:	c1 e0 02             	shl    $0x2,%eax
  802093:	05 48 20 81 00       	add    $0x812048,%eax
  802098:	8a 00                	mov    (%eax),%al
  80209a:	84 c0                	test   %al,%al
  80209c:	75 4a                	jne    8020e8 <free+0x17b>
        {
            uhp_frees[i].va = va;
  80209e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020a1:	89 d0                	mov    %edx,%eax
  8020a3:	01 c0                	add    %eax,%eax
  8020a5:	01 d0                	add    %edx,%eax
  8020a7:	c1 e0 02             	shl    $0x2,%eax
  8020aa:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8020b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020b3:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  8020b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020b8:	89 d0                	mov    %edx,%eax
  8020ba:	01 c0                	add    %eax,%eax
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	c1 e0 02             	shl    $0x2,%eax
  8020c1:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  8020cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020cf:	89 d0                	mov    %edx,%eax
  8020d1:	01 c0                	add    %eax,%eax
  8020d3:	01 d0                	add    %edx,%eax
  8020d5:	c1 e0 02             	shl    $0x2,%eax
  8020d8:	05 48 20 81 00       	add    $0x812048,%eax
  8020dd:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  8020e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  8020e6:	eb 0c                	jmp    8020f4 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020e8:	ff 45 e4             	incl   -0x1c(%ebp)
  8020eb:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8020f2:	7e 93                	jle    802087 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  8020f4:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8020f8:	0f 84 f1 01 00 00    	je     8022ef <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802105:	e9 d8 01 00 00       	jmp    8022e2 <free+0x375>
        {
            if (i == fidx) continue;
  80210a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802110:	0f 84 c8 01 00 00    	je     8022de <free+0x371>
            if (uhp_frees[i].free)
  802116:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802119:	89 d0                	mov    %edx,%eax
  80211b:	01 c0                	add    %eax,%eax
  80211d:	01 d0                	add    %edx,%eax
  80211f:	c1 e0 02             	shl    $0x2,%eax
  802122:	05 48 20 81 00       	add    $0x812048,%eax
  802127:	8a 00                	mov    (%eax),%al
  802129:	84 c0                	test   %al,%al
  80212b:	0f 84 ae 01 00 00    	je     8022df <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  802131:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802134:	89 d0                	mov    %edx,%eax
  802136:	01 c0                	add    %eax,%eax
  802138:	01 d0                	add    %edx,%eax
  80213a:	c1 e0 02             	shl    $0x2,%eax
  80213d:	05 40 20 81 00       	add    $0x812040,%eax
  802142:	8b 08                	mov    (%eax),%ecx
  802144:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802147:	89 d0                	mov    %edx,%eax
  802149:	01 c0                	add    %eax,%eax
  80214b:	01 d0                	add    %edx,%eax
  80214d:	c1 e0 02             	shl    $0x2,%eax
  802150:	05 44 20 81 00       	add    $0x812044,%eax
  802155:	8b 00                	mov    (%eax),%eax
  802157:	01 c1                	add    %eax,%ecx
  802159:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80215c:	89 d0                	mov    %edx,%eax
  80215e:	01 c0                	add    %eax,%eax
  802160:	01 d0                	add    %edx,%eax
  802162:	c1 e0 02             	shl    $0x2,%eax
  802165:	05 40 20 81 00       	add    $0x812040,%eax
  80216a:	8b 00                	mov    (%eax),%eax
  80216c:	39 c1                	cmp    %eax,%ecx
  80216e:	0f 85 a8 00 00 00    	jne    80221c <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802174:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802177:	89 d0                	mov    %edx,%eax
  802179:	01 c0                	add    %eax,%eax
  80217b:	01 d0                	add    %edx,%eax
  80217d:	c1 e0 02             	shl    $0x2,%eax
  802180:	05 40 20 81 00       	add    $0x812040,%eax
  802185:	8b 10                	mov    (%eax),%edx
  802187:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80218a:	89 c8                	mov    %ecx,%eax
  80218c:	01 c0                	add    %eax,%eax
  80218e:	01 c8                	add    %ecx,%eax
  802190:	c1 e0 02             	shl    $0x2,%eax
  802193:	05 40 20 81 00       	add    $0x812040,%eax
  802198:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80219a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80219d:	89 d0                	mov    %edx,%eax
  80219f:	01 c0                	add    %eax,%eax
  8021a1:	01 d0                	add    %edx,%eax
  8021a3:	c1 e0 02             	shl    $0x2,%eax
  8021a6:	05 44 20 81 00       	add    $0x812044,%eax
  8021ab:	8b 08                	mov    (%eax),%ecx
  8021ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021b0:	89 d0                	mov    %edx,%eax
  8021b2:	01 c0                	add    %eax,%eax
  8021b4:	01 d0                	add    %edx,%eax
  8021b6:	c1 e0 02             	shl    $0x2,%eax
  8021b9:	05 44 20 81 00       	add    $0x812044,%eax
  8021be:	8b 00                	mov    (%eax),%eax
  8021c0:	01 c1                	add    %eax,%ecx
  8021c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021c5:	89 d0                	mov    %edx,%eax
  8021c7:	01 c0                	add    %eax,%eax
  8021c9:	01 d0                	add    %edx,%eax
  8021cb:	c1 e0 02             	shl    $0x2,%eax
  8021ce:	05 44 20 81 00       	add    $0x812044,%eax
  8021d3:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8021d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021d8:	89 d0                	mov    %edx,%eax
  8021da:	01 c0                	add    %eax,%eax
  8021dc:	01 d0                	add    %edx,%eax
  8021de:	c1 e0 02             	shl    $0x2,%eax
  8021e1:	05 48 20 81 00       	add    $0x812048,%eax
  8021e6:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8021e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021ec:	89 d0                	mov    %edx,%eax
  8021ee:	01 c0                	add    %eax,%eax
  8021f0:	01 d0                	add    %edx,%eax
  8021f2:	c1 e0 02             	shl    $0x2,%eax
  8021f5:	05 40 20 81 00       	add    $0x812040,%eax
  8021fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802200:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802203:	89 d0                	mov    %edx,%eax
  802205:	01 c0                	add    %eax,%eax
  802207:	01 d0                	add    %edx,%eax
  802209:	c1 e0 02             	shl    $0x2,%eax
  80220c:	05 44 20 81 00       	add    $0x812044,%eax
  802211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802217:	e9 c3 00 00 00       	jmp    8022df <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  80221c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80221f:	89 d0                	mov    %edx,%eax
  802221:	01 c0                	add    %eax,%eax
  802223:	01 d0                	add    %edx,%eax
  802225:	c1 e0 02             	shl    $0x2,%eax
  802228:	05 40 20 81 00       	add    $0x812040,%eax
  80222d:	8b 08                	mov    (%eax),%ecx
  80222f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802232:	89 d0                	mov    %edx,%eax
  802234:	01 c0                	add    %eax,%eax
  802236:	01 d0                	add    %edx,%eax
  802238:	c1 e0 02             	shl    $0x2,%eax
  80223b:	05 44 20 81 00       	add    $0x812044,%eax
  802240:	8b 00                	mov    (%eax),%eax
  802242:	01 c1                	add    %eax,%ecx
  802244:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802247:	89 d0                	mov    %edx,%eax
  802249:	01 c0                	add    %eax,%eax
  80224b:	01 d0                	add    %edx,%eax
  80224d:	c1 e0 02             	shl    $0x2,%eax
  802250:	05 40 20 81 00       	add    $0x812040,%eax
  802255:	8b 00                	mov    (%eax),%eax
  802257:	39 c1                	cmp    %eax,%ecx
  802259:	0f 85 80 00 00 00    	jne    8022df <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80225f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802262:	89 d0                	mov    %edx,%eax
  802264:	01 c0                	add    %eax,%eax
  802266:	01 d0                	add    %edx,%eax
  802268:	c1 e0 02             	shl    $0x2,%eax
  80226b:	05 44 20 81 00       	add    $0x812044,%eax
  802270:	8b 08                	mov    (%eax),%ecx
  802272:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802275:	89 d0                	mov    %edx,%eax
  802277:	01 c0                	add    %eax,%eax
  802279:	01 d0                	add    %edx,%eax
  80227b:	c1 e0 02             	shl    $0x2,%eax
  80227e:	05 44 20 81 00       	add    $0x812044,%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	01 c1                	add    %eax,%ecx
  802287:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80228a:	89 d0                	mov    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	01 d0                	add    %edx,%eax
  802290:	c1 e0 02             	shl    $0x2,%eax
  802293:	05 44 20 81 00       	add    $0x812044,%eax
  802298:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  80229a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80229d:	89 d0                	mov    %edx,%eax
  80229f:	01 c0                	add    %eax,%eax
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	c1 e0 02             	shl    $0x2,%eax
  8022a6:	05 48 20 81 00       	add    $0x812048,%eax
  8022ab:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8022ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022b1:	89 d0                	mov    %edx,%eax
  8022b3:	01 c0                	add    %eax,%eax
  8022b5:	01 d0                	add    %edx,%eax
  8022b7:	c1 e0 02             	shl    $0x2,%eax
  8022ba:	05 40 20 81 00       	add    $0x812040,%eax
  8022bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8022c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022c8:	89 d0                	mov    %edx,%eax
  8022ca:	01 c0                	add    %eax,%eax
  8022cc:	01 d0                	add    %edx,%eax
  8022ce:	c1 e0 02             	shl    $0x2,%eax
  8022d1:	05 44 20 81 00       	add    $0x812044,%eax
  8022d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022dc:	eb 01                	jmp    8022df <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  8022de:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022df:	ff 45 e0             	incl   -0x20(%ebp)
  8022e2:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8022e9:	0f 8e 1b fe ff ff    	jle    80210a <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  8022ef:	a1 30 61 83 00       	mov    0x836130,%eax
  8022f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022f7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8022fe:	eb 53                	jmp    802353 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802300:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802303:	89 d0                	mov    %edx,%eax
  802305:	01 c0                	add    %eax,%eax
  802307:	01 d0                	add    %edx,%eax
  802309:	c1 e0 02             	shl    $0x2,%eax
  80230c:	05 48 60 80 00       	add    $0x806048,%eax
  802311:	8a 00                	mov    (%eax),%al
  802313:	84 c0                	test   %al,%al
  802315:	74 39                	je     802350 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802317:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80231a:	89 d0                	mov    %edx,%eax
  80231c:	01 c0                	add    %eax,%eax
  80231e:	01 d0                	add    %edx,%eax
  802320:	c1 e0 02             	shl    $0x2,%eax
  802323:	05 40 60 80 00       	add    $0x806040,%eax
  802328:	8b 08                	mov    (%eax),%ecx
  80232a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80232d:	89 d0                	mov    %edx,%eax
  80232f:	01 c0                	add    %eax,%eax
  802331:	01 d0                	add    %edx,%eax
  802333:	c1 e0 02             	shl    $0x2,%eax
  802336:	05 44 60 80 00       	add    $0x806044,%eax
  80233b:	8b 00                	mov    (%eax),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  802342:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802345:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802348:	76 06                	jbe    802350 <free+0x3e3>
  80234a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80234d:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802350:	ff 45 d8             	incl   -0x28(%ebp)
  802353:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80235a:	7e a4                	jle    802300 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  80235c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80235f:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  802364:	83 ec 08             	sub    $0x8,%esp
  802367:	ff 75 f4             	pushl  -0xc(%ebp)
  80236a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80236d:	e8 79 15 00 00       	call   8038eb <sys_free_user_mem>
  802372:	83 c4 10             	add    $0x10,%esp
  802375:	eb 01                	jmp    802378 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802377:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 68             	sub    $0x68,%esp
  802380:	8b 45 10             	mov    0x10(%ebp),%eax
  802383:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802386:	e8 a5 f7 ff ff       	call   801b30 <uheap_init>
	if (size == 0) return NULL ;
  80238b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80238f:	75 0a                	jne    80239b <smalloc+0x21>
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
  802396:	e9 37 03 00 00       	jmp    8026d2 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80239b:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8023a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023a8:	01 d0                	add    %edx,%eax
  8023aa:	48                   	dec    %eax
  8023ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b6:	f7 75 dc             	divl   -0x24(%ebp)
  8023b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023bc:	29 d0                	sub    %edx,%eax
  8023be:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  8023c1:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8023c8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8023cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8023d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8023dd:	e9 85 00 00 00       	jmp    802467 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8023e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023e5:	89 d0                	mov    %edx,%eax
  8023e7:	01 c0                	add    %eax,%eax
  8023e9:	01 d0                	add    %edx,%eax
  8023eb:	c1 e0 02             	shl    $0x2,%eax
  8023ee:	05 48 20 81 00       	add    $0x812048,%eax
  8023f3:	8a 00                	mov    (%eax),%al
  8023f5:	84 c0                	test   %al,%al
  8023f7:	74 20                	je     802419 <smalloc+0x9f>
  8023f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023fc:	89 d0                	mov    %edx,%eax
  8023fe:	01 c0                	add    %eax,%eax
  802400:	01 d0                	add    %edx,%eax
  802402:	c1 e0 02             	shl    $0x2,%eax
  802405:	05 44 20 81 00       	add    $0x812044,%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80240f:	75 08                	jne    802419 <smalloc+0x9f>
        {
            exactIdx = i;
  802411:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802414:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802417:	eb 5b                	jmp    802474 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802419:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80241c:	89 d0                	mov    %edx,%eax
  80241e:	01 c0                	add    %eax,%eax
  802420:	01 d0                	add    %edx,%eax
  802422:	c1 e0 02             	shl    $0x2,%eax
  802425:	05 48 20 81 00       	add    $0x812048,%eax
  80242a:	8a 00                	mov    (%eax),%al
  80242c:	84 c0                	test   %al,%al
  80242e:	74 34                	je     802464 <smalloc+0xea>
  802430:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802433:	89 d0                	mov    %edx,%eax
  802435:	01 c0                	add    %eax,%eax
  802437:	01 d0                	add    %edx,%eax
  802439:	c1 e0 02             	shl    $0x2,%eax
  80243c:	05 44 20 81 00       	add    $0x812044,%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802446:	76 1c                	jbe    802464 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802448:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80244b:	89 d0                	mov    %edx,%eax
  80244d:	01 c0                	add    %eax,%eax
  80244f:	01 d0                	add    %edx,%eax
  802451:	c1 e0 02             	shl    $0x2,%eax
  802454:	05 44 20 81 00       	add    $0x812044,%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80245e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802461:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802464:	ff 45 e8             	incl   -0x18(%ebp)
  802467:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80246e:	0f 8e 6e ff ff ff    	jle    8023e2 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802474:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80247b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80247f:	74 7d                	je     8024fe <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802481:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802488:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248b:	89 d0                	mov    %edx,%eax
  80248d:	01 c0                	add    %eax,%eax
  80248f:	01 d0                	add    %edx,%eax
  802491:	c1 e0 02             	shl    $0x2,%eax
  802494:	05 40 20 81 00       	add    $0x812040,%eax
  802499:	8b 10                	mov    (%eax),%edx
  80249b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80249e:	01 d0                	add    %edx,%eax
  8024a0:	48                   	dec    %eax
  8024a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8024a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ac:	f7 75 bc             	divl   -0x44(%ebp)
  8024af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024b2:	29 d0                	sub    %edx,%eax
  8024b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8024b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ba:	89 d0                	mov    %edx,%eax
  8024bc:	01 c0                	add    %eax,%eax
  8024be:	01 d0                	add    %edx,%eax
  8024c0:	c1 e0 02             	shl    $0x2,%eax
  8024c3:	05 48 20 81 00       	add    $0x812048,%eax
  8024c8:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8024cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ce:	89 d0                	mov    %edx,%eax
  8024d0:	01 c0                	add    %eax,%eax
  8024d2:	01 d0                	add    %edx,%eax
  8024d4:	c1 e0 02             	shl    $0x2,%eax
  8024d7:	05 44 20 81 00       	add    $0x812044,%eax
  8024dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8024e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e5:	89 d0                	mov    %edx,%eax
  8024e7:	01 c0                	add    %eax,%eax
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	c1 e0 02             	shl    $0x2,%eax
  8024ee:	05 40 20 81 00       	add    $0x812040,%eax
  8024f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f9:	e9 2d 01 00 00       	jmp    80262b <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8024fe:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802502:	0f 84 ce 00 00 00    	je     8025d6 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802508:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80250f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	01 c0                	add    %eax,%eax
  802516:	01 d0                	add    %edx,%eax
  802518:	c1 e0 02             	shl    $0x2,%eax
  80251b:	05 40 20 81 00       	add    $0x812040,%eax
  802520:	8b 10                	mov    (%eax),%edx
  802522:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802525:	01 d0                	add    %edx,%eax
  802527:	48                   	dec    %eax
  802528:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80252b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80252e:	ba 00 00 00 00       	mov    $0x0,%edx
  802533:	f7 75 c4             	divl   -0x3c(%ebp)
  802536:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802539:	29 d0                	sub    %edx,%eax
  80253b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80253e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802541:	89 d0                	mov    %edx,%eax
  802543:	01 c0                	add    %eax,%eax
  802545:	01 d0                	add    %edx,%eax
  802547:	c1 e0 02             	shl    $0x2,%eax
  80254a:	05 44 20 81 00       	add    $0x812044,%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802554:	75 47                	jne    80259d <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802556:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802559:	89 d0                	mov    %edx,%eax
  80255b:	01 c0                	add    %eax,%eax
  80255d:	01 d0                	add    %edx,%eax
  80255f:	c1 e0 02             	shl    $0x2,%eax
  802562:	05 48 20 81 00       	add    $0x812048,%eax
  802567:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80256a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256d:	89 d0                	mov    %edx,%eax
  80256f:	01 c0                	add    %eax,%eax
  802571:	01 d0                	add    %edx,%eax
  802573:	c1 e0 02             	shl    $0x2,%eax
  802576:	05 44 20 81 00       	add    $0x812044,%eax
  80257b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802581:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802584:	89 d0                	mov    %edx,%eax
  802586:	01 c0                	add    %eax,%eax
  802588:	01 d0                	add    %edx,%eax
  80258a:	c1 e0 02             	shl    $0x2,%eax
  80258d:	05 40 20 81 00       	add    $0x812040,%eax
  802592:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802598:	e9 8e 00 00 00       	jmp    80262b <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80259d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025a3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8025a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a9:	89 d0                	mov    %edx,%eax
  8025ab:	01 c0                	add    %eax,%eax
  8025ad:	01 d0                	add    %edx,%eax
  8025af:	c1 e0 02             	shl    $0x2,%eax
  8025b2:	05 40 20 81 00       	add    $0x812040,%eax
  8025b7:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8025b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8025bf:	89 c2                	mov    %eax,%edx
  8025c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025c4:	89 c8                	mov    %ecx,%eax
  8025c6:	01 c0                	add    %eax,%eax
  8025c8:	01 c8                	add    %ecx,%eax
  8025ca:	c1 e0 02             	shl    $0x2,%eax
  8025cd:	05 44 20 81 00       	add    $0x812044,%eax
  8025d2:	89 10                	mov    %edx,(%eax)
  8025d4:	eb 55                	jmp    80262b <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8025d6:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8025dd:	8b 15 88 60 83 00    	mov    0x836088,%edx
  8025e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025e6:	01 d0                	add    %edx,%eax
  8025e8:	48                   	dec    %eax
  8025e9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8025ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f4:	f7 75 d0             	divl   -0x30(%ebp)
  8025f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025fa:	29 d0                	sub    %edx,%eax
  8025fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8025ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802602:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802605:	01 d0                	add    %edx,%eax
  802607:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80260c:	76 0a                	jbe    802618 <smalloc+0x29e>
            return NULL;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
  802613:	e9 ba 00 00 00       	jmp    8026d2 <smalloc+0x358>
        va = start;
  802618:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80261b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80261e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802621:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802624:	01 d0                	add    %edx,%eax
  802626:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80262b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802632:	eb 5e                	jmp    802692 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802634:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802637:	89 d0                	mov    %edx,%eax
  802639:	01 c0                	add    %eax,%eax
  80263b:	01 d0                	add    %edx,%eax
  80263d:	c1 e0 02             	shl    $0x2,%eax
  802640:	05 48 60 80 00       	add    $0x806048,%eax
  802645:	8a 00                	mov    (%eax),%al
  802647:	84 c0                	test   %al,%al
  802649:	75 44                	jne    80268f <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80264b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80264e:	89 d0                	mov    %edx,%eax
  802650:	01 c0                	add    %eax,%eax
  802652:	01 d0                	add    %edx,%eax
  802654:	c1 e0 02             	shl    $0x2,%eax
  802657:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80265d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802660:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802662:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802665:	89 d0                	mov    %edx,%eax
  802667:	01 c0                	add    %eax,%eax
  802669:	01 d0                	add    %edx,%eax
  80266b:	c1 e0 02             	shl    $0x2,%eax
  80266e:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802677:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802679:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80267c:	89 d0                	mov    %edx,%eax
  80267e:	01 c0                	add    %eax,%eax
  802680:	01 d0                	add    %edx,%eax
  802682:	c1 e0 02             	shl    $0x2,%eax
  802685:	05 48 60 80 00       	add    $0x806048,%eax
  80268a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80268d:	eb 0c                	jmp    80269b <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80268f:	ff 45 e0             	incl   -0x20(%ebp)
  802692:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802699:	7e 99                	jle    802634 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80269b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80269e:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8026a2:	52                   	push   %edx
  8026a3:	50                   	push   %eax
  8026a4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8026a7:	ff 75 08             	pushl  0x8(%ebp)
  8026aa:	e8 de 0e 00 00       	call   80358d <sys_create_shared_object>
  8026af:	83 c4 10             	add    $0x10,%esp
  8026b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8026b5:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8026b9:	75 07                	jne    8026c2 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8026bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8026c0:	eb 10                	jmp    8026d2 <smalloc+0x358>
    if (r < 0)
  8026c2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8026c6:	79 07                	jns    8026cf <smalloc+0x355>
        return NULL;
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cd:	eb 03                	jmp    8026d2 <smalloc+0x358>
    return (void*)va;
  8026cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026da:	e8 51 f4 ff ff       	call   801b30 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8026df:	83 ec 08             	sub    $0x8,%esp
  8026e2:	ff 75 0c             	pushl  0xc(%ebp)
  8026e5:	ff 75 08             	pushl  0x8(%ebp)
  8026e8:	e8 ca 0e 00 00       	call   8035b7 <sys_size_of_shared_object>
  8026ed:	83 c4 10             	add    $0x10,%esp
  8026f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8026f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8026f7:	7f 0a                	jg     802703 <sget+0x2f>
        return NULL;
  8026f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fe:	e9 28 03 00 00       	jmp    802a2b <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802703:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80270a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80270d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802710:	01 d0                	add    %edx,%eax
  802712:	48                   	dec    %eax
  802713:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802716:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802719:	ba 00 00 00 00       	mov    $0x0,%edx
  80271e:	f7 75 d8             	divl   -0x28(%ebp)
  802721:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802724:	29 d0                	sub    %edx,%eax
  802726:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802729:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802730:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802737:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80273e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802745:	e9 85 00 00 00       	jmp    8027cf <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80274a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274d:	89 d0                	mov    %edx,%eax
  80274f:	01 c0                	add    %eax,%eax
  802751:	01 d0                	add    %edx,%eax
  802753:	c1 e0 02             	shl    $0x2,%eax
  802756:	05 48 20 81 00       	add    $0x812048,%eax
  80275b:	8a 00                	mov    (%eax),%al
  80275d:	84 c0                	test   %al,%al
  80275f:	74 20                	je     802781 <sget+0xad>
  802761:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802764:	89 d0                	mov    %edx,%eax
  802766:	01 c0                	add    %eax,%eax
  802768:	01 d0                	add    %edx,%eax
  80276a:	c1 e0 02             	shl    $0x2,%eax
  80276d:	05 44 20 81 00       	add    $0x812044,%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802777:	75 08                	jne    802781 <sget+0xad>
        {
            exactIdx = i;
  802779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80277f:	eb 5b                	jmp    8027dc <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802781:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802784:	89 d0                	mov    %edx,%eax
  802786:	01 c0                	add    %eax,%eax
  802788:	01 d0                	add    %edx,%eax
  80278a:	c1 e0 02             	shl    $0x2,%eax
  80278d:	05 48 20 81 00       	add    $0x812048,%eax
  802792:	8a 00                	mov    (%eax),%al
  802794:	84 c0                	test   %al,%al
  802796:	74 34                	je     8027cc <sget+0xf8>
  802798:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80279b:	89 d0                	mov    %edx,%eax
  80279d:	01 c0                	add    %eax,%eax
  80279f:	01 d0                	add    %edx,%eax
  8027a1:	c1 e0 02             	shl    $0x2,%eax
  8027a4:	05 44 20 81 00       	add    $0x812044,%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027ae:	76 1c                	jbe    8027cc <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8027b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	01 c0                	add    %eax,%eax
  8027b7:	01 d0                	add    %edx,%eax
  8027b9:	c1 e0 02             	shl    $0x2,%eax
  8027bc:	05 44 20 81 00       	add    $0x812044,%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8027c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8027cc:	ff 45 e8             	incl   -0x18(%ebp)
  8027cf:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8027d6:	0f 8e 6e ff ff ff    	jle    80274a <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8027dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8027e3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8027e7:	74 7d                	je     802866 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8027e9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8027f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f3:	89 d0                	mov    %edx,%eax
  8027f5:	01 c0                	add    %eax,%eax
  8027f7:	01 d0                	add    %edx,%eax
  8027f9:	c1 e0 02             	shl    $0x2,%eax
  8027fc:	05 40 20 81 00       	add    $0x812040,%eax
  802801:	8b 10                	mov    (%eax),%edx
  802803:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802806:	01 d0                	add    %edx,%eax
  802808:	48                   	dec    %eax
  802809:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80280c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80280f:	ba 00 00 00 00       	mov    $0x0,%edx
  802814:	f7 75 b8             	divl   -0x48(%ebp)
  802817:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80281a:	29 d0                	sub    %edx,%eax
  80281c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80281f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802822:	89 d0                	mov    %edx,%eax
  802824:	01 c0                	add    %eax,%eax
  802826:	01 d0                	add    %edx,%eax
  802828:	c1 e0 02             	shl    $0x2,%eax
  80282b:	05 48 20 81 00       	add    $0x812048,%eax
  802830:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802836:	89 d0                	mov    %edx,%eax
  802838:	01 c0                	add    %eax,%eax
  80283a:	01 d0                	add    %edx,%eax
  80283c:	c1 e0 02             	shl    $0x2,%eax
  80283f:	05 44 20 81 00       	add    $0x812044,%eax
  802844:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80284a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284d:	89 d0                	mov    %edx,%eax
  80284f:	01 c0                	add    %eax,%eax
  802851:	01 d0                	add    %edx,%eax
  802853:	c1 e0 02             	shl    $0x2,%eax
  802856:	05 40 20 81 00       	add    $0x812040,%eax
  80285b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802861:	e9 2d 01 00 00       	jmp    802993 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802866:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80286a:	0f 84 ce 00 00 00    	je     80293e <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802870:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802877:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80287a:	89 d0                	mov    %edx,%eax
  80287c:	01 c0                	add    %eax,%eax
  80287e:	01 d0                	add    %edx,%eax
  802880:	c1 e0 02             	shl    $0x2,%eax
  802883:	05 40 20 81 00       	add    $0x812040,%eax
  802888:	8b 10                	mov    (%eax),%edx
  80288a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80288d:	01 d0                	add    %edx,%eax
  80288f:	48                   	dec    %eax
  802890:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802893:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802896:	ba 00 00 00 00       	mov    $0x0,%edx
  80289b:	f7 75 c0             	divl   -0x40(%ebp)
  80289e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028a1:	29 d0                	sub    %edx,%eax
  8028a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8028a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a9:	89 d0                	mov    %edx,%eax
  8028ab:	01 c0                	add    %eax,%eax
  8028ad:	01 d0                	add    %edx,%eax
  8028af:	c1 e0 02             	shl    $0x2,%eax
  8028b2:	05 44 20 81 00       	add    $0x812044,%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8028bc:	75 47                	jne    802905 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8028be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c1:	89 d0                	mov    %edx,%eax
  8028c3:	01 c0                	add    %eax,%eax
  8028c5:	01 d0                	add    %edx,%eax
  8028c7:	c1 e0 02             	shl    $0x2,%eax
  8028ca:	05 48 20 81 00       	add    $0x812048,%eax
  8028cf:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8028d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d5:	89 d0                	mov    %edx,%eax
  8028d7:	01 c0                	add    %eax,%eax
  8028d9:	01 d0                	add    %edx,%eax
  8028db:	c1 e0 02             	shl    $0x2,%eax
  8028de:	05 44 20 81 00       	add    $0x812044,%eax
  8028e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8028e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ec:	89 d0                	mov    %edx,%eax
  8028ee:	01 c0                	add    %eax,%eax
  8028f0:	01 d0                	add    %edx,%eax
  8028f2:	c1 e0 02             	shl    $0x2,%eax
  8028f5:	05 40 20 81 00       	add    $0x812040,%eax
  8028fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802900:	e9 8e 00 00 00       	jmp    802993 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802905:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802908:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80290b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80290e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802911:	89 d0                	mov    %edx,%eax
  802913:	01 c0                	add    %eax,%eax
  802915:	01 d0                	add    %edx,%eax
  802917:	c1 e0 02             	shl    $0x2,%eax
  80291a:	05 40 20 81 00       	add    $0x812040,%eax
  80291f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802927:	89 c2                	mov    %eax,%edx
  802929:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80292c:	89 c8                	mov    %ecx,%eax
  80292e:	01 c0                	add    %eax,%eax
  802930:	01 c8                	add    %ecx,%eax
  802932:	c1 e0 02             	shl    $0x2,%eax
  802935:	05 44 20 81 00       	add    $0x812044,%eax
  80293a:	89 10                	mov    %edx,(%eax)
  80293c:	eb 55                	jmp    802993 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80293e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802945:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80294b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294e:	01 d0                	add    %edx,%eax
  802950:	48                   	dec    %eax
  802951:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802954:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802957:	ba 00 00 00 00       	mov    $0x0,%edx
  80295c:	f7 75 cc             	divl   -0x34(%ebp)
  80295f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802962:	29 d0                	sub    %edx,%eax
  802964:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802967:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80296a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80296d:	01 d0                	add    %edx,%eax
  80296f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802974:	76 0a                	jbe    802980 <sget+0x2ac>
            return NULL;
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	e9 ab 00 00 00       	jmp    802a2b <sget+0x357>
        va = start;
  802980:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802983:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802986:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802989:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80298c:	01 d0                	add    %edx,%eax
  80298e:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802993:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80299a:	eb 5e                	jmp    8029fa <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  80299c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80299f:	89 d0                	mov    %edx,%eax
  8029a1:	01 c0                	add    %eax,%eax
  8029a3:	01 d0                	add    %edx,%eax
  8029a5:	c1 e0 02             	shl    $0x2,%eax
  8029a8:	05 48 60 80 00       	add    $0x806048,%eax
  8029ad:	8a 00                	mov    (%eax),%al
  8029af:	84 c0                	test   %al,%al
  8029b1:	75 44                	jne    8029f7 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8029b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029b6:	89 d0                	mov    %edx,%eax
  8029b8:	01 c0                	add    %eax,%eax
  8029ba:	01 d0                	add    %edx,%eax
  8029bc:	c1 e0 02             	shl    $0x2,%eax
  8029bf:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  8029c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8029ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029cd:	89 d0                	mov    %edx,%eax
  8029cf:	01 c0                	add    %eax,%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	c1 e0 02             	shl    $0x2,%eax
  8029d6:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8029dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029df:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8029e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029e4:	89 d0                	mov    %edx,%eax
  8029e6:	01 c0                	add    %eax,%eax
  8029e8:	01 d0                	add    %edx,%eax
  8029ea:	c1 e0 02             	shl    $0x2,%eax
  8029ed:	05 48 60 80 00       	add    $0x806048,%eax
  8029f2:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8029f5:	eb 0c                	jmp    802a03 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029f7:	ff 45 e0             	incl   -0x20(%ebp)
  8029fa:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802a01:	7e 99                	jle    80299c <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a06:	83 ec 04             	sub    $0x4,%esp
  802a09:	50                   	push   %eax
  802a0a:	ff 75 0c             	pushl  0xc(%ebp)
  802a0d:	ff 75 08             	pushl  0x8(%ebp)
  802a10:	e8 bf 0b 00 00       	call   8035d4 <sys_get_shared_object>
  802a15:	83 c4 10             	add    $0x10,%esp
  802a18:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802a1b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a1f:	79 07                	jns    802a28 <sget+0x354>
        return NULL;
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
  802a26:	eb 03                	jmp    802a2b <sget+0x357>
    return (void*)va;
  802a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802a2b:	c9                   	leave  
  802a2c:	c3                   	ret    

00802a2d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a2d:	55                   	push   %ebp
  802a2e:	89 e5                	mov    %esp,%ebp
  802a30:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a33:	e8 f8 f0 ff ff       	call   801b30 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802a38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3c:	75 13                	jne    802a51 <realloc+0x24>
		return malloc(new_size);
  802a3e:	83 ec 0c             	sub    $0xc,%esp
  802a41:	ff 75 0c             	pushl  0xc(%ebp)
  802a44:	e8 c4 f1 ff ff       	call   801c0d <malloc>
  802a49:	83 c4 10             	add    $0x10,%esp
  802a4c:	e9 f4 05 00 00       	jmp    803045 <realloc+0x618>
	if (new_size == 0)
  802a51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a55:	75 18                	jne    802a6f <realloc+0x42>
	{
		free(virtual_address);
  802a57:	83 ec 0c             	sub    $0xc,%esp
  802a5a:	ff 75 08             	pushl  0x8(%ebp)
  802a5d:	e8 0b f5 ff ff       	call   801f6d <free>
  802a62:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802a65:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6a:	e9 d6 05 00 00       	jmp    803045 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802a75:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	79 74                	jns    802af0 <realloc+0xc3>
  802a7c:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802a83:	77 6b                	ja     802af0 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802a85:	83 ec 0c             	sub    $0xc,%esp
  802a88:	ff 75 0c             	pushl  0xc(%ebp)
  802a8b:	e8 7d f1 ff ff       	call   801c0d <malloc>
  802a90:	83 c4 10             	add    $0x10,%esp
  802a93:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802a96:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802a9a:	75 0a                	jne    802aa6 <realloc+0x79>
			return NULL;
  802a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa1:	e9 9f 05 00 00       	jmp    803045 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802aa6:	83 ec 0c             	sub    $0xc,%esp
  802aa9:	ff 75 08             	pushl  0x8(%ebp)
  802aac:	e8 e0 11 00 00       	call   803c91 <get_block_size>
  802ab1:	83 c4 10             	add    $0x10,%esp
  802ab4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802ab7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802abd:	39 d0                	cmp    %edx,%eax
  802abf:	76 02                	jbe    802ac3 <realloc+0x96>
  802ac1:	89 d0                	mov    %edx,%eax
  802ac3:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	ff 75 c0             	pushl  -0x40(%ebp)
  802acc:	ff 75 08             	pushl  0x8(%ebp)
  802acf:	ff 75 c8             	pushl  -0x38(%ebp)
  802ad2:	e8 56 eb ff ff       	call   80162d <memmove>
  802ad7:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802ada:	83 ec 0c             	sub    $0xc,%esp
  802add:	ff 75 08             	pushl  0x8(%ebp)
  802ae0:	e8 88 f4 ff ff       	call   801f6d <free>
  802ae5:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802ae8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802aeb:	e9 55 05 00 00       	jmp    803045 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802af0:	a1 30 61 83 00       	mov    0x836130,%eax
  802af5:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802af8:	72 09                	jb     802b03 <realloc+0xd6>
  802afa:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802b01:	76 0a                	jbe    802b0d <realloc+0xe0>
		return NULL;
  802b03:	b8 00 00 00 00       	mov    $0x0,%eax
  802b08:	e9 38 05 00 00       	jmp    803045 <realloc+0x618>
	uint32 oldsz = 0;
  802b0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802b14:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b1b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b22:	eb 50                	jmp    802b74 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b27:	89 d0                	mov    %edx,%eax
  802b29:	01 c0                	add    %eax,%eax
  802b2b:	01 d0                	add    %edx,%eax
  802b2d:	c1 e0 02             	shl    $0x2,%eax
  802b30:	05 48 60 80 00       	add    $0x806048,%eax
  802b35:	8a 00                	mov    (%eax),%al
  802b37:	84 c0                	test   %al,%al
  802b39:	74 36                	je     802b71 <realloc+0x144>
  802b3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b3e:	89 d0                	mov    %edx,%eax
  802b40:	01 c0                	add    %eax,%eax
  802b42:	01 d0                	add    %edx,%eax
  802b44:	c1 e0 02             	shl    $0x2,%eax
  802b47:	05 40 60 80 00       	add    $0x806040,%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802b51:	75 1e                	jne    802b71 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802b53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b56:	89 d0                	mov    %edx,%eax
  802b58:	01 c0                	add    %eax,%eax
  802b5a:	01 d0                	add    %edx,%eax
  802b5c:	c1 e0 02             	shl    $0x2,%eax
  802b5f:	05 44 60 80 00       	add    $0x806044,%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802b6f:	eb 0c                	jmp    802b7d <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b71:	ff 45 ec             	incl   -0x14(%ebp)
  802b74:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b7b:	7e a7                	jle    802b24 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802b7d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b81:	75 0a                	jne    802b8d <realloc+0x160>
		return NULL;
  802b83:	b8 00 00 00 00       	mov    $0x0,%eax
  802b88:	e9 b8 04 00 00       	jmp    803045 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802b8d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802b94:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b97:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b9a:	01 d0                	add    %edx,%eax
  802b9c:	48                   	dec    %eax
  802b9d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802ba0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba8:	f7 75 bc             	divl   -0x44(%ebp)
  802bab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bae:	29 d0                	sub    %edx,%eax
  802bb0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802bb3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bb6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802bb9:	75 08                	jne    802bc3 <realloc+0x196>
		return virtual_address;
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	e9 82 04 00 00       	jmp    803045 <realloc+0x618>
	if (req < oldsz)
  802bc3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bc6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802bc9:	0f 83 cd 02 00 00    	jae    802e9c <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802bd5:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802bd8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bdb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bde:	01 d0                	add    %edx,%eax
  802be0:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802be3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be6:	89 d0                	mov    %edx,%eax
  802be8:	01 c0                	add    %eax,%eax
  802bea:	01 d0                	add    %edx,%eax
  802bec:	c1 e0 02             	shl    $0x2,%eax
  802bef:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802bf5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bf8:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802bfa:	83 ec 08             	sub    $0x8,%esp
  802bfd:	ff 75 b0             	pushl  -0x50(%ebp)
  802c00:	ff 75 ac             	pushl  -0x54(%ebp)
  802c03:	e8 e3 0c 00 00       	call   8038eb <sys_free_user_mem>
  802c08:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802c0b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802c19:	eb 64                	jmp    802c7f <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802c1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c1e:	89 d0                	mov    %edx,%eax
  802c20:	01 c0                	add    %eax,%eax
  802c22:	01 d0                	add    %edx,%eax
  802c24:	c1 e0 02             	shl    $0x2,%eax
  802c27:	05 48 20 81 00       	add    $0x812048,%eax
  802c2c:	8a 00                	mov    (%eax),%al
  802c2e:	84 c0                	test   %al,%al
  802c30:	75 4a                	jne    802c7c <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802c32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c35:	89 d0                	mov    %edx,%eax
  802c37:	01 c0                	add    %eax,%eax
  802c39:	01 d0                	add    %edx,%eax
  802c3b:	c1 e0 02             	shl    $0x2,%eax
  802c3e:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802c44:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c47:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802c49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c4c:	89 d0                	mov    %edx,%eax
  802c4e:	01 c0                	add    %eax,%eax
  802c50:	01 d0                	add    %edx,%eax
  802c52:	c1 e0 02             	shl    $0x2,%eax
  802c55:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802c5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c5e:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802c60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c63:	89 d0                	mov    %edx,%eax
  802c65:	01 c0                	add    %eax,%eax
  802c67:	01 d0                	add    %edx,%eax
  802c69:	c1 e0 02             	shl    $0x2,%eax
  802c6c:	05 48 20 81 00       	add    $0x812048,%eax
  802c71:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c77:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802c7a:	eb 0c                	jmp    802c88 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c7c:	ff 45 e4             	incl   -0x1c(%ebp)
  802c7f:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802c86:	7e 93                	jle    802c1b <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802c88:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802c8c:	0f 84 8d 01 00 00    	je     802e1f <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c99:	e9 74 01 00 00       	jmp    802e12 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802c9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ca4:	0f 84 64 01 00 00    	je     802e0e <realloc+0x3e1>
				if (uhp_frees[k].free)
  802caa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cad:	89 d0                	mov    %edx,%eax
  802caf:	01 c0                	add    %eax,%eax
  802cb1:	01 d0                	add    %edx,%eax
  802cb3:	c1 e0 02             	shl    $0x2,%eax
  802cb6:	05 48 20 81 00       	add    $0x812048,%eax
  802cbb:	8a 00                	mov    (%eax),%al
  802cbd:	84 c0                	test   %al,%al
  802cbf:	0f 84 4a 01 00 00    	je     802e0f <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc8:	89 d0                	mov    %edx,%eax
  802cca:	01 c0                	add    %eax,%eax
  802ccc:	01 d0                	add    %edx,%eax
  802cce:	c1 e0 02             	shl    $0x2,%eax
  802cd1:	05 40 20 81 00       	add    $0x812040,%eax
  802cd6:	8b 08                	mov    (%eax),%ecx
  802cd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cdb:	89 d0                	mov    %edx,%eax
  802cdd:	01 c0                	add    %eax,%eax
  802cdf:	01 d0                	add    %edx,%eax
  802ce1:	c1 e0 02             	shl    $0x2,%eax
  802ce4:	05 44 20 81 00       	add    $0x812044,%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	01 c1                	add    %eax,%ecx
  802ced:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cf0:	89 d0                	mov    %edx,%eax
  802cf2:	01 c0                	add    %eax,%eax
  802cf4:	01 d0                	add    %edx,%eax
  802cf6:	c1 e0 02             	shl    $0x2,%eax
  802cf9:	05 40 20 81 00       	add    $0x812040,%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	39 c1                	cmp    %eax,%ecx
  802d02:	75 7a                	jne    802d7e <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802d04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d07:	89 d0                	mov    %edx,%eax
  802d09:	01 c0                	add    %eax,%eax
  802d0b:	01 d0                	add    %edx,%eax
  802d0d:	c1 e0 02             	shl    $0x2,%eax
  802d10:	05 40 20 81 00       	add    $0x812040,%eax
  802d15:	8b 10                	mov    (%eax),%edx
  802d17:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802d1a:	89 c8                	mov    %ecx,%eax
  802d1c:	01 c0                	add    %eax,%eax
  802d1e:	01 c8                	add    %ecx,%eax
  802d20:	c1 e0 02             	shl    $0x2,%eax
  802d23:	05 40 20 81 00       	add    $0x812040,%eax
  802d28:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d2d:	89 d0                	mov    %edx,%eax
  802d2f:	01 c0                	add    %eax,%eax
  802d31:	01 d0                	add    %edx,%eax
  802d33:	c1 e0 02             	shl    $0x2,%eax
  802d36:	05 44 20 81 00       	add    $0x812044,%eax
  802d3b:	8b 08                	mov    (%eax),%ecx
  802d3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d40:	89 d0                	mov    %edx,%eax
  802d42:	01 c0                	add    %eax,%eax
  802d44:	01 d0                	add    %edx,%eax
  802d46:	c1 e0 02             	shl    $0x2,%eax
  802d49:	05 44 20 81 00       	add    $0x812044,%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	01 c1                	add    %eax,%ecx
  802d52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d55:	89 d0                	mov    %edx,%eax
  802d57:	01 c0                	add    %eax,%eax
  802d59:	01 d0                	add    %edx,%eax
  802d5b:	c1 e0 02             	shl    $0x2,%eax
  802d5e:	05 44 20 81 00       	add    $0x812044,%eax
  802d63:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802d65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d68:	89 d0                	mov    %edx,%eax
  802d6a:	01 c0                	add    %eax,%eax
  802d6c:	01 d0                	add    %edx,%eax
  802d6e:	c1 e0 02             	shl    $0x2,%eax
  802d71:	05 48 20 81 00       	add    $0x812048,%eax
  802d76:	c6 00 00             	movb   $0x0,(%eax)
  802d79:	e9 91 00 00 00       	jmp    802e0f <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d81:	89 d0                	mov    %edx,%eax
  802d83:	01 c0                	add    %eax,%eax
  802d85:	01 d0                	add    %edx,%eax
  802d87:	c1 e0 02             	shl    $0x2,%eax
  802d8a:	05 40 20 81 00       	add    $0x812040,%eax
  802d8f:	8b 08                	mov    (%eax),%ecx
  802d91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d94:	89 d0                	mov    %edx,%eax
  802d96:	01 c0                	add    %eax,%eax
  802d98:	01 d0                	add    %edx,%eax
  802d9a:	c1 e0 02             	shl    $0x2,%eax
  802d9d:	05 44 20 81 00       	add    $0x812044,%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	01 c1                	add    %eax,%ecx
  802da6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802da9:	89 d0                	mov    %edx,%eax
  802dab:	01 c0                	add    %eax,%eax
  802dad:	01 d0                	add    %edx,%eax
  802daf:	c1 e0 02             	shl    $0x2,%eax
  802db2:	05 40 20 81 00       	add    $0x812040,%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	39 c1                	cmp    %eax,%ecx
  802dbb:	75 52                	jne    802e0f <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802dbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc0:	89 d0                	mov    %edx,%eax
  802dc2:	01 c0                	add    %eax,%eax
  802dc4:	01 d0                	add    %edx,%eax
  802dc6:	c1 e0 02             	shl    $0x2,%eax
  802dc9:	05 44 20 81 00       	add    $0x812044,%eax
  802dce:	8b 08                	mov    (%eax),%ecx
  802dd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dd3:	89 d0                	mov    %edx,%eax
  802dd5:	01 c0                	add    %eax,%eax
  802dd7:	01 d0                	add    %edx,%eax
  802dd9:	c1 e0 02             	shl    $0x2,%eax
  802ddc:	05 44 20 81 00       	add    $0x812044,%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	01 c1                	add    %eax,%ecx
  802de5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de8:	89 d0                	mov    %edx,%eax
  802dea:	01 c0                	add    %eax,%eax
  802dec:	01 d0                	add    %edx,%eax
  802dee:	c1 e0 02             	shl    $0x2,%eax
  802df1:	05 44 20 81 00       	add    $0x812044,%eax
  802df6:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802df8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dfb:	89 d0                	mov    %edx,%eax
  802dfd:	01 c0                	add    %eax,%eax
  802dff:	01 d0                	add    %edx,%eax
  802e01:	c1 e0 02             	shl    $0x2,%eax
  802e04:	05 48 20 81 00       	add    $0x812048,%eax
  802e09:	c6 00 00             	movb   $0x0,(%eax)
  802e0c:	eb 01                	jmp    802e0f <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802e0e:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e0f:	ff 45 e0             	incl   -0x20(%ebp)
  802e12:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e19:	0f 8e 7f fe ff ff    	jle    802c9e <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802e1f:	a1 30 61 83 00       	mov    0x836130,%eax
  802e24:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e27:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802e2e:	eb 53                	jmp    802e83 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802e30:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e33:	89 d0                	mov    %edx,%eax
  802e35:	01 c0                	add    %eax,%eax
  802e37:	01 d0                	add    %edx,%eax
  802e39:	c1 e0 02             	shl    $0x2,%eax
  802e3c:	05 48 60 80 00       	add    $0x806048,%eax
  802e41:	8a 00                	mov    (%eax),%al
  802e43:	84 c0                	test   %al,%al
  802e45:	74 39                	je     802e80 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e47:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e4a:	89 d0                	mov    %edx,%eax
  802e4c:	01 c0                	add    %eax,%eax
  802e4e:	01 d0                	add    %edx,%eax
  802e50:	c1 e0 02             	shl    $0x2,%eax
  802e53:	05 40 60 80 00       	add    $0x806040,%eax
  802e58:	8b 08                	mov    (%eax),%ecx
  802e5a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e5d:	89 d0                	mov    %edx,%eax
  802e5f:	01 c0                	add    %eax,%eax
  802e61:	01 d0                	add    %edx,%eax
  802e63:	c1 e0 02             	shl    $0x2,%eax
  802e66:	05 44 60 80 00       	add    $0x806044,%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	01 c8                	add    %ecx,%eax
  802e6f:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802e72:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e75:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802e78:	76 06                	jbe    802e80 <realloc+0x453>
  802e7a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e80:	ff 45 d8             	incl   -0x28(%ebp)
  802e83:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802e8a:	7e a4                	jle    802e30 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802e8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e8f:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	e9 a9 01 00 00       	jmp    803045 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802e9c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	01 d0                	add    %edx,%eax
  802ea4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802ea7:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802eae:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802eb5:	eb 57                	jmp    802f0e <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802eb7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802eba:	89 d0                	mov    %edx,%eax
  802ebc:	01 c0                	add    %eax,%eax
  802ebe:	01 d0                	add    %edx,%eax
  802ec0:	c1 e0 02             	shl    $0x2,%eax
  802ec3:	05 48 20 81 00       	add    $0x812048,%eax
  802ec8:	8a 00                	mov    (%eax),%al
  802eca:	84 c0                	test   %al,%al
  802ecc:	74 3d                	je     802f0b <realloc+0x4de>
  802ece:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ed1:	89 d0                	mov    %edx,%eax
  802ed3:	01 c0                	add    %eax,%eax
  802ed5:	01 d0                	add    %edx,%eax
  802ed7:	c1 e0 02             	shl    $0x2,%eax
  802eda:	05 40 20 81 00       	add    $0x812040,%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ee4:	75 25                	jne    802f0b <realloc+0x4de>
  802ee6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ee9:	89 d0                	mov    %edx,%eax
  802eeb:	01 c0                	add    %eax,%eax
  802eed:	01 d0                	add    %edx,%eax
  802eef:	c1 e0 02             	shl    $0x2,%eax
  802ef2:	05 44 20 81 00       	add    $0x812044,%eax
  802ef7:	8b 10                	mov    (%eax),%edx
  802ef9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802efc:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802eff:	39 c2                	cmp    %eax,%edx
  802f01:	72 08                	jb     802f0b <realloc+0x4de>
		{
			adjIdx = j; break;
  802f03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f06:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f09:	eb 0c                	jmp    802f17 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802f0b:	ff 45 d0             	incl   -0x30(%ebp)
  802f0e:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802f15:	7e a0                	jle    802eb7 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802f17:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802f1b:	0f 84 d6 00 00 00    	je     802ff7 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802f21:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f24:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802f27:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802f2a:	83 ec 08             	sub    $0x8,%esp
  802f2d:	ff 75 a0             	pushl  -0x60(%ebp)
  802f30:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f33:	e8 cf 09 00 00       	call   803907 <sys_allocate_user_mem>
  802f38:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802f3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3e:	89 d0                	mov    %edx,%eax
  802f40:	01 c0                	add    %eax,%eax
  802f42:	01 d0                	add    %edx,%eax
  802f44:	c1 e0 02             	shl    $0x2,%eax
  802f47:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802f4d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f50:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802f52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f55:	89 d0                	mov    %edx,%eax
  802f57:	01 c0                	add    %eax,%eax
  802f59:	01 d0                	add    %edx,%eax
  802f5b:	c1 e0 02             	shl    $0x2,%eax
  802f5e:	05 40 20 81 00       	add    $0x812040,%eax
  802f63:	8b 10                	mov    (%eax),%edx
  802f65:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f68:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802f6b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f6e:	89 d0                	mov    %edx,%eax
  802f70:	01 c0                	add    %eax,%eax
  802f72:	01 d0                	add    %edx,%eax
  802f74:	c1 e0 02             	shl    $0x2,%eax
  802f77:	05 40 20 81 00       	add    $0x812040,%eax
  802f7c:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802f7e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f81:	89 d0                	mov    %edx,%eax
  802f83:	01 c0                	add    %eax,%eax
  802f85:	01 d0                	add    %edx,%eax
  802f87:	c1 e0 02             	shl    $0x2,%eax
  802f8a:	05 44 20 81 00       	add    $0x812044,%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802f94:	89 c2                	mov    %eax,%edx
  802f96:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802f99:	89 c8                	mov    %ecx,%eax
  802f9b:	01 c0                	add    %eax,%eax
  802f9d:	01 c8                	add    %ecx,%eax
  802f9f:	c1 e0 02             	shl    $0x2,%eax
  802fa2:	05 44 20 81 00       	add    $0x812044,%eax
  802fa7:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802fa9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fac:	89 d0                	mov    %edx,%eax
  802fae:	01 c0                	add    %eax,%eax
  802fb0:	01 d0                	add    %edx,%eax
  802fb2:	c1 e0 02             	shl    $0x2,%eax
  802fb5:	05 44 20 81 00       	add    $0x812044,%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	85 c0                	test   %eax,%eax
  802fbe:	75 14                	jne    802fd4 <realloc+0x5a7>
  802fc0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fc3:	89 d0                	mov    %edx,%eax
  802fc5:	01 c0                	add    %eax,%eax
  802fc7:	01 d0                	add    %edx,%eax
  802fc9:	c1 e0 02             	shl    $0x2,%eax
  802fcc:	05 48 20 81 00       	add    $0x812048,%eax
  802fd1:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802fd4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fd7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fda:	01 c2                	add    %eax,%edx
  802fdc:	a1 88 60 83 00       	mov    0x836088,%eax
  802fe1:	39 c2                	cmp    %eax,%edx
  802fe3:	76 0d                	jbe    802ff2 <realloc+0x5c5>
  802fe5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fe8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802feb:	01 d0                	add    %edx,%eax
  802fed:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	eb 4e                	jmp    803045 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802ff7:	83 ec 0c             	sub    $0xc,%esp
  802ffa:	ff 75 0c             	pushl  0xc(%ebp)
  802ffd:	e8 0b ec ff ff       	call   801c0d <malloc>
  803002:	83 c4 10             	add    $0x10,%esp
  803005:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  803008:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80300c:	75 07                	jne    803015 <realloc+0x5e8>
		return NULL;
  80300e:	b8 00 00 00 00       	mov    $0x0,%eax
  803013:	eb 30                	jmp    803045 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  803015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803018:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80301b:	39 d0                	cmp    %edx,%eax
  80301d:	76 02                	jbe    803021 <realloc+0x5f4>
  80301f:	89 d0                	mov    %edx,%eax
  803021:	8b 55 9c             	mov    -0x64(%ebp),%edx
  803024:	83 ec 04             	sub    $0x4,%esp
  803027:	50                   	push   %eax
  803028:	52                   	push   %edx
  803029:	ff 75 cc             	pushl  -0x34(%ebp)
  80302c:	e8 cf 06 00 00       	call   803700 <sys_move_user_mem>
  803031:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  803034:	83 ec 0c             	sub    $0xc,%esp
  803037:	ff 75 08             	pushl  0x8(%ebp)
  80303a:	e8 2e ef ff ff       	call   801f6d <free>
  80303f:	83 c4 10             	add    $0x10,%esp
	return newptr;
  803042:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
  80304a:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  803053:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803057:	0f 84 33 03 00 00    	je     803390 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  80305d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803060:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  803065:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  803068:	83 ec 08             	sub    $0x8,%esp
  80306b:	ff 75 08             	pushl  0x8(%ebp)
  80306e:	ff 75 d8             	pushl  -0x28(%ebp)
  803071:	e8 7d 05 00 00       	call   8035f3 <sys_delete_shared_object>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  80307c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803080:	0f 88 0d 03 00 00    	js     803393 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80308d:	e9 ef 02 00 00       	jmp    803381 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803095:	89 d0                	mov    %edx,%eax
  803097:	01 c0                	add    %eax,%eax
  803099:	01 d0                	add    %edx,%eax
  80309b:	c1 e0 02             	shl    $0x2,%eax
  80309e:	05 48 60 80 00       	add    $0x806048,%eax
  8030a3:	8a 00                	mov    (%eax),%al
  8030a5:	84 c0                	test   %al,%al
  8030a7:	0f 84 d1 02 00 00    	je     80337e <sfree+0x337>
  8030ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b0:	89 d0                	mov    %edx,%eax
  8030b2:	01 c0                	add    %eax,%eax
  8030b4:	01 d0                	add    %edx,%eax
  8030b6:	c1 e0 02             	shl    $0x2,%eax
  8030b9:	05 40 60 80 00       	add    $0x806040,%eax
  8030be:	8b 00                	mov    (%eax),%eax
  8030c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8030c3:	0f 85 b5 02 00 00    	jne    80337e <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  8030c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030cc:	89 d0                	mov    %edx,%eax
  8030ce:	01 c0                	add    %eax,%eax
  8030d0:	01 d0                	add    %edx,%eax
  8030d2:	c1 e0 02             	shl    $0x2,%eax
  8030d5:	05 44 60 80 00       	add    $0x806044,%eax
  8030da:	8b 00                	mov    (%eax),%eax
  8030dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  8030df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e2:	89 d0                	mov    %edx,%eax
  8030e4:	01 c0                	add    %eax,%eax
  8030e6:	01 d0                	add    %edx,%eax
  8030e8:	c1 e0 02             	shl    $0x2,%eax
  8030eb:	05 48 60 80 00       	add    $0x806048,%eax
  8030f0:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  8030f3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8030fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803101:	eb 64                	jmp    803167 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  803103:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803106:	89 d0                	mov    %edx,%eax
  803108:	01 c0                	add    %eax,%eax
  80310a:	01 d0                	add    %edx,%eax
  80310c:	c1 e0 02             	shl    $0x2,%eax
  80310f:	05 48 20 81 00       	add    $0x812048,%eax
  803114:	8a 00                	mov    (%eax),%al
  803116:	84 c0                	test   %al,%al
  803118:	75 4a                	jne    803164 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  80311a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80311d:	89 d0                	mov    %edx,%eax
  80311f:	01 c0                	add    %eax,%eax
  803121:	01 d0                	add    %edx,%eax
  803123:	c1 e0 02             	shl    $0x2,%eax
  803126:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  80312c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312f:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  803131:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803134:	89 d0                	mov    %edx,%eax
  803136:	01 c0                	add    %eax,%eax
  803138:	01 d0                	add    %edx,%eax
  80313a:	c1 e0 02             	shl    $0x2,%eax
  80313d:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  803143:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803146:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  803148:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80314b:	89 d0                	mov    %edx,%eax
  80314d:	01 c0                	add    %eax,%eax
  80314f:	01 d0                	add    %edx,%eax
  803151:	c1 e0 02             	shl    $0x2,%eax
  803154:	05 48 20 81 00       	add    $0x812048,%eax
  803159:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  80315c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  803162:	eb 0c                	jmp    803170 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803164:	ff 45 ec             	incl   -0x14(%ebp)
  803167:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80316e:	7e 93                	jle    803103 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  803170:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803174:	0f 84 8d 01 00 00    	je     803307 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80317a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803181:	e9 74 01 00 00       	jmp    8032fa <sfree+0x2b3>
				{
					if (k == fidx) continue;
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80318c:	0f 84 64 01 00 00    	je     8032f6 <sfree+0x2af>
					if (uhp_frees[k].free)
  803192:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803195:	89 d0                	mov    %edx,%eax
  803197:	01 c0                	add    %eax,%eax
  803199:	01 d0                	add    %edx,%eax
  80319b:	c1 e0 02             	shl    $0x2,%eax
  80319e:	05 48 20 81 00       	add    $0x812048,%eax
  8031a3:	8a 00                	mov    (%eax),%al
  8031a5:	84 c0                	test   %al,%al
  8031a7:	0f 84 4a 01 00 00    	je     8032f7 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8031ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b0:	89 d0                	mov    %edx,%eax
  8031b2:	01 c0                	add    %eax,%eax
  8031b4:	01 d0                	add    %edx,%eax
  8031b6:	c1 e0 02             	shl    $0x2,%eax
  8031b9:	05 40 20 81 00       	add    $0x812040,%eax
  8031be:	8b 08                	mov    (%eax),%ecx
  8031c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c3:	89 d0                	mov    %edx,%eax
  8031c5:	01 c0                	add    %eax,%eax
  8031c7:	01 d0                	add    %edx,%eax
  8031c9:	c1 e0 02             	shl    $0x2,%eax
  8031cc:	05 44 20 81 00       	add    $0x812044,%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	01 c1                	add    %eax,%ecx
  8031d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d8:	89 d0                	mov    %edx,%eax
  8031da:	01 c0                	add    %eax,%eax
  8031dc:	01 d0                	add    %edx,%eax
  8031de:	c1 e0 02             	shl    $0x2,%eax
  8031e1:	05 40 20 81 00       	add    $0x812040,%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	39 c1                	cmp    %eax,%ecx
  8031ea:	75 7a                	jne    803266 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  8031ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ef:	89 d0                	mov    %edx,%eax
  8031f1:	01 c0                	add    %eax,%eax
  8031f3:	01 d0                	add    %edx,%eax
  8031f5:	c1 e0 02             	shl    $0x2,%eax
  8031f8:	05 40 20 81 00       	add    $0x812040,%eax
  8031fd:	8b 10                	mov    (%eax),%edx
  8031ff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803202:	89 c8                	mov    %ecx,%eax
  803204:	01 c0                	add    %eax,%eax
  803206:	01 c8                	add    %ecx,%eax
  803208:	c1 e0 02             	shl    $0x2,%eax
  80320b:	05 40 20 81 00       	add    $0x812040,%eax
  803210:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  803212:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803215:	89 d0                	mov    %edx,%eax
  803217:	01 c0                	add    %eax,%eax
  803219:	01 d0                	add    %edx,%eax
  80321b:	c1 e0 02             	shl    $0x2,%eax
  80321e:	05 44 20 81 00       	add    $0x812044,%eax
  803223:	8b 08                	mov    (%eax),%ecx
  803225:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803228:	89 d0                	mov    %edx,%eax
  80322a:	01 c0                	add    %eax,%eax
  80322c:	01 d0                	add    %edx,%eax
  80322e:	c1 e0 02             	shl    $0x2,%eax
  803231:	05 44 20 81 00       	add    $0x812044,%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	01 c1                	add    %eax,%ecx
  80323a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323d:	89 d0                	mov    %edx,%eax
  80323f:	01 c0                	add    %eax,%eax
  803241:	01 d0                	add    %edx,%eax
  803243:	c1 e0 02             	shl    $0x2,%eax
  803246:	05 44 20 81 00       	add    $0x812044,%eax
  80324b:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  80324d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803250:	89 d0                	mov    %edx,%eax
  803252:	01 c0                	add    %eax,%eax
  803254:	01 d0                	add    %edx,%eax
  803256:	c1 e0 02             	shl    $0x2,%eax
  803259:	05 48 20 81 00       	add    $0x812048,%eax
  80325e:	c6 00 00             	movb   $0x0,(%eax)
  803261:	e9 91 00 00 00       	jmp    8032f7 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803266:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803269:	89 d0                	mov    %edx,%eax
  80326b:	01 c0                	add    %eax,%eax
  80326d:	01 d0                	add    %edx,%eax
  80326f:	c1 e0 02             	shl    $0x2,%eax
  803272:	05 40 20 81 00       	add    $0x812040,%eax
  803277:	8b 08                	mov    (%eax),%ecx
  803279:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327c:	89 d0                	mov    %edx,%eax
  80327e:	01 c0                	add    %eax,%eax
  803280:	01 d0                	add    %edx,%eax
  803282:	c1 e0 02             	shl    $0x2,%eax
  803285:	05 44 20 81 00       	add    $0x812044,%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	01 c1                	add    %eax,%ecx
  80328e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803291:	89 d0                	mov    %edx,%eax
  803293:	01 c0                	add    %eax,%eax
  803295:	01 d0                	add    %edx,%eax
  803297:	c1 e0 02             	shl    $0x2,%eax
  80329a:	05 40 20 81 00       	add    $0x812040,%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	39 c1                	cmp    %eax,%ecx
  8032a3:	75 52                	jne    8032f7 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  8032a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032a8:	89 d0                	mov    %edx,%eax
  8032aa:	01 c0                	add    %eax,%eax
  8032ac:	01 d0                	add    %edx,%eax
  8032ae:	c1 e0 02             	shl    $0x2,%eax
  8032b1:	05 44 20 81 00       	add    $0x812044,%eax
  8032b6:	8b 08                	mov    (%eax),%ecx
  8032b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032bb:	89 d0                	mov    %edx,%eax
  8032bd:	01 c0                	add    %eax,%eax
  8032bf:	01 d0                	add    %edx,%eax
  8032c1:	c1 e0 02             	shl    $0x2,%eax
  8032c4:	05 44 20 81 00       	add    $0x812044,%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	01 c1                	add    %eax,%ecx
  8032cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d0:	89 d0                	mov    %edx,%eax
  8032d2:	01 c0                	add    %eax,%eax
  8032d4:	01 d0                	add    %edx,%eax
  8032d6:	c1 e0 02             	shl    $0x2,%eax
  8032d9:	05 44 20 81 00       	add    $0x812044,%eax
  8032de:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8032e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e3:	89 d0                	mov    %edx,%eax
  8032e5:	01 c0                	add    %eax,%eax
  8032e7:	01 d0                	add    %edx,%eax
  8032e9:	c1 e0 02             	shl    $0x2,%eax
  8032ec:	05 48 20 81 00       	add    $0x812048,%eax
  8032f1:	c6 00 00             	movb   $0x0,(%eax)
  8032f4:	eb 01                	jmp    8032f7 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  8032f6:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8032f7:	ff 45 e8             	incl   -0x18(%ebp)
  8032fa:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803301:	0f 8e 7f fe ff ff    	jle    803186 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803307:	a1 30 61 83 00       	mov    0x836130,%eax
  80330c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80330f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803316:	eb 53                	jmp    80336b <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803318:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80331b:	89 d0                	mov    %edx,%eax
  80331d:	01 c0                	add    %eax,%eax
  80331f:	01 d0                	add    %edx,%eax
  803321:	c1 e0 02             	shl    $0x2,%eax
  803324:	05 48 60 80 00       	add    $0x806048,%eax
  803329:	8a 00                	mov    (%eax),%al
  80332b:	84 c0                	test   %al,%al
  80332d:	74 39                	je     803368 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80332f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803332:	89 d0                	mov    %edx,%eax
  803334:	01 c0                	add    %eax,%eax
  803336:	01 d0                	add    %edx,%eax
  803338:	c1 e0 02             	shl    $0x2,%eax
  80333b:	05 40 60 80 00       	add    $0x806040,%eax
  803340:	8b 08                	mov    (%eax),%ecx
  803342:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803345:	89 d0                	mov    %edx,%eax
  803347:	01 c0                	add    %eax,%eax
  803349:	01 d0                	add    %edx,%eax
  80334b:	c1 e0 02             	shl    $0x2,%eax
  80334e:	05 44 60 80 00       	add    $0x806044,%eax
  803353:	8b 00                	mov    (%eax),%eax
  803355:	01 c8                	add    %ecx,%eax
  803357:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  80335a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80335d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803360:	76 06                	jbe    803368 <sfree+0x321>
  803362:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803365:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803368:	ff 45 e0             	incl   -0x20(%ebp)
  80336b:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803372:	7e a4                	jle    803318 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803377:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  80337c:	eb 16                	jmp    803394 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80337e:	ff 45 f4             	incl   -0xc(%ebp)
  803381:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803388:	0f 8e 04 fd ff ff    	jle    803092 <sfree+0x4b>
  80338e:	eb 04                	jmp    803394 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803390:	90                   	nop
  803391:	eb 01                	jmp    803394 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803393:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
  803399:	57                   	push   %edi
  80339a:	56                   	push   %esi
  80339b:	53                   	push   %ebx
  80339c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8033ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8033b1:	cd 30                	int    $0x30
  8033b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8033b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8033b9:	83 c4 10             	add    $0x10,%esp
  8033bc:	5b                   	pop    %ebx
  8033bd:	5e                   	pop    %esi
  8033be:	5f                   	pop    %edi
  8033bf:	5d                   	pop    %ebp
  8033c0:	c3                   	ret    

008033c1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8033c1:	55                   	push   %ebp
  8033c2:	89 e5                	mov    %esp,%ebp
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8033cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8033d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	6a 00                	push   $0x0
  8033d9:	51                   	push   %ecx
  8033da:	52                   	push   %edx
  8033db:	ff 75 0c             	pushl  0xc(%ebp)
  8033de:	50                   	push   %eax
  8033df:	6a 00                	push   $0x0
  8033e1:	e8 b0 ff ff ff       	call   803396 <syscall>
  8033e6:	83 c4 18             	add    $0x18,%esp
}
  8033e9:	90                   	nop
  8033ea:	c9                   	leave  
  8033eb:	c3                   	ret    

008033ec <sys_cgetc>:

int
sys_cgetc(void)
{
  8033ec:	55                   	push   %ebp
  8033ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8033ef:	6a 00                	push   $0x0
  8033f1:	6a 00                	push   $0x0
  8033f3:	6a 00                	push   $0x0
  8033f5:	6a 00                	push   $0x0
  8033f7:	6a 00                	push   $0x0
  8033f9:	6a 02                	push   $0x2
  8033fb:	e8 96 ff ff ff       	call   803396 <syscall>
  803400:	83 c4 18             	add    $0x18,%esp
}
  803403:	c9                   	leave  
  803404:	c3                   	ret    

00803405 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803405:	55                   	push   %ebp
  803406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	6a 00                	push   $0x0
  80340e:	6a 00                	push   $0x0
  803410:	6a 00                	push   $0x0
  803412:	6a 03                	push   $0x3
  803414:	e8 7d ff ff ff       	call   803396 <syscall>
  803419:	83 c4 18             	add    $0x18,%esp
}
  80341c:	90                   	nop
  80341d:	c9                   	leave  
  80341e:	c3                   	ret    

0080341f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80341f:	55                   	push   %ebp
  803420:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803422:	6a 00                	push   $0x0
  803424:	6a 00                	push   $0x0
  803426:	6a 00                	push   $0x0
  803428:	6a 00                	push   $0x0
  80342a:	6a 00                	push   $0x0
  80342c:	6a 04                	push   $0x4
  80342e:	e8 63 ff ff ff       	call   803396 <syscall>
  803433:	83 c4 18             	add    $0x18,%esp
}
  803436:	90                   	nop
  803437:	c9                   	leave  
  803438:	c3                   	ret    

00803439 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803439:	55                   	push   %ebp
  80343a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80343c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	6a 00                	push   $0x0
  803444:	6a 00                	push   $0x0
  803446:	6a 00                	push   $0x0
  803448:	52                   	push   %edx
  803449:	50                   	push   %eax
  80344a:	6a 08                	push   $0x8
  80344c:	e8 45 ff ff ff       	call   803396 <syscall>
  803451:	83 c4 18             	add    $0x18,%esp
}
  803454:	c9                   	leave  
  803455:	c3                   	ret    

00803456 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803456:	55                   	push   %ebp
  803457:	89 e5                	mov    %esp,%ebp
  803459:	56                   	push   %esi
  80345a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80345b:	8b 75 18             	mov    0x18(%ebp),%esi
  80345e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803461:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803464:	8b 55 0c             	mov    0xc(%ebp),%edx
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	56                   	push   %esi
  80346b:	53                   	push   %ebx
  80346c:	51                   	push   %ecx
  80346d:	52                   	push   %edx
  80346e:	50                   	push   %eax
  80346f:	6a 09                	push   $0x9
  803471:	e8 20 ff ff ff       	call   803396 <syscall>
  803476:	83 c4 18             	add    $0x18,%esp
}
  803479:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80347c:	5b                   	pop    %ebx
  80347d:	5e                   	pop    %esi
  80347e:	5d                   	pop    %ebp
  80347f:	c3                   	ret    

00803480 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803480:	55                   	push   %ebp
  803481:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803483:	6a 00                	push   $0x0
  803485:	6a 00                	push   $0x0
  803487:	6a 00                	push   $0x0
  803489:	6a 00                	push   $0x0
  80348b:	ff 75 08             	pushl  0x8(%ebp)
  80348e:	6a 0a                	push   $0xa
  803490:	e8 01 ff ff ff       	call   803396 <syscall>
  803495:	83 c4 18             	add    $0x18,%esp
}
  803498:	c9                   	leave  
  803499:	c3                   	ret    

0080349a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80349a:	55                   	push   %ebp
  80349b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80349d:	6a 00                	push   $0x0
  80349f:	6a 00                	push   $0x0
  8034a1:	6a 00                	push   $0x0
  8034a3:	ff 75 0c             	pushl  0xc(%ebp)
  8034a6:	ff 75 08             	pushl  0x8(%ebp)
  8034a9:	6a 0b                	push   $0xb
  8034ab:	e8 e6 fe ff ff       	call   803396 <syscall>
  8034b0:	83 c4 18             	add    $0x18,%esp
}
  8034b3:	c9                   	leave  
  8034b4:	c3                   	ret    

008034b5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8034b5:	55                   	push   %ebp
  8034b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8034b8:	6a 00                	push   $0x0
  8034ba:	6a 00                	push   $0x0
  8034bc:	6a 00                	push   $0x0
  8034be:	6a 00                	push   $0x0
  8034c0:	6a 00                	push   $0x0
  8034c2:	6a 0c                	push   $0xc
  8034c4:	e8 cd fe ff ff       	call   803396 <syscall>
  8034c9:	83 c4 18             	add    $0x18,%esp
}
  8034cc:	c9                   	leave  
  8034cd:	c3                   	ret    

008034ce <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8034ce:	55                   	push   %ebp
  8034cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8034d1:	6a 00                	push   $0x0
  8034d3:	6a 00                	push   $0x0
  8034d5:	6a 00                	push   $0x0
  8034d7:	6a 00                	push   $0x0
  8034d9:	6a 00                	push   $0x0
  8034db:	6a 0d                	push   $0xd
  8034dd:	e8 b4 fe ff ff       	call   803396 <syscall>
  8034e2:	83 c4 18             	add    $0x18,%esp
}
  8034e5:	c9                   	leave  
  8034e6:	c3                   	ret    

008034e7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8034e7:	55                   	push   %ebp
  8034e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8034ea:	6a 00                	push   $0x0
  8034ec:	6a 00                	push   $0x0
  8034ee:	6a 00                	push   $0x0
  8034f0:	6a 00                	push   $0x0
  8034f2:	6a 00                	push   $0x0
  8034f4:	6a 0e                	push   $0xe
  8034f6:	e8 9b fe ff ff       	call   803396 <syscall>
  8034fb:	83 c4 18             	add    $0x18,%esp
}
  8034fe:	c9                   	leave  
  8034ff:	c3                   	ret    

00803500 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803500:	55                   	push   %ebp
  803501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803503:	6a 00                	push   $0x0
  803505:	6a 00                	push   $0x0
  803507:	6a 00                	push   $0x0
  803509:	6a 00                	push   $0x0
  80350b:	6a 00                	push   $0x0
  80350d:	6a 0f                	push   $0xf
  80350f:	e8 82 fe ff ff       	call   803396 <syscall>
  803514:	83 c4 18             	add    $0x18,%esp
}
  803517:	c9                   	leave  
  803518:	c3                   	ret    

00803519 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803519:	55                   	push   %ebp
  80351a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80351c:	6a 00                	push   $0x0
  80351e:	6a 00                	push   $0x0
  803520:	6a 00                	push   $0x0
  803522:	6a 00                	push   $0x0
  803524:	ff 75 08             	pushl  0x8(%ebp)
  803527:	6a 10                	push   $0x10
  803529:	e8 68 fe ff ff       	call   803396 <syscall>
  80352e:	83 c4 18             	add    $0x18,%esp
}
  803531:	c9                   	leave  
  803532:	c3                   	ret    

00803533 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803533:	55                   	push   %ebp
  803534:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803536:	6a 00                	push   $0x0
  803538:	6a 00                	push   $0x0
  80353a:	6a 00                	push   $0x0
  80353c:	6a 00                	push   $0x0
  80353e:	6a 00                	push   $0x0
  803540:	6a 11                	push   $0x11
  803542:	e8 4f fe ff ff       	call   803396 <syscall>
  803547:	83 c4 18             	add    $0x18,%esp
}
  80354a:	90                   	nop
  80354b:	c9                   	leave  
  80354c:	c3                   	ret    

0080354d <sys_cputc>:

void
sys_cputc(const char c)
{
  80354d:	55                   	push   %ebp
  80354e:	89 e5                	mov    %esp,%ebp
  803550:	83 ec 04             	sub    $0x4,%esp
  803553:	8b 45 08             	mov    0x8(%ebp),%eax
  803556:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803559:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80355d:	6a 00                	push   $0x0
  80355f:	6a 00                	push   $0x0
  803561:	6a 00                	push   $0x0
  803563:	6a 00                	push   $0x0
  803565:	50                   	push   %eax
  803566:	6a 01                	push   $0x1
  803568:	e8 29 fe ff ff       	call   803396 <syscall>
  80356d:	83 c4 18             	add    $0x18,%esp
}
  803570:	90                   	nop
  803571:	c9                   	leave  
  803572:	c3                   	ret    

00803573 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803573:	55                   	push   %ebp
  803574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803576:	6a 00                	push   $0x0
  803578:	6a 00                	push   $0x0
  80357a:	6a 00                	push   $0x0
  80357c:	6a 00                	push   $0x0
  80357e:	6a 00                	push   $0x0
  803580:	6a 14                	push   $0x14
  803582:	e8 0f fe ff ff       	call   803396 <syscall>
  803587:	83 c4 18             	add    $0x18,%esp
}
  80358a:	90                   	nop
  80358b:	c9                   	leave  
  80358c:	c3                   	ret    

0080358d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80358d:	55                   	push   %ebp
  80358e:	89 e5                	mov    %esp,%ebp
  803590:	83 ec 04             	sub    $0x4,%esp
  803593:	8b 45 10             	mov    0x10(%ebp),%eax
  803596:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803599:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80359c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	6a 00                	push   $0x0
  8035a5:	51                   	push   %ecx
  8035a6:	52                   	push   %edx
  8035a7:	ff 75 0c             	pushl  0xc(%ebp)
  8035aa:	50                   	push   %eax
  8035ab:	6a 15                	push   $0x15
  8035ad:	e8 e4 fd ff ff       	call   803396 <syscall>
  8035b2:	83 c4 18             	add    $0x18,%esp
}
  8035b5:	c9                   	leave  
  8035b6:	c3                   	ret    

008035b7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8035b7:	55                   	push   %ebp
  8035b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8035ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	6a 00                	push   $0x0
  8035c2:	6a 00                	push   $0x0
  8035c4:	6a 00                	push   $0x0
  8035c6:	52                   	push   %edx
  8035c7:	50                   	push   %eax
  8035c8:	6a 16                	push   $0x16
  8035ca:	e8 c7 fd ff ff       	call   803396 <syscall>
  8035cf:	83 c4 18             	add    $0x18,%esp
}
  8035d2:	c9                   	leave  
  8035d3:	c3                   	ret    

008035d4 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8035d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8035da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	6a 00                	push   $0x0
  8035e2:	6a 00                	push   $0x0
  8035e4:	51                   	push   %ecx
  8035e5:	52                   	push   %edx
  8035e6:	50                   	push   %eax
  8035e7:	6a 17                	push   $0x17
  8035e9:	e8 a8 fd ff ff       	call   803396 <syscall>
  8035ee:	83 c4 18             	add    $0x18,%esp
}
  8035f1:	c9                   	leave  
  8035f2:	c3                   	ret    

008035f3 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8035f3:	55                   	push   %ebp
  8035f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8035f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	6a 00                	push   $0x0
  8035fe:	6a 00                	push   $0x0
  803600:	6a 00                	push   $0x0
  803602:	52                   	push   %edx
  803603:	50                   	push   %eax
  803604:	6a 18                	push   $0x18
  803606:	e8 8b fd ff ff       	call   803396 <syscall>
  80360b:	83 c4 18             	add    $0x18,%esp
}
  80360e:	c9                   	leave  
  80360f:	c3                   	ret    

00803610 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803610:	55                   	push   %ebp
  803611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	6a 00                	push   $0x0
  803618:	ff 75 14             	pushl  0x14(%ebp)
  80361b:	ff 75 10             	pushl  0x10(%ebp)
  80361e:	ff 75 0c             	pushl  0xc(%ebp)
  803621:	50                   	push   %eax
  803622:	6a 19                	push   $0x19
  803624:	e8 6d fd ff ff       	call   803396 <syscall>
  803629:	83 c4 18             	add    $0x18,%esp
}
  80362c:	c9                   	leave  
  80362d:	c3                   	ret    

0080362e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80362e:	55                   	push   %ebp
  80362f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	6a 00                	push   $0x0
  803636:	6a 00                	push   $0x0
  803638:	6a 00                	push   $0x0
  80363a:	6a 00                	push   $0x0
  80363c:	50                   	push   %eax
  80363d:	6a 1a                	push   $0x1a
  80363f:	e8 52 fd ff ff       	call   803396 <syscall>
  803644:	83 c4 18             	add    $0x18,%esp
}
  803647:	90                   	nop
  803648:	c9                   	leave  
  803649:	c3                   	ret    

0080364a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80364a:	55                   	push   %ebp
  80364b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	6a 00                	push   $0x0
  803652:	6a 00                	push   $0x0
  803654:	6a 00                	push   $0x0
  803656:	6a 00                	push   $0x0
  803658:	50                   	push   %eax
  803659:	6a 1b                	push   $0x1b
  80365b:	e8 36 fd ff ff       	call   803396 <syscall>
  803660:	83 c4 18             	add    $0x18,%esp
}
  803663:	c9                   	leave  
  803664:	c3                   	ret    

00803665 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803665:	55                   	push   %ebp
  803666:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803668:	6a 00                	push   $0x0
  80366a:	6a 00                	push   $0x0
  80366c:	6a 00                	push   $0x0
  80366e:	6a 00                	push   $0x0
  803670:	6a 00                	push   $0x0
  803672:	6a 05                	push   $0x5
  803674:	e8 1d fd ff ff       	call   803396 <syscall>
  803679:	83 c4 18             	add    $0x18,%esp
}
  80367c:	c9                   	leave  
  80367d:	c3                   	ret    

0080367e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80367e:	55                   	push   %ebp
  80367f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803681:	6a 00                	push   $0x0
  803683:	6a 00                	push   $0x0
  803685:	6a 00                	push   $0x0
  803687:	6a 00                	push   $0x0
  803689:	6a 00                	push   $0x0
  80368b:	6a 06                	push   $0x6
  80368d:	e8 04 fd ff ff       	call   803396 <syscall>
  803692:	83 c4 18             	add    $0x18,%esp
}
  803695:	c9                   	leave  
  803696:	c3                   	ret    

00803697 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803697:	55                   	push   %ebp
  803698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80369a:	6a 00                	push   $0x0
  80369c:	6a 00                	push   $0x0
  80369e:	6a 00                	push   $0x0
  8036a0:	6a 00                	push   $0x0
  8036a2:	6a 00                	push   $0x0
  8036a4:	6a 07                	push   $0x7
  8036a6:	e8 eb fc ff ff       	call   803396 <syscall>
  8036ab:	83 c4 18             	add    $0x18,%esp
}
  8036ae:	c9                   	leave  
  8036af:	c3                   	ret    

008036b0 <sys_exit_env>:


void sys_exit_env(void)
{
  8036b0:	55                   	push   %ebp
  8036b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8036b3:	6a 00                	push   $0x0
  8036b5:	6a 00                	push   $0x0
  8036b7:	6a 00                	push   $0x0
  8036b9:	6a 00                	push   $0x0
  8036bb:	6a 00                	push   $0x0
  8036bd:	6a 1c                	push   $0x1c
  8036bf:	e8 d2 fc ff ff       	call   803396 <syscall>
  8036c4:	83 c4 18             	add    $0x18,%esp
}
  8036c7:	90                   	nop
  8036c8:	c9                   	leave  
  8036c9:	c3                   	ret    

008036ca <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8036ca:	55                   	push   %ebp
  8036cb:	89 e5                	mov    %esp,%ebp
  8036cd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8036d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8036d3:	8d 50 04             	lea    0x4(%eax),%edx
  8036d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8036d9:	6a 00                	push   $0x0
  8036db:	6a 00                	push   $0x0
  8036dd:	6a 00                	push   $0x0
  8036df:	52                   	push   %edx
  8036e0:	50                   	push   %eax
  8036e1:	6a 1d                	push   $0x1d
  8036e3:	e8 ae fc ff ff       	call   803396 <syscall>
  8036e8:	83 c4 18             	add    $0x18,%esp
	return result;
  8036eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8036ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8036f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036f4:	89 01                	mov    %eax,(%ecx)
  8036f6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8036f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fc:	c9                   	leave  
  8036fd:	c2 04 00             	ret    $0x4

00803700 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803700:	55                   	push   %ebp
  803701:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803703:	6a 00                	push   $0x0
  803705:	6a 00                	push   $0x0
  803707:	ff 75 10             	pushl  0x10(%ebp)
  80370a:	ff 75 0c             	pushl  0xc(%ebp)
  80370d:	ff 75 08             	pushl  0x8(%ebp)
  803710:	6a 13                	push   $0x13
  803712:	e8 7f fc ff ff       	call   803396 <syscall>
  803717:	83 c4 18             	add    $0x18,%esp
	return ;
  80371a:	90                   	nop
}
  80371b:	c9                   	leave  
  80371c:	c3                   	ret    

0080371d <sys_rcr2>:
uint32 sys_rcr2()
{
  80371d:	55                   	push   %ebp
  80371e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803720:	6a 00                	push   $0x0
  803722:	6a 00                	push   $0x0
  803724:	6a 00                	push   $0x0
  803726:	6a 00                	push   $0x0
  803728:	6a 00                	push   $0x0
  80372a:	6a 1e                	push   $0x1e
  80372c:	e8 65 fc ff ff       	call   803396 <syscall>
  803731:	83 c4 18             	add    $0x18,%esp
}
  803734:	c9                   	leave  
  803735:	c3                   	ret    

00803736 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803736:	55                   	push   %ebp
  803737:	89 e5                	mov    %esp,%ebp
  803739:	83 ec 04             	sub    $0x4,%esp
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803742:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803746:	6a 00                	push   $0x0
  803748:	6a 00                	push   $0x0
  80374a:	6a 00                	push   $0x0
  80374c:	6a 00                	push   $0x0
  80374e:	50                   	push   %eax
  80374f:	6a 1f                	push   $0x1f
  803751:	e8 40 fc ff ff       	call   803396 <syscall>
  803756:	83 c4 18             	add    $0x18,%esp
	return ;
  803759:	90                   	nop
}
  80375a:	c9                   	leave  
  80375b:	c3                   	ret    

0080375c <rsttst>:
void rsttst()
{
  80375c:	55                   	push   %ebp
  80375d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80375f:	6a 00                	push   $0x0
  803761:	6a 00                	push   $0x0
  803763:	6a 00                	push   $0x0
  803765:	6a 00                	push   $0x0
  803767:	6a 00                	push   $0x0
  803769:	6a 21                	push   $0x21
  80376b:	e8 26 fc ff ff       	call   803396 <syscall>
  803770:	83 c4 18             	add    $0x18,%esp
	return ;
  803773:	90                   	nop
}
  803774:	c9                   	leave  
  803775:	c3                   	ret    

00803776 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803776:	55                   	push   %ebp
  803777:	89 e5                	mov    %esp,%ebp
  803779:	83 ec 04             	sub    $0x4,%esp
  80377c:	8b 45 14             	mov    0x14(%ebp),%eax
  80377f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803782:	8b 55 18             	mov    0x18(%ebp),%edx
  803785:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803789:	52                   	push   %edx
  80378a:	50                   	push   %eax
  80378b:	ff 75 10             	pushl  0x10(%ebp)
  80378e:	ff 75 0c             	pushl  0xc(%ebp)
  803791:	ff 75 08             	pushl  0x8(%ebp)
  803794:	6a 20                	push   $0x20
  803796:	e8 fb fb ff ff       	call   803396 <syscall>
  80379b:	83 c4 18             	add    $0x18,%esp
	return ;
  80379e:	90                   	nop
}
  80379f:	c9                   	leave  
  8037a0:	c3                   	ret    

008037a1 <chktst>:
void chktst(uint32 n)
{
  8037a1:	55                   	push   %ebp
  8037a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8037a4:	6a 00                	push   $0x0
  8037a6:	6a 00                	push   $0x0
  8037a8:	6a 00                	push   $0x0
  8037aa:	6a 00                	push   $0x0
  8037ac:	ff 75 08             	pushl  0x8(%ebp)
  8037af:	6a 22                	push   $0x22
  8037b1:	e8 e0 fb ff ff       	call   803396 <syscall>
  8037b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8037b9:	90                   	nop
}
  8037ba:	c9                   	leave  
  8037bb:	c3                   	ret    

008037bc <inctst>:

void inctst()
{
  8037bc:	55                   	push   %ebp
  8037bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8037bf:	6a 00                	push   $0x0
  8037c1:	6a 00                	push   $0x0
  8037c3:	6a 00                	push   $0x0
  8037c5:	6a 00                	push   $0x0
  8037c7:	6a 00                	push   $0x0
  8037c9:	6a 23                	push   $0x23
  8037cb:	e8 c6 fb ff ff       	call   803396 <syscall>
  8037d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8037d3:	90                   	nop
}
  8037d4:	c9                   	leave  
  8037d5:	c3                   	ret    

008037d6 <gettst>:
uint32 gettst()
{
  8037d6:	55                   	push   %ebp
  8037d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8037d9:	6a 00                	push   $0x0
  8037db:	6a 00                	push   $0x0
  8037dd:	6a 00                	push   $0x0
  8037df:	6a 00                	push   $0x0
  8037e1:	6a 00                	push   $0x0
  8037e3:	6a 24                	push   $0x24
  8037e5:	e8 ac fb ff ff       	call   803396 <syscall>
  8037ea:	83 c4 18             	add    $0x18,%esp
}
  8037ed:	c9                   	leave  
  8037ee:	c3                   	ret    

008037ef <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8037ef:	55                   	push   %ebp
  8037f0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8037f2:	6a 00                	push   $0x0
  8037f4:	6a 00                	push   $0x0
  8037f6:	6a 00                	push   $0x0
  8037f8:	6a 00                	push   $0x0
  8037fa:	6a 00                	push   $0x0
  8037fc:	6a 25                	push   $0x25
  8037fe:	e8 93 fb ff ff       	call   803396 <syscall>
  803803:	83 c4 18             	add    $0x18,%esp
  803806:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  80380b:	a1 80 60 83 00       	mov    0x836080,%eax
}
  803810:	c9                   	leave  
  803811:	c3                   	ret    

00803812 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803812:	55                   	push   %ebp
  803813:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803815:	8b 45 08             	mov    0x8(%ebp),%eax
  803818:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80381d:	6a 00                	push   $0x0
  80381f:	6a 00                	push   $0x0
  803821:	6a 00                	push   $0x0
  803823:	6a 00                	push   $0x0
  803825:	ff 75 08             	pushl  0x8(%ebp)
  803828:	6a 26                	push   $0x26
  80382a:	e8 67 fb ff ff       	call   803396 <syscall>
  80382f:	83 c4 18             	add    $0x18,%esp
	return ;
  803832:	90                   	nop
}
  803833:	c9                   	leave  
  803834:	c3                   	ret    

00803835 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803835:	55                   	push   %ebp
  803836:	89 e5                	mov    %esp,%ebp
  803838:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803839:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80383c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80383f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803842:	8b 45 08             	mov    0x8(%ebp),%eax
  803845:	6a 00                	push   $0x0
  803847:	53                   	push   %ebx
  803848:	51                   	push   %ecx
  803849:	52                   	push   %edx
  80384a:	50                   	push   %eax
  80384b:	6a 27                	push   $0x27
  80384d:	e8 44 fb ff ff       	call   803396 <syscall>
  803852:	83 c4 18             	add    $0x18,%esp
}
  803855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803858:	c9                   	leave  
  803859:	c3                   	ret    

0080385a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80385a:	55                   	push   %ebp
  80385b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80385d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803860:	8b 45 08             	mov    0x8(%ebp),%eax
  803863:	6a 00                	push   $0x0
  803865:	6a 00                	push   $0x0
  803867:	6a 00                	push   $0x0
  803869:	52                   	push   %edx
  80386a:	50                   	push   %eax
  80386b:	6a 28                	push   $0x28
  80386d:	e8 24 fb ff ff       	call   803396 <syscall>
  803872:	83 c4 18             	add    $0x18,%esp
}
  803875:	c9                   	leave  
  803876:	c3                   	ret    

00803877 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803877:	55                   	push   %ebp
  803878:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80387a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80387d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	6a 00                	push   $0x0
  803885:	51                   	push   %ecx
  803886:	ff 75 10             	pushl  0x10(%ebp)
  803889:	52                   	push   %edx
  80388a:	50                   	push   %eax
  80388b:	6a 29                	push   $0x29
  80388d:	e8 04 fb ff ff       	call   803396 <syscall>
  803892:	83 c4 18             	add    $0x18,%esp
}
  803895:	c9                   	leave  
  803896:	c3                   	ret    

00803897 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803897:	55                   	push   %ebp
  803898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80389a:	6a 00                	push   $0x0
  80389c:	6a 00                	push   $0x0
  80389e:	ff 75 10             	pushl  0x10(%ebp)
  8038a1:	ff 75 0c             	pushl  0xc(%ebp)
  8038a4:	ff 75 08             	pushl  0x8(%ebp)
  8038a7:	6a 12                	push   $0x12
  8038a9:	e8 e8 fa ff ff       	call   803396 <syscall>
  8038ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8038b1:	90                   	nop
}
  8038b2:	c9                   	leave  
  8038b3:	c3                   	ret    

008038b4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8038b4:	55                   	push   %ebp
  8038b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8038b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	6a 00                	push   $0x0
  8038bf:	6a 00                	push   $0x0
  8038c1:	6a 00                	push   $0x0
  8038c3:	52                   	push   %edx
  8038c4:	50                   	push   %eax
  8038c5:	6a 2a                	push   $0x2a
  8038c7:	e8 ca fa ff ff       	call   803396 <syscall>
  8038cc:	83 c4 18             	add    $0x18,%esp
	return;
  8038cf:	90                   	nop
}
  8038d0:	c9                   	leave  
  8038d1:	c3                   	ret    

008038d2 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8038d2:	55                   	push   %ebp
  8038d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8038d5:	6a 00                	push   $0x0
  8038d7:	6a 00                	push   $0x0
  8038d9:	6a 00                	push   $0x0
  8038db:	6a 00                	push   $0x0
  8038dd:	6a 00                	push   $0x0
  8038df:	6a 2b                	push   $0x2b
  8038e1:	e8 b0 fa ff ff       	call   803396 <syscall>
  8038e6:	83 c4 18             	add    $0x18,%esp
}
  8038e9:	c9                   	leave  
  8038ea:	c3                   	ret    

008038eb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8038eb:	55                   	push   %ebp
  8038ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8038ee:	6a 00                	push   $0x0
  8038f0:	6a 00                	push   $0x0
  8038f2:	6a 00                	push   $0x0
  8038f4:	ff 75 0c             	pushl  0xc(%ebp)
  8038f7:	ff 75 08             	pushl  0x8(%ebp)
  8038fa:	6a 2d                	push   $0x2d
  8038fc:	e8 95 fa ff ff       	call   803396 <syscall>
  803901:	83 c4 18             	add    $0x18,%esp
	return;
  803904:	90                   	nop
}
  803905:	c9                   	leave  
  803906:	c3                   	ret    

00803907 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803907:	55                   	push   %ebp
  803908:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80390a:	6a 00                	push   $0x0
  80390c:	6a 00                	push   $0x0
  80390e:	6a 00                	push   $0x0
  803910:	ff 75 0c             	pushl  0xc(%ebp)
  803913:	ff 75 08             	pushl  0x8(%ebp)
  803916:	6a 2c                	push   $0x2c
  803918:	e8 79 fa ff ff       	call   803396 <syscall>
  80391d:	83 c4 18             	add    $0x18,%esp
	return ;
  803920:	90                   	nop
}
  803921:	c9                   	leave  
  803922:	c3                   	ret    

00803923 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803923:	55                   	push   %ebp
  803924:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803926:	8b 55 0c             	mov    0xc(%ebp),%edx
  803929:	8b 45 08             	mov    0x8(%ebp),%eax
  80392c:	6a 00                	push   $0x0
  80392e:	6a 00                	push   $0x0
  803930:	6a 00                	push   $0x0
  803932:	52                   	push   %edx
  803933:	50                   	push   %eax
  803934:	6a 2e                	push   $0x2e
  803936:	e8 5b fa ff ff       	call   803396 <syscall>
  80393b:	83 c4 18             	add    $0x18,%esp
}
  80393e:	90                   	nop
  80393f:	c9                   	leave  
  803940:	c3                   	ret    

00803941 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803941:	55                   	push   %ebp
  803942:	89 e5                	mov    %esp,%ebp
  803944:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803947:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  80394e:	72 09                	jb     803959 <to_page_va+0x18>
  803950:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803957:	72 14                	jb     80396d <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803959:	83 ec 04             	sub    $0x4,%esp
  80395c:	68 cc 4e 80 00       	push   $0x804ecc
  803961:	6a 15                	push   $0x15
  803963:	68 f7 4e 80 00       	push   $0x804ef7
  803968:	e8 08 ce ff ff       	call   800775 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803975:	29 d0                	sub    %edx,%eax
  803977:	c1 f8 02             	sar    $0x2,%eax
  80397a:	89 c2                	mov    %eax,%edx
  80397c:	89 d0                	mov    %edx,%eax
  80397e:	c1 e0 02             	shl    $0x2,%eax
  803981:	01 d0                	add    %edx,%eax
  803983:	c1 e0 02             	shl    $0x2,%eax
  803986:	01 d0                	add    %edx,%eax
  803988:	c1 e0 02             	shl    $0x2,%eax
  80398b:	01 d0                	add    %edx,%eax
  80398d:	89 c1                	mov    %eax,%ecx
  80398f:	c1 e1 08             	shl    $0x8,%ecx
  803992:	01 c8                	add    %ecx,%eax
  803994:	89 c1                	mov    %eax,%ecx
  803996:	c1 e1 10             	shl    $0x10,%ecx
  803999:	01 c8                	add    %ecx,%eax
  80399b:	01 c0                	add    %eax,%eax
  80399d:	01 d0                	add    %edx,%eax
  80399f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8039a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a5:	c1 e0 0c             	shl    $0xc,%eax
  8039a8:	89 c2                	mov    %eax,%edx
  8039aa:	a1 84 60 83 00       	mov    0x836084,%eax
  8039af:	01 d0                	add    %edx,%eax
}
  8039b1:	c9                   	leave  
  8039b2:	c3                   	ret    

008039b3 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8039b3:	55                   	push   %ebp
  8039b4:	89 e5                	mov    %esp,%ebp
  8039b6:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8039b9:	a1 84 60 83 00       	mov    0x836084,%eax
  8039be:	8b 55 08             	mov    0x8(%ebp),%edx
  8039c1:	29 c2                	sub    %eax,%edx
  8039c3:	89 d0                	mov    %edx,%eax
  8039c5:	c1 e8 0c             	shr    $0xc,%eax
  8039c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8039cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039cf:	78 09                	js     8039da <to_page_info+0x27>
  8039d1:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8039d8:	7e 14                	jle    8039ee <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8039da:	83 ec 04             	sub    $0x4,%esp
  8039dd:	68 10 4f 80 00       	push   $0x804f10
  8039e2:	6a 21                	push   $0x21
  8039e4:	68 f7 4e 80 00       	push   $0x804ef7
  8039e9:	e8 87 cd ff ff       	call   800775 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8039ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039f1:	89 d0                	mov    %edx,%eax
  8039f3:	01 c0                	add    %eax,%eax
  8039f5:	01 d0                	add    %edx,%eax
  8039f7:	c1 e0 02             	shl    $0x2,%eax
  8039fa:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  8039ff:	c9                   	leave  
  803a00:	c3                   	ret    

00803a01 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803a01:	55                   	push   %ebp
  803a02:	89 e5                	mov    %esp,%ebp
  803a04:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803a07:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0a:	05 00 00 00 02       	add    $0x2000000,%eax
  803a0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a12:	73 16                	jae    803a2a <initialize_dynamic_allocator+0x29>
  803a14:	68 34 4f 80 00       	push   $0x804f34
  803a19:	68 5a 4f 80 00       	push   $0x804f5a
  803a1e:	6a 2f                	push   $0x2f
  803a20:	68 f7 4e 80 00       	push   $0x804ef7
  803a25:	e8 4b cd ff ff       	call   800775 <_panic>
	dynAllocStart = daStart;
  803a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2d:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a35:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a41:	eb 36                	jmp    803a79 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a46:	c1 e0 04             	shl    $0x4,%eax
  803a49:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a57:	c1 e0 04             	shl    $0x4,%eax
  803a5a:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803a5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a68:	c1 e0 04             	shl    $0x4,%eax
  803a6b:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a76:	ff 45 f4             	incl   -0xc(%ebp)
  803a79:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803a7d:	7e c4                	jle    803a43 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803a7f:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803a86:	00 00 00 
  803a89:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803a90:	00 00 00 
  803a93:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803a9a:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803a9d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803aa4:	e9 1b 01 00 00       	jmp    803bc4 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803aa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aac:	89 d0                	mov    %edx,%eax
  803aae:	01 c0                	add    %eax,%eax
  803ab0:	01 d0                	add    %edx,%eax
  803ab2:	c1 e0 02             	shl    $0x2,%eax
  803ab5:	05 88 e0 81 00       	add    $0x81e088,%eax
  803aba:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803abf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ac2:	89 d0                	mov    %edx,%eax
  803ac4:	01 c0                	add    %eax,%eax
  803ac6:	01 d0                	add    %edx,%eax
  803ac8:	c1 e0 02             	shl    $0x2,%eax
  803acb:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803ad0:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803ad5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ad8:	89 d0                	mov    %edx,%eax
  803ada:	01 c0                	add    %eax,%eax
  803adc:	01 d0                	add    %edx,%eax
  803ade:	c1 e0 02             	shl    $0x2,%eax
  803ae1:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ae6:	8b 00                	mov    (%eax),%eax
  803ae8:	85 c0                	test   %eax,%eax
  803aea:	74 2b                	je     803b17 <initialize_dynamic_allocator+0x116>
  803aec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aef:	89 d0                	mov    %edx,%eax
  803af1:	01 c0                	add    %eax,%eax
  803af3:	01 d0                	add    %edx,%eax
  803af5:	c1 e0 02             	shl    $0x2,%eax
  803af8:	05 80 e0 81 00       	add    $0x81e080,%eax
  803afd:	8b 10                	mov    (%eax),%edx
  803aff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b02:	89 c8                	mov    %ecx,%eax
  803b04:	01 c0                	add    %eax,%eax
  803b06:	01 c8                	add    %ecx,%eax
  803b08:	c1 e0 02             	shl    $0x2,%eax
  803b0b:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b10:	8b 00                	mov    (%eax),%eax
  803b12:	89 42 04             	mov    %eax,0x4(%edx)
  803b15:	eb 18                	jmp    803b2f <initialize_dynamic_allocator+0x12e>
  803b17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b1a:	89 d0                	mov    %edx,%eax
  803b1c:	01 c0                	add    %eax,%eax
  803b1e:	01 d0                	add    %edx,%eax
  803b20:	c1 e0 02             	shl    $0x2,%eax
  803b23:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b28:	8b 00                	mov    (%eax),%eax
  803b2a:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803b2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b32:	89 d0                	mov    %edx,%eax
  803b34:	01 c0                	add    %eax,%eax
  803b36:	01 d0                	add    %edx,%eax
  803b38:	c1 e0 02             	shl    $0x2,%eax
  803b3b:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b40:	8b 00                	mov    (%eax),%eax
  803b42:	85 c0                	test   %eax,%eax
  803b44:	74 2a                	je     803b70 <initialize_dynamic_allocator+0x16f>
  803b46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b49:	89 d0                	mov    %edx,%eax
  803b4b:	01 c0                	add    %eax,%eax
  803b4d:	01 d0                	add    %edx,%eax
  803b4f:	c1 e0 02             	shl    $0x2,%eax
  803b52:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b57:	8b 10                	mov    (%eax),%edx
  803b59:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b5c:	89 c8                	mov    %ecx,%eax
  803b5e:	01 c0                	add    %eax,%eax
  803b60:	01 c8                	add    %ecx,%eax
  803b62:	c1 e0 02             	shl    $0x2,%eax
  803b65:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b6a:	8b 00                	mov    (%eax),%eax
  803b6c:	89 02                	mov    %eax,(%edx)
  803b6e:	eb 18                	jmp    803b88 <initialize_dynamic_allocator+0x187>
  803b70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b73:	89 d0                	mov    %edx,%eax
  803b75:	01 c0                	add    %eax,%eax
  803b77:	01 d0                	add    %edx,%eax
  803b79:	c1 e0 02             	shl    $0x2,%eax
  803b7c:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b8b:	89 d0                	mov    %edx,%eax
  803b8d:	01 c0                	add    %eax,%eax
  803b8f:	01 d0                	add    %edx,%eax
  803b91:	c1 e0 02             	shl    $0x2,%eax
  803b94:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ba2:	89 d0                	mov    %edx,%eax
  803ba4:	01 c0                	add    %eax,%eax
  803ba6:	01 d0                	add    %edx,%eax
  803ba8:	c1 e0 02             	shl    $0x2,%eax
  803bab:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb6:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803bbb:	48                   	dec    %eax
  803bbc:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803bc1:	ff 45 f0             	incl   -0x10(%ebp)
  803bc4:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803bcb:	0f 8e d8 fe ff ff    	jle    803aa9 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803bd1:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803bd8:	e9 9d 00 00 00       	jmp    803c7a <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803bdd:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803be3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803be6:	89 c8                	mov    %ecx,%eax
  803be8:	01 c0                	add    %eax,%eax
  803bea:	01 c8                	add    %ecx,%eax
  803bec:	c1 e0 02             	shl    $0x2,%eax
  803bef:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bf4:	89 10                	mov    %edx,(%eax)
  803bf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bf9:	89 d0                	mov    %edx,%eax
  803bfb:	01 c0                	add    %eax,%eax
  803bfd:	01 d0                	add    %edx,%eax
  803bff:	c1 e0 02             	shl    $0x2,%eax
  803c02:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c07:	8b 00                	mov    (%eax),%eax
  803c09:	85 c0                	test   %eax,%eax
  803c0b:	74 1c                	je     803c29 <initialize_dynamic_allocator+0x228>
  803c0d:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803c13:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c16:	89 c8                	mov    %ecx,%eax
  803c18:	01 c0                	add    %eax,%eax
  803c1a:	01 c8                	add    %ecx,%eax
  803c1c:	c1 e0 02             	shl    $0x2,%eax
  803c1f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c24:	89 42 04             	mov    %eax,0x4(%edx)
  803c27:	eb 16                	jmp    803c3f <initialize_dynamic_allocator+0x23e>
  803c29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c2c:	89 d0                	mov    %edx,%eax
  803c2e:	01 c0                	add    %eax,%eax
  803c30:	01 d0                	add    %edx,%eax
  803c32:	c1 e0 02             	shl    $0x2,%eax
  803c35:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c3a:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803c3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c42:	89 d0                	mov    %edx,%eax
  803c44:	01 c0                	add    %eax,%eax
  803c46:	01 d0                	add    %edx,%eax
  803c48:	c1 e0 02             	shl    $0x2,%eax
  803c4b:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c50:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803c55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c58:	89 d0                	mov    %edx,%eax
  803c5a:	01 c0                	add    %eax,%eax
  803c5c:	01 d0                	add    %edx,%eax
  803c5e:	c1 e0 02             	shl    $0x2,%eax
  803c61:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c6c:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803c71:	40                   	inc    %eax
  803c72:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803c77:	ff 4d ec             	decl   -0x14(%ebp)
  803c7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c7e:	0f 89 59 ff ff ff    	jns    803bdd <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803c84:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803c8b:	00 00 00 
}
  803c8e:	90                   	nop
  803c8f:	c9                   	leave  
  803c90:	c3                   	ret    

00803c91 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803c91:	55                   	push   %ebp
  803c92:	89 e5                	mov    %esp,%ebp
  803c94:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803c97:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9a:	83 ec 0c             	sub    $0xc,%esp
  803c9d:	50                   	push   %eax
  803c9e:	e8 10 fd ff ff       	call   8039b3 <to_page_info>
  803ca3:	83 c4 10             	add    $0x10,%esp
  803ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cac:	8b 40 08             	mov    0x8(%eax),%eax
  803caf:	0f b7 c0             	movzwl %ax,%eax
}
  803cb2:	c9                   	leave  
  803cb3:	c3                   	ret    

00803cb4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803cb4:	55                   	push   %ebp
  803cb5:	89 e5                	mov    %esp,%ebp
  803cb7:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803cba:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803cc1:	76 16                	jbe    803cd9 <alloc_block+0x25>
  803cc3:	68 70 4f 80 00       	push   $0x804f70
  803cc8:	68 5a 4f 80 00       	push   $0x804f5a
  803ccd:	6a 59                	push   $0x59
  803ccf:	68 f7 4e 80 00       	push   $0x804ef7
  803cd4:	e8 9c ca ff ff       	call   800775 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803cd9:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803ce0:	eb 08                	jmp    803cea <alloc_block+0x36>
		allocSize <<= 1;
  803ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce5:	01 c0                	add    %eax,%eax
  803ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ced:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cf0:	73 09                	jae    803cfb <alloc_block+0x47>
  803cf2:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803cf9:	76 e7                	jbe    803ce2 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803cfb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803d02:	eb 03                	jmp    803d07 <alloc_block+0x53>
		listIndex++;
  803d04:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d0a:	ba 08 00 00 00       	mov    $0x8,%edx
  803d0f:	88 c1                	mov    %al,%cl
  803d11:	d3 e2                	shl    %cl,%edx
  803d13:	89 d0                	mov    %edx,%eax
  803d15:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803d18:	72 ea                	jb     803d04 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803d20:	e9 f4 00 00 00       	jmp    803e19 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d28:	c1 e0 04             	shl    $0x4,%eax
  803d2b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d30:	8b 00                	mov    (%eax),%eax
  803d32:	85 c0                	test   %eax,%eax
  803d34:	0f 84 dc 00 00 00    	je     803e16 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d3d:	c1 e0 04             	shl    $0x4,%eax
  803d40:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d45:	8b 00                	mov    (%eax),%eax
  803d47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803d4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d4e:	75 14                	jne    803d64 <alloc_block+0xb0>
  803d50:	83 ec 04             	sub    $0x4,%esp
  803d53:	68 91 4f 80 00       	push   $0x804f91
  803d58:	6a 6b                	push   $0x6b
  803d5a:	68 f7 4e 80 00       	push   $0x804ef7
  803d5f:	e8 11 ca ff ff       	call   800775 <_panic>
  803d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d67:	8b 00                	mov    (%eax),%eax
  803d69:	85 c0                	test   %eax,%eax
  803d6b:	74 10                	je     803d7d <alloc_block+0xc9>
  803d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d70:	8b 00                	mov    (%eax),%eax
  803d72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d75:	8b 52 04             	mov    0x4(%edx),%edx
  803d78:	89 50 04             	mov    %edx,0x4(%eax)
  803d7b:	eb 14                	jmp    803d91 <alloc_block+0xdd>
  803d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d80:	8b 40 04             	mov    0x4(%eax),%eax
  803d83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d86:	c1 e2 04             	shl    $0x4,%edx
  803d89:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803d8f:	89 02                	mov    %eax,(%edx)
  803d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d94:	8b 40 04             	mov    0x4(%eax),%eax
  803d97:	85 c0                	test   %eax,%eax
  803d99:	74 0f                	je     803daa <alloc_block+0xf6>
  803d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9e:	8b 40 04             	mov    0x4(%eax),%eax
  803da1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da4:	8b 12                	mov    (%edx),%edx
  803da6:	89 10                	mov    %edx,(%eax)
  803da8:	eb 13                	jmp    803dbd <alloc_block+0x109>
  803daa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dad:	8b 00                	mov    (%eax),%eax
  803daf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803db2:	c1 e2 04             	shl    $0x4,%edx
  803db5:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803dbb:	89 02                	mov    %eax,(%edx)
  803dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dd3:	c1 e0 04             	shl    $0x4,%eax
  803dd6:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803ddb:	8b 00                	mov    (%eax),%eax
  803ddd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803de3:	c1 e0 04             	shl    $0x4,%eax
  803de6:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803deb:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803ded:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df0:	83 ec 0c             	sub    $0xc,%esp
  803df3:	50                   	push   %eax
  803df4:	e8 ba fb ff ff       	call   8039b3 <to_page_info>
  803df9:	83 c4 10             	add    $0x10,%esp
  803dfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e02:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e06:	48                   	dec    %eax
  803e07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e0a:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803e0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e11:	e9 8f 02 00 00       	jmp    8040a5 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803e16:	ff 45 ec             	incl   -0x14(%ebp)
  803e19:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803e1d:	0f 8e 02 ff ff ff    	jle    803d25 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803e23:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803e28:	85 c0                	test   %eax,%eax
  803e2a:	75 14                	jne    803e40 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803e2c:	83 ec 04             	sub    $0x4,%esp
  803e2f:	68 b0 4f 80 00       	push   $0x804fb0
  803e34:	6a 77                	push   $0x77
  803e36:	68 f7 4e 80 00       	push   $0x804ef7
  803e3b:	e8 35 c9 ff ff       	call   800775 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803e40:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803e45:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803e48:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e4c:	75 14                	jne    803e62 <alloc_block+0x1ae>
  803e4e:	83 ec 04             	sub    $0x4,%esp
  803e51:	68 91 4f 80 00       	push   $0x804f91
  803e56:	6a 7a                	push   $0x7a
  803e58:	68 f7 4e 80 00       	push   $0x804ef7
  803e5d:	e8 13 c9 ff ff       	call   800775 <_panic>
  803e62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e65:	8b 00                	mov    (%eax),%eax
  803e67:	85 c0                	test   %eax,%eax
  803e69:	74 10                	je     803e7b <alloc_block+0x1c7>
  803e6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e6e:	8b 00                	mov    (%eax),%eax
  803e70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e73:	8b 52 04             	mov    0x4(%edx),%edx
  803e76:	89 50 04             	mov    %edx,0x4(%eax)
  803e79:	eb 0b                	jmp    803e86 <alloc_block+0x1d2>
  803e7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e7e:	8b 40 04             	mov    0x4(%eax),%eax
  803e81:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e89:	8b 40 04             	mov    0x4(%eax),%eax
  803e8c:	85 c0                	test   %eax,%eax
  803e8e:	74 0f                	je     803e9f <alloc_block+0x1eb>
  803e90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e93:	8b 40 04             	mov    0x4(%eax),%eax
  803e96:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e99:	8b 12                	mov    (%edx),%edx
  803e9b:	89 10                	mov    %edx,(%eax)
  803e9d:	eb 0a                	jmp    803ea9 <alloc_block+0x1f5>
  803e9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ea2:	8b 00                	mov    (%eax),%eax
  803ea4:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ebc:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803ec1:	48                   	dec    %eax
  803ec2:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803ec7:	83 ec 0c             	sub    $0xc,%esp
  803eca:	ff 75 dc             	pushl  -0x24(%ebp)
  803ecd:	e8 6f fa ff ff       	call   803941 <to_page_va>
  803ed2:	83 c4 10             	add    $0x10,%esp
  803ed5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803ed8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803edb:	83 ec 0c             	sub    $0xc,%esp
  803ede:	50                   	push   %eax
  803edf:	e8 a0 dc ff ff       	call   801b84 <get_page>
  803ee4:	83 c4 10             	add    $0x10,%esp
  803ee7:	85 c0                	test   %eax,%eax
  803ee9:	74 14                	je     803eff <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803eeb:	83 ec 04             	sub    $0x4,%esp
  803eee:	68 d8 4f 80 00       	push   $0x804fd8
  803ef3:	6a 7f                	push   $0x7f
  803ef5:	68 f7 4e 80 00       	push   $0x804ef7
  803efa:	e8 76 c8 ff ff       	call   800775 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f05:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803f09:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f0e:	ba 00 00 00 00       	mov    $0x0,%edx
  803f13:	f7 75 f4             	divl   -0xc(%ebp)
  803f16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f19:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803f1d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803f24:	e9 a7 00 00 00       	jmp    803fd0 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803f29:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f2f:	01 d0                	add    %edx,%eax
  803f31:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803f34:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f38:	75 17                	jne    803f51 <alloc_block+0x29d>
  803f3a:	83 ec 04             	sub    $0x4,%esp
  803f3d:	68 00 50 80 00       	push   $0x805000
  803f42:	68 88 00 00 00       	push   $0x88
  803f47:	68 f7 4e 80 00       	push   $0x804ef7
  803f4c:	e8 24 c8 ff ff       	call   800775 <_panic>
  803f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f54:	c1 e0 04             	shl    $0x4,%eax
  803f57:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f5c:	8b 10                	mov    (%eax),%edx
  803f5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f61:	89 10                	mov    %edx,(%eax)
  803f63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f66:	8b 00                	mov    (%eax),%eax
  803f68:	85 c0                	test   %eax,%eax
  803f6a:	74 15                	je     803f81 <alloc_block+0x2cd>
  803f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6f:	c1 e0 04             	shl    $0x4,%eax
  803f72:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f77:	8b 00                	mov    (%eax),%eax
  803f79:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f7c:	89 50 04             	mov    %edx,0x4(%eax)
  803f7f:	eb 11                	jmp    803f92 <alloc_block+0x2de>
  803f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f84:	c1 e0 04             	shl    $0x4,%eax
  803f87:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803f8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f90:	89 02                	mov    %eax,(%edx)
  803f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f95:	c1 e0 04             	shl    $0x4,%eax
  803f98:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803f9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa1:	89 02                	mov    %eax,(%edx)
  803fa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb0:	c1 e0 04             	shl    $0x4,%eax
  803fb3:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803fb8:	8b 00                	mov    (%eax),%eax
  803fba:	8d 50 01             	lea    0x1(%eax),%edx
  803fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc0:	c1 e0 04             	shl    $0x4,%eax
  803fc3:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803fc8:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fcd:	01 45 e8             	add    %eax,-0x18(%ebp)
  803fd0:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803fd7:	0f 86 4c ff ff ff    	jbe    803f29 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe0:	c1 e0 04             	shl    $0x4,%eax
  803fe3:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803fe8:	8b 00                	mov    (%eax),%eax
  803fea:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803fed:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ff1:	75 17                	jne    80400a <alloc_block+0x356>
  803ff3:	83 ec 04             	sub    $0x4,%esp
  803ff6:	68 91 4f 80 00       	push   $0x804f91
  803ffb:	68 8d 00 00 00       	push   $0x8d
  804000:	68 f7 4e 80 00       	push   $0x804ef7
  804005:	e8 6b c7 ff ff       	call   800775 <_panic>
  80400a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80400d:	8b 00                	mov    (%eax),%eax
  80400f:	85 c0                	test   %eax,%eax
  804011:	74 10                	je     804023 <alloc_block+0x36f>
  804013:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804016:	8b 00                	mov    (%eax),%eax
  804018:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80401b:	8b 52 04             	mov    0x4(%edx),%edx
  80401e:	89 50 04             	mov    %edx,0x4(%eax)
  804021:	eb 14                	jmp    804037 <alloc_block+0x383>
  804023:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804026:	8b 40 04             	mov    0x4(%eax),%eax
  804029:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80402c:	c1 e2 04             	shl    $0x4,%edx
  80402f:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804035:	89 02                	mov    %eax,(%edx)
  804037:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80403a:	8b 40 04             	mov    0x4(%eax),%eax
  80403d:	85 c0                	test   %eax,%eax
  80403f:	74 0f                	je     804050 <alloc_block+0x39c>
  804041:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804044:	8b 40 04             	mov    0x4(%eax),%eax
  804047:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80404a:	8b 12                	mov    (%edx),%edx
  80404c:	89 10                	mov    %edx,(%eax)
  80404e:	eb 13                	jmp    804063 <alloc_block+0x3af>
  804050:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804053:	8b 00                	mov    (%eax),%eax
  804055:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804058:	c1 e2 04             	shl    $0x4,%edx
  80405b:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804061:	89 02                	mov    %eax,(%edx)
  804063:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804066:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80406c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80406f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804079:	c1 e0 04             	shl    $0x4,%eax
  80407c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804081:	8b 00                	mov    (%eax),%eax
  804083:	8d 50 ff             	lea    -0x1(%eax),%edx
  804086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804089:	c1 e0 04             	shl    $0x4,%eax
  80408c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804091:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  804093:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804096:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80409a:	48                   	dec    %eax
  80409b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80409e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  8040a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8040a5:	c9                   	leave  
  8040a6:	c3                   	ret    

008040a7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8040a7:	55                   	push   %ebp
  8040a8:	89 e5                	mov    %esp,%ebp
  8040aa:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8040ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8040b0:	a1 84 60 83 00       	mov    0x836084,%eax
  8040b5:	39 c2                	cmp    %eax,%edx
  8040b7:	72 0c                	jb     8040c5 <free_block+0x1e>
  8040b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8040bc:	a1 60 e0 81 00       	mov    0x81e060,%eax
  8040c1:	39 c2                	cmp    %eax,%edx
  8040c3:	72 19                	jb     8040de <free_block+0x37>
  8040c5:	68 24 50 80 00       	push   $0x805024
  8040ca:	68 5a 4f 80 00       	push   $0x804f5a
  8040cf:	68 98 00 00 00       	push   $0x98
  8040d4:	68 f7 4e 80 00       	push   $0x804ef7
  8040d9:	e8 97 c6 ff ff       	call   800775 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8040de:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e1:	83 ec 0c             	sub    $0xc,%esp
  8040e4:	50                   	push   %eax
  8040e5:	e8 c9 f8 ff ff       	call   8039b3 <to_page_info>
  8040ea:	83 c4 10             	add    $0x10,%esp
  8040ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  8040f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040f3:	8b 40 08             	mov    0x8(%eax),%eax
  8040f6:	0f b7 c0             	movzwl %ax,%eax
  8040f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  8040fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804103:	eb 03                	jmp    804108 <free_block+0x61>
		listIndex++;
  804105:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80410b:	ba 08 00 00 00       	mov    $0x8,%edx
  804110:	88 c1                	mov    %al,%cl
  804112:	d3 e2                	shl    %cl,%edx
  804114:	89 d0                	mov    %edx,%eax
  804116:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804119:	72 ea                	jb     804105 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  80411b:	8b 45 08             	mov    0x8(%ebp),%eax
  80411e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  804121:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804125:	75 17                	jne    80413e <free_block+0x97>
  804127:	83 ec 04             	sub    $0x4,%esp
  80412a:	68 00 50 80 00       	push   $0x805000
  80412f:	68 a2 00 00 00       	push   $0xa2
  804134:	68 f7 4e 80 00       	push   $0x804ef7
  804139:	e8 37 c6 ff ff       	call   800775 <_panic>
  80413e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804141:	c1 e0 04             	shl    $0x4,%eax
  804144:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804149:	8b 10                	mov    (%eax),%edx
  80414b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80414e:	89 10                	mov    %edx,(%eax)
  804150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804153:	8b 00                	mov    (%eax),%eax
  804155:	85 c0                	test   %eax,%eax
  804157:	74 15                	je     80416e <free_block+0xc7>
  804159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80415c:	c1 e0 04             	shl    $0x4,%eax
  80415f:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804164:	8b 00                	mov    (%eax),%eax
  804166:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804169:	89 50 04             	mov    %edx,0x4(%eax)
  80416c:	eb 11                	jmp    80417f <free_block+0xd8>
  80416e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804171:	c1 e0 04             	shl    $0x4,%eax
  804174:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  80417a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80417d:	89 02                	mov    %eax,(%edx)
  80417f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804182:	c1 e0 04             	shl    $0x4,%eax
  804185:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  80418b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418e:	89 02                	mov    %eax,(%edx)
  804190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804193:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80419a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80419d:	c1 e0 04             	shl    $0x4,%eax
  8041a0:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041a5:	8b 00                	mov    (%eax),%eax
  8041a7:	8d 50 01             	lea    0x1(%eax),%edx
  8041aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ad:	c1 e0 04             	shl    $0x4,%eax
  8041b0:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041b5:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  8041b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041ba:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8041be:	40                   	inc    %eax
  8041bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041c2:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  8041c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041c9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8041cd:	0f b7 c8             	movzwl %ax,%ecx
  8041d0:	b8 00 10 00 00       	mov    $0x1000,%eax
  8041d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8041da:	f7 75 e8             	divl   -0x18(%ebp)
  8041dd:	39 c1                	cmp    %eax,%ecx
  8041df:	0f 85 ed 01 00 00    	jne    8043d2 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8041e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041e8:	c1 e0 04             	shl    $0x4,%eax
  8041eb:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041f0:	8b 00                	mov    (%eax),%eax
  8041f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041f5:	eb 2a                	jmp    804221 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  8041f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041fa:	83 ec 0c             	sub    $0xc,%esp
  8041fd:	50                   	push   %eax
  8041fe:	e8 b0 f7 ff ff       	call   8039b3 <to_page_info>
  804203:	83 c4 10             	add    $0x10,%esp
  804206:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804209:	75 06                	jne    804211 <free_block+0x16a>
				tmp = b;
  80420b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80420e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804214:	c1 e0 04             	shl    $0x4,%eax
  804217:	05 a8 60 83 00       	add    $0x8360a8,%eax
  80421c:	8b 00                	mov    (%eax),%eax
  80421e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804225:	74 07                	je     80422e <free_block+0x187>
  804227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80422a:	8b 00                	mov    (%eax),%eax
  80422c:	eb 05                	jmp    804233 <free_block+0x18c>
  80422e:	b8 00 00 00 00       	mov    $0x0,%eax
  804233:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804236:	c1 e2 04             	shl    $0x4,%edx
  804239:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  80423f:	89 02                	mov    %eax,(%edx)
  804241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804244:	c1 e0 04             	shl    $0x4,%eax
  804247:	05 a8 60 83 00       	add    $0x8360a8,%eax
  80424c:	8b 00                	mov    (%eax),%eax
  80424e:	85 c0                	test   %eax,%eax
  804250:	75 a5                	jne    8041f7 <free_block+0x150>
  804252:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804256:	75 9f                	jne    8041f7 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80425b:	c1 e0 04             	shl    $0x4,%eax
  80425e:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804263:	8b 00                	mov    (%eax),%eax
  804265:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804268:	e9 cc 00 00 00       	jmp    804339 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  80426d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804270:	8b 00                	mov    (%eax),%eax
  804272:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804278:	83 ec 0c             	sub    $0xc,%esp
  80427b:	50                   	push   %eax
  80427c:	e8 32 f7 ff ff       	call   8039b3 <to_page_info>
  804281:	83 c4 10             	add    $0x10,%esp
  804284:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804287:	0f 85 a6 00 00 00    	jne    804333 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  80428d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804291:	75 17                	jne    8042aa <free_block+0x203>
  804293:	83 ec 04             	sub    $0x4,%esp
  804296:	68 91 4f 80 00       	push   $0x804f91
  80429b:	68 b5 00 00 00       	push   $0xb5
  8042a0:	68 f7 4e 80 00       	push   $0x804ef7
  8042a5:	e8 cb c4 ff ff       	call   800775 <_panic>
  8042aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ad:	8b 00                	mov    (%eax),%eax
  8042af:	85 c0                	test   %eax,%eax
  8042b1:	74 10                	je     8042c3 <free_block+0x21c>
  8042b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b6:	8b 00                	mov    (%eax),%eax
  8042b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042bb:	8b 52 04             	mov    0x4(%edx),%edx
  8042be:	89 50 04             	mov    %edx,0x4(%eax)
  8042c1:	eb 14                	jmp    8042d7 <free_block+0x230>
  8042c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042c6:	8b 40 04             	mov    0x4(%eax),%eax
  8042c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042cc:	c1 e2 04             	shl    $0x4,%edx
  8042cf:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  8042d5:	89 02                	mov    %eax,(%edx)
  8042d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042da:	8b 40 04             	mov    0x4(%eax),%eax
  8042dd:	85 c0                	test   %eax,%eax
  8042df:	74 0f                	je     8042f0 <free_block+0x249>
  8042e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042e4:	8b 40 04             	mov    0x4(%eax),%eax
  8042e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042ea:	8b 12                	mov    (%edx),%edx
  8042ec:	89 10                	mov    %edx,(%eax)
  8042ee:	eb 13                	jmp    804303 <free_block+0x25c>
  8042f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042f3:	8b 00                	mov    (%eax),%eax
  8042f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042f8:	c1 e2 04             	shl    $0x4,%edx
  8042fb:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804301:	89 02                	mov    %eax,(%edx)
  804303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80430c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80430f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804319:	c1 e0 04             	shl    $0x4,%eax
  80431c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804321:	8b 00                	mov    (%eax),%eax
  804323:	8d 50 ff             	lea    -0x1(%eax),%edx
  804326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804329:	c1 e0 04             	shl    $0x4,%eax
  80432c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804331:	89 10                	mov    %edx,(%eax)
			b = next;
  804333:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804336:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80433d:	0f 85 2a ff ff ff    	jne    80426d <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  804343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804346:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80434c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80434f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804355:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804359:	75 17                	jne    804372 <free_block+0x2cb>
  80435b:	83 ec 04             	sub    $0x4,%esp
  80435e:	68 00 50 80 00       	push   $0x805000
  804363:	68 bc 00 00 00       	push   $0xbc
  804368:	68 f7 4e 80 00       	push   $0x804ef7
  80436d:	e8 03 c4 ff ff       	call   800775 <_panic>
  804372:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  804378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80437b:	89 10                	mov    %edx,(%eax)
  80437d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804380:	8b 00                	mov    (%eax),%eax
  804382:	85 c0                	test   %eax,%eax
  804384:	74 0d                	je     804393 <free_block+0x2ec>
  804386:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80438b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80438e:	89 50 04             	mov    %edx,0x4(%eax)
  804391:	eb 08                	jmp    80439b <free_block+0x2f4>
  804393:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804396:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  80439b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80439e:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8043a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043ad:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8043b2:	40                   	inc    %eax
  8043b3:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  8043b8:	83 ec 0c             	sub    $0xc,%esp
  8043bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8043be:	e8 7e f5 ff ff       	call   803941 <to_page_va>
  8043c3:	83 c4 10             	add    $0x10,%esp
  8043c6:	83 ec 0c             	sub    $0xc,%esp
  8043c9:	50                   	push   %eax
  8043ca:	e8 fe d7 ff ff       	call   801bcd <return_page>
  8043cf:	83 c4 10             	add    $0x10,%esp
	}
}
  8043d2:	90                   	nop
  8043d3:	c9                   	leave  
  8043d4:	c3                   	ret    
  8043d5:	66 90                	xchg   %ax,%ax
  8043d7:	90                   	nop

008043d8 <__udivdi3>:
  8043d8:	55                   	push   %ebp
  8043d9:	57                   	push   %edi
  8043da:	56                   	push   %esi
  8043db:	53                   	push   %ebx
  8043dc:	83 ec 1c             	sub    $0x1c,%esp
  8043df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8043e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043ef:	89 ca                	mov    %ecx,%edx
  8043f1:	89 f8                	mov    %edi,%eax
  8043f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043f7:	85 f6                	test   %esi,%esi
  8043f9:	75 2d                	jne    804428 <__udivdi3+0x50>
  8043fb:	39 cf                	cmp    %ecx,%edi
  8043fd:	77 65                	ja     804464 <__udivdi3+0x8c>
  8043ff:	89 fd                	mov    %edi,%ebp
  804401:	85 ff                	test   %edi,%edi
  804403:	75 0b                	jne    804410 <__udivdi3+0x38>
  804405:	b8 01 00 00 00       	mov    $0x1,%eax
  80440a:	31 d2                	xor    %edx,%edx
  80440c:	f7 f7                	div    %edi
  80440e:	89 c5                	mov    %eax,%ebp
  804410:	31 d2                	xor    %edx,%edx
  804412:	89 c8                	mov    %ecx,%eax
  804414:	f7 f5                	div    %ebp
  804416:	89 c1                	mov    %eax,%ecx
  804418:	89 d8                	mov    %ebx,%eax
  80441a:	f7 f5                	div    %ebp
  80441c:	89 cf                	mov    %ecx,%edi
  80441e:	89 fa                	mov    %edi,%edx
  804420:	83 c4 1c             	add    $0x1c,%esp
  804423:	5b                   	pop    %ebx
  804424:	5e                   	pop    %esi
  804425:	5f                   	pop    %edi
  804426:	5d                   	pop    %ebp
  804427:	c3                   	ret    
  804428:	39 ce                	cmp    %ecx,%esi
  80442a:	77 28                	ja     804454 <__udivdi3+0x7c>
  80442c:	0f bd fe             	bsr    %esi,%edi
  80442f:	83 f7 1f             	xor    $0x1f,%edi
  804432:	75 40                	jne    804474 <__udivdi3+0x9c>
  804434:	39 ce                	cmp    %ecx,%esi
  804436:	72 0a                	jb     804442 <__udivdi3+0x6a>
  804438:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80443c:	0f 87 9e 00 00 00    	ja     8044e0 <__udivdi3+0x108>
  804442:	b8 01 00 00 00       	mov    $0x1,%eax
  804447:	89 fa                	mov    %edi,%edx
  804449:	83 c4 1c             	add    $0x1c,%esp
  80444c:	5b                   	pop    %ebx
  80444d:	5e                   	pop    %esi
  80444e:	5f                   	pop    %edi
  80444f:	5d                   	pop    %ebp
  804450:	c3                   	ret    
  804451:	8d 76 00             	lea    0x0(%esi),%esi
  804454:	31 ff                	xor    %edi,%edi
  804456:	31 c0                	xor    %eax,%eax
  804458:	89 fa                	mov    %edi,%edx
  80445a:	83 c4 1c             	add    $0x1c,%esp
  80445d:	5b                   	pop    %ebx
  80445e:	5e                   	pop    %esi
  80445f:	5f                   	pop    %edi
  804460:	5d                   	pop    %ebp
  804461:	c3                   	ret    
  804462:	66 90                	xchg   %ax,%ax
  804464:	89 d8                	mov    %ebx,%eax
  804466:	f7 f7                	div    %edi
  804468:	31 ff                	xor    %edi,%edi
  80446a:	89 fa                	mov    %edi,%edx
  80446c:	83 c4 1c             	add    $0x1c,%esp
  80446f:	5b                   	pop    %ebx
  804470:	5e                   	pop    %esi
  804471:	5f                   	pop    %edi
  804472:	5d                   	pop    %ebp
  804473:	c3                   	ret    
  804474:	bd 20 00 00 00       	mov    $0x20,%ebp
  804479:	89 eb                	mov    %ebp,%ebx
  80447b:	29 fb                	sub    %edi,%ebx
  80447d:	89 f9                	mov    %edi,%ecx
  80447f:	d3 e6                	shl    %cl,%esi
  804481:	89 c5                	mov    %eax,%ebp
  804483:	88 d9                	mov    %bl,%cl
  804485:	d3 ed                	shr    %cl,%ebp
  804487:	89 e9                	mov    %ebp,%ecx
  804489:	09 f1                	or     %esi,%ecx
  80448b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80448f:	89 f9                	mov    %edi,%ecx
  804491:	d3 e0                	shl    %cl,%eax
  804493:	89 c5                	mov    %eax,%ebp
  804495:	89 d6                	mov    %edx,%esi
  804497:	88 d9                	mov    %bl,%cl
  804499:	d3 ee                	shr    %cl,%esi
  80449b:	89 f9                	mov    %edi,%ecx
  80449d:	d3 e2                	shl    %cl,%edx
  80449f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044a3:	88 d9                	mov    %bl,%cl
  8044a5:	d3 e8                	shr    %cl,%eax
  8044a7:	09 c2                	or     %eax,%edx
  8044a9:	89 d0                	mov    %edx,%eax
  8044ab:	89 f2                	mov    %esi,%edx
  8044ad:	f7 74 24 0c          	divl   0xc(%esp)
  8044b1:	89 d6                	mov    %edx,%esi
  8044b3:	89 c3                	mov    %eax,%ebx
  8044b5:	f7 e5                	mul    %ebp
  8044b7:	39 d6                	cmp    %edx,%esi
  8044b9:	72 19                	jb     8044d4 <__udivdi3+0xfc>
  8044bb:	74 0b                	je     8044c8 <__udivdi3+0xf0>
  8044bd:	89 d8                	mov    %ebx,%eax
  8044bf:	31 ff                	xor    %edi,%edi
  8044c1:	e9 58 ff ff ff       	jmp    80441e <__udivdi3+0x46>
  8044c6:	66 90                	xchg   %ax,%ax
  8044c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8044cc:	89 f9                	mov    %edi,%ecx
  8044ce:	d3 e2                	shl    %cl,%edx
  8044d0:	39 c2                	cmp    %eax,%edx
  8044d2:	73 e9                	jae    8044bd <__udivdi3+0xe5>
  8044d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8044d7:	31 ff                	xor    %edi,%edi
  8044d9:	e9 40 ff ff ff       	jmp    80441e <__udivdi3+0x46>
  8044de:	66 90                	xchg   %ax,%ax
  8044e0:	31 c0                	xor    %eax,%eax
  8044e2:	e9 37 ff ff ff       	jmp    80441e <__udivdi3+0x46>
  8044e7:	90                   	nop

008044e8 <__umoddi3>:
  8044e8:	55                   	push   %ebp
  8044e9:	57                   	push   %edi
  8044ea:	56                   	push   %esi
  8044eb:	53                   	push   %ebx
  8044ec:	83 ec 1c             	sub    $0x1c,%esp
  8044ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804503:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804507:	89 f3                	mov    %esi,%ebx
  804509:	89 fa                	mov    %edi,%edx
  80450b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80450f:	89 34 24             	mov    %esi,(%esp)
  804512:	85 c0                	test   %eax,%eax
  804514:	75 1a                	jne    804530 <__umoddi3+0x48>
  804516:	39 f7                	cmp    %esi,%edi
  804518:	0f 86 a2 00 00 00    	jbe    8045c0 <__umoddi3+0xd8>
  80451e:	89 c8                	mov    %ecx,%eax
  804520:	89 f2                	mov    %esi,%edx
  804522:	f7 f7                	div    %edi
  804524:	89 d0                	mov    %edx,%eax
  804526:	31 d2                	xor    %edx,%edx
  804528:	83 c4 1c             	add    $0x1c,%esp
  80452b:	5b                   	pop    %ebx
  80452c:	5e                   	pop    %esi
  80452d:	5f                   	pop    %edi
  80452e:	5d                   	pop    %ebp
  80452f:	c3                   	ret    
  804530:	39 f0                	cmp    %esi,%eax
  804532:	0f 87 ac 00 00 00    	ja     8045e4 <__umoddi3+0xfc>
  804538:	0f bd e8             	bsr    %eax,%ebp
  80453b:	83 f5 1f             	xor    $0x1f,%ebp
  80453e:	0f 84 ac 00 00 00    	je     8045f0 <__umoddi3+0x108>
  804544:	bf 20 00 00 00       	mov    $0x20,%edi
  804549:	29 ef                	sub    %ebp,%edi
  80454b:	89 fe                	mov    %edi,%esi
  80454d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804551:	89 e9                	mov    %ebp,%ecx
  804553:	d3 e0                	shl    %cl,%eax
  804555:	89 d7                	mov    %edx,%edi
  804557:	89 f1                	mov    %esi,%ecx
  804559:	d3 ef                	shr    %cl,%edi
  80455b:	09 c7                	or     %eax,%edi
  80455d:	89 e9                	mov    %ebp,%ecx
  80455f:	d3 e2                	shl    %cl,%edx
  804561:	89 14 24             	mov    %edx,(%esp)
  804564:	89 d8                	mov    %ebx,%eax
  804566:	d3 e0                	shl    %cl,%eax
  804568:	89 c2                	mov    %eax,%edx
  80456a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80456e:	d3 e0                	shl    %cl,%eax
  804570:	89 44 24 04          	mov    %eax,0x4(%esp)
  804574:	8b 44 24 08          	mov    0x8(%esp),%eax
  804578:	89 f1                	mov    %esi,%ecx
  80457a:	d3 e8                	shr    %cl,%eax
  80457c:	09 d0                	or     %edx,%eax
  80457e:	d3 eb                	shr    %cl,%ebx
  804580:	89 da                	mov    %ebx,%edx
  804582:	f7 f7                	div    %edi
  804584:	89 d3                	mov    %edx,%ebx
  804586:	f7 24 24             	mull   (%esp)
  804589:	89 c6                	mov    %eax,%esi
  80458b:	89 d1                	mov    %edx,%ecx
  80458d:	39 d3                	cmp    %edx,%ebx
  80458f:	0f 82 87 00 00 00    	jb     80461c <__umoddi3+0x134>
  804595:	0f 84 91 00 00 00    	je     80462c <__umoddi3+0x144>
  80459b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80459f:	29 f2                	sub    %esi,%edx
  8045a1:	19 cb                	sbb    %ecx,%ebx
  8045a3:	89 d8                	mov    %ebx,%eax
  8045a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8045a9:	d3 e0                	shl    %cl,%eax
  8045ab:	89 e9                	mov    %ebp,%ecx
  8045ad:	d3 ea                	shr    %cl,%edx
  8045af:	09 d0                	or     %edx,%eax
  8045b1:	89 e9                	mov    %ebp,%ecx
  8045b3:	d3 eb                	shr    %cl,%ebx
  8045b5:	89 da                	mov    %ebx,%edx
  8045b7:	83 c4 1c             	add    $0x1c,%esp
  8045ba:	5b                   	pop    %ebx
  8045bb:	5e                   	pop    %esi
  8045bc:	5f                   	pop    %edi
  8045bd:	5d                   	pop    %ebp
  8045be:	c3                   	ret    
  8045bf:	90                   	nop
  8045c0:	89 fd                	mov    %edi,%ebp
  8045c2:	85 ff                	test   %edi,%edi
  8045c4:	75 0b                	jne    8045d1 <__umoddi3+0xe9>
  8045c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8045cb:	31 d2                	xor    %edx,%edx
  8045cd:	f7 f7                	div    %edi
  8045cf:	89 c5                	mov    %eax,%ebp
  8045d1:	89 f0                	mov    %esi,%eax
  8045d3:	31 d2                	xor    %edx,%edx
  8045d5:	f7 f5                	div    %ebp
  8045d7:	89 c8                	mov    %ecx,%eax
  8045d9:	f7 f5                	div    %ebp
  8045db:	89 d0                	mov    %edx,%eax
  8045dd:	e9 44 ff ff ff       	jmp    804526 <__umoddi3+0x3e>
  8045e2:	66 90                	xchg   %ax,%ax
  8045e4:	89 c8                	mov    %ecx,%eax
  8045e6:	89 f2                	mov    %esi,%edx
  8045e8:	83 c4 1c             	add    $0x1c,%esp
  8045eb:	5b                   	pop    %ebx
  8045ec:	5e                   	pop    %esi
  8045ed:	5f                   	pop    %edi
  8045ee:	5d                   	pop    %ebp
  8045ef:	c3                   	ret    
  8045f0:	3b 04 24             	cmp    (%esp),%eax
  8045f3:	72 06                	jb     8045fb <__umoddi3+0x113>
  8045f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045f9:	77 0f                	ja     80460a <__umoddi3+0x122>
  8045fb:	89 f2                	mov    %esi,%edx
  8045fd:	29 f9                	sub    %edi,%ecx
  8045ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804603:	89 14 24             	mov    %edx,(%esp)
  804606:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80460a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80460e:	8b 14 24             	mov    (%esp),%edx
  804611:	83 c4 1c             	add    $0x1c,%esp
  804614:	5b                   	pop    %ebx
  804615:	5e                   	pop    %esi
  804616:	5f                   	pop    %edi
  804617:	5d                   	pop    %ebp
  804618:	c3                   	ret    
  804619:	8d 76 00             	lea    0x0(%esi),%esi
  80461c:	2b 04 24             	sub    (%esp),%eax
  80461f:	19 fa                	sbb    %edi,%edx
  804621:	89 d1                	mov    %edx,%ecx
  804623:	89 c6                	mov    %eax,%esi
  804625:	e9 71 ff ff ff       	jmp    80459b <__umoddi3+0xb3>
  80462a:	66 90                	xchg   %ax,%ax
  80462c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804630:	72 ea                	jb     80461c <__umoddi3+0x134>
  804632:	89 d9                	mov    %ebx,%ecx
  804634:	e9 62 ff ff ff       	jmp    80459b <__umoddi3+0xb3>
