
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 b7 08 00 00       	call   8008ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	/*[1] CREATE SEMAPHORES*/
	struct semaphore ready = create_semaphore("Ready", 0);
  800044:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800047:	83 ec 04             	sub    $0x4,%esp
  80004a:	6a 00                	push   $0x0
  80004c:	68 40 4b 80 00       	push   $0x804b40
  800051:	50                   	push   %eax
  800052:	e8 a6 46 00 00       	call   8046fd <create_semaphore>
  800057:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = create_semaphore("Finished", 0);
  80005a:	8d 45 80             	lea    -0x80(%ebp),%eax
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	6a 00                	push   $0x0
  800062:	68 46 4b 80 00       	push   $0x804b46
  800067:	50                   	push   %eax
  800068:	e8 90 46 00 00       	call   8046fd <create_semaphore>
  80006d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cons_mutex = create_semaphore("Console Mutex", 1);
  800070:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	6a 01                	push   $0x1
  80007b:	68 4f 4b 80 00       	push   $0x804b4f
  800080:	50                   	push   %eax
  800081:	e8 77 46 00 00       	call   8046fd <create_semaphore>
  800086:	83 c4 0c             	add    $0xc,%esp

	/*[2] RUN THE SLAVES PROGRAMS*/
	int numOfSlaveProgs = 3 ;
  800089:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)

	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  800090:	a1 20 60 80 00       	mov    0x806020,%eax
  800095:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80009b:	a1 20 60 80 00       	mov    0x806020,%eax
  8000a0:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000a6:	89 c1                	mov    %eax,%ecx
  8000a8:	a1 20 60 80 00       	mov    0x806020,%eax
  8000ad:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b3:	52                   	push   %edx
  8000b4:	51                   	push   %ecx
  8000b5:	50                   	push   %eax
  8000b6:	68 5d 4b 80 00       	push   $0x804b5d
  8000bb:	e8 78 38 00 00       	call   803938 <sys_create_env>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000c6:	a1 20 60 80 00       	mov    0x806020,%eax
  8000cb:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000d1:	a1 20 60 80 00       	mov    0x806020,%eax
  8000d6:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000dc:	89 c1                	mov    %eax,%ecx
  8000de:	a1 20 60 80 00       	mov    0x806020,%eax
  8000e3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e9:	52                   	push   %edx
  8000ea:	51                   	push   %ecx
  8000eb:	50                   	push   %eax
  8000ec:	68 66 4b 80 00       	push   $0x804b66
  8000f1:	e8 42 38 00 00       	call   803938 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000fc:	a1 20 60 80 00       	mov    0x806020,%eax
  800101:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800107:	a1 20 60 80 00       	mov    0x806020,%eax
  80010c:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800112:	89 c1                	mov    %eax,%ecx
  800114:	a1 20 60 80 00       	mov    0x806020,%eax
  800119:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80011f:	52                   	push   %edx
  800120:	51                   	push   %ecx
  800121:	50                   	push   %eax
  800122:	68 6f 4b 80 00       	push   $0x804b6f
  800127:	e8 0c 38 00 00       	call   803938 <sys_create_env>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  800132:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  800136:	74 0c                	je     800144 <_main+0x10c>
  800138:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  80013c:	74 06                	je     800144 <_main+0x10c>
  80013e:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  800142:	75 14                	jne    800158 <_main+0x120>
		panic("NO AVAILABLE ENVs...");
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 7b 4b 80 00       	push   $0x804b7b
  80014c:	6a 1a                	push   $0x1a
  80014e:	68 90 4b 80 00       	push   $0x804b90
  800153:	e8 45 09 00 00       	call   800a9d <_panic>

	sys_run_env(envIdQuickSort);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d8             	pushl  -0x28(%ebp)
  80015e:	e8 f3 37 00 00       	call   803956 <sys_run_env>
  800163:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 75 d4             	pushl  -0x2c(%ebp)
  80016c:	e8 e5 37 00 00       	call   803956 <sys_run_env>
  800171:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 d0             	pushl  -0x30(%ebp)
  80017a:	e8 d7 37 00 00       	call   803956 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp

	/*[3] CREATE SHARED VARIABLES*/
	//Share the cons_mutex owner ID
	int *mutexOwnerID = smalloc("cons_mutex ownerID", sizeof(int) , 0) ;
  800182:	83 ec 04             	sub    $0x4,%esp
  800185:	6a 00                	push   $0x0
  800187:	6a 04                	push   $0x4
  800189:	68 ae 4b 80 00       	push   $0x804bae
  80018e:	e8 0f 25 00 00       	call   8026a2 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 cc             	mov    %eax,-0x34(%ebp)
	*mutexOwnerID = myEnv->env_id ;
  800199:	a1 20 60 80 00       	mov    0x806020,%eax
  80019e:	8b 50 10             	mov    0x10(%eax),%edx
  8001a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a4:	89 10                	mov    %edx,(%eax)

	int ret;
	char Chose;
	char Line[30];
	int NumOfElements;
	int *Elements = NULL;
  8001a6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	//lock the console
	wait_semaphore(cons_mutex);
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  8001b6:	e8 76 45 00 00       	call   804731 <wait_semaphore>
  8001bb:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 c1 4b 80 00       	push   $0x804bc1
  8001c6:	e8 a0 0b 00 00       	call   800d6b <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 c3 4b 80 00       	push   $0x804bc3
  8001d6:	e8 90 0b 00 00       	call   800d6b <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 e1 4b 80 00       	push   $0x804be1
  8001e6:	e8 80 0b 00 00       	call   800d6b <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 c3 4b 80 00       	push   $0x804bc3
  8001f6:	e8 70 0b 00 00       	call   800d6b <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 c1 4b 80 00       	push   $0x804bc1
  800206:	e8 60 0b 00 00       	call   800d6b <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800217:	50                   	push   %eax
  800218:	68 00 4c 80 00       	push   $0x804c00
  80021d:	e8 22 12 00 00       	call   801444 <readline>
  800222:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	6a 00                	push   $0x0
  80022a:	6a 04                	push   $0x4
  80022c:	68 1f 4c 80 00       	push   $0x804c1f
  800231:	e8 6c 24 00 00       	call   8026a2 <smalloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	6a 0a                	push   $0xa
  800241:	6a 00                	push   $0x0
  800243:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 0c 18 00 00       	call   801a5b <strtol>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	89 c2                	mov    %eax,%edx
  800254:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800257:	89 10                	mov    %edx,(%eax)
		NumOfElements = *arrSize;
  800259:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80025c:	8b 00                	mov    (%eax),%eax
  80025e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  800261:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800264:	c1 e0 02             	shl    $0x2,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	6a 00                	push   $0x0
  80026c:	50                   	push   %eax
  80026d:	68 27 4c 80 00       	push   $0x804c27
  800272:	e8 2b 24 00 00       	call   8026a2 <smalloc>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	89 45 c8             	mov    %eax,-0x38(%ebp)

		cprintf("Chose the initialization method:\n") ;
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	68 2c 4c 80 00       	push   $0x804c2c
  800285:	e8 e1 0a 00 00       	call   800d6b <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 4e 4c 80 00       	push   $0x804c4e
  800295:	e8 d1 0a 00 00       	call   800d6b <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	68 5c 4c 80 00       	push   $0x804c5c
  8002a5:	e8 c1 0a 00 00       	call   800d6b <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 6b 4c 80 00       	push   $0x804c6b
  8002b5:	e8 b1 0a 00 00       	call   800d6b <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	68 7b 4c 80 00       	push   $0x804c7b
  8002c5:	e8 a1 0a 00 00       	call   800d6b <cprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002cd:	e8 fe 05 00 00       	call   8008d0 <getchar>
  8002d2:	88 45 bf             	mov    %al,-0x41(%ebp)
			cputchar(Chose);
  8002d5:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	50                   	push   %eax
  8002dd:	e8 cf 05 00 00       	call   8008b1 <cputchar>
  8002e2:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	6a 0a                	push   $0xa
  8002ea:	e8 c2 05 00 00       	call   8008b1 <cputchar>
  8002ef:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  8002f2:	80 7d bf 61          	cmpb   $0x61,-0x41(%ebp)
  8002f6:	74 0c                	je     800304 <_main+0x2cc>
  8002f8:	80 7d bf 62          	cmpb   $0x62,-0x41(%ebp)
  8002fc:	74 06                	je     800304 <_main+0x2cc>
  8002fe:	80 7d bf 63          	cmpb   $0x63,-0x41(%ebp)
  800302:	75 b9                	jne    8002bd <_main+0x285>

	}
	signal_semaphore(cons_mutex);
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  80030d:	e8 39 44 00 00       	call   80474b <signal_semaphore>
  800312:	83 c4 10             	add    $0x10,%esp
	//unlock the console

	int  i ;
	switch (Chose)
  800315:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  800319:	83 f8 62             	cmp    $0x62,%eax
  80031c:	74 1d                	je     80033b <_main+0x303>
  80031e:	83 f8 63             	cmp    $0x63,%eax
  800321:	74 2b                	je     80034e <_main+0x316>
  800323:	83 f8 61             	cmp    $0x61,%eax
  800326:	75 39                	jne    800361 <_main+0x329>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	ff 75 c0             	pushl  -0x40(%ebp)
  80032e:	ff 75 c8             	pushl  -0x38(%ebp)
  800331:	e8 82 03 00 00       	call   8006b8 <InitializeAscending>
  800336:	83 c4 10             	add    $0x10,%esp
		break ;
  800339:	eb 37                	jmp    800372 <_main+0x33a>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 c0             	pushl  -0x40(%ebp)
  800341:	ff 75 c8             	pushl  -0x38(%ebp)
  800344:	e8 a0 03 00 00       	call   8006e9 <InitializeDescending>
  800349:	83 c4 10             	add    $0x10,%esp
		break ;
  80034c:	eb 24                	jmp    800372 <_main+0x33a>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	ff 75 c0             	pushl  -0x40(%ebp)
  800354:	ff 75 c8             	pushl  -0x38(%ebp)
  800357:	e8 c2 03 00 00       	call   80071e <InitializeSemiRandom>
  80035c:	83 c4 10             	add    $0x10,%esp
		break ;
  80035f:	eb 11                	jmp    800372 <_main+0x33a>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 c0             	pushl  -0x40(%ebp)
  800367:	ff 75 c8             	pushl  -0x38(%ebp)
  80036a:	e8 af 03 00 00       	call   80071e <InitializeSemiRandom>
  80036f:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800372:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800379:	eb 11                	jmp    80038c <_main+0x354>
		signal_semaphore(ready);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	ff 75 84             	pushl  -0x7c(%ebp)
  800381:	e8 c5 43 00 00       	call   80474b <signal_semaphore>
  800386:	83 c4 10             	add    $0x10,%esp
	default:
		InitializeSemiRandom(Elements, NumOfElements);
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800389:	ff 45 e4             	incl   -0x1c(%ebp)
  80038c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800392:	7c e7                	jl     80037b <_main+0x343>
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800394:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80039b:	eb 11                	jmp    8003ae <_main+0x376>
		wait_semaphore(finished);
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	ff 75 80             	pushl  -0x80(%ebp)
  8003a3:	e8 89 43 00 00       	call   804731 <wait_semaphore>
  8003a8:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < numOfSlaveProgs; ++i) {
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  8003ab:	ff 45 e0             	incl   -0x20(%ebp)
  8003ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003b4:	7c e7                	jl     80039d <_main+0x365>
		wait_semaphore(finished);
	}

	/*[6] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  8003b6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	int *mergesortedArr = NULL;
  8003bd:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int64 *mean = NULL;
  8003c4:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
	int64 *var = NULL;
  8003cb:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
	int *min = NULL;
  8003d2:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int *max = NULL;
  8003d9:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
	int *med = NULL;
  8003e0:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	68 84 4c 80 00       	push   $0x804c84
  8003ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8003f2:	e8 05 26 00 00       	call   8029fc <sget>
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	89 45 b8             	mov    %eax,-0x48(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	68 93 4c 80 00       	push   $0x804c93
  800405:	ff 75 d4             	pushl  -0x2c(%ebp)
  800408:	e8 ef 25 00 00       	call   8029fc <sget>
  80040d:	83 c4 10             	add    $0x10,%esp
  800410:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	mean = sget(envIdStats, "mean") ;
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	68 a2 4c 80 00       	push   $0x804ca2
  80041b:	ff 75 d0             	pushl  -0x30(%ebp)
  80041e:	e8 d9 25 00 00       	call   8029fc <sget>
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	89 45 b0             	mov    %eax,-0x50(%ebp)
	var = sget(envIdStats,"var") ;
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	68 a7 4c 80 00       	push   $0x804ca7
  800431:	ff 75 d0             	pushl  -0x30(%ebp)
  800434:	e8 c3 25 00 00       	call   8029fc <sget>
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	89 45 ac             	mov    %eax,-0x54(%ebp)
	min = sget(envIdStats,"min") ;
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	68 ab 4c 80 00       	push   $0x804cab
  800447:	ff 75 d0             	pushl  -0x30(%ebp)
  80044a:	e8 ad 25 00 00       	call   8029fc <sget>
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	89 45 a8             	mov    %eax,-0x58(%ebp)
	max = sget(envIdStats,"max") ;
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	68 af 4c 80 00       	push   $0x804caf
  80045d:	ff 75 d0             	pushl  -0x30(%ebp)
  800460:	e8 97 25 00 00       	call   8029fc <sget>
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	med = sget(envIdStats,"med") ;
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	68 b3 4c 80 00       	push   $0x804cb3
  800473:	ff 75 d0             	pushl  -0x30(%ebp)
  800476:	e8 81 25 00 00       	call   8029fc <sget>
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	89 45 a0             	mov    %eax,-0x60(%ebp)

	/*[7] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 c0             	pushl  -0x40(%ebp)
  800487:	ff 75 b8             	pushl  -0x48(%ebp)
  80048a:	e8 d2 01 00 00       	call   800661 <CheckSorted>
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  800495:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  800499:	75 14                	jne    8004af <_main+0x477>
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	68 b8 4c 80 00       	push   $0x804cb8
  8004a3:	6a 77                	push   $0x77
  8004a5:	68 90 4b 80 00       	push   $0x804b90
  8004aa:	e8 ee 05 00 00       	call   800a9d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 c0             	pushl  -0x40(%ebp)
  8004b5:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004b8:	e8 a4 01 00 00       	call   800661 <CheckSorted>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  8004c3:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8004c7:	75 14                	jne    8004dd <_main+0x4a5>
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 e0 4c 80 00       	push   $0x804ce0
  8004d1:	6a 79                	push   $0x79
  8004d3:	68 90 4b 80 00       	push   $0x804b90
  8004d8:	e8 c0 05 00 00       	call   800a9d <_panic>
	int64 correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  8004dd:	8d 85 48 ff ff ff    	lea    -0xb8(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 c0             	pushl  -0x40(%ebp)
  8004ee:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f1:	e8 74 02 00 00       	call   80076a <ArrayStats>
  8004f6:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  8004f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	int last = NumOfElements-1;
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	48                   	dec    %eax
  800505:	89 45 94             	mov    %eax,-0x6c(%ebp)
//	int middle = (NumOfElements-1)/2;
//	if (NumOfElements % 2 != 0)
//		middle--;
	int middle = (NumOfElements+1)/2 - 1; /*-1 to make it ZERO-Based*/
  800508:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80050b:	40                   	inc    %eax
  80050c:	89 c2                	mov    %eax,%edx
  80050e:	c1 ea 1f             	shr    $0x1f,%edx
  800511:	01 d0                	add    %edx,%eax
  800513:	d1 f8                	sar    %eax
  800515:	48                   	dec    %eax
  800516:	89 45 90             	mov    %eax,-0x70(%ebp)

	int correctMax = quicksortedArr[last];
  800519:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800523:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	89 45 8c             	mov    %eax,-0x74(%ebp)
	int correctMed = quicksortedArr[middle];
  80052d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800530:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800537:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	8b 00                	mov    (%eax),%eax
  80053e:	89 45 88             	mov    %eax,-0x78(%ebp)
	wait_semaphore(cons_mutex);
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  80054a:	e8 e2 41 00 00       	call   804731 <wait_semaphore>
  80054f:	83 c4 10             	add    $0x10,%esp
	{
		//cprintf("Array is correctly sorted\n");
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
  800552:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  80055d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800560:	8b 38                	mov    (%eax),%edi
  800562:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800565:	8b 30                	mov    (%eax),%esi
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8b 08                	mov    (%eax),%ecx
  80056c:	8b 58 04             	mov    0x4(%eax),%ebx
  80056f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800572:	8b 50 04             	mov    0x4(%eax),%edx
  800575:	8b 00                	mov    (%eax),%eax
  800577:	ff b5 44 ff ff ff    	pushl  -0xbc(%ebp)
  80057d:	57                   	push   %edi
  80057e:	56                   	push   %esi
  80057f:	53                   	push   %ebx
  800580:	51                   	push   %ecx
  800581:	52                   	push   %edx
  800582:	50                   	push   %eax
  800583:	68 08 4d 80 00       	push   $0x804d08
  800588:	e8 de 07 00 00       	call   800d6b <cprintf>
  80058d:	83 c4 20             	add    $0x20,%esp
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);
  800590:	8b 8d 48 ff ff ff    	mov    -0xb8(%ebp),%ecx
  800596:	8b 9d 4c ff ff ff    	mov    -0xb4(%ebp),%ebx
  80059c:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005a2:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  8005a8:	ff 75 88             	pushl  -0x78(%ebp)
  8005ab:	ff 75 8c             	pushl  -0x74(%ebp)
  8005ae:	ff 75 98             	pushl  -0x68(%ebp)
  8005b1:	53                   	push   %ebx
  8005b2:	51                   	push   %ecx
  8005b3:	52                   	push   %edx
  8005b4:	50                   	push   %eax
  8005b5:	68 08 4d 80 00       	push   $0x804d08
  8005ba:	e8 ac 07 00 00       	call   800d6b <cprintf>
  8005bf:	83 c4 20             	add    $0x20,%esp
	}
	signal_semaphore(cons_mutex);
  8005c2:	83 ec 0c             	sub    $0xc,%esp
  8005c5:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  8005cb:	e8 7b 41 00 00       	call   80474b <signal_semaphore>
  8005d0:	83 c4 10             	add    $0x10,%esp
	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  8005d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005d6:	8b 08                	mov    (%eax),%ecx
  8005d8:	8b 58 04             	mov    0x4(%eax),%ebx
  8005db:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005e1:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  8005e7:	89 de                	mov    %ebx,%esi
  8005e9:	31 d6                	xor    %edx,%esi
  8005eb:	31 c8                	xor    %ecx,%eax
  8005ed:	09 f0                	or     %esi,%eax
  8005ef:	85 c0                	test   %eax,%eax
  8005f1:	75 3e                	jne    800631 <_main+0x5f9>
  8005f3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005f6:	8b 08                	mov    (%eax),%ecx
  8005f8:	8b 58 04             	mov    0x4(%eax),%ebx
  8005fb:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800601:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800607:	89 de                	mov    %ebx,%esi
  800609:	31 d6                	xor    %edx,%esi
  80060b:	31 c8                	xor    %ecx,%eax
  80060d:	09 f0                	or     %esi,%eax
  80060f:	85 c0                	test   %eax,%eax
  800611:	75 1e                	jne    800631 <_main+0x5f9>
  800613:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	3b 45 98             	cmp    -0x68(%ebp),%eax
  80061b:	75 14                	jne    800631 <_main+0x5f9>
  80061d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	3b 45 8c             	cmp    -0x74(%ebp),%eax
  800625:	75 0a                	jne    800631 <_main+0x5f9>
  800627:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	3b 45 88             	cmp    -0x78(%ebp),%eax
  80062f:	74 17                	je     800648 <_main+0x610>
		panic("The array STATS are NOT calculated correctly") ;
  800631:	83 ec 04             	sub    $0x4,%esp
  800634:	68 40 4d 80 00       	push   $0x804d40
  800639:	68 8d 00 00 00       	push   $0x8d
  80063e:	68 90 4b 80 00       	push   $0x804b90
  800643:	e8 55 04 00 00       	call   800a9d <_panic>

	cprintf("Congratulations!! Scenario of Using the Semaphores & Shared Variables completed successfully!!\n\n\n");
  800648:	83 ec 0c             	sub    $0xc,%esp
  80064b:	68 70 4d 80 00       	push   $0x804d70
  800650:	e8 16 07 00 00       	call   800d6b <cprintf>
  800655:	83 c4 10             	add    $0x10,%esp

	return;
  800658:	90                   	nop
}
  800659:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80065c:	5b                   	pop    %ebx
  80065d:	5e                   	pop    %esi
  80065e:	5f                   	pop    %edi
  80065f:	5d                   	pop    %ebp
  800660:	c3                   	ret    

00800661 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800661:	55                   	push   %ebp
  800662:	89 e5                	mov    %esp,%ebp
  800664:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800667:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80066e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800675:	eb 33                	jmp    8006aa <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800677:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 d0                	add    %edx,%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80068b:	40                   	inc    %eax
  80068c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	01 c8                	add    %ecx,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	39 c2                	cmp    %eax,%edx
  80069c:	7e 09                	jle    8006a7 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80069e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8006a5:	eb 0c                	jmp    8006b3 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8006a7:	ff 45 f8             	incl   -0x8(%ebp)
  8006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ad:	48                   	dec    %eax
  8006ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8006b1:	7f c4                	jg     800677 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8006b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8006b6:	c9                   	leave  
  8006b7:	c3                   	ret    

008006b8 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8006b8:	55                   	push   %ebp
  8006b9:	89 e5                	mov    %esp,%ebp
  8006bb:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006c5:	eb 17                	jmp    8006de <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	01 c2                	add    %eax,%edx
  8006d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d9:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006db:	ff 45 fc             	incl   -0x4(%ebp)
  8006de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006e4:	7c e1                	jl     8006c7 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006e6:	90                   	nop
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006f6:	eb 1b                	jmp    800713 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	01 c2                	add    %eax,%edx
  800707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070a:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80070d:	48                   	dec    %eax
  80070e:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800710:	ff 45 fc             	incl   -0x4(%ebp)
  800713:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800716:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800719:	7c dd                	jl     8006f8 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800724:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800727:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80072c:	f7 e9                	imul   %ecx
  80072e:	c1 f9 1f             	sar    $0x1f,%ecx
  800731:	89 d0                	mov    %edx,%eax
  800733:	29 c8                	sub    %ecx,%eax
  800735:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800738:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80073f:	eb 1e                	jmp    80075f <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800751:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800754:	99                   	cltd   
  800755:	f7 7d f8             	idivl  -0x8(%ebp)
  800758:	89 d0                	mov    %edx,%eax
  80075a:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80075c:	ff 45 fc             	incl   -0x4(%ebp)
  80075f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800762:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800765:	7c da                	jl     800741 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  800767:	90                   	nop
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	57                   	push   %edi
  80076e:	56                   	push   %esi
  80076f:	53                   	push   %ebx
  800770:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  800773:	8b 45 10             	mov    0x10(%ebp),%eax
  800776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80077c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800783:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80078a:	eb 29                	jmp    8007b5 <ArrayStats+0x4b>
	{
		*mean += Elements[i];
  80078c:	8b 45 10             	mov    0x10(%ebp),%eax
  80078f:	8b 08                	mov    (%eax),%ecx
  800791:	8b 58 04             	mov    0x4(%eax),%ebx
  800794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800797:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	01 d0                	add    %edx,%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	99                   	cltd   
  8007a6:	01 c8                	add    %ecx,%eax
  8007a8:	11 da                	adc    %ebx,%edx
  8007aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007ad:	89 01                	mov    %eax,(%ecx)
  8007af:	89 51 04             	mov    %edx,0x4(%ecx)

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007b2:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8007bb:	7c cf                	jl     80078c <ArrayStats+0x22>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  8007bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c0:	8b 50 04             	mov    0x4(%eax),%edx
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c8:	89 cb                	mov    %ecx,%ebx
  8007ca:	c1 fb 1f             	sar    $0x1f,%ebx
  8007cd:	53                   	push   %ebx
  8007ce:	51                   	push   %ecx
  8007cf:	52                   	push   %edx
  8007d0:	50                   	push   %eax
  8007d1:	e8 9a 3f 00 00       	call   804770 <__divdi3>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007dc:	89 01                	mov    %eax,(%ecx)
  8007de:	89 51 04             	mov    %edx,0x4(%ecx)
	*var = 0;
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8007ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  8007f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007f8:	eb 7e                	jmp    800878 <ArrayStats+0x10e>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 50 04             	mov    0x4(%eax),%edx
  800800:	8b 00                	mov    (%eax),%eax
  800802:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800805:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80080b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	01 d0                	add    %edx,%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	89 c1                	mov    %eax,%ecx
  80081b:	89 c3                	mov    %eax,%ebx
  80081d:	c1 fb 1f             	sar    $0x1f,%ebx
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	8b 50 04             	mov    0x4(%eax),%edx
  800826:	8b 00                	mov    (%eax),%eax
  800828:	29 c1                	sub    %eax,%ecx
  80082a:	19 d3                	sbb    %edx,%ebx
  80082c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80082f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 c6                	mov    %eax,%esi
  80083f:	89 c7                	mov    %eax,%edi
  800841:	c1 ff 1f             	sar    $0x1f,%edi
  800844:	8b 45 10             	mov    0x10(%ebp),%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	29 c6                	sub    %eax,%esi
  80084e:	19 d7                	sbb    %edx,%edi
  800850:	89 f0                	mov    %esi,%eax
  800852:	89 fa                	mov    %edi,%edx
  800854:	89 df                	mov    %ebx,%edi
  800856:	0f af f8             	imul   %eax,%edi
  800859:	89 d6                	mov    %edx,%esi
  80085b:	0f af f1             	imul   %ecx,%esi
  80085e:	01 fe                	add    %edi,%esi
  800860:	f7 e1                	mul    %ecx
  800862:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  800865:	89 ca                	mov    %ecx,%edx
  800867:	03 45 d0             	add    -0x30(%ebp),%eax
  80086a:	13 55 d4             	adc    -0x2c(%ebp),%edx
  80086d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800870:	89 01                	mov    %eax,(%ecx)
  800872:	89 51 04             	mov    %edx,0x4(%ecx)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  800875:	ff 45 e4             	incl   -0x1c(%ebp)
  800878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80087b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80087e:	0f 8c 76 ff ff ff    	jl     8007fa <ArrayStats+0x90>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
//		if (i%1000 == 0)
//			cprintf("current #elements = %d, current var = %lld\n", i , *var);
	}
	*var /= NumOfElements;
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8b 50 04             	mov    0x4(%eax),%edx
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088f:	89 cb                	mov    %ecx,%ebx
  800891:	c1 fb 1f             	sar    $0x1f,%ebx
  800894:	53                   	push   %ebx
  800895:	51                   	push   %ecx
  800896:	52                   	push   %edx
  800897:	50                   	push   %eax
  800898:	e8 d3 3e 00 00       	call   804770 <__divdi3>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008a3:	89 01                	mov    %eax,(%ecx)
  8008a5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8008a8:	90                   	nop
  8008a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ac:	5b                   	pop    %ebx
  8008ad:	5e                   	pop    %esi
  8008ae:	5f                   	pop    %edi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8008bd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8008c1:	83 ec 0c             	sub    $0xc,%esp
  8008c4:	50                   	push   %eax
  8008c5:	e8 ab 2f 00 00       	call   803875 <sys_cputc>
  8008ca:	83 c4 10             	add    $0x10,%esp
}
  8008cd:	90                   	nop
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <getchar>:


int
getchar(void)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8008d6:	e8 39 2e 00 00       	call   803714 <sys_cgetc>
  8008db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8008de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <iscons>:

int iscons(int fdnum)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8008e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	57                   	push   %edi
  8008f1:	56                   	push   %esi
  8008f2:	53                   	push   %ebx
  8008f3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8008f6:	e8 ab 30 00 00       	call   8039a6 <sys_getenvindex>
  8008fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8008fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800901:	89 d0                	mov    %edx,%eax
  800903:	c1 e0 03             	shl    $0x3,%eax
  800906:	01 d0                	add    %edx,%eax
  800908:	c1 e0 02             	shl    $0x2,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800914:	01 d0                	add    %edx,%eax
  800916:	c1 e0 03             	shl    $0x3,%eax
  800919:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80091e:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800923:	a1 20 60 80 00       	mov    0x806020,%eax
  800928:	8a 40 20             	mov    0x20(%eax),%al
  80092b:	84 c0                	test   %al,%al
  80092d:	74 0d                	je     80093c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80092f:	a1 20 60 80 00       	mov    0x806020,%eax
  800934:	83 c0 20             	add    $0x20,%eax
  800937:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800940:	7e 0a                	jle    80094c <libmain+0x5f>
		binaryname = argv[0];
  800942:	8b 45 0c             	mov    0xc(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	ff 75 08             	pushl  0x8(%ebp)
  800955:	e8 de f6 ff ff       	call   800038 <_main>
  80095a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80095d:	a1 00 60 80 00       	mov    0x806000,%eax
  800962:	85 c0                	test   %eax,%eax
  800964:	0f 84 01 01 00 00    	je     800a6b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80096a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800970:	bb cc 4e 80 00       	mov    $0x804ecc,%ebx
  800975:	ba 0e 00 00 00       	mov    $0xe,%edx
  80097a:	89 c7                	mov    %eax,%edi
  80097c:	89 de                	mov    %ebx,%esi
  80097e:	89 d1                	mov    %edx,%ecx
  800980:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800982:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800985:	b9 56 00 00 00       	mov    $0x56,%ecx
  80098a:	b0 00                	mov    $0x0,%al
  80098c:	89 d7                	mov    %edx,%edi
  80098e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800990:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800997:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	50                   	push   %eax
  80099e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8009a4:	50                   	push   %eax
  8009a5:	e8 32 32 00 00       	call   803bdc <sys_utilities>
  8009aa:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8009ad:	e8 7b 2d 00 00       	call   80372d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8009b2:	83 ec 0c             	sub    $0xc,%esp
  8009b5:	68 ec 4d 80 00       	push   $0x804dec
  8009ba:	e8 ac 03 00 00       	call   800d6b <cprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8009c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	74 18                	je     8009e1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8009c9:	e8 2c 32 00 00       	call   803bfa <sys_get_optimal_num_faults>
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	50                   	push   %eax
  8009d2:	68 14 4e 80 00       	push   $0x804e14
  8009d7:	e8 8f 03 00 00       	call   800d6b <cprintf>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	eb 59                	jmp    800a3a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009e1:	a1 20 60 80 00       	mov    0x806020,%eax
  8009e6:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8009ec:	a1 20 60 80 00       	mov    0x806020,%eax
  8009f1:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8009f7:	83 ec 04             	sub    $0x4,%esp
  8009fa:	52                   	push   %edx
  8009fb:	50                   	push   %eax
  8009fc:	68 38 4e 80 00       	push   $0x804e38
  800a01:	e8 65 03 00 00       	call   800d6b <cprintf>
  800a06:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a09:	a1 20 60 80 00       	mov    0x806020,%eax
  800a0e:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800a14:	a1 20 60 80 00       	mov    0x806020,%eax
  800a19:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800a1f:	a1 20 60 80 00       	mov    0x806020,%eax
  800a24:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800a2a:	51                   	push   %ecx
  800a2b:	52                   	push   %edx
  800a2c:	50                   	push   %eax
  800a2d:	68 60 4e 80 00       	push   $0x804e60
  800a32:	e8 34 03 00 00       	call   800d6b <cprintf>
  800a37:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a3a:	a1 20 60 80 00       	mov    0x806020,%eax
  800a3f:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	50                   	push   %eax
  800a49:	68 b8 4e 80 00       	push   $0x804eb8
  800a4e:	e8 18 03 00 00       	call   800d6b <cprintf>
  800a53:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	68 ec 4d 80 00       	push   $0x804dec
  800a5e:	e8 08 03 00 00       	call   800d6b <cprintf>
  800a63:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800a66:	e8 dc 2c 00 00       	call   803747 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800a6b:	e8 1f 00 00 00       	call   800a8f <exit>
}
  800a70:	90                   	nop
  800a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a74:	5b                   	pop    %ebx
  800a75:	5e                   	pop    %esi
  800a76:	5f                   	pop    %edi
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	6a 00                	push   $0x0
  800a84:	e8 e9 2e 00 00       	call   803972 <sys_destroy_env>
  800a89:	83 c4 10             	add    $0x10,%esp
}
  800a8c:	90                   	nop
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <exit>:

void
exit(void)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a95:	e8 3e 2f 00 00       	call   8039d8 <sys_exit_env>
}
  800a9a:	90                   	nop
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800aa3:	8d 45 10             	lea    0x10(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800aac:	a1 38 61 83 00       	mov    0x836138,%eax
  800ab1:	85 c0                	test   %eax,%eax
  800ab3:	74 16                	je     800acb <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ab5:	a1 38 61 83 00       	mov    0x836138,%eax
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	50                   	push   %eax
  800abe:	68 30 4f 80 00       	push   $0x804f30
  800ac3:	e8 a3 02 00 00       	call   800d6b <cprintf>
  800ac8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800acb:	a1 04 60 80 00       	mov    0x806004,%eax
  800ad0:	83 ec 0c             	sub    $0xc,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	ff 75 08             	pushl  0x8(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	68 38 4f 80 00       	push   $0x804f38
  800adf:	6a 74                	push   $0x74
  800ae1:	e8 b2 02 00 00       	call   800d98 <cprintf_colored>
  800ae6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 f4             	pushl  -0xc(%ebp)
  800af2:	50                   	push   %eax
  800af3:	e8 04 02 00 00       	call   800cfc <vcprintf>
  800af8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	6a 00                	push   $0x0
  800b00:	68 60 4f 80 00       	push   $0x804f60
  800b05:	e8 f2 01 00 00       	call   800cfc <vcprintf>
  800b0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b0d:	e8 7d ff ff ff       	call   800a8f <exit>

	// should not return here
	while (1) ;
  800b12:	eb fe                	jmp    800b12 <_panic+0x75>

00800b14 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b1a:	a1 20 60 80 00       	mov    0x806020,%eax
  800b1f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	39 c2                	cmp    %eax,%edx
  800b2a:	74 14                	je     800b40 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	68 64 4f 80 00       	push   $0x804f64
  800b34:	6a 26                	push   $0x26
  800b36:	68 b0 4f 80 00       	push   $0x804fb0
  800b3b:	e8 5d ff ff ff       	call   800a9d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b47:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b4e:	e9 c5 00 00 00       	jmp    800c18 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	01 d0                	add    %edx,%eax
  800b62:	8b 00                	mov    (%eax),%eax
  800b64:	85 c0                	test   %eax,%eax
  800b66:	75 08                	jne    800b70 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800b68:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b6b:	e9 a5 00 00 00       	jmp    800c15 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800b70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b77:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b7e:	eb 69                	jmp    800be9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b80:	a1 20 60 80 00       	mov    0x806020,%eax
  800b85:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800b8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b8e:	89 d0                	mov    %edx,%eax
  800b90:	01 c0                	add    %eax,%eax
  800b92:	01 d0                	add    %edx,%eax
  800b94:	c1 e0 03             	shl    $0x3,%eax
  800b97:	01 c8                	add    %ecx,%eax
  800b99:	8a 40 04             	mov    0x4(%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 46                	jne    800be6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ba0:	a1 20 60 80 00       	mov    0x806020,%eax
  800ba5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800bab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bae:	89 d0                	mov    %edx,%eax
  800bb0:	01 c0                	add    %eax,%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	c1 e0 03             	shl    $0x3,%eax
  800bb7:	01 c8                	add    %ecx,%eax
  800bb9:	8b 00                	mov    (%eax),%eax
  800bbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	01 c8                	add    %ecx,%eax
  800bd7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	75 09                	jne    800be6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800bdd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800be4:	eb 15                	jmp    800bfb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800be6:	ff 45 e8             	incl   -0x18(%ebp)
  800be9:	a1 20 60 80 00       	mov    0x806020,%eax
  800bee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800bf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bf7:	39 c2                	cmp    %eax,%edx
  800bf9:	77 85                	ja     800b80 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800bfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bff:	75 14                	jne    800c15 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800c01:	83 ec 04             	sub    $0x4,%esp
  800c04:	68 bc 4f 80 00       	push   $0x804fbc
  800c09:	6a 3a                	push   $0x3a
  800c0b:	68 b0 4f 80 00       	push   $0x804fb0
  800c10:	e8 88 fe ff ff       	call   800a9d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c15:	ff 45 f0             	incl   -0x10(%ebp)
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c1e:	0f 8c 2f ff ff ff    	jl     800b53 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c32:	eb 26                	jmp    800c5a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c34:	a1 20 60 80 00       	mov    0x806020,%eax
  800c39:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800c3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c42:	89 d0                	mov    %edx,%eax
  800c44:	01 c0                	add    %eax,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	c1 e0 03             	shl    $0x3,%eax
  800c4b:	01 c8                	add    %ecx,%eax
  800c4d:	8a 40 04             	mov    0x4(%eax),%al
  800c50:	3c 01                	cmp    $0x1,%al
  800c52:	75 03                	jne    800c57 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800c54:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c57:	ff 45 e0             	incl   -0x20(%ebp)
  800c5a:	a1 20 60 80 00       	mov    0x806020,%eax
  800c5f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c68:	39 c2                	cmp    %eax,%edx
  800c6a:	77 c8                	ja     800c34 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c6f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c72:	74 14                	je     800c88 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c74:	83 ec 04             	sub    $0x4,%esp
  800c77:	68 10 50 80 00       	push   $0x805010
  800c7c:	6a 44                	push   $0x44
  800c7e:	68 b0 4f 80 00       	push   $0x804fb0
  800c83:	e8 15 fe ff ff       	call   800a9d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c88:	90                   	nop
  800c89:	c9                   	leave  
  800c8a:	c3                   	ret    

00800c8b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	53                   	push   %ebx
  800c8f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9d:	89 0a                	mov    %ecx,(%edx)
  800c9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca2:	88 d1                	mov    %dl,%cl
  800ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cb5:	75 30                	jne    800ce7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800cb7:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800cbd:	a0 64 e0 81 00       	mov    0x81e064,%al
  800cc2:	0f b6 c0             	movzbl %al,%eax
  800cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc8:	8b 09                	mov    (%ecx),%ecx
  800cca:	89 cb                	mov    %ecx,%ebx
  800ccc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccf:	83 c1 08             	add    $0x8,%ecx
  800cd2:	52                   	push   %edx
  800cd3:	50                   	push   %eax
  800cd4:	53                   	push   %ebx
  800cd5:	51                   	push   %ecx
  800cd6:	e8 0e 2a 00 00       	call   8036e9 <sys_cputs>
  800cdb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cea:	8b 40 04             	mov    0x4(%eax),%eax
  800ced:	8d 50 01             	lea    0x1(%eax),%edx
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cf6:	90                   	nop
  800cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d05:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0c:	00 00 00 
	b.cnt = 0;
  800d0f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d16:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d19:	ff 75 0c             	pushl  0xc(%ebp)
  800d1c:	ff 75 08             	pushl  0x8(%ebp)
  800d1f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d25:	50                   	push   %eax
  800d26:	68 8b 0c 80 00       	push   $0x800c8b
  800d2b:	e8 5a 02 00 00       	call   800f8a <vprintfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800d33:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800d39:	a0 64 e0 81 00       	mov    0x81e064,%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800d47:	52                   	push   %edx
  800d48:	50                   	push   %eax
  800d49:	51                   	push   %ecx
  800d4a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d50:	83 c0 08             	add    $0x8,%eax
  800d53:	50                   	push   %eax
  800d54:	e8 90 29 00 00       	call   8036e9 <sys_cputs>
  800d59:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5c:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800d63:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d71:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800d78:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 f4             	pushl  -0xc(%ebp)
  800d87:	50                   	push   %eax
  800d88:	e8 6f ff ff ff       	call   800cfc <vcprintf>
  800d8d:	83 c4 10             	add    $0x10,%esp
  800d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d9e:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	c1 e0 08             	shl    $0x8,%eax
  800dab:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800db0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800db3:	83 c0 04             	add    $0x4,%eax
  800db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	83 ec 08             	sub    $0x8,%esp
  800dbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc2:	50                   	push   %eax
  800dc3:	e8 34 ff ff ff       	call   800cfc <vcprintf>
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800dce:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800dd5:	07 00 00 

	return cnt;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800de3:	e8 45 29 00 00       	call   80372d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800de8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 f4             	pushl  -0xc(%ebp)
  800df7:	50                   	push   %eax
  800df8:	e8 ff fe ff ff       	call   800cfc <vcprintf>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800e03:	e8 3f 29 00 00       	call   803747 <sys_unlock_cons>
	return cnt;
  800e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	53                   	push   %ebx
  800e11:	83 ec 14             	sub    $0x14,%esp
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e20:	8b 45 18             	mov    0x18(%ebp),%eax
  800e23:	ba 00 00 00 00       	mov    $0x0,%edx
  800e28:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e2b:	77 55                	ja     800e82 <printnum+0x75>
  800e2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e30:	72 05                	jb     800e37 <printnum+0x2a>
  800e32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e35:	77 4b                	ja     800e82 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e37:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e3a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e3d:	8b 45 18             	mov    0x18(%ebp),%eax
  800e40:	ba 00 00 00 00       	mov    $0x0,%edx
  800e45:	52                   	push   %edx
  800e46:	50                   	push   %eax
  800e47:	ff 75 f4             	pushl  -0xc(%ebp)
  800e4a:	ff 75 f0             	pushl  -0x10(%ebp)
  800e4d:	e8 86 3a 00 00       	call   8048d8 <__udivdi3>
  800e52:	83 c4 10             	add    $0x10,%esp
  800e55:	83 ec 04             	sub    $0x4,%esp
  800e58:	ff 75 20             	pushl  0x20(%ebp)
  800e5b:	53                   	push   %ebx
  800e5c:	ff 75 18             	pushl  0x18(%ebp)
  800e5f:	52                   	push   %edx
  800e60:	50                   	push   %eax
  800e61:	ff 75 0c             	pushl  0xc(%ebp)
  800e64:	ff 75 08             	pushl  0x8(%ebp)
  800e67:	e8 a1 ff ff ff       	call   800e0d <printnum>
  800e6c:	83 c4 20             	add    $0x20,%esp
  800e6f:	eb 1a                	jmp    800e8b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e71:	83 ec 08             	sub    $0x8,%esp
  800e74:	ff 75 0c             	pushl  0xc(%ebp)
  800e77:	ff 75 20             	pushl  0x20(%ebp)
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	ff d0                	call   *%eax
  800e7f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e82:	ff 4d 1c             	decl   0x1c(%ebp)
  800e85:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e89:	7f e6                	jg     800e71 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e8b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e99:	53                   	push   %ebx
  800e9a:	51                   	push   %ecx
  800e9b:	52                   	push   %edx
  800e9c:	50                   	push   %eax
  800e9d:	e8 46 3b 00 00       	call   8049e8 <__umoddi3>
  800ea2:	83 c4 10             	add    $0x10,%esp
  800ea5:	05 74 52 80 00       	add    $0x805274,%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f be c0             	movsbl %al,%eax
  800eaf:	83 ec 08             	sub    $0x8,%esp
  800eb2:	ff 75 0c             	pushl  0xc(%ebp)
  800eb5:	50                   	push   %eax
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	ff d0                	call   *%eax
  800ebb:	83 c4 10             	add    $0x10,%esp
}
  800ebe:	90                   	nop
  800ebf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ec7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ecb:	7e 1c                	jle    800ee9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8b 00                	mov    (%eax),%eax
  800ed2:	8d 50 08             	lea    0x8(%eax),%edx
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 10                	mov    %edx,(%eax)
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8b 00                	mov    (%eax),%eax
  800edf:	83 e8 08             	sub    $0x8,%eax
  800ee2:	8b 50 04             	mov    0x4(%eax),%edx
  800ee5:	8b 00                	mov    (%eax),%eax
  800ee7:	eb 40                	jmp    800f29 <getuint+0x65>
	else if (lflag)
  800ee9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eed:	74 1e                	je     800f0d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8b 00                	mov    (%eax),%eax
  800ef4:	8d 50 04             	lea    0x4(%eax),%edx
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	89 10                	mov    %edx,(%eax)
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8b 00                	mov    (%eax),%eax
  800f01:	83 e8 04             	sub    $0x4,%eax
  800f04:	8b 00                	mov    (%eax),%eax
  800f06:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0b:	eb 1c                	jmp    800f29 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8b 00                	mov    (%eax),%eax
  800f12:	8d 50 04             	lea    0x4(%eax),%edx
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	89 10                	mov    %edx,(%eax)
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8b 00                	mov    (%eax),%eax
  800f1f:	83 e8 04             	sub    $0x4,%eax
  800f22:	8b 00                	mov    (%eax),%eax
  800f24:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f2e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f32:	7e 1c                	jle    800f50 <getint+0x25>
		return va_arg(*ap, long long);
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8b 00                	mov    (%eax),%eax
  800f39:	8d 50 08             	lea    0x8(%eax),%edx
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	89 10                	mov    %edx,(%eax)
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8b 00                	mov    (%eax),%eax
  800f46:	83 e8 08             	sub    $0x8,%eax
  800f49:	8b 50 04             	mov    0x4(%eax),%edx
  800f4c:	8b 00                	mov    (%eax),%eax
  800f4e:	eb 38                	jmp    800f88 <getint+0x5d>
	else if (lflag)
  800f50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f54:	74 1a                	je     800f70 <getint+0x45>
		return va_arg(*ap, long);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8b 00                	mov    (%eax),%eax
  800f5b:	8d 50 04             	lea    0x4(%eax),%edx
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	89 10                	mov    %edx,(%eax)
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8b 00                	mov    (%eax),%eax
  800f68:	83 e8 04             	sub    $0x4,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	99                   	cltd   
  800f6e:	eb 18                	jmp    800f88 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8b 00                	mov    (%eax),%eax
  800f75:	8d 50 04             	lea    0x4(%eax),%edx
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	89 10                	mov    %edx,(%eax)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8b 00                	mov    (%eax),%eax
  800f82:	83 e8 04             	sub    $0x4,%eax
  800f85:	8b 00                	mov    (%eax),%eax
  800f87:	99                   	cltd   
}
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f92:	eb 17                	jmp    800fab <vprintfmt+0x21>
			if (ch == '\0')
  800f94:	85 db                	test   %ebx,%ebx
  800f96:	0f 84 c1 03 00 00    	je     80135d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	ff 75 0c             	pushl  0xc(%ebp)
  800fa2:	53                   	push   %ebx
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	8d 50 01             	lea    0x1(%eax),%edx
  800fb1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	0f b6 d8             	movzbl %al,%ebx
  800fb9:	83 fb 25             	cmp    $0x25,%ebx
  800fbc:	75 d6                	jne    800f94 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800fbe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800fc2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800fc9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800fd0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800fd7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	8d 50 01             	lea    0x1(%eax),%edx
  800fe4:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f b6 d8             	movzbl %al,%ebx
  800fec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fef:	83 f8 5b             	cmp    $0x5b,%eax
  800ff2:	0f 87 3d 03 00 00    	ja     801335 <vprintfmt+0x3ab>
  800ff8:	8b 04 85 98 52 80 00 	mov    0x805298(,%eax,4),%eax
  800fff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801001:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801005:	eb d7                	jmp    800fde <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801007:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80100b:	eb d1                	jmp    800fde <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80100d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801014:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801017:	89 d0                	mov    %edx,%eax
  801019:	c1 e0 02             	shl    $0x2,%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	01 c0                	add    %eax,%eax
  801020:	01 d8                	add    %ebx,%eax
  801022:	83 e8 30             	sub    $0x30,%eax
  801025:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801028:	8b 45 10             	mov    0x10(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801030:	83 fb 2f             	cmp    $0x2f,%ebx
  801033:	7e 3e                	jle    801073 <vprintfmt+0xe9>
  801035:	83 fb 39             	cmp    $0x39,%ebx
  801038:	7f 39                	jg     801073 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80103a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80103d:	eb d5                	jmp    801014 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80103f:	8b 45 14             	mov    0x14(%ebp),%eax
  801042:	83 c0 04             	add    $0x4,%eax
  801045:	89 45 14             	mov    %eax,0x14(%ebp)
  801048:	8b 45 14             	mov    0x14(%ebp),%eax
  80104b:	83 e8 04             	sub    $0x4,%eax
  80104e:	8b 00                	mov    (%eax),%eax
  801050:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801053:	eb 1f                	jmp    801074 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801055:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801059:	79 83                	jns    800fde <vprintfmt+0x54>
				width = 0;
  80105b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801062:	e9 77 ff ff ff       	jmp    800fde <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801067:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80106e:	e9 6b ff ff ff       	jmp    800fde <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801073:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801074:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801078:	0f 89 60 ff ff ff    	jns    800fde <vprintfmt+0x54>
				width = precision, precision = -1;
  80107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801081:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801084:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80108b:	e9 4e ff ff ff       	jmp    800fde <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801090:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801093:	e9 46 ff ff ff       	jmp    800fde <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801098:	8b 45 14             	mov    0x14(%ebp),%eax
  80109b:	83 c0 04             	add    $0x4,%eax
  80109e:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 e8 04             	sub    $0x4,%eax
  8010a7:	8b 00                	mov    (%eax),%eax
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 0c             	pushl  0xc(%ebp)
  8010af:	50                   	push   %eax
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
			break;
  8010b8:	e9 9b 02 00 00       	jmp    801358 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8010bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c0:	83 c0 04             	add    $0x4,%eax
  8010c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c9:	83 e8 04             	sub    $0x4,%eax
  8010cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8010ce:	85 db                	test   %ebx,%ebx
  8010d0:	79 02                	jns    8010d4 <vprintfmt+0x14a>
				err = -err;
  8010d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8010d4:	83 fb 64             	cmp    $0x64,%ebx
  8010d7:	7f 0b                	jg     8010e4 <vprintfmt+0x15a>
  8010d9:	8b 34 9d e0 50 80 00 	mov    0x8050e0(,%ebx,4),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 19                	jne    8010fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8010e4:	53                   	push   %ebx
  8010e5:	68 85 52 80 00       	push   $0x805285
  8010ea:	ff 75 0c             	pushl  0xc(%ebp)
  8010ed:	ff 75 08             	pushl  0x8(%ebp)
  8010f0:	e8 70 02 00 00       	call   801365 <printfmt>
  8010f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010f8:	e9 5b 02 00 00       	jmp    801358 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010fd:	56                   	push   %esi
  8010fe:	68 8e 52 80 00       	push   $0x80528e
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	ff 75 08             	pushl  0x8(%ebp)
  801109:	e8 57 02 00 00       	call   801365 <printfmt>
  80110e:	83 c4 10             	add    $0x10,%esp
			break;
  801111:	e9 42 02 00 00       	jmp    801358 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801116:	8b 45 14             	mov    0x14(%ebp),%eax
  801119:	83 c0 04             	add    $0x4,%eax
  80111c:	89 45 14             	mov    %eax,0x14(%ebp)
  80111f:	8b 45 14             	mov    0x14(%ebp),%eax
  801122:	83 e8 04             	sub    $0x4,%eax
  801125:	8b 30                	mov    (%eax),%esi
  801127:	85 f6                	test   %esi,%esi
  801129:	75 05                	jne    801130 <vprintfmt+0x1a6>
				p = "(null)";
  80112b:	be 91 52 80 00       	mov    $0x805291,%esi
			if (width > 0 && padc != '-')
  801130:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801134:	7e 6d                	jle    8011a3 <vprintfmt+0x219>
  801136:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80113a:	74 67                	je     8011a3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80113c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80113f:	83 ec 08             	sub    $0x8,%esp
  801142:	50                   	push   %eax
  801143:	56                   	push   %esi
  801144:	e8 26 05 00 00       	call   80166f <strnlen>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80114f:	eb 16                	jmp    801167 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801151:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801155:	83 ec 08             	sub    $0x8,%esp
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	50                   	push   %eax
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	ff d0                	call   *%eax
  801161:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801164:	ff 4d e4             	decl   -0x1c(%ebp)
  801167:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80116b:	7f e4                	jg     801151 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80116d:	eb 34                	jmp    8011a3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80116f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801173:	74 1c                	je     801191 <vprintfmt+0x207>
  801175:	83 fb 1f             	cmp    $0x1f,%ebx
  801178:	7e 05                	jle    80117f <vprintfmt+0x1f5>
  80117a:	83 fb 7e             	cmp    $0x7e,%ebx
  80117d:	7e 12                	jle    801191 <vprintfmt+0x207>
					putch('?', putdat);
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	ff 75 0c             	pushl  0xc(%ebp)
  801185:	6a 3f                	push   $0x3f
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	ff d0                	call   *%eax
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	eb 0f                	jmp    8011a0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801191:	83 ec 08             	sub    $0x8,%esp
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	53                   	push   %ebx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011a0:	ff 4d e4             	decl   -0x1c(%ebp)
  8011a3:	89 f0                	mov    %esi,%eax
  8011a5:	8d 70 01             	lea    0x1(%eax),%esi
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	0f be d8             	movsbl %al,%ebx
  8011ad:	85 db                	test   %ebx,%ebx
  8011af:	74 24                	je     8011d5 <vprintfmt+0x24b>
  8011b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011b5:	78 b8                	js     80116f <vprintfmt+0x1e5>
  8011b7:	ff 4d e0             	decl   -0x20(%ebp)
  8011ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011be:	79 af                	jns    80116f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011c0:	eb 13                	jmp    8011d5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8011c2:	83 ec 08             	sub    $0x8,%esp
  8011c5:	ff 75 0c             	pushl  0xc(%ebp)
  8011c8:	6a 20                	push   $0x20
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	ff d0                	call   *%eax
  8011cf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8011d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011d9:	7f e7                	jg     8011c2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8011db:	e9 78 01 00 00       	jmp    801358 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8011e0:	83 ec 08             	sub    $0x8,%esp
  8011e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8011e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8011e9:	50                   	push   %eax
  8011ea:	e8 3c fd ff ff       	call   800f2b <getint>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fe:	85 d2                	test   %edx,%edx
  801200:	79 23                	jns    801225 <vprintfmt+0x29b>
				putch('-', putdat);
  801202:	83 ec 08             	sub    $0x8,%esp
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	6a 2d                	push   $0x2d
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	ff d0                	call   *%eax
  80120f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	f7 d8                	neg    %eax
  80121a:	83 d2 00             	adc    $0x0,%edx
  80121d:	f7 da                	neg    %edx
  80121f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801222:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801225:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80122c:	e9 bc 00 00 00       	jmp    8012ed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801231:	83 ec 08             	sub    $0x8,%esp
  801234:	ff 75 e8             	pushl  -0x18(%ebp)
  801237:	8d 45 14             	lea    0x14(%ebp),%eax
  80123a:	50                   	push   %eax
  80123b:	e8 84 fc ff ff       	call   800ec4 <getuint>
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801246:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801249:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801250:	e9 98 00 00 00       	jmp    8012ed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801255:	83 ec 08             	sub    $0x8,%esp
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	6a 58                	push   $0x58
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	ff d0                	call   *%eax
  801262:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801265:	83 ec 08             	sub    $0x8,%esp
  801268:	ff 75 0c             	pushl  0xc(%ebp)
  80126b:	6a 58                	push   $0x58
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	ff d0                	call   *%eax
  801272:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	6a 58                	push   $0x58
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	ff d0                	call   *%eax
  801282:	83 c4 10             	add    $0x10,%esp
			break;
  801285:	e9 ce 00 00 00       	jmp    801358 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	6a 30                	push   $0x30
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	ff d0                	call   *%eax
  801297:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	6a 78                	push   $0x78
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	ff d0                	call   *%eax
  8012a7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 c0 04             	add    $0x4,%eax
  8012b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8012b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b6:	83 e8 04             	sub    $0x4,%eax
  8012b9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8012bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8012c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8012cc:	eb 1f                	jmp    8012ed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8012ce:	83 ec 08             	sub    $0x8,%esp
  8012d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8012d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	e8 e7 fb ff ff       	call   800ec4 <getuint>
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8012e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012ed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012f4:	83 ec 04             	sub    $0x4,%esp
  8012f7:	52                   	push   %edx
  8012f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012fb:	50                   	push   %eax
  8012fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	ff 75 08             	pushl  0x8(%ebp)
  801308:	e8 00 fb ff ff       	call   800e0d <printnum>
  80130d:	83 c4 20             	add    $0x20,%esp
			break;
  801310:	eb 46                	jmp    801358 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	53                   	push   %ebx
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	ff d0                	call   *%eax
  80131e:	83 c4 10             	add    $0x10,%esp
			break;
  801321:	eb 35                	jmp    801358 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801323:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  80132a:	eb 2c                	jmp    801358 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80132c:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  801333:	eb 23                	jmp    801358 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	6a 25                	push   $0x25
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	ff d0                	call   *%eax
  801342:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801345:	ff 4d 10             	decl   0x10(%ebp)
  801348:	eb 03                	jmp    80134d <vprintfmt+0x3c3>
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	48                   	dec    %eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	3c 25                	cmp    $0x25,%al
  801355:	75 f3                	jne    80134a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801357:	90                   	nop
		}
	}
  801358:	e9 35 fc ff ff       	jmp    800f92 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80135d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80135e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801361:	5b                   	pop    %ebx
  801362:	5e                   	pop    %esi
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    

00801365 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80136b:	8d 45 10             	lea    0x10(%ebp),%eax
  80136e:	83 c0 04             	add    $0x4,%eax
  801371:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	ff 75 f4             	pushl  -0xc(%ebp)
  80137a:	50                   	push   %eax
  80137b:	ff 75 0c             	pushl  0xc(%ebp)
  80137e:	ff 75 08             	pushl  0x8(%ebp)
  801381:	e8 04 fc ff ff       	call   800f8a <vprintfmt>
  801386:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801389:	90                   	nop
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8b 40 08             	mov    0x8(%eax),%eax
  801395:	8d 50 01             	lea    0x1(%eax),%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	8b 10                	mov    (%eax),%edx
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	8b 40 04             	mov    0x4(%eax),%eax
  8013a9:	39 c2                	cmp    %eax,%edx
  8013ab:	73 12                	jae    8013bf <sprintputch+0x33>
		*b->buf++ = ch;
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b8:	89 0a                	mov    %ecx,(%edx)
  8013ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bd:	88 10                	mov    %dl,(%eax)
}
  8013bf:	90                   	nop
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    

008013c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	01 d0                	add    %edx,%eax
  8013d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8013e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e7:	74 06                	je     8013ef <vsnprintf+0x2d>
  8013e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ed:	7f 07                	jg     8013f6 <vsnprintf+0x34>
		return -E_INVAL;
  8013ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8013f4:	eb 20                	jmp    801416 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8013f6:	ff 75 14             	pushl  0x14(%ebp)
  8013f9:	ff 75 10             	pushl  0x10(%ebp)
  8013fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	68 8c 13 80 00       	push   $0x80138c
  801405:	e8 80 fb ff ff       	call   800f8a <vprintfmt>
  80140a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80140d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801410:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801413:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80141e:	8d 45 10             	lea    0x10(%ebp),%eax
  801421:	83 c0 04             	add    $0x4,%eax
  801424:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801427:	8b 45 10             	mov    0x10(%ebp),%eax
  80142a:	ff 75 f4             	pushl  -0xc(%ebp)
  80142d:	50                   	push   %eax
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	e8 89 ff ff ff       	call   8013c2 <vsnprintf>
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80143f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80144a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144e:	74 13                	je     801463 <readline+0x1f>
		cprintf("%s", prompt);
  801450:	83 ec 08             	sub    $0x8,%esp
  801453:	ff 75 08             	pushl  0x8(%ebp)
  801456:	68 08 54 80 00       	push   $0x805408
  80145b:	e8 0b f9 ff ff       	call   800d6b <cprintf>
  801460:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80146a:	83 ec 0c             	sub    $0xc,%esp
  80146d:	6a 00                	push   $0x0
  80146f:	e8 6f f4 ff ff       	call   8008e3 <iscons>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80147a:	e8 51 f4 ff ff       	call   8008d0 <getchar>
  80147f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801482:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801486:	79 22                	jns    8014aa <readline+0x66>
			if (c != -E_EOF)
  801488:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80148c:	0f 84 ad 00 00 00    	je     80153f <readline+0xfb>
				cprintf("read error: %e\n", c);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	ff 75 ec             	pushl  -0x14(%ebp)
  801498:	68 0b 54 80 00       	push   $0x80540b
  80149d:	e8 c9 f8 ff ff       	call   800d6b <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			break;
  8014a5:	e9 95 00 00 00       	jmp    80153f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8014aa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014ae:	7e 34                	jle    8014e4 <readline+0xa0>
  8014b0:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014b7:	7f 2b                	jg     8014e4 <readline+0xa0>
			if (echoing)
  8014b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014bd:	74 0e                	je     8014cd <readline+0x89>
				cputchar(c);
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8014c5:	e8 e7 f3 ff ff       	call   8008b1 <cputchar>
  8014ca:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8014cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d0:	8d 50 01             	lea    0x1(%eax),%edx
  8014d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8014d6:	89 c2                	mov    %eax,%edx
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	01 d0                	add    %edx,%eax
  8014dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014e0:	88 10                	mov    %dl,(%eax)
  8014e2:	eb 56                	jmp    80153a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8014e4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8014e8:	75 1f                	jne    801509 <readline+0xc5>
  8014ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014ee:	7e 19                	jle    801509 <readline+0xc5>
			if (echoing)
  8014f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014f4:	74 0e                	je     801504 <readline+0xc0>
				cputchar(c);
  8014f6:	83 ec 0c             	sub    $0xc,%esp
  8014f9:	ff 75 ec             	pushl  -0x14(%ebp)
  8014fc:	e8 b0 f3 ff ff       	call   8008b1 <cputchar>
  801501:	83 c4 10             	add    $0x10,%esp

			i--;
  801504:	ff 4d f4             	decl   -0xc(%ebp)
  801507:	eb 31                	jmp    80153a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801509:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80150d:	74 0a                	je     801519 <readline+0xd5>
  80150f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801513:	0f 85 61 ff ff ff    	jne    80147a <readline+0x36>
			if (echoing)
  801519:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151d:	74 0e                	je     80152d <readline+0xe9>
				cputchar(c);
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	ff 75 ec             	pushl  -0x14(%ebp)
  801525:	e8 87 f3 ff ff       	call   8008b1 <cputchar>
  80152a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80152d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	01 d0                	add    %edx,%eax
  801535:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801538:	eb 06                	jmp    801540 <readline+0xfc>
		}
	}
  80153a:	e9 3b ff ff ff       	jmp    80147a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80153f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801540:	90                   	nop
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801549:	e8 df 21 00 00       	call   80372d <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80154e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801552:	74 13                	je     801567 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801554:	83 ec 08             	sub    $0x8,%esp
  801557:	ff 75 08             	pushl  0x8(%ebp)
  80155a:	68 08 54 80 00       	push   $0x805408
  80155f:	e8 07 f8 ff ff       	call   800d6b <cprintf>
  801564:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801567:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	6a 00                	push   $0x0
  801573:	e8 6b f3 ff ff       	call   8008e3 <iscons>
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80157e:	e8 4d f3 ff ff       	call   8008d0 <getchar>
  801583:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801586:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80158a:	79 22                	jns    8015ae <atomic_readline+0x6b>
				if (c != -E_EOF)
  80158c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801590:	0f 84 ad 00 00 00    	je     801643 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	ff 75 ec             	pushl  -0x14(%ebp)
  80159c:	68 0b 54 80 00       	push   $0x80540b
  8015a1:	e8 c5 f7 ff ff       	call   800d6b <cprintf>
  8015a6:	83 c4 10             	add    $0x10,%esp
				break;
  8015a9:	e9 95 00 00 00       	jmp    801643 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8015ae:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8015b2:	7e 34                	jle    8015e8 <atomic_readline+0xa5>
  8015b4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8015bb:	7f 2b                	jg     8015e8 <atomic_readline+0xa5>
				if (echoing)
  8015bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015c1:	74 0e                	je     8015d1 <atomic_readline+0x8e>
					cputchar(c);
  8015c3:	83 ec 0c             	sub    $0xc,%esp
  8015c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8015c9:	e8 e3 f2 ff ff       	call   8008b1 <cputchar>
  8015ce:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	8d 50 01             	lea    0x1(%eax),%edx
  8015d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8015da:	89 c2                	mov    %eax,%edx
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e4:	88 10                	mov    %dl,(%eax)
  8015e6:	eb 56                	jmp    80163e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8015e8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8015ec:	75 1f                	jne    80160d <atomic_readline+0xca>
  8015ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015f2:	7e 19                	jle    80160d <atomic_readline+0xca>
				if (echoing)
  8015f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015f8:	74 0e                	je     801608 <atomic_readline+0xc5>
					cputchar(c);
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	ff 75 ec             	pushl  -0x14(%ebp)
  801600:	e8 ac f2 ff ff       	call   8008b1 <cputchar>
  801605:	83 c4 10             	add    $0x10,%esp
				i--;
  801608:	ff 4d f4             	decl   -0xc(%ebp)
  80160b:	eb 31                	jmp    80163e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80160d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801611:	74 0a                	je     80161d <atomic_readline+0xda>
  801613:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801617:	0f 85 61 ff ff ff    	jne    80157e <atomic_readline+0x3b>
				if (echoing)
  80161d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801621:	74 0e                	je     801631 <atomic_readline+0xee>
					cputchar(c);
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	ff 75 ec             	pushl  -0x14(%ebp)
  801629:	e8 83 f2 ff ff       	call   8008b1 <cputchar>
  80162e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801631:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
  801637:	01 d0                	add    %edx,%eax
  801639:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80163c:	eb 06                	jmp    801644 <atomic_readline+0x101>
			}
		}
  80163e:	e9 3b ff ff ff       	jmp    80157e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801643:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801644:	e8 fe 20 00 00       	call   803747 <sys_unlock_cons>
}
  801649:	90                   	nop
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801652:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801659:	eb 06                	jmp    801661 <strlen+0x15>
		n++;
  80165b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	8a 00                	mov    (%eax),%al
  801666:	84 c0                	test   %al,%al
  801668:	75 f1                	jne    80165b <strlen+0xf>
		n++;
	return n;
  80166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801675:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80167c:	eb 09                	jmp    801687 <strnlen+0x18>
		n++;
  80167e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801681:	ff 45 08             	incl   0x8(%ebp)
  801684:	ff 4d 0c             	decl   0xc(%ebp)
  801687:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168b:	74 09                	je     801696 <strnlen+0x27>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	84 c0                	test   %al,%al
  801694:	75 e8                	jne    80167e <strnlen+0xf>
		n++;
	return n;
  801696:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016a7:	90                   	nop
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8d 50 01             	lea    0x1(%eax),%edx
  8016ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016b7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016ba:	8a 12                	mov    (%edx),%dl
  8016bc:	88 10                	mov    %dl,(%eax)
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 e4                	jne    8016a8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016dc:	eb 1f                	jmp    8016fd <strncpy+0x34>
		*dst++ = *src;
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8d 50 01             	lea    0x1(%eax),%edx
  8016e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8016e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ea:	8a 12                	mov    (%edx),%dl
  8016ec:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8a 00                	mov    (%eax),%al
  8016f3:	84 c0                	test   %al,%al
  8016f5:	74 03                	je     8016fa <strncpy+0x31>
			src++;
  8016f7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8016fa:	ff 45 fc             	incl   -0x4(%ebp)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	3b 45 10             	cmp    0x10(%ebp),%eax
  801703:	72 d9                	jb     8016de <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801705:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801716:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171a:	74 30                	je     80174c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80171c:	eb 16                	jmp    801734 <strlcpy+0x2a>
			*dst++ = *src++;
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8d 50 01             	lea    0x1(%eax),%edx
  801724:	89 55 08             	mov    %edx,0x8(%ebp)
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80172d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801730:	8a 12                	mov    (%edx),%dl
  801732:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801734:	ff 4d 10             	decl   0x10(%ebp)
  801737:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80173b:	74 09                	je     801746 <strlcpy+0x3c>
  80173d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	84 c0                	test   %al,%al
  801744:	75 d8                	jne    80171e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80174c:	8b 55 08             	mov    0x8(%ebp),%edx
  80174f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801752:	29 c2                	sub    %eax,%edx
  801754:	89 d0                	mov    %edx,%eax
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80175b:	eb 06                	jmp    801763 <strcmp+0xb>
		p++, q++;
  80175d:	ff 45 08             	incl   0x8(%ebp)
  801760:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	8a 00                	mov    (%eax),%al
  801768:	84 c0                	test   %al,%al
  80176a:	74 0e                	je     80177a <strcmp+0x22>
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8a 10                	mov    (%eax),%dl
  801771:	8b 45 0c             	mov    0xc(%ebp),%eax
  801774:	8a 00                	mov    (%eax),%al
  801776:	38 c2                	cmp    %al,%dl
  801778:	74 e3                	je     80175d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8a 00                	mov    (%eax),%al
  80177f:	0f b6 d0             	movzbl %al,%edx
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	0f b6 c0             	movzbl %al,%eax
  80178a:	29 c2                	sub    %eax,%edx
  80178c:	89 d0                	mov    %edx,%eax
}
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801793:	eb 09                	jmp    80179e <strncmp+0xe>
		n--, p++, q++;
  801795:	ff 4d 10             	decl   0x10(%ebp)
  801798:	ff 45 08             	incl   0x8(%ebp)
  80179b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80179e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a2:	74 17                	je     8017bb <strncmp+0x2b>
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	84 c0                	test   %al,%al
  8017ab:	74 0e                	je     8017bb <strncmp+0x2b>
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 10                	mov    (%eax),%dl
  8017b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b5:	8a 00                	mov    (%eax),%al
  8017b7:	38 c2                	cmp    %al,%dl
  8017b9:	74 da                	je     801795 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017bf:	75 07                	jne    8017c8 <strncmp+0x38>
		return 0;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	eb 14                	jmp    8017dc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	0f b6 d0             	movzbl %al,%edx
  8017d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	0f b6 c0             	movzbl %al,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
}
  8017dc:	5d                   	pop    %ebp
  8017dd:	c3                   	ret    

008017de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ea:	eb 12                	jmp    8017fe <strchr+0x20>
		if (*s == c)
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017f4:	75 05                	jne    8017fb <strchr+0x1d>
			return (char *) s;
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	eb 11                	jmp    80180c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8017fb:	ff 45 08             	incl   0x8(%ebp)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	84 c0                	test   %al,%al
  801805:	75 e5                	jne    8017ec <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80181a:	eb 0d                	jmp    801829 <strfind+0x1b>
		if (*s == c)
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801824:	74 0e                	je     801834 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801826:	ff 45 08             	incl   0x8(%ebp)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	84 c0                	test   %al,%al
  801830:	75 ea                	jne    80181c <strfind+0xe>
  801832:	eb 01                	jmp    801835 <strfind+0x27>
		if (*s == c)
			break;
  801834:	90                   	nop
	return (char *) s;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801846:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80184a:	76 63                	jbe    8018af <memset+0x75>
		uint64 data_block = c;
  80184c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184f:	99                   	cltd   
  801850:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801853:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801860:	c1 e0 08             	shl    $0x8,%eax
  801863:	09 45 f0             	or     %eax,-0x10(%ebp)
  801866:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801873:	c1 e0 10             	shl    $0x10,%eax
  801876:	09 45 f0             	or     %eax,-0x10(%ebp)
  801879:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801882:	89 c2                	mov    %eax,%edx
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
  801889:	09 45 f0             	or     %eax,-0x10(%ebp)
  80188c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80188f:	eb 18                	jmp    8018a9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801891:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801894:	8d 41 08             	lea    0x8(%ecx),%eax
  801897:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a0:	89 01                	mov    %eax,(%ecx)
  8018a2:	89 51 04             	mov    %edx,0x4(%ecx)
  8018a5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8018a9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8018ad:	77 e2                	ja     801891 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8018af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018b3:	74 23                	je     8018d8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018bb:	eb 0e                	jmp    8018cb <memset+0x91>
			*p8++ = (uint8)c;
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8d 50 01             	lea    0x1(%eax),%edx
  8018c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8018cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	75 e5                	jne    8018bd <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8018e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8018ef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8018f3:	76 24                	jbe    801919 <memcpy+0x3c>
		while(n >= 8){
  8018f5:	eb 1c                	jmp    801913 <memcpy+0x36>
			*d64 = *s64;
  8018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fa:	8b 50 04             	mov    0x4(%eax),%edx
  8018fd:	8b 00                	mov    (%eax),%eax
  8018ff:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801902:	89 01                	mov    %eax,(%ecx)
  801904:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801907:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80190b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80190f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801913:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801917:	77 de                	ja     8018f7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801919:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80191d:	74 31                	je     801950 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801922:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801925:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801928:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80192b:	eb 16                	jmp    801943 <memcpy+0x66>
			*d8++ = *s8++;
  80192d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801930:	8d 50 01             	lea    0x1(%eax),%edx
  801933:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801939:	8d 4a 01             	lea    0x1(%edx),%ecx
  80193c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80193f:	8a 12                	mov    (%edx),%dl
  801941:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801943:	8b 45 10             	mov    0x10(%ebp),%eax
  801946:	8d 50 ff             	lea    -0x1(%eax),%edx
  801949:	89 55 10             	mov    %edx,0x10(%ebp)
  80194c:	85 c0                	test   %eax,%eax
  80194e:	75 dd                	jne    80192d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80195b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801967:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80196d:	73 50                	jae    8019bf <memmove+0x6a>
  80196f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	01 d0                	add    %edx,%eax
  801977:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80197a:	76 43                	jbe    8019bf <memmove+0x6a>
		s += n;
  80197c:	8b 45 10             	mov    0x10(%ebp),%eax
  80197f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801982:	8b 45 10             	mov    0x10(%ebp),%eax
  801985:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801988:	eb 10                	jmp    80199a <memmove+0x45>
			*--d = *--s;
  80198a:	ff 4d f8             	decl   -0x8(%ebp)
  80198d:	ff 4d fc             	decl   -0x4(%ebp)
  801990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801993:	8a 10                	mov    (%eax),%dl
  801995:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801998:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80199a:	8b 45 10             	mov    0x10(%ebp),%eax
  80199d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	75 e3                	jne    80198a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019a7:	eb 23                	jmp    8019cc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ac:	8d 50 01             	lea    0x1(%eax),%edx
  8019af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019b8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019bb:	8a 12                	mov    (%edx),%dl
  8019bd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	75 dd                	jne    8019a9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8019dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8019e3:	eb 2a                	jmp    801a0f <memcmp+0x3e>
		if (*s1 != *s2)
  8019e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e8:	8a 10                	mov    (%eax),%dl
  8019ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	38 c2                	cmp    %al,%dl
  8019f1:	74 16                	je     801a09 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8019f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f6:	8a 00                	mov    (%eax),%al
  8019f8:	0f b6 d0             	movzbl %al,%edx
  8019fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fe:	8a 00                	mov    (%eax),%al
  801a00:	0f b6 c0             	movzbl %al,%eax
  801a03:	29 c2                	sub    %eax,%edx
  801a05:	89 d0                	mov    %edx,%eax
  801a07:	eb 18                	jmp    801a21 <memcmp+0x50>
		s1++, s2++;
  801a09:	ff 45 fc             	incl   -0x4(%ebp)
  801a0c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a12:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a15:	89 55 10             	mov    %edx,0x10(%ebp)
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	75 c9                	jne    8019e5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a29:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2f:	01 d0                	add    %edx,%eax
  801a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a34:	eb 15                	jmp    801a4b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f b6 d0             	movzbl %al,%edx
  801a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a41:	0f b6 c0             	movzbl %al,%eax
  801a44:	39 c2                	cmp    %eax,%edx
  801a46:	74 0d                	je     801a55 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a48:	ff 45 08             	incl   0x8(%ebp)
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a51:	72 e3                	jb     801a36 <memfind+0x13>
  801a53:	eb 01                	jmp    801a56 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a55:	90                   	nop
	return (void *) s;
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a6f:	eb 03                	jmp    801a74 <strtol+0x19>
		s++;
  801a71:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8a 00                	mov    (%eax),%al
  801a79:	3c 20                	cmp    $0x20,%al
  801a7b:	74 f4                	je     801a71 <strtol+0x16>
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	8a 00                	mov    (%eax),%al
  801a82:	3c 09                	cmp    $0x9,%al
  801a84:	74 eb                	je     801a71 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8a 00                	mov    (%eax),%al
  801a8b:	3c 2b                	cmp    $0x2b,%al
  801a8d:	75 05                	jne    801a94 <strtol+0x39>
		s++;
  801a8f:	ff 45 08             	incl   0x8(%ebp)
  801a92:	eb 13                	jmp    801aa7 <strtol+0x4c>
	else if (*s == '-')
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	3c 2d                	cmp    $0x2d,%al
  801a9b:	75 0a                	jne    801aa7 <strtol+0x4c>
		s++, neg = 1;
  801a9d:	ff 45 08             	incl   0x8(%ebp)
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801aab:	74 06                	je     801ab3 <strtol+0x58>
  801aad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801ab1:	75 20                	jne    801ad3 <strtol+0x78>
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	8a 00                	mov    (%eax),%al
  801ab8:	3c 30                	cmp    $0x30,%al
  801aba:	75 17                	jne    801ad3 <strtol+0x78>
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	40                   	inc    %eax
  801ac0:	8a 00                	mov    (%eax),%al
  801ac2:	3c 78                	cmp    $0x78,%al
  801ac4:	75 0d                	jne    801ad3 <strtol+0x78>
		s += 2, base = 16;
  801ac6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801aca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ad1:	eb 28                	jmp    801afb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ad3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad7:	75 15                	jne    801aee <strtol+0x93>
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	8a 00                	mov    (%eax),%al
  801ade:	3c 30                	cmp    $0x30,%al
  801ae0:	75 0c                	jne    801aee <strtol+0x93>
		s++, base = 8;
  801ae2:	ff 45 08             	incl   0x8(%ebp)
  801ae5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801aec:	eb 0d                	jmp    801afb <strtol+0xa0>
	else if (base == 0)
  801aee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801af2:	75 07                	jne    801afb <strtol+0xa0>
		base = 10;
  801af4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	8a 00                	mov    (%eax),%al
  801b00:	3c 2f                	cmp    $0x2f,%al
  801b02:	7e 19                	jle    801b1d <strtol+0xc2>
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	8a 00                	mov    (%eax),%al
  801b09:	3c 39                	cmp    $0x39,%al
  801b0b:	7f 10                	jg     801b1d <strtol+0xc2>
			dig = *s - '0';
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	8a 00                	mov    (%eax),%al
  801b12:	0f be c0             	movsbl %al,%eax
  801b15:	83 e8 30             	sub    $0x30,%eax
  801b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b1b:	eb 42                	jmp    801b5f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	8a 00                	mov    (%eax),%al
  801b22:	3c 60                	cmp    $0x60,%al
  801b24:	7e 19                	jle    801b3f <strtol+0xe4>
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	8a 00                	mov    (%eax),%al
  801b2b:	3c 7a                	cmp    $0x7a,%al
  801b2d:	7f 10                	jg     801b3f <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	8a 00                	mov    (%eax),%al
  801b34:	0f be c0             	movsbl %al,%eax
  801b37:	83 e8 57             	sub    $0x57,%eax
  801b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b3d:	eb 20                	jmp    801b5f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	8a 00                	mov    (%eax),%al
  801b44:	3c 40                	cmp    $0x40,%al
  801b46:	7e 39                	jle    801b81 <strtol+0x126>
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	8a 00                	mov    (%eax),%al
  801b4d:	3c 5a                	cmp    $0x5a,%al
  801b4f:	7f 30                	jg     801b81 <strtol+0x126>
			dig = *s - 'A' + 10;
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	8a 00                	mov    (%eax),%al
  801b56:	0f be c0             	movsbl %al,%eax
  801b59:	83 e8 37             	sub    $0x37,%eax
  801b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b65:	7d 19                	jge    801b80 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b67:	ff 45 08             	incl   0x8(%ebp)
  801b6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b71:	89 c2                	mov    %eax,%edx
  801b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801b7b:	e9 7b ff ff ff       	jmp    801afb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b80:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b85:	74 08                	je     801b8f <strtol+0x134>
		*endptr = (char *) s;
  801b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  801b8d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801b8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b93:	74 07                	je     801b9c <strtol+0x141>
  801b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b98:	f7 d8                	neg    %eax
  801b9a:	eb 03                	jmp    801b9f <strtol+0x144>
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <ltostr>:

void
ltostr(long value, char *str)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801bb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bb9:	79 13                	jns    801bce <ltostr+0x2d>
	{
		neg = 1;
  801bbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bc8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bcb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801bd6:	99                   	cltd   
  801bd7:	f7 f9                	idiv   %ecx
  801bd9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801bdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bdf:	8d 50 01             	lea    0x1(%eax),%edx
  801be2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801be5:	89 c2                	mov    %eax,%edx
  801be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bea:	01 d0                	add    %edx,%eax
  801bec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bef:	83 c2 30             	add    $0x30,%edx
  801bf2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801bfc:	f7 e9                	imul   %ecx
  801bfe:	c1 fa 02             	sar    $0x2,%edx
  801c01:	89 c8                	mov    %ecx,%eax
  801c03:	c1 f8 1f             	sar    $0x1f,%eax
  801c06:	29 c2                	sub    %eax,%edx
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801c0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c11:	75 bb                	jne    801bce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1d:	48                   	dec    %eax
  801c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c25:	74 3d                	je     801c64 <ltostr+0xc3>
		start = 1 ;
  801c27:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c2e:	eb 34                	jmp    801c64 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c36:	01 d0                	add    %edx,%eax
  801c38:	8a 00                	mov    (%eax),%al
  801c3a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c43:	01 c2                	add    %eax,%edx
  801c45:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4b:	01 c8                	add    %ecx,%eax
  801c4d:	8a 00                	mov    (%eax),%al
  801c4f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	01 c2                	add    %eax,%edx
  801c59:	8a 45 eb             	mov    -0x15(%ebp),%al
  801c5c:	88 02                	mov    %al,(%edx)
		start++ ;
  801c5e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801c61:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c6a:	7c c4                	jl     801c30 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801c6c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c72:	01 d0                	add    %edx,%eax
  801c74:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801c77:	90                   	nop
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	e8 c4 f9 ff ff       	call   80164c <strlen>
  801c88:	83 c4 04             	add    $0x4,%esp
  801c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	e8 b6 f9 ff ff       	call   80164c <strlen>
  801c96:	83 c4 04             	add    $0x4,%esp
  801c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ca3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801caa:	eb 17                	jmp    801cc3 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801caf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb2:	01 c2                	add    %eax,%edx
  801cb4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	01 c8                	add    %ecx,%eax
  801cbc:	8a 00                	mov    (%eax),%al
  801cbe:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801cc0:	ff 45 fc             	incl   -0x4(%ebp)
  801cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801cc9:	7c e1                	jl     801cac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ccb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801cd2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801cd9:	eb 1f                	jmp    801cfa <strcconcat+0x80>
		final[s++] = str2[i] ;
  801cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cde:	8d 50 01             	lea    0x1(%eax),%edx
  801ce1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ce4:	89 c2                	mov    %eax,%edx
  801ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce9:	01 c2                	add    %eax,%edx
  801ceb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	01 c8                	add    %ecx,%eax
  801cf3:	8a 00                	mov    (%eax),%al
  801cf5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801cf7:	ff 45 f8             	incl   -0x8(%ebp)
  801cfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cfd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d00:	7c d9                	jl     801cdb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d05:	8b 45 10             	mov    0x10(%ebp),%eax
  801d08:	01 d0                	add    %edx,%eax
  801d0a:	c6 00 00             	movb   $0x0,(%eax)
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d13:	8b 45 14             	mov    0x14(%ebp),%eax
  801d16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1f:	8b 00                	mov    (%eax),%eax
  801d21:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d28:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d33:	eb 0c                	jmp    801d41 <strsplit+0x31>
			*string++ = 0;
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	8d 50 01             	lea    0x1(%eax),%edx
  801d3b:	89 55 08             	mov    %edx,0x8(%ebp)
  801d3e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 00                	mov    (%eax),%al
  801d46:	84 c0                	test   %al,%al
  801d48:	74 18                	je     801d62 <strsplit+0x52>
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	8a 00                	mov    (%eax),%al
  801d4f:	0f be c0             	movsbl %al,%eax
  801d52:	50                   	push   %eax
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	e8 83 fa ff ff       	call   8017de <strchr>
  801d5b:	83 c4 08             	add    $0x8,%esp
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	75 d3                	jne    801d35 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	8a 00                	mov    (%eax),%al
  801d67:	84 c0                	test   %al,%al
  801d69:	74 5a                	je     801dc5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801d6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6e:	8b 00                	mov    (%eax),%eax
  801d70:	83 f8 0f             	cmp    $0xf,%eax
  801d73:	75 07                	jne    801d7c <strsplit+0x6c>
		{
			return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	eb 66                	jmp    801de2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7f:	8b 00                	mov    (%eax),%eax
  801d81:	8d 48 01             	lea    0x1(%eax),%ecx
  801d84:	8b 55 14             	mov    0x14(%ebp),%edx
  801d87:	89 0a                	mov    %ecx,(%edx)
  801d89:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d90:	8b 45 10             	mov    0x10(%ebp),%eax
  801d93:	01 c2                	add    %eax,%edx
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d9a:	eb 03                	jmp    801d9f <strsplit+0x8f>
			string++;
  801d9c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	8a 00                	mov    (%eax),%al
  801da4:	84 c0                	test   %al,%al
  801da6:	74 8b                	je     801d33 <strsplit+0x23>
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	8a 00                	mov    (%eax),%al
  801dad:	0f be c0             	movsbl %al,%eax
  801db0:	50                   	push   %eax
  801db1:	ff 75 0c             	pushl  0xc(%ebp)
  801db4:	e8 25 fa ff ff       	call   8017de <strchr>
  801db9:	83 c4 08             	add    $0x8,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	74 dc                	je     801d9c <strsplit+0x8c>
			string++;
	}
  801dc0:	e9 6e ff ff ff       	jmp    801d33 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801dc5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801dc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc9:	8b 00                	mov    (%eax),%eax
  801dcb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd5:	01 d0                	add    %edx,%eax
  801dd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ddd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801df0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801df7:	eb 4a                	jmp    801e43 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801df9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	01 c2                	add    %eax,%edx
  801e01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	01 c8                	add    %ecx,%eax
  801e09:	8a 00                	mov    (%eax),%al
  801e0b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801e0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	8a 00                	mov    (%eax),%al
  801e17:	3c 40                	cmp    $0x40,%al
  801e19:	7e 25                	jle    801e40 <str2lower+0x5c>
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e21:	01 d0                	add    %edx,%eax
  801e23:	8a 00                	mov    (%eax),%al
  801e25:	3c 5a                	cmp    $0x5a,%al
  801e27:	7f 17                	jg     801e40 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	01 d0                	add    %edx,%eax
  801e31:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e34:	8b 55 08             	mov    0x8(%ebp),%edx
  801e37:	01 ca                	add    %ecx,%edx
  801e39:	8a 12                	mov    (%edx),%dl
  801e3b:	83 c2 20             	add    $0x20,%edx
  801e3e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801e40:	ff 45 fc             	incl   -0x4(%ebp)
  801e43:	ff 75 0c             	pushl  0xc(%ebp)
  801e46:	e8 01 f8 ff ff       	call   80164c <strlen>
  801e4b:	83 c4 04             	add    $0x4,%esp
  801e4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e51:	7f a6                	jg     801df9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801e53:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801e5e:	a1 08 60 80 00       	mov    0x806008,%eax
  801e63:	85 c0                	test   %eax,%eax
  801e65:	74 42                	je     801ea9 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801e67:	83 ec 08             	sub    $0x8,%esp
  801e6a:	68 00 00 00 82       	push   $0x82000000
  801e6f:	68 00 00 00 80       	push   $0x80000000
  801e74:	e8 b0 1e 00 00       	call   803d29 <initialize_dynamic_allocator>
  801e79:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801e7c:	e8 96 1c 00 00       	call   803b17 <sys_get_uheap_strategy>
  801e81:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801e86:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801e8b:	05 00 10 00 00       	add    $0x1000,%eax
  801e90:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801e95:	a1 30 61 83 00       	mov    0x836130,%eax
  801e9a:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801e9f:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801ea6:	00 00 00 
	}
}
  801ea9:	90                   	nop
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ec0:	83 ec 08             	sub    $0x8,%esp
  801ec3:	68 06 04 00 00       	push   $0x406
  801ec8:	50                   	push   %eax
  801ec9:	e8 93 18 00 00       	call   803761 <__sys_allocate_page>
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ed4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed8:	79 14                	jns    801eee <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	68 1c 54 80 00       	push   $0x80541c
  801ee2:	6a 1f                	push   $0x1f
  801ee4:	68 58 54 80 00       	push   $0x805458
  801ee9:	e8 af eb ff ff       	call   800a9d <_panic>
	return 0;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	50                   	push   %eax
  801f0d:	e8 96 18 00 00       	call   8037a8 <__sys_unmap_frame>
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f1c:	79 14                	jns    801f32 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	68 64 54 80 00       	push   $0x805464
  801f26:	6a 2a                	push   $0x2a
  801f28:	68 58 54 80 00       	push   $0x805458
  801f2d:	e8 6b eb ff ff       	call   800a9d <_panic>
}
  801f32:	90                   	nop
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f3b:	e8 18 ff ff ff       	call   801e58 <uheap_init>
	if (size == 0) return NULL ;
  801f40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f44:	75 0a                	jne    801f50 <malloc+0x1b>
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	e9 43 03 00 00       	jmp    802293 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801f50:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f57:	77 13                	ja     801f6c <malloc+0x37>
    {
        return alloc_block(size);
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	ff 75 08             	pushl  0x8(%ebp)
  801f5f:	e8 78 20 00 00       	call   803fdc <alloc_block>
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	e9 27 03 00 00       	jmp    802293 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801f6c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801f73:	8b 55 08             	mov    0x8(%ebp),%edx
  801f76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f79:	01 d0                	add    %edx,%eax
  801f7b:	48                   	dec    %eax
  801f7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f82:	ba 00 00 00 00       	mov    $0x0,%edx
  801f87:	f7 75 dc             	divl   -0x24(%ebp)
  801f8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f8d:	29 d0                	sub    %edx,%eax
  801f8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801f92:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 0a                	jne    801fa5 <malloc+0x70>
    {
        uhp_inited = 1;
  801f9b:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801fa2:	00 00 00 
    }

    int exactIdx = -1;
  801fa5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801fac:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801fb3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801fba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801fc1:	e9 85 00 00 00       	jmp    80204b <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801fc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fc9:	89 d0                	mov    %edx,%eax
  801fcb:	01 c0                	add    %eax,%eax
  801fcd:	01 d0                	add    %edx,%eax
  801fcf:	c1 e0 02             	shl    $0x2,%eax
  801fd2:	05 48 20 81 00       	add    $0x812048,%eax
  801fd7:	8a 00                	mov    (%eax),%al
  801fd9:	84 c0                	test   %al,%al
  801fdb:	74 20                	je     801ffd <malloc+0xc8>
  801fdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fe0:	89 d0                	mov    %edx,%eax
  801fe2:	01 c0                	add    %eax,%eax
  801fe4:	01 d0                	add    %edx,%eax
  801fe6:	c1 e0 02             	shl    $0x2,%eax
  801fe9:	05 44 20 81 00       	add    $0x812044,%eax
  801fee:	8b 00                	mov    (%eax),%eax
  801ff0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ff3:	75 08                	jne    801ffd <malloc+0xc8>
        {
            exactIdx = i;
  801ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801ffb:	eb 5b                	jmp    802058 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801ffd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802000:	89 d0                	mov    %edx,%eax
  802002:	01 c0                	add    %eax,%eax
  802004:	01 d0                	add    %edx,%eax
  802006:	c1 e0 02             	shl    $0x2,%eax
  802009:	05 48 20 81 00       	add    $0x812048,%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	84 c0                	test   %al,%al
  802012:	74 34                	je     802048 <malloc+0x113>
  802014:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802017:	89 d0                	mov    %edx,%eax
  802019:	01 c0                	add    %eax,%eax
  80201b:	01 d0                	add    %edx,%eax
  80201d:	c1 e0 02             	shl    $0x2,%eax
  802020:	05 44 20 81 00       	add    $0x812044,%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80202a:	76 1c                	jbe    802048 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  80202c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80202f:	89 d0                	mov    %edx,%eax
  802031:	01 c0                	add    %eax,%eax
  802033:	01 d0                	add    %edx,%eax
  802035:	c1 e0 02             	shl    $0x2,%eax
  802038:	05 44 20 81 00       	add    $0x812044,%eax
  80203d:	8b 00                	mov    (%eax),%eax
  80203f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802045:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802048:	ff 45 e8             	incl   -0x18(%ebp)
  80204b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802052:	0f 8e 6e ff ff ff    	jle    801fc6 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  802058:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80205f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802063:	74 7d                	je     8020e2 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802065:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80206c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206f:	89 d0                	mov    %edx,%eax
  802071:	01 c0                	add    %eax,%eax
  802073:	01 d0                	add    %edx,%eax
  802075:	c1 e0 02             	shl    $0x2,%eax
  802078:	05 40 20 81 00       	add    $0x812040,%eax
  80207d:	8b 10                	mov    (%eax),%edx
  80207f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802082:	01 d0                	add    %edx,%eax
  802084:	48                   	dec    %eax
  802085:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802088:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80208b:	ba 00 00 00 00       	mov    $0x0,%edx
  802090:	f7 75 bc             	divl   -0x44(%ebp)
  802093:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802096:	29 d0                	sub    %edx,%eax
  802098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80209b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209e:	89 d0                	mov    %edx,%eax
  8020a0:	01 c0                	add    %eax,%eax
  8020a2:	01 d0                	add    %edx,%eax
  8020a4:	c1 e0 02             	shl    $0x2,%eax
  8020a7:	05 48 20 81 00       	add    $0x812048,%eax
  8020ac:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8020af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b2:	89 d0                	mov    %edx,%eax
  8020b4:	01 c0                	add    %eax,%eax
  8020b6:	01 d0                	add    %edx,%eax
  8020b8:	c1 e0 02             	shl    $0x2,%eax
  8020bb:	05 44 20 81 00       	add    $0x812044,%eax
  8020c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8020c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	01 c0                	add    %eax,%eax
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	c1 e0 02             	shl    $0x2,%eax
  8020d2:	05 40 20 81 00       	add    $0x812040,%eax
  8020d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020dd:	e9 2d 01 00 00       	jmp    80220f <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8020e2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020e6:	0f 84 ce 00 00 00    	je     8021ba <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8020ec:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8020f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020f6:	89 d0                	mov    %edx,%eax
  8020f8:	01 c0                	add    %eax,%eax
  8020fa:	01 d0                	add    %edx,%eax
  8020fc:	c1 e0 02             	shl    $0x2,%eax
  8020ff:	05 40 20 81 00       	add    $0x812040,%eax
  802104:	8b 10                	mov    (%eax),%edx
  802106:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802109:	01 d0                	add    %edx,%eax
  80210b:	48                   	dec    %eax
  80210c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80210f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802112:	ba 00 00 00 00       	mov    $0x0,%edx
  802117:	f7 75 c4             	divl   -0x3c(%ebp)
  80211a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80211d:	29 d0                	sub    %edx,%eax
  80211f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802125:	89 d0                	mov    %edx,%eax
  802127:	01 c0                	add    %eax,%eax
  802129:	01 d0                	add    %edx,%eax
  80212b:	c1 e0 02             	shl    $0x2,%eax
  80212e:	05 44 20 81 00       	add    $0x812044,%eax
  802133:	8b 00                	mov    (%eax),%eax
  802135:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802138:	75 47                	jne    802181 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80213a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80213d:	89 d0                	mov    %edx,%eax
  80213f:	01 c0                	add    %eax,%eax
  802141:	01 d0                	add    %edx,%eax
  802143:	c1 e0 02             	shl    $0x2,%eax
  802146:	05 48 20 81 00       	add    $0x812048,%eax
  80214b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80214e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802151:	89 d0                	mov    %edx,%eax
  802153:	01 c0                	add    %eax,%eax
  802155:	01 d0                	add    %edx,%eax
  802157:	c1 e0 02             	shl    $0x2,%eax
  80215a:	05 44 20 81 00       	add    $0x812044,%eax
  80215f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802165:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802168:	89 d0                	mov    %edx,%eax
  80216a:	01 c0                	add    %eax,%eax
  80216c:	01 d0                	add    %edx,%eax
  80216e:	c1 e0 02             	shl    $0x2,%eax
  802171:	05 40 20 81 00       	add    $0x812040,%eax
  802176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80217c:	e9 8e 00 00 00       	jmp    80220f <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802181:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802184:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802187:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80218a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80218d:	89 d0                	mov    %edx,%eax
  80218f:	01 c0                	add    %eax,%eax
  802191:	01 d0                	add    %edx,%eax
  802193:	c1 e0 02             	shl    $0x2,%eax
  802196:	05 40 20 81 00       	add    $0x812040,%eax
  80219b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80219d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a0:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8021a3:	89 c2                	mov    %eax,%edx
  8021a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8021a8:	89 c8                	mov    %ecx,%eax
  8021aa:	01 c0                	add    %eax,%eax
  8021ac:	01 c8                	add    %ecx,%eax
  8021ae:	c1 e0 02             	shl    $0x2,%eax
  8021b1:	05 44 20 81 00       	add    $0x812044,%eax
  8021b6:	89 10                	mov    %edx,(%eax)
  8021b8:	eb 55                	jmp    80220f <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8021ba:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8021c1:	8b 15 88 60 83 00    	mov    0x836088,%edx
  8021c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ca:	01 d0                	add    %edx,%eax
  8021cc:	48                   	dec    %eax
  8021cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8021d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d8:	f7 75 d0             	divl   -0x30(%ebp)
  8021db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021de:	29 d0                	sub    %edx,%eax
  8021e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8021e3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8021e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e9:	01 d0                	add    %edx,%eax
  8021eb:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8021f0:	76 0a                	jbe    8021fc <malloc+0x2c7>
            return NULL;
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f7:	e9 97 00 00 00       	jmp    802293 <malloc+0x35e>
        va = start;
  8021fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8021ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802202:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802205:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802208:	01 d0                	add    %edx,%eax
  80220a:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80220f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802216:	eb 5e                	jmp    802276 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  802218:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80221b:	89 d0                	mov    %edx,%eax
  80221d:	01 c0                	add    %eax,%eax
  80221f:	01 d0                	add    %edx,%eax
  802221:	c1 e0 02             	shl    $0x2,%eax
  802224:	05 48 60 80 00       	add    $0x806048,%eax
  802229:	8a 00                	mov    (%eax),%al
  80222b:	84 c0                	test   %al,%al
  80222d:	75 44                	jne    802273 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  80222f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802232:	89 d0                	mov    %edx,%eax
  802234:	01 c0                	add    %eax,%eax
  802236:	01 d0                	add    %edx,%eax
  802238:	c1 e0 02             	shl    $0x2,%eax
  80223b:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802241:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802244:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802246:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802249:	89 d0                	mov    %edx,%eax
  80224b:	01 c0                	add    %eax,%eax
  80224d:	01 d0                	add    %edx,%eax
  80224f:	c1 e0 02             	shl    $0x2,%eax
  802252:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80225b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80225d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802260:	89 d0                	mov    %edx,%eax
  802262:	01 c0                	add    %eax,%eax
  802264:	01 d0                	add    %edx,%eax
  802266:	c1 e0 02             	shl    $0x2,%eax
  802269:	05 48 60 80 00       	add    $0x806048,%eax
  80226e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802271:	eb 0c                	jmp    80227f <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802273:	ff 45 e0             	incl   -0x20(%ebp)
  802276:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80227d:	7e 99                	jle    802218 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  80227f:	83 ec 08             	sub    $0x8,%esp
  802282:	ff 75 d4             	pushl  -0x2c(%ebp)
  802285:	ff 75 e4             	pushl  -0x1c(%ebp)
  802288:	e8 a2 19 00 00       	call   803c2f <sys_allocate_user_mem>
  80228d:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  802290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  80229b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229f:	0f 84 fa 03 00 00    	je     80269f <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8022ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	79 1c                	jns    8022ce <free+0x39>
  8022b2:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  8022b9:	77 13                	ja     8022ce <free+0x39>
    {
        free_block(virtual_address);
  8022bb:	83 ec 0c             	sub    $0xc,%esp
  8022be:	ff 75 08             	pushl  0x8(%ebp)
  8022c1:	e8 09 21 00 00       	call   8043cf <free_block>
  8022c6:	83 c4 10             	add    $0x10,%esp
        return;
  8022c9:	e9 d2 03 00 00       	jmp    8026a0 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8022ce:	a1 30 61 83 00       	mov    0x836130,%eax
  8022d3:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8022d6:	72 09                	jb     8022e1 <free+0x4c>
  8022d8:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  8022df:	76 17                	jbe    8022f8 <free+0x63>
        panic("free: invalid address");
  8022e1:	83 ec 04             	sub    $0x4,%esp
  8022e4:	68 a1 54 80 00       	push   $0x8054a1
  8022e9:	68 9b 00 00 00       	push   $0x9b
  8022ee:	68 58 54 80 00       	push   $0x805458
  8022f3:	e8 a5 e7 ff ff       	call   800a9d <_panic>

    uint32 size = 0;
  8022f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  8022ff:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802306:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80230d:	eb 50                	jmp    80235f <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80230f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802312:	89 d0                	mov    %edx,%eax
  802314:	01 c0                	add    %eax,%eax
  802316:	01 d0                	add    %edx,%eax
  802318:	c1 e0 02             	shl    $0x2,%eax
  80231b:	05 48 60 80 00       	add    $0x806048,%eax
  802320:	8a 00                	mov    (%eax),%al
  802322:	84 c0                	test   %al,%al
  802324:	74 36                	je     80235c <free+0xc7>
  802326:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802329:	89 d0                	mov    %edx,%eax
  80232b:	01 c0                	add    %eax,%eax
  80232d:	01 d0                	add    %edx,%eax
  80232f:	c1 e0 02             	shl    $0x2,%eax
  802332:	05 40 60 80 00       	add    $0x806040,%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80233c:	75 1e                	jne    80235c <free+0xc7>
        {
            size = uhp_allocs[i].size;
  80233e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802341:	89 d0                	mov    %edx,%eax
  802343:	01 c0                	add    %eax,%eax
  802345:	01 d0                	add    %edx,%eax
  802347:	c1 e0 02             	shl    $0x2,%eax
  80234a:	05 44 60 80 00       	add    $0x806044,%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  80235a:	eb 0c                	jmp    802368 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80235c:	ff 45 ec             	incl   -0x14(%ebp)
  80235f:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802366:	7e a7                	jle    80230f <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  802368:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80236c:	74 06                	je     802374 <free+0xdf>
  80236e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802372:	75 17                	jne    80238b <free+0xf6>
        panic("free: unknown block");
  802374:	83 ec 04             	sub    $0x4,%esp
  802377:	68 b7 54 80 00       	push   $0x8054b7
  80237c:	68 a9 00 00 00       	push   $0xa9
  802381:	68 58 54 80 00       	push   $0x805458
  802386:	e8 12 e7 ff ff       	call   800a9d <_panic>

    uhp_allocs[idx].used = 0;
  80238b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238e:	89 d0                	mov    %edx,%eax
  802390:	01 c0                	add    %eax,%eax
  802392:	01 d0                	add    %edx,%eax
  802394:	c1 e0 02             	shl    $0x2,%eax
  802397:	05 48 60 80 00       	add    $0x806048,%eax
  80239c:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  80239f:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8023a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8023ad:	eb 64                	jmp    802413 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8023af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023b2:	89 d0                	mov    %edx,%eax
  8023b4:	01 c0                	add    %eax,%eax
  8023b6:	01 d0                	add    %edx,%eax
  8023b8:	c1 e0 02             	shl    $0x2,%eax
  8023bb:	05 48 20 81 00       	add    $0x812048,%eax
  8023c0:	8a 00                	mov    (%eax),%al
  8023c2:	84 c0                	test   %al,%al
  8023c4:	75 4a                	jne    802410 <free+0x17b>
        {
            uhp_frees[i].va = va;
  8023c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023c9:	89 d0                	mov    %edx,%eax
  8023cb:	01 c0                	add    %eax,%eax
  8023cd:	01 d0                	add    %edx,%eax
  8023cf:	c1 e0 02             	shl    $0x2,%eax
  8023d2:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8023d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023db:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  8023dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023e0:	89 d0                	mov    %edx,%eax
  8023e2:	01 c0                	add    %eax,%eax
  8023e4:	01 d0                	add    %edx,%eax
  8023e6:	c1 e0 02             	shl    $0x2,%eax
  8023e9:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  8023f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023f7:	89 d0                	mov    %edx,%eax
  8023f9:	01 c0                	add    %eax,%eax
  8023fb:	01 d0                	add    %edx,%eax
  8023fd:	c1 e0 02             	shl    $0x2,%eax
  802400:	05 48 20 81 00       	add    $0x812048,%eax
  802405:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  80240e:	eb 0c                	jmp    80241c <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802410:	ff 45 e4             	incl   -0x1c(%ebp)
  802413:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80241a:	7e 93                	jle    8023af <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  80241c:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802420:	0f 84 f1 01 00 00    	je     802617 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802426:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80242d:	e9 d8 01 00 00       	jmp    80260a <free+0x375>
        {
            if (i == fidx) continue;
  802432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802435:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802438:	0f 84 c8 01 00 00    	je     802606 <free+0x371>
            if (uhp_frees[i].free)
  80243e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802441:	89 d0                	mov    %edx,%eax
  802443:	01 c0                	add    %eax,%eax
  802445:	01 d0                	add    %edx,%eax
  802447:	c1 e0 02             	shl    $0x2,%eax
  80244a:	05 48 20 81 00       	add    $0x812048,%eax
  80244f:	8a 00                	mov    (%eax),%al
  802451:	84 c0                	test   %al,%al
  802453:	0f 84 ae 01 00 00    	je     802607 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  802459:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80245c:	89 d0                	mov    %edx,%eax
  80245e:	01 c0                	add    %eax,%eax
  802460:	01 d0                	add    %edx,%eax
  802462:	c1 e0 02             	shl    $0x2,%eax
  802465:	05 40 20 81 00       	add    $0x812040,%eax
  80246a:	8b 08                	mov    (%eax),%ecx
  80246c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80246f:	89 d0                	mov    %edx,%eax
  802471:	01 c0                	add    %eax,%eax
  802473:	01 d0                	add    %edx,%eax
  802475:	c1 e0 02             	shl    $0x2,%eax
  802478:	05 44 20 81 00       	add    $0x812044,%eax
  80247d:	8b 00                	mov    (%eax),%eax
  80247f:	01 c1                	add    %eax,%ecx
  802481:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802484:	89 d0                	mov    %edx,%eax
  802486:	01 c0                	add    %eax,%eax
  802488:	01 d0                	add    %edx,%eax
  80248a:	c1 e0 02             	shl    $0x2,%eax
  80248d:	05 40 20 81 00       	add    $0x812040,%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	39 c1                	cmp    %eax,%ecx
  802496:	0f 85 a8 00 00 00    	jne    802544 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  80249c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80249f:	89 d0                	mov    %edx,%eax
  8024a1:	01 c0                	add    %eax,%eax
  8024a3:	01 d0                	add    %edx,%eax
  8024a5:	c1 e0 02             	shl    $0x2,%eax
  8024a8:	05 40 20 81 00       	add    $0x812040,%eax
  8024ad:	8b 10                	mov    (%eax),%edx
  8024af:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8024b2:	89 c8                	mov    %ecx,%eax
  8024b4:	01 c0                	add    %eax,%eax
  8024b6:	01 c8                	add    %ecx,%eax
  8024b8:	c1 e0 02             	shl    $0x2,%eax
  8024bb:	05 40 20 81 00       	add    $0x812040,%eax
  8024c0:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8024c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024c5:	89 d0                	mov    %edx,%eax
  8024c7:	01 c0                	add    %eax,%eax
  8024c9:	01 d0                	add    %edx,%eax
  8024cb:	c1 e0 02             	shl    $0x2,%eax
  8024ce:	05 44 20 81 00       	add    $0x812044,%eax
  8024d3:	8b 08                	mov    (%eax),%ecx
  8024d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024d8:	89 d0                	mov    %edx,%eax
  8024da:	01 c0                	add    %eax,%eax
  8024dc:	01 d0                	add    %edx,%eax
  8024de:	c1 e0 02             	shl    $0x2,%eax
  8024e1:	05 44 20 81 00       	add    $0x812044,%eax
  8024e6:	8b 00                	mov    (%eax),%eax
  8024e8:	01 c1                	add    %eax,%ecx
  8024ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024ed:	89 d0                	mov    %edx,%eax
  8024ef:	01 c0                	add    %eax,%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c1 e0 02             	shl    $0x2,%eax
  8024f6:	05 44 20 81 00       	add    $0x812044,%eax
  8024fb:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8024fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802500:	89 d0                	mov    %edx,%eax
  802502:	01 c0                	add    %eax,%eax
  802504:	01 d0                	add    %edx,%eax
  802506:	c1 e0 02             	shl    $0x2,%eax
  802509:	05 48 20 81 00       	add    $0x812048,%eax
  80250e:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802511:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802514:	89 d0                	mov    %edx,%eax
  802516:	01 c0                	add    %eax,%eax
  802518:	01 d0                	add    %edx,%eax
  80251a:	c1 e0 02             	shl    $0x2,%eax
  80251d:	05 40 20 81 00       	add    $0x812040,%eax
  802522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802528:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80252b:	89 d0                	mov    %edx,%eax
  80252d:	01 c0                	add    %eax,%eax
  80252f:	01 d0                	add    %edx,%eax
  802531:	c1 e0 02             	shl    $0x2,%eax
  802534:	05 44 20 81 00       	add    $0x812044,%eax
  802539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253f:	e9 c3 00 00 00       	jmp    802607 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  802544:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802547:	89 d0                	mov    %edx,%eax
  802549:	01 c0                	add    %eax,%eax
  80254b:	01 d0                	add    %edx,%eax
  80254d:	c1 e0 02             	shl    $0x2,%eax
  802550:	05 40 20 81 00       	add    $0x812040,%eax
  802555:	8b 08                	mov    (%eax),%ecx
  802557:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80255a:	89 d0                	mov    %edx,%eax
  80255c:	01 c0                	add    %eax,%eax
  80255e:	01 d0                	add    %edx,%eax
  802560:	c1 e0 02             	shl    $0x2,%eax
  802563:	05 44 20 81 00       	add    $0x812044,%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	01 c1                	add    %eax,%ecx
  80256c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80256f:	89 d0                	mov    %edx,%eax
  802571:	01 c0                	add    %eax,%eax
  802573:	01 d0                	add    %edx,%eax
  802575:	c1 e0 02             	shl    $0x2,%eax
  802578:	05 40 20 81 00       	add    $0x812040,%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	39 c1                	cmp    %eax,%ecx
  802581:	0f 85 80 00 00 00    	jne    802607 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802587:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80258a:	89 d0                	mov    %edx,%eax
  80258c:	01 c0                	add    %eax,%eax
  80258e:	01 d0                	add    %edx,%eax
  802590:	c1 e0 02             	shl    $0x2,%eax
  802593:	05 44 20 81 00       	add    $0x812044,%eax
  802598:	8b 08                	mov    (%eax),%ecx
  80259a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80259d:	89 d0                	mov    %edx,%eax
  80259f:	01 c0                	add    %eax,%eax
  8025a1:	01 d0                	add    %edx,%eax
  8025a3:	c1 e0 02             	shl    $0x2,%eax
  8025a6:	05 44 20 81 00       	add    $0x812044,%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	01 c1                	add    %eax,%ecx
  8025af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025b2:	89 d0                	mov    %edx,%eax
  8025b4:	01 c0                	add    %eax,%eax
  8025b6:	01 d0                	add    %edx,%eax
  8025b8:	c1 e0 02             	shl    $0x2,%eax
  8025bb:	05 44 20 81 00       	add    $0x812044,%eax
  8025c0:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  8025c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025c5:	89 d0                	mov    %edx,%eax
  8025c7:	01 c0                	add    %eax,%eax
  8025c9:	01 d0                	add    %edx,%eax
  8025cb:	c1 e0 02             	shl    $0x2,%eax
  8025ce:	05 48 20 81 00       	add    $0x812048,%eax
  8025d3:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8025d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025d9:	89 d0                	mov    %edx,%eax
  8025db:	01 c0                	add    %eax,%eax
  8025dd:	01 d0                	add    %edx,%eax
  8025df:	c1 e0 02             	shl    $0x2,%eax
  8025e2:	05 40 20 81 00       	add    $0x812040,%eax
  8025e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8025ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025f0:	89 d0                	mov    %edx,%eax
  8025f2:	01 c0                	add    %eax,%eax
  8025f4:	01 d0                	add    %edx,%eax
  8025f6:	c1 e0 02             	shl    $0x2,%eax
  8025f9:	05 44 20 81 00       	add    $0x812044,%eax
  8025fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802604:	eb 01                	jmp    802607 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  802606:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802607:	ff 45 e0             	incl   -0x20(%ebp)
  80260a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802611:	0f 8e 1b fe ff ff    	jle    802432 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802617:	a1 30 61 83 00       	mov    0x836130,%eax
  80261c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80261f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802626:	eb 53                	jmp    80267b <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802628:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80262b:	89 d0                	mov    %edx,%eax
  80262d:	01 c0                	add    %eax,%eax
  80262f:	01 d0                	add    %edx,%eax
  802631:	c1 e0 02             	shl    $0x2,%eax
  802634:	05 48 60 80 00       	add    $0x806048,%eax
  802639:	8a 00                	mov    (%eax),%al
  80263b:	84 c0                	test   %al,%al
  80263d:	74 39                	je     802678 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  80263f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802642:	89 d0                	mov    %edx,%eax
  802644:	01 c0                	add    %eax,%eax
  802646:	01 d0                	add    %edx,%eax
  802648:	c1 e0 02             	shl    $0x2,%eax
  80264b:	05 40 60 80 00       	add    $0x806040,%eax
  802650:	8b 08                	mov    (%eax),%ecx
  802652:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802655:	89 d0                	mov    %edx,%eax
  802657:	01 c0                	add    %eax,%eax
  802659:	01 d0                	add    %edx,%eax
  80265b:	c1 e0 02             	shl    $0x2,%eax
  80265e:	05 44 60 80 00       	add    $0x806044,%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	01 c8                	add    %ecx,%eax
  802667:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  80266a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80266d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802670:	76 06                	jbe    802678 <free+0x3e3>
  802672:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802675:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802678:	ff 45 d8             	incl   -0x28(%ebp)
  80267b:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802682:	7e a4                	jle    802628 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802684:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802687:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  80268c:	83 ec 08             	sub    $0x8,%esp
  80268f:	ff 75 f4             	pushl  -0xc(%ebp)
  802692:	ff 75 d4             	pushl  -0x2c(%ebp)
  802695:	e8 79 15 00 00       	call   803c13 <sys_free_user_mem>
  80269a:	83 c4 10             	add    $0x10,%esp
  80269d:	eb 01                	jmp    8026a0 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  80269f:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	83 ec 68             	sub    $0x68,%esp
  8026a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ab:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026ae:	e8 a5 f7 ff ff       	call   801e58 <uheap_init>
	if (size == 0) return NULL ;
  8026b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026b7:	75 0a                	jne    8026c3 <smalloc+0x21>
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	e9 37 03 00 00       	jmp    8029fa <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8026c3:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8026ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026d0:	01 d0                	add    %edx,%eax
  8026d2:	48                   	dec    %eax
  8026d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8026d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026de:	f7 75 dc             	divl   -0x24(%ebp)
  8026e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026e4:	29 d0                	sub    %edx,%eax
  8026e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  8026e9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8026f0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8026f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8026fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802705:	e9 85 00 00 00       	jmp    80278f <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80270a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80270d:	89 d0                	mov    %edx,%eax
  80270f:	01 c0                	add    %eax,%eax
  802711:	01 d0                	add    %edx,%eax
  802713:	c1 e0 02             	shl    $0x2,%eax
  802716:	05 48 20 81 00       	add    $0x812048,%eax
  80271b:	8a 00                	mov    (%eax),%al
  80271d:	84 c0                	test   %al,%al
  80271f:	74 20                	je     802741 <smalloc+0x9f>
  802721:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802724:	89 d0                	mov    %edx,%eax
  802726:	01 c0                	add    %eax,%eax
  802728:	01 d0                	add    %edx,%eax
  80272a:	c1 e0 02             	shl    $0x2,%eax
  80272d:	05 44 20 81 00       	add    $0x812044,%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802737:	75 08                	jne    802741 <smalloc+0x9f>
        {
            exactIdx = i;
  802739:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80273f:	eb 5b                	jmp    80279c <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802741:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802744:	89 d0                	mov    %edx,%eax
  802746:	01 c0                	add    %eax,%eax
  802748:	01 d0                	add    %edx,%eax
  80274a:	c1 e0 02             	shl    $0x2,%eax
  80274d:	05 48 20 81 00       	add    $0x812048,%eax
  802752:	8a 00                	mov    (%eax),%al
  802754:	84 c0                	test   %al,%al
  802756:	74 34                	je     80278c <smalloc+0xea>
  802758:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80275b:	89 d0                	mov    %edx,%eax
  80275d:	01 c0                	add    %eax,%eax
  80275f:	01 d0                	add    %edx,%eax
  802761:	c1 e0 02             	shl    $0x2,%eax
  802764:	05 44 20 81 00       	add    $0x812044,%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80276e:	76 1c                	jbe    80278c <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802770:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802773:	89 d0                	mov    %edx,%eax
  802775:	01 c0                	add    %eax,%eax
  802777:	01 d0                	add    %edx,%eax
  802779:	c1 e0 02             	shl    $0x2,%eax
  80277c:	05 44 20 81 00       	add    $0x812044,%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802786:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802789:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80278c:	ff 45 e8             	incl   -0x18(%ebp)
  80278f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802796:	0f 8e 6e ff ff ff    	jle    80270a <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80279c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8027a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8027a7:	74 7d                	je     802826 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8027a9:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8027b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	01 c0                	add    %eax,%eax
  8027b7:	01 d0                	add    %edx,%eax
  8027b9:	c1 e0 02             	shl    $0x2,%eax
  8027bc:	05 40 20 81 00       	add    $0x812040,%eax
  8027c1:	8b 10                	mov    (%eax),%edx
  8027c3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027c6:	01 d0                	add    %edx,%eax
  8027c8:	48                   	dec    %eax
  8027c9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8027cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d4:	f7 75 bc             	divl   -0x44(%ebp)
  8027d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027da:	29 d0                	sub    %edx,%eax
  8027dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8027df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e2:	89 d0                	mov    %edx,%eax
  8027e4:	01 c0                	add    %eax,%eax
  8027e6:	01 d0                	add    %edx,%eax
  8027e8:	c1 e0 02             	shl    $0x2,%eax
  8027eb:	05 48 20 81 00       	add    $0x812048,%eax
  8027f0:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8027f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f6:	89 d0                	mov    %edx,%eax
  8027f8:	01 c0                	add    %eax,%eax
  8027fa:	01 d0                	add    %edx,%eax
  8027fc:	c1 e0 02             	shl    $0x2,%eax
  8027ff:	05 44 20 81 00       	add    $0x812044,%eax
  802804:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80280a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280d:	89 d0                	mov    %edx,%eax
  80280f:	01 c0                	add    %eax,%eax
  802811:	01 d0                	add    %edx,%eax
  802813:	c1 e0 02             	shl    $0x2,%eax
  802816:	05 40 20 81 00       	add    $0x812040,%eax
  80281b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802821:	e9 2d 01 00 00       	jmp    802953 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802826:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80282a:	0f 84 ce 00 00 00    	je     8028fe <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802830:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802837:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283a:	89 d0                	mov    %edx,%eax
  80283c:	01 c0                	add    %eax,%eax
  80283e:	01 d0                	add    %edx,%eax
  802840:	c1 e0 02             	shl    $0x2,%eax
  802843:	05 40 20 81 00       	add    $0x812040,%eax
  802848:	8b 10                	mov    (%eax),%edx
  80284a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80284d:	01 d0                	add    %edx,%eax
  80284f:	48                   	dec    %eax
  802850:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802853:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802856:	ba 00 00 00 00       	mov    $0x0,%edx
  80285b:	f7 75 c4             	divl   -0x3c(%ebp)
  80285e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802861:	29 d0                	sub    %edx,%eax
  802863:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802866:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802869:	89 d0                	mov    %edx,%eax
  80286b:	01 c0                	add    %eax,%eax
  80286d:	01 d0                	add    %edx,%eax
  80286f:	c1 e0 02             	shl    $0x2,%eax
  802872:	05 44 20 81 00       	add    $0x812044,%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80287c:	75 47                	jne    8028c5 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80287e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802881:	89 d0                	mov    %edx,%eax
  802883:	01 c0                	add    %eax,%eax
  802885:	01 d0                	add    %edx,%eax
  802887:	c1 e0 02             	shl    $0x2,%eax
  80288a:	05 48 20 81 00       	add    $0x812048,%eax
  80288f:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802892:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802895:	89 d0                	mov    %edx,%eax
  802897:	01 c0                	add    %eax,%eax
  802899:	01 d0                	add    %edx,%eax
  80289b:	c1 e0 02             	shl    $0x2,%eax
  80289e:	05 44 20 81 00       	add    $0x812044,%eax
  8028a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8028a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ac:	89 d0                	mov    %edx,%eax
  8028ae:	01 c0                	add    %eax,%eax
  8028b0:	01 d0                	add    %edx,%eax
  8028b2:	c1 e0 02             	shl    $0x2,%eax
  8028b5:	05 40 20 81 00       	add    $0x812040,%eax
  8028ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c0:	e9 8e 00 00 00       	jmp    802953 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8028c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028cb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d1:	89 d0                	mov    %edx,%eax
  8028d3:	01 c0                	add    %eax,%eax
  8028d5:	01 d0                	add    %edx,%eax
  8028d7:	c1 e0 02             	shl    $0x2,%eax
  8028da:	05 40 20 81 00       	add    $0x812040,%eax
  8028df:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8028e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8028e7:	89 c2                	mov    %eax,%edx
  8028e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028ec:	89 c8                	mov    %ecx,%eax
  8028ee:	01 c0                	add    %eax,%eax
  8028f0:	01 c8                	add    %ecx,%eax
  8028f2:	c1 e0 02             	shl    $0x2,%eax
  8028f5:	05 44 20 81 00       	add    $0x812044,%eax
  8028fa:	89 10                	mov    %edx,(%eax)
  8028fc:	eb 55                	jmp    802953 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8028fe:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802905:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80290b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80290e:	01 d0                	add    %edx,%eax
  802910:	48                   	dec    %eax
  802911:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802914:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802917:	ba 00 00 00 00       	mov    $0x0,%edx
  80291c:	f7 75 d0             	divl   -0x30(%ebp)
  80291f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802922:	29 d0                	sub    %edx,%eax
  802924:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802927:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80292a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80292d:	01 d0                	add    %edx,%eax
  80292f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802934:	76 0a                	jbe    802940 <smalloc+0x29e>
            return NULL;
  802936:	b8 00 00 00 00       	mov    $0x0,%eax
  80293b:	e9 ba 00 00 00       	jmp    8029fa <smalloc+0x358>
        va = start;
  802940:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802943:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802946:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802949:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80294c:	01 d0                	add    %edx,%eax
  80294e:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802953:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80295a:	eb 5e                	jmp    8029ba <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  80295c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80295f:	89 d0                	mov    %edx,%eax
  802961:	01 c0                	add    %eax,%eax
  802963:	01 d0                	add    %edx,%eax
  802965:	c1 e0 02             	shl    $0x2,%eax
  802968:	05 48 60 80 00       	add    $0x806048,%eax
  80296d:	8a 00                	mov    (%eax),%al
  80296f:	84 c0                	test   %al,%al
  802971:	75 44                	jne    8029b7 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802973:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802976:	89 d0                	mov    %edx,%eax
  802978:	01 c0                	add    %eax,%eax
  80297a:	01 d0                	add    %edx,%eax
  80297c:	c1 e0 02             	shl    $0x2,%eax
  80297f:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802988:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80298a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80298d:	89 d0                	mov    %edx,%eax
  80298f:	01 c0                	add    %eax,%eax
  802991:	01 d0                	add    %edx,%eax
  802993:	c1 e0 02             	shl    $0x2,%eax
  802996:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  80299c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80299f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8029a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029a4:	89 d0                	mov    %edx,%eax
  8029a6:	01 c0                	add    %eax,%eax
  8029a8:	01 d0                	add    %edx,%eax
  8029aa:	c1 e0 02             	shl    $0x2,%eax
  8029ad:	05 48 60 80 00       	add    $0x806048,%eax
  8029b2:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8029b5:	eb 0c                	jmp    8029c3 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029b7:	ff 45 e0             	incl   -0x20(%ebp)
  8029ba:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8029c1:	7e 99                	jle    80295c <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8029c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029c6:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8029ca:	52                   	push   %edx
  8029cb:	50                   	push   %eax
  8029cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8029cf:	ff 75 08             	pushl  0x8(%ebp)
  8029d2:	e8 de 0e 00 00       	call   8038b5 <sys_create_shared_object>
  8029d7:	83 c4 10             	add    $0x10,%esp
  8029da:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8029dd:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8029e1:	75 07                	jne    8029ea <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8029e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8029e8:	eb 10                	jmp    8029fa <smalloc+0x358>
    if (r < 0)
  8029ea:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8029ee:	79 07                	jns    8029f7 <smalloc+0x355>
        return NULL;
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f5:	eb 03                	jmp    8029fa <smalloc+0x358>
    return (void*)va;
  8029f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
  8029ff:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a02:	e8 51 f4 ff ff       	call   801e58 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802a07:	83 ec 08             	sub    $0x8,%esp
  802a0a:	ff 75 0c             	pushl  0xc(%ebp)
  802a0d:	ff 75 08             	pushl  0x8(%ebp)
  802a10:	e8 ca 0e 00 00       	call   8038df <sys_size_of_shared_object>
  802a15:	83 c4 10             	add    $0x10,%esp
  802a18:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802a1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a1f:	7f 0a                	jg     802a2b <sget+0x2f>
        return NULL;
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
  802a26:	e9 28 03 00 00       	jmp    802d53 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802a2b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802a32:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a35:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a38:	01 d0                	add    %edx,%eax
  802a3a:	48                   	dec    %eax
  802a3b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a41:	ba 00 00 00 00       	mov    $0x0,%edx
  802a46:	f7 75 d8             	divl   -0x28(%ebp)
  802a49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a4c:	29 d0                	sub    %edx,%eax
  802a4e:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802a51:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802a58:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802a5f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802a66:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802a6d:	e9 85 00 00 00       	jmp    802af7 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802a72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a75:	89 d0                	mov    %edx,%eax
  802a77:	01 c0                	add    %eax,%eax
  802a79:	01 d0                	add    %edx,%eax
  802a7b:	c1 e0 02             	shl    $0x2,%eax
  802a7e:	05 48 20 81 00       	add    $0x812048,%eax
  802a83:	8a 00                	mov    (%eax),%al
  802a85:	84 c0                	test   %al,%al
  802a87:	74 20                	je     802aa9 <sget+0xad>
  802a89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a8c:	89 d0                	mov    %edx,%eax
  802a8e:	01 c0                	add    %eax,%eax
  802a90:	01 d0                	add    %edx,%eax
  802a92:	c1 e0 02             	shl    $0x2,%eax
  802a95:	05 44 20 81 00       	add    $0x812044,%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802a9f:	75 08                	jne    802aa9 <sget+0xad>
        {
            exactIdx = i;
  802aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802aa7:	eb 5b                	jmp    802b04 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802aa9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aac:	89 d0                	mov    %edx,%eax
  802aae:	01 c0                	add    %eax,%eax
  802ab0:	01 d0                	add    %edx,%eax
  802ab2:	c1 e0 02             	shl    $0x2,%eax
  802ab5:	05 48 20 81 00       	add    $0x812048,%eax
  802aba:	8a 00                	mov    (%eax),%al
  802abc:	84 c0                	test   %al,%al
  802abe:	74 34                	je     802af4 <sget+0xf8>
  802ac0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac3:	89 d0                	mov    %edx,%eax
  802ac5:	01 c0                	add    %eax,%eax
  802ac7:	01 d0                	add    %edx,%eax
  802ac9:	c1 e0 02             	shl    $0x2,%eax
  802acc:	05 44 20 81 00       	add    $0x812044,%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ad6:	76 1c                	jbe    802af4 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802ad8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802adb:	89 d0                	mov    %edx,%eax
  802add:	01 c0                	add    %eax,%eax
  802adf:	01 d0                	add    %edx,%eax
  802ae1:	c1 e0 02             	shl    $0x2,%eax
  802ae4:	05 44 20 81 00       	add    $0x812044,%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802af4:	ff 45 e8             	incl   -0x18(%ebp)
  802af7:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802afe:	0f 8e 6e ff ff ff    	jle    802a72 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802b04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802b0b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802b0f:	74 7d                	je     802b8e <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802b11:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	01 c0                	add    %eax,%eax
  802b1f:	01 d0                	add    %edx,%eax
  802b21:	c1 e0 02             	shl    $0x2,%eax
  802b24:	05 40 20 81 00       	add    $0x812040,%eax
  802b29:	8b 10                	mov    (%eax),%edx
  802b2b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b2e:	01 d0                	add    %edx,%eax
  802b30:	48                   	dec    %eax
  802b31:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b34:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b37:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3c:	f7 75 b8             	divl   -0x48(%ebp)
  802b3f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b42:	29 d0                	sub    %edx,%eax
  802b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4a:	89 d0                	mov    %edx,%eax
  802b4c:	01 c0                	add    %eax,%eax
  802b4e:	01 d0                	add    %edx,%eax
  802b50:	c1 e0 02             	shl    $0x2,%eax
  802b53:	05 48 20 81 00       	add    $0x812048,%eax
  802b58:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5e:	89 d0                	mov    %edx,%eax
  802b60:	01 c0                	add    %eax,%eax
  802b62:	01 d0                	add    %edx,%eax
  802b64:	c1 e0 02             	shl    $0x2,%eax
  802b67:	05 44 20 81 00       	add    $0x812044,%eax
  802b6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b75:	89 d0                	mov    %edx,%eax
  802b77:	01 c0                	add    %eax,%eax
  802b79:	01 d0                	add    %edx,%eax
  802b7b:	c1 e0 02             	shl    $0x2,%eax
  802b7e:	05 40 20 81 00       	add    $0x812040,%eax
  802b83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b89:	e9 2d 01 00 00       	jmp    802cbb <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802b8e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b92:	0f 84 ce 00 00 00    	je     802c66 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802b98:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802b9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba2:	89 d0                	mov    %edx,%eax
  802ba4:	01 c0                	add    %eax,%eax
  802ba6:	01 d0                	add    %edx,%eax
  802ba8:	c1 e0 02             	shl    $0x2,%eax
  802bab:	05 40 20 81 00       	add    $0x812040,%eax
  802bb0:	8b 10                	mov    (%eax),%edx
  802bb2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bb5:	01 d0                	add    %edx,%eax
  802bb7:	48                   	dec    %eax
  802bb8:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802bbb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc3:	f7 75 c0             	divl   -0x40(%ebp)
  802bc6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bc9:	29 d0                	sub    %edx,%eax
  802bcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd1:	89 d0                	mov    %edx,%eax
  802bd3:	01 c0                	add    %eax,%eax
  802bd5:	01 d0                	add    %edx,%eax
  802bd7:	c1 e0 02             	shl    $0x2,%eax
  802bda:	05 44 20 81 00       	add    $0x812044,%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802be4:	75 47                	jne    802c2d <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802be6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be9:	89 d0                	mov    %edx,%eax
  802beb:	01 c0                	add    %eax,%eax
  802bed:	01 d0                	add    %edx,%eax
  802bef:	c1 e0 02             	shl    $0x2,%eax
  802bf2:	05 48 20 81 00       	add    $0x812048,%eax
  802bf7:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802bfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfd:	89 d0                	mov    %edx,%eax
  802bff:	01 c0                	add    %eax,%eax
  802c01:	01 d0                	add    %edx,%eax
  802c03:	c1 e0 02             	shl    $0x2,%eax
  802c06:	05 44 20 81 00       	add    $0x812044,%eax
  802c0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802c11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c14:	89 d0                	mov    %edx,%eax
  802c16:	01 c0                	add    %eax,%eax
  802c18:	01 d0                	add    %edx,%eax
  802c1a:	c1 e0 02             	shl    $0x2,%eax
  802c1d:	05 40 20 81 00       	add    $0x812040,%eax
  802c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c28:	e9 8e 00 00 00       	jmp    802cbb <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802c2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c30:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c33:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802c36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c39:	89 d0                	mov    %edx,%eax
  802c3b:	01 c0                	add    %eax,%eax
  802c3d:	01 d0                	add    %edx,%eax
  802c3f:	c1 e0 02             	shl    $0x2,%eax
  802c42:	05 40 20 81 00       	add    $0x812040,%eax
  802c47:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4c:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802c4f:	89 c2                	mov    %eax,%edx
  802c51:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c54:	89 c8                	mov    %ecx,%eax
  802c56:	01 c0                	add    %eax,%eax
  802c58:	01 c8                	add    %ecx,%eax
  802c5a:	c1 e0 02             	shl    $0x2,%eax
  802c5d:	05 44 20 81 00       	add    $0x812044,%eax
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	eb 55                	jmp    802cbb <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802c66:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c6d:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802c73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c76:	01 d0                	add    %edx,%eax
  802c78:	48                   	dec    %eax
  802c79:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c7c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c7f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c84:	f7 75 cc             	divl   -0x34(%ebp)
  802c87:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c8a:	29 d0                	sub    %edx,%eax
  802c8c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802c8f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802c92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c95:	01 d0                	add    %edx,%eax
  802c97:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802c9c:	76 0a                	jbe    802ca8 <sget+0x2ac>
            return NULL;
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca3:	e9 ab 00 00 00       	jmp    802d53 <sget+0x357>
        va = start;
  802ca8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802cae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802cb1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cb4:	01 d0                	add    %edx,%eax
  802cb6:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cbb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802cc2:	eb 5e                	jmp    802d22 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802cc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc7:	89 d0                	mov    %edx,%eax
  802cc9:	01 c0                	add    %eax,%eax
  802ccb:	01 d0                	add    %edx,%eax
  802ccd:	c1 e0 02             	shl    $0x2,%eax
  802cd0:	05 48 60 80 00       	add    $0x806048,%eax
  802cd5:	8a 00                	mov    (%eax),%al
  802cd7:	84 c0                	test   %al,%al
  802cd9:	75 44                	jne    802d1f <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802cdb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cde:	89 d0                	mov    %edx,%eax
  802ce0:	01 c0                	add    %eax,%eax
  802ce2:	01 d0                	add    %edx,%eax
  802ce4:	c1 e0 02             	shl    $0x2,%eax
  802ce7:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802ced:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802cf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf5:	89 d0                	mov    %edx,%eax
  802cf7:	01 c0                	add    %eax,%eax
  802cf9:	01 d0                	add    %edx,%eax
  802cfb:	c1 e0 02             	shl    $0x2,%eax
  802cfe:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802d04:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d07:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802d09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d0c:	89 d0                	mov    %edx,%eax
  802d0e:	01 c0                	add    %eax,%eax
  802d10:	01 d0                	add    %edx,%eax
  802d12:	c1 e0 02             	shl    $0x2,%eax
  802d15:	05 48 60 80 00       	add    $0x806048,%eax
  802d1a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802d1d:	eb 0c                	jmp    802d2b <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d1f:	ff 45 e0             	incl   -0x20(%ebp)
  802d22:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802d29:	7e 99                	jle    802cc4 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2e:	83 ec 04             	sub    $0x4,%esp
  802d31:	50                   	push   %eax
  802d32:	ff 75 0c             	pushl  0xc(%ebp)
  802d35:	ff 75 08             	pushl  0x8(%ebp)
  802d38:	e8 bf 0b 00 00       	call   8038fc <sys_get_shared_object>
  802d3d:	83 c4 10             	add    $0x10,%esp
  802d40:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802d43:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d47:	79 07                	jns    802d50 <sget+0x354>
        return NULL;
  802d49:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4e:	eb 03                	jmp    802d53 <sget+0x357>
    return (void*)va;
  802d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802d53:	c9                   	leave  
  802d54:	c3                   	ret    

00802d55 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
  802d58:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802d5b:	e8 f8 f0 ff ff       	call   801e58 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802d60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d64:	75 13                	jne    802d79 <realloc+0x24>
		return malloc(new_size);
  802d66:	83 ec 0c             	sub    $0xc,%esp
  802d69:	ff 75 0c             	pushl  0xc(%ebp)
  802d6c:	e8 c4 f1 ff ff       	call   801f35 <malloc>
  802d71:	83 c4 10             	add    $0x10,%esp
  802d74:	e9 f4 05 00 00       	jmp    80336d <realloc+0x618>
	if (new_size == 0)
  802d79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d7d:	75 18                	jne    802d97 <realloc+0x42>
	{
		free(virtual_address);
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	ff 75 08             	pushl  0x8(%ebp)
  802d85:	e8 0b f5 ff ff       	call   802295 <free>
  802d8a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d92:	e9 d6 05 00 00       	jmp    80336d <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802d9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	79 74                	jns    802e18 <realloc+0xc3>
  802da4:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802dab:	77 6b                	ja     802e18 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802dad:	83 ec 0c             	sub    $0xc,%esp
  802db0:	ff 75 0c             	pushl  0xc(%ebp)
  802db3:	e8 7d f1 ff ff       	call   801f35 <malloc>
  802db8:	83 c4 10             	add    $0x10,%esp
  802dbb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802dbe:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802dc2:	75 0a                	jne    802dce <realloc+0x79>
			return NULL;
  802dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc9:	e9 9f 05 00 00       	jmp    80336d <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802dce:	83 ec 0c             	sub    $0xc,%esp
  802dd1:	ff 75 08             	pushl  0x8(%ebp)
  802dd4:	e8 e0 11 00 00       	call   803fb9 <get_block_size>
  802dd9:	83 c4 10             	add    $0x10,%esp
  802ddc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802ddf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de5:	39 d0                	cmp    %edx,%eax
  802de7:	76 02                	jbe    802deb <realloc+0x96>
  802de9:	89 d0                	mov    %edx,%eax
  802deb:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	ff 75 c0             	pushl  -0x40(%ebp)
  802df4:	ff 75 08             	pushl  0x8(%ebp)
  802df7:	ff 75 c8             	pushl  -0x38(%ebp)
  802dfa:	e8 56 eb ff ff       	call   801955 <memmove>
  802dff:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802e02:	83 ec 0c             	sub    $0xc,%esp
  802e05:	ff 75 08             	pushl  0x8(%ebp)
  802e08:	e8 88 f4 ff ff       	call   802295 <free>
  802e0d:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802e10:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e13:	e9 55 05 00 00       	jmp    80336d <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802e18:	a1 30 61 83 00       	mov    0x836130,%eax
  802e1d:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802e20:	72 09                	jb     802e2b <realloc+0xd6>
  802e22:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802e29:	76 0a                	jbe    802e35 <realloc+0xe0>
		return NULL;
  802e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e30:	e9 38 05 00 00       	jmp    80336d <realloc+0x618>
	uint32 oldsz = 0;
  802e35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802e3c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802e4a:	eb 50                	jmp    802e9c <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802e4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e4f:	89 d0                	mov    %edx,%eax
  802e51:	01 c0                	add    %eax,%eax
  802e53:	01 d0                	add    %edx,%eax
  802e55:	c1 e0 02             	shl    $0x2,%eax
  802e58:	05 48 60 80 00       	add    $0x806048,%eax
  802e5d:	8a 00                	mov    (%eax),%al
  802e5f:	84 c0                	test   %al,%al
  802e61:	74 36                	je     802e99 <realloc+0x144>
  802e63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e66:	89 d0                	mov    %edx,%eax
  802e68:	01 c0                	add    %eax,%eax
  802e6a:	01 d0                	add    %edx,%eax
  802e6c:	c1 e0 02             	shl    $0x2,%eax
  802e6f:	05 40 60 80 00       	add    $0x806040,%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802e79:	75 1e                	jne    802e99 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802e7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e7e:	89 d0                	mov    %edx,%eax
  802e80:	01 c0                	add    %eax,%eax
  802e82:	01 d0                	add    %edx,%eax
  802e84:	c1 e0 02             	shl    $0x2,%eax
  802e87:	05 44 60 80 00       	add    $0x806044,%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802e97:	eb 0c                	jmp    802ea5 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e99:	ff 45 ec             	incl   -0x14(%ebp)
  802e9c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ea3:	7e a7                	jle    802e4c <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802ea5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ea9:	75 0a                	jne    802eb5 <realloc+0x160>
		return NULL;
  802eab:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb0:	e9 b8 04 00 00       	jmp    80336d <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802eb5:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ec2:	01 d0                	add    %edx,%eax
  802ec4:	48                   	dec    %eax
  802ec5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802ec8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ecb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed0:	f7 75 bc             	divl   -0x44(%ebp)
  802ed3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ed6:	29 d0                	sub    %edx,%eax
  802ed8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802edb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ede:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ee1:	75 08                	jne    802eeb <realloc+0x196>
		return virtual_address;
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	e9 82 04 00 00       	jmp    80336d <realloc+0x618>
	if (req < oldsz)
  802eeb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802eee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ef1:	0f 83 cd 02 00 00    	jae    8031c4 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802efd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802f00:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f06:	01 d0                	add    %edx,%eax
  802f08:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0e:	89 d0                	mov    %edx,%eax
  802f10:	01 c0                	add    %eax,%eax
  802f12:	01 d0                	add    %edx,%eax
  802f14:	c1 e0 02             	shl    $0x2,%eax
  802f17:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802f1d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f20:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802f22:	83 ec 08             	sub    $0x8,%esp
  802f25:	ff 75 b0             	pushl  -0x50(%ebp)
  802f28:	ff 75 ac             	pushl  -0x54(%ebp)
  802f2b:	e8 e3 0c 00 00       	call   803c13 <sys_free_user_mem>
  802f30:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802f33:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802f3a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802f41:	eb 64                	jmp    802fa7 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802f43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f46:	89 d0                	mov    %edx,%eax
  802f48:	01 c0                	add    %eax,%eax
  802f4a:	01 d0                	add    %edx,%eax
  802f4c:	c1 e0 02             	shl    $0x2,%eax
  802f4f:	05 48 20 81 00       	add    $0x812048,%eax
  802f54:	8a 00                	mov    (%eax),%al
  802f56:	84 c0                	test   %al,%al
  802f58:	75 4a                	jne    802fa4 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802f5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f5d:	89 d0                	mov    %edx,%eax
  802f5f:	01 c0                	add    %eax,%eax
  802f61:	01 d0                	add    %edx,%eax
  802f63:	c1 e0 02             	shl    $0x2,%eax
  802f66:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802f6c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f6f:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802f71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f74:	89 d0                	mov    %edx,%eax
  802f76:	01 c0                	add    %eax,%eax
  802f78:	01 d0                	add    %edx,%eax
  802f7a:	c1 e0 02             	shl    $0x2,%eax
  802f7d:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802f83:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f86:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802f88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f8b:	89 d0                	mov    %edx,%eax
  802f8d:	01 c0                	add    %eax,%eax
  802f8f:	01 d0                	add    %edx,%eax
  802f91:	c1 e0 02             	shl    $0x2,%eax
  802f94:	05 48 20 81 00       	add    $0x812048,%eax
  802f99:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802fa2:	eb 0c                	jmp    802fb0 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802fa4:	ff 45 e4             	incl   -0x1c(%ebp)
  802fa7:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802fae:	7e 93                	jle    802f43 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802fb0:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802fb4:	0f 84 8d 01 00 00    	je     803147 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802fba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802fc1:	e9 74 01 00 00       	jmp    80313a <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fcc:	0f 84 64 01 00 00    	je     803136 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802fd2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fd5:	89 d0                	mov    %edx,%eax
  802fd7:	01 c0                	add    %eax,%eax
  802fd9:	01 d0                	add    %edx,%eax
  802fdb:	c1 e0 02             	shl    $0x2,%eax
  802fde:	05 48 20 81 00       	add    $0x812048,%eax
  802fe3:	8a 00                	mov    (%eax),%al
  802fe5:	84 c0                	test   %al,%al
  802fe7:	0f 84 4a 01 00 00    	je     803137 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802fed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ff0:	89 d0                	mov    %edx,%eax
  802ff2:	01 c0                	add    %eax,%eax
  802ff4:	01 d0                	add    %edx,%eax
  802ff6:	c1 e0 02             	shl    $0x2,%eax
  802ff9:	05 40 20 81 00       	add    $0x812040,%eax
  802ffe:	8b 08                	mov    (%eax),%ecx
  803000:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803003:	89 d0                	mov    %edx,%eax
  803005:	01 c0                	add    %eax,%eax
  803007:	01 d0                	add    %edx,%eax
  803009:	c1 e0 02             	shl    $0x2,%eax
  80300c:	05 44 20 81 00       	add    $0x812044,%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	01 c1                	add    %eax,%ecx
  803015:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803018:	89 d0                	mov    %edx,%eax
  80301a:	01 c0                	add    %eax,%eax
  80301c:	01 d0                	add    %edx,%eax
  80301e:	c1 e0 02             	shl    $0x2,%eax
  803021:	05 40 20 81 00       	add    $0x812040,%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	39 c1                	cmp    %eax,%ecx
  80302a:	75 7a                	jne    8030a6 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  80302c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80302f:	89 d0                	mov    %edx,%eax
  803031:	01 c0                	add    %eax,%eax
  803033:	01 d0                	add    %edx,%eax
  803035:	c1 e0 02             	shl    $0x2,%eax
  803038:	05 40 20 81 00       	add    $0x812040,%eax
  80303d:	8b 10                	mov    (%eax),%edx
  80303f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803042:	89 c8                	mov    %ecx,%eax
  803044:	01 c0                	add    %eax,%eax
  803046:	01 c8                	add    %ecx,%eax
  803048:	c1 e0 02             	shl    $0x2,%eax
  80304b:	05 40 20 81 00       	add    $0x812040,%eax
  803050:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  803052:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803055:	89 d0                	mov    %edx,%eax
  803057:	01 c0                	add    %eax,%eax
  803059:	01 d0                	add    %edx,%eax
  80305b:	c1 e0 02             	shl    $0x2,%eax
  80305e:	05 44 20 81 00       	add    $0x812044,%eax
  803063:	8b 08                	mov    (%eax),%ecx
  803065:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803068:	89 d0                	mov    %edx,%eax
  80306a:	01 c0                	add    %eax,%eax
  80306c:	01 d0                	add    %edx,%eax
  80306e:	c1 e0 02             	shl    $0x2,%eax
  803071:	05 44 20 81 00       	add    $0x812044,%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	01 c1                	add    %eax,%ecx
  80307a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307d:	89 d0                	mov    %edx,%eax
  80307f:	01 c0                	add    %eax,%eax
  803081:	01 d0                	add    %edx,%eax
  803083:	c1 e0 02             	shl    $0x2,%eax
  803086:	05 44 20 81 00       	add    $0x812044,%eax
  80308b:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80308d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803090:	89 d0                	mov    %edx,%eax
  803092:	01 c0                	add    %eax,%eax
  803094:	01 d0                	add    %edx,%eax
  803096:	c1 e0 02             	shl    $0x2,%eax
  803099:	05 48 20 81 00       	add    $0x812048,%eax
  80309e:	c6 00 00             	movb   $0x0,(%eax)
  8030a1:	e9 91 00 00 00       	jmp    803137 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8030a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a9:	89 d0                	mov    %edx,%eax
  8030ab:	01 c0                	add    %eax,%eax
  8030ad:	01 d0                	add    %edx,%eax
  8030af:	c1 e0 02             	shl    $0x2,%eax
  8030b2:	05 40 20 81 00       	add    $0x812040,%eax
  8030b7:	8b 08                	mov    (%eax),%ecx
  8030b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030bc:	89 d0                	mov    %edx,%eax
  8030be:	01 c0                	add    %eax,%eax
  8030c0:	01 d0                	add    %edx,%eax
  8030c2:	c1 e0 02             	shl    $0x2,%eax
  8030c5:	05 44 20 81 00       	add    $0x812044,%eax
  8030ca:	8b 00                	mov    (%eax),%eax
  8030cc:	01 c1                	add    %eax,%ecx
  8030ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030d1:	89 d0                	mov    %edx,%eax
  8030d3:	01 c0                	add    %eax,%eax
  8030d5:	01 d0                	add    %edx,%eax
  8030d7:	c1 e0 02             	shl    $0x2,%eax
  8030da:	05 40 20 81 00       	add    $0x812040,%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	39 c1                	cmp    %eax,%ecx
  8030e3:	75 52                	jne    803137 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8030e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e8:	89 d0                	mov    %edx,%eax
  8030ea:	01 c0                	add    %eax,%eax
  8030ec:	01 d0                	add    %edx,%eax
  8030ee:	c1 e0 02             	shl    $0x2,%eax
  8030f1:	05 44 20 81 00       	add    $0x812044,%eax
  8030f6:	8b 08                	mov    (%eax),%ecx
  8030f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030fb:	89 d0                	mov    %edx,%eax
  8030fd:	01 c0                	add    %eax,%eax
  8030ff:	01 d0                	add    %edx,%eax
  803101:	c1 e0 02             	shl    $0x2,%eax
  803104:	05 44 20 81 00       	add    $0x812044,%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	01 c1                	add    %eax,%ecx
  80310d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803110:	89 d0                	mov    %edx,%eax
  803112:	01 c0                	add    %eax,%eax
  803114:	01 d0                	add    %edx,%eax
  803116:	c1 e0 02             	shl    $0x2,%eax
  803119:	05 44 20 81 00       	add    $0x812044,%eax
  80311e:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  803120:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803123:	89 d0                	mov    %edx,%eax
  803125:	01 c0                	add    %eax,%eax
  803127:	01 d0                	add    %edx,%eax
  803129:	c1 e0 02             	shl    $0x2,%eax
  80312c:	05 48 20 81 00       	add    $0x812048,%eax
  803131:	c6 00 00             	movb   $0x0,(%eax)
  803134:	eb 01                	jmp    803137 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  803136:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803137:	ff 45 e0             	incl   -0x20(%ebp)
  80313a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803141:	0f 8e 7f fe ff ff    	jle    802fc6 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  803147:	a1 30 61 83 00       	mov    0x836130,%eax
  80314c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80314f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  803156:	eb 53                	jmp    8031ab <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  803158:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80315b:	89 d0                	mov    %edx,%eax
  80315d:	01 c0                	add    %eax,%eax
  80315f:	01 d0                	add    %edx,%eax
  803161:	c1 e0 02             	shl    $0x2,%eax
  803164:	05 48 60 80 00       	add    $0x806048,%eax
  803169:	8a 00                	mov    (%eax),%al
  80316b:	84 c0                	test   %al,%al
  80316d:	74 39                	je     8031a8 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80316f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803172:	89 d0                	mov    %edx,%eax
  803174:	01 c0                	add    %eax,%eax
  803176:	01 d0                	add    %edx,%eax
  803178:	c1 e0 02             	shl    $0x2,%eax
  80317b:	05 40 60 80 00       	add    $0x806040,%eax
  803180:	8b 08                	mov    (%eax),%ecx
  803182:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803185:	89 d0                	mov    %edx,%eax
  803187:	01 c0                	add    %eax,%eax
  803189:	01 d0                	add    %edx,%eax
  80318b:	c1 e0 02             	shl    $0x2,%eax
  80318e:	05 44 60 80 00       	add    $0x806044,%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	01 c8                	add    %ecx,%eax
  803197:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  80319a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80319d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8031a0:	76 06                	jbe    8031a8 <realloc+0x453>
  8031a2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8031a8:	ff 45 d8             	incl   -0x28(%ebp)
  8031ab:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8031b2:	7e a4                	jle    803158 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8031b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b7:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	e9 a9 01 00 00       	jmp    80336d <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8031c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	01 d0                	add    %edx,%eax
  8031cc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8031cf:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8031d6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8031dd:	eb 57                	jmp    803236 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8031df:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031e2:	89 d0                	mov    %edx,%eax
  8031e4:	01 c0                	add    %eax,%eax
  8031e6:	01 d0                	add    %edx,%eax
  8031e8:	c1 e0 02             	shl    $0x2,%eax
  8031eb:	05 48 20 81 00       	add    $0x812048,%eax
  8031f0:	8a 00                	mov    (%eax),%al
  8031f2:	84 c0                	test   %al,%al
  8031f4:	74 3d                	je     803233 <realloc+0x4de>
  8031f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031f9:	89 d0                	mov    %edx,%eax
  8031fb:	01 c0                	add    %eax,%eax
  8031fd:	01 d0                	add    %edx,%eax
  8031ff:	c1 e0 02             	shl    $0x2,%eax
  803202:	05 40 20 81 00       	add    $0x812040,%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80320c:	75 25                	jne    803233 <realloc+0x4de>
  80320e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803211:	89 d0                	mov    %edx,%eax
  803213:	01 c0                	add    %eax,%eax
  803215:	01 d0                	add    %edx,%eax
  803217:	c1 e0 02             	shl    $0x2,%eax
  80321a:	05 44 20 81 00       	add    $0x812044,%eax
  80321f:	8b 10                	mov    (%eax),%edx
  803221:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803224:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803227:	39 c2                	cmp    %eax,%edx
  803229:	72 08                	jb     803233 <realloc+0x4de>
		{
			adjIdx = j; break;
  80322b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80322e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803231:	eb 0c                	jmp    80323f <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803233:	ff 45 d0             	incl   -0x30(%ebp)
  803236:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  80323d:	7e a0                	jle    8031df <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  80323f:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  803243:	0f 84 d6 00 00 00    	je     80331f <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  803249:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80324c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80324f:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  803252:	83 ec 08             	sub    $0x8,%esp
  803255:	ff 75 a0             	pushl  -0x60(%ebp)
  803258:	ff 75 a4             	pushl  -0x5c(%ebp)
  80325b:	e8 cf 09 00 00       	call   803c2f <sys_allocate_user_mem>
  803260:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  803263:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803266:	89 d0                	mov    %edx,%eax
  803268:	01 c0                	add    %eax,%eax
  80326a:	01 d0                	add    %edx,%eax
  80326c:	c1 e0 02             	shl    $0x2,%eax
  80326f:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  803275:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803278:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  80327a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80327d:	89 d0                	mov    %edx,%eax
  80327f:	01 c0                	add    %eax,%eax
  803281:	01 d0                	add    %edx,%eax
  803283:	c1 e0 02             	shl    $0x2,%eax
  803286:	05 40 20 81 00       	add    $0x812040,%eax
  80328b:	8b 10                	mov    (%eax),%edx
  80328d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803290:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  803293:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803296:	89 d0                	mov    %edx,%eax
  803298:	01 c0                	add    %eax,%eax
  80329a:	01 d0                	add    %edx,%eax
  80329c:	c1 e0 02             	shl    $0x2,%eax
  80329f:	05 40 20 81 00       	add    $0x812040,%eax
  8032a4:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8032a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032a9:	89 d0                	mov    %edx,%eax
  8032ab:	01 c0                	add    %eax,%eax
  8032ad:	01 d0                	add    %edx,%eax
  8032af:	c1 e0 02             	shl    $0x2,%eax
  8032b2:	05 44 20 81 00       	add    $0x812044,%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	2b 45 a0             	sub    -0x60(%ebp),%eax
  8032bc:	89 c2                	mov    %eax,%edx
  8032be:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8032c1:	89 c8                	mov    %ecx,%eax
  8032c3:	01 c0                	add    %eax,%eax
  8032c5:	01 c8                	add    %ecx,%eax
  8032c7:	c1 e0 02             	shl    $0x2,%eax
  8032ca:	05 44 20 81 00       	add    $0x812044,%eax
  8032cf:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  8032d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032d4:	89 d0                	mov    %edx,%eax
  8032d6:	01 c0                	add    %eax,%eax
  8032d8:	01 d0                	add    %edx,%eax
  8032da:	c1 e0 02             	shl    $0x2,%eax
  8032dd:	05 44 20 81 00       	add    $0x812044,%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	85 c0                	test   %eax,%eax
  8032e6:	75 14                	jne    8032fc <realloc+0x5a7>
  8032e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032eb:	89 d0                	mov    %edx,%eax
  8032ed:	01 c0                	add    %eax,%eax
  8032ef:	01 d0                	add    %edx,%eax
  8032f1:	c1 e0 02             	shl    $0x2,%eax
  8032f4:	05 48 20 81 00       	add    $0x812048,%eax
  8032f9:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  8032fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803302:	01 c2                	add    %eax,%edx
  803304:	a1 88 60 83 00       	mov    0x836088,%eax
  803309:	39 c2                	cmp    %eax,%edx
  80330b:	76 0d                	jbe    80331a <realloc+0x5c5>
  80330d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803310:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803313:	01 d0                	add    %edx,%eax
  803315:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	eb 4e                	jmp    80336d <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  80331f:	83 ec 0c             	sub    $0xc,%esp
  803322:	ff 75 0c             	pushl  0xc(%ebp)
  803325:	e8 0b ec ff ff       	call   801f35 <malloc>
  80332a:	83 c4 10             	add    $0x10,%esp
  80332d:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  803330:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  803334:	75 07                	jne    80333d <realloc+0x5e8>
		return NULL;
  803336:	b8 00 00 00 00       	mov    $0x0,%eax
  80333b:	eb 30                	jmp    80336d <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  80333d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803340:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803343:	39 d0                	cmp    %edx,%eax
  803345:	76 02                	jbe    803349 <realloc+0x5f4>
  803347:	89 d0                	mov    %edx,%eax
  803349:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80334c:	83 ec 04             	sub    $0x4,%esp
  80334f:	50                   	push   %eax
  803350:	52                   	push   %edx
  803351:	ff 75 cc             	pushl  -0x34(%ebp)
  803354:	e8 cf 06 00 00       	call   803a28 <sys_move_user_mem>
  803359:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  80335c:	83 ec 0c             	sub    $0xc,%esp
  80335f:	ff 75 08             	pushl  0x8(%ebp)
  803362:	e8 2e ef ff ff       	call   802295 <free>
  803367:	83 c4 10             	add    $0x10,%esp
	return newptr;
  80336a:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  80336d:	c9                   	leave  
  80336e:	c3                   	ret    

0080336f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80336f:	55                   	push   %ebp
  803370:	89 e5                	mov    %esp,%ebp
  803372:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  80337b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80337f:	0f 84 33 03 00 00    	je     8036b8 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  803385:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803388:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  80338d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  803390:	83 ec 08             	sub    $0x8,%esp
  803393:	ff 75 08             	pushl  0x8(%ebp)
  803396:	ff 75 d8             	pushl  -0x28(%ebp)
  803399:	e8 7d 05 00 00       	call   80391b <sys_delete_shared_object>
  80339e:	83 c4 10             	add    $0x10,%esp
  8033a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8033a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033a8:	0f 88 0d 03 00 00    	js     8036bb <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8033ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033b5:	e9 ef 02 00 00       	jmp    8036a9 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8033ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033bd:	89 d0                	mov    %edx,%eax
  8033bf:	01 c0                	add    %eax,%eax
  8033c1:	01 d0                	add    %edx,%eax
  8033c3:	c1 e0 02             	shl    $0x2,%eax
  8033c6:	05 48 60 80 00       	add    $0x806048,%eax
  8033cb:	8a 00                	mov    (%eax),%al
  8033cd:	84 c0                	test   %al,%al
  8033cf:	0f 84 d1 02 00 00    	je     8036a6 <sfree+0x337>
  8033d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d8:	89 d0                	mov    %edx,%eax
  8033da:	01 c0                	add    %eax,%eax
  8033dc:	01 d0                	add    %edx,%eax
  8033de:	c1 e0 02             	shl    $0x2,%eax
  8033e1:	05 40 60 80 00       	add    $0x806040,%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8033eb:	0f 85 b5 02 00 00    	jne    8036a6 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  8033f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f4:	89 d0                	mov    %edx,%eax
  8033f6:	01 c0                	add    %eax,%eax
  8033f8:	01 d0                	add    %edx,%eax
  8033fa:	c1 e0 02             	shl    $0x2,%eax
  8033fd:	05 44 60 80 00       	add    $0x806044,%eax
  803402:	8b 00                	mov    (%eax),%eax
  803404:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80340a:	89 d0                	mov    %edx,%eax
  80340c:	01 c0                	add    %eax,%eax
  80340e:	01 d0                	add    %edx,%eax
  803410:	c1 e0 02             	shl    $0x2,%eax
  803413:	05 48 60 80 00       	add    $0x806048,%eax
  803418:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  80341b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803422:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803429:	eb 64                	jmp    80348f <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  80342b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80342e:	89 d0                	mov    %edx,%eax
  803430:	01 c0                	add    %eax,%eax
  803432:	01 d0                	add    %edx,%eax
  803434:	c1 e0 02             	shl    $0x2,%eax
  803437:	05 48 20 81 00       	add    $0x812048,%eax
  80343c:	8a 00                	mov    (%eax),%al
  80343e:	84 c0                	test   %al,%al
  803440:	75 4a                	jne    80348c <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  803442:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803445:	89 d0                	mov    %edx,%eax
  803447:	01 c0                	add    %eax,%eax
  803449:	01 d0                	add    %edx,%eax
  80344b:	c1 e0 02             	shl    $0x2,%eax
  80344e:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  803454:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803457:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  803459:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80345c:	89 d0                	mov    %edx,%eax
  80345e:	01 c0                	add    %eax,%eax
  803460:	01 d0                	add    %edx,%eax
  803462:	c1 e0 02             	shl    $0x2,%eax
  803465:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  80346b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80346e:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  803470:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803473:	89 d0                	mov    %edx,%eax
  803475:	01 c0                	add    %eax,%eax
  803477:	01 d0                	add    %edx,%eax
  803479:	c1 e0 02             	shl    $0x2,%eax
  80347c:	05 48 20 81 00       	add    $0x812048,%eax
  803481:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  803484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803487:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  80348a:	eb 0c                	jmp    803498 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80348c:	ff 45 ec             	incl   -0x14(%ebp)
  80348f:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803496:	7e 93                	jle    80342b <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  803498:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80349c:	0f 84 8d 01 00 00    	je     80362f <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8034a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8034a9:	e9 74 01 00 00       	jmp    803622 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  8034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034b4:	0f 84 64 01 00 00    	je     80361e <sfree+0x2af>
					if (uhp_frees[k].free)
  8034ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034bd:	89 d0                	mov    %edx,%eax
  8034bf:	01 c0                	add    %eax,%eax
  8034c1:	01 d0                	add    %edx,%eax
  8034c3:	c1 e0 02             	shl    $0x2,%eax
  8034c6:	05 48 20 81 00       	add    $0x812048,%eax
  8034cb:	8a 00                	mov    (%eax),%al
  8034cd:	84 c0                	test   %al,%al
  8034cf:	0f 84 4a 01 00 00    	je     80361f <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8034d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034d8:	89 d0                	mov    %edx,%eax
  8034da:	01 c0                	add    %eax,%eax
  8034dc:	01 d0                	add    %edx,%eax
  8034de:	c1 e0 02             	shl    $0x2,%eax
  8034e1:	05 40 20 81 00       	add    $0x812040,%eax
  8034e6:	8b 08                	mov    (%eax),%ecx
  8034e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034eb:	89 d0                	mov    %edx,%eax
  8034ed:	01 c0                	add    %eax,%eax
  8034ef:	01 d0                	add    %edx,%eax
  8034f1:	c1 e0 02             	shl    $0x2,%eax
  8034f4:	05 44 20 81 00       	add    $0x812044,%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	01 c1                	add    %eax,%ecx
  8034fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803500:	89 d0                	mov    %edx,%eax
  803502:	01 c0                	add    %eax,%eax
  803504:	01 d0                	add    %edx,%eax
  803506:	c1 e0 02             	shl    $0x2,%eax
  803509:	05 40 20 81 00       	add    $0x812040,%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	39 c1                	cmp    %eax,%ecx
  803512:	75 7a                	jne    80358e <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  803514:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803517:	89 d0                	mov    %edx,%eax
  803519:	01 c0                	add    %eax,%eax
  80351b:	01 d0                	add    %edx,%eax
  80351d:	c1 e0 02             	shl    $0x2,%eax
  803520:	05 40 20 81 00       	add    $0x812040,%eax
  803525:	8b 10                	mov    (%eax),%edx
  803527:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80352a:	89 c8                	mov    %ecx,%eax
  80352c:	01 c0                	add    %eax,%eax
  80352e:	01 c8                	add    %ecx,%eax
  803530:	c1 e0 02             	shl    $0x2,%eax
  803533:	05 40 20 81 00       	add    $0x812040,%eax
  803538:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  80353a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353d:	89 d0                	mov    %edx,%eax
  80353f:	01 c0                	add    %eax,%eax
  803541:	01 d0                	add    %edx,%eax
  803543:	c1 e0 02             	shl    $0x2,%eax
  803546:	05 44 20 81 00       	add    $0x812044,%eax
  80354b:	8b 08                	mov    (%eax),%ecx
  80354d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803550:	89 d0                	mov    %edx,%eax
  803552:	01 c0                	add    %eax,%eax
  803554:	01 d0                	add    %edx,%eax
  803556:	c1 e0 02             	shl    $0x2,%eax
  803559:	05 44 20 81 00       	add    $0x812044,%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	01 c1                	add    %eax,%ecx
  803562:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803565:	89 d0                	mov    %edx,%eax
  803567:	01 c0                	add    %eax,%eax
  803569:	01 d0                	add    %edx,%eax
  80356b:	c1 e0 02             	shl    $0x2,%eax
  80356e:	05 44 20 81 00       	add    $0x812044,%eax
  803573:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803575:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803578:	89 d0                	mov    %edx,%eax
  80357a:	01 c0                	add    %eax,%eax
  80357c:	01 d0                	add    %edx,%eax
  80357e:	c1 e0 02             	shl    $0x2,%eax
  803581:	05 48 20 81 00       	add    $0x812048,%eax
  803586:	c6 00 00             	movb   $0x0,(%eax)
  803589:	e9 91 00 00 00       	jmp    80361f <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80358e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803591:	89 d0                	mov    %edx,%eax
  803593:	01 c0                	add    %eax,%eax
  803595:	01 d0                	add    %edx,%eax
  803597:	c1 e0 02             	shl    $0x2,%eax
  80359a:	05 40 20 81 00       	add    $0x812040,%eax
  80359f:	8b 08                	mov    (%eax),%ecx
  8035a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a4:	89 d0                	mov    %edx,%eax
  8035a6:	01 c0                	add    %eax,%eax
  8035a8:	01 d0                	add    %edx,%eax
  8035aa:	c1 e0 02             	shl    $0x2,%eax
  8035ad:	05 44 20 81 00       	add    $0x812044,%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	01 c1                	add    %eax,%ecx
  8035b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035b9:	89 d0                	mov    %edx,%eax
  8035bb:	01 c0                	add    %eax,%eax
  8035bd:	01 d0                	add    %edx,%eax
  8035bf:	c1 e0 02             	shl    $0x2,%eax
  8035c2:	05 40 20 81 00       	add    $0x812040,%eax
  8035c7:	8b 00                	mov    (%eax),%eax
  8035c9:	39 c1                	cmp    %eax,%ecx
  8035cb:	75 52                	jne    80361f <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  8035cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d0:	89 d0                	mov    %edx,%eax
  8035d2:	01 c0                	add    %eax,%eax
  8035d4:	01 d0                	add    %edx,%eax
  8035d6:	c1 e0 02             	shl    $0x2,%eax
  8035d9:	05 44 20 81 00       	add    $0x812044,%eax
  8035de:	8b 08                	mov    (%eax),%ecx
  8035e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035e3:	89 d0                	mov    %edx,%eax
  8035e5:	01 c0                	add    %eax,%eax
  8035e7:	01 d0                	add    %edx,%eax
  8035e9:	c1 e0 02             	shl    $0x2,%eax
  8035ec:	05 44 20 81 00       	add    $0x812044,%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	01 c1                	add    %eax,%ecx
  8035f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f8:	89 d0                	mov    %edx,%eax
  8035fa:	01 c0                	add    %eax,%eax
  8035fc:	01 d0                	add    %edx,%eax
  8035fe:	c1 e0 02             	shl    $0x2,%eax
  803601:	05 44 20 81 00       	add    $0x812044,%eax
  803606:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803608:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80360b:	89 d0                	mov    %edx,%eax
  80360d:	01 c0                	add    %eax,%eax
  80360f:	01 d0                	add    %edx,%eax
  803611:	c1 e0 02             	shl    $0x2,%eax
  803614:	05 48 20 81 00       	add    $0x812048,%eax
  803619:	c6 00 00             	movb   $0x0,(%eax)
  80361c:	eb 01                	jmp    80361f <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  80361e:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80361f:	ff 45 e8             	incl   -0x18(%ebp)
  803622:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803629:	0f 8e 7f fe ff ff    	jle    8034ae <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  80362f:	a1 30 61 83 00       	mov    0x836130,%eax
  803634:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803637:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80363e:	eb 53                	jmp    803693 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803640:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803643:	89 d0                	mov    %edx,%eax
  803645:	01 c0                	add    %eax,%eax
  803647:	01 d0                	add    %edx,%eax
  803649:	c1 e0 02             	shl    $0x2,%eax
  80364c:	05 48 60 80 00       	add    $0x806048,%eax
  803651:	8a 00                	mov    (%eax),%al
  803653:	84 c0                	test   %al,%al
  803655:	74 39                	je     803690 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803657:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80365a:	89 d0                	mov    %edx,%eax
  80365c:	01 c0                	add    %eax,%eax
  80365e:	01 d0                	add    %edx,%eax
  803660:	c1 e0 02             	shl    $0x2,%eax
  803663:	05 40 60 80 00       	add    $0x806040,%eax
  803668:	8b 08                	mov    (%eax),%ecx
  80366a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80366d:	89 d0                	mov    %edx,%eax
  80366f:	01 c0                	add    %eax,%eax
  803671:	01 d0                	add    %edx,%eax
  803673:	c1 e0 02             	shl    $0x2,%eax
  803676:	05 44 60 80 00       	add    $0x806044,%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	01 c8                	add    %ecx,%eax
  80367f:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803682:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803685:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803688:	76 06                	jbe    803690 <sfree+0x321>
  80368a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80368d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803690:	ff 45 e0             	incl   -0x20(%ebp)
  803693:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80369a:	7e a4                	jle    803640 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  80369c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369f:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  8036a4:	eb 16                	jmp    8036bc <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8036a6:	ff 45 f4             	incl   -0xc(%ebp)
  8036a9:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  8036b0:	0f 8e 04 fd ff ff    	jle    8033ba <sfree+0x4b>
  8036b6:	eb 04                	jmp    8036bc <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  8036b8:	90                   	nop
  8036b9:	eb 01                	jmp    8036bc <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  8036bb:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  8036bc:	c9                   	leave  
  8036bd:	c3                   	ret    

008036be <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8036be:	55                   	push   %ebp
  8036bf:	89 e5                	mov    %esp,%ebp
  8036c1:	57                   	push   %edi
  8036c2:	56                   	push   %esi
  8036c3:	53                   	push   %ebx
  8036c4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8036d3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8036d6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8036d9:	cd 30                	int    $0x30
  8036db:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8036de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8036e1:	83 c4 10             	add    $0x10,%esp
  8036e4:	5b                   	pop    %ebx
  8036e5:	5e                   	pop    %esi
  8036e6:	5f                   	pop    %edi
  8036e7:	5d                   	pop    %ebp
  8036e8:	c3                   	ret    

008036e9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8036e9:	55                   	push   %ebp
  8036ea:	89 e5                	mov    %esp,%ebp
  8036ec:	83 ec 04             	sub    $0x4,%esp
  8036ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8036f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8036f5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8036f8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8036fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ff:	6a 00                	push   $0x0
  803701:	51                   	push   %ecx
  803702:	52                   	push   %edx
  803703:	ff 75 0c             	pushl  0xc(%ebp)
  803706:	50                   	push   %eax
  803707:	6a 00                	push   $0x0
  803709:	e8 b0 ff ff ff       	call   8036be <syscall>
  80370e:	83 c4 18             	add    $0x18,%esp
}
  803711:	90                   	nop
  803712:	c9                   	leave  
  803713:	c3                   	ret    

00803714 <sys_cgetc>:

int
sys_cgetc(void)
{
  803714:	55                   	push   %ebp
  803715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803717:	6a 00                	push   $0x0
  803719:	6a 00                	push   $0x0
  80371b:	6a 00                	push   $0x0
  80371d:	6a 00                	push   $0x0
  80371f:	6a 00                	push   $0x0
  803721:	6a 02                	push   $0x2
  803723:	e8 96 ff ff ff       	call   8036be <syscall>
  803728:	83 c4 18             	add    $0x18,%esp
}
  80372b:	c9                   	leave  
  80372c:	c3                   	ret    

0080372d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80372d:	55                   	push   %ebp
  80372e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803730:	6a 00                	push   $0x0
  803732:	6a 00                	push   $0x0
  803734:	6a 00                	push   $0x0
  803736:	6a 00                	push   $0x0
  803738:	6a 00                	push   $0x0
  80373a:	6a 03                	push   $0x3
  80373c:	e8 7d ff ff ff       	call   8036be <syscall>
  803741:	83 c4 18             	add    $0x18,%esp
}
  803744:	90                   	nop
  803745:	c9                   	leave  
  803746:	c3                   	ret    

00803747 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803747:	55                   	push   %ebp
  803748:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80374a:	6a 00                	push   $0x0
  80374c:	6a 00                	push   $0x0
  80374e:	6a 00                	push   $0x0
  803750:	6a 00                	push   $0x0
  803752:	6a 00                	push   $0x0
  803754:	6a 04                	push   $0x4
  803756:	e8 63 ff ff ff       	call   8036be <syscall>
  80375b:	83 c4 18             	add    $0x18,%esp
}
  80375e:	90                   	nop
  80375f:	c9                   	leave  
  803760:	c3                   	ret    

00803761 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803761:	55                   	push   %ebp
  803762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803764:	8b 55 0c             	mov    0xc(%ebp),%edx
  803767:	8b 45 08             	mov    0x8(%ebp),%eax
  80376a:	6a 00                	push   $0x0
  80376c:	6a 00                	push   $0x0
  80376e:	6a 00                	push   $0x0
  803770:	52                   	push   %edx
  803771:	50                   	push   %eax
  803772:	6a 08                	push   $0x8
  803774:	e8 45 ff ff ff       	call   8036be <syscall>
  803779:	83 c4 18             	add    $0x18,%esp
}
  80377c:	c9                   	leave  
  80377d:	c3                   	ret    

0080377e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80377e:	55                   	push   %ebp
  80377f:	89 e5                	mov    %esp,%ebp
  803781:	56                   	push   %esi
  803782:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803783:	8b 75 18             	mov    0x18(%ebp),%esi
  803786:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803789:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80378c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	56                   	push   %esi
  803793:	53                   	push   %ebx
  803794:	51                   	push   %ecx
  803795:	52                   	push   %edx
  803796:	50                   	push   %eax
  803797:	6a 09                	push   $0x9
  803799:	e8 20 ff ff ff       	call   8036be <syscall>
  80379e:	83 c4 18             	add    $0x18,%esp
}
  8037a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8037a4:	5b                   	pop    %ebx
  8037a5:	5e                   	pop    %esi
  8037a6:	5d                   	pop    %ebp
  8037a7:	c3                   	ret    

008037a8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8037a8:	55                   	push   %ebp
  8037a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8037ab:	6a 00                	push   $0x0
  8037ad:	6a 00                	push   $0x0
  8037af:	6a 00                	push   $0x0
  8037b1:	6a 00                	push   $0x0
  8037b3:	ff 75 08             	pushl  0x8(%ebp)
  8037b6:	6a 0a                	push   $0xa
  8037b8:	e8 01 ff ff ff       	call   8036be <syscall>
  8037bd:	83 c4 18             	add    $0x18,%esp
}
  8037c0:	c9                   	leave  
  8037c1:	c3                   	ret    

008037c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8037c2:	55                   	push   %ebp
  8037c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8037c5:	6a 00                	push   $0x0
  8037c7:	6a 00                	push   $0x0
  8037c9:	6a 00                	push   $0x0
  8037cb:	ff 75 0c             	pushl  0xc(%ebp)
  8037ce:	ff 75 08             	pushl  0x8(%ebp)
  8037d1:	6a 0b                	push   $0xb
  8037d3:	e8 e6 fe ff ff       	call   8036be <syscall>
  8037d8:	83 c4 18             	add    $0x18,%esp
}
  8037db:	c9                   	leave  
  8037dc:	c3                   	ret    

008037dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8037dd:	55                   	push   %ebp
  8037de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8037e0:	6a 00                	push   $0x0
  8037e2:	6a 00                	push   $0x0
  8037e4:	6a 00                	push   $0x0
  8037e6:	6a 00                	push   $0x0
  8037e8:	6a 00                	push   $0x0
  8037ea:	6a 0c                	push   $0xc
  8037ec:	e8 cd fe ff ff       	call   8036be <syscall>
  8037f1:	83 c4 18             	add    $0x18,%esp
}
  8037f4:	c9                   	leave  
  8037f5:	c3                   	ret    

008037f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8037f6:	55                   	push   %ebp
  8037f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8037f9:	6a 00                	push   $0x0
  8037fb:	6a 00                	push   $0x0
  8037fd:	6a 00                	push   $0x0
  8037ff:	6a 00                	push   $0x0
  803801:	6a 00                	push   $0x0
  803803:	6a 0d                	push   $0xd
  803805:	e8 b4 fe ff ff       	call   8036be <syscall>
  80380a:	83 c4 18             	add    $0x18,%esp
}
  80380d:	c9                   	leave  
  80380e:	c3                   	ret    

0080380f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80380f:	55                   	push   %ebp
  803810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803812:	6a 00                	push   $0x0
  803814:	6a 00                	push   $0x0
  803816:	6a 00                	push   $0x0
  803818:	6a 00                	push   $0x0
  80381a:	6a 00                	push   $0x0
  80381c:	6a 0e                	push   $0xe
  80381e:	e8 9b fe ff ff       	call   8036be <syscall>
  803823:	83 c4 18             	add    $0x18,%esp
}
  803826:	c9                   	leave  
  803827:	c3                   	ret    

00803828 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803828:	55                   	push   %ebp
  803829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80382b:	6a 00                	push   $0x0
  80382d:	6a 00                	push   $0x0
  80382f:	6a 00                	push   $0x0
  803831:	6a 00                	push   $0x0
  803833:	6a 00                	push   $0x0
  803835:	6a 0f                	push   $0xf
  803837:	e8 82 fe ff ff       	call   8036be <syscall>
  80383c:	83 c4 18             	add    $0x18,%esp
}
  80383f:	c9                   	leave  
  803840:	c3                   	ret    

00803841 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803841:	55                   	push   %ebp
  803842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803844:	6a 00                	push   $0x0
  803846:	6a 00                	push   $0x0
  803848:	6a 00                	push   $0x0
  80384a:	6a 00                	push   $0x0
  80384c:	ff 75 08             	pushl  0x8(%ebp)
  80384f:	6a 10                	push   $0x10
  803851:	e8 68 fe ff ff       	call   8036be <syscall>
  803856:	83 c4 18             	add    $0x18,%esp
}
  803859:	c9                   	leave  
  80385a:	c3                   	ret    

0080385b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80385b:	55                   	push   %ebp
  80385c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80385e:	6a 00                	push   $0x0
  803860:	6a 00                	push   $0x0
  803862:	6a 00                	push   $0x0
  803864:	6a 00                	push   $0x0
  803866:	6a 00                	push   $0x0
  803868:	6a 11                	push   $0x11
  80386a:	e8 4f fe ff ff       	call   8036be <syscall>
  80386f:	83 c4 18             	add    $0x18,%esp
}
  803872:	90                   	nop
  803873:	c9                   	leave  
  803874:	c3                   	ret    

00803875 <sys_cputc>:

void
sys_cputc(const char c)
{
  803875:	55                   	push   %ebp
  803876:	89 e5                	mov    %esp,%ebp
  803878:	83 ec 04             	sub    $0x4,%esp
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803881:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803885:	6a 00                	push   $0x0
  803887:	6a 00                	push   $0x0
  803889:	6a 00                	push   $0x0
  80388b:	6a 00                	push   $0x0
  80388d:	50                   	push   %eax
  80388e:	6a 01                	push   $0x1
  803890:	e8 29 fe ff ff       	call   8036be <syscall>
  803895:	83 c4 18             	add    $0x18,%esp
}
  803898:	90                   	nop
  803899:	c9                   	leave  
  80389a:	c3                   	ret    

0080389b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80389b:	55                   	push   %ebp
  80389c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80389e:	6a 00                	push   $0x0
  8038a0:	6a 00                	push   $0x0
  8038a2:	6a 00                	push   $0x0
  8038a4:	6a 00                	push   $0x0
  8038a6:	6a 00                	push   $0x0
  8038a8:	6a 14                	push   $0x14
  8038aa:	e8 0f fe ff ff       	call   8036be <syscall>
  8038af:	83 c4 18             	add    $0x18,%esp
}
  8038b2:	90                   	nop
  8038b3:	c9                   	leave  
  8038b4:	c3                   	ret    

008038b5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8038b5:	55                   	push   %ebp
  8038b6:	89 e5                	mov    %esp,%ebp
  8038b8:	83 ec 04             	sub    $0x4,%esp
  8038bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8038be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8038c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8038c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8038c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cb:	6a 00                	push   $0x0
  8038cd:	51                   	push   %ecx
  8038ce:	52                   	push   %edx
  8038cf:	ff 75 0c             	pushl  0xc(%ebp)
  8038d2:	50                   	push   %eax
  8038d3:	6a 15                	push   $0x15
  8038d5:	e8 e4 fd ff ff       	call   8036be <syscall>
  8038da:	83 c4 18             	add    $0x18,%esp
}
  8038dd:	c9                   	leave  
  8038de:	c3                   	ret    

008038df <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8038df:	55                   	push   %ebp
  8038e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8038e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e8:	6a 00                	push   $0x0
  8038ea:	6a 00                	push   $0x0
  8038ec:	6a 00                	push   $0x0
  8038ee:	52                   	push   %edx
  8038ef:	50                   	push   %eax
  8038f0:	6a 16                	push   $0x16
  8038f2:	e8 c7 fd ff ff       	call   8036be <syscall>
  8038f7:	83 c4 18             	add    $0x18,%esp
}
  8038fa:	c9                   	leave  
  8038fb:	c3                   	ret    

008038fc <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8038fc:	55                   	push   %ebp
  8038fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8038ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803902:	8b 55 0c             	mov    0xc(%ebp),%edx
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	6a 00                	push   $0x0
  80390a:	6a 00                	push   $0x0
  80390c:	51                   	push   %ecx
  80390d:	52                   	push   %edx
  80390e:	50                   	push   %eax
  80390f:	6a 17                	push   $0x17
  803911:	e8 a8 fd ff ff       	call   8036be <syscall>
  803916:	83 c4 18             	add    $0x18,%esp
}
  803919:	c9                   	leave  
  80391a:	c3                   	ret    

0080391b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80391b:	55                   	push   %ebp
  80391c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80391e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	6a 00                	push   $0x0
  803926:	6a 00                	push   $0x0
  803928:	6a 00                	push   $0x0
  80392a:	52                   	push   %edx
  80392b:	50                   	push   %eax
  80392c:	6a 18                	push   $0x18
  80392e:	e8 8b fd ff ff       	call   8036be <syscall>
  803933:	83 c4 18             	add    $0x18,%esp
}
  803936:	c9                   	leave  
  803937:	c3                   	ret    

00803938 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803938:	55                   	push   %ebp
  803939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	6a 00                	push   $0x0
  803940:	ff 75 14             	pushl  0x14(%ebp)
  803943:	ff 75 10             	pushl  0x10(%ebp)
  803946:	ff 75 0c             	pushl  0xc(%ebp)
  803949:	50                   	push   %eax
  80394a:	6a 19                	push   $0x19
  80394c:	e8 6d fd ff ff       	call   8036be <syscall>
  803951:	83 c4 18             	add    $0x18,%esp
}
  803954:	c9                   	leave  
  803955:	c3                   	ret    

00803956 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803956:	55                   	push   %ebp
  803957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803959:	8b 45 08             	mov    0x8(%ebp),%eax
  80395c:	6a 00                	push   $0x0
  80395e:	6a 00                	push   $0x0
  803960:	6a 00                	push   $0x0
  803962:	6a 00                	push   $0x0
  803964:	50                   	push   %eax
  803965:	6a 1a                	push   $0x1a
  803967:	e8 52 fd ff ff       	call   8036be <syscall>
  80396c:	83 c4 18             	add    $0x18,%esp
}
  80396f:	90                   	nop
  803970:	c9                   	leave  
  803971:	c3                   	ret    

00803972 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803972:	55                   	push   %ebp
  803973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803975:	8b 45 08             	mov    0x8(%ebp),%eax
  803978:	6a 00                	push   $0x0
  80397a:	6a 00                	push   $0x0
  80397c:	6a 00                	push   $0x0
  80397e:	6a 00                	push   $0x0
  803980:	50                   	push   %eax
  803981:	6a 1b                	push   $0x1b
  803983:	e8 36 fd ff ff       	call   8036be <syscall>
  803988:	83 c4 18             	add    $0x18,%esp
}
  80398b:	c9                   	leave  
  80398c:	c3                   	ret    

0080398d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80398d:	55                   	push   %ebp
  80398e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803990:	6a 00                	push   $0x0
  803992:	6a 00                	push   $0x0
  803994:	6a 00                	push   $0x0
  803996:	6a 00                	push   $0x0
  803998:	6a 00                	push   $0x0
  80399a:	6a 05                	push   $0x5
  80399c:	e8 1d fd ff ff       	call   8036be <syscall>
  8039a1:	83 c4 18             	add    $0x18,%esp
}
  8039a4:	c9                   	leave  
  8039a5:	c3                   	ret    

008039a6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8039a6:	55                   	push   %ebp
  8039a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8039a9:	6a 00                	push   $0x0
  8039ab:	6a 00                	push   $0x0
  8039ad:	6a 00                	push   $0x0
  8039af:	6a 00                	push   $0x0
  8039b1:	6a 00                	push   $0x0
  8039b3:	6a 06                	push   $0x6
  8039b5:	e8 04 fd ff ff       	call   8036be <syscall>
  8039ba:	83 c4 18             	add    $0x18,%esp
}
  8039bd:	c9                   	leave  
  8039be:	c3                   	ret    

008039bf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8039bf:	55                   	push   %ebp
  8039c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8039c2:	6a 00                	push   $0x0
  8039c4:	6a 00                	push   $0x0
  8039c6:	6a 00                	push   $0x0
  8039c8:	6a 00                	push   $0x0
  8039ca:	6a 00                	push   $0x0
  8039cc:	6a 07                	push   $0x7
  8039ce:	e8 eb fc ff ff       	call   8036be <syscall>
  8039d3:	83 c4 18             	add    $0x18,%esp
}
  8039d6:	c9                   	leave  
  8039d7:	c3                   	ret    

008039d8 <sys_exit_env>:


void sys_exit_env(void)
{
  8039d8:	55                   	push   %ebp
  8039d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8039db:	6a 00                	push   $0x0
  8039dd:	6a 00                	push   $0x0
  8039df:	6a 00                	push   $0x0
  8039e1:	6a 00                	push   $0x0
  8039e3:	6a 00                	push   $0x0
  8039e5:	6a 1c                	push   $0x1c
  8039e7:	e8 d2 fc ff ff       	call   8036be <syscall>
  8039ec:	83 c4 18             	add    $0x18,%esp
}
  8039ef:	90                   	nop
  8039f0:	c9                   	leave  
  8039f1:	c3                   	ret    

008039f2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8039f2:	55                   	push   %ebp
  8039f3:	89 e5                	mov    %esp,%ebp
  8039f5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8039f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8039fb:	8d 50 04             	lea    0x4(%eax),%edx
  8039fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803a01:	6a 00                	push   $0x0
  803a03:	6a 00                	push   $0x0
  803a05:	6a 00                	push   $0x0
  803a07:	52                   	push   %edx
  803a08:	50                   	push   %eax
  803a09:	6a 1d                	push   $0x1d
  803a0b:	e8 ae fc ff ff       	call   8036be <syscall>
  803a10:	83 c4 18             	add    $0x18,%esp
	return result;
  803a13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803a16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803a19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a1c:	89 01                	mov    %eax,(%ecx)
  803a1e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803a21:	8b 45 08             	mov    0x8(%ebp),%eax
  803a24:	c9                   	leave  
  803a25:	c2 04 00             	ret    $0x4

00803a28 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803a28:	55                   	push   %ebp
  803a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803a2b:	6a 00                	push   $0x0
  803a2d:	6a 00                	push   $0x0
  803a2f:	ff 75 10             	pushl  0x10(%ebp)
  803a32:	ff 75 0c             	pushl  0xc(%ebp)
  803a35:	ff 75 08             	pushl  0x8(%ebp)
  803a38:	6a 13                	push   $0x13
  803a3a:	e8 7f fc ff ff       	call   8036be <syscall>
  803a3f:	83 c4 18             	add    $0x18,%esp
	return ;
  803a42:	90                   	nop
}
  803a43:	c9                   	leave  
  803a44:	c3                   	ret    

00803a45 <sys_rcr2>:
uint32 sys_rcr2()
{
  803a45:	55                   	push   %ebp
  803a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803a48:	6a 00                	push   $0x0
  803a4a:	6a 00                	push   $0x0
  803a4c:	6a 00                	push   $0x0
  803a4e:	6a 00                	push   $0x0
  803a50:	6a 00                	push   $0x0
  803a52:	6a 1e                	push   $0x1e
  803a54:	e8 65 fc ff ff       	call   8036be <syscall>
  803a59:	83 c4 18             	add    $0x18,%esp
}
  803a5c:	c9                   	leave  
  803a5d:	c3                   	ret    

00803a5e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803a5e:	55                   	push   %ebp
  803a5f:	89 e5                	mov    %esp,%ebp
  803a61:	83 ec 04             	sub    $0x4,%esp
  803a64:	8b 45 08             	mov    0x8(%ebp),%eax
  803a67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803a6a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803a6e:	6a 00                	push   $0x0
  803a70:	6a 00                	push   $0x0
  803a72:	6a 00                	push   $0x0
  803a74:	6a 00                	push   $0x0
  803a76:	50                   	push   %eax
  803a77:	6a 1f                	push   $0x1f
  803a79:	e8 40 fc ff ff       	call   8036be <syscall>
  803a7e:	83 c4 18             	add    $0x18,%esp
	return ;
  803a81:	90                   	nop
}
  803a82:	c9                   	leave  
  803a83:	c3                   	ret    

00803a84 <rsttst>:
void rsttst()
{
  803a84:	55                   	push   %ebp
  803a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803a87:	6a 00                	push   $0x0
  803a89:	6a 00                	push   $0x0
  803a8b:	6a 00                	push   $0x0
  803a8d:	6a 00                	push   $0x0
  803a8f:	6a 00                	push   $0x0
  803a91:	6a 21                	push   $0x21
  803a93:	e8 26 fc ff ff       	call   8036be <syscall>
  803a98:	83 c4 18             	add    $0x18,%esp
	return ;
  803a9b:	90                   	nop
}
  803a9c:	c9                   	leave  
  803a9d:	c3                   	ret    

00803a9e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803a9e:	55                   	push   %ebp
  803a9f:	89 e5                	mov    %esp,%ebp
  803aa1:	83 ec 04             	sub    $0x4,%esp
  803aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  803aa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803aaa:	8b 55 18             	mov    0x18(%ebp),%edx
  803aad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803ab1:	52                   	push   %edx
  803ab2:	50                   	push   %eax
  803ab3:	ff 75 10             	pushl  0x10(%ebp)
  803ab6:	ff 75 0c             	pushl  0xc(%ebp)
  803ab9:	ff 75 08             	pushl  0x8(%ebp)
  803abc:	6a 20                	push   $0x20
  803abe:	e8 fb fb ff ff       	call   8036be <syscall>
  803ac3:	83 c4 18             	add    $0x18,%esp
	return ;
  803ac6:	90                   	nop
}
  803ac7:	c9                   	leave  
  803ac8:	c3                   	ret    

00803ac9 <chktst>:
void chktst(uint32 n)
{
  803ac9:	55                   	push   %ebp
  803aca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803acc:	6a 00                	push   $0x0
  803ace:	6a 00                	push   $0x0
  803ad0:	6a 00                	push   $0x0
  803ad2:	6a 00                	push   $0x0
  803ad4:	ff 75 08             	pushl  0x8(%ebp)
  803ad7:	6a 22                	push   $0x22
  803ad9:	e8 e0 fb ff ff       	call   8036be <syscall>
  803ade:	83 c4 18             	add    $0x18,%esp
	return ;
  803ae1:	90                   	nop
}
  803ae2:	c9                   	leave  
  803ae3:	c3                   	ret    

00803ae4 <inctst>:

void inctst()
{
  803ae4:	55                   	push   %ebp
  803ae5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803ae7:	6a 00                	push   $0x0
  803ae9:	6a 00                	push   $0x0
  803aeb:	6a 00                	push   $0x0
  803aed:	6a 00                	push   $0x0
  803aef:	6a 00                	push   $0x0
  803af1:	6a 23                	push   $0x23
  803af3:	e8 c6 fb ff ff       	call   8036be <syscall>
  803af8:	83 c4 18             	add    $0x18,%esp
	return ;
  803afb:	90                   	nop
}
  803afc:	c9                   	leave  
  803afd:	c3                   	ret    

00803afe <gettst>:
uint32 gettst()
{
  803afe:	55                   	push   %ebp
  803aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803b01:	6a 00                	push   $0x0
  803b03:	6a 00                	push   $0x0
  803b05:	6a 00                	push   $0x0
  803b07:	6a 00                	push   $0x0
  803b09:	6a 00                	push   $0x0
  803b0b:	6a 24                	push   $0x24
  803b0d:	e8 ac fb ff ff       	call   8036be <syscall>
  803b12:	83 c4 18             	add    $0x18,%esp
}
  803b15:	c9                   	leave  
  803b16:	c3                   	ret    

00803b17 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803b17:	55                   	push   %ebp
  803b18:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803b1a:	6a 00                	push   $0x0
  803b1c:	6a 00                	push   $0x0
  803b1e:	6a 00                	push   $0x0
  803b20:	6a 00                	push   $0x0
  803b22:	6a 00                	push   $0x0
  803b24:	6a 25                	push   $0x25
  803b26:	e8 93 fb ff ff       	call   8036be <syscall>
  803b2b:	83 c4 18             	add    $0x18,%esp
  803b2e:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  803b33:	a1 80 60 83 00       	mov    0x836080,%eax
}
  803b38:	c9                   	leave  
  803b39:	c3                   	ret    

00803b3a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803b3a:	55                   	push   %ebp
  803b3b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b40:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803b45:	6a 00                	push   $0x0
  803b47:	6a 00                	push   $0x0
  803b49:	6a 00                	push   $0x0
  803b4b:	6a 00                	push   $0x0
  803b4d:	ff 75 08             	pushl  0x8(%ebp)
  803b50:	6a 26                	push   $0x26
  803b52:	e8 67 fb ff ff       	call   8036be <syscall>
  803b57:	83 c4 18             	add    $0x18,%esp
	return ;
  803b5a:	90                   	nop
}
  803b5b:	c9                   	leave  
  803b5c:	c3                   	ret    

00803b5d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803b5d:	55                   	push   %ebp
  803b5e:	89 e5                	mov    %esp,%ebp
  803b60:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803b61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803b64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6d:	6a 00                	push   $0x0
  803b6f:	53                   	push   %ebx
  803b70:	51                   	push   %ecx
  803b71:	52                   	push   %edx
  803b72:	50                   	push   %eax
  803b73:	6a 27                	push   $0x27
  803b75:	e8 44 fb ff ff       	call   8036be <syscall>
  803b7a:	83 c4 18             	add    $0x18,%esp
}
  803b7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803b80:	c9                   	leave  
  803b81:	c3                   	ret    

00803b82 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803b82:	55                   	push   %ebp
  803b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b88:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8b:	6a 00                	push   $0x0
  803b8d:	6a 00                	push   $0x0
  803b8f:	6a 00                	push   $0x0
  803b91:	52                   	push   %edx
  803b92:	50                   	push   %eax
  803b93:	6a 28                	push   $0x28
  803b95:	e8 24 fb ff ff       	call   8036be <syscall>
  803b9a:	83 c4 18             	add    $0x18,%esp
}
  803b9d:	c9                   	leave  
  803b9e:	c3                   	ret    

00803b9f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803b9f:	55                   	push   %ebp
  803ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803ba2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bab:	6a 00                	push   $0x0
  803bad:	51                   	push   %ecx
  803bae:	ff 75 10             	pushl  0x10(%ebp)
  803bb1:	52                   	push   %edx
  803bb2:	50                   	push   %eax
  803bb3:	6a 29                	push   $0x29
  803bb5:	e8 04 fb ff ff       	call   8036be <syscall>
  803bba:	83 c4 18             	add    $0x18,%esp
}
  803bbd:	c9                   	leave  
  803bbe:	c3                   	ret    

00803bbf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803bbf:	55                   	push   %ebp
  803bc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803bc2:	6a 00                	push   $0x0
  803bc4:	6a 00                	push   $0x0
  803bc6:	ff 75 10             	pushl  0x10(%ebp)
  803bc9:	ff 75 0c             	pushl  0xc(%ebp)
  803bcc:	ff 75 08             	pushl  0x8(%ebp)
  803bcf:	6a 12                	push   $0x12
  803bd1:	e8 e8 fa ff ff       	call   8036be <syscall>
  803bd6:	83 c4 18             	add    $0x18,%esp
	return ;
  803bd9:	90                   	nop
}
  803bda:	c9                   	leave  
  803bdb:	c3                   	ret    

00803bdc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803bdc:	55                   	push   %ebp
  803bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  803be2:	8b 45 08             	mov    0x8(%ebp),%eax
  803be5:	6a 00                	push   $0x0
  803be7:	6a 00                	push   $0x0
  803be9:	6a 00                	push   $0x0
  803beb:	52                   	push   %edx
  803bec:	50                   	push   %eax
  803bed:	6a 2a                	push   $0x2a
  803bef:	e8 ca fa ff ff       	call   8036be <syscall>
  803bf4:	83 c4 18             	add    $0x18,%esp
	return;
  803bf7:	90                   	nop
}
  803bf8:	c9                   	leave  
  803bf9:	c3                   	ret    

00803bfa <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803bfa:	55                   	push   %ebp
  803bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803bfd:	6a 00                	push   $0x0
  803bff:	6a 00                	push   $0x0
  803c01:	6a 00                	push   $0x0
  803c03:	6a 00                	push   $0x0
  803c05:	6a 00                	push   $0x0
  803c07:	6a 2b                	push   $0x2b
  803c09:	e8 b0 fa ff ff       	call   8036be <syscall>
  803c0e:	83 c4 18             	add    $0x18,%esp
}
  803c11:	c9                   	leave  
  803c12:	c3                   	ret    

00803c13 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803c13:	55                   	push   %ebp
  803c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803c16:	6a 00                	push   $0x0
  803c18:	6a 00                	push   $0x0
  803c1a:	6a 00                	push   $0x0
  803c1c:	ff 75 0c             	pushl  0xc(%ebp)
  803c1f:	ff 75 08             	pushl  0x8(%ebp)
  803c22:	6a 2d                	push   $0x2d
  803c24:	e8 95 fa ff ff       	call   8036be <syscall>
  803c29:	83 c4 18             	add    $0x18,%esp
	return;
  803c2c:	90                   	nop
}
  803c2d:	c9                   	leave  
  803c2e:	c3                   	ret    

00803c2f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803c2f:	55                   	push   %ebp
  803c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803c32:	6a 00                	push   $0x0
  803c34:	6a 00                	push   $0x0
  803c36:	6a 00                	push   $0x0
  803c38:	ff 75 0c             	pushl  0xc(%ebp)
  803c3b:	ff 75 08             	pushl  0x8(%ebp)
  803c3e:	6a 2c                	push   $0x2c
  803c40:	e8 79 fa ff ff       	call   8036be <syscall>
  803c45:	83 c4 18             	add    $0x18,%esp
	return ;
  803c48:	90                   	nop
}
  803c49:	c9                   	leave  
  803c4a:	c3                   	ret    

00803c4b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803c4b:	55                   	push   %ebp
  803c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c51:	8b 45 08             	mov    0x8(%ebp),%eax
  803c54:	6a 00                	push   $0x0
  803c56:	6a 00                	push   $0x0
  803c58:	6a 00                	push   $0x0
  803c5a:	52                   	push   %edx
  803c5b:	50                   	push   %eax
  803c5c:	6a 2e                	push   $0x2e
  803c5e:	e8 5b fa ff ff       	call   8036be <syscall>
  803c63:	83 c4 18             	add    $0x18,%esp
}
  803c66:	90                   	nop
  803c67:	c9                   	leave  
  803c68:	c3                   	ret    

00803c69 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803c69:	55                   	push   %ebp
  803c6a:	89 e5                	mov    %esp,%ebp
  803c6c:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803c6f:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803c76:	72 09                	jb     803c81 <to_page_va+0x18>
  803c78:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803c7f:	72 14                	jb     803c95 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803c81:	83 ec 04             	sub    $0x4,%esp
  803c84:	68 cc 54 80 00       	push   $0x8054cc
  803c89:	6a 15                	push   $0x15
  803c8b:	68 f7 54 80 00       	push   $0x8054f7
  803c90:	e8 08 ce ff ff       	call   800a9d <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803c95:	8b 45 08             	mov    0x8(%ebp),%eax
  803c98:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803c9d:	29 d0                	sub    %edx,%eax
  803c9f:	c1 f8 02             	sar    $0x2,%eax
  803ca2:	89 c2                	mov    %eax,%edx
  803ca4:	89 d0                	mov    %edx,%eax
  803ca6:	c1 e0 02             	shl    $0x2,%eax
  803ca9:	01 d0                	add    %edx,%eax
  803cab:	c1 e0 02             	shl    $0x2,%eax
  803cae:	01 d0                	add    %edx,%eax
  803cb0:	c1 e0 02             	shl    $0x2,%eax
  803cb3:	01 d0                	add    %edx,%eax
  803cb5:	89 c1                	mov    %eax,%ecx
  803cb7:	c1 e1 08             	shl    $0x8,%ecx
  803cba:	01 c8                	add    %ecx,%eax
  803cbc:	89 c1                	mov    %eax,%ecx
  803cbe:	c1 e1 10             	shl    $0x10,%ecx
  803cc1:	01 c8                	add    %ecx,%eax
  803cc3:	01 c0                	add    %eax,%eax
  803cc5:	01 d0                	add    %edx,%eax
  803cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccd:	c1 e0 0c             	shl    $0xc,%eax
  803cd0:	89 c2                	mov    %eax,%edx
  803cd2:	a1 84 60 83 00       	mov    0x836084,%eax
  803cd7:	01 d0                	add    %edx,%eax
}
  803cd9:	c9                   	leave  
  803cda:	c3                   	ret    

00803cdb <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803cdb:	55                   	push   %ebp
  803cdc:	89 e5                	mov    %esp,%ebp
  803cde:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803ce1:	a1 84 60 83 00       	mov    0x836084,%eax
  803ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce9:	29 c2                	sub    %eax,%edx
  803ceb:	89 d0                	mov    %edx,%eax
  803ced:	c1 e8 0c             	shr    $0xc,%eax
  803cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803cf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cf7:	78 09                	js     803d02 <to_page_info+0x27>
  803cf9:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803d00:	7e 14                	jle    803d16 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803d02:	83 ec 04             	sub    $0x4,%esp
  803d05:	68 10 55 80 00       	push   $0x805510
  803d0a:	6a 21                	push   $0x21
  803d0c:	68 f7 54 80 00       	push   $0x8054f7
  803d11:	e8 87 cd ff ff       	call   800a9d <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d19:	89 d0                	mov    %edx,%eax
  803d1b:	01 c0                	add    %eax,%eax
  803d1d:	01 d0                	add    %edx,%eax
  803d1f:	c1 e0 02             	shl    $0x2,%eax
  803d22:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  803d27:	c9                   	leave  
  803d28:	c3                   	ret    

00803d29 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803d29:	55                   	push   %ebp
  803d2a:	89 e5                	mov    %esp,%ebp
  803d2c:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d32:	05 00 00 00 02       	add    $0x2000000,%eax
  803d37:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803d3a:	73 16                	jae    803d52 <initialize_dynamic_allocator+0x29>
  803d3c:	68 34 55 80 00       	push   $0x805534
  803d41:	68 5a 55 80 00       	push   $0x80555a
  803d46:	6a 2f                	push   $0x2f
  803d48:	68 f7 54 80 00       	push   $0x8054f7
  803d4d:	e8 4b cd ff ff       	call   800a9d <_panic>
	dynAllocStart = daStart;
  803d52:	8b 45 08             	mov    0x8(%ebp),%eax
  803d55:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d5d:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803d62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803d69:	eb 36                	jmp    803da1 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6e:	c1 e0 04             	shl    $0x4,%eax
  803d71:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7f:	c1 e0 04             	shl    $0x4,%eax
  803d82:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803d87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d90:	c1 e0 04             	shl    $0x4,%eax
  803d93:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803d9e:	ff 45 f4             	incl   -0xc(%ebp)
  803da1:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803da5:	7e c4                	jle    803d6b <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803da7:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803dae:	00 00 00 
  803db1:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803db8:	00 00 00 
  803dbb:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803dc2:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803dc5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803dcc:	e9 1b 01 00 00       	jmp    803eec <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803dd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dd4:	89 d0                	mov    %edx,%eax
  803dd6:	01 c0                	add    %eax,%eax
  803dd8:	01 d0                	add    %edx,%eax
  803dda:	c1 e0 02             	shl    $0x2,%eax
  803ddd:	05 88 e0 81 00       	add    $0x81e088,%eax
  803de2:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803de7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dea:	89 d0                	mov    %edx,%eax
  803dec:	01 c0                	add    %eax,%eax
  803dee:	01 d0                	add    %edx,%eax
  803df0:	c1 e0 02             	shl    $0x2,%eax
  803df3:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803df8:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803dfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e00:	89 d0                	mov    %edx,%eax
  803e02:	01 c0                	add    %eax,%eax
  803e04:	01 d0                	add    %edx,%eax
  803e06:	c1 e0 02             	shl    $0x2,%eax
  803e09:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e0e:	8b 00                	mov    (%eax),%eax
  803e10:	85 c0                	test   %eax,%eax
  803e12:	74 2b                	je     803e3f <initialize_dynamic_allocator+0x116>
  803e14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e17:	89 d0                	mov    %edx,%eax
  803e19:	01 c0                	add    %eax,%eax
  803e1b:	01 d0                	add    %edx,%eax
  803e1d:	c1 e0 02             	shl    $0x2,%eax
  803e20:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e25:	8b 10                	mov    (%eax),%edx
  803e27:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803e2a:	89 c8                	mov    %ecx,%eax
  803e2c:	01 c0                	add    %eax,%eax
  803e2e:	01 c8                	add    %ecx,%eax
  803e30:	c1 e0 02             	shl    $0x2,%eax
  803e33:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e38:	8b 00                	mov    (%eax),%eax
  803e3a:	89 42 04             	mov    %eax,0x4(%edx)
  803e3d:	eb 18                	jmp    803e57 <initialize_dynamic_allocator+0x12e>
  803e3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e42:	89 d0                	mov    %edx,%eax
  803e44:	01 c0                	add    %eax,%eax
  803e46:	01 d0                	add    %edx,%eax
  803e48:	c1 e0 02             	shl    $0x2,%eax
  803e4b:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e50:	8b 00                	mov    (%eax),%eax
  803e52:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803e57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e5a:	89 d0                	mov    %edx,%eax
  803e5c:	01 c0                	add    %eax,%eax
  803e5e:	01 d0                	add    %edx,%eax
  803e60:	c1 e0 02             	shl    $0x2,%eax
  803e63:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e68:	8b 00                	mov    (%eax),%eax
  803e6a:	85 c0                	test   %eax,%eax
  803e6c:	74 2a                	je     803e98 <initialize_dynamic_allocator+0x16f>
  803e6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e71:	89 d0                	mov    %edx,%eax
  803e73:	01 c0                	add    %eax,%eax
  803e75:	01 d0                	add    %edx,%eax
  803e77:	c1 e0 02             	shl    $0x2,%eax
  803e7a:	05 84 e0 81 00       	add    $0x81e084,%eax
  803e7f:	8b 10                	mov    (%eax),%edx
  803e81:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803e84:	89 c8                	mov    %ecx,%eax
  803e86:	01 c0                	add    %eax,%eax
  803e88:	01 c8                	add    %ecx,%eax
  803e8a:	c1 e0 02             	shl    $0x2,%eax
  803e8d:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e92:	8b 00                	mov    (%eax),%eax
  803e94:	89 02                	mov    %eax,(%edx)
  803e96:	eb 18                	jmp    803eb0 <initialize_dynamic_allocator+0x187>
  803e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e9b:	89 d0                	mov    %edx,%eax
  803e9d:	01 c0                	add    %eax,%eax
  803e9f:	01 d0                	add    %edx,%eax
  803ea1:	c1 e0 02             	shl    $0x2,%eax
  803ea4:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ea9:	8b 00                	mov    (%eax),%eax
  803eab:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803eb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803eb3:	89 d0                	mov    %edx,%eax
  803eb5:	01 c0                	add    %eax,%eax
  803eb7:	01 d0                	add    %edx,%eax
  803eb9:	c1 e0 02             	shl    $0x2,%eax
  803ebc:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ec7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803eca:	89 d0                	mov    %edx,%eax
  803ecc:	01 c0                	add    %eax,%eax
  803ece:	01 d0                	add    %edx,%eax
  803ed0:	c1 e0 02             	shl    $0x2,%eax
  803ed3:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ede:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803ee3:	48                   	dec    %eax
  803ee4:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803ee9:	ff 45 f0             	incl   -0x10(%ebp)
  803eec:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803ef3:	0f 8e d8 fe ff ff    	jle    803dd1 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803ef9:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803f00:	e9 9d 00 00 00       	jmp    803fa2 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803f05:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803f0b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803f0e:	89 c8                	mov    %ecx,%eax
  803f10:	01 c0                	add    %eax,%eax
  803f12:	01 c8                	add    %ecx,%eax
  803f14:	c1 e0 02             	shl    $0x2,%eax
  803f17:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f1c:	89 10                	mov    %edx,(%eax)
  803f1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f21:	89 d0                	mov    %edx,%eax
  803f23:	01 c0                	add    %eax,%eax
  803f25:	01 d0                	add    %edx,%eax
  803f27:	c1 e0 02             	shl    $0x2,%eax
  803f2a:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f2f:	8b 00                	mov    (%eax),%eax
  803f31:	85 c0                	test   %eax,%eax
  803f33:	74 1c                	je     803f51 <initialize_dynamic_allocator+0x228>
  803f35:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803f3b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803f3e:	89 c8                	mov    %ecx,%eax
  803f40:	01 c0                	add    %eax,%eax
  803f42:	01 c8                	add    %ecx,%eax
  803f44:	c1 e0 02             	shl    $0x2,%eax
  803f47:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f4c:	89 42 04             	mov    %eax,0x4(%edx)
  803f4f:	eb 16                	jmp    803f67 <initialize_dynamic_allocator+0x23e>
  803f51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f54:	89 d0                	mov    %edx,%eax
  803f56:	01 c0                	add    %eax,%eax
  803f58:	01 d0                	add    %edx,%eax
  803f5a:	c1 e0 02             	shl    $0x2,%eax
  803f5d:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f62:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803f67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f6a:	89 d0                	mov    %edx,%eax
  803f6c:	01 c0                	add    %eax,%eax
  803f6e:	01 d0                	add    %edx,%eax
  803f70:	c1 e0 02             	shl    $0x2,%eax
  803f73:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f78:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803f7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f80:	89 d0                	mov    %edx,%eax
  803f82:	01 c0                	add    %eax,%eax
  803f84:	01 d0                	add    %edx,%eax
  803f86:	c1 e0 02             	shl    $0x2,%eax
  803f89:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f94:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803f99:	40                   	inc    %eax
  803f9a:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803f9f:	ff 4d ec             	decl   -0x14(%ebp)
  803fa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803fa6:	0f 89 59 ff ff ff    	jns    803f05 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803fac:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803fb3:	00 00 00 
}
  803fb6:	90                   	nop
  803fb7:	c9                   	leave  
  803fb8:	c3                   	ret    

00803fb9 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803fb9:	55                   	push   %ebp
  803fba:	89 e5                	mov    %esp,%ebp
  803fbc:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc2:	83 ec 0c             	sub    $0xc,%esp
  803fc5:	50                   	push   %eax
  803fc6:	e8 10 fd ff ff       	call   803cdb <to_page_info>
  803fcb:	83 c4 10             	add    $0x10,%esp
  803fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd4:	8b 40 08             	mov    0x8(%eax),%eax
  803fd7:	0f b7 c0             	movzwl %ax,%eax
}
  803fda:	c9                   	leave  
  803fdb:	c3                   	ret    

00803fdc <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803fdc:	55                   	push   %ebp
  803fdd:	89 e5                	mov    %esp,%ebp
  803fdf:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803fe2:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803fe9:	76 16                	jbe    804001 <alloc_block+0x25>
  803feb:	68 70 55 80 00       	push   $0x805570
  803ff0:	68 5a 55 80 00       	push   $0x80555a
  803ff5:	6a 59                	push   $0x59
  803ff7:	68 f7 54 80 00       	push   $0x8054f7
  803ffc:	e8 9c ca ff ff       	call   800a9d <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  804001:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  804008:	eb 08                	jmp    804012 <alloc_block+0x36>
		allocSize <<= 1;
  80400a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400d:	01 c0                	add    %eax,%eax
  80400f:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  804012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804015:	3b 45 08             	cmp    0x8(%ebp),%eax
  804018:	73 09                	jae    804023 <alloc_block+0x47>
  80401a:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  804021:	76 e7                	jbe    80400a <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  804023:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80402a:	eb 03                	jmp    80402f <alloc_block+0x53>
		listIndex++;
  80402c:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80402f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804032:	ba 08 00 00 00       	mov    $0x8,%edx
  804037:	88 c1                	mov    %al,%cl
  804039:	d3 e2                	shl    %cl,%edx
  80403b:	89 d0                	mov    %edx,%eax
  80403d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804040:	72 ea                	jb     80402c <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804045:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804048:	e9 f4 00 00 00       	jmp    804141 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80404d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804050:	c1 e0 04             	shl    $0x4,%eax
  804053:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804058:	8b 00                	mov    (%eax),%eax
  80405a:	85 c0                	test   %eax,%eax
  80405c:	0f 84 dc 00 00 00    	je     80413e <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804062:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804065:	c1 e0 04             	shl    $0x4,%eax
  804068:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80406d:	8b 00                	mov    (%eax),%eax
  80406f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  804072:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804076:	75 14                	jne    80408c <alloc_block+0xb0>
  804078:	83 ec 04             	sub    $0x4,%esp
  80407b:	68 91 55 80 00       	push   $0x805591
  804080:	6a 6b                	push   $0x6b
  804082:	68 f7 54 80 00       	push   $0x8054f7
  804087:	e8 11 ca ff ff       	call   800a9d <_panic>
  80408c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408f:	8b 00                	mov    (%eax),%eax
  804091:	85 c0                	test   %eax,%eax
  804093:	74 10                	je     8040a5 <alloc_block+0xc9>
  804095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804098:	8b 00                	mov    (%eax),%eax
  80409a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80409d:	8b 52 04             	mov    0x4(%edx),%edx
  8040a0:	89 50 04             	mov    %edx,0x4(%eax)
  8040a3:	eb 14                	jmp    8040b9 <alloc_block+0xdd>
  8040a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a8:	8b 40 04             	mov    0x4(%eax),%eax
  8040ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040ae:	c1 e2 04             	shl    $0x4,%edx
  8040b1:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  8040b7:	89 02                	mov    %eax,(%edx)
  8040b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040bc:	8b 40 04             	mov    0x4(%eax),%eax
  8040bf:	85 c0                	test   %eax,%eax
  8040c1:	74 0f                	je     8040d2 <alloc_block+0xf6>
  8040c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c6:	8b 40 04             	mov    0x4(%eax),%eax
  8040c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040cc:	8b 12                	mov    (%edx),%edx
  8040ce:	89 10                	mov    %edx,(%eax)
  8040d0:	eb 13                	jmp    8040e5 <alloc_block+0x109>
  8040d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d5:	8b 00                	mov    (%eax),%eax
  8040d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040da:	c1 e2 04             	shl    $0x4,%edx
  8040dd:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8040e3:	89 02                	mov    %eax,(%edx)
  8040e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040fb:	c1 e0 04             	shl    $0x4,%eax
  8040fe:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804103:	8b 00                	mov    (%eax),%eax
  804105:	8d 50 ff             	lea    -0x1(%eax),%edx
  804108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80410b:	c1 e0 04             	shl    $0x4,%eax
  80410e:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804113:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  804115:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804118:	83 ec 0c             	sub    $0xc,%esp
  80411b:	50                   	push   %eax
  80411c:	e8 ba fb ff ff       	call   803cdb <to_page_info>
  804121:	83 c4 10             	add    $0x10,%esp
  804124:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  804127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80412a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80412e:	48                   	dec    %eax
  80412f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804132:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  804136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804139:	e9 8f 02 00 00       	jmp    8043cd <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80413e:	ff 45 ec             	incl   -0x14(%ebp)
  804141:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804145:	0f 8e 02 ff ff ff    	jle    80404d <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  80414b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804150:	85 c0                	test   %eax,%eax
  804152:	75 14                	jne    804168 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  804154:	83 ec 04             	sub    $0x4,%esp
  804157:	68 b0 55 80 00       	push   $0x8055b0
  80415c:	6a 77                	push   $0x77
  80415e:	68 f7 54 80 00       	push   $0x8054f7
  804163:	e8 35 c9 ff ff       	call   800a9d <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  804168:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80416d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  804170:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804174:	75 14                	jne    80418a <alloc_block+0x1ae>
  804176:	83 ec 04             	sub    $0x4,%esp
  804179:	68 91 55 80 00       	push   $0x805591
  80417e:	6a 7a                	push   $0x7a
  804180:	68 f7 54 80 00       	push   $0x8054f7
  804185:	e8 13 c9 ff ff       	call   800a9d <_panic>
  80418a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80418d:	8b 00                	mov    (%eax),%eax
  80418f:	85 c0                	test   %eax,%eax
  804191:	74 10                	je     8041a3 <alloc_block+0x1c7>
  804193:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804196:	8b 00                	mov    (%eax),%eax
  804198:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80419b:	8b 52 04             	mov    0x4(%edx),%edx
  80419e:	89 50 04             	mov    %edx,0x4(%eax)
  8041a1:	eb 0b                	jmp    8041ae <alloc_block+0x1d2>
  8041a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041a6:	8b 40 04             	mov    0x4(%eax),%eax
  8041a9:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8041ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041b1:	8b 40 04             	mov    0x4(%eax),%eax
  8041b4:	85 c0                	test   %eax,%eax
  8041b6:	74 0f                	je     8041c7 <alloc_block+0x1eb>
  8041b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041bb:	8b 40 04             	mov    0x4(%eax),%eax
  8041be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8041c1:	8b 12                	mov    (%edx),%edx
  8041c3:	89 10                	mov    %edx,(%eax)
  8041c5:	eb 0a                	jmp    8041d1 <alloc_block+0x1f5>
  8041c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041ca:	8b 00                	mov    (%eax),%eax
  8041cc:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8041d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041e4:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8041e9:	48                   	dec    %eax
  8041ea:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8041ef:	83 ec 0c             	sub    $0xc,%esp
  8041f2:	ff 75 dc             	pushl  -0x24(%ebp)
  8041f5:	e8 6f fa ff ff       	call   803c69 <to_page_va>
  8041fa:	83 c4 10             	add    $0x10,%esp
  8041fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  804200:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804203:	83 ec 0c             	sub    $0xc,%esp
  804206:	50                   	push   %eax
  804207:	e8 a0 dc ff ff       	call   801eac <get_page>
  80420c:	83 c4 10             	add    $0x10,%esp
  80420f:	85 c0                	test   %eax,%eax
  804211:	74 14                	je     804227 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  804213:	83 ec 04             	sub    $0x4,%esp
  804216:	68 d8 55 80 00       	push   $0x8055d8
  80421b:	6a 7f                	push   $0x7f
  80421d:	68 f7 54 80 00       	push   $0x8054f7
  804222:	e8 76 c8 ff ff       	call   800a9d <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  804227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80422d:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  804231:	b8 00 10 00 00       	mov    $0x1000,%eax
  804236:	ba 00 00 00 00       	mov    $0x0,%edx
  80423b:	f7 75 f4             	divl   -0xc(%ebp)
  80423e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804241:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  804245:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80424c:	e9 a7 00 00 00       	jmp    8042f8 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  804251:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804257:	01 d0                	add    %edx,%eax
  804259:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  80425c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804260:	75 17                	jne    804279 <alloc_block+0x29d>
  804262:	83 ec 04             	sub    $0x4,%esp
  804265:	68 00 56 80 00       	push   $0x805600
  80426a:	68 88 00 00 00       	push   $0x88
  80426f:	68 f7 54 80 00       	push   $0x8054f7
  804274:	e8 24 c8 ff ff       	call   800a9d <_panic>
  804279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80427c:	c1 e0 04             	shl    $0x4,%eax
  80427f:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804284:	8b 10                	mov    (%eax),%edx
  804286:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804289:	89 10                	mov    %edx,(%eax)
  80428b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80428e:	8b 00                	mov    (%eax),%eax
  804290:	85 c0                	test   %eax,%eax
  804292:	74 15                	je     8042a9 <alloc_block+0x2cd>
  804294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804297:	c1 e0 04             	shl    $0x4,%eax
  80429a:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80429f:	8b 00                	mov    (%eax),%eax
  8042a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042a4:	89 50 04             	mov    %edx,0x4(%eax)
  8042a7:	eb 11                	jmp    8042ba <alloc_block+0x2de>
  8042a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ac:	c1 e0 04             	shl    $0x4,%eax
  8042af:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8042b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042b8:	89 02                	mov    %eax,(%edx)
  8042ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042bd:	c1 e0 04             	shl    $0x4,%eax
  8042c0:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8042c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042c9:	89 02                	mov    %eax,(%edx)
  8042cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d8:	c1 e0 04             	shl    $0x4,%eax
  8042db:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042e0:	8b 00                	mov    (%eax),%eax
  8042e2:	8d 50 01             	lea    0x1(%eax),%edx
  8042e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042e8:	c1 e0 04             	shl    $0x4,%eax
  8042eb:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042f0:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8042f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f5:	01 45 e8             	add    %eax,-0x18(%ebp)
  8042f8:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8042ff:	0f 86 4c ff ff ff    	jbe    804251 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  804305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804308:	c1 e0 04             	shl    $0x4,%eax
  80430b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804310:	8b 00                	mov    (%eax),%eax
  804312:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  804315:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804319:	75 17                	jne    804332 <alloc_block+0x356>
  80431b:	83 ec 04             	sub    $0x4,%esp
  80431e:	68 91 55 80 00       	push   $0x805591
  804323:	68 8d 00 00 00       	push   $0x8d
  804328:	68 f7 54 80 00       	push   $0x8054f7
  80432d:	e8 6b c7 ff ff       	call   800a9d <_panic>
  804332:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804335:	8b 00                	mov    (%eax),%eax
  804337:	85 c0                	test   %eax,%eax
  804339:	74 10                	je     80434b <alloc_block+0x36f>
  80433b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80433e:	8b 00                	mov    (%eax),%eax
  804340:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804343:	8b 52 04             	mov    0x4(%edx),%edx
  804346:	89 50 04             	mov    %edx,0x4(%eax)
  804349:	eb 14                	jmp    80435f <alloc_block+0x383>
  80434b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80434e:	8b 40 04             	mov    0x4(%eax),%eax
  804351:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804354:	c1 e2 04             	shl    $0x4,%edx
  804357:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  80435d:	89 02                	mov    %eax,(%edx)
  80435f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804362:	8b 40 04             	mov    0x4(%eax),%eax
  804365:	85 c0                	test   %eax,%eax
  804367:	74 0f                	je     804378 <alloc_block+0x39c>
  804369:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80436c:	8b 40 04             	mov    0x4(%eax),%eax
  80436f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804372:	8b 12                	mov    (%edx),%edx
  804374:	89 10                	mov    %edx,(%eax)
  804376:	eb 13                	jmp    80438b <alloc_block+0x3af>
  804378:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80437b:	8b 00                	mov    (%eax),%eax
  80437d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804380:	c1 e2 04             	shl    $0x4,%edx
  804383:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804389:	89 02                	mov    %eax,(%edx)
  80438b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80438e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804394:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804397:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80439e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043a1:	c1 e0 04             	shl    $0x4,%eax
  8043a4:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8043a9:	8b 00                	mov    (%eax),%eax
  8043ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8043ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043b1:	c1 e0 04             	shl    $0x4,%eax
  8043b4:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8043b9:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8043bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043be:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8043c2:	48                   	dec    %eax
  8043c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8043c6:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  8043ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8043cd:	c9                   	leave  
  8043ce:	c3                   	ret    

008043cf <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8043cf:	55                   	push   %ebp
  8043d0:	89 e5                	mov    %esp,%ebp
  8043d2:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8043d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8043d8:	a1 84 60 83 00       	mov    0x836084,%eax
  8043dd:	39 c2                	cmp    %eax,%edx
  8043df:	72 0c                	jb     8043ed <free_block+0x1e>
  8043e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8043e4:	a1 60 e0 81 00       	mov    0x81e060,%eax
  8043e9:	39 c2                	cmp    %eax,%edx
  8043eb:	72 19                	jb     804406 <free_block+0x37>
  8043ed:	68 24 56 80 00       	push   $0x805624
  8043f2:	68 5a 55 80 00       	push   $0x80555a
  8043f7:	68 98 00 00 00       	push   $0x98
  8043fc:	68 f7 54 80 00       	push   $0x8054f7
  804401:	e8 97 c6 ff ff       	call   800a9d <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804406:	8b 45 08             	mov    0x8(%ebp),%eax
  804409:	83 ec 0c             	sub    $0xc,%esp
  80440c:	50                   	push   %eax
  80440d:	e8 c9 f8 ff ff       	call   803cdb <to_page_info>
  804412:	83 c4 10             	add    $0x10,%esp
  804415:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80441b:	8b 40 08             	mov    0x8(%eax),%eax
  80441e:	0f b7 c0             	movzwl %ax,%eax
  804421:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  804424:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  80442b:	eb 03                	jmp    804430 <free_block+0x61>
		listIndex++;
  80442d:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804433:	ba 08 00 00 00       	mov    $0x8,%edx
  804438:	88 c1                	mov    %al,%cl
  80443a:	d3 e2                	shl    %cl,%edx
  80443c:	89 d0                	mov    %edx,%eax
  80443e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804441:	72 ea                	jb     80442d <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  804443:	8b 45 08             	mov    0x8(%ebp),%eax
  804446:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  804449:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80444d:	75 17                	jne    804466 <free_block+0x97>
  80444f:	83 ec 04             	sub    $0x4,%esp
  804452:	68 00 56 80 00       	push   $0x805600
  804457:	68 a2 00 00 00       	push   $0xa2
  80445c:	68 f7 54 80 00       	push   $0x8054f7
  804461:	e8 37 c6 ff ff       	call   800a9d <_panic>
  804466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804469:	c1 e0 04             	shl    $0x4,%eax
  80446c:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804471:	8b 10                	mov    (%eax),%edx
  804473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804476:	89 10                	mov    %edx,(%eax)
  804478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80447b:	8b 00                	mov    (%eax),%eax
  80447d:	85 c0                	test   %eax,%eax
  80447f:	74 15                	je     804496 <free_block+0xc7>
  804481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804484:	c1 e0 04             	shl    $0x4,%eax
  804487:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80448c:	8b 00                	mov    (%eax),%eax
  80448e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804491:	89 50 04             	mov    %edx,0x4(%eax)
  804494:	eb 11                	jmp    8044a7 <free_block+0xd8>
  804496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804499:	c1 e0 04             	shl    $0x4,%eax
  80449c:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  8044a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044a5:	89 02                	mov    %eax,(%edx)
  8044a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044aa:	c1 e0 04             	shl    $0x4,%eax
  8044ad:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  8044b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044b6:	89 02                	mov    %eax,(%edx)
  8044b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044c5:	c1 e0 04             	shl    $0x4,%eax
  8044c8:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8044cd:	8b 00                	mov    (%eax),%eax
  8044cf:	8d 50 01             	lea    0x1(%eax),%edx
  8044d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044d5:	c1 e0 04             	shl    $0x4,%eax
  8044d8:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8044dd:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  8044df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044e2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8044e6:	40                   	inc    %eax
  8044e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8044ea:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  8044ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044f1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8044f5:	0f b7 c8             	movzwl %ax,%ecx
  8044f8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8044fd:	ba 00 00 00 00       	mov    $0x0,%edx
  804502:	f7 75 e8             	divl   -0x18(%ebp)
  804505:	39 c1                	cmp    %eax,%ecx
  804507:	0f 85 ed 01 00 00    	jne    8046fa <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  80450d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804510:	c1 e0 04             	shl    $0x4,%eax
  804513:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804518:	8b 00                	mov    (%eax),%eax
  80451a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80451d:	eb 2a                	jmp    804549 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  80451f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804522:	83 ec 0c             	sub    $0xc,%esp
  804525:	50                   	push   %eax
  804526:	e8 b0 f7 ff ff       	call   803cdb <to_page_info>
  80452b:	83 c4 10             	add    $0x10,%esp
  80452e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804531:	75 06                	jne    804539 <free_block+0x16a>
				tmp = b;
  804533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804536:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80453c:	c1 e0 04             	shl    $0x4,%eax
  80453f:	05 a8 60 83 00       	add    $0x8360a8,%eax
  804544:	8b 00                	mov    (%eax),%eax
  804546:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804549:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80454d:	74 07                	je     804556 <free_block+0x187>
  80454f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804552:	8b 00                	mov    (%eax),%eax
  804554:	eb 05                	jmp    80455b <free_block+0x18c>
  804556:	b8 00 00 00 00       	mov    $0x0,%eax
  80455b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80455e:	c1 e2 04             	shl    $0x4,%edx
  804561:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  804567:	89 02                	mov    %eax,(%edx)
  804569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80456c:	c1 e0 04             	shl    $0x4,%eax
  80456f:	05 a8 60 83 00       	add    $0x8360a8,%eax
  804574:	8b 00                	mov    (%eax),%eax
  804576:	85 c0                	test   %eax,%eax
  804578:	75 a5                	jne    80451f <free_block+0x150>
  80457a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80457e:	75 9f                	jne    80451f <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804583:	c1 e0 04             	shl    $0x4,%eax
  804586:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80458b:	8b 00                	mov    (%eax),%eax
  80458d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804590:	e9 cc 00 00 00       	jmp    804661 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  804595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804598:	8b 00                	mov    (%eax),%eax
  80459a:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  80459d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045a0:	83 ec 0c             	sub    $0xc,%esp
  8045a3:	50                   	push   %eax
  8045a4:	e8 32 f7 ff ff       	call   803cdb <to_page_info>
  8045a9:	83 c4 10             	add    $0x10,%esp
  8045ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8045af:	0f 85 a6 00 00 00    	jne    80465b <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  8045b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8045b9:	75 17                	jne    8045d2 <free_block+0x203>
  8045bb:	83 ec 04             	sub    $0x4,%esp
  8045be:	68 91 55 80 00       	push   $0x805591
  8045c3:	68 b5 00 00 00       	push   $0xb5
  8045c8:	68 f7 54 80 00       	push   $0x8054f7
  8045cd:	e8 cb c4 ff ff       	call   800a9d <_panic>
  8045d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045d5:	8b 00                	mov    (%eax),%eax
  8045d7:	85 c0                	test   %eax,%eax
  8045d9:	74 10                	je     8045eb <free_block+0x21c>
  8045db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045de:	8b 00                	mov    (%eax),%eax
  8045e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045e3:	8b 52 04             	mov    0x4(%edx),%edx
  8045e6:	89 50 04             	mov    %edx,0x4(%eax)
  8045e9:	eb 14                	jmp    8045ff <free_block+0x230>
  8045eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045ee:	8b 40 04             	mov    0x4(%eax),%eax
  8045f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8045f4:	c1 e2 04             	shl    $0x4,%edx
  8045f7:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  8045fd:	89 02                	mov    %eax,(%edx)
  8045ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804602:	8b 40 04             	mov    0x4(%eax),%eax
  804605:	85 c0                	test   %eax,%eax
  804607:	74 0f                	je     804618 <free_block+0x249>
  804609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80460c:	8b 40 04             	mov    0x4(%eax),%eax
  80460f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804612:	8b 12                	mov    (%edx),%edx
  804614:	89 10                	mov    %edx,(%eax)
  804616:	eb 13                	jmp    80462b <free_block+0x25c>
  804618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80461b:	8b 00                	mov    (%eax),%eax
  80461d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804620:	c1 e2 04             	shl    $0x4,%edx
  804623:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804629:	89 02                	mov    %eax,(%edx)
  80462b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80462e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804637:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80463e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804641:	c1 e0 04             	shl    $0x4,%eax
  804644:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804649:	8b 00                	mov    (%eax),%eax
  80464b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804651:	c1 e0 04             	shl    $0x4,%eax
  804654:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804659:	89 10                	mov    %edx,(%eax)
			b = next;
  80465b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80465e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804661:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804665:	0f 85 2a ff ff ff    	jne    804595 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  80466b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80466e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804677:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  80467d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804681:	75 17                	jne    80469a <free_block+0x2cb>
  804683:	83 ec 04             	sub    $0x4,%esp
  804686:	68 00 56 80 00       	push   $0x805600
  80468b:	68 bc 00 00 00       	push   $0xbc
  804690:	68 f7 54 80 00       	push   $0x8054f7
  804695:	e8 03 c4 ff ff       	call   800a9d <_panic>
  80469a:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8046a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046a3:	89 10                	mov    %edx,(%eax)
  8046a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046a8:	8b 00                	mov    (%eax),%eax
  8046aa:	85 c0                	test   %eax,%eax
  8046ac:	74 0d                	je     8046bb <free_block+0x2ec>
  8046ae:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8046b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8046b6:	89 50 04             	mov    %edx,0x4(%eax)
  8046b9:	eb 08                	jmp    8046c3 <free_block+0x2f4>
  8046bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046be:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8046c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046c6:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8046cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046d5:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8046da:	40                   	inc    %eax
  8046db:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  8046e0:	83 ec 0c             	sub    $0xc,%esp
  8046e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8046e6:	e8 7e f5 ff ff       	call   803c69 <to_page_va>
  8046eb:	83 c4 10             	add    $0x10,%esp
  8046ee:	83 ec 0c             	sub    $0xc,%esp
  8046f1:	50                   	push   %eax
  8046f2:	e8 fe d7 ff ff       	call   801ef5 <return_page>
  8046f7:	83 c4 10             	add    $0x10,%esp
	}
}
  8046fa:	90                   	nop
  8046fb:	c9                   	leave  
  8046fc:	c3                   	ret    

008046fd <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8046fd:	55                   	push   %ebp
  8046fe:	89 e5                	mov    %esp,%ebp
  804700:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  804703:	83 ec 04             	sub    $0x4,%esp
  804706:	68 5c 56 80 00       	push   $0x80565c
  80470b:	6a 07                	push   $0x7
  80470d:	68 8b 56 80 00       	push   $0x80568b
  804712:	e8 86 c3 ff ff       	call   800a9d <_panic>

00804717 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  804717:	55                   	push   %ebp
  804718:	89 e5                	mov    %esp,%ebp
  80471a:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  80471d:	83 ec 04             	sub    $0x4,%esp
  804720:	68 9c 56 80 00       	push   $0x80569c
  804725:	6a 0b                	push   $0xb
  804727:	68 8b 56 80 00       	push   $0x80568b
  80472c:	e8 6c c3 ff ff       	call   800a9d <_panic>

00804731 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  804731:	55                   	push   %ebp
  804732:	89 e5                	mov    %esp,%ebp
  804734:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  804737:	83 ec 04             	sub    $0x4,%esp
  80473a:	68 c8 56 80 00       	push   $0x8056c8
  80473f:	6a 10                	push   $0x10
  804741:	68 8b 56 80 00       	push   $0x80568b
  804746:	e8 52 c3 ff ff       	call   800a9d <_panic>

0080474b <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  80474b:	55                   	push   %ebp
  80474c:	89 e5                	mov    %esp,%ebp
  80474e:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  804751:	83 ec 04             	sub    $0x4,%esp
  804754:	68 f8 56 80 00       	push   $0x8056f8
  804759:	6a 15                	push   $0x15
  80475b:	68 8b 56 80 00       	push   $0x80568b
  804760:	e8 38 c3 ff ff       	call   800a9d <_panic>

00804765 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  804765:	55                   	push   %ebp
  804766:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804768:	8b 45 08             	mov    0x8(%ebp),%eax
  80476b:	8b 40 10             	mov    0x10(%eax),%eax
}
  80476e:	5d                   	pop    %ebp
  80476f:	c3                   	ret    

00804770 <__divdi3>:
  804770:	55                   	push   %ebp
  804771:	57                   	push   %edi
  804772:	56                   	push   %esi
  804773:	53                   	push   %ebx
  804774:	83 ec 1c             	sub    $0x1c,%esp
  804777:	8b 44 24 30          	mov    0x30(%esp),%eax
  80477b:	8b 54 24 34          	mov    0x34(%esp),%edx
  80477f:	8b 74 24 38          	mov    0x38(%esp),%esi
  804783:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  804787:	89 f9                	mov    %edi,%ecx
  804789:	85 d2                	test   %edx,%edx
  80478b:	0f 88 bb 00 00 00    	js     80484c <__divdi3+0xdc>
  804791:	31 ed                	xor    %ebp,%ebp
  804793:	85 c9                	test   %ecx,%ecx
  804795:	0f 88 99 00 00 00    	js     804834 <__divdi3+0xc4>
  80479b:	89 34 24             	mov    %esi,(%esp)
  80479e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8047a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8047a6:	89 d3                	mov    %edx,%ebx
  8047a8:	8b 34 24             	mov    (%esp),%esi
  8047ab:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8047af:	89 74 24 08          	mov    %esi,0x8(%esp)
  8047b3:	8b 34 24             	mov    (%esp),%esi
  8047b6:	89 c1                	mov    %eax,%ecx
  8047b8:	85 ff                	test   %edi,%edi
  8047ba:	75 10                	jne    8047cc <__divdi3+0x5c>
  8047bc:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8047c0:	39 d7                	cmp    %edx,%edi
  8047c2:	76 4c                	jbe    804810 <__divdi3+0xa0>
  8047c4:	f7 f7                	div    %edi
  8047c6:	89 c1                	mov    %eax,%ecx
  8047c8:	31 f6                	xor    %esi,%esi
  8047ca:	eb 08                	jmp    8047d4 <__divdi3+0x64>
  8047cc:	39 d7                	cmp    %edx,%edi
  8047ce:	76 1c                	jbe    8047ec <__divdi3+0x7c>
  8047d0:	31 f6                	xor    %esi,%esi
  8047d2:	31 c9                	xor    %ecx,%ecx
  8047d4:	89 c8                	mov    %ecx,%eax
  8047d6:	89 f2                	mov    %esi,%edx
  8047d8:	85 ed                	test   %ebp,%ebp
  8047da:	74 07                	je     8047e3 <__divdi3+0x73>
  8047dc:	f7 d8                	neg    %eax
  8047de:	83 d2 00             	adc    $0x0,%edx
  8047e1:	f7 da                	neg    %edx
  8047e3:	83 c4 1c             	add    $0x1c,%esp
  8047e6:	5b                   	pop    %ebx
  8047e7:	5e                   	pop    %esi
  8047e8:	5f                   	pop    %edi
  8047e9:	5d                   	pop    %ebp
  8047ea:	c3                   	ret    
  8047eb:	90                   	nop
  8047ec:	0f bd f7             	bsr    %edi,%esi
  8047ef:	83 f6 1f             	xor    $0x1f,%esi
  8047f2:	75 6c                	jne    804860 <__divdi3+0xf0>
  8047f4:	39 d7                	cmp    %edx,%edi
  8047f6:	72 0e                	jb     804806 <__divdi3+0x96>
  8047f8:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  8047fc:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  804800:	0f 87 ca 00 00 00    	ja     8048d0 <__divdi3+0x160>
  804806:	b9 01 00 00 00       	mov    $0x1,%ecx
  80480b:	eb c7                	jmp    8047d4 <__divdi3+0x64>
  80480d:	8d 76 00             	lea    0x0(%esi),%esi
  804810:	85 f6                	test   %esi,%esi
  804812:	75 0b                	jne    80481f <__divdi3+0xaf>
  804814:	b8 01 00 00 00       	mov    $0x1,%eax
  804819:	31 d2                	xor    %edx,%edx
  80481b:	f7 f6                	div    %esi
  80481d:	89 c6                	mov    %eax,%esi
  80481f:	31 d2                	xor    %edx,%edx
  804821:	89 d8                	mov    %ebx,%eax
  804823:	f7 f6                	div    %esi
  804825:	89 c7                	mov    %eax,%edi
  804827:	89 c8                	mov    %ecx,%eax
  804829:	f7 f6                	div    %esi
  80482b:	89 c1                	mov    %eax,%ecx
  80482d:	89 fe                	mov    %edi,%esi
  80482f:	eb a3                	jmp    8047d4 <__divdi3+0x64>
  804831:	8d 76 00             	lea    0x0(%esi),%esi
  804834:	f7 d5                	not    %ebp
  804836:	f7 de                	neg    %esi
  804838:	83 d7 00             	adc    $0x0,%edi
  80483b:	f7 df                	neg    %edi
  80483d:	89 34 24             	mov    %esi,(%esp)
  804840:	89 7c 24 04          	mov    %edi,0x4(%esp)
  804844:	e9 59 ff ff ff       	jmp    8047a2 <__divdi3+0x32>
  804849:	8d 76 00             	lea    0x0(%esi),%esi
  80484c:	f7 d8                	neg    %eax
  80484e:	83 d2 00             	adc    $0x0,%edx
  804851:	f7 da                	neg    %edx
  804853:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  804858:	e9 36 ff ff ff       	jmp    804793 <__divdi3+0x23>
  80485d:	8d 76 00             	lea    0x0(%esi),%esi
  804860:	b8 20 00 00 00       	mov    $0x20,%eax
  804865:	29 f0                	sub    %esi,%eax
  804867:	89 f1                	mov    %esi,%ecx
  804869:	d3 e7                	shl    %cl,%edi
  80486b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80486f:	88 c1                	mov    %al,%cl
  804871:	d3 ea                	shr    %cl,%edx
  804873:	89 d1                	mov    %edx,%ecx
  804875:	09 f9                	or     %edi,%ecx
  804877:	89 0c 24             	mov    %ecx,(%esp)
  80487a:	8b 54 24 08          	mov    0x8(%esp),%edx
  80487e:	89 f1                	mov    %esi,%ecx
  804880:	d3 e2                	shl    %cl,%edx
  804882:	89 54 24 08          	mov    %edx,0x8(%esp)
  804886:	89 df                	mov    %ebx,%edi
  804888:	88 c1                	mov    %al,%cl
  80488a:	d3 ef                	shr    %cl,%edi
  80488c:	89 f1                	mov    %esi,%ecx
  80488e:	d3 e3                	shl    %cl,%ebx
  804890:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804894:	88 c1                	mov    %al,%cl
  804896:	d3 ea                	shr    %cl,%edx
  804898:	09 d3                	or     %edx,%ebx
  80489a:	89 d8                	mov    %ebx,%eax
  80489c:	89 fa                	mov    %edi,%edx
  80489e:	f7 34 24             	divl   (%esp)
  8048a1:	89 d1                	mov    %edx,%ecx
  8048a3:	89 c3                	mov    %eax,%ebx
  8048a5:	f7 64 24 08          	mull   0x8(%esp)
  8048a9:	39 d1                	cmp    %edx,%ecx
  8048ab:	72 17                	jb     8048c4 <__divdi3+0x154>
  8048ad:	74 09                	je     8048b8 <__divdi3+0x148>
  8048af:	89 d9                	mov    %ebx,%ecx
  8048b1:	31 f6                	xor    %esi,%esi
  8048b3:	e9 1c ff ff ff       	jmp    8047d4 <__divdi3+0x64>
  8048b8:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8048bc:	89 f1                	mov    %esi,%ecx
  8048be:	d3 e2                	shl    %cl,%edx
  8048c0:	39 c2                	cmp    %eax,%edx
  8048c2:	73 eb                	jae    8048af <__divdi3+0x13f>
  8048c4:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  8048c7:	31 f6                	xor    %esi,%esi
  8048c9:	e9 06 ff ff ff       	jmp    8047d4 <__divdi3+0x64>
  8048ce:	66 90                	xchg   %ax,%ax
  8048d0:	31 c9                	xor    %ecx,%ecx
  8048d2:	e9 fd fe ff ff       	jmp    8047d4 <__divdi3+0x64>
  8048d7:	90                   	nop

008048d8 <__udivdi3>:
  8048d8:	55                   	push   %ebp
  8048d9:	57                   	push   %edi
  8048da:	56                   	push   %esi
  8048db:	53                   	push   %ebx
  8048dc:	83 ec 1c             	sub    $0x1c,%esp
  8048df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8048e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8048e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8048eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8048ef:	89 ca                	mov    %ecx,%edx
  8048f1:	89 f8                	mov    %edi,%eax
  8048f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8048f7:	85 f6                	test   %esi,%esi
  8048f9:	75 2d                	jne    804928 <__udivdi3+0x50>
  8048fb:	39 cf                	cmp    %ecx,%edi
  8048fd:	77 65                	ja     804964 <__udivdi3+0x8c>
  8048ff:	89 fd                	mov    %edi,%ebp
  804901:	85 ff                	test   %edi,%edi
  804903:	75 0b                	jne    804910 <__udivdi3+0x38>
  804905:	b8 01 00 00 00       	mov    $0x1,%eax
  80490a:	31 d2                	xor    %edx,%edx
  80490c:	f7 f7                	div    %edi
  80490e:	89 c5                	mov    %eax,%ebp
  804910:	31 d2                	xor    %edx,%edx
  804912:	89 c8                	mov    %ecx,%eax
  804914:	f7 f5                	div    %ebp
  804916:	89 c1                	mov    %eax,%ecx
  804918:	89 d8                	mov    %ebx,%eax
  80491a:	f7 f5                	div    %ebp
  80491c:	89 cf                	mov    %ecx,%edi
  80491e:	89 fa                	mov    %edi,%edx
  804920:	83 c4 1c             	add    $0x1c,%esp
  804923:	5b                   	pop    %ebx
  804924:	5e                   	pop    %esi
  804925:	5f                   	pop    %edi
  804926:	5d                   	pop    %ebp
  804927:	c3                   	ret    
  804928:	39 ce                	cmp    %ecx,%esi
  80492a:	77 28                	ja     804954 <__udivdi3+0x7c>
  80492c:	0f bd fe             	bsr    %esi,%edi
  80492f:	83 f7 1f             	xor    $0x1f,%edi
  804932:	75 40                	jne    804974 <__udivdi3+0x9c>
  804934:	39 ce                	cmp    %ecx,%esi
  804936:	72 0a                	jb     804942 <__udivdi3+0x6a>
  804938:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80493c:	0f 87 9e 00 00 00    	ja     8049e0 <__udivdi3+0x108>
  804942:	b8 01 00 00 00       	mov    $0x1,%eax
  804947:	89 fa                	mov    %edi,%edx
  804949:	83 c4 1c             	add    $0x1c,%esp
  80494c:	5b                   	pop    %ebx
  80494d:	5e                   	pop    %esi
  80494e:	5f                   	pop    %edi
  80494f:	5d                   	pop    %ebp
  804950:	c3                   	ret    
  804951:	8d 76 00             	lea    0x0(%esi),%esi
  804954:	31 ff                	xor    %edi,%edi
  804956:	31 c0                	xor    %eax,%eax
  804958:	89 fa                	mov    %edi,%edx
  80495a:	83 c4 1c             	add    $0x1c,%esp
  80495d:	5b                   	pop    %ebx
  80495e:	5e                   	pop    %esi
  80495f:	5f                   	pop    %edi
  804960:	5d                   	pop    %ebp
  804961:	c3                   	ret    
  804962:	66 90                	xchg   %ax,%ax
  804964:	89 d8                	mov    %ebx,%eax
  804966:	f7 f7                	div    %edi
  804968:	31 ff                	xor    %edi,%edi
  80496a:	89 fa                	mov    %edi,%edx
  80496c:	83 c4 1c             	add    $0x1c,%esp
  80496f:	5b                   	pop    %ebx
  804970:	5e                   	pop    %esi
  804971:	5f                   	pop    %edi
  804972:	5d                   	pop    %ebp
  804973:	c3                   	ret    
  804974:	bd 20 00 00 00       	mov    $0x20,%ebp
  804979:	89 eb                	mov    %ebp,%ebx
  80497b:	29 fb                	sub    %edi,%ebx
  80497d:	89 f9                	mov    %edi,%ecx
  80497f:	d3 e6                	shl    %cl,%esi
  804981:	89 c5                	mov    %eax,%ebp
  804983:	88 d9                	mov    %bl,%cl
  804985:	d3 ed                	shr    %cl,%ebp
  804987:	89 e9                	mov    %ebp,%ecx
  804989:	09 f1                	or     %esi,%ecx
  80498b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80498f:	89 f9                	mov    %edi,%ecx
  804991:	d3 e0                	shl    %cl,%eax
  804993:	89 c5                	mov    %eax,%ebp
  804995:	89 d6                	mov    %edx,%esi
  804997:	88 d9                	mov    %bl,%cl
  804999:	d3 ee                	shr    %cl,%esi
  80499b:	89 f9                	mov    %edi,%ecx
  80499d:	d3 e2                	shl    %cl,%edx
  80499f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8049a3:	88 d9                	mov    %bl,%cl
  8049a5:	d3 e8                	shr    %cl,%eax
  8049a7:	09 c2                	or     %eax,%edx
  8049a9:	89 d0                	mov    %edx,%eax
  8049ab:	89 f2                	mov    %esi,%edx
  8049ad:	f7 74 24 0c          	divl   0xc(%esp)
  8049b1:	89 d6                	mov    %edx,%esi
  8049b3:	89 c3                	mov    %eax,%ebx
  8049b5:	f7 e5                	mul    %ebp
  8049b7:	39 d6                	cmp    %edx,%esi
  8049b9:	72 19                	jb     8049d4 <__udivdi3+0xfc>
  8049bb:	74 0b                	je     8049c8 <__udivdi3+0xf0>
  8049bd:	89 d8                	mov    %ebx,%eax
  8049bf:	31 ff                	xor    %edi,%edi
  8049c1:	e9 58 ff ff ff       	jmp    80491e <__udivdi3+0x46>
  8049c6:	66 90                	xchg   %ax,%ax
  8049c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8049cc:	89 f9                	mov    %edi,%ecx
  8049ce:	d3 e2                	shl    %cl,%edx
  8049d0:	39 c2                	cmp    %eax,%edx
  8049d2:	73 e9                	jae    8049bd <__udivdi3+0xe5>
  8049d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8049d7:	31 ff                	xor    %edi,%edi
  8049d9:	e9 40 ff ff ff       	jmp    80491e <__udivdi3+0x46>
  8049de:	66 90                	xchg   %ax,%ax
  8049e0:	31 c0                	xor    %eax,%eax
  8049e2:	e9 37 ff ff ff       	jmp    80491e <__udivdi3+0x46>
  8049e7:	90                   	nop

008049e8 <__umoddi3>:
  8049e8:	55                   	push   %ebp
  8049e9:	57                   	push   %edi
  8049ea:	56                   	push   %esi
  8049eb:	53                   	push   %ebx
  8049ec:	83 ec 1c             	sub    $0x1c,%esp
  8049ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8049f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8049f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8049fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8049ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804a03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804a07:	89 f3                	mov    %esi,%ebx
  804a09:	89 fa                	mov    %edi,%edx
  804a0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a0f:	89 34 24             	mov    %esi,(%esp)
  804a12:	85 c0                	test   %eax,%eax
  804a14:	75 1a                	jne    804a30 <__umoddi3+0x48>
  804a16:	39 f7                	cmp    %esi,%edi
  804a18:	0f 86 a2 00 00 00    	jbe    804ac0 <__umoddi3+0xd8>
  804a1e:	89 c8                	mov    %ecx,%eax
  804a20:	89 f2                	mov    %esi,%edx
  804a22:	f7 f7                	div    %edi
  804a24:	89 d0                	mov    %edx,%eax
  804a26:	31 d2                	xor    %edx,%edx
  804a28:	83 c4 1c             	add    $0x1c,%esp
  804a2b:	5b                   	pop    %ebx
  804a2c:	5e                   	pop    %esi
  804a2d:	5f                   	pop    %edi
  804a2e:	5d                   	pop    %ebp
  804a2f:	c3                   	ret    
  804a30:	39 f0                	cmp    %esi,%eax
  804a32:	0f 87 ac 00 00 00    	ja     804ae4 <__umoddi3+0xfc>
  804a38:	0f bd e8             	bsr    %eax,%ebp
  804a3b:	83 f5 1f             	xor    $0x1f,%ebp
  804a3e:	0f 84 ac 00 00 00    	je     804af0 <__umoddi3+0x108>
  804a44:	bf 20 00 00 00       	mov    $0x20,%edi
  804a49:	29 ef                	sub    %ebp,%edi
  804a4b:	89 fe                	mov    %edi,%esi
  804a4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804a51:	89 e9                	mov    %ebp,%ecx
  804a53:	d3 e0                	shl    %cl,%eax
  804a55:	89 d7                	mov    %edx,%edi
  804a57:	89 f1                	mov    %esi,%ecx
  804a59:	d3 ef                	shr    %cl,%edi
  804a5b:	09 c7                	or     %eax,%edi
  804a5d:	89 e9                	mov    %ebp,%ecx
  804a5f:	d3 e2                	shl    %cl,%edx
  804a61:	89 14 24             	mov    %edx,(%esp)
  804a64:	89 d8                	mov    %ebx,%eax
  804a66:	d3 e0                	shl    %cl,%eax
  804a68:	89 c2                	mov    %eax,%edx
  804a6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a6e:	d3 e0                	shl    %cl,%eax
  804a70:	89 44 24 04          	mov    %eax,0x4(%esp)
  804a74:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a78:	89 f1                	mov    %esi,%ecx
  804a7a:	d3 e8                	shr    %cl,%eax
  804a7c:	09 d0                	or     %edx,%eax
  804a7e:	d3 eb                	shr    %cl,%ebx
  804a80:	89 da                	mov    %ebx,%edx
  804a82:	f7 f7                	div    %edi
  804a84:	89 d3                	mov    %edx,%ebx
  804a86:	f7 24 24             	mull   (%esp)
  804a89:	89 c6                	mov    %eax,%esi
  804a8b:	89 d1                	mov    %edx,%ecx
  804a8d:	39 d3                	cmp    %edx,%ebx
  804a8f:	0f 82 87 00 00 00    	jb     804b1c <__umoddi3+0x134>
  804a95:	0f 84 91 00 00 00    	je     804b2c <__umoddi3+0x144>
  804a9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  804a9f:	29 f2                	sub    %esi,%edx
  804aa1:	19 cb                	sbb    %ecx,%ebx
  804aa3:	89 d8                	mov    %ebx,%eax
  804aa5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804aa9:	d3 e0                	shl    %cl,%eax
  804aab:	89 e9                	mov    %ebp,%ecx
  804aad:	d3 ea                	shr    %cl,%edx
  804aaf:	09 d0                	or     %edx,%eax
  804ab1:	89 e9                	mov    %ebp,%ecx
  804ab3:	d3 eb                	shr    %cl,%ebx
  804ab5:	89 da                	mov    %ebx,%edx
  804ab7:	83 c4 1c             	add    $0x1c,%esp
  804aba:	5b                   	pop    %ebx
  804abb:	5e                   	pop    %esi
  804abc:	5f                   	pop    %edi
  804abd:	5d                   	pop    %ebp
  804abe:	c3                   	ret    
  804abf:	90                   	nop
  804ac0:	89 fd                	mov    %edi,%ebp
  804ac2:	85 ff                	test   %edi,%edi
  804ac4:	75 0b                	jne    804ad1 <__umoddi3+0xe9>
  804ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  804acb:	31 d2                	xor    %edx,%edx
  804acd:	f7 f7                	div    %edi
  804acf:	89 c5                	mov    %eax,%ebp
  804ad1:	89 f0                	mov    %esi,%eax
  804ad3:	31 d2                	xor    %edx,%edx
  804ad5:	f7 f5                	div    %ebp
  804ad7:	89 c8                	mov    %ecx,%eax
  804ad9:	f7 f5                	div    %ebp
  804adb:	89 d0                	mov    %edx,%eax
  804add:	e9 44 ff ff ff       	jmp    804a26 <__umoddi3+0x3e>
  804ae2:	66 90                	xchg   %ax,%ax
  804ae4:	89 c8                	mov    %ecx,%eax
  804ae6:	89 f2                	mov    %esi,%edx
  804ae8:	83 c4 1c             	add    $0x1c,%esp
  804aeb:	5b                   	pop    %ebx
  804aec:	5e                   	pop    %esi
  804aed:	5f                   	pop    %edi
  804aee:	5d                   	pop    %ebp
  804aef:	c3                   	ret    
  804af0:	3b 04 24             	cmp    (%esp),%eax
  804af3:	72 06                	jb     804afb <__umoddi3+0x113>
  804af5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804af9:	77 0f                	ja     804b0a <__umoddi3+0x122>
  804afb:	89 f2                	mov    %esi,%edx
  804afd:	29 f9                	sub    %edi,%ecx
  804aff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804b03:	89 14 24             	mov    %edx,(%esp)
  804b06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804b0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  804b0e:	8b 14 24             	mov    (%esp),%edx
  804b11:	83 c4 1c             	add    $0x1c,%esp
  804b14:	5b                   	pop    %ebx
  804b15:	5e                   	pop    %esi
  804b16:	5f                   	pop    %edi
  804b17:	5d                   	pop    %ebp
  804b18:	c3                   	ret    
  804b19:	8d 76 00             	lea    0x0(%esi),%esi
  804b1c:	2b 04 24             	sub    (%esp),%eax
  804b1f:	19 fa                	sbb    %edi,%edx
  804b21:	89 d1                	mov    %edx,%ecx
  804b23:	89 c6                	mov    %eax,%esi
  804b25:	e9 71 ff ff ff       	jmp    804a9b <__umoddi3+0xb3>
  804b2a:	66 90                	xchg   %ax,%ax
  804b2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804b30:	72 ea                	jb     804b1c <__umoddi3+0x134>
  804b32:	89 d9                	mov    %ebx,%ecx
  804b34:	e9 62 ff ff ff       	jmp    804a9b <__umoddi3+0xb3>
