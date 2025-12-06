
obj/user/matrix_operations:     file format elf32-i386


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
  800031:	e8 de 09 00 00       	call   800a14 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements);
int64** MatrixAddition(int **M1, int **M2, int NumOfElements);
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Line[255] ;
	char Chose ;
	int val =0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int NumOfElements = 3;
  800049:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	do
	{
		val = 0;
  800050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		NumOfElements = 3;
  800057:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80005e:	e8 03 36 00 00       	call   803666 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 a0 4a 80 00       	push   $0x804aa0
  80006b:	e8 34 0c 00 00       	call   800ca4 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 a4 4a 80 00       	push   $0x804aa4
  80007b:	e8 24 0c 00 00       	call   800ca4 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 c8 4a 80 00       	push   $0x804ac8
  80008b:	e8 14 0c 00 00       	call   800ca4 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 a4 4a 80 00       	push   $0x804aa4
  80009b:	e8 04 0c 00 00       	call   800ca4 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 a0 4a 80 00       	push   $0x804aa0
  8000ab:	e8 f4 0b 00 00       	call   800ca4 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 ec 4a 80 00       	push   $0x804aec
  8000c2:	e8 b6 12 00 00       	call   80137d <readline>
  8000c7:	83 c4 10             	add    $0x10,%esp
		NumOfElements = strtol(Line, NULL, 10) ;
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 0a                	push   $0xa
  8000cf:	6a 00                	push   $0x0
  8000d1:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000d7:	50                   	push   %eax
  8000d8:	e8 b7 18 00 00       	call   801994 <strtol>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	68 0c 4b 80 00       	push   $0x804b0c
  8000eb:	e8 b4 0b 00 00       	call   800ca4 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 2e 4b 80 00       	push   $0x804b2e
  8000fb:	e8 a4 0b 00 00       	call   800ca4 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 3c 4b 80 00       	push   $0x804b3c
  80010b:	e8 94 0b 00 00       	call   800ca4 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 4a 4b 80 00       	push   $0x804b4a
  80011b:	e8 84 0b 00 00       	call   800ca4 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 5a 4b 80 00       	push   $0x804b5a
  80012b:	e8 74 0b 00 00       	call   800ca4 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800133:	e8 bf 08 00 00       	call   8009f7 <getchar>
  800138:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80013b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	50                   	push   %eax
  800143:	e8 90 08 00 00       	call   8009d8 <cputchar>
  800148:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	6a 0a                	push   $0xa
  800150:	e8 83 08 00 00       	call   8009d8 <cputchar>
  800155:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800158:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  80015c:	74 0c                	je     80016a <_main+0x132>
  80015e:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800162:	74 06                	je     80016a <_main+0x132>
  800164:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800168:	75 b9                	jne    800123 <_main+0xeb>

		if (Chose == 'b')
  80016a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80016e:	75 30                	jne    8001a0 <_main+0x168>
		{
			readline("Enter the value to be initialized: ", Line);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	68 64 4b 80 00       	push   $0x804b64
  80017f:	e8 f9 11 00 00       	call   80137d <readline>
  800184:	83 c4 10             	add    $0x10,%esp
			val = strtol(Line, NULL, 10) ;
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	6a 0a                	push   $0xa
  80018c:	6a 00                	push   $0x0
  80018e:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 fa 17 00 00       	call   801994 <strtol>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		//2012: lock the interrupt
		sys_unlock_cons();
  8001a0:	e8 db 34 00 00       	call   803680 <sys_unlock_cons>

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	c1 e0 02             	shl    $0x2,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	e8 ba 1c 00 00       	call   801e6e <malloc>
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int **M2 = malloc(sizeof(int) * NumOfElements) ;
  8001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001bd:	c1 e0 02             	shl    $0x2,%eax
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	e8 a5 1c 00 00       	call   801e6e <malloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (int i = 0; i < NumOfElements; ++i)
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	eb 4b                	jmp    800223 <_main+0x1eb>
		{
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
  8001d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8001e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001eb:	c1 e0 02             	shl    $0x2,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 77 1c 00 00       	call   801e6e <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 03                	mov    %eax,(%ebx)
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
  8001fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800206:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800209:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	e8 53 1c 00 00       	call   801e6e <malloc>
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	89 03                	mov    %eax,(%ebx)
		sys_unlock_cons();

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
		int **M2 = malloc(sizeof(int) * NumOfElements) ;

		for (int i = 0; i < NumOfElements; ++i)
  800220:	ff 45 f0             	incl   -0x10(%ebp)
  800223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800226:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800229:	7c ad                	jl     8001d8 <_main+0x1a0>
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
		}

		int  i ;
		switch (Chose)
  80022b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80022f:	83 f8 62             	cmp    $0x62,%eax
  800232:	74 2e                	je     800262 <_main+0x22a>
  800234:	83 f8 63             	cmp    $0x63,%eax
  800237:	74 53                	je     80028c <_main+0x254>
  800239:	83 f8 61             	cmp    $0x61,%eax
  80023c:	75 72                	jne    8002b0 <_main+0x278>
		{
		case 'a':
			InitializeAscending(M1, NumOfElements);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	ff 75 e4             	pushl  -0x1c(%ebp)
  800244:	ff 75 dc             	pushl  -0x24(%ebp)
  800247:	e8 9b 05 00 00       	call   8007e7 <InitializeAscending>
  80024c:	83 c4 10             	add    $0x10,%esp
			InitializeAscending(M2, NumOfElements);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	e8 8a 05 00 00       	call   8007e7 <InitializeAscending>
  80025d:	83 c4 10             	add    $0x10,%esp
			break ;
  800260:	eb 70                	jmp    8002d2 <_main+0x29a>
		case 'b':
			InitializeIdentical(M1, NumOfElements, val);
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 f4             	pushl  -0xc(%ebp)
  800268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026b:	ff 75 dc             	pushl  -0x24(%ebp)
  80026e:	e8 c3 05 00 00       	call   800836 <InitializeIdentical>
  800273:	83 c4 10             	add    $0x10,%esp
			InitializeIdentical(M2, NumOfElements, val);
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	ff 75 f4             	pushl  -0xc(%ebp)
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	ff 75 d8             	pushl  -0x28(%ebp)
  800282:	e8 af 05 00 00       	call   800836 <InitializeIdentical>
  800287:	83 c4 10             	add    $0x10,%esp
			break ;
  80028a:	eb 46                	jmp    8002d2 <_main+0x29a>
		case 'c':
			InitializeSemiRandom(M1, NumOfElements);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	e8 eb 05 00 00       	call   800885 <InitializeSemiRandom>
  80029a:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 da 05 00 00       	call   800885 <InitializeSemiRandom>
  8002ab:	83 c4 10             	add    $0x10,%esp
			//PrintElements(M1, NumOfElements);
			break ;
  8002ae:	eb 22                	jmp    8002d2 <_main+0x29a>
		default:
			InitializeSemiRandom(M1, NumOfElements);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	e8 c7 05 00 00       	call   800885 <InitializeSemiRandom>
  8002be:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	e8 b6 05 00 00       	call   800885 <InitializeSemiRandom>
  8002cf:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
  8002d2:	e8 8f 33 00 00       	call   803666 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 88 4b 80 00       	push   $0x804b88
  8002df:	e8 c0 09 00 00       	call   800ca4 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 a6 4b 80 00       	push   $0x804ba6
  8002ef:	e8 b0 09 00 00       	call   800ca4 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 bd 4b 80 00       	push   $0x804bbd
  8002ff:	e8 a0 09 00 00       	call   800ca4 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 d4 4b 80 00       	push   $0x804bd4
  80030f:	e8 90 09 00 00       	call   800ca4 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 5a 4b 80 00       	push   $0x804b5a
  80031f:	e8 80 09 00 00       	call   800ca4 <cprintf>
  800324:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800327:	e8 cb 06 00 00       	call   8009f7 <getchar>
  80032c:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80032f:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	50                   	push   %eax
  800337:	e8 9c 06 00 00       	call   8009d8 <cputchar>
  80033c:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	6a 0a                	push   $0xa
  800344:	e8 8f 06 00 00       	call   8009d8 <cputchar>
  800349:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80034c:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800350:	74 0c                	je     80035e <_main+0x326>
  800352:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800356:	74 06                	je     80035e <_main+0x326>
  800358:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  80035c:	75 b9                	jne    800317 <_main+0x2df>
		sys_unlock_cons();
  80035e:	e8 1d 33 00 00       	call   803680 <sys_unlock_cons>


		int64** Res = NULL ;
  800363:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		switch (Chose)
  80036a:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80036e:	83 f8 62             	cmp    $0x62,%eax
  800371:	74 23                	je     800396 <_main+0x35e>
  800373:	83 f8 63             	cmp    $0x63,%eax
  800376:	74 37                	je     8003af <_main+0x377>
  800378:	83 f8 61             	cmp    $0x61,%eax
  80037b:	75 4b                	jne    8003c8 <_main+0x390>
		{
		case 'a':
			Res = MatrixAddition(M1, M2, NumOfElements);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	ff 75 e4             	pushl  -0x1c(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	ff 75 dc             	pushl  -0x24(%ebp)
  800389:	e8 9f 02 00 00       	call   80062d <MatrixAddition>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  800394:	eb 49                	jmp    8003df <_main+0x3a7>
		case 'b':
			Res = MatrixSubtraction(M1, M2, NumOfElements);
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039c:	ff 75 d8             	pushl  -0x28(%ebp)
  80039f:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a2:	e8 62 03 00 00       	call   800709 <MatrixSubtraction>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003ad:	eb 30                	jmp    8003df <_main+0x3a7>
		case 'c':
			Res = MatrixMultiply(M1, M2, NumOfElements);
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003bb:	e8 1d 01 00 00       	call   8004dd <MatrixMultiply>
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003c6:	eb 17                	jmp    8003df <_main+0x3a7>
		default:
			Res = MatrixAddition(M1, M2, NumOfElements);
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d4:	e8 54 02 00 00       	call   80062d <MatrixAddition>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
		}


		sys_lock_cons();
  8003df:	e8 82 32 00 00       	call   803666 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 eb 4b 80 00       	push   $0x804beb
  8003ec:	e8 b3 08 00 00       	call   800ca4 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 87 32 00 00       	call   803680 <sys_unlock_cons>

		for (int i = 0; i < NumOfElements; ++i)
  8003f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800400:	eb 5a                	jmp    80045c <_main+0x424>
		{
			free(M1[i]);
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	50                   	push   %eax
  800417:	e8 b2 1d 00 00       	call   8021ce <free>
  80041c:	83 c4 10             	add    $0x10,%esp
			free(M2[i]);
  80041f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	50                   	push   %eax
  800434:	e8 95 1d 00 00       	call   8021ce <free>
  800439:	83 c4 10             	add    $0x10,%esp
			free(Res[i]);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	50                   	push   %eax
  800451:	e8 78 1d 00 00       	call   8021ce <free>
  800456:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
		cprintf("Operation is COMPLETED.\n");
		sys_unlock_cons();

		for (int i = 0; i < NumOfElements; ++i)
  800459:	ff 45 e8             	incl   -0x18(%ebp)
  80045c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800462:	7c 9e                	jl     800402 <_main+0x3ca>
		{
			free(M1[i]);
			free(M2[i]);
			free(Res[i]);
		}
		free(M1) ;
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	ff 75 dc             	pushl  -0x24(%ebp)
  80046a:	e8 5f 1d 00 00       	call   8021ce <free>
  80046f:	83 c4 10             	add    $0x10,%esp
		free(M2) ;
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	e8 51 1d 00 00       	call   8021ce <free>
  80047d:	83 c4 10             	add    $0x10,%esp
		free(Res) ;
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 ec             	pushl  -0x14(%ebp)
  800486:	e8 43 1d 00 00       	call   8021ce <free>
  80048b:	83 c4 10             	add    $0x10,%esp


		sys_lock_cons();
  80048e:	e8 d3 31 00 00       	call   803666 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 04 4c 80 00       	push   $0x804c04
  80049b:	e8 04 08 00 00       	call   800ca4 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  8004a3:	e8 4f 05 00 00       	call   8009f7 <getchar>
  8004a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
		cputchar(Chose);
  8004ab:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	50                   	push   %eax
  8004b3:	e8 20 05 00 00       	call   8009d8 <cputchar>
  8004b8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	6a 0a                	push   $0xa
  8004c0:	e8 13 05 00 00       	call   8009d8 <cputchar>
  8004c5:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8004c8:	e8 b3 31 00 00       	call   803680 <sys_unlock_cons>

	} while (Chose == 'y');
  8004cd:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8004d1:	0f 84 79 fb ff ff    	je     800050 <_main+0x18>

}
  8004d7:	90                   	nop
  8004d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <MatrixMultiply>:

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 2c             	sub    $0x2c,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  8004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e9:	c1 e0 03             	shl    $0x3,%eax
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	50                   	push   %eax
  8004f0:	e8 79 19 00 00       	call   801e6e <malloc>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  8004fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800502:	eb 27                	jmp    80052b <MatrixMultiply+0x4e>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	c1 e0 03             	shl    $0x3,%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 4b 19 00 00       	call   801e6e <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 03                	mov    %eax,(%ebx)

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800528:	ff 45 e4             	incl   -0x1c(%ebp)
  80052b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800531:	7c d1                	jl     800504 <MatrixMultiply+0x27>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80053a:	e9 d7 00 00 00       	jmp    800616 <MatrixMultiply+0x139>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80053f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800546:	e9 bc 00 00 00       	jmp    800607 <MatrixMultiply+0x12a>
		{
			Res[i][j] = 0 ;
  80054b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055f:	c1 e2 03             	shl    $0x3,%edx
  800562:	01 d0                	add    %edx,%eax
  800564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80056a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			for (int k = 0; k < NumOfElements; ++k)
  800571:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800578:	eb 7e                	jmp    8005f8 <MatrixMultiply+0x11b>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
  80057a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058e:	c1 e2 03             	shl    $0x3,%edx
  800591:	8d 34 10             	lea    (%eax,%edx,1),%esi
  800594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005a8:	c1 e2 03             	shl    $0x3,%edx
  8005ab:	01 d0                	add    %edx,%eax
  8005ad:	8b 08                	mov    (%eax),%ecx
  8005af:	8b 58 04             	mov    0x4(%eax),%ebx
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c6:	c1 e2 02             	shl    $0x2,%edx
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d0:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	01 f8                	add    %edi,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005e1:	c1 e7 02             	shl    $0x2,%edi
  8005e4:	01 f8                	add    %edi,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	0f af c2             	imul   %edx,%eax
  8005eb:	99                   	cltd   
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	11 da                	adc    %ebx,%edx
  8005f0:	89 06                	mov    %eax,(%esi)
  8005f2:	89 56 04             	mov    %edx,0x4(%esi)
	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = 0 ;
			for (int k = 0; k < NumOfElements; ++k)
  8005f5:	ff 45 d8             	incl   -0x28(%ebp)
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8005fe:	0f 8c 76 ff ff ff    	jl     80057a <MatrixMultiply+0x9d>
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  800604:	ff 45 dc             	incl   -0x24(%ebp)
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80060d:	0f 8c 38 ff ff ff    	jl     80054b <MatrixMultiply+0x6e>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800613:	ff 45 e0             	incl   -0x20(%ebp)
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	3b 45 10             	cmp    0x10(%ebp),%eax
  80061c:	0f 8c 1d ff ff ff    	jl     80053f <MatrixMultiply+0x62>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
			}
		}
	}
	return Res;
  800622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800625:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800628:	5b                   	pop    %ebx
  800629:	5e                   	pop    %esi
  80062a:	5f                   	pop    %edi
  80062b:	5d                   	pop    %ebp
  80062c:	c3                   	ret    

0080062d <MatrixAddition>:

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	53                   	push   %ebx
  800631:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800634:	8b 45 10             	mov    0x10(%ebp),%eax
  800637:	c1 e0 03             	shl    $0x3,%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	50                   	push   %eax
  80063e:	e8 2b 18 00 00       	call   801e6e <malloc>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800650:	eb 27                	jmp    800679 <MatrixAddition+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800655:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800662:	8b 45 10             	mov    0x10(%ebp),%eax
  800665:	c1 e0 03             	shl    $0x3,%eax
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	50                   	push   %eax
  80066c:	e8 fd 17 00 00       	call   801e6e <malloc>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 03                	mov    %eax,(%ebx)

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800676:	ff 45 f4             	incl   -0xc(%ebp)
  800679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80067f:	7c d1                	jl     800652 <MatrixAddition+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	eb 6f                	jmp    8006f9 <MatrixAddition+0xcc>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80068a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800691:	eb 5b                	jmp    8006ee <MatrixAddition+0xc1>
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
  800693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006a0:	01 d0                	add    %edx,%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006a7:	c1 e2 03             	shl    $0x3,%edx
  8006aa:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006c1:	c1 e2 02             	shl    $0x2,%edx
  8006c4:	01 d0                	add    %edx,%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	01 d8                	add    %ebx,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8006dc:	c1 e3 02             	shl    $0x2,%ebx
  8006df:	01 d8                	add    %ebx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	99                   	cltd   
  8006e6:	89 01                	mov    %eax,(%ecx)
  8006e8:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8006eb:	ff 45 ec             	incl   -0x14(%ebp)
  8006ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006f4:	7c 9d                	jl     800693 <MatrixAddition+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8006f6:	ff 45 f0             	incl   -0x10(%ebp)
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006ff:	7c 89                	jl     80068a <MatrixAddition+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
		}
	}
	return Res;
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  800704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <MatrixSubtraction>:

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	53                   	push   %ebx
  80070d:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800710:	8b 45 10             	mov    0x10(%ebp),%eax
  800713:	c1 e0 03             	shl    $0x3,%eax
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	50                   	push   %eax
  80071a:	e8 4f 17 00 00       	call   801e6e <malloc>
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80072c:	eb 27                	jmp    800755 <MatrixSubtraction+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  80072e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800731:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	c1 e0 03             	shl    $0x3,%eax
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	50                   	push   %eax
  800748:	e8 21 17 00 00       	call   801e6e <malloc>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 03                	mov    %eax,(%ebx)

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800752:	ff 45 f4             	incl   -0xc(%ebp)
  800755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800758:	3b 45 10             	cmp    0x10(%ebp),%eax
  80075b:	7c d1                	jl     80072e <MatrixSubtraction+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  80075d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800764:	eb 71                	jmp    8007d7 <MatrixSubtraction+0xce>
	{
		for (int j = 0; j < NumOfElements; ++j)
  800766:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80076d:	eb 5d                	jmp    8007cc <MatrixSubtraction+0xc3>
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80077c:	01 d0                	add    %edx,%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800783:	c1 e2 03             	shl    $0x3,%edx
  800786:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80079d:	c1 e2 02             	shl    $0x2,%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a7:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	01 d8                	add    %ebx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8007b8:	c1 e3 02             	shl    $0x2,%ebx
  8007bb:	01 d8                	add    %ebx,%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	29 c2                	sub    %eax,%edx
  8007c1:	89 d0                	mov    %edx,%eax
  8007c3:	99                   	cltd   
  8007c4:	89 01                	mov    %eax,(%ecx)
  8007c6:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8007c9:	ff 45 ec             	incl   -0x14(%ebp)
  8007cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007d2:	7c 9b                	jl     80076f <MatrixSubtraction+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8007d4:	ff 45 f0             	incl   -0x10(%ebp)
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007dd:	7c 87                	jl     800766 <MatrixSubtraction+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
		}
	}
	return Res;
  8007df:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8007e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <InitializeAscending>:

///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8007f4:	eb 35                	jmp    80082b <InitializeAscending+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8007f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8007fd:	eb 21                	jmp    800820 <InitializeAscending+0x39>
		{
			(Elements)[i][j] = j ;
  8007ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800802:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800813:	c1 e2 02             	shl    $0x2,%edx
  800816:	01 c2                	add    %eax,%edx
  800818:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80081b:	89 02                	mov    %eax,(%edx)
void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80081d:	ff 45 f8             	incl   -0x8(%ebp)
  800820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800823:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800826:	7c d7                	jl     8007ff <InitializeAscending+0x18>
///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800828:	ff 45 fc             	incl   -0x4(%ebp)
  80082b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80082e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800831:	7c c3                	jl     8007f6 <InitializeAscending+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = j ;
		}
	}
}
  800833:	90                   	nop
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <InitializeIdentical>:

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80083c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800843:	eb 35                	jmp    80087a <InitializeIdentical+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800845:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80084c:	eb 21                	jmp    80086f <InitializeIdentical+0x39>
		{
			(Elements)[i][j] = value ;
  80084e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800851:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800862:	c1 e2 02             	shl    $0x2,%edx
  800865:	01 c2                	add    %eax,%edx
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	89 02                	mov    %eax,(%edx)
void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80086c:	ff 45 f8             	incl   -0x8(%ebp)
  80086f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800872:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800875:	7c d7                	jl     80084e <InitializeIdentical+0x18>
}

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800877:	ff 45 fc             	incl   -0x4(%ebp)
  80087a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80087d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800880:	7c c3                	jl     800845 <InitializeIdentical+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = value ;
		}
	}
}
  800882:	90                   	nop
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <InitializeSemiRandom>:

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 20             	sub    $0x20,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80088c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800893:	eb 56                	jmp    8008eb <InitializeSemiRandom+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80089c:	eb 42                	jmp    8008e0 <InitializeSemiRandom+0x5b>
		{
			(Elements)[i][j] =  RANDU(0, NumOfElements) ;
  80089e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b2:	c1 e2 02             	shl    $0x2,%edx
  8008b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8008b8:	0f 31                	rdtsc  
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	89 55 e8             	mov    %edx,-0x18(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8008c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8008cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	f7 f3                	div    %ebx
  8008d9:	89 d0                	mov    %edx,%eax
  8008db:	89 01                	mov    %eax,(%ecx)
void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8008dd:	ff 45 f4             	incl   -0xc(%ebp)
  8008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008e6:	7c b6                	jl     80089e <InitializeSemiRandom+0x19>
}

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8008e8:	ff 45 f8             	incl   -0x8(%ebp)
  8008eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f1:	7c a2                	jl     800895 <InitializeSemiRandom+0x10>
		{
			(Elements)[i][j] =  RANDU(0, NumOfElements) ;
			//	cprintf("i=%d\n",i);
		}
	}
}
  8008f3:	90                   	nop
  8008f4:	83 c4 20             	add    $0x20,%esp
  8008f7:	5b                   	pop    %ebx
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <PrintElements>:

void PrintElements(int **Elements, int NumOfElements)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800907:	eb 53                	jmp    80095c <PrintElements+0x62>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800909:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800910:	eb 2f                	jmp    800941 <PrintElements+0x47>
		{
			cprintf("%~%d, ",Elements[i][j]);
  800912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800915:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800926:	c1 e2 02             	shl    $0x2,%edx
  800929:	01 d0                	add    %edx,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	50                   	push   %eax
  800931:	68 22 4c 80 00       	push   $0x804c22
  800936:	e8 69 03 00 00       	call   800ca4 <cprintf>
  80093b:	83 c4 10             	add    $0x10,%esp
void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80093e:	ff 45 f0             	incl   -0x10(%ebp)
  800941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800944:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800947:	7c c9                	jl     800912 <PrintElements+0x18>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
  800949:	83 ec 0c             	sub    $0xc,%esp
  80094c:	68 29 4c 80 00       	push   $0x804c29
  800951:	e8 4e 03 00 00       	call   800ca4 <cprintf>
  800956:	83 c4 10             	add    $0x10,%esp
}

void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800959:	ff 45 f4             	incl   -0xc(%ebp)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800962:	7c a5                	jl     800909 <PrintElements+0xf>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <PrintElements64>:

void PrintElements64(int64 **Elements, int NumOfElements)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80096d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800974:	eb 57                	jmp    8009cd <PrintElements64+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800976:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097d:	eb 33                	jmp    8009b2 <PrintElements64+0x4b>
		{
			cprintf("%~%lld, ",Elements[i][j]);
  80097f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800982:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	01 d0                	add    %edx,%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800993:	c1 e2 03             	shl    $0x3,%edx
  800996:	01 d0                	add    %edx,%eax
  800998:	8b 50 04             	mov    0x4(%eax),%edx
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	52                   	push   %edx
  8009a1:	50                   	push   %eax
  8009a2:	68 2d 4c 80 00       	push   $0x804c2d
  8009a7:	e8 f8 02 00 00       	call   800ca4 <cprintf>
  8009ac:	83 c4 10             	add    $0x10,%esp
void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8009af:	ff 45 f0             	incl   -0x10(%ebp)
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b8:	7c c5                	jl     80097f <PrintElements64+0x18>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
  8009ba:	83 ec 0c             	sub    $0xc,%esp
  8009bd:	68 29 4c 80 00       	push   $0x804c29
  8009c2:	e8 dd 02 00 00       	call   800ca4 <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
}

void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8009ca:	ff 45 f4             	incl   -0xc(%ebp)
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009d3:	7c a1                	jl     800976 <PrintElements64+0xf>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  8009d5:	90                   	nop
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8009e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8009e8:	83 ec 0c             	sub    $0xc,%esp
  8009eb:	50                   	push   %eax
  8009ec:	e8 bd 2d 00 00       	call   8037ae <sys_cputc>
  8009f1:	83 c4 10             	add    $0x10,%esp
}
  8009f4:	90                   	nop
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <getchar>:


int
getchar(void)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8009fd:	e8 4b 2c 00 00       	call   80364d <sys_cgetc>
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <iscons>:

int iscons(int fdnum)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800a0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800a1d:	e8 bd 2e 00 00       	call   8038df <sys_getenvindex>
  800a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	c1 e0 03             	shl    $0x3,%eax
  800a2d:	01 d0                	add    %edx,%eax
  800a2f:	c1 e0 02             	shl    $0x2,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a45:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a4a:	a1 20 60 80 00       	mov    0x806020,%eax
  800a4f:	8a 40 20             	mov    0x20(%eax),%al
  800a52:	84 c0                	test   %al,%al
  800a54:	74 0d                	je     800a63 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800a56:	a1 20 60 80 00       	mov    0x806020,%eax
  800a5b:	83 c0 20             	add    $0x20,%eax
  800a5e:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a67:	7e 0a                	jle    800a73 <libmain+0x5f>
		binaryname = argv[0];
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	ff 75 08             	pushl  0x8(%ebp)
  800a7c:	e8 b7 f5 ff ff       	call   800038 <_main>
  800a81:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800a84:	a1 00 60 80 00       	mov    0x806000,%eax
  800a89:	85 c0                	test   %eax,%eax
  800a8b:	0f 84 01 01 00 00    	je     800b92 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800a91:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800a97:	bb 30 4d 80 00       	mov    $0x804d30,%ebx
  800a9c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800aa1:	89 c7                	mov    %eax,%edi
  800aa3:	89 de                	mov    %ebx,%esi
  800aa5:	89 d1                	mov    %edx,%ecx
  800aa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800aa9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800aac:	b9 56 00 00 00       	mov    $0x56,%ecx
  800ab1:	b0 00                	mov    $0x0,%al
  800ab3:	89 d7                	mov    %edx,%edi
  800ab5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800ab7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800abe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	50                   	push   %eax
  800ac5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800acb:	50                   	push   %eax
  800acc:	e8 44 30 00 00       	call   803b15 <sys_utilities>
  800ad1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800ad4:	e8 8d 2b 00 00       	call   803666 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800ad9:	83 ec 0c             	sub    $0xc,%esp
  800adc:	68 50 4c 80 00       	push   $0x804c50
  800ae1:	e8 be 01 00 00       	call   800ca4 <cprintf>
  800ae6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aec:	85 c0                	test   %eax,%eax
  800aee:	74 18                	je     800b08 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800af0:	e8 3e 30 00 00       	call   803b33 <sys_get_optimal_num_faults>
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	50                   	push   %eax
  800af9:	68 78 4c 80 00       	push   $0x804c78
  800afe:	e8 a1 01 00 00       	call   800ca4 <cprintf>
  800b03:	83 c4 10             	add    $0x10,%esp
  800b06:	eb 59                	jmp    800b61 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b08:	a1 20 60 80 00       	mov    0x806020,%eax
  800b0d:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800b13:	a1 20 60 80 00       	mov    0x806020,%eax
  800b18:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	50                   	push   %eax
  800b23:	68 9c 4c 80 00       	push   $0x804c9c
  800b28:	e8 77 01 00 00       	call   800ca4 <cprintf>
  800b2d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800b30:	a1 20 60 80 00       	mov    0x806020,%eax
  800b35:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800b3b:	a1 20 60 80 00       	mov    0x806020,%eax
  800b40:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800b46:	a1 20 60 80 00       	mov    0x806020,%eax
  800b4b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800b51:	51                   	push   %ecx
  800b52:	52                   	push   %edx
  800b53:	50                   	push   %eax
  800b54:	68 c4 4c 80 00       	push   $0x804cc4
  800b59:	e8 46 01 00 00       	call   800ca4 <cprintf>
  800b5e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800b61:	a1 20 60 80 00       	mov    0x806020,%eax
  800b66:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	50                   	push   %eax
  800b70:	68 1c 4d 80 00       	push   $0x804d1c
  800b75:	e8 2a 01 00 00       	call   800ca4 <cprintf>
  800b7a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800b7d:	83 ec 0c             	sub    $0xc,%esp
  800b80:	68 50 4c 80 00       	push   $0x804c50
  800b85:	e8 1a 01 00 00       	call   800ca4 <cprintf>
  800b8a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800b8d:	e8 ee 2a 00 00       	call   803680 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800b92:	e8 1f 00 00 00       	call   800bb6 <exit>
}
  800b97:	90                   	nop
  800b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	6a 00                	push   $0x0
  800bab:	e8 fb 2c 00 00       	call   8038ab <sys_destroy_env>
  800bb0:	83 c4 10             	add    $0x10,%esp
}
  800bb3:	90                   	nop
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <exit>:

void
exit(void)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800bbc:	e8 50 2d 00 00       	call   803911 <sys_exit_env>
}
  800bc1:	90                   	nop
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	53                   	push   %ebx
  800bc8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	8b 00                	mov    (%eax),%eax
  800bd0:	8d 48 01             	lea    0x1(%eax),%ecx
  800bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd6:	89 0a                	mov    %ecx,(%edx)
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	88 d1                	mov    %dl,%cl
  800bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bee:	75 30                	jne    800c20 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800bf0:	8b 15 38 61 83 00    	mov    0x836138,%edx
  800bf6:	a0 64 e0 81 00       	mov    0x81e064,%al
  800bfb:	0f b6 c0             	movzbl %al,%eax
  800bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c01:	8b 09                	mov    (%ecx),%ecx
  800c03:	89 cb                	mov    %ecx,%ebx
  800c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c08:	83 c1 08             	add    $0x8,%ecx
  800c0b:	52                   	push   %edx
  800c0c:	50                   	push   %eax
  800c0d:	53                   	push   %ebx
  800c0e:	51                   	push   %ecx
  800c0f:	e8 0e 2a 00 00       	call   803622 <sys_cputs>
  800c14:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 40 04             	mov    0x4(%eax),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c2f:	90                   	nop
  800c30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c3e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c45:	00 00 00 
	b.cnt = 0;
  800c48:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c4f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	ff 75 08             	pushl  0x8(%ebp)
  800c58:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c5e:	50                   	push   %eax
  800c5f:	68 c4 0b 80 00       	push   $0x800bc4
  800c64:	e8 5a 02 00 00       	call   800ec3 <vprintfmt>
  800c69:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c6c:	8b 15 38 61 83 00    	mov    0x836138,%edx
  800c72:	a0 64 e0 81 00       	mov    0x81e064,%al
  800c77:	0f b6 c0             	movzbl %al,%eax
  800c7a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c80:	52                   	push   %edx
  800c81:	50                   	push   %eax
  800c82:	51                   	push   %ecx
  800c83:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c89:	83 c0 08             	add    $0x8,%eax
  800c8c:	50                   	push   %eax
  800c8d:	e8 90 29 00 00       	call   803622 <sys_cputs>
  800c92:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c95:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800c9c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800caa:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800cb1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	e8 6f ff ff ff       	call   800c35 <vcprintf>
  800cc6:	83 c4 10             	add    $0x10,%esp
  800cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cd7:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	c1 e0 08             	shl    $0x8,%eax
  800ce4:	a3 38 61 83 00       	mov    %eax,0x836138
	va_start(ap, fmt);
  800ce9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	e8 34 ff ff ff       	call   800c35 <vcprintf>
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800d07:	c7 05 38 61 83 00 00 	movl   $0x700,0x836138
  800d0e:	07 00 00 

	return cnt;
  800d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d1c:	e8 45 29 00 00       	call   803666 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d21:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	83 ec 08             	sub    $0x8,%esp
  800d2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d30:	50                   	push   %eax
  800d31:	e8 ff fe ff ff       	call   800c35 <vcprintf>
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d3c:	e8 3f 29 00 00       	call   803680 <sys_unlock_cons>
	return cnt;
  800d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 14             	sub    $0x14,%esp
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d53:	8b 45 14             	mov    0x14(%ebp),%eax
  800d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d59:	8b 45 18             	mov    0x18(%ebp),%eax
  800d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d61:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d64:	77 55                	ja     800dbb <printnum+0x75>
  800d66:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d69:	72 05                	jb     800d70 <printnum+0x2a>
  800d6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d6e:	77 4b                	ja     800dbb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d70:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d73:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d76:	8b 45 18             	mov    0x18(%ebp),%eax
  800d79:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7e:	52                   	push   %edx
  800d7f:	50                   	push   %eax
  800d80:	ff 75 f4             	pushl  -0xc(%ebp)
  800d83:	ff 75 f0             	pushl  -0x10(%ebp)
  800d86:	e8 99 3a 00 00       	call   804824 <__udivdi3>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	ff 75 20             	pushl  0x20(%ebp)
  800d94:	53                   	push   %ebx
  800d95:	ff 75 18             	pushl  0x18(%ebp)
  800d98:	52                   	push   %edx
  800d99:	50                   	push   %eax
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 a1 ff ff ff       	call   800d46 <printnum>
  800da5:	83 c4 20             	add    $0x20,%esp
  800da8:	eb 1a                	jmp    800dc4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	ff 75 20             	pushl  0x20(%ebp)
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dbb:	ff 4d 1c             	decl   0x1c(%ebp)
  800dbe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dc2:	7f e6                	jg     800daa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dc4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd2:	53                   	push   %ebx
  800dd3:	51                   	push   %ecx
  800dd4:	52                   	push   %edx
  800dd5:	50                   	push   %eax
  800dd6:	e8 59 3b 00 00       	call   804934 <__umoddi3>
  800ddb:	83 c4 10             	add    $0x10,%esp
  800dde:	05 b4 4f 80 00       	add    $0x804fb4,%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f be c0             	movsbl %al,%eax
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 0c             	pushl  0xc(%ebp)
  800dee:	50                   	push   %eax
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
}
  800df7:	90                   	nop
  800df8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e00:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e04:	7e 1c                	jle    800e22 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8b 00                	mov    (%eax),%eax
  800e0b:	8d 50 08             	lea    0x8(%eax),%edx
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	89 10                	mov    %edx,(%eax)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	83 e8 08             	sub    $0x8,%eax
  800e1b:	8b 50 04             	mov    0x4(%eax),%edx
  800e1e:	8b 00                	mov    (%eax),%eax
  800e20:	eb 40                	jmp    800e62 <getuint+0x65>
	else if (lflag)
  800e22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e26:	74 1e                	je     800e46 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	8d 50 04             	lea    0x4(%eax),%edx
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	89 10                	mov    %edx,(%eax)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8b 00                	mov    (%eax),%eax
  800e3a:	83 e8 04             	sub    $0x4,%eax
  800e3d:	8b 00                	mov    (%eax),%eax
  800e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e44:	eb 1c                	jmp    800e62 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 00                	mov    (%eax),%eax
  800e4b:	8d 50 04             	lea    0x4(%eax),%edx
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 10                	mov    %edx,(%eax)
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8b 00                	mov    (%eax),%eax
  800e58:	83 e8 04             	sub    $0x4,%eax
  800e5b:	8b 00                	mov    (%eax),%eax
  800e5d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e67:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e6b:	7e 1c                	jle    800e89 <getint+0x25>
		return va_arg(*ap, long long);
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 50 08             	lea    0x8(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 10                	mov    %edx,(%eax)
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8b 00                	mov    (%eax),%eax
  800e7f:	83 e8 08             	sub    $0x8,%eax
  800e82:	8b 50 04             	mov    0x4(%eax),%edx
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	eb 38                	jmp    800ec1 <getint+0x5d>
	else if (lflag)
  800e89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8d:	74 1a                	je     800ea9 <getint+0x45>
		return va_arg(*ap, long);
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8b 00                	mov    (%eax),%eax
  800e94:	8d 50 04             	lea    0x4(%eax),%edx
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	89 10                	mov    %edx,(%eax)
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8b 00                	mov    (%eax),%eax
  800ea1:	83 e8 04             	sub    $0x4,%eax
  800ea4:	8b 00                	mov    (%eax),%eax
  800ea6:	99                   	cltd   
  800ea7:	eb 18                	jmp    800ec1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	8d 50 04             	lea    0x4(%eax),%edx
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 10                	mov    %edx,(%eax)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8b 00                	mov    (%eax),%eax
  800ebb:	83 e8 04             	sub    $0x4,%eax
  800ebe:	8b 00                	mov    (%eax),%eax
  800ec0:	99                   	cltd   
}
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ecb:	eb 17                	jmp    800ee4 <vprintfmt+0x21>
			if (ch == '\0')
  800ecd:	85 db                	test   %ebx,%ebx
  800ecf:	0f 84 c1 03 00 00    	je     801296 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ed5:	83 ec 08             	sub    $0x8,%esp
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	53                   	push   %ebx
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	ff d0                	call   *%eax
  800ee1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	89 55 10             	mov    %edx,0x10(%ebp)
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f b6 d8             	movzbl %al,%ebx
  800ef2:	83 fb 25             	cmp    $0x25,%ebx
  800ef5:	75 d6                	jne    800ecd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ef7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800efb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f02:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	8d 50 01             	lea    0x1(%eax),%edx
  800f1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	0f b6 d8             	movzbl %al,%ebx
  800f25:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f28:	83 f8 5b             	cmp    $0x5b,%eax
  800f2b:	0f 87 3d 03 00 00    	ja     80126e <vprintfmt+0x3ab>
  800f31:	8b 04 85 d8 4f 80 00 	mov    0x804fd8(,%eax,4),%eax
  800f38:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f3a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f3e:	eb d7                	jmp    800f17 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f40:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f44:	eb d1                	jmp    800f17 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f46:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f50:	89 d0                	mov    %edx,%eax
  800f52:	c1 e0 02             	shl    $0x2,%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	01 c0                	add    %eax,%eax
  800f59:	01 d8                	add    %ebx,%eax
  800f5b:	83 e8 30             	sub    $0x30,%eax
  800f5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f61:	8b 45 10             	mov    0x10(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f69:	83 fb 2f             	cmp    $0x2f,%ebx
  800f6c:	7e 3e                	jle    800fac <vprintfmt+0xe9>
  800f6e:	83 fb 39             	cmp    $0x39,%ebx
  800f71:	7f 39                	jg     800fac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f73:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f76:	eb d5                	jmp    800f4d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f78:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7b:	83 c0 04             	add    $0x4,%eax
  800f7e:	89 45 14             	mov    %eax,0x14(%ebp)
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	83 e8 04             	sub    $0x4,%eax
  800f87:	8b 00                	mov    (%eax),%eax
  800f89:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f92:	79 83                	jns    800f17 <vprintfmt+0x54>
				width = 0;
  800f94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f9b:	e9 77 ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fa0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fa7:	e9 6b ff ff ff       	jmp    800f17 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb1:	0f 89 60 ff ff ff    	jns    800f17 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fbd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fc4:	e9 4e ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fc9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fcc:	e9 46 ff ff ff       	jmp    800f17 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd4:	83 c0 04             	add    $0x4,%eax
  800fd7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fda:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdd:	83 e8 04             	sub    $0x4,%eax
  800fe0:	8b 00                	mov    (%eax),%eax
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	50                   	push   %eax
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	ff d0                	call   *%eax
  800fee:	83 c4 10             	add    $0x10,%esp
			break;
  800ff1:	e9 9b 02 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff9:	83 c0 04             	add    $0x4,%eax
  800ffc:	89 45 14             	mov    %eax,0x14(%ebp)
  800fff:	8b 45 14             	mov    0x14(%ebp),%eax
  801002:	83 e8 04             	sub    $0x4,%eax
  801005:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801007:	85 db                	test   %ebx,%ebx
  801009:	79 02                	jns    80100d <vprintfmt+0x14a>
				err = -err;
  80100b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80100d:	83 fb 64             	cmp    $0x64,%ebx
  801010:	7f 0b                	jg     80101d <vprintfmt+0x15a>
  801012:	8b 34 9d 20 4e 80 00 	mov    0x804e20(,%ebx,4),%esi
  801019:	85 f6                	test   %esi,%esi
  80101b:	75 19                	jne    801036 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80101d:	53                   	push   %ebx
  80101e:	68 c5 4f 80 00       	push   $0x804fc5
  801023:	ff 75 0c             	pushl  0xc(%ebp)
  801026:	ff 75 08             	pushl  0x8(%ebp)
  801029:	e8 70 02 00 00       	call   80129e <printfmt>
  80102e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801031:	e9 5b 02 00 00       	jmp    801291 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801036:	56                   	push   %esi
  801037:	68 ce 4f 80 00       	push   $0x804fce
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	ff 75 08             	pushl  0x8(%ebp)
  801042:	e8 57 02 00 00       	call   80129e <printfmt>
  801047:	83 c4 10             	add    $0x10,%esp
			break;
  80104a:	e9 42 02 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	83 c0 04             	add    $0x4,%eax
  801055:	89 45 14             	mov    %eax,0x14(%ebp)
  801058:	8b 45 14             	mov    0x14(%ebp),%eax
  80105b:	83 e8 04             	sub    $0x4,%eax
  80105e:	8b 30                	mov    (%eax),%esi
  801060:	85 f6                	test   %esi,%esi
  801062:	75 05                	jne    801069 <vprintfmt+0x1a6>
				p = "(null)";
  801064:	be d1 4f 80 00       	mov    $0x804fd1,%esi
			if (width > 0 && padc != '-')
  801069:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106d:	7e 6d                	jle    8010dc <vprintfmt+0x219>
  80106f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801073:	74 67                	je     8010dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801075:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	50                   	push   %eax
  80107c:	56                   	push   %esi
  80107d:	e8 26 05 00 00       	call   8015a8 <strnlen>
  801082:	83 c4 10             	add    $0x10,%esp
  801085:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801088:	eb 16                	jmp    8010a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80108a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80108e:	83 ec 08             	sub    $0x8,%esp
  801091:	ff 75 0c             	pushl  0xc(%ebp)
  801094:	50                   	push   %eax
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	ff d0                	call   *%eax
  80109a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80109d:	ff 4d e4             	decl   -0x1c(%ebp)
  8010a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a4:	7f e4                	jg     80108a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010a6:	eb 34                	jmp    8010dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010ac:	74 1c                	je     8010ca <vprintfmt+0x207>
  8010ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8010b1:	7e 05                	jle    8010b8 <vprintfmt+0x1f5>
  8010b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8010b6:	7e 12                	jle    8010ca <vprintfmt+0x207>
					putch('?', putdat);
  8010b8:	83 ec 08             	sub    $0x8,%esp
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	6a 3f                	push   $0x3f
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	ff d0                	call   *%eax
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	eb 0f                	jmp    8010d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	ff 75 0c             	pushl  0xc(%ebp)
  8010d0:	53                   	push   %ebx
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	ff d0                	call   *%eax
  8010d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8010dc:	89 f0                	mov    %esi,%eax
  8010de:	8d 70 01             	lea    0x1(%eax),%esi
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f be d8             	movsbl %al,%ebx
  8010e6:	85 db                	test   %ebx,%ebx
  8010e8:	74 24                	je     80110e <vprintfmt+0x24b>
  8010ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010ee:	78 b8                	js     8010a8 <vprintfmt+0x1e5>
  8010f0:	ff 4d e0             	decl   -0x20(%ebp)
  8010f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010f7:	79 af                	jns    8010a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010f9:	eb 13                	jmp    80110e <vprintfmt+0x24b>
				putch(' ', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 20                	push   $0x20
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80110b:	ff 4d e4             	decl   -0x1c(%ebp)
  80110e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801112:	7f e7                	jg     8010fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801114:	e9 78 01 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	ff 75 e8             	pushl  -0x18(%ebp)
  80111f:	8d 45 14             	lea    0x14(%ebp),%eax
  801122:	50                   	push   %eax
  801123:	e8 3c fd ff ff       	call   800e64 <getint>
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	79 23                	jns    80115e <vprintfmt+0x29b>
				putch('-', putdat);
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	6a 2d                	push   $0x2d
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	ff d0                	call   *%eax
  801148:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80114b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801151:	f7 d8                	neg    %eax
  801153:	83 d2 00             	adc    $0x0,%edx
  801156:	f7 da                	neg    %edx
  801158:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80115e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801165:	e9 bc 00 00 00       	jmp    801226 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	ff 75 e8             	pushl  -0x18(%ebp)
  801170:	8d 45 14             	lea    0x14(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	e8 84 fc ff ff       	call   800dfd <getuint>
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801182:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801189:	e9 98 00 00 00       	jmp    801226 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80118e:	83 ec 08             	sub    $0x8,%esp
  801191:	ff 75 0c             	pushl  0xc(%ebp)
  801194:	6a 58                	push   $0x58
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	ff d0                	call   *%eax
  80119b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 0c             	pushl  0xc(%ebp)
  8011a4:	6a 58                	push   $0x58
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	ff d0                	call   *%eax
  8011ab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011ae:	83 ec 08             	sub    $0x8,%esp
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	6a 58                	push   $0x58
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	ff d0                	call   *%eax
  8011bb:	83 c4 10             	add    $0x10,%esp
			break;
  8011be:	e9 ce 00 00 00       	jmp    801291 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	6a 30                	push   $0x30
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	ff d0                	call   *%eax
  8011d0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011d3:	83 ec 08             	sub    $0x8,%esp
  8011d6:	ff 75 0c             	pushl  0xc(%ebp)
  8011d9:	6a 78                	push   $0x78
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	ff d0                	call   *%eax
  8011e0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e6:	83 c0 04             	add    $0x4,%eax
  8011e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	83 e8 04             	sub    $0x4,%eax
  8011f2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801205:	eb 1f                	jmp    801226 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	ff 75 e8             	pushl  -0x18(%ebp)
  80120d:	8d 45 14             	lea    0x14(%ebp),%eax
  801210:	50                   	push   %eax
  801211:	e8 e7 fb ff ff       	call   800dfd <getuint>
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80121c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80121f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801226:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80122a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	52                   	push   %edx
  801231:	ff 75 e4             	pushl  -0x1c(%ebp)
  801234:	50                   	push   %eax
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	ff 75 f0             	pushl  -0x10(%ebp)
  80123b:	ff 75 0c             	pushl  0xc(%ebp)
  80123e:	ff 75 08             	pushl  0x8(%ebp)
  801241:	e8 00 fb ff ff       	call   800d46 <printnum>
  801246:	83 c4 20             	add    $0x20,%esp
			break;
  801249:	eb 46                	jmp    801291 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	53                   	push   %ebx
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	ff d0                	call   *%eax
  801257:	83 c4 10             	add    $0x10,%esp
			break;
  80125a:	eb 35                	jmp    801291 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80125c:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  801263:	eb 2c                	jmp    801291 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801265:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  80126c:	eb 23                	jmp    801291 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	6a 25                	push   $0x25
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	ff d0                	call   *%eax
  80127b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80127e:	ff 4d 10             	decl   0x10(%ebp)
  801281:	eb 03                	jmp    801286 <vprintfmt+0x3c3>
  801283:	ff 4d 10             	decl   0x10(%ebp)
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	48                   	dec    %eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 25                	cmp    $0x25,%al
  80128e:	75 f3                	jne    801283 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801290:	90                   	nop
		}
	}
  801291:	e9 35 fc ff ff       	jmp    800ecb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801296:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801297:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80129a:	5b                   	pop    %ebx
  80129b:	5e                   	pop    %esi
  80129c:	5d                   	pop    %ebp
  80129d:	c3                   	ret    

0080129e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a7:	83 c0 04             	add    $0x4,%eax
  8012aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b3:	50                   	push   %eax
  8012b4:	ff 75 0c             	pushl  0xc(%ebp)
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	e8 04 fc ff ff       	call   800ec3 <vprintfmt>
  8012bf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012c2:	90                   	nop
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8b 40 08             	mov    0x8(%eax),%eax
  8012ce:	8d 50 01             	lea    0x1(%eax),%edx
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012da:	8b 10                	mov    (%eax),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	8b 40 04             	mov    0x4(%eax),%eax
  8012e2:	39 c2                	cmp    %eax,%edx
  8012e4:	73 12                	jae    8012f8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	8b 00                	mov    (%eax),%eax
  8012eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	89 0a                	mov    %ecx,(%edx)
  8012f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f6:	88 10                	mov    %dl,(%eax)
}
  8012f8:	90                   	nop
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80131c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801320:	74 06                	je     801328 <vsnprintf+0x2d>
  801322:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801326:	7f 07                	jg     80132f <vsnprintf+0x34>
		return -E_INVAL;
  801328:	b8 03 00 00 00       	mov    $0x3,%eax
  80132d:	eb 20                	jmp    80134f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80132f:	ff 75 14             	pushl  0x14(%ebp)
  801332:	ff 75 10             	pushl  0x10(%ebp)
  801335:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	68 c5 12 80 00       	push   $0x8012c5
  80133e:	e8 80 fb ff ff       	call   800ec3 <vprintfmt>
  801343:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801349:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801357:	8d 45 10             	lea    0x10(%ebp),%eax
  80135a:	83 c0 04             	add    $0x4,%eax
  80135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	ff 75 f4             	pushl  -0xc(%ebp)
  801366:	50                   	push   %eax
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	ff 75 08             	pushl  0x8(%ebp)
  80136d:	e8 89 ff ff ff       	call   8012fb <vsnprintf>
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801378:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801383:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801387:	74 13                	je     80139c <readline+0x1f>
		cprintf("%s", prompt);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	ff 75 08             	pushl  0x8(%ebp)
  80138f:	68 48 51 80 00       	push   $0x805148
  801394:	e8 0b f9 ff ff       	call   800ca4 <cprintf>
  801399:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80139c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	6a 00                	push   $0x0
  8013a8:	e8 5d f6 ff ff       	call   800a0a <iscons>
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8013b3:	e8 3f f6 ff ff       	call   8009f7 <getchar>
  8013b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013bf:	79 22                	jns    8013e3 <readline+0x66>
			if (c != -E_EOF)
  8013c1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013c5:	0f 84 ad 00 00 00    	je     801478 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8013d1:	68 4b 51 80 00       	push   $0x80514b
  8013d6:	e8 c9 f8 ff ff       	call   800ca4 <cprintf>
  8013db:	83 c4 10             	add    $0x10,%esp
			break;
  8013de:	e9 95 00 00 00       	jmp    801478 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013e3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013e7:	7e 34                	jle    80141d <readline+0xa0>
  8013e9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013f0:	7f 2b                	jg     80141d <readline+0xa0>
			if (echoing)
  8013f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013f6:	74 0e                	je     801406 <readline+0x89>
				cputchar(c);
  8013f8:	83 ec 0c             	sub    $0xc,%esp
  8013fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8013fe:	e8 d5 f5 ff ff       	call   8009d8 <cputchar>
  801403:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	8d 50 01             	lea    0x1(%eax),%edx
  80140c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80140f:	89 c2                	mov    %eax,%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801419:	88 10                	mov    %dl,(%eax)
  80141b:	eb 56                	jmp    801473 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80141d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801421:	75 1f                	jne    801442 <readline+0xc5>
  801423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801427:	7e 19                	jle    801442 <readline+0xc5>
			if (echoing)
  801429:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80142d:	74 0e                	je     80143d <readline+0xc0>
				cputchar(c);
  80142f:	83 ec 0c             	sub    $0xc,%esp
  801432:	ff 75 ec             	pushl  -0x14(%ebp)
  801435:	e8 9e f5 ff ff       	call   8009d8 <cputchar>
  80143a:	83 c4 10             	add    $0x10,%esp

			i--;
  80143d:	ff 4d f4             	decl   -0xc(%ebp)
  801440:	eb 31                	jmp    801473 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801442:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801446:	74 0a                	je     801452 <readline+0xd5>
  801448:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80144c:	0f 85 61 ff ff ff    	jne    8013b3 <readline+0x36>
			if (echoing)
  801452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801456:	74 0e                	je     801466 <readline+0xe9>
				cputchar(c);
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	ff 75 ec             	pushl  -0x14(%ebp)
  80145e:	e8 75 f5 ff ff       	call   8009d8 <cputchar>
  801463:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801471:	eb 06                	jmp    801479 <readline+0xfc>
		}
	}
  801473:	e9 3b ff ff ff       	jmp    8013b3 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801478:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801479:	90                   	nop
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801482:	e8 df 21 00 00       	call   803666 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801487:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80148b:	74 13                	je     8014a0 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	68 48 51 80 00       	push   $0x805148
  801498:	e8 07 f8 ff ff       	call   800ca4 <cprintf>
  80149d:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8014a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	6a 00                	push   $0x0
  8014ac:	e8 59 f5 ff ff       	call   800a0a <iscons>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8014b7:	e8 3b f5 ff ff       	call   8009f7 <getchar>
  8014bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8014bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014c3:	79 22                	jns    8014e7 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014c5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014c9:	0f 84 ad 00 00 00    	je     80157c <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8014d5:	68 4b 51 80 00       	push   $0x80514b
  8014da:	e8 c5 f7 ff ff       	call   800ca4 <cprintf>
  8014df:	83 c4 10             	add    $0x10,%esp
				break;
  8014e2:	e9 95 00 00 00       	jmp    80157c <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014e7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014eb:	7e 34                	jle    801521 <atomic_readline+0xa5>
  8014ed:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014f4:	7f 2b                	jg     801521 <atomic_readline+0xa5>
				if (echoing)
  8014f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014fa:	74 0e                	je     80150a <atomic_readline+0x8e>
					cputchar(c);
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801502:	e8 d1 f4 ff ff       	call   8009d8 <cputchar>
  801507:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80150a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150d:	8d 50 01             	lea    0x1(%eax),%edx
  801510:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801513:	89 c2                	mov    %eax,%edx
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80151d:	88 10                	mov    %dl,(%eax)
  80151f:	eb 56                	jmp    801577 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801521:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801525:	75 1f                	jne    801546 <atomic_readline+0xca>
  801527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80152b:	7e 19                	jle    801546 <atomic_readline+0xca>
				if (echoing)
  80152d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801531:	74 0e                	je     801541 <atomic_readline+0xc5>
					cputchar(c);
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	ff 75 ec             	pushl  -0x14(%ebp)
  801539:	e8 9a f4 ff ff       	call   8009d8 <cputchar>
  80153e:	83 c4 10             	add    $0x10,%esp
				i--;
  801541:	ff 4d f4             	decl   -0xc(%ebp)
  801544:	eb 31                	jmp    801577 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801546:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80154a:	74 0a                	je     801556 <atomic_readline+0xda>
  80154c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801550:	0f 85 61 ff ff ff    	jne    8014b7 <atomic_readline+0x3b>
				if (echoing)
  801556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80155a:	74 0e                	je     80156a <atomic_readline+0xee>
					cputchar(c);
  80155c:	83 ec 0c             	sub    $0xc,%esp
  80155f:	ff 75 ec             	pushl  -0x14(%ebp)
  801562:	e8 71 f4 ff ff       	call   8009d8 <cputchar>
  801567:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801570:	01 d0                	add    %edx,%eax
  801572:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801575:	eb 06                	jmp    80157d <atomic_readline+0x101>
			}
		}
  801577:	e9 3b ff ff ff       	jmp    8014b7 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80157c:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80157d:	e8 fe 20 00 00       	call   803680 <sys_unlock_cons>
}
  801582:	90                   	nop
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80158b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801592:	eb 06                	jmp    80159a <strlen+0x15>
		n++;
  801594:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801597:	ff 45 08             	incl   0x8(%ebp)
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	84 c0                	test   %al,%al
  8015a1:	75 f1                	jne    801594 <strlen+0xf>
		n++;
	return n;
  8015a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b5:	eb 09                	jmp    8015c0 <strnlen+0x18>
		n++;
  8015b7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015ba:	ff 45 08             	incl   0x8(%ebp)
  8015bd:	ff 4d 0c             	decl   0xc(%ebp)
  8015c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c4:	74 09                	je     8015cf <strnlen+0x27>
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	84 c0                	test   %al,%al
  8015cd:	75 e8                	jne    8015b7 <strnlen+0xf>
		n++;
	return n;
  8015cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015e0:	90                   	nop
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8d 50 01             	lea    0x1(%eax),%edx
  8015e7:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015f3:	8a 12                	mov    (%edx),%dl
  8015f5:	88 10                	mov    %dl,(%eax)
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	84 c0                	test   %al,%al
  8015fb:	75 e4                	jne    8015e1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80160e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801615:	eb 1f                	jmp    801636 <strncpy+0x34>
		*dst++ = *src;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8d 50 01             	lea    0x1(%eax),%edx
  80161d:	89 55 08             	mov    %edx,0x8(%ebp)
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8a 12                	mov    (%edx),%dl
  801625:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162a:	8a 00                	mov    (%eax),%al
  80162c:	84 c0                	test   %al,%al
  80162e:	74 03                	je     801633 <strncpy+0x31>
			src++;
  801630:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801633:	ff 45 fc             	incl   -0x4(%ebp)
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	3b 45 10             	cmp    0x10(%ebp),%eax
  80163c:	72 d9                	jb     801617 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80164f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801653:	74 30                	je     801685 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801655:	eb 16                	jmp    80166d <strlcpy+0x2a>
			*dst++ = *src++;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8d 50 01             	lea    0x1(%eax),%edx
  80165d:	89 55 08             	mov    %edx,0x8(%ebp)
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8d 4a 01             	lea    0x1(%edx),%ecx
  801666:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801669:	8a 12                	mov    (%edx),%dl
  80166b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80166d:	ff 4d 10             	decl   0x10(%ebp)
  801670:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801674:	74 09                	je     80167f <strlcpy+0x3c>
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	84 c0                	test   %al,%al
  80167d:	75 d8                	jne    801657 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801685:	8b 55 08             	mov    0x8(%ebp),%edx
  801688:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168b:	29 c2                	sub    %eax,%edx
  80168d:	89 d0                	mov    %edx,%eax
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801694:	eb 06                	jmp    80169c <strcmp+0xb>
		p++, q++;
  801696:	ff 45 08             	incl   0x8(%ebp)
  801699:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	8a 00                	mov    (%eax),%al
  8016a1:	84 c0                	test   %al,%al
  8016a3:	74 0e                	je     8016b3 <strcmp+0x22>
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8a 10                	mov    (%eax),%dl
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	38 c2                	cmp    %al,%dl
  8016b1:	74 e3                	je     801696 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	0f b6 d0             	movzbl %al,%edx
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	0f b6 c0             	movzbl %al,%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016cc:	eb 09                	jmp    8016d7 <strncmp+0xe>
		n--, p++, q++;
  8016ce:	ff 4d 10             	decl   0x10(%ebp)
  8016d1:	ff 45 08             	incl   0x8(%ebp)
  8016d4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016db:	74 17                	je     8016f4 <strncmp+0x2b>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	84 c0                	test   %al,%al
  8016e4:	74 0e                	je     8016f4 <strncmp+0x2b>
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 10                	mov    (%eax),%dl
  8016eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	38 c2                	cmp    %al,%dl
  8016f2:	74 da                	je     8016ce <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f8:	75 07                	jne    801701 <strncmp+0x38>
		return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ff:	eb 14                	jmp    801715 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f b6 d0             	movzbl %al,%edx
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	0f b6 c0             	movzbl %al,%eax
  801711:	29 c2                	sub    %eax,%edx
  801713:	89 d0                	mov    %edx,%eax
}
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801723:	eb 12                	jmp    801737 <strchr+0x20>
		if (*s == c)
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	8a 00                	mov    (%eax),%al
  80172a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80172d:	75 05                	jne    801734 <strchr+0x1d>
			return (char *) s;
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	eb 11                	jmp    801745 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801734:	ff 45 08             	incl   0x8(%ebp)
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8a 00                	mov    (%eax),%al
  80173c:	84 c0                	test   %al,%al
  80173e:	75 e5                	jne    801725 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801753:	eb 0d                	jmp    801762 <strfind+0x1b>
		if (*s == c)
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80175d:	74 0e                	je     80176d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80175f:	ff 45 08             	incl   0x8(%ebp)
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	84 c0                	test   %al,%al
  801769:	75 ea                	jne    801755 <strfind+0xe>
  80176b:	eb 01                	jmp    80176e <strfind+0x27>
		if (*s == c)
			break;
  80176d:	90                   	nop
	return (char *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80177f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801783:	76 63                	jbe    8017e8 <memset+0x75>
		uint64 data_block = c;
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	99                   	cltd   
  801789:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80178c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801795:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801799:	c1 e0 08             	shl    $0x8,%eax
  80179c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80179f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a8:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8017ac:	c1 e0 10             	shl    $0x10,%eax
  8017af:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017b2:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8017b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bb:	89 c2                	mov    %eax,%edx
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c2:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017c5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017c8:	eb 18                	jmp    8017e2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017cd:	8d 41 08             	lea    0x8(%ecx),%eax
  8017d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d9:	89 01                	mov    %eax,(%ecx)
  8017db:	89 51 04             	mov    %edx,0x4(%ecx)
  8017de:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017e2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017e6:	77 e2                	ja     8017ca <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ec:	74 23                	je     801811 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8017ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017f4:	eb 0e                	jmp    801804 <memset+0x91>
			*p8++ = (uint8)c;
  8017f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f9:	8d 50 01             	lea    0x1(%eax),%edx
  8017fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801804:	8b 45 10             	mov    0x10(%ebp),%eax
  801807:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180a:	89 55 10             	mov    %edx,0x10(%ebp)
  80180d:	85 c0                	test   %eax,%eax
  80180f:	75 e5                	jne    8017f6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80181c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801828:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80182c:	76 24                	jbe    801852 <memcpy+0x3c>
		while(n >= 8){
  80182e:	eb 1c                	jmp    80184c <memcpy+0x36>
			*d64 = *s64;
  801830:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801833:	8b 50 04             	mov    0x4(%eax),%edx
  801836:	8b 00                	mov    (%eax),%eax
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	89 01                	mov    %eax,(%ecx)
  80183d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801840:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801844:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801848:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80184c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801850:	77 de                	ja     801830 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801852:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801856:	74 31                	je     801889 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801858:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80185e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801861:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801864:	eb 16                	jmp    80187c <memcpy+0x66>
			*d8++ = *s8++;
  801866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801869:	8d 50 01             	lea    0x1(%eax),%edx
  80186c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80186f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801872:	8d 4a 01             	lea    0x1(%edx),%ecx
  801875:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801878:	8a 12                	mov    (%edx),%dl
  80187a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80187c:	8b 45 10             	mov    0x10(%ebp),%eax
  80187f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801882:	89 55 10             	mov    %edx,0x10(%ebp)
  801885:	85 c0                	test   %eax,%eax
  801887:	75 dd                	jne    801866 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801894:	8b 45 0c             	mov    0xc(%ebp),%eax
  801897:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018a6:	73 50                	jae    8018f8 <memmove+0x6a>
  8018a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018b3:	76 43                	jbe    8018f8 <memmove+0x6a>
		s += n;
  8018b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018be:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018c1:	eb 10                	jmp    8018d3 <memmove+0x45>
			*--d = *--s;
  8018c3:	ff 4d f8             	decl   -0x8(%ebp)
  8018c6:	ff 4d fc             	decl   -0x4(%ebp)
  8018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cc:	8a 10                	mov    (%eax),%dl
  8018ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	75 e3                	jne    8018c3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018e0:	eb 23                	jmp    801905 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e5:	8d 50 01             	lea    0x1(%eax),%edx
  8018e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018f1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018f4:	8a 12                	mov    (%edx),%dl
  8018f6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801901:	85 c0                	test   %eax,%eax
  801903:	75 dd                	jne    8018e2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801916:	8b 45 0c             	mov    0xc(%ebp),%eax
  801919:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80191c:	eb 2a                	jmp    801948 <memcmp+0x3e>
		if (*s1 != *s2)
  80191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801921:	8a 10                	mov    (%eax),%dl
  801923:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	38 c2                	cmp    %al,%dl
  80192a:	74 16                	je     801942 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80192c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192f:	8a 00                	mov    (%eax),%al
  801931:	0f b6 d0             	movzbl %al,%edx
  801934:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f b6 c0             	movzbl %al,%eax
  80193c:	29 c2                	sub    %eax,%edx
  80193e:	89 d0                	mov    %edx,%eax
  801940:	eb 18                	jmp    80195a <memcmp+0x50>
		s1++, s2++;
  801942:	ff 45 fc             	incl   -0x4(%ebp)
  801945:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80194e:	89 55 10             	mov    %edx,0x10(%ebp)
  801951:	85 c0                	test   %eax,%eax
  801953:	75 c9                	jne    80191e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801962:	8b 55 08             	mov    0x8(%ebp),%edx
  801965:	8b 45 10             	mov    0x10(%ebp),%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80196d:	eb 15                	jmp    801984 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	8a 00                	mov    (%eax),%al
  801974:	0f b6 d0             	movzbl %al,%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	0f b6 c0             	movzbl %al,%eax
  80197d:	39 c2                	cmp    %eax,%edx
  80197f:	74 0d                	je     80198e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801981:	ff 45 08             	incl   0x8(%ebp)
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80198a:	72 e3                	jb     80196f <memfind+0x13>
  80198c:	eb 01                	jmp    80198f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80198e:	90                   	nop
	return (void *) s;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80199a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019a8:	eb 03                	jmp    8019ad <strtol+0x19>
		s++;
  8019aa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	3c 20                	cmp    $0x20,%al
  8019b4:	74 f4                	je     8019aa <strtol+0x16>
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	3c 09                	cmp    $0x9,%al
  8019bd:	74 eb                	je     8019aa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	8a 00                	mov    (%eax),%al
  8019c4:	3c 2b                	cmp    $0x2b,%al
  8019c6:	75 05                	jne    8019cd <strtol+0x39>
		s++;
  8019c8:	ff 45 08             	incl   0x8(%ebp)
  8019cb:	eb 13                	jmp    8019e0 <strtol+0x4c>
	else if (*s == '-')
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8a 00                	mov    (%eax),%al
  8019d2:	3c 2d                	cmp    $0x2d,%al
  8019d4:	75 0a                	jne    8019e0 <strtol+0x4c>
		s++, neg = 1;
  8019d6:	ff 45 08             	incl   0x8(%ebp)
  8019d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019e4:	74 06                	je     8019ec <strtol+0x58>
  8019e6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019ea:	75 20                	jne    801a0c <strtol+0x78>
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8a 00                	mov    (%eax),%al
  8019f1:	3c 30                	cmp    $0x30,%al
  8019f3:	75 17                	jne    801a0c <strtol+0x78>
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	40                   	inc    %eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	3c 78                	cmp    $0x78,%al
  8019fd:	75 0d                	jne    801a0c <strtol+0x78>
		s += 2, base = 16;
  8019ff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a03:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a0a:	eb 28                	jmp    801a34 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a10:	75 15                	jne    801a27 <strtol+0x93>
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	8a 00                	mov    (%eax),%al
  801a17:	3c 30                	cmp    $0x30,%al
  801a19:	75 0c                	jne    801a27 <strtol+0x93>
		s++, base = 8;
  801a1b:	ff 45 08             	incl   0x8(%ebp)
  801a1e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a25:	eb 0d                	jmp    801a34 <strtol+0xa0>
	else if (base == 0)
  801a27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a2b:	75 07                	jne    801a34 <strtol+0xa0>
		base = 10;
  801a2d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	8a 00                	mov    (%eax),%al
  801a39:	3c 2f                	cmp    $0x2f,%al
  801a3b:	7e 19                	jle    801a56 <strtol+0xc2>
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	3c 39                	cmp    $0x39,%al
  801a44:	7f 10                	jg     801a56 <strtol+0xc2>
			dig = *s - '0';
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8a 00                	mov    (%eax),%al
  801a4b:	0f be c0             	movsbl %al,%eax
  801a4e:	83 e8 30             	sub    $0x30,%eax
  801a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a54:	eb 42                	jmp    801a98 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	3c 60                	cmp    $0x60,%al
  801a5d:	7e 19                	jle    801a78 <strtol+0xe4>
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	3c 7a                	cmp    $0x7a,%al
  801a66:	7f 10                	jg     801a78 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	8a 00                	mov    (%eax),%al
  801a6d:	0f be c0             	movsbl %al,%eax
  801a70:	83 e8 57             	sub    $0x57,%eax
  801a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a76:	eb 20                	jmp    801a98 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	3c 40                	cmp    $0x40,%al
  801a7f:	7e 39                	jle    801aba <strtol+0x126>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	3c 5a                	cmp    $0x5a,%al
  801a88:	7f 30                	jg     801aba <strtol+0x126>
			dig = *s - 'A' + 10;
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	8a 00                	mov    (%eax),%al
  801a8f:	0f be c0             	movsbl %al,%eax
  801a92:	83 e8 37             	sub    $0x37,%eax
  801a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a9e:	7d 19                	jge    801ab9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aa0:	ff 45 08             	incl   0x8(%ebp)
  801aa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa6:	0f af 45 10          	imul   0x10(%ebp),%eax
  801aaa:	89 c2                	mov    %eax,%edx
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ab4:	e9 7b ff ff ff       	jmp    801a34 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ab9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801aba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801abe:	74 08                	je     801ac8 <strtol+0x134>
		*endptr = (char *) s;
  801ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801acc:	74 07                	je     801ad5 <strtol+0x141>
  801ace:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad1:	f7 d8                	neg    %eax
  801ad3:	eb 03                	jmp    801ad8 <strtol+0x144>
  801ad5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <ltostr>:

void
ltostr(long value, char *str)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801ae7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801aee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801af2:	79 13                	jns    801b07 <ltostr+0x2d>
	{
		neg = 1;
  801af4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b01:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b04:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b0f:	99                   	cltd   
  801b10:	f7 f9                	idiv   %ecx
  801b12:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b18:	8d 50 01             	lea    0x1(%eax),%edx
  801b1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b1e:	89 c2                	mov    %eax,%edx
  801b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
  801b25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b28:	83 c2 30             	add    $0x30,%edx
  801b2b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b30:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b35:	f7 e9                	imul   %ecx
  801b37:	c1 fa 02             	sar    $0x2,%edx
  801b3a:	89 c8                	mov    %ecx,%eax
  801b3c:	c1 f8 1f             	sar    $0x1f,%eax
  801b3f:	29 c2                	sub    %eax,%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b4a:	75 bb                	jne    801b07 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b56:	48                   	dec    %eax
  801b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b5e:	74 3d                	je     801b9d <ltostr+0xc3>
		start = 1 ;
  801b60:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b67:	eb 34                	jmp    801b9d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	01 d0                	add    %edx,%eax
  801b71:	8a 00                	mov    (%eax),%al
  801b73:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7c:	01 c2                	add    %eax,%edx
  801b7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b84:	01 c8                	add    %ecx,%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b90:	01 c2                	add    %eax,%edx
  801b92:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b95:	88 02                	mov    %al,(%edx)
		start++ ;
  801b97:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b9a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ba3:	7c c4                	jl     801b69 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ba5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bb0:	90                   	nop
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	e8 c4 f9 ff ff       	call   801585 <strlen>
  801bc1:	83 c4 04             	add    $0x4,%esp
  801bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	e8 b6 f9 ff ff       	call   801585 <strlen>
  801bcf:	83 c4 04             	add    $0x4,%esp
  801bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801be3:	eb 17                	jmp    801bfc <strcconcat+0x49>
		final[s] = str1[s] ;
  801be5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be8:	8b 45 10             	mov    0x10(%ebp),%eax
  801beb:	01 c2                	add    %eax,%edx
  801bed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	01 c8                	add    %ecx,%eax
  801bf5:	8a 00                	mov    (%eax),%al
  801bf7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bf9:	ff 45 fc             	incl   -0x4(%ebp)
  801bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c02:	7c e1                	jl     801be5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c12:	eb 1f                	jmp    801c33 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c17:	8d 50 01             	lea    0x1(%eax),%edx
  801c1a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c1d:	89 c2                	mov    %eax,%edx
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	01 c2                	add    %eax,%edx
  801c24:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2a:	01 c8                	add    %ecx,%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c30:	ff 45 f8             	incl   -0x8(%ebp)
  801c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c39:	7c d9                	jl     801c14 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c41:	01 d0                	add    %edx,%eax
  801c43:	c6 00 00             	movb   $0x0,(%eax)
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c55:	8b 45 14             	mov    0x14(%ebp),%eax
  801c58:	8b 00                	mov    (%eax),%eax
  801c5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c61:	8b 45 10             	mov    0x10(%ebp),%eax
  801c64:	01 d0                	add    %edx,%eax
  801c66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c6c:	eb 0c                	jmp    801c7a <strsplit+0x31>
			*string++ = 0;
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	8d 50 01             	lea    0x1(%eax),%edx
  801c74:	89 55 08             	mov    %edx,0x8(%ebp)
  801c77:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	8a 00                	mov    (%eax),%al
  801c7f:	84 c0                	test   %al,%al
  801c81:	74 18                	je     801c9b <strsplit+0x52>
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8a 00                	mov    (%eax),%al
  801c88:	0f be c0             	movsbl %al,%eax
  801c8b:	50                   	push   %eax
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	e8 83 fa ff ff       	call   801717 <strchr>
  801c94:	83 c4 08             	add    $0x8,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	75 d3                	jne    801c6e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	8a 00                	mov    (%eax),%al
  801ca0:	84 c0                	test   %al,%al
  801ca2:	74 5a                	je     801cfe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca7:	8b 00                	mov    (%eax),%eax
  801ca9:	83 f8 0f             	cmp    $0xf,%eax
  801cac:	75 07                	jne    801cb5 <strsplit+0x6c>
		{
			return 0;
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb3:	eb 66                	jmp    801d1b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cb5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb8:	8b 00                	mov    (%eax),%eax
  801cba:	8d 48 01             	lea    0x1(%eax),%ecx
  801cbd:	8b 55 14             	mov    0x14(%ebp),%edx
  801cc0:	89 0a                	mov    %ecx,(%edx)
  801cc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	01 c2                	add    %eax,%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cd3:	eb 03                	jmp    801cd8 <strsplit+0x8f>
			string++;
  801cd5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	8a 00                	mov    (%eax),%al
  801cdd:	84 c0                	test   %al,%al
  801cdf:	74 8b                	je     801c6c <strsplit+0x23>
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	8a 00                	mov    (%eax),%al
  801ce6:	0f be c0             	movsbl %al,%eax
  801ce9:	50                   	push   %eax
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	e8 25 fa ff ff       	call   801717 <strchr>
  801cf2:	83 c4 08             	add    $0x8,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	74 dc                	je     801cd5 <strsplit+0x8c>
			string++;
	}
  801cf9:	e9 6e ff ff ff       	jmp    801c6c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cfe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cff:	8b 45 14             	mov    0x14(%ebp),%eax
  801d02:	8b 00                	mov    (%eax),%eax
  801d04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0e:	01 d0                	add    %edx,%eax
  801d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d30:	eb 4a                	jmp    801d7c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	01 c2                	add    %eax,%edx
  801d3a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d40:	01 c8                	add    %ecx,%eax
  801d42:	8a 00                	mov    (%eax),%al
  801d44:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	8a 00                	mov    (%eax),%al
  801d50:	3c 40                	cmp    $0x40,%al
  801d52:	7e 25                	jle    801d79 <str2lower+0x5c>
  801d54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	8a 00                	mov    (%eax),%al
  801d5e:	3c 5a                	cmp    $0x5a,%al
  801d60:	7f 17                	jg     801d79 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d70:	01 ca                	add    %ecx,%edx
  801d72:	8a 12                	mov    (%edx),%dl
  801d74:	83 c2 20             	add    $0x20,%edx
  801d77:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d79:	ff 45 fc             	incl   -0x4(%ebp)
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	e8 01 f8 ff ff       	call   801585 <strlen>
  801d84:	83 c4 04             	add    $0x4,%esp
  801d87:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d8a:	7f a6                	jg     801d32 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801d97:	a1 08 60 80 00       	mov    0x806008,%eax
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	74 42                	je     801de2 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801da0:	83 ec 08             	sub    $0x8,%esp
  801da3:	68 00 00 00 82       	push   $0x82000000
  801da8:	68 00 00 00 80       	push   $0x80000000
  801dad:	e8 b0 1e 00 00       	call   803c62 <initialize_dynamic_allocator>
  801db2:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801db5:	e8 96 1c 00 00       	call   803a50 <sys_get_uheap_strategy>
  801dba:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801dbf:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801dc4:	05 00 10 00 00       	add    $0x1000,%eax
  801dc9:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801dce:	a1 30 61 83 00       	mov    0x836130,%eax
  801dd3:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801dd8:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801ddf:	00 00 00 
	}
}
  801de2:	90                   	nop
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801df9:	83 ec 08             	sub    $0x8,%esp
  801dfc:	68 06 04 00 00       	push   $0x406
  801e01:	50                   	push   %eax
  801e02:	e8 93 18 00 00       	call   80369a <__sys_allocate_page>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e11:	79 14                	jns    801e27 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	68 5c 51 80 00       	push   $0x80515c
  801e1b:	6a 1f                	push   $0x1f
  801e1d:	68 98 51 80 00       	push   $0x805198
  801e22:	e8 0f 28 00 00       	call   804636 <_panic>
	return 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e42:	83 ec 0c             	sub    $0xc,%esp
  801e45:	50                   	push   %eax
  801e46:	e8 96 18 00 00       	call   8036e1 <__sys_unmap_frame>
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e55:	79 14                	jns    801e6b <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	68 a4 51 80 00       	push   $0x8051a4
  801e5f:	6a 2a                	push   $0x2a
  801e61:	68 98 51 80 00       	push   $0x805198
  801e66:	e8 cb 27 00 00       	call   804636 <_panic>
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e74:	e8 18 ff ff ff       	call   801d91 <uheap_init>
	if (size == 0) return NULL ;
  801e79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e7d:	75 0a                	jne    801e89 <malloc+0x1b>
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e84:	e9 43 03 00 00       	jmp    8021cc <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801e89:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e90:	77 13                	ja     801ea5 <malloc+0x37>
    {
        return alloc_block(size);
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	ff 75 08             	pushl  0x8(%ebp)
  801e98:	e8 78 20 00 00       	call   803f15 <alloc_block>
  801e9d:	83 c4 10             	add    $0x10,%esp
  801ea0:	e9 27 03 00 00       	jmp    8021cc <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801ea5:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801eac:	8b 55 08             	mov    0x8(%ebp),%edx
  801eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb2:	01 d0                	add    %edx,%eax
  801eb4:	48                   	dec    %eax
  801eb5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801eb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec0:	f7 75 dc             	divl   -0x24(%ebp)
  801ec3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ec6:	29 d0                	sub    %edx,%eax
  801ec8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801ecb:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	75 0a                	jne    801ede <malloc+0x70>
    {
        uhp_inited = 1;
  801ed4:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801edb:	00 00 00 
    }

    int exactIdx = -1;
  801ede:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ee5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801eec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ef3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801efa:	e9 85 00 00 00       	jmp    801f84 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801eff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f02:	89 d0                	mov    %edx,%eax
  801f04:	01 c0                	add    %eax,%eax
  801f06:	01 d0                	add    %edx,%eax
  801f08:	c1 e0 02             	shl    $0x2,%eax
  801f0b:	05 48 20 81 00       	add    $0x812048,%eax
  801f10:	8a 00                	mov    (%eax),%al
  801f12:	84 c0                	test   %al,%al
  801f14:	74 20                	je     801f36 <malloc+0xc8>
  801f16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f19:	89 d0                	mov    %edx,%eax
  801f1b:	01 c0                	add    %eax,%eax
  801f1d:	01 d0                	add    %edx,%eax
  801f1f:	c1 e0 02             	shl    $0x2,%eax
  801f22:	05 44 20 81 00       	add    $0x812044,%eax
  801f27:	8b 00                	mov    (%eax),%eax
  801f29:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f2c:	75 08                	jne    801f36 <malloc+0xc8>
        {
            exactIdx = i;
  801f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f34:	eb 5b                	jmp    801f91 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f36:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f39:	89 d0                	mov    %edx,%eax
  801f3b:	01 c0                	add    %eax,%eax
  801f3d:	01 d0                	add    %edx,%eax
  801f3f:	c1 e0 02             	shl    $0x2,%eax
  801f42:	05 48 20 81 00       	add    $0x812048,%eax
  801f47:	8a 00                	mov    (%eax),%al
  801f49:	84 c0                	test   %al,%al
  801f4b:	74 34                	je     801f81 <malloc+0x113>
  801f4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f50:	89 d0                	mov    %edx,%eax
  801f52:	01 c0                	add    %eax,%eax
  801f54:	01 d0                	add    %edx,%eax
  801f56:	c1 e0 02             	shl    $0x2,%eax
  801f59:	05 44 20 81 00       	add    $0x812044,%eax
  801f5e:	8b 00                	mov    (%eax),%eax
  801f60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f63:	76 1c                	jbe    801f81 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801f65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f68:	89 d0                	mov    %edx,%eax
  801f6a:	01 c0                	add    %eax,%eax
  801f6c:	01 d0                	add    %edx,%eax
  801f6e:	c1 e0 02             	shl    $0x2,%eax
  801f71:	05 44 20 81 00       	add    $0x812044,%eax
  801f76:	8b 00                	mov    (%eax),%eax
  801f78:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f81:	ff 45 e8             	incl   -0x18(%ebp)
  801f84:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f8b:	0f 8e 6e ff ff ff    	jle    801eff <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801f91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f98:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f9c:	74 7d                	je     80201b <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f9e:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa8:	89 d0                	mov    %edx,%eax
  801faa:	01 c0                	add    %eax,%eax
  801fac:	01 d0                	add    %edx,%eax
  801fae:	c1 e0 02             	shl    $0x2,%eax
  801fb1:	05 40 20 81 00       	add    $0x812040,%eax
  801fb6:	8b 10                	mov    (%eax),%edx
  801fb8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801fbb:	01 d0                	add    %edx,%eax
  801fbd:	48                   	dec    %eax
  801fbe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801fc1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fc4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc9:	f7 75 bc             	divl   -0x44(%ebp)
  801fcc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fcf:	29 d0                	sub    %edx,%eax
  801fd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd7:	89 d0                	mov    %edx,%eax
  801fd9:	01 c0                	add    %eax,%eax
  801fdb:	01 d0                	add    %edx,%eax
  801fdd:	c1 e0 02             	shl    $0x2,%eax
  801fe0:	05 48 20 81 00       	add    $0x812048,%eax
  801fe5:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801feb:	89 d0                	mov    %edx,%eax
  801fed:	01 c0                	add    %eax,%eax
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	c1 e0 02             	shl    $0x2,%eax
  801ff4:	05 44 20 81 00       	add    $0x812044,%eax
  801ff9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	89 d0                	mov    %edx,%eax
  802004:	01 c0                	add    %eax,%eax
  802006:	01 d0                	add    %edx,%eax
  802008:	c1 e0 02             	shl    $0x2,%eax
  80200b:	05 40 20 81 00       	add    $0x812040,%eax
  802010:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802016:	e9 2d 01 00 00       	jmp    802148 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  80201b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80201f:	0f 84 ce 00 00 00    	je     8020f3 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802025:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80202c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80202f:	89 d0                	mov    %edx,%eax
  802031:	01 c0                	add    %eax,%eax
  802033:	01 d0                	add    %edx,%eax
  802035:	c1 e0 02             	shl    $0x2,%eax
  802038:	05 40 20 81 00       	add    $0x812040,%eax
  80203d:	8b 10                	mov    (%eax),%edx
  80203f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802042:	01 d0                	add    %edx,%eax
  802044:	48                   	dec    %eax
  802045:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802048:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80204b:	ba 00 00 00 00       	mov    $0x0,%edx
  802050:	f7 75 c4             	divl   -0x3c(%ebp)
  802053:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802056:	29 d0                	sub    %edx,%eax
  802058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80205b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80205e:	89 d0                	mov    %edx,%eax
  802060:	01 c0                	add    %eax,%eax
  802062:	01 d0                	add    %edx,%eax
  802064:	c1 e0 02             	shl    $0x2,%eax
  802067:	05 44 20 81 00       	add    $0x812044,%eax
  80206c:	8b 00                	mov    (%eax),%eax
  80206e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802071:	75 47                	jne    8020ba <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  802073:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802076:	89 d0                	mov    %edx,%eax
  802078:	01 c0                	add    %eax,%eax
  80207a:	01 d0                	add    %edx,%eax
  80207c:	c1 e0 02             	shl    $0x2,%eax
  80207f:	05 48 20 81 00       	add    $0x812048,%eax
  802084:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802087:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80208a:	89 d0                	mov    %edx,%eax
  80208c:	01 c0                	add    %eax,%eax
  80208e:	01 d0                	add    %edx,%eax
  802090:	c1 e0 02             	shl    $0x2,%eax
  802093:	05 44 20 81 00       	add    $0x812044,%eax
  802098:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80209e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a1:	89 d0                	mov    %edx,%eax
  8020a3:	01 c0                	add    %eax,%eax
  8020a5:	01 d0                	add    %edx,%eax
  8020a7:	c1 e0 02             	shl    $0x2,%eax
  8020aa:	05 40 20 81 00       	add    $0x812040,%eax
  8020af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020b5:	e9 8e 00 00 00       	jmp    802148 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8020ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020c0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020c6:	89 d0                	mov    %edx,%eax
  8020c8:	01 c0                	add    %eax,%eax
  8020ca:	01 d0                	add    %edx,%eax
  8020cc:	c1 e0 02             	shl    $0x2,%eax
  8020cf:	05 40 20 81 00       	add    $0x812040,%eax
  8020d4:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020dc:	89 c2                	mov    %eax,%edx
  8020de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020e1:	89 c8                	mov    %ecx,%eax
  8020e3:	01 c0                	add    %eax,%eax
  8020e5:	01 c8                	add    %ecx,%eax
  8020e7:	c1 e0 02             	shl    $0x2,%eax
  8020ea:	05 44 20 81 00       	add    $0x812044,%eax
  8020ef:	89 10                	mov    %edx,(%eax)
  8020f1:	eb 55                	jmp    802148 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020f3:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020fa:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802100:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802103:	01 d0                	add    %edx,%eax
  802105:	48                   	dec    %eax
  802106:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802109:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80210c:	ba 00 00 00 00       	mov    $0x0,%edx
  802111:	f7 75 d0             	divl   -0x30(%ebp)
  802114:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802117:	29 d0                	sub    %edx,%eax
  802119:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80211c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80211f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802122:	01 d0                	add    %edx,%eax
  802124:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802129:	76 0a                	jbe    802135 <malloc+0x2c7>
            return NULL;
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
  802130:	e9 97 00 00 00       	jmp    8021cc <malloc+0x35e>
        va = start;
  802135:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802138:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80213b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80213e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802141:	01 d0                	add    %edx,%eax
  802143:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802148:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80214f:	eb 5e                	jmp    8021af <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  802151:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802154:	89 d0                	mov    %edx,%eax
  802156:	01 c0                	add    %eax,%eax
  802158:	01 d0                	add    %edx,%eax
  80215a:	c1 e0 02             	shl    $0x2,%eax
  80215d:	05 48 60 80 00       	add    $0x806048,%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	84 c0                	test   %al,%al
  802166:	75 44                	jne    8021ac <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  802168:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80216b:	89 d0                	mov    %edx,%eax
  80216d:	01 c0                	add    %eax,%eax
  80216f:	01 d0                	add    %edx,%eax
  802171:	c1 e0 02             	shl    $0x2,%eax
  802174:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80217a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80217d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80217f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802182:	89 d0                	mov    %edx,%eax
  802184:	01 c0                	add    %eax,%eax
  802186:	01 d0                	add    %edx,%eax
  802188:	c1 e0 02             	shl    $0x2,%eax
  80218b:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802191:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802194:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802196:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802199:	89 d0                	mov    %edx,%eax
  80219b:	01 c0                	add    %eax,%eax
  80219d:	01 d0                	add    %edx,%eax
  80219f:	c1 e0 02             	shl    $0x2,%eax
  8021a2:	05 48 60 80 00       	add    $0x806048,%eax
  8021a7:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8021aa:	eb 0c                	jmp    8021b8 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8021ac:	ff 45 e0             	incl   -0x20(%ebp)
  8021af:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8021b6:	7e 99                	jle    802151 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8021b8:	83 ec 08             	sub    $0x8,%esp
  8021bb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021c1:	e8 a2 19 00 00       	call   803b68 <sys_allocate_user_mem>
  8021c6:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8021c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8021d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d8:	0f 84 fa 03 00 00    	je     8025d8 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8021e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	79 1c                	jns    802207 <free+0x39>
  8021eb:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  8021f2:	77 13                	ja     802207 <free+0x39>
    {
        free_block(virtual_address);
  8021f4:	83 ec 0c             	sub    $0xc,%esp
  8021f7:	ff 75 08             	pushl  0x8(%ebp)
  8021fa:	e8 09 21 00 00       	call   804308 <free_block>
  8021ff:	83 c4 10             	add    $0x10,%esp
        return;
  802202:	e9 d2 03 00 00       	jmp    8025d9 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802207:	a1 30 61 83 00       	mov    0x836130,%eax
  80220c:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  80220f:	72 09                	jb     80221a <free+0x4c>
  802211:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  802218:	76 17                	jbe    802231 <free+0x63>
        panic("free: invalid address");
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	68 e1 51 80 00       	push   $0x8051e1
  802222:	68 9b 00 00 00       	push   $0x9b
  802227:	68 98 51 80 00       	push   $0x805198
  80222c:	e8 05 24 00 00       	call   804636 <_panic>

    uint32 size = 0;
  802231:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  802238:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80223f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802246:	eb 50                	jmp    802298 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802248:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80224b:	89 d0                	mov    %edx,%eax
  80224d:	01 c0                	add    %eax,%eax
  80224f:	01 d0                	add    %edx,%eax
  802251:	c1 e0 02             	shl    $0x2,%eax
  802254:	05 48 60 80 00       	add    $0x806048,%eax
  802259:	8a 00                	mov    (%eax),%al
  80225b:	84 c0                	test   %al,%al
  80225d:	74 36                	je     802295 <free+0xc7>
  80225f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802262:	89 d0                	mov    %edx,%eax
  802264:	01 c0                	add    %eax,%eax
  802266:	01 d0                	add    %edx,%eax
  802268:	c1 e0 02             	shl    $0x2,%eax
  80226b:	05 40 60 80 00       	add    $0x806040,%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802275:	75 1e                	jne    802295 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  802277:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80227a:	89 d0                	mov    %edx,%eax
  80227c:	01 c0                	add    %eax,%eax
  80227e:	01 d0                	add    %edx,%eax
  802280:	c1 e0 02             	shl    $0x2,%eax
  802283:	05 44 60 80 00       	add    $0x806044,%eax
  802288:	8b 00                	mov    (%eax),%eax
  80228a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  80228d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802290:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  802293:	eb 0c                	jmp    8022a1 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802295:	ff 45 ec             	incl   -0x14(%ebp)
  802298:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80229f:	7e a7                	jle    802248 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  8022a1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8022a5:	74 06                	je     8022ad <free+0xdf>
  8022a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ab:	75 17                	jne    8022c4 <free+0xf6>
        panic("free: unknown block");
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	68 f7 51 80 00       	push   $0x8051f7
  8022b5:	68 a9 00 00 00       	push   $0xa9
  8022ba:	68 98 51 80 00       	push   $0x805198
  8022bf:	e8 72 23 00 00       	call   804636 <_panic>

    uhp_allocs[idx].used = 0;
  8022c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c7:	89 d0                	mov    %edx,%eax
  8022c9:	01 c0                	add    %eax,%eax
  8022cb:	01 d0                	add    %edx,%eax
  8022cd:	c1 e0 02             	shl    $0x2,%eax
  8022d0:	05 48 60 80 00       	add    $0x806048,%eax
  8022d5:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8022d8:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8022e6:	eb 64                	jmp    80234c <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8022e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022eb:	89 d0                	mov    %edx,%eax
  8022ed:	01 c0                	add    %eax,%eax
  8022ef:	01 d0                	add    %edx,%eax
  8022f1:	c1 e0 02             	shl    $0x2,%eax
  8022f4:	05 48 20 81 00       	add    $0x812048,%eax
  8022f9:	8a 00                	mov    (%eax),%al
  8022fb:	84 c0                	test   %al,%al
  8022fd:	75 4a                	jne    802349 <free+0x17b>
        {
            uhp_frees[i].va = va;
  8022ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802302:	89 d0                	mov    %edx,%eax
  802304:	01 c0                	add    %eax,%eax
  802306:	01 d0                	add    %edx,%eax
  802308:	c1 e0 02             	shl    $0x2,%eax
  80230b:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802311:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802314:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802316:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802319:	89 d0                	mov    %edx,%eax
  80231b:	01 c0                	add    %eax,%eax
  80231d:	01 d0                	add    %edx,%eax
  80231f:	c1 e0 02             	shl    $0x2,%eax
  802322:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  80232d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802330:	89 d0                	mov    %edx,%eax
  802332:	01 c0                	add    %eax,%eax
  802334:	01 d0                	add    %edx,%eax
  802336:	c1 e0 02             	shl    $0x2,%eax
  802339:	05 48 20 81 00       	add    $0x812048,%eax
  80233e:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802341:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802344:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802347:	eb 0c                	jmp    802355 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802349:	ff 45 e4             	incl   -0x1c(%ebp)
  80234c:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802353:	7e 93                	jle    8022e8 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  802355:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802359:	0f 84 f1 01 00 00    	je     802550 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80235f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802366:	e9 d8 01 00 00       	jmp    802543 <free+0x375>
        {
            if (i == fidx) continue;
  80236b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802371:	0f 84 c8 01 00 00    	je     80253f <free+0x371>
            if (uhp_frees[i].free)
  802377:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80237a:	89 d0                	mov    %edx,%eax
  80237c:	01 c0                	add    %eax,%eax
  80237e:	01 d0                	add    %edx,%eax
  802380:	c1 e0 02             	shl    $0x2,%eax
  802383:	05 48 20 81 00       	add    $0x812048,%eax
  802388:	8a 00                	mov    (%eax),%al
  80238a:	84 c0                	test   %al,%al
  80238c:	0f 84 ae 01 00 00    	je     802540 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  802392:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802395:	89 d0                	mov    %edx,%eax
  802397:	01 c0                	add    %eax,%eax
  802399:	01 d0                	add    %edx,%eax
  80239b:	c1 e0 02             	shl    $0x2,%eax
  80239e:	05 40 20 81 00       	add    $0x812040,%eax
  8023a3:	8b 08                	mov    (%eax),%ecx
  8023a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a8:	89 d0                	mov    %edx,%eax
  8023aa:	01 c0                	add    %eax,%eax
  8023ac:	01 d0                	add    %edx,%eax
  8023ae:	c1 e0 02             	shl    $0x2,%eax
  8023b1:	05 44 20 81 00       	add    $0x812044,%eax
  8023b6:	8b 00                	mov    (%eax),%eax
  8023b8:	01 c1                	add    %eax,%ecx
  8023ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023bd:	89 d0                	mov    %edx,%eax
  8023bf:	01 c0                	add    %eax,%eax
  8023c1:	01 d0                	add    %edx,%eax
  8023c3:	c1 e0 02             	shl    $0x2,%eax
  8023c6:	05 40 20 81 00       	add    $0x812040,%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	39 c1                	cmp    %eax,%ecx
  8023cf:	0f 85 a8 00 00 00    	jne    80247d <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  8023d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023d8:	89 d0                	mov    %edx,%eax
  8023da:	01 c0                	add    %eax,%eax
  8023dc:	01 d0                	add    %edx,%eax
  8023de:	c1 e0 02             	shl    $0x2,%eax
  8023e1:	05 40 20 81 00       	add    $0x812040,%eax
  8023e6:	8b 10                	mov    (%eax),%edx
  8023e8:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8023eb:	89 c8                	mov    %ecx,%eax
  8023ed:	01 c0                	add    %eax,%eax
  8023ef:	01 c8                	add    %ecx,%eax
  8023f1:	c1 e0 02             	shl    $0x2,%eax
  8023f4:	05 40 20 81 00       	add    $0x812040,%eax
  8023f9:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8023fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023fe:	89 d0                	mov    %edx,%eax
  802400:	01 c0                	add    %eax,%eax
  802402:	01 d0                	add    %edx,%eax
  802404:	c1 e0 02             	shl    $0x2,%eax
  802407:	05 44 20 81 00       	add    $0x812044,%eax
  80240c:	8b 08                	mov    (%eax),%ecx
  80240e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802411:	89 d0                	mov    %edx,%eax
  802413:	01 c0                	add    %eax,%eax
  802415:	01 d0                	add    %edx,%eax
  802417:	c1 e0 02             	shl    $0x2,%eax
  80241a:	05 44 20 81 00       	add    $0x812044,%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	01 c1                	add    %eax,%ecx
  802423:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802426:	89 d0                	mov    %edx,%eax
  802428:	01 c0                	add    %eax,%eax
  80242a:	01 d0                	add    %edx,%eax
  80242c:	c1 e0 02             	shl    $0x2,%eax
  80242f:	05 44 20 81 00       	add    $0x812044,%eax
  802434:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802436:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802439:	89 d0                	mov    %edx,%eax
  80243b:	01 c0                	add    %eax,%eax
  80243d:	01 d0                	add    %edx,%eax
  80243f:	c1 e0 02             	shl    $0x2,%eax
  802442:	05 48 20 81 00       	add    $0x812048,%eax
  802447:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80244a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80244d:	89 d0                	mov    %edx,%eax
  80244f:	01 c0                	add    %eax,%eax
  802451:	01 d0                	add    %edx,%eax
  802453:	c1 e0 02             	shl    $0x2,%eax
  802456:	05 40 20 81 00       	add    $0x812040,%eax
  80245b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802461:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802464:	89 d0                	mov    %edx,%eax
  802466:	01 c0                	add    %eax,%eax
  802468:	01 d0                	add    %edx,%eax
  80246a:	c1 e0 02             	shl    $0x2,%eax
  80246d:	05 44 20 81 00       	add    $0x812044,%eax
  802472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802478:	e9 c3 00 00 00       	jmp    802540 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  80247d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802480:	89 d0                	mov    %edx,%eax
  802482:	01 c0                	add    %eax,%eax
  802484:	01 d0                	add    %edx,%eax
  802486:	c1 e0 02             	shl    $0x2,%eax
  802489:	05 40 20 81 00       	add    $0x812040,%eax
  80248e:	8b 08                	mov    (%eax),%ecx
  802490:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802493:	89 d0                	mov    %edx,%eax
  802495:	01 c0                	add    %eax,%eax
  802497:	01 d0                	add    %edx,%eax
  802499:	c1 e0 02             	shl    $0x2,%eax
  80249c:	05 44 20 81 00       	add    $0x812044,%eax
  8024a1:	8b 00                	mov    (%eax),%eax
  8024a3:	01 c1                	add    %eax,%ecx
  8024a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024a8:	89 d0                	mov    %edx,%eax
  8024aa:	01 c0                	add    %eax,%eax
  8024ac:	01 d0                	add    %edx,%eax
  8024ae:	c1 e0 02             	shl    $0x2,%eax
  8024b1:	05 40 20 81 00       	add    $0x812040,%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	39 c1                	cmp    %eax,%ecx
  8024ba:	0f 85 80 00 00 00    	jne    802540 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8024c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024c3:	89 d0                	mov    %edx,%eax
  8024c5:	01 c0                	add    %eax,%eax
  8024c7:	01 d0                	add    %edx,%eax
  8024c9:	c1 e0 02             	shl    $0x2,%eax
  8024cc:	05 44 20 81 00       	add    $0x812044,%eax
  8024d1:	8b 08                	mov    (%eax),%ecx
  8024d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024d6:	89 d0                	mov    %edx,%eax
  8024d8:	01 c0                	add    %eax,%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	c1 e0 02             	shl    $0x2,%eax
  8024df:	05 44 20 81 00       	add    $0x812044,%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	01 c1                	add    %eax,%ecx
  8024e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024eb:	89 d0                	mov    %edx,%eax
  8024ed:	01 c0                	add    %eax,%eax
  8024ef:	01 d0                	add    %edx,%eax
  8024f1:	c1 e0 02             	shl    $0x2,%eax
  8024f4:	05 44 20 81 00       	add    $0x812044,%eax
  8024f9:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8024fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024fe:	89 d0                	mov    %edx,%eax
  802500:	01 c0                	add    %eax,%eax
  802502:	01 d0                	add    %edx,%eax
  802504:	c1 e0 02             	shl    $0x2,%eax
  802507:	05 48 20 81 00       	add    $0x812048,%eax
  80250c:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80250f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	01 c0                	add    %eax,%eax
  802516:	01 d0                	add    %edx,%eax
  802518:	c1 e0 02             	shl    $0x2,%eax
  80251b:	05 40 20 81 00       	add    $0x812040,%eax
  802520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802526:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802529:	89 d0                	mov    %edx,%eax
  80252b:	01 c0                	add    %eax,%eax
  80252d:	01 d0                	add    %edx,%eax
  80252f:	c1 e0 02             	shl    $0x2,%eax
  802532:	05 44 20 81 00       	add    $0x812044,%eax
  802537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253d:	eb 01                	jmp    802540 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  80253f:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802540:	ff 45 e0             	incl   -0x20(%ebp)
  802543:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80254a:	0f 8e 1b fe ff ff    	jle    80236b <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802550:	a1 30 61 83 00       	mov    0x836130,%eax
  802555:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802558:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80255f:	eb 53                	jmp    8025b4 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802561:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802564:	89 d0                	mov    %edx,%eax
  802566:	01 c0                	add    %eax,%eax
  802568:	01 d0                	add    %edx,%eax
  80256a:	c1 e0 02             	shl    $0x2,%eax
  80256d:	05 48 60 80 00       	add    $0x806048,%eax
  802572:	8a 00                	mov    (%eax),%al
  802574:	84 c0                	test   %al,%al
  802576:	74 39                	je     8025b1 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802578:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80257b:	89 d0                	mov    %edx,%eax
  80257d:	01 c0                	add    %eax,%eax
  80257f:	01 d0                	add    %edx,%eax
  802581:	c1 e0 02             	shl    $0x2,%eax
  802584:	05 40 60 80 00       	add    $0x806040,%eax
  802589:	8b 08                	mov    (%eax),%ecx
  80258b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80258e:	89 d0                	mov    %edx,%eax
  802590:	01 c0                	add    %eax,%eax
  802592:	01 d0                	add    %edx,%eax
  802594:	c1 e0 02             	shl    $0x2,%eax
  802597:	05 44 60 80 00       	add    $0x806044,%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	01 c8                	add    %ecx,%eax
  8025a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  8025a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025a6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8025a9:	76 06                	jbe    8025b1 <free+0x3e3>
  8025ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025b1:	ff 45 d8             	incl   -0x28(%ebp)
  8025b4:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8025bb:	7e a4                	jle    802561 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  8025bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025c0:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  8025c5:	83 ec 08             	sub    $0x8,%esp
  8025c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025cb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8025ce:	e8 79 15 00 00       	call   803b4c <sys_free_user_mem>
  8025d3:	83 c4 10             	add    $0x10,%esp
  8025d6:	eb 01                	jmp    8025d9 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  8025d8:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 68             	sub    $0x68,%esp
  8025e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e4:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025e7:	e8 a5 f7 ff ff       	call   801d91 <uheap_init>
	if (size == 0) return NULL ;
  8025ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025f0:	75 0a                	jne    8025fc <smalloc+0x21>
  8025f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f7:	e9 37 03 00 00       	jmp    802933 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8025fc:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802603:	8b 55 0c             	mov    0xc(%ebp),%edx
  802606:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802609:	01 d0                	add    %edx,%eax
  80260b:	48                   	dec    %eax
  80260c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80260f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802612:	ba 00 00 00 00       	mov    $0x0,%edx
  802617:	f7 75 dc             	divl   -0x24(%ebp)
  80261a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80261d:	29 d0                	sub    %edx,%eax
  80261f:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802622:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802629:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802630:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802637:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80263e:	e9 85 00 00 00       	jmp    8026c8 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802643:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802646:	89 d0                	mov    %edx,%eax
  802648:	01 c0                	add    %eax,%eax
  80264a:	01 d0                	add    %edx,%eax
  80264c:	c1 e0 02             	shl    $0x2,%eax
  80264f:	05 48 20 81 00       	add    $0x812048,%eax
  802654:	8a 00                	mov    (%eax),%al
  802656:	84 c0                	test   %al,%al
  802658:	74 20                	je     80267a <smalloc+0x9f>
  80265a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80265d:	89 d0                	mov    %edx,%eax
  80265f:	01 c0                	add    %eax,%eax
  802661:	01 d0                	add    %edx,%eax
  802663:	c1 e0 02             	shl    $0x2,%eax
  802666:	05 44 20 81 00       	add    $0x812044,%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802670:	75 08                	jne    80267a <smalloc+0x9f>
        {
            exactIdx = i;
  802672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802675:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802678:	eb 5b                	jmp    8026d5 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80267a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80267d:	89 d0                	mov    %edx,%eax
  80267f:	01 c0                	add    %eax,%eax
  802681:	01 d0                	add    %edx,%eax
  802683:	c1 e0 02             	shl    $0x2,%eax
  802686:	05 48 20 81 00       	add    $0x812048,%eax
  80268b:	8a 00                	mov    (%eax),%al
  80268d:	84 c0                	test   %al,%al
  80268f:	74 34                	je     8026c5 <smalloc+0xea>
  802691:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802694:	89 d0                	mov    %edx,%eax
  802696:	01 c0                	add    %eax,%eax
  802698:	01 d0                	add    %edx,%eax
  80269a:	c1 e0 02             	shl    $0x2,%eax
  80269d:	05 44 20 81 00       	add    $0x812044,%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026a7:	76 1c                	jbe    8026c5 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8026a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ac:	89 d0                	mov    %edx,%eax
  8026ae:	01 c0                	add    %eax,%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	c1 e0 02             	shl    $0x2,%eax
  8026b5:	05 44 20 81 00       	add    $0x812044,%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8026bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c2:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8026c5:	ff 45 e8             	incl   -0x18(%ebp)
  8026c8:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8026cf:	0f 8e 6e ff ff ff    	jle    802643 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8026d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8026dc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8026e0:	74 7d                	je     80275f <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8026e2:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8026e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ec:	89 d0                	mov    %edx,%eax
  8026ee:	01 c0                	add    %eax,%eax
  8026f0:	01 d0                	add    %edx,%eax
  8026f2:	c1 e0 02             	shl    $0x2,%eax
  8026f5:	05 40 20 81 00       	add    $0x812040,%eax
  8026fa:	8b 10                	mov    (%eax),%edx
  8026fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026ff:	01 d0                	add    %edx,%eax
  802701:	48                   	dec    %eax
  802702:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802705:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802708:	ba 00 00 00 00       	mov    $0x0,%edx
  80270d:	f7 75 bc             	divl   -0x44(%ebp)
  802710:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802713:	29 d0                	sub    %edx,%eax
  802715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271b:	89 d0                	mov    %edx,%eax
  80271d:	01 c0                	add    %eax,%eax
  80271f:	01 d0                	add    %edx,%eax
  802721:	c1 e0 02             	shl    $0x2,%eax
  802724:	05 48 20 81 00       	add    $0x812048,%eax
  802729:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80272c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272f:	89 d0                	mov    %edx,%eax
  802731:	01 c0                	add    %eax,%eax
  802733:	01 d0                	add    %edx,%eax
  802735:	c1 e0 02             	shl    $0x2,%eax
  802738:	05 44 20 81 00       	add    $0x812044,%eax
  80273d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802746:	89 d0                	mov    %edx,%eax
  802748:	01 c0                	add    %eax,%eax
  80274a:	01 d0                	add    %edx,%eax
  80274c:	c1 e0 02             	shl    $0x2,%eax
  80274f:	05 40 20 81 00       	add    $0x812040,%eax
  802754:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275a:	e9 2d 01 00 00       	jmp    80288c <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  80275f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802763:	0f 84 ce 00 00 00    	je     802837 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802769:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802770:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802773:	89 d0                	mov    %edx,%eax
  802775:	01 c0                	add    %eax,%eax
  802777:	01 d0                	add    %edx,%eax
  802779:	c1 e0 02             	shl    $0x2,%eax
  80277c:	05 40 20 81 00       	add    $0x812040,%eax
  802781:	8b 10                	mov    (%eax),%edx
  802783:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802786:	01 d0                	add    %edx,%eax
  802788:	48                   	dec    %eax
  802789:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80278c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80278f:	ba 00 00 00 00       	mov    $0x0,%edx
  802794:	f7 75 c4             	divl   -0x3c(%ebp)
  802797:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80279a:	29 d0                	sub    %edx,%eax
  80279c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80279f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a2:	89 d0                	mov    %edx,%eax
  8027a4:	01 c0                	add    %eax,%eax
  8027a6:	01 d0                	add    %edx,%eax
  8027a8:	c1 e0 02             	shl    $0x2,%eax
  8027ab:	05 44 20 81 00       	add    $0x812044,%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8027b5:	75 47                	jne    8027fe <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  8027b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ba:	89 d0                	mov    %edx,%eax
  8027bc:	01 c0                	add    %eax,%eax
  8027be:	01 d0                	add    %edx,%eax
  8027c0:	c1 e0 02             	shl    $0x2,%eax
  8027c3:	05 48 20 81 00       	add    $0x812048,%eax
  8027c8:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8027cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ce:	89 d0                	mov    %edx,%eax
  8027d0:	01 c0                	add    %eax,%eax
  8027d2:	01 d0                	add    %edx,%eax
  8027d4:	c1 e0 02             	shl    $0x2,%eax
  8027d7:	05 44 20 81 00       	add    $0x812044,%eax
  8027dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8027e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e5:	89 d0                	mov    %edx,%eax
  8027e7:	01 c0                	add    %eax,%eax
  8027e9:	01 d0                	add    %edx,%eax
  8027eb:	c1 e0 02             	shl    $0x2,%eax
  8027ee:	05 40 20 81 00       	add    $0x812040,%eax
  8027f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f9:	e9 8e 00 00 00       	jmp    80288c <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8027fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802801:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802804:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802807:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80280a:	89 d0                	mov    %edx,%eax
  80280c:	01 c0                	add    %eax,%eax
  80280e:	01 d0                	add    %edx,%eax
  802810:	c1 e0 02             	shl    $0x2,%eax
  802813:	05 40 20 81 00       	add    $0x812040,%eax
  802818:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80281a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802820:	89 c2                	mov    %eax,%edx
  802822:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802825:	89 c8                	mov    %ecx,%eax
  802827:	01 c0                	add    %eax,%eax
  802829:	01 c8                	add    %ecx,%eax
  80282b:	c1 e0 02             	shl    $0x2,%eax
  80282e:	05 44 20 81 00       	add    $0x812044,%eax
  802833:	89 10                	mov    %edx,(%eax)
  802835:	eb 55                	jmp    80288c <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802837:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80283e:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802844:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802847:	01 d0                	add    %edx,%eax
  802849:	48                   	dec    %eax
  80284a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80284d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802850:	ba 00 00 00 00       	mov    $0x0,%edx
  802855:	f7 75 d0             	divl   -0x30(%ebp)
  802858:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285b:	29 d0                	sub    %edx,%eax
  80285d:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802860:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802866:	01 d0                	add    %edx,%eax
  802868:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80286d:	76 0a                	jbe    802879 <smalloc+0x29e>
            return NULL;
  80286f:	b8 00 00 00 00       	mov    $0x0,%eax
  802874:	e9 ba 00 00 00       	jmp    802933 <smalloc+0x358>
        va = start;
  802879:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80287c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80287f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802885:	01 d0                	add    %edx,%eax
  802887:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80288c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802893:	eb 5e                	jmp    8028f3 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802895:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802898:	89 d0                	mov    %edx,%eax
  80289a:	01 c0                	add    %eax,%eax
  80289c:	01 d0                	add    %edx,%eax
  80289e:	c1 e0 02             	shl    $0x2,%eax
  8028a1:	05 48 60 80 00       	add    $0x806048,%eax
  8028a6:	8a 00                	mov    (%eax),%al
  8028a8:	84 c0                	test   %al,%al
  8028aa:	75 44                	jne    8028f0 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8028ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028af:	89 d0                	mov    %edx,%eax
  8028b1:	01 c0                	add    %eax,%eax
  8028b3:	01 d0                	add    %edx,%eax
  8028b5:	c1 e0 02             	shl    $0x2,%eax
  8028b8:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  8028be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c1:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8028c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028c6:	89 d0                	mov    %edx,%eax
  8028c8:	01 c0                	add    %eax,%eax
  8028ca:	01 d0                	add    %edx,%eax
  8028cc:	c1 e0 02             	shl    $0x2,%eax
  8028cf:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8028d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028d8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8028da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028dd:	89 d0                	mov    %edx,%eax
  8028df:	01 c0                	add    %eax,%eax
  8028e1:	01 d0                	add    %edx,%eax
  8028e3:	c1 e0 02             	shl    $0x2,%eax
  8028e6:	05 48 60 80 00       	add    $0x806048,%eax
  8028eb:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8028ee:	eb 0c                	jmp    8028fc <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8028f0:	ff 45 e0             	incl   -0x20(%ebp)
  8028f3:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8028fa:	7e 99                	jle    802895 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8028fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028ff:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802903:	52                   	push   %edx
  802904:	50                   	push   %eax
  802905:	ff 75 d4             	pushl  -0x2c(%ebp)
  802908:	ff 75 08             	pushl  0x8(%ebp)
  80290b:	e8 de 0e 00 00       	call   8037ee <sys_create_shared_object>
  802910:	83 c4 10             	add    $0x10,%esp
  802913:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802916:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80291a:	75 07                	jne    802923 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80291c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802921:	eb 10                	jmp    802933 <smalloc+0x358>
    if (r < 0)
  802923:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802927:	79 07                	jns    802930 <smalloc+0x355>
        return NULL;
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
  80292e:	eb 03                	jmp    802933 <smalloc+0x358>
    return (void*)va;
  802930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80293b:	e8 51 f4 ff ff       	call   801d91 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802940:	83 ec 08             	sub    $0x8,%esp
  802943:	ff 75 0c             	pushl  0xc(%ebp)
  802946:	ff 75 08             	pushl  0x8(%ebp)
  802949:	e8 ca 0e 00 00       	call   803818 <sys_size_of_shared_object>
  80294e:	83 c4 10             	add    $0x10,%esp
  802951:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802954:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802958:	7f 0a                	jg     802964 <sget+0x2f>
        return NULL;
  80295a:	b8 00 00 00 00       	mov    $0x0,%eax
  80295f:	e9 28 03 00 00       	jmp    802c8c <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802964:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80296b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80296e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802971:	01 d0                	add    %edx,%eax
  802973:	48                   	dec    %eax
  802974:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802977:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80297a:	ba 00 00 00 00       	mov    $0x0,%edx
  80297f:	f7 75 d8             	divl   -0x28(%ebp)
  802982:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802985:	29 d0                	sub    %edx,%eax
  802987:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80298a:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802991:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802998:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80299f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8029a6:	e9 85 00 00 00       	jmp    802a30 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8029ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029ae:	89 d0                	mov    %edx,%eax
  8029b0:	01 c0                	add    %eax,%eax
  8029b2:	01 d0                	add    %edx,%eax
  8029b4:	c1 e0 02             	shl    $0x2,%eax
  8029b7:	05 48 20 81 00       	add    $0x812048,%eax
  8029bc:	8a 00                	mov    (%eax),%al
  8029be:	84 c0                	test   %al,%al
  8029c0:	74 20                	je     8029e2 <sget+0xad>
  8029c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c5:	89 d0                	mov    %edx,%eax
  8029c7:	01 c0                	add    %eax,%eax
  8029c9:	01 d0                	add    %edx,%eax
  8029cb:	c1 e0 02             	shl    $0x2,%eax
  8029ce:	05 44 20 81 00       	add    $0x812044,%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8029d8:	75 08                	jne    8029e2 <sget+0xad>
        {
            exactIdx = i;
  8029da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8029e0:	eb 5b                	jmp    802a3d <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8029e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e5:	89 d0                	mov    %edx,%eax
  8029e7:	01 c0                	add    %eax,%eax
  8029e9:	01 d0                	add    %edx,%eax
  8029eb:	c1 e0 02             	shl    $0x2,%eax
  8029ee:	05 48 20 81 00       	add    $0x812048,%eax
  8029f3:	8a 00                	mov    (%eax),%al
  8029f5:	84 c0                	test   %al,%al
  8029f7:	74 34                	je     802a2d <sget+0xf8>
  8029f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029fc:	89 d0                	mov    %edx,%eax
  8029fe:	01 c0                	add    %eax,%eax
  802a00:	01 d0                	add    %edx,%eax
  802a02:	c1 e0 02             	shl    $0x2,%eax
  802a05:	05 44 20 81 00       	add    $0x812044,%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a0f:	76 1c                	jbe    802a2d <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802a11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a14:	89 d0                	mov    %edx,%eax
  802a16:	01 c0                	add    %eax,%eax
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	c1 e0 02             	shl    $0x2,%eax
  802a1d:	05 44 20 81 00       	add    $0x812044,%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802a2d:	ff 45 e8             	incl   -0x18(%ebp)
  802a30:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802a37:	0f 8e 6e ff ff ff    	jle    8029ab <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802a3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802a44:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802a48:	74 7d                	je     802ac7 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802a4a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a54:	89 d0                	mov    %edx,%eax
  802a56:	01 c0                	add    %eax,%eax
  802a58:	01 d0                	add    %edx,%eax
  802a5a:	c1 e0 02             	shl    $0x2,%eax
  802a5d:	05 40 20 81 00       	add    $0x812040,%eax
  802a62:	8b 10                	mov    (%eax),%edx
  802a64:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a67:	01 d0                	add    %edx,%eax
  802a69:	48                   	dec    %eax
  802a6a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a6d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a70:	ba 00 00 00 00       	mov    $0x0,%edx
  802a75:	f7 75 b8             	divl   -0x48(%ebp)
  802a78:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a7b:	29 d0                	sub    %edx,%eax
  802a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a83:	89 d0                	mov    %edx,%eax
  802a85:	01 c0                	add    %eax,%eax
  802a87:	01 d0                	add    %edx,%eax
  802a89:	c1 e0 02             	shl    $0x2,%eax
  802a8c:	05 48 20 81 00       	add    $0x812048,%eax
  802a91:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a97:	89 d0                	mov    %edx,%eax
  802a99:	01 c0                	add    %eax,%eax
  802a9b:	01 d0                	add    %edx,%eax
  802a9d:	c1 e0 02             	shl    $0x2,%eax
  802aa0:	05 44 20 81 00       	add    $0x812044,%eax
  802aa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802aab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aae:	89 d0                	mov    %edx,%eax
  802ab0:	01 c0                	add    %eax,%eax
  802ab2:	01 d0                	add    %edx,%eax
  802ab4:	c1 e0 02             	shl    $0x2,%eax
  802ab7:	05 40 20 81 00       	add    $0x812040,%eax
  802abc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac2:	e9 2d 01 00 00       	jmp    802bf4 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802ac7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802acb:	0f 84 ce 00 00 00    	je     802b9f <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802ad1:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adb:	89 d0                	mov    %edx,%eax
  802add:	01 c0                	add    %eax,%eax
  802adf:	01 d0                	add    %edx,%eax
  802ae1:	c1 e0 02             	shl    $0x2,%eax
  802ae4:	05 40 20 81 00       	add    $0x812040,%eax
  802ae9:	8b 10                	mov    (%eax),%edx
  802aeb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802aee:	01 d0                	add    %edx,%eax
  802af0:	48                   	dec    %eax
  802af1:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802af4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802af7:	ba 00 00 00 00       	mov    $0x0,%edx
  802afc:	f7 75 c0             	divl   -0x40(%ebp)
  802aff:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b02:	29 d0                	sub    %edx,%eax
  802b04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802b07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0a:	89 d0                	mov    %edx,%eax
  802b0c:	01 c0                	add    %eax,%eax
  802b0e:	01 d0                	add    %edx,%eax
  802b10:	c1 e0 02             	shl    $0x2,%eax
  802b13:	05 44 20 81 00       	add    $0x812044,%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802b1d:	75 47                	jne    802b66 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b22:	89 d0                	mov    %edx,%eax
  802b24:	01 c0                	add    %eax,%eax
  802b26:	01 d0                	add    %edx,%eax
  802b28:	c1 e0 02             	shl    $0x2,%eax
  802b2b:	05 48 20 81 00       	add    $0x812048,%eax
  802b30:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802b33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b36:	89 d0                	mov    %edx,%eax
  802b38:	01 c0                	add    %eax,%eax
  802b3a:	01 d0                	add    %edx,%eax
  802b3c:	c1 e0 02             	shl    $0x2,%eax
  802b3f:	05 44 20 81 00       	add    $0x812044,%eax
  802b44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4d:	89 d0                	mov    %edx,%eax
  802b4f:	01 c0                	add    %eax,%eax
  802b51:	01 d0                	add    %edx,%eax
  802b53:	c1 e0 02             	shl    $0x2,%eax
  802b56:	05 40 20 81 00       	add    $0x812040,%eax
  802b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b61:	e9 8e 00 00 00       	jmp    802bf4 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802b66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b69:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b6c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802b6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b72:	89 d0                	mov    %edx,%eax
  802b74:	01 c0                	add    %eax,%eax
  802b76:	01 d0                	add    %edx,%eax
  802b78:	c1 e0 02             	shl    $0x2,%eax
  802b7b:	05 40 20 81 00       	add    $0x812040,%eax
  802b80:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b85:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802b88:	89 c2                	mov    %eax,%edx
  802b8a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b8d:	89 c8                	mov    %ecx,%eax
  802b8f:	01 c0                	add    %eax,%eax
  802b91:	01 c8                	add    %ecx,%eax
  802b93:	c1 e0 02             	shl    $0x2,%eax
  802b96:	05 44 20 81 00       	add    $0x812044,%eax
  802b9b:	89 10                	mov    %edx,(%eax)
  802b9d:	eb 55                	jmp    802bf4 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802b9f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ba6:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802bac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802baf:	01 d0                	add    %edx,%eax
  802bb1:	48                   	dec    %eax
  802bb2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802bb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bbd:	f7 75 cc             	divl   -0x34(%ebp)
  802bc0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bc3:	29 d0                	sub    %edx,%eax
  802bc5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802bc8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802bcb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bce:	01 d0                	add    %edx,%eax
  802bd0:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802bd5:	76 0a                	jbe    802be1 <sget+0x2ac>
            return NULL;
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdc:	e9 ab 00 00 00       	jmp    802c8c <sget+0x357>
        va = start;
  802be1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802be4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802be7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802bea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bed:	01 d0                	add    %edx,%eax
  802bef:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802bf4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802bfb:	eb 5e                	jmp    802c5b <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802bfd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c00:	89 d0                	mov    %edx,%eax
  802c02:	01 c0                	add    %eax,%eax
  802c04:	01 d0                	add    %edx,%eax
  802c06:	c1 e0 02             	shl    $0x2,%eax
  802c09:	05 48 60 80 00       	add    $0x806048,%eax
  802c0e:	8a 00                	mov    (%eax),%al
  802c10:	84 c0                	test   %al,%al
  802c12:	75 44                	jne    802c58 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802c14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c17:	89 d0                	mov    %edx,%eax
  802c19:	01 c0                	add    %eax,%eax
  802c1b:	01 d0                	add    %edx,%eax
  802c1d:	c1 e0 02             	shl    $0x2,%eax
  802c20:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c29:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802c2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c2e:	89 d0                	mov    %edx,%eax
  802c30:	01 c0                	add    %eax,%eax
  802c32:	01 d0                	add    %edx,%eax
  802c34:	c1 e0 02             	shl    $0x2,%eax
  802c37:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802c3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c40:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802c42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c45:	89 d0                	mov    %edx,%eax
  802c47:	01 c0                	add    %eax,%eax
  802c49:	01 d0                	add    %edx,%eax
  802c4b:	c1 e0 02             	shl    $0x2,%eax
  802c4e:	05 48 60 80 00       	add    $0x806048,%eax
  802c53:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802c56:	eb 0c                	jmp    802c64 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c58:	ff 45 e0             	incl   -0x20(%ebp)
  802c5b:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802c62:	7e 99                	jle    802bfd <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	50                   	push   %eax
  802c6b:	ff 75 0c             	pushl  0xc(%ebp)
  802c6e:	ff 75 08             	pushl  0x8(%ebp)
  802c71:	e8 bf 0b 00 00       	call   803835 <sys_get_shared_object>
  802c76:	83 c4 10             	add    $0x10,%esp
  802c79:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802c7c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c80:	79 07                	jns    802c89 <sget+0x354>
        return NULL;
  802c82:	b8 00 00 00 00       	mov    $0x0,%eax
  802c87:	eb 03                	jmp    802c8c <sget+0x357>
    return (void*)va;
  802c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802c8c:	c9                   	leave  
  802c8d:	c3                   	ret    

00802c8e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802c8e:	55                   	push   %ebp
  802c8f:	89 e5                	mov    %esp,%ebp
  802c91:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802c94:	e8 f8 f0 ff ff       	call   801d91 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802c99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9d:	75 13                	jne    802cb2 <realloc+0x24>
		return malloc(new_size);
  802c9f:	83 ec 0c             	sub    $0xc,%esp
  802ca2:	ff 75 0c             	pushl  0xc(%ebp)
  802ca5:	e8 c4 f1 ff ff       	call   801e6e <malloc>
  802caa:	83 c4 10             	add    $0x10,%esp
  802cad:	e9 f4 05 00 00       	jmp    8032a6 <realloc+0x618>
	if (new_size == 0)
  802cb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cb6:	75 18                	jne    802cd0 <realloc+0x42>
	{
		free(virtual_address);
  802cb8:	83 ec 0c             	sub    $0xc,%esp
  802cbb:	ff 75 08             	pushl  0x8(%ebp)
  802cbe:	e8 0b f5 ff ff       	call   8021ce <free>
  802cc3:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccb:	e9 d6 05 00 00       	jmp    8032a6 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802cd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	79 74                	jns    802d51 <realloc+0xc3>
  802cdd:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802ce4:	77 6b                	ja     802d51 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802ce6:	83 ec 0c             	sub    $0xc,%esp
  802ce9:	ff 75 0c             	pushl  0xc(%ebp)
  802cec:	e8 7d f1 ff ff       	call   801e6e <malloc>
  802cf1:	83 c4 10             	add    $0x10,%esp
  802cf4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802cf7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802cfb:	75 0a                	jne    802d07 <realloc+0x79>
			return NULL;
  802cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802d02:	e9 9f 05 00 00       	jmp    8032a6 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802d07:	83 ec 0c             	sub    $0xc,%esp
  802d0a:	ff 75 08             	pushl  0x8(%ebp)
  802d0d:	e8 e0 11 00 00       	call   803ef2 <get_block_size>
  802d12:	83 c4 10             	add    $0x10,%esp
  802d15:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802d18:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1e:	39 d0                	cmp    %edx,%eax
  802d20:	76 02                	jbe    802d24 <realloc+0x96>
  802d22:	89 d0                	mov    %edx,%eax
  802d24:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802d27:	83 ec 04             	sub    $0x4,%esp
  802d2a:	ff 75 c0             	pushl  -0x40(%ebp)
  802d2d:	ff 75 08             	pushl  0x8(%ebp)
  802d30:	ff 75 c8             	pushl  -0x38(%ebp)
  802d33:	e8 56 eb ff ff       	call   80188e <memmove>
  802d38:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802d3b:	83 ec 0c             	sub    $0xc,%esp
  802d3e:	ff 75 08             	pushl  0x8(%ebp)
  802d41:	e8 88 f4 ff ff       	call   8021ce <free>
  802d46:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802d49:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d4c:	e9 55 05 00 00       	jmp    8032a6 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802d51:	a1 30 61 83 00       	mov    0x836130,%eax
  802d56:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802d59:	72 09                	jb     802d64 <realloc+0xd6>
  802d5b:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802d62:	76 0a                	jbe    802d6e <realloc+0xe0>
		return NULL;
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
  802d69:	e9 38 05 00 00       	jmp    8032a6 <realloc+0x618>
	uint32 oldsz = 0;
  802d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802d75:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d7c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802d83:	eb 50                	jmp    802dd5 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802d85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d88:	89 d0                	mov    %edx,%eax
  802d8a:	01 c0                	add    %eax,%eax
  802d8c:	01 d0                	add    %edx,%eax
  802d8e:	c1 e0 02             	shl    $0x2,%eax
  802d91:	05 48 60 80 00       	add    $0x806048,%eax
  802d96:	8a 00                	mov    (%eax),%al
  802d98:	84 c0                	test   %al,%al
  802d9a:	74 36                	je     802dd2 <realloc+0x144>
  802d9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d9f:	89 d0                	mov    %edx,%eax
  802da1:	01 c0                	add    %eax,%eax
  802da3:	01 d0                	add    %edx,%eax
  802da5:	c1 e0 02             	shl    $0x2,%eax
  802da8:	05 40 60 80 00       	add    $0x806040,%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802db2:	75 1e                	jne    802dd2 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802db4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802db7:	89 d0                	mov    %edx,%eax
  802db9:	01 c0                	add    %eax,%eax
  802dbb:	01 d0                	add    %edx,%eax
  802dbd:	c1 e0 02             	shl    $0x2,%eax
  802dc0:	05 44 60 80 00       	add    $0x806044,%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802dd0:	eb 0c                	jmp    802dde <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802dd2:	ff 45 ec             	incl   -0x14(%ebp)
  802dd5:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ddc:	7e a7                	jle    802d85 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802dde:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802de2:	75 0a                	jne    802dee <realloc+0x160>
		return NULL;
  802de4:	b8 00 00 00 00       	mov    $0x0,%eax
  802de9:	e9 b8 04 00 00       	jmp    8032a6 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802dee:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dfb:	01 d0                	add    %edx,%eax
  802dfd:	48                   	dec    %eax
  802dfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802e01:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e04:	ba 00 00 00 00       	mov    $0x0,%edx
  802e09:	f7 75 bc             	divl   -0x44(%ebp)
  802e0c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e0f:	29 d0                	sub    %edx,%eax
  802e11:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802e14:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e17:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e1a:	75 08                	jne    802e24 <realloc+0x196>
		return virtual_address;
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	e9 82 04 00 00       	jmp    8032a6 <realloc+0x618>
	if (req < oldsz)
  802e24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e2a:	0f 83 cd 02 00 00    	jae    8030fd <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802e36:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802e39:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e3c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e3f:	01 d0                	add    %edx,%eax
  802e41:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802e44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e47:	89 d0                	mov    %edx,%eax
  802e49:	01 c0                	add    %eax,%eax
  802e4b:	01 d0                	add    %edx,%eax
  802e4d:	c1 e0 02             	shl    $0x2,%eax
  802e50:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802e56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e59:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802e5b:	83 ec 08             	sub    $0x8,%esp
  802e5e:	ff 75 b0             	pushl  -0x50(%ebp)
  802e61:	ff 75 ac             	pushl  -0x54(%ebp)
  802e64:	e8 e3 0c 00 00       	call   803b4c <sys_free_user_mem>
  802e69:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802e6c:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802e7a:	eb 64                	jmp    802ee0 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802e7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e7f:	89 d0                	mov    %edx,%eax
  802e81:	01 c0                	add    %eax,%eax
  802e83:	01 d0                	add    %edx,%eax
  802e85:	c1 e0 02             	shl    $0x2,%eax
  802e88:	05 48 20 81 00       	add    $0x812048,%eax
  802e8d:	8a 00                	mov    (%eax),%al
  802e8f:	84 c0                	test   %al,%al
  802e91:	75 4a                	jne    802edd <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802e93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e96:	89 d0                	mov    %edx,%eax
  802e98:	01 c0                	add    %eax,%eax
  802e9a:	01 d0                	add    %edx,%eax
  802e9c:	c1 e0 02             	shl    $0x2,%eax
  802e9f:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802ea5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ea8:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802eaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ead:	89 d0                	mov    %edx,%eax
  802eaf:	01 c0                	add    %eax,%eax
  802eb1:	01 d0                	add    %edx,%eax
  802eb3:	c1 e0 02             	shl    $0x2,%eax
  802eb6:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802ebc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ebf:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802ec1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ec4:	89 d0                	mov    %edx,%eax
  802ec6:	01 c0                	add    %eax,%eax
  802ec8:	01 d0                	add    %edx,%eax
  802eca:	c1 e0 02             	shl    $0x2,%eax
  802ecd:	05 48 20 81 00       	add    $0x812048,%eax
  802ed2:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802ed5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed8:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802edb:	eb 0c                	jmp    802ee9 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802edd:	ff 45 e4             	incl   -0x1c(%ebp)
  802ee0:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802ee7:	7e 93                	jle    802e7c <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802ee9:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802eed:	0f 84 8d 01 00 00    	je     803080 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ef3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802efa:	e9 74 01 00 00       	jmp    803073 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f02:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f05:	0f 84 64 01 00 00    	je     80306f <realloc+0x3e1>
				if (uhp_frees[k].free)
  802f0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f0e:	89 d0                	mov    %edx,%eax
  802f10:	01 c0                	add    %eax,%eax
  802f12:	01 d0                	add    %edx,%eax
  802f14:	c1 e0 02             	shl    $0x2,%eax
  802f17:	05 48 20 81 00       	add    $0x812048,%eax
  802f1c:	8a 00                	mov    (%eax),%al
  802f1e:	84 c0                	test   %al,%al
  802f20:	0f 84 4a 01 00 00    	je     803070 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802f26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f29:	89 d0                	mov    %edx,%eax
  802f2b:	01 c0                	add    %eax,%eax
  802f2d:	01 d0                	add    %edx,%eax
  802f2f:	c1 e0 02             	shl    $0x2,%eax
  802f32:	05 40 20 81 00       	add    $0x812040,%eax
  802f37:	8b 08                	mov    (%eax),%ecx
  802f39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f3c:	89 d0                	mov    %edx,%eax
  802f3e:	01 c0                	add    %eax,%eax
  802f40:	01 d0                	add    %edx,%eax
  802f42:	c1 e0 02             	shl    $0x2,%eax
  802f45:	05 44 20 81 00       	add    $0x812044,%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	01 c1                	add    %eax,%ecx
  802f4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f51:	89 d0                	mov    %edx,%eax
  802f53:	01 c0                	add    %eax,%eax
  802f55:	01 d0                	add    %edx,%eax
  802f57:	c1 e0 02             	shl    $0x2,%eax
  802f5a:	05 40 20 81 00       	add    $0x812040,%eax
  802f5f:	8b 00                	mov    (%eax),%eax
  802f61:	39 c1                	cmp    %eax,%ecx
  802f63:	75 7a                	jne    802fdf <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802f65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f68:	89 d0                	mov    %edx,%eax
  802f6a:	01 c0                	add    %eax,%eax
  802f6c:	01 d0                	add    %edx,%eax
  802f6e:	c1 e0 02             	shl    $0x2,%eax
  802f71:	05 40 20 81 00       	add    $0x812040,%eax
  802f76:	8b 10                	mov    (%eax),%edx
  802f78:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802f7b:	89 c8                	mov    %ecx,%eax
  802f7d:	01 c0                	add    %eax,%eax
  802f7f:	01 c8                	add    %ecx,%eax
  802f81:	c1 e0 02             	shl    $0x2,%eax
  802f84:	05 40 20 81 00       	add    $0x812040,%eax
  802f89:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802f8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8e:	89 d0                	mov    %edx,%eax
  802f90:	01 c0                	add    %eax,%eax
  802f92:	01 d0                	add    %edx,%eax
  802f94:	c1 e0 02             	shl    $0x2,%eax
  802f97:	05 44 20 81 00       	add    $0x812044,%eax
  802f9c:	8b 08                	mov    (%eax),%ecx
  802f9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa1:	89 d0                	mov    %edx,%eax
  802fa3:	01 c0                	add    %eax,%eax
  802fa5:	01 d0                	add    %edx,%eax
  802fa7:	c1 e0 02             	shl    $0x2,%eax
  802faa:	05 44 20 81 00       	add    $0x812044,%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	01 c1                	add    %eax,%ecx
  802fb3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb6:	89 d0                	mov    %edx,%eax
  802fb8:	01 c0                	add    %eax,%eax
  802fba:	01 d0                	add    %edx,%eax
  802fbc:	c1 e0 02             	shl    $0x2,%eax
  802fbf:	05 44 20 81 00       	add    $0x812044,%eax
  802fc4:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802fc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fc9:	89 d0                	mov    %edx,%eax
  802fcb:	01 c0                	add    %eax,%eax
  802fcd:	01 d0                	add    %edx,%eax
  802fcf:	c1 e0 02             	shl    $0x2,%eax
  802fd2:	05 48 20 81 00       	add    $0x812048,%eax
  802fd7:	c6 00 00             	movb   $0x0,(%eax)
  802fda:	e9 91 00 00 00       	jmp    803070 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802fdf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe2:	89 d0                	mov    %edx,%eax
  802fe4:	01 c0                	add    %eax,%eax
  802fe6:	01 d0                	add    %edx,%eax
  802fe8:	c1 e0 02             	shl    $0x2,%eax
  802feb:	05 40 20 81 00       	add    $0x812040,%eax
  802ff0:	8b 08                	mov    (%eax),%ecx
  802ff2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff5:	89 d0                	mov    %edx,%eax
  802ff7:	01 c0                	add    %eax,%eax
  802ff9:	01 d0                	add    %edx,%eax
  802ffb:	c1 e0 02             	shl    $0x2,%eax
  802ffe:	05 44 20 81 00       	add    $0x812044,%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	01 c1                	add    %eax,%ecx
  803007:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80300a:	89 d0                	mov    %edx,%eax
  80300c:	01 c0                	add    %eax,%eax
  80300e:	01 d0                	add    %edx,%eax
  803010:	c1 e0 02             	shl    $0x2,%eax
  803013:	05 40 20 81 00       	add    $0x812040,%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	39 c1                	cmp    %eax,%ecx
  80301c:	75 52                	jne    803070 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  80301e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803021:	89 d0                	mov    %edx,%eax
  803023:	01 c0                	add    %eax,%eax
  803025:	01 d0                	add    %edx,%eax
  803027:	c1 e0 02             	shl    $0x2,%eax
  80302a:	05 44 20 81 00       	add    $0x812044,%eax
  80302f:	8b 08                	mov    (%eax),%ecx
  803031:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803034:	89 d0                	mov    %edx,%eax
  803036:	01 c0                	add    %eax,%eax
  803038:	01 d0                	add    %edx,%eax
  80303a:	c1 e0 02             	shl    $0x2,%eax
  80303d:	05 44 20 81 00       	add    $0x812044,%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	01 c1                	add    %eax,%ecx
  803046:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803049:	89 d0                	mov    %edx,%eax
  80304b:	01 c0                	add    %eax,%eax
  80304d:	01 d0                	add    %edx,%eax
  80304f:	c1 e0 02             	shl    $0x2,%eax
  803052:	05 44 20 81 00       	add    $0x812044,%eax
  803057:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  803059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80305c:	89 d0                	mov    %edx,%eax
  80305e:	01 c0                	add    %eax,%eax
  803060:	01 d0                	add    %edx,%eax
  803062:	c1 e0 02             	shl    $0x2,%eax
  803065:	05 48 20 81 00       	add    $0x812048,%eax
  80306a:	c6 00 00             	movb   $0x0,(%eax)
  80306d:	eb 01                	jmp    803070 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  80306f:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803070:	ff 45 e0             	incl   -0x20(%ebp)
  803073:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80307a:	0f 8e 7f fe ff ff    	jle    802eff <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  803080:	a1 30 61 83 00       	mov    0x836130,%eax
  803085:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803088:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80308f:	eb 53                	jmp    8030e4 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  803091:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803094:	89 d0                	mov    %edx,%eax
  803096:	01 c0                	add    %eax,%eax
  803098:	01 d0                	add    %edx,%eax
  80309a:	c1 e0 02             	shl    $0x2,%eax
  80309d:	05 48 60 80 00       	add    $0x806048,%eax
  8030a2:	8a 00                	mov    (%eax),%al
  8030a4:	84 c0                	test   %al,%al
  8030a6:	74 39                	je     8030e1 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8030a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030ab:	89 d0                	mov    %edx,%eax
  8030ad:	01 c0                	add    %eax,%eax
  8030af:	01 d0                	add    %edx,%eax
  8030b1:	c1 e0 02             	shl    $0x2,%eax
  8030b4:	05 40 60 80 00       	add    $0x806040,%eax
  8030b9:	8b 08                	mov    (%eax),%ecx
  8030bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030be:	89 d0                	mov    %edx,%eax
  8030c0:	01 c0                	add    %eax,%eax
  8030c2:	01 d0                	add    %edx,%eax
  8030c4:	c1 e0 02             	shl    $0x2,%eax
  8030c7:	05 44 60 80 00       	add    $0x806044,%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	01 c8                	add    %ecx,%eax
  8030d0:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8030d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8030d9:	76 06                	jbe    8030e1 <realloc+0x453>
  8030db:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030de:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8030e1:	ff 45 d8             	incl   -0x28(%ebp)
  8030e4:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8030eb:	7e a4                	jle    803091 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8030ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f0:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	e9 a9 01 00 00       	jmp    8032a6 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8030fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	01 d0                	add    %edx,%eax
  803105:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  803108:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80310f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  803116:	eb 57                	jmp    80316f <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  803118:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80311b:	89 d0                	mov    %edx,%eax
  80311d:	01 c0                	add    %eax,%eax
  80311f:	01 d0                	add    %edx,%eax
  803121:	c1 e0 02             	shl    $0x2,%eax
  803124:	05 48 20 81 00       	add    $0x812048,%eax
  803129:	8a 00                	mov    (%eax),%al
  80312b:	84 c0                	test   %al,%al
  80312d:	74 3d                	je     80316c <realloc+0x4de>
  80312f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803132:	89 d0                	mov    %edx,%eax
  803134:	01 c0                	add    %eax,%eax
  803136:	01 d0                	add    %edx,%eax
  803138:	c1 e0 02             	shl    $0x2,%eax
  80313b:	05 40 20 81 00       	add    $0x812040,%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803145:	75 25                	jne    80316c <realloc+0x4de>
  803147:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80314a:	89 d0                	mov    %edx,%eax
  80314c:	01 c0                	add    %eax,%eax
  80314e:	01 d0                	add    %edx,%eax
  803150:	c1 e0 02             	shl    $0x2,%eax
  803153:	05 44 20 81 00       	add    $0x812044,%eax
  803158:	8b 10                	mov    (%eax),%edx
  80315a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80315d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803160:	39 c2                	cmp    %eax,%edx
  803162:	72 08                	jb     80316c <realloc+0x4de>
		{
			adjIdx = j; break;
  803164:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803167:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80316a:	eb 0c                	jmp    803178 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80316c:	ff 45 d0             	incl   -0x30(%ebp)
  80316f:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  803176:	7e a0                	jle    803118 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  803178:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  80317c:	0f 84 d6 00 00 00    	je     803258 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  803182:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803185:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803188:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  80318b:	83 ec 08             	sub    $0x8,%esp
  80318e:	ff 75 a0             	pushl  -0x60(%ebp)
  803191:	ff 75 a4             	pushl  -0x5c(%ebp)
  803194:	e8 cf 09 00 00       	call   803b68 <sys_allocate_user_mem>
  803199:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  80319c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80319f:	89 d0                	mov    %edx,%eax
  8031a1:	01 c0                	add    %eax,%eax
  8031a3:	01 d0                	add    %edx,%eax
  8031a5:	c1 e0 02             	shl    $0x2,%eax
  8031a8:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8031ae:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031b1:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8031b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031b6:	89 d0                	mov    %edx,%eax
  8031b8:	01 c0                	add    %eax,%eax
  8031ba:	01 d0                	add    %edx,%eax
  8031bc:	c1 e0 02             	shl    $0x2,%eax
  8031bf:	05 40 20 81 00       	add    $0x812040,%eax
  8031c4:	8b 10                	mov    (%eax),%edx
  8031c6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8031c9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8031cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031cf:	89 d0                	mov    %edx,%eax
  8031d1:	01 c0                	add    %eax,%eax
  8031d3:	01 d0                	add    %edx,%eax
  8031d5:	c1 e0 02             	shl    $0x2,%eax
  8031d8:	05 40 20 81 00       	add    $0x812040,%eax
  8031dd:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8031df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031e2:	89 d0                	mov    %edx,%eax
  8031e4:	01 c0                	add    %eax,%eax
  8031e6:	01 d0                	add    %edx,%eax
  8031e8:	c1 e0 02             	shl    $0x2,%eax
  8031eb:	05 44 20 81 00       	add    $0x812044,%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	2b 45 a0             	sub    -0x60(%ebp),%eax
  8031f5:	89 c2                	mov    %eax,%edx
  8031f7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8031fa:	89 c8                	mov    %ecx,%eax
  8031fc:	01 c0                	add    %eax,%eax
  8031fe:	01 c8                	add    %ecx,%eax
  803200:	c1 e0 02             	shl    $0x2,%eax
  803203:	05 44 20 81 00       	add    $0x812044,%eax
  803208:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  80320a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80320d:	89 d0                	mov    %edx,%eax
  80320f:	01 c0                	add    %eax,%eax
  803211:	01 d0                	add    %edx,%eax
  803213:	c1 e0 02             	shl    $0x2,%eax
  803216:	05 44 20 81 00       	add    $0x812044,%eax
  80321b:	8b 00                	mov    (%eax),%eax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	75 14                	jne    803235 <realloc+0x5a7>
  803221:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803224:	89 d0                	mov    %edx,%eax
  803226:	01 c0                	add    %eax,%eax
  803228:	01 d0                	add    %edx,%eax
  80322a:	c1 e0 02             	shl    $0x2,%eax
  80322d:	05 48 20 81 00       	add    $0x812048,%eax
  803232:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  803235:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803238:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80323b:	01 c2                	add    %eax,%edx
  80323d:	a1 88 60 83 00       	mov    0x836088,%eax
  803242:	39 c2                	cmp    %eax,%edx
  803244:	76 0d                	jbe    803253 <realloc+0x5c5>
  803246:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803249:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80324c:	01 d0                	add    %edx,%eax
  80324e:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	eb 4e                	jmp    8032a6 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  803258:	83 ec 0c             	sub    $0xc,%esp
  80325b:	ff 75 0c             	pushl  0xc(%ebp)
  80325e:	e8 0b ec ff ff       	call   801e6e <malloc>
  803263:	83 c4 10             	add    $0x10,%esp
  803266:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  803269:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80326d:	75 07                	jne    803276 <realloc+0x5e8>
		return NULL;
  80326f:	b8 00 00 00 00       	mov    $0x0,%eax
  803274:	eb 30                	jmp    8032a6 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  803276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803279:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80327c:	39 d0                	cmp    %edx,%eax
  80327e:	76 02                	jbe    803282 <realloc+0x5f4>
  803280:	89 d0                	mov    %edx,%eax
  803282:	8b 55 9c             	mov    -0x64(%ebp),%edx
  803285:	83 ec 04             	sub    $0x4,%esp
  803288:	50                   	push   %eax
  803289:	52                   	push   %edx
  80328a:	ff 75 cc             	pushl  -0x34(%ebp)
  80328d:	e8 cf 06 00 00       	call   803961 <sys_move_user_mem>
  803292:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  803295:	83 ec 0c             	sub    $0xc,%esp
  803298:	ff 75 08             	pushl  0x8(%ebp)
  80329b:	e8 2e ef ff ff       	call   8021ce <free>
  8032a0:	83 c4 10             	add    $0x10,%esp
	return newptr;
  8032a3:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  8032a6:	c9                   	leave  
  8032a7:	c3                   	ret    

008032a8 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8032a8:	55                   	push   %ebp
  8032a9:	89 e5                	mov    %esp,%ebp
  8032ab:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8032b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032b8:	0f 84 33 03 00 00    	je     8035f1 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8032be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c1:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8032c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8032c9:	83 ec 08             	sub    $0x8,%esp
  8032cc:	ff 75 08             	pushl  0x8(%ebp)
  8032cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8032d2:	e8 7d 05 00 00       	call   803854 <sys_delete_shared_object>
  8032d7:	83 c4 10             	add    $0x10,%esp
  8032da:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8032dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032e1:	0f 88 0d 03 00 00    	js     8035f4 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8032e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032ee:	e9 ef 02 00 00       	jmp    8035e2 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8032f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f6:	89 d0                	mov    %edx,%eax
  8032f8:	01 c0                	add    %eax,%eax
  8032fa:	01 d0                	add    %edx,%eax
  8032fc:	c1 e0 02             	shl    $0x2,%eax
  8032ff:	05 48 60 80 00       	add    $0x806048,%eax
  803304:	8a 00                	mov    (%eax),%al
  803306:	84 c0                	test   %al,%al
  803308:	0f 84 d1 02 00 00    	je     8035df <sfree+0x337>
  80330e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803311:	89 d0                	mov    %edx,%eax
  803313:	01 c0                	add    %eax,%eax
  803315:	01 d0                	add    %edx,%eax
  803317:	c1 e0 02             	shl    $0x2,%eax
  80331a:	05 40 60 80 00       	add    $0x806040,%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803324:	0f 85 b5 02 00 00    	jne    8035df <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  80332a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80332d:	89 d0                	mov    %edx,%eax
  80332f:	01 c0                	add    %eax,%eax
  803331:	01 d0                	add    %edx,%eax
  803333:	c1 e0 02             	shl    $0x2,%eax
  803336:	05 44 60 80 00       	add    $0x806044,%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803340:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803343:	89 d0                	mov    %edx,%eax
  803345:	01 c0                	add    %eax,%eax
  803347:	01 d0                	add    %edx,%eax
  803349:	c1 e0 02             	shl    $0x2,%eax
  80334c:	05 48 60 80 00       	add    $0x806048,%eax
  803351:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  803354:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80335b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803362:	eb 64                	jmp    8033c8 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  803364:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803367:	89 d0                	mov    %edx,%eax
  803369:	01 c0                	add    %eax,%eax
  80336b:	01 d0                	add    %edx,%eax
  80336d:	c1 e0 02             	shl    $0x2,%eax
  803370:	05 48 20 81 00       	add    $0x812048,%eax
  803375:	8a 00                	mov    (%eax),%al
  803377:	84 c0                	test   %al,%al
  803379:	75 4a                	jne    8033c5 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  80337b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80337e:	89 d0                	mov    %edx,%eax
  803380:	01 c0                	add    %eax,%eax
  803382:	01 d0                	add    %edx,%eax
  803384:	c1 e0 02             	shl    $0x2,%eax
  803387:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  80338d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803390:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  803392:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803395:	89 d0                	mov    %edx,%eax
  803397:	01 c0                	add    %eax,%eax
  803399:	01 d0                	add    %edx,%eax
  80339b:	c1 e0 02             	shl    $0x2,%eax
  80339e:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  8033a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033a7:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  8033a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033ac:	89 d0                	mov    %edx,%eax
  8033ae:	01 c0                	add    %eax,%eax
  8033b0:	01 d0                	add    %edx,%eax
  8033b2:	c1 e0 02             	shl    $0x2,%eax
  8033b5:	05 48 20 81 00       	add    $0x812048,%eax
  8033ba:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  8033bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  8033c3:	eb 0c                	jmp    8033d1 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8033c5:	ff 45 ec             	incl   -0x14(%ebp)
  8033c8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8033cf:	7e 93                	jle    803364 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  8033d1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8033d5:	0f 84 8d 01 00 00    	je     803568 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8033db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8033e2:	e9 74 01 00 00       	jmp    80355b <sfree+0x2b3>
				{
					if (k == fidx) continue;
  8033e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033ed:	0f 84 64 01 00 00    	je     803557 <sfree+0x2af>
					if (uhp_frees[k].free)
  8033f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f6:	89 d0                	mov    %edx,%eax
  8033f8:	01 c0                	add    %eax,%eax
  8033fa:	01 d0                	add    %edx,%eax
  8033fc:	c1 e0 02             	shl    $0x2,%eax
  8033ff:	05 48 20 81 00       	add    $0x812048,%eax
  803404:	8a 00                	mov    (%eax),%al
  803406:	84 c0                	test   %al,%al
  803408:	0f 84 4a 01 00 00    	je     803558 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80340e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803411:	89 d0                	mov    %edx,%eax
  803413:	01 c0                	add    %eax,%eax
  803415:	01 d0                	add    %edx,%eax
  803417:	c1 e0 02             	shl    $0x2,%eax
  80341a:	05 40 20 81 00       	add    $0x812040,%eax
  80341f:	8b 08                	mov    (%eax),%ecx
  803421:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803424:	89 d0                	mov    %edx,%eax
  803426:	01 c0                	add    %eax,%eax
  803428:	01 d0                	add    %edx,%eax
  80342a:	c1 e0 02             	shl    $0x2,%eax
  80342d:	05 44 20 81 00       	add    $0x812044,%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	01 c1                	add    %eax,%ecx
  803436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803439:	89 d0                	mov    %edx,%eax
  80343b:	01 c0                	add    %eax,%eax
  80343d:	01 d0                	add    %edx,%eax
  80343f:	c1 e0 02             	shl    $0x2,%eax
  803442:	05 40 20 81 00       	add    $0x812040,%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	39 c1                	cmp    %eax,%ecx
  80344b:	75 7a                	jne    8034c7 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  80344d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803450:	89 d0                	mov    %edx,%eax
  803452:	01 c0                	add    %eax,%eax
  803454:	01 d0                	add    %edx,%eax
  803456:	c1 e0 02             	shl    $0x2,%eax
  803459:	05 40 20 81 00       	add    $0x812040,%eax
  80345e:	8b 10                	mov    (%eax),%edx
  803460:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803463:	89 c8                	mov    %ecx,%eax
  803465:	01 c0                	add    %eax,%eax
  803467:	01 c8                	add    %ecx,%eax
  803469:	c1 e0 02             	shl    $0x2,%eax
  80346c:	05 40 20 81 00       	add    $0x812040,%eax
  803471:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  803473:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803476:	89 d0                	mov    %edx,%eax
  803478:	01 c0                	add    %eax,%eax
  80347a:	01 d0                	add    %edx,%eax
  80347c:	c1 e0 02             	shl    $0x2,%eax
  80347f:	05 44 20 81 00       	add    $0x812044,%eax
  803484:	8b 08                	mov    (%eax),%ecx
  803486:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803489:	89 d0                	mov    %edx,%eax
  80348b:	01 c0                	add    %eax,%eax
  80348d:	01 d0                	add    %edx,%eax
  80348f:	c1 e0 02             	shl    $0x2,%eax
  803492:	05 44 20 81 00       	add    $0x812044,%eax
  803497:	8b 00                	mov    (%eax),%eax
  803499:	01 c1                	add    %eax,%ecx
  80349b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80349e:	89 d0                	mov    %edx,%eax
  8034a0:	01 c0                	add    %eax,%eax
  8034a2:	01 d0                	add    %edx,%eax
  8034a4:	c1 e0 02             	shl    $0x2,%eax
  8034a7:	05 44 20 81 00       	add    $0x812044,%eax
  8034ac:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8034ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b1:	89 d0                	mov    %edx,%eax
  8034b3:	01 c0                	add    %eax,%eax
  8034b5:	01 d0                	add    %edx,%eax
  8034b7:	c1 e0 02             	shl    $0x2,%eax
  8034ba:	05 48 20 81 00       	add    $0x812048,%eax
  8034bf:	c6 00 00             	movb   $0x0,(%eax)
  8034c2:	e9 91 00 00 00       	jmp    803558 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8034c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ca:	89 d0                	mov    %edx,%eax
  8034cc:	01 c0                	add    %eax,%eax
  8034ce:	01 d0                	add    %edx,%eax
  8034d0:	c1 e0 02             	shl    $0x2,%eax
  8034d3:	05 40 20 81 00       	add    $0x812040,%eax
  8034d8:	8b 08                	mov    (%eax),%ecx
  8034da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034dd:	89 d0                	mov    %edx,%eax
  8034df:	01 c0                	add    %eax,%eax
  8034e1:	01 d0                	add    %edx,%eax
  8034e3:	c1 e0 02             	shl    $0x2,%eax
  8034e6:	05 44 20 81 00       	add    $0x812044,%eax
  8034eb:	8b 00                	mov    (%eax),%eax
  8034ed:	01 c1                	add    %eax,%ecx
  8034ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f2:	89 d0                	mov    %edx,%eax
  8034f4:	01 c0                	add    %eax,%eax
  8034f6:	01 d0                	add    %edx,%eax
  8034f8:	c1 e0 02             	shl    $0x2,%eax
  8034fb:	05 40 20 81 00       	add    $0x812040,%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	39 c1                	cmp    %eax,%ecx
  803504:	75 52                	jne    803558 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803506:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803509:	89 d0                	mov    %edx,%eax
  80350b:	01 c0                	add    %eax,%eax
  80350d:	01 d0                	add    %edx,%eax
  80350f:	c1 e0 02             	shl    $0x2,%eax
  803512:	05 44 20 81 00       	add    $0x812044,%eax
  803517:	8b 08                	mov    (%eax),%ecx
  803519:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80351c:	89 d0                	mov    %edx,%eax
  80351e:	01 c0                	add    %eax,%eax
  803520:	01 d0                	add    %edx,%eax
  803522:	c1 e0 02             	shl    $0x2,%eax
  803525:	05 44 20 81 00       	add    $0x812044,%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	01 c1                	add    %eax,%ecx
  80352e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803531:	89 d0                	mov    %edx,%eax
  803533:	01 c0                	add    %eax,%eax
  803535:	01 d0                	add    %edx,%eax
  803537:	c1 e0 02             	shl    $0x2,%eax
  80353a:	05 44 20 81 00       	add    $0x812044,%eax
  80353f:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803541:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803544:	89 d0                	mov    %edx,%eax
  803546:	01 c0                	add    %eax,%eax
  803548:	01 d0                	add    %edx,%eax
  80354a:	c1 e0 02             	shl    $0x2,%eax
  80354d:	05 48 20 81 00       	add    $0x812048,%eax
  803552:	c6 00 00             	movb   $0x0,(%eax)
  803555:	eb 01                	jmp    803558 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  803557:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803558:	ff 45 e8             	incl   -0x18(%ebp)
  80355b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803562:	0f 8e 7f fe ff ff    	jle    8033e7 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803568:	a1 30 61 83 00       	mov    0x836130,%eax
  80356d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803570:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803577:	eb 53                	jmp    8035cc <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803579:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80357c:	89 d0                	mov    %edx,%eax
  80357e:	01 c0                	add    %eax,%eax
  803580:	01 d0                	add    %edx,%eax
  803582:	c1 e0 02             	shl    $0x2,%eax
  803585:	05 48 60 80 00       	add    $0x806048,%eax
  80358a:	8a 00                	mov    (%eax),%al
  80358c:	84 c0                	test   %al,%al
  80358e:	74 39                	je     8035c9 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803590:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803593:	89 d0                	mov    %edx,%eax
  803595:	01 c0                	add    %eax,%eax
  803597:	01 d0                	add    %edx,%eax
  803599:	c1 e0 02             	shl    $0x2,%eax
  80359c:	05 40 60 80 00       	add    $0x806040,%eax
  8035a1:	8b 08                	mov    (%eax),%ecx
  8035a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035a6:	89 d0                	mov    %edx,%eax
  8035a8:	01 c0                	add    %eax,%eax
  8035aa:	01 d0                	add    %edx,%eax
  8035ac:	c1 e0 02             	shl    $0x2,%eax
  8035af:	05 44 60 80 00       	add    $0x806044,%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	01 c8                	add    %ecx,%eax
  8035b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  8035bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035be:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035c1:	76 06                	jbe    8035c9 <sfree+0x321>
  8035c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8035c9:	ff 45 e0             	incl   -0x20(%ebp)
  8035cc:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8035d3:	7e a4                	jle    803579 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  8035d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d8:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  8035dd:	eb 16                	jmp    8035f5 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8035df:	ff 45 f4             	incl   -0xc(%ebp)
  8035e2:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  8035e9:	0f 8e 04 fd ff ff    	jle    8032f3 <sfree+0x4b>
  8035ef:	eb 04                	jmp    8035f5 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  8035f1:	90                   	nop
  8035f2:	eb 01                	jmp    8035f5 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  8035f4:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  8035f5:	c9                   	leave  
  8035f6:	c3                   	ret    

008035f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8035f7:	55                   	push   %ebp
  8035f8:	89 e5                	mov    %esp,%ebp
  8035fa:	57                   	push   %edi
  8035fb:	56                   	push   %esi
  8035fc:	53                   	push   %ebx
  8035fd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	8b 55 0c             	mov    0xc(%ebp),%edx
  803606:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803609:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80360c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80360f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803612:	cd 30                	int    $0x30
  803614:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803617:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80361a:	83 c4 10             	add    $0x10,%esp
  80361d:	5b                   	pop    %ebx
  80361e:	5e                   	pop    %esi
  80361f:	5f                   	pop    %edi
  803620:	5d                   	pop    %ebp
  803621:	c3                   	ret    

00803622 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803622:	55                   	push   %ebp
  803623:	89 e5                	mov    %esp,%ebp
  803625:	83 ec 04             	sub    $0x4,%esp
  803628:	8b 45 10             	mov    0x10(%ebp),%eax
  80362b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80362e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803631:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	6a 00                	push   $0x0
  80363a:	51                   	push   %ecx
  80363b:	52                   	push   %edx
  80363c:	ff 75 0c             	pushl  0xc(%ebp)
  80363f:	50                   	push   %eax
  803640:	6a 00                	push   $0x0
  803642:	e8 b0 ff ff ff       	call   8035f7 <syscall>
  803647:	83 c4 18             	add    $0x18,%esp
}
  80364a:	90                   	nop
  80364b:	c9                   	leave  
  80364c:	c3                   	ret    

0080364d <sys_cgetc>:

int
sys_cgetc(void)
{
  80364d:	55                   	push   %ebp
  80364e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803650:	6a 00                	push   $0x0
  803652:	6a 00                	push   $0x0
  803654:	6a 00                	push   $0x0
  803656:	6a 00                	push   $0x0
  803658:	6a 00                	push   $0x0
  80365a:	6a 02                	push   $0x2
  80365c:	e8 96 ff ff ff       	call   8035f7 <syscall>
  803661:	83 c4 18             	add    $0x18,%esp
}
  803664:	c9                   	leave  
  803665:	c3                   	ret    

00803666 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803666:	55                   	push   %ebp
  803667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803669:	6a 00                	push   $0x0
  80366b:	6a 00                	push   $0x0
  80366d:	6a 00                	push   $0x0
  80366f:	6a 00                	push   $0x0
  803671:	6a 00                	push   $0x0
  803673:	6a 03                	push   $0x3
  803675:	e8 7d ff ff ff       	call   8035f7 <syscall>
  80367a:	83 c4 18             	add    $0x18,%esp
}
  80367d:	90                   	nop
  80367e:	c9                   	leave  
  80367f:	c3                   	ret    

00803680 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803680:	55                   	push   %ebp
  803681:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803683:	6a 00                	push   $0x0
  803685:	6a 00                	push   $0x0
  803687:	6a 00                	push   $0x0
  803689:	6a 00                	push   $0x0
  80368b:	6a 00                	push   $0x0
  80368d:	6a 04                	push   $0x4
  80368f:	e8 63 ff ff ff       	call   8035f7 <syscall>
  803694:	83 c4 18             	add    $0x18,%esp
}
  803697:	90                   	nop
  803698:	c9                   	leave  
  803699:	c3                   	ret    

0080369a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80369a:	55                   	push   %ebp
  80369b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80369d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	6a 00                	push   $0x0
  8036a5:	6a 00                	push   $0x0
  8036a7:	6a 00                	push   $0x0
  8036a9:	52                   	push   %edx
  8036aa:	50                   	push   %eax
  8036ab:	6a 08                	push   $0x8
  8036ad:	e8 45 ff ff ff       	call   8035f7 <syscall>
  8036b2:	83 c4 18             	add    $0x18,%esp
}
  8036b5:	c9                   	leave  
  8036b6:	c3                   	ret    

008036b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8036b7:	55                   	push   %ebp
  8036b8:	89 e5                	mov    %esp,%ebp
  8036ba:	56                   	push   %esi
  8036bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8036bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8036bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8036c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	56                   	push   %esi
  8036cc:	53                   	push   %ebx
  8036cd:	51                   	push   %ecx
  8036ce:	52                   	push   %edx
  8036cf:	50                   	push   %eax
  8036d0:	6a 09                	push   $0x9
  8036d2:	e8 20 ff ff ff       	call   8035f7 <syscall>
  8036d7:	83 c4 18             	add    $0x18,%esp
}
  8036da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8036dd:	5b                   	pop    %ebx
  8036de:	5e                   	pop    %esi
  8036df:	5d                   	pop    %ebp
  8036e0:	c3                   	ret    

008036e1 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8036e1:	55                   	push   %ebp
  8036e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8036e4:	6a 00                	push   $0x0
  8036e6:	6a 00                	push   $0x0
  8036e8:	6a 00                	push   $0x0
  8036ea:	6a 00                	push   $0x0
  8036ec:	ff 75 08             	pushl  0x8(%ebp)
  8036ef:	6a 0a                	push   $0xa
  8036f1:	e8 01 ff ff ff       	call   8035f7 <syscall>
  8036f6:	83 c4 18             	add    $0x18,%esp
}
  8036f9:	c9                   	leave  
  8036fa:	c3                   	ret    

008036fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8036fb:	55                   	push   %ebp
  8036fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8036fe:	6a 00                	push   $0x0
  803700:	6a 00                	push   $0x0
  803702:	6a 00                	push   $0x0
  803704:	ff 75 0c             	pushl  0xc(%ebp)
  803707:	ff 75 08             	pushl  0x8(%ebp)
  80370a:	6a 0b                	push   $0xb
  80370c:	e8 e6 fe ff ff       	call   8035f7 <syscall>
  803711:	83 c4 18             	add    $0x18,%esp
}
  803714:	c9                   	leave  
  803715:	c3                   	ret    

00803716 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803716:	55                   	push   %ebp
  803717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803719:	6a 00                	push   $0x0
  80371b:	6a 00                	push   $0x0
  80371d:	6a 00                	push   $0x0
  80371f:	6a 00                	push   $0x0
  803721:	6a 00                	push   $0x0
  803723:	6a 0c                	push   $0xc
  803725:	e8 cd fe ff ff       	call   8035f7 <syscall>
  80372a:	83 c4 18             	add    $0x18,%esp
}
  80372d:	c9                   	leave  
  80372e:	c3                   	ret    

0080372f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80372f:	55                   	push   %ebp
  803730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803732:	6a 00                	push   $0x0
  803734:	6a 00                	push   $0x0
  803736:	6a 00                	push   $0x0
  803738:	6a 00                	push   $0x0
  80373a:	6a 00                	push   $0x0
  80373c:	6a 0d                	push   $0xd
  80373e:	e8 b4 fe ff ff       	call   8035f7 <syscall>
  803743:	83 c4 18             	add    $0x18,%esp
}
  803746:	c9                   	leave  
  803747:	c3                   	ret    

00803748 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803748:	55                   	push   %ebp
  803749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80374b:	6a 00                	push   $0x0
  80374d:	6a 00                	push   $0x0
  80374f:	6a 00                	push   $0x0
  803751:	6a 00                	push   $0x0
  803753:	6a 00                	push   $0x0
  803755:	6a 0e                	push   $0xe
  803757:	e8 9b fe ff ff       	call   8035f7 <syscall>
  80375c:	83 c4 18             	add    $0x18,%esp
}
  80375f:	c9                   	leave  
  803760:	c3                   	ret    

00803761 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803761:	55                   	push   %ebp
  803762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803764:	6a 00                	push   $0x0
  803766:	6a 00                	push   $0x0
  803768:	6a 00                	push   $0x0
  80376a:	6a 00                	push   $0x0
  80376c:	6a 00                	push   $0x0
  80376e:	6a 0f                	push   $0xf
  803770:	e8 82 fe ff ff       	call   8035f7 <syscall>
  803775:	83 c4 18             	add    $0x18,%esp
}
  803778:	c9                   	leave  
  803779:	c3                   	ret    

0080377a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80377a:	55                   	push   %ebp
  80377b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80377d:	6a 00                	push   $0x0
  80377f:	6a 00                	push   $0x0
  803781:	6a 00                	push   $0x0
  803783:	6a 00                	push   $0x0
  803785:	ff 75 08             	pushl  0x8(%ebp)
  803788:	6a 10                	push   $0x10
  80378a:	e8 68 fe ff ff       	call   8035f7 <syscall>
  80378f:	83 c4 18             	add    $0x18,%esp
}
  803792:	c9                   	leave  
  803793:	c3                   	ret    

00803794 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803794:	55                   	push   %ebp
  803795:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803797:	6a 00                	push   $0x0
  803799:	6a 00                	push   $0x0
  80379b:	6a 00                	push   $0x0
  80379d:	6a 00                	push   $0x0
  80379f:	6a 00                	push   $0x0
  8037a1:	6a 11                	push   $0x11
  8037a3:	e8 4f fe ff ff       	call   8035f7 <syscall>
  8037a8:	83 c4 18             	add    $0x18,%esp
}
  8037ab:	90                   	nop
  8037ac:	c9                   	leave  
  8037ad:	c3                   	ret    

008037ae <sys_cputc>:

void
sys_cputc(const char c)
{
  8037ae:	55                   	push   %ebp
  8037af:	89 e5                	mov    %esp,%ebp
  8037b1:	83 ec 04             	sub    $0x4,%esp
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8037ba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8037be:	6a 00                	push   $0x0
  8037c0:	6a 00                	push   $0x0
  8037c2:	6a 00                	push   $0x0
  8037c4:	6a 00                	push   $0x0
  8037c6:	50                   	push   %eax
  8037c7:	6a 01                	push   $0x1
  8037c9:	e8 29 fe ff ff       	call   8035f7 <syscall>
  8037ce:	83 c4 18             	add    $0x18,%esp
}
  8037d1:	90                   	nop
  8037d2:	c9                   	leave  
  8037d3:	c3                   	ret    

008037d4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8037d4:	55                   	push   %ebp
  8037d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8037d7:	6a 00                	push   $0x0
  8037d9:	6a 00                	push   $0x0
  8037db:	6a 00                	push   $0x0
  8037dd:	6a 00                	push   $0x0
  8037df:	6a 00                	push   $0x0
  8037e1:	6a 14                	push   $0x14
  8037e3:	e8 0f fe ff ff       	call   8035f7 <syscall>
  8037e8:	83 c4 18             	add    $0x18,%esp
}
  8037eb:	90                   	nop
  8037ec:	c9                   	leave  
  8037ed:	c3                   	ret    

008037ee <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8037ee:	55                   	push   %ebp
  8037ef:	89 e5                	mov    %esp,%ebp
  8037f1:	83 ec 04             	sub    $0x4,%esp
  8037f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8037f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8037fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8037fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	6a 00                	push   $0x0
  803806:	51                   	push   %ecx
  803807:	52                   	push   %edx
  803808:	ff 75 0c             	pushl  0xc(%ebp)
  80380b:	50                   	push   %eax
  80380c:	6a 15                	push   $0x15
  80380e:	e8 e4 fd ff ff       	call   8035f7 <syscall>
  803813:	83 c4 18             	add    $0x18,%esp
}
  803816:	c9                   	leave  
  803817:	c3                   	ret    

00803818 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803818:	55                   	push   %ebp
  803819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80381b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80381e:	8b 45 08             	mov    0x8(%ebp),%eax
  803821:	6a 00                	push   $0x0
  803823:	6a 00                	push   $0x0
  803825:	6a 00                	push   $0x0
  803827:	52                   	push   %edx
  803828:	50                   	push   %eax
  803829:	6a 16                	push   $0x16
  80382b:	e8 c7 fd ff ff       	call   8035f7 <syscall>
  803830:	83 c4 18             	add    $0x18,%esp
}
  803833:	c9                   	leave  
  803834:	c3                   	ret    

00803835 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803835:	55                   	push   %ebp
  803836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803838:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80383b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80383e:	8b 45 08             	mov    0x8(%ebp),%eax
  803841:	6a 00                	push   $0x0
  803843:	6a 00                	push   $0x0
  803845:	51                   	push   %ecx
  803846:	52                   	push   %edx
  803847:	50                   	push   %eax
  803848:	6a 17                	push   $0x17
  80384a:	e8 a8 fd ff ff       	call   8035f7 <syscall>
  80384f:	83 c4 18             	add    $0x18,%esp
}
  803852:	c9                   	leave  
  803853:	c3                   	ret    

00803854 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803854:	55                   	push   %ebp
  803855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80385a:	8b 45 08             	mov    0x8(%ebp),%eax
  80385d:	6a 00                	push   $0x0
  80385f:	6a 00                	push   $0x0
  803861:	6a 00                	push   $0x0
  803863:	52                   	push   %edx
  803864:	50                   	push   %eax
  803865:	6a 18                	push   $0x18
  803867:	e8 8b fd ff ff       	call   8035f7 <syscall>
  80386c:	83 c4 18             	add    $0x18,%esp
}
  80386f:	c9                   	leave  
  803870:	c3                   	ret    

00803871 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803871:	55                   	push   %ebp
  803872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	6a 00                	push   $0x0
  803879:	ff 75 14             	pushl  0x14(%ebp)
  80387c:	ff 75 10             	pushl  0x10(%ebp)
  80387f:	ff 75 0c             	pushl  0xc(%ebp)
  803882:	50                   	push   %eax
  803883:	6a 19                	push   $0x19
  803885:	e8 6d fd ff ff       	call   8035f7 <syscall>
  80388a:	83 c4 18             	add    $0x18,%esp
}
  80388d:	c9                   	leave  
  80388e:	c3                   	ret    

0080388f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80388f:	55                   	push   %ebp
  803890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803892:	8b 45 08             	mov    0x8(%ebp),%eax
  803895:	6a 00                	push   $0x0
  803897:	6a 00                	push   $0x0
  803899:	6a 00                	push   $0x0
  80389b:	6a 00                	push   $0x0
  80389d:	50                   	push   %eax
  80389e:	6a 1a                	push   $0x1a
  8038a0:	e8 52 fd ff ff       	call   8035f7 <syscall>
  8038a5:	83 c4 18             	add    $0x18,%esp
}
  8038a8:	90                   	nop
  8038a9:	c9                   	leave  
  8038aa:	c3                   	ret    

008038ab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8038ab:	55                   	push   %ebp
  8038ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	6a 00                	push   $0x0
  8038b3:	6a 00                	push   $0x0
  8038b5:	6a 00                	push   $0x0
  8038b7:	6a 00                	push   $0x0
  8038b9:	50                   	push   %eax
  8038ba:	6a 1b                	push   $0x1b
  8038bc:	e8 36 fd ff ff       	call   8035f7 <syscall>
  8038c1:	83 c4 18             	add    $0x18,%esp
}
  8038c4:	c9                   	leave  
  8038c5:	c3                   	ret    

008038c6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8038c6:	55                   	push   %ebp
  8038c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8038c9:	6a 00                	push   $0x0
  8038cb:	6a 00                	push   $0x0
  8038cd:	6a 00                	push   $0x0
  8038cf:	6a 00                	push   $0x0
  8038d1:	6a 00                	push   $0x0
  8038d3:	6a 05                	push   $0x5
  8038d5:	e8 1d fd ff ff       	call   8035f7 <syscall>
  8038da:	83 c4 18             	add    $0x18,%esp
}
  8038dd:	c9                   	leave  
  8038de:	c3                   	ret    

008038df <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8038df:	55                   	push   %ebp
  8038e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8038e2:	6a 00                	push   $0x0
  8038e4:	6a 00                	push   $0x0
  8038e6:	6a 00                	push   $0x0
  8038e8:	6a 00                	push   $0x0
  8038ea:	6a 00                	push   $0x0
  8038ec:	6a 06                	push   $0x6
  8038ee:	e8 04 fd ff ff       	call   8035f7 <syscall>
  8038f3:	83 c4 18             	add    $0x18,%esp
}
  8038f6:	c9                   	leave  
  8038f7:	c3                   	ret    

008038f8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8038f8:	55                   	push   %ebp
  8038f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8038fb:	6a 00                	push   $0x0
  8038fd:	6a 00                	push   $0x0
  8038ff:	6a 00                	push   $0x0
  803901:	6a 00                	push   $0x0
  803903:	6a 00                	push   $0x0
  803905:	6a 07                	push   $0x7
  803907:	e8 eb fc ff ff       	call   8035f7 <syscall>
  80390c:	83 c4 18             	add    $0x18,%esp
}
  80390f:	c9                   	leave  
  803910:	c3                   	ret    

00803911 <sys_exit_env>:


void sys_exit_env(void)
{
  803911:	55                   	push   %ebp
  803912:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803914:	6a 00                	push   $0x0
  803916:	6a 00                	push   $0x0
  803918:	6a 00                	push   $0x0
  80391a:	6a 00                	push   $0x0
  80391c:	6a 00                	push   $0x0
  80391e:	6a 1c                	push   $0x1c
  803920:	e8 d2 fc ff ff       	call   8035f7 <syscall>
  803925:	83 c4 18             	add    $0x18,%esp
}
  803928:	90                   	nop
  803929:	c9                   	leave  
  80392a:	c3                   	ret    

0080392b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80392b:	55                   	push   %ebp
  80392c:	89 e5                	mov    %esp,%ebp
  80392e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803931:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803934:	8d 50 04             	lea    0x4(%eax),%edx
  803937:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80393a:	6a 00                	push   $0x0
  80393c:	6a 00                	push   $0x0
  80393e:	6a 00                	push   $0x0
  803940:	52                   	push   %edx
  803941:	50                   	push   %eax
  803942:	6a 1d                	push   $0x1d
  803944:	e8 ae fc ff ff       	call   8035f7 <syscall>
  803949:	83 c4 18             	add    $0x18,%esp
	return result;
  80394c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80394f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803952:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803955:	89 01                	mov    %eax,(%ecx)
  803957:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80395a:	8b 45 08             	mov    0x8(%ebp),%eax
  80395d:	c9                   	leave  
  80395e:	c2 04 00             	ret    $0x4

00803961 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803961:	55                   	push   %ebp
  803962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803964:	6a 00                	push   $0x0
  803966:	6a 00                	push   $0x0
  803968:	ff 75 10             	pushl  0x10(%ebp)
  80396b:	ff 75 0c             	pushl  0xc(%ebp)
  80396e:	ff 75 08             	pushl  0x8(%ebp)
  803971:	6a 13                	push   $0x13
  803973:	e8 7f fc ff ff       	call   8035f7 <syscall>
  803978:	83 c4 18             	add    $0x18,%esp
	return ;
  80397b:	90                   	nop
}
  80397c:	c9                   	leave  
  80397d:	c3                   	ret    

0080397e <sys_rcr2>:
uint32 sys_rcr2()
{
  80397e:	55                   	push   %ebp
  80397f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803981:	6a 00                	push   $0x0
  803983:	6a 00                	push   $0x0
  803985:	6a 00                	push   $0x0
  803987:	6a 00                	push   $0x0
  803989:	6a 00                	push   $0x0
  80398b:	6a 1e                	push   $0x1e
  80398d:	e8 65 fc ff ff       	call   8035f7 <syscall>
  803992:	83 c4 18             	add    $0x18,%esp
}
  803995:	c9                   	leave  
  803996:	c3                   	ret    

00803997 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803997:	55                   	push   %ebp
  803998:	89 e5                	mov    %esp,%ebp
  80399a:	83 ec 04             	sub    $0x4,%esp
  80399d:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8039a3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8039a7:	6a 00                	push   $0x0
  8039a9:	6a 00                	push   $0x0
  8039ab:	6a 00                	push   $0x0
  8039ad:	6a 00                	push   $0x0
  8039af:	50                   	push   %eax
  8039b0:	6a 1f                	push   $0x1f
  8039b2:	e8 40 fc ff ff       	call   8035f7 <syscall>
  8039b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8039ba:	90                   	nop
}
  8039bb:	c9                   	leave  
  8039bc:	c3                   	ret    

008039bd <rsttst>:
void rsttst()
{
  8039bd:	55                   	push   %ebp
  8039be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8039c0:	6a 00                	push   $0x0
  8039c2:	6a 00                	push   $0x0
  8039c4:	6a 00                	push   $0x0
  8039c6:	6a 00                	push   $0x0
  8039c8:	6a 00                	push   $0x0
  8039ca:	6a 21                	push   $0x21
  8039cc:	e8 26 fc ff ff       	call   8035f7 <syscall>
  8039d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8039d4:	90                   	nop
}
  8039d5:	c9                   	leave  
  8039d6:	c3                   	ret    

008039d7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8039d7:	55                   	push   %ebp
  8039d8:	89 e5                	mov    %esp,%ebp
  8039da:	83 ec 04             	sub    $0x4,%esp
  8039dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8039e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8039e3:	8b 55 18             	mov    0x18(%ebp),%edx
  8039e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8039ea:	52                   	push   %edx
  8039eb:	50                   	push   %eax
  8039ec:	ff 75 10             	pushl  0x10(%ebp)
  8039ef:	ff 75 0c             	pushl  0xc(%ebp)
  8039f2:	ff 75 08             	pushl  0x8(%ebp)
  8039f5:	6a 20                	push   $0x20
  8039f7:	e8 fb fb ff ff       	call   8035f7 <syscall>
  8039fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8039ff:	90                   	nop
}
  803a00:	c9                   	leave  
  803a01:	c3                   	ret    

00803a02 <chktst>:
void chktst(uint32 n)
{
  803a02:	55                   	push   %ebp
  803a03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803a05:	6a 00                	push   $0x0
  803a07:	6a 00                	push   $0x0
  803a09:	6a 00                	push   $0x0
  803a0b:	6a 00                	push   $0x0
  803a0d:	ff 75 08             	pushl  0x8(%ebp)
  803a10:	6a 22                	push   $0x22
  803a12:	e8 e0 fb ff ff       	call   8035f7 <syscall>
  803a17:	83 c4 18             	add    $0x18,%esp
	return ;
  803a1a:	90                   	nop
}
  803a1b:	c9                   	leave  
  803a1c:	c3                   	ret    

00803a1d <inctst>:

void inctst()
{
  803a1d:	55                   	push   %ebp
  803a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803a20:	6a 00                	push   $0x0
  803a22:	6a 00                	push   $0x0
  803a24:	6a 00                	push   $0x0
  803a26:	6a 00                	push   $0x0
  803a28:	6a 00                	push   $0x0
  803a2a:	6a 23                	push   $0x23
  803a2c:	e8 c6 fb ff ff       	call   8035f7 <syscall>
  803a31:	83 c4 18             	add    $0x18,%esp
	return ;
  803a34:	90                   	nop
}
  803a35:	c9                   	leave  
  803a36:	c3                   	ret    

00803a37 <gettst>:
uint32 gettst()
{
  803a37:	55                   	push   %ebp
  803a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803a3a:	6a 00                	push   $0x0
  803a3c:	6a 00                	push   $0x0
  803a3e:	6a 00                	push   $0x0
  803a40:	6a 00                	push   $0x0
  803a42:	6a 00                	push   $0x0
  803a44:	6a 24                	push   $0x24
  803a46:	e8 ac fb ff ff       	call   8035f7 <syscall>
  803a4b:	83 c4 18             	add    $0x18,%esp
}
  803a4e:	c9                   	leave  
  803a4f:	c3                   	ret    

00803a50 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803a50:	55                   	push   %ebp
  803a51:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803a53:	6a 00                	push   $0x0
  803a55:	6a 00                	push   $0x0
  803a57:	6a 00                	push   $0x0
  803a59:	6a 00                	push   $0x0
  803a5b:	6a 00                	push   $0x0
  803a5d:	6a 25                	push   $0x25
  803a5f:	e8 93 fb ff ff       	call   8035f7 <syscall>
  803a64:	83 c4 18             	add    $0x18,%esp
  803a67:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  803a6c:	a1 80 60 83 00       	mov    0x836080,%eax
}
  803a71:	c9                   	leave  
  803a72:	c3                   	ret    

00803a73 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803a73:	55                   	push   %ebp
  803a74:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803a76:	8b 45 08             	mov    0x8(%ebp),%eax
  803a79:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803a7e:	6a 00                	push   $0x0
  803a80:	6a 00                	push   $0x0
  803a82:	6a 00                	push   $0x0
  803a84:	6a 00                	push   $0x0
  803a86:	ff 75 08             	pushl  0x8(%ebp)
  803a89:	6a 26                	push   $0x26
  803a8b:	e8 67 fb ff ff       	call   8035f7 <syscall>
  803a90:	83 c4 18             	add    $0x18,%esp
	return ;
  803a93:	90                   	nop
}
  803a94:	c9                   	leave  
  803a95:	c3                   	ret    

00803a96 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803a96:	55                   	push   %ebp
  803a97:	89 e5                	mov    %esp,%ebp
  803a99:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803a9a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803a9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa6:	6a 00                	push   $0x0
  803aa8:	53                   	push   %ebx
  803aa9:	51                   	push   %ecx
  803aaa:	52                   	push   %edx
  803aab:	50                   	push   %eax
  803aac:	6a 27                	push   $0x27
  803aae:	e8 44 fb ff ff       	call   8035f7 <syscall>
  803ab3:	83 c4 18             	add    $0x18,%esp
}
  803ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803ab9:	c9                   	leave  
  803aba:	c3                   	ret    

00803abb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803abb:	55                   	push   %ebp
  803abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac4:	6a 00                	push   $0x0
  803ac6:	6a 00                	push   $0x0
  803ac8:	6a 00                	push   $0x0
  803aca:	52                   	push   %edx
  803acb:	50                   	push   %eax
  803acc:	6a 28                	push   $0x28
  803ace:	e8 24 fb ff ff       	call   8035f7 <syscall>
  803ad3:	83 c4 18             	add    $0x18,%esp
}
  803ad6:	c9                   	leave  
  803ad7:	c3                   	ret    

00803ad8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803ad8:	55                   	push   %ebp
  803ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803adb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae4:	6a 00                	push   $0x0
  803ae6:	51                   	push   %ecx
  803ae7:	ff 75 10             	pushl  0x10(%ebp)
  803aea:	52                   	push   %edx
  803aeb:	50                   	push   %eax
  803aec:	6a 29                	push   $0x29
  803aee:	e8 04 fb ff ff       	call   8035f7 <syscall>
  803af3:	83 c4 18             	add    $0x18,%esp
}
  803af6:	c9                   	leave  
  803af7:	c3                   	ret    

00803af8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803af8:	55                   	push   %ebp
  803af9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803afb:	6a 00                	push   $0x0
  803afd:	6a 00                	push   $0x0
  803aff:	ff 75 10             	pushl  0x10(%ebp)
  803b02:	ff 75 0c             	pushl  0xc(%ebp)
  803b05:	ff 75 08             	pushl  0x8(%ebp)
  803b08:	6a 12                	push   $0x12
  803b0a:	e8 e8 fa ff ff       	call   8035f7 <syscall>
  803b0f:	83 c4 18             	add    $0x18,%esp
	return ;
  803b12:	90                   	nop
}
  803b13:	c9                   	leave  
  803b14:	c3                   	ret    

00803b15 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803b15:	55                   	push   %ebp
  803b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1e:	6a 00                	push   $0x0
  803b20:	6a 00                	push   $0x0
  803b22:	6a 00                	push   $0x0
  803b24:	52                   	push   %edx
  803b25:	50                   	push   %eax
  803b26:	6a 2a                	push   $0x2a
  803b28:	e8 ca fa ff ff       	call   8035f7 <syscall>
  803b2d:	83 c4 18             	add    $0x18,%esp
	return;
  803b30:	90                   	nop
}
  803b31:	c9                   	leave  
  803b32:	c3                   	ret    

00803b33 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803b33:	55                   	push   %ebp
  803b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803b36:	6a 00                	push   $0x0
  803b38:	6a 00                	push   $0x0
  803b3a:	6a 00                	push   $0x0
  803b3c:	6a 00                	push   $0x0
  803b3e:	6a 00                	push   $0x0
  803b40:	6a 2b                	push   $0x2b
  803b42:	e8 b0 fa ff ff       	call   8035f7 <syscall>
  803b47:	83 c4 18             	add    $0x18,%esp
}
  803b4a:	c9                   	leave  
  803b4b:	c3                   	ret    

00803b4c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803b4c:	55                   	push   %ebp
  803b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803b4f:	6a 00                	push   $0x0
  803b51:	6a 00                	push   $0x0
  803b53:	6a 00                	push   $0x0
  803b55:	ff 75 0c             	pushl  0xc(%ebp)
  803b58:	ff 75 08             	pushl  0x8(%ebp)
  803b5b:	6a 2d                	push   $0x2d
  803b5d:	e8 95 fa ff ff       	call   8035f7 <syscall>
  803b62:	83 c4 18             	add    $0x18,%esp
	return;
  803b65:	90                   	nop
}
  803b66:	c9                   	leave  
  803b67:	c3                   	ret    

00803b68 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803b68:	55                   	push   %ebp
  803b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803b6b:	6a 00                	push   $0x0
  803b6d:	6a 00                	push   $0x0
  803b6f:	6a 00                	push   $0x0
  803b71:	ff 75 0c             	pushl  0xc(%ebp)
  803b74:	ff 75 08             	pushl  0x8(%ebp)
  803b77:	6a 2c                	push   $0x2c
  803b79:	e8 79 fa ff ff       	call   8035f7 <syscall>
  803b7e:	83 c4 18             	add    $0x18,%esp
	return ;
  803b81:	90                   	nop
}
  803b82:	c9                   	leave  
  803b83:	c3                   	ret    

00803b84 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803b84:	55                   	push   %ebp
  803b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8d:	6a 00                	push   $0x0
  803b8f:	6a 00                	push   $0x0
  803b91:	6a 00                	push   $0x0
  803b93:	52                   	push   %edx
  803b94:	50                   	push   %eax
  803b95:	6a 2e                	push   $0x2e
  803b97:	e8 5b fa ff ff       	call   8035f7 <syscall>
  803b9c:	83 c4 18             	add    $0x18,%esp
}
  803b9f:	90                   	nop
  803ba0:	c9                   	leave  
  803ba1:	c3                   	ret    

00803ba2 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803ba2:	55                   	push   %ebp
  803ba3:	89 e5                	mov    %esp,%ebp
  803ba5:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803ba8:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803baf:	72 09                	jb     803bba <to_page_va+0x18>
  803bb1:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803bb8:	72 14                	jb     803bce <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803bba:	83 ec 04             	sub    $0x4,%esp
  803bbd:	68 0c 52 80 00       	push   $0x80520c
  803bc2:	6a 15                	push   $0x15
  803bc4:	68 37 52 80 00       	push   $0x805237
  803bc9:	e8 68 0a 00 00       	call   804636 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803bce:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd1:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803bd6:	29 d0                	sub    %edx,%eax
  803bd8:	c1 f8 02             	sar    $0x2,%eax
  803bdb:	89 c2                	mov    %eax,%edx
  803bdd:	89 d0                	mov    %edx,%eax
  803bdf:	c1 e0 02             	shl    $0x2,%eax
  803be2:	01 d0                	add    %edx,%eax
  803be4:	c1 e0 02             	shl    $0x2,%eax
  803be7:	01 d0                	add    %edx,%eax
  803be9:	c1 e0 02             	shl    $0x2,%eax
  803bec:	01 d0                	add    %edx,%eax
  803bee:	89 c1                	mov    %eax,%ecx
  803bf0:	c1 e1 08             	shl    $0x8,%ecx
  803bf3:	01 c8                	add    %ecx,%eax
  803bf5:	89 c1                	mov    %eax,%ecx
  803bf7:	c1 e1 10             	shl    $0x10,%ecx
  803bfa:	01 c8                	add    %ecx,%eax
  803bfc:	01 c0                	add    %eax,%eax
  803bfe:	01 d0                	add    %edx,%eax
  803c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c06:	c1 e0 0c             	shl    $0xc,%eax
  803c09:	89 c2                	mov    %eax,%edx
  803c0b:	a1 84 60 83 00       	mov    0x836084,%eax
  803c10:	01 d0                	add    %edx,%eax
}
  803c12:	c9                   	leave  
  803c13:	c3                   	ret    

00803c14 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803c14:	55                   	push   %ebp
  803c15:	89 e5                	mov    %esp,%ebp
  803c17:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803c1a:	a1 84 60 83 00       	mov    0x836084,%eax
  803c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  803c22:	29 c2                	sub    %eax,%edx
  803c24:	89 d0                	mov    %edx,%eax
  803c26:	c1 e8 0c             	shr    $0xc,%eax
  803c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c30:	78 09                	js     803c3b <to_page_info+0x27>
  803c32:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803c39:	7e 14                	jle    803c4f <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803c3b:	83 ec 04             	sub    $0x4,%esp
  803c3e:	68 50 52 80 00       	push   $0x805250
  803c43:	6a 21                	push   $0x21
  803c45:	68 37 52 80 00       	push   $0x805237
  803c4a:	e8 e7 09 00 00       	call   804636 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c52:	89 d0                	mov    %edx,%eax
  803c54:	01 c0                	add    %eax,%eax
  803c56:	01 d0                	add    %edx,%eax
  803c58:	c1 e0 02             	shl    $0x2,%eax
  803c5b:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803c60:	c9                   	leave  
  803c61:	c3                   	ret    

00803c62 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803c62:	55                   	push   %ebp
  803c63:	89 e5                	mov    %esp,%ebp
  803c65:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803c68:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6b:	05 00 00 00 02       	add    $0x2000000,%eax
  803c70:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c73:	73 16                	jae    803c8b <initialize_dynamic_allocator+0x29>
  803c75:	68 74 52 80 00       	push   $0x805274
  803c7a:	68 9a 52 80 00       	push   $0x80529a
  803c7f:	6a 2f                	push   $0x2f
  803c81:	68 37 52 80 00       	push   $0x805237
  803c86:	e8 ab 09 00 00       	call   804636 <_panic>
	dynAllocStart = daStart;
  803c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8e:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c96:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803c9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803ca2:	eb 36                	jmp    803cda <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca7:	c1 e0 04             	shl    $0x4,%eax
  803caa:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb8:	c1 e0 04             	shl    $0x4,%eax
  803cbb:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803cc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc9:	c1 e0 04             	shl    $0x4,%eax
  803ccc:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803cd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803cd7:	ff 45 f4             	incl   -0xc(%ebp)
  803cda:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803cde:	7e c4                	jle    803ca4 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803ce0:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803ce7:	00 00 00 
  803cea:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803cf1:	00 00 00 
  803cf4:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803cfb:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803cfe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803d05:	e9 1b 01 00 00       	jmp    803e25 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803d0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d0d:	89 d0                	mov    %edx,%eax
  803d0f:	01 c0                	add    %eax,%eax
  803d11:	01 d0                	add    %edx,%eax
  803d13:	c1 e0 02             	shl    $0x2,%eax
  803d16:	05 88 e0 81 00       	add    $0x81e088,%eax
  803d1b:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803d20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d23:	89 d0                	mov    %edx,%eax
  803d25:	01 c0                	add    %eax,%eax
  803d27:	01 d0                	add    %edx,%eax
  803d29:	c1 e0 02             	shl    $0x2,%eax
  803d2c:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803d31:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803d36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d39:	89 d0                	mov    %edx,%eax
  803d3b:	01 c0                	add    %eax,%eax
  803d3d:	01 d0                	add    %edx,%eax
  803d3f:	c1 e0 02             	shl    $0x2,%eax
  803d42:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d47:	8b 00                	mov    (%eax),%eax
  803d49:	85 c0                	test   %eax,%eax
  803d4b:	74 2b                	je     803d78 <initialize_dynamic_allocator+0x116>
  803d4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d50:	89 d0                	mov    %edx,%eax
  803d52:	01 c0                	add    %eax,%eax
  803d54:	01 d0                	add    %edx,%eax
  803d56:	c1 e0 02             	shl    $0x2,%eax
  803d59:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d5e:	8b 10                	mov    (%eax),%edx
  803d60:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803d63:	89 c8                	mov    %ecx,%eax
  803d65:	01 c0                	add    %eax,%eax
  803d67:	01 c8                	add    %ecx,%eax
  803d69:	c1 e0 02             	shl    $0x2,%eax
  803d6c:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d71:	8b 00                	mov    (%eax),%eax
  803d73:	89 42 04             	mov    %eax,0x4(%edx)
  803d76:	eb 18                	jmp    803d90 <initialize_dynamic_allocator+0x12e>
  803d78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d7b:	89 d0                	mov    %edx,%eax
  803d7d:	01 c0                	add    %eax,%eax
  803d7f:	01 d0                	add    %edx,%eax
  803d81:	c1 e0 02             	shl    $0x2,%eax
  803d84:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d89:	8b 00                	mov    (%eax),%eax
  803d8b:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803d90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d93:	89 d0                	mov    %edx,%eax
  803d95:	01 c0                	add    %eax,%eax
  803d97:	01 d0                	add    %edx,%eax
  803d99:	c1 e0 02             	shl    $0x2,%eax
  803d9c:	05 84 e0 81 00       	add    $0x81e084,%eax
  803da1:	8b 00                	mov    (%eax),%eax
  803da3:	85 c0                	test   %eax,%eax
  803da5:	74 2a                	je     803dd1 <initialize_dynamic_allocator+0x16f>
  803da7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803daa:	89 d0                	mov    %edx,%eax
  803dac:	01 c0                	add    %eax,%eax
  803dae:	01 d0                	add    %edx,%eax
  803db0:	c1 e0 02             	shl    $0x2,%eax
  803db3:	05 84 e0 81 00       	add    $0x81e084,%eax
  803db8:	8b 10                	mov    (%eax),%edx
  803dba:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803dbd:	89 c8                	mov    %ecx,%eax
  803dbf:	01 c0                	add    %eax,%eax
  803dc1:	01 c8                	add    %ecx,%eax
  803dc3:	c1 e0 02             	shl    $0x2,%eax
  803dc6:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dcb:	8b 00                	mov    (%eax),%eax
  803dcd:	89 02                	mov    %eax,(%edx)
  803dcf:	eb 18                	jmp    803de9 <initialize_dynamic_allocator+0x187>
  803dd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dd4:	89 d0                	mov    %edx,%eax
  803dd6:	01 c0                	add    %eax,%eax
  803dd8:	01 d0                	add    %edx,%eax
  803dda:	c1 e0 02             	shl    $0x2,%eax
  803ddd:	05 80 e0 81 00       	add    $0x81e080,%eax
  803de2:	8b 00                	mov    (%eax),%eax
  803de4:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803de9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dec:	89 d0                	mov    %edx,%eax
  803dee:	01 c0                	add    %eax,%eax
  803df0:	01 d0                	add    %edx,%eax
  803df2:	c1 e0 02             	shl    $0x2,%eax
  803df5:	05 80 e0 81 00       	add    $0x81e080,%eax
  803dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e03:	89 d0                	mov    %edx,%eax
  803e05:	01 c0                	add    %eax,%eax
  803e07:	01 d0                	add    %edx,%eax
  803e09:	c1 e0 02             	shl    $0x2,%eax
  803e0c:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e17:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803e1c:	48                   	dec    %eax
  803e1d:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803e22:	ff 45 f0             	incl   -0x10(%ebp)
  803e25:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803e2c:	0f 8e d8 fe ff ff    	jle    803d0a <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803e32:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803e39:	e9 9d 00 00 00       	jmp    803edb <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803e3e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803e44:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803e47:	89 c8                	mov    %ecx,%eax
  803e49:	01 c0                	add    %eax,%eax
  803e4b:	01 c8                	add    %ecx,%eax
  803e4d:	c1 e0 02             	shl    $0x2,%eax
  803e50:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e55:	89 10                	mov    %edx,(%eax)
  803e57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e5a:	89 d0                	mov    %edx,%eax
  803e5c:	01 c0                	add    %eax,%eax
  803e5e:	01 d0                	add    %edx,%eax
  803e60:	c1 e0 02             	shl    $0x2,%eax
  803e63:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e68:	8b 00                	mov    (%eax),%eax
  803e6a:	85 c0                	test   %eax,%eax
  803e6c:	74 1c                	je     803e8a <initialize_dynamic_allocator+0x228>
  803e6e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803e74:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803e77:	89 c8                	mov    %ecx,%eax
  803e79:	01 c0                	add    %eax,%eax
  803e7b:	01 c8                	add    %ecx,%eax
  803e7d:	c1 e0 02             	shl    $0x2,%eax
  803e80:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e85:	89 42 04             	mov    %eax,0x4(%edx)
  803e88:	eb 16                	jmp    803ea0 <initialize_dynamic_allocator+0x23e>
  803e8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e8d:	89 d0                	mov    %edx,%eax
  803e8f:	01 c0                	add    %eax,%eax
  803e91:	01 d0                	add    %edx,%eax
  803e93:	c1 e0 02             	shl    $0x2,%eax
  803e96:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e9b:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803ea0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ea3:	89 d0                	mov    %edx,%eax
  803ea5:	01 c0                	add    %eax,%eax
  803ea7:	01 d0                	add    %edx,%eax
  803ea9:	c1 e0 02             	shl    $0x2,%eax
  803eac:	05 80 e0 81 00       	add    $0x81e080,%eax
  803eb1:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803eb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803eb9:	89 d0                	mov    %edx,%eax
  803ebb:	01 c0                	add    %eax,%eax
  803ebd:	01 d0                	add    %edx,%eax
  803ebf:	c1 e0 02             	shl    $0x2,%eax
  803ec2:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ecd:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803ed2:	40                   	inc    %eax
  803ed3:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803ed8:	ff 4d ec             	decl   -0x14(%ebp)
  803edb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803edf:	0f 89 59 ff ff ff    	jns    803e3e <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803ee5:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803eec:	00 00 00 
}
  803eef:	90                   	nop
  803ef0:	c9                   	leave  
  803ef1:	c3                   	ret    

00803ef2 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803ef2:	55                   	push   %ebp
  803ef3:	89 e5                	mov    %esp,%ebp
  803ef5:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  803efb:	83 ec 0c             	sub    $0xc,%esp
  803efe:	50                   	push   %eax
  803eff:	e8 10 fd ff ff       	call   803c14 <to_page_info>
  803f04:	83 c4 10             	add    $0x10,%esp
  803f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0d:	8b 40 08             	mov    0x8(%eax),%eax
  803f10:	0f b7 c0             	movzwl %ax,%eax
}
  803f13:	c9                   	leave  
  803f14:	c3                   	ret    

00803f15 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803f15:	55                   	push   %ebp
  803f16:	89 e5                	mov    %esp,%ebp
  803f18:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803f1b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803f22:	76 16                	jbe    803f3a <alloc_block+0x25>
  803f24:	68 b0 52 80 00       	push   $0x8052b0
  803f29:	68 9a 52 80 00       	push   $0x80529a
  803f2e:	6a 59                	push   $0x59
  803f30:	68 37 52 80 00       	push   $0x805237
  803f35:	e8 fc 06 00 00       	call   804636 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803f3a:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803f41:	eb 08                	jmp    803f4b <alloc_block+0x36>
		allocSize <<= 1;
  803f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f46:	01 c0                	add    %eax,%eax
  803f48:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f51:	73 09                	jae    803f5c <alloc_block+0x47>
  803f53:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803f5a:	76 e7                	jbe    803f43 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803f5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803f63:	eb 03                	jmp    803f68 <alloc_block+0x53>
		listIndex++;
  803f65:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6b:	ba 08 00 00 00       	mov    $0x8,%edx
  803f70:	88 c1                	mov    %al,%cl
  803f72:	d3 e2                	shl    %cl,%edx
  803f74:	89 d0                	mov    %edx,%eax
  803f76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803f79:	72 ea                	jb     803f65 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803f81:	e9 f4 00 00 00       	jmp    80407a <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f89:	c1 e0 04             	shl    $0x4,%eax
  803f8c:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f91:	8b 00                	mov    (%eax),%eax
  803f93:	85 c0                	test   %eax,%eax
  803f95:	0f 84 dc 00 00 00    	je     804077 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f9e:	c1 e0 04             	shl    $0x4,%eax
  803fa1:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803fa6:	8b 00                	mov    (%eax),%eax
  803fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803fab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803faf:	75 14                	jne    803fc5 <alloc_block+0xb0>
  803fb1:	83 ec 04             	sub    $0x4,%esp
  803fb4:	68 d1 52 80 00       	push   $0x8052d1
  803fb9:	6a 6b                	push   $0x6b
  803fbb:	68 37 52 80 00       	push   $0x805237
  803fc0:	e8 71 06 00 00       	call   804636 <_panic>
  803fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc8:	8b 00                	mov    (%eax),%eax
  803fca:	85 c0                	test   %eax,%eax
  803fcc:	74 10                	je     803fde <alloc_block+0xc9>
  803fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd1:	8b 00                	mov    (%eax),%eax
  803fd3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fd6:	8b 52 04             	mov    0x4(%edx),%edx
  803fd9:	89 50 04             	mov    %edx,0x4(%eax)
  803fdc:	eb 14                	jmp    803ff2 <alloc_block+0xdd>
  803fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe1:	8b 40 04             	mov    0x4(%eax),%eax
  803fe4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fe7:	c1 e2 04             	shl    $0x4,%edx
  803fea:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803ff0:	89 02                	mov    %eax,(%edx)
  803ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff5:	8b 40 04             	mov    0x4(%eax),%eax
  803ff8:	85 c0                	test   %eax,%eax
  803ffa:	74 0f                	je     80400b <alloc_block+0xf6>
  803ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fff:	8b 40 04             	mov    0x4(%eax),%eax
  804002:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804005:	8b 12                	mov    (%edx),%edx
  804007:	89 10                	mov    %edx,(%eax)
  804009:	eb 13                	jmp    80401e <alloc_block+0x109>
  80400b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80400e:	8b 00                	mov    (%eax),%eax
  804010:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804013:	c1 e2 04             	shl    $0x4,%edx
  804016:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  80401c:	89 02                	mov    %eax,(%edx)
  80401e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804021:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804034:	c1 e0 04             	shl    $0x4,%eax
  804037:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80403c:	8b 00                	mov    (%eax),%eax
  80403e:	8d 50 ff             	lea    -0x1(%eax),%edx
  804041:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804044:	c1 e0 04             	shl    $0x4,%eax
  804047:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80404c:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  80404e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804051:	83 ec 0c             	sub    $0xc,%esp
  804054:	50                   	push   %eax
  804055:	e8 ba fb ff ff       	call   803c14 <to_page_info>
  80405a:	83 c4 10             	add    $0x10,%esp
  80405d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  804060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804063:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804067:	48                   	dec    %eax
  804068:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80406b:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  80406f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804072:	e9 8f 02 00 00       	jmp    804306 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804077:	ff 45 ec             	incl   -0x14(%ebp)
  80407a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80407e:	0f 8e 02 ff ff ff    	jle    803f86 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  804084:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804089:	85 c0                	test   %eax,%eax
  80408b:	75 14                	jne    8040a1 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  80408d:	83 ec 04             	sub    $0x4,%esp
  804090:	68 f0 52 80 00       	push   $0x8052f0
  804095:	6a 77                	push   $0x77
  804097:	68 37 52 80 00       	push   $0x805237
  80409c:	e8 95 05 00 00       	call   804636 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  8040a1:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8040a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  8040a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8040ad:	75 14                	jne    8040c3 <alloc_block+0x1ae>
  8040af:	83 ec 04             	sub    $0x4,%esp
  8040b2:	68 d1 52 80 00       	push   $0x8052d1
  8040b7:	6a 7a                	push   $0x7a
  8040b9:	68 37 52 80 00       	push   $0x805237
  8040be:	e8 73 05 00 00       	call   804636 <_panic>
  8040c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040c6:	8b 00                	mov    (%eax),%eax
  8040c8:	85 c0                	test   %eax,%eax
  8040ca:	74 10                	je     8040dc <alloc_block+0x1c7>
  8040cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040cf:	8b 00                	mov    (%eax),%eax
  8040d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040d4:	8b 52 04             	mov    0x4(%edx),%edx
  8040d7:	89 50 04             	mov    %edx,0x4(%eax)
  8040da:	eb 0b                	jmp    8040e7 <alloc_block+0x1d2>
  8040dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040df:	8b 40 04             	mov    0x4(%eax),%eax
  8040e2:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8040e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040ea:	8b 40 04             	mov    0x4(%eax),%eax
  8040ed:	85 c0                	test   %eax,%eax
  8040ef:	74 0f                	je     804100 <alloc_block+0x1eb>
  8040f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040f4:	8b 40 04             	mov    0x4(%eax),%eax
  8040f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8040fa:	8b 12                	mov    (%edx),%edx
  8040fc:	89 10                	mov    %edx,(%eax)
  8040fe:	eb 0a                	jmp    80410a <alloc_block+0x1f5>
  804100:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804103:	8b 00                	mov    (%eax),%eax
  804105:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80410a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80410d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804113:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804116:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80411d:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804122:	48                   	dec    %eax
  804123:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  804128:	83 ec 0c             	sub    $0xc,%esp
  80412b:	ff 75 dc             	pushl  -0x24(%ebp)
  80412e:	e8 6f fa ff ff       	call   803ba2 <to_page_va>
  804133:	83 c4 10             	add    $0x10,%esp
  804136:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  804139:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80413c:	83 ec 0c             	sub    $0xc,%esp
  80413f:	50                   	push   %eax
  804140:	e8 a0 dc ff ff       	call   801de5 <get_page>
  804145:	83 c4 10             	add    $0x10,%esp
  804148:	85 c0                	test   %eax,%eax
  80414a:	74 14                	je     804160 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  80414c:	83 ec 04             	sub    $0x4,%esp
  80414f:	68 18 53 80 00       	push   $0x805318
  804154:	6a 7f                	push   $0x7f
  804156:	68 37 52 80 00       	push   $0x805237
  80415b:	e8 d6 04 00 00       	call   804636 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  804160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804163:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804166:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  80416a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80416f:	ba 00 00 00 00       	mov    $0x0,%edx
  804174:	f7 75 f4             	divl   -0xc(%ebp)
  804177:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80417a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80417e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804185:	e9 a7 00 00 00       	jmp    804231 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  80418a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80418d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804190:	01 d0                	add    %edx,%eax
  804192:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  804195:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804199:	75 17                	jne    8041b2 <alloc_block+0x29d>
  80419b:	83 ec 04             	sub    $0x4,%esp
  80419e:	68 40 53 80 00       	push   $0x805340
  8041a3:	68 88 00 00 00       	push   $0x88
  8041a8:	68 37 52 80 00       	push   $0x805237
  8041ad:	e8 84 04 00 00       	call   804636 <_panic>
  8041b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041b5:	c1 e0 04             	shl    $0x4,%eax
  8041b8:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041bd:	8b 10                	mov    (%eax),%edx
  8041bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041c2:	89 10                	mov    %edx,(%eax)
  8041c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041c7:	8b 00                	mov    (%eax),%eax
  8041c9:	85 c0                	test   %eax,%eax
  8041cb:	74 15                	je     8041e2 <alloc_block+0x2cd>
  8041cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041d0:	c1 e0 04             	shl    $0x4,%eax
  8041d3:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041d8:	8b 00                	mov    (%eax),%eax
  8041da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8041dd:	89 50 04             	mov    %edx,0x4(%eax)
  8041e0:	eb 11                	jmp    8041f3 <alloc_block+0x2de>
  8041e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041e5:	c1 e0 04             	shl    $0x4,%eax
  8041e8:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8041ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8041f1:	89 02                	mov    %eax,(%edx)
  8041f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041f6:	c1 e0 04             	shl    $0x4,%eax
  8041f9:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8041ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804202:	89 02                	mov    %eax,(%edx)
  804204:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804207:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80420e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804211:	c1 e0 04             	shl    $0x4,%eax
  804214:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804219:	8b 00                	mov    (%eax),%eax
  80421b:	8d 50 01             	lea    0x1(%eax),%edx
  80421e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804221:	c1 e0 04             	shl    $0x4,%eax
  804224:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804229:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80422b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422e:	01 45 e8             	add    %eax,-0x18(%ebp)
  804231:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  804238:	0f 86 4c ff ff ff    	jbe    80418a <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  80423e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804241:	c1 e0 04             	shl    $0x4,%eax
  804244:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804249:	8b 00                	mov    (%eax),%eax
  80424b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  80424e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804252:	75 17                	jne    80426b <alloc_block+0x356>
  804254:	83 ec 04             	sub    $0x4,%esp
  804257:	68 d1 52 80 00       	push   $0x8052d1
  80425c:	68 8d 00 00 00       	push   $0x8d
  804261:	68 37 52 80 00       	push   $0x805237
  804266:	e8 cb 03 00 00       	call   804636 <_panic>
  80426b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80426e:	8b 00                	mov    (%eax),%eax
  804270:	85 c0                	test   %eax,%eax
  804272:	74 10                	je     804284 <alloc_block+0x36f>
  804274:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804277:	8b 00                	mov    (%eax),%eax
  804279:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80427c:	8b 52 04             	mov    0x4(%edx),%edx
  80427f:	89 50 04             	mov    %edx,0x4(%eax)
  804282:	eb 14                	jmp    804298 <alloc_block+0x383>
  804284:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804287:	8b 40 04             	mov    0x4(%eax),%eax
  80428a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80428d:	c1 e2 04             	shl    $0x4,%edx
  804290:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804296:	89 02                	mov    %eax,(%edx)
  804298:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80429b:	8b 40 04             	mov    0x4(%eax),%eax
  80429e:	85 c0                	test   %eax,%eax
  8042a0:	74 0f                	je     8042b1 <alloc_block+0x39c>
  8042a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042a5:	8b 40 04             	mov    0x4(%eax),%eax
  8042a8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8042ab:	8b 12                	mov    (%edx),%edx
  8042ad:	89 10                	mov    %edx,(%eax)
  8042af:	eb 13                	jmp    8042c4 <alloc_block+0x3af>
  8042b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042b4:	8b 00                	mov    (%eax),%eax
  8042b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042b9:	c1 e2 04             	shl    $0x4,%edx
  8042bc:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8042c2:	89 02                	mov    %eax,(%edx)
  8042c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8042d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042da:	c1 e0 04             	shl    $0x4,%eax
  8042dd:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042e2:	8b 00                	mov    (%eax),%eax
  8042e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8042e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ea:	c1 e0 04             	shl    $0x4,%eax
  8042ed:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042f2:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8042f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042f7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8042fb:	48                   	dec    %eax
  8042fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8042ff:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  804303:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804306:	c9                   	leave  
  804307:	c3                   	ret    

00804308 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804308:	55                   	push   %ebp
  804309:	89 e5                	mov    %esp,%ebp
  80430b:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80430e:	8b 55 08             	mov    0x8(%ebp),%edx
  804311:	a1 84 60 83 00       	mov    0x836084,%eax
  804316:	39 c2                	cmp    %eax,%edx
  804318:	72 0c                	jb     804326 <free_block+0x1e>
  80431a:	8b 55 08             	mov    0x8(%ebp),%edx
  80431d:	a1 60 e0 81 00       	mov    0x81e060,%eax
  804322:	39 c2                	cmp    %eax,%edx
  804324:	72 19                	jb     80433f <free_block+0x37>
  804326:	68 64 53 80 00       	push   $0x805364
  80432b:	68 9a 52 80 00       	push   $0x80529a
  804330:	68 98 00 00 00       	push   $0x98
  804335:	68 37 52 80 00       	push   $0x805237
  80433a:	e8 f7 02 00 00       	call   804636 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80433f:	8b 45 08             	mov    0x8(%ebp),%eax
  804342:	83 ec 0c             	sub    $0xc,%esp
  804345:	50                   	push   %eax
  804346:	e8 c9 f8 ff ff       	call   803c14 <to_page_info>
  80434b:	83 c4 10             	add    $0x10,%esp
  80434e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804351:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804354:	8b 40 08             	mov    0x8(%eax),%eax
  804357:	0f b7 c0             	movzwl %ax,%eax
  80435a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  80435d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804364:	eb 03                	jmp    804369 <free_block+0x61>
		listIndex++;
  804366:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80436c:	ba 08 00 00 00       	mov    $0x8,%edx
  804371:	88 c1                	mov    %al,%cl
  804373:	d3 e2                	shl    %cl,%edx
  804375:	89 d0                	mov    %edx,%eax
  804377:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80437a:	72 ea                	jb     804366 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  80437c:	8b 45 08             	mov    0x8(%ebp),%eax
  80437f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  804382:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804386:	75 17                	jne    80439f <free_block+0x97>
  804388:	83 ec 04             	sub    $0x4,%esp
  80438b:	68 40 53 80 00       	push   $0x805340
  804390:	68 a2 00 00 00       	push   $0xa2
  804395:	68 37 52 80 00       	push   $0x805237
  80439a:	e8 97 02 00 00       	call   804636 <_panic>
  80439f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a2:	c1 e0 04             	shl    $0x4,%eax
  8043a5:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8043aa:	8b 10                	mov    (%eax),%edx
  8043ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043af:	89 10                	mov    %edx,(%eax)
  8043b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043b4:	8b 00                	mov    (%eax),%eax
  8043b6:	85 c0                	test   %eax,%eax
  8043b8:	74 15                	je     8043cf <free_block+0xc7>
  8043ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043bd:	c1 e0 04             	shl    $0x4,%eax
  8043c0:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8043c5:	8b 00                	mov    (%eax),%eax
  8043c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043ca:	89 50 04             	mov    %edx,0x4(%eax)
  8043cd:	eb 11                	jmp    8043e0 <free_block+0xd8>
  8043cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d2:	c1 e0 04             	shl    $0x4,%eax
  8043d5:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8043db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043de:	89 02                	mov    %eax,(%edx)
  8043e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043e3:	c1 e0 04             	shl    $0x4,%eax
  8043e6:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8043ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043ef:	89 02                	mov    %eax,(%edx)
  8043f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8043f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043fe:	c1 e0 04             	shl    $0x4,%eax
  804401:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804406:	8b 00                	mov    (%eax),%eax
  804408:	8d 50 01             	lea    0x1(%eax),%edx
  80440b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80440e:	c1 e0 04             	shl    $0x4,%eax
  804411:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804416:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80441b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80441f:	40                   	inc    %eax
  804420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804423:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80442a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80442e:	0f b7 c8             	movzwl %ax,%ecx
  804431:	b8 00 10 00 00       	mov    $0x1000,%eax
  804436:	ba 00 00 00 00       	mov    $0x0,%edx
  80443b:	f7 75 e8             	divl   -0x18(%ebp)
  80443e:	39 c1                	cmp    %eax,%ecx
  804440:	0f 85 ed 01 00 00    	jne    804633 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804449:	c1 e0 04             	shl    $0x4,%eax
  80444c:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804451:	8b 00                	mov    (%eax),%eax
  804453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804456:	eb 2a                	jmp    804482 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  804458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80445b:	83 ec 0c             	sub    $0xc,%esp
  80445e:	50                   	push   %eax
  80445f:	e8 b0 f7 ff ff       	call   803c14 <to_page_info>
  804464:	83 c4 10             	add    $0x10,%esp
  804467:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80446a:	75 06                	jne    804472 <free_block+0x16a>
				tmp = b;
  80446c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80446f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804475:	c1 e0 04             	shl    $0x4,%eax
  804478:	05 a8 60 83 00       	add    $0x8360a8,%eax
  80447d:	8b 00                	mov    (%eax),%eax
  80447f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804482:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804486:	74 07                	je     80448f <free_block+0x187>
  804488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80448b:	8b 00                	mov    (%eax),%eax
  80448d:	eb 05                	jmp    804494 <free_block+0x18c>
  80448f:	b8 00 00 00 00       	mov    $0x0,%eax
  804494:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804497:	c1 e2 04             	shl    $0x4,%edx
  80449a:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  8044a0:	89 02                	mov    %eax,(%edx)
  8044a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044a5:	c1 e0 04             	shl    $0x4,%eax
  8044a8:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8044ad:	8b 00                	mov    (%eax),%eax
  8044af:	85 c0                	test   %eax,%eax
  8044b1:	75 a5                	jne    804458 <free_block+0x150>
  8044b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044b7:	75 9f                	jne    804458 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  8044b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044bc:	c1 e0 04             	shl    $0x4,%eax
  8044bf:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8044c4:	8b 00                	mov    (%eax),%eax
  8044c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  8044c9:	e9 cc 00 00 00       	jmp    80459a <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  8044ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044d1:	8b 00                	mov    (%eax),%eax
  8044d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  8044d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044d9:	83 ec 0c             	sub    $0xc,%esp
  8044dc:	50                   	push   %eax
  8044dd:	e8 32 f7 ff ff       	call   803c14 <to_page_info>
  8044e2:	83 c4 10             	add    $0x10,%esp
  8044e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8044e8:	0f 85 a6 00 00 00    	jne    804594 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  8044ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044f2:	75 17                	jne    80450b <free_block+0x203>
  8044f4:	83 ec 04             	sub    $0x4,%esp
  8044f7:	68 d1 52 80 00       	push   $0x8052d1
  8044fc:	68 b5 00 00 00       	push   $0xb5
  804501:	68 37 52 80 00       	push   $0x805237
  804506:	e8 2b 01 00 00       	call   804636 <_panic>
  80450b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80450e:	8b 00                	mov    (%eax),%eax
  804510:	85 c0                	test   %eax,%eax
  804512:	74 10                	je     804524 <free_block+0x21c>
  804514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804517:	8b 00                	mov    (%eax),%eax
  804519:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80451c:	8b 52 04             	mov    0x4(%edx),%edx
  80451f:	89 50 04             	mov    %edx,0x4(%eax)
  804522:	eb 14                	jmp    804538 <free_block+0x230>
  804524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804527:	8b 40 04             	mov    0x4(%eax),%eax
  80452a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80452d:	c1 e2 04             	shl    $0x4,%edx
  804530:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804536:	89 02                	mov    %eax,(%edx)
  804538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80453b:	8b 40 04             	mov    0x4(%eax),%eax
  80453e:	85 c0                	test   %eax,%eax
  804540:	74 0f                	je     804551 <free_block+0x249>
  804542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804545:	8b 40 04             	mov    0x4(%eax),%eax
  804548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80454b:	8b 12                	mov    (%edx),%edx
  80454d:	89 10                	mov    %edx,(%eax)
  80454f:	eb 13                	jmp    804564 <free_block+0x25c>
  804551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804554:	8b 00                	mov    (%eax),%eax
  804556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804559:	c1 e2 04             	shl    $0x4,%edx
  80455c:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804562:	89 02                	mov    %eax,(%edx)
  804564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804567:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80456d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804570:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80457a:	c1 e0 04             	shl    $0x4,%eax
  80457d:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804582:	8b 00                	mov    (%eax),%eax
  804584:	8d 50 ff             	lea    -0x1(%eax),%edx
  804587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80458a:	c1 e0 04             	shl    $0x4,%eax
  80458d:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804592:	89 10                	mov    %edx,(%eax)
			b = next;
  804594:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804597:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  80459a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80459e:	0f 85 2a ff ff ff    	jne    8044ce <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  8045a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045a7:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8045ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045b0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  8045b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8045ba:	75 17                	jne    8045d3 <free_block+0x2cb>
  8045bc:	83 ec 04             	sub    $0x4,%esp
  8045bf:	68 40 53 80 00       	push   $0x805340
  8045c4:	68 bc 00 00 00       	push   $0xbc
  8045c9:	68 37 52 80 00       	push   $0x805237
  8045ce:	e8 63 00 00 00       	call   804636 <_panic>
  8045d3:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8045d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045dc:	89 10                	mov    %edx,(%eax)
  8045de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045e1:	8b 00                	mov    (%eax),%eax
  8045e3:	85 c0                	test   %eax,%eax
  8045e5:	74 0d                	je     8045f4 <free_block+0x2ec>
  8045e7:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8045ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045ef:	89 50 04             	mov    %edx,0x4(%eax)
  8045f2:	eb 08                	jmp    8045fc <free_block+0x2f4>
  8045f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045f7:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8045fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045ff:	a3 68 e0 81 00       	mov    %eax,0x81e068
  804604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804607:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80460e:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804613:	40                   	inc    %eax
  804614:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804619:	83 ec 0c             	sub    $0xc,%esp
  80461c:	ff 75 ec             	pushl  -0x14(%ebp)
  80461f:	e8 7e f5 ff ff       	call   803ba2 <to_page_va>
  804624:	83 c4 10             	add    $0x10,%esp
  804627:	83 ec 0c             	sub    $0xc,%esp
  80462a:	50                   	push   %eax
  80462b:	e8 fe d7 ff ff       	call   801e2e <return_page>
  804630:	83 c4 10             	add    $0x10,%esp
	}
}
  804633:	90                   	nop
  804634:	c9                   	leave  
  804635:	c3                   	ret    

00804636 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  804636:	55                   	push   %ebp
  804637:	89 e5                	mov    %esp,%ebp
  804639:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80463c:	8d 45 10             	lea    0x10(%ebp),%eax
  80463f:	83 c0 04             	add    $0x4,%eax
  804642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  804645:	a1 3c 61 83 00       	mov    0x83613c,%eax
  80464a:	85 c0                	test   %eax,%eax
  80464c:	74 16                	je     804664 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80464e:	a1 3c 61 83 00       	mov    0x83613c,%eax
  804653:	83 ec 08             	sub    $0x8,%esp
  804656:	50                   	push   %eax
  804657:	68 9c 53 80 00       	push   $0x80539c
  80465c:	e8 43 c6 ff ff       	call   800ca4 <cprintf>
  804661:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  804664:	a1 04 60 80 00       	mov    0x806004,%eax
  804669:	83 ec 0c             	sub    $0xc,%esp
  80466c:	ff 75 0c             	pushl  0xc(%ebp)
  80466f:	ff 75 08             	pushl  0x8(%ebp)
  804672:	50                   	push   %eax
  804673:	68 a4 53 80 00       	push   $0x8053a4
  804678:	6a 74                	push   $0x74
  80467a:	e8 52 c6 ff ff       	call   800cd1 <cprintf_colored>
  80467f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  804682:	8b 45 10             	mov    0x10(%ebp),%eax
  804685:	83 ec 08             	sub    $0x8,%esp
  804688:	ff 75 f4             	pushl  -0xc(%ebp)
  80468b:	50                   	push   %eax
  80468c:	e8 a4 c5 ff ff       	call   800c35 <vcprintf>
  804691:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  804694:	83 ec 08             	sub    $0x8,%esp
  804697:	6a 00                	push   $0x0
  804699:	68 cc 53 80 00       	push   $0x8053cc
  80469e:	e8 92 c5 ff ff       	call   800c35 <vcprintf>
  8046a3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8046a6:	e8 0b c5 ff ff       	call   800bb6 <exit>

	// should not return here
	while (1) ;
  8046ab:	eb fe                	jmp    8046ab <_panic+0x75>

008046ad <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8046ad:	55                   	push   %ebp
  8046ae:	89 e5                	mov    %esp,%ebp
  8046b0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8046b3:	a1 20 60 80 00       	mov    0x806020,%eax
  8046b8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8046be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046c1:	39 c2                	cmp    %eax,%edx
  8046c3:	74 14                	je     8046d9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8046c5:	83 ec 04             	sub    $0x4,%esp
  8046c8:	68 d0 53 80 00       	push   $0x8053d0
  8046cd:	6a 26                	push   $0x26
  8046cf:	68 1c 54 80 00       	push   $0x80541c
  8046d4:	e8 5d ff ff ff       	call   804636 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8046d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8046e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8046e7:	e9 c5 00 00 00       	jmp    8047b1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8046ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8046f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8046f9:	01 d0                	add    %edx,%eax
  8046fb:	8b 00                	mov    (%eax),%eax
  8046fd:	85 c0                	test   %eax,%eax
  8046ff:	75 08                	jne    804709 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  804701:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804704:	e9 a5 00 00 00       	jmp    8047ae <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  804709:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804710:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804717:	eb 69                	jmp    804782 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  804719:	a1 20 60 80 00       	mov    0x806020,%eax
  80471e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804724:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804727:	89 d0                	mov    %edx,%eax
  804729:	01 c0                	add    %eax,%eax
  80472b:	01 d0                	add    %edx,%eax
  80472d:	c1 e0 03             	shl    $0x3,%eax
  804730:	01 c8                	add    %ecx,%eax
  804732:	8a 40 04             	mov    0x4(%eax),%al
  804735:	84 c0                	test   %al,%al
  804737:	75 46                	jne    80477f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804739:	a1 20 60 80 00       	mov    0x806020,%eax
  80473e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804744:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804747:	89 d0                	mov    %edx,%eax
  804749:	01 c0                	add    %eax,%eax
  80474b:	01 d0                	add    %edx,%eax
  80474d:	c1 e0 03             	shl    $0x3,%eax
  804750:	01 c8                	add    %ecx,%eax
  804752:	8b 00                	mov    (%eax),%eax
  804754:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804757:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80475a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80475f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804764:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80476b:	8b 45 08             	mov    0x8(%ebp),%eax
  80476e:	01 c8                	add    %ecx,%eax
  804770:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804772:	39 c2                	cmp    %eax,%edx
  804774:	75 09                	jne    80477f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804776:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80477d:	eb 15                	jmp    804794 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80477f:	ff 45 e8             	incl   -0x18(%ebp)
  804782:	a1 20 60 80 00       	mov    0x806020,%eax
  804787:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80478d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804790:	39 c2                	cmp    %eax,%edx
  804792:	77 85                	ja     804719 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804794:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804798:	75 14                	jne    8047ae <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80479a:	83 ec 04             	sub    $0x4,%esp
  80479d:	68 28 54 80 00       	push   $0x805428
  8047a2:	6a 3a                	push   $0x3a
  8047a4:	68 1c 54 80 00       	push   $0x80541c
  8047a9:	e8 88 fe ff ff       	call   804636 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8047ae:	ff 45 f0             	incl   -0x10(%ebp)
  8047b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8047b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8047b7:	0f 8c 2f ff ff ff    	jl     8046ec <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8047bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8047c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8047cb:	eb 26                	jmp    8047f3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8047cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8047d2:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8047d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8047db:	89 d0                	mov    %edx,%eax
  8047dd:	01 c0                	add    %eax,%eax
  8047df:	01 d0                	add    %edx,%eax
  8047e1:	c1 e0 03             	shl    $0x3,%eax
  8047e4:	01 c8                	add    %ecx,%eax
  8047e6:	8a 40 04             	mov    0x4(%eax),%al
  8047e9:	3c 01                	cmp    $0x1,%al
  8047eb:	75 03                	jne    8047f0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8047ed:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8047f0:	ff 45 e0             	incl   -0x20(%ebp)
  8047f3:	a1 20 60 80 00       	mov    0x806020,%eax
  8047f8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8047fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804801:	39 c2                	cmp    %eax,%edx
  804803:	77 c8                	ja     8047cd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804808:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80480b:	74 14                	je     804821 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80480d:	83 ec 04             	sub    $0x4,%esp
  804810:	68 7c 54 80 00       	push   $0x80547c
  804815:	6a 44                	push   $0x44
  804817:	68 1c 54 80 00       	push   $0x80541c
  80481c:	e8 15 fe ff ff       	call   804636 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  804821:	90                   	nop
  804822:	c9                   	leave  
  804823:	c3                   	ret    

00804824 <__udivdi3>:
  804824:	55                   	push   %ebp
  804825:	57                   	push   %edi
  804826:	56                   	push   %esi
  804827:	53                   	push   %ebx
  804828:	83 ec 1c             	sub    $0x1c,%esp
  80482b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80482f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804837:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80483b:	89 ca                	mov    %ecx,%edx
  80483d:	89 f8                	mov    %edi,%eax
  80483f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804843:	85 f6                	test   %esi,%esi
  804845:	75 2d                	jne    804874 <__udivdi3+0x50>
  804847:	39 cf                	cmp    %ecx,%edi
  804849:	77 65                	ja     8048b0 <__udivdi3+0x8c>
  80484b:	89 fd                	mov    %edi,%ebp
  80484d:	85 ff                	test   %edi,%edi
  80484f:	75 0b                	jne    80485c <__udivdi3+0x38>
  804851:	b8 01 00 00 00       	mov    $0x1,%eax
  804856:	31 d2                	xor    %edx,%edx
  804858:	f7 f7                	div    %edi
  80485a:	89 c5                	mov    %eax,%ebp
  80485c:	31 d2                	xor    %edx,%edx
  80485e:	89 c8                	mov    %ecx,%eax
  804860:	f7 f5                	div    %ebp
  804862:	89 c1                	mov    %eax,%ecx
  804864:	89 d8                	mov    %ebx,%eax
  804866:	f7 f5                	div    %ebp
  804868:	89 cf                	mov    %ecx,%edi
  80486a:	89 fa                	mov    %edi,%edx
  80486c:	83 c4 1c             	add    $0x1c,%esp
  80486f:	5b                   	pop    %ebx
  804870:	5e                   	pop    %esi
  804871:	5f                   	pop    %edi
  804872:	5d                   	pop    %ebp
  804873:	c3                   	ret    
  804874:	39 ce                	cmp    %ecx,%esi
  804876:	77 28                	ja     8048a0 <__udivdi3+0x7c>
  804878:	0f bd fe             	bsr    %esi,%edi
  80487b:	83 f7 1f             	xor    $0x1f,%edi
  80487e:	75 40                	jne    8048c0 <__udivdi3+0x9c>
  804880:	39 ce                	cmp    %ecx,%esi
  804882:	72 0a                	jb     80488e <__udivdi3+0x6a>
  804884:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804888:	0f 87 9e 00 00 00    	ja     80492c <__udivdi3+0x108>
  80488e:	b8 01 00 00 00       	mov    $0x1,%eax
  804893:	89 fa                	mov    %edi,%edx
  804895:	83 c4 1c             	add    $0x1c,%esp
  804898:	5b                   	pop    %ebx
  804899:	5e                   	pop    %esi
  80489a:	5f                   	pop    %edi
  80489b:	5d                   	pop    %ebp
  80489c:	c3                   	ret    
  80489d:	8d 76 00             	lea    0x0(%esi),%esi
  8048a0:	31 ff                	xor    %edi,%edi
  8048a2:	31 c0                	xor    %eax,%eax
  8048a4:	89 fa                	mov    %edi,%edx
  8048a6:	83 c4 1c             	add    $0x1c,%esp
  8048a9:	5b                   	pop    %ebx
  8048aa:	5e                   	pop    %esi
  8048ab:	5f                   	pop    %edi
  8048ac:	5d                   	pop    %ebp
  8048ad:	c3                   	ret    
  8048ae:	66 90                	xchg   %ax,%ax
  8048b0:	89 d8                	mov    %ebx,%eax
  8048b2:	f7 f7                	div    %edi
  8048b4:	31 ff                	xor    %edi,%edi
  8048b6:	89 fa                	mov    %edi,%edx
  8048b8:	83 c4 1c             	add    $0x1c,%esp
  8048bb:	5b                   	pop    %ebx
  8048bc:	5e                   	pop    %esi
  8048bd:	5f                   	pop    %edi
  8048be:	5d                   	pop    %ebp
  8048bf:	c3                   	ret    
  8048c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8048c5:	89 eb                	mov    %ebp,%ebx
  8048c7:	29 fb                	sub    %edi,%ebx
  8048c9:	89 f9                	mov    %edi,%ecx
  8048cb:	d3 e6                	shl    %cl,%esi
  8048cd:	89 c5                	mov    %eax,%ebp
  8048cf:	88 d9                	mov    %bl,%cl
  8048d1:	d3 ed                	shr    %cl,%ebp
  8048d3:	89 e9                	mov    %ebp,%ecx
  8048d5:	09 f1                	or     %esi,%ecx
  8048d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8048db:	89 f9                	mov    %edi,%ecx
  8048dd:	d3 e0                	shl    %cl,%eax
  8048df:	89 c5                	mov    %eax,%ebp
  8048e1:	89 d6                	mov    %edx,%esi
  8048e3:	88 d9                	mov    %bl,%cl
  8048e5:	d3 ee                	shr    %cl,%esi
  8048e7:	89 f9                	mov    %edi,%ecx
  8048e9:	d3 e2                	shl    %cl,%edx
  8048eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048ef:	88 d9                	mov    %bl,%cl
  8048f1:	d3 e8                	shr    %cl,%eax
  8048f3:	09 c2                	or     %eax,%edx
  8048f5:	89 d0                	mov    %edx,%eax
  8048f7:	89 f2                	mov    %esi,%edx
  8048f9:	f7 74 24 0c          	divl   0xc(%esp)
  8048fd:	89 d6                	mov    %edx,%esi
  8048ff:	89 c3                	mov    %eax,%ebx
  804901:	f7 e5                	mul    %ebp
  804903:	39 d6                	cmp    %edx,%esi
  804905:	72 19                	jb     804920 <__udivdi3+0xfc>
  804907:	74 0b                	je     804914 <__udivdi3+0xf0>
  804909:	89 d8                	mov    %ebx,%eax
  80490b:	31 ff                	xor    %edi,%edi
  80490d:	e9 58 ff ff ff       	jmp    80486a <__udivdi3+0x46>
  804912:	66 90                	xchg   %ax,%ax
  804914:	8b 54 24 08          	mov    0x8(%esp),%edx
  804918:	89 f9                	mov    %edi,%ecx
  80491a:	d3 e2                	shl    %cl,%edx
  80491c:	39 c2                	cmp    %eax,%edx
  80491e:	73 e9                	jae    804909 <__udivdi3+0xe5>
  804920:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804923:	31 ff                	xor    %edi,%edi
  804925:	e9 40 ff ff ff       	jmp    80486a <__udivdi3+0x46>
  80492a:	66 90                	xchg   %ax,%ax
  80492c:	31 c0                	xor    %eax,%eax
  80492e:	e9 37 ff ff ff       	jmp    80486a <__udivdi3+0x46>
  804933:	90                   	nop

00804934 <__umoddi3>:
  804934:	55                   	push   %ebp
  804935:	57                   	push   %edi
  804936:	56                   	push   %esi
  804937:	53                   	push   %ebx
  804938:	83 ec 1c             	sub    $0x1c,%esp
  80493b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80493f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804943:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804947:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80494b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80494f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804953:	89 f3                	mov    %esi,%ebx
  804955:	89 fa                	mov    %edi,%edx
  804957:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80495b:	89 34 24             	mov    %esi,(%esp)
  80495e:	85 c0                	test   %eax,%eax
  804960:	75 1a                	jne    80497c <__umoddi3+0x48>
  804962:	39 f7                	cmp    %esi,%edi
  804964:	0f 86 a2 00 00 00    	jbe    804a0c <__umoddi3+0xd8>
  80496a:	89 c8                	mov    %ecx,%eax
  80496c:	89 f2                	mov    %esi,%edx
  80496e:	f7 f7                	div    %edi
  804970:	89 d0                	mov    %edx,%eax
  804972:	31 d2                	xor    %edx,%edx
  804974:	83 c4 1c             	add    $0x1c,%esp
  804977:	5b                   	pop    %ebx
  804978:	5e                   	pop    %esi
  804979:	5f                   	pop    %edi
  80497a:	5d                   	pop    %ebp
  80497b:	c3                   	ret    
  80497c:	39 f0                	cmp    %esi,%eax
  80497e:	0f 87 ac 00 00 00    	ja     804a30 <__umoddi3+0xfc>
  804984:	0f bd e8             	bsr    %eax,%ebp
  804987:	83 f5 1f             	xor    $0x1f,%ebp
  80498a:	0f 84 ac 00 00 00    	je     804a3c <__umoddi3+0x108>
  804990:	bf 20 00 00 00       	mov    $0x20,%edi
  804995:	29 ef                	sub    %ebp,%edi
  804997:	89 fe                	mov    %edi,%esi
  804999:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80499d:	89 e9                	mov    %ebp,%ecx
  80499f:	d3 e0                	shl    %cl,%eax
  8049a1:	89 d7                	mov    %edx,%edi
  8049a3:	89 f1                	mov    %esi,%ecx
  8049a5:	d3 ef                	shr    %cl,%edi
  8049a7:	09 c7                	or     %eax,%edi
  8049a9:	89 e9                	mov    %ebp,%ecx
  8049ab:	d3 e2                	shl    %cl,%edx
  8049ad:	89 14 24             	mov    %edx,(%esp)
  8049b0:	89 d8                	mov    %ebx,%eax
  8049b2:	d3 e0                	shl    %cl,%eax
  8049b4:	89 c2                	mov    %eax,%edx
  8049b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8049ba:	d3 e0                	shl    %cl,%eax
  8049bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8049c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8049c4:	89 f1                	mov    %esi,%ecx
  8049c6:	d3 e8                	shr    %cl,%eax
  8049c8:	09 d0                	or     %edx,%eax
  8049ca:	d3 eb                	shr    %cl,%ebx
  8049cc:	89 da                	mov    %ebx,%edx
  8049ce:	f7 f7                	div    %edi
  8049d0:	89 d3                	mov    %edx,%ebx
  8049d2:	f7 24 24             	mull   (%esp)
  8049d5:	89 c6                	mov    %eax,%esi
  8049d7:	89 d1                	mov    %edx,%ecx
  8049d9:	39 d3                	cmp    %edx,%ebx
  8049db:	0f 82 87 00 00 00    	jb     804a68 <__umoddi3+0x134>
  8049e1:	0f 84 91 00 00 00    	je     804a78 <__umoddi3+0x144>
  8049e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8049eb:	29 f2                	sub    %esi,%edx
  8049ed:	19 cb                	sbb    %ecx,%ebx
  8049ef:	89 d8                	mov    %ebx,%eax
  8049f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8049f5:	d3 e0                	shl    %cl,%eax
  8049f7:	89 e9                	mov    %ebp,%ecx
  8049f9:	d3 ea                	shr    %cl,%edx
  8049fb:	09 d0                	or     %edx,%eax
  8049fd:	89 e9                	mov    %ebp,%ecx
  8049ff:	d3 eb                	shr    %cl,%ebx
  804a01:	89 da                	mov    %ebx,%edx
  804a03:	83 c4 1c             	add    $0x1c,%esp
  804a06:	5b                   	pop    %ebx
  804a07:	5e                   	pop    %esi
  804a08:	5f                   	pop    %edi
  804a09:	5d                   	pop    %ebp
  804a0a:	c3                   	ret    
  804a0b:	90                   	nop
  804a0c:	89 fd                	mov    %edi,%ebp
  804a0e:	85 ff                	test   %edi,%edi
  804a10:	75 0b                	jne    804a1d <__umoddi3+0xe9>
  804a12:	b8 01 00 00 00       	mov    $0x1,%eax
  804a17:	31 d2                	xor    %edx,%edx
  804a19:	f7 f7                	div    %edi
  804a1b:	89 c5                	mov    %eax,%ebp
  804a1d:	89 f0                	mov    %esi,%eax
  804a1f:	31 d2                	xor    %edx,%edx
  804a21:	f7 f5                	div    %ebp
  804a23:	89 c8                	mov    %ecx,%eax
  804a25:	f7 f5                	div    %ebp
  804a27:	89 d0                	mov    %edx,%eax
  804a29:	e9 44 ff ff ff       	jmp    804972 <__umoddi3+0x3e>
  804a2e:	66 90                	xchg   %ax,%ax
  804a30:	89 c8                	mov    %ecx,%eax
  804a32:	89 f2                	mov    %esi,%edx
  804a34:	83 c4 1c             	add    $0x1c,%esp
  804a37:	5b                   	pop    %ebx
  804a38:	5e                   	pop    %esi
  804a39:	5f                   	pop    %edi
  804a3a:	5d                   	pop    %ebp
  804a3b:	c3                   	ret    
  804a3c:	3b 04 24             	cmp    (%esp),%eax
  804a3f:	72 06                	jb     804a47 <__umoddi3+0x113>
  804a41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804a45:	77 0f                	ja     804a56 <__umoddi3+0x122>
  804a47:	89 f2                	mov    %esi,%edx
  804a49:	29 f9                	sub    %edi,%ecx
  804a4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804a4f:	89 14 24             	mov    %edx,(%esp)
  804a52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a56:	8b 44 24 04          	mov    0x4(%esp),%eax
  804a5a:	8b 14 24             	mov    (%esp),%edx
  804a5d:	83 c4 1c             	add    $0x1c,%esp
  804a60:	5b                   	pop    %ebx
  804a61:	5e                   	pop    %esi
  804a62:	5f                   	pop    %edi
  804a63:	5d                   	pop    %ebp
  804a64:	c3                   	ret    
  804a65:	8d 76 00             	lea    0x0(%esi),%esi
  804a68:	2b 04 24             	sub    (%esp),%eax
  804a6b:	19 fa                	sbb    %edi,%edx
  804a6d:	89 d1                	mov    %edx,%ecx
  804a6f:	89 c6                	mov    %eax,%esi
  804a71:	e9 71 ff ff ff       	jmp    8049e7 <__umoddi3+0xb3>
  804a76:	66 90                	xchg   %ax,%ax
  804a78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804a7c:	72 ea                	jb     804a68 <__umoddi3+0x134>
  804a7e:	89 d9                	mov    %ebx,%ecx
  804a80:	e9 62 ff ff ff       	jmp    8049e7 <__umoddi3+0xb3>
