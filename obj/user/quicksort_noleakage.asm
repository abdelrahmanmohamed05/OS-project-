
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 d6 05 00 00       	call   80060c <libmain>
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
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
		//2012: lock the interrupt
		//sys_lock_cons();
		//2024: lock the console only using a sleepLock
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 06 34 00 00       	call   80344c <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 46 80 00       	push   $0x804680
  80004e:	e8 37 0a 00 00       	call   800a8a <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 46 80 00       	push   $0x804682
  80005e:	e8 27 0a 00 00       	call   800a8a <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 9b 46 80 00       	push   $0x80469b
  80006e:	e8 17 0a 00 00       	call   800a8a <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 46 80 00       	push   $0x804682
  80007e:	e8 07 0a 00 00       	call   800a8a <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 46 80 00       	push   $0x804680
  80008e:	e8 f7 09 00 00       	call   800a8a <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b4 46 80 00       	push   $0x8046b4
  8000a5:	e8 b9 10 00 00       	call   801163 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 ba 16 00 00       	call   80177a <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 d4 46 80 00       	push   $0x8046d4
  8000ce:	e8 b7 09 00 00       	call   800a8a <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 f6 46 80 00       	push   $0x8046f6
  8000de:	e8 a7 09 00 00       	call   800a8a <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 04 47 80 00       	push   $0x804704
  8000ee:	e8 97 09 00 00       	call   800a8a <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 13 47 80 00       	push   $0x804713
  8000fe:	e8 87 09 00 00       	call   800a8a <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 23 47 80 00       	push   $0x804723
  80010e:	e8 77 09 00 00       	call   800a8a <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 d4 04 00 00       	call   8005ef <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 a5 04 00 00       	call   8005d0 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 98 04 00 00       	call   8005d0 <cputchar>
  800138:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80013b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80013f:	74 0c                	je     80014d <_main+0x115>
  800141:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800145:	74 06                	je     80014d <_main+0x115>
  800147:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80014b:	75 b9                	jne    800106 <_main+0xce>
		}
		//2012: unlock
		sys_unlock_cons();
  80014d:	e8 14 33 00 00       	call   803466 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 f3 1a 00 00       	call   801c54 <malloc>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 03 03 00 00       	call   80048b <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 21 03 00 00       	call   8004bc <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 43 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 30 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 fe 00 00 00       	call   8002d0 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  8001d5:	e8 72 32 00 00       	call   80344c <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 2c 47 80 00       	push   $0x80472c
  8001e2:	e8 a3 08 00 00       	call   800a8a <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 77 32 00 00       	call   803466 <sys_unlock_cons>
		//sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 e4 01 00 00       	call   8003e1 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 60 47 80 00       	push   $0x804760
  800211:	6a 54                	push   $0x54
  800213:	68 82 47 80 00       	push   $0x804782
  800218:	e8 9f 05 00 00       	call   8007bc <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 2a 32 00 00       	call   80344c <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 a0 47 80 00       	push   $0x8047a0
  80022a:	e8 5b 08 00 00       	call   800a8a <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 d4 47 80 00       	push   $0x8047d4
  80023a:	e8 4b 08 00 00       	call   800a8a <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 08 48 80 00       	push   $0x804808
  80024a:	e8 3b 08 00 00       	call   800a8a <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 0f 32 00 00       	call   803466 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 52 1d 00 00       	call   801fb4 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 e2 31 00 00       	call   80344c <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 3a 48 80 00       	push   $0x80483a
  800278:	e8 0d 08 00 00       	call   800a8a <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800280:	e8 6a 03 00 00       	call   8005ef <getchar>
  800285:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800288:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 3b 03 00 00       	call   8005d0 <cputchar>
  800295:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 0a                	push   $0xa
  80029d:	e8 2e 03 00 00       	call   8005d0 <cputchar>
  8002a2:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	6a 0a                	push   $0xa
  8002aa:	e8 21 03 00 00       	call   8005d0 <cputchar>
  8002af:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b2:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b6:	74 06                	je     8002be <_main+0x286>
  8002b8:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002bc:	75 b2                	jne    800270 <_main+0x238>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002be:	e8 a3 31 00 00       	call   803466 <sys_unlock_cons>
		//		sys_unlock_cons();

	} while (Chose == 'y');
  8002c3:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c7:	0f 84 74 fd ff ff    	je     800041 <_main+0x9>

}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d9:	48                   	dec    %eax
  8002da:	50                   	push   %eax
  8002db:	6a 00                	push   $0x0
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 06 00 00 00       	call   8002ee <QSort>
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	90                   	nop
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fa:	0f 8d de 00 00 00    	jge    8003de <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800300:	8b 45 10             	mov    0x10(%ebp),%eax
  800303:	40                   	inc    %eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800307:	8b 45 14             	mov    0x14(%ebp),%eax
  80030a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80030d:	e9 80 00 00 00       	jmp    800392 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800312:	ff 45 f4             	incl   -0xc(%ebp)
  800315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800318:	3b 45 14             	cmp    0x14(%ebp),%eax
  80031b:	7f 2b                	jg     800348 <QSort+0x5a>
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	8b 10                	mov    (%eax),%edx
  80032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800331:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	39 c2                	cmp    %eax,%edx
  800341:	7d cf                	jge    800312 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800343:	eb 03                	jmp    800348 <QSort+0x5a>
  800345:	ff 4d f0             	decl   -0x10(%ebp)
  800348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80034e:	7e 26                	jle    800376 <QSort+0x88>
  800350:	8b 45 10             	mov    0x10(%ebp),%eax
  800353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 c8                	add    %ecx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	39 c2                	cmp    %eax,%edx
  800374:	7e cf                	jle    800345 <QSort+0x57>

		if (i <= j)
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037c:	7f 14                	jg     800392 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	ff 75 f0             	pushl  -0x10(%ebp)
  800384:	ff 75 f4             	pushl  -0xc(%ebp)
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 a9 00 00 00       	call   800438 <Swap>
  80038f:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800398:	0f 8e 77 ff ff ff    	jle    800315 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	ff 75 10             	pushl  0x10(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 89 00 00 00       	call   800438 <Swap>
  8003af:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b5:	48                   	dec    %eax
  8003b6:	50                   	push   %eax
  8003b7:	ff 75 10             	pushl  0x10(%ebp)
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	e8 29 ff ff ff       	call   8002ee <QSort>
  8003c5:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003c8:	ff 75 14             	pushl  0x14(%ebp)
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 15 ff ff ff       	call   8002ee <QSort>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	eb 01                	jmp    8003df <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003de:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003f5:	eb 33                	jmp    80042a <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8b 10                	mov    (%eax),%edx
  800408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80040b:	40                   	inc    %eax
  80040c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	01 c8                	add    %ecx,%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	7e 09                	jle    800427 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80041e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800425:	eb 0c                	jmp    800433 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800427:	ff 45 f8             	incl   -0x8(%ebp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	48                   	dec    %eax
  80042e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800431:	7f c4                	jg     8003f7 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 c8                	add    %ecx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	01 c2                	add    %eax,%edx
  800483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800486:	89 02                	mov    %eax,(%edx)
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800498:	eb 17                	jmp    8004b1 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80049a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 c2                	add    %eax,%edx
  8004a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ac:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004ae:	ff 45 fc             	incl   -0x4(%ebp)
  8004b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b7:	7c e1                	jl     80049a <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004b9:	90                   	nop
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004c9:	eb 1b                	jmp    8004e6 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	01 c2                	add    %eax,%edx
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004e0:	48                   	dec    %eax
  8004e1:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e3:	ff 45 fc             	incl   -0x4(%ebp)
  8004e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ec:	7c dd                	jl     8004cb <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004fa:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ff:	f7 e9                	imul   %ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 d0                	mov    %edx,%eax
  800506:	29 c8                	sub    %ecx,%eax
  800508:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  80050b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80050f:	75 07                	jne    800518 <InitializeSemiRandom+0x27>
		Repetition = 3;
  800511:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80051f:	eb 1e                	jmp    80053f <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	99                   	cltd   
  800535:	f7 7d f8             	idivl  -0x8(%ebp)
  800538:	89 d0                	mov    %edx,%eax
  80053a:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
		Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80053c:	ff 45 fc             	incl   -0x4(%ebp)
  80053f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800542:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800545:	7c da                	jl     800521 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800550:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80055e:	eb 42                	jmp    8005a2 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800563:	99                   	cltd   
  800564:	f7 7d f0             	idivl  -0x10(%ebp)
  800567:	89 d0                	mov    %edx,%eax
  800569:	85 c0                	test   %eax,%eax
  80056b:	75 10                	jne    80057d <PrintElements+0x33>
			cprintf("\n");
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 80 46 80 00       	push   $0x804680
  800575:	e8 10 05 00 00       	call   800a8a <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 58 48 80 00       	push   $0x804858
  800597:	e8 ee 04 00 00       	call   800a8a <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80059f:	ff 45 f4             	incl   -0xc(%ebp)
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a5:	48                   	dec    %eax
  8005a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005a9:	7f b5                	jg     800560 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8005ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	50                   	push   %eax
  8005c0:	68 5d 48 80 00       	push   $0x80485d
  8005c5:	e8 c0 04 00 00       	call   800a8a <cprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp

}
  8005cd:	90                   	nop
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005dc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 ab 2f 00 00       	call   803594 <sys_cputc>
  8005e9:	83 c4 10             	add    $0x10,%esp
}
  8005ec:	90                   	nop
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <getchar>:


int
getchar(void)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005f5:	e8 39 2e 00 00       	call   803433 <sys_cgetc>
  8005fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <iscons>:

int iscons(int fdnum)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800605:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	57                   	push   %edi
  800610:	56                   	push   %esi
  800611:	53                   	push   %ebx
  800612:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800615:	e8 ab 30 00 00       	call   8036c5 <sys_getenvindex>
  80061a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80061d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800620:	89 d0                	mov    %edx,%eax
  800622:	c1 e0 03             	shl    $0x3,%eax
  800625:	01 d0                	add    %edx,%eax
  800627:	c1 e0 02             	shl    $0x2,%eax
  80062a:	01 d0                	add    %edx,%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	01 d0                	add    %edx,%eax
  800635:	c1 e0 03             	shl    $0x3,%eax
  800638:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80063d:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800642:	a1 24 60 80 00       	mov    0x806024,%eax
  800647:	8a 40 20             	mov    0x20(%eax),%al
  80064a:	84 c0                	test   %al,%al
  80064c:	74 0d                	je     80065b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80064e:	a1 24 60 80 00       	mov    0x806024,%eax
  800653:	83 c0 20             	add    $0x20,%eax
  800656:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80065b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065f:	7e 0a                	jle    80066b <libmain+0x5f>
		binaryname = argv[0];
  800661:	8b 45 0c             	mov    0xc(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	ff 75 08             	pushl  0x8(%ebp)
  800674:	e8 bf f9 ff ff       	call   800038 <_main>
  800679:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80067c:	a1 00 60 80 00       	mov    0x806000,%eax
  800681:	85 c0                	test   %eax,%eax
  800683:	0f 84 01 01 00 00    	je     80078a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800689:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80068f:	bb 5c 49 80 00       	mov    $0x80495c,%ebx
  800694:	ba 0e 00 00 00       	mov    $0xe,%edx
  800699:	89 c7                	mov    %eax,%edi
  80069b:	89 de                	mov    %ebx,%esi
  80069d:	89 d1                	mov    %edx,%ecx
  80069f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006a1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006a4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8006a9:	b0 00                	mov    $0x0,%al
  8006ab:	89 d7                	mov    %edx,%edi
  8006ad:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	50                   	push   %eax
  8006bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006c3:	50                   	push   %eax
  8006c4:	e8 32 32 00 00       	call   8038fb <sys_utilities>
  8006c9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006cc:	e8 7b 2d 00 00       	call   80344c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	68 7c 48 80 00       	push   $0x80487c
  8006d9:	e8 ac 03 00 00       	call   800a8a <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e4:	85 c0                	test   %eax,%eax
  8006e6:	74 18                	je     800700 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006e8:	e8 2c 32 00 00       	call   803919 <sys_get_optimal_num_faults>
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	50                   	push   %eax
  8006f1:	68 a4 48 80 00       	push   $0x8048a4
  8006f6:	e8 8f 03 00 00       	call   800a8a <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	eb 59                	jmp    800759 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800700:	a1 24 60 80 00       	mov    0x806024,%eax
  800705:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80070b:	a1 24 60 80 00       	mov    0x806024,%eax
  800710:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	52                   	push   %edx
  80071a:	50                   	push   %eax
  80071b:	68 c8 48 80 00       	push   $0x8048c8
  800720:	e8 65 03 00 00       	call   800a8a <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800728:	a1 24 60 80 00       	mov    0x806024,%eax
  80072d:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800733:	a1 24 60 80 00       	mov    0x806024,%eax
  800738:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80073e:	a1 24 60 80 00       	mov    0x806024,%eax
  800743:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800749:	51                   	push   %ecx
  80074a:	52                   	push   %edx
  80074b:	50                   	push   %eax
  80074c:	68 f0 48 80 00       	push   $0x8048f0
  800751:	e8 34 03 00 00       	call   800a8a <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800759:	a1 24 60 80 00       	mov    0x806024,%eax
  80075e:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	50                   	push   %eax
  800768:	68 48 49 80 00       	push   $0x804948
  80076d:	e8 18 03 00 00       	call   800a8a <cprintf>
  800772:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800775:	83 ec 0c             	sub    $0xc,%esp
  800778:	68 7c 48 80 00       	push   $0x80487c
  80077d:	e8 08 03 00 00       	call   800a8a <cprintf>
  800782:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800785:	e8 dc 2c 00 00       	call   803466 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80078a:	e8 1f 00 00 00       	call   8007ae <exit>
}
  80078f:	90                   	nop
  800790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800793:	5b                   	pop    %ebx
  800794:	5e                   	pop    %esi
  800795:	5f                   	pop    %edi
  800796:	5d                   	pop    %ebp
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 e9 2e 00 00       	call   803691 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 3e 2f 00 00       	call   8036f7 <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 38 61 83 00       	mov    0x836138,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 38 61 83 00       	mov    0x836138,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 c0 49 80 00       	push   $0x8049c0
  8007e2:	e8 a3 02 00 00       	call   800a8a <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 04 60 80 00       	mov    0x806004,%eax
  8007ef:	83 ec 0c             	sub    $0xc,%esp
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	ff 75 08             	pushl  0x8(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	68 c8 49 80 00       	push   $0x8049c8
  8007fe:	6a 74                	push   $0x74
  800800:	e8 b2 02 00 00       	call   800ab7 <cprintf_colored>
  800805:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 f4             	pushl  -0xc(%ebp)
  800811:	50                   	push   %eax
  800812:	e8 04 02 00 00       	call   800a1b <vcprintf>
  800817:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	6a 00                	push   $0x0
  80081f:	68 f0 49 80 00       	push   $0x8049f0
  800824:	e8 f2 01 00 00       	call   800a1b <vcprintf>
  800829:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80082c:	e8 7d ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  800831:	eb fe                	jmp    800831 <_panic+0x75>

00800833 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800839:	a1 24 60 80 00       	mov    0x806024,%eax
  80083e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800844:	8b 45 0c             	mov    0xc(%ebp),%eax
  800847:	39 c2                	cmp    %eax,%edx
  800849:	74 14                	je     80085f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	68 f4 49 80 00       	push   $0x8049f4
  800853:	6a 26                	push   $0x26
  800855:	68 40 4a 80 00       	push   $0x804a40
  80085a:	e8 5d ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800866:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80086d:	e9 c5 00 00 00       	jmp    800937 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800875:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	85 c0                	test   %eax,%eax
  800885:	75 08                	jne    80088f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800887:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80088a:	e9 a5 00 00 00       	jmp    800934 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80088f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800896:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80089d:	eb 69                	jmp    800908 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80089f:	a1 24 60 80 00       	mov    0x806024,%eax
  8008a4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ad:	89 d0                	mov    %edx,%eax
  8008af:	01 c0                	add    %eax,%eax
  8008b1:	01 d0                	add    %edx,%eax
  8008b3:	c1 e0 03             	shl    $0x3,%eax
  8008b6:	01 c8                	add    %ecx,%eax
  8008b8:	8a 40 04             	mov    0x4(%eax),%al
  8008bb:	84 c0                	test   %al,%al
  8008bd:	75 46                	jne    800905 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008bf:	a1 24 60 80 00       	mov    0x806024,%eax
  8008c4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008cd:	89 d0                	mov    %edx,%eax
  8008cf:	01 c0                	add    %eax,%eax
  8008d1:	01 d0                	add    %edx,%eax
  8008d3:	c1 e0 03             	shl    $0x3,%eax
  8008d6:	01 c8                	add    %ecx,%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008e5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	01 c8                	add    %ecx,%eax
  8008f6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f8:	39 c2                	cmp    %eax,%edx
  8008fa:	75 09                	jne    800905 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008fc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800903:	eb 15                	jmp    80091a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800905:	ff 45 e8             	incl   -0x18(%ebp)
  800908:	a1 24 60 80 00       	mov    0x806024,%eax
  80090d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 85                	ja     80089f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80091a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80091e:	75 14                	jne    800934 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800920:	83 ec 04             	sub    $0x4,%esp
  800923:	68 4c 4a 80 00       	push   $0x804a4c
  800928:	6a 3a                	push   $0x3a
  80092a:	68 40 4a 80 00       	push   $0x804a40
  80092f:	e8 88 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800934:	ff 45 f0             	incl   -0x10(%ebp)
  800937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80093d:	0f 8c 2f ff ff ff    	jl     800872 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800943:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800951:	eb 26                	jmp    800979 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800953:	a1 24 60 80 00       	mov    0x806024,%eax
  800958:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80095e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800961:	89 d0                	mov    %edx,%eax
  800963:	01 c0                	add    %eax,%eax
  800965:	01 d0                	add    %edx,%eax
  800967:	c1 e0 03             	shl    $0x3,%eax
  80096a:	01 c8                	add    %ecx,%eax
  80096c:	8a 40 04             	mov    0x4(%eax),%al
  80096f:	3c 01                	cmp    $0x1,%al
  800971:	75 03                	jne    800976 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800973:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800976:	ff 45 e0             	incl   -0x20(%ebp)
  800979:	a1 24 60 80 00       	mov    0x806024,%eax
  80097e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800984:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800987:	39 c2                	cmp    %eax,%edx
  800989:	77 c8                	ja     800953 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80098b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800991:	74 14                	je     8009a7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 a0 4a 80 00       	push   $0x804aa0
  80099b:	6a 44                	push   $0x44
  80099d:	68 40 4a 80 00       	push   $0x804a40
  8009a2:	e8 15 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009a7:	90                   	nop
  8009a8:	c9                   	leave  
  8009a9:	c3                   	ret    

008009aa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	53                   	push   %ebx
  8009ae:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 0a                	mov    %ecx,(%edx)
  8009be:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c1:	88 d1                	mov    %dl,%cl
  8009c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009d4:	75 30                	jne    800a06 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009d6:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  8009dc:	a0 64 e0 81 00       	mov    0x81e064,%al
  8009e1:	0f b6 c0             	movzbl %al,%eax
  8009e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e7:	8b 09                	mov    (%ecx),%ecx
  8009e9:	89 cb                	mov    %ecx,%ebx
  8009eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ee:	83 c1 08             	add    $0x8,%ecx
  8009f1:	52                   	push   %edx
  8009f2:	50                   	push   %eax
  8009f3:	53                   	push   %ebx
  8009f4:	51                   	push   %ecx
  8009f5:	e8 0e 2a 00 00       	call   803408 <sys_cputs>
  8009fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	8b 40 04             	mov    0x4(%eax),%eax
  800a0c:	8d 50 01             	lea    0x1(%eax),%edx
  800a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a12:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a15:	90                   	nop
  800a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a24:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a2b:	00 00 00 
	b.cnt = 0;
  800a2e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a35:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a38:	ff 75 0c             	pushl  0xc(%ebp)
  800a3b:	ff 75 08             	pushl  0x8(%ebp)
  800a3e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a44:	50                   	push   %eax
  800a45:	68 aa 09 80 00       	push   $0x8009aa
  800a4a:	e8 5a 02 00 00       	call   800ca9 <vprintfmt>
  800a4f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a52:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800a58:	a0 64 e0 81 00       	mov    0x81e064,%al
  800a5d:	0f b6 c0             	movzbl %al,%eax
  800a60:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a66:	52                   	push   %edx
  800a67:	50                   	push   %eax
  800a68:	51                   	push   %ecx
  800a69:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a6f:	83 c0 08             	add    $0x8,%eax
  800a72:	50                   	push   %eax
  800a73:	e8 90 29 00 00       	call   803408 <sys_cputs>
  800a78:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a7b:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800a82:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a90:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800a97:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa6:	50                   	push   %eax
  800aa7:	e8 6f ff ff ff       	call   800a1b <vcprintf>
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800abd:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c1 e0 08             	shl    $0x8,%eax
  800aca:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800acf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae1:	50                   	push   %eax
  800ae2:	e8 34 ff ff ff       	call   800a1b <vcprintf>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800aed:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800af4:	07 00 00 

	return cnt;
  800af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b02:	e8 45 29 00 00       	call   80344c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b07:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 f4             	pushl  -0xc(%ebp)
  800b16:	50                   	push   %eax
  800b17:	e8 ff fe ff ff       	call   800a1b <vcprintf>
  800b1c:	83 c4 10             	add    $0x10,%esp
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b22:	e8 3f 29 00 00       	call   803466 <sys_unlock_cons>
	return cnt;
  800b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	53                   	push   %ebx
  800b30:	83 ec 14             	sub    $0x14,%esp
  800b33:	8b 45 10             	mov    0x10(%ebp),%eax
  800b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b39:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b3f:	8b 45 18             	mov    0x18(%ebp),%eax
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b4a:	77 55                	ja     800ba1 <printnum+0x75>
  800b4c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b4f:	72 05                	jb     800b56 <printnum+0x2a>
  800b51:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b54:	77 4b                	ja     800ba1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b56:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b59:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b5c:	8b 45 18             	mov    0x18(%ebp),%eax
  800b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b64:	52                   	push   %edx
  800b65:	50                   	push   %eax
  800b66:	ff 75 f4             	pushl  -0xc(%ebp)
  800b69:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6c:	e8 ab 38 00 00       	call   80441c <__udivdi3>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	83 ec 04             	sub    $0x4,%esp
  800b77:	ff 75 20             	pushl  0x20(%ebp)
  800b7a:	53                   	push   %ebx
  800b7b:	ff 75 18             	pushl  0x18(%ebp)
  800b7e:	52                   	push   %edx
  800b7f:	50                   	push   %eax
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	ff 75 08             	pushl  0x8(%ebp)
  800b86:	e8 a1 ff ff ff       	call   800b2c <printnum>
  800b8b:	83 c4 20             	add    $0x20,%esp
  800b8e:	eb 1a                	jmp    800baa <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 20             	pushl  0x20(%ebp)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ba1:	ff 4d 1c             	decl   0x1c(%ebp)
  800ba4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ba8:	7f e6                	jg     800b90 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800baa:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb8:	53                   	push   %ebx
  800bb9:	51                   	push   %ecx
  800bba:	52                   	push   %edx
  800bbb:	50                   	push   %eax
  800bbc:	e8 6b 39 00 00       	call   80452c <__umoddi3>
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	05 14 4d 80 00       	add    $0x804d14,%eax
  800bc9:	8a 00                	mov    (%eax),%al
  800bcb:	0f be c0             	movsbl %al,%eax
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	50                   	push   %eax
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
}
  800bdd:	90                   	nop
  800bde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800be6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bea:	7e 1c                	jle    800c08 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	8d 50 08             	lea    0x8(%eax),%edx
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 10                	mov    %edx,(%eax)
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	83 e8 08             	sub    $0x8,%eax
  800c01:	8b 50 04             	mov    0x4(%eax),%edx
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	eb 40                	jmp    800c48 <getuint+0x65>
	else if (lflag)
  800c08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0c:	74 1e                	je     800c2c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 00                	mov    (%eax),%eax
  800c13:	8d 50 04             	lea    0x4(%eax),%edx
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	89 10                	mov    %edx,(%eax)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8b 00                	mov    (%eax),%eax
  800c20:	83 e8 04             	sub    $0x4,%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2a:	eb 1c                	jmp    800c48 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	8d 50 04             	lea    0x4(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	89 10                	mov    %edx,(%eax)
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	83 e8 04             	sub    $0x4,%eax
  800c41:	8b 00                	mov    (%eax),%eax
  800c43:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c4d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c51:	7e 1c                	jle    800c6f <getint+0x25>
		return va_arg(*ap, long long);
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8b 00                	mov    (%eax),%eax
  800c58:	8d 50 08             	lea    0x8(%eax),%edx
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	89 10                	mov    %edx,(%eax)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8b 00                	mov    (%eax),%eax
  800c65:	83 e8 08             	sub    $0x8,%eax
  800c68:	8b 50 04             	mov    0x4(%eax),%edx
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	eb 38                	jmp    800ca7 <getint+0x5d>
	else if (lflag)
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	74 1a                	je     800c8f <getint+0x45>
		return va_arg(*ap, long);
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	8d 50 04             	lea    0x4(%eax),%edx
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	89 10                	mov    %edx,(%eax)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8b 00                	mov    (%eax),%eax
  800c87:	83 e8 04             	sub    $0x4,%eax
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	99                   	cltd   
  800c8d:	eb 18                	jmp    800ca7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8b 00                	mov    (%eax),%eax
  800c94:	8d 50 04             	lea    0x4(%eax),%edx
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	89 10                	mov    %edx,(%eax)
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	83 e8 04             	sub    $0x4,%eax
  800ca4:	8b 00                	mov    (%eax),%eax
  800ca6:	99                   	cltd   
}
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb1:	eb 17                	jmp    800cca <vprintfmt+0x21>
			if (ch == '\0')
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	0f 84 c1 03 00 00    	je     80107c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	53                   	push   %ebx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	ff d0                	call   *%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 01             	lea    0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f b6 d8             	movzbl %al,%ebx
  800cd8:	83 fb 25             	cmp    $0x25,%ebx
  800cdb:	75 d6                	jne    800cb3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800cdd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ce1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ce8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cf6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 10             	mov    %edx,0x10(%ebp)
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	0f b6 d8             	movzbl %al,%ebx
  800d0b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d0e:	83 f8 5b             	cmp    $0x5b,%eax
  800d11:	0f 87 3d 03 00 00    	ja     801054 <vprintfmt+0x3ab>
  800d17:	8b 04 85 38 4d 80 00 	mov    0x804d38(,%eax,4),%eax
  800d1e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d20:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d24:	eb d7                	jmp    800cfd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d26:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d2a:	eb d1                	jmp    800cfd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d2c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d36:	89 d0                	mov    %edx,%eax
  800d38:	c1 e0 02             	shl    $0x2,%eax
  800d3b:	01 d0                	add    %edx,%eax
  800d3d:	01 c0                	add    %eax,%eax
  800d3f:	01 d8                	add    %ebx,%eax
  800d41:	83 e8 30             	sub    $0x30,%eax
  800d44:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d4f:	83 fb 2f             	cmp    $0x2f,%ebx
  800d52:	7e 3e                	jle    800d92 <vprintfmt+0xe9>
  800d54:	83 fb 39             	cmp    $0x39,%ebx
  800d57:	7f 39                	jg     800d92 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d59:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d5c:	eb d5                	jmp    800d33 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d61:	83 c0 04             	add    $0x4,%eax
  800d64:	89 45 14             	mov    %eax,0x14(%ebp)
  800d67:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6a:	83 e8 04             	sub    $0x4,%eax
  800d6d:	8b 00                	mov    (%eax),%eax
  800d6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d72:	eb 1f                	jmp    800d93 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d78:	79 83                	jns    800cfd <vprintfmt+0x54>
				width = 0;
  800d7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d81:	e9 77 ff ff ff       	jmp    800cfd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d86:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d8d:	e9 6b ff ff ff       	jmp    800cfd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d92:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d97:	0f 89 60 ff ff ff    	jns    800cfd <vprintfmt+0x54>
				width = precision, precision = -1;
  800d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800da0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800da3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800daa:	e9 4e ff ff ff       	jmp    800cfd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800daf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800db2:	e9 46 ff ff ff       	jmp    800cfd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800db7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc3:	83 e8 04             	sub    $0x4,%eax
  800dc6:	8b 00                	mov    (%eax),%eax
  800dc8:	83 ec 08             	sub    $0x8,%esp
  800dcb:	ff 75 0c             	pushl  0xc(%ebp)
  800dce:	50                   	push   %eax
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	ff d0                	call   *%eax
  800dd4:	83 c4 10             	add    $0x10,%esp
			break;
  800dd7:	e9 9b 02 00 00       	jmp    801077 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ddc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddf:	83 c0 04             	add    $0x4,%eax
  800de2:	89 45 14             	mov    %eax,0x14(%ebp)
  800de5:	8b 45 14             	mov    0x14(%ebp),%eax
  800de8:	83 e8 04             	sub    $0x4,%eax
  800deb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ded:	85 db                	test   %ebx,%ebx
  800def:	79 02                	jns    800df3 <vprintfmt+0x14a>
				err = -err;
  800df1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800df3:	83 fb 64             	cmp    $0x64,%ebx
  800df6:	7f 0b                	jg     800e03 <vprintfmt+0x15a>
  800df8:	8b 34 9d 80 4b 80 00 	mov    0x804b80(,%ebx,4),%esi
  800dff:	85 f6                	test   %esi,%esi
  800e01:	75 19                	jne    800e1c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e03:	53                   	push   %ebx
  800e04:	68 25 4d 80 00       	push   $0x804d25
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	ff 75 08             	pushl  0x8(%ebp)
  800e0f:	e8 70 02 00 00       	call   801084 <printfmt>
  800e14:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e17:	e9 5b 02 00 00       	jmp    801077 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e1c:	56                   	push   %esi
  800e1d:	68 2e 4d 80 00       	push   $0x804d2e
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	ff 75 08             	pushl  0x8(%ebp)
  800e28:	e8 57 02 00 00       	call   801084 <printfmt>
  800e2d:	83 c4 10             	add    $0x10,%esp
			break;
  800e30:	e9 42 02 00 00       	jmp    801077 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e35:	8b 45 14             	mov    0x14(%ebp),%eax
  800e38:	83 c0 04             	add    $0x4,%eax
  800e3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e41:	83 e8 04             	sub    $0x4,%eax
  800e44:	8b 30                	mov    (%eax),%esi
  800e46:	85 f6                	test   %esi,%esi
  800e48:	75 05                	jne    800e4f <vprintfmt+0x1a6>
				p = "(null)";
  800e4a:	be 31 4d 80 00       	mov    $0x804d31,%esi
			if (width > 0 && padc != '-')
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	7e 6d                	jle    800ec2 <vprintfmt+0x219>
  800e55:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e59:	74 67                	je     800ec2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5e:	83 ec 08             	sub    $0x8,%esp
  800e61:	50                   	push   %eax
  800e62:	56                   	push   %esi
  800e63:	e8 26 05 00 00       	call   80138e <strnlen>
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e6e:	eb 16                	jmp    800e86 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e70:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	50                   	push   %eax
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	ff d0                	call   *%eax
  800e80:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e83:	ff 4d e4             	decl   -0x1c(%ebp)
  800e86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e8a:	7f e4                	jg     800e70 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8c:	eb 34                	jmp    800ec2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e92:	74 1c                	je     800eb0 <vprintfmt+0x207>
  800e94:	83 fb 1f             	cmp    $0x1f,%ebx
  800e97:	7e 05                	jle    800e9e <vprintfmt+0x1f5>
  800e99:	83 fb 7e             	cmp    $0x7e,%ebx
  800e9c:	7e 12                	jle    800eb0 <vprintfmt+0x207>
					putch('?', putdat);
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	ff 75 0c             	pushl  0xc(%ebp)
  800ea4:	6a 3f                	push   $0x3f
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	ff d0                	call   *%eax
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	eb 0f                	jmp    800ebf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eb0:	83 ec 08             	sub    $0x8,%esp
  800eb3:	ff 75 0c             	pushl  0xc(%ebp)
  800eb6:	53                   	push   %ebx
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	ff d0                	call   *%eax
  800ebc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec2:	89 f0                	mov    %esi,%eax
  800ec4:	8d 70 01             	lea    0x1(%eax),%esi
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f be d8             	movsbl %al,%ebx
  800ecc:	85 db                	test   %ebx,%ebx
  800ece:	74 24                	je     800ef4 <vprintfmt+0x24b>
  800ed0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ed4:	78 b8                	js     800e8e <vprintfmt+0x1e5>
  800ed6:	ff 4d e0             	decl   -0x20(%ebp)
  800ed9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800edd:	79 af                	jns    800e8e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800edf:	eb 13                	jmp    800ef4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ee1:	83 ec 08             	sub    $0x8,%esp
  800ee4:	ff 75 0c             	pushl  0xc(%ebp)
  800ee7:	6a 20                	push   $0x20
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	ff d0                	call   *%eax
  800eee:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ef4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef8:	7f e7                	jg     800ee1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800efa:	e9 78 01 00 00       	jmp    801077 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eff:	83 ec 08             	sub    $0x8,%esp
  800f02:	ff 75 e8             	pushl  -0x18(%ebp)
  800f05:	8d 45 14             	lea    0x14(%ebp),%eax
  800f08:	50                   	push   %eax
  800f09:	e8 3c fd ff ff       	call   800c4a <getint>
  800f0e:	83 c4 10             	add    $0x10,%esp
  800f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1d:	85 d2                	test   %edx,%edx
  800f1f:	79 23                	jns    800f44 <vprintfmt+0x29b>
				putch('-', putdat);
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	6a 2d                	push   $0x2d
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	ff d0                	call   *%eax
  800f2e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f37:	f7 d8                	neg    %eax
  800f39:	83 d2 00             	adc    $0x0,%edx
  800f3c:	f7 da                	neg    %edx
  800f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f4b:	e9 bc 00 00 00       	jmp    80100c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f50:	83 ec 08             	sub    $0x8,%esp
  800f53:	ff 75 e8             	pushl  -0x18(%ebp)
  800f56:	8d 45 14             	lea    0x14(%ebp),%eax
  800f59:	50                   	push   %eax
  800f5a:	e8 84 fc ff ff       	call   800be3 <getuint>
  800f5f:	83 c4 10             	add    $0x10,%esp
  800f62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f6f:	e9 98 00 00 00       	jmp    80100c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 0c             	pushl  0xc(%ebp)
  800f7a:	6a 58                	push   $0x58
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	ff d0                	call   *%eax
  800f81:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 58                	push   $0x58
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	6a 58                	push   $0x58
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	ff d0                	call   *%eax
  800fa1:	83 c4 10             	add    $0x10,%esp
			break;
  800fa4:	e9 ce 00 00 00       	jmp    801077 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	ff 75 0c             	pushl  0xc(%ebp)
  800faf:	6a 30                	push   $0x30
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	ff d0                	call   *%eax
  800fb6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 78                	push   $0x78
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd5:	83 e8 04             	sub    $0x4,%eax
  800fd8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fe4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800feb:	eb 1f                	jmp    80100c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fed:	83 ec 08             	sub    $0x8,%esp
  800ff0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff6:	50                   	push   %eax
  800ff7:	e8 e7 fb ff ff       	call   800be3 <getuint>
  800ffc:	83 c4 10             	add    $0x10,%esp
  800fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801002:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801005:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80100c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	52                   	push   %edx
  801017:	ff 75 e4             	pushl  -0x1c(%ebp)
  80101a:	50                   	push   %eax
  80101b:	ff 75 f4             	pushl  -0xc(%ebp)
  80101e:	ff 75 f0             	pushl  -0x10(%ebp)
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	ff 75 08             	pushl  0x8(%ebp)
  801027:	e8 00 fb ff ff       	call   800b2c <printnum>
  80102c:	83 c4 20             	add    $0x20,%esp
			break;
  80102f:	eb 46                	jmp    801077 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	53                   	push   %ebx
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			break;
  801040:	eb 35                	jmp    801077 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801042:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  801049:	eb 2c                	jmp    801077 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80104b:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  801052:	eb 23                	jmp    801077 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801054:	83 ec 08             	sub    $0x8,%esp
  801057:	ff 75 0c             	pushl  0xc(%ebp)
  80105a:	6a 25                	push   $0x25
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	ff d0                	call   *%eax
  801061:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801064:	ff 4d 10             	decl   0x10(%ebp)
  801067:	eb 03                	jmp    80106c <vprintfmt+0x3c3>
  801069:	ff 4d 10             	decl   0x10(%ebp)
  80106c:	8b 45 10             	mov    0x10(%ebp),%eax
  80106f:	48                   	dec    %eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 25                	cmp    $0x25,%al
  801074:	75 f3                	jne    801069 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801076:	90                   	nop
		}
	}
  801077:	e9 35 fc ff ff       	jmp    800cb1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80107c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80107d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80108a:	8d 45 10             	lea    0x10(%ebp),%eax
  80108d:	83 c0 04             	add    $0x4,%eax
  801090:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	ff 75 f4             	pushl  -0xc(%ebp)
  801099:	50                   	push   %eax
  80109a:	ff 75 0c             	pushl  0xc(%ebp)
  80109d:	ff 75 08             	pushl  0x8(%ebp)
  8010a0:	e8 04 fc ff ff       	call   800ca9 <vprintfmt>
  8010a5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010a8:	90                   	nop
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	8b 40 08             	mov    0x8(%eax),%eax
  8010b4:	8d 50 01             	lea    0x1(%eax),%edx
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c0:	8b 10                	mov    (%eax),%edx
  8010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c5:	8b 40 04             	mov    0x4(%eax),%eax
  8010c8:	39 c2                	cmp    %eax,%edx
  8010ca:	73 12                	jae    8010de <sprintputch+0x33>
		*b->buf++ = ch;
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	8d 48 01             	lea    0x1(%eax),%ecx
  8010d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d7:	89 0a                	mov    %ecx,(%edx)
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	88 10                	mov    %dl,(%eax)
}
  8010de:	90                   	nop
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801106:	74 06                	je     80110e <vsnprintf+0x2d>
  801108:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80110c:	7f 07                	jg     801115 <vsnprintf+0x34>
		return -E_INVAL;
  80110e:	b8 03 00 00 00       	mov    $0x3,%eax
  801113:	eb 20                	jmp    801135 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801115:	ff 75 14             	pushl  0x14(%ebp)
  801118:	ff 75 10             	pushl  0x10(%ebp)
  80111b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80111e:	50                   	push   %eax
  80111f:	68 ab 10 80 00       	push   $0x8010ab
  801124:	e8 80 fb ff ff       	call   800ca9 <vprintfmt>
  801129:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80112c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80112f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801132:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80113d:	8d 45 10             	lea    0x10(%ebp),%eax
  801140:	83 c0 04             	add    $0x4,%eax
  801143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	ff 75 f4             	pushl  -0xc(%ebp)
  80114c:	50                   	push   %eax
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	ff 75 08             	pushl  0x8(%ebp)
  801153:	e8 89 ff ff ff       	call   8010e1 <vsnprintf>
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80115e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801169:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116d:	74 13                	je     801182 <readline+0x1f>
		cprintf("%s", prompt);
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	ff 75 08             	pushl  0x8(%ebp)
  801175:	68 a8 4e 80 00       	push   $0x804ea8
  80117a:	e8 0b f9 ff ff       	call   800a8a <cprintf>
  80117f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	6a 00                	push   $0x0
  80118e:	e8 6f f4 ff ff       	call   800602 <iscons>
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801199:	e8 51 f4 ff ff       	call   8005ef <getchar>
  80119e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a5:	79 22                	jns    8011c9 <readline+0x66>
			if (c != -E_EOF)
  8011a7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011ab:	0f 84 ad 00 00 00    	je     80125e <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011b1:	83 ec 08             	sub    $0x8,%esp
  8011b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8011b7:	68 ab 4e 80 00       	push   $0x804eab
  8011bc:	e8 c9 f8 ff ff       	call   800a8a <cprintf>
  8011c1:	83 c4 10             	add    $0x10,%esp
			break;
  8011c4:	e9 95 00 00 00       	jmp    80125e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011cd:	7e 34                	jle    801203 <readline+0xa0>
  8011cf:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d6:	7f 2b                	jg     801203 <readline+0xa0>
			if (echoing)
  8011d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011dc:	74 0e                	je     8011ec <readline+0x89>
				cputchar(c);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e4:	e8 e7 f3 ff ff       	call   8005d0 <cputchar>
  8011e9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ef:	8d 50 01             	lea    0x1(%eax),%edx
  8011f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f5:	89 c2                	mov    %eax,%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ff:	88 10                	mov    %dl,(%eax)
  801201:	eb 56                	jmp    801259 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801203:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801207:	75 1f                	jne    801228 <readline+0xc5>
  801209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120d:	7e 19                	jle    801228 <readline+0xc5>
			if (echoing)
  80120f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801213:	74 0e                	je     801223 <readline+0xc0>
				cputchar(c);
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	ff 75 ec             	pushl  -0x14(%ebp)
  80121b:	e8 b0 f3 ff ff       	call   8005d0 <cputchar>
  801220:	83 c4 10             	add    $0x10,%esp

			i--;
  801223:	ff 4d f4             	decl   -0xc(%ebp)
  801226:	eb 31                	jmp    801259 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801228:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80122c:	74 0a                	je     801238 <readline+0xd5>
  80122e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801232:	0f 85 61 ff ff ff    	jne    801199 <readline+0x36>
			if (echoing)
  801238:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80123c:	74 0e                	je     80124c <readline+0xe9>
				cputchar(c);
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	ff 75 ec             	pushl  -0x14(%ebp)
  801244:	e8 87 f3 ff ff       	call   8005d0 <cputchar>
  801249:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80124c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	01 d0                	add    %edx,%eax
  801254:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801257:	eb 06                	jmp    80125f <readline+0xfc>
		}
	}
  801259:	e9 3b ff ff ff       	jmp    801199 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80125e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80125f:	90                   	nop
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801268:	e8 df 21 00 00       	call   80344c <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80126d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801271:	74 13                	je     801286 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801273:	83 ec 08             	sub    $0x8,%esp
  801276:	ff 75 08             	pushl  0x8(%ebp)
  801279:	68 a8 4e 80 00       	push   $0x804ea8
  80127e:	e8 07 f8 ff ff       	call   800a8a <cprintf>
  801283:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801286:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	6a 00                	push   $0x0
  801292:	e8 6b f3 ff ff       	call   800602 <iscons>
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80129d:	e8 4d f3 ff ff       	call   8005ef <getchar>
  8012a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012a9:	79 22                	jns    8012cd <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012ab:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012af:	0f 84 ad 00 00 00    	je     801362 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012b5:	83 ec 08             	sub    $0x8,%esp
  8012b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012bb:	68 ab 4e 80 00       	push   $0x804eab
  8012c0:	e8 c5 f7 ff ff       	call   800a8a <cprintf>
  8012c5:	83 c4 10             	add    $0x10,%esp
				break;
  8012c8:	e9 95 00 00 00       	jmp    801362 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012cd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012d1:	7e 34                	jle    801307 <atomic_readline+0xa5>
  8012d3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012da:	7f 2b                	jg     801307 <atomic_readline+0xa5>
				if (echoing)
  8012dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e0:	74 0e                	je     8012f0 <atomic_readline+0x8e>
					cputchar(c);
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e8:	e8 e3 f2 ff ff       	call   8005d0 <cputchar>
  8012ed:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f3:	8d 50 01             	lea    0x1(%eax),%edx
  8012f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012f9:	89 c2                	mov    %eax,%edx
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	01 d0                	add    %edx,%eax
  801300:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801303:	88 10                	mov    %dl,(%eax)
  801305:	eb 56                	jmp    80135d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801307:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80130b:	75 1f                	jne    80132c <atomic_readline+0xca>
  80130d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801311:	7e 19                	jle    80132c <atomic_readline+0xca>
				if (echoing)
  801313:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801317:	74 0e                	je     801327 <atomic_readline+0xc5>
					cputchar(c);
  801319:	83 ec 0c             	sub    $0xc,%esp
  80131c:	ff 75 ec             	pushl  -0x14(%ebp)
  80131f:	e8 ac f2 ff ff       	call   8005d0 <cputchar>
  801324:	83 c4 10             	add    $0x10,%esp
				i--;
  801327:	ff 4d f4             	decl   -0xc(%ebp)
  80132a:	eb 31                	jmp    80135d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80132c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801330:	74 0a                	je     80133c <atomic_readline+0xda>
  801332:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801336:	0f 85 61 ff ff ff    	jne    80129d <atomic_readline+0x3b>
				if (echoing)
  80133c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801340:	74 0e                	je     801350 <atomic_readline+0xee>
					cputchar(c);
  801342:	83 ec 0c             	sub    $0xc,%esp
  801345:	ff 75 ec             	pushl  -0x14(%ebp)
  801348:	e8 83 f2 ff ff       	call   8005d0 <cputchar>
  80134d:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80135b:	eb 06                	jmp    801363 <atomic_readline+0x101>
			}
		}
  80135d:	e9 3b ff ff ff       	jmp    80129d <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801362:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801363:	e8 fe 20 00 00       	call   803466 <sys_unlock_cons>
}
  801368:	90                   	nop
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801378:	eb 06                	jmp    801380 <strlen+0x15>
		n++;
  80137a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	84 c0                	test   %al,%al
  801387:	75 f1                	jne    80137a <strlen+0xf>
		n++;
	return n;
  801389:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801394:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139b:	eb 09                	jmp    8013a6 <strnlen+0x18>
		n++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a0:	ff 45 08             	incl   0x8(%ebp)
  8013a3:	ff 4d 0c             	decl   0xc(%ebp)
  8013a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013aa:	74 09                	je     8013b5 <strnlen+0x27>
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	84 c0                	test   %al,%al
  8013b3:	75 e8                	jne    80139d <strnlen+0xf>
		n++;
	return n;
  8013b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013c6:	90                   	nop
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8d 50 01             	lea    0x1(%eax),%edx
  8013cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013d9:	8a 12                	mov    (%edx),%dl
  8013db:	88 10                	mov    %dl,(%eax)
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	84 c0                	test   %al,%al
  8013e1:	75 e4                	jne    8013c7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fb:	eb 1f                	jmp    80141c <strncpy+0x34>
		*dst++ = *src;
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8d 50 01             	lea    0x1(%eax),%edx
  801403:	89 55 08             	mov    %edx,0x8(%ebp)
  801406:	8b 55 0c             	mov    0xc(%ebp),%edx
  801409:	8a 12                	mov    (%edx),%dl
  80140b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	8a 00                	mov    (%eax),%al
  801412:	84 c0                	test   %al,%al
  801414:	74 03                	je     801419 <strncpy+0x31>
			src++;
  801416:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801419:	ff 45 fc             	incl   -0x4(%ebp)
  80141c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801422:	72 d9                	jb     8013fd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801424:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801435:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801439:	74 30                	je     80146b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80143b:	eb 16                	jmp    801453 <strlcpy+0x2a>
			*dst++ = *src++;
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8d 50 01             	lea    0x1(%eax),%edx
  801443:	89 55 08             	mov    %edx,0x8(%ebp)
  801446:	8b 55 0c             	mov    0xc(%ebp),%edx
  801449:	8d 4a 01             	lea    0x1(%edx),%ecx
  80144c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80144f:	8a 12                	mov    (%edx),%dl
  801451:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801453:	ff 4d 10             	decl   0x10(%ebp)
  801456:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145a:	74 09                	je     801465 <strlcpy+0x3c>
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	84 c0                	test   %al,%al
  801463:	75 d8                	jne    80143d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80146b:	8b 55 08             	mov    0x8(%ebp),%edx
  80146e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801471:	29 c2                	sub    %eax,%edx
  801473:	89 d0                	mov    %edx,%eax
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80147a:	eb 06                	jmp    801482 <strcmp+0xb>
		p++, q++;
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 0e                	je     801499 <strcmp+0x22>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 10                	mov    (%eax),%dl
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	38 c2                	cmp    %al,%dl
  801497:	74 e3                	je     80147c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	0f b6 d0             	movzbl %al,%edx
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f b6 c0             	movzbl %al,%eax
  8014a9:	29 c2                	sub    %eax,%edx
  8014ab:	89 d0                	mov    %edx,%eax
}
  8014ad:	5d                   	pop    %ebp
  8014ae:	c3                   	ret    

008014af <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014b2:	eb 09                	jmp    8014bd <strncmp+0xe>
		n--, p++, q++;
  8014b4:	ff 4d 10             	decl   0x10(%ebp)
  8014b7:	ff 45 08             	incl   0x8(%ebp)
  8014ba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c1:	74 17                	je     8014da <strncmp+0x2b>
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	84 c0                	test   %al,%al
  8014ca:	74 0e                	je     8014da <strncmp+0x2b>
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 10                	mov    (%eax),%dl
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	38 c2                	cmp    %al,%dl
  8014d8:	74 da                	je     8014b4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014de:	75 07                	jne    8014e7 <strncmp+0x38>
		return 0;
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e5:	eb 14                	jmp    8014fb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	0f b6 d0             	movzbl %al,%edx
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	0f b6 c0             	movzbl %al,%eax
  8014f7:	29 c2                	sub    %eax,%edx
  8014f9:	89 d0                	mov    %edx,%eax
}
  8014fb:	5d                   	pop    %ebp
  8014fc:	c3                   	ret    

008014fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801509:	eb 12                	jmp    80151d <strchr+0x20>
		if (*s == c)
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801513:	75 05                	jne    80151a <strchr+0x1d>
			return (char *) s;
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	eb 11                	jmp    80152b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80151a:	ff 45 08             	incl   0x8(%ebp)
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	84 c0                	test   %al,%al
  801524:	75 e5                	jne    80150b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801539:	eb 0d                	jmp    801548 <strfind+0x1b>
		if (*s == c)
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801543:	74 0e                	je     801553 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801545:	ff 45 08             	incl   0x8(%ebp)
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	84 c0                	test   %al,%al
  80154f:	75 ea                	jne    80153b <strfind+0xe>
  801551:	eb 01                	jmp    801554 <strfind+0x27>
		if (*s == c)
			break;
  801553:	90                   	nop
	return (char *) s;
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801565:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801569:	76 63                	jbe    8015ce <memset+0x75>
		uint64 data_block = c;
  80156b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156e:	99                   	cltd   
  80156f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801572:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80157f:	c1 e0 08             	shl    $0x8,%eax
  801582:	09 45 f0             	or     %eax,-0x10(%ebp)
  801585:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801592:	c1 e0 10             	shl    $0x10,%eax
  801595:	09 45 f0             	or     %eax,-0x10(%ebp)
  801598:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a1:	89 c2                	mov    %eax,%edx
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a8:	09 45 f0             	or     %eax,-0x10(%ebp)
  8015ab:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015ae:	eb 18                	jmp    8015c8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015b3:	8d 41 08             	lea    0x8(%ecx),%eax
  8015b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015bf:	89 01                	mov    %eax,(%ecx)
  8015c1:	89 51 04             	mov    %edx,0x4(%ecx)
  8015c4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015c8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015cc:	77 e2                	ja     8015b0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d2:	74 23                	je     8015f7 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015da:	eb 0e                	jmp    8015ea <memset+0x91>
			*p8++ = (uint8)c;
  8015dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015df:	8d 50 01             	lea    0x1(%eax),%edx
  8015e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	75 e5                	jne    8015dc <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801602:	8b 45 0c             	mov    0xc(%ebp),%eax
  801605:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80160e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801612:	76 24                	jbe    801638 <memcpy+0x3c>
		while(n >= 8){
  801614:	eb 1c                	jmp    801632 <memcpy+0x36>
			*d64 = *s64;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8b 50 04             	mov    0x4(%eax),%edx
  80161c:	8b 00                	mov    (%eax),%eax
  80161e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801621:	89 01                	mov    %eax,(%ecx)
  801623:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801626:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80162a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80162e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801632:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801636:	77 de                	ja     801616 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163c:	74 31                	je     80166f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80163e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801644:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801647:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80164a:	eb 16                	jmp    801662 <memcpy+0x66>
			*d8++ = *s8++;
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801655:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	8d 50 ff             	lea    -0x1(%eax),%edx
  801668:	89 55 10             	mov    %edx,0x10(%ebp)
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 dd                	jne    80164c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80168c:	73 50                	jae    8016de <memmove+0x6a>
  80168e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801691:	8b 45 10             	mov    0x10(%ebp),%eax
  801694:	01 d0                	add    %edx,%eax
  801696:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801699:	76 43                	jbe    8016de <memmove+0x6a>
		s += n;
  80169b:	8b 45 10             	mov    0x10(%ebp),%eax
  80169e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a7:	eb 10                	jmp    8016b9 <memmove+0x45>
			*--d = *--s;
  8016a9:	ff 4d f8             	decl   -0x8(%ebp)
  8016ac:	ff 4d fc             	decl   -0x4(%ebp)
  8016af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b2:	8a 10                	mov    (%eax),%dl
  8016b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	75 e3                	jne    8016a9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016c6:	eb 23                	jmp    8016eb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016da:	8a 12                	mov    (%edx),%dl
  8016dc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016de:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	75 dd                	jne    8016c8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ff:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801702:	eb 2a                	jmp    80172e <memcmp+0x3e>
		if (*s1 != *s2)
  801704:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801707:	8a 10                	mov    (%eax),%dl
  801709:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	38 c2                	cmp    %al,%dl
  801710:	74 16                	je     801728 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f b6 d0             	movzbl %al,%edx
  80171a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	29 c2                	sub    %eax,%edx
  801724:	89 d0                	mov    %edx,%eax
  801726:	eb 18                	jmp    801740 <memcmp+0x50>
		s1++, s2++;
  801728:	ff 45 fc             	incl   -0x4(%ebp)
  80172b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	8d 50 ff             	lea    -0x1(%eax),%edx
  801734:	89 55 10             	mov    %edx,0x10(%ebp)
  801737:	85 c0                	test   %eax,%eax
  801739:	75 c9                	jne    801704 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801748:	8b 55 08             	mov    0x8(%ebp),%edx
  80174b:	8b 45 10             	mov    0x10(%ebp),%eax
  80174e:	01 d0                	add    %edx,%eax
  801750:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801753:	eb 15                	jmp    80176a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	0f b6 d0             	movzbl %al,%edx
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	0f b6 c0             	movzbl %al,%eax
  801763:	39 c2                	cmp    %eax,%edx
  801765:	74 0d                	je     801774 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801767:	ff 45 08             	incl   0x8(%ebp)
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801770:	72 e3                	jb     801755 <memfind+0x13>
  801772:	eb 01                	jmp    801775 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801774:	90                   	nop
	return (void *) s;
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801780:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801787:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178e:	eb 03                	jmp    801793 <strtol+0x19>
		s++;
  801790:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	8a 00                	mov    (%eax),%al
  801798:	3c 20                	cmp    $0x20,%al
  80179a:	74 f4                	je     801790 <strtol+0x16>
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	8a 00                	mov    (%eax),%al
  8017a1:	3c 09                	cmp    $0x9,%al
  8017a3:	74 eb                	je     801790 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	3c 2b                	cmp    $0x2b,%al
  8017ac:	75 05                	jne    8017b3 <strtol+0x39>
		s++;
  8017ae:	ff 45 08             	incl   0x8(%ebp)
  8017b1:	eb 13                	jmp    8017c6 <strtol+0x4c>
	else if (*s == '-')
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	3c 2d                	cmp    $0x2d,%al
  8017ba:	75 0a                	jne    8017c6 <strtol+0x4c>
		s++, neg = 1;
  8017bc:	ff 45 08             	incl   0x8(%ebp)
  8017bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ca:	74 06                	je     8017d2 <strtol+0x58>
  8017cc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017d0:	75 20                	jne    8017f2 <strtol+0x78>
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	3c 30                	cmp    $0x30,%al
  8017d9:	75 17                	jne    8017f2 <strtol+0x78>
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	40                   	inc    %eax
  8017df:	8a 00                	mov    (%eax),%al
  8017e1:	3c 78                	cmp    $0x78,%al
  8017e3:	75 0d                	jne    8017f2 <strtol+0x78>
		s += 2, base = 16;
  8017e5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017f0:	eb 28                	jmp    80181a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f6:	75 15                	jne    80180d <strtol+0x93>
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	8a 00                	mov    (%eax),%al
  8017fd:	3c 30                	cmp    $0x30,%al
  8017ff:	75 0c                	jne    80180d <strtol+0x93>
		s++, base = 8;
  801801:	ff 45 08             	incl   0x8(%ebp)
  801804:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80180b:	eb 0d                	jmp    80181a <strtol+0xa0>
	else if (base == 0)
  80180d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801811:	75 07                	jne    80181a <strtol+0xa0>
		base = 10;
  801813:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	3c 2f                	cmp    $0x2f,%al
  801821:	7e 19                	jle    80183c <strtol+0xc2>
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8a 00                	mov    (%eax),%al
  801828:	3c 39                	cmp    $0x39,%al
  80182a:	7f 10                	jg     80183c <strtol+0xc2>
			dig = *s - '0';
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8a 00                	mov    (%eax),%al
  801831:	0f be c0             	movsbl %al,%eax
  801834:	83 e8 30             	sub    $0x30,%eax
  801837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80183a:	eb 42                	jmp    80187e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	8a 00                	mov    (%eax),%al
  801841:	3c 60                	cmp    $0x60,%al
  801843:	7e 19                	jle    80185e <strtol+0xe4>
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	8a 00                	mov    (%eax),%al
  80184a:	3c 7a                	cmp    $0x7a,%al
  80184c:	7f 10                	jg     80185e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	0f be c0             	movsbl %al,%eax
  801856:	83 e8 57             	sub    $0x57,%eax
  801859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185c:	eb 20                	jmp    80187e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	8a 00                	mov    (%eax),%al
  801863:	3c 40                	cmp    $0x40,%al
  801865:	7e 39                	jle    8018a0 <strtol+0x126>
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	3c 5a                	cmp    $0x5a,%al
  80186e:	7f 30                	jg     8018a0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	8a 00                	mov    (%eax),%al
  801875:	0f be c0             	movsbl %al,%eax
  801878:	83 e8 37             	sub    $0x37,%eax
  80187b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	3b 45 10             	cmp    0x10(%ebp),%eax
  801884:	7d 19                	jge    80189f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801886:	ff 45 08             	incl   0x8(%ebp)
  801889:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801890:	89 c2                	mov    %eax,%edx
  801892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801895:	01 d0                	add    %edx,%eax
  801897:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80189a:	e9 7b ff ff ff       	jmp    80181a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80189f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018a4:	74 08                	je     8018ae <strtol+0x134>
		*endptr = (char *) s;
  8018a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ac:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018b2:	74 07                	je     8018bb <strtol+0x141>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b7:	f7 d8                	neg    %eax
  8018b9:	eb 03                	jmp    8018be <strtol+0x144>
  8018bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <ltostr>:

void
ltostr(long value, char *str)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d8:	79 13                	jns    8018ed <ltostr+0x2d>
	{
		neg = 1;
  8018da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018ea:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018f5:	99                   	cltd   
  8018f6:	f7 f9                	idiv   %ecx
  8018f8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fe:	8d 50 01             	lea    0x1(%eax),%edx
  801901:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801904:	89 c2                	mov    %eax,%edx
  801906:	8b 45 0c             	mov    0xc(%ebp),%eax
  801909:	01 d0                	add    %edx,%eax
  80190b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80190e:	83 c2 30             	add    $0x30,%edx
  801911:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801913:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801916:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80191b:	f7 e9                	imul   %ecx
  80191d:	c1 fa 02             	sar    $0x2,%edx
  801920:	89 c8                	mov    %ecx,%eax
  801922:	c1 f8 1f             	sar    $0x1f,%eax
  801925:	29 c2                	sub    %eax,%edx
  801927:	89 d0                	mov    %edx,%eax
  801929:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80192c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801930:	75 bb                	jne    8018ed <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801939:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193c:	48                   	dec    %eax
  80193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801940:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801944:	74 3d                	je     801983 <ltostr+0xc3>
		start = 1 ;
  801946:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80194d:	eb 34                	jmp    801983 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80194f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801952:	8b 45 0c             	mov    0xc(%ebp),%eax
  801955:	01 d0                	add    %edx,%eax
  801957:	8a 00                	mov    (%eax),%al
  801959:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80195c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801962:	01 c2                	add    %eax,%edx
  801964:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	01 c8                	add    %ecx,%eax
  80196c:	8a 00                	mov    (%eax),%al
  80196e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801970:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	01 c2                	add    %eax,%edx
  801978:	8a 45 eb             	mov    -0x15(%ebp),%al
  80197b:	88 02                	mov    %al,(%edx)
		start++ ;
  80197d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801980:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801986:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801989:	7c c4                	jl     80194f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80198b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80198e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801991:	01 d0                	add    %edx,%eax
  801993:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	e8 c4 f9 ff ff       	call   80136b <strlen>
  8019a7:	83 c4 04             	add    $0x4,%esp
  8019aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	e8 b6 f9 ff ff       	call   80136b <strlen>
  8019b5:	83 c4 04             	add    $0x4,%esp
  8019b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019c9:	eb 17                	jmp    8019e2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d1:	01 c2                	add    %eax,%edx
  8019d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	01 c8                	add    %ecx,%eax
  8019db:	8a 00                	mov    (%eax),%al
  8019dd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019df:	ff 45 fc             	incl   -0x4(%ebp)
  8019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019e8:	7c e1                	jl     8019cb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019f8:	eb 1f                	jmp    801a19 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	01 c2                	add    %eax,%edx
  801a0a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a10:	01 c8                	add    %ecx,%eax
  801a12:	8a 00                	mov    (%eax),%al
  801a14:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a16:	ff 45 f8             	incl   -0x8(%ebp)
  801a19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a1f:	7c d9                	jl     8019fa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a24:	8b 45 10             	mov    0x10(%ebp),%eax
  801a27:	01 d0                	add    %edx,%eax
  801a29:	c6 00 00             	movb   $0x0,(%eax)
}
  801a2c:	90                   	nop
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a32:	8b 45 14             	mov    0x14(%ebp),%eax
  801a35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 d0                	add    %edx,%eax
  801a4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a52:	eb 0c                	jmp    801a60 <strsplit+0x31>
			*string++ = 0;
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	8d 50 01             	lea    0x1(%eax),%edx
  801a5a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a5d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8a 00                	mov    (%eax),%al
  801a65:	84 c0                	test   %al,%al
  801a67:	74 18                	je     801a81 <strsplit+0x52>
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8a 00                	mov    (%eax),%al
  801a6e:	0f be c0             	movsbl %al,%eax
  801a71:	50                   	push   %eax
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	e8 83 fa ff ff       	call   8014fd <strchr>
  801a7a:	83 c4 08             	add    $0x8,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	75 d3                	jne    801a54 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	84 c0                	test   %al,%al
  801a88:	74 5a                	je     801ae4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8d:	8b 00                	mov    (%eax),%eax
  801a8f:	83 f8 0f             	cmp    $0xf,%eax
  801a92:	75 07                	jne    801a9b <strsplit+0x6c>
		{
			return 0;
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
  801a99:	eb 66                	jmp    801b01 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9e:	8b 00                	mov    (%eax),%eax
  801aa0:	8d 48 01             	lea    0x1(%eax),%ecx
  801aa3:	8b 55 14             	mov    0x14(%ebp),%edx
  801aa6:	89 0a                	mov    %ecx,(%edx)
  801aa8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab2:	01 c2                	add    %eax,%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ab9:	eb 03                	jmp    801abe <strsplit+0x8f>
			string++;
  801abb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8a 00                	mov    (%eax),%al
  801ac3:	84 c0                	test   %al,%al
  801ac5:	74 8b                	je     801a52 <strsplit+0x23>
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	8a 00                	mov    (%eax),%al
  801acc:	0f be c0             	movsbl %al,%eax
  801acf:	50                   	push   %eax
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	e8 25 fa ff ff       	call   8014fd <strchr>
  801ad8:	83 c4 08             	add    $0x8,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	74 dc                	je     801abb <strsplit+0x8c>
			string++;
	}
  801adf:	e9 6e ff ff ff       	jmp    801a52 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ae4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae8:	8b 00                	mov    (%eax),%eax
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 d0                	add    %edx,%eax
  801af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801afc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b16:	eb 4a                	jmp    801b62 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	01 c2                	add    %eax,%edx
  801b20:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b26:	01 c8                	add    %ecx,%eax
  801b28:	8a 00                	mov    (%eax),%al
  801b2a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b32:	01 d0                	add    %edx,%eax
  801b34:	8a 00                	mov    (%eax),%al
  801b36:	3c 40                	cmp    $0x40,%al
  801b38:	7e 25                	jle    801b5f <str2lower+0x5c>
  801b3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b40:	01 d0                	add    %edx,%eax
  801b42:	8a 00                	mov    (%eax),%al
  801b44:	3c 5a                	cmp    $0x5a,%al
  801b46:	7f 17                	jg     801b5f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b53:	8b 55 08             	mov    0x8(%ebp),%edx
  801b56:	01 ca                	add    %ecx,%edx
  801b58:	8a 12                	mov    (%edx),%dl
  801b5a:	83 c2 20             	add    $0x20,%edx
  801b5d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b5f:	ff 45 fc             	incl   -0x4(%ebp)
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	e8 01 f8 ff ff       	call   80136b <strlen>
  801b6a:	83 c4 04             	add    $0x4,%esp
  801b6d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b70:	7f a6                	jg     801b18 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b72:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b7d:	a1 08 60 80 00       	mov    0x806008,%eax
  801b82:	85 c0                	test   %eax,%eax
  801b84:	74 42                	je     801bc8 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b86:	83 ec 08             	sub    $0x8,%esp
  801b89:	68 00 00 00 82       	push   $0x82000000
  801b8e:	68 00 00 00 80       	push   $0x80000000
  801b93:	e8 b0 1e 00 00       	call   803a48 <initialize_dynamic_allocator>
  801b98:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b9b:	e8 96 1c 00 00       	call   803836 <sys_get_uheap_strategy>
  801ba0:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801ba5:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801baa:	05 00 10 00 00       	add    $0x1000,%eax
  801baf:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801bb4:	a1 30 61 83 00       	mov    0x836130,%eax
  801bb9:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801bbe:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801bc5:	00 00 00 
	}
}
  801bc8:	90                   	nop
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	68 06 04 00 00       	push   $0x406
  801be7:	50                   	push   %eax
  801be8:	e8 93 18 00 00       	call   803480 <__sys_allocate_page>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf7:	79 14                	jns    801c0d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	68 bc 4e 80 00       	push   $0x804ebc
  801c01:	6a 1f                	push   $0x1f
  801c03:	68 f8 4e 80 00       	push   $0x804ef8
  801c08:	e8 af eb ff ff       	call   8007bc <_panic>
	return 0;
  801c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	50                   	push   %eax
  801c2c:	e8 96 18 00 00       	call   8034c7 <__sys_unmap_frame>
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c3b:	79 14                	jns    801c51 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c3d:	83 ec 04             	sub    $0x4,%esp
  801c40:	68 04 4f 80 00       	push   $0x804f04
  801c45:	6a 2a                	push   $0x2a
  801c47:	68 f8 4e 80 00       	push   $0x804ef8
  801c4c:	e8 6b eb ff ff       	call   8007bc <_panic>
}
  801c51:	90                   	nop
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c5a:	e8 18 ff ff ff       	call   801b77 <uheap_init>
	if (size == 0) return NULL ;
  801c5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c63:	75 0a                	jne    801c6f <malloc+0x1b>
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	e9 43 03 00 00       	jmp    801fb2 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c6f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c76:	77 13                	ja     801c8b <malloc+0x37>
    {
        return alloc_block(size);
  801c78:	83 ec 0c             	sub    $0xc,%esp
  801c7b:	ff 75 08             	pushl  0x8(%ebp)
  801c7e:	e8 78 20 00 00       	call   803cfb <alloc_block>
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	e9 27 03 00 00       	jmp    801fb2 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801c8b:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c92:	8b 55 08             	mov    0x8(%ebp),%edx
  801c95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c98:	01 d0                	add    %edx,%eax
  801c9a:	48                   	dec    %eax
  801c9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca6:	f7 75 dc             	divl   -0x24(%ebp)
  801ca9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cac:	29 d0                	sub    %edx,%eax
  801cae:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801cb1:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	75 0a                	jne    801cc4 <malloc+0x70>
    {
        uhp_inited = 1;
  801cba:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801cc1:	00 00 00 
    }

    int exactIdx = -1;
  801cc4:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ccb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801cd2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cd9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ce0:	e9 85 00 00 00       	jmp    801d6a <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ce5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ce8:	89 d0                	mov    %edx,%eax
  801cea:	01 c0                	add    %eax,%eax
  801cec:	01 d0                	add    %edx,%eax
  801cee:	c1 e0 02             	shl    $0x2,%eax
  801cf1:	05 48 20 81 00       	add    $0x812048,%eax
  801cf6:	8a 00                	mov    (%eax),%al
  801cf8:	84 c0                	test   %al,%al
  801cfa:	74 20                	je     801d1c <malloc+0xc8>
  801cfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cff:	89 d0                	mov    %edx,%eax
  801d01:	01 c0                	add    %eax,%eax
  801d03:	01 d0                	add    %edx,%eax
  801d05:	c1 e0 02             	shl    $0x2,%eax
  801d08:	05 44 20 81 00       	add    $0x812044,%eax
  801d0d:	8b 00                	mov    (%eax),%eax
  801d0f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d12:	75 08                	jne    801d1c <malloc+0xc8>
        {
            exactIdx = i;
  801d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d17:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801d1a:	eb 5b                	jmp    801d77 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801d1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d1f:	89 d0                	mov    %edx,%eax
  801d21:	01 c0                	add    %eax,%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	c1 e0 02             	shl    $0x2,%eax
  801d28:	05 48 20 81 00       	add    $0x812048,%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	84 c0                	test   %al,%al
  801d31:	74 34                	je     801d67 <malloc+0x113>
  801d33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d36:	89 d0                	mov    %edx,%eax
  801d38:	01 c0                	add    %eax,%eax
  801d3a:	01 d0                	add    %edx,%eax
  801d3c:	c1 e0 02             	shl    $0x2,%eax
  801d3f:	05 44 20 81 00       	add    $0x812044,%eax
  801d44:	8b 00                	mov    (%eax),%eax
  801d46:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d49:	76 1c                	jbe    801d67 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801d4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d4e:	89 d0                	mov    %edx,%eax
  801d50:	01 c0                	add    %eax,%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	c1 e0 02             	shl    $0x2,%eax
  801d57:	05 44 20 81 00       	add    $0x812044,%eax
  801d5c:	8b 00                	mov    (%eax),%eax
  801d5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801d61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d67:	ff 45 e8             	incl   -0x18(%ebp)
  801d6a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801d71:	0f 8e 6e ff ff ff    	jle    801ce5 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801d77:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801d7e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801d82:	74 7d                	je     801e01 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801d84:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8e:	89 d0                	mov    %edx,%eax
  801d90:	01 c0                	add    %eax,%eax
  801d92:	01 d0                	add    %edx,%eax
  801d94:	c1 e0 02             	shl    $0x2,%eax
  801d97:	05 40 20 81 00       	add    $0x812040,%eax
  801d9c:	8b 10                	mov    (%eax),%edx
  801d9e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801da1:	01 d0                	add    %edx,%eax
  801da3:	48                   	dec    %eax
  801da4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801da7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801daa:	ba 00 00 00 00       	mov    $0x0,%edx
  801daf:	f7 75 bc             	divl   -0x44(%ebp)
  801db2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801db5:	29 d0                	sub    %edx,%eax
  801db7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbd:	89 d0                	mov    %edx,%eax
  801dbf:	01 c0                	add    %eax,%eax
  801dc1:	01 d0                	add    %edx,%eax
  801dc3:	c1 e0 02             	shl    $0x2,%eax
  801dc6:	05 48 20 81 00       	add    $0x812048,%eax
  801dcb:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd1:	89 d0                	mov    %edx,%eax
  801dd3:	01 c0                	add    %eax,%eax
  801dd5:	01 d0                	add    %edx,%eax
  801dd7:	c1 e0 02             	shl    $0x2,%eax
  801dda:	05 44 20 81 00       	add    $0x812044,%eax
  801ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de8:	89 d0                	mov    %edx,%eax
  801dea:	01 c0                	add    %eax,%eax
  801dec:	01 d0                	add    %edx,%eax
  801dee:	c1 e0 02             	shl    $0x2,%eax
  801df1:	05 40 20 81 00       	add    $0x812040,%eax
  801df6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dfc:	e9 2d 01 00 00       	jmp    801f2e <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801e01:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e05:	0f 84 ce 00 00 00    	je     801ed9 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801e0b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801e12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e15:	89 d0                	mov    %edx,%eax
  801e17:	01 c0                	add    %eax,%eax
  801e19:	01 d0                	add    %edx,%eax
  801e1b:	c1 e0 02             	shl    $0x2,%eax
  801e1e:	05 40 20 81 00       	add    $0x812040,%eax
  801e23:	8b 10                	mov    (%eax),%edx
  801e25:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e28:	01 d0                	add    %edx,%eax
  801e2a:	48                   	dec    %eax
  801e2b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801e2e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e31:	ba 00 00 00 00       	mov    $0x0,%edx
  801e36:	f7 75 c4             	divl   -0x3c(%ebp)
  801e39:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e3c:	29 d0                	sub    %edx,%eax
  801e3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801e41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e44:	89 d0                	mov    %edx,%eax
  801e46:	01 c0                	add    %eax,%eax
  801e48:	01 d0                	add    %edx,%eax
  801e4a:	c1 e0 02             	shl    $0x2,%eax
  801e4d:	05 44 20 81 00       	add    $0x812044,%eax
  801e52:	8b 00                	mov    (%eax),%eax
  801e54:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e57:	75 47                	jne    801ea0 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801e59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e5c:	89 d0                	mov    %edx,%eax
  801e5e:	01 c0                	add    %eax,%eax
  801e60:	01 d0                	add    %edx,%eax
  801e62:	c1 e0 02             	shl    $0x2,%eax
  801e65:	05 48 20 81 00       	add    $0x812048,%eax
  801e6a:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801e6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e70:	89 d0                	mov    %edx,%eax
  801e72:	01 c0                	add    %eax,%eax
  801e74:	01 d0                	add    %edx,%eax
  801e76:	c1 e0 02             	shl    $0x2,%eax
  801e79:	05 44 20 81 00       	add    $0x812044,%eax
  801e7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801e84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e87:	89 d0                	mov    %edx,%eax
  801e89:	01 c0                	add    %eax,%eax
  801e8b:	01 d0                	add    %edx,%eax
  801e8d:	c1 e0 02             	shl    $0x2,%eax
  801e90:	05 40 20 81 00       	add    $0x812040,%eax
  801e95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e9b:	e9 8e 00 00 00       	jmp    801f2e <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ea3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ea6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801ea9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eac:	89 d0                	mov    %edx,%eax
  801eae:	01 c0                	add    %eax,%eax
  801eb0:	01 d0                	add    %edx,%eax
  801eb2:	c1 e0 02             	shl    $0x2,%eax
  801eb5:	05 40 20 81 00       	add    $0x812040,%eax
  801eba:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ec2:	89 c2                	mov    %eax,%edx
  801ec4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ec7:	89 c8                	mov    %ecx,%eax
  801ec9:	01 c0                	add    %eax,%eax
  801ecb:	01 c8                	add    %ecx,%eax
  801ecd:	c1 e0 02             	shl    $0x2,%eax
  801ed0:	05 44 20 81 00       	add    $0x812044,%eax
  801ed5:	89 10                	mov    %edx,(%eax)
  801ed7:	eb 55                	jmp    801f2e <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801ed9:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801ee0:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801ee6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ee9:	01 d0                	add    %edx,%eax
  801eeb:	48                   	dec    %eax
  801eec:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801eef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef7:	f7 75 d0             	divl   -0x30(%ebp)
  801efa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801efd:	29 d0                	sub    %edx,%eax
  801eff:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801f02:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f0f:	76 0a                	jbe    801f1b <malloc+0x2c7>
            return NULL;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	e9 97 00 00 00       	jmp    801fb2 <malloc+0x35e>
        va = start;
  801f1b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801f21:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f27:	01 d0                	add    %edx,%eax
  801f29:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f35:	eb 5e                	jmp    801f95 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801f37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f3a:	89 d0                	mov    %edx,%eax
  801f3c:	01 c0                	add    %eax,%eax
  801f3e:	01 d0                	add    %edx,%eax
  801f40:	c1 e0 02             	shl    $0x2,%eax
  801f43:	05 48 60 80 00       	add    $0x806048,%eax
  801f48:	8a 00                	mov    (%eax),%al
  801f4a:	84 c0                	test   %al,%al
  801f4c:	75 44                	jne    801f92 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801f4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f51:	89 d0                	mov    %edx,%eax
  801f53:	01 c0                	add    %eax,%eax
  801f55:	01 d0                	add    %edx,%eax
  801f57:	c1 e0 02             	shl    $0x2,%eax
  801f5a:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f63:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801f65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f68:	89 d0                	mov    %edx,%eax
  801f6a:	01 c0                	add    %eax,%eax
  801f6c:	01 d0                	add    %edx,%eax
  801f6e:	c1 e0 02             	shl    $0x2,%eax
  801f71:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801f77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f7a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801f7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f7f:	89 d0                	mov    %edx,%eax
  801f81:	01 c0                	add    %eax,%eax
  801f83:	01 d0                	add    %edx,%eax
  801f85:	c1 e0 02             	shl    $0x2,%eax
  801f88:	05 48 60 80 00       	add    $0x806048,%eax
  801f8d:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801f90:	eb 0c                	jmp    801f9e <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f92:	ff 45 e0             	incl   -0x20(%ebp)
  801f95:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f9c:	7e 99                	jle    801f37 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801f9e:	83 ec 08             	sub    $0x8,%esp
  801fa1:	ff 75 d4             	pushl  -0x2c(%ebp)
  801fa4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fa7:	e8 a2 19 00 00       	call   80394e <sys_allocate_user_mem>
  801fac:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801fba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fbe:	0f 84 fa 03 00 00    	je     8023be <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801fca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	79 1c                	jns    801fed <free+0x39>
  801fd1:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801fd8:	77 13                	ja     801fed <free+0x39>
    {
        free_block(virtual_address);
  801fda:	83 ec 0c             	sub    $0xc,%esp
  801fdd:	ff 75 08             	pushl  0x8(%ebp)
  801fe0:	e8 09 21 00 00       	call   8040ee <free_block>
  801fe5:	83 c4 10             	add    $0x10,%esp
        return;
  801fe8:	e9 d2 03 00 00       	jmp    8023bf <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801fed:	a1 30 61 83 00       	mov    0x836130,%eax
  801ff2:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801ff5:	72 09                	jb     802000 <free+0x4c>
  801ff7:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801ffe:	76 17                	jbe    802017 <free+0x63>
        panic("free: invalid address");
  802000:	83 ec 04             	sub    $0x4,%esp
  802003:	68 41 4f 80 00       	push   $0x804f41
  802008:	68 9b 00 00 00       	push   $0x9b
  80200d:	68 f8 4e 80 00       	push   $0x804ef8
  802012:	e8 a5 e7 ff ff       	call   8007bc <_panic>

    uint32 size = 0;
  802017:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  80201e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802025:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80202c:	eb 50                	jmp    80207e <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80202e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802031:	89 d0                	mov    %edx,%eax
  802033:	01 c0                	add    %eax,%eax
  802035:	01 d0                	add    %edx,%eax
  802037:	c1 e0 02             	shl    $0x2,%eax
  80203a:	05 48 60 80 00       	add    $0x806048,%eax
  80203f:	8a 00                	mov    (%eax),%al
  802041:	84 c0                	test   %al,%al
  802043:	74 36                	je     80207b <free+0xc7>
  802045:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802048:	89 d0                	mov    %edx,%eax
  80204a:	01 c0                	add    %eax,%eax
  80204c:	01 d0                	add    %edx,%eax
  80204e:	c1 e0 02             	shl    $0x2,%eax
  802051:	05 40 60 80 00       	add    $0x806040,%eax
  802056:	8b 00                	mov    (%eax),%eax
  802058:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80205b:	75 1e                	jne    80207b <free+0xc7>
        {
            size = uhp_allocs[i].size;
  80205d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802060:	89 d0                	mov    %edx,%eax
  802062:	01 c0                	add    %eax,%eax
  802064:	01 d0                	add    %edx,%eax
  802066:	c1 e0 02             	shl    $0x2,%eax
  802069:	05 44 60 80 00       	add    $0x806044,%eax
  80206e:	8b 00                	mov    (%eax),%eax
  802070:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  802073:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802076:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  802079:	eb 0c                	jmp    802087 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80207b:	ff 45 ec             	incl   -0x14(%ebp)
  80207e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802085:	7e a7                	jle    80202e <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  802087:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80208b:	74 06                	je     802093 <free+0xdf>
  80208d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802091:	75 17                	jne    8020aa <free+0xf6>
        panic("free: unknown block");
  802093:	83 ec 04             	sub    $0x4,%esp
  802096:	68 57 4f 80 00       	push   $0x804f57
  80209b:	68 a9 00 00 00       	push   $0xa9
  8020a0:	68 f8 4e 80 00       	push   $0x804ef8
  8020a5:	e8 12 e7 ff ff       	call   8007bc <_panic>

    uhp_allocs[idx].used = 0;
  8020aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ad:	89 d0                	mov    %edx,%eax
  8020af:	01 c0                	add    %eax,%eax
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	c1 e0 02             	shl    $0x2,%eax
  8020b6:	05 48 60 80 00       	add    $0x806048,%eax
  8020bb:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8020be:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8020cc:	eb 64                	jmp    802132 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8020ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020d1:	89 d0                	mov    %edx,%eax
  8020d3:	01 c0                	add    %eax,%eax
  8020d5:	01 d0                	add    %edx,%eax
  8020d7:	c1 e0 02             	shl    $0x2,%eax
  8020da:	05 48 20 81 00       	add    $0x812048,%eax
  8020df:	8a 00                	mov    (%eax),%al
  8020e1:	84 c0                	test   %al,%al
  8020e3:	75 4a                	jne    80212f <free+0x17b>
        {
            uhp_frees[i].va = va;
  8020e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020e8:	89 d0                	mov    %edx,%eax
  8020ea:	01 c0                	add    %eax,%eax
  8020ec:	01 d0                	add    %edx,%eax
  8020ee:	c1 e0 02             	shl    $0x2,%eax
  8020f1:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8020f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020fa:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  8020fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020ff:	89 d0                	mov    %edx,%eax
  802101:	01 c0                	add    %eax,%eax
  802103:	01 d0                	add    %edx,%eax
  802105:	c1 e0 02             	shl    $0x2,%eax
  802108:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  802113:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802116:	89 d0                	mov    %edx,%eax
  802118:	01 c0                	add    %eax,%eax
  80211a:	01 d0                	add    %edx,%eax
  80211c:	c1 e0 02             	shl    $0x2,%eax
  80211f:	05 48 20 81 00       	add    $0x812048,%eax
  802124:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80212a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  80212d:	eb 0c                	jmp    80213b <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80212f:	ff 45 e4             	incl   -0x1c(%ebp)
  802132:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802139:	7e 93                	jle    8020ce <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  80213b:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80213f:	0f 84 f1 01 00 00    	je     802336 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802145:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80214c:	e9 d8 01 00 00       	jmp    802329 <free+0x375>
        {
            if (i == fidx) continue;
  802151:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802154:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802157:	0f 84 c8 01 00 00    	je     802325 <free+0x371>
            if (uhp_frees[i].free)
  80215d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802160:	89 d0                	mov    %edx,%eax
  802162:	01 c0                	add    %eax,%eax
  802164:	01 d0                	add    %edx,%eax
  802166:	c1 e0 02             	shl    $0x2,%eax
  802169:	05 48 20 81 00       	add    $0x812048,%eax
  80216e:	8a 00                	mov    (%eax),%al
  802170:	84 c0                	test   %al,%al
  802172:	0f 84 ae 01 00 00    	je     802326 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  802178:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80217b:	89 d0                	mov    %edx,%eax
  80217d:	01 c0                	add    %eax,%eax
  80217f:	01 d0                	add    %edx,%eax
  802181:	c1 e0 02             	shl    $0x2,%eax
  802184:	05 40 20 81 00       	add    $0x812040,%eax
  802189:	8b 08                	mov    (%eax),%ecx
  80218b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80218e:	89 d0                	mov    %edx,%eax
  802190:	01 c0                	add    %eax,%eax
  802192:	01 d0                	add    %edx,%eax
  802194:	c1 e0 02             	shl    $0x2,%eax
  802197:	05 44 20 81 00       	add    $0x812044,%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	01 c1                	add    %eax,%ecx
  8021a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021a3:	89 d0                	mov    %edx,%eax
  8021a5:	01 c0                	add    %eax,%eax
  8021a7:	01 d0                	add    %edx,%eax
  8021a9:	c1 e0 02             	shl    $0x2,%eax
  8021ac:	05 40 20 81 00       	add    $0x812040,%eax
  8021b1:	8b 00                	mov    (%eax),%eax
  8021b3:	39 c1                	cmp    %eax,%ecx
  8021b5:	0f 85 a8 00 00 00    	jne    802263 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  8021bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021be:	89 d0                	mov    %edx,%eax
  8021c0:	01 c0                	add    %eax,%eax
  8021c2:	01 d0                	add    %edx,%eax
  8021c4:	c1 e0 02             	shl    $0x2,%eax
  8021c7:	05 40 20 81 00       	add    $0x812040,%eax
  8021cc:	8b 10                	mov    (%eax),%edx
  8021ce:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8021d1:	89 c8                	mov    %ecx,%eax
  8021d3:	01 c0                	add    %eax,%eax
  8021d5:	01 c8                	add    %ecx,%eax
  8021d7:	c1 e0 02             	shl    $0x2,%eax
  8021da:	05 40 20 81 00       	add    $0x812040,%eax
  8021df:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8021e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021e4:	89 d0                	mov    %edx,%eax
  8021e6:	01 c0                	add    %eax,%eax
  8021e8:	01 d0                	add    %edx,%eax
  8021ea:	c1 e0 02             	shl    $0x2,%eax
  8021ed:	05 44 20 81 00       	add    $0x812044,%eax
  8021f2:	8b 08                	mov    (%eax),%ecx
  8021f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021f7:	89 d0                	mov    %edx,%eax
  8021f9:	01 c0                	add    %eax,%eax
  8021fb:	01 d0                	add    %edx,%eax
  8021fd:	c1 e0 02             	shl    $0x2,%eax
  802200:	05 44 20 81 00       	add    $0x812044,%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	01 c1                	add    %eax,%ecx
  802209:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80220c:	89 d0                	mov    %edx,%eax
  80220e:	01 c0                	add    %eax,%eax
  802210:	01 d0                	add    %edx,%eax
  802212:	c1 e0 02             	shl    $0x2,%eax
  802215:	05 44 20 81 00       	add    $0x812044,%eax
  80221a:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  80221c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80221f:	89 d0                	mov    %edx,%eax
  802221:	01 c0                	add    %eax,%eax
  802223:	01 d0                	add    %edx,%eax
  802225:	c1 e0 02             	shl    $0x2,%eax
  802228:	05 48 20 81 00       	add    $0x812048,%eax
  80222d:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802230:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802233:	89 d0                	mov    %edx,%eax
  802235:	01 c0                	add    %eax,%eax
  802237:	01 d0                	add    %edx,%eax
  802239:	c1 e0 02             	shl    $0x2,%eax
  80223c:	05 40 20 81 00       	add    $0x812040,%eax
  802241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802247:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80224a:	89 d0                	mov    %edx,%eax
  80224c:	01 c0                	add    %eax,%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	c1 e0 02             	shl    $0x2,%eax
  802253:	05 44 20 81 00       	add    $0x812044,%eax
  802258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225e:	e9 c3 00 00 00       	jmp    802326 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  802263:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802266:	89 d0                	mov    %edx,%eax
  802268:	01 c0                	add    %eax,%eax
  80226a:	01 d0                	add    %edx,%eax
  80226c:	c1 e0 02             	shl    $0x2,%eax
  80226f:	05 40 20 81 00       	add    $0x812040,%eax
  802274:	8b 08                	mov    (%eax),%ecx
  802276:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802279:	89 d0                	mov    %edx,%eax
  80227b:	01 c0                	add    %eax,%eax
  80227d:	01 d0                	add    %edx,%eax
  80227f:	c1 e0 02             	shl    $0x2,%eax
  802282:	05 44 20 81 00       	add    $0x812044,%eax
  802287:	8b 00                	mov    (%eax),%eax
  802289:	01 c1                	add    %eax,%ecx
  80228b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80228e:	89 d0                	mov    %edx,%eax
  802290:	01 c0                	add    %eax,%eax
  802292:	01 d0                	add    %edx,%eax
  802294:	c1 e0 02             	shl    $0x2,%eax
  802297:	05 40 20 81 00       	add    $0x812040,%eax
  80229c:	8b 00                	mov    (%eax),%eax
  80229e:	39 c1                	cmp    %eax,%ecx
  8022a0:	0f 85 80 00 00 00    	jne    802326 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8022a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a9:	89 d0                	mov    %edx,%eax
  8022ab:	01 c0                	add    %eax,%eax
  8022ad:	01 d0                	add    %edx,%eax
  8022af:	c1 e0 02             	shl    $0x2,%eax
  8022b2:	05 44 20 81 00       	add    $0x812044,%eax
  8022b7:	8b 08                	mov    (%eax),%ecx
  8022b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022bc:	89 d0                	mov    %edx,%eax
  8022be:	01 c0                	add    %eax,%eax
  8022c0:	01 d0                	add    %edx,%eax
  8022c2:	c1 e0 02             	shl    $0x2,%eax
  8022c5:	05 44 20 81 00       	add    $0x812044,%eax
  8022ca:	8b 00                	mov    (%eax),%eax
  8022cc:	01 c1                	add    %eax,%ecx
  8022ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022d1:	89 d0                	mov    %edx,%eax
  8022d3:	01 c0                	add    %eax,%eax
  8022d5:	01 d0                	add    %edx,%eax
  8022d7:	c1 e0 02             	shl    $0x2,%eax
  8022da:	05 44 20 81 00       	add    $0x812044,%eax
  8022df:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8022e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022e4:	89 d0                	mov    %edx,%eax
  8022e6:	01 c0                	add    %eax,%eax
  8022e8:	01 d0                	add    %edx,%eax
  8022ea:	c1 e0 02             	shl    $0x2,%eax
  8022ed:	05 48 20 81 00       	add    $0x812048,%eax
  8022f2:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8022f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022f8:	89 d0                	mov    %edx,%eax
  8022fa:	01 c0                	add    %eax,%eax
  8022fc:	01 d0                	add    %edx,%eax
  8022fe:	c1 e0 02             	shl    $0x2,%eax
  802301:	05 40 20 81 00       	add    $0x812040,%eax
  802306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  80230c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80230f:	89 d0                	mov    %edx,%eax
  802311:	01 c0                	add    %eax,%eax
  802313:	01 d0                	add    %edx,%eax
  802315:	c1 e0 02             	shl    $0x2,%eax
  802318:	05 44 20 81 00       	add    $0x812044,%eax
  80231d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802323:	eb 01                	jmp    802326 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  802325:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802326:	ff 45 e0             	incl   -0x20(%ebp)
  802329:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802330:	0f 8e 1b fe ff ff    	jle    802151 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802336:	a1 30 61 83 00       	mov    0x836130,%eax
  80233b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80233e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802345:	eb 53                	jmp    80239a <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802347:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80234a:	89 d0                	mov    %edx,%eax
  80234c:	01 c0                	add    %eax,%eax
  80234e:	01 d0                	add    %edx,%eax
  802350:	c1 e0 02             	shl    $0x2,%eax
  802353:	05 48 60 80 00       	add    $0x806048,%eax
  802358:	8a 00                	mov    (%eax),%al
  80235a:	84 c0                	test   %al,%al
  80235c:	74 39                	je     802397 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  80235e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802361:	89 d0                	mov    %edx,%eax
  802363:	01 c0                	add    %eax,%eax
  802365:	01 d0                	add    %edx,%eax
  802367:	c1 e0 02             	shl    $0x2,%eax
  80236a:	05 40 60 80 00       	add    $0x806040,%eax
  80236f:	8b 08                	mov    (%eax),%ecx
  802371:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802374:	89 d0                	mov    %edx,%eax
  802376:	01 c0                	add    %eax,%eax
  802378:	01 d0                	add    %edx,%eax
  80237a:	c1 e0 02             	shl    $0x2,%eax
  80237d:	05 44 60 80 00       	add    $0x806044,%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	01 c8                	add    %ecx,%eax
  802386:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  802389:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80238c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80238f:	76 06                	jbe    802397 <free+0x3e3>
  802391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802394:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802397:	ff 45 d8             	incl   -0x28(%ebp)
  80239a:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8023a1:	7e a4                	jle    802347 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  8023a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023a6:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  8023ab:	83 ec 08             	sub    $0x8,%esp
  8023ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8023b4:	e8 79 15 00 00       	call   803932 <sys_free_user_mem>
  8023b9:	83 c4 10             	add    $0x10,%esp
  8023bc:	eb 01                	jmp    8023bf <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  8023be:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    

008023c1 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	83 ec 68             	sub    $0x68,%esp
  8023c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ca:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023cd:	e8 a5 f7 ff ff       	call   801b77 <uheap_init>
	if (size == 0) return NULL ;
  8023d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023d6:	75 0a                	jne    8023e2 <smalloc+0x21>
  8023d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dd:	e9 37 03 00 00       	jmp    802719 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8023e2:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8023e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023ef:	01 d0                	add    %edx,%eax
  8023f1:	48                   	dec    %eax
  8023f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8023fd:	f7 75 dc             	divl   -0x24(%ebp)
  802400:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802403:	29 d0                	sub    %edx,%eax
  802405:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802408:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80240f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802416:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80241d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802424:	e9 85 00 00 00       	jmp    8024ae <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802429:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80242c:	89 d0                	mov    %edx,%eax
  80242e:	01 c0                	add    %eax,%eax
  802430:	01 d0                	add    %edx,%eax
  802432:	c1 e0 02             	shl    $0x2,%eax
  802435:	05 48 20 81 00       	add    $0x812048,%eax
  80243a:	8a 00                	mov    (%eax),%al
  80243c:	84 c0                	test   %al,%al
  80243e:	74 20                	je     802460 <smalloc+0x9f>
  802440:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802443:	89 d0                	mov    %edx,%eax
  802445:	01 c0                	add    %eax,%eax
  802447:	01 d0                	add    %edx,%eax
  802449:	c1 e0 02             	shl    $0x2,%eax
  80244c:	05 44 20 81 00       	add    $0x812044,%eax
  802451:	8b 00                	mov    (%eax),%eax
  802453:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802456:	75 08                	jne    802460 <smalloc+0x9f>
        {
            exactIdx = i;
  802458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80245b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80245e:	eb 5b                	jmp    8024bb <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802460:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802463:	89 d0                	mov    %edx,%eax
  802465:	01 c0                	add    %eax,%eax
  802467:	01 d0                	add    %edx,%eax
  802469:	c1 e0 02             	shl    $0x2,%eax
  80246c:	05 48 20 81 00       	add    $0x812048,%eax
  802471:	8a 00                	mov    (%eax),%al
  802473:	84 c0                	test   %al,%al
  802475:	74 34                	je     8024ab <smalloc+0xea>
  802477:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80247a:	89 d0                	mov    %edx,%eax
  80247c:	01 c0                	add    %eax,%eax
  80247e:	01 d0                	add    %edx,%eax
  802480:	c1 e0 02             	shl    $0x2,%eax
  802483:	05 44 20 81 00       	add    $0x812044,%eax
  802488:	8b 00                	mov    (%eax),%eax
  80248a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80248d:	76 1c                	jbe    8024ab <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  80248f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802492:	89 d0                	mov    %edx,%eax
  802494:	01 c0                	add    %eax,%eax
  802496:	01 d0                	add    %edx,%eax
  802498:	c1 e0 02             	shl    $0x2,%eax
  80249b:	05 44 20 81 00       	add    $0x812044,%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8024a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a8:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8024ab:	ff 45 e8             	incl   -0x18(%ebp)
  8024ae:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8024b5:	0f 8e 6e ff ff ff    	jle    802429 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8024bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8024c2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8024c6:	74 7d                	je     802545 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8024c8:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8024cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	01 c0                	add    %eax,%eax
  8024d6:	01 d0                	add    %edx,%eax
  8024d8:	c1 e0 02             	shl    $0x2,%eax
  8024db:	05 40 20 81 00       	add    $0x812040,%eax
  8024e0:	8b 10                	mov    (%eax),%edx
  8024e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024e5:	01 d0                	add    %edx,%eax
  8024e7:	48                   	dec    %eax
  8024e8:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8024eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f3:	f7 75 bc             	divl   -0x44(%ebp)
  8024f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024f9:	29 d0                	sub    %edx,%eax
  8024fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8024fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802501:	89 d0                	mov    %edx,%eax
  802503:	01 c0                	add    %eax,%eax
  802505:	01 d0                	add    %edx,%eax
  802507:	c1 e0 02             	shl    $0x2,%eax
  80250a:	05 48 20 81 00       	add    $0x812048,%eax
  80250f:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802512:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802515:	89 d0                	mov    %edx,%eax
  802517:	01 c0                	add    %eax,%eax
  802519:	01 d0                	add    %edx,%eax
  80251b:	c1 e0 02             	shl    $0x2,%eax
  80251e:	05 44 20 81 00       	add    $0x812044,%eax
  802523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802529:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252c:	89 d0                	mov    %edx,%eax
  80252e:	01 c0                	add    %eax,%eax
  802530:	01 d0                	add    %edx,%eax
  802532:	c1 e0 02             	shl    $0x2,%eax
  802535:	05 40 20 81 00       	add    $0x812040,%eax
  80253a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802540:	e9 2d 01 00 00       	jmp    802672 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802545:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802549:	0f 84 ce 00 00 00    	je     80261d <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80254f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802556:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802559:	89 d0                	mov    %edx,%eax
  80255b:	01 c0                	add    %eax,%eax
  80255d:	01 d0                	add    %edx,%eax
  80255f:	c1 e0 02             	shl    $0x2,%eax
  802562:	05 40 20 81 00       	add    $0x812040,%eax
  802567:	8b 10                	mov    (%eax),%edx
  802569:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80256c:	01 d0                	add    %edx,%eax
  80256e:	48                   	dec    %eax
  80256f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802572:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802575:	ba 00 00 00 00       	mov    $0x0,%edx
  80257a:	f7 75 c4             	divl   -0x3c(%ebp)
  80257d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802580:	29 d0                	sub    %edx,%eax
  802582:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802588:	89 d0                	mov    %edx,%eax
  80258a:	01 c0                	add    %eax,%eax
  80258c:	01 d0                	add    %edx,%eax
  80258e:	c1 e0 02             	shl    $0x2,%eax
  802591:	05 44 20 81 00       	add    $0x812044,%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80259b:	75 47                	jne    8025e4 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80259d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a0:	89 d0                	mov    %edx,%eax
  8025a2:	01 c0                	add    %eax,%eax
  8025a4:	01 d0                	add    %edx,%eax
  8025a6:	c1 e0 02             	shl    $0x2,%eax
  8025a9:	05 48 20 81 00       	add    $0x812048,%eax
  8025ae:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8025b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b4:	89 d0                	mov    %edx,%eax
  8025b6:	01 c0                	add    %eax,%eax
  8025b8:	01 d0                	add    %edx,%eax
  8025ba:	c1 e0 02             	shl    $0x2,%eax
  8025bd:	05 44 20 81 00       	add    $0x812044,%eax
  8025c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8025c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	01 c0                	add    %eax,%eax
  8025cf:	01 d0                	add    %edx,%eax
  8025d1:	c1 e0 02             	shl    $0x2,%eax
  8025d4:	05 40 20 81 00       	add    $0x812040,%eax
  8025d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025df:	e9 8e 00 00 00       	jmp    802672 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8025e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025ea:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8025ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f0:	89 d0                	mov    %edx,%eax
  8025f2:	01 c0                	add    %eax,%eax
  8025f4:	01 d0                	add    %edx,%eax
  8025f6:	c1 e0 02             	shl    $0x2,%eax
  8025f9:	05 40 20 81 00       	add    $0x812040,%eax
  8025fe:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802600:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802603:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802606:	89 c2                	mov    %eax,%edx
  802608:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80260b:	89 c8                	mov    %ecx,%eax
  80260d:	01 c0                	add    %eax,%eax
  80260f:	01 c8                	add    %ecx,%eax
  802611:	c1 e0 02             	shl    $0x2,%eax
  802614:	05 44 20 81 00       	add    $0x812044,%eax
  802619:	89 10                	mov    %edx,(%eax)
  80261b:	eb 55                	jmp    802672 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80261d:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802624:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80262a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80262d:	01 d0                	add    %edx,%eax
  80262f:	48                   	dec    %eax
  802630:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802633:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802636:	ba 00 00 00 00       	mov    $0x0,%edx
  80263b:	f7 75 d0             	divl   -0x30(%ebp)
  80263e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802641:	29 d0                	sub    %edx,%eax
  802643:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802646:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802649:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80264c:	01 d0                	add    %edx,%eax
  80264e:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802653:	76 0a                	jbe    80265f <smalloc+0x29e>
            return NULL;
  802655:	b8 00 00 00 00       	mov    $0x0,%eax
  80265a:	e9 ba 00 00 00       	jmp    802719 <smalloc+0x358>
        va = start;
  80265f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802665:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80266b:	01 d0                	add    %edx,%eax
  80266d:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802672:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802679:	eb 5e                	jmp    8026d9 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  80267b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80267e:	89 d0                	mov    %edx,%eax
  802680:	01 c0                	add    %eax,%eax
  802682:	01 d0                	add    %edx,%eax
  802684:	c1 e0 02             	shl    $0x2,%eax
  802687:	05 48 60 80 00       	add    $0x806048,%eax
  80268c:	8a 00                	mov    (%eax),%al
  80268e:	84 c0                	test   %al,%al
  802690:	75 44                	jne    8026d6 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802695:	89 d0                	mov    %edx,%eax
  802697:	01 c0                	add    %eax,%eax
  802699:	01 d0                	add    %edx,%eax
  80269b:	c1 e0 02             	shl    $0x2,%eax
  80269e:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  8026a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a7:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8026a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ac:	89 d0                	mov    %edx,%eax
  8026ae:	01 c0                	add    %eax,%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	c1 e0 02             	shl    $0x2,%eax
  8026b5:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8026bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026be:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8026c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026c3:	89 d0                	mov    %edx,%eax
  8026c5:	01 c0                	add    %eax,%eax
  8026c7:	01 d0                	add    %edx,%eax
  8026c9:	c1 e0 02             	shl    $0x2,%eax
  8026cc:	05 48 60 80 00       	add    $0x806048,%eax
  8026d1:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8026d4:	eb 0c                	jmp    8026e2 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8026d6:	ff 45 e0             	incl   -0x20(%ebp)
  8026d9:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8026e0:	7e 99                	jle    80267b <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8026e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e5:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8026e9:	52                   	push   %edx
  8026ea:	50                   	push   %eax
  8026eb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8026ee:	ff 75 08             	pushl  0x8(%ebp)
  8026f1:	e8 de 0e 00 00       	call   8035d4 <sys_create_shared_object>
  8026f6:	83 c4 10             	add    $0x10,%esp
  8026f9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8026fc:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802700:	75 07                	jne    802709 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802702:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802707:	eb 10                	jmp    802719 <smalloc+0x358>
    if (r < 0)
  802709:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80270d:	79 07                	jns    802716 <smalloc+0x355>
        return NULL;
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
  802714:	eb 03                	jmp    802719 <smalloc+0x358>
    return (void*)va;
  802716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802721:	e8 51 f4 ff ff       	call   801b77 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802726:	83 ec 08             	sub    $0x8,%esp
  802729:	ff 75 0c             	pushl  0xc(%ebp)
  80272c:	ff 75 08             	pushl  0x8(%ebp)
  80272f:	e8 ca 0e 00 00       	call   8035fe <sys_size_of_shared_object>
  802734:	83 c4 10             	add    $0x10,%esp
  802737:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80273a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80273e:	7f 0a                	jg     80274a <sget+0x2f>
        return NULL;
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
  802745:	e9 28 03 00 00       	jmp    802a72 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80274a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802751:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802754:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802757:	01 d0                	add    %edx,%eax
  802759:	48                   	dec    %eax
  80275a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80275d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802760:	ba 00 00 00 00       	mov    $0x0,%edx
  802765:	f7 75 d8             	divl   -0x28(%ebp)
  802768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80276b:	29 d0                	sub    %edx,%eax
  80276d:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802770:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802777:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80277e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80278c:	e9 85 00 00 00       	jmp    802816 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802791:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802794:	89 d0                	mov    %edx,%eax
  802796:	01 c0                	add    %eax,%eax
  802798:	01 d0                	add    %edx,%eax
  80279a:	c1 e0 02             	shl    $0x2,%eax
  80279d:	05 48 20 81 00       	add    $0x812048,%eax
  8027a2:	8a 00                	mov    (%eax),%al
  8027a4:	84 c0                	test   %al,%al
  8027a6:	74 20                	je     8027c8 <sget+0xad>
  8027a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ab:	89 d0                	mov    %edx,%eax
  8027ad:	01 c0                	add    %eax,%eax
  8027af:	01 d0                	add    %edx,%eax
  8027b1:	c1 e0 02             	shl    $0x2,%eax
  8027b4:	05 44 20 81 00       	add    $0x812044,%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8027be:	75 08                	jne    8027c8 <sget+0xad>
        {
            exactIdx = i;
  8027c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8027c6:	eb 5b                	jmp    802823 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8027c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027cb:	89 d0                	mov    %edx,%eax
  8027cd:	01 c0                	add    %eax,%eax
  8027cf:	01 d0                	add    %edx,%eax
  8027d1:	c1 e0 02             	shl    $0x2,%eax
  8027d4:	05 48 20 81 00       	add    $0x812048,%eax
  8027d9:	8a 00                	mov    (%eax),%al
  8027db:	84 c0                	test   %al,%al
  8027dd:	74 34                	je     802813 <sget+0xf8>
  8027df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027e2:	89 d0                	mov    %edx,%eax
  8027e4:	01 c0                	add    %eax,%eax
  8027e6:	01 d0                	add    %edx,%eax
  8027e8:	c1 e0 02             	shl    $0x2,%eax
  8027eb:	05 44 20 81 00       	add    $0x812044,%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027f5:	76 1c                	jbe    802813 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8027f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027fa:	89 d0                	mov    %edx,%eax
  8027fc:	01 c0                	add    %eax,%eax
  8027fe:	01 d0                	add    %edx,%eax
  802800:	c1 e0 02             	shl    $0x2,%eax
  802803:	05 44 20 81 00       	add    $0x812044,%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80280d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802810:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802813:	ff 45 e8             	incl   -0x18(%ebp)
  802816:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80281d:	0f 8e 6e ff ff ff    	jle    802791 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802823:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80282a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80282e:	74 7d                	je     8028ad <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802830:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283a:	89 d0                	mov    %edx,%eax
  80283c:	01 c0                	add    %eax,%eax
  80283e:	01 d0                	add    %edx,%eax
  802840:	c1 e0 02             	shl    $0x2,%eax
  802843:	05 40 20 81 00       	add    $0x812040,%eax
  802848:	8b 10                	mov    (%eax),%edx
  80284a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80284d:	01 d0                	add    %edx,%eax
  80284f:	48                   	dec    %eax
  802850:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802853:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802856:	ba 00 00 00 00       	mov    $0x0,%edx
  80285b:	f7 75 b8             	divl   -0x48(%ebp)
  80285e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802861:	29 d0                	sub    %edx,%eax
  802863:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802866:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802869:	89 d0                	mov    %edx,%eax
  80286b:	01 c0                	add    %eax,%eax
  80286d:	01 d0                	add    %edx,%eax
  80286f:	c1 e0 02             	shl    $0x2,%eax
  802872:	05 48 20 81 00       	add    $0x812048,%eax
  802877:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80287a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287d:	89 d0                	mov    %edx,%eax
  80287f:	01 c0                	add    %eax,%eax
  802881:	01 d0                	add    %edx,%eax
  802883:	c1 e0 02             	shl    $0x2,%eax
  802886:	05 44 20 81 00       	add    $0x812044,%eax
  80288b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802894:	89 d0                	mov    %edx,%eax
  802896:	01 c0                	add    %eax,%eax
  802898:	01 d0                	add    %edx,%eax
  80289a:	c1 e0 02             	shl    $0x2,%eax
  80289d:	05 40 20 81 00       	add    $0x812040,%eax
  8028a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a8:	e9 2d 01 00 00       	jmp    8029da <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8028ad:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8028b1:	0f 84 ce 00 00 00    	je     802985 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8028b7:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8028be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c1:	89 d0                	mov    %edx,%eax
  8028c3:	01 c0                	add    %eax,%eax
  8028c5:	01 d0                	add    %edx,%eax
  8028c7:	c1 e0 02             	shl    $0x2,%eax
  8028ca:	05 40 20 81 00       	add    $0x812040,%eax
  8028cf:	8b 10                	mov    (%eax),%edx
  8028d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028d4:	01 d0                	add    %edx,%eax
  8028d6:	48                   	dec    %eax
  8028d7:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8028da:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e2:	f7 75 c0             	divl   -0x40(%ebp)
  8028e5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028e8:	29 d0                	sub    %edx,%eax
  8028ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8028ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f0:	89 d0                	mov    %edx,%eax
  8028f2:	01 c0                	add    %eax,%eax
  8028f4:	01 d0                	add    %edx,%eax
  8028f6:	c1 e0 02             	shl    $0x2,%eax
  8028f9:	05 44 20 81 00       	add    $0x812044,%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802903:	75 47                	jne    80294c <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802905:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802908:	89 d0                	mov    %edx,%eax
  80290a:	01 c0                	add    %eax,%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	c1 e0 02             	shl    $0x2,%eax
  802911:	05 48 20 81 00       	add    $0x812048,%eax
  802916:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802919:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291c:	89 d0                	mov    %edx,%eax
  80291e:	01 c0                	add    %eax,%eax
  802920:	01 d0                	add    %edx,%eax
  802922:	c1 e0 02             	shl    $0x2,%eax
  802925:	05 44 20 81 00       	add    $0x812044,%eax
  80292a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802930:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802933:	89 d0                	mov    %edx,%eax
  802935:	01 c0                	add    %eax,%eax
  802937:	01 d0                	add    %edx,%eax
  802939:	c1 e0 02             	shl    $0x2,%eax
  80293c:	05 40 20 81 00       	add    $0x812040,%eax
  802941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802947:	e9 8e 00 00 00       	jmp    8029da <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80294c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80294f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802952:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802955:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802958:	89 d0                	mov    %edx,%eax
  80295a:	01 c0                	add    %eax,%eax
  80295c:	01 d0                	add    %edx,%eax
  80295e:	c1 e0 02             	shl    $0x2,%eax
  802961:	05 40 20 81 00       	add    $0x812040,%eax
  802966:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296b:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80296e:	89 c2                	mov    %eax,%edx
  802970:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802973:	89 c8                	mov    %ecx,%eax
  802975:	01 c0                	add    %eax,%eax
  802977:	01 c8                	add    %ecx,%eax
  802979:	c1 e0 02             	shl    $0x2,%eax
  80297c:	05 44 20 81 00       	add    $0x812044,%eax
  802981:	89 10                	mov    %edx,(%eax)
  802983:	eb 55                	jmp    8029da <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802985:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80298c:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802992:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802995:	01 d0                	add    %edx,%eax
  802997:	48                   	dec    %eax
  802998:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80299b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80299e:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a3:	f7 75 cc             	divl   -0x34(%ebp)
  8029a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029a9:	29 d0                	sub    %edx,%eax
  8029ab:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8029ae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8029b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029b4:	01 d0                	add    %edx,%eax
  8029b6:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8029bb:	76 0a                	jbe    8029c7 <sget+0x2ac>
            return NULL;
  8029bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c2:	e9 ab 00 00 00       	jmp    802a72 <sget+0x357>
        va = start;
  8029c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8029cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8029d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029d3:	01 d0                	add    %edx,%eax
  8029d5:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8029e1:	eb 5e                	jmp    802a41 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8029e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029e6:	89 d0                	mov    %edx,%eax
  8029e8:	01 c0                	add    %eax,%eax
  8029ea:	01 d0                	add    %edx,%eax
  8029ec:	c1 e0 02             	shl    $0x2,%eax
  8029ef:	05 48 60 80 00       	add    $0x806048,%eax
  8029f4:	8a 00                	mov    (%eax),%al
  8029f6:	84 c0                	test   %al,%al
  8029f8:	75 44                	jne    802a3e <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8029fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029fd:	89 d0                	mov    %edx,%eax
  8029ff:	01 c0                	add    %eax,%eax
  802a01:	01 d0                	add    %edx,%eax
  802a03:	c1 e0 02             	shl    $0x2,%eax
  802a06:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802a11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a14:	89 d0                	mov    %edx,%eax
  802a16:	01 c0                	add    %eax,%eax
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	c1 e0 02             	shl    $0x2,%eax
  802a1d:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802a23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a26:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802a28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a2b:	89 d0                	mov    %edx,%eax
  802a2d:	01 c0                	add    %eax,%eax
  802a2f:	01 d0                	add    %edx,%eax
  802a31:	c1 e0 02             	shl    $0x2,%eax
  802a34:	05 48 60 80 00       	add    $0x806048,%eax
  802a39:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802a3c:	eb 0c                	jmp    802a4a <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a3e:	ff 45 e0             	incl   -0x20(%ebp)
  802a41:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802a48:	7e 99                	jle    8029e3 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802a4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4d:	83 ec 04             	sub    $0x4,%esp
  802a50:	50                   	push   %eax
  802a51:	ff 75 0c             	pushl  0xc(%ebp)
  802a54:	ff 75 08             	pushl  0x8(%ebp)
  802a57:	e8 bf 0b 00 00       	call   80361b <sys_get_shared_object>
  802a5c:	83 c4 10             	add    $0x10,%esp
  802a5f:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802a62:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a66:	79 07                	jns    802a6f <sget+0x354>
        return NULL;
  802a68:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6d:	eb 03                	jmp    802a72 <sget+0x357>
    return (void*)va;
  802a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802a72:	c9                   	leave  
  802a73:	c3                   	ret    

00802a74 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a74:	55                   	push   %ebp
  802a75:	89 e5                	mov    %esp,%ebp
  802a77:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a7a:	e8 f8 f0 ff ff       	call   801b77 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a83:	75 13                	jne    802a98 <realloc+0x24>
		return malloc(new_size);
  802a85:	83 ec 0c             	sub    $0xc,%esp
  802a88:	ff 75 0c             	pushl  0xc(%ebp)
  802a8b:	e8 c4 f1 ff ff       	call   801c54 <malloc>
  802a90:	83 c4 10             	add    $0x10,%esp
  802a93:	e9 f4 05 00 00       	jmp    80308c <realloc+0x618>
	if (new_size == 0)
  802a98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a9c:	75 18                	jne    802ab6 <realloc+0x42>
	{
		free(virtual_address);
  802a9e:	83 ec 0c             	sub    $0xc,%esp
  802aa1:	ff 75 08             	pushl  0x8(%ebp)
  802aa4:	e8 0b f5 ff ff       	call   801fb4 <free>
  802aa9:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802aac:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab1:	e9 d6 05 00 00       	jmp    80308c <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802abc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	79 74                	jns    802b37 <realloc+0xc3>
  802ac3:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802aca:	77 6b                	ja     802b37 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802acc:	83 ec 0c             	sub    $0xc,%esp
  802acf:	ff 75 0c             	pushl  0xc(%ebp)
  802ad2:	e8 7d f1 ff ff       	call   801c54 <malloc>
  802ad7:	83 c4 10             	add    $0x10,%esp
  802ada:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802add:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802ae1:	75 0a                	jne    802aed <realloc+0x79>
			return NULL;
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae8:	e9 9f 05 00 00       	jmp    80308c <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802aed:	83 ec 0c             	sub    $0xc,%esp
  802af0:	ff 75 08             	pushl  0x8(%ebp)
  802af3:	e8 e0 11 00 00       	call   803cd8 <get_block_size>
  802af8:	83 c4 10             	add    $0x10,%esp
  802afb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802afe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b04:	39 d0                	cmp    %edx,%eax
  802b06:	76 02                	jbe    802b0a <realloc+0x96>
  802b08:	89 d0                	mov    %edx,%eax
  802b0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	ff 75 c0             	pushl  -0x40(%ebp)
  802b13:	ff 75 08             	pushl  0x8(%ebp)
  802b16:	ff 75 c8             	pushl  -0x38(%ebp)
  802b19:	e8 56 eb ff ff       	call   801674 <memmove>
  802b1e:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802b21:	83 ec 0c             	sub    $0xc,%esp
  802b24:	ff 75 08             	pushl  0x8(%ebp)
  802b27:	e8 88 f4 ff ff       	call   801fb4 <free>
  802b2c:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802b2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b32:	e9 55 05 00 00       	jmp    80308c <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802b37:	a1 30 61 83 00       	mov    0x836130,%eax
  802b3c:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802b3f:	72 09                	jb     802b4a <realloc+0xd6>
  802b41:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802b48:	76 0a                	jbe    802b54 <realloc+0xe0>
		return NULL;
  802b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4f:	e9 38 05 00 00       	jmp    80308c <realloc+0x618>
	uint32 oldsz = 0;
  802b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802b5b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b62:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b69:	eb 50                	jmp    802bbb <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6e:	89 d0                	mov    %edx,%eax
  802b70:	01 c0                	add    %eax,%eax
  802b72:	01 d0                	add    %edx,%eax
  802b74:	c1 e0 02             	shl    $0x2,%eax
  802b77:	05 48 60 80 00       	add    $0x806048,%eax
  802b7c:	8a 00                	mov    (%eax),%al
  802b7e:	84 c0                	test   %al,%al
  802b80:	74 36                	je     802bb8 <realloc+0x144>
  802b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b85:	89 d0                	mov    %edx,%eax
  802b87:	01 c0                	add    %eax,%eax
  802b89:	01 d0                	add    %edx,%eax
  802b8b:	c1 e0 02             	shl    $0x2,%eax
  802b8e:	05 40 60 80 00       	add    $0x806040,%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802b98:	75 1e                	jne    802bb8 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802b9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b9d:	89 d0                	mov    %edx,%eax
  802b9f:	01 c0                	add    %eax,%eax
  802ba1:	01 d0                	add    %edx,%eax
  802ba3:	c1 e0 02             	shl    $0x2,%eax
  802ba6:	05 44 60 80 00       	add    $0x806044,%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802bb6:	eb 0c                	jmp    802bc4 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802bb8:	ff 45 ec             	incl   -0x14(%ebp)
  802bbb:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802bc2:	7e a7                	jle    802b6b <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802bc4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802bc8:	75 0a                	jne    802bd4 <realloc+0x160>
		return NULL;
  802bca:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcf:	e9 b8 04 00 00       	jmp    80308c <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802bd4:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bde:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802be1:	01 d0                	add    %edx,%eax
  802be3:	48                   	dec    %eax
  802be4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802be7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bea:	ba 00 00 00 00       	mov    $0x0,%edx
  802bef:	f7 75 bc             	divl   -0x44(%ebp)
  802bf2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bf5:	29 d0                	sub    %edx,%eax
  802bf7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802bfa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bfd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c00:	75 08                	jne    802c0a <realloc+0x196>
		return virtual_address;
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	e9 82 04 00 00       	jmp    80308c <realloc+0x618>
	if (req < oldsz)
  802c0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c0d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c10:	0f 83 cd 02 00 00    	jae    802ee3 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802c1c:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802c1f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c22:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c25:	01 d0                	add    %edx,%eax
  802c27:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802c2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2d:	89 d0                	mov    %edx,%eax
  802c2f:	01 c0                	add    %eax,%eax
  802c31:	01 d0                	add    %edx,%eax
  802c33:	c1 e0 02             	shl    $0x2,%eax
  802c36:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802c3c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c3f:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802c41:	83 ec 08             	sub    $0x8,%esp
  802c44:	ff 75 b0             	pushl  -0x50(%ebp)
  802c47:	ff 75 ac             	pushl  -0x54(%ebp)
  802c4a:	e8 e3 0c 00 00       	call   803932 <sys_free_user_mem>
  802c4f:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802c52:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c59:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802c60:	eb 64                	jmp    802cc6 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802c62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c65:	89 d0                	mov    %edx,%eax
  802c67:	01 c0                	add    %eax,%eax
  802c69:	01 d0                	add    %edx,%eax
  802c6b:	c1 e0 02             	shl    $0x2,%eax
  802c6e:	05 48 20 81 00       	add    $0x812048,%eax
  802c73:	8a 00                	mov    (%eax),%al
  802c75:	84 c0                	test   %al,%al
  802c77:	75 4a                	jne    802cc3 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802c79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c7c:	89 d0                	mov    %edx,%eax
  802c7e:	01 c0                	add    %eax,%eax
  802c80:	01 d0                	add    %edx,%eax
  802c82:	c1 e0 02             	shl    $0x2,%eax
  802c85:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802c8b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c8e:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802c90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c93:	89 d0                	mov    %edx,%eax
  802c95:	01 c0                	add    %eax,%eax
  802c97:	01 d0                	add    %edx,%eax
  802c99:	c1 e0 02             	shl    $0x2,%eax
  802c9c:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802ca2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca5:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802ca7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802caa:	89 d0                	mov    %edx,%eax
  802cac:	01 c0                	add    %eax,%eax
  802cae:	01 d0                	add    %edx,%eax
  802cb0:	c1 e0 02             	shl    $0x2,%eax
  802cb3:	05 48 20 81 00       	add    $0x812048,%eax
  802cb8:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802cc1:	eb 0c                	jmp    802ccf <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802cc3:	ff 45 e4             	incl   -0x1c(%ebp)
  802cc6:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802ccd:	7e 93                	jle    802c62 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802ccf:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802cd3:	0f 84 8d 01 00 00    	je     802e66 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802cd9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802ce0:	e9 74 01 00 00       	jmp    802e59 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ceb:	0f 84 64 01 00 00    	je     802e55 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802cf1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf4:	89 d0                	mov    %edx,%eax
  802cf6:	01 c0                	add    %eax,%eax
  802cf8:	01 d0                	add    %edx,%eax
  802cfa:	c1 e0 02             	shl    $0x2,%eax
  802cfd:	05 48 20 81 00       	add    $0x812048,%eax
  802d02:	8a 00                	mov    (%eax),%al
  802d04:	84 c0                	test   %al,%al
  802d06:	0f 84 4a 01 00 00    	je     802e56 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802d0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d0f:	89 d0                	mov    %edx,%eax
  802d11:	01 c0                	add    %eax,%eax
  802d13:	01 d0                	add    %edx,%eax
  802d15:	c1 e0 02             	shl    $0x2,%eax
  802d18:	05 40 20 81 00       	add    $0x812040,%eax
  802d1d:	8b 08                	mov    (%eax),%ecx
  802d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d22:	89 d0                	mov    %edx,%eax
  802d24:	01 c0                	add    %eax,%eax
  802d26:	01 d0                	add    %edx,%eax
  802d28:	c1 e0 02             	shl    $0x2,%eax
  802d2b:	05 44 20 81 00       	add    $0x812044,%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	01 c1                	add    %eax,%ecx
  802d34:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d37:	89 d0                	mov    %edx,%eax
  802d39:	01 c0                	add    %eax,%eax
  802d3b:	01 d0                	add    %edx,%eax
  802d3d:	c1 e0 02             	shl    $0x2,%eax
  802d40:	05 40 20 81 00       	add    $0x812040,%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	39 c1                	cmp    %eax,%ecx
  802d49:	75 7a                	jne    802dc5 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802d4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d4e:	89 d0                	mov    %edx,%eax
  802d50:	01 c0                	add    %eax,%eax
  802d52:	01 d0                	add    %edx,%eax
  802d54:	c1 e0 02             	shl    $0x2,%eax
  802d57:	05 40 20 81 00       	add    $0x812040,%eax
  802d5c:	8b 10                	mov    (%eax),%edx
  802d5e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802d61:	89 c8                	mov    %ecx,%eax
  802d63:	01 c0                	add    %eax,%eax
  802d65:	01 c8                	add    %ecx,%eax
  802d67:	c1 e0 02             	shl    $0x2,%eax
  802d6a:	05 40 20 81 00       	add    $0x812040,%eax
  802d6f:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802d71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d74:	89 d0                	mov    %edx,%eax
  802d76:	01 c0                	add    %eax,%eax
  802d78:	01 d0                	add    %edx,%eax
  802d7a:	c1 e0 02             	shl    $0x2,%eax
  802d7d:	05 44 20 81 00       	add    $0x812044,%eax
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
  802da5:	05 44 20 81 00       	add    $0x812044,%eax
  802daa:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802dac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802daf:	89 d0                	mov    %edx,%eax
  802db1:	01 c0                	add    %eax,%eax
  802db3:	01 d0                	add    %edx,%eax
  802db5:	c1 e0 02             	shl    $0x2,%eax
  802db8:	05 48 20 81 00       	add    $0x812048,%eax
  802dbd:	c6 00 00             	movb   $0x0,(%eax)
  802dc0:	e9 91 00 00 00       	jmp    802e56 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802dc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc8:	89 d0                	mov    %edx,%eax
  802dca:	01 c0                	add    %eax,%eax
  802dcc:	01 d0                	add    %edx,%eax
  802dce:	c1 e0 02             	shl    $0x2,%eax
  802dd1:	05 40 20 81 00       	add    $0x812040,%eax
  802dd6:	8b 08                	mov    (%eax),%ecx
  802dd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ddb:	89 d0                	mov    %edx,%eax
  802ddd:	01 c0                	add    %eax,%eax
  802ddf:	01 d0                	add    %edx,%eax
  802de1:	c1 e0 02             	shl    $0x2,%eax
  802de4:	05 44 20 81 00       	add    $0x812044,%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	01 c1                	add    %eax,%ecx
  802ded:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802df0:	89 d0                	mov    %edx,%eax
  802df2:	01 c0                	add    %eax,%eax
  802df4:	01 d0                	add    %edx,%eax
  802df6:	c1 e0 02             	shl    $0x2,%eax
  802df9:	05 40 20 81 00       	add    $0x812040,%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	39 c1                	cmp    %eax,%ecx
  802e02:	75 52                	jne    802e56 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802e04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e07:	89 d0                	mov    %edx,%eax
  802e09:	01 c0                	add    %eax,%eax
  802e0b:	01 d0                	add    %edx,%eax
  802e0d:	c1 e0 02             	shl    $0x2,%eax
  802e10:	05 44 20 81 00       	add    $0x812044,%eax
  802e15:	8b 08                	mov    (%eax),%ecx
  802e17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e1a:	89 d0                	mov    %edx,%eax
  802e1c:	01 c0                	add    %eax,%eax
  802e1e:	01 d0                	add    %edx,%eax
  802e20:	c1 e0 02             	shl    $0x2,%eax
  802e23:	05 44 20 81 00       	add    $0x812044,%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	01 c1                	add    %eax,%ecx
  802e2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e2f:	89 d0                	mov    %edx,%eax
  802e31:	01 c0                	add    %eax,%eax
  802e33:	01 d0                	add    %edx,%eax
  802e35:	c1 e0 02             	shl    $0x2,%eax
  802e38:	05 44 20 81 00       	add    $0x812044,%eax
  802e3d:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802e3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e42:	89 d0                	mov    %edx,%eax
  802e44:	01 c0                	add    %eax,%eax
  802e46:	01 d0                	add    %edx,%eax
  802e48:	c1 e0 02             	shl    $0x2,%eax
  802e4b:	05 48 20 81 00       	add    $0x812048,%eax
  802e50:	c6 00 00             	movb   $0x0,(%eax)
  802e53:	eb 01                	jmp    802e56 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802e55:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e56:	ff 45 e0             	incl   -0x20(%ebp)
  802e59:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e60:	0f 8e 7f fe ff ff    	jle    802ce5 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802e66:	a1 30 61 83 00       	mov    0x836130,%eax
  802e6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e6e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802e75:	eb 53                	jmp    802eca <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802e77:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e7a:	89 d0                	mov    %edx,%eax
  802e7c:	01 c0                	add    %eax,%eax
  802e7e:	01 d0                	add    %edx,%eax
  802e80:	c1 e0 02             	shl    $0x2,%eax
  802e83:	05 48 60 80 00       	add    $0x806048,%eax
  802e88:	8a 00                	mov    (%eax),%al
  802e8a:	84 c0                	test   %al,%al
  802e8c:	74 39                	je     802ec7 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e8e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e91:	89 d0                	mov    %edx,%eax
  802e93:	01 c0                	add    %eax,%eax
  802e95:	01 d0                	add    %edx,%eax
  802e97:	c1 e0 02             	shl    $0x2,%eax
  802e9a:	05 40 60 80 00       	add    $0x806040,%eax
  802e9f:	8b 08                	mov    (%eax),%ecx
  802ea1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ea4:	89 d0                	mov    %edx,%eax
  802ea6:	01 c0                	add    %eax,%eax
  802ea8:	01 d0                	add    %edx,%eax
  802eaa:	c1 e0 02             	shl    $0x2,%eax
  802ead:	05 44 60 80 00       	add    $0x806044,%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	01 c8                	add    %ecx,%eax
  802eb6:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802eb9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ebc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802ebf:	76 06                	jbe    802ec7 <realloc+0x453>
  802ec1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ec4:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802ec7:	ff 45 d8             	incl   -0x28(%ebp)
  802eca:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802ed1:	7e a4                	jle    802e77 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802ed3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed6:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	e9 a9 01 00 00       	jmp    80308c <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802ee3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	01 d0                	add    %edx,%eax
  802eeb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802eee:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ef5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802efc:	eb 57                	jmp    802f55 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802efe:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f01:	89 d0                	mov    %edx,%eax
  802f03:	01 c0                	add    %eax,%eax
  802f05:	01 d0                	add    %edx,%eax
  802f07:	c1 e0 02             	shl    $0x2,%eax
  802f0a:	05 48 20 81 00       	add    $0x812048,%eax
  802f0f:	8a 00                	mov    (%eax),%al
  802f11:	84 c0                	test   %al,%al
  802f13:	74 3d                	je     802f52 <realloc+0x4de>
  802f15:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f18:	89 d0                	mov    %edx,%eax
  802f1a:	01 c0                	add    %eax,%eax
  802f1c:	01 d0                	add    %edx,%eax
  802f1e:	c1 e0 02             	shl    $0x2,%eax
  802f21:	05 40 20 81 00       	add    $0x812040,%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f2b:	75 25                	jne    802f52 <realloc+0x4de>
  802f2d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f30:	89 d0                	mov    %edx,%eax
  802f32:	01 c0                	add    %eax,%eax
  802f34:	01 d0                	add    %edx,%eax
  802f36:	c1 e0 02             	shl    $0x2,%eax
  802f39:	05 44 20 81 00       	add    $0x812044,%eax
  802f3e:	8b 10                	mov    (%eax),%edx
  802f40:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f43:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802f46:	39 c2                	cmp    %eax,%edx
  802f48:	72 08                	jb     802f52 <realloc+0x4de>
		{
			adjIdx = j; break;
  802f4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f50:	eb 0c                	jmp    802f5e <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802f52:	ff 45 d0             	incl   -0x30(%ebp)
  802f55:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802f5c:	7e a0                	jle    802efe <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802f5e:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802f62:	0f 84 d6 00 00 00    	je     80303e <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802f68:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f6b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802f6e:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802f71:	83 ec 08             	sub    $0x8,%esp
  802f74:	ff 75 a0             	pushl  -0x60(%ebp)
  802f77:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f7a:	e8 cf 09 00 00       	call   80394e <sys_allocate_user_mem>
  802f7f:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802f82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f85:	89 d0                	mov    %edx,%eax
  802f87:	01 c0                	add    %eax,%eax
  802f89:	01 d0                	add    %edx,%eax
  802f8b:	c1 e0 02             	shl    $0x2,%eax
  802f8e:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802f94:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f97:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802f99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f9c:	89 d0                	mov    %edx,%eax
  802f9e:	01 c0                	add    %eax,%eax
  802fa0:	01 d0                	add    %edx,%eax
  802fa2:	c1 e0 02             	shl    $0x2,%eax
  802fa5:	05 40 20 81 00       	add    $0x812040,%eax
  802faa:	8b 10                	mov    (%eax),%edx
  802fac:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802faf:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802fb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fb5:	89 d0                	mov    %edx,%eax
  802fb7:	01 c0                	add    %eax,%eax
  802fb9:	01 d0                	add    %edx,%eax
  802fbb:	c1 e0 02             	shl    $0x2,%eax
  802fbe:	05 40 20 81 00       	add    $0x812040,%eax
  802fc3:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802fc5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fc8:	89 d0                	mov    %edx,%eax
  802fca:	01 c0                	add    %eax,%eax
  802fcc:	01 d0                	add    %edx,%eax
  802fce:	c1 e0 02             	shl    $0x2,%eax
  802fd1:	05 44 20 81 00       	add    $0x812044,%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802fdb:	89 c2                	mov    %eax,%edx
  802fdd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802fe0:	89 c8                	mov    %ecx,%eax
  802fe2:	01 c0                	add    %eax,%eax
  802fe4:	01 c8                	add    %ecx,%eax
  802fe6:	c1 e0 02             	shl    $0x2,%eax
  802fe9:	05 44 20 81 00       	add    $0x812044,%eax
  802fee:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802ff0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ff3:	89 d0                	mov    %edx,%eax
  802ff5:	01 c0                	add    %eax,%eax
  802ff7:	01 d0                	add    %edx,%eax
  802ff9:	c1 e0 02             	shl    $0x2,%eax
  802ffc:	05 44 20 81 00       	add    $0x812044,%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	75 14                	jne    80301b <realloc+0x5a7>
  803007:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80300a:	89 d0                	mov    %edx,%eax
  80300c:	01 c0                	add    %eax,%eax
  80300e:	01 d0                	add    %edx,%eax
  803010:	c1 e0 02             	shl    $0x2,%eax
  803013:	05 48 20 81 00       	add    $0x812048,%eax
  803018:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  80301b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80301e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803021:	01 c2                	add    %eax,%edx
  803023:	a1 88 60 83 00       	mov    0x836088,%eax
  803028:	39 c2                	cmp    %eax,%edx
  80302a:	76 0d                	jbe    803039 <realloc+0x5c5>
  80302c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80302f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803032:	01 d0                	add    %edx,%eax
  803034:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	eb 4e                	jmp    80308c <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  80303e:	83 ec 0c             	sub    $0xc,%esp
  803041:	ff 75 0c             	pushl  0xc(%ebp)
  803044:	e8 0b ec ff ff       	call   801c54 <malloc>
  803049:	83 c4 10             	add    $0x10,%esp
  80304c:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  80304f:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  803053:	75 07                	jne    80305c <realloc+0x5e8>
		return NULL;
  803055:	b8 00 00 00 00       	mov    $0x0,%eax
  80305a:	eb 30                	jmp    80308c <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  80305c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803062:	39 d0                	cmp    %edx,%eax
  803064:	76 02                	jbe    803068 <realloc+0x5f4>
  803066:	89 d0                	mov    %edx,%eax
  803068:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	50                   	push   %eax
  80306f:	52                   	push   %edx
  803070:	ff 75 cc             	pushl  -0x34(%ebp)
  803073:	e8 cf 06 00 00       	call   803747 <sys_move_user_mem>
  803078:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  80307b:	83 ec 0c             	sub    $0xc,%esp
  80307e:	ff 75 08             	pushl  0x8(%ebp)
  803081:	e8 2e ef ff ff       	call   801fb4 <free>
  803086:	83 c4 10             	add    $0x10,%esp
	return newptr;
  803089:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  80308c:	c9                   	leave  
  80308d:	c3                   	ret    

0080308e <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80308e:	55                   	push   %ebp
  80308f:	89 e5                	mov    %esp,%ebp
  803091:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  80309a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80309e:	0f 84 33 03 00 00    	je     8033d7 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8030a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a7:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8030ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8030af:	83 ec 08             	sub    $0x8,%esp
  8030b2:	ff 75 08             	pushl  0x8(%ebp)
  8030b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8030b8:	e8 7d 05 00 00       	call   80363a <sys_delete_shared_object>
  8030bd:	83 c4 10             	add    $0x10,%esp
  8030c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8030c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8030c7:	0f 88 0d 03 00 00    	js     8033da <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8030cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8030d4:	e9 ef 02 00 00       	jmp    8033c8 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8030d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030dc:	89 d0                	mov    %edx,%eax
  8030de:	01 c0                	add    %eax,%eax
  8030e0:	01 d0                	add    %edx,%eax
  8030e2:	c1 e0 02             	shl    $0x2,%eax
  8030e5:	05 48 60 80 00       	add    $0x806048,%eax
  8030ea:	8a 00                	mov    (%eax),%al
  8030ec:	84 c0                	test   %al,%al
  8030ee:	0f 84 d1 02 00 00    	je     8033c5 <sfree+0x337>
  8030f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f7:	89 d0                	mov    %edx,%eax
  8030f9:	01 c0                	add    %eax,%eax
  8030fb:	01 d0                	add    %edx,%eax
  8030fd:	c1 e0 02             	shl    $0x2,%eax
  803100:	05 40 60 80 00       	add    $0x806040,%eax
  803105:	8b 00                	mov    (%eax),%eax
  803107:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80310a:	0f 85 b5 02 00 00    	jne    8033c5 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803113:	89 d0                	mov    %edx,%eax
  803115:	01 c0                	add    %eax,%eax
  803117:	01 d0                	add    %edx,%eax
  803119:	c1 e0 02             	shl    $0x2,%eax
  80311c:	05 44 60 80 00       	add    $0x806044,%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803129:	89 d0                	mov    %edx,%eax
  80312b:	01 c0                	add    %eax,%eax
  80312d:	01 d0                	add    %edx,%eax
  80312f:	c1 e0 02             	shl    $0x2,%eax
  803132:	05 48 60 80 00       	add    $0x806048,%eax
  803137:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  80313a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803141:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803148:	eb 64                	jmp    8031ae <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  80314a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80314d:	89 d0                	mov    %edx,%eax
  80314f:	01 c0                	add    %eax,%eax
  803151:	01 d0                	add    %edx,%eax
  803153:	c1 e0 02             	shl    $0x2,%eax
  803156:	05 48 20 81 00       	add    $0x812048,%eax
  80315b:	8a 00                	mov    (%eax),%al
  80315d:	84 c0                	test   %al,%al
  80315f:	75 4a                	jne    8031ab <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  803161:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803164:	89 d0                	mov    %edx,%eax
  803166:	01 c0                	add    %eax,%eax
  803168:	01 d0                	add    %edx,%eax
  80316a:	c1 e0 02             	shl    $0x2,%eax
  80316d:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  803173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803176:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  803178:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80317b:	89 d0                	mov    %edx,%eax
  80317d:	01 c0                	add    %eax,%eax
  80317f:	01 d0                	add    %edx,%eax
  803181:	c1 e0 02             	shl    $0x2,%eax
  803184:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  80318a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80318d:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  80318f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803192:	89 d0                	mov    %edx,%eax
  803194:	01 c0                	add    %eax,%eax
  803196:	01 d0                	add    %edx,%eax
  803198:	c1 e0 02             	shl    $0x2,%eax
  80319b:	05 48 20 81 00       	add    $0x812048,%eax
  8031a0:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  8031a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  8031a9:	eb 0c                	jmp    8031b7 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8031ab:	ff 45 ec             	incl   -0x14(%ebp)
  8031ae:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8031b5:	7e 93                	jle    80314a <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  8031b7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8031bb:	0f 84 8d 01 00 00    	je     80334e <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8031c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8031c8:	e9 74 01 00 00       	jmp    803341 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  8031cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031d3:	0f 84 64 01 00 00    	je     80333d <sfree+0x2af>
					if (uhp_frees[k].free)
  8031d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031dc:	89 d0                	mov    %edx,%eax
  8031de:	01 c0                	add    %eax,%eax
  8031e0:	01 d0                	add    %edx,%eax
  8031e2:	c1 e0 02             	shl    $0x2,%eax
  8031e5:	05 48 20 81 00       	add    $0x812048,%eax
  8031ea:	8a 00                	mov    (%eax),%al
  8031ec:	84 c0                	test   %al,%al
  8031ee:	0f 84 4a 01 00 00    	je     80333e <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8031f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f7:	89 d0                	mov    %edx,%eax
  8031f9:	01 c0                	add    %eax,%eax
  8031fb:	01 d0                	add    %edx,%eax
  8031fd:	c1 e0 02             	shl    $0x2,%eax
  803200:	05 40 20 81 00       	add    $0x812040,%eax
  803205:	8b 08                	mov    (%eax),%ecx
  803207:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320a:	89 d0                	mov    %edx,%eax
  80320c:	01 c0                	add    %eax,%eax
  80320e:	01 d0                	add    %edx,%eax
  803210:	c1 e0 02             	shl    $0x2,%eax
  803213:	05 44 20 81 00       	add    $0x812044,%eax
  803218:	8b 00                	mov    (%eax),%eax
  80321a:	01 c1                	add    %eax,%ecx
  80321c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321f:	89 d0                	mov    %edx,%eax
  803221:	01 c0                	add    %eax,%eax
  803223:	01 d0                	add    %edx,%eax
  803225:	c1 e0 02             	shl    $0x2,%eax
  803228:	05 40 20 81 00       	add    $0x812040,%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	39 c1                	cmp    %eax,%ecx
  803231:	75 7a                	jne    8032ad <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  803233:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803236:	89 d0                	mov    %edx,%eax
  803238:	01 c0                	add    %eax,%eax
  80323a:	01 d0                	add    %edx,%eax
  80323c:	c1 e0 02             	shl    $0x2,%eax
  80323f:	05 40 20 81 00       	add    $0x812040,%eax
  803244:	8b 10                	mov    (%eax),%edx
  803246:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803249:	89 c8                	mov    %ecx,%eax
  80324b:	01 c0                	add    %eax,%eax
  80324d:	01 c8                	add    %ecx,%eax
  80324f:	c1 e0 02             	shl    $0x2,%eax
  803252:	05 40 20 81 00       	add    $0x812040,%eax
  803257:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  803259:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80325c:	89 d0                	mov    %edx,%eax
  80325e:	01 c0                	add    %eax,%eax
  803260:	01 d0                	add    %edx,%eax
  803262:	c1 e0 02             	shl    $0x2,%eax
  803265:	05 44 20 81 00       	add    $0x812044,%eax
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
  80328d:	05 44 20 81 00       	add    $0x812044,%eax
  803292:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803294:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803297:	89 d0                	mov    %edx,%eax
  803299:	01 c0                	add    %eax,%eax
  80329b:	01 d0                	add    %edx,%eax
  80329d:	c1 e0 02             	shl    $0x2,%eax
  8032a0:	05 48 20 81 00       	add    $0x812048,%eax
  8032a5:	c6 00 00             	movb   $0x0,(%eax)
  8032a8:	e9 91 00 00 00       	jmp    80333e <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8032ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b0:	89 d0                	mov    %edx,%eax
  8032b2:	01 c0                	add    %eax,%eax
  8032b4:	01 d0                	add    %edx,%eax
  8032b6:	c1 e0 02             	shl    $0x2,%eax
  8032b9:	05 40 20 81 00       	add    $0x812040,%eax
  8032be:	8b 08                	mov    (%eax),%ecx
  8032c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c3:	89 d0                	mov    %edx,%eax
  8032c5:	01 c0                	add    %eax,%eax
  8032c7:	01 d0                	add    %edx,%eax
  8032c9:	c1 e0 02             	shl    $0x2,%eax
  8032cc:	05 44 20 81 00       	add    $0x812044,%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	01 c1                	add    %eax,%ecx
  8032d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d8:	89 d0                	mov    %edx,%eax
  8032da:	01 c0                	add    %eax,%eax
  8032dc:	01 d0                	add    %edx,%eax
  8032de:	c1 e0 02             	shl    $0x2,%eax
  8032e1:	05 40 20 81 00       	add    $0x812040,%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	39 c1                	cmp    %eax,%ecx
  8032ea:	75 52                	jne    80333e <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  8032ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ef:	89 d0                	mov    %edx,%eax
  8032f1:	01 c0                	add    %eax,%eax
  8032f3:	01 d0                	add    %edx,%eax
  8032f5:	c1 e0 02             	shl    $0x2,%eax
  8032f8:	05 44 20 81 00       	add    $0x812044,%eax
  8032fd:	8b 08                	mov    (%eax),%ecx
  8032ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803302:	89 d0                	mov    %edx,%eax
  803304:	01 c0                	add    %eax,%eax
  803306:	01 d0                	add    %edx,%eax
  803308:	c1 e0 02             	shl    $0x2,%eax
  80330b:	05 44 20 81 00       	add    $0x812044,%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	01 c1                	add    %eax,%ecx
  803314:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803317:	89 d0                	mov    %edx,%eax
  803319:	01 c0                	add    %eax,%eax
  80331b:	01 d0                	add    %edx,%eax
  80331d:	c1 e0 02             	shl    $0x2,%eax
  803320:	05 44 20 81 00       	add    $0x812044,%eax
  803325:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803327:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332a:	89 d0                	mov    %edx,%eax
  80332c:	01 c0                	add    %eax,%eax
  80332e:	01 d0                	add    %edx,%eax
  803330:	c1 e0 02             	shl    $0x2,%eax
  803333:	05 48 20 81 00       	add    $0x812048,%eax
  803338:	c6 00 00             	movb   $0x0,(%eax)
  80333b:	eb 01                	jmp    80333e <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  80333d:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80333e:	ff 45 e8             	incl   -0x18(%ebp)
  803341:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803348:	0f 8e 7f fe ff ff    	jle    8031cd <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  80334e:	a1 30 61 83 00       	mov    0x836130,%eax
  803353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803356:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80335d:	eb 53                	jmp    8033b2 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  80335f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803362:	89 d0                	mov    %edx,%eax
  803364:	01 c0                	add    %eax,%eax
  803366:	01 d0                	add    %edx,%eax
  803368:	c1 e0 02             	shl    $0x2,%eax
  80336b:	05 48 60 80 00       	add    $0x806048,%eax
  803370:	8a 00                	mov    (%eax),%al
  803372:	84 c0                	test   %al,%al
  803374:	74 39                	je     8033af <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803376:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803379:	89 d0                	mov    %edx,%eax
  80337b:	01 c0                	add    %eax,%eax
  80337d:	01 d0                	add    %edx,%eax
  80337f:	c1 e0 02             	shl    $0x2,%eax
  803382:	05 40 60 80 00       	add    $0x806040,%eax
  803387:	8b 08                	mov    (%eax),%ecx
  803389:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80338c:	89 d0                	mov    %edx,%eax
  80338e:	01 c0                	add    %eax,%eax
  803390:	01 d0                	add    %edx,%eax
  803392:	c1 e0 02             	shl    $0x2,%eax
  803395:	05 44 60 80 00       	add    $0x806044,%eax
  80339a:	8b 00                	mov    (%eax),%eax
  80339c:	01 c8                	add    %ecx,%eax
  80339e:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  8033a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033a7:	76 06                	jbe    8033af <sfree+0x321>
  8033a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8033af:	ff 45 e0             	incl   -0x20(%ebp)
  8033b2:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8033b9:	7e a4                	jle    80335f <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  8033bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033be:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  8033c3:	eb 16                	jmp    8033db <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8033c5:	ff 45 f4             	incl   -0xc(%ebp)
  8033c8:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  8033cf:	0f 8e 04 fd ff ff    	jle    8030d9 <sfree+0x4b>
  8033d5:	eb 04                	jmp    8033db <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  8033d7:	90                   	nop
  8033d8:	eb 01                	jmp    8033db <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  8033da:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  8033db:	c9                   	leave  
  8033dc:	c3                   	ret    

008033dd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8033dd:	55                   	push   %ebp
  8033de:	89 e5                	mov    %esp,%ebp
  8033e0:	57                   	push   %edi
  8033e1:	56                   	push   %esi
  8033e2:	53                   	push   %ebx
  8033e3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033f2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8033f5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8033f8:	cd 30                	int    $0x30
  8033fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8033fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803400:	83 c4 10             	add    $0x10,%esp
  803403:	5b                   	pop    %ebx
  803404:	5e                   	pop    %esi
  803405:	5f                   	pop    %edi
  803406:	5d                   	pop    %ebp
  803407:	c3                   	ret    

00803408 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
  80340b:	83 ec 04             	sub    $0x4,%esp
  80340e:	8b 45 10             	mov    0x10(%ebp),%eax
  803411:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803414:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803417:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	6a 00                	push   $0x0
  803420:	51                   	push   %ecx
  803421:	52                   	push   %edx
  803422:	ff 75 0c             	pushl  0xc(%ebp)
  803425:	50                   	push   %eax
  803426:	6a 00                	push   $0x0
  803428:	e8 b0 ff ff ff       	call   8033dd <syscall>
  80342d:	83 c4 18             	add    $0x18,%esp
}
  803430:	90                   	nop
  803431:	c9                   	leave  
  803432:	c3                   	ret    

00803433 <sys_cgetc>:

int
sys_cgetc(void)
{
  803433:	55                   	push   %ebp
  803434:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803436:	6a 00                	push   $0x0
  803438:	6a 00                	push   $0x0
  80343a:	6a 00                	push   $0x0
  80343c:	6a 00                	push   $0x0
  80343e:	6a 00                	push   $0x0
  803440:	6a 02                	push   $0x2
  803442:	e8 96 ff ff ff       	call   8033dd <syscall>
  803447:	83 c4 18             	add    $0x18,%esp
}
  80344a:	c9                   	leave  
  80344b:	c3                   	ret    

0080344c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80344c:	55                   	push   %ebp
  80344d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80344f:	6a 00                	push   $0x0
  803451:	6a 00                	push   $0x0
  803453:	6a 00                	push   $0x0
  803455:	6a 00                	push   $0x0
  803457:	6a 00                	push   $0x0
  803459:	6a 03                	push   $0x3
  80345b:	e8 7d ff ff ff       	call   8033dd <syscall>
  803460:	83 c4 18             	add    $0x18,%esp
}
  803463:	90                   	nop
  803464:	c9                   	leave  
  803465:	c3                   	ret    

00803466 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803466:	55                   	push   %ebp
  803467:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803469:	6a 00                	push   $0x0
  80346b:	6a 00                	push   $0x0
  80346d:	6a 00                	push   $0x0
  80346f:	6a 00                	push   $0x0
  803471:	6a 00                	push   $0x0
  803473:	6a 04                	push   $0x4
  803475:	e8 63 ff ff ff       	call   8033dd <syscall>
  80347a:	83 c4 18             	add    $0x18,%esp
}
  80347d:	90                   	nop
  80347e:	c9                   	leave  
  80347f:	c3                   	ret    

00803480 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803480:	55                   	push   %ebp
  803481:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803483:	8b 55 0c             	mov    0xc(%ebp),%edx
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	6a 00                	push   $0x0
  80348b:	6a 00                	push   $0x0
  80348d:	6a 00                	push   $0x0
  80348f:	52                   	push   %edx
  803490:	50                   	push   %eax
  803491:	6a 08                	push   $0x8
  803493:	e8 45 ff ff ff       	call   8033dd <syscall>
  803498:	83 c4 18             	add    $0x18,%esp
}
  80349b:	c9                   	leave  
  80349c:	c3                   	ret    

0080349d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80349d:	55                   	push   %ebp
  80349e:	89 e5                	mov    %esp,%ebp
  8034a0:	56                   	push   %esi
  8034a1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8034a2:	8b 75 18             	mov    0x18(%ebp),%esi
  8034a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	56                   	push   %esi
  8034b2:	53                   	push   %ebx
  8034b3:	51                   	push   %ecx
  8034b4:	52                   	push   %edx
  8034b5:	50                   	push   %eax
  8034b6:	6a 09                	push   $0x9
  8034b8:	e8 20 ff ff ff       	call   8033dd <syscall>
  8034bd:	83 c4 18             	add    $0x18,%esp
}
  8034c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034c3:	5b                   	pop    %ebx
  8034c4:	5e                   	pop    %esi
  8034c5:	5d                   	pop    %ebp
  8034c6:	c3                   	ret    

008034c7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8034c7:	55                   	push   %ebp
  8034c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8034ca:	6a 00                	push   $0x0
  8034cc:	6a 00                	push   $0x0
  8034ce:	6a 00                	push   $0x0
  8034d0:	6a 00                	push   $0x0
  8034d2:	ff 75 08             	pushl  0x8(%ebp)
  8034d5:	6a 0a                	push   $0xa
  8034d7:	e8 01 ff ff ff       	call   8033dd <syscall>
  8034dc:	83 c4 18             	add    $0x18,%esp
}
  8034df:	c9                   	leave  
  8034e0:	c3                   	ret    

008034e1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8034e1:	55                   	push   %ebp
  8034e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8034e4:	6a 00                	push   $0x0
  8034e6:	6a 00                	push   $0x0
  8034e8:	6a 00                	push   $0x0
  8034ea:	ff 75 0c             	pushl  0xc(%ebp)
  8034ed:	ff 75 08             	pushl  0x8(%ebp)
  8034f0:	6a 0b                	push   $0xb
  8034f2:	e8 e6 fe ff ff       	call   8033dd <syscall>
  8034f7:	83 c4 18             	add    $0x18,%esp
}
  8034fa:	c9                   	leave  
  8034fb:	c3                   	ret    

008034fc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8034fc:	55                   	push   %ebp
  8034fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8034ff:	6a 00                	push   $0x0
  803501:	6a 00                	push   $0x0
  803503:	6a 00                	push   $0x0
  803505:	6a 00                	push   $0x0
  803507:	6a 00                	push   $0x0
  803509:	6a 0c                	push   $0xc
  80350b:	e8 cd fe ff ff       	call   8033dd <syscall>
  803510:	83 c4 18             	add    $0x18,%esp
}
  803513:	c9                   	leave  
  803514:	c3                   	ret    

00803515 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803515:	55                   	push   %ebp
  803516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803518:	6a 00                	push   $0x0
  80351a:	6a 00                	push   $0x0
  80351c:	6a 00                	push   $0x0
  80351e:	6a 00                	push   $0x0
  803520:	6a 00                	push   $0x0
  803522:	6a 0d                	push   $0xd
  803524:	e8 b4 fe ff ff       	call   8033dd <syscall>
  803529:	83 c4 18             	add    $0x18,%esp
}
  80352c:	c9                   	leave  
  80352d:	c3                   	ret    

0080352e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80352e:	55                   	push   %ebp
  80352f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803531:	6a 00                	push   $0x0
  803533:	6a 00                	push   $0x0
  803535:	6a 00                	push   $0x0
  803537:	6a 00                	push   $0x0
  803539:	6a 00                	push   $0x0
  80353b:	6a 0e                	push   $0xe
  80353d:	e8 9b fe ff ff       	call   8033dd <syscall>
  803542:	83 c4 18             	add    $0x18,%esp
}
  803545:	c9                   	leave  
  803546:	c3                   	ret    

00803547 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803547:	55                   	push   %ebp
  803548:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80354a:	6a 00                	push   $0x0
  80354c:	6a 00                	push   $0x0
  80354e:	6a 00                	push   $0x0
  803550:	6a 00                	push   $0x0
  803552:	6a 00                	push   $0x0
  803554:	6a 0f                	push   $0xf
  803556:	e8 82 fe ff ff       	call   8033dd <syscall>
  80355b:	83 c4 18             	add    $0x18,%esp
}
  80355e:	c9                   	leave  
  80355f:	c3                   	ret    

00803560 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803560:	55                   	push   %ebp
  803561:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803563:	6a 00                	push   $0x0
  803565:	6a 00                	push   $0x0
  803567:	6a 00                	push   $0x0
  803569:	6a 00                	push   $0x0
  80356b:	ff 75 08             	pushl  0x8(%ebp)
  80356e:	6a 10                	push   $0x10
  803570:	e8 68 fe ff ff       	call   8033dd <syscall>
  803575:	83 c4 18             	add    $0x18,%esp
}
  803578:	c9                   	leave  
  803579:	c3                   	ret    

0080357a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80357a:	55                   	push   %ebp
  80357b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80357d:	6a 00                	push   $0x0
  80357f:	6a 00                	push   $0x0
  803581:	6a 00                	push   $0x0
  803583:	6a 00                	push   $0x0
  803585:	6a 00                	push   $0x0
  803587:	6a 11                	push   $0x11
  803589:	e8 4f fe ff ff       	call   8033dd <syscall>
  80358e:	83 c4 18             	add    $0x18,%esp
}
  803591:	90                   	nop
  803592:	c9                   	leave  
  803593:	c3                   	ret    

00803594 <sys_cputc>:

void
sys_cputc(const char c)
{
  803594:	55                   	push   %ebp
  803595:	89 e5                	mov    %esp,%ebp
  803597:	83 ec 04             	sub    $0x4,%esp
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8035a0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8035a4:	6a 00                	push   $0x0
  8035a6:	6a 00                	push   $0x0
  8035a8:	6a 00                	push   $0x0
  8035aa:	6a 00                	push   $0x0
  8035ac:	50                   	push   %eax
  8035ad:	6a 01                	push   $0x1
  8035af:	e8 29 fe ff ff       	call   8033dd <syscall>
  8035b4:	83 c4 18             	add    $0x18,%esp
}
  8035b7:	90                   	nop
  8035b8:	c9                   	leave  
  8035b9:	c3                   	ret    

008035ba <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8035ba:	55                   	push   %ebp
  8035bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8035bd:	6a 00                	push   $0x0
  8035bf:	6a 00                	push   $0x0
  8035c1:	6a 00                	push   $0x0
  8035c3:	6a 00                	push   $0x0
  8035c5:	6a 00                	push   $0x0
  8035c7:	6a 14                	push   $0x14
  8035c9:	e8 0f fe ff ff       	call   8033dd <syscall>
  8035ce:	83 c4 18             	add    $0x18,%esp
}
  8035d1:	90                   	nop
  8035d2:	c9                   	leave  
  8035d3:	c3                   	ret    

008035d4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
  8035d7:	83 ec 04             	sub    $0x4,%esp
  8035da:	8b 45 10             	mov    0x10(%ebp),%eax
  8035dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8035e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8035e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8035e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ea:	6a 00                	push   $0x0
  8035ec:	51                   	push   %ecx
  8035ed:	52                   	push   %edx
  8035ee:	ff 75 0c             	pushl  0xc(%ebp)
  8035f1:	50                   	push   %eax
  8035f2:	6a 15                	push   $0x15
  8035f4:	e8 e4 fd ff ff       	call   8033dd <syscall>
  8035f9:	83 c4 18             	add    $0x18,%esp
}
  8035fc:	c9                   	leave  
  8035fd:	c3                   	ret    

008035fe <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8035fe:	55                   	push   %ebp
  8035ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803601:	8b 55 0c             	mov    0xc(%ebp),%edx
  803604:	8b 45 08             	mov    0x8(%ebp),%eax
  803607:	6a 00                	push   $0x0
  803609:	6a 00                	push   $0x0
  80360b:	6a 00                	push   $0x0
  80360d:	52                   	push   %edx
  80360e:	50                   	push   %eax
  80360f:	6a 16                	push   $0x16
  803611:	e8 c7 fd ff ff       	call   8033dd <syscall>
  803616:	83 c4 18             	add    $0x18,%esp
}
  803619:	c9                   	leave  
  80361a:	c3                   	ret    

0080361b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80361b:	55                   	push   %ebp
  80361c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80361e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803621:	8b 55 0c             	mov    0xc(%ebp),%edx
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	6a 00                	push   $0x0
  803629:	6a 00                	push   $0x0
  80362b:	51                   	push   %ecx
  80362c:	52                   	push   %edx
  80362d:	50                   	push   %eax
  80362e:	6a 17                	push   $0x17
  803630:	e8 a8 fd ff ff       	call   8033dd <syscall>
  803635:	83 c4 18             	add    $0x18,%esp
}
  803638:	c9                   	leave  
  803639:	c3                   	ret    

0080363a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80363a:	55                   	push   %ebp
  80363b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80363d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	6a 00                	push   $0x0
  803645:	6a 00                	push   $0x0
  803647:	6a 00                	push   $0x0
  803649:	52                   	push   %edx
  80364a:	50                   	push   %eax
  80364b:	6a 18                	push   $0x18
  80364d:	e8 8b fd ff ff       	call   8033dd <syscall>
  803652:	83 c4 18             	add    $0x18,%esp
}
  803655:	c9                   	leave  
  803656:	c3                   	ret    

00803657 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803657:	55                   	push   %ebp
  803658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80365a:	8b 45 08             	mov    0x8(%ebp),%eax
  80365d:	6a 00                	push   $0x0
  80365f:	ff 75 14             	pushl  0x14(%ebp)
  803662:	ff 75 10             	pushl  0x10(%ebp)
  803665:	ff 75 0c             	pushl  0xc(%ebp)
  803668:	50                   	push   %eax
  803669:	6a 19                	push   $0x19
  80366b:	e8 6d fd ff ff       	call   8033dd <syscall>
  803670:	83 c4 18             	add    $0x18,%esp
}
  803673:	c9                   	leave  
  803674:	c3                   	ret    

00803675 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803675:	55                   	push   %ebp
  803676:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	6a 00                	push   $0x0
  80367d:	6a 00                	push   $0x0
  80367f:	6a 00                	push   $0x0
  803681:	6a 00                	push   $0x0
  803683:	50                   	push   %eax
  803684:	6a 1a                	push   $0x1a
  803686:	e8 52 fd ff ff       	call   8033dd <syscall>
  80368b:	83 c4 18             	add    $0x18,%esp
}
  80368e:	90                   	nop
  80368f:	c9                   	leave  
  803690:	c3                   	ret    

00803691 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803691:	55                   	push   %ebp
  803692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803694:	8b 45 08             	mov    0x8(%ebp),%eax
  803697:	6a 00                	push   $0x0
  803699:	6a 00                	push   $0x0
  80369b:	6a 00                	push   $0x0
  80369d:	6a 00                	push   $0x0
  80369f:	50                   	push   %eax
  8036a0:	6a 1b                	push   $0x1b
  8036a2:	e8 36 fd ff ff       	call   8033dd <syscall>
  8036a7:	83 c4 18             	add    $0x18,%esp
}
  8036aa:	c9                   	leave  
  8036ab:	c3                   	ret    

008036ac <sys_getenvid>:

int32 sys_getenvid(void)
{
  8036ac:	55                   	push   %ebp
  8036ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8036af:	6a 00                	push   $0x0
  8036b1:	6a 00                	push   $0x0
  8036b3:	6a 00                	push   $0x0
  8036b5:	6a 00                	push   $0x0
  8036b7:	6a 00                	push   $0x0
  8036b9:	6a 05                	push   $0x5
  8036bb:	e8 1d fd ff ff       	call   8033dd <syscall>
  8036c0:	83 c4 18             	add    $0x18,%esp
}
  8036c3:	c9                   	leave  
  8036c4:	c3                   	ret    

008036c5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8036c5:	55                   	push   %ebp
  8036c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8036c8:	6a 00                	push   $0x0
  8036ca:	6a 00                	push   $0x0
  8036cc:	6a 00                	push   $0x0
  8036ce:	6a 00                	push   $0x0
  8036d0:	6a 00                	push   $0x0
  8036d2:	6a 06                	push   $0x6
  8036d4:	e8 04 fd ff ff       	call   8033dd <syscall>
  8036d9:	83 c4 18             	add    $0x18,%esp
}
  8036dc:	c9                   	leave  
  8036dd:	c3                   	ret    

008036de <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8036de:	55                   	push   %ebp
  8036df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8036e1:	6a 00                	push   $0x0
  8036e3:	6a 00                	push   $0x0
  8036e5:	6a 00                	push   $0x0
  8036e7:	6a 00                	push   $0x0
  8036e9:	6a 00                	push   $0x0
  8036eb:	6a 07                	push   $0x7
  8036ed:	e8 eb fc ff ff       	call   8033dd <syscall>
  8036f2:	83 c4 18             	add    $0x18,%esp
}
  8036f5:	c9                   	leave  
  8036f6:	c3                   	ret    

008036f7 <sys_exit_env>:


void sys_exit_env(void)
{
  8036f7:	55                   	push   %ebp
  8036f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8036fa:	6a 00                	push   $0x0
  8036fc:	6a 00                	push   $0x0
  8036fe:	6a 00                	push   $0x0
  803700:	6a 00                	push   $0x0
  803702:	6a 00                	push   $0x0
  803704:	6a 1c                	push   $0x1c
  803706:	e8 d2 fc ff ff       	call   8033dd <syscall>
  80370b:	83 c4 18             	add    $0x18,%esp
}
  80370e:	90                   	nop
  80370f:	c9                   	leave  
  803710:	c3                   	ret    

00803711 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803711:	55                   	push   %ebp
  803712:	89 e5                	mov    %esp,%ebp
  803714:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803717:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80371a:	8d 50 04             	lea    0x4(%eax),%edx
  80371d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803720:	6a 00                	push   $0x0
  803722:	6a 00                	push   $0x0
  803724:	6a 00                	push   $0x0
  803726:	52                   	push   %edx
  803727:	50                   	push   %eax
  803728:	6a 1d                	push   $0x1d
  80372a:	e8 ae fc ff ff       	call   8033dd <syscall>
  80372f:	83 c4 18             	add    $0x18,%esp
	return result;
  803732:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803735:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803738:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80373b:	89 01                	mov    %eax,(%ecx)
  80373d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	c9                   	leave  
  803744:	c2 04 00             	ret    $0x4

00803747 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803747:	55                   	push   %ebp
  803748:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80374a:	6a 00                	push   $0x0
  80374c:	6a 00                	push   $0x0
  80374e:	ff 75 10             	pushl  0x10(%ebp)
  803751:	ff 75 0c             	pushl  0xc(%ebp)
  803754:	ff 75 08             	pushl  0x8(%ebp)
  803757:	6a 13                	push   $0x13
  803759:	e8 7f fc ff ff       	call   8033dd <syscall>
  80375e:	83 c4 18             	add    $0x18,%esp
	return ;
  803761:	90                   	nop
}
  803762:	c9                   	leave  
  803763:	c3                   	ret    

00803764 <sys_rcr2>:
uint32 sys_rcr2()
{
  803764:	55                   	push   %ebp
  803765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803767:	6a 00                	push   $0x0
  803769:	6a 00                	push   $0x0
  80376b:	6a 00                	push   $0x0
  80376d:	6a 00                	push   $0x0
  80376f:	6a 00                	push   $0x0
  803771:	6a 1e                	push   $0x1e
  803773:	e8 65 fc ff ff       	call   8033dd <syscall>
  803778:	83 c4 18             	add    $0x18,%esp
}
  80377b:	c9                   	leave  
  80377c:	c3                   	ret    

0080377d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80377d:	55                   	push   %ebp
  80377e:	89 e5                	mov    %esp,%ebp
  803780:	83 ec 04             	sub    $0x4,%esp
  803783:	8b 45 08             	mov    0x8(%ebp),%eax
  803786:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803789:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80378d:	6a 00                	push   $0x0
  80378f:	6a 00                	push   $0x0
  803791:	6a 00                	push   $0x0
  803793:	6a 00                	push   $0x0
  803795:	50                   	push   %eax
  803796:	6a 1f                	push   $0x1f
  803798:	e8 40 fc ff ff       	call   8033dd <syscall>
  80379d:	83 c4 18             	add    $0x18,%esp
	return ;
  8037a0:	90                   	nop
}
  8037a1:	c9                   	leave  
  8037a2:	c3                   	ret    

008037a3 <rsttst>:
void rsttst()
{
  8037a3:	55                   	push   %ebp
  8037a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8037a6:	6a 00                	push   $0x0
  8037a8:	6a 00                	push   $0x0
  8037aa:	6a 00                	push   $0x0
  8037ac:	6a 00                	push   $0x0
  8037ae:	6a 00                	push   $0x0
  8037b0:	6a 21                	push   $0x21
  8037b2:	e8 26 fc ff ff       	call   8033dd <syscall>
  8037b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8037ba:	90                   	nop
}
  8037bb:	c9                   	leave  
  8037bc:	c3                   	ret    

008037bd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8037bd:	55                   	push   %ebp
  8037be:	89 e5                	mov    %esp,%ebp
  8037c0:	83 ec 04             	sub    $0x4,%esp
  8037c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8037c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8037c9:	8b 55 18             	mov    0x18(%ebp),%edx
  8037cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8037d0:	52                   	push   %edx
  8037d1:	50                   	push   %eax
  8037d2:	ff 75 10             	pushl  0x10(%ebp)
  8037d5:	ff 75 0c             	pushl  0xc(%ebp)
  8037d8:	ff 75 08             	pushl  0x8(%ebp)
  8037db:	6a 20                	push   $0x20
  8037dd:	e8 fb fb ff ff       	call   8033dd <syscall>
  8037e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8037e5:	90                   	nop
}
  8037e6:	c9                   	leave  
  8037e7:	c3                   	ret    

008037e8 <chktst>:
void chktst(uint32 n)
{
  8037e8:	55                   	push   %ebp
  8037e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8037eb:	6a 00                	push   $0x0
  8037ed:	6a 00                	push   $0x0
  8037ef:	6a 00                	push   $0x0
  8037f1:	6a 00                	push   $0x0
  8037f3:	ff 75 08             	pushl  0x8(%ebp)
  8037f6:	6a 22                	push   $0x22
  8037f8:	e8 e0 fb ff ff       	call   8033dd <syscall>
  8037fd:	83 c4 18             	add    $0x18,%esp
	return ;
  803800:	90                   	nop
}
  803801:	c9                   	leave  
  803802:	c3                   	ret    

00803803 <inctst>:

void inctst()
{
  803803:	55                   	push   %ebp
  803804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803806:	6a 00                	push   $0x0
  803808:	6a 00                	push   $0x0
  80380a:	6a 00                	push   $0x0
  80380c:	6a 00                	push   $0x0
  80380e:	6a 00                	push   $0x0
  803810:	6a 23                	push   $0x23
  803812:	e8 c6 fb ff ff       	call   8033dd <syscall>
  803817:	83 c4 18             	add    $0x18,%esp
	return ;
  80381a:	90                   	nop
}
  80381b:	c9                   	leave  
  80381c:	c3                   	ret    

0080381d <gettst>:
uint32 gettst()
{
  80381d:	55                   	push   %ebp
  80381e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803820:	6a 00                	push   $0x0
  803822:	6a 00                	push   $0x0
  803824:	6a 00                	push   $0x0
  803826:	6a 00                	push   $0x0
  803828:	6a 00                	push   $0x0
  80382a:	6a 24                	push   $0x24
  80382c:	e8 ac fb ff ff       	call   8033dd <syscall>
  803831:	83 c4 18             	add    $0x18,%esp
}
  803834:	c9                   	leave  
  803835:	c3                   	ret    

00803836 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803836:	55                   	push   %ebp
  803837:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803839:	6a 00                	push   $0x0
  80383b:	6a 00                	push   $0x0
  80383d:	6a 00                	push   $0x0
  80383f:	6a 00                	push   $0x0
  803841:	6a 00                	push   $0x0
  803843:	6a 25                	push   $0x25
  803845:	e8 93 fb ff ff       	call   8033dd <syscall>
  80384a:	83 c4 18             	add    $0x18,%esp
  80384d:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  803852:	a1 80 60 83 00       	mov    0x836080,%eax
}
  803857:	c9                   	leave  
  803858:	c3                   	ret    

00803859 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803859:	55                   	push   %ebp
  80385a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80385c:	8b 45 08             	mov    0x8(%ebp),%eax
  80385f:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803864:	6a 00                	push   $0x0
  803866:	6a 00                	push   $0x0
  803868:	6a 00                	push   $0x0
  80386a:	6a 00                	push   $0x0
  80386c:	ff 75 08             	pushl  0x8(%ebp)
  80386f:	6a 26                	push   $0x26
  803871:	e8 67 fb ff ff       	call   8033dd <syscall>
  803876:	83 c4 18             	add    $0x18,%esp
	return ;
  803879:	90                   	nop
}
  80387a:	c9                   	leave  
  80387b:	c3                   	ret    

0080387c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80387c:	55                   	push   %ebp
  80387d:	89 e5                	mov    %esp,%ebp
  80387f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803880:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803883:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803886:	8b 55 0c             	mov    0xc(%ebp),%edx
  803889:	8b 45 08             	mov    0x8(%ebp),%eax
  80388c:	6a 00                	push   $0x0
  80388e:	53                   	push   %ebx
  80388f:	51                   	push   %ecx
  803890:	52                   	push   %edx
  803891:	50                   	push   %eax
  803892:	6a 27                	push   $0x27
  803894:	e8 44 fb ff ff       	call   8033dd <syscall>
  803899:	83 c4 18             	add    $0x18,%esp
}
  80389c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80389f:	c9                   	leave  
  8038a0:	c3                   	ret    

008038a1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8038a1:	55                   	push   %ebp
  8038a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8038a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038aa:	6a 00                	push   $0x0
  8038ac:	6a 00                	push   $0x0
  8038ae:	6a 00                	push   $0x0
  8038b0:	52                   	push   %edx
  8038b1:	50                   	push   %eax
  8038b2:	6a 28                	push   $0x28
  8038b4:	e8 24 fb ff ff       	call   8033dd <syscall>
  8038b9:	83 c4 18             	add    $0x18,%esp
}
  8038bc:	c9                   	leave  
  8038bd:	c3                   	ret    

008038be <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8038be:	55                   	push   %ebp
  8038bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8038c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8038c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	6a 00                	push   $0x0
  8038cc:	51                   	push   %ecx
  8038cd:	ff 75 10             	pushl  0x10(%ebp)
  8038d0:	52                   	push   %edx
  8038d1:	50                   	push   %eax
  8038d2:	6a 29                	push   $0x29
  8038d4:	e8 04 fb ff ff       	call   8033dd <syscall>
  8038d9:	83 c4 18             	add    $0x18,%esp
}
  8038dc:	c9                   	leave  
  8038dd:	c3                   	ret    

008038de <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8038de:	55                   	push   %ebp
  8038df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8038e1:	6a 00                	push   $0x0
  8038e3:	6a 00                	push   $0x0
  8038e5:	ff 75 10             	pushl  0x10(%ebp)
  8038e8:	ff 75 0c             	pushl  0xc(%ebp)
  8038eb:	ff 75 08             	pushl  0x8(%ebp)
  8038ee:	6a 12                	push   $0x12
  8038f0:	e8 e8 fa ff ff       	call   8033dd <syscall>
  8038f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8038f8:	90                   	nop
}
  8038f9:	c9                   	leave  
  8038fa:	c3                   	ret    

008038fb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8038fb:	55                   	push   %ebp
  8038fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8038fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  803901:	8b 45 08             	mov    0x8(%ebp),%eax
  803904:	6a 00                	push   $0x0
  803906:	6a 00                	push   $0x0
  803908:	6a 00                	push   $0x0
  80390a:	52                   	push   %edx
  80390b:	50                   	push   %eax
  80390c:	6a 2a                	push   $0x2a
  80390e:	e8 ca fa ff ff       	call   8033dd <syscall>
  803913:	83 c4 18             	add    $0x18,%esp
	return;
  803916:	90                   	nop
}
  803917:	c9                   	leave  
  803918:	c3                   	ret    

00803919 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803919:	55                   	push   %ebp
  80391a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80391c:	6a 00                	push   $0x0
  80391e:	6a 00                	push   $0x0
  803920:	6a 00                	push   $0x0
  803922:	6a 00                	push   $0x0
  803924:	6a 00                	push   $0x0
  803926:	6a 2b                	push   $0x2b
  803928:	e8 b0 fa ff ff       	call   8033dd <syscall>
  80392d:	83 c4 18             	add    $0x18,%esp
}
  803930:	c9                   	leave  
  803931:	c3                   	ret    

00803932 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803932:	55                   	push   %ebp
  803933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803935:	6a 00                	push   $0x0
  803937:	6a 00                	push   $0x0
  803939:	6a 00                	push   $0x0
  80393b:	ff 75 0c             	pushl  0xc(%ebp)
  80393e:	ff 75 08             	pushl  0x8(%ebp)
  803941:	6a 2d                	push   $0x2d
  803943:	e8 95 fa ff ff       	call   8033dd <syscall>
  803948:	83 c4 18             	add    $0x18,%esp
	return;
  80394b:	90                   	nop
}
  80394c:	c9                   	leave  
  80394d:	c3                   	ret    

0080394e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80394e:	55                   	push   %ebp
  80394f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803951:	6a 00                	push   $0x0
  803953:	6a 00                	push   $0x0
  803955:	6a 00                	push   $0x0
  803957:	ff 75 0c             	pushl  0xc(%ebp)
  80395a:	ff 75 08             	pushl  0x8(%ebp)
  80395d:	6a 2c                	push   $0x2c
  80395f:	e8 79 fa ff ff       	call   8033dd <syscall>
  803964:	83 c4 18             	add    $0x18,%esp
	return ;
  803967:	90                   	nop
}
  803968:	c9                   	leave  
  803969:	c3                   	ret    

0080396a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80396a:	55                   	push   %ebp
  80396b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80396d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803970:	8b 45 08             	mov    0x8(%ebp),%eax
  803973:	6a 00                	push   $0x0
  803975:	6a 00                	push   $0x0
  803977:	6a 00                	push   $0x0
  803979:	52                   	push   %edx
  80397a:	50                   	push   %eax
  80397b:	6a 2e                	push   $0x2e
  80397d:	e8 5b fa ff ff       	call   8033dd <syscall>
  803982:	83 c4 18             	add    $0x18,%esp
}
  803985:	90                   	nop
  803986:	c9                   	leave  
  803987:	c3                   	ret    

00803988 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803988:	55                   	push   %ebp
  803989:	89 e5                	mov    %esp,%ebp
  80398b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80398e:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803995:	72 09                	jb     8039a0 <to_page_va+0x18>
  803997:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  80399e:	72 14                	jb     8039b4 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8039a0:	83 ec 04             	sub    $0x4,%esp
  8039a3:	68 6c 4f 80 00       	push   $0x804f6c
  8039a8:	6a 15                	push   $0x15
  8039aa:	68 97 4f 80 00       	push   $0x804f97
  8039af:	e8 08 ce ff ff       	call   8007bc <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8039b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b7:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  8039bc:	29 d0                	sub    %edx,%eax
  8039be:	c1 f8 02             	sar    $0x2,%eax
  8039c1:	89 c2                	mov    %eax,%edx
  8039c3:	89 d0                	mov    %edx,%eax
  8039c5:	c1 e0 02             	shl    $0x2,%eax
  8039c8:	01 d0                	add    %edx,%eax
  8039ca:	c1 e0 02             	shl    $0x2,%eax
  8039cd:	01 d0                	add    %edx,%eax
  8039cf:	c1 e0 02             	shl    $0x2,%eax
  8039d2:	01 d0                	add    %edx,%eax
  8039d4:	89 c1                	mov    %eax,%ecx
  8039d6:	c1 e1 08             	shl    $0x8,%ecx
  8039d9:	01 c8                	add    %ecx,%eax
  8039db:	89 c1                	mov    %eax,%ecx
  8039dd:	c1 e1 10             	shl    $0x10,%ecx
  8039e0:	01 c8                	add    %ecx,%eax
  8039e2:	01 c0                	add    %eax,%eax
  8039e4:	01 d0                	add    %edx,%eax
  8039e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8039e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ec:	c1 e0 0c             	shl    $0xc,%eax
  8039ef:	89 c2                	mov    %eax,%edx
  8039f1:	a1 84 60 83 00       	mov    0x836084,%eax
  8039f6:	01 d0                	add    %edx,%eax
}
  8039f8:	c9                   	leave  
  8039f9:	c3                   	ret    

008039fa <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8039fa:	55                   	push   %ebp
  8039fb:	89 e5                	mov    %esp,%ebp
  8039fd:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803a00:	a1 84 60 83 00       	mov    0x836084,%eax
  803a05:	8b 55 08             	mov    0x8(%ebp),%edx
  803a08:	29 c2                	sub    %eax,%edx
  803a0a:	89 d0                	mov    %edx,%eax
  803a0c:	c1 e8 0c             	shr    $0xc,%eax
  803a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a16:	78 09                	js     803a21 <to_page_info+0x27>
  803a18:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803a1f:	7e 14                	jle    803a35 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803a21:	83 ec 04             	sub    $0x4,%esp
  803a24:	68 b0 4f 80 00       	push   $0x804fb0
  803a29:	6a 21                	push   $0x21
  803a2b:	68 97 4f 80 00       	push   $0x804f97
  803a30:	e8 87 cd ff ff       	call   8007bc <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a38:	89 d0                	mov    %edx,%eax
  803a3a:	01 c0                	add    %eax,%eax
  803a3c:	01 d0                	add    %edx,%eax
  803a3e:	c1 e0 02             	shl    $0x2,%eax
  803a41:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803a46:	c9                   	leave  
  803a47:	c3                   	ret    

00803a48 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803a48:	55                   	push   %ebp
  803a49:	89 e5                	mov    %esp,%ebp
  803a4b:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a51:	05 00 00 00 02       	add    $0x2000000,%eax
  803a56:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a59:	73 16                	jae    803a71 <initialize_dynamic_allocator+0x29>
  803a5b:	68 d4 4f 80 00       	push   $0x804fd4
  803a60:	68 fa 4f 80 00       	push   $0x804ffa
  803a65:	6a 2f                	push   $0x2f
  803a67:	68 97 4f 80 00       	push   $0x804f97
  803a6c:	e8 4b cd ff ff       	call   8007bc <_panic>
	dynAllocStart = daStart;
  803a71:	8b 45 08             	mov    0x8(%ebp),%eax
  803a74:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a7c:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a88:	eb 36                	jmp    803ac0 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8d:	c1 e0 04             	shl    $0x4,%eax
  803a90:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803a95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9e:	c1 e0 04             	shl    $0x4,%eax
  803aa1:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803aa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aaf:	c1 e0 04             	shl    $0x4,%eax
  803ab2:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803ab7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803abd:	ff 45 f4             	incl   -0xc(%ebp)
  803ac0:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803ac4:	7e c4                	jle    803a8a <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803ac6:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803acd:	00 00 00 
  803ad0:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803ad7:	00 00 00 
  803ada:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803ae1:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803ae4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803aeb:	e9 1b 01 00 00       	jmp    803c0b <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803af0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803af3:	89 d0                	mov    %edx,%eax
  803af5:	01 c0                	add    %eax,%eax
  803af7:	01 d0                	add    %edx,%eax
  803af9:	c1 e0 02             	shl    $0x2,%eax
  803afc:	05 88 e0 81 00       	add    $0x81e088,%eax
  803b01:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803b06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b09:	89 d0                	mov    %edx,%eax
  803b0b:	01 c0                	add    %eax,%eax
  803b0d:	01 d0                	add    %edx,%eax
  803b0f:	c1 e0 02             	shl    $0x2,%eax
  803b12:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803b17:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803b1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b1f:	89 d0                	mov    %edx,%eax
  803b21:	01 c0                	add    %eax,%eax
  803b23:	01 d0                	add    %edx,%eax
  803b25:	c1 e0 02             	shl    $0x2,%eax
  803b28:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b2d:	8b 00                	mov    (%eax),%eax
  803b2f:	85 c0                	test   %eax,%eax
  803b31:	74 2b                	je     803b5e <initialize_dynamic_allocator+0x116>
  803b33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b36:	89 d0                	mov    %edx,%eax
  803b38:	01 c0                	add    %eax,%eax
  803b3a:	01 d0                	add    %edx,%eax
  803b3c:	c1 e0 02             	shl    $0x2,%eax
  803b3f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b44:	8b 10                	mov    (%eax),%edx
  803b46:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b49:	89 c8                	mov    %ecx,%eax
  803b4b:	01 c0                	add    %eax,%eax
  803b4d:	01 c8                	add    %ecx,%eax
  803b4f:	c1 e0 02             	shl    $0x2,%eax
  803b52:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b57:	8b 00                	mov    (%eax),%eax
  803b59:	89 42 04             	mov    %eax,0x4(%edx)
  803b5c:	eb 18                	jmp    803b76 <initialize_dynamic_allocator+0x12e>
  803b5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b61:	89 d0                	mov    %edx,%eax
  803b63:	01 c0                	add    %eax,%eax
  803b65:	01 d0                	add    %edx,%eax
  803b67:	c1 e0 02             	shl    $0x2,%eax
  803b6a:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b6f:	8b 00                	mov    (%eax),%eax
  803b71:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803b76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b79:	89 d0                	mov    %edx,%eax
  803b7b:	01 c0                	add    %eax,%eax
  803b7d:	01 d0                	add    %edx,%eax
  803b7f:	c1 e0 02             	shl    $0x2,%eax
  803b82:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b87:	8b 00                	mov    (%eax),%eax
  803b89:	85 c0                	test   %eax,%eax
  803b8b:	74 2a                	je     803bb7 <initialize_dynamic_allocator+0x16f>
  803b8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b90:	89 d0                	mov    %edx,%eax
  803b92:	01 c0                	add    %eax,%eax
  803b94:	01 d0                	add    %edx,%eax
  803b96:	c1 e0 02             	shl    $0x2,%eax
  803b99:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b9e:	8b 10                	mov    (%eax),%edx
  803ba0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803ba3:	89 c8                	mov    %ecx,%eax
  803ba5:	01 c0                	add    %eax,%eax
  803ba7:	01 c8                	add    %ecx,%eax
  803ba9:	c1 e0 02             	shl    $0x2,%eax
  803bac:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bb1:	8b 00                	mov    (%eax),%eax
  803bb3:	89 02                	mov    %eax,(%edx)
  803bb5:	eb 18                	jmp    803bcf <initialize_dynamic_allocator+0x187>
  803bb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bba:	89 d0                	mov    %edx,%eax
  803bbc:	01 c0                	add    %eax,%eax
  803bbe:	01 d0                	add    %edx,%eax
  803bc0:	c1 e0 02             	shl    $0x2,%eax
  803bc3:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bc8:	8b 00                	mov    (%eax),%eax
  803bca:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803bcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bd2:	89 d0                	mov    %edx,%eax
  803bd4:	01 c0                	add    %eax,%eax
  803bd6:	01 d0                	add    %edx,%eax
  803bd8:	c1 e0 02             	shl    $0x2,%eax
  803bdb:	05 80 e0 81 00       	add    $0x81e080,%eax
  803be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803be9:	89 d0                	mov    %edx,%eax
  803beb:	01 c0                	add    %eax,%eax
  803bed:	01 d0                	add    %edx,%eax
  803bef:	c1 e0 02             	shl    $0x2,%eax
  803bf2:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bfd:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803c02:	48                   	dec    %eax
  803c03:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803c08:	ff 45 f0             	incl   -0x10(%ebp)
  803c0b:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803c12:	0f 8e d8 fe ff ff    	jle    803af0 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803c18:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803c1f:	e9 9d 00 00 00       	jmp    803cc1 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803c24:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803c2a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c2d:	89 c8                	mov    %ecx,%eax
  803c2f:	01 c0                	add    %eax,%eax
  803c31:	01 c8                	add    %ecx,%eax
  803c33:	c1 e0 02             	shl    $0x2,%eax
  803c36:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c3b:	89 10                	mov    %edx,(%eax)
  803c3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c40:	89 d0                	mov    %edx,%eax
  803c42:	01 c0                	add    %eax,%eax
  803c44:	01 d0                	add    %edx,%eax
  803c46:	c1 e0 02             	shl    $0x2,%eax
  803c49:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c4e:	8b 00                	mov    (%eax),%eax
  803c50:	85 c0                	test   %eax,%eax
  803c52:	74 1c                	je     803c70 <initialize_dynamic_allocator+0x228>
  803c54:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803c5a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c5d:	89 c8                	mov    %ecx,%eax
  803c5f:	01 c0                	add    %eax,%eax
  803c61:	01 c8                	add    %ecx,%eax
  803c63:	c1 e0 02             	shl    $0x2,%eax
  803c66:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c6b:	89 42 04             	mov    %eax,0x4(%edx)
  803c6e:	eb 16                	jmp    803c86 <initialize_dynamic_allocator+0x23e>
  803c70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c73:	89 d0                	mov    %edx,%eax
  803c75:	01 c0                	add    %eax,%eax
  803c77:	01 d0                	add    %edx,%eax
  803c79:	c1 e0 02             	shl    $0x2,%eax
  803c7c:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c81:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803c86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c89:	89 d0                	mov    %edx,%eax
  803c8b:	01 c0                	add    %eax,%eax
  803c8d:	01 d0                	add    %edx,%eax
  803c8f:	c1 e0 02             	shl    $0x2,%eax
  803c92:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c97:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803c9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c9f:	89 d0                	mov    %edx,%eax
  803ca1:	01 c0                	add    %eax,%eax
  803ca3:	01 d0                	add    %edx,%eax
  803ca5:	c1 e0 02             	shl    $0x2,%eax
  803ca8:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cb3:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803cb8:	40                   	inc    %eax
  803cb9:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803cbe:	ff 4d ec             	decl   -0x14(%ebp)
  803cc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cc5:	0f 89 59 ff ff ff    	jns    803c24 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803ccb:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803cd2:	00 00 00 
}
  803cd5:	90                   	nop
  803cd6:	c9                   	leave  
  803cd7:	c3                   	ret    

00803cd8 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803cd8:	55                   	push   %ebp
  803cd9:	89 e5                	mov    %esp,%ebp
  803cdb:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803cde:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce1:	83 ec 0c             	sub    $0xc,%esp
  803ce4:	50                   	push   %eax
  803ce5:	e8 10 fd ff ff       	call   8039fa <to_page_info>
  803cea:	83 c4 10             	add    $0x10,%esp
  803ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf3:	8b 40 08             	mov    0x8(%eax),%eax
  803cf6:	0f b7 c0             	movzwl %ax,%eax
}
  803cf9:	c9                   	leave  
  803cfa:	c3                   	ret    

00803cfb <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803cfb:	55                   	push   %ebp
  803cfc:	89 e5                	mov    %esp,%ebp
  803cfe:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803d01:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803d08:	76 16                	jbe    803d20 <alloc_block+0x25>
  803d0a:	68 10 50 80 00       	push   $0x805010
  803d0f:	68 fa 4f 80 00       	push   $0x804ffa
  803d14:	6a 59                	push   $0x59
  803d16:	68 97 4f 80 00       	push   $0x804f97
  803d1b:	e8 9c ca ff ff       	call   8007bc <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803d20:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803d27:	eb 08                	jmp    803d31 <alloc_block+0x36>
		allocSize <<= 1;
  803d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2c:	01 c0                	add    %eax,%eax
  803d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d34:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d37:	73 09                	jae    803d42 <alloc_block+0x47>
  803d39:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803d40:	76 e7                	jbe    803d29 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803d42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803d49:	eb 03                	jmp    803d4e <alloc_block+0x53>
		listIndex++;
  803d4b:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d51:	ba 08 00 00 00       	mov    $0x8,%edx
  803d56:	88 c1                	mov    %al,%cl
  803d58:	d3 e2                	shl    %cl,%edx
  803d5a:	89 d0                	mov    %edx,%eax
  803d5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803d5f:	72 ea                	jb     803d4b <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803d67:	e9 f4 00 00 00       	jmp    803e60 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d6f:	c1 e0 04             	shl    $0x4,%eax
  803d72:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d77:	8b 00                	mov    (%eax),%eax
  803d79:	85 c0                	test   %eax,%eax
  803d7b:	0f 84 dc 00 00 00    	je     803e5d <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d84:	c1 e0 04             	shl    $0x4,%eax
  803d87:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d8c:	8b 00                	mov    (%eax),%eax
  803d8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d95:	75 14                	jne    803dab <alloc_block+0xb0>
  803d97:	83 ec 04             	sub    $0x4,%esp
  803d9a:	68 31 50 80 00       	push   $0x805031
  803d9f:	6a 6b                	push   $0x6b
  803da1:	68 97 4f 80 00       	push   $0x804f97
  803da6:	e8 11 ca ff ff       	call   8007bc <_panic>
  803dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dae:	8b 00                	mov    (%eax),%eax
  803db0:	85 c0                	test   %eax,%eax
  803db2:	74 10                	je     803dc4 <alloc_block+0xc9>
  803db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db7:	8b 00                	mov    (%eax),%eax
  803db9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dbc:	8b 52 04             	mov    0x4(%edx),%edx
  803dbf:	89 50 04             	mov    %edx,0x4(%eax)
  803dc2:	eb 14                	jmp    803dd8 <alloc_block+0xdd>
  803dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc7:	8b 40 04             	mov    0x4(%eax),%eax
  803dca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dcd:	c1 e2 04             	shl    $0x4,%edx
  803dd0:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803dd6:	89 02                	mov    %eax,(%edx)
  803dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ddb:	8b 40 04             	mov    0x4(%eax),%eax
  803dde:	85 c0                	test   %eax,%eax
  803de0:	74 0f                	je     803df1 <alloc_block+0xf6>
  803de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de5:	8b 40 04             	mov    0x4(%eax),%eax
  803de8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803deb:	8b 12                	mov    (%edx),%edx
  803ded:	89 10                	mov    %edx,(%eax)
  803def:	eb 13                	jmp    803e04 <alloc_block+0x109>
  803df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df4:	8b 00                	mov    (%eax),%eax
  803df6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803df9:	c1 e2 04             	shl    $0x4,%edx
  803dfc:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803e02:	89 02                	mov    %eax,(%edx)
  803e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e1a:	c1 e0 04             	shl    $0x4,%eax
  803e1d:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e22:	8b 00                	mov    (%eax),%eax
  803e24:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e2a:	c1 e0 04             	shl    $0x4,%eax
  803e2d:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e32:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e37:	83 ec 0c             	sub    $0xc,%esp
  803e3a:	50                   	push   %eax
  803e3b:	e8 ba fb ff ff       	call   8039fa <to_page_info>
  803e40:	83 c4 10             	add    $0x10,%esp
  803e43:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e49:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e4d:	48                   	dec    %eax
  803e4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e51:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e58:	e9 8f 02 00 00       	jmp    8040ec <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803e5d:	ff 45 ec             	incl   -0x14(%ebp)
  803e60:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803e64:	0f 8e 02 ff ff ff    	jle    803d6c <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803e6a:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803e6f:	85 c0                	test   %eax,%eax
  803e71:	75 14                	jne    803e87 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803e73:	83 ec 04             	sub    $0x4,%esp
  803e76:	68 50 50 80 00       	push   $0x805050
  803e7b:	6a 77                	push   $0x77
  803e7d:	68 97 4f 80 00       	push   $0x804f97
  803e82:	e8 35 c9 ff ff       	call   8007bc <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803e87:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803e8c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803e8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e93:	75 14                	jne    803ea9 <alloc_block+0x1ae>
  803e95:	83 ec 04             	sub    $0x4,%esp
  803e98:	68 31 50 80 00       	push   $0x805031
  803e9d:	6a 7a                	push   $0x7a
  803e9f:	68 97 4f 80 00       	push   $0x804f97
  803ea4:	e8 13 c9 ff ff       	call   8007bc <_panic>
  803ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eac:	8b 00                	mov    (%eax),%eax
  803eae:	85 c0                	test   %eax,%eax
  803eb0:	74 10                	je     803ec2 <alloc_block+0x1c7>
  803eb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eb5:	8b 00                	mov    (%eax),%eax
  803eb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803eba:	8b 52 04             	mov    0x4(%edx),%edx
  803ebd:	89 50 04             	mov    %edx,0x4(%eax)
  803ec0:	eb 0b                	jmp    803ecd <alloc_block+0x1d2>
  803ec2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ec5:	8b 40 04             	mov    0x4(%eax),%eax
  803ec8:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803ecd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ed0:	8b 40 04             	mov    0x4(%eax),%eax
  803ed3:	85 c0                	test   %eax,%eax
  803ed5:	74 0f                	je     803ee6 <alloc_block+0x1eb>
  803ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eda:	8b 40 04             	mov    0x4(%eax),%eax
  803edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ee0:	8b 12                	mov    (%edx),%edx
  803ee2:	89 10                	mov    %edx,(%eax)
  803ee4:	eb 0a                	jmp    803ef0 <alloc_block+0x1f5>
  803ee6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ee9:	8b 00                	mov    (%eax),%eax
  803eeb:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ef9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803efc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f03:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803f08:	48                   	dec    %eax
  803f09:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803f0e:	83 ec 0c             	sub    $0xc,%esp
  803f11:	ff 75 dc             	pushl  -0x24(%ebp)
  803f14:	e8 6f fa ff ff       	call   803988 <to_page_va>
  803f19:	83 c4 10             	add    $0x10,%esp
  803f1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803f1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f22:	83 ec 0c             	sub    $0xc,%esp
  803f25:	50                   	push   %eax
  803f26:	e8 a0 dc ff ff       	call   801bcb <get_page>
  803f2b:	83 c4 10             	add    $0x10,%esp
  803f2e:	85 c0                	test   %eax,%eax
  803f30:	74 14                	je     803f46 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803f32:	83 ec 04             	sub    $0x4,%esp
  803f35:	68 78 50 80 00       	push   $0x805078
  803f3a:	6a 7f                	push   $0x7f
  803f3c:	68 97 4f 80 00       	push   $0x804f97
  803f41:	e8 76 c8 ff ff       	call   8007bc <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f4c:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803f50:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f55:	ba 00 00 00 00       	mov    $0x0,%edx
  803f5a:	f7 75 f4             	divl   -0xc(%ebp)
  803f5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f60:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803f64:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803f6b:	e9 a7 00 00 00       	jmp    804017 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803f70:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f76:	01 d0                	add    %edx,%eax
  803f78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803f7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f7f:	75 17                	jne    803f98 <alloc_block+0x29d>
  803f81:	83 ec 04             	sub    $0x4,%esp
  803f84:	68 a0 50 80 00       	push   $0x8050a0
  803f89:	68 88 00 00 00       	push   $0x88
  803f8e:	68 97 4f 80 00       	push   $0x804f97
  803f93:	e8 24 c8 ff ff       	call   8007bc <_panic>
  803f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f9b:	c1 e0 04             	shl    $0x4,%eax
  803f9e:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803fa3:	8b 10                	mov    (%eax),%edx
  803fa5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa8:	89 10                	mov    %edx,(%eax)
  803faa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fad:	8b 00                	mov    (%eax),%eax
  803faf:	85 c0                	test   %eax,%eax
  803fb1:	74 15                	je     803fc8 <alloc_block+0x2cd>
  803fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb6:	c1 e0 04             	shl    $0x4,%eax
  803fb9:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803fbe:	8b 00                	mov    (%eax),%eax
  803fc0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fc3:	89 50 04             	mov    %edx,0x4(%eax)
  803fc6:	eb 11                	jmp    803fd9 <alloc_block+0x2de>
  803fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fcb:	c1 e0 04             	shl    $0x4,%eax
  803fce:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803fd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fd7:	89 02                	mov    %eax,(%edx)
  803fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fdc:	c1 e0 04             	shl    $0x4,%eax
  803fdf:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803fe5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fe8:	89 02                	mov    %eax,(%edx)
  803fea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff7:	c1 e0 04             	shl    $0x4,%eax
  803ffa:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803fff:	8b 00                	mov    (%eax),%eax
  804001:	8d 50 01             	lea    0x1(%eax),%edx
  804004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804007:	c1 e0 04             	shl    $0x4,%eax
  80400a:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80400f:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  804011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804014:	01 45 e8             	add    %eax,-0x18(%ebp)
  804017:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80401e:	0f 86 4c ff ff ff    	jbe    803f70 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  804024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804027:	c1 e0 04             	shl    $0x4,%eax
  80402a:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80402f:	8b 00                	mov    (%eax),%eax
  804031:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  804034:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804038:	75 17                	jne    804051 <alloc_block+0x356>
  80403a:	83 ec 04             	sub    $0x4,%esp
  80403d:	68 31 50 80 00       	push   $0x805031
  804042:	68 8d 00 00 00       	push   $0x8d
  804047:	68 97 4f 80 00       	push   $0x804f97
  80404c:	e8 6b c7 ff ff       	call   8007bc <_panic>
  804051:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804054:	8b 00                	mov    (%eax),%eax
  804056:	85 c0                	test   %eax,%eax
  804058:	74 10                	je     80406a <alloc_block+0x36f>
  80405a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80405d:	8b 00                	mov    (%eax),%eax
  80405f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804062:	8b 52 04             	mov    0x4(%edx),%edx
  804065:	89 50 04             	mov    %edx,0x4(%eax)
  804068:	eb 14                	jmp    80407e <alloc_block+0x383>
  80406a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80406d:	8b 40 04             	mov    0x4(%eax),%eax
  804070:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804073:	c1 e2 04             	shl    $0x4,%edx
  804076:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  80407c:	89 02                	mov    %eax,(%edx)
  80407e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804081:	8b 40 04             	mov    0x4(%eax),%eax
  804084:	85 c0                	test   %eax,%eax
  804086:	74 0f                	je     804097 <alloc_block+0x39c>
  804088:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80408b:	8b 40 04             	mov    0x4(%eax),%eax
  80408e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804091:	8b 12                	mov    (%edx),%edx
  804093:	89 10                	mov    %edx,(%eax)
  804095:	eb 13                	jmp    8040aa <alloc_block+0x3af>
  804097:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80409a:	8b 00                	mov    (%eax),%eax
  80409c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80409f:	c1 e2 04             	shl    $0x4,%edx
  8040a2:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8040a8:	89 02                	mov    %eax,(%edx)
  8040aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040c0:	c1 e0 04             	shl    $0x4,%eax
  8040c3:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8040c8:	8b 00                	mov    (%eax),%eax
  8040ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8040cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040d0:	c1 e0 04             	shl    $0x4,%eax
  8040d3:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8040d8:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8040da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040dd:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8040e1:	48                   	dec    %eax
  8040e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040e5:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  8040e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8040ec:	c9                   	leave  
  8040ed:	c3                   	ret    

008040ee <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8040ee:	55                   	push   %ebp
  8040ef:	89 e5                	mov    %esp,%ebp
  8040f1:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8040f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8040f7:	a1 84 60 83 00       	mov    0x836084,%eax
  8040fc:	39 c2                	cmp    %eax,%edx
  8040fe:	72 0c                	jb     80410c <free_block+0x1e>
  804100:	8b 55 08             	mov    0x8(%ebp),%edx
  804103:	a1 60 e0 81 00       	mov    0x81e060,%eax
  804108:	39 c2                	cmp    %eax,%edx
  80410a:	72 19                	jb     804125 <free_block+0x37>
  80410c:	68 c4 50 80 00       	push   $0x8050c4
  804111:	68 fa 4f 80 00       	push   $0x804ffa
  804116:	68 98 00 00 00       	push   $0x98
  80411b:	68 97 4f 80 00       	push   $0x804f97
  804120:	e8 97 c6 ff ff       	call   8007bc <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804125:	8b 45 08             	mov    0x8(%ebp),%eax
  804128:	83 ec 0c             	sub    $0xc,%esp
  80412b:	50                   	push   %eax
  80412c:	e8 c9 f8 ff ff       	call   8039fa <to_page_info>
  804131:	83 c4 10             	add    $0x10,%esp
  804134:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804137:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80413a:	8b 40 08             	mov    0x8(%eax),%eax
  80413d:	0f b7 c0             	movzwl %ax,%eax
  804140:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  804143:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  80414a:	eb 03                	jmp    80414f <free_block+0x61>
		listIndex++;
  80414c:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  80414f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804152:	ba 08 00 00 00       	mov    $0x8,%edx
  804157:	88 c1                	mov    %al,%cl
  804159:	d3 e2                	shl    %cl,%edx
  80415b:	89 d0                	mov    %edx,%eax
  80415d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804160:	72 ea                	jb     80414c <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  804162:	8b 45 08             	mov    0x8(%ebp),%eax
  804165:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  804168:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80416c:	75 17                	jne    804185 <free_block+0x97>
  80416e:	83 ec 04             	sub    $0x4,%esp
  804171:	68 a0 50 80 00       	push   $0x8050a0
  804176:	68 a2 00 00 00       	push   $0xa2
  80417b:	68 97 4f 80 00       	push   $0x804f97
  804180:	e8 37 c6 ff ff       	call   8007bc <_panic>
  804185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804188:	c1 e0 04             	shl    $0x4,%eax
  80418b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804190:	8b 10                	mov    (%eax),%edx
  804192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804195:	89 10                	mov    %edx,(%eax)
  804197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80419a:	8b 00                	mov    (%eax),%eax
  80419c:	85 c0                	test   %eax,%eax
  80419e:	74 15                	je     8041b5 <free_block+0xc7>
  8041a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041a3:	c1 e0 04             	shl    $0x4,%eax
  8041a6:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041ab:	8b 00                	mov    (%eax),%eax
  8041ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041b0:	89 50 04             	mov    %edx,0x4(%eax)
  8041b3:	eb 11                	jmp    8041c6 <free_block+0xd8>
  8041b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b8:	c1 e0 04             	shl    $0x4,%eax
  8041bb:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8041c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c4:	89 02                	mov    %eax,(%edx)
  8041c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041c9:	c1 e0 04             	shl    $0x4,%eax
  8041cc:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8041d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d5:	89 02                	mov    %eax,(%edx)
  8041d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041e4:	c1 e0 04             	shl    $0x4,%eax
  8041e7:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041ec:	8b 00                	mov    (%eax),%eax
  8041ee:	8d 50 01             	lea    0x1(%eax),%edx
  8041f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f4:	c1 e0 04             	shl    $0x4,%eax
  8041f7:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041fc:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  8041fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804201:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804205:	40                   	inc    %eax
  804206:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804209:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  80420d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804210:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804214:	0f b7 c8             	movzwl %ax,%ecx
  804217:	b8 00 10 00 00       	mov    $0x1000,%eax
  80421c:	ba 00 00 00 00       	mov    $0x0,%edx
  804221:	f7 75 e8             	divl   -0x18(%ebp)
  804224:	39 c1                	cmp    %eax,%ecx
  804226:	0f 85 ed 01 00 00    	jne    804419 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  80422c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422f:	c1 e0 04             	shl    $0x4,%eax
  804232:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804237:	8b 00                	mov    (%eax),%eax
  804239:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80423c:	eb 2a                	jmp    804268 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  80423e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804241:	83 ec 0c             	sub    $0xc,%esp
  804244:	50                   	push   %eax
  804245:	e8 b0 f7 ff ff       	call   8039fa <to_page_info>
  80424a:	83 c4 10             	add    $0x10,%esp
  80424d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804250:	75 06                	jne    804258 <free_block+0x16a>
				tmp = b;
  804252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804255:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80425b:	c1 e0 04             	shl    $0x4,%eax
  80425e:	05 a8 60 83 00       	add    $0x8360a8,%eax
  804263:	8b 00                	mov    (%eax),%eax
  804265:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804268:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80426c:	74 07                	je     804275 <free_block+0x187>
  80426e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804271:	8b 00                	mov    (%eax),%eax
  804273:	eb 05                	jmp    80427a <free_block+0x18c>
  804275:	b8 00 00 00 00       	mov    $0x0,%eax
  80427a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80427d:	c1 e2 04             	shl    $0x4,%edx
  804280:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  804286:	89 02                	mov    %eax,(%edx)
  804288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80428b:	c1 e0 04             	shl    $0x4,%eax
  80428e:	05 a8 60 83 00       	add    $0x8360a8,%eax
  804293:	8b 00                	mov    (%eax),%eax
  804295:	85 c0                	test   %eax,%eax
  804297:	75 a5                	jne    80423e <free_block+0x150>
  804299:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80429d:	75 9f                	jne    80423e <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  80429f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042a2:	c1 e0 04             	shl    $0x4,%eax
  8042a5:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8042aa:	8b 00                	mov    (%eax),%eax
  8042ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  8042af:	e9 cc 00 00 00       	jmp    804380 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  8042b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b7:	8b 00                	mov    (%eax),%eax
  8042b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  8042bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042bf:	83 ec 0c             	sub    $0xc,%esp
  8042c2:	50                   	push   %eax
  8042c3:	e8 32 f7 ff ff       	call   8039fa <to_page_info>
  8042c8:	83 c4 10             	add    $0x10,%esp
  8042cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8042ce:	0f 85 a6 00 00 00    	jne    80437a <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  8042d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042d8:	75 17                	jne    8042f1 <free_block+0x203>
  8042da:	83 ec 04             	sub    $0x4,%esp
  8042dd:	68 31 50 80 00       	push   $0x805031
  8042e2:	68 b5 00 00 00       	push   $0xb5
  8042e7:	68 97 4f 80 00       	push   $0x804f97
  8042ec:	e8 cb c4 ff ff       	call   8007bc <_panic>
  8042f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042f4:	8b 00                	mov    (%eax),%eax
  8042f6:	85 c0                	test   %eax,%eax
  8042f8:	74 10                	je     80430a <free_block+0x21c>
  8042fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042fd:	8b 00                	mov    (%eax),%eax
  8042ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804302:	8b 52 04             	mov    0x4(%edx),%edx
  804305:	89 50 04             	mov    %edx,0x4(%eax)
  804308:	eb 14                	jmp    80431e <free_block+0x230>
  80430a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80430d:	8b 40 04             	mov    0x4(%eax),%eax
  804310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804313:	c1 e2 04             	shl    $0x4,%edx
  804316:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  80431c:	89 02                	mov    %eax,(%edx)
  80431e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804321:	8b 40 04             	mov    0x4(%eax),%eax
  804324:	85 c0                	test   %eax,%eax
  804326:	74 0f                	je     804337 <free_block+0x249>
  804328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80432b:	8b 40 04             	mov    0x4(%eax),%eax
  80432e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804331:	8b 12                	mov    (%edx),%edx
  804333:	89 10                	mov    %edx,(%eax)
  804335:	eb 13                	jmp    80434a <free_block+0x25c>
  804337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80433a:	8b 00                	mov    (%eax),%eax
  80433c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80433f:	c1 e2 04             	shl    $0x4,%edx
  804342:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804348:	89 02                	mov    %eax,(%edx)
  80434a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80434d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804356:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80435d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804360:	c1 e0 04             	shl    $0x4,%eax
  804363:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804368:	8b 00                	mov    (%eax),%eax
  80436a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80436d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804370:	c1 e0 04             	shl    $0x4,%eax
  804373:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804378:	89 10                	mov    %edx,(%eax)
			b = next;
  80437a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80437d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804384:	0f 85 2a ff ff ff    	jne    8042b4 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  80438a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80438d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804393:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804396:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  80439c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8043a0:	75 17                	jne    8043b9 <free_block+0x2cb>
  8043a2:	83 ec 04             	sub    $0x4,%esp
  8043a5:	68 a0 50 80 00       	push   $0x8050a0
  8043aa:	68 bc 00 00 00       	push   $0xbc
  8043af:	68 97 4f 80 00       	push   $0x804f97
  8043b4:	e8 03 c4 ff ff       	call   8007bc <_panic>
  8043b9:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8043bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043c2:	89 10                	mov    %edx,(%eax)
  8043c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043c7:	8b 00                	mov    (%eax),%eax
  8043c9:	85 c0                	test   %eax,%eax
  8043cb:	74 0d                	je     8043da <free_block+0x2ec>
  8043cd:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8043d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8043d5:	89 50 04             	mov    %edx,0x4(%eax)
  8043d8:	eb 08                	jmp    8043e2 <free_block+0x2f4>
  8043da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043dd:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8043e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043e5:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8043ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043f4:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8043f9:	40                   	inc    %eax
  8043fa:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  8043ff:	83 ec 0c             	sub    $0xc,%esp
  804402:	ff 75 ec             	pushl  -0x14(%ebp)
  804405:	e8 7e f5 ff ff       	call   803988 <to_page_va>
  80440a:	83 c4 10             	add    $0x10,%esp
  80440d:	83 ec 0c             	sub    $0xc,%esp
  804410:	50                   	push   %eax
  804411:	e8 fe d7 ff ff       	call   801c14 <return_page>
  804416:	83 c4 10             	add    $0x10,%esp
	}
}
  804419:	90                   	nop
  80441a:	c9                   	leave  
  80441b:	c3                   	ret    

0080441c <__udivdi3>:
  80441c:	55                   	push   %ebp
  80441d:	57                   	push   %edi
  80441e:	56                   	push   %esi
  80441f:	53                   	push   %ebx
  804420:	83 ec 1c             	sub    $0x1c,%esp
  804423:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804427:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80442b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80442f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804433:	89 ca                	mov    %ecx,%edx
  804435:	89 f8                	mov    %edi,%eax
  804437:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80443b:	85 f6                	test   %esi,%esi
  80443d:	75 2d                	jne    80446c <__udivdi3+0x50>
  80443f:	39 cf                	cmp    %ecx,%edi
  804441:	77 65                	ja     8044a8 <__udivdi3+0x8c>
  804443:	89 fd                	mov    %edi,%ebp
  804445:	85 ff                	test   %edi,%edi
  804447:	75 0b                	jne    804454 <__udivdi3+0x38>
  804449:	b8 01 00 00 00       	mov    $0x1,%eax
  80444e:	31 d2                	xor    %edx,%edx
  804450:	f7 f7                	div    %edi
  804452:	89 c5                	mov    %eax,%ebp
  804454:	31 d2                	xor    %edx,%edx
  804456:	89 c8                	mov    %ecx,%eax
  804458:	f7 f5                	div    %ebp
  80445a:	89 c1                	mov    %eax,%ecx
  80445c:	89 d8                	mov    %ebx,%eax
  80445e:	f7 f5                	div    %ebp
  804460:	89 cf                	mov    %ecx,%edi
  804462:	89 fa                	mov    %edi,%edx
  804464:	83 c4 1c             	add    $0x1c,%esp
  804467:	5b                   	pop    %ebx
  804468:	5e                   	pop    %esi
  804469:	5f                   	pop    %edi
  80446a:	5d                   	pop    %ebp
  80446b:	c3                   	ret    
  80446c:	39 ce                	cmp    %ecx,%esi
  80446e:	77 28                	ja     804498 <__udivdi3+0x7c>
  804470:	0f bd fe             	bsr    %esi,%edi
  804473:	83 f7 1f             	xor    $0x1f,%edi
  804476:	75 40                	jne    8044b8 <__udivdi3+0x9c>
  804478:	39 ce                	cmp    %ecx,%esi
  80447a:	72 0a                	jb     804486 <__udivdi3+0x6a>
  80447c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804480:	0f 87 9e 00 00 00    	ja     804524 <__udivdi3+0x108>
  804486:	b8 01 00 00 00       	mov    $0x1,%eax
  80448b:	89 fa                	mov    %edi,%edx
  80448d:	83 c4 1c             	add    $0x1c,%esp
  804490:	5b                   	pop    %ebx
  804491:	5e                   	pop    %esi
  804492:	5f                   	pop    %edi
  804493:	5d                   	pop    %ebp
  804494:	c3                   	ret    
  804495:	8d 76 00             	lea    0x0(%esi),%esi
  804498:	31 ff                	xor    %edi,%edi
  80449a:	31 c0                	xor    %eax,%eax
  80449c:	89 fa                	mov    %edi,%edx
  80449e:	83 c4 1c             	add    $0x1c,%esp
  8044a1:	5b                   	pop    %ebx
  8044a2:	5e                   	pop    %esi
  8044a3:	5f                   	pop    %edi
  8044a4:	5d                   	pop    %ebp
  8044a5:	c3                   	ret    
  8044a6:	66 90                	xchg   %ax,%ax
  8044a8:	89 d8                	mov    %ebx,%eax
  8044aa:	f7 f7                	div    %edi
  8044ac:	31 ff                	xor    %edi,%edi
  8044ae:	89 fa                	mov    %edi,%edx
  8044b0:	83 c4 1c             	add    $0x1c,%esp
  8044b3:	5b                   	pop    %ebx
  8044b4:	5e                   	pop    %esi
  8044b5:	5f                   	pop    %edi
  8044b6:	5d                   	pop    %ebp
  8044b7:	c3                   	ret    
  8044b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8044bd:	89 eb                	mov    %ebp,%ebx
  8044bf:	29 fb                	sub    %edi,%ebx
  8044c1:	89 f9                	mov    %edi,%ecx
  8044c3:	d3 e6                	shl    %cl,%esi
  8044c5:	89 c5                	mov    %eax,%ebp
  8044c7:	88 d9                	mov    %bl,%cl
  8044c9:	d3 ed                	shr    %cl,%ebp
  8044cb:	89 e9                	mov    %ebp,%ecx
  8044cd:	09 f1                	or     %esi,%ecx
  8044cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8044d3:	89 f9                	mov    %edi,%ecx
  8044d5:	d3 e0                	shl    %cl,%eax
  8044d7:	89 c5                	mov    %eax,%ebp
  8044d9:	89 d6                	mov    %edx,%esi
  8044db:	88 d9                	mov    %bl,%cl
  8044dd:	d3 ee                	shr    %cl,%esi
  8044df:	89 f9                	mov    %edi,%ecx
  8044e1:	d3 e2                	shl    %cl,%edx
  8044e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044e7:	88 d9                	mov    %bl,%cl
  8044e9:	d3 e8                	shr    %cl,%eax
  8044eb:	09 c2                	or     %eax,%edx
  8044ed:	89 d0                	mov    %edx,%eax
  8044ef:	89 f2                	mov    %esi,%edx
  8044f1:	f7 74 24 0c          	divl   0xc(%esp)
  8044f5:	89 d6                	mov    %edx,%esi
  8044f7:	89 c3                	mov    %eax,%ebx
  8044f9:	f7 e5                	mul    %ebp
  8044fb:	39 d6                	cmp    %edx,%esi
  8044fd:	72 19                	jb     804518 <__udivdi3+0xfc>
  8044ff:	74 0b                	je     80450c <__udivdi3+0xf0>
  804501:	89 d8                	mov    %ebx,%eax
  804503:	31 ff                	xor    %edi,%edi
  804505:	e9 58 ff ff ff       	jmp    804462 <__udivdi3+0x46>
  80450a:	66 90                	xchg   %ax,%ax
  80450c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804510:	89 f9                	mov    %edi,%ecx
  804512:	d3 e2                	shl    %cl,%edx
  804514:	39 c2                	cmp    %eax,%edx
  804516:	73 e9                	jae    804501 <__udivdi3+0xe5>
  804518:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80451b:	31 ff                	xor    %edi,%edi
  80451d:	e9 40 ff ff ff       	jmp    804462 <__udivdi3+0x46>
  804522:	66 90                	xchg   %ax,%ax
  804524:	31 c0                	xor    %eax,%eax
  804526:	e9 37 ff ff ff       	jmp    804462 <__udivdi3+0x46>
  80452b:	90                   	nop

0080452c <__umoddi3>:
  80452c:	55                   	push   %ebp
  80452d:	57                   	push   %edi
  80452e:	56                   	push   %esi
  80452f:	53                   	push   %ebx
  804530:	83 ec 1c             	sub    $0x1c,%esp
  804533:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804537:	8b 74 24 34          	mov    0x34(%esp),%esi
  80453b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80453f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804543:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804547:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80454b:	89 f3                	mov    %esi,%ebx
  80454d:	89 fa                	mov    %edi,%edx
  80454f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804553:	89 34 24             	mov    %esi,(%esp)
  804556:	85 c0                	test   %eax,%eax
  804558:	75 1a                	jne    804574 <__umoddi3+0x48>
  80455a:	39 f7                	cmp    %esi,%edi
  80455c:	0f 86 a2 00 00 00    	jbe    804604 <__umoddi3+0xd8>
  804562:	89 c8                	mov    %ecx,%eax
  804564:	89 f2                	mov    %esi,%edx
  804566:	f7 f7                	div    %edi
  804568:	89 d0                	mov    %edx,%eax
  80456a:	31 d2                	xor    %edx,%edx
  80456c:	83 c4 1c             	add    $0x1c,%esp
  80456f:	5b                   	pop    %ebx
  804570:	5e                   	pop    %esi
  804571:	5f                   	pop    %edi
  804572:	5d                   	pop    %ebp
  804573:	c3                   	ret    
  804574:	39 f0                	cmp    %esi,%eax
  804576:	0f 87 ac 00 00 00    	ja     804628 <__umoddi3+0xfc>
  80457c:	0f bd e8             	bsr    %eax,%ebp
  80457f:	83 f5 1f             	xor    $0x1f,%ebp
  804582:	0f 84 ac 00 00 00    	je     804634 <__umoddi3+0x108>
  804588:	bf 20 00 00 00       	mov    $0x20,%edi
  80458d:	29 ef                	sub    %ebp,%edi
  80458f:	89 fe                	mov    %edi,%esi
  804591:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804595:	89 e9                	mov    %ebp,%ecx
  804597:	d3 e0                	shl    %cl,%eax
  804599:	89 d7                	mov    %edx,%edi
  80459b:	89 f1                	mov    %esi,%ecx
  80459d:	d3 ef                	shr    %cl,%edi
  80459f:	09 c7                	or     %eax,%edi
  8045a1:	89 e9                	mov    %ebp,%ecx
  8045a3:	d3 e2                	shl    %cl,%edx
  8045a5:	89 14 24             	mov    %edx,(%esp)
  8045a8:	89 d8                	mov    %ebx,%eax
  8045aa:	d3 e0                	shl    %cl,%eax
  8045ac:	89 c2                	mov    %eax,%edx
  8045ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045b2:	d3 e0                	shl    %cl,%eax
  8045b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8045b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045bc:	89 f1                	mov    %esi,%ecx
  8045be:	d3 e8                	shr    %cl,%eax
  8045c0:	09 d0                	or     %edx,%eax
  8045c2:	d3 eb                	shr    %cl,%ebx
  8045c4:	89 da                	mov    %ebx,%edx
  8045c6:	f7 f7                	div    %edi
  8045c8:	89 d3                	mov    %edx,%ebx
  8045ca:	f7 24 24             	mull   (%esp)
  8045cd:	89 c6                	mov    %eax,%esi
  8045cf:	89 d1                	mov    %edx,%ecx
  8045d1:	39 d3                	cmp    %edx,%ebx
  8045d3:	0f 82 87 00 00 00    	jb     804660 <__umoddi3+0x134>
  8045d9:	0f 84 91 00 00 00    	je     804670 <__umoddi3+0x144>
  8045df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8045e3:	29 f2                	sub    %esi,%edx
  8045e5:	19 cb                	sbb    %ecx,%ebx
  8045e7:	89 d8                	mov    %ebx,%eax
  8045e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8045ed:	d3 e0                	shl    %cl,%eax
  8045ef:	89 e9                	mov    %ebp,%ecx
  8045f1:	d3 ea                	shr    %cl,%edx
  8045f3:	09 d0                	or     %edx,%eax
  8045f5:	89 e9                	mov    %ebp,%ecx
  8045f7:	d3 eb                	shr    %cl,%ebx
  8045f9:	89 da                	mov    %ebx,%edx
  8045fb:	83 c4 1c             	add    $0x1c,%esp
  8045fe:	5b                   	pop    %ebx
  8045ff:	5e                   	pop    %esi
  804600:	5f                   	pop    %edi
  804601:	5d                   	pop    %ebp
  804602:	c3                   	ret    
  804603:	90                   	nop
  804604:	89 fd                	mov    %edi,%ebp
  804606:	85 ff                	test   %edi,%edi
  804608:	75 0b                	jne    804615 <__umoddi3+0xe9>
  80460a:	b8 01 00 00 00       	mov    $0x1,%eax
  80460f:	31 d2                	xor    %edx,%edx
  804611:	f7 f7                	div    %edi
  804613:	89 c5                	mov    %eax,%ebp
  804615:	89 f0                	mov    %esi,%eax
  804617:	31 d2                	xor    %edx,%edx
  804619:	f7 f5                	div    %ebp
  80461b:	89 c8                	mov    %ecx,%eax
  80461d:	f7 f5                	div    %ebp
  80461f:	89 d0                	mov    %edx,%eax
  804621:	e9 44 ff ff ff       	jmp    80456a <__umoddi3+0x3e>
  804626:	66 90                	xchg   %ax,%ax
  804628:	89 c8                	mov    %ecx,%eax
  80462a:	89 f2                	mov    %esi,%edx
  80462c:	83 c4 1c             	add    $0x1c,%esp
  80462f:	5b                   	pop    %ebx
  804630:	5e                   	pop    %esi
  804631:	5f                   	pop    %edi
  804632:	5d                   	pop    %ebp
  804633:	c3                   	ret    
  804634:	3b 04 24             	cmp    (%esp),%eax
  804637:	72 06                	jb     80463f <__umoddi3+0x113>
  804639:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80463d:	77 0f                	ja     80464e <__umoddi3+0x122>
  80463f:	89 f2                	mov    %esi,%edx
  804641:	29 f9                	sub    %edi,%ecx
  804643:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804647:	89 14 24             	mov    %edx,(%esp)
  80464a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80464e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804652:	8b 14 24             	mov    (%esp),%edx
  804655:	83 c4 1c             	add    $0x1c,%esp
  804658:	5b                   	pop    %ebx
  804659:	5e                   	pop    %esi
  80465a:	5f                   	pop    %edi
  80465b:	5d                   	pop    %ebp
  80465c:	c3                   	ret    
  80465d:	8d 76 00             	lea    0x0(%esi),%esi
  804660:	2b 04 24             	sub    (%esp),%eax
  804663:	19 fa                	sbb    %edi,%edx
  804665:	89 d1                	mov    %edx,%ecx
  804667:	89 c6                	mov    %eax,%esi
  804669:	e9 71 ff ff ff       	jmp    8045df <__umoddi3+0xb3>
  80466e:	66 90                	xchg   %ax,%ax
  804670:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804674:	72 ea                	jb     804660 <__umoddi3+0x134>
  804676:	89 d9                	mov    %ebx,%ecx
  804678:	e9 62 ff ff ff       	jmp    8045df <__umoddi3+0xb3>
