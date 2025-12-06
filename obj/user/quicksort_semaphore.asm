
obj/user/quicksort_semaphore:     file format elf32-i386


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
  800031:	e8 3b 06 00 00       	call   800671 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);
struct semaphore IO_CS ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp
	int envID = sys_getenvid();
  800042:	e8 ca 36 00 00       	call   803711 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 60 47 80 00       	push   $0x804760
  800061:	50                   	push   %eax
  800062:	e8 1a 44 00 00       	call   804481 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 80 60 83 00       	mov    %eax,0x836080
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 e7 34 00 00       	call   803561 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 f9 34 00 00       	call   80357a <sys_calculate_modified_frames>
  800081:	01 d8                	add    %ebx,%eax
  800083:	89 45 ec             	mov    %eax,-0x14(%ebp)

		Iteration++ ;
  800086:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();
		int NumOfElements, *Elements;
		wait_semaphore(IO_CS);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 35 80 60 83 00    	pushl  0x836080
  800092:	e8 1e 44 00 00       	call   8044b5 <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 68 47 80 00       	push   $0x804768
  8000a9:	e8 1a 11 00 00       	call   8011c8 <readline>
  8000ae:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 0a                	push   $0xa
  8000b6:	6a 00                	push   $0x0
  8000b8:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 1b 17 00 00       	call   8017df <strtol>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c1 e0 02             	shl    $0x2,%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 e0 1b 00 00       	call   801cb9 <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 88 47 80 00       	push   $0x804788
  8000e7:	e8 03 0a 00 00       	call   800aef <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 ab 47 80 00       	push   $0x8047ab
  8000f7:	e8 f3 09 00 00       	call   800aef <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 b9 47 80 00       	push   $0x8047b9
  800107:	e8 e3 09 00 00       	call   800aef <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 c8 47 80 00       	push   $0x8047c8
  800117:	e8 d3 09 00 00       	call   800aef <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 d8 47 80 00       	push   $0x8047d8
  800127:	e8 c3 09 00 00       	call   800aef <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012f:	e8 20 05 00 00       	call   800654 <getchar>
  800134:	88 45 e3             	mov    %al,-0x1d(%ebp)
				cputchar(Chose);
  800137:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 f1 04 00 00       	call   800635 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 e4 04 00 00       	call   800635 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>

		}
		signal_semaphore(IO_CS);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 35 80 60 83 00    	pushl  0x836080
  80016f:	e8 5b 43 00 00       	call   8044cf <signal_semaphore>
  800174:	83 c4 10             	add    $0x10,%esp

		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800177:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80017b:	83 f8 62             	cmp    $0x62,%eax
  80017e:	74 1d                	je     80019d <_main+0x165>
  800180:	83 f8 63             	cmp    $0x63,%eax
  800183:	74 2b                	je     8001b0 <_main+0x178>
  800185:	83 f8 61             	cmp    $0x61,%eax
  800188:	75 39                	jne    8001c3 <_main+0x18b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 e8             	pushl  -0x18(%ebp)
  800190:	ff 75 e4             	pushl  -0x1c(%ebp)
  800193:	e8 2e 03 00 00       	call   8004c6 <InitializeAscending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 37                	jmp    8001d4 <_main+0x19c>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a6:	e8 4c 03 00 00       	call   8004f7 <InitializeIdentical>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 24                	jmp    8001d4 <_main+0x19c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b9:	e8 6e 03 00 00       	call   80052c <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c1:	eb 11                	jmp    8001d4 <_main+0x19c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cc:	e8 5b 03 00 00       	call   80052c <InitializeSemiRandom>
  8001d1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001dd:	e8 29 01 00 00       	call   80030b <QuickSort>
  8001e2:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ee:	e8 29 02 00 00       	call   80041c <CheckSorted>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001fd:	75 14                	jne    800213 <_main+0x1db>
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	68 e4 47 80 00       	push   $0x8047e4
  800207:	6a 4d                	push   $0x4d
  800209:	68 06 48 80 00       	push   $0x804806
  80020e:	e8 0e 06 00 00       	call   800821 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 80 60 83 00    	pushl  0x836080
  80021c:	e8 94 42 00 00       	call   8044b5 <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 24 48 80 00       	push   $0x804824
  80022c:	e8 be 08 00 00       	call   800aef <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 58 48 80 00       	push   $0x804858
  80023c:	e8 ae 08 00 00       	call   800aef <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 8c 48 80 00       	push   $0x80488c
  80024c:	e8 9e 08 00 00       	call   800aef <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 80 60 83 00    	pushl  0x836080
  80025d:	e8 6d 42 00 00       	call   8044cf <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 80 60 83 00    	pushl  0x836080
  80026e:	e8 42 42 00 00       	call   8044b5 <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 be 48 80 00       	push   $0x8048be
  80027e:	e8 6c 08 00 00       	call   800aef <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 80 60 83 00    	pushl  0x836080
  80028f:	e8 3b 42 00 00       	call   8044cf <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 80 60 83 00    	pushl  0x836080
  8002a0:	e8 10 42 00 00       	call   8044b5 <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 d4 48 80 00       	push   $0x8048d4
  8002b0:	e8 3a 08 00 00       	call   800aef <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002b8:	e8 97 03 00 00       	call   800654 <getchar>
  8002bd:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  8002c0:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	50                   	push   %eax
  8002c8:	e8 68 03 00 00       	call   800635 <cputchar>
  8002cd:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	6a 0a                	push   $0xa
  8002d5:	e8 5b 03 00 00       	call   800635 <cputchar>
  8002da:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	6a 0a                	push   $0xa
  8002e2:	e8 4e 03 00 00       	call   800635 <cputchar>
  8002e7:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		signal_semaphore(IO_CS);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 35 80 60 83 00    	pushl  0x836080
  8002f3:	e8 d7 41 00 00       	call   8044cf <signal_semaphore>
  8002f8:	83 c4 10             	add    $0x10,%esp

	} while (Chose == 'y');
  8002fb:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8002ff:	0f 84 70 fd ff ff    	je     800075 <_main+0x3d>

}
  800305:	90                   	nop
  800306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	50                   	push   %eax
  800316:	6a 00                	push   $0x0
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 06 00 00 00       	call   800329 <QSort>
  800323:	83 c4 10             	add    $0x10,%esp
}
  800326:	90                   	nop
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	3b 45 14             	cmp    0x14(%ebp),%eax
  800335:	0f 8d de 00 00 00    	jge    800419 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80033b:	8b 45 10             	mov    0x10(%ebp),%eax
  80033e:	40                   	inc    %eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800342:	8b 45 14             	mov    0x14(%ebp),%eax
  800345:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800348:	e9 80 00 00 00       	jmp    8003cd <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80034d:	ff 45 f4             	incl   -0xc(%ebp)
  800350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800353:	3b 45 14             	cmp    0x14(%ebp),%eax
  800356:	7f 2b                	jg     800383 <QSort+0x5a>
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	01 d0                	add    %edx,%eax
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	01 c8                	add    %ecx,%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	7d cf                	jge    80034d <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80037e:	eb 03                	jmp    800383 <QSort+0x5a>
  800380:	ff 4d f0             	decl   -0x10(%ebp)
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	3b 45 10             	cmp    0x10(%ebp),%eax
  800389:	7e 26                	jle    8003b1 <QSort+0x88>
  80038b:	8b 45 10             	mov    0x10(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	8b 10                	mov    (%eax),%edx
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	39 c2                	cmp    %eax,%edx
  8003af:	7e cf                	jle    800380 <QSort+0x57>

		if (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	7f 14                	jg     8003cd <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	e8 a9 00 00 00       	call   800473 <Swap>
  8003ca:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d3:	0f 8e 77 ff ff ff    	jle    800350 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003df:	ff 75 10             	pushl  0x10(%ebp)
  8003e2:	ff 75 08             	pushl  0x8(%ebp)
  8003e5:	e8 89 00 00 00       	call   800473 <Swap>
  8003ea:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f0:	48                   	dec    %eax
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 10             	pushl  0x10(%ebp)
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 29 ff ff ff       	call   800329 <QSort>
  800400:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800403:	ff 75 14             	pushl  0x14(%ebp)
  800406:	ff 75 f4             	pushl  -0xc(%ebp)
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	e8 15 ff ff ff       	call   800329 <QSort>
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	eb 01                	jmp    80041a <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800419:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800422:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800429:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800430:	eb 33                	jmp    800465 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800432:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 10                	mov    (%eax),%edx
  800443:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800446:	40                   	inc    %eax
  800447:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c8                	add    %ecx,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	39 c2                	cmp    %eax,%edx
  800457:	7e 09                	jle    800462 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800460:	eb 0c                	jmp    80046e <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800462:	ff 45 f8             	incl   -0x8(%ebp)
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	48                   	dec    %eax
  800469:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80046c:	7f c4                	jg     800432 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80046e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c2                	add    %eax,%edx
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	01 c8                	add    %ecx,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8004af:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	01 c2                	add    %eax,%edx
  8004be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c1:	89 02                	mov    %eax,(%edx)
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004d3:	eb 17                	jmp    8004ec <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8004d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 c2                	add    %eax,%edx
  8004e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e7:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e9:	ff 45 fc             	incl   -0x4(%ebp)
  8004ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f2:	7c e1                	jl     8004d5 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004f4:	90                   	nop
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1b                	jmp    800521 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 c2                	add    %eax,%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80051b:	48                   	dec    %eax
  80051c:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80051e:	ff 45 fc             	incl   -0x4(%ebp)
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800527:	7c dd                	jl     800506 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800529:	90                   	nop
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800535:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80053a:	f7 e9                	imul   %ecx
  80053c:	c1 f9 1f             	sar    $0x1f,%ecx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	29 c8                	sub    %ecx,%eax
  800543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800546:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80054a:	75 07                	jne    800553 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80054c:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800553:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80055a:	eb 1e                	jmp    80057a <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80055c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80055f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80056c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80056f:	99                   	cltd   
  800570:	f7 7d f8             	idivl  -0x8(%ebp)
  800573:	89 d0                	mov    %edx,%eax
  800575:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800577:	ff 45 fc             	incl   -0x4(%ebp)
  80057a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80057d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800580:	7c da                	jl     80055c <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  800582:	90                   	nop
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80058b:	e8 81 31 00 00       	call   803711 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 80 60 83 00    	pushl  0x836080
  80059c:	e8 14 3f 00 00       	call   8044b5 <wait_semaphore>
  8005a1:	83 c4 10             	add    $0x10,%esp
		int i ;
		int NumsPerLine = 20 ;
  8005a4:	c7 45 ec 14 00 00 00 	movl   $0x14,-0x14(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005b2:	eb 42                	jmp    8005f6 <PrintElements+0x71>
		{
			if (i%NumsPerLine == 0)
  8005b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b7:	99                   	cltd   
  8005b8:	f7 7d ec             	idivl  -0x14(%ebp)
  8005bb:	89 d0                	mov    %edx,%eax
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	75 10                	jne    8005d1 <PrintElements+0x4c>
				cprintf("\n");
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	68 f2 48 80 00       	push   $0x8048f2
  8005c9:	e8 21 05 00 00       	call   800aef <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	68 f4 48 80 00       	push   $0x8048f4
  8005eb:	e8 ff 04 00 00       	call   800aef <cprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
{
	int envID = sys_getenvid();
	wait_semaphore(IO_CS);
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005f3:	ff 45 f4             	incl   -0xc(%ebp)
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	48                   	dec    %eax
  8005fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005fd:	7f b5                	jg     8005b4 <PrintElements+0x2f>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  8005ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	01 d0                	add    %edx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	50                   	push   %eax
  800614:	68 f9 48 80 00       	push   $0x8048f9
  800619:	e8 d1 04 00 00       	call   800aef <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 80 60 83 00    	pushl  0x836080
  80062a:	e8 a0 3e 00 00       	call   8044cf <signal_semaphore>
  80062f:	83 c4 10             	add    $0x10,%esp
}
  800632:	90                   	nop
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800641:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	e8 ab 2f 00 00       	call   8035f9 <sys_cputc>
  80064e:	83 c4 10             	add    $0x10,%esp
}
  800651:	90                   	nop
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <getchar>:


int
getchar(void)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80065a:	e8 39 2e 00 00       	call   803498 <sys_cgetc>
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <iscons>:

int iscons(int fdnum)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80066a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80066f:	5d                   	pop    %ebp
  800670:	c3                   	ret    

00800671 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	57                   	push   %edi
  800675:	56                   	push   %esi
  800676:	53                   	push   %ebx
  800677:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80067a:	e8 ab 30 00 00       	call   80372a <sys_getenvindex>
  80067f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800685:	89 d0                	mov    %edx,%eax
  800687:	c1 e0 03             	shl    $0x3,%eax
  80068a:	01 d0                	add    %edx,%eax
  80068c:	c1 e0 02             	shl    $0x2,%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800698:	01 d0                	add    %edx,%eax
  80069a:	c1 e0 03             	shl    $0x3,%eax
  80069d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a2:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a7:	a1 24 60 80 00       	mov    0x806024,%eax
  8006ac:	8a 40 20             	mov    0x20(%eax),%al
  8006af:	84 c0                	test   %al,%al
  8006b1:	74 0d                	je     8006c0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006b3:	a1 24 60 80 00       	mov    0x806024,%eax
  8006b8:	83 c0 20             	add    $0x20,%eax
  8006bb:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c4:	7e 0a                	jle    8006d0 <libmain+0x5f>
		binaryname = argv[0];
  8006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 5a f9 ff ff       	call   800038 <_main>
  8006de:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006e1:	a1 00 60 80 00       	mov    0x806000,%eax
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	0f 84 01 01 00 00    	je     8007ef <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006ee:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006f4:	bb f8 49 80 00       	mov    $0x8049f8,%ebx
  8006f9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006fe:	89 c7                	mov    %eax,%edi
  800700:	89 de                	mov    %ebx,%esi
  800702:	89 d1                	mov    %edx,%ecx
  800704:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800706:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800709:	b9 56 00 00 00       	mov    $0x56,%ecx
  80070e:	b0 00                	mov    $0x0,%al
  800710:	89 d7                	mov    %edx,%edi
  800712:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800714:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80071b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	50                   	push   %eax
  800722:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800728:	50                   	push   %eax
  800729:	e8 32 32 00 00       	call   803960 <sys_utilities>
  80072e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800731:	e8 7b 2d 00 00       	call   8034b1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800736:	83 ec 0c             	sub    $0xc,%esp
  800739:	68 18 49 80 00       	push   $0x804918
  80073e:	e8 ac 03 00 00       	call   800aef <cprintf>
  800743:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800749:	85 c0                	test   %eax,%eax
  80074b:	74 18                	je     800765 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80074d:	e8 2c 32 00 00       	call   80397e <sys_get_optimal_num_faults>
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	50                   	push   %eax
  800756:	68 40 49 80 00       	push   $0x804940
  80075b:	e8 8f 03 00 00       	call   800aef <cprintf>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	eb 59                	jmp    8007be <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800765:	a1 24 60 80 00       	mov    0x806024,%eax
  80076a:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800770:	a1 24 60 80 00       	mov    0x806024,%eax
  800775:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80077b:	83 ec 04             	sub    $0x4,%esp
  80077e:	52                   	push   %edx
  80077f:	50                   	push   %eax
  800780:	68 64 49 80 00       	push   $0x804964
  800785:	e8 65 03 00 00       	call   800aef <cprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80078d:	a1 24 60 80 00       	mov    0x806024,%eax
  800792:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800798:	a1 24 60 80 00       	mov    0x806024,%eax
  80079d:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8007a3:	a1 24 60 80 00       	mov    0x806024,%eax
  8007a8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007ae:	51                   	push   %ecx
  8007af:	52                   	push   %edx
  8007b0:	50                   	push   %eax
  8007b1:	68 8c 49 80 00       	push   $0x80498c
  8007b6:	e8 34 03 00 00       	call   800aef <cprintf>
  8007bb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007be:	a1 24 60 80 00       	mov    0x806024,%eax
  8007c3:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	50                   	push   %eax
  8007cd:	68 e4 49 80 00       	push   $0x8049e4
  8007d2:	e8 18 03 00 00       	call   800aef <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007da:	83 ec 0c             	sub    $0xc,%esp
  8007dd:	68 18 49 80 00       	push   $0x804918
  8007e2:	e8 08 03 00 00       	call   800aef <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007ea:	e8 dc 2c 00 00       	call   8034cb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007ef:	e8 1f 00 00 00       	call   800813 <exit>
}
  8007f4:	90                   	nop
  8007f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f8:	5b                   	pop    %ebx
  8007f9:	5e                   	pop    %esi
  8007fa:	5f                   	pop    %edi
  8007fb:	5d                   	pop    %ebp
  8007fc:	c3                   	ret    

008007fd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800803:	83 ec 0c             	sub    $0xc,%esp
  800806:	6a 00                	push   $0x0
  800808:	e8 e9 2e 00 00       	call   8036f6 <sys_destroy_env>
  80080d:	83 c4 10             	add    $0x10,%esp
}
  800810:	90                   	nop
  800811:	c9                   	leave  
  800812:	c3                   	ret    

00800813 <exit>:

void
exit(void)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800819:	e8 3e 2f 00 00       	call   80375c <sys_exit_env>
}
  80081e:	90                   	nop
  80081f:	c9                   	leave  
  800820:	c3                   	ret    

00800821 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800827:	8d 45 10             	lea    0x10(%ebp),%eax
  80082a:	83 c0 04             	add    $0x4,%eax
  80082d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800830:	a1 38 61 83 00       	mov    0x836138,%eax
  800835:	85 c0                	test   %eax,%eax
  800837:	74 16                	je     80084f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800839:	a1 38 61 83 00       	mov    0x836138,%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	50                   	push   %eax
  800842:	68 5c 4a 80 00       	push   $0x804a5c
  800847:	e8 a3 02 00 00       	call   800aef <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80084f:	a1 04 60 80 00       	mov    0x806004,%eax
  800854:	83 ec 0c             	sub    $0xc,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	50                   	push   %eax
  80085e:	68 64 4a 80 00       	push   $0x804a64
  800863:	6a 74                	push   $0x74
  800865:	e8 b2 02 00 00       	call   800b1c <cprintf_colored>
  80086a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 f4             	pushl  -0xc(%ebp)
  800876:	50                   	push   %eax
  800877:	e8 04 02 00 00       	call   800a80 <vcprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80087f:	83 ec 08             	sub    $0x8,%esp
  800882:	6a 00                	push   $0x0
  800884:	68 8c 4a 80 00       	push   $0x804a8c
  800889:	e8 f2 01 00 00       	call   800a80 <vcprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800891:	e8 7d ff ff ff       	call   800813 <exit>

	// should not return here
	while (1) ;
  800896:	eb fe                	jmp    800896 <_panic+0x75>

00800898 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80089e:	a1 24 60 80 00       	mov    0x806024,%eax
  8008a3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ac:	39 c2                	cmp    %eax,%edx
  8008ae:	74 14                	je     8008c4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008b0:	83 ec 04             	sub    $0x4,%esp
  8008b3:	68 90 4a 80 00       	push   $0x804a90
  8008b8:	6a 26                	push   $0x26
  8008ba:	68 dc 4a 80 00       	push   $0x804adc
  8008bf:	e8 5d ff ff ff       	call   800821 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d2:	e9 c5 00 00 00       	jmp    80099c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	01 d0                	add    %edx,%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	85 c0                	test   %eax,%eax
  8008ea:	75 08                	jne    8008f4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8008ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008ef:	e9 a5 00 00 00       	jmp    800999 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800902:	eb 69                	jmp    80096d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800904:	a1 24 60 80 00       	mov    0x806024,%eax
  800909:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80090f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800912:	89 d0                	mov    %edx,%eax
  800914:	01 c0                	add    %eax,%eax
  800916:	01 d0                	add    %edx,%eax
  800918:	c1 e0 03             	shl    $0x3,%eax
  80091b:	01 c8                	add    %ecx,%eax
  80091d:	8a 40 04             	mov    0x4(%eax),%al
  800920:	84 c0                	test   %al,%al
  800922:	75 46                	jne    80096a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800924:	a1 24 60 80 00       	mov    0x806024,%eax
  800929:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80092f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 03             	shl    $0x3,%eax
  80093b:	01 c8                	add    %ecx,%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800942:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800945:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80094a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80094c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	01 c8                	add    %ecx,%eax
  80095b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80095d:	39 c2                	cmp    %eax,%edx
  80095f:	75 09                	jne    80096a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800961:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800968:	eb 15                	jmp    80097f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096a:	ff 45 e8             	incl   -0x18(%ebp)
  80096d:	a1 24 60 80 00       	mov    0x806024,%eax
  800972:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	77 85                	ja     800904 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80097f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800983:	75 14                	jne    800999 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 e8 4a 80 00       	push   $0x804ae8
  80098d:	6a 3a                	push   $0x3a
  80098f:	68 dc 4a 80 00       	push   $0x804adc
  800994:	e8 88 fe ff ff       	call   800821 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800999:	ff 45 f0             	incl   -0x10(%ebp)
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009a2:	0f 8c 2f ff ff ff    	jl     8008d7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b6:	eb 26                	jmp    8009de <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009b8:	a1 24 60 80 00       	mov    0x806024,%eax
  8009bd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c6:	89 d0                	mov    %edx,%eax
  8009c8:	01 c0                	add    %eax,%eax
  8009ca:	01 d0                	add    %edx,%eax
  8009cc:	c1 e0 03             	shl    $0x3,%eax
  8009cf:	01 c8                	add    %ecx,%eax
  8009d1:	8a 40 04             	mov    0x4(%eax),%al
  8009d4:	3c 01                	cmp    $0x1,%al
  8009d6:	75 03                	jne    8009db <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009db:	ff 45 e0             	incl   -0x20(%ebp)
  8009de:	a1 24 60 80 00       	mov    0x806024,%eax
  8009e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 c8                	ja     8009b8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009f6:	74 14                	je     800a0c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009f8:	83 ec 04             	sub    $0x4,%esp
  8009fb:	68 3c 4b 80 00       	push   $0x804b3c
  800a00:	6a 44                	push   $0x44
  800a02:	68 dc 4a 80 00       	push   $0x804adc
  800a07:	e8 15 fe ff ff       	call   800821 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a0c:	90                   	nop
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    

00800a0f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	53                   	push   %ebx
  800a13:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a21:	89 0a                	mov    %ecx,(%edx)
  800a23:	8b 55 08             	mov    0x8(%ebp),%edx
  800a26:	88 d1                	mov    %dl,%cl
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a32:	8b 00                	mov    (%eax),%eax
  800a34:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a39:	75 30                	jne    800a6b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800a3b:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800a41:	a0 64 e0 81 00       	mov    0x81e064,%al
  800a46:	0f b6 c0             	movzbl %al,%eax
  800a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4c:	8b 09                	mov    (%ecx),%ecx
  800a4e:	89 cb                	mov    %ecx,%ebx
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a53:	83 c1 08             	add    $0x8,%ecx
  800a56:	52                   	push   %edx
  800a57:	50                   	push   %eax
  800a58:	53                   	push   %ebx
  800a59:	51                   	push   %ecx
  800a5a:	e8 0e 2a 00 00       	call   80346d <sys_cputs>
  800a5f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6e:	8b 40 04             	mov    0x4(%eax),%eax
  800a71:	8d 50 01             	lea    0x1(%eax),%edx
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a7a:	90                   	nop
  800a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a89:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a90:	00 00 00 
	b.cnt = 0;
  800a93:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a9a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	ff 75 08             	pushl  0x8(%ebp)
  800aa3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	68 0f 0a 80 00       	push   $0x800a0f
  800aaf:	e8 5a 02 00 00       	call   800d0e <vprintfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800ab7:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800abd:	a0 64 e0 81 00       	mov    0x81e064,%al
  800ac2:	0f b6 c0             	movzbl %al,%eax
  800ac5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800acb:	52                   	push   %edx
  800acc:	50                   	push   %eax
  800acd:	51                   	push   %ecx
  800ace:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ad4:	83 c0 08             	add    $0x8,%eax
  800ad7:	50                   	push   %eax
  800ad8:	e8 90 29 00 00       	call   80346d <sys_cputs>
  800add:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ae0:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800ae7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800af5:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800afc:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0b:	50                   	push   %eax
  800b0c:	e8 6f ff ff ff       	call   800a80 <vcprintf>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b22:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	c1 e0 08             	shl    $0x8,%eax
  800b2f:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800b34:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b37:	83 c0 04             	add    $0x4,%eax
  800b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 f4             	pushl  -0xc(%ebp)
  800b46:	50                   	push   %eax
  800b47:	e8 34 ff ff ff       	call   800a80 <vcprintf>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b52:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800b59:	07 00 00 

	return cnt;
  800b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b67:	e8 45 29 00 00       	call   8034b1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7b:	50                   	push   %eax
  800b7c:	e8 ff fe ff ff       	call   800a80 <vcprintf>
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b87:	e8 3f 29 00 00       	call   8034cb <sys_unlock_cons>
	return cnt;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	53                   	push   %ebx
  800b95:	83 ec 14             	sub    $0x14,%esp
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ba4:	8b 45 18             	mov    0x18(%ebp),%eax
  800ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800baf:	77 55                	ja     800c06 <printnum+0x75>
  800bb1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bb4:	72 05                	jb     800bbb <printnum+0x2a>
  800bb6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bb9:	77 4b                	ja     800c06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bbb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bbe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	52                   	push   %edx
  800bca:	50                   	push   %eax
  800bcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bce:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd1:	e8 1e 39 00 00       	call   8044f4 <__udivdi3>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	83 ec 04             	sub    $0x4,%esp
  800bdc:	ff 75 20             	pushl  0x20(%ebp)
  800bdf:	53                   	push   %ebx
  800be0:	ff 75 18             	pushl  0x18(%ebp)
  800be3:	52                   	push   %edx
  800be4:	50                   	push   %eax
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	ff 75 08             	pushl  0x8(%ebp)
  800beb:	e8 a1 ff ff ff       	call   800b91 <printnum>
  800bf0:	83 c4 20             	add    $0x20,%esp
  800bf3:	eb 1a                	jmp    800c0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	ff 75 20             	pushl  0x20(%ebp)
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c06:	ff 4d 1c             	decl   0x1c(%ebp)
  800c09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c0d:	7f e6                	jg     800bf5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1d:	53                   	push   %ebx
  800c1e:	51                   	push   %ecx
  800c1f:	52                   	push   %edx
  800c20:	50                   	push   %eax
  800c21:	e8 de 39 00 00       	call   804604 <__umoddi3>
  800c26:	83 c4 10             	add    $0x10,%esp
  800c29:	05 b4 4d 80 00       	add    $0x804db4,%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	0f be c0             	movsbl %al,%eax
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	50                   	push   %eax
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
}
  800c42:	90                   	nop
  800c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c4f:	7e 1c                	jle    800c6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8b 00                	mov    (%eax),%eax
  800c56:	8d 50 08             	lea    0x8(%eax),%edx
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 10                	mov    %edx,(%eax)
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	83 e8 08             	sub    $0x8,%eax
  800c66:	8b 50 04             	mov    0x4(%eax),%edx
  800c69:	8b 00                	mov    (%eax),%eax
  800c6b:	eb 40                	jmp    800cad <getuint+0x65>
	else if (lflag)
  800c6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c71:	74 1e                	je     800c91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	8d 50 04             	lea    0x4(%eax),%edx
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	89 10                	mov    %edx,(%eax)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	83 e8 04             	sub    $0x4,%eax
  800c88:	8b 00                	mov    (%eax),%eax
  800c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8f:	eb 1c                	jmp    800cad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8b 00                	mov    (%eax),%eax
  800c96:	8d 50 04             	lea    0x4(%eax),%edx
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	89 10                	mov    %edx,(%eax)
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	83 e8 04             	sub    $0x4,%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cb6:	7e 1c                	jle    800cd4 <getint+0x25>
		return va_arg(*ap, long long);
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	8d 50 08             	lea    0x8(%eax),%edx
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 10                	mov    %edx,(%eax)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8b 00                	mov    (%eax),%eax
  800cca:	83 e8 08             	sub    $0x8,%eax
  800ccd:	8b 50 04             	mov    0x4(%eax),%edx
  800cd0:	8b 00                	mov    (%eax),%eax
  800cd2:	eb 38                	jmp    800d0c <getint+0x5d>
	else if (lflag)
  800cd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd8:	74 1a                	je     800cf4 <getint+0x45>
		return va_arg(*ap, long);
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8b 00                	mov    (%eax),%eax
  800cdf:	8d 50 04             	lea    0x4(%eax),%edx
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	89 10                	mov    %edx,(%eax)
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	83 e8 04             	sub    $0x4,%eax
  800cef:	8b 00                	mov    (%eax),%eax
  800cf1:	99                   	cltd   
  800cf2:	eb 18                	jmp    800d0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	99                   	cltd   
}
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d16:	eb 17                	jmp    800d2f <vprintfmt+0x21>
			if (ch == '\0')
  800d18:	85 db                	test   %ebx,%ebx
  800d1a:	0f 84 c1 03 00 00    	je     8010e1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	53                   	push   %ebx
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 10             	mov    %edx,0x10(%ebp)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d8             	movzbl %al,%ebx
  800d3d:	83 fb 25             	cmp    $0x25,%ebx
  800d40:	75 d6                	jne    800d18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d62:	8b 45 10             	mov    0x10(%ebp),%eax
  800d65:	8d 50 01             	lea    0x1(%eax),%edx
  800d68:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d8             	movzbl %al,%ebx
  800d70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d73:	83 f8 5b             	cmp    $0x5b,%eax
  800d76:	0f 87 3d 03 00 00    	ja     8010b9 <vprintfmt+0x3ab>
  800d7c:	8b 04 85 d8 4d 80 00 	mov    0x804dd8(,%eax,4),%eax
  800d83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d89:	eb d7                	jmp    800d62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d8f:	eb d1                	jmp    800d62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d9b:	89 d0                	mov    %edx,%eax
  800d9d:	c1 e0 02             	shl    $0x2,%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	01 c0                	add    %eax,%eax
  800da4:	01 d8                	add    %ebx,%eax
  800da6:	83 e8 30             	sub    $0x30,%eax
  800da9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dac:	8b 45 10             	mov    0x10(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800db4:	83 fb 2f             	cmp    $0x2f,%ebx
  800db7:	7e 3e                	jle    800df7 <vprintfmt+0xe9>
  800db9:	83 fb 39             	cmp    $0x39,%ebx
  800dbc:	7f 39                	jg     800df7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dc1:	eb d5                	jmp    800d98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc6:	83 c0 04             	add    $0x4,%eax
  800dc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcf:	83 e8 04             	sub    $0x4,%eax
  800dd2:	8b 00                	mov    (%eax),%eax
  800dd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dd7:	eb 1f                	jmp    800df8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ddd:	79 83                	jns    800d62 <vprintfmt+0x54>
				width = 0;
  800ddf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800de6:	e9 77 ff ff ff       	jmp    800d62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800deb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800df2:	e9 6b ff ff ff       	jmp    800d62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800df7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800df8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfc:	0f 89 60 ff ff ff    	jns    800d62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e0f:	e9 4e ff ff ff       	jmp    800d62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e17:	e9 46 ff ff ff       	jmp    800d62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1f:	83 c0 04             	add    $0x4,%eax
  800e22:	89 45 14             	mov    %eax,0x14(%ebp)
  800e25:	8b 45 14             	mov    0x14(%ebp),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	50                   	push   %eax
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 9b 02 00 00       	jmp    8010dc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e41:	8b 45 14             	mov    0x14(%ebp),%eax
  800e44:	83 c0 04             	add    $0x4,%eax
  800e47:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4d:	83 e8 04             	sub    $0x4,%eax
  800e50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e52:	85 db                	test   %ebx,%ebx
  800e54:	79 02                	jns    800e58 <vprintfmt+0x14a>
				err = -err;
  800e56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e58:	83 fb 64             	cmp    $0x64,%ebx
  800e5b:	7f 0b                	jg     800e68 <vprintfmt+0x15a>
  800e5d:	8b 34 9d 20 4c 80 00 	mov    0x804c20(,%ebx,4),%esi
  800e64:	85 f6                	test   %esi,%esi
  800e66:	75 19                	jne    800e81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e68:	53                   	push   %ebx
  800e69:	68 c5 4d 80 00       	push   $0x804dc5
  800e6e:	ff 75 0c             	pushl  0xc(%ebp)
  800e71:	ff 75 08             	pushl  0x8(%ebp)
  800e74:	e8 70 02 00 00       	call   8010e9 <printfmt>
  800e79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e7c:	e9 5b 02 00 00       	jmp    8010dc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e81:	56                   	push   %esi
  800e82:	68 ce 4d 80 00       	push   $0x804dce
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	ff 75 08             	pushl  0x8(%ebp)
  800e8d:	e8 57 02 00 00       	call   8010e9 <printfmt>
  800e92:	83 c4 10             	add    $0x10,%esp
			break;
  800e95:	e9 42 02 00 00       	jmp    8010dc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9d:	83 c0 04             	add    $0x4,%eax
  800ea0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea6:	83 e8 04             	sub    $0x4,%eax
  800ea9:	8b 30                	mov    (%eax),%esi
  800eab:	85 f6                	test   %esi,%esi
  800ead:	75 05                	jne    800eb4 <vprintfmt+0x1a6>
				p = "(null)";
  800eaf:	be d1 4d 80 00       	mov    $0x804dd1,%esi
			if (width > 0 && padc != '-')
  800eb4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb8:	7e 6d                	jle    800f27 <vprintfmt+0x219>
  800eba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ebe:	74 67                	je     800f27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec3:	83 ec 08             	sub    $0x8,%esp
  800ec6:	50                   	push   %eax
  800ec7:	56                   	push   %esi
  800ec8:	e8 26 05 00 00       	call   8013f3 <strnlen>
  800ecd:	83 c4 10             	add    $0x10,%esp
  800ed0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ed3:	eb 16                	jmp    800eeb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ed5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	50                   	push   %eax
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	ff d0                	call   *%eax
  800ee5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee8:	ff 4d e4             	decl   -0x1c(%ebp)
  800eeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eef:	7f e4                	jg     800ed5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef1:	eb 34                	jmp    800f27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ef3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ef7:	74 1c                	je     800f15 <vprintfmt+0x207>
  800ef9:	83 fb 1f             	cmp    $0x1f,%ebx
  800efc:	7e 05                	jle    800f03 <vprintfmt+0x1f5>
  800efe:	83 fb 7e             	cmp    $0x7e,%ebx
  800f01:	7e 12                	jle    800f15 <vprintfmt+0x207>
					putch('?', putdat);
  800f03:	83 ec 08             	sub    $0x8,%esp
  800f06:	ff 75 0c             	pushl  0xc(%ebp)
  800f09:	6a 3f                	push   $0x3f
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	ff d0                	call   *%eax
  800f10:	83 c4 10             	add    $0x10,%esp
  800f13:	eb 0f                	jmp    800f24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	53                   	push   %ebx
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f24:	ff 4d e4             	decl   -0x1c(%ebp)
  800f27:	89 f0                	mov    %esi,%eax
  800f29:	8d 70 01             	lea    0x1(%eax),%esi
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	0f be d8             	movsbl %al,%ebx
  800f31:	85 db                	test   %ebx,%ebx
  800f33:	74 24                	je     800f59 <vprintfmt+0x24b>
  800f35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f39:	78 b8                	js     800ef3 <vprintfmt+0x1e5>
  800f3b:	ff 4d e0             	decl   -0x20(%ebp)
  800f3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f42:	79 af                	jns    800ef3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f44:	eb 13                	jmp    800f59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f46:	83 ec 08             	sub    $0x8,%esp
  800f49:	ff 75 0c             	pushl  0xc(%ebp)
  800f4c:	6a 20                	push   $0x20
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	ff d0                	call   *%eax
  800f53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f56:	ff 4d e4             	decl   -0x1c(%ebp)
  800f59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f5d:	7f e7                	jg     800f46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f5f:	e9 78 01 00 00       	jmp    8010dc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f64:	83 ec 08             	sub    $0x8,%esp
  800f67:	ff 75 e8             	pushl  -0x18(%ebp)
  800f6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6d:	50                   	push   %eax
  800f6e:	e8 3c fd ff ff       	call   800caf <getint>
  800f73:	83 c4 10             	add    $0x10,%esp
  800f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f82:	85 d2                	test   %edx,%edx
  800f84:	79 23                	jns    800fa9 <vprintfmt+0x29b>
				putch('-', putdat);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	6a 2d                	push   $0x2d
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	ff d0                	call   *%eax
  800f93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9c:	f7 d8                	neg    %eax
  800f9e:	83 d2 00             	adc    $0x0,%edx
  800fa1:	f7 da                	neg    %edx
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fa9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fb0:	e9 bc 00 00 00       	jmp    801071 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800fbb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fbe:	50                   	push   %eax
  800fbf:	e8 84 fc ff ff       	call   800c48 <getuint>
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fcd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fd4:	e9 98 00 00 00       	jmp    801071 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fd9:	83 ec 08             	sub    $0x8,%esp
  800fdc:	ff 75 0c             	pushl  0xc(%ebp)
  800fdf:	6a 58                	push   $0x58
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	ff d0                	call   *%eax
  800fe6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fe9:	83 ec 08             	sub    $0x8,%esp
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	6a 58                	push   $0x58
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	ff d0                	call   *%eax
  800ff6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 58                	push   $0x58
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
			break;
  801009:	e9 ce 00 00 00       	jmp    8010dc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	6a 30                	push   $0x30
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	ff d0                	call   *%eax
  80101b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	6a 78                	push   $0x78
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	ff d0                	call   *%eax
  80102b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 14             	mov    %eax,0x14(%ebp)
  801037:	8b 45 14             	mov    0x14(%ebp),%eax
  80103a:	83 e8 04             	sub    $0x4,%eax
  80103d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80103f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801049:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801050:	eb 1f                	jmp    801071 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801052:	83 ec 08             	sub    $0x8,%esp
  801055:	ff 75 e8             	pushl  -0x18(%ebp)
  801058:	8d 45 14             	lea    0x14(%ebp),%eax
  80105b:	50                   	push   %eax
  80105c:	e8 e7 fb ff ff       	call   800c48 <getuint>
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801067:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80106a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801071:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801078:	83 ec 04             	sub    $0x4,%esp
  80107b:	52                   	push   %edx
  80107c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80107f:	50                   	push   %eax
  801080:	ff 75 f4             	pushl  -0xc(%ebp)
  801083:	ff 75 f0             	pushl  -0x10(%ebp)
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	ff 75 08             	pushl  0x8(%ebp)
  80108c:	e8 00 fb ff ff       	call   800b91 <printnum>
  801091:	83 c4 20             	add    $0x20,%esp
			break;
  801094:	eb 46                	jmp    8010dc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801096:	83 ec 08             	sub    $0x8,%esp
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	53                   	push   %ebx
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	ff d0                	call   *%eax
  8010a2:	83 c4 10             	add    $0x10,%esp
			break;
  8010a5:	eb 35                	jmp    8010dc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010a7:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  8010ae:	eb 2c                	jmp    8010dc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010b0:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  8010b7:	eb 23                	jmp    8010dc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010b9:	83 ec 08             	sub    $0x8,%esp
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	6a 25                	push   $0x25
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	ff d0                	call   *%eax
  8010c6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010c9:	ff 4d 10             	decl   0x10(%ebp)
  8010cc:	eb 03                	jmp    8010d1 <vprintfmt+0x3c3>
  8010ce:	ff 4d 10             	decl   0x10(%ebp)
  8010d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d4:	48                   	dec    %eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 25                	cmp    $0x25,%al
  8010d9:	75 f3                	jne    8010ce <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010db:	90                   	nop
		}
	}
  8010dc:	e9 35 fc ff ff       	jmp    800d16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010e1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f2:	83 c0 04             	add    $0x4,%eax
  8010f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010fe:	50                   	push   %eax
  8010ff:	ff 75 0c             	pushl  0xc(%ebp)
  801102:	ff 75 08             	pushl  0x8(%ebp)
  801105:	e8 04 fc ff ff       	call   800d0e <vprintfmt>
  80110a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	8b 40 08             	mov    0x8(%eax),%eax
  801119:	8d 50 01             	lea    0x1(%eax),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	8b 10                	mov    (%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	8b 40 04             	mov    0x4(%eax),%eax
  80112d:	39 c2                	cmp    %eax,%edx
  80112f:	73 12                	jae    801143 <sprintputch+0x33>
		*b->buf++ = ch;
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8b 00                	mov    (%eax),%eax
  801136:	8d 48 01             	lea    0x1(%eax),%ecx
  801139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113c:	89 0a                	mov    %ecx,(%edx)
  80113e:	8b 55 08             	mov    0x8(%ebp),%edx
  801141:	88 10                	mov    %dl,(%eax)
}
  801143:	90                   	nop
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8d 50 ff             	lea    -0x1(%eax),%edx
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
  80115d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801160:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801167:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116b:	74 06                	je     801173 <vsnprintf+0x2d>
  80116d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801171:	7f 07                	jg     80117a <vsnprintf+0x34>
		return -E_INVAL;
  801173:	b8 03 00 00 00       	mov    $0x3,%eax
  801178:	eb 20                	jmp    80119a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80117a:	ff 75 14             	pushl  0x14(%ebp)
  80117d:	ff 75 10             	pushl  0x10(%ebp)
  801180:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801183:	50                   	push   %eax
  801184:	68 10 11 80 00       	push   $0x801110
  801189:	e8 80 fb ff ff       	call   800d0e <vprintfmt>
  80118e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801194:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801197:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8011a5:	83 c0 04             	add    $0x4,%eax
  8011a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b1:	50                   	push   %eax
  8011b2:	ff 75 0c             	pushl  0xc(%ebp)
  8011b5:	ff 75 08             	pushl  0x8(%ebp)
  8011b8:	e8 89 ff ff ff       	call   801146 <vsnprintf>
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d2:	74 13                	je     8011e7 <readline+0x1f>
		cprintf("%s", prompt);
  8011d4:	83 ec 08             	sub    $0x8,%esp
  8011d7:	ff 75 08             	pushl  0x8(%ebp)
  8011da:	68 48 4f 80 00       	push   $0x804f48
  8011df:	e8 0b f9 ff ff       	call   800aef <cprintf>
  8011e4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	6a 00                	push   $0x0
  8011f3:	e8 6f f4 ff ff       	call   800667 <iscons>
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011fe:	e8 51 f4 ff ff       	call   800654 <getchar>
  801203:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801206:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120a:	79 22                	jns    80122e <readline+0x66>
			if (c != -E_EOF)
  80120c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801210:	0f 84 ad 00 00 00    	je     8012c3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	ff 75 ec             	pushl  -0x14(%ebp)
  80121c:	68 4b 4f 80 00       	push   $0x804f4b
  801221:	e8 c9 f8 ff ff       	call   800aef <cprintf>
  801226:	83 c4 10             	add    $0x10,%esp
			break;
  801229:	e9 95 00 00 00       	jmp    8012c3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80122e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801232:	7e 34                	jle    801268 <readline+0xa0>
  801234:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123b:	7f 2b                	jg     801268 <readline+0xa0>
			if (echoing)
  80123d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801241:	74 0e                	je     801251 <readline+0x89>
				cputchar(c);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	ff 75 ec             	pushl  -0x14(%ebp)
  801249:	e8 e7 f3 ff ff       	call   800635 <cputchar>
  80124e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801254:	8d 50 01             	lea    0x1(%eax),%edx
  801257:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125a:	89 c2                	mov    %eax,%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801264:	88 10                	mov    %dl,(%eax)
  801266:	eb 56                	jmp    8012be <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801268:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126c:	75 1f                	jne    80128d <readline+0xc5>
  80126e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801272:	7e 19                	jle    80128d <readline+0xc5>
			if (echoing)
  801274:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801278:	74 0e                	je     801288 <readline+0xc0>
				cputchar(c);
  80127a:	83 ec 0c             	sub    $0xc,%esp
  80127d:	ff 75 ec             	pushl  -0x14(%ebp)
  801280:	e8 b0 f3 ff ff       	call   800635 <cputchar>
  801285:	83 c4 10             	add    $0x10,%esp

			i--;
  801288:	ff 4d f4             	decl   -0xc(%ebp)
  80128b:	eb 31                	jmp    8012be <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80128d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801291:	74 0a                	je     80129d <readline+0xd5>
  801293:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801297:	0f 85 61 ff ff ff    	jne    8011fe <readline+0x36>
			if (echoing)
  80129d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a1:	74 0e                	je     8012b1 <readline+0xe9>
				cputchar(c);
  8012a3:	83 ec 0c             	sub    $0xc,%esp
  8012a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a9:	e8 87 f3 ff ff       	call   800635 <cputchar>
  8012ae:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012bc:	eb 06                	jmp    8012c4 <readline+0xfc>
		}
	}
  8012be:	e9 3b ff ff ff       	jmp    8011fe <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012c3:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012c4:	90                   	nop
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012cd:	e8 df 21 00 00       	call   8034b1 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d6:	74 13                	je     8012eb <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	ff 75 08             	pushl  0x8(%ebp)
  8012de:	68 48 4f 80 00       	push   $0x804f48
  8012e3:	e8 07 f8 ff ff       	call   800aef <cprintf>
  8012e8:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012f2:	83 ec 0c             	sub    $0xc,%esp
  8012f5:	6a 00                	push   $0x0
  8012f7:	e8 6b f3 ff ff       	call   800667 <iscons>
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801302:	e8 4d f3 ff ff       	call   800654 <getchar>
  801307:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80130a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80130e:	79 22                	jns    801332 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801310:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801314:	0f 84 ad 00 00 00    	je     8013c7 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	ff 75 ec             	pushl  -0x14(%ebp)
  801320:	68 4b 4f 80 00       	push   $0x804f4b
  801325:	e8 c5 f7 ff ff       	call   800aef <cprintf>
  80132a:	83 c4 10             	add    $0x10,%esp
				break;
  80132d:	e9 95 00 00 00       	jmp    8013c7 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801332:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801336:	7e 34                	jle    80136c <atomic_readline+0xa5>
  801338:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80133f:	7f 2b                	jg     80136c <atomic_readline+0xa5>
				if (echoing)
  801341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801345:	74 0e                	je     801355 <atomic_readline+0x8e>
					cputchar(c);
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	ff 75 ec             	pushl  -0x14(%ebp)
  80134d:	e8 e3 f2 ff ff       	call   800635 <cputchar>
  801352:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801358:	8d 50 01             	lea    0x1(%eax),%edx
  80135b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80135e:	89 c2                	mov    %eax,%edx
  801360:	8b 45 0c             	mov    0xc(%ebp),%eax
  801363:	01 d0                	add    %edx,%eax
  801365:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801368:	88 10                	mov    %dl,(%eax)
  80136a:	eb 56                	jmp    8013c2 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80136c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801370:	75 1f                	jne    801391 <atomic_readline+0xca>
  801372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801376:	7e 19                	jle    801391 <atomic_readline+0xca>
				if (echoing)
  801378:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80137c:	74 0e                	je     80138c <atomic_readline+0xc5>
					cputchar(c);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	ff 75 ec             	pushl  -0x14(%ebp)
  801384:	e8 ac f2 ff ff       	call   800635 <cputchar>
  801389:	83 c4 10             	add    $0x10,%esp
				i--;
  80138c:	ff 4d f4             	decl   -0xc(%ebp)
  80138f:	eb 31                	jmp    8013c2 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801391:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801395:	74 0a                	je     8013a1 <atomic_readline+0xda>
  801397:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80139b:	0f 85 61 ff ff ff    	jne    801302 <atomic_readline+0x3b>
				if (echoing)
  8013a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013a5:	74 0e                	je     8013b5 <atomic_readline+0xee>
					cputchar(c);
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ad:	e8 83 f2 ff ff       	call   800635 <cputchar>
  8013b2:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	01 d0                	add    %edx,%eax
  8013bd:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013c0:	eb 06                	jmp    8013c8 <atomic_readline+0x101>
			}
		}
  8013c2:	e9 3b ff ff ff       	jmp    801302 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013c7:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013c8:	e8 fe 20 00 00       	call   8034cb <sys_unlock_cons>
}
  8013cd:	90                   	nop
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013dd:	eb 06                	jmp    8013e5 <strlen+0x15>
		n++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e2:	ff 45 08             	incl   0x8(%ebp)
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	84 c0                	test   %al,%al
  8013ec:	75 f1                	jne    8013df <strlen+0xf>
		n++;
	return n;
  8013ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801400:	eb 09                	jmp    80140b <strnlen+0x18>
		n++;
  801402:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801405:	ff 45 08             	incl   0x8(%ebp)
  801408:	ff 4d 0c             	decl   0xc(%ebp)
  80140b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140f:	74 09                	je     80141a <strnlen+0x27>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	84 c0                	test   %al,%al
  801418:	75 e8                	jne    801402 <strnlen+0xf>
		n++;
	return n;
  80141a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80142b:	90                   	nop
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8d 50 01             	lea    0x1(%eax),%edx
  801432:	89 55 08             	mov    %edx,0x8(%ebp)
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80143e:	8a 12                	mov    (%edx),%dl
  801440:	88 10                	mov    %dl,(%eax)
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 e4                	jne    80142c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801448:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801460:	eb 1f                	jmp    801481 <strncpy+0x34>
		*dst++ = *src;
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8d 50 01             	lea    0x1(%eax),%edx
  801468:	89 55 08             	mov    %edx,0x8(%ebp)
  80146b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146e:	8a 12                	mov    (%edx),%dl
  801470:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	84 c0                	test   %al,%al
  801479:	74 03                	je     80147e <strncpy+0x31>
			src++;
  80147b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80147e:	ff 45 fc             	incl   -0x4(%ebp)
  801481:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801484:	3b 45 10             	cmp    0x10(%ebp),%eax
  801487:	72 d9                	jb     801462 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801489:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80149a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149e:	74 30                	je     8014d0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a0:	eb 16                	jmp    8014b8 <strlcpy+0x2a>
			*dst++ = *src++;
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8d 50 01             	lea    0x1(%eax),%edx
  8014a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014b4:	8a 12                	mov    (%edx),%dl
  8014b6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014b8:	ff 4d 10             	decl   0x10(%ebp)
  8014bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bf:	74 09                	je     8014ca <strlcpy+0x3c>
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	84 c0                	test   %al,%al
  8014c8:	75 d8                	jne    8014a2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d6:	29 c2                	sub    %eax,%edx
  8014d8:	89 d0                	mov    %edx,%eax
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014df:	eb 06                	jmp    8014e7 <strcmp+0xb>
		p++, q++;
  8014e1:	ff 45 08             	incl   0x8(%ebp)
  8014e4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	84 c0                	test   %al,%al
  8014ee:	74 0e                	je     8014fe <strcmp+0x22>
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 10                	mov    (%eax),%dl
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	38 c2                	cmp    %al,%dl
  8014fc:	74 e3                	je     8014e1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	0f b6 d0             	movzbl %al,%edx
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	0f b6 c0             	movzbl %al,%eax
  80150e:	29 c2                	sub    %eax,%edx
  801510:	89 d0                	mov    %edx,%eax
}
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801517:	eb 09                	jmp    801522 <strncmp+0xe>
		n--, p++, q++;
  801519:	ff 4d 10             	decl   0x10(%ebp)
  80151c:	ff 45 08             	incl   0x8(%ebp)
  80151f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801522:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801526:	74 17                	je     80153f <strncmp+0x2b>
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8a 00                	mov    (%eax),%al
  80152d:	84 c0                	test   %al,%al
  80152f:	74 0e                	je     80153f <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 10                	mov    (%eax),%dl
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	38 c2                	cmp    %al,%dl
  80153d:	74 da                	je     801519 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80153f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801543:	75 07                	jne    80154c <strncmp+0x38>
		return 0;
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
  80154a:	eb 14                	jmp    801560 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f b6 d0             	movzbl %al,%edx
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	0f b6 c0             	movzbl %al,%eax
  80155c:	29 c2                	sub    %eax,%edx
  80155e:	89 d0                	mov    %edx,%eax
}
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    

00801562 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80156e:	eb 12                	jmp    801582 <strchr+0x20>
		if (*s == c)
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801578:	75 05                	jne    80157f <strchr+0x1d>
			return (char *) s;
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	eb 11                	jmp    801590 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80157f:	ff 45 08             	incl   0x8(%ebp)
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	84 c0                	test   %al,%al
  801589:	75 e5                	jne    801570 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80159e:	eb 0d                	jmp    8015ad <strfind+0x1b>
		if (*s == c)
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015a8:	74 0e                	je     8015b8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015aa:	ff 45 08             	incl   0x8(%ebp)
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	84 c0                	test   %al,%al
  8015b4:	75 ea                	jne    8015a0 <strfind+0xe>
  8015b6:	eb 01                	jmp    8015b9 <strfind+0x27>
		if (*s == c)
			break;
  8015b8:	90                   	nop
	return (char *) s;
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8015ca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015ce:	76 63                	jbe    801633 <memset+0x75>
		uint64 data_block = c;
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	99                   	cltd   
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8015da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8015e4:	c1 e0 08             	shl    $0x8,%eax
  8015e7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015ea:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8015ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8015f7:	c1 e0 10             	shl    $0x10,%eax
  8015fa:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015fd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801606:	89 c2                	mov    %eax,%edx
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
  80160d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801610:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801613:	eb 18                	jmp    80162d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801615:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801618:	8d 41 08             	lea    0x8(%ecx),%eax
  80161b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801624:	89 01                	mov    %eax,(%ecx)
  801626:	89 51 04             	mov    %edx,0x4(%ecx)
  801629:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80162d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801631:	77 e2                	ja     801615 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801633:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801637:	74 23                	je     80165c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801639:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80163f:	eb 0e                	jmp    80164f <memset+0x91>
			*p8++ = (uint8)c;
  801641:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801644:	8d 50 01             	lea    0x1(%eax),%edx
  801647:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80164f:	8b 45 10             	mov    0x10(%ebp),%eax
  801652:	8d 50 ff             	lea    -0x1(%eax),%edx
  801655:	89 55 10             	mov    %edx,0x10(%ebp)
  801658:	85 c0                	test   %eax,%eax
  80165a:	75 e5                	jne    801641 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801673:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801677:	76 24                	jbe    80169d <memcpy+0x3c>
		while(n >= 8){
  801679:	eb 1c                	jmp    801697 <memcpy+0x36>
			*d64 = *s64;
  80167b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167e:	8b 50 04             	mov    0x4(%eax),%edx
  801681:	8b 00                	mov    (%eax),%eax
  801683:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801686:	89 01                	mov    %eax,(%ecx)
  801688:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80168b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80168f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801693:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801697:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80169b:	77 de                	ja     80167b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80169d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a1:	74 31                	je     8016d4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8016a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8016a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8016af:	eb 16                	jmp    8016c7 <memcpy+0x66>
			*d8++ = *s8++;
  8016b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b4:	8d 50 01             	lea    0x1(%eax),%edx
  8016b7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8016ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8016c3:	8a 12                	mov    (%edx),%dl
  8016c5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	75 dd                	jne    8016b1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016f1:	73 50                	jae    801743 <memmove+0x6a>
  8016f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f9:	01 d0                	add    %edx,%eax
  8016fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016fe:	76 43                	jbe    801743 <memmove+0x6a>
		s += n;
  801700:	8b 45 10             	mov    0x10(%ebp),%eax
  801703:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801706:	8b 45 10             	mov    0x10(%ebp),%eax
  801709:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80170c:	eb 10                	jmp    80171e <memmove+0x45>
			*--d = *--s;
  80170e:	ff 4d f8             	decl   -0x8(%ebp)
  801711:	ff 4d fc             	decl   -0x4(%ebp)
  801714:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801717:	8a 10                	mov    (%eax),%dl
  801719:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80171e:	8b 45 10             	mov    0x10(%ebp),%eax
  801721:	8d 50 ff             	lea    -0x1(%eax),%edx
  801724:	89 55 10             	mov    %edx,0x10(%ebp)
  801727:	85 c0                	test   %eax,%eax
  801729:	75 e3                	jne    80170e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80172b:	eb 23                	jmp    801750 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80172d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801730:	8d 50 01             	lea    0x1(%eax),%edx
  801733:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801736:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801739:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80173f:	8a 12                	mov    (%edx),%dl
  801741:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	8d 50 ff             	lea    -0x1(%eax),%edx
  801749:	89 55 10             	mov    %edx,0x10(%ebp)
  80174c:	85 c0                	test   %eax,%eax
  80174e:	75 dd                	jne    80172d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801767:	eb 2a                	jmp    801793 <memcmp+0x3e>
		if (*s1 != *s2)
  801769:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80176c:	8a 10                	mov    (%eax),%dl
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801771:	8a 00                	mov    (%eax),%al
  801773:	38 c2                	cmp    %al,%dl
  801775:	74 16                	je     80178d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801777:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177a:	8a 00                	mov    (%eax),%al
  80177c:	0f b6 d0             	movzbl %al,%edx
  80177f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	0f b6 c0             	movzbl %al,%eax
  801787:	29 c2                	sub    %eax,%edx
  801789:	89 d0                	mov    %edx,%eax
  80178b:	eb 18                	jmp    8017a5 <memcmp+0x50>
		s1++, s2++;
  80178d:	ff 45 fc             	incl   -0x4(%ebp)
  801790:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801793:	8b 45 10             	mov    0x10(%ebp),%eax
  801796:	8d 50 ff             	lea    -0x1(%eax),%edx
  801799:	89 55 10             	mov    %edx,0x10(%ebp)
  80179c:	85 c0                	test   %eax,%eax
  80179e:	75 c9                	jne    801769 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017b8:	eb 15                	jmp    8017cf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	0f b6 d0             	movzbl %al,%edx
  8017c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c5:	0f b6 c0             	movzbl %al,%eax
  8017c8:	39 c2                	cmp    %eax,%edx
  8017ca:	74 0d                	je     8017d9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017cc:	ff 45 08             	incl   0x8(%ebp)
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017d5:	72 e3                	jb     8017ba <memfind+0x13>
  8017d7:	eb 01                	jmp    8017da <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017d9:	90                   	nop
	return (void *) s;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017f3:	eb 03                	jmp    8017f8 <strtol+0x19>
		s++;
  8017f5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	8a 00                	mov    (%eax),%al
  8017fd:	3c 20                	cmp    $0x20,%al
  8017ff:	74 f4                	je     8017f5 <strtol+0x16>
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8a 00                	mov    (%eax),%al
  801806:	3c 09                	cmp    $0x9,%al
  801808:	74 eb                	je     8017f5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8a 00                	mov    (%eax),%al
  80180f:	3c 2b                	cmp    $0x2b,%al
  801811:	75 05                	jne    801818 <strtol+0x39>
		s++;
  801813:	ff 45 08             	incl   0x8(%ebp)
  801816:	eb 13                	jmp    80182b <strtol+0x4c>
	else if (*s == '-')
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	8a 00                	mov    (%eax),%al
  80181d:	3c 2d                	cmp    $0x2d,%al
  80181f:	75 0a                	jne    80182b <strtol+0x4c>
		s++, neg = 1;
  801821:	ff 45 08             	incl   0x8(%ebp)
  801824:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80182b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182f:	74 06                	je     801837 <strtol+0x58>
  801831:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801835:	75 20                	jne    801857 <strtol+0x78>
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 30                	cmp    $0x30,%al
  80183e:	75 17                	jne    801857 <strtol+0x78>
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	40                   	inc    %eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	3c 78                	cmp    $0x78,%al
  801848:	75 0d                	jne    801857 <strtol+0x78>
		s += 2, base = 16;
  80184a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80184e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801855:	eb 28                	jmp    80187f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801857:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80185b:	75 15                	jne    801872 <strtol+0x93>
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	8a 00                	mov    (%eax),%al
  801862:	3c 30                	cmp    $0x30,%al
  801864:	75 0c                	jne    801872 <strtol+0x93>
		s++, base = 8;
  801866:	ff 45 08             	incl   0x8(%ebp)
  801869:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801870:	eb 0d                	jmp    80187f <strtol+0xa0>
	else if (base == 0)
  801872:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801876:	75 07                	jne    80187f <strtol+0xa0>
		base = 10;
  801878:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	8a 00                	mov    (%eax),%al
  801884:	3c 2f                	cmp    $0x2f,%al
  801886:	7e 19                	jle    8018a1 <strtol+0xc2>
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	8a 00                	mov    (%eax),%al
  80188d:	3c 39                	cmp    $0x39,%al
  80188f:	7f 10                	jg     8018a1 <strtol+0xc2>
			dig = *s - '0';
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	8a 00                	mov    (%eax),%al
  801896:	0f be c0             	movsbl %al,%eax
  801899:	83 e8 30             	sub    $0x30,%eax
  80189c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80189f:	eb 42                	jmp    8018e3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	8a 00                	mov    (%eax),%al
  8018a6:	3c 60                	cmp    $0x60,%al
  8018a8:	7e 19                	jle    8018c3 <strtol+0xe4>
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	3c 7a                	cmp    $0x7a,%al
  8018b1:	7f 10                	jg     8018c3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	0f be c0             	movsbl %al,%eax
  8018bb:	83 e8 57             	sub    $0x57,%eax
  8018be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c1:	eb 20                	jmp    8018e3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8a 00                	mov    (%eax),%al
  8018c8:	3c 40                	cmp    $0x40,%al
  8018ca:	7e 39                	jle    801905 <strtol+0x126>
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	8a 00                	mov    (%eax),%al
  8018d1:	3c 5a                	cmp    $0x5a,%al
  8018d3:	7f 30                	jg     801905 <strtol+0x126>
			dig = *s - 'A' + 10;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	0f be c0             	movsbl %al,%eax
  8018dd:	83 e8 37             	sub    $0x37,%eax
  8018e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018e9:	7d 19                	jge    801904 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018eb:	ff 45 08             	incl   0x8(%ebp)
  8018ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018f5:	89 c2                	mov    %eax,%edx
  8018f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fa:	01 d0                	add    %edx,%eax
  8018fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018ff:	e9 7b ff ff ff       	jmp    80187f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801904:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801905:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801909:	74 08                	je     801913 <strtol+0x134>
		*endptr = (char *) s;
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801913:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801917:	74 07                	je     801920 <strtol+0x141>
  801919:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191c:	f7 d8                	neg    %eax
  80191e:	eb 03                	jmp    801923 <strtol+0x144>
  801920:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <ltostr>:

void
ltostr(long value, char *str)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80192b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801932:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80193d:	79 13                	jns    801952 <ltostr+0x2d>
	{
		neg = 1;
  80193f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80194c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80194f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80195a:	99                   	cltd   
  80195b:	f7 f9                	idiv   %ecx
  80195d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801960:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801963:	8d 50 01             	lea    0x1(%eax),%edx
  801966:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801969:	89 c2                	mov    %eax,%edx
  80196b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196e:	01 d0                	add    %edx,%eax
  801970:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801973:	83 c2 30             	add    $0x30,%edx
  801976:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801978:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80197b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801980:	f7 e9                	imul   %ecx
  801982:	c1 fa 02             	sar    $0x2,%edx
  801985:	89 c8                	mov    %ecx,%eax
  801987:	c1 f8 1f             	sar    $0x1f,%eax
  80198a:	29 c2                	sub    %eax,%edx
  80198c:	89 d0                	mov    %edx,%eax
  80198e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801991:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801995:	75 bb                	jne    801952 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80199e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a1:	48                   	dec    %eax
  8019a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019a9:	74 3d                	je     8019e8 <ltostr+0xc3>
		start = 1 ;
  8019ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019b2:	eb 34                	jmp    8019e8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8019b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	8a 00                	mov    (%eax),%al
  8019be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c7:	01 c2                	add    %eax,%edx
  8019c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cf:	01 c8                	add    %ecx,%eax
  8019d1:	8a 00                	mov    (%eax),%al
  8019d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019db:	01 c2                	add    %eax,%edx
  8019dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8019e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019ee:	7c c4                	jl     8019b4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	01 d0                	add    %edx,%eax
  8019f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a04:	ff 75 08             	pushl  0x8(%ebp)
  801a07:	e8 c4 f9 ff ff       	call   8013d0 <strlen>
  801a0c:	83 c4 04             	add    $0x4,%esp
  801a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	e8 b6 f9 ff ff       	call   8013d0 <strlen>
  801a1a:	83 c4 04             	add    $0x4,%esp
  801a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a2e:	eb 17                	jmp    801a47 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a33:	8b 45 10             	mov    0x10(%ebp),%eax
  801a36:	01 c2                	add    %eax,%edx
  801a38:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	01 c8                	add    %ecx,%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a44:	ff 45 fc             	incl   -0x4(%ebp)
  801a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a4d:	7c e1                	jl     801a30 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a56:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a5d:	eb 1f                	jmp    801a7e <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a62:	8d 50 01             	lea    0x1(%eax),%edx
  801a65:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a68:	89 c2                	mov    %eax,%edx
  801a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6d:	01 c2                	add    %eax,%edx
  801a6f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	01 c8                	add    %ecx,%eax
  801a77:	8a 00                	mov    (%eax),%al
  801a79:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a7b:	ff 45 f8             	incl   -0x8(%ebp)
  801a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a84:	7c d9                	jl     801a5f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c6 00 00             	movb   $0x0,(%eax)
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a97:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa3:	8b 00                	mov    (%eax),%eax
  801aa5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aac:	8b 45 10             	mov    0x10(%ebp),%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ab7:	eb 0c                	jmp    801ac5 <strsplit+0x31>
			*string++ = 0;
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8d 50 01             	lea    0x1(%eax),%edx
  801abf:	89 55 08             	mov    %edx,0x8(%ebp)
  801ac2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	8a 00                	mov    (%eax),%al
  801aca:	84 c0                	test   %al,%al
  801acc:	74 18                	je     801ae6 <strsplit+0x52>
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	8a 00                	mov    (%eax),%al
  801ad3:	0f be c0             	movsbl %al,%eax
  801ad6:	50                   	push   %eax
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	e8 83 fa ff ff       	call   801562 <strchr>
  801adf:	83 c4 08             	add    $0x8,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	75 d3                	jne    801ab9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	8a 00                	mov    (%eax),%al
  801aeb:	84 c0                	test   %al,%al
  801aed:	74 5a                	je     801b49 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aef:	8b 45 14             	mov    0x14(%ebp),%eax
  801af2:	8b 00                	mov    (%eax),%eax
  801af4:	83 f8 0f             	cmp    $0xf,%eax
  801af7:	75 07                	jne    801b00 <strsplit+0x6c>
		{
			return 0;
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
  801afe:	eb 66                	jmp    801b66 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b00:	8b 45 14             	mov    0x14(%ebp),%eax
  801b03:	8b 00                	mov    (%eax),%eax
  801b05:	8d 48 01             	lea    0x1(%eax),%ecx
  801b08:	8b 55 14             	mov    0x14(%ebp),%edx
  801b0b:	89 0a                	mov    %ecx,(%edx)
  801b0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b14:	8b 45 10             	mov    0x10(%ebp),%eax
  801b17:	01 c2                	add    %eax,%edx
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b1e:	eb 03                	jmp    801b23 <strsplit+0x8f>
			string++;
  801b20:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	84 c0                	test   %al,%al
  801b2a:	74 8b                	je     801ab7 <strsplit+0x23>
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	8a 00                	mov    (%eax),%al
  801b31:	0f be c0             	movsbl %al,%eax
  801b34:	50                   	push   %eax
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	e8 25 fa ff ff       	call   801562 <strchr>
  801b3d:	83 c4 08             	add    $0x8,%esp
  801b40:	85 c0                	test   %eax,%eax
  801b42:	74 dc                	je     801b20 <strsplit+0x8c>
			string++;
	}
  801b44:	e9 6e ff ff ff       	jmp    801ab7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b49:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4d:	8b 00                	mov    (%eax),%eax
  801b4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b56:	8b 45 10             	mov    0x10(%ebp),%eax
  801b59:	01 d0                	add    %edx,%eax
  801b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b61:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b7b:	eb 4a                	jmp    801bc7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	01 c2                	add    %eax,%edx
  801b85:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8b:	01 c8                	add    %ecx,%eax
  801b8d:	8a 00                	mov    (%eax),%al
  801b8f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	3c 40                	cmp    $0x40,%al
  801b9d:	7e 25                	jle    801bc4 <str2lower+0x5c>
  801b9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba5:	01 d0                	add    %edx,%eax
  801ba7:	8a 00                	mov    (%eax),%al
  801ba9:	3c 5a                	cmp    $0x5a,%al
  801bab:	7f 17                	jg     801bc4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801bad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	01 d0                	add    %edx,%eax
  801bb5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	01 ca                	add    %ecx,%edx
  801bbd:	8a 12                	mov    (%edx),%dl
  801bbf:	83 c2 20             	add    $0x20,%edx
  801bc2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	e8 01 f8 ff ff       	call   8013d0 <strlen>
  801bcf:	83 c4 04             	add    $0x4,%esp
  801bd2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bd5:	7f a6                	jg     801b7d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801bd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801be2:	a1 08 60 80 00       	mov    0x806008,%eax
  801be7:	85 c0                	test   %eax,%eax
  801be9:	74 42                	je     801c2d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801beb:	83 ec 08             	sub    $0x8,%esp
  801bee:	68 00 00 00 82       	push   $0x82000000
  801bf3:	68 00 00 00 80       	push   $0x80000000
  801bf8:	e8 b0 1e 00 00       	call   803aad <initialize_dynamic_allocator>
  801bfd:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801c00:	e8 96 1c 00 00       	call   80389b <sys_get_uheap_strategy>
  801c05:	a3 84 60 83 00       	mov    %eax,0x836084
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801c0a:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801c0f:	05 00 10 00 00       	add    $0x1000,%eax
  801c14:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801c19:	a1 30 61 83 00       	mov    0x836130,%eax
  801c1e:	a3 8c 60 83 00       	mov    %eax,0x83608c

		__firstTimeFlag = 0;
  801c23:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801c2a:	00 00 00 
	}
}
  801c2d:	90                   	nop
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c44:	83 ec 08             	sub    $0x8,%esp
  801c47:	68 06 04 00 00       	push   $0x406
  801c4c:	50                   	push   %eax
  801c4d:	e8 93 18 00 00       	call   8034e5 <__sys_allocate_page>
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c5c:	79 14                	jns    801c72 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	68 5c 4f 80 00       	push   $0x804f5c
  801c66:	6a 1f                	push   $0x1f
  801c68:	68 98 4f 80 00       	push   $0x804f98
  801c6d:	e8 af eb ff ff       	call   800821 <_panic>
	return 0;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	50                   	push   %eax
  801c91:	e8 96 18 00 00       	call   80352c <__sys_unmap_frame>
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ca0:	79 14                	jns    801cb6 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	68 a4 4f 80 00       	push   $0x804fa4
  801caa:	6a 2a                	push   $0x2a
  801cac:	68 98 4f 80 00       	push   $0x804f98
  801cb1:	e8 6b eb ff ff       	call   800821 <_panic>
}
  801cb6:	90                   	nop
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cbf:	e8 18 ff ff ff       	call   801bdc <uheap_init>
	if (size == 0) return NULL ;
  801cc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cc8:	75 0a                	jne    801cd4 <malloc+0x1b>
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	e9 43 03 00 00       	jmp    802017 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801cd4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801cdb:	77 13                	ja     801cf0 <malloc+0x37>
    {
        return alloc_block(size);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	e8 78 20 00 00       	call   803d60 <alloc_block>
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	e9 27 03 00 00       	jmp    802017 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801cf0:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  801cfa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cfd:	01 d0                	add    %edx,%eax
  801cff:	48                   	dec    %eax
  801d00:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d06:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0b:	f7 75 dc             	divl   -0x24(%ebp)
  801d0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d11:	29 d0                	sub    %edx,%eax
  801d13:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801d16:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	75 0a                	jne    801d29 <malloc+0x70>
    {
        uhp_inited = 1;
  801d1f:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801d26:	00 00 00 
    }

    int exactIdx = -1;
  801d29:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801d30:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801d37:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d3e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d45:	e9 85 00 00 00       	jmp    801dcf <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d4d:	89 d0                	mov    %edx,%eax
  801d4f:	01 c0                	add    %eax,%eax
  801d51:	01 d0                	add    %edx,%eax
  801d53:	c1 e0 02             	shl    $0x2,%eax
  801d56:	05 48 20 81 00       	add    $0x812048,%eax
  801d5b:	8a 00                	mov    (%eax),%al
  801d5d:	84 c0                	test   %al,%al
  801d5f:	74 20                	je     801d81 <malloc+0xc8>
  801d61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d64:	89 d0                	mov    %edx,%eax
  801d66:	01 c0                	add    %eax,%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	c1 e0 02             	shl    $0x2,%eax
  801d6d:	05 44 20 81 00       	add    $0x812044,%eax
  801d72:	8b 00                	mov    (%eax),%eax
  801d74:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d77:	75 08                	jne    801d81 <malloc+0xc8>
        {
            exactIdx = i;
  801d79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801d7f:	eb 5b                	jmp    801ddc <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801d81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d84:	89 d0                	mov    %edx,%eax
  801d86:	01 c0                	add    %eax,%eax
  801d88:	01 d0                	add    %edx,%eax
  801d8a:	c1 e0 02             	shl    $0x2,%eax
  801d8d:	05 48 20 81 00       	add    $0x812048,%eax
  801d92:	8a 00                	mov    (%eax),%al
  801d94:	84 c0                	test   %al,%al
  801d96:	74 34                	je     801dcc <malloc+0x113>
  801d98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d9b:	89 d0                	mov    %edx,%eax
  801d9d:	01 c0                	add    %eax,%eax
  801d9f:	01 d0                	add    %edx,%eax
  801da1:	c1 e0 02             	shl    $0x2,%eax
  801da4:	05 44 20 81 00       	add    $0x812044,%eax
  801da9:	8b 00                	mov    (%eax),%eax
  801dab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801dae:	76 1c                	jbe    801dcc <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801db3:	89 d0                	mov    %edx,%eax
  801db5:	01 c0                	add    %eax,%eax
  801db7:	01 d0                	add    %edx,%eax
  801db9:	c1 e0 02             	shl    $0x2,%eax
  801dbc:	05 44 20 81 00       	add    $0x812044,%eax
  801dc1:	8b 00                	mov    (%eax),%eax
  801dc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801dc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dcc:	ff 45 e8             	incl   -0x18(%ebp)
  801dcf:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801dd6:	0f 8e 6e ff ff ff    	jle    801d4a <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801ddc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801de3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801de7:	74 7d                	je     801e66 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801de9:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801df0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df3:	89 d0                	mov    %edx,%eax
  801df5:	01 c0                	add    %eax,%eax
  801df7:	01 d0                	add    %edx,%eax
  801df9:	c1 e0 02             	shl    $0x2,%eax
  801dfc:	05 40 20 81 00       	add    $0x812040,%eax
  801e01:	8b 10                	mov    (%eax),%edx
  801e03:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e06:	01 d0                	add    %edx,%eax
  801e08:	48                   	dec    %eax
  801e09:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e0c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e14:	f7 75 bc             	divl   -0x44(%ebp)
  801e17:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e1a:	29 d0                	sub    %edx,%eax
  801e1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801e1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e22:	89 d0                	mov    %edx,%eax
  801e24:	01 c0                	add    %eax,%eax
  801e26:	01 d0                	add    %edx,%eax
  801e28:	c1 e0 02             	shl    $0x2,%eax
  801e2b:	05 48 20 81 00       	add    $0x812048,%eax
  801e30:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801e33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e36:	89 d0                	mov    %edx,%eax
  801e38:	01 c0                	add    %eax,%eax
  801e3a:	01 d0                	add    %edx,%eax
  801e3c:	c1 e0 02             	shl    $0x2,%eax
  801e3f:	05 44 20 81 00       	add    $0x812044,%eax
  801e44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4d:	89 d0                	mov    %edx,%eax
  801e4f:	01 c0                	add    %eax,%eax
  801e51:	01 d0                	add    %edx,%eax
  801e53:	c1 e0 02             	shl    $0x2,%eax
  801e56:	05 40 20 81 00       	add    $0x812040,%eax
  801e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e61:	e9 2d 01 00 00       	jmp    801f93 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801e66:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e6a:	0f 84 ce 00 00 00    	je     801f3e <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801e70:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801e77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e7a:	89 d0                	mov    %edx,%eax
  801e7c:	01 c0                	add    %eax,%eax
  801e7e:	01 d0                	add    %edx,%eax
  801e80:	c1 e0 02             	shl    $0x2,%eax
  801e83:	05 40 20 81 00       	add    $0x812040,%eax
  801e88:	8b 10                	mov    (%eax),%edx
  801e8a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e8d:	01 d0                	add    %edx,%eax
  801e8f:	48                   	dec    %eax
  801e90:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801e93:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e96:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9b:	f7 75 c4             	divl   -0x3c(%ebp)
  801e9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ea1:	29 d0                	sub    %edx,%eax
  801ea3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801ea6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ea9:	89 d0                	mov    %edx,%eax
  801eab:	01 c0                	add    %eax,%eax
  801ead:	01 d0                	add    %edx,%eax
  801eaf:	c1 e0 02             	shl    $0x2,%eax
  801eb2:	05 44 20 81 00       	add    $0x812044,%eax
  801eb7:	8b 00                	mov    (%eax),%eax
  801eb9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ebc:	75 47                	jne    801f05 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ec1:	89 d0                	mov    %edx,%eax
  801ec3:	01 c0                	add    %eax,%eax
  801ec5:	01 d0                	add    %edx,%eax
  801ec7:	c1 e0 02             	shl    $0x2,%eax
  801eca:	05 48 20 81 00       	add    $0x812048,%eax
  801ecf:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801ed2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed5:	89 d0                	mov    %edx,%eax
  801ed7:	01 c0                	add    %eax,%eax
  801ed9:	01 d0                	add    %edx,%eax
  801edb:	c1 e0 02             	shl    $0x2,%eax
  801ede:	05 44 20 81 00       	add    $0x812044,%eax
  801ee3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801ee9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	01 c0                	add    %eax,%eax
  801ef0:	01 d0                	add    %edx,%eax
  801ef2:	c1 e0 02             	shl    $0x2,%eax
  801ef5:	05 40 20 81 00       	add    $0x812040,%eax
  801efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f00:	e9 8e 00 00 00       	jmp    801f93 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f0b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801f0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f11:	89 d0                	mov    %edx,%eax
  801f13:	01 c0                	add    %eax,%eax
  801f15:	01 d0                	add    %edx,%eax
  801f17:	c1 e0 02             	shl    $0x2,%eax
  801f1a:	05 40 20 81 00       	add    $0x812040,%eax
  801f1f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f24:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f27:	89 c2                	mov    %eax,%edx
  801f29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f2c:	89 c8                	mov    %ecx,%eax
  801f2e:	01 c0                	add    %eax,%eax
  801f30:	01 c8                	add    %ecx,%eax
  801f32:	c1 e0 02             	shl    $0x2,%eax
  801f35:	05 44 20 81 00       	add    $0x812044,%eax
  801f3a:	89 10                	mov    %edx,(%eax)
  801f3c:	eb 55                	jmp    801f93 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801f3e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801f45:	8b 15 8c 60 83 00    	mov    0x83608c,%edx
  801f4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f4e:	01 d0                	add    %edx,%eax
  801f50:	48                   	dec    %eax
  801f51:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f57:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5c:	f7 75 d0             	divl   -0x30(%ebp)
  801f5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f62:	29 d0                	sub    %edx,%eax
  801f64:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801f67:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f6d:	01 d0                	add    %edx,%eax
  801f6f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f74:	76 0a                	jbe    801f80 <malloc+0x2c7>
            return NULL;
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	e9 97 00 00 00       	jmp    802017 <malloc+0x35e>
        va = start;
  801f80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801f86:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f8c:	01 d0                	add    %edx,%eax
  801f8e:	a3 8c 60 83 00       	mov    %eax,0x83608c
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f93:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f9a:	eb 5e                	jmp    801ffa <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801f9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f9f:	89 d0                	mov    %edx,%eax
  801fa1:	01 c0                	add    %eax,%eax
  801fa3:	01 d0                	add    %edx,%eax
  801fa5:	c1 e0 02             	shl    $0x2,%eax
  801fa8:	05 48 60 80 00       	add    $0x806048,%eax
  801fad:	8a 00                	mov    (%eax),%al
  801faf:	84 c0                	test   %al,%al
  801fb1:	75 44                	jne    801ff7 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801fb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fb6:	89 d0                	mov    %edx,%eax
  801fb8:	01 c0                	add    %eax,%eax
  801fba:	01 d0                	add    %edx,%eax
  801fbc:	c1 e0 02             	shl    $0x2,%eax
  801fbf:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801fca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fcd:	89 d0                	mov    %edx,%eax
  801fcf:	01 c0                	add    %eax,%eax
  801fd1:	01 d0                	add    %edx,%eax
  801fd3:	c1 e0 02             	shl    $0x2,%eax
  801fd6:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801fdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fdf:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801fe1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fe4:	89 d0                	mov    %edx,%eax
  801fe6:	01 c0                	add    %eax,%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	c1 e0 02             	shl    $0x2,%eax
  801fed:	05 48 60 80 00       	add    $0x806048,%eax
  801ff2:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801ff5:	eb 0c                	jmp    802003 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ff7:	ff 45 e0             	incl   -0x20(%ebp)
  801ffa:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802001:	7e 99                	jle    801f9c <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  802003:	83 ec 08             	sub    $0x8,%esp
  802006:	ff 75 d4             	pushl  -0x2c(%ebp)
  802009:	ff 75 e4             	pushl  -0x1c(%ebp)
  80200c:	e8 a2 19 00 00       	call   8039b3 <sys_allocate_user_mem>
  802011:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  802014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  80201f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802023:	0f 84 fa 03 00 00    	je     802423 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80202f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802032:	85 c0                	test   %eax,%eax
  802034:	79 1c                	jns    802052 <free+0x39>
  802036:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  80203d:	77 13                	ja     802052 <free+0x39>
    {
        free_block(virtual_address);
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	e8 09 21 00 00       	call   804153 <free_block>
  80204a:	83 c4 10             	add    $0x10,%esp
        return;
  80204d:	e9 d2 03 00 00       	jmp    802424 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802052:	a1 30 61 83 00       	mov    0x836130,%eax
  802057:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  80205a:	72 09                	jb     802065 <free+0x4c>
  80205c:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  802063:	76 17                	jbe    80207c <free+0x63>
        panic("free: invalid address");
  802065:	83 ec 04             	sub    $0x4,%esp
  802068:	68 e1 4f 80 00       	push   $0x804fe1
  80206d:	68 9b 00 00 00       	push   $0x9b
  802072:	68 98 4f 80 00       	push   $0x804f98
  802077:	e8 a5 e7 ff ff       	call   800821 <_panic>

    uint32 size = 0;
  80207c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  802083:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80208a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802091:	eb 50                	jmp    8020e3 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802093:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802096:	89 d0                	mov    %edx,%eax
  802098:	01 c0                	add    %eax,%eax
  80209a:	01 d0                	add    %edx,%eax
  80209c:	c1 e0 02             	shl    $0x2,%eax
  80209f:	05 48 60 80 00       	add    $0x806048,%eax
  8020a4:	8a 00                	mov    (%eax),%al
  8020a6:	84 c0                	test   %al,%al
  8020a8:	74 36                	je     8020e0 <free+0xc7>
  8020aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020ad:	89 d0                	mov    %edx,%eax
  8020af:	01 c0                	add    %eax,%eax
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	c1 e0 02             	shl    $0x2,%eax
  8020b6:	05 40 60 80 00       	add    $0x806040,%eax
  8020bb:	8b 00                	mov    (%eax),%eax
  8020bd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8020c0:	75 1e                	jne    8020e0 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  8020c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020c5:	89 d0                	mov    %edx,%eax
  8020c7:	01 c0                	add    %eax,%eax
  8020c9:	01 d0                	add    %edx,%eax
  8020cb:	c1 e0 02             	shl    $0x2,%eax
  8020ce:	05 44 60 80 00       	add    $0x806044,%eax
  8020d3:	8b 00                	mov    (%eax),%eax
  8020d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  8020d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020db:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  8020de:	eb 0c                	jmp    8020ec <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8020e0:	ff 45 ec             	incl   -0x14(%ebp)
  8020e3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8020ea:	7e a7                	jle    802093 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  8020ec:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020f0:	74 06                	je     8020f8 <free+0xdf>
  8020f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f6:	75 17                	jne    80210f <free+0xf6>
        panic("free: unknown block");
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	68 f7 4f 80 00       	push   $0x804ff7
  802100:	68 a9 00 00 00       	push   $0xa9
  802105:	68 98 4f 80 00       	push   $0x804f98
  80210a:	e8 12 e7 ff ff       	call   800821 <_panic>

    uhp_allocs[idx].used = 0;
  80210f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802112:	89 d0                	mov    %edx,%eax
  802114:	01 c0                	add    %eax,%eax
  802116:	01 d0                	add    %edx,%eax
  802118:	c1 e0 02             	shl    $0x2,%eax
  80211b:	05 48 60 80 00       	add    $0x806048,%eax
  802120:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  802123:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80212a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802131:	eb 64                	jmp    802197 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  802133:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802136:	89 d0                	mov    %edx,%eax
  802138:	01 c0                	add    %eax,%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	c1 e0 02             	shl    $0x2,%eax
  80213f:	05 48 20 81 00       	add    $0x812048,%eax
  802144:	8a 00                	mov    (%eax),%al
  802146:	84 c0                	test   %al,%al
  802148:	75 4a                	jne    802194 <free+0x17b>
        {
            uhp_frees[i].va = va;
  80214a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80214d:	89 d0                	mov    %edx,%eax
  80214f:	01 c0                	add    %eax,%eax
  802151:	01 d0                	add    %edx,%eax
  802153:	c1 e0 02             	shl    $0x2,%eax
  802156:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  80215c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80215f:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802161:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802164:	89 d0                	mov    %edx,%eax
  802166:	01 c0                	add    %eax,%eax
  802168:	01 d0                	add    %edx,%eax
  80216a:	c1 e0 02             	shl    $0x2,%eax
  80216d:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  802178:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80217b:	89 d0                	mov    %edx,%eax
  80217d:	01 c0                	add    %eax,%eax
  80217f:	01 d0                	add    %edx,%eax
  802181:	c1 e0 02             	shl    $0x2,%eax
  802184:	05 48 20 81 00       	add    $0x812048,%eax
  802189:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  80218c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80218f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802192:	eb 0c                	jmp    8021a0 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802194:	ff 45 e4             	incl   -0x1c(%ebp)
  802197:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80219e:	7e 93                	jle    802133 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  8021a0:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8021a4:	0f 84 f1 01 00 00    	je     80239b <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8021b1:	e9 d8 01 00 00       	jmp    80238e <free+0x375>
        {
            if (i == fidx) continue;
  8021b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8021bc:	0f 84 c8 01 00 00    	je     80238a <free+0x371>
            if (uhp_frees[i].free)
  8021c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021c5:	89 d0                	mov    %edx,%eax
  8021c7:	01 c0                	add    %eax,%eax
  8021c9:	01 d0                	add    %edx,%eax
  8021cb:	c1 e0 02             	shl    $0x2,%eax
  8021ce:	05 48 20 81 00       	add    $0x812048,%eax
  8021d3:	8a 00                	mov    (%eax),%al
  8021d5:	84 c0                	test   %al,%al
  8021d7:	0f 84 ae 01 00 00    	je     80238b <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  8021dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021e0:	89 d0                	mov    %edx,%eax
  8021e2:	01 c0                	add    %eax,%eax
  8021e4:	01 d0                	add    %edx,%eax
  8021e6:	c1 e0 02             	shl    $0x2,%eax
  8021e9:	05 40 20 81 00       	add    $0x812040,%eax
  8021ee:	8b 08                	mov    (%eax),%ecx
  8021f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021f3:	89 d0                	mov    %edx,%eax
  8021f5:	01 c0                	add    %eax,%eax
  8021f7:	01 d0                	add    %edx,%eax
  8021f9:	c1 e0 02             	shl    $0x2,%eax
  8021fc:	05 44 20 81 00       	add    $0x812044,%eax
  802201:	8b 00                	mov    (%eax),%eax
  802203:	01 c1                	add    %eax,%ecx
  802205:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802208:	89 d0                	mov    %edx,%eax
  80220a:	01 c0                	add    %eax,%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c1 e0 02             	shl    $0x2,%eax
  802211:	05 40 20 81 00       	add    $0x812040,%eax
  802216:	8b 00                	mov    (%eax),%eax
  802218:	39 c1                	cmp    %eax,%ecx
  80221a:	0f 85 a8 00 00 00    	jne    8022c8 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802220:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802223:	89 d0                	mov    %edx,%eax
  802225:	01 c0                	add    %eax,%eax
  802227:	01 d0                	add    %edx,%eax
  802229:	c1 e0 02             	shl    $0x2,%eax
  80222c:	05 40 20 81 00       	add    $0x812040,%eax
  802231:	8b 10                	mov    (%eax),%edx
  802233:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802236:	89 c8                	mov    %ecx,%eax
  802238:	01 c0                	add    %eax,%eax
  80223a:	01 c8                	add    %ecx,%eax
  80223c:	c1 e0 02             	shl    $0x2,%eax
  80223f:	05 40 20 81 00       	add    $0x812040,%eax
  802244:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802246:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802249:	89 d0                	mov    %edx,%eax
  80224b:	01 c0                	add    %eax,%eax
  80224d:	01 d0                	add    %edx,%eax
  80224f:	c1 e0 02             	shl    $0x2,%eax
  802252:	05 44 20 81 00       	add    $0x812044,%eax
  802257:	8b 08                	mov    (%eax),%ecx
  802259:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80225c:	89 d0                	mov    %edx,%eax
  80225e:	01 c0                	add    %eax,%eax
  802260:	01 d0                	add    %edx,%eax
  802262:	c1 e0 02             	shl    $0x2,%eax
  802265:	05 44 20 81 00       	add    $0x812044,%eax
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	01 c1                	add    %eax,%ecx
  80226e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802271:	89 d0                	mov    %edx,%eax
  802273:	01 c0                	add    %eax,%eax
  802275:	01 d0                	add    %edx,%eax
  802277:	c1 e0 02             	shl    $0x2,%eax
  80227a:	05 44 20 81 00       	add    $0x812044,%eax
  80227f:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802281:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802284:	89 d0                	mov    %edx,%eax
  802286:	01 c0                	add    %eax,%eax
  802288:	01 d0                	add    %edx,%eax
  80228a:	c1 e0 02             	shl    $0x2,%eax
  80228d:	05 48 20 81 00       	add    $0x812048,%eax
  802292:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802295:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802298:	89 d0                	mov    %edx,%eax
  80229a:	01 c0                	add    %eax,%eax
  80229c:	01 d0                	add    %edx,%eax
  80229e:	c1 e0 02             	shl    $0x2,%eax
  8022a1:	05 40 20 81 00       	add    $0x812040,%eax
  8022a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8022ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022af:	89 d0                	mov    %edx,%eax
  8022b1:	01 c0                	add    %eax,%eax
  8022b3:	01 d0                	add    %edx,%eax
  8022b5:	c1 e0 02             	shl    $0x2,%eax
  8022b8:	05 44 20 81 00       	add    $0x812044,%eax
  8022bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c3:	e9 c3 00 00 00       	jmp    80238b <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  8022c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022cb:	89 d0                	mov    %edx,%eax
  8022cd:	01 c0                	add    %eax,%eax
  8022cf:	01 d0                	add    %edx,%eax
  8022d1:	c1 e0 02             	shl    $0x2,%eax
  8022d4:	05 40 20 81 00       	add    $0x812040,%eax
  8022d9:	8b 08                	mov    (%eax),%ecx
  8022db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022de:	89 d0                	mov    %edx,%eax
  8022e0:	01 c0                	add    %eax,%eax
  8022e2:	01 d0                	add    %edx,%eax
  8022e4:	c1 e0 02             	shl    $0x2,%eax
  8022e7:	05 44 20 81 00       	add    $0x812044,%eax
  8022ec:	8b 00                	mov    (%eax),%eax
  8022ee:	01 c1                	add    %eax,%ecx
  8022f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022f3:	89 d0                	mov    %edx,%eax
  8022f5:	01 c0                	add    %eax,%eax
  8022f7:	01 d0                	add    %edx,%eax
  8022f9:	c1 e0 02             	shl    $0x2,%eax
  8022fc:	05 40 20 81 00       	add    $0x812040,%eax
  802301:	8b 00                	mov    (%eax),%eax
  802303:	39 c1                	cmp    %eax,%ecx
  802305:	0f 85 80 00 00 00    	jne    80238b <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80230b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80230e:	89 d0                	mov    %edx,%eax
  802310:	01 c0                	add    %eax,%eax
  802312:	01 d0                	add    %edx,%eax
  802314:	c1 e0 02             	shl    $0x2,%eax
  802317:	05 44 20 81 00       	add    $0x812044,%eax
  80231c:	8b 08                	mov    (%eax),%ecx
  80231e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802321:	89 d0                	mov    %edx,%eax
  802323:	01 c0                	add    %eax,%eax
  802325:	01 d0                	add    %edx,%eax
  802327:	c1 e0 02             	shl    $0x2,%eax
  80232a:	05 44 20 81 00       	add    $0x812044,%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	01 c1                	add    %eax,%ecx
  802333:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802336:	89 d0                	mov    %edx,%eax
  802338:	01 c0                	add    %eax,%eax
  80233a:	01 d0                	add    %edx,%eax
  80233c:	c1 e0 02             	shl    $0x2,%eax
  80233f:	05 44 20 81 00       	add    $0x812044,%eax
  802344:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802346:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802349:	89 d0                	mov    %edx,%eax
  80234b:	01 c0                	add    %eax,%eax
  80234d:	01 d0                	add    %edx,%eax
  80234f:	c1 e0 02             	shl    $0x2,%eax
  802352:	05 48 20 81 00       	add    $0x812048,%eax
  802357:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80235a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80235d:	89 d0                	mov    %edx,%eax
  80235f:	01 c0                	add    %eax,%eax
  802361:	01 d0                	add    %edx,%eax
  802363:	c1 e0 02             	shl    $0x2,%eax
  802366:	05 40 20 81 00       	add    $0x812040,%eax
  80236b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802371:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802374:	89 d0                	mov    %edx,%eax
  802376:	01 c0                	add    %eax,%eax
  802378:	01 d0                	add    %edx,%eax
  80237a:	c1 e0 02             	shl    $0x2,%eax
  80237d:	05 44 20 81 00       	add    $0x812044,%eax
  802382:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802388:	eb 01                	jmp    80238b <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  80238a:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80238b:	ff 45 e0             	incl   -0x20(%ebp)
  80238e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802395:	0f 8e 1b fe ff ff    	jle    8021b6 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  80239b:	a1 30 61 83 00       	mov    0x836130,%eax
  8023a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023a3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8023aa:	eb 53                	jmp    8023ff <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  8023ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023af:	89 d0                	mov    %edx,%eax
  8023b1:	01 c0                	add    %eax,%eax
  8023b3:	01 d0                	add    %edx,%eax
  8023b5:	c1 e0 02             	shl    $0x2,%eax
  8023b8:	05 48 60 80 00       	add    $0x806048,%eax
  8023bd:	8a 00                	mov    (%eax),%al
  8023bf:	84 c0                	test   %al,%al
  8023c1:	74 39                	je     8023fc <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  8023c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023c6:	89 d0                	mov    %edx,%eax
  8023c8:	01 c0                	add    %eax,%eax
  8023ca:	01 d0                	add    %edx,%eax
  8023cc:	c1 e0 02             	shl    $0x2,%eax
  8023cf:	05 40 60 80 00       	add    $0x806040,%eax
  8023d4:	8b 08                	mov    (%eax),%ecx
  8023d6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023d9:	89 d0                	mov    %edx,%eax
  8023db:	01 c0                	add    %eax,%eax
  8023dd:	01 d0                	add    %edx,%eax
  8023df:	c1 e0 02             	shl    $0x2,%eax
  8023e2:	05 44 60 80 00       	add    $0x806044,%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	01 c8                	add    %ecx,%eax
  8023eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  8023ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8023f4:	76 06                	jbe    8023fc <free+0x3e3>
  8023f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023fc:	ff 45 d8             	incl   -0x28(%ebp)
  8023ff:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802406:	7e a4                	jle    8023ac <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802408:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80240b:	a3 8c 60 83 00       	mov    %eax,0x83608c

    sys_free_user_mem(va, size);
  802410:	83 ec 08             	sub    $0x8,%esp
  802413:	ff 75 f4             	pushl  -0xc(%ebp)
  802416:	ff 75 d4             	pushl  -0x2c(%ebp)
  802419:	e8 79 15 00 00       	call   803997 <sys_free_user_mem>
  80241e:	83 c4 10             	add    $0x10,%esp
  802421:	eb 01                	jmp    802424 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802423:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	83 ec 68             	sub    $0x68,%esp
  80242c:	8b 45 10             	mov    0x10(%ebp),%eax
  80242f:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802432:	e8 a5 f7 ff ff       	call   801bdc <uheap_init>
	if (size == 0) return NULL ;
  802437:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80243b:	75 0a                	jne    802447 <smalloc+0x21>
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
  802442:	e9 37 03 00 00       	jmp    80277e <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802447:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80244e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802451:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802454:	01 d0                	add    %edx,%eax
  802456:	48                   	dec    %eax
  802457:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80245a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80245d:	ba 00 00 00 00       	mov    $0x0,%edx
  802462:	f7 75 dc             	divl   -0x24(%ebp)
  802465:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802468:	29 d0                	sub    %edx,%eax
  80246a:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  80246d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802474:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80247b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802482:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802489:	e9 85 00 00 00       	jmp    802513 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80248e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802491:	89 d0                	mov    %edx,%eax
  802493:	01 c0                	add    %eax,%eax
  802495:	01 d0                	add    %edx,%eax
  802497:	c1 e0 02             	shl    $0x2,%eax
  80249a:	05 48 20 81 00       	add    $0x812048,%eax
  80249f:	8a 00                	mov    (%eax),%al
  8024a1:	84 c0                	test   %al,%al
  8024a3:	74 20                	je     8024c5 <smalloc+0x9f>
  8024a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024a8:	89 d0                	mov    %edx,%eax
  8024aa:	01 c0                	add    %eax,%eax
  8024ac:	01 d0                	add    %edx,%eax
  8024ae:	c1 e0 02             	shl    $0x2,%eax
  8024b1:	05 44 20 81 00       	add    $0x812044,%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8024bb:	75 08                	jne    8024c5 <smalloc+0x9f>
        {
            exactIdx = i;
  8024bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8024c3:	eb 5b                	jmp    802520 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8024c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024c8:	89 d0                	mov    %edx,%eax
  8024ca:	01 c0                	add    %eax,%eax
  8024cc:	01 d0                	add    %edx,%eax
  8024ce:	c1 e0 02             	shl    $0x2,%eax
  8024d1:	05 48 20 81 00       	add    $0x812048,%eax
  8024d6:	8a 00                	mov    (%eax),%al
  8024d8:	84 c0                	test   %al,%al
  8024da:	74 34                	je     802510 <smalloc+0xea>
  8024dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024df:	89 d0                	mov    %edx,%eax
  8024e1:	01 c0                	add    %eax,%eax
  8024e3:	01 d0                	add    %edx,%eax
  8024e5:	c1 e0 02             	shl    $0x2,%eax
  8024e8:	05 44 20 81 00       	add    $0x812044,%eax
  8024ed:	8b 00                	mov    (%eax),%eax
  8024ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024f2:	76 1c                	jbe    802510 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8024f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024f7:	89 d0                	mov    %edx,%eax
  8024f9:	01 c0                	add    %eax,%eax
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	c1 e0 02             	shl    $0x2,%eax
  802500:	05 44 20 81 00       	add    $0x812044,%eax
  802505:	8b 00                	mov    (%eax),%eax
  802507:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80250a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80250d:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802510:	ff 45 e8             	incl   -0x18(%ebp)
  802513:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80251a:	0f 8e 6e ff ff ff    	jle    80248e <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802520:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802527:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80252b:	74 7d                	je     8025aa <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80252d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802534:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802537:	89 d0                	mov    %edx,%eax
  802539:	01 c0                	add    %eax,%eax
  80253b:	01 d0                	add    %edx,%eax
  80253d:	c1 e0 02             	shl    $0x2,%eax
  802540:	05 40 20 81 00       	add    $0x812040,%eax
  802545:	8b 10                	mov    (%eax),%edx
  802547:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80254a:	01 d0                	add    %edx,%eax
  80254c:	48                   	dec    %eax
  80254d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802550:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802553:	ba 00 00 00 00       	mov    $0x0,%edx
  802558:	f7 75 bc             	divl   -0x44(%ebp)
  80255b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80255e:	29 d0                	sub    %edx,%eax
  802560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	89 d0                	mov    %edx,%eax
  802568:	01 c0                	add    %eax,%eax
  80256a:	01 d0                	add    %edx,%eax
  80256c:	c1 e0 02             	shl    $0x2,%eax
  80256f:	05 48 20 81 00       	add    $0x812048,%eax
  802574:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802577:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257a:	89 d0                	mov    %edx,%eax
  80257c:	01 c0                	add    %eax,%eax
  80257e:	01 d0                	add    %edx,%eax
  802580:	c1 e0 02             	shl    $0x2,%eax
  802583:	05 44 20 81 00       	add    $0x812044,%eax
  802588:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80258e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802591:	89 d0                	mov    %edx,%eax
  802593:	01 c0                	add    %eax,%eax
  802595:	01 d0                	add    %edx,%eax
  802597:	c1 e0 02             	shl    $0x2,%eax
  80259a:	05 40 20 81 00       	add    $0x812040,%eax
  80259f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a5:	e9 2d 01 00 00       	jmp    8026d7 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8025aa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025ae:	0f 84 ce 00 00 00    	je     802682 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8025b4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025be:	89 d0                	mov    %edx,%eax
  8025c0:	01 c0                	add    %eax,%eax
  8025c2:	01 d0                	add    %edx,%eax
  8025c4:	c1 e0 02             	shl    $0x2,%eax
  8025c7:	05 40 20 81 00       	add    $0x812040,%eax
  8025cc:	8b 10                	mov    (%eax),%edx
  8025ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025d1:	01 d0                	add    %edx,%eax
  8025d3:	48                   	dec    %eax
  8025d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025da:	ba 00 00 00 00       	mov    $0x0,%edx
  8025df:	f7 75 c4             	divl   -0x3c(%ebp)
  8025e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025e5:	29 d0                	sub    %edx,%eax
  8025e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8025ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ed:	89 d0                	mov    %edx,%eax
  8025ef:	01 c0                	add    %eax,%eax
  8025f1:	01 d0                	add    %edx,%eax
  8025f3:	c1 e0 02             	shl    $0x2,%eax
  8025f6:	05 44 20 81 00       	add    $0x812044,%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802600:	75 47                	jne    802649 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802602:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802605:	89 d0                	mov    %edx,%eax
  802607:	01 c0                	add    %eax,%eax
  802609:	01 d0                	add    %edx,%eax
  80260b:	c1 e0 02             	shl    $0x2,%eax
  80260e:	05 48 20 81 00       	add    $0x812048,%eax
  802613:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802616:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802619:	89 d0                	mov    %edx,%eax
  80261b:	01 c0                	add    %eax,%eax
  80261d:	01 d0                	add    %edx,%eax
  80261f:	c1 e0 02             	shl    $0x2,%eax
  802622:	05 44 20 81 00       	add    $0x812044,%eax
  802627:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80262d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802630:	89 d0                	mov    %edx,%eax
  802632:	01 c0                	add    %eax,%eax
  802634:	01 d0                	add    %edx,%eax
  802636:	c1 e0 02             	shl    $0x2,%eax
  802639:	05 40 20 81 00       	add    $0x812040,%eax
  80263e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802644:	e9 8e 00 00 00       	jmp    8026d7 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802649:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80264c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80264f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802652:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802655:	89 d0                	mov    %edx,%eax
  802657:	01 c0                	add    %eax,%eax
  802659:	01 d0                	add    %edx,%eax
  80265b:	c1 e0 02             	shl    $0x2,%eax
  80265e:	05 40 20 81 00       	add    $0x812040,%eax
  802663:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802668:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80266b:	89 c2                	mov    %eax,%edx
  80266d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802670:	89 c8                	mov    %ecx,%eax
  802672:	01 c0                	add    %eax,%eax
  802674:	01 c8                	add    %ecx,%eax
  802676:	c1 e0 02             	shl    $0x2,%eax
  802679:	05 44 20 81 00       	add    $0x812044,%eax
  80267e:	89 10                	mov    %edx,(%eax)
  802680:	eb 55                	jmp    8026d7 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802682:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802689:	8b 15 8c 60 83 00    	mov    0x83608c,%edx
  80268f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802692:	01 d0                	add    %edx,%eax
  802694:	48                   	dec    %eax
  802695:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802698:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80269b:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a0:	f7 75 d0             	divl   -0x30(%ebp)
  8026a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026a6:	29 d0                	sub    %edx,%eax
  8026a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8026ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8026ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b1:	01 d0                	add    %edx,%eax
  8026b3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8026b8:	76 0a                	jbe    8026c4 <smalloc+0x29e>
            return NULL;
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bf:	e9 ba 00 00 00       	jmp    80277e <smalloc+0x358>
        va = start;
  8026c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8026ca:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8026cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d0:	01 d0                	add    %edx,%eax
  8026d2:	a3 8c 60 83 00       	mov    %eax,0x83608c
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8026d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8026de:	eb 5e                	jmp    80273e <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8026e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026e3:	89 d0                	mov    %edx,%eax
  8026e5:	01 c0                	add    %eax,%eax
  8026e7:	01 d0                	add    %edx,%eax
  8026e9:	c1 e0 02             	shl    $0x2,%eax
  8026ec:	05 48 60 80 00       	add    $0x806048,%eax
  8026f1:	8a 00                	mov    (%eax),%al
  8026f3:	84 c0                	test   %al,%al
  8026f5:	75 44                	jne    80273b <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8026f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026fa:	89 d0                	mov    %edx,%eax
  8026fc:	01 c0                	add    %eax,%eax
  8026fe:	01 d0                	add    %edx,%eax
  802700:	c1 e0 02             	shl    $0x2,%eax
  802703:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80270e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802711:	89 d0                	mov    %edx,%eax
  802713:	01 c0                	add    %eax,%eax
  802715:	01 d0                	add    %edx,%eax
  802717:	c1 e0 02             	shl    $0x2,%eax
  80271a:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802723:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802725:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802728:	89 d0                	mov    %edx,%eax
  80272a:	01 c0                	add    %eax,%eax
  80272c:	01 d0                	add    %edx,%eax
  80272e:	c1 e0 02             	shl    $0x2,%eax
  802731:	05 48 60 80 00       	add    $0x806048,%eax
  802736:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802739:	eb 0c                	jmp    802747 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80273b:	ff 45 e0             	incl   -0x20(%ebp)
  80273e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802745:	7e 99                	jle    8026e0 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802747:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80274a:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80274e:	52                   	push   %edx
  80274f:	50                   	push   %eax
  802750:	ff 75 d4             	pushl  -0x2c(%ebp)
  802753:	ff 75 08             	pushl  0x8(%ebp)
  802756:	e8 de 0e 00 00       	call   803639 <sys_create_shared_object>
  80275b:	83 c4 10             	add    $0x10,%esp
  80275e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802761:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802765:	75 07                	jne    80276e <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802767:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80276c:	eb 10                	jmp    80277e <smalloc+0x358>
    if (r < 0)
  80276e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802772:	79 07                	jns    80277b <smalloc+0x355>
        return NULL;
  802774:	b8 00 00 00 00       	mov    $0x0,%eax
  802779:	eb 03                	jmp    80277e <smalloc+0x358>
    return (void*)va;
  80277b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802786:	e8 51 f4 ff ff       	call   801bdc <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80278b:	83 ec 08             	sub    $0x8,%esp
  80278e:	ff 75 0c             	pushl  0xc(%ebp)
  802791:	ff 75 08             	pushl  0x8(%ebp)
  802794:	e8 ca 0e 00 00       	call   803663 <sys_size_of_shared_object>
  802799:	83 c4 10             	add    $0x10,%esp
  80279c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80279f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8027a3:	7f 0a                	jg     8027af <sget+0x2f>
        return NULL;
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027aa:	e9 28 03 00 00       	jmp    802ad7 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8027af:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027bc:	01 d0                	add    %edx,%eax
  8027be:	48                   	dec    %eax
  8027bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ca:	f7 75 d8             	divl   -0x28(%ebp)
  8027cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027d0:	29 d0                	sub    %edx,%eax
  8027d2:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8027d5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8027dc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8027e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8027ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8027f1:	e9 85 00 00 00       	jmp    80287b <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8027f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027f9:	89 d0                	mov    %edx,%eax
  8027fb:	01 c0                	add    %eax,%eax
  8027fd:	01 d0                	add    %edx,%eax
  8027ff:	c1 e0 02             	shl    $0x2,%eax
  802802:	05 48 20 81 00       	add    $0x812048,%eax
  802807:	8a 00                	mov    (%eax),%al
  802809:	84 c0                	test   %al,%al
  80280b:	74 20                	je     80282d <sget+0xad>
  80280d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802810:	89 d0                	mov    %edx,%eax
  802812:	01 c0                	add    %eax,%eax
  802814:	01 d0                	add    %edx,%eax
  802816:	c1 e0 02             	shl    $0x2,%eax
  802819:	05 44 20 81 00       	add    $0x812044,%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802823:	75 08                	jne    80282d <sget+0xad>
        {
            exactIdx = i;
  802825:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802828:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80282b:	eb 5b                	jmp    802888 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80282d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802830:	89 d0                	mov    %edx,%eax
  802832:	01 c0                	add    %eax,%eax
  802834:	01 d0                	add    %edx,%eax
  802836:	c1 e0 02             	shl    $0x2,%eax
  802839:	05 48 20 81 00       	add    $0x812048,%eax
  80283e:	8a 00                	mov    (%eax),%al
  802840:	84 c0                	test   %al,%al
  802842:	74 34                	je     802878 <sget+0xf8>
  802844:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802847:	89 d0                	mov    %edx,%eax
  802849:	01 c0                	add    %eax,%eax
  80284b:	01 d0                	add    %edx,%eax
  80284d:	c1 e0 02             	shl    $0x2,%eax
  802850:	05 44 20 81 00       	add    $0x812044,%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80285a:	76 1c                	jbe    802878 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80285c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80285f:	89 d0                	mov    %edx,%eax
  802861:	01 c0                	add    %eax,%eax
  802863:	01 d0                	add    %edx,%eax
  802865:	c1 e0 02             	shl    $0x2,%eax
  802868:	05 44 20 81 00       	add    $0x812044,%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802875:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802878:	ff 45 e8             	incl   -0x18(%ebp)
  80287b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802882:	0f 8e 6e ff ff ff    	jle    8027f6 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802888:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80288f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802893:	74 7d                	je     802912 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802895:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80289c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289f:	89 d0                	mov    %edx,%eax
  8028a1:	01 c0                	add    %eax,%eax
  8028a3:	01 d0                	add    %edx,%eax
  8028a5:	c1 e0 02             	shl    $0x2,%eax
  8028a8:	05 40 20 81 00       	add    $0x812040,%eax
  8028ad:	8b 10                	mov    (%eax),%edx
  8028af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	48                   	dec    %eax
  8028b5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8028b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c0:	f7 75 b8             	divl   -0x48(%ebp)
  8028c3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028c6:	29 d0                	sub    %edx,%eax
  8028c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8028cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ce:	89 d0                	mov    %edx,%eax
  8028d0:	01 c0                	add    %eax,%eax
  8028d2:	01 d0                	add    %edx,%eax
  8028d4:	c1 e0 02             	shl    $0x2,%eax
  8028d7:	05 48 20 81 00       	add    $0x812048,%eax
  8028dc:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8028df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e2:	89 d0                	mov    %edx,%eax
  8028e4:	01 c0                	add    %eax,%eax
  8028e6:	01 d0                	add    %edx,%eax
  8028e8:	c1 e0 02             	shl    $0x2,%eax
  8028eb:	05 44 20 81 00       	add    $0x812044,%eax
  8028f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8028f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f9:	89 d0                	mov    %edx,%eax
  8028fb:	01 c0                	add    %eax,%eax
  8028fd:	01 d0                	add    %edx,%eax
  8028ff:	c1 e0 02             	shl    $0x2,%eax
  802902:	05 40 20 81 00       	add    $0x812040,%eax
  802907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290d:	e9 2d 01 00 00       	jmp    802a3f <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802912:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802916:	0f 84 ce 00 00 00    	je     8029ea <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80291c:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802926:	89 d0                	mov    %edx,%eax
  802928:	01 c0                	add    %eax,%eax
  80292a:	01 d0                	add    %edx,%eax
  80292c:	c1 e0 02             	shl    $0x2,%eax
  80292f:	05 40 20 81 00       	add    $0x812040,%eax
  802934:	8b 10                	mov    (%eax),%edx
  802936:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802939:	01 d0                	add    %edx,%eax
  80293b:	48                   	dec    %eax
  80293c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80293f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802942:	ba 00 00 00 00       	mov    $0x0,%edx
  802947:	f7 75 c0             	divl   -0x40(%ebp)
  80294a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80294d:	29 d0                	sub    %edx,%eax
  80294f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	89 d0                	mov    %edx,%eax
  802957:	01 c0                	add    %eax,%eax
  802959:	01 d0                	add    %edx,%eax
  80295b:	c1 e0 02             	shl    $0x2,%eax
  80295e:	05 44 20 81 00       	add    $0x812044,%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802968:	75 47                	jne    8029b1 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80296a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296d:	89 d0                	mov    %edx,%eax
  80296f:	01 c0                	add    %eax,%eax
  802971:	01 d0                	add    %edx,%eax
  802973:	c1 e0 02             	shl    $0x2,%eax
  802976:	05 48 20 81 00       	add    $0x812048,%eax
  80297b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80297e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802981:	89 d0                	mov    %edx,%eax
  802983:	01 c0                	add    %eax,%eax
  802985:	01 d0                	add    %edx,%eax
  802987:	c1 e0 02             	shl    $0x2,%eax
  80298a:	05 44 20 81 00       	add    $0x812044,%eax
  80298f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802995:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802998:	89 d0                	mov    %edx,%eax
  80299a:	01 c0                	add    %eax,%eax
  80299c:	01 d0                	add    %edx,%eax
  80299e:	c1 e0 02             	shl    $0x2,%eax
  8029a1:	05 40 20 81 00       	add    $0x812040,%eax
  8029a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ac:	e9 8e 00 00 00       	jmp    802a3f <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8029b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029b7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8029ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bd:	89 d0                	mov    %edx,%eax
  8029bf:	01 c0                	add    %eax,%eax
  8029c1:	01 d0                	add    %edx,%eax
  8029c3:	c1 e0 02             	shl    $0x2,%eax
  8029c6:	05 40 20 81 00       	add    $0x812040,%eax
  8029cb:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8029cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8029d3:	89 c2                	mov    %eax,%edx
  8029d5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8029d8:	89 c8                	mov    %ecx,%eax
  8029da:	01 c0                	add    %eax,%eax
  8029dc:	01 c8                	add    %ecx,%eax
  8029de:	c1 e0 02             	shl    $0x2,%eax
  8029e1:	05 44 20 81 00       	add    $0x812044,%eax
  8029e6:	89 10                	mov    %edx,(%eax)
  8029e8:	eb 55                	jmp    802a3f <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8029ea:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8029f1:	8b 15 8c 60 83 00    	mov    0x83608c,%edx
  8029f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fa:	01 d0                	add    %edx,%eax
  8029fc:	48                   	dec    %eax
  8029fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802a00:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a03:	ba 00 00 00 00       	mov    $0x0,%edx
  802a08:	f7 75 cc             	divl   -0x34(%ebp)
  802a0b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a0e:	29 d0                	sub    %edx,%eax
  802a10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802a13:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802a16:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a19:	01 d0                	add    %edx,%eax
  802a1b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802a20:	76 0a                	jbe    802a2c <sget+0x2ac>
            return NULL;
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	e9 ab 00 00 00       	jmp    802ad7 <sget+0x357>
        va = start;
  802a2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802a32:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802a35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a38:	01 d0                	add    %edx,%eax
  802a3a:	a3 8c 60 83 00       	mov    %eax,0x83608c
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a3f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802a46:	eb 5e                	jmp    802aa6 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802a48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a4b:	89 d0                	mov    %edx,%eax
  802a4d:	01 c0                	add    %eax,%eax
  802a4f:	01 d0                	add    %edx,%eax
  802a51:	c1 e0 02             	shl    $0x2,%eax
  802a54:	05 48 60 80 00       	add    $0x806048,%eax
  802a59:	8a 00                	mov    (%eax),%al
  802a5b:	84 c0                	test   %al,%al
  802a5d:	75 44                	jne    802aa3 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802a5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a62:	89 d0                	mov    %edx,%eax
  802a64:	01 c0                	add    %eax,%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	c1 e0 02             	shl    $0x2,%eax
  802a6b:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a74:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802a76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a79:	89 d0                	mov    %edx,%eax
  802a7b:	01 c0                	add    %eax,%eax
  802a7d:	01 d0                	add    %edx,%eax
  802a7f:	c1 e0 02             	shl    $0x2,%eax
  802a82:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802a88:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a8b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802a8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	01 c0                	add    %eax,%eax
  802a94:	01 d0                	add    %edx,%eax
  802a96:	c1 e0 02             	shl    $0x2,%eax
  802a99:	05 48 60 80 00       	add    $0x806048,%eax
  802a9e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802aa1:	eb 0c                	jmp    802aaf <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802aa3:	ff 45 e0             	incl   -0x20(%ebp)
  802aa6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802aad:	7e 99                	jle    802a48 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab2:	83 ec 04             	sub    $0x4,%esp
  802ab5:	50                   	push   %eax
  802ab6:	ff 75 0c             	pushl  0xc(%ebp)
  802ab9:	ff 75 08             	pushl  0x8(%ebp)
  802abc:	e8 bf 0b 00 00       	call   803680 <sys_get_shared_object>
  802ac1:	83 c4 10             	add    $0x10,%esp
  802ac4:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802ac7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802acb:	79 07                	jns    802ad4 <sget+0x354>
        return NULL;
  802acd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad2:	eb 03                	jmp    802ad7 <sget+0x357>
    return (void*)va;
  802ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802ad7:	c9                   	leave  
  802ad8:	c3                   	ret    

00802ad9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802ad9:	55                   	push   %ebp
  802ada:	89 e5                	mov    %esp,%ebp
  802adc:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802adf:	e8 f8 f0 ff ff       	call   801bdc <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802ae4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae8:	75 13                	jne    802afd <realloc+0x24>
		return malloc(new_size);
  802aea:	83 ec 0c             	sub    $0xc,%esp
  802aed:	ff 75 0c             	pushl  0xc(%ebp)
  802af0:	e8 c4 f1 ff ff       	call   801cb9 <malloc>
  802af5:	83 c4 10             	add    $0x10,%esp
  802af8:	e9 f4 05 00 00       	jmp    8030f1 <realloc+0x618>
	if (new_size == 0)
  802afd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b01:	75 18                	jne    802b1b <realloc+0x42>
	{
		free(virtual_address);
  802b03:	83 ec 0c             	sub    $0xc,%esp
  802b06:	ff 75 08             	pushl  0x8(%ebp)
  802b09:	e8 0b f5 ff ff       	call   802019 <free>
  802b0e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802b11:	b8 00 00 00 00       	mov    $0x0,%eax
  802b16:	e9 d6 05 00 00       	jmp    8030f1 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802b21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	79 74                	jns    802b9c <realloc+0xc3>
  802b28:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802b2f:	77 6b                	ja     802b9c <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802b31:	83 ec 0c             	sub    $0xc,%esp
  802b34:	ff 75 0c             	pushl  0xc(%ebp)
  802b37:	e8 7d f1 ff ff       	call   801cb9 <malloc>
  802b3c:	83 c4 10             	add    $0x10,%esp
  802b3f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802b42:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802b46:	75 0a                	jne    802b52 <realloc+0x79>
			return NULL;
  802b48:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4d:	e9 9f 05 00 00       	jmp    8030f1 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802b52:	83 ec 0c             	sub    $0xc,%esp
  802b55:	ff 75 08             	pushl  0x8(%ebp)
  802b58:	e8 e0 11 00 00       	call   803d3d <get_block_size>
  802b5d:	83 c4 10             	add    $0x10,%esp
  802b60:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802b63:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b69:	39 d0                	cmp    %edx,%eax
  802b6b:	76 02                	jbe    802b6f <realloc+0x96>
  802b6d:	89 d0                	mov    %edx,%eax
  802b6f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802b72:	83 ec 04             	sub    $0x4,%esp
  802b75:	ff 75 c0             	pushl  -0x40(%ebp)
  802b78:	ff 75 08             	pushl  0x8(%ebp)
  802b7b:	ff 75 c8             	pushl  -0x38(%ebp)
  802b7e:	e8 56 eb ff ff       	call   8016d9 <memmove>
  802b83:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802b86:	83 ec 0c             	sub    $0xc,%esp
  802b89:	ff 75 08             	pushl  0x8(%ebp)
  802b8c:	e8 88 f4 ff ff       	call   802019 <free>
  802b91:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802b94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b97:	e9 55 05 00 00       	jmp    8030f1 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802b9c:	a1 30 61 83 00       	mov    0x836130,%eax
  802ba1:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802ba4:	72 09                	jb     802baf <realloc+0xd6>
  802ba6:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802bad:	76 0a                	jbe    802bb9 <realloc+0xe0>
		return NULL;
  802baf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb4:	e9 38 05 00 00       	jmp    8030f1 <realloc+0x618>
	uint32 oldsz = 0;
  802bb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802bc0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802bc7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802bce:	eb 50                	jmp    802c20 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802bd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd3:	89 d0                	mov    %edx,%eax
  802bd5:	01 c0                	add    %eax,%eax
  802bd7:	01 d0                	add    %edx,%eax
  802bd9:	c1 e0 02             	shl    $0x2,%eax
  802bdc:	05 48 60 80 00       	add    $0x806048,%eax
  802be1:	8a 00                	mov    (%eax),%al
  802be3:	84 c0                	test   %al,%al
  802be5:	74 36                	je     802c1d <realloc+0x144>
  802be7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bea:	89 d0                	mov    %edx,%eax
  802bec:	01 c0                	add    %eax,%eax
  802bee:	01 d0                	add    %edx,%eax
  802bf0:	c1 e0 02             	shl    $0x2,%eax
  802bf3:	05 40 60 80 00       	add    $0x806040,%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802bfd:	75 1e                	jne    802c1d <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802bff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c02:	89 d0                	mov    %edx,%eax
  802c04:	01 c0                	add    %eax,%eax
  802c06:	01 d0                	add    %edx,%eax
  802c08:	c1 e0 02             	shl    $0x2,%eax
  802c0b:	05 44 60 80 00       	add    $0x806044,%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802c1b:	eb 0c                	jmp    802c29 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c1d:	ff 45 ec             	incl   -0x14(%ebp)
  802c20:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c27:	7e a7                	jle    802bd0 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802c29:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c2d:	75 0a                	jne    802c39 <realloc+0x160>
		return NULL;
  802c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c34:	e9 b8 04 00 00       	jmp    8030f1 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802c39:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c43:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c46:	01 d0                	add    %edx,%eax
  802c48:	48                   	dec    %eax
  802c49:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802c4c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c4f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c54:	f7 75 bc             	divl   -0x44(%ebp)
  802c57:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c5a:	29 d0                	sub    %edx,%eax
  802c5c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802c5f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c65:	75 08                	jne    802c6f <realloc+0x196>
		return virtual_address;
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	e9 82 04 00 00       	jmp    8030f1 <realloc+0x618>
	if (req < oldsz)
  802c6f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c72:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c75:	0f 83 cd 02 00 00    	jae    802f48 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802c81:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802c84:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c87:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c8a:	01 d0                	add    %edx,%eax
  802c8c:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802c8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c92:	89 d0                	mov    %edx,%eax
  802c94:	01 c0                	add    %eax,%eax
  802c96:	01 d0                	add    %edx,%eax
  802c98:	c1 e0 02             	shl    $0x2,%eax
  802c9b:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802ca1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ca4:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802ca6:	83 ec 08             	sub    $0x8,%esp
  802ca9:	ff 75 b0             	pushl  -0x50(%ebp)
  802cac:	ff 75 ac             	pushl  -0x54(%ebp)
  802caf:	e8 e3 0c 00 00       	call   803997 <sys_free_user_mem>
  802cb4:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802cb7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802cbe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802cc5:	eb 64                	jmp    802d2b <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802cc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cca:	89 d0                	mov    %edx,%eax
  802ccc:	01 c0                	add    %eax,%eax
  802cce:	01 d0                	add    %edx,%eax
  802cd0:	c1 e0 02             	shl    $0x2,%eax
  802cd3:	05 48 20 81 00       	add    $0x812048,%eax
  802cd8:	8a 00                	mov    (%eax),%al
  802cda:	84 c0                	test   %al,%al
  802cdc:	75 4a                	jne    802d28 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802cde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ce1:	89 d0                	mov    %edx,%eax
  802ce3:	01 c0                	add    %eax,%eax
  802ce5:	01 d0                	add    %edx,%eax
  802ce7:	c1 e0 02             	shl    $0x2,%eax
  802cea:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802cf0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cf3:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cf8:	89 d0                	mov    %edx,%eax
  802cfa:	01 c0                	add    %eax,%eax
  802cfc:	01 d0                	add    %edx,%eax
  802cfe:	c1 e0 02             	shl    $0x2,%eax
  802d01:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802d07:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d0a:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802d0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d0f:	89 d0                	mov    %edx,%eax
  802d11:	01 c0                	add    %eax,%eax
  802d13:	01 d0                	add    %edx,%eax
  802d15:	c1 e0 02             	shl    $0x2,%eax
  802d18:	05 48 20 81 00       	add    $0x812048,%eax
  802d1d:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d23:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802d26:	eb 0c                	jmp    802d34 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802d28:	ff 45 e4             	incl   -0x1c(%ebp)
  802d2b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802d32:	7e 93                	jle    802cc7 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802d34:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802d38:	0f 84 8d 01 00 00    	je     802ecb <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802d3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802d45:	e9 74 01 00 00       	jmp    802ebe <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d4d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d50:	0f 84 64 01 00 00    	je     802eba <realloc+0x3e1>
				if (uhp_frees[k].free)
  802d56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d59:	89 d0                	mov    %edx,%eax
  802d5b:	01 c0                	add    %eax,%eax
  802d5d:	01 d0                	add    %edx,%eax
  802d5f:	c1 e0 02             	shl    $0x2,%eax
  802d62:	05 48 20 81 00       	add    $0x812048,%eax
  802d67:	8a 00                	mov    (%eax),%al
  802d69:	84 c0                	test   %al,%al
  802d6b:	0f 84 4a 01 00 00    	je     802ebb <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802d71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d74:	89 d0                	mov    %edx,%eax
  802d76:	01 c0                	add    %eax,%eax
  802d78:	01 d0                	add    %edx,%eax
  802d7a:	c1 e0 02             	shl    $0x2,%eax
  802d7d:	05 40 20 81 00       	add    $0x812040,%eax
  802d82:	8b 08                	mov    (%eax),%ecx
  802d84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d87:	89 d0                	mov    %edx,%eax
  802d89:	01 c0                	add    %eax,%eax
  802d8b:	01 d0                	add    %edx,%eax
  802d8d:	c1 e0 02             	shl    $0x2,%eax
  802d90:	05 44 20 81 00       	add    $0x812044,%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	01 c1                	add    %eax,%ecx
  802d99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9c:	89 d0                	mov    %edx,%eax
  802d9e:	01 c0                	add    %eax,%eax
  802da0:	01 d0                	add    %edx,%eax
  802da2:	c1 e0 02             	shl    $0x2,%eax
  802da5:	05 40 20 81 00       	add    $0x812040,%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	39 c1                	cmp    %eax,%ecx
  802dae:	75 7a                	jne    802e2a <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802db0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802db3:	89 d0                	mov    %edx,%eax
  802db5:	01 c0                	add    %eax,%eax
  802db7:	01 d0                	add    %edx,%eax
  802db9:	c1 e0 02             	shl    $0x2,%eax
  802dbc:	05 40 20 81 00       	add    $0x812040,%eax
  802dc1:	8b 10                	mov    (%eax),%edx
  802dc3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802dc6:	89 c8                	mov    %ecx,%eax
  802dc8:	01 c0                	add    %eax,%eax
  802dca:	01 c8                	add    %ecx,%eax
  802dcc:	c1 e0 02             	shl    $0x2,%eax
  802dcf:	05 40 20 81 00       	add    $0x812040,%eax
  802dd4:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802dd6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd9:	89 d0                	mov    %edx,%eax
  802ddb:	01 c0                	add    %eax,%eax
  802ddd:	01 d0                	add    %edx,%eax
  802ddf:	c1 e0 02             	shl    $0x2,%eax
  802de2:	05 44 20 81 00       	add    $0x812044,%eax
  802de7:	8b 08                	mov    (%eax),%ecx
  802de9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dec:	89 d0                	mov    %edx,%eax
  802dee:	01 c0                	add    %eax,%eax
  802df0:	01 d0                	add    %edx,%eax
  802df2:	c1 e0 02             	shl    $0x2,%eax
  802df5:	05 44 20 81 00       	add    $0x812044,%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	01 c1                	add    %eax,%ecx
  802dfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e01:	89 d0                	mov    %edx,%eax
  802e03:	01 c0                	add    %eax,%eax
  802e05:	01 d0                	add    %edx,%eax
  802e07:	c1 e0 02             	shl    $0x2,%eax
  802e0a:	05 44 20 81 00       	add    $0x812044,%eax
  802e0f:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802e11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e14:	89 d0                	mov    %edx,%eax
  802e16:	01 c0                	add    %eax,%eax
  802e18:	01 d0                	add    %edx,%eax
  802e1a:	c1 e0 02             	shl    $0x2,%eax
  802e1d:	05 48 20 81 00       	add    $0x812048,%eax
  802e22:	c6 00 00             	movb   $0x0,(%eax)
  802e25:	e9 91 00 00 00       	jmp    802ebb <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802e2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e2d:	89 d0                	mov    %edx,%eax
  802e2f:	01 c0                	add    %eax,%eax
  802e31:	01 d0                	add    %edx,%eax
  802e33:	c1 e0 02             	shl    $0x2,%eax
  802e36:	05 40 20 81 00       	add    $0x812040,%eax
  802e3b:	8b 08                	mov    (%eax),%ecx
  802e3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e40:	89 d0                	mov    %edx,%eax
  802e42:	01 c0                	add    %eax,%eax
  802e44:	01 d0                	add    %edx,%eax
  802e46:	c1 e0 02             	shl    $0x2,%eax
  802e49:	05 44 20 81 00       	add    $0x812044,%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	01 c1                	add    %eax,%ecx
  802e52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e55:	89 d0                	mov    %edx,%eax
  802e57:	01 c0                	add    %eax,%eax
  802e59:	01 d0                	add    %edx,%eax
  802e5b:	c1 e0 02             	shl    $0x2,%eax
  802e5e:	05 40 20 81 00       	add    $0x812040,%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	39 c1                	cmp    %eax,%ecx
  802e67:	75 52                	jne    802ebb <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802e69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e6c:	89 d0                	mov    %edx,%eax
  802e6e:	01 c0                	add    %eax,%eax
  802e70:	01 d0                	add    %edx,%eax
  802e72:	c1 e0 02             	shl    $0x2,%eax
  802e75:	05 44 20 81 00       	add    $0x812044,%eax
  802e7a:	8b 08                	mov    (%eax),%ecx
  802e7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e7f:	89 d0                	mov    %edx,%eax
  802e81:	01 c0                	add    %eax,%eax
  802e83:	01 d0                	add    %edx,%eax
  802e85:	c1 e0 02             	shl    $0x2,%eax
  802e88:	05 44 20 81 00       	add    $0x812044,%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	01 c1                	add    %eax,%ecx
  802e91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e94:	89 d0                	mov    %edx,%eax
  802e96:	01 c0                	add    %eax,%eax
  802e98:	01 d0                	add    %edx,%eax
  802e9a:	c1 e0 02             	shl    $0x2,%eax
  802e9d:	05 44 20 81 00       	add    $0x812044,%eax
  802ea2:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802ea4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ea7:	89 d0                	mov    %edx,%eax
  802ea9:	01 c0                	add    %eax,%eax
  802eab:	01 d0                	add    %edx,%eax
  802ead:	c1 e0 02             	shl    $0x2,%eax
  802eb0:	05 48 20 81 00       	add    $0x812048,%eax
  802eb5:	c6 00 00             	movb   $0x0,(%eax)
  802eb8:	eb 01                	jmp    802ebb <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802eba:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ebb:	ff 45 e0             	incl   -0x20(%ebp)
  802ebe:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802ec5:	0f 8e 7f fe ff ff    	jle    802d4a <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802ecb:	a1 30 61 83 00       	mov    0x836130,%eax
  802ed0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802ed3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802eda:	eb 53                	jmp    802f2f <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802edc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802edf:	89 d0                	mov    %edx,%eax
  802ee1:	01 c0                	add    %eax,%eax
  802ee3:	01 d0                	add    %edx,%eax
  802ee5:	c1 e0 02             	shl    $0x2,%eax
  802ee8:	05 48 60 80 00       	add    $0x806048,%eax
  802eed:	8a 00                	mov    (%eax),%al
  802eef:	84 c0                	test   %al,%al
  802ef1:	74 39                	je     802f2c <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802ef3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ef6:	89 d0                	mov    %edx,%eax
  802ef8:	01 c0                	add    %eax,%eax
  802efa:	01 d0                	add    %edx,%eax
  802efc:	c1 e0 02             	shl    $0x2,%eax
  802eff:	05 40 60 80 00       	add    $0x806040,%eax
  802f04:	8b 08                	mov    (%eax),%ecx
  802f06:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f09:	89 d0                	mov    %edx,%eax
  802f0b:	01 c0                	add    %eax,%eax
  802f0d:	01 d0                	add    %edx,%eax
  802f0f:	c1 e0 02             	shl    $0x2,%eax
  802f12:	05 44 60 80 00       	add    $0x806044,%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	01 c8                	add    %ecx,%eax
  802f1b:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802f1e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f21:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802f24:	76 06                	jbe    802f2c <realloc+0x453>
  802f26:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f29:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802f2c:	ff 45 d8             	incl   -0x28(%ebp)
  802f2f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802f36:	7e a4                	jle    802edc <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802f38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3b:	a3 8c 60 83 00       	mov    %eax,0x83608c
		return virtual_address;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	e9 a9 01 00 00       	jmp    8030f1 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802f48:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	01 d0                	add    %edx,%eax
  802f50:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802f53:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802f5a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802f61:	eb 57                	jmp    802fba <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802f63:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f66:	89 d0                	mov    %edx,%eax
  802f68:	01 c0                	add    %eax,%eax
  802f6a:	01 d0                	add    %edx,%eax
  802f6c:	c1 e0 02             	shl    $0x2,%eax
  802f6f:	05 48 20 81 00       	add    $0x812048,%eax
  802f74:	8a 00                	mov    (%eax),%al
  802f76:	84 c0                	test   %al,%al
  802f78:	74 3d                	je     802fb7 <realloc+0x4de>
  802f7a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f7d:	89 d0                	mov    %edx,%eax
  802f7f:	01 c0                	add    %eax,%eax
  802f81:	01 d0                	add    %edx,%eax
  802f83:	c1 e0 02             	shl    $0x2,%eax
  802f86:	05 40 20 81 00       	add    $0x812040,%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f90:	75 25                	jne    802fb7 <realloc+0x4de>
  802f92:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f95:	89 d0                	mov    %edx,%eax
  802f97:	01 c0                	add    %eax,%eax
  802f99:	01 d0                	add    %edx,%eax
  802f9b:	c1 e0 02             	shl    $0x2,%eax
  802f9e:	05 44 20 81 00       	add    $0x812044,%eax
  802fa3:	8b 10                	mov    (%eax),%edx
  802fa5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fa8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802fab:	39 c2                	cmp    %eax,%edx
  802fad:	72 08                	jb     802fb7 <realloc+0x4de>
		{
			adjIdx = j; break;
  802faf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fb2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802fb5:	eb 0c                	jmp    802fc3 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802fb7:	ff 45 d0             	incl   -0x30(%ebp)
  802fba:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802fc1:	7e a0                	jle    802f63 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802fc3:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802fc7:	0f 84 d6 00 00 00    	je     8030a3 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802fcd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fd0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802fd3:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802fd6:	83 ec 08             	sub    $0x8,%esp
  802fd9:	ff 75 a0             	pushl  -0x60(%ebp)
  802fdc:	ff 75 a4             	pushl  -0x5c(%ebp)
  802fdf:	e8 cf 09 00 00       	call   8039b3 <sys_allocate_user_mem>
  802fe4:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802fe7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fea:	89 d0                	mov    %edx,%eax
  802fec:	01 c0                	add    %eax,%eax
  802fee:	01 d0                	add    %edx,%eax
  802ff0:	c1 e0 02             	shl    $0x2,%eax
  802ff3:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802ff9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ffc:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802ffe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803001:	89 d0                	mov    %edx,%eax
  803003:	01 c0                	add    %eax,%eax
  803005:	01 d0                	add    %edx,%eax
  803007:	c1 e0 02             	shl    $0x2,%eax
  80300a:	05 40 20 81 00       	add    $0x812040,%eax
  80300f:	8b 10                	mov    (%eax),%edx
  803011:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803014:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  803017:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80301a:	89 d0                	mov    %edx,%eax
  80301c:	01 c0                	add    %eax,%eax
  80301e:	01 d0                	add    %edx,%eax
  803020:	c1 e0 02             	shl    $0x2,%eax
  803023:	05 40 20 81 00       	add    $0x812040,%eax
  803028:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  80302a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80302d:	89 d0                	mov    %edx,%eax
  80302f:	01 c0                	add    %eax,%eax
  803031:	01 d0                	add    %edx,%eax
  803033:	c1 e0 02             	shl    $0x2,%eax
  803036:	05 44 20 81 00       	add    $0x812044,%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	2b 45 a0             	sub    -0x60(%ebp),%eax
  803040:	89 c2                	mov    %eax,%edx
  803042:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803045:	89 c8                	mov    %ecx,%eax
  803047:	01 c0                	add    %eax,%eax
  803049:	01 c8                	add    %ecx,%eax
  80304b:	c1 e0 02             	shl    $0x2,%eax
  80304e:	05 44 20 81 00       	add    $0x812044,%eax
  803053:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  803055:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803058:	89 d0                	mov    %edx,%eax
  80305a:	01 c0                	add    %eax,%eax
  80305c:	01 d0                	add    %edx,%eax
  80305e:	c1 e0 02             	shl    $0x2,%eax
  803061:	05 44 20 81 00       	add    $0x812044,%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	75 14                	jne    803080 <realloc+0x5a7>
  80306c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80306f:	89 d0                	mov    %edx,%eax
  803071:	01 c0                	add    %eax,%eax
  803073:	01 d0                	add    %edx,%eax
  803075:	c1 e0 02             	shl    $0x2,%eax
  803078:	05 48 20 81 00       	add    $0x812048,%eax
  80307d:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  803080:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803083:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803086:	01 c2                	add    %eax,%edx
  803088:	a1 8c 60 83 00       	mov    0x83608c,%eax
  80308d:	39 c2                	cmp    %eax,%edx
  80308f:	76 0d                	jbe    80309e <realloc+0x5c5>
  803091:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803094:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803097:	01 d0                	add    %edx,%eax
  803099:	a3 8c 60 83 00       	mov    %eax,0x83608c
		return virtual_address;
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	eb 4e                	jmp    8030f1 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  8030a3:	83 ec 0c             	sub    $0xc,%esp
  8030a6:	ff 75 0c             	pushl  0xc(%ebp)
  8030a9:	e8 0b ec ff ff       	call   801cb9 <malloc>
  8030ae:	83 c4 10             	add    $0x10,%esp
  8030b1:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  8030b4:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8030b8:	75 07                	jne    8030c1 <realloc+0x5e8>
		return NULL;
  8030ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bf:	eb 30                	jmp    8030f1 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  8030c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030c7:	39 d0                	cmp    %edx,%eax
  8030c9:	76 02                	jbe    8030cd <realloc+0x5f4>
  8030cb:	89 d0                	mov    %edx,%eax
  8030cd:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8030d0:	83 ec 04             	sub    $0x4,%esp
  8030d3:	50                   	push   %eax
  8030d4:	52                   	push   %edx
  8030d5:	ff 75 cc             	pushl  -0x34(%ebp)
  8030d8:	e8 cf 06 00 00       	call   8037ac <sys_move_user_mem>
  8030dd:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  8030e0:	83 ec 0c             	sub    $0xc,%esp
  8030e3:	ff 75 08             	pushl  0x8(%ebp)
  8030e6:	e8 2e ef ff ff       	call   802019 <free>
  8030eb:	83 c4 10             	add    $0x10,%esp
	return newptr;
  8030ee:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  8030f1:	c9                   	leave  
  8030f2:	c3                   	ret    

008030f3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
  8030f6:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8030ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803103:	0f 84 33 03 00 00    	je     80343c <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  803109:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  803111:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  803114:	83 ec 08             	sub    $0x8,%esp
  803117:	ff 75 08             	pushl  0x8(%ebp)
  80311a:	ff 75 d8             	pushl  -0x28(%ebp)
  80311d:	e8 7d 05 00 00       	call   80369f <sys_delete_shared_object>
  803122:	83 c4 10             	add    $0x10,%esp
  803125:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  803128:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80312c:	0f 88 0d 03 00 00    	js     80343f <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803132:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803139:	e9 ef 02 00 00       	jmp    80342d <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80313e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803141:	89 d0                	mov    %edx,%eax
  803143:	01 c0                	add    %eax,%eax
  803145:	01 d0                	add    %edx,%eax
  803147:	c1 e0 02             	shl    $0x2,%eax
  80314a:	05 48 60 80 00       	add    $0x806048,%eax
  80314f:	8a 00                	mov    (%eax),%al
  803151:	84 c0                	test   %al,%al
  803153:	0f 84 d1 02 00 00    	je     80342a <sfree+0x337>
  803159:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80315c:	89 d0                	mov    %edx,%eax
  80315e:	01 c0                	add    %eax,%eax
  803160:	01 d0                	add    %edx,%eax
  803162:	c1 e0 02             	shl    $0x2,%eax
  803165:	05 40 60 80 00       	add    $0x806040,%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80316f:	0f 85 b5 02 00 00    	jne    80342a <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803175:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803178:	89 d0                	mov    %edx,%eax
  80317a:	01 c0                	add    %eax,%eax
  80317c:	01 d0                	add    %edx,%eax
  80317e:	c1 e0 02             	shl    $0x2,%eax
  803181:	05 44 60 80 00       	add    $0x806044,%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  80318b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80318e:	89 d0                	mov    %edx,%eax
  803190:	01 c0                	add    %eax,%eax
  803192:	01 d0                	add    %edx,%eax
  803194:	c1 e0 02             	shl    $0x2,%eax
  803197:	05 48 60 80 00       	add    $0x806048,%eax
  80319c:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  80319f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8031a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8031ad:	eb 64                	jmp    803213 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  8031af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031b2:	89 d0                	mov    %edx,%eax
  8031b4:	01 c0                	add    %eax,%eax
  8031b6:	01 d0                	add    %edx,%eax
  8031b8:	c1 e0 02             	shl    $0x2,%eax
  8031bb:	05 48 20 81 00       	add    $0x812048,%eax
  8031c0:	8a 00                	mov    (%eax),%al
  8031c2:	84 c0                	test   %al,%al
  8031c4:	75 4a                	jne    803210 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  8031c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031c9:	89 d0                	mov    %edx,%eax
  8031cb:	01 c0                	add    %eax,%eax
  8031cd:	01 d0                	add    %edx,%eax
  8031cf:	c1 e0 02             	shl    $0x2,%eax
  8031d2:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8031d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031db:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  8031dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031e0:	89 d0                	mov    %edx,%eax
  8031e2:	01 c0                	add    %eax,%eax
  8031e4:	01 d0                	add    %edx,%eax
  8031e6:	c1 e0 02             	shl    $0x2,%eax
  8031e9:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  8031ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031f2:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  8031f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031f7:	89 d0                	mov    %edx,%eax
  8031f9:	01 c0                	add    %eax,%eax
  8031fb:	01 d0                	add    %edx,%eax
  8031fd:	c1 e0 02             	shl    $0x2,%eax
  803200:	05 48 20 81 00       	add    $0x812048,%eax
  803205:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  803208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  80320e:	eb 0c                	jmp    80321c <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803210:	ff 45 ec             	incl   -0x14(%ebp)
  803213:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80321a:	7e 93                	jle    8031af <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  80321c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803220:	0f 84 8d 01 00 00    	je     8033b3 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803226:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80322d:	e9 74 01 00 00       	jmp    8033a6 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803238:	0f 84 64 01 00 00    	je     8033a2 <sfree+0x2af>
					if (uhp_frees[k].free)
  80323e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803241:	89 d0                	mov    %edx,%eax
  803243:	01 c0                	add    %eax,%eax
  803245:	01 d0                	add    %edx,%eax
  803247:	c1 e0 02             	shl    $0x2,%eax
  80324a:	05 48 20 81 00       	add    $0x812048,%eax
  80324f:	8a 00                	mov    (%eax),%al
  803251:	84 c0                	test   %al,%al
  803253:	0f 84 4a 01 00 00    	je     8033a3 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  803259:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325c:	89 d0                	mov    %edx,%eax
  80325e:	01 c0                	add    %eax,%eax
  803260:	01 d0                	add    %edx,%eax
  803262:	c1 e0 02             	shl    $0x2,%eax
  803265:	05 40 20 81 00       	add    $0x812040,%eax
  80326a:	8b 08                	mov    (%eax),%ecx
  80326c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326f:	89 d0                	mov    %edx,%eax
  803271:	01 c0                	add    %eax,%eax
  803273:	01 d0                	add    %edx,%eax
  803275:	c1 e0 02             	shl    $0x2,%eax
  803278:	05 44 20 81 00       	add    $0x812044,%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	01 c1                	add    %eax,%ecx
  803281:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803284:	89 d0                	mov    %edx,%eax
  803286:	01 c0                	add    %eax,%eax
  803288:	01 d0                	add    %edx,%eax
  80328a:	c1 e0 02             	shl    $0x2,%eax
  80328d:	05 40 20 81 00       	add    $0x812040,%eax
  803292:	8b 00                	mov    (%eax),%eax
  803294:	39 c1                	cmp    %eax,%ecx
  803296:	75 7a                	jne    803312 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  803298:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329b:	89 d0                	mov    %edx,%eax
  80329d:	01 c0                	add    %eax,%eax
  80329f:	01 d0                	add    %edx,%eax
  8032a1:	c1 e0 02             	shl    $0x2,%eax
  8032a4:	05 40 20 81 00       	add    $0x812040,%eax
  8032a9:	8b 10                	mov    (%eax),%edx
  8032ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8032ae:	89 c8                	mov    %ecx,%eax
  8032b0:	01 c0                	add    %eax,%eax
  8032b2:	01 c8                	add    %ecx,%eax
  8032b4:	c1 e0 02             	shl    $0x2,%eax
  8032b7:	05 40 20 81 00       	add    $0x812040,%eax
  8032bc:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  8032be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c1:	89 d0                	mov    %edx,%eax
  8032c3:	01 c0                	add    %eax,%eax
  8032c5:	01 d0                	add    %edx,%eax
  8032c7:	c1 e0 02             	shl    $0x2,%eax
  8032ca:	05 44 20 81 00       	add    $0x812044,%eax
  8032cf:	8b 08                	mov    (%eax),%ecx
  8032d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d4:	89 d0                	mov    %edx,%eax
  8032d6:	01 c0                	add    %eax,%eax
  8032d8:	01 d0                	add    %edx,%eax
  8032da:	c1 e0 02             	shl    $0x2,%eax
  8032dd:	05 44 20 81 00       	add    $0x812044,%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	01 c1                	add    %eax,%ecx
  8032e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e9:	89 d0                	mov    %edx,%eax
  8032eb:	01 c0                	add    %eax,%eax
  8032ed:	01 d0                	add    %edx,%eax
  8032ef:	c1 e0 02             	shl    $0x2,%eax
  8032f2:	05 44 20 81 00       	add    $0x812044,%eax
  8032f7:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8032f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032fc:	89 d0                	mov    %edx,%eax
  8032fe:	01 c0                	add    %eax,%eax
  803300:	01 d0                	add    %edx,%eax
  803302:	c1 e0 02             	shl    $0x2,%eax
  803305:	05 48 20 81 00       	add    $0x812048,%eax
  80330a:	c6 00 00             	movb   $0x0,(%eax)
  80330d:	e9 91 00 00 00       	jmp    8033a3 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803312:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803315:	89 d0                	mov    %edx,%eax
  803317:	01 c0                	add    %eax,%eax
  803319:	01 d0                	add    %edx,%eax
  80331b:	c1 e0 02             	shl    $0x2,%eax
  80331e:	05 40 20 81 00       	add    $0x812040,%eax
  803323:	8b 08                	mov    (%eax),%ecx
  803325:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803328:	89 d0                	mov    %edx,%eax
  80332a:	01 c0                	add    %eax,%eax
  80332c:	01 d0                	add    %edx,%eax
  80332e:	c1 e0 02             	shl    $0x2,%eax
  803331:	05 44 20 81 00       	add    $0x812044,%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	01 c1                	add    %eax,%ecx
  80333a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333d:	89 d0                	mov    %edx,%eax
  80333f:	01 c0                	add    %eax,%eax
  803341:	01 d0                	add    %edx,%eax
  803343:	c1 e0 02             	shl    $0x2,%eax
  803346:	05 40 20 81 00       	add    $0x812040,%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	39 c1                	cmp    %eax,%ecx
  80334f:	75 52                	jne    8033a3 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803351:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803354:	89 d0                	mov    %edx,%eax
  803356:	01 c0                	add    %eax,%eax
  803358:	01 d0                	add    %edx,%eax
  80335a:	c1 e0 02             	shl    $0x2,%eax
  80335d:	05 44 20 81 00       	add    $0x812044,%eax
  803362:	8b 08                	mov    (%eax),%ecx
  803364:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803367:	89 d0                	mov    %edx,%eax
  803369:	01 c0                	add    %eax,%eax
  80336b:	01 d0                	add    %edx,%eax
  80336d:	c1 e0 02             	shl    $0x2,%eax
  803370:	05 44 20 81 00       	add    $0x812044,%eax
  803375:	8b 00                	mov    (%eax),%eax
  803377:	01 c1                	add    %eax,%ecx
  803379:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80337c:	89 d0                	mov    %edx,%eax
  80337e:	01 c0                	add    %eax,%eax
  803380:	01 d0                	add    %edx,%eax
  803382:	c1 e0 02             	shl    $0x2,%eax
  803385:	05 44 20 81 00       	add    $0x812044,%eax
  80338a:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  80338c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80338f:	89 d0                	mov    %edx,%eax
  803391:	01 c0                	add    %eax,%eax
  803393:	01 d0                	add    %edx,%eax
  803395:	c1 e0 02             	shl    $0x2,%eax
  803398:	05 48 20 81 00       	add    $0x812048,%eax
  80339d:	c6 00 00             	movb   $0x0,(%eax)
  8033a0:	eb 01                	jmp    8033a3 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  8033a2:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8033a3:	ff 45 e8             	incl   -0x18(%ebp)
  8033a6:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8033ad:	0f 8e 7f fe ff ff    	jle    803232 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  8033b3:	a1 30 61 83 00       	mov    0x836130,%eax
  8033b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8033bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033c2:	eb 53                	jmp    803417 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  8033c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033c7:	89 d0                	mov    %edx,%eax
  8033c9:	01 c0                	add    %eax,%eax
  8033cb:	01 d0                	add    %edx,%eax
  8033cd:	c1 e0 02             	shl    $0x2,%eax
  8033d0:	05 48 60 80 00       	add    $0x806048,%eax
  8033d5:	8a 00                	mov    (%eax),%al
  8033d7:	84 c0                	test   %al,%al
  8033d9:	74 39                	je     803414 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8033db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033de:	89 d0                	mov    %edx,%eax
  8033e0:	01 c0                	add    %eax,%eax
  8033e2:	01 d0                	add    %edx,%eax
  8033e4:	c1 e0 02             	shl    $0x2,%eax
  8033e7:	05 40 60 80 00       	add    $0x806040,%eax
  8033ec:	8b 08                	mov    (%eax),%ecx
  8033ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033f1:	89 d0                	mov    %edx,%eax
  8033f3:	01 c0                	add    %eax,%eax
  8033f5:	01 d0                	add    %edx,%eax
  8033f7:	c1 e0 02             	shl    $0x2,%eax
  8033fa:	05 44 60 80 00       	add    $0x806044,%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	01 c8                	add    %ecx,%eax
  803403:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803406:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803409:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80340c:	76 06                	jbe    803414 <sfree+0x321>
  80340e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803414:	ff 45 e0             	incl   -0x20(%ebp)
  803417:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80341e:	7e a4                	jle    8033c4 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803423:	a3 8c 60 83 00       	mov    %eax,0x83608c
			break;
  803428:	eb 16                	jmp    803440 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80342a:	ff 45 f4             	incl   -0xc(%ebp)
  80342d:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803434:	0f 8e 04 fd ff ff    	jle    80313e <sfree+0x4b>
  80343a:	eb 04                	jmp    803440 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  80343c:	90                   	nop
  80343d:	eb 01                	jmp    803440 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  80343f:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803440:	c9                   	leave  
  803441:	c3                   	ret    

00803442 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803442:	55                   	push   %ebp
  803443:	89 e5                	mov    %esp,%ebp
  803445:	57                   	push   %edi
  803446:	56                   	push   %esi
  803447:	53                   	push   %ebx
  803448:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803451:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803454:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803457:	8b 7d 18             	mov    0x18(%ebp),%edi
  80345a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80345d:	cd 30                	int    $0x30
  80345f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803462:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803465:	83 c4 10             	add    $0x10,%esp
  803468:	5b                   	pop    %ebx
  803469:	5e                   	pop    %esi
  80346a:	5f                   	pop    %edi
  80346b:	5d                   	pop    %ebp
  80346c:	c3                   	ret    

0080346d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80346d:	55                   	push   %ebp
  80346e:	89 e5                	mov    %esp,%ebp
  803470:	83 ec 04             	sub    $0x4,%esp
  803473:	8b 45 10             	mov    0x10(%ebp),%eax
  803476:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803479:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80347c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	6a 00                	push   $0x0
  803485:	51                   	push   %ecx
  803486:	52                   	push   %edx
  803487:	ff 75 0c             	pushl  0xc(%ebp)
  80348a:	50                   	push   %eax
  80348b:	6a 00                	push   $0x0
  80348d:	e8 b0 ff ff ff       	call   803442 <syscall>
  803492:	83 c4 18             	add    $0x18,%esp
}
  803495:	90                   	nop
  803496:	c9                   	leave  
  803497:	c3                   	ret    

00803498 <sys_cgetc>:

int
sys_cgetc(void)
{
  803498:	55                   	push   %ebp
  803499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80349b:	6a 00                	push   $0x0
  80349d:	6a 00                	push   $0x0
  80349f:	6a 00                	push   $0x0
  8034a1:	6a 00                	push   $0x0
  8034a3:	6a 00                	push   $0x0
  8034a5:	6a 02                	push   $0x2
  8034a7:	e8 96 ff ff ff       	call   803442 <syscall>
  8034ac:	83 c4 18             	add    $0x18,%esp
}
  8034af:	c9                   	leave  
  8034b0:	c3                   	ret    

008034b1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8034b1:	55                   	push   %ebp
  8034b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8034b4:	6a 00                	push   $0x0
  8034b6:	6a 00                	push   $0x0
  8034b8:	6a 00                	push   $0x0
  8034ba:	6a 00                	push   $0x0
  8034bc:	6a 00                	push   $0x0
  8034be:	6a 03                	push   $0x3
  8034c0:	e8 7d ff ff ff       	call   803442 <syscall>
  8034c5:	83 c4 18             	add    $0x18,%esp
}
  8034c8:	90                   	nop
  8034c9:	c9                   	leave  
  8034ca:	c3                   	ret    

008034cb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8034cb:	55                   	push   %ebp
  8034cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8034ce:	6a 00                	push   $0x0
  8034d0:	6a 00                	push   $0x0
  8034d2:	6a 00                	push   $0x0
  8034d4:	6a 00                	push   $0x0
  8034d6:	6a 00                	push   $0x0
  8034d8:	6a 04                	push   $0x4
  8034da:	e8 63 ff ff ff       	call   803442 <syscall>
  8034df:	83 c4 18             	add    $0x18,%esp
}
  8034e2:	90                   	nop
  8034e3:	c9                   	leave  
  8034e4:	c3                   	ret    

008034e5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8034e5:	55                   	push   %ebp
  8034e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8034e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	6a 00                	push   $0x0
  8034f0:	6a 00                	push   $0x0
  8034f2:	6a 00                	push   $0x0
  8034f4:	52                   	push   %edx
  8034f5:	50                   	push   %eax
  8034f6:	6a 08                	push   $0x8
  8034f8:	e8 45 ff ff ff       	call   803442 <syscall>
  8034fd:	83 c4 18             	add    $0x18,%esp
}
  803500:	c9                   	leave  
  803501:	c3                   	ret    

00803502 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803502:	55                   	push   %ebp
  803503:	89 e5                	mov    %esp,%ebp
  803505:	56                   	push   %esi
  803506:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803507:	8b 75 18             	mov    0x18(%ebp),%esi
  80350a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80350d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803510:	8b 55 0c             	mov    0xc(%ebp),%edx
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	56                   	push   %esi
  803517:	53                   	push   %ebx
  803518:	51                   	push   %ecx
  803519:	52                   	push   %edx
  80351a:	50                   	push   %eax
  80351b:	6a 09                	push   $0x9
  80351d:	e8 20 ff ff ff       	call   803442 <syscall>
  803522:	83 c4 18             	add    $0x18,%esp
}
  803525:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803528:	5b                   	pop    %ebx
  803529:	5e                   	pop    %esi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    

0080352c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80352c:	55                   	push   %ebp
  80352d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80352f:	6a 00                	push   $0x0
  803531:	6a 00                	push   $0x0
  803533:	6a 00                	push   $0x0
  803535:	6a 00                	push   $0x0
  803537:	ff 75 08             	pushl  0x8(%ebp)
  80353a:	6a 0a                	push   $0xa
  80353c:	e8 01 ff ff ff       	call   803442 <syscall>
  803541:	83 c4 18             	add    $0x18,%esp
}
  803544:	c9                   	leave  
  803545:	c3                   	ret    

00803546 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803546:	55                   	push   %ebp
  803547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803549:	6a 00                	push   $0x0
  80354b:	6a 00                	push   $0x0
  80354d:	6a 00                	push   $0x0
  80354f:	ff 75 0c             	pushl  0xc(%ebp)
  803552:	ff 75 08             	pushl  0x8(%ebp)
  803555:	6a 0b                	push   $0xb
  803557:	e8 e6 fe ff ff       	call   803442 <syscall>
  80355c:	83 c4 18             	add    $0x18,%esp
}
  80355f:	c9                   	leave  
  803560:	c3                   	ret    

00803561 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803561:	55                   	push   %ebp
  803562:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803564:	6a 00                	push   $0x0
  803566:	6a 00                	push   $0x0
  803568:	6a 00                	push   $0x0
  80356a:	6a 00                	push   $0x0
  80356c:	6a 00                	push   $0x0
  80356e:	6a 0c                	push   $0xc
  803570:	e8 cd fe ff ff       	call   803442 <syscall>
  803575:	83 c4 18             	add    $0x18,%esp
}
  803578:	c9                   	leave  
  803579:	c3                   	ret    

0080357a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80357a:	55                   	push   %ebp
  80357b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80357d:	6a 00                	push   $0x0
  80357f:	6a 00                	push   $0x0
  803581:	6a 00                	push   $0x0
  803583:	6a 00                	push   $0x0
  803585:	6a 00                	push   $0x0
  803587:	6a 0d                	push   $0xd
  803589:	e8 b4 fe ff ff       	call   803442 <syscall>
  80358e:	83 c4 18             	add    $0x18,%esp
}
  803591:	c9                   	leave  
  803592:	c3                   	ret    

00803593 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803593:	55                   	push   %ebp
  803594:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803596:	6a 00                	push   $0x0
  803598:	6a 00                	push   $0x0
  80359a:	6a 00                	push   $0x0
  80359c:	6a 00                	push   $0x0
  80359e:	6a 00                	push   $0x0
  8035a0:	6a 0e                	push   $0xe
  8035a2:	e8 9b fe ff ff       	call   803442 <syscall>
  8035a7:	83 c4 18             	add    $0x18,%esp
}
  8035aa:	c9                   	leave  
  8035ab:	c3                   	ret    

008035ac <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8035ac:	55                   	push   %ebp
  8035ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8035af:	6a 00                	push   $0x0
  8035b1:	6a 00                	push   $0x0
  8035b3:	6a 00                	push   $0x0
  8035b5:	6a 00                	push   $0x0
  8035b7:	6a 00                	push   $0x0
  8035b9:	6a 0f                	push   $0xf
  8035bb:	e8 82 fe ff ff       	call   803442 <syscall>
  8035c0:	83 c4 18             	add    $0x18,%esp
}
  8035c3:	c9                   	leave  
  8035c4:	c3                   	ret    

008035c5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8035c5:	55                   	push   %ebp
  8035c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8035c8:	6a 00                	push   $0x0
  8035ca:	6a 00                	push   $0x0
  8035cc:	6a 00                	push   $0x0
  8035ce:	6a 00                	push   $0x0
  8035d0:	ff 75 08             	pushl  0x8(%ebp)
  8035d3:	6a 10                	push   $0x10
  8035d5:	e8 68 fe ff ff       	call   803442 <syscall>
  8035da:	83 c4 18             	add    $0x18,%esp
}
  8035dd:	c9                   	leave  
  8035de:	c3                   	ret    

008035df <sys_scarce_memory>:

void sys_scarce_memory()
{
  8035df:	55                   	push   %ebp
  8035e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8035e2:	6a 00                	push   $0x0
  8035e4:	6a 00                	push   $0x0
  8035e6:	6a 00                	push   $0x0
  8035e8:	6a 00                	push   $0x0
  8035ea:	6a 00                	push   $0x0
  8035ec:	6a 11                	push   $0x11
  8035ee:	e8 4f fe ff ff       	call   803442 <syscall>
  8035f3:	83 c4 18             	add    $0x18,%esp
}
  8035f6:	90                   	nop
  8035f7:	c9                   	leave  
  8035f8:	c3                   	ret    

008035f9 <sys_cputc>:

void
sys_cputc(const char c)
{
  8035f9:	55                   	push   %ebp
  8035fa:	89 e5                	mov    %esp,%ebp
  8035fc:	83 ec 04             	sub    $0x4,%esp
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803605:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803609:	6a 00                	push   $0x0
  80360b:	6a 00                	push   $0x0
  80360d:	6a 00                	push   $0x0
  80360f:	6a 00                	push   $0x0
  803611:	50                   	push   %eax
  803612:	6a 01                	push   $0x1
  803614:	e8 29 fe ff ff       	call   803442 <syscall>
  803619:	83 c4 18             	add    $0x18,%esp
}
  80361c:	90                   	nop
  80361d:	c9                   	leave  
  80361e:	c3                   	ret    

0080361f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80361f:	55                   	push   %ebp
  803620:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803622:	6a 00                	push   $0x0
  803624:	6a 00                	push   $0x0
  803626:	6a 00                	push   $0x0
  803628:	6a 00                	push   $0x0
  80362a:	6a 00                	push   $0x0
  80362c:	6a 14                	push   $0x14
  80362e:	e8 0f fe ff ff       	call   803442 <syscall>
  803633:	83 c4 18             	add    $0x18,%esp
}
  803636:	90                   	nop
  803637:	c9                   	leave  
  803638:	c3                   	ret    

00803639 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803639:	55                   	push   %ebp
  80363a:	89 e5                	mov    %esp,%ebp
  80363c:	83 ec 04             	sub    $0x4,%esp
  80363f:	8b 45 10             	mov    0x10(%ebp),%eax
  803642:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803645:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803648:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	6a 00                	push   $0x0
  803651:	51                   	push   %ecx
  803652:	52                   	push   %edx
  803653:	ff 75 0c             	pushl  0xc(%ebp)
  803656:	50                   	push   %eax
  803657:	6a 15                	push   $0x15
  803659:	e8 e4 fd ff ff       	call   803442 <syscall>
  80365e:	83 c4 18             	add    $0x18,%esp
}
  803661:	c9                   	leave  
  803662:	c3                   	ret    

00803663 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803663:	55                   	push   %ebp
  803664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803666:	8b 55 0c             	mov    0xc(%ebp),%edx
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	6a 00                	push   $0x0
  80366e:	6a 00                	push   $0x0
  803670:	6a 00                	push   $0x0
  803672:	52                   	push   %edx
  803673:	50                   	push   %eax
  803674:	6a 16                	push   $0x16
  803676:	e8 c7 fd ff ff       	call   803442 <syscall>
  80367b:	83 c4 18             	add    $0x18,%esp
}
  80367e:	c9                   	leave  
  80367f:	c3                   	ret    

00803680 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803680:	55                   	push   %ebp
  803681:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803683:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803686:	8b 55 0c             	mov    0xc(%ebp),%edx
  803689:	8b 45 08             	mov    0x8(%ebp),%eax
  80368c:	6a 00                	push   $0x0
  80368e:	6a 00                	push   $0x0
  803690:	51                   	push   %ecx
  803691:	52                   	push   %edx
  803692:	50                   	push   %eax
  803693:	6a 17                	push   $0x17
  803695:	e8 a8 fd ff ff       	call   803442 <syscall>
  80369a:	83 c4 18             	add    $0x18,%esp
}
  80369d:	c9                   	leave  
  80369e:	c3                   	ret    

0080369f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80369f:	55                   	push   %ebp
  8036a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8036a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	6a 00                	push   $0x0
  8036aa:	6a 00                	push   $0x0
  8036ac:	6a 00                	push   $0x0
  8036ae:	52                   	push   %edx
  8036af:	50                   	push   %eax
  8036b0:	6a 18                	push   $0x18
  8036b2:	e8 8b fd ff ff       	call   803442 <syscall>
  8036b7:	83 c4 18             	add    $0x18,%esp
}
  8036ba:	c9                   	leave  
  8036bb:	c3                   	ret    

008036bc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8036bc:	55                   	push   %ebp
  8036bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8036bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c2:	6a 00                	push   $0x0
  8036c4:	ff 75 14             	pushl  0x14(%ebp)
  8036c7:	ff 75 10             	pushl  0x10(%ebp)
  8036ca:	ff 75 0c             	pushl  0xc(%ebp)
  8036cd:	50                   	push   %eax
  8036ce:	6a 19                	push   $0x19
  8036d0:	e8 6d fd ff ff       	call   803442 <syscall>
  8036d5:	83 c4 18             	add    $0x18,%esp
}
  8036d8:	c9                   	leave  
  8036d9:	c3                   	ret    

008036da <sys_run_env>:

void sys_run_env(int32 envId)
{
  8036da:	55                   	push   %ebp
  8036db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8036dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e0:	6a 00                	push   $0x0
  8036e2:	6a 00                	push   $0x0
  8036e4:	6a 00                	push   $0x0
  8036e6:	6a 00                	push   $0x0
  8036e8:	50                   	push   %eax
  8036e9:	6a 1a                	push   $0x1a
  8036eb:	e8 52 fd ff ff       	call   803442 <syscall>
  8036f0:	83 c4 18             	add    $0x18,%esp
}
  8036f3:	90                   	nop
  8036f4:	c9                   	leave  
  8036f5:	c3                   	ret    

008036f6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8036f6:	55                   	push   %ebp
  8036f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8036f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fc:	6a 00                	push   $0x0
  8036fe:	6a 00                	push   $0x0
  803700:	6a 00                	push   $0x0
  803702:	6a 00                	push   $0x0
  803704:	50                   	push   %eax
  803705:	6a 1b                	push   $0x1b
  803707:	e8 36 fd ff ff       	call   803442 <syscall>
  80370c:	83 c4 18             	add    $0x18,%esp
}
  80370f:	c9                   	leave  
  803710:	c3                   	ret    

00803711 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803711:	55                   	push   %ebp
  803712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803714:	6a 00                	push   $0x0
  803716:	6a 00                	push   $0x0
  803718:	6a 00                	push   $0x0
  80371a:	6a 00                	push   $0x0
  80371c:	6a 00                	push   $0x0
  80371e:	6a 05                	push   $0x5
  803720:	e8 1d fd ff ff       	call   803442 <syscall>
  803725:	83 c4 18             	add    $0x18,%esp
}
  803728:	c9                   	leave  
  803729:	c3                   	ret    

0080372a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80372a:	55                   	push   %ebp
  80372b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80372d:	6a 00                	push   $0x0
  80372f:	6a 00                	push   $0x0
  803731:	6a 00                	push   $0x0
  803733:	6a 00                	push   $0x0
  803735:	6a 00                	push   $0x0
  803737:	6a 06                	push   $0x6
  803739:	e8 04 fd ff ff       	call   803442 <syscall>
  80373e:	83 c4 18             	add    $0x18,%esp
}
  803741:	c9                   	leave  
  803742:	c3                   	ret    

00803743 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803743:	55                   	push   %ebp
  803744:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803746:	6a 00                	push   $0x0
  803748:	6a 00                	push   $0x0
  80374a:	6a 00                	push   $0x0
  80374c:	6a 00                	push   $0x0
  80374e:	6a 00                	push   $0x0
  803750:	6a 07                	push   $0x7
  803752:	e8 eb fc ff ff       	call   803442 <syscall>
  803757:	83 c4 18             	add    $0x18,%esp
}
  80375a:	c9                   	leave  
  80375b:	c3                   	ret    

0080375c <sys_exit_env>:


void sys_exit_env(void)
{
  80375c:	55                   	push   %ebp
  80375d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80375f:	6a 00                	push   $0x0
  803761:	6a 00                	push   $0x0
  803763:	6a 00                	push   $0x0
  803765:	6a 00                	push   $0x0
  803767:	6a 00                	push   $0x0
  803769:	6a 1c                	push   $0x1c
  80376b:	e8 d2 fc ff ff       	call   803442 <syscall>
  803770:	83 c4 18             	add    $0x18,%esp
}
  803773:	90                   	nop
  803774:	c9                   	leave  
  803775:	c3                   	ret    

00803776 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803776:	55                   	push   %ebp
  803777:	89 e5                	mov    %esp,%ebp
  803779:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80377c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80377f:	8d 50 04             	lea    0x4(%eax),%edx
  803782:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803785:	6a 00                	push   $0x0
  803787:	6a 00                	push   $0x0
  803789:	6a 00                	push   $0x0
  80378b:	52                   	push   %edx
  80378c:	50                   	push   %eax
  80378d:	6a 1d                	push   $0x1d
  80378f:	e8 ae fc ff ff       	call   803442 <syscall>
  803794:	83 c4 18             	add    $0x18,%esp
	return result;
  803797:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80379a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80379d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037a0:	89 01                	mov    %eax,(%ecx)
  8037a2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	c9                   	leave  
  8037a9:	c2 04 00             	ret    $0x4

008037ac <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8037ac:	55                   	push   %ebp
  8037ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8037af:	6a 00                	push   $0x0
  8037b1:	6a 00                	push   $0x0
  8037b3:	ff 75 10             	pushl  0x10(%ebp)
  8037b6:	ff 75 0c             	pushl  0xc(%ebp)
  8037b9:	ff 75 08             	pushl  0x8(%ebp)
  8037bc:	6a 13                	push   $0x13
  8037be:	e8 7f fc ff ff       	call   803442 <syscall>
  8037c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8037c6:	90                   	nop
}
  8037c7:	c9                   	leave  
  8037c8:	c3                   	ret    

008037c9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8037c9:	55                   	push   %ebp
  8037ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8037cc:	6a 00                	push   $0x0
  8037ce:	6a 00                	push   $0x0
  8037d0:	6a 00                	push   $0x0
  8037d2:	6a 00                	push   $0x0
  8037d4:	6a 00                	push   $0x0
  8037d6:	6a 1e                	push   $0x1e
  8037d8:	e8 65 fc ff ff       	call   803442 <syscall>
  8037dd:	83 c4 18             	add    $0x18,%esp
}
  8037e0:	c9                   	leave  
  8037e1:	c3                   	ret    

008037e2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8037e2:	55                   	push   %ebp
  8037e3:	89 e5                	mov    %esp,%ebp
  8037e5:	83 ec 04             	sub    $0x4,%esp
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8037ee:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8037f2:	6a 00                	push   $0x0
  8037f4:	6a 00                	push   $0x0
  8037f6:	6a 00                	push   $0x0
  8037f8:	6a 00                	push   $0x0
  8037fa:	50                   	push   %eax
  8037fb:	6a 1f                	push   $0x1f
  8037fd:	e8 40 fc ff ff       	call   803442 <syscall>
  803802:	83 c4 18             	add    $0x18,%esp
	return ;
  803805:	90                   	nop
}
  803806:	c9                   	leave  
  803807:	c3                   	ret    

00803808 <rsttst>:
void rsttst()
{
  803808:	55                   	push   %ebp
  803809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80380b:	6a 00                	push   $0x0
  80380d:	6a 00                	push   $0x0
  80380f:	6a 00                	push   $0x0
  803811:	6a 00                	push   $0x0
  803813:	6a 00                	push   $0x0
  803815:	6a 21                	push   $0x21
  803817:	e8 26 fc ff ff       	call   803442 <syscall>
  80381c:	83 c4 18             	add    $0x18,%esp
	return ;
  80381f:	90                   	nop
}
  803820:	c9                   	leave  
  803821:	c3                   	ret    

00803822 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803822:	55                   	push   %ebp
  803823:	89 e5                	mov    %esp,%ebp
  803825:	83 ec 04             	sub    $0x4,%esp
  803828:	8b 45 14             	mov    0x14(%ebp),%eax
  80382b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80382e:	8b 55 18             	mov    0x18(%ebp),%edx
  803831:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803835:	52                   	push   %edx
  803836:	50                   	push   %eax
  803837:	ff 75 10             	pushl  0x10(%ebp)
  80383a:	ff 75 0c             	pushl  0xc(%ebp)
  80383d:	ff 75 08             	pushl  0x8(%ebp)
  803840:	6a 20                	push   $0x20
  803842:	e8 fb fb ff ff       	call   803442 <syscall>
  803847:	83 c4 18             	add    $0x18,%esp
	return ;
  80384a:	90                   	nop
}
  80384b:	c9                   	leave  
  80384c:	c3                   	ret    

0080384d <chktst>:
void chktst(uint32 n)
{
  80384d:	55                   	push   %ebp
  80384e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803850:	6a 00                	push   $0x0
  803852:	6a 00                	push   $0x0
  803854:	6a 00                	push   $0x0
  803856:	6a 00                	push   $0x0
  803858:	ff 75 08             	pushl  0x8(%ebp)
  80385b:	6a 22                	push   $0x22
  80385d:	e8 e0 fb ff ff       	call   803442 <syscall>
  803862:	83 c4 18             	add    $0x18,%esp
	return ;
  803865:	90                   	nop
}
  803866:	c9                   	leave  
  803867:	c3                   	ret    

00803868 <inctst>:

void inctst()
{
  803868:	55                   	push   %ebp
  803869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80386b:	6a 00                	push   $0x0
  80386d:	6a 00                	push   $0x0
  80386f:	6a 00                	push   $0x0
  803871:	6a 00                	push   $0x0
  803873:	6a 00                	push   $0x0
  803875:	6a 23                	push   $0x23
  803877:	e8 c6 fb ff ff       	call   803442 <syscall>
  80387c:	83 c4 18             	add    $0x18,%esp
	return ;
  80387f:	90                   	nop
}
  803880:	c9                   	leave  
  803881:	c3                   	ret    

00803882 <gettst>:
uint32 gettst()
{
  803882:	55                   	push   %ebp
  803883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803885:	6a 00                	push   $0x0
  803887:	6a 00                	push   $0x0
  803889:	6a 00                	push   $0x0
  80388b:	6a 00                	push   $0x0
  80388d:	6a 00                	push   $0x0
  80388f:	6a 24                	push   $0x24
  803891:	e8 ac fb ff ff       	call   803442 <syscall>
  803896:	83 c4 18             	add    $0x18,%esp
}
  803899:	c9                   	leave  
  80389a:	c3                   	ret    

0080389b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80389b:	55                   	push   %ebp
  80389c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80389e:	6a 00                	push   $0x0
  8038a0:	6a 00                	push   $0x0
  8038a2:	6a 00                	push   $0x0
  8038a4:	6a 00                	push   $0x0
  8038a6:	6a 00                	push   $0x0
  8038a8:	6a 25                	push   $0x25
  8038aa:	e8 93 fb ff ff       	call   803442 <syscall>
  8038af:	83 c4 18             	add    $0x18,%esp
  8038b2:	a3 84 60 83 00       	mov    %eax,0x836084
	return uheapPlaceStrategy ;
  8038b7:	a1 84 60 83 00       	mov    0x836084,%eax
}
  8038bc:	c9                   	leave  
  8038bd:	c3                   	ret    

008038be <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8038be:	55                   	push   %ebp
  8038bf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	a3 84 60 83 00       	mov    %eax,0x836084
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8038c9:	6a 00                	push   $0x0
  8038cb:	6a 00                	push   $0x0
  8038cd:	6a 00                	push   $0x0
  8038cf:	6a 00                	push   $0x0
  8038d1:	ff 75 08             	pushl  0x8(%ebp)
  8038d4:	6a 26                	push   $0x26
  8038d6:	e8 67 fb ff ff       	call   803442 <syscall>
  8038db:	83 c4 18             	add    $0x18,%esp
	return ;
  8038de:	90                   	nop
}
  8038df:	c9                   	leave  
  8038e0:	c3                   	ret    

008038e1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8038e1:	55                   	push   %ebp
  8038e2:	89 e5                	mov    %esp,%ebp
  8038e4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8038e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8038e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8038eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f1:	6a 00                	push   $0x0
  8038f3:	53                   	push   %ebx
  8038f4:	51                   	push   %ecx
  8038f5:	52                   	push   %edx
  8038f6:	50                   	push   %eax
  8038f7:	6a 27                	push   $0x27
  8038f9:	e8 44 fb ff ff       	call   803442 <syscall>
  8038fe:	83 c4 18             	add    $0x18,%esp
}
  803901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803904:	c9                   	leave  
  803905:	c3                   	ret    

00803906 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803906:	55                   	push   %ebp
  803907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	6a 00                	push   $0x0
  803911:	6a 00                	push   $0x0
  803913:	6a 00                	push   $0x0
  803915:	52                   	push   %edx
  803916:	50                   	push   %eax
  803917:	6a 28                	push   $0x28
  803919:	e8 24 fb ff ff       	call   803442 <syscall>
  80391e:	83 c4 18             	add    $0x18,%esp
}
  803921:	c9                   	leave  
  803922:	c3                   	ret    

00803923 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803923:	55                   	push   %ebp
  803924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803926:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	6a 00                	push   $0x0
  803931:	51                   	push   %ecx
  803932:	ff 75 10             	pushl  0x10(%ebp)
  803935:	52                   	push   %edx
  803936:	50                   	push   %eax
  803937:	6a 29                	push   $0x29
  803939:	e8 04 fb ff ff       	call   803442 <syscall>
  80393e:	83 c4 18             	add    $0x18,%esp
}
  803941:	c9                   	leave  
  803942:	c3                   	ret    

00803943 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803943:	55                   	push   %ebp
  803944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803946:	6a 00                	push   $0x0
  803948:	6a 00                	push   $0x0
  80394a:	ff 75 10             	pushl  0x10(%ebp)
  80394d:	ff 75 0c             	pushl  0xc(%ebp)
  803950:	ff 75 08             	pushl  0x8(%ebp)
  803953:	6a 12                	push   $0x12
  803955:	e8 e8 fa ff ff       	call   803442 <syscall>
  80395a:	83 c4 18             	add    $0x18,%esp
	return ;
  80395d:	90                   	nop
}
  80395e:	c9                   	leave  
  80395f:	c3                   	ret    

00803960 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803960:	55                   	push   %ebp
  803961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803963:	8b 55 0c             	mov    0xc(%ebp),%edx
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	6a 00                	push   $0x0
  80396b:	6a 00                	push   $0x0
  80396d:	6a 00                	push   $0x0
  80396f:	52                   	push   %edx
  803970:	50                   	push   %eax
  803971:	6a 2a                	push   $0x2a
  803973:	e8 ca fa ff ff       	call   803442 <syscall>
  803978:	83 c4 18             	add    $0x18,%esp
	return;
  80397b:	90                   	nop
}
  80397c:	c9                   	leave  
  80397d:	c3                   	ret    

0080397e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80397e:	55                   	push   %ebp
  80397f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803981:	6a 00                	push   $0x0
  803983:	6a 00                	push   $0x0
  803985:	6a 00                	push   $0x0
  803987:	6a 00                	push   $0x0
  803989:	6a 00                	push   $0x0
  80398b:	6a 2b                	push   $0x2b
  80398d:	e8 b0 fa ff ff       	call   803442 <syscall>
  803992:	83 c4 18             	add    $0x18,%esp
}
  803995:	c9                   	leave  
  803996:	c3                   	ret    

00803997 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803997:	55                   	push   %ebp
  803998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80399a:	6a 00                	push   $0x0
  80399c:	6a 00                	push   $0x0
  80399e:	6a 00                	push   $0x0
  8039a0:	ff 75 0c             	pushl  0xc(%ebp)
  8039a3:	ff 75 08             	pushl  0x8(%ebp)
  8039a6:	6a 2d                	push   $0x2d
  8039a8:	e8 95 fa ff ff       	call   803442 <syscall>
  8039ad:	83 c4 18             	add    $0x18,%esp
	return;
  8039b0:	90                   	nop
}
  8039b1:	c9                   	leave  
  8039b2:	c3                   	ret    

008039b3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8039b3:	55                   	push   %ebp
  8039b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8039b6:	6a 00                	push   $0x0
  8039b8:	6a 00                	push   $0x0
  8039ba:	6a 00                	push   $0x0
  8039bc:	ff 75 0c             	pushl  0xc(%ebp)
  8039bf:	ff 75 08             	pushl  0x8(%ebp)
  8039c2:	6a 2c                	push   $0x2c
  8039c4:	e8 79 fa ff ff       	call   803442 <syscall>
  8039c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8039cc:	90                   	nop
}
  8039cd:	c9                   	leave  
  8039ce:	c3                   	ret    

008039cf <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8039cf:	55                   	push   %ebp
  8039d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8039d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d8:	6a 00                	push   $0x0
  8039da:	6a 00                	push   $0x0
  8039dc:	6a 00                	push   $0x0
  8039de:	52                   	push   %edx
  8039df:	50                   	push   %eax
  8039e0:	6a 2e                	push   $0x2e
  8039e2:	e8 5b fa ff ff       	call   803442 <syscall>
  8039e7:	83 c4 18             	add    $0x18,%esp
}
  8039ea:	90                   	nop
  8039eb:	c9                   	leave  
  8039ec:	c3                   	ret    

008039ed <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8039ed:	55                   	push   %ebp
  8039ee:	89 e5                	mov    %esp,%ebp
  8039f0:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8039f3:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  8039fa:	72 09                	jb     803a05 <to_page_va+0x18>
  8039fc:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803a03:	72 14                	jb     803a19 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803a05:	83 ec 04             	sub    $0x4,%esp
  803a08:	68 0c 50 80 00       	push   $0x80500c
  803a0d:	6a 15                	push   $0x15
  803a0f:	68 37 50 80 00       	push   $0x805037
  803a14:	e8 08 ce ff ff       	call   800821 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803a19:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1c:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803a21:	29 d0                	sub    %edx,%eax
  803a23:	c1 f8 02             	sar    $0x2,%eax
  803a26:	89 c2                	mov    %eax,%edx
  803a28:	89 d0                	mov    %edx,%eax
  803a2a:	c1 e0 02             	shl    $0x2,%eax
  803a2d:	01 d0                	add    %edx,%eax
  803a2f:	c1 e0 02             	shl    $0x2,%eax
  803a32:	01 d0                	add    %edx,%eax
  803a34:	c1 e0 02             	shl    $0x2,%eax
  803a37:	01 d0                	add    %edx,%eax
  803a39:	89 c1                	mov    %eax,%ecx
  803a3b:	c1 e1 08             	shl    $0x8,%ecx
  803a3e:	01 c8                	add    %ecx,%eax
  803a40:	89 c1                	mov    %eax,%ecx
  803a42:	c1 e1 10             	shl    $0x10,%ecx
  803a45:	01 c8                	add    %ecx,%eax
  803a47:	01 c0                	add    %eax,%eax
  803a49:	01 d0                	add    %edx,%eax
  803a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a51:	c1 e0 0c             	shl    $0xc,%eax
  803a54:	89 c2                	mov    %eax,%edx
  803a56:	a1 88 60 83 00       	mov    0x836088,%eax
  803a5b:	01 d0                	add    %edx,%eax
}
  803a5d:	c9                   	leave  
  803a5e:	c3                   	ret    

00803a5f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803a5f:	55                   	push   %ebp
  803a60:	89 e5                	mov    %esp,%ebp
  803a62:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803a65:	a1 88 60 83 00       	mov    0x836088,%eax
  803a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a6d:	29 c2                	sub    %eax,%edx
  803a6f:	89 d0                	mov    %edx,%eax
  803a71:	c1 e8 0c             	shr    $0xc,%eax
  803a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a7b:	78 09                	js     803a86 <to_page_info+0x27>
  803a7d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803a84:	7e 14                	jle    803a9a <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803a86:	83 ec 04             	sub    $0x4,%esp
  803a89:	68 50 50 80 00       	push   $0x805050
  803a8e:	6a 21                	push   $0x21
  803a90:	68 37 50 80 00       	push   $0x805037
  803a95:	e8 87 cd ff ff       	call   800821 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a9d:	89 d0                	mov    %edx,%eax
  803a9f:	01 c0                	add    %eax,%eax
  803aa1:	01 d0                	add    %edx,%eax
  803aa3:	c1 e0 02             	shl    $0x2,%eax
  803aa6:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803aab:	c9                   	leave  
  803aac:	c3                   	ret    

00803aad <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803aad:	55                   	push   %ebp
  803aae:	89 e5                	mov    %esp,%ebp
  803ab0:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab6:	05 00 00 00 02       	add    $0x2000000,%eax
  803abb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803abe:	73 16                	jae    803ad6 <initialize_dynamic_allocator+0x29>
  803ac0:	68 74 50 80 00       	push   $0x805074
  803ac5:	68 9a 50 80 00       	push   $0x80509a
  803aca:	6a 2f                	push   $0x2f
  803acc:	68 37 50 80 00       	push   $0x805037
  803ad1:	e8 4b cd ff ff       	call   800821 <_panic>
	dynAllocStart = daStart;
  803ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad9:	a3 88 60 83 00       	mov    %eax,0x836088
	dynAllocEnd = daEnd;
  803ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ae1:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803ae6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803aed:	eb 36                	jmp    803b25 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af2:	c1 e0 04             	shl    $0x4,%eax
  803af5:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803afa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b03:	c1 e0 04             	shl    $0x4,%eax
  803b06:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b14:	c1 e0 04             	shl    $0x4,%eax
  803b17:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803b1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803b22:	ff 45 f4             	incl   -0xc(%ebp)
  803b25:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803b29:	7e c4                	jle    803aef <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803b2b:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803b32:	00 00 00 
  803b35:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803b3c:	00 00 00 
  803b3f:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803b46:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803b49:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b50:	e9 1b 01 00 00       	jmp    803c70 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b58:	89 d0                	mov    %edx,%eax
  803b5a:	01 c0                	add    %eax,%eax
  803b5c:	01 d0                	add    %edx,%eax
  803b5e:	c1 e0 02             	shl    $0x2,%eax
  803b61:	05 88 e0 81 00       	add    $0x81e088,%eax
  803b66:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803b6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b6e:	89 d0                	mov    %edx,%eax
  803b70:	01 c0                	add    %eax,%eax
  803b72:	01 d0                	add    %edx,%eax
  803b74:	c1 e0 02             	shl    $0x2,%eax
  803b77:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803b7c:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803b81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b84:	89 d0                	mov    %edx,%eax
  803b86:	01 c0                	add    %eax,%eax
  803b88:	01 d0                	add    %edx,%eax
  803b8a:	c1 e0 02             	shl    $0x2,%eax
  803b8d:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b92:	8b 00                	mov    (%eax),%eax
  803b94:	85 c0                	test   %eax,%eax
  803b96:	74 2b                	je     803bc3 <initialize_dynamic_allocator+0x116>
  803b98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b9b:	89 d0                	mov    %edx,%eax
  803b9d:	01 c0                	add    %eax,%eax
  803b9f:	01 d0                	add    %edx,%eax
  803ba1:	c1 e0 02             	shl    $0x2,%eax
  803ba4:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ba9:	8b 10                	mov    (%eax),%edx
  803bab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803bae:	89 c8                	mov    %ecx,%eax
  803bb0:	01 c0                	add    %eax,%eax
  803bb2:	01 c8                	add    %ecx,%eax
  803bb4:	c1 e0 02             	shl    $0x2,%eax
  803bb7:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bbc:	8b 00                	mov    (%eax),%eax
  803bbe:	89 42 04             	mov    %eax,0x4(%edx)
  803bc1:	eb 18                	jmp    803bdb <initialize_dynamic_allocator+0x12e>
  803bc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bc6:	89 d0                	mov    %edx,%eax
  803bc8:	01 c0                	add    %eax,%eax
  803bca:	01 d0                	add    %edx,%eax
  803bcc:	c1 e0 02             	shl    $0x2,%eax
  803bcf:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bd4:	8b 00                	mov    (%eax),%eax
  803bd6:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803bdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bde:	89 d0                	mov    %edx,%eax
  803be0:	01 c0                	add    %eax,%eax
  803be2:	01 d0                	add    %edx,%eax
  803be4:	c1 e0 02             	shl    $0x2,%eax
  803be7:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bec:	8b 00                	mov    (%eax),%eax
  803bee:	85 c0                	test   %eax,%eax
  803bf0:	74 2a                	je     803c1c <initialize_dynamic_allocator+0x16f>
  803bf2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bf5:	89 d0                	mov    %edx,%eax
  803bf7:	01 c0                	add    %eax,%eax
  803bf9:	01 d0                	add    %edx,%eax
  803bfb:	c1 e0 02             	shl    $0x2,%eax
  803bfe:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c03:	8b 10                	mov    (%eax),%edx
  803c05:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803c08:	89 c8                	mov    %ecx,%eax
  803c0a:	01 c0                	add    %eax,%eax
  803c0c:	01 c8                	add    %ecx,%eax
  803c0e:	c1 e0 02             	shl    $0x2,%eax
  803c11:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c16:	8b 00                	mov    (%eax),%eax
  803c18:	89 02                	mov    %eax,(%edx)
  803c1a:	eb 18                	jmp    803c34 <initialize_dynamic_allocator+0x187>
  803c1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c1f:	89 d0                	mov    %edx,%eax
  803c21:	01 c0                	add    %eax,%eax
  803c23:	01 d0                	add    %edx,%eax
  803c25:	c1 e0 02             	shl    $0x2,%eax
  803c28:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c2d:	8b 00                	mov    (%eax),%eax
  803c2f:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803c34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c37:	89 d0                	mov    %edx,%eax
  803c39:	01 c0                	add    %eax,%eax
  803c3b:	01 d0                	add    %edx,%eax
  803c3d:	c1 e0 02             	shl    $0x2,%eax
  803c40:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c4e:	89 d0                	mov    %edx,%eax
  803c50:	01 c0                	add    %eax,%eax
  803c52:	01 d0                	add    %edx,%eax
  803c54:	c1 e0 02             	shl    $0x2,%eax
  803c57:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c62:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803c67:	48                   	dec    %eax
  803c68:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803c6d:	ff 45 f0             	incl   -0x10(%ebp)
  803c70:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803c77:	0f 8e d8 fe ff ff    	jle    803b55 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803c7d:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803c84:	e9 9d 00 00 00       	jmp    803d26 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803c89:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803c8f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c92:	89 c8                	mov    %ecx,%eax
  803c94:	01 c0                	add    %eax,%eax
  803c96:	01 c8                	add    %ecx,%eax
  803c98:	c1 e0 02             	shl    $0x2,%eax
  803c9b:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ca0:	89 10                	mov    %edx,(%eax)
  803ca2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ca5:	89 d0                	mov    %edx,%eax
  803ca7:	01 c0                	add    %eax,%eax
  803ca9:	01 d0                	add    %edx,%eax
  803cab:	c1 e0 02             	shl    $0x2,%eax
  803cae:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cb3:	8b 00                	mov    (%eax),%eax
  803cb5:	85 c0                	test   %eax,%eax
  803cb7:	74 1c                	je     803cd5 <initialize_dynamic_allocator+0x228>
  803cb9:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803cbf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803cc2:	89 c8                	mov    %ecx,%eax
  803cc4:	01 c0                	add    %eax,%eax
  803cc6:	01 c8                	add    %ecx,%eax
  803cc8:	c1 e0 02             	shl    $0x2,%eax
  803ccb:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cd0:	89 42 04             	mov    %eax,0x4(%edx)
  803cd3:	eb 16                	jmp    803ceb <initialize_dynamic_allocator+0x23e>
  803cd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cd8:	89 d0                	mov    %edx,%eax
  803cda:	01 c0                	add    %eax,%eax
  803cdc:	01 d0                	add    %edx,%eax
  803cde:	c1 e0 02             	shl    $0x2,%eax
  803ce1:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ce6:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803ceb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cee:	89 d0                	mov    %edx,%eax
  803cf0:	01 c0                	add    %eax,%eax
  803cf2:	01 d0                	add    %edx,%eax
  803cf4:	c1 e0 02             	shl    $0x2,%eax
  803cf7:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cfc:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803d01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d04:	89 d0                	mov    %edx,%eax
  803d06:	01 c0                	add    %eax,%eax
  803d08:	01 d0                	add    %edx,%eax
  803d0a:	c1 e0 02             	shl    $0x2,%eax
  803d0d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d18:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803d1d:	40                   	inc    %eax
  803d1e:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803d23:	ff 4d ec             	decl   -0x14(%ebp)
  803d26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d2a:	0f 89 59 ff ff ff    	jns    803c89 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803d30:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803d37:	00 00 00 
}
  803d3a:	90                   	nop
  803d3b:	c9                   	leave  
  803d3c:	c3                   	ret    

00803d3d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803d3d:	55                   	push   %ebp
  803d3e:	89 e5                	mov    %esp,%ebp
  803d40:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803d43:	8b 45 08             	mov    0x8(%ebp),%eax
  803d46:	83 ec 0c             	sub    $0xc,%esp
  803d49:	50                   	push   %eax
  803d4a:	e8 10 fd ff ff       	call   803a5f <to_page_info>
  803d4f:	83 c4 10             	add    $0x10,%esp
  803d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d58:	8b 40 08             	mov    0x8(%eax),%eax
  803d5b:	0f b7 c0             	movzwl %ax,%eax
}
  803d5e:	c9                   	leave  
  803d5f:	c3                   	ret    

00803d60 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803d60:	55                   	push   %ebp
  803d61:	89 e5                	mov    %esp,%ebp
  803d63:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803d66:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803d6d:	76 16                	jbe    803d85 <alloc_block+0x25>
  803d6f:	68 b0 50 80 00       	push   $0x8050b0
  803d74:	68 9a 50 80 00       	push   $0x80509a
  803d79:	6a 59                	push   $0x59
  803d7b:	68 37 50 80 00       	push   $0x805037
  803d80:	e8 9c ca ff ff       	call   800821 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803d85:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803d8c:	eb 08                	jmp    803d96 <alloc_block+0x36>
		allocSize <<= 1;
  803d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d91:	01 c0                	add    %eax,%eax
  803d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d99:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d9c:	73 09                	jae    803da7 <alloc_block+0x47>
  803d9e:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803da5:	76 e7                	jbe    803d8e <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803da7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803dae:	eb 03                	jmp    803db3 <alloc_block+0x53>
		listIndex++;
  803db0:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db6:	ba 08 00 00 00       	mov    $0x8,%edx
  803dbb:	88 c1                	mov    %al,%cl
  803dbd:	d3 e2                	shl    %cl,%edx
  803dbf:	89 d0                	mov    %edx,%eax
  803dc1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803dc4:	72 ea                	jb     803db0 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803dcc:	e9 f4 00 00 00       	jmp    803ec5 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dd4:	c1 e0 04             	shl    $0x4,%eax
  803dd7:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ddc:	8b 00                	mov    (%eax),%eax
  803dde:	85 c0                	test   %eax,%eax
  803de0:	0f 84 dc 00 00 00    	je     803ec2 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803de9:	c1 e0 04             	shl    $0x4,%eax
  803dec:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803df1:	8b 00                	mov    (%eax),%eax
  803df3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dfa:	75 14                	jne    803e10 <alloc_block+0xb0>
  803dfc:	83 ec 04             	sub    $0x4,%esp
  803dff:	68 d1 50 80 00       	push   $0x8050d1
  803e04:	6a 6b                	push   $0x6b
  803e06:	68 37 50 80 00       	push   $0x805037
  803e0b:	e8 11 ca ff ff       	call   800821 <_panic>
  803e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e13:	8b 00                	mov    (%eax),%eax
  803e15:	85 c0                	test   %eax,%eax
  803e17:	74 10                	je     803e29 <alloc_block+0xc9>
  803e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1c:	8b 00                	mov    (%eax),%eax
  803e1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e21:	8b 52 04             	mov    0x4(%edx),%edx
  803e24:	89 50 04             	mov    %edx,0x4(%eax)
  803e27:	eb 14                	jmp    803e3d <alloc_block+0xdd>
  803e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2c:	8b 40 04             	mov    0x4(%eax),%eax
  803e2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e32:	c1 e2 04             	shl    $0x4,%edx
  803e35:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803e3b:	89 02                	mov    %eax,(%edx)
  803e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e40:	8b 40 04             	mov    0x4(%eax),%eax
  803e43:	85 c0                	test   %eax,%eax
  803e45:	74 0f                	je     803e56 <alloc_block+0xf6>
  803e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e4a:	8b 40 04             	mov    0x4(%eax),%eax
  803e4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e50:	8b 12                	mov    (%edx),%edx
  803e52:	89 10                	mov    %edx,(%eax)
  803e54:	eb 13                	jmp    803e69 <alloc_block+0x109>
  803e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e59:	8b 00                	mov    (%eax),%eax
  803e5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e5e:	c1 e2 04             	shl    $0x4,%edx
  803e61:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803e67:	89 02                	mov    %eax,(%edx)
  803e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e7f:	c1 e0 04             	shl    $0x4,%eax
  803e82:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e87:	8b 00                	mov    (%eax),%eax
  803e89:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8f:	c1 e0 04             	shl    $0x4,%eax
  803e92:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e97:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9c:	83 ec 0c             	sub    $0xc,%esp
  803e9f:	50                   	push   %eax
  803ea0:	e8 ba fb ff ff       	call   803a5f <to_page_info>
  803ea5:	83 c4 10             	add    $0x10,%esp
  803ea8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803eab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eae:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803eb2:	48                   	dec    %eax
  803eb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803eb6:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ebd:	e9 8f 02 00 00       	jmp    804151 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803ec2:	ff 45 ec             	incl   -0x14(%ebp)
  803ec5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803ec9:	0f 8e 02 ff ff ff    	jle    803dd1 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803ecf:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803ed4:	85 c0                	test   %eax,%eax
  803ed6:	75 14                	jne    803eec <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803ed8:	83 ec 04             	sub    $0x4,%esp
  803edb:	68 f0 50 80 00       	push   $0x8050f0
  803ee0:	6a 77                	push   $0x77
  803ee2:	68 37 50 80 00       	push   $0x805037
  803ee7:	e8 35 c9 ff ff       	call   800821 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803eec:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803ef1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803ef4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ef8:	75 14                	jne    803f0e <alloc_block+0x1ae>
  803efa:	83 ec 04             	sub    $0x4,%esp
  803efd:	68 d1 50 80 00       	push   $0x8050d1
  803f02:	6a 7a                	push   $0x7a
  803f04:	68 37 50 80 00       	push   $0x805037
  803f09:	e8 13 c9 ff ff       	call   800821 <_panic>
  803f0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f11:	8b 00                	mov    (%eax),%eax
  803f13:	85 c0                	test   %eax,%eax
  803f15:	74 10                	je     803f27 <alloc_block+0x1c7>
  803f17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f1a:	8b 00                	mov    (%eax),%eax
  803f1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f1f:	8b 52 04             	mov    0x4(%edx),%edx
  803f22:	89 50 04             	mov    %edx,0x4(%eax)
  803f25:	eb 0b                	jmp    803f32 <alloc_block+0x1d2>
  803f27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f2a:	8b 40 04             	mov    0x4(%eax),%eax
  803f2d:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803f32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f35:	8b 40 04             	mov    0x4(%eax),%eax
  803f38:	85 c0                	test   %eax,%eax
  803f3a:	74 0f                	je     803f4b <alloc_block+0x1eb>
  803f3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f3f:	8b 40 04             	mov    0x4(%eax),%eax
  803f42:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f45:	8b 12                	mov    (%edx),%edx
  803f47:	89 10                	mov    %edx,(%eax)
  803f49:	eb 0a                	jmp    803f55 <alloc_block+0x1f5>
  803f4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f4e:	8b 00                	mov    (%eax),%eax
  803f50:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803f55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f68:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803f6d:	48                   	dec    %eax
  803f6e:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803f73:	83 ec 0c             	sub    $0xc,%esp
  803f76:	ff 75 dc             	pushl  -0x24(%ebp)
  803f79:	e8 6f fa ff ff       	call   8039ed <to_page_va>
  803f7e:	83 c4 10             	add    $0x10,%esp
  803f81:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803f84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f87:	83 ec 0c             	sub    $0xc,%esp
  803f8a:	50                   	push   %eax
  803f8b:	e8 a0 dc ff ff       	call   801c30 <get_page>
  803f90:	83 c4 10             	add    $0x10,%esp
  803f93:	85 c0                	test   %eax,%eax
  803f95:	74 14                	je     803fab <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803f97:	83 ec 04             	sub    $0x4,%esp
  803f9a:	68 18 51 80 00       	push   $0x805118
  803f9f:	6a 7f                	push   $0x7f
  803fa1:	68 37 50 80 00       	push   $0x805037
  803fa6:	e8 76 c8 ff ff       	call   800821 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803fb1:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803fb5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803fba:	ba 00 00 00 00       	mov    $0x0,%edx
  803fbf:	f7 75 f4             	divl   -0xc(%ebp)
  803fc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803fc5:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803fc9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803fd0:	e9 a7 00 00 00       	jmp    80407c <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803fd5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fdb:	01 d0                	add    %edx,%eax
  803fdd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803fe0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803fe4:	75 17                	jne    803ffd <alloc_block+0x29d>
  803fe6:	83 ec 04             	sub    $0x4,%esp
  803fe9:	68 40 51 80 00       	push   $0x805140
  803fee:	68 88 00 00 00       	push   $0x88
  803ff3:	68 37 50 80 00       	push   $0x805037
  803ff8:	e8 24 c8 ff ff       	call   800821 <_panic>
  803ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804000:	c1 e0 04             	shl    $0x4,%eax
  804003:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804008:	8b 10                	mov    (%eax),%edx
  80400a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80400d:	89 10                	mov    %edx,(%eax)
  80400f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804012:	8b 00                	mov    (%eax),%eax
  804014:	85 c0                	test   %eax,%eax
  804016:	74 15                	je     80402d <alloc_block+0x2cd>
  804018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401b:	c1 e0 04             	shl    $0x4,%eax
  80401e:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804023:	8b 00                	mov    (%eax),%eax
  804025:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804028:	89 50 04             	mov    %edx,0x4(%eax)
  80402b:	eb 11                	jmp    80403e <alloc_block+0x2de>
  80402d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804030:	c1 e0 04             	shl    $0x4,%eax
  804033:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  804039:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80403c:	89 02                	mov    %eax,(%edx)
  80403e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804041:	c1 e0 04             	shl    $0x4,%eax
  804044:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  80404a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80404d:	89 02                	mov    %eax,(%edx)
  80404f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804052:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80405c:	c1 e0 04             	shl    $0x4,%eax
  80405f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804064:	8b 00                	mov    (%eax),%eax
  804066:	8d 50 01             	lea    0x1(%eax),%edx
  804069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80406c:	c1 e0 04             	shl    $0x4,%eax
  80406f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804074:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  804076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804079:	01 45 e8             	add    %eax,-0x18(%ebp)
  80407c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  804083:	0f 86 4c ff ff ff    	jbe    803fd5 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  804089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80408c:	c1 e0 04             	shl    $0x4,%eax
  80408f:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804094:	8b 00                	mov    (%eax),%eax
  804096:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  804099:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80409d:	75 17                	jne    8040b6 <alloc_block+0x356>
  80409f:	83 ec 04             	sub    $0x4,%esp
  8040a2:	68 d1 50 80 00       	push   $0x8050d1
  8040a7:	68 8d 00 00 00       	push   $0x8d
  8040ac:	68 37 50 80 00       	push   $0x805037
  8040b1:	e8 6b c7 ff ff       	call   800821 <_panic>
  8040b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040b9:	8b 00                	mov    (%eax),%eax
  8040bb:	85 c0                	test   %eax,%eax
  8040bd:	74 10                	je     8040cf <alloc_block+0x36f>
  8040bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040c2:	8b 00                	mov    (%eax),%eax
  8040c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8040c7:	8b 52 04             	mov    0x4(%edx),%edx
  8040ca:	89 50 04             	mov    %edx,0x4(%eax)
  8040cd:	eb 14                	jmp    8040e3 <alloc_block+0x383>
  8040cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040d2:	8b 40 04             	mov    0x4(%eax),%eax
  8040d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040d8:	c1 e2 04             	shl    $0x4,%edx
  8040db:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  8040e1:	89 02                	mov    %eax,(%edx)
  8040e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040e6:	8b 40 04             	mov    0x4(%eax),%eax
  8040e9:	85 c0                	test   %eax,%eax
  8040eb:	74 0f                	je     8040fc <alloc_block+0x39c>
  8040ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040f0:	8b 40 04             	mov    0x4(%eax),%eax
  8040f3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8040f6:	8b 12                	mov    (%edx),%edx
  8040f8:	89 10                	mov    %edx,(%eax)
  8040fa:	eb 13                	jmp    80410f <alloc_block+0x3af>
  8040fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040ff:	8b 00                	mov    (%eax),%eax
  804101:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804104:	c1 e2 04             	shl    $0x4,%edx
  804107:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  80410d:	89 02                	mov    %eax,(%edx)
  80410f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804118:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80411b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804125:	c1 e0 04             	shl    $0x4,%eax
  804128:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80412d:	8b 00                	mov    (%eax),%eax
  80412f:	8d 50 ff             	lea    -0x1(%eax),%edx
  804132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804135:	c1 e0 04             	shl    $0x4,%eax
  804138:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80413d:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  80413f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804142:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804146:	48                   	dec    %eax
  804147:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80414a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  80414e:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804151:	c9                   	leave  
  804152:	c3                   	ret    

00804153 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804153:	55                   	push   %ebp
  804154:	89 e5                	mov    %esp,%ebp
  804156:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804159:	8b 55 08             	mov    0x8(%ebp),%edx
  80415c:	a1 88 60 83 00       	mov    0x836088,%eax
  804161:	39 c2                	cmp    %eax,%edx
  804163:	72 0c                	jb     804171 <free_block+0x1e>
  804165:	8b 55 08             	mov    0x8(%ebp),%edx
  804168:	a1 60 e0 81 00       	mov    0x81e060,%eax
  80416d:	39 c2                	cmp    %eax,%edx
  80416f:	72 19                	jb     80418a <free_block+0x37>
  804171:	68 64 51 80 00       	push   $0x805164
  804176:	68 9a 50 80 00       	push   $0x80509a
  80417b:	68 98 00 00 00       	push   $0x98
  804180:	68 37 50 80 00       	push   $0x805037
  804185:	e8 97 c6 ff ff       	call   800821 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80418a:	8b 45 08             	mov    0x8(%ebp),%eax
  80418d:	83 ec 0c             	sub    $0xc,%esp
  804190:	50                   	push   %eax
  804191:	e8 c9 f8 ff ff       	call   803a5f <to_page_info>
  804196:	83 c4 10             	add    $0x10,%esp
  804199:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  80419c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80419f:	8b 40 08             	mov    0x8(%eax),%eax
  8041a2:	0f b7 c0             	movzwl %ax,%eax
  8041a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  8041a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8041af:	eb 03                	jmp    8041b4 <free_block+0x61>
		listIndex++;
  8041b1:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8041b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b7:	ba 08 00 00 00       	mov    $0x8,%edx
  8041bc:	88 c1                	mov    %al,%cl
  8041be:	d3 e2                	shl    %cl,%edx
  8041c0:	89 d0                	mov    %edx,%eax
  8041c2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8041c5:	72 ea                	jb     8041b1 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  8041c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  8041cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041d1:	75 17                	jne    8041ea <free_block+0x97>
  8041d3:	83 ec 04             	sub    $0x4,%esp
  8041d6:	68 40 51 80 00       	push   $0x805140
  8041db:	68 a2 00 00 00       	push   $0xa2
  8041e0:	68 37 50 80 00       	push   $0x805037
  8041e5:	e8 37 c6 ff ff       	call   800821 <_panic>
  8041ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ed:	c1 e0 04             	shl    $0x4,%eax
  8041f0:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041f5:	8b 10                	mov    (%eax),%edx
  8041f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041fa:	89 10                	mov    %edx,(%eax)
  8041fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ff:	8b 00                	mov    (%eax),%eax
  804201:	85 c0                	test   %eax,%eax
  804203:	74 15                	je     80421a <free_block+0xc7>
  804205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804208:	c1 e0 04             	shl    $0x4,%eax
  80420b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804210:	8b 00                	mov    (%eax),%eax
  804212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804215:	89 50 04             	mov    %edx,0x4(%eax)
  804218:	eb 11                	jmp    80422b <free_block+0xd8>
  80421a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80421d:	c1 e0 04             	shl    $0x4,%eax
  804220:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  804226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804229:	89 02                	mov    %eax,(%edx)
  80422b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422e:	c1 e0 04             	shl    $0x4,%eax
  804231:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  804237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80423a:	89 02                	mov    %eax,(%edx)
  80423c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80423f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804249:	c1 e0 04             	shl    $0x4,%eax
  80424c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804251:	8b 00                	mov    (%eax),%eax
  804253:	8d 50 01             	lea    0x1(%eax),%edx
  804256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804259:	c1 e0 04             	shl    $0x4,%eax
  80425c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804261:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804266:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80426a:	40                   	inc    %eax
  80426b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80426e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804275:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804279:	0f b7 c8             	movzwl %ax,%ecx
  80427c:	b8 00 10 00 00       	mov    $0x1000,%eax
  804281:	ba 00 00 00 00       	mov    $0x0,%edx
  804286:	f7 75 e8             	divl   -0x18(%ebp)
  804289:	39 c1                	cmp    %eax,%ecx
  80428b:	0f 85 ed 01 00 00    	jne    80447e <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804294:	c1 e0 04             	shl    $0x4,%eax
  804297:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80429c:	8b 00                	mov    (%eax),%eax
  80429e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8042a1:	eb 2a                	jmp    8042cd <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  8042a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a6:	83 ec 0c             	sub    $0xc,%esp
  8042a9:	50                   	push   %eax
  8042aa:	e8 b0 f7 ff ff       	call   803a5f <to_page_info>
  8042af:	83 c4 10             	add    $0x10,%esp
  8042b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8042b5:	75 06                	jne    8042bd <free_block+0x16a>
				tmp = b;
  8042b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8042bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c0:	c1 e0 04             	shl    $0x4,%eax
  8042c3:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8042c8:	8b 00                	mov    (%eax),%eax
  8042ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8042cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042d1:	74 07                	je     8042da <free_block+0x187>
  8042d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d6:	8b 00                	mov    (%eax),%eax
  8042d8:	eb 05                	jmp    8042df <free_block+0x18c>
  8042da:	b8 00 00 00 00       	mov    $0x0,%eax
  8042df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042e2:	c1 e2 04             	shl    $0x4,%edx
  8042e5:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  8042eb:	89 02                	mov    %eax,(%edx)
  8042ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f0:	c1 e0 04             	shl    $0x4,%eax
  8042f3:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8042f8:	8b 00                	mov    (%eax),%eax
  8042fa:	85 c0                	test   %eax,%eax
  8042fc:	75 a5                	jne    8042a3 <free_block+0x150>
  8042fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804302:	75 9f                	jne    8042a3 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804307:	c1 e0 04             	shl    $0x4,%eax
  80430a:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80430f:	8b 00                	mov    (%eax),%eax
  804311:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804314:	e9 cc 00 00 00       	jmp    8043e5 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  804319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80431c:	8b 00                	mov    (%eax),%eax
  80431e:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804324:	83 ec 0c             	sub    $0xc,%esp
  804327:	50                   	push   %eax
  804328:	e8 32 f7 ff ff       	call   803a5f <to_page_info>
  80432d:	83 c4 10             	add    $0x10,%esp
  804330:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804333:	0f 85 a6 00 00 00    	jne    8043df <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  804339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80433d:	75 17                	jne    804356 <free_block+0x203>
  80433f:	83 ec 04             	sub    $0x4,%esp
  804342:	68 d1 50 80 00       	push   $0x8050d1
  804347:	68 b5 00 00 00       	push   $0xb5
  80434c:	68 37 50 80 00       	push   $0x805037
  804351:	e8 cb c4 ff ff       	call   800821 <_panic>
  804356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804359:	8b 00                	mov    (%eax),%eax
  80435b:	85 c0                	test   %eax,%eax
  80435d:	74 10                	je     80436f <free_block+0x21c>
  80435f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804362:	8b 00                	mov    (%eax),%eax
  804364:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804367:	8b 52 04             	mov    0x4(%edx),%edx
  80436a:	89 50 04             	mov    %edx,0x4(%eax)
  80436d:	eb 14                	jmp    804383 <free_block+0x230>
  80436f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804372:	8b 40 04             	mov    0x4(%eax),%eax
  804375:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804378:	c1 e2 04             	shl    $0x4,%edx
  80437b:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804381:	89 02                	mov    %eax,(%edx)
  804383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804386:	8b 40 04             	mov    0x4(%eax),%eax
  804389:	85 c0                	test   %eax,%eax
  80438b:	74 0f                	je     80439c <free_block+0x249>
  80438d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804390:	8b 40 04             	mov    0x4(%eax),%eax
  804393:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804396:	8b 12                	mov    (%edx),%edx
  804398:	89 10                	mov    %edx,(%eax)
  80439a:	eb 13                	jmp    8043af <free_block+0x25c>
  80439c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80439f:	8b 00                	mov    (%eax),%eax
  8043a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043a4:	c1 e2 04             	shl    $0x4,%edx
  8043a7:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8043ad:	89 02                	mov    %eax,(%edx)
  8043af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c5:	c1 e0 04             	shl    $0x4,%eax
  8043c8:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8043cd:	8b 00                	mov    (%eax),%eax
  8043cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8043d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d5:	c1 e0 04             	shl    $0x4,%eax
  8043d8:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8043dd:	89 10                	mov    %edx,(%eax)
			b = next;
  8043df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  8043e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8043e9:	0f 85 2a ff ff ff    	jne    804319 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  8043ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043f2:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8043f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043fb:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804401:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804405:	75 17                	jne    80441e <free_block+0x2cb>
  804407:	83 ec 04             	sub    $0x4,%esp
  80440a:	68 40 51 80 00       	push   $0x805140
  80440f:	68 bc 00 00 00       	push   $0xbc
  804414:	68 37 50 80 00       	push   $0x805037
  804419:	e8 03 c4 ff ff       	call   800821 <_panic>
  80441e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  804424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804427:	89 10                	mov    %edx,(%eax)
  804429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80442c:	8b 00                	mov    (%eax),%eax
  80442e:	85 c0                	test   %eax,%eax
  804430:	74 0d                	je     80443f <free_block+0x2ec>
  804432:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804437:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80443a:	89 50 04             	mov    %edx,0x4(%eax)
  80443d:	eb 08                	jmp    804447 <free_block+0x2f4>
  80443f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804442:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  804447:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80444a:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80444f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804452:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804459:	a1 74 e0 81 00       	mov    0x81e074,%eax
  80445e:	40                   	inc    %eax
  80445f:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804464:	83 ec 0c             	sub    $0xc,%esp
  804467:	ff 75 ec             	pushl  -0x14(%ebp)
  80446a:	e8 7e f5 ff ff       	call   8039ed <to_page_va>
  80446f:	83 c4 10             	add    $0x10,%esp
  804472:	83 ec 0c             	sub    $0xc,%esp
  804475:	50                   	push   %eax
  804476:	e8 fe d7 ff ff       	call   801c79 <return_page>
  80447b:	83 c4 10             	add    $0x10,%esp
	}
}
  80447e:	90                   	nop
  80447f:	c9                   	leave  
  804480:	c3                   	ret    

00804481 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804481:	55                   	push   %ebp
  804482:	89 e5                	mov    %esp,%ebp
  804484:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  804487:	83 ec 04             	sub    $0x4,%esp
  80448a:	68 9c 51 80 00       	push   $0x80519c
  80448f:	6a 07                	push   $0x7
  804491:	68 cb 51 80 00       	push   $0x8051cb
  804496:	e8 86 c3 ff ff       	call   800821 <_panic>

0080449b <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80449b:	55                   	push   %ebp
  80449c:	89 e5                	mov    %esp,%ebp
  80449e:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8044a1:	83 ec 04             	sub    $0x4,%esp
  8044a4:	68 dc 51 80 00       	push   $0x8051dc
  8044a9:	6a 0b                	push   $0xb
  8044ab:	68 cb 51 80 00       	push   $0x8051cb
  8044b0:	e8 6c c3 ff ff       	call   800821 <_panic>

008044b5 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8044b5:	55                   	push   %ebp
  8044b6:	89 e5                	mov    %esp,%ebp
  8044b8:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8044bb:	83 ec 04             	sub    $0x4,%esp
  8044be:	68 08 52 80 00       	push   $0x805208
  8044c3:	6a 10                	push   $0x10
  8044c5:	68 cb 51 80 00       	push   $0x8051cb
  8044ca:	e8 52 c3 ff ff       	call   800821 <_panic>

008044cf <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8044cf:	55                   	push   %ebp
  8044d0:	89 e5                	mov    %esp,%ebp
  8044d2:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8044d5:	83 ec 04             	sub    $0x4,%esp
  8044d8:	68 38 52 80 00       	push   $0x805238
  8044dd:	6a 15                	push   $0x15
  8044df:	68 cb 51 80 00       	push   $0x8051cb
  8044e4:	e8 38 c3 ff ff       	call   800821 <_panic>

008044e9 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8044e9:	55                   	push   %ebp
  8044ea:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8044ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ef:	8b 40 10             	mov    0x10(%eax),%eax
}
  8044f2:	5d                   	pop    %ebp
  8044f3:	c3                   	ret    

008044f4 <__udivdi3>:
  8044f4:	55                   	push   %ebp
  8044f5:	57                   	push   %edi
  8044f6:	56                   	push   %esi
  8044f7:	53                   	push   %ebx
  8044f8:	83 ec 1c             	sub    $0x1c,%esp
  8044fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8044ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804503:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804507:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80450b:	89 ca                	mov    %ecx,%edx
  80450d:	89 f8                	mov    %edi,%eax
  80450f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804513:	85 f6                	test   %esi,%esi
  804515:	75 2d                	jne    804544 <__udivdi3+0x50>
  804517:	39 cf                	cmp    %ecx,%edi
  804519:	77 65                	ja     804580 <__udivdi3+0x8c>
  80451b:	89 fd                	mov    %edi,%ebp
  80451d:	85 ff                	test   %edi,%edi
  80451f:	75 0b                	jne    80452c <__udivdi3+0x38>
  804521:	b8 01 00 00 00       	mov    $0x1,%eax
  804526:	31 d2                	xor    %edx,%edx
  804528:	f7 f7                	div    %edi
  80452a:	89 c5                	mov    %eax,%ebp
  80452c:	31 d2                	xor    %edx,%edx
  80452e:	89 c8                	mov    %ecx,%eax
  804530:	f7 f5                	div    %ebp
  804532:	89 c1                	mov    %eax,%ecx
  804534:	89 d8                	mov    %ebx,%eax
  804536:	f7 f5                	div    %ebp
  804538:	89 cf                	mov    %ecx,%edi
  80453a:	89 fa                	mov    %edi,%edx
  80453c:	83 c4 1c             	add    $0x1c,%esp
  80453f:	5b                   	pop    %ebx
  804540:	5e                   	pop    %esi
  804541:	5f                   	pop    %edi
  804542:	5d                   	pop    %ebp
  804543:	c3                   	ret    
  804544:	39 ce                	cmp    %ecx,%esi
  804546:	77 28                	ja     804570 <__udivdi3+0x7c>
  804548:	0f bd fe             	bsr    %esi,%edi
  80454b:	83 f7 1f             	xor    $0x1f,%edi
  80454e:	75 40                	jne    804590 <__udivdi3+0x9c>
  804550:	39 ce                	cmp    %ecx,%esi
  804552:	72 0a                	jb     80455e <__udivdi3+0x6a>
  804554:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804558:	0f 87 9e 00 00 00    	ja     8045fc <__udivdi3+0x108>
  80455e:	b8 01 00 00 00       	mov    $0x1,%eax
  804563:	89 fa                	mov    %edi,%edx
  804565:	83 c4 1c             	add    $0x1c,%esp
  804568:	5b                   	pop    %ebx
  804569:	5e                   	pop    %esi
  80456a:	5f                   	pop    %edi
  80456b:	5d                   	pop    %ebp
  80456c:	c3                   	ret    
  80456d:	8d 76 00             	lea    0x0(%esi),%esi
  804570:	31 ff                	xor    %edi,%edi
  804572:	31 c0                	xor    %eax,%eax
  804574:	89 fa                	mov    %edi,%edx
  804576:	83 c4 1c             	add    $0x1c,%esp
  804579:	5b                   	pop    %ebx
  80457a:	5e                   	pop    %esi
  80457b:	5f                   	pop    %edi
  80457c:	5d                   	pop    %ebp
  80457d:	c3                   	ret    
  80457e:	66 90                	xchg   %ax,%ax
  804580:	89 d8                	mov    %ebx,%eax
  804582:	f7 f7                	div    %edi
  804584:	31 ff                	xor    %edi,%edi
  804586:	89 fa                	mov    %edi,%edx
  804588:	83 c4 1c             	add    $0x1c,%esp
  80458b:	5b                   	pop    %ebx
  80458c:	5e                   	pop    %esi
  80458d:	5f                   	pop    %edi
  80458e:	5d                   	pop    %ebp
  80458f:	c3                   	ret    
  804590:	bd 20 00 00 00       	mov    $0x20,%ebp
  804595:	89 eb                	mov    %ebp,%ebx
  804597:	29 fb                	sub    %edi,%ebx
  804599:	89 f9                	mov    %edi,%ecx
  80459b:	d3 e6                	shl    %cl,%esi
  80459d:	89 c5                	mov    %eax,%ebp
  80459f:	88 d9                	mov    %bl,%cl
  8045a1:	d3 ed                	shr    %cl,%ebp
  8045a3:	89 e9                	mov    %ebp,%ecx
  8045a5:	09 f1                	or     %esi,%ecx
  8045a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8045ab:	89 f9                	mov    %edi,%ecx
  8045ad:	d3 e0                	shl    %cl,%eax
  8045af:	89 c5                	mov    %eax,%ebp
  8045b1:	89 d6                	mov    %edx,%esi
  8045b3:	88 d9                	mov    %bl,%cl
  8045b5:	d3 ee                	shr    %cl,%esi
  8045b7:	89 f9                	mov    %edi,%ecx
  8045b9:	d3 e2                	shl    %cl,%edx
  8045bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045bf:	88 d9                	mov    %bl,%cl
  8045c1:	d3 e8                	shr    %cl,%eax
  8045c3:	09 c2                	or     %eax,%edx
  8045c5:	89 d0                	mov    %edx,%eax
  8045c7:	89 f2                	mov    %esi,%edx
  8045c9:	f7 74 24 0c          	divl   0xc(%esp)
  8045cd:	89 d6                	mov    %edx,%esi
  8045cf:	89 c3                	mov    %eax,%ebx
  8045d1:	f7 e5                	mul    %ebp
  8045d3:	39 d6                	cmp    %edx,%esi
  8045d5:	72 19                	jb     8045f0 <__udivdi3+0xfc>
  8045d7:	74 0b                	je     8045e4 <__udivdi3+0xf0>
  8045d9:	89 d8                	mov    %ebx,%eax
  8045db:	31 ff                	xor    %edi,%edi
  8045dd:	e9 58 ff ff ff       	jmp    80453a <__udivdi3+0x46>
  8045e2:	66 90                	xchg   %ax,%ax
  8045e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8045e8:	89 f9                	mov    %edi,%ecx
  8045ea:	d3 e2                	shl    %cl,%edx
  8045ec:	39 c2                	cmp    %eax,%edx
  8045ee:	73 e9                	jae    8045d9 <__udivdi3+0xe5>
  8045f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8045f3:	31 ff                	xor    %edi,%edi
  8045f5:	e9 40 ff ff ff       	jmp    80453a <__udivdi3+0x46>
  8045fa:	66 90                	xchg   %ax,%ax
  8045fc:	31 c0                	xor    %eax,%eax
  8045fe:	e9 37 ff ff ff       	jmp    80453a <__udivdi3+0x46>
  804603:	90                   	nop

00804604 <__umoddi3>:
  804604:	55                   	push   %ebp
  804605:	57                   	push   %edi
  804606:	56                   	push   %esi
  804607:	53                   	push   %ebx
  804608:	83 ec 1c             	sub    $0x1c,%esp
  80460b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80460f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804613:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804617:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80461b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80461f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804623:	89 f3                	mov    %esi,%ebx
  804625:	89 fa                	mov    %edi,%edx
  804627:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80462b:	89 34 24             	mov    %esi,(%esp)
  80462e:	85 c0                	test   %eax,%eax
  804630:	75 1a                	jne    80464c <__umoddi3+0x48>
  804632:	39 f7                	cmp    %esi,%edi
  804634:	0f 86 a2 00 00 00    	jbe    8046dc <__umoddi3+0xd8>
  80463a:	89 c8                	mov    %ecx,%eax
  80463c:	89 f2                	mov    %esi,%edx
  80463e:	f7 f7                	div    %edi
  804640:	89 d0                	mov    %edx,%eax
  804642:	31 d2                	xor    %edx,%edx
  804644:	83 c4 1c             	add    $0x1c,%esp
  804647:	5b                   	pop    %ebx
  804648:	5e                   	pop    %esi
  804649:	5f                   	pop    %edi
  80464a:	5d                   	pop    %ebp
  80464b:	c3                   	ret    
  80464c:	39 f0                	cmp    %esi,%eax
  80464e:	0f 87 ac 00 00 00    	ja     804700 <__umoddi3+0xfc>
  804654:	0f bd e8             	bsr    %eax,%ebp
  804657:	83 f5 1f             	xor    $0x1f,%ebp
  80465a:	0f 84 ac 00 00 00    	je     80470c <__umoddi3+0x108>
  804660:	bf 20 00 00 00       	mov    $0x20,%edi
  804665:	29 ef                	sub    %ebp,%edi
  804667:	89 fe                	mov    %edi,%esi
  804669:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80466d:	89 e9                	mov    %ebp,%ecx
  80466f:	d3 e0                	shl    %cl,%eax
  804671:	89 d7                	mov    %edx,%edi
  804673:	89 f1                	mov    %esi,%ecx
  804675:	d3 ef                	shr    %cl,%edi
  804677:	09 c7                	or     %eax,%edi
  804679:	89 e9                	mov    %ebp,%ecx
  80467b:	d3 e2                	shl    %cl,%edx
  80467d:	89 14 24             	mov    %edx,(%esp)
  804680:	89 d8                	mov    %ebx,%eax
  804682:	d3 e0                	shl    %cl,%eax
  804684:	89 c2                	mov    %eax,%edx
  804686:	8b 44 24 08          	mov    0x8(%esp),%eax
  80468a:	d3 e0                	shl    %cl,%eax
  80468c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804690:	8b 44 24 08          	mov    0x8(%esp),%eax
  804694:	89 f1                	mov    %esi,%ecx
  804696:	d3 e8                	shr    %cl,%eax
  804698:	09 d0                	or     %edx,%eax
  80469a:	d3 eb                	shr    %cl,%ebx
  80469c:	89 da                	mov    %ebx,%edx
  80469e:	f7 f7                	div    %edi
  8046a0:	89 d3                	mov    %edx,%ebx
  8046a2:	f7 24 24             	mull   (%esp)
  8046a5:	89 c6                	mov    %eax,%esi
  8046a7:	89 d1                	mov    %edx,%ecx
  8046a9:	39 d3                	cmp    %edx,%ebx
  8046ab:	0f 82 87 00 00 00    	jb     804738 <__umoddi3+0x134>
  8046b1:	0f 84 91 00 00 00    	je     804748 <__umoddi3+0x144>
  8046b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8046bb:	29 f2                	sub    %esi,%edx
  8046bd:	19 cb                	sbb    %ecx,%ebx
  8046bf:	89 d8                	mov    %ebx,%eax
  8046c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8046c5:	d3 e0                	shl    %cl,%eax
  8046c7:	89 e9                	mov    %ebp,%ecx
  8046c9:	d3 ea                	shr    %cl,%edx
  8046cb:	09 d0                	or     %edx,%eax
  8046cd:	89 e9                	mov    %ebp,%ecx
  8046cf:	d3 eb                	shr    %cl,%ebx
  8046d1:	89 da                	mov    %ebx,%edx
  8046d3:	83 c4 1c             	add    $0x1c,%esp
  8046d6:	5b                   	pop    %ebx
  8046d7:	5e                   	pop    %esi
  8046d8:	5f                   	pop    %edi
  8046d9:	5d                   	pop    %ebp
  8046da:	c3                   	ret    
  8046db:	90                   	nop
  8046dc:	89 fd                	mov    %edi,%ebp
  8046de:	85 ff                	test   %edi,%edi
  8046e0:	75 0b                	jne    8046ed <__umoddi3+0xe9>
  8046e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8046e7:	31 d2                	xor    %edx,%edx
  8046e9:	f7 f7                	div    %edi
  8046eb:	89 c5                	mov    %eax,%ebp
  8046ed:	89 f0                	mov    %esi,%eax
  8046ef:	31 d2                	xor    %edx,%edx
  8046f1:	f7 f5                	div    %ebp
  8046f3:	89 c8                	mov    %ecx,%eax
  8046f5:	f7 f5                	div    %ebp
  8046f7:	89 d0                	mov    %edx,%eax
  8046f9:	e9 44 ff ff ff       	jmp    804642 <__umoddi3+0x3e>
  8046fe:	66 90                	xchg   %ax,%ax
  804700:	89 c8                	mov    %ecx,%eax
  804702:	89 f2                	mov    %esi,%edx
  804704:	83 c4 1c             	add    $0x1c,%esp
  804707:	5b                   	pop    %ebx
  804708:	5e                   	pop    %esi
  804709:	5f                   	pop    %edi
  80470a:	5d                   	pop    %ebp
  80470b:	c3                   	ret    
  80470c:	3b 04 24             	cmp    (%esp),%eax
  80470f:	72 06                	jb     804717 <__umoddi3+0x113>
  804711:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804715:	77 0f                	ja     804726 <__umoddi3+0x122>
  804717:	89 f2                	mov    %esi,%edx
  804719:	29 f9                	sub    %edi,%ecx
  80471b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80471f:	89 14 24             	mov    %edx,(%esp)
  804722:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804726:	8b 44 24 04          	mov    0x4(%esp),%eax
  80472a:	8b 14 24             	mov    (%esp),%edx
  80472d:	83 c4 1c             	add    $0x1c,%esp
  804730:	5b                   	pop    %ebx
  804731:	5e                   	pop    %esi
  804732:	5f                   	pop    %edi
  804733:	5d                   	pop    %ebp
  804734:	c3                   	ret    
  804735:	8d 76 00             	lea    0x0(%esi),%esi
  804738:	2b 04 24             	sub    (%esp),%eax
  80473b:	19 fa                	sbb    %edi,%edx
  80473d:	89 d1                	mov    %edx,%ecx
  80473f:	89 c6                	mov    %eax,%esi
  804741:	e9 71 ff ff ff       	jmp    8046b7 <__umoddi3+0xb3>
  804746:	66 90                	xchg   %ax,%ax
  804748:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80474c:	72 ea                	jb     804738 <__umoddi3+0x134>
  80474e:	89 d9                	mov    %ebx,%ecx
  804750:	e9 62 ff ff ff       	jmp    8046b7 <__umoddi3+0xb3>
