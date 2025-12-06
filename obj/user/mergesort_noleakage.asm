
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 21 07 00 00       	call   800757 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp

	do
	{
		//2012: lock the interrupt
		//sys_lock_cons();
		sys_lock_cons();
  800041:	e8 51 35 00 00       	call   803597 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 47 80 00       	push   $0x8047e0
  80004e:	e8 82 0b 00 00       	call   800bd5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 47 80 00       	push   $0x8047e2
  80005e:	e8 72 0b 00 00       	call   800bd5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 47 80 00       	push   $0x8047f8
  80006e:	e8 62 0b 00 00       	call   800bd5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 47 80 00       	push   $0x8047e2
  80007e:	e8 52 0b 00 00       	call   800bd5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 47 80 00       	push   $0x8047e0
  80008e:	e8 42 0b 00 00       	call   800bd5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 10 48 80 00       	push   $0x804810
  8000a5:	e8 04 12 00 00       	call   8012ae <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 30 48 80 00       	push   $0x804830
  8000b5:	e8 1b 0b 00 00       	call   800bd5 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 52 48 80 00       	push   $0x804852
  8000c5:	e8 0b 0b 00 00       	call   800bd5 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 60 48 80 00       	push   $0x804860
  8000d5:	e8 fb 0a 00 00       	call   800bd5 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 6f 48 80 00       	push   $0x80486f
  8000e5:	e8 eb 0a 00 00       	call   800bd5 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 7f 48 80 00       	push   $0x80487f
  8000f5:	e8 db 0a 00 00       	call   800bd5 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000fd:	e8 38 06 00 00       	call   80073a <getchar>
  800102:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800105:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	e8 09 06 00 00       	call   80071b <cputchar>
  800112:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	6a 0a                	push   $0xa
  80011a:	e8 fc 05 00 00       	call   80071b <cputchar>
  80011f:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800122:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800126:	74 0c                	je     800134 <_main+0xfc>
  800128:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80012c:	74 06                	je     800134 <_main+0xfc>
  80012e:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800132:	75 b9                	jne    8000ed <_main+0xb5>
		}
		sys_unlock_cons();
  800134:	e8 78 34 00 00       	call   8035b1 <sys_unlock_cons>
		//sys_unlock_cons();

		NumOfElements = strtol(Line, NULL, 10) ;
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	6a 00                	push   $0x0
  800140:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800146:	50                   	push   %eax
  800147:	e8 79 17 00 00       	call   8018c5 <strtol>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 3e 1c 00 00       	call   801d9f <malloc>
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
  800183:	e8 ea 01 00 00       	call   800372 <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 08 02 00 00       	call   8003a3 <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 2a 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 17 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d6 02 00 00       	call   8004aa <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 88 48 80 00       	push   $0x804888
  8001df:	e8 63 0a 00 00       	call   800c47 <atomic_cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d3 00 00 00       	call   8002c8 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 bc 48 80 00       	push   $0x8048bc
  800209:	6a 4d                	push   $0x4d
  80020b:	68 de 48 80 00       	push   $0x8048de
  800210:	e8 f2 06 00 00       	call   800907 <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 7d 33 00 00       	call   803597 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 fc 48 80 00       	push   $0x8048fc
  800222:	e8 ae 09 00 00       	call   800bd5 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 30 49 80 00       	push   $0x804930
  800232:	e8 9e 09 00 00       	call   800bd5 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 64 49 80 00       	push   $0x804964
  800242:	e8 8e 09 00 00       	call   800bd5 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 62 33 00 00       	call   8035b1 <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 a5 1e 00 00       	call   8020ff <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 35 33 00 00       	call   803597 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 96 49 80 00       	push   $0x804996
  800270:	e8 60 09 00 00       	call   800bd5 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800278:	e8 bd 04 00 00       	call   80073a <getchar>
  80027d:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800280:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	50                   	push   %eax
  800288:	e8 8e 04 00 00       	call   80071b <cputchar>
  80028d:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 0a                	push   $0xa
  800295:	e8 81 04 00 00       	call   80071b <cputchar>
  80029a:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	6a 0a                	push   $0xa
  8002a2:	e8 74 04 00 00       	call   80071b <cputchar>
  8002a7:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002aa:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002ae:	74 06                	je     8002b6 <_main+0x27e>
  8002b0:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b4:	75 b2                	jne    800268 <_main+0x230>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b6:	e8 f6 32 00 00       	call   8035b1 <sys_unlock_cons>
		//sys_unlock_cons();

	} while (Chose == 'y');
  8002bb:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bf:	0f 84 7c fd ff ff    	je     800041 <_main+0x9>

}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dc:	eb 33                	jmp    800311 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f2:	40                   	inc    %eax
  8002f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	01 c8                	add    %ecx,%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	7e 09                	jle    80030e <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030c:	eb 0c                	jmp    80031a <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030e:	ff 45 f8             	incl   -0x8(%ebp)
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800318:	7f c4                	jg     8002de <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 c2                	add    %eax,%edx
  800348:	8b 45 10             	mov    0x10(%ebp),%eax
  80034b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	01 c8                	add    %ecx,%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035b:	8b 45 10             	mov    0x10(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 c2                	add    %eax,%edx
  80036a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036d:	89 02                	mov    %eax,(%edx)
}
  80036f:	90                   	nop
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037f:	eb 17                	jmp    800398 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	01 c2                	add    %eax,%edx
  800390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800393:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800395:	ff 45 fc             	incl   -0x4(%ebp)
  800398:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039e:	7c e1                	jl     800381 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 1b                	jmp    8003cd <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c7:	48                   	dec    %eax
  8003c8:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ca:	ff 45 fc             	incl   -0x4(%ebp)
  8003cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d3:	7c dd                	jl     8003b2 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e1:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e6:	f7 e9                	imul   %ecx
  8003e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8003eb:	89 d0                	mov    %edx,%eax
  8003ed:	29 c8                	sub    %ecx,%eax
  8003ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f9:	eb 1e                	jmp    800419 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80040b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040e:	99                   	cltd   
  80040f:	f7 7d f8             	idivl  -0x8(%ebp)
  800412:	89 d0                	mov    %edx,%eax
  800414:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800416:	ff 45 fc             	incl   -0x4(%ebp)
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041f:	7c da                	jl     8003fb <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("i=%d\n",i);
	}

}
  800421:	90                   	nop
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80042a:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800438:	eb 42                	jmp    80047c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80043a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043d:	99                   	cltd   
  80043e:	f7 7d f0             	idivl  -0x10(%ebp)
  800441:	89 d0                	mov    %edx,%eax
  800443:	85 c0                	test   %eax,%eax
  800445:	75 10                	jne    800457 <PrintElements+0x33>
			cprintf("\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 e0 47 80 00       	push   $0x8047e0
  80044f:	e8 81 07 00 00       	call   800bd5 <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	50                   	push   %eax
  80046c:	68 b4 49 80 00       	push   $0x8049b4
  800471:	e8 5f 07 00 00       	call   800bd5 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800479:	ff 45 f4             	incl   -0xc(%ebp)
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	48                   	dec    %eax
  800480:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800483:	7f b5                	jg     80043a <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	01 d0                	add    %edx,%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 b9 49 80 00       	push   $0x8049b9
  80049f:	e8 31 07 00 00       	call   800bd5 <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp

}
  8004a7:	90                   	nop
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <MSort>:


void MSort(int* A, int p, int r)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b6:	7d 54                	jge    80050c <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004be:	01 d0                	add    %edx,%eax
  8004c0:	89 c2                	mov    %eax,%edx
  8004c2:	c1 ea 1f             	shr    $0x1f,%edx
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	d1 f8                	sar    %eax
  8004c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 cd ff ff ff       	call   8004aa <MSort>
  8004dd:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e3:	40                   	inc    %eax
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 b7 ff ff ff       	call   8004aa <MSort>
  8004f3:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f6:	ff 75 10             	pushl  0x10(%ebp)
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	ff 75 08             	pushl  0x8(%ebp)
  800502:	e8 08 00 00 00       	call   80050f <Merge>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	eb 01                	jmp    80050d <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80050c:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800515:	8b 45 10             	mov    0x10(%ebp),%eax
  800518:	2b 45 0c             	sub    0xc(%ebp),%eax
  80051b:	40                   	inc    %eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	2b 45 10             	sub    0x10(%ebp),%eax
  800525:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	50                   	push   %eax
  800540:	e8 5a 18 00 00       	call   801d9f <malloc>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	c1 e0 02             	shl    $0x2,%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	50                   	push   %eax
  800555:	e8 45 18 00 00       	call   801d9f <malloc>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800560:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800567:	eb 2f                	jmp    800598 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800576:	01 c2                	add    %eax,%edx
  800578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80057b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057e:	01 c8                	add    %ecx,%eax
  800580:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800585:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	01 c8                	add    %ecx,%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800595:	ff 45 ec             	incl   -0x14(%ebp)
  800598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059e:	7c c9                	jl     800569 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a7:	eb 2a                	jmp    8005d3 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b6:	01 c2                	add    %eax,%edx
  8005b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005be:	01 c8                	add    %ecx,%eax
  8005c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d0:	ff 45 e8             	incl   -0x18(%ebp)
  8005d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d9:	7c ce                	jl     8005a9 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e1:	e9 0a 01 00 00       	jmp    8006f0 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ec:	0f 8d 95 00 00 00    	jge    800687 <Merge+0x178>
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f8:	0f 8d 89 00 00 00    	jge    800687 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800601:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800608:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7d 33                	jge    800657 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800627:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80063c:	8d 50 01             	lea    0x1(%eax),%edx
  80063f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064c:	01 d0                	add    %edx,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800652:	e9 96 00 00 00       	jmp    8006ed <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80065a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	8d 50 01             	lea    0x1(%eax),%edx
  800672:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067f:	01 d0                	add    %edx,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800685:	eb 66                	jmp    8006ed <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80068d:	7d 30                	jge    8006bf <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
  8006bd:	eb 2e                	jmp    8006ed <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f6:	0f 8e ea fe ff ff    	jle    8005e6 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800702:	e8 f8 19 00 00       	call   8020ff <free>
  800707:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800710:	e8 ea 19 00 00       	call   8020ff <free>
  800715:	83 c4 10             	add    $0x10,%esp

}
  800718:	90                   	nop
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800727:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	50                   	push   %eax
  80072f:	e8 ab 2f 00 00       	call   8036df <sys_cputc>
  800734:	83 c4 10             	add    $0x10,%esp
}
  800737:	90                   	nop
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <getchar>:


int
getchar(void)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800740:	e8 39 2e 00 00       	call   80357e <sys_cgetc>
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800748:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <iscons>:

int iscons(int fdnum)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800750:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	57                   	push   %edi
  80075b:	56                   	push   %esi
  80075c:	53                   	push   %ebx
  80075d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800760:	e8 ab 30 00 00       	call   803810 <sys_getenvindex>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800768:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80076b:	89 d0                	mov    %edx,%eax
  80076d:	c1 e0 03             	shl    $0x3,%eax
  800770:	01 d0                	add    %edx,%eax
  800772:	c1 e0 02             	shl    $0x2,%eax
  800775:	01 d0                	add    %edx,%eax
  800777:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077e:	01 d0                	add    %edx,%eax
  800780:	c1 e0 03             	shl    $0x3,%eax
  800783:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800788:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80078d:	a1 24 60 80 00       	mov    0x806024,%eax
  800792:	8a 40 20             	mov    0x20(%eax),%al
  800795:	84 c0                	test   %al,%al
  800797:	74 0d                	je     8007a6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800799:	a1 24 60 80 00       	mov    0x806024,%eax
  80079e:	83 c0 20             	add    $0x20,%eax
  8007a1:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007aa:	7e 0a                	jle    8007b6 <libmain+0x5f>
		binaryname = argv[0];
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	ff 75 08             	pushl  0x8(%ebp)
  8007bf:	e8 74 f8 ff ff       	call   800038 <_main>
  8007c4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007c7:	a1 00 60 80 00       	mov    0x806000,%eax
  8007cc:	85 c0                	test   %eax,%eax
  8007ce:	0f 84 01 01 00 00    	je     8008d5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007d4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007da:	bb b8 4a 80 00       	mov    $0x804ab8,%ebx
  8007df:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007e4:	89 c7                	mov    %eax,%edi
  8007e6:	89 de                	mov    %ebx,%esi
  8007e8:	89 d1                	mov    %edx,%ecx
  8007ea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007ec:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007ef:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007f4:	b0 00                	mov    $0x0,%al
  8007f6:	89 d7                	mov    %edx,%edi
  8007f8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800801:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	50                   	push   %eax
  800808:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80080e:	50                   	push   %eax
  80080f:	e8 32 32 00 00       	call   803a46 <sys_utilities>
  800814:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800817:	e8 7b 2d 00 00       	call   803597 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80081c:	83 ec 0c             	sub    $0xc,%esp
  80081f:	68 d8 49 80 00       	push   $0x8049d8
  800824:	e8 ac 03 00 00       	call   800bd5 <cprintf>
  800829:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80082c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 18                	je     80084b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800833:	e8 2c 32 00 00       	call   803a64 <sys_get_optimal_num_faults>
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	50                   	push   %eax
  80083c:	68 00 4a 80 00       	push   $0x804a00
  800841:	e8 8f 03 00 00       	call   800bd5 <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	eb 59                	jmp    8008a4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 60 80 00       	mov    0x806024,%eax
  800850:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800856:	a1 24 60 80 00       	mov    0x806024,%eax
  80085b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 24 4a 80 00       	push   $0x804a24
  80086b:	e8 65 03 00 00       	call   800bd5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 60 80 00       	mov    0x806024,%eax
  800878:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80087e:	a1 24 60 80 00       	mov    0x806024,%eax
  800883:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800889:	a1 24 60 80 00       	mov    0x806024,%eax
  80088e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 4c 4a 80 00       	push   $0x804a4c
  80089c:	e8 34 03 00 00       	call   800bd5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 60 80 00       	mov    0x806024,%eax
  8008a9:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 a4 4a 80 00       	push   $0x804aa4
  8008b8:	e8 18 03 00 00       	call   800bd5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 d8 49 80 00       	push   $0x8049d8
  8008c8:	e8 08 03 00 00       	call   800bd5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008d0:	e8 dc 2c 00 00       	call   8035b1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008d5:	e8 1f 00 00 00       	call   8008f9 <exit>
}
  8008da:	90                   	nop
  8008db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008de:	5b                   	pop    %ebx
  8008df:	5e                   	pop    %esi
  8008e0:	5f                   	pop    %edi
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e9:	83 ec 0c             	sub    $0xc,%esp
  8008ec:	6a 00                	push   $0x0
  8008ee:	e8 e9 2e 00 00       	call   8037dc <sys_destroy_env>
  8008f3:	83 c4 10             	add    $0x10,%esp
}
  8008f6:	90                   	nop
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <exit>:

void
exit(void)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008ff:	e8 3e 2f 00 00       	call   803842 <sys_exit_env>
}
  800904:	90                   	nop
  800905:	c9                   	leave  
  800906:	c3                   	ret    

00800907 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80090d:	8d 45 10             	lea    0x10(%ebp),%eax
  800910:	83 c0 04             	add    $0x4,%eax
  800913:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800916:	a1 38 61 83 00       	mov    0x836138,%eax
  80091b:	85 c0                	test   %eax,%eax
  80091d:	74 16                	je     800935 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80091f:	a1 38 61 83 00       	mov    0x836138,%eax
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	50                   	push   %eax
  800928:	68 1c 4b 80 00       	push   $0x804b1c
  80092d:	e8 a3 02 00 00       	call   800bd5 <cprintf>
  800932:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800935:	a1 04 60 80 00       	mov    0x806004,%eax
  80093a:	83 ec 0c             	sub    $0xc,%esp
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	ff 75 08             	pushl  0x8(%ebp)
  800943:	50                   	push   %eax
  800944:	68 24 4b 80 00       	push   $0x804b24
  800949:	6a 74                	push   $0x74
  80094b:	e8 b2 02 00 00       	call   800c02 <cprintf_colored>
  800950:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 04 02 00 00       	call   800b66 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 4c 4b 80 00       	push   $0x804b4c
  80096f:	e8 f2 01 00 00       	call   800b66 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 7d ff ff ff       	call   8008f9 <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x75>

0080097e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 60 80 00       	mov    0x806024,%eax
  800989:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80098f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800992:	39 c2                	cmp    %eax,%edx
  800994:	74 14                	je     8009aa <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 50 4b 80 00       	push   $0x804b50
  80099e:	6a 26                	push   $0x26
  8009a0:	68 9c 4b 80 00       	push   $0x804b9c
  8009a5:	e8 5d ff ff ff       	call   800907 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b8:	e9 c5 00 00 00       	jmp    800a82 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	01 d0                	add    %edx,%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	85 c0                	test   %eax,%eax
  8009d0:	75 08                	jne    8009da <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009d2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d5:	e9 a5 00 00 00       	jmp    800a7f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e8:	eb 69                	jmp    800a53 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ea:	a1 24 60 80 00       	mov    0x806024,%eax
  8009ef:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	01 c0                	add    %eax,%eax
  8009fc:	01 d0                	add    %edx,%eax
  8009fe:	c1 e0 03             	shl    $0x3,%eax
  800a01:	01 c8                	add    %ecx,%eax
  800a03:	8a 40 04             	mov    0x4(%eax),%al
  800a06:	84 c0                	test   %al,%al
  800a08:	75 46                	jne    800a50 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0a:	a1 24 60 80 00       	mov    0x806024,%eax
  800a0f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a18:	89 d0                	mov    %edx,%eax
  800a1a:	01 c0                	add    %eax,%eax
  800a1c:	01 d0                	add    %edx,%eax
  800a1e:	c1 e0 03             	shl    $0x3,%eax
  800a21:	01 c8                	add    %ecx,%eax
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a30:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a35:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	01 c8                	add    %ecx,%eax
  800a41:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a43:	39 c2                	cmp    %eax,%edx
  800a45:	75 09                	jne    800a50 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a47:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4e:	eb 15                	jmp    800a65 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a50:	ff 45 e8             	incl   -0x18(%ebp)
  800a53:	a1 24 60 80 00       	mov    0x806024,%eax
  800a58:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a61:	39 c2                	cmp    %eax,%edx
  800a63:	77 85                	ja     8009ea <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a69:	75 14                	jne    800a7f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a6b:	83 ec 04             	sub    $0x4,%esp
  800a6e:	68 a8 4b 80 00       	push   $0x804ba8
  800a73:	6a 3a                	push   $0x3a
  800a75:	68 9c 4b 80 00       	push   $0x804b9c
  800a7a:	e8 88 fe ff ff       	call   800907 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a7f:	ff 45 f0             	incl   -0x10(%ebp)
  800a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a85:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a88:	0f 8c 2f ff ff ff    	jl     8009bd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a8e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a9c:	eb 26                	jmp    800ac4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a9e:	a1 24 60 80 00       	mov    0x806024,%eax
  800aa3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800aa9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aac:	89 d0                	mov    %edx,%eax
  800aae:	01 c0                	add    %eax,%eax
  800ab0:	01 d0                	add    %edx,%eax
  800ab2:	c1 e0 03             	shl    $0x3,%eax
  800ab5:	01 c8                	add    %ecx,%eax
  800ab7:	8a 40 04             	mov    0x4(%eax),%al
  800aba:	3c 01                	cmp    $0x1,%al
  800abc:	75 03                	jne    800ac1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800abe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ac1:	ff 45 e0             	incl   -0x20(%ebp)
  800ac4:	a1 24 60 80 00       	mov    0x806024,%eax
  800ac9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800acf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad2:	39 c2                	cmp    %eax,%edx
  800ad4:	77 c8                	ja     800a9e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800adc:	74 14                	je     800af2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800ade:	83 ec 04             	sub    $0x4,%esp
  800ae1:	68 fc 4b 80 00       	push   $0x804bfc
  800ae6:	6a 44                	push   $0x44
  800ae8:	68 9c 4b 80 00       	push   $0x804b9c
  800aed:	e8 15 fe ff ff       	call   800907 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	53                   	push   %ebx
  800af9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	8d 48 01             	lea    0x1(%eax),%ecx
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	89 0a                	mov    %ecx,(%edx)
  800b09:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0c:	88 d1                	mov    %dl,%cl
  800b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b11:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b1f:	75 30                	jne    800b51 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b21:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800b27:	a0 64 e0 81 00       	mov    0x81e064,%al
  800b2c:	0f b6 c0             	movzbl %al,%eax
  800b2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b32:	8b 09                	mov    (%ecx),%ecx
  800b34:	89 cb                	mov    %ecx,%ebx
  800b36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b39:	83 c1 08             	add    $0x8,%ecx
  800b3c:	52                   	push   %edx
  800b3d:	50                   	push   %eax
  800b3e:	53                   	push   %ebx
  800b3f:	51                   	push   %ecx
  800b40:	e8 0e 2a 00 00       	call   803553 <sys_cputs>
  800b45:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 40 04             	mov    0x4(%eax),%eax
  800b57:	8d 50 01             	lea    0x1(%eax),%edx
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b60:	90                   	nop
  800b61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b6f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b76:	00 00 00 
	b.cnt = 0;
  800b79:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b80:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8f:	50                   	push   %eax
  800b90:	68 f5 0a 80 00       	push   $0x800af5
  800b95:	e8 5a 02 00 00       	call   800df4 <vprintfmt>
  800b9a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b9d:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800ba3:	a0 64 e0 81 00       	mov    0x81e064,%al
  800ba8:	0f b6 c0             	movzbl %al,%eax
  800bab:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bb1:	52                   	push   %edx
  800bb2:	50                   	push   %eax
  800bb3:	51                   	push   %ecx
  800bb4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bba:	83 c0 08             	add    $0x8,%eax
  800bbd:	50                   	push   %eax
  800bbe:	e8 90 29 00 00       	call   803553 <sys_cputs>
  800bc3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bc6:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800bcd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bdb:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800be2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	83 ec 08             	sub    $0x8,%esp
  800bee:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf1:	50                   	push   %eax
  800bf2:	e8 6f ff ff ff       	call   800b66 <vcprintf>
  800bf7:	83 c4 10             	add    $0x10,%esp
  800bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c08:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	c1 e0 08             	shl    $0x8,%eax
  800c15:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800c1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c1d:	83 c0 04             	add    $0x4,%eax
  800c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2c:	50                   	push   %eax
  800c2d:	e8 34 ff ff ff       	call   800b66 <vcprintf>
  800c32:	83 c4 10             	add    $0x10,%esp
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c38:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800c3f:	07 00 00 

	return cnt;
  800c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c45:	c9                   	leave  
  800c46:	c3                   	ret    

00800c47 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c4d:	e8 45 29 00 00       	call   803597 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c61:	50                   	push   %eax
  800c62:	e8 ff fe ff ff       	call   800b66 <vcprintf>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c6d:	e8 3f 29 00 00       	call   8035b1 <sys_unlock_cons>
	return cnt;
  800c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 14             	sub    $0x14,%esp
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c8a:	8b 45 18             	mov    0x18(%ebp),%eax
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c92:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c95:	77 55                	ja     800cec <printnum+0x75>
  800c97:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c9a:	72 05                	jb     800ca1 <printnum+0x2a>
  800c9c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c9f:	77 4b                	ja     800cec <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ca1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ca4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ca7:	8b 45 18             	mov    0x18(%ebp),%eax
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	52                   	push   %edx
  800cb0:	50                   	push   %eax
  800cb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb7:	e8 ac 38 00 00       	call   804568 <__udivdi3>
  800cbc:	83 c4 10             	add    $0x10,%esp
  800cbf:	83 ec 04             	sub    $0x4,%esp
  800cc2:	ff 75 20             	pushl  0x20(%ebp)
  800cc5:	53                   	push   %ebx
  800cc6:	ff 75 18             	pushl  0x18(%ebp)
  800cc9:	52                   	push   %edx
  800cca:	50                   	push   %eax
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	ff 75 08             	pushl  0x8(%ebp)
  800cd1:	e8 a1 ff ff ff       	call   800c77 <printnum>
  800cd6:	83 c4 20             	add    $0x20,%esp
  800cd9:	eb 1a                	jmp    800cf5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	ff 75 20             	pushl  0x20(%ebp)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	ff d0                	call   *%eax
  800ce9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cec:	ff 4d 1c             	decl   0x1c(%ebp)
  800cef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cf3:	7f e6                	jg     800cdb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cf5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cf8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d03:	53                   	push   %ebx
  800d04:	51                   	push   %ecx
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	e8 6c 39 00 00       	call   804678 <__umoddi3>
  800d0c:	83 c4 10             	add    $0x10,%esp
  800d0f:	05 74 4e 80 00       	add    $0x804e74,%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	0f be c0             	movsbl %al,%eax
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	50                   	push   %eax
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
}
  800d28:	90                   	nop
  800d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d31:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d35:	7e 1c                	jle    800d53 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8b 00                	mov    (%eax),%eax
  800d3c:	8d 50 08             	lea    0x8(%eax),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 10                	mov    %edx,(%eax)
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	83 e8 08             	sub    $0x8,%eax
  800d4c:	8b 50 04             	mov    0x4(%eax),%edx
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	eb 40                	jmp    800d93 <getuint+0x65>
	else if (lflag)
  800d53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d57:	74 1e                	je     800d77 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	8d 50 04             	lea    0x4(%eax),%edx
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 10                	mov    %edx,(%eax)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	83 e8 04             	sub    $0x4,%eax
  800d6e:	8b 00                	mov    (%eax),%eax
  800d70:	ba 00 00 00 00       	mov    $0x0,%edx
  800d75:	eb 1c                	jmp    800d93 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8b 00                	mov    (%eax),%eax
  800d7c:	8d 50 04             	lea    0x4(%eax),%edx
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 10                	mov    %edx,(%eax)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8b 00                	mov    (%eax),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d98:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d9c:	7e 1c                	jle    800dba <getint+0x25>
		return va_arg(*ap, long long);
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	8d 50 08             	lea    0x8(%eax),%edx
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	89 10                	mov    %edx,(%eax)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	83 e8 08             	sub    $0x8,%eax
  800db3:	8b 50 04             	mov    0x4(%eax),%edx
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	eb 38                	jmp    800df2 <getint+0x5d>
	else if (lflag)
  800dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbe:	74 1a                	je     800dda <getint+0x45>
		return va_arg(*ap, long);
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	8d 50 04             	lea    0x4(%eax),%edx
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 10                	mov    %edx,(%eax)
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8b 00                	mov    (%eax),%eax
  800dd2:	83 e8 04             	sub    $0x4,%eax
  800dd5:	8b 00                	mov    (%eax),%eax
  800dd7:	99                   	cltd   
  800dd8:	eb 18                	jmp    800df2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 04             	lea    0x4(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	99                   	cltd   
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dfc:	eb 17                	jmp    800e15 <vprintfmt+0x21>
			if (ch == '\0')
  800dfe:	85 db                	test   %ebx,%ebx
  800e00:	0f 84 c1 03 00 00    	je     8011c7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e06:	83 ec 08             	sub    $0x8,%esp
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	53                   	push   %ebx
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	ff d0                	call   *%eax
  800e12:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	8d 50 01             	lea    0x1(%eax),%edx
  800e1b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f b6 d8             	movzbl %al,%ebx
  800e23:	83 fb 25             	cmp    $0x25,%ebx
  800e26:	75 d6                	jne    800dfe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e28:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e2c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e33:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e3a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e48:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4b:	8d 50 01             	lea    0x1(%eax),%edx
  800e4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	0f b6 d8             	movzbl %al,%ebx
  800e56:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e59:	83 f8 5b             	cmp    $0x5b,%eax
  800e5c:	0f 87 3d 03 00 00    	ja     80119f <vprintfmt+0x3ab>
  800e62:	8b 04 85 98 4e 80 00 	mov    0x804e98(,%eax,4),%eax
  800e69:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e6b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e6f:	eb d7                	jmp    800e48 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e71:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e75:	eb d1                	jmp    800e48 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e77:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e81:	89 d0                	mov    %edx,%eax
  800e83:	c1 e0 02             	shl    $0x2,%eax
  800e86:	01 d0                	add    %edx,%eax
  800e88:	01 c0                	add    %eax,%eax
  800e8a:	01 d8                	add    %ebx,%eax
  800e8c:	83 e8 30             	sub    $0x30,%eax
  800e8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e9a:	83 fb 2f             	cmp    $0x2f,%ebx
  800e9d:	7e 3e                	jle    800edd <vprintfmt+0xe9>
  800e9f:	83 fb 39             	cmp    $0x39,%ebx
  800ea2:	7f 39                	jg     800edd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ea7:	eb d5                	jmp    800e7e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eac:	83 c0 04             	add    $0x4,%eax
  800eaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb5:	83 e8 04             	sub    $0x4,%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ebd:	eb 1f                	jmp    800ede <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ebf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec3:	79 83                	jns    800e48 <vprintfmt+0x54>
				width = 0;
  800ec5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ecc:	e9 77 ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ed1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ed8:	e9 6b ff ff ff       	jmp    800e48 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800edd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ede:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee2:	0f 89 60 ff ff ff    	jns    800e48 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800eee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ef5:	e9 4e ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800efa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800efd:	e9 46 ff ff ff       	jmp    800e48 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f02:	8b 45 14             	mov    0x14(%ebp),%eax
  800f05:	83 c0 04             	add    $0x4,%eax
  800f08:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0e:	83 e8 04             	sub    $0x4,%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	83 ec 08             	sub    $0x8,%esp
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	50                   	push   %eax
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	ff d0                	call   *%eax
  800f1f:	83 c4 10             	add    $0x10,%esp
			break;
  800f22:	e9 9b 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f27:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2a:	83 c0 04             	add    $0x4,%eax
  800f2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f30:	8b 45 14             	mov    0x14(%ebp),%eax
  800f33:	83 e8 04             	sub    $0x4,%eax
  800f36:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f38:	85 db                	test   %ebx,%ebx
  800f3a:	79 02                	jns    800f3e <vprintfmt+0x14a>
				err = -err;
  800f3c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f3e:	83 fb 64             	cmp    $0x64,%ebx
  800f41:	7f 0b                	jg     800f4e <vprintfmt+0x15a>
  800f43:	8b 34 9d e0 4c 80 00 	mov    0x804ce0(,%ebx,4),%esi
  800f4a:	85 f6                	test   %esi,%esi
  800f4c:	75 19                	jne    800f67 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f4e:	53                   	push   %ebx
  800f4f:	68 85 4e 80 00       	push   $0x804e85
  800f54:	ff 75 0c             	pushl  0xc(%ebp)
  800f57:	ff 75 08             	pushl  0x8(%ebp)
  800f5a:	e8 70 02 00 00       	call   8011cf <printfmt>
  800f5f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f62:	e9 5b 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f67:	56                   	push   %esi
  800f68:	68 8e 4e 80 00       	push   $0x804e8e
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	ff 75 08             	pushl  0x8(%ebp)
  800f73:	e8 57 02 00 00       	call   8011cf <printfmt>
  800f78:	83 c4 10             	add    $0x10,%esp
			break;
  800f7b:	e9 42 02 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f80:	8b 45 14             	mov    0x14(%ebp),%eax
  800f83:	83 c0 04             	add    $0x4,%eax
  800f86:	89 45 14             	mov    %eax,0x14(%ebp)
  800f89:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8c:	83 e8 04             	sub    $0x4,%eax
  800f8f:	8b 30                	mov    (%eax),%esi
  800f91:	85 f6                	test   %esi,%esi
  800f93:	75 05                	jne    800f9a <vprintfmt+0x1a6>
				p = "(null)";
  800f95:	be 91 4e 80 00       	mov    $0x804e91,%esi
			if (width > 0 && padc != '-')
  800f9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f9e:	7e 6d                	jle    80100d <vprintfmt+0x219>
  800fa0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fa4:	74 67                	je     80100d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	50                   	push   %eax
  800fad:	56                   	push   %esi
  800fae:	e8 26 05 00 00       	call   8014d9 <strnlen>
  800fb3:	83 c4 10             	add    $0x10,%esp
  800fb6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fb9:	eb 16                	jmp    800fd1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fbb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fbf:	83 ec 08             	sub    $0x8,%esp
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fce:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd5:	7f e4                	jg     800fbb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fd7:	eb 34                	jmp    80100d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fdd:	74 1c                	je     800ffb <vprintfmt+0x207>
  800fdf:	83 fb 1f             	cmp    $0x1f,%ebx
  800fe2:	7e 05                	jle    800fe9 <vprintfmt+0x1f5>
  800fe4:	83 fb 7e             	cmp    $0x7e,%ebx
  800fe7:	7e 12                	jle    800ffb <vprintfmt+0x207>
					putch('?', putdat);
  800fe9:	83 ec 08             	sub    $0x8,%esp
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	6a 3f                	push   $0x3f
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	ff d0                	call   *%eax
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	eb 0f                	jmp    80100a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	53                   	push   %ebx
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	89 f0                	mov    %esi,%eax
  80100f:	8d 70 01             	lea    0x1(%eax),%esi
  801012:	8a 00                	mov    (%eax),%al
  801014:	0f be d8             	movsbl %al,%ebx
  801017:	85 db                	test   %ebx,%ebx
  801019:	74 24                	je     80103f <vprintfmt+0x24b>
  80101b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80101f:	78 b8                	js     800fd9 <vprintfmt+0x1e5>
  801021:	ff 4d e0             	decl   -0x20(%ebp)
  801024:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801028:	79 af                	jns    800fd9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80102a:	eb 13                	jmp    80103f <vprintfmt+0x24b>
				putch(' ', putdat);
  80102c:	83 ec 08             	sub    $0x8,%esp
  80102f:	ff 75 0c             	pushl  0xc(%ebp)
  801032:	6a 20                	push   $0x20
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	ff d0                	call   *%eax
  801039:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80103c:	ff 4d e4             	decl   -0x1c(%ebp)
  80103f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801043:	7f e7                	jg     80102c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801045:	e9 78 01 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80104a:	83 ec 08             	sub    $0x8,%esp
  80104d:	ff 75 e8             	pushl  -0x18(%ebp)
  801050:	8d 45 14             	lea    0x14(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	e8 3c fd ff ff       	call   800d95 <getint>
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801068:	85 d2                	test   %edx,%edx
  80106a:	79 23                	jns    80108f <vprintfmt+0x29b>
				putch('-', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 2d                	push   $0x2d
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801082:	f7 d8                	neg    %eax
  801084:	83 d2 00             	adc    $0x0,%edx
  801087:	f7 da                	neg    %edx
  801089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80108f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801096:	e9 bc 00 00 00       	jmp    801157 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80109b:	83 ec 08             	sub    $0x8,%esp
  80109e:	ff 75 e8             	pushl  -0x18(%ebp)
  8010a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8010a4:	50                   	push   %eax
  8010a5:	e8 84 fc ff ff       	call   800d2e <getuint>
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010ba:	e9 98 00 00 00       	jmp    801157 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	6a 58                	push   $0x58
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	ff d0                	call   *%eax
  8010cc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010cf:	83 ec 08             	sub    $0x8,%esp
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	6a 58                	push   $0x58
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	ff d0                	call   *%eax
  8010dc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	ff 75 0c             	pushl  0xc(%ebp)
  8010e5:	6a 58                	push   $0x58
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	ff d0                	call   *%eax
  8010ec:	83 c4 10             	add    $0x10,%esp
			break;
  8010ef:	e9 ce 00 00 00       	jmp    8011c2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	ff 75 0c             	pushl  0xc(%ebp)
  8010fa:	6a 30                	push   $0x30
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	ff d0                	call   *%eax
  801101:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	6a 78                	push   $0x78
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	ff d0                	call   *%eax
  801111:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801114:	8b 45 14             	mov    0x14(%ebp),%eax
  801117:	83 c0 04             	add    $0x4,%eax
  80111a:	89 45 14             	mov    %eax,0x14(%ebp)
  80111d:	8b 45 14             	mov    0x14(%ebp),%eax
  801120:	83 e8 04             	sub    $0x4,%eax
  801123:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801125:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80112f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801136:	eb 1f                	jmp    801157 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 e8             	pushl  -0x18(%ebp)
  80113e:	8d 45 14             	lea    0x14(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	e8 e7 fb ff ff       	call   800d2e <getuint>
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801150:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801157:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80115b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80115e:	83 ec 04             	sub    $0x4,%esp
  801161:	52                   	push   %edx
  801162:	ff 75 e4             	pushl  -0x1c(%ebp)
  801165:	50                   	push   %eax
  801166:	ff 75 f4             	pushl  -0xc(%ebp)
  801169:	ff 75 f0             	pushl  -0x10(%ebp)
  80116c:	ff 75 0c             	pushl  0xc(%ebp)
  80116f:	ff 75 08             	pushl  0x8(%ebp)
  801172:	e8 00 fb ff ff       	call   800c77 <printnum>
  801177:	83 c4 20             	add    $0x20,%esp
			break;
  80117a:	eb 46                	jmp    8011c2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	53                   	push   %ebx
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			break;
  80118b:	eb 35                	jmp    8011c2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80118d:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  801194:	eb 2c                	jmp    8011c2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801196:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  80119d:	eb 23                	jmp    8011c2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80119f:	83 ec 08             	sub    $0x8,%esp
  8011a2:	ff 75 0c             	pushl  0xc(%ebp)
  8011a5:	6a 25                	push   $0x25
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	ff d0                	call   *%eax
  8011ac:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011af:	ff 4d 10             	decl   0x10(%ebp)
  8011b2:	eb 03                	jmp    8011b7 <vprintfmt+0x3c3>
  8011b4:	ff 4d 10             	decl   0x10(%ebp)
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	48                   	dec    %eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 25                	cmp    $0x25,%al
  8011bf:	75 f3                	jne    8011b4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011c1:	90                   	nop
		}
	}
  8011c2:	e9 35 fc ff ff       	jmp    800dfc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011c7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e4:	50                   	push   %eax
  8011e5:	ff 75 0c             	pushl  0xc(%ebp)
  8011e8:	ff 75 08             	pushl  0x8(%ebp)
  8011eb:	e8 04 fc ff ff       	call   800df4 <vprintfmt>
  8011f0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011f3:	90                   	nop
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	8b 40 08             	mov    0x8(%eax),%eax
  8011ff:	8d 50 01             	lea    0x1(%eax),%edx
  801202:	8b 45 0c             	mov    0xc(%ebp),%eax
  801205:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	8b 10                	mov    (%eax),%edx
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	8b 40 04             	mov    0x4(%eax),%eax
  801213:	39 c2                	cmp    %eax,%edx
  801215:	73 12                	jae    801229 <sprintputch+0x33>
		*b->buf++ = ch;
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 48 01             	lea    0x1(%eax),%ecx
  80121f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801222:	89 0a                	mov    %ecx,(%edx)
  801224:	8b 55 08             	mov    0x8(%ebp),%edx
  801227:	88 10                	mov    %dl,(%eax)
}
  801229:	90                   	nop
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	01 d0                	add    %edx,%eax
  801243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80124d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801251:	74 06                	je     801259 <vsnprintf+0x2d>
  801253:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801257:	7f 07                	jg     801260 <vsnprintf+0x34>
		return -E_INVAL;
  801259:	b8 03 00 00 00       	mov    $0x3,%eax
  80125e:	eb 20                	jmp    801280 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801260:	ff 75 14             	pushl  0x14(%ebp)
  801263:	ff 75 10             	pushl  0x10(%ebp)
  801266:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801269:	50                   	push   %eax
  80126a:	68 f6 11 80 00       	push   $0x8011f6
  80126f:	e8 80 fb ff ff       	call   800df4 <vprintfmt>
  801274:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801277:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80127a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80127d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801288:	8d 45 10             	lea    0x10(%ebp),%eax
  80128b:	83 c0 04             	add    $0x4,%eax
  80128e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801291:	8b 45 10             	mov    0x10(%ebp),%eax
  801294:	ff 75 f4             	pushl  -0xc(%ebp)
  801297:	50                   	push   %eax
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 89 ff ff ff       	call   80122c <vsnprintf>
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b8:	74 13                	je     8012cd <readline+0x1f>
		cprintf("%s", prompt);
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	ff 75 08             	pushl  0x8(%ebp)
  8012c0:	68 08 50 80 00       	push   $0x805008
  8012c5:	e8 0b f9 ff ff       	call   800bd5 <cprintf>
  8012ca:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	6a 00                	push   $0x0
  8012d9:	e8 6f f4 ff ff       	call   80074d <iscons>
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012e4:	e8 51 f4 ff ff       	call   80073a <getchar>
  8012e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f0:	79 22                	jns    801314 <readline+0x66>
			if (c != -E_EOF)
  8012f2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012f6:	0f 84 ad 00 00 00    	je     8013a9 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801302:	68 0b 50 80 00       	push   $0x80500b
  801307:	e8 c9 f8 ff ff       	call   800bd5 <cprintf>
  80130c:	83 c4 10             	add    $0x10,%esp
			break;
  80130f:	e9 95 00 00 00       	jmp    8013a9 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801314:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801318:	7e 34                	jle    80134e <readline+0xa0>
  80131a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801321:	7f 2b                	jg     80134e <readline+0xa0>
			if (echoing)
  801323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801327:	74 0e                	je     801337 <readline+0x89>
				cputchar(c);
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	ff 75 ec             	pushl  -0x14(%ebp)
  80132f:	e8 e7 f3 ff ff       	call   80071b <cputchar>
  801334:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133a:	8d 50 01             	lea    0x1(%eax),%edx
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801340:	89 c2                	mov    %eax,%edx
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80134a:	88 10                	mov    %dl,(%eax)
  80134c:	eb 56                	jmp    8013a4 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80134e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801352:	75 1f                	jne    801373 <readline+0xc5>
  801354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801358:	7e 19                	jle    801373 <readline+0xc5>
			if (echoing)
  80135a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80135e:	74 0e                	je     80136e <readline+0xc0>
				cputchar(c);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	ff 75 ec             	pushl  -0x14(%ebp)
  801366:	e8 b0 f3 ff ff       	call   80071b <cputchar>
  80136b:	83 c4 10             	add    $0x10,%esp

			i--;
  80136e:	ff 4d f4             	decl   -0xc(%ebp)
  801371:	eb 31                	jmp    8013a4 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801373:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801377:	74 0a                	je     801383 <readline+0xd5>
  801379:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80137d:	0f 85 61 ff ff ff    	jne    8012e4 <readline+0x36>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <readline+0xe9>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 87 f3 ff ff       	call   80071b <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013a2:	eb 06                	jmp    8013aa <readline+0xfc>
		}
	}
  8013a4:	e9 3b ff ff ff       	jmp    8012e4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013a9:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013aa:	90                   	nop
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013b3:	e8 df 21 00 00       	call   803597 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013bc:	74 13                	je     8013d1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	68 08 50 80 00       	push   $0x805008
  8013c9:	e8 07 f8 ff ff       	call   800bd5 <cprintf>
  8013ce:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	6a 00                	push   $0x0
  8013dd:	e8 6b f3 ff ff       	call   80074d <iscons>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013e8:	e8 4d f3 ff ff       	call   80073a <getchar>
  8013ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013f4:	79 22                	jns    801418 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013f6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013fa:	0f 84 ad 00 00 00    	je     8014ad <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 ec             	pushl  -0x14(%ebp)
  801406:	68 0b 50 80 00       	push   $0x80500b
  80140b:	e8 c5 f7 ff ff       	call   800bd5 <cprintf>
  801410:	83 c4 10             	add    $0x10,%esp
				break;
  801413:	e9 95 00 00 00       	jmp    8014ad <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801418:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80141c:	7e 34                	jle    801452 <atomic_readline+0xa5>
  80141e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801425:	7f 2b                	jg     801452 <atomic_readline+0xa5>
				if (echoing)
  801427:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80142b:	74 0e                	je     80143b <atomic_readline+0x8e>
					cputchar(c);
  80142d:	83 ec 0c             	sub    $0xc,%esp
  801430:	ff 75 ec             	pushl  -0x14(%ebp)
  801433:	e8 e3 f2 ff ff       	call   80071b <cputchar>
  801438:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80143b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143e:	8d 50 01             	lea    0x1(%eax),%edx
  801441:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801444:	89 c2                	mov    %eax,%edx
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80144e:	88 10                	mov    %dl,(%eax)
  801450:	eb 56                	jmp    8014a8 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801452:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801456:	75 1f                	jne    801477 <atomic_readline+0xca>
  801458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80145c:	7e 19                	jle    801477 <atomic_readline+0xca>
				if (echoing)
  80145e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801462:	74 0e                	je     801472 <atomic_readline+0xc5>
					cputchar(c);
  801464:	83 ec 0c             	sub    $0xc,%esp
  801467:	ff 75 ec             	pushl  -0x14(%ebp)
  80146a:	e8 ac f2 ff ff       	call   80071b <cputchar>
  80146f:	83 c4 10             	add    $0x10,%esp
				i--;
  801472:	ff 4d f4             	decl   -0xc(%ebp)
  801475:	eb 31                	jmp    8014a8 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801477:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80147b:	74 0a                	je     801487 <atomic_readline+0xda>
  80147d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801481:	0f 85 61 ff ff ff    	jne    8013e8 <atomic_readline+0x3b>
				if (echoing)
  801487:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148b:	74 0e                	je     80149b <atomic_readline+0xee>
					cputchar(c);
  80148d:	83 ec 0c             	sub    $0xc,%esp
  801490:	ff 75 ec             	pushl  -0x14(%ebp)
  801493:	e8 83 f2 ff ff       	call   80071b <cputchar>
  801498:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80149b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a1:	01 d0                	add    %edx,%eax
  8014a3:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014a6:	eb 06                	jmp    8014ae <atomic_readline+0x101>
			}
		}
  8014a8:	e9 3b ff ff ff       	jmp    8013e8 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014ad:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014ae:	e8 fe 20 00 00       	call   8035b1 <sys_unlock_cons>
}
  8014b3:	90                   	nop
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c3:	eb 06                	jmp    8014cb <strlen+0x15>
		n++;
  8014c5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014c8:	ff 45 08             	incl   0x8(%ebp)
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	84 c0                	test   %al,%al
  8014d2:	75 f1                	jne    8014c5 <strlen+0xf>
		n++;
	return n;
  8014d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e6:	eb 09                	jmp    8014f1 <strnlen+0x18>
		n++;
  8014e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014eb:	ff 45 08             	incl   0x8(%ebp)
  8014ee:	ff 4d 0c             	decl   0xc(%ebp)
  8014f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f5:	74 09                	je     801500 <strnlen+0x27>
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8a 00                	mov    (%eax),%al
  8014fc:	84 c0                	test   %al,%al
  8014fe:	75 e8                	jne    8014e8 <strnlen+0xf>
		n++;
	return n;
  801500:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801511:	90                   	nop
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8d 50 01             	lea    0x1(%eax),%edx
  801518:	89 55 08             	mov    %edx,0x8(%ebp)
  80151b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801521:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801524:	8a 12                	mov    (%edx),%dl
  801526:	88 10                	mov    %dl,(%eax)
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	75 e4                	jne    801512 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80152e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80153f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801546:	eb 1f                	jmp    801567 <strncpy+0x34>
		*dst++ = *src;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8d 50 01             	lea    0x1(%eax),%edx
  80154e:	89 55 08             	mov    %edx,0x8(%ebp)
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8a 12                	mov    (%edx),%dl
  801556:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	84 c0                	test   %al,%al
  80155f:	74 03                	je     801564 <strncpy+0x31>
			src++;
  801561:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801564:	ff 45 fc             	incl   -0x4(%ebp)
  801567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80156d:	72 d9                	jb     801548 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80156f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801580:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801584:	74 30                	je     8015b6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801586:	eb 16                	jmp    80159e <strlcpy+0x2a>
			*dst++ = *src++;
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8d 50 01             	lea    0x1(%eax),%edx
  80158e:	89 55 08             	mov    %edx,0x8(%ebp)
  801591:	8b 55 0c             	mov    0xc(%ebp),%edx
  801594:	8d 4a 01             	lea    0x1(%edx),%ecx
  801597:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80159a:	8a 12                	mov    (%edx),%dl
  80159c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80159e:	ff 4d 10             	decl   0x10(%ebp)
  8015a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a5:	74 09                	je     8015b0 <strlcpy+0x3c>
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	84 c0                	test   %al,%al
  8015ae:	75 d8                	jne    801588 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bc:	29 c2                	sub    %eax,%edx
  8015be:	89 d0                	mov    %edx,%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015c5:	eb 06                	jmp    8015cd <strcmp+0xb>
		p++, q++;
  8015c7:	ff 45 08             	incl   0x8(%ebp)
  8015ca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	84 c0                	test   %al,%al
  8015d4:	74 0e                	je     8015e4 <strcmp+0x22>
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8a 10                	mov    (%eax),%dl
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	38 c2                	cmp    %al,%dl
  8015e2:	74 e3                	je     8015c7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	0f b6 d0             	movzbl %al,%edx
  8015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	0f b6 c0             	movzbl %al,%eax
  8015f4:	29 c2                	sub    %eax,%edx
  8015f6:	89 d0                	mov    %edx,%eax
}
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    

008015fa <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015fd:	eb 09                	jmp    801608 <strncmp+0xe>
		n--, p++, q++;
  8015ff:	ff 4d 10             	decl   0x10(%ebp)
  801602:	ff 45 08             	incl   0x8(%ebp)
  801605:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801608:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80160c:	74 17                	je     801625 <strncmp+0x2b>
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	8a 00                	mov    (%eax),%al
  801613:	84 c0                	test   %al,%al
  801615:	74 0e                	je     801625 <strncmp+0x2b>
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8a 10                	mov    (%eax),%dl
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	38 c2                	cmp    %al,%dl
  801623:	74 da                	je     8015ff <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801625:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801629:	75 07                	jne    801632 <strncmp+0x38>
		return 0;
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
  801630:	eb 14                	jmp    801646 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	0f b6 d0             	movzbl %al,%edx
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	8a 00                	mov    (%eax),%al
  80163f:	0f b6 c0             	movzbl %al,%eax
  801642:	29 c2                	sub    %eax,%edx
  801644:	89 d0                	mov    %edx,%eax
}
  801646:	5d                   	pop    %ebp
  801647:	c3                   	ret    

00801648 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801651:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801654:	eb 12                	jmp    801668 <strchr+0x20>
		if (*s == c)
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8a 00                	mov    (%eax),%al
  80165b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80165e:	75 05                	jne    801665 <strchr+0x1d>
			return (char *) s;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	eb 11                	jmp    801676 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801665:	ff 45 08             	incl   0x8(%ebp)
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	84 c0                	test   %al,%al
  80166f:	75 e5                	jne    801656 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801681:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801684:	eb 0d                	jmp    801693 <strfind+0x1b>
		if (*s == c)
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80168e:	74 0e                	je     80169e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801690:	ff 45 08             	incl   0x8(%ebp)
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	84 c0                	test   %al,%al
  80169a:	75 ea                	jne    801686 <strfind+0xe>
  80169c:	eb 01                	jmp    80169f <strfind+0x27>
		if (*s == c)
			break;
  80169e:	90                   	nop
	return (char *) s;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8016b0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016b4:	76 63                	jbe    801719 <memset+0x75>
		uint64 data_block = c;
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	99                   	cltd   
  8016ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016ca:	c1 e0 08             	shl    $0x8,%eax
  8016cd:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016d0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016dd:	c1 e0 10             	shl    $0x10,%eax
  8016e0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016e3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ec:	89 c2                	mov    %eax,%edx
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016f6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8016f9:	eb 18                	jmp    801713 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8016fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016fe:	8d 41 08             	lea    0x8(%ecx),%eax
  801701:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170a:	89 01                	mov    %eax,(%ecx)
  80170c:	89 51 04             	mov    %edx,0x4(%ecx)
  80170f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801713:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801717:	77 e2                	ja     8016fb <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801719:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171d:	74 23                	je     801742 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80171f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801725:	eb 0e                	jmp    801735 <memset+0x91>
			*p8++ = (uint8)c;
  801727:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172a:	8d 50 01             	lea    0x1(%eax),%edx
  80172d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801730:	8b 55 0c             	mov    0xc(%ebp),%edx
  801733:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801735:	8b 45 10             	mov    0x10(%ebp),%eax
  801738:	8d 50 ff             	lea    -0x1(%eax),%edx
  80173b:	89 55 10             	mov    %edx,0x10(%ebp)
  80173e:	85 c0                	test   %eax,%eax
  801740:	75 e5                	jne    801727 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801759:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80175d:	76 24                	jbe    801783 <memcpy+0x3c>
		while(n >= 8){
  80175f:	eb 1c                	jmp    80177d <memcpy+0x36>
			*d64 = *s64;
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	8b 50 04             	mov    0x4(%eax),%edx
  801767:	8b 00                	mov    (%eax),%eax
  801769:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80176c:	89 01                	mov    %eax,(%ecx)
  80176e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801771:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801775:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801779:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80177d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801781:	77 de                	ja     801761 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801783:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801787:	74 31                	je     8017ba <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801789:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80178f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801792:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801795:	eb 16                	jmp    8017ad <memcpy+0x66>
			*d8++ = *s8++;
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179a:	8d 50 01             	lea    0x1(%eax),%edx
  80179d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8017a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017a6:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8017a9:	8a 12                	mov    (%edx),%dl
  8017ab:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8017ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	75 dd                	jne    801797 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017d7:	73 50                	jae    801829 <memmove+0x6a>
  8017d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	01 d0                	add    %edx,%eax
  8017e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017e4:	76 43                	jbe    801829 <memmove+0x6a>
		s += n;
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ef:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017f2:	eb 10                	jmp    801804 <memmove+0x45>
			*--d = *--s;
  8017f4:	ff 4d f8             	decl   -0x8(%ebp)
  8017f7:	ff 4d fc             	decl   -0x4(%ebp)
  8017fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017fd:	8a 10                	mov    (%eax),%dl
  8017ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801802:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180a:	89 55 10             	mov    %edx,0x10(%ebp)
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 e3                	jne    8017f4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801811:	eb 23                	jmp    801836 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801813:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801816:	8d 50 01             	lea    0x1(%eax),%edx
  801819:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801822:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801825:	8a 12                	mov    (%edx),%dl
  801827:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801829:	8b 45 10             	mov    0x10(%ebp),%eax
  80182c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182f:	89 55 10             	mov    %edx,0x10(%ebp)
  801832:	85 c0                	test   %eax,%eax
  801834:	75 dd                	jne    801813 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80184d:	eb 2a                	jmp    801879 <memcmp+0x3e>
		if (*s1 != *s2)
  80184f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801852:	8a 10                	mov    (%eax),%dl
  801854:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801857:	8a 00                	mov    (%eax),%al
  801859:	38 c2                	cmp    %al,%dl
  80185b:	74 16                	je     801873 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80185d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801860:	8a 00                	mov    (%eax),%al
  801862:	0f b6 d0             	movzbl %al,%edx
  801865:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801868:	8a 00                	mov    (%eax),%al
  80186a:	0f b6 c0             	movzbl %al,%eax
  80186d:	29 c2                	sub    %eax,%edx
  80186f:	89 d0                	mov    %edx,%eax
  801871:	eb 18                	jmp    80188b <memcmp+0x50>
		s1++, s2++;
  801873:	ff 45 fc             	incl   -0x4(%ebp)
  801876:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80187f:	89 55 10             	mov    %edx,0x10(%ebp)
  801882:	85 c0                	test   %eax,%eax
  801884:	75 c9                	jne    80184f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801893:	8b 55 08             	mov    0x8(%ebp),%edx
  801896:	8b 45 10             	mov    0x10(%ebp),%eax
  801899:	01 d0                	add    %edx,%eax
  80189b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80189e:	eb 15                	jmp    8018b5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	0f b6 d0             	movzbl %al,%edx
  8018a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ab:	0f b6 c0             	movzbl %al,%eax
  8018ae:	39 c2                	cmp    %eax,%edx
  8018b0:	74 0d                	je     8018bf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018b2:	ff 45 08             	incl   0x8(%ebp)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018bb:	72 e3                	jb     8018a0 <memfind+0x13>
  8018bd:	eb 01                	jmp    8018c0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018bf:	90                   	nop
	return (void *) s;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018d9:	eb 03                	jmp    8018de <strtol+0x19>
		s++;
  8018db:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 20                	cmp    $0x20,%al
  8018e5:	74 f4                	je     8018db <strtol+0x16>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 09                	cmp    $0x9,%al
  8018ee:	74 eb                	je     8018db <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	3c 2b                	cmp    $0x2b,%al
  8018f7:	75 05                	jne    8018fe <strtol+0x39>
		s++;
  8018f9:	ff 45 08             	incl   0x8(%ebp)
  8018fc:	eb 13                	jmp    801911 <strtol+0x4c>
	else if (*s == '-')
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8a 00                	mov    (%eax),%al
  801903:	3c 2d                	cmp    $0x2d,%al
  801905:	75 0a                	jne    801911 <strtol+0x4c>
		s++, neg = 1;
  801907:	ff 45 08             	incl   0x8(%ebp)
  80190a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801911:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801915:	74 06                	je     80191d <strtol+0x58>
  801917:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80191b:	75 20                	jne    80193d <strtol+0x78>
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	3c 30                	cmp    $0x30,%al
  801924:	75 17                	jne    80193d <strtol+0x78>
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	40                   	inc    %eax
  80192a:	8a 00                	mov    (%eax),%al
  80192c:	3c 78                	cmp    $0x78,%al
  80192e:	75 0d                	jne    80193d <strtol+0x78>
		s += 2, base = 16;
  801930:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801934:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80193b:	eb 28                	jmp    801965 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80193d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801941:	75 15                	jne    801958 <strtol+0x93>
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8a 00                	mov    (%eax),%al
  801948:	3c 30                	cmp    $0x30,%al
  80194a:	75 0c                	jne    801958 <strtol+0x93>
		s++, base = 8;
  80194c:	ff 45 08             	incl   0x8(%ebp)
  80194f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801956:	eb 0d                	jmp    801965 <strtol+0xa0>
	else if (base == 0)
  801958:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80195c:	75 07                	jne    801965 <strtol+0xa0>
		base = 10;
  80195e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	8a 00                	mov    (%eax),%al
  80196a:	3c 2f                	cmp    $0x2f,%al
  80196c:	7e 19                	jle    801987 <strtol+0xc2>
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	8a 00                	mov    (%eax),%al
  801973:	3c 39                	cmp    $0x39,%al
  801975:	7f 10                	jg     801987 <strtol+0xc2>
			dig = *s - '0';
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8a 00                	mov    (%eax),%al
  80197c:	0f be c0             	movsbl %al,%eax
  80197f:	83 e8 30             	sub    $0x30,%eax
  801982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801985:	eb 42                	jmp    8019c9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	8a 00                	mov    (%eax),%al
  80198c:	3c 60                	cmp    $0x60,%al
  80198e:	7e 19                	jle    8019a9 <strtol+0xe4>
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	3c 7a                	cmp    $0x7a,%al
  801997:	7f 10                	jg     8019a9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	83 e8 57             	sub    $0x57,%eax
  8019a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019a7:	eb 20                	jmp    8019c9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	8a 00                	mov    (%eax),%al
  8019ae:	3c 40                	cmp    $0x40,%al
  8019b0:	7e 39                	jle    8019eb <strtol+0x126>
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8a 00                	mov    (%eax),%al
  8019b7:	3c 5a                	cmp    $0x5a,%al
  8019b9:	7f 30                	jg     8019eb <strtol+0x126>
			dig = *s - 'A' + 10;
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8a 00                	mov    (%eax),%al
  8019c0:	0f be c0             	movsbl %al,%eax
  8019c3:	83 e8 37             	sub    $0x37,%eax
  8019c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019cf:	7d 19                	jge    8019ea <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019d1:	ff 45 08             	incl   0x8(%ebp)
  8019d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019db:	89 c2                	mov    %eax,%edx
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019e5:	e9 7b ff ff ff       	jmp    801965 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ea:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019ef:	74 08                	je     8019f9 <strtol+0x134>
		*endptr = (char *) s;
  8019f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8019f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019fd:	74 07                	je     801a06 <strtol+0x141>
  8019ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a02:	f7 d8                	neg    %eax
  801a04:	eb 03                	jmp    801a09 <strtol+0x144>
  801a06:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <ltostr>:

void
ltostr(long value, char *str)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a23:	79 13                	jns    801a38 <ltostr+0x2d>
	{
		neg = 1;
  801a25:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a32:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a35:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a40:	99                   	cltd   
  801a41:	f7 f9                	idiv   %ecx
  801a43:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a49:	8d 50 01             	lea    0x1(%eax),%edx
  801a4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a4f:	89 c2                	mov    %eax,%edx
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	01 d0                	add    %edx,%eax
  801a56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a59:	83 c2 30             	add    $0x30,%edx
  801a5c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a61:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a66:	f7 e9                	imul   %ecx
  801a68:	c1 fa 02             	sar    $0x2,%edx
  801a6b:	89 c8                	mov    %ecx,%eax
  801a6d:	c1 f8 1f             	sar    $0x1f,%eax
  801a70:	29 c2                	sub    %eax,%edx
  801a72:	89 d0                	mov    %edx,%eax
  801a74:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	75 bb                	jne    801a38 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a87:	48                   	dec    %eax
  801a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a8f:	74 3d                	je     801ace <ltostr+0xc3>
		start = 1 ;
  801a91:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a98:	eb 34                	jmp    801ace <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa0:	01 d0                	add    %edx,%eax
  801aa2:	8a 00                	mov    (%eax),%al
  801aa4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aad:	01 c2                	add    %eax,%edx
  801aaf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab5:	01 c8                	add    %ecx,%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac1:	01 c2                	add    %eax,%edx
  801ac3:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ac6:	88 02                	mov    %al,(%edx)
		start++ ;
  801ac8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801acb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ad4:	7c c4                	jl     801a9a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ad6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	e8 c4 f9 ff ff       	call   8014b6 <strlen>
  801af2:	83 c4 04             	add    $0x4,%esp
  801af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801af8:	ff 75 0c             	pushl  0xc(%ebp)
  801afb:	e8 b6 f9 ff ff       	call   8014b6 <strlen>
  801b00:	83 c4 04             	add    $0x4,%esp
  801b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b14:	eb 17                	jmp    801b2d <strcconcat+0x49>
		final[s] = str1[s] ;
  801b16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1c:	01 c2                	add    %eax,%edx
  801b1e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	01 c8                	add    %ecx,%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b2a:	ff 45 fc             	incl   -0x4(%ebp)
  801b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b30:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b33:	7c e1                	jl     801b16 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b35:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b3c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b43:	eb 1f                	jmp    801b64 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b48:	8d 50 01             	lea    0x1(%eax),%edx
  801b4b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b4e:	89 c2                	mov    %eax,%edx
  801b50:	8b 45 10             	mov    0x10(%ebp),%eax
  801b53:	01 c2                	add    %eax,%edx
  801b55:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c8                	add    %ecx,%eax
  801b5d:	8a 00                	mov    (%eax),%al
  801b5f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b61:	ff 45 f8             	incl   -0x8(%ebp)
  801b64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6a:	7c d9                	jl     801b45 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b72:	01 d0                	add    %edx,%eax
  801b74:	c6 00 00             	movb   $0x0,(%eax)
}
  801b77:	90                   	nop
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b86:	8b 45 14             	mov    0x14(%ebp),%eax
  801b89:	8b 00                	mov    (%eax),%eax
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 d0                	add    %edx,%eax
  801b97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b9d:	eb 0c                	jmp    801bab <strsplit+0x31>
			*string++ = 0;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	8d 50 01             	lea    0x1(%eax),%edx
  801ba5:	89 55 08             	mov    %edx,0x8(%ebp)
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	8a 00                	mov    (%eax),%al
  801bb0:	84 c0                	test   %al,%al
  801bb2:	74 18                	je     801bcc <strsplit+0x52>
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	8a 00                	mov    (%eax),%al
  801bb9:	0f be c0             	movsbl %al,%eax
  801bbc:	50                   	push   %eax
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	e8 83 fa ff ff       	call   801648 <strchr>
  801bc5:	83 c4 08             	add    $0x8,%esp
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	75 d3                	jne    801b9f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	84 c0                	test   %al,%al
  801bd3:	74 5a                	je     801c2f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd8:	8b 00                	mov    (%eax),%eax
  801bda:	83 f8 0f             	cmp    $0xf,%eax
  801bdd:	75 07                	jne    801be6 <strsplit+0x6c>
		{
			return 0;
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801be4:	eb 66                	jmp    801c4c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801be6:	8b 45 14             	mov    0x14(%ebp),%eax
  801be9:	8b 00                	mov    (%eax),%eax
  801beb:	8d 48 01             	lea    0x1(%eax),%ecx
  801bee:	8b 55 14             	mov    0x14(%ebp),%edx
  801bf1:	89 0a                	mov    %ecx,(%edx)
  801bf3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfd:	01 c2                	add    %eax,%edx
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c04:	eb 03                	jmp    801c09 <strsplit+0x8f>
			string++;
  801c06:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	8a 00                	mov    (%eax),%al
  801c0e:	84 c0                	test   %al,%al
  801c10:	74 8b                	je     801b9d <strsplit+0x23>
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	8a 00                	mov    (%eax),%al
  801c17:	0f be c0             	movsbl %al,%eax
  801c1a:	50                   	push   %eax
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	e8 25 fa ff ff       	call   801648 <strchr>
  801c23:	83 c4 08             	add    $0x8,%esp
  801c26:	85 c0                	test   %eax,%eax
  801c28:	74 dc                	je     801c06 <strsplit+0x8c>
			string++;
	}
  801c2a:	e9 6e ff ff ff       	jmp    801b9d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c2f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c30:	8b 45 14             	mov    0x14(%ebp),%eax
  801c33:	8b 00                	mov    (%eax),%eax
  801c35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3f:	01 d0                	add    %edx,%eax
  801c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c47:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c61:	eb 4a                	jmp    801cad <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	01 c2                	add    %eax,%edx
  801c6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c71:	01 c8                	add    %ecx,%eax
  801c73:	8a 00                	mov    (%eax),%al
  801c75:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7d:	01 d0                	add    %edx,%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 40                	cmp    $0x40,%al
  801c83:	7e 25                	jle    801caa <str2lower+0x5c>
  801c85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8b:	01 d0                	add    %edx,%eax
  801c8d:	8a 00                	mov    (%eax),%al
  801c8f:	3c 5a                	cmp    $0x5a,%al
  801c91:	7f 17                	jg     801caa <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801c93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	01 d0                	add    %edx,%eax
  801c9b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca1:	01 ca                	add    %ecx,%edx
  801ca3:	8a 12                	mov    (%edx),%dl
  801ca5:	83 c2 20             	add    $0x20,%edx
  801ca8:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801caa:	ff 45 fc             	incl   -0x4(%ebp)
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	e8 01 f8 ff ff       	call   8014b6 <strlen>
  801cb5:	83 c4 04             	add    $0x4,%esp
  801cb8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cbb:	7f a6                	jg     801c63 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801cc8:	a1 08 60 80 00       	mov    0x806008,%eax
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	74 42                	je     801d13 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801cd1:	83 ec 08             	sub    $0x8,%esp
  801cd4:	68 00 00 00 82       	push   $0x82000000
  801cd9:	68 00 00 00 80       	push   $0x80000000
  801cde:	e8 b0 1e 00 00       	call   803b93 <initialize_dynamic_allocator>
  801ce3:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801ce6:	e8 96 1c 00 00       	call   803981 <sys_get_uheap_strategy>
  801ceb:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801cf0:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801cf5:	05 00 10 00 00       	add    $0x1000,%eax
  801cfa:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801cff:	a1 30 61 83 00       	mov    0x836130,%eax
  801d04:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801d09:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801d10:	00 00 00 
	}
}
  801d13:	90                   	nop
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d2a:	83 ec 08             	sub    $0x8,%esp
  801d2d:	68 06 04 00 00       	push   $0x406
  801d32:	50                   	push   %eax
  801d33:	e8 93 18 00 00       	call   8035cb <__sys_allocate_page>
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d42:	79 14                	jns    801d58 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d44:	83 ec 04             	sub    $0x4,%esp
  801d47:	68 1c 50 80 00       	push   $0x80501c
  801d4c:	6a 1f                	push   $0x1f
  801d4e:	68 58 50 80 00       	push   $0x805058
  801d53:	e8 af eb ff ff       	call   800907 <_panic>
	return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d73:	83 ec 0c             	sub    $0xc,%esp
  801d76:	50                   	push   %eax
  801d77:	e8 96 18 00 00       	call   803612 <__sys_unmap_frame>
  801d7c:	83 c4 10             	add    $0x10,%esp
  801d7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d86:	79 14                	jns    801d9c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	68 64 50 80 00       	push   $0x805064
  801d90:	6a 2a                	push   $0x2a
  801d92:	68 58 50 80 00       	push   $0x805058
  801d97:	e8 6b eb ff ff       	call   800907 <_panic>
}
  801d9c:	90                   	nop
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801da5:	e8 18 ff ff ff       	call   801cc2 <uheap_init>
	if (size == 0) return NULL ;
  801daa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dae:	75 0a                	jne    801dba <malloc+0x1b>
  801db0:	b8 00 00 00 00       	mov    $0x0,%eax
  801db5:	e9 43 03 00 00       	jmp    8020fd <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801dba:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801dc1:	77 13                	ja     801dd6 <malloc+0x37>
    {
        return alloc_block(size);
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	ff 75 08             	pushl  0x8(%ebp)
  801dc9:	e8 78 20 00 00       	call   803e46 <alloc_block>
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	e9 27 03 00 00       	jmp    8020fd <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801dd6:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  801de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801de3:	01 d0                	add    %edx,%eax
  801de5:	48                   	dec    %eax
  801de6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801de9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dec:	ba 00 00 00 00       	mov    $0x0,%edx
  801df1:	f7 75 dc             	divl   -0x24(%ebp)
  801df4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801df7:	29 d0                	sub    %edx,%eax
  801df9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801dfc:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801e01:	85 c0                	test   %eax,%eax
  801e03:	75 0a                	jne    801e0f <malloc+0x70>
    {
        uhp_inited = 1;
  801e05:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801e0c:	00 00 00 
    }

    int exactIdx = -1;
  801e0f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801e16:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801e1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e2b:	e9 85 00 00 00       	jmp    801eb5 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801e30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e33:	89 d0                	mov    %edx,%eax
  801e35:	01 c0                	add    %eax,%eax
  801e37:	01 d0                	add    %edx,%eax
  801e39:	c1 e0 02             	shl    $0x2,%eax
  801e3c:	05 48 20 81 00       	add    $0x812048,%eax
  801e41:	8a 00                	mov    (%eax),%al
  801e43:	84 c0                	test   %al,%al
  801e45:	74 20                	je     801e67 <malloc+0xc8>
  801e47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e4a:	89 d0                	mov    %edx,%eax
  801e4c:	01 c0                	add    %eax,%eax
  801e4e:	01 d0                	add    %edx,%eax
  801e50:	c1 e0 02             	shl    $0x2,%eax
  801e53:	05 44 20 81 00       	add    $0x812044,%eax
  801e58:	8b 00                	mov    (%eax),%eax
  801e5a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e5d:	75 08                	jne    801e67 <malloc+0xc8>
        {
            exactIdx = i;
  801e5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801e65:	eb 5b                	jmp    801ec2 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801e67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e6a:	89 d0                	mov    %edx,%eax
  801e6c:	01 c0                	add    %eax,%eax
  801e6e:	01 d0                	add    %edx,%eax
  801e70:	c1 e0 02             	shl    $0x2,%eax
  801e73:	05 48 20 81 00       	add    $0x812048,%eax
  801e78:	8a 00                	mov    (%eax),%al
  801e7a:	84 c0                	test   %al,%al
  801e7c:	74 34                	je     801eb2 <malloc+0x113>
  801e7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e81:	89 d0                	mov    %edx,%eax
  801e83:	01 c0                	add    %eax,%eax
  801e85:	01 d0                	add    %edx,%eax
  801e87:	c1 e0 02             	shl    $0x2,%eax
  801e8a:	05 44 20 81 00       	add    $0x812044,%eax
  801e8f:	8b 00                	mov    (%eax),%eax
  801e91:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e94:	76 1c                	jbe    801eb2 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801e96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e99:	89 d0                	mov    %edx,%eax
  801e9b:	01 c0                	add    %eax,%eax
  801e9d:	01 d0                	add    %edx,%eax
  801e9f:	c1 e0 02             	shl    $0x2,%eax
  801ea2:	05 44 20 81 00       	add    $0x812044,%eax
  801ea7:	8b 00                	mov    (%eax),%eax
  801ea9:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801eb2:	ff 45 e8             	incl   -0x18(%ebp)
  801eb5:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801ebc:	0f 8e 6e ff ff ff    	jle    801e30 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801ec2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801ec9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801ecd:	74 7d                	je     801f4c <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801ecf:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801ed6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed9:	89 d0                	mov    %edx,%eax
  801edb:	01 c0                	add    %eax,%eax
  801edd:	01 d0                	add    %edx,%eax
  801edf:	c1 e0 02             	shl    $0x2,%eax
  801ee2:	05 40 20 81 00       	add    $0x812040,%eax
  801ee7:	8b 10                	mov    (%eax),%edx
  801ee9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	48                   	dec    %eax
  801eef:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801ef2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  801efa:	f7 75 bc             	divl   -0x44(%ebp)
  801efd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f00:	29 d0                	sub    %edx,%eax
  801f02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f08:	89 d0                	mov    %edx,%eax
  801f0a:	01 c0                	add    %eax,%eax
  801f0c:	01 d0                	add    %edx,%eax
  801f0e:	c1 e0 02             	shl    $0x2,%eax
  801f11:	05 48 20 81 00       	add    $0x812048,%eax
  801f16:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1c:	89 d0                	mov    %edx,%eax
  801f1e:	01 c0                	add    %eax,%eax
  801f20:	01 d0                	add    %edx,%eax
  801f22:	c1 e0 02             	shl    $0x2,%eax
  801f25:	05 44 20 81 00       	add    $0x812044,%eax
  801f2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f33:	89 d0                	mov    %edx,%eax
  801f35:	01 c0                	add    %eax,%eax
  801f37:	01 d0                	add    %edx,%eax
  801f39:	c1 e0 02             	shl    $0x2,%eax
  801f3c:	05 40 20 81 00       	add    $0x812040,%eax
  801f41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f47:	e9 2d 01 00 00       	jmp    802079 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801f4c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f50:	0f 84 ce 00 00 00    	je     802024 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801f56:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801f5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f60:	89 d0                	mov    %edx,%eax
  801f62:	01 c0                	add    %eax,%eax
  801f64:	01 d0                	add    %edx,%eax
  801f66:	c1 e0 02             	shl    $0x2,%eax
  801f69:	05 40 20 81 00       	add    $0x812040,%eax
  801f6e:	8b 10                	mov    (%eax),%edx
  801f70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f73:	01 d0                	add    %edx,%eax
  801f75:	48                   	dec    %eax
  801f76:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801f79:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f81:	f7 75 c4             	divl   -0x3c(%ebp)
  801f84:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f87:	29 d0                	sub    %edx,%eax
  801f89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801f8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f8f:	89 d0                	mov    %edx,%eax
  801f91:	01 c0                	add    %eax,%eax
  801f93:	01 d0                	add    %edx,%eax
  801f95:	c1 e0 02             	shl    $0x2,%eax
  801f98:	05 44 20 81 00       	add    $0x812044,%eax
  801f9d:	8b 00                	mov    (%eax),%eax
  801f9f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fa2:	75 47                	jne    801feb <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801fa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fa7:	89 d0                	mov    %edx,%eax
  801fa9:	01 c0                	add    %eax,%eax
  801fab:	01 d0                	add    %edx,%eax
  801fad:	c1 e0 02             	shl    $0x2,%eax
  801fb0:	05 48 20 81 00       	add    $0x812048,%eax
  801fb5:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801fb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fbb:	89 d0                	mov    %edx,%eax
  801fbd:	01 c0                	add    %eax,%eax
  801fbf:	01 d0                	add    %edx,%eax
  801fc1:	c1 e0 02             	shl    $0x2,%eax
  801fc4:	05 44 20 81 00       	add    $0x812044,%eax
  801fc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801fcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd2:	89 d0                	mov    %edx,%eax
  801fd4:	01 c0                	add    %eax,%eax
  801fd6:	01 d0                	add    %edx,%eax
  801fd8:	c1 e0 02             	shl    $0x2,%eax
  801fdb:	05 40 20 81 00       	add    $0x812040,%eax
  801fe0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fe6:	e9 8e 00 00 00       	jmp    802079 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801feb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ff1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801ff4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff7:	89 d0                	mov    %edx,%eax
  801ff9:	01 c0                	add    %eax,%eax
  801ffb:	01 d0                	add    %edx,%eax
  801ffd:	c1 e0 02             	shl    $0x2,%eax
  802000:	05 40 20 81 00       	add    $0x812040,%eax
  802005:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80200d:	89 c2                	mov    %eax,%edx
  80200f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802012:	89 c8                	mov    %ecx,%eax
  802014:	01 c0                	add    %eax,%eax
  802016:	01 c8                	add    %ecx,%eax
  802018:	c1 e0 02             	shl    $0x2,%eax
  80201b:	05 44 20 81 00       	add    $0x812044,%eax
  802020:	89 10                	mov    %edx,(%eax)
  802022:	eb 55                	jmp    802079 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802024:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80202b:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802031:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802034:	01 d0                	add    %edx,%eax
  802036:	48                   	dec    %eax
  802037:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80203a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80203d:	ba 00 00 00 00       	mov    $0x0,%edx
  802042:	f7 75 d0             	divl   -0x30(%ebp)
  802045:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802048:	29 d0                	sub    %edx,%eax
  80204a:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80204d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802050:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802053:	01 d0                	add    %edx,%eax
  802055:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80205a:	76 0a                	jbe    802066 <malloc+0x2c7>
            return NULL;
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	e9 97 00 00 00       	jmp    8020fd <malloc+0x35e>
        va = start;
  802066:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802069:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80206c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80206f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802072:	01 d0                	add    %edx,%eax
  802074:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802079:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802080:	eb 5e                	jmp    8020e0 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  802082:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802085:	89 d0                	mov    %edx,%eax
  802087:	01 c0                	add    %eax,%eax
  802089:	01 d0                	add    %edx,%eax
  80208b:	c1 e0 02             	shl    $0x2,%eax
  80208e:	05 48 60 80 00       	add    $0x806048,%eax
  802093:	8a 00                	mov    (%eax),%al
  802095:	84 c0                	test   %al,%al
  802097:	75 44                	jne    8020dd <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  802099:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80209c:	89 d0                	mov    %edx,%eax
  80209e:	01 c0                	add    %eax,%eax
  8020a0:	01 d0                	add    %edx,%eax
  8020a2:	c1 e0 02             	shl    $0x2,%eax
  8020a5:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  8020ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ae:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8020b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020b3:	89 d0                	mov    %edx,%eax
  8020b5:	01 c0                	add    %eax,%eax
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	c1 e0 02             	shl    $0x2,%eax
  8020bc:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8020c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020c5:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8020c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020ca:	89 d0                	mov    %edx,%eax
  8020cc:	01 c0                	add    %eax,%eax
  8020ce:	01 d0                	add    %edx,%eax
  8020d0:	c1 e0 02             	shl    $0x2,%eax
  8020d3:	05 48 60 80 00       	add    $0x806048,%eax
  8020d8:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8020db:	eb 0c                	jmp    8020e9 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8020dd:	ff 45 e0             	incl   -0x20(%ebp)
  8020e0:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8020e7:	7e 99                	jle    802082 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8020e9:	83 ec 08             	sub    $0x8,%esp
  8020ec:	ff 75 d4             	pushl  -0x2c(%ebp)
  8020ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020f2:	e8 a2 19 00 00       	call   803a99 <sys_allocate_user_mem>
  8020f7:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8020fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  802105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802109:	0f 84 fa 03 00 00    	je     802509 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802115:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	79 1c                	jns    802138 <free+0x39>
  80211c:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  802123:	77 13                	ja     802138 <free+0x39>
    {
        free_block(virtual_address);
  802125:	83 ec 0c             	sub    $0xc,%esp
  802128:	ff 75 08             	pushl  0x8(%ebp)
  80212b:	e8 09 21 00 00       	call   804239 <free_block>
  802130:	83 c4 10             	add    $0x10,%esp
        return;
  802133:	e9 d2 03 00 00       	jmp    80250a <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802138:	a1 30 61 83 00       	mov    0x836130,%eax
  80213d:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  802140:	72 09                	jb     80214b <free+0x4c>
  802142:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  802149:	76 17                	jbe    802162 <free+0x63>
        panic("free: invalid address");
  80214b:	83 ec 04             	sub    $0x4,%esp
  80214e:	68 a1 50 80 00       	push   $0x8050a1
  802153:	68 9b 00 00 00       	push   $0x9b
  802158:	68 58 50 80 00       	push   $0x805058
  80215d:	e8 a5 e7 ff ff       	call   800907 <_panic>

    uint32 size = 0;
  802162:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  802169:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802170:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802177:	eb 50                	jmp    8021c9 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802179:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80217c:	89 d0                	mov    %edx,%eax
  80217e:	01 c0                	add    %eax,%eax
  802180:	01 d0                	add    %edx,%eax
  802182:	c1 e0 02             	shl    $0x2,%eax
  802185:	05 48 60 80 00       	add    $0x806048,%eax
  80218a:	8a 00                	mov    (%eax),%al
  80218c:	84 c0                	test   %al,%al
  80218e:	74 36                	je     8021c6 <free+0xc7>
  802190:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802193:	89 d0                	mov    %edx,%eax
  802195:	01 c0                	add    %eax,%eax
  802197:	01 d0                	add    %edx,%eax
  802199:	c1 e0 02             	shl    $0x2,%eax
  80219c:	05 40 60 80 00       	add    $0x806040,%eax
  8021a1:	8b 00                	mov    (%eax),%eax
  8021a3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8021a6:	75 1e                	jne    8021c6 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  8021a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021ab:	89 d0                	mov    %edx,%eax
  8021ad:	01 c0                	add    %eax,%eax
  8021af:	01 d0                	add    %edx,%eax
  8021b1:	c1 e0 02             	shl    $0x2,%eax
  8021b4:	05 44 60 80 00       	add    $0x806044,%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  8021be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  8021c4:	eb 0c                	jmp    8021d2 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8021c6:	ff 45 ec             	incl   -0x14(%ebp)
  8021c9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8021d0:	7e a7                	jle    802179 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  8021d2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021d6:	74 06                	je     8021de <free+0xdf>
  8021d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021dc:	75 17                	jne    8021f5 <free+0xf6>
        panic("free: unknown block");
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	68 b7 50 80 00       	push   $0x8050b7
  8021e6:	68 a9 00 00 00       	push   $0xa9
  8021eb:	68 58 50 80 00       	push   $0x805058
  8021f0:	e8 12 e7 ff ff       	call   800907 <_panic>

    uhp_allocs[idx].used = 0;
  8021f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021f8:	89 d0                	mov    %edx,%eax
  8021fa:	01 c0                	add    %eax,%eax
  8021fc:	01 d0                	add    %edx,%eax
  8021fe:	c1 e0 02             	shl    $0x2,%eax
  802201:	05 48 60 80 00       	add    $0x806048,%eax
  802206:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  802209:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802210:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802217:	eb 64                	jmp    80227d <free+0x17e>
    {
        if (!uhp_frees[i].free)
  802219:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80221c:	89 d0                	mov    %edx,%eax
  80221e:	01 c0                	add    %eax,%eax
  802220:	01 d0                	add    %edx,%eax
  802222:	c1 e0 02             	shl    $0x2,%eax
  802225:	05 48 20 81 00       	add    $0x812048,%eax
  80222a:	8a 00                	mov    (%eax),%al
  80222c:	84 c0                	test   %al,%al
  80222e:	75 4a                	jne    80227a <free+0x17b>
        {
            uhp_frees[i].va = va;
  802230:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802233:	89 d0                	mov    %edx,%eax
  802235:	01 c0                	add    %eax,%eax
  802237:	01 d0                	add    %edx,%eax
  802239:	c1 e0 02             	shl    $0x2,%eax
  80223c:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802245:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802247:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80224a:	89 d0                	mov    %edx,%eax
  80224c:	01 c0                	add    %eax,%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	c1 e0 02             	shl    $0x2,%eax
  802253:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  80225e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802261:	89 d0                	mov    %edx,%eax
  802263:	01 c0                	add    %eax,%eax
  802265:	01 d0                	add    %edx,%eax
  802267:	c1 e0 02             	shl    $0x2,%eax
  80226a:	05 48 20 81 00       	add    $0x812048,%eax
  80226f:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802275:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802278:	eb 0c                	jmp    802286 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80227a:	ff 45 e4             	incl   -0x1c(%ebp)
  80227d:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802284:	7e 93                	jle    802219 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  802286:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80228a:	0f 84 f1 01 00 00    	je     802481 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802290:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802297:	e9 d8 01 00 00       	jmp    802474 <free+0x375>
        {
            if (i == fidx) continue;
  80229c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80229f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8022a2:	0f 84 c8 01 00 00    	je     802470 <free+0x371>
            if (uhp_frees[i].free)
  8022a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022ab:	89 d0                	mov    %edx,%eax
  8022ad:	01 c0                	add    %eax,%eax
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	c1 e0 02             	shl    $0x2,%eax
  8022b4:	05 48 20 81 00       	add    $0x812048,%eax
  8022b9:	8a 00                	mov    (%eax),%al
  8022bb:	84 c0                	test   %al,%al
  8022bd:	0f 84 ae 01 00 00    	je     802471 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  8022c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022c6:	89 d0                	mov    %edx,%eax
  8022c8:	01 c0                	add    %eax,%eax
  8022ca:	01 d0                	add    %edx,%eax
  8022cc:	c1 e0 02             	shl    $0x2,%eax
  8022cf:	05 40 20 81 00       	add    $0x812040,%eax
  8022d4:	8b 08                	mov    (%eax),%ecx
  8022d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022d9:	89 d0                	mov    %edx,%eax
  8022db:	01 c0                	add    %eax,%eax
  8022dd:	01 d0                	add    %edx,%eax
  8022df:	c1 e0 02             	shl    $0x2,%eax
  8022e2:	05 44 20 81 00       	add    $0x812044,%eax
  8022e7:	8b 00                	mov    (%eax),%eax
  8022e9:	01 c1                	add    %eax,%ecx
  8022eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022ee:	89 d0                	mov    %edx,%eax
  8022f0:	01 c0                	add    %eax,%eax
  8022f2:	01 d0                	add    %edx,%eax
  8022f4:	c1 e0 02             	shl    $0x2,%eax
  8022f7:	05 40 20 81 00       	add    $0x812040,%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	39 c1                	cmp    %eax,%ecx
  802300:	0f 85 a8 00 00 00    	jne    8023ae <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802306:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802309:	89 d0                	mov    %edx,%eax
  80230b:	01 c0                	add    %eax,%eax
  80230d:	01 d0                	add    %edx,%eax
  80230f:	c1 e0 02             	shl    $0x2,%eax
  802312:	05 40 20 81 00       	add    $0x812040,%eax
  802317:	8b 10                	mov    (%eax),%edx
  802319:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80231c:	89 c8                	mov    %ecx,%eax
  80231e:	01 c0                	add    %eax,%eax
  802320:	01 c8                	add    %ecx,%eax
  802322:	c1 e0 02             	shl    $0x2,%eax
  802325:	05 40 20 81 00       	add    $0x812040,%eax
  80232a:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80232c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80232f:	89 d0                	mov    %edx,%eax
  802331:	01 c0                	add    %eax,%eax
  802333:	01 d0                	add    %edx,%eax
  802335:	c1 e0 02             	shl    $0x2,%eax
  802338:	05 44 20 81 00       	add    $0x812044,%eax
  80233d:	8b 08                	mov    (%eax),%ecx
  80233f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802342:	89 d0                	mov    %edx,%eax
  802344:	01 c0                	add    %eax,%eax
  802346:	01 d0                	add    %edx,%eax
  802348:	c1 e0 02             	shl    $0x2,%eax
  80234b:	05 44 20 81 00       	add    $0x812044,%eax
  802350:	8b 00                	mov    (%eax),%eax
  802352:	01 c1                	add    %eax,%ecx
  802354:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802357:	89 d0                	mov    %edx,%eax
  802359:	01 c0                	add    %eax,%eax
  80235b:	01 d0                	add    %edx,%eax
  80235d:	c1 e0 02             	shl    $0x2,%eax
  802360:	05 44 20 81 00       	add    $0x812044,%eax
  802365:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802367:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80236a:	89 d0                	mov    %edx,%eax
  80236c:	01 c0                	add    %eax,%eax
  80236e:	01 d0                	add    %edx,%eax
  802370:	c1 e0 02             	shl    $0x2,%eax
  802373:	05 48 20 81 00       	add    $0x812048,%eax
  802378:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80237b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80237e:	89 d0                	mov    %edx,%eax
  802380:	01 c0                	add    %eax,%eax
  802382:	01 d0                	add    %edx,%eax
  802384:	c1 e0 02             	shl    $0x2,%eax
  802387:	05 40 20 81 00       	add    $0x812040,%eax
  80238c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802392:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802395:	89 d0                	mov    %edx,%eax
  802397:	01 c0                	add    %eax,%eax
  802399:	01 d0                	add    %edx,%eax
  80239b:	c1 e0 02             	shl    $0x2,%eax
  80239e:	05 44 20 81 00       	add    $0x812044,%eax
  8023a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a9:	e9 c3 00 00 00       	jmp    802471 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  8023ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023b1:	89 d0                	mov    %edx,%eax
  8023b3:	01 c0                	add    %eax,%eax
  8023b5:	01 d0                	add    %edx,%eax
  8023b7:	c1 e0 02             	shl    $0x2,%eax
  8023ba:	05 40 20 81 00       	add    $0x812040,%eax
  8023bf:	8b 08                	mov    (%eax),%ecx
  8023c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023c4:	89 d0                	mov    %edx,%eax
  8023c6:	01 c0                	add    %eax,%eax
  8023c8:	01 d0                	add    %edx,%eax
  8023ca:	c1 e0 02             	shl    $0x2,%eax
  8023cd:	05 44 20 81 00       	add    $0x812044,%eax
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	01 c1                	add    %eax,%ecx
  8023d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023d9:	89 d0                	mov    %edx,%eax
  8023db:	01 c0                	add    %eax,%eax
  8023dd:	01 d0                	add    %edx,%eax
  8023df:	c1 e0 02             	shl    $0x2,%eax
  8023e2:	05 40 20 81 00       	add    $0x812040,%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	39 c1                	cmp    %eax,%ecx
  8023eb:	0f 85 80 00 00 00    	jne    802471 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8023f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023f4:	89 d0                	mov    %edx,%eax
  8023f6:	01 c0                	add    %eax,%eax
  8023f8:	01 d0                	add    %edx,%eax
  8023fa:	c1 e0 02             	shl    $0x2,%eax
  8023fd:	05 44 20 81 00       	add    $0x812044,%eax
  802402:	8b 08                	mov    (%eax),%ecx
  802404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802407:	89 d0                	mov    %edx,%eax
  802409:	01 c0                	add    %eax,%eax
  80240b:	01 d0                	add    %edx,%eax
  80240d:	c1 e0 02             	shl    $0x2,%eax
  802410:	05 44 20 81 00       	add    $0x812044,%eax
  802415:	8b 00                	mov    (%eax),%eax
  802417:	01 c1                	add    %eax,%ecx
  802419:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80241c:	89 d0                	mov    %edx,%eax
  80241e:	01 c0                	add    %eax,%eax
  802420:	01 d0                	add    %edx,%eax
  802422:	c1 e0 02             	shl    $0x2,%eax
  802425:	05 44 20 81 00       	add    $0x812044,%eax
  80242a:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  80242c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80242f:	89 d0                	mov    %edx,%eax
  802431:	01 c0                	add    %eax,%eax
  802433:	01 d0                	add    %edx,%eax
  802435:	c1 e0 02             	shl    $0x2,%eax
  802438:	05 48 20 81 00       	add    $0x812048,%eax
  80243d:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802440:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802443:	89 d0                	mov    %edx,%eax
  802445:	01 c0                	add    %eax,%eax
  802447:	01 d0                	add    %edx,%eax
  802449:	c1 e0 02             	shl    $0x2,%eax
  80244c:	05 40 20 81 00       	add    $0x812040,%eax
  802451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802457:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80245a:	89 d0                	mov    %edx,%eax
  80245c:	01 c0                	add    %eax,%eax
  80245e:	01 d0                	add    %edx,%eax
  802460:	c1 e0 02             	shl    $0x2,%eax
  802463:	05 44 20 81 00       	add    $0x812044,%eax
  802468:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246e:	eb 01                	jmp    802471 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  802470:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802471:	ff 45 e0             	incl   -0x20(%ebp)
  802474:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80247b:	0f 8e 1b fe ff ff    	jle    80229c <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802481:	a1 30 61 83 00       	mov    0x836130,%eax
  802486:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802489:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802490:	eb 53                	jmp    8024e5 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802492:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802495:	89 d0                	mov    %edx,%eax
  802497:	01 c0                	add    %eax,%eax
  802499:	01 d0                	add    %edx,%eax
  80249b:	c1 e0 02             	shl    $0x2,%eax
  80249e:	05 48 60 80 00       	add    $0x806048,%eax
  8024a3:	8a 00                	mov    (%eax),%al
  8024a5:	84 c0                	test   %al,%al
  8024a7:	74 39                	je     8024e2 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  8024a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024ac:	89 d0                	mov    %edx,%eax
  8024ae:	01 c0                	add    %eax,%eax
  8024b0:	01 d0                	add    %edx,%eax
  8024b2:	c1 e0 02             	shl    $0x2,%eax
  8024b5:	05 40 60 80 00       	add    $0x806040,%eax
  8024ba:	8b 08                	mov    (%eax),%ecx
  8024bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024bf:	89 d0                	mov    %edx,%eax
  8024c1:	01 c0                	add    %eax,%eax
  8024c3:	01 d0                	add    %edx,%eax
  8024c5:	c1 e0 02             	shl    $0x2,%eax
  8024c8:	05 44 60 80 00       	add    $0x806044,%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	01 c8                	add    %ecx,%eax
  8024d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  8024d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8024da:	76 06                	jbe    8024e2 <free+0x3e3>
  8024dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024df:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024e2:	ff 45 d8             	incl   -0x28(%ebp)
  8024e5:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8024ec:	7e a4                	jle    802492 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  8024ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024f1:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  8024f6:	83 ec 08             	sub    $0x8,%esp
  8024f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024fc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8024ff:	e8 79 15 00 00       	call   803a7d <sys_free_user_mem>
  802504:	83 c4 10             	add    $0x10,%esp
  802507:	eb 01                	jmp    80250a <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802509:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 68             	sub    $0x68,%esp
  802512:	8b 45 10             	mov    0x10(%ebp),%eax
  802515:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802518:	e8 a5 f7 ff ff       	call   801cc2 <uheap_init>
	if (size == 0) return NULL ;
  80251d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802521:	75 0a                	jne    80252d <smalloc+0x21>
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
  802528:	e9 37 03 00 00       	jmp    802864 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80252d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802534:	8b 55 0c             	mov    0xc(%ebp),%edx
  802537:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80253a:	01 d0                	add    %edx,%eax
  80253c:	48                   	dec    %eax
  80253d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802540:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802543:	ba 00 00 00 00       	mov    $0x0,%edx
  802548:	f7 75 dc             	divl   -0x24(%ebp)
  80254b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80254e:	29 d0                	sub    %edx,%eax
  802550:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802553:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80255a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802561:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80256f:	e9 85 00 00 00       	jmp    8025f9 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802574:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802577:	89 d0                	mov    %edx,%eax
  802579:	01 c0                	add    %eax,%eax
  80257b:	01 d0                	add    %edx,%eax
  80257d:	c1 e0 02             	shl    $0x2,%eax
  802580:	05 48 20 81 00       	add    $0x812048,%eax
  802585:	8a 00                	mov    (%eax),%al
  802587:	84 c0                	test   %al,%al
  802589:	74 20                	je     8025ab <smalloc+0x9f>
  80258b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80258e:	89 d0                	mov    %edx,%eax
  802590:	01 c0                	add    %eax,%eax
  802592:	01 d0                	add    %edx,%eax
  802594:	c1 e0 02             	shl    $0x2,%eax
  802597:	05 44 20 81 00       	add    $0x812044,%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8025a1:	75 08                	jne    8025ab <smalloc+0x9f>
        {
            exactIdx = i;
  8025a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8025a9:	eb 5b                	jmp    802606 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8025ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025ae:	89 d0                	mov    %edx,%eax
  8025b0:	01 c0                	add    %eax,%eax
  8025b2:	01 d0                	add    %edx,%eax
  8025b4:	c1 e0 02             	shl    $0x2,%eax
  8025b7:	05 48 20 81 00       	add    $0x812048,%eax
  8025bc:	8a 00                	mov    (%eax),%al
  8025be:	84 c0                	test   %al,%al
  8025c0:	74 34                	je     8025f6 <smalloc+0xea>
  8025c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025c5:	89 d0                	mov    %edx,%eax
  8025c7:	01 c0                	add    %eax,%eax
  8025c9:	01 d0                	add    %edx,%eax
  8025cb:	c1 e0 02             	shl    $0x2,%eax
  8025ce:	05 44 20 81 00       	add    $0x812044,%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025d8:	76 1c                	jbe    8025f6 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8025da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025dd:	89 d0                	mov    %edx,%eax
  8025df:	01 c0                	add    %eax,%eax
  8025e1:	01 d0                	add    %edx,%eax
  8025e3:	c1 e0 02             	shl    $0x2,%eax
  8025e6:	05 44 20 81 00       	add    $0x812044,%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8025f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f3:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8025f6:	ff 45 e8             	incl   -0x18(%ebp)
  8025f9:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802600:	0f 8e 6e ff ff ff    	jle    802574 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802606:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80260d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802611:	74 7d                	je     802690 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802613:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80261a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261d:	89 d0                	mov    %edx,%eax
  80261f:	01 c0                	add    %eax,%eax
  802621:	01 d0                	add    %edx,%eax
  802623:	c1 e0 02             	shl    $0x2,%eax
  802626:	05 40 20 81 00       	add    $0x812040,%eax
  80262b:	8b 10                	mov    (%eax),%edx
  80262d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802630:	01 d0                	add    %edx,%eax
  802632:	48                   	dec    %eax
  802633:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802636:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802639:	ba 00 00 00 00       	mov    $0x0,%edx
  80263e:	f7 75 bc             	divl   -0x44(%ebp)
  802641:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802644:	29 d0                	sub    %edx,%eax
  802646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802649:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264c:	89 d0                	mov    %edx,%eax
  80264e:	01 c0                	add    %eax,%eax
  802650:	01 d0                	add    %edx,%eax
  802652:	c1 e0 02             	shl    $0x2,%eax
  802655:	05 48 20 81 00       	add    $0x812048,%eax
  80265a:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80265d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802660:	89 d0                	mov    %edx,%eax
  802662:	01 c0                	add    %eax,%eax
  802664:	01 d0                	add    %edx,%eax
  802666:	c1 e0 02             	shl    $0x2,%eax
  802669:	05 44 20 81 00       	add    $0x812044,%eax
  80266e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802677:	89 d0                	mov    %edx,%eax
  802679:	01 c0                	add    %eax,%eax
  80267b:	01 d0                	add    %edx,%eax
  80267d:	c1 e0 02             	shl    $0x2,%eax
  802680:	05 40 20 81 00       	add    $0x812040,%eax
  802685:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268b:	e9 2d 01 00 00       	jmp    8027bd <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802690:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802694:	0f 84 ce 00 00 00    	je     802768 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80269a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a4:	89 d0                	mov    %edx,%eax
  8026a6:	01 c0                	add    %eax,%eax
  8026a8:	01 d0                	add    %edx,%eax
  8026aa:	c1 e0 02             	shl    $0x2,%eax
  8026ad:	05 40 20 81 00       	add    $0x812040,%eax
  8026b2:	8b 10                	mov    (%eax),%edx
  8026b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026b7:	01 d0                	add    %edx,%eax
  8026b9:	48                   	dec    %eax
  8026ba:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c5:	f7 75 c4             	divl   -0x3c(%ebp)
  8026c8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026cb:	29 d0                	sub    %edx,%eax
  8026cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8026d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d3:	89 d0                	mov    %edx,%eax
  8026d5:	01 c0                	add    %eax,%eax
  8026d7:	01 d0                	add    %edx,%eax
  8026d9:	c1 e0 02             	shl    $0x2,%eax
  8026dc:	05 44 20 81 00       	add    $0x812044,%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8026e6:	75 47                	jne    80272f <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  8026e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026eb:	89 d0                	mov    %edx,%eax
  8026ed:	01 c0                	add    %eax,%eax
  8026ef:	01 d0                	add    %edx,%eax
  8026f1:	c1 e0 02             	shl    $0x2,%eax
  8026f4:	05 48 20 81 00       	add    $0x812048,%eax
  8026f9:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8026fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ff:	89 d0                	mov    %edx,%eax
  802701:	01 c0                	add    %eax,%eax
  802703:	01 d0                	add    %edx,%eax
  802705:	c1 e0 02             	shl    $0x2,%eax
  802708:	05 44 20 81 00       	add    $0x812044,%eax
  80270d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802713:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802716:	89 d0                	mov    %edx,%eax
  802718:	01 c0                	add    %eax,%eax
  80271a:	01 d0                	add    %edx,%eax
  80271c:	c1 e0 02             	shl    $0x2,%eax
  80271f:	05 40 20 81 00       	add    $0x812040,%eax
  802724:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272a:	e9 8e 00 00 00       	jmp    8027bd <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80272f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802735:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802738:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273b:	89 d0                	mov    %edx,%eax
  80273d:	01 c0                	add    %eax,%eax
  80273f:	01 d0                	add    %edx,%eax
  802741:	c1 e0 02             	shl    $0x2,%eax
  802744:	05 40 20 81 00       	add    $0x812040,%eax
  802749:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80274b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802751:	89 c2                	mov    %eax,%edx
  802753:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802756:	89 c8                	mov    %ecx,%eax
  802758:	01 c0                	add    %eax,%eax
  80275a:	01 c8                	add    %ecx,%eax
  80275c:	c1 e0 02             	shl    $0x2,%eax
  80275f:	05 44 20 81 00       	add    $0x812044,%eax
  802764:	89 10                	mov    %edx,(%eax)
  802766:	eb 55                	jmp    8027bd <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802768:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80276f:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802775:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802778:	01 d0                	add    %edx,%eax
  80277a:	48                   	dec    %eax
  80277b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80277e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802781:	ba 00 00 00 00       	mov    $0x0,%edx
  802786:	f7 75 d0             	divl   -0x30(%ebp)
  802789:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80278c:	29 d0                	sub    %edx,%eax
  80278e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802791:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802794:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802797:	01 d0                	add    %edx,%eax
  802799:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80279e:	76 0a                	jbe    8027aa <smalloc+0x29e>
            return NULL;
  8027a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a5:	e9 ba 00 00 00       	jmp    802864 <smalloc+0x358>
        va = start;
  8027aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8027b0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8027b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027b6:	01 d0                	add    %edx,%eax
  8027b8:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8027bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027c4:	eb 5e                	jmp    802824 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8027c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c9:	89 d0                	mov    %edx,%eax
  8027cb:	01 c0                	add    %eax,%eax
  8027cd:	01 d0                	add    %edx,%eax
  8027cf:	c1 e0 02             	shl    $0x2,%eax
  8027d2:	05 48 60 80 00       	add    $0x806048,%eax
  8027d7:	8a 00                	mov    (%eax),%al
  8027d9:	84 c0                	test   %al,%al
  8027db:	75 44                	jne    802821 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8027dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e0:	89 d0                	mov    %edx,%eax
  8027e2:	01 c0                	add    %eax,%eax
  8027e4:	01 d0                	add    %edx,%eax
  8027e6:	c1 e0 02             	shl    $0x2,%eax
  8027e9:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  8027ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f2:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8027f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027f7:	89 d0                	mov    %edx,%eax
  8027f9:	01 c0                	add    %eax,%eax
  8027fb:	01 d0                	add    %edx,%eax
  8027fd:	c1 e0 02             	shl    $0x2,%eax
  802800:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802806:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802809:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80280b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80280e:	89 d0                	mov    %edx,%eax
  802810:	01 c0                	add    %eax,%eax
  802812:	01 d0                	add    %edx,%eax
  802814:	c1 e0 02             	shl    $0x2,%eax
  802817:	05 48 60 80 00       	add    $0x806048,%eax
  80281c:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80281f:	eb 0c                	jmp    80282d <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802821:	ff 45 e0             	incl   -0x20(%ebp)
  802824:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80282b:	7e 99                	jle    8027c6 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80282d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802830:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802834:	52                   	push   %edx
  802835:	50                   	push   %eax
  802836:	ff 75 d4             	pushl  -0x2c(%ebp)
  802839:	ff 75 08             	pushl  0x8(%ebp)
  80283c:	e8 de 0e 00 00       	call   80371f <sys_create_shared_object>
  802841:	83 c4 10             	add    $0x10,%esp
  802844:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802847:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80284b:	75 07                	jne    802854 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80284d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802852:	eb 10                	jmp    802864 <smalloc+0x358>
    if (r < 0)
  802854:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802858:	79 07                	jns    802861 <smalloc+0x355>
        return NULL;
  80285a:	b8 00 00 00 00       	mov    $0x0,%eax
  80285f:	eb 03                	jmp    802864 <smalloc+0x358>
    return (void*)va;
  802861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80286c:	e8 51 f4 ff ff       	call   801cc2 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802871:	83 ec 08             	sub    $0x8,%esp
  802874:	ff 75 0c             	pushl  0xc(%ebp)
  802877:	ff 75 08             	pushl  0x8(%ebp)
  80287a:	e8 ca 0e 00 00       	call   803749 <sys_size_of_shared_object>
  80287f:	83 c4 10             	add    $0x10,%esp
  802882:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802885:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802889:	7f 0a                	jg     802895 <sget+0x2f>
        return NULL;
  80288b:	b8 00 00 00 00       	mov    $0x0,%eax
  802890:	e9 28 03 00 00       	jmp    802bbd <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802895:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80289c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80289f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028a2:	01 d0                	add    %edx,%eax
  8028a4:	48                   	dec    %eax
  8028a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b0:	f7 75 d8             	divl   -0x28(%ebp)
  8028b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028b6:	29 d0                	sub    %edx,%eax
  8028b8:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8028bb:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8028c2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8028c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8028d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8028d7:	e9 85 00 00 00       	jmp    802961 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8028dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028df:	89 d0                	mov    %edx,%eax
  8028e1:	01 c0                	add    %eax,%eax
  8028e3:	01 d0                	add    %edx,%eax
  8028e5:	c1 e0 02             	shl    $0x2,%eax
  8028e8:	05 48 20 81 00       	add    $0x812048,%eax
  8028ed:	8a 00                	mov    (%eax),%al
  8028ef:	84 c0                	test   %al,%al
  8028f1:	74 20                	je     802913 <sget+0xad>
  8028f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028f6:	89 d0                	mov    %edx,%eax
  8028f8:	01 c0                	add    %eax,%eax
  8028fa:	01 d0                	add    %edx,%eax
  8028fc:	c1 e0 02             	shl    $0x2,%eax
  8028ff:	05 44 20 81 00       	add    $0x812044,%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802909:	75 08                	jne    802913 <sget+0xad>
        {
            exactIdx = i;
  80290b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802911:	eb 5b                	jmp    80296e <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802913:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802916:	89 d0                	mov    %edx,%eax
  802918:	01 c0                	add    %eax,%eax
  80291a:	01 d0                	add    %edx,%eax
  80291c:	c1 e0 02             	shl    $0x2,%eax
  80291f:	05 48 20 81 00       	add    $0x812048,%eax
  802924:	8a 00                	mov    (%eax),%al
  802926:	84 c0                	test   %al,%al
  802928:	74 34                	je     80295e <sget+0xf8>
  80292a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80292d:	89 d0                	mov    %edx,%eax
  80292f:	01 c0                	add    %eax,%eax
  802931:	01 d0                	add    %edx,%eax
  802933:	c1 e0 02             	shl    $0x2,%eax
  802936:	05 44 20 81 00       	add    $0x812044,%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802940:	76 1c                	jbe    80295e <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802942:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802945:	89 d0                	mov    %edx,%eax
  802947:	01 c0                	add    %eax,%eax
  802949:	01 d0                	add    %edx,%eax
  80294b:	c1 e0 02             	shl    $0x2,%eax
  80294e:	05 44 20 81 00       	add    $0x812044,%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80295e:	ff 45 e8             	incl   -0x18(%ebp)
  802961:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802968:	0f 8e 6e ff ff ff    	jle    8028dc <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80296e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802975:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802979:	74 7d                	je     8029f8 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80297b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802985:	89 d0                	mov    %edx,%eax
  802987:	01 c0                	add    %eax,%eax
  802989:	01 d0                	add    %edx,%eax
  80298b:	c1 e0 02             	shl    $0x2,%eax
  80298e:	05 40 20 81 00       	add    $0x812040,%eax
  802993:	8b 10                	mov    (%eax),%edx
  802995:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802998:	01 d0                	add    %edx,%eax
  80299a:	48                   	dec    %eax
  80299b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80299e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a6:	f7 75 b8             	divl   -0x48(%ebp)
  8029a9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029ac:	29 d0                	sub    %edx,%eax
  8029ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8029b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b4:	89 d0                	mov    %edx,%eax
  8029b6:	01 c0                	add    %eax,%eax
  8029b8:	01 d0                	add    %edx,%eax
  8029ba:	c1 e0 02             	shl    $0x2,%eax
  8029bd:	05 48 20 81 00       	add    $0x812048,%eax
  8029c2:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8029c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c8:	89 d0                	mov    %edx,%eax
  8029ca:	01 c0                	add    %eax,%eax
  8029cc:	01 d0                	add    %edx,%eax
  8029ce:	c1 e0 02             	shl    $0x2,%eax
  8029d1:	05 44 20 81 00       	add    $0x812044,%eax
  8029d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8029dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029df:	89 d0                	mov    %edx,%eax
  8029e1:	01 c0                	add    %eax,%eax
  8029e3:	01 d0                	add    %edx,%eax
  8029e5:	c1 e0 02             	shl    $0x2,%eax
  8029e8:	05 40 20 81 00       	add    $0x812040,%eax
  8029ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f3:	e9 2d 01 00 00       	jmp    802b25 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8029f8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8029fc:	0f 84 ce 00 00 00    	je     802ad0 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802a02:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802a09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a0c:	89 d0                	mov    %edx,%eax
  802a0e:	01 c0                	add    %eax,%eax
  802a10:	01 d0                	add    %edx,%eax
  802a12:	c1 e0 02             	shl    $0x2,%eax
  802a15:	05 40 20 81 00       	add    $0x812040,%eax
  802a1a:	8b 10                	mov    (%eax),%edx
  802a1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a1f:	01 d0                	add    %edx,%eax
  802a21:	48                   	dec    %eax
  802a22:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802a25:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a28:	ba 00 00 00 00       	mov    $0x0,%edx
  802a2d:	f7 75 c0             	divl   -0x40(%ebp)
  802a30:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a33:	29 d0                	sub    %edx,%eax
  802a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a3b:	89 d0                	mov    %edx,%eax
  802a3d:	01 c0                	add    %eax,%eax
  802a3f:	01 d0                	add    %edx,%eax
  802a41:	c1 e0 02             	shl    $0x2,%eax
  802a44:	05 44 20 81 00       	add    $0x812044,%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a4e:	75 47                	jne    802a97 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802a50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a53:	89 d0                	mov    %edx,%eax
  802a55:	01 c0                	add    %eax,%eax
  802a57:	01 d0                	add    %edx,%eax
  802a59:	c1 e0 02             	shl    $0x2,%eax
  802a5c:	05 48 20 81 00       	add    $0x812048,%eax
  802a61:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802a64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a67:	89 d0                	mov    %edx,%eax
  802a69:	01 c0                	add    %eax,%eax
  802a6b:	01 d0                	add    %edx,%eax
  802a6d:	c1 e0 02             	shl    $0x2,%eax
  802a70:	05 44 20 81 00       	add    $0x812044,%eax
  802a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a7e:	89 d0                	mov    %edx,%eax
  802a80:	01 c0                	add    %eax,%eax
  802a82:	01 d0                	add    %edx,%eax
  802a84:	c1 e0 02             	shl    $0x2,%eax
  802a87:	05 40 20 81 00       	add    $0x812040,%eax
  802a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a92:	e9 8e 00 00 00       	jmp    802b25 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802a97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a9d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802aa0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa3:	89 d0                	mov    %edx,%eax
  802aa5:	01 c0                	add    %eax,%eax
  802aa7:	01 d0                	add    %edx,%eax
  802aa9:	c1 e0 02             	shl    $0x2,%eax
  802aac:	05 40 20 81 00       	add    $0x812040,%eax
  802ab1:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab6:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802ab9:	89 c2                	mov    %eax,%edx
  802abb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802abe:	89 c8                	mov    %ecx,%eax
  802ac0:	01 c0                	add    %eax,%eax
  802ac2:	01 c8                	add    %ecx,%eax
  802ac4:	c1 e0 02             	shl    $0x2,%eax
  802ac7:	05 44 20 81 00       	add    $0x812044,%eax
  802acc:	89 10                	mov    %edx,(%eax)
  802ace:	eb 55                	jmp    802b25 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802ad0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ad7:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802add:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae0:	01 d0                	add    %edx,%eax
  802ae2:	48                   	dec    %eax
  802ae3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ae6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  802aee:	f7 75 cc             	divl   -0x34(%ebp)
  802af1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802af4:	29 d0                	sub    %edx,%eax
  802af6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802af9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802afc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802aff:	01 d0                	add    %edx,%eax
  802b01:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802b06:	76 0a                	jbe    802b12 <sget+0x2ac>
            return NULL;
  802b08:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0d:	e9 ab 00 00 00       	jmp    802bbd <sget+0x357>
        va = start;
  802b12:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802b18:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802b1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b1e:	01 d0                	add    %edx,%eax
  802b20:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802b2c:	eb 5e                	jmp    802b8c <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802b2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b31:	89 d0                	mov    %edx,%eax
  802b33:	01 c0                	add    %eax,%eax
  802b35:	01 d0                	add    %edx,%eax
  802b37:	c1 e0 02             	shl    $0x2,%eax
  802b3a:	05 48 60 80 00       	add    $0x806048,%eax
  802b3f:	8a 00                	mov    (%eax),%al
  802b41:	84 c0                	test   %al,%al
  802b43:	75 44                	jne    802b89 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802b45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b48:	89 d0                	mov    %edx,%eax
  802b4a:	01 c0                	add    %eax,%eax
  802b4c:	01 d0                	add    %edx,%eax
  802b4e:	c1 e0 02             	shl    $0x2,%eax
  802b51:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802b5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b5f:	89 d0                	mov    %edx,%eax
  802b61:	01 c0                	add    %eax,%eax
  802b63:	01 d0                	add    %edx,%eax
  802b65:	c1 e0 02             	shl    $0x2,%eax
  802b68:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802b6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b71:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802b73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b76:	89 d0                	mov    %edx,%eax
  802b78:	01 c0                	add    %eax,%eax
  802b7a:	01 d0                	add    %edx,%eax
  802b7c:	c1 e0 02             	shl    $0x2,%eax
  802b7f:	05 48 60 80 00       	add    $0x806048,%eax
  802b84:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802b87:	eb 0c                	jmp    802b95 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b89:	ff 45 e0             	incl   -0x20(%ebp)
  802b8c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802b93:	7e 99                	jle    802b2e <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	50                   	push   %eax
  802b9c:	ff 75 0c             	pushl  0xc(%ebp)
  802b9f:	ff 75 08             	pushl  0x8(%ebp)
  802ba2:	e8 bf 0b 00 00       	call   803766 <sys_get_shared_object>
  802ba7:	83 c4 10             	add    $0x10,%esp
  802baa:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802bad:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bb1:	79 07                	jns    802bba <sget+0x354>
        return NULL;
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	eb 03                	jmp    802bbd <sget+0x357>
    return (void*)va;
  802bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802bbd:	c9                   	leave  
  802bbe:	c3                   	ret    

00802bbf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802bbf:	55                   	push   %ebp
  802bc0:	89 e5                	mov    %esp,%ebp
  802bc2:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802bc5:	e8 f8 f0 ff ff       	call   801cc2 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bce:	75 13                	jne    802be3 <realloc+0x24>
		return malloc(new_size);
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	ff 75 0c             	pushl  0xc(%ebp)
  802bd6:	e8 c4 f1 ff ff       	call   801d9f <malloc>
  802bdb:	83 c4 10             	add    $0x10,%esp
  802bde:	e9 f4 05 00 00       	jmp    8031d7 <realloc+0x618>
	if (new_size == 0)
  802be3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802be7:	75 18                	jne    802c01 <realloc+0x42>
	{
		free(virtual_address);
  802be9:	83 ec 0c             	sub    $0xc,%esp
  802bec:	ff 75 08             	pushl  0x8(%ebp)
  802bef:	e8 0b f5 ff ff       	call   8020ff <free>
  802bf4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfc:	e9 d6 05 00 00       	jmp    8031d7 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802c07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	79 74                	jns    802c82 <realloc+0xc3>
  802c0e:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802c15:	77 6b                	ja     802c82 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802c17:	83 ec 0c             	sub    $0xc,%esp
  802c1a:	ff 75 0c             	pushl  0xc(%ebp)
  802c1d:	e8 7d f1 ff ff       	call   801d9f <malloc>
  802c22:	83 c4 10             	add    $0x10,%esp
  802c25:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802c28:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802c2c:	75 0a                	jne    802c38 <realloc+0x79>
			return NULL;
  802c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c33:	e9 9f 05 00 00       	jmp    8031d7 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802c38:	83 ec 0c             	sub    $0xc,%esp
  802c3b:	ff 75 08             	pushl  0x8(%ebp)
  802c3e:	e8 e0 11 00 00       	call   803e23 <get_block_size>
  802c43:	83 c4 10             	add    $0x10,%esp
  802c46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802c49:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4f:	39 d0                	cmp    %edx,%eax
  802c51:	76 02                	jbe    802c55 <realloc+0x96>
  802c53:	89 d0                	mov    %edx,%eax
  802c55:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	ff 75 c0             	pushl  -0x40(%ebp)
  802c5e:	ff 75 08             	pushl  0x8(%ebp)
  802c61:	ff 75 c8             	pushl  -0x38(%ebp)
  802c64:	e8 56 eb ff ff       	call   8017bf <memmove>
  802c69:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802c6c:	83 ec 0c             	sub    $0xc,%esp
  802c6f:	ff 75 08             	pushl  0x8(%ebp)
  802c72:	e8 88 f4 ff ff       	call   8020ff <free>
  802c77:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802c7a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c7d:	e9 55 05 00 00       	jmp    8031d7 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802c82:	a1 30 61 83 00       	mov    0x836130,%eax
  802c87:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802c8a:	72 09                	jb     802c95 <realloc+0xd6>
  802c8c:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802c93:	76 0a                	jbe    802c9f <realloc+0xe0>
		return NULL;
  802c95:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9a:	e9 38 05 00 00       	jmp    8031d7 <realloc+0x618>
	uint32 oldsz = 0;
  802c9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802ca6:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802cb4:	eb 50                	jmp    802d06 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802cb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb9:	89 d0                	mov    %edx,%eax
  802cbb:	01 c0                	add    %eax,%eax
  802cbd:	01 d0                	add    %edx,%eax
  802cbf:	c1 e0 02             	shl    $0x2,%eax
  802cc2:	05 48 60 80 00       	add    $0x806048,%eax
  802cc7:	8a 00                	mov    (%eax),%al
  802cc9:	84 c0                	test   %al,%al
  802ccb:	74 36                	je     802d03 <realloc+0x144>
  802ccd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cd0:	89 d0                	mov    %edx,%eax
  802cd2:	01 c0                	add    %eax,%eax
  802cd4:	01 d0                	add    %edx,%eax
  802cd6:	c1 e0 02             	shl    $0x2,%eax
  802cd9:	05 40 60 80 00       	add    $0x806040,%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802ce3:	75 1e                	jne    802d03 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802ce5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce8:	89 d0                	mov    %edx,%eax
  802cea:	01 c0                	add    %eax,%eax
  802cec:	01 d0                	add    %edx,%eax
  802cee:	c1 e0 02             	shl    $0x2,%eax
  802cf1:	05 44 60 80 00       	add    $0x806044,%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802d01:	eb 0c                	jmp    802d0f <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d03:	ff 45 ec             	incl   -0x14(%ebp)
  802d06:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802d0d:	7e a7                	jle    802cb6 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802d0f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802d13:	75 0a                	jne    802d1f <realloc+0x160>
		return NULL;
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1a:	e9 b8 04 00 00       	jmp    8031d7 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802d1f:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d29:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d2c:	01 d0                	add    %edx,%eax
  802d2e:	48                   	dec    %eax
  802d2f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802d32:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d35:	ba 00 00 00 00       	mov    $0x0,%edx
  802d3a:	f7 75 bc             	divl   -0x44(%ebp)
  802d3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d40:	29 d0                	sub    %edx,%eax
  802d42:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802d45:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d4b:	75 08                	jne    802d55 <realloc+0x196>
		return virtual_address;
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	e9 82 04 00 00       	jmp    8031d7 <realloc+0x618>
	if (req < oldsz)
  802d55:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d5b:	0f 83 cd 02 00 00    	jae    80302e <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802d67:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802d6a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d6d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d70:	01 d0                	add    %edx,%eax
  802d72:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802d75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d78:	89 d0                	mov    %edx,%eax
  802d7a:	01 c0                	add    %eax,%eax
  802d7c:	01 d0                	add    %edx,%eax
  802d7e:	c1 e0 02             	shl    $0x2,%eax
  802d81:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802d87:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d8a:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802d8c:	83 ec 08             	sub    $0x8,%esp
  802d8f:	ff 75 b0             	pushl  -0x50(%ebp)
  802d92:	ff 75 ac             	pushl  -0x54(%ebp)
  802d95:	e8 e3 0c 00 00       	call   803a7d <sys_free_user_mem>
  802d9a:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802d9d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802da4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802dab:	eb 64                	jmp    802e11 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802dad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802db0:	89 d0                	mov    %edx,%eax
  802db2:	01 c0                	add    %eax,%eax
  802db4:	01 d0                	add    %edx,%eax
  802db6:	c1 e0 02             	shl    $0x2,%eax
  802db9:	05 48 20 81 00       	add    $0x812048,%eax
  802dbe:	8a 00                	mov    (%eax),%al
  802dc0:	84 c0                	test   %al,%al
  802dc2:	75 4a                	jne    802e0e <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802dc4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dc7:	89 d0                	mov    %edx,%eax
  802dc9:	01 c0                	add    %eax,%eax
  802dcb:	01 d0                	add    %edx,%eax
  802dcd:	c1 e0 02             	shl    $0x2,%eax
  802dd0:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802dd6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802dd9:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802ddb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dde:	89 d0                	mov    %edx,%eax
  802de0:	01 c0                	add    %eax,%eax
  802de2:	01 d0                	add    %edx,%eax
  802de4:	c1 e0 02             	shl    $0x2,%eax
  802de7:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802ded:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802df0:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802df2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802df5:	89 d0                	mov    %edx,%eax
  802df7:	01 c0                	add    %eax,%eax
  802df9:	01 d0                	add    %edx,%eax
  802dfb:	c1 e0 02             	shl    $0x2,%eax
  802dfe:	05 48 20 81 00       	add    $0x812048,%eax
  802e03:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e09:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802e0c:	eb 0c                	jmp    802e1a <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e0e:	ff 45 e4             	incl   -0x1c(%ebp)
  802e11:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802e18:	7e 93                	jle    802dad <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802e1a:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802e1e:	0f 84 8d 01 00 00    	je     802fb1 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e24:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e2b:	e9 74 01 00 00       	jmp    802fa4 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e33:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e36:	0f 84 64 01 00 00    	je     802fa0 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802e3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3f:	89 d0                	mov    %edx,%eax
  802e41:	01 c0                	add    %eax,%eax
  802e43:	01 d0                	add    %edx,%eax
  802e45:	c1 e0 02             	shl    $0x2,%eax
  802e48:	05 48 20 81 00       	add    $0x812048,%eax
  802e4d:	8a 00                	mov    (%eax),%al
  802e4f:	84 c0                	test   %al,%al
  802e51:	0f 84 4a 01 00 00    	je     802fa1 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e5a:	89 d0                	mov    %edx,%eax
  802e5c:	01 c0                	add    %eax,%eax
  802e5e:	01 d0                	add    %edx,%eax
  802e60:	c1 e0 02             	shl    $0x2,%eax
  802e63:	05 40 20 81 00       	add    $0x812040,%eax
  802e68:	8b 08                	mov    (%eax),%ecx
  802e6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e6d:	89 d0                	mov    %edx,%eax
  802e6f:	01 c0                	add    %eax,%eax
  802e71:	01 d0                	add    %edx,%eax
  802e73:	c1 e0 02             	shl    $0x2,%eax
  802e76:	05 44 20 81 00       	add    $0x812044,%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	01 c1                	add    %eax,%ecx
  802e7f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e82:	89 d0                	mov    %edx,%eax
  802e84:	01 c0                	add    %eax,%eax
  802e86:	01 d0                	add    %edx,%eax
  802e88:	c1 e0 02             	shl    $0x2,%eax
  802e8b:	05 40 20 81 00       	add    $0x812040,%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	39 c1                	cmp    %eax,%ecx
  802e94:	75 7a                	jne    802f10 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802e96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e99:	89 d0                	mov    %edx,%eax
  802e9b:	01 c0                	add    %eax,%eax
  802e9d:	01 d0                	add    %edx,%eax
  802e9f:	c1 e0 02             	shl    $0x2,%eax
  802ea2:	05 40 20 81 00       	add    $0x812040,%eax
  802ea7:	8b 10                	mov    (%eax),%edx
  802ea9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802eac:	89 c8                	mov    %ecx,%eax
  802eae:	01 c0                	add    %eax,%eax
  802eb0:	01 c8                	add    %ecx,%eax
  802eb2:	c1 e0 02             	shl    $0x2,%eax
  802eb5:	05 40 20 81 00       	add    $0x812040,%eax
  802eba:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802ebc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ebf:	89 d0                	mov    %edx,%eax
  802ec1:	01 c0                	add    %eax,%eax
  802ec3:	01 d0                	add    %edx,%eax
  802ec5:	c1 e0 02             	shl    $0x2,%eax
  802ec8:	05 44 20 81 00       	add    $0x812044,%eax
  802ecd:	8b 08                	mov    (%eax),%ecx
  802ecf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ed2:	89 d0                	mov    %edx,%eax
  802ed4:	01 c0                	add    %eax,%eax
  802ed6:	01 d0                	add    %edx,%eax
  802ed8:	c1 e0 02             	shl    $0x2,%eax
  802edb:	05 44 20 81 00       	add    $0x812044,%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	01 c1                	add    %eax,%ecx
  802ee4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ee7:	89 d0                	mov    %edx,%eax
  802ee9:	01 c0                	add    %eax,%eax
  802eeb:	01 d0                	add    %edx,%eax
  802eed:	c1 e0 02             	shl    $0x2,%eax
  802ef0:	05 44 20 81 00       	add    $0x812044,%eax
  802ef5:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802ef7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802efa:	89 d0                	mov    %edx,%eax
  802efc:	01 c0                	add    %eax,%eax
  802efe:	01 d0                	add    %edx,%eax
  802f00:	c1 e0 02             	shl    $0x2,%eax
  802f03:	05 48 20 81 00       	add    $0x812048,%eax
  802f08:	c6 00 00             	movb   $0x0,(%eax)
  802f0b:	e9 91 00 00 00       	jmp    802fa1 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802f10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f13:	89 d0                	mov    %edx,%eax
  802f15:	01 c0                	add    %eax,%eax
  802f17:	01 d0                	add    %edx,%eax
  802f19:	c1 e0 02             	shl    $0x2,%eax
  802f1c:	05 40 20 81 00       	add    $0x812040,%eax
  802f21:	8b 08                	mov    (%eax),%ecx
  802f23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f26:	89 d0                	mov    %edx,%eax
  802f28:	01 c0                	add    %eax,%eax
  802f2a:	01 d0                	add    %edx,%eax
  802f2c:	c1 e0 02             	shl    $0x2,%eax
  802f2f:	05 44 20 81 00       	add    $0x812044,%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	01 c1                	add    %eax,%ecx
  802f38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f3b:	89 d0                	mov    %edx,%eax
  802f3d:	01 c0                	add    %eax,%eax
  802f3f:	01 d0                	add    %edx,%eax
  802f41:	c1 e0 02             	shl    $0x2,%eax
  802f44:	05 40 20 81 00       	add    $0x812040,%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	39 c1                	cmp    %eax,%ecx
  802f4d:	75 52                	jne    802fa1 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802f4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f52:	89 d0                	mov    %edx,%eax
  802f54:	01 c0                	add    %eax,%eax
  802f56:	01 d0                	add    %edx,%eax
  802f58:	c1 e0 02             	shl    $0x2,%eax
  802f5b:	05 44 20 81 00       	add    $0x812044,%eax
  802f60:	8b 08                	mov    (%eax),%ecx
  802f62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f65:	89 d0                	mov    %edx,%eax
  802f67:	01 c0                	add    %eax,%eax
  802f69:	01 d0                	add    %edx,%eax
  802f6b:	c1 e0 02             	shl    $0x2,%eax
  802f6e:	05 44 20 81 00       	add    $0x812044,%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	01 c1                	add    %eax,%ecx
  802f77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f7a:	89 d0                	mov    %edx,%eax
  802f7c:	01 c0                	add    %eax,%eax
  802f7e:	01 d0                	add    %edx,%eax
  802f80:	c1 e0 02             	shl    $0x2,%eax
  802f83:	05 44 20 81 00       	add    $0x812044,%eax
  802f88:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f8d:	89 d0                	mov    %edx,%eax
  802f8f:	01 c0                	add    %eax,%eax
  802f91:	01 d0                	add    %edx,%eax
  802f93:	c1 e0 02             	shl    $0x2,%eax
  802f96:	05 48 20 81 00       	add    $0x812048,%eax
  802f9b:	c6 00 00             	movb   $0x0,(%eax)
  802f9e:	eb 01                	jmp    802fa1 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802fa0:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802fa1:	ff 45 e0             	incl   -0x20(%ebp)
  802fa4:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802fab:	0f 8e 7f fe ff ff    	jle    802e30 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802fb1:	a1 30 61 83 00       	mov    0x836130,%eax
  802fb6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802fb9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802fc0:	eb 53                	jmp    803015 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802fc2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802fc5:	89 d0                	mov    %edx,%eax
  802fc7:	01 c0                	add    %eax,%eax
  802fc9:	01 d0                	add    %edx,%eax
  802fcb:	c1 e0 02             	shl    $0x2,%eax
  802fce:	05 48 60 80 00       	add    $0x806048,%eax
  802fd3:	8a 00                	mov    (%eax),%al
  802fd5:	84 c0                	test   %al,%al
  802fd7:	74 39                	je     803012 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802fd9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802fdc:	89 d0                	mov    %edx,%eax
  802fde:	01 c0                	add    %eax,%eax
  802fe0:	01 d0                	add    %edx,%eax
  802fe2:	c1 e0 02             	shl    $0x2,%eax
  802fe5:	05 40 60 80 00       	add    $0x806040,%eax
  802fea:	8b 08                	mov    (%eax),%ecx
  802fec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802fef:	89 d0                	mov    %edx,%eax
  802ff1:	01 c0                	add    %eax,%eax
  802ff3:	01 d0                	add    %edx,%eax
  802ff5:	c1 e0 02             	shl    $0x2,%eax
  802ff8:	05 44 60 80 00       	add    $0x806044,%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	01 c8                	add    %ecx,%eax
  803001:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  803004:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803007:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80300a:	76 06                	jbe    803012 <realloc+0x453>
  80300c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80300f:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803012:	ff 45 d8             	incl   -0x28(%ebp)
  803015:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80301c:	7e a4                	jle    802fc2 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  80301e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803021:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	e9 a9 01 00 00       	jmp    8031d7 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  80302e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	01 d0                	add    %edx,%eax
  803036:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  803039:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803040:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  803047:	eb 57                	jmp    8030a0 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  803049:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80304c:	89 d0                	mov    %edx,%eax
  80304e:	01 c0                	add    %eax,%eax
  803050:	01 d0                	add    %edx,%eax
  803052:	c1 e0 02             	shl    $0x2,%eax
  803055:	05 48 20 81 00       	add    $0x812048,%eax
  80305a:	8a 00                	mov    (%eax),%al
  80305c:	84 c0                	test   %al,%al
  80305e:	74 3d                	je     80309d <realloc+0x4de>
  803060:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803063:	89 d0                	mov    %edx,%eax
  803065:	01 c0                	add    %eax,%eax
  803067:	01 d0                	add    %edx,%eax
  803069:	c1 e0 02             	shl    $0x2,%eax
  80306c:	05 40 20 81 00       	add    $0x812040,%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803076:	75 25                	jne    80309d <realloc+0x4de>
  803078:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80307b:	89 d0                	mov    %edx,%eax
  80307d:	01 c0                	add    %eax,%eax
  80307f:	01 d0                	add    %edx,%eax
  803081:	c1 e0 02             	shl    $0x2,%eax
  803084:	05 44 20 81 00       	add    $0x812044,%eax
  803089:	8b 10                	mov    (%eax),%edx
  80308b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80308e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803091:	39 c2                	cmp    %eax,%edx
  803093:	72 08                	jb     80309d <realloc+0x4de>
		{
			adjIdx = j; break;
  803095:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803098:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80309b:	eb 0c                	jmp    8030a9 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80309d:	ff 45 d0             	incl   -0x30(%ebp)
  8030a0:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8030a7:	7e a0                	jle    803049 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8030a9:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8030ad:	0f 84 d6 00 00 00    	je     803189 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8030b3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030b6:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8030b9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8030bc:	83 ec 08             	sub    $0x8,%esp
  8030bf:	ff 75 a0             	pushl  -0x60(%ebp)
  8030c2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8030c5:	e8 cf 09 00 00       	call   803a99 <sys_allocate_user_mem>
  8030ca:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8030cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d0:	89 d0                	mov    %edx,%eax
  8030d2:	01 c0                	add    %eax,%eax
  8030d4:	01 d0                	add    %edx,%eax
  8030d6:	c1 e0 02             	shl    $0x2,%eax
  8030d9:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8030df:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030e2:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8030e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8030e7:	89 d0                	mov    %edx,%eax
  8030e9:	01 c0                	add    %eax,%eax
  8030eb:	01 d0                	add    %edx,%eax
  8030ed:	c1 e0 02             	shl    $0x2,%eax
  8030f0:	05 40 20 81 00       	add    $0x812040,%eax
  8030f5:	8b 10                	mov    (%eax),%edx
  8030f7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8030fa:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8030fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803100:	89 d0                	mov    %edx,%eax
  803102:	01 c0                	add    %eax,%eax
  803104:	01 d0                	add    %edx,%eax
  803106:	c1 e0 02             	shl    $0x2,%eax
  803109:	05 40 20 81 00       	add    $0x812040,%eax
  80310e:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  803110:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803113:	89 d0                	mov    %edx,%eax
  803115:	01 c0                	add    %eax,%eax
  803117:	01 d0                	add    %edx,%eax
  803119:	c1 e0 02             	shl    $0x2,%eax
  80311c:	05 44 20 81 00       	add    $0x812044,%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	2b 45 a0             	sub    -0x60(%ebp),%eax
  803126:	89 c2                	mov    %eax,%edx
  803128:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80312b:	89 c8                	mov    %ecx,%eax
  80312d:	01 c0                	add    %eax,%eax
  80312f:	01 c8                	add    %ecx,%eax
  803131:	c1 e0 02             	shl    $0x2,%eax
  803134:	05 44 20 81 00       	add    $0x812044,%eax
  803139:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  80313b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80313e:	89 d0                	mov    %edx,%eax
  803140:	01 c0                	add    %eax,%eax
  803142:	01 d0                	add    %edx,%eax
  803144:	c1 e0 02             	shl    $0x2,%eax
  803147:	05 44 20 81 00       	add    $0x812044,%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	85 c0                	test   %eax,%eax
  803150:	75 14                	jne    803166 <realloc+0x5a7>
  803152:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803155:	89 d0                	mov    %edx,%eax
  803157:	01 c0                	add    %eax,%eax
  803159:	01 d0                	add    %edx,%eax
  80315b:	c1 e0 02             	shl    $0x2,%eax
  80315e:	05 48 20 81 00       	add    $0x812048,%eax
  803163:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  803166:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803169:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80316c:	01 c2                	add    %eax,%edx
  80316e:	a1 88 60 83 00       	mov    0x836088,%eax
  803173:	39 c2                	cmp    %eax,%edx
  803175:	76 0d                	jbe    803184 <realloc+0x5c5>
  803177:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80317a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80317d:	01 d0                	add    %edx,%eax
  80317f:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	eb 4e                	jmp    8031d7 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  803189:	83 ec 0c             	sub    $0xc,%esp
  80318c:	ff 75 0c             	pushl  0xc(%ebp)
  80318f:	e8 0b ec ff ff       	call   801d9f <malloc>
  803194:	83 c4 10             	add    $0x10,%esp
  803197:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  80319a:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80319e:	75 07                	jne    8031a7 <realloc+0x5e8>
		return NULL;
  8031a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a5:	eb 30                	jmp    8031d7 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  8031a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031aa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031ad:	39 d0                	cmp    %edx,%eax
  8031af:	76 02                	jbe    8031b3 <realloc+0x5f4>
  8031b1:	89 d0                	mov    %edx,%eax
  8031b3:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8031b6:	83 ec 04             	sub    $0x4,%esp
  8031b9:	50                   	push   %eax
  8031ba:	52                   	push   %edx
  8031bb:	ff 75 cc             	pushl  -0x34(%ebp)
  8031be:	e8 cf 06 00 00       	call   803892 <sys_move_user_mem>
  8031c3:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  8031c6:	83 ec 0c             	sub    $0xc,%esp
  8031c9:	ff 75 08             	pushl  0x8(%ebp)
  8031cc:	e8 2e ef ff ff       	call   8020ff <free>
  8031d1:	83 c4 10             	add    $0x10,%esp
	return newptr;
  8031d4:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  8031d7:	c9                   	leave  
  8031d8:	c3                   	ret    

008031d9 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8031d9:	55                   	push   %ebp
  8031da:	89 e5                	mov    %esp,%ebp
  8031dc:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8031e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031e9:	0f 84 33 03 00 00    	je     803522 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8031ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f2:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8031f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8031fa:	83 ec 08             	sub    $0x8,%esp
  8031fd:	ff 75 08             	pushl  0x8(%ebp)
  803200:	ff 75 d8             	pushl  -0x28(%ebp)
  803203:	e8 7d 05 00 00       	call   803785 <sys_delete_shared_object>
  803208:	83 c4 10             	add    $0x10,%esp
  80320b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  80320e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803212:	0f 88 0d 03 00 00    	js     803525 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80321f:	e9 ef 02 00 00       	jmp    803513 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803224:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803227:	89 d0                	mov    %edx,%eax
  803229:	01 c0                	add    %eax,%eax
  80322b:	01 d0                	add    %edx,%eax
  80322d:	c1 e0 02             	shl    $0x2,%eax
  803230:	05 48 60 80 00       	add    $0x806048,%eax
  803235:	8a 00                	mov    (%eax),%al
  803237:	84 c0                	test   %al,%al
  803239:	0f 84 d1 02 00 00    	je     803510 <sfree+0x337>
  80323f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803242:	89 d0                	mov    %edx,%eax
  803244:	01 c0                	add    %eax,%eax
  803246:	01 d0                	add    %edx,%eax
  803248:	c1 e0 02             	shl    $0x2,%eax
  80324b:	05 40 60 80 00       	add    $0x806040,%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803255:	0f 85 b5 02 00 00    	jne    803510 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  80325b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80325e:	89 d0                	mov    %edx,%eax
  803260:	01 c0                	add    %eax,%eax
  803262:	01 d0                	add    %edx,%eax
  803264:	c1 e0 02             	shl    $0x2,%eax
  803267:	05 44 60 80 00       	add    $0x806044,%eax
  80326c:	8b 00                	mov    (%eax),%eax
  80326e:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803274:	89 d0                	mov    %edx,%eax
  803276:	01 c0                	add    %eax,%eax
  803278:	01 d0                	add    %edx,%eax
  80327a:	c1 e0 02             	shl    $0x2,%eax
  80327d:	05 48 60 80 00       	add    $0x806048,%eax
  803282:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  803285:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80328c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803293:	eb 64                	jmp    8032f9 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  803295:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803298:	89 d0                	mov    %edx,%eax
  80329a:	01 c0                	add    %eax,%eax
  80329c:	01 d0                	add    %edx,%eax
  80329e:	c1 e0 02             	shl    $0x2,%eax
  8032a1:	05 48 20 81 00       	add    $0x812048,%eax
  8032a6:	8a 00                	mov    (%eax),%al
  8032a8:	84 c0                	test   %al,%al
  8032aa:	75 4a                	jne    8032f6 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  8032ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032af:	89 d0                	mov    %edx,%eax
  8032b1:	01 c0                	add    %eax,%eax
  8032b3:	01 d0                	add    %edx,%eax
  8032b5:	c1 e0 02             	shl    $0x2,%eax
  8032b8:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8032be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c1:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  8032c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c6:	89 d0                	mov    %edx,%eax
  8032c8:	01 c0                	add    %eax,%eax
  8032ca:	01 d0                	add    %edx,%eax
  8032cc:	c1 e0 02             	shl    $0x2,%eax
  8032cf:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  8032d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032d8:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  8032da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032dd:	89 d0                	mov    %edx,%eax
  8032df:	01 c0                	add    %eax,%eax
  8032e1:	01 d0                	add    %edx,%eax
  8032e3:	c1 e0 02             	shl    $0x2,%eax
  8032e6:	05 48 20 81 00       	add    $0x812048,%eax
  8032eb:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  8032ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  8032f4:	eb 0c                	jmp    803302 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8032f6:	ff 45 ec             	incl   -0x14(%ebp)
  8032f9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803300:	7e 93                	jle    803295 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  803302:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803306:	0f 84 8d 01 00 00    	je     803499 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80330c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803313:	e9 74 01 00 00       	jmp    80348c <sfree+0x2b3>
				{
					if (k == fidx) continue;
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80331e:	0f 84 64 01 00 00    	je     803488 <sfree+0x2af>
					if (uhp_frees[k].free)
  803324:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803327:	89 d0                	mov    %edx,%eax
  803329:	01 c0                	add    %eax,%eax
  80332b:	01 d0                	add    %edx,%eax
  80332d:	c1 e0 02             	shl    $0x2,%eax
  803330:	05 48 20 81 00       	add    $0x812048,%eax
  803335:	8a 00                	mov    (%eax),%al
  803337:	84 c0                	test   %al,%al
  803339:	0f 84 4a 01 00 00    	je     803489 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80333f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803342:	89 d0                	mov    %edx,%eax
  803344:	01 c0                	add    %eax,%eax
  803346:	01 d0                	add    %edx,%eax
  803348:	c1 e0 02             	shl    $0x2,%eax
  80334b:	05 40 20 81 00       	add    $0x812040,%eax
  803350:	8b 08                	mov    (%eax),%ecx
  803352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803355:	89 d0                	mov    %edx,%eax
  803357:	01 c0                	add    %eax,%eax
  803359:	01 d0                	add    %edx,%eax
  80335b:	c1 e0 02             	shl    $0x2,%eax
  80335e:	05 44 20 81 00       	add    $0x812044,%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	01 c1                	add    %eax,%ecx
  803367:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80336a:	89 d0                	mov    %edx,%eax
  80336c:	01 c0                	add    %eax,%eax
  80336e:	01 d0                	add    %edx,%eax
  803370:	c1 e0 02             	shl    $0x2,%eax
  803373:	05 40 20 81 00       	add    $0x812040,%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	39 c1                	cmp    %eax,%ecx
  80337c:	75 7a                	jne    8033f8 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  80337e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803381:	89 d0                	mov    %edx,%eax
  803383:	01 c0                	add    %eax,%eax
  803385:	01 d0                	add    %edx,%eax
  803387:	c1 e0 02             	shl    $0x2,%eax
  80338a:	05 40 20 81 00       	add    $0x812040,%eax
  80338f:	8b 10                	mov    (%eax),%edx
  803391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803394:	89 c8                	mov    %ecx,%eax
  803396:	01 c0                	add    %eax,%eax
  803398:	01 c8                	add    %ecx,%eax
  80339a:	c1 e0 02             	shl    $0x2,%eax
  80339d:	05 40 20 81 00       	add    $0x812040,%eax
  8033a2:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  8033a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033a7:	89 d0                	mov    %edx,%eax
  8033a9:	01 c0                	add    %eax,%eax
  8033ab:	01 d0                	add    %edx,%eax
  8033ad:	c1 e0 02             	shl    $0x2,%eax
  8033b0:	05 44 20 81 00       	add    $0x812044,%eax
  8033b5:	8b 08                	mov    (%eax),%ecx
  8033b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ba:	89 d0                	mov    %edx,%eax
  8033bc:	01 c0                	add    %eax,%eax
  8033be:	01 d0                	add    %edx,%eax
  8033c0:	c1 e0 02             	shl    $0x2,%eax
  8033c3:	05 44 20 81 00       	add    $0x812044,%eax
  8033c8:	8b 00                	mov    (%eax),%eax
  8033ca:	01 c1                	add    %eax,%ecx
  8033cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033cf:	89 d0                	mov    %edx,%eax
  8033d1:	01 c0                	add    %eax,%eax
  8033d3:	01 d0                	add    %edx,%eax
  8033d5:	c1 e0 02             	shl    $0x2,%eax
  8033d8:	05 44 20 81 00       	add    $0x812044,%eax
  8033dd:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8033df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033e2:	89 d0                	mov    %edx,%eax
  8033e4:	01 c0                	add    %eax,%eax
  8033e6:	01 d0                	add    %edx,%eax
  8033e8:	c1 e0 02             	shl    $0x2,%eax
  8033eb:	05 48 20 81 00       	add    $0x812048,%eax
  8033f0:	c6 00 00             	movb   $0x0,(%eax)
  8033f3:	e9 91 00 00 00       	jmp    803489 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8033f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033fb:	89 d0                	mov    %edx,%eax
  8033fd:	01 c0                	add    %eax,%eax
  8033ff:	01 d0                	add    %edx,%eax
  803401:	c1 e0 02             	shl    $0x2,%eax
  803404:	05 40 20 81 00       	add    $0x812040,%eax
  803409:	8b 08                	mov    (%eax),%ecx
  80340b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340e:	89 d0                	mov    %edx,%eax
  803410:	01 c0                	add    %eax,%eax
  803412:	01 d0                	add    %edx,%eax
  803414:	c1 e0 02             	shl    $0x2,%eax
  803417:	05 44 20 81 00       	add    $0x812044,%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	01 c1                	add    %eax,%ecx
  803420:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803423:	89 d0                	mov    %edx,%eax
  803425:	01 c0                	add    %eax,%eax
  803427:	01 d0                	add    %edx,%eax
  803429:	c1 e0 02             	shl    $0x2,%eax
  80342c:	05 40 20 81 00       	add    $0x812040,%eax
  803431:	8b 00                	mov    (%eax),%eax
  803433:	39 c1                	cmp    %eax,%ecx
  803435:	75 52                	jne    803489 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803437:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80343a:	89 d0                	mov    %edx,%eax
  80343c:	01 c0                	add    %eax,%eax
  80343e:	01 d0                	add    %edx,%eax
  803440:	c1 e0 02             	shl    $0x2,%eax
  803443:	05 44 20 81 00       	add    $0x812044,%eax
  803448:	8b 08                	mov    (%eax),%ecx
  80344a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80344d:	89 d0                	mov    %edx,%eax
  80344f:	01 c0                	add    %eax,%eax
  803451:	01 d0                	add    %edx,%eax
  803453:	c1 e0 02             	shl    $0x2,%eax
  803456:	05 44 20 81 00       	add    $0x812044,%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	01 c1                	add    %eax,%ecx
  80345f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803462:	89 d0                	mov    %edx,%eax
  803464:	01 c0                	add    %eax,%eax
  803466:	01 d0                	add    %edx,%eax
  803468:	c1 e0 02             	shl    $0x2,%eax
  80346b:	05 44 20 81 00       	add    $0x812044,%eax
  803470:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803472:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803475:	89 d0                	mov    %edx,%eax
  803477:	01 c0                	add    %eax,%eax
  803479:	01 d0                	add    %edx,%eax
  80347b:	c1 e0 02             	shl    $0x2,%eax
  80347e:	05 48 20 81 00       	add    $0x812048,%eax
  803483:	c6 00 00             	movb   $0x0,(%eax)
  803486:	eb 01                	jmp    803489 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  803488:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803489:	ff 45 e8             	incl   -0x18(%ebp)
  80348c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803493:	0f 8e 7f fe ff ff    	jle    803318 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803499:	a1 30 61 83 00       	mov    0x836130,%eax
  80349e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8034a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8034a8:	eb 53                	jmp    8034fd <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  8034aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034ad:	89 d0                	mov    %edx,%eax
  8034af:	01 c0                	add    %eax,%eax
  8034b1:	01 d0                	add    %edx,%eax
  8034b3:	c1 e0 02             	shl    $0x2,%eax
  8034b6:	05 48 60 80 00       	add    $0x806048,%eax
  8034bb:	8a 00                	mov    (%eax),%al
  8034bd:	84 c0                	test   %al,%al
  8034bf:	74 39                	je     8034fa <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8034c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034c4:	89 d0                	mov    %edx,%eax
  8034c6:	01 c0                	add    %eax,%eax
  8034c8:	01 d0                	add    %edx,%eax
  8034ca:	c1 e0 02             	shl    $0x2,%eax
  8034cd:	05 40 60 80 00       	add    $0x806040,%eax
  8034d2:	8b 08                	mov    (%eax),%ecx
  8034d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034d7:	89 d0                	mov    %edx,%eax
  8034d9:	01 c0                	add    %eax,%eax
  8034db:	01 d0                	add    %edx,%eax
  8034dd:	c1 e0 02             	shl    $0x2,%eax
  8034e0:	05 44 60 80 00       	add    $0x806044,%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	01 c8                	add    %ecx,%eax
  8034e9:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  8034ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034ef:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034f2:	76 06                	jbe    8034fa <sfree+0x321>
  8034f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8034fa:	ff 45 e0             	incl   -0x20(%ebp)
  8034fd:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803504:	7e a4                	jle    8034aa <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803509:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  80350e:	eb 16                	jmp    803526 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803510:	ff 45 f4             	incl   -0xc(%ebp)
  803513:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  80351a:	0f 8e 04 fd ff ff    	jle    803224 <sfree+0x4b>
  803520:	eb 04                	jmp    803526 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803522:	90                   	nop
  803523:	eb 01                	jmp    803526 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803525:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803526:	c9                   	leave  
  803527:	c3                   	ret    

00803528 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803528:	55                   	push   %ebp
  803529:	89 e5                	mov    %esp,%ebp
  80352b:	57                   	push   %edi
  80352c:	56                   	push   %esi
  80352d:	53                   	push   %ebx
  80352e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	8b 55 0c             	mov    0xc(%ebp),%edx
  803537:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80353a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80353d:	8b 7d 18             	mov    0x18(%ebp),%edi
  803540:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803543:	cd 30                	int    $0x30
  803545:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803548:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80354b:	83 c4 10             	add    $0x10,%esp
  80354e:	5b                   	pop    %ebx
  80354f:	5e                   	pop    %esi
  803550:	5f                   	pop    %edi
  803551:	5d                   	pop    %ebp
  803552:	c3                   	ret    

00803553 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803553:	55                   	push   %ebp
  803554:	89 e5                	mov    %esp,%ebp
  803556:	83 ec 04             	sub    $0x4,%esp
  803559:	8b 45 10             	mov    0x10(%ebp),%eax
  80355c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80355f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803562:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	6a 00                	push   $0x0
  80356b:	51                   	push   %ecx
  80356c:	52                   	push   %edx
  80356d:	ff 75 0c             	pushl  0xc(%ebp)
  803570:	50                   	push   %eax
  803571:	6a 00                	push   $0x0
  803573:	e8 b0 ff ff ff       	call   803528 <syscall>
  803578:	83 c4 18             	add    $0x18,%esp
}
  80357b:	90                   	nop
  80357c:	c9                   	leave  
  80357d:	c3                   	ret    

0080357e <sys_cgetc>:

int
sys_cgetc(void)
{
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803581:	6a 00                	push   $0x0
  803583:	6a 00                	push   $0x0
  803585:	6a 00                	push   $0x0
  803587:	6a 00                	push   $0x0
  803589:	6a 00                	push   $0x0
  80358b:	6a 02                	push   $0x2
  80358d:	e8 96 ff ff ff       	call   803528 <syscall>
  803592:	83 c4 18             	add    $0x18,%esp
}
  803595:	c9                   	leave  
  803596:	c3                   	ret    

00803597 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803597:	55                   	push   %ebp
  803598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80359a:	6a 00                	push   $0x0
  80359c:	6a 00                	push   $0x0
  80359e:	6a 00                	push   $0x0
  8035a0:	6a 00                	push   $0x0
  8035a2:	6a 00                	push   $0x0
  8035a4:	6a 03                	push   $0x3
  8035a6:	e8 7d ff ff ff       	call   803528 <syscall>
  8035ab:	83 c4 18             	add    $0x18,%esp
}
  8035ae:	90                   	nop
  8035af:	c9                   	leave  
  8035b0:	c3                   	ret    

008035b1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8035b1:	55                   	push   %ebp
  8035b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8035b4:	6a 00                	push   $0x0
  8035b6:	6a 00                	push   $0x0
  8035b8:	6a 00                	push   $0x0
  8035ba:	6a 00                	push   $0x0
  8035bc:	6a 00                	push   $0x0
  8035be:	6a 04                	push   $0x4
  8035c0:	e8 63 ff ff ff       	call   803528 <syscall>
  8035c5:	83 c4 18             	add    $0x18,%esp
}
  8035c8:	90                   	nop
  8035c9:	c9                   	leave  
  8035ca:	c3                   	ret    

008035cb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8035cb:	55                   	push   %ebp
  8035cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8035ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	6a 00                	push   $0x0
  8035d6:	6a 00                	push   $0x0
  8035d8:	6a 00                	push   $0x0
  8035da:	52                   	push   %edx
  8035db:	50                   	push   %eax
  8035dc:	6a 08                	push   $0x8
  8035de:	e8 45 ff ff ff       	call   803528 <syscall>
  8035e3:	83 c4 18             	add    $0x18,%esp
}
  8035e6:	c9                   	leave  
  8035e7:	c3                   	ret    

008035e8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8035e8:	55                   	push   %ebp
  8035e9:	89 e5                	mov    %esp,%ebp
  8035eb:	56                   	push   %esi
  8035ec:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8035ed:	8b 75 18             	mov    0x18(%ebp),%esi
  8035f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8035f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8035f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	56                   	push   %esi
  8035fd:	53                   	push   %ebx
  8035fe:	51                   	push   %ecx
  8035ff:	52                   	push   %edx
  803600:	50                   	push   %eax
  803601:	6a 09                	push   $0x9
  803603:	e8 20 ff ff ff       	call   803528 <syscall>
  803608:	83 c4 18             	add    $0x18,%esp
}
  80360b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80360e:	5b                   	pop    %ebx
  80360f:	5e                   	pop    %esi
  803610:	5d                   	pop    %ebp
  803611:	c3                   	ret    

00803612 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803612:	55                   	push   %ebp
  803613:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803615:	6a 00                	push   $0x0
  803617:	6a 00                	push   $0x0
  803619:	6a 00                	push   $0x0
  80361b:	6a 00                	push   $0x0
  80361d:	ff 75 08             	pushl  0x8(%ebp)
  803620:	6a 0a                	push   $0xa
  803622:	e8 01 ff ff ff       	call   803528 <syscall>
  803627:	83 c4 18             	add    $0x18,%esp
}
  80362a:	c9                   	leave  
  80362b:	c3                   	ret    

0080362c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80362c:	55                   	push   %ebp
  80362d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80362f:	6a 00                	push   $0x0
  803631:	6a 00                	push   $0x0
  803633:	6a 00                	push   $0x0
  803635:	ff 75 0c             	pushl  0xc(%ebp)
  803638:	ff 75 08             	pushl  0x8(%ebp)
  80363b:	6a 0b                	push   $0xb
  80363d:	e8 e6 fe ff ff       	call   803528 <syscall>
  803642:	83 c4 18             	add    $0x18,%esp
}
  803645:	c9                   	leave  
  803646:	c3                   	ret    

00803647 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803647:	55                   	push   %ebp
  803648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80364a:	6a 00                	push   $0x0
  80364c:	6a 00                	push   $0x0
  80364e:	6a 00                	push   $0x0
  803650:	6a 00                	push   $0x0
  803652:	6a 00                	push   $0x0
  803654:	6a 0c                	push   $0xc
  803656:	e8 cd fe ff ff       	call   803528 <syscall>
  80365b:	83 c4 18             	add    $0x18,%esp
}
  80365e:	c9                   	leave  
  80365f:	c3                   	ret    

00803660 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803660:	55                   	push   %ebp
  803661:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803663:	6a 00                	push   $0x0
  803665:	6a 00                	push   $0x0
  803667:	6a 00                	push   $0x0
  803669:	6a 00                	push   $0x0
  80366b:	6a 00                	push   $0x0
  80366d:	6a 0d                	push   $0xd
  80366f:	e8 b4 fe ff ff       	call   803528 <syscall>
  803674:	83 c4 18             	add    $0x18,%esp
}
  803677:	c9                   	leave  
  803678:	c3                   	ret    

00803679 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803679:	55                   	push   %ebp
  80367a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80367c:	6a 00                	push   $0x0
  80367e:	6a 00                	push   $0x0
  803680:	6a 00                	push   $0x0
  803682:	6a 00                	push   $0x0
  803684:	6a 00                	push   $0x0
  803686:	6a 0e                	push   $0xe
  803688:	e8 9b fe ff ff       	call   803528 <syscall>
  80368d:	83 c4 18             	add    $0x18,%esp
}
  803690:	c9                   	leave  
  803691:	c3                   	ret    

00803692 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803692:	55                   	push   %ebp
  803693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803695:	6a 00                	push   $0x0
  803697:	6a 00                	push   $0x0
  803699:	6a 00                	push   $0x0
  80369b:	6a 00                	push   $0x0
  80369d:	6a 00                	push   $0x0
  80369f:	6a 0f                	push   $0xf
  8036a1:	e8 82 fe ff ff       	call   803528 <syscall>
  8036a6:	83 c4 18             	add    $0x18,%esp
}
  8036a9:	c9                   	leave  
  8036aa:	c3                   	ret    

008036ab <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8036ab:	55                   	push   %ebp
  8036ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8036ae:	6a 00                	push   $0x0
  8036b0:	6a 00                	push   $0x0
  8036b2:	6a 00                	push   $0x0
  8036b4:	6a 00                	push   $0x0
  8036b6:	ff 75 08             	pushl  0x8(%ebp)
  8036b9:	6a 10                	push   $0x10
  8036bb:	e8 68 fe ff ff       	call   803528 <syscall>
  8036c0:	83 c4 18             	add    $0x18,%esp
}
  8036c3:	c9                   	leave  
  8036c4:	c3                   	ret    

008036c5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8036c5:	55                   	push   %ebp
  8036c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8036c8:	6a 00                	push   $0x0
  8036ca:	6a 00                	push   $0x0
  8036cc:	6a 00                	push   $0x0
  8036ce:	6a 00                	push   $0x0
  8036d0:	6a 00                	push   $0x0
  8036d2:	6a 11                	push   $0x11
  8036d4:	e8 4f fe ff ff       	call   803528 <syscall>
  8036d9:	83 c4 18             	add    $0x18,%esp
}
  8036dc:	90                   	nop
  8036dd:	c9                   	leave  
  8036de:	c3                   	ret    

008036df <sys_cputc>:

void
sys_cputc(const char c)
{
  8036df:	55                   	push   %ebp
  8036e0:	89 e5                	mov    %esp,%ebp
  8036e2:	83 ec 04             	sub    $0x4,%esp
  8036e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8036eb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8036ef:	6a 00                	push   $0x0
  8036f1:	6a 00                	push   $0x0
  8036f3:	6a 00                	push   $0x0
  8036f5:	6a 00                	push   $0x0
  8036f7:	50                   	push   %eax
  8036f8:	6a 01                	push   $0x1
  8036fa:	e8 29 fe ff ff       	call   803528 <syscall>
  8036ff:	83 c4 18             	add    $0x18,%esp
}
  803702:	90                   	nop
  803703:	c9                   	leave  
  803704:	c3                   	ret    

00803705 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803705:	55                   	push   %ebp
  803706:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803708:	6a 00                	push   $0x0
  80370a:	6a 00                	push   $0x0
  80370c:	6a 00                	push   $0x0
  80370e:	6a 00                	push   $0x0
  803710:	6a 00                	push   $0x0
  803712:	6a 14                	push   $0x14
  803714:	e8 0f fe ff ff       	call   803528 <syscall>
  803719:	83 c4 18             	add    $0x18,%esp
}
  80371c:	90                   	nop
  80371d:	c9                   	leave  
  80371e:	c3                   	ret    

0080371f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80371f:	55                   	push   %ebp
  803720:	89 e5                	mov    %esp,%ebp
  803722:	83 ec 04             	sub    $0x4,%esp
  803725:	8b 45 10             	mov    0x10(%ebp),%eax
  803728:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80372b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80372e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	6a 00                	push   $0x0
  803737:	51                   	push   %ecx
  803738:	52                   	push   %edx
  803739:	ff 75 0c             	pushl  0xc(%ebp)
  80373c:	50                   	push   %eax
  80373d:	6a 15                	push   $0x15
  80373f:	e8 e4 fd ff ff       	call   803528 <syscall>
  803744:	83 c4 18             	add    $0x18,%esp
}
  803747:	c9                   	leave  
  803748:	c3                   	ret    

00803749 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803749:	55                   	push   %ebp
  80374a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80374c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	6a 00                	push   $0x0
  803754:	6a 00                	push   $0x0
  803756:	6a 00                	push   $0x0
  803758:	52                   	push   %edx
  803759:	50                   	push   %eax
  80375a:	6a 16                	push   $0x16
  80375c:	e8 c7 fd ff ff       	call   803528 <syscall>
  803761:	83 c4 18             	add    $0x18,%esp
}
  803764:	c9                   	leave  
  803765:	c3                   	ret    

00803766 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803766:	55                   	push   %ebp
  803767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803769:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80376c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80376f:	8b 45 08             	mov    0x8(%ebp),%eax
  803772:	6a 00                	push   $0x0
  803774:	6a 00                	push   $0x0
  803776:	51                   	push   %ecx
  803777:	52                   	push   %edx
  803778:	50                   	push   %eax
  803779:	6a 17                	push   $0x17
  80377b:	e8 a8 fd ff ff       	call   803528 <syscall>
  803780:	83 c4 18             	add    $0x18,%esp
}
  803783:	c9                   	leave  
  803784:	c3                   	ret    

00803785 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803785:	55                   	push   %ebp
  803786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803788:	8b 55 0c             	mov    0xc(%ebp),%edx
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	6a 00                	push   $0x0
  803790:	6a 00                	push   $0x0
  803792:	6a 00                	push   $0x0
  803794:	52                   	push   %edx
  803795:	50                   	push   %eax
  803796:	6a 18                	push   $0x18
  803798:	e8 8b fd ff ff       	call   803528 <syscall>
  80379d:	83 c4 18             	add    $0x18,%esp
}
  8037a0:	c9                   	leave  
  8037a1:	c3                   	ret    

008037a2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8037a2:	55                   	push   %ebp
  8037a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	6a 00                	push   $0x0
  8037aa:	ff 75 14             	pushl  0x14(%ebp)
  8037ad:	ff 75 10             	pushl  0x10(%ebp)
  8037b0:	ff 75 0c             	pushl  0xc(%ebp)
  8037b3:	50                   	push   %eax
  8037b4:	6a 19                	push   $0x19
  8037b6:	e8 6d fd ff ff       	call   803528 <syscall>
  8037bb:	83 c4 18             	add    $0x18,%esp
}
  8037be:	c9                   	leave  
  8037bf:	c3                   	ret    

008037c0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8037c0:	55                   	push   %ebp
  8037c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8037c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	6a 00                	push   $0x0
  8037cc:	6a 00                	push   $0x0
  8037ce:	50                   	push   %eax
  8037cf:	6a 1a                	push   $0x1a
  8037d1:	e8 52 fd ff ff       	call   803528 <syscall>
  8037d6:	83 c4 18             	add    $0x18,%esp
}
  8037d9:	90                   	nop
  8037da:	c9                   	leave  
  8037db:	c3                   	ret    

008037dc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8037dc:	55                   	push   %ebp
  8037dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e2:	6a 00                	push   $0x0
  8037e4:	6a 00                	push   $0x0
  8037e6:	6a 00                	push   $0x0
  8037e8:	6a 00                	push   $0x0
  8037ea:	50                   	push   %eax
  8037eb:	6a 1b                	push   $0x1b
  8037ed:	e8 36 fd ff ff       	call   803528 <syscall>
  8037f2:	83 c4 18             	add    $0x18,%esp
}
  8037f5:	c9                   	leave  
  8037f6:	c3                   	ret    

008037f7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8037f7:	55                   	push   %ebp
  8037f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8037fa:	6a 00                	push   $0x0
  8037fc:	6a 00                	push   $0x0
  8037fe:	6a 00                	push   $0x0
  803800:	6a 00                	push   $0x0
  803802:	6a 00                	push   $0x0
  803804:	6a 05                	push   $0x5
  803806:	e8 1d fd ff ff       	call   803528 <syscall>
  80380b:	83 c4 18             	add    $0x18,%esp
}
  80380e:	c9                   	leave  
  80380f:	c3                   	ret    

00803810 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803810:	55                   	push   %ebp
  803811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803813:	6a 00                	push   $0x0
  803815:	6a 00                	push   $0x0
  803817:	6a 00                	push   $0x0
  803819:	6a 00                	push   $0x0
  80381b:	6a 00                	push   $0x0
  80381d:	6a 06                	push   $0x6
  80381f:	e8 04 fd ff ff       	call   803528 <syscall>
  803824:	83 c4 18             	add    $0x18,%esp
}
  803827:	c9                   	leave  
  803828:	c3                   	ret    

00803829 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803829:	55                   	push   %ebp
  80382a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80382c:	6a 00                	push   $0x0
  80382e:	6a 00                	push   $0x0
  803830:	6a 00                	push   $0x0
  803832:	6a 00                	push   $0x0
  803834:	6a 00                	push   $0x0
  803836:	6a 07                	push   $0x7
  803838:	e8 eb fc ff ff       	call   803528 <syscall>
  80383d:	83 c4 18             	add    $0x18,%esp
}
  803840:	c9                   	leave  
  803841:	c3                   	ret    

00803842 <sys_exit_env>:


void sys_exit_env(void)
{
  803842:	55                   	push   %ebp
  803843:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803845:	6a 00                	push   $0x0
  803847:	6a 00                	push   $0x0
  803849:	6a 00                	push   $0x0
  80384b:	6a 00                	push   $0x0
  80384d:	6a 00                	push   $0x0
  80384f:	6a 1c                	push   $0x1c
  803851:	e8 d2 fc ff ff       	call   803528 <syscall>
  803856:	83 c4 18             	add    $0x18,%esp
}
  803859:	90                   	nop
  80385a:	c9                   	leave  
  80385b:	c3                   	ret    

0080385c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80385c:	55                   	push   %ebp
  80385d:	89 e5                	mov    %esp,%ebp
  80385f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803862:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803865:	8d 50 04             	lea    0x4(%eax),%edx
  803868:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80386b:	6a 00                	push   $0x0
  80386d:	6a 00                	push   $0x0
  80386f:	6a 00                	push   $0x0
  803871:	52                   	push   %edx
  803872:	50                   	push   %eax
  803873:	6a 1d                	push   $0x1d
  803875:	e8 ae fc ff ff       	call   803528 <syscall>
  80387a:	83 c4 18             	add    $0x18,%esp
	return result;
  80387d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803880:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803883:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803886:	89 01                	mov    %eax,(%ecx)
  803888:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80388b:	8b 45 08             	mov    0x8(%ebp),%eax
  80388e:	c9                   	leave  
  80388f:	c2 04 00             	ret    $0x4

00803892 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803892:	55                   	push   %ebp
  803893:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803895:	6a 00                	push   $0x0
  803897:	6a 00                	push   $0x0
  803899:	ff 75 10             	pushl  0x10(%ebp)
  80389c:	ff 75 0c             	pushl  0xc(%ebp)
  80389f:	ff 75 08             	pushl  0x8(%ebp)
  8038a2:	6a 13                	push   $0x13
  8038a4:	e8 7f fc ff ff       	call   803528 <syscall>
  8038a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8038ac:	90                   	nop
}
  8038ad:	c9                   	leave  
  8038ae:	c3                   	ret    

008038af <sys_rcr2>:
uint32 sys_rcr2()
{
  8038af:	55                   	push   %ebp
  8038b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8038b2:	6a 00                	push   $0x0
  8038b4:	6a 00                	push   $0x0
  8038b6:	6a 00                	push   $0x0
  8038b8:	6a 00                	push   $0x0
  8038ba:	6a 00                	push   $0x0
  8038bc:	6a 1e                	push   $0x1e
  8038be:	e8 65 fc ff ff       	call   803528 <syscall>
  8038c3:	83 c4 18             	add    $0x18,%esp
}
  8038c6:	c9                   	leave  
  8038c7:	c3                   	ret    

008038c8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8038c8:	55                   	push   %ebp
  8038c9:	89 e5                	mov    %esp,%ebp
  8038cb:	83 ec 04             	sub    $0x4,%esp
  8038ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8038d4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8038d8:	6a 00                	push   $0x0
  8038da:	6a 00                	push   $0x0
  8038dc:	6a 00                	push   $0x0
  8038de:	6a 00                	push   $0x0
  8038e0:	50                   	push   %eax
  8038e1:	6a 1f                	push   $0x1f
  8038e3:	e8 40 fc ff ff       	call   803528 <syscall>
  8038e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8038eb:	90                   	nop
}
  8038ec:	c9                   	leave  
  8038ed:	c3                   	ret    

008038ee <rsttst>:
void rsttst()
{
  8038ee:	55                   	push   %ebp
  8038ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8038f1:	6a 00                	push   $0x0
  8038f3:	6a 00                	push   $0x0
  8038f5:	6a 00                	push   $0x0
  8038f7:	6a 00                	push   $0x0
  8038f9:	6a 00                	push   $0x0
  8038fb:	6a 21                	push   $0x21
  8038fd:	e8 26 fc ff ff       	call   803528 <syscall>
  803902:	83 c4 18             	add    $0x18,%esp
	return ;
  803905:	90                   	nop
}
  803906:	c9                   	leave  
  803907:	c3                   	ret    

00803908 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803908:	55                   	push   %ebp
  803909:	89 e5                	mov    %esp,%ebp
  80390b:	83 ec 04             	sub    $0x4,%esp
  80390e:	8b 45 14             	mov    0x14(%ebp),%eax
  803911:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803914:	8b 55 18             	mov    0x18(%ebp),%edx
  803917:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80391b:	52                   	push   %edx
  80391c:	50                   	push   %eax
  80391d:	ff 75 10             	pushl  0x10(%ebp)
  803920:	ff 75 0c             	pushl  0xc(%ebp)
  803923:	ff 75 08             	pushl  0x8(%ebp)
  803926:	6a 20                	push   $0x20
  803928:	e8 fb fb ff ff       	call   803528 <syscall>
  80392d:	83 c4 18             	add    $0x18,%esp
	return ;
  803930:	90                   	nop
}
  803931:	c9                   	leave  
  803932:	c3                   	ret    

00803933 <chktst>:
void chktst(uint32 n)
{
  803933:	55                   	push   %ebp
  803934:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803936:	6a 00                	push   $0x0
  803938:	6a 00                	push   $0x0
  80393a:	6a 00                	push   $0x0
  80393c:	6a 00                	push   $0x0
  80393e:	ff 75 08             	pushl  0x8(%ebp)
  803941:	6a 22                	push   $0x22
  803943:	e8 e0 fb ff ff       	call   803528 <syscall>
  803948:	83 c4 18             	add    $0x18,%esp
	return ;
  80394b:	90                   	nop
}
  80394c:	c9                   	leave  
  80394d:	c3                   	ret    

0080394e <inctst>:

void inctst()
{
  80394e:	55                   	push   %ebp
  80394f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803951:	6a 00                	push   $0x0
  803953:	6a 00                	push   $0x0
  803955:	6a 00                	push   $0x0
  803957:	6a 00                	push   $0x0
  803959:	6a 00                	push   $0x0
  80395b:	6a 23                	push   $0x23
  80395d:	e8 c6 fb ff ff       	call   803528 <syscall>
  803962:	83 c4 18             	add    $0x18,%esp
	return ;
  803965:	90                   	nop
}
  803966:	c9                   	leave  
  803967:	c3                   	ret    

00803968 <gettst>:
uint32 gettst()
{
  803968:	55                   	push   %ebp
  803969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80396b:	6a 00                	push   $0x0
  80396d:	6a 00                	push   $0x0
  80396f:	6a 00                	push   $0x0
  803971:	6a 00                	push   $0x0
  803973:	6a 00                	push   $0x0
  803975:	6a 24                	push   $0x24
  803977:	e8 ac fb ff ff       	call   803528 <syscall>
  80397c:	83 c4 18             	add    $0x18,%esp
}
  80397f:	c9                   	leave  
  803980:	c3                   	ret    

00803981 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803981:	55                   	push   %ebp
  803982:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803984:	6a 00                	push   $0x0
  803986:	6a 00                	push   $0x0
  803988:	6a 00                	push   $0x0
  80398a:	6a 00                	push   $0x0
  80398c:	6a 00                	push   $0x0
  80398e:	6a 25                	push   $0x25
  803990:	e8 93 fb ff ff       	call   803528 <syscall>
  803995:	83 c4 18             	add    $0x18,%esp
  803998:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  80399d:	a1 80 60 83 00       	mov    0x836080,%eax
}
  8039a2:	c9                   	leave  
  8039a3:	c3                   	ret    

008039a4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8039a4:	55                   	push   %ebp
  8039a5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8039a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039aa:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8039af:	6a 00                	push   $0x0
  8039b1:	6a 00                	push   $0x0
  8039b3:	6a 00                	push   $0x0
  8039b5:	6a 00                	push   $0x0
  8039b7:	ff 75 08             	pushl  0x8(%ebp)
  8039ba:	6a 26                	push   $0x26
  8039bc:	e8 67 fb ff ff       	call   803528 <syscall>
  8039c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8039c4:	90                   	nop
}
  8039c5:	c9                   	leave  
  8039c6:	c3                   	ret    

008039c7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8039c7:	55                   	push   %ebp
  8039c8:	89 e5                	mov    %esp,%ebp
  8039ca:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8039cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8039ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8039d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d7:	6a 00                	push   $0x0
  8039d9:	53                   	push   %ebx
  8039da:	51                   	push   %ecx
  8039db:	52                   	push   %edx
  8039dc:	50                   	push   %eax
  8039dd:	6a 27                	push   $0x27
  8039df:	e8 44 fb ff ff       	call   803528 <syscall>
  8039e4:	83 c4 18             	add    $0x18,%esp
}
  8039e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039ea:	c9                   	leave  
  8039eb:	c3                   	ret    

008039ec <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8039ec:	55                   	push   %ebp
  8039ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8039ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	6a 00                	push   $0x0
  8039f7:	6a 00                	push   $0x0
  8039f9:	6a 00                	push   $0x0
  8039fb:	52                   	push   %edx
  8039fc:	50                   	push   %eax
  8039fd:	6a 28                	push   $0x28
  8039ff:	e8 24 fb ff ff       	call   803528 <syscall>
  803a04:	83 c4 18             	add    $0x18,%esp
}
  803a07:	c9                   	leave  
  803a08:	c3                   	ret    

00803a09 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803a09:	55                   	push   %ebp
  803a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803a0c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a12:	8b 45 08             	mov    0x8(%ebp),%eax
  803a15:	6a 00                	push   $0x0
  803a17:	51                   	push   %ecx
  803a18:	ff 75 10             	pushl  0x10(%ebp)
  803a1b:	52                   	push   %edx
  803a1c:	50                   	push   %eax
  803a1d:	6a 29                	push   $0x29
  803a1f:	e8 04 fb ff ff       	call   803528 <syscall>
  803a24:	83 c4 18             	add    $0x18,%esp
}
  803a27:	c9                   	leave  
  803a28:	c3                   	ret    

00803a29 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803a29:	55                   	push   %ebp
  803a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803a2c:	6a 00                	push   $0x0
  803a2e:	6a 00                	push   $0x0
  803a30:	ff 75 10             	pushl  0x10(%ebp)
  803a33:	ff 75 0c             	pushl  0xc(%ebp)
  803a36:	ff 75 08             	pushl  0x8(%ebp)
  803a39:	6a 12                	push   $0x12
  803a3b:	e8 e8 fa ff ff       	call   803528 <syscall>
  803a40:	83 c4 18             	add    $0x18,%esp
	return ;
  803a43:	90                   	nop
}
  803a44:	c9                   	leave  
  803a45:	c3                   	ret    

00803a46 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803a46:	55                   	push   %ebp
  803a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4f:	6a 00                	push   $0x0
  803a51:	6a 00                	push   $0x0
  803a53:	6a 00                	push   $0x0
  803a55:	52                   	push   %edx
  803a56:	50                   	push   %eax
  803a57:	6a 2a                	push   $0x2a
  803a59:	e8 ca fa ff ff       	call   803528 <syscall>
  803a5e:	83 c4 18             	add    $0x18,%esp
	return;
  803a61:	90                   	nop
}
  803a62:	c9                   	leave  
  803a63:	c3                   	ret    

00803a64 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803a64:	55                   	push   %ebp
  803a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803a67:	6a 00                	push   $0x0
  803a69:	6a 00                	push   $0x0
  803a6b:	6a 00                	push   $0x0
  803a6d:	6a 00                	push   $0x0
  803a6f:	6a 00                	push   $0x0
  803a71:	6a 2b                	push   $0x2b
  803a73:	e8 b0 fa ff ff       	call   803528 <syscall>
  803a78:	83 c4 18             	add    $0x18,%esp
}
  803a7b:	c9                   	leave  
  803a7c:	c3                   	ret    

00803a7d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803a7d:	55                   	push   %ebp
  803a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803a80:	6a 00                	push   $0x0
  803a82:	6a 00                	push   $0x0
  803a84:	6a 00                	push   $0x0
  803a86:	ff 75 0c             	pushl  0xc(%ebp)
  803a89:	ff 75 08             	pushl  0x8(%ebp)
  803a8c:	6a 2d                	push   $0x2d
  803a8e:	e8 95 fa ff ff       	call   803528 <syscall>
  803a93:	83 c4 18             	add    $0x18,%esp
	return;
  803a96:	90                   	nop
}
  803a97:	c9                   	leave  
  803a98:	c3                   	ret    

00803a99 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803a99:	55                   	push   %ebp
  803a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803a9c:	6a 00                	push   $0x0
  803a9e:	6a 00                	push   $0x0
  803aa0:	6a 00                	push   $0x0
  803aa2:	ff 75 0c             	pushl  0xc(%ebp)
  803aa5:	ff 75 08             	pushl  0x8(%ebp)
  803aa8:	6a 2c                	push   $0x2c
  803aaa:	e8 79 fa ff ff       	call   803528 <syscall>
  803aaf:	83 c4 18             	add    $0x18,%esp
	return ;
  803ab2:	90                   	nop
}
  803ab3:	c9                   	leave  
  803ab4:	c3                   	ret    

00803ab5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803ab5:	55                   	push   %ebp
  803ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  803abb:	8b 45 08             	mov    0x8(%ebp),%eax
  803abe:	6a 00                	push   $0x0
  803ac0:	6a 00                	push   $0x0
  803ac2:	6a 00                	push   $0x0
  803ac4:	52                   	push   %edx
  803ac5:	50                   	push   %eax
  803ac6:	6a 2e                	push   $0x2e
  803ac8:	e8 5b fa ff ff       	call   803528 <syscall>
  803acd:	83 c4 18             	add    $0x18,%esp
}
  803ad0:	90                   	nop
  803ad1:	c9                   	leave  
  803ad2:	c3                   	ret    

00803ad3 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803ad3:	55                   	push   %ebp
  803ad4:	89 e5                	mov    %esp,%ebp
  803ad6:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803ad9:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803ae0:	72 09                	jb     803aeb <to_page_va+0x18>
  803ae2:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803ae9:	72 14                	jb     803aff <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803aeb:	83 ec 04             	sub    $0x4,%esp
  803aee:	68 cc 50 80 00       	push   $0x8050cc
  803af3:	6a 15                	push   $0x15
  803af5:	68 f7 50 80 00       	push   $0x8050f7
  803afa:	e8 08 ce ff ff       	call   800907 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803aff:	8b 45 08             	mov    0x8(%ebp),%eax
  803b02:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803b07:	29 d0                	sub    %edx,%eax
  803b09:	c1 f8 02             	sar    $0x2,%eax
  803b0c:	89 c2                	mov    %eax,%edx
  803b0e:	89 d0                	mov    %edx,%eax
  803b10:	c1 e0 02             	shl    $0x2,%eax
  803b13:	01 d0                	add    %edx,%eax
  803b15:	c1 e0 02             	shl    $0x2,%eax
  803b18:	01 d0                	add    %edx,%eax
  803b1a:	c1 e0 02             	shl    $0x2,%eax
  803b1d:	01 d0                	add    %edx,%eax
  803b1f:	89 c1                	mov    %eax,%ecx
  803b21:	c1 e1 08             	shl    $0x8,%ecx
  803b24:	01 c8                	add    %ecx,%eax
  803b26:	89 c1                	mov    %eax,%ecx
  803b28:	c1 e1 10             	shl    $0x10,%ecx
  803b2b:	01 c8                	add    %ecx,%eax
  803b2d:	01 c0                	add    %eax,%eax
  803b2f:	01 d0                	add    %edx,%eax
  803b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b37:	c1 e0 0c             	shl    $0xc,%eax
  803b3a:	89 c2                	mov    %eax,%edx
  803b3c:	a1 84 60 83 00       	mov    0x836084,%eax
  803b41:	01 d0                	add    %edx,%eax
}
  803b43:	c9                   	leave  
  803b44:	c3                   	ret    

00803b45 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803b45:	55                   	push   %ebp
  803b46:	89 e5                	mov    %esp,%ebp
  803b48:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803b4b:	a1 84 60 83 00       	mov    0x836084,%eax
  803b50:	8b 55 08             	mov    0x8(%ebp),%edx
  803b53:	29 c2                	sub    %eax,%edx
  803b55:	89 d0                	mov    %edx,%eax
  803b57:	c1 e8 0c             	shr    $0xc,%eax
  803b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b61:	78 09                	js     803b6c <to_page_info+0x27>
  803b63:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803b6a:	7e 14                	jle    803b80 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803b6c:	83 ec 04             	sub    $0x4,%esp
  803b6f:	68 10 51 80 00       	push   $0x805110
  803b74:	6a 21                	push   $0x21
  803b76:	68 f7 50 80 00       	push   $0x8050f7
  803b7b:	e8 87 cd ff ff       	call   800907 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b83:	89 d0                	mov    %edx,%eax
  803b85:	01 c0                	add    %eax,%eax
  803b87:	01 d0                	add    %edx,%eax
  803b89:	c1 e0 02             	shl    $0x2,%eax
  803b8c:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803b91:	c9                   	leave  
  803b92:	c3                   	ret    

00803b93 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803b93:	55                   	push   %ebp
  803b94:	89 e5                	mov    %esp,%ebp
  803b96:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803b99:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9c:	05 00 00 00 02       	add    $0x2000000,%eax
  803ba1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ba4:	73 16                	jae    803bbc <initialize_dynamic_allocator+0x29>
  803ba6:	68 34 51 80 00       	push   $0x805134
  803bab:	68 5a 51 80 00       	push   $0x80515a
  803bb0:	6a 2f                	push   $0x2f
  803bb2:	68 f7 50 80 00       	push   $0x8050f7
  803bb7:	e8 4b cd ff ff       	call   800907 <_panic>
	dynAllocStart = daStart;
  803bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbf:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc7:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803bcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803bd3:	eb 36                	jmp    803c0b <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd8:	c1 e0 04             	shl    $0x4,%eax
  803bdb:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be9:	c1 e0 04             	shl    $0x4,%eax
  803bec:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803bf1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfa:	c1 e0 04             	shl    $0x4,%eax
  803bfd:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803c02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803c08:	ff 45 f4             	incl   -0xc(%ebp)
  803c0b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803c0f:	7e c4                	jle    803bd5 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803c11:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803c18:	00 00 00 
  803c1b:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803c22:	00 00 00 
  803c25:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803c2c:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803c2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803c36:	e9 1b 01 00 00       	jmp    803d56 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803c3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c3e:	89 d0                	mov    %edx,%eax
  803c40:	01 c0                	add    %eax,%eax
  803c42:	01 d0                	add    %edx,%eax
  803c44:	c1 e0 02             	shl    $0x2,%eax
  803c47:	05 88 e0 81 00       	add    $0x81e088,%eax
  803c4c:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803c51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c54:	89 d0                	mov    %edx,%eax
  803c56:	01 c0                	add    %eax,%eax
  803c58:	01 d0                	add    %edx,%eax
  803c5a:	c1 e0 02             	shl    $0x2,%eax
  803c5d:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803c62:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803c67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c6a:	89 d0                	mov    %edx,%eax
  803c6c:	01 c0                	add    %eax,%eax
  803c6e:	01 d0                	add    %edx,%eax
  803c70:	c1 e0 02             	shl    $0x2,%eax
  803c73:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c78:	8b 00                	mov    (%eax),%eax
  803c7a:	85 c0                	test   %eax,%eax
  803c7c:	74 2b                	je     803ca9 <initialize_dynamic_allocator+0x116>
  803c7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c81:	89 d0                	mov    %edx,%eax
  803c83:	01 c0                	add    %eax,%eax
  803c85:	01 d0                	add    %edx,%eax
  803c87:	c1 e0 02             	shl    $0x2,%eax
  803c8a:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c8f:	8b 10                	mov    (%eax),%edx
  803c91:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803c94:	89 c8                	mov    %ecx,%eax
  803c96:	01 c0                	add    %eax,%eax
  803c98:	01 c8                	add    %ecx,%eax
  803c9a:	c1 e0 02             	shl    $0x2,%eax
  803c9d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ca2:	8b 00                	mov    (%eax),%eax
  803ca4:	89 42 04             	mov    %eax,0x4(%edx)
  803ca7:	eb 18                	jmp    803cc1 <initialize_dynamic_allocator+0x12e>
  803ca9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cac:	89 d0                	mov    %edx,%eax
  803cae:	01 c0                	add    %eax,%eax
  803cb0:	01 d0                	add    %edx,%eax
  803cb2:	c1 e0 02             	shl    $0x2,%eax
  803cb5:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cba:	8b 00                	mov    (%eax),%eax
  803cbc:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803cc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cc4:	89 d0                	mov    %edx,%eax
  803cc6:	01 c0                	add    %eax,%eax
  803cc8:	01 d0                	add    %edx,%eax
  803cca:	c1 e0 02             	shl    $0x2,%eax
  803ccd:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cd2:	8b 00                	mov    (%eax),%eax
  803cd4:	85 c0                	test   %eax,%eax
  803cd6:	74 2a                	je     803d02 <initialize_dynamic_allocator+0x16f>
  803cd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cdb:	89 d0                	mov    %edx,%eax
  803cdd:	01 c0                	add    %eax,%eax
  803cdf:	01 d0                	add    %edx,%eax
  803ce1:	c1 e0 02             	shl    $0x2,%eax
  803ce4:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ce9:	8b 10                	mov    (%eax),%edx
  803ceb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803cee:	89 c8                	mov    %ecx,%eax
  803cf0:	01 c0                	add    %eax,%eax
  803cf2:	01 c8                	add    %ecx,%eax
  803cf4:	c1 e0 02             	shl    $0x2,%eax
  803cf7:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cfc:	8b 00                	mov    (%eax),%eax
  803cfe:	89 02                	mov    %eax,(%edx)
  803d00:	eb 18                	jmp    803d1a <initialize_dynamic_allocator+0x187>
  803d02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d05:	89 d0                	mov    %edx,%eax
  803d07:	01 c0                	add    %eax,%eax
  803d09:	01 d0                	add    %edx,%eax
  803d0b:	c1 e0 02             	shl    $0x2,%eax
  803d0e:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d13:	8b 00                	mov    (%eax),%eax
  803d15:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803d1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d1d:	89 d0                	mov    %edx,%eax
  803d1f:	01 c0                	add    %eax,%eax
  803d21:	01 d0                	add    %edx,%eax
  803d23:	c1 e0 02             	shl    $0x2,%eax
  803d26:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d34:	89 d0                	mov    %edx,%eax
  803d36:	01 c0                	add    %eax,%eax
  803d38:	01 d0                	add    %edx,%eax
  803d3a:	c1 e0 02             	shl    $0x2,%eax
  803d3d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d48:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803d4d:	48                   	dec    %eax
  803d4e:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803d53:	ff 45 f0             	incl   -0x10(%ebp)
  803d56:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803d5d:	0f 8e d8 fe ff ff    	jle    803c3b <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803d63:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803d6a:	e9 9d 00 00 00       	jmp    803e0c <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803d6f:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803d75:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803d78:	89 c8                	mov    %ecx,%eax
  803d7a:	01 c0                	add    %eax,%eax
  803d7c:	01 c8                	add    %ecx,%eax
  803d7e:	c1 e0 02             	shl    $0x2,%eax
  803d81:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d86:	89 10                	mov    %edx,(%eax)
  803d88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d8b:	89 d0                	mov    %edx,%eax
  803d8d:	01 c0                	add    %eax,%eax
  803d8f:	01 d0                	add    %edx,%eax
  803d91:	c1 e0 02             	shl    $0x2,%eax
  803d94:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d99:	8b 00                	mov    (%eax),%eax
  803d9b:	85 c0                	test   %eax,%eax
  803d9d:	74 1c                	je     803dbb <initialize_dynamic_allocator+0x228>
  803d9f:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803da5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803da8:	89 c8                	mov    %ecx,%eax
  803daa:	01 c0                	add    %eax,%eax
  803dac:	01 c8                	add    %ecx,%eax
  803dae:	c1 e0 02             	shl    $0x2,%eax
  803db1:	05 80 e0 81 00       	add    $0x81e080,%eax
  803db6:	89 42 04             	mov    %eax,0x4(%edx)
  803db9:	eb 16                	jmp    803dd1 <initialize_dynamic_allocator+0x23e>
  803dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dbe:	89 d0                	mov    %edx,%eax
  803dc0:	01 c0                	add    %eax,%eax
  803dc2:	01 d0                	add    %edx,%eax
  803dc4:	c1 e0 02             	shl    $0x2,%eax
  803dc7:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dcc:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803dd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dd4:	89 d0                	mov    %edx,%eax
  803dd6:	01 c0                	add    %eax,%eax
  803dd8:	01 d0                	add    %edx,%eax
  803dda:	c1 e0 02             	shl    $0x2,%eax
  803ddd:	05 80 e0 81 00       	add    $0x81e080,%eax
  803de2:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803de7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dea:	89 d0                	mov    %edx,%eax
  803dec:	01 c0                	add    %eax,%eax
  803dee:	01 d0                	add    %edx,%eax
  803df0:	c1 e0 02             	shl    $0x2,%eax
  803df3:	05 84 e0 81 00       	add    $0x81e084,%eax
  803df8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dfe:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803e03:	40                   	inc    %eax
  803e04:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803e09:	ff 4d ec             	decl   -0x14(%ebp)
  803e0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e10:	0f 89 59 ff ff ff    	jns    803d6f <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803e16:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803e1d:	00 00 00 
}
  803e20:	90                   	nop
  803e21:	c9                   	leave  
  803e22:	c3                   	ret    

00803e23 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803e23:	55                   	push   %ebp
  803e24:	89 e5                	mov    %esp,%ebp
  803e26:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803e29:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2c:	83 ec 0c             	sub    $0xc,%esp
  803e2f:	50                   	push   %eax
  803e30:	e8 10 fd ff ff       	call   803b45 <to_page_info>
  803e35:	83 c4 10             	add    $0x10,%esp
  803e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3e:	8b 40 08             	mov    0x8(%eax),%eax
  803e41:	0f b7 c0             	movzwl %ax,%eax
}
  803e44:	c9                   	leave  
  803e45:	c3                   	ret    

00803e46 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803e46:	55                   	push   %ebp
  803e47:	89 e5                	mov    %esp,%ebp
  803e49:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803e4c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803e53:	76 16                	jbe    803e6b <alloc_block+0x25>
  803e55:	68 70 51 80 00       	push   $0x805170
  803e5a:	68 5a 51 80 00       	push   $0x80515a
  803e5f:	6a 59                	push   $0x59
  803e61:	68 f7 50 80 00       	push   $0x8050f7
  803e66:	e8 9c ca ff ff       	call   800907 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803e6b:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803e72:	eb 08                	jmp    803e7c <alloc_block+0x36>
		allocSize <<= 1;
  803e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e77:	01 c0                	add    %eax,%eax
  803e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e82:	73 09                	jae    803e8d <alloc_block+0x47>
  803e84:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803e8b:	76 e7                	jbe    803e74 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803e8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803e94:	eb 03                	jmp    803e99 <alloc_block+0x53>
		listIndex++;
  803e96:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e9c:	ba 08 00 00 00       	mov    $0x8,%edx
  803ea1:	88 c1                	mov    %al,%cl
  803ea3:	d3 e2                	shl    %cl,%edx
  803ea5:	89 d0                	mov    %edx,%eax
  803ea7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803eaa:	72 ea                	jb     803e96 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803eb2:	e9 f4 00 00 00       	jmp    803fab <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eba:	c1 e0 04             	shl    $0x4,%eax
  803ebd:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ec2:	8b 00                	mov    (%eax),%eax
  803ec4:	85 c0                	test   %eax,%eax
  803ec6:	0f 84 dc 00 00 00    	je     803fa8 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ecf:	c1 e0 04             	shl    $0x4,%eax
  803ed2:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ed7:	8b 00                	mov    (%eax),%eax
  803ed9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ee0:	75 14                	jne    803ef6 <alloc_block+0xb0>
  803ee2:	83 ec 04             	sub    $0x4,%esp
  803ee5:	68 91 51 80 00       	push   $0x805191
  803eea:	6a 6b                	push   $0x6b
  803eec:	68 f7 50 80 00       	push   $0x8050f7
  803ef1:	e8 11 ca ff ff       	call   800907 <_panic>
  803ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef9:	8b 00                	mov    (%eax),%eax
  803efb:	85 c0                	test   %eax,%eax
  803efd:	74 10                	je     803f0f <alloc_block+0xc9>
  803eff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f02:	8b 00                	mov    (%eax),%eax
  803f04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f07:	8b 52 04             	mov    0x4(%edx),%edx
  803f0a:	89 50 04             	mov    %edx,0x4(%eax)
  803f0d:	eb 14                	jmp    803f23 <alloc_block+0xdd>
  803f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f12:	8b 40 04             	mov    0x4(%eax),%eax
  803f15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f18:	c1 e2 04             	shl    $0x4,%edx
  803f1b:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803f21:	89 02                	mov    %eax,(%edx)
  803f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f26:	8b 40 04             	mov    0x4(%eax),%eax
  803f29:	85 c0                	test   %eax,%eax
  803f2b:	74 0f                	je     803f3c <alloc_block+0xf6>
  803f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f30:	8b 40 04             	mov    0x4(%eax),%eax
  803f33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f36:	8b 12                	mov    (%edx),%edx
  803f38:	89 10                	mov    %edx,(%eax)
  803f3a:	eb 13                	jmp    803f4f <alloc_block+0x109>
  803f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3f:	8b 00                	mov    (%eax),%eax
  803f41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f44:	c1 e2 04             	shl    $0x4,%edx
  803f47:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803f4d:	89 02                	mov    %eax,(%edx)
  803f4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f65:	c1 e0 04             	shl    $0x4,%eax
  803f68:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f6d:	8b 00                	mov    (%eax),%eax
  803f6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f75:	c1 e0 04             	shl    $0x4,%eax
  803f78:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f7d:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803f7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f82:	83 ec 0c             	sub    $0xc,%esp
  803f85:	50                   	push   %eax
  803f86:	e8 ba fb ff ff       	call   803b45 <to_page_info>
  803f8b:	83 c4 10             	add    $0x10,%esp
  803f8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803f91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f94:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803f98:	48                   	dec    %eax
  803f99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f9c:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa3:	e9 8f 02 00 00       	jmp    804237 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803fa8:	ff 45 ec             	incl   -0x14(%ebp)
  803fab:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803faf:	0f 8e 02 ff ff ff    	jle    803eb7 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803fb5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803fba:	85 c0                	test   %eax,%eax
  803fbc:	75 14                	jne    803fd2 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803fbe:	83 ec 04             	sub    $0x4,%esp
  803fc1:	68 b0 51 80 00       	push   $0x8051b0
  803fc6:	6a 77                	push   $0x77
  803fc8:	68 f7 50 80 00       	push   $0x8050f7
  803fcd:	e8 35 c9 ff ff       	call   800907 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803fd2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803fd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803fda:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803fde:	75 14                	jne    803ff4 <alloc_block+0x1ae>
  803fe0:	83 ec 04             	sub    $0x4,%esp
  803fe3:	68 91 51 80 00       	push   $0x805191
  803fe8:	6a 7a                	push   $0x7a
  803fea:	68 f7 50 80 00       	push   $0x8050f7
  803fef:	e8 13 c9 ff ff       	call   800907 <_panic>
  803ff4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ff7:	8b 00                	mov    (%eax),%eax
  803ff9:	85 c0                	test   %eax,%eax
  803ffb:	74 10                	je     80400d <alloc_block+0x1c7>
  803ffd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804000:	8b 00                	mov    (%eax),%eax
  804002:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804005:	8b 52 04             	mov    0x4(%edx),%edx
  804008:	89 50 04             	mov    %edx,0x4(%eax)
  80400b:	eb 0b                	jmp    804018 <alloc_block+0x1d2>
  80400d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804010:	8b 40 04             	mov    0x4(%eax),%eax
  804013:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  804018:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80401b:	8b 40 04             	mov    0x4(%eax),%eax
  80401e:	85 c0                	test   %eax,%eax
  804020:	74 0f                	je     804031 <alloc_block+0x1eb>
  804022:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804025:	8b 40 04             	mov    0x4(%eax),%eax
  804028:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80402b:	8b 12                	mov    (%edx),%edx
  80402d:	89 10                	mov    %edx,(%eax)
  80402f:	eb 0a                	jmp    80403b <alloc_block+0x1f5>
  804031:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804034:	8b 00                	mov    (%eax),%eax
  804036:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80403b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80403e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804044:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804047:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80404e:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804053:	48                   	dec    %eax
  804054:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  804059:	83 ec 0c             	sub    $0xc,%esp
  80405c:	ff 75 dc             	pushl  -0x24(%ebp)
  80405f:	e8 6f fa ff ff       	call   803ad3 <to_page_va>
  804064:	83 c4 10             	add    $0x10,%esp
  804067:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  80406a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80406d:	83 ec 0c             	sub    $0xc,%esp
  804070:	50                   	push   %eax
  804071:	e8 a0 dc ff ff       	call   801d16 <get_page>
  804076:	83 c4 10             	add    $0x10,%esp
  804079:	85 c0                	test   %eax,%eax
  80407b:	74 14                	je     804091 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  80407d:	83 ec 04             	sub    $0x4,%esp
  804080:	68 d8 51 80 00       	push   $0x8051d8
  804085:	6a 7f                	push   $0x7f
  804087:	68 f7 50 80 00       	push   $0x8050f7
  80408c:	e8 76 c8 ff ff       	call   800907 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  804091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804094:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804097:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  80409b:	b8 00 10 00 00       	mov    $0x1000,%eax
  8040a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8040a5:	f7 75 f4             	divl   -0xc(%ebp)
  8040a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040ab:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8040af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8040b6:	e9 a7 00 00 00       	jmp    804162 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8040bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8040be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040c1:	01 d0                	add    %edx,%eax
  8040c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8040c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8040ca:	75 17                	jne    8040e3 <alloc_block+0x29d>
  8040cc:	83 ec 04             	sub    $0x4,%esp
  8040cf:	68 00 52 80 00       	push   $0x805200
  8040d4:	68 88 00 00 00       	push   $0x88
  8040d9:	68 f7 50 80 00       	push   $0x8050f7
  8040de:	e8 24 c8 ff ff       	call   800907 <_panic>
  8040e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040e6:	c1 e0 04             	shl    $0x4,%eax
  8040e9:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8040ee:	8b 10                	mov    (%eax),%edx
  8040f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040f3:	89 10                	mov    %edx,(%eax)
  8040f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040f8:	8b 00                	mov    (%eax),%eax
  8040fa:	85 c0                	test   %eax,%eax
  8040fc:	74 15                	je     804113 <alloc_block+0x2cd>
  8040fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804101:	c1 e0 04             	shl    $0x4,%eax
  804104:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804109:	8b 00                	mov    (%eax),%eax
  80410b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80410e:	89 50 04             	mov    %edx,0x4(%eax)
  804111:	eb 11                	jmp    804124 <alloc_block+0x2de>
  804113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804116:	c1 e0 04             	shl    $0x4,%eax
  804119:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  80411f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804122:	89 02                	mov    %eax,(%edx)
  804124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804127:	c1 e0 04             	shl    $0x4,%eax
  80412a:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  804130:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804133:	89 02                	mov    %eax,(%edx)
  804135:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804138:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80413f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804142:	c1 e0 04             	shl    $0x4,%eax
  804145:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80414a:	8b 00                	mov    (%eax),%eax
  80414c:	8d 50 01             	lea    0x1(%eax),%edx
  80414f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804152:	c1 e0 04             	shl    $0x4,%eax
  804155:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80415a:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80415c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80415f:	01 45 e8             	add    %eax,-0x18(%ebp)
  804162:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  804169:	0f 86 4c ff ff ff    	jbe    8040bb <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  80416f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804172:	c1 e0 04             	shl    $0x4,%eax
  804175:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80417a:	8b 00                	mov    (%eax),%eax
  80417c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  80417f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804183:	75 17                	jne    80419c <alloc_block+0x356>
  804185:	83 ec 04             	sub    $0x4,%esp
  804188:	68 91 51 80 00       	push   $0x805191
  80418d:	68 8d 00 00 00       	push   $0x8d
  804192:	68 f7 50 80 00       	push   $0x8050f7
  804197:	e8 6b c7 ff ff       	call   800907 <_panic>
  80419c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80419f:	8b 00                	mov    (%eax),%eax
  8041a1:	85 c0                	test   %eax,%eax
  8041a3:	74 10                	je     8041b5 <alloc_block+0x36f>
  8041a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041a8:	8b 00                	mov    (%eax),%eax
  8041aa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8041ad:	8b 52 04             	mov    0x4(%edx),%edx
  8041b0:	89 50 04             	mov    %edx,0x4(%eax)
  8041b3:	eb 14                	jmp    8041c9 <alloc_block+0x383>
  8041b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041b8:	8b 40 04             	mov    0x4(%eax),%eax
  8041bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041be:	c1 e2 04             	shl    $0x4,%edx
  8041c1:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  8041c7:	89 02                	mov    %eax,(%edx)
  8041c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041cc:	8b 40 04             	mov    0x4(%eax),%eax
  8041cf:	85 c0                	test   %eax,%eax
  8041d1:	74 0f                	je     8041e2 <alloc_block+0x39c>
  8041d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041d6:	8b 40 04             	mov    0x4(%eax),%eax
  8041d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8041dc:	8b 12                	mov    (%edx),%edx
  8041de:	89 10                	mov    %edx,(%eax)
  8041e0:	eb 13                	jmp    8041f5 <alloc_block+0x3af>
  8041e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041e5:	8b 00                	mov    (%eax),%eax
  8041e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041ea:	c1 e2 04             	shl    $0x4,%edx
  8041ed:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8041f3:	89 02                	mov    %eax,(%edx)
  8041f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804201:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80420b:	c1 e0 04             	shl    $0x4,%eax
  80420e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804213:	8b 00                	mov    (%eax),%eax
  804215:	8d 50 ff             	lea    -0x1(%eax),%edx
  804218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80421b:	c1 e0 04             	shl    $0x4,%eax
  80421e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804223:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  804225:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804228:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80422c:	48                   	dec    %eax
  80422d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804230:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  804234:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804237:	c9                   	leave  
  804238:	c3                   	ret    

00804239 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804239:	55                   	push   %ebp
  80423a:	89 e5                	mov    %esp,%ebp
  80423c:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80423f:	8b 55 08             	mov    0x8(%ebp),%edx
  804242:	a1 84 60 83 00       	mov    0x836084,%eax
  804247:	39 c2                	cmp    %eax,%edx
  804249:	72 0c                	jb     804257 <free_block+0x1e>
  80424b:	8b 55 08             	mov    0x8(%ebp),%edx
  80424e:	a1 60 e0 81 00       	mov    0x81e060,%eax
  804253:	39 c2                	cmp    %eax,%edx
  804255:	72 19                	jb     804270 <free_block+0x37>
  804257:	68 24 52 80 00       	push   $0x805224
  80425c:	68 5a 51 80 00       	push   $0x80515a
  804261:	68 98 00 00 00       	push   $0x98
  804266:	68 f7 50 80 00       	push   $0x8050f7
  80426b:	e8 97 c6 ff ff       	call   800907 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804270:	8b 45 08             	mov    0x8(%ebp),%eax
  804273:	83 ec 0c             	sub    $0xc,%esp
  804276:	50                   	push   %eax
  804277:	e8 c9 f8 ff ff       	call   803b45 <to_page_info>
  80427c:	83 c4 10             	add    $0x10,%esp
  80427f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804285:	8b 40 08             	mov    0x8(%eax),%eax
  804288:	0f b7 c0             	movzwl %ax,%eax
  80428b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  80428e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804295:	eb 03                	jmp    80429a <free_block+0x61>
		listIndex++;
  804297:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  80429a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80429d:	ba 08 00 00 00       	mov    $0x8,%edx
  8042a2:	88 c1                	mov    %al,%cl
  8042a4:	d3 e2                	shl    %cl,%edx
  8042a6:	89 d0                	mov    %edx,%eax
  8042a8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8042ab:	72 ea                	jb     804297 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  8042ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  8042b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8042b7:	75 17                	jne    8042d0 <free_block+0x97>
  8042b9:	83 ec 04             	sub    $0x4,%esp
  8042bc:	68 00 52 80 00       	push   $0x805200
  8042c1:	68 a2 00 00 00       	push   $0xa2
  8042c6:	68 f7 50 80 00       	push   $0x8050f7
  8042cb:	e8 37 c6 ff ff       	call   800907 <_panic>
  8042d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042d3:	c1 e0 04             	shl    $0x4,%eax
  8042d6:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8042db:	8b 10                	mov    (%eax),%edx
  8042dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042e0:	89 10                	mov    %edx,(%eax)
  8042e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042e5:	8b 00                	mov    (%eax),%eax
  8042e7:	85 c0                	test   %eax,%eax
  8042e9:	74 15                	je     804300 <free_block+0xc7>
  8042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ee:	c1 e0 04             	shl    $0x4,%eax
  8042f1:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8042f6:	8b 00                	mov    (%eax),%eax
  8042f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042fb:	89 50 04             	mov    %edx,0x4(%eax)
  8042fe:	eb 11                	jmp    804311 <free_block+0xd8>
  804300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804303:	c1 e0 04             	shl    $0x4,%eax
  804306:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  80430c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80430f:	89 02                	mov    %eax,(%edx)
  804311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804314:	c1 e0 04             	shl    $0x4,%eax
  804317:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  80431d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804320:	89 02                	mov    %eax,(%edx)
  804322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804325:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80432c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80432f:	c1 e0 04             	shl    $0x4,%eax
  804332:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804337:	8b 00                	mov    (%eax),%eax
  804339:	8d 50 01             	lea    0x1(%eax),%edx
  80433c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80433f:	c1 e0 04             	shl    $0x4,%eax
  804342:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804347:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80434c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804350:	40                   	inc    %eax
  804351:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804354:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804358:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80435b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80435f:	0f b7 c8             	movzwl %ax,%ecx
  804362:	b8 00 10 00 00       	mov    $0x1000,%eax
  804367:	ba 00 00 00 00       	mov    $0x0,%edx
  80436c:	f7 75 e8             	divl   -0x18(%ebp)
  80436f:	39 c1                	cmp    %eax,%ecx
  804371:	0f 85 ed 01 00 00    	jne    804564 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437a:	c1 e0 04             	shl    $0x4,%eax
  80437d:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804382:	8b 00                	mov    (%eax),%eax
  804384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804387:	eb 2a                	jmp    8043b3 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  804389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80438c:	83 ec 0c             	sub    $0xc,%esp
  80438f:	50                   	push   %eax
  804390:	e8 b0 f7 ff ff       	call   803b45 <to_page_info>
  804395:	83 c4 10             	add    $0x10,%esp
  804398:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80439b:	75 06                	jne    8043a3 <free_block+0x16a>
				tmp = b;
  80439d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8043a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a6:	c1 e0 04             	shl    $0x4,%eax
  8043a9:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8043ae:	8b 00                	mov    (%eax),%eax
  8043b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8043b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8043b7:	74 07                	je     8043c0 <free_block+0x187>
  8043b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043bc:	8b 00                	mov    (%eax),%eax
  8043be:	eb 05                	jmp    8043c5 <free_block+0x18c>
  8043c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043c8:	c1 e2 04             	shl    $0x4,%edx
  8043cb:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  8043d1:	89 02                	mov    %eax,(%edx)
  8043d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d6:	c1 e0 04             	shl    $0x4,%eax
  8043d9:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8043de:	8b 00                	mov    (%eax),%eax
  8043e0:	85 c0                	test   %eax,%eax
  8043e2:	75 a5                	jne    804389 <free_block+0x150>
  8043e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8043e8:	75 9f                	jne    804389 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  8043ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ed:	c1 e0 04             	shl    $0x4,%eax
  8043f0:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8043f5:	8b 00                	mov    (%eax),%eax
  8043f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  8043fa:	e9 cc 00 00 00       	jmp    8044cb <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  8043ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804402:	8b 00                	mov    (%eax),%eax
  804404:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80440a:	83 ec 0c             	sub    $0xc,%esp
  80440d:	50                   	push   %eax
  80440e:	e8 32 f7 ff ff       	call   803b45 <to_page_info>
  804413:	83 c4 10             	add    $0x10,%esp
  804416:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804419:	0f 85 a6 00 00 00    	jne    8044c5 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  80441f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804423:	75 17                	jne    80443c <free_block+0x203>
  804425:	83 ec 04             	sub    $0x4,%esp
  804428:	68 91 51 80 00       	push   $0x805191
  80442d:	68 b5 00 00 00       	push   $0xb5
  804432:	68 f7 50 80 00       	push   $0x8050f7
  804437:	e8 cb c4 ff ff       	call   800907 <_panic>
  80443c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80443f:	8b 00                	mov    (%eax),%eax
  804441:	85 c0                	test   %eax,%eax
  804443:	74 10                	je     804455 <free_block+0x21c>
  804445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804448:	8b 00                	mov    (%eax),%eax
  80444a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80444d:	8b 52 04             	mov    0x4(%edx),%edx
  804450:	89 50 04             	mov    %edx,0x4(%eax)
  804453:	eb 14                	jmp    804469 <free_block+0x230>
  804455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804458:	8b 40 04             	mov    0x4(%eax),%eax
  80445b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80445e:	c1 e2 04             	shl    $0x4,%edx
  804461:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804467:	89 02                	mov    %eax,(%edx)
  804469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80446c:	8b 40 04             	mov    0x4(%eax),%eax
  80446f:	85 c0                	test   %eax,%eax
  804471:	74 0f                	je     804482 <free_block+0x249>
  804473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804476:	8b 40 04             	mov    0x4(%eax),%eax
  804479:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80447c:	8b 12                	mov    (%edx),%edx
  80447e:	89 10                	mov    %edx,(%eax)
  804480:	eb 13                	jmp    804495 <free_block+0x25c>
  804482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804485:	8b 00                	mov    (%eax),%eax
  804487:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80448a:	c1 e2 04             	shl    $0x4,%edx
  80448d:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804493:	89 02                	mov    %eax,(%edx)
  804495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804498:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80449e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044ab:	c1 e0 04             	shl    $0x4,%eax
  8044ae:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8044b3:	8b 00                	mov    (%eax),%eax
  8044b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8044b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044bb:	c1 e0 04             	shl    $0x4,%eax
  8044be:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8044c3:	89 10                	mov    %edx,(%eax)
			b = next;
  8044c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  8044cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044cf:	0f 85 2a ff ff ff    	jne    8043ff <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  8044d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044d8:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8044de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044e1:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  8044e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8044eb:	75 17                	jne    804504 <free_block+0x2cb>
  8044ed:	83 ec 04             	sub    $0x4,%esp
  8044f0:	68 00 52 80 00       	push   $0x805200
  8044f5:	68 bc 00 00 00       	push   $0xbc
  8044fa:	68 f7 50 80 00       	push   $0x8050f7
  8044ff:	e8 03 c4 ff ff       	call   800907 <_panic>
  804504:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80450a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80450d:	89 10                	mov    %edx,(%eax)
  80450f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804512:	8b 00                	mov    (%eax),%eax
  804514:	85 c0                	test   %eax,%eax
  804516:	74 0d                	je     804525 <free_block+0x2ec>
  804518:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80451d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804520:	89 50 04             	mov    %edx,0x4(%eax)
  804523:	eb 08                	jmp    80452d <free_block+0x2f4>
  804525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804528:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  80452d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804530:	a3 68 e0 81 00       	mov    %eax,0x81e068
  804535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80453f:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804544:	40                   	inc    %eax
  804545:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  80454a:	83 ec 0c             	sub    $0xc,%esp
  80454d:	ff 75 ec             	pushl  -0x14(%ebp)
  804550:	e8 7e f5 ff ff       	call   803ad3 <to_page_va>
  804555:	83 c4 10             	add    $0x10,%esp
  804558:	83 ec 0c             	sub    $0xc,%esp
  80455b:	50                   	push   %eax
  80455c:	e8 fe d7 ff ff       	call   801d5f <return_page>
  804561:	83 c4 10             	add    $0x10,%esp
	}
}
  804564:	90                   	nop
  804565:	c9                   	leave  
  804566:	c3                   	ret    
  804567:	90                   	nop

00804568 <__udivdi3>:
  804568:	55                   	push   %ebp
  804569:	57                   	push   %edi
  80456a:	56                   	push   %esi
  80456b:	53                   	push   %ebx
  80456c:	83 ec 1c             	sub    $0x1c,%esp
  80456f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804573:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804577:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80457b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80457f:	89 ca                	mov    %ecx,%edx
  804581:	89 f8                	mov    %edi,%eax
  804583:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804587:	85 f6                	test   %esi,%esi
  804589:	75 2d                	jne    8045b8 <__udivdi3+0x50>
  80458b:	39 cf                	cmp    %ecx,%edi
  80458d:	77 65                	ja     8045f4 <__udivdi3+0x8c>
  80458f:	89 fd                	mov    %edi,%ebp
  804591:	85 ff                	test   %edi,%edi
  804593:	75 0b                	jne    8045a0 <__udivdi3+0x38>
  804595:	b8 01 00 00 00       	mov    $0x1,%eax
  80459a:	31 d2                	xor    %edx,%edx
  80459c:	f7 f7                	div    %edi
  80459e:	89 c5                	mov    %eax,%ebp
  8045a0:	31 d2                	xor    %edx,%edx
  8045a2:	89 c8                	mov    %ecx,%eax
  8045a4:	f7 f5                	div    %ebp
  8045a6:	89 c1                	mov    %eax,%ecx
  8045a8:	89 d8                	mov    %ebx,%eax
  8045aa:	f7 f5                	div    %ebp
  8045ac:	89 cf                	mov    %ecx,%edi
  8045ae:	89 fa                	mov    %edi,%edx
  8045b0:	83 c4 1c             	add    $0x1c,%esp
  8045b3:	5b                   	pop    %ebx
  8045b4:	5e                   	pop    %esi
  8045b5:	5f                   	pop    %edi
  8045b6:	5d                   	pop    %ebp
  8045b7:	c3                   	ret    
  8045b8:	39 ce                	cmp    %ecx,%esi
  8045ba:	77 28                	ja     8045e4 <__udivdi3+0x7c>
  8045bc:	0f bd fe             	bsr    %esi,%edi
  8045bf:	83 f7 1f             	xor    $0x1f,%edi
  8045c2:	75 40                	jne    804604 <__udivdi3+0x9c>
  8045c4:	39 ce                	cmp    %ecx,%esi
  8045c6:	72 0a                	jb     8045d2 <__udivdi3+0x6a>
  8045c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8045cc:	0f 87 9e 00 00 00    	ja     804670 <__udivdi3+0x108>
  8045d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8045d7:	89 fa                	mov    %edi,%edx
  8045d9:	83 c4 1c             	add    $0x1c,%esp
  8045dc:	5b                   	pop    %ebx
  8045dd:	5e                   	pop    %esi
  8045de:	5f                   	pop    %edi
  8045df:	5d                   	pop    %ebp
  8045e0:	c3                   	ret    
  8045e1:	8d 76 00             	lea    0x0(%esi),%esi
  8045e4:	31 ff                	xor    %edi,%edi
  8045e6:	31 c0                	xor    %eax,%eax
  8045e8:	89 fa                	mov    %edi,%edx
  8045ea:	83 c4 1c             	add    $0x1c,%esp
  8045ed:	5b                   	pop    %ebx
  8045ee:	5e                   	pop    %esi
  8045ef:	5f                   	pop    %edi
  8045f0:	5d                   	pop    %ebp
  8045f1:	c3                   	ret    
  8045f2:	66 90                	xchg   %ax,%ax
  8045f4:	89 d8                	mov    %ebx,%eax
  8045f6:	f7 f7                	div    %edi
  8045f8:	31 ff                	xor    %edi,%edi
  8045fa:	89 fa                	mov    %edi,%edx
  8045fc:	83 c4 1c             	add    $0x1c,%esp
  8045ff:	5b                   	pop    %ebx
  804600:	5e                   	pop    %esi
  804601:	5f                   	pop    %edi
  804602:	5d                   	pop    %ebp
  804603:	c3                   	ret    
  804604:	bd 20 00 00 00       	mov    $0x20,%ebp
  804609:	89 eb                	mov    %ebp,%ebx
  80460b:	29 fb                	sub    %edi,%ebx
  80460d:	89 f9                	mov    %edi,%ecx
  80460f:	d3 e6                	shl    %cl,%esi
  804611:	89 c5                	mov    %eax,%ebp
  804613:	88 d9                	mov    %bl,%cl
  804615:	d3 ed                	shr    %cl,%ebp
  804617:	89 e9                	mov    %ebp,%ecx
  804619:	09 f1                	or     %esi,%ecx
  80461b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80461f:	89 f9                	mov    %edi,%ecx
  804621:	d3 e0                	shl    %cl,%eax
  804623:	89 c5                	mov    %eax,%ebp
  804625:	89 d6                	mov    %edx,%esi
  804627:	88 d9                	mov    %bl,%cl
  804629:	d3 ee                	shr    %cl,%esi
  80462b:	89 f9                	mov    %edi,%ecx
  80462d:	d3 e2                	shl    %cl,%edx
  80462f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804633:	88 d9                	mov    %bl,%cl
  804635:	d3 e8                	shr    %cl,%eax
  804637:	09 c2                	or     %eax,%edx
  804639:	89 d0                	mov    %edx,%eax
  80463b:	89 f2                	mov    %esi,%edx
  80463d:	f7 74 24 0c          	divl   0xc(%esp)
  804641:	89 d6                	mov    %edx,%esi
  804643:	89 c3                	mov    %eax,%ebx
  804645:	f7 e5                	mul    %ebp
  804647:	39 d6                	cmp    %edx,%esi
  804649:	72 19                	jb     804664 <__udivdi3+0xfc>
  80464b:	74 0b                	je     804658 <__udivdi3+0xf0>
  80464d:	89 d8                	mov    %ebx,%eax
  80464f:	31 ff                	xor    %edi,%edi
  804651:	e9 58 ff ff ff       	jmp    8045ae <__udivdi3+0x46>
  804656:	66 90                	xchg   %ax,%ax
  804658:	8b 54 24 08          	mov    0x8(%esp),%edx
  80465c:	89 f9                	mov    %edi,%ecx
  80465e:	d3 e2                	shl    %cl,%edx
  804660:	39 c2                	cmp    %eax,%edx
  804662:	73 e9                	jae    80464d <__udivdi3+0xe5>
  804664:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804667:	31 ff                	xor    %edi,%edi
  804669:	e9 40 ff ff ff       	jmp    8045ae <__udivdi3+0x46>
  80466e:	66 90                	xchg   %ax,%ax
  804670:	31 c0                	xor    %eax,%eax
  804672:	e9 37 ff ff ff       	jmp    8045ae <__udivdi3+0x46>
  804677:	90                   	nop

00804678 <__umoddi3>:
  804678:	55                   	push   %ebp
  804679:	57                   	push   %edi
  80467a:	56                   	push   %esi
  80467b:	53                   	push   %ebx
  80467c:	83 ec 1c             	sub    $0x1c,%esp
  80467f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804683:	8b 74 24 34          	mov    0x34(%esp),%esi
  804687:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80468b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80468f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804693:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804697:	89 f3                	mov    %esi,%ebx
  804699:	89 fa                	mov    %edi,%edx
  80469b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80469f:	89 34 24             	mov    %esi,(%esp)
  8046a2:	85 c0                	test   %eax,%eax
  8046a4:	75 1a                	jne    8046c0 <__umoddi3+0x48>
  8046a6:	39 f7                	cmp    %esi,%edi
  8046a8:	0f 86 a2 00 00 00    	jbe    804750 <__umoddi3+0xd8>
  8046ae:	89 c8                	mov    %ecx,%eax
  8046b0:	89 f2                	mov    %esi,%edx
  8046b2:	f7 f7                	div    %edi
  8046b4:	89 d0                	mov    %edx,%eax
  8046b6:	31 d2                	xor    %edx,%edx
  8046b8:	83 c4 1c             	add    $0x1c,%esp
  8046bb:	5b                   	pop    %ebx
  8046bc:	5e                   	pop    %esi
  8046bd:	5f                   	pop    %edi
  8046be:	5d                   	pop    %ebp
  8046bf:	c3                   	ret    
  8046c0:	39 f0                	cmp    %esi,%eax
  8046c2:	0f 87 ac 00 00 00    	ja     804774 <__umoddi3+0xfc>
  8046c8:	0f bd e8             	bsr    %eax,%ebp
  8046cb:	83 f5 1f             	xor    $0x1f,%ebp
  8046ce:	0f 84 ac 00 00 00    	je     804780 <__umoddi3+0x108>
  8046d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8046d9:	29 ef                	sub    %ebp,%edi
  8046db:	89 fe                	mov    %edi,%esi
  8046dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8046e1:	89 e9                	mov    %ebp,%ecx
  8046e3:	d3 e0                	shl    %cl,%eax
  8046e5:	89 d7                	mov    %edx,%edi
  8046e7:	89 f1                	mov    %esi,%ecx
  8046e9:	d3 ef                	shr    %cl,%edi
  8046eb:	09 c7                	or     %eax,%edi
  8046ed:	89 e9                	mov    %ebp,%ecx
  8046ef:	d3 e2                	shl    %cl,%edx
  8046f1:	89 14 24             	mov    %edx,(%esp)
  8046f4:	89 d8                	mov    %ebx,%eax
  8046f6:	d3 e0                	shl    %cl,%eax
  8046f8:	89 c2                	mov    %eax,%edx
  8046fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046fe:	d3 e0                	shl    %cl,%eax
  804700:	89 44 24 04          	mov    %eax,0x4(%esp)
  804704:	8b 44 24 08          	mov    0x8(%esp),%eax
  804708:	89 f1                	mov    %esi,%ecx
  80470a:	d3 e8                	shr    %cl,%eax
  80470c:	09 d0                	or     %edx,%eax
  80470e:	d3 eb                	shr    %cl,%ebx
  804710:	89 da                	mov    %ebx,%edx
  804712:	f7 f7                	div    %edi
  804714:	89 d3                	mov    %edx,%ebx
  804716:	f7 24 24             	mull   (%esp)
  804719:	89 c6                	mov    %eax,%esi
  80471b:	89 d1                	mov    %edx,%ecx
  80471d:	39 d3                	cmp    %edx,%ebx
  80471f:	0f 82 87 00 00 00    	jb     8047ac <__umoddi3+0x134>
  804725:	0f 84 91 00 00 00    	je     8047bc <__umoddi3+0x144>
  80472b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80472f:	29 f2                	sub    %esi,%edx
  804731:	19 cb                	sbb    %ecx,%ebx
  804733:	89 d8                	mov    %ebx,%eax
  804735:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804739:	d3 e0                	shl    %cl,%eax
  80473b:	89 e9                	mov    %ebp,%ecx
  80473d:	d3 ea                	shr    %cl,%edx
  80473f:	09 d0                	or     %edx,%eax
  804741:	89 e9                	mov    %ebp,%ecx
  804743:	d3 eb                	shr    %cl,%ebx
  804745:	89 da                	mov    %ebx,%edx
  804747:	83 c4 1c             	add    $0x1c,%esp
  80474a:	5b                   	pop    %ebx
  80474b:	5e                   	pop    %esi
  80474c:	5f                   	pop    %edi
  80474d:	5d                   	pop    %ebp
  80474e:	c3                   	ret    
  80474f:	90                   	nop
  804750:	89 fd                	mov    %edi,%ebp
  804752:	85 ff                	test   %edi,%edi
  804754:	75 0b                	jne    804761 <__umoddi3+0xe9>
  804756:	b8 01 00 00 00       	mov    $0x1,%eax
  80475b:	31 d2                	xor    %edx,%edx
  80475d:	f7 f7                	div    %edi
  80475f:	89 c5                	mov    %eax,%ebp
  804761:	89 f0                	mov    %esi,%eax
  804763:	31 d2                	xor    %edx,%edx
  804765:	f7 f5                	div    %ebp
  804767:	89 c8                	mov    %ecx,%eax
  804769:	f7 f5                	div    %ebp
  80476b:	89 d0                	mov    %edx,%eax
  80476d:	e9 44 ff ff ff       	jmp    8046b6 <__umoddi3+0x3e>
  804772:	66 90                	xchg   %ax,%ax
  804774:	89 c8                	mov    %ecx,%eax
  804776:	89 f2                	mov    %esi,%edx
  804778:	83 c4 1c             	add    $0x1c,%esp
  80477b:	5b                   	pop    %ebx
  80477c:	5e                   	pop    %esi
  80477d:	5f                   	pop    %edi
  80477e:	5d                   	pop    %ebp
  80477f:	c3                   	ret    
  804780:	3b 04 24             	cmp    (%esp),%eax
  804783:	72 06                	jb     80478b <__umoddi3+0x113>
  804785:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804789:	77 0f                	ja     80479a <__umoddi3+0x122>
  80478b:	89 f2                	mov    %esi,%edx
  80478d:	29 f9                	sub    %edi,%ecx
  80478f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804793:	89 14 24             	mov    %edx,(%esp)
  804796:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80479a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80479e:	8b 14 24             	mov    (%esp),%edx
  8047a1:	83 c4 1c             	add    $0x1c,%esp
  8047a4:	5b                   	pop    %ebx
  8047a5:	5e                   	pop    %esi
  8047a6:	5f                   	pop    %edi
  8047a7:	5d                   	pop    %ebp
  8047a8:	c3                   	ret    
  8047a9:	8d 76 00             	lea    0x0(%esi),%esi
  8047ac:	2b 04 24             	sub    (%esp),%eax
  8047af:	19 fa                	sbb    %edi,%edx
  8047b1:	89 d1                	mov    %edx,%ecx
  8047b3:	89 c6                	mov    %eax,%esi
  8047b5:	e9 71 ff ff ff       	jmp    80472b <__umoddi3+0xb3>
  8047ba:	66 90                	xchg   %ax,%ax
  8047bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8047c0:	72 ea                	jb     8047ac <__umoddi3+0x134>
  8047c2:	89 d9                	mov    %ebx,%ecx
  8047c4:	e9 62 ff ff ff       	jmp    80472b <__umoddi3+0xb3>
