
obj/user/quicksort_leakage:     file format elf32-i386


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
  800031:	e8 c8 05 00 00       	call   8005fe <libmain>
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
  800041:	e8 f8 33 00 00       	call   80343e <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 46 80 00       	push   $0x804680
  80004e:	e8 29 0a 00 00       	call   800a7c <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 46 80 00       	push   $0x804682
  80005e:	e8 19 0a 00 00       	call   800a7c <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 9b 46 80 00       	push   $0x80469b
  80006e:	e8 09 0a 00 00       	call   800a7c <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 46 80 00       	push   $0x804682
  80007e:	e8 f9 09 00 00       	call   800a7c <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 46 80 00       	push   $0x804680
  80008e:	e8 e9 09 00 00       	call   800a7c <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b4 46 80 00       	push   $0x8046b4
  8000a5:	e8 ab 10 00 00       	call   801155 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 ac 16 00 00       	call   80176c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 d4 46 80 00       	push   $0x8046d4
  8000ce:	e8 a9 09 00 00       	call   800a7c <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 f6 46 80 00       	push   $0x8046f6
  8000de:	e8 99 09 00 00       	call   800a7c <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 04 47 80 00       	push   $0x804704
  8000ee:	e8 89 09 00 00       	call   800a7c <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 13 47 80 00       	push   $0x804713
  8000fe:	e8 79 09 00 00       	call   800a7c <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 23 47 80 00       	push   $0x804723
  80010e:	e8 69 09 00 00       	call   800a7c <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 c6 04 00 00       	call   8005e1 <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 97 04 00 00       	call   8005c2 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 8a 04 00 00       	call   8005c2 <cputchar>
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
  80014d:	e8 06 33 00 00       	call   803458 <sys_unlock_cons>

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 e5 1a 00 00       	call   801c46 <malloc>
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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001d5:	e8 64 32 00 00       	call   80343e <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 2c 47 80 00       	push   $0x80472c
  8001e2:	e8 95 08 00 00       	call   800a7c <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 69 32 00 00       	call   803458 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 60 47 80 00       	push   $0x804760
  800211:	6a 51                	push   $0x51
  800213:	68 82 47 80 00       	push   $0x804782
  800218:	e8 91 05 00 00       	call   8007ae <_panic>
		else
		{
			sys_lock_cons();
  80021d:	e8 1c 32 00 00       	call   80343e <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 9c 47 80 00       	push   $0x80479c
  80022a:	e8 4d 08 00 00       	call   800a7c <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 d0 47 80 00       	push   $0x8047d0
  80023a:	e8 3d 08 00 00       	call   800a7c <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 04 48 80 00       	push   $0x804804
  80024a:	e8 2d 08 00 00       	call   800a7c <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 01 32 00 00       	call   803458 <sys_unlock_cons>
		}

		sys_lock_cons();
  800257:	e8 e2 31 00 00       	call   80343e <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 36 48 80 00       	push   $0x804836
  80026a:	e8 0d 08 00 00       	call   800a7c <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 6a 03 00 00       	call   8005e1 <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 3b 03 00 00       	call   8005c2 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 2e 03 00 00       	call   8005c2 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 21 03 00 00       	call   8005c2 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b0:	e8 a3 31 00 00       	call   803458 <sys_unlock_cons>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800501:	75 07                	jne    80050a <InitializeSemiRandom+0x27>
			Repetition = 3;
  800503:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80050a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800511:	eb 1e                	jmp    800531 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800526:	99                   	cltd   
  800527:	f7 7d f8             	idivl  -0x8(%ebp)
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80052e:	ff 45 fc             	incl   -0x4(%ebp)
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800537:	7c da                	jl     800513 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800542:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800550:	eb 42                	jmp    800594 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	99                   	cltd   
  800556:	f7 7d f0             	idivl  -0x10(%ebp)
  800559:	89 d0                	mov    %edx,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 10                	jne    80056f <PrintElements+0x33>
			cprintf("\n");
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 80 46 80 00       	push   $0x804680
  800567:	e8 10 05 00 00       	call   800a7c <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 54 48 80 00       	push   $0x804854
  800589:	e8 ee 04 00 00       	call   800a7c <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800591:	ff 45 f4             	incl   -0xc(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	48                   	dec    %eax
  800598:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80059b:	7f b5                	jg     800552 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	50                   	push   %eax
  8005b2:	68 59 48 80 00       	push   $0x804859
  8005b7:	e8 c0 04 00 00       	call   800a7c <cprintf>
  8005bc:	83 c4 10             	add    $0x10,%esp

}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005ce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	50                   	push   %eax
  8005d6:	e8 ab 2f 00 00       	call   803586 <sys_cputc>
  8005db:	83 c4 10             	add    $0x10,%esp
}
  8005de:	90                   	nop
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <getchar>:


int
getchar(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005e7:	e8 39 2e 00 00       	call   803425 <sys_cgetc>
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <iscons>:

int iscons(int fdnum)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fc:	5d                   	pop    %ebp
  8005fd:	c3                   	ret    

008005fe <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	57                   	push   %edi
  800602:	56                   	push   %esi
  800603:	53                   	push   %ebx
  800604:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800607:	e8 ab 30 00 00       	call   8036b7 <sys_getenvindex>
  80060c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80060f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800612:	89 d0                	mov    %edx,%eax
  800614:	c1 e0 03             	shl    $0x3,%eax
  800617:	01 d0                	add    %edx,%eax
  800619:	c1 e0 02             	shl    $0x2,%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800625:	01 d0                	add    %edx,%eax
  800627:	c1 e0 03             	shl    $0x3,%eax
  80062a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80062f:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800634:	a1 24 60 80 00       	mov    0x806024,%eax
  800639:	8a 40 20             	mov    0x20(%eax),%al
  80063c:	84 c0                	test   %al,%al
  80063e:	74 0d                	je     80064d <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800640:	a1 24 60 80 00       	mov    0x806024,%eax
  800645:	83 c0 20             	add    $0x20,%eax
  800648:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80064d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800651:	7e 0a                	jle    80065d <libmain+0x5f>
		binaryname = argv[0];
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 08             	pushl  0x8(%ebp)
  800666:	e8 cd f9 ff ff       	call   800038 <_main>
  80066b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80066e:	a1 00 60 80 00       	mov    0x806000,%eax
  800673:	85 c0                	test   %eax,%eax
  800675:	0f 84 01 01 00 00    	je     80077c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80067b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800681:	bb 58 49 80 00       	mov    $0x804958,%ebx
  800686:	ba 0e 00 00 00       	mov    $0xe,%edx
  80068b:	89 c7                	mov    %eax,%edi
  80068d:	89 de                	mov    %ebx,%esi
  80068f:	89 d1                	mov    %edx,%ecx
  800691:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800693:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800696:	b9 56 00 00 00       	mov    $0x56,%ecx
  80069b:	b0 00                	mov    $0x0,%al
  80069d:	89 d7                	mov    %edx,%edi
  80069f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8006a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8006a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	50                   	push   %eax
  8006af:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006b5:	50                   	push   %eax
  8006b6:	e8 32 32 00 00       	call   8038ed <sys_utilities>
  8006bb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8006be:	e8 7b 2d 00 00       	call   80343e <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	68 78 48 80 00       	push   $0x804878
  8006cb:	e8 ac 03 00 00       	call   800a7c <cprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8006d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	74 18                	je     8006f2 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8006da:	e8 2c 32 00 00       	call   80390b <sys_get_optimal_num_faults>
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	50                   	push   %eax
  8006e3:	68 a0 48 80 00       	push   $0x8048a0
  8006e8:	e8 8f 03 00 00       	call   800a7c <cprintf>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	eb 59                	jmp    80074b <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006f2:	a1 24 60 80 00       	mov    0x806024,%eax
  8006f7:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8006fd:	a1 24 60 80 00       	mov    0x806024,%eax
  800702:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	52                   	push   %edx
  80070c:	50                   	push   %eax
  80070d:	68 c4 48 80 00       	push   $0x8048c4
  800712:	e8 65 03 00 00       	call   800a7c <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80071a:	a1 24 60 80 00       	mov    0x806024,%eax
  80071f:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800725:	a1 24 60 80 00       	mov    0x806024,%eax
  80072a:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800730:	a1 24 60 80 00       	mov    0x806024,%eax
  800735:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	68 ec 48 80 00       	push   $0x8048ec
  800743:	e8 34 03 00 00       	call   800a7c <cprintf>
  800748:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80074b:	a1 24 60 80 00       	mov    0x806024,%eax
  800750:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	50                   	push   %eax
  80075a:	68 44 49 80 00       	push   $0x804944
  80075f:	e8 18 03 00 00       	call   800a7c <cprintf>
  800764:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 78 48 80 00       	push   $0x804878
  80076f:	e8 08 03 00 00       	call   800a7c <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800777:	e8 dc 2c 00 00       	call   803458 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80077c:	e8 1f 00 00 00       	call   8007a0 <exit>
}
  800781:	90                   	nop
  800782:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800785:	5b                   	pop    %ebx
  800786:	5e                   	pop    %esi
  800787:	5f                   	pop    %edi
  800788:	5d                   	pop    %ebp
  800789:	c3                   	ret    

0080078a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	6a 00                	push   $0x0
  800795:	e8 e9 2e 00 00       	call   803683 <sys_destroy_env>
  80079a:	83 c4 10             	add    $0x10,%esp
}
  80079d:	90                   	nop
  80079e:	c9                   	leave  
  80079f:	c3                   	ret    

008007a0 <exit>:

void
exit(void)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007a6:	e8 3e 2f 00 00       	call   8036e9 <sys_exit_env>
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007bd:	a1 38 61 83 00       	mov    0x836138,%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 16                	je     8007dc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007c6:	a1 38 61 83 00       	mov    0x836138,%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	50                   	push   %eax
  8007cf:	68 bc 49 80 00       	push   $0x8049bc
  8007d4:	e8 a3 02 00 00       	call   800a7c <cprintf>
  8007d9:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8007dc:	a1 04 60 80 00       	mov    0x806004,%eax
  8007e1:	83 ec 0c             	sub    $0xc,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	ff 75 08             	pushl  0x8(%ebp)
  8007ea:	50                   	push   %eax
  8007eb:	68 c4 49 80 00       	push   $0x8049c4
  8007f0:	6a 74                	push   $0x74
  8007f2:	e8 b2 02 00 00       	call   800aa9 <cprintf_colored>
  8007f7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 f4             	pushl  -0xc(%ebp)
  800803:	50                   	push   %eax
  800804:	e8 04 02 00 00       	call   800a0d <vcprintf>
  800809:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	6a 00                	push   $0x0
  800811:	68 ec 49 80 00       	push   $0x8049ec
  800816:	e8 f2 01 00 00       	call   800a0d <vcprintf>
  80081b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80081e:	e8 7d ff ff ff       	call   8007a0 <exit>

	// should not return here
	while (1) ;
  800823:	eb fe                	jmp    800823 <_panic+0x75>

00800825 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80082b:	a1 24 60 80 00       	mov    0x806024,%eax
  800830:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800836:	8b 45 0c             	mov    0xc(%ebp),%eax
  800839:	39 c2                	cmp    %eax,%edx
  80083b:	74 14                	je     800851 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	68 f0 49 80 00       	push   $0x8049f0
  800845:	6a 26                	push   $0x26
  800847:	68 3c 4a 80 00       	push   $0x804a3c
  80084c:	e8 5d ff ff ff       	call   8007ae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800858:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80085f:	e9 c5 00 00 00       	jmp    800929 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800867:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	01 d0                	add    %edx,%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	85 c0                	test   %eax,%eax
  800877:	75 08                	jne    800881 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800879:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80087c:	e9 a5 00 00 00       	jmp    800926 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800881:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800888:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80088f:	eb 69                	jmp    8008fa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800891:	a1 24 60 80 00       	mov    0x806024,%eax
  800896:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80089c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089f:	89 d0                	mov    %edx,%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	01 d0                	add    %edx,%eax
  8008a5:	c1 e0 03             	shl    $0x3,%eax
  8008a8:	01 c8                	add    %ecx,%eax
  8008aa:	8a 40 04             	mov    0x4(%eax),%al
  8008ad:	84 c0                	test   %al,%al
  8008af:	75 46                	jne    8008f7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b1:	a1 24 60 80 00       	mov    0x806024,%eax
  8008b6:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8008bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008bf:	89 d0                	mov    %edx,%eax
  8008c1:	01 c0                	add    %eax,%eax
  8008c3:	01 d0                	add    %edx,%eax
  8008c5:	c1 e0 03             	shl    $0x3,%eax
  8008c8:	01 c8                	add    %ecx,%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	01 c8                	add    %ecx,%eax
  8008e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	75 09                	jne    8008f7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008f5:	eb 15                	jmp    80090c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008f7:	ff 45 e8             	incl   -0x18(%ebp)
  8008fa:	a1 24 60 80 00       	mov    0x806024,%eax
  8008ff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800908:	39 c2                	cmp    %eax,%edx
  80090a:	77 85                	ja     800891 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800910:	75 14                	jne    800926 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800912:	83 ec 04             	sub    $0x4,%esp
  800915:	68 48 4a 80 00       	push   $0x804a48
  80091a:	6a 3a                	push   $0x3a
  80091c:	68 3c 4a 80 00       	push   $0x804a3c
  800921:	e8 88 fe ff ff       	call   8007ae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800926:	ff 45 f0             	incl   -0x10(%ebp)
  800929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80092f:	0f 8c 2f ff ff ff    	jl     800864 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800935:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800943:	eb 26                	jmp    80096b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800945:	a1 24 60 80 00       	mov    0x806024,%eax
  80094a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800950:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800953:	89 d0                	mov    %edx,%eax
  800955:	01 c0                	add    %eax,%eax
  800957:	01 d0                	add    %edx,%eax
  800959:	c1 e0 03             	shl    $0x3,%eax
  80095c:	01 c8                	add    %ecx,%eax
  80095e:	8a 40 04             	mov    0x4(%eax),%al
  800961:	3c 01                	cmp    $0x1,%al
  800963:	75 03                	jne    800968 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800965:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800968:	ff 45 e0             	incl   -0x20(%ebp)
  80096b:	a1 24 60 80 00       	mov    0x806024,%eax
  800970:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 c8                	ja     800945 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 9c 4a 80 00       	push   $0x804a9c
  80098d:	6a 44                	push   $0x44
  80098f:	68 3c 4a 80 00       	push   $0x804a3c
  800994:	e8 15 fe ff ff       	call   8007ae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	89 0a                	mov    %ecx,(%edx)
  8009b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b3:	88 d1                	mov    %dl,%cl
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c6:	75 30                	jne    8009f8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009c8:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  8009ce:	a0 64 e0 81 00       	mov    0x81e064,%al
  8009d3:	0f b6 c0             	movzbl %al,%eax
  8009d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d9:	8b 09                	mov    (%ecx),%ecx
  8009db:	89 cb                	mov    %ecx,%ebx
  8009dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e0:	83 c1 08             	add    $0x8,%ecx
  8009e3:	52                   	push   %edx
  8009e4:	50                   	push   %eax
  8009e5:	53                   	push   %ebx
  8009e6:	51                   	push   %ecx
  8009e7:	e8 0e 2a 00 00       	call   8033fa <sys_cputs>
  8009ec:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	8b 40 04             	mov    0x4(%eax),%eax
  8009fe:	8d 50 01             	lea    0x1(%eax),%edx
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a07:	90                   	nop
  800a08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a16:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a1d:	00 00 00 
	b.cnt = 0;
  800a20:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a27:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	68 9c 09 80 00       	push   $0x80099c
  800a3c:	e8 5a 02 00 00       	call   800c9b <vprintfmt>
  800a41:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a44:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800a4a:	a0 64 e0 81 00       	mov    0x81e064,%al
  800a4f:	0f b6 c0             	movzbl %al,%eax
  800a52:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a58:	52                   	push   %edx
  800a59:	50                   	push   %eax
  800a5a:	51                   	push   %ecx
  800a5b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a61:	83 c0 08             	add    $0x8,%eax
  800a64:	50                   	push   %eax
  800a65:	e8 90 29 00 00       	call   8033fa <sys_cputs>
  800a6a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a6d:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800a74:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a82:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800a89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 f4             	pushl  -0xc(%ebp)
  800a98:	50                   	push   %eax
  800a99:	e8 6f ff ff ff       	call   800a0d <vcprintf>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800aaf:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	c1 e0 08             	shl    $0x8,%eax
  800abc:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800ac1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad3:	50                   	push   %eax
  800ad4:	e8 34 ff ff ff       	call   800a0d <vcprintf>
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800adf:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800ae6:	07 00 00 

	return cnt;
  800ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800af4:	e8 45 29 00 00       	call   80343e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800af9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 f4             	pushl  -0xc(%ebp)
  800b08:	50                   	push   %eax
  800b09:	e8 ff fe ff ff       	call   800a0d <vcprintf>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b14:	e8 3f 29 00 00       	call   803458 <sys_unlock_cons>
	return cnt;
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	53                   	push   %ebx
  800b22:	83 ec 14             	sub    $0x14,%esp
  800b25:	8b 45 10             	mov    0x10(%ebp),%eax
  800b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b31:	8b 45 18             	mov    0x18(%ebp),%eax
  800b34:	ba 00 00 00 00       	mov    $0x0,%edx
  800b39:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b3c:	77 55                	ja     800b93 <printnum+0x75>
  800b3e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b41:	72 05                	jb     800b48 <printnum+0x2a>
  800b43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b46:	77 4b                	ja     800b93 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b48:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b4b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b4e:	8b 45 18             	mov    0x18(%ebp),%eax
  800b51:	ba 00 00 00 00       	mov    $0x0,%edx
  800b56:	52                   	push   %edx
  800b57:	50                   	push   %eax
  800b58:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b5e:	e8 ad 38 00 00       	call   804410 <__udivdi3>
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	ff 75 20             	pushl  0x20(%ebp)
  800b6c:	53                   	push   %ebx
  800b6d:	ff 75 18             	pushl  0x18(%ebp)
  800b70:	52                   	push   %edx
  800b71:	50                   	push   %eax
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	e8 a1 ff ff ff       	call   800b1e <printnum>
  800b7d:	83 c4 20             	add    $0x20,%esp
  800b80:	eb 1a                	jmp    800b9c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	ff 75 20             	pushl  0x20(%ebp)
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b93:	ff 4d 1c             	decl   0x1c(%ebp)
  800b96:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b9a:	7f e6                	jg     800b82 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b9c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800baa:	53                   	push   %ebx
  800bab:	51                   	push   %ecx
  800bac:	52                   	push   %edx
  800bad:	50                   	push   %eax
  800bae:	e8 6d 39 00 00       	call   804520 <__umoddi3>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	05 14 4d 80 00       	add    $0x804d14,%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	0f be c0             	movsbl %al,%eax
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	50                   	push   %eax
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	ff d0                	call   *%eax
  800bcc:	83 c4 10             	add    $0x10,%esp
}
  800bcf:	90                   	nop
  800bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bd8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bdc:	7e 1c                	jle    800bfa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	8d 50 08             	lea    0x8(%eax),%edx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 10                	mov    %edx,(%eax)
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	83 e8 08             	sub    $0x8,%eax
  800bf3:	8b 50 04             	mov    0x4(%eax),%edx
  800bf6:	8b 00                	mov    (%eax),%eax
  800bf8:	eb 40                	jmp    800c3a <getuint+0x65>
	else if (lflag)
  800bfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfe:	74 1e                	je     800c1e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8b 00                	mov    (%eax),%eax
  800c05:	8d 50 04             	lea    0x4(%eax),%edx
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	89 10                	mov    %edx,(%eax)
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	83 e8 04             	sub    $0x4,%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1c:	eb 1c                	jmp    800c3a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	8d 50 04             	lea    0x4(%eax),%edx
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 10                	mov    %edx,(%eax)
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c3f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c43:	7e 1c                	jle    800c61 <getint+0x25>
		return va_arg(*ap, long long);
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	8d 50 08             	lea    0x8(%eax),%edx
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	89 10                	mov    %edx,(%eax)
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	83 e8 08             	sub    $0x8,%eax
  800c5a:	8b 50 04             	mov    0x4(%eax),%edx
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	eb 38                	jmp    800c99 <getint+0x5d>
	else if (lflag)
  800c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c65:	74 1a                	je     800c81 <getint+0x45>
		return va_arg(*ap, long);
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	8d 50 04             	lea    0x4(%eax),%edx
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 10                	mov    %edx,(%eax)
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8b 00                	mov    (%eax),%eax
  800c79:	83 e8 04             	sub    $0x4,%eax
  800c7c:	8b 00                	mov    (%eax),%eax
  800c7e:	99                   	cltd   
  800c7f:	eb 18                	jmp    800c99 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8b 00                	mov    (%eax),%eax
  800c86:	8d 50 04             	lea    0x4(%eax),%edx
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 10                	mov    %edx,(%eax)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8b 00                	mov    (%eax),%eax
  800c93:	83 e8 04             	sub    $0x4,%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	99                   	cltd   
}
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca3:	eb 17                	jmp    800cbc <vprintfmt+0x21>
			if (ch == '\0')
  800ca5:	85 db                	test   %ebx,%ebx
  800ca7:	0f 84 c1 03 00 00    	je     80106e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cad:	83 ec 08             	sub    $0x8,%esp
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	53                   	push   %ebx
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	ff d0                	call   *%eax
  800cb9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbf:	8d 50 01             	lea    0x1(%eax),%edx
  800cc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d8             	movzbl %al,%ebx
  800cca:	83 fb 25             	cmp    $0x25,%ebx
  800ccd:	75 d6                	jne    800ca5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ccf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cd3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cda:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ce1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ce8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d8             	movzbl %al,%ebx
  800cfd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d00:	83 f8 5b             	cmp    $0x5b,%eax
  800d03:	0f 87 3d 03 00 00    	ja     801046 <vprintfmt+0x3ab>
  800d09:	8b 04 85 38 4d 80 00 	mov    0x804d38(,%eax,4),%eax
  800d10:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d12:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d16:	eb d7                	jmp    800cef <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d18:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d1c:	eb d1                	jmp    800cef <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d28:	89 d0                	mov    %edx,%eax
  800d2a:	c1 e0 02             	shl    $0x2,%eax
  800d2d:	01 d0                	add    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d8                	add    %ebx,%eax
  800d33:	83 e8 30             	sub    $0x30,%eax
  800d36:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d41:	83 fb 2f             	cmp    $0x2f,%ebx
  800d44:	7e 3e                	jle    800d84 <vprintfmt+0xe9>
  800d46:	83 fb 39             	cmp    $0x39,%ebx
  800d49:	7f 39                	jg     800d84 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d4b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d4e:	eb d5                	jmp    800d25 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d50:	8b 45 14             	mov    0x14(%ebp),%eax
  800d53:	83 c0 04             	add    $0x4,%eax
  800d56:	89 45 14             	mov    %eax,0x14(%ebp)
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	83 e8 04             	sub    $0x4,%eax
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d64:	eb 1f                	jmp    800d85 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6a:	79 83                	jns    800cef <vprintfmt+0x54>
				width = 0;
  800d6c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d73:	e9 77 ff ff ff       	jmp    800cef <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d78:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d7f:	e9 6b ff ff ff       	jmp    800cef <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d84:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d89:	0f 89 60 ff ff ff    	jns    800cef <vprintfmt+0x54>
				width = precision, precision = -1;
  800d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d95:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d9c:	e9 4e ff ff ff       	jmp    800cef <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800da1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800da4:	e9 46 ff ff ff       	jmp    800cef <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800da9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 14             	mov    %eax,0x14(%ebp)
  800db2:	8b 45 14             	mov    0x14(%ebp),%eax
  800db5:	83 e8 04             	sub    $0x4,%eax
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	50                   	push   %eax
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
			break;
  800dc9:	e9 9b 02 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dce:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd1:	83 c0 04             	add    $0x4,%eax
  800dd4:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dda:	83 e8 04             	sub    $0x4,%eax
  800ddd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ddf:	85 db                	test   %ebx,%ebx
  800de1:	79 02                	jns    800de5 <vprintfmt+0x14a>
				err = -err;
  800de3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800de5:	83 fb 64             	cmp    $0x64,%ebx
  800de8:	7f 0b                	jg     800df5 <vprintfmt+0x15a>
  800dea:	8b 34 9d 80 4b 80 00 	mov    0x804b80(,%ebx,4),%esi
  800df1:	85 f6                	test   %esi,%esi
  800df3:	75 19                	jne    800e0e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800df5:	53                   	push   %ebx
  800df6:	68 25 4d 80 00       	push   $0x804d25
  800dfb:	ff 75 0c             	pushl  0xc(%ebp)
  800dfe:	ff 75 08             	pushl  0x8(%ebp)
  800e01:	e8 70 02 00 00       	call   801076 <printfmt>
  800e06:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e09:	e9 5b 02 00 00       	jmp    801069 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e0e:	56                   	push   %esi
  800e0f:	68 2e 4d 80 00       	push   $0x804d2e
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	ff 75 08             	pushl  0x8(%ebp)
  800e1a:	e8 57 02 00 00       	call   801076 <printfmt>
  800e1f:	83 c4 10             	add    $0x10,%esp
			break;
  800e22:	e9 42 02 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e27:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2a:	83 c0 04             	add    $0x4,%eax
  800e2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e30:	8b 45 14             	mov    0x14(%ebp),%eax
  800e33:	83 e8 04             	sub    $0x4,%eax
  800e36:	8b 30                	mov    (%eax),%esi
  800e38:	85 f6                	test   %esi,%esi
  800e3a:	75 05                	jne    800e41 <vprintfmt+0x1a6>
				p = "(null)";
  800e3c:	be 31 4d 80 00       	mov    $0x804d31,%esi
			if (width > 0 && padc != '-')
  800e41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e45:	7e 6d                	jle    800eb4 <vprintfmt+0x219>
  800e47:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e4b:	74 67                	je     800eb4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	50                   	push   %eax
  800e54:	56                   	push   %esi
  800e55:	e8 26 05 00 00       	call   801380 <strnlen>
  800e5a:	83 c4 10             	add    $0x10,%esp
  800e5d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e60:	eb 16                	jmp    800e78 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e62:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	ff 75 0c             	pushl  0xc(%ebp)
  800e6c:	50                   	push   %eax
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	ff d0                	call   *%eax
  800e72:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e75:	ff 4d e4             	decl   -0x1c(%ebp)
  800e78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7c:	7f e4                	jg     800e62 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e7e:	eb 34                	jmp    800eb4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e80:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e84:	74 1c                	je     800ea2 <vprintfmt+0x207>
  800e86:	83 fb 1f             	cmp    $0x1f,%ebx
  800e89:	7e 05                	jle    800e90 <vprintfmt+0x1f5>
  800e8b:	83 fb 7e             	cmp    $0x7e,%ebx
  800e8e:	7e 12                	jle    800ea2 <vprintfmt+0x207>
					putch('?', putdat);
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	6a 3f                	push   $0x3f
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	ff d0                	call   *%eax
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	eb 0f                	jmp    800eb1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	ff 75 0c             	pushl  0xc(%ebp)
  800ea8:	53                   	push   %ebx
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb1:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb4:	89 f0                	mov    %esi,%eax
  800eb6:	8d 70 01             	lea    0x1(%eax),%esi
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f be d8             	movsbl %al,%ebx
  800ebe:	85 db                	test   %ebx,%ebx
  800ec0:	74 24                	je     800ee6 <vprintfmt+0x24b>
  800ec2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ec6:	78 b8                	js     800e80 <vprintfmt+0x1e5>
  800ec8:	ff 4d e0             	decl   -0x20(%ebp)
  800ecb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ecf:	79 af                	jns    800e80 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ed1:	eb 13                	jmp    800ee6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	ff 75 0c             	pushl  0xc(%ebp)
  800ed9:	6a 20                	push   $0x20
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	ff d0                	call   *%eax
  800ee0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eea:	7f e7                	jg     800ed3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800eec:	e9 78 01 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 3c fd ff ff       	call   800c3c <getint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0f:	85 d2                	test   %edx,%edx
  800f11:	79 23                	jns    800f36 <vprintfmt+0x29b>
				putch('-', putdat);
  800f13:	83 ec 08             	sub    $0x8,%esp
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	6a 2d                	push   $0x2d
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	ff d0                	call   *%eax
  800f20:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f29:	f7 d8                	neg    %eax
  800f2b:	83 d2 00             	adc    $0x0,%edx
  800f2e:	f7 da                	neg    %edx
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3d:	e9 bc 00 00 00       	jmp    800ffe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	ff 75 e8             	pushl  -0x18(%ebp)
  800f48:	8d 45 14             	lea    0x14(%ebp),%eax
  800f4b:	50                   	push   %eax
  800f4c:	e8 84 fc ff ff       	call   800bd5 <getuint>
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f61:	e9 98 00 00 00       	jmp    800ffe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	6a 58                	push   $0x58
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	ff d0                	call   *%eax
  800f73:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 58                	push   $0x58
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f86:	83 ec 08             	sub    $0x8,%esp
  800f89:	ff 75 0c             	pushl  0xc(%ebp)
  800f8c:	6a 58                	push   $0x58
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	ff d0                	call   *%eax
  800f93:	83 c4 10             	add    $0x10,%esp
			break;
  800f96:	e9 ce 00 00 00       	jmp    801069 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	6a 30                	push   $0x30
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	6a 78                	push   $0x78
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	ff d0                	call   *%eax
  800fb8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbe:	83 c0 04             	add    $0x4,%eax
  800fc1:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc7:	83 e8 04             	sub    $0x4,%eax
  800fca:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fd6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fdd:	eb 1f                	jmp    800ffe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe5:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe8:	50                   	push   %eax
  800fe9:	e8 e7 fb ff ff       	call   800bd5 <getuint>
  800fee:	83 c4 10             	add    $0x10,%esp
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ff7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ffe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801005:	83 ec 04             	sub    $0x4,%esp
  801008:	52                   	push   %edx
  801009:	ff 75 e4             	pushl  -0x1c(%ebp)
  80100c:	50                   	push   %eax
  80100d:	ff 75 f4             	pushl  -0xc(%ebp)
  801010:	ff 75 f0             	pushl  -0x10(%ebp)
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	ff 75 08             	pushl  0x8(%ebp)
  801019:	e8 00 fb ff ff       	call   800b1e <printnum>
  80101e:	83 c4 20             	add    $0x20,%esp
			break;
  801021:	eb 46                	jmp    801069 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	ff 75 0c             	pushl  0xc(%ebp)
  801029:	53                   	push   %ebx
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	ff d0                	call   *%eax
  80102f:	83 c4 10             	add    $0x10,%esp
			break;
  801032:	eb 35                	jmp    801069 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801034:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  80103b:	eb 2c                	jmp    801069 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80103d:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  801044:	eb 23                	jmp    801069 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	ff 75 0c             	pushl  0xc(%ebp)
  80104c:	6a 25                	push   $0x25
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	ff d0                	call   *%eax
  801053:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801056:	ff 4d 10             	decl   0x10(%ebp)
  801059:	eb 03                	jmp    80105e <vprintfmt+0x3c3>
  80105b:	ff 4d 10             	decl   0x10(%ebp)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	48                   	dec    %eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 25                	cmp    $0x25,%al
  801066:	75 f3                	jne    80105b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801068:	90                   	nop
		}
	}
  801069:	e9 35 fc ff ff       	jmp    800ca3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80106e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80106f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80107c:	8d 45 10             	lea    0x10(%ebp),%eax
  80107f:	83 c0 04             	add    $0x4,%eax
  801082:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	ff 75 f4             	pushl  -0xc(%ebp)
  80108b:	50                   	push   %eax
  80108c:	ff 75 0c             	pushl  0xc(%ebp)
  80108f:	ff 75 08             	pushl  0x8(%ebp)
  801092:	e8 04 fc ff ff       	call   800c9b <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80109a:	90                   	nop
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	8b 40 08             	mov    0x8(%eax),%eax
  8010a6:	8d 50 01             	lea    0x1(%eax),%edx
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	8b 10                	mov    (%eax),%edx
  8010b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b7:	8b 40 04             	mov    0x4(%eax),%eax
  8010ba:	39 c2                	cmp    %eax,%edx
  8010bc:	73 12                	jae    8010d0 <sprintputch+0x33>
		*b->buf++ = ch;
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	8b 00                	mov    (%eax),%eax
  8010c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c9:	89 0a                	mov    %ecx,(%edx)
  8010cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ce:	88 10                	mov    %dl,(%eax)
}
  8010d0:	90                   	nop
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f8:	74 06                	je     801100 <vsnprintf+0x2d>
  8010fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fe:	7f 07                	jg     801107 <vsnprintf+0x34>
		return -E_INVAL;
  801100:	b8 03 00 00 00       	mov    $0x3,%eax
  801105:	eb 20                	jmp    801127 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801107:	ff 75 14             	pushl  0x14(%ebp)
  80110a:	ff 75 10             	pushl  0x10(%ebp)
  80110d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801110:	50                   	push   %eax
  801111:	68 9d 10 80 00       	push   $0x80109d
  801116:	e8 80 fb ff ff       	call   800c9b <vprintfmt>
  80111b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80111e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801121:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    

00801129 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80112f:	8d 45 10             	lea    0x10(%ebp),%eax
  801132:	83 c0 04             	add    $0x4,%eax
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	ff 75 f4             	pushl  -0xc(%ebp)
  80113e:	50                   	push   %eax
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	e8 89 ff ff ff       	call   8010d3 <vsnprintf>
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801150:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80115b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115f:	74 13                	je     801174 <readline+0x1f>
		cprintf("%s", prompt);
  801161:	83 ec 08             	sub    $0x8,%esp
  801164:	ff 75 08             	pushl  0x8(%ebp)
  801167:	68 a8 4e 80 00       	push   $0x804ea8
  80116c:	e8 0b f9 ff ff       	call   800a7c <cprintf>
  801171:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	6a 00                	push   $0x0
  801180:	e8 6f f4 ff ff       	call   8005f4 <iscons>
  801185:	83 c4 10             	add    $0x10,%esp
  801188:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80118b:	e8 51 f4 ff ff       	call   8005e1 <getchar>
  801190:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801193:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801197:	79 22                	jns    8011bb <readline+0x66>
			if (c != -E_EOF)
  801199:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80119d:	0f 84 ad 00 00 00    	je     801250 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a9:	68 ab 4e 80 00       	push   $0x804eab
  8011ae:	e8 c9 f8 ff ff       	call   800a7c <cprintf>
  8011b3:	83 c4 10             	add    $0x10,%esp
			break;
  8011b6:	e9 95 00 00 00       	jmp    801250 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011bb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011bf:	7e 34                	jle    8011f5 <readline+0xa0>
  8011c1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011c8:	7f 2b                	jg     8011f5 <readline+0xa0>
			if (echoing)
  8011ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011ce:	74 0e                	je     8011de <readline+0x89>
				cputchar(c);
  8011d0:	83 ec 0c             	sub    $0xc,%esp
  8011d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8011d6:	e8 e7 f3 ff ff       	call   8005c2 <cputchar>
  8011db:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e1:	8d 50 01             	lea    0x1(%eax),%edx
  8011e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011e7:	89 c2                	mov    %eax,%edx
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	01 d0                	add    %edx,%eax
  8011ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f1:	88 10                	mov    %dl,(%eax)
  8011f3:	eb 56                	jmp    80124b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011f5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011f9:	75 1f                	jne    80121a <readline+0xc5>
  8011fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011ff:	7e 19                	jle    80121a <readline+0xc5>
			if (echoing)
  801201:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801205:	74 0e                	je     801215 <readline+0xc0>
				cputchar(c);
  801207:	83 ec 0c             	sub    $0xc,%esp
  80120a:	ff 75 ec             	pushl  -0x14(%ebp)
  80120d:	e8 b0 f3 ff ff       	call   8005c2 <cputchar>
  801212:	83 c4 10             	add    $0x10,%esp

			i--;
  801215:	ff 4d f4             	decl   -0xc(%ebp)
  801218:	eb 31                	jmp    80124b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80121a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80121e:	74 0a                	je     80122a <readline+0xd5>
  801220:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801224:	0f 85 61 ff ff ff    	jne    80118b <readline+0x36>
			if (echoing)
  80122a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80122e:	74 0e                	je     80123e <readline+0xe9>
				cputchar(c);
  801230:	83 ec 0c             	sub    $0xc,%esp
  801233:	ff 75 ec             	pushl  -0x14(%ebp)
  801236:	e8 87 f3 ff ff       	call   8005c2 <cputchar>
  80123b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80123e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801249:	eb 06                	jmp    801251 <readline+0xfc>
		}
	}
  80124b:	e9 3b ff ff ff       	jmp    80118b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801250:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801251:	90                   	nop
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80125a:	e8 df 21 00 00       	call   80343e <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80125f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801263:	74 13                	je     801278 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801265:	83 ec 08             	sub    $0x8,%esp
  801268:	ff 75 08             	pushl  0x8(%ebp)
  80126b:	68 a8 4e 80 00       	push   $0x804ea8
  801270:	e8 07 f8 ff ff       	call   800a7c <cprintf>
  801275:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801278:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80127f:	83 ec 0c             	sub    $0xc,%esp
  801282:	6a 00                	push   $0x0
  801284:	e8 6b f3 ff ff       	call   8005f4 <iscons>
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80128f:	e8 4d f3 ff ff       	call   8005e1 <getchar>
  801294:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801297:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80129b:	79 22                	jns    8012bf <atomic_readline+0x6b>
				if (c != -E_EOF)
  80129d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012a1:	0f 84 ad 00 00 00    	je     801354 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012a7:	83 ec 08             	sub    $0x8,%esp
  8012aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ad:	68 ab 4e 80 00       	push   $0x804eab
  8012b2:	e8 c5 f7 ff ff       	call   800a7c <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
				break;
  8012ba:	e9 95 00 00 00       	jmp    801354 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012bf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012c3:	7e 34                	jle    8012f9 <atomic_readline+0xa5>
  8012c5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012cc:	7f 2b                	jg     8012f9 <atomic_readline+0xa5>
				if (echoing)
  8012ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012d2:	74 0e                	je     8012e2 <atomic_readline+0x8e>
					cputchar(c);
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8012da:	e8 e3 f2 ff ff       	call   8005c2 <cputchar>
  8012df:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8012e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e5:	8d 50 01             	lea    0x1(%eax),%edx
  8012e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012eb:	89 c2                	mov    %eax,%edx
  8012ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f5:	88 10                	mov    %dl,(%eax)
  8012f7:	eb 56                	jmp    80134f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012f9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012fd:	75 1f                	jne    80131e <atomic_readline+0xca>
  8012ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801303:	7e 19                	jle    80131e <atomic_readline+0xca>
				if (echoing)
  801305:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801309:	74 0e                	je     801319 <atomic_readline+0xc5>
					cputchar(c);
  80130b:	83 ec 0c             	sub    $0xc,%esp
  80130e:	ff 75 ec             	pushl  -0x14(%ebp)
  801311:	e8 ac f2 ff ff       	call   8005c2 <cputchar>
  801316:	83 c4 10             	add    $0x10,%esp
				i--;
  801319:	ff 4d f4             	decl   -0xc(%ebp)
  80131c:	eb 31                	jmp    80134f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80131e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801322:	74 0a                	je     80132e <atomic_readline+0xda>
  801324:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801328:	0f 85 61 ff ff ff    	jne    80128f <atomic_readline+0x3b>
				if (echoing)
  80132e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801332:	74 0e                	je     801342 <atomic_readline+0xee>
					cputchar(c);
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	ff 75 ec             	pushl  -0x14(%ebp)
  80133a:	e8 83 f2 ff ff       	call   8005c2 <cputchar>
  80133f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	01 d0                	add    %edx,%eax
  80134a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80134d:	eb 06                	jmp    801355 <atomic_readline+0x101>
			}
		}
  80134f:	e9 3b ff ff ff       	jmp    80128f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801354:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801355:	e8 fe 20 00 00       	call   803458 <sys_unlock_cons>
}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801557:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80155b:	76 63                	jbe    8015c0 <memset+0x75>
		uint64 data_block = c;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	99                   	cltd   
  801561:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801564:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801571:	c1 e0 08             	shl    $0x8,%eax
  801574:	09 45 f0             	or     %eax,-0x10(%ebp)
  801577:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801580:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801584:	c1 e0 10             	shl    $0x10,%eax
  801587:	09 45 f0             	or     %eax,-0x10(%ebp)
  80158a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80158d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801593:	89 c2                	mov    %eax,%edx
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
  80159a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80159d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8015a0:	eb 18                	jmp    8015ba <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8015a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015a5:	8d 41 08             	lea    0x8(%ecx),%eax
  8015a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b1:	89 01                	mov    %eax,(%ecx)
  8015b3:	89 51 04             	mov    %edx,0x4(%ecx)
  8015b6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8015ba:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015be:	77 e2                	ja     8015a2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8015c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c4:	74 23                	je     8015e9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8015c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015cc:	eb 0e                	jmp    8015dc <memset+0x91>
			*p8++ = (uint8)c;
  8015ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d1:	8d 50 01             	lea    0x1(%eax),%edx
  8015d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015da:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8015dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	75 e5                	jne    8015ce <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801600:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801604:	76 24                	jbe    80162a <memcpy+0x3c>
		while(n >= 8){
  801606:	eb 1c                	jmp    801624 <memcpy+0x36>
			*d64 = *s64;
  801608:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160b:	8b 50 04             	mov    0x4(%eax),%edx
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801613:	89 01                	mov    %eax,(%ecx)
  801615:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801618:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80161c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801620:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801624:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801628:	77 de                	ja     801608 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80162a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80162e:	74 31                	je     801661 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801630:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801633:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801636:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801639:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80163c:	eb 16                	jmp    801654 <memcpy+0x66>
			*d8++ = *s8++;
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	8d 50 01             	lea    0x1(%eax),%edx
  801644:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801647:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801650:	8a 12                	mov    (%edx),%dl
  801652:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801654:	8b 45 10             	mov    0x10(%ebp),%eax
  801657:	8d 50 ff             	lea    -0x1(%eax),%edx
  80165a:	89 55 10             	mov    %edx,0x10(%ebp)
  80165d:	85 c0                	test   %eax,%eax
  80165f:	75 dd                	jne    80163e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80166c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801678:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80167e:	73 50                	jae    8016d0 <memmove+0x6a>
  801680:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801683:	8b 45 10             	mov    0x10(%ebp),%eax
  801686:	01 d0                	add    %edx,%eax
  801688:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80168b:	76 43                	jbe    8016d0 <memmove+0x6a>
		s += n;
  80168d:	8b 45 10             	mov    0x10(%ebp),%eax
  801690:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801693:	8b 45 10             	mov    0x10(%ebp),%eax
  801696:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801699:	eb 10                	jmp    8016ab <memmove+0x45>
			*--d = *--s;
  80169b:	ff 4d f8             	decl   -0x8(%ebp)
  80169e:	ff 4d fc             	decl   -0x4(%ebp)
  8016a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a4:	8a 10                	mov    (%eax),%dl
  8016a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	75 e3                	jne    80169b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016b8:	eb 23                	jmp    8016dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	75 dd                	jne    8016ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016f4:	eb 2a                	jmp    801720 <memcmp+0x3e>
		if (*s1 != *s2)
  8016f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f9:	8a 10                	mov    (%eax),%dl
  8016fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	38 c2                	cmp    %al,%dl
  801702:	74 16                	je     80171a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801704:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	0f b6 d0             	movzbl %al,%edx
  80170c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170f:	8a 00                	mov    (%eax),%al
  801711:	0f b6 c0             	movzbl %al,%eax
  801714:	29 c2                	sub    %eax,%edx
  801716:	89 d0                	mov    %edx,%eax
  801718:	eb 18                	jmp    801732 <memcmp+0x50>
		s1++, s2++;
  80171a:	ff 45 fc             	incl   -0x4(%ebp)
  80171d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	8d 50 ff             	lea    -0x1(%eax),%edx
  801726:	89 55 10             	mov    %edx,0x10(%ebp)
  801729:	85 c0                	test   %eax,%eax
  80172b:	75 c9                	jne    8016f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80173a:	8b 55 08             	mov    0x8(%ebp),%edx
  80173d:	8b 45 10             	mov    0x10(%ebp),%eax
  801740:	01 d0                	add    %edx,%eax
  801742:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801745:	eb 15                	jmp    80175c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8a 00                	mov    (%eax),%al
  80174c:	0f b6 d0             	movzbl %al,%edx
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	0f b6 c0             	movzbl %al,%eax
  801755:	39 c2                	cmp    %eax,%edx
  801757:	74 0d                	je     801766 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801759:	ff 45 08             	incl   0x8(%ebp)
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801762:	72 e3                	jb     801747 <memfind+0x13>
  801764:	eb 01                	jmp    801767 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801766:	90                   	nop
	return (void *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801772:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801779:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801780:	eb 03                	jmp    801785 <strtol+0x19>
		s++;
  801782:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8a 00                	mov    (%eax),%al
  80178a:	3c 20                	cmp    $0x20,%al
  80178c:	74 f4                	je     801782 <strtol+0x16>
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	3c 09                	cmp    $0x9,%al
  801795:	74 eb                	je     801782 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	3c 2b                	cmp    $0x2b,%al
  80179e:	75 05                	jne    8017a5 <strtol+0x39>
		s++;
  8017a0:	ff 45 08             	incl   0x8(%ebp)
  8017a3:	eb 13                	jmp    8017b8 <strtol+0x4c>
	else if (*s == '-')
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	3c 2d                	cmp    $0x2d,%al
  8017ac:	75 0a                	jne    8017b8 <strtol+0x4c>
		s++, neg = 1;
  8017ae:	ff 45 08             	incl   0x8(%ebp)
  8017b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017bc:	74 06                	je     8017c4 <strtol+0x58>
  8017be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c2:	75 20                	jne    8017e4 <strtol+0x78>
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	3c 30                	cmp    $0x30,%al
  8017cb:	75 17                	jne    8017e4 <strtol+0x78>
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	40                   	inc    %eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	3c 78                	cmp    $0x78,%al
  8017d5:	75 0d                	jne    8017e4 <strtol+0x78>
		s += 2, base = 16;
  8017d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e2:	eb 28                	jmp    80180c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e8:	75 15                	jne    8017ff <strtol+0x93>
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8a 00                	mov    (%eax),%al
  8017ef:	3c 30                	cmp    $0x30,%al
  8017f1:	75 0c                	jne    8017ff <strtol+0x93>
		s++, base = 8;
  8017f3:	ff 45 08             	incl   0x8(%ebp)
  8017f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017fd:	eb 0d                	jmp    80180c <strtol+0xa0>
	else if (base == 0)
  8017ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801803:	75 07                	jne    80180c <strtol+0xa0>
		base = 10;
  801805:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	3c 2f                	cmp    $0x2f,%al
  801813:	7e 19                	jle    80182e <strtol+0xc2>
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	3c 39                	cmp    $0x39,%al
  80181c:	7f 10                	jg     80182e <strtol+0xc2>
			dig = *s - '0';
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	8a 00                	mov    (%eax),%al
  801823:	0f be c0             	movsbl %al,%eax
  801826:	83 e8 30             	sub    $0x30,%eax
  801829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182c:	eb 42                	jmp    801870 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3c 60                	cmp    $0x60,%al
  801835:	7e 19                	jle    801850 <strtol+0xe4>
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 7a                	cmp    $0x7a,%al
  80183e:	7f 10                	jg     801850 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	0f be c0             	movsbl %al,%eax
  801848:	83 e8 57             	sub    $0x57,%eax
  80184b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80184e:	eb 20                	jmp    801870 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	3c 40                	cmp    $0x40,%al
  801857:	7e 39                	jle    801892 <strtol+0x126>
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	3c 5a                	cmp    $0x5a,%al
  801860:	7f 30                	jg     801892 <strtol+0x126>
			dig = *s - 'A' + 10;
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	8a 00                	mov    (%eax),%al
  801867:	0f be c0             	movsbl %al,%eax
  80186a:	83 e8 37             	sub    $0x37,%eax
  80186d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801873:	3b 45 10             	cmp    0x10(%ebp),%eax
  801876:	7d 19                	jge    801891 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801878:	ff 45 08             	incl   0x8(%ebp)
  80187b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801882:	89 c2                	mov    %eax,%edx
  801884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801887:	01 d0                	add    %edx,%eax
  801889:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80188c:	e9 7b ff ff ff       	jmp    80180c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801891:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801892:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801896:	74 08                	je     8018a0 <strtol+0x134>
		*endptr = (char *) s;
  801898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189b:	8b 55 08             	mov    0x8(%ebp),%edx
  80189e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a4:	74 07                	je     8018ad <strtol+0x141>
  8018a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a9:	f7 d8                	neg    %eax
  8018ab:	eb 03                	jmp    8018b0 <strtol+0x144>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ca:	79 13                	jns    8018df <ltostr+0x2d>
	{
		neg = 1;
  8018cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018e7:	99                   	cltd   
  8018e8:	f7 f9                	idiv   %ecx
  8018ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f0:	8d 50 01             	lea    0x1(%eax),%edx
  8018f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018f6:	89 c2                	mov    %eax,%edx
  8018f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801900:	83 c2 30             	add    $0x30,%edx
  801903:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801905:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801908:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80190d:	f7 e9                	imul   %ecx
  80190f:	c1 fa 02             	sar    $0x2,%edx
  801912:	89 c8                	mov    %ecx,%eax
  801914:	c1 f8 1f             	sar    $0x1f,%eax
  801917:	29 c2                	sub    %eax,%edx
  801919:	89 d0                	mov    %edx,%eax
  80191b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80191e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801922:	75 bb                	jne    8018df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801924:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80192b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192e:	48                   	dec    %eax
  80192f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801932:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801936:	74 3d                	je     801975 <ltostr+0xc3>
		start = 1 ;
  801938:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193f:	eb 34                	jmp    801975 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801941:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801944:	8b 45 0c             	mov    0xc(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	8a 00                	mov    (%eax),%al
  80194b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195c:	01 c8                	add    %ecx,%eax
  80195e:	8a 00                	mov    (%eax),%al
  801960:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801962:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801965:	8b 45 0c             	mov    0xc(%ebp),%eax
  801968:	01 c2                	add    %eax,%edx
  80196a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196d:	88 02                	mov    %al,(%edx)
		start++ ;
  80196f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801972:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801978:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80197b:	7c c4                	jl     801941 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	01 d0                	add    %edx,%eax
  801985:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801988:	90                   	nop
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	e8 c4 f9 ff ff       	call   80135d <strlen>
  801999:	83 c4 04             	add    $0x4,%esp
  80199c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	e8 b6 f9 ff ff       	call   80135d <strlen>
  8019a7:	83 c4 04             	add    $0x4,%esp
  8019aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019bb:	eb 17                	jmp    8019d4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c3:	01 c2                	add    %eax,%edx
  8019c5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	01 c8                	add    %ecx,%eax
  8019cd:	8a 00                	mov    (%eax),%al
  8019cf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019d1:	ff 45 fc             	incl   -0x4(%ebp)
  8019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019da:	7c e1                	jl     8019bd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019ea:	eb 1f                	jmp    801a0b <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ef:	8d 50 01             	lea    0x1(%eax),%edx
  8019f2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f5:	89 c2                	mov    %eax,%edx
  8019f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fa:	01 c2                	add    %eax,%edx
  8019fc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a02:	01 c8                	add    %ecx,%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a08:	ff 45 f8             	incl   -0x8(%ebp)
  801a0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a11:	7c d9                	jl     8019ec <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a16:	8b 45 10             	mov    0x10(%ebp),%eax
  801a19:	01 d0                	add    %edx,%eax
  801a1b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a24:	8b 45 14             	mov    0x14(%ebp),%eax
  801a27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a30:	8b 00                	mov    (%eax),%eax
  801a32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a39:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3c:	01 d0                	add    %edx,%eax
  801a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a44:	eb 0c                	jmp    801a52 <strsplit+0x31>
			*string++ = 0;
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8d 50 01             	lea    0x1(%eax),%edx
  801a4c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	8a 00                	mov    (%eax),%al
  801a57:	84 c0                	test   %al,%al
  801a59:	74 18                	je     801a73 <strsplit+0x52>
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8a 00                	mov    (%eax),%al
  801a60:	0f be c0             	movsbl %al,%eax
  801a63:	50                   	push   %eax
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	e8 83 fa ff ff       	call   8014ef <strchr>
  801a6c:	83 c4 08             	add    $0x8,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	75 d3                	jne    801a46 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	8a 00                	mov    (%eax),%al
  801a78:	84 c0                	test   %al,%al
  801a7a:	74 5a                	je     801ad6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7f:	8b 00                	mov    (%eax),%eax
  801a81:	83 f8 0f             	cmp    $0xf,%eax
  801a84:	75 07                	jne    801a8d <strsplit+0x6c>
		{
			return 0;
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8b:	eb 66                	jmp    801af3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a90:	8b 00                	mov    (%eax),%eax
  801a92:	8d 48 01             	lea    0x1(%eax),%ecx
  801a95:	8b 55 14             	mov    0x14(%ebp),%edx
  801a98:	89 0a                	mov    %ecx,(%edx)
  801a9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa4:	01 c2                	add    %eax,%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aab:	eb 03                	jmp    801ab0 <strsplit+0x8f>
			string++;
  801aad:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	8a 00                	mov    (%eax),%al
  801ab5:	84 c0                	test   %al,%al
  801ab7:	74 8b                	je     801a44 <strsplit+0x23>
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8a 00                	mov    (%eax),%al
  801abe:	0f be c0             	movsbl %al,%eax
  801ac1:	50                   	push   %eax
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	e8 25 fa ff ff       	call   8014ef <strchr>
  801aca:	83 c4 08             	add    $0x8,%esp
  801acd:	85 c0                	test   %eax,%eax
  801acf:	74 dc                	je     801aad <strsplit+0x8c>
			string++;
	}
  801ad1:	e9 6e ff ff ff       	jmp    801a44 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  801ada:	8b 00                	mov    (%eax),%eax
  801adc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae6:	01 d0                	add    %edx,%eax
  801ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b08:	eb 4a                	jmp    801b54 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801b0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	01 c2                	add    %eax,%edx
  801b12:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b18:	01 c8                	add    %ecx,%eax
  801b1a:	8a 00                	mov    (%eax),%al
  801b1c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801b1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 d0                	add    %edx,%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	3c 40                	cmp    $0x40,%al
  801b2a:	7e 25                	jle    801b51 <str2lower+0x5c>
  801b2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b32:	01 d0                	add    %edx,%eax
  801b34:	8a 00                	mov    (%eax),%al
  801b36:	3c 5a                	cmp    $0x5a,%al
  801b38:	7f 17                	jg     801b51 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801b3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	01 d0                	add    %edx,%eax
  801b42:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b45:	8b 55 08             	mov    0x8(%ebp),%edx
  801b48:	01 ca                	add    %ecx,%edx
  801b4a:	8a 12                	mov    (%edx),%dl
  801b4c:	83 c2 20             	add    $0x20,%edx
  801b4f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801b51:	ff 45 fc             	incl   -0x4(%ebp)
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	e8 01 f8 ff ff       	call   80135d <strlen>
  801b5c:	83 c4 04             	add    $0x4,%esp
  801b5f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b62:	7f a6                	jg     801b0a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b64:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b6f:	a1 08 60 80 00       	mov    0x806008,%eax
  801b74:	85 c0                	test   %eax,%eax
  801b76:	74 42                	je     801bba <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b78:	83 ec 08             	sub    $0x8,%esp
  801b7b:	68 00 00 00 82       	push   $0x82000000
  801b80:	68 00 00 00 80       	push   $0x80000000
  801b85:	e8 b0 1e 00 00       	call   803a3a <initialize_dynamic_allocator>
  801b8a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b8d:	e8 96 1c 00 00       	call   803828 <sys_get_uheap_strategy>
  801b92:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b97:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801b9c:	05 00 10 00 00       	add    $0x1000,%eax
  801ba1:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801ba6:	a1 30 61 83 00       	mov    0x836130,%eax
  801bab:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801bb0:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801bb7:	00 00 00 
	}
}
  801bba:	90                   	nop
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	68 06 04 00 00       	push   $0x406
  801bd9:	50                   	push   %eax
  801bda:	e8 93 18 00 00       	call   803472 <__sys_allocate_page>
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801be5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be9:	79 14                	jns    801bff <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	68 bc 4e 80 00       	push   $0x804ebc
  801bf3:	6a 1f                	push   $0x1f
  801bf5:	68 f8 4e 80 00       	push   $0x804ef8
  801bfa:	e8 af eb ff ff       	call   8007ae <_panic>
	return 0;
  801bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	50                   	push   %eax
  801c1e:	e8 96 18 00 00       	call   8034b9 <__sys_unmap_frame>
  801c23:	83 c4 10             	add    $0x10,%esp
  801c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c2d:	79 14                	jns    801c43 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	68 04 4f 80 00       	push   $0x804f04
  801c37:	6a 2a                	push   $0x2a
  801c39:	68 f8 4e 80 00       	push   $0x804ef8
  801c3e:	e8 6b eb ff ff       	call   8007ae <_panic>
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c4c:	e8 18 ff ff ff       	call   801b69 <uheap_init>
	if (size == 0) return NULL ;
  801c51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c55:	75 0a                	jne    801c61 <malloc+0x1b>
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5c:	e9 43 03 00 00       	jmp    801fa4 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c61:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c68:	77 13                	ja     801c7d <malloc+0x37>
    {
        return alloc_block(size);
  801c6a:	83 ec 0c             	sub    $0xc,%esp
  801c6d:	ff 75 08             	pushl  0x8(%ebp)
  801c70:	e8 78 20 00 00       	call   803ced <alloc_block>
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	e9 27 03 00 00       	jmp    801fa4 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801c7d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c84:	8b 55 08             	mov    0x8(%ebp),%edx
  801c87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	48                   	dec    %eax
  801c8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c93:	ba 00 00 00 00       	mov    $0x0,%edx
  801c98:	f7 75 dc             	divl   -0x24(%ebp)
  801c9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c9e:	29 d0                	sub    %edx,%eax
  801ca0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801ca3:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	75 0a                	jne    801cb6 <malloc+0x70>
    {
        uhp_inited = 1;
  801cac:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801cb3:	00 00 00 
    }

    int exactIdx = -1;
  801cb6:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801cbd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801cc4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ccb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801cd2:	e9 85 00 00 00       	jmp    801d5c <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801cd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cda:	89 d0                	mov    %edx,%eax
  801cdc:	01 c0                	add    %eax,%eax
  801cde:	01 d0                	add    %edx,%eax
  801ce0:	c1 e0 02             	shl    $0x2,%eax
  801ce3:	05 48 20 81 00       	add    $0x812048,%eax
  801ce8:	8a 00                	mov    (%eax),%al
  801cea:	84 c0                	test   %al,%al
  801cec:	74 20                	je     801d0e <malloc+0xc8>
  801cee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cf1:	89 d0                	mov    %edx,%eax
  801cf3:	01 c0                	add    %eax,%eax
  801cf5:	01 d0                	add    %edx,%eax
  801cf7:	c1 e0 02             	shl    $0x2,%eax
  801cfa:	05 44 20 81 00       	add    $0x812044,%eax
  801cff:	8b 00                	mov    (%eax),%eax
  801d01:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d04:	75 08                	jne    801d0e <malloc+0xc8>
        {
            exactIdx = i;
  801d06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801d0c:	eb 5b                	jmp    801d69 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801d0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d11:	89 d0                	mov    %edx,%eax
  801d13:	01 c0                	add    %eax,%eax
  801d15:	01 d0                	add    %edx,%eax
  801d17:	c1 e0 02             	shl    $0x2,%eax
  801d1a:	05 48 20 81 00       	add    $0x812048,%eax
  801d1f:	8a 00                	mov    (%eax),%al
  801d21:	84 c0                	test   %al,%al
  801d23:	74 34                	je     801d59 <malloc+0x113>
  801d25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d28:	89 d0                	mov    %edx,%eax
  801d2a:	01 c0                	add    %eax,%eax
  801d2c:	01 d0                	add    %edx,%eax
  801d2e:	c1 e0 02             	shl    $0x2,%eax
  801d31:	05 44 20 81 00       	add    $0x812044,%eax
  801d36:	8b 00                	mov    (%eax),%eax
  801d38:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d3b:	76 1c                	jbe    801d59 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801d3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d40:	89 d0                	mov    %edx,%eax
  801d42:	01 c0                	add    %eax,%eax
  801d44:	01 d0                	add    %edx,%eax
  801d46:	c1 e0 02             	shl    $0x2,%eax
  801d49:	05 44 20 81 00       	add    $0x812044,%eax
  801d4e:	8b 00                	mov    (%eax),%eax
  801d50:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801d53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d59:	ff 45 e8             	incl   -0x18(%ebp)
  801d5c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801d63:	0f 8e 6e ff ff ff    	jle    801cd7 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801d69:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801d70:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801d74:	74 7d                	je     801df3 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801d76:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d80:	89 d0                	mov    %edx,%eax
  801d82:	01 c0                	add    %eax,%eax
  801d84:	01 d0                	add    %edx,%eax
  801d86:	c1 e0 02             	shl    $0x2,%eax
  801d89:	05 40 20 81 00       	add    $0x812040,%eax
  801d8e:	8b 10                	mov    (%eax),%edx
  801d90:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d93:	01 d0                	add    %edx,%eax
  801d95:	48                   	dec    %eax
  801d96:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d99:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801da1:	f7 75 bc             	divl   -0x44(%ebp)
  801da4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801da7:	29 d0                	sub    %edx,%eax
  801da9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801dac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801daf:	89 d0                	mov    %edx,%eax
  801db1:	01 c0                	add    %eax,%eax
  801db3:	01 d0                	add    %edx,%eax
  801db5:	c1 e0 02             	shl    $0x2,%eax
  801db8:	05 48 20 81 00       	add    $0x812048,%eax
  801dbd:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801dc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc3:	89 d0                	mov    %edx,%eax
  801dc5:	01 c0                	add    %eax,%eax
  801dc7:	01 d0                	add    %edx,%eax
  801dc9:	c1 e0 02             	shl    $0x2,%eax
  801dcc:	05 44 20 81 00       	add    $0x812044,%eax
  801dd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dda:	89 d0                	mov    %edx,%eax
  801ddc:	01 c0                	add    %eax,%eax
  801dde:	01 d0                	add    %edx,%eax
  801de0:	c1 e0 02             	shl    $0x2,%eax
  801de3:	05 40 20 81 00       	add    $0x812040,%eax
  801de8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dee:	e9 2d 01 00 00       	jmp    801f20 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801df3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801df7:	0f 84 ce 00 00 00    	je     801ecb <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801dfd:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801e04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e07:	89 d0                	mov    %edx,%eax
  801e09:	01 c0                	add    %eax,%eax
  801e0b:	01 d0                	add    %edx,%eax
  801e0d:	c1 e0 02             	shl    $0x2,%eax
  801e10:	05 40 20 81 00       	add    $0x812040,%eax
  801e15:	8b 10                	mov    (%eax),%edx
  801e17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	48                   	dec    %eax
  801e1d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801e20:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e23:	ba 00 00 00 00       	mov    $0x0,%edx
  801e28:	f7 75 c4             	divl   -0x3c(%ebp)
  801e2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e2e:	29 d0                	sub    %edx,%eax
  801e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801e33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e36:	89 d0                	mov    %edx,%eax
  801e38:	01 c0                	add    %eax,%eax
  801e3a:	01 d0                	add    %edx,%eax
  801e3c:	c1 e0 02             	shl    $0x2,%eax
  801e3f:	05 44 20 81 00       	add    $0x812044,%eax
  801e44:	8b 00                	mov    (%eax),%eax
  801e46:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e49:	75 47                	jne    801e92 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801e4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e4e:	89 d0                	mov    %edx,%eax
  801e50:	01 c0                	add    %eax,%eax
  801e52:	01 d0                	add    %edx,%eax
  801e54:	c1 e0 02             	shl    $0x2,%eax
  801e57:	05 48 20 81 00       	add    $0x812048,%eax
  801e5c:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801e5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e62:	89 d0                	mov    %edx,%eax
  801e64:	01 c0                	add    %eax,%eax
  801e66:	01 d0                	add    %edx,%eax
  801e68:	c1 e0 02             	shl    $0x2,%eax
  801e6b:	05 44 20 81 00       	add    $0x812044,%eax
  801e70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801e76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e79:	89 d0                	mov    %edx,%eax
  801e7b:	01 c0                	add    %eax,%eax
  801e7d:	01 d0                	add    %edx,%eax
  801e7f:	c1 e0 02             	shl    $0x2,%eax
  801e82:	05 40 20 81 00       	add    $0x812040,%eax
  801e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e8d:	e9 8e 00 00 00       	jmp    801f20 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801e92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e98:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e9e:	89 d0                	mov    %edx,%eax
  801ea0:	01 c0                	add    %eax,%eax
  801ea2:	01 d0                	add    %edx,%eax
  801ea4:	c1 e0 02             	shl    $0x2,%eax
  801ea7:	05 40 20 81 00       	add    $0x812040,%eax
  801eac:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb1:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801eb4:	89 c2                	mov    %eax,%edx
  801eb6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801eb9:	89 c8                	mov    %ecx,%eax
  801ebb:	01 c0                	add    %eax,%eax
  801ebd:	01 c8                	add    %ecx,%eax
  801ebf:	c1 e0 02             	shl    $0x2,%eax
  801ec2:	05 44 20 81 00       	add    $0x812044,%eax
  801ec7:	89 10                	mov    %edx,(%eax)
  801ec9:	eb 55                	jmp    801f20 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801ecb:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801ed2:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801ed8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801edb:	01 d0                	add    %edx,%eax
  801edd:	48                   	dec    %eax
  801ede:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ee1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee9:	f7 75 d0             	divl   -0x30(%ebp)
  801eec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801eef:	29 d0                	sub    %edx,%eax
  801ef1:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801ef4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801efa:	01 d0                	add    %edx,%eax
  801efc:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f01:	76 0a                	jbe    801f0d <malloc+0x2c7>
            return NULL;
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	e9 97 00 00 00       	jmp    801fa4 <malloc+0x35e>
        va = start;
  801f0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801f13:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f19:	01 d0                	add    %edx,%eax
  801f1b:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f27:	eb 5e                	jmp    801f87 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801f29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f2c:	89 d0                	mov    %edx,%eax
  801f2e:	01 c0                	add    %eax,%eax
  801f30:	01 d0                	add    %edx,%eax
  801f32:	c1 e0 02             	shl    $0x2,%eax
  801f35:	05 48 60 80 00       	add    $0x806048,%eax
  801f3a:	8a 00                	mov    (%eax),%al
  801f3c:	84 c0                	test   %al,%al
  801f3e:	75 44                	jne    801f84 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801f40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f43:	89 d0                	mov    %edx,%eax
  801f45:	01 c0                	add    %eax,%eax
  801f47:	01 d0                	add    %edx,%eax
  801f49:	c1 e0 02             	shl    $0x2,%eax
  801f4c:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f55:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801f57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f5a:	89 d0                	mov    %edx,%eax
  801f5c:	01 c0                	add    %eax,%eax
  801f5e:	01 d0                	add    %edx,%eax
  801f60:	c1 e0 02             	shl    $0x2,%eax
  801f63:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801f69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f6c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801f6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f71:	89 d0                	mov    %edx,%eax
  801f73:	01 c0                	add    %eax,%eax
  801f75:	01 d0                	add    %edx,%eax
  801f77:	c1 e0 02             	shl    $0x2,%eax
  801f7a:	05 48 60 80 00       	add    $0x806048,%eax
  801f7f:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801f82:	eb 0c                	jmp    801f90 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f84:	ff 45 e0             	incl   -0x20(%ebp)
  801f87:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f8e:	7e 99                	jle    801f29 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801f90:	83 ec 08             	sub    $0x8,%esp
  801f93:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f96:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f99:	e8 a2 19 00 00       	call   803940 <sys_allocate_user_mem>
  801f9e:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801fa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801fac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fb0:	0f 84 fa 03 00 00    	je     8023b0 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801fbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	79 1c                	jns    801fdf <free+0x39>
  801fc3:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801fca:	77 13                	ja     801fdf <free+0x39>
    {
        free_block(virtual_address);
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	ff 75 08             	pushl  0x8(%ebp)
  801fd2:	e8 09 21 00 00       	call   8040e0 <free_block>
  801fd7:	83 c4 10             	add    $0x10,%esp
        return;
  801fda:	e9 d2 03 00 00       	jmp    8023b1 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801fdf:	a1 30 61 83 00       	mov    0x836130,%eax
  801fe4:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801fe7:	72 09                	jb     801ff2 <free+0x4c>
  801fe9:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801ff0:	76 17                	jbe    802009 <free+0x63>
        panic("free: invalid address");
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	68 41 4f 80 00       	push   $0x804f41
  801ffa:	68 9b 00 00 00       	push   $0x9b
  801fff:	68 f8 4e 80 00       	push   $0x804ef8
  802004:	e8 a5 e7 ff ff       	call   8007ae <_panic>

    uint32 size = 0;
  802009:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  802010:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802017:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80201e:	eb 50                	jmp    802070 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802020:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802023:	89 d0                	mov    %edx,%eax
  802025:	01 c0                	add    %eax,%eax
  802027:	01 d0                	add    %edx,%eax
  802029:	c1 e0 02             	shl    $0x2,%eax
  80202c:	05 48 60 80 00       	add    $0x806048,%eax
  802031:	8a 00                	mov    (%eax),%al
  802033:	84 c0                	test   %al,%al
  802035:	74 36                	je     80206d <free+0xc7>
  802037:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80203a:	89 d0                	mov    %edx,%eax
  80203c:	01 c0                	add    %eax,%eax
  80203e:	01 d0                	add    %edx,%eax
  802040:	c1 e0 02             	shl    $0x2,%eax
  802043:	05 40 60 80 00       	add    $0x806040,%eax
  802048:	8b 00                	mov    (%eax),%eax
  80204a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80204d:	75 1e                	jne    80206d <free+0xc7>
        {
            size = uhp_allocs[i].size;
  80204f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802052:	89 d0                	mov    %edx,%eax
  802054:	01 c0                	add    %eax,%eax
  802056:	01 d0                	add    %edx,%eax
  802058:	c1 e0 02             	shl    $0x2,%eax
  80205b:	05 44 60 80 00       	add    $0x806044,%eax
  802060:	8b 00                	mov    (%eax),%eax
  802062:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  802065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802068:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  80206b:	eb 0c                	jmp    802079 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80206d:	ff 45 ec             	incl   -0x14(%ebp)
  802070:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802077:	7e a7                	jle    802020 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  802079:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80207d:	74 06                	je     802085 <free+0xdf>
  80207f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802083:	75 17                	jne    80209c <free+0xf6>
        panic("free: unknown block");
  802085:	83 ec 04             	sub    $0x4,%esp
  802088:	68 57 4f 80 00       	push   $0x804f57
  80208d:	68 a9 00 00 00       	push   $0xa9
  802092:	68 f8 4e 80 00       	push   $0x804ef8
  802097:	e8 12 e7 ff ff       	call   8007ae <_panic>

    uhp_allocs[idx].used = 0;
  80209c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80209f:	89 d0                	mov    %edx,%eax
  8020a1:	01 c0                	add    %eax,%eax
  8020a3:	01 d0                	add    %edx,%eax
  8020a5:	c1 e0 02             	shl    $0x2,%eax
  8020a8:	05 48 60 80 00       	add    $0x806048,%eax
  8020ad:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8020b0:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8020be:	eb 64                	jmp    802124 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8020c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020c3:	89 d0                	mov    %edx,%eax
  8020c5:	01 c0                	add    %eax,%eax
  8020c7:	01 d0                	add    %edx,%eax
  8020c9:	c1 e0 02             	shl    $0x2,%eax
  8020cc:	05 48 20 81 00       	add    $0x812048,%eax
  8020d1:	8a 00                	mov    (%eax),%al
  8020d3:	84 c0                	test   %al,%al
  8020d5:	75 4a                	jne    802121 <free+0x17b>
        {
            uhp_frees[i].va = va;
  8020d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020da:	89 d0                	mov    %edx,%eax
  8020dc:	01 c0                	add    %eax,%eax
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	c1 e0 02             	shl    $0x2,%eax
  8020e3:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8020e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020ec:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  8020ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020f1:	89 d0                	mov    %edx,%eax
  8020f3:	01 c0                	add    %eax,%eax
  8020f5:	01 d0                	add    %edx,%eax
  8020f7:	c1 e0 02             	shl    $0x2,%eax
  8020fa:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  802105:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802108:	89 d0                	mov    %edx,%eax
  80210a:	01 c0                	add    %eax,%eax
  80210c:	01 d0                	add    %edx,%eax
  80210e:	c1 e0 02             	shl    $0x2,%eax
  802111:	05 48 20 81 00       	add    $0x812048,%eax
  802116:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80211c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  80211f:	eb 0c                	jmp    80212d <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802121:	ff 45 e4             	incl   -0x1c(%ebp)
  802124:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80212b:	7e 93                	jle    8020c0 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  80212d:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802131:	0f 84 f1 01 00 00    	je     802328 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802137:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80213e:	e9 d8 01 00 00       	jmp    80231b <free+0x375>
        {
            if (i == fidx) continue;
  802143:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802146:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802149:	0f 84 c8 01 00 00    	je     802317 <free+0x371>
            if (uhp_frees[i].free)
  80214f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802152:	89 d0                	mov    %edx,%eax
  802154:	01 c0                	add    %eax,%eax
  802156:	01 d0                	add    %edx,%eax
  802158:	c1 e0 02             	shl    $0x2,%eax
  80215b:	05 48 20 81 00       	add    $0x812048,%eax
  802160:	8a 00                	mov    (%eax),%al
  802162:	84 c0                	test   %al,%al
  802164:	0f 84 ae 01 00 00    	je     802318 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  80216a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80216d:	89 d0                	mov    %edx,%eax
  80216f:	01 c0                	add    %eax,%eax
  802171:	01 d0                	add    %edx,%eax
  802173:	c1 e0 02             	shl    $0x2,%eax
  802176:	05 40 20 81 00       	add    $0x812040,%eax
  80217b:	8b 08                	mov    (%eax),%ecx
  80217d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802180:	89 d0                	mov    %edx,%eax
  802182:	01 c0                	add    %eax,%eax
  802184:	01 d0                	add    %edx,%eax
  802186:	c1 e0 02             	shl    $0x2,%eax
  802189:	05 44 20 81 00       	add    $0x812044,%eax
  80218e:	8b 00                	mov    (%eax),%eax
  802190:	01 c1                	add    %eax,%ecx
  802192:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802195:	89 d0                	mov    %edx,%eax
  802197:	01 c0                	add    %eax,%eax
  802199:	01 d0                	add    %edx,%eax
  80219b:	c1 e0 02             	shl    $0x2,%eax
  80219e:	05 40 20 81 00       	add    $0x812040,%eax
  8021a3:	8b 00                	mov    (%eax),%eax
  8021a5:	39 c1                	cmp    %eax,%ecx
  8021a7:	0f 85 a8 00 00 00    	jne    802255 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  8021ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021b0:	89 d0                	mov    %edx,%eax
  8021b2:	01 c0                	add    %eax,%eax
  8021b4:	01 d0                	add    %edx,%eax
  8021b6:	c1 e0 02             	shl    $0x2,%eax
  8021b9:	05 40 20 81 00       	add    $0x812040,%eax
  8021be:	8b 10                	mov    (%eax),%edx
  8021c0:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8021c3:	89 c8                	mov    %ecx,%eax
  8021c5:	01 c0                	add    %eax,%eax
  8021c7:	01 c8                	add    %ecx,%eax
  8021c9:	c1 e0 02             	shl    $0x2,%eax
  8021cc:	05 40 20 81 00       	add    $0x812040,%eax
  8021d1:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8021d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021d6:	89 d0                	mov    %edx,%eax
  8021d8:	01 c0                	add    %eax,%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	c1 e0 02             	shl    $0x2,%eax
  8021df:	05 44 20 81 00       	add    $0x812044,%eax
  8021e4:	8b 08                	mov    (%eax),%ecx
  8021e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	01 c0                	add    %eax,%eax
  8021ed:	01 d0                	add    %edx,%eax
  8021ef:	c1 e0 02             	shl    $0x2,%eax
  8021f2:	05 44 20 81 00       	add    $0x812044,%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	01 c1                	add    %eax,%ecx
  8021fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021fe:	89 d0                	mov    %edx,%eax
  802200:	01 c0                	add    %eax,%eax
  802202:	01 d0                	add    %edx,%eax
  802204:	c1 e0 02             	shl    $0x2,%eax
  802207:	05 44 20 81 00       	add    $0x812044,%eax
  80220c:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  80220e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802211:	89 d0                	mov    %edx,%eax
  802213:	01 c0                	add    %eax,%eax
  802215:	01 d0                	add    %edx,%eax
  802217:	c1 e0 02             	shl    $0x2,%eax
  80221a:	05 48 20 81 00       	add    $0x812048,%eax
  80221f:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802222:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802225:	89 d0                	mov    %edx,%eax
  802227:	01 c0                	add    %eax,%eax
  802229:	01 d0                	add    %edx,%eax
  80222b:	c1 e0 02             	shl    $0x2,%eax
  80222e:	05 40 20 81 00       	add    $0x812040,%eax
  802233:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802239:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80223c:	89 d0                	mov    %edx,%eax
  80223e:	01 c0                	add    %eax,%eax
  802240:	01 d0                	add    %edx,%eax
  802242:	c1 e0 02             	shl    $0x2,%eax
  802245:	05 44 20 81 00       	add    $0x812044,%eax
  80224a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802250:	e9 c3 00 00 00       	jmp    802318 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  802255:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802258:	89 d0                	mov    %edx,%eax
  80225a:	01 c0                	add    %eax,%eax
  80225c:	01 d0                	add    %edx,%eax
  80225e:	c1 e0 02             	shl    $0x2,%eax
  802261:	05 40 20 81 00       	add    $0x812040,%eax
  802266:	8b 08                	mov    (%eax),%ecx
  802268:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80226b:	89 d0                	mov    %edx,%eax
  80226d:	01 c0                	add    %eax,%eax
  80226f:	01 d0                	add    %edx,%eax
  802271:	c1 e0 02             	shl    $0x2,%eax
  802274:	05 44 20 81 00       	add    $0x812044,%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	01 c1                	add    %eax,%ecx
  80227d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802280:	89 d0                	mov    %edx,%eax
  802282:	01 c0                	add    %eax,%eax
  802284:	01 d0                	add    %edx,%eax
  802286:	c1 e0 02             	shl    $0x2,%eax
  802289:	05 40 20 81 00       	add    $0x812040,%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	39 c1                	cmp    %eax,%ecx
  802292:	0f 85 80 00 00 00    	jne    802318 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802298:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80229b:	89 d0                	mov    %edx,%eax
  80229d:	01 c0                	add    %eax,%eax
  80229f:	01 d0                	add    %edx,%eax
  8022a1:	c1 e0 02             	shl    $0x2,%eax
  8022a4:	05 44 20 81 00       	add    $0x812044,%eax
  8022a9:	8b 08                	mov    (%eax),%ecx
  8022ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022ae:	89 d0                	mov    %edx,%eax
  8022b0:	01 c0                	add    %eax,%eax
  8022b2:	01 d0                	add    %edx,%eax
  8022b4:	c1 e0 02             	shl    $0x2,%eax
  8022b7:	05 44 20 81 00       	add    $0x812044,%eax
  8022bc:	8b 00                	mov    (%eax),%eax
  8022be:	01 c1                	add    %eax,%ecx
  8022c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022c3:	89 d0                	mov    %edx,%eax
  8022c5:	01 c0                	add    %eax,%eax
  8022c7:	01 d0                	add    %edx,%eax
  8022c9:	c1 e0 02             	shl    $0x2,%eax
  8022cc:	05 44 20 81 00       	add    $0x812044,%eax
  8022d1:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8022d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022d6:	89 d0                	mov    %edx,%eax
  8022d8:	01 c0                	add    %eax,%eax
  8022da:	01 d0                	add    %edx,%eax
  8022dc:	c1 e0 02             	shl    $0x2,%eax
  8022df:	05 48 20 81 00       	add    $0x812048,%eax
  8022e4:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8022e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022ea:	89 d0                	mov    %edx,%eax
  8022ec:	01 c0                	add    %eax,%eax
  8022ee:	01 d0                	add    %edx,%eax
  8022f0:	c1 e0 02             	shl    $0x2,%eax
  8022f3:	05 40 20 81 00       	add    $0x812040,%eax
  8022f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8022fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802301:	89 d0                	mov    %edx,%eax
  802303:	01 c0                	add    %eax,%eax
  802305:	01 d0                	add    %edx,%eax
  802307:	c1 e0 02             	shl    $0x2,%eax
  80230a:	05 44 20 81 00       	add    $0x812044,%eax
  80230f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802315:	eb 01                	jmp    802318 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  802317:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802318:	ff 45 e0             	incl   -0x20(%ebp)
  80231b:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802322:	0f 8e 1b fe ff ff    	jle    802143 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802328:	a1 30 61 83 00       	mov    0x836130,%eax
  80232d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802330:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802337:	eb 53                	jmp    80238c <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802339:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80233c:	89 d0                	mov    %edx,%eax
  80233e:	01 c0                	add    %eax,%eax
  802340:	01 d0                	add    %edx,%eax
  802342:	c1 e0 02             	shl    $0x2,%eax
  802345:	05 48 60 80 00       	add    $0x806048,%eax
  80234a:	8a 00                	mov    (%eax),%al
  80234c:	84 c0                	test   %al,%al
  80234e:	74 39                	je     802389 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802350:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802353:	89 d0                	mov    %edx,%eax
  802355:	01 c0                	add    %eax,%eax
  802357:	01 d0                	add    %edx,%eax
  802359:	c1 e0 02             	shl    $0x2,%eax
  80235c:	05 40 60 80 00       	add    $0x806040,%eax
  802361:	8b 08                	mov    (%eax),%ecx
  802363:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802366:	89 d0                	mov    %edx,%eax
  802368:	01 c0                	add    %eax,%eax
  80236a:	01 d0                	add    %edx,%eax
  80236c:	c1 e0 02             	shl    $0x2,%eax
  80236f:	05 44 60 80 00       	add    $0x806044,%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	01 c8                	add    %ecx,%eax
  802378:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  80237b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80237e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802381:	76 06                	jbe    802389 <free+0x3e3>
  802383:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802386:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802389:	ff 45 d8             	incl   -0x28(%ebp)
  80238c:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802393:	7e a4                	jle    802339 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802395:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802398:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  80239d:	83 ec 08             	sub    $0x8,%esp
  8023a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8023a3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8023a6:	e8 79 15 00 00       	call   803924 <sys_free_user_mem>
  8023ab:	83 c4 10             	add    $0x10,%esp
  8023ae:	eb 01                	jmp    8023b1 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  8023b0:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	83 ec 68             	sub    $0x68,%esp
  8023b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023bc:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023bf:	e8 a5 f7 ff ff       	call   801b69 <uheap_init>
	if (size == 0) return NULL ;
  8023c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023c8:	75 0a                	jne    8023d4 <smalloc+0x21>
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cf:	e9 37 03 00 00       	jmp    80270b <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8023d4:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8023db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023e1:	01 d0                	add    %edx,%eax
  8023e3:	48                   	dec    %eax
  8023e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ef:	f7 75 dc             	divl   -0x24(%ebp)
  8023f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023f5:	29 d0                	sub    %edx,%eax
  8023f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  8023fa:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802401:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802408:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80240f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802416:	e9 85 00 00 00       	jmp    8024a0 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80241b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80241e:	89 d0                	mov    %edx,%eax
  802420:	01 c0                	add    %eax,%eax
  802422:	01 d0                	add    %edx,%eax
  802424:	c1 e0 02             	shl    $0x2,%eax
  802427:	05 48 20 81 00       	add    $0x812048,%eax
  80242c:	8a 00                	mov    (%eax),%al
  80242e:	84 c0                	test   %al,%al
  802430:	74 20                	je     802452 <smalloc+0x9f>
  802432:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802435:	89 d0                	mov    %edx,%eax
  802437:	01 c0                	add    %eax,%eax
  802439:	01 d0                	add    %edx,%eax
  80243b:	c1 e0 02             	shl    $0x2,%eax
  80243e:	05 44 20 81 00       	add    $0x812044,%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802448:	75 08                	jne    802452 <smalloc+0x9f>
        {
            exactIdx = i;
  80244a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802450:	eb 5b                	jmp    8024ad <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802452:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802455:	89 d0                	mov    %edx,%eax
  802457:	01 c0                	add    %eax,%eax
  802459:	01 d0                	add    %edx,%eax
  80245b:	c1 e0 02             	shl    $0x2,%eax
  80245e:	05 48 20 81 00       	add    $0x812048,%eax
  802463:	8a 00                	mov    (%eax),%al
  802465:	84 c0                	test   %al,%al
  802467:	74 34                	je     80249d <smalloc+0xea>
  802469:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80246c:	89 d0                	mov    %edx,%eax
  80246e:	01 c0                	add    %eax,%eax
  802470:	01 d0                	add    %edx,%eax
  802472:	c1 e0 02             	shl    $0x2,%eax
  802475:	05 44 20 81 00       	add    $0x812044,%eax
  80247a:	8b 00                	mov    (%eax),%eax
  80247c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80247f:	76 1c                	jbe    80249d <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802481:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802484:	89 d0                	mov    %edx,%eax
  802486:	01 c0                	add    %eax,%eax
  802488:	01 d0                	add    %edx,%eax
  80248a:	c1 e0 02             	shl    $0x2,%eax
  80248d:	05 44 20 81 00       	add    $0x812044,%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80249a:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80249d:	ff 45 e8             	incl   -0x18(%ebp)
  8024a0:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8024a7:	0f 8e 6e ff ff ff    	jle    80241b <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8024ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8024b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8024b8:	74 7d                	je     802537 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8024ba:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8024c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c4:	89 d0                	mov    %edx,%eax
  8024c6:	01 c0                	add    %eax,%eax
  8024c8:	01 d0                	add    %edx,%eax
  8024ca:	c1 e0 02             	shl    $0x2,%eax
  8024cd:	05 40 20 81 00       	add    $0x812040,%eax
  8024d2:	8b 10                	mov    (%eax),%edx
  8024d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024d7:	01 d0                	add    %edx,%eax
  8024d9:	48                   	dec    %eax
  8024da:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8024dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e5:	f7 75 bc             	divl   -0x44(%ebp)
  8024e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024eb:	29 d0                	sub    %edx,%eax
  8024ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8024f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f3:	89 d0                	mov    %edx,%eax
  8024f5:	01 c0                	add    %eax,%eax
  8024f7:	01 d0                	add    %edx,%eax
  8024f9:	c1 e0 02             	shl    $0x2,%eax
  8024fc:	05 48 20 81 00       	add    $0x812048,%eax
  802501:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802507:	89 d0                	mov    %edx,%eax
  802509:	01 c0                	add    %eax,%eax
  80250b:	01 d0                	add    %edx,%eax
  80250d:	c1 e0 02             	shl    $0x2,%eax
  802510:	05 44 20 81 00       	add    $0x812044,%eax
  802515:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80251b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251e:	89 d0                	mov    %edx,%eax
  802520:	01 c0                	add    %eax,%eax
  802522:	01 d0                	add    %edx,%eax
  802524:	c1 e0 02             	shl    $0x2,%eax
  802527:	05 40 20 81 00       	add    $0x812040,%eax
  80252c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802532:	e9 2d 01 00 00       	jmp    802664 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802537:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80253b:	0f 84 ce 00 00 00    	je     80260f <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802541:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254b:	89 d0                	mov    %edx,%eax
  80254d:	01 c0                	add    %eax,%eax
  80254f:	01 d0                	add    %edx,%eax
  802551:	c1 e0 02             	shl    $0x2,%eax
  802554:	05 40 20 81 00       	add    $0x812040,%eax
  802559:	8b 10                	mov    (%eax),%edx
  80255b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80255e:	01 d0                	add    %edx,%eax
  802560:	48                   	dec    %eax
  802561:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802564:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802567:	ba 00 00 00 00       	mov    $0x0,%edx
  80256c:	f7 75 c4             	divl   -0x3c(%ebp)
  80256f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802572:	29 d0                	sub    %edx,%eax
  802574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802577:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257a:	89 d0                	mov    %edx,%eax
  80257c:	01 c0                	add    %eax,%eax
  80257e:	01 d0                	add    %edx,%eax
  802580:	c1 e0 02             	shl    $0x2,%eax
  802583:	05 44 20 81 00       	add    $0x812044,%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80258d:	75 47                	jne    8025d6 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80258f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802592:	89 d0                	mov    %edx,%eax
  802594:	01 c0                	add    %eax,%eax
  802596:	01 d0                	add    %edx,%eax
  802598:	c1 e0 02             	shl    $0x2,%eax
  80259b:	05 48 20 81 00       	add    $0x812048,%eax
  8025a0:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8025a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a6:	89 d0                	mov    %edx,%eax
  8025a8:	01 c0                	add    %eax,%eax
  8025aa:	01 d0                	add    %edx,%eax
  8025ac:	c1 e0 02             	shl    $0x2,%eax
  8025af:	05 44 20 81 00       	add    $0x812044,%eax
  8025b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8025ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025bd:	89 d0                	mov    %edx,%eax
  8025bf:	01 c0                	add    %eax,%eax
  8025c1:	01 d0                	add    %edx,%eax
  8025c3:	c1 e0 02             	shl    $0x2,%eax
  8025c6:	05 40 20 81 00       	add    $0x812040,%eax
  8025cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d1:	e9 8e 00 00 00       	jmp    802664 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8025d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025dc:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8025df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e2:	89 d0                	mov    %edx,%eax
  8025e4:	01 c0                	add    %eax,%eax
  8025e6:	01 d0                	add    %edx,%eax
  8025e8:	c1 e0 02             	shl    $0x2,%eax
  8025eb:	05 40 20 81 00       	add    $0x812040,%eax
  8025f0:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8025f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f5:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8025f8:	89 c2                	mov    %eax,%edx
  8025fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025fd:	89 c8                	mov    %ecx,%eax
  8025ff:	01 c0                	add    %eax,%eax
  802601:	01 c8                	add    %ecx,%eax
  802603:	c1 e0 02             	shl    $0x2,%eax
  802606:	05 44 20 81 00       	add    $0x812044,%eax
  80260b:	89 10                	mov    %edx,(%eax)
  80260d:	eb 55                	jmp    802664 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80260f:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802616:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80261c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80261f:	01 d0                	add    %edx,%eax
  802621:	48                   	dec    %eax
  802622:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802625:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802628:	ba 00 00 00 00       	mov    $0x0,%edx
  80262d:	f7 75 d0             	divl   -0x30(%ebp)
  802630:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802633:	29 d0                	sub    %edx,%eax
  802635:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802638:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80263b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80263e:	01 d0                	add    %edx,%eax
  802640:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802645:	76 0a                	jbe    802651 <smalloc+0x29e>
            return NULL;
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
  80264c:	e9 ba 00 00 00       	jmp    80270b <smalloc+0x358>
        va = start;
  802651:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802654:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802657:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80265a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80265d:	01 d0                	add    %edx,%eax
  80265f:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802664:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80266b:	eb 5e                	jmp    8026cb <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  80266d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802670:	89 d0                	mov    %edx,%eax
  802672:	01 c0                	add    %eax,%eax
  802674:	01 d0                	add    %edx,%eax
  802676:	c1 e0 02             	shl    $0x2,%eax
  802679:	05 48 60 80 00       	add    $0x806048,%eax
  80267e:	8a 00                	mov    (%eax),%al
  802680:	84 c0                	test   %al,%al
  802682:	75 44                	jne    8026c8 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802684:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802687:	89 d0                	mov    %edx,%eax
  802689:	01 c0                	add    %eax,%eax
  80268b:	01 d0                	add    %edx,%eax
  80268d:	c1 e0 02             	shl    $0x2,%eax
  802690:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802699:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80269b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80269e:	89 d0                	mov    %edx,%eax
  8026a0:	01 c0                	add    %eax,%eax
  8026a2:	01 d0                	add    %edx,%eax
  8026a4:	c1 e0 02             	shl    $0x2,%eax
  8026a7:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8026ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8026b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026b5:	89 d0                	mov    %edx,%eax
  8026b7:	01 c0                	add    %eax,%eax
  8026b9:	01 d0                	add    %edx,%eax
  8026bb:	c1 e0 02             	shl    $0x2,%eax
  8026be:	05 48 60 80 00       	add    $0x806048,%eax
  8026c3:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8026c6:	eb 0c                	jmp    8026d4 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8026c8:	ff 45 e0             	incl   -0x20(%ebp)
  8026cb:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8026d2:	7e 99                	jle    80266d <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8026d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026d7:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8026db:	52                   	push   %edx
  8026dc:	50                   	push   %eax
  8026dd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8026e0:	ff 75 08             	pushl  0x8(%ebp)
  8026e3:	e8 de 0e 00 00       	call   8035c6 <sys_create_shared_object>
  8026e8:	83 c4 10             	add    $0x10,%esp
  8026eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8026ee:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8026f2:	75 07                	jne    8026fb <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8026f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8026f9:	eb 10                	jmp    80270b <smalloc+0x358>
    if (r < 0)
  8026fb:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8026ff:	79 07                	jns    802708 <smalloc+0x355>
        return NULL;
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
  802706:	eb 03                	jmp    80270b <smalloc+0x358>
    return (void*)va;
  802708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
  802710:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802713:	e8 51 f4 ff ff       	call   801b69 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802718:	83 ec 08             	sub    $0x8,%esp
  80271b:	ff 75 0c             	pushl  0xc(%ebp)
  80271e:	ff 75 08             	pushl  0x8(%ebp)
  802721:	e8 ca 0e 00 00       	call   8035f0 <sys_size_of_shared_object>
  802726:	83 c4 10             	add    $0x10,%esp
  802729:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80272c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802730:	7f 0a                	jg     80273c <sget+0x2f>
        return NULL;
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
  802737:	e9 28 03 00 00       	jmp    802a64 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80273c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802743:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802746:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802749:	01 d0                	add    %edx,%eax
  80274b:	48                   	dec    %eax
  80274c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80274f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802752:	ba 00 00 00 00       	mov    $0x0,%edx
  802757:	f7 75 d8             	divl   -0x28(%ebp)
  80275a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80275d:	29 d0                	sub    %edx,%eax
  80275f:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802762:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802769:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802770:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802777:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80277e:	e9 85 00 00 00       	jmp    802808 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802783:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802786:	89 d0                	mov    %edx,%eax
  802788:	01 c0                	add    %eax,%eax
  80278a:	01 d0                	add    %edx,%eax
  80278c:	c1 e0 02             	shl    $0x2,%eax
  80278f:	05 48 20 81 00       	add    $0x812048,%eax
  802794:	8a 00                	mov    (%eax),%al
  802796:	84 c0                	test   %al,%al
  802798:	74 20                	je     8027ba <sget+0xad>
  80279a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80279d:	89 d0                	mov    %edx,%eax
  80279f:	01 c0                	add    %eax,%eax
  8027a1:	01 d0                	add    %edx,%eax
  8027a3:	c1 e0 02             	shl    $0x2,%eax
  8027a6:	05 44 20 81 00       	add    $0x812044,%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8027b0:	75 08                	jne    8027ba <sget+0xad>
        {
            exactIdx = i;
  8027b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8027b8:	eb 5b                	jmp    802815 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8027ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027bd:	89 d0                	mov    %edx,%eax
  8027bf:	01 c0                	add    %eax,%eax
  8027c1:	01 d0                	add    %edx,%eax
  8027c3:	c1 e0 02             	shl    $0x2,%eax
  8027c6:	05 48 20 81 00       	add    $0x812048,%eax
  8027cb:	8a 00                	mov    (%eax),%al
  8027cd:	84 c0                	test   %al,%al
  8027cf:	74 34                	je     802805 <sget+0xf8>
  8027d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027d4:	89 d0                	mov    %edx,%eax
  8027d6:	01 c0                	add    %eax,%eax
  8027d8:	01 d0                	add    %edx,%eax
  8027da:	c1 e0 02             	shl    $0x2,%eax
  8027dd:	05 44 20 81 00       	add    $0x812044,%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027e7:	76 1c                	jbe    802805 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8027e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ec:	89 d0                	mov    %edx,%eax
  8027ee:	01 c0                	add    %eax,%eax
  8027f0:	01 d0                	add    %edx,%eax
  8027f2:	c1 e0 02             	shl    $0x2,%eax
  8027f5:	05 44 20 81 00       	add    $0x812044,%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8027ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802802:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802805:	ff 45 e8             	incl   -0x18(%ebp)
  802808:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80280f:	0f 8e 6e ff ff ff    	jle    802783 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80281c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802820:	74 7d                	je     80289f <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802822:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282c:	89 d0                	mov    %edx,%eax
  80282e:	01 c0                	add    %eax,%eax
  802830:	01 d0                	add    %edx,%eax
  802832:	c1 e0 02             	shl    $0x2,%eax
  802835:	05 40 20 81 00       	add    $0x812040,%eax
  80283a:	8b 10                	mov    (%eax),%edx
  80283c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80283f:	01 d0                	add    %edx,%eax
  802841:	48                   	dec    %eax
  802842:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802845:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802848:	ba 00 00 00 00       	mov    $0x0,%edx
  80284d:	f7 75 b8             	divl   -0x48(%ebp)
  802850:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802853:	29 d0                	sub    %edx,%eax
  802855:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285b:	89 d0                	mov    %edx,%eax
  80285d:	01 c0                	add    %eax,%eax
  80285f:	01 d0                	add    %edx,%eax
  802861:	c1 e0 02             	shl    $0x2,%eax
  802864:	05 48 20 81 00       	add    $0x812048,%eax
  802869:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80286c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286f:	89 d0                	mov    %edx,%eax
  802871:	01 c0                	add    %eax,%eax
  802873:	01 d0                	add    %edx,%eax
  802875:	c1 e0 02             	shl    $0x2,%eax
  802878:	05 44 20 81 00       	add    $0x812044,%eax
  80287d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802886:	89 d0                	mov    %edx,%eax
  802888:	01 c0                	add    %eax,%eax
  80288a:	01 d0                	add    %edx,%eax
  80288c:	c1 e0 02             	shl    $0x2,%eax
  80288f:	05 40 20 81 00       	add    $0x812040,%eax
  802894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289a:	e9 2d 01 00 00       	jmp    8029cc <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80289f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8028a3:	0f 84 ce 00 00 00    	je     802977 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8028a9:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8028b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b3:	89 d0                	mov    %edx,%eax
  8028b5:	01 c0                	add    %eax,%eax
  8028b7:	01 d0                	add    %edx,%eax
  8028b9:	c1 e0 02             	shl    $0x2,%eax
  8028bc:	05 40 20 81 00       	add    $0x812040,%eax
  8028c1:	8b 10                	mov    (%eax),%edx
  8028c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028c6:	01 d0                	add    %edx,%eax
  8028c8:	48                   	dec    %eax
  8028c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8028cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d4:	f7 75 c0             	divl   -0x40(%ebp)
  8028d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028da:	29 d0                	sub    %edx,%eax
  8028dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8028df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e2:	89 d0                	mov    %edx,%eax
  8028e4:	01 c0                	add    %eax,%eax
  8028e6:	01 d0                	add    %edx,%eax
  8028e8:	c1 e0 02             	shl    $0x2,%eax
  8028eb:	05 44 20 81 00       	add    $0x812044,%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8028f5:	75 47                	jne    80293e <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8028f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028fa:	89 d0                	mov    %edx,%eax
  8028fc:	01 c0                	add    %eax,%eax
  8028fe:	01 d0                	add    %edx,%eax
  802900:	c1 e0 02             	shl    $0x2,%eax
  802903:	05 48 20 81 00       	add    $0x812048,%eax
  802908:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80290b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80290e:	89 d0                	mov    %edx,%eax
  802910:	01 c0                	add    %eax,%eax
  802912:	01 d0                	add    %edx,%eax
  802914:	c1 e0 02             	shl    $0x2,%eax
  802917:	05 44 20 81 00       	add    $0x812044,%eax
  80291c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802922:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802925:	89 d0                	mov    %edx,%eax
  802927:	01 c0                	add    %eax,%eax
  802929:	01 d0                	add    %edx,%eax
  80292b:	c1 e0 02             	shl    $0x2,%eax
  80292e:	05 40 20 81 00       	add    $0x812040,%eax
  802933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802939:	e9 8e 00 00 00       	jmp    8029cc <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80293e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802941:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802944:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802947:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294a:	89 d0                	mov    %edx,%eax
  80294c:	01 c0                	add    %eax,%eax
  80294e:	01 d0                	add    %edx,%eax
  802950:	c1 e0 02             	shl    $0x2,%eax
  802953:	05 40 20 81 00       	add    $0x812040,%eax
  802958:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80295a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295d:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802960:	89 c2                	mov    %eax,%edx
  802962:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802965:	89 c8                	mov    %ecx,%eax
  802967:	01 c0                	add    %eax,%eax
  802969:	01 c8                	add    %ecx,%eax
  80296b:	c1 e0 02             	shl    $0x2,%eax
  80296e:	05 44 20 81 00       	add    $0x812044,%eax
  802973:	89 10                	mov    %edx,(%eax)
  802975:	eb 55                	jmp    8029cc <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802977:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80297e:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802984:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802987:	01 d0                	add    %edx,%eax
  802989:	48                   	dec    %eax
  80298a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80298d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802990:	ba 00 00 00 00       	mov    $0x0,%edx
  802995:	f7 75 cc             	divl   -0x34(%ebp)
  802998:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80299b:	29 d0                	sub    %edx,%eax
  80299d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8029a0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8029a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029a6:	01 d0                	add    %edx,%eax
  8029a8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8029ad:	76 0a                	jbe    8029b9 <sget+0x2ac>
            return NULL;
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b4:	e9 ab 00 00 00       	jmp    802a64 <sget+0x357>
        va = start;
  8029b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8029bf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8029c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c5:	01 d0                	add    %edx,%eax
  8029c7:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8029d3:	eb 5e                	jmp    802a33 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8029d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029d8:	89 d0                	mov    %edx,%eax
  8029da:	01 c0                	add    %eax,%eax
  8029dc:	01 d0                	add    %edx,%eax
  8029de:	c1 e0 02             	shl    $0x2,%eax
  8029e1:	05 48 60 80 00       	add    $0x806048,%eax
  8029e6:	8a 00                	mov    (%eax),%al
  8029e8:	84 c0                	test   %al,%al
  8029ea:	75 44                	jne    802a30 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8029ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029ef:	89 d0                	mov    %edx,%eax
  8029f1:	01 c0                	add    %eax,%eax
  8029f3:	01 d0                	add    %edx,%eax
  8029f5:	c1 e0 02             	shl    $0x2,%eax
  8029f8:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  8029fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a01:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802a03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a06:	89 d0                	mov    %edx,%eax
  802a08:	01 c0                	add    %eax,%eax
  802a0a:	01 d0                	add    %edx,%eax
  802a0c:	c1 e0 02             	shl    $0x2,%eax
  802a0f:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802a15:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a18:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802a1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a1d:	89 d0                	mov    %edx,%eax
  802a1f:	01 c0                	add    %eax,%eax
  802a21:	01 d0                	add    %edx,%eax
  802a23:	c1 e0 02             	shl    $0x2,%eax
  802a26:	05 48 60 80 00       	add    $0x806048,%eax
  802a2b:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802a2e:	eb 0c                	jmp    802a3c <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a30:	ff 45 e0             	incl   -0x20(%ebp)
  802a33:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802a3a:	7e 99                	jle    8029d5 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	50                   	push   %eax
  802a43:	ff 75 0c             	pushl  0xc(%ebp)
  802a46:	ff 75 08             	pushl  0x8(%ebp)
  802a49:	e8 bf 0b 00 00       	call   80360d <sys_get_shared_object>
  802a4e:	83 c4 10             	add    $0x10,%esp
  802a51:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802a54:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a58:	79 07                	jns    802a61 <sget+0x354>
        return NULL;
  802a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5f:	eb 03                	jmp    802a64 <sget+0x357>
    return (void*)va;
  802a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802a64:	c9                   	leave  
  802a65:	c3                   	ret    

00802a66 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a66:	55                   	push   %ebp
  802a67:	89 e5                	mov    %esp,%ebp
  802a69:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a6c:	e8 f8 f0 ff ff       	call   801b69 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802a71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a75:	75 13                	jne    802a8a <realloc+0x24>
		return malloc(new_size);
  802a77:	83 ec 0c             	sub    $0xc,%esp
  802a7a:	ff 75 0c             	pushl  0xc(%ebp)
  802a7d:	e8 c4 f1 ff ff       	call   801c46 <malloc>
  802a82:	83 c4 10             	add    $0x10,%esp
  802a85:	e9 f4 05 00 00       	jmp    80307e <realloc+0x618>
	if (new_size == 0)
  802a8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a8e:	75 18                	jne    802aa8 <realloc+0x42>
	{
		free(virtual_address);
  802a90:	83 ec 0c             	sub    $0xc,%esp
  802a93:	ff 75 08             	pushl  0x8(%ebp)
  802a96:	e8 0b f5 ff ff       	call   801fa6 <free>
  802a9b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa3:	e9 d6 05 00 00       	jmp    80307e <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802aae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	79 74                	jns    802b29 <realloc+0xc3>
  802ab5:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802abc:	77 6b                	ja     802b29 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802abe:	83 ec 0c             	sub    $0xc,%esp
  802ac1:	ff 75 0c             	pushl  0xc(%ebp)
  802ac4:	e8 7d f1 ff ff       	call   801c46 <malloc>
  802ac9:	83 c4 10             	add    $0x10,%esp
  802acc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802acf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802ad3:	75 0a                	jne    802adf <realloc+0x79>
			return NULL;
  802ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  802ada:	e9 9f 05 00 00       	jmp    80307e <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802adf:	83 ec 0c             	sub    $0xc,%esp
  802ae2:	ff 75 08             	pushl  0x8(%ebp)
  802ae5:	e8 e0 11 00 00       	call   803cca <get_block_size>
  802aea:	83 c4 10             	add    $0x10,%esp
  802aed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802af0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af6:	39 d0                	cmp    %edx,%eax
  802af8:	76 02                	jbe    802afc <realloc+0x96>
  802afa:	89 d0                	mov    %edx,%eax
  802afc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	ff 75 c0             	pushl  -0x40(%ebp)
  802b05:	ff 75 08             	pushl  0x8(%ebp)
  802b08:	ff 75 c8             	pushl  -0x38(%ebp)
  802b0b:	e8 56 eb ff ff       	call   801666 <memmove>
  802b10:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802b13:	83 ec 0c             	sub    $0xc,%esp
  802b16:	ff 75 08             	pushl  0x8(%ebp)
  802b19:	e8 88 f4 ff ff       	call   801fa6 <free>
  802b1e:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802b21:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b24:	e9 55 05 00 00       	jmp    80307e <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802b29:	a1 30 61 83 00       	mov    0x836130,%eax
  802b2e:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802b31:	72 09                	jb     802b3c <realloc+0xd6>
  802b33:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802b3a:	76 0a                	jbe    802b46 <realloc+0xe0>
		return NULL;
  802b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b41:	e9 38 05 00 00       	jmp    80307e <realloc+0x618>
	uint32 oldsz = 0;
  802b46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802b4d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b5b:	eb 50                	jmp    802bad <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b60:	89 d0                	mov    %edx,%eax
  802b62:	01 c0                	add    %eax,%eax
  802b64:	01 d0                	add    %edx,%eax
  802b66:	c1 e0 02             	shl    $0x2,%eax
  802b69:	05 48 60 80 00       	add    $0x806048,%eax
  802b6e:	8a 00                	mov    (%eax),%al
  802b70:	84 c0                	test   %al,%al
  802b72:	74 36                	je     802baa <realloc+0x144>
  802b74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b77:	89 d0                	mov    %edx,%eax
  802b79:	01 c0                	add    %eax,%eax
  802b7b:	01 d0                	add    %edx,%eax
  802b7d:	c1 e0 02             	shl    $0x2,%eax
  802b80:	05 40 60 80 00       	add    $0x806040,%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802b8a:	75 1e                	jne    802baa <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802b8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b8f:	89 d0                	mov    %edx,%eax
  802b91:	01 c0                	add    %eax,%eax
  802b93:	01 d0                	add    %edx,%eax
  802b95:	c1 e0 02             	shl    $0x2,%eax
  802b98:	05 44 60 80 00       	add    $0x806044,%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802ba8:	eb 0c                	jmp    802bb6 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802baa:	ff 45 ec             	incl   -0x14(%ebp)
  802bad:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802bb4:	7e a7                	jle    802b5d <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802bb6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802bba:	75 0a                	jne    802bc6 <realloc+0x160>
		return NULL;
  802bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc1:	e9 b8 04 00 00       	jmp    80307e <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802bc6:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bd3:	01 d0                	add    %edx,%eax
  802bd5:	48                   	dec    %eax
  802bd6:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802bd9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  802be1:	f7 75 bc             	divl   -0x44(%ebp)
  802be4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802be7:	29 d0                	sub    %edx,%eax
  802be9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802bec:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802bf2:	75 08                	jne    802bfc <realloc+0x196>
		return virtual_address;
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	e9 82 04 00 00       	jmp    80307e <realloc+0x618>
	if (req < oldsz)
  802bfc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c02:	0f 83 cd 02 00 00    	jae    802ed5 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802c0e:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802c11:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c14:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c17:	01 d0                	add    %edx,%eax
  802c19:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802c1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1f:	89 d0                	mov    %edx,%eax
  802c21:	01 c0                	add    %eax,%eax
  802c23:	01 d0                	add    %edx,%eax
  802c25:	c1 e0 02             	shl    $0x2,%eax
  802c28:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802c2e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c31:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802c33:	83 ec 08             	sub    $0x8,%esp
  802c36:	ff 75 b0             	pushl  -0x50(%ebp)
  802c39:	ff 75 ac             	pushl  -0x54(%ebp)
  802c3c:	e8 e3 0c 00 00       	call   803924 <sys_free_user_mem>
  802c41:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802c44:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802c52:	eb 64                	jmp    802cb8 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802c54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c57:	89 d0                	mov    %edx,%eax
  802c59:	01 c0                	add    %eax,%eax
  802c5b:	01 d0                	add    %edx,%eax
  802c5d:	c1 e0 02             	shl    $0x2,%eax
  802c60:	05 48 20 81 00       	add    $0x812048,%eax
  802c65:	8a 00                	mov    (%eax),%al
  802c67:	84 c0                	test   %al,%al
  802c69:	75 4a                	jne    802cb5 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802c6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c6e:	89 d0                	mov    %edx,%eax
  802c70:	01 c0                	add    %eax,%eax
  802c72:	01 d0                	add    %edx,%eax
  802c74:	c1 e0 02             	shl    $0x2,%eax
  802c77:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802c7d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c80:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802c82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c85:	89 d0                	mov    %edx,%eax
  802c87:	01 c0                	add    %eax,%eax
  802c89:	01 d0                	add    %edx,%eax
  802c8b:	c1 e0 02             	shl    $0x2,%eax
  802c8e:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802c94:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c97:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802c99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c9c:	89 d0                	mov    %edx,%eax
  802c9e:	01 c0                	add    %eax,%eax
  802ca0:	01 d0                	add    %edx,%eax
  802ca2:	c1 e0 02             	shl    $0x2,%eax
  802ca5:	05 48 20 81 00       	add    $0x812048,%eax
  802caa:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802cb3:	eb 0c                	jmp    802cc1 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802cb5:	ff 45 e4             	incl   -0x1c(%ebp)
  802cb8:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802cbf:	7e 93                	jle    802c54 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802cc1:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802cc5:	0f 84 8d 01 00 00    	je     802e58 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ccb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802cd2:	e9 74 01 00 00       	jmp    802e4b <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802cd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cda:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802cdd:	0f 84 64 01 00 00    	je     802e47 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802ce3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ce6:	89 d0                	mov    %edx,%eax
  802ce8:	01 c0                	add    %eax,%eax
  802cea:	01 d0                	add    %edx,%eax
  802cec:	c1 e0 02             	shl    $0x2,%eax
  802cef:	05 48 20 81 00       	add    $0x812048,%eax
  802cf4:	8a 00                	mov    (%eax),%al
  802cf6:	84 c0                	test   %al,%al
  802cf8:	0f 84 4a 01 00 00    	je     802e48 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802cfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d01:	89 d0                	mov    %edx,%eax
  802d03:	01 c0                	add    %eax,%eax
  802d05:	01 d0                	add    %edx,%eax
  802d07:	c1 e0 02             	shl    $0x2,%eax
  802d0a:	05 40 20 81 00       	add    $0x812040,%eax
  802d0f:	8b 08                	mov    (%eax),%ecx
  802d11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d14:	89 d0                	mov    %edx,%eax
  802d16:	01 c0                	add    %eax,%eax
  802d18:	01 d0                	add    %edx,%eax
  802d1a:	c1 e0 02             	shl    $0x2,%eax
  802d1d:	05 44 20 81 00       	add    $0x812044,%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	01 c1                	add    %eax,%ecx
  802d26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d29:	89 d0                	mov    %edx,%eax
  802d2b:	01 c0                	add    %eax,%eax
  802d2d:	01 d0                	add    %edx,%eax
  802d2f:	c1 e0 02             	shl    $0x2,%eax
  802d32:	05 40 20 81 00       	add    $0x812040,%eax
  802d37:	8b 00                	mov    (%eax),%eax
  802d39:	39 c1                	cmp    %eax,%ecx
  802d3b:	75 7a                	jne    802db7 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802d3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d40:	89 d0                	mov    %edx,%eax
  802d42:	01 c0                	add    %eax,%eax
  802d44:	01 d0                	add    %edx,%eax
  802d46:	c1 e0 02             	shl    $0x2,%eax
  802d49:	05 40 20 81 00       	add    $0x812040,%eax
  802d4e:	8b 10                	mov    (%eax),%edx
  802d50:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802d53:	89 c8                	mov    %ecx,%eax
  802d55:	01 c0                	add    %eax,%eax
  802d57:	01 c8                	add    %ecx,%eax
  802d59:	c1 e0 02             	shl    $0x2,%eax
  802d5c:	05 40 20 81 00       	add    $0x812040,%eax
  802d61:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802d63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d66:	89 d0                	mov    %edx,%eax
  802d68:	01 c0                	add    %eax,%eax
  802d6a:	01 d0                	add    %edx,%eax
  802d6c:	c1 e0 02             	shl    $0x2,%eax
  802d6f:	05 44 20 81 00       	add    $0x812044,%eax
  802d74:	8b 08                	mov    (%eax),%ecx
  802d76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d79:	89 d0                	mov    %edx,%eax
  802d7b:	01 c0                	add    %eax,%eax
  802d7d:	01 d0                	add    %edx,%eax
  802d7f:	c1 e0 02             	shl    $0x2,%eax
  802d82:	05 44 20 81 00       	add    $0x812044,%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	01 c1                	add    %eax,%ecx
  802d8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d8e:	89 d0                	mov    %edx,%eax
  802d90:	01 c0                	add    %eax,%eax
  802d92:	01 d0                	add    %edx,%eax
  802d94:	c1 e0 02             	shl    $0x2,%eax
  802d97:	05 44 20 81 00       	add    $0x812044,%eax
  802d9c:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802d9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802da1:	89 d0                	mov    %edx,%eax
  802da3:	01 c0                	add    %eax,%eax
  802da5:	01 d0                	add    %edx,%eax
  802da7:	c1 e0 02             	shl    $0x2,%eax
  802daa:	05 48 20 81 00       	add    $0x812048,%eax
  802daf:	c6 00 00             	movb   $0x0,(%eax)
  802db2:	e9 91 00 00 00       	jmp    802e48 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802db7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dba:	89 d0                	mov    %edx,%eax
  802dbc:	01 c0                	add    %eax,%eax
  802dbe:	01 d0                	add    %edx,%eax
  802dc0:	c1 e0 02             	shl    $0x2,%eax
  802dc3:	05 40 20 81 00       	add    $0x812040,%eax
  802dc8:	8b 08                	mov    (%eax),%ecx
  802dca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dcd:	89 d0                	mov    %edx,%eax
  802dcf:	01 c0                	add    %eax,%eax
  802dd1:	01 d0                	add    %edx,%eax
  802dd3:	c1 e0 02             	shl    $0x2,%eax
  802dd6:	05 44 20 81 00       	add    $0x812044,%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	01 c1                	add    %eax,%ecx
  802ddf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802de2:	89 d0                	mov    %edx,%eax
  802de4:	01 c0                	add    %eax,%eax
  802de6:	01 d0                	add    %edx,%eax
  802de8:	c1 e0 02             	shl    $0x2,%eax
  802deb:	05 40 20 81 00       	add    $0x812040,%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	39 c1                	cmp    %eax,%ecx
  802df4:	75 52                	jne    802e48 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802df6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802df9:	89 d0                	mov    %edx,%eax
  802dfb:	01 c0                	add    %eax,%eax
  802dfd:	01 d0                	add    %edx,%eax
  802dff:	c1 e0 02             	shl    $0x2,%eax
  802e02:	05 44 20 81 00       	add    $0x812044,%eax
  802e07:	8b 08                	mov    (%eax),%ecx
  802e09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e0c:	89 d0                	mov    %edx,%eax
  802e0e:	01 c0                	add    %eax,%eax
  802e10:	01 d0                	add    %edx,%eax
  802e12:	c1 e0 02             	shl    $0x2,%eax
  802e15:	05 44 20 81 00       	add    $0x812044,%eax
  802e1a:	8b 00                	mov    (%eax),%eax
  802e1c:	01 c1                	add    %eax,%ecx
  802e1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e21:	89 d0                	mov    %edx,%eax
  802e23:	01 c0                	add    %eax,%eax
  802e25:	01 d0                	add    %edx,%eax
  802e27:	c1 e0 02             	shl    $0x2,%eax
  802e2a:	05 44 20 81 00       	add    $0x812044,%eax
  802e2f:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802e31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e34:	89 d0                	mov    %edx,%eax
  802e36:	01 c0                	add    %eax,%eax
  802e38:	01 d0                	add    %edx,%eax
  802e3a:	c1 e0 02             	shl    $0x2,%eax
  802e3d:	05 48 20 81 00       	add    $0x812048,%eax
  802e42:	c6 00 00             	movb   $0x0,(%eax)
  802e45:	eb 01                	jmp    802e48 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802e47:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e48:	ff 45 e0             	incl   -0x20(%ebp)
  802e4b:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e52:	0f 8e 7f fe ff ff    	jle    802cd7 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802e58:	a1 30 61 83 00       	mov    0x836130,%eax
  802e5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e60:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802e67:	eb 53                	jmp    802ebc <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802e69:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e6c:	89 d0                	mov    %edx,%eax
  802e6e:	01 c0                	add    %eax,%eax
  802e70:	01 d0                	add    %edx,%eax
  802e72:	c1 e0 02             	shl    $0x2,%eax
  802e75:	05 48 60 80 00       	add    $0x806048,%eax
  802e7a:	8a 00                	mov    (%eax),%al
  802e7c:	84 c0                	test   %al,%al
  802e7e:	74 39                	je     802eb9 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e80:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e83:	89 d0                	mov    %edx,%eax
  802e85:	01 c0                	add    %eax,%eax
  802e87:	01 d0                	add    %edx,%eax
  802e89:	c1 e0 02             	shl    $0x2,%eax
  802e8c:	05 40 60 80 00       	add    $0x806040,%eax
  802e91:	8b 08                	mov    (%eax),%ecx
  802e93:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e96:	89 d0                	mov    %edx,%eax
  802e98:	01 c0                	add    %eax,%eax
  802e9a:	01 d0                	add    %edx,%eax
  802e9c:	c1 e0 02             	shl    $0x2,%eax
  802e9f:	05 44 60 80 00       	add    $0x806044,%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	01 c8                	add    %ecx,%eax
  802ea8:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802eab:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802eae:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802eb1:	76 06                	jbe    802eb9 <realloc+0x453>
  802eb3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802eb6:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802eb9:	ff 45 d8             	incl   -0x28(%ebp)
  802ebc:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802ec3:	7e a4                	jle    802e69 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802ec5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec8:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	e9 a9 01 00 00       	jmp    80307e <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802ed5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	01 d0                	add    %edx,%eax
  802edd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802ee0:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ee7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802eee:	eb 57                	jmp    802f47 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802ef0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ef3:	89 d0                	mov    %edx,%eax
  802ef5:	01 c0                	add    %eax,%eax
  802ef7:	01 d0                	add    %edx,%eax
  802ef9:	c1 e0 02             	shl    $0x2,%eax
  802efc:	05 48 20 81 00       	add    $0x812048,%eax
  802f01:	8a 00                	mov    (%eax),%al
  802f03:	84 c0                	test   %al,%al
  802f05:	74 3d                	je     802f44 <realloc+0x4de>
  802f07:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f0a:	89 d0                	mov    %edx,%eax
  802f0c:	01 c0                	add    %eax,%eax
  802f0e:	01 d0                	add    %edx,%eax
  802f10:	c1 e0 02             	shl    $0x2,%eax
  802f13:	05 40 20 81 00       	add    $0x812040,%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f1d:	75 25                	jne    802f44 <realloc+0x4de>
  802f1f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f22:	89 d0                	mov    %edx,%eax
  802f24:	01 c0                	add    %eax,%eax
  802f26:	01 d0                	add    %edx,%eax
  802f28:	c1 e0 02             	shl    $0x2,%eax
  802f2b:	05 44 20 81 00       	add    $0x812044,%eax
  802f30:	8b 10                	mov    (%eax),%edx
  802f32:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f35:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802f38:	39 c2                	cmp    %eax,%edx
  802f3a:	72 08                	jb     802f44 <realloc+0x4de>
		{
			adjIdx = j; break;
  802f3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f3f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f42:	eb 0c                	jmp    802f50 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802f44:	ff 45 d0             	incl   -0x30(%ebp)
  802f47:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802f4e:	7e a0                	jle    802ef0 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802f50:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802f54:	0f 84 d6 00 00 00    	je     803030 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802f5a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f5d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802f60:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802f63:	83 ec 08             	sub    $0x8,%esp
  802f66:	ff 75 a0             	pushl  -0x60(%ebp)
  802f69:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f6c:	e8 cf 09 00 00       	call   803940 <sys_allocate_user_mem>
  802f71:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802f74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f77:	89 d0                	mov    %edx,%eax
  802f79:	01 c0                	add    %eax,%eax
  802f7b:	01 d0                	add    %edx,%eax
  802f7d:	c1 e0 02             	shl    $0x2,%eax
  802f80:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802f86:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f89:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802f8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f8e:	89 d0                	mov    %edx,%eax
  802f90:	01 c0                	add    %eax,%eax
  802f92:	01 d0                	add    %edx,%eax
  802f94:	c1 e0 02             	shl    $0x2,%eax
  802f97:	05 40 20 81 00       	add    $0x812040,%eax
  802f9c:	8b 10                	mov    (%eax),%edx
  802f9e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802fa1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802fa4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fa7:	89 d0                	mov    %edx,%eax
  802fa9:	01 c0                	add    %eax,%eax
  802fab:	01 d0                	add    %edx,%eax
  802fad:	c1 e0 02             	shl    $0x2,%eax
  802fb0:	05 40 20 81 00       	add    $0x812040,%eax
  802fb5:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802fb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fba:	89 d0                	mov    %edx,%eax
  802fbc:	01 c0                	add    %eax,%eax
  802fbe:	01 d0                	add    %edx,%eax
  802fc0:	c1 e0 02             	shl    $0x2,%eax
  802fc3:	05 44 20 81 00       	add    $0x812044,%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802fcd:	89 c2                	mov    %eax,%edx
  802fcf:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802fd2:	89 c8                	mov    %ecx,%eax
  802fd4:	01 c0                	add    %eax,%eax
  802fd6:	01 c8                	add    %ecx,%eax
  802fd8:	c1 e0 02             	shl    $0x2,%eax
  802fdb:	05 44 20 81 00       	add    $0x812044,%eax
  802fe0:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802fe2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fe5:	89 d0                	mov    %edx,%eax
  802fe7:	01 c0                	add    %eax,%eax
  802fe9:	01 d0                	add    %edx,%eax
  802feb:	c1 e0 02             	shl    $0x2,%eax
  802fee:	05 44 20 81 00       	add    $0x812044,%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	75 14                	jne    80300d <realloc+0x5a7>
  802ff9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ffc:	89 d0                	mov    %edx,%eax
  802ffe:	01 c0                	add    %eax,%eax
  803000:	01 d0                	add    %edx,%eax
  803002:	c1 e0 02             	shl    $0x2,%eax
  803005:	05 48 20 81 00       	add    $0x812048,%eax
  80300a:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  80300d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803010:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803013:	01 c2                	add    %eax,%edx
  803015:	a1 88 60 83 00       	mov    0x836088,%eax
  80301a:	39 c2                	cmp    %eax,%edx
  80301c:	76 0d                	jbe    80302b <realloc+0x5c5>
  80301e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803021:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803024:	01 d0                	add    %edx,%eax
  803026:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	eb 4e                	jmp    80307e <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  803030:	83 ec 0c             	sub    $0xc,%esp
  803033:	ff 75 0c             	pushl  0xc(%ebp)
  803036:	e8 0b ec ff ff       	call   801c46 <malloc>
  80303b:	83 c4 10             	add    $0x10,%esp
  80303e:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  803041:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  803045:	75 07                	jne    80304e <realloc+0x5e8>
		return NULL;
  803047:	b8 00 00 00 00       	mov    $0x0,%eax
  80304c:	eb 30                	jmp    80307e <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  80304e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803051:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803054:	39 d0                	cmp    %edx,%eax
  803056:	76 02                	jbe    80305a <realloc+0x5f4>
  803058:	89 d0                	mov    %edx,%eax
  80305a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80305d:	83 ec 04             	sub    $0x4,%esp
  803060:	50                   	push   %eax
  803061:	52                   	push   %edx
  803062:	ff 75 cc             	pushl  -0x34(%ebp)
  803065:	e8 cf 06 00 00       	call   803739 <sys_move_user_mem>
  80306a:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  80306d:	83 ec 0c             	sub    $0xc,%esp
  803070:	ff 75 08             	pushl  0x8(%ebp)
  803073:	e8 2e ef ff ff       	call   801fa6 <free>
  803078:	83 c4 10             	add    $0x10,%esp
	return newptr;
  80307b:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  80307e:	c9                   	leave  
  80307f:	c3                   	ret    

00803080 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803080:	55                   	push   %ebp
  803081:	89 e5                	mov    %esp,%ebp
  803083:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  80308c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803090:	0f 84 33 03 00 00    	je     8033c9 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  803096:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803099:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  80309e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8030a1:	83 ec 08             	sub    $0x8,%esp
  8030a4:	ff 75 08             	pushl  0x8(%ebp)
  8030a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8030aa:	e8 7d 05 00 00       	call   80362c <sys_delete_shared_object>
  8030af:	83 c4 10             	add    $0x10,%esp
  8030b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8030b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8030b9:	0f 88 0d 03 00 00    	js     8033cc <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8030bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8030c6:	e9 ef 02 00 00       	jmp    8033ba <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8030cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ce:	89 d0                	mov    %edx,%eax
  8030d0:	01 c0                	add    %eax,%eax
  8030d2:	01 d0                	add    %edx,%eax
  8030d4:	c1 e0 02             	shl    $0x2,%eax
  8030d7:	05 48 60 80 00       	add    $0x806048,%eax
  8030dc:	8a 00                	mov    (%eax),%al
  8030de:	84 c0                	test   %al,%al
  8030e0:	0f 84 d1 02 00 00    	je     8033b7 <sfree+0x337>
  8030e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e9:	89 d0                	mov    %edx,%eax
  8030eb:	01 c0                	add    %eax,%eax
  8030ed:	01 d0                	add    %edx,%eax
  8030ef:	c1 e0 02             	shl    $0x2,%eax
  8030f2:	05 40 60 80 00       	add    $0x806040,%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8030fc:	0f 85 b5 02 00 00    	jne    8033b7 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803105:	89 d0                	mov    %edx,%eax
  803107:	01 c0                	add    %eax,%eax
  803109:	01 d0                	add    %edx,%eax
  80310b:	c1 e0 02             	shl    $0x2,%eax
  80310e:	05 44 60 80 00       	add    $0x806044,%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80311b:	89 d0                	mov    %edx,%eax
  80311d:	01 c0                	add    %eax,%eax
  80311f:	01 d0                	add    %edx,%eax
  803121:	c1 e0 02             	shl    $0x2,%eax
  803124:	05 48 60 80 00       	add    $0x806048,%eax
  803129:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  80312c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803133:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80313a:	eb 64                	jmp    8031a0 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  80313c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80313f:	89 d0                	mov    %edx,%eax
  803141:	01 c0                	add    %eax,%eax
  803143:	01 d0                	add    %edx,%eax
  803145:	c1 e0 02             	shl    $0x2,%eax
  803148:	05 48 20 81 00       	add    $0x812048,%eax
  80314d:	8a 00                	mov    (%eax),%al
  80314f:	84 c0                	test   %al,%al
  803151:	75 4a                	jne    80319d <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  803153:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803156:	89 d0                	mov    %edx,%eax
  803158:	01 c0                	add    %eax,%eax
  80315a:	01 d0                	add    %edx,%eax
  80315c:	c1 e0 02             	shl    $0x2,%eax
  80315f:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  803165:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803168:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  80316a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80316d:	89 d0                	mov    %edx,%eax
  80316f:	01 c0                	add    %eax,%eax
  803171:	01 d0                	add    %edx,%eax
  803173:	c1 e0 02             	shl    $0x2,%eax
  803176:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  80317c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80317f:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  803181:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803184:	89 d0                	mov    %edx,%eax
  803186:	01 c0                	add    %eax,%eax
  803188:	01 d0                	add    %edx,%eax
  80318a:	c1 e0 02             	shl    $0x2,%eax
  80318d:	05 48 20 81 00       	add    $0x812048,%eax
  803192:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  803195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803198:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  80319b:	eb 0c                	jmp    8031a9 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80319d:	ff 45 ec             	incl   -0x14(%ebp)
  8031a0:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8031a7:	7e 93                	jle    80313c <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  8031a9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8031ad:	0f 84 8d 01 00 00    	je     803340 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8031b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8031ba:	e9 74 01 00 00       	jmp    803333 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031c5:	0f 84 64 01 00 00    	je     80332f <sfree+0x2af>
					if (uhp_frees[k].free)
  8031cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ce:	89 d0                	mov    %edx,%eax
  8031d0:	01 c0                	add    %eax,%eax
  8031d2:	01 d0                	add    %edx,%eax
  8031d4:	c1 e0 02             	shl    $0x2,%eax
  8031d7:	05 48 20 81 00       	add    $0x812048,%eax
  8031dc:	8a 00                	mov    (%eax),%al
  8031de:	84 c0                	test   %al,%al
  8031e0:	0f 84 4a 01 00 00    	je     803330 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8031e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e9:	89 d0                	mov    %edx,%eax
  8031eb:	01 c0                	add    %eax,%eax
  8031ed:	01 d0                	add    %edx,%eax
  8031ef:	c1 e0 02             	shl    $0x2,%eax
  8031f2:	05 40 20 81 00       	add    $0x812040,%eax
  8031f7:	8b 08                	mov    (%eax),%ecx
  8031f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fc:	89 d0                	mov    %edx,%eax
  8031fe:	01 c0                	add    %eax,%eax
  803200:	01 d0                	add    %edx,%eax
  803202:	c1 e0 02             	shl    $0x2,%eax
  803205:	05 44 20 81 00       	add    $0x812044,%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	01 c1                	add    %eax,%ecx
  80320e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803211:	89 d0                	mov    %edx,%eax
  803213:	01 c0                	add    %eax,%eax
  803215:	01 d0                	add    %edx,%eax
  803217:	c1 e0 02             	shl    $0x2,%eax
  80321a:	05 40 20 81 00       	add    $0x812040,%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	39 c1                	cmp    %eax,%ecx
  803223:	75 7a                	jne    80329f <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  803225:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803228:	89 d0                	mov    %edx,%eax
  80322a:	01 c0                	add    %eax,%eax
  80322c:	01 d0                	add    %edx,%eax
  80322e:	c1 e0 02             	shl    $0x2,%eax
  803231:	05 40 20 81 00       	add    $0x812040,%eax
  803236:	8b 10                	mov    (%eax),%edx
  803238:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80323b:	89 c8                	mov    %ecx,%eax
  80323d:	01 c0                	add    %eax,%eax
  80323f:	01 c8                	add    %ecx,%eax
  803241:	c1 e0 02             	shl    $0x2,%eax
  803244:	05 40 20 81 00       	add    $0x812040,%eax
  803249:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  80324b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324e:	89 d0                	mov    %edx,%eax
  803250:	01 c0                	add    %eax,%eax
  803252:	01 d0                	add    %edx,%eax
  803254:	c1 e0 02             	shl    $0x2,%eax
  803257:	05 44 20 81 00       	add    $0x812044,%eax
  80325c:	8b 08                	mov    (%eax),%ecx
  80325e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803261:	89 d0                	mov    %edx,%eax
  803263:	01 c0                	add    %eax,%eax
  803265:	01 d0                	add    %edx,%eax
  803267:	c1 e0 02             	shl    $0x2,%eax
  80326a:	05 44 20 81 00       	add    $0x812044,%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	01 c1                	add    %eax,%ecx
  803273:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803276:	89 d0                	mov    %edx,%eax
  803278:	01 c0                	add    %eax,%eax
  80327a:	01 d0                	add    %edx,%eax
  80327c:	c1 e0 02             	shl    $0x2,%eax
  80327f:	05 44 20 81 00       	add    $0x812044,%eax
  803284:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803286:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803289:	89 d0                	mov    %edx,%eax
  80328b:	01 c0                	add    %eax,%eax
  80328d:	01 d0                	add    %edx,%eax
  80328f:	c1 e0 02             	shl    $0x2,%eax
  803292:	05 48 20 81 00       	add    $0x812048,%eax
  803297:	c6 00 00             	movb   $0x0,(%eax)
  80329a:	e9 91 00 00 00       	jmp    803330 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80329f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032a2:	89 d0                	mov    %edx,%eax
  8032a4:	01 c0                	add    %eax,%eax
  8032a6:	01 d0                	add    %edx,%eax
  8032a8:	c1 e0 02             	shl    $0x2,%eax
  8032ab:	05 40 20 81 00       	add    $0x812040,%eax
  8032b0:	8b 08                	mov    (%eax),%ecx
  8032b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b5:	89 d0                	mov    %edx,%eax
  8032b7:	01 c0                	add    %eax,%eax
  8032b9:	01 d0                	add    %edx,%eax
  8032bb:	c1 e0 02             	shl    $0x2,%eax
  8032be:	05 44 20 81 00       	add    $0x812044,%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	01 c1                	add    %eax,%ecx
  8032c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ca:	89 d0                	mov    %edx,%eax
  8032cc:	01 c0                	add    %eax,%eax
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	c1 e0 02             	shl    $0x2,%eax
  8032d3:	05 40 20 81 00       	add    $0x812040,%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	39 c1                	cmp    %eax,%ecx
  8032dc:	75 52                	jne    803330 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  8032de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e1:	89 d0                	mov    %edx,%eax
  8032e3:	01 c0                	add    %eax,%eax
  8032e5:	01 d0                	add    %edx,%eax
  8032e7:	c1 e0 02             	shl    $0x2,%eax
  8032ea:	05 44 20 81 00       	add    $0x812044,%eax
  8032ef:	8b 08                	mov    (%eax),%ecx
  8032f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f4:	89 d0                	mov    %edx,%eax
  8032f6:	01 c0                	add    %eax,%eax
  8032f8:	01 d0                	add    %edx,%eax
  8032fa:	c1 e0 02             	shl    $0x2,%eax
  8032fd:	05 44 20 81 00       	add    $0x812044,%eax
  803302:	8b 00                	mov    (%eax),%eax
  803304:	01 c1                	add    %eax,%ecx
  803306:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803309:	89 d0                	mov    %edx,%eax
  80330b:	01 c0                	add    %eax,%eax
  80330d:	01 d0                	add    %edx,%eax
  80330f:	c1 e0 02             	shl    $0x2,%eax
  803312:	05 44 20 81 00       	add    $0x812044,%eax
  803317:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803319:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331c:	89 d0                	mov    %edx,%eax
  80331e:	01 c0                	add    %eax,%eax
  803320:	01 d0                	add    %edx,%eax
  803322:	c1 e0 02             	shl    $0x2,%eax
  803325:	05 48 20 81 00       	add    $0x812048,%eax
  80332a:	c6 00 00             	movb   $0x0,(%eax)
  80332d:	eb 01                	jmp    803330 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  80332f:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803330:	ff 45 e8             	incl   -0x18(%ebp)
  803333:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80333a:	0f 8e 7f fe ff ff    	jle    8031bf <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803340:	a1 30 61 83 00       	mov    0x836130,%eax
  803345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803348:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80334f:	eb 53                	jmp    8033a4 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803351:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803354:	89 d0                	mov    %edx,%eax
  803356:	01 c0                	add    %eax,%eax
  803358:	01 d0                	add    %edx,%eax
  80335a:	c1 e0 02             	shl    $0x2,%eax
  80335d:	05 48 60 80 00       	add    $0x806048,%eax
  803362:	8a 00                	mov    (%eax),%al
  803364:	84 c0                	test   %al,%al
  803366:	74 39                	je     8033a1 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803368:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80336b:	89 d0                	mov    %edx,%eax
  80336d:	01 c0                	add    %eax,%eax
  80336f:	01 d0                	add    %edx,%eax
  803371:	c1 e0 02             	shl    $0x2,%eax
  803374:	05 40 60 80 00       	add    $0x806040,%eax
  803379:	8b 08                	mov    (%eax),%ecx
  80337b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80337e:	89 d0                	mov    %edx,%eax
  803380:	01 c0                	add    %eax,%eax
  803382:	01 d0                	add    %edx,%eax
  803384:	c1 e0 02             	shl    $0x2,%eax
  803387:	05 44 60 80 00       	add    $0x806044,%eax
  80338c:	8b 00                	mov    (%eax),%eax
  80338e:	01 c8                	add    %ecx,%eax
  803390:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803393:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803396:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803399:	76 06                	jbe    8033a1 <sfree+0x321>
  80339b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80339e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8033a1:	ff 45 e0             	incl   -0x20(%ebp)
  8033a4:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8033ab:	7e a4                	jle    803351 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  8033ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b0:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  8033b5:	eb 16                	jmp    8033cd <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8033b7:	ff 45 f4             	incl   -0xc(%ebp)
  8033ba:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  8033c1:	0f 8e 04 fd ff ff    	jle    8030cb <sfree+0x4b>
  8033c7:	eb 04                	jmp    8033cd <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  8033c9:	90                   	nop
  8033ca:	eb 01                	jmp    8033cd <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  8033cc:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  8033cd:	c9                   	leave  
  8033ce:	c3                   	ret    

008033cf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8033cf:	55                   	push   %ebp
  8033d0:	89 e5                	mov    %esp,%ebp
  8033d2:	57                   	push   %edi
  8033d3:	56                   	push   %esi
  8033d4:	53                   	push   %ebx
  8033d5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033e4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8033e7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8033ea:	cd 30                	int    $0x30
  8033ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8033ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8033f2:	83 c4 10             	add    $0x10,%esp
  8033f5:	5b                   	pop    %ebx
  8033f6:	5e                   	pop    %esi
  8033f7:	5f                   	pop    %edi
  8033f8:	5d                   	pop    %ebp
  8033f9:	c3                   	ret    

008033fa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8033fa:	55                   	push   %ebp
  8033fb:	89 e5                	mov    %esp,%ebp
  8033fd:	83 ec 04             	sub    $0x4,%esp
  803400:	8b 45 10             	mov    0x10(%ebp),%eax
  803403:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803406:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803409:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	6a 00                	push   $0x0
  803412:	51                   	push   %ecx
  803413:	52                   	push   %edx
  803414:	ff 75 0c             	pushl  0xc(%ebp)
  803417:	50                   	push   %eax
  803418:	6a 00                	push   $0x0
  80341a:	e8 b0 ff ff ff       	call   8033cf <syscall>
  80341f:	83 c4 18             	add    $0x18,%esp
}
  803422:	90                   	nop
  803423:	c9                   	leave  
  803424:	c3                   	ret    

00803425 <sys_cgetc>:

int
sys_cgetc(void)
{
  803425:	55                   	push   %ebp
  803426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803428:	6a 00                	push   $0x0
  80342a:	6a 00                	push   $0x0
  80342c:	6a 00                	push   $0x0
  80342e:	6a 00                	push   $0x0
  803430:	6a 00                	push   $0x0
  803432:	6a 02                	push   $0x2
  803434:	e8 96 ff ff ff       	call   8033cf <syscall>
  803439:	83 c4 18             	add    $0x18,%esp
}
  80343c:	c9                   	leave  
  80343d:	c3                   	ret    

0080343e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80343e:	55                   	push   %ebp
  80343f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803441:	6a 00                	push   $0x0
  803443:	6a 00                	push   $0x0
  803445:	6a 00                	push   $0x0
  803447:	6a 00                	push   $0x0
  803449:	6a 00                	push   $0x0
  80344b:	6a 03                	push   $0x3
  80344d:	e8 7d ff ff ff       	call   8033cf <syscall>
  803452:	83 c4 18             	add    $0x18,%esp
}
  803455:	90                   	nop
  803456:	c9                   	leave  
  803457:	c3                   	ret    

00803458 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803458:	55                   	push   %ebp
  803459:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80345b:	6a 00                	push   $0x0
  80345d:	6a 00                	push   $0x0
  80345f:	6a 00                	push   $0x0
  803461:	6a 00                	push   $0x0
  803463:	6a 00                	push   $0x0
  803465:	6a 04                	push   $0x4
  803467:	e8 63 ff ff ff       	call   8033cf <syscall>
  80346c:	83 c4 18             	add    $0x18,%esp
}
  80346f:	90                   	nop
  803470:	c9                   	leave  
  803471:	c3                   	ret    

00803472 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803472:	55                   	push   %ebp
  803473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803475:	8b 55 0c             	mov    0xc(%ebp),%edx
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	6a 00                	push   $0x0
  80347d:	6a 00                	push   $0x0
  80347f:	6a 00                	push   $0x0
  803481:	52                   	push   %edx
  803482:	50                   	push   %eax
  803483:	6a 08                	push   $0x8
  803485:	e8 45 ff ff ff       	call   8033cf <syscall>
  80348a:	83 c4 18             	add    $0x18,%esp
}
  80348d:	c9                   	leave  
  80348e:	c3                   	ret    

0080348f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80348f:	55                   	push   %ebp
  803490:	89 e5                	mov    %esp,%ebp
  803492:	56                   	push   %esi
  803493:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803494:	8b 75 18             	mov    0x18(%ebp),%esi
  803497:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80349a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80349d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	56                   	push   %esi
  8034a4:	53                   	push   %ebx
  8034a5:	51                   	push   %ecx
  8034a6:	52                   	push   %edx
  8034a7:	50                   	push   %eax
  8034a8:	6a 09                	push   $0x9
  8034aa:	e8 20 ff ff ff       	call   8033cf <syscall>
  8034af:	83 c4 18             	add    $0x18,%esp
}
  8034b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034b5:	5b                   	pop    %ebx
  8034b6:	5e                   	pop    %esi
  8034b7:	5d                   	pop    %ebp
  8034b8:	c3                   	ret    

008034b9 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8034b9:	55                   	push   %ebp
  8034ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8034bc:	6a 00                	push   $0x0
  8034be:	6a 00                	push   $0x0
  8034c0:	6a 00                	push   $0x0
  8034c2:	6a 00                	push   $0x0
  8034c4:	ff 75 08             	pushl  0x8(%ebp)
  8034c7:	6a 0a                	push   $0xa
  8034c9:	e8 01 ff ff ff       	call   8033cf <syscall>
  8034ce:	83 c4 18             	add    $0x18,%esp
}
  8034d1:	c9                   	leave  
  8034d2:	c3                   	ret    

008034d3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8034d3:	55                   	push   %ebp
  8034d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8034d6:	6a 00                	push   $0x0
  8034d8:	6a 00                	push   $0x0
  8034da:	6a 00                	push   $0x0
  8034dc:	ff 75 0c             	pushl  0xc(%ebp)
  8034df:	ff 75 08             	pushl  0x8(%ebp)
  8034e2:	6a 0b                	push   $0xb
  8034e4:	e8 e6 fe ff ff       	call   8033cf <syscall>
  8034e9:	83 c4 18             	add    $0x18,%esp
}
  8034ec:	c9                   	leave  
  8034ed:	c3                   	ret    

008034ee <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8034ee:	55                   	push   %ebp
  8034ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8034f1:	6a 00                	push   $0x0
  8034f3:	6a 00                	push   $0x0
  8034f5:	6a 00                	push   $0x0
  8034f7:	6a 00                	push   $0x0
  8034f9:	6a 00                	push   $0x0
  8034fb:	6a 0c                	push   $0xc
  8034fd:	e8 cd fe ff ff       	call   8033cf <syscall>
  803502:	83 c4 18             	add    $0x18,%esp
}
  803505:	c9                   	leave  
  803506:	c3                   	ret    

00803507 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803507:	55                   	push   %ebp
  803508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80350a:	6a 00                	push   $0x0
  80350c:	6a 00                	push   $0x0
  80350e:	6a 00                	push   $0x0
  803510:	6a 00                	push   $0x0
  803512:	6a 00                	push   $0x0
  803514:	6a 0d                	push   $0xd
  803516:	e8 b4 fe ff ff       	call   8033cf <syscall>
  80351b:	83 c4 18             	add    $0x18,%esp
}
  80351e:	c9                   	leave  
  80351f:	c3                   	ret    

00803520 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803520:	55                   	push   %ebp
  803521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803523:	6a 00                	push   $0x0
  803525:	6a 00                	push   $0x0
  803527:	6a 00                	push   $0x0
  803529:	6a 00                	push   $0x0
  80352b:	6a 00                	push   $0x0
  80352d:	6a 0e                	push   $0xe
  80352f:	e8 9b fe ff ff       	call   8033cf <syscall>
  803534:	83 c4 18             	add    $0x18,%esp
}
  803537:	c9                   	leave  
  803538:	c3                   	ret    

00803539 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803539:	55                   	push   %ebp
  80353a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80353c:	6a 00                	push   $0x0
  80353e:	6a 00                	push   $0x0
  803540:	6a 00                	push   $0x0
  803542:	6a 00                	push   $0x0
  803544:	6a 00                	push   $0x0
  803546:	6a 0f                	push   $0xf
  803548:	e8 82 fe ff ff       	call   8033cf <syscall>
  80354d:	83 c4 18             	add    $0x18,%esp
}
  803550:	c9                   	leave  
  803551:	c3                   	ret    

00803552 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803552:	55                   	push   %ebp
  803553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803555:	6a 00                	push   $0x0
  803557:	6a 00                	push   $0x0
  803559:	6a 00                	push   $0x0
  80355b:	6a 00                	push   $0x0
  80355d:	ff 75 08             	pushl  0x8(%ebp)
  803560:	6a 10                	push   $0x10
  803562:	e8 68 fe ff ff       	call   8033cf <syscall>
  803567:	83 c4 18             	add    $0x18,%esp
}
  80356a:	c9                   	leave  
  80356b:	c3                   	ret    

0080356c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80356c:	55                   	push   %ebp
  80356d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80356f:	6a 00                	push   $0x0
  803571:	6a 00                	push   $0x0
  803573:	6a 00                	push   $0x0
  803575:	6a 00                	push   $0x0
  803577:	6a 00                	push   $0x0
  803579:	6a 11                	push   $0x11
  80357b:	e8 4f fe ff ff       	call   8033cf <syscall>
  803580:	83 c4 18             	add    $0x18,%esp
}
  803583:	90                   	nop
  803584:	c9                   	leave  
  803585:	c3                   	ret    

00803586 <sys_cputc>:

void
sys_cputc(const char c)
{
  803586:	55                   	push   %ebp
  803587:	89 e5                	mov    %esp,%ebp
  803589:	83 ec 04             	sub    $0x4,%esp
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803592:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803596:	6a 00                	push   $0x0
  803598:	6a 00                	push   $0x0
  80359a:	6a 00                	push   $0x0
  80359c:	6a 00                	push   $0x0
  80359e:	50                   	push   %eax
  80359f:	6a 01                	push   $0x1
  8035a1:	e8 29 fe ff ff       	call   8033cf <syscall>
  8035a6:	83 c4 18             	add    $0x18,%esp
}
  8035a9:	90                   	nop
  8035aa:	c9                   	leave  
  8035ab:	c3                   	ret    

008035ac <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8035ac:	55                   	push   %ebp
  8035ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8035af:	6a 00                	push   $0x0
  8035b1:	6a 00                	push   $0x0
  8035b3:	6a 00                	push   $0x0
  8035b5:	6a 00                	push   $0x0
  8035b7:	6a 00                	push   $0x0
  8035b9:	6a 14                	push   $0x14
  8035bb:	e8 0f fe ff ff       	call   8033cf <syscall>
  8035c0:	83 c4 18             	add    $0x18,%esp
}
  8035c3:	90                   	nop
  8035c4:	c9                   	leave  
  8035c5:	c3                   	ret    

008035c6 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8035c6:	55                   	push   %ebp
  8035c7:	89 e5                	mov    %esp,%ebp
  8035c9:	83 ec 04             	sub    $0x4,%esp
  8035cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8035cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8035d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8035d5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	6a 00                	push   $0x0
  8035de:	51                   	push   %ecx
  8035df:	52                   	push   %edx
  8035e0:	ff 75 0c             	pushl  0xc(%ebp)
  8035e3:	50                   	push   %eax
  8035e4:	6a 15                	push   $0x15
  8035e6:	e8 e4 fd ff ff       	call   8033cf <syscall>
  8035eb:	83 c4 18             	add    $0x18,%esp
}
  8035ee:	c9                   	leave  
  8035ef:	c3                   	ret    

008035f0 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8035f0:	55                   	push   %ebp
  8035f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8035f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	6a 00                	push   $0x0
  8035fb:	6a 00                	push   $0x0
  8035fd:	6a 00                	push   $0x0
  8035ff:	52                   	push   %edx
  803600:	50                   	push   %eax
  803601:	6a 16                	push   $0x16
  803603:	e8 c7 fd ff ff       	call   8033cf <syscall>
  803608:	83 c4 18             	add    $0x18,%esp
}
  80360b:	c9                   	leave  
  80360c:	c3                   	ret    

0080360d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80360d:	55                   	push   %ebp
  80360e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803610:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803613:	8b 55 0c             	mov    0xc(%ebp),%edx
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	6a 00                	push   $0x0
  80361b:	6a 00                	push   $0x0
  80361d:	51                   	push   %ecx
  80361e:	52                   	push   %edx
  80361f:	50                   	push   %eax
  803620:	6a 17                	push   $0x17
  803622:	e8 a8 fd ff ff       	call   8033cf <syscall>
  803627:	83 c4 18             	add    $0x18,%esp
}
  80362a:	c9                   	leave  
  80362b:	c3                   	ret    

0080362c <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80362c:	55                   	push   %ebp
  80362d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80362f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	6a 00                	push   $0x0
  803637:	6a 00                	push   $0x0
  803639:	6a 00                	push   $0x0
  80363b:	52                   	push   %edx
  80363c:	50                   	push   %eax
  80363d:	6a 18                	push   $0x18
  80363f:	e8 8b fd ff ff       	call   8033cf <syscall>
  803644:	83 c4 18             	add    $0x18,%esp
}
  803647:	c9                   	leave  
  803648:	c3                   	ret    

00803649 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803649:	55                   	push   %ebp
  80364a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	6a 00                	push   $0x0
  803651:	ff 75 14             	pushl  0x14(%ebp)
  803654:	ff 75 10             	pushl  0x10(%ebp)
  803657:	ff 75 0c             	pushl  0xc(%ebp)
  80365a:	50                   	push   %eax
  80365b:	6a 19                	push   $0x19
  80365d:	e8 6d fd ff ff       	call   8033cf <syscall>
  803662:	83 c4 18             	add    $0x18,%esp
}
  803665:	c9                   	leave  
  803666:	c3                   	ret    

00803667 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803667:	55                   	push   %ebp
  803668:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	6a 00                	push   $0x0
  80366f:	6a 00                	push   $0x0
  803671:	6a 00                	push   $0x0
  803673:	6a 00                	push   $0x0
  803675:	50                   	push   %eax
  803676:	6a 1a                	push   $0x1a
  803678:	e8 52 fd ff ff       	call   8033cf <syscall>
  80367d:	83 c4 18             	add    $0x18,%esp
}
  803680:	90                   	nop
  803681:	c9                   	leave  
  803682:	c3                   	ret    

00803683 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803683:	55                   	push   %ebp
  803684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803686:	8b 45 08             	mov    0x8(%ebp),%eax
  803689:	6a 00                	push   $0x0
  80368b:	6a 00                	push   $0x0
  80368d:	6a 00                	push   $0x0
  80368f:	6a 00                	push   $0x0
  803691:	50                   	push   %eax
  803692:	6a 1b                	push   $0x1b
  803694:	e8 36 fd ff ff       	call   8033cf <syscall>
  803699:	83 c4 18             	add    $0x18,%esp
}
  80369c:	c9                   	leave  
  80369d:	c3                   	ret    

0080369e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80369e:	55                   	push   %ebp
  80369f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8036a1:	6a 00                	push   $0x0
  8036a3:	6a 00                	push   $0x0
  8036a5:	6a 00                	push   $0x0
  8036a7:	6a 00                	push   $0x0
  8036a9:	6a 00                	push   $0x0
  8036ab:	6a 05                	push   $0x5
  8036ad:	e8 1d fd ff ff       	call   8033cf <syscall>
  8036b2:	83 c4 18             	add    $0x18,%esp
}
  8036b5:	c9                   	leave  
  8036b6:	c3                   	ret    

008036b7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8036b7:	55                   	push   %ebp
  8036b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8036ba:	6a 00                	push   $0x0
  8036bc:	6a 00                	push   $0x0
  8036be:	6a 00                	push   $0x0
  8036c0:	6a 00                	push   $0x0
  8036c2:	6a 00                	push   $0x0
  8036c4:	6a 06                	push   $0x6
  8036c6:	e8 04 fd ff ff       	call   8033cf <syscall>
  8036cb:	83 c4 18             	add    $0x18,%esp
}
  8036ce:	c9                   	leave  
  8036cf:	c3                   	ret    

008036d0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8036d0:	55                   	push   %ebp
  8036d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8036d3:	6a 00                	push   $0x0
  8036d5:	6a 00                	push   $0x0
  8036d7:	6a 00                	push   $0x0
  8036d9:	6a 00                	push   $0x0
  8036db:	6a 00                	push   $0x0
  8036dd:	6a 07                	push   $0x7
  8036df:	e8 eb fc ff ff       	call   8033cf <syscall>
  8036e4:	83 c4 18             	add    $0x18,%esp
}
  8036e7:	c9                   	leave  
  8036e8:	c3                   	ret    

008036e9 <sys_exit_env>:


void sys_exit_env(void)
{
  8036e9:	55                   	push   %ebp
  8036ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8036ec:	6a 00                	push   $0x0
  8036ee:	6a 00                	push   $0x0
  8036f0:	6a 00                	push   $0x0
  8036f2:	6a 00                	push   $0x0
  8036f4:	6a 00                	push   $0x0
  8036f6:	6a 1c                	push   $0x1c
  8036f8:	e8 d2 fc ff ff       	call   8033cf <syscall>
  8036fd:	83 c4 18             	add    $0x18,%esp
}
  803700:	90                   	nop
  803701:	c9                   	leave  
  803702:	c3                   	ret    

00803703 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803703:	55                   	push   %ebp
  803704:	89 e5                	mov    %esp,%ebp
  803706:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803709:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80370c:	8d 50 04             	lea    0x4(%eax),%edx
  80370f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803712:	6a 00                	push   $0x0
  803714:	6a 00                	push   $0x0
  803716:	6a 00                	push   $0x0
  803718:	52                   	push   %edx
  803719:	50                   	push   %eax
  80371a:	6a 1d                	push   $0x1d
  80371c:	e8 ae fc ff ff       	call   8033cf <syscall>
  803721:	83 c4 18             	add    $0x18,%esp
	return result;
  803724:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803727:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80372a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80372d:	89 01                	mov    %eax,(%ecx)
  80372f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	c9                   	leave  
  803736:	c2 04 00             	ret    $0x4

00803739 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803739:	55                   	push   %ebp
  80373a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80373c:	6a 00                	push   $0x0
  80373e:	6a 00                	push   $0x0
  803740:	ff 75 10             	pushl  0x10(%ebp)
  803743:	ff 75 0c             	pushl  0xc(%ebp)
  803746:	ff 75 08             	pushl  0x8(%ebp)
  803749:	6a 13                	push   $0x13
  80374b:	e8 7f fc ff ff       	call   8033cf <syscall>
  803750:	83 c4 18             	add    $0x18,%esp
	return ;
  803753:	90                   	nop
}
  803754:	c9                   	leave  
  803755:	c3                   	ret    

00803756 <sys_rcr2>:
uint32 sys_rcr2()
{
  803756:	55                   	push   %ebp
  803757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803759:	6a 00                	push   $0x0
  80375b:	6a 00                	push   $0x0
  80375d:	6a 00                	push   $0x0
  80375f:	6a 00                	push   $0x0
  803761:	6a 00                	push   $0x0
  803763:	6a 1e                	push   $0x1e
  803765:	e8 65 fc ff ff       	call   8033cf <syscall>
  80376a:	83 c4 18             	add    $0x18,%esp
}
  80376d:	c9                   	leave  
  80376e:	c3                   	ret    

0080376f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80376f:	55                   	push   %ebp
  803770:	89 e5                	mov    %esp,%ebp
  803772:	83 ec 04             	sub    $0x4,%esp
  803775:	8b 45 08             	mov    0x8(%ebp),%eax
  803778:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80377b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80377f:	6a 00                	push   $0x0
  803781:	6a 00                	push   $0x0
  803783:	6a 00                	push   $0x0
  803785:	6a 00                	push   $0x0
  803787:	50                   	push   %eax
  803788:	6a 1f                	push   $0x1f
  80378a:	e8 40 fc ff ff       	call   8033cf <syscall>
  80378f:	83 c4 18             	add    $0x18,%esp
	return ;
  803792:	90                   	nop
}
  803793:	c9                   	leave  
  803794:	c3                   	ret    

00803795 <rsttst>:
void rsttst()
{
  803795:	55                   	push   %ebp
  803796:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803798:	6a 00                	push   $0x0
  80379a:	6a 00                	push   $0x0
  80379c:	6a 00                	push   $0x0
  80379e:	6a 00                	push   $0x0
  8037a0:	6a 00                	push   $0x0
  8037a2:	6a 21                	push   $0x21
  8037a4:	e8 26 fc ff ff       	call   8033cf <syscall>
  8037a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8037ac:	90                   	nop
}
  8037ad:	c9                   	leave  
  8037ae:	c3                   	ret    

008037af <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8037af:	55                   	push   %ebp
  8037b0:	89 e5                	mov    %esp,%ebp
  8037b2:	83 ec 04             	sub    $0x4,%esp
  8037b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8037b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8037bb:	8b 55 18             	mov    0x18(%ebp),%edx
  8037be:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8037c2:	52                   	push   %edx
  8037c3:	50                   	push   %eax
  8037c4:	ff 75 10             	pushl  0x10(%ebp)
  8037c7:	ff 75 0c             	pushl  0xc(%ebp)
  8037ca:	ff 75 08             	pushl  0x8(%ebp)
  8037cd:	6a 20                	push   $0x20
  8037cf:	e8 fb fb ff ff       	call   8033cf <syscall>
  8037d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8037d7:	90                   	nop
}
  8037d8:	c9                   	leave  
  8037d9:	c3                   	ret    

008037da <chktst>:
void chktst(uint32 n)
{
  8037da:	55                   	push   %ebp
  8037db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8037dd:	6a 00                	push   $0x0
  8037df:	6a 00                	push   $0x0
  8037e1:	6a 00                	push   $0x0
  8037e3:	6a 00                	push   $0x0
  8037e5:	ff 75 08             	pushl  0x8(%ebp)
  8037e8:	6a 22                	push   $0x22
  8037ea:	e8 e0 fb ff ff       	call   8033cf <syscall>
  8037ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8037f2:	90                   	nop
}
  8037f3:	c9                   	leave  
  8037f4:	c3                   	ret    

008037f5 <inctst>:

void inctst()
{
  8037f5:	55                   	push   %ebp
  8037f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8037f8:	6a 00                	push   $0x0
  8037fa:	6a 00                	push   $0x0
  8037fc:	6a 00                	push   $0x0
  8037fe:	6a 00                	push   $0x0
  803800:	6a 00                	push   $0x0
  803802:	6a 23                	push   $0x23
  803804:	e8 c6 fb ff ff       	call   8033cf <syscall>
  803809:	83 c4 18             	add    $0x18,%esp
	return ;
  80380c:	90                   	nop
}
  80380d:	c9                   	leave  
  80380e:	c3                   	ret    

0080380f <gettst>:
uint32 gettst()
{
  80380f:	55                   	push   %ebp
  803810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803812:	6a 00                	push   $0x0
  803814:	6a 00                	push   $0x0
  803816:	6a 00                	push   $0x0
  803818:	6a 00                	push   $0x0
  80381a:	6a 00                	push   $0x0
  80381c:	6a 24                	push   $0x24
  80381e:	e8 ac fb ff ff       	call   8033cf <syscall>
  803823:	83 c4 18             	add    $0x18,%esp
}
  803826:	c9                   	leave  
  803827:	c3                   	ret    

00803828 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803828:	55                   	push   %ebp
  803829:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80382b:	6a 00                	push   $0x0
  80382d:	6a 00                	push   $0x0
  80382f:	6a 00                	push   $0x0
  803831:	6a 00                	push   $0x0
  803833:	6a 00                	push   $0x0
  803835:	6a 25                	push   $0x25
  803837:	e8 93 fb ff ff       	call   8033cf <syscall>
  80383c:	83 c4 18             	add    $0x18,%esp
  80383f:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  803844:	a1 80 60 83 00       	mov    0x836080,%eax
}
  803849:	c9                   	leave  
  80384a:	c3                   	ret    

0080384b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80384b:	55                   	push   %ebp
  80384c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803856:	6a 00                	push   $0x0
  803858:	6a 00                	push   $0x0
  80385a:	6a 00                	push   $0x0
  80385c:	6a 00                	push   $0x0
  80385e:	ff 75 08             	pushl  0x8(%ebp)
  803861:	6a 26                	push   $0x26
  803863:	e8 67 fb ff ff       	call   8033cf <syscall>
  803868:	83 c4 18             	add    $0x18,%esp
	return ;
  80386b:	90                   	nop
}
  80386c:	c9                   	leave  
  80386d:	c3                   	ret    

0080386e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80386e:	55                   	push   %ebp
  80386f:	89 e5                	mov    %esp,%ebp
  803871:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803872:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803875:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	6a 00                	push   $0x0
  803880:	53                   	push   %ebx
  803881:	51                   	push   %ecx
  803882:	52                   	push   %edx
  803883:	50                   	push   %eax
  803884:	6a 27                	push   $0x27
  803886:	e8 44 fb ff ff       	call   8033cf <syscall>
  80388b:	83 c4 18             	add    $0x18,%esp
}
  80388e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803891:	c9                   	leave  
  803892:	c3                   	ret    

00803893 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803893:	55                   	push   %ebp
  803894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803896:	8b 55 0c             	mov    0xc(%ebp),%edx
  803899:	8b 45 08             	mov    0x8(%ebp),%eax
  80389c:	6a 00                	push   $0x0
  80389e:	6a 00                	push   $0x0
  8038a0:	6a 00                	push   $0x0
  8038a2:	52                   	push   %edx
  8038a3:	50                   	push   %eax
  8038a4:	6a 28                	push   $0x28
  8038a6:	e8 24 fb ff ff       	call   8033cf <syscall>
  8038ab:	83 c4 18             	add    $0x18,%esp
}
  8038ae:	c9                   	leave  
  8038af:	c3                   	ret    

008038b0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8038b0:	55                   	push   %ebp
  8038b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8038b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8038b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	6a 00                	push   $0x0
  8038be:	51                   	push   %ecx
  8038bf:	ff 75 10             	pushl  0x10(%ebp)
  8038c2:	52                   	push   %edx
  8038c3:	50                   	push   %eax
  8038c4:	6a 29                	push   $0x29
  8038c6:	e8 04 fb ff ff       	call   8033cf <syscall>
  8038cb:	83 c4 18             	add    $0x18,%esp
}
  8038ce:	c9                   	leave  
  8038cf:	c3                   	ret    

008038d0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8038d0:	55                   	push   %ebp
  8038d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8038d3:	6a 00                	push   $0x0
  8038d5:	6a 00                	push   $0x0
  8038d7:	ff 75 10             	pushl  0x10(%ebp)
  8038da:	ff 75 0c             	pushl  0xc(%ebp)
  8038dd:	ff 75 08             	pushl  0x8(%ebp)
  8038e0:	6a 12                	push   $0x12
  8038e2:	e8 e8 fa ff ff       	call   8033cf <syscall>
  8038e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8038ea:	90                   	nop
}
  8038eb:	c9                   	leave  
  8038ec:	c3                   	ret    

008038ed <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8038ed:	55                   	push   %ebp
  8038ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8038f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f6:	6a 00                	push   $0x0
  8038f8:	6a 00                	push   $0x0
  8038fa:	6a 00                	push   $0x0
  8038fc:	52                   	push   %edx
  8038fd:	50                   	push   %eax
  8038fe:	6a 2a                	push   $0x2a
  803900:	e8 ca fa ff ff       	call   8033cf <syscall>
  803905:	83 c4 18             	add    $0x18,%esp
	return;
  803908:	90                   	nop
}
  803909:	c9                   	leave  
  80390a:	c3                   	ret    

0080390b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80390b:	55                   	push   %ebp
  80390c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80390e:	6a 00                	push   $0x0
  803910:	6a 00                	push   $0x0
  803912:	6a 00                	push   $0x0
  803914:	6a 00                	push   $0x0
  803916:	6a 00                	push   $0x0
  803918:	6a 2b                	push   $0x2b
  80391a:	e8 b0 fa ff ff       	call   8033cf <syscall>
  80391f:	83 c4 18             	add    $0x18,%esp
}
  803922:	c9                   	leave  
  803923:	c3                   	ret    

00803924 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803924:	55                   	push   %ebp
  803925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803927:	6a 00                	push   $0x0
  803929:	6a 00                	push   $0x0
  80392b:	6a 00                	push   $0x0
  80392d:	ff 75 0c             	pushl  0xc(%ebp)
  803930:	ff 75 08             	pushl  0x8(%ebp)
  803933:	6a 2d                	push   $0x2d
  803935:	e8 95 fa ff ff       	call   8033cf <syscall>
  80393a:	83 c4 18             	add    $0x18,%esp
	return;
  80393d:	90                   	nop
}
  80393e:	c9                   	leave  
  80393f:	c3                   	ret    

00803940 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803940:	55                   	push   %ebp
  803941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803943:	6a 00                	push   $0x0
  803945:	6a 00                	push   $0x0
  803947:	6a 00                	push   $0x0
  803949:	ff 75 0c             	pushl  0xc(%ebp)
  80394c:	ff 75 08             	pushl  0x8(%ebp)
  80394f:	6a 2c                	push   $0x2c
  803951:	e8 79 fa ff ff       	call   8033cf <syscall>
  803956:	83 c4 18             	add    $0x18,%esp
	return ;
  803959:	90                   	nop
}
  80395a:	c9                   	leave  
  80395b:	c3                   	ret    

0080395c <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80395c:	55                   	push   %ebp
  80395d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80395f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803962:	8b 45 08             	mov    0x8(%ebp),%eax
  803965:	6a 00                	push   $0x0
  803967:	6a 00                	push   $0x0
  803969:	6a 00                	push   $0x0
  80396b:	52                   	push   %edx
  80396c:	50                   	push   %eax
  80396d:	6a 2e                	push   $0x2e
  80396f:	e8 5b fa ff ff       	call   8033cf <syscall>
  803974:	83 c4 18             	add    $0x18,%esp
}
  803977:	90                   	nop
  803978:	c9                   	leave  
  803979:	c3                   	ret    

0080397a <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80397a:	55                   	push   %ebp
  80397b:	89 e5                	mov    %esp,%ebp
  80397d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803980:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803987:	72 09                	jb     803992 <to_page_va+0x18>
  803989:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803990:	72 14                	jb     8039a6 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803992:	83 ec 04             	sub    $0x4,%esp
  803995:	68 6c 4f 80 00       	push   $0x804f6c
  80399a:	6a 15                	push   $0x15
  80399c:	68 97 4f 80 00       	push   $0x804f97
  8039a1:	e8 08 ce ff ff       	call   8007ae <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8039a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a9:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  8039ae:	29 d0                	sub    %edx,%eax
  8039b0:	c1 f8 02             	sar    $0x2,%eax
  8039b3:	89 c2                	mov    %eax,%edx
  8039b5:	89 d0                	mov    %edx,%eax
  8039b7:	c1 e0 02             	shl    $0x2,%eax
  8039ba:	01 d0                	add    %edx,%eax
  8039bc:	c1 e0 02             	shl    $0x2,%eax
  8039bf:	01 d0                	add    %edx,%eax
  8039c1:	c1 e0 02             	shl    $0x2,%eax
  8039c4:	01 d0                	add    %edx,%eax
  8039c6:	89 c1                	mov    %eax,%ecx
  8039c8:	c1 e1 08             	shl    $0x8,%ecx
  8039cb:	01 c8                	add    %ecx,%eax
  8039cd:	89 c1                	mov    %eax,%ecx
  8039cf:	c1 e1 10             	shl    $0x10,%ecx
  8039d2:	01 c8                	add    %ecx,%eax
  8039d4:	01 c0                	add    %eax,%eax
  8039d6:	01 d0                	add    %edx,%eax
  8039d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8039db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039de:	c1 e0 0c             	shl    $0xc,%eax
  8039e1:	89 c2                	mov    %eax,%edx
  8039e3:	a1 84 60 83 00       	mov    0x836084,%eax
  8039e8:	01 d0                	add    %edx,%eax
}
  8039ea:	c9                   	leave  
  8039eb:	c3                   	ret    

008039ec <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8039ec:	55                   	push   %ebp
  8039ed:	89 e5                	mov    %esp,%ebp
  8039ef:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8039f2:	a1 84 60 83 00       	mov    0x836084,%eax
  8039f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8039fa:	29 c2                	sub    %eax,%edx
  8039fc:	89 d0                	mov    %edx,%eax
  8039fe:	c1 e8 0c             	shr    $0xc,%eax
  803a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a08:	78 09                	js     803a13 <to_page_info+0x27>
  803a0a:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803a11:	7e 14                	jle    803a27 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803a13:	83 ec 04             	sub    $0x4,%esp
  803a16:	68 b0 4f 80 00       	push   $0x804fb0
  803a1b:	6a 21                	push   $0x21
  803a1d:	68 97 4f 80 00       	push   $0x804f97
  803a22:	e8 87 cd ff ff       	call   8007ae <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a2a:	89 d0                	mov    %edx,%eax
  803a2c:	01 c0                	add    %eax,%eax
  803a2e:	01 d0                	add    %edx,%eax
  803a30:	c1 e0 02             	shl    $0x2,%eax
  803a33:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803a38:	c9                   	leave  
  803a39:	c3                   	ret    

00803a3a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803a3a:	55                   	push   %ebp
  803a3b:	89 e5                	mov    %esp,%ebp
  803a3d:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803a40:	8b 45 08             	mov    0x8(%ebp),%eax
  803a43:	05 00 00 00 02       	add    $0x2000000,%eax
  803a48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a4b:	73 16                	jae    803a63 <initialize_dynamic_allocator+0x29>
  803a4d:	68 d4 4f 80 00       	push   $0x804fd4
  803a52:	68 fa 4f 80 00       	push   $0x804ffa
  803a57:	6a 2f                	push   $0x2f
  803a59:	68 97 4f 80 00       	push   $0x804f97
  803a5e:	e8 4b cd ff ff       	call   8007ae <_panic>
	dynAllocStart = daStart;
  803a63:	8b 45 08             	mov    0x8(%ebp),%eax
  803a66:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a6e:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a7a:	eb 36                	jmp    803ab2 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7f:	c1 e0 04             	shl    $0x4,%eax
  803a82:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803a87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a90:	c1 e0 04             	shl    $0x4,%eax
  803a93:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803a98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa1:	c1 e0 04             	shl    $0x4,%eax
  803aa4:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803aa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803aaf:	ff 45 f4             	incl   -0xc(%ebp)
  803ab2:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803ab6:	7e c4                	jle    803a7c <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803ab8:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803abf:	00 00 00 
  803ac2:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803ac9:	00 00 00 
  803acc:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803ad3:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803ad6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803add:	e9 1b 01 00 00       	jmp    803bfd <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ae5:	89 d0                	mov    %edx,%eax
  803ae7:	01 c0                	add    %eax,%eax
  803ae9:	01 d0                	add    %edx,%eax
  803aeb:	c1 e0 02             	shl    $0x2,%eax
  803aee:	05 88 e0 81 00       	add    $0x81e088,%eax
  803af3:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803af8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803afb:	89 d0                	mov    %edx,%eax
  803afd:	01 c0                	add    %eax,%eax
  803aff:	01 d0                	add    %edx,%eax
  803b01:	c1 e0 02             	shl    $0x2,%eax
  803b04:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803b09:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803b0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b11:	89 d0                	mov    %edx,%eax
  803b13:	01 c0                	add    %eax,%eax
  803b15:	01 d0                	add    %edx,%eax
  803b17:	c1 e0 02             	shl    $0x2,%eax
  803b1a:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b1f:	8b 00                	mov    (%eax),%eax
  803b21:	85 c0                	test   %eax,%eax
  803b23:	74 2b                	je     803b50 <initialize_dynamic_allocator+0x116>
  803b25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b28:	89 d0                	mov    %edx,%eax
  803b2a:	01 c0                	add    %eax,%eax
  803b2c:	01 d0                	add    %edx,%eax
  803b2e:	c1 e0 02             	shl    $0x2,%eax
  803b31:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b36:	8b 10                	mov    (%eax),%edx
  803b38:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b3b:	89 c8                	mov    %ecx,%eax
  803b3d:	01 c0                	add    %eax,%eax
  803b3f:	01 c8                	add    %ecx,%eax
  803b41:	c1 e0 02             	shl    $0x2,%eax
  803b44:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b49:	8b 00                	mov    (%eax),%eax
  803b4b:	89 42 04             	mov    %eax,0x4(%edx)
  803b4e:	eb 18                	jmp    803b68 <initialize_dynamic_allocator+0x12e>
  803b50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b53:	89 d0                	mov    %edx,%eax
  803b55:	01 c0                	add    %eax,%eax
  803b57:	01 d0                	add    %edx,%eax
  803b59:	c1 e0 02             	shl    $0x2,%eax
  803b5c:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b61:	8b 00                	mov    (%eax),%eax
  803b63:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803b68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b6b:	89 d0                	mov    %edx,%eax
  803b6d:	01 c0                	add    %eax,%eax
  803b6f:	01 d0                	add    %edx,%eax
  803b71:	c1 e0 02             	shl    $0x2,%eax
  803b74:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b79:	8b 00                	mov    (%eax),%eax
  803b7b:	85 c0                	test   %eax,%eax
  803b7d:	74 2a                	je     803ba9 <initialize_dynamic_allocator+0x16f>
  803b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b82:	89 d0                	mov    %edx,%eax
  803b84:	01 c0                	add    %eax,%eax
  803b86:	01 d0                	add    %edx,%eax
  803b88:	c1 e0 02             	shl    $0x2,%eax
  803b8b:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b90:	8b 10                	mov    (%eax),%edx
  803b92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b95:	89 c8                	mov    %ecx,%eax
  803b97:	01 c0                	add    %eax,%eax
  803b99:	01 c8                	add    %ecx,%eax
  803b9b:	c1 e0 02             	shl    $0x2,%eax
  803b9e:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ba3:	8b 00                	mov    (%eax),%eax
  803ba5:	89 02                	mov    %eax,(%edx)
  803ba7:	eb 18                	jmp    803bc1 <initialize_dynamic_allocator+0x187>
  803ba9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bac:	89 d0                	mov    %edx,%eax
  803bae:	01 c0                	add    %eax,%eax
  803bb0:	01 d0                	add    %edx,%eax
  803bb2:	c1 e0 02             	shl    $0x2,%eax
  803bb5:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bba:	8b 00                	mov    (%eax),%eax
  803bbc:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803bc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bc4:	89 d0                	mov    %edx,%eax
  803bc6:	01 c0                	add    %eax,%eax
  803bc8:	01 d0                	add    %edx,%eax
  803bca:	c1 e0 02             	shl    $0x2,%eax
  803bcd:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bdb:	89 d0                	mov    %edx,%eax
  803bdd:	01 c0                	add    %eax,%eax
  803bdf:	01 d0                	add    %edx,%eax
  803be1:	c1 e0 02             	shl    $0x2,%eax
  803be4:	05 84 e0 81 00       	add    $0x81e084,%eax
  803be9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bef:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803bf4:	48                   	dec    %eax
  803bf5:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803bfa:	ff 45 f0             	incl   -0x10(%ebp)
  803bfd:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803c04:	0f 8e d8 fe ff ff    	jle    803ae2 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803c0a:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803c11:	e9 9d 00 00 00       	jmp    803cb3 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803c16:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803c1c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c1f:	89 c8                	mov    %ecx,%eax
  803c21:	01 c0                	add    %eax,%eax
  803c23:	01 c8                	add    %ecx,%eax
  803c25:	c1 e0 02             	shl    $0x2,%eax
  803c28:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c2d:	89 10                	mov    %edx,(%eax)
  803c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c32:	89 d0                	mov    %edx,%eax
  803c34:	01 c0                	add    %eax,%eax
  803c36:	01 d0                	add    %edx,%eax
  803c38:	c1 e0 02             	shl    $0x2,%eax
  803c3b:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c40:	8b 00                	mov    (%eax),%eax
  803c42:	85 c0                	test   %eax,%eax
  803c44:	74 1c                	je     803c62 <initialize_dynamic_allocator+0x228>
  803c46:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803c4c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c4f:	89 c8                	mov    %ecx,%eax
  803c51:	01 c0                	add    %eax,%eax
  803c53:	01 c8                	add    %ecx,%eax
  803c55:	c1 e0 02             	shl    $0x2,%eax
  803c58:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c5d:	89 42 04             	mov    %eax,0x4(%edx)
  803c60:	eb 16                	jmp    803c78 <initialize_dynamic_allocator+0x23e>
  803c62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c65:	89 d0                	mov    %edx,%eax
  803c67:	01 c0                	add    %eax,%eax
  803c69:	01 d0                	add    %edx,%eax
  803c6b:	c1 e0 02             	shl    $0x2,%eax
  803c6e:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c73:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803c78:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c7b:	89 d0                	mov    %edx,%eax
  803c7d:	01 c0                	add    %eax,%eax
  803c7f:	01 d0                	add    %edx,%eax
  803c81:	c1 e0 02             	shl    $0x2,%eax
  803c84:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c89:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803c8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c91:	89 d0                	mov    %edx,%eax
  803c93:	01 c0                	add    %eax,%eax
  803c95:	01 d0                	add    %edx,%eax
  803c97:	c1 e0 02             	shl    $0x2,%eax
  803c9a:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ca5:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803caa:	40                   	inc    %eax
  803cab:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803cb0:	ff 4d ec             	decl   -0x14(%ebp)
  803cb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cb7:	0f 89 59 ff ff ff    	jns    803c16 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803cbd:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803cc4:	00 00 00 
}
  803cc7:	90                   	nop
  803cc8:	c9                   	leave  
  803cc9:	c3                   	ret    

00803cca <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803cca:	55                   	push   %ebp
  803ccb:	89 e5                	mov    %esp,%ebp
  803ccd:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd3:	83 ec 0c             	sub    $0xc,%esp
  803cd6:	50                   	push   %eax
  803cd7:	e8 10 fd ff ff       	call   8039ec <to_page_info>
  803cdc:	83 c4 10             	add    $0x10,%esp
  803cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce5:	8b 40 08             	mov    0x8(%eax),%eax
  803ce8:	0f b7 c0             	movzwl %ax,%eax
}
  803ceb:	c9                   	leave  
  803cec:	c3                   	ret    

00803ced <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803ced:	55                   	push   %ebp
  803cee:	89 e5                	mov    %esp,%ebp
  803cf0:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803cf3:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803cfa:	76 16                	jbe    803d12 <alloc_block+0x25>
  803cfc:	68 10 50 80 00       	push   $0x805010
  803d01:	68 fa 4f 80 00       	push   $0x804ffa
  803d06:	6a 59                	push   $0x59
  803d08:	68 97 4f 80 00       	push   $0x804f97
  803d0d:	e8 9c ca ff ff       	call   8007ae <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803d12:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803d19:	eb 08                	jmp    803d23 <alloc_block+0x36>
		allocSize <<= 1;
  803d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1e:	01 c0                	add    %eax,%eax
  803d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d26:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d29:	73 09                	jae    803d34 <alloc_block+0x47>
  803d2b:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803d32:	76 e7                	jbe    803d1b <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803d34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803d3b:	eb 03                	jmp    803d40 <alloc_block+0x53>
		listIndex++;
  803d3d:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d43:	ba 08 00 00 00       	mov    $0x8,%edx
  803d48:	88 c1                	mov    %al,%cl
  803d4a:	d3 e2                	shl    %cl,%edx
  803d4c:	89 d0                	mov    %edx,%eax
  803d4e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803d51:	72 ea                	jb     803d3d <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803d59:	e9 f4 00 00 00       	jmp    803e52 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d61:	c1 e0 04             	shl    $0x4,%eax
  803d64:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d69:	8b 00                	mov    (%eax),%eax
  803d6b:	85 c0                	test   %eax,%eax
  803d6d:	0f 84 dc 00 00 00    	je     803e4f <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d76:	c1 e0 04             	shl    $0x4,%eax
  803d79:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d7e:	8b 00                	mov    (%eax),%eax
  803d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803d83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d87:	75 14                	jne    803d9d <alloc_block+0xb0>
  803d89:	83 ec 04             	sub    $0x4,%esp
  803d8c:	68 31 50 80 00       	push   $0x805031
  803d91:	6a 6b                	push   $0x6b
  803d93:	68 97 4f 80 00       	push   $0x804f97
  803d98:	e8 11 ca ff ff       	call   8007ae <_panic>
  803d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da0:	8b 00                	mov    (%eax),%eax
  803da2:	85 c0                	test   %eax,%eax
  803da4:	74 10                	je     803db6 <alloc_block+0xc9>
  803da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da9:	8b 00                	mov    (%eax),%eax
  803dab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dae:	8b 52 04             	mov    0x4(%edx),%edx
  803db1:	89 50 04             	mov    %edx,0x4(%eax)
  803db4:	eb 14                	jmp    803dca <alloc_block+0xdd>
  803db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db9:	8b 40 04             	mov    0x4(%eax),%eax
  803dbc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dbf:	c1 e2 04             	shl    $0x4,%edx
  803dc2:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803dc8:	89 02                	mov    %eax,(%edx)
  803dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcd:	8b 40 04             	mov    0x4(%eax),%eax
  803dd0:	85 c0                	test   %eax,%eax
  803dd2:	74 0f                	je     803de3 <alloc_block+0xf6>
  803dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd7:	8b 40 04             	mov    0x4(%eax),%eax
  803dda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ddd:	8b 12                	mov    (%edx),%edx
  803ddf:	89 10                	mov    %edx,(%eax)
  803de1:	eb 13                	jmp    803df6 <alloc_block+0x109>
  803de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de6:	8b 00                	mov    (%eax),%eax
  803de8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803deb:	c1 e2 04             	shl    $0x4,%edx
  803dee:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803df4:	89 02                	mov    %eax,(%edx)
  803df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e0c:	c1 e0 04             	shl    $0x4,%eax
  803e0f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e14:	8b 00                	mov    (%eax),%eax
  803e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e1c:	c1 e0 04             	shl    $0x4,%eax
  803e1f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e24:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e29:	83 ec 0c             	sub    $0xc,%esp
  803e2c:	50                   	push   %eax
  803e2d:	e8 ba fb ff ff       	call   8039ec <to_page_info>
  803e32:	83 c4 10             	add    $0x10,%esp
  803e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e3b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e3f:	48                   	dec    %eax
  803e40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e43:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e4a:	e9 8f 02 00 00       	jmp    8040de <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803e4f:	ff 45 ec             	incl   -0x14(%ebp)
  803e52:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803e56:	0f 8e 02 ff ff ff    	jle    803d5e <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803e5c:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803e61:	85 c0                	test   %eax,%eax
  803e63:	75 14                	jne    803e79 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803e65:	83 ec 04             	sub    $0x4,%esp
  803e68:	68 50 50 80 00       	push   $0x805050
  803e6d:	6a 77                	push   $0x77
  803e6f:	68 97 4f 80 00       	push   $0x804f97
  803e74:	e8 35 c9 ff ff       	call   8007ae <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803e79:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803e7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803e81:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e85:	75 14                	jne    803e9b <alloc_block+0x1ae>
  803e87:	83 ec 04             	sub    $0x4,%esp
  803e8a:	68 31 50 80 00       	push   $0x805031
  803e8f:	6a 7a                	push   $0x7a
  803e91:	68 97 4f 80 00       	push   $0x804f97
  803e96:	e8 13 c9 ff ff       	call   8007ae <_panic>
  803e9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e9e:	8b 00                	mov    (%eax),%eax
  803ea0:	85 c0                	test   %eax,%eax
  803ea2:	74 10                	je     803eb4 <alloc_block+0x1c7>
  803ea4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ea7:	8b 00                	mov    (%eax),%eax
  803ea9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803eac:	8b 52 04             	mov    0x4(%edx),%edx
  803eaf:	89 50 04             	mov    %edx,0x4(%eax)
  803eb2:	eb 0b                	jmp    803ebf <alloc_block+0x1d2>
  803eb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eb7:	8b 40 04             	mov    0x4(%eax),%eax
  803eba:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ec2:	8b 40 04             	mov    0x4(%eax),%eax
  803ec5:	85 c0                	test   %eax,%eax
  803ec7:	74 0f                	je     803ed8 <alloc_block+0x1eb>
  803ec9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ecc:	8b 40 04             	mov    0x4(%eax),%eax
  803ecf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ed2:	8b 12                	mov    (%edx),%edx
  803ed4:	89 10                	mov    %edx,(%eax)
  803ed6:	eb 0a                	jmp    803ee2 <alloc_block+0x1f5>
  803ed8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803edb:	8b 00                	mov    (%eax),%eax
  803edd:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803ee2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ee5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eeb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ef5:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803efa:	48                   	dec    %eax
  803efb:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803f00:	83 ec 0c             	sub    $0xc,%esp
  803f03:	ff 75 dc             	pushl  -0x24(%ebp)
  803f06:	e8 6f fa ff ff       	call   80397a <to_page_va>
  803f0b:	83 c4 10             	add    $0x10,%esp
  803f0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803f11:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f14:	83 ec 0c             	sub    $0xc,%esp
  803f17:	50                   	push   %eax
  803f18:	e8 a0 dc ff ff       	call   801bbd <get_page>
  803f1d:	83 c4 10             	add    $0x10,%esp
  803f20:	85 c0                	test   %eax,%eax
  803f22:	74 14                	je     803f38 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803f24:	83 ec 04             	sub    $0x4,%esp
  803f27:	68 78 50 80 00       	push   $0x805078
  803f2c:	6a 7f                	push   $0x7f
  803f2e:	68 97 4f 80 00       	push   $0x804f97
  803f33:	e8 76 c8 ff ff       	call   8007ae <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f3e:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803f42:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f47:	ba 00 00 00 00       	mov    $0x0,%edx
  803f4c:	f7 75 f4             	divl   -0xc(%ebp)
  803f4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f52:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803f56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803f5d:	e9 a7 00 00 00       	jmp    804009 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803f62:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f68:	01 d0                	add    %edx,%eax
  803f6a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803f6d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f71:	75 17                	jne    803f8a <alloc_block+0x29d>
  803f73:	83 ec 04             	sub    $0x4,%esp
  803f76:	68 a0 50 80 00       	push   $0x8050a0
  803f7b:	68 88 00 00 00       	push   $0x88
  803f80:	68 97 4f 80 00       	push   $0x804f97
  803f85:	e8 24 c8 ff ff       	call   8007ae <_panic>
  803f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f8d:	c1 e0 04             	shl    $0x4,%eax
  803f90:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f95:	8b 10                	mov    (%eax),%edx
  803f97:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f9a:	89 10                	mov    %edx,(%eax)
  803f9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f9f:	8b 00                	mov    (%eax),%eax
  803fa1:	85 c0                	test   %eax,%eax
  803fa3:	74 15                	je     803fba <alloc_block+0x2cd>
  803fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa8:	c1 e0 04             	shl    $0x4,%eax
  803fab:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803fb0:	8b 00                	mov    (%eax),%eax
  803fb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fb5:	89 50 04             	mov    %edx,0x4(%eax)
  803fb8:	eb 11                	jmp    803fcb <alloc_block+0x2de>
  803fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fbd:	c1 e0 04             	shl    $0x4,%eax
  803fc0:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803fc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fc9:	89 02                	mov    %eax,(%edx)
  803fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fce:	c1 e0 04             	shl    $0x4,%eax
  803fd1:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803fd7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fda:	89 02                	mov    %eax,(%edx)
  803fdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fdf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe9:	c1 e0 04             	shl    $0x4,%eax
  803fec:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803ff1:	8b 00                	mov    (%eax),%eax
  803ff3:	8d 50 01             	lea    0x1(%eax),%edx
  803ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff9:	c1 e0 04             	shl    $0x4,%eax
  803ffc:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804001:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  804003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804006:	01 45 e8             	add    %eax,-0x18(%ebp)
  804009:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  804010:	0f 86 4c ff ff ff    	jbe    803f62 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  804016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804019:	c1 e0 04             	shl    $0x4,%eax
  80401c:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804021:	8b 00                	mov    (%eax),%eax
  804023:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  804026:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80402a:	75 17                	jne    804043 <alloc_block+0x356>
  80402c:	83 ec 04             	sub    $0x4,%esp
  80402f:	68 31 50 80 00       	push   $0x805031
  804034:	68 8d 00 00 00       	push   $0x8d
  804039:	68 97 4f 80 00       	push   $0x804f97
  80403e:	e8 6b c7 ff ff       	call   8007ae <_panic>
  804043:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804046:	8b 00                	mov    (%eax),%eax
  804048:	85 c0                	test   %eax,%eax
  80404a:	74 10                	je     80405c <alloc_block+0x36f>
  80404c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80404f:	8b 00                	mov    (%eax),%eax
  804051:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804054:	8b 52 04             	mov    0x4(%edx),%edx
  804057:	89 50 04             	mov    %edx,0x4(%eax)
  80405a:	eb 14                	jmp    804070 <alloc_block+0x383>
  80405c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80405f:	8b 40 04             	mov    0x4(%eax),%eax
  804062:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804065:	c1 e2 04             	shl    $0x4,%edx
  804068:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  80406e:	89 02                	mov    %eax,(%edx)
  804070:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804073:	8b 40 04             	mov    0x4(%eax),%eax
  804076:	85 c0                	test   %eax,%eax
  804078:	74 0f                	je     804089 <alloc_block+0x39c>
  80407a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80407d:	8b 40 04             	mov    0x4(%eax),%eax
  804080:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804083:	8b 12                	mov    (%edx),%edx
  804085:	89 10                	mov    %edx,(%eax)
  804087:	eb 13                	jmp    80409c <alloc_block+0x3af>
  804089:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80408c:	8b 00                	mov    (%eax),%eax
  80408e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804091:	c1 e2 04             	shl    $0x4,%edx
  804094:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  80409a:	89 02                	mov    %eax,(%edx)
  80409c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80409f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8040a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b2:	c1 e0 04             	shl    $0x4,%eax
  8040b5:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8040ba:	8b 00                	mov    (%eax),%eax
  8040bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8040bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040c2:	c1 e0 04             	shl    $0x4,%eax
  8040c5:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8040ca:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8040cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040cf:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8040d3:	48                   	dec    %eax
  8040d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040d7:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  8040db:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8040de:	c9                   	leave  
  8040df:	c3                   	ret    

008040e0 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8040e0:	55                   	push   %ebp
  8040e1:	89 e5                	mov    %esp,%ebp
  8040e3:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8040e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8040e9:	a1 84 60 83 00       	mov    0x836084,%eax
  8040ee:	39 c2                	cmp    %eax,%edx
  8040f0:	72 0c                	jb     8040fe <free_block+0x1e>
  8040f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8040f5:	a1 60 e0 81 00       	mov    0x81e060,%eax
  8040fa:	39 c2                	cmp    %eax,%edx
  8040fc:	72 19                	jb     804117 <free_block+0x37>
  8040fe:	68 c4 50 80 00       	push   $0x8050c4
  804103:	68 fa 4f 80 00       	push   $0x804ffa
  804108:	68 98 00 00 00       	push   $0x98
  80410d:	68 97 4f 80 00       	push   $0x804f97
  804112:	e8 97 c6 ff ff       	call   8007ae <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804117:	8b 45 08             	mov    0x8(%ebp),%eax
  80411a:	83 ec 0c             	sub    $0xc,%esp
  80411d:	50                   	push   %eax
  80411e:	e8 c9 f8 ff ff       	call   8039ec <to_page_info>
  804123:	83 c4 10             	add    $0x10,%esp
  804126:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804129:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80412c:	8b 40 08             	mov    0x8(%eax),%eax
  80412f:	0f b7 c0             	movzwl %ax,%eax
  804132:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  804135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  80413c:	eb 03                	jmp    804141 <free_block+0x61>
		listIndex++;
  80413e:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804144:	ba 08 00 00 00       	mov    $0x8,%edx
  804149:	88 c1                	mov    %al,%cl
  80414b:	d3 e2                	shl    %cl,%edx
  80414d:	89 d0                	mov    %edx,%eax
  80414f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804152:	72 ea                	jb     80413e <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  804154:	8b 45 08             	mov    0x8(%ebp),%eax
  804157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  80415a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80415e:	75 17                	jne    804177 <free_block+0x97>
  804160:	83 ec 04             	sub    $0x4,%esp
  804163:	68 a0 50 80 00       	push   $0x8050a0
  804168:	68 a2 00 00 00       	push   $0xa2
  80416d:	68 97 4f 80 00       	push   $0x804f97
  804172:	e8 37 c6 ff ff       	call   8007ae <_panic>
  804177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80417a:	c1 e0 04             	shl    $0x4,%eax
  80417d:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804182:	8b 10                	mov    (%eax),%edx
  804184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804187:	89 10                	mov    %edx,(%eax)
  804189:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418c:	8b 00                	mov    (%eax),%eax
  80418e:	85 c0                	test   %eax,%eax
  804190:	74 15                	je     8041a7 <free_block+0xc7>
  804192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804195:	c1 e0 04             	shl    $0x4,%eax
  804198:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80419d:	8b 00                	mov    (%eax),%eax
  80419f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041a2:	89 50 04             	mov    %edx,0x4(%eax)
  8041a5:	eb 11                	jmp    8041b8 <free_block+0xd8>
  8041a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041aa:	c1 e0 04             	shl    $0x4,%eax
  8041ad:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8041b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b6:	89 02                	mov    %eax,(%edx)
  8041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041bb:	c1 e0 04             	shl    $0x4,%eax
  8041be:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8041c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c7:	89 02                	mov    %eax,(%edx)
  8041c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041d6:	c1 e0 04             	shl    $0x4,%eax
  8041d9:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041de:	8b 00                	mov    (%eax),%eax
  8041e0:	8d 50 01             	lea    0x1(%eax),%edx
  8041e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041e6:	c1 e0 04             	shl    $0x4,%eax
  8041e9:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041ee:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  8041f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041f3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8041f7:	40                   	inc    %eax
  8041f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041fb:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  8041ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804202:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804206:	0f b7 c8             	movzwl %ax,%ecx
  804209:	b8 00 10 00 00       	mov    $0x1000,%eax
  80420e:	ba 00 00 00 00       	mov    $0x0,%edx
  804213:	f7 75 e8             	divl   -0x18(%ebp)
  804216:	39 c1                	cmp    %eax,%ecx
  804218:	0f 85 ed 01 00 00    	jne    80440b <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  80421e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804221:	c1 e0 04             	shl    $0x4,%eax
  804224:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804229:	8b 00                	mov    (%eax),%eax
  80422b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80422e:	eb 2a                	jmp    80425a <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  804230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804233:	83 ec 0c             	sub    $0xc,%esp
  804236:	50                   	push   %eax
  804237:	e8 b0 f7 ff ff       	call   8039ec <to_page_info>
  80423c:	83 c4 10             	add    $0x10,%esp
  80423f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804242:	75 06                	jne    80424a <free_block+0x16a>
				tmp = b;
  804244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804247:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  80424a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80424d:	c1 e0 04             	shl    $0x4,%eax
  804250:	05 a8 60 83 00       	add    $0x8360a8,%eax
  804255:	8b 00                	mov    (%eax),%eax
  804257:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80425a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80425e:	74 07                	je     804267 <free_block+0x187>
  804260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804263:	8b 00                	mov    (%eax),%eax
  804265:	eb 05                	jmp    80426c <free_block+0x18c>
  804267:	b8 00 00 00 00       	mov    $0x0,%eax
  80426c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80426f:	c1 e2 04             	shl    $0x4,%edx
  804272:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  804278:	89 02                	mov    %eax,(%edx)
  80427a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80427d:	c1 e0 04             	shl    $0x4,%eax
  804280:	05 a8 60 83 00       	add    $0x8360a8,%eax
  804285:	8b 00                	mov    (%eax),%eax
  804287:	85 c0                	test   %eax,%eax
  804289:	75 a5                	jne    804230 <free_block+0x150>
  80428b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80428f:	75 9f                	jne    804230 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804294:	c1 e0 04             	shl    $0x4,%eax
  804297:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80429c:	8b 00                	mov    (%eax),%eax
  80429e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  8042a1:	e9 cc 00 00 00       	jmp    804372 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  8042a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a9:	8b 00                	mov    (%eax),%eax
  8042ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  8042ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b1:	83 ec 0c             	sub    $0xc,%esp
  8042b4:	50                   	push   %eax
  8042b5:	e8 32 f7 ff ff       	call   8039ec <to_page_info>
  8042ba:	83 c4 10             	add    $0x10,%esp
  8042bd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8042c0:	0f 85 a6 00 00 00    	jne    80436c <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  8042c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042ca:	75 17                	jne    8042e3 <free_block+0x203>
  8042cc:	83 ec 04             	sub    $0x4,%esp
  8042cf:	68 31 50 80 00       	push   $0x805031
  8042d4:	68 b5 00 00 00       	push   $0xb5
  8042d9:	68 97 4f 80 00       	push   $0x804f97
  8042de:	e8 cb c4 ff ff       	call   8007ae <_panic>
  8042e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042e6:	8b 00                	mov    (%eax),%eax
  8042e8:	85 c0                	test   %eax,%eax
  8042ea:	74 10                	je     8042fc <free_block+0x21c>
  8042ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ef:	8b 00                	mov    (%eax),%eax
  8042f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042f4:	8b 52 04             	mov    0x4(%edx),%edx
  8042f7:	89 50 04             	mov    %edx,0x4(%eax)
  8042fa:	eb 14                	jmp    804310 <free_block+0x230>
  8042fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ff:	8b 40 04             	mov    0x4(%eax),%eax
  804302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804305:	c1 e2 04             	shl    $0x4,%edx
  804308:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  80430e:	89 02                	mov    %eax,(%edx)
  804310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804313:	8b 40 04             	mov    0x4(%eax),%eax
  804316:	85 c0                	test   %eax,%eax
  804318:	74 0f                	je     804329 <free_block+0x249>
  80431a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80431d:	8b 40 04             	mov    0x4(%eax),%eax
  804320:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804323:	8b 12                	mov    (%edx),%edx
  804325:	89 10                	mov    %edx,(%eax)
  804327:	eb 13                	jmp    80433c <free_block+0x25c>
  804329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80432c:	8b 00                	mov    (%eax),%eax
  80432e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804331:	c1 e2 04             	shl    $0x4,%edx
  804334:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  80433a:	89 02                	mov    %eax,(%edx)
  80433c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80433f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804348:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80434f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804352:	c1 e0 04             	shl    $0x4,%eax
  804355:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80435a:	8b 00                	mov    (%eax),%eax
  80435c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80435f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804362:	c1 e0 04             	shl    $0x4,%eax
  804365:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80436a:	89 10                	mov    %edx,(%eax)
			b = next;
  80436c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80436f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804376:	0f 85 2a ff ff ff    	jne    8042a6 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  80437c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80437f:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804388:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  80438e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804392:	75 17                	jne    8043ab <free_block+0x2cb>
  804394:	83 ec 04             	sub    $0x4,%esp
  804397:	68 a0 50 80 00       	push   $0x8050a0
  80439c:	68 bc 00 00 00       	push   $0xbc
  8043a1:	68 97 4f 80 00       	push   $0x804f97
  8043a6:	e8 03 c4 ff ff       	call   8007ae <_panic>
  8043ab:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8043b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043b4:	89 10                	mov    %edx,(%eax)
  8043b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043b9:	8b 00                	mov    (%eax),%eax
  8043bb:	85 c0                	test   %eax,%eax
  8043bd:	74 0d                	je     8043cc <free_block+0x2ec>
  8043bf:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8043c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8043c7:	89 50 04             	mov    %edx,0x4(%eax)
  8043ca:	eb 08                	jmp    8043d4 <free_block+0x2f4>
  8043cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043cf:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8043d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043d7:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8043dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043e6:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8043eb:	40                   	inc    %eax
  8043ec:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  8043f1:	83 ec 0c             	sub    $0xc,%esp
  8043f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8043f7:	e8 7e f5 ff ff       	call   80397a <to_page_va>
  8043fc:	83 c4 10             	add    $0x10,%esp
  8043ff:	83 ec 0c             	sub    $0xc,%esp
  804402:	50                   	push   %eax
  804403:	e8 fe d7 ff ff       	call   801c06 <return_page>
  804408:	83 c4 10             	add    $0x10,%esp
	}
}
  80440b:	90                   	nop
  80440c:	c9                   	leave  
  80440d:	c3                   	ret    
  80440e:	66 90                	xchg   %ax,%ax

00804410 <__udivdi3>:
  804410:	55                   	push   %ebp
  804411:	57                   	push   %edi
  804412:	56                   	push   %esi
  804413:	53                   	push   %ebx
  804414:	83 ec 1c             	sub    $0x1c,%esp
  804417:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80441b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80441f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804423:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804427:	89 ca                	mov    %ecx,%edx
  804429:	89 f8                	mov    %edi,%eax
  80442b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80442f:	85 f6                	test   %esi,%esi
  804431:	75 2d                	jne    804460 <__udivdi3+0x50>
  804433:	39 cf                	cmp    %ecx,%edi
  804435:	77 65                	ja     80449c <__udivdi3+0x8c>
  804437:	89 fd                	mov    %edi,%ebp
  804439:	85 ff                	test   %edi,%edi
  80443b:	75 0b                	jne    804448 <__udivdi3+0x38>
  80443d:	b8 01 00 00 00       	mov    $0x1,%eax
  804442:	31 d2                	xor    %edx,%edx
  804444:	f7 f7                	div    %edi
  804446:	89 c5                	mov    %eax,%ebp
  804448:	31 d2                	xor    %edx,%edx
  80444a:	89 c8                	mov    %ecx,%eax
  80444c:	f7 f5                	div    %ebp
  80444e:	89 c1                	mov    %eax,%ecx
  804450:	89 d8                	mov    %ebx,%eax
  804452:	f7 f5                	div    %ebp
  804454:	89 cf                	mov    %ecx,%edi
  804456:	89 fa                	mov    %edi,%edx
  804458:	83 c4 1c             	add    $0x1c,%esp
  80445b:	5b                   	pop    %ebx
  80445c:	5e                   	pop    %esi
  80445d:	5f                   	pop    %edi
  80445e:	5d                   	pop    %ebp
  80445f:	c3                   	ret    
  804460:	39 ce                	cmp    %ecx,%esi
  804462:	77 28                	ja     80448c <__udivdi3+0x7c>
  804464:	0f bd fe             	bsr    %esi,%edi
  804467:	83 f7 1f             	xor    $0x1f,%edi
  80446a:	75 40                	jne    8044ac <__udivdi3+0x9c>
  80446c:	39 ce                	cmp    %ecx,%esi
  80446e:	72 0a                	jb     80447a <__udivdi3+0x6a>
  804470:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804474:	0f 87 9e 00 00 00    	ja     804518 <__udivdi3+0x108>
  80447a:	b8 01 00 00 00       	mov    $0x1,%eax
  80447f:	89 fa                	mov    %edi,%edx
  804481:	83 c4 1c             	add    $0x1c,%esp
  804484:	5b                   	pop    %ebx
  804485:	5e                   	pop    %esi
  804486:	5f                   	pop    %edi
  804487:	5d                   	pop    %ebp
  804488:	c3                   	ret    
  804489:	8d 76 00             	lea    0x0(%esi),%esi
  80448c:	31 ff                	xor    %edi,%edi
  80448e:	31 c0                	xor    %eax,%eax
  804490:	89 fa                	mov    %edi,%edx
  804492:	83 c4 1c             	add    $0x1c,%esp
  804495:	5b                   	pop    %ebx
  804496:	5e                   	pop    %esi
  804497:	5f                   	pop    %edi
  804498:	5d                   	pop    %ebp
  804499:	c3                   	ret    
  80449a:	66 90                	xchg   %ax,%ax
  80449c:	89 d8                	mov    %ebx,%eax
  80449e:	f7 f7                	div    %edi
  8044a0:	31 ff                	xor    %edi,%edi
  8044a2:	89 fa                	mov    %edi,%edx
  8044a4:	83 c4 1c             	add    $0x1c,%esp
  8044a7:	5b                   	pop    %ebx
  8044a8:	5e                   	pop    %esi
  8044a9:	5f                   	pop    %edi
  8044aa:	5d                   	pop    %ebp
  8044ab:	c3                   	ret    
  8044ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8044b1:	89 eb                	mov    %ebp,%ebx
  8044b3:	29 fb                	sub    %edi,%ebx
  8044b5:	89 f9                	mov    %edi,%ecx
  8044b7:	d3 e6                	shl    %cl,%esi
  8044b9:	89 c5                	mov    %eax,%ebp
  8044bb:	88 d9                	mov    %bl,%cl
  8044bd:	d3 ed                	shr    %cl,%ebp
  8044bf:	89 e9                	mov    %ebp,%ecx
  8044c1:	09 f1                	or     %esi,%ecx
  8044c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8044c7:	89 f9                	mov    %edi,%ecx
  8044c9:	d3 e0                	shl    %cl,%eax
  8044cb:	89 c5                	mov    %eax,%ebp
  8044cd:	89 d6                	mov    %edx,%esi
  8044cf:	88 d9                	mov    %bl,%cl
  8044d1:	d3 ee                	shr    %cl,%esi
  8044d3:	89 f9                	mov    %edi,%ecx
  8044d5:	d3 e2                	shl    %cl,%edx
  8044d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044db:	88 d9                	mov    %bl,%cl
  8044dd:	d3 e8                	shr    %cl,%eax
  8044df:	09 c2                	or     %eax,%edx
  8044e1:	89 d0                	mov    %edx,%eax
  8044e3:	89 f2                	mov    %esi,%edx
  8044e5:	f7 74 24 0c          	divl   0xc(%esp)
  8044e9:	89 d6                	mov    %edx,%esi
  8044eb:	89 c3                	mov    %eax,%ebx
  8044ed:	f7 e5                	mul    %ebp
  8044ef:	39 d6                	cmp    %edx,%esi
  8044f1:	72 19                	jb     80450c <__udivdi3+0xfc>
  8044f3:	74 0b                	je     804500 <__udivdi3+0xf0>
  8044f5:	89 d8                	mov    %ebx,%eax
  8044f7:	31 ff                	xor    %edi,%edi
  8044f9:	e9 58 ff ff ff       	jmp    804456 <__udivdi3+0x46>
  8044fe:	66 90                	xchg   %ax,%ax
  804500:	8b 54 24 08          	mov    0x8(%esp),%edx
  804504:	89 f9                	mov    %edi,%ecx
  804506:	d3 e2                	shl    %cl,%edx
  804508:	39 c2                	cmp    %eax,%edx
  80450a:	73 e9                	jae    8044f5 <__udivdi3+0xe5>
  80450c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80450f:	31 ff                	xor    %edi,%edi
  804511:	e9 40 ff ff ff       	jmp    804456 <__udivdi3+0x46>
  804516:	66 90                	xchg   %ax,%ax
  804518:	31 c0                	xor    %eax,%eax
  80451a:	e9 37 ff ff ff       	jmp    804456 <__udivdi3+0x46>
  80451f:	90                   	nop

00804520 <__umoddi3>:
  804520:	55                   	push   %ebp
  804521:	57                   	push   %edi
  804522:	56                   	push   %esi
  804523:	53                   	push   %ebx
  804524:	83 ec 1c             	sub    $0x1c,%esp
  804527:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80452b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80452f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804533:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804537:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80453b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80453f:	89 f3                	mov    %esi,%ebx
  804541:	89 fa                	mov    %edi,%edx
  804543:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804547:	89 34 24             	mov    %esi,(%esp)
  80454a:	85 c0                	test   %eax,%eax
  80454c:	75 1a                	jne    804568 <__umoddi3+0x48>
  80454e:	39 f7                	cmp    %esi,%edi
  804550:	0f 86 a2 00 00 00    	jbe    8045f8 <__umoddi3+0xd8>
  804556:	89 c8                	mov    %ecx,%eax
  804558:	89 f2                	mov    %esi,%edx
  80455a:	f7 f7                	div    %edi
  80455c:	89 d0                	mov    %edx,%eax
  80455e:	31 d2                	xor    %edx,%edx
  804560:	83 c4 1c             	add    $0x1c,%esp
  804563:	5b                   	pop    %ebx
  804564:	5e                   	pop    %esi
  804565:	5f                   	pop    %edi
  804566:	5d                   	pop    %ebp
  804567:	c3                   	ret    
  804568:	39 f0                	cmp    %esi,%eax
  80456a:	0f 87 ac 00 00 00    	ja     80461c <__umoddi3+0xfc>
  804570:	0f bd e8             	bsr    %eax,%ebp
  804573:	83 f5 1f             	xor    $0x1f,%ebp
  804576:	0f 84 ac 00 00 00    	je     804628 <__umoddi3+0x108>
  80457c:	bf 20 00 00 00       	mov    $0x20,%edi
  804581:	29 ef                	sub    %ebp,%edi
  804583:	89 fe                	mov    %edi,%esi
  804585:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804589:	89 e9                	mov    %ebp,%ecx
  80458b:	d3 e0                	shl    %cl,%eax
  80458d:	89 d7                	mov    %edx,%edi
  80458f:	89 f1                	mov    %esi,%ecx
  804591:	d3 ef                	shr    %cl,%edi
  804593:	09 c7                	or     %eax,%edi
  804595:	89 e9                	mov    %ebp,%ecx
  804597:	d3 e2                	shl    %cl,%edx
  804599:	89 14 24             	mov    %edx,(%esp)
  80459c:	89 d8                	mov    %ebx,%eax
  80459e:	d3 e0                	shl    %cl,%eax
  8045a0:	89 c2                	mov    %eax,%edx
  8045a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045a6:	d3 e0                	shl    %cl,%eax
  8045a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8045ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045b0:	89 f1                	mov    %esi,%ecx
  8045b2:	d3 e8                	shr    %cl,%eax
  8045b4:	09 d0                	or     %edx,%eax
  8045b6:	d3 eb                	shr    %cl,%ebx
  8045b8:	89 da                	mov    %ebx,%edx
  8045ba:	f7 f7                	div    %edi
  8045bc:	89 d3                	mov    %edx,%ebx
  8045be:	f7 24 24             	mull   (%esp)
  8045c1:	89 c6                	mov    %eax,%esi
  8045c3:	89 d1                	mov    %edx,%ecx
  8045c5:	39 d3                	cmp    %edx,%ebx
  8045c7:	0f 82 87 00 00 00    	jb     804654 <__umoddi3+0x134>
  8045cd:	0f 84 91 00 00 00    	je     804664 <__umoddi3+0x144>
  8045d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8045d7:	29 f2                	sub    %esi,%edx
  8045d9:	19 cb                	sbb    %ecx,%ebx
  8045db:	89 d8                	mov    %ebx,%eax
  8045dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8045e1:	d3 e0                	shl    %cl,%eax
  8045e3:	89 e9                	mov    %ebp,%ecx
  8045e5:	d3 ea                	shr    %cl,%edx
  8045e7:	09 d0                	or     %edx,%eax
  8045e9:	89 e9                	mov    %ebp,%ecx
  8045eb:	d3 eb                	shr    %cl,%ebx
  8045ed:	89 da                	mov    %ebx,%edx
  8045ef:	83 c4 1c             	add    $0x1c,%esp
  8045f2:	5b                   	pop    %ebx
  8045f3:	5e                   	pop    %esi
  8045f4:	5f                   	pop    %edi
  8045f5:	5d                   	pop    %ebp
  8045f6:	c3                   	ret    
  8045f7:	90                   	nop
  8045f8:	89 fd                	mov    %edi,%ebp
  8045fa:	85 ff                	test   %edi,%edi
  8045fc:	75 0b                	jne    804609 <__umoddi3+0xe9>
  8045fe:	b8 01 00 00 00       	mov    $0x1,%eax
  804603:	31 d2                	xor    %edx,%edx
  804605:	f7 f7                	div    %edi
  804607:	89 c5                	mov    %eax,%ebp
  804609:	89 f0                	mov    %esi,%eax
  80460b:	31 d2                	xor    %edx,%edx
  80460d:	f7 f5                	div    %ebp
  80460f:	89 c8                	mov    %ecx,%eax
  804611:	f7 f5                	div    %ebp
  804613:	89 d0                	mov    %edx,%eax
  804615:	e9 44 ff ff ff       	jmp    80455e <__umoddi3+0x3e>
  80461a:	66 90                	xchg   %ax,%ax
  80461c:	89 c8                	mov    %ecx,%eax
  80461e:	89 f2                	mov    %esi,%edx
  804620:	83 c4 1c             	add    $0x1c,%esp
  804623:	5b                   	pop    %ebx
  804624:	5e                   	pop    %esi
  804625:	5f                   	pop    %edi
  804626:	5d                   	pop    %ebp
  804627:	c3                   	ret    
  804628:	3b 04 24             	cmp    (%esp),%eax
  80462b:	72 06                	jb     804633 <__umoddi3+0x113>
  80462d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804631:	77 0f                	ja     804642 <__umoddi3+0x122>
  804633:	89 f2                	mov    %esi,%edx
  804635:	29 f9                	sub    %edi,%ecx
  804637:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80463b:	89 14 24             	mov    %edx,(%esp)
  80463e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804642:	8b 44 24 04          	mov    0x4(%esp),%eax
  804646:	8b 14 24             	mov    (%esp),%edx
  804649:	83 c4 1c             	add    $0x1c,%esp
  80464c:	5b                   	pop    %ebx
  80464d:	5e                   	pop    %esi
  80464e:	5f                   	pop    %edi
  80464f:	5d                   	pop    %ebp
  804650:	c3                   	ret    
  804651:	8d 76 00             	lea    0x0(%esi),%esi
  804654:	2b 04 24             	sub    (%esp),%eax
  804657:	19 fa                	sbb    %edi,%edx
  804659:	89 d1                	mov    %edx,%ecx
  80465b:	89 c6                	mov    %eax,%esi
  80465d:	e9 71 ff ff ff       	jmp    8045d3 <__umoddi3+0xb3>
  804662:	66 90                	xchg   %ax,%ax
  804664:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804668:	72 ea                	jb     804654 <__umoddi3+0x134>
  80466a:	89 d9                	mov    %ebx,%ecx
  80466c:	e9 62 ff ff ff       	jmp    8045d3 <__umoddi3+0xb3>
