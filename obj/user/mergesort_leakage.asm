
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 01 07 00 00       	call   800737 <libmain>
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
	{
		//2012: lock the interrupt
//		sys_lock_cons();
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 31 35 00 00       	call   803577 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 47 80 00       	push   $0x8047c0
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 47 80 00       	push   $0x8047c2
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 47 80 00       	push   $0x8047d8
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 47 80 00       	push   $0x8047c2
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 47 80 00       	push   $0x8047c0
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f0 47 80 00       	push   $0x8047f0
  8000a5:	e8 e4 11 00 00       	call   80128e <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 e5 17 00 00       	call   8018a5 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 aa 1c 00 00       	call   801d7f <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 10 48 80 00       	push   $0x804810
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 32 48 80 00       	push   $0x804832
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 40 48 80 00       	push   $0x804840
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 4f 48 80 00       	push   $0x80484f
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 5f 48 80 00       	push   $0x80485f
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012b:	e8 ea 05 00 00       	call   80071a <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		}
		sys_unlock_cons();
  800162:	e8 2a 34 00 00       	call   803591 <sys_unlock_cons>
//		sys_unlock_cons();

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
  8001d7:	e8 9b 33 00 00       	call   803577 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 68 48 80 00       	push   $0x804868
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 a0 33 00 00       	call   803591 <sys_unlock_cons>
//		sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 9c 48 80 00       	push   $0x80489c
  800213:	6a 51                	push   $0x51
  800215:	68 be 48 80 00       	push   $0x8048be
  80021a:	e8 c8 06 00 00       	call   8008e7 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 53 33 00 00       	call   803577 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 d8 48 80 00       	push   $0x8048d8
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 0c 49 80 00       	push   $0x80490c
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 40 49 80 00       	push   $0x804940
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 38 33 00 00       	call   803591 <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 19 33 00 00       	call   803577 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 72 49 80 00       	push   $0x804972
  80026c:	e8 44 09 00 00       	call   800bb5 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 a1 04 00 00       	call   80071a <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b2:	e8 da 32 00 00       	call   803591 <sys_unlock_cons>
//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 c0 47 80 00       	push   $0x8047c0
  80044b:	e8 65 07 00 00       	call   800bb5 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 90 49 80 00       	push   $0x804990
  80046d:	e8 43 07 00 00       	call   800bb5 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 95 49 80 00       	push   $0x804995
  80049b:	e8 15 07 00 00       	call   800bb5 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 3e 18 00 00       	call   801d7f <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 29 18 00 00       	call   801d7f <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 ab 2f 00 00       	call   8036bf <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <getchar>:


int
getchar(void)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800720:	e8 39 2e 00 00       	call   80355e <sys_cgetc>
  800725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <iscons>:

int iscons(int fdnum)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800730:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	57                   	push   %edi
  80073b:	56                   	push   %esi
  80073c:	53                   	push   %ebx
  80073d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800740:	e8 ab 30 00 00       	call   8037f0 <sys_getenvindex>
  800745:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074b:	89 d0                	mov    %edx,%eax
  80074d:	c1 e0 03             	shl    $0x3,%eax
  800750:	01 d0                	add    %edx,%eax
  800752:	c1 e0 02             	shl    $0x2,%eax
  800755:	01 d0                	add    %edx,%eax
  800757:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80075e:	01 d0                	add    %edx,%eax
  800760:	c1 e0 03             	shl    $0x3,%eax
  800763:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800768:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80076d:	a1 24 60 80 00       	mov    0x806024,%eax
  800772:	8a 40 20             	mov    0x20(%eax),%al
  800775:	84 c0                	test   %al,%al
  800777:	74 0d                	je     800786 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800779:	a1 24 60 80 00       	mov    0x806024,%eax
  80077e:	83 c0 20             	add    $0x20,%eax
  800781:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80078a:	7e 0a                	jle    800796 <libmain+0x5f>
		binaryname = argv[0];
  80078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	ff 75 08             	pushl  0x8(%ebp)
  80079f:	e8 94 f8 ff ff       	call   800038 <_main>
  8007a4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007a7:	a1 00 60 80 00       	mov    0x806000,%eax
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	0f 84 01 01 00 00    	je     8008b5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007b4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007ba:	bb 94 4a 80 00       	mov    $0x804a94,%ebx
  8007bf:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007c4:	89 c7                	mov    %eax,%edi
  8007c6:	89 de                	mov    %ebx,%esi
  8007c8:	89 d1                	mov    %edx,%ecx
  8007ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007cc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007cf:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007d4:	b0 00                	mov    $0x0,%al
  8007d6:	89 d7                	mov    %edx,%edi
  8007d8:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8007e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	50                   	push   %eax
  8007e8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007ee:	50                   	push   %eax
  8007ef:	e8 32 32 00 00       	call   803a26 <sys_utilities>
  8007f4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8007f7:	e8 7b 2d 00 00       	call   803577 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	68 b4 49 80 00       	push   $0x8049b4
  800804:	e8 ac 03 00 00       	call   800bb5 <cprintf>
  800809:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80080c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080f:	85 c0                	test   %eax,%eax
  800811:	74 18                	je     80082b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800813:	e8 2c 32 00 00       	call   803a44 <sys_get_optimal_num_faults>
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	50                   	push   %eax
  80081c:	68 dc 49 80 00       	push   $0x8049dc
  800821:	e8 8f 03 00 00       	call   800bb5 <cprintf>
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	eb 59                	jmp    800884 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80082b:	a1 24 60 80 00       	mov    0x806024,%eax
  800830:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800836:	a1 24 60 80 00       	mov    0x806024,%eax
  80083b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	68 00 4a 80 00       	push   $0x804a00
  80084b:	e8 65 03 00 00       	call   800bb5 <cprintf>
  800850:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800853:	a1 24 60 80 00       	mov    0x806024,%eax
  800858:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80085e:	a1 24 60 80 00       	mov    0x806024,%eax
  800863:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800869:	a1 24 60 80 00       	mov    0x806024,%eax
  80086e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	68 28 4a 80 00       	push   $0x804a28
  80087c:	e8 34 03 00 00       	call   800bb5 <cprintf>
  800881:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800884:	a1 24 60 80 00       	mov    0x806024,%eax
  800889:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	50                   	push   %eax
  800893:	68 80 4a 80 00       	push   $0x804a80
  800898:	e8 18 03 00 00       	call   800bb5 <cprintf>
  80089d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 b4 49 80 00       	push   $0x8049b4
  8008a8:	e8 08 03 00 00       	call   800bb5 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008b0:	e8 dc 2c 00 00       	call   803591 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008b5:	e8 1f 00 00 00       	call   8008d9 <exit>
}
  8008ba:	90                   	nop
  8008bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008be:	5b                   	pop    %ebx
  8008bf:	5e                   	pop    %esi
  8008c0:	5f                   	pop    %edi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	6a 00                	push   $0x0
  8008ce:	e8 e9 2e 00 00       	call   8037bc <sys_destroy_env>
  8008d3:	83 c4 10             	add    $0x10,%esp
}
  8008d6:	90                   	nop
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    

008008d9 <exit>:

void
exit(void)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008df:	e8 3e 2f 00 00       	call   803822 <sys_exit_env>
}
  8008e4:	90                   	nop
  8008e5:	c9                   	leave  
  8008e6:	c3                   	ret    

008008e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f0:	83 c0 04             	add    $0x4,%eax
  8008f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008f6:	a1 38 61 83 00       	mov    0x836138,%eax
  8008fb:	85 c0                	test   %eax,%eax
  8008fd:	74 16                	je     800915 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ff:	a1 38 61 83 00       	mov    0x836138,%eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	50                   	push   %eax
  800908:	68 f8 4a 80 00       	push   $0x804af8
  80090d:	e8 a3 02 00 00       	call   800bb5 <cprintf>
  800912:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800915:	a1 04 60 80 00       	mov    0x806004,%eax
  80091a:	83 ec 0c             	sub    $0xc,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	50                   	push   %eax
  800924:	68 00 4b 80 00       	push   $0x804b00
  800929:	6a 74                	push   $0x74
  80092b:	e8 b2 02 00 00       	call   800be2 <cprintf_colored>
  800930:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800933:	8b 45 10             	mov    0x10(%ebp),%eax
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 f4             	pushl  -0xc(%ebp)
  80093c:	50                   	push   %eax
  80093d:	e8 04 02 00 00       	call   800b46 <vcprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	6a 00                	push   $0x0
  80094a:	68 28 4b 80 00       	push   $0x804b28
  80094f:	e8 f2 01 00 00       	call   800b46 <vcprintf>
  800954:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800957:	e8 7d ff ff ff       	call   8008d9 <exit>

	// should not return here
	while (1) ;
  80095c:	eb fe                	jmp    80095c <_panic+0x75>

0080095e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800964:	a1 24 60 80 00       	mov    0x806024,%eax
  800969:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	39 c2                	cmp    %eax,%edx
  800974:	74 14                	je     80098a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800976:	83 ec 04             	sub    $0x4,%esp
  800979:	68 2c 4b 80 00       	push   $0x804b2c
  80097e:	6a 26                	push   $0x26
  800980:	68 78 4b 80 00       	push   $0x804b78
  800985:	e8 5d ff ff ff       	call   8008e7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800991:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800998:	e9 c5 00 00 00       	jmp    800a62 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	85 c0                	test   %eax,%eax
  8009b0:	75 08                	jne    8009ba <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009b2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b5:	e9 a5 00 00 00       	jmp    800a5f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009c8:	eb 69                	jmp    800a33 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ca:	a1 24 60 80 00       	mov    0x806024,%eax
  8009cf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009d8:	89 d0                	mov    %edx,%eax
  8009da:	01 c0                	add    %eax,%eax
  8009dc:	01 d0                	add    %edx,%eax
  8009de:	c1 e0 03             	shl    $0x3,%eax
  8009e1:	01 c8                	add    %ecx,%eax
  8009e3:	8a 40 04             	mov    0x4(%eax),%al
  8009e6:	84 c0                	test   %al,%al
  8009e8:	75 46                	jne    800a30 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ea:	a1 24 60 80 00       	mov    0x806024,%eax
  8009ef:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	01 c0                	add    %eax,%eax
  8009fc:	01 d0                	add    %edx,%eax
  8009fe:	c1 e0 03             	shl    $0x3,%eax
  800a01:	01 c8                	add    %ecx,%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a10:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a15:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	01 c8                	add    %ecx,%eax
  800a21:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a23:	39 c2                	cmp    %eax,%edx
  800a25:	75 09                	jne    800a30 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a27:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a2e:	eb 15                	jmp    800a45 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a30:	ff 45 e8             	incl   -0x18(%ebp)
  800a33:	a1 24 60 80 00       	mov    0x806024,%eax
  800a38:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	77 85                	ja     8009ca <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a49:	75 14                	jne    800a5f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a4b:	83 ec 04             	sub    $0x4,%esp
  800a4e:	68 84 4b 80 00       	push   $0x804b84
  800a53:	6a 3a                	push   $0x3a
  800a55:	68 78 4b 80 00       	push   $0x804b78
  800a5a:	e8 88 fe ff ff       	call   8008e7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a5f:	ff 45 f0             	incl   -0x10(%ebp)
  800a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a65:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a68:	0f 8c 2f ff ff ff    	jl     80099d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7c:	eb 26                	jmp    800aa4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7e:	a1 24 60 80 00       	mov    0x806024,%eax
  800a83:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8c:	89 d0                	mov    %edx,%eax
  800a8e:	01 c0                	add    %eax,%eax
  800a90:	01 d0                	add    %edx,%eax
  800a92:	c1 e0 03             	shl    $0x3,%eax
  800a95:	01 c8                	add    %ecx,%eax
  800a97:	8a 40 04             	mov    0x4(%eax),%al
  800a9a:	3c 01                	cmp    $0x1,%al
  800a9c:	75 03                	jne    800aa1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a9e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa1:	ff 45 e0             	incl   -0x20(%ebp)
  800aa4:	a1 24 60 80 00       	mov    0x806024,%eax
  800aa9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab2:	39 c2                	cmp    %eax,%edx
  800ab4:	77 c8                	ja     800a7e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800abc:	74 14                	je     800ad2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800abe:	83 ec 04             	sub    $0x4,%esp
  800ac1:	68 d8 4b 80 00       	push   $0x804bd8
  800ac6:	6a 44                	push   $0x44
  800ac8:	68 78 4b 80 00       	push   $0x804b78
  800acd:	e8 15 fe ff ff       	call   8008e7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad2:	90                   	nop
  800ad3:	c9                   	leave  
  800ad4:	c3                   	ret    

00800ad5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	53                   	push   %ebx
  800ad9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae7:	89 0a                	mov    %ecx,(%edx)
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	88 d1                	mov    %dl,%cl
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aff:	75 30                	jne    800b31 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b01:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800b07:	a0 64 e0 81 00       	mov    0x81e064,%al
  800b0c:	0f b6 c0             	movzbl %al,%eax
  800b0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b12:	8b 09                	mov    (%ecx),%ecx
  800b14:	89 cb                	mov    %ecx,%ebx
  800b16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b19:	83 c1 08             	add    $0x8,%ecx
  800b1c:	52                   	push   %edx
  800b1d:	50                   	push   %eax
  800b1e:	53                   	push   %ebx
  800b1f:	51                   	push   %ecx
  800b20:	e8 0e 2a 00 00       	call   803533 <sys_cputs>
  800b25:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 40 04             	mov    0x4(%eax),%eax
  800b37:	8d 50 01             	lea    0x1(%eax),%edx
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b40:	90                   	nop
  800b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b4f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b56:	00 00 00 
	b.cnt = 0;
  800b59:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b60:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	ff 75 08             	pushl  0x8(%ebp)
  800b69:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b6f:	50                   	push   %eax
  800b70:	68 d5 0a 80 00       	push   $0x800ad5
  800b75:	e8 5a 02 00 00       	call   800dd4 <vprintfmt>
  800b7a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b7d:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800b83:	a0 64 e0 81 00       	mov    0x81e064,%al
  800b88:	0f b6 c0             	movzbl %al,%eax
  800b8b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800b91:	52                   	push   %edx
  800b92:	50                   	push   %eax
  800b93:	51                   	push   %ecx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 90 29 00 00       	call   803533 <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 6f ff ff ff       	call   800b46 <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800be8:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	c1 e0 08             	shl    $0x8,%eax
  800bf5:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800bfa:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0c:	50                   	push   %eax
  800c0d:	e8 34 ff ff ff       	call   800b46 <vcprintf>
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c18:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800c1f:	07 00 00 

	return cnt;
  800c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c2d:	e8 45 29 00 00       	call   803577 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c32:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	50                   	push   %eax
  800c42:	e8 ff fe ff ff       	call   800b46 <vcprintf>
  800c47:	83 c4 10             	add    $0x10,%esp
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c4d:	e8 3f 29 00 00       	call   803591 <sys_unlock_cons>
	return cnt;
  800c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 14             	sub    $0x14,%esp
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c64:	8b 45 14             	mov    0x14(%ebp),%eax
  800c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c6a:	8b 45 18             	mov    0x18(%ebp),%eax
  800c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c72:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c75:	77 55                	ja     800ccc <printnum+0x75>
  800c77:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c7a:	72 05                	jb     800c81 <printnum+0x2a>
  800c7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c7f:	77 4b                	ja     800ccc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c81:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c84:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c87:	8b 45 18             	mov    0x18(%ebp),%eax
  800c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8f:	52                   	push   %edx
  800c90:	50                   	push   %eax
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	ff 75 f0             	pushl  -0x10(%ebp)
  800c97:	e8 ac 38 00 00       	call   804548 <__udivdi3>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	ff 75 20             	pushl  0x20(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	ff 75 18             	pushl  0x18(%ebp)
  800ca9:	52                   	push   %edx
  800caa:	50                   	push   %eax
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	ff 75 08             	pushl  0x8(%ebp)
  800cb1:	e8 a1 ff ff ff       	call   800c57 <printnum>
  800cb6:	83 c4 20             	add    $0x20,%esp
  800cb9:	eb 1a                	jmp    800cd5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	ff 75 20             	pushl  0x20(%ebp)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ccc:	ff 4d 1c             	decl   0x1c(%ebp)
  800ccf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cd3:	7f e6                	jg     800cbb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cd5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce3:	53                   	push   %ebx
  800ce4:	51                   	push   %ecx
  800ce5:	52                   	push   %edx
  800ce6:	50                   	push   %eax
  800ce7:	e8 6c 39 00 00       	call   804658 <__umoddi3>
  800cec:	83 c4 10             	add    $0x10,%esp
  800cef:	05 54 4e 80 00       	add    $0x804e54,%eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	0f be c0             	movsbl %al,%eax
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	50                   	push   %eax
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	ff d0                	call   *%eax
  800d05:	83 c4 10             	add    $0x10,%esp
}
  800d08:	90                   	nop
  800d09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d15:	7e 1c                	jle    800d33 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8b 00                	mov    (%eax),%eax
  800d1c:	8d 50 08             	lea    0x8(%eax),%edx
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	89 10                	mov    %edx,(%eax)
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	83 e8 08             	sub    $0x8,%eax
  800d2c:	8b 50 04             	mov    0x4(%eax),%edx
  800d2f:	8b 00                	mov    (%eax),%eax
  800d31:	eb 40                	jmp    800d73 <getuint+0x65>
	else if (lflag)
  800d33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d37:	74 1e                	je     800d57 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 04             	lea    0x4(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 04             	sub    $0x4,%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	eb 1c                	jmp    800d73 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	8d 50 04             	lea    0x4(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	89 10                	mov    %edx,(%eax)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d78:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d7c:	7e 1c                	jle    800d9a <getint+0x25>
		return va_arg(*ap, long long);
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	8d 50 08             	lea    0x8(%eax),%edx
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	89 10                	mov    %edx,(%eax)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	83 e8 08             	sub    $0x8,%eax
  800d93:	8b 50 04             	mov    0x4(%eax),%edx
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	eb 38                	jmp    800dd2 <getint+0x5d>
	else if (lflag)
  800d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9e:	74 1a                	je     800dba <getint+0x45>
		return va_arg(*ap, long);
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	8d 50 04             	lea    0x4(%eax),%edx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 10                	mov    %edx,(%eax)
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8b 00                	mov    (%eax),%eax
  800db2:	83 e8 04             	sub    $0x4,%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	99                   	cltd   
  800db8:	eb 18                	jmp    800dd2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8b 00                	mov    (%eax),%eax
  800dbf:	8d 50 04             	lea    0x4(%eax),%edx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 10                	mov    %edx,(%eax)
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8b 00                	mov    (%eax),%eax
  800dcc:	83 e8 04             	sub    $0x4,%eax
  800dcf:	8b 00                	mov    (%eax),%eax
  800dd1:	99                   	cltd   
}
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ddc:	eb 17                	jmp    800df5 <vprintfmt+0x21>
			if (ch == '\0')
  800dde:	85 db                	test   %ebx,%ebx
  800de0:	0f 84 c1 03 00 00    	je     8011a7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	53                   	push   %ebx
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	ff d0                	call   *%eax
  800df2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	0f b6 d8             	movzbl %al,%ebx
  800e03:	83 fb 25             	cmp    $0x25,%ebx
  800e06:	75 d6                	jne    800dde <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e08:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e0c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	8d 50 01             	lea    0x1(%eax),%edx
  800e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	0f b6 d8             	movzbl %al,%ebx
  800e36:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e39:	83 f8 5b             	cmp    $0x5b,%eax
  800e3c:	0f 87 3d 03 00 00    	ja     80117f <vprintfmt+0x3ab>
  800e42:	8b 04 85 78 4e 80 00 	mov    0x804e78(,%eax,4),%eax
  800e49:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e4b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e4f:	eb d7                	jmp    800e28 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e51:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e55:	eb d1                	jmp    800e28 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e61:	89 d0                	mov    %edx,%eax
  800e63:	c1 e0 02             	shl    $0x2,%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	01 c0                	add    %eax,%eax
  800e6a:	01 d8                	add    %ebx,%eax
  800e6c:	83 e8 30             	sub    $0x30,%eax
  800e6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e7a:	83 fb 2f             	cmp    $0x2f,%ebx
  800e7d:	7e 3e                	jle    800ebd <vprintfmt+0xe9>
  800e7f:	83 fb 39             	cmp    $0x39,%ebx
  800e82:	7f 39                	jg     800ebd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e84:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e87:	eb d5                	jmp    800e5e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e89:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8c:	83 c0 04             	add    $0x4,%eax
  800e8f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e92:	8b 45 14             	mov    0x14(%ebp),%eax
  800e95:	83 e8 04             	sub    $0x4,%eax
  800e98:	8b 00                	mov    (%eax),%eax
  800e9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e9d:	eb 1f                	jmp    800ebe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ea3:	79 83                	jns    800e28 <vprintfmt+0x54>
				width = 0;
  800ea5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800eac:	e9 77 ff ff ff       	jmp    800e28 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800eb1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800eb8:	e9 6b ff ff ff       	jmp    800e28 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ebd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ebe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec2:	0f 89 60 ff ff ff    	jns    800e28 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ecb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ece:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ed5:	e9 4e ff ff ff       	jmp    800e28 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800eda:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800edd:	e9 46 ff ff ff       	jmp    800e28 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee5:	83 c0 04             	add    $0x4,%eax
  800ee8:	89 45 14             	mov    %eax,0x14(%ebp)
  800eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  800eee:	83 e8 04             	sub    $0x4,%eax
  800ef1:	8b 00                	mov    (%eax),%eax
  800ef3:	83 ec 08             	sub    $0x8,%esp
  800ef6:	ff 75 0c             	pushl  0xc(%ebp)
  800ef9:	50                   	push   %eax
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	ff d0                	call   *%eax
  800eff:	83 c4 10             	add    $0x10,%esp
			break;
  800f02:	e9 9b 02 00 00       	jmp    8011a2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f18:	85 db                	test   %ebx,%ebx
  800f1a:	79 02                	jns    800f1e <vprintfmt+0x14a>
				err = -err;
  800f1c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f1e:	83 fb 64             	cmp    $0x64,%ebx
  800f21:	7f 0b                	jg     800f2e <vprintfmt+0x15a>
  800f23:	8b 34 9d c0 4c 80 00 	mov    0x804cc0(,%ebx,4),%esi
  800f2a:	85 f6                	test   %esi,%esi
  800f2c:	75 19                	jne    800f47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f2e:	53                   	push   %ebx
  800f2f:	68 65 4e 80 00       	push   $0x804e65
  800f34:	ff 75 0c             	pushl  0xc(%ebp)
  800f37:	ff 75 08             	pushl  0x8(%ebp)
  800f3a:	e8 70 02 00 00       	call   8011af <printfmt>
  800f3f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f42:	e9 5b 02 00 00       	jmp    8011a2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f47:	56                   	push   %esi
  800f48:	68 6e 4e 80 00       	push   $0x804e6e
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	ff 75 08             	pushl  0x8(%ebp)
  800f53:	e8 57 02 00 00       	call   8011af <printfmt>
  800f58:	83 c4 10             	add    $0x10,%esp
			break;
  800f5b:	e9 42 02 00 00       	jmp    8011a2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f60:	8b 45 14             	mov    0x14(%ebp),%eax
  800f63:	83 c0 04             	add    $0x4,%eax
  800f66:	89 45 14             	mov    %eax,0x14(%ebp)
  800f69:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6c:	83 e8 04             	sub    $0x4,%eax
  800f6f:	8b 30                	mov    (%eax),%esi
  800f71:	85 f6                	test   %esi,%esi
  800f73:	75 05                	jne    800f7a <vprintfmt+0x1a6>
				p = "(null)";
  800f75:	be 71 4e 80 00       	mov    $0x804e71,%esi
			if (width > 0 && padc != '-')
  800f7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7e:	7e 6d                	jle    800fed <vprintfmt+0x219>
  800f80:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f84:	74 67                	je     800fed <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	50                   	push   %eax
  800f8d:	56                   	push   %esi
  800f8e:	e8 26 05 00 00       	call   8014b9 <strnlen>
  800f93:	83 c4 10             	add    $0x10,%esp
  800f96:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f99:	eb 16                	jmp    800fb1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f9b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 0c             	pushl  0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	ff d0                	call   *%eax
  800fab:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fae:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb5:	7f e4                	jg     800f9b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb7:	eb 34                	jmp    800fed <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fbd:	74 1c                	je     800fdb <vprintfmt+0x207>
  800fbf:	83 fb 1f             	cmp    $0x1f,%ebx
  800fc2:	7e 05                	jle    800fc9 <vprintfmt+0x1f5>
  800fc4:	83 fb 7e             	cmp    $0x7e,%ebx
  800fc7:	7e 12                	jle    800fdb <vprintfmt+0x207>
					putch('?', putdat);
  800fc9:	83 ec 08             	sub    $0x8,%esp
  800fcc:	ff 75 0c             	pushl  0xc(%ebp)
  800fcf:	6a 3f                	push   $0x3f
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	ff d0                	call   *%eax
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	eb 0f                	jmp    800fea <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fdb:	83 ec 08             	sub    $0x8,%esp
  800fde:	ff 75 0c             	pushl  0xc(%ebp)
  800fe1:	53                   	push   %ebx
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	ff d0                	call   *%eax
  800fe7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fea:	ff 4d e4             	decl   -0x1c(%ebp)
  800fed:	89 f0                	mov    %esi,%eax
  800fef:	8d 70 01             	lea    0x1(%eax),%esi
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be d8             	movsbl %al,%ebx
  800ff7:	85 db                	test   %ebx,%ebx
  800ff9:	74 24                	je     80101f <vprintfmt+0x24b>
  800ffb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fff:	78 b8                	js     800fb9 <vprintfmt+0x1e5>
  801001:	ff 4d e0             	decl   -0x20(%ebp)
  801004:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801008:	79 af                	jns    800fb9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80100a:	eb 13                	jmp    80101f <vprintfmt+0x24b>
				putch(' ', putdat);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	6a 20                	push   $0x20
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	ff d0                	call   *%eax
  801019:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80101c:	ff 4d e4             	decl   -0x1c(%ebp)
  80101f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801023:	7f e7                	jg     80100c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801025:	e9 78 01 00 00       	jmp    8011a2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80102a:	83 ec 08             	sub    $0x8,%esp
  80102d:	ff 75 e8             	pushl  -0x18(%ebp)
  801030:	8d 45 14             	lea    0x14(%ebp),%eax
  801033:	50                   	push   %eax
  801034:	e8 3c fd ff ff       	call   800d75 <getint>
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801045:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801048:	85 d2                	test   %edx,%edx
  80104a:	79 23                	jns    80106f <vprintfmt+0x29b>
				putch('-', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 2d                	push   $0x2d
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80105c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801062:	f7 d8                	neg    %eax
  801064:	83 d2 00             	adc    $0x0,%edx
  801067:	f7 da                	neg    %edx
  801069:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80106f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801076:	e9 bc 00 00 00       	jmp    801137 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80107b:	83 ec 08             	sub    $0x8,%esp
  80107e:	ff 75 e8             	pushl  -0x18(%ebp)
  801081:	8d 45 14             	lea    0x14(%ebp),%eax
  801084:	50                   	push   %eax
  801085:	e8 84 fc ff ff       	call   800d0e <getuint>
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801090:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801093:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80109a:	e9 98 00 00 00       	jmp    801137 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 58                	push   $0x58
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010af:	83 ec 08             	sub    $0x8,%esp
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	6a 58                	push   $0x58
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	ff d0                	call   *%eax
  8010bc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010bf:	83 ec 08             	sub    $0x8,%esp
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	6a 58                	push   $0x58
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	ff d0                	call   *%eax
  8010cc:	83 c4 10             	add    $0x10,%esp
			break;
  8010cf:	e9 ce 00 00 00       	jmp    8011a2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	6a 30                	push   $0x30
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	ff d0                	call   *%eax
  8010e1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	6a 78                	push   $0x78
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	ff d0                	call   *%eax
  8010f1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f7:	83 c0 04             	add    $0x4,%eax
  8010fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8010fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801100:	83 e8 04             	sub    $0x4,%eax
  801103:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801105:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801108:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80110f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801116:	eb 1f                	jmp    801137 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801118:	83 ec 08             	sub    $0x8,%esp
  80111b:	ff 75 e8             	pushl  -0x18(%ebp)
  80111e:	8d 45 14             	lea    0x14(%ebp),%eax
  801121:	50                   	push   %eax
  801122:	e8 e7 fb ff ff       	call   800d0e <getuint>
  801127:	83 c4 10             	add    $0x10,%esp
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801130:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801137:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80113b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80113e:	83 ec 04             	sub    $0x4,%esp
  801141:	52                   	push   %edx
  801142:	ff 75 e4             	pushl  -0x1c(%ebp)
  801145:	50                   	push   %eax
  801146:	ff 75 f4             	pushl  -0xc(%ebp)
  801149:	ff 75 f0             	pushl  -0x10(%ebp)
  80114c:	ff 75 0c             	pushl  0xc(%ebp)
  80114f:	ff 75 08             	pushl  0x8(%ebp)
  801152:	e8 00 fb ff ff       	call   800c57 <printnum>
  801157:	83 c4 20             	add    $0x20,%esp
			break;
  80115a:	eb 46                	jmp    8011a2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	53                   	push   %ebx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	ff d0                	call   *%eax
  801168:	83 c4 10             	add    $0x10,%esp
			break;
  80116b:	eb 35                	jmp    8011a2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80116d:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  801174:	eb 2c                	jmp    8011a2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801176:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  80117d:	eb 23                	jmp    8011a2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	ff 75 0c             	pushl  0xc(%ebp)
  801185:	6a 25                	push   $0x25
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	ff d0                	call   *%eax
  80118c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80118f:	ff 4d 10             	decl   0x10(%ebp)
  801192:	eb 03                	jmp    801197 <vprintfmt+0x3c3>
  801194:	ff 4d 10             	decl   0x10(%ebp)
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	48                   	dec    %eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 25                	cmp    $0x25,%al
  80119f:	75 f3                	jne    801194 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011a1:	90                   	nop
		}
	}
  8011a2:	e9 35 fc ff ff       	jmp    800ddc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011a7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    

008011af <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b8:	83 c0 04             	add    $0x4,%eax
  8011bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c4:	50                   	push   %eax
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	e8 04 fc ff ff       	call   800dd4 <vprintfmt>
  8011d0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011d3:	90                   	nop
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	8b 40 08             	mov    0x8(%eax),%eax
  8011df:	8d 50 01             	lea    0x1(%eax),%edx
  8011e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	8b 10                	mov    (%eax),%edx
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	8b 40 04             	mov    0x4(%eax),%eax
  8011f3:	39 c2                	cmp    %eax,%edx
  8011f5:	73 12                	jae    801209 <sprintputch+0x33>
		*b->buf++ = ch;
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	8b 00                	mov    (%eax),%eax
  8011fc:	8d 48 01             	lea    0x1(%eax),%ecx
  8011ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801202:	89 0a                	mov    %ecx,(%edx)
  801204:	8b 55 08             	mov    0x8(%ebp),%edx
  801207:	88 10                	mov    %dl,(%eax)
}
  801209:	90                   	nop
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801226:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80122d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801231:	74 06                	je     801239 <vsnprintf+0x2d>
  801233:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801237:	7f 07                	jg     801240 <vsnprintf+0x34>
		return -E_INVAL;
  801239:	b8 03 00 00 00       	mov    $0x3,%eax
  80123e:	eb 20                	jmp    801260 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801240:	ff 75 14             	pushl  0x14(%ebp)
  801243:	ff 75 10             	pushl  0x10(%ebp)
  801246:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801249:	50                   	push   %eax
  80124a:	68 d6 11 80 00       	push   $0x8011d6
  80124f:	e8 80 fb ff ff       	call   800dd4 <vprintfmt>
  801254:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80125a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80125d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801268:	8d 45 10             	lea    0x10(%ebp),%eax
  80126b:	83 c0 04             	add    $0x4,%eax
  80126e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801271:	8b 45 10             	mov    0x10(%ebp),%eax
  801274:	ff 75 f4             	pushl  -0xc(%ebp)
  801277:	50                   	push   %eax
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	ff 75 08             	pushl  0x8(%ebp)
  80127e:	e8 89 ff ff ff       	call   80120c <vsnprintf>
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801289:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801298:	74 13                	je     8012ad <readline+0x1f>
		cprintf("%s", prompt);
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	68 e8 4f 80 00       	push   $0x804fe8
  8012a5:	e8 0b f9 ff ff       	call   800bb5 <cprintf>
  8012aa:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	6a 00                	push   $0x0
  8012b9:	e8 6f f4 ff ff       	call   80072d <iscons>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012c4:	e8 51 f4 ff ff       	call   80071a <getchar>
  8012c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012d0:	79 22                	jns    8012f4 <readline+0x66>
			if (c != -E_EOF)
  8012d2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012d6:	0f 84 ad 00 00 00    	je     801389 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e2:	68 eb 4f 80 00       	push   $0x804feb
  8012e7:	e8 c9 f8 ff ff       	call   800bb5 <cprintf>
  8012ec:	83 c4 10             	add    $0x10,%esp
			break;
  8012ef:	e9 95 00 00 00       	jmp    801389 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012f4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012f8:	7e 34                	jle    80132e <readline+0xa0>
  8012fa:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801301:	7f 2b                	jg     80132e <readline+0xa0>
			if (echoing)
  801303:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801307:	74 0e                	je     801317 <readline+0x89>
				cputchar(c);
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	ff 75 ec             	pushl  -0x14(%ebp)
  80130f:	e8 e7 f3 ff ff       	call   8006fb <cputchar>
  801314:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131a:	8d 50 01             	lea    0x1(%eax),%edx
  80131d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801320:	89 c2                	mov    %eax,%edx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80132a:	88 10                	mov    %dl,(%eax)
  80132c:	eb 56                	jmp    801384 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80132e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801332:	75 1f                	jne    801353 <readline+0xc5>
  801334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801338:	7e 19                	jle    801353 <readline+0xc5>
			if (echoing)
  80133a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80133e:	74 0e                	je     80134e <readline+0xc0>
				cputchar(c);
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	ff 75 ec             	pushl  -0x14(%ebp)
  801346:	e8 b0 f3 ff ff       	call   8006fb <cputchar>
  80134b:	83 c4 10             	add    $0x10,%esp

			i--;
  80134e:	ff 4d f4             	decl   -0xc(%ebp)
  801351:	eb 31                	jmp    801384 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801353:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801357:	74 0a                	je     801363 <readline+0xd5>
  801359:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80135d:	0f 85 61 ff ff ff    	jne    8012c4 <readline+0x36>
			if (echoing)
  801363:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801367:	74 0e                	je     801377 <readline+0xe9>
				cputchar(c);
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	ff 75 ec             	pushl  -0x14(%ebp)
  80136f:	e8 87 f3 ff ff       	call   8006fb <cputchar>
  801374:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137d:	01 d0                	add    %edx,%eax
  80137f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801382:	eb 06                	jmp    80138a <readline+0xfc>
		}
	}
  801384:	e9 3b ff ff ff       	jmp    8012c4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801389:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80138a:	90                   	nop
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801393:	e8 df 21 00 00       	call   803577 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139c:	74 13                	je     8013b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	ff 75 08             	pushl  0x8(%ebp)
  8013a4:	68 e8 4f 80 00       	push   $0x804fe8
  8013a9:	e8 07 f8 ff ff       	call   800bb5 <cprintf>
  8013ae:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013b8:	83 ec 0c             	sub    $0xc,%esp
  8013bb:	6a 00                	push   $0x0
  8013bd:	e8 6b f3 ff ff       	call   80072d <iscons>
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013c8:	e8 4d f3 ff ff       	call   80071a <getchar>
  8013cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013d4:	79 22                	jns    8013f8 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8013d6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013da:	0f 84 ad 00 00 00    	je     80148d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8013e6:	68 eb 4f 80 00       	push   $0x804feb
  8013eb:	e8 c5 f7 ff ff       	call   800bb5 <cprintf>
  8013f0:	83 c4 10             	add    $0x10,%esp
				break;
  8013f3:	e9 95 00 00 00       	jmp    80148d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8013f8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013fc:	7e 34                	jle    801432 <atomic_readline+0xa5>
  8013fe:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801405:	7f 2b                	jg     801432 <atomic_readline+0xa5>
				if (echoing)
  801407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80140b:	74 0e                	je     80141b <atomic_readline+0x8e>
					cputchar(c);
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	ff 75 ec             	pushl  -0x14(%ebp)
  801413:	e8 e3 f2 ff ff       	call   8006fb <cputchar>
  801418:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141e:	8d 50 01             	lea    0x1(%eax),%edx
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801424:	89 c2                	mov    %eax,%edx
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80142e:	88 10                	mov    %dl,(%eax)
  801430:	eb 56                	jmp    801488 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801432:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801436:	75 1f                	jne    801457 <atomic_readline+0xca>
  801438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80143c:	7e 19                	jle    801457 <atomic_readline+0xca>
				if (echoing)
  80143e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801442:	74 0e                	je     801452 <atomic_readline+0xc5>
					cputchar(c);
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	ff 75 ec             	pushl  -0x14(%ebp)
  80144a:	e8 ac f2 ff ff       	call   8006fb <cputchar>
  80144f:	83 c4 10             	add    $0x10,%esp
				i--;
  801452:	ff 4d f4             	decl   -0xc(%ebp)
  801455:	eb 31                	jmp    801488 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801457:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80145b:	74 0a                	je     801467 <atomic_readline+0xda>
  80145d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801461:	0f 85 61 ff ff ff    	jne    8013c8 <atomic_readline+0x3b>
				if (echoing)
  801467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80146b:	74 0e                	je     80147b <atomic_readline+0xee>
					cputchar(c);
  80146d:	83 ec 0c             	sub    $0xc,%esp
  801470:	ff 75 ec             	pushl  -0x14(%ebp)
  801473:	e8 83 f2 ff ff       	call   8006fb <cputchar>
  801478:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80147b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801481:	01 d0                	add    %edx,%eax
  801483:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801486:	eb 06                	jmp    80148e <atomic_readline+0x101>
			}
		}
  801488:	e9 3b ff ff ff       	jmp    8013c8 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80148d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80148e:	e8 fe 20 00 00       	call   803591 <sys_unlock_cons>
}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 06                	jmp    8014ab <strlen+0x15>
		n++;
  8014a5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014a8:	ff 45 08             	incl   0x8(%ebp)
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	84 c0                	test   %al,%al
  8014b2:	75 f1                	jne    8014a5 <strlen+0xf>
		n++;
	return n;
  8014b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c6:	eb 09                	jmp    8014d1 <strnlen+0x18>
		n++;
  8014c8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014cb:	ff 45 08             	incl   0x8(%ebp)
  8014ce:	ff 4d 0c             	decl   0xc(%ebp)
  8014d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014d5:	74 09                	je     8014e0 <strnlen+0x27>
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	84 c0                	test   %al,%al
  8014de:	75 e8                	jne    8014c8 <strnlen+0xf>
		n++;
	return n;
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8014f1:	90                   	nop
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801501:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801504:	8a 12                	mov    (%edx),%dl
  801506:	88 10                	mov    %dl,(%eax)
  801508:	8a 00                	mov    (%eax),%al
  80150a:	84 c0                	test   %al,%al
  80150c:	75 e4                	jne    8014f2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80150e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80151f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801526:	eb 1f                	jmp    801547 <strncpy+0x34>
		*dst++ = *src;
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8d 50 01             	lea    0x1(%eax),%edx
  80152e:	89 55 08             	mov    %edx,0x8(%ebp)
  801531:	8b 55 0c             	mov    0xc(%ebp),%edx
  801534:	8a 12                	mov    (%edx),%dl
  801536:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	84 c0                	test   %al,%al
  80153f:	74 03                	je     801544 <strncpy+0x31>
			src++;
  801541:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801544:	ff 45 fc             	incl   -0x4(%ebp)
  801547:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80154d:	72 d9                	jb     801528 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80154f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801560:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801564:	74 30                	je     801596 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801566:	eb 16                	jmp    80157e <strlcpy+0x2a>
			*dst++ = *src++;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8d 50 01             	lea    0x1(%eax),%edx
  80156e:	89 55 08             	mov    %edx,0x8(%ebp)
  801571:	8b 55 0c             	mov    0xc(%ebp),%edx
  801574:	8d 4a 01             	lea    0x1(%edx),%ecx
  801577:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80157a:	8a 12                	mov    (%edx),%dl
  80157c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80157e:	ff 4d 10             	decl   0x10(%ebp)
  801581:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801585:	74 09                	je     801590 <strlcpy+0x3c>
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	84 c0                	test   %al,%al
  80158e:	75 d8                	jne    801568 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801596:	8b 55 08             	mov    0x8(%ebp),%edx
  801599:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159c:	29 c2                	sub    %eax,%edx
  80159e:	89 d0                	mov    %edx,%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015a5:	eb 06                	jmp    8015ad <strcmp+0xb>
		p++, q++;
  8015a7:	ff 45 08             	incl   0x8(%ebp)
  8015aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	84 c0                	test   %al,%al
  8015b4:	74 0e                	je     8015c4 <strcmp+0x22>
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 10                	mov    (%eax),%dl
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	38 c2                	cmp    %al,%dl
  8015c2:	74 e3                	je     8015a7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	0f b6 d0             	movzbl %al,%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	0f b6 c0             	movzbl %al,%eax
  8015d4:	29 c2                	sub    %eax,%edx
  8015d6:	89 d0                	mov    %edx,%eax
}
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015dd:	eb 09                	jmp    8015e8 <strncmp+0xe>
		n--, p++, q++;
  8015df:	ff 4d 10             	decl   0x10(%ebp)
  8015e2:	ff 45 08             	incl   0x8(%ebp)
  8015e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ec:	74 17                	je     801605 <strncmp+0x2b>
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	84 c0                	test   %al,%al
  8015f5:	74 0e                	je     801605 <strncmp+0x2b>
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 10                	mov    (%eax),%dl
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	8a 00                	mov    (%eax),%al
  801601:	38 c2                	cmp    %al,%dl
  801603:	74 da                	je     8015df <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801605:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801609:	75 07                	jne    801612 <strncmp+0x38>
		return 0;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	eb 14                	jmp    801626 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	8a 00                	mov    (%eax),%al
  801617:	0f b6 d0             	movzbl %al,%edx
  80161a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	0f b6 c0             	movzbl %al,%eax
  801622:	29 c2                	sub    %eax,%edx
  801624:	89 d0                	mov    %edx,%eax
}
  801626:	5d                   	pop    %ebp
  801627:	c3                   	ret    

00801628 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801631:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801634:	eb 12                	jmp    801648 <strchr+0x20>
		if (*s == c)
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80163e:	75 05                	jne    801645 <strchr+0x1d>
			return (char *) s;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	eb 11                	jmp    801656 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801645:	ff 45 08             	incl   0x8(%ebp)
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8a 00                	mov    (%eax),%al
  80164d:	84 c0                	test   %al,%al
  80164f:	75 e5                	jne    801636 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801664:	eb 0d                	jmp    801673 <strfind+0x1b>
		if (*s == c)
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80166e:	74 0e                	je     80167e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 ea                	jne    801666 <strfind+0xe>
  80167c:	eb 01                	jmp    80167f <strfind+0x27>
		if (*s == c)
			break;
  80167e:	90                   	nop
	return (char *) s;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801690:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801694:	76 63                	jbe    8016f9 <memset+0x75>
		uint64 data_block = c;
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	99                   	cltd   
  80169a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80169d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8016aa:	c1 e0 08             	shl    $0x8,%eax
  8016ad:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016b0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8016b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8016bd:	c1 e0 10             	shl    $0x10,%eax
  8016c0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016c3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cc:	89 c2                	mov    %eax,%edx
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8016d6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8016d9:	eb 18                	jmp    8016f3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8016db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016de:	8d 41 08             	lea    0x8(%ecx),%eax
  8016e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8016e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ea:	89 01                	mov    %eax,(%ecx)
  8016ec:	89 51 04             	mov    %edx,0x4(%ecx)
  8016ef:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8016f3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8016f7:	77 e2                	ja     8016db <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8016f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016fd:	74 23                	je     801722 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8016ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801702:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801705:	eb 0e                	jmp    801715 <memset+0x91>
			*p8++ = (uint8)c;
  801707:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170a:	8d 50 01             	lea    0x1(%eax),%edx
  80170d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801710:	8b 55 0c             	mov    0xc(%ebp),%edx
  801713:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801715:	8b 45 10             	mov    0x10(%ebp),%eax
  801718:	8d 50 ff             	lea    -0x1(%eax),%edx
  80171b:	89 55 10             	mov    %edx,0x10(%ebp)
  80171e:	85 c0                	test   %eax,%eax
  801720:	75 e5                	jne    801707 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80172d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801730:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801739:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80173d:	76 24                	jbe    801763 <memcpy+0x3c>
		while(n >= 8){
  80173f:	eb 1c                	jmp    80175d <memcpy+0x36>
			*d64 = *s64;
  801741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801744:	8b 50 04             	mov    0x4(%eax),%edx
  801747:	8b 00                	mov    (%eax),%eax
  801749:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80174c:	89 01                	mov    %eax,(%ecx)
  80174e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801751:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801755:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801759:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80175d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801761:	77 de                	ja     801741 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801763:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801767:	74 31                	je     80179a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801769:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80176c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80176f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801772:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801775:	eb 16                	jmp    80178d <memcpy+0x66>
			*d8++ = *s8++;
  801777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177a:	8d 50 01             	lea    0x1(%eax),%edx
  80177d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801783:	8d 4a 01             	lea    0x1(%edx),%ecx
  801786:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801789:	8a 12                	mov    (%edx),%dl
  80178b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80178d:	8b 45 10             	mov    0x10(%ebp),%eax
  801790:	8d 50 ff             	lea    -0x1(%eax),%edx
  801793:	89 55 10             	mov    %edx,0x10(%ebp)
  801796:	85 c0                	test   %eax,%eax
  801798:	75 dd                	jne    801777 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017b7:	73 50                	jae    801809 <memmove+0x6a>
  8017b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017c4:	76 43                	jbe    801809 <memmove+0x6a>
		s += n;
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017d2:	eb 10                	jmp    8017e4 <memmove+0x45>
			*--d = *--s;
  8017d4:	ff 4d f8             	decl   -0x8(%ebp)
  8017d7:	ff 4d fc             	decl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	8a 10                	mov    (%eax),%dl
  8017df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8017e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	75 e3                	jne    8017d4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017f1:	eb 23                	jmp    801816 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8017f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f6:	8d 50 01             	lea    0x1(%eax),%edx
  8017f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801802:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801805:	8a 12                	mov    (%edx),%dl
  801807:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801809:	8b 45 10             	mov    0x10(%ebp),%eax
  80180c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180f:	89 55 10             	mov    %edx,0x10(%ebp)
  801812:	85 c0                	test   %eax,%eax
  801814:	75 dd                	jne    8017f3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80182d:	eb 2a                	jmp    801859 <memcmp+0x3e>
		if (*s1 != *s2)
  80182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801832:	8a 10                	mov    (%eax),%dl
  801834:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801837:	8a 00                	mov    (%eax),%al
  801839:	38 c2                	cmp    %al,%dl
  80183b:	74 16                	je     801853 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80183d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	0f b6 d0             	movzbl %al,%edx
  801845:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801848:	8a 00                	mov    (%eax),%al
  80184a:	0f b6 c0             	movzbl %al,%eax
  80184d:	29 c2                	sub    %eax,%edx
  80184f:	89 d0                	mov    %edx,%eax
  801851:	eb 18                	jmp    80186b <memcmp+0x50>
		s1++, s2++;
  801853:	ff 45 fc             	incl   -0x4(%ebp)
  801856:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801859:	8b 45 10             	mov    0x10(%ebp),%eax
  80185c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80185f:	89 55 10             	mov    %edx,0x10(%ebp)
  801862:	85 c0                	test   %eax,%eax
  801864:	75 c9                	jne    80182f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801873:	8b 55 08             	mov    0x8(%ebp),%edx
  801876:	8b 45 10             	mov    0x10(%ebp),%eax
  801879:	01 d0                	add    %edx,%eax
  80187b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80187e:	eb 15                	jmp    801895 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	8a 00                	mov    (%eax),%al
  801885:	0f b6 d0             	movzbl %al,%edx
  801888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188b:	0f b6 c0             	movzbl %al,%eax
  80188e:	39 c2                	cmp    %eax,%edx
  801890:	74 0d                	je     80189f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801892:	ff 45 08             	incl   0x8(%ebp)
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80189b:	72 e3                	jb     801880 <memfind+0x13>
  80189d:	eb 01                	jmp    8018a0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80189f:	90                   	nop
	return (void *) s;
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018b9:	eb 03                	jmp    8018be <strtol+0x19>
		s++;
  8018bb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	3c 20                	cmp    $0x20,%al
  8018c5:	74 f4                	je     8018bb <strtol+0x16>
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	3c 09                	cmp    $0x9,%al
  8018ce:	74 eb                	je     8018bb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	3c 2b                	cmp    $0x2b,%al
  8018d7:	75 05                	jne    8018de <strtol+0x39>
		s++;
  8018d9:	ff 45 08             	incl   0x8(%ebp)
  8018dc:	eb 13                	jmp    8018f1 <strtol+0x4c>
	else if (*s == '-')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2d                	cmp    $0x2d,%al
  8018e5:	75 0a                	jne    8018f1 <strtol+0x4c>
		s++, neg = 1;
  8018e7:	ff 45 08             	incl   0x8(%ebp)
  8018ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018f5:	74 06                	je     8018fd <strtol+0x58>
  8018f7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8018fb:	75 20                	jne    80191d <strtol+0x78>
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8a 00                	mov    (%eax),%al
  801902:	3c 30                	cmp    $0x30,%al
  801904:	75 17                	jne    80191d <strtol+0x78>
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	40                   	inc    %eax
  80190a:	8a 00                	mov    (%eax),%al
  80190c:	3c 78                	cmp    $0x78,%al
  80190e:	75 0d                	jne    80191d <strtol+0x78>
		s += 2, base = 16;
  801910:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801914:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80191b:	eb 28                	jmp    801945 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80191d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801921:	75 15                	jne    801938 <strtol+0x93>
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	3c 30                	cmp    $0x30,%al
  80192a:	75 0c                	jne    801938 <strtol+0x93>
		s++, base = 8;
  80192c:	ff 45 08             	incl   0x8(%ebp)
  80192f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801936:	eb 0d                	jmp    801945 <strtol+0xa0>
	else if (base == 0)
  801938:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80193c:	75 07                	jne    801945 <strtol+0xa0>
		base = 10;
  80193e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	8a 00                	mov    (%eax),%al
  80194a:	3c 2f                	cmp    $0x2f,%al
  80194c:	7e 19                	jle    801967 <strtol+0xc2>
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8a 00                	mov    (%eax),%al
  801953:	3c 39                	cmp    $0x39,%al
  801955:	7f 10                	jg     801967 <strtol+0xc2>
			dig = *s - '0';
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	0f be c0             	movsbl %al,%eax
  80195f:	83 e8 30             	sub    $0x30,%eax
  801962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801965:	eb 42                	jmp    8019a9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	8a 00                	mov    (%eax),%al
  80196c:	3c 60                	cmp    $0x60,%al
  80196e:	7e 19                	jle    801989 <strtol+0xe4>
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8a 00                	mov    (%eax),%al
  801975:	3c 7a                	cmp    $0x7a,%al
  801977:	7f 10                	jg     801989 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	0f be c0             	movsbl %al,%eax
  801981:	83 e8 57             	sub    $0x57,%eax
  801984:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801987:	eb 20                	jmp    8019a9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	8a 00                	mov    (%eax),%al
  80198e:	3c 40                	cmp    $0x40,%al
  801990:	7e 39                	jle    8019cb <strtol+0x126>
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8a 00                	mov    (%eax),%al
  801997:	3c 5a                	cmp    $0x5a,%al
  801999:	7f 30                	jg     8019cb <strtol+0x126>
			dig = *s - 'A' + 10;
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	0f be c0             	movsbl %al,%eax
  8019a3:	83 e8 37             	sub    $0x37,%eax
  8019a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019af:	7d 19                	jge    8019ca <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019b1:	ff 45 08             	incl   0x8(%ebp)
  8019b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019bb:	89 c2                	mov    %eax,%edx
  8019bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c0:	01 d0                	add    %edx,%eax
  8019c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019c5:	e9 7b ff ff ff       	jmp    801945 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ca:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019cf:	74 08                	je     8019d9 <strtol+0x134>
		*endptr = (char *) s;
  8019d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8019d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019dd:	74 07                	je     8019e6 <strtol+0x141>
  8019df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019e2:	f7 d8                	neg    %eax
  8019e4:	eb 03                	jmp    8019e9 <strtol+0x144>
  8019e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <ltostr>:

void
ltostr(long value, char *str)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8019f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8019f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8019ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a03:	79 13                	jns    801a18 <ltostr+0x2d>
	{
		neg = 1;
  801a05:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a12:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a15:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a20:	99                   	cltd   
  801a21:	f7 f9                	idiv   %ecx
  801a23:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a29:	8d 50 01             	lea    0x1(%eax),%edx
  801a2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a2f:	89 c2                	mov    %eax,%edx
  801a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a34:	01 d0                	add    %edx,%eax
  801a36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a39:	83 c2 30             	add    $0x30,%edx
  801a3c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a41:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a46:	f7 e9                	imul   %ecx
  801a48:	c1 fa 02             	sar    $0x2,%edx
  801a4b:	89 c8                	mov    %ecx,%eax
  801a4d:	c1 f8 1f             	sar    $0x1f,%eax
  801a50:	29 c2                	sub    %eax,%edx
  801a52:	89 d0                	mov    %edx,%eax
  801a54:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a5b:	75 bb                	jne    801a18 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a67:	48                   	dec    %eax
  801a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a6f:	74 3d                	je     801aae <ltostr+0xc3>
		start = 1 ;
  801a71:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a78:	eb 34                	jmp    801aae <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a80:	01 d0                	add    %edx,%eax
  801a82:	8a 00                	mov    (%eax),%al
  801a84:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8d:	01 c2                	add    %eax,%edx
  801a8f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a95:	01 c8                	add    %ecx,%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa1:	01 c2                	add    %eax,%edx
  801aa3:	8a 45 eb             	mov    -0x15(%ebp),%al
  801aa6:	88 02                	mov    %al,(%edx)
		start++ ;
  801aa8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aab:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ab4:	7c c4                	jl     801a7a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ab6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abc:	01 d0                	add    %edx,%eax
  801abe:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801ac1:	90                   	nop
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	e8 c4 f9 ff ff       	call   801496 <strlen>
  801ad2:	83 c4 04             	add    $0x4,%esp
  801ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	e8 b6 f9 ff ff       	call   801496 <strlen>
  801ae0:	83 c4 04             	add    $0x4,%esp
  801ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ae6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801af4:	eb 17                	jmp    801b0d <strcconcat+0x49>
		final[s] = str1[s] ;
  801af6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af9:	8b 45 10             	mov    0x10(%ebp),%eax
  801afc:	01 c2                	add    %eax,%edx
  801afe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	01 c8                	add    %ecx,%eax
  801b06:	8a 00                	mov    (%eax),%al
  801b08:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b0a:	ff 45 fc             	incl   -0x4(%ebp)
  801b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b10:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b13:	7c e1                	jl     801af6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b15:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b1c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b23:	eb 1f                	jmp    801b44 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b28:	8d 50 01             	lea    0x1(%eax),%edx
  801b2b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b2e:	89 c2                	mov    %eax,%edx
  801b30:	8b 45 10             	mov    0x10(%ebp),%eax
  801b33:	01 c2                	add    %eax,%edx
  801b35:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	01 c8                	add    %ecx,%eax
  801b3d:	8a 00                	mov    (%eax),%al
  801b3f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b41:	ff 45 f8             	incl   -0x8(%ebp)
  801b44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4a:	7c d9                	jl     801b25 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b52:	01 d0                	add    %edx,%eax
  801b54:	c6 00 00             	movb   $0x0,(%eax)
}
  801b57:	90                   	nop
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b66:	8b 45 14             	mov    0x14(%ebp),%eax
  801b69:	8b 00                	mov    (%eax),%eax
  801b6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b72:	8b 45 10             	mov    0x10(%ebp),%eax
  801b75:	01 d0                	add    %edx,%eax
  801b77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b7d:	eb 0c                	jmp    801b8b <strsplit+0x31>
			*string++ = 0;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8d 50 01             	lea    0x1(%eax),%edx
  801b85:	89 55 08             	mov    %edx,0x8(%ebp)
  801b88:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	8a 00                	mov    (%eax),%al
  801b90:	84 c0                	test   %al,%al
  801b92:	74 18                	je     801bac <strsplit+0x52>
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	8a 00                	mov    (%eax),%al
  801b99:	0f be c0             	movsbl %al,%eax
  801b9c:	50                   	push   %eax
  801b9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ba0:	e8 83 fa ff ff       	call   801628 <strchr>
  801ba5:	83 c4 08             	add    $0x8,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	75 d3                	jne    801b7f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	8a 00                	mov    (%eax),%al
  801bb1:	84 c0                	test   %al,%al
  801bb3:	74 5a                	je     801c0f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bb5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb8:	8b 00                	mov    (%eax),%eax
  801bba:	83 f8 0f             	cmp    $0xf,%eax
  801bbd:	75 07                	jne    801bc6 <strsplit+0x6c>
		{
			return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc4:	eb 66                	jmp    801c2c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801bc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc9:	8b 00                	mov    (%eax),%eax
  801bcb:	8d 48 01             	lea    0x1(%eax),%ecx
  801bce:	8b 55 14             	mov    0x14(%ebp),%edx
  801bd1:	89 0a                	mov    %ecx,(%edx)
  801bd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bda:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdd:	01 c2                	add    %eax,%edx
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801be4:	eb 03                	jmp    801be9 <strsplit+0x8f>
			string++;
  801be6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	8a 00                	mov    (%eax),%al
  801bee:	84 c0                	test   %al,%al
  801bf0:	74 8b                	je     801b7d <strsplit+0x23>
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	8a 00                	mov    (%eax),%al
  801bf7:	0f be c0             	movsbl %al,%eax
  801bfa:	50                   	push   %eax
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	e8 25 fa ff ff       	call   801628 <strchr>
  801c03:	83 c4 08             	add    $0x8,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	74 dc                	je     801be6 <strsplit+0x8c>
			string++;
	}
  801c0a:	e9 6e ff ff ff       	jmp    801b7d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c0f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c10:	8b 45 14             	mov    0x14(%ebp),%eax
  801c13:	8b 00                	mov    (%eax),%eax
  801c15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1f:	01 d0                	add    %edx,%eax
  801c21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c27:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801c3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c41:	eb 4a                	jmp    801c8d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801c43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	01 c2                	add    %eax,%edx
  801c4b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c51:	01 c8                	add    %ecx,%eax
  801c53:	8a 00                	mov    (%eax),%al
  801c55:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801c57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5d:	01 d0                	add    %edx,%eax
  801c5f:	8a 00                	mov    (%eax),%al
  801c61:	3c 40                	cmp    $0x40,%al
  801c63:	7e 25                	jle    801c8a <str2lower+0x5c>
  801c65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	01 d0                	add    %edx,%eax
  801c6d:	8a 00                	mov    (%eax),%al
  801c6f:	3c 5a                	cmp    $0x5a,%al
  801c71:	7f 17                	jg     801c8a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801c73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  801c81:	01 ca                	add    %ecx,%edx
  801c83:	8a 12                	mov    (%edx),%dl
  801c85:	83 c2 20             	add    $0x20,%edx
  801c88:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801c8a:	ff 45 fc             	incl   -0x4(%ebp)
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	e8 01 f8 ff ff       	call   801496 <strlen>
  801c95:	83 c4 04             	add    $0x4,%esp
  801c98:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c9b:	7f a6                	jg     801c43 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801c9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ca8:	a1 08 60 80 00       	mov    0x806008,%eax
  801cad:	85 c0                	test   %eax,%eax
  801caf:	74 42                	je     801cf3 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	68 00 00 00 82       	push   $0x82000000
  801cb9:	68 00 00 00 80       	push   $0x80000000
  801cbe:	e8 b0 1e 00 00       	call   803b73 <initialize_dynamic_allocator>
  801cc3:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801cc6:	e8 96 1c 00 00       	call   803961 <sys_get_uheap_strategy>
  801ccb:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801cd0:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801cd5:	05 00 10 00 00       	add    $0x1000,%eax
  801cda:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801cdf:	a1 30 61 83 00       	mov    0x836130,%eax
  801ce4:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801ce9:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0a:	83 ec 08             	sub    $0x8,%esp
  801d0d:	68 06 04 00 00       	push   $0x406
  801d12:	50                   	push   %eax
  801d13:	e8 93 18 00 00       	call   8035ab <__sys_allocate_page>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d22:	79 14                	jns    801d38 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	68 fc 4f 80 00       	push   $0x804ffc
  801d2c:	6a 1f                	push   $0x1f
  801d2e:	68 38 50 80 00       	push   $0x805038
  801d33:	e8 af eb ff ff       	call   8008e7 <_panic>
	return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	50                   	push   %eax
  801d57:	e8 96 18 00 00       	call   8035f2 <__sys_unmap_frame>
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801d62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d66:	79 14                	jns    801d7c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801d68:	83 ec 04             	sub    $0x4,%esp
  801d6b:	68 44 50 80 00       	push   $0x805044
  801d70:	6a 2a                	push   $0x2a
  801d72:	68 38 50 80 00       	push   $0x805038
  801d77:	e8 6b eb ff ff       	call   8008e7 <_panic>
}
  801d7c:	90                   	nop
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d85:	e8 18 ff ff ff       	call   801ca2 <uheap_init>
	if (size == 0) return NULL ;
  801d8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d8e:	75 0a                	jne    801d9a <malloc+0x1b>
  801d90:	b8 00 00 00 00       	mov    $0x0,%eax
  801d95:	e9 43 03 00 00       	jmp    8020dd <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801d9a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801da1:	77 13                	ja     801db6 <malloc+0x37>
    {
        return alloc_block(size);
  801da3:	83 ec 0c             	sub    $0xc,%esp
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	e8 78 20 00 00       	call   803e26 <alloc_block>
  801dae:	83 c4 10             	add    $0x10,%esp
  801db1:	e9 27 03 00 00       	jmp    8020dd <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801db6:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dc3:	01 d0                	add    %edx,%eax
  801dc5:	48                   	dec    %eax
  801dc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801dc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd1:	f7 75 dc             	divl   -0x24(%ebp)
  801dd4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dd7:	29 d0                	sub    %edx,%eax
  801dd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801ddc:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801de1:	85 c0                	test   %eax,%eax
  801de3:	75 0a                	jne    801def <malloc+0x70>
    {
        uhp_inited = 1;
  801de5:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801dec:	00 00 00 
    }

    int exactIdx = -1;
  801def:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801df6:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801dfd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e0b:	e9 85 00 00 00       	jmp    801e95 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801e10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e13:	89 d0                	mov    %edx,%eax
  801e15:	01 c0                	add    %eax,%eax
  801e17:	01 d0                	add    %edx,%eax
  801e19:	c1 e0 02             	shl    $0x2,%eax
  801e1c:	05 48 20 81 00       	add    $0x812048,%eax
  801e21:	8a 00                	mov    (%eax),%al
  801e23:	84 c0                	test   %al,%al
  801e25:	74 20                	je     801e47 <malloc+0xc8>
  801e27:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e2a:	89 d0                	mov    %edx,%eax
  801e2c:	01 c0                	add    %eax,%eax
  801e2e:	01 d0                	add    %edx,%eax
  801e30:	c1 e0 02             	shl    $0x2,%eax
  801e33:	05 44 20 81 00       	add    $0x812044,%eax
  801e38:	8b 00                	mov    (%eax),%eax
  801e3a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e3d:	75 08                	jne    801e47 <malloc+0xc8>
        {
            exactIdx = i;
  801e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801e45:	eb 5b                	jmp    801ea2 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801e47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e4a:	89 d0                	mov    %edx,%eax
  801e4c:	01 c0                	add    %eax,%eax
  801e4e:	01 d0                	add    %edx,%eax
  801e50:	c1 e0 02             	shl    $0x2,%eax
  801e53:	05 48 20 81 00       	add    $0x812048,%eax
  801e58:	8a 00                	mov    (%eax),%al
  801e5a:	84 c0                	test   %al,%al
  801e5c:	74 34                	je     801e92 <malloc+0x113>
  801e5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e61:	89 d0                	mov    %edx,%eax
  801e63:	01 c0                	add    %eax,%eax
  801e65:	01 d0                	add    %edx,%eax
  801e67:	c1 e0 02             	shl    $0x2,%eax
  801e6a:	05 44 20 81 00       	add    $0x812044,%eax
  801e6f:	8b 00                	mov    (%eax),%eax
  801e71:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e74:	76 1c                	jbe    801e92 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801e76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e79:	89 d0                	mov    %edx,%eax
  801e7b:	01 c0                	add    %eax,%eax
  801e7d:	01 d0                	add    %edx,%eax
  801e7f:	c1 e0 02             	shl    $0x2,%eax
  801e82:	05 44 20 81 00       	add    $0x812044,%eax
  801e87:	8b 00                	mov    (%eax),%eax
  801e89:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801e8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e92:	ff 45 e8             	incl   -0x18(%ebp)
  801e95:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801e9c:	0f 8e 6e ff ff ff    	jle    801e10 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801ea2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801ea9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801ead:	74 7d                	je     801f2c <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801eaf:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb9:	89 d0                	mov    %edx,%eax
  801ebb:	01 c0                	add    %eax,%eax
  801ebd:	01 d0                	add    %edx,%eax
  801ebf:	c1 e0 02             	shl    $0x2,%eax
  801ec2:	05 40 20 81 00       	add    $0x812040,%eax
  801ec7:	8b 10                	mov    (%eax),%edx
  801ec9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801ecc:	01 d0                	add    %edx,%eax
  801ece:	48                   	dec    %eax
  801ecf:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801ed2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ed5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eda:	f7 75 bc             	divl   -0x44(%ebp)
  801edd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ee0:	29 d0                	sub    %edx,%eax
  801ee2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee8:	89 d0                	mov    %edx,%eax
  801eea:	01 c0                	add    %eax,%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	c1 e0 02             	shl    $0x2,%eax
  801ef1:	05 48 20 81 00       	add    $0x812048,%eax
  801ef6:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efc:	89 d0                	mov    %edx,%eax
  801efe:	01 c0                	add    %eax,%eax
  801f00:	01 d0                	add    %edx,%eax
  801f02:	c1 e0 02             	shl    $0x2,%eax
  801f05:	05 44 20 81 00       	add    $0x812044,%eax
  801f0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f13:	89 d0                	mov    %edx,%eax
  801f15:	01 c0                	add    %eax,%eax
  801f17:	01 d0                	add    %edx,%eax
  801f19:	c1 e0 02             	shl    $0x2,%eax
  801f1c:	05 40 20 81 00       	add    $0x812040,%eax
  801f21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f27:	e9 2d 01 00 00       	jmp    802059 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801f2c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f30:	0f 84 ce 00 00 00    	je     802004 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801f36:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801f3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f40:	89 d0                	mov    %edx,%eax
  801f42:	01 c0                	add    %eax,%eax
  801f44:	01 d0                	add    %edx,%eax
  801f46:	c1 e0 02             	shl    $0x2,%eax
  801f49:	05 40 20 81 00       	add    $0x812040,%eax
  801f4e:	8b 10                	mov    (%eax),%edx
  801f50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f53:	01 d0                	add    %edx,%eax
  801f55:	48                   	dec    %eax
  801f56:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801f59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f61:	f7 75 c4             	divl   -0x3c(%ebp)
  801f64:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f67:	29 d0                	sub    %edx,%eax
  801f69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801f6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f6f:	89 d0                	mov    %edx,%eax
  801f71:	01 c0                	add    %eax,%eax
  801f73:	01 d0                	add    %edx,%eax
  801f75:	c1 e0 02             	shl    $0x2,%eax
  801f78:	05 44 20 81 00       	add    $0x812044,%eax
  801f7d:	8b 00                	mov    (%eax),%eax
  801f7f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f82:	75 47                	jne    801fcb <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801f84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f87:	89 d0                	mov    %edx,%eax
  801f89:	01 c0                	add    %eax,%eax
  801f8b:	01 d0                	add    %edx,%eax
  801f8d:	c1 e0 02             	shl    $0x2,%eax
  801f90:	05 48 20 81 00       	add    $0x812048,%eax
  801f95:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801f98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f9b:	89 d0                	mov    %edx,%eax
  801f9d:	01 c0                	add    %eax,%eax
  801f9f:	01 d0                	add    %edx,%eax
  801fa1:	c1 e0 02             	shl    $0x2,%eax
  801fa4:	05 44 20 81 00       	add    $0x812044,%eax
  801fa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801faf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fb2:	89 d0                	mov    %edx,%eax
  801fb4:	01 c0                	add    %eax,%eax
  801fb6:	01 d0                	add    %edx,%eax
  801fb8:	c1 e0 02             	shl    $0x2,%eax
  801fbb:	05 40 20 81 00       	add    $0x812040,%eax
  801fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fc6:	e9 8e 00 00 00       	jmp    802059 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801fcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fd1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801fd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd7:	89 d0                	mov    %edx,%eax
  801fd9:	01 c0                	add    %eax,%eax
  801fdb:	01 d0                	add    %edx,%eax
  801fdd:	c1 e0 02             	shl    $0x2,%eax
  801fe0:	05 40 20 81 00       	add    $0x812040,%eax
  801fe5:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fea:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801fed:	89 c2                	mov    %eax,%edx
  801fef:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ff2:	89 c8                	mov    %ecx,%eax
  801ff4:	01 c0                	add    %eax,%eax
  801ff6:	01 c8                	add    %ecx,%eax
  801ff8:	c1 e0 02             	shl    $0x2,%eax
  801ffb:	05 44 20 81 00       	add    $0x812044,%eax
  802000:	89 10                	mov    %edx,(%eax)
  802002:	eb 55                	jmp    802059 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802004:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80200b:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802011:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802014:	01 d0                	add    %edx,%eax
  802016:	48                   	dec    %eax
  802017:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80201a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80201d:	ba 00 00 00 00       	mov    $0x0,%edx
  802022:	f7 75 d0             	divl   -0x30(%ebp)
  802025:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802028:	29 d0                	sub    %edx,%eax
  80202a:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80202d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802030:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802033:	01 d0                	add    %edx,%eax
  802035:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80203a:	76 0a                	jbe    802046 <malloc+0x2c7>
            return NULL;
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
  802041:	e9 97 00 00 00       	jmp    8020dd <malloc+0x35e>
        va = start;
  802046:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80204c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80204f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802052:	01 d0                	add    %edx,%eax
  802054:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802059:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802060:	eb 5e                	jmp    8020c0 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  802062:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802065:	89 d0                	mov    %edx,%eax
  802067:	01 c0                	add    %eax,%eax
  802069:	01 d0                	add    %edx,%eax
  80206b:	c1 e0 02             	shl    $0x2,%eax
  80206e:	05 48 60 80 00       	add    $0x806048,%eax
  802073:	8a 00                	mov    (%eax),%al
  802075:	84 c0                	test   %al,%al
  802077:	75 44                	jne    8020bd <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  802079:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80207c:	89 d0                	mov    %edx,%eax
  80207e:	01 c0                	add    %eax,%eax
  802080:	01 d0                	add    %edx,%eax
  802082:	c1 e0 02             	shl    $0x2,%eax
  802085:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80208b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802090:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802093:	89 d0                	mov    %edx,%eax
  802095:	01 c0                	add    %eax,%eax
  802097:	01 d0                	add    %edx,%eax
  802099:	c1 e0 02             	shl    $0x2,%eax
  80209c:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8020a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020a5:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8020a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020aa:	89 d0                	mov    %edx,%eax
  8020ac:	01 c0                	add    %eax,%eax
  8020ae:	01 d0                	add    %edx,%eax
  8020b0:	c1 e0 02             	shl    $0x2,%eax
  8020b3:	05 48 60 80 00       	add    $0x806048,%eax
  8020b8:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8020bb:	eb 0c                	jmp    8020c9 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8020bd:	ff 45 e0             	incl   -0x20(%ebp)
  8020c0:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8020c7:	7e 99                	jle    802062 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8020c9:	83 ec 08             	sub    $0x8,%esp
  8020cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8020cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020d2:	e8 a2 19 00 00       	call   803a79 <sys_allocate_user_mem>
  8020d7:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8020da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8020e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e9:	0f 84 fa 03 00 00    	je     8024e9 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8020f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	79 1c                	jns    802118 <free+0x39>
  8020fc:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  802103:	77 13                	ja     802118 <free+0x39>
    {
        free_block(virtual_address);
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	ff 75 08             	pushl  0x8(%ebp)
  80210b:	e8 09 21 00 00       	call   804219 <free_block>
  802110:	83 c4 10             	add    $0x10,%esp
        return;
  802113:	e9 d2 03 00 00       	jmp    8024ea <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802118:	a1 30 61 83 00       	mov    0x836130,%eax
  80211d:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  802120:	72 09                	jb     80212b <free+0x4c>
  802122:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  802129:	76 17                	jbe    802142 <free+0x63>
        panic("free: invalid address");
  80212b:	83 ec 04             	sub    $0x4,%esp
  80212e:	68 81 50 80 00       	push   $0x805081
  802133:	68 9b 00 00 00       	push   $0x9b
  802138:	68 38 50 80 00       	push   $0x805038
  80213d:	e8 a5 e7 ff ff       	call   8008e7 <_panic>

    uint32 size = 0;
  802142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  802149:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802150:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802157:	eb 50                	jmp    8021a9 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802159:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80215c:	89 d0                	mov    %edx,%eax
  80215e:	01 c0                	add    %eax,%eax
  802160:	01 d0                	add    %edx,%eax
  802162:	c1 e0 02             	shl    $0x2,%eax
  802165:	05 48 60 80 00       	add    $0x806048,%eax
  80216a:	8a 00                	mov    (%eax),%al
  80216c:	84 c0                	test   %al,%al
  80216e:	74 36                	je     8021a6 <free+0xc7>
  802170:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802173:	89 d0                	mov    %edx,%eax
  802175:	01 c0                	add    %eax,%eax
  802177:	01 d0                	add    %edx,%eax
  802179:	c1 e0 02             	shl    $0x2,%eax
  80217c:	05 40 60 80 00       	add    $0x806040,%eax
  802181:	8b 00                	mov    (%eax),%eax
  802183:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802186:	75 1e                	jne    8021a6 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  802188:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80218b:	89 d0                	mov    %edx,%eax
  80218d:	01 c0                	add    %eax,%eax
  80218f:	01 d0                	add    %edx,%eax
  802191:	c1 e0 02             	shl    $0x2,%eax
  802194:	05 44 60 80 00       	add    $0x806044,%eax
  802199:	8b 00                	mov    (%eax),%eax
  80219b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  80219e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  8021a4:	eb 0c                	jmp    8021b2 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8021a6:	ff 45 ec             	incl   -0x14(%ebp)
  8021a9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8021b0:	7e a7                	jle    802159 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  8021b2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021b6:	74 06                	je     8021be <free+0xdf>
  8021b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bc:	75 17                	jne    8021d5 <free+0xf6>
        panic("free: unknown block");
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	68 97 50 80 00       	push   $0x805097
  8021c6:	68 a9 00 00 00       	push   $0xa9
  8021cb:	68 38 50 80 00       	push   $0x805038
  8021d0:	e8 12 e7 ff ff       	call   8008e7 <_panic>

    uhp_allocs[idx].used = 0;
  8021d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021d8:	89 d0                	mov    %edx,%eax
  8021da:	01 c0                	add    %eax,%eax
  8021dc:	01 d0                	add    %edx,%eax
  8021de:	c1 e0 02             	shl    $0x2,%eax
  8021e1:	05 48 60 80 00       	add    $0x806048,%eax
  8021e6:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8021e9:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8021f7:	eb 64                	jmp    80225d <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8021f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021fc:	89 d0                	mov    %edx,%eax
  8021fe:	01 c0                	add    %eax,%eax
  802200:	01 d0                	add    %edx,%eax
  802202:	c1 e0 02             	shl    $0x2,%eax
  802205:	05 48 20 81 00       	add    $0x812048,%eax
  80220a:	8a 00                	mov    (%eax),%al
  80220c:	84 c0                	test   %al,%al
  80220e:	75 4a                	jne    80225a <free+0x17b>
        {
            uhp_frees[i].va = va;
  802210:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802213:	89 d0                	mov    %edx,%eax
  802215:	01 c0                	add    %eax,%eax
  802217:	01 d0                	add    %edx,%eax
  802219:	c1 e0 02             	shl    $0x2,%eax
  80221c:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802222:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802225:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802227:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	01 c0                	add    %eax,%eax
  80222e:	01 d0                	add    %edx,%eax
  802230:	c1 e0 02             	shl    $0x2,%eax
  802233:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  80223e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802241:	89 d0                	mov    %edx,%eax
  802243:	01 c0                	add    %eax,%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	c1 e0 02             	shl    $0x2,%eax
  80224a:	05 48 20 81 00       	add    $0x812048,%eax
  80224f:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802255:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802258:	eb 0c                	jmp    802266 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80225a:	ff 45 e4             	incl   -0x1c(%ebp)
  80225d:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802264:	7e 93                	jle    8021f9 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  802266:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80226a:	0f 84 f1 01 00 00    	je     802461 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802270:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802277:	e9 d8 01 00 00       	jmp    802454 <free+0x375>
        {
            if (i == fidx) continue;
  80227c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80227f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802282:	0f 84 c8 01 00 00    	je     802450 <free+0x371>
            if (uhp_frees[i].free)
  802288:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80228b:	89 d0                	mov    %edx,%eax
  80228d:	01 c0                	add    %eax,%eax
  80228f:	01 d0                	add    %edx,%eax
  802291:	c1 e0 02             	shl    $0x2,%eax
  802294:	05 48 20 81 00       	add    $0x812048,%eax
  802299:	8a 00                	mov    (%eax),%al
  80229b:	84 c0                	test   %al,%al
  80229d:	0f 84 ae 01 00 00    	je     802451 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  8022a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022a6:	89 d0                	mov    %edx,%eax
  8022a8:	01 c0                	add    %eax,%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	c1 e0 02             	shl    $0x2,%eax
  8022af:	05 40 20 81 00       	add    $0x812040,%eax
  8022b4:	8b 08                	mov    (%eax),%ecx
  8022b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022b9:	89 d0                	mov    %edx,%eax
  8022bb:	01 c0                	add    %eax,%eax
  8022bd:	01 d0                	add    %edx,%eax
  8022bf:	c1 e0 02             	shl    $0x2,%eax
  8022c2:	05 44 20 81 00       	add    $0x812044,%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	01 c1                	add    %eax,%ecx
  8022cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022ce:	89 d0                	mov    %edx,%eax
  8022d0:	01 c0                	add    %eax,%eax
  8022d2:	01 d0                	add    %edx,%eax
  8022d4:	c1 e0 02             	shl    $0x2,%eax
  8022d7:	05 40 20 81 00       	add    $0x812040,%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	39 c1                	cmp    %eax,%ecx
  8022e0:	0f 85 a8 00 00 00    	jne    80238e <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  8022e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022e9:	89 d0                	mov    %edx,%eax
  8022eb:	01 c0                	add    %eax,%eax
  8022ed:	01 d0                	add    %edx,%eax
  8022ef:	c1 e0 02             	shl    $0x2,%eax
  8022f2:	05 40 20 81 00       	add    $0x812040,%eax
  8022f7:	8b 10                	mov    (%eax),%edx
  8022f9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8022fc:	89 c8                	mov    %ecx,%eax
  8022fe:	01 c0                	add    %eax,%eax
  802300:	01 c8                	add    %ecx,%eax
  802302:	c1 e0 02             	shl    $0x2,%eax
  802305:	05 40 20 81 00       	add    $0x812040,%eax
  80230a:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80230c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80230f:	89 d0                	mov    %edx,%eax
  802311:	01 c0                	add    %eax,%eax
  802313:	01 d0                	add    %edx,%eax
  802315:	c1 e0 02             	shl    $0x2,%eax
  802318:	05 44 20 81 00       	add    $0x812044,%eax
  80231d:	8b 08                	mov    (%eax),%ecx
  80231f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802322:	89 d0                	mov    %edx,%eax
  802324:	01 c0                	add    %eax,%eax
  802326:	01 d0                	add    %edx,%eax
  802328:	c1 e0 02             	shl    $0x2,%eax
  80232b:	05 44 20 81 00       	add    $0x812044,%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	01 c1                	add    %eax,%ecx
  802334:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802337:	89 d0                	mov    %edx,%eax
  802339:	01 c0                	add    %eax,%eax
  80233b:	01 d0                	add    %edx,%eax
  80233d:	c1 e0 02             	shl    $0x2,%eax
  802340:	05 44 20 81 00       	add    $0x812044,%eax
  802345:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802347:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80234a:	89 d0                	mov    %edx,%eax
  80234c:	01 c0                	add    %eax,%eax
  80234e:	01 d0                	add    %edx,%eax
  802350:	c1 e0 02             	shl    $0x2,%eax
  802353:	05 48 20 81 00       	add    $0x812048,%eax
  802358:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80235b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80235e:	89 d0                	mov    %edx,%eax
  802360:	01 c0                	add    %eax,%eax
  802362:	01 d0                	add    %edx,%eax
  802364:	c1 e0 02             	shl    $0x2,%eax
  802367:	05 40 20 81 00       	add    $0x812040,%eax
  80236c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802372:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802375:	89 d0                	mov    %edx,%eax
  802377:	01 c0                	add    %eax,%eax
  802379:	01 d0                	add    %edx,%eax
  80237b:	c1 e0 02             	shl    $0x2,%eax
  80237e:	05 44 20 81 00       	add    $0x812044,%eax
  802383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802389:	e9 c3 00 00 00       	jmp    802451 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  80238e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802391:	89 d0                	mov    %edx,%eax
  802393:	01 c0                	add    %eax,%eax
  802395:	01 d0                	add    %edx,%eax
  802397:	c1 e0 02             	shl    $0x2,%eax
  80239a:	05 40 20 81 00       	add    $0x812040,%eax
  80239f:	8b 08                	mov    (%eax),%ecx
  8023a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023a4:	89 d0                	mov    %edx,%eax
  8023a6:	01 c0                	add    %eax,%eax
  8023a8:	01 d0                	add    %edx,%eax
  8023aa:	c1 e0 02             	shl    $0x2,%eax
  8023ad:	05 44 20 81 00       	add    $0x812044,%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	01 c1                	add    %eax,%ecx
  8023b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023b9:	89 d0                	mov    %edx,%eax
  8023bb:	01 c0                	add    %eax,%eax
  8023bd:	01 d0                	add    %edx,%eax
  8023bf:	c1 e0 02             	shl    $0x2,%eax
  8023c2:	05 40 20 81 00       	add    $0x812040,%eax
  8023c7:	8b 00                	mov    (%eax),%eax
  8023c9:	39 c1                	cmp    %eax,%ecx
  8023cb:	0f 85 80 00 00 00    	jne    802451 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8023d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023d4:	89 d0                	mov    %edx,%eax
  8023d6:	01 c0                	add    %eax,%eax
  8023d8:	01 d0                	add    %edx,%eax
  8023da:	c1 e0 02             	shl    $0x2,%eax
  8023dd:	05 44 20 81 00       	add    $0x812044,%eax
  8023e2:	8b 08                	mov    (%eax),%ecx
  8023e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023e7:	89 d0                	mov    %edx,%eax
  8023e9:	01 c0                	add    %eax,%eax
  8023eb:	01 d0                	add    %edx,%eax
  8023ed:	c1 e0 02             	shl    $0x2,%eax
  8023f0:	05 44 20 81 00       	add    $0x812044,%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	01 c1                	add    %eax,%ecx
  8023f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023fc:	89 d0                	mov    %edx,%eax
  8023fe:	01 c0                	add    %eax,%eax
  802400:	01 d0                	add    %edx,%eax
  802402:	c1 e0 02             	shl    $0x2,%eax
  802405:	05 44 20 81 00       	add    $0x812044,%eax
  80240a:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  80240c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80240f:	89 d0                	mov    %edx,%eax
  802411:	01 c0                	add    %eax,%eax
  802413:	01 d0                	add    %edx,%eax
  802415:	c1 e0 02             	shl    $0x2,%eax
  802418:	05 48 20 81 00       	add    $0x812048,%eax
  80241d:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802420:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802423:	89 d0                	mov    %edx,%eax
  802425:	01 c0                	add    %eax,%eax
  802427:	01 d0                	add    %edx,%eax
  802429:	c1 e0 02             	shl    $0x2,%eax
  80242c:	05 40 20 81 00       	add    $0x812040,%eax
  802431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802437:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80243a:	89 d0                	mov    %edx,%eax
  80243c:	01 c0                	add    %eax,%eax
  80243e:	01 d0                	add    %edx,%eax
  802440:	c1 e0 02             	shl    $0x2,%eax
  802443:	05 44 20 81 00       	add    $0x812044,%eax
  802448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244e:	eb 01                	jmp    802451 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  802450:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802451:	ff 45 e0             	incl   -0x20(%ebp)
  802454:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80245b:	0f 8e 1b fe ff ff    	jle    80227c <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802461:	a1 30 61 83 00       	mov    0x836130,%eax
  802466:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802469:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802470:	eb 53                	jmp    8024c5 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802472:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802475:	89 d0                	mov    %edx,%eax
  802477:	01 c0                	add    %eax,%eax
  802479:	01 d0                	add    %edx,%eax
  80247b:	c1 e0 02             	shl    $0x2,%eax
  80247e:	05 48 60 80 00       	add    $0x806048,%eax
  802483:	8a 00                	mov    (%eax),%al
  802485:	84 c0                	test   %al,%al
  802487:	74 39                	je     8024c2 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802489:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80248c:	89 d0                	mov    %edx,%eax
  80248e:	01 c0                	add    %eax,%eax
  802490:	01 d0                	add    %edx,%eax
  802492:	c1 e0 02             	shl    $0x2,%eax
  802495:	05 40 60 80 00       	add    $0x806040,%eax
  80249a:	8b 08                	mov    (%eax),%ecx
  80249c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80249f:	89 d0                	mov    %edx,%eax
  8024a1:	01 c0                	add    %eax,%eax
  8024a3:	01 d0                	add    %edx,%eax
  8024a5:	c1 e0 02             	shl    $0x2,%eax
  8024a8:	05 44 60 80 00       	add    $0x806044,%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	01 c8                	add    %ecx,%eax
  8024b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  8024b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8024ba:	76 06                	jbe    8024c2 <free+0x3e3>
  8024bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024c2:	ff 45 d8             	incl   -0x28(%ebp)
  8024c5:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8024cc:	7e a4                	jle    802472 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  8024ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024d1:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  8024d6:	83 ec 08             	sub    $0x8,%esp
  8024d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024dc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8024df:	e8 79 15 00 00       	call   803a5d <sys_free_user_mem>
  8024e4:	83 c4 10             	add    $0x10,%esp
  8024e7:	eb 01                	jmp    8024ea <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  8024e9:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 68             	sub    $0x68,%esp
  8024f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f5:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024f8:	e8 a5 f7 ff ff       	call   801ca2 <uheap_init>
	if (size == 0) return NULL ;
  8024fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802501:	75 0a                	jne    80250d <smalloc+0x21>
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
  802508:	e9 37 03 00 00       	jmp    802844 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80250d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802514:	8b 55 0c             	mov    0xc(%ebp),%edx
  802517:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80251a:	01 d0                	add    %edx,%eax
  80251c:	48                   	dec    %eax
  80251d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802520:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802523:	ba 00 00 00 00       	mov    $0x0,%edx
  802528:	f7 75 dc             	divl   -0x24(%ebp)
  80252b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80252e:	29 d0                	sub    %edx,%eax
  802530:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802533:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80253a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802541:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802548:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80254f:	e9 85 00 00 00       	jmp    8025d9 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802554:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802557:	89 d0                	mov    %edx,%eax
  802559:	01 c0                	add    %eax,%eax
  80255b:	01 d0                	add    %edx,%eax
  80255d:	c1 e0 02             	shl    $0x2,%eax
  802560:	05 48 20 81 00       	add    $0x812048,%eax
  802565:	8a 00                	mov    (%eax),%al
  802567:	84 c0                	test   %al,%al
  802569:	74 20                	je     80258b <smalloc+0x9f>
  80256b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80256e:	89 d0                	mov    %edx,%eax
  802570:	01 c0                	add    %eax,%eax
  802572:	01 d0                	add    %edx,%eax
  802574:	c1 e0 02             	shl    $0x2,%eax
  802577:	05 44 20 81 00       	add    $0x812044,%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802581:	75 08                	jne    80258b <smalloc+0x9f>
        {
            exactIdx = i;
  802583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802586:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802589:	eb 5b                	jmp    8025e6 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80258b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80258e:	89 d0                	mov    %edx,%eax
  802590:	01 c0                	add    %eax,%eax
  802592:	01 d0                	add    %edx,%eax
  802594:	c1 e0 02             	shl    $0x2,%eax
  802597:	05 48 20 81 00       	add    $0x812048,%eax
  80259c:	8a 00                	mov    (%eax),%al
  80259e:	84 c0                	test   %al,%al
  8025a0:	74 34                	je     8025d6 <smalloc+0xea>
  8025a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025a5:	89 d0                	mov    %edx,%eax
  8025a7:	01 c0                	add    %eax,%eax
  8025a9:	01 d0                	add    %edx,%eax
  8025ab:	c1 e0 02             	shl    $0x2,%eax
  8025ae:	05 44 20 81 00       	add    $0x812044,%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025b8:	76 1c                	jbe    8025d6 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8025ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025bd:	89 d0                	mov    %edx,%eax
  8025bf:	01 c0                	add    %eax,%eax
  8025c1:	01 d0                	add    %edx,%eax
  8025c3:	c1 e0 02             	shl    $0x2,%eax
  8025c6:	05 44 20 81 00       	add    $0x812044,%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8025d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025d3:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8025d6:	ff 45 e8             	incl   -0x18(%ebp)
  8025d9:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8025e0:	0f 8e 6e ff ff ff    	jle    802554 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8025e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8025ed:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8025f1:	74 7d                	je     802670 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8025f3:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8025fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fd:	89 d0                	mov    %edx,%eax
  8025ff:	01 c0                	add    %eax,%eax
  802601:	01 d0                	add    %edx,%eax
  802603:	c1 e0 02             	shl    $0x2,%eax
  802606:	05 40 20 81 00       	add    $0x812040,%eax
  80260b:	8b 10                	mov    (%eax),%edx
  80260d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802610:	01 d0                	add    %edx,%eax
  802612:	48                   	dec    %eax
  802613:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802616:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802619:	ba 00 00 00 00       	mov    $0x0,%edx
  80261e:	f7 75 bc             	divl   -0x44(%ebp)
  802621:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802624:	29 d0                	sub    %edx,%eax
  802626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262c:	89 d0                	mov    %edx,%eax
  80262e:	01 c0                	add    %eax,%eax
  802630:	01 d0                	add    %edx,%eax
  802632:	c1 e0 02             	shl    $0x2,%eax
  802635:	05 48 20 81 00       	add    $0x812048,%eax
  80263a:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80263d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802640:	89 d0                	mov    %edx,%eax
  802642:	01 c0                	add    %eax,%eax
  802644:	01 d0                	add    %edx,%eax
  802646:	c1 e0 02             	shl    $0x2,%eax
  802649:	05 44 20 81 00       	add    $0x812044,%eax
  80264e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802657:	89 d0                	mov    %edx,%eax
  802659:	01 c0                	add    %eax,%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	c1 e0 02             	shl    $0x2,%eax
  802660:	05 40 20 81 00       	add    $0x812040,%eax
  802665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266b:	e9 2d 01 00 00       	jmp    80279d <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802670:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802674:	0f 84 ce 00 00 00    	je     802748 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80267a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802681:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802684:	89 d0                	mov    %edx,%eax
  802686:	01 c0                	add    %eax,%eax
  802688:	01 d0                	add    %edx,%eax
  80268a:	c1 e0 02             	shl    $0x2,%eax
  80268d:	05 40 20 81 00       	add    $0x812040,%eax
  802692:	8b 10                	mov    (%eax),%edx
  802694:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802697:	01 d0                	add    %edx,%eax
  802699:	48                   	dec    %eax
  80269a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80269d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a5:	f7 75 c4             	divl   -0x3c(%ebp)
  8026a8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026ab:	29 d0                	sub    %edx,%eax
  8026ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8026b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b3:	89 d0                	mov    %edx,%eax
  8026b5:	01 c0                	add    %eax,%eax
  8026b7:	01 d0                	add    %edx,%eax
  8026b9:	c1 e0 02             	shl    $0x2,%eax
  8026bc:	05 44 20 81 00       	add    $0x812044,%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8026c6:	75 47                	jne    80270f <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  8026c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026cb:	89 d0                	mov    %edx,%eax
  8026cd:	01 c0                	add    %eax,%eax
  8026cf:	01 d0                	add    %edx,%eax
  8026d1:	c1 e0 02             	shl    $0x2,%eax
  8026d4:	05 48 20 81 00       	add    $0x812048,%eax
  8026d9:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8026dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026df:	89 d0                	mov    %edx,%eax
  8026e1:	01 c0                	add    %eax,%eax
  8026e3:	01 d0                	add    %edx,%eax
  8026e5:	c1 e0 02             	shl    $0x2,%eax
  8026e8:	05 44 20 81 00       	add    $0x812044,%eax
  8026ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8026f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f6:	89 d0                	mov    %edx,%eax
  8026f8:	01 c0                	add    %eax,%eax
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	c1 e0 02             	shl    $0x2,%eax
  8026ff:	05 40 20 81 00       	add    $0x812040,%eax
  802704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270a:	e9 8e 00 00 00       	jmp    80279d <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80270f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802712:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802715:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271b:	89 d0                	mov    %edx,%eax
  80271d:	01 c0                	add    %eax,%eax
  80271f:	01 d0                	add    %edx,%eax
  802721:	c1 e0 02             	shl    $0x2,%eax
  802724:	05 40 20 81 00       	add    $0x812040,%eax
  802729:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80272b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802731:	89 c2                	mov    %eax,%edx
  802733:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802736:	89 c8                	mov    %ecx,%eax
  802738:	01 c0                	add    %eax,%eax
  80273a:	01 c8                	add    %ecx,%eax
  80273c:	c1 e0 02             	shl    $0x2,%eax
  80273f:	05 44 20 81 00       	add    $0x812044,%eax
  802744:	89 10                	mov    %edx,(%eax)
  802746:	eb 55                	jmp    80279d <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802748:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80274f:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802755:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802758:	01 d0                	add    %edx,%eax
  80275a:	48                   	dec    %eax
  80275b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80275e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802761:	ba 00 00 00 00       	mov    $0x0,%edx
  802766:	f7 75 d0             	divl   -0x30(%ebp)
  802769:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80276c:	29 d0                	sub    %edx,%eax
  80276e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802771:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802777:	01 d0                	add    %edx,%eax
  802779:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80277e:	76 0a                	jbe    80278a <smalloc+0x29e>
            return NULL;
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
  802785:	e9 ba 00 00 00       	jmp    802844 <smalloc+0x358>
        va = start;
  80278a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80278d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802790:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802793:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802796:	01 d0                	add    %edx,%eax
  802798:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80279d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027a4:	eb 5e                	jmp    802804 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8027a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027a9:	89 d0                	mov    %edx,%eax
  8027ab:	01 c0                	add    %eax,%eax
  8027ad:	01 d0                	add    %edx,%eax
  8027af:	c1 e0 02             	shl    $0x2,%eax
  8027b2:	05 48 60 80 00       	add    $0x806048,%eax
  8027b7:	8a 00                	mov    (%eax),%al
  8027b9:	84 c0                	test   %al,%al
  8027bb:	75 44                	jne    802801 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8027bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c0:	89 d0                	mov    %edx,%eax
  8027c2:	01 c0                	add    %eax,%eax
  8027c4:	01 d0                	add    %edx,%eax
  8027c6:	c1 e0 02             	shl    $0x2,%eax
  8027c9:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  8027cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d2:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8027d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027d7:	89 d0                	mov    %edx,%eax
  8027d9:	01 c0                	add    %eax,%eax
  8027db:	01 d0                	add    %edx,%eax
  8027dd:	c1 e0 02             	shl    $0x2,%eax
  8027e0:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8027e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027e9:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8027eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ee:	89 d0                	mov    %edx,%eax
  8027f0:	01 c0                	add    %eax,%eax
  8027f2:	01 d0                	add    %edx,%eax
  8027f4:	c1 e0 02             	shl    $0x2,%eax
  8027f7:	05 48 60 80 00       	add    $0x806048,%eax
  8027fc:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8027ff:	eb 0c                	jmp    80280d <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802801:	ff 45 e0             	incl   -0x20(%ebp)
  802804:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80280b:	7e 99                	jle    8027a6 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80280d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802810:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802814:	52                   	push   %edx
  802815:	50                   	push   %eax
  802816:	ff 75 d4             	pushl  -0x2c(%ebp)
  802819:	ff 75 08             	pushl  0x8(%ebp)
  80281c:	e8 de 0e 00 00       	call   8036ff <sys_create_shared_object>
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802827:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80282b:	75 07                	jne    802834 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80282d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802832:	eb 10                	jmp    802844 <smalloc+0x358>
    if (r < 0)
  802834:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802838:	79 07                	jns    802841 <smalloc+0x355>
        return NULL;
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	eb 03                	jmp    802844 <smalloc+0x358>
    return (void*)va;
  802841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80284c:	e8 51 f4 ff ff       	call   801ca2 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802851:	83 ec 08             	sub    $0x8,%esp
  802854:	ff 75 0c             	pushl  0xc(%ebp)
  802857:	ff 75 08             	pushl  0x8(%ebp)
  80285a:	e8 ca 0e 00 00       	call   803729 <sys_size_of_shared_object>
  80285f:	83 c4 10             	add    $0x10,%esp
  802862:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802865:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802869:	7f 0a                	jg     802875 <sget+0x2f>
        return NULL;
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	e9 28 03 00 00       	jmp    802b9d <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802875:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80287c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80287f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802882:	01 d0                	add    %edx,%eax
  802884:	48                   	dec    %eax
  802885:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80288b:	ba 00 00 00 00       	mov    $0x0,%edx
  802890:	f7 75 d8             	divl   -0x28(%ebp)
  802893:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802896:	29 d0                	sub    %edx,%eax
  802898:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80289b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8028a2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8028a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8028b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8028b7:	e9 85 00 00 00       	jmp    802941 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8028bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028bf:	89 d0                	mov    %edx,%eax
  8028c1:	01 c0                	add    %eax,%eax
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	c1 e0 02             	shl    $0x2,%eax
  8028c8:	05 48 20 81 00       	add    $0x812048,%eax
  8028cd:	8a 00                	mov    (%eax),%al
  8028cf:	84 c0                	test   %al,%al
  8028d1:	74 20                	je     8028f3 <sget+0xad>
  8028d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d6:	89 d0                	mov    %edx,%eax
  8028d8:	01 c0                	add    %eax,%eax
  8028da:	01 d0                	add    %edx,%eax
  8028dc:	c1 e0 02             	shl    $0x2,%eax
  8028df:	05 44 20 81 00       	add    $0x812044,%eax
  8028e4:	8b 00                	mov    (%eax),%eax
  8028e6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8028e9:	75 08                	jne    8028f3 <sget+0xad>
        {
            exactIdx = i;
  8028eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8028f1:	eb 5b                	jmp    80294e <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8028f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028f6:	89 d0                	mov    %edx,%eax
  8028f8:	01 c0                	add    %eax,%eax
  8028fa:	01 d0                	add    %edx,%eax
  8028fc:	c1 e0 02             	shl    $0x2,%eax
  8028ff:	05 48 20 81 00       	add    $0x812048,%eax
  802904:	8a 00                	mov    (%eax),%al
  802906:	84 c0                	test   %al,%al
  802908:	74 34                	je     80293e <sget+0xf8>
  80290a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290d:	89 d0                	mov    %edx,%eax
  80290f:	01 c0                	add    %eax,%eax
  802911:	01 d0                	add    %edx,%eax
  802913:	c1 e0 02             	shl    $0x2,%eax
  802916:	05 44 20 81 00       	add    $0x812044,%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802920:	76 1c                	jbe    80293e <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802922:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802925:	89 d0                	mov    %edx,%eax
  802927:	01 c0                	add    %eax,%eax
  802929:	01 d0                	add    %edx,%eax
  80292b:	c1 e0 02             	shl    $0x2,%eax
  80292e:	05 44 20 81 00       	add    $0x812044,%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80293e:	ff 45 e8             	incl   -0x18(%ebp)
  802941:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802948:	0f 8e 6e ff ff ff    	jle    8028bc <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80294e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802955:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802959:	74 7d                	je     8029d8 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80295b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802965:	89 d0                	mov    %edx,%eax
  802967:	01 c0                	add    %eax,%eax
  802969:	01 d0                	add    %edx,%eax
  80296b:	c1 e0 02             	shl    $0x2,%eax
  80296e:	05 40 20 81 00       	add    $0x812040,%eax
  802973:	8b 10                	mov    (%eax),%edx
  802975:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802978:	01 d0                	add    %edx,%eax
  80297a:	48                   	dec    %eax
  80297b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80297e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802981:	ba 00 00 00 00       	mov    $0x0,%edx
  802986:	f7 75 b8             	divl   -0x48(%ebp)
  802989:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80298c:	29 d0                	sub    %edx,%eax
  80298e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802994:	89 d0                	mov    %edx,%eax
  802996:	01 c0                	add    %eax,%eax
  802998:	01 d0                	add    %edx,%eax
  80299a:	c1 e0 02             	shl    $0x2,%eax
  80299d:	05 48 20 81 00       	add    $0x812048,%eax
  8029a2:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a8:	89 d0                	mov    %edx,%eax
  8029aa:	01 c0                	add    %eax,%eax
  8029ac:	01 d0                	add    %edx,%eax
  8029ae:	c1 e0 02             	shl    $0x2,%eax
  8029b1:	05 44 20 81 00       	add    $0x812044,%eax
  8029b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8029bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bf:	89 d0                	mov    %edx,%eax
  8029c1:	01 c0                	add    %eax,%eax
  8029c3:	01 d0                	add    %edx,%eax
  8029c5:	c1 e0 02             	shl    $0x2,%eax
  8029c8:	05 40 20 81 00       	add    $0x812040,%eax
  8029cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d3:	e9 2d 01 00 00       	jmp    802b05 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8029d8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8029dc:	0f 84 ce 00 00 00    	je     802ab0 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8029e2:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8029e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	01 c0                	add    %eax,%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	c1 e0 02             	shl    $0x2,%eax
  8029f5:	05 40 20 81 00       	add    $0x812040,%eax
  8029fa:	8b 10                	mov    (%eax),%edx
  8029fc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029ff:	01 d0                	add    %edx,%eax
  802a01:	48                   	dec    %eax
  802a02:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802a05:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a08:	ba 00 00 00 00       	mov    $0x0,%edx
  802a0d:	f7 75 c0             	divl   -0x40(%ebp)
  802a10:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a13:	29 d0                	sub    %edx,%eax
  802a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1b:	89 d0                	mov    %edx,%eax
  802a1d:	01 c0                	add    %eax,%eax
  802a1f:	01 d0                	add    %edx,%eax
  802a21:	c1 e0 02             	shl    $0x2,%eax
  802a24:	05 44 20 81 00       	add    $0x812044,%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a2e:	75 47                	jne    802a77 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802a30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a33:	89 d0                	mov    %edx,%eax
  802a35:	01 c0                	add    %eax,%eax
  802a37:	01 d0                	add    %edx,%eax
  802a39:	c1 e0 02             	shl    $0x2,%eax
  802a3c:	05 48 20 81 00       	add    $0x812048,%eax
  802a41:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802a44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a47:	89 d0                	mov    %edx,%eax
  802a49:	01 c0                	add    %eax,%eax
  802a4b:	01 d0                	add    %edx,%eax
  802a4d:	c1 e0 02             	shl    $0x2,%eax
  802a50:	05 44 20 81 00       	add    $0x812044,%eax
  802a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5e:	89 d0                	mov    %edx,%eax
  802a60:	01 c0                	add    %eax,%eax
  802a62:	01 d0                	add    %edx,%eax
  802a64:	c1 e0 02             	shl    $0x2,%eax
  802a67:	05 40 20 81 00       	add    $0x812040,%eax
  802a6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a72:	e9 8e 00 00 00       	jmp    802b05 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802a77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a7d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a83:	89 d0                	mov    %edx,%eax
  802a85:	01 c0                	add    %eax,%eax
  802a87:	01 d0                	add    %edx,%eax
  802a89:	c1 e0 02             	shl    $0x2,%eax
  802a8c:	05 40 20 81 00       	add    $0x812040,%eax
  802a91:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a96:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802a99:	89 c2                	mov    %eax,%edx
  802a9b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a9e:	89 c8                	mov    %ecx,%eax
  802aa0:	01 c0                	add    %eax,%eax
  802aa2:	01 c8                	add    %ecx,%eax
  802aa4:	c1 e0 02             	shl    $0x2,%eax
  802aa7:	05 44 20 81 00       	add    $0x812044,%eax
  802aac:	89 10                	mov    %edx,(%eax)
  802aae:	eb 55                	jmp    802b05 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802ab0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ab7:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802abd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac0:	01 d0                	add    %edx,%eax
  802ac2:	48                   	dec    %eax
  802ac3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ac6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  802ace:	f7 75 cc             	divl   -0x34(%ebp)
  802ad1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ad4:	29 d0                	sub    %edx,%eax
  802ad6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802ad9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802adc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802adf:	01 d0                	add    %edx,%eax
  802ae1:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802ae6:	76 0a                	jbe    802af2 <sget+0x2ac>
            return NULL;
  802ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  802aed:	e9 ab 00 00 00       	jmp    802b9d <sget+0x357>
        va = start;
  802af2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802af5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802af8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802afb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802afe:	01 d0                	add    %edx,%eax
  802b00:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802b0c:	eb 5e                	jmp    802b6c <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802b0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b11:	89 d0                	mov    %edx,%eax
  802b13:	01 c0                	add    %eax,%eax
  802b15:	01 d0                	add    %edx,%eax
  802b17:	c1 e0 02             	shl    $0x2,%eax
  802b1a:	05 48 60 80 00       	add    $0x806048,%eax
  802b1f:	8a 00                	mov    (%eax),%al
  802b21:	84 c0                	test   %al,%al
  802b23:	75 44                	jne    802b69 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802b25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b28:	89 d0                	mov    %edx,%eax
  802b2a:	01 c0                	add    %eax,%eax
  802b2c:	01 d0                	add    %edx,%eax
  802b2e:	c1 e0 02             	shl    $0x2,%eax
  802b31:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802b3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b3f:	89 d0                	mov    %edx,%eax
  802b41:	01 c0                	add    %eax,%eax
  802b43:	01 d0                	add    %edx,%eax
  802b45:	c1 e0 02             	shl    $0x2,%eax
  802b48:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802b4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b51:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802b53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b56:	89 d0                	mov    %edx,%eax
  802b58:	01 c0                	add    %eax,%eax
  802b5a:	01 d0                	add    %edx,%eax
  802b5c:	c1 e0 02             	shl    $0x2,%eax
  802b5f:	05 48 60 80 00       	add    $0x806048,%eax
  802b64:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802b67:	eb 0c                	jmp    802b75 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b69:	ff 45 e0             	incl   -0x20(%ebp)
  802b6c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802b73:	7e 99                	jle    802b0e <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b78:	83 ec 04             	sub    $0x4,%esp
  802b7b:	50                   	push   %eax
  802b7c:	ff 75 0c             	pushl  0xc(%ebp)
  802b7f:	ff 75 08             	pushl  0x8(%ebp)
  802b82:	e8 bf 0b 00 00       	call   803746 <sys_get_shared_object>
  802b87:	83 c4 10             	add    $0x10,%esp
  802b8a:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802b8d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b91:	79 07                	jns    802b9a <sget+0x354>
        return NULL;
  802b93:	b8 00 00 00 00       	mov    $0x0,%eax
  802b98:	eb 03                	jmp    802b9d <sget+0x357>
    return (void*)va;
  802b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802b9d:	c9                   	leave  
  802b9e:	c3                   	ret    

00802b9f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802b9f:	55                   	push   %ebp
  802ba0:	89 e5                	mov    %esp,%ebp
  802ba2:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802ba5:	e8 f8 f0 ff ff       	call   801ca2 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802baa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bae:	75 13                	jne    802bc3 <realloc+0x24>
		return malloc(new_size);
  802bb0:	83 ec 0c             	sub    $0xc,%esp
  802bb3:	ff 75 0c             	pushl  0xc(%ebp)
  802bb6:	e8 c4 f1 ff ff       	call   801d7f <malloc>
  802bbb:	83 c4 10             	add    $0x10,%esp
  802bbe:	e9 f4 05 00 00       	jmp    8031b7 <realloc+0x618>
	if (new_size == 0)
  802bc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bc7:	75 18                	jne    802be1 <realloc+0x42>
	{
		free(virtual_address);
  802bc9:	83 ec 0c             	sub    $0xc,%esp
  802bcc:	ff 75 08             	pushl  0x8(%ebp)
  802bcf:	e8 0b f5 ff ff       	call   8020df <free>
  802bd4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdc:	e9 d6 05 00 00       	jmp    8031b7 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802be7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	79 74                	jns    802c62 <realloc+0xc3>
  802bee:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802bf5:	77 6b                	ja     802c62 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802bf7:	83 ec 0c             	sub    $0xc,%esp
  802bfa:	ff 75 0c             	pushl  0xc(%ebp)
  802bfd:	e8 7d f1 ff ff       	call   801d7f <malloc>
  802c02:	83 c4 10             	add    $0x10,%esp
  802c05:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802c08:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802c0c:	75 0a                	jne    802c18 <realloc+0x79>
			return NULL;
  802c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c13:	e9 9f 05 00 00       	jmp    8031b7 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802c18:	83 ec 0c             	sub    $0xc,%esp
  802c1b:	ff 75 08             	pushl  0x8(%ebp)
  802c1e:	e8 e0 11 00 00       	call   803e03 <get_block_size>
  802c23:	83 c4 10             	add    $0x10,%esp
  802c26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802c29:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2f:	39 d0                	cmp    %edx,%eax
  802c31:	76 02                	jbe    802c35 <realloc+0x96>
  802c33:	89 d0                	mov    %edx,%eax
  802c35:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	ff 75 c0             	pushl  -0x40(%ebp)
  802c3e:	ff 75 08             	pushl  0x8(%ebp)
  802c41:	ff 75 c8             	pushl  -0x38(%ebp)
  802c44:	e8 56 eb ff ff       	call   80179f <memmove>
  802c49:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802c4c:	83 ec 0c             	sub    $0xc,%esp
  802c4f:	ff 75 08             	pushl  0x8(%ebp)
  802c52:	e8 88 f4 ff ff       	call   8020df <free>
  802c57:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802c5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c5d:	e9 55 05 00 00       	jmp    8031b7 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802c62:	a1 30 61 83 00       	mov    0x836130,%eax
  802c67:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802c6a:	72 09                	jb     802c75 <realloc+0xd6>
  802c6c:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802c73:	76 0a                	jbe    802c7f <realloc+0xe0>
		return NULL;
  802c75:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7a:	e9 38 05 00 00       	jmp    8031b7 <realloc+0x618>
	uint32 oldsz = 0;
  802c7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802c86:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c94:	eb 50                	jmp    802ce6 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802c96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c99:	89 d0                	mov    %edx,%eax
  802c9b:	01 c0                	add    %eax,%eax
  802c9d:	01 d0                	add    %edx,%eax
  802c9f:	c1 e0 02             	shl    $0x2,%eax
  802ca2:	05 48 60 80 00       	add    $0x806048,%eax
  802ca7:	8a 00                	mov    (%eax),%al
  802ca9:	84 c0                	test   %al,%al
  802cab:	74 36                	je     802ce3 <realloc+0x144>
  802cad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb0:	89 d0                	mov    %edx,%eax
  802cb2:	01 c0                	add    %eax,%eax
  802cb4:	01 d0                	add    %edx,%eax
  802cb6:	c1 e0 02             	shl    $0x2,%eax
  802cb9:	05 40 60 80 00       	add    $0x806040,%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802cc3:	75 1e                	jne    802ce3 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802cc5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc8:	89 d0                	mov    %edx,%eax
  802cca:	01 c0                	add    %eax,%eax
  802ccc:	01 d0                	add    %edx,%eax
  802cce:	c1 e0 02             	shl    $0x2,%eax
  802cd1:	05 44 60 80 00       	add    $0x806044,%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802ce1:	eb 0c                	jmp    802cef <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802ce3:	ff 45 ec             	incl   -0x14(%ebp)
  802ce6:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ced:	7e a7                	jle    802c96 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802cef:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802cf3:	75 0a                	jne    802cff <realloc+0x160>
		return NULL;
  802cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfa:	e9 b8 04 00 00       	jmp    8031b7 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802cff:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d09:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d0c:	01 d0                	add    %edx,%eax
  802d0e:	48                   	dec    %eax
  802d0f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802d12:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d15:	ba 00 00 00 00       	mov    $0x0,%edx
  802d1a:	f7 75 bc             	divl   -0x44(%ebp)
  802d1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d20:	29 d0                	sub    %edx,%eax
  802d22:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802d25:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d28:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d2b:	75 08                	jne    802d35 <realloc+0x196>
		return virtual_address;
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	e9 82 04 00 00       	jmp    8031b7 <realloc+0x618>
	if (req < oldsz)
  802d35:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d38:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d3b:	0f 83 cd 02 00 00    	jae    80300e <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802d47:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802d4a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d4d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802d55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d58:	89 d0                	mov    %edx,%eax
  802d5a:	01 c0                	add    %eax,%eax
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	c1 e0 02             	shl    $0x2,%eax
  802d61:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802d67:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d6a:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802d6c:	83 ec 08             	sub    $0x8,%esp
  802d6f:	ff 75 b0             	pushl  -0x50(%ebp)
  802d72:	ff 75 ac             	pushl  -0x54(%ebp)
  802d75:	e8 e3 0c 00 00       	call   803a5d <sys_free_user_mem>
  802d7a:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802d7d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802d84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802d8b:	eb 64                	jmp    802df1 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802d8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d90:	89 d0                	mov    %edx,%eax
  802d92:	01 c0                	add    %eax,%eax
  802d94:	01 d0                	add    %edx,%eax
  802d96:	c1 e0 02             	shl    $0x2,%eax
  802d99:	05 48 20 81 00       	add    $0x812048,%eax
  802d9e:	8a 00                	mov    (%eax),%al
  802da0:	84 c0                	test   %al,%al
  802da2:	75 4a                	jne    802dee <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802da4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802da7:	89 d0                	mov    %edx,%eax
  802da9:	01 c0                	add    %eax,%eax
  802dab:	01 d0                	add    %edx,%eax
  802dad:	c1 e0 02             	shl    $0x2,%eax
  802db0:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802db6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802db9:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802dbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dbe:	89 d0                	mov    %edx,%eax
  802dc0:	01 c0                	add    %eax,%eax
  802dc2:	01 d0                	add    %edx,%eax
  802dc4:	c1 e0 02             	shl    $0x2,%eax
  802dc7:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802dcd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dd0:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802dd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd5:	89 d0                	mov    %edx,%eax
  802dd7:	01 c0                	add    %eax,%eax
  802dd9:	01 d0                	add    %edx,%eax
  802ddb:	c1 e0 02             	shl    $0x2,%eax
  802dde:	05 48 20 81 00       	add    $0x812048,%eax
  802de3:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de9:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802dec:	eb 0c                	jmp    802dfa <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802dee:	ff 45 e4             	incl   -0x1c(%ebp)
  802df1:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802df8:	7e 93                	jle    802d8d <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802dfa:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802dfe:	0f 84 8d 01 00 00    	je     802f91 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e0b:	e9 74 01 00 00       	jmp    802f84 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802e10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e13:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e16:	0f 84 64 01 00 00    	je     802f80 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802e1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e1f:	89 d0                	mov    %edx,%eax
  802e21:	01 c0                	add    %eax,%eax
  802e23:	01 d0                	add    %edx,%eax
  802e25:	c1 e0 02             	shl    $0x2,%eax
  802e28:	05 48 20 81 00       	add    $0x812048,%eax
  802e2d:	8a 00                	mov    (%eax),%al
  802e2f:	84 c0                	test   %al,%al
  802e31:	0f 84 4a 01 00 00    	je     802f81 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802e37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3a:	89 d0                	mov    %edx,%eax
  802e3c:	01 c0                	add    %eax,%eax
  802e3e:	01 d0                	add    %edx,%eax
  802e40:	c1 e0 02             	shl    $0x2,%eax
  802e43:	05 40 20 81 00       	add    $0x812040,%eax
  802e48:	8b 08                	mov    (%eax),%ecx
  802e4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e4d:	89 d0                	mov    %edx,%eax
  802e4f:	01 c0                	add    %eax,%eax
  802e51:	01 d0                	add    %edx,%eax
  802e53:	c1 e0 02             	shl    $0x2,%eax
  802e56:	05 44 20 81 00       	add    $0x812044,%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	01 c1                	add    %eax,%ecx
  802e5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e62:	89 d0                	mov    %edx,%eax
  802e64:	01 c0                	add    %eax,%eax
  802e66:	01 d0                	add    %edx,%eax
  802e68:	c1 e0 02             	shl    $0x2,%eax
  802e6b:	05 40 20 81 00       	add    $0x812040,%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	39 c1                	cmp    %eax,%ecx
  802e74:	75 7a                	jne    802ef0 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802e76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e79:	89 d0                	mov    %edx,%eax
  802e7b:	01 c0                	add    %eax,%eax
  802e7d:	01 d0                	add    %edx,%eax
  802e7f:	c1 e0 02             	shl    $0x2,%eax
  802e82:	05 40 20 81 00       	add    $0x812040,%eax
  802e87:	8b 10                	mov    (%eax),%edx
  802e89:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802e8c:	89 c8                	mov    %ecx,%eax
  802e8e:	01 c0                	add    %eax,%eax
  802e90:	01 c8                	add    %ecx,%eax
  802e92:	c1 e0 02             	shl    $0x2,%eax
  802e95:	05 40 20 81 00       	add    $0x812040,%eax
  802e9a:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802e9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e9f:	89 d0                	mov    %edx,%eax
  802ea1:	01 c0                	add    %eax,%eax
  802ea3:	01 d0                	add    %edx,%eax
  802ea5:	c1 e0 02             	shl    $0x2,%eax
  802ea8:	05 44 20 81 00       	add    $0x812044,%eax
  802ead:	8b 08                	mov    (%eax),%ecx
  802eaf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eb2:	89 d0                	mov    %edx,%eax
  802eb4:	01 c0                	add    %eax,%eax
  802eb6:	01 d0                	add    %edx,%eax
  802eb8:	c1 e0 02             	shl    $0x2,%eax
  802ebb:	05 44 20 81 00       	add    $0x812044,%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	01 c1                	add    %eax,%ecx
  802ec4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec7:	89 d0                	mov    %edx,%eax
  802ec9:	01 c0                	add    %eax,%eax
  802ecb:	01 d0                	add    %edx,%eax
  802ecd:	c1 e0 02             	shl    $0x2,%eax
  802ed0:	05 44 20 81 00       	add    $0x812044,%eax
  802ed5:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802ed7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eda:	89 d0                	mov    %edx,%eax
  802edc:	01 c0                	add    %eax,%eax
  802ede:	01 d0                	add    %edx,%eax
  802ee0:	c1 e0 02             	shl    $0x2,%eax
  802ee3:	05 48 20 81 00       	add    $0x812048,%eax
  802ee8:	c6 00 00             	movb   $0x0,(%eax)
  802eeb:	e9 91 00 00 00       	jmp    802f81 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802ef0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef3:	89 d0                	mov    %edx,%eax
  802ef5:	01 c0                	add    %eax,%eax
  802ef7:	01 d0                	add    %edx,%eax
  802ef9:	c1 e0 02             	shl    $0x2,%eax
  802efc:	05 40 20 81 00       	add    $0x812040,%eax
  802f01:	8b 08                	mov    (%eax),%ecx
  802f03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f06:	89 d0                	mov    %edx,%eax
  802f08:	01 c0                	add    %eax,%eax
  802f0a:	01 d0                	add    %edx,%eax
  802f0c:	c1 e0 02             	shl    $0x2,%eax
  802f0f:	05 44 20 81 00       	add    $0x812044,%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	01 c1                	add    %eax,%ecx
  802f18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f1b:	89 d0                	mov    %edx,%eax
  802f1d:	01 c0                	add    %eax,%eax
  802f1f:	01 d0                	add    %edx,%eax
  802f21:	c1 e0 02             	shl    $0x2,%eax
  802f24:	05 40 20 81 00       	add    $0x812040,%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	39 c1                	cmp    %eax,%ecx
  802f2d:	75 52                	jne    802f81 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802f2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f32:	89 d0                	mov    %edx,%eax
  802f34:	01 c0                	add    %eax,%eax
  802f36:	01 d0                	add    %edx,%eax
  802f38:	c1 e0 02             	shl    $0x2,%eax
  802f3b:	05 44 20 81 00       	add    $0x812044,%eax
  802f40:	8b 08                	mov    (%eax),%ecx
  802f42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f45:	89 d0                	mov    %edx,%eax
  802f47:	01 c0                	add    %eax,%eax
  802f49:	01 d0                	add    %edx,%eax
  802f4b:	c1 e0 02             	shl    $0x2,%eax
  802f4e:	05 44 20 81 00       	add    $0x812044,%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	01 c1                	add    %eax,%ecx
  802f57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f5a:	89 d0                	mov    %edx,%eax
  802f5c:	01 c0                	add    %eax,%eax
  802f5e:	01 d0                	add    %edx,%eax
  802f60:	c1 e0 02             	shl    $0x2,%eax
  802f63:	05 44 20 81 00       	add    $0x812044,%eax
  802f68:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802f6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f6d:	89 d0                	mov    %edx,%eax
  802f6f:	01 c0                	add    %eax,%eax
  802f71:	01 d0                	add    %edx,%eax
  802f73:	c1 e0 02             	shl    $0x2,%eax
  802f76:	05 48 20 81 00       	add    $0x812048,%eax
  802f7b:	c6 00 00             	movb   $0x0,(%eax)
  802f7e:	eb 01                	jmp    802f81 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802f80:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802f81:	ff 45 e0             	incl   -0x20(%ebp)
  802f84:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802f8b:	0f 8e 7f fe ff ff    	jle    802e10 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802f91:	a1 30 61 83 00       	mov    0x836130,%eax
  802f96:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802f99:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802fa0:	eb 53                	jmp    802ff5 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802fa2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802fa5:	89 d0                	mov    %edx,%eax
  802fa7:	01 c0                	add    %eax,%eax
  802fa9:	01 d0                	add    %edx,%eax
  802fab:	c1 e0 02             	shl    $0x2,%eax
  802fae:	05 48 60 80 00       	add    $0x806048,%eax
  802fb3:	8a 00                	mov    (%eax),%al
  802fb5:	84 c0                	test   %al,%al
  802fb7:	74 39                	je     802ff2 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802fb9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802fbc:	89 d0                	mov    %edx,%eax
  802fbe:	01 c0                	add    %eax,%eax
  802fc0:	01 d0                	add    %edx,%eax
  802fc2:	c1 e0 02             	shl    $0x2,%eax
  802fc5:	05 40 60 80 00       	add    $0x806040,%eax
  802fca:	8b 08                	mov    (%eax),%ecx
  802fcc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802fcf:	89 d0                	mov    %edx,%eax
  802fd1:	01 c0                	add    %eax,%eax
  802fd3:	01 d0                	add    %edx,%eax
  802fd5:	c1 e0 02             	shl    $0x2,%eax
  802fd8:	05 44 60 80 00       	add    $0x806044,%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	01 c8                	add    %ecx,%eax
  802fe1:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802fe4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fe7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802fea:	76 06                	jbe    802ff2 <realloc+0x453>
  802fec:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802ff2:	ff 45 d8             	incl   -0x28(%ebp)
  802ff5:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802ffc:	7e a4                	jle    802fa2 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802ffe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803001:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	e9 a9 01 00 00       	jmp    8031b7 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  80300e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	01 d0                	add    %edx,%eax
  803016:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  803019:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803020:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  803027:	eb 57                	jmp    803080 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  803029:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80302c:	89 d0                	mov    %edx,%eax
  80302e:	01 c0                	add    %eax,%eax
  803030:	01 d0                	add    %edx,%eax
  803032:	c1 e0 02             	shl    $0x2,%eax
  803035:	05 48 20 81 00       	add    $0x812048,%eax
  80303a:	8a 00                	mov    (%eax),%al
  80303c:	84 c0                	test   %al,%al
  80303e:	74 3d                	je     80307d <realloc+0x4de>
  803040:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803043:	89 d0                	mov    %edx,%eax
  803045:	01 c0                	add    %eax,%eax
  803047:	01 d0                	add    %edx,%eax
  803049:	c1 e0 02             	shl    $0x2,%eax
  80304c:	05 40 20 81 00       	add    $0x812040,%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803056:	75 25                	jne    80307d <realloc+0x4de>
  803058:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80305b:	89 d0                	mov    %edx,%eax
  80305d:	01 c0                	add    %eax,%eax
  80305f:	01 d0                	add    %edx,%eax
  803061:	c1 e0 02             	shl    $0x2,%eax
  803064:	05 44 20 81 00       	add    $0x812044,%eax
  803069:	8b 10                	mov    (%eax),%edx
  80306b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80306e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803071:	39 c2                	cmp    %eax,%edx
  803073:	72 08                	jb     80307d <realloc+0x4de>
		{
			adjIdx = j; break;
  803075:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803078:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80307b:	eb 0c                	jmp    803089 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80307d:	ff 45 d0             	incl   -0x30(%ebp)
  803080:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  803087:	7e a0                	jle    803029 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  803089:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  80308d:	0f 84 d6 00 00 00    	je     803169 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  803093:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803096:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803099:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  80309c:	83 ec 08             	sub    $0x8,%esp
  80309f:	ff 75 a0             	pushl  -0x60(%ebp)
  8030a2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8030a5:	e8 cf 09 00 00       	call   803a79 <sys_allocate_user_mem>
  8030aa:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8030ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030b0:	89 d0                	mov    %edx,%eax
  8030b2:	01 c0                	add    %eax,%eax
  8030b4:	01 d0                	add    %edx,%eax
  8030b6:	c1 e0 02             	shl    $0x2,%eax
  8030b9:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8030bf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030c2:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8030c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8030c7:	89 d0                	mov    %edx,%eax
  8030c9:	01 c0                	add    %eax,%eax
  8030cb:	01 d0                	add    %edx,%eax
  8030cd:	c1 e0 02             	shl    $0x2,%eax
  8030d0:	05 40 20 81 00       	add    $0x812040,%eax
  8030d5:	8b 10                	mov    (%eax),%edx
  8030d7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8030da:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8030dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8030e0:	89 d0                	mov    %edx,%eax
  8030e2:	01 c0                	add    %eax,%eax
  8030e4:	01 d0                	add    %edx,%eax
  8030e6:	c1 e0 02             	shl    $0x2,%eax
  8030e9:	05 40 20 81 00       	add    $0x812040,%eax
  8030ee:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8030f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8030f3:	89 d0                	mov    %edx,%eax
  8030f5:	01 c0                	add    %eax,%eax
  8030f7:	01 d0                	add    %edx,%eax
  8030f9:	c1 e0 02             	shl    $0x2,%eax
  8030fc:	05 44 20 81 00       	add    $0x812044,%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	2b 45 a0             	sub    -0x60(%ebp),%eax
  803106:	89 c2                	mov    %eax,%edx
  803108:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80310b:	89 c8                	mov    %ecx,%eax
  80310d:	01 c0                	add    %eax,%eax
  80310f:	01 c8                	add    %ecx,%eax
  803111:	c1 e0 02             	shl    $0x2,%eax
  803114:	05 44 20 81 00       	add    $0x812044,%eax
  803119:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  80311b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80311e:	89 d0                	mov    %edx,%eax
  803120:	01 c0                	add    %eax,%eax
  803122:	01 d0                	add    %edx,%eax
  803124:	c1 e0 02             	shl    $0x2,%eax
  803127:	05 44 20 81 00       	add    $0x812044,%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	85 c0                	test   %eax,%eax
  803130:	75 14                	jne    803146 <realloc+0x5a7>
  803132:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803135:	89 d0                	mov    %edx,%eax
  803137:	01 c0                	add    %eax,%eax
  803139:	01 d0                	add    %edx,%eax
  80313b:	c1 e0 02             	shl    $0x2,%eax
  80313e:	05 48 20 81 00       	add    $0x812048,%eax
  803143:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  803146:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803149:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80314c:	01 c2                	add    %eax,%edx
  80314e:	a1 88 60 83 00       	mov    0x836088,%eax
  803153:	39 c2                	cmp    %eax,%edx
  803155:	76 0d                	jbe    803164 <realloc+0x5c5>
  803157:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80315a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80315d:	01 d0                	add    %edx,%eax
  80315f:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	eb 4e                	jmp    8031b7 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  803169:	83 ec 0c             	sub    $0xc,%esp
  80316c:	ff 75 0c             	pushl  0xc(%ebp)
  80316f:	e8 0b ec ff ff       	call   801d7f <malloc>
  803174:	83 c4 10             	add    $0x10,%esp
  803177:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  80317a:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80317e:	75 07                	jne    803187 <realloc+0x5e8>
		return NULL;
  803180:	b8 00 00 00 00       	mov    $0x0,%eax
  803185:	eb 30                	jmp    8031b7 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  803187:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80318a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80318d:	39 d0                	cmp    %edx,%eax
  80318f:	76 02                	jbe    803193 <realloc+0x5f4>
  803191:	89 d0                	mov    %edx,%eax
  803193:	8b 55 9c             	mov    -0x64(%ebp),%edx
  803196:	83 ec 04             	sub    $0x4,%esp
  803199:	50                   	push   %eax
  80319a:	52                   	push   %edx
  80319b:	ff 75 cc             	pushl  -0x34(%ebp)
  80319e:	e8 cf 06 00 00       	call   803872 <sys_move_user_mem>
  8031a3:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  8031a6:	83 ec 0c             	sub    $0xc,%esp
  8031a9:	ff 75 08             	pushl  0x8(%ebp)
  8031ac:	e8 2e ef ff ff       	call   8020df <free>
  8031b1:	83 c4 10             	add    $0x10,%esp
	return newptr;
  8031b4:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  8031b7:	c9                   	leave  
  8031b8:	c3                   	ret    

008031b9 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8031b9:	55                   	push   %ebp
  8031ba:	89 e5                	mov    %esp,%ebp
  8031bc:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8031c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031c9:	0f 84 33 03 00 00    	je     803502 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8031cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d2:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8031d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8031da:	83 ec 08             	sub    $0x8,%esp
  8031dd:	ff 75 08             	pushl  0x8(%ebp)
  8031e0:	ff 75 d8             	pushl  -0x28(%ebp)
  8031e3:	e8 7d 05 00 00       	call   803765 <sys_delete_shared_object>
  8031e8:	83 c4 10             	add    $0x10,%esp
  8031eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8031ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031f2:	0f 88 0d 03 00 00    	js     803505 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8031f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031ff:	e9 ef 02 00 00       	jmp    8034f3 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803204:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803207:	89 d0                	mov    %edx,%eax
  803209:	01 c0                	add    %eax,%eax
  80320b:	01 d0                	add    %edx,%eax
  80320d:	c1 e0 02             	shl    $0x2,%eax
  803210:	05 48 60 80 00       	add    $0x806048,%eax
  803215:	8a 00                	mov    (%eax),%al
  803217:	84 c0                	test   %al,%al
  803219:	0f 84 d1 02 00 00    	je     8034f0 <sfree+0x337>
  80321f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803222:	89 d0                	mov    %edx,%eax
  803224:	01 c0                	add    %eax,%eax
  803226:	01 d0                	add    %edx,%eax
  803228:	c1 e0 02             	shl    $0x2,%eax
  80322b:	05 40 60 80 00       	add    $0x806040,%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803235:	0f 85 b5 02 00 00    	jne    8034f0 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  80323b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323e:	89 d0                	mov    %edx,%eax
  803240:	01 c0                	add    %eax,%eax
  803242:	01 d0                	add    %edx,%eax
  803244:	c1 e0 02             	shl    $0x2,%eax
  803247:	05 44 60 80 00       	add    $0x806044,%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803254:	89 d0                	mov    %edx,%eax
  803256:	01 c0                	add    %eax,%eax
  803258:	01 d0                	add    %edx,%eax
  80325a:	c1 e0 02             	shl    $0x2,%eax
  80325d:	05 48 60 80 00       	add    $0x806048,%eax
  803262:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  803265:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80326c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803273:	eb 64                	jmp    8032d9 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  803275:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803278:	89 d0                	mov    %edx,%eax
  80327a:	01 c0                	add    %eax,%eax
  80327c:	01 d0                	add    %edx,%eax
  80327e:	c1 e0 02             	shl    $0x2,%eax
  803281:	05 48 20 81 00       	add    $0x812048,%eax
  803286:	8a 00                	mov    (%eax),%al
  803288:	84 c0                	test   %al,%al
  80328a:	75 4a                	jne    8032d6 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  80328c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80328f:	89 d0                	mov    %edx,%eax
  803291:	01 c0                	add    %eax,%eax
  803293:	01 d0                	add    %edx,%eax
  803295:	c1 e0 02             	shl    $0x2,%eax
  803298:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  80329e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a1:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  8032a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032a6:	89 d0                	mov    %edx,%eax
  8032a8:	01 c0                	add    %eax,%eax
  8032aa:	01 d0                	add    %edx,%eax
  8032ac:	c1 e0 02             	shl    $0x2,%eax
  8032af:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  8032b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032b8:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  8032ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032bd:	89 d0                	mov    %edx,%eax
  8032bf:	01 c0                	add    %eax,%eax
  8032c1:	01 d0                	add    %edx,%eax
  8032c3:	c1 e0 02             	shl    $0x2,%eax
  8032c6:	05 48 20 81 00       	add    $0x812048,%eax
  8032cb:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  8032ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  8032d4:	eb 0c                	jmp    8032e2 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8032d6:	ff 45 ec             	incl   -0x14(%ebp)
  8032d9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8032e0:	7e 93                	jle    803275 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  8032e2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8032e6:	0f 84 8d 01 00 00    	je     803479 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8032ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8032f3:	e9 74 01 00 00       	jmp    80346c <sfree+0x2b3>
				{
					if (k == fidx) continue;
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032fe:	0f 84 64 01 00 00    	je     803468 <sfree+0x2af>
					if (uhp_frees[k].free)
  803304:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803307:	89 d0                	mov    %edx,%eax
  803309:	01 c0                	add    %eax,%eax
  80330b:	01 d0                	add    %edx,%eax
  80330d:	c1 e0 02             	shl    $0x2,%eax
  803310:	05 48 20 81 00       	add    $0x812048,%eax
  803315:	8a 00                	mov    (%eax),%al
  803317:	84 c0                	test   %al,%al
  803319:	0f 84 4a 01 00 00    	je     803469 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80331f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803322:	89 d0                	mov    %edx,%eax
  803324:	01 c0                	add    %eax,%eax
  803326:	01 d0                	add    %edx,%eax
  803328:	c1 e0 02             	shl    $0x2,%eax
  80332b:	05 40 20 81 00       	add    $0x812040,%eax
  803330:	8b 08                	mov    (%eax),%ecx
  803332:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803335:	89 d0                	mov    %edx,%eax
  803337:	01 c0                	add    %eax,%eax
  803339:	01 d0                	add    %edx,%eax
  80333b:	c1 e0 02             	shl    $0x2,%eax
  80333e:	05 44 20 81 00       	add    $0x812044,%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	01 c1                	add    %eax,%ecx
  803347:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334a:	89 d0                	mov    %edx,%eax
  80334c:	01 c0                	add    %eax,%eax
  80334e:	01 d0                	add    %edx,%eax
  803350:	c1 e0 02             	shl    $0x2,%eax
  803353:	05 40 20 81 00       	add    $0x812040,%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	39 c1                	cmp    %eax,%ecx
  80335c:	75 7a                	jne    8033d8 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  80335e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803361:	89 d0                	mov    %edx,%eax
  803363:	01 c0                	add    %eax,%eax
  803365:	01 d0                	add    %edx,%eax
  803367:	c1 e0 02             	shl    $0x2,%eax
  80336a:	05 40 20 81 00       	add    $0x812040,%eax
  80336f:	8b 10                	mov    (%eax),%edx
  803371:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803374:	89 c8                	mov    %ecx,%eax
  803376:	01 c0                	add    %eax,%eax
  803378:	01 c8                	add    %ecx,%eax
  80337a:	c1 e0 02             	shl    $0x2,%eax
  80337d:	05 40 20 81 00       	add    $0x812040,%eax
  803382:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  803384:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803387:	89 d0                	mov    %edx,%eax
  803389:	01 c0                	add    %eax,%eax
  80338b:	01 d0                	add    %edx,%eax
  80338d:	c1 e0 02             	shl    $0x2,%eax
  803390:	05 44 20 81 00       	add    $0x812044,%eax
  803395:	8b 08                	mov    (%eax),%ecx
  803397:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339a:	89 d0                	mov    %edx,%eax
  80339c:	01 c0                	add    %eax,%eax
  80339e:	01 d0                	add    %edx,%eax
  8033a0:	c1 e0 02             	shl    $0x2,%eax
  8033a3:	05 44 20 81 00       	add    $0x812044,%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	01 c1                	add    %eax,%ecx
  8033ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033af:	89 d0                	mov    %edx,%eax
  8033b1:	01 c0                	add    %eax,%eax
  8033b3:	01 d0                	add    %edx,%eax
  8033b5:	c1 e0 02             	shl    $0x2,%eax
  8033b8:	05 44 20 81 00       	add    $0x812044,%eax
  8033bd:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8033bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c2:	89 d0                	mov    %edx,%eax
  8033c4:	01 c0                	add    %eax,%eax
  8033c6:	01 d0                	add    %edx,%eax
  8033c8:	c1 e0 02             	shl    $0x2,%eax
  8033cb:	05 48 20 81 00       	add    $0x812048,%eax
  8033d0:	c6 00 00             	movb   $0x0,(%eax)
  8033d3:	e9 91 00 00 00       	jmp    803469 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8033d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033db:	89 d0                	mov    %edx,%eax
  8033dd:	01 c0                	add    %eax,%eax
  8033df:	01 d0                	add    %edx,%eax
  8033e1:	c1 e0 02             	shl    $0x2,%eax
  8033e4:	05 40 20 81 00       	add    $0x812040,%eax
  8033e9:	8b 08                	mov    (%eax),%ecx
  8033eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033ee:	89 d0                	mov    %edx,%eax
  8033f0:	01 c0                	add    %eax,%eax
  8033f2:	01 d0                	add    %edx,%eax
  8033f4:	c1 e0 02             	shl    $0x2,%eax
  8033f7:	05 44 20 81 00       	add    $0x812044,%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	01 c1                	add    %eax,%ecx
  803400:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803403:	89 d0                	mov    %edx,%eax
  803405:	01 c0                	add    %eax,%eax
  803407:	01 d0                	add    %edx,%eax
  803409:	c1 e0 02             	shl    $0x2,%eax
  80340c:	05 40 20 81 00       	add    $0x812040,%eax
  803411:	8b 00                	mov    (%eax),%eax
  803413:	39 c1                	cmp    %eax,%ecx
  803415:	75 52                	jne    803469 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803417:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80341a:	89 d0                	mov    %edx,%eax
  80341c:	01 c0                	add    %eax,%eax
  80341e:	01 d0                	add    %edx,%eax
  803420:	c1 e0 02             	shl    $0x2,%eax
  803423:	05 44 20 81 00       	add    $0x812044,%eax
  803428:	8b 08                	mov    (%eax),%ecx
  80342a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342d:	89 d0                	mov    %edx,%eax
  80342f:	01 c0                	add    %eax,%eax
  803431:	01 d0                	add    %edx,%eax
  803433:	c1 e0 02             	shl    $0x2,%eax
  803436:	05 44 20 81 00       	add    $0x812044,%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	01 c1                	add    %eax,%ecx
  80343f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803442:	89 d0                	mov    %edx,%eax
  803444:	01 c0                	add    %eax,%eax
  803446:	01 d0                	add    %edx,%eax
  803448:	c1 e0 02             	shl    $0x2,%eax
  80344b:	05 44 20 81 00       	add    $0x812044,%eax
  803450:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803452:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803455:	89 d0                	mov    %edx,%eax
  803457:	01 c0                	add    %eax,%eax
  803459:	01 d0                	add    %edx,%eax
  80345b:	c1 e0 02             	shl    $0x2,%eax
  80345e:	05 48 20 81 00       	add    $0x812048,%eax
  803463:	c6 00 00             	movb   $0x0,(%eax)
  803466:	eb 01                	jmp    803469 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  803468:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803469:	ff 45 e8             	incl   -0x18(%ebp)
  80346c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803473:	0f 8e 7f fe ff ff    	jle    8032f8 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803479:	a1 30 61 83 00       	mov    0x836130,%eax
  80347e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803481:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803488:	eb 53                	jmp    8034dd <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  80348a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80348d:	89 d0                	mov    %edx,%eax
  80348f:	01 c0                	add    %eax,%eax
  803491:	01 d0                	add    %edx,%eax
  803493:	c1 e0 02             	shl    $0x2,%eax
  803496:	05 48 60 80 00       	add    $0x806048,%eax
  80349b:	8a 00                	mov    (%eax),%al
  80349d:	84 c0                	test   %al,%al
  80349f:	74 39                	je     8034da <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8034a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034a4:	89 d0                	mov    %edx,%eax
  8034a6:	01 c0                	add    %eax,%eax
  8034a8:	01 d0                	add    %edx,%eax
  8034aa:	c1 e0 02             	shl    $0x2,%eax
  8034ad:	05 40 60 80 00       	add    $0x806040,%eax
  8034b2:	8b 08                	mov    (%eax),%ecx
  8034b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034b7:	89 d0                	mov    %edx,%eax
  8034b9:	01 c0                	add    %eax,%eax
  8034bb:	01 d0                	add    %edx,%eax
  8034bd:	c1 e0 02             	shl    $0x2,%eax
  8034c0:	05 44 60 80 00       	add    $0x806044,%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	01 c8                	add    %ecx,%eax
  8034c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  8034cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034d2:	76 06                	jbe    8034da <sfree+0x321>
  8034d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8034da:	ff 45 e0             	incl   -0x20(%ebp)
  8034dd:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8034e4:	7e a4                	jle    80348a <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  8034e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e9:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  8034ee:	eb 16                	jmp    803506 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8034f0:	ff 45 f4             	incl   -0xc(%ebp)
  8034f3:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  8034fa:	0f 8e 04 fd ff ff    	jle    803204 <sfree+0x4b>
  803500:	eb 04                	jmp    803506 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803502:	90                   	nop
  803503:	eb 01                	jmp    803506 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803505:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803506:	c9                   	leave  
  803507:	c3                   	ret    

00803508 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803508:	55                   	push   %ebp
  803509:	89 e5                	mov    %esp,%ebp
  80350b:	57                   	push   %edi
  80350c:	56                   	push   %esi
  80350d:	53                   	push   %ebx
  80350e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 55 0c             	mov    0xc(%ebp),%edx
  803517:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80351a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80351d:	8b 7d 18             	mov    0x18(%ebp),%edi
  803520:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803523:	cd 30                	int    $0x30
  803525:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803528:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80352b:	83 c4 10             	add    $0x10,%esp
  80352e:	5b                   	pop    %ebx
  80352f:	5e                   	pop    %esi
  803530:	5f                   	pop    %edi
  803531:	5d                   	pop    %ebp
  803532:	c3                   	ret    

00803533 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803533:	55                   	push   %ebp
  803534:	89 e5                	mov    %esp,%ebp
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	8b 45 10             	mov    0x10(%ebp),%eax
  80353c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80353f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803542:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	6a 00                	push   $0x0
  80354b:	51                   	push   %ecx
  80354c:	52                   	push   %edx
  80354d:	ff 75 0c             	pushl  0xc(%ebp)
  803550:	50                   	push   %eax
  803551:	6a 00                	push   $0x0
  803553:	e8 b0 ff ff ff       	call   803508 <syscall>
  803558:	83 c4 18             	add    $0x18,%esp
}
  80355b:	90                   	nop
  80355c:	c9                   	leave  
  80355d:	c3                   	ret    

0080355e <sys_cgetc>:

int
sys_cgetc(void)
{
  80355e:	55                   	push   %ebp
  80355f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803561:	6a 00                	push   $0x0
  803563:	6a 00                	push   $0x0
  803565:	6a 00                	push   $0x0
  803567:	6a 00                	push   $0x0
  803569:	6a 00                	push   $0x0
  80356b:	6a 02                	push   $0x2
  80356d:	e8 96 ff ff ff       	call   803508 <syscall>
  803572:	83 c4 18             	add    $0x18,%esp
}
  803575:	c9                   	leave  
  803576:	c3                   	ret    

00803577 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803577:	55                   	push   %ebp
  803578:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80357a:	6a 00                	push   $0x0
  80357c:	6a 00                	push   $0x0
  80357e:	6a 00                	push   $0x0
  803580:	6a 00                	push   $0x0
  803582:	6a 00                	push   $0x0
  803584:	6a 03                	push   $0x3
  803586:	e8 7d ff ff ff       	call   803508 <syscall>
  80358b:	83 c4 18             	add    $0x18,%esp
}
  80358e:	90                   	nop
  80358f:	c9                   	leave  
  803590:	c3                   	ret    

00803591 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803591:	55                   	push   %ebp
  803592:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803594:	6a 00                	push   $0x0
  803596:	6a 00                	push   $0x0
  803598:	6a 00                	push   $0x0
  80359a:	6a 00                	push   $0x0
  80359c:	6a 00                	push   $0x0
  80359e:	6a 04                	push   $0x4
  8035a0:	e8 63 ff ff ff       	call   803508 <syscall>
  8035a5:	83 c4 18             	add    $0x18,%esp
}
  8035a8:	90                   	nop
  8035a9:	c9                   	leave  
  8035aa:	c3                   	ret    

008035ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8035ab:	55                   	push   %ebp
  8035ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8035ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	6a 00                	push   $0x0
  8035b6:	6a 00                	push   $0x0
  8035b8:	6a 00                	push   $0x0
  8035ba:	52                   	push   %edx
  8035bb:	50                   	push   %eax
  8035bc:	6a 08                	push   $0x8
  8035be:	e8 45 ff ff ff       	call   803508 <syscall>
  8035c3:	83 c4 18             	add    $0x18,%esp
}
  8035c6:	c9                   	leave  
  8035c7:	c3                   	ret    

008035c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8035c8:	55                   	push   %ebp
  8035c9:	89 e5                	mov    %esp,%ebp
  8035cb:	56                   	push   %esi
  8035cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8035cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8035d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8035d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8035d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	56                   	push   %esi
  8035dd:	53                   	push   %ebx
  8035de:	51                   	push   %ecx
  8035df:	52                   	push   %edx
  8035e0:	50                   	push   %eax
  8035e1:	6a 09                	push   $0x9
  8035e3:	e8 20 ff ff ff       	call   803508 <syscall>
  8035e8:	83 c4 18             	add    $0x18,%esp
}
  8035eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8035ee:	5b                   	pop    %ebx
  8035ef:	5e                   	pop    %esi
  8035f0:	5d                   	pop    %ebp
  8035f1:	c3                   	ret    

008035f2 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8035f2:	55                   	push   %ebp
  8035f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8035f5:	6a 00                	push   $0x0
  8035f7:	6a 00                	push   $0x0
  8035f9:	6a 00                	push   $0x0
  8035fb:	6a 00                	push   $0x0
  8035fd:	ff 75 08             	pushl  0x8(%ebp)
  803600:	6a 0a                	push   $0xa
  803602:	e8 01 ff ff ff       	call   803508 <syscall>
  803607:	83 c4 18             	add    $0x18,%esp
}
  80360a:	c9                   	leave  
  80360b:	c3                   	ret    

0080360c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80360c:	55                   	push   %ebp
  80360d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80360f:	6a 00                	push   $0x0
  803611:	6a 00                	push   $0x0
  803613:	6a 00                	push   $0x0
  803615:	ff 75 0c             	pushl  0xc(%ebp)
  803618:	ff 75 08             	pushl  0x8(%ebp)
  80361b:	6a 0b                	push   $0xb
  80361d:	e8 e6 fe ff ff       	call   803508 <syscall>
  803622:	83 c4 18             	add    $0x18,%esp
}
  803625:	c9                   	leave  
  803626:	c3                   	ret    

00803627 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803627:	55                   	push   %ebp
  803628:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80362a:	6a 00                	push   $0x0
  80362c:	6a 00                	push   $0x0
  80362e:	6a 00                	push   $0x0
  803630:	6a 00                	push   $0x0
  803632:	6a 00                	push   $0x0
  803634:	6a 0c                	push   $0xc
  803636:	e8 cd fe ff ff       	call   803508 <syscall>
  80363b:	83 c4 18             	add    $0x18,%esp
}
  80363e:	c9                   	leave  
  80363f:	c3                   	ret    

00803640 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803640:	55                   	push   %ebp
  803641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803643:	6a 00                	push   $0x0
  803645:	6a 00                	push   $0x0
  803647:	6a 00                	push   $0x0
  803649:	6a 00                	push   $0x0
  80364b:	6a 00                	push   $0x0
  80364d:	6a 0d                	push   $0xd
  80364f:	e8 b4 fe ff ff       	call   803508 <syscall>
  803654:	83 c4 18             	add    $0x18,%esp
}
  803657:	c9                   	leave  
  803658:	c3                   	ret    

00803659 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803659:	55                   	push   %ebp
  80365a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80365c:	6a 00                	push   $0x0
  80365e:	6a 00                	push   $0x0
  803660:	6a 00                	push   $0x0
  803662:	6a 00                	push   $0x0
  803664:	6a 00                	push   $0x0
  803666:	6a 0e                	push   $0xe
  803668:	e8 9b fe ff ff       	call   803508 <syscall>
  80366d:	83 c4 18             	add    $0x18,%esp
}
  803670:	c9                   	leave  
  803671:	c3                   	ret    

00803672 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803672:	55                   	push   %ebp
  803673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803675:	6a 00                	push   $0x0
  803677:	6a 00                	push   $0x0
  803679:	6a 00                	push   $0x0
  80367b:	6a 00                	push   $0x0
  80367d:	6a 00                	push   $0x0
  80367f:	6a 0f                	push   $0xf
  803681:	e8 82 fe ff ff       	call   803508 <syscall>
  803686:	83 c4 18             	add    $0x18,%esp
}
  803689:	c9                   	leave  
  80368a:	c3                   	ret    

0080368b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80368b:	55                   	push   %ebp
  80368c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80368e:	6a 00                	push   $0x0
  803690:	6a 00                	push   $0x0
  803692:	6a 00                	push   $0x0
  803694:	6a 00                	push   $0x0
  803696:	ff 75 08             	pushl  0x8(%ebp)
  803699:	6a 10                	push   $0x10
  80369b:	e8 68 fe ff ff       	call   803508 <syscall>
  8036a0:	83 c4 18             	add    $0x18,%esp
}
  8036a3:	c9                   	leave  
  8036a4:	c3                   	ret    

008036a5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8036a5:	55                   	push   %ebp
  8036a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8036a8:	6a 00                	push   $0x0
  8036aa:	6a 00                	push   $0x0
  8036ac:	6a 00                	push   $0x0
  8036ae:	6a 00                	push   $0x0
  8036b0:	6a 00                	push   $0x0
  8036b2:	6a 11                	push   $0x11
  8036b4:	e8 4f fe ff ff       	call   803508 <syscall>
  8036b9:	83 c4 18             	add    $0x18,%esp
}
  8036bc:	90                   	nop
  8036bd:	c9                   	leave  
  8036be:	c3                   	ret    

008036bf <sys_cputc>:

void
sys_cputc(const char c)
{
  8036bf:	55                   	push   %ebp
  8036c0:	89 e5                	mov    %esp,%ebp
  8036c2:	83 ec 04             	sub    $0x4,%esp
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8036cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8036cf:	6a 00                	push   $0x0
  8036d1:	6a 00                	push   $0x0
  8036d3:	6a 00                	push   $0x0
  8036d5:	6a 00                	push   $0x0
  8036d7:	50                   	push   %eax
  8036d8:	6a 01                	push   $0x1
  8036da:	e8 29 fe ff ff       	call   803508 <syscall>
  8036df:	83 c4 18             	add    $0x18,%esp
}
  8036e2:	90                   	nop
  8036e3:	c9                   	leave  
  8036e4:	c3                   	ret    

008036e5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8036e5:	55                   	push   %ebp
  8036e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8036e8:	6a 00                	push   $0x0
  8036ea:	6a 00                	push   $0x0
  8036ec:	6a 00                	push   $0x0
  8036ee:	6a 00                	push   $0x0
  8036f0:	6a 00                	push   $0x0
  8036f2:	6a 14                	push   $0x14
  8036f4:	e8 0f fe ff ff       	call   803508 <syscall>
  8036f9:	83 c4 18             	add    $0x18,%esp
}
  8036fc:	90                   	nop
  8036fd:	c9                   	leave  
  8036fe:	c3                   	ret    

008036ff <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8036ff:	55                   	push   %ebp
  803700:	89 e5                	mov    %esp,%ebp
  803702:	83 ec 04             	sub    $0x4,%esp
  803705:	8b 45 10             	mov    0x10(%ebp),%eax
  803708:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80370b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80370e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	6a 00                	push   $0x0
  803717:	51                   	push   %ecx
  803718:	52                   	push   %edx
  803719:	ff 75 0c             	pushl  0xc(%ebp)
  80371c:	50                   	push   %eax
  80371d:	6a 15                	push   $0x15
  80371f:	e8 e4 fd ff ff       	call   803508 <syscall>
  803724:	83 c4 18             	add    $0x18,%esp
}
  803727:	c9                   	leave  
  803728:	c3                   	ret    

00803729 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803729:	55                   	push   %ebp
  80372a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80372c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80372f:	8b 45 08             	mov    0x8(%ebp),%eax
  803732:	6a 00                	push   $0x0
  803734:	6a 00                	push   $0x0
  803736:	6a 00                	push   $0x0
  803738:	52                   	push   %edx
  803739:	50                   	push   %eax
  80373a:	6a 16                	push   $0x16
  80373c:	e8 c7 fd ff ff       	call   803508 <syscall>
  803741:	83 c4 18             	add    $0x18,%esp
}
  803744:	c9                   	leave  
  803745:	c3                   	ret    

00803746 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803746:	55                   	push   %ebp
  803747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803749:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80374c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	6a 00                	push   $0x0
  803754:	6a 00                	push   $0x0
  803756:	51                   	push   %ecx
  803757:	52                   	push   %edx
  803758:	50                   	push   %eax
  803759:	6a 17                	push   $0x17
  80375b:	e8 a8 fd ff ff       	call   803508 <syscall>
  803760:	83 c4 18             	add    $0x18,%esp
}
  803763:	c9                   	leave  
  803764:	c3                   	ret    

00803765 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803765:	55                   	push   %ebp
  803766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80376b:	8b 45 08             	mov    0x8(%ebp),%eax
  80376e:	6a 00                	push   $0x0
  803770:	6a 00                	push   $0x0
  803772:	6a 00                	push   $0x0
  803774:	52                   	push   %edx
  803775:	50                   	push   %eax
  803776:	6a 18                	push   $0x18
  803778:	e8 8b fd ff ff       	call   803508 <syscall>
  80377d:	83 c4 18             	add    $0x18,%esp
}
  803780:	c9                   	leave  
  803781:	c3                   	ret    

00803782 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803782:	55                   	push   %ebp
  803783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	6a 00                	push   $0x0
  80378a:	ff 75 14             	pushl  0x14(%ebp)
  80378d:	ff 75 10             	pushl  0x10(%ebp)
  803790:	ff 75 0c             	pushl  0xc(%ebp)
  803793:	50                   	push   %eax
  803794:	6a 19                	push   $0x19
  803796:	e8 6d fd ff ff       	call   803508 <syscall>
  80379b:	83 c4 18             	add    $0x18,%esp
}
  80379e:	c9                   	leave  
  80379f:	c3                   	ret    

008037a0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8037a0:	55                   	push   %ebp
  8037a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8037a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a6:	6a 00                	push   $0x0
  8037a8:	6a 00                	push   $0x0
  8037aa:	6a 00                	push   $0x0
  8037ac:	6a 00                	push   $0x0
  8037ae:	50                   	push   %eax
  8037af:	6a 1a                	push   $0x1a
  8037b1:	e8 52 fd ff ff       	call   803508 <syscall>
  8037b6:	83 c4 18             	add    $0x18,%esp
}
  8037b9:	90                   	nop
  8037ba:	c9                   	leave  
  8037bb:	c3                   	ret    

008037bc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8037bc:	55                   	push   %ebp
  8037bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8037bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c2:	6a 00                	push   $0x0
  8037c4:	6a 00                	push   $0x0
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	50                   	push   %eax
  8037cb:	6a 1b                	push   $0x1b
  8037cd:	e8 36 fd ff ff       	call   803508 <syscall>
  8037d2:	83 c4 18             	add    $0x18,%esp
}
  8037d5:	c9                   	leave  
  8037d6:	c3                   	ret    

008037d7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8037d7:	55                   	push   %ebp
  8037d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8037da:	6a 00                	push   $0x0
  8037dc:	6a 00                	push   $0x0
  8037de:	6a 00                	push   $0x0
  8037e0:	6a 00                	push   $0x0
  8037e2:	6a 00                	push   $0x0
  8037e4:	6a 05                	push   $0x5
  8037e6:	e8 1d fd ff ff       	call   803508 <syscall>
  8037eb:	83 c4 18             	add    $0x18,%esp
}
  8037ee:	c9                   	leave  
  8037ef:	c3                   	ret    

008037f0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8037f0:	55                   	push   %ebp
  8037f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8037f3:	6a 00                	push   $0x0
  8037f5:	6a 00                	push   $0x0
  8037f7:	6a 00                	push   $0x0
  8037f9:	6a 00                	push   $0x0
  8037fb:	6a 00                	push   $0x0
  8037fd:	6a 06                	push   $0x6
  8037ff:	e8 04 fd ff ff       	call   803508 <syscall>
  803804:	83 c4 18             	add    $0x18,%esp
}
  803807:	c9                   	leave  
  803808:	c3                   	ret    

00803809 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803809:	55                   	push   %ebp
  80380a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80380c:	6a 00                	push   $0x0
  80380e:	6a 00                	push   $0x0
  803810:	6a 00                	push   $0x0
  803812:	6a 00                	push   $0x0
  803814:	6a 00                	push   $0x0
  803816:	6a 07                	push   $0x7
  803818:	e8 eb fc ff ff       	call   803508 <syscall>
  80381d:	83 c4 18             	add    $0x18,%esp
}
  803820:	c9                   	leave  
  803821:	c3                   	ret    

00803822 <sys_exit_env>:


void sys_exit_env(void)
{
  803822:	55                   	push   %ebp
  803823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803825:	6a 00                	push   $0x0
  803827:	6a 00                	push   $0x0
  803829:	6a 00                	push   $0x0
  80382b:	6a 00                	push   $0x0
  80382d:	6a 00                	push   $0x0
  80382f:	6a 1c                	push   $0x1c
  803831:	e8 d2 fc ff ff       	call   803508 <syscall>
  803836:	83 c4 18             	add    $0x18,%esp
}
  803839:	90                   	nop
  80383a:	c9                   	leave  
  80383b:	c3                   	ret    

0080383c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80383c:	55                   	push   %ebp
  80383d:	89 e5                	mov    %esp,%ebp
  80383f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803842:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803845:	8d 50 04             	lea    0x4(%eax),%edx
  803848:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80384b:	6a 00                	push   $0x0
  80384d:	6a 00                	push   $0x0
  80384f:	6a 00                	push   $0x0
  803851:	52                   	push   %edx
  803852:	50                   	push   %eax
  803853:	6a 1d                	push   $0x1d
  803855:	e8 ae fc ff ff       	call   803508 <syscall>
  80385a:	83 c4 18             	add    $0x18,%esp
	return result;
  80385d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803863:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803866:	89 01                	mov    %eax,(%ecx)
  803868:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	c9                   	leave  
  80386f:	c2 04 00             	ret    $0x4

00803872 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803872:	55                   	push   %ebp
  803873:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803875:	6a 00                	push   $0x0
  803877:	6a 00                	push   $0x0
  803879:	ff 75 10             	pushl  0x10(%ebp)
  80387c:	ff 75 0c             	pushl  0xc(%ebp)
  80387f:	ff 75 08             	pushl  0x8(%ebp)
  803882:	6a 13                	push   $0x13
  803884:	e8 7f fc ff ff       	call   803508 <syscall>
  803889:	83 c4 18             	add    $0x18,%esp
	return ;
  80388c:	90                   	nop
}
  80388d:	c9                   	leave  
  80388e:	c3                   	ret    

0080388f <sys_rcr2>:
uint32 sys_rcr2()
{
  80388f:	55                   	push   %ebp
  803890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803892:	6a 00                	push   $0x0
  803894:	6a 00                	push   $0x0
  803896:	6a 00                	push   $0x0
  803898:	6a 00                	push   $0x0
  80389a:	6a 00                	push   $0x0
  80389c:	6a 1e                	push   $0x1e
  80389e:	e8 65 fc ff ff       	call   803508 <syscall>
  8038a3:	83 c4 18             	add    $0x18,%esp
}
  8038a6:	c9                   	leave  
  8038a7:	c3                   	ret    

008038a8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8038a8:	55                   	push   %ebp
  8038a9:	89 e5                	mov    %esp,%ebp
  8038ab:	83 ec 04             	sub    $0x4,%esp
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8038b4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8038b8:	6a 00                	push   $0x0
  8038ba:	6a 00                	push   $0x0
  8038bc:	6a 00                	push   $0x0
  8038be:	6a 00                	push   $0x0
  8038c0:	50                   	push   %eax
  8038c1:	6a 1f                	push   $0x1f
  8038c3:	e8 40 fc ff ff       	call   803508 <syscall>
  8038c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8038cb:	90                   	nop
}
  8038cc:	c9                   	leave  
  8038cd:	c3                   	ret    

008038ce <rsttst>:
void rsttst()
{
  8038ce:	55                   	push   %ebp
  8038cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8038d1:	6a 00                	push   $0x0
  8038d3:	6a 00                	push   $0x0
  8038d5:	6a 00                	push   $0x0
  8038d7:	6a 00                	push   $0x0
  8038d9:	6a 00                	push   $0x0
  8038db:	6a 21                	push   $0x21
  8038dd:	e8 26 fc ff ff       	call   803508 <syscall>
  8038e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8038e5:	90                   	nop
}
  8038e6:	c9                   	leave  
  8038e7:	c3                   	ret    

008038e8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8038e8:	55                   	push   %ebp
  8038e9:	89 e5                	mov    %esp,%ebp
  8038eb:	83 ec 04             	sub    $0x4,%esp
  8038ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8038f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8038f4:	8b 55 18             	mov    0x18(%ebp),%edx
  8038f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8038fb:	52                   	push   %edx
  8038fc:	50                   	push   %eax
  8038fd:	ff 75 10             	pushl  0x10(%ebp)
  803900:	ff 75 0c             	pushl  0xc(%ebp)
  803903:	ff 75 08             	pushl  0x8(%ebp)
  803906:	6a 20                	push   $0x20
  803908:	e8 fb fb ff ff       	call   803508 <syscall>
  80390d:	83 c4 18             	add    $0x18,%esp
	return ;
  803910:	90                   	nop
}
  803911:	c9                   	leave  
  803912:	c3                   	ret    

00803913 <chktst>:
void chktst(uint32 n)
{
  803913:	55                   	push   %ebp
  803914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803916:	6a 00                	push   $0x0
  803918:	6a 00                	push   $0x0
  80391a:	6a 00                	push   $0x0
  80391c:	6a 00                	push   $0x0
  80391e:	ff 75 08             	pushl  0x8(%ebp)
  803921:	6a 22                	push   $0x22
  803923:	e8 e0 fb ff ff       	call   803508 <syscall>
  803928:	83 c4 18             	add    $0x18,%esp
	return ;
  80392b:	90                   	nop
}
  80392c:	c9                   	leave  
  80392d:	c3                   	ret    

0080392e <inctst>:

void inctst()
{
  80392e:	55                   	push   %ebp
  80392f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803931:	6a 00                	push   $0x0
  803933:	6a 00                	push   $0x0
  803935:	6a 00                	push   $0x0
  803937:	6a 00                	push   $0x0
  803939:	6a 00                	push   $0x0
  80393b:	6a 23                	push   $0x23
  80393d:	e8 c6 fb ff ff       	call   803508 <syscall>
  803942:	83 c4 18             	add    $0x18,%esp
	return ;
  803945:	90                   	nop
}
  803946:	c9                   	leave  
  803947:	c3                   	ret    

00803948 <gettst>:
uint32 gettst()
{
  803948:	55                   	push   %ebp
  803949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80394b:	6a 00                	push   $0x0
  80394d:	6a 00                	push   $0x0
  80394f:	6a 00                	push   $0x0
  803951:	6a 00                	push   $0x0
  803953:	6a 00                	push   $0x0
  803955:	6a 24                	push   $0x24
  803957:	e8 ac fb ff ff       	call   803508 <syscall>
  80395c:	83 c4 18             	add    $0x18,%esp
}
  80395f:	c9                   	leave  
  803960:	c3                   	ret    

00803961 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803961:	55                   	push   %ebp
  803962:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803964:	6a 00                	push   $0x0
  803966:	6a 00                	push   $0x0
  803968:	6a 00                	push   $0x0
  80396a:	6a 00                	push   $0x0
  80396c:	6a 00                	push   $0x0
  80396e:	6a 25                	push   $0x25
  803970:	e8 93 fb ff ff       	call   803508 <syscall>
  803975:	83 c4 18             	add    $0x18,%esp
  803978:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  80397d:	a1 80 60 83 00       	mov    0x836080,%eax
}
  803982:	c9                   	leave  
  803983:	c3                   	ret    

00803984 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803984:	55                   	push   %ebp
  803985:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803987:	8b 45 08             	mov    0x8(%ebp),%eax
  80398a:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80398f:	6a 00                	push   $0x0
  803991:	6a 00                	push   $0x0
  803993:	6a 00                	push   $0x0
  803995:	6a 00                	push   $0x0
  803997:	ff 75 08             	pushl  0x8(%ebp)
  80399a:	6a 26                	push   $0x26
  80399c:	e8 67 fb ff ff       	call   803508 <syscall>
  8039a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8039a4:	90                   	nop
}
  8039a5:	c9                   	leave  
  8039a6:	c3                   	ret    

008039a7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8039a7:	55                   	push   %ebp
  8039a8:	89 e5                	mov    %esp,%ebp
  8039aa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8039ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8039ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8039b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b7:	6a 00                	push   $0x0
  8039b9:	53                   	push   %ebx
  8039ba:	51                   	push   %ecx
  8039bb:	52                   	push   %edx
  8039bc:	50                   	push   %eax
  8039bd:	6a 27                	push   $0x27
  8039bf:	e8 44 fb ff ff       	call   803508 <syscall>
  8039c4:	83 c4 18             	add    $0x18,%esp
}
  8039c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039ca:	c9                   	leave  
  8039cb:	c3                   	ret    

008039cc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8039cc:	55                   	push   %ebp
  8039cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8039cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d5:	6a 00                	push   $0x0
  8039d7:	6a 00                	push   $0x0
  8039d9:	6a 00                	push   $0x0
  8039db:	52                   	push   %edx
  8039dc:	50                   	push   %eax
  8039dd:	6a 28                	push   $0x28
  8039df:	e8 24 fb ff ff       	call   803508 <syscall>
  8039e4:	83 c4 18             	add    $0x18,%esp
}
  8039e7:	c9                   	leave  
  8039e8:	c3                   	ret    

008039e9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8039e9:	55                   	push   %ebp
  8039ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8039ec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8039ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	6a 00                	push   $0x0
  8039f7:	51                   	push   %ecx
  8039f8:	ff 75 10             	pushl  0x10(%ebp)
  8039fb:	52                   	push   %edx
  8039fc:	50                   	push   %eax
  8039fd:	6a 29                	push   $0x29
  8039ff:	e8 04 fb ff ff       	call   803508 <syscall>
  803a04:	83 c4 18             	add    $0x18,%esp
}
  803a07:	c9                   	leave  
  803a08:	c3                   	ret    

00803a09 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803a09:	55                   	push   %ebp
  803a0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803a0c:	6a 00                	push   $0x0
  803a0e:	6a 00                	push   $0x0
  803a10:	ff 75 10             	pushl  0x10(%ebp)
  803a13:	ff 75 0c             	pushl  0xc(%ebp)
  803a16:	ff 75 08             	pushl  0x8(%ebp)
  803a19:	6a 12                	push   $0x12
  803a1b:	e8 e8 fa ff ff       	call   803508 <syscall>
  803a20:	83 c4 18             	add    $0x18,%esp
	return ;
  803a23:	90                   	nop
}
  803a24:	c9                   	leave  
  803a25:	c3                   	ret    

00803a26 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803a26:	55                   	push   %ebp
  803a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2f:	6a 00                	push   $0x0
  803a31:	6a 00                	push   $0x0
  803a33:	6a 00                	push   $0x0
  803a35:	52                   	push   %edx
  803a36:	50                   	push   %eax
  803a37:	6a 2a                	push   $0x2a
  803a39:	e8 ca fa ff ff       	call   803508 <syscall>
  803a3e:	83 c4 18             	add    $0x18,%esp
	return;
  803a41:	90                   	nop
}
  803a42:	c9                   	leave  
  803a43:	c3                   	ret    

00803a44 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803a44:	55                   	push   %ebp
  803a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803a47:	6a 00                	push   $0x0
  803a49:	6a 00                	push   $0x0
  803a4b:	6a 00                	push   $0x0
  803a4d:	6a 00                	push   $0x0
  803a4f:	6a 00                	push   $0x0
  803a51:	6a 2b                	push   $0x2b
  803a53:	e8 b0 fa ff ff       	call   803508 <syscall>
  803a58:	83 c4 18             	add    $0x18,%esp
}
  803a5b:	c9                   	leave  
  803a5c:	c3                   	ret    

00803a5d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803a5d:	55                   	push   %ebp
  803a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803a60:	6a 00                	push   $0x0
  803a62:	6a 00                	push   $0x0
  803a64:	6a 00                	push   $0x0
  803a66:	ff 75 0c             	pushl  0xc(%ebp)
  803a69:	ff 75 08             	pushl  0x8(%ebp)
  803a6c:	6a 2d                	push   $0x2d
  803a6e:	e8 95 fa ff ff       	call   803508 <syscall>
  803a73:	83 c4 18             	add    $0x18,%esp
	return;
  803a76:	90                   	nop
}
  803a77:	c9                   	leave  
  803a78:	c3                   	ret    

00803a79 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803a79:	55                   	push   %ebp
  803a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803a7c:	6a 00                	push   $0x0
  803a7e:	6a 00                	push   $0x0
  803a80:	6a 00                	push   $0x0
  803a82:	ff 75 0c             	pushl  0xc(%ebp)
  803a85:	ff 75 08             	pushl  0x8(%ebp)
  803a88:	6a 2c                	push   $0x2c
  803a8a:	e8 79 fa ff ff       	call   803508 <syscall>
  803a8f:	83 c4 18             	add    $0x18,%esp
	return ;
  803a92:	90                   	nop
}
  803a93:	c9                   	leave  
  803a94:	c3                   	ret    

00803a95 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803a95:	55                   	push   %ebp
  803a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9e:	6a 00                	push   $0x0
  803aa0:	6a 00                	push   $0x0
  803aa2:	6a 00                	push   $0x0
  803aa4:	52                   	push   %edx
  803aa5:	50                   	push   %eax
  803aa6:	6a 2e                	push   $0x2e
  803aa8:	e8 5b fa ff ff       	call   803508 <syscall>
  803aad:	83 c4 18             	add    $0x18,%esp
}
  803ab0:	90                   	nop
  803ab1:	c9                   	leave  
  803ab2:	c3                   	ret    

00803ab3 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803ab3:	55                   	push   %ebp
  803ab4:	89 e5                	mov    %esp,%ebp
  803ab6:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803ab9:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803ac0:	72 09                	jb     803acb <to_page_va+0x18>
  803ac2:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803ac9:	72 14                	jb     803adf <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803acb:	83 ec 04             	sub    $0x4,%esp
  803ace:	68 ac 50 80 00       	push   $0x8050ac
  803ad3:	6a 15                	push   $0x15
  803ad5:	68 d7 50 80 00       	push   $0x8050d7
  803ada:	e8 08 ce ff ff       	call   8008e7 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803adf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae2:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803ae7:	29 d0                	sub    %edx,%eax
  803ae9:	c1 f8 02             	sar    $0x2,%eax
  803aec:	89 c2                	mov    %eax,%edx
  803aee:	89 d0                	mov    %edx,%eax
  803af0:	c1 e0 02             	shl    $0x2,%eax
  803af3:	01 d0                	add    %edx,%eax
  803af5:	c1 e0 02             	shl    $0x2,%eax
  803af8:	01 d0                	add    %edx,%eax
  803afa:	c1 e0 02             	shl    $0x2,%eax
  803afd:	01 d0                	add    %edx,%eax
  803aff:	89 c1                	mov    %eax,%ecx
  803b01:	c1 e1 08             	shl    $0x8,%ecx
  803b04:	01 c8                	add    %ecx,%eax
  803b06:	89 c1                	mov    %eax,%ecx
  803b08:	c1 e1 10             	shl    $0x10,%ecx
  803b0b:	01 c8                	add    %ecx,%eax
  803b0d:	01 c0                	add    %eax,%eax
  803b0f:	01 d0                	add    %edx,%eax
  803b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b17:	c1 e0 0c             	shl    $0xc,%eax
  803b1a:	89 c2                	mov    %eax,%edx
  803b1c:	a1 84 60 83 00       	mov    0x836084,%eax
  803b21:	01 d0                	add    %edx,%eax
}
  803b23:	c9                   	leave  
  803b24:	c3                   	ret    

00803b25 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803b25:	55                   	push   %ebp
  803b26:	89 e5                	mov    %esp,%ebp
  803b28:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803b2b:	a1 84 60 83 00       	mov    0x836084,%eax
  803b30:	8b 55 08             	mov    0x8(%ebp),%edx
  803b33:	29 c2                	sub    %eax,%edx
  803b35:	89 d0                	mov    %edx,%eax
  803b37:	c1 e8 0c             	shr    $0xc,%eax
  803b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b41:	78 09                	js     803b4c <to_page_info+0x27>
  803b43:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803b4a:	7e 14                	jle    803b60 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803b4c:	83 ec 04             	sub    $0x4,%esp
  803b4f:	68 f0 50 80 00       	push   $0x8050f0
  803b54:	6a 21                	push   $0x21
  803b56:	68 d7 50 80 00       	push   $0x8050d7
  803b5b:	e8 87 cd ff ff       	call   8008e7 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b63:	89 d0                	mov    %edx,%eax
  803b65:	01 c0                	add    %eax,%eax
  803b67:	01 d0                	add    %edx,%eax
  803b69:	c1 e0 02             	shl    $0x2,%eax
  803b6c:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803b71:	c9                   	leave  
  803b72:	c3                   	ret    

00803b73 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803b73:	55                   	push   %ebp
  803b74:	89 e5                	mov    %esp,%ebp
  803b76:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803b79:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7c:	05 00 00 00 02       	add    $0x2000000,%eax
  803b81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b84:	73 16                	jae    803b9c <initialize_dynamic_allocator+0x29>
  803b86:	68 14 51 80 00       	push   $0x805114
  803b8b:	68 3a 51 80 00       	push   $0x80513a
  803b90:	6a 2f                	push   $0x2f
  803b92:	68 d7 50 80 00       	push   $0x8050d7
  803b97:	e8 4b cd ff ff       	call   8008e7 <_panic>
	dynAllocStart = daStart;
  803b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9f:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ba7:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803bac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803bb3:	eb 36                	jmp    803beb <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb8:	c1 e0 04             	shl    $0x4,%eax
  803bbb:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803bc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc9:	c1 e0 04             	shl    $0x4,%eax
  803bcc:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803bd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bda:	c1 e0 04             	shl    $0x4,%eax
  803bdd:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803be2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803be8:	ff 45 f4             	incl   -0xc(%ebp)
  803beb:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803bef:	7e c4                	jle    803bb5 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803bf1:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803bf8:	00 00 00 
  803bfb:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803c02:	00 00 00 
  803c05:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803c0c:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803c16:	e9 1b 01 00 00       	jmp    803d36 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803c1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c1e:	89 d0                	mov    %edx,%eax
  803c20:	01 c0                	add    %eax,%eax
  803c22:	01 d0                	add    %edx,%eax
  803c24:	c1 e0 02             	shl    $0x2,%eax
  803c27:	05 88 e0 81 00       	add    $0x81e088,%eax
  803c2c:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803c31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c34:	89 d0                	mov    %edx,%eax
  803c36:	01 c0                	add    %eax,%eax
  803c38:	01 d0                	add    %edx,%eax
  803c3a:	c1 e0 02             	shl    $0x2,%eax
  803c3d:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803c42:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803c47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c4a:	89 d0                	mov    %edx,%eax
  803c4c:	01 c0                	add    %eax,%eax
  803c4e:	01 d0                	add    %edx,%eax
  803c50:	c1 e0 02             	shl    $0x2,%eax
  803c53:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c58:	8b 00                	mov    (%eax),%eax
  803c5a:	85 c0                	test   %eax,%eax
  803c5c:	74 2b                	je     803c89 <initialize_dynamic_allocator+0x116>
  803c5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c61:	89 d0                	mov    %edx,%eax
  803c63:	01 c0                	add    %eax,%eax
  803c65:	01 d0                	add    %edx,%eax
  803c67:	c1 e0 02             	shl    $0x2,%eax
  803c6a:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c6f:	8b 10                	mov    (%eax),%edx
  803c71:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803c74:	89 c8                	mov    %ecx,%eax
  803c76:	01 c0                	add    %eax,%eax
  803c78:	01 c8                	add    %ecx,%eax
  803c7a:	c1 e0 02             	shl    $0x2,%eax
  803c7d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c82:	8b 00                	mov    (%eax),%eax
  803c84:	89 42 04             	mov    %eax,0x4(%edx)
  803c87:	eb 18                	jmp    803ca1 <initialize_dynamic_allocator+0x12e>
  803c89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c8c:	89 d0                	mov    %edx,%eax
  803c8e:	01 c0                	add    %eax,%eax
  803c90:	01 d0                	add    %edx,%eax
  803c92:	c1 e0 02             	shl    $0x2,%eax
  803c95:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c9a:	8b 00                	mov    (%eax),%eax
  803c9c:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803ca1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ca4:	89 d0                	mov    %edx,%eax
  803ca6:	01 c0                	add    %eax,%eax
  803ca8:	01 d0                	add    %edx,%eax
  803caa:	c1 e0 02             	shl    $0x2,%eax
  803cad:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cb2:	8b 00                	mov    (%eax),%eax
  803cb4:	85 c0                	test   %eax,%eax
  803cb6:	74 2a                	je     803ce2 <initialize_dynamic_allocator+0x16f>
  803cb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cbb:	89 d0                	mov    %edx,%eax
  803cbd:	01 c0                	add    %eax,%eax
  803cbf:	01 d0                	add    %edx,%eax
  803cc1:	c1 e0 02             	shl    $0x2,%eax
  803cc4:	05 84 e0 81 00       	add    $0x81e084,%eax
  803cc9:	8b 10                	mov    (%eax),%edx
  803ccb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803cce:	89 c8                	mov    %ecx,%eax
  803cd0:	01 c0                	add    %eax,%eax
  803cd2:	01 c8                	add    %ecx,%eax
  803cd4:	c1 e0 02             	shl    $0x2,%eax
  803cd7:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cdc:	8b 00                	mov    (%eax),%eax
  803cde:	89 02                	mov    %eax,(%edx)
  803ce0:	eb 18                	jmp    803cfa <initialize_dynamic_allocator+0x187>
  803ce2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ce5:	89 d0                	mov    %edx,%eax
  803ce7:	01 c0                	add    %eax,%eax
  803ce9:	01 d0                	add    %edx,%eax
  803ceb:	c1 e0 02             	shl    $0x2,%eax
  803cee:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cf3:	8b 00                	mov    (%eax),%eax
  803cf5:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803cfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cfd:	89 d0                	mov    %edx,%eax
  803cff:	01 c0                	add    %eax,%eax
  803d01:	01 d0                	add    %edx,%eax
  803d03:	c1 e0 02             	shl    $0x2,%eax
  803d06:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d14:	89 d0                	mov    %edx,%eax
  803d16:	01 c0                	add    %eax,%eax
  803d18:	01 d0                	add    %edx,%eax
  803d1a:	c1 e0 02             	shl    $0x2,%eax
  803d1d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d28:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803d2d:	48                   	dec    %eax
  803d2e:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803d33:	ff 45 f0             	incl   -0x10(%ebp)
  803d36:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803d3d:	0f 8e d8 fe ff ff    	jle    803c1b <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803d43:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803d4a:	e9 9d 00 00 00       	jmp    803dec <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803d4f:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803d55:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803d58:	89 c8                	mov    %ecx,%eax
  803d5a:	01 c0                	add    %eax,%eax
  803d5c:	01 c8                	add    %ecx,%eax
  803d5e:	c1 e0 02             	shl    $0x2,%eax
  803d61:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d66:	89 10                	mov    %edx,(%eax)
  803d68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d6b:	89 d0                	mov    %edx,%eax
  803d6d:	01 c0                	add    %eax,%eax
  803d6f:	01 d0                	add    %edx,%eax
  803d71:	c1 e0 02             	shl    $0x2,%eax
  803d74:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d79:	8b 00                	mov    (%eax),%eax
  803d7b:	85 c0                	test   %eax,%eax
  803d7d:	74 1c                	je     803d9b <initialize_dynamic_allocator+0x228>
  803d7f:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803d85:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803d88:	89 c8                	mov    %ecx,%eax
  803d8a:	01 c0                	add    %eax,%eax
  803d8c:	01 c8                	add    %ecx,%eax
  803d8e:	c1 e0 02             	shl    $0x2,%eax
  803d91:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d96:	89 42 04             	mov    %eax,0x4(%edx)
  803d99:	eb 16                	jmp    803db1 <initialize_dynamic_allocator+0x23e>
  803d9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d9e:	89 d0                	mov    %edx,%eax
  803da0:	01 c0                	add    %eax,%eax
  803da2:	01 d0                	add    %edx,%eax
  803da4:	c1 e0 02             	shl    $0x2,%eax
  803da7:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dac:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803db1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803db4:	89 d0                	mov    %edx,%eax
  803db6:	01 c0                	add    %eax,%eax
  803db8:	01 d0                	add    %edx,%eax
  803dba:	c1 e0 02             	shl    $0x2,%eax
  803dbd:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dc2:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803dc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dca:	89 d0                	mov    %edx,%eax
  803dcc:	01 c0                	add    %eax,%eax
  803dce:	01 d0                	add    %edx,%eax
  803dd0:	c1 e0 02             	shl    $0x2,%eax
  803dd3:	05 84 e0 81 00       	add    $0x81e084,%eax
  803dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dde:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803de3:	40                   	inc    %eax
  803de4:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803de9:	ff 4d ec             	decl   -0x14(%ebp)
  803dec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803df0:	0f 89 59 ff ff ff    	jns    803d4f <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803df6:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803dfd:	00 00 00 
}
  803e00:	90                   	nop
  803e01:	c9                   	leave  
  803e02:	c3                   	ret    

00803e03 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803e03:	55                   	push   %ebp
  803e04:	89 e5                	mov    %esp,%ebp
  803e06:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803e09:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0c:	83 ec 0c             	sub    $0xc,%esp
  803e0f:	50                   	push   %eax
  803e10:	e8 10 fd ff ff       	call   803b25 <to_page_info>
  803e15:	83 c4 10             	add    $0x10,%esp
  803e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1e:	8b 40 08             	mov    0x8(%eax),%eax
  803e21:	0f b7 c0             	movzwl %ax,%eax
}
  803e24:	c9                   	leave  
  803e25:	c3                   	ret    

00803e26 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803e26:	55                   	push   %ebp
  803e27:	89 e5                	mov    %esp,%ebp
  803e29:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803e2c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803e33:	76 16                	jbe    803e4b <alloc_block+0x25>
  803e35:	68 50 51 80 00       	push   $0x805150
  803e3a:	68 3a 51 80 00       	push   $0x80513a
  803e3f:	6a 59                	push   $0x59
  803e41:	68 d7 50 80 00       	push   $0x8050d7
  803e46:	e8 9c ca ff ff       	call   8008e7 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803e4b:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803e52:	eb 08                	jmp    803e5c <alloc_block+0x36>
		allocSize <<= 1;
  803e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e57:	01 c0                	add    %eax,%eax
  803e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e62:	73 09                	jae    803e6d <alloc_block+0x47>
  803e64:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803e6b:	76 e7                	jbe    803e54 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803e6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803e74:	eb 03                	jmp    803e79 <alloc_block+0x53>
		listIndex++;
  803e76:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e7c:	ba 08 00 00 00       	mov    $0x8,%edx
  803e81:	88 c1                	mov    %al,%cl
  803e83:	d3 e2                	shl    %cl,%edx
  803e85:	89 d0                	mov    %edx,%eax
  803e87:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803e8a:	72 ea                	jb     803e76 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803e92:	e9 f4 00 00 00       	jmp    803f8b <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e9a:	c1 e0 04             	shl    $0x4,%eax
  803e9d:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ea2:	8b 00                	mov    (%eax),%eax
  803ea4:	85 c0                	test   %eax,%eax
  803ea6:	0f 84 dc 00 00 00    	je     803f88 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eaf:	c1 e0 04             	shl    $0x4,%eax
  803eb2:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803eb7:	8b 00                	mov    (%eax),%eax
  803eb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803ebc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ec0:	75 14                	jne    803ed6 <alloc_block+0xb0>
  803ec2:	83 ec 04             	sub    $0x4,%esp
  803ec5:	68 71 51 80 00       	push   $0x805171
  803eca:	6a 6b                	push   $0x6b
  803ecc:	68 d7 50 80 00       	push   $0x8050d7
  803ed1:	e8 11 ca ff ff       	call   8008e7 <_panic>
  803ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed9:	8b 00                	mov    (%eax),%eax
  803edb:	85 c0                	test   %eax,%eax
  803edd:	74 10                	je     803eef <alloc_block+0xc9>
  803edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee2:	8b 00                	mov    (%eax),%eax
  803ee4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ee7:	8b 52 04             	mov    0x4(%edx),%edx
  803eea:	89 50 04             	mov    %edx,0x4(%eax)
  803eed:	eb 14                	jmp    803f03 <alloc_block+0xdd>
  803eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef2:	8b 40 04             	mov    0x4(%eax),%eax
  803ef5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ef8:	c1 e2 04             	shl    $0x4,%edx
  803efb:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803f01:	89 02                	mov    %eax,(%edx)
  803f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f06:	8b 40 04             	mov    0x4(%eax),%eax
  803f09:	85 c0                	test   %eax,%eax
  803f0b:	74 0f                	je     803f1c <alloc_block+0xf6>
  803f0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f10:	8b 40 04             	mov    0x4(%eax),%eax
  803f13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f16:	8b 12                	mov    (%edx),%edx
  803f18:	89 10                	mov    %edx,(%eax)
  803f1a:	eb 13                	jmp    803f2f <alloc_block+0x109>
  803f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1f:	8b 00                	mov    (%eax),%eax
  803f21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f24:	c1 e2 04             	shl    $0x4,%edx
  803f27:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803f2d:	89 02                	mov    %eax,(%edx)
  803f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f45:	c1 e0 04             	shl    $0x4,%eax
  803f48:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f4d:	8b 00                	mov    (%eax),%eax
  803f4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f55:	c1 e0 04             	shl    $0x4,%eax
  803f58:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f5d:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803f5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f62:	83 ec 0c             	sub    $0xc,%esp
  803f65:	50                   	push   %eax
  803f66:	e8 ba fb ff ff       	call   803b25 <to_page_info>
  803f6b:	83 c4 10             	add    $0x10,%esp
  803f6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f74:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803f78:	48                   	dec    %eax
  803f79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f7c:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f83:	e9 8f 02 00 00       	jmp    804217 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803f88:	ff 45 ec             	incl   -0x14(%ebp)
  803f8b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803f8f:	0f 8e 02 ff ff ff    	jle    803e97 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803f95:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803f9a:	85 c0                	test   %eax,%eax
  803f9c:	75 14                	jne    803fb2 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803f9e:	83 ec 04             	sub    $0x4,%esp
  803fa1:	68 90 51 80 00       	push   $0x805190
  803fa6:	6a 77                	push   $0x77
  803fa8:	68 d7 50 80 00       	push   $0x8050d7
  803fad:	e8 35 c9 ff ff       	call   8008e7 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803fb2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803fb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803fba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803fbe:	75 14                	jne    803fd4 <alloc_block+0x1ae>
  803fc0:	83 ec 04             	sub    $0x4,%esp
  803fc3:	68 71 51 80 00       	push   $0x805171
  803fc8:	6a 7a                	push   $0x7a
  803fca:	68 d7 50 80 00       	push   $0x8050d7
  803fcf:	e8 13 c9 ff ff       	call   8008e7 <_panic>
  803fd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fd7:	8b 00                	mov    (%eax),%eax
  803fd9:	85 c0                	test   %eax,%eax
  803fdb:	74 10                	je     803fed <alloc_block+0x1c7>
  803fdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fe0:	8b 00                	mov    (%eax),%eax
  803fe2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803fe5:	8b 52 04             	mov    0x4(%edx),%edx
  803fe8:	89 50 04             	mov    %edx,0x4(%eax)
  803feb:	eb 0b                	jmp    803ff8 <alloc_block+0x1d2>
  803fed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ff0:	8b 40 04             	mov    0x4(%eax),%eax
  803ff3:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803ff8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ffb:	8b 40 04             	mov    0x4(%eax),%eax
  803ffe:	85 c0                	test   %eax,%eax
  804000:	74 0f                	je     804011 <alloc_block+0x1eb>
  804002:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804005:	8b 40 04             	mov    0x4(%eax),%eax
  804008:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80400b:	8b 12                	mov    (%edx),%edx
  80400d:	89 10                	mov    %edx,(%eax)
  80400f:	eb 0a                	jmp    80401b <alloc_block+0x1f5>
  804011:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804014:	8b 00                	mov    (%eax),%eax
  804016:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80401b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80401e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804024:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804027:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80402e:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804033:	48                   	dec    %eax
  804034:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  804039:	83 ec 0c             	sub    $0xc,%esp
  80403c:	ff 75 dc             	pushl  -0x24(%ebp)
  80403f:	e8 6f fa ff ff       	call   803ab3 <to_page_va>
  804044:	83 c4 10             	add    $0x10,%esp
  804047:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  80404a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80404d:	83 ec 0c             	sub    $0xc,%esp
  804050:	50                   	push   %eax
  804051:	e8 a0 dc ff ff       	call   801cf6 <get_page>
  804056:	83 c4 10             	add    $0x10,%esp
  804059:	85 c0                	test   %eax,%eax
  80405b:	74 14                	je     804071 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  80405d:	83 ec 04             	sub    $0x4,%esp
  804060:	68 b8 51 80 00       	push   $0x8051b8
  804065:	6a 7f                	push   $0x7f
  804067:	68 d7 50 80 00       	push   $0x8050d7
  80406c:	e8 76 c8 ff ff       	call   8008e7 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  804071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804074:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804077:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  80407b:	b8 00 10 00 00       	mov    $0x1000,%eax
  804080:	ba 00 00 00 00       	mov    $0x0,%edx
  804085:	f7 75 f4             	divl   -0xc(%ebp)
  804088:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80408b:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80408f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804096:	e9 a7 00 00 00       	jmp    804142 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  80409b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80409e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040a1:	01 d0                	add    %edx,%eax
  8040a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8040a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8040aa:	75 17                	jne    8040c3 <alloc_block+0x29d>
  8040ac:	83 ec 04             	sub    $0x4,%esp
  8040af:	68 e0 51 80 00       	push   $0x8051e0
  8040b4:	68 88 00 00 00       	push   $0x88
  8040b9:	68 d7 50 80 00       	push   $0x8050d7
  8040be:	e8 24 c8 ff ff       	call   8008e7 <_panic>
  8040c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040c6:	c1 e0 04             	shl    $0x4,%eax
  8040c9:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8040ce:	8b 10                	mov    (%eax),%edx
  8040d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040d3:	89 10                	mov    %edx,(%eax)
  8040d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8040d8:	8b 00                	mov    (%eax),%eax
  8040da:	85 c0                	test   %eax,%eax
  8040dc:	74 15                	je     8040f3 <alloc_block+0x2cd>
  8040de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040e1:	c1 e0 04             	shl    $0x4,%eax
  8040e4:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8040e9:	8b 00                	mov    (%eax),%eax
  8040eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8040ee:	89 50 04             	mov    %edx,0x4(%eax)
  8040f1:	eb 11                	jmp    804104 <alloc_block+0x2de>
  8040f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040f6:	c1 e0 04             	shl    $0x4,%eax
  8040f9:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8040ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804102:	89 02                	mov    %eax,(%edx)
  804104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804107:	c1 e0 04             	shl    $0x4,%eax
  80410a:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  804110:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804113:	89 02                	mov    %eax,(%edx)
  804115:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804118:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80411f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804122:	c1 e0 04             	shl    $0x4,%eax
  804125:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80412a:	8b 00                	mov    (%eax),%eax
  80412c:	8d 50 01             	lea    0x1(%eax),%edx
  80412f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804132:	c1 e0 04             	shl    $0x4,%eax
  804135:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80413a:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80413c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80413f:	01 45 e8             	add    %eax,-0x18(%ebp)
  804142:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  804149:	0f 86 4c ff ff ff    	jbe    80409b <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  80414f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804152:	c1 e0 04             	shl    $0x4,%eax
  804155:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80415a:	8b 00                	mov    (%eax),%eax
  80415c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  80415f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804163:	75 17                	jne    80417c <alloc_block+0x356>
  804165:	83 ec 04             	sub    $0x4,%esp
  804168:	68 71 51 80 00       	push   $0x805171
  80416d:	68 8d 00 00 00       	push   $0x8d
  804172:	68 d7 50 80 00       	push   $0x8050d7
  804177:	e8 6b c7 ff ff       	call   8008e7 <_panic>
  80417c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80417f:	8b 00                	mov    (%eax),%eax
  804181:	85 c0                	test   %eax,%eax
  804183:	74 10                	je     804195 <alloc_block+0x36f>
  804185:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804188:	8b 00                	mov    (%eax),%eax
  80418a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80418d:	8b 52 04             	mov    0x4(%edx),%edx
  804190:	89 50 04             	mov    %edx,0x4(%eax)
  804193:	eb 14                	jmp    8041a9 <alloc_block+0x383>
  804195:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804198:	8b 40 04             	mov    0x4(%eax),%eax
  80419b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80419e:	c1 e2 04             	shl    $0x4,%edx
  8041a1:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  8041a7:	89 02                	mov    %eax,(%edx)
  8041a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041ac:	8b 40 04             	mov    0x4(%eax),%eax
  8041af:	85 c0                	test   %eax,%eax
  8041b1:	74 0f                	je     8041c2 <alloc_block+0x39c>
  8041b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041b6:	8b 40 04             	mov    0x4(%eax),%eax
  8041b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8041bc:	8b 12                	mov    (%edx),%edx
  8041be:	89 10                	mov    %edx,(%eax)
  8041c0:	eb 13                	jmp    8041d5 <alloc_block+0x3af>
  8041c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041c5:	8b 00                	mov    (%eax),%eax
  8041c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041ca:	c1 e2 04             	shl    $0x4,%edx
  8041cd:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8041d3:	89 02                	mov    %eax,(%edx)
  8041d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041eb:	c1 e0 04             	shl    $0x4,%eax
  8041ee:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041f3:	8b 00                	mov    (%eax),%eax
  8041f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8041f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041fb:	c1 e0 04             	shl    $0x4,%eax
  8041fe:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804203:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  804205:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804208:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80420c:	48                   	dec    %eax
  80420d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804210:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  804214:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804217:	c9                   	leave  
  804218:	c3                   	ret    

00804219 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804219:	55                   	push   %ebp
  80421a:	89 e5                	mov    %esp,%ebp
  80421c:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80421f:	8b 55 08             	mov    0x8(%ebp),%edx
  804222:	a1 84 60 83 00       	mov    0x836084,%eax
  804227:	39 c2                	cmp    %eax,%edx
  804229:	72 0c                	jb     804237 <free_block+0x1e>
  80422b:	8b 55 08             	mov    0x8(%ebp),%edx
  80422e:	a1 60 e0 81 00       	mov    0x81e060,%eax
  804233:	39 c2                	cmp    %eax,%edx
  804235:	72 19                	jb     804250 <free_block+0x37>
  804237:	68 04 52 80 00       	push   $0x805204
  80423c:	68 3a 51 80 00       	push   $0x80513a
  804241:	68 98 00 00 00       	push   $0x98
  804246:	68 d7 50 80 00       	push   $0x8050d7
  80424b:	e8 97 c6 ff ff       	call   8008e7 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804250:	8b 45 08             	mov    0x8(%ebp),%eax
  804253:	83 ec 0c             	sub    $0xc,%esp
  804256:	50                   	push   %eax
  804257:	e8 c9 f8 ff ff       	call   803b25 <to_page_info>
  80425c:	83 c4 10             	add    $0x10,%esp
  80425f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804265:	8b 40 08             	mov    0x8(%eax),%eax
  804268:	0f b7 c0             	movzwl %ax,%eax
  80426b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  80426e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804275:	eb 03                	jmp    80427a <free_block+0x61>
		listIndex++;
  804277:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  80427a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80427d:	ba 08 00 00 00       	mov    $0x8,%edx
  804282:	88 c1                	mov    %al,%cl
  804284:	d3 e2                	shl    %cl,%edx
  804286:	89 d0                	mov    %edx,%eax
  804288:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80428b:	72 ea                	jb     804277 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  80428d:	8b 45 08             	mov    0x8(%ebp),%eax
  804290:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  804293:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804297:	75 17                	jne    8042b0 <free_block+0x97>
  804299:	83 ec 04             	sub    $0x4,%esp
  80429c:	68 e0 51 80 00       	push   $0x8051e0
  8042a1:	68 a2 00 00 00       	push   $0xa2
  8042a6:	68 d7 50 80 00       	push   $0x8050d7
  8042ab:	e8 37 c6 ff ff       	call   8008e7 <_panic>
  8042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b3:	c1 e0 04             	shl    $0x4,%eax
  8042b6:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8042bb:	8b 10                	mov    (%eax),%edx
  8042bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042c0:	89 10                	mov    %edx,(%eax)
  8042c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042c5:	8b 00                	mov    (%eax),%eax
  8042c7:	85 c0                	test   %eax,%eax
  8042c9:	74 15                	je     8042e0 <free_block+0xc7>
  8042cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ce:	c1 e0 04             	shl    $0x4,%eax
  8042d1:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8042d6:	8b 00                	mov    (%eax),%eax
  8042d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042db:	89 50 04             	mov    %edx,0x4(%eax)
  8042de:	eb 11                	jmp    8042f1 <free_block+0xd8>
  8042e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042e3:	c1 e0 04             	shl    $0x4,%eax
  8042e6:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8042ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042ef:	89 02                	mov    %eax,(%edx)
  8042f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f4:	c1 e0 04             	shl    $0x4,%eax
  8042f7:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8042fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804300:	89 02                	mov    %eax,(%edx)
  804302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804305:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80430c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80430f:	c1 e0 04             	shl    $0x4,%eax
  804312:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804317:	8b 00                	mov    (%eax),%eax
  804319:	8d 50 01             	lea    0x1(%eax),%edx
  80431c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80431f:	c1 e0 04             	shl    $0x4,%eax
  804322:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804327:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80432c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804330:	40                   	inc    %eax
  804331:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804334:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80433b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80433f:	0f b7 c8             	movzwl %ax,%ecx
  804342:	b8 00 10 00 00       	mov    $0x1000,%eax
  804347:	ba 00 00 00 00       	mov    $0x0,%edx
  80434c:	f7 75 e8             	divl   -0x18(%ebp)
  80434f:	39 c1                	cmp    %eax,%ecx
  804351:	0f 85 ed 01 00 00    	jne    804544 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80435a:	c1 e0 04             	shl    $0x4,%eax
  80435d:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804362:	8b 00                	mov    (%eax),%eax
  804364:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804367:	eb 2a                	jmp    804393 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  804369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80436c:	83 ec 0c             	sub    $0xc,%esp
  80436f:	50                   	push   %eax
  804370:	e8 b0 f7 ff ff       	call   803b25 <to_page_info>
  804375:	83 c4 10             	add    $0x10,%esp
  804378:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80437b:	75 06                	jne    804383 <free_block+0x16a>
				tmp = b;
  80437d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804380:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804386:	c1 e0 04             	shl    $0x4,%eax
  804389:	05 a8 60 83 00       	add    $0x8360a8,%eax
  80438e:	8b 00                	mov    (%eax),%eax
  804390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804393:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804397:	74 07                	je     8043a0 <free_block+0x187>
  804399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80439c:	8b 00                	mov    (%eax),%eax
  80439e:	eb 05                	jmp    8043a5 <free_block+0x18c>
  8043a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8043a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043a8:	c1 e2 04             	shl    $0x4,%edx
  8043ab:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  8043b1:	89 02                	mov    %eax,(%edx)
  8043b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b6:	c1 e0 04             	shl    $0x4,%eax
  8043b9:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8043be:	8b 00                	mov    (%eax),%eax
  8043c0:	85 c0                	test   %eax,%eax
  8043c2:	75 a5                	jne    804369 <free_block+0x150>
  8043c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8043c8:	75 9f                	jne    804369 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  8043ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043cd:	c1 e0 04             	shl    $0x4,%eax
  8043d0:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8043d5:	8b 00                	mov    (%eax),%eax
  8043d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  8043da:	e9 cc 00 00 00       	jmp    8044ab <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  8043df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043e2:	8b 00                	mov    (%eax),%eax
  8043e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  8043e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043ea:	83 ec 0c             	sub    $0xc,%esp
  8043ed:	50                   	push   %eax
  8043ee:	e8 32 f7 ff ff       	call   803b25 <to_page_info>
  8043f3:	83 c4 10             	add    $0x10,%esp
  8043f6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8043f9:	0f 85 a6 00 00 00    	jne    8044a5 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  8043ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804403:	75 17                	jne    80441c <free_block+0x203>
  804405:	83 ec 04             	sub    $0x4,%esp
  804408:	68 71 51 80 00       	push   $0x805171
  80440d:	68 b5 00 00 00       	push   $0xb5
  804412:	68 d7 50 80 00       	push   $0x8050d7
  804417:	e8 cb c4 ff ff       	call   8008e7 <_panic>
  80441c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80441f:	8b 00                	mov    (%eax),%eax
  804421:	85 c0                	test   %eax,%eax
  804423:	74 10                	je     804435 <free_block+0x21c>
  804425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804428:	8b 00                	mov    (%eax),%eax
  80442a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80442d:	8b 52 04             	mov    0x4(%edx),%edx
  804430:	89 50 04             	mov    %edx,0x4(%eax)
  804433:	eb 14                	jmp    804449 <free_block+0x230>
  804435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804438:	8b 40 04             	mov    0x4(%eax),%eax
  80443b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80443e:	c1 e2 04             	shl    $0x4,%edx
  804441:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804447:	89 02                	mov    %eax,(%edx)
  804449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80444c:	8b 40 04             	mov    0x4(%eax),%eax
  80444f:	85 c0                	test   %eax,%eax
  804451:	74 0f                	je     804462 <free_block+0x249>
  804453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804456:	8b 40 04             	mov    0x4(%eax),%eax
  804459:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80445c:	8b 12                	mov    (%edx),%edx
  80445e:	89 10                	mov    %edx,(%eax)
  804460:	eb 13                	jmp    804475 <free_block+0x25c>
  804462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804465:	8b 00                	mov    (%eax),%eax
  804467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80446a:	c1 e2 04             	shl    $0x4,%edx
  80446d:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804473:	89 02                	mov    %eax,(%edx)
  804475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804478:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80447e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804481:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80448b:	c1 e0 04             	shl    $0x4,%eax
  80448e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804493:	8b 00                	mov    (%eax),%eax
  804495:	8d 50 ff             	lea    -0x1(%eax),%edx
  804498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80449b:	c1 e0 04             	shl    $0x4,%eax
  80449e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8044a3:	89 10                	mov    %edx,(%eax)
			b = next;
  8044a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8044a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  8044ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044af:	0f 85 2a ff ff ff    	jne    8043df <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  8044b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044b8:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8044be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044c1:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  8044c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8044cb:	75 17                	jne    8044e4 <free_block+0x2cb>
  8044cd:	83 ec 04             	sub    $0x4,%esp
  8044d0:	68 e0 51 80 00       	push   $0x8051e0
  8044d5:	68 bc 00 00 00       	push   $0xbc
  8044da:	68 d7 50 80 00       	push   $0x8050d7
  8044df:	e8 03 c4 ff ff       	call   8008e7 <_panic>
  8044e4:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8044ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044ed:	89 10                	mov    %edx,(%eax)
  8044ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044f2:	8b 00                	mov    (%eax),%eax
  8044f4:	85 c0                	test   %eax,%eax
  8044f6:	74 0d                	je     804505 <free_block+0x2ec>
  8044f8:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8044fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804500:	89 50 04             	mov    %edx,0x4(%eax)
  804503:	eb 08                	jmp    80450d <free_block+0x2f4>
  804505:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804508:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  80450d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804510:	a3 68 e0 81 00       	mov    %eax,0x81e068
  804515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804518:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80451f:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804524:	40                   	inc    %eax
  804525:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  80452a:	83 ec 0c             	sub    $0xc,%esp
  80452d:	ff 75 ec             	pushl  -0x14(%ebp)
  804530:	e8 7e f5 ff ff       	call   803ab3 <to_page_va>
  804535:	83 c4 10             	add    $0x10,%esp
  804538:	83 ec 0c             	sub    $0xc,%esp
  80453b:	50                   	push   %eax
  80453c:	e8 fe d7 ff ff       	call   801d3f <return_page>
  804541:	83 c4 10             	add    $0x10,%esp
	}
}
  804544:	90                   	nop
  804545:	c9                   	leave  
  804546:	c3                   	ret    
  804547:	90                   	nop

00804548 <__udivdi3>:
  804548:	55                   	push   %ebp
  804549:	57                   	push   %edi
  80454a:	56                   	push   %esi
  80454b:	53                   	push   %ebx
  80454c:	83 ec 1c             	sub    $0x1c,%esp
  80454f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804553:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804557:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80455b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80455f:	89 ca                	mov    %ecx,%edx
  804561:	89 f8                	mov    %edi,%eax
  804563:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804567:	85 f6                	test   %esi,%esi
  804569:	75 2d                	jne    804598 <__udivdi3+0x50>
  80456b:	39 cf                	cmp    %ecx,%edi
  80456d:	77 65                	ja     8045d4 <__udivdi3+0x8c>
  80456f:	89 fd                	mov    %edi,%ebp
  804571:	85 ff                	test   %edi,%edi
  804573:	75 0b                	jne    804580 <__udivdi3+0x38>
  804575:	b8 01 00 00 00       	mov    $0x1,%eax
  80457a:	31 d2                	xor    %edx,%edx
  80457c:	f7 f7                	div    %edi
  80457e:	89 c5                	mov    %eax,%ebp
  804580:	31 d2                	xor    %edx,%edx
  804582:	89 c8                	mov    %ecx,%eax
  804584:	f7 f5                	div    %ebp
  804586:	89 c1                	mov    %eax,%ecx
  804588:	89 d8                	mov    %ebx,%eax
  80458a:	f7 f5                	div    %ebp
  80458c:	89 cf                	mov    %ecx,%edi
  80458e:	89 fa                	mov    %edi,%edx
  804590:	83 c4 1c             	add    $0x1c,%esp
  804593:	5b                   	pop    %ebx
  804594:	5e                   	pop    %esi
  804595:	5f                   	pop    %edi
  804596:	5d                   	pop    %ebp
  804597:	c3                   	ret    
  804598:	39 ce                	cmp    %ecx,%esi
  80459a:	77 28                	ja     8045c4 <__udivdi3+0x7c>
  80459c:	0f bd fe             	bsr    %esi,%edi
  80459f:	83 f7 1f             	xor    $0x1f,%edi
  8045a2:	75 40                	jne    8045e4 <__udivdi3+0x9c>
  8045a4:	39 ce                	cmp    %ecx,%esi
  8045a6:	72 0a                	jb     8045b2 <__udivdi3+0x6a>
  8045a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8045ac:	0f 87 9e 00 00 00    	ja     804650 <__udivdi3+0x108>
  8045b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8045b7:	89 fa                	mov    %edi,%edx
  8045b9:	83 c4 1c             	add    $0x1c,%esp
  8045bc:	5b                   	pop    %ebx
  8045bd:	5e                   	pop    %esi
  8045be:	5f                   	pop    %edi
  8045bf:	5d                   	pop    %ebp
  8045c0:	c3                   	ret    
  8045c1:	8d 76 00             	lea    0x0(%esi),%esi
  8045c4:	31 ff                	xor    %edi,%edi
  8045c6:	31 c0                	xor    %eax,%eax
  8045c8:	89 fa                	mov    %edi,%edx
  8045ca:	83 c4 1c             	add    $0x1c,%esp
  8045cd:	5b                   	pop    %ebx
  8045ce:	5e                   	pop    %esi
  8045cf:	5f                   	pop    %edi
  8045d0:	5d                   	pop    %ebp
  8045d1:	c3                   	ret    
  8045d2:	66 90                	xchg   %ax,%ax
  8045d4:	89 d8                	mov    %ebx,%eax
  8045d6:	f7 f7                	div    %edi
  8045d8:	31 ff                	xor    %edi,%edi
  8045da:	89 fa                	mov    %edi,%edx
  8045dc:	83 c4 1c             	add    $0x1c,%esp
  8045df:	5b                   	pop    %ebx
  8045e0:	5e                   	pop    %esi
  8045e1:	5f                   	pop    %edi
  8045e2:	5d                   	pop    %ebp
  8045e3:	c3                   	ret    
  8045e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8045e9:	89 eb                	mov    %ebp,%ebx
  8045eb:	29 fb                	sub    %edi,%ebx
  8045ed:	89 f9                	mov    %edi,%ecx
  8045ef:	d3 e6                	shl    %cl,%esi
  8045f1:	89 c5                	mov    %eax,%ebp
  8045f3:	88 d9                	mov    %bl,%cl
  8045f5:	d3 ed                	shr    %cl,%ebp
  8045f7:	89 e9                	mov    %ebp,%ecx
  8045f9:	09 f1                	or     %esi,%ecx
  8045fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8045ff:	89 f9                	mov    %edi,%ecx
  804601:	d3 e0                	shl    %cl,%eax
  804603:	89 c5                	mov    %eax,%ebp
  804605:	89 d6                	mov    %edx,%esi
  804607:	88 d9                	mov    %bl,%cl
  804609:	d3 ee                	shr    %cl,%esi
  80460b:	89 f9                	mov    %edi,%ecx
  80460d:	d3 e2                	shl    %cl,%edx
  80460f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804613:	88 d9                	mov    %bl,%cl
  804615:	d3 e8                	shr    %cl,%eax
  804617:	09 c2                	or     %eax,%edx
  804619:	89 d0                	mov    %edx,%eax
  80461b:	89 f2                	mov    %esi,%edx
  80461d:	f7 74 24 0c          	divl   0xc(%esp)
  804621:	89 d6                	mov    %edx,%esi
  804623:	89 c3                	mov    %eax,%ebx
  804625:	f7 e5                	mul    %ebp
  804627:	39 d6                	cmp    %edx,%esi
  804629:	72 19                	jb     804644 <__udivdi3+0xfc>
  80462b:	74 0b                	je     804638 <__udivdi3+0xf0>
  80462d:	89 d8                	mov    %ebx,%eax
  80462f:	31 ff                	xor    %edi,%edi
  804631:	e9 58 ff ff ff       	jmp    80458e <__udivdi3+0x46>
  804636:	66 90                	xchg   %ax,%ax
  804638:	8b 54 24 08          	mov    0x8(%esp),%edx
  80463c:	89 f9                	mov    %edi,%ecx
  80463e:	d3 e2                	shl    %cl,%edx
  804640:	39 c2                	cmp    %eax,%edx
  804642:	73 e9                	jae    80462d <__udivdi3+0xe5>
  804644:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804647:	31 ff                	xor    %edi,%edi
  804649:	e9 40 ff ff ff       	jmp    80458e <__udivdi3+0x46>
  80464e:	66 90                	xchg   %ax,%ax
  804650:	31 c0                	xor    %eax,%eax
  804652:	e9 37 ff ff ff       	jmp    80458e <__udivdi3+0x46>
  804657:	90                   	nop

00804658 <__umoddi3>:
  804658:	55                   	push   %ebp
  804659:	57                   	push   %edi
  80465a:	56                   	push   %esi
  80465b:	53                   	push   %ebx
  80465c:	83 ec 1c             	sub    $0x1c,%esp
  80465f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804663:	8b 74 24 34          	mov    0x34(%esp),%esi
  804667:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80466b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80466f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804673:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804677:	89 f3                	mov    %esi,%ebx
  804679:	89 fa                	mov    %edi,%edx
  80467b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80467f:	89 34 24             	mov    %esi,(%esp)
  804682:	85 c0                	test   %eax,%eax
  804684:	75 1a                	jne    8046a0 <__umoddi3+0x48>
  804686:	39 f7                	cmp    %esi,%edi
  804688:	0f 86 a2 00 00 00    	jbe    804730 <__umoddi3+0xd8>
  80468e:	89 c8                	mov    %ecx,%eax
  804690:	89 f2                	mov    %esi,%edx
  804692:	f7 f7                	div    %edi
  804694:	89 d0                	mov    %edx,%eax
  804696:	31 d2                	xor    %edx,%edx
  804698:	83 c4 1c             	add    $0x1c,%esp
  80469b:	5b                   	pop    %ebx
  80469c:	5e                   	pop    %esi
  80469d:	5f                   	pop    %edi
  80469e:	5d                   	pop    %ebp
  80469f:	c3                   	ret    
  8046a0:	39 f0                	cmp    %esi,%eax
  8046a2:	0f 87 ac 00 00 00    	ja     804754 <__umoddi3+0xfc>
  8046a8:	0f bd e8             	bsr    %eax,%ebp
  8046ab:	83 f5 1f             	xor    $0x1f,%ebp
  8046ae:	0f 84 ac 00 00 00    	je     804760 <__umoddi3+0x108>
  8046b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8046b9:	29 ef                	sub    %ebp,%edi
  8046bb:	89 fe                	mov    %edi,%esi
  8046bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8046c1:	89 e9                	mov    %ebp,%ecx
  8046c3:	d3 e0                	shl    %cl,%eax
  8046c5:	89 d7                	mov    %edx,%edi
  8046c7:	89 f1                	mov    %esi,%ecx
  8046c9:	d3 ef                	shr    %cl,%edi
  8046cb:	09 c7                	or     %eax,%edi
  8046cd:	89 e9                	mov    %ebp,%ecx
  8046cf:	d3 e2                	shl    %cl,%edx
  8046d1:	89 14 24             	mov    %edx,(%esp)
  8046d4:	89 d8                	mov    %ebx,%eax
  8046d6:	d3 e0                	shl    %cl,%eax
  8046d8:	89 c2                	mov    %eax,%edx
  8046da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046de:	d3 e0                	shl    %cl,%eax
  8046e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8046e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046e8:	89 f1                	mov    %esi,%ecx
  8046ea:	d3 e8                	shr    %cl,%eax
  8046ec:	09 d0                	or     %edx,%eax
  8046ee:	d3 eb                	shr    %cl,%ebx
  8046f0:	89 da                	mov    %ebx,%edx
  8046f2:	f7 f7                	div    %edi
  8046f4:	89 d3                	mov    %edx,%ebx
  8046f6:	f7 24 24             	mull   (%esp)
  8046f9:	89 c6                	mov    %eax,%esi
  8046fb:	89 d1                	mov    %edx,%ecx
  8046fd:	39 d3                	cmp    %edx,%ebx
  8046ff:	0f 82 87 00 00 00    	jb     80478c <__umoddi3+0x134>
  804705:	0f 84 91 00 00 00    	je     80479c <__umoddi3+0x144>
  80470b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80470f:	29 f2                	sub    %esi,%edx
  804711:	19 cb                	sbb    %ecx,%ebx
  804713:	89 d8                	mov    %ebx,%eax
  804715:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804719:	d3 e0                	shl    %cl,%eax
  80471b:	89 e9                	mov    %ebp,%ecx
  80471d:	d3 ea                	shr    %cl,%edx
  80471f:	09 d0                	or     %edx,%eax
  804721:	89 e9                	mov    %ebp,%ecx
  804723:	d3 eb                	shr    %cl,%ebx
  804725:	89 da                	mov    %ebx,%edx
  804727:	83 c4 1c             	add    $0x1c,%esp
  80472a:	5b                   	pop    %ebx
  80472b:	5e                   	pop    %esi
  80472c:	5f                   	pop    %edi
  80472d:	5d                   	pop    %ebp
  80472e:	c3                   	ret    
  80472f:	90                   	nop
  804730:	89 fd                	mov    %edi,%ebp
  804732:	85 ff                	test   %edi,%edi
  804734:	75 0b                	jne    804741 <__umoddi3+0xe9>
  804736:	b8 01 00 00 00       	mov    $0x1,%eax
  80473b:	31 d2                	xor    %edx,%edx
  80473d:	f7 f7                	div    %edi
  80473f:	89 c5                	mov    %eax,%ebp
  804741:	89 f0                	mov    %esi,%eax
  804743:	31 d2                	xor    %edx,%edx
  804745:	f7 f5                	div    %ebp
  804747:	89 c8                	mov    %ecx,%eax
  804749:	f7 f5                	div    %ebp
  80474b:	89 d0                	mov    %edx,%eax
  80474d:	e9 44 ff ff ff       	jmp    804696 <__umoddi3+0x3e>
  804752:	66 90                	xchg   %ax,%ax
  804754:	89 c8                	mov    %ecx,%eax
  804756:	89 f2                	mov    %esi,%edx
  804758:	83 c4 1c             	add    $0x1c,%esp
  80475b:	5b                   	pop    %ebx
  80475c:	5e                   	pop    %esi
  80475d:	5f                   	pop    %edi
  80475e:	5d                   	pop    %ebp
  80475f:	c3                   	ret    
  804760:	3b 04 24             	cmp    (%esp),%eax
  804763:	72 06                	jb     80476b <__umoddi3+0x113>
  804765:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804769:	77 0f                	ja     80477a <__umoddi3+0x122>
  80476b:	89 f2                	mov    %esi,%edx
  80476d:	29 f9                	sub    %edi,%ecx
  80476f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804773:	89 14 24             	mov    %edx,(%esp)
  804776:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80477a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80477e:	8b 14 24             	mov    (%esp),%edx
  804781:	83 c4 1c             	add    $0x1c,%esp
  804784:	5b                   	pop    %ebx
  804785:	5e                   	pop    %esi
  804786:	5f                   	pop    %edi
  804787:	5d                   	pop    %ebp
  804788:	c3                   	ret    
  804789:	8d 76 00             	lea    0x0(%esi),%esi
  80478c:	2b 04 24             	sub    (%esp),%eax
  80478f:	19 fa                	sbb    %edi,%edx
  804791:	89 d1                	mov    %edx,%ecx
  804793:	89 c6                	mov    %eax,%esi
  804795:	e9 71 ff ff ff       	jmp    80470b <__umoddi3+0xb3>
  80479a:	66 90                	xchg   %ax,%ax
  80479c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8047a0:	72 ea                	jb     80478c <__umoddi3+0x134>
  8047a2:	89 d9                	mov    %ebx,%ecx
  8047a4:	e9 62 ff ff ff       	jmp    80470b <__umoddi3+0xb3>
