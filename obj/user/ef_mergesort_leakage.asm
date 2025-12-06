
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 48 07 00 00       	call   80077e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80004b:	e8 66 33 00 00       	call   8033b6 <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 00 46 80 00       	push   $0x804600
  800058:	e8 9f 0b 00 00       	call   800bfc <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 02 46 80 00       	push   $0x804602
  800068:	e8 8f 0b 00 00       	call   800bfc <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 18 46 80 00       	push   $0x804618
  800078:	e8 7f 0b 00 00       	call   800bfc <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 02 46 80 00       	push   $0x804602
  800088:	e8 6f 0b 00 00       	call   800bfc <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 00 46 80 00       	push   $0x804600
  800098:	e8 5f 0b 00 00       	call   800bfc <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 30 46 80 00       	push   $0x804630
  8000a8:	e8 4f 0b 00 00       	call   800bfc <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 4f 46 80 00       	push   $0x80464f
  8000d7:	e8 20 0b 00 00       	call   800bfc <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 d0 1a 00 00       	call   801bbe <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 54 46 80 00       	push   $0x804654
  8000fc:	e8 fb 0a 00 00       	call   800bfc <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 76 46 80 00       	push   $0x804676
  80010c:	e8 eb 0a 00 00       	call   800bfc <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 84 46 80 00       	push   $0x804684
  80011c:	e8 db 0a 00 00       	call   800bfc <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 93 46 80 00       	push   $0x804693
  80012c:	e8 cb 0a 00 00       	call   800bfc <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 a3 46 80 00       	push   $0x8046a3
  80013c:	e8 bb 0a 00 00       	call   800bfc <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 db 05 00 00       	call   800742 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 ce 05 00 00       	call   800742 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_unlock_cons();
  800189:	e8 42 32 00 00       	call   8033d0 <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f9 01 00 00       	call   8003a8 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 17 02 00 00       	call   8003d9 <InitializeIdentical>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 39 02 00 00       	call   80040e <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 26 02 00 00       	call   80040e <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 f2 02 00 00       	call   8004ed <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001fe:	e8 b3 31 00 00       	call   8033b6 <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 ac 46 80 00       	push   $0x8046ac
  80020b:	e8 ec 09 00 00       	call   800bfc <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  800213:	e8 b8 31 00 00       	call   8033d0 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d8 00 00 00       	call   8002fe <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 e0 46 80 00       	push   $0x8046e0
  80023a:	6a 58                	push   $0x58
  80023c:	68 02 47 80 00       	push   $0x804702
  800241:	e8 e8 06 00 00       	call   80092e <_panic>
		else
		{
			sys_lock_cons();
  800246:	e8 6b 31 00 00       	call   8033b6 <sys_lock_cons>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 20 47 80 00       	push   $0x804720
  800253:	e8 a4 09 00 00       	call   800bfc <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 54 47 80 00       	push   $0x804754
  800263:	e8 94 09 00 00       	call   800bfc <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 88 47 80 00       	push   $0x804788
  800273:	e8 84 09 00 00       	call   800bfc <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80027b:	e8 50 31 00 00       	call   8033d0 <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  800280:	e8 31 31 00 00       	call   8033b6 <sys_lock_cons>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 ba 47 80 00       	push   $0x8047ba
  800293:	e8 64 09 00 00       	call   800bfc <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 84 04 00 00       	call   800742 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 77 04 00 00       	call   800742 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 6a 04 00 00       	call   800742 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  8002e7:	e8 e4 30 00 00       	call   8033d0 <sys_unlock_cons>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  8002f6:	e8 72 34 00 00       	call   80376d <inctst>

}
  8002fb:	90                   	nop
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800304:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800312:	eb 33                	jmp    800347 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800314:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	8b 10                	mov    (%eax),%edx
  800325:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800328:	40                   	inc    %eax
  800329:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 c8                	add    %ecx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	7e 09                	jle    800344 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80033b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800342:	eb 0c                	jmp    800350 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800344:	ff 45 f8             	incl   -0x8(%ebp)
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	48                   	dec    %eax
  80034b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80034e:	7f c4                	jg     800314 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800350:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80035b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	01 c2                	add    %eax,%edx
  80037e:	8b 45 10             	mov    0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800391:	8b 45 10             	mov    0x10(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a3:	89 02                	mov    %eax,(%edx)
}
  8003a5:	90                   	nop
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b5:	eb 17                	jmp    8003ce <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	01 c2                	add    %eax,%edx
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c e1                	jl     8003b7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e6:	eb 1b                	jmp    800403 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c2                	add    %eax,%edx
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003fd:	48                   	dec    %eax
  8003fe:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	ff 45 fc             	incl   -0x4(%ebp)
  800403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800406:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800409:	7c dd                	jl     8003e8 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80040b:	90                   	nop
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800414:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800417:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80041c:	f7 e9                	imul   %ecx
  80041e:	c1 f9 1f             	sar    $0x1f,%ecx
  800421:	89 d0                	mov    %edx,%eax
  800423:	29 c8                	sub    %ecx,%eax
  800425:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800428:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80042c:	75 07                	jne    800435 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80042e:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80043c:	eb 1e                	jmp    80045c <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80043e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80044e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800451:	99                   	cltd   
  800452:	f7 7d f8             	idivl  -0x8(%ebp)
  800455:	89 d0                	mov    %edx,%eax
  800457:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800459:	ff 45 fc             	incl   -0x4(%ebp)
  80045c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80045f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800462:	7c da                	jl     80043e <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800464:	90                   	nop
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80046d:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80047b:	eb 42                	jmp    8004bf <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80047d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800480:	99                   	cltd   
  800481:	f7 7d f0             	idivl  -0x10(%ebp)
  800484:	89 d0                	mov    %edx,%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	75 10                	jne    80049a <PrintElements+0x33>
			cprintf("\n");
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	68 00 46 80 00       	push   $0x804600
  800492:	e8 65 07 00 00       	call   800bfc <cprintf>
  800497:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	50                   	push   %eax
  8004af:	68 d8 47 80 00       	push   $0x8047d8
  8004b4:	e8 43 07 00 00       	call   800bfc <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004bc:	ff 45 f4             	incl   -0xc(%ebp)
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	48                   	dec    %eax
  8004c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004c6:	7f b5                	jg     80047d <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	50                   	push   %eax
  8004dd:	68 4f 46 80 00       	push   $0x80464f
  8004e2:	e8 15 07 00 00       	call   800bfc <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp

}
  8004ea:	90                   	nop
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <MSort>:


void MSort(int* A, int p, int r)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004f9:	7d 54                	jge    80054f <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	c1 ea 1f             	shr    $0x1f,%edx
  800508:	01 d0                	add    %edx,%eax
  80050a:	d1 f8                	sar    %eax
  80050c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	ff 75 f4             	pushl  -0xc(%ebp)
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	ff 75 08             	pushl  0x8(%ebp)
  80051b:	e8 cd ff ff ff       	call   8004ed <MSort>
  800520:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800526:	40                   	inc    %eax
  800527:	83 ec 04             	sub    $0x4,%esp
  80052a:	ff 75 10             	pushl  0x10(%ebp)
  80052d:	50                   	push   %eax
  80052e:	ff 75 08             	pushl  0x8(%ebp)
  800531:	e8 b7 ff ff ff       	call   8004ed <MSort>
  800536:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800539:	ff 75 10             	pushl  0x10(%ebp)
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	ff 75 0c             	pushl  0xc(%ebp)
  800542:	ff 75 08             	pushl  0x8(%ebp)
  800545:	e8 08 00 00 00       	call   800552 <Merge>
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	eb 01                	jmp    800550 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80054f:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800558:	8b 45 10             	mov    0x10(%ebp),%eax
  80055b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80055e:	40                   	inc    %eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	2b 45 10             	sub    0x10(%ebp),%eax
  800568:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  80056b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800572:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057c:	c1 e0 02             	shl    $0x2,%eax
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	50                   	push   %eax
  800583:	e8 36 16 00 00       	call   801bbe <malloc>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80058e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800591:	c1 e0 02             	shl    $0x2,%eax
  800594:	83 ec 0c             	sub    $0xc,%esp
  800597:	50                   	push   %eax
  800598:	e8 21 16 00 00       	call   801bbe <malloc>
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8005aa:	eb 2f                	jmp    8005db <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b9:	01 c2                	add    %eax,%edx
  8005bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c1:	01 c8                	add    %ecx,%eax
  8005c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005c8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	01 c8                	add    %ecx,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005d8:	ff 45 ec             	incl   -0x14(%ebp)
  8005db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e1:	7c c9                	jl     8005ac <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005ea:	eb 2a                	jmp    800616 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f9:	01 c2                	add    %eax,%edx
  8005fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800601:	01 c8                	add    %ecx,%eax
  800603:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	01 c8                	add    %ecx,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800613:	ff 45 e8             	incl   -0x18(%ebp)
  800616:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	7c ce                	jl     8005ec <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80061e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800624:	e9 0a 01 00 00       	jmp    800733 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80062f:	0f 8d 95 00 00 00    	jge    8006ca <Merge+0x178>
  800635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800638:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80063b:	0f 8d 89 00 00 00    	jge    8006ca <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 10                	mov    (%eax),%edx
  800652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800655:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80065f:	01 c8                	add    %ecx,%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	39 c2                	cmp    %eax,%edx
  800665:	7d 33                	jge    80069a <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80066a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	8d 50 01             	lea    0x1(%eax),%edx
  800682:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800685:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80068f:	01 d0                	add    %edx,%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800695:	e9 96 00 00 00       	jmp    800730 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069d:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006c2:	01 d0                	add    %edx,%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006c8:	eb 66                	jmp    800730 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006d0:	7d 30                	jge    800702 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d5:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ea:	8d 50 01             	lea    0x1(%eax),%edx
  8006ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	89 01                	mov    %eax,(%ecx)
  800700:	eb 2e                	jmp    800730 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800705:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80070a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071a:	8d 50 01             	lea    0x1(%eax),%edx
  80071d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800720:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800727:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072a:	01 d0                	add    %edx,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800730:	ff 45 e4             	incl   -0x1c(%ebp)
  800733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800736:	3b 45 14             	cmp    0x14(%ebp),%eax
  800739:	0f 8e ea fe ff ff    	jle    800629 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80073f:	90                   	nop
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80074e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	50                   	push   %eax
  800756:	e8 a3 2d 00 00       	call   8034fe <sys_cputc>
  80075b:	83 c4 10             	add    $0x10,%esp
}
  80075e:	90                   	nop
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <getchar>:


int
getchar(void)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800767:	e8 31 2c 00 00       	call   80339d <sys_cgetc>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80076f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <iscons>:

int iscons(int fdnum)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800777:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	57                   	push   %edi
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
  800784:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800787:	e8 a3 2e 00 00       	call   80362f <sys_getenvindex>
  80078c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80078f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 03             	shl    $0x3,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	c1 e0 02             	shl    $0x2,%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	c1 e0 03             	shl    $0x3,%eax
  8007aa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007af:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007b4:	a1 24 60 80 00       	mov    0x806024,%eax
  8007b9:	8a 40 20             	mov    0x20(%eax),%al
  8007bc:	84 c0                	test   %al,%al
  8007be:	74 0d                	je     8007cd <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007c0:	a1 24 60 80 00       	mov    0x806024,%eax
  8007c5:	83 c0 20             	add    $0x20,%eax
  8007c8:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007d1:	7e 0a                	jle    8007dd <libmain+0x5f>
		binaryname = argv[0];
  8007d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	ff 75 08             	pushl  0x8(%ebp)
  8007e6:	e8 4d f8 ff ff       	call   800038 <_main>
  8007eb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007ee:	a1 00 60 80 00       	mov    0x806000,%eax
  8007f3:	85 c0                	test   %eax,%eax
  8007f5:	0f 84 01 01 00 00    	je     8008fc <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007fb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800801:	bb d8 48 80 00       	mov    $0x8048d8,%ebx
  800806:	ba 0e 00 00 00       	mov    $0xe,%edx
  80080b:	89 c7                	mov    %eax,%edi
  80080d:	89 de                	mov    %ebx,%esi
  80080f:	89 d1                	mov    %edx,%ecx
  800811:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800813:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800816:	b9 56 00 00 00       	mov    $0x56,%ecx
  80081b:	b0 00                	mov    $0x0,%al
  80081d:	89 d7                	mov    %edx,%edi
  80081f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800821:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800828:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	50                   	push   %eax
  80082f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800835:	50                   	push   %eax
  800836:	e8 2a 30 00 00       	call   803865 <sys_utilities>
  80083b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80083e:	e8 73 2b 00 00       	call   8033b6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800843:	83 ec 0c             	sub    $0xc,%esp
  800846:	68 f8 47 80 00       	push   $0x8047f8
  80084b:	e8 ac 03 00 00       	call   800bfc <cprintf>
  800850:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	85 c0                	test   %eax,%eax
  800858:	74 18                	je     800872 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80085a:	e8 24 30 00 00       	call   803883 <sys_get_optimal_num_faults>
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	50                   	push   %eax
  800863:	68 20 48 80 00       	push   $0x804820
  800868:	e8 8f 03 00 00       	call   800bfc <cprintf>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	eb 59                	jmp    8008cb <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800872:	a1 24 60 80 00       	mov    0x806024,%eax
  800877:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80087d:	a1 24 60 80 00       	mov    0x806024,%eax
  800882:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800888:	83 ec 04             	sub    $0x4,%esp
  80088b:	52                   	push   %edx
  80088c:	50                   	push   %eax
  80088d:	68 44 48 80 00       	push   $0x804844
  800892:	e8 65 03 00 00       	call   800bfc <cprintf>
  800897:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80089a:	a1 24 60 80 00       	mov    0x806024,%eax
  80089f:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8008a5:	a1 24 60 80 00       	mov    0x806024,%eax
  8008aa:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8008b0:	a1 24 60 80 00       	mov    0x806024,%eax
  8008b5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8008bb:	51                   	push   %ecx
  8008bc:	52                   	push   %edx
  8008bd:	50                   	push   %eax
  8008be:	68 6c 48 80 00       	push   $0x80486c
  8008c3:	e8 34 03 00 00       	call   800bfc <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008cb:	a1 24 60 80 00       	mov    0x806024,%eax
  8008d0:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	50                   	push   %eax
  8008da:	68 c4 48 80 00       	push   $0x8048c4
  8008df:	e8 18 03 00 00       	call   800bfc <cprintf>
  8008e4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	68 f8 47 80 00       	push   $0x8047f8
  8008ef:	e8 08 03 00 00       	call   800bfc <cprintf>
  8008f4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008f7:	e8 d4 2a 00 00       	call   8033d0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008fc:	e8 1f 00 00 00       	call   800920 <exit>
}
  800901:	90                   	nop
  800902:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800905:	5b                   	pop    %ebx
  800906:	5e                   	pop    %esi
  800907:	5f                   	pop    %edi
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	6a 00                	push   $0x0
  800915:	e8 e1 2c 00 00       	call   8035fb <sys_destroy_env>
  80091a:	83 c4 10             	add    $0x10,%esp
}
  80091d:	90                   	nop
  80091e:	c9                   	leave  
  80091f:	c3                   	ret    

00800920 <exit>:

void
exit(void)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800926:	e8 36 2d 00 00       	call   803661 <sys_exit_env>
}
  80092b:	90                   	nop
  80092c:	c9                   	leave  
  80092d:	c3                   	ret    

0080092e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800934:	8d 45 10             	lea    0x10(%ebp),%eax
  800937:	83 c0 04             	add    $0x4,%eax
  80093a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80093d:	a1 38 61 83 00       	mov    0x836138,%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 16                	je     80095c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800946:	a1 38 61 83 00       	mov    0x836138,%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	50                   	push   %eax
  80094f:	68 3c 49 80 00       	push   $0x80493c
  800954:	e8 a3 02 00 00       	call   800bfc <cprintf>
  800959:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80095c:	a1 04 60 80 00       	mov    0x806004,%eax
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	50                   	push   %eax
  80096b:	68 44 49 80 00       	push   $0x804944
  800970:	6a 74                	push   $0x74
  800972:	e8 b2 02 00 00       	call   800c29 <cprintf_colored>
  800977:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80097a:	8b 45 10             	mov    0x10(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 04 02 00 00       	call   800b8d <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	6a 00                	push   $0x0
  800991:	68 6c 49 80 00       	push   $0x80496c
  800996:	e8 f2 01 00 00       	call   800b8d <vcprintf>
  80099b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80099e:	e8 7d ff ff ff       	call   800920 <exit>

	// should not return here
	while (1) ;
  8009a3:	eb fe                	jmp    8009a3 <_panic+0x75>

008009a5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009ab:	a1 24 60 80 00       	mov    0x806024,%eax
  8009b0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	39 c2                	cmp    %eax,%edx
  8009bb:	74 14                	je     8009d1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009bd:	83 ec 04             	sub    $0x4,%esp
  8009c0:	68 70 49 80 00       	push   $0x804970
  8009c5:	6a 26                	push   $0x26
  8009c7:	68 bc 49 80 00       	push   $0x8049bc
  8009cc:	e8 5d ff ff ff       	call   80092e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009df:	e9 c5 00 00 00       	jmp    800aa9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	01 d0                	add    %edx,%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	85 c0                	test   %eax,%eax
  8009f7:	75 08                	jne    800a01 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009f9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009fc:	e9 a5 00 00 00       	jmp    800aa6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a01:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a08:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a0f:	eb 69                	jmp    800a7a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a11:	a1 24 60 80 00       	mov    0x806024,%eax
  800a16:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a1f:	89 d0                	mov    %edx,%eax
  800a21:	01 c0                	add    %eax,%eax
  800a23:	01 d0                	add    %edx,%eax
  800a25:	c1 e0 03             	shl    $0x3,%eax
  800a28:	01 c8                	add    %ecx,%eax
  800a2a:	8a 40 04             	mov    0x4(%eax),%al
  800a2d:	84 c0                	test   %al,%al
  800a2f:	75 46                	jne    800a77 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a31:	a1 24 60 80 00       	mov    0x806024,%eax
  800a36:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a3f:	89 d0                	mov    %edx,%eax
  800a41:	01 c0                	add    %eax,%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	c1 e0 03             	shl    $0x3,%eax
  800a48:	01 c8                	add    %ecx,%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a57:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	01 c8                	add    %ecx,%eax
  800a68:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	75 09                	jne    800a77 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a6e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a75:	eb 15                	jmp    800a8c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a77:	ff 45 e8             	incl   -0x18(%ebp)
  800a7a:	a1 24 60 80 00       	mov    0x806024,%eax
  800a7f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a88:	39 c2                	cmp    %eax,%edx
  800a8a:	77 85                	ja     800a11 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a90:	75 14                	jne    800aa6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a92:	83 ec 04             	sub    $0x4,%esp
  800a95:	68 c8 49 80 00       	push   $0x8049c8
  800a9a:	6a 3a                	push   $0x3a
  800a9c:	68 bc 49 80 00       	push   $0x8049bc
  800aa1:	e8 88 fe ff ff       	call   80092e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800aa6:	ff 45 f0             	incl   -0x10(%ebp)
  800aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800aaf:	0f 8c 2f ff ff ff    	jl     8009e4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ab5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ac3:	eb 26                	jmp    800aeb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ac5:	a1 24 60 80 00       	mov    0x806024,%eax
  800aca:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800ad0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ad3:	89 d0                	mov    %edx,%eax
  800ad5:	01 c0                	add    %eax,%eax
  800ad7:	01 d0                	add    %edx,%eax
  800ad9:	c1 e0 03             	shl    $0x3,%eax
  800adc:	01 c8                	add    %ecx,%eax
  800ade:	8a 40 04             	mov    0x4(%eax),%al
  800ae1:	3c 01                	cmp    $0x1,%al
  800ae3:	75 03                	jne    800ae8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800ae5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae8:	ff 45 e0             	incl   -0x20(%ebp)
  800aeb:	a1 24 60 80 00       	mov    0x806024,%eax
  800af0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af9:	39 c2                	cmp    %eax,%edx
  800afb:	77 c8                	ja     800ac5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b00:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b03:	74 14                	je     800b19 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b05:	83 ec 04             	sub    $0x4,%esp
  800b08:	68 1c 4a 80 00       	push   $0x804a1c
  800b0d:	6a 44                	push   $0x44
  800b0f:	68 bc 49 80 00       	push   $0x8049bc
  800b14:	e8 15 fe ff ff       	call   80092e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b19:	90                   	nop
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	53                   	push   %ebx
  800b20:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	8d 48 01             	lea    0x1(%eax),%ecx
  800b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2e:	89 0a                	mov    %ecx,(%edx)
  800b30:	8b 55 08             	mov    0x8(%ebp),%edx
  800b33:	88 d1                	mov    %dl,%cl
  800b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b38:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b46:	75 30                	jne    800b78 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b48:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800b4e:	a0 64 e0 81 00       	mov    0x81e064,%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b59:	8b 09                	mov    (%ecx),%ecx
  800b5b:	89 cb                	mov    %ecx,%ebx
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b60:	83 c1 08             	add    $0x8,%ecx
  800b63:	52                   	push   %edx
  800b64:	50                   	push   %eax
  800b65:	53                   	push   %ebx
  800b66:	51                   	push   %ecx
  800b67:	e8 06 28 00 00       	call   803372 <sys_cputs>
  800b6c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	8b 40 04             	mov    0x4(%eax),%eax
  800b7e:	8d 50 01             	lea    0x1(%eax),%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b87:	90                   	nop
  800b88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b9d:	00 00 00 
	b.cnt = 0;
  800ba0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ba7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	ff 75 08             	pushl  0x8(%ebp)
  800bb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bb6:	50                   	push   %eax
  800bb7:	68 1c 0b 80 00       	push   $0x800b1c
  800bbc:	e8 5a 02 00 00       	call   800e1b <vprintfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bc4:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800bca:	a0 64 e0 81 00       	mov    0x81e064,%al
  800bcf:	0f b6 c0             	movzbl %al,%eax
  800bd2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	51                   	push   %ecx
  800bdb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800be1:	83 c0 08             	add    $0x8,%eax
  800be4:	50                   	push   %eax
  800be5:	e8 88 27 00 00       	call   803372 <sys_cputs>
  800bea:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bed:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800bf4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c02:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800c09:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 f4             	pushl  -0xc(%ebp)
  800c18:	50                   	push   %eax
  800c19:	e8 6f ff ff ff       	call   800b8d <vcprintf>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c2f:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	c1 e0 08             	shl    $0x8,%eax
  800c3c:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800c41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c44:	83 c0 04             	add    $0x4,%eax
  800c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	ff 75 f4             	pushl  -0xc(%ebp)
  800c53:	50                   	push   %eax
  800c54:	e8 34 ff ff ff       	call   800b8d <vcprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c5f:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800c66:	07 00 00 

	return cnt;
  800c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c74:	e8 3d 27 00 00       	call   8033b6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c79:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	83 ec 08             	sub    $0x8,%esp
  800c85:	ff 75 f4             	pushl  -0xc(%ebp)
  800c88:	50                   	push   %eax
  800c89:	e8 ff fe ff ff       	call   800b8d <vcprintf>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c94:	e8 37 27 00 00       	call   8033d0 <sys_unlock_cons>
	return cnt;
  800c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	53                   	push   %ebx
  800ca2:	83 ec 14             	sub    $0x14,%esp
  800ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cb1:	8b 45 18             	mov    0x18(%ebp),%eax
  800cb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cbc:	77 55                	ja     800d13 <printnum+0x75>
  800cbe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc1:	72 05                	jb     800cc8 <printnum+0x2a>
  800cc3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cc6:	77 4b                	ja     800d13 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cc8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ccb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cce:	8b 45 18             	mov    0x18(%ebp),%eax
  800cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd6:	52                   	push   %edx
  800cd7:	50                   	push   %eax
  800cd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cdb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cde:	e8 a5 36 00 00       	call   804388 <__udivdi3>
  800ce3:	83 c4 10             	add    $0x10,%esp
  800ce6:	83 ec 04             	sub    $0x4,%esp
  800ce9:	ff 75 20             	pushl  0x20(%ebp)
  800cec:	53                   	push   %ebx
  800ced:	ff 75 18             	pushl  0x18(%ebp)
  800cf0:	52                   	push   %edx
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 0c             	pushl  0xc(%ebp)
  800cf5:	ff 75 08             	pushl  0x8(%ebp)
  800cf8:	e8 a1 ff ff ff       	call   800c9e <printnum>
  800cfd:	83 c4 20             	add    $0x20,%esp
  800d00:	eb 1a                	jmp    800d1c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	ff 75 20             	pushl  0x20(%ebp)
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	ff d0                	call   *%eax
  800d10:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d13:	ff 4d 1c             	decl   0x1c(%ebp)
  800d16:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d1a:	7f e6                	jg     800d02 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d1c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d2a:	53                   	push   %ebx
  800d2b:	51                   	push   %ecx
  800d2c:	52                   	push   %edx
  800d2d:	50                   	push   %eax
  800d2e:	e8 65 37 00 00       	call   804498 <__umoddi3>
  800d33:	83 c4 10             	add    $0x10,%esp
  800d36:	05 94 4c 80 00       	add    $0x804c94,%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f be c0             	movsbl %al,%eax
  800d40:	83 ec 08             	sub    $0x8,%esp
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	50                   	push   %eax
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	ff d0                	call   *%eax
  800d4c:	83 c4 10             	add    $0x10,%esp
}
  800d4f:	90                   	nop
  800d50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d5c:	7e 1c                	jle    800d7a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8b 00                	mov    (%eax),%eax
  800d63:	8d 50 08             	lea    0x8(%eax),%edx
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	89 10                	mov    %edx,(%eax)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8b 00                	mov    (%eax),%eax
  800d70:	83 e8 08             	sub    $0x8,%eax
  800d73:	8b 50 04             	mov    0x4(%eax),%edx
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	eb 40                	jmp    800dba <getuint+0x65>
	else if (lflag)
  800d7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7e:	74 1e                	je     800d9e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9c:	eb 1c                	jmp    800dba <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	8d 50 04             	lea    0x4(%eax),%edx
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	89 10                	mov    %edx,(%eax)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	83 e8 04             	sub    $0x4,%eax
  800db3:	8b 00                	mov    (%eax),%eax
  800db5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dbf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dc3:	7e 1c                	jle    800de1 <getint+0x25>
		return va_arg(*ap, long long);
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	8d 50 08             	lea    0x8(%eax),%edx
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 10                	mov    %edx,(%eax)
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8b 00                	mov    (%eax),%eax
  800dd7:	83 e8 08             	sub    $0x8,%eax
  800dda:	8b 50 04             	mov    0x4(%eax),%edx
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	eb 38                	jmp    800e19 <getint+0x5d>
	else if (lflag)
  800de1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de5:	74 1a                	je     800e01 <getint+0x45>
		return va_arg(*ap, long);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	8d 50 04             	lea    0x4(%eax),%edx
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 10                	mov    %edx,(%eax)
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8b 00                	mov    (%eax),%eax
  800df9:	83 e8 04             	sub    $0x4,%eax
  800dfc:	8b 00                	mov    (%eax),%eax
  800dfe:	99                   	cltd   
  800dff:	eb 18                	jmp    800e19 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	8d 50 04             	lea    0x4(%eax),%edx
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	89 10                	mov    %edx,(%eax)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	83 e8 04             	sub    $0x4,%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	99                   	cltd   
}
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e23:	eb 17                	jmp    800e3c <vprintfmt+0x21>
			if (ch == '\0')
  800e25:	85 db                	test   %ebx,%ebx
  800e27:	0f 84 c1 03 00 00    	je     8011ee <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	53                   	push   %ebx
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	8d 50 01             	lea    0x1(%eax),%edx
  800e42:	89 55 10             	mov    %edx,0x10(%ebp)
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d8             	movzbl %al,%ebx
  800e4a:	83 fb 25             	cmp    $0x25,%ebx
  800e4d:	75 d6                	jne    800e25 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e4f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e53:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e5a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e61:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e68:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 10             	mov    %edx,0x10(%ebp)
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	0f b6 d8             	movzbl %al,%ebx
  800e7d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e80:	83 f8 5b             	cmp    $0x5b,%eax
  800e83:	0f 87 3d 03 00 00    	ja     8011c6 <vprintfmt+0x3ab>
  800e89:	8b 04 85 b8 4c 80 00 	mov    0x804cb8(,%eax,4),%eax
  800e90:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e92:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e96:	eb d7                	jmp    800e6f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e98:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e9c:	eb d1                	jmp    800e6f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e9e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ea5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ea8:	89 d0                	mov    %edx,%eax
  800eaa:	c1 e0 02             	shl    $0x2,%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	01 c0                	add    %eax,%eax
  800eb1:	01 d8                	add    %ebx,%eax
  800eb3:	83 e8 30             	sub    $0x30,%eax
  800eb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ec1:	83 fb 2f             	cmp    $0x2f,%ebx
  800ec4:	7e 3e                	jle    800f04 <vprintfmt+0xe9>
  800ec6:	83 fb 39             	cmp    $0x39,%ebx
  800ec9:	7f 39                	jg     800f04 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ecb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ece:	eb d5                	jmp    800ea5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed3:	83 c0 04             	add    $0x4,%eax
  800ed6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  800edc:	83 e8 04             	sub    $0x4,%eax
  800edf:	8b 00                	mov    (%eax),%eax
  800ee1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ee4:	eb 1f                	jmp    800f05 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ee6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eea:	79 83                	jns    800e6f <vprintfmt+0x54>
				width = 0;
  800eec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ef3:	e9 77 ff ff ff       	jmp    800e6f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ef8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eff:	e9 6b ff ff ff       	jmp    800e6f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f04:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f09:	0f 89 60 ff ff ff    	jns    800e6f <vprintfmt+0x54>
				width = precision, precision = -1;
  800f0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f15:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f1c:	e9 4e ff ff ff       	jmp    800e6f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f21:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f24:	e9 46 ff ff ff       	jmp    800e6f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f29:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2c:	83 c0 04             	add    $0x4,%eax
  800f2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f32:	8b 45 14             	mov    0x14(%ebp),%eax
  800f35:	83 e8 04             	sub    $0x4,%eax
  800f38:	8b 00                	mov    (%eax),%eax
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	50                   	push   %eax
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			break;
  800f49:	e9 9b 02 00 00       	jmp    8011e9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f51:	83 c0 04             	add    $0x4,%eax
  800f54:	89 45 14             	mov    %eax,0x14(%ebp)
  800f57:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5a:	83 e8 04             	sub    $0x4,%eax
  800f5d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f5f:	85 db                	test   %ebx,%ebx
  800f61:	79 02                	jns    800f65 <vprintfmt+0x14a>
				err = -err;
  800f63:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f65:	83 fb 64             	cmp    $0x64,%ebx
  800f68:	7f 0b                	jg     800f75 <vprintfmt+0x15a>
  800f6a:	8b 34 9d 00 4b 80 00 	mov    0x804b00(,%ebx,4),%esi
  800f71:	85 f6                	test   %esi,%esi
  800f73:	75 19                	jne    800f8e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f75:	53                   	push   %ebx
  800f76:	68 a5 4c 80 00       	push   $0x804ca5
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	ff 75 08             	pushl  0x8(%ebp)
  800f81:	e8 70 02 00 00       	call   8011f6 <printfmt>
  800f86:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f89:	e9 5b 02 00 00       	jmp    8011e9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f8e:	56                   	push   %esi
  800f8f:	68 ae 4c 80 00       	push   $0x804cae
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	ff 75 08             	pushl  0x8(%ebp)
  800f9a:	e8 57 02 00 00       	call   8011f6 <printfmt>
  800f9f:	83 c4 10             	add    $0x10,%esp
			break;
  800fa2:	e9 42 02 00 00       	jmp    8011e9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800faa:	83 c0 04             	add    $0x4,%eax
  800fad:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb3:	83 e8 04             	sub    $0x4,%eax
  800fb6:	8b 30                	mov    (%eax),%esi
  800fb8:	85 f6                	test   %esi,%esi
  800fba:	75 05                	jne    800fc1 <vprintfmt+0x1a6>
				p = "(null)";
  800fbc:	be b1 4c 80 00       	mov    $0x804cb1,%esi
			if (width > 0 && padc != '-')
  800fc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc5:	7e 6d                	jle    801034 <vprintfmt+0x219>
  800fc7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fcb:	74 67                	je     801034 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	50                   	push   %eax
  800fd4:	56                   	push   %esi
  800fd5:	e8 1e 03 00 00       	call   8012f8 <strnlen>
  800fda:	83 c4 10             	add    $0x10,%esp
  800fdd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fe0:	eb 16                	jmp    800ff8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fe2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fe6:	83 ec 08             	sub    $0x8,%esp
  800fe9:	ff 75 0c             	pushl  0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	ff d0                	call   *%eax
  800ff2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ff5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ff8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ffc:	7f e4                	jg     800fe2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ffe:	eb 34                	jmp    801034 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801000:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801004:	74 1c                	je     801022 <vprintfmt+0x207>
  801006:	83 fb 1f             	cmp    $0x1f,%ebx
  801009:	7e 05                	jle    801010 <vprintfmt+0x1f5>
  80100b:	83 fb 7e             	cmp    $0x7e,%ebx
  80100e:	7e 12                	jle    801022 <vprintfmt+0x207>
					putch('?', putdat);
  801010:	83 ec 08             	sub    $0x8,%esp
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	6a 3f                	push   $0x3f
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	ff d0                	call   *%eax
  80101d:	83 c4 10             	add    $0x10,%esp
  801020:	eb 0f                	jmp    801031 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801022:	83 ec 08             	sub    $0x8,%esp
  801025:	ff 75 0c             	pushl  0xc(%ebp)
  801028:	53                   	push   %ebx
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	ff d0                	call   *%eax
  80102e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801031:	ff 4d e4             	decl   -0x1c(%ebp)
  801034:	89 f0                	mov    %esi,%eax
  801036:	8d 70 01             	lea    0x1(%eax),%esi
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f be d8             	movsbl %al,%ebx
  80103e:	85 db                	test   %ebx,%ebx
  801040:	74 24                	je     801066 <vprintfmt+0x24b>
  801042:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801046:	78 b8                	js     801000 <vprintfmt+0x1e5>
  801048:	ff 4d e0             	decl   -0x20(%ebp)
  80104b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80104f:	79 af                	jns    801000 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801051:	eb 13                	jmp    801066 <vprintfmt+0x24b>
				putch(' ', putdat);
  801053:	83 ec 08             	sub    $0x8,%esp
  801056:	ff 75 0c             	pushl  0xc(%ebp)
  801059:	6a 20                	push   $0x20
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	ff d0                	call   *%eax
  801060:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801063:	ff 4d e4             	decl   -0x1c(%ebp)
  801066:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106a:	7f e7                	jg     801053 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80106c:	e9 78 01 00 00       	jmp    8011e9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801071:	83 ec 08             	sub    $0x8,%esp
  801074:	ff 75 e8             	pushl  -0x18(%ebp)
  801077:	8d 45 14             	lea    0x14(%ebp),%eax
  80107a:	50                   	push   %eax
  80107b:	e8 3c fd ff ff       	call   800dbc <getint>
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801086:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108f:	85 d2                	test   %edx,%edx
  801091:	79 23                	jns    8010b6 <vprintfmt+0x29b>
				putch('-', putdat);
  801093:	83 ec 08             	sub    $0x8,%esp
  801096:	ff 75 0c             	pushl  0xc(%ebp)
  801099:	6a 2d                	push   $0x2d
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	ff d0                	call   *%eax
  8010a0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a9:	f7 d8                	neg    %eax
  8010ab:	83 d2 00             	adc    $0x0,%edx
  8010ae:	f7 da                	neg    %edx
  8010b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010b6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010bd:	e9 bc 00 00 00       	jmp    80117e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 e8             	pushl  -0x18(%ebp)
  8010c8:	8d 45 14             	lea    0x14(%ebp),%eax
  8010cb:	50                   	push   %eax
  8010cc:	e8 84 fc ff ff       	call   800d55 <getuint>
  8010d1:	83 c4 10             	add    $0x10,%esp
  8010d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010da:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010e1:	e9 98 00 00 00       	jmp    80117e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	6a 58                	push   $0x58
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	ff d0                	call   *%eax
  8010f3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	6a 58                	push   $0x58
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	ff d0                	call   *%eax
  801103:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801106:	83 ec 08             	sub    $0x8,%esp
  801109:	ff 75 0c             	pushl  0xc(%ebp)
  80110c:	6a 58                	push   $0x58
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	ff d0                	call   *%eax
  801113:	83 c4 10             	add    $0x10,%esp
			break;
  801116:	e9 ce 00 00 00       	jmp    8011e9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 30                	push   $0x30
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	ff 75 0c             	pushl  0xc(%ebp)
  801131:	6a 78                	push   $0x78
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	ff d0                	call   *%eax
  801138:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80113b:	8b 45 14             	mov    0x14(%ebp),%eax
  80113e:	83 c0 04             	add    $0x4,%eax
  801141:	89 45 14             	mov    %eax,0x14(%ebp)
  801144:	8b 45 14             	mov    0x14(%ebp),%eax
  801147:	83 e8 04             	sub    $0x4,%eax
  80114a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80114c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801156:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80115d:	eb 1f                	jmp    80117e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80115f:	83 ec 08             	sub    $0x8,%esp
  801162:	ff 75 e8             	pushl  -0x18(%ebp)
  801165:	8d 45 14             	lea    0x14(%ebp),%eax
  801168:	50                   	push   %eax
  801169:	e8 e7 fb ff ff       	call   800d55 <getuint>
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801174:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801177:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80117e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801185:	83 ec 04             	sub    $0x4,%esp
  801188:	52                   	push   %edx
  801189:	ff 75 e4             	pushl  -0x1c(%ebp)
  80118c:	50                   	push   %eax
  80118d:	ff 75 f4             	pushl  -0xc(%ebp)
  801190:	ff 75 f0             	pushl  -0x10(%ebp)
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	ff 75 08             	pushl  0x8(%ebp)
  801199:	e8 00 fb ff ff       	call   800c9e <printnum>
  80119e:	83 c4 20             	add    $0x20,%esp
			break;
  8011a1:	eb 46                	jmp    8011e9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	53                   	push   %ebx
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	ff d0                	call   *%eax
  8011af:	83 c4 10             	add    $0x10,%esp
			break;
  8011b2:	eb 35                	jmp    8011e9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011b4:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  8011bb:	eb 2c                	jmp    8011e9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011bd:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  8011c4:	eb 23                	jmp    8011e9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	ff 75 0c             	pushl  0xc(%ebp)
  8011cc:	6a 25                	push   $0x25
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	ff d0                	call   *%eax
  8011d3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d6:	ff 4d 10             	decl   0x10(%ebp)
  8011d9:	eb 03                	jmp    8011de <vprintfmt+0x3c3>
  8011db:	ff 4d 10             	decl   0x10(%ebp)
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	3c 25                	cmp    $0x25,%al
  8011e6:	75 f3                	jne    8011db <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011e8:	90                   	nop
		}
	}
  8011e9:	e9 35 fc ff ff       	jmp    800e23 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011ee:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f2:	5b                   	pop    %ebx
  8011f3:	5e                   	pop    %esi
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011fc:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ff:	83 c0 04             	add    $0x4,%eax
  801202:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801205:	8b 45 10             	mov    0x10(%ebp),%eax
  801208:	ff 75 f4             	pushl  -0xc(%ebp)
  80120b:	50                   	push   %eax
  80120c:	ff 75 0c             	pushl  0xc(%ebp)
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 04 fc ff ff       	call   800e1b <vprintfmt>
  801217:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121a:	90                   	nop
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	8b 40 08             	mov    0x8(%eax),%eax
  801226:	8d 50 01             	lea    0x1(%eax),%edx
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	8b 10                	mov    (%eax),%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	8b 40 04             	mov    0x4(%eax),%eax
  80123a:	39 c2                	cmp    %eax,%edx
  80123c:	73 12                	jae    801250 <sprintputch+0x33>
		*b->buf++ = ch;
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	8d 48 01             	lea    0x1(%eax),%ecx
  801246:	8b 55 0c             	mov    0xc(%ebp),%edx
  801249:	89 0a                	mov    %ecx,(%edx)
  80124b:	8b 55 08             	mov    0x8(%ebp),%edx
  80124e:	88 10                	mov    %dl,(%eax)
}
  801250:	90                   	nop
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801274:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801278:	74 06                	je     801280 <vsnprintf+0x2d>
  80127a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127e:	7f 07                	jg     801287 <vsnprintf+0x34>
		return -E_INVAL;
  801280:	b8 03 00 00 00       	mov    $0x3,%eax
  801285:	eb 20                	jmp    8012a7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801287:	ff 75 14             	pushl  0x14(%ebp)
  80128a:	ff 75 10             	pushl  0x10(%ebp)
  80128d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	68 1d 12 80 00       	push   $0x80121d
  801296:	e8 80 fb ff ff       	call   800e1b <vprintfmt>
  80129b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80129e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012af:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b2:	83 c0 04             	add    $0x4,%eax
  8012b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8012be:	50                   	push   %eax
  8012bf:	ff 75 0c             	pushl  0xc(%ebp)
  8012c2:	ff 75 08             	pushl  0x8(%ebp)
  8012c5:	e8 89 ff ff ff       	call   801253 <vsnprintf>
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e2:	eb 06                	jmp    8012ea <strlen+0x15>
		n++;
  8012e4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e7:	ff 45 08             	incl   0x8(%ebp)
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	84 c0                	test   %al,%al
  8012f1:	75 f1                	jne    8012e4 <strlen+0xf>
		n++;
	return n;
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801305:	eb 09                	jmp    801310 <strnlen+0x18>
		n++;
  801307:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80130a:	ff 45 08             	incl   0x8(%ebp)
  80130d:	ff 4d 0c             	decl   0xc(%ebp)
  801310:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801314:	74 09                	je     80131f <strnlen+0x27>
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	84 c0                	test   %al,%al
  80131d:	75 e8                	jne    801307 <strnlen+0xf>
		n++;
	return n;
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801330:	90                   	nop
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 08             	mov    %edx,0x8(%ebp)
  80133a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801340:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801343:	8a 12                	mov    (%edx),%dl
  801345:	88 10                	mov    %dl,(%eax)
  801347:	8a 00                	mov    (%eax),%al
  801349:	84 c0                	test   %al,%al
  80134b:	75 e4                	jne    801331 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80134d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80135e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801365:	eb 1f                	jmp    801386 <strncpy+0x34>
		*dst++ = *src;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8d 50 01             	lea    0x1(%eax),%edx
  80136d:	89 55 08             	mov    %edx,0x8(%ebp)
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	8a 12                	mov    (%edx),%dl
  801375:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 03                	je     801383 <strncpy+0x31>
			src++;
  801380:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801383:	ff 45 fc             	incl   -0x4(%ebp)
  801386:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801389:	3b 45 10             	cmp    0x10(%ebp),%eax
  80138c:	72 d9                	jb     801367 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80139f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a3:	74 30                	je     8013d5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013a5:	eb 16                	jmp    8013bd <strlcpy+0x2a>
			*dst++ = *src++;
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8d 50 01             	lea    0x1(%eax),%edx
  8013ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b9:	8a 12                	mov    (%edx),%dl
  8013bb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013bd:	ff 4d 10             	decl   0x10(%ebp)
  8013c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c4:	74 09                	je     8013cf <strlcpy+0x3c>
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	75 d8                	jne    8013a7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	29 c2                	sub    %eax,%edx
  8013dd:	89 d0                	mov    %edx,%eax
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013e4:	eb 06                	jmp    8013ec <strcmp+0xb>
		p++, q++;
  8013e6:	ff 45 08             	incl   0x8(%ebp)
  8013e9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	84 c0                	test   %al,%al
  8013f3:	74 0e                	je     801403 <strcmp+0x22>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 10                	mov    (%eax),%dl
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	38 c2                	cmp    %al,%dl
  801401:	74 e3                	je     8013e6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 d0             	movzbl %al,%edx
  80140b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	0f b6 c0             	movzbl %al,%eax
  801413:	29 c2                	sub    %eax,%edx
  801415:	89 d0                	mov    %edx,%eax
}
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80141c:	eb 09                	jmp    801427 <strncmp+0xe>
		n--, p++, q++;
  80141e:	ff 4d 10             	decl   0x10(%ebp)
  801421:	ff 45 08             	incl   0x8(%ebp)
  801424:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 17                	je     801444 <strncmp+0x2b>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	84 c0                	test   %al,%al
  801434:	74 0e                	je     801444 <strncmp+0x2b>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 10                	mov    (%eax),%dl
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	38 c2                	cmp    %al,%dl
  801442:	74 da                	je     80141e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801444:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801448:	75 07                	jne    801451 <strncmp+0x38>
		return 0;
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
  80144f:	eb 14                	jmp    801465 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 d0             	movzbl %al,%edx
  801459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	0f b6 c0             	movzbl %al,%eax
  801461:	29 c2                	sub    %eax,%edx
  801463:	89 d0                	mov    %edx,%eax
}
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    

00801467 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 04             	sub    $0x4,%esp
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801473:	eb 12                	jmp    801487 <strchr+0x20>
		if (*s == c)
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80147d:	75 05                	jne    801484 <strchr+0x1d>
			return (char *) s;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	eb 11                	jmp    801495 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801484:	ff 45 08             	incl   0x8(%ebp)
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	84 c0                	test   %al,%al
  80148e:	75 e5                	jne    801475 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014a3:	eb 0d                	jmp    8014b2 <strfind+0x1b>
		if (*s == c)
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014ad:	74 0e                	je     8014bd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014af:	ff 45 08             	incl   0x8(%ebp)
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	84 c0                	test   %al,%al
  8014b9:	75 ea                	jne    8014a5 <strfind+0xe>
  8014bb:	eb 01                	jmp    8014be <strfind+0x27>
		if (*s == c)
			break;
  8014bd:	90                   	nop
	return (char *) s;
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014d3:	76 63                	jbe    801538 <memset+0x75>
		uint64 data_block = c;
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	99                   	cltd   
  8014d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014e9:	c1 e0 08             	shl    $0x8,%eax
  8014ec:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014ef:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8014f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8014fc:	c1 e0 10             	shl    $0x10,%eax
  8014ff:	09 45 f0             	or     %eax,-0x10(%ebp)
  801502:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150b:	89 c2                	mov    %eax,%edx
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
  801512:	09 45 f0             	or     %eax,-0x10(%ebp)
  801515:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801518:	eb 18                	jmp    801532 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80151a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80151d:	8d 41 08             	lea    0x8(%ecx),%eax
  801520:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801529:	89 01                	mov    %eax,(%ecx)
  80152b:	89 51 04             	mov    %edx,0x4(%ecx)
  80152e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801532:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801536:	77 e2                	ja     80151a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801538:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153c:	74 23                	je     801561 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80153e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801541:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801544:	eb 0e                	jmp    801554 <memset+0x91>
			*p8++ = (uint8)c;
  801546:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801549:	8d 50 01             	lea    0x1(%eax),%edx
  80154c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155a:	89 55 10             	mov    %edx,0x10(%ebp)
  80155d:	85 c0                	test   %eax,%eax
  80155f:	75 e5                	jne    801546 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801578:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80157c:	76 24                	jbe    8015a2 <memcpy+0x3c>
		while(n >= 8){
  80157e:	eb 1c                	jmp    80159c <memcpy+0x36>
			*d64 = *s64;
  801580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801583:	8b 50 04             	mov    0x4(%eax),%edx
  801586:	8b 00                	mov    (%eax),%eax
  801588:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80158b:	89 01                	mov    %eax,(%ecx)
  80158d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801590:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801594:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801598:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80159c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015a0:	77 de                	ja     801580 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a6:	74 31                	je     8015d9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015b4:	eb 16                	jmp    8015cc <memcpy+0x66>
			*d8++ = *s8++;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b9:	8d 50 01             	lea    0x1(%eax),%edx
  8015bc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015c5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015c8:	8a 12                	mov    (%edx),%dl
  8015ca:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	75 dd                	jne    8015b6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015f6:	73 50                	jae    801648 <memmove+0x6a>
  8015f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fe:	01 d0                	add    %edx,%eax
  801600:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801603:	76 43                	jbe    801648 <memmove+0x6a>
		s += n;
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80160b:	8b 45 10             	mov    0x10(%ebp),%eax
  80160e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801611:	eb 10                	jmp    801623 <memmove+0x45>
			*--d = *--s;
  801613:	ff 4d f8             	decl   -0x8(%ebp)
  801616:	ff 4d fc             	decl   -0x4(%ebp)
  801619:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161c:	8a 10                	mov    (%eax),%dl
  80161e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801621:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	8d 50 ff             	lea    -0x1(%eax),%edx
  801629:	89 55 10             	mov    %edx,0x10(%ebp)
  80162c:	85 c0                	test   %eax,%eax
  80162e:	75 e3                	jne    801613 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801630:	eb 23                	jmp    801655 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801635:	8d 50 01             	lea    0x1(%eax),%edx
  801638:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80163b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801641:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801644:	8a 12                	mov    (%edx),%dl
  801646:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801648:	8b 45 10             	mov    0x10(%ebp),%eax
  80164b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80164e:	89 55 10             	mov    %edx,0x10(%ebp)
  801651:	85 c0                	test   %eax,%eax
  801653:	75 dd                	jne    801632 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80166c:	eb 2a                	jmp    801698 <memcmp+0x3e>
		if (*s1 != *s2)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	38 c2                	cmp    %al,%dl
  80167a:	74 16                	je     801692 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	0f b6 d0             	movzbl %al,%edx
  801684:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	0f b6 c0             	movzbl %al,%eax
  80168c:	29 c2                	sub    %eax,%edx
  80168e:	89 d0                	mov    %edx,%eax
  801690:	eb 18                	jmp    8016aa <memcmp+0x50>
		s1++, s2++;
  801692:	ff 45 fc             	incl   -0x4(%ebp)
  801695:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801698:	8b 45 10             	mov    0x10(%ebp),%eax
  80169b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169e:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	75 c9                	jne    80166e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	01 d0                	add    %edx,%eax
  8016ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016bd:	eb 15                	jmp    8016d4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	0f b6 d0             	movzbl %al,%edx
  8016c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ca:	0f b6 c0             	movzbl %al,%eax
  8016cd:	39 c2                	cmp    %eax,%edx
  8016cf:	74 0d                	je     8016de <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016d1:	ff 45 08             	incl   0x8(%ebp)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016da:	72 e3                	jb     8016bf <memfind+0x13>
  8016dc:	eb 01                	jmp    8016df <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016de:	90                   	nop
	return (void *) s;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016f8:	eb 03                	jmp    8016fd <strtol+0x19>
		s++;
  8016fa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	3c 20                	cmp    $0x20,%al
  801704:	74 f4                	je     8016fa <strtol+0x16>
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	3c 09                	cmp    $0x9,%al
  80170d:	74 eb                	je     8016fa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	3c 2b                	cmp    $0x2b,%al
  801716:	75 05                	jne    80171d <strtol+0x39>
		s++;
  801718:	ff 45 08             	incl   0x8(%ebp)
  80171b:	eb 13                	jmp    801730 <strtol+0x4c>
	else if (*s == '-')
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	8a 00                	mov    (%eax),%al
  801722:	3c 2d                	cmp    $0x2d,%al
  801724:	75 0a                	jne    801730 <strtol+0x4c>
		s++, neg = 1;
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801730:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801734:	74 06                	je     80173c <strtol+0x58>
  801736:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80173a:	75 20                	jne    80175c <strtol+0x78>
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	8a 00                	mov    (%eax),%al
  801741:	3c 30                	cmp    $0x30,%al
  801743:	75 17                	jne    80175c <strtol+0x78>
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	40                   	inc    %eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	3c 78                	cmp    $0x78,%al
  80174d:	75 0d                	jne    80175c <strtol+0x78>
		s += 2, base = 16;
  80174f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801753:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80175a:	eb 28                	jmp    801784 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80175c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801760:	75 15                	jne    801777 <strtol+0x93>
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	3c 30                	cmp    $0x30,%al
  801769:	75 0c                	jne    801777 <strtol+0x93>
		s++, base = 8;
  80176b:	ff 45 08             	incl   0x8(%ebp)
  80176e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801775:	eb 0d                	jmp    801784 <strtol+0xa0>
	else if (base == 0)
  801777:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177b:	75 07                	jne    801784 <strtol+0xa0>
		base = 10;
  80177d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2f                	cmp    $0x2f,%al
  80178b:	7e 19                	jle    8017a6 <strtol+0xc2>
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3c 39                	cmp    $0x39,%al
  801794:	7f 10                	jg     8017a6 <strtol+0xc2>
			dig = *s - '0';
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	0f be c0             	movsbl %al,%eax
  80179e:	83 e8 30             	sub    $0x30,%eax
  8017a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017a4:	eb 42                	jmp    8017e8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8a 00                	mov    (%eax),%al
  8017ab:	3c 60                	cmp    $0x60,%al
  8017ad:	7e 19                	jle    8017c8 <strtol+0xe4>
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8a 00                	mov    (%eax),%al
  8017b4:	3c 7a                	cmp    $0x7a,%al
  8017b6:	7f 10                	jg     8017c8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	0f be c0             	movsbl %al,%eax
  8017c0:	83 e8 57             	sub    $0x57,%eax
  8017c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017c6:	eb 20                	jmp    8017e8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 40                	cmp    $0x40,%al
  8017cf:	7e 39                	jle    80180a <strtol+0x126>
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8a 00                	mov    (%eax),%al
  8017d6:	3c 5a                	cmp    $0x5a,%al
  8017d8:	7f 30                	jg     80180a <strtol+0x126>
			dig = *s - 'A' + 10;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f be c0             	movsbl %al,%eax
  8017e2:	83 e8 37             	sub    $0x37,%eax
  8017e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017ee:	7d 19                	jge    801809 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017f0:	ff 45 08             	incl   0x8(%ebp)
  8017f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017fa:	89 c2                	mov    %eax,%edx
  8017fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ff:	01 d0                	add    %edx,%eax
  801801:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801804:	e9 7b ff ff ff       	jmp    801784 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801809:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80180a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80180e:	74 08                	je     801818 <strtol+0x134>
		*endptr = (char *) s;
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	8b 55 08             	mov    0x8(%ebp),%edx
  801816:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801818:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80181c:	74 07                	je     801825 <strtol+0x141>
  80181e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801821:	f7 d8                	neg    %eax
  801823:	eb 03                	jmp    801828 <strtol+0x144>
  801825:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <ltostr>:

void
ltostr(long value, char *str)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801830:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801837:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80183e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801842:	79 13                	jns    801857 <ltostr+0x2d>
	{
		neg = 1;
  801844:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80184b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801851:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801854:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80185f:	99                   	cltd   
  801860:	f7 f9                	idiv   %ecx
  801862:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801865:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801868:	8d 50 01             	lea    0x1(%eax),%edx
  80186b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80186e:	89 c2                	mov    %eax,%edx
  801870:	8b 45 0c             	mov    0xc(%ebp),%eax
  801873:	01 d0                	add    %edx,%eax
  801875:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801878:	83 c2 30             	add    $0x30,%edx
  80187b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80187d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801880:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801885:	f7 e9                	imul   %ecx
  801887:	c1 fa 02             	sar    $0x2,%edx
  80188a:	89 c8                	mov    %ecx,%eax
  80188c:	c1 f8 1f             	sar    $0x1f,%eax
  80188f:	29 c2                	sub    %eax,%edx
  801891:	89 d0                	mov    %edx,%eax
  801893:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801896:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80189a:	75 bb                	jne    801857 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80189c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	48                   	dec    %eax
  8018a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ae:	74 3d                	je     8018ed <ltostr+0xc3>
		start = 1 ;
  8018b0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018b7:	eb 34                	jmp    8018ed <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c2                	add    %eax,%edx
  8018ce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	01 c8                	add    %ecx,%eax
  8018d6:	8a 00                	mov    (%eax),%al
  8018d8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018e5:	88 02                	mov    %al,(%edx)
		start++ ;
  8018e7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018ea:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f3:	7c c4                	jl     8018b9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	e8 c4 f9 ff ff       	call   8012d5 <strlen>
  801911:	83 c4 04             	add    $0x4,%esp
  801914:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b6 f9 ff ff       	call   8012d5 <strlen>
  80191f:	83 c4 04             	add    $0x4,%esp
  801922:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801925:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80192c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801933:	eb 17                	jmp    80194c <strcconcat+0x49>
		final[s] = str1[s] ;
  801935:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 c2                	add    %eax,%edx
  80193d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	01 c8                	add    %ecx,%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801949:	ff 45 fc             	incl   -0x4(%ebp)
  80194c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801952:	7c e1                	jl     801935 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801954:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80195b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801962:	eb 1f                	jmp    801983 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801967:	8d 50 01             	lea    0x1(%eax),%edx
  80196a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80196d:	89 c2                	mov    %eax,%edx
  80196f:	8b 45 10             	mov    0x10(%ebp),%eax
  801972:	01 c2                	add    %eax,%edx
  801974:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c8                	add    %ecx,%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801980:	ff 45 f8             	incl   -0x8(%ebp)
  801983:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801986:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801989:	7c d9                	jl     801964 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80198b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80198e:	8b 45 10             	mov    0x10(%ebp),%eax
  801991:	01 d0                	add    %edx,%eax
  801993:	c6 00 00             	movb   $0x0,(%eax)
}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80199c:	8b 45 14             	mov    0x14(%ebp),%eax
  80199f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a8:	8b 00                	mov    (%eax),%eax
  8019aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b4:	01 d0                	add    %edx,%eax
  8019b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019bc:	eb 0c                	jmp    8019ca <strsplit+0x31>
			*string++ = 0;
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8d 50 01             	lea    0x1(%eax),%edx
  8019c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8019c7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	8a 00                	mov    (%eax),%al
  8019cf:	84 c0                	test   %al,%al
  8019d1:	74 18                	je     8019eb <strsplit+0x52>
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8a 00                	mov    (%eax),%al
  8019d8:	0f be c0             	movsbl %al,%eax
  8019db:	50                   	push   %eax
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	e8 83 fa ff ff       	call   801467 <strchr>
  8019e4:	83 c4 08             	add    $0x8,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	75 d3                	jne    8019be <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	8a 00                	mov    (%eax),%al
  8019f0:	84 c0                	test   %al,%al
  8019f2:	74 5a                	je     801a4e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	83 f8 0f             	cmp    $0xf,%eax
  8019fc:	75 07                	jne    801a05 <strsplit+0x6c>
		{
			return 0;
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801a03:	eb 66                	jmp    801a6b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a05:	8b 45 14             	mov    0x14(%ebp),%eax
  801a08:	8b 00                	mov    (%eax),%eax
  801a0a:	8d 48 01             	lea    0x1(%eax),%ecx
  801a0d:	8b 55 14             	mov    0x14(%ebp),%edx
  801a10:	89 0a                	mov    %ecx,(%edx)
  801a12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a19:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1c:	01 c2                	add    %eax,%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a23:	eb 03                	jmp    801a28 <strsplit+0x8f>
			string++;
  801a25:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8a 00                	mov    (%eax),%al
  801a2d:	84 c0                	test   %al,%al
  801a2f:	74 8b                	je     8019bc <strsplit+0x23>
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	8a 00                	mov    (%eax),%al
  801a36:	0f be c0             	movsbl %al,%eax
  801a39:	50                   	push   %eax
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	e8 25 fa ff ff       	call   801467 <strchr>
  801a42:	83 c4 08             	add    $0x8,%esp
  801a45:	85 c0                	test   %eax,%eax
  801a47:	74 dc                	je     801a25 <strsplit+0x8c>
			string++;
	}
  801a49:	e9 6e ff ff ff       	jmp    8019bc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a4e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5e:	01 d0                	add    %edx,%eax
  801a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a66:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a80:	eb 4a                	jmp    801acc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	01 c2                	add    %eax,%edx
  801a8a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a90:	01 c8                	add    %ecx,%eax
  801a92:	8a 00                	mov    (%eax),%al
  801a94:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9c:	01 d0                	add    %edx,%eax
  801a9e:	8a 00                	mov    (%eax),%al
  801aa0:	3c 40                	cmp    $0x40,%al
  801aa2:	7e 25                	jle    801ac9 <str2lower+0x5c>
  801aa4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	01 d0                	add    %edx,%eax
  801aac:	8a 00                	mov    (%eax),%al
  801aae:	3c 5a                	cmp    $0x5a,%al
  801ab0:	7f 17                	jg     801ac9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ab2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	01 d0                	add    %edx,%eax
  801aba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801abd:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac0:	01 ca                	add    %ecx,%edx
  801ac2:	8a 12                	mov    (%edx),%dl
  801ac4:	83 c2 20             	add    $0x20,%edx
  801ac7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ac9:	ff 45 fc             	incl   -0x4(%ebp)
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	e8 01 f8 ff ff       	call   8012d5 <strlen>
  801ad4:	83 c4 04             	add    $0x4,%esp
  801ad7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ada:	7f a6                	jg     801a82 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801adc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ae7:	a1 08 60 80 00       	mov    0x806008,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 42                	je     801b32 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801af0:	83 ec 08             	sub    $0x8,%esp
  801af3:	68 00 00 00 82       	push   $0x82000000
  801af8:	68 00 00 00 80       	push   $0x80000000
  801afd:	e8 b0 1e 00 00       	call   8039b2 <initialize_dynamic_allocator>
  801b02:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b05:	e8 96 1c 00 00       	call   8037a0 <sys_get_uheap_strategy>
  801b0a:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b0f:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801b14:	05 00 10 00 00       	add    $0x1000,%eax
  801b19:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801b1e:	a1 30 61 83 00       	mov    0x836130,%eax
  801b23:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801b28:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801b2f:	00 00 00 
	}
}
  801b32:	90                   	nop
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	68 06 04 00 00       	push   $0x406
  801b51:	50                   	push   %eax
  801b52:	e8 93 18 00 00       	call   8033ea <__sys_allocate_page>
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b61:	79 14                	jns    801b77 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	68 28 4e 80 00       	push   $0x804e28
  801b6b:	6a 1f                	push   $0x1f
  801b6d:	68 64 4e 80 00       	push   $0x804e64
  801b72:	e8 b7 ed ff ff       	call   80092e <_panic>
	return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b92:	83 ec 0c             	sub    $0xc,%esp
  801b95:	50                   	push   %eax
  801b96:	e8 96 18 00 00       	call   803431 <__sys_unmap_frame>
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ba1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ba5:	79 14                	jns    801bbb <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	68 70 4e 80 00       	push   $0x804e70
  801baf:	6a 2a                	push   $0x2a
  801bb1:	68 64 4e 80 00       	push   $0x804e64
  801bb6:	e8 73 ed ff ff       	call   80092e <_panic>
}
  801bbb:	90                   	nop
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bc4:	e8 18 ff ff ff       	call   801ae1 <uheap_init>
	if (size == 0) return NULL ;
  801bc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bcd:	75 0a                	jne    801bd9 <malloc+0x1b>
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	e9 43 03 00 00       	jmp    801f1c <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801bd9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801be0:	77 13                	ja     801bf5 <malloc+0x37>
    {
        return alloc_block(size);
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	ff 75 08             	pushl  0x8(%ebp)
  801be8:	e8 78 20 00 00       	call   803c65 <alloc_block>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	e9 27 03 00 00       	jmp    801f1c <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801bf5:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c02:	01 d0                	add    %edx,%eax
  801c04:	48                   	dec    %eax
  801c05:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c10:	f7 75 dc             	divl   -0x24(%ebp)
  801c13:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c16:	29 d0                	sub    %edx,%eax
  801c18:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801c1b:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801c20:	85 c0                	test   %eax,%eax
  801c22:	75 0a                	jne    801c2e <malloc+0x70>
    {
        uhp_inited = 1;
  801c24:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801c2b:	00 00 00 
    }

    int exactIdx = -1;
  801c2e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801c35:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801c3c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c43:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801c4a:	e9 85 00 00 00       	jmp    801cd4 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801c4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c52:	89 d0                	mov    %edx,%eax
  801c54:	01 c0                	add    %eax,%eax
  801c56:	01 d0                	add    %edx,%eax
  801c58:	c1 e0 02             	shl    $0x2,%eax
  801c5b:	05 48 20 81 00       	add    $0x812048,%eax
  801c60:	8a 00                	mov    (%eax),%al
  801c62:	84 c0                	test   %al,%al
  801c64:	74 20                	je     801c86 <malloc+0xc8>
  801c66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c69:	89 d0                	mov    %edx,%eax
  801c6b:	01 c0                	add    %eax,%eax
  801c6d:	01 d0                	add    %edx,%eax
  801c6f:	c1 e0 02             	shl    $0x2,%eax
  801c72:	05 44 20 81 00       	add    $0x812044,%eax
  801c77:	8b 00                	mov    (%eax),%eax
  801c79:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c7c:	75 08                	jne    801c86 <malloc+0xc8>
        {
            exactIdx = i;
  801c7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801c84:	eb 5b                	jmp    801ce1 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801c86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c89:	89 d0                	mov    %edx,%eax
  801c8b:	01 c0                	add    %eax,%eax
  801c8d:	01 d0                	add    %edx,%eax
  801c8f:	c1 e0 02             	shl    $0x2,%eax
  801c92:	05 48 20 81 00       	add    $0x812048,%eax
  801c97:	8a 00                	mov    (%eax),%al
  801c99:	84 c0                	test   %al,%al
  801c9b:	74 34                	je     801cd1 <malloc+0x113>
  801c9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca0:	89 d0                	mov    %edx,%eax
  801ca2:	01 c0                	add    %eax,%eax
  801ca4:	01 d0                	add    %edx,%eax
  801ca6:	c1 e0 02             	shl    $0x2,%eax
  801ca9:	05 44 20 81 00       	add    $0x812044,%eax
  801cae:	8b 00                	mov    (%eax),%eax
  801cb0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801cb3:	76 1c                	jbe    801cd1 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801cb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cb8:	89 d0                	mov    %edx,%eax
  801cba:	01 c0                	add    %eax,%eax
  801cbc:	01 d0                	add    %edx,%eax
  801cbe:	c1 e0 02             	shl    $0x2,%eax
  801cc1:	05 44 20 81 00       	add    $0x812044,%eax
  801cc6:	8b 00                	mov    (%eax),%eax
  801cc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cd1:	ff 45 e8             	incl   -0x18(%ebp)
  801cd4:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801cdb:	0f 8e 6e ff ff ff    	jle    801c4f <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801ce1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801ce8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801cec:	74 7d                	je     801d6b <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801cee:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf8:	89 d0                	mov    %edx,%eax
  801cfa:	01 c0                	add    %eax,%eax
  801cfc:	01 d0                	add    %edx,%eax
  801cfe:	c1 e0 02             	shl    $0x2,%eax
  801d01:	05 40 20 81 00       	add    $0x812040,%eax
  801d06:	8b 10                	mov    (%eax),%edx
  801d08:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d0b:	01 d0                	add    %edx,%eax
  801d0d:	48                   	dec    %eax
  801d0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d11:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d14:	ba 00 00 00 00       	mov    $0x0,%edx
  801d19:	f7 75 bc             	divl   -0x44(%ebp)
  801d1c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d1f:	29 d0                	sub    %edx,%eax
  801d21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d27:	89 d0                	mov    %edx,%eax
  801d29:	01 c0                	add    %eax,%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	c1 e0 02             	shl    $0x2,%eax
  801d30:	05 48 20 81 00       	add    $0x812048,%eax
  801d35:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3b:	89 d0                	mov    %edx,%eax
  801d3d:	01 c0                	add    %eax,%eax
  801d3f:	01 d0                	add    %edx,%eax
  801d41:	c1 e0 02             	shl    $0x2,%eax
  801d44:	05 44 20 81 00       	add    $0x812044,%eax
  801d49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d52:	89 d0                	mov    %edx,%eax
  801d54:	01 c0                	add    %eax,%eax
  801d56:	01 d0                	add    %edx,%eax
  801d58:	c1 e0 02             	shl    $0x2,%eax
  801d5b:	05 40 20 81 00       	add    $0x812040,%eax
  801d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d66:	e9 2d 01 00 00       	jmp    801e98 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801d6b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d6f:	0f 84 ce 00 00 00    	je     801e43 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801d75:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801d7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7f:	89 d0                	mov    %edx,%eax
  801d81:	01 c0                	add    %eax,%eax
  801d83:	01 d0                	add    %edx,%eax
  801d85:	c1 e0 02             	shl    $0x2,%eax
  801d88:	05 40 20 81 00       	add    $0x812040,%eax
  801d8d:	8b 10                	mov    (%eax),%edx
  801d8f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d92:	01 d0                	add    %edx,%eax
  801d94:	48                   	dec    %eax
  801d95:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801d98:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801da0:	f7 75 c4             	divl   -0x3c(%ebp)
  801da3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801da6:	29 d0                	sub    %edx,%eax
  801da8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801dab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dae:	89 d0                	mov    %edx,%eax
  801db0:	01 c0                	add    %eax,%eax
  801db2:	01 d0                	add    %edx,%eax
  801db4:	c1 e0 02             	shl    $0x2,%eax
  801db7:	05 44 20 81 00       	add    $0x812044,%eax
  801dbc:	8b 00                	mov    (%eax),%eax
  801dbe:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801dc1:	75 47                	jne    801e0a <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801dc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc6:	89 d0                	mov    %edx,%eax
  801dc8:	01 c0                	add    %eax,%eax
  801dca:	01 d0                	add    %edx,%eax
  801dcc:	c1 e0 02             	shl    $0x2,%eax
  801dcf:	05 48 20 81 00       	add    $0x812048,%eax
  801dd4:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801dd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dda:	89 d0                	mov    %edx,%eax
  801ddc:	01 c0                	add    %eax,%eax
  801dde:	01 d0                	add    %edx,%eax
  801de0:	c1 e0 02             	shl    $0x2,%eax
  801de3:	05 44 20 81 00       	add    $0x812044,%eax
  801de8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801dee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801df1:	89 d0                	mov    %edx,%eax
  801df3:	01 c0                	add    %eax,%eax
  801df5:	01 d0                	add    %edx,%eax
  801df7:	c1 e0 02             	shl    $0x2,%eax
  801dfa:	05 40 20 81 00       	add    $0x812040,%eax
  801dff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e05:	e9 8e 00 00 00       	jmp    801e98 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801e0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e10:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e16:	89 d0                	mov    %edx,%eax
  801e18:	01 c0                	add    %eax,%eax
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	c1 e0 02             	shl    $0x2,%eax
  801e1f:	05 40 20 81 00       	add    $0x812040,%eax
  801e24:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e29:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e2c:	89 c2                	mov    %eax,%edx
  801e2e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e31:	89 c8                	mov    %ecx,%eax
  801e33:	01 c0                	add    %eax,%eax
  801e35:	01 c8                	add    %ecx,%eax
  801e37:	c1 e0 02             	shl    $0x2,%eax
  801e3a:	05 44 20 81 00       	add    $0x812044,%eax
  801e3f:	89 10                	mov    %edx,(%eax)
  801e41:	eb 55                	jmp    801e98 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801e43:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e4a:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801e50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e53:	01 d0                	add    %edx,%eax
  801e55:	48                   	dec    %eax
  801e56:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e61:	f7 75 d0             	divl   -0x30(%ebp)
  801e64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e67:	29 d0                	sub    %edx,%eax
  801e69:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801e6c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801e6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e72:	01 d0                	add    %edx,%eax
  801e74:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801e79:	76 0a                	jbe    801e85 <malloc+0x2c7>
            return NULL;
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	e9 97 00 00 00       	jmp    801f1c <malloc+0x35e>
        va = start;
  801e85:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801e8b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801e8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e91:	01 d0                	add    %edx,%eax
  801e93:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e98:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801e9f:	eb 5e                	jmp    801eff <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801ea1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ea4:	89 d0                	mov    %edx,%eax
  801ea6:	01 c0                	add    %eax,%eax
  801ea8:	01 d0                	add    %edx,%eax
  801eaa:	c1 e0 02             	shl    $0x2,%eax
  801ead:	05 48 60 80 00       	add    $0x806048,%eax
  801eb2:	8a 00                	mov    (%eax),%al
  801eb4:	84 c0                	test   %al,%al
  801eb6:	75 44                	jne    801efc <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801eb8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ebb:	89 d0                	mov    %edx,%eax
  801ebd:	01 c0                	add    %eax,%eax
  801ebf:	01 d0                	add    %edx,%eax
  801ec1:	c1 e0 02             	shl    $0x2,%eax
  801ec4:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ecd:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801ecf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ed2:	89 d0                	mov    %edx,%eax
  801ed4:	01 c0                	add    %eax,%eax
  801ed6:	01 d0                	add    %edx,%eax
  801ed8:	c1 e0 02             	shl    $0x2,%eax
  801edb:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801ee1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ee4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801ee6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ee9:	89 d0                	mov    %edx,%eax
  801eeb:	01 c0                	add    %eax,%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c1 e0 02             	shl    $0x2,%eax
  801ef2:	05 48 60 80 00       	add    $0x806048,%eax
  801ef7:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801efa:	eb 0c                	jmp    801f08 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801efc:	ff 45 e0             	incl   -0x20(%ebp)
  801eff:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f06:	7e 99                	jle    801ea1 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801f08:	83 ec 08             	sub    $0x8,%esp
  801f0b:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f0e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f11:	e8 a2 19 00 00       	call   8038b8 <sys_allocate_user_mem>
  801f16:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801f19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f28:	0f 84 fa 03 00 00    	je     802328 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801f34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f37:	85 c0                	test   %eax,%eax
  801f39:	79 1c                	jns    801f57 <free+0x39>
  801f3b:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801f42:	77 13                	ja     801f57 <free+0x39>
    {
        free_block(virtual_address);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 08             	pushl  0x8(%ebp)
  801f4a:	e8 09 21 00 00       	call   804058 <free_block>
  801f4f:	83 c4 10             	add    $0x10,%esp
        return;
  801f52:	e9 d2 03 00 00       	jmp    802329 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801f57:	a1 30 61 83 00       	mov    0x836130,%eax
  801f5c:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801f5f:	72 09                	jb     801f6a <free+0x4c>
  801f61:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801f68:	76 17                	jbe    801f81 <free+0x63>
        panic("free: invalid address");
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 ad 4e 80 00       	push   $0x804ead
  801f72:	68 9b 00 00 00       	push   $0x9b
  801f77:	68 64 4e 80 00       	push   $0x804e64
  801f7c:	e8 ad e9 ff ff       	call   80092e <_panic>

    uint32 size = 0;
  801f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801f88:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f8f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f96:	eb 50                	jmp    801fe8 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801f98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f9b:	89 d0                	mov    %edx,%eax
  801f9d:	01 c0                	add    %eax,%eax
  801f9f:	01 d0                	add    %edx,%eax
  801fa1:	c1 e0 02             	shl    $0x2,%eax
  801fa4:	05 48 60 80 00       	add    $0x806048,%eax
  801fa9:	8a 00                	mov    (%eax),%al
  801fab:	84 c0                	test   %al,%al
  801fad:	74 36                	je     801fe5 <free+0xc7>
  801faf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fb2:	89 d0                	mov    %edx,%eax
  801fb4:	01 c0                	add    %eax,%eax
  801fb6:	01 d0                	add    %edx,%eax
  801fb8:	c1 e0 02             	shl    $0x2,%eax
  801fbb:	05 40 60 80 00       	add    $0x806040,%eax
  801fc0:	8b 00                	mov    (%eax),%eax
  801fc2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fc5:	75 1e                	jne    801fe5 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801fc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fca:	89 d0                	mov    %edx,%eax
  801fcc:	01 c0                	add    %eax,%eax
  801fce:	01 d0                	add    %edx,%eax
  801fd0:	c1 e0 02             	shl    $0x2,%eax
  801fd3:	05 44 60 80 00       	add    $0x806044,%eax
  801fd8:	8b 00                	mov    (%eax),%eax
  801fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe0:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801fe3:	eb 0c                	jmp    801ff1 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fe5:	ff 45 ec             	incl   -0x14(%ebp)
  801fe8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801fef:	7e a7                	jle    801f98 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801ff1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ff5:	74 06                	je     801ffd <free+0xdf>
  801ff7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffb:	75 17                	jne    802014 <free+0xf6>
        panic("free: unknown block");
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	68 c3 4e 80 00       	push   $0x804ec3
  802005:	68 a9 00 00 00       	push   $0xa9
  80200a:	68 64 4e 80 00       	push   $0x804e64
  80200f:	e8 1a e9 ff ff       	call   80092e <_panic>

    uhp_allocs[idx].used = 0;
  802014:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802017:	89 d0                	mov    %edx,%eax
  802019:	01 c0                	add    %eax,%eax
  80201b:	01 d0                	add    %edx,%eax
  80201d:	c1 e0 02             	shl    $0x2,%eax
  802020:	05 48 60 80 00       	add    $0x806048,%eax
  802025:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  802028:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80202f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802036:	eb 64                	jmp    80209c <free+0x17e>
    {
        if (!uhp_frees[i].free)
  802038:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80203b:	89 d0                	mov    %edx,%eax
  80203d:	01 c0                	add    %eax,%eax
  80203f:	01 d0                	add    %edx,%eax
  802041:	c1 e0 02             	shl    $0x2,%eax
  802044:	05 48 20 81 00       	add    $0x812048,%eax
  802049:	8a 00                	mov    (%eax),%al
  80204b:	84 c0                	test   %al,%al
  80204d:	75 4a                	jne    802099 <free+0x17b>
        {
            uhp_frees[i].va = va;
  80204f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802052:	89 d0                	mov    %edx,%eax
  802054:	01 c0                	add    %eax,%eax
  802056:	01 d0                	add    %edx,%eax
  802058:	c1 e0 02             	shl    $0x2,%eax
  80205b:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802061:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802064:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	01 c0                	add    %eax,%eax
  80206d:	01 d0                	add    %edx,%eax
  80206f:	c1 e0 02             	shl    $0x2,%eax
  802072:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  80207d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802080:	89 d0                	mov    %edx,%eax
  802082:	01 c0                	add    %eax,%eax
  802084:	01 d0                	add    %edx,%eax
  802086:	c1 e0 02             	shl    $0x2,%eax
  802089:	05 48 20 81 00       	add    $0x812048,%eax
  80208e:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802094:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802097:	eb 0c                	jmp    8020a5 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802099:	ff 45 e4             	incl   -0x1c(%ebp)
  80209c:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8020a3:	7e 93                	jle    802038 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  8020a5:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8020a9:	0f 84 f1 01 00 00    	je     8022a0 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020b6:	e9 d8 01 00 00       	jmp    802293 <free+0x375>
        {
            if (i == fidx) continue;
  8020bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020be:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020c1:	0f 84 c8 01 00 00    	je     80228f <free+0x371>
            if (uhp_frees[i].free)
  8020c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020ca:	89 d0                	mov    %edx,%eax
  8020cc:	01 c0                	add    %eax,%eax
  8020ce:	01 d0                	add    %edx,%eax
  8020d0:	c1 e0 02             	shl    $0x2,%eax
  8020d3:	05 48 20 81 00       	add    $0x812048,%eax
  8020d8:	8a 00                	mov    (%eax),%al
  8020da:	84 c0                	test   %al,%al
  8020dc:	0f 84 ae 01 00 00    	je     802290 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  8020e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020e5:	89 d0                	mov    %edx,%eax
  8020e7:	01 c0                	add    %eax,%eax
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	c1 e0 02             	shl    $0x2,%eax
  8020ee:	05 40 20 81 00       	add    $0x812040,%eax
  8020f3:	8b 08                	mov    (%eax),%ecx
  8020f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020f8:	89 d0                	mov    %edx,%eax
  8020fa:	01 c0                	add    %eax,%eax
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	c1 e0 02             	shl    $0x2,%eax
  802101:	05 44 20 81 00       	add    $0x812044,%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	01 c1                	add    %eax,%ecx
  80210a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80210d:	89 d0                	mov    %edx,%eax
  80210f:	01 c0                	add    %eax,%eax
  802111:	01 d0                	add    %edx,%eax
  802113:	c1 e0 02             	shl    $0x2,%eax
  802116:	05 40 20 81 00       	add    $0x812040,%eax
  80211b:	8b 00                	mov    (%eax),%eax
  80211d:	39 c1                	cmp    %eax,%ecx
  80211f:	0f 85 a8 00 00 00    	jne    8021cd <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802125:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802128:	89 d0                	mov    %edx,%eax
  80212a:	01 c0                	add    %eax,%eax
  80212c:	01 d0                	add    %edx,%eax
  80212e:	c1 e0 02             	shl    $0x2,%eax
  802131:	05 40 20 81 00       	add    $0x812040,%eax
  802136:	8b 10                	mov    (%eax),%edx
  802138:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80213b:	89 c8                	mov    %ecx,%eax
  80213d:	01 c0                	add    %eax,%eax
  80213f:	01 c8                	add    %ecx,%eax
  802141:	c1 e0 02             	shl    $0x2,%eax
  802144:	05 40 20 81 00       	add    $0x812040,%eax
  802149:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80214b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80214e:	89 d0                	mov    %edx,%eax
  802150:	01 c0                	add    %eax,%eax
  802152:	01 d0                	add    %edx,%eax
  802154:	c1 e0 02             	shl    $0x2,%eax
  802157:	05 44 20 81 00       	add    $0x812044,%eax
  80215c:	8b 08                	mov    (%eax),%ecx
  80215e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802161:	89 d0                	mov    %edx,%eax
  802163:	01 c0                	add    %eax,%eax
  802165:	01 d0                	add    %edx,%eax
  802167:	c1 e0 02             	shl    $0x2,%eax
  80216a:	05 44 20 81 00       	add    $0x812044,%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	01 c1                	add    %eax,%ecx
  802173:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802176:	89 d0                	mov    %edx,%eax
  802178:	01 c0                	add    %eax,%eax
  80217a:	01 d0                	add    %edx,%eax
  80217c:	c1 e0 02             	shl    $0x2,%eax
  80217f:	05 44 20 81 00       	add    $0x812044,%eax
  802184:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802186:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802189:	89 d0                	mov    %edx,%eax
  80218b:	01 c0                	add    %eax,%eax
  80218d:	01 d0                	add    %edx,%eax
  80218f:	c1 e0 02             	shl    $0x2,%eax
  802192:	05 48 20 81 00       	add    $0x812048,%eax
  802197:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80219a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80219d:	89 d0                	mov    %edx,%eax
  80219f:	01 c0                	add    %eax,%eax
  8021a1:	01 d0                	add    %edx,%eax
  8021a3:	c1 e0 02             	shl    $0x2,%eax
  8021a6:	05 40 20 81 00       	add    $0x812040,%eax
  8021ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8021b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021b4:	89 d0                	mov    %edx,%eax
  8021b6:	01 c0                	add    %eax,%eax
  8021b8:	01 d0                	add    %edx,%eax
  8021ba:	c1 e0 02             	shl    $0x2,%eax
  8021bd:	05 44 20 81 00       	add    $0x812044,%eax
  8021c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021c8:	e9 c3 00 00 00       	jmp    802290 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  8021cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021d0:	89 d0                	mov    %edx,%eax
  8021d2:	01 c0                	add    %eax,%eax
  8021d4:	01 d0                	add    %edx,%eax
  8021d6:	c1 e0 02             	shl    $0x2,%eax
  8021d9:	05 40 20 81 00       	add    $0x812040,%eax
  8021de:	8b 08                	mov    (%eax),%ecx
  8021e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021e3:	89 d0                	mov    %edx,%eax
  8021e5:	01 c0                	add    %eax,%eax
  8021e7:	01 d0                	add    %edx,%eax
  8021e9:	c1 e0 02             	shl    $0x2,%eax
  8021ec:	05 44 20 81 00       	add    $0x812044,%eax
  8021f1:	8b 00                	mov    (%eax),%eax
  8021f3:	01 c1                	add    %eax,%ecx
  8021f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021f8:	89 d0                	mov    %edx,%eax
  8021fa:	01 c0                	add    %eax,%eax
  8021fc:	01 d0                	add    %edx,%eax
  8021fe:	c1 e0 02             	shl    $0x2,%eax
  802201:	05 40 20 81 00       	add    $0x812040,%eax
  802206:	8b 00                	mov    (%eax),%eax
  802208:	39 c1                	cmp    %eax,%ecx
  80220a:	0f 85 80 00 00 00    	jne    802290 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802210:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802213:	89 d0                	mov    %edx,%eax
  802215:	01 c0                	add    %eax,%eax
  802217:	01 d0                	add    %edx,%eax
  802219:	c1 e0 02             	shl    $0x2,%eax
  80221c:	05 44 20 81 00       	add    $0x812044,%eax
  802221:	8b 08                	mov    (%eax),%ecx
  802223:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802226:	89 d0                	mov    %edx,%eax
  802228:	01 c0                	add    %eax,%eax
  80222a:	01 d0                	add    %edx,%eax
  80222c:	c1 e0 02             	shl    $0x2,%eax
  80222f:	05 44 20 81 00       	add    $0x812044,%eax
  802234:	8b 00                	mov    (%eax),%eax
  802236:	01 c1                	add    %eax,%ecx
  802238:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80223b:	89 d0                	mov    %edx,%eax
  80223d:	01 c0                	add    %eax,%eax
  80223f:	01 d0                	add    %edx,%eax
  802241:	c1 e0 02             	shl    $0x2,%eax
  802244:	05 44 20 81 00       	add    $0x812044,%eax
  802249:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  80224b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80224e:	89 d0                	mov    %edx,%eax
  802250:	01 c0                	add    %eax,%eax
  802252:	01 d0                	add    %edx,%eax
  802254:	c1 e0 02             	shl    $0x2,%eax
  802257:	05 48 20 81 00       	add    $0x812048,%eax
  80225c:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80225f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802262:	89 d0                	mov    %edx,%eax
  802264:	01 c0                	add    %eax,%eax
  802266:	01 d0                	add    %edx,%eax
  802268:	c1 e0 02             	shl    $0x2,%eax
  80226b:	05 40 20 81 00       	add    $0x812040,%eax
  802270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802276:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802279:	89 d0                	mov    %edx,%eax
  80227b:	01 c0                	add    %eax,%eax
  80227d:	01 d0                	add    %edx,%eax
  80227f:	c1 e0 02             	shl    $0x2,%eax
  802282:	05 44 20 81 00       	add    $0x812044,%eax
  802287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80228d:	eb 01                	jmp    802290 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  80228f:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802290:	ff 45 e0             	incl   -0x20(%ebp)
  802293:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80229a:	0f 8e 1b fe ff ff    	jle    8020bb <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  8022a0:	a1 30 61 83 00       	mov    0x836130,%eax
  8022a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022a8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8022af:	eb 53                	jmp    802304 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  8022b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022b4:	89 d0                	mov    %edx,%eax
  8022b6:	01 c0                	add    %eax,%eax
  8022b8:	01 d0                	add    %edx,%eax
  8022ba:	c1 e0 02             	shl    $0x2,%eax
  8022bd:	05 48 60 80 00       	add    $0x806048,%eax
  8022c2:	8a 00                	mov    (%eax),%al
  8022c4:	84 c0                	test   %al,%al
  8022c6:	74 39                	je     802301 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  8022c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022cb:	89 d0                	mov    %edx,%eax
  8022cd:	01 c0                	add    %eax,%eax
  8022cf:	01 d0                	add    %edx,%eax
  8022d1:	c1 e0 02             	shl    $0x2,%eax
  8022d4:	05 40 60 80 00       	add    $0x806040,%eax
  8022d9:	8b 08                	mov    (%eax),%ecx
  8022db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022de:	89 d0                	mov    %edx,%eax
  8022e0:	01 c0                	add    %eax,%eax
  8022e2:	01 d0                	add    %edx,%eax
  8022e4:	c1 e0 02             	shl    $0x2,%eax
  8022e7:	05 44 60 80 00       	add    $0x806044,%eax
  8022ec:	8b 00                	mov    (%eax),%eax
  8022ee:	01 c8                	add    %ecx,%eax
  8022f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  8022f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022f6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8022f9:	76 06                	jbe    802301 <free+0x3e3>
  8022fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802301:	ff 45 d8             	incl   -0x28(%ebp)
  802304:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80230b:	7e a4                	jle    8022b1 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  80230d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802310:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  802315:	83 ec 08             	sub    $0x8,%esp
  802318:	ff 75 f4             	pushl  -0xc(%ebp)
  80231b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80231e:	e8 79 15 00 00       	call   80389c <sys_free_user_mem>
  802323:	83 c4 10             	add    $0x10,%esp
  802326:	eb 01                	jmp    802329 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802328:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 68             	sub    $0x68,%esp
  802331:	8b 45 10             	mov    0x10(%ebp),%eax
  802334:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802337:	e8 a5 f7 ff ff       	call   801ae1 <uheap_init>
	if (size == 0) return NULL ;
  80233c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802340:	75 0a                	jne    80234c <smalloc+0x21>
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
  802347:	e9 37 03 00 00       	jmp    802683 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80234c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802353:	8b 55 0c             	mov    0xc(%ebp),%edx
  802356:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802359:	01 d0                	add    %edx,%eax
  80235b:	48                   	dec    %eax
  80235c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80235f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802362:	ba 00 00 00 00       	mov    $0x0,%edx
  802367:	f7 75 dc             	divl   -0x24(%ebp)
  80236a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80236d:	29 d0                	sub    %edx,%eax
  80236f:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802372:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802379:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802380:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802387:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80238e:	e9 85 00 00 00       	jmp    802418 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802393:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802396:	89 d0                	mov    %edx,%eax
  802398:	01 c0                	add    %eax,%eax
  80239a:	01 d0                	add    %edx,%eax
  80239c:	c1 e0 02             	shl    $0x2,%eax
  80239f:	05 48 20 81 00       	add    $0x812048,%eax
  8023a4:	8a 00                	mov    (%eax),%al
  8023a6:	84 c0                	test   %al,%al
  8023a8:	74 20                	je     8023ca <smalloc+0x9f>
  8023aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023ad:	89 d0                	mov    %edx,%eax
  8023af:	01 c0                	add    %eax,%eax
  8023b1:	01 d0                	add    %edx,%eax
  8023b3:	c1 e0 02             	shl    $0x2,%eax
  8023b6:	05 44 20 81 00       	add    $0x812044,%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8023c0:	75 08                	jne    8023ca <smalloc+0x9f>
        {
            exactIdx = i;
  8023c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8023c8:	eb 5b                	jmp    802425 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8023ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023cd:	89 d0                	mov    %edx,%eax
  8023cf:	01 c0                	add    %eax,%eax
  8023d1:	01 d0                	add    %edx,%eax
  8023d3:	c1 e0 02             	shl    $0x2,%eax
  8023d6:	05 48 20 81 00       	add    $0x812048,%eax
  8023db:	8a 00                	mov    (%eax),%al
  8023dd:	84 c0                	test   %al,%al
  8023df:	74 34                	je     802415 <smalloc+0xea>
  8023e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023e4:	89 d0                	mov    %edx,%eax
  8023e6:	01 c0                	add    %eax,%eax
  8023e8:	01 d0                	add    %edx,%eax
  8023ea:	c1 e0 02             	shl    $0x2,%eax
  8023ed:	05 44 20 81 00       	add    $0x812044,%eax
  8023f2:	8b 00                	mov    (%eax),%eax
  8023f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023f7:	76 1c                	jbe    802415 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8023f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023fc:	89 d0                	mov    %edx,%eax
  8023fe:	01 c0                	add    %eax,%eax
  802400:	01 d0                	add    %edx,%eax
  802402:	c1 e0 02             	shl    $0x2,%eax
  802405:	05 44 20 81 00       	add    $0x812044,%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80240f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802412:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802415:	ff 45 e8             	incl   -0x18(%ebp)
  802418:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80241f:	0f 8e 6e ff ff ff    	jle    802393 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802425:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80242c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802430:	74 7d                	je     8024af <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802432:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243c:	89 d0                	mov    %edx,%eax
  80243e:	01 c0                	add    %eax,%eax
  802440:	01 d0                	add    %edx,%eax
  802442:	c1 e0 02             	shl    $0x2,%eax
  802445:	05 40 20 81 00       	add    $0x812040,%eax
  80244a:	8b 10                	mov    (%eax),%edx
  80244c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80244f:	01 d0                	add    %edx,%eax
  802451:	48                   	dec    %eax
  802452:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802455:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802458:	ba 00 00 00 00       	mov    $0x0,%edx
  80245d:	f7 75 bc             	divl   -0x44(%ebp)
  802460:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802463:	29 d0                	sub    %edx,%eax
  802465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802468:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246b:	89 d0                	mov    %edx,%eax
  80246d:	01 c0                	add    %eax,%eax
  80246f:	01 d0                	add    %edx,%eax
  802471:	c1 e0 02             	shl    $0x2,%eax
  802474:	05 48 20 81 00       	add    $0x812048,%eax
  802479:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80247c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247f:	89 d0                	mov    %edx,%eax
  802481:	01 c0                	add    %eax,%eax
  802483:	01 d0                	add    %edx,%eax
  802485:	c1 e0 02             	shl    $0x2,%eax
  802488:	05 44 20 81 00       	add    $0x812044,%eax
  80248d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802496:	89 d0                	mov    %edx,%eax
  802498:	01 c0                	add    %eax,%eax
  80249a:	01 d0                	add    %edx,%eax
  80249c:	c1 e0 02             	shl    $0x2,%eax
  80249f:	05 40 20 81 00       	add    $0x812040,%eax
  8024a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024aa:	e9 2d 01 00 00       	jmp    8025dc <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8024af:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024b3:	0f 84 ce 00 00 00    	je     802587 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8024b9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8024c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c3:	89 d0                	mov    %edx,%eax
  8024c5:	01 c0                	add    %eax,%eax
  8024c7:	01 d0                	add    %edx,%eax
  8024c9:	c1 e0 02             	shl    $0x2,%eax
  8024cc:	05 40 20 81 00       	add    $0x812040,%eax
  8024d1:	8b 10                	mov    (%eax),%edx
  8024d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024d6:	01 d0                	add    %edx,%eax
  8024d8:	48                   	dec    %eax
  8024d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8024dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024df:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e4:	f7 75 c4             	divl   -0x3c(%ebp)
  8024e7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024ea:	29 d0                	sub    %edx,%eax
  8024ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8024ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f2:	89 d0                	mov    %edx,%eax
  8024f4:	01 c0                	add    %eax,%eax
  8024f6:	01 d0                	add    %edx,%eax
  8024f8:	c1 e0 02             	shl    $0x2,%eax
  8024fb:	05 44 20 81 00       	add    $0x812044,%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802505:	75 47                	jne    80254e <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802507:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250a:	89 d0                	mov    %edx,%eax
  80250c:	01 c0                	add    %eax,%eax
  80250e:	01 d0                	add    %edx,%eax
  802510:	c1 e0 02             	shl    $0x2,%eax
  802513:	05 48 20 81 00       	add    $0x812048,%eax
  802518:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80251b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251e:	89 d0                	mov    %edx,%eax
  802520:	01 c0                	add    %eax,%eax
  802522:	01 d0                	add    %edx,%eax
  802524:	c1 e0 02             	shl    $0x2,%eax
  802527:	05 44 20 81 00       	add    $0x812044,%eax
  80252c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802535:	89 d0                	mov    %edx,%eax
  802537:	01 c0                	add    %eax,%eax
  802539:	01 d0                	add    %edx,%eax
  80253b:	c1 e0 02             	shl    $0x2,%eax
  80253e:	05 40 20 81 00       	add    $0x812040,%eax
  802543:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802549:	e9 8e 00 00 00       	jmp    8025dc <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80254e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802551:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802554:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255a:	89 d0                	mov    %edx,%eax
  80255c:	01 c0                	add    %eax,%eax
  80255e:	01 d0                	add    %edx,%eax
  802560:	c1 e0 02             	shl    $0x2,%eax
  802563:	05 40 20 81 00       	add    $0x812040,%eax
  802568:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802570:	89 c2                	mov    %eax,%edx
  802572:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802575:	89 c8                	mov    %ecx,%eax
  802577:	01 c0                	add    %eax,%eax
  802579:	01 c8                	add    %ecx,%eax
  80257b:	c1 e0 02             	shl    $0x2,%eax
  80257e:	05 44 20 81 00       	add    $0x812044,%eax
  802583:	89 10                	mov    %edx,(%eax)
  802585:	eb 55                	jmp    8025dc <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802587:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80258e:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802594:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802597:	01 d0                	add    %edx,%eax
  802599:	48                   	dec    %eax
  80259a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80259d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a5:	f7 75 d0             	divl   -0x30(%ebp)
  8025a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025ab:	29 d0                	sub    %edx,%eax
  8025ad:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8025b0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8025b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b6:	01 d0                	add    %edx,%eax
  8025b8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8025bd:	76 0a                	jbe    8025c9 <smalloc+0x29e>
            return NULL;
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c4:	e9 ba 00 00 00       	jmp    802683 <smalloc+0x358>
        va = start;
  8025c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8025cf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8025d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d5:	01 d0                	add    %edx,%eax
  8025d7:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8025e3:	eb 5e                	jmp    802643 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8025e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025e8:	89 d0                	mov    %edx,%eax
  8025ea:	01 c0                	add    %eax,%eax
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	c1 e0 02             	shl    $0x2,%eax
  8025f1:	05 48 60 80 00       	add    $0x806048,%eax
  8025f6:	8a 00                	mov    (%eax),%al
  8025f8:	84 c0                	test   %al,%al
  8025fa:	75 44                	jne    802640 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8025fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025ff:	89 d0                	mov    %edx,%eax
  802601:	01 c0                	add    %eax,%eax
  802603:	01 d0                	add    %edx,%eax
  802605:	c1 e0 02             	shl    $0x2,%eax
  802608:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80260e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802611:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802613:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802616:	89 d0                	mov    %edx,%eax
  802618:	01 c0                	add    %eax,%eax
  80261a:	01 d0                	add    %edx,%eax
  80261c:	c1 e0 02             	shl    $0x2,%eax
  80261f:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802628:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80262a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80262d:	89 d0                	mov    %edx,%eax
  80262f:	01 c0                	add    %eax,%eax
  802631:	01 d0                	add    %edx,%eax
  802633:	c1 e0 02             	shl    $0x2,%eax
  802636:	05 48 60 80 00       	add    $0x806048,%eax
  80263b:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80263e:	eb 0c                	jmp    80264c <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802640:	ff 45 e0             	incl   -0x20(%ebp)
  802643:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80264a:	7e 99                	jle    8025e5 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80264c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80264f:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802653:	52                   	push   %edx
  802654:	50                   	push   %eax
  802655:	ff 75 d4             	pushl  -0x2c(%ebp)
  802658:	ff 75 08             	pushl  0x8(%ebp)
  80265b:	e8 de 0e 00 00       	call   80353e <sys_create_shared_object>
  802660:	83 c4 10             	add    $0x10,%esp
  802663:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802666:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80266a:	75 07                	jne    802673 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80266c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802671:	eb 10                	jmp    802683 <smalloc+0x358>
    if (r < 0)
  802673:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802677:	79 07                	jns    802680 <smalloc+0x355>
        return NULL;
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
  80267e:	eb 03                	jmp    802683 <smalloc+0x358>
    return (void*)va;
  802680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80268b:	e8 51 f4 ff ff       	call   801ae1 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802690:	83 ec 08             	sub    $0x8,%esp
  802693:	ff 75 0c             	pushl  0xc(%ebp)
  802696:	ff 75 08             	pushl  0x8(%ebp)
  802699:	e8 ca 0e 00 00       	call   803568 <sys_size_of_shared_object>
  80269e:	83 c4 10             	add    $0x10,%esp
  8026a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8026a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8026a8:	7f 0a                	jg     8026b4 <sget+0x2f>
        return NULL;
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026af:	e9 28 03 00 00       	jmp    8029dc <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8026b4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026c1:	01 d0                	add    %edx,%eax
  8026c3:	48                   	dec    %eax
  8026c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cf:	f7 75 d8             	divl   -0x28(%ebp)
  8026d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d5:	29 d0                	sub    %edx,%eax
  8026d7:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8026da:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8026e1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8026e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8026ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8026f6:	e9 85 00 00 00       	jmp    802780 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8026fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026fe:	89 d0                	mov    %edx,%eax
  802700:	01 c0                	add    %eax,%eax
  802702:	01 d0                	add    %edx,%eax
  802704:	c1 e0 02             	shl    $0x2,%eax
  802707:	05 48 20 81 00       	add    $0x812048,%eax
  80270c:	8a 00                	mov    (%eax),%al
  80270e:	84 c0                	test   %al,%al
  802710:	74 20                	je     802732 <sget+0xad>
  802712:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802715:	89 d0                	mov    %edx,%eax
  802717:	01 c0                	add    %eax,%eax
  802719:	01 d0                	add    %edx,%eax
  80271b:	c1 e0 02             	shl    $0x2,%eax
  80271e:	05 44 20 81 00       	add    $0x812044,%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802728:	75 08                	jne    802732 <sget+0xad>
        {
            exactIdx = i;
  80272a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802730:	eb 5b                	jmp    80278d <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802732:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802735:	89 d0                	mov    %edx,%eax
  802737:	01 c0                	add    %eax,%eax
  802739:	01 d0                	add    %edx,%eax
  80273b:	c1 e0 02             	shl    $0x2,%eax
  80273e:	05 48 20 81 00       	add    $0x812048,%eax
  802743:	8a 00                	mov    (%eax),%al
  802745:	84 c0                	test   %al,%al
  802747:	74 34                	je     80277d <sget+0xf8>
  802749:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274c:	89 d0                	mov    %edx,%eax
  80274e:	01 c0                	add    %eax,%eax
  802750:	01 d0                	add    %edx,%eax
  802752:	c1 e0 02             	shl    $0x2,%eax
  802755:	05 44 20 81 00       	add    $0x812044,%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80275f:	76 1c                	jbe    80277d <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802761:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802764:	89 d0                	mov    %edx,%eax
  802766:	01 c0                	add    %eax,%eax
  802768:	01 d0                	add    %edx,%eax
  80276a:	c1 e0 02             	shl    $0x2,%eax
  80276d:	05 44 20 81 00       	add    $0x812044,%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802777:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80277d:	ff 45 e8             	incl   -0x18(%ebp)
  802780:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802787:	0f 8e 6e ff ff ff    	jle    8026fb <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80278d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802794:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802798:	74 7d                	je     802817 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80279a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8027a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a4:	89 d0                	mov    %edx,%eax
  8027a6:	01 c0                	add    %eax,%eax
  8027a8:	01 d0                	add    %edx,%eax
  8027aa:	c1 e0 02             	shl    $0x2,%eax
  8027ad:	05 40 20 81 00       	add    $0x812040,%eax
  8027b2:	8b 10                	mov    (%eax),%edx
  8027b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027b7:	01 d0                	add    %edx,%eax
  8027b9:	48                   	dec    %eax
  8027ba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8027bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c5:	f7 75 b8             	divl   -0x48(%ebp)
  8027c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027cb:	29 d0                	sub    %edx,%eax
  8027cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8027d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d3:	89 d0                	mov    %edx,%eax
  8027d5:	01 c0                	add    %eax,%eax
  8027d7:	01 d0                	add    %edx,%eax
  8027d9:	c1 e0 02             	shl    $0x2,%eax
  8027dc:	05 48 20 81 00       	add    $0x812048,%eax
  8027e1:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8027e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e7:	89 d0                	mov    %edx,%eax
  8027e9:	01 c0                	add    %eax,%eax
  8027eb:	01 d0                	add    %edx,%eax
  8027ed:	c1 e0 02             	shl    $0x2,%eax
  8027f0:	05 44 20 81 00       	add    $0x812044,%eax
  8027f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8027fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fe:	89 d0                	mov    %edx,%eax
  802800:	01 c0                	add    %eax,%eax
  802802:	01 d0                	add    %edx,%eax
  802804:	c1 e0 02             	shl    $0x2,%eax
  802807:	05 40 20 81 00       	add    $0x812040,%eax
  80280c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802812:	e9 2d 01 00 00       	jmp    802944 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802817:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80281b:	0f 84 ce 00 00 00    	je     8028ef <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802821:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282b:	89 d0                	mov    %edx,%eax
  80282d:	01 c0                	add    %eax,%eax
  80282f:	01 d0                	add    %edx,%eax
  802831:	c1 e0 02             	shl    $0x2,%eax
  802834:	05 40 20 81 00       	add    $0x812040,%eax
  802839:	8b 10                	mov    (%eax),%edx
  80283b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80283e:	01 d0                	add    %edx,%eax
  802840:	48                   	dec    %eax
  802841:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802844:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802847:	ba 00 00 00 00       	mov    $0x0,%edx
  80284c:	f7 75 c0             	divl   -0x40(%ebp)
  80284f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802852:	29 d0                	sub    %edx,%eax
  802854:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802857:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285a:	89 d0                	mov    %edx,%eax
  80285c:	01 c0                	add    %eax,%eax
  80285e:	01 d0                	add    %edx,%eax
  802860:	c1 e0 02             	shl    $0x2,%eax
  802863:	05 44 20 81 00       	add    $0x812044,%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80286d:	75 47                	jne    8028b6 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80286f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	01 c0                	add    %eax,%eax
  802876:	01 d0                	add    %edx,%eax
  802878:	c1 e0 02             	shl    $0x2,%eax
  80287b:	05 48 20 81 00       	add    $0x812048,%eax
  802880:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802883:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802886:	89 d0                	mov    %edx,%eax
  802888:	01 c0                	add    %eax,%eax
  80288a:	01 d0                	add    %edx,%eax
  80288c:	c1 e0 02             	shl    $0x2,%eax
  80288f:	05 44 20 81 00       	add    $0x812044,%eax
  802894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80289a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289d:	89 d0                	mov    %edx,%eax
  80289f:	01 c0                	add    %eax,%eax
  8028a1:	01 d0                	add    %edx,%eax
  8028a3:	c1 e0 02             	shl    $0x2,%eax
  8028a6:	05 40 20 81 00       	add    $0x812040,%eax
  8028ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b1:	e9 8e 00 00 00       	jmp    802944 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8028b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028bc:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c2:	89 d0                	mov    %edx,%eax
  8028c4:	01 c0                	add    %eax,%eax
  8028c6:	01 d0                	add    %edx,%eax
  8028c8:	c1 e0 02             	shl    $0x2,%eax
  8028cb:	05 40 20 81 00       	add    $0x812040,%eax
  8028d0:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8028d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d5:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8028d8:	89 c2                	mov    %eax,%edx
  8028da:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028dd:	89 c8                	mov    %ecx,%eax
  8028df:	01 c0                	add    %eax,%eax
  8028e1:	01 c8                	add    %ecx,%eax
  8028e3:	c1 e0 02             	shl    $0x2,%eax
  8028e6:	05 44 20 81 00       	add    $0x812044,%eax
  8028eb:	89 10                	mov    %edx,(%eax)
  8028ed:	eb 55                	jmp    802944 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8028ef:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028f6:	8b 15 88 60 83 00    	mov    0x836088,%edx
  8028fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ff:	01 d0                	add    %edx,%eax
  802901:	48                   	dec    %eax
  802902:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802905:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802908:	ba 00 00 00 00       	mov    $0x0,%edx
  80290d:	f7 75 cc             	divl   -0x34(%ebp)
  802910:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802913:	29 d0                	sub    %edx,%eax
  802915:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802918:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80291b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80291e:	01 d0                	add    %edx,%eax
  802920:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802925:	76 0a                	jbe    802931 <sget+0x2ac>
            return NULL;
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
  80292c:	e9 ab 00 00 00       	jmp    8029dc <sget+0x357>
        va = start;
  802931:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802934:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802937:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80293a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80293d:	01 d0                	add    %edx,%eax
  80293f:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802944:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80294b:	eb 5e                	jmp    8029ab <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  80294d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802950:	89 d0                	mov    %edx,%eax
  802952:	01 c0                	add    %eax,%eax
  802954:	01 d0                	add    %edx,%eax
  802956:	c1 e0 02             	shl    $0x2,%eax
  802959:	05 48 60 80 00       	add    $0x806048,%eax
  80295e:	8a 00                	mov    (%eax),%al
  802960:	84 c0                	test   %al,%al
  802962:	75 44                	jne    8029a8 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802964:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802967:	89 d0                	mov    %edx,%eax
  802969:	01 c0                	add    %eax,%eax
  80296b:	01 d0                	add    %edx,%eax
  80296d:	c1 e0 02             	shl    $0x2,%eax
  802970:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802979:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80297b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80297e:	89 d0                	mov    %edx,%eax
  802980:	01 c0                	add    %eax,%eax
  802982:	01 d0                	add    %edx,%eax
  802984:	c1 e0 02             	shl    $0x2,%eax
  802987:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  80298d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802990:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802992:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802995:	89 d0                	mov    %edx,%eax
  802997:	01 c0                	add    %eax,%eax
  802999:	01 d0                	add    %edx,%eax
  80299b:	c1 e0 02             	shl    $0x2,%eax
  80299e:	05 48 60 80 00       	add    $0x806048,%eax
  8029a3:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8029a6:	eb 0c                	jmp    8029b4 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029a8:	ff 45 e0             	incl   -0x20(%ebp)
  8029ab:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8029b2:	7e 99                	jle    80294d <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8029b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b7:	83 ec 04             	sub    $0x4,%esp
  8029ba:	50                   	push   %eax
  8029bb:	ff 75 0c             	pushl  0xc(%ebp)
  8029be:	ff 75 08             	pushl  0x8(%ebp)
  8029c1:	e8 bf 0b 00 00       	call   803585 <sys_get_shared_object>
  8029c6:	83 c4 10             	add    $0x10,%esp
  8029c9:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8029cc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029d0:	79 07                	jns    8029d9 <sget+0x354>
        return NULL;
  8029d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d7:	eb 03                	jmp    8029dc <sget+0x357>
    return (void*)va;
  8029d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8029dc:	c9                   	leave  
  8029dd:	c3                   	ret    

008029de <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8029de:	55                   	push   %ebp
  8029df:	89 e5                	mov    %esp,%ebp
  8029e1:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8029e4:	e8 f8 f0 ff ff       	call   801ae1 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8029e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ed:	75 13                	jne    802a02 <realloc+0x24>
		return malloc(new_size);
  8029ef:	83 ec 0c             	sub    $0xc,%esp
  8029f2:	ff 75 0c             	pushl  0xc(%ebp)
  8029f5:	e8 c4 f1 ff ff       	call   801bbe <malloc>
  8029fa:	83 c4 10             	add    $0x10,%esp
  8029fd:	e9 f4 05 00 00       	jmp    802ff6 <realloc+0x618>
	if (new_size == 0)
  802a02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a06:	75 18                	jne    802a20 <realloc+0x42>
	{
		free(virtual_address);
  802a08:	83 ec 0c             	sub    $0xc,%esp
  802a0b:	ff 75 08             	pushl  0x8(%ebp)
  802a0e:	e8 0b f5 ff ff       	call   801f1e <free>
  802a13:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802a16:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1b:	e9 d6 05 00 00       	jmp    802ff6 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802a26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	79 74                	jns    802aa1 <realloc+0xc3>
  802a2d:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802a34:	77 6b                	ja     802aa1 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802a36:	83 ec 0c             	sub    $0xc,%esp
  802a39:	ff 75 0c             	pushl  0xc(%ebp)
  802a3c:	e8 7d f1 ff ff       	call   801bbe <malloc>
  802a41:	83 c4 10             	add    $0x10,%esp
  802a44:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802a47:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802a4b:	75 0a                	jne    802a57 <realloc+0x79>
			return NULL;
  802a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a52:	e9 9f 05 00 00       	jmp    802ff6 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802a57:	83 ec 0c             	sub    $0xc,%esp
  802a5a:	ff 75 08             	pushl  0x8(%ebp)
  802a5d:	e8 e0 11 00 00       	call   803c42 <get_block_size>
  802a62:	83 c4 10             	add    $0x10,%esp
  802a65:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802a68:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a6e:	39 d0                	cmp    %edx,%eax
  802a70:	76 02                	jbe    802a74 <realloc+0x96>
  802a72:	89 d0                	mov    %edx,%eax
  802a74:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802a77:	83 ec 04             	sub    $0x4,%esp
  802a7a:	ff 75 c0             	pushl  -0x40(%ebp)
  802a7d:	ff 75 08             	pushl  0x8(%ebp)
  802a80:	ff 75 c8             	pushl  -0x38(%ebp)
  802a83:	e8 56 eb ff ff       	call   8015de <memmove>
  802a88:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802a8b:	83 ec 0c             	sub    $0xc,%esp
  802a8e:	ff 75 08             	pushl  0x8(%ebp)
  802a91:	e8 88 f4 ff ff       	call   801f1e <free>
  802a96:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802a99:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a9c:	e9 55 05 00 00       	jmp    802ff6 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802aa1:	a1 30 61 83 00       	mov    0x836130,%eax
  802aa6:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802aa9:	72 09                	jb     802ab4 <realloc+0xd6>
  802aab:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802ab2:	76 0a                	jbe    802abe <realloc+0xe0>
		return NULL;
  802ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab9:	e9 38 05 00 00       	jmp    802ff6 <realloc+0x618>
	uint32 oldsz = 0;
  802abe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802ac5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802acc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802ad3:	eb 50                	jmp    802b25 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad8:	89 d0                	mov    %edx,%eax
  802ada:	01 c0                	add    %eax,%eax
  802adc:	01 d0                	add    %edx,%eax
  802ade:	c1 e0 02             	shl    $0x2,%eax
  802ae1:	05 48 60 80 00       	add    $0x806048,%eax
  802ae6:	8a 00                	mov    (%eax),%al
  802ae8:	84 c0                	test   %al,%al
  802aea:	74 36                	je     802b22 <realloc+0x144>
  802aec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aef:	89 d0                	mov    %edx,%eax
  802af1:	01 c0                	add    %eax,%eax
  802af3:	01 d0                	add    %edx,%eax
  802af5:	c1 e0 02             	shl    $0x2,%eax
  802af8:	05 40 60 80 00       	add    $0x806040,%eax
  802afd:	8b 00                	mov    (%eax),%eax
  802aff:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802b02:	75 1e                	jne    802b22 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b07:	89 d0                	mov    %edx,%eax
  802b09:	01 c0                	add    %eax,%eax
  802b0b:	01 d0                	add    %edx,%eax
  802b0d:	c1 e0 02             	shl    $0x2,%eax
  802b10:	05 44 60 80 00       	add    $0x806044,%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802b20:	eb 0c                	jmp    802b2e <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b22:	ff 45 ec             	incl   -0x14(%ebp)
  802b25:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b2c:	7e a7                	jle    802ad5 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802b2e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b32:	75 0a                	jne    802b3e <realloc+0x160>
		return NULL;
  802b34:	b8 00 00 00 00       	mov    $0x0,%eax
  802b39:	e9 b8 04 00 00       	jmp    802ff6 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802b3e:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b48:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b4b:	01 d0                	add    %edx,%eax
  802b4d:	48                   	dec    %eax
  802b4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802b51:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b54:	ba 00 00 00 00       	mov    $0x0,%edx
  802b59:	f7 75 bc             	divl   -0x44(%ebp)
  802b5c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b5f:	29 d0                	sub    %edx,%eax
  802b61:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802b64:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b67:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b6a:	75 08                	jne    802b74 <realloc+0x196>
		return virtual_address;
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	e9 82 04 00 00       	jmp    802ff6 <realloc+0x618>
	if (req < oldsz)
  802b74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b77:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b7a:	0f 83 cd 02 00 00    	jae    802e4d <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802b86:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802b89:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b8c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b8f:	01 d0                	add    %edx,%eax
  802b91:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802b94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b97:	89 d0                	mov    %edx,%eax
  802b99:	01 c0                	add    %eax,%eax
  802b9b:	01 d0                	add    %edx,%eax
  802b9d:	c1 e0 02             	shl    $0x2,%eax
  802ba0:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802ba6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ba9:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802bab:	83 ec 08             	sub    $0x8,%esp
  802bae:	ff 75 b0             	pushl  -0x50(%ebp)
  802bb1:	ff 75 ac             	pushl  -0x54(%ebp)
  802bb4:	e8 e3 0c 00 00       	call   80389c <sys_free_user_mem>
  802bb9:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802bbc:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bc3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802bca:	eb 64                	jmp    802c30 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802bcc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bcf:	89 d0                	mov    %edx,%eax
  802bd1:	01 c0                	add    %eax,%eax
  802bd3:	01 d0                	add    %edx,%eax
  802bd5:	c1 e0 02             	shl    $0x2,%eax
  802bd8:	05 48 20 81 00       	add    $0x812048,%eax
  802bdd:	8a 00                	mov    (%eax),%al
  802bdf:	84 c0                	test   %al,%al
  802be1:	75 4a                	jne    802c2d <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802be3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802be6:	89 d0                	mov    %edx,%eax
  802be8:	01 c0                	add    %eax,%eax
  802bea:	01 d0                	add    %edx,%eax
  802bec:	c1 e0 02             	shl    $0x2,%eax
  802bef:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802bf5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bf8:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802bfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bfd:	89 d0                	mov    %edx,%eax
  802bff:	01 c0                	add    %eax,%eax
  802c01:	01 d0                	add    %edx,%eax
  802c03:	c1 e0 02             	shl    $0x2,%eax
  802c06:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802c0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0f:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802c11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c14:	89 d0                	mov    %edx,%eax
  802c16:	01 c0                	add    %eax,%eax
  802c18:	01 d0                	add    %edx,%eax
  802c1a:	c1 e0 02             	shl    $0x2,%eax
  802c1d:	05 48 20 81 00       	add    $0x812048,%eax
  802c22:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c28:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802c2b:	eb 0c                	jmp    802c39 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c2d:	ff 45 e4             	incl   -0x1c(%ebp)
  802c30:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802c37:	7e 93                	jle    802bcc <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802c39:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802c3d:	0f 84 8d 01 00 00    	je     802dd0 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c4a:	e9 74 01 00 00       	jmp    802dc3 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c52:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c55:	0f 84 64 01 00 00    	je     802dbf <realloc+0x3e1>
				if (uhp_frees[k].free)
  802c5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c5e:	89 d0                	mov    %edx,%eax
  802c60:	01 c0                	add    %eax,%eax
  802c62:	01 d0                	add    %edx,%eax
  802c64:	c1 e0 02             	shl    $0x2,%eax
  802c67:	05 48 20 81 00       	add    $0x812048,%eax
  802c6c:	8a 00                	mov    (%eax),%al
  802c6e:	84 c0                	test   %al,%al
  802c70:	0f 84 4a 01 00 00    	je     802dc0 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c79:	89 d0                	mov    %edx,%eax
  802c7b:	01 c0                	add    %eax,%eax
  802c7d:	01 d0                	add    %edx,%eax
  802c7f:	c1 e0 02             	shl    $0x2,%eax
  802c82:	05 40 20 81 00       	add    $0x812040,%eax
  802c87:	8b 08                	mov    (%eax),%ecx
  802c89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c8c:	89 d0                	mov    %edx,%eax
  802c8e:	01 c0                	add    %eax,%eax
  802c90:	01 d0                	add    %edx,%eax
  802c92:	c1 e0 02             	shl    $0x2,%eax
  802c95:	05 44 20 81 00       	add    $0x812044,%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	01 c1                	add    %eax,%ecx
  802c9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca1:	89 d0                	mov    %edx,%eax
  802ca3:	01 c0                	add    %eax,%eax
  802ca5:	01 d0                	add    %edx,%eax
  802ca7:	c1 e0 02             	shl    $0x2,%eax
  802caa:	05 40 20 81 00       	add    $0x812040,%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	39 c1                	cmp    %eax,%ecx
  802cb3:	75 7a                	jne    802d2f <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802cb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cb8:	89 d0                	mov    %edx,%eax
  802cba:	01 c0                	add    %eax,%eax
  802cbc:	01 d0                	add    %edx,%eax
  802cbe:	c1 e0 02             	shl    $0x2,%eax
  802cc1:	05 40 20 81 00       	add    $0x812040,%eax
  802cc6:	8b 10                	mov    (%eax),%edx
  802cc8:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802ccb:	89 c8                	mov    %ecx,%eax
  802ccd:	01 c0                	add    %eax,%eax
  802ccf:	01 c8                	add    %ecx,%eax
  802cd1:	c1 e0 02             	shl    $0x2,%eax
  802cd4:	05 40 20 81 00       	add    $0x812040,%eax
  802cd9:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802cdb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cde:	89 d0                	mov    %edx,%eax
  802ce0:	01 c0                	add    %eax,%eax
  802ce2:	01 d0                	add    %edx,%eax
  802ce4:	c1 e0 02             	shl    $0x2,%eax
  802ce7:	05 44 20 81 00       	add    $0x812044,%eax
  802cec:	8b 08                	mov    (%eax),%ecx
  802cee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf1:	89 d0                	mov    %edx,%eax
  802cf3:	01 c0                	add    %eax,%eax
  802cf5:	01 d0                	add    %edx,%eax
  802cf7:	c1 e0 02             	shl    $0x2,%eax
  802cfa:	05 44 20 81 00       	add    $0x812044,%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	01 c1                	add    %eax,%ecx
  802d03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d06:	89 d0                	mov    %edx,%eax
  802d08:	01 c0                	add    %eax,%eax
  802d0a:	01 d0                	add    %edx,%eax
  802d0c:	c1 e0 02             	shl    $0x2,%eax
  802d0f:	05 44 20 81 00       	add    $0x812044,%eax
  802d14:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802d16:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d19:	89 d0                	mov    %edx,%eax
  802d1b:	01 c0                	add    %eax,%eax
  802d1d:	01 d0                	add    %edx,%eax
  802d1f:	c1 e0 02             	shl    $0x2,%eax
  802d22:	05 48 20 81 00       	add    $0x812048,%eax
  802d27:	c6 00 00             	movb   $0x0,(%eax)
  802d2a:	e9 91 00 00 00       	jmp    802dc0 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d32:	89 d0                	mov    %edx,%eax
  802d34:	01 c0                	add    %eax,%eax
  802d36:	01 d0                	add    %edx,%eax
  802d38:	c1 e0 02             	shl    $0x2,%eax
  802d3b:	05 40 20 81 00       	add    $0x812040,%eax
  802d40:	8b 08                	mov    (%eax),%ecx
  802d42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d45:	89 d0                	mov    %edx,%eax
  802d47:	01 c0                	add    %eax,%eax
  802d49:	01 d0                	add    %edx,%eax
  802d4b:	c1 e0 02             	shl    $0x2,%eax
  802d4e:	05 44 20 81 00       	add    $0x812044,%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	01 c1                	add    %eax,%ecx
  802d57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d5a:	89 d0                	mov    %edx,%eax
  802d5c:	01 c0                	add    %eax,%eax
  802d5e:	01 d0                	add    %edx,%eax
  802d60:	c1 e0 02             	shl    $0x2,%eax
  802d63:	05 40 20 81 00       	add    $0x812040,%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	39 c1                	cmp    %eax,%ecx
  802d6c:	75 52                	jne    802dc0 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802d6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d71:	89 d0                	mov    %edx,%eax
  802d73:	01 c0                	add    %eax,%eax
  802d75:	01 d0                	add    %edx,%eax
  802d77:	c1 e0 02             	shl    $0x2,%eax
  802d7a:	05 44 20 81 00       	add    $0x812044,%eax
  802d7f:	8b 08                	mov    (%eax),%ecx
  802d81:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d84:	89 d0                	mov    %edx,%eax
  802d86:	01 c0                	add    %eax,%eax
  802d88:	01 d0                	add    %edx,%eax
  802d8a:	c1 e0 02             	shl    $0x2,%eax
  802d8d:	05 44 20 81 00       	add    $0x812044,%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	01 c1                	add    %eax,%ecx
  802d96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d99:	89 d0                	mov    %edx,%eax
  802d9b:	01 c0                	add    %eax,%eax
  802d9d:	01 d0                	add    %edx,%eax
  802d9f:	c1 e0 02             	shl    $0x2,%eax
  802da2:	05 44 20 81 00       	add    $0x812044,%eax
  802da7:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802da9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dac:	89 d0                	mov    %edx,%eax
  802dae:	01 c0                	add    %eax,%eax
  802db0:	01 d0                	add    %edx,%eax
  802db2:	c1 e0 02             	shl    $0x2,%eax
  802db5:	05 48 20 81 00       	add    $0x812048,%eax
  802dba:	c6 00 00             	movb   $0x0,(%eax)
  802dbd:	eb 01                	jmp    802dc0 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802dbf:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802dc0:	ff 45 e0             	incl   -0x20(%ebp)
  802dc3:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802dca:	0f 8e 7f fe ff ff    	jle    802c4f <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802dd0:	a1 30 61 83 00       	mov    0x836130,%eax
  802dd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802dd8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802ddf:	eb 53                	jmp    802e34 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802de1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802de4:	89 d0                	mov    %edx,%eax
  802de6:	01 c0                	add    %eax,%eax
  802de8:	01 d0                	add    %edx,%eax
  802dea:	c1 e0 02             	shl    $0x2,%eax
  802ded:	05 48 60 80 00       	add    $0x806048,%eax
  802df2:	8a 00                	mov    (%eax),%al
  802df4:	84 c0                	test   %al,%al
  802df6:	74 39                	je     802e31 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802df8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802dfb:	89 d0                	mov    %edx,%eax
  802dfd:	01 c0                	add    %eax,%eax
  802dff:	01 d0                	add    %edx,%eax
  802e01:	c1 e0 02             	shl    $0x2,%eax
  802e04:	05 40 60 80 00       	add    $0x806040,%eax
  802e09:	8b 08                	mov    (%eax),%ecx
  802e0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e0e:	89 d0                	mov    %edx,%eax
  802e10:	01 c0                	add    %eax,%eax
  802e12:	01 d0                	add    %edx,%eax
  802e14:	c1 e0 02             	shl    $0x2,%eax
  802e17:	05 44 60 80 00       	add    $0x806044,%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	01 c8                	add    %ecx,%eax
  802e20:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802e23:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e26:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802e29:	76 06                	jbe    802e31 <realloc+0x453>
  802e2b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e31:	ff 45 d8             	incl   -0x28(%ebp)
  802e34:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802e3b:	7e a4                	jle    802de1 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802e3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e40:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	e9 a9 01 00 00       	jmp    802ff6 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802e4d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	01 d0                	add    %edx,%eax
  802e55:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802e58:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e5f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802e66:	eb 57                	jmp    802ebf <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802e68:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e6b:	89 d0                	mov    %edx,%eax
  802e6d:	01 c0                	add    %eax,%eax
  802e6f:	01 d0                	add    %edx,%eax
  802e71:	c1 e0 02             	shl    $0x2,%eax
  802e74:	05 48 20 81 00       	add    $0x812048,%eax
  802e79:	8a 00                	mov    (%eax),%al
  802e7b:	84 c0                	test   %al,%al
  802e7d:	74 3d                	je     802ebc <realloc+0x4de>
  802e7f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e82:	89 d0                	mov    %edx,%eax
  802e84:	01 c0                	add    %eax,%eax
  802e86:	01 d0                	add    %edx,%eax
  802e88:	c1 e0 02             	shl    $0x2,%eax
  802e8b:	05 40 20 81 00       	add    $0x812040,%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e95:	75 25                	jne    802ebc <realloc+0x4de>
  802e97:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e9a:	89 d0                	mov    %edx,%eax
  802e9c:	01 c0                	add    %eax,%eax
  802e9e:	01 d0                	add    %edx,%eax
  802ea0:	c1 e0 02             	shl    $0x2,%eax
  802ea3:	05 44 20 81 00       	add    $0x812044,%eax
  802ea8:	8b 10                	mov    (%eax),%edx
  802eaa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ead:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802eb0:	39 c2                	cmp    %eax,%edx
  802eb2:	72 08                	jb     802ebc <realloc+0x4de>
		{
			adjIdx = j; break;
  802eb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802eb7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802eba:	eb 0c                	jmp    802ec8 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ebc:	ff 45 d0             	incl   -0x30(%ebp)
  802ebf:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802ec6:	7e a0                	jle    802e68 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802ec8:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802ecc:	0f 84 d6 00 00 00    	je     802fa8 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802ed2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ed5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ed8:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802edb:	83 ec 08             	sub    $0x8,%esp
  802ede:	ff 75 a0             	pushl  -0x60(%ebp)
  802ee1:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ee4:	e8 cf 09 00 00       	call   8038b8 <sys_allocate_user_mem>
  802ee9:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802eec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eef:	89 d0                	mov    %edx,%eax
  802ef1:	01 c0                	add    %eax,%eax
  802ef3:	01 d0                	add    %edx,%eax
  802ef5:	c1 e0 02             	shl    $0x2,%eax
  802ef8:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802efe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f01:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802f03:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f06:	89 d0                	mov    %edx,%eax
  802f08:	01 c0                	add    %eax,%eax
  802f0a:	01 d0                	add    %edx,%eax
  802f0c:	c1 e0 02             	shl    $0x2,%eax
  802f0f:	05 40 20 81 00       	add    $0x812040,%eax
  802f14:	8b 10                	mov    (%eax),%edx
  802f16:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f19:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802f1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f1f:	89 d0                	mov    %edx,%eax
  802f21:	01 c0                	add    %eax,%eax
  802f23:	01 d0                	add    %edx,%eax
  802f25:	c1 e0 02             	shl    $0x2,%eax
  802f28:	05 40 20 81 00       	add    $0x812040,%eax
  802f2d:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802f2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f32:	89 d0                	mov    %edx,%eax
  802f34:	01 c0                	add    %eax,%eax
  802f36:	01 d0                	add    %edx,%eax
  802f38:	c1 e0 02             	shl    $0x2,%eax
  802f3b:	05 44 20 81 00       	add    $0x812044,%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802f45:	89 c2                	mov    %eax,%edx
  802f47:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802f4a:	89 c8                	mov    %ecx,%eax
  802f4c:	01 c0                	add    %eax,%eax
  802f4e:	01 c8                	add    %ecx,%eax
  802f50:	c1 e0 02             	shl    $0x2,%eax
  802f53:	05 44 20 81 00       	add    $0x812044,%eax
  802f58:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802f5a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f5d:	89 d0                	mov    %edx,%eax
  802f5f:	01 c0                	add    %eax,%eax
  802f61:	01 d0                	add    %edx,%eax
  802f63:	c1 e0 02             	shl    $0x2,%eax
  802f66:	05 44 20 81 00       	add    $0x812044,%eax
  802f6b:	8b 00                	mov    (%eax),%eax
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	75 14                	jne    802f85 <realloc+0x5a7>
  802f71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f74:	89 d0                	mov    %edx,%eax
  802f76:	01 c0                	add    %eax,%eax
  802f78:	01 d0                	add    %edx,%eax
  802f7a:	c1 e0 02             	shl    $0x2,%eax
  802f7d:	05 48 20 81 00       	add    $0x812048,%eax
  802f82:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802f85:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f88:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f8b:	01 c2                	add    %eax,%edx
  802f8d:	a1 88 60 83 00       	mov    0x836088,%eax
  802f92:	39 c2                	cmp    %eax,%edx
  802f94:	76 0d                	jbe    802fa3 <realloc+0x5c5>
  802f96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f99:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f9c:	01 d0                	add    %edx,%eax
  802f9e:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	eb 4e                	jmp    802ff6 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802fa8:	83 ec 0c             	sub    $0xc,%esp
  802fab:	ff 75 0c             	pushl  0xc(%ebp)
  802fae:	e8 0b ec ff ff       	call   801bbe <malloc>
  802fb3:	83 c4 10             	add    $0x10,%esp
  802fb6:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802fb9:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802fbd:	75 07                	jne    802fc6 <realloc+0x5e8>
		return NULL;
  802fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc4:	eb 30                	jmp    802ff6 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fcc:	39 d0                	cmp    %edx,%eax
  802fce:	76 02                	jbe    802fd2 <realloc+0x5f4>
  802fd0:	89 d0                	mov    %edx,%eax
  802fd2:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	50                   	push   %eax
  802fd9:	52                   	push   %edx
  802fda:	ff 75 cc             	pushl  -0x34(%ebp)
  802fdd:	e8 cf 06 00 00       	call   8036b1 <sys_move_user_mem>
  802fe2:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802fe5:	83 ec 0c             	sub    $0xc,%esp
  802fe8:	ff 75 08             	pushl  0x8(%ebp)
  802feb:	e8 2e ef ff ff       	call   801f1e <free>
  802ff0:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802ff3:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802ff6:	c9                   	leave  
  802ff7:	c3                   	ret    

00802ff8 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802ff8:	55                   	push   %ebp
  802ff9:	89 e5                	mov    %esp,%ebp
  802ffb:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  803004:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803008:	0f 84 33 03 00 00    	je     803341 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  80300e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803011:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  803016:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  803019:	83 ec 08             	sub    $0x8,%esp
  80301c:	ff 75 08             	pushl  0x8(%ebp)
  80301f:	ff 75 d8             	pushl  -0x28(%ebp)
  803022:	e8 7d 05 00 00       	call   8035a4 <sys_delete_shared_object>
  803027:	83 c4 10             	add    $0x10,%esp
  80302a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  80302d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803031:	0f 88 0d 03 00 00    	js     803344 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803037:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80303e:	e9 ef 02 00 00       	jmp    803332 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803046:	89 d0                	mov    %edx,%eax
  803048:	01 c0                	add    %eax,%eax
  80304a:	01 d0                	add    %edx,%eax
  80304c:	c1 e0 02             	shl    $0x2,%eax
  80304f:	05 48 60 80 00       	add    $0x806048,%eax
  803054:	8a 00                	mov    (%eax),%al
  803056:	84 c0                	test   %al,%al
  803058:	0f 84 d1 02 00 00    	je     80332f <sfree+0x337>
  80305e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803061:	89 d0                	mov    %edx,%eax
  803063:	01 c0                	add    %eax,%eax
  803065:	01 d0                	add    %edx,%eax
  803067:	c1 e0 02             	shl    $0x2,%eax
  80306a:	05 40 60 80 00       	add    $0x806040,%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803074:	0f 85 b5 02 00 00    	jne    80332f <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  80307a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307d:	89 d0                	mov    %edx,%eax
  80307f:	01 c0                	add    %eax,%eax
  803081:	01 d0                	add    %edx,%eax
  803083:	c1 e0 02             	shl    $0x2,%eax
  803086:	05 44 60 80 00       	add    $0x806044,%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803090:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803093:	89 d0                	mov    %edx,%eax
  803095:	01 c0                	add    %eax,%eax
  803097:	01 d0                	add    %edx,%eax
  803099:	c1 e0 02             	shl    $0x2,%eax
  80309c:	05 48 60 80 00       	add    $0x806048,%eax
  8030a1:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  8030a4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8030ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8030b2:	eb 64                	jmp    803118 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  8030b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030b7:	89 d0                	mov    %edx,%eax
  8030b9:	01 c0                	add    %eax,%eax
  8030bb:	01 d0                	add    %edx,%eax
  8030bd:	c1 e0 02             	shl    $0x2,%eax
  8030c0:	05 48 20 81 00       	add    $0x812048,%eax
  8030c5:	8a 00                	mov    (%eax),%al
  8030c7:	84 c0                	test   %al,%al
  8030c9:	75 4a                	jne    803115 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  8030cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ce:	89 d0                	mov    %edx,%eax
  8030d0:	01 c0                	add    %eax,%eax
  8030d2:	01 d0                	add    %edx,%eax
  8030d4:	c1 e0 02             	shl    $0x2,%eax
  8030d7:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8030dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e0:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  8030e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030e5:	89 d0                	mov    %edx,%eax
  8030e7:	01 c0                	add    %eax,%eax
  8030e9:	01 d0                	add    %edx,%eax
  8030eb:	c1 e0 02             	shl    $0x2,%eax
  8030ee:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  8030f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030f7:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  8030f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030fc:	89 d0                	mov    %edx,%eax
  8030fe:	01 c0                	add    %eax,%eax
  803100:	01 d0                	add    %edx,%eax
  803102:	c1 e0 02             	shl    $0x2,%eax
  803105:	05 48 20 81 00       	add    $0x812048,%eax
  80310a:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  80310d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803110:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  803113:	eb 0c                	jmp    803121 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803115:	ff 45 ec             	incl   -0x14(%ebp)
  803118:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80311f:	7e 93                	jle    8030b4 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  803121:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803125:	0f 84 8d 01 00 00    	je     8032b8 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80312b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803132:	e9 74 01 00 00       	jmp    8032ab <sfree+0x2b3>
				{
					if (k == fidx) continue;
  803137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80313d:	0f 84 64 01 00 00    	je     8032a7 <sfree+0x2af>
					if (uhp_frees[k].free)
  803143:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803146:	89 d0                	mov    %edx,%eax
  803148:	01 c0                	add    %eax,%eax
  80314a:	01 d0                	add    %edx,%eax
  80314c:	c1 e0 02             	shl    $0x2,%eax
  80314f:	05 48 20 81 00       	add    $0x812048,%eax
  803154:	8a 00                	mov    (%eax),%al
  803156:	84 c0                	test   %al,%al
  803158:	0f 84 4a 01 00 00    	je     8032a8 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80315e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803161:	89 d0                	mov    %edx,%eax
  803163:	01 c0                	add    %eax,%eax
  803165:	01 d0                	add    %edx,%eax
  803167:	c1 e0 02             	shl    $0x2,%eax
  80316a:	05 40 20 81 00       	add    $0x812040,%eax
  80316f:	8b 08                	mov    (%eax),%ecx
  803171:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803174:	89 d0                	mov    %edx,%eax
  803176:	01 c0                	add    %eax,%eax
  803178:	01 d0                	add    %edx,%eax
  80317a:	c1 e0 02             	shl    $0x2,%eax
  80317d:	05 44 20 81 00       	add    $0x812044,%eax
  803182:	8b 00                	mov    (%eax),%eax
  803184:	01 c1                	add    %eax,%ecx
  803186:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803189:	89 d0                	mov    %edx,%eax
  80318b:	01 c0                	add    %eax,%eax
  80318d:	01 d0                	add    %edx,%eax
  80318f:	c1 e0 02             	shl    $0x2,%eax
  803192:	05 40 20 81 00       	add    $0x812040,%eax
  803197:	8b 00                	mov    (%eax),%eax
  803199:	39 c1                	cmp    %eax,%ecx
  80319b:	75 7a                	jne    803217 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  80319d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a0:	89 d0                	mov    %edx,%eax
  8031a2:	01 c0                	add    %eax,%eax
  8031a4:	01 d0                	add    %edx,%eax
  8031a6:	c1 e0 02             	shl    $0x2,%eax
  8031a9:	05 40 20 81 00       	add    $0x812040,%eax
  8031ae:	8b 10                	mov    (%eax),%edx
  8031b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8031b3:	89 c8                	mov    %ecx,%eax
  8031b5:	01 c0                	add    %eax,%eax
  8031b7:	01 c8                	add    %ecx,%eax
  8031b9:	c1 e0 02             	shl    $0x2,%eax
  8031bc:	05 40 20 81 00       	add    $0x812040,%eax
  8031c1:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  8031c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c6:	89 d0                	mov    %edx,%eax
  8031c8:	01 c0                	add    %eax,%eax
  8031ca:	01 d0                	add    %edx,%eax
  8031cc:	c1 e0 02             	shl    $0x2,%eax
  8031cf:	05 44 20 81 00       	add    $0x812044,%eax
  8031d4:	8b 08                	mov    (%eax),%ecx
  8031d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d9:	89 d0                	mov    %edx,%eax
  8031db:	01 c0                	add    %eax,%eax
  8031dd:	01 d0                	add    %edx,%eax
  8031df:	c1 e0 02             	shl    $0x2,%eax
  8031e2:	05 44 20 81 00       	add    $0x812044,%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	01 c1                	add    %eax,%ecx
  8031eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ee:	89 d0                	mov    %edx,%eax
  8031f0:	01 c0                	add    %eax,%eax
  8031f2:	01 d0                	add    %edx,%eax
  8031f4:	c1 e0 02             	shl    $0x2,%eax
  8031f7:	05 44 20 81 00       	add    $0x812044,%eax
  8031fc:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8031fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803201:	89 d0                	mov    %edx,%eax
  803203:	01 c0                	add    %eax,%eax
  803205:	01 d0                	add    %edx,%eax
  803207:	c1 e0 02             	shl    $0x2,%eax
  80320a:	05 48 20 81 00       	add    $0x812048,%eax
  80320f:	c6 00 00             	movb   $0x0,(%eax)
  803212:	e9 91 00 00 00       	jmp    8032a8 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803217:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321a:	89 d0                	mov    %edx,%eax
  80321c:	01 c0                	add    %eax,%eax
  80321e:	01 d0                	add    %edx,%eax
  803220:	c1 e0 02             	shl    $0x2,%eax
  803223:	05 40 20 81 00       	add    $0x812040,%eax
  803228:	8b 08                	mov    (%eax),%ecx
  80322a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80322d:	89 d0                	mov    %edx,%eax
  80322f:	01 c0                	add    %eax,%eax
  803231:	01 d0                	add    %edx,%eax
  803233:	c1 e0 02             	shl    $0x2,%eax
  803236:	05 44 20 81 00       	add    $0x812044,%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	01 c1                	add    %eax,%ecx
  80323f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803242:	89 d0                	mov    %edx,%eax
  803244:	01 c0                	add    %eax,%eax
  803246:	01 d0                	add    %edx,%eax
  803248:	c1 e0 02             	shl    $0x2,%eax
  80324b:	05 40 20 81 00       	add    $0x812040,%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	39 c1                	cmp    %eax,%ecx
  803254:	75 52                	jne    8032a8 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803256:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803259:	89 d0                	mov    %edx,%eax
  80325b:	01 c0                	add    %eax,%eax
  80325d:	01 d0                	add    %edx,%eax
  80325f:	c1 e0 02             	shl    $0x2,%eax
  803262:	05 44 20 81 00       	add    $0x812044,%eax
  803267:	8b 08                	mov    (%eax),%ecx
  803269:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326c:	89 d0                	mov    %edx,%eax
  80326e:	01 c0                	add    %eax,%eax
  803270:	01 d0                	add    %edx,%eax
  803272:	c1 e0 02             	shl    $0x2,%eax
  803275:	05 44 20 81 00       	add    $0x812044,%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	01 c1                	add    %eax,%ecx
  80327e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803281:	89 d0                	mov    %edx,%eax
  803283:	01 c0                	add    %eax,%eax
  803285:	01 d0                	add    %edx,%eax
  803287:	c1 e0 02             	shl    $0x2,%eax
  80328a:	05 44 20 81 00       	add    $0x812044,%eax
  80328f:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803291:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803294:	89 d0                	mov    %edx,%eax
  803296:	01 c0                	add    %eax,%eax
  803298:	01 d0                	add    %edx,%eax
  80329a:	c1 e0 02             	shl    $0x2,%eax
  80329d:	05 48 20 81 00       	add    $0x812048,%eax
  8032a2:	c6 00 00             	movb   $0x0,(%eax)
  8032a5:	eb 01                	jmp    8032a8 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  8032a7:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8032a8:	ff 45 e8             	incl   -0x18(%ebp)
  8032ab:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8032b2:	0f 8e 7f fe ff ff    	jle    803137 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  8032b8:	a1 30 61 83 00       	mov    0x836130,%eax
  8032bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8032c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032c7:	eb 53                	jmp    80331c <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  8032c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032cc:	89 d0                	mov    %edx,%eax
  8032ce:	01 c0                	add    %eax,%eax
  8032d0:	01 d0                	add    %edx,%eax
  8032d2:	c1 e0 02             	shl    $0x2,%eax
  8032d5:	05 48 60 80 00       	add    $0x806048,%eax
  8032da:	8a 00                	mov    (%eax),%al
  8032dc:	84 c0                	test   %al,%al
  8032de:	74 39                	je     803319 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8032e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032e3:	89 d0                	mov    %edx,%eax
  8032e5:	01 c0                	add    %eax,%eax
  8032e7:	01 d0                	add    %edx,%eax
  8032e9:	c1 e0 02             	shl    $0x2,%eax
  8032ec:	05 40 60 80 00       	add    $0x806040,%eax
  8032f1:	8b 08                	mov    (%eax),%ecx
  8032f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032f6:	89 d0                	mov    %edx,%eax
  8032f8:	01 c0                	add    %eax,%eax
  8032fa:	01 d0                	add    %edx,%eax
  8032fc:	c1 e0 02             	shl    $0x2,%eax
  8032ff:	05 44 60 80 00       	add    $0x806044,%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	01 c8                	add    %ecx,%eax
  803308:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  80330b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80330e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803311:	76 06                	jbe    803319 <sfree+0x321>
  803313:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803319:	ff 45 e0             	incl   -0x20(%ebp)
  80331c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803323:	7e a4                	jle    8032c9 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803328:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  80332d:	eb 16                	jmp    803345 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80332f:	ff 45 f4             	incl   -0xc(%ebp)
  803332:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803339:	0f 8e 04 fd ff ff    	jle    803043 <sfree+0x4b>
  80333f:	eb 04                	jmp    803345 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803341:	90                   	nop
  803342:	eb 01                	jmp    803345 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803344:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803345:	c9                   	leave  
  803346:	c3                   	ret    

00803347 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803347:	55                   	push   %ebp
  803348:	89 e5                	mov    %esp,%ebp
  80334a:	57                   	push   %edi
  80334b:	56                   	push   %esi
  80334c:	53                   	push   %ebx
  80334d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	8b 55 0c             	mov    0xc(%ebp),%edx
  803356:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803359:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80335c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80335f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803362:	cd 30                	int    $0x30
  803364:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803367:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80336a:	83 c4 10             	add    $0x10,%esp
  80336d:	5b                   	pop    %ebx
  80336e:	5e                   	pop    %esi
  80336f:	5f                   	pop    %edi
  803370:	5d                   	pop    %ebp
  803371:	c3                   	ret    

00803372 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803372:	55                   	push   %ebp
  803373:	89 e5                	mov    %esp,%ebp
  803375:	83 ec 04             	sub    $0x4,%esp
  803378:	8b 45 10             	mov    0x10(%ebp),%eax
  80337b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80337e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803381:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	6a 00                	push   $0x0
  80338a:	51                   	push   %ecx
  80338b:	52                   	push   %edx
  80338c:	ff 75 0c             	pushl  0xc(%ebp)
  80338f:	50                   	push   %eax
  803390:	6a 00                	push   $0x0
  803392:	e8 b0 ff ff ff       	call   803347 <syscall>
  803397:	83 c4 18             	add    $0x18,%esp
}
  80339a:	90                   	nop
  80339b:	c9                   	leave  
  80339c:	c3                   	ret    

0080339d <sys_cgetc>:

int
sys_cgetc(void)
{
  80339d:	55                   	push   %ebp
  80339e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8033a0:	6a 00                	push   $0x0
  8033a2:	6a 00                	push   $0x0
  8033a4:	6a 00                	push   $0x0
  8033a6:	6a 00                	push   $0x0
  8033a8:	6a 00                	push   $0x0
  8033aa:	6a 02                	push   $0x2
  8033ac:	e8 96 ff ff ff       	call   803347 <syscall>
  8033b1:	83 c4 18             	add    $0x18,%esp
}
  8033b4:	c9                   	leave  
  8033b5:	c3                   	ret    

008033b6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8033b6:	55                   	push   %ebp
  8033b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8033b9:	6a 00                	push   $0x0
  8033bb:	6a 00                	push   $0x0
  8033bd:	6a 00                	push   $0x0
  8033bf:	6a 00                	push   $0x0
  8033c1:	6a 00                	push   $0x0
  8033c3:	6a 03                	push   $0x3
  8033c5:	e8 7d ff ff ff       	call   803347 <syscall>
  8033ca:	83 c4 18             	add    $0x18,%esp
}
  8033cd:	90                   	nop
  8033ce:	c9                   	leave  
  8033cf:	c3                   	ret    

008033d0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8033d0:	55                   	push   %ebp
  8033d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8033d3:	6a 00                	push   $0x0
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	6a 00                	push   $0x0
  8033db:	6a 00                	push   $0x0
  8033dd:	6a 04                	push   $0x4
  8033df:	e8 63 ff ff ff       	call   803347 <syscall>
  8033e4:	83 c4 18             	add    $0x18,%esp
}
  8033e7:	90                   	nop
  8033e8:	c9                   	leave  
  8033e9:	c3                   	ret    

008033ea <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8033ea:	55                   	push   %ebp
  8033eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8033ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	6a 00                	push   $0x0
  8033f5:	6a 00                	push   $0x0
  8033f7:	6a 00                	push   $0x0
  8033f9:	52                   	push   %edx
  8033fa:	50                   	push   %eax
  8033fb:	6a 08                	push   $0x8
  8033fd:	e8 45 ff ff ff       	call   803347 <syscall>
  803402:	83 c4 18             	add    $0x18,%esp
}
  803405:	c9                   	leave  
  803406:	c3                   	ret    

00803407 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803407:	55                   	push   %ebp
  803408:	89 e5                	mov    %esp,%ebp
  80340a:	56                   	push   %esi
  80340b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80340c:	8b 75 18             	mov    0x18(%ebp),%esi
  80340f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803412:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803415:	8b 55 0c             	mov    0xc(%ebp),%edx
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	56                   	push   %esi
  80341c:	53                   	push   %ebx
  80341d:	51                   	push   %ecx
  80341e:	52                   	push   %edx
  80341f:	50                   	push   %eax
  803420:	6a 09                	push   $0x9
  803422:	e8 20 ff ff ff       	call   803347 <syscall>
  803427:	83 c4 18             	add    $0x18,%esp
}
  80342a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80342d:	5b                   	pop    %ebx
  80342e:	5e                   	pop    %esi
  80342f:	5d                   	pop    %ebp
  803430:	c3                   	ret    

00803431 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803431:	55                   	push   %ebp
  803432:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803434:	6a 00                	push   $0x0
  803436:	6a 00                	push   $0x0
  803438:	6a 00                	push   $0x0
  80343a:	6a 00                	push   $0x0
  80343c:	ff 75 08             	pushl  0x8(%ebp)
  80343f:	6a 0a                	push   $0xa
  803441:	e8 01 ff ff ff       	call   803347 <syscall>
  803446:	83 c4 18             	add    $0x18,%esp
}
  803449:	c9                   	leave  
  80344a:	c3                   	ret    

0080344b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80344b:	55                   	push   %ebp
  80344c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80344e:	6a 00                	push   $0x0
  803450:	6a 00                	push   $0x0
  803452:	6a 00                	push   $0x0
  803454:	ff 75 0c             	pushl  0xc(%ebp)
  803457:	ff 75 08             	pushl  0x8(%ebp)
  80345a:	6a 0b                	push   $0xb
  80345c:	e8 e6 fe ff ff       	call   803347 <syscall>
  803461:	83 c4 18             	add    $0x18,%esp
}
  803464:	c9                   	leave  
  803465:	c3                   	ret    

00803466 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803466:	55                   	push   %ebp
  803467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803469:	6a 00                	push   $0x0
  80346b:	6a 00                	push   $0x0
  80346d:	6a 00                	push   $0x0
  80346f:	6a 00                	push   $0x0
  803471:	6a 00                	push   $0x0
  803473:	6a 0c                	push   $0xc
  803475:	e8 cd fe ff ff       	call   803347 <syscall>
  80347a:	83 c4 18             	add    $0x18,%esp
}
  80347d:	c9                   	leave  
  80347e:	c3                   	ret    

0080347f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80347f:	55                   	push   %ebp
  803480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803482:	6a 00                	push   $0x0
  803484:	6a 00                	push   $0x0
  803486:	6a 00                	push   $0x0
  803488:	6a 00                	push   $0x0
  80348a:	6a 00                	push   $0x0
  80348c:	6a 0d                	push   $0xd
  80348e:	e8 b4 fe ff ff       	call   803347 <syscall>
  803493:	83 c4 18             	add    $0x18,%esp
}
  803496:	c9                   	leave  
  803497:	c3                   	ret    

00803498 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803498:	55                   	push   %ebp
  803499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80349b:	6a 00                	push   $0x0
  80349d:	6a 00                	push   $0x0
  80349f:	6a 00                	push   $0x0
  8034a1:	6a 00                	push   $0x0
  8034a3:	6a 00                	push   $0x0
  8034a5:	6a 0e                	push   $0xe
  8034a7:	e8 9b fe ff ff       	call   803347 <syscall>
  8034ac:	83 c4 18             	add    $0x18,%esp
}
  8034af:	c9                   	leave  
  8034b0:	c3                   	ret    

008034b1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8034b1:	55                   	push   %ebp
  8034b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8034b4:	6a 00                	push   $0x0
  8034b6:	6a 00                	push   $0x0
  8034b8:	6a 00                	push   $0x0
  8034ba:	6a 00                	push   $0x0
  8034bc:	6a 00                	push   $0x0
  8034be:	6a 0f                	push   $0xf
  8034c0:	e8 82 fe ff ff       	call   803347 <syscall>
  8034c5:	83 c4 18             	add    $0x18,%esp
}
  8034c8:	c9                   	leave  
  8034c9:	c3                   	ret    

008034ca <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8034ca:	55                   	push   %ebp
  8034cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8034cd:	6a 00                	push   $0x0
  8034cf:	6a 00                	push   $0x0
  8034d1:	6a 00                	push   $0x0
  8034d3:	6a 00                	push   $0x0
  8034d5:	ff 75 08             	pushl  0x8(%ebp)
  8034d8:	6a 10                	push   $0x10
  8034da:	e8 68 fe ff ff       	call   803347 <syscall>
  8034df:	83 c4 18             	add    $0x18,%esp
}
  8034e2:	c9                   	leave  
  8034e3:	c3                   	ret    

008034e4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8034e4:	55                   	push   %ebp
  8034e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8034e7:	6a 00                	push   $0x0
  8034e9:	6a 00                	push   $0x0
  8034eb:	6a 00                	push   $0x0
  8034ed:	6a 00                	push   $0x0
  8034ef:	6a 00                	push   $0x0
  8034f1:	6a 11                	push   $0x11
  8034f3:	e8 4f fe ff ff       	call   803347 <syscall>
  8034f8:	83 c4 18             	add    $0x18,%esp
}
  8034fb:	90                   	nop
  8034fc:	c9                   	leave  
  8034fd:	c3                   	ret    

008034fe <sys_cputc>:

void
sys_cputc(const char c)
{
  8034fe:	55                   	push   %ebp
  8034ff:	89 e5                	mov    %esp,%ebp
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	8b 45 08             	mov    0x8(%ebp),%eax
  803507:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80350a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80350e:	6a 00                	push   $0x0
  803510:	6a 00                	push   $0x0
  803512:	6a 00                	push   $0x0
  803514:	6a 00                	push   $0x0
  803516:	50                   	push   %eax
  803517:	6a 01                	push   $0x1
  803519:	e8 29 fe ff ff       	call   803347 <syscall>
  80351e:	83 c4 18             	add    $0x18,%esp
}
  803521:	90                   	nop
  803522:	c9                   	leave  
  803523:	c3                   	ret    

00803524 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803524:	55                   	push   %ebp
  803525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803527:	6a 00                	push   $0x0
  803529:	6a 00                	push   $0x0
  80352b:	6a 00                	push   $0x0
  80352d:	6a 00                	push   $0x0
  80352f:	6a 00                	push   $0x0
  803531:	6a 14                	push   $0x14
  803533:	e8 0f fe ff ff       	call   803347 <syscall>
  803538:	83 c4 18             	add    $0x18,%esp
}
  80353b:	90                   	nop
  80353c:	c9                   	leave  
  80353d:	c3                   	ret    

0080353e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80353e:	55                   	push   %ebp
  80353f:	89 e5                	mov    %esp,%ebp
  803541:	83 ec 04             	sub    $0x4,%esp
  803544:	8b 45 10             	mov    0x10(%ebp),%eax
  803547:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80354a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80354d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	6a 00                	push   $0x0
  803556:	51                   	push   %ecx
  803557:	52                   	push   %edx
  803558:	ff 75 0c             	pushl  0xc(%ebp)
  80355b:	50                   	push   %eax
  80355c:	6a 15                	push   $0x15
  80355e:	e8 e4 fd ff ff       	call   803347 <syscall>
  803563:	83 c4 18             	add    $0x18,%esp
}
  803566:	c9                   	leave  
  803567:	c3                   	ret    

00803568 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803568:	55                   	push   %ebp
  803569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80356b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	6a 00                	push   $0x0
  803573:	6a 00                	push   $0x0
  803575:	6a 00                	push   $0x0
  803577:	52                   	push   %edx
  803578:	50                   	push   %eax
  803579:	6a 16                	push   $0x16
  80357b:	e8 c7 fd ff ff       	call   803347 <syscall>
  803580:	83 c4 18             	add    $0x18,%esp
}
  803583:	c9                   	leave  
  803584:	c3                   	ret    

00803585 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803585:	55                   	push   %ebp
  803586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803588:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80358b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358e:	8b 45 08             	mov    0x8(%ebp),%eax
  803591:	6a 00                	push   $0x0
  803593:	6a 00                	push   $0x0
  803595:	51                   	push   %ecx
  803596:	52                   	push   %edx
  803597:	50                   	push   %eax
  803598:	6a 17                	push   $0x17
  80359a:	e8 a8 fd ff ff       	call   803347 <syscall>
  80359f:	83 c4 18             	add    $0x18,%esp
}
  8035a2:	c9                   	leave  
  8035a3:	c3                   	ret    

008035a4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8035a4:	55                   	push   %ebp
  8035a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8035a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	6a 00                	push   $0x0
  8035af:	6a 00                	push   $0x0
  8035b1:	6a 00                	push   $0x0
  8035b3:	52                   	push   %edx
  8035b4:	50                   	push   %eax
  8035b5:	6a 18                	push   $0x18
  8035b7:	e8 8b fd ff ff       	call   803347 <syscall>
  8035bc:	83 c4 18             	add    $0x18,%esp
}
  8035bf:	c9                   	leave  
  8035c0:	c3                   	ret    

008035c1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8035c1:	55                   	push   %ebp
  8035c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	6a 00                	push   $0x0
  8035c9:	ff 75 14             	pushl  0x14(%ebp)
  8035cc:	ff 75 10             	pushl  0x10(%ebp)
  8035cf:	ff 75 0c             	pushl  0xc(%ebp)
  8035d2:	50                   	push   %eax
  8035d3:	6a 19                	push   $0x19
  8035d5:	e8 6d fd ff ff       	call   803347 <syscall>
  8035da:	83 c4 18             	add    $0x18,%esp
}
  8035dd:	c9                   	leave  
  8035de:	c3                   	ret    

008035df <sys_run_env>:

void sys_run_env(int32 envId)
{
  8035df:	55                   	push   %ebp
  8035e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	6a 00                	push   $0x0
  8035e7:	6a 00                	push   $0x0
  8035e9:	6a 00                	push   $0x0
  8035eb:	6a 00                	push   $0x0
  8035ed:	50                   	push   %eax
  8035ee:	6a 1a                	push   $0x1a
  8035f0:	e8 52 fd ff ff       	call   803347 <syscall>
  8035f5:	83 c4 18             	add    $0x18,%esp
}
  8035f8:	90                   	nop
  8035f9:	c9                   	leave  
  8035fa:	c3                   	ret    

008035fb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8035fb:	55                   	push   %ebp
  8035fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	6a 00                	push   $0x0
  803603:	6a 00                	push   $0x0
  803605:	6a 00                	push   $0x0
  803607:	6a 00                	push   $0x0
  803609:	50                   	push   %eax
  80360a:	6a 1b                	push   $0x1b
  80360c:	e8 36 fd ff ff       	call   803347 <syscall>
  803611:	83 c4 18             	add    $0x18,%esp
}
  803614:	c9                   	leave  
  803615:	c3                   	ret    

00803616 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803616:	55                   	push   %ebp
  803617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803619:	6a 00                	push   $0x0
  80361b:	6a 00                	push   $0x0
  80361d:	6a 00                	push   $0x0
  80361f:	6a 00                	push   $0x0
  803621:	6a 00                	push   $0x0
  803623:	6a 05                	push   $0x5
  803625:	e8 1d fd ff ff       	call   803347 <syscall>
  80362a:	83 c4 18             	add    $0x18,%esp
}
  80362d:	c9                   	leave  
  80362e:	c3                   	ret    

0080362f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80362f:	55                   	push   %ebp
  803630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803632:	6a 00                	push   $0x0
  803634:	6a 00                	push   $0x0
  803636:	6a 00                	push   $0x0
  803638:	6a 00                	push   $0x0
  80363a:	6a 00                	push   $0x0
  80363c:	6a 06                	push   $0x6
  80363e:	e8 04 fd ff ff       	call   803347 <syscall>
  803643:	83 c4 18             	add    $0x18,%esp
}
  803646:	c9                   	leave  
  803647:	c3                   	ret    

00803648 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803648:	55                   	push   %ebp
  803649:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80364b:	6a 00                	push   $0x0
  80364d:	6a 00                	push   $0x0
  80364f:	6a 00                	push   $0x0
  803651:	6a 00                	push   $0x0
  803653:	6a 00                	push   $0x0
  803655:	6a 07                	push   $0x7
  803657:	e8 eb fc ff ff       	call   803347 <syscall>
  80365c:	83 c4 18             	add    $0x18,%esp
}
  80365f:	c9                   	leave  
  803660:	c3                   	ret    

00803661 <sys_exit_env>:


void sys_exit_env(void)
{
  803661:	55                   	push   %ebp
  803662:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803664:	6a 00                	push   $0x0
  803666:	6a 00                	push   $0x0
  803668:	6a 00                	push   $0x0
  80366a:	6a 00                	push   $0x0
  80366c:	6a 00                	push   $0x0
  80366e:	6a 1c                	push   $0x1c
  803670:	e8 d2 fc ff ff       	call   803347 <syscall>
  803675:	83 c4 18             	add    $0x18,%esp
}
  803678:	90                   	nop
  803679:	c9                   	leave  
  80367a:	c3                   	ret    

0080367b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80367b:	55                   	push   %ebp
  80367c:	89 e5                	mov    %esp,%ebp
  80367e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803681:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803684:	8d 50 04             	lea    0x4(%eax),%edx
  803687:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80368a:	6a 00                	push   $0x0
  80368c:	6a 00                	push   $0x0
  80368e:	6a 00                	push   $0x0
  803690:	52                   	push   %edx
  803691:	50                   	push   %eax
  803692:	6a 1d                	push   $0x1d
  803694:	e8 ae fc ff ff       	call   803347 <syscall>
  803699:	83 c4 18             	add    $0x18,%esp
	return result;
  80369c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80369f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8036a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036a5:	89 01                	mov    %eax,(%ecx)
  8036a7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	c9                   	leave  
  8036ae:	c2 04 00             	ret    $0x4

008036b1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8036b1:	55                   	push   %ebp
  8036b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8036b4:	6a 00                	push   $0x0
  8036b6:	6a 00                	push   $0x0
  8036b8:	ff 75 10             	pushl  0x10(%ebp)
  8036bb:	ff 75 0c             	pushl  0xc(%ebp)
  8036be:	ff 75 08             	pushl  0x8(%ebp)
  8036c1:	6a 13                	push   $0x13
  8036c3:	e8 7f fc ff ff       	call   803347 <syscall>
  8036c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8036cb:	90                   	nop
}
  8036cc:	c9                   	leave  
  8036cd:	c3                   	ret    

008036ce <sys_rcr2>:
uint32 sys_rcr2()
{
  8036ce:	55                   	push   %ebp
  8036cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8036d1:	6a 00                	push   $0x0
  8036d3:	6a 00                	push   $0x0
  8036d5:	6a 00                	push   $0x0
  8036d7:	6a 00                	push   $0x0
  8036d9:	6a 00                	push   $0x0
  8036db:	6a 1e                	push   $0x1e
  8036dd:	e8 65 fc ff ff       	call   803347 <syscall>
  8036e2:	83 c4 18             	add    $0x18,%esp
}
  8036e5:	c9                   	leave  
  8036e6:	c3                   	ret    

008036e7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8036e7:	55                   	push   %ebp
  8036e8:	89 e5                	mov    %esp,%ebp
  8036ea:	83 ec 04             	sub    $0x4,%esp
  8036ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8036f3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8036f7:	6a 00                	push   $0x0
  8036f9:	6a 00                	push   $0x0
  8036fb:	6a 00                	push   $0x0
  8036fd:	6a 00                	push   $0x0
  8036ff:	50                   	push   %eax
  803700:	6a 1f                	push   $0x1f
  803702:	e8 40 fc ff ff       	call   803347 <syscall>
  803707:	83 c4 18             	add    $0x18,%esp
	return ;
  80370a:	90                   	nop
}
  80370b:	c9                   	leave  
  80370c:	c3                   	ret    

0080370d <rsttst>:
void rsttst()
{
  80370d:	55                   	push   %ebp
  80370e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803710:	6a 00                	push   $0x0
  803712:	6a 00                	push   $0x0
  803714:	6a 00                	push   $0x0
  803716:	6a 00                	push   $0x0
  803718:	6a 00                	push   $0x0
  80371a:	6a 21                	push   $0x21
  80371c:	e8 26 fc ff ff       	call   803347 <syscall>
  803721:	83 c4 18             	add    $0x18,%esp
	return ;
  803724:	90                   	nop
}
  803725:	c9                   	leave  
  803726:	c3                   	ret    

00803727 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803727:	55                   	push   %ebp
  803728:	89 e5                	mov    %esp,%ebp
  80372a:	83 ec 04             	sub    $0x4,%esp
  80372d:	8b 45 14             	mov    0x14(%ebp),%eax
  803730:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803733:	8b 55 18             	mov    0x18(%ebp),%edx
  803736:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80373a:	52                   	push   %edx
  80373b:	50                   	push   %eax
  80373c:	ff 75 10             	pushl  0x10(%ebp)
  80373f:	ff 75 0c             	pushl  0xc(%ebp)
  803742:	ff 75 08             	pushl  0x8(%ebp)
  803745:	6a 20                	push   $0x20
  803747:	e8 fb fb ff ff       	call   803347 <syscall>
  80374c:	83 c4 18             	add    $0x18,%esp
	return ;
  80374f:	90                   	nop
}
  803750:	c9                   	leave  
  803751:	c3                   	ret    

00803752 <chktst>:
void chktst(uint32 n)
{
  803752:	55                   	push   %ebp
  803753:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803755:	6a 00                	push   $0x0
  803757:	6a 00                	push   $0x0
  803759:	6a 00                	push   $0x0
  80375b:	6a 00                	push   $0x0
  80375d:	ff 75 08             	pushl  0x8(%ebp)
  803760:	6a 22                	push   $0x22
  803762:	e8 e0 fb ff ff       	call   803347 <syscall>
  803767:	83 c4 18             	add    $0x18,%esp
	return ;
  80376a:	90                   	nop
}
  80376b:	c9                   	leave  
  80376c:	c3                   	ret    

0080376d <inctst>:

void inctst()
{
  80376d:	55                   	push   %ebp
  80376e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803770:	6a 00                	push   $0x0
  803772:	6a 00                	push   $0x0
  803774:	6a 00                	push   $0x0
  803776:	6a 00                	push   $0x0
  803778:	6a 00                	push   $0x0
  80377a:	6a 23                	push   $0x23
  80377c:	e8 c6 fb ff ff       	call   803347 <syscall>
  803781:	83 c4 18             	add    $0x18,%esp
	return ;
  803784:	90                   	nop
}
  803785:	c9                   	leave  
  803786:	c3                   	ret    

00803787 <gettst>:
uint32 gettst()
{
  803787:	55                   	push   %ebp
  803788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80378a:	6a 00                	push   $0x0
  80378c:	6a 00                	push   $0x0
  80378e:	6a 00                	push   $0x0
  803790:	6a 00                	push   $0x0
  803792:	6a 00                	push   $0x0
  803794:	6a 24                	push   $0x24
  803796:	e8 ac fb ff ff       	call   803347 <syscall>
  80379b:	83 c4 18             	add    $0x18,%esp
}
  80379e:	c9                   	leave  
  80379f:	c3                   	ret    

008037a0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8037a0:	55                   	push   %ebp
  8037a1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8037a3:	6a 00                	push   $0x0
  8037a5:	6a 00                	push   $0x0
  8037a7:	6a 00                	push   $0x0
  8037a9:	6a 00                	push   $0x0
  8037ab:	6a 00                	push   $0x0
  8037ad:	6a 25                	push   $0x25
  8037af:	e8 93 fb ff ff       	call   803347 <syscall>
  8037b4:	83 c4 18             	add    $0x18,%esp
  8037b7:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  8037bc:	a1 80 60 83 00       	mov    0x836080,%eax
}
  8037c1:	c9                   	leave  
  8037c2:	c3                   	ret    

008037c3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8037c3:	55                   	push   %ebp
  8037c4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8037c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c9:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8037ce:	6a 00                	push   $0x0
  8037d0:	6a 00                	push   $0x0
  8037d2:	6a 00                	push   $0x0
  8037d4:	6a 00                	push   $0x0
  8037d6:	ff 75 08             	pushl  0x8(%ebp)
  8037d9:	6a 26                	push   $0x26
  8037db:	e8 67 fb ff ff       	call   803347 <syscall>
  8037e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8037e3:	90                   	nop
}
  8037e4:	c9                   	leave  
  8037e5:	c3                   	ret    

008037e6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8037e6:	55                   	push   %ebp
  8037e7:	89 e5                	mov    %esp,%ebp
  8037e9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8037ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8037ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8037f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f6:	6a 00                	push   $0x0
  8037f8:	53                   	push   %ebx
  8037f9:	51                   	push   %ecx
  8037fa:	52                   	push   %edx
  8037fb:	50                   	push   %eax
  8037fc:	6a 27                	push   $0x27
  8037fe:	e8 44 fb ff ff       	call   803347 <syscall>
  803803:	83 c4 18             	add    $0x18,%esp
}
  803806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803809:	c9                   	leave  
  80380a:	c3                   	ret    

0080380b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80380b:	55                   	push   %ebp
  80380c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80380e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803811:	8b 45 08             	mov    0x8(%ebp),%eax
  803814:	6a 00                	push   $0x0
  803816:	6a 00                	push   $0x0
  803818:	6a 00                	push   $0x0
  80381a:	52                   	push   %edx
  80381b:	50                   	push   %eax
  80381c:	6a 28                	push   $0x28
  80381e:	e8 24 fb ff ff       	call   803347 <syscall>
  803823:	83 c4 18             	add    $0x18,%esp
}
  803826:	c9                   	leave  
  803827:	c3                   	ret    

00803828 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803828:	55                   	push   %ebp
  803829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80382b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80382e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803831:	8b 45 08             	mov    0x8(%ebp),%eax
  803834:	6a 00                	push   $0x0
  803836:	51                   	push   %ecx
  803837:	ff 75 10             	pushl  0x10(%ebp)
  80383a:	52                   	push   %edx
  80383b:	50                   	push   %eax
  80383c:	6a 29                	push   $0x29
  80383e:	e8 04 fb ff ff       	call   803347 <syscall>
  803843:	83 c4 18             	add    $0x18,%esp
}
  803846:	c9                   	leave  
  803847:	c3                   	ret    

00803848 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803848:	55                   	push   %ebp
  803849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80384b:	6a 00                	push   $0x0
  80384d:	6a 00                	push   $0x0
  80384f:	ff 75 10             	pushl  0x10(%ebp)
  803852:	ff 75 0c             	pushl  0xc(%ebp)
  803855:	ff 75 08             	pushl  0x8(%ebp)
  803858:	6a 12                	push   $0x12
  80385a:	e8 e8 fa ff ff       	call   803347 <syscall>
  80385f:	83 c4 18             	add    $0x18,%esp
	return ;
  803862:	90                   	nop
}
  803863:	c9                   	leave  
  803864:	c3                   	ret    

00803865 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803865:	55                   	push   %ebp
  803866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803868:	8b 55 0c             	mov    0xc(%ebp),%edx
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	6a 00                	push   $0x0
  803870:	6a 00                	push   $0x0
  803872:	6a 00                	push   $0x0
  803874:	52                   	push   %edx
  803875:	50                   	push   %eax
  803876:	6a 2a                	push   $0x2a
  803878:	e8 ca fa ff ff       	call   803347 <syscall>
  80387d:	83 c4 18             	add    $0x18,%esp
	return;
  803880:	90                   	nop
}
  803881:	c9                   	leave  
  803882:	c3                   	ret    

00803883 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803883:	55                   	push   %ebp
  803884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803886:	6a 00                	push   $0x0
  803888:	6a 00                	push   $0x0
  80388a:	6a 00                	push   $0x0
  80388c:	6a 00                	push   $0x0
  80388e:	6a 00                	push   $0x0
  803890:	6a 2b                	push   $0x2b
  803892:	e8 b0 fa ff ff       	call   803347 <syscall>
  803897:	83 c4 18             	add    $0x18,%esp
}
  80389a:	c9                   	leave  
  80389b:	c3                   	ret    

0080389c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80389c:	55                   	push   %ebp
  80389d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80389f:	6a 00                	push   $0x0
  8038a1:	6a 00                	push   $0x0
  8038a3:	6a 00                	push   $0x0
  8038a5:	ff 75 0c             	pushl  0xc(%ebp)
  8038a8:	ff 75 08             	pushl  0x8(%ebp)
  8038ab:	6a 2d                	push   $0x2d
  8038ad:	e8 95 fa ff ff       	call   803347 <syscall>
  8038b2:	83 c4 18             	add    $0x18,%esp
	return;
  8038b5:	90                   	nop
}
  8038b6:	c9                   	leave  
  8038b7:	c3                   	ret    

008038b8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8038b8:	55                   	push   %ebp
  8038b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8038bb:	6a 00                	push   $0x0
  8038bd:	6a 00                	push   $0x0
  8038bf:	6a 00                	push   $0x0
  8038c1:	ff 75 0c             	pushl  0xc(%ebp)
  8038c4:	ff 75 08             	pushl  0x8(%ebp)
  8038c7:	6a 2c                	push   $0x2c
  8038c9:	e8 79 fa ff ff       	call   803347 <syscall>
  8038ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8038d1:	90                   	nop
}
  8038d2:	c9                   	leave  
  8038d3:	c3                   	ret    

008038d4 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8038d4:	55                   	push   %ebp
  8038d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8038d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038da:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dd:	6a 00                	push   $0x0
  8038df:	6a 00                	push   $0x0
  8038e1:	6a 00                	push   $0x0
  8038e3:	52                   	push   %edx
  8038e4:	50                   	push   %eax
  8038e5:	6a 2e                	push   $0x2e
  8038e7:	e8 5b fa ff ff       	call   803347 <syscall>
  8038ec:	83 c4 18             	add    $0x18,%esp
}
  8038ef:	90                   	nop
  8038f0:	c9                   	leave  
  8038f1:	c3                   	ret    

008038f2 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8038f2:	55                   	push   %ebp
  8038f3:	89 e5                	mov    %esp,%ebp
  8038f5:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8038f8:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  8038ff:	72 09                	jb     80390a <to_page_va+0x18>
  803901:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803908:	72 14                	jb     80391e <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80390a:	83 ec 04             	sub    $0x4,%esp
  80390d:	68 d8 4e 80 00       	push   $0x804ed8
  803912:	6a 15                	push   $0x15
  803914:	68 03 4f 80 00       	push   $0x804f03
  803919:	e8 10 d0 ff ff       	call   80092e <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80391e:	8b 45 08             	mov    0x8(%ebp),%eax
  803921:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803926:	29 d0                	sub    %edx,%eax
  803928:	c1 f8 02             	sar    $0x2,%eax
  80392b:	89 c2                	mov    %eax,%edx
  80392d:	89 d0                	mov    %edx,%eax
  80392f:	c1 e0 02             	shl    $0x2,%eax
  803932:	01 d0                	add    %edx,%eax
  803934:	c1 e0 02             	shl    $0x2,%eax
  803937:	01 d0                	add    %edx,%eax
  803939:	c1 e0 02             	shl    $0x2,%eax
  80393c:	01 d0                	add    %edx,%eax
  80393e:	89 c1                	mov    %eax,%ecx
  803940:	c1 e1 08             	shl    $0x8,%ecx
  803943:	01 c8                	add    %ecx,%eax
  803945:	89 c1                	mov    %eax,%ecx
  803947:	c1 e1 10             	shl    $0x10,%ecx
  80394a:	01 c8                	add    %ecx,%eax
  80394c:	01 c0                	add    %eax,%eax
  80394e:	01 d0                	add    %edx,%eax
  803950:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803956:	c1 e0 0c             	shl    $0xc,%eax
  803959:	89 c2                	mov    %eax,%edx
  80395b:	a1 84 60 83 00       	mov    0x836084,%eax
  803960:	01 d0                	add    %edx,%eax
}
  803962:	c9                   	leave  
  803963:	c3                   	ret    

00803964 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803964:	55                   	push   %ebp
  803965:	89 e5                	mov    %esp,%ebp
  803967:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80396a:	a1 84 60 83 00       	mov    0x836084,%eax
  80396f:	8b 55 08             	mov    0x8(%ebp),%edx
  803972:	29 c2                	sub    %eax,%edx
  803974:	89 d0                	mov    %edx,%eax
  803976:	c1 e8 0c             	shr    $0xc,%eax
  803979:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80397c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803980:	78 09                	js     80398b <to_page_info+0x27>
  803982:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803989:	7e 14                	jle    80399f <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80398b:	83 ec 04             	sub    $0x4,%esp
  80398e:	68 1c 4f 80 00       	push   $0x804f1c
  803993:	6a 21                	push   $0x21
  803995:	68 03 4f 80 00       	push   $0x804f03
  80399a:	e8 8f cf ff ff       	call   80092e <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80399f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039a2:	89 d0                	mov    %edx,%eax
  8039a4:	01 c0                	add    %eax,%eax
  8039a6:	01 d0                	add    %edx,%eax
  8039a8:	c1 e0 02             	shl    $0x2,%eax
  8039ab:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  8039b0:	c9                   	leave  
  8039b1:	c3                   	ret    

008039b2 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8039b2:	55                   	push   %ebp
  8039b3:	89 e5                	mov    %esp,%ebp
  8039b5:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	05 00 00 00 02       	add    $0x2000000,%eax
  8039c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039c3:	73 16                	jae    8039db <initialize_dynamic_allocator+0x29>
  8039c5:	68 40 4f 80 00       	push   $0x804f40
  8039ca:	68 66 4f 80 00       	push   $0x804f66
  8039cf:	6a 2f                	push   $0x2f
  8039d1:	68 03 4f 80 00       	push   $0x804f03
  8039d6:	e8 53 cf ff ff       	call   80092e <_panic>
	dynAllocStart = daStart;
  8039db:	8b 45 08             	mov    0x8(%ebp),%eax
  8039de:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  8039e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e6:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8039eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8039f2:	eb 36                	jmp    803a2a <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8039f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f7:	c1 e0 04             	shl    $0x4,%eax
  8039fa:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8039ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a08:	c1 e0 04             	shl    $0x4,%eax
  803a0b:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a19:	c1 e0 04             	shl    $0x4,%eax
  803a1c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803a21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a27:	ff 45 f4             	incl   -0xc(%ebp)
  803a2a:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803a2e:	7e c4                	jle    8039f4 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803a30:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803a37:	00 00 00 
  803a3a:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803a41:	00 00 00 
  803a44:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803a4b:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803a4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a55:	e9 1b 01 00 00       	jmp    803b75 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a5d:	89 d0                	mov    %edx,%eax
  803a5f:	01 c0                	add    %eax,%eax
  803a61:	01 d0                	add    %edx,%eax
  803a63:	c1 e0 02             	shl    $0x2,%eax
  803a66:	05 88 e0 81 00       	add    $0x81e088,%eax
  803a6b:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803a70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a73:	89 d0                	mov    %edx,%eax
  803a75:	01 c0                	add    %eax,%eax
  803a77:	01 d0                	add    %edx,%eax
  803a79:	c1 e0 02             	shl    $0x2,%eax
  803a7c:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803a81:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803a86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a89:	89 d0                	mov    %edx,%eax
  803a8b:	01 c0                	add    %eax,%eax
  803a8d:	01 d0                	add    %edx,%eax
  803a8f:	c1 e0 02             	shl    $0x2,%eax
  803a92:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a97:	8b 00                	mov    (%eax),%eax
  803a99:	85 c0                	test   %eax,%eax
  803a9b:	74 2b                	je     803ac8 <initialize_dynamic_allocator+0x116>
  803a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aa0:	89 d0                	mov    %edx,%eax
  803aa2:	01 c0                	add    %eax,%eax
  803aa4:	01 d0                	add    %edx,%eax
  803aa6:	c1 e0 02             	shl    $0x2,%eax
  803aa9:	05 80 e0 81 00       	add    $0x81e080,%eax
  803aae:	8b 10                	mov    (%eax),%edx
  803ab0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803ab3:	89 c8                	mov    %ecx,%eax
  803ab5:	01 c0                	add    %eax,%eax
  803ab7:	01 c8                	add    %ecx,%eax
  803ab9:	c1 e0 02             	shl    $0x2,%eax
  803abc:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ac1:	8b 00                	mov    (%eax),%eax
  803ac3:	89 42 04             	mov    %eax,0x4(%edx)
  803ac6:	eb 18                	jmp    803ae0 <initialize_dynamic_allocator+0x12e>
  803ac8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803acb:	89 d0                	mov    %edx,%eax
  803acd:	01 c0                	add    %eax,%eax
  803acf:	01 d0                	add    %edx,%eax
  803ad1:	c1 e0 02             	shl    $0x2,%eax
  803ad4:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ad9:	8b 00                	mov    (%eax),%eax
  803adb:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803ae0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ae3:	89 d0                	mov    %edx,%eax
  803ae5:	01 c0                	add    %eax,%eax
  803ae7:	01 d0                	add    %edx,%eax
  803ae9:	c1 e0 02             	shl    $0x2,%eax
  803aec:	05 84 e0 81 00       	add    $0x81e084,%eax
  803af1:	8b 00                	mov    (%eax),%eax
  803af3:	85 c0                	test   %eax,%eax
  803af5:	74 2a                	je     803b21 <initialize_dynamic_allocator+0x16f>
  803af7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803afa:	89 d0                	mov    %edx,%eax
  803afc:	01 c0                	add    %eax,%eax
  803afe:	01 d0                	add    %edx,%eax
  803b00:	c1 e0 02             	shl    $0x2,%eax
  803b03:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b08:	8b 10                	mov    (%eax),%edx
  803b0a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b0d:	89 c8                	mov    %ecx,%eax
  803b0f:	01 c0                	add    %eax,%eax
  803b11:	01 c8                	add    %ecx,%eax
  803b13:	c1 e0 02             	shl    $0x2,%eax
  803b16:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b1b:	8b 00                	mov    (%eax),%eax
  803b1d:	89 02                	mov    %eax,(%edx)
  803b1f:	eb 18                	jmp    803b39 <initialize_dynamic_allocator+0x187>
  803b21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b24:	89 d0                	mov    %edx,%eax
  803b26:	01 c0                	add    %eax,%eax
  803b28:	01 d0                	add    %edx,%eax
  803b2a:	c1 e0 02             	shl    $0x2,%eax
  803b2d:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b32:	8b 00                	mov    (%eax),%eax
  803b34:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803b39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b3c:	89 d0                	mov    %edx,%eax
  803b3e:	01 c0                	add    %eax,%eax
  803b40:	01 d0                	add    %edx,%eax
  803b42:	c1 e0 02             	shl    $0x2,%eax
  803b45:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b53:	89 d0                	mov    %edx,%eax
  803b55:	01 c0                	add    %eax,%eax
  803b57:	01 d0                	add    %edx,%eax
  803b59:	c1 e0 02             	shl    $0x2,%eax
  803b5c:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b67:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803b6c:	48                   	dec    %eax
  803b6d:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803b72:	ff 45 f0             	incl   -0x10(%ebp)
  803b75:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803b7c:	0f 8e d8 fe ff ff    	jle    803a5a <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803b82:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803b89:	e9 9d 00 00 00       	jmp    803c2b <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803b8e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803b94:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803b97:	89 c8                	mov    %ecx,%eax
  803b99:	01 c0                	add    %eax,%eax
  803b9b:	01 c8                	add    %ecx,%eax
  803b9d:	c1 e0 02             	shl    $0x2,%eax
  803ba0:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ba5:	89 10                	mov    %edx,(%eax)
  803ba7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803baa:	89 d0                	mov    %edx,%eax
  803bac:	01 c0                	add    %eax,%eax
  803bae:	01 d0                	add    %edx,%eax
  803bb0:	c1 e0 02             	shl    $0x2,%eax
  803bb3:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bb8:	8b 00                	mov    (%eax),%eax
  803bba:	85 c0                	test   %eax,%eax
  803bbc:	74 1c                	je     803bda <initialize_dynamic_allocator+0x228>
  803bbe:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803bc4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803bc7:	89 c8                	mov    %ecx,%eax
  803bc9:	01 c0                	add    %eax,%eax
  803bcb:	01 c8                	add    %ecx,%eax
  803bcd:	c1 e0 02             	shl    $0x2,%eax
  803bd0:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bd5:	89 42 04             	mov    %eax,0x4(%edx)
  803bd8:	eb 16                	jmp    803bf0 <initialize_dynamic_allocator+0x23e>
  803bda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bdd:	89 d0                	mov    %edx,%eax
  803bdf:	01 c0                	add    %eax,%eax
  803be1:	01 d0                	add    %edx,%eax
  803be3:	c1 e0 02             	shl    $0x2,%eax
  803be6:	05 80 e0 81 00       	add    $0x81e080,%eax
  803beb:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803bf0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bf3:	89 d0                	mov    %edx,%eax
  803bf5:	01 c0                	add    %eax,%eax
  803bf7:	01 d0                	add    %edx,%eax
  803bf9:	c1 e0 02             	shl    $0x2,%eax
  803bfc:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c01:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803c06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c09:	89 d0                	mov    %edx,%eax
  803c0b:	01 c0                	add    %eax,%eax
  803c0d:	01 d0                	add    %edx,%eax
  803c0f:	c1 e0 02             	shl    $0x2,%eax
  803c12:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c1d:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803c22:	40                   	inc    %eax
  803c23:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803c28:	ff 4d ec             	decl   -0x14(%ebp)
  803c2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c2f:	0f 89 59 ff ff ff    	jns    803b8e <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803c35:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803c3c:	00 00 00 
}
  803c3f:	90                   	nop
  803c40:	c9                   	leave  
  803c41:	c3                   	ret    

00803c42 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803c42:	55                   	push   %ebp
  803c43:	89 e5                	mov    %esp,%ebp
  803c45:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803c48:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4b:	83 ec 0c             	sub    $0xc,%esp
  803c4e:	50                   	push   %eax
  803c4f:	e8 10 fd ff ff       	call   803964 <to_page_info>
  803c54:	83 c4 10             	add    $0x10,%esp
  803c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5d:	8b 40 08             	mov    0x8(%eax),%eax
  803c60:	0f b7 c0             	movzwl %ax,%eax
}
  803c63:	c9                   	leave  
  803c64:	c3                   	ret    

00803c65 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803c65:	55                   	push   %ebp
  803c66:	89 e5                	mov    %esp,%ebp
  803c68:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c6b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c72:	76 16                	jbe    803c8a <alloc_block+0x25>
  803c74:	68 7c 4f 80 00       	push   $0x804f7c
  803c79:	68 66 4f 80 00       	push   $0x804f66
  803c7e:	6a 59                	push   $0x59
  803c80:	68 03 4f 80 00       	push   $0x804f03
  803c85:	e8 a4 cc ff ff       	call   80092e <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803c8a:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803c91:	eb 08                	jmp    803c9b <alloc_block+0x36>
		allocSize <<= 1;
  803c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c96:	01 c0                	add    %eax,%eax
  803c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ca1:	73 09                	jae    803cac <alloc_block+0x47>
  803ca3:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803caa:	76 e7                	jbe    803c93 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803cac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803cb3:	eb 03                	jmp    803cb8 <alloc_block+0x53>
		listIndex++;
  803cb5:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cbb:	ba 08 00 00 00       	mov    $0x8,%edx
  803cc0:	88 c1                	mov    %al,%cl
  803cc2:	d3 e2                	shl    %cl,%edx
  803cc4:	89 d0                	mov    %edx,%eax
  803cc6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803cc9:	72 ea                	jb     803cb5 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803cd1:	e9 f4 00 00 00       	jmp    803dca <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cd9:	c1 e0 04             	shl    $0x4,%eax
  803cdc:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ce1:	8b 00                	mov    (%eax),%eax
  803ce3:	85 c0                	test   %eax,%eax
  803ce5:	0f 84 dc 00 00 00    	je     803dc7 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cee:	c1 e0 04             	shl    $0x4,%eax
  803cf1:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803cf6:	8b 00                	mov    (%eax),%eax
  803cf8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803cfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cff:	75 14                	jne    803d15 <alloc_block+0xb0>
  803d01:	83 ec 04             	sub    $0x4,%esp
  803d04:	68 9d 4f 80 00       	push   $0x804f9d
  803d09:	6a 6b                	push   $0x6b
  803d0b:	68 03 4f 80 00       	push   $0x804f03
  803d10:	e8 19 cc ff ff       	call   80092e <_panic>
  803d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d18:	8b 00                	mov    (%eax),%eax
  803d1a:	85 c0                	test   %eax,%eax
  803d1c:	74 10                	je     803d2e <alloc_block+0xc9>
  803d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d21:	8b 00                	mov    (%eax),%eax
  803d23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d26:	8b 52 04             	mov    0x4(%edx),%edx
  803d29:	89 50 04             	mov    %edx,0x4(%eax)
  803d2c:	eb 14                	jmp    803d42 <alloc_block+0xdd>
  803d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d31:	8b 40 04             	mov    0x4(%eax),%eax
  803d34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d37:	c1 e2 04             	shl    $0x4,%edx
  803d3a:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803d40:	89 02                	mov    %eax,(%edx)
  803d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d45:	8b 40 04             	mov    0x4(%eax),%eax
  803d48:	85 c0                	test   %eax,%eax
  803d4a:	74 0f                	je     803d5b <alloc_block+0xf6>
  803d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4f:	8b 40 04             	mov    0x4(%eax),%eax
  803d52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d55:	8b 12                	mov    (%edx),%edx
  803d57:	89 10                	mov    %edx,(%eax)
  803d59:	eb 13                	jmp    803d6e <alloc_block+0x109>
  803d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5e:	8b 00                	mov    (%eax),%eax
  803d60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d63:	c1 e2 04             	shl    $0x4,%edx
  803d66:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803d6c:	89 02                	mov    %eax,(%edx)
  803d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d84:	c1 e0 04             	shl    $0x4,%eax
  803d87:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d8c:	8b 00                	mov    (%eax),%eax
  803d8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d94:	c1 e0 04             	shl    $0x4,%eax
  803d97:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d9c:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da1:	83 ec 0c             	sub    $0xc,%esp
  803da4:	50                   	push   %eax
  803da5:	e8 ba fb ff ff       	call   803964 <to_page_info>
  803daa:	83 c4 10             	add    $0x10,%esp
  803dad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803db3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803db7:	48                   	dec    %eax
  803db8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803dbb:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc2:	e9 8f 02 00 00       	jmp    804056 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803dc7:	ff 45 ec             	incl   -0x14(%ebp)
  803dca:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803dce:	0f 8e 02 ff ff ff    	jle    803cd6 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803dd4:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803dd9:	85 c0                	test   %eax,%eax
  803ddb:	75 14                	jne    803df1 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803ddd:	83 ec 04             	sub    $0x4,%esp
  803de0:	68 bc 4f 80 00       	push   $0x804fbc
  803de5:	6a 77                	push   $0x77
  803de7:	68 03 4f 80 00       	push   $0x804f03
  803dec:	e8 3d cb ff ff       	call   80092e <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803df1:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803df6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803df9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803dfd:	75 14                	jne    803e13 <alloc_block+0x1ae>
  803dff:	83 ec 04             	sub    $0x4,%esp
  803e02:	68 9d 4f 80 00       	push   $0x804f9d
  803e07:	6a 7a                	push   $0x7a
  803e09:	68 03 4f 80 00       	push   $0x804f03
  803e0e:	e8 1b cb ff ff       	call   80092e <_panic>
  803e13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e16:	8b 00                	mov    (%eax),%eax
  803e18:	85 c0                	test   %eax,%eax
  803e1a:	74 10                	je     803e2c <alloc_block+0x1c7>
  803e1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1f:	8b 00                	mov    (%eax),%eax
  803e21:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e24:	8b 52 04             	mov    0x4(%edx),%edx
  803e27:	89 50 04             	mov    %edx,0x4(%eax)
  803e2a:	eb 0b                	jmp    803e37 <alloc_block+0x1d2>
  803e2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e2f:	8b 40 04             	mov    0x4(%eax),%eax
  803e32:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3a:	8b 40 04             	mov    0x4(%eax),%eax
  803e3d:	85 c0                	test   %eax,%eax
  803e3f:	74 0f                	je     803e50 <alloc_block+0x1eb>
  803e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e44:	8b 40 04             	mov    0x4(%eax),%eax
  803e47:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e4a:	8b 12                	mov    (%edx),%edx
  803e4c:	89 10                	mov    %edx,(%eax)
  803e4e:	eb 0a                	jmp    803e5a <alloc_block+0x1f5>
  803e50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e53:	8b 00                	mov    (%eax),%eax
  803e55:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803e5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e6d:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803e72:	48                   	dec    %eax
  803e73:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803e78:	83 ec 0c             	sub    $0xc,%esp
  803e7b:	ff 75 dc             	pushl  -0x24(%ebp)
  803e7e:	e8 6f fa ff ff       	call   8038f2 <to_page_va>
  803e83:	83 c4 10             	add    $0x10,%esp
  803e86:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803e89:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e8c:	83 ec 0c             	sub    $0xc,%esp
  803e8f:	50                   	push   %eax
  803e90:	e8 a0 dc ff ff       	call   801b35 <get_page>
  803e95:	83 c4 10             	add    $0x10,%esp
  803e98:	85 c0                	test   %eax,%eax
  803e9a:	74 14                	je     803eb0 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803e9c:	83 ec 04             	sub    $0x4,%esp
  803e9f:	68 e4 4f 80 00       	push   $0x804fe4
  803ea4:	6a 7f                	push   $0x7f
  803ea6:	68 03 4f 80 00       	push   $0x804f03
  803eab:	e8 7e ca ff ff       	call   80092e <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803eb6:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803eba:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  803ec4:	f7 75 f4             	divl   -0xc(%ebp)
  803ec7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803eca:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803ece:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ed5:	e9 a7 00 00 00       	jmp    803f81 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803eda:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803edd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ee0:	01 d0                	add    %edx,%eax
  803ee2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803ee5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ee9:	75 17                	jne    803f02 <alloc_block+0x29d>
  803eeb:	83 ec 04             	sub    $0x4,%esp
  803eee:	68 0c 50 80 00       	push   $0x80500c
  803ef3:	68 88 00 00 00       	push   $0x88
  803ef8:	68 03 4f 80 00       	push   $0x804f03
  803efd:	e8 2c ca ff ff       	call   80092e <_panic>
  803f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f05:	c1 e0 04             	shl    $0x4,%eax
  803f08:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f0d:	8b 10                	mov    (%eax),%edx
  803f0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f12:	89 10                	mov    %edx,(%eax)
  803f14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f17:	8b 00                	mov    (%eax),%eax
  803f19:	85 c0                	test   %eax,%eax
  803f1b:	74 15                	je     803f32 <alloc_block+0x2cd>
  803f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f20:	c1 e0 04             	shl    $0x4,%eax
  803f23:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f28:	8b 00                	mov    (%eax),%eax
  803f2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f2d:	89 50 04             	mov    %edx,0x4(%eax)
  803f30:	eb 11                	jmp    803f43 <alloc_block+0x2de>
  803f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f35:	c1 e0 04             	shl    $0x4,%eax
  803f38:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803f3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f41:	89 02                	mov    %eax,(%edx)
  803f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f46:	c1 e0 04             	shl    $0x4,%eax
  803f49:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803f4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f52:	89 02                	mov    %eax,(%edx)
  803f54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f61:	c1 e0 04             	shl    $0x4,%eax
  803f64:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f69:	8b 00                	mov    (%eax),%eax
  803f6b:	8d 50 01             	lea    0x1(%eax),%edx
  803f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f71:	c1 e0 04             	shl    $0x4,%eax
  803f74:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f79:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7e:	01 45 e8             	add    %eax,-0x18(%ebp)
  803f81:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803f88:	0f 86 4c ff ff ff    	jbe    803eda <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f91:	c1 e0 04             	shl    $0x4,%eax
  803f94:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f99:	8b 00                	mov    (%eax),%eax
  803f9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803f9e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803fa2:	75 17                	jne    803fbb <alloc_block+0x356>
  803fa4:	83 ec 04             	sub    $0x4,%esp
  803fa7:	68 9d 4f 80 00       	push   $0x804f9d
  803fac:	68 8d 00 00 00       	push   $0x8d
  803fb1:	68 03 4f 80 00       	push   $0x804f03
  803fb6:	e8 73 c9 ff ff       	call   80092e <_panic>
  803fbb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fbe:	8b 00                	mov    (%eax),%eax
  803fc0:	85 c0                	test   %eax,%eax
  803fc2:	74 10                	je     803fd4 <alloc_block+0x36f>
  803fc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fc7:	8b 00                	mov    (%eax),%eax
  803fc9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803fcc:	8b 52 04             	mov    0x4(%edx),%edx
  803fcf:	89 50 04             	mov    %edx,0x4(%eax)
  803fd2:	eb 14                	jmp    803fe8 <alloc_block+0x383>
  803fd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fd7:	8b 40 04             	mov    0x4(%eax),%eax
  803fda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fdd:	c1 e2 04             	shl    $0x4,%edx
  803fe0:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803fe6:	89 02                	mov    %eax,(%edx)
  803fe8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803feb:	8b 40 04             	mov    0x4(%eax),%eax
  803fee:	85 c0                	test   %eax,%eax
  803ff0:	74 0f                	je     804001 <alloc_block+0x39c>
  803ff2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ff5:	8b 40 04             	mov    0x4(%eax),%eax
  803ff8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803ffb:	8b 12                	mov    (%edx),%edx
  803ffd:	89 10                	mov    %edx,(%eax)
  803fff:	eb 13                	jmp    804014 <alloc_block+0x3af>
  804001:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804004:	8b 00                	mov    (%eax),%eax
  804006:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804009:	c1 e2 04             	shl    $0x4,%edx
  80400c:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804012:	89 02                	mov    %eax,(%edx)
  804014:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80401d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80402a:	c1 e0 04             	shl    $0x4,%eax
  80402d:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804032:	8b 00                	mov    (%eax),%eax
  804034:	8d 50 ff             	lea    -0x1(%eax),%edx
  804037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80403a:	c1 e0 04             	shl    $0x4,%eax
  80403d:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804042:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  804044:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804047:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80404b:	48                   	dec    %eax
  80404c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80404f:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  804053:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804056:	c9                   	leave  
  804057:	c3                   	ret    

00804058 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804058:	55                   	push   %ebp
  804059:	89 e5                	mov    %esp,%ebp
  80405b:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80405e:	8b 55 08             	mov    0x8(%ebp),%edx
  804061:	a1 84 60 83 00       	mov    0x836084,%eax
  804066:	39 c2                	cmp    %eax,%edx
  804068:	72 0c                	jb     804076 <free_block+0x1e>
  80406a:	8b 55 08             	mov    0x8(%ebp),%edx
  80406d:	a1 60 e0 81 00       	mov    0x81e060,%eax
  804072:	39 c2                	cmp    %eax,%edx
  804074:	72 19                	jb     80408f <free_block+0x37>
  804076:	68 30 50 80 00       	push   $0x805030
  80407b:	68 66 4f 80 00       	push   $0x804f66
  804080:	68 98 00 00 00       	push   $0x98
  804085:	68 03 4f 80 00       	push   $0x804f03
  80408a:	e8 9f c8 ff ff       	call   80092e <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80408f:	8b 45 08             	mov    0x8(%ebp),%eax
  804092:	83 ec 0c             	sub    $0xc,%esp
  804095:	50                   	push   %eax
  804096:	e8 c9 f8 ff ff       	call   803964 <to_page_info>
  80409b:	83 c4 10             	add    $0x10,%esp
  80409e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  8040a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040a4:	8b 40 08             	mov    0x8(%eax),%eax
  8040a7:	0f b7 c0             	movzwl %ax,%eax
  8040aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  8040ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8040b4:	eb 03                	jmp    8040b9 <free_block+0x61>
		listIndex++;
  8040b6:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8040b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040bc:	ba 08 00 00 00       	mov    $0x8,%edx
  8040c1:	88 c1                	mov    %al,%cl
  8040c3:	d3 e2                	shl    %cl,%edx
  8040c5:	89 d0                	mov    %edx,%eax
  8040c7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8040ca:	72 ea                	jb     8040b6 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  8040cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  8040d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040d6:	75 17                	jne    8040ef <free_block+0x97>
  8040d8:	83 ec 04             	sub    $0x4,%esp
  8040db:	68 0c 50 80 00       	push   $0x80500c
  8040e0:	68 a2 00 00 00       	push   $0xa2
  8040e5:	68 03 4f 80 00       	push   $0x804f03
  8040ea:	e8 3f c8 ff ff       	call   80092e <_panic>
  8040ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f2:	c1 e0 04             	shl    $0x4,%eax
  8040f5:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8040fa:	8b 10                	mov    (%eax),%edx
  8040fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ff:	89 10                	mov    %edx,(%eax)
  804101:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804104:	8b 00                	mov    (%eax),%eax
  804106:	85 c0                	test   %eax,%eax
  804108:	74 15                	je     80411f <free_block+0xc7>
  80410a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80410d:	c1 e0 04             	shl    $0x4,%eax
  804110:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804115:	8b 00                	mov    (%eax),%eax
  804117:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80411a:	89 50 04             	mov    %edx,0x4(%eax)
  80411d:	eb 11                	jmp    804130 <free_block+0xd8>
  80411f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804122:	c1 e0 04             	shl    $0x4,%eax
  804125:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  80412b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412e:	89 02                	mov    %eax,(%edx)
  804130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804133:	c1 e0 04             	shl    $0x4,%eax
  804136:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  80413c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80413f:	89 02                	mov    %eax,(%edx)
  804141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80414b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80414e:	c1 e0 04             	shl    $0x4,%eax
  804151:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804156:	8b 00                	mov    (%eax),%eax
  804158:	8d 50 01             	lea    0x1(%eax),%edx
  80415b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80415e:	c1 e0 04             	shl    $0x4,%eax
  804161:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804166:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80416b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80416f:	40                   	inc    %eax
  804170:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804173:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80417a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80417e:	0f b7 c8             	movzwl %ax,%ecx
  804181:	b8 00 10 00 00       	mov    $0x1000,%eax
  804186:	ba 00 00 00 00       	mov    $0x0,%edx
  80418b:	f7 75 e8             	divl   -0x18(%ebp)
  80418e:	39 c1                	cmp    %eax,%ecx
  804190:	0f 85 ed 01 00 00    	jne    804383 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804199:	c1 e0 04             	shl    $0x4,%eax
  80419c:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041a1:	8b 00                	mov    (%eax),%eax
  8041a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041a6:	eb 2a                	jmp    8041d2 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  8041a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041ab:	83 ec 0c             	sub    $0xc,%esp
  8041ae:	50                   	push   %eax
  8041af:	e8 b0 f7 ff ff       	call   803964 <to_page_info>
  8041b4:	83 c4 10             	add    $0x10,%esp
  8041b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8041ba:	75 06                	jne    8041c2 <free_block+0x16a>
				tmp = b;
  8041bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8041c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041c5:	c1 e0 04             	shl    $0x4,%eax
  8041c8:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8041cd:	8b 00                	mov    (%eax),%eax
  8041cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041d6:	74 07                	je     8041df <free_block+0x187>
  8041d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041db:	8b 00                	mov    (%eax),%eax
  8041dd:	eb 05                	jmp    8041e4 <free_block+0x18c>
  8041df:	b8 00 00 00 00       	mov    $0x0,%eax
  8041e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8041e7:	c1 e2 04             	shl    $0x4,%edx
  8041ea:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  8041f0:	89 02                	mov    %eax,(%edx)
  8041f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f5:	c1 e0 04             	shl    $0x4,%eax
  8041f8:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8041fd:	8b 00                	mov    (%eax),%eax
  8041ff:	85 c0                	test   %eax,%eax
  804201:	75 a5                	jne    8041a8 <free_block+0x150>
  804203:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804207:	75 9f                	jne    8041a8 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80420c:	c1 e0 04             	shl    $0x4,%eax
  80420f:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804214:	8b 00                	mov    (%eax),%eax
  804216:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804219:	e9 cc 00 00 00       	jmp    8042ea <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  80421e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804221:	8b 00                	mov    (%eax),%eax
  804223:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804229:	83 ec 0c             	sub    $0xc,%esp
  80422c:	50                   	push   %eax
  80422d:	e8 32 f7 ff ff       	call   803964 <to_page_info>
  804232:	83 c4 10             	add    $0x10,%esp
  804235:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804238:	0f 85 a6 00 00 00    	jne    8042e4 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  80423e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804242:	75 17                	jne    80425b <free_block+0x203>
  804244:	83 ec 04             	sub    $0x4,%esp
  804247:	68 9d 4f 80 00       	push   $0x804f9d
  80424c:	68 b5 00 00 00       	push   $0xb5
  804251:	68 03 4f 80 00       	push   $0x804f03
  804256:	e8 d3 c6 ff ff       	call   80092e <_panic>
  80425b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80425e:	8b 00                	mov    (%eax),%eax
  804260:	85 c0                	test   %eax,%eax
  804262:	74 10                	je     804274 <free_block+0x21c>
  804264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804267:	8b 00                	mov    (%eax),%eax
  804269:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80426c:	8b 52 04             	mov    0x4(%edx),%edx
  80426f:	89 50 04             	mov    %edx,0x4(%eax)
  804272:	eb 14                	jmp    804288 <free_block+0x230>
  804274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804277:	8b 40 04             	mov    0x4(%eax),%eax
  80427a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80427d:	c1 e2 04             	shl    $0x4,%edx
  804280:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804286:	89 02                	mov    %eax,(%edx)
  804288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80428b:	8b 40 04             	mov    0x4(%eax),%eax
  80428e:	85 c0                	test   %eax,%eax
  804290:	74 0f                	je     8042a1 <free_block+0x249>
  804292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804295:	8b 40 04             	mov    0x4(%eax),%eax
  804298:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80429b:	8b 12                	mov    (%edx),%edx
  80429d:	89 10                	mov    %edx,(%eax)
  80429f:	eb 13                	jmp    8042b4 <free_block+0x25c>
  8042a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a4:	8b 00                	mov    (%eax),%eax
  8042a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042a9:	c1 e2 04             	shl    $0x4,%edx
  8042ac:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8042b2:	89 02                	mov    %eax,(%edx)
  8042b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ca:	c1 e0 04             	shl    $0x4,%eax
  8042cd:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042d2:	8b 00                	mov    (%eax),%eax
  8042d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8042d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042da:	c1 e0 04             	shl    $0x4,%eax
  8042dd:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042e2:	89 10                	mov    %edx,(%eax)
			b = next;
  8042e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  8042ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042ee:	0f 85 2a ff ff ff    	jne    80421e <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  8042f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042f7:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8042fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804300:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804306:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80430a:	75 17                	jne    804323 <free_block+0x2cb>
  80430c:	83 ec 04             	sub    $0x4,%esp
  80430f:	68 0c 50 80 00       	push   $0x80500c
  804314:	68 bc 00 00 00       	push   $0xbc
  804319:	68 03 4f 80 00       	push   $0x804f03
  80431e:	e8 0b c6 ff ff       	call   80092e <_panic>
  804323:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  804329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80432c:	89 10                	mov    %edx,(%eax)
  80432e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804331:	8b 00                	mov    (%eax),%eax
  804333:	85 c0                	test   %eax,%eax
  804335:	74 0d                	je     804344 <free_block+0x2ec>
  804337:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80433c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80433f:	89 50 04             	mov    %edx,0x4(%eax)
  804342:	eb 08                	jmp    80434c <free_block+0x2f4>
  804344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804347:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  80434c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80434f:	a3 68 e0 81 00       	mov    %eax,0x81e068
  804354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804357:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80435e:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804363:	40                   	inc    %eax
  804364:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804369:	83 ec 0c             	sub    $0xc,%esp
  80436c:	ff 75 ec             	pushl  -0x14(%ebp)
  80436f:	e8 7e f5 ff ff       	call   8038f2 <to_page_va>
  804374:	83 c4 10             	add    $0x10,%esp
  804377:	83 ec 0c             	sub    $0xc,%esp
  80437a:	50                   	push   %eax
  80437b:	e8 fe d7 ff ff       	call   801b7e <return_page>
  804380:	83 c4 10             	add    $0x10,%esp
	}
}
  804383:	90                   	nop
  804384:	c9                   	leave  
  804385:	c3                   	ret    
  804386:	66 90                	xchg   %ax,%ax

00804388 <__udivdi3>:
  804388:	55                   	push   %ebp
  804389:	57                   	push   %edi
  80438a:	56                   	push   %esi
  80438b:	53                   	push   %ebx
  80438c:	83 ec 1c             	sub    $0x1c,%esp
  80438f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804393:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804397:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80439b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80439f:	89 ca                	mov    %ecx,%edx
  8043a1:	89 f8                	mov    %edi,%eax
  8043a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043a7:	85 f6                	test   %esi,%esi
  8043a9:	75 2d                	jne    8043d8 <__udivdi3+0x50>
  8043ab:	39 cf                	cmp    %ecx,%edi
  8043ad:	77 65                	ja     804414 <__udivdi3+0x8c>
  8043af:	89 fd                	mov    %edi,%ebp
  8043b1:	85 ff                	test   %edi,%edi
  8043b3:	75 0b                	jne    8043c0 <__udivdi3+0x38>
  8043b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8043ba:	31 d2                	xor    %edx,%edx
  8043bc:	f7 f7                	div    %edi
  8043be:	89 c5                	mov    %eax,%ebp
  8043c0:	31 d2                	xor    %edx,%edx
  8043c2:	89 c8                	mov    %ecx,%eax
  8043c4:	f7 f5                	div    %ebp
  8043c6:	89 c1                	mov    %eax,%ecx
  8043c8:	89 d8                	mov    %ebx,%eax
  8043ca:	f7 f5                	div    %ebp
  8043cc:	89 cf                	mov    %ecx,%edi
  8043ce:	89 fa                	mov    %edi,%edx
  8043d0:	83 c4 1c             	add    $0x1c,%esp
  8043d3:	5b                   	pop    %ebx
  8043d4:	5e                   	pop    %esi
  8043d5:	5f                   	pop    %edi
  8043d6:	5d                   	pop    %ebp
  8043d7:	c3                   	ret    
  8043d8:	39 ce                	cmp    %ecx,%esi
  8043da:	77 28                	ja     804404 <__udivdi3+0x7c>
  8043dc:	0f bd fe             	bsr    %esi,%edi
  8043df:	83 f7 1f             	xor    $0x1f,%edi
  8043e2:	75 40                	jne    804424 <__udivdi3+0x9c>
  8043e4:	39 ce                	cmp    %ecx,%esi
  8043e6:	72 0a                	jb     8043f2 <__udivdi3+0x6a>
  8043e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043ec:	0f 87 9e 00 00 00    	ja     804490 <__udivdi3+0x108>
  8043f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8043f7:	89 fa                	mov    %edi,%edx
  8043f9:	83 c4 1c             	add    $0x1c,%esp
  8043fc:	5b                   	pop    %ebx
  8043fd:	5e                   	pop    %esi
  8043fe:	5f                   	pop    %edi
  8043ff:	5d                   	pop    %ebp
  804400:	c3                   	ret    
  804401:	8d 76 00             	lea    0x0(%esi),%esi
  804404:	31 ff                	xor    %edi,%edi
  804406:	31 c0                	xor    %eax,%eax
  804408:	89 fa                	mov    %edi,%edx
  80440a:	83 c4 1c             	add    $0x1c,%esp
  80440d:	5b                   	pop    %ebx
  80440e:	5e                   	pop    %esi
  80440f:	5f                   	pop    %edi
  804410:	5d                   	pop    %ebp
  804411:	c3                   	ret    
  804412:	66 90                	xchg   %ax,%ax
  804414:	89 d8                	mov    %ebx,%eax
  804416:	f7 f7                	div    %edi
  804418:	31 ff                	xor    %edi,%edi
  80441a:	89 fa                	mov    %edi,%edx
  80441c:	83 c4 1c             	add    $0x1c,%esp
  80441f:	5b                   	pop    %ebx
  804420:	5e                   	pop    %esi
  804421:	5f                   	pop    %edi
  804422:	5d                   	pop    %ebp
  804423:	c3                   	ret    
  804424:	bd 20 00 00 00       	mov    $0x20,%ebp
  804429:	89 eb                	mov    %ebp,%ebx
  80442b:	29 fb                	sub    %edi,%ebx
  80442d:	89 f9                	mov    %edi,%ecx
  80442f:	d3 e6                	shl    %cl,%esi
  804431:	89 c5                	mov    %eax,%ebp
  804433:	88 d9                	mov    %bl,%cl
  804435:	d3 ed                	shr    %cl,%ebp
  804437:	89 e9                	mov    %ebp,%ecx
  804439:	09 f1                	or     %esi,%ecx
  80443b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80443f:	89 f9                	mov    %edi,%ecx
  804441:	d3 e0                	shl    %cl,%eax
  804443:	89 c5                	mov    %eax,%ebp
  804445:	89 d6                	mov    %edx,%esi
  804447:	88 d9                	mov    %bl,%cl
  804449:	d3 ee                	shr    %cl,%esi
  80444b:	89 f9                	mov    %edi,%ecx
  80444d:	d3 e2                	shl    %cl,%edx
  80444f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804453:	88 d9                	mov    %bl,%cl
  804455:	d3 e8                	shr    %cl,%eax
  804457:	09 c2                	or     %eax,%edx
  804459:	89 d0                	mov    %edx,%eax
  80445b:	89 f2                	mov    %esi,%edx
  80445d:	f7 74 24 0c          	divl   0xc(%esp)
  804461:	89 d6                	mov    %edx,%esi
  804463:	89 c3                	mov    %eax,%ebx
  804465:	f7 e5                	mul    %ebp
  804467:	39 d6                	cmp    %edx,%esi
  804469:	72 19                	jb     804484 <__udivdi3+0xfc>
  80446b:	74 0b                	je     804478 <__udivdi3+0xf0>
  80446d:	89 d8                	mov    %ebx,%eax
  80446f:	31 ff                	xor    %edi,%edi
  804471:	e9 58 ff ff ff       	jmp    8043ce <__udivdi3+0x46>
  804476:	66 90                	xchg   %ax,%ax
  804478:	8b 54 24 08          	mov    0x8(%esp),%edx
  80447c:	89 f9                	mov    %edi,%ecx
  80447e:	d3 e2                	shl    %cl,%edx
  804480:	39 c2                	cmp    %eax,%edx
  804482:	73 e9                	jae    80446d <__udivdi3+0xe5>
  804484:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804487:	31 ff                	xor    %edi,%edi
  804489:	e9 40 ff ff ff       	jmp    8043ce <__udivdi3+0x46>
  80448e:	66 90                	xchg   %ax,%ax
  804490:	31 c0                	xor    %eax,%eax
  804492:	e9 37 ff ff ff       	jmp    8043ce <__udivdi3+0x46>
  804497:	90                   	nop

00804498 <__umoddi3>:
  804498:	55                   	push   %ebp
  804499:	57                   	push   %edi
  80449a:	56                   	push   %esi
  80449b:	53                   	push   %ebx
  80449c:	83 ec 1c             	sub    $0x1c,%esp
  80449f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044b7:	89 f3                	mov    %esi,%ebx
  8044b9:	89 fa                	mov    %edi,%edx
  8044bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044bf:	89 34 24             	mov    %esi,(%esp)
  8044c2:	85 c0                	test   %eax,%eax
  8044c4:	75 1a                	jne    8044e0 <__umoddi3+0x48>
  8044c6:	39 f7                	cmp    %esi,%edi
  8044c8:	0f 86 a2 00 00 00    	jbe    804570 <__umoddi3+0xd8>
  8044ce:	89 c8                	mov    %ecx,%eax
  8044d0:	89 f2                	mov    %esi,%edx
  8044d2:	f7 f7                	div    %edi
  8044d4:	89 d0                	mov    %edx,%eax
  8044d6:	31 d2                	xor    %edx,%edx
  8044d8:	83 c4 1c             	add    $0x1c,%esp
  8044db:	5b                   	pop    %ebx
  8044dc:	5e                   	pop    %esi
  8044dd:	5f                   	pop    %edi
  8044de:	5d                   	pop    %ebp
  8044df:	c3                   	ret    
  8044e0:	39 f0                	cmp    %esi,%eax
  8044e2:	0f 87 ac 00 00 00    	ja     804594 <__umoddi3+0xfc>
  8044e8:	0f bd e8             	bsr    %eax,%ebp
  8044eb:	83 f5 1f             	xor    $0x1f,%ebp
  8044ee:	0f 84 ac 00 00 00    	je     8045a0 <__umoddi3+0x108>
  8044f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8044f9:	29 ef                	sub    %ebp,%edi
  8044fb:	89 fe                	mov    %edi,%esi
  8044fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804501:	89 e9                	mov    %ebp,%ecx
  804503:	d3 e0                	shl    %cl,%eax
  804505:	89 d7                	mov    %edx,%edi
  804507:	89 f1                	mov    %esi,%ecx
  804509:	d3 ef                	shr    %cl,%edi
  80450b:	09 c7                	or     %eax,%edi
  80450d:	89 e9                	mov    %ebp,%ecx
  80450f:	d3 e2                	shl    %cl,%edx
  804511:	89 14 24             	mov    %edx,(%esp)
  804514:	89 d8                	mov    %ebx,%eax
  804516:	d3 e0                	shl    %cl,%eax
  804518:	89 c2                	mov    %eax,%edx
  80451a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80451e:	d3 e0                	shl    %cl,%eax
  804520:	89 44 24 04          	mov    %eax,0x4(%esp)
  804524:	8b 44 24 08          	mov    0x8(%esp),%eax
  804528:	89 f1                	mov    %esi,%ecx
  80452a:	d3 e8                	shr    %cl,%eax
  80452c:	09 d0                	or     %edx,%eax
  80452e:	d3 eb                	shr    %cl,%ebx
  804530:	89 da                	mov    %ebx,%edx
  804532:	f7 f7                	div    %edi
  804534:	89 d3                	mov    %edx,%ebx
  804536:	f7 24 24             	mull   (%esp)
  804539:	89 c6                	mov    %eax,%esi
  80453b:	89 d1                	mov    %edx,%ecx
  80453d:	39 d3                	cmp    %edx,%ebx
  80453f:	0f 82 87 00 00 00    	jb     8045cc <__umoddi3+0x134>
  804545:	0f 84 91 00 00 00    	je     8045dc <__umoddi3+0x144>
  80454b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80454f:	29 f2                	sub    %esi,%edx
  804551:	19 cb                	sbb    %ecx,%ebx
  804553:	89 d8                	mov    %ebx,%eax
  804555:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804559:	d3 e0                	shl    %cl,%eax
  80455b:	89 e9                	mov    %ebp,%ecx
  80455d:	d3 ea                	shr    %cl,%edx
  80455f:	09 d0                	or     %edx,%eax
  804561:	89 e9                	mov    %ebp,%ecx
  804563:	d3 eb                	shr    %cl,%ebx
  804565:	89 da                	mov    %ebx,%edx
  804567:	83 c4 1c             	add    $0x1c,%esp
  80456a:	5b                   	pop    %ebx
  80456b:	5e                   	pop    %esi
  80456c:	5f                   	pop    %edi
  80456d:	5d                   	pop    %ebp
  80456e:	c3                   	ret    
  80456f:	90                   	nop
  804570:	89 fd                	mov    %edi,%ebp
  804572:	85 ff                	test   %edi,%edi
  804574:	75 0b                	jne    804581 <__umoddi3+0xe9>
  804576:	b8 01 00 00 00       	mov    $0x1,%eax
  80457b:	31 d2                	xor    %edx,%edx
  80457d:	f7 f7                	div    %edi
  80457f:	89 c5                	mov    %eax,%ebp
  804581:	89 f0                	mov    %esi,%eax
  804583:	31 d2                	xor    %edx,%edx
  804585:	f7 f5                	div    %ebp
  804587:	89 c8                	mov    %ecx,%eax
  804589:	f7 f5                	div    %ebp
  80458b:	89 d0                	mov    %edx,%eax
  80458d:	e9 44 ff ff ff       	jmp    8044d6 <__umoddi3+0x3e>
  804592:	66 90                	xchg   %ax,%ax
  804594:	89 c8                	mov    %ecx,%eax
  804596:	89 f2                	mov    %esi,%edx
  804598:	83 c4 1c             	add    $0x1c,%esp
  80459b:	5b                   	pop    %ebx
  80459c:	5e                   	pop    %esi
  80459d:	5f                   	pop    %edi
  80459e:	5d                   	pop    %ebp
  80459f:	c3                   	ret    
  8045a0:	3b 04 24             	cmp    (%esp),%eax
  8045a3:	72 06                	jb     8045ab <__umoddi3+0x113>
  8045a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045a9:	77 0f                	ja     8045ba <__umoddi3+0x122>
  8045ab:	89 f2                	mov    %esi,%edx
  8045ad:	29 f9                	sub    %edi,%ecx
  8045af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045b3:	89 14 24             	mov    %edx,(%esp)
  8045b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045be:	8b 14 24             	mov    (%esp),%edx
  8045c1:	83 c4 1c             	add    $0x1c,%esp
  8045c4:	5b                   	pop    %ebx
  8045c5:	5e                   	pop    %esi
  8045c6:	5f                   	pop    %edi
  8045c7:	5d                   	pop    %ebp
  8045c8:	c3                   	ret    
  8045c9:	8d 76 00             	lea    0x0(%esi),%esi
  8045cc:	2b 04 24             	sub    (%esp),%eax
  8045cf:	19 fa                	sbb    %edi,%edx
  8045d1:	89 d1                	mov    %edx,%ecx
  8045d3:	89 c6                	mov    %eax,%esi
  8045d5:	e9 71 ff ff ff       	jmp    80454b <__umoddi3+0xb3>
  8045da:	66 90                	xchg   %ax,%ax
  8045dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045e0:	72 ea                	jb     8045cc <__umoddi3+0x134>
  8045e2:	89 d9                	mov    %ebx,%ecx
  8045e4:	e9 62 ff ff ff       	jmp    80454b <__umoddi3+0xb3>
