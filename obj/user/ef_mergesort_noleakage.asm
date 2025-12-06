
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 2f 07 00 00       	call   800765 <libmain>
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
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_lock_cons();
  800041:	e8 57 33 00 00       	call   80339d <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 45 80 00       	push   $0x8045e0
  80004e:	e8 90 0b 00 00       	call   800be3 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 45 80 00       	push   $0x8045e2
  80005e:	e8 80 0b 00 00       	call   800be3 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 45 80 00       	push   $0x8045f8
  80006e:	e8 70 0b 00 00       	call   800be3 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 45 80 00       	push   $0x8045e2
  80007e:	e8 60 0b 00 00       	call   800be3 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 45 80 00       	push   $0x8045e0
  80008e:	e8 50 0b 00 00       	call   800be3 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 10 46 80 00       	push   $0x804610
  80009e:	e8 40 0b 00 00       	call   800be3 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 2f 46 80 00       	push   $0x80462f
  8000b8:	e8 26 0b 00 00       	call   800be3 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 d6 1a 00 00       	call   801ba5 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 34 46 80 00       	push   $0x804634
  8000dd:	e8 01 0b 00 00       	call   800be3 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 56 46 80 00       	push   $0x804656
  8000ed:	e8 f1 0a 00 00       	call   800be3 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 64 46 80 00       	push   $0x804664
  8000fd:	e8 e1 0a 00 00       	call   800be3 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 73 46 80 00       	push   $0x804673
  80010d:	e8 d1 0a 00 00       	call   800be3 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 83 46 80 00       	push   $0x804683
  80011d:	e8 c1 0a 00 00       	call   800be3 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 f3 05 00 00       	call   800729 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 e6 05 00 00       	call   800729 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_unlock_cons();
  800158:	e8 5a 32 00 00       	call   8033b7 <sys_unlock_cons>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f5 01 00 00       	call   800373 <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 13 02 00 00       	call   8003a4 <InitializeIdentical>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 35 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 22 02 00 00       	call   8003d9 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 ee 02 00 00       	call   8004b8 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001cd:	e8 cb 31 00 00       	call   80339d <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 8c 46 80 00       	push   $0x80468c
  8001da:	e8 04 0a 00 00       	call   800be3 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001e2:	e8 d0 31 00 00       	call   8033b7 <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d4 00 00 00       	call   8002c9 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 c0 46 80 00       	push   $0x8046c0
  800209:	6a 4e                	push   $0x4e
  80020b:	68 e2 46 80 00       	push   $0x8046e2
  800210:	e8 00 07 00 00       	call   800915 <_panic>
		else
		{
			sys_lock_cons();
  800215:	e8 83 31 00 00       	call   80339d <sys_lock_cons>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 00 47 80 00       	push   $0x804700
  800222:	e8 bc 09 00 00       	call   800be3 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 34 47 80 00       	push   $0x804734
  800232:	e8 ac 09 00 00       	call   800be3 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 68 47 80 00       	push   $0x804768
  800242:	e8 9c 09 00 00       	call   800be3 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  80024a:	e8 68 31 00 00       	call   8033b7 <sys_unlock_cons>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 ab 1c 00 00       	call   801f05 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80025d:	e8 3b 31 00 00       	call   80339d <sys_lock_cons>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 9a 47 80 00       	push   $0x80479a
  800270:	e8 6e 09 00 00       	call   800be3 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 a0 04 00 00       	call   800729 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 93 04 00 00       	call   800729 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 86 04 00 00       	call   800729 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_lock_cons();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_unlock_cons();
  8002b2:	e8 00 31 00 00       	call   8033b7 <sys_unlock_cons>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

	//To indicate that it's completed successfully
	inctst();
  8002c1:	e8 8e 34 00 00       	call   803754 <inctst>

}
  8002c6:	90                   	nop
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dd:	eb 33                	jmp    800312 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	01 d0                	add    %edx,%eax
  8002ee:	8b 10                	mov    (%eax),%edx
  8002f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f3:	40                   	inc    %eax
  8002f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	01 c8                	add    %ecx,%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	7e 09                	jle    80030f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030d:	eb 0c                	jmp    80031b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030f:	ff 45 f8             	incl   -0x8(%ebp)
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	48                   	dec    %eax
  800316:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800319:	7f c4                	jg     8002df <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800326:	8b 45 0c             	mov    0xc(%ebp),%eax
  800329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 d0                	add    %edx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	01 c8                	add    %ecx,%eax
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	01 c2                	add    %eax,%edx
  80036b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036e:	89 02                	mov    %eax,(%edx)
}
  800370:	90                   	nop
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800379:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800380:	eb 17                	jmp    800399 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800382:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	01 c2                	add    %eax,%edx
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800396:	ff 45 fc             	incl   -0x4(%ebp)
  800399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039f:	7c e1                	jl     800382 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a1:	90                   	nop
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b1:	eb 1b                	jmp    8003ce <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c2                	add    %eax,%edx
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c8:	48                   	dec    %eax
  8003c9:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003cb:	ff 45 fc             	incl   -0x4(%ebp)
  8003ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d4:	7c dd                	jl     8003b3 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d6:	90                   	nop
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e2:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e7:	f7 e9                	imul   %ecx
  8003e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ec:	89 d0                	mov    %edx,%eax
  8003ee:	29 c8                	sub    %ecx,%eax
  8003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003f7:	75 07                	jne    800400 <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003f9:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800407:	eb 1e                	jmp    800427 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	99                   	cltd   
  80041d:	f7 7d f8             	idivl  -0x8(%ebp)
  800420:	89 d0                	mov    %edx,%eax
  800422:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800424:	ff 45 fc             	incl   -0x4(%ebp)
  800427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042d:	7c da                	jl     800409 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80042f:	90                   	nop
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800438:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800446:	eb 42                	jmp    80048a <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044b:	99                   	cltd   
  80044c:	f7 7d f0             	idivl  -0x10(%ebp)
  80044f:	89 d0                	mov    %edx,%eax
  800451:	85 c0                	test   %eax,%eax
  800453:	75 10                	jne    800465 <PrintElements+0x33>
			cprintf("\n");
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	68 e0 45 80 00       	push   $0x8045e0
  80045d:	e8 81 07 00 00       	call   800be3 <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 b8 47 80 00       	push   $0x8047b8
  80047f:	e8 5f 07 00 00       	call   800be3 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800487:	ff 45 f4             	incl   -0xc(%ebp)
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	48                   	dec    %eax
  80048e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800491:	7f b5                	jg     800448 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800496:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 2f 46 80 00       	push   $0x80462f
  8004ad:	e8 31 07 00 00       	call   800be3 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp

}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c4:	7d 54                	jge    80051a <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	89 c2                	mov    %eax,%edx
  8004d0:	c1 ea 1f             	shr    $0x1f,%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	d1 f8                	sar    %eax
  8004d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 cd ff ff ff       	call   8004b8 <MSort>
  8004eb:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f1:	40                   	inc    %eax
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	ff 75 10             	pushl  0x10(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	e8 b7 ff ff ff       	call   8004b8 <MSort>
  800501:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800504:	ff 75 10             	pushl  0x10(%ebp)
  800507:	ff 75 f4             	pushl  -0xc(%ebp)
  80050a:	ff 75 0c             	pushl  0xc(%ebp)
  80050d:	ff 75 08             	pushl  0x8(%ebp)
  800510:	e8 08 00 00 00       	call   80051d <Merge>
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	eb 01                	jmp    80051b <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80051a:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    

0080051d <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	2b 45 0c             	sub    0xc(%ebp),%eax
  800529:	40                   	inc    %eax
  80052a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	2b 45 10             	sub    0x10(%ebp),%eax
  800533:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80053d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800547:	c1 e0 02             	shl    $0x2,%eax
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	50                   	push   %eax
  80054e:	e8 52 16 00 00       	call   801ba5 <malloc>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800559:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055c:	c1 e0 02             	shl    $0x2,%eax
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	50                   	push   %eax
  800563:	e8 3d 16 00 00       	call   801ba5 <malloc>
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800575:	eb 2f                	jmp    8005a6 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800581:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800584:	01 c2                	add    %eax,%edx
  800586:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800593:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005a3:	ff 45 ec             	incl   -0x14(%ebp)
  8005a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ac:	7c c9                	jl     800577 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b5:	eb 2a                	jmp    8005e1 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c4:	01 c2                	add    %eax,%edx
  8005c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005cc:	01 c8                	add    %ecx,%eax
  8005ce:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	01 c8                	add    %ecx,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005de:	ff 45 e8             	incl   -0x18(%ebp)
  8005e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e7:	7c ce                	jl     8005b7 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ef:	e9 0a 01 00 00       	jmp    8006fe <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005fa:	0f 8d 95 00 00 00    	jge    800695 <Merge+0x178>
  800600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800603:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800606:	0f 8d 89 00 00 00    	jge    800695 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800616:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800619:	01 d0                	add    %edx,%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80062a:	01 c8                	add    %ecx,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	39 c2                	cmp    %eax,%edx
  800630:	7d 33                	jge    800665 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800635:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80063a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800650:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800657:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800660:	e9 96 00 00 00       	jmp    8006fb <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800668:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80066d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800683:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80068d:	01 d0                	add    %edx,%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800693:	eb 66                	jmp    8006fb <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800698:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80069b:	7d 30                	jge    8006cd <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80069d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b5:	8d 50 01             	lea    0x1(%eax),%edx
  8006b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c5:	01 d0                	add    %edx,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 01                	mov    %eax,(%ecx)
  8006cb:	eb 2e                	jmp    8006fb <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d0:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	8d 50 01             	lea    0x1(%eax),%edx
  8006e8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800701:	3b 45 14             	cmp    0x14(%ebp),%eax
  800704:	0f 8e ea fe ff ff    	jle    8005f4 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d8             	pushl  -0x28(%ebp)
  800710:	e8 f0 17 00 00       	call   801f05 <free>
  800715:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071e:	e8 e2 17 00 00       	call   801f05 <free>
  800723:	83 c4 10             	add    $0x10,%esp

}
  800726:	90                   	nop
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800735:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800739:	83 ec 0c             	sub    $0xc,%esp
  80073c:	50                   	push   %eax
  80073d:	e8 a3 2d 00 00       	call   8034e5 <sys_cputc>
  800742:	83 c4 10             	add    $0x10,%esp
}
  800745:	90                   	nop
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <getchar>:


int
getchar(void)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80074e:	e8 31 2c 00 00       	call   803384 <sys_cgetc>
  800753:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <iscons>:

int iscons(int fdnum)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	57                   	push   %edi
  800769:	56                   	push   %esi
  80076a:	53                   	push   %ebx
  80076b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80076e:	e8 a3 2e 00 00       	call   803616 <sys_getenvindex>
  800773:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800779:	89 d0                	mov    %edx,%eax
  80077b:	c1 e0 03             	shl    $0x3,%eax
  80077e:	01 d0                	add    %edx,%eax
  800780:	c1 e0 02             	shl    $0x2,%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80078c:	01 d0                	add    %edx,%eax
  80078e:	c1 e0 03             	shl    $0x3,%eax
  800791:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800796:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80079b:	a1 24 60 80 00       	mov    0x806024,%eax
  8007a0:	8a 40 20             	mov    0x20(%eax),%al
  8007a3:	84 c0                	test   %al,%al
  8007a5:	74 0d                	je     8007b4 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007a7:	a1 24 60 80 00       	mov    0x806024,%eax
  8007ac:	83 c0 20             	add    $0x20,%eax
  8007af:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b8:	7e 0a                	jle    8007c4 <libmain+0x5f>
		binaryname = argv[0];
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 66 f8 ff ff       	call   800038 <_main>
  8007d2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007d5:	a1 00 60 80 00       	mov    0x806000,%eax
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	0f 84 01 01 00 00    	je     8008e3 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8007e2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007e8:	bb b8 48 80 00       	mov    $0x8048b8,%ebx
  8007ed:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007f2:	89 c7                	mov    %eax,%edi
  8007f4:	89 de                	mov    %ebx,%esi
  8007f6:	89 d1                	mov    %edx,%ecx
  8007f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007fa:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007fd:	b9 56 00 00 00       	mov    $0x56,%ecx
  800802:	b0 00                	mov    $0x0,%al
  800804:	89 d7                	mov    %edx,%edi
  800806:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800808:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80080f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	50                   	push   %eax
  800816:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80081c:	50                   	push   %eax
  80081d:	e8 2a 30 00 00       	call   80384c <sys_utilities>
  800822:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800825:	e8 73 2b 00 00       	call   80339d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80082a:	83 ec 0c             	sub    $0xc,%esp
  80082d:	68 d8 47 80 00       	push   $0x8047d8
  800832:	e8 ac 03 00 00       	call   800be3 <cprintf>
  800837:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80083a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083d:	85 c0                	test   %eax,%eax
  80083f:	74 18                	je     800859 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800841:	e8 24 30 00 00       	call   80386a <sys_get_optimal_num_faults>
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	50                   	push   %eax
  80084a:	68 00 48 80 00       	push   $0x804800
  80084f:	e8 8f 03 00 00       	call   800be3 <cprintf>
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	eb 59                	jmp    8008b2 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800859:	a1 24 60 80 00       	mov    0x806024,%eax
  80085e:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800864:	a1 24 60 80 00       	mov    0x806024,%eax
  800869:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80086f:	83 ec 04             	sub    $0x4,%esp
  800872:	52                   	push   %edx
  800873:	50                   	push   %eax
  800874:	68 24 48 80 00       	push   $0x804824
  800879:	e8 65 03 00 00       	call   800be3 <cprintf>
  80087e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800881:	a1 24 60 80 00       	mov    0x806024,%eax
  800886:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80088c:	a1 24 60 80 00       	mov    0x806024,%eax
  800891:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800897:	a1 24 60 80 00       	mov    0x806024,%eax
  80089c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8008a2:	51                   	push   %ecx
  8008a3:	52                   	push   %edx
  8008a4:	50                   	push   %eax
  8008a5:	68 4c 48 80 00       	push   $0x80484c
  8008aa:	e8 34 03 00 00       	call   800be3 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008b2:	a1 24 60 80 00       	mov    0x806024,%eax
  8008b7:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	50                   	push   %eax
  8008c1:	68 a4 48 80 00       	push   $0x8048a4
  8008c6:	e8 18 03 00 00       	call   800be3 <cprintf>
  8008cb:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008ce:	83 ec 0c             	sub    $0xc,%esp
  8008d1:	68 d8 47 80 00       	push   $0x8047d8
  8008d6:	e8 08 03 00 00       	call   800be3 <cprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8008de:	e8 d4 2a 00 00       	call   8033b7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8008e3:	e8 1f 00 00 00       	call   800907 <exit>
}
  8008e8:	90                   	nop
  8008e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5f                   	pop    %edi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	6a 00                	push   $0x0
  8008fc:	e8 e1 2c 00 00       	call   8035e2 <sys_destroy_env>
  800901:	83 c4 10             	add    $0x10,%esp
}
  800904:	90                   	nop
  800905:	c9                   	leave  
  800906:	c3                   	ret    

00800907 <exit>:

void
exit(void)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80090d:	e8 36 2d 00 00       	call   803648 <sys_exit_env>
}
  800912:	90                   	nop
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80091b:	8d 45 10             	lea    0x10(%ebp),%eax
  80091e:	83 c0 04             	add    $0x4,%eax
  800921:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800924:	a1 38 61 83 00       	mov    0x836138,%eax
  800929:	85 c0                	test   %eax,%eax
  80092b:	74 16                	je     800943 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80092d:	a1 38 61 83 00       	mov    0x836138,%eax
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	50                   	push   %eax
  800936:	68 1c 49 80 00       	push   $0x80491c
  80093b:	e8 a3 02 00 00       	call   800be3 <cprintf>
  800940:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800943:	a1 04 60 80 00       	mov    0x806004,%eax
  800948:	83 ec 0c             	sub    $0xc,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	ff 75 08             	pushl  0x8(%ebp)
  800951:	50                   	push   %eax
  800952:	68 24 49 80 00       	push   $0x804924
  800957:	6a 74                	push   $0x74
  800959:	e8 b2 02 00 00       	call   800c10 <cprintf_colored>
  80095e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800961:	8b 45 10             	mov    0x10(%ebp),%eax
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 f4             	pushl  -0xc(%ebp)
  80096a:	50                   	push   %eax
  80096b:	e8 04 02 00 00       	call   800b74 <vcprintf>
  800970:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	6a 00                	push   $0x0
  800978:	68 4c 49 80 00       	push   $0x80494c
  80097d:	e8 f2 01 00 00       	call   800b74 <vcprintf>
  800982:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800985:	e8 7d ff ff ff       	call   800907 <exit>

	// should not return here
	while (1) ;
  80098a:	eb fe                	jmp    80098a <_panic+0x75>

0080098c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800992:	a1 24 60 80 00       	mov    0x806024,%eax
  800997:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80099d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a0:	39 c2                	cmp    %eax,%edx
  8009a2:	74 14                	je     8009b8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	68 50 49 80 00       	push   $0x804950
  8009ac:	6a 26                	push   $0x26
  8009ae:	68 9c 49 80 00       	push   $0x80499c
  8009b3:	e8 5d ff ff ff       	call   800915 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009c6:	e9 c5 00 00 00       	jmp    800a90 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	8b 00                	mov    (%eax),%eax
  8009dc:	85 c0                	test   %eax,%eax
  8009de:	75 08                	jne    8009e8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009e0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009e3:	e9 a5 00 00 00       	jmp    800a8d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009f6:	eb 69                	jmp    800a61 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009f8:	a1 24 60 80 00       	mov    0x806024,%eax
  8009fd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a06:	89 d0                	mov    %edx,%eax
  800a08:	01 c0                	add    %eax,%eax
  800a0a:	01 d0                	add    %edx,%eax
  800a0c:	c1 e0 03             	shl    $0x3,%eax
  800a0f:	01 c8                	add    %ecx,%eax
  800a11:	8a 40 04             	mov    0x4(%eax),%al
  800a14:	84 c0                	test   %al,%al
  800a16:	75 46                	jne    800a5e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a18:	a1 24 60 80 00       	mov    0x806024,%eax
  800a1d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a26:	89 d0                	mov    %edx,%eax
  800a28:	01 c0                	add    %eax,%eax
  800a2a:	01 d0                	add    %edx,%eax
  800a2c:	c1 e0 03             	shl    $0x3,%eax
  800a2f:	01 c8                	add    %ecx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a3e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a43:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	01 c8                	add    %ecx,%eax
  800a4f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a51:	39 c2                	cmp    %eax,%edx
  800a53:	75 09                	jne    800a5e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a55:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a5c:	eb 15                	jmp    800a73 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5e:	ff 45 e8             	incl   -0x18(%ebp)
  800a61:	a1 24 60 80 00       	mov    0x806024,%eax
  800a66:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a6f:	39 c2                	cmp    %eax,%edx
  800a71:	77 85                	ja     8009f8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a77:	75 14                	jne    800a8d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a79:	83 ec 04             	sub    $0x4,%esp
  800a7c:	68 a8 49 80 00       	push   $0x8049a8
  800a81:	6a 3a                	push   $0x3a
  800a83:	68 9c 49 80 00       	push   $0x80499c
  800a88:	e8 88 fe ff ff       	call   800915 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a8d:	ff 45 f0             	incl   -0x10(%ebp)
  800a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a93:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a96:	0f 8c 2f ff ff ff    	jl     8009cb <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800aaa:	eb 26                	jmp    800ad2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800aac:	a1 24 60 80 00       	mov    0x806024,%eax
  800ab1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800ab7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aba:	89 d0                	mov    %edx,%eax
  800abc:	01 c0                	add    %eax,%eax
  800abe:	01 d0                	add    %edx,%eax
  800ac0:	c1 e0 03             	shl    $0x3,%eax
  800ac3:	01 c8                	add    %ecx,%eax
  800ac5:	8a 40 04             	mov    0x4(%eax),%al
  800ac8:	3c 01                	cmp    $0x1,%al
  800aca:	75 03                	jne    800acf <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800acc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800acf:	ff 45 e0             	incl   -0x20(%ebp)
  800ad2:	a1 24 60 80 00       	mov    0x806024,%eax
  800ad7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae0:	39 c2                	cmp    %eax,%edx
  800ae2:	77 c8                	ja     800aac <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aea:	74 14                	je     800b00 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800aec:	83 ec 04             	sub    $0x4,%esp
  800aef:	68 fc 49 80 00       	push   $0x8049fc
  800af4:	6a 44                	push   $0x44
  800af6:	68 9c 49 80 00       	push   $0x80499c
  800afb:	e8 15 fe ff ff       	call   800915 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b00:	90                   	nop
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	53                   	push   %ebx
  800b07:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	89 0a                	mov    %ecx,(%edx)
  800b17:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1a:	88 d1                	mov    %dl,%cl
  800b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b2d:	75 30                	jne    800b5f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b2f:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800b35:	a0 64 e0 81 00       	mov    0x81e064,%al
  800b3a:	0f b6 c0             	movzbl %al,%eax
  800b3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b40:	8b 09                	mov    (%ecx),%ecx
  800b42:	89 cb                	mov    %ecx,%ebx
  800b44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b47:	83 c1 08             	add    $0x8,%ecx
  800b4a:	52                   	push   %edx
  800b4b:	50                   	push   %eax
  800b4c:	53                   	push   %ebx
  800b4d:	51                   	push   %ecx
  800b4e:	e8 06 28 00 00       	call   803359 <sys_cputs>
  800b53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b62:	8b 40 04             	mov    0x4(%eax),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b6e:	90                   	nop
  800b6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b7d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b84:	00 00 00 
	b.cnt = 0;
  800b87:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b8e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9d:	50                   	push   %eax
  800b9e:	68 03 0b 80 00       	push   $0x800b03
  800ba3:	e8 5a 02 00 00       	call   800e02 <vprintfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bab:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800bb1:	a0 64 e0 81 00       	mov    0x81e064,%al
  800bb6:	0f b6 c0             	movzbl %al,%eax
  800bb9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bbf:	52                   	push   %edx
  800bc0:	50                   	push   %eax
  800bc1:	51                   	push   %ecx
  800bc2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bc8:	83 c0 08             	add    $0x8,%eax
  800bcb:	50                   	push   %eax
  800bcc:	e8 88 27 00 00       	call   803359 <sys_cputs>
  800bd1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bd4:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800bdb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800be9:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800bf0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	50                   	push   %eax
  800c00:	e8 6f ff ff ff       	call   800b74 <vcprintf>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c16:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	c1 e0 08             	shl    $0x8,%eax
  800c23:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800c28:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c2b:	83 c0 04             	add    $0x4,%eax
  800c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3a:	50                   	push   %eax
  800c3b:	e8 34 ff ff ff       	call   800b74 <vcprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c46:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800c4d:	07 00 00 

	return cnt;
  800c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c5b:	e8 3d 27 00 00       	call   80339d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c60:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	83 ec 08             	sub    $0x8,%esp
  800c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6f:	50                   	push   %eax
  800c70:	e8 ff fe ff ff       	call   800b74 <vcprintf>
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c7b:	e8 37 27 00 00       	call   8033b7 <sys_unlock_cons>
	return cnt;
  800c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	53                   	push   %ebx
  800c89:	83 ec 14             	sub    $0x14,%esp
  800c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c92:	8b 45 14             	mov    0x14(%ebp),%eax
  800c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c98:	8b 45 18             	mov    0x18(%ebp),%eax
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ca3:	77 55                	ja     800cfa <printnum+0x75>
  800ca5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ca8:	72 05                	jb     800caf <printnum+0x2a>
  800caa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cad:	77 4b                	ja     800cfa <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800caf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cb2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cb5:	8b 45 18             	mov    0x18(%ebp),%eax
  800cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbd:	52                   	push   %edx
  800cbe:	50                   	push   %eax
  800cbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc2:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc5:	e8 a6 36 00 00       	call   804370 <__udivdi3>
  800cca:	83 c4 10             	add    $0x10,%esp
  800ccd:	83 ec 04             	sub    $0x4,%esp
  800cd0:	ff 75 20             	pushl  0x20(%ebp)
  800cd3:	53                   	push   %ebx
  800cd4:	ff 75 18             	pushl  0x18(%ebp)
  800cd7:	52                   	push   %edx
  800cd8:	50                   	push   %eax
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	ff 75 08             	pushl  0x8(%ebp)
  800cdf:	e8 a1 ff ff ff       	call   800c85 <printnum>
  800ce4:	83 c4 20             	add    $0x20,%esp
  800ce7:	eb 1a                	jmp    800d03 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	ff 75 20             	pushl  0x20(%ebp)
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	ff d0                	call   *%eax
  800cf7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cfa:	ff 4d 1c             	decl   0x1c(%ebp)
  800cfd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d01:	7f e6                	jg     800ce9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d03:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d11:	53                   	push   %ebx
  800d12:	51                   	push   %ecx
  800d13:	52                   	push   %edx
  800d14:	50                   	push   %eax
  800d15:	e8 66 37 00 00       	call   804480 <__umoddi3>
  800d1a:	83 c4 10             	add    $0x10,%esp
  800d1d:	05 74 4c 80 00       	add    $0x804c74,%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f be c0             	movsbl %al,%eax
  800d27:	83 ec 08             	sub    $0x8,%esp
  800d2a:	ff 75 0c             	pushl  0xc(%ebp)
  800d2d:	50                   	push   %eax
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	ff d0                	call   *%eax
  800d33:	83 c4 10             	add    $0x10,%esp
}
  800d36:	90                   	nop
  800d37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    

00800d3c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d43:	7e 1c                	jle    800d61 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8b 00                	mov    (%eax),%eax
  800d4a:	8d 50 08             	lea    0x8(%eax),%edx
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	89 10                	mov    %edx,(%eax)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	83 e8 08             	sub    $0x8,%eax
  800d5a:	8b 50 04             	mov    0x4(%eax),%edx
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	eb 40                	jmp    800da1 <getuint+0x65>
	else if (lflag)
  800d61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d65:	74 1e                	je     800d85 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d83:	eb 1c                	jmp    800da1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8b 00                	mov    (%eax),%eax
  800d8a:	8d 50 04             	lea    0x4(%eax),%edx
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 10                	mov    %edx,(%eax)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	83 e8 04             	sub    $0x4,%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800da6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800daa:	7e 1c                	jle    800dc8 <getint+0x25>
		return va_arg(*ap, long long);
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	8d 50 08             	lea    0x8(%eax),%edx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 10                	mov    %edx,(%eax)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8b 00                	mov    (%eax),%eax
  800dbe:	83 e8 08             	sub    $0x8,%eax
  800dc1:	8b 50 04             	mov    0x4(%eax),%edx
  800dc4:	8b 00                	mov    (%eax),%eax
  800dc6:	eb 38                	jmp    800e00 <getint+0x5d>
	else if (lflag)
  800dc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcc:	74 1a                	je     800de8 <getint+0x45>
		return va_arg(*ap, long);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	8d 50 04             	lea    0x4(%eax),%edx
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 10                	mov    %edx,(%eax)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8b 00                	mov    (%eax),%eax
  800de0:	83 e8 04             	sub    $0x4,%eax
  800de3:	8b 00                	mov    (%eax),%eax
  800de5:	99                   	cltd   
  800de6:	eb 18                	jmp    800e00 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8b 00                	mov    (%eax),%eax
  800ded:	8d 50 04             	lea    0x4(%eax),%edx
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 10                	mov    %edx,(%eax)
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8b 00                	mov    (%eax),%eax
  800dfa:	83 e8 04             	sub    $0x4,%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	99                   	cltd   
}
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
  800e07:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e0a:	eb 17                	jmp    800e23 <vprintfmt+0x21>
			if (ch == '\0')
  800e0c:	85 db                	test   %ebx,%ebx
  800e0e:	0f 84 c1 03 00 00    	je     8011d5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	53                   	push   %ebx
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	ff d0                	call   *%eax
  800e20:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e23:	8b 45 10             	mov    0x10(%ebp),%eax
  800e26:	8d 50 01             	lea    0x1(%eax),%edx
  800e29:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f b6 d8             	movzbl %al,%ebx
  800e31:	83 fb 25             	cmp    $0x25,%ebx
  800e34:	75 d6                	jne    800e0c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e36:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e3a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e41:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e48:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e4f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	8d 50 01             	lea    0x1(%eax),%edx
  800e5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 d8             	movzbl %al,%ebx
  800e64:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e67:	83 f8 5b             	cmp    $0x5b,%eax
  800e6a:	0f 87 3d 03 00 00    	ja     8011ad <vprintfmt+0x3ab>
  800e70:	8b 04 85 98 4c 80 00 	mov    0x804c98(,%eax,4),%eax
  800e77:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e79:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e7d:	eb d7                	jmp    800e56 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e7f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e83:	eb d1                	jmp    800e56 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e8f:	89 d0                	mov    %edx,%eax
  800e91:	c1 e0 02             	shl    $0x2,%eax
  800e94:	01 d0                	add    %edx,%eax
  800e96:	01 c0                	add    %eax,%eax
  800e98:	01 d8                	add    %ebx,%eax
  800e9a:	83 e8 30             	sub    $0x30,%eax
  800e9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ea8:	83 fb 2f             	cmp    $0x2f,%ebx
  800eab:	7e 3e                	jle    800eeb <vprintfmt+0xe9>
  800ead:	83 fb 39             	cmp    $0x39,%ebx
  800eb0:	7f 39                	jg     800eeb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eb5:	eb d5                	jmp    800e8c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 00                	mov    (%eax),%eax
  800ec8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ecb:	eb 1f                	jmp    800eec <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ecd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed1:	79 83                	jns    800e56 <vprintfmt+0x54>
				width = 0;
  800ed3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800eda:	e9 77 ff ff ff       	jmp    800e56 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800edf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ee6:	e9 6b ff ff ff       	jmp    800e56 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800eeb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800eec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef0:	0f 89 60 ff ff ff    	jns    800e56 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ef6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800efc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f03:	e9 4e ff ff ff       	jmp    800e56 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f08:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f0b:	e9 46 ff ff ff       	jmp    800e56 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 14             	mov    %eax,0x14(%ebp)
  800f19:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1c:	83 e8 04             	sub    $0x4,%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	50                   	push   %eax
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
			break;
  800f30:	e9 9b 02 00 00       	jmp    8011d0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f35:	8b 45 14             	mov    0x14(%ebp),%eax
  800f38:	83 c0 04             	add    $0x4,%eax
  800f3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 e8 04             	sub    $0x4,%eax
  800f44:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f46:	85 db                	test   %ebx,%ebx
  800f48:	79 02                	jns    800f4c <vprintfmt+0x14a>
				err = -err;
  800f4a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f4c:	83 fb 64             	cmp    $0x64,%ebx
  800f4f:	7f 0b                	jg     800f5c <vprintfmt+0x15a>
  800f51:	8b 34 9d e0 4a 80 00 	mov    0x804ae0(,%ebx,4),%esi
  800f58:	85 f6                	test   %esi,%esi
  800f5a:	75 19                	jne    800f75 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f5c:	53                   	push   %ebx
  800f5d:	68 85 4c 80 00       	push   $0x804c85
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	ff 75 08             	pushl  0x8(%ebp)
  800f68:	e8 70 02 00 00       	call   8011dd <printfmt>
  800f6d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f70:	e9 5b 02 00 00       	jmp    8011d0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f75:	56                   	push   %esi
  800f76:	68 8e 4c 80 00       	push   $0x804c8e
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	ff 75 08             	pushl  0x8(%ebp)
  800f81:	e8 57 02 00 00       	call   8011dd <printfmt>
  800f86:	83 c4 10             	add    $0x10,%esp
			break;
  800f89:	e9 42 02 00 00       	jmp    8011d0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f91:	83 c0 04             	add    $0x4,%eax
  800f94:	89 45 14             	mov    %eax,0x14(%ebp)
  800f97:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9a:	83 e8 04             	sub    $0x4,%eax
  800f9d:	8b 30                	mov    (%eax),%esi
  800f9f:	85 f6                	test   %esi,%esi
  800fa1:	75 05                	jne    800fa8 <vprintfmt+0x1a6>
				p = "(null)";
  800fa3:	be 91 4c 80 00       	mov    $0x804c91,%esi
			if (width > 0 && padc != '-')
  800fa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fac:	7e 6d                	jle    80101b <vprintfmt+0x219>
  800fae:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fb2:	74 67                	je     80101b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb7:	83 ec 08             	sub    $0x8,%esp
  800fba:	50                   	push   %eax
  800fbb:	56                   	push   %esi
  800fbc:	e8 1e 03 00 00       	call   8012df <strnlen>
  800fc1:	83 c4 10             	add    $0x10,%esp
  800fc4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fc7:	eb 16                	jmp    800fdf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fc9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fcd:	83 ec 08             	sub    $0x8,%esp
  800fd0:	ff 75 0c             	pushl  0xc(%ebp)
  800fd3:	50                   	push   %eax
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	ff d0                	call   *%eax
  800fd9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fdc:	ff 4d e4             	decl   -0x1c(%ebp)
  800fdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe3:	7f e4                	jg     800fc9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fe5:	eb 34                	jmp    80101b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fe7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800feb:	74 1c                	je     801009 <vprintfmt+0x207>
  800fed:	83 fb 1f             	cmp    $0x1f,%ebx
  800ff0:	7e 05                	jle    800ff7 <vprintfmt+0x1f5>
  800ff2:	83 fb 7e             	cmp    $0x7e,%ebx
  800ff5:	7e 12                	jle    801009 <vprintfmt+0x207>
					putch('?', putdat);
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	6a 3f                	push   $0x3f
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	ff d0                	call   *%eax
  801004:	83 c4 10             	add    $0x10,%esp
  801007:	eb 0f                	jmp    801018 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801009:	83 ec 08             	sub    $0x8,%esp
  80100c:	ff 75 0c             	pushl  0xc(%ebp)
  80100f:	53                   	push   %ebx
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	ff d0                	call   *%eax
  801015:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801018:	ff 4d e4             	decl   -0x1c(%ebp)
  80101b:	89 f0                	mov    %esi,%eax
  80101d:	8d 70 01             	lea    0x1(%eax),%esi
  801020:	8a 00                	mov    (%eax),%al
  801022:	0f be d8             	movsbl %al,%ebx
  801025:	85 db                	test   %ebx,%ebx
  801027:	74 24                	je     80104d <vprintfmt+0x24b>
  801029:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80102d:	78 b8                	js     800fe7 <vprintfmt+0x1e5>
  80102f:	ff 4d e0             	decl   -0x20(%ebp)
  801032:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801036:	79 af                	jns    800fe7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801038:	eb 13                	jmp    80104d <vprintfmt+0x24b>
				putch(' ', putdat);
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	6a 20                	push   $0x20
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	ff d0                	call   *%eax
  801047:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80104a:	ff 4d e4             	decl   -0x1c(%ebp)
  80104d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801051:	7f e7                	jg     80103a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801053:	e9 78 01 00 00       	jmp    8011d0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801058:	83 ec 08             	sub    $0x8,%esp
  80105b:	ff 75 e8             	pushl  -0x18(%ebp)
  80105e:	8d 45 14             	lea    0x14(%ebp),%eax
  801061:	50                   	push   %eax
  801062:	e8 3c fd ff ff       	call   800da3 <getint>
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801070:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801073:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801076:	85 d2                	test   %edx,%edx
  801078:	79 23                	jns    80109d <vprintfmt+0x29b>
				putch('-', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 2d                	push   $0x2d
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801090:	f7 d8                	neg    %eax
  801092:	83 d2 00             	adc    $0x0,%edx
  801095:	f7 da                	neg    %edx
  801097:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80109d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010a4:	e9 bc 00 00 00       	jmp    801165 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 84 fc ff ff       	call   800d3c <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c8:	e9 98 00 00 00       	jmp    801165 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	ff 75 0c             	pushl  0xc(%ebp)
  8010d3:	6a 58                	push   $0x58
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	ff d0                	call   *%eax
  8010da:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010dd:	83 ec 08             	sub    $0x8,%esp
  8010e0:	ff 75 0c             	pushl  0xc(%ebp)
  8010e3:	6a 58                	push   $0x58
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	ff d0                	call   *%eax
  8010ea:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 58                	push   $0x58
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			break;
  8010fd:	e9 ce 00 00 00       	jmp    8011d0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	ff 75 0c             	pushl  0xc(%ebp)
  801108:	6a 30                	push   $0x30
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	ff d0                	call   *%eax
  80110f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	ff 75 0c             	pushl  0xc(%ebp)
  801118:	6a 78                	push   $0x78
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	ff d0                	call   *%eax
  80111f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801122:	8b 45 14             	mov    0x14(%ebp),%eax
  801125:	83 c0 04             	add    $0x4,%eax
  801128:	89 45 14             	mov    %eax,0x14(%ebp)
  80112b:	8b 45 14             	mov    0x14(%ebp),%eax
  80112e:	83 e8 04             	sub    $0x4,%eax
  801131:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801133:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801136:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80113d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801144:	eb 1f                	jmp    801165 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	ff 75 e8             	pushl  -0x18(%ebp)
  80114c:	8d 45 14             	lea    0x14(%ebp),%eax
  80114f:	50                   	push   %eax
  801150:	e8 e7 fb ff ff       	call   800d3c <getuint>
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80115e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801165:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80116c:	83 ec 04             	sub    $0x4,%esp
  80116f:	52                   	push   %edx
  801170:	ff 75 e4             	pushl  -0x1c(%ebp)
  801173:	50                   	push   %eax
  801174:	ff 75 f4             	pushl  -0xc(%ebp)
  801177:	ff 75 f0             	pushl  -0x10(%ebp)
  80117a:	ff 75 0c             	pushl  0xc(%ebp)
  80117d:	ff 75 08             	pushl  0x8(%ebp)
  801180:	e8 00 fb ff ff       	call   800c85 <printnum>
  801185:	83 c4 20             	add    $0x20,%esp
			break;
  801188:	eb 46                	jmp    8011d0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80118a:	83 ec 08             	sub    $0x8,%esp
  80118d:	ff 75 0c             	pushl  0xc(%ebp)
  801190:	53                   	push   %ebx
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	ff d0                	call   *%eax
  801196:	83 c4 10             	add    $0x10,%esp
			break;
  801199:	eb 35                	jmp    8011d0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80119b:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  8011a2:	eb 2c                	jmp    8011d0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011a4:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  8011ab:	eb 23                	jmp    8011d0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011ad:	83 ec 08             	sub    $0x8,%esp
  8011b0:	ff 75 0c             	pushl  0xc(%ebp)
  8011b3:	6a 25                	push   $0x25
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	ff d0                	call   *%eax
  8011ba:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011bd:	ff 4d 10             	decl   0x10(%ebp)
  8011c0:	eb 03                	jmp    8011c5 <vprintfmt+0x3c3>
  8011c2:	ff 4d 10             	decl   0x10(%ebp)
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	48                   	dec    %eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 25                	cmp    $0x25,%al
  8011cd:	75 f3                	jne    8011c2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011cf:	90                   	nop
		}
	}
  8011d0:	e9 35 fc ff ff       	jmp    800e0a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011d5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5e                   	pop    %esi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011e3:	8d 45 10             	lea    0x10(%ebp),%eax
  8011e6:	83 c0 04             	add    $0x4,%eax
  8011e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f2:	50                   	push   %eax
  8011f3:	ff 75 0c             	pushl  0xc(%ebp)
  8011f6:	ff 75 08             	pushl  0x8(%ebp)
  8011f9:	e8 04 fc ff ff       	call   800e02 <vprintfmt>
  8011fe:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801201:	90                   	nop
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8b 40 08             	mov    0x8(%eax),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	8b 10                	mov    (%eax),%edx
  80121b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121e:	8b 40 04             	mov    0x4(%eax),%eax
  801221:	39 c2                	cmp    %eax,%edx
  801223:	73 12                	jae    801237 <sprintputch+0x33>
		*b->buf++ = ch;
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	8b 00                	mov    (%eax),%eax
  80122a:	8d 48 01             	lea    0x1(%eax),%ecx
  80122d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801230:	89 0a                	mov    %ecx,(%edx)
  801232:	8b 55 08             	mov    0x8(%ebp),%edx
  801235:	88 10                	mov    %dl,(%eax)
}
  801237:	90                   	nop
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	8d 50 ff             	lea    -0x1(%eax),%edx
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80125b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125f:	74 06                	je     801267 <vsnprintf+0x2d>
  801261:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801265:	7f 07                	jg     80126e <vsnprintf+0x34>
		return -E_INVAL;
  801267:	b8 03 00 00 00       	mov    $0x3,%eax
  80126c:	eb 20                	jmp    80128e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80126e:	ff 75 14             	pushl  0x14(%ebp)
  801271:	ff 75 10             	pushl  0x10(%ebp)
  801274:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801277:	50                   	push   %eax
  801278:	68 04 12 80 00       	push   $0x801204
  80127d:	e8 80 fb ff ff       	call   800e02 <vprintfmt>
  801282:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801288:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80128b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801296:	8d 45 10             	lea    0x10(%ebp),%eax
  801299:	83 c0 04             	add    $0x4,%eax
  80129c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012a5:	50                   	push   %eax
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 89 ff ff ff       	call   80123a <vsnprintf>
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014b6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014ba:	76 63                	jbe    80151f <memset+0x75>
		uint64 data_block = c;
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	99                   	cltd   
  8014c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cc:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014d0:	c1 e0 08             	shl    $0x8,%eax
  8014d3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014d6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014df:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8014e3:	c1 e0 10             	shl    $0x10,%eax
  8014e6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014e9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8014ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f9:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014fc:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8014ff:	eb 18                	jmp    801519 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801501:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801504:	8d 41 08             	lea    0x8(%ecx),%eax
  801507:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80150a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801510:	89 01                	mov    %eax,(%ecx)
  801512:	89 51 04             	mov    %edx,0x4(%ecx)
  801515:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801519:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80151d:	77 e2                	ja     801501 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80151f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801523:	74 23                	je     801548 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801528:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80152b:	eb 0e                	jmp    80153b <memset+0x91>
			*p8++ = (uint8)c;
  80152d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801530:	8d 50 01             	lea    0x1(%eax),%edx
  801533:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801536:	8b 55 0c             	mov    0xc(%ebp),%edx
  801539:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801541:	89 55 10             	mov    %edx,0x10(%ebp)
  801544:	85 c0                	test   %eax,%eax
  801546:	75 e5                	jne    80152d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80155f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801563:	76 24                	jbe    801589 <memcpy+0x3c>
		while(n >= 8){
  801565:	eb 1c                	jmp    801583 <memcpy+0x36>
			*d64 = *s64;
  801567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156a:	8b 50 04             	mov    0x4(%eax),%edx
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801572:	89 01                	mov    %eax,(%ecx)
  801574:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801577:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80157b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80157f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801583:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801587:	77 de                	ja     801567 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801589:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158d:	74 31                	je     8015c0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801595:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801598:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80159b:	eb 16                	jmp    8015b3 <memcpy+0x66>
			*d8++ = *s8++;
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a0:	8d 50 01             	lea    0x1(%eax),%edx
  8015a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ac:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015af:	8a 12                	mov    (%edx),%dl
  8015b1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	75 dd                	jne    80159d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dd:	73 50                	jae    80162f <memmove+0x6a>
  8015df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e5:	01 d0                	add    %edx,%eax
  8015e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015ea:	76 43                	jbe    80162f <memmove+0x6a>
		s += n;
  8015ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015f8:	eb 10                	jmp    80160a <memmove+0x45>
			*--d = *--s;
  8015fa:	ff 4d f8             	decl   -0x8(%ebp)
  8015fd:	ff 4d fc             	decl   -0x4(%ebp)
  801600:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801603:	8a 10                	mov    (%eax),%dl
  801605:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801608:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80160a:	8b 45 10             	mov    0x10(%ebp),%eax
  80160d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801610:	89 55 10             	mov    %edx,0x10(%ebp)
  801613:	85 c0                	test   %eax,%eax
  801615:	75 e3                	jne    8015fa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801617:	eb 23                	jmp    80163c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801619:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801622:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80162f:	8b 45 10             	mov    0x10(%ebp),%eax
  801632:	8d 50 ff             	lea    -0x1(%eax),%edx
  801635:	89 55 10             	mov    %edx,0x10(%ebp)
  801638:	85 c0                	test   %eax,%eax
  80163a:	75 dd                	jne    801619 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80164d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801650:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801653:	eb 2a                	jmp    80167f <memcmp+0x3e>
		if (*s1 != *s2)
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 10                	mov    (%eax),%dl
  80165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	38 c2                	cmp    %al,%dl
  801661:	74 16                	je     801679 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801663:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	0f b6 d0             	movzbl %al,%edx
  80166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	0f b6 c0             	movzbl %al,%eax
  801673:	29 c2                	sub    %eax,%edx
  801675:	89 d0                	mov    %edx,%eax
  801677:	eb 18                	jmp    801691 <memcmp+0x50>
		s1++, s2++;
  801679:	ff 45 fc             	incl   -0x4(%ebp)
  80167c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80167f:	8b 45 10             	mov    0x10(%ebp),%eax
  801682:	8d 50 ff             	lea    -0x1(%eax),%edx
  801685:	89 55 10             	mov    %edx,0x10(%ebp)
  801688:	85 c0                	test   %eax,%eax
  80168a:	75 c9                	jne    801655 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801699:	8b 55 08             	mov    0x8(%ebp),%edx
  80169c:	8b 45 10             	mov    0x10(%ebp),%eax
  80169f:	01 d0                	add    %edx,%eax
  8016a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016a4:	eb 15                	jmp    8016bb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	0f b6 d0             	movzbl %al,%edx
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	0f b6 c0             	movzbl %al,%eax
  8016b4:	39 c2                	cmp    %eax,%edx
  8016b6:	74 0d                	je     8016c5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016c1:	72 e3                	jb     8016a6 <memfind+0x13>
  8016c3:	eb 01                	jmp    8016c6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016c5:	90                   	nop
	return (void *) s;
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016df:	eb 03                	jmp    8016e4 <strtol+0x19>
		s++;
  8016e1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8a 00                	mov    (%eax),%al
  8016e9:	3c 20                	cmp    $0x20,%al
  8016eb:	74 f4                	je     8016e1 <strtol+0x16>
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	3c 09                	cmp    $0x9,%al
  8016f4:	74 eb                	je     8016e1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2b                	cmp    $0x2b,%al
  8016fd:	75 05                	jne    801704 <strtol+0x39>
		s++;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	eb 13                	jmp    801717 <strtol+0x4c>
	else if (*s == '-')
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	3c 2d                	cmp    $0x2d,%al
  80170b:	75 0a                	jne    801717 <strtol+0x4c>
		s++, neg = 1;
  80170d:	ff 45 08             	incl   0x8(%ebp)
  801710:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801717:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171b:	74 06                	je     801723 <strtol+0x58>
  80171d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801721:	75 20                	jne    801743 <strtol+0x78>
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	3c 30                	cmp    $0x30,%al
  80172a:	75 17                	jne    801743 <strtol+0x78>
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	40                   	inc    %eax
  801730:	8a 00                	mov    (%eax),%al
  801732:	3c 78                	cmp    $0x78,%al
  801734:	75 0d                	jne    801743 <strtol+0x78>
		s += 2, base = 16;
  801736:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80173a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801741:	eb 28                	jmp    80176b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801743:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801747:	75 15                	jne    80175e <strtol+0x93>
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	3c 30                	cmp    $0x30,%al
  801750:	75 0c                	jne    80175e <strtol+0x93>
		s++, base = 8;
  801752:	ff 45 08             	incl   0x8(%ebp)
  801755:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80175c:	eb 0d                	jmp    80176b <strtol+0xa0>
	else if (base == 0)
  80175e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801762:	75 07                	jne    80176b <strtol+0xa0>
		base = 10;
  801764:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	8a 00                	mov    (%eax),%al
  801770:	3c 2f                	cmp    $0x2f,%al
  801772:	7e 19                	jle    80178d <strtol+0xc2>
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	8a 00                	mov    (%eax),%al
  801779:	3c 39                	cmp    $0x39,%al
  80177b:	7f 10                	jg     80178d <strtol+0xc2>
			dig = *s - '0';
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8a 00                	mov    (%eax),%al
  801782:	0f be c0             	movsbl %al,%eax
  801785:	83 e8 30             	sub    $0x30,%eax
  801788:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80178b:	eb 42                	jmp    8017cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3c 60                	cmp    $0x60,%al
  801794:	7e 19                	jle    8017af <strtol+0xe4>
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	3c 7a                	cmp    $0x7a,%al
  80179d:	7f 10                	jg     8017af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	0f be c0             	movsbl %al,%eax
  8017a7:	83 e8 57             	sub    $0x57,%eax
  8017aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ad:	eb 20                	jmp    8017cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8a 00                	mov    (%eax),%al
  8017b4:	3c 40                	cmp    $0x40,%al
  8017b6:	7e 39                	jle    8017f1 <strtol+0x126>
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	3c 5a                	cmp    $0x5a,%al
  8017bf:	7f 30                	jg     8017f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	0f be c0             	movsbl %al,%eax
  8017c9:	83 e8 37             	sub    $0x37,%eax
  8017cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017d5:	7d 19                	jge    8017f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017d7:	ff 45 08             	incl   0x8(%ebp)
  8017da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017e1:	89 c2                	mov    %eax,%edx
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017eb:	e9 7b ff ff ff       	jmp    80176b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017f5:	74 08                	je     8017ff <strtol+0x134>
		*endptr = (char *) s;
  8017f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801803:	74 07                	je     80180c <strtol+0x141>
  801805:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801808:	f7 d8                	neg    %eax
  80180a:	eb 03                	jmp    80180f <strtol+0x144>
  80180c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <ltostr>:

void
ltostr(long value, char *str)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801817:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80181e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801825:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801829:	79 13                	jns    80183e <ltostr+0x2d>
	{
		neg = 1;
  80182b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801832:	8b 45 0c             	mov    0xc(%ebp),%eax
  801835:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801838:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80183b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801846:	99                   	cltd   
  801847:	f7 f9                	idiv   %ecx
  801849:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80184c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184f:	8d 50 01             	lea    0x1(%eax),%edx
  801852:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801855:	89 c2                	mov    %eax,%edx
  801857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80185f:	83 c2 30             	add    $0x30,%edx
  801862:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801864:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801867:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80186c:	f7 e9                	imul   %ecx
  80186e:	c1 fa 02             	sar    $0x2,%edx
  801871:	89 c8                	mov    %ecx,%eax
  801873:	c1 f8 1f             	sar    $0x1f,%eax
  801876:	29 c2                	sub    %eax,%edx
  801878:	89 d0                	mov    %edx,%eax
  80187a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80187d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801881:	75 bb                	jne    80183e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80188a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188d:	48                   	dec    %eax
  80188e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801891:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801895:	74 3d                	je     8018d4 <ltostr+0xc3>
		start = 1 ;
  801897:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80189e:	eb 34                	jmp    8018d4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a6:	01 d0                	add    %edx,%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b3:	01 c2                	add    %eax,%edx
  8018b5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bb:	01 c8                	add    %ecx,%eax
  8018bd:	8a 00                	mov    (%eax),%al
  8018bf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c7:	01 c2                	add    %eax,%edx
  8018c9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018cc:	88 02                	mov    %al,(%edx)
		start++ ;
  8018ce:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018d1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018da:	7c c4                	jl     8018a0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018e7:	90                   	nop
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 c4 f9 ff ff       	call   8012bc <strlen>
  8018f8:	83 c4 04             	add    $0x4,%esp
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b6 f9 ff ff       	call   8012bc <strlen>
  801906:	83 c4 04             	add    $0x4,%esp
  801909:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80190c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801913:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80191a:	eb 17                	jmp    801933 <strcconcat+0x49>
		final[s] = str1[s] ;
  80191c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 c2                	add    %eax,%edx
  801924:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	01 c8                	add    %ecx,%eax
  80192c:	8a 00                	mov    (%eax),%al
  80192e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801930:	ff 45 fc             	incl   -0x4(%ebp)
  801933:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801936:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801939:	7c e1                	jl     80191c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80193b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801942:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801949:	eb 1f                	jmp    80196a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194e:	8d 50 01             	lea    0x1(%eax),%edx
  801951:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 10             	mov    0x10(%ebp),%eax
  801959:	01 c2                	add    %eax,%edx
  80195b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	01 c8                	add    %ecx,%eax
  801963:	8a 00                	mov    (%eax),%al
  801965:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801967:	ff 45 f8             	incl   -0x8(%ebp)
  80196a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80196d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801970:	7c d9                	jl     80194b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801972:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801975:	8b 45 10             	mov    0x10(%ebp),%eax
  801978:	01 d0                	add    %edx,%eax
  80197a:	c6 00 00             	movb   $0x0,(%eax)
}
  80197d:	90                   	nop
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801983:	8b 45 14             	mov    0x14(%ebp),%eax
  801986:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80198c:	8b 45 14             	mov    0x14(%ebp),%eax
  80198f:	8b 00                	mov    (%eax),%eax
  801991:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801998:	8b 45 10             	mov    0x10(%ebp),%eax
  80199b:	01 d0                	add    %edx,%eax
  80199d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019a3:	eb 0c                	jmp    8019b1 <strsplit+0x31>
			*string++ = 0;
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8d 50 01             	lea    0x1(%eax),%edx
  8019ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8019ae:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	8a 00                	mov    (%eax),%al
  8019b6:	84 c0                	test   %al,%al
  8019b8:	74 18                	je     8019d2 <strsplit+0x52>
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8a 00                	mov    (%eax),%al
  8019bf:	0f be c0             	movsbl %al,%eax
  8019c2:	50                   	push   %eax
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	e8 83 fa ff ff       	call   80144e <strchr>
  8019cb:	83 c4 08             	add    $0x8,%esp
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	75 d3                	jne    8019a5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	8a 00                	mov    (%eax),%al
  8019d7:	84 c0                	test   %al,%al
  8019d9:	74 5a                	je     801a35 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019db:	8b 45 14             	mov    0x14(%ebp),%eax
  8019de:	8b 00                	mov    (%eax),%eax
  8019e0:	83 f8 0f             	cmp    $0xf,%eax
  8019e3:	75 07                	jne    8019ec <strsplit+0x6c>
		{
			return 0;
  8019e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ea:	eb 66                	jmp    801a52 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8019f4:	8b 55 14             	mov    0x14(%ebp),%edx
  8019f7:	89 0a                	mov    %ecx,(%edx)
  8019f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	01 c2                	add    %eax,%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a0a:	eb 03                	jmp    801a0f <strsplit+0x8f>
			string++;
  801a0c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8a 00                	mov    (%eax),%al
  801a14:	84 c0                	test   %al,%al
  801a16:	74 8b                	je     8019a3 <strsplit+0x23>
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	0f be c0             	movsbl %al,%eax
  801a20:	50                   	push   %eax
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	e8 25 fa ff ff       	call   80144e <strchr>
  801a29:	83 c4 08             	add    $0x8,%esp
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	74 dc                	je     801a0c <strsplit+0x8c>
			string++;
	}
  801a30:	e9 6e ff ff ff       	jmp    8019a3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a35:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a36:	8b 45 14             	mov    0x14(%ebp),%eax
  801a39:	8b 00                	mov    (%eax),%eax
  801a3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a42:	8b 45 10             	mov    0x10(%ebp),%eax
  801a45:	01 d0                	add    %edx,%eax
  801a47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a4d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a67:	eb 4a                	jmp    801ab3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	01 c2                	add    %eax,%edx
  801a71:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a77:	01 c8                	add    %ecx,%eax
  801a79:	8a 00                	mov    (%eax),%al
  801a7b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a83:	01 d0                	add    %edx,%eax
  801a85:	8a 00                	mov    (%eax),%al
  801a87:	3c 40                	cmp    $0x40,%al
  801a89:	7e 25                	jle    801ab0 <str2lower+0x5c>
  801a8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a91:	01 d0                	add    %edx,%eax
  801a93:	8a 00                	mov    (%eax),%al
  801a95:	3c 5a                	cmp    $0x5a,%al
  801a97:	7f 17                	jg     801ab0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801a99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	01 d0                	add    %edx,%eax
  801aa1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa7:	01 ca                	add    %ecx,%edx
  801aa9:	8a 12                	mov    (%edx),%dl
  801aab:	83 c2 20             	add    $0x20,%edx
  801aae:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ab0:	ff 45 fc             	incl   -0x4(%ebp)
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	e8 01 f8 ff ff       	call   8012bc <strlen>
  801abb:	83 c4 04             	add    $0x4,%esp
  801abe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ac1:	7f a6                	jg     801a69 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801ace:	a1 08 60 80 00       	mov    0x806008,%eax
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	74 42                	je     801b19 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801ad7:	83 ec 08             	sub    $0x8,%esp
  801ada:	68 00 00 00 82       	push   $0x82000000
  801adf:	68 00 00 00 80       	push   $0x80000000
  801ae4:	e8 b0 1e 00 00       	call   803999 <initialize_dynamic_allocator>
  801ae9:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801aec:	e8 96 1c 00 00       	call   803787 <sys_get_uheap_strategy>
  801af1:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801af6:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801afb:	05 00 10 00 00       	add    $0x1000,%eax
  801b00:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801b05:	a1 30 61 83 00       	mov    0x836130,%eax
  801b0a:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801b0f:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801b16:	00 00 00 
	}
}
  801b19:	90                   	nop
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b30:	83 ec 08             	sub    $0x8,%esp
  801b33:	68 06 04 00 00       	push   $0x406
  801b38:	50                   	push   %eax
  801b39:	e8 93 18 00 00       	call   8033d1 <__sys_allocate_page>
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b48:	79 14                	jns    801b5e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	68 08 4e 80 00       	push   $0x804e08
  801b52:	6a 1f                	push   $0x1f
  801b54:	68 44 4e 80 00       	push   $0x804e44
  801b59:	e8 b7 ed ff ff       	call   800915 <_panic>
	return 0;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	50                   	push   %eax
  801b7d:	e8 96 18 00 00       	call   803418 <__sys_unmap_frame>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b8c:	79 14                	jns    801ba2 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	68 50 4e 80 00       	push   $0x804e50
  801b96:	6a 2a                	push   $0x2a
  801b98:	68 44 4e 80 00       	push   $0x804e44
  801b9d:	e8 73 ed ff ff       	call   800915 <_panic>
}
  801ba2:	90                   	nop
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bab:	e8 18 ff ff ff       	call   801ac8 <uheap_init>
	if (size == 0) return NULL ;
  801bb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bb4:	75 0a                	jne    801bc0 <malloc+0x1b>
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbb:	e9 43 03 00 00       	jmp    801f03 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801bc0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801bc7:	77 13                	ja     801bdc <malloc+0x37>
    {
        return alloc_block(size);
  801bc9:	83 ec 0c             	sub    $0xc,%esp
  801bcc:	ff 75 08             	pushl  0x8(%ebp)
  801bcf:	e8 78 20 00 00       	call   803c4c <alloc_block>
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	e9 27 03 00 00       	jmp    801f03 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801bdc:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801be3:	8b 55 08             	mov    0x8(%ebp),%edx
  801be6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	48                   	dec    %eax
  801bec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801bef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf7:	f7 75 dc             	divl   -0x24(%ebp)
  801bfa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bfd:	29 d0                	sub    %edx,%eax
  801bff:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801c02:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801c07:	85 c0                	test   %eax,%eax
  801c09:	75 0a                	jne    801c15 <malloc+0x70>
    {
        uhp_inited = 1;
  801c0b:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801c12:	00 00 00 
    }

    int exactIdx = -1;
  801c15:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801c1c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801c23:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801c31:	e9 85 00 00 00       	jmp    801cbb <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801c36:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c39:	89 d0                	mov    %edx,%eax
  801c3b:	01 c0                	add    %eax,%eax
  801c3d:	01 d0                	add    %edx,%eax
  801c3f:	c1 e0 02             	shl    $0x2,%eax
  801c42:	05 48 20 81 00       	add    $0x812048,%eax
  801c47:	8a 00                	mov    (%eax),%al
  801c49:	84 c0                	test   %al,%al
  801c4b:	74 20                	je     801c6d <malloc+0xc8>
  801c4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c50:	89 d0                	mov    %edx,%eax
  801c52:	01 c0                	add    %eax,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	c1 e0 02             	shl    $0x2,%eax
  801c59:	05 44 20 81 00       	add    $0x812044,%eax
  801c5e:	8b 00                	mov    (%eax),%eax
  801c60:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c63:	75 08                	jne    801c6d <malloc+0xc8>
        {
            exactIdx = i;
  801c65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801c6b:	eb 5b                	jmp    801cc8 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801c6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c70:	89 d0                	mov    %edx,%eax
  801c72:	01 c0                	add    %eax,%eax
  801c74:	01 d0                	add    %edx,%eax
  801c76:	c1 e0 02             	shl    $0x2,%eax
  801c79:	05 48 20 81 00       	add    $0x812048,%eax
  801c7e:	8a 00                	mov    (%eax),%al
  801c80:	84 c0                	test   %al,%al
  801c82:	74 34                	je     801cb8 <malloc+0x113>
  801c84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c87:	89 d0                	mov    %edx,%eax
  801c89:	01 c0                	add    %eax,%eax
  801c8b:	01 d0                	add    %edx,%eax
  801c8d:	c1 e0 02             	shl    $0x2,%eax
  801c90:	05 44 20 81 00       	add    $0x812044,%eax
  801c95:	8b 00                	mov    (%eax),%eax
  801c97:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801c9a:	76 1c                	jbe    801cb8 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801c9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c9f:	89 d0                	mov    %edx,%eax
  801ca1:	01 c0                	add    %eax,%eax
  801ca3:	01 d0                	add    %edx,%eax
  801ca5:	c1 e0 02             	shl    $0x2,%eax
  801ca8:	05 44 20 81 00       	add    $0x812044,%eax
  801cad:	8b 00                	mov    (%eax),%eax
  801caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cb8:	ff 45 e8             	incl   -0x18(%ebp)
  801cbb:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801cc2:	0f 8e 6e ff ff ff    	jle    801c36 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801cc8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801ccf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801cd3:	74 7d                	je     801d52 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801cd5:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801cdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cdf:	89 d0                	mov    %edx,%eax
  801ce1:	01 c0                	add    %eax,%eax
  801ce3:	01 d0                	add    %edx,%eax
  801ce5:	c1 e0 02             	shl    $0x2,%eax
  801ce8:	05 40 20 81 00       	add    $0x812040,%eax
  801ced:	8b 10                	mov    (%eax),%edx
  801cef:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	48                   	dec    %eax
  801cf5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801cf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801d00:	f7 75 bc             	divl   -0x44(%ebp)
  801d03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d06:	29 d0                	sub    %edx,%eax
  801d08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0e:	89 d0                	mov    %edx,%eax
  801d10:	01 c0                	add    %eax,%eax
  801d12:	01 d0                	add    %edx,%eax
  801d14:	c1 e0 02             	shl    $0x2,%eax
  801d17:	05 48 20 81 00       	add    $0x812048,%eax
  801d1c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801d1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d22:	89 d0                	mov    %edx,%eax
  801d24:	01 c0                	add    %eax,%eax
  801d26:	01 d0                	add    %edx,%eax
  801d28:	c1 e0 02             	shl    $0x2,%eax
  801d2b:	05 44 20 81 00       	add    $0x812044,%eax
  801d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d39:	89 d0                	mov    %edx,%eax
  801d3b:	01 c0                	add    %eax,%eax
  801d3d:	01 d0                	add    %edx,%eax
  801d3f:	c1 e0 02             	shl    $0x2,%eax
  801d42:	05 40 20 81 00       	add    $0x812040,%eax
  801d47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d4d:	e9 2d 01 00 00       	jmp    801e7f <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801d52:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d56:	0f 84 ce 00 00 00    	je     801e2a <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801d5c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801d63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d66:	89 d0                	mov    %edx,%eax
  801d68:	01 c0                	add    %eax,%eax
  801d6a:	01 d0                	add    %edx,%eax
  801d6c:	c1 e0 02             	shl    $0x2,%eax
  801d6f:	05 40 20 81 00       	add    $0x812040,%eax
  801d74:	8b 10                	mov    (%eax),%edx
  801d76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d79:	01 d0                	add    %edx,%eax
  801d7b:	48                   	dec    %eax
  801d7c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801d7f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d82:	ba 00 00 00 00       	mov    $0x0,%edx
  801d87:	f7 75 c4             	divl   -0x3c(%ebp)
  801d8a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d8d:	29 d0                	sub    %edx,%eax
  801d8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801d92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d95:	89 d0                	mov    %edx,%eax
  801d97:	01 c0                	add    %eax,%eax
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	c1 e0 02             	shl    $0x2,%eax
  801d9e:	05 44 20 81 00       	add    $0x812044,%eax
  801da3:	8b 00                	mov    (%eax),%eax
  801da5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801da8:	75 47                	jne    801df1 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801daa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dad:	89 d0                	mov    %edx,%eax
  801daf:	01 c0                	add    %eax,%eax
  801db1:	01 d0                	add    %edx,%eax
  801db3:	c1 e0 02             	shl    $0x2,%eax
  801db6:	05 48 20 81 00       	add    $0x812048,%eax
  801dbb:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc1:	89 d0                	mov    %edx,%eax
  801dc3:	01 c0                	add    %eax,%eax
  801dc5:	01 d0                	add    %edx,%eax
  801dc7:	c1 e0 02             	shl    $0x2,%eax
  801dca:	05 44 20 81 00       	add    $0x812044,%eax
  801dcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801dd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd8:	89 d0                	mov    %edx,%eax
  801dda:	01 c0                	add    %eax,%eax
  801ddc:	01 d0                	add    %edx,%eax
  801dde:	c1 e0 02             	shl    $0x2,%eax
  801de1:	05 40 20 81 00       	add    $0x812040,%eax
  801de6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dec:	e9 8e 00 00 00       	jmp    801e7f <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801df1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801df4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801dfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dfd:	89 d0                	mov    %edx,%eax
  801dff:	01 c0                	add    %eax,%eax
  801e01:	01 d0                	add    %edx,%eax
  801e03:	c1 e0 02             	shl    $0x2,%eax
  801e06:	05 40 20 81 00       	add    $0x812040,%eax
  801e0b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e10:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e13:	89 c2                	mov    %eax,%edx
  801e15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e18:	89 c8                	mov    %ecx,%eax
  801e1a:	01 c0                	add    %eax,%eax
  801e1c:	01 c8                	add    %ecx,%eax
  801e1e:	c1 e0 02             	shl    $0x2,%eax
  801e21:	05 44 20 81 00       	add    $0x812044,%eax
  801e26:	89 10                	mov    %edx,(%eax)
  801e28:	eb 55                	jmp    801e7f <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801e2a:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e31:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801e37:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e3a:	01 d0                	add    %edx,%eax
  801e3c:	48                   	dec    %eax
  801e3d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e43:	ba 00 00 00 00       	mov    $0x0,%edx
  801e48:	f7 75 d0             	divl   -0x30(%ebp)
  801e4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e4e:	29 d0                	sub    %edx,%eax
  801e50:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801e53:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801e56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e59:	01 d0                	add    %edx,%eax
  801e5b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801e60:	76 0a                	jbe    801e6c <malloc+0x2c7>
            return NULL;
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
  801e67:	e9 97 00 00 00       	jmp    801f03 <malloc+0x35e>
        va = start;
  801e6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801e72:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801e75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e78:	01 d0                	add    %edx,%eax
  801e7a:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e7f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801e86:	eb 5e                	jmp    801ee6 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801e88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e8b:	89 d0                	mov    %edx,%eax
  801e8d:	01 c0                	add    %eax,%eax
  801e8f:	01 d0                	add    %edx,%eax
  801e91:	c1 e0 02             	shl    $0x2,%eax
  801e94:	05 48 60 80 00       	add    $0x806048,%eax
  801e99:	8a 00                	mov    (%eax),%al
  801e9b:	84 c0                	test   %al,%al
  801e9d:	75 44                	jne    801ee3 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801e9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ea2:	89 d0                	mov    %edx,%eax
  801ea4:	01 c0                	add    %eax,%eax
  801ea6:	01 d0                	add    %edx,%eax
  801ea8:	c1 e0 02             	shl    $0x2,%eax
  801eab:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eb4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801eb6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb9:	89 d0                	mov    %edx,%eax
  801ebb:	01 c0                	add    %eax,%eax
  801ebd:	01 d0                	add    %edx,%eax
  801ebf:	c1 e0 02             	shl    $0x2,%eax
  801ec2:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801ec8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ecb:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801ecd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ed0:	89 d0                	mov    %edx,%eax
  801ed2:	01 c0                	add    %eax,%eax
  801ed4:	01 d0                	add    %edx,%eax
  801ed6:	c1 e0 02             	shl    $0x2,%eax
  801ed9:	05 48 60 80 00       	add    $0x806048,%eax
  801ede:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801ee1:	eb 0c                	jmp    801eef <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ee3:	ff 45 e0             	incl   -0x20(%ebp)
  801ee6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801eed:	7e 99                	jle    801e88 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801eef:	83 ec 08             	sub    $0x8,%esp
  801ef2:	ff 75 d4             	pushl  -0x2c(%ebp)
  801ef5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ef8:	e8 a2 19 00 00       	call   80389f <sys_allocate_user_mem>
  801efd:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801f00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801f0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f0f:	0f 84 fa 03 00 00    	je     80230f <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801f1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	79 1c                	jns    801f3e <free+0x39>
  801f22:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801f29:	77 13                	ja     801f3e <free+0x39>
    {
        free_block(virtual_address);
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	ff 75 08             	pushl  0x8(%ebp)
  801f31:	e8 09 21 00 00       	call   80403f <free_block>
  801f36:	83 c4 10             	add    $0x10,%esp
        return;
  801f39:	e9 d2 03 00 00       	jmp    802310 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801f3e:	a1 30 61 83 00       	mov    0x836130,%eax
  801f43:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801f46:	72 09                	jb     801f51 <free+0x4c>
  801f48:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801f4f:	76 17                	jbe    801f68 <free+0x63>
        panic("free: invalid address");
  801f51:	83 ec 04             	sub    $0x4,%esp
  801f54:	68 8d 4e 80 00       	push   $0x804e8d
  801f59:	68 9b 00 00 00       	push   $0x9b
  801f5e:	68 44 4e 80 00       	push   $0x804e44
  801f63:	e8 ad e9 ff ff       	call   800915 <_panic>

    uint32 size = 0;
  801f68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801f6f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f7d:	eb 50                	jmp    801fcf <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801f7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f82:	89 d0                	mov    %edx,%eax
  801f84:	01 c0                	add    %eax,%eax
  801f86:	01 d0                	add    %edx,%eax
  801f88:	c1 e0 02             	shl    $0x2,%eax
  801f8b:	05 48 60 80 00       	add    $0x806048,%eax
  801f90:	8a 00                	mov    (%eax),%al
  801f92:	84 c0                	test   %al,%al
  801f94:	74 36                	je     801fcc <free+0xc7>
  801f96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f99:	89 d0                	mov    %edx,%eax
  801f9b:	01 c0                	add    %eax,%eax
  801f9d:	01 d0                	add    %edx,%eax
  801f9f:	c1 e0 02             	shl    $0x2,%eax
  801fa2:	05 40 60 80 00       	add    $0x806040,%eax
  801fa7:	8b 00                	mov    (%eax),%eax
  801fa9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fac:	75 1e                	jne    801fcc <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801fae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fb1:	89 d0                	mov    %edx,%eax
  801fb3:	01 c0                	add    %eax,%eax
  801fb5:	01 d0                	add    %edx,%eax
  801fb7:	c1 e0 02             	shl    $0x2,%eax
  801fba:	05 44 60 80 00       	add    $0x806044,%eax
  801fbf:	8b 00                	mov    (%eax),%eax
  801fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801fca:	eb 0c                	jmp    801fd8 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fcc:	ff 45 ec             	incl   -0x14(%ebp)
  801fcf:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801fd6:	7e a7                	jle    801f7f <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801fd8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801fdc:	74 06                	je     801fe4 <free+0xdf>
  801fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe2:	75 17                	jne    801ffb <free+0xf6>
        panic("free: unknown block");
  801fe4:	83 ec 04             	sub    $0x4,%esp
  801fe7:	68 a3 4e 80 00       	push   $0x804ea3
  801fec:	68 a9 00 00 00       	push   $0xa9
  801ff1:	68 44 4e 80 00       	push   $0x804e44
  801ff6:	e8 1a e9 ff ff       	call   800915 <_panic>

    uhp_allocs[idx].used = 0;
  801ffb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ffe:	89 d0                	mov    %edx,%eax
  802000:	01 c0                	add    %eax,%eax
  802002:	01 d0                	add    %edx,%eax
  802004:	c1 e0 02             	shl    $0x2,%eax
  802007:	05 48 60 80 00       	add    $0x806048,%eax
  80200c:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  80200f:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802016:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80201d:	eb 64                	jmp    802083 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  80201f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802022:	89 d0                	mov    %edx,%eax
  802024:	01 c0                	add    %eax,%eax
  802026:	01 d0                	add    %edx,%eax
  802028:	c1 e0 02             	shl    $0x2,%eax
  80202b:	05 48 20 81 00       	add    $0x812048,%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	84 c0                	test   %al,%al
  802034:	75 4a                	jne    802080 <free+0x17b>
        {
            uhp_frees[i].va = va;
  802036:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802039:	89 d0                	mov    %edx,%eax
  80203b:	01 c0                	add    %eax,%eax
  80203d:	01 d0                	add    %edx,%eax
  80203f:	c1 e0 02             	shl    $0x2,%eax
  802042:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802048:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80204b:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  80204d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802050:	89 d0                	mov    %edx,%eax
  802052:	01 c0                	add    %eax,%eax
  802054:	01 d0                	add    %edx,%eax
  802056:	c1 e0 02             	shl    $0x2,%eax
  802059:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  802064:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802067:	89 d0                	mov    %edx,%eax
  802069:	01 c0                	add    %eax,%eax
  80206b:	01 d0                	add    %edx,%eax
  80206d:	c1 e0 02             	shl    $0x2,%eax
  802070:	05 48 20 81 00       	add    $0x812048,%eax
  802075:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80207b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  80207e:	eb 0c                	jmp    80208c <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802080:	ff 45 e4             	incl   -0x1c(%ebp)
  802083:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80208a:	7e 93                	jle    80201f <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  80208c:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802090:	0f 84 f1 01 00 00    	je     802287 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802096:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80209d:	e9 d8 01 00 00       	jmp    80227a <free+0x375>
        {
            if (i == fidx) continue;
  8020a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020a8:	0f 84 c8 01 00 00    	je     802276 <free+0x371>
            if (uhp_frees[i].free)
  8020ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020b1:	89 d0                	mov    %edx,%eax
  8020b3:	01 c0                	add    %eax,%eax
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	c1 e0 02             	shl    $0x2,%eax
  8020ba:	05 48 20 81 00       	add    $0x812048,%eax
  8020bf:	8a 00                	mov    (%eax),%al
  8020c1:	84 c0                	test   %al,%al
  8020c3:	0f 84 ae 01 00 00    	je     802277 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  8020c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020cc:	89 d0                	mov    %edx,%eax
  8020ce:	01 c0                	add    %eax,%eax
  8020d0:	01 d0                	add    %edx,%eax
  8020d2:	c1 e0 02             	shl    $0x2,%eax
  8020d5:	05 40 20 81 00       	add    $0x812040,%eax
  8020da:	8b 08                	mov    (%eax),%ecx
  8020dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020df:	89 d0                	mov    %edx,%eax
  8020e1:	01 c0                	add    %eax,%eax
  8020e3:	01 d0                	add    %edx,%eax
  8020e5:	c1 e0 02             	shl    $0x2,%eax
  8020e8:	05 44 20 81 00       	add    $0x812044,%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	01 c1                	add    %eax,%ecx
  8020f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020f4:	89 d0                	mov    %edx,%eax
  8020f6:	01 c0                	add    %eax,%eax
  8020f8:	01 d0                	add    %edx,%eax
  8020fa:	c1 e0 02             	shl    $0x2,%eax
  8020fd:	05 40 20 81 00       	add    $0x812040,%eax
  802102:	8b 00                	mov    (%eax),%eax
  802104:	39 c1                	cmp    %eax,%ecx
  802106:	0f 85 a8 00 00 00    	jne    8021b4 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  80210c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80210f:	89 d0                	mov    %edx,%eax
  802111:	01 c0                	add    %eax,%eax
  802113:	01 d0                	add    %edx,%eax
  802115:	c1 e0 02             	shl    $0x2,%eax
  802118:	05 40 20 81 00       	add    $0x812040,%eax
  80211d:	8b 10                	mov    (%eax),%edx
  80211f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802122:	89 c8                	mov    %ecx,%eax
  802124:	01 c0                	add    %eax,%eax
  802126:	01 c8                	add    %ecx,%eax
  802128:	c1 e0 02             	shl    $0x2,%eax
  80212b:	05 40 20 81 00       	add    $0x812040,%eax
  802130:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802135:	89 d0                	mov    %edx,%eax
  802137:	01 c0                	add    %eax,%eax
  802139:	01 d0                	add    %edx,%eax
  80213b:	c1 e0 02             	shl    $0x2,%eax
  80213e:	05 44 20 81 00       	add    $0x812044,%eax
  802143:	8b 08                	mov    (%eax),%ecx
  802145:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802148:	89 d0                	mov    %edx,%eax
  80214a:	01 c0                	add    %eax,%eax
  80214c:	01 d0                	add    %edx,%eax
  80214e:	c1 e0 02             	shl    $0x2,%eax
  802151:	05 44 20 81 00       	add    $0x812044,%eax
  802156:	8b 00                	mov    (%eax),%eax
  802158:	01 c1                	add    %eax,%ecx
  80215a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80215d:	89 d0                	mov    %edx,%eax
  80215f:	01 c0                	add    %eax,%eax
  802161:	01 d0                	add    %edx,%eax
  802163:	c1 e0 02             	shl    $0x2,%eax
  802166:	05 44 20 81 00       	add    $0x812044,%eax
  80216b:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  80216d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802170:	89 d0                	mov    %edx,%eax
  802172:	01 c0                	add    %eax,%eax
  802174:	01 d0                	add    %edx,%eax
  802176:	c1 e0 02             	shl    $0x2,%eax
  802179:	05 48 20 81 00       	add    $0x812048,%eax
  80217e:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802181:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802184:	89 d0                	mov    %edx,%eax
  802186:	01 c0                	add    %eax,%eax
  802188:	01 d0                	add    %edx,%eax
  80218a:	c1 e0 02             	shl    $0x2,%eax
  80218d:	05 40 20 81 00       	add    $0x812040,%eax
  802192:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802198:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80219b:	89 d0                	mov    %edx,%eax
  80219d:	01 c0                	add    %eax,%eax
  80219f:	01 d0                	add    %edx,%eax
  8021a1:	c1 e0 02             	shl    $0x2,%eax
  8021a4:	05 44 20 81 00       	add    $0x812044,%eax
  8021a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021af:	e9 c3 00 00 00       	jmp    802277 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  8021b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021b7:	89 d0                	mov    %edx,%eax
  8021b9:	01 c0                	add    %eax,%eax
  8021bb:	01 d0                	add    %edx,%eax
  8021bd:	c1 e0 02             	shl    $0x2,%eax
  8021c0:	05 40 20 81 00       	add    $0x812040,%eax
  8021c5:	8b 08                	mov    (%eax),%ecx
  8021c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021ca:	89 d0                	mov    %edx,%eax
  8021cc:	01 c0                	add    %eax,%eax
  8021ce:	01 d0                	add    %edx,%eax
  8021d0:	c1 e0 02             	shl    $0x2,%eax
  8021d3:	05 44 20 81 00       	add    $0x812044,%eax
  8021d8:	8b 00                	mov    (%eax),%eax
  8021da:	01 c1                	add    %eax,%ecx
  8021dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021df:	89 d0                	mov    %edx,%eax
  8021e1:	01 c0                	add    %eax,%eax
  8021e3:	01 d0                	add    %edx,%eax
  8021e5:	c1 e0 02             	shl    $0x2,%eax
  8021e8:	05 40 20 81 00       	add    $0x812040,%eax
  8021ed:	8b 00                	mov    (%eax),%eax
  8021ef:	39 c1                	cmp    %eax,%ecx
  8021f1:	0f 85 80 00 00 00    	jne    802277 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8021f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021fa:	89 d0                	mov    %edx,%eax
  8021fc:	01 c0                	add    %eax,%eax
  8021fe:	01 d0                	add    %edx,%eax
  802200:	c1 e0 02             	shl    $0x2,%eax
  802203:	05 44 20 81 00       	add    $0x812044,%eax
  802208:	8b 08                	mov    (%eax),%ecx
  80220a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80220d:	89 d0                	mov    %edx,%eax
  80220f:	01 c0                	add    %eax,%eax
  802211:	01 d0                	add    %edx,%eax
  802213:	c1 e0 02             	shl    $0x2,%eax
  802216:	05 44 20 81 00       	add    $0x812044,%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	01 c1                	add    %eax,%ecx
  80221f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802222:	89 d0                	mov    %edx,%eax
  802224:	01 c0                	add    %eax,%eax
  802226:	01 d0                	add    %edx,%eax
  802228:	c1 e0 02             	shl    $0x2,%eax
  80222b:	05 44 20 81 00       	add    $0x812044,%eax
  802230:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802232:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802235:	89 d0                	mov    %edx,%eax
  802237:	01 c0                	add    %eax,%eax
  802239:	01 d0                	add    %edx,%eax
  80223b:	c1 e0 02             	shl    $0x2,%eax
  80223e:	05 48 20 81 00       	add    $0x812048,%eax
  802243:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802246:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802249:	89 d0                	mov    %edx,%eax
  80224b:	01 c0                	add    %eax,%eax
  80224d:	01 d0                	add    %edx,%eax
  80224f:	c1 e0 02             	shl    $0x2,%eax
  802252:	05 40 20 81 00       	add    $0x812040,%eax
  802257:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  80225d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802260:	89 d0                	mov    %edx,%eax
  802262:	01 c0                	add    %eax,%eax
  802264:	01 d0                	add    %edx,%eax
  802266:	c1 e0 02             	shl    $0x2,%eax
  802269:	05 44 20 81 00       	add    $0x812044,%eax
  80226e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802274:	eb 01                	jmp    802277 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  802276:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802277:	ff 45 e0             	incl   -0x20(%ebp)
  80227a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802281:	0f 8e 1b fe ff ff    	jle    8020a2 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802287:	a1 30 61 83 00       	mov    0x836130,%eax
  80228c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80228f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802296:	eb 53                	jmp    8022eb <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802298:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80229b:	89 d0                	mov    %edx,%eax
  80229d:	01 c0                	add    %eax,%eax
  80229f:	01 d0                	add    %edx,%eax
  8022a1:	c1 e0 02             	shl    $0x2,%eax
  8022a4:	05 48 60 80 00       	add    $0x806048,%eax
  8022a9:	8a 00                	mov    (%eax),%al
  8022ab:	84 c0                	test   %al,%al
  8022ad:	74 39                	je     8022e8 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  8022af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022b2:	89 d0                	mov    %edx,%eax
  8022b4:	01 c0                	add    %eax,%eax
  8022b6:	01 d0                	add    %edx,%eax
  8022b8:	c1 e0 02             	shl    $0x2,%eax
  8022bb:	05 40 60 80 00       	add    $0x806040,%eax
  8022c0:	8b 08                	mov    (%eax),%ecx
  8022c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022c5:	89 d0                	mov    %edx,%eax
  8022c7:	01 c0                	add    %eax,%eax
  8022c9:	01 d0                	add    %edx,%eax
  8022cb:	c1 e0 02             	shl    $0x2,%eax
  8022ce:	05 44 60 80 00       	add    $0x806044,%eax
  8022d3:	8b 00                	mov    (%eax),%eax
  8022d5:	01 c8                	add    %ecx,%eax
  8022d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  8022da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8022e0:	76 06                	jbe    8022e8 <free+0x3e3>
  8022e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022e8:	ff 45 d8             	incl   -0x28(%ebp)
  8022eb:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8022f2:	7e a4                	jle    802298 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  8022f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022f7:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  8022fc:	83 ec 08             	sub    $0x8,%esp
  8022ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802302:	ff 75 d4             	pushl  -0x2c(%ebp)
  802305:	e8 79 15 00 00       	call   803883 <sys_free_user_mem>
  80230a:	83 c4 10             	add    $0x10,%esp
  80230d:	eb 01                	jmp    802310 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  80230f:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 68             	sub    $0x68,%esp
  802318:	8b 45 10             	mov    0x10(%ebp),%eax
  80231b:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80231e:	e8 a5 f7 ff ff       	call   801ac8 <uheap_init>
	if (size == 0) return NULL ;
  802323:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802327:	75 0a                	jne    802333 <smalloc+0x21>
  802329:	b8 00 00 00 00       	mov    $0x0,%eax
  80232e:	e9 37 03 00 00       	jmp    80266a <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802333:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80233a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802340:	01 d0                	add    %edx,%eax
  802342:	48                   	dec    %eax
  802343:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802346:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802349:	ba 00 00 00 00       	mov    $0x0,%edx
  80234e:	f7 75 dc             	divl   -0x24(%ebp)
  802351:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802354:	29 d0                	sub    %edx,%eax
  802356:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802359:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802360:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802367:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80236e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802375:	e9 85 00 00 00       	jmp    8023ff <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80237a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80237d:	89 d0                	mov    %edx,%eax
  80237f:	01 c0                	add    %eax,%eax
  802381:	01 d0                	add    %edx,%eax
  802383:	c1 e0 02             	shl    $0x2,%eax
  802386:	05 48 20 81 00       	add    $0x812048,%eax
  80238b:	8a 00                	mov    (%eax),%al
  80238d:	84 c0                	test   %al,%al
  80238f:	74 20                	je     8023b1 <smalloc+0x9f>
  802391:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802394:	89 d0                	mov    %edx,%eax
  802396:	01 c0                	add    %eax,%eax
  802398:	01 d0                	add    %edx,%eax
  80239a:	c1 e0 02             	shl    $0x2,%eax
  80239d:	05 44 20 81 00       	add    $0x812044,%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8023a7:	75 08                	jne    8023b1 <smalloc+0x9f>
        {
            exactIdx = i;
  8023a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8023af:	eb 5b                	jmp    80240c <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8023b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023b4:	89 d0                	mov    %edx,%eax
  8023b6:	01 c0                	add    %eax,%eax
  8023b8:	01 d0                	add    %edx,%eax
  8023ba:	c1 e0 02             	shl    $0x2,%eax
  8023bd:	05 48 20 81 00       	add    $0x812048,%eax
  8023c2:	8a 00                	mov    (%eax),%al
  8023c4:	84 c0                	test   %al,%al
  8023c6:	74 34                	je     8023fc <smalloc+0xea>
  8023c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	01 c0                	add    %eax,%eax
  8023cf:	01 d0                	add    %edx,%eax
  8023d1:	c1 e0 02             	shl    $0x2,%eax
  8023d4:	05 44 20 81 00       	add    $0x812044,%eax
  8023d9:	8b 00                	mov    (%eax),%eax
  8023db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023de:	76 1c                	jbe    8023fc <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8023e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023e3:	89 d0                	mov    %edx,%eax
  8023e5:	01 c0                	add    %eax,%eax
  8023e7:	01 d0                	add    %edx,%eax
  8023e9:	c1 e0 02             	shl    $0x2,%eax
  8023ec:	05 44 20 81 00       	add    $0x812044,%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8023f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023f9:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8023fc:	ff 45 e8             	incl   -0x18(%ebp)
  8023ff:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802406:	0f 8e 6e ff ff ff    	jle    80237a <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80240c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802413:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802417:	74 7d                	je     802496 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802419:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802423:	89 d0                	mov    %edx,%eax
  802425:	01 c0                	add    %eax,%eax
  802427:	01 d0                	add    %edx,%eax
  802429:	c1 e0 02             	shl    $0x2,%eax
  80242c:	05 40 20 81 00       	add    $0x812040,%eax
  802431:	8b 10                	mov    (%eax),%edx
  802433:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802436:	01 d0                	add    %edx,%eax
  802438:	48                   	dec    %eax
  802439:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80243c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80243f:	ba 00 00 00 00       	mov    $0x0,%edx
  802444:	f7 75 bc             	divl   -0x44(%ebp)
  802447:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80244a:	29 d0                	sub    %edx,%eax
  80244c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80244f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802452:	89 d0                	mov    %edx,%eax
  802454:	01 c0                	add    %eax,%eax
  802456:	01 d0                	add    %edx,%eax
  802458:	c1 e0 02             	shl    $0x2,%eax
  80245b:	05 48 20 81 00       	add    $0x812048,%eax
  802460:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802466:	89 d0                	mov    %edx,%eax
  802468:	01 c0                	add    %eax,%eax
  80246a:	01 d0                	add    %edx,%eax
  80246c:	c1 e0 02             	shl    $0x2,%eax
  80246f:	05 44 20 81 00       	add    $0x812044,%eax
  802474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80247a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247d:	89 d0                	mov    %edx,%eax
  80247f:	01 c0                	add    %eax,%eax
  802481:	01 d0                	add    %edx,%eax
  802483:	c1 e0 02             	shl    $0x2,%eax
  802486:	05 40 20 81 00       	add    $0x812040,%eax
  80248b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802491:	e9 2d 01 00 00       	jmp    8025c3 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802496:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80249a:	0f 84 ce 00 00 00    	je     80256e <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8024a0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8024a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024aa:	89 d0                	mov    %edx,%eax
  8024ac:	01 c0                	add    %eax,%eax
  8024ae:	01 d0                	add    %edx,%eax
  8024b0:	c1 e0 02             	shl    $0x2,%eax
  8024b3:	05 40 20 81 00       	add    $0x812040,%eax
  8024b8:	8b 10                	mov    (%eax),%edx
  8024ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024bd:	01 d0                	add    %edx,%eax
  8024bf:	48                   	dec    %eax
  8024c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8024c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8024cb:	f7 75 c4             	divl   -0x3c(%ebp)
  8024ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024d1:	29 d0                	sub    %edx,%eax
  8024d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8024d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d9:	89 d0                	mov    %edx,%eax
  8024db:	01 c0                	add    %eax,%eax
  8024dd:	01 d0                	add    %edx,%eax
  8024df:	c1 e0 02             	shl    $0x2,%eax
  8024e2:	05 44 20 81 00       	add    $0x812044,%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8024ec:	75 47                	jne    802535 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  8024ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f1:	89 d0                	mov    %edx,%eax
  8024f3:	01 c0                	add    %eax,%eax
  8024f5:	01 d0                	add    %edx,%eax
  8024f7:	c1 e0 02             	shl    $0x2,%eax
  8024fa:	05 48 20 81 00       	add    $0x812048,%eax
  8024ff:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802502:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802505:	89 d0                	mov    %edx,%eax
  802507:	01 c0                	add    %eax,%eax
  802509:	01 d0                	add    %edx,%eax
  80250b:	c1 e0 02             	shl    $0x2,%eax
  80250e:	05 44 20 81 00       	add    $0x812044,%eax
  802513:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802519:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251c:	89 d0                	mov    %edx,%eax
  80251e:	01 c0                	add    %eax,%eax
  802520:	01 d0                	add    %edx,%eax
  802522:	c1 e0 02             	shl    $0x2,%eax
  802525:	05 40 20 81 00       	add    $0x812040,%eax
  80252a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802530:	e9 8e 00 00 00       	jmp    8025c3 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802535:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80253b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80253e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802541:	89 d0                	mov    %edx,%eax
  802543:	01 c0                	add    %eax,%eax
  802545:	01 d0                	add    %edx,%eax
  802547:	c1 e0 02             	shl    $0x2,%eax
  80254a:	05 40 20 81 00       	add    $0x812040,%eax
  80254f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802551:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802554:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802557:	89 c2                	mov    %eax,%edx
  802559:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80255c:	89 c8                	mov    %ecx,%eax
  80255e:	01 c0                	add    %eax,%eax
  802560:	01 c8                	add    %ecx,%eax
  802562:	c1 e0 02             	shl    $0x2,%eax
  802565:	05 44 20 81 00       	add    $0x812044,%eax
  80256a:	89 10                	mov    %edx,(%eax)
  80256c:	eb 55                	jmp    8025c3 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80256e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802575:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80257b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80257e:	01 d0                	add    %edx,%eax
  802580:	48                   	dec    %eax
  802581:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802584:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802587:	ba 00 00 00 00       	mov    $0x0,%edx
  80258c:	f7 75 d0             	divl   -0x30(%ebp)
  80258f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802592:	29 d0                	sub    %edx,%eax
  802594:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802597:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80259a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80259d:	01 d0                	add    %edx,%eax
  80259f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8025a4:	76 0a                	jbe    8025b0 <smalloc+0x29e>
            return NULL;
  8025a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ab:	e9 ba 00 00 00       	jmp    80266a <smalloc+0x358>
        va = start;
  8025b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8025b6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8025b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025bc:	01 d0                	add    %edx,%eax
  8025be:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8025ca:	eb 5e                	jmp    80262a <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8025cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025cf:	89 d0                	mov    %edx,%eax
  8025d1:	01 c0                	add    %eax,%eax
  8025d3:	01 d0                	add    %edx,%eax
  8025d5:	c1 e0 02             	shl    $0x2,%eax
  8025d8:	05 48 60 80 00       	add    $0x806048,%eax
  8025dd:	8a 00                	mov    (%eax),%al
  8025df:	84 c0                	test   %al,%al
  8025e1:	75 44                	jne    802627 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8025e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025e6:	89 d0                	mov    %edx,%eax
  8025e8:	01 c0                	add    %eax,%eax
  8025ea:	01 d0                	add    %edx,%eax
  8025ec:	c1 e0 02             	shl    $0x2,%eax
  8025ef:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  8025f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8025fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025fd:	89 d0                	mov    %edx,%eax
  8025ff:	01 c0                	add    %eax,%eax
  802601:	01 d0                	add    %edx,%eax
  802603:	c1 e0 02             	shl    $0x2,%eax
  802606:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  80260c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80260f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802611:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802614:	89 d0                	mov    %edx,%eax
  802616:	01 c0                	add    %eax,%eax
  802618:	01 d0                	add    %edx,%eax
  80261a:	c1 e0 02             	shl    $0x2,%eax
  80261d:	05 48 60 80 00       	add    $0x806048,%eax
  802622:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802625:	eb 0c                	jmp    802633 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802627:	ff 45 e0             	incl   -0x20(%ebp)
  80262a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802631:	7e 99                	jle    8025cc <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802636:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80263a:	52                   	push   %edx
  80263b:	50                   	push   %eax
  80263c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80263f:	ff 75 08             	pushl  0x8(%ebp)
  802642:	e8 de 0e 00 00       	call   803525 <sys_create_shared_object>
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  80264d:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802651:	75 07                	jne    80265a <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802653:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802658:	eb 10                	jmp    80266a <smalloc+0x358>
    if (r < 0)
  80265a:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80265e:	79 07                	jns    802667 <smalloc+0x355>
        return NULL;
  802660:	b8 00 00 00 00       	mov    $0x0,%eax
  802665:	eb 03                	jmp    80266a <smalloc+0x358>
    return (void*)va;
  802667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802672:	e8 51 f4 ff ff       	call   801ac8 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802677:	83 ec 08             	sub    $0x8,%esp
  80267a:	ff 75 0c             	pushl  0xc(%ebp)
  80267d:	ff 75 08             	pushl  0x8(%ebp)
  802680:	e8 ca 0e 00 00       	call   80354f <sys_size_of_shared_object>
  802685:	83 c4 10             	add    $0x10,%esp
  802688:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80268b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80268f:	7f 0a                	jg     80269b <sget+0x2f>
        return NULL;
  802691:	b8 00 00 00 00       	mov    $0x0,%eax
  802696:	e9 28 03 00 00       	jmp    8029c3 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80269b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026a8:	01 d0                	add    %edx,%eax
  8026aa:	48                   	dec    %eax
  8026ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b6:	f7 75 d8             	divl   -0x28(%ebp)
  8026b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026bc:	29 d0                	sub    %edx,%eax
  8026be:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8026c1:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8026c8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8026cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8026d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8026dd:	e9 85 00 00 00       	jmp    802767 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8026e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026e5:	89 d0                	mov    %edx,%eax
  8026e7:	01 c0                	add    %eax,%eax
  8026e9:	01 d0                	add    %edx,%eax
  8026eb:	c1 e0 02             	shl    $0x2,%eax
  8026ee:	05 48 20 81 00       	add    $0x812048,%eax
  8026f3:	8a 00                	mov    (%eax),%al
  8026f5:	84 c0                	test   %al,%al
  8026f7:	74 20                	je     802719 <sget+0xad>
  8026f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026fc:	89 d0                	mov    %edx,%eax
  8026fe:	01 c0                	add    %eax,%eax
  802700:	01 d0                	add    %edx,%eax
  802702:	c1 e0 02             	shl    $0x2,%eax
  802705:	05 44 20 81 00       	add    $0x812044,%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80270f:	75 08                	jne    802719 <sget+0xad>
        {
            exactIdx = i;
  802711:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802714:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802717:	eb 5b                	jmp    802774 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802719:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80271c:	89 d0                	mov    %edx,%eax
  80271e:	01 c0                	add    %eax,%eax
  802720:	01 d0                	add    %edx,%eax
  802722:	c1 e0 02             	shl    $0x2,%eax
  802725:	05 48 20 81 00       	add    $0x812048,%eax
  80272a:	8a 00                	mov    (%eax),%al
  80272c:	84 c0                	test   %al,%al
  80272e:	74 34                	je     802764 <sget+0xf8>
  802730:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802733:	89 d0                	mov    %edx,%eax
  802735:	01 c0                	add    %eax,%eax
  802737:	01 d0                	add    %edx,%eax
  802739:	c1 e0 02             	shl    $0x2,%eax
  80273c:	05 44 20 81 00       	add    $0x812044,%eax
  802741:	8b 00                	mov    (%eax),%eax
  802743:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802746:	76 1c                	jbe    802764 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802748:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274b:	89 d0                	mov    %edx,%eax
  80274d:	01 c0                	add    %eax,%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	c1 e0 02             	shl    $0x2,%eax
  802754:	05 44 20 81 00       	add    $0x812044,%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80275e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802761:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802764:	ff 45 e8             	incl   -0x18(%ebp)
  802767:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80276e:	0f 8e 6e ff ff ff    	jle    8026e2 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802774:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80277b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80277f:	74 7d                	je     8027fe <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802781:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802788:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278b:	89 d0                	mov    %edx,%eax
  80278d:	01 c0                	add    %eax,%eax
  80278f:	01 d0                	add    %edx,%eax
  802791:	c1 e0 02             	shl    $0x2,%eax
  802794:	05 40 20 81 00       	add    $0x812040,%eax
  802799:	8b 10                	mov    (%eax),%edx
  80279b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80279e:	01 d0                	add    %edx,%eax
  8027a0:	48                   	dec    %eax
  8027a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8027a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ac:	f7 75 b8             	divl   -0x48(%ebp)
  8027af:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027b2:	29 d0                	sub    %edx,%eax
  8027b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8027b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ba:	89 d0                	mov    %edx,%eax
  8027bc:	01 c0                	add    %eax,%eax
  8027be:	01 d0                	add    %edx,%eax
  8027c0:	c1 e0 02             	shl    $0x2,%eax
  8027c3:	05 48 20 81 00       	add    $0x812048,%eax
  8027c8:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8027cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ce:	89 d0                	mov    %edx,%eax
  8027d0:	01 c0                	add    %eax,%eax
  8027d2:	01 d0                	add    %edx,%eax
  8027d4:	c1 e0 02             	shl    $0x2,%eax
  8027d7:	05 44 20 81 00       	add    $0x812044,%eax
  8027dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8027e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e5:	89 d0                	mov    %edx,%eax
  8027e7:	01 c0                	add    %eax,%eax
  8027e9:	01 d0                	add    %edx,%eax
  8027eb:	c1 e0 02             	shl    $0x2,%eax
  8027ee:	05 40 20 81 00       	add    $0x812040,%eax
  8027f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f9:	e9 2d 01 00 00       	jmp    80292b <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8027fe:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802802:	0f 84 ce 00 00 00    	je     8028d6 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802808:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80280f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802812:	89 d0                	mov    %edx,%eax
  802814:	01 c0                	add    %eax,%eax
  802816:	01 d0                	add    %edx,%eax
  802818:	c1 e0 02             	shl    $0x2,%eax
  80281b:	05 40 20 81 00       	add    $0x812040,%eax
  802820:	8b 10                	mov    (%eax),%edx
  802822:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802825:	01 d0                	add    %edx,%eax
  802827:	48                   	dec    %eax
  802828:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80282b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80282e:	ba 00 00 00 00       	mov    $0x0,%edx
  802833:	f7 75 c0             	divl   -0x40(%ebp)
  802836:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802839:	29 d0                	sub    %edx,%eax
  80283b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80283e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802841:	89 d0                	mov    %edx,%eax
  802843:	01 c0                	add    %eax,%eax
  802845:	01 d0                	add    %edx,%eax
  802847:	c1 e0 02             	shl    $0x2,%eax
  80284a:	05 44 20 81 00       	add    $0x812044,%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802854:	75 47                	jne    80289d <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802856:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802859:	89 d0                	mov    %edx,%eax
  80285b:	01 c0                	add    %eax,%eax
  80285d:	01 d0                	add    %edx,%eax
  80285f:	c1 e0 02             	shl    $0x2,%eax
  802862:	05 48 20 81 00       	add    $0x812048,%eax
  802867:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80286a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80286d:	89 d0                	mov    %edx,%eax
  80286f:	01 c0                	add    %eax,%eax
  802871:	01 d0                	add    %edx,%eax
  802873:	c1 e0 02             	shl    $0x2,%eax
  802876:	05 44 20 81 00       	add    $0x812044,%eax
  80287b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802881:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802884:	89 d0                	mov    %edx,%eax
  802886:	01 c0                	add    %eax,%eax
  802888:	01 d0                	add    %edx,%eax
  80288a:	c1 e0 02             	shl    $0x2,%eax
  80288d:	05 40 20 81 00       	add    $0x812040,%eax
  802892:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802898:	e9 8e 00 00 00       	jmp    80292b <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80289d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028a3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a9:	89 d0                	mov    %edx,%eax
  8028ab:	01 c0                	add    %eax,%eax
  8028ad:	01 d0                	add    %edx,%eax
  8028af:	c1 e0 02             	shl    $0x2,%eax
  8028b2:	05 40 20 81 00       	add    $0x812040,%eax
  8028b7:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8028b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8028bf:	89 c2                	mov    %eax,%edx
  8028c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028c4:	89 c8                	mov    %ecx,%eax
  8028c6:	01 c0                	add    %eax,%eax
  8028c8:	01 c8                	add    %ecx,%eax
  8028ca:	c1 e0 02             	shl    $0x2,%eax
  8028cd:	05 44 20 81 00       	add    $0x812044,%eax
  8028d2:	89 10                	mov    %edx,(%eax)
  8028d4:	eb 55                	jmp    80292b <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8028d6:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028dd:	8b 15 88 60 83 00    	mov    0x836088,%edx
  8028e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e6:	01 d0                	add    %edx,%eax
  8028e8:	48                   	dec    %eax
  8028e9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f4:	f7 75 cc             	divl   -0x34(%ebp)
  8028f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028fa:	29 d0                	sub    %edx,%eax
  8028fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8028ff:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802902:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802905:	01 d0                	add    %edx,%eax
  802907:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80290c:	76 0a                	jbe    802918 <sget+0x2ac>
            return NULL;
  80290e:	b8 00 00 00 00       	mov    $0x0,%eax
  802913:	e9 ab 00 00 00       	jmp    8029c3 <sget+0x357>
        va = start;
  802918:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80291b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80291e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802921:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802924:	01 d0                	add    %edx,%eax
  802926:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80292b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802932:	eb 5e                	jmp    802992 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802934:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802937:	89 d0                	mov    %edx,%eax
  802939:	01 c0                	add    %eax,%eax
  80293b:	01 d0                	add    %edx,%eax
  80293d:	c1 e0 02             	shl    $0x2,%eax
  802940:	05 48 60 80 00       	add    $0x806048,%eax
  802945:	8a 00                	mov    (%eax),%al
  802947:	84 c0                	test   %al,%al
  802949:	75 44                	jne    80298f <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80294b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80294e:	89 d0                	mov    %edx,%eax
  802950:	01 c0                	add    %eax,%eax
  802952:	01 d0                	add    %edx,%eax
  802954:	c1 e0 02             	shl    $0x2,%eax
  802957:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80295d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802960:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802962:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802965:	89 d0                	mov    %edx,%eax
  802967:	01 c0                	add    %eax,%eax
  802969:	01 d0                	add    %edx,%eax
  80296b:	c1 e0 02             	shl    $0x2,%eax
  80296e:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802974:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802977:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802979:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80297c:	89 d0                	mov    %edx,%eax
  80297e:	01 c0                	add    %eax,%eax
  802980:	01 d0                	add    %edx,%eax
  802982:	c1 e0 02             	shl    $0x2,%eax
  802985:	05 48 60 80 00       	add    $0x806048,%eax
  80298a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80298d:	eb 0c                	jmp    80299b <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80298f:	ff 45 e0             	incl   -0x20(%ebp)
  802992:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802999:	7e 99                	jle    802934 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80299b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	50                   	push   %eax
  8029a2:	ff 75 0c             	pushl  0xc(%ebp)
  8029a5:	ff 75 08             	pushl  0x8(%ebp)
  8029a8:	e8 bf 0b 00 00       	call   80356c <sys_get_shared_object>
  8029ad:	83 c4 10             	add    $0x10,%esp
  8029b0:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8029b3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029b7:	79 07                	jns    8029c0 <sget+0x354>
        return NULL;
  8029b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029be:	eb 03                	jmp    8029c3 <sget+0x357>
    return (void*)va;
  8029c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8029c3:	c9                   	leave  
  8029c4:	c3                   	ret    

008029c5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
  8029c8:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8029cb:	e8 f8 f0 ff ff       	call   801ac8 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8029d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d4:	75 13                	jne    8029e9 <realloc+0x24>
		return malloc(new_size);
  8029d6:	83 ec 0c             	sub    $0xc,%esp
  8029d9:	ff 75 0c             	pushl  0xc(%ebp)
  8029dc:	e8 c4 f1 ff ff       	call   801ba5 <malloc>
  8029e1:	83 c4 10             	add    $0x10,%esp
  8029e4:	e9 f4 05 00 00       	jmp    802fdd <realloc+0x618>
	if (new_size == 0)
  8029e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029ed:	75 18                	jne    802a07 <realloc+0x42>
	{
		free(virtual_address);
  8029ef:	83 ec 0c             	sub    $0xc,%esp
  8029f2:	ff 75 08             	pushl  0x8(%ebp)
  8029f5:	e8 0b f5 ff ff       	call   801f05 <free>
  8029fa:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8029fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802a02:	e9 d6 05 00 00       	jmp    802fdd <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802a0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	79 74                	jns    802a88 <realloc+0xc3>
  802a14:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802a1b:	77 6b                	ja     802a88 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802a1d:	83 ec 0c             	sub    $0xc,%esp
  802a20:	ff 75 0c             	pushl  0xc(%ebp)
  802a23:	e8 7d f1 ff ff       	call   801ba5 <malloc>
  802a28:	83 c4 10             	add    $0x10,%esp
  802a2b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802a2e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802a32:	75 0a                	jne    802a3e <realloc+0x79>
			return NULL;
  802a34:	b8 00 00 00 00       	mov    $0x0,%eax
  802a39:	e9 9f 05 00 00       	jmp    802fdd <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802a3e:	83 ec 0c             	sub    $0xc,%esp
  802a41:	ff 75 08             	pushl  0x8(%ebp)
  802a44:	e8 e0 11 00 00       	call   803c29 <get_block_size>
  802a49:	83 c4 10             	add    $0x10,%esp
  802a4c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802a4f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a55:	39 d0                	cmp    %edx,%eax
  802a57:	76 02                	jbe    802a5b <realloc+0x96>
  802a59:	89 d0                	mov    %edx,%eax
  802a5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	ff 75 c0             	pushl  -0x40(%ebp)
  802a64:	ff 75 08             	pushl  0x8(%ebp)
  802a67:	ff 75 c8             	pushl  -0x38(%ebp)
  802a6a:	e8 56 eb ff ff       	call   8015c5 <memmove>
  802a6f:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802a72:	83 ec 0c             	sub    $0xc,%esp
  802a75:	ff 75 08             	pushl  0x8(%ebp)
  802a78:	e8 88 f4 ff ff       	call   801f05 <free>
  802a7d:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802a80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a83:	e9 55 05 00 00       	jmp    802fdd <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802a88:	a1 30 61 83 00       	mov    0x836130,%eax
  802a8d:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802a90:	72 09                	jb     802a9b <realloc+0xd6>
  802a92:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802a99:	76 0a                	jbe    802aa5 <realloc+0xe0>
		return NULL;
  802a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa0:	e9 38 05 00 00       	jmp    802fdd <realloc+0x618>
	uint32 oldsz = 0;
  802aa5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802aac:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802ab3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802aba:	eb 50                	jmp    802b0c <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802abc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802abf:	89 d0                	mov    %edx,%eax
  802ac1:	01 c0                	add    %eax,%eax
  802ac3:	01 d0                	add    %edx,%eax
  802ac5:	c1 e0 02             	shl    $0x2,%eax
  802ac8:	05 48 60 80 00       	add    $0x806048,%eax
  802acd:	8a 00                	mov    (%eax),%al
  802acf:	84 c0                	test   %al,%al
  802ad1:	74 36                	je     802b09 <realloc+0x144>
  802ad3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad6:	89 d0                	mov    %edx,%eax
  802ad8:	01 c0                	add    %eax,%eax
  802ada:	01 d0                	add    %edx,%eax
  802adc:	c1 e0 02             	shl    $0x2,%eax
  802adf:	05 40 60 80 00       	add    $0x806040,%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802ae9:	75 1e                	jne    802b09 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802aeb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aee:	89 d0                	mov    %edx,%eax
  802af0:	01 c0                	add    %eax,%eax
  802af2:	01 d0                	add    %edx,%eax
  802af4:	c1 e0 02             	shl    $0x2,%eax
  802af7:	05 44 60 80 00       	add    $0x806044,%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802b07:	eb 0c                	jmp    802b15 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b09:	ff 45 ec             	incl   -0x14(%ebp)
  802b0c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b13:	7e a7                	jle    802abc <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802b15:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b19:	75 0a                	jne    802b25 <realloc+0x160>
		return NULL;
  802b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b20:	e9 b8 04 00 00       	jmp    802fdd <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802b25:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b2f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b32:	01 d0                	add    %edx,%eax
  802b34:	48                   	dec    %eax
  802b35:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802b38:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b40:	f7 75 bc             	divl   -0x44(%ebp)
  802b43:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b46:	29 d0                	sub    %edx,%eax
  802b48:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802b4b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b4e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b51:	75 08                	jne    802b5b <realloc+0x196>
		return virtual_address;
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	e9 82 04 00 00       	jmp    802fdd <realloc+0x618>
	if (req < oldsz)
  802b5b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b5e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b61:	0f 83 cd 02 00 00    	jae    802e34 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802b6d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802b70:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b73:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b76:	01 d0                	add    %edx,%eax
  802b78:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802b7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7e:	89 d0                	mov    %edx,%eax
  802b80:	01 c0                	add    %eax,%eax
  802b82:	01 d0                	add    %edx,%eax
  802b84:	c1 e0 02             	shl    $0x2,%eax
  802b87:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802b8d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b90:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802b92:	83 ec 08             	sub    $0x8,%esp
  802b95:	ff 75 b0             	pushl  -0x50(%ebp)
  802b98:	ff 75 ac             	pushl  -0x54(%ebp)
  802b9b:	e8 e3 0c 00 00       	call   803883 <sys_free_user_mem>
  802ba0:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802ba3:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802baa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802bb1:	eb 64                	jmp    802c17 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802bb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bb6:	89 d0                	mov    %edx,%eax
  802bb8:	01 c0                	add    %eax,%eax
  802bba:	01 d0                	add    %edx,%eax
  802bbc:	c1 e0 02             	shl    $0x2,%eax
  802bbf:	05 48 20 81 00       	add    $0x812048,%eax
  802bc4:	8a 00                	mov    (%eax),%al
  802bc6:	84 c0                	test   %al,%al
  802bc8:	75 4a                	jne    802c14 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802bca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bcd:	89 d0                	mov    %edx,%eax
  802bcf:	01 c0                	add    %eax,%eax
  802bd1:	01 d0                	add    %edx,%eax
  802bd3:	c1 e0 02             	shl    $0x2,%eax
  802bd6:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802bdc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bdf:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802be4:	89 d0                	mov    %edx,%eax
  802be6:	01 c0                	add    %eax,%eax
  802be8:	01 d0                	add    %edx,%eax
  802bea:	c1 e0 02             	shl    $0x2,%eax
  802bed:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802bf3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf6:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802bf8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bfb:	89 d0                	mov    %edx,%eax
  802bfd:	01 c0                	add    %eax,%eax
  802bff:	01 d0                	add    %edx,%eax
  802c01:	c1 e0 02             	shl    $0x2,%eax
  802c04:	05 48 20 81 00       	add    $0x812048,%eax
  802c09:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802c12:	eb 0c                	jmp    802c20 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c14:	ff 45 e4             	incl   -0x1c(%ebp)
  802c17:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802c1e:	7e 93                	jle    802bb3 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802c20:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802c24:	0f 84 8d 01 00 00    	je     802db7 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c2a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c31:	e9 74 01 00 00       	jmp    802daa <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802c36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c39:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c3c:	0f 84 64 01 00 00    	je     802da6 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802c42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c45:	89 d0                	mov    %edx,%eax
  802c47:	01 c0                	add    %eax,%eax
  802c49:	01 d0                	add    %edx,%eax
  802c4b:	c1 e0 02             	shl    $0x2,%eax
  802c4e:	05 48 20 81 00       	add    $0x812048,%eax
  802c53:	8a 00                	mov    (%eax),%al
  802c55:	84 c0                	test   %al,%al
  802c57:	0f 84 4a 01 00 00    	je     802da7 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c60:	89 d0                	mov    %edx,%eax
  802c62:	01 c0                	add    %eax,%eax
  802c64:	01 d0                	add    %edx,%eax
  802c66:	c1 e0 02             	shl    $0x2,%eax
  802c69:	05 40 20 81 00       	add    $0x812040,%eax
  802c6e:	8b 08                	mov    (%eax),%ecx
  802c70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c73:	89 d0                	mov    %edx,%eax
  802c75:	01 c0                	add    %eax,%eax
  802c77:	01 d0                	add    %edx,%eax
  802c79:	c1 e0 02             	shl    $0x2,%eax
  802c7c:	05 44 20 81 00       	add    $0x812044,%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	01 c1                	add    %eax,%ecx
  802c85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c88:	89 d0                	mov    %edx,%eax
  802c8a:	01 c0                	add    %eax,%eax
  802c8c:	01 d0                	add    %edx,%eax
  802c8e:	c1 e0 02             	shl    $0x2,%eax
  802c91:	05 40 20 81 00       	add    $0x812040,%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	39 c1                	cmp    %eax,%ecx
  802c9a:	75 7a                	jne    802d16 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802c9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9f:	89 d0                	mov    %edx,%eax
  802ca1:	01 c0                	add    %eax,%eax
  802ca3:	01 d0                	add    %edx,%eax
  802ca5:	c1 e0 02             	shl    $0x2,%eax
  802ca8:	05 40 20 81 00       	add    $0x812040,%eax
  802cad:	8b 10                	mov    (%eax),%edx
  802caf:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802cb2:	89 c8                	mov    %ecx,%eax
  802cb4:	01 c0                	add    %eax,%eax
  802cb6:	01 c8                	add    %ecx,%eax
  802cb8:	c1 e0 02             	shl    $0x2,%eax
  802cbb:	05 40 20 81 00       	add    $0x812040,%eax
  802cc0:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802cc2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cc5:	89 d0                	mov    %edx,%eax
  802cc7:	01 c0                	add    %eax,%eax
  802cc9:	01 d0                	add    %edx,%eax
  802ccb:	c1 e0 02             	shl    $0x2,%eax
  802cce:	05 44 20 81 00       	add    $0x812044,%eax
  802cd3:	8b 08                	mov    (%eax),%ecx
  802cd5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cd8:	89 d0                	mov    %edx,%eax
  802cda:	01 c0                	add    %eax,%eax
  802cdc:	01 d0                	add    %edx,%eax
  802cde:	c1 e0 02             	shl    $0x2,%eax
  802ce1:	05 44 20 81 00       	add    $0x812044,%eax
  802ce6:	8b 00                	mov    (%eax),%eax
  802ce8:	01 c1                	add    %eax,%ecx
  802cea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ced:	89 d0                	mov    %edx,%eax
  802cef:	01 c0                	add    %eax,%eax
  802cf1:	01 d0                	add    %edx,%eax
  802cf3:	c1 e0 02             	shl    $0x2,%eax
  802cf6:	05 44 20 81 00       	add    $0x812044,%eax
  802cfb:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802cfd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d00:	89 d0                	mov    %edx,%eax
  802d02:	01 c0                	add    %eax,%eax
  802d04:	01 d0                	add    %edx,%eax
  802d06:	c1 e0 02             	shl    $0x2,%eax
  802d09:	05 48 20 81 00       	add    $0x812048,%eax
  802d0e:	c6 00 00             	movb   $0x0,(%eax)
  802d11:	e9 91 00 00 00       	jmp    802da7 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d19:	89 d0                	mov    %edx,%eax
  802d1b:	01 c0                	add    %eax,%eax
  802d1d:	01 d0                	add    %edx,%eax
  802d1f:	c1 e0 02             	shl    $0x2,%eax
  802d22:	05 40 20 81 00       	add    $0x812040,%eax
  802d27:	8b 08                	mov    (%eax),%ecx
  802d29:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d2c:	89 d0                	mov    %edx,%eax
  802d2e:	01 c0                	add    %eax,%eax
  802d30:	01 d0                	add    %edx,%eax
  802d32:	c1 e0 02             	shl    $0x2,%eax
  802d35:	05 44 20 81 00       	add    $0x812044,%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	01 c1                	add    %eax,%ecx
  802d3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d41:	89 d0                	mov    %edx,%eax
  802d43:	01 c0                	add    %eax,%eax
  802d45:	01 d0                	add    %edx,%eax
  802d47:	c1 e0 02             	shl    $0x2,%eax
  802d4a:	05 40 20 81 00       	add    $0x812040,%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	39 c1                	cmp    %eax,%ecx
  802d53:	75 52                	jne    802da7 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802d55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d58:	89 d0                	mov    %edx,%eax
  802d5a:	01 c0                	add    %eax,%eax
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	c1 e0 02             	shl    $0x2,%eax
  802d61:	05 44 20 81 00       	add    $0x812044,%eax
  802d66:	8b 08                	mov    (%eax),%ecx
  802d68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d6b:	89 d0                	mov    %edx,%eax
  802d6d:	01 c0                	add    %eax,%eax
  802d6f:	01 d0                	add    %edx,%eax
  802d71:	c1 e0 02             	shl    $0x2,%eax
  802d74:	05 44 20 81 00       	add    $0x812044,%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	01 c1                	add    %eax,%ecx
  802d7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d80:	89 d0                	mov    %edx,%eax
  802d82:	01 c0                	add    %eax,%eax
  802d84:	01 d0                	add    %edx,%eax
  802d86:	c1 e0 02             	shl    $0x2,%eax
  802d89:	05 44 20 81 00       	add    $0x812044,%eax
  802d8e:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802d90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d93:	89 d0                	mov    %edx,%eax
  802d95:	01 c0                	add    %eax,%eax
  802d97:	01 d0                	add    %edx,%eax
  802d99:	c1 e0 02             	shl    $0x2,%eax
  802d9c:	05 48 20 81 00       	add    $0x812048,%eax
  802da1:	c6 00 00             	movb   $0x0,(%eax)
  802da4:	eb 01                	jmp    802da7 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802da6:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802da7:	ff 45 e0             	incl   -0x20(%ebp)
  802daa:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802db1:	0f 8e 7f fe ff ff    	jle    802c36 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802db7:	a1 30 61 83 00       	mov    0x836130,%eax
  802dbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802dbf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802dc6:	eb 53                	jmp    802e1b <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802dc8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802dcb:	89 d0                	mov    %edx,%eax
  802dcd:	01 c0                	add    %eax,%eax
  802dcf:	01 d0                	add    %edx,%eax
  802dd1:	c1 e0 02             	shl    $0x2,%eax
  802dd4:	05 48 60 80 00       	add    $0x806048,%eax
  802dd9:	8a 00                	mov    (%eax),%al
  802ddb:	84 c0                	test   %al,%al
  802ddd:	74 39                	je     802e18 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802ddf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802de2:	89 d0                	mov    %edx,%eax
  802de4:	01 c0                	add    %eax,%eax
  802de6:	01 d0                	add    %edx,%eax
  802de8:	c1 e0 02             	shl    $0x2,%eax
  802deb:	05 40 60 80 00       	add    $0x806040,%eax
  802df0:	8b 08                	mov    (%eax),%ecx
  802df2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802df5:	89 d0                	mov    %edx,%eax
  802df7:	01 c0                	add    %eax,%eax
  802df9:	01 d0                	add    %edx,%eax
  802dfb:	c1 e0 02             	shl    $0x2,%eax
  802dfe:	05 44 60 80 00       	add    $0x806044,%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	01 c8                	add    %ecx,%eax
  802e07:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802e0a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e0d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802e10:	76 06                	jbe    802e18 <realloc+0x453>
  802e12:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e15:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e18:	ff 45 d8             	incl   -0x28(%ebp)
  802e1b:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802e22:	7e a4                	jle    802dc8 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802e24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e27:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	e9 a9 01 00 00       	jmp    802fdd <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802e34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	01 d0                	add    %edx,%eax
  802e3c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802e3f:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e46:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802e4d:	eb 57                	jmp    802ea6 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802e4f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e52:	89 d0                	mov    %edx,%eax
  802e54:	01 c0                	add    %eax,%eax
  802e56:	01 d0                	add    %edx,%eax
  802e58:	c1 e0 02             	shl    $0x2,%eax
  802e5b:	05 48 20 81 00       	add    $0x812048,%eax
  802e60:	8a 00                	mov    (%eax),%al
  802e62:	84 c0                	test   %al,%al
  802e64:	74 3d                	je     802ea3 <realloc+0x4de>
  802e66:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e69:	89 d0                	mov    %edx,%eax
  802e6b:	01 c0                	add    %eax,%eax
  802e6d:	01 d0                	add    %edx,%eax
  802e6f:	c1 e0 02             	shl    $0x2,%eax
  802e72:	05 40 20 81 00       	add    $0x812040,%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e7c:	75 25                	jne    802ea3 <realloc+0x4de>
  802e7e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e81:	89 d0                	mov    %edx,%eax
  802e83:	01 c0                	add    %eax,%eax
  802e85:	01 d0                	add    %edx,%eax
  802e87:	c1 e0 02             	shl    $0x2,%eax
  802e8a:	05 44 20 81 00       	add    $0x812044,%eax
  802e8f:	8b 10                	mov    (%eax),%edx
  802e91:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e94:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802e97:	39 c2                	cmp    %eax,%edx
  802e99:	72 08                	jb     802ea3 <realloc+0x4de>
		{
			adjIdx = j; break;
  802e9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ea1:	eb 0c                	jmp    802eaf <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ea3:	ff 45 d0             	incl   -0x30(%ebp)
  802ea6:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802ead:	7e a0                	jle    802e4f <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802eaf:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802eb3:	0f 84 d6 00 00 00    	je     802f8f <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802eb9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ebc:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ebf:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802ec2:	83 ec 08             	sub    $0x8,%esp
  802ec5:	ff 75 a0             	pushl  -0x60(%ebp)
  802ec8:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ecb:	e8 cf 09 00 00       	call   80389f <sys_allocate_user_mem>
  802ed0:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802ed3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed6:	89 d0                	mov    %edx,%eax
  802ed8:	01 c0                	add    %eax,%eax
  802eda:	01 d0                	add    %edx,%eax
  802edc:	c1 e0 02             	shl    $0x2,%eax
  802edf:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802ee5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ee8:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802eea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802eed:	89 d0                	mov    %edx,%eax
  802eef:	01 c0                	add    %eax,%eax
  802ef1:	01 d0                	add    %edx,%eax
  802ef3:	c1 e0 02             	shl    $0x2,%eax
  802ef6:	05 40 20 81 00       	add    $0x812040,%eax
  802efb:	8b 10                	mov    (%eax),%edx
  802efd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f00:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802f03:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f06:	89 d0                	mov    %edx,%eax
  802f08:	01 c0                	add    %eax,%eax
  802f0a:	01 d0                	add    %edx,%eax
  802f0c:	c1 e0 02             	shl    $0x2,%eax
  802f0f:	05 40 20 81 00       	add    $0x812040,%eax
  802f14:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802f16:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f19:	89 d0                	mov    %edx,%eax
  802f1b:	01 c0                	add    %eax,%eax
  802f1d:	01 d0                	add    %edx,%eax
  802f1f:	c1 e0 02             	shl    $0x2,%eax
  802f22:	05 44 20 81 00       	add    $0x812044,%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802f2c:	89 c2                	mov    %eax,%edx
  802f2e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802f31:	89 c8                	mov    %ecx,%eax
  802f33:	01 c0                	add    %eax,%eax
  802f35:	01 c8                	add    %ecx,%eax
  802f37:	c1 e0 02             	shl    $0x2,%eax
  802f3a:	05 44 20 81 00       	add    $0x812044,%eax
  802f3f:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802f41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f44:	89 d0                	mov    %edx,%eax
  802f46:	01 c0                	add    %eax,%eax
  802f48:	01 d0                	add    %edx,%eax
  802f4a:	c1 e0 02             	shl    $0x2,%eax
  802f4d:	05 44 20 81 00       	add    $0x812044,%eax
  802f52:	8b 00                	mov    (%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	75 14                	jne    802f6c <realloc+0x5a7>
  802f58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f5b:	89 d0                	mov    %edx,%eax
  802f5d:	01 c0                	add    %eax,%eax
  802f5f:	01 d0                	add    %edx,%eax
  802f61:	c1 e0 02             	shl    $0x2,%eax
  802f64:	05 48 20 81 00       	add    $0x812048,%eax
  802f69:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802f6c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f6f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f72:	01 c2                	add    %eax,%edx
  802f74:	a1 88 60 83 00       	mov    0x836088,%eax
  802f79:	39 c2                	cmp    %eax,%edx
  802f7b:	76 0d                	jbe    802f8a <realloc+0x5c5>
  802f7d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f80:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f83:	01 d0                	add    %edx,%eax
  802f85:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	eb 4e                	jmp    802fdd <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802f8f:	83 ec 0c             	sub    $0xc,%esp
  802f92:	ff 75 0c             	pushl  0xc(%ebp)
  802f95:	e8 0b ec ff ff       	call   801ba5 <malloc>
  802f9a:	83 c4 10             	add    $0x10,%esp
  802f9d:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802fa0:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802fa4:	75 07                	jne    802fad <realloc+0x5e8>
		return NULL;
  802fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fab:	eb 30                	jmp    802fdd <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fb3:	39 d0                	cmp    %edx,%eax
  802fb5:	76 02                	jbe    802fb9 <realloc+0x5f4>
  802fb7:	89 d0                	mov    %edx,%eax
  802fb9:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802fbc:	83 ec 04             	sub    $0x4,%esp
  802fbf:	50                   	push   %eax
  802fc0:	52                   	push   %edx
  802fc1:	ff 75 cc             	pushl  -0x34(%ebp)
  802fc4:	e8 cf 06 00 00       	call   803698 <sys_move_user_mem>
  802fc9:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802fcc:	83 ec 0c             	sub    $0xc,%esp
  802fcf:	ff 75 08             	pushl  0x8(%ebp)
  802fd2:	e8 2e ef ff ff       	call   801f05 <free>
  802fd7:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802fda:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802fdd:	c9                   	leave  
  802fde:	c3                   	ret    

00802fdf <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802fdf:	55                   	push   %ebp
  802fe0:	89 e5                	mov    %esp,%ebp
  802fe2:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802feb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fef:	0f 84 33 03 00 00    	je     803328 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802ff5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff8:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802ffd:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  803000:	83 ec 08             	sub    $0x8,%esp
  803003:	ff 75 08             	pushl  0x8(%ebp)
  803006:	ff 75 d8             	pushl  -0x28(%ebp)
  803009:	e8 7d 05 00 00       	call   80358b <sys_delete_shared_object>
  80300e:	83 c4 10             	add    $0x10,%esp
  803011:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  803014:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803018:	0f 88 0d 03 00 00    	js     80332b <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80301e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803025:	e9 ef 02 00 00       	jmp    803319 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80302a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302d:	89 d0                	mov    %edx,%eax
  80302f:	01 c0                	add    %eax,%eax
  803031:	01 d0                	add    %edx,%eax
  803033:	c1 e0 02             	shl    $0x2,%eax
  803036:	05 48 60 80 00       	add    $0x806048,%eax
  80303b:	8a 00                	mov    (%eax),%al
  80303d:	84 c0                	test   %al,%al
  80303f:	0f 84 d1 02 00 00    	je     803316 <sfree+0x337>
  803045:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803048:	89 d0                	mov    %edx,%eax
  80304a:	01 c0                	add    %eax,%eax
  80304c:	01 d0                	add    %edx,%eax
  80304e:	c1 e0 02             	shl    $0x2,%eax
  803051:	05 40 60 80 00       	add    $0x806040,%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80305b:	0f 85 b5 02 00 00    	jne    803316 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803064:	89 d0                	mov    %edx,%eax
  803066:	01 c0                	add    %eax,%eax
  803068:	01 d0                	add    %edx,%eax
  80306a:	c1 e0 02             	shl    $0x2,%eax
  80306d:	05 44 60 80 00       	add    $0x806044,%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307a:	89 d0                	mov    %edx,%eax
  80307c:	01 c0                	add    %eax,%eax
  80307e:	01 d0                	add    %edx,%eax
  803080:	c1 e0 02             	shl    $0x2,%eax
  803083:	05 48 60 80 00       	add    $0x806048,%eax
  803088:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  80308b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803092:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803099:	eb 64                	jmp    8030ff <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  80309b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80309e:	89 d0                	mov    %edx,%eax
  8030a0:	01 c0                	add    %eax,%eax
  8030a2:	01 d0                	add    %edx,%eax
  8030a4:	c1 e0 02             	shl    $0x2,%eax
  8030a7:	05 48 20 81 00       	add    $0x812048,%eax
  8030ac:	8a 00                	mov    (%eax),%al
  8030ae:	84 c0                	test   %al,%al
  8030b0:	75 4a                	jne    8030fc <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  8030b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030b5:	89 d0                	mov    %edx,%eax
  8030b7:	01 c0                	add    %eax,%eax
  8030b9:	01 d0                	add    %edx,%eax
  8030bb:	c1 e0 02             	shl    $0x2,%eax
  8030be:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8030c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c7:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  8030c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030cc:	89 d0                	mov    %edx,%eax
  8030ce:	01 c0                	add    %eax,%eax
  8030d0:	01 d0                	add    %edx,%eax
  8030d2:	c1 e0 02             	shl    $0x2,%eax
  8030d5:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  8030db:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030de:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  8030e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030e3:	89 d0                	mov    %edx,%eax
  8030e5:	01 c0                	add    %eax,%eax
  8030e7:	01 d0                	add    %edx,%eax
  8030e9:	c1 e0 02             	shl    $0x2,%eax
  8030ec:	05 48 20 81 00       	add    $0x812048,%eax
  8030f1:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  8030f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  8030fa:	eb 0c                	jmp    803108 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8030fc:	ff 45 ec             	incl   -0x14(%ebp)
  8030ff:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803106:	7e 93                	jle    80309b <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  803108:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80310c:	0f 84 8d 01 00 00    	je     80329f <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803112:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803119:	e9 74 01 00 00       	jmp    803292 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  80311e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803121:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803124:	0f 84 64 01 00 00    	je     80328e <sfree+0x2af>
					if (uhp_frees[k].free)
  80312a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312d:	89 d0                	mov    %edx,%eax
  80312f:	01 c0                	add    %eax,%eax
  803131:	01 d0                	add    %edx,%eax
  803133:	c1 e0 02             	shl    $0x2,%eax
  803136:	05 48 20 81 00       	add    $0x812048,%eax
  80313b:	8a 00                	mov    (%eax),%al
  80313d:	84 c0                	test   %al,%al
  80313f:	0f 84 4a 01 00 00    	je     80328f <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  803145:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803148:	89 d0                	mov    %edx,%eax
  80314a:	01 c0                	add    %eax,%eax
  80314c:	01 d0                	add    %edx,%eax
  80314e:	c1 e0 02             	shl    $0x2,%eax
  803151:	05 40 20 81 00       	add    $0x812040,%eax
  803156:	8b 08                	mov    (%eax),%ecx
  803158:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80315b:	89 d0                	mov    %edx,%eax
  80315d:	01 c0                	add    %eax,%eax
  80315f:	01 d0                	add    %edx,%eax
  803161:	c1 e0 02             	shl    $0x2,%eax
  803164:	05 44 20 81 00       	add    $0x812044,%eax
  803169:	8b 00                	mov    (%eax),%eax
  80316b:	01 c1                	add    %eax,%ecx
  80316d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803170:	89 d0                	mov    %edx,%eax
  803172:	01 c0                	add    %eax,%eax
  803174:	01 d0                	add    %edx,%eax
  803176:	c1 e0 02             	shl    $0x2,%eax
  803179:	05 40 20 81 00       	add    $0x812040,%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	39 c1                	cmp    %eax,%ecx
  803182:	75 7a                	jne    8031fe <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  803184:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803187:	89 d0                	mov    %edx,%eax
  803189:	01 c0                	add    %eax,%eax
  80318b:	01 d0                	add    %edx,%eax
  80318d:	c1 e0 02             	shl    $0x2,%eax
  803190:	05 40 20 81 00       	add    $0x812040,%eax
  803195:	8b 10                	mov    (%eax),%edx
  803197:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80319a:	89 c8                	mov    %ecx,%eax
  80319c:	01 c0                	add    %eax,%eax
  80319e:	01 c8                	add    %ecx,%eax
  8031a0:	c1 e0 02             	shl    $0x2,%eax
  8031a3:	05 40 20 81 00       	add    $0x812040,%eax
  8031a8:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  8031aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ad:	89 d0                	mov    %edx,%eax
  8031af:	01 c0                	add    %eax,%eax
  8031b1:	01 d0                	add    %edx,%eax
  8031b3:	c1 e0 02             	shl    $0x2,%eax
  8031b6:	05 44 20 81 00       	add    $0x812044,%eax
  8031bb:	8b 08                	mov    (%eax),%ecx
  8031bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c0:	89 d0                	mov    %edx,%eax
  8031c2:	01 c0                	add    %eax,%eax
  8031c4:	01 d0                	add    %edx,%eax
  8031c6:	c1 e0 02             	shl    $0x2,%eax
  8031c9:	05 44 20 81 00       	add    $0x812044,%eax
  8031ce:	8b 00                	mov    (%eax),%eax
  8031d0:	01 c1                	add    %eax,%ecx
  8031d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d5:	89 d0                	mov    %edx,%eax
  8031d7:	01 c0                	add    %eax,%eax
  8031d9:	01 d0                	add    %edx,%eax
  8031db:	c1 e0 02             	shl    $0x2,%eax
  8031de:	05 44 20 81 00       	add    $0x812044,%eax
  8031e3:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8031e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e8:	89 d0                	mov    %edx,%eax
  8031ea:	01 c0                	add    %eax,%eax
  8031ec:	01 d0                	add    %edx,%eax
  8031ee:	c1 e0 02             	shl    $0x2,%eax
  8031f1:	05 48 20 81 00       	add    $0x812048,%eax
  8031f6:	c6 00 00             	movb   $0x0,(%eax)
  8031f9:	e9 91 00 00 00       	jmp    80328f <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8031fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803201:	89 d0                	mov    %edx,%eax
  803203:	01 c0                	add    %eax,%eax
  803205:	01 d0                	add    %edx,%eax
  803207:	c1 e0 02             	shl    $0x2,%eax
  80320a:	05 40 20 81 00       	add    $0x812040,%eax
  80320f:	8b 08                	mov    (%eax),%ecx
  803211:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803214:	89 d0                	mov    %edx,%eax
  803216:	01 c0                	add    %eax,%eax
  803218:	01 d0                	add    %edx,%eax
  80321a:	c1 e0 02             	shl    $0x2,%eax
  80321d:	05 44 20 81 00       	add    $0x812044,%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	01 c1                	add    %eax,%ecx
  803226:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803229:	89 d0                	mov    %edx,%eax
  80322b:	01 c0                	add    %eax,%eax
  80322d:	01 d0                	add    %edx,%eax
  80322f:	c1 e0 02             	shl    $0x2,%eax
  803232:	05 40 20 81 00       	add    $0x812040,%eax
  803237:	8b 00                	mov    (%eax),%eax
  803239:	39 c1                	cmp    %eax,%ecx
  80323b:	75 52                	jne    80328f <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  80323d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803240:	89 d0                	mov    %edx,%eax
  803242:	01 c0                	add    %eax,%eax
  803244:	01 d0                	add    %edx,%eax
  803246:	c1 e0 02             	shl    $0x2,%eax
  803249:	05 44 20 81 00       	add    $0x812044,%eax
  80324e:	8b 08                	mov    (%eax),%ecx
  803250:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803253:	89 d0                	mov    %edx,%eax
  803255:	01 c0                	add    %eax,%eax
  803257:	01 d0                	add    %edx,%eax
  803259:	c1 e0 02             	shl    $0x2,%eax
  80325c:	05 44 20 81 00       	add    $0x812044,%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	01 c1                	add    %eax,%ecx
  803265:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803268:	89 d0                	mov    %edx,%eax
  80326a:	01 c0                	add    %eax,%eax
  80326c:	01 d0                	add    %edx,%eax
  80326e:	c1 e0 02             	shl    $0x2,%eax
  803271:	05 44 20 81 00       	add    $0x812044,%eax
  803276:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803278:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327b:	89 d0                	mov    %edx,%eax
  80327d:	01 c0                	add    %eax,%eax
  80327f:	01 d0                	add    %edx,%eax
  803281:	c1 e0 02             	shl    $0x2,%eax
  803284:	05 48 20 81 00       	add    $0x812048,%eax
  803289:	c6 00 00             	movb   $0x0,(%eax)
  80328c:	eb 01                	jmp    80328f <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  80328e:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80328f:	ff 45 e8             	incl   -0x18(%ebp)
  803292:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803299:	0f 8e 7f fe ff ff    	jle    80311e <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  80329f:	a1 30 61 83 00       	mov    0x836130,%eax
  8032a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8032a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032ae:	eb 53                	jmp    803303 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  8032b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032b3:	89 d0                	mov    %edx,%eax
  8032b5:	01 c0                	add    %eax,%eax
  8032b7:	01 d0                	add    %edx,%eax
  8032b9:	c1 e0 02             	shl    $0x2,%eax
  8032bc:	05 48 60 80 00       	add    $0x806048,%eax
  8032c1:	8a 00                	mov    (%eax),%al
  8032c3:	84 c0                	test   %al,%al
  8032c5:	74 39                	je     803300 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8032c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ca:	89 d0                	mov    %edx,%eax
  8032cc:	01 c0                	add    %eax,%eax
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	c1 e0 02             	shl    $0x2,%eax
  8032d3:	05 40 60 80 00       	add    $0x806040,%eax
  8032d8:	8b 08                	mov    (%eax),%ecx
  8032da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032dd:	89 d0                	mov    %edx,%eax
  8032df:	01 c0                	add    %eax,%eax
  8032e1:	01 d0                	add    %edx,%eax
  8032e3:	c1 e0 02             	shl    $0x2,%eax
  8032e6:	05 44 60 80 00       	add    $0x806044,%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	01 c8                	add    %ecx,%eax
  8032ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  8032f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032f5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032f8:	76 06                	jbe    803300 <sfree+0x321>
  8032fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803300:	ff 45 e0             	incl   -0x20(%ebp)
  803303:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80330a:	7e a4                	jle    8032b0 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  80330c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330f:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  803314:	eb 16                	jmp    80332c <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803316:	ff 45 f4             	incl   -0xc(%ebp)
  803319:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803320:	0f 8e 04 fd ff ff    	jle    80302a <sfree+0x4b>
  803326:	eb 04                	jmp    80332c <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803328:	90                   	nop
  803329:	eb 01                	jmp    80332c <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  80332b:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  80332c:	c9                   	leave  
  80332d:	c3                   	ret    

0080332e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80332e:	55                   	push   %ebp
  80332f:	89 e5                	mov    %esp,%ebp
  803331:	57                   	push   %edi
  803332:	56                   	push   %esi
  803333:	53                   	push   %ebx
  803334:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80333d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803340:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803343:	8b 7d 18             	mov    0x18(%ebp),%edi
  803346:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803349:	cd 30                	int    $0x30
  80334b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80334e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803351:	83 c4 10             	add    $0x10,%esp
  803354:	5b                   	pop    %ebx
  803355:	5e                   	pop    %esi
  803356:	5f                   	pop    %edi
  803357:	5d                   	pop    %ebp
  803358:	c3                   	ret    

00803359 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803359:	55                   	push   %ebp
  80335a:	89 e5                	mov    %esp,%ebp
  80335c:	83 ec 04             	sub    $0x4,%esp
  80335f:	8b 45 10             	mov    0x10(%ebp),%eax
  803362:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803365:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803368:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	6a 00                	push   $0x0
  803371:	51                   	push   %ecx
  803372:	52                   	push   %edx
  803373:	ff 75 0c             	pushl  0xc(%ebp)
  803376:	50                   	push   %eax
  803377:	6a 00                	push   $0x0
  803379:	e8 b0 ff ff ff       	call   80332e <syscall>
  80337e:	83 c4 18             	add    $0x18,%esp
}
  803381:	90                   	nop
  803382:	c9                   	leave  
  803383:	c3                   	ret    

00803384 <sys_cgetc>:

int
sys_cgetc(void)
{
  803384:	55                   	push   %ebp
  803385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803387:	6a 00                	push   $0x0
  803389:	6a 00                	push   $0x0
  80338b:	6a 00                	push   $0x0
  80338d:	6a 00                	push   $0x0
  80338f:	6a 00                	push   $0x0
  803391:	6a 02                	push   $0x2
  803393:	e8 96 ff ff ff       	call   80332e <syscall>
  803398:	83 c4 18             	add    $0x18,%esp
}
  80339b:	c9                   	leave  
  80339c:	c3                   	ret    

0080339d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80339d:	55                   	push   %ebp
  80339e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8033a0:	6a 00                	push   $0x0
  8033a2:	6a 00                	push   $0x0
  8033a4:	6a 00                	push   $0x0
  8033a6:	6a 00                	push   $0x0
  8033a8:	6a 00                	push   $0x0
  8033aa:	6a 03                	push   $0x3
  8033ac:	e8 7d ff ff ff       	call   80332e <syscall>
  8033b1:	83 c4 18             	add    $0x18,%esp
}
  8033b4:	90                   	nop
  8033b5:	c9                   	leave  
  8033b6:	c3                   	ret    

008033b7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8033ba:	6a 00                	push   $0x0
  8033bc:	6a 00                	push   $0x0
  8033be:	6a 00                	push   $0x0
  8033c0:	6a 00                	push   $0x0
  8033c2:	6a 00                	push   $0x0
  8033c4:	6a 04                	push   $0x4
  8033c6:	e8 63 ff ff ff       	call   80332e <syscall>
  8033cb:	83 c4 18             	add    $0x18,%esp
}
  8033ce:	90                   	nop
  8033cf:	c9                   	leave  
  8033d0:	c3                   	ret    

008033d1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8033d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	6a 00                	push   $0x0
  8033dc:	6a 00                	push   $0x0
  8033de:	6a 00                	push   $0x0
  8033e0:	52                   	push   %edx
  8033e1:	50                   	push   %eax
  8033e2:	6a 08                	push   $0x8
  8033e4:	e8 45 ff ff ff       	call   80332e <syscall>
  8033e9:	83 c4 18             	add    $0x18,%esp
}
  8033ec:	c9                   	leave  
  8033ed:	c3                   	ret    

008033ee <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8033ee:	55                   	push   %ebp
  8033ef:	89 e5                	mov    %esp,%ebp
  8033f1:	56                   	push   %esi
  8033f2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8033f3:	8b 75 18             	mov    0x18(%ebp),%esi
  8033f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8033f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8033fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	56                   	push   %esi
  803403:	53                   	push   %ebx
  803404:	51                   	push   %ecx
  803405:	52                   	push   %edx
  803406:	50                   	push   %eax
  803407:	6a 09                	push   $0x9
  803409:	e8 20 ff ff ff       	call   80332e <syscall>
  80340e:	83 c4 18             	add    $0x18,%esp
}
  803411:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803414:	5b                   	pop    %ebx
  803415:	5e                   	pop    %esi
  803416:	5d                   	pop    %ebp
  803417:	c3                   	ret    

00803418 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803418:	55                   	push   %ebp
  803419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80341b:	6a 00                	push   $0x0
  80341d:	6a 00                	push   $0x0
  80341f:	6a 00                	push   $0x0
  803421:	6a 00                	push   $0x0
  803423:	ff 75 08             	pushl  0x8(%ebp)
  803426:	6a 0a                	push   $0xa
  803428:	e8 01 ff ff ff       	call   80332e <syscall>
  80342d:	83 c4 18             	add    $0x18,%esp
}
  803430:	c9                   	leave  
  803431:	c3                   	ret    

00803432 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803432:	55                   	push   %ebp
  803433:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803435:	6a 00                	push   $0x0
  803437:	6a 00                	push   $0x0
  803439:	6a 00                	push   $0x0
  80343b:	ff 75 0c             	pushl  0xc(%ebp)
  80343e:	ff 75 08             	pushl  0x8(%ebp)
  803441:	6a 0b                	push   $0xb
  803443:	e8 e6 fe ff ff       	call   80332e <syscall>
  803448:	83 c4 18             	add    $0x18,%esp
}
  80344b:	c9                   	leave  
  80344c:	c3                   	ret    

0080344d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80344d:	55                   	push   %ebp
  80344e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803450:	6a 00                	push   $0x0
  803452:	6a 00                	push   $0x0
  803454:	6a 00                	push   $0x0
  803456:	6a 00                	push   $0x0
  803458:	6a 00                	push   $0x0
  80345a:	6a 0c                	push   $0xc
  80345c:	e8 cd fe ff ff       	call   80332e <syscall>
  803461:	83 c4 18             	add    $0x18,%esp
}
  803464:	c9                   	leave  
  803465:	c3                   	ret    

00803466 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803466:	55                   	push   %ebp
  803467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803469:	6a 00                	push   $0x0
  80346b:	6a 00                	push   $0x0
  80346d:	6a 00                	push   $0x0
  80346f:	6a 00                	push   $0x0
  803471:	6a 00                	push   $0x0
  803473:	6a 0d                	push   $0xd
  803475:	e8 b4 fe ff ff       	call   80332e <syscall>
  80347a:	83 c4 18             	add    $0x18,%esp
}
  80347d:	c9                   	leave  
  80347e:	c3                   	ret    

0080347f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80347f:	55                   	push   %ebp
  803480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803482:	6a 00                	push   $0x0
  803484:	6a 00                	push   $0x0
  803486:	6a 00                	push   $0x0
  803488:	6a 00                	push   $0x0
  80348a:	6a 00                	push   $0x0
  80348c:	6a 0e                	push   $0xe
  80348e:	e8 9b fe ff ff       	call   80332e <syscall>
  803493:	83 c4 18             	add    $0x18,%esp
}
  803496:	c9                   	leave  
  803497:	c3                   	ret    

00803498 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803498:	55                   	push   %ebp
  803499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80349b:	6a 00                	push   $0x0
  80349d:	6a 00                	push   $0x0
  80349f:	6a 00                	push   $0x0
  8034a1:	6a 00                	push   $0x0
  8034a3:	6a 00                	push   $0x0
  8034a5:	6a 0f                	push   $0xf
  8034a7:	e8 82 fe ff ff       	call   80332e <syscall>
  8034ac:	83 c4 18             	add    $0x18,%esp
}
  8034af:	c9                   	leave  
  8034b0:	c3                   	ret    

008034b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8034b1:	55                   	push   %ebp
  8034b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8034b4:	6a 00                	push   $0x0
  8034b6:	6a 00                	push   $0x0
  8034b8:	6a 00                	push   $0x0
  8034ba:	6a 00                	push   $0x0
  8034bc:	ff 75 08             	pushl  0x8(%ebp)
  8034bf:	6a 10                	push   $0x10
  8034c1:	e8 68 fe ff ff       	call   80332e <syscall>
  8034c6:	83 c4 18             	add    $0x18,%esp
}
  8034c9:	c9                   	leave  
  8034ca:	c3                   	ret    

008034cb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8034cb:	55                   	push   %ebp
  8034cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8034ce:	6a 00                	push   $0x0
  8034d0:	6a 00                	push   $0x0
  8034d2:	6a 00                	push   $0x0
  8034d4:	6a 00                	push   $0x0
  8034d6:	6a 00                	push   $0x0
  8034d8:	6a 11                	push   $0x11
  8034da:	e8 4f fe ff ff       	call   80332e <syscall>
  8034df:	83 c4 18             	add    $0x18,%esp
}
  8034e2:	90                   	nop
  8034e3:	c9                   	leave  
  8034e4:	c3                   	ret    

008034e5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8034e5:	55                   	push   %ebp
  8034e6:	89 e5                	mov    %esp,%ebp
  8034e8:	83 ec 04             	sub    $0x4,%esp
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8034f1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8034f5:	6a 00                	push   $0x0
  8034f7:	6a 00                	push   $0x0
  8034f9:	6a 00                	push   $0x0
  8034fb:	6a 00                	push   $0x0
  8034fd:	50                   	push   %eax
  8034fe:	6a 01                	push   $0x1
  803500:	e8 29 fe ff ff       	call   80332e <syscall>
  803505:	83 c4 18             	add    $0x18,%esp
}
  803508:	90                   	nop
  803509:	c9                   	leave  
  80350a:	c3                   	ret    

0080350b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80350b:	55                   	push   %ebp
  80350c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80350e:	6a 00                	push   $0x0
  803510:	6a 00                	push   $0x0
  803512:	6a 00                	push   $0x0
  803514:	6a 00                	push   $0x0
  803516:	6a 00                	push   $0x0
  803518:	6a 14                	push   $0x14
  80351a:	e8 0f fe ff ff       	call   80332e <syscall>
  80351f:	83 c4 18             	add    $0x18,%esp
}
  803522:	90                   	nop
  803523:	c9                   	leave  
  803524:	c3                   	ret    

00803525 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803525:	55                   	push   %ebp
  803526:	89 e5                	mov    %esp,%ebp
  803528:	83 ec 04             	sub    $0x4,%esp
  80352b:	8b 45 10             	mov    0x10(%ebp),%eax
  80352e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803531:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803534:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	6a 00                	push   $0x0
  80353d:	51                   	push   %ecx
  80353e:	52                   	push   %edx
  80353f:	ff 75 0c             	pushl  0xc(%ebp)
  803542:	50                   	push   %eax
  803543:	6a 15                	push   $0x15
  803545:	e8 e4 fd ff ff       	call   80332e <syscall>
  80354a:	83 c4 18             	add    $0x18,%esp
}
  80354d:	c9                   	leave  
  80354e:	c3                   	ret    

0080354f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80354f:	55                   	push   %ebp
  803550:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803552:	8b 55 0c             	mov    0xc(%ebp),%edx
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	6a 00                	push   $0x0
  80355a:	6a 00                	push   $0x0
  80355c:	6a 00                	push   $0x0
  80355e:	52                   	push   %edx
  80355f:	50                   	push   %eax
  803560:	6a 16                	push   $0x16
  803562:	e8 c7 fd ff ff       	call   80332e <syscall>
  803567:	83 c4 18             	add    $0x18,%esp
}
  80356a:	c9                   	leave  
  80356b:	c3                   	ret    

0080356c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80356c:	55                   	push   %ebp
  80356d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80356f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803572:	8b 55 0c             	mov    0xc(%ebp),%edx
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	6a 00                	push   $0x0
  80357a:	6a 00                	push   $0x0
  80357c:	51                   	push   %ecx
  80357d:	52                   	push   %edx
  80357e:	50                   	push   %eax
  80357f:	6a 17                	push   $0x17
  803581:	e8 a8 fd ff ff       	call   80332e <syscall>
  803586:	83 c4 18             	add    $0x18,%esp
}
  803589:	c9                   	leave  
  80358a:	c3                   	ret    

0080358b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80358b:	55                   	push   %ebp
  80358c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80358e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803591:	8b 45 08             	mov    0x8(%ebp),%eax
  803594:	6a 00                	push   $0x0
  803596:	6a 00                	push   $0x0
  803598:	6a 00                	push   $0x0
  80359a:	52                   	push   %edx
  80359b:	50                   	push   %eax
  80359c:	6a 18                	push   $0x18
  80359e:	e8 8b fd ff ff       	call   80332e <syscall>
  8035a3:	83 c4 18             	add    $0x18,%esp
}
  8035a6:	c9                   	leave  
  8035a7:	c3                   	ret    

008035a8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8035a8:	55                   	push   %ebp
  8035a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	6a 00                	push   $0x0
  8035b0:	ff 75 14             	pushl  0x14(%ebp)
  8035b3:	ff 75 10             	pushl  0x10(%ebp)
  8035b6:	ff 75 0c             	pushl  0xc(%ebp)
  8035b9:	50                   	push   %eax
  8035ba:	6a 19                	push   $0x19
  8035bc:	e8 6d fd ff ff       	call   80332e <syscall>
  8035c1:	83 c4 18             	add    $0x18,%esp
}
  8035c4:	c9                   	leave  
  8035c5:	c3                   	ret    

008035c6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8035c6:	55                   	push   %ebp
  8035c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cc:	6a 00                	push   $0x0
  8035ce:	6a 00                	push   $0x0
  8035d0:	6a 00                	push   $0x0
  8035d2:	6a 00                	push   $0x0
  8035d4:	50                   	push   %eax
  8035d5:	6a 1a                	push   $0x1a
  8035d7:	e8 52 fd ff ff       	call   80332e <syscall>
  8035dc:	83 c4 18             	add    $0x18,%esp
}
  8035df:	90                   	nop
  8035e0:	c9                   	leave  
  8035e1:	c3                   	ret    

008035e2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8035e2:	55                   	push   %ebp
  8035e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8035e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e8:	6a 00                	push   $0x0
  8035ea:	6a 00                	push   $0x0
  8035ec:	6a 00                	push   $0x0
  8035ee:	6a 00                	push   $0x0
  8035f0:	50                   	push   %eax
  8035f1:	6a 1b                	push   $0x1b
  8035f3:	e8 36 fd ff ff       	call   80332e <syscall>
  8035f8:	83 c4 18             	add    $0x18,%esp
}
  8035fb:	c9                   	leave  
  8035fc:	c3                   	ret    

008035fd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8035fd:	55                   	push   %ebp
  8035fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803600:	6a 00                	push   $0x0
  803602:	6a 00                	push   $0x0
  803604:	6a 00                	push   $0x0
  803606:	6a 00                	push   $0x0
  803608:	6a 00                	push   $0x0
  80360a:	6a 05                	push   $0x5
  80360c:	e8 1d fd ff ff       	call   80332e <syscall>
  803611:	83 c4 18             	add    $0x18,%esp
}
  803614:	c9                   	leave  
  803615:	c3                   	ret    

00803616 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803616:	55                   	push   %ebp
  803617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803619:	6a 00                	push   $0x0
  80361b:	6a 00                	push   $0x0
  80361d:	6a 00                	push   $0x0
  80361f:	6a 00                	push   $0x0
  803621:	6a 00                	push   $0x0
  803623:	6a 06                	push   $0x6
  803625:	e8 04 fd ff ff       	call   80332e <syscall>
  80362a:	83 c4 18             	add    $0x18,%esp
}
  80362d:	c9                   	leave  
  80362e:	c3                   	ret    

0080362f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80362f:	55                   	push   %ebp
  803630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803632:	6a 00                	push   $0x0
  803634:	6a 00                	push   $0x0
  803636:	6a 00                	push   $0x0
  803638:	6a 00                	push   $0x0
  80363a:	6a 00                	push   $0x0
  80363c:	6a 07                	push   $0x7
  80363e:	e8 eb fc ff ff       	call   80332e <syscall>
  803643:	83 c4 18             	add    $0x18,%esp
}
  803646:	c9                   	leave  
  803647:	c3                   	ret    

00803648 <sys_exit_env>:


void sys_exit_env(void)
{
  803648:	55                   	push   %ebp
  803649:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80364b:	6a 00                	push   $0x0
  80364d:	6a 00                	push   $0x0
  80364f:	6a 00                	push   $0x0
  803651:	6a 00                	push   $0x0
  803653:	6a 00                	push   $0x0
  803655:	6a 1c                	push   $0x1c
  803657:	e8 d2 fc ff ff       	call   80332e <syscall>
  80365c:	83 c4 18             	add    $0x18,%esp
}
  80365f:	90                   	nop
  803660:	c9                   	leave  
  803661:	c3                   	ret    

00803662 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803662:	55                   	push   %ebp
  803663:	89 e5                	mov    %esp,%ebp
  803665:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803668:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80366b:	8d 50 04             	lea    0x4(%eax),%edx
  80366e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803671:	6a 00                	push   $0x0
  803673:	6a 00                	push   $0x0
  803675:	6a 00                	push   $0x0
  803677:	52                   	push   %edx
  803678:	50                   	push   %eax
  803679:	6a 1d                	push   $0x1d
  80367b:	e8 ae fc ff ff       	call   80332e <syscall>
  803680:	83 c4 18             	add    $0x18,%esp
	return result;
  803683:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803686:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803689:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80368c:	89 01                	mov    %eax,(%ecx)
  80368e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	c9                   	leave  
  803695:	c2 04 00             	ret    $0x4

00803698 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803698:	55                   	push   %ebp
  803699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80369b:	6a 00                	push   $0x0
  80369d:	6a 00                	push   $0x0
  80369f:	ff 75 10             	pushl  0x10(%ebp)
  8036a2:	ff 75 0c             	pushl  0xc(%ebp)
  8036a5:	ff 75 08             	pushl  0x8(%ebp)
  8036a8:	6a 13                	push   $0x13
  8036aa:	e8 7f fc ff ff       	call   80332e <syscall>
  8036af:	83 c4 18             	add    $0x18,%esp
	return ;
  8036b2:	90                   	nop
}
  8036b3:	c9                   	leave  
  8036b4:	c3                   	ret    

008036b5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8036b5:	55                   	push   %ebp
  8036b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8036b8:	6a 00                	push   $0x0
  8036ba:	6a 00                	push   $0x0
  8036bc:	6a 00                	push   $0x0
  8036be:	6a 00                	push   $0x0
  8036c0:	6a 00                	push   $0x0
  8036c2:	6a 1e                	push   $0x1e
  8036c4:	e8 65 fc ff ff       	call   80332e <syscall>
  8036c9:	83 c4 18             	add    $0x18,%esp
}
  8036cc:	c9                   	leave  
  8036cd:	c3                   	ret    

008036ce <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8036ce:	55                   	push   %ebp
  8036cf:	89 e5                	mov    %esp,%ebp
  8036d1:	83 ec 04             	sub    $0x4,%esp
  8036d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8036da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8036de:	6a 00                	push   $0x0
  8036e0:	6a 00                	push   $0x0
  8036e2:	6a 00                	push   $0x0
  8036e4:	6a 00                	push   $0x0
  8036e6:	50                   	push   %eax
  8036e7:	6a 1f                	push   $0x1f
  8036e9:	e8 40 fc ff ff       	call   80332e <syscall>
  8036ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8036f1:	90                   	nop
}
  8036f2:	c9                   	leave  
  8036f3:	c3                   	ret    

008036f4 <rsttst>:
void rsttst()
{
  8036f4:	55                   	push   %ebp
  8036f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8036f7:	6a 00                	push   $0x0
  8036f9:	6a 00                	push   $0x0
  8036fb:	6a 00                	push   $0x0
  8036fd:	6a 00                	push   $0x0
  8036ff:	6a 00                	push   $0x0
  803701:	6a 21                	push   $0x21
  803703:	e8 26 fc ff ff       	call   80332e <syscall>
  803708:	83 c4 18             	add    $0x18,%esp
	return ;
  80370b:	90                   	nop
}
  80370c:	c9                   	leave  
  80370d:	c3                   	ret    

0080370e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80370e:	55                   	push   %ebp
  80370f:	89 e5                	mov    %esp,%ebp
  803711:	83 ec 04             	sub    $0x4,%esp
  803714:	8b 45 14             	mov    0x14(%ebp),%eax
  803717:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80371a:	8b 55 18             	mov    0x18(%ebp),%edx
  80371d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803721:	52                   	push   %edx
  803722:	50                   	push   %eax
  803723:	ff 75 10             	pushl  0x10(%ebp)
  803726:	ff 75 0c             	pushl  0xc(%ebp)
  803729:	ff 75 08             	pushl  0x8(%ebp)
  80372c:	6a 20                	push   $0x20
  80372e:	e8 fb fb ff ff       	call   80332e <syscall>
  803733:	83 c4 18             	add    $0x18,%esp
	return ;
  803736:	90                   	nop
}
  803737:	c9                   	leave  
  803738:	c3                   	ret    

00803739 <chktst>:
void chktst(uint32 n)
{
  803739:	55                   	push   %ebp
  80373a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80373c:	6a 00                	push   $0x0
  80373e:	6a 00                	push   $0x0
  803740:	6a 00                	push   $0x0
  803742:	6a 00                	push   $0x0
  803744:	ff 75 08             	pushl  0x8(%ebp)
  803747:	6a 22                	push   $0x22
  803749:	e8 e0 fb ff ff       	call   80332e <syscall>
  80374e:	83 c4 18             	add    $0x18,%esp
	return ;
  803751:	90                   	nop
}
  803752:	c9                   	leave  
  803753:	c3                   	ret    

00803754 <inctst>:

void inctst()
{
  803754:	55                   	push   %ebp
  803755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803757:	6a 00                	push   $0x0
  803759:	6a 00                	push   $0x0
  80375b:	6a 00                	push   $0x0
  80375d:	6a 00                	push   $0x0
  80375f:	6a 00                	push   $0x0
  803761:	6a 23                	push   $0x23
  803763:	e8 c6 fb ff ff       	call   80332e <syscall>
  803768:	83 c4 18             	add    $0x18,%esp
	return ;
  80376b:	90                   	nop
}
  80376c:	c9                   	leave  
  80376d:	c3                   	ret    

0080376e <gettst>:
uint32 gettst()
{
  80376e:	55                   	push   %ebp
  80376f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803771:	6a 00                	push   $0x0
  803773:	6a 00                	push   $0x0
  803775:	6a 00                	push   $0x0
  803777:	6a 00                	push   $0x0
  803779:	6a 00                	push   $0x0
  80377b:	6a 24                	push   $0x24
  80377d:	e8 ac fb ff ff       	call   80332e <syscall>
  803782:	83 c4 18             	add    $0x18,%esp
}
  803785:	c9                   	leave  
  803786:	c3                   	ret    

00803787 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803787:	55                   	push   %ebp
  803788:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80378a:	6a 00                	push   $0x0
  80378c:	6a 00                	push   $0x0
  80378e:	6a 00                	push   $0x0
  803790:	6a 00                	push   $0x0
  803792:	6a 00                	push   $0x0
  803794:	6a 25                	push   $0x25
  803796:	e8 93 fb ff ff       	call   80332e <syscall>
  80379b:	83 c4 18             	add    $0x18,%esp
  80379e:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  8037a3:	a1 80 60 83 00       	mov    0x836080,%eax
}
  8037a8:	c9                   	leave  
  8037a9:	c3                   	ret    

008037aa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8037aa:	55                   	push   %ebp
  8037ab:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8037b5:	6a 00                	push   $0x0
  8037b7:	6a 00                	push   $0x0
  8037b9:	6a 00                	push   $0x0
  8037bb:	6a 00                	push   $0x0
  8037bd:	ff 75 08             	pushl  0x8(%ebp)
  8037c0:	6a 26                	push   $0x26
  8037c2:	e8 67 fb ff ff       	call   80332e <syscall>
  8037c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8037ca:	90                   	nop
}
  8037cb:	c9                   	leave  
  8037cc:	c3                   	ret    

008037cd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8037cd:	55                   	push   %ebp
  8037ce:	89 e5                	mov    %esp,%ebp
  8037d0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8037d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8037d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8037d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	6a 00                	push   $0x0
  8037df:	53                   	push   %ebx
  8037e0:	51                   	push   %ecx
  8037e1:	52                   	push   %edx
  8037e2:	50                   	push   %eax
  8037e3:	6a 27                	push   $0x27
  8037e5:	e8 44 fb ff ff       	call   80332e <syscall>
  8037ea:	83 c4 18             	add    $0x18,%esp
}
  8037ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037f0:	c9                   	leave  
  8037f1:	c3                   	ret    

008037f2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8037f2:	55                   	push   %ebp
  8037f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8037f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	6a 00                	push   $0x0
  8037fd:	6a 00                	push   $0x0
  8037ff:	6a 00                	push   $0x0
  803801:	52                   	push   %edx
  803802:	50                   	push   %eax
  803803:	6a 28                	push   $0x28
  803805:	e8 24 fb ff ff       	call   80332e <syscall>
  80380a:	83 c4 18             	add    $0x18,%esp
}
  80380d:	c9                   	leave  
  80380e:	c3                   	ret    

0080380f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80380f:	55                   	push   %ebp
  803810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803812:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803815:	8b 55 0c             	mov    0xc(%ebp),%edx
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	6a 00                	push   $0x0
  80381d:	51                   	push   %ecx
  80381e:	ff 75 10             	pushl  0x10(%ebp)
  803821:	52                   	push   %edx
  803822:	50                   	push   %eax
  803823:	6a 29                	push   $0x29
  803825:	e8 04 fb ff ff       	call   80332e <syscall>
  80382a:	83 c4 18             	add    $0x18,%esp
}
  80382d:	c9                   	leave  
  80382e:	c3                   	ret    

0080382f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80382f:	55                   	push   %ebp
  803830:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803832:	6a 00                	push   $0x0
  803834:	6a 00                	push   $0x0
  803836:	ff 75 10             	pushl  0x10(%ebp)
  803839:	ff 75 0c             	pushl  0xc(%ebp)
  80383c:	ff 75 08             	pushl  0x8(%ebp)
  80383f:	6a 12                	push   $0x12
  803841:	e8 e8 fa ff ff       	call   80332e <syscall>
  803846:	83 c4 18             	add    $0x18,%esp
	return ;
  803849:	90                   	nop
}
  80384a:	c9                   	leave  
  80384b:	c3                   	ret    

0080384c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80384c:	55                   	push   %ebp
  80384d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80384f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	6a 00                	push   $0x0
  803857:	6a 00                	push   $0x0
  803859:	6a 00                	push   $0x0
  80385b:	52                   	push   %edx
  80385c:	50                   	push   %eax
  80385d:	6a 2a                	push   $0x2a
  80385f:	e8 ca fa ff ff       	call   80332e <syscall>
  803864:	83 c4 18             	add    $0x18,%esp
	return;
  803867:	90                   	nop
}
  803868:	c9                   	leave  
  803869:	c3                   	ret    

0080386a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80386a:	55                   	push   %ebp
  80386b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80386d:	6a 00                	push   $0x0
  80386f:	6a 00                	push   $0x0
  803871:	6a 00                	push   $0x0
  803873:	6a 00                	push   $0x0
  803875:	6a 00                	push   $0x0
  803877:	6a 2b                	push   $0x2b
  803879:	e8 b0 fa ff ff       	call   80332e <syscall>
  80387e:	83 c4 18             	add    $0x18,%esp
}
  803881:	c9                   	leave  
  803882:	c3                   	ret    

00803883 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803883:	55                   	push   %ebp
  803884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803886:	6a 00                	push   $0x0
  803888:	6a 00                	push   $0x0
  80388a:	6a 00                	push   $0x0
  80388c:	ff 75 0c             	pushl  0xc(%ebp)
  80388f:	ff 75 08             	pushl  0x8(%ebp)
  803892:	6a 2d                	push   $0x2d
  803894:	e8 95 fa ff ff       	call   80332e <syscall>
  803899:	83 c4 18             	add    $0x18,%esp
	return;
  80389c:	90                   	nop
}
  80389d:	c9                   	leave  
  80389e:	c3                   	ret    

0080389f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80389f:	55                   	push   %ebp
  8038a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8038a2:	6a 00                	push   $0x0
  8038a4:	6a 00                	push   $0x0
  8038a6:	6a 00                	push   $0x0
  8038a8:	ff 75 0c             	pushl  0xc(%ebp)
  8038ab:	ff 75 08             	pushl  0x8(%ebp)
  8038ae:	6a 2c                	push   $0x2c
  8038b0:	e8 79 fa ff ff       	call   80332e <syscall>
  8038b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8038b8:	90                   	nop
}
  8038b9:	c9                   	leave  
  8038ba:	c3                   	ret    

008038bb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8038bb:	55                   	push   %ebp
  8038bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8038be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	6a 00                	push   $0x0
  8038c6:	6a 00                	push   $0x0
  8038c8:	6a 00                	push   $0x0
  8038ca:	52                   	push   %edx
  8038cb:	50                   	push   %eax
  8038cc:	6a 2e                	push   $0x2e
  8038ce:	e8 5b fa ff ff       	call   80332e <syscall>
  8038d3:	83 c4 18             	add    $0x18,%esp
}
  8038d6:	90                   	nop
  8038d7:	c9                   	leave  
  8038d8:	c3                   	ret    

008038d9 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8038d9:	55                   	push   %ebp
  8038da:	89 e5                	mov    %esp,%ebp
  8038dc:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8038df:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  8038e6:	72 09                	jb     8038f1 <to_page_va+0x18>
  8038e8:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  8038ef:	72 14                	jb     803905 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8038f1:	83 ec 04             	sub    $0x4,%esp
  8038f4:	68 b8 4e 80 00       	push   $0x804eb8
  8038f9:	6a 15                	push   $0x15
  8038fb:	68 e3 4e 80 00       	push   $0x804ee3
  803900:	e8 10 d0 ff ff       	call   800915 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  80390d:	29 d0                	sub    %edx,%eax
  80390f:	c1 f8 02             	sar    $0x2,%eax
  803912:	89 c2                	mov    %eax,%edx
  803914:	89 d0                	mov    %edx,%eax
  803916:	c1 e0 02             	shl    $0x2,%eax
  803919:	01 d0                	add    %edx,%eax
  80391b:	c1 e0 02             	shl    $0x2,%eax
  80391e:	01 d0                	add    %edx,%eax
  803920:	c1 e0 02             	shl    $0x2,%eax
  803923:	01 d0                	add    %edx,%eax
  803925:	89 c1                	mov    %eax,%ecx
  803927:	c1 e1 08             	shl    $0x8,%ecx
  80392a:	01 c8                	add    %ecx,%eax
  80392c:	89 c1                	mov    %eax,%ecx
  80392e:	c1 e1 10             	shl    $0x10,%ecx
  803931:	01 c8                	add    %ecx,%eax
  803933:	01 c0                	add    %eax,%eax
  803935:	01 d0                	add    %edx,%eax
  803937:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80393a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393d:	c1 e0 0c             	shl    $0xc,%eax
  803940:	89 c2                	mov    %eax,%edx
  803942:	a1 84 60 83 00       	mov    0x836084,%eax
  803947:	01 d0                	add    %edx,%eax
}
  803949:	c9                   	leave  
  80394a:	c3                   	ret    

0080394b <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80394b:	55                   	push   %ebp
  80394c:	89 e5                	mov    %esp,%ebp
  80394e:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803951:	a1 84 60 83 00       	mov    0x836084,%eax
  803956:	8b 55 08             	mov    0x8(%ebp),%edx
  803959:	29 c2                	sub    %eax,%edx
  80395b:	89 d0                	mov    %edx,%eax
  80395d:	c1 e8 0c             	shr    $0xc,%eax
  803960:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803967:	78 09                	js     803972 <to_page_info+0x27>
  803969:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803970:	7e 14                	jle    803986 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803972:	83 ec 04             	sub    $0x4,%esp
  803975:	68 fc 4e 80 00       	push   $0x804efc
  80397a:	6a 21                	push   $0x21
  80397c:	68 e3 4e 80 00       	push   $0x804ee3
  803981:	e8 8f cf ff ff       	call   800915 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803989:	89 d0                	mov    %edx,%eax
  80398b:	01 c0                	add    %eax,%eax
  80398d:	01 d0                	add    %edx,%eax
  80398f:	c1 e0 02             	shl    $0x2,%eax
  803992:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803997:	c9                   	leave  
  803998:	c3                   	ret    

00803999 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803999:	55                   	push   %ebp
  80399a:	89 e5                	mov    %esp,%ebp
  80399c:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80399f:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a2:	05 00 00 00 02       	add    $0x2000000,%eax
  8039a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039aa:	73 16                	jae    8039c2 <initialize_dynamic_allocator+0x29>
  8039ac:	68 20 4f 80 00       	push   $0x804f20
  8039b1:	68 46 4f 80 00       	push   $0x804f46
  8039b6:	6a 2f                	push   $0x2f
  8039b8:	68 e3 4e 80 00       	push   $0x804ee3
  8039bd:	e8 53 cf ff ff       	call   800915 <_panic>
	dynAllocStart = daStart;
  8039c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c5:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  8039ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039cd:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8039d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8039d9:	eb 36                	jmp    803a11 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8039db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039de:	c1 e0 04             	shl    $0x4,%eax
  8039e1:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8039e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ef:	c1 e0 04             	shl    $0x4,%eax
  8039f2:	05 a4 60 83 00       	add    $0x8360a4,%eax
  8039f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a00:	c1 e0 04             	shl    $0x4,%eax
  803a03:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a0e:	ff 45 f4             	incl   -0xc(%ebp)
  803a11:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803a15:	7e c4                	jle    8039db <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803a17:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803a1e:	00 00 00 
  803a21:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803a28:	00 00 00 
  803a2b:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803a32:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803a35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a3c:	e9 1b 01 00 00       	jmp    803b5c <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803a41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a44:	89 d0                	mov    %edx,%eax
  803a46:	01 c0                	add    %eax,%eax
  803a48:	01 d0                	add    %edx,%eax
  803a4a:	c1 e0 02             	shl    $0x2,%eax
  803a4d:	05 88 e0 81 00       	add    $0x81e088,%eax
  803a52:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a5a:	89 d0                	mov    %edx,%eax
  803a5c:	01 c0                	add    %eax,%eax
  803a5e:	01 d0                	add    %edx,%eax
  803a60:	c1 e0 02             	shl    $0x2,%eax
  803a63:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803a68:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803a6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a70:	89 d0                	mov    %edx,%eax
  803a72:	01 c0                	add    %eax,%eax
  803a74:	01 d0                	add    %edx,%eax
  803a76:	c1 e0 02             	shl    $0x2,%eax
  803a79:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a7e:	8b 00                	mov    (%eax),%eax
  803a80:	85 c0                	test   %eax,%eax
  803a82:	74 2b                	je     803aaf <initialize_dynamic_allocator+0x116>
  803a84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a87:	89 d0                	mov    %edx,%eax
  803a89:	01 c0                	add    %eax,%eax
  803a8b:	01 d0                	add    %edx,%eax
  803a8d:	c1 e0 02             	shl    $0x2,%eax
  803a90:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a95:	8b 10                	mov    (%eax),%edx
  803a97:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803a9a:	89 c8                	mov    %ecx,%eax
  803a9c:	01 c0                	add    %eax,%eax
  803a9e:	01 c8                	add    %ecx,%eax
  803aa0:	c1 e0 02             	shl    $0x2,%eax
  803aa3:	05 84 e0 81 00       	add    $0x81e084,%eax
  803aa8:	8b 00                	mov    (%eax),%eax
  803aaa:	89 42 04             	mov    %eax,0x4(%edx)
  803aad:	eb 18                	jmp    803ac7 <initialize_dynamic_allocator+0x12e>
  803aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ab2:	89 d0                	mov    %edx,%eax
  803ab4:	01 c0                	add    %eax,%eax
  803ab6:	01 d0                	add    %edx,%eax
  803ab8:	c1 e0 02             	shl    $0x2,%eax
  803abb:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ac0:	8b 00                	mov    (%eax),%eax
  803ac2:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803ac7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aca:	89 d0                	mov    %edx,%eax
  803acc:	01 c0                	add    %eax,%eax
  803ace:	01 d0                	add    %edx,%eax
  803ad0:	c1 e0 02             	shl    $0x2,%eax
  803ad3:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ad8:	8b 00                	mov    (%eax),%eax
  803ada:	85 c0                	test   %eax,%eax
  803adc:	74 2a                	je     803b08 <initialize_dynamic_allocator+0x16f>
  803ade:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ae1:	89 d0                	mov    %edx,%eax
  803ae3:	01 c0                	add    %eax,%eax
  803ae5:	01 d0                	add    %edx,%eax
  803ae7:	c1 e0 02             	shl    $0x2,%eax
  803aea:	05 84 e0 81 00       	add    $0x81e084,%eax
  803aef:	8b 10                	mov    (%eax),%edx
  803af1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803af4:	89 c8                	mov    %ecx,%eax
  803af6:	01 c0                	add    %eax,%eax
  803af8:	01 c8                	add    %ecx,%eax
  803afa:	c1 e0 02             	shl    $0x2,%eax
  803afd:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b02:	8b 00                	mov    (%eax),%eax
  803b04:	89 02                	mov    %eax,(%edx)
  803b06:	eb 18                	jmp    803b20 <initialize_dynamic_allocator+0x187>
  803b08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b0b:	89 d0                	mov    %edx,%eax
  803b0d:	01 c0                	add    %eax,%eax
  803b0f:	01 d0                	add    %edx,%eax
  803b11:	c1 e0 02             	shl    $0x2,%eax
  803b14:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b19:	8b 00                	mov    (%eax),%eax
  803b1b:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803b20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b23:	89 d0                	mov    %edx,%eax
  803b25:	01 c0                	add    %eax,%eax
  803b27:	01 d0                	add    %edx,%eax
  803b29:	c1 e0 02             	shl    $0x2,%eax
  803b2c:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b3a:	89 d0                	mov    %edx,%eax
  803b3c:	01 c0                	add    %eax,%eax
  803b3e:	01 d0                	add    %edx,%eax
  803b40:	c1 e0 02             	shl    $0x2,%eax
  803b43:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b4e:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803b53:	48                   	dec    %eax
  803b54:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803b59:	ff 45 f0             	incl   -0x10(%ebp)
  803b5c:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803b63:	0f 8e d8 fe ff ff    	jle    803a41 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803b69:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803b70:	e9 9d 00 00 00       	jmp    803c12 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803b75:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803b7b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803b7e:	89 c8                	mov    %ecx,%eax
  803b80:	01 c0                	add    %eax,%eax
  803b82:	01 c8                	add    %ecx,%eax
  803b84:	c1 e0 02             	shl    $0x2,%eax
  803b87:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b8c:	89 10                	mov    %edx,(%eax)
  803b8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b91:	89 d0                	mov    %edx,%eax
  803b93:	01 c0                	add    %eax,%eax
  803b95:	01 d0                	add    %edx,%eax
  803b97:	c1 e0 02             	shl    $0x2,%eax
  803b9a:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b9f:	8b 00                	mov    (%eax),%eax
  803ba1:	85 c0                	test   %eax,%eax
  803ba3:	74 1c                	je     803bc1 <initialize_dynamic_allocator+0x228>
  803ba5:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803bab:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803bae:	89 c8                	mov    %ecx,%eax
  803bb0:	01 c0                	add    %eax,%eax
  803bb2:	01 c8                	add    %ecx,%eax
  803bb4:	c1 e0 02             	shl    $0x2,%eax
  803bb7:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bbc:	89 42 04             	mov    %eax,0x4(%edx)
  803bbf:	eb 16                	jmp    803bd7 <initialize_dynamic_allocator+0x23e>
  803bc1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bc4:	89 d0                	mov    %edx,%eax
  803bc6:	01 c0                	add    %eax,%eax
  803bc8:	01 d0                	add    %edx,%eax
  803bca:	c1 e0 02             	shl    $0x2,%eax
  803bcd:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bd2:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803bd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bda:	89 d0                	mov    %edx,%eax
  803bdc:	01 c0                	add    %eax,%eax
  803bde:	01 d0                	add    %edx,%eax
  803be0:	c1 e0 02             	shl    $0x2,%eax
  803be3:	05 80 e0 81 00       	add    $0x81e080,%eax
  803be8:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803bed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bf0:	89 d0                	mov    %edx,%eax
  803bf2:	01 c0                	add    %eax,%eax
  803bf4:	01 d0                	add    %edx,%eax
  803bf6:	c1 e0 02             	shl    $0x2,%eax
  803bf9:	05 84 e0 81 00       	add    $0x81e084,%eax
  803bfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c04:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803c09:	40                   	inc    %eax
  803c0a:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803c0f:	ff 4d ec             	decl   -0x14(%ebp)
  803c12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c16:	0f 89 59 ff ff ff    	jns    803b75 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803c1c:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803c23:	00 00 00 
}
  803c26:	90                   	nop
  803c27:	c9                   	leave  
  803c28:	c3                   	ret    

00803c29 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803c29:	55                   	push   %ebp
  803c2a:	89 e5                	mov    %esp,%ebp
  803c2c:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c32:	83 ec 0c             	sub    $0xc,%esp
  803c35:	50                   	push   %eax
  803c36:	e8 10 fd ff ff       	call   80394b <to_page_info>
  803c3b:	83 c4 10             	add    $0x10,%esp
  803c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c44:	8b 40 08             	mov    0x8(%eax),%eax
  803c47:	0f b7 c0             	movzwl %ax,%eax
}
  803c4a:	c9                   	leave  
  803c4b:	c3                   	ret    

00803c4c <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803c4c:	55                   	push   %ebp
  803c4d:	89 e5                	mov    %esp,%ebp
  803c4f:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c52:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c59:	76 16                	jbe    803c71 <alloc_block+0x25>
  803c5b:	68 5c 4f 80 00       	push   $0x804f5c
  803c60:	68 46 4f 80 00       	push   $0x804f46
  803c65:	6a 59                	push   $0x59
  803c67:	68 e3 4e 80 00       	push   $0x804ee3
  803c6c:	e8 a4 cc ff ff       	call   800915 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803c71:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803c78:	eb 08                	jmp    803c82 <alloc_block+0x36>
		allocSize <<= 1;
  803c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7d:	01 c0                	add    %eax,%eax
  803c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c85:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c88:	73 09                	jae    803c93 <alloc_block+0x47>
  803c8a:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803c91:	76 e7                	jbe    803c7a <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803c93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803c9a:	eb 03                	jmp    803c9f <alloc_block+0x53>
		listIndex++;
  803c9c:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca2:	ba 08 00 00 00       	mov    $0x8,%edx
  803ca7:	88 c1                	mov    %al,%cl
  803ca9:	d3 e2                	shl    %cl,%edx
  803cab:	89 d0                	mov    %edx,%eax
  803cad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803cb0:	72 ea                	jb     803c9c <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803cb8:	e9 f4 00 00 00       	jmp    803db1 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc0:	c1 e0 04             	shl    $0x4,%eax
  803cc3:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803cc8:	8b 00                	mov    (%eax),%eax
  803cca:	85 c0                	test   %eax,%eax
  803ccc:	0f 84 dc 00 00 00    	je     803dae <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cd5:	c1 e0 04             	shl    $0x4,%eax
  803cd8:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803cdd:	8b 00                	mov    (%eax),%eax
  803cdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803ce2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ce6:	75 14                	jne    803cfc <alloc_block+0xb0>
  803ce8:	83 ec 04             	sub    $0x4,%esp
  803ceb:	68 7d 4f 80 00       	push   $0x804f7d
  803cf0:	6a 6b                	push   $0x6b
  803cf2:	68 e3 4e 80 00       	push   $0x804ee3
  803cf7:	e8 19 cc ff ff       	call   800915 <_panic>
  803cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cff:	8b 00                	mov    (%eax),%eax
  803d01:	85 c0                	test   %eax,%eax
  803d03:	74 10                	je     803d15 <alloc_block+0xc9>
  803d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d08:	8b 00                	mov    (%eax),%eax
  803d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d0d:	8b 52 04             	mov    0x4(%edx),%edx
  803d10:	89 50 04             	mov    %edx,0x4(%eax)
  803d13:	eb 14                	jmp    803d29 <alloc_block+0xdd>
  803d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d18:	8b 40 04             	mov    0x4(%eax),%eax
  803d1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d1e:	c1 e2 04             	shl    $0x4,%edx
  803d21:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803d27:	89 02                	mov    %eax,(%edx)
  803d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2c:	8b 40 04             	mov    0x4(%eax),%eax
  803d2f:	85 c0                	test   %eax,%eax
  803d31:	74 0f                	je     803d42 <alloc_block+0xf6>
  803d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d36:	8b 40 04             	mov    0x4(%eax),%eax
  803d39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d3c:	8b 12                	mov    (%edx),%edx
  803d3e:	89 10                	mov    %edx,(%eax)
  803d40:	eb 13                	jmp    803d55 <alloc_block+0x109>
  803d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d45:	8b 00                	mov    (%eax),%eax
  803d47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d4a:	c1 e2 04             	shl    $0x4,%edx
  803d4d:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803d53:	89 02                	mov    %eax,(%edx)
  803d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d6b:	c1 e0 04             	shl    $0x4,%eax
  803d6e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d73:	8b 00                	mov    (%eax),%eax
  803d75:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d7b:	c1 e0 04             	shl    $0x4,%eax
  803d7e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d83:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d88:	83 ec 0c             	sub    $0xc,%esp
  803d8b:	50                   	push   %eax
  803d8c:	e8 ba fb ff ff       	call   80394b <to_page_info>
  803d91:	83 c4 10             	add    $0x10,%esp
  803d94:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d9a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803d9e:	48                   	dec    %eax
  803d9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803da2:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da9:	e9 8f 02 00 00       	jmp    80403d <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803dae:	ff 45 ec             	incl   -0x14(%ebp)
  803db1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803db5:	0f 8e 02 ff ff ff    	jle    803cbd <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803dbb:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803dc0:	85 c0                	test   %eax,%eax
  803dc2:	75 14                	jne    803dd8 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803dc4:	83 ec 04             	sub    $0x4,%esp
  803dc7:	68 9c 4f 80 00       	push   $0x804f9c
  803dcc:	6a 77                	push   $0x77
  803dce:	68 e3 4e 80 00       	push   $0x804ee3
  803dd3:	e8 3d cb ff ff       	call   800915 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803dd8:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803ddd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803de0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803de4:	75 14                	jne    803dfa <alloc_block+0x1ae>
  803de6:	83 ec 04             	sub    $0x4,%esp
  803de9:	68 7d 4f 80 00       	push   $0x804f7d
  803dee:	6a 7a                	push   $0x7a
  803df0:	68 e3 4e 80 00       	push   $0x804ee3
  803df5:	e8 1b cb ff ff       	call   800915 <_panic>
  803dfa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dfd:	8b 00                	mov    (%eax),%eax
  803dff:	85 c0                	test   %eax,%eax
  803e01:	74 10                	je     803e13 <alloc_block+0x1c7>
  803e03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e06:	8b 00                	mov    (%eax),%eax
  803e08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e0b:	8b 52 04             	mov    0x4(%edx),%edx
  803e0e:	89 50 04             	mov    %edx,0x4(%eax)
  803e11:	eb 0b                	jmp    803e1e <alloc_block+0x1d2>
  803e13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e16:	8b 40 04             	mov    0x4(%eax),%eax
  803e19:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803e1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e21:	8b 40 04             	mov    0x4(%eax),%eax
  803e24:	85 c0                	test   %eax,%eax
  803e26:	74 0f                	je     803e37 <alloc_block+0x1eb>
  803e28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e2b:	8b 40 04             	mov    0x4(%eax),%eax
  803e2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e31:	8b 12                	mov    (%edx),%edx
  803e33:	89 10                	mov    %edx,(%eax)
  803e35:	eb 0a                	jmp    803e41 <alloc_block+0x1f5>
  803e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3a:	8b 00                	mov    (%eax),%eax
  803e3c:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e54:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803e59:	48                   	dec    %eax
  803e5a:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803e5f:	83 ec 0c             	sub    $0xc,%esp
  803e62:	ff 75 dc             	pushl  -0x24(%ebp)
  803e65:	e8 6f fa ff ff       	call   8038d9 <to_page_va>
  803e6a:	83 c4 10             	add    $0x10,%esp
  803e6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803e70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e73:	83 ec 0c             	sub    $0xc,%esp
  803e76:	50                   	push   %eax
  803e77:	e8 a0 dc ff ff       	call   801b1c <get_page>
  803e7c:	83 c4 10             	add    $0x10,%esp
  803e7f:	85 c0                	test   %eax,%eax
  803e81:	74 14                	je     803e97 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803e83:	83 ec 04             	sub    $0x4,%esp
  803e86:	68 c4 4f 80 00       	push   $0x804fc4
  803e8b:	6a 7f                	push   $0x7f
  803e8d:	68 e3 4e 80 00       	push   $0x804ee3
  803e92:	e8 7e ca ff ff       	call   800915 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e9d:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803ea1:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  803eab:	f7 75 f4             	divl   -0xc(%ebp)
  803eae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803eb1:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803eb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ebc:	e9 a7 00 00 00       	jmp    803f68 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803ec1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec7:	01 d0                	add    %edx,%eax
  803ec9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803ecc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ed0:	75 17                	jne    803ee9 <alloc_block+0x29d>
  803ed2:	83 ec 04             	sub    $0x4,%esp
  803ed5:	68 ec 4f 80 00       	push   $0x804fec
  803eda:	68 88 00 00 00       	push   $0x88
  803edf:	68 e3 4e 80 00       	push   $0x804ee3
  803ee4:	e8 2c ca ff ff       	call   800915 <_panic>
  803ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eec:	c1 e0 04             	shl    $0x4,%eax
  803eef:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ef4:	8b 10                	mov    (%eax),%edx
  803ef6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ef9:	89 10                	mov    %edx,(%eax)
  803efb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803efe:	8b 00                	mov    (%eax),%eax
  803f00:	85 c0                	test   %eax,%eax
  803f02:	74 15                	je     803f19 <alloc_block+0x2cd>
  803f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f07:	c1 e0 04             	shl    $0x4,%eax
  803f0a:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f0f:	8b 00                	mov    (%eax),%eax
  803f11:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f14:	89 50 04             	mov    %edx,0x4(%eax)
  803f17:	eb 11                	jmp    803f2a <alloc_block+0x2de>
  803f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f1c:	c1 e0 04             	shl    $0x4,%eax
  803f1f:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803f25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f28:	89 02                	mov    %eax,(%edx)
  803f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f2d:	c1 e0 04             	shl    $0x4,%eax
  803f30:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803f36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f39:	89 02                	mov    %eax,(%edx)
  803f3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f48:	c1 e0 04             	shl    $0x4,%eax
  803f4b:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f50:	8b 00                	mov    (%eax),%eax
  803f52:	8d 50 01             	lea    0x1(%eax),%edx
  803f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f58:	c1 e0 04             	shl    $0x4,%eax
  803f5b:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f60:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f65:	01 45 e8             	add    %eax,-0x18(%ebp)
  803f68:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803f6f:	0f 86 4c ff ff ff    	jbe    803ec1 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f78:	c1 e0 04             	shl    $0x4,%eax
  803f7b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f80:	8b 00                	mov    (%eax),%eax
  803f82:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803f85:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803f89:	75 17                	jne    803fa2 <alloc_block+0x356>
  803f8b:	83 ec 04             	sub    $0x4,%esp
  803f8e:	68 7d 4f 80 00       	push   $0x804f7d
  803f93:	68 8d 00 00 00       	push   $0x8d
  803f98:	68 e3 4e 80 00       	push   $0x804ee3
  803f9d:	e8 73 c9 ff ff       	call   800915 <_panic>
  803fa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fa5:	8b 00                	mov    (%eax),%eax
  803fa7:	85 c0                	test   %eax,%eax
  803fa9:	74 10                	je     803fbb <alloc_block+0x36f>
  803fab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fae:	8b 00                	mov    (%eax),%eax
  803fb0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803fb3:	8b 52 04             	mov    0x4(%edx),%edx
  803fb6:	89 50 04             	mov    %edx,0x4(%eax)
  803fb9:	eb 14                	jmp    803fcf <alloc_block+0x383>
  803fbb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fbe:	8b 40 04             	mov    0x4(%eax),%eax
  803fc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fc4:	c1 e2 04             	shl    $0x4,%edx
  803fc7:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803fcd:	89 02                	mov    %eax,(%edx)
  803fcf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fd2:	8b 40 04             	mov    0x4(%eax),%eax
  803fd5:	85 c0                	test   %eax,%eax
  803fd7:	74 0f                	je     803fe8 <alloc_block+0x39c>
  803fd9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fdc:	8b 40 04             	mov    0x4(%eax),%eax
  803fdf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803fe2:	8b 12                	mov    (%edx),%edx
  803fe4:	89 10                	mov    %edx,(%eax)
  803fe6:	eb 13                	jmp    803ffb <alloc_block+0x3af>
  803fe8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803feb:	8b 00                	mov    (%eax),%eax
  803fed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ff0:	c1 e2 04             	shl    $0x4,%edx
  803ff3:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803ff9:	89 02                	mov    %eax,(%edx)
  803ffb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ffe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804004:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804007:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80400e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804011:	c1 e0 04             	shl    $0x4,%eax
  804014:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804019:	8b 00                	mov    (%eax),%eax
  80401b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80401e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804021:	c1 e0 04             	shl    $0x4,%eax
  804024:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804029:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  80402b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80402e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804032:	48                   	dec    %eax
  804033:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804036:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  80403a:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  80403d:	c9                   	leave  
  80403e:	c3                   	ret    

0080403f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80403f:	55                   	push   %ebp
  804040:	89 e5                	mov    %esp,%ebp
  804042:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804045:	8b 55 08             	mov    0x8(%ebp),%edx
  804048:	a1 84 60 83 00       	mov    0x836084,%eax
  80404d:	39 c2                	cmp    %eax,%edx
  80404f:	72 0c                	jb     80405d <free_block+0x1e>
  804051:	8b 55 08             	mov    0x8(%ebp),%edx
  804054:	a1 60 e0 81 00       	mov    0x81e060,%eax
  804059:	39 c2                	cmp    %eax,%edx
  80405b:	72 19                	jb     804076 <free_block+0x37>
  80405d:	68 10 50 80 00       	push   $0x805010
  804062:	68 46 4f 80 00       	push   $0x804f46
  804067:	68 98 00 00 00       	push   $0x98
  80406c:	68 e3 4e 80 00       	push   $0x804ee3
  804071:	e8 9f c8 ff ff       	call   800915 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804076:	8b 45 08             	mov    0x8(%ebp),%eax
  804079:	83 ec 0c             	sub    $0xc,%esp
  80407c:	50                   	push   %eax
  80407d:	e8 c9 f8 ff ff       	call   80394b <to_page_info>
  804082:	83 c4 10             	add    $0x10,%esp
  804085:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80408b:	8b 40 08             	mov    0x8(%eax),%eax
  80408e:	0f b7 c0             	movzwl %ax,%eax
  804091:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  804094:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  80409b:	eb 03                	jmp    8040a0 <free_block+0x61>
		listIndex++;
  80409d:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8040a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a3:	ba 08 00 00 00       	mov    $0x8,%edx
  8040a8:	88 c1                	mov    %al,%cl
  8040aa:	d3 e2                	shl    %cl,%edx
  8040ac:	89 d0                	mov    %edx,%eax
  8040ae:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8040b1:	72 ea                	jb     80409d <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  8040b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  8040b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040bd:	75 17                	jne    8040d6 <free_block+0x97>
  8040bf:	83 ec 04             	sub    $0x4,%esp
  8040c2:	68 ec 4f 80 00       	push   $0x804fec
  8040c7:	68 a2 00 00 00       	push   $0xa2
  8040cc:	68 e3 4e 80 00       	push   $0x804ee3
  8040d1:	e8 3f c8 ff ff       	call   800915 <_panic>
  8040d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d9:	c1 e0 04             	shl    $0x4,%eax
  8040dc:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8040e1:	8b 10                	mov    (%eax),%edx
  8040e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e6:	89 10                	mov    %edx,(%eax)
  8040e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040eb:	8b 00                	mov    (%eax),%eax
  8040ed:	85 c0                	test   %eax,%eax
  8040ef:	74 15                	je     804106 <free_block+0xc7>
  8040f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f4:	c1 e0 04             	shl    $0x4,%eax
  8040f7:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8040fc:	8b 00                	mov    (%eax),%eax
  8040fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804101:	89 50 04             	mov    %edx,0x4(%eax)
  804104:	eb 11                	jmp    804117 <free_block+0xd8>
  804106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804109:	c1 e0 04             	shl    $0x4,%eax
  80410c:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  804112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804115:	89 02                	mov    %eax,(%edx)
  804117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80411a:	c1 e0 04             	shl    $0x4,%eax
  80411d:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  804123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804126:	89 02                	mov    %eax,(%edx)
  804128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804135:	c1 e0 04             	shl    $0x4,%eax
  804138:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80413d:	8b 00                	mov    (%eax),%eax
  80413f:	8d 50 01             	lea    0x1(%eax),%edx
  804142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804145:	c1 e0 04             	shl    $0x4,%eax
  804148:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80414d:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  80414f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804152:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804156:	40                   	inc    %eax
  804157:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80415a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  80415e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804161:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804165:	0f b7 c8             	movzwl %ax,%ecx
  804168:	b8 00 10 00 00       	mov    $0x1000,%eax
  80416d:	ba 00 00 00 00       	mov    $0x0,%edx
  804172:	f7 75 e8             	divl   -0x18(%ebp)
  804175:	39 c1                	cmp    %eax,%ecx
  804177:	0f 85 ed 01 00 00    	jne    80436a <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  80417d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804180:	c1 e0 04             	shl    $0x4,%eax
  804183:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804188:	8b 00                	mov    (%eax),%eax
  80418a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80418d:	eb 2a                	jmp    8041b9 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  80418f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804192:	83 ec 0c             	sub    $0xc,%esp
  804195:	50                   	push   %eax
  804196:	e8 b0 f7 ff ff       	call   80394b <to_page_info>
  80419b:	83 c4 10             	add    $0x10,%esp
  80419e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8041a1:	75 06                	jne    8041a9 <free_block+0x16a>
				tmp = b;
  8041a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8041a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ac:	c1 e0 04             	shl    $0x4,%eax
  8041af:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8041b4:	8b 00                	mov    (%eax),%eax
  8041b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041bd:	74 07                	je     8041c6 <free_block+0x187>
  8041bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041c2:	8b 00                	mov    (%eax),%eax
  8041c4:	eb 05                	jmp    8041cb <free_block+0x18c>
  8041c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8041cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8041ce:	c1 e2 04             	shl    $0x4,%edx
  8041d1:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  8041d7:	89 02                	mov    %eax,(%edx)
  8041d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041dc:	c1 e0 04             	shl    $0x4,%eax
  8041df:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8041e4:	8b 00                	mov    (%eax),%eax
  8041e6:	85 c0                	test   %eax,%eax
  8041e8:	75 a5                	jne    80418f <free_block+0x150>
  8041ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041ee:	75 9f                	jne    80418f <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  8041f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f3:	c1 e0 04             	shl    $0x4,%eax
  8041f6:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041fb:	8b 00                	mov    (%eax),%eax
  8041fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804200:	e9 cc 00 00 00       	jmp    8042d1 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  804205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804208:	8b 00                	mov    (%eax),%eax
  80420a:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  80420d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804210:	83 ec 0c             	sub    $0xc,%esp
  804213:	50                   	push   %eax
  804214:	e8 32 f7 ff ff       	call   80394b <to_page_info>
  804219:	83 c4 10             	add    $0x10,%esp
  80421c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80421f:	0f 85 a6 00 00 00    	jne    8042cb <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  804225:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804229:	75 17                	jne    804242 <free_block+0x203>
  80422b:	83 ec 04             	sub    $0x4,%esp
  80422e:	68 7d 4f 80 00       	push   $0x804f7d
  804233:	68 b5 00 00 00       	push   $0xb5
  804238:	68 e3 4e 80 00       	push   $0x804ee3
  80423d:	e8 d3 c6 ff ff       	call   800915 <_panic>
  804242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804245:	8b 00                	mov    (%eax),%eax
  804247:	85 c0                	test   %eax,%eax
  804249:	74 10                	je     80425b <free_block+0x21c>
  80424b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80424e:	8b 00                	mov    (%eax),%eax
  804250:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804253:	8b 52 04             	mov    0x4(%edx),%edx
  804256:	89 50 04             	mov    %edx,0x4(%eax)
  804259:	eb 14                	jmp    80426f <free_block+0x230>
  80425b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80425e:	8b 40 04             	mov    0x4(%eax),%eax
  804261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804264:	c1 e2 04             	shl    $0x4,%edx
  804267:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  80426d:	89 02                	mov    %eax,(%edx)
  80426f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804272:	8b 40 04             	mov    0x4(%eax),%eax
  804275:	85 c0                	test   %eax,%eax
  804277:	74 0f                	je     804288 <free_block+0x249>
  804279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80427c:	8b 40 04             	mov    0x4(%eax),%eax
  80427f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804282:	8b 12                	mov    (%edx),%edx
  804284:	89 10                	mov    %edx,(%eax)
  804286:	eb 13                	jmp    80429b <free_block+0x25c>
  804288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80428b:	8b 00                	mov    (%eax),%eax
  80428d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804290:	c1 e2 04             	shl    $0x4,%edx
  804293:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804299:	89 02                	mov    %eax,(%edx)
  80429b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80429e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b1:	c1 e0 04             	shl    $0x4,%eax
  8042b4:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042b9:	8b 00                	mov    (%eax),%eax
  8042bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8042be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c1:	c1 e0 04             	shl    $0x4,%eax
  8042c4:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042c9:	89 10                	mov    %edx,(%eax)
			b = next;
  8042cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  8042d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042d5:	0f 85 2a ff ff ff    	jne    804205 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  8042db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042de:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8042e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042e7:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  8042ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8042f1:	75 17                	jne    80430a <free_block+0x2cb>
  8042f3:	83 ec 04             	sub    $0x4,%esp
  8042f6:	68 ec 4f 80 00       	push   $0x804fec
  8042fb:	68 bc 00 00 00       	push   $0xbc
  804300:	68 e3 4e 80 00       	push   $0x804ee3
  804305:	e8 0b c6 ff ff       	call   800915 <_panic>
  80430a:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  804310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804313:	89 10                	mov    %edx,(%eax)
  804315:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804318:	8b 00                	mov    (%eax),%eax
  80431a:	85 c0                	test   %eax,%eax
  80431c:	74 0d                	je     80432b <free_block+0x2ec>
  80431e:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804323:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804326:	89 50 04             	mov    %edx,0x4(%eax)
  804329:	eb 08                	jmp    804333 <free_block+0x2f4>
  80432b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80432e:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  804333:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804336:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80433b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80433e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804345:	a1 74 e0 81 00       	mov    0x81e074,%eax
  80434a:	40                   	inc    %eax
  80434b:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804350:	83 ec 0c             	sub    $0xc,%esp
  804353:	ff 75 ec             	pushl  -0x14(%ebp)
  804356:	e8 7e f5 ff ff       	call   8038d9 <to_page_va>
  80435b:	83 c4 10             	add    $0x10,%esp
  80435e:	83 ec 0c             	sub    $0xc,%esp
  804361:	50                   	push   %eax
  804362:	e8 fe d7 ff ff       	call   801b65 <return_page>
  804367:	83 c4 10             	add    $0x10,%esp
	}
}
  80436a:	90                   	nop
  80436b:	c9                   	leave  
  80436c:	c3                   	ret    
  80436d:	66 90                	xchg   %ax,%ax
  80436f:	90                   	nop

00804370 <__udivdi3>:
  804370:	55                   	push   %ebp
  804371:	57                   	push   %edi
  804372:	56                   	push   %esi
  804373:	53                   	push   %ebx
  804374:	83 ec 1c             	sub    $0x1c,%esp
  804377:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80437b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80437f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804383:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804387:	89 ca                	mov    %ecx,%edx
  804389:	89 f8                	mov    %edi,%eax
  80438b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80438f:	85 f6                	test   %esi,%esi
  804391:	75 2d                	jne    8043c0 <__udivdi3+0x50>
  804393:	39 cf                	cmp    %ecx,%edi
  804395:	77 65                	ja     8043fc <__udivdi3+0x8c>
  804397:	89 fd                	mov    %edi,%ebp
  804399:	85 ff                	test   %edi,%edi
  80439b:	75 0b                	jne    8043a8 <__udivdi3+0x38>
  80439d:	b8 01 00 00 00       	mov    $0x1,%eax
  8043a2:	31 d2                	xor    %edx,%edx
  8043a4:	f7 f7                	div    %edi
  8043a6:	89 c5                	mov    %eax,%ebp
  8043a8:	31 d2                	xor    %edx,%edx
  8043aa:	89 c8                	mov    %ecx,%eax
  8043ac:	f7 f5                	div    %ebp
  8043ae:	89 c1                	mov    %eax,%ecx
  8043b0:	89 d8                	mov    %ebx,%eax
  8043b2:	f7 f5                	div    %ebp
  8043b4:	89 cf                	mov    %ecx,%edi
  8043b6:	89 fa                	mov    %edi,%edx
  8043b8:	83 c4 1c             	add    $0x1c,%esp
  8043bb:	5b                   	pop    %ebx
  8043bc:	5e                   	pop    %esi
  8043bd:	5f                   	pop    %edi
  8043be:	5d                   	pop    %ebp
  8043bf:	c3                   	ret    
  8043c0:	39 ce                	cmp    %ecx,%esi
  8043c2:	77 28                	ja     8043ec <__udivdi3+0x7c>
  8043c4:	0f bd fe             	bsr    %esi,%edi
  8043c7:	83 f7 1f             	xor    $0x1f,%edi
  8043ca:	75 40                	jne    80440c <__udivdi3+0x9c>
  8043cc:	39 ce                	cmp    %ecx,%esi
  8043ce:	72 0a                	jb     8043da <__udivdi3+0x6a>
  8043d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043d4:	0f 87 9e 00 00 00    	ja     804478 <__udivdi3+0x108>
  8043da:	b8 01 00 00 00       	mov    $0x1,%eax
  8043df:	89 fa                	mov    %edi,%edx
  8043e1:	83 c4 1c             	add    $0x1c,%esp
  8043e4:	5b                   	pop    %ebx
  8043e5:	5e                   	pop    %esi
  8043e6:	5f                   	pop    %edi
  8043e7:	5d                   	pop    %ebp
  8043e8:	c3                   	ret    
  8043e9:	8d 76 00             	lea    0x0(%esi),%esi
  8043ec:	31 ff                	xor    %edi,%edi
  8043ee:	31 c0                	xor    %eax,%eax
  8043f0:	89 fa                	mov    %edi,%edx
  8043f2:	83 c4 1c             	add    $0x1c,%esp
  8043f5:	5b                   	pop    %ebx
  8043f6:	5e                   	pop    %esi
  8043f7:	5f                   	pop    %edi
  8043f8:	5d                   	pop    %ebp
  8043f9:	c3                   	ret    
  8043fa:	66 90                	xchg   %ax,%ax
  8043fc:	89 d8                	mov    %ebx,%eax
  8043fe:	f7 f7                	div    %edi
  804400:	31 ff                	xor    %edi,%edi
  804402:	89 fa                	mov    %edi,%edx
  804404:	83 c4 1c             	add    $0x1c,%esp
  804407:	5b                   	pop    %ebx
  804408:	5e                   	pop    %esi
  804409:	5f                   	pop    %edi
  80440a:	5d                   	pop    %ebp
  80440b:	c3                   	ret    
  80440c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804411:	89 eb                	mov    %ebp,%ebx
  804413:	29 fb                	sub    %edi,%ebx
  804415:	89 f9                	mov    %edi,%ecx
  804417:	d3 e6                	shl    %cl,%esi
  804419:	89 c5                	mov    %eax,%ebp
  80441b:	88 d9                	mov    %bl,%cl
  80441d:	d3 ed                	shr    %cl,%ebp
  80441f:	89 e9                	mov    %ebp,%ecx
  804421:	09 f1                	or     %esi,%ecx
  804423:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804427:	89 f9                	mov    %edi,%ecx
  804429:	d3 e0                	shl    %cl,%eax
  80442b:	89 c5                	mov    %eax,%ebp
  80442d:	89 d6                	mov    %edx,%esi
  80442f:	88 d9                	mov    %bl,%cl
  804431:	d3 ee                	shr    %cl,%esi
  804433:	89 f9                	mov    %edi,%ecx
  804435:	d3 e2                	shl    %cl,%edx
  804437:	8b 44 24 08          	mov    0x8(%esp),%eax
  80443b:	88 d9                	mov    %bl,%cl
  80443d:	d3 e8                	shr    %cl,%eax
  80443f:	09 c2                	or     %eax,%edx
  804441:	89 d0                	mov    %edx,%eax
  804443:	89 f2                	mov    %esi,%edx
  804445:	f7 74 24 0c          	divl   0xc(%esp)
  804449:	89 d6                	mov    %edx,%esi
  80444b:	89 c3                	mov    %eax,%ebx
  80444d:	f7 e5                	mul    %ebp
  80444f:	39 d6                	cmp    %edx,%esi
  804451:	72 19                	jb     80446c <__udivdi3+0xfc>
  804453:	74 0b                	je     804460 <__udivdi3+0xf0>
  804455:	89 d8                	mov    %ebx,%eax
  804457:	31 ff                	xor    %edi,%edi
  804459:	e9 58 ff ff ff       	jmp    8043b6 <__udivdi3+0x46>
  80445e:	66 90                	xchg   %ax,%ax
  804460:	8b 54 24 08          	mov    0x8(%esp),%edx
  804464:	89 f9                	mov    %edi,%ecx
  804466:	d3 e2                	shl    %cl,%edx
  804468:	39 c2                	cmp    %eax,%edx
  80446a:	73 e9                	jae    804455 <__udivdi3+0xe5>
  80446c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80446f:	31 ff                	xor    %edi,%edi
  804471:	e9 40 ff ff ff       	jmp    8043b6 <__udivdi3+0x46>
  804476:	66 90                	xchg   %ax,%ax
  804478:	31 c0                	xor    %eax,%eax
  80447a:	e9 37 ff ff ff       	jmp    8043b6 <__udivdi3+0x46>
  80447f:	90                   	nop

00804480 <__umoddi3>:
  804480:	55                   	push   %ebp
  804481:	57                   	push   %edi
  804482:	56                   	push   %esi
  804483:	53                   	push   %ebx
  804484:	83 ec 1c             	sub    $0x1c,%esp
  804487:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80448b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80448f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804493:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804497:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80449b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80449f:	89 f3                	mov    %esi,%ebx
  8044a1:	89 fa                	mov    %edi,%edx
  8044a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044a7:	89 34 24             	mov    %esi,(%esp)
  8044aa:	85 c0                	test   %eax,%eax
  8044ac:	75 1a                	jne    8044c8 <__umoddi3+0x48>
  8044ae:	39 f7                	cmp    %esi,%edi
  8044b0:	0f 86 a2 00 00 00    	jbe    804558 <__umoddi3+0xd8>
  8044b6:	89 c8                	mov    %ecx,%eax
  8044b8:	89 f2                	mov    %esi,%edx
  8044ba:	f7 f7                	div    %edi
  8044bc:	89 d0                	mov    %edx,%eax
  8044be:	31 d2                	xor    %edx,%edx
  8044c0:	83 c4 1c             	add    $0x1c,%esp
  8044c3:	5b                   	pop    %ebx
  8044c4:	5e                   	pop    %esi
  8044c5:	5f                   	pop    %edi
  8044c6:	5d                   	pop    %ebp
  8044c7:	c3                   	ret    
  8044c8:	39 f0                	cmp    %esi,%eax
  8044ca:	0f 87 ac 00 00 00    	ja     80457c <__umoddi3+0xfc>
  8044d0:	0f bd e8             	bsr    %eax,%ebp
  8044d3:	83 f5 1f             	xor    $0x1f,%ebp
  8044d6:	0f 84 ac 00 00 00    	je     804588 <__umoddi3+0x108>
  8044dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8044e1:	29 ef                	sub    %ebp,%edi
  8044e3:	89 fe                	mov    %edi,%esi
  8044e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044e9:	89 e9                	mov    %ebp,%ecx
  8044eb:	d3 e0                	shl    %cl,%eax
  8044ed:	89 d7                	mov    %edx,%edi
  8044ef:	89 f1                	mov    %esi,%ecx
  8044f1:	d3 ef                	shr    %cl,%edi
  8044f3:	09 c7                	or     %eax,%edi
  8044f5:	89 e9                	mov    %ebp,%ecx
  8044f7:	d3 e2                	shl    %cl,%edx
  8044f9:	89 14 24             	mov    %edx,(%esp)
  8044fc:	89 d8                	mov    %ebx,%eax
  8044fe:	d3 e0                	shl    %cl,%eax
  804500:	89 c2                	mov    %eax,%edx
  804502:	8b 44 24 08          	mov    0x8(%esp),%eax
  804506:	d3 e0                	shl    %cl,%eax
  804508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80450c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804510:	89 f1                	mov    %esi,%ecx
  804512:	d3 e8                	shr    %cl,%eax
  804514:	09 d0                	or     %edx,%eax
  804516:	d3 eb                	shr    %cl,%ebx
  804518:	89 da                	mov    %ebx,%edx
  80451a:	f7 f7                	div    %edi
  80451c:	89 d3                	mov    %edx,%ebx
  80451e:	f7 24 24             	mull   (%esp)
  804521:	89 c6                	mov    %eax,%esi
  804523:	89 d1                	mov    %edx,%ecx
  804525:	39 d3                	cmp    %edx,%ebx
  804527:	0f 82 87 00 00 00    	jb     8045b4 <__umoddi3+0x134>
  80452d:	0f 84 91 00 00 00    	je     8045c4 <__umoddi3+0x144>
  804533:	8b 54 24 04          	mov    0x4(%esp),%edx
  804537:	29 f2                	sub    %esi,%edx
  804539:	19 cb                	sbb    %ecx,%ebx
  80453b:	89 d8                	mov    %ebx,%eax
  80453d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804541:	d3 e0                	shl    %cl,%eax
  804543:	89 e9                	mov    %ebp,%ecx
  804545:	d3 ea                	shr    %cl,%edx
  804547:	09 d0                	or     %edx,%eax
  804549:	89 e9                	mov    %ebp,%ecx
  80454b:	d3 eb                	shr    %cl,%ebx
  80454d:	89 da                	mov    %ebx,%edx
  80454f:	83 c4 1c             	add    $0x1c,%esp
  804552:	5b                   	pop    %ebx
  804553:	5e                   	pop    %esi
  804554:	5f                   	pop    %edi
  804555:	5d                   	pop    %ebp
  804556:	c3                   	ret    
  804557:	90                   	nop
  804558:	89 fd                	mov    %edi,%ebp
  80455a:	85 ff                	test   %edi,%edi
  80455c:	75 0b                	jne    804569 <__umoddi3+0xe9>
  80455e:	b8 01 00 00 00       	mov    $0x1,%eax
  804563:	31 d2                	xor    %edx,%edx
  804565:	f7 f7                	div    %edi
  804567:	89 c5                	mov    %eax,%ebp
  804569:	89 f0                	mov    %esi,%eax
  80456b:	31 d2                	xor    %edx,%edx
  80456d:	f7 f5                	div    %ebp
  80456f:	89 c8                	mov    %ecx,%eax
  804571:	f7 f5                	div    %ebp
  804573:	89 d0                	mov    %edx,%eax
  804575:	e9 44 ff ff ff       	jmp    8044be <__umoddi3+0x3e>
  80457a:	66 90                	xchg   %ax,%ax
  80457c:	89 c8                	mov    %ecx,%eax
  80457e:	89 f2                	mov    %esi,%edx
  804580:	83 c4 1c             	add    $0x1c,%esp
  804583:	5b                   	pop    %ebx
  804584:	5e                   	pop    %esi
  804585:	5f                   	pop    %edi
  804586:	5d                   	pop    %ebp
  804587:	c3                   	ret    
  804588:	3b 04 24             	cmp    (%esp),%eax
  80458b:	72 06                	jb     804593 <__umoddi3+0x113>
  80458d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804591:	77 0f                	ja     8045a2 <__umoddi3+0x122>
  804593:	89 f2                	mov    %esi,%edx
  804595:	29 f9                	sub    %edi,%ecx
  804597:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80459b:	89 14 24             	mov    %edx,(%esp)
  80459e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045a6:	8b 14 24             	mov    (%esp),%edx
  8045a9:	83 c4 1c             	add    $0x1c,%esp
  8045ac:	5b                   	pop    %ebx
  8045ad:	5e                   	pop    %esi
  8045ae:	5f                   	pop    %edi
  8045af:	5d                   	pop    %ebp
  8045b0:	c3                   	ret    
  8045b1:	8d 76 00             	lea    0x0(%esi),%esi
  8045b4:	2b 04 24             	sub    (%esp),%eax
  8045b7:	19 fa                	sbb    %edi,%edx
  8045b9:	89 d1                	mov    %edx,%ecx
  8045bb:	89 c6                	mov    %eax,%esi
  8045bd:	e9 71 ff ff ff       	jmp    804533 <__umoddi3+0xb3>
  8045c2:	66 90                	xchg   %ax,%ax
  8045c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045c8:	72 ea                	jb     8045b4 <__umoddi3+0x134>
  8045ca:	89 d9                	mov    %ebx,%ecx
  8045cc:	e9 62 ff ff ff       	jmp    804533 <__umoddi3+0xb3>
