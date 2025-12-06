
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 cf 07 00 00       	call   800805 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_lock_cons();
  80004c:	e8 f4 35 00 00       	call   803645 <sys_lock_cons>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 80 48 80 00       	push   $0x804880
  800060:	e8 f7 12 00 00       	call   80135c <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 f8 18 00 00       	call   801973 <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 bd 1d 00 00       	call   801e4d <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 60 80 00       	mov    0x806024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 3f 36 00 00       	call   8036f5 <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 51 36 00 00       	call   80370e <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 a0 48 80 00       	push   $0x8048a0
  8000e7:	e8 97 0b 00 00       	call   800c83 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 c3 48 80 00       	push   $0x8048c3
  8000f7:	e8 87 0b 00 00       	call   800c83 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 d1 48 80 00       	push   $0x8048d1
  800107:	e8 77 0b 00 00       	call   800c83 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 e0 48 80 00       	push   $0x8048e0
  800117:	e8 67 0b 00 00       	call   800c83 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 f0 48 80 00       	push   $0x8048f0
  800127:	e8 57 0b 00 00       	call   800c83 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 b4 06 00 00       	call   8007e8 <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 85 06 00 00       	call   8007c9 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 78 06 00 00       	call   8007c9 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_unlock_cons();
  800166:	e8 f4 34 00 00       	call   80365f <sys_unlock_cons>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 05 05 00 00       	call   800691 <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 23 05 00 00       	call   8006c2 <InitializeIdentical>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 45 05 00 00       	call   8006f7 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 32 05 00 00       	call   8006f7 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 00 03 00 00       	call   8004d6 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 00 04 00 00       	call   8005e7 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 fc 48 80 00       	push   $0x8048fc
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 1e 49 80 00       	push   $0x80491e
  800202:	e8 ae 07 00 00       	call   8009b5 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 3c 49 80 00       	push   $0x80493c
  80020f:	e8 6f 0a 00 00       	call   800c83 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 70 49 80 00       	push   $0x804970
  80021f:	e8 5f 0a 00 00       	call   800c83 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 a4 49 80 00       	push   $0x8049a4
  80022f:	e8 4f 0a 00 00       	call   800c83 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 d6 49 80 00       	push   $0x8049d6
  80023f:	e8 3f 0a 00 00       	call   800c83 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 5b 1f 00 00       	call   8021ad <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 ec 49 80 00       	push   $0x8049ec
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 1e 49 80 00       	push   $0x80491e
  800282:	e8 2e 07 00 00       	call   8009b5 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 60 80 00       	mov    0x806024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 55 34 00 00       	call   8036f5 <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 67 34 00 00       	call   80370e <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 3c 4a 80 00       	push   $0x804a3c
  8002c5:	68 61 4a 80 00       	push   $0x804a61
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 1e 49 80 00       	push   $0x80491e
  8002d1:	e8 df 06 00 00       	call   8009b5 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 ec 49 80 00       	push   $0x8049ec
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 1e 49 80 00       	push   $0x80491e
  8002fa:	e8 b6 06 00 00       	call   8009b5 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 60 80 00       	mov    0x806024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 dd 33 00 00       	call   8036f5 <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 ef 33 00 00       	call   80370e <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 3c 4a 80 00       	push   $0x804a3c
  80033d:	68 61 4a 80 00       	push   $0x804a61
  800342:	6a 77                	push   $0x77
  800344:	68 1e 49 80 00       	push   $0x80491e
  800349:	e8 67 06 00 00       	call   8009b5 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 ec 49 80 00       	push   $0x8049ec
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 1e 49 80 00       	push   $0x80491e
  800372:	e8 3e 06 00 00       	call   8009b5 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 60 80 00       	mov    0x806024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 65 33 00 00       	call   8036f5 <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 77 33 00 00       	call   80370e <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 3c 4a 80 00       	push   $0x804a3c
  8003b1:	68 61 4a 80 00       	push   $0x804a61
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 1e 49 80 00       	push   $0x80491e
  8003c0:	e8 f0 05 00 00       	call   8009b5 <_panic>
		}
		///========================================================================
	sys_lock_cons();
  8003c5:	e8 7b 32 00 00       	call   803645 <sys_lock_cons>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 76 4a 80 00       	push   $0x804a76
  8003d8:	e8 a6 08 00 00       	call   800c83 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 03 04 00 00       	call   8007e8 <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d4 03 00 00       	call   8007c9 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c7 03 00 00       	call   8007c9 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 ba 03 00 00       	call   8007c9 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_unlock_cons();
  80041e:	e8 3c 32 00 00       	call   80365f <sys_unlock_cons>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 94 4a 80 00       	push   $0x804a94
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 1e 49 80 00       	push   $0x80491e
  8004b5:	e8 fb 04 00 00       	call   8009b5 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c9:	39 c2                	cmp    %eax,%edx
  8004cb:	0f 87 78 ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004d1:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004df:	48                   	dec    %eax
  8004e0:	50                   	push   %eax
  8004e1:	6a 00                	push   $0x0
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	ff 75 08             	pushl  0x8(%ebp)
  8004e9:	e8 06 00 00 00       	call   8004f4 <QSort>
  8004ee:	83 c4 10             	add    $0x10,%esp
}
  8004f1:	90                   	nop
  8004f2:	c9                   	leave  
  8004f3:	c3                   	ret    

008004f4 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800500:	0f 8d de 00 00 00    	jge    8005e4 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800506:	8b 45 10             	mov    0x10(%ebp),%eax
  800509:	40                   	inc    %eax
  80050a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800513:	e9 80 00 00 00       	jmp    800598 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800518:	ff 45 f4             	incl   -0xc(%ebp)
  80051b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800521:	7f 2b                	jg     80054e <QSort+0x5a>
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	8b 10                	mov    (%eax),%edx
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	39 c2                	cmp    %eax,%edx
  800547:	7d cf                	jge    800518 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800549:	eb 03                	jmp    80054e <QSort+0x5a>
  80054b:	ff 4d f0             	decl   -0x10(%ebp)
  80054e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800551:	3b 45 10             	cmp    0x10(%ebp),%eax
  800554:	7e 26                	jle    80057c <QSort+0x88>
  800556:	8b 45 10             	mov    0x10(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 d0                	add    %edx,%eax
  800565:	8b 10                	mov    (%eax),%edx
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	01 c8                	add    %ecx,%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	39 c2                	cmp    %eax,%edx
  80057a:	7e cf                	jle    80054b <QSort+0x57>

		if (i <= j)
  80057c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800582:	7f 14                	jg     800598 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800584:	83 ec 04             	sub    $0x4,%esp
  800587:	ff 75 f0             	pushl  -0x10(%ebp)
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	ff 75 08             	pushl  0x8(%ebp)
  800590:	e8 a9 00 00 00       	call   80063e <Swap>
  800595:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80059b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059e:	0f 8e 77 ff ff ff    	jle    80051b <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8005aa:	ff 75 10             	pushl  0x10(%ebp)
  8005ad:	ff 75 08             	pushl  0x8(%ebp)
  8005b0:	e8 89 00 00 00       	call   80063e <Swap>
  8005b5:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bb:	48                   	dec    %eax
  8005bc:	50                   	push   %eax
  8005bd:	ff 75 10             	pushl  0x10(%ebp)
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 29 ff ff ff       	call   8004f4 <QSort>
  8005cb:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005ce:	ff 75 14             	pushl  0x14(%ebp)
  8005d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	e8 15 ff ff ff       	call   8004f4 <QSort>
  8005df:	83 c4 10             	add    $0x10,%esp
  8005e2:	eb 01                	jmp    8005e5 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e4:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005fb:	eb 33                	jmp    800630 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 10                	mov    (%eax),%edx
  80060e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800611:	40                   	inc    %eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7e 09                	jle    80062d <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80062b:	eb 0c                	jmp    800639 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062d:	ff 45 f8             	incl   -0x8(%ebp)
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	48                   	dec    %eax
  800634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800637:	7f c4                	jg     8005fd <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800639:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	01 d0                	add    %edx,%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	01 c2                	add    %eax,%edx
  800667:	8b 45 10             	mov    0x10(%ebp),%eax
  80066a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	01 c8                	add    %ecx,%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	01 c2                	add    %eax,%edx
  800689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80068c:	89 02                	mov    %eax,(%edx)
}
  80068e:	90                   	nop
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800697:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069e:	eb 17                	jmp    8006b7 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	01 c2                	add    %eax,%edx
  8006af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b2:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b4:	ff 45 fc             	incl   -0x4(%ebp)
  8006b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006bd:	7c e1                	jl     8006a0 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bf:	90                   	nop
  8006c0:	c9                   	leave  
  8006c1:	c3                   	ret    

008006c2 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cf:	eb 1b                	jmp    8006ec <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	01 c2                	add    %eax,%edx
  8006e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e3:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e6:	48                   	dec    %eax
  8006e7:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e9:	ff 45 fc             	incl   -0x4(%ebp)
  8006ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006f2:	7c dd                	jl     8006d1 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f4:	90                   	nop
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    

008006f7 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f7:	55                   	push   %ebp
  8006f8:	89 e5                	mov    %esp,%ebp
  8006fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800700:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800705:	f7 e9                	imul   %ecx
  800707:	c1 f9 1f             	sar    $0x1f,%ecx
  80070a:	89 d0                	mov    %edx,%eax
  80070c:	29 c8                	sub    %ecx,%eax
  80070e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800711:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800718:	eb 1e                	jmp    800738 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80071a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80072a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072d:	99                   	cltd   
  80072e:	f7 7d f8             	idivl  -0x8(%ebp)
  800731:	89 d0                	mov    %edx,%eax
  800733:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800735:	ff 45 fc             	incl   -0x4(%ebp)
  800738:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80073b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073e:	7c da                	jl     80071a <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800749:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800750:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800757:	eb 42                	jmp    80079b <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075c:	99                   	cltd   
  80075d:	f7 7d f0             	idivl  -0x10(%ebp)
  800760:	89 d0                	mov    %edx,%eax
  800762:	85 c0                	test   %eax,%eax
  800764:	75 10                	jne    800776 <PrintElements+0x33>
			cprintf("\n");
  800766:	83 ec 0c             	sub    $0xc,%esp
  800769:	68 c2 4a 80 00       	push   $0x804ac2
  80076e:	e8 10 05 00 00       	call   800c83 <cprintf>
  800773:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800779:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	50                   	push   %eax
  80078b:	68 c4 4a 80 00       	push   $0x804ac4
  800790:	e8 ee 04 00 00       	call   800c83 <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800798:	ff 45 f4             	incl   -0xc(%ebp)
  80079b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079e:	48                   	dec    %eax
  80079f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8007a2:	7f b5                	jg     800759 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	50                   	push   %eax
  8007b9:	68 c9 4a 80 00       	push   $0x804ac9
  8007be:	e8 c0 04 00 00       	call   800c83 <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp

}
  8007c6:	90                   	nop
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d9:	83 ec 0c             	sub    $0xc,%esp
  8007dc:	50                   	push   %eax
  8007dd:	e8 ab 2f 00 00       	call   80378d <sys_cputc>
  8007e2:	83 c4 10             	add    $0x10,%esp
}
  8007e5:	90                   	nop
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <getchar>:


int
getchar(void)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8007ee:	e8 39 2e 00 00       	call   80362c <sys_cgetc>
  8007f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    

008007fb <iscons>:

int iscons(int fdnum)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	57                   	push   %edi
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80080e:	e8 ab 30 00 00       	call   8038be <sys_getenvindex>
  800813:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800816:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800819:	89 d0                	mov    %edx,%eax
  80081b:	c1 e0 03             	shl    $0x3,%eax
  80081e:	01 d0                	add    %edx,%eax
  800820:	c1 e0 02             	shl    $0x2,%eax
  800823:	01 d0                	add    %edx,%eax
  800825:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80082c:	01 d0                	add    %edx,%eax
  80082e:	c1 e0 03             	shl    $0x3,%eax
  800831:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800836:	a3 24 60 80 00       	mov    %eax,0x806024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80083b:	a1 24 60 80 00       	mov    0x806024,%eax
  800840:	8a 40 20             	mov    0x20(%eax),%al
  800843:	84 c0                	test   %al,%al
  800845:	74 0d                	je     800854 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800847:	a1 24 60 80 00       	mov    0x806024,%eax
  80084c:	83 c0 20             	add    $0x20,%eax
  80084f:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800854:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800858:	7e 0a                	jle    800864 <libmain+0x5f>
		binaryname = argv[0];
  80085a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 c6 f7 ff ff       	call   800038 <_main>
  800872:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800875:	a1 00 60 80 00       	mov    0x806000,%eax
  80087a:	85 c0                	test   %eax,%eax
  80087c:	0f 84 01 01 00 00    	je     800983 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800882:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800888:	bb c8 4b 80 00       	mov    $0x804bc8,%ebx
  80088d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800892:	89 c7                	mov    %eax,%edi
  800894:	89 de                	mov    %ebx,%esi
  800896:	89 d1                	mov    %edx,%ecx
  800898:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80089a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80089d:	b9 56 00 00 00       	mov    $0x56,%ecx
  8008a2:	b0 00                	mov    $0x0,%al
  8008a4:	89 d7                	mov    %edx,%edi
  8008a6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8008a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8008af:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	50                   	push   %eax
  8008b6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8008bc:	50                   	push   %eax
  8008bd:	e8 32 32 00 00       	call   803af4 <sys_utilities>
  8008c2:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8008c5:	e8 7b 2d 00 00       	call   803645 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8008ca:	83 ec 0c             	sub    $0xc,%esp
  8008cd:	68 e8 4a 80 00       	push   $0x804ae8
  8008d2:	e8 ac 03 00 00       	call   800c83 <cprintf>
  8008d7:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8008da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	74 18                	je     8008f9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8008e1:	e8 2c 32 00 00       	call   803b12 <sys_get_optimal_num_faults>
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	50                   	push   %eax
  8008ea:	68 10 4b 80 00       	push   $0x804b10
  8008ef:	e8 8f 03 00 00       	call   800c83 <cprintf>
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	eb 59                	jmp    800952 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008f9:	a1 24 60 80 00       	mov    0x806024,%eax
  8008fe:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800904:	a1 24 60 80 00       	mov    0x806024,%eax
  800909:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80090f:	83 ec 04             	sub    $0x4,%esp
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	68 34 4b 80 00       	push   $0x804b34
  800919:	e8 65 03 00 00       	call   800c83 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800921:	a1 24 60 80 00       	mov    0x806024,%eax
  800926:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80092c:	a1 24 60 80 00       	mov    0x806024,%eax
  800931:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800937:	a1 24 60 80 00       	mov    0x806024,%eax
  80093c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	50                   	push   %eax
  800945:	68 5c 4b 80 00       	push   $0x804b5c
  80094a:	e8 34 03 00 00       	call   800c83 <cprintf>
  80094f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800952:	a1 24 60 80 00       	mov    0x806024,%eax
  800957:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	50                   	push   %eax
  800961:	68 b4 4b 80 00       	push   $0x804bb4
  800966:	e8 18 03 00 00       	call   800c83 <cprintf>
  80096b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80096e:	83 ec 0c             	sub    $0xc,%esp
  800971:	68 e8 4a 80 00       	push   $0x804ae8
  800976:	e8 08 03 00 00       	call   800c83 <cprintf>
  80097b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80097e:	e8 dc 2c 00 00       	call   80365f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800983:	e8 1f 00 00 00       	call   8009a7 <exit>
}
  800988:	90                   	nop
  800989:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5f                   	pop    %edi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800997:	83 ec 0c             	sub    $0xc,%esp
  80099a:	6a 00                	push   $0x0
  80099c:	e8 e9 2e 00 00       	call   80388a <sys_destroy_env>
  8009a1:	83 c4 10             	add    $0x10,%esp
}
  8009a4:	90                   	nop
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <exit>:

void
exit(void)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8009ad:	e8 3e 2f 00 00       	call   8038f0 <sys_exit_env>
}
  8009b2:	90                   	nop
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    

008009b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8009be:	83 c0 04             	add    $0x4,%eax
  8009c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009c4:	a1 38 61 83 00       	mov    0x836138,%eax
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	74 16                	je     8009e3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009cd:	a1 38 61 83 00       	mov    0x836138,%eax
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	50                   	push   %eax
  8009d6:	68 2c 4c 80 00       	push   $0x804c2c
  8009db:	e8 a3 02 00 00       	call   800c83 <cprintf>
  8009e0:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8009e3:	a1 04 60 80 00       	mov    0x806004,%eax
  8009e8:	83 ec 0c             	sub    $0xc,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	ff 75 08             	pushl  0x8(%ebp)
  8009f1:	50                   	push   %eax
  8009f2:	68 34 4c 80 00       	push   $0x804c34
  8009f7:	6a 74                	push   $0x74
  8009f9:	e8 b2 02 00 00       	call   800cb0 <cprintf_colored>
  8009fe:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800a01:	8b 45 10             	mov    0x10(%ebp),%eax
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0a:	50                   	push   %eax
  800a0b:	e8 04 02 00 00       	call   800c14 <vcprintf>
  800a10:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	6a 00                	push   $0x0
  800a18:	68 5c 4c 80 00       	push   $0x804c5c
  800a1d:	e8 f2 01 00 00       	call   800c14 <vcprintf>
  800a22:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a25:	e8 7d ff ff ff       	call   8009a7 <exit>

	// should not return here
	while (1) ;
  800a2a:	eb fe                	jmp    800a2a <_panic+0x75>

00800a2c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a32:	a1 24 60 80 00       	mov    0x806024,%eax
  800a37:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	74 14                	je     800a58 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a44:	83 ec 04             	sub    $0x4,%esp
  800a47:	68 60 4c 80 00       	push   $0x804c60
  800a4c:	6a 26                	push   $0x26
  800a4e:	68 ac 4c 80 00       	push   $0x804cac
  800a53:	e8 5d ff ff ff       	call   8009b5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a66:	e9 c5 00 00 00       	jmp    800b30 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	01 d0                	add    %edx,%eax
  800a7a:	8b 00                	mov    (%eax),%eax
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	75 08                	jne    800a88 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a80:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a83:	e9 a5 00 00 00       	jmp    800b2d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a88:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a96:	eb 69                	jmp    800b01 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a98:	a1 24 60 80 00       	mov    0x806024,%eax
  800a9d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800aa3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	84 c0                	test   %al,%al
  800ab6:	75 46                	jne    800afe <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ab8:	a1 24 60 80 00       	mov    0x806024,%eax
  800abd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800ac3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ac6:	89 d0                	mov    %edx,%eax
  800ac8:	01 c0                	add    %eax,%eax
  800aca:	01 d0                	add    %edx,%eax
  800acc:	c1 e0 03             	shl    $0x3,%eax
  800acf:	01 c8                	add    %ecx,%eax
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ad6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ad9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ade:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	01 c8                	add    %ecx,%eax
  800aef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	75 09                	jne    800afe <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800af5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800afc:	eb 15                	jmp    800b13 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800afe:	ff 45 e8             	incl   -0x18(%ebp)
  800b01:	a1 24 60 80 00       	mov    0x806024,%eax
  800b06:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	77 85                	ja     800a98 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b17:	75 14                	jne    800b2d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800b19:	83 ec 04             	sub    $0x4,%esp
  800b1c:	68 b8 4c 80 00       	push   $0x804cb8
  800b21:	6a 3a                	push   $0x3a
  800b23:	68 ac 4c 80 00       	push   $0x804cac
  800b28:	e8 88 fe ff ff       	call   8009b5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b2d:	ff 45 f0             	incl   -0x10(%ebp)
  800b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b33:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b36:	0f 8c 2f ff ff ff    	jl     800a6b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b3c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b4a:	eb 26                	jmp    800b72 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b4c:	a1 24 60 80 00       	mov    0x806024,%eax
  800b51:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800b57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b5a:	89 d0                	mov    %edx,%eax
  800b5c:	01 c0                	add    %eax,%eax
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	c1 e0 03             	shl    $0x3,%eax
  800b63:	01 c8                	add    %ecx,%eax
  800b65:	8a 40 04             	mov    0x4(%eax),%al
  800b68:	3c 01                	cmp    $0x1,%al
  800b6a:	75 03                	jne    800b6f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800b6c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b6f:	ff 45 e0             	incl   -0x20(%ebp)
  800b72:	a1 24 60 80 00       	mov    0x806024,%eax
  800b77:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	77 c8                	ja     800b4c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b87:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b8a:	74 14                	je     800ba0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b8c:	83 ec 04             	sub    $0x4,%esp
  800b8f:	68 0c 4d 80 00       	push   $0x804d0c
  800b94:	6a 44                	push   $0x44
  800b96:	68 ac 4c 80 00       	push   $0x804cac
  800b9b:	e8 15 fe ff ff       	call   8009b5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ba0:	90                   	nop
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	53                   	push   %ebx
  800ba7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 00                	mov    (%eax),%eax
  800baf:	8d 48 01             	lea    0x1(%eax),%ecx
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb5:	89 0a                	mov    %ecx,(%edx)
  800bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bba:	88 d1                	mov    %dl,%cl
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	8b 00                	mov    (%eax),%eax
  800bc8:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bcd:	75 30                	jne    800bff <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800bcf:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800bd5:	a0 64 e0 81 00       	mov    0x81e064,%al
  800bda:	0f b6 c0             	movzbl %al,%eax
  800bdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be0:	8b 09                	mov    (%ecx),%ecx
  800be2:	89 cb                	mov    %ecx,%ebx
  800be4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be7:	83 c1 08             	add    $0x8,%ecx
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	53                   	push   %ebx
  800bed:	51                   	push   %ecx
  800bee:	e8 0e 2a 00 00       	call   803601 <sys_cputs>
  800bf3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c0e:	90                   	nop
  800c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c1d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c24:	00 00 00 
	b.cnt = 0;
  800c27:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c2e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	ff 75 08             	pushl  0x8(%ebp)
  800c37:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3d:	50                   	push   %eax
  800c3e:	68 a3 0b 80 00       	push   $0x800ba3
  800c43:	e8 5a 02 00 00       	call   800ea2 <vprintfmt>
  800c48:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c4b:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800c51:	a0 64 e0 81 00       	mov    0x81e064,%al
  800c56:	0f b6 c0             	movzbl %al,%eax
  800c59:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c5f:	52                   	push   %edx
  800c60:	50                   	push   %eax
  800c61:	51                   	push   %ecx
  800c62:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c68:	83 c0 08             	add    $0x8,%eax
  800c6b:	50                   	push   %eax
  800c6c:	e8 90 29 00 00       	call   803601 <sys_cputs>
  800c71:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c74:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800c7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c89:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800c90:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9f:	50                   	push   %eax
  800ca0:	e8 6f ff ff ff       	call   800c14 <vcprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cb6:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	c1 e0 08             	shl    $0x8,%eax
  800cc3:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800cc8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ccb:	83 c0 04             	add    $0x4,%eax
  800cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cda:	50                   	push   %eax
  800cdb:	e8 34 ff ff ff       	call   800c14 <vcprintf>
  800ce0:	83 c4 10             	add    $0x10,%esp
  800ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800ce6:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800ced:	07 00 00 

	return cnt;
  800cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800cfb:	e8 45 29 00 00       	call   803645 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d00:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0f:	50                   	push   %eax
  800d10:	e8 ff fe ff ff       	call   800c14 <vcprintf>
  800d15:	83 c4 10             	add    $0x10,%esp
  800d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d1b:	e8 3f 29 00 00       	call   80365f <sys_unlock_cons>
	return cnt;
  800d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	53                   	push   %ebx
  800d29:	83 ec 14             	sub    $0x14,%esp
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d32:	8b 45 14             	mov    0x14(%ebp),%eax
  800d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d38:	8b 45 18             	mov    0x18(%ebp),%eax
  800d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d40:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d43:	77 55                	ja     800d9a <printnum+0x75>
  800d45:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d48:	72 05                	jb     800d4f <printnum+0x2a>
  800d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d4d:	77 4b                	ja     800d9a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d4f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d52:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d55:	8b 45 18             	mov    0x18(%ebp),%eax
  800d58:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5d:	52                   	push   %edx
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d62:	ff 75 f0             	pushl  -0x10(%ebp)
  800d65:	e8 ae 38 00 00       	call   804618 <__udivdi3>
  800d6a:	83 c4 10             	add    $0x10,%esp
  800d6d:	83 ec 04             	sub    $0x4,%esp
  800d70:	ff 75 20             	pushl  0x20(%ebp)
  800d73:	53                   	push   %ebx
  800d74:	ff 75 18             	pushl  0x18(%ebp)
  800d77:	52                   	push   %edx
  800d78:	50                   	push   %eax
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	ff 75 08             	pushl  0x8(%ebp)
  800d7f:	e8 a1 ff ff ff       	call   800d25 <printnum>
  800d84:	83 c4 20             	add    $0x20,%esp
  800d87:	eb 1a                	jmp    800da3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d89:	83 ec 08             	sub    $0x8,%esp
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 20             	pushl  0x20(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	ff d0                	call   *%eax
  800d97:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d9a:	ff 4d 1c             	decl   0x1c(%ebp)
  800d9d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800da1:	7f e6                	jg     800d89 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800da3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db1:	53                   	push   %ebx
  800db2:	51                   	push   %ecx
  800db3:	52                   	push   %edx
  800db4:	50                   	push   %eax
  800db5:	e8 6e 39 00 00       	call   804728 <__umoddi3>
  800dba:	83 c4 10             	add    $0x10,%esp
  800dbd:	05 74 4f 80 00       	add    $0x804f74,%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f be c0             	movsbl %al,%eax
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	ff 75 0c             	pushl  0xc(%ebp)
  800dcd:	50                   	push   %eax
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	ff d0                	call   *%eax
  800dd3:	83 c4 10             	add    $0x10,%esp
}
  800dd6:	90                   	nop
  800dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ddf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800de3:	7e 1c                	jle    800e01 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8b 00                	mov    (%eax),%eax
  800dea:	8d 50 08             	lea    0x8(%eax),%edx
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	89 10                	mov    %edx,(%eax)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8b 00                	mov    (%eax),%eax
  800df7:	83 e8 08             	sub    $0x8,%eax
  800dfa:	8b 50 04             	mov    0x4(%eax),%edx
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	eb 40                	jmp    800e41 <getuint+0x65>
	else if (lflag)
  800e01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e05:	74 1e                	je     800e25 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	8d 50 04             	lea    0x4(%eax),%edx
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	89 10                	mov    %edx,(%eax)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8b 00                	mov    (%eax),%eax
  800e19:	83 e8 04             	sub    $0x4,%eax
  800e1c:	8b 00                	mov    (%eax),%eax
  800e1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e23:	eb 1c                	jmp    800e41 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8b 00                	mov    (%eax),%eax
  800e2a:	8d 50 04             	lea    0x4(%eax),%edx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	89 10                	mov    %edx,(%eax)
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8b 00                	mov    (%eax),%eax
  800e37:	83 e8 04             	sub    $0x4,%eax
  800e3a:	8b 00                	mov    (%eax),%eax
  800e3c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e46:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e4a:	7e 1c                	jle    800e68 <getint+0x25>
		return va_arg(*ap, long long);
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	8b 00                	mov    (%eax),%eax
  800e51:	8d 50 08             	lea    0x8(%eax),%edx
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	89 10                	mov    %edx,(%eax)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8b 00                	mov    (%eax),%eax
  800e5e:	83 e8 08             	sub    $0x8,%eax
  800e61:	8b 50 04             	mov    0x4(%eax),%edx
  800e64:	8b 00                	mov    (%eax),%eax
  800e66:	eb 38                	jmp    800ea0 <getint+0x5d>
	else if (lflag)
  800e68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6c:	74 1a                	je     800e88 <getint+0x45>
		return va_arg(*ap, long);
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8b 00                	mov    (%eax),%eax
  800e73:	8d 50 04             	lea    0x4(%eax),%edx
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	89 10                	mov    %edx,(%eax)
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8b 00                	mov    (%eax),%eax
  800e80:	83 e8 04             	sub    $0x4,%eax
  800e83:	8b 00                	mov    (%eax),%eax
  800e85:	99                   	cltd   
  800e86:	eb 18                	jmp    800ea0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8b 00                	mov    (%eax),%eax
  800e8d:	8d 50 04             	lea    0x4(%eax),%edx
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	89 10                	mov    %edx,(%eax)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8b 00                	mov    (%eax),%eax
  800e9a:	83 e8 04             	sub    $0x4,%eax
  800e9d:	8b 00                	mov    (%eax),%eax
  800e9f:	99                   	cltd   
}
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eaa:	eb 17                	jmp    800ec3 <vprintfmt+0x21>
			if (ch == '\0')
  800eac:	85 db                	test   %ebx,%ebx
  800eae:	0f 84 c1 03 00 00    	je     801275 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	53                   	push   %ebx
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	ff d0                	call   *%eax
  800ec0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	0f b6 d8             	movzbl %al,%ebx
  800ed1:	83 fb 25             	cmp    $0x25,%ebx
  800ed4:	75 d6                	jne    800eac <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ed6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eda:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ee1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ee8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800eef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef9:	8d 50 01             	lea    0x1(%eax),%edx
  800efc:	89 55 10             	mov    %edx,0x10(%ebp)
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d8             	movzbl %al,%ebx
  800f04:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f07:	83 f8 5b             	cmp    $0x5b,%eax
  800f0a:	0f 87 3d 03 00 00    	ja     80124d <vprintfmt+0x3ab>
  800f10:	8b 04 85 98 4f 80 00 	mov    0x804f98(,%eax,4),%eax
  800f17:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f19:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f1d:	eb d7                	jmp    800ef6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f1f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f23:	eb d1                	jmp    800ef6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f2f:	89 d0                	mov    %edx,%eax
  800f31:	c1 e0 02             	shl    $0x2,%eax
  800f34:	01 d0                	add    %edx,%eax
  800f36:	01 c0                	add    %eax,%eax
  800f38:	01 d8                	add    %ebx,%eax
  800f3a:	83 e8 30             	sub    $0x30,%eax
  800f3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f40:	8b 45 10             	mov    0x10(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f48:	83 fb 2f             	cmp    $0x2f,%ebx
  800f4b:	7e 3e                	jle    800f8b <vprintfmt+0xe9>
  800f4d:	83 fb 39             	cmp    $0x39,%ebx
  800f50:	7f 39                	jg     800f8b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f52:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f55:	eb d5                	jmp    800f2c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f57:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5a:	83 c0 04             	add    $0x4,%eax
  800f5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f60:	8b 45 14             	mov    0x14(%ebp),%eax
  800f63:	83 e8 04             	sub    $0x4,%eax
  800f66:	8b 00                	mov    (%eax),%eax
  800f68:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f71:	79 83                	jns    800ef6 <vprintfmt+0x54>
				width = 0;
  800f73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f7a:	e9 77 ff ff ff       	jmp    800ef6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f7f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f86:	e9 6b ff ff ff       	jmp    800ef6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f8b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f90:	0f 89 60 ff ff ff    	jns    800ef6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fa3:	e9 4e ff ff ff       	jmp    800ef6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fa8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fab:	e9 46 ff ff ff       	jmp    800ef6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb3:	83 c0 04             	add    $0x4,%eax
  800fb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbc:	83 e8 04             	sub    $0x4,%eax
  800fbf:	8b 00                	mov    (%eax),%eax
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	ff 75 0c             	pushl  0xc(%ebp)
  800fc7:	50                   	push   %eax
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	ff d0                	call   *%eax
  800fcd:	83 c4 10             	add    $0x10,%esp
			break;
  800fd0:	e9 9b 02 00 00       	jmp    801270 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd8:	83 c0 04             	add    $0x4,%eax
  800fdb:	89 45 14             	mov    %eax,0x14(%ebp)
  800fde:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe1:	83 e8 04             	sub    $0x4,%eax
  800fe4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800fe6:	85 db                	test   %ebx,%ebx
  800fe8:	79 02                	jns    800fec <vprintfmt+0x14a>
				err = -err;
  800fea:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fec:	83 fb 64             	cmp    $0x64,%ebx
  800fef:	7f 0b                	jg     800ffc <vprintfmt+0x15a>
  800ff1:	8b 34 9d e0 4d 80 00 	mov    0x804de0(,%ebx,4),%esi
  800ff8:	85 f6                	test   %esi,%esi
  800ffa:	75 19                	jne    801015 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ffc:	53                   	push   %ebx
  800ffd:	68 85 4f 80 00       	push   $0x804f85
  801002:	ff 75 0c             	pushl  0xc(%ebp)
  801005:	ff 75 08             	pushl  0x8(%ebp)
  801008:	e8 70 02 00 00       	call   80127d <printfmt>
  80100d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801010:	e9 5b 02 00 00       	jmp    801270 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801015:	56                   	push   %esi
  801016:	68 8e 4f 80 00       	push   $0x804f8e
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	ff 75 08             	pushl  0x8(%ebp)
  801021:	e8 57 02 00 00       	call   80127d <printfmt>
  801026:	83 c4 10             	add    $0x10,%esp
			break;
  801029:	e9 42 02 00 00       	jmp    801270 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 14             	mov    %eax,0x14(%ebp)
  801037:	8b 45 14             	mov    0x14(%ebp),%eax
  80103a:	83 e8 04             	sub    $0x4,%eax
  80103d:	8b 30                	mov    (%eax),%esi
  80103f:	85 f6                	test   %esi,%esi
  801041:	75 05                	jne    801048 <vprintfmt+0x1a6>
				p = "(null)";
  801043:	be 91 4f 80 00       	mov    $0x804f91,%esi
			if (width > 0 && padc != '-')
  801048:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80104c:	7e 6d                	jle    8010bb <vprintfmt+0x219>
  80104e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801052:	74 67                	je     8010bb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801054:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801057:	83 ec 08             	sub    $0x8,%esp
  80105a:	50                   	push   %eax
  80105b:	56                   	push   %esi
  80105c:	e8 26 05 00 00       	call   801587 <strnlen>
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801067:	eb 16                	jmp    80107f <vprintfmt+0x1dd>
					putch(padc, putdat);
  801069:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80106d:	83 ec 08             	sub    $0x8,%esp
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	50                   	push   %eax
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80107c:	ff 4d e4             	decl   -0x1c(%ebp)
  80107f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801083:	7f e4                	jg     801069 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801085:	eb 34                	jmp    8010bb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801087:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80108b:	74 1c                	je     8010a9 <vprintfmt+0x207>
  80108d:	83 fb 1f             	cmp    $0x1f,%ebx
  801090:	7e 05                	jle    801097 <vprintfmt+0x1f5>
  801092:	83 fb 7e             	cmp    $0x7e,%ebx
  801095:	7e 12                	jle    8010a9 <vprintfmt+0x207>
					putch('?', putdat);
  801097:	83 ec 08             	sub    $0x8,%esp
  80109a:	ff 75 0c             	pushl  0xc(%ebp)
  80109d:	6a 3f                	push   $0x3f
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	ff d0                	call   *%eax
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	eb 0f                	jmp    8010b8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 0c             	pushl  0xc(%ebp)
  8010af:	53                   	push   %ebx
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8010bb:	89 f0                	mov    %esi,%eax
  8010bd:	8d 70 01             	lea    0x1(%eax),%esi
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	0f be d8             	movsbl %al,%ebx
  8010c5:	85 db                	test   %ebx,%ebx
  8010c7:	74 24                	je     8010ed <vprintfmt+0x24b>
  8010c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010cd:	78 b8                	js     801087 <vprintfmt+0x1e5>
  8010cf:	ff 4d e0             	decl   -0x20(%ebp)
  8010d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010d6:	79 af                	jns    801087 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010d8:	eb 13                	jmp    8010ed <vprintfmt+0x24b>
				putch(' ', putdat);
  8010da:	83 ec 08             	sub    $0x8,%esp
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	6a 20                	push   $0x20
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010f1:	7f e7                	jg     8010da <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8010f3:	e9 78 01 00 00       	jmp    801270 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8010fe:	8d 45 14             	lea    0x14(%ebp),%eax
  801101:	50                   	push   %eax
  801102:	e8 3c fd ff ff       	call   800e43 <getint>
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80110d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801116:	85 d2                	test   %edx,%edx
  801118:	79 23                	jns    80113d <vprintfmt+0x29b>
				putch('-', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 2d                	push   $0x2d
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80112a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801130:	f7 d8                	neg    %eax
  801132:	83 d2 00             	adc    $0x0,%edx
  801135:	f7 da                	neg    %edx
  801137:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80113a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80113d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801144:	e9 bc 00 00 00       	jmp    801205 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801149:	83 ec 08             	sub    $0x8,%esp
  80114c:	ff 75 e8             	pushl  -0x18(%ebp)
  80114f:	8d 45 14             	lea    0x14(%ebp),%eax
  801152:	50                   	push   %eax
  801153:	e8 84 fc ff ff       	call   800ddc <getuint>
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801161:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801168:	e9 98 00 00 00       	jmp    801205 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	ff 75 0c             	pushl  0xc(%ebp)
  801173:	6a 58                	push   $0x58
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	ff d0                	call   *%eax
  80117a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80117d:	83 ec 08             	sub    $0x8,%esp
  801180:	ff 75 0c             	pushl  0xc(%ebp)
  801183:	6a 58                	push   $0x58
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	ff d0                	call   *%eax
  80118a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	ff 75 0c             	pushl  0xc(%ebp)
  801193:	6a 58                	push   $0x58
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	ff d0                	call   *%eax
  80119a:	83 c4 10             	add    $0x10,%esp
			break;
  80119d:	e9 ce 00 00 00       	jmp    801270 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	6a 30                	push   $0x30
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	ff d0                	call   *%eax
  8011af:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011b2:	83 ec 08             	sub    $0x8,%esp
  8011b5:	ff 75 0c             	pushl  0xc(%ebp)
  8011b8:	6a 78                	push   $0x78
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	ff d0                	call   *%eax
  8011bf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	83 c0 04             	add    $0x4,%eax
  8011c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8011cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ce:	83 e8 04             	sub    $0x4,%eax
  8011d1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011e4:	eb 1f                	jmp    801205 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8011ef:	50                   	push   %eax
  8011f0:	e8 e7 fb ff ff       	call   800ddc <getuint>
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8011fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801205:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120c:	83 ec 04             	sub    $0x4,%esp
  80120f:	52                   	push   %edx
  801210:	ff 75 e4             	pushl  -0x1c(%ebp)
  801213:	50                   	push   %eax
  801214:	ff 75 f4             	pushl  -0xc(%ebp)
  801217:	ff 75 f0             	pushl  -0x10(%ebp)
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	ff 75 08             	pushl  0x8(%ebp)
  801220:	e8 00 fb ff ff       	call   800d25 <printnum>
  801225:	83 c4 20             	add    $0x20,%esp
			break;
  801228:	eb 46                	jmp    801270 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80122a:	83 ec 08             	sub    $0x8,%esp
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	53                   	push   %ebx
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	ff d0                	call   *%eax
  801236:	83 c4 10             	add    $0x10,%esp
			break;
  801239:	eb 35                	jmp    801270 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80123b:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  801242:	eb 2c                	jmp    801270 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801244:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  80124b:	eb 23                	jmp    801270 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124d:	83 ec 08             	sub    $0x8,%esp
  801250:	ff 75 0c             	pushl  0xc(%ebp)
  801253:	6a 25                	push   $0x25
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	ff d0                	call   *%eax
  80125a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125d:	ff 4d 10             	decl   0x10(%ebp)
  801260:	eb 03                	jmp    801265 <vprintfmt+0x3c3>
  801262:	ff 4d 10             	decl   0x10(%ebp)
  801265:	8b 45 10             	mov    0x10(%ebp),%eax
  801268:	48                   	dec    %eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	3c 25                	cmp    $0x25,%al
  80126d:	75 f3                	jne    801262 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80126f:	90                   	nop
		}
	}
  801270:	e9 35 fc ff ff       	jmp    800eaa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801275:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801276:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801283:	8d 45 10             	lea    0x10(%ebp),%eax
  801286:	83 c0 04             	add    $0x4,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	ff 75 f4             	pushl  -0xc(%ebp)
  801292:	50                   	push   %eax
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	ff 75 08             	pushl  0x8(%ebp)
  801299:	e8 04 fc ff ff       	call   800ea2 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	8b 40 08             	mov    0x8(%eax),%eax
  8012ad:	8d 50 01             	lea    0x1(%eax),%edx
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	8b 10                	mov    (%eax),%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	8b 40 04             	mov    0x4(%eax),%eax
  8012c1:	39 c2                	cmp    %eax,%edx
  8012c3:	73 12                	jae    8012d7 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	8b 00                	mov    (%eax),%eax
  8012ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8012cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d0:	89 0a                	mov    %ecx,(%edx)
  8012d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d5:	88 10                	mov    %dl,(%eax)
}
  8012d7:	90                   	nop
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ff:	74 06                	je     801307 <vsnprintf+0x2d>
  801301:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801305:	7f 07                	jg     80130e <vsnprintf+0x34>
		return -E_INVAL;
  801307:	b8 03 00 00 00       	mov    $0x3,%eax
  80130c:	eb 20                	jmp    80132e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130e:	ff 75 14             	pushl  0x14(%ebp)
  801311:	ff 75 10             	pushl  0x10(%ebp)
  801314:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801317:	50                   	push   %eax
  801318:	68 a4 12 80 00       	push   $0x8012a4
  80131d:	e8 80 fb ff ff       	call   800ea2 <vprintfmt>
  801322:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801336:	8d 45 10             	lea    0x10(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80133f:	8b 45 10             	mov    0x10(%ebp),%eax
  801342:	ff 75 f4             	pushl  -0xc(%ebp)
  801345:	50                   	push   %eax
  801346:	ff 75 0c             	pushl  0xc(%ebp)
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	e8 89 ff ff ff       	call   8012da <vsnprintf>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801357:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801362:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801366:	74 13                	je     80137b <readline+0x1f>
		cprintf("%s", prompt);
  801368:	83 ec 08             	sub    $0x8,%esp
  80136b:	ff 75 08             	pushl  0x8(%ebp)
  80136e:	68 08 51 80 00       	push   $0x805108
  801373:	e8 0b f9 ff ff       	call   800c83 <cprintf>
  801378:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80137b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801382:	83 ec 0c             	sub    $0xc,%esp
  801385:	6a 00                	push   $0x0
  801387:	e8 6f f4 ff ff       	call   8007fb <iscons>
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801392:	e8 51 f4 ff ff       	call   8007e8 <getchar>
  801397:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80139a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80139e:	79 22                	jns    8013c2 <readline+0x66>
			if (c != -E_EOF)
  8013a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013a4:	0f 84 ad 00 00 00    	je     801457 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b0:	68 0b 51 80 00       	push   $0x80510b
  8013b5:	e8 c9 f8 ff ff       	call   800c83 <cprintf>
  8013ba:	83 c4 10             	add    $0x10,%esp
			break;
  8013bd:	e9 95 00 00 00       	jmp    801457 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013c6:	7e 34                	jle    8013fc <readline+0xa0>
  8013c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013cf:	7f 2b                	jg     8013fc <readline+0xa0>
			if (echoing)
  8013d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013d5:	74 0e                	je     8013e5 <readline+0x89>
				cputchar(c);
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	ff 75 ec             	pushl  -0x14(%ebp)
  8013dd:	e8 e7 f3 ff ff       	call   8007c9 <cputchar>
  8013e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e8:	8d 50 01             	lea    0x1(%eax),%edx
  8013eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013ee:	89 c2                	mov    %eax,%edx
  8013f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f3:	01 d0                	add    %edx,%eax
  8013f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013f8:	88 10                	mov    %dl,(%eax)
  8013fa:	eb 56                	jmp    801452 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8013fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801400:	75 1f                	jne    801421 <readline+0xc5>
  801402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801406:	7e 19                	jle    801421 <readline+0xc5>
			if (echoing)
  801408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80140c:	74 0e                	je     80141c <readline+0xc0>
				cputchar(c);
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	ff 75 ec             	pushl  -0x14(%ebp)
  801414:	e8 b0 f3 ff ff       	call   8007c9 <cputchar>
  801419:	83 c4 10             	add    $0x10,%esp

			i--;
  80141c:	ff 4d f4             	decl   -0xc(%ebp)
  80141f:	eb 31                	jmp    801452 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801421:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801425:	74 0a                	je     801431 <readline+0xd5>
  801427:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80142b:	0f 85 61 ff ff ff    	jne    801392 <readline+0x36>
			if (echoing)
  801431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801435:	74 0e                	je     801445 <readline+0xe9>
				cputchar(c);
  801437:	83 ec 0c             	sub    $0xc,%esp
  80143a:	ff 75 ec             	pushl  -0x14(%ebp)
  80143d:	e8 87 f3 ff ff       	call   8007c9 <cputchar>
  801442:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801445:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	01 d0                	add    %edx,%eax
  80144d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801450:	eb 06                	jmp    801458 <readline+0xfc>
		}
	}
  801452:	e9 3b ff ff ff       	jmp    801392 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801457:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801458:	90                   	nop
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801461:	e8 df 21 00 00       	call   803645 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801466:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146a:	74 13                	je     80147f <atomic_readline+0x24>
			cprintf("%s", prompt);
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	ff 75 08             	pushl  0x8(%ebp)
  801472:	68 08 51 80 00       	push   $0x805108
  801477:	e8 07 f8 ff ff       	call   800c83 <cprintf>
  80147c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80147f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801486:	83 ec 0c             	sub    $0xc,%esp
  801489:	6a 00                	push   $0x0
  80148b:	e8 6b f3 ff ff       	call   8007fb <iscons>
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801496:	e8 4d f3 ff ff       	call   8007e8 <getchar>
  80149b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80149e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a2:	79 22                	jns    8014c6 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014a4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014a8:	0f 84 ad 00 00 00    	je     80155b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b4:	68 0b 51 80 00       	push   $0x80510b
  8014b9:	e8 c5 f7 ff ff       	call   800c83 <cprintf>
  8014be:	83 c4 10             	add    $0x10,%esp
				break;
  8014c1:	e9 95 00 00 00       	jmp    80155b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014ca:	7e 34                	jle    801500 <atomic_readline+0xa5>
  8014cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014d3:	7f 2b                	jg     801500 <atomic_readline+0xa5>
				if (echoing)
  8014d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014d9:	74 0e                	je     8014e9 <atomic_readline+0x8e>
					cputchar(c);
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e1:	e8 e3 f2 ff ff       	call   8007c9 <cputchar>
  8014e6:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8014e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ec:	8d 50 01             	lea    0x1(%eax),%edx
  8014ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014fc:	88 10                	mov    %dl,(%eax)
  8014fe:	eb 56                	jmp    801556 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801500:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801504:	75 1f                	jne    801525 <atomic_readline+0xca>
  801506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80150a:	7e 19                	jle    801525 <atomic_readline+0xca>
				if (echoing)
  80150c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801510:	74 0e                	je     801520 <atomic_readline+0xc5>
					cputchar(c);
  801512:	83 ec 0c             	sub    $0xc,%esp
  801515:	ff 75 ec             	pushl  -0x14(%ebp)
  801518:	e8 ac f2 ff ff       	call   8007c9 <cputchar>
  80151d:	83 c4 10             	add    $0x10,%esp
				i--;
  801520:	ff 4d f4             	decl   -0xc(%ebp)
  801523:	eb 31                	jmp    801556 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801525:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801529:	74 0a                	je     801535 <atomic_readline+0xda>
  80152b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80152f:	0f 85 61 ff ff ff    	jne    801496 <atomic_readline+0x3b>
				if (echoing)
  801535:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801539:	74 0e                	je     801549 <atomic_readline+0xee>
					cputchar(c);
  80153b:	83 ec 0c             	sub    $0xc,%esp
  80153e:	ff 75 ec             	pushl  -0x14(%ebp)
  801541:	e8 83 f2 ff ff       	call   8007c9 <cputchar>
  801546:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154f:	01 d0                	add    %edx,%eax
  801551:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801554:	eb 06                	jmp    80155c <atomic_readline+0x101>
			}
		}
  801556:	e9 3b ff ff ff       	jmp    801496 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80155b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80155c:	e8 fe 20 00 00       	call   80365f <sys_unlock_cons>
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80156a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801571:	eb 06                	jmp    801579 <strlen+0x15>
		n++;
  801573:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	84 c0                	test   %al,%al
  801580:	75 f1                	jne    801573 <strlen+0xf>
		n++;
	return n;
  801582:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80158d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801594:	eb 09                	jmp    80159f <strnlen+0x18>
		n++;
  801596:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801599:	ff 45 08             	incl   0x8(%ebp)
  80159c:	ff 4d 0c             	decl   0xc(%ebp)
  80159f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a3:	74 09                	je     8015ae <strnlen+0x27>
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	84 c0                	test   %al,%al
  8015ac:	75 e8                	jne    801596 <strnlen+0xf>
		n++;
	return n;
  8015ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015bf:	90                   	nop
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8d 50 01             	lea    0x1(%eax),%edx
  8015c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015cf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015d2:	8a 12                	mov    (%edx),%dl
  8015d4:	88 10                	mov    %dl,(%eax)
  8015d6:	8a 00                	mov    (%eax),%al
  8015d8:	84 c0                	test   %al,%al
  8015da:	75 e4                	jne    8015c0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8015ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f4:	eb 1f                	jmp    801615 <strncpy+0x34>
		*dst++ = *src;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8d 50 01             	lea    0x1(%eax),%edx
  8015fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	8a 12                	mov    (%edx),%dl
  801604:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	84 c0                	test   %al,%al
  80160d:	74 03                	je     801612 <strncpy+0x31>
			src++;
  80160f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801612:	ff 45 fc             	incl   -0x4(%ebp)
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	3b 45 10             	cmp    0x10(%ebp),%eax
  80161b:	72 d9                	jb     8015f6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80162e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801632:	74 30                	je     801664 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801634:	eb 16                	jmp    80164c <strlcpy+0x2a>
			*dst++ = *src++;
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8d 50 01             	lea    0x1(%eax),%edx
  80163c:	89 55 08             	mov    %edx,0x8(%ebp)
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8d 4a 01             	lea    0x1(%edx),%ecx
  801645:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801648:	8a 12                	mov    (%edx),%dl
  80164a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80164c:	ff 4d 10             	decl   0x10(%ebp)
  80164f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801653:	74 09                	je     80165e <strlcpy+0x3c>
  801655:	8b 45 0c             	mov    0xc(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	84 c0                	test   %al,%al
  80165c:	75 d8                	jne    801636 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801664:	8b 55 08             	mov    0x8(%ebp),%edx
  801667:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801673:	eb 06                	jmp    80167b <strcmp+0xb>
		p++, q++;
  801675:	ff 45 08             	incl   0x8(%ebp)
  801678:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8a 00                	mov    (%eax),%al
  801680:	84 c0                	test   %al,%al
  801682:	74 0e                	je     801692 <strcmp+0x22>
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 10                	mov    (%eax),%dl
  801689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	38 c2                	cmp    %al,%dl
  801690:	74 e3                	je     801675 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	0f b6 d0             	movzbl %al,%edx
  80169a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	0f b6 c0             	movzbl %al,%eax
  8016a2:	29 c2                	sub    %eax,%edx
  8016a4:	89 d0                	mov    %edx,%eax
}
  8016a6:	5d                   	pop    %ebp
  8016a7:	c3                   	ret    

008016a8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016ab:	eb 09                	jmp    8016b6 <strncmp+0xe>
		n--, p++, q++;
  8016ad:	ff 4d 10             	decl   0x10(%ebp)
  8016b0:	ff 45 08             	incl   0x8(%ebp)
  8016b3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ba:	74 17                	je     8016d3 <strncmp+0x2b>
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	84 c0                	test   %al,%al
  8016c3:	74 0e                	je     8016d3 <strncmp+0x2b>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 10                	mov    (%eax),%dl
  8016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	38 c2                	cmp    %al,%dl
  8016d1:	74 da                	je     8016ad <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d7:	75 07                	jne    8016e0 <strncmp+0x38>
		return 0;
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016de:	eb 14                	jmp    8016f4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	0f b6 d0             	movzbl %al,%edx
  8016e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	0f b6 c0             	movzbl %al,%eax
  8016f0:	29 c2                	sub    %eax,%edx
  8016f2:	89 d0                	mov    %edx,%eax
}
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801702:	eb 12                	jmp    801716 <strchr+0x20>
		if (*s == c)
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80170c:	75 05                	jne    801713 <strchr+0x1d>
			return (char *) s;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	eb 11                	jmp    801724 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801713:	ff 45 08             	incl   0x8(%ebp)
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	84 c0                	test   %al,%al
  80171d:	75 e5                	jne    801704 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801732:	eb 0d                	jmp    801741 <strfind+0x1b>
		if (*s == c)
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	8a 00                	mov    (%eax),%al
  801739:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80173c:	74 0e                	je     80174c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80173e:	ff 45 08             	incl   0x8(%ebp)
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	84 c0                	test   %al,%al
  801748:	75 ea                	jne    801734 <strfind+0xe>
  80174a:	eb 01                	jmp    80174d <strfind+0x27>
		if (*s == c)
			break;
  80174c:	90                   	nop
	return (char *) s;
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80175e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801762:	76 63                	jbe    8017c7 <memset+0x75>
		uint64 data_block = c;
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	99                   	cltd   
  801768:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80176b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80176e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801771:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801774:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801778:	c1 e0 08             	shl    $0x8,%eax
  80177b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80177e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801787:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80178b:	c1 e0 10             	shl    $0x10,%eax
  80178e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801791:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179a:	89 c2                	mov    %eax,%edx
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017a4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017a7:	eb 18                	jmp    8017c1 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017ac:	8d 41 08             	lea    0x8(%ecx),%eax
  8017af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b8:	89 01                	mov    %eax,(%ecx)
  8017ba:	89 51 04             	mov    %edx,0x4(%ecx)
  8017bd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017c1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017c5:	77 e2                	ja     8017a9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017cb:	74 23                	je     8017f0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8017cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017d3:	eb 0e                	jmp    8017e3 <memset+0x91>
			*p8++ = (uint8)c;
  8017d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d8:	8d 50 01             	lea    0x1(%eax),%edx
  8017db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8017e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	75 e5                	jne    8017d5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801807:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80180b:	76 24                	jbe    801831 <memcpy+0x3c>
		while(n >= 8){
  80180d:	eb 1c                	jmp    80182b <memcpy+0x36>
			*d64 = *s64;
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8b 50 04             	mov    0x4(%eax),%edx
  801815:	8b 00                	mov    (%eax),%eax
  801817:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80181a:	89 01                	mov    %eax,(%ecx)
  80181c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80181f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801823:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801827:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80182b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80182f:	77 de                	ja     80180f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801831:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801835:	74 31                	je     801868 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801837:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80183d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801840:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801843:	eb 16                	jmp    80185b <memcpy+0x66>
			*d8++ = *s8++;
  801845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801848:	8d 50 01             	lea    0x1(%eax),%edx
  80184b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80184e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801851:	8d 4a 01             	lea    0x1(%edx),%ecx
  801854:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801857:	8a 12                	mov    (%edx),%dl
  801859:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801861:	89 55 10             	mov    %edx,0x10(%ebp)
  801864:	85 c0                	test   %eax,%eax
  801866:	75 dd                	jne    801845 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80187f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801882:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801885:	73 50                	jae    8018d7 <memmove+0x6a>
  801887:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188a:	8b 45 10             	mov    0x10(%ebp),%eax
  80188d:	01 d0                	add    %edx,%eax
  80188f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801892:	76 43                	jbe    8018d7 <memmove+0x6a>
		s += n;
  801894:	8b 45 10             	mov    0x10(%ebp),%eax
  801897:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80189a:	8b 45 10             	mov    0x10(%ebp),%eax
  80189d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018a0:	eb 10                	jmp    8018b2 <memmove+0x45>
			*--d = *--s;
  8018a2:	ff 4d f8             	decl   -0x8(%ebp)
  8018a5:	ff 4d fc             	decl   -0x4(%ebp)
  8018a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ab:	8a 10                	mov    (%eax),%dl
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	75 e3                	jne    8018a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018bf:	eb 23                	jmp    8018e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c4:	8d 50 01             	lea    0x1(%eax),%edx
  8018c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018d3:	8a 12                	mov    (%edx),%dl
  8018d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	75 dd                	jne    8018c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018fb:	eb 2a                	jmp    801927 <memcmp+0x3e>
		if (*s1 != *s2)
  8018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801900:	8a 10                	mov    (%eax),%dl
  801902:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801905:	8a 00                	mov    (%eax),%al
  801907:	38 c2                	cmp    %al,%dl
  801909:	74 16                	je     801921 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80190b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80190e:	8a 00                	mov    (%eax),%al
  801910:	0f b6 d0             	movzbl %al,%edx
  801913:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	0f b6 c0             	movzbl %al,%eax
  80191b:	29 c2                	sub    %eax,%edx
  80191d:	89 d0                	mov    %edx,%eax
  80191f:	eb 18                	jmp    801939 <memcmp+0x50>
		s1++, s2++;
  801921:	ff 45 fc             	incl   -0x4(%ebp)
  801924:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801927:	8b 45 10             	mov    0x10(%ebp),%eax
  80192a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80192d:	89 55 10             	mov    %edx,0x10(%ebp)
  801930:	85 c0                	test   %eax,%eax
  801932:	75 c9                	jne    8018fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801934:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801941:	8b 55 08             	mov    0x8(%ebp),%edx
  801944:	8b 45 10             	mov    0x10(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80194c:	eb 15                	jmp    801963 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8a 00                	mov    (%eax),%al
  801953:	0f b6 d0             	movzbl %al,%edx
  801956:	8b 45 0c             	mov    0xc(%ebp),%eax
  801959:	0f b6 c0             	movzbl %al,%eax
  80195c:	39 c2                	cmp    %eax,%edx
  80195e:	74 0d                	je     80196d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801960:	ff 45 08             	incl   0x8(%ebp)
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801969:	72 e3                	jb     80194e <memfind+0x13>
  80196b:	eb 01                	jmp    80196e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80196d:	90                   	nop
	return (void *) s;
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801979:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801980:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801987:	eb 03                	jmp    80198c <strtol+0x19>
		s++;
  801989:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	3c 20                	cmp    $0x20,%al
  801993:	74 f4                	je     801989 <strtol+0x16>
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	8a 00                	mov    (%eax),%al
  80199a:	3c 09                	cmp    $0x9,%al
  80199c:	74 eb                	je     801989 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	8a 00                	mov    (%eax),%al
  8019a3:	3c 2b                	cmp    $0x2b,%al
  8019a5:	75 05                	jne    8019ac <strtol+0x39>
		s++;
  8019a7:	ff 45 08             	incl   0x8(%ebp)
  8019aa:	eb 13                	jmp    8019bf <strtol+0x4c>
	else if (*s == '-')
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	3c 2d                	cmp    $0x2d,%al
  8019b3:	75 0a                	jne    8019bf <strtol+0x4c>
		s++, neg = 1;
  8019b5:	ff 45 08             	incl   0x8(%ebp)
  8019b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c3:	74 06                	je     8019cb <strtol+0x58>
  8019c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019c9:	75 20                	jne    8019eb <strtol+0x78>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	3c 30                	cmp    $0x30,%al
  8019d2:	75 17                	jne    8019eb <strtol+0x78>
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	40                   	inc    %eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	3c 78                	cmp    $0x78,%al
  8019dc:	75 0d                	jne    8019eb <strtol+0x78>
		s += 2, base = 16;
  8019de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019e9:	eb 28                	jmp    801a13 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ef:	75 15                	jne    801a06 <strtol+0x93>
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	3c 30                	cmp    $0x30,%al
  8019f8:	75 0c                	jne    801a06 <strtol+0x93>
		s++, base = 8;
  8019fa:	ff 45 08             	incl   0x8(%ebp)
  8019fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a04:	eb 0d                	jmp    801a13 <strtol+0xa0>
	else if (base == 0)
  801a06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0a:	75 07                	jne    801a13 <strtol+0xa0>
		base = 10;
  801a0c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	3c 2f                	cmp    $0x2f,%al
  801a1a:	7e 19                	jle    801a35 <strtol+0xc2>
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	8a 00                	mov    (%eax),%al
  801a21:	3c 39                	cmp    $0x39,%al
  801a23:	7f 10                	jg     801a35 <strtol+0xc2>
			dig = *s - '0';
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	8a 00                	mov    (%eax),%al
  801a2a:	0f be c0             	movsbl %al,%eax
  801a2d:	83 e8 30             	sub    $0x30,%eax
  801a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a33:	eb 42                	jmp    801a77 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	8a 00                	mov    (%eax),%al
  801a3a:	3c 60                	cmp    $0x60,%al
  801a3c:	7e 19                	jle    801a57 <strtol+0xe4>
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3c 7a                	cmp    $0x7a,%al
  801a45:	7f 10                	jg     801a57 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	83 e8 57             	sub    $0x57,%eax
  801a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a55:	eb 20                	jmp    801a77 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	8a 00                	mov    (%eax),%al
  801a5c:	3c 40                	cmp    $0x40,%al
  801a5e:	7e 39                	jle    801a99 <strtol+0x126>
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	8a 00                	mov    (%eax),%al
  801a65:	3c 5a                	cmp    $0x5a,%al
  801a67:	7f 30                	jg     801a99 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8a 00                	mov    (%eax),%al
  801a6e:	0f be c0             	movsbl %al,%eax
  801a71:	83 e8 37             	sub    $0x37,%eax
  801a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a7d:	7d 19                	jge    801a98 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a7f:	ff 45 08             	incl   0x8(%ebp)
  801a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a85:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a89:	89 c2                	mov    %eax,%edx
  801a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8e:	01 d0                	add    %edx,%eax
  801a90:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a93:	e9 7b ff ff ff       	jmp    801a13 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a98:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a9d:	74 08                	je     801aa7 <strtol+0x134>
		*endptr = (char *) s;
  801a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801aa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801aab:	74 07                	je     801ab4 <strtol+0x141>
  801aad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ab0:	f7 d8                	neg    %eax
  801ab2:	eb 03                	jmp    801ab7 <strtol+0x144>
  801ab4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <ltostr>:

void
ltostr(long value, char *str)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801abf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801ac6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801acd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ad1:	79 13                	jns    801ae6 <ltostr+0x2d>
	{
		neg = 1;
  801ad3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801ae0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ae3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801aee:	99                   	cltd   
  801aef:	f7 f9                	idiv   %ecx
  801af1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801af4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af7:	8d 50 01             	lea    0x1(%eax),%edx
  801afa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801afd:	89 c2                	mov    %eax,%edx
  801aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b02:	01 d0                	add    %edx,%eax
  801b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b07:	83 c2 30             	add    $0x30,%edx
  801b0a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b0f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b14:	f7 e9                	imul   %ecx
  801b16:	c1 fa 02             	sar    $0x2,%edx
  801b19:	89 c8                	mov    %ecx,%eax
  801b1b:	c1 f8 1f             	sar    $0x1f,%eax
  801b1e:	29 c2                	sub    %eax,%edx
  801b20:	89 d0                	mov    %edx,%eax
  801b22:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b29:	75 bb                	jne    801ae6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b35:	48                   	dec    %eax
  801b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b3d:	74 3d                	je     801b7c <ltostr+0xc3>
		start = 1 ;
  801b3f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b46:	eb 34                	jmp    801b7c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	8a 00                	mov    (%eax),%al
  801b52:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b63:	01 c8                	add    %ecx,%eax
  801b65:	8a 00                	mov    (%eax),%al
  801b67:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	01 c2                	add    %eax,%edx
  801b71:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b74:	88 02                	mov    %al,(%edx)
		start++ ;
  801b76:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b79:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b82:	7c c4                	jl     801b48 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b84:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8a:	01 d0                	add    %edx,%eax
  801b8c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b8f:	90                   	nop
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	e8 c4 f9 ff ff       	call   801564 <strlen>
  801ba0:	83 c4 04             	add    $0x4,%esp
  801ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	e8 b6 f9 ff ff       	call   801564 <strlen>
  801bae:	83 c4 04             	add    $0x4,%esp
  801bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801bb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bc2:	eb 17                	jmp    801bdb <strcconcat+0x49>
		final[s] = str1[s] ;
  801bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bd8:	ff 45 fc             	incl   -0x4(%ebp)
  801bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bde:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801be1:	7c e1                	jl     801bc4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801be3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bf1:	eb 1f                	jmp    801c12 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bf6:	8d 50 01             	lea    0x1(%eax),%edx
  801bf9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bfc:	89 c2                	mov    %eax,%edx
  801bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801c01:	01 c2                	add    %eax,%edx
  801c03:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c09:	01 c8                	add    %ecx,%eax
  801c0b:	8a 00                	mov    (%eax),%al
  801c0d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c0f:	ff 45 f8             	incl   -0x8(%ebp)
  801c12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c18:	7c d9                	jl     801bf3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c20:	01 d0                	add    %edx,%eax
  801c22:	c6 00 00             	movb   $0x0,(%eax)
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c34:	8b 45 14             	mov    0x14(%ebp),%eax
  801c37:	8b 00                	mov    (%eax),%eax
  801c39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c40:	8b 45 10             	mov    0x10(%ebp),%eax
  801c43:	01 d0                	add    %edx,%eax
  801c45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c4b:	eb 0c                	jmp    801c59 <strsplit+0x31>
			*string++ = 0;
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	8d 50 01             	lea    0x1(%eax),%edx
  801c53:	89 55 08             	mov    %edx,0x8(%ebp)
  801c56:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8a 00                	mov    (%eax),%al
  801c5e:	84 c0                	test   %al,%al
  801c60:	74 18                	je     801c7a <strsplit+0x52>
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	0f be c0             	movsbl %al,%eax
  801c6a:	50                   	push   %eax
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	e8 83 fa ff ff       	call   8016f6 <strchr>
  801c73:	83 c4 08             	add    $0x8,%esp
  801c76:	85 c0                	test   %eax,%eax
  801c78:	75 d3                	jne    801c4d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	8a 00                	mov    (%eax),%al
  801c7f:	84 c0                	test   %al,%al
  801c81:	74 5a                	je     801cdd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c83:	8b 45 14             	mov    0x14(%ebp),%eax
  801c86:	8b 00                	mov    (%eax),%eax
  801c88:	83 f8 0f             	cmp    $0xf,%eax
  801c8b:	75 07                	jne    801c94 <strsplit+0x6c>
		{
			return 0;
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c92:	eb 66                	jmp    801cfa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c94:	8b 45 14             	mov    0x14(%ebp),%eax
  801c97:	8b 00                	mov    (%eax),%eax
  801c99:	8d 48 01             	lea    0x1(%eax),%ecx
  801c9c:	8b 55 14             	mov    0x14(%ebp),%edx
  801c9f:	89 0a                	mov    %ecx,(%edx)
  801ca1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cab:	01 c2                	add    %eax,%edx
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cb2:	eb 03                	jmp    801cb7 <strsplit+0x8f>
			string++;
  801cb4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8a 00                	mov    (%eax),%al
  801cbc:	84 c0                	test   %al,%al
  801cbe:	74 8b                	je     801c4b <strsplit+0x23>
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	0f be c0             	movsbl %al,%eax
  801cc8:	50                   	push   %eax
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	e8 25 fa ff ff       	call   8016f6 <strchr>
  801cd1:	83 c4 08             	add    $0x8,%esp
  801cd4:	85 c0                	test   %eax,%eax
  801cd6:	74 dc                	je     801cb4 <strsplit+0x8c>
			string++;
	}
  801cd8:	e9 6e ff ff ff       	jmp    801c4b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cdd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cde:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce1:	8b 00                	mov    (%eax),%eax
  801ce3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ced:	01 d0                	add    %edx,%eax
  801cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cf5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d0f:	eb 4a                	jmp    801d5b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	01 c2                	add    %eax,%edx
  801d19:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	01 c8                	add    %ecx,%eax
  801d21:	8a 00                	mov    (%eax),%al
  801d23:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	3c 40                	cmp    $0x40,%al
  801d31:	7e 25                	jle    801d58 <str2lower+0x5c>
  801d33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d39:	01 d0                	add    %edx,%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	3c 5a                	cmp    $0x5a,%al
  801d3f:	7f 17                	jg     801d58 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	01 d0                	add    %edx,%eax
  801d49:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801d4f:	01 ca                	add    %ecx,%edx
  801d51:	8a 12                	mov    (%edx),%dl
  801d53:	83 c2 20             	add    $0x20,%edx
  801d56:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d58:	ff 45 fc             	incl   -0x4(%ebp)
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	e8 01 f8 ff ff       	call   801564 <strlen>
  801d63:	83 c4 04             	add    $0x4,%esp
  801d66:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d69:	7f a6                	jg     801d11 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801d6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801d76:	a1 08 60 80 00       	mov    0x806008,%eax
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	74 42                	je     801dc1 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801d7f:	83 ec 08             	sub    $0x8,%esp
  801d82:	68 00 00 00 82       	push   $0x82000000
  801d87:	68 00 00 00 80       	push   $0x80000000
  801d8c:	e8 b0 1e 00 00       	call   803c41 <initialize_dynamic_allocator>
  801d91:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801d94:	e8 96 1c 00 00       	call   803a2f <sys_get_uheap_strategy>
  801d99:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801d9e:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801da3:	05 00 10 00 00       	add    $0x1000,%eax
  801da8:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801dad:	a1 30 61 83 00       	mov    0x836130,%eax
  801db2:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801db7:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801dbe:	00 00 00 
	}
}
  801dc1:	90                   	nop
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	68 06 04 00 00       	push   $0x406
  801de0:	50                   	push   %eax
  801de1:	e8 93 18 00 00       	call   803679 <__sys_allocate_page>
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801dec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801df0:	79 14                	jns    801e06 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	68 1c 51 80 00       	push   $0x80511c
  801dfa:	6a 1f                	push   $0x1f
  801dfc:	68 58 51 80 00       	push   $0x805158
  801e01:	e8 af eb ff ff       	call   8009b5 <_panic>
	return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	50                   	push   %eax
  801e25:	e8 96 18 00 00       	call   8036c0 <__sys_unmap_frame>
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e34:	79 14                	jns    801e4a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	68 64 51 80 00       	push   $0x805164
  801e3e:	6a 2a                	push   $0x2a
  801e40:	68 58 51 80 00       	push   $0x805158
  801e45:	e8 6b eb ff ff       	call   8009b5 <_panic>
}
  801e4a:	90                   	nop
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e53:	e8 18 ff ff ff       	call   801d70 <uheap_init>
	if (size == 0) return NULL ;
  801e58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e5c:	75 0a                	jne    801e68 <malloc+0x1b>
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	e9 43 03 00 00       	jmp    8021ab <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801e68:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e6f:	77 13                	ja     801e84 <malloc+0x37>
    {
        return alloc_block(size);
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	ff 75 08             	pushl  0x8(%ebp)
  801e77:	e8 78 20 00 00       	call   803ef4 <alloc_block>
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	e9 27 03 00 00       	jmp    8021ab <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801e84:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e91:	01 d0                	add    %edx,%eax
  801e93:	48                   	dec    %eax
  801e94:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9f:	f7 75 dc             	divl   -0x24(%ebp)
  801ea2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ea5:	29 d0                	sub    %edx,%eax
  801ea7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801eaa:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	75 0a                	jne    801ebd <malloc+0x70>
    {
        uhp_inited = 1;
  801eb3:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801eba:	00 00 00 
    }

    int exactIdx = -1;
  801ebd:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ec4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801ecb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ed2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ed9:	e9 85 00 00 00       	jmp    801f63 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ede:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ee1:	89 d0                	mov    %edx,%eax
  801ee3:	01 c0                	add    %eax,%eax
  801ee5:	01 d0                	add    %edx,%eax
  801ee7:	c1 e0 02             	shl    $0x2,%eax
  801eea:	05 48 20 81 00       	add    $0x812048,%eax
  801eef:	8a 00                	mov    (%eax),%al
  801ef1:	84 c0                	test   %al,%al
  801ef3:	74 20                	je     801f15 <malloc+0xc8>
  801ef5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ef8:	89 d0                	mov    %edx,%eax
  801efa:	01 c0                	add    %eax,%eax
  801efc:	01 d0                	add    %edx,%eax
  801efe:	c1 e0 02             	shl    $0x2,%eax
  801f01:	05 44 20 81 00       	add    $0x812044,%eax
  801f06:	8b 00                	mov    (%eax),%eax
  801f08:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f0b:	75 08                	jne    801f15 <malloc+0xc8>
        {
            exactIdx = i;
  801f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f13:	eb 5b                	jmp    801f70 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f18:	89 d0                	mov    %edx,%eax
  801f1a:	01 c0                	add    %eax,%eax
  801f1c:	01 d0                	add    %edx,%eax
  801f1e:	c1 e0 02             	shl    $0x2,%eax
  801f21:	05 48 20 81 00       	add    $0x812048,%eax
  801f26:	8a 00                	mov    (%eax),%al
  801f28:	84 c0                	test   %al,%al
  801f2a:	74 34                	je     801f60 <malloc+0x113>
  801f2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f2f:	89 d0                	mov    %edx,%eax
  801f31:	01 c0                	add    %eax,%eax
  801f33:	01 d0                	add    %edx,%eax
  801f35:	c1 e0 02             	shl    $0x2,%eax
  801f38:	05 44 20 81 00       	add    $0x812044,%eax
  801f3d:	8b 00                	mov    (%eax),%eax
  801f3f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f42:	76 1c                	jbe    801f60 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801f44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f47:	89 d0                	mov    %edx,%eax
  801f49:	01 c0                	add    %eax,%eax
  801f4b:	01 d0                	add    %edx,%eax
  801f4d:	c1 e0 02             	shl    $0x2,%eax
  801f50:	05 44 20 81 00       	add    $0x812044,%eax
  801f55:	8b 00                	mov    (%eax),%eax
  801f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f60:	ff 45 e8             	incl   -0x18(%ebp)
  801f63:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f6a:	0f 8e 6e ff ff ff    	jle    801ede <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801f70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f77:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f7b:	74 7d                	je     801ffa <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f7d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f87:	89 d0                	mov    %edx,%eax
  801f89:	01 c0                	add    %eax,%eax
  801f8b:	01 d0                	add    %edx,%eax
  801f8d:	c1 e0 02             	shl    $0x2,%eax
  801f90:	05 40 20 81 00       	add    $0x812040,%eax
  801f95:	8b 10                	mov    (%eax),%edx
  801f97:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	48                   	dec    %eax
  801f9d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801fa0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa8:	f7 75 bc             	divl   -0x44(%ebp)
  801fab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fae:	29 d0                	sub    %edx,%eax
  801fb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801fb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb6:	89 d0                	mov    %edx,%eax
  801fb8:	01 c0                	add    %eax,%eax
  801fba:	01 d0                	add    %edx,%eax
  801fbc:	c1 e0 02             	shl    $0x2,%eax
  801fbf:	05 48 20 81 00       	add    $0x812048,%eax
  801fc4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fca:	89 d0                	mov    %edx,%eax
  801fcc:	01 c0                	add    %eax,%eax
  801fce:	01 d0                	add    %edx,%eax
  801fd0:	c1 e0 02             	shl    $0x2,%eax
  801fd3:	05 44 20 81 00       	add    $0x812044,%eax
  801fd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe1:	89 d0                	mov    %edx,%eax
  801fe3:	01 c0                	add    %eax,%eax
  801fe5:	01 d0                	add    %edx,%eax
  801fe7:	c1 e0 02             	shl    $0x2,%eax
  801fea:	05 40 20 81 00       	add    $0x812040,%eax
  801fef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ff5:	e9 2d 01 00 00       	jmp    802127 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801ffa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ffe:	0f 84 ce 00 00 00    	je     8020d2 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802004:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80200b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200e:	89 d0                	mov    %edx,%eax
  802010:	01 c0                	add    %eax,%eax
  802012:	01 d0                	add    %edx,%eax
  802014:	c1 e0 02             	shl    $0x2,%eax
  802017:	05 40 20 81 00       	add    $0x812040,%eax
  80201c:	8b 10                	mov    (%eax),%edx
  80201e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802021:	01 d0                	add    %edx,%eax
  802023:	48                   	dec    %eax
  802024:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802027:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80202a:	ba 00 00 00 00       	mov    $0x0,%edx
  80202f:	f7 75 c4             	divl   -0x3c(%ebp)
  802032:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802035:	29 d0                	sub    %edx,%eax
  802037:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80203a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80203d:	89 d0                	mov    %edx,%eax
  80203f:	01 c0                	add    %eax,%eax
  802041:	01 d0                	add    %edx,%eax
  802043:	c1 e0 02             	shl    $0x2,%eax
  802046:	05 44 20 81 00       	add    $0x812044,%eax
  80204b:	8b 00                	mov    (%eax),%eax
  80204d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802050:	75 47                	jne    802099 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  802052:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802055:	89 d0                	mov    %edx,%eax
  802057:	01 c0                	add    %eax,%eax
  802059:	01 d0                	add    %edx,%eax
  80205b:	c1 e0 02             	shl    $0x2,%eax
  80205e:	05 48 20 81 00       	add    $0x812048,%eax
  802063:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802066:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	01 c0                	add    %eax,%eax
  80206d:	01 d0                	add    %edx,%eax
  80206f:	c1 e0 02             	shl    $0x2,%eax
  802072:	05 44 20 81 00       	add    $0x812044,%eax
  802077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80207d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802080:	89 d0                	mov    %edx,%eax
  802082:	01 c0                	add    %eax,%eax
  802084:	01 d0                	add    %edx,%eax
  802086:	c1 e0 02             	shl    $0x2,%eax
  802089:	05 40 20 81 00       	add    $0x812040,%eax
  80208e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802094:	e9 8e 00 00 00       	jmp    802127 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802099:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80209c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80209f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a5:	89 d0                	mov    %edx,%eax
  8020a7:	01 c0                	add    %eax,%eax
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	c1 e0 02             	shl    $0x2,%eax
  8020ae:	05 40 20 81 00       	add    $0x812040,%eax
  8020b3:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020bb:	89 c2                	mov    %eax,%edx
  8020bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020c0:	89 c8                	mov    %ecx,%eax
  8020c2:	01 c0                	add    %eax,%eax
  8020c4:	01 c8                	add    %ecx,%eax
  8020c6:	c1 e0 02             	shl    $0x2,%eax
  8020c9:	05 44 20 81 00       	add    $0x812044,%eax
  8020ce:	89 10                	mov    %edx,(%eax)
  8020d0:	eb 55                	jmp    802127 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020d2:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020d9:	8b 15 88 60 83 00    	mov    0x836088,%edx
  8020df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020e2:	01 d0                	add    %edx,%eax
  8020e4:	48                   	dec    %eax
  8020e5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f0:	f7 75 d0             	divl   -0x30(%ebp)
  8020f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020f6:	29 d0                	sub    %edx,%eax
  8020f8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8020fb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802101:	01 d0                	add    %edx,%eax
  802103:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802108:	76 0a                	jbe    802114 <malloc+0x2c7>
            return NULL;
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	e9 97 00 00 00       	jmp    8021ab <malloc+0x35e>
        va = start;
  802114:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802117:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80211a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80211d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802120:	01 d0                	add    %edx,%eax
  802122:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802127:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80212e:	eb 5e                	jmp    80218e <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  802130:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802133:	89 d0                	mov    %edx,%eax
  802135:	01 c0                	add    %eax,%eax
  802137:	01 d0                	add    %edx,%eax
  802139:	c1 e0 02             	shl    $0x2,%eax
  80213c:	05 48 60 80 00       	add    $0x806048,%eax
  802141:	8a 00                	mov    (%eax),%al
  802143:	84 c0                	test   %al,%al
  802145:	75 44                	jne    80218b <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  802147:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80214a:	89 d0                	mov    %edx,%eax
  80214c:	01 c0                	add    %eax,%eax
  80214e:	01 d0                	add    %edx,%eax
  802150:	c1 e0 02             	shl    $0x2,%eax
  802153:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80215e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802161:	89 d0                	mov    %edx,%eax
  802163:	01 c0                	add    %eax,%eax
  802165:	01 d0                	add    %edx,%eax
  802167:	c1 e0 02             	shl    $0x2,%eax
  80216a:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802170:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802173:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802175:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802178:	89 d0                	mov    %edx,%eax
  80217a:	01 c0                	add    %eax,%eax
  80217c:	01 d0                	add    %edx,%eax
  80217e:	c1 e0 02             	shl    $0x2,%eax
  802181:	05 48 60 80 00       	add    $0x806048,%eax
  802186:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802189:	eb 0c                	jmp    802197 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80218b:	ff 45 e0             	incl   -0x20(%ebp)
  80218e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802195:	7e 99                	jle    802130 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  802197:	83 ec 08             	sub    $0x8,%esp
  80219a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80219d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021a0:	e8 a2 19 00 00       	call   803b47 <sys_allocate_user_mem>
  8021a5:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8021a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8021b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b7:	0f 84 fa 03 00 00    	je     8025b7 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8021c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	79 1c                	jns    8021e6 <free+0x39>
  8021ca:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  8021d1:	77 13                	ja     8021e6 <free+0x39>
    {
        free_block(virtual_address);
  8021d3:	83 ec 0c             	sub    $0xc,%esp
  8021d6:	ff 75 08             	pushl  0x8(%ebp)
  8021d9:	e8 09 21 00 00       	call   8042e7 <free_block>
  8021de:	83 c4 10             	add    $0x10,%esp
        return;
  8021e1:	e9 d2 03 00 00       	jmp    8025b8 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8021e6:	a1 30 61 83 00       	mov    0x836130,%eax
  8021eb:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8021ee:	72 09                	jb     8021f9 <free+0x4c>
  8021f0:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  8021f7:	76 17                	jbe    802210 <free+0x63>
        panic("free: invalid address");
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	68 a1 51 80 00       	push   $0x8051a1
  802201:	68 9b 00 00 00       	push   $0x9b
  802206:	68 58 51 80 00       	push   $0x805158
  80220b:	e8 a5 e7 ff ff       	call   8009b5 <_panic>

    uint32 size = 0;
  802210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  802217:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80221e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802225:	eb 50                	jmp    802277 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802227:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	01 c0                	add    %eax,%eax
  80222e:	01 d0                	add    %edx,%eax
  802230:	c1 e0 02             	shl    $0x2,%eax
  802233:	05 48 60 80 00       	add    $0x806048,%eax
  802238:	8a 00                	mov    (%eax),%al
  80223a:	84 c0                	test   %al,%al
  80223c:	74 36                	je     802274 <free+0xc7>
  80223e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802241:	89 d0                	mov    %edx,%eax
  802243:	01 c0                	add    %eax,%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	c1 e0 02             	shl    $0x2,%eax
  80224a:	05 40 60 80 00       	add    $0x806040,%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802254:	75 1e                	jne    802274 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  802256:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802259:	89 d0                	mov    %edx,%eax
  80225b:	01 c0                	add    %eax,%eax
  80225d:	01 d0                	add    %edx,%eax
  80225f:	c1 e0 02             	shl    $0x2,%eax
  802262:	05 44 60 80 00       	add    $0x806044,%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  80226c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  802272:	eb 0c                	jmp    802280 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802274:	ff 45 ec             	incl   -0x14(%ebp)
  802277:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80227e:	7e a7                	jle    802227 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  802280:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802284:	74 06                	je     80228c <free+0xdf>
  802286:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228a:	75 17                	jne    8022a3 <free+0xf6>
        panic("free: unknown block");
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	68 b7 51 80 00       	push   $0x8051b7
  802294:	68 a9 00 00 00       	push   $0xa9
  802299:	68 58 51 80 00       	push   $0x805158
  80229e:	e8 12 e7 ff ff       	call   8009b5 <_panic>

    uhp_allocs[idx].used = 0;
  8022a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022a6:	89 d0                	mov    %edx,%eax
  8022a8:	01 c0                	add    %eax,%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	c1 e0 02             	shl    $0x2,%eax
  8022af:	05 48 60 80 00       	add    $0x806048,%eax
  8022b4:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8022b7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8022c5:	eb 64                	jmp    80232b <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8022c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022ca:	89 d0                	mov    %edx,%eax
  8022cc:	01 c0                	add    %eax,%eax
  8022ce:	01 d0                	add    %edx,%eax
  8022d0:	c1 e0 02             	shl    $0x2,%eax
  8022d3:	05 48 20 81 00       	add    $0x812048,%eax
  8022d8:	8a 00                	mov    (%eax),%al
  8022da:	84 c0                	test   %al,%al
  8022dc:	75 4a                	jne    802328 <free+0x17b>
        {
            uhp_frees[i].va = va;
  8022de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022e1:	89 d0                	mov    %edx,%eax
  8022e3:	01 c0                	add    %eax,%eax
  8022e5:	01 d0                	add    %edx,%eax
  8022e7:	c1 e0 02             	shl    $0x2,%eax
  8022ea:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8022f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f3:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  8022f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022f8:	89 d0                	mov    %edx,%eax
  8022fa:	01 c0                	add    %eax,%eax
  8022fc:	01 d0                	add    %edx,%eax
  8022fe:	c1 e0 02             	shl    $0x2,%eax
  802301:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  80230c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80230f:	89 d0                	mov    %edx,%eax
  802311:	01 c0                	add    %eax,%eax
  802313:	01 d0                	add    %edx,%eax
  802315:	c1 e0 02             	shl    $0x2,%eax
  802318:	05 48 20 81 00       	add    $0x812048,%eax
  80231d:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802323:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802326:	eb 0c                	jmp    802334 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802328:	ff 45 e4             	incl   -0x1c(%ebp)
  80232b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802332:	7e 93                	jle    8022c7 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  802334:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802338:	0f 84 f1 01 00 00    	je     80252f <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80233e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802345:	e9 d8 01 00 00       	jmp    802522 <free+0x375>
        {
            if (i == fidx) continue;
  80234a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80234d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802350:	0f 84 c8 01 00 00    	je     80251e <free+0x371>
            if (uhp_frees[i].free)
  802356:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802359:	89 d0                	mov    %edx,%eax
  80235b:	01 c0                	add    %eax,%eax
  80235d:	01 d0                	add    %edx,%eax
  80235f:	c1 e0 02             	shl    $0x2,%eax
  802362:	05 48 20 81 00       	add    $0x812048,%eax
  802367:	8a 00                	mov    (%eax),%al
  802369:	84 c0                	test   %al,%al
  80236b:	0f 84 ae 01 00 00    	je     80251f <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  802371:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802374:	89 d0                	mov    %edx,%eax
  802376:	01 c0                	add    %eax,%eax
  802378:	01 d0                	add    %edx,%eax
  80237a:	c1 e0 02             	shl    $0x2,%eax
  80237d:	05 40 20 81 00       	add    $0x812040,%eax
  802382:	8b 08                	mov    (%eax),%ecx
  802384:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802387:	89 d0                	mov    %edx,%eax
  802389:	01 c0                	add    %eax,%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	c1 e0 02             	shl    $0x2,%eax
  802390:	05 44 20 81 00       	add    $0x812044,%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	01 c1                	add    %eax,%ecx
  802399:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80239c:	89 d0                	mov    %edx,%eax
  80239e:	01 c0                	add    %eax,%eax
  8023a0:	01 d0                	add    %edx,%eax
  8023a2:	c1 e0 02             	shl    $0x2,%eax
  8023a5:	05 40 20 81 00       	add    $0x812040,%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	39 c1                	cmp    %eax,%ecx
  8023ae:	0f 85 a8 00 00 00    	jne    80245c <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  8023b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023b7:	89 d0                	mov    %edx,%eax
  8023b9:	01 c0                	add    %eax,%eax
  8023bb:	01 d0                	add    %edx,%eax
  8023bd:	c1 e0 02             	shl    $0x2,%eax
  8023c0:	05 40 20 81 00       	add    $0x812040,%eax
  8023c5:	8b 10                	mov    (%eax),%edx
  8023c7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8023ca:	89 c8                	mov    %ecx,%eax
  8023cc:	01 c0                	add    %eax,%eax
  8023ce:	01 c8                	add    %ecx,%eax
  8023d0:	c1 e0 02             	shl    $0x2,%eax
  8023d3:	05 40 20 81 00       	add    $0x812040,%eax
  8023d8:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8023da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023dd:	89 d0                	mov    %edx,%eax
  8023df:	01 c0                	add    %eax,%eax
  8023e1:	01 d0                	add    %edx,%eax
  8023e3:	c1 e0 02             	shl    $0x2,%eax
  8023e6:	05 44 20 81 00       	add    $0x812044,%eax
  8023eb:	8b 08                	mov    (%eax),%ecx
  8023ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023f0:	89 d0                	mov    %edx,%eax
  8023f2:	01 c0                	add    %eax,%eax
  8023f4:	01 d0                	add    %edx,%eax
  8023f6:	c1 e0 02             	shl    $0x2,%eax
  8023f9:	05 44 20 81 00       	add    $0x812044,%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	01 c1                	add    %eax,%ecx
  802402:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802405:	89 d0                	mov    %edx,%eax
  802407:	01 c0                	add    %eax,%eax
  802409:	01 d0                	add    %edx,%eax
  80240b:	c1 e0 02             	shl    $0x2,%eax
  80240e:	05 44 20 81 00       	add    $0x812044,%eax
  802413:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802415:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802418:	89 d0                	mov    %edx,%eax
  80241a:	01 c0                	add    %eax,%eax
  80241c:	01 d0                	add    %edx,%eax
  80241e:	c1 e0 02             	shl    $0x2,%eax
  802421:	05 48 20 81 00       	add    $0x812048,%eax
  802426:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802429:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80242c:	89 d0                	mov    %edx,%eax
  80242e:	01 c0                	add    %eax,%eax
  802430:	01 d0                	add    %edx,%eax
  802432:	c1 e0 02             	shl    $0x2,%eax
  802435:	05 40 20 81 00       	add    $0x812040,%eax
  80243a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802440:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802443:	89 d0                	mov    %edx,%eax
  802445:	01 c0                	add    %eax,%eax
  802447:	01 d0                	add    %edx,%eax
  802449:	c1 e0 02             	shl    $0x2,%eax
  80244c:	05 44 20 81 00       	add    $0x812044,%eax
  802451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802457:	e9 c3 00 00 00       	jmp    80251f <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  80245c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80245f:	89 d0                	mov    %edx,%eax
  802461:	01 c0                	add    %eax,%eax
  802463:	01 d0                	add    %edx,%eax
  802465:	c1 e0 02             	shl    $0x2,%eax
  802468:	05 40 20 81 00       	add    $0x812040,%eax
  80246d:	8b 08                	mov    (%eax),%ecx
  80246f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802472:	89 d0                	mov    %edx,%eax
  802474:	01 c0                	add    %eax,%eax
  802476:	01 d0                	add    %edx,%eax
  802478:	c1 e0 02             	shl    $0x2,%eax
  80247b:	05 44 20 81 00       	add    $0x812044,%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	01 c1                	add    %eax,%ecx
  802484:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802487:	89 d0                	mov    %edx,%eax
  802489:	01 c0                	add    %eax,%eax
  80248b:	01 d0                	add    %edx,%eax
  80248d:	c1 e0 02             	shl    $0x2,%eax
  802490:	05 40 20 81 00       	add    $0x812040,%eax
  802495:	8b 00                	mov    (%eax),%eax
  802497:	39 c1                	cmp    %eax,%ecx
  802499:	0f 85 80 00 00 00    	jne    80251f <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80249f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024a2:	89 d0                	mov    %edx,%eax
  8024a4:	01 c0                	add    %eax,%eax
  8024a6:	01 d0                	add    %edx,%eax
  8024a8:	c1 e0 02             	shl    $0x2,%eax
  8024ab:	05 44 20 81 00       	add    $0x812044,%eax
  8024b0:	8b 08                	mov    (%eax),%ecx
  8024b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024b5:	89 d0                	mov    %edx,%eax
  8024b7:	01 c0                	add    %eax,%eax
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	c1 e0 02             	shl    $0x2,%eax
  8024be:	05 44 20 81 00       	add    $0x812044,%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	01 c1                	add    %eax,%ecx
  8024c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024ca:	89 d0                	mov    %edx,%eax
  8024cc:	01 c0                	add    %eax,%eax
  8024ce:	01 d0                	add    %edx,%eax
  8024d0:	c1 e0 02             	shl    $0x2,%eax
  8024d3:	05 44 20 81 00       	add    $0x812044,%eax
  8024d8:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8024da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024dd:	89 d0                	mov    %edx,%eax
  8024df:	01 c0                	add    %eax,%eax
  8024e1:	01 d0                	add    %edx,%eax
  8024e3:	c1 e0 02             	shl    $0x2,%eax
  8024e6:	05 48 20 81 00       	add    $0x812048,%eax
  8024eb:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8024ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024f1:	89 d0                	mov    %edx,%eax
  8024f3:	01 c0                	add    %eax,%eax
  8024f5:	01 d0                	add    %edx,%eax
  8024f7:	c1 e0 02             	shl    $0x2,%eax
  8024fa:	05 40 20 81 00       	add    $0x812040,%eax
  8024ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802505:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802508:	89 d0                	mov    %edx,%eax
  80250a:	01 c0                	add    %eax,%eax
  80250c:	01 d0                	add    %edx,%eax
  80250e:	c1 e0 02             	shl    $0x2,%eax
  802511:	05 44 20 81 00       	add    $0x812044,%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251c:	eb 01                	jmp    80251f <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  80251e:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80251f:	ff 45 e0             	incl   -0x20(%ebp)
  802522:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802529:	0f 8e 1b fe ff ff    	jle    80234a <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  80252f:	a1 30 61 83 00       	mov    0x836130,%eax
  802534:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802537:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80253e:	eb 53                	jmp    802593 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802540:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802543:	89 d0                	mov    %edx,%eax
  802545:	01 c0                	add    %eax,%eax
  802547:	01 d0                	add    %edx,%eax
  802549:	c1 e0 02             	shl    $0x2,%eax
  80254c:	05 48 60 80 00       	add    $0x806048,%eax
  802551:	8a 00                	mov    (%eax),%al
  802553:	84 c0                	test   %al,%al
  802555:	74 39                	je     802590 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802557:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80255a:	89 d0                	mov    %edx,%eax
  80255c:	01 c0                	add    %eax,%eax
  80255e:	01 d0                	add    %edx,%eax
  802560:	c1 e0 02             	shl    $0x2,%eax
  802563:	05 40 60 80 00       	add    $0x806040,%eax
  802568:	8b 08                	mov    (%eax),%ecx
  80256a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80256d:	89 d0                	mov    %edx,%eax
  80256f:	01 c0                	add    %eax,%eax
  802571:	01 d0                	add    %edx,%eax
  802573:	c1 e0 02             	shl    $0x2,%eax
  802576:	05 44 60 80 00       	add    $0x806044,%eax
  80257b:	8b 00                	mov    (%eax),%eax
  80257d:	01 c8                	add    %ecx,%eax
  80257f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  802582:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802585:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802588:	76 06                	jbe    802590 <free+0x3e3>
  80258a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80258d:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802590:	ff 45 d8             	incl   -0x28(%ebp)
  802593:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80259a:	7e a4                	jle    802540 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  80259c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80259f:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  8025a4:	83 ec 08             	sub    $0x8,%esp
  8025a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8025ad:	e8 79 15 00 00       	call   803b2b <sys_free_user_mem>
  8025b2:	83 c4 10             	add    $0x10,%esp
  8025b5:	eb 01                	jmp    8025b8 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  8025b7:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 68             	sub    $0x68,%esp
  8025c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c3:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025c6:	e8 a5 f7 ff ff       	call   801d70 <uheap_init>
	if (size == 0) return NULL ;
  8025cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025cf:	75 0a                	jne    8025db <smalloc+0x21>
  8025d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d6:	e9 37 03 00 00       	jmp    802912 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8025db:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8025e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025e8:	01 d0                	add    %edx,%eax
  8025ea:	48                   	dec    %eax
  8025eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8025ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f6:	f7 75 dc             	divl   -0x24(%ebp)
  8025f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025fc:	29 d0                	sub    %edx,%eax
  8025fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802601:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802608:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80260f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802616:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80261d:	e9 85 00 00 00       	jmp    8026a7 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802622:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802625:	89 d0                	mov    %edx,%eax
  802627:	01 c0                	add    %eax,%eax
  802629:	01 d0                	add    %edx,%eax
  80262b:	c1 e0 02             	shl    $0x2,%eax
  80262e:	05 48 20 81 00       	add    $0x812048,%eax
  802633:	8a 00                	mov    (%eax),%al
  802635:	84 c0                	test   %al,%al
  802637:	74 20                	je     802659 <smalloc+0x9f>
  802639:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80263c:	89 d0                	mov    %edx,%eax
  80263e:	01 c0                	add    %eax,%eax
  802640:	01 d0                	add    %edx,%eax
  802642:	c1 e0 02             	shl    $0x2,%eax
  802645:	05 44 20 81 00       	add    $0x812044,%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80264f:	75 08                	jne    802659 <smalloc+0x9f>
        {
            exactIdx = i;
  802651:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802654:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802657:	eb 5b                	jmp    8026b4 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802659:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80265c:	89 d0                	mov    %edx,%eax
  80265e:	01 c0                	add    %eax,%eax
  802660:	01 d0                	add    %edx,%eax
  802662:	c1 e0 02             	shl    $0x2,%eax
  802665:	05 48 20 81 00       	add    $0x812048,%eax
  80266a:	8a 00                	mov    (%eax),%al
  80266c:	84 c0                	test   %al,%al
  80266e:	74 34                	je     8026a4 <smalloc+0xea>
  802670:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802673:	89 d0                	mov    %edx,%eax
  802675:	01 c0                	add    %eax,%eax
  802677:	01 d0                	add    %edx,%eax
  802679:	c1 e0 02             	shl    $0x2,%eax
  80267c:	05 44 20 81 00       	add    $0x812044,%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802686:	76 1c                	jbe    8026a4 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802688:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80268b:	89 d0                	mov    %edx,%eax
  80268d:	01 c0                	add    %eax,%eax
  80268f:	01 d0                	add    %edx,%eax
  802691:	c1 e0 02             	shl    $0x2,%eax
  802694:	05 44 20 81 00       	add    $0x812044,%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80269e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a1:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8026a4:	ff 45 e8             	incl   -0x18(%ebp)
  8026a7:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8026ae:	0f 8e 6e ff ff ff    	jle    802622 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8026b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8026bb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8026bf:	74 7d                	je     80273e <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8026c1:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	89 d0                	mov    %edx,%eax
  8026cd:	01 c0                	add    %eax,%eax
  8026cf:	01 d0                	add    %edx,%eax
  8026d1:	c1 e0 02             	shl    $0x2,%eax
  8026d4:	05 40 20 81 00       	add    $0x812040,%eax
  8026d9:	8b 10                	mov    (%eax),%edx
  8026db:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026de:	01 d0                	add    %edx,%eax
  8026e0:	48                   	dec    %eax
  8026e1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8026e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ec:	f7 75 bc             	divl   -0x44(%ebp)
  8026ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026f2:	29 d0                	sub    %edx,%eax
  8026f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8026f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fa:	89 d0                	mov    %edx,%eax
  8026fc:	01 c0                	add    %eax,%eax
  8026fe:	01 d0                	add    %edx,%eax
  802700:	c1 e0 02             	shl    $0x2,%eax
  802703:	05 48 20 81 00       	add    $0x812048,%eax
  802708:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80270b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270e:	89 d0                	mov    %edx,%eax
  802710:	01 c0                	add    %eax,%eax
  802712:	01 d0                	add    %edx,%eax
  802714:	c1 e0 02             	shl    $0x2,%eax
  802717:	05 44 20 81 00       	add    $0x812044,%eax
  80271c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802725:	89 d0                	mov    %edx,%eax
  802727:	01 c0                	add    %eax,%eax
  802729:	01 d0                	add    %edx,%eax
  80272b:	c1 e0 02             	shl    $0x2,%eax
  80272e:	05 40 20 81 00       	add    $0x812040,%eax
  802733:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802739:	e9 2d 01 00 00       	jmp    80286b <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  80273e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802742:	0f 84 ce 00 00 00    	je     802816 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802748:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80274f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802752:	89 d0                	mov    %edx,%eax
  802754:	01 c0                	add    %eax,%eax
  802756:	01 d0                	add    %edx,%eax
  802758:	c1 e0 02             	shl    $0x2,%eax
  80275b:	05 40 20 81 00       	add    $0x812040,%eax
  802760:	8b 10                	mov    (%eax),%edx
  802762:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802765:	01 d0                	add    %edx,%eax
  802767:	48                   	dec    %eax
  802768:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80276b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80276e:	ba 00 00 00 00       	mov    $0x0,%edx
  802773:	f7 75 c4             	divl   -0x3c(%ebp)
  802776:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802779:	29 d0                	sub    %edx,%eax
  80277b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80277e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802781:	89 d0                	mov    %edx,%eax
  802783:	01 c0                	add    %eax,%eax
  802785:	01 d0                	add    %edx,%eax
  802787:	c1 e0 02             	shl    $0x2,%eax
  80278a:	05 44 20 81 00       	add    $0x812044,%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802794:	75 47                	jne    8027dd <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802796:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802799:	89 d0                	mov    %edx,%eax
  80279b:	01 c0                	add    %eax,%eax
  80279d:	01 d0                	add    %edx,%eax
  80279f:	c1 e0 02             	shl    $0x2,%eax
  8027a2:	05 48 20 81 00       	add    $0x812048,%eax
  8027a7:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8027aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ad:	89 d0                	mov    %edx,%eax
  8027af:	01 c0                	add    %eax,%eax
  8027b1:	01 d0                	add    %edx,%eax
  8027b3:	c1 e0 02             	shl    $0x2,%eax
  8027b6:	05 44 20 81 00       	add    $0x812044,%eax
  8027bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8027c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c4:	89 d0                	mov    %edx,%eax
  8027c6:	01 c0                	add    %eax,%eax
  8027c8:	01 d0                	add    %edx,%eax
  8027ca:	c1 e0 02             	shl    $0x2,%eax
  8027cd:	05 40 20 81 00       	add    $0x812040,%eax
  8027d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d8:	e9 8e 00 00 00       	jmp    80286b <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8027dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027e3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8027e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e9:	89 d0                	mov    %edx,%eax
  8027eb:	01 c0                	add    %eax,%eax
  8027ed:	01 d0                	add    %edx,%eax
  8027ef:	c1 e0 02             	shl    $0x2,%eax
  8027f2:	05 40 20 81 00       	add    $0x812040,%eax
  8027f7:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8027f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8027ff:	89 c2                	mov    %eax,%edx
  802801:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802804:	89 c8                	mov    %ecx,%eax
  802806:	01 c0                	add    %eax,%eax
  802808:	01 c8                	add    %ecx,%eax
  80280a:	c1 e0 02             	shl    $0x2,%eax
  80280d:	05 44 20 81 00       	add    $0x812044,%eax
  802812:	89 10                	mov    %edx,(%eax)
  802814:	eb 55                	jmp    80286b <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802816:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80281d:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802823:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802826:	01 d0                	add    %edx,%eax
  802828:	48                   	dec    %eax
  802829:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80282c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80282f:	ba 00 00 00 00       	mov    $0x0,%edx
  802834:	f7 75 d0             	divl   -0x30(%ebp)
  802837:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283a:	29 d0                	sub    %edx,%eax
  80283c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80283f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802845:	01 d0                	add    %edx,%eax
  802847:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80284c:	76 0a                	jbe    802858 <smalloc+0x29e>
            return NULL;
  80284e:	b8 00 00 00 00       	mov    $0x0,%eax
  802853:	e9 ba 00 00 00       	jmp    802912 <smalloc+0x358>
        va = start;
  802858:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80285b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80285e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802864:	01 d0                	add    %edx,%eax
  802866:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80286b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802872:	eb 5e                	jmp    8028d2 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802874:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802877:	89 d0                	mov    %edx,%eax
  802879:	01 c0                	add    %eax,%eax
  80287b:	01 d0                	add    %edx,%eax
  80287d:	c1 e0 02             	shl    $0x2,%eax
  802880:	05 48 60 80 00       	add    $0x806048,%eax
  802885:	8a 00                	mov    (%eax),%al
  802887:	84 c0                	test   %al,%al
  802889:	75 44                	jne    8028cf <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80288b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80288e:	89 d0                	mov    %edx,%eax
  802890:	01 c0                	add    %eax,%eax
  802892:	01 d0                	add    %edx,%eax
  802894:	c1 e0 02             	shl    $0x2,%eax
  802897:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80289d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8028a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028a5:	89 d0                	mov    %edx,%eax
  8028a7:	01 c0                	add    %eax,%eax
  8028a9:	01 d0                	add    %edx,%eax
  8028ab:	c1 e0 02             	shl    $0x2,%eax
  8028ae:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8028b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028b7:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8028b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028bc:	89 d0                	mov    %edx,%eax
  8028be:	01 c0                	add    %eax,%eax
  8028c0:	01 d0                	add    %edx,%eax
  8028c2:	c1 e0 02             	shl    $0x2,%eax
  8028c5:	05 48 60 80 00       	add    $0x806048,%eax
  8028ca:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8028cd:	eb 0c                	jmp    8028db <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8028cf:	ff 45 e0             	incl   -0x20(%ebp)
  8028d2:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8028d9:	7e 99                	jle    802874 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8028db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028de:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8028e2:	52                   	push   %edx
  8028e3:	50                   	push   %eax
  8028e4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8028e7:	ff 75 08             	pushl  0x8(%ebp)
  8028ea:	e8 de 0e 00 00       	call   8037cd <sys_create_shared_object>
  8028ef:	83 c4 10             	add    $0x10,%esp
  8028f2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8028f5:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8028f9:	75 07                	jne    802902 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8028fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802900:	eb 10                	jmp    802912 <smalloc+0x358>
    if (r < 0)
  802902:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802906:	79 07                	jns    80290f <smalloc+0x355>
        return NULL;
  802908:	b8 00 00 00 00       	mov    $0x0,%eax
  80290d:	eb 03                	jmp    802912 <smalloc+0x358>
    return (void*)va;
  80290f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802912:	c9                   	leave  
  802913:	c3                   	ret    

00802914 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802914:	55                   	push   %ebp
  802915:	89 e5                	mov    %esp,%ebp
  802917:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80291a:	e8 51 f4 ff ff       	call   801d70 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80291f:	83 ec 08             	sub    $0x8,%esp
  802922:	ff 75 0c             	pushl  0xc(%ebp)
  802925:	ff 75 08             	pushl  0x8(%ebp)
  802928:	e8 ca 0e 00 00       	call   8037f7 <sys_size_of_shared_object>
  80292d:	83 c4 10             	add    $0x10,%esp
  802930:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802933:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802937:	7f 0a                	jg     802943 <sget+0x2f>
        return NULL;
  802939:	b8 00 00 00 00       	mov    $0x0,%eax
  80293e:	e9 28 03 00 00       	jmp    802c6b <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802943:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80294a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80294d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802950:	01 d0                	add    %edx,%eax
  802952:	48                   	dec    %eax
  802953:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802956:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802959:	ba 00 00 00 00       	mov    $0x0,%edx
  80295e:	f7 75 d8             	divl   -0x28(%ebp)
  802961:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802964:	29 d0                	sub    %edx,%eax
  802966:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802969:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802970:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802977:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80297e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802985:	e9 85 00 00 00       	jmp    802a0f <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80298a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298d:	89 d0                	mov    %edx,%eax
  80298f:	01 c0                	add    %eax,%eax
  802991:	01 d0                	add    %edx,%eax
  802993:	c1 e0 02             	shl    $0x2,%eax
  802996:	05 48 20 81 00       	add    $0x812048,%eax
  80299b:	8a 00                	mov    (%eax),%al
  80299d:	84 c0                	test   %al,%al
  80299f:	74 20                	je     8029c1 <sget+0xad>
  8029a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a4:	89 d0                	mov    %edx,%eax
  8029a6:	01 c0                	add    %eax,%eax
  8029a8:	01 d0                	add    %edx,%eax
  8029aa:	c1 e0 02             	shl    $0x2,%eax
  8029ad:	05 44 20 81 00       	add    $0x812044,%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8029b7:	75 08                	jne    8029c1 <sget+0xad>
        {
            exactIdx = i;
  8029b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8029bf:	eb 5b                	jmp    802a1c <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8029c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c4:	89 d0                	mov    %edx,%eax
  8029c6:	01 c0                	add    %eax,%eax
  8029c8:	01 d0                	add    %edx,%eax
  8029ca:	c1 e0 02             	shl    $0x2,%eax
  8029cd:	05 48 20 81 00       	add    $0x812048,%eax
  8029d2:	8a 00                	mov    (%eax),%al
  8029d4:	84 c0                	test   %al,%al
  8029d6:	74 34                	je     802a0c <sget+0xf8>
  8029d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029db:	89 d0                	mov    %edx,%eax
  8029dd:	01 c0                	add    %eax,%eax
  8029df:	01 d0                	add    %edx,%eax
  8029e1:	c1 e0 02             	shl    $0x2,%eax
  8029e4:	05 44 20 81 00       	add    $0x812044,%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029ee:	76 1c                	jbe    802a0c <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8029f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029f3:	89 d0                	mov    %edx,%eax
  8029f5:	01 c0                	add    %eax,%eax
  8029f7:	01 d0                	add    %edx,%eax
  8029f9:	c1 e0 02             	shl    $0x2,%eax
  8029fc:	05 44 20 81 00       	add    $0x812044,%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802a06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802a0c:	ff 45 e8             	incl   -0x18(%ebp)
  802a0f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802a16:	0f 8e 6e ff ff ff    	jle    80298a <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802a1c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802a23:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802a27:	74 7d                	je     802aa6 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802a29:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a33:	89 d0                	mov    %edx,%eax
  802a35:	01 c0                	add    %eax,%eax
  802a37:	01 d0                	add    %edx,%eax
  802a39:	c1 e0 02             	shl    $0x2,%eax
  802a3c:	05 40 20 81 00       	add    $0x812040,%eax
  802a41:	8b 10                	mov    (%eax),%edx
  802a43:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a46:	01 d0                	add    %edx,%eax
  802a48:	48                   	dec    %eax
  802a49:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a4c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a54:	f7 75 b8             	divl   -0x48(%ebp)
  802a57:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a5a:	29 d0                	sub    %edx,%eax
  802a5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a62:	89 d0                	mov    %edx,%eax
  802a64:	01 c0                	add    %eax,%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	c1 e0 02             	shl    $0x2,%eax
  802a6b:	05 48 20 81 00       	add    $0x812048,%eax
  802a70:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802a73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a76:	89 d0                	mov    %edx,%eax
  802a78:	01 c0                	add    %eax,%eax
  802a7a:	01 d0                	add    %edx,%eax
  802a7c:	c1 e0 02             	shl    $0x2,%eax
  802a7f:	05 44 20 81 00       	add    $0x812044,%eax
  802a84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8d:	89 d0                	mov    %edx,%eax
  802a8f:	01 c0                	add    %eax,%eax
  802a91:	01 d0                	add    %edx,%eax
  802a93:	c1 e0 02             	shl    $0x2,%eax
  802a96:	05 40 20 81 00       	add    $0x812040,%eax
  802a9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa1:	e9 2d 01 00 00       	jmp    802bd3 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802aa6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802aaa:	0f 84 ce 00 00 00    	je     802b7e <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802ab0:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802ab7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aba:	89 d0                	mov    %edx,%eax
  802abc:	01 c0                	add    %eax,%eax
  802abe:	01 d0                	add    %edx,%eax
  802ac0:	c1 e0 02             	shl    $0x2,%eax
  802ac3:	05 40 20 81 00       	add    $0x812040,%eax
  802ac8:	8b 10                	mov    (%eax),%edx
  802aca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802acd:	01 d0                	add    %edx,%eax
  802acf:	48                   	dec    %eax
  802ad0:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802ad3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  802adb:	f7 75 c0             	divl   -0x40(%ebp)
  802ade:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ae1:	29 d0                	sub    %edx,%eax
  802ae3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802ae6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae9:	89 d0                	mov    %edx,%eax
  802aeb:	01 c0                	add    %eax,%eax
  802aed:	01 d0                	add    %edx,%eax
  802aef:	c1 e0 02             	shl    $0x2,%eax
  802af2:	05 44 20 81 00       	add    $0x812044,%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802afc:	75 47                	jne    802b45 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802afe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b01:	89 d0                	mov    %edx,%eax
  802b03:	01 c0                	add    %eax,%eax
  802b05:	01 d0                	add    %edx,%eax
  802b07:	c1 e0 02             	shl    $0x2,%eax
  802b0a:	05 48 20 81 00       	add    $0x812048,%eax
  802b0f:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802b12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b15:	89 d0                	mov    %edx,%eax
  802b17:	01 c0                	add    %eax,%eax
  802b19:	01 d0                	add    %edx,%eax
  802b1b:	c1 e0 02             	shl    $0x2,%eax
  802b1e:	05 44 20 81 00       	add    $0x812044,%eax
  802b23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802b29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2c:	89 d0                	mov    %edx,%eax
  802b2e:	01 c0                	add    %eax,%eax
  802b30:	01 d0                	add    %edx,%eax
  802b32:	c1 e0 02             	shl    $0x2,%eax
  802b35:	05 40 20 81 00       	add    $0x812040,%eax
  802b3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b40:	e9 8e 00 00 00       	jmp    802bd3 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802b45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b4b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802b4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b51:	89 d0                	mov    %edx,%eax
  802b53:	01 c0                	add    %eax,%eax
  802b55:	01 d0                	add    %edx,%eax
  802b57:	c1 e0 02             	shl    $0x2,%eax
  802b5a:	05 40 20 81 00       	add    $0x812040,%eax
  802b5f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802b67:	89 c2                	mov    %eax,%edx
  802b69:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b6c:	89 c8                	mov    %ecx,%eax
  802b6e:	01 c0                	add    %eax,%eax
  802b70:	01 c8                	add    %ecx,%eax
  802b72:	c1 e0 02             	shl    $0x2,%eax
  802b75:	05 44 20 81 00       	add    $0x812044,%eax
  802b7a:	89 10                	mov    %edx,(%eax)
  802b7c:	eb 55                	jmp    802bd3 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802b7e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b85:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802b8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8e:	01 d0                	add    %edx,%eax
  802b90:	48                   	dec    %eax
  802b91:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b97:	ba 00 00 00 00       	mov    $0x0,%edx
  802b9c:	f7 75 cc             	divl   -0x34(%ebp)
  802b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ba2:	29 d0                	sub    %edx,%eax
  802ba4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802ba7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802baa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bad:	01 d0                	add    %edx,%eax
  802baf:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802bb4:	76 0a                	jbe    802bc0 <sget+0x2ac>
            return NULL;
  802bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbb:	e9 ab 00 00 00       	jmp    802c6b <sget+0x357>
        va = start;
  802bc0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802bc6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802bc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bcc:	01 d0                	add    %edx,%eax
  802bce:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802bd3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802bda:	eb 5e                	jmp    802c3a <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802bdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bdf:	89 d0                	mov    %edx,%eax
  802be1:	01 c0                	add    %eax,%eax
  802be3:	01 d0                	add    %edx,%eax
  802be5:	c1 e0 02             	shl    $0x2,%eax
  802be8:	05 48 60 80 00       	add    $0x806048,%eax
  802bed:	8a 00                	mov    (%eax),%al
  802bef:	84 c0                	test   %al,%al
  802bf1:	75 44                	jne    802c37 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802bf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf6:	89 d0                	mov    %edx,%eax
  802bf8:	01 c0                	add    %eax,%eax
  802bfa:	01 d0                	add    %edx,%eax
  802bfc:	c1 e0 02             	shl    $0x2,%eax
  802bff:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802c05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c08:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802c0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c0d:	89 d0                	mov    %edx,%eax
  802c0f:	01 c0                	add    %eax,%eax
  802c11:	01 d0                	add    %edx,%eax
  802c13:	c1 e0 02             	shl    $0x2,%eax
  802c16:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802c1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c1f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802c21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c24:	89 d0                	mov    %edx,%eax
  802c26:	01 c0                	add    %eax,%eax
  802c28:	01 d0                	add    %edx,%eax
  802c2a:	c1 e0 02             	shl    $0x2,%eax
  802c2d:	05 48 60 80 00       	add    $0x806048,%eax
  802c32:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802c35:	eb 0c                	jmp    802c43 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c37:	ff 45 e0             	incl   -0x20(%ebp)
  802c3a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802c41:	7e 99                	jle    802bdc <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	83 ec 04             	sub    $0x4,%esp
  802c49:	50                   	push   %eax
  802c4a:	ff 75 0c             	pushl  0xc(%ebp)
  802c4d:	ff 75 08             	pushl  0x8(%ebp)
  802c50:	e8 bf 0b 00 00       	call   803814 <sys_get_shared_object>
  802c55:	83 c4 10             	add    $0x10,%esp
  802c58:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802c5b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c5f:	79 07                	jns    802c68 <sget+0x354>
        return NULL;
  802c61:	b8 00 00 00 00       	mov    $0x0,%eax
  802c66:	eb 03                	jmp    802c6b <sget+0x357>
    return (void*)va;
  802c68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802c6b:	c9                   	leave  
  802c6c:	c3                   	ret    

00802c6d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802c6d:	55                   	push   %ebp
  802c6e:	89 e5                	mov    %esp,%ebp
  802c70:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802c73:	e8 f8 f0 ff ff       	call   801d70 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802c78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7c:	75 13                	jne    802c91 <realloc+0x24>
		return malloc(new_size);
  802c7e:	83 ec 0c             	sub    $0xc,%esp
  802c81:	ff 75 0c             	pushl  0xc(%ebp)
  802c84:	e8 c4 f1 ff ff       	call   801e4d <malloc>
  802c89:	83 c4 10             	add    $0x10,%esp
  802c8c:	e9 f4 05 00 00       	jmp    803285 <realloc+0x618>
	if (new_size == 0)
  802c91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c95:	75 18                	jne    802caf <realloc+0x42>
	{
		free(virtual_address);
  802c97:	83 ec 0c             	sub    $0xc,%esp
  802c9a:	ff 75 08             	pushl  0x8(%ebp)
  802c9d:	e8 0b f5 ff ff       	call   8021ad <free>
  802ca2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  802caa:	e9 d6 05 00 00       	jmp    803285 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	79 74                	jns    802d30 <realloc+0xc3>
  802cbc:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802cc3:	77 6b                	ja     802d30 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802cc5:	83 ec 0c             	sub    $0xc,%esp
  802cc8:	ff 75 0c             	pushl  0xc(%ebp)
  802ccb:	e8 7d f1 ff ff       	call   801e4d <malloc>
  802cd0:	83 c4 10             	add    $0x10,%esp
  802cd3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802cd6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802cda:	75 0a                	jne    802ce6 <realloc+0x79>
			return NULL;
  802cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce1:	e9 9f 05 00 00       	jmp    803285 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802ce6:	83 ec 0c             	sub    $0xc,%esp
  802ce9:	ff 75 08             	pushl  0x8(%ebp)
  802cec:	e8 e0 11 00 00       	call   803ed1 <get_block_size>
  802cf1:	83 c4 10             	add    $0x10,%esp
  802cf4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802cf7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfd:	39 d0                	cmp    %edx,%eax
  802cff:	76 02                	jbe    802d03 <realloc+0x96>
  802d01:	89 d0                	mov    %edx,%eax
  802d03:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	ff 75 c0             	pushl  -0x40(%ebp)
  802d0c:	ff 75 08             	pushl  0x8(%ebp)
  802d0f:	ff 75 c8             	pushl  -0x38(%ebp)
  802d12:	e8 56 eb ff ff       	call   80186d <memmove>
  802d17:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802d1a:	83 ec 0c             	sub    $0xc,%esp
  802d1d:	ff 75 08             	pushl  0x8(%ebp)
  802d20:	e8 88 f4 ff ff       	call   8021ad <free>
  802d25:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802d28:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d2b:	e9 55 05 00 00       	jmp    803285 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802d30:	a1 30 61 83 00       	mov    0x836130,%eax
  802d35:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802d38:	72 09                	jb     802d43 <realloc+0xd6>
  802d3a:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802d41:	76 0a                	jbe    802d4d <realloc+0xe0>
		return NULL;
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
  802d48:	e9 38 05 00 00       	jmp    803285 <realloc+0x618>
	uint32 oldsz = 0;
  802d4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802d54:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d5b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802d62:	eb 50                	jmp    802db4 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802d64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d67:	89 d0                	mov    %edx,%eax
  802d69:	01 c0                	add    %eax,%eax
  802d6b:	01 d0                	add    %edx,%eax
  802d6d:	c1 e0 02             	shl    $0x2,%eax
  802d70:	05 48 60 80 00       	add    $0x806048,%eax
  802d75:	8a 00                	mov    (%eax),%al
  802d77:	84 c0                	test   %al,%al
  802d79:	74 36                	je     802db1 <realloc+0x144>
  802d7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d7e:	89 d0                	mov    %edx,%eax
  802d80:	01 c0                	add    %eax,%eax
  802d82:	01 d0                	add    %edx,%eax
  802d84:	c1 e0 02             	shl    $0x2,%eax
  802d87:	05 40 60 80 00       	add    $0x806040,%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802d91:	75 1e                	jne    802db1 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802d93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d96:	89 d0                	mov    %edx,%eax
  802d98:	01 c0                	add    %eax,%eax
  802d9a:	01 d0                	add    %edx,%eax
  802d9c:	c1 e0 02             	shl    $0x2,%eax
  802d9f:	05 44 60 80 00       	add    $0x806044,%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802daf:	eb 0c                	jmp    802dbd <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802db1:	ff 45 ec             	incl   -0x14(%ebp)
  802db4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802dbb:	7e a7                	jle    802d64 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802dbd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802dc1:	75 0a                	jne    802dcd <realloc+0x160>
		return NULL;
  802dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc8:	e9 b8 04 00 00       	jmp    803285 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802dcd:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dd7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dda:	01 d0                	add    %edx,%eax
  802ddc:	48                   	dec    %eax
  802ddd:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802de0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802de3:	ba 00 00 00 00       	mov    $0x0,%edx
  802de8:	f7 75 bc             	divl   -0x44(%ebp)
  802deb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802dee:	29 d0                	sub    %edx,%eax
  802df0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802df3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802df6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802df9:	75 08                	jne    802e03 <realloc+0x196>
		return virtual_address;
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	e9 82 04 00 00       	jmp    803285 <realloc+0x618>
	if (req < oldsz)
  802e03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e09:	0f 83 cd 02 00 00    	jae    8030dc <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802e15:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802e18:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e1b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e1e:	01 d0                	add    %edx,%eax
  802e20:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802e23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e26:	89 d0                	mov    %edx,%eax
  802e28:	01 c0                	add    %eax,%eax
  802e2a:	01 d0                	add    %edx,%eax
  802e2c:	c1 e0 02             	shl    $0x2,%eax
  802e2f:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802e35:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e38:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802e3a:	83 ec 08             	sub    $0x8,%esp
  802e3d:	ff 75 b0             	pushl  -0x50(%ebp)
  802e40:	ff 75 ac             	pushl  -0x54(%ebp)
  802e43:	e8 e3 0c 00 00       	call   803b2b <sys_free_user_mem>
  802e48:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802e4b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802e59:	eb 64                	jmp    802ebf <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802e5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e5e:	89 d0                	mov    %edx,%eax
  802e60:	01 c0                	add    %eax,%eax
  802e62:	01 d0                	add    %edx,%eax
  802e64:	c1 e0 02             	shl    $0x2,%eax
  802e67:	05 48 20 81 00       	add    $0x812048,%eax
  802e6c:	8a 00                	mov    (%eax),%al
  802e6e:	84 c0                	test   %al,%al
  802e70:	75 4a                	jne    802ebc <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e75:	89 d0                	mov    %edx,%eax
  802e77:	01 c0                	add    %eax,%eax
  802e79:	01 d0                	add    %edx,%eax
  802e7b:	c1 e0 02             	shl    $0x2,%eax
  802e7e:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802e84:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e87:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802e89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e8c:	89 d0                	mov    %edx,%eax
  802e8e:	01 c0                	add    %eax,%eax
  802e90:	01 d0                	add    %edx,%eax
  802e92:	c1 e0 02             	shl    $0x2,%eax
  802e95:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802e9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e9e:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ea3:	89 d0                	mov    %edx,%eax
  802ea5:	01 c0                	add    %eax,%eax
  802ea7:	01 d0                	add    %edx,%eax
  802ea9:	c1 e0 02             	shl    $0x2,%eax
  802eac:	05 48 20 81 00       	add    $0x812048,%eax
  802eb1:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802eb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802eba:	eb 0c                	jmp    802ec8 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ebc:	ff 45 e4             	incl   -0x1c(%ebp)
  802ebf:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802ec6:	7e 93                	jle    802e5b <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802ec8:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802ecc:	0f 84 8d 01 00 00    	je     80305f <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ed2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802ed9:	e9 74 01 00 00       	jmp    803052 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ee4:	0f 84 64 01 00 00    	je     80304e <realloc+0x3e1>
				if (uhp_frees[k].free)
  802eea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eed:	89 d0                	mov    %edx,%eax
  802eef:	01 c0                	add    %eax,%eax
  802ef1:	01 d0                	add    %edx,%eax
  802ef3:	c1 e0 02             	shl    $0x2,%eax
  802ef6:	05 48 20 81 00       	add    $0x812048,%eax
  802efb:	8a 00                	mov    (%eax),%al
  802efd:	84 c0                	test   %al,%al
  802eff:	0f 84 4a 01 00 00    	je     80304f <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802f05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f08:	89 d0                	mov    %edx,%eax
  802f0a:	01 c0                	add    %eax,%eax
  802f0c:	01 d0                	add    %edx,%eax
  802f0e:	c1 e0 02             	shl    $0x2,%eax
  802f11:	05 40 20 81 00       	add    $0x812040,%eax
  802f16:	8b 08                	mov    (%eax),%ecx
  802f18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f1b:	89 d0                	mov    %edx,%eax
  802f1d:	01 c0                	add    %eax,%eax
  802f1f:	01 d0                	add    %edx,%eax
  802f21:	c1 e0 02             	shl    $0x2,%eax
  802f24:	05 44 20 81 00       	add    $0x812044,%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	01 c1                	add    %eax,%ecx
  802f2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f30:	89 d0                	mov    %edx,%eax
  802f32:	01 c0                	add    %eax,%eax
  802f34:	01 d0                	add    %edx,%eax
  802f36:	c1 e0 02             	shl    $0x2,%eax
  802f39:	05 40 20 81 00       	add    $0x812040,%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	39 c1                	cmp    %eax,%ecx
  802f42:	75 7a                	jne    802fbe <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802f44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f47:	89 d0                	mov    %edx,%eax
  802f49:	01 c0                	add    %eax,%eax
  802f4b:	01 d0                	add    %edx,%eax
  802f4d:	c1 e0 02             	shl    $0x2,%eax
  802f50:	05 40 20 81 00       	add    $0x812040,%eax
  802f55:	8b 10                	mov    (%eax),%edx
  802f57:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802f5a:	89 c8                	mov    %ecx,%eax
  802f5c:	01 c0                	add    %eax,%eax
  802f5e:	01 c8                	add    %ecx,%eax
  802f60:	c1 e0 02             	shl    $0x2,%eax
  802f63:	05 40 20 81 00       	add    $0x812040,%eax
  802f68:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802f6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f6d:	89 d0                	mov    %edx,%eax
  802f6f:	01 c0                	add    %eax,%eax
  802f71:	01 d0                	add    %edx,%eax
  802f73:	c1 e0 02             	shl    $0x2,%eax
  802f76:	05 44 20 81 00       	add    $0x812044,%eax
  802f7b:	8b 08                	mov    (%eax),%ecx
  802f7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f80:	89 d0                	mov    %edx,%eax
  802f82:	01 c0                	add    %eax,%eax
  802f84:	01 d0                	add    %edx,%eax
  802f86:	c1 e0 02             	shl    $0x2,%eax
  802f89:	05 44 20 81 00       	add    $0x812044,%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	01 c1                	add    %eax,%ecx
  802f92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f95:	89 d0                	mov    %edx,%eax
  802f97:	01 c0                	add    %eax,%eax
  802f99:	01 d0                	add    %edx,%eax
  802f9b:	c1 e0 02             	shl    $0x2,%eax
  802f9e:	05 44 20 81 00       	add    $0x812044,%eax
  802fa3:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802fa5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa8:	89 d0                	mov    %edx,%eax
  802faa:	01 c0                	add    %eax,%eax
  802fac:	01 d0                	add    %edx,%eax
  802fae:	c1 e0 02             	shl    $0x2,%eax
  802fb1:	05 48 20 81 00       	add    $0x812048,%eax
  802fb6:	c6 00 00             	movb   $0x0,(%eax)
  802fb9:	e9 91 00 00 00       	jmp    80304f <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802fbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc1:	89 d0                	mov    %edx,%eax
  802fc3:	01 c0                	add    %eax,%eax
  802fc5:	01 d0                	add    %edx,%eax
  802fc7:	c1 e0 02             	shl    $0x2,%eax
  802fca:	05 40 20 81 00       	add    $0x812040,%eax
  802fcf:	8b 08                	mov    (%eax),%ecx
  802fd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd4:	89 d0                	mov    %edx,%eax
  802fd6:	01 c0                	add    %eax,%eax
  802fd8:	01 d0                	add    %edx,%eax
  802fda:	c1 e0 02             	shl    $0x2,%eax
  802fdd:	05 44 20 81 00       	add    $0x812044,%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	01 c1                	add    %eax,%ecx
  802fe6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fe9:	89 d0                	mov    %edx,%eax
  802feb:	01 c0                	add    %eax,%eax
  802fed:	01 d0                	add    %edx,%eax
  802fef:	c1 e0 02             	shl    $0x2,%eax
  802ff2:	05 40 20 81 00       	add    $0x812040,%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	39 c1                	cmp    %eax,%ecx
  802ffb:	75 52                	jne    80304f <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802ffd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803000:	89 d0                	mov    %edx,%eax
  803002:	01 c0                	add    %eax,%eax
  803004:	01 d0                	add    %edx,%eax
  803006:	c1 e0 02             	shl    $0x2,%eax
  803009:	05 44 20 81 00       	add    $0x812044,%eax
  80300e:	8b 08                	mov    (%eax),%ecx
  803010:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803013:	89 d0                	mov    %edx,%eax
  803015:	01 c0                	add    %eax,%eax
  803017:	01 d0                	add    %edx,%eax
  803019:	c1 e0 02             	shl    $0x2,%eax
  80301c:	05 44 20 81 00       	add    $0x812044,%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	01 c1                	add    %eax,%ecx
  803025:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803028:	89 d0                	mov    %edx,%eax
  80302a:	01 c0                	add    %eax,%eax
  80302c:	01 d0                	add    %edx,%eax
  80302e:	c1 e0 02             	shl    $0x2,%eax
  803031:	05 44 20 81 00       	add    $0x812044,%eax
  803036:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  803038:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80303b:	89 d0                	mov    %edx,%eax
  80303d:	01 c0                	add    %eax,%eax
  80303f:	01 d0                	add    %edx,%eax
  803041:	c1 e0 02             	shl    $0x2,%eax
  803044:	05 48 20 81 00       	add    $0x812048,%eax
  803049:	c6 00 00             	movb   $0x0,(%eax)
  80304c:	eb 01                	jmp    80304f <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  80304e:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80304f:	ff 45 e0             	incl   -0x20(%ebp)
  803052:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803059:	0f 8e 7f fe ff ff    	jle    802ede <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  80305f:	a1 30 61 83 00       	mov    0x836130,%eax
  803064:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803067:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80306e:	eb 53                	jmp    8030c3 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  803070:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803073:	89 d0                	mov    %edx,%eax
  803075:	01 c0                	add    %eax,%eax
  803077:	01 d0                	add    %edx,%eax
  803079:	c1 e0 02             	shl    $0x2,%eax
  80307c:	05 48 60 80 00       	add    $0x806048,%eax
  803081:	8a 00                	mov    (%eax),%al
  803083:	84 c0                	test   %al,%al
  803085:	74 39                	je     8030c0 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803087:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80308a:	89 d0                	mov    %edx,%eax
  80308c:	01 c0                	add    %eax,%eax
  80308e:	01 d0                	add    %edx,%eax
  803090:	c1 e0 02             	shl    $0x2,%eax
  803093:	05 40 60 80 00       	add    $0x806040,%eax
  803098:	8b 08                	mov    (%eax),%ecx
  80309a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80309d:	89 d0                	mov    %edx,%eax
  80309f:	01 c0                	add    %eax,%eax
  8030a1:	01 d0                	add    %edx,%eax
  8030a3:	c1 e0 02             	shl    $0x2,%eax
  8030a6:	05 44 60 80 00       	add    $0x806044,%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	01 c8                	add    %ecx,%eax
  8030af:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8030b2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030b5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8030b8:	76 06                	jbe    8030c0 <realloc+0x453>
  8030ba:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8030c0:	ff 45 d8             	incl   -0x28(%ebp)
  8030c3:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8030ca:	7e a4                	jle    803070 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8030cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cf:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	e9 a9 01 00 00       	jmp    803285 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8030dc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	01 d0                	add    %edx,%eax
  8030e4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8030e7:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8030ee:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8030f5:	eb 57                	jmp    80314e <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8030f7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8030fa:	89 d0                	mov    %edx,%eax
  8030fc:	01 c0                	add    %eax,%eax
  8030fe:	01 d0                	add    %edx,%eax
  803100:	c1 e0 02             	shl    $0x2,%eax
  803103:	05 48 20 81 00       	add    $0x812048,%eax
  803108:	8a 00                	mov    (%eax),%al
  80310a:	84 c0                	test   %al,%al
  80310c:	74 3d                	je     80314b <realloc+0x4de>
  80310e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803111:	89 d0                	mov    %edx,%eax
  803113:	01 c0                	add    %eax,%eax
  803115:	01 d0                	add    %edx,%eax
  803117:	c1 e0 02             	shl    $0x2,%eax
  80311a:	05 40 20 81 00       	add    $0x812040,%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803124:	75 25                	jne    80314b <realloc+0x4de>
  803126:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803129:	89 d0                	mov    %edx,%eax
  80312b:	01 c0                	add    %eax,%eax
  80312d:	01 d0                	add    %edx,%eax
  80312f:	c1 e0 02             	shl    $0x2,%eax
  803132:	05 44 20 81 00       	add    $0x812044,%eax
  803137:	8b 10                	mov    (%eax),%edx
  803139:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80313c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80313f:	39 c2                	cmp    %eax,%edx
  803141:	72 08                	jb     80314b <realloc+0x4de>
		{
			adjIdx = j; break;
  803143:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803146:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803149:	eb 0c                	jmp    803157 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80314b:	ff 45 d0             	incl   -0x30(%ebp)
  80314e:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  803155:	7e a0                	jle    8030f7 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  803157:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  80315b:	0f 84 d6 00 00 00    	je     803237 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  803161:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803164:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803167:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  80316a:	83 ec 08             	sub    $0x8,%esp
  80316d:	ff 75 a0             	pushl  -0x60(%ebp)
  803170:	ff 75 a4             	pushl  -0x5c(%ebp)
  803173:	e8 cf 09 00 00       	call   803b47 <sys_allocate_user_mem>
  803178:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  80317b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317e:	89 d0                	mov    %edx,%eax
  803180:	01 c0                	add    %eax,%eax
  803182:	01 d0                	add    %edx,%eax
  803184:	c1 e0 02             	shl    $0x2,%eax
  803187:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  80318d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803190:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  803192:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803195:	89 d0                	mov    %edx,%eax
  803197:	01 c0                	add    %eax,%eax
  803199:	01 d0                	add    %edx,%eax
  80319b:	c1 e0 02             	shl    $0x2,%eax
  80319e:	05 40 20 81 00       	add    $0x812040,%eax
  8031a3:	8b 10                	mov    (%eax),%edx
  8031a5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8031a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8031ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031ae:	89 d0                	mov    %edx,%eax
  8031b0:	01 c0                	add    %eax,%eax
  8031b2:	01 d0                	add    %edx,%eax
  8031b4:	c1 e0 02             	shl    $0x2,%eax
  8031b7:	05 40 20 81 00       	add    $0x812040,%eax
  8031bc:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8031be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031c1:	89 d0                	mov    %edx,%eax
  8031c3:	01 c0                	add    %eax,%eax
  8031c5:	01 d0                	add    %edx,%eax
  8031c7:	c1 e0 02             	shl    $0x2,%eax
  8031ca:	05 44 20 81 00       	add    $0x812044,%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	2b 45 a0             	sub    -0x60(%ebp),%eax
  8031d4:	89 c2                	mov    %eax,%edx
  8031d6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8031d9:	89 c8                	mov    %ecx,%eax
  8031db:	01 c0                	add    %eax,%eax
  8031dd:	01 c8                	add    %ecx,%eax
  8031df:	c1 e0 02             	shl    $0x2,%eax
  8031e2:	05 44 20 81 00       	add    $0x812044,%eax
  8031e7:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  8031e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031ec:	89 d0                	mov    %edx,%eax
  8031ee:	01 c0                	add    %eax,%eax
  8031f0:	01 d0                	add    %edx,%eax
  8031f2:	c1 e0 02             	shl    $0x2,%eax
  8031f5:	05 44 20 81 00       	add    $0x812044,%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	75 14                	jne    803214 <realloc+0x5a7>
  803200:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803203:	89 d0                	mov    %edx,%eax
  803205:	01 c0                	add    %eax,%eax
  803207:	01 d0                	add    %edx,%eax
  803209:	c1 e0 02             	shl    $0x2,%eax
  80320c:	05 48 20 81 00       	add    $0x812048,%eax
  803211:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  803214:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803217:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80321a:	01 c2                	add    %eax,%edx
  80321c:	a1 88 60 83 00       	mov    0x836088,%eax
  803221:	39 c2                	cmp    %eax,%edx
  803223:	76 0d                	jbe    803232 <realloc+0x5c5>
  803225:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803228:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80322b:	01 d0                	add    %edx,%eax
  80322d:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	eb 4e                	jmp    803285 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  803237:	83 ec 0c             	sub    $0xc,%esp
  80323a:	ff 75 0c             	pushl  0xc(%ebp)
  80323d:	e8 0b ec ff ff       	call   801e4d <malloc>
  803242:	83 c4 10             	add    $0x10,%esp
  803245:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  803248:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80324c:	75 07                	jne    803255 <realloc+0x5e8>
		return NULL;
  80324e:	b8 00 00 00 00       	mov    $0x0,%eax
  803253:	eb 30                	jmp    803285 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  803255:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803258:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80325b:	39 d0                	cmp    %edx,%eax
  80325d:	76 02                	jbe    803261 <realloc+0x5f4>
  80325f:	89 d0                	mov    %edx,%eax
  803261:	8b 55 9c             	mov    -0x64(%ebp),%edx
  803264:	83 ec 04             	sub    $0x4,%esp
  803267:	50                   	push   %eax
  803268:	52                   	push   %edx
  803269:	ff 75 cc             	pushl  -0x34(%ebp)
  80326c:	e8 cf 06 00 00       	call   803940 <sys_move_user_mem>
  803271:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  803274:	83 ec 0c             	sub    $0xc,%esp
  803277:	ff 75 08             	pushl  0x8(%ebp)
  80327a:	e8 2e ef ff ff       	call   8021ad <free>
  80327f:	83 c4 10             	add    $0x10,%esp
	return newptr;
  803282:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  803285:	c9                   	leave  
  803286:	c3                   	ret    

00803287 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803287:	55                   	push   %ebp
  803288:	89 e5                	mov    %esp,%ebp
  80328a:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  803293:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803297:	0f 84 33 03 00 00    	je     8035d0 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  80329d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a0:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8032a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8032a8:	83 ec 08             	sub    $0x8,%esp
  8032ab:	ff 75 08             	pushl  0x8(%ebp)
  8032ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8032b1:	e8 7d 05 00 00       	call   803833 <sys_delete_shared_object>
  8032b6:	83 c4 10             	add    $0x10,%esp
  8032b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8032bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032c0:	0f 88 0d 03 00 00    	js     8035d3 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8032c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032cd:	e9 ef 02 00 00       	jmp    8035c1 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8032d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d5:	89 d0                	mov    %edx,%eax
  8032d7:	01 c0                	add    %eax,%eax
  8032d9:	01 d0                	add    %edx,%eax
  8032db:	c1 e0 02             	shl    $0x2,%eax
  8032de:	05 48 60 80 00       	add    $0x806048,%eax
  8032e3:	8a 00                	mov    (%eax),%al
  8032e5:	84 c0                	test   %al,%al
  8032e7:	0f 84 d1 02 00 00    	je     8035be <sfree+0x337>
  8032ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f0:	89 d0                	mov    %edx,%eax
  8032f2:	01 c0                	add    %eax,%eax
  8032f4:	01 d0                	add    %edx,%eax
  8032f6:	c1 e0 02             	shl    $0x2,%eax
  8032f9:	05 40 60 80 00       	add    $0x806040,%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803303:	0f 85 b5 02 00 00    	jne    8035be <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803309:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80330c:	89 d0                	mov    %edx,%eax
  80330e:	01 c0                	add    %eax,%eax
  803310:	01 d0                	add    %edx,%eax
  803312:	c1 e0 02             	shl    $0x2,%eax
  803315:	05 44 60 80 00       	add    $0x806044,%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  80331f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803322:	89 d0                	mov    %edx,%eax
  803324:	01 c0                	add    %eax,%eax
  803326:	01 d0                	add    %edx,%eax
  803328:	c1 e0 02             	shl    $0x2,%eax
  80332b:	05 48 60 80 00       	add    $0x806048,%eax
  803330:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  803333:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80333a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803341:	eb 64                	jmp    8033a7 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  803343:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803346:	89 d0                	mov    %edx,%eax
  803348:	01 c0                	add    %eax,%eax
  80334a:	01 d0                	add    %edx,%eax
  80334c:	c1 e0 02             	shl    $0x2,%eax
  80334f:	05 48 20 81 00       	add    $0x812048,%eax
  803354:	8a 00                	mov    (%eax),%al
  803356:	84 c0                	test   %al,%al
  803358:	75 4a                	jne    8033a4 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  80335a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80335d:	89 d0                	mov    %edx,%eax
  80335f:	01 c0                	add    %eax,%eax
  803361:	01 d0                	add    %edx,%eax
  803363:	c1 e0 02             	shl    $0x2,%eax
  803366:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  80336c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336f:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  803371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803374:	89 d0                	mov    %edx,%eax
  803376:	01 c0                	add    %eax,%eax
  803378:	01 d0                	add    %edx,%eax
  80337a:	c1 e0 02             	shl    $0x2,%eax
  80337d:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  803383:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803386:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  803388:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80338b:	89 d0                	mov    %edx,%eax
  80338d:	01 c0                	add    %eax,%eax
  80338f:	01 d0                	add    %edx,%eax
  803391:	c1 e0 02             	shl    $0x2,%eax
  803394:	05 48 20 81 00       	add    $0x812048,%eax
  803399:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  80339c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  8033a2:	eb 0c                	jmp    8033b0 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8033a4:	ff 45 ec             	incl   -0x14(%ebp)
  8033a7:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8033ae:	7e 93                	jle    803343 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  8033b0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8033b4:	0f 84 8d 01 00 00    	je     803547 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8033ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8033c1:	e9 74 01 00 00       	jmp    80353a <sfree+0x2b3>
				{
					if (k == fidx) continue;
  8033c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033cc:	0f 84 64 01 00 00    	je     803536 <sfree+0x2af>
					if (uhp_frees[k].free)
  8033d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d5:	89 d0                	mov    %edx,%eax
  8033d7:	01 c0                	add    %eax,%eax
  8033d9:	01 d0                	add    %edx,%eax
  8033db:	c1 e0 02             	shl    $0x2,%eax
  8033de:	05 48 20 81 00       	add    $0x812048,%eax
  8033e3:	8a 00                	mov    (%eax),%al
  8033e5:	84 c0                	test   %al,%al
  8033e7:	0f 84 4a 01 00 00    	je     803537 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8033ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f0:	89 d0                	mov    %edx,%eax
  8033f2:	01 c0                	add    %eax,%eax
  8033f4:	01 d0                	add    %edx,%eax
  8033f6:	c1 e0 02             	shl    $0x2,%eax
  8033f9:	05 40 20 81 00       	add    $0x812040,%eax
  8033fe:	8b 08                	mov    (%eax),%ecx
  803400:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803403:	89 d0                	mov    %edx,%eax
  803405:	01 c0                	add    %eax,%eax
  803407:	01 d0                	add    %edx,%eax
  803409:	c1 e0 02             	shl    $0x2,%eax
  80340c:	05 44 20 81 00       	add    $0x812044,%eax
  803411:	8b 00                	mov    (%eax),%eax
  803413:	01 c1                	add    %eax,%ecx
  803415:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803418:	89 d0                	mov    %edx,%eax
  80341a:	01 c0                	add    %eax,%eax
  80341c:	01 d0                	add    %edx,%eax
  80341e:	c1 e0 02             	shl    $0x2,%eax
  803421:	05 40 20 81 00       	add    $0x812040,%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	39 c1                	cmp    %eax,%ecx
  80342a:	75 7a                	jne    8034a6 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  80342c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342f:	89 d0                	mov    %edx,%eax
  803431:	01 c0                	add    %eax,%eax
  803433:	01 d0                	add    %edx,%eax
  803435:	c1 e0 02             	shl    $0x2,%eax
  803438:	05 40 20 81 00       	add    $0x812040,%eax
  80343d:	8b 10                	mov    (%eax),%edx
  80343f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803442:	89 c8                	mov    %ecx,%eax
  803444:	01 c0                	add    %eax,%eax
  803446:	01 c8                	add    %ecx,%eax
  803448:	c1 e0 02             	shl    $0x2,%eax
  80344b:	05 40 20 81 00       	add    $0x812040,%eax
  803450:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  803452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803455:	89 d0                	mov    %edx,%eax
  803457:	01 c0                	add    %eax,%eax
  803459:	01 d0                	add    %edx,%eax
  80345b:	c1 e0 02             	shl    $0x2,%eax
  80345e:	05 44 20 81 00       	add    $0x812044,%eax
  803463:	8b 08                	mov    (%eax),%ecx
  803465:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803468:	89 d0                	mov    %edx,%eax
  80346a:	01 c0                	add    %eax,%eax
  80346c:	01 d0                	add    %edx,%eax
  80346e:	c1 e0 02             	shl    $0x2,%eax
  803471:	05 44 20 81 00       	add    $0x812044,%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	01 c1                	add    %eax,%ecx
  80347a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80347d:	89 d0                	mov    %edx,%eax
  80347f:	01 c0                	add    %eax,%eax
  803481:	01 d0                	add    %edx,%eax
  803483:	c1 e0 02             	shl    $0x2,%eax
  803486:	05 44 20 81 00       	add    $0x812044,%eax
  80348b:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  80348d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803490:	89 d0                	mov    %edx,%eax
  803492:	01 c0                	add    %eax,%eax
  803494:	01 d0                	add    %edx,%eax
  803496:	c1 e0 02             	shl    $0x2,%eax
  803499:	05 48 20 81 00       	add    $0x812048,%eax
  80349e:	c6 00 00             	movb   $0x0,(%eax)
  8034a1:	e9 91 00 00 00       	jmp    803537 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8034a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a9:	89 d0                	mov    %edx,%eax
  8034ab:	01 c0                	add    %eax,%eax
  8034ad:	01 d0                	add    %edx,%eax
  8034af:	c1 e0 02             	shl    $0x2,%eax
  8034b2:	05 40 20 81 00       	add    $0x812040,%eax
  8034b7:	8b 08                	mov    (%eax),%ecx
  8034b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034bc:	89 d0                	mov    %edx,%eax
  8034be:	01 c0                	add    %eax,%eax
  8034c0:	01 d0                	add    %edx,%eax
  8034c2:	c1 e0 02             	shl    $0x2,%eax
  8034c5:	05 44 20 81 00       	add    $0x812044,%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	01 c1                	add    %eax,%ecx
  8034ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034d1:	89 d0                	mov    %edx,%eax
  8034d3:	01 c0                	add    %eax,%eax
  8034d5:	01 d0                	add    %edx,%eax
  8034d7:	c1 e0 02             	shl    $0x2,%eax
  8034da:	05 40 20 81 00       	add    $0x812040,%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	39 c1                	cmp    %eax,%ecx
  8034e3:	75 52                	jne    803537 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  8034e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034e8:	89 d0                	mov    %edx,%eax
  8034ea:	01 c0                	add    %eax,%eax
  8034ec:	01 d0                	add    %edx,%eax
  8034ee:	c1 e0 02             	shl    $0x2,%eax
  8034f1:	05 44 20 81 00       	add    $0x812044,%eax
  8034f6:	8b 08                	mov    (%eax),%ecx
  8034f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034fb:	89 d0                	mov    %edx,%eax
  8034fd:	01 c0                	add    %eax,%eax
  8034ff:	01 d0                	add    %edx,%eax
  803501:	c1 e0 02             	shl    $0x2,%eax
  803504:	05 44 20 81 00       	add    $0x812044,%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	01 c1                	add    %eax,%ecx
  80350d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803510:	89 d0                	mov    %edx,%eax
  803512:	01 c0                	add    %eax,%eax
  803514:	01 d0                	add    %edx,%eax
  803516:	c1 e0 02             	shl    $0x2,%eax
  803519:	05 44 20 81 00       	add    $0x812044,%eax
  80351e:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803520:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803523:	89 d0                	mov    %edx,%eax
  803525:	01 c0                	add    %eax,%eax
  803527:	01 d0                	add    %edx,%eax
  803529:	c1 e0 02             	shl    $0x2,%eax
  80352c:	05 48 20 81 00       	add    $0x812048,%eax
  803531:	c6 00 00             	movb   $0x0,(%eax)
  803534:	eb 01                	jmp    803537 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  803536:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803537:	ff 45 e8             	incl   -0x18(%ebp)
  80353a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803541:	0f 8e 7f fe ff ff    	jle    8033c6 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803547:	a1 30 61 83 00       	mov    0x836130,%eax
  80354c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80354f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803556:	eb 53                	jmp    8035ab <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803558:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80355b:	89 d0                	mov    %edx,%eax
  80355d:	01 c0                	add    %eax,%eax
  80355f:	01 d0                	add    %edx,%eax
  803561:	c1 e0 02             	shl    $0x2,%eax
  803564:	05 48 60 80 00       	add    $0x806048,%eax
  803569:	8a 00                	mov    (%eax),%al
  80356b:	84 c0                	test   %al,%al
  80356d:	74 39                	je     8035a8 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80356f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803572:	89 d0                	mov    %edx,%eax
  803574:	01 c0                	add    %eax,%eax
  803576:	01 d0                	add    %edx,%eax
  803578:	c1 e0 02             	shl    $0x2,%eax
  80357b:	05 40 60 80 00       	add    $0x806040,%eax
  803580:	8b 08                	mov    (%eax),%ecx
  803582:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803585:	89 d0                	mov    %edx,%eax
  803587:	01 c0                	add    %eax,%eax
  803589:	01 d0                	add    %edx,%eax
  80358b:	c1 e0 02             	shl    $0x2,%eax
  80358e:	05 44 60 80 00       	add    $0x806044,%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	01 c8                	add    %ecx,%eax
  803597:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  80359a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80359d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035a0:	76 06                	jbe    8035a8 <sfree+0x321>
  8035a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8035a8:	ff 45 e0             	incl   -0x20(%ebp)
  8035ab:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8035b2:	7e a4                	jle    803558 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  8035b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b7:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  8035bc:	eb 16                	jmp    8035d4 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8035be:	ff 45 f4             	incl   -0xc(%ebp)
  8035c1:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  8035c8:	0f 8e 04 fd ff ff    	jle    8032d2 <sfree+0x4b>
  8035ce:	eb 04                	jmp    8035d4 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  8035d0:	90                   	nop
  8035d1:	eb 01                	jmp    8035d4 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  8035d3:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
  8035d9:	57                   	push   %edi
  8035da:	56                   	push   %esi
  8035db:	53                   	push   %ebx
  8035dc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8035e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8035eb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8035ee:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8035f1:	cd 30                	int    $0x30
  8035f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8035f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8035f9:	83 c4 10             	add    $0x10,%esp
  8035fc:	5b                   	pop    %ebx
  8035fd:	5e                   	pop    %esi
  8035fe:	5f                   	pop    %edi
  8035ff:	5d                   	pop    %ebp
  803600:	c3                   	ret    

00803601 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803601:	55                   	push   %ebp
  803602:	89 e5                	mov    %esp,%ebp
  803604:	83 ec 04             	sub    $0x4,%esp
  803607:	8b 45 10             	mov    0x10(%ebp),%eax
  80360a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80360d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803610:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	6a 00                	push   $0x0
  803619:	51                   	push   %ecx
  80361a:	52                   	push   %edx
  80361b:	ff 75 0c             	pushl  0xc(%ebp)
  80361e:	50                   	push   %eax
  80361f:	6a 00                	push   $0x0
  803621:	e8 b0 ff ff ff       	call   8035d6 <syscall>
  803626:	83 c4 18             	add    $0x18,%esp
}
  803629:	90                   	nop
  80362a:	c9                   	leave  
  80362b:	c3                   	ret    

0080362c <sys_cgetc>:

int
sys_cgetc(void)
{
  80362c:	55                   	push   %ebp
  80362d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80362f:	6a 00                	push   $0x0
  803631:	6a 00                	push   $0x0
  803633:	6a 00                	push   $0x0
  803635:	6a 00                	push   $0x0
  803637:	6a 00                	push   $0x0
  803639:	6a 02                	push   $0x2
  80363b:	e8 96 ff ff ff       	call   8035d6 <syscall>
  803640:	83 c4 18             	add    $0x18,%esp
}
  803643:	c9                   	leave  
  803644:	c3                   	ret    

00803645 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803645:	55                   	push   %ebp
  803646:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803648:	6a 00                	push   $0x0
  80364a:	6a 00                	push   $0x0
  80364c:	6a 00                	push   $0x0
  80364e:	6a 00                	push   $0x0
  803650:	6a 00                	push   $0x0
  803652:	6a 03                	push   $0x3
  803654:	e8 7d ff ff ff       	call   8035d6 <syscall>
  803659:	83 c4 18             	add    $0x18,%esp
}
  80365c:	90                   	nop
  80365d:	c9                   	leave  
  80365e:	c3                   	ret    

0080365f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80365f:	55                   	push   %ebp
  803660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803662:	6a 00                	push   $0x0
  803664:	6a 00                	push   $0x0
  803666:	6a 00                	push   $0x0
  803668:	6a 00                	push   $0x0
  80366a:	6a 00                	push   $0x0
  80366c:	6a 04                	push   $0x4
  80366e:	e8 63 ff ff ff       	call   8035d6 <syscall>
  803673:	83 c4 18             	add    $0x18,%esp
}
  803676:	90                   	nop
  803677:	c9                   	leave  
  803678:	c3                   	ret    

00803679 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803679:	55                   	push   %ebp
  80367a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80367c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80367f:	8b 45 08             	mov    0x8(%ebp),%eax
  803682:	6a 00                	push   $0x0
  803684:	6a 00                	push   $0x0
  803686:	6a 00                	push   $0x0
  803688:	52                   	push   %edx
  803689:	50                   	push   %eax
  80368a:	6a 08                	push   $0x8
  80368c:	e8 45 ff ff ff       	call   8035d6 <syscall>
  803691:	83 c4 18             	add    $0x18,%esp
}
  803694:	c9                   	leave  
  803695:	c3                   	ret    

00803696 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803696:	55                   	push   %ebp
  803697:	89 e5                	mov    %esp,%ebp
  803699:	56                   	push   %esi
  80369a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80369b:	8b 75 18             	mov    0x18(%ebp),%esi
  80369e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8036a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	56                   	push   %esi
  8036ab:	53                   	push   %ebx
  8036ac:	51                   	push   %ecx
  8036ad:	52                   	push   %edx
  8036ae:	50                   	push   %eax
  8036af:	6a 09                	push   $0x9
  8036b1:	e8 20 ff ff ff       	call   8035d6 <syscall>
  8036b6:	83 c4 18             	add    $0x18,%esp
}
  8036b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8036bc:	5b                   	pop    %ebx
  8036bd:	5e                   	pop    %esi
  8036be:	5d                   	pop    %ebp
  8036bf:	c3                   	ret    

008036c0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8036c0:	55                   	push   %ebp
  8036c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8036c3:	6a 00                	push   $0x0
  8036c5:	6a 00                	push   $0x0
  8036c7:	6a 00                	push   $0x0
  8036c9:	6a 00                	push   $0x0
  8036cb:	ff 75 08             	pushl  0x8(%ebp)
  8036ce:	6a 0a                	push   $0xa
  8036d0:	e8 01 ff ff ff       	call   8035d6 <syscall>
  8036d5:	83 c4 18             	add    $0x18,%esp
}
  8036d8:	c9                   	leave  
  8036d9:	c3                   	ret    

008036da <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8036da:	55                   	push   %ebp
  8036db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8036dd:	6a 00                	push   $0x0
  8036df:	6a 00                	push   $0x0
  8036e1:	6a 00                	push   $0x0
  8036e3:	ff 75 0c             	pushl  0xc(%ebp)
  8036e6:	ff 75 08             	pushl  0x8(%ebp)
  8036e9:	6a 0b                	push   $0xb
  8036eb:	e8 e6 fe ff ff       	call   8035d6 <syscall>
  8036f0:	83 c4 18             	add    $0x18,%esp
}
  8036f3:	c9                   	leave  
  8036f4:	c3                   	ret    

008036f5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8036f5:	55                   	push   %ebp
  8036f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8036f8:	6a 00                	push   $0x0
  8036fa:	6a 00                	push   $0x0
  8036fc:	6a 00                	push   $0x0
  8036fe:	6a 00                	push   $0x0
  803700:	6a 00                	push   $0x0
  803702:	6a 0c                	push   $0xc
  803704:	e8 cd fe ff ff       	call   8035d6 <syscall>
  803709:	83 c4 18             	add    $0x18,%esp
}
  80370c:	c9                   	leave  
  80370d:	c3                   	ret    

0080370e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80370e:	55                   	push   %ebp
  80370f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803711:	6a 00                	push   $0x0
  803713:	6a 00                	push   $0x0
  803715:	6a 00                	push   $0x0
  803717:	6a 00                	push   $0x0
  803719:	6a 00                	push   $0x0
  80371b:	6a 0d                	push   $0xd
  80371d:	e8 b4 fe ff ff       	call   8035d6 <syscall>
  803722:	83 c4 18             	add    $0x18,%esp
}
  803725:	c9                   	leave  
  803726:	c3                   	ret    

00803727 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803727:	55                   	push   %ebp
  803728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80372a:	6a 00                	push   $0x0
  80372c:	6a 00                	push   $0x0
  80372e:	6a 00                	push   $0x0
  803730:	6a 00                	push   $0x0
  803732:	6a 00                	push   $0x0
  803734:	6a 0e                	push   $0xe
  803736:	e8 9b fe ff ff       	call   8035d6 <syscall>
  80373b:	83 c4 18             	add    $0x18,%esp
}
  80373e:	c9                   	leave  
  80373f:	c3                   	ret    

00803740 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803740:	55                   	push   %ebp
  803741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803743:	6a 00                	push   $0x0
  803745:	6a 00                	push   $0x0
  803747:	6a 00                	push   $0x0
  803749:	6a 00                	push   $0x0
  80374b:	6a 00                	push   $0x0
  80374d:	6a 0f                	push   $0xf
  80374f:	e8 82 fe ff ff       	call   8035d6 <syscall>
  803754:	83 c4 18             	add    $0x18,%esp
}
  803757:	c9                   	leave  
  803758:	c3                   	ret    

00803759 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803759:	55                   	push   %ebp
  80375a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80375c:	6a 00                	push   $0x0
  80375e:	6a 00                	push   $0x0
  803760:	6a 00                	push   $0x0
  803762:	6a 00                	push   $0x0
  803764:	ff 75 08             	pushl  0x8(%ebp)
  803767:	6a 10                	push   $0x10
  803769:	e8 68 fe ff ff       	call   8035d6 <syscall>
  80376e:	83 c4 18             	add    $0x18,%esp
}
  803771:	c9                   	leave  
  803772:	c3                   	ret    

00803773 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803773:	55                   	push   %ebp
  803774:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803776:	6a 00                	push   $0x0
  803778:	6a 00                	push   $0x0
  80377a:	6a 00                	push   $0x0
  80377c:	6a 00                	push   $0x0
  80377e:	6a 00                	push   $0x0
  803780:	6a 11                	push   $0x11
  803782:	e8 4f fe ff ff       	call   8035d6 <syscall>
  803787:	83 c4 18             	add    $0x18,%esp
}
  80378a:	90                   	nop
  80378b:	c9                   	leave  
  80378c:	c3                   	ret    

0080378d <sys_cputc>:

void
sys_cputc(const char c)
{
  80378d:	55                   	push   %ebp
  80378e:	89 e5                	mov    %esp,%ebp
  803790:	83 ec 04             	sub    $0x4,%esp
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803799:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80379d:	6a 00                	push   $0x0
  80379f:	6a 00                	push   $0x0
  8037a1:	6a 00                	push   $0x0
  8037a3:	6a 00                	push   $0x0
  8037a5:	50                   	push   %eax
  8037a6:	6a 01                	push   $0x1
  8037a8:	e8 29 fe ff ff       	call   8035d6 <syscall>
  8037ad:	83 c4 18             	add    $0x18,%esp
}
  8037b0:	90                   	nop
  8037b1:	c9                   	leave  
  8037b2:	c3                   	ret    

008037b3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8037b3:	55                   	push   %ebp
  8037b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8037b6:	6a 00                	push   $0x0
  8037b8:	6a 00                	push   $0x0
  8037ba:	6a 00                	push   $0x0
  8037bc:	6a 00                	push   $0x0
  8037be:	6a 00                	push   $0x0
  8037c0:	6a 14                	push   $0x14
  8037c2:	e8 0f fe ff ff       	call   8035d6 <syscall>
  8037c7:	83 c4 18             	add    $0x18,%esp
}
  8037ca:	90                   	nop
  8037cb:	c9                   	leave  
  8037cc:	c3                   	ret    

008037cd <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8037cd:	55                   	push   %ebp
  8037ce:	89 e5                	mov    %esp,%ebp
  8037d0:	83 ec 04             	sub    $0x4,%esp
  8037d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8037d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8037d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8037dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	6a 00                	push   $0x0
  8037e5:	51                   	push   %ecx
  8037e6:	52                   	push   %edx
  8037e7:	ff 75 0c             	pushl  0xc(%ebp)
  8037ea:	50                   	push   %eax
  8037eb:	6a 15                	push   $0x15
  8037ed:	e8 e4 fd ff ff       	call   8035d6 <syscall>
  8037f2:	83 c4 18             	add    $0x18,%esp
}
  8037f5:	c9                   	leave  
  8037f6:	c3                   	ret    

008037f7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8037f7:	55                   	push   %ebp
  8037f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8037fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	6a 00                	push   $0x0
  803802:	6a 00                	push   $0x0
  803804:	6a 00                	push   $0x0
  803806:	52                   	push   %edx
  803807:	50                   	push   %eax
  803808:	6a 16                	push   $0x16
  80380a:	e8 c7 fd ff ff       	call   8035d6 <syscall>
  80380f:	83 c4 18             	add    $0x18,%esp
}
  803812:	c9                   	leave  
  803813:	c3                   	ret    

00803814 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803814:	55                   	push   %ebp
  803815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803817:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80381a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80381d:	8b 45 08             	mov    0x8(%ebp),%eax
  803820:	6a 00                	push   $0x0
  803822:	6a 00                	push   $0x0
  803824:	51                   	push   %ecx
  803825:	52                   	push   %edx
  803826:	50                   	push   %eax
  803827:	6a 17                	push   $0x17
  803829:	e8 a8 fd ff ff       	call   8035d6 <syscall>
  80382e:	83 c4 18             	add    $0x18,%esp
}
  803831:	c9                   	leave  
  803832:	c3                   	ret    

00803833 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803833:	55                   	push   %ebp
  803834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803836:	8b 55 0c             	mov    0xc(%ebp),%edx
  803839:	8b 45 08             	mov    0x8(%ebp),%eax
  80383c:	6a 00                	push   $0x0
  80383e:	6a 00                	push   $0x0
  803840:	6a 00                	push   $0x0
  803842:	52                   	push   %edx
  803843:	50                   	push   %eax
  803844:	6a 18                	push   $0x18
  803846:	e8 8b fd ff ff       	call   8035d6 <syscall>
  80384b:	83 c4 18             	add    $0x18,%esp
}
  80384e:	c9                   	leave  
  80384f:	c3                   	ret    

00803850 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803850:	55                   	push   %ebp
  803851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803853:	8b 45 08             	mov    0x8(%ebp),%eax
  803856:	6a 00                	push   $0x0
  803858:	ff 75 14             	pushl  0x14(%ebp)
  80385b:	ff 75 10             	pushl  0x10(%ebp)
  80385e:	ff 75 0c             	pushl  0xc(%ebp)
  803861:	50                   	push   %eax
  803862:	6a 19                	push   $0x19
  803864:	e8 6d fd ff ff       	call   8035d6 <syscall>
  803869:	83 c4 18             	add    $0x18,%esp
}
  80386c:	c9                   	leave  
  80386d:	c3                   	ret    

0080386e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80386e:	55                   	push   %ebp
  80386f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	6a 00                	push   $0x0
  803876:	6a 00                	push   $0x0
  803878:	6a 00                	push   $0x0
  80387a:	6a 00                	push   $0x0
  80387c:	50                   	push   %eax
  80387d:	6a 1a                	push   $0x1a
  80387f:	e8 52 fd ff ff       	call   8035d6 <syscall>
  803884:	83 c4 18             	add    $0x18,%esp
}
  803887:	90                   	nop
  803888:	c9                   	leave  
  803889:	c3                   	ret    

0080388a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80388a:	55                   	push   %ebp
  80388b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	6a 00                	push   $0x0
  803892:	6a 00                	push   $0x0
  803894:	6a 00                	push   $0x0
  803896:	6a 00                	push   $0x0
  803898:	50                   	push   %eax
  803899:	6a 1b                	push   $0x1b
  80389b:	e8 36 fd ff ff       	call   8035d6 <syscall>
  8038a0:	83 c4 18             	add    $0x18,%esp
}
  8038a3:	c9                   	leave  
  8038a4:	c3                   	ret    

008038a5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8038a5:	55                   	push   %ebp
  8038a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8038a8:	6a 00                	push   $0x0
  8038aa:	6a 00                	push   $0x0
  8038ac:	6a 00                	push   $0x0
  8038ae:	6a 00                	push   $0x0
  8038b0:	6a 00                	push   $0x0
  8038b2:	6a 05                	push   $0x5
  8038b4:	e8 1d fd ff ff       	call   8035d6 <syscall>
  8038b9:	83 c4 18             	add    $0x18,%esp
}
  8038bc:	c9                   	leave  
  8038bd:	c3                   	ret    

008038be <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8038be:	55                   	push   %ebp
  8038bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8038c1:	6a 00                	push   $0x0
  8038c3:	6a 00                	push   $0x0
  8038c5:	6a 00                	push   $0x0
  8038c7:	6a 00                	push   $0x0
  8038c9:	6a 00                	push   $0x0
  8038cb:	6a 06                	push   $0x6
  8038cd:	e8 04 fd ff ff       	call   8035d6 <syscall>
  8038d2:	83 c4 18             	add    $0x18,%esp
}
  8038d5:	c9                   	leave  
  8038d6:	c3                   	ret    

008038d7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8038da:	6a 00                	push   $0x0
  8038dc:	6a 00                	push   $0x0
  8038de:	6a 00                	push   $0x0
  8038e0:	6a 00                	push   $0x0
  8038e2:	6a 00                	push   $0x0
  8038e4:	6a 07                	push   $0x7
  8038e6:	e8 eb fc ff ff       	call   8035d6 <syscall>
  8038eb:	83 c4 18             	add    $0x18,%esp
}
  8038ee:	c9                   	leave  
  8038ef:	c3                   	ret    

008038f0 <sys_exit_env>:


void sys_exit_env(void)
{
  8038f0:	55                   	push   %ebp
  8038f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8038f3:	6a 00                	push   $0x0
  8038f5:	6a 00                	push   $0x0
  8038f7:	6a 00                	push   $0x0
  8038f9:	6a 00                	push   $0x0
  8038fb:	6a 00                	push   $0x0
  8038fd:	6a 1c                	push   $0x1c
  8038ff:	e8 d2 fc ff ff       	call   8035d6 <syscall>
  803904:	83 c4 18             	add    $0x18,%esp
}
  803907:	90                   	nop
  803908:	c9                   	leave  
  803909:	c3                   	ret    

0080390a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80390a:	55                   	push   %ebp
  80390b:	89 e5                	mov    %esp,%ebp
  80390d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803910:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803913:	8d 50 04             	lea    0x4(%eax),%edx
  803916:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803919:	6a 00                	push   $0x0
  80391b:	6a 00                	push   $0x0
  80391d:	6a 00                	push   $0x0
  80391f:	52                   	push   %edx
  803920:	50                   	push   %eax
  803921:	6a 1d                	push   $0x1d
  803923:	e8 ae fc ff ff       	call   8035d6 <syscall>
  803928:	83 c4 18             	add    $0x18,%esp
	return result;
  80392b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80392e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803931:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803934:	89 01                	mov    %eax,(%ecx)
  803936:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803939:	8b 45 08             	mov    0x8(%ebp),%eax
  80393c:	c9                   	leave  
  80393d:	c2 04 00             	ret    $0x4

00803940 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803940:	55                   	push   %ebp
  803941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803943:	6a 00                	push   $0x0
  803945:	6a 00                	push   $0x0
  803947:	ff 75 10             	pushl  0x10(%ebp)
  80394a:	ff 75 0c             	pushl  0xc(%ebp)
  80394d:	ff 75 08             	pushl  0x8(%ebp)
  803950:	6a 13                	push   $0x13
  803952:	e8 7f fc ff ff       	call   8035d6 <syscall>
  803957:	83 c4 18             	add    $0x18,%esp
	return ;
  80395a:	90                   	nop
}
  80395b:	c9                   	leave  
  80395c:	c3                   	ret    

0080395d <sys_rcr2>:
uint32 sys_rcr2()
{
  80395d:	55                   	push   %ebp
  80395e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803960:	6a 00                	push   $0x0
  803962:	6a 00                	push   $0x0
  803964:	6a 00                	push   $0x0
  803966:	6a 00                	push   $0x0
  803968:	6a 00                	push   $0x0
  80396a:	6a 1e                	push   $0x1e
  80396c:	e8 65 fc ff ff       	call   8035d6 <syscall>
  803971:	83 c4 18             	add    $0x18,%esp
}
  803974:	c9                   	leave  
  803975:	c3                   	ret    

00803976 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803976:	55                   	push   %ebp
  803977:	89 e5                	mov    %esp,%ebp
  803979:	83 ec 04             	sub    $0x4,%esp
  80397c:	8b 45 08             	mov    0x8(%ebp),%eax
  80397f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803982:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803986:	6a 00                	push   $0x0
  803988:	6a 00                	push   $0x0
  80398a:	6a 00                	push   $0x0
  80398c:	6a 00                	push   $0x0
  80398e:	50                   	push   %eax
  80398f:	6a 1f                	push   $0x1f
  803991:	e8 40 fc ff ff       	call   8035d6 <syscall>
  803996:	83 c4 18             	add    $0x18,%esp
	return ;
  803999:	90                   	nop
}
  80399a:	c9                   	leave  
  80399b:	c3                   	ret    

0080399c <rsttst>:
void rsttst()
{
  80399c:	55                   	push   %ebp
  80399d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80399f:	6a 00                	push   $0x0
  8039a1:	6a 00                	push   $0x0
  8039a3:	6a 00                	push   $0x0
  8039a5:	6a 00                	push   $0x0
  8039a7:	6a 00                	push   $0x0
  8039a9:	6a 21                	push   $0x21
  8039ab:	e8 26 fc ff ff       	call   8035d6 <syscall>
  8039b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8039b3:	90                   	nop
}
  8039b4:	c9                   	leave  
  8039b5:	c3                   	ret    

008039b6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8039b6:	55                   	push   %ebp
  8039b7:	89 e5                	mov    %esp,%ebp
  8039b9:	83 ec 04             	sub    $0x4,%esp
  8039bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8039bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8039c2:	8b 55 18             	mov    0x18(%ebp),%edx
  8039c5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8039c9:	52                   	push   %edx
  8039ca:	50                   	push   %eax
  8039cb:	ff 75 10             	pushl  0x10(%ebp)
  8039ce:	ff 75 0c             	pushl  0xc(%ebp)
  8039d1:	ff 75 08             	pushl  0x8(%ebp)
  8039d4:	6a 20                	push   $0x20
  8039d6:	e8 fb fb ff ff       	call   8035d6 <syscall>
  8039db:	83 c4 18             	add    $0x18,%esp
	return ;
  8039de:	90                   	nop
}
  8039df:	c9                   	leave  
  8039e0:	c3                   	ret    

008039e1 <chktst>:
void chktst(uint32 n)
{
  8039e1:	55                   	push   %ebp
  8039e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8039e4:	6a 00                	push   $0x0
  8039e6:	6a 00                	push   $0x0
  8039e8:	6a 00                	push   $0x0
  8039ea:	6a 00                	push   $0x0
  8039ec:	ff 75 08             	pushl  0x8(%ebp)
  8039ef:	6a 22                	push   $0x22
  8039f1:	e8 e0 fb ff ff       	call   8035d6 <syscall>
  8039f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8039f9:	90                   	nop
}
  8039fa:	c9                   	leave  
  8039fb:	c3                   	ret    

008039fc <inctst>:

void inctst()
{
  8039fc:	55                   	push   %ebp
  8039fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8039ff:	6a 00                	push   $0x0
  803a01:	6a 00                	push   $0x0
  803a03:	6a 00                	push   $0x0
  803a05:	6a 00                	push   $0x0
  803a07:	6a 00                	push   $0x0
  803a09:	6a 23                	push   $0x23
  803a0b:	e8 c6 fb ff ff       	call   8035d6 <syscall>
  803a10:	83 c4 18             	add    $0x18,%esp
	return ;
  803a13:	90                   	nop
}
  803a14:	c9                   	leave  
  803a15:	c3                   	ret    

00803a16 <gettst>:
uint32 gettst()
{
  803a16:	55                   	push   %ebp
  803a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803a19:	6a 00                	push   $0x0
  803a1b:	6a 00                	push   $0x0
  803a1d:	6a 00                	push   $0x0
  803a1f:	6a 00                	push   $0x0
  803a21:	6a 00                	push   $0x0
  803a23:	6a 24                	push   $0x24
  803a25:	e8 ac fb ff ff       	call   8035d6 <syscall>
  803a2a:	83 c4 18             	add    $0x18,%esp
}
  803a2d:	c9                   	leave  
  803a2e:	c3                   	ret    

00803a2f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803a2f:	55                   	push   %ebp
  803a30:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803a32:	6a 00                	push   $0x0
  803a34:	6a 00                	push   $0x0
  803a36:	6a 00                	push   $0x0
  803a38:	6a 00                	push   $0x0
  803a3a:	6a 00                	push   $0x0
  803a3c:	6a 25                	push   $0x25
  803a3e:	e8 93 fb ff ff       	call   8035d6 <syscall>
  803a43:	83 c4 18             	add    $0x18,%esp
  803a46:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  803a4b:	a1 80 60 83 00       	mov    0x836080,%eax
}
  803a50:	c9                   	leave  
  803a51:	c3                   	ret    

00803a52 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803a52:	55                   	push   %ebp
  803a53:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803a55:	8b 45 08             	mov    0x8(%ebp),%eax
  803a58:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803a5d:	6a 00                	push   $0x0
  803a5f:	6a 00                	push   $0x0
  803a61:	6a 00                	push   $0x0
  803a63:	6a 00                	push   $0x0
  803a65:	ff 75 08             	pushl  0x8(%ebp)
  803a68:	6a 26                	push   $0x26
  803a6a:	e8 67 fb ff ff       	call   8035d6 <syscall>
  803a6f:	83 c4 18             	add    $0x18,%esp
	return ;
  803a72:	90                   	nop
}
  803a73:	c9                   	leave  
  803a74:	c3                   	ret    

00803a75 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803a75:	55                   	push   %ebp
  803a76:	89 e5                	mov    %esp,%ebp
  803a78:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803a79:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803a7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a82:	8b 45 08             	mov    0x8(%ebp),%eax
  803a85:	6a 00                	push   $0x0
  803a87:	53                   	push   %ebx
  803a88:	51                   	push   %ecx
  803a89:	52                   	push   %edx
  803a8a:	50                   	push   %eax
  803a8b:	6a 27                	push   $0x27
  803a8d:	e8 44 fb ff ff       	call   8035d6 <syscall>
  803a92:	83 c4 18             	add    $0x18,%esp
}
  803a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a98:	c9                   	leave  
  803a99:	c3                   	ret    

00803a9a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803a9a:	55                   	push   %ebp
  803a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa3:	6a 00                	push   $0x0
  803aa5:	6a 00                	push   $0x0
  803aa7:	6a 00                	push   $0x0
  803aa9:	52                   	push   %edx
  803aaa:	50                   	push   %eax
  803aab:	6a 28                	push   $0x28
  803aad:	e8 24 fb ff ff       	call   8035d6 <syscall>
  803ab2:	83 c4 18             	add    $0x18,%esp
}
  803ab5:	c9                   	leave  
  803ab6:	c3                   	ret    

00803ab7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803ab7:	55                   	push   %ebp
  803ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803aba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac3:	6a 00                	push   $0x0
  803ac5:	51                   	push   %ecx
  803ac6:	ff 75 10             	pushl  0x10(%ebp)
  803ac9:	52                   	push   %edx
  803aca:	50                   	push   %eax
  803acb:	6a 29                	push   $0x29
  803acd:	e8 04 fb ff ff       	call   8035d6 <syscall>
  803ad2:	83 c4 18             	add    $0x18,%esp
}
  803ad5:	c9                   	leave  
  803ad6:	c3                   	ret    

00803ad7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803ad7:	55                   	push   %ebp
  803ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803ada:	6a 00                	push   $0x0
  803adc:	6a 00                	push   $0x0
  803ade:	ff 75 10             	pushl  0x10(%ebp)
  803ae1:	ff 75 0c             	pushl  0xc(%ebp)
  803ae4:	ff 75 08             	pushl  0x8(%ebp)
  803ae7:	6a 12                	push   $0x12
  803ae9:	e8 e8 fa ff ff       	call   8035d6 <syscall>
  803aee:	83 c4 18             	add    $0x18,%esp
	return ;
  803af1:	90                   	nop
}
  803af2:	c9                   	leave  
  803af3:	c3                   	ret    

00803af4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803af4:	55                   	push   %ebp
  803af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  803afa:	8b 45 08             	mov    0x8(%ebp),%eax
  803afd:	6a 00                	push   $0x0
  803aff:	6a 00                	push   $0x0
  803b01:	6a 00                	push   $0x0
  803b03:	52                   	push   %edx
  803b04:	50                   	push   %eax
  803b05:	6a 2a                	push   $0x2a
  803b07:	e8 ca fa ff ff       	call   8035d6 <syscall>
  803b0c:	83 c4 18             	add    $0x18,%esp
	return;
  803b0f:	90                   	nop
}
  803b10:	c9                   	leave  
  803b11:	c3                   	ret    

00803b12 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803b12:	55                   	push   %ebp
  803b13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803b15:	6a 00                	push   $0x0
  803b17:	6a 00                	push   $0x0
  803b19:	6a 00                	push   $0x0
  803b1b:	6a 00                	push   $0x0
  803b1d:	6a 00                	push   $0x0
  803b1f:	6a 2b                	push   $0x2b
  803b21:	e8 b0 fa ff ff       	call   8035d6 <syscall>
  803b26:	83 c4 18             	add    $0x18,%esp
}
  803b29:	c9                   	leave  
  803b2a:	c3                   	ret    

00803b2b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803b2b:	55                   	push   %ebp
  803b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803b2e:	6a 00                	push   $0x0
  803b30:	6a 00                	push   $0x0
  803b32:	6a 00                	push   $0x0
  803b34:	ff 75 0c             	pushl  0xc(%ebp)
  803b37:	ff 75 08             	pushl  0x8(%ebp)
  803b3a:	6a 2d                	push   $0x2d
  803b3c:	e8 95 fa ff ff       	call   8035d6 <syscall>
  803b41:	83 c4 18             	add    $0x18,%esp
	return;
  803b44:	90                   	nop
}
  803b45:	c9                   	leave  
  803b46:	c3                   	ret    

00803b47 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803b47:	55                   	push   %ebp
  803b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803b4a:	6a 00                	push   $0x0
  803b4c:	6a 00                	push   $0x0
  803b4e:	6a 00                	push   $0x0
  803b50:	ff 75 0c             	pushl  0xc(%ebp)
  803b53:	ff 75 08             	pushl  0x8(%ebp)
  803b56:	6a 2c                	push   $0x2c
  803b58:	e8 79 fa ff ff       	call   8035d6 <syscall>
  803b5d:	83 c4 18             	add    $0x18,%esp
	return ;
  803b60:	90                   	nop
}
  803b61:	c9                   	leave  
  803b62:	c3                   	ret    

00803b63 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803b63:	55                   	push   %ebp
  803b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b69:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6c:	6a 00                	push   $0x0
  803b6e:	6a 00                	push   $0x0
  803b70:	6a 00                	push   $0x0
  803b72:	52                   	push   %edx
  803b73:	50                   	push   %eax
  803b74:	6a 2e                	push   $0x2e
  803b76:	e8 5b fa ff ff       	call   8035d6 <syscall>
  803b7b:	83 c4 18             	add    $0x18,%esp
}
  803b7e:	90                   	nop
  803b7f:	c9                   	leave  
  803b80:	c3                   	ret    

00803b81 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803b81:	55                   	push   %ebp
  803b82:	89 e5                	mov    %esp,%ebp
  803b84:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803b87:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803b8e:	72 09                	jb     803b99 <to_page_va+0x18>
  803b90:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803b97:	72 14                	jb     803bad <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803b99:	83 ec 04             	sub    $0x4,%esp
  803b9c:	68 cc 51 80 00       	push   $0x8051cc
  803ba1:	6a 15                	push   $0x15
  803ba3:	68 f7 51 80 00       	push   $0x8051f7
  803ba8:	e8 08 ce ff ff       	call   8009b5 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803bad:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb0:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803bb5:	29 d0                	sub    %edx,%eax
  803bb7:	c1 f8 02             	sar    $0x2,%eax
  803bba:	89 c2                	mov    %eax,%edx
  803bbc:	89 d0                	mov    %edx,%eax
  803bbe:	c1 e0 02             	shl    $0x2,%eax
  803bc1:	01 d0                	add    %edx,%eax
  803bc3:	c1 e0 02             	shl    $0x2,%eax
  803bc6:	01 d0                	add    %edx,%eax
  803bc8:	c1 e0 02             	shl    $0x2,%eax
  803bcb:	01 d0                	add    %edx,%eax
  803bcd:	89 c1                	mov    %eax,%ecx
  803bcf:	c1 e1 08             	shl    $0x8,%ecx
  803bd2:	01 c8                	add    %ecx,%eax
  803bd4:	89 c1                	mov    %eax,%ecx
  803bd6:	c1 e1 10             	shl    $0x10,%ecx
  803bd9:	01 c8                	add    %ecx,%eax
  803bdb:	01 c0                	add    %eax,%eax
  803bdd:	01 d0                	add    %edx,%eax
  803bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be5:	c1 e0 0c             	shl    $0xc,%eax
  803be8:	89 c2                	mov    %eax,%edx
  803bea:	a1 84 60 83 00       	mov    0x836084,%eax
  803bef:	01 d0                	add    %edx,%eax
}
  803bf1:	c9                   	leave  
  803bf2:	c3                   	ret    

00803bf3 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803bf3:	55                   	push   %ebp
  803bf4:	89 e5                	mov    %esp,%ebp
  803bf6:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803bf9:	a1 84 60 83 00       	mov    0x836084,%eax
  803bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  803c01:	29 c2                	sub    %eax,%edx
  803c03:	89 d0                	mov    %edx,%eax
  803c05:	c1 e8 0c             	shr    $0xc,%eax
  803c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803c0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c0f:	78 09                	js     803c1a <to_page_info+0x27>
  803c11:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803c18:	7e 14                	jle    803c2e <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803c1a:	83 ec 04             	sub    $0x4,%esp
  803c1d:	68 10 52 80 00       	push   $0x805210
  803c22:	6a 21                	push   $0x21
  803c24:	68 f7 51 80 00       	push   $0x8051f7
  803c29:	e8 87 cd ff ff       	call   8009b5 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c31:	89 d0                	mov    %edx,%eax
  803c33:	01 c0                	add    %eax,%eax
  803c35:	01 d0                	add    %edx,%eax
  803c37:	c1 e0 02             	shl    $0x2,%eax
  803c3a:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803c3f:	c9                   	leave  
  803c40:	c3                   	ret    

00803c41 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803c41:	55                   	push   %ebp
  803c42:	89 e5                	mov    %esp,%ebp
  803c44:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803c47:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4a:	05 00 00 00 02       	add    $0x2000000,%eax
  803c4f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c52:	73 16                	jae    803c6a <initialize_dynamic_allocator+0x29>
  803c54:	68 34 52 80 00       	push   $0x805234
  803c59:	68 5a 52 80 00       	push   $0x80525a
  803c5e:	6a 2f                	push   $0x2f
  803c60:	68 f7 51 80 00       	push   $0x8051f7
  803c65:	e8 4b cd ff ff       	call   8009b5 <_panic>
	dynAllocStart = daStart;
  803c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6d:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c75:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803c81:	eb 36                	jmp    803cb9 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c86:	c1 e0 04             	shl    $0x4,%eax
  803c89:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c97:	c1 e0 04             	shl    $0x4,%eax
  803c9a:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803c9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca8:	c1 e0 04             	shl    $0x4,%eax
  803cab:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803cb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803cb6:	ff 45 f4             	incl   -0xc(%ebp)
  803cb9:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803cbd:	7e c4                	jle    803c83 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803cbf:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803cc6:	00 00 00 
  803cc9:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803cd0:	00 00 00 
  803cd3:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803cda:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803cdd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803ce4:	e9 1b 01 00 00       	jmp    803e04 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803ce9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cec:	89 d0                	mov    %edx,%eax
  803cee:	01 c0                	add    %eax,%eax
  803cf0:	01 d0                	add    %edx,%eax
  803cf2:	c1 e0 02             	shl    $0x2,%eax
  803cf5:	05 88 e0 81 00       	add    $0x81e088,%eax
  803cfa:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803cff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d02:	89 d0                	mov    %edx,%eax
  803d04:	01 c0                	add    %eax,%eax
  803d06:	01 d0                	add    %edx,%eax
  803d08:	c1 e0 02             	shl    $0x2,%eax
  803d0b:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803d10:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803d15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d18:	89 d0                	mov    %edx,%eax
  803d1a:	01 c0                	add    %eax,%eax
  803d1c:	01 d0                	add    %edx,%eax
  803d1e:	c1 e0 02             	shl    $0x2,%eax
  803d21:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d26:	8b 00                	mov    (%eax),%eax
  803d28:	85 c0                	test   %eax,%eax
  803d2a:	74 2b                	je     803d57 <initialize_dynamic_allocator+0x116>
  803d2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d2f:	89 d0                	mov    %edx,%eax
  803d31:	01 c0                	add    %eax,%eax
  803d33:	01 d0                	add    %edx,%eax
  803d35:	c1 e0 02             	shl    $0x2,%eax
  803d38:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d3d:	8b 10                	mov    (%eax),%edx
  803d3f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d42:	89 c8                	mov    %ecx,%eax
  803d44:	01 c0                	add    %eax,%eax
  803d46:	01 c8                	add    %ecx,%eax
  803d48:	c1 e0 02             	shl    $0x2,%eax
  803d4b:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d50:	8b 00                	mov    (%eax),%eax
  803d52:	89 42 04             	mov    %eax,0x4(%edx)
  803d55:	eb 18                	jmp    803d6f <initialize_dynamic_allocator+0x12e>
  803d57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d5a:	89 d0                	mov    %edx,%eax
  803d5c:	01 c0                	add    %eax,%eax
  803d5e:	01 d0                	add    %edx,%eax
  803d60:	c1 e0 02             	shl    $0x2,%eax
  803d63:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d68:	8b 00                	mov    (%eax),%eax
  803d6a:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803d6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d72:	89 d0                	mov    %edx,%eax
  803d74:	01 c0                	add    %eax,%eax
  803d76:	01 d0                	add    %edx,%eax
  803d78:	c1 e0 02             	shl    $0x2,%eax
  803d7b:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d80:	8b 00                	mov    (%eax),%eax
  803d82:	85 c0                	test   %eax,%eax
  803d84:	74 2a                	je     803db0 <initialize_dynamic_allocator+0x16f>
  803d86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d89:	89 d0                	mov    %edx,%eax
  803d8b:	01 c0                	add    %eax,%eax
  803d8d:	01 d0                	add    %edx,%eax
  803d8f:	c1 e0 02             	shl    $0x2,%eax
  803d92:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d97:	8b 10                	mov    (%eax),%edx
  803d99:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d9c:	89 c8                	mov    %ecx,%eax
  803d9e:	01 c0                	add    %eax,%eax
  803da0:	01 c8                	add    %ecx,%eax
  803da2:	c1 e0 02             	shl    $0x2,%eax
  803da5:	05 80 e0 81 00       	add    $0x81e080,%eax
  803daa:	8b 00                	mov    (%eax),%eax
  803dac:	89 02                	mov    %eax,(%edx)
  803dae:	eb 18                	jmp    803dc8 <initialize_dynamic_allocator+0x187>
  803db0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803db3:	89 d0                	mov    %edx,%eax
  803db5:	01 c0                	add    %eax,%eax
  803db7:	01 d0                	add    %edx,%eax
  803db9:	c1 e0 02             	shl    $0x2,%eax
  803dbc:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dc1:	8b 00                	mov    (%eax),%eax
  803dc3:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dcb:	89 d0                	mov    %edx,%eax
  803dcd:	01 c0                	add    %eax,%eax
  803dcf:	01 d0                	add    %edx,%eax
  803dd1:	c1 e0 02             	shl    $0x2,%eax
  803dd4:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ddf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803de2:	89 d0                	mov    %edx,%eax
  803de4:	01 c0                	add    %eax,%eax
  803de6:	01 d0                	add    %edx,%eax
  803de8:	c1 e0 02             	shl    $0x2,%eax
  803deb:	05 84 e0 81 00       	add    $0x81e084,%eax
  803df0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df6:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803dfb:	48                   	dec    %eax
  803dfc:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803e01:	ff 45 f0             	incl   -0x10(%ebp)
  803e04:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803e0b:	0f 8e d8 fe ff ff    	jle    803ce9 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803e11:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803e18:	e9 9d 00 00 00       	jmp    803eba <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803e1d:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803e23:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803e26:	89 c8                	mov    %ecx,%eax
  803e28:	01 c0                	add    %eax,%eax
  803e2a:	01 c8                	add    %ecx,%eax
  803e2c:	c1 e0 02             	shl    $0x2,%eax
  803e2f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e34:	89 10                	mov    %edx,(%eax)
  803e36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e39:	89 d0                	mov    %edx,%eax
  803e3b:	01 c0                	add    %eax,%eax
  803e3d:	01 d0                	add    %edx,%eax
  803e3f:	c1 e0 02             	shl    $0x2,%eax
  803e42:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e47:	8b 00                	mov    (%eax),%eax
  803e49:	85 c0                	test   %eax,%eax
  803e4b:	74 1c                	je     803e69 <initialize_dynamic_allocator+0x228>
  803e4d:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803e53:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803e56:	89 c8                	mov    %ecx,%eax
  803e58:	01 c0                	add    %eax,%eax
  803e5a:	01 c8                	add    %ecx,%eax
  803e5c:	c1 e0 02             	shl    $0x2,%eax
  803e5f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e64:	89 42 04             	mov    %eax,0x4(%edx)
  803e67:	eb 16                	jmp    803e7f <initialize_dynamic_allocator+0x23e>
  803e69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e6c:	89 d0                	mov    %edx,%eax
  803e6e:	01 c0                	add    %eax,%eax
  803e70:	01 d0                	add    %edx,%eax
  803e72:	c1 e0 02             	shl    $0x2,%eax
  803e75:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e7a:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803e7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e82:	89 d0                	mov    %edx,%eax
  803e84:	01 c0                	add    %eax,%eax
  803e86:	01 d0                	add    %edx,%eax
  803e88:	c1 e0 02             	shl    $0x2,%eax
  803e8b:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e90:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803e95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e98:	89 d0                	mov    %edx,%eax
  803e9a:	01 c0                	add    %eax,%eax
  803e9c:	01 d0                	add    %edx,%eax
  803e9e:	c1 e0 02             	shl    $0x2,%eax
  803ea1:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ea6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eac:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803eb1:	40                   	inc    %eax
  803eb2:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803eb7:	ff 4d ec             	decl   -0x14(%ebp)
  803eba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ebe:	0f 89 59 ff ff ff    	jns    803e1d <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803ec4:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803ecb:	00 00 00 
}
  803ece:	90                   	nop
  803ecf:	c9                   	leave  
  803ed0:	c3                   	ret    

00803ed1 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803ed1:	55                   	push   %ebp
  803ed2:	89 e5                	mov    %esp,%ebp
  803ed4:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eda:	83 ec 0c             	sub    $0xc,%esp
  803edd:	50                   	push   %eax
  803ede:	e8 10 fd ff ff       	call   803bf3 <to_page_info>
  803ee3:	83 c4 10             	add    $0x10,%esp
  803ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eec:	8b 40 08             	mov    0x8(%eax),%eax
  803eef:	0f b7 c0             	movzwl %ax,%eax
}
  803ef2:	c9                   	leave  
  803ef3:	c3                   	ret    

00803ef4 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803ef4:	55                   	push   %ebp
  803ef5:	89 e5                	mov    %esp,%ebp
  803ef7:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803efa:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803f01:	76 16                	jbe    803f19 <alloc_block+0x25>
  803f03:	68 70 52 80 00       	push   $0x805270
  803f08:	68 5a 52 80 00       	push   $0x80525a
  803f0d:	6a 59                	push   $0x59
  803f0f:	68 f7 51 80 00       	push   $0x8051f7
  803f14:	e8 9c ca ff ff       	call   8009b5 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803f19:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803f20:	eb 08                	jmp    803f2a <alloc_block+0x36>
		allocSize <<= 1;
  803f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f25:	01 c0                	add    %eax,%eax
  803f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f30:	73 09                	jae    803f3b <alloc_block+0x47>
  803f32:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803f39:	76 e7                	jbe    803f22 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803f3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803f42:	eb 03                	jmp    803f47 <alloc_block+0x53>
		listIndex++;
  803f44:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4a:	ba 08 00 00 00       	mov    $0x8,%edx
  803f4f:	88 c1                	mov    %al,%cl
  803f51:	d3 e2                	shl    %cl,%edx
  803f53:	89 d0                	mov    %edx,%eax
  803f55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803f58:	72 ea                	jb     803f44 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803f60:	e9 f4 00 00 00       	jmp    804059 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f68:	c1 e0 04             	shl    $0x4,%eax
  803f6b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f70:	8b 00                	mov    (%eax),%eax
  803f72:	85 c0                	test   %eax,%eax
  803f74:	0f 84 dc 00 00 00    	je     804056 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f7d:	c1 e0 04             	shl    $0x4,%eax
  803f80:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f85:	8b 00                	mov    (%eax),%eax
  803f87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803f8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f8e:	75 14                	jne    803fa4 <alloc_block+0xb0>
  803f90:	83 ec 04             	sub    $0x4,%esp
  803f93:	68 91 52 80 00       	push   $0x805291
  803f98:	6a 6b                	push   $0x6b
  803f9a:	68 f7 51 80 00       	push   $0x8051f7
  803f9f:	e8 11 ca ff ff       	call   8009b5 <_panic>
  803fa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa7:	8b 00                	mov    (%eax),%eax
  803fa9:	85 c0                	test   %eax,%eax
  803fab:	74 10                	je     803fbd <alloc_block+0xc9>
  803fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb0:	8b 00                	mov    (%eax),%eax
  803fb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fb5:	8b 52 04             	mov    0x4(%edx),%edx
  803fb8:	89 50 04             	mov    %edx,0x4(%eax)
  803fbb:	eb 14                	jmp    803fd1 <alloc_block+0xdd>
  803fbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc0:	8b 40 04             	mov    0x4(%eax),%eax
  803fc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fc6:	c1 e2 04             	shl    $0x4,%edx
  803fc9:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803fcf:	89 02                	mov    %eax,(%edx)
  803fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd4:	8b 40 04             	mov    0x4(%eax),%eax
  803fd7:	85 c0                	test   %eax,%eax
  803fd9:	74 0f                	je     803fea <alloc_block+0xf6>
  803fdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fde:	8b 40 04             	mov    0x4(%eax),%eax
  803fe1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fe4:	8b 12                	mov    (%edx),%edx
  803fe6:	89 10                	mov    %edx,(%eax)
  803fe8:	eb 13                	jmp    803ffd <alloc_block+0x109>
  803fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fed:	8b 00                	mov    (%eax),%eax
  803fef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ff2:	c1 e2 04             	shl    $0x4,%edx
  803ff5:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803ffb:	89 02                	mov    %eax,(%edx)
  803ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804000:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804009:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804013:	c1 e0 04             	shl    $0x4,%eax
  804016:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80401b:	8b 00                	mov    (%eax),%eax
  80401d:	8d 50 ff             	lea    -0x1(%eax),%edx
  804020:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804023:	c1 e0 04             	shl    $0x4,%eax
  804026:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80402b:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  80402d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804030:	83 ec 0c             	sub    $0xc,%esp
  804033:	50                   	push   %eax
  804034:	e8 ba fb ff ff       	call   803bf3 <to_page_info>
  804039:	83 c4 10             	add    $0x10,%esp
  80403c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80403f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804042:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804046:	48                   	dec    %eax
  804047:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80404a:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  80404e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804051:	e9 8f 02 00 00       	jmp    8042e5 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804056:	ff 45 ec             	incl   -0x14(%ebp)
  804059:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80405d:	0f 8e 02 ff ff ff    	jle    803f65 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  804063:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804068:	85 c0                	test   %eax,%eax
  80406a:	75 14                	jne    804080 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  80406c:	83 ec 04             	sub    $0x4,%esp
  80406f:	68 b0 52 80 00       	push   $0x8052b0
  804074:	6a 77                	push   $0x77
  804076:	68 f7 51 80 00       	push   $0x8051f7
  80407b:	e8 35 c9 ff ff       	call   8009b5 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  804080:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804085:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  804088:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80408c:	75 14                	jne    8040a2 <alloc_block+0x1ae>
  80408e:	83 ec 04             	sub    $0x4,%esp
  804091:	68 91 52 80 00       	push   $0x805291
  804096:	6a 7a                	push   $0x7a
  804098:	68 f7 51 80 00       	push   $0x8051f7
  80409d:	e8 13 c9 ff ff       	call   8009b5 <_panic>
  8040a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040a5:	8b 00                	mov    (%eax),%eax
  8040a7:	85 c0                	test   %eax,%eax
  8040a9:	74 10                	je     8040bb <alloc_block+0x1c7>
  8040ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040ae:	8b 00                	mov    (%eax),%eax
  8040b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040b3:	8b 52 04             	mov    0x4(%edx),%edx
  8040b6:	89 50 04             	mov    %edx,0x4(%eax)
  8040b9:	eb 0b                	jmp    8040c6 <alloc_block+0x1d2>
  8040bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040be:	8b 40 04             	mov    0x4(%eax),%eax
  8040c1:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8040c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040c9:	8b 40 04             	mov    0x4(%eax),%eax
  8040cc:	85 c0                	test   %eax,%eax
  8040ce:	74 0f                	je     8040df <alloc_block+0x1eb>
  8040d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040d3:	8b 40 04             	mov    0x4(%eax),%eax
  8040d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040d9:	8b 12                	mov    (%edx),%edx
  8040db:	89 10                	mov    %edx,(%eax)
  8040dd:	eb 0a                	jmp    8040e9 <alloc_block+0x1f5>
  8040df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040e2:	8b 00                	mov    (%eax),%eax
  8040e4:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8040e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040fc:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804101:	48                   	dec    %eax
  804102:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  804107:	83 ec 0c             	sub    $0xc,%esp
  80410a:	ff 75 dc             	pushl  -0x24(%ebp)
  80410d:	e8 6f fa ff ff       	call   803b81 <to_page_va>
  804112:	83 c4 10             	add    $0x10,%esp
  804115:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  804118:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80411b:	83 ec 0c             	sub    $0xc,%esp
  80411e:	50                   	push   %eax
  80411f:	e8 a0 dc ff ff       	call   801dc4 <get_page>
  804124:	83 c4 10             	add    $0x10,%esp
  804127:	85 c0                	test   %eax,%eax
  804129:	74 14                	je     80413f <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  80412b:	83 ec 04             	sub    $0x4,%esp
  80412e:	68 d8 52 80 00       	push   $0x8052d8
  804133:	6a 7f                	push   $0x7f
  804135:	68 f7 51 80 00       	push   $0x8051f7
  80413a:	e8 76 c8 ff ff       	call   8009b5 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  80413f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804142:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804145:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  804149:	b8 00 10 00 00       	mov    $0x1000,%eax
  80414e:	ba 00 00 00 00       	mov    $0x0,%edx
  804153:	f7 75 f4             	divl   -0xc(%ebp)
  804156:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804159:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80415d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804164:	e9 a7 00 00 00       	jmp    804210 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  804169:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80416c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80416f:	01 d0                	add    %edx,%eax
  804171:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  804174:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804178:	75 17                	jne    804191 <alloc_block+0x29d>
  80417a:	83 ec 04             	sub    $0x4,%esp
  80417d:	68 00 53 80 00       	push   $0x805300
  804182:	68 88 00 00 00       	push   $0x88
  804187:	68 f7 51 80 00       	push   $0x8051f7
  80418c:	e8 24 c8 ff ff       	call   8009b5 <_panic>
  804191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804194:	c1 e0 04             	shl    $0x4,%eax
  804197:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80419c:	8b 10                	mov    (%eax),%edx
  80419e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041a1:	89 10                	mov    %edx,(%eax)
  8041a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041a6:	8b 00                	mov    (%eax),%eax
  8041a8:	85 c0                	test   %eax,%eax
  8041aa:	74 15                	je     8041c1 <alloc_block+0x2cd>
  8041ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041af:	c1 e0 04             	shl    $0x4,%eax
  8041b2:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041b7:	8b 00                	mov    (%eax),%eax
  8041b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041bc:	89 50 04             	mov    %edx,0x4(%eax)
  8041bf:	eb 11                	jmp    8041d2 <alloc_block+0x2de>
  8041c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041c4:	c1 e0 04             	shl    $0x4,%eax
  8041c7:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8041cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041d0:	89 02                	mov    %eax,(%edx)
  8041d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041d5:	c1 e0 04             	shl    $0x4,%eax
  8041d8:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8041de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e1:	89 02                	mov    %eax,(%edx)
  8041e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041f0:	c1 e0 04             	shl    $0x4,%eax
  8041f3:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041f8:	8b 00                	mov    (%eax),%eax
  8041fa:	8d 50 01             	lea    0x1(%eax),%edx
  8041fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804200:	c1 e0 04             	shl    $0x4,%eax
  804203:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804208:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80420a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80420d:	01 45 e8             	add    %eax,-0x18(%ebp)
  804210:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  804217:	0f 86 4c ff ff ff    	jbe    804169 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  80421d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804220:	c1 e0 04             	shl    $0x4,%eax
  804223:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804228:	8b 00                	mov    (%eax),%eax
  80422a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  80422d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804231:	75 17                	jne    80424a <alloc_block+0x356>
  804233:	83 ec 04             	sub    $0x4,%esp
  804236:	68 91 52 80 00       	push   $0x805291
  80423b:	68 8d 00 00 00       	push   $0x8d
  804240:	68 f7 51 80 00       	push   $0x8051f7
  804245:	e8 6b c7 ff ff       	call   8009b5 <_panic>
  80424a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80424d:	8b 00                	mov    (%eax),%eax
  80424f:	85 c0                	test   %eax,%eax
  804251:	74 10                	je     804263 <alloc_block+0x36f>
  804253:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804256:	8b 00                	mov    (%eax),%eax
  804258:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80425b:	8b 52 04             	mov    0x4(%edx),%edx
  80425e:	89 50 04             	mov    %edx,0x4(%eax)
  804261:	eb 14                	jmp    804277 <alloc_block+0x383>
  804263:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804266:	8b 40 04             	mov    0x4(%eax),%eax
  804269:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80426c:	c1 e2 04             	shl    $0x4,%edx
  80426f:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804275:	89 02                	mov    %eax,(%edx)
  804277:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80427a:	8b 40 04             	mov    0x4(%eax),%eax
  80427d:	85 c0                	test   %eax,%eax
  80427f:	74 0f                	je     804290 <alloc_block+0x39c>
  804281:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804284:	8b 40 04             	mov    0x4(%eax),%eax
  804287:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80428a:	8b 12                	mov    (%edx),%edx
  80428c:	89 10                	mov    %edx,(%eax)
  80428e:	eb 13                	jmp    8042a3 <alloc_block+0x3af>
  804290:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804293:	8b 00                	mov    (%eax),%eax
  804295:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804298:	c1 e2 04             	shl    $0x4,%edx
  80429b:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8042a1:	89 02                	mov    %eax,(%edx)
  8042a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b9:	c1 e0 04             	shl    $0x4,%eax
  8042bc:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042c1:	8b 00                	mov    (%eax),%eax
  8042c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8042c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042c9:	c1 e0 04             	shl    $0x4,%eax
  8042cc:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042d1:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8042d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042d6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8042da:	48                   	dec    %eax
  8042db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8042de:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  8042e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8042e5:	c9                   	leave  
  8042e6:	c3                   	ret    

008042e7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8042e7:	55                   	push   %ebp
  8042e8:	89 e5                	mov    %esp,%ebp
  8042ea:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8042ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8042f0:	a1 84 60 83 00       	mov    0x836084,%eax
  8042f5:	39 c2                	cmp    %eax,%edx
  8042f7:	72 0c                	jb     804305 <free_block+0x1e>
  8042f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8042fc:	a1 60 e0 81 00       	mov    0x81e060,%eax
  804301:	39 c2                	cmp    %eax,%edx
  804303:	72 19                	jb     80431e <free_block+0x37>
  804305:	68 24 53 80 00       	push   $0x805324
  80430a:	68 5a 52 80 00       	push   $0x80525a
  80430f:	68 98 00 00 00       	push   $0x98
  804314:	68 f7 51 80 00       	push   $0x8051f7
  804319:	e8 97 c6 ff ff       	call   8009b5 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80431e:	8b 45 08             	mov    0x8(%ebp),%eax
  804321:	83 ec 0c             	sub    $0xc,%esp
  804324:	50                   	push   %eax
  804325:	e8 c9 f8 ff ff       	call   803bf3 <to_page_info>
  80432a:	83 c4 10             	add    $0x10,%esp
  80432d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804333:	8b 40 08             	mov    0x8(%eax),%eax
  804336:	0f b7 c0             	movzwl %ax,%eax
  804339:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  80433c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804343:	eb 03                	jmp    804348 <free_block+0x61>
		listIndex++;
  804345:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80434b:	ba 08 00 00 00       	mov    $0x8,%edx
  804350:	88 c1                	mov    %al,%cl
  804352:	d3 e2                	shl    %cl,%edx
  804354:	89 d0                	mov    %edx,%eax
  804356:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804359:	72 ea                	jb     804345 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  80435b:	8b 45 08             	mov    0x8(%ebp),%eax
  80435e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  804361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804365:	75 17                	jne    80437e <free_block+0x97>
  804367:	83 ec 04             	sub    $0x4,%esp
  80436a:	68 00 53 80 00       	push   $0x805300
  80436f:	68 a2 00 00 00       	push   $0xa2
  804374:	68 f7 51 80 00       	push   $0x8051f7
  804379:	e8 37 c6 ff ff       	call   8009b5 <_panic>
  80437e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804381:	c1 e0 04             	shl    $0x4,%eax
  804384:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804389:	8b 10                	mov    (%eax),%edx
  80438b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80438e:	89 10                	mov    %edx,(%eax)
  804390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804393:	8b 00                	mov    (%eax),%eax
  804395:	85 c0                	test   %eax,%eax
  804397:	74 15                	je     8043ae <free_block+0xc7>
  804399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80439c:	c1 e0 04             	shl    $0x4,%eax
  80439f:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8043a4:	8b 00                	mov    (%eax),%eax
  8043a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043a9:	89 50 04             	mov    %edx,0x4(%eax)
  8043ac:	eb 11                	jmp    8043bf <free_block+0xd8>
  8043ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b1:	c1 e0 04             	shl    $0x4,%eax
  8043b4:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8043ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043bd:	89 02                	mov    %eax,(%edx)
  8043bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c2:	c1 e0 04             	shl    $0x4,%eax
  8043c5:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8043cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043ce:	89 02                	mov    %eax,(%edx)
  8043d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043dd:	c1 e0 04             	shl    $0x4,%eax
  8043e0:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8043e5:	8b 00                	mov    (%eax),%eax
  8043e7:	8d 50 01             	lea    0x1(%eax),%edx
  8043ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ed:	c1 e0 04             	shl    $0x4,%eax
  8043f0:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8043f5:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  8043f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043fa:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8043fe:	40                   	inc    %eax
  8043ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804402:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804409:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80440d:	0f b7 c8             	movzwl %ax,%ecx
  804410:	b8 00 10 00 00       	mov    $0x1000,%eax
  804415:	ba 00 00 00 00       	mov    $0x0,%edx
  80441a:	f7 75 e8             	divl   -0x18(%ebp)
  80441d:	39 c1                	cmp    %eax,%ecx
  80441f:	0f 85 ed 01 00 00    	jne    804612 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804428:	c1 e0 04             	shl    $0x4,%eax
  80442b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804430:	8b 00                	mov    (%eax),%eax
  804432:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804435:	eb 2a                	jmp    804461 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  804437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80443a:	83 ec 0c             	sub    $0xc,%esp
  80443d:	50                   	push   %eax
  80443e:	e8 b0 f7 ff ff       	call   803bf3 <to_page_info>
  804443:	83 c4 10             	add    $0x10,%esp
  804446:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804449:	75 06                	jne    804451 <free_block+0x16a>
				tmp = b;
  80444b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80444e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804454:	c1 e0 04             	shl    $0x4,%eax
  804457:	05 a8 60 83 00       	add    $0x8360a8,%eax
  80445c:	8b 00                	mov    (%eax),%eax
  80445e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804461:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804465:	74 07                	je     80446e <free_block+0x187>
  804467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80446a:	8b 00                	mov    (%eax),%eax
  80446c:	eb 05                	jmp    804473 <free_block+0x18c>
  80446e:	b8 00 00 00 00       	mov    $0x0,%eax
  804473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804476:	c1 e2 04             	shl    $0x4,%edx
  804479:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  80447f:	89 02                	mov    %eax,(%edx)
  804481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804484:	c1 e0 04             	shl    $0x4,%eax
  804487:	05 a8 60 83 00       	add    $0x8360a8,%eax
  80448c:	8b 00                	mov    (%eax),%eax
  80448e:	85 c0                	test   %eax,%eax
  804490:	75 a5                	jne    804437 <free_block+0x150>
  804492:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804496:	75 9f                	jne    804437 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80449b:	c1 e0 04             	shl    $0x4,%eax
  80449e:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8044a3:	8b 00                	mov    (%eax),%eax
  8044a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  8044a8:	e9 cc 00 00 00       	jmp    804579 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  8044ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044b0:	8b 00                	mov    (%eax),%eax
  8044b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  8044b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044b8:	83 ec 0c             	sub    $0xc,%esp
  8044bb:	50                   	push   %eax
  8044bc:	e8 32 f7 ff ff       	call   803bf3 <to_page_info>
  8044c1:	83 c4 10             	add    $0x10,%esp
  8044c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8044c7:	0f 85 a6 00 00 00    	jne    804573 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  8044cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044d1:	75 17                	jne    8044ea <free_block+0x203>
  8044d3:	83 ec 04             	sub    $0x4,%esp
  8044d6:	68 91 52 80 00       	push   $0x805291
  8044db:	68 b5 00 00 00       	push   $0xb5
  8044e0:	68 f7 51 80 00       	push   $0x8051f7
  8044e5:	e8 cb c4 ff ff       	call   8009b5 <_panic>
  8044ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044ed:	8b 00                	mov    (%eax),%eax
  8044ef:	85 c0                	test   %eax,%eax
  8044f1:	74 10                	je     804503 <free_block+0x21c>
  8044f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044f6:	8b 00                	mov    (%eax),%eax
  8044f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044fb:	8b 52 04             	mov    0x4(%edx),%edx
  8044fe:	89 50 04             	mov    %edx,0x4(%eax)
  804501:	eb 14                	jmp    804517 <free_block+0x230>
  804503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804506:	8b 40 04             	mov    0x4(%eax),%eax
  804509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80450c:	c1 e2 04             	shl    $0x4,%edx
  80450f:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804515:	89 02                	mov    %eax,(%edx)
  804517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80451a:	8b 40 04             	mov    0x4(%eax),%eax
  80451d:	85 c0                	test   %eax,%eax
  80451f:	74 0f                	je     804530 <free_block+0x249>
  804521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804524:	8b 40 04             	mov    0x4(%eax),%eax
  804527:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80452a:	8b 12                	mov    (%edx),%edx
  80452c:	89 10                	mov    %edx,(%eax)
  80452e:	eb 13                	jmp    804543 <free_block+0x25c>
  804530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804533:	8b 00                	mov    (%eax),%eax
  804535:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804538:	c1 e2 04             	shl    $0x4,%edx
  80453b:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804541:	89 02                	mov    %eax,(%edx)
  804543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80454c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80454f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804559:	c1 e0 04             	shl    $0x4,%eax
  80455c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804561:	8b 00                	mov    (%eax),%eax
  804563:	8d 50 ff             	lea    -0x1(%eax),%edx
  804566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804569:	c1 e0 04             	shl    $0x4,%eax
  80456c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804571:	89 10                	mov    %edx,(%eax)
			b = next;
  804573:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804576:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804579:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80457d:	0f 85 2a ff ff ff    	jne    8044ad <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  804583:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804586:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80458c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80458f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804595:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804599:	75 17                	jne    8045b2 <free_block+0x2cb>
  80459b:	83 ec 04             	sub    $0x4,%esp
  80459e:	68 00 53 80 00       	push   $0x805300
  8045a3:	68 bc 00 00 00       	push   $0xbc
  8045a8:	68 f7 51 80 00       	push   $0x8051f7
  8045ad:	e8 03 c4 ff ff       	call   8009b5 <_panic>
  8045b2:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8045b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045bb:	89 10                	mov    %edx,(%eax)
  8045bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045c0:	8b 00                	mov    (%eax),%eax
  8045c2:	85 c0                	test   %eax,%eax
  8045c4:	74 0d                	je     8045d3 <free_block+0x2ec>
  8045c6:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8045cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045ce:	89 50 04             	mov    %edx,0x4(%eax)
  8045d1:	eb 08                	jmp    8045db <free_block+0x2f4>
  8045d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045d6:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8045db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045de:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8045e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045ed:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8045f2:	40                   	inc    %eax
  8045f3:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  8045f8:	83 ec 0c             	sub    $0xc,%esp
  8045fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8045fe:	e8 7e f5 ff ff       	call   803b81 <to_page_va>
  804603:	83 c4 10             	add    $0x10,%esp
  804606:	83 ec 0c             	sub    $0xc,%esp
  804609:	50                   	push   %eax
  80460a:	e8 fe d7 ff ff       	call   801e0d <return_page>
  80460f:	83 c4 10             	add    $0x10,%esp
	}
}
  804612:	90                   	nop
  804613:	c9                   	leave  
  804614:	c3                   	ret    
  804615:	66 90                	xchg   %ax,%ax
  804617:	90                   	nop

00804618 <__udivdi3>:
  804618:	55                   	push   %ebp
  804619:	57                   	push   %edi
  80461a:	56                   	push   %esi
  80461b:	53                   	push   %ebx
  80461c:	83 ec 1c             	sub    $0x1c,%esp
  80461f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804623:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804627:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80462b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80462f:	89 ca                	mov    %ecx,%edx
  804631:	89 f8                	mov    %edi,%eax
  804633:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804637:	85 f6                	test   %esi,%esi
  804639:	75 2d                	jne    804668 <__udivdi3+0x50>
  80463b:	39 cf                	cmp    %ecx,%edi
  80463d:	77 65                	ja     8046a4 <__udivdi3+0x8c>
  80463f:	89 fd                	mov    %edi,%ebp
  804641:	85 ff                	test   %edi,%edi
  804643:	75 0b                	jne    804650 <__udivdi3+0x38>
  804645:	b8 01 00 00 00       	mov    $0x1,%eax
  80464a:	31 d2                	xor    %edx,%edx
  80464c:	f7 f7                	div    %edi
  80464e:	89 c5                	mov    %eax,%ebp
  804650:	31 d2                	xor    %edx,%edx
  804652:	89 c8                	mov    %ecx,%eax
  804654:	f7 f5                	div    %ebp
  804656:	89 c1                	mov    %eax,%ecx
  804658:	89 d8                	mov    %ebx,%eax
  80465a:	f7 f5                	div    %ebp
  80465c:	89 cf                	mov    %ecx,%edi
  80465e:	89 fa                	mov    %edi,%edx
  804660:	83 c4 1c             	add    $0x1c,%esp
  804663:	5b                   	pop    %ebx
  804664:	5e                   	pop    %esi
  804665:	5f                   	pop    %edi
  804666:	5d                   	pop    %ebp
  804667:	c3                   	ret    
  804668:	39 ce                	cmp    %ecx,%esi
  80466a:	77 28                	ja     804694 <__udivdi3+0x7c>
  80466c:	0f bd fe             	bsr    %esi,%edi
  80466f:	83 f7 1f             	xor    $0x1f,%edi
  804672:	75 40                	jne    8046b4 <__udivdi3+0x9c>
  804674:	39 ce                	cmp    %ecx,%esi
  804676:	72 0a                	jb     804682 <__udivdi3+0x6a>
  804678:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80467c:	0f 87 9e 00 00 00    	ja     804720 <__udivdi3+0x108>
  804682:	b8 01 00 00 00       	mov    $0x1,%eax
  804687:	89 fa                	mov    %edi,%edx
  804689:	83 c4 1c             	add    $0x1c,%esp
  80468c:	5b                   	pop    %ebx
  80468d:	5e                   	pop    %esi
  80468e:	5f                   	pop    %edi
  80468f:	5d                   	pop    %ebp
  804690:	c3                   	ret    
  804691:	8d 76 00             	lea    0x0(%esi),%esi
  804694:	31 ff                	xor    %edi,%edi
  804696:	31 c0                	xor    %eax,%eax
  804698:	89 fa                	mov    %edi,%edx
  80469a:	83 c4 1c             	add    $0x1c,%esp
  80469d:	5b                   	pop    %ebx
  80469e:	5e                   	pop    %esi
  80469f:	5f                   	pop    %edi
  8046a0:	5d                   	pop    %ebp
  8046a1:	c3                   	ret    
  8046a2:	66 90                	xchg   %ax,%ax
  8046a4:	89 d8                	mov    %ebx,%eax
  8046a6:	f7 f7                	div    %edi
  8046a8:	31 ff                	xor    %edi,%edi
  8046aa:	89 fa                	mov    %edi,%edx
  8046ac:	83 c4 1c             	add    $0x1c,%esp
  8046af:	5b                   	pop    %ebx
  8046b0:	5e                   	pop    %esi
  8046b1:	5f                   	pop    %edi
  8046b2:	5d                   	pop    %ebp
  8046b3:	c3                   	ret    
  8046b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046b9:	89 eb                	mov    %ebp,%ebx
  8046bb:	29 fb                	sub    %edi,%ebx
  8046bd:	89 f9                	mov    %edi,%ecx
  8046bf:	d3 e6                	shl    %cl,%esi
  8046c1:	89 c5                	mov    %eax,%ebp
  8046c3:	88 d9                	mov    %bl,%cl
  8046c5:	d3 ed                	shr    %cl,%ebp
  8046c7:	89 e9                	mov    %ebp,%ecx
  8046c9:	09 f1                	or     %esi,%ecx
  8046cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046cf:	89 f9                	mov    %edi,%ecx
  8046d1:	d3 e0                	shl    %cl,%eax
  8046d3:	89 c5                	mov    %eax,%ebp
  8046d5:	89 d6                	mov    %edx,%esi
  8046d7:	88 d9                	mov    %bl,%cl
  8046d9:	d3 ee                	shr    %cl,%esi
  8046db:	89 f9                	mov    %edi,%ecx
  8046dd:	d3 e2                	shl    %cl,%edx
  8046df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046e3:	88 d9                	mov    %bl,%cl
  8046e5:	d3 e8                	shr    %cl,%eax
  8046e7:	09 c2                	or     %eax,%edx
  8046e9:	89 d0                	mov    %edx,%eax
  8046eb:	89 f2                	mov    %esi,%edx
  8046ed:	f7 74 24 0c          	divl   0xc(%esp)
  8046f1:	89 d6                	mov    %edx,%esi
  8046f3:	89 c3                	mov    %eax,%ebx
  8046f5:	f7 e5                	mul    %ebp
  8046f7:	39 d6                	cmp    %edx,%esi
  8046f9:	72 19                	jb     804714 <__udivdi3+0xfc>
  8046fb:	74 0b                	je     804708 <__udivdi3+0xf0>
  8046fd:	89 d8                	mov    %ebx,%eax
  8046ff:	31 ff                	xor    %edi,%edi
  804701:	e9 58 ff ff ff       	jmp    80465e <__udivdi3+0x46>
  804706:	66 90                	xchg   %ax,%ax
  804708:	8b 54 24 08          	mov    0x8(%esp),%edx
  80470c:	89 f9                	mov    %edi,%ecx
  80470e:	d3 e2                	shl    %cl,%edx
  804710:	39 c2                	cmp    %eax,%edx
  804712:	73 e9                	jae    8046fd <__udivdi3+0xe5>
  804714:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804717:	31 ff                	xor    %edi,%edi
  804719:	e9 40 ff ff ff       	jmp    80465e <__udivdi3+0x46>
  80471e:	66 90                	xchg   %ax,%ax
  804720:	31 c0                	xor    %eax,%eax
  804722:	e9 37 ff ff ff       	jmp    80465e <__udivdi3+0x46>
  804727:	90                   	nop

00804728 <__umoddi3>:
  804728:	55                   	push   %ebp
  804729:	57                   	push   %edi
  80472a:	56                   	push   %esi
  80472b:	53                   	push   %ebx
  80472c:	83 ec 1c             	sub    $0x1c,%esp
  80472f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804733:	8b 74 24 34          	mov    0x34(%esp),%esi
  804737:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80473b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80473f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804743:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804747:	89 f3                	mov    %esi,%ebx
  804749:	89 fa                	mov    %edi,%edx
  80474b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80474f:	89 34 24             	mov    %esi,(%esp)
  804752:	85 c0                	test   %eax,%eax
  804754:	75 1a                	jne    804770 <__umoddi3+0x48>
  804756:	39 f7                	cmp    %esi,%edi
  804758:	0f 86 a2 00 00 00    	jbe    804800 <__umoddi3+0xd8>
  80475e:	89 c8                	mov    %ecx,%eax
  804760:	89 f2                	mov    %esi,%edx
  804762:	f7 f7                	div    %edi
  804764:	89 d0                	mov    %edx,%eax
  804766:	31 d2                	xor    %edx,%edx
  804768:	83 c4 1c             	add    $0x1c,%esp
  80476b:	5b                   	pop    %ebx
  80476c:	5e                   	pop    %esi
  80476d:	5f                   	pop    %edi
  80476e:	5d                   	pop    %ebp
  80476f:	c3                   	ret    
  804770:	39 f0                	cmp    %esi,%eax
  804772:	0f 87 ac 00 00 00    	ja     804824 <__umoddi3+0xfc>
  804778:	0f bd e8             	bsr    %eax,%ebp
  80477b:	83 f5 1f             	xor    $0x1f,%ebp
  80477e:	0f 84 ac 00 00 00    	je     804830 <__umoddi3+0x108>
  804784:	bf 20 00 00 00       	mov    $0x20,%edi
  804789:	29 ef                	sub    %ebp,%edi
  80478b:	89 fe                	mov    %edi,%esi
  80478d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804791:	89 e9                	mov    %ebp,%ecx
  804793:	d3 e0                	shl    %cl,%eax
  804795:	89 d7                	mov    %edx,%edi
  804797:	89 f1                	mov    %esi,%ecx
  804799:	d3 ef                	shr    %cl,%edi
  80479b:	09 c7                	or     %eax,%edi
  80479d:	89 e9                	mov    %ebp,%ecx
  80479f:	d3 e2                	shl    %cl,%edx
  8047a1:	89 14 24             	mov    %edx,(%esp)
  8047a4:	89 d8                	mov    %ebx,%eax
  8047a6:	d3 e0                	shl    %cl,%eax
  8047a8:	89 c2                	mov    %eax,%edx
  8047aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047ae:	d3 e0                	shl    %cl,%eax
  8047b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047b8:	89 f1                	mov    %esi,%ecx
  8047ba:	d3 e8                	shr    %cl,%eax
  8047bc:	09 d0                	or     %edx,%eax
  8047be:	d3 eb                	shr    %cl,%ebx
  8047c0:	89 da                	mov    %ebx,%edx
  8047c2:	f7 f7                	div    %edi
  8047c4:	89 d3                	mov    %edx,%ebx
  8047c6:	f7 24 24             	mull   (%esp)
  8047c9:	89 c6                	mov    %eax,%esi
  8047cb:	89 d1                	mov    %edx,%ecx
  8047cd:	39 d3                	cmp    %edx,%ebx
  8047cf:	0f 82 87 00 00 00    	jb     80485c <__umoddi3+0x134>
  8047d5:	0f 84 91 00 00 00    	je     80486c <__umoddi3+0x144>
  8047db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047df:	29 f2                	sub    %esi,%edx
  8047e1:	19 cb                	sbb    %ecx,%ebx
  8047e3:	89 d8                	mov    %ebx,%eax
  8047e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8047e9:	d3 e0                	shl    %cl,%eax
  8047eb:	89 e9                	mov    %ebp,%ecx
  8047ed:	d3 ea                	shr    %cl,%edx
  8047ef:	09 d0                	or     %edx,%eax
  8047f1:	89 e9                	mov    %ebp,%ecx
  8047f3:	d3 eb                	shr    %cl,%ebx
  8047f5:	89 da                	mov    %ebx,%edx
  8047f7:	83 c4 1c             	add    $0x1c,%esp
  8047fa:	5b                   	pop    %ebx
  8047fb:	5e                   	pop    %esi
  8047fc:	5f                   	pop    %edi
  8047fd:	5d                   	pop    %ebp
  8047fe:	c3                   	ret    
  8047ff:	90                   	nop
  804800:	89 fd                	mov    %edi,%ebp
  804802:	85 ff                	test   %edi,%edi
  804804:	75 0b                	jne    804811 <__umoddi3+0xe9>
  804806:	b8 01 00 00 00       	mov    $0x1,%eax
  80480b:	31 d2                	xor    %edx,%edx
  80480d:	f7 f7                	div    %edi
  80480f:	89 c5                	mov    %eax,%ebp
  804811:	89 f0                	mov    %esi,%eax
  804813:	31 d2                	xor    %edx,%edx
  804815:	f7 f5                	div    %ebp
  804817:	89 c8                	mov    %ecx,%eax
  804819:	f7 f5                	div    %ebp
  80481b:	89 d0                	mov    %edx,%eax
  80481d:	e9 44 ff ff ff       	jmp    804766 <__umoddi3+0x3e>
  804822:	66 90                	xchg   %ax,%ax
  804824:	89 c8                	mov    %ecx,%eax
  804826:	89 f2                	mov    %esi,%edx
  804828:	83 c4 1c             	add    $0x1c,%esp
  80482b:	5b                   	pop    %ebx
  80482c:	5e                   	pop    %esi
  80482d:	5f                   	pop    %edi
  80482e:	5d                   	pop    %ebp
  80482f:	c3                   	ret    
  804830:	3b 04 24             	cmp    (%esp),%eax
  804833:	72 06                	jb     80483b <__umoddi3+0x113>
  804835:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804839:	77 0f                	ja     80484a <__umoddi3+0x122>
  80483b:	89 f2                	mov    %esi,%edx
  80483d:	29 f9                	sub    %edi,%ecx
  80483f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804843:	89 14 24             	mov    %edx,(%esp)
  804846:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80484a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80484e:	8b 14 24             	mov    (%esp),%edx
  804851:	83 c4 1c             	add    $0x1c,%esp
  804854:	5b                   	pop    %ebx
  804855:	5e                   	pop    %esi
  804856:	5f                   	pop    %edi
  804857:	5d                   	pop    %ebp
  804858:	c3                   	ret    
  804859:	8d 76 00             	lea    0x0(%esi),%esi
  80485c:	2b 04 24             	sub    (%esp),%eax
  80485f:	19 fa                	sbb    %edi,%edx
  804861:	89 d1                	mov    %edx,%ecx
  804863:	89 c6                	mov    %eax,%esi
  804865:	e9 71 ff ff ff       	jmp    8047db <__umoddi3+0xb3>
  80486a:	66 90                	xchg   %ax,%ax
  80486c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804870:	72 ea                	jb     80485c <__umoddi3+0x134>
  804872:	89 d9                	mov    %ebx,%ecx
  804874:	e9 62 ff ff ff       	jmp    8047db <__umoddi3+0xb3>
