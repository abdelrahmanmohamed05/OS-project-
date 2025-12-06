
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 8b 02 00 00       	call   8002c1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 a0 41 80 00       	push   $0x8041a0
  800050:	e8 19 1e 00 00       	call   801e6e <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*X = 5 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  800064:	c6 45 e3 79          	movb   $0x79,-0x1d(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	6a 04                	push   $0x4
  80006f:	68 a2 41 80 00       	push   $0x8041a2
  800074:	e8 f5 1d 00 00       	call   801e6e <smalloc>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	*useSem = 0 ;
  80007f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800082:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800088:	80 7d e3 59          	cmpb   $0x59,-0x1d(%ebp)
  80008c:	74 06                	je     800094 <_main+0x5c>
  80008e:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  800092:	75 09                	jne    80009d <_main+0x65>
		*useSem = 1 ;
  800094:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800097:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	struct semaphore T, finished, finishedCountMutex ;
	int *numOfFinished ;
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80009d:	83 ec 04             	sub    $0x4,%esp
  8000a0:	6a 01                	push   $0x1
  8000a2:	6a 04                	push   $0x4
  8000a4:	68 a9 41 80 00       	push   $0x8041a9
  8000a9:	e8 c0 1d 00 00       	call   801e6e <smalloc>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	*numOfFinished = 0 ;
  8000b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	if (*useSem == 1)
  8000bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000c0:	8b 00                	mov    (%eax),%eax
  8000c2:	83 f8 01             	cmp    $0x1,%eax
  8000c5:	75 42                	jne    800109 <_main+0xd1>
	{
		T = create_semaphore("T", 0);
  8000c7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 00                	push   $0x0
  8000cf:	68 b7 41 80 00       	push   $0x8041b7
  8000d4:	50                   	push   %eax
  8000d5:	e8 ef 3d 00 00       	call   803ec9 <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  8000dd:	8d 45 c0             	lea    -0x40(%ebp),%eax
  8000e0:	83 ec 04             	sub    $0x4,%esp
  8000e3:	6a 00                	push   $0x0
  8000e5:	68 b9 41 80 00       	push   $0x8041b9
  8000ea:	50                   	push   %eax
  8000eb:	e8 d9 3d 00 00       	call   803ec9 <create_semaphore>
  8000f0:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  8000f3:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 01                	push   $0x1
  8000fb:	68 c2 41 80 00       	push   $0x8041c2
  800100:	50                   	push   %eax
  800101:	e8 c3 3d 00 00       	call   803ec9 <create_semaphore>
  800106:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800109:	a1 20 50 80 00       	mov    0x805020,%eax
  80010e:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800114:	89 c2                	mov    %eax,%edx
  800116:	a1 20 50 80 00       	mov    0x805020,%eax
  80011b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800121:	6a 32                	push   $0x32
  800123:	52                   	push   %edx
  800124:	50                   	push   %eax
  800125:	68 d5 41 80 00       	push   $0x8041d5
  80012a:	e8 d5 2f 00 00       	call   803104 <sys_create_env>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800135:	a1 20 50 80 00       	mov    0x805020,%eax
  80013a:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800140:	89 c2                	mov    %eax,%edx
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80014d:	6a 32                	push   $0x32
  80014f:	52                   	push   %edx
  800150:	50                   	push   %eax
  800151:	68 df 41 80 00       	push   $0x8041df
  800156:	e8 a9 2f 00 00       	call   803104 <sys_create_env>
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800161:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  800165:	74 06                	je     80016d <_main+0x135>
  800167:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  80016b:	75 14                	jne    800181 <_main+0x149>
		panic("NO AVAILABLE ENVs...");
  80016d:	83 ec 04             	sub    $0x4,%esp
  800170:	68 e9 41 80 00       	push   $0x8041e9
  800175:	6a 2b                	push   $0x2b
  800177:	68 fe 41 80 00       	push   $0x8041fe
  80017c:	e8 f0 02 00 00       	call   800471 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 d4             	pushl  -0x2c(%ebp)
  800187:	e8 96 2f 00 00       	call   803122 <sys_run_env>
  80018c:	83 c4 10             	add    $0x10,%esp
	//env_sleep(10000);
	sys_run_env(envIdProcessB);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	ff 75 d0             	pushl  -0x30(%ebp)
  800195:	e8 88 2f 00 00       	call   803122 <sys_run_env>
  80019a:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	if (*useSem == 1)
  80019d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	83 f8 01             	cmp    $0x1,%eax
  8001a5:	75 1e                	jne    8001c5 <_main+0x18d>
	{
		wait_semaphore(finished);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 c0             	pushl  -0x40(%ebp)
  8001ad:	e8 4b 3d 00 00       	call   803efd <wait_semaphore>
  8001b2:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	ff 75 c0             	pushl  -0x40(%ebp)
  8001bb:	e8 3d 3d 00 00       	call   803efd <wait_semaphore>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	eb 0b                	jmp    8001d0 <_main+0x198>
	}
	else
	{
		while (*numOfFinished != 2) ;
  8001c5:	90                   	nop
  8001c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001c9:	8b 00                	mov    (%eax),%eax
  8001cb:	83 f8 02             	cmp    $0x2,%eax
  8001ce:	75 f6                	jne    8001c6 <_main+0x18e>
	}

	/*[6] PRINT X*/
	atomic_cprintf("Final value of X = %d\n", *X);
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	50                   	push   %eax
  8001d9:	68 19 42 80 00       	push   $0x804219
  8001de:	e8 ce 05 00 00       	call   8007b1 <atomic_cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp

	//ensure that X has the expected value (=11)
	if (*X != 11)
  8001e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	83 f8 0b             	cmp    $0xb,%eax
  8001ee:	74 14                	je     800204 <_main+0x1cc>
		panic("Final value of X is not correct. Semaphore and/or shared variables are not working correctly\n");
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 30 42 80 00       	push   $0x804230
  8001f8:	6a 42                	push   $0x42
  8001fa:	68 fe 41 80 00       	push   $0x8041fe
  8001ff:	e8 6d 02 00 00       	call   800471 <_panic>

	int32 parentenvID = sys_getparentenvid();
  800204:	e8 82 2f 00 00       	call   80318b <sys_getparentenvid>
  800209:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if(parentenvID > 0)
  80020c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800210:	0f 8e a2 00 00 00    	jle    8002b8 <_main+0x280>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  800216:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	68 a9 41 80 00       	push   $0x8041a9
  800225:	ff 75 cc             	pushl  -0x34(%ebp)
  800228:	e8 9b 1f 00 00       	call   8021c8 <sget>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	89 45 c8             	mov    %eax,-0x38(%ebp)

		//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
		//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
		//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
		//	2. changing the # free frames
		char changeIntCmd[100] = "__changeInterruptStatus__";
  800233:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800239:	bb 8e 42 80 00       	mov    $0x80428e,%ebx
  80023e:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800243:	89 c7                	mov    %eax,%edi
  800245:	89 de                	mov    %ebx,%esi
  800247:	89 d1                	mov    %edx,%ecx
  800249:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80024b:	8d 95 72 ff ff ff    	lea    -0x8e(%ebp),%edx
  800251:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800256:	b0 00                	mov    $0x0,%al
  800258:	89 d7                	mov    %edx,%edi
  80025a:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(changeIntCmd, 0);
  80025c:	83 ec 08             	sub    $0x8,%esp
  80025f:	6a 00                	push   $0x0
  800261:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800267:	50                   	push   %eax
  800268:	e8 3b 31 00 00       	call   8033a8 <sys_utilities>
  80026d:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(envIdProcessA);
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	ff 75 d4             	pushl  -0x2c(%ebp)
  800276:	e8 c3 2e 00 00       	call   80313e <sys_destroy_env>
  80027b:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdProcessB);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 d0             	pushl  -0x30(%ebp)
  800284:	e8 b5 2e 00 00       	call   80313e <sys_destroy_env>
  800289:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	6a 01                	push   $0x1
  800291:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800297:	50                   	push   %eax
  800298:	e8 0b 31 00 00       	call   8033a8 <sys_utilities>
  80029d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002a0:	e8 54 2c 00 00       	call   802ef9 <sys_lock_cons>
		{
			(*AllFinish)++ ;
  8002a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a8:	8b 00                	mov    (%eax),%eax
  8002aa:	8d 50 01             	lea    0x1(%eax),%edx
  8002ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002b0:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8002b2:	e8 5c 2c 00 00       	call   802f13 <sys_unlock_cons>
	}

	return;
  8002b7:	90                   	nop
  8002b8:	90                   	nop
}
  8002b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bc:	5b                   	pop    %ebx
  8002bd:	5e                   	pop    %esi
  8002be:	5f                   	pop    %edi
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    

008002c1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	57                   	push   %edi
  8002c5:	56                   	push   %esi
  8002c6:	53                   	push   %ebx
  8002c7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ca:	e8 a3 2e 00 00       	call   803172 <sys_getenvindex>
  8002cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002d5:	89 d0                	mov    %edx,%eax
  8002d7:	c1 e0 03             	shl    $0x3,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	c1 e0 02             	shl    $0x2,%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e8:	01 d0                	add    %edx,%eax
  8002ea:	c1 e0 03             	shl    $0x3,%eax
  8002ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002fc:	8a 40 20             	mov    0x20(%eax),%al
  8002ff:	84 c0                	test   %al,%al
  800301:	74 0d                	je     800310 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800303:	a1 20 50 80 00       	mov    0x805020,%eax
  800308:	83 c0 20             	add    $0x20,%eax
  80030b:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x5f>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800331:	a1 00 50 80 00       	mov    0x805000,%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	0f 84 01 01 00 00    	je     80043f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80033e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800344:	bb ec 43 80 00       	mov    $0x8043ec,%ebx
  800349:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034e:	89 c7                	mov    %eax,%edi
  800350:	89 de                	mov    %ebx,%esi
  800352:	89 d1                	mov    %edx,%ecx
  800354:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800356:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800359:	b9 56 00 00 00       	mov    $0x56,%ecx
  80035e:	b0 00                	mov    $0x0,%al
  800360:	89 d7                	mov    %edx,%edi
  800362:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800364:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80036b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	50                   	push   %eax
  800372:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800378:	50                   	push   %eax
  800379:	e8 2a 30 00 00       	call   8033a8 <sys_utilities>
  80037e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800381:	e8 73 2b 00 00       	call   802ef9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 0c 43 80 00       	push   $0x80430c
  80038e:	e8 ac 03 00 00       	call   80073f <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800399:	85 c0                	test   %eax,%eax
  80039b:	74 18                	je     8003b5 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80039d:	e8 24 30 00 00       	call   8033c6 <sys_get_optimal_num_faults>
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 34 43 80 00       	push   $0x804334
  8003ab:	e8 8f 03 00 00       	call   80073f <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	eb 59                	jmp    80040e <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ba:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8003c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c5:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	52                   	push   %edx
  8003cf:	50                   	push   %eax
  8003d0:	68 58 43 80 00       	push   $0x804358
  8003d5:	e8 65 03 00 00       	call   80073f <cprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e2:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ed:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003fe:	51                   	push   %ecx
  8003ff:	52                   	push   %edx
  800400:	50                   	push   %eax
  800401:	68 80 43 80 00       	push   $0x804380
  800406:	e8 34 03 00 00       	call   80073f <cprintf>
  80040b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80040e:	a1 20 50 80 00       	mov    0x805020,%eax
  800413:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 d8 43 80 00       	push   $0x8043d8
  800422:	e8 18 03 00 00       	call   80073f <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	68 0c 43 80 00       	push   $0x80430c
  800432:	e8 08 03 00 00       	call   80073f <cprintf>
  800437:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80043a:	e8 d4 2a 00 00       	call   802f13 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80043f:	e8 1f 00 00 00       	call   800463 <exit>
}
  800444:	90                   	nop
  800445:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800448:	5b                   	pop    %ebx
  800449:	5e                   	pop    %esi
  80044a:	5f                   	pop    %edi
  80044b:	5d                   	pop    %ebp
  80044c:	c3                   	ret    

0080044d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	6a 00                	push   $0x0
  800458:	e8 e1 2c 00 00       	call   80313e <sys_destroy_env>
  80045d:	83 c4 10             	add    $0x10,%esp
}
  800460:	90                   	nop
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <exit>:

void
exit(void)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800469:	e8 36 2d 00 00       	call   8031a4 <sys_exit_env>
}
  80046e:	90                   	nop
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800477:	8d 45 10             	lea    0x10(%ebp),%eax
  80047a:	83 c0 04             	add    $0x4,%eax
  80047d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800480:	a1 38 51 83 00       	mov    0x835138,%eax
  800485:	85 c0                	test   %eax,%eax
  800487:	74 16                	je     80049f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800489:	a1 38 51 83 00       	mov    0x835138,%eax
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	50                   	push   %eax
  800492:	68 50 44 80 00       	push   $0x804450
  800497:	e8 a3 02 00 00       	call   80073f <cprintf>
  80049c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80049f:	a1 04 50 80 00       	mov    0x805004,%eax
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	ff 75 0c             	pushl  0xc(%ebp)
  8004aa:	ff 75 08             	pushl  0x8(%ebp)
  8004ad:	50                   	push   %eax
  8004ae:	68 58 44 80 00       	push   $0x804458
  8004b3:	6a 74                	push   $0x74
  8004b5:	e8 b2 02 00 00       	call   80076c <cprintf_colored>
  8004ba:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c6:	50                   	push   %eax
  8004c7:	e8 04 02 00 00       	call   8006d0 <vcprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	6a 00                	push   $0x0
  8004d4:	68 80 44 80 00       	push   $0x804480
  8004d9:	e8 f2 01 00 00       	call   8006d0 <vcprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004e1:	e8 7d ff ff ff       	call   800463 <exit>

	// should not return here
	while (1) ;
  8004e6:	eb fe                	jmp    8004e6 <_panic+0x75>

008004e8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fc:	39 c2                	cmp    %eax,%edx
  8004fe:	74 14                	je     800514 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	68 84 44 80 00       	push   $0x804484
  800508:	6a 26                	push   $0x26
  80050a:	68 d0 44 80 00       	push   $0x8044d0
  80050f:	e8 5d ff ff ff       	call   800471 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800514:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80051b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800522:	e9 c5 00 00 00       	jmp    8005ec <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800531:	8b 45 08             	mov    0x8(%ebp),%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	85 c0                	test   %eax,%eax
  80053a:	75 08                	jne    800544 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80053c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80053f:	e9 a5 00 00 00       	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800544:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800552:	eb 69                	jmp    8005bd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800554:	a1 20 50 80 00       	mov    0x805020,%eax
  800559:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80055f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800562:	89 d0                	mov    %edx,%eax
  800564:	01 c0                	add    %eax,%eax
  800566:	01 d0                	add    %edx,%eax
  800568:	c1 e0 03             	shl    $0x3,%eax
  80056b:	01 c8                	add    %ecx,%eax
  80056d:	8a 40 04             	mov    0x4(%eax),%al
  800570:	84 c0                	test   %al,%al
  800572:	75 46                	jne    8005ba <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800574:	a1 20 50 80 00       	mov    0x805020,%eax
  800579:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80057f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800582:	89 d0                	mov    %edx,%eax
  800584:	01 c0                	add    %eax,%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c1 e0 03             	shl    $0x3,%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800592:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	01 c8                	add    %ecx,%eax
  8005ab:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ad:	39 c2                	cmp    %eax,%edx
  8005af:	75 09                	jne    8005ba <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005b1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b8:	eb 15                	jmp    8005cf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ba:	ff 45 e8             	incl   -0x18(%ebp)
  8005bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005cb:	39 c2                	cmp    %eax,%edx
  8005cd:	77 85                	ja     800554 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d3:	75 14                	jne    8005e9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005d5:	83 ec 04             	sub    $0x4,%esp
  8005d8:	68 dc 44 80 00       	push   $0x8044dc
  8005dd:	6a 3a                	push   $0x3a
  8005df:	68 d0 44 80 00       	push   $0x8044d0
  8005e4:	e8 88 fe ff ff       	call   800471 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005e9:	ff 45 f0             	incl   -0x10(%ebp)
  8005ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f2:	0f 8c 2f ff ff ff    	jl     800527 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800606:	eb 26                	jmp    80062e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800608:	a1 20 50 80 00       	mov    0x805020,%eax
  80060d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800613:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800616:	89 d0                	mov    %edx,%eax
  800618:	01 c0                	add    %eax,%eax
  80061a:	01 d0                	add    %edx,%eax
  80061c:	c1 e0 03             	shl    $0x3,%eax
  80061f:	01 c8                	add    %ecx,%eax
  800621:	8a 40 04             	mov    0x4(%eax),%al
  800624:	3c 01                	cmp    $0x1,%al
  800626:	75 03                	jne    80062b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800628:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062b:	ff 45 e0             	incl   -0x20(%ebp)
  80062e:	a1 20 50 80 00       	mov    0x805020,%eax
  800633:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800639:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	77 c8                	ja     800608 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800643:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800646:	74 14                	je     80065c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800648:	83 ec 04             	sub    $0x4,%esp
  80064b:	68 30 45 80 00       	push   $0x804530
  800650:	6a 44                	push   $0x44
  800652:	68 d0 44 80 00       	push   $0x8044d0
  800657:	e8 15 fe ff ff       	call   800471 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80065c:	90                   	nop
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	53                   	push   %ebx
  800663:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800666:	8b 45 0c             	mov    0xc(%ebp),%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	8d 48 01             	lea    0x1(%eax),%ecx
  80066e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800671:	89 0a                	mov    %ecx,(%edx)
  800673:	8b 55 08             	mov    0x8(%ebp),%edx
  800676:	88 d1                	mov    %dl,%cl
  800678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	3d ff 00 00 00       	cmp    $0xff,%eax
  800689:	75 30                	jne    8006bb <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80068b:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800691:	a0 64 d0 81 00       	mov    0x81d064,%al
  800696:	0f b6 c0             	movzbl %al,%eax
  800699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80069c:	8b 09                	mov    (%ecx),%ecx
  80069e:	89 cb                	mov    %ecx,%ebx
  8006a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a3:	83 c1 08             	add    $0x8,%ecx
  8006a6:	52                   	push   %edx
  8006a7:	50                   	push   %eax
  8006a8:	53                   	push   %ebx
  8006a9:	51                   	push   %ecx
  8006aa:	e8 06 28 00 00       	call   802eb5 <sys_cputs>
  8006af:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006be:	8b 40 04             	mov    0x4(%eax),%eax
  8006c1:	8d 50 01             	lea    0x1(%eax),%edx
  8006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ca:	90                   	nop
  8006cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ce:	c9                   	leave  
  8006cf:	c3                   	ret    

008006d0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
  8006d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e0:	00 00 00 
	b.cnt = 0;
  8006e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ed:	ff 75 0c             	pushl  0xc(%ebp)
  8006f0:	ff 75 08             	pushl  0x8(%ebp)
  8006f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f9:	50                   	push   %eax
  8006fa:	68 5f 06 80 00       	push   $0x80065f
  8006ff:	e8 5a 02 00 00       	call   80095e <vprintfmt>
  800704:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800707:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80070d:	a0 64 d0 81 00       	mov    0x81d064,%al
  800712:	0f b6 c0             	movzbl %al,%eax
  800715:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80071b:	52                   	push   %edx
  80071c:	50                   	push   %eax
  80071d:	51                   	push   %ecx
  80071e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800724:	83 c0 08             	add    $0x8,%eax
  800727:	50                   	push   %eax
  800728:	e8 88 27 00 00       	call   802eb5 <sys_cputs>
  80072d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800730:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800737:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    

0080073f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800745:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  80074c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 f4             	pushl  -0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	e8 6f ff ff ff       	call   8006d0 <vcprintf>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800767:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800772:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	c1 e0 08             	shl    $0x8,%eax
  80077f:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800784:	8d 45 0c             	lea    0xc(%ebp),%eax
  800787:	83 c0 04             	add    $0x4,%eax
  80078a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 f4             	pushl  -0xc(%ebp)
  800796:	50                   	push   %eax
  800797:	e8 34 ff ff ff       	call   8006d0 <vcprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007a2:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  8007a9:	07 00 00 

	return cnt;
  8007ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007af:	c9                   	leave  
  8007b0:	c3                   	ret    

008007b1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007b7:	e8 3d 27 00 00       	call   802ef9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cb:	50                   	push   %eax
  8007cc:	e8 ff fe ff ff       	call   8006d0 <vcprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007d7:	e8 37 27 00 00       	call   802f13 <sys_unlock_cons>
	return cnt;
  8007dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007df:	c9                   	leave  
  8007e0:	c3                   	ret    

008007e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	53                   	push   %ebx
  8007e5:	83 ec 14             	sub    $0x14,%esp
  8007e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ff:	77 55                	ja     800856 <printnum+0x75>
  800801:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800804:	72 05                	jb     80080b <printnum+0x2a>
  800806:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800809:	77 4b                	ja     800856 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80080b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80080e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800811:	8b 45 18             	mov    0x18(%ebp),%eax
  800814:	ba 00 00 00 00       	mov    $0x0,%edx
  800819:	52                   	push   %edx
  80081a:	50                   	push   %eax
  80081b:	ff 75 f4             	pushl  -0xc(%ebp)
  80081e:	ff 75 f0             	pushl  -0x10(%ebp)
  800821:	e8 16 37 00 00       	call   803f3c <__udivdi3>
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	ff 75 20             	pushl  0x20(%ebp)
  80082f:	53                   	push   %ebx
  800830:	ff 75 18             	pushl  0x18(%ebp)
  800833:	52                   	push   %edx
  800834:	50                   	push   %eax
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	ff 75 08             	pushl  0x8(%ebp)
  80083b:	e8 a1 ff ff ff       	call   8007e1 <printnum>
  800840:	83 c4 20             	add    $0x20,%esp
  800843:	eb 1a                	jmp    80085f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 20             	pushl  0x20(%ebp)
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	ff d0                	call   *%eax
  800853:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800856:	ff 4d 1c             	decl   0x1c(%ebp)
  800859:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80085d:	7f e6                	jg     800845 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80085f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800862:	bb 00 00 00 00       	mov    $0x0,%ebx
  800867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086d:	53                   	push   %ebx
  80086e:	51                   	push   %ecx
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	e8 d6 37 00 00       	call   80404c <__umoddi3>
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	05 94 47 80 00       	add    $0x804794,%eax
  80087e:	8a 00                	mov    (%eax),%al
  800880:	0f be c0             	movsbl %al,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	50                   	push   %eax
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	ff d0                	call   *%eax
  80088f:	83 c4 10             	add    $0x10,%esp
}
  800892:	90                   	nop
  800893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800896:	c9                   	leave  
  800897:	c3                   	ret    

00800898 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80089b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089f:	7e 1c                	jle    8008bd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	8d 50 08             	lea    0x8(%eax),%edx
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	89 10                	mov    %edx,(%eax)
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	83 e8 08             	sub    $0x8,%eax
  8008b6:	8b 50 04             	mov    0x4(%eax),%edx
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	eb 40                	jmp    8008fd <getuint+0x65>
	else if (lflag)
  8008bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c1:	74 1e                	je     8008e1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 04             	lea    0x4(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 04             	sub    $0x4,%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	ba 00 00 00 00       	mov    $0x0,%edx
  8008df:	eb 1c                	jmp    8008fd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	8d 50 04             	lea    0x4(%eax),%edx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	89 10                	mov    %edx,(%eax)
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800902:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800906:	7e 1c                	jle    800924 <getint+0x25>
		return va_arg(*ap, long long);
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	8d 50 08             	lea    0x8(%eax),%edx
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	89 10                	mov    %edx,(%eax)
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	83 e8 08             	sub    $0x8,%eax
  80091d:	8b 50 04             	mov    0x4(%eax),%edx
  800920:	8b 00                	mov    (%eax),%eax
  800922:	eb 38                	jmp    80095c <getint+0x5d>
	else if (lflag)
  800924:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800928:	74 1a                	je     800944 <getint+0x45>
		return va_arg(*ap, long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 04             	lea    0x4(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 04             	sub    $0x4,%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	99                   	cltd   
  800942:	eb 18                	jmp    80095c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	8d 50 04             	lea    0x4(%eax),%edx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	89 10                	mov    %edx,(%eax)
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	83 e8 04             	sub    $0x4,%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	99                   	cltd   
}
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	56                   	push   %esi
  800962:	53                   	push   %ebx
  800963:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800966:	eb 17                	jmp    80097f <vprintfmt+0x21>
			if (ch == '\0')
  800968:	85 db                	test   %ebx,%ebx
  80096a:	0f 84 c1 03 00 00    	je     800d31 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	53                   	push   %ebx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	ff d0                	call   *%eax
  80097c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097f:	8b 45 10             	mov    0x10(%ebp),%eax
  800982:	8d 50 01             	lea    0x1(%eax),%edx
  800985:	89 55 10             	mov    %edx,0x10(%ebp)
  800988:	8a 00                	mov    (%eax),%al
  80098a:	0f b6 d8             	movzbl %al,%ebx
  80098d:	83 fb 25             	cmp    $0x25,%ebx
  800990:	75 d6                	jne    800968 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800992:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800996:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80099d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b5:	8d 50 01             	lea    0x1(%eax),%edx
  8009b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bb:	8a 00                	mov    (%eax),%al
  8009bd:	0f b6 d8             	movzbl %al,%ebx
  8009c0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c3:	83 f8 5b             	cmp    $0x5b,%eax
  8009c6:	0f 87 3d 03 00 00    	ja     800d09 <vprintfmt+0x3ab>
  8009cc:	8b 04 85 b8 47 80 00 	mov    0x8047b8(,%eax,4),%eax
  8009d3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009d9:	eb d7                	jmp    8009b2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009db:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d1                	jmp    8009b2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009eb:	89 d0                	mov    %edx,%eax
  8009ed:	c1 e0 02             	shl    $0x2,%eax
  8009f0:	01 d0                	add    %edx,%eax
  8009f2:	01 c0                	add    %eax,%eax
  8009f4:	01 d8                	add    %ebx,%eax
  8009f6:	83 e8 30             	sub    $0x30,%eax
  8009f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ff:	8a 00                	mov    (%eax),%al
  800a01:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a04:	83 fb 2f             	cmp    $0x2f,%ebx
  800a07:	7e 3e                	jle    800a47 <vprintfmt+0xe9>
  800a09:	83 fb 39             	cmp    $0x39,%ebx
  800a0c:	7f 39                	jg     800a47 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a11:	eb d5                	jmp    8009e8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	83 c0 04             	add    $0x4,%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	83 e8 04             	sub    $0x4,%eax
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a27:	eb 1f                	jmp    800a48 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2d:	79 83                	jns    8009b2 <vprintfmt+0x54>
				width = 0;
  800a2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a36:	e9 77 ff ff ff       	jmp    8009b2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a3b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a42:	e9 6b ff ff ff       	jmp    8009b2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a47:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4c:	0f 89 60 ff ff ff    	jns    8009b2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a58:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a5f:	e9 4e ff ff ff       	jmp    8009b2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a64:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a67:	e9 46 ff ff ff       	jmp    8009b2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 c0 04             	add    $0x4,%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	83 e8 04             	sub    $0x4,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	50                   	push   %eax
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	ff d0                	call   *%eax
  800a89:	83 c4 10             	add    $0x10,%esp
			break;
  800a8c:	e9 9b 02 00 00       	jmp    800d2c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	83 c0 04             	add    $0x4,%eax
  800a97:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	83 e8 04             	sub    $0x4,%eax
  800aa0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa2:	85 db                	test   %ebx,%ebx
  800aa4:	79 02                	jns    800aa8 <vprintfmt+0x14a>
				err = -err;
  800aa6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aa8:	83 fb 64             	cmp    $0x64,%ebx
  800aab:	7f 0b                	jg     800ab8 <vprintfmt+0x15a>
  800aad:	8b 34 9d 00 46 80 00 	mov    0x804600(,%ebx,4),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 19                	jne    800ad1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ab8:	53                   	push   %ebx
  800ab9:	68 a5 47 80 00       	push   $0x8047a5
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 70 02 00 00       	call   800d39 <printfmt>
  800ac9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800acc:	e9 5b 02 00 00       	jmp    800d2c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad1:	56                   	push   %esi
  800ad2:	68 ae 47 80 00       	push   $0x8047ae
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 57 02 00 00       	call   800d39 <printfmt>
  800ae2:	83 c4 10             	add    $0x10,%esp
			break;
  800ae5:	e9 42 02 00 00       	jmp    800d2c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 c0 04             	add    $0x4,%eax
  800af0:	89 45 14             	mov    %eax,0x14(%ebp)
  800af3:	8b 45 14             	mov    0x14(%ebp),%eax
  800af6:	83 e8 04             	sub    $0x4,%eax
  800af9:	8b 30                	mov    (%eax),%esi
  800afb:	85 f6                	test   %esi,%esi
  800afd:	75 05                	jne    800b04 <vprintfmt+0x1a6>
				p = "(null)";
  800aff:	be b1 47 80 00       	mov    $0x8047b1,%esi
			if (width > 0 && padc != '-')
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7e 6d                	jle    800b77 <vprintfmt+0x219>
  800b0a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b0e:	74 67                	je     800b77 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	50                   	push   %eax
  800b17:	56                   	push   %esi
  800b18:	e8 1e 03 00 00       	call   800e3b <strnlen>
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b23:	eb 16                	jmp    800b3b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b25:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	50                   	push   %eax
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b38:	ff 4d e4             	decl   -0x1c(%ebp)
  800b3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3f:	7f e4                	jg     800b25 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b41:	eb 34                	jmp    800b77 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b47:	74 1c                	je     800b65 <vprintfmt+0x207>
  800b49:	83 fb 1f             	cmp    $0x1f,%ebx
  800b4c:	7e 05                	jle    800b53 <vprintfmt+0x1f5>
  800b4e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b51:	7e 12                	jle    800b65 <vprintfmt+0x207>
					putch('?', putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	6a 3f                	push   $0x3f
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
  800b63:	eb 0f                	jmp    800b74 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	53                   	push   %ebx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b74:	ff 4d e4             	decl   -0x1c(%ebp)
  800b77:	89 f0                	mov    %esi,%eax
  800b79:	8d 70 01             	lea    0x1(%eax),%esi
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f be d8             	movsbl %al,%ebx
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	74 24                	je     800ba9 <vprintfmt+0x24b>
  800b85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b89:	78 b8                	js     800b43 <vprintfmt+0x1e5>
  800b8b:	ff 4d e0             	decl   -0x20(%ebp)
  800b8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b92:	79 af                	jns    800b43 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b94:	eb 13                	jmp    800ba9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	6a 20                	push   $0x20
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bad:	7f e7                	jg     800b96 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800baf:	e9 78 01 00 00       	jmp    800d2c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 e8             	pushl  -0x18(%ebp)
  800bba:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbd:	50                   	push   %eax
  800bbe:	e8 3c fd ff ff       	call   8008ff <getint>
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd2:	85 d2                	test   %edx,%edx
  800bd4:	79 23                	jns    800bf9 <vprintfmt+0x29b>
				putch('-', putdat);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	6a 2d                	push   $0x2d
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	ff d0                	call   *%eax
  800be3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bec:	f7 d8                	neg    %eax
  800bee:	83 d2 00             	adc    $0x0,%edx
  800bf1:	f7 da                	neg    %edx
  800bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bf9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c00:	e9 bc 00 00 00       	jmp    800cc1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 e8             	pushl  -0x18(%ebp)
  800c0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0e:	50                   	push   %eax
  800c0f:	e8 84 fc ff ff       	call   800898 <getuint>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c24:	e9 98 00 00 00       	jmp    800cc1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	6a 58                	push   $0x58
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 58                	push   $0x58
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 58                	push   $0x58
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			break;
  800c59:	e9 ce 00 00 00       	jmp    800d2c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	6a 30                	push   $0x30
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	6a 78                	push   $0x78
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 14             	mov    %eax,0x14(%ebp)
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	83 e8 04             	sub    $0x4,%eax
  800c8d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca0:	eb 1f                	jmp    800cc1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca8:	8d 45 14             	lea    0x14(%ebp),%eax
  800cab:	50                   	push   %eax
  800cac:	e8 e7 fb ff ff       	call   800898 <getuint>
  800cb1:	83 c4 10             	add    $0x10,%esp
  800cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc8:	83 ec 04             	sub    $0x4,%esp
  800ccb:	52                   	push   %edx
  800ccc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ccf:	50                   	push   %eax
  800cd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd3:	ff 75 f0             	pushl  -0x10(%ebp)
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 00 fb ff ff       	call   8007e1 <printnum>
  800ce1:	83 c4 20             	add    $0x20,%esp
			break;
  800ce4:	eb 46                	jmp    800d2c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce6:	83 ec 08             	sub    $0x8,%esp
  800ce9:	ff 75 0c             	pushl  0xc(%ebp)
  800cec:	53                   	push   %ebx
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
			break;
  800cf5:	eb 35                	jmp    800d2c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cf7:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800cfe:	eb 2c                	jmp    800d2c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d00:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800d07:	eb 23                	jmp    800d2c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d09:	83 ec 08             	sub    $0x8,%esp
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	6a 25                	push   $0x25
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	ff d0                	call   *%eax
  800d16:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d19:	ff 4d 10             	decl   0x10(%ebp)
  800d1c:	eb 03                	jmp    800d21 <vprintfmt+0x3c3>
  800d1e:	ff 4d 10             	decl   0x10(%ebp)
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	48                   	dec    %eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3c 25                	cmp    $0x25,%al
  800d29:	75 f3                	jne    800d1e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d2b:	90                   	nop
		}
	}
  800d2c:	e9 35 fc ff ff       	jmp    800966 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d31:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d3f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d42:	83 c0 04             	add    $0x4,%eax
  800d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d48:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	ff 75 0c             	pushl  0xc(%ebp)
  800d52:	ff 75 08             	pushl  0x8(%ebp)
  800d55:	e8 04 fc ff ff       	call   80095e <vprintfmt>
  800d5a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d5d:	90                   	nop
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 40 08             	mov    0x8(%eax),%eax
  800d69:	8d 50 01             	lea    0x1(%eax),%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8b 10                	mov    (%eax),%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8b 40 04             	mov    0x4(%eax),%eax
  800d7d:	39 c2                	cmp    %eax,%edx
  800d7f:	73 12                	jae    800d93 <sprintputch+0x33>
		*b->buf++ = ch;
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8b 00                	mov    (%eax),%eax
  800d86:	8d 48 01             	lea    0x1(%eax),%ecx
  800d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8c:	89 0a                	mov    %ecx,(%edx)
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	88 10                	mov    %dl,(%eax)
}
  800d93:	90                   	nop
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	01 d0                	add    %edx,%eax
  800dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800db7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dbb:	74 06                	je     800dc3 <vsnprintf+0x2d>
  800dbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc1:	7f 07                	jg     800dca <vsnprintf+0x34>
		return -E_INVAL;
  800dc3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc8:	eb 20                	jmp    800dea <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dca:	ff 75 14             	pushl  0x14(%ebp)
  800dcd:	ff 75 10             	pushl  0x10(%ebp)
  800dd0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dd3:	50                   	push   %eax
  800dd4:	68 60 0d 80 00       	push   $0x800d60
  800dd9:	e8 80 fb ff ff       	call   80095e <vprintfmt>
  800dde:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800df2:	8d 45 10             	lea    0x10(%ebp),%eax
  800df5:	83 c0 04             	add    $0x4,%eax
  800df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfe:	ff 75 f4             	pushl  -0xc(%ebp)
  800e01:	50                   	push   %eax
  800e02:	ff 75 0c             	pushl  0xc(%ebp)
  800e05:	ff 75 08             	pushl  0x8(%ebp)
  800e08:	e8 89 ff ff ff       	call   800d96 <vsnprintf>
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e25:	eb 06                	jmp    800e2d <strlen+0x15>
		n++;
  800e27:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 f1                	jne    800e27 <strlen+0xf>
		n++;
	return n;
  800e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e48:	eb 09                	jmp    800e53 <strnlen+0x18>
		n++;
  800e4a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e4d:	ff 45 08             	incl   0x8(%ebp)
  800e50:	ff 4d 0c             	decl   0xc(%ebp)
  800e53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e57:	74 09                	je     800e62 <strnlen+0x27>
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	84 c0                	test   %al,%al
  800e60:	75 e8                	jne    800e4a <strnlen+0xf>
		n++;
	return n;
  800e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e73:	90                   	nop
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	75 e4                	jne    800e74 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ea1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea8:	eb 1f                	jmp    800ec9 <strncpy+0x34>
		*dst++ = *src;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8d 50 01             	lea    0x1(%eax),%edx
  800eb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb6:	8a 12                	mov    (%edx),%dl
  800eb8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	84 c0                	test   %al,%al
  800ec1:	74 03                	je     800ec6 <strncpy+0x31>
			src++;
  800ec3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ecf:	72 d9                	jb     800eaa <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ed1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee6:	74 30                	je     800f18 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ee8:	eb 16                	jmp    800f00 <strlcpy+0x2a>
			*dst++ = *src++;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8d 50 01             	lea    0x1(%eax),%edx
  800ef0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800efc:	8a 12                	mov    (%edx),%dl
  800efe:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f00:	ff 4d 10             	decl   0x10(%ebp)
  800f03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f07:	74 09                	je     800f12 <strlcpy+0x3c>
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	84 c0                	test   %al,%al
  800f10:	75 d8                	jne    800eea <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1e:	29 c2                	sub    %eax,%edx
  800f20:	89 d0                	mov    %edx,%eax
}
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f27:	eb 06                	jmp    800f2f <strcmp+0xb>
		p++, q++;
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	84 c0                	test   %al,%al
  800f36:	74 0e                	je     800f46 <strcmp+0x22>
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 10                	mov    (%eax),%dl
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	38 c2                	cmp    %al,%dl
  800f44:	74 e3                	je     800f29 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f b6 d0             	movzbl %al,%edx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f b6 c0             	movzbl %al,%eax
  800f56:	29 c2                	sub    %eax,%edx
  800f58:	89 d0                	mov    %edx,%eax
}
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f5f:	eb 09                	jmp    800f6a <strncmp+0xe>
		n--, p++, q++;
  800f61:	ff 4d 10             	decl   0x10(%ebp)
  800f64:	ff 45 08             	incl   0x8(%ebp)
  800f67:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6e:	74 17                	je     800f87 <strncmp+0x2b>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	84 c0                	test   %al,%al
  800f77:	74 0e                	je     800f87 <strncmp+0x2b>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 10                	mov    (%eax),%dl
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	38 c2                	cmp    %al,%dl
  800f85:	74 da                	je     800f61 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8b:	75 07                	jne    800f94 <strncmp+0x38>
		return 0;
  800f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f92:	eb 14                	jmp    800fa8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	0f b6 d0             	movzbl %al,%edx
  800f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 c0             	movzbl %al,%eax
  800fa4:	29 c2                	sub    %eax,%edx
  800fa6:	89 d0                	mov    %edx,%eax
}
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 04             	sub    $0x4,%esp
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb6:	eb 12                	jmp    800fca <strchr+0x20>
		if (*s == c)
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc0:	75 05                	jne    800fc7 <strchr+0x1d>
			return (char *) s;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	eb 11                	jmp    800fd8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fc7:	ff 45 08             	incl   0x8(%ebp)
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	84 c0                	test   %al,%al
  800fd1:	75 e5                	jne    800fb8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd8:	c9                   	leave  
  800fd9:	c3                   	ret    

00800fda <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 04             	sub    $0x4,%esp
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe6:	eb 0d                	jmp    800ff5 <strfind+0x1b>
		if (*s == c)
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff0:	74 0e                	je     801000 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	84 c0                	test   %al,%al
  800ffc:	75 ea                	jne    800fe8 <strfind+0xe>
  800ffe:	eb 01                	jmp    801001 <strfind+0x27>
		if (*s == c)
			break;
  801000:	90                   	nop
	return (char *) s;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801012:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801016:	76 63                	jbe    80107b <memset+0x75>
		uint64 data_block = c;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	99                   	cltd   
  80101c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80102c:	c1 e0 08             	shl    $0x8,%eax
  80102f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801032:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80103f:	c1 e0 10             	shl    $0x10,%eax
  801042:	09 45 f0             	or     %eax,-0x10(%ebp)
  801045:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104e:	89 c2                	mov    %eax,%edx
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
  801055:	09 45 f0             	or     %eax,-0x10(%ebp)
  801058:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80105b:	eb 18                	jmp    801075 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80105d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801060:	8d 41 08             	lea    0x8(%ecx),%eax
  801063:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106c:	89 01                	mov    %eax,(%ecx)
  80106e:	89 51 04             	mov    %edx,0x4(%ecx)
  801071:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801075:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801079:	77 e2                	ja     80105d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80107b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107f:	74 23                	je     8010a4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801087:	eb 0e                	jmp    801097 <memset+0x91>
			*p8++ = (uint8)c;
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108c:	8d 50 01             	lea    0x1(%eax),%edx
  80108f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801092:	8b 55 0c             	mov    0xc(%ebp),%edx
  801095:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801097:	8b 45 10             	mov    0x10(%ebp),%eax
  80109a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109d:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	75 e5                	jne    801089 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010bb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010bf:	76 24                	jbe    8010e5 <memcpy+0x3c>
		while(n >= 8){
  8010c1:	eb 1c                	jmp    8010df <memcpy+0x36>
			*d64 = *s64;
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	8b 50 04             	mov    0x4(%eax),%edx
  8010c9:	8b 00                	mov    (%eax),%eax
  8010cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ce:	89 01                	mov    %eax,(%ecx)
  8010d0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010d3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010d7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010db:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010df:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e3:	77 de                	ja     8010c3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e9:	74 31                	je     80111c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010f7:	eb 16                	jmp    80110f <memcpy+0x66>
			*d8++ = *s8++;
  8010f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010fc:	8d 50 01             	lea    0x1(%eax),%edx
  8010ff:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801105:	8d 4a 01             	lea    0x1(%edx),%ecx
  801108:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80110b:	8a 12                	mov    (%edx),%dl
  80110d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	8d 50 ff             	lea    -0x1(%eax),%edx
  801115:	89 55 10             	mov    %edx,0x10(%ebp)
  801118:	85 c0                	test   %eax,%eax
  80111a:	75 dd                	jne    8010f9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801136:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801139:	73 50                	jae    80118b <memmove+0x6a>
  80113b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113e:	8b 45 10             	mov    0x10(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801146:	76 43                	jbe    80118b <memmove+0x6a>
		s += n;
  801148:	8b 45 10             	mov    0x10(%ebp),%eax
  80114b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80114e:	8b 45 10             	mov    0x10(%ebp),%eax
  801151:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801154:	eb 10                	jmp    801166 <memmove+0x45>
			*--d = *--s;
  801156:	ff 4d f8             	decl   -0x8(%ebp)
  801159:	ff 4d fc             	decl   -0x4(%ebp)
  80115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115f:	8a 10                	mov    (%eax),%dl
  801161:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801164:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116c:	89 55 10             	mov    %edx,0x10(%ebp)
  80116f:	85 c0                	test   %eax,%eax
  801171:	75 e3                	jne    801156 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801173:	eb 23                	jmp    801198 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801175:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801178:	8d 50 01             	lea    0x1(%eax),%edx
  80117b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80117e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801181:	8d 4a 01             	lea    0x1(%edx),%ecx
  801184:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801187:	8a 12                	mov    (%edx),%dl
  801189:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801191:	89 55 10             	mov    %edx,0x10(%ebp)
  801194:	85 c0                	test   %eax,%eax
  801196:	75 dd                	jne    801175 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011af:	eb 2a                	jmp    8011db <memcmp+0x3e>
		if (*s1 != *s2)
  8011b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b4:	8a 10                	mov    (%eax),%dl
  8011b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	38 c2                	cmp    %al,%dl
  8011bd:	74 16                	je     8011d5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	0f b6 d0             	movzbl %al,%edx
  8011c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f b6 c0             	movzbl %al,%eax
  8011cf:	29 c2                	sub    %eax,%edx
  8011d1:	89 d0                	mov    %edx,%eax
  8011d3:	eb 18                	jmp    8011ed <memcmp+0x50>
		s1++, s2++;
  8011d5:	ff 45 fc             	incl   -0x4(%ebp)
  8011d8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011db:	8b 45 10             	mov    0x10(%ebp),%eax
  8011de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	75 c9                	jne    8011b1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	01 d0                	add    %edx,%eax
  8011fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801200:	eb 15                	jmp    801217 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	0f b6 d0             	movzbl %al,%edx
  80120a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120d:	0f b6 c0             	movzbl %al,%eax
  801210:	39 c2                	cmp    %eax,%edx
  801212:	74 0d                	je     801221 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80121d:	72 e3                	jb     801202 <memfind+0x13>
  80121f:	eb 01                	jmp    801222 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801221:	90                   	nop
	return (void *) s;
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80122d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801234:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80123b:	eb 03                	jmp    801240 <strtol+0x19>
		s++;
  80123d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	3c 20                	cmp    $0x20,%al
  801247:	74 f4                	je     80123d <strtol+0x16>
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	3c 09                	cmp    $0x9,%al
  801250:	74 eb                	je     80123d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	3c 2b                	cmp    $0x2b,%al
  801259:	75 05                	jne    801260 <strtol+0x39>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
  80125e:	eb 13                	jmp    801273 <strtol+0x4c>
	else if (*s == '-')
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	3c 2d                	cmp    $0x2d,%al
  801267:	75 0a                	jne    801273 <strtol+0x4c>
		s++, neg = 1;
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	74 06                	je     80127f <strtol+0x58>
  801279:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80127d:	75 20                	jne    80129f <strtol+0x78>
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 30                	cmp    $0x30,%al
  801286:	75 17                	jne    80129f <strtol+0x78>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	40                   	inc    %eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 78                	cmp    $0x78,%al
  801290:	75 0d                	jne    80129f <strtol+0x78>
		s += 2, base = 16;
  801292:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801296:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80129d:	eb 28                	jmp    8012c7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80129f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a3:	75 15                	jne    8012ba <strtol+0x93>
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	3c 30                	cmp    $0x30,%al
  8012ac:	75 0c                	jne    8012ba <strtol+0x93>
		s++, base = 8;
  8012ae:	ff 45 08             	incl   0x8(%ebp)
  8012b1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012b8:	eb 0d                	jmp    8012c7 <strtol+0xa0>
	else if (base == 0)
  8012ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012be:	75 07                	jne    8012c7 <strtol+0xa0>
		base = 10;
  8012c0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3c 2f                	cmp    $0x2f,%al
  8012ce:	7e 19                	jle    8012e9 <strtol+0xc2>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 39                	cmp    $0x39,%al
  8012d7:	7f 10                	jg     8012e9 <strtol+0xc2>
			dig = *s - '0';
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	83 e8 30             	sub    $0x30,%eax
  8012e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e7:	eb 42                	jmp    80132b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	3c 60                	cmp    $0x60,%al
  8012f0:	7e 19                	jle    80130b <strtol+0xe4>
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 7a                	cmp    $0x7a,%al
  8012f9:	7f 10                	jg     80130b <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	0f be c0             	movsbl %al,%eax
  801303:	83 e8 57             	sub    $0x57,%eax
  801306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801309:	eb 20                	jmp    80132b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	3c 40                	cmp    $0x40,%al
  801312:	7e 39                	jle    80134d <strtol+0x126>
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	3c 5a                	cmp    $0x5a,%al
  80131b:	7f 30                	jg     80134d <strtol+0x126>
			dig = *s - 'A' + 10;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	0f be c0             	movsbl %al,%eax
  801325:	83 e8 37             	sub    $0x37,%eax
  801328:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80132b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801331:	7d 19                	jge    80134c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801333:	ff 45 08             	incl   0x8(%ebp)
  801336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801339:	0f af 45 10          	imul   0x10(%ebp),%eax
  80133d:	89 c2                	mov    %eax,%edx
  80133f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801342:	01 d0                	add    %edx,%eax
  801344:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801347:	e9 7b ff ff ff       	jmp    8012c7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80134c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80134d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801351:	74 08                	je     80135b <strtol+0x134>
		*endptr = (char *) s;
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8b 55 08             	mov    0x8(%ebp),%edx
  801359:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80135b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80135f:	74 07                	je     801368 <strtol+0x141>
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	f7 d8                	neg    %eax
  801366:	eb 03                	jmp    80136b <strtol+0x144>
  801368:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <ltostr>:

void
ltostr(long value, char *str)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801373:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80137a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801385:	79 13                	jns    80139a <ltostr+0x2d>
	{
		neg = 1;
  801387:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80138e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801391:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801394:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801397:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013a2:	99                   	cltd   
  8013a3:	f7 f9                	idiv   %ecx
  8013a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ab:	8d 50 01             	lea    0x1(%eax),%edx
  8013ae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	01 d0                	add    %edx,%eax
  8013b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013bb:	83 c2 30             	add    $0x30,%edx
  8013be:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013c8:	f7 e9                	imul   %ecx
  8013ca:	c1 fa 02             	sar    $0x2,%edx
  8013cd:	89 c8                	mov    %ecx,%eax
  8013cf:	c1 f8 1f             	sar    $0x1f,%eax
  8013d2:	29 c2                	sub    %eax,%edx
  8013d4:	89 d0                	mov    %edx,%eax
  8013d6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013dd:	75 bb                	jne    80139a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e9:	48                   	dec    %eax
  8013ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013f1:	74 3d                	je     801430 <ltostr+0xc3>
		start = 1 ;
  8013f3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013fa:	eb 34                	jmp    801430 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	01 d0                	add    %edx,%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801409:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	01 c2                	add    %eax,%edx
  801411:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	01 c8                	add    %ecx,%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80141d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	01 c2                	add    %eax,%edx
  801425:	8a 45 eb             	mov    -0x15(%ebp),%al
  801428:	88 02                	mov    %al,(%edx)
		start++ ;
  80142a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80142d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801433:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801436:	7c c4                	jl     8013fc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801438:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801443:	90                   	nop
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80144c:	ff 75 08             	pushl  0x8(%ebp)
  80144f:	e8 c4 f9 ff ff       	call   800e18 <strlen>
  801454:	83 c4 04             	add    $0x4,%esp
  801457:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80145a:	ff 75 0c             	pushl  0xc(%ebp)
  80145d:	e8 b6 f9 ff ff       	call   800e18 <strlen>
  801462:	83 c4 04             	add    $0x4,%esp
  801465:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80146f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801476:	eb 17                	jmp    80148f <strcconcat+0x49>
		final[s] = str1[s] ;
  801478:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147b:	8b 45 10             	mov    0x10(%ebp),%eax
  80147e:	01 c2                	add    %eax,%edx
  801480:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	01 c8                	add    %ecx,%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80148c:	ff 45 fc             	incl   -0x4(%ebp)
  80148f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801492:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801495:	7c e1                	jl     801478 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801497:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80149e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014a5:	eb 1f                	jmp    8014c6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014aa:	8d 50 01             	lea    0x1(%eax),%edx
  8014ad:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b0:	89 c2                	mov    %eax,%edx
  8014b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b5:	01 c2                	add    %eax,%edx
  8014b7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	01 c8                	add    %ecx,%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014c3:	ff 45 f8             	incl   -0x8(%ebp)
  8014c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014cc:	7c d9                	jl     8014a7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d4:	01 d0                	add    %edx,%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
}
  8014d9:	90                   	nop
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014eb:	8b 00                	mov    (%eax),%eax
  8014ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ff:	eb 0c                	jmp    80150d <strsplit+0x31>
			*string++ = 0;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8d 50 01             	lea    0x1(%eax),%edx
  801507:	89 55 08             	mov    %edx,0x8(%ebp)
  80150a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	84 c0                	test   %al,%al
  801514:	74 18                	je     80152e <strsplit+0x52>
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	0f be c0             	movsbl %al,%eax
  80151e:	50                   	push   %eax
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	e8 83 fa ff ff       	call   800faa <strchr>
  801527:	83 c4 08             	add    $0x8,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	75 d3                	jne    801501 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	74 5a                	je     801591 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801537:	8b 45 14             	mov    0x14(%ebp),%eax
  80153a:	8b 00                	mov    (%eax),%eax
  80153c:	83 f8 0f             	cmp    $0xf,%eax
  80153f:	75 07                	jne    801548 <strsplit+0x6c>
		{
			return 0;
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
  801546:	eb 66                	jmp    8015ae <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801548:	8b 45 14             	mov    0x14(%ebp),%eax
  80154b:	8b 00                	mov    (%eax),%eax
  80154d:	8d 48 01             	lea    0x1(%eax),%ecx
  801550:	8b 55 14             	mov    0x14(%ebp),%edx
  801553:	89 0a                	mov    %ecx,(%edx)
  801555:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155c:	8b 45 10             	mov    0x10(%ebp),%eax
  80155f:	01 c2                	add    %eax,%edx
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801566:	eb 03                	jmp    80156b <strsplit+0x8f>
			string++;
  801568:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 8b                	je     8014ff <strsplit+0x23>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	0f be c0             	movsbl %al,%eax
  80157c:	50                   	push   %eax
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	e8 25 fa ff ff       	call   800faa <strchr>
  801585:	83 c4 08             	add    $0x8,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	74 dc                	je     801568 <strsplit+0x8c>
			string++;
	}
  80158c:	e9 6e ff ff ff       	jmp    8014ff <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801591:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801592:	8b 45 14             	mov    0x14(%ebp),%eax
  801595:	8b 00                	mov    (%eax),%eax
  801597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80159e:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a1:	01 d0                	add    %edx,%eax
  8015a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c3:	eb 4a                	jmp    80160f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	01 c2                	add    %eax,%edx
  8015cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	01 c8                	add    %ecx,%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	8a 00                	mov    (%eax),%al
  8015e3:	3c 40                	cmp    $0x40,%al
  8015e5:	7e 25                	jle    80160c <str2lower+0x5c>
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	01 d0                	add    %edx,%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	3c 5a                	cmp    $0x5a,%al
  8015f3:	7f 17                	jg     80160c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	01 d0                	add    %edx,%eax
  8015fd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801600:	8b 55 08             	mov    0x8(%ebp),%edx
  801603:	01 ca                	add    %ecx,%edx
  801605:	8a 12                	mov    (%edx),%dl
  801607:	83 c2 20             	add    $0x20,%edx
  80160a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80160c:	ff 45 fc             	incl   -0x4(%ebp)
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	e8 01 f8 ff ff       	call   800e18 <strlen>
  801617:	83 c4 04             	add    $0x4,%esp
  80161a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80161d:	7f a6                	jg     8015c5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80161f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80162a:	a1 08 50 80 00       	mov    0x805008,%eax
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 42                	je     801675 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	68 00 00 00 82       	push   $0x82000000
  80163b:	68 00 00 00 80       	push   $0x80000000
  801640:	e8 b0 1e 00 00       	call   8034f5 <initialize_dynamic_allocator>
  801645:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801648:	e8 96 1c 00 00       	call   8032e3 <sys_get_uheap_strategy>
  80164d:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801652:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801657:	05 00 10 00 00       	add    $0x1000,%eax
  80165c:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801661:	a1 30 51 83 00       	mov    0x835130,%eax
  801666:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  80166b:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801672:	00 00 00 
	}
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	68 06 04 00 00       	push   $0x406
  801694:	50                   	push   %eax
  801695:	e8 93 18 00 00       	call   802f2d <__sys_allocate_page>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016a4:	79 14                	jns    8016ba <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016a6:	83 ec 04             	sub    $0x4,%esp
  8016a9:	68 28 49 80 00       	push   $0x804928
  8016ae:	6a 1f                	push   $0x1f
  8016b0:	68 64 49 80 00       	push   $0x804964
  8016b5:	e8 b7 ed ff ff       	call   800471 <_panic>
	return 0;
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016d5:	83 ec 0c             	sub    $0xc,%esp
  8016d8:	50                   	push   %eax
  8016d9:	e8 96 18 00 00       	call   802f74 <__sys_unmap_frame>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016e8:	79 14                	jns    8016fe <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016ea:	83 ec 04             	sub    $0x4,%esp
  8016ed:	68 70 49 80 00       	push   $0x804970
  8016f2:	6a 2a                	push   $0x2a
  8016f4:	68 64 49 80 00       	push   $0x804964
  8016f9:	e8 73 ed ff ff       	call   800471 <_panic>
}
  8016fe:	90                   	nop
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801707:	e8 18 ff ff ff       	call   801624 <uheap_init>
	if (size == 0) return NULL ;
  80170c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801710:	75 0a                	jne    80171c <malloc+0x1b>
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	e9 43 03 00 00       	jmp    801a5f <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80171c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801723:	77 13                	ja     801738 <malloc+0x37>
    {
        return alloc_block(size);
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	ff 75 08             	pushl  0x8(%ebp)
  80172b:	e8 78 20 00 00       	call   8037a8 <alloc_block>
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	e9 27 03 00 00       	jmp    801a5f <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801738:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80173f:	8b 55 08             	mov    0x8(%ebp),%edx
  801742:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	48                   	dec    %eax
  801748:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80174b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80174e:	ba 00 00 00 00       	mov    $0x0,%edx
  801753:	f7 75 dc             	divl   -0x24(%ebp)
  801756:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801759:	29 d0                	sub    %edx,%eax
  80175b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80175e:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801763:	85 c0                	test   %eax,%eax
  801765:	75 0a                	jne    801771 <malloc+0x70>
    {
        uhp_inited = 1;
  801767:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  80176e:	00 00 00 
    }

    int exactIdx = -1;
  801771:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801778:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80177f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801786:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80178d:	e9 85 00 00 00       	jmp    801817 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801792:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801795:	89 d0                	mov    %edx,%eax
  801797:	01 c0                	add    %eax,%eax
  801799:	01 d0                	add    %edx,%eax
  80179b:	c1 e0 02             	shl    $0x2,%eax
  80179e:	05 48 10 81 00       	add    $0x811048,%eax
  8017a3:	8a 00                	mov    (%eax),%al
  8017a5:	84 c0                	test   %al,%al
  8017a7:	74 20                	je     8017c9 <malloc+0xc8>
  8017a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ac:	89 d0                	mov    %edx,%eax
  8017ae:	01 c0                	add    %eax,%eax
  8017b0:	01 d0                	add    %edx,%eax
  8017b2:	c1 e0 02             	shl    $0x2,%eax
  8017b5:	05 44 10 81 00       	add    $0x811044,%eax
  8017ba:	8b 00                	mov    (%eax),%eax
  8017bc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017bf:	75 08                	jne    8017c9 <malloc+0xc8>
        {
            exactIdx = i;
  8017c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8017c7:	eb 5b                	jmp    801824 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8017c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017cc:	89 d0                	mov    %edx,%eax
  8017ce:	01 c0                	add    %eax,%eax
  8017d0:	01 d0                	add    %edx,%eax
  8017d2:	c1 e0 02             	shl    $0x2,%eax
  8017d5:	05 48 10 81 00       	add    $0x811048,%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	84 c0                	test   %al,%al
  8017de:	74 34                	je     801814 <malloc+0x113>
  8017e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017e3:	89 d0                	mov    %edx,%eax
  8017e5:	01 c0                	add    %eax,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	c1 e0 02             	shl    $0x2,%eax
  8017ec:	05 44 10 81 00       	add    $0x811044,%eax
  8017f1:	8b 00                	mov    (%eax),%eax
  8017f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8017f6:	76 1c                	jbe    801814 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8017f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017fb:	89 d0                	mov    %edx,%eax
  8017fd:	01 c0                	add    %eax,%eax
  8017ff:	01 d0                	add    %edx,%eax
  801801:	c1 e0 02             	shl    $0x2,%eax
  801804:	05 44 10 81 00       	add    $0x811044,%eax
  801809:	8b 00                	mov    (%eax),%eax
  80180b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80180e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801811:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801814:	ff 45 e8             	incl   -0x18(%ebp)
  801817:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80181e:	0f 8e 6e ff ff ff    	jle    801792 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801824:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80182b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80182f:	74 7d                	je     8018ae <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801831:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183b:	89 d0                	mov    %edx,%eax
  80183d:	01 c0                	add    %eax,%eax
  80183f:	01 d0                	add    %edx,%eax
  801841:	c1 e0 02             	shl    $0x2,%eax
  801844:	05 40 10 81 00       	add    $0x811040,%eax
  801849:	8b 10                	mov    (%eax),%edx
  80184b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80184e:	01 d0                	add    %edx,%eax
  801850:	48                   	dec    %eax
  801851:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801854:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	f7 75 bc             	divl   -0x44(%ebp)
  80185f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801862:	29 d0                	sub    %edx,%eax
  801864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	01 c0                	add    %eax,%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	c1 e0 02             	shl    $0x2,%eax
  801873:	05 48 10 81 00       	add    $0x811048,%eax
  801878:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80187b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187e:	89 d0                	mov    %edx,%eax
  801880:	01 c0                	add    %eax,%eax
  801882:	01 d0                	add    %edx,%eax
  801884:	c1 e0 02             	shl    $0x2,%eax
  801887:	05 44 10 81 00       	add    $0x811044,%eax
  80188c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801895:	89 d0                	mov    %edx,%eax
  801897:	01 c0                	add    %eax,%eax
  801899:	01 d0                	add    %edx,%eax
  80189b:	c1 e0 02             	shl    $0x2,%eax
  80189e:	05 40 10 81 00       	add    $0x811040,%eax
  8018a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018a9:	e9 2d 01 00 00       	jmp    8019db <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8018ae:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018b2:	0f 84 ce 00 00 00    	je     801986 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8018b8:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8018bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c2:	89 d0                	mov    %edx,%eax
  8018c4:	01 c0                	add    %eax,%eax
  8018c6:	01 d0                	add    %edx,%eax
  8018c8:	c1 e0 02             	shl    $0x2,%eax
  8018cb:	05 40 10 81 00       	add    $0x811040,%eax
  8018d0:	8b 10                	mov    (%eax),%edx
  8018d2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018d5:	01 d0                	add    %edx,%eax
  8018d7:	48                   	dec    %eax
  8018d8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8018db:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018de:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e3:	f7 75 c4             	divl   -0x3c(%ebp)
  8018e6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018e9:	29 d0                	sub    %edx,%eax
  8018eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8018ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f1:	89 d0                	mov    %edx,%eax
  8018f3:	01 c0                	add    %eax,%eax
  8018f5:	01 d0                	add    %edx,%eax
  8018f7:	c1 e0 02             	shl    $0x2,%eax
  8018fa:	05 44 10 81 00       	add    $0x811044,%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801904:	75 47                	jne    80194d <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801909:	89 d0                	mov    %edx,%eax
  80190b:	01 c0                	add    %eax,%eax
  80190d:	01 d0                	add    %edx,%eax
  80190f:	c1 e0 02             	shl    $0x2,%eax
  801912:	05 48 10 81 00       	add    $0x811048,%eax
  801917:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80191a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191d:	89 d0                	mov    %edx,%eax
  80191f:	01 c0                	add    %eax,%eax
  801921:	01 d0                	add    %edx,%eax
  801923:	c1 e0 02             	shl    $0x2,%eax
  801926:	05 44 10 81 00       	add    $0x811044,%eax
  80192b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801931:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801934:	89 d0                	mov    %edx,%eax
  801936:	01 c0                	add    %eax,%eax
  801938:	01 d0                	add    %edx,%eax
  80193a:	c1 e0 02             	shl    $0x2,%eax
  80193d:	05 40 10 81 00       	add    $0x811040,%eax
  801942:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801948:	e9 8e 00 00 00       	jmp    8019db <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80194d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801950:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801953:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801956:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801959:	89 d0                	mov    %edx,%eax
  80195b:	01 c0                	add    %eax,%eax
  80195d:	01 d0                	add    %edx,%eax
  80195f:	c1 e0 02             	shl    $0x2,%eax
  801962:	05 40 10 81 00       	add    $0x811040,%eax
  801967:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80196f:	89 c2                	mov    %eax,%edx
  801971:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801974:	89 c8                	mov    %ecx,%eax
  801976:	01 c0                	add    %eax,%eax
  801978:	01 c8                	add    %ecx,%eax
  80197a:	c1 e0 02             	shl    $0x2,%eax
  80197d:	05 44 10 81 00       	add    $0x811044,%eax
  801982:	89 10                	mov    %edx,(%eax)
  801984:	eb 55                	jmp    8019db <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801986:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80198d:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801993:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801996:	01 d0                	add    %edx,%eax
  801998:	48                   	dec    %eax
  801999:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80199c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80199f:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a4:	f7 75 d0             	divl   -0x30(%ebp)
  8019a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019aa:	29 d0                	sub    %edx,%eax
  8019ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8019af:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019bc:	76 0a                	jbe    8019c8 <malloc+0x2c7>
            return NULL;
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c3:	e9 97 00 00 00       	jmp    801a5f <malloc+0x35e>
        va = start;
  8019c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8019ce:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019d4:	01 d0                	add    %edx,%eax
  8019d6:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019e2:	eb 5e                	jmp    801a42 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8019e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019e7:	89 d0                	mov    %edx,%eax
  8019e9:	01 c0                	add    %eax,%eax
  8019eb:	01 d0                	add    %edx,%eax
  8019ed:	c1 e0 02             	shl    $0x2,%eax
  8019f0:	05 48 50 80 00       	add    $0x805048,%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	84 c0                	test   %al,%al
  8019f9:	75 44                	jne    801a3f <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8019fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019fe:	89 d0                	mov    %edx,%eax
  801a00:	01 c0                	add    %eax,%eax
  801a02:	01 d0                	add    %edx,%eax
  801a04:	c1 e0 02             	shl    $0x2,%eax
  801a07:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a10:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a15:	89 d0                	mov    %edx,%eax
  801a17:	01 c0                	add    %eax,%eax
  801a19:	01 d0                	add    %edx,%eax
  801a1b:	c1 e0 02             	shl    $0x2,%eax
  801a1e:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a27:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a2c:	89 d0                	mov    %edx,%eax
  801a2e:	01 c0                	add    %eax,%eax
  801a30:	01 d0                	add    %edx,%eax
  801a32:	c1 e0 02             	shl    $0x2,%eax
  801a35:	05 48 50 80 00       	add    $0x805048,%eax
  801a3a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a3d:	eb 0c                	jmp    801a4b <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a3f:	ff 45 e0             	incl   -0x20(%ebp)
  801a42:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a49:	7e 99                	jle    8019e4 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a4b:	83 ec 08             	sub    $0x8,%esp
  801a4e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a51:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a54:	e8 a2 19 00 00       	call   8033fb <sys_allocate_user_mem>
  801a59:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a6b:	0f 84 fa 03 00 00    	je     801e6b <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	79 1c                	jns    801a9a <free+0x39>
  801a7e:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a85:	77 13                	ja     801a9a <free+0x39>
    {
        free_block(virtual_address);
  801a87:	83 ec 0c             	sub    $0xc,%esp
  801a8a:	ff 75 08             	pushl  0x8(%ebp)
  801a8d:	e8 09 21 00 00       	call   803b9b <free_block>
  801a92:	83 c4 10             	add    $0x10,%esp
        return;
  801a95:	e9 d2 03 00 00       	jmp    801e6c <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801a9a:	a1 30 51 83 00       	mov    0x835130,%eax
  801a9f:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801aa2:	72 09                	jb     801aad <free+0x4c>
  801aa4:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801aab:	76 17                	jbe    801ac4 <free+0x63>
        panic("free: invalid address");
  801aad:	83 ec 04             	sub    $0x4,%esp
  801ab0:	68 ad 49 80 00       	push   $0x8049ad
  801ab5:	68 9b 00 00 00       	push   $0x9b
  801aba:	68 64 49 80 00       	push   $0x804964
  801abf:	e8 ad e9 ff ff       	call   800471 <_panic>

    uint32 size = 0;
  801ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801acb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ad2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801ad9:	eb 50                	jmp    801b2b <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801adb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ade:	89 d0                	mov    %edx,%eax
  801ae0:	01 c0                	add    %eax,%eax
  801ae2:	01 d0                	add    %edx,%eax
  801ae4:	c1 e0 02             	shl    $0x2,%eax
  801ae7:	05 48 50 80 00       	add    $0x805048,%eax
  801aec:	8a 00                	mov    (%eax),%al
  801aee:	84 c0                	test   %al,%al
  801af0:	74 36                	je     801b28 <free+0xc7>
  801af2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801af5:	89 d0                	mov    %edx,%eax
  801af7:	01 c0                	add    %eax,%eax
  801af9:	01 d0                	add    %edx,%eax
  801afb:	c1 e0 02             	shl    $0x2,%eax
  801afe:	05 40 50 80 00       	add    $0x805040,%eax
  801b03:	8b 00                	mov    (%eax),%eax
  801b05:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b08:	75 1e                	jne    801b28 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801b0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b0d:	89 d0                	mov    %edx,%eax
  801b0f:	01 c0                	add    %eax,%eax
  801b11:	01 d0                	add    %edx,%eax
  801b13:	c1 e0 02             	shl    $0x2,%eax
  801b16:	05 44 50 80 00       	add    $0x805044,%eax
  801b1b:	8b 00                	mov    (%eax),%eax
  801b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b26:	eb 0c                	jmp    801b34 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b28:	ff 45 ec             	incl   -0x14(%ebp)
  801b2b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b32:	7e a7                	jle    801adb <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b34:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b38:	74 06                	je     801b40 <free+0xdf>
  801b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b3e:	75 17                	jne    801b57 <free+0xf6>
        panic("free: unknown block");
  801b40:	83 ec 04             	sub    $0x4,%esp
  801b43:	68 c3 49 80 00       	push   $0x8049c3
  801b48:	68 a9 00 00 00       	push   $0xa9
  801b4d:	68 64 49 80 00       	push   $0x804964
  801b52:	e8 1a e9 ff ff       	call   800471 <_panic>

    uhp_allocs[idx].used = 0;
  801b57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b5a:	89 d0                	mov    %edx,%eax
  801b5c:	01 c0                	add    %eax,%eax
  801b5e:	01 d0                	add    %edx,%eax
  801b60:	c1 e0 02             	shl    $0x2,%eax
  801b63:	05 48 50 80 00       	add    $0x805048,%eax
  801b68:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b6b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b72:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b79:	eb 64                	jmp    801bdf <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b7e:	89 d0                	mov    %edx,%eax
  801b80:	01 c0                	add    %eax,%eax
  801b82:	01 d0                	add    %edx,%eax
  801b84:	c1 e0 02             	shl    $0x2,%eax
  801b87:	05 48 10 81 00       	add    $0x811048,%eax
  801b8c:	8a 00                	mov    (%eax),%al
  801b8e:	84 c0                	test   %al,%al
  801b90:	75 4a                	jne    801bdc <free+0x17b>
        {
            uhp_frees[i].va = va;
  801b92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b95:	89 d0                	mov    %edx,%eax
  801b97:	01 c0                	add    %eax,%eax
  801b99:	01 d0                	add    %edx,%eax
  801b9b:	c1 e0 02             	shl    $0x2,%eax
  801b9e:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801ba4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ba7:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801ba9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bac:	89 d0                	mov    %edx,%eax
  801bae:	01 c0                	add    %eax,%eax
  801bb0:	01 d0                	add    %edx,%eax
  801bb2:	c1 e0 02             	shl    $0x2,%eax
  801bb5:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbe:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801bc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bc3:	89 d0                	mov    %edx,%eax
  801bc5:	01 c0                	add    %eax,%eax
  801bc7:	01 d0                	add    %edx,%eax
  801bc9:	c1 e0 02             	shl    $0x2,%eax
  801bcc:	05 48 10 81 00       	add    $0x811048,%eax
  801bd1:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801bda:	eb 0c                	jmp    801be8 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bdc:	ff 45 e4             	incl   -0x1c(%ebp)
  801bdf:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801be6:	7e 93                	jle    801b7b <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801be8:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801bec:	0f 84 f1 01 00 00    	je     801de3 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bf9:	e9 d8 01 00 00       	jmp    801dd6 <free+0x375>
        {
            if (i == fidx) continue;
  801bfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c01:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c04:	0f 84 c8 01 00 00    	je     801dd2 <free+0x371>
            if (uhp_frees[i].free)
  801c0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c0d:	89 d0                	mov    %edx,%eax
  801c0f:	01 c0                	add    %eax,%eax
  801c11:	01 d0                	add    %edx,%eax
  801c13:	c1 e0 02             	shl    $0x2,%eax
  801c16:	05 48 10 81 00       	add    $0x811048,%eax
  801c1b:	8a 00                	mov    (%eax),%al
  801c1d:	84 c0                	test   %al,%al
  801c1f:	0f 84 ae 01 00 00    	je     801dd3 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c28:	89 d0                	mov    %edx,%eax
  801c2a:	01 c0                	add    %eax,%eax
  801c2c:	01 d0                	add    %edx,%eax
  801c2e:	c1 e0 02             	shl    $0x2,%eax
  801c31:	05 40 10 81 00       	add    $0x811040,%eax
  801c36:	8b 08                	mov    (%eax),%ecx
  801c38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c3b:	89 d0                	mov    %edx,%eax
  801c3d:	01 c0                	add    %eax,%eax
  801c3f:	01 d0                	add    %edx,%eax
  801c41:	c1 e0 02             	shl    $0x2,%eax
  801c44:	05 44 10 81 00       	add    $0x811044,%eax
  801c49:	8b 00                	mov    (%eax),%eax
  801c4b:	01 c1                	add    %eax,%ecx
  801c4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c50:	89 d0                	mov    %edx,%eax
  801c52:	01 c0                	add    %eax,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	c1 e0 02             	shl    $0x2,%eax
  801c59:	05 40 10 81 00       	add    $0x811040,%eax
  801c5e:	8b 00                	mov    (%eax),%eax
  801c60:	39 c1                	cmp    %eax,%ecx
  801c62:	0f 85 a8 00 00 00    	jne    801d10 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c6b:	89 d0                	mov    %edx,%eax
  801c6d:	01 c0                	add    %eax,%eax
  801c6f:	01 d0                	add    %edx,%eax
  801c71:	c1 e0 02             	shl    $0x2,%eax
  801c74:	05 40 10 81 00       	add    $0x811040,%eax
  801c79:	8b 10                	mov    (%eax),%edx
  801c7b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c7e:	89 c8                	mov    %ecx,%eax
  801c80:	01 c0                	add    %eax,%eax
  801c82:	01 c8                	add    %ecx,%eax
  801c84:	c1 e0 02             	shl    $0x2,%eax
  801c87:	05 40 10 81 00       	add    $0x811040,%eax
  801c8c:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c91:	89 d0                	mov    %edx,%eax
  801c93:	01 c0                	add    %eax,%eax
  801c95:	01 d0                	add    %edx,%eax
  801c97:	c1 e0 02             	shl    $0x2,%eax
  801c9a:	05 44 10 81 00       	add    $0x811044,%eax
  801c9f:	8b 08                	mov    (%eax),%ecx
  801ca1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ca4:	89 d0                	mov    %edx,%eax
  801ca6:	01 c0                	add    %eax,%eax
  801ca8:	01 d0                	add    %edx,%eax
  801caa:	c1 e0 02             	shl    $0x2,%eax
  801cad:	05 44 10 81 00       	add    $0x811044,%eax
  801cb2:	8b 00                	mov    (%eax),%eax
  801cb4:	01 c1                	add    %eax,%ecx
  801cb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cb9:	89 d0                	mov    %edx,%eax
  801cbb:	01 c0                	add    %eax,%eax
  801cbd:	01 d0                	add    %edx,%eax
  801cbf:	c1 e0 02             	shl    $0x2,%eax
  801cc2:	05 44 10 81 00       	add    $0x811044,%eax
  801cc7:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801cc9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ccc:	89 d0                	mov    %edx,%eax
  801cce:	01 c0                	add    %eax,%eax
  801cd0:	01 d0                	add    %edx,%eax
  801cd2:	c1 e0 02             	shl    $0x2,%eax
  801cd5:	05 48 10 81 00       	add    $0x811048,%eax
  801cda:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801cdd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ce0:	89 d0                	mov    %edx,%eax
  801ce2:	01 c0                	add    %eax,%eax
  801ce4:	01 d0                	add    %edx,%eax
  801ce6:	c1 e0 02             	shl    $0x2,%eax
  801ce9:	05 40 10 81 00       	add    $0x811040,%eax
  801cee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801cf4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf7:	89 d0                	mov    %edx,%eax
  801cf9:	01 c0                	add    %eax,%eax
  801cfb:	01 d0                	add    %edx,%eax
  801cfd:	c1 e0 02             	shl    $0x2,%eax
  801d00:	05 44 10 81 00       	add    $0x811044,%eax
  801d05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d0b:	e9 c3 00 00 00       	jmp    801dd3 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d13:	89 d0                	mov    %edx,%eax
  801d15:	01 c0                	add    %eax,%eax
  801d17:	01 d0                	add    %edx,%eax
  801d19:	c1 e0 02             	shl    $0x2,%eax
  801d1c:	05 40 10 81 00       	add    $0x811040,%eax
  801d21:	8b 08                	mov    (%eax),%ecx
  801d23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d26:	89 d0                	mov    %edx,%eax
  801d28:	01 c0                	add    %eax,%eax
  801d2a:	01 d0                	add    %edx,%eax
  801d2c:	c1 e0 02             	shl    $0x2,%eax
  801d2f:	05 44 10 81 00       	add    $0x811044,%eax
  801d34:	8b 00                	mov    (%eax),%eax
  801d36:	01 c1                	add    %eax,%ecx
  801d38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d3b:	89 d0                	mov    %edx,%eax
  801d3d:	01 c0                	add    %eax,%eax
  801d3f:	01 d0                	add    %edx,%eax
  801d41:	c1 e0 02             	shl    $0x2,%eax
  801d44:	05 40 10 81 00       	add    $0x811040,%eax
  801d49:	8b 00                	mov    (%eax),%eax
  801d4b:	39 c1                	cmp    %eax,%ecx
  801d4d:	0f 85 80 00 00 00    	jne    801dd3 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d56:	89 d0                	mov    %edx,%eax
  801d58:	01 c0                	add    %eax,%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	c1 e0 02             	shl    $0x2,%eax
  801d5f:	05 44 10 81 00       	add    $0x811044,%eax
  801d64:	8b 08                	mov    (%eax),%ecx
  801d66:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d69:	89 d0                	mov    %edx,%eax
  801d6b:	01 c0                	add    %eax,%eax
  801d6d:	01 d0                	add    %edx,%eax
  801d6f:	c1 e0 02             	shl    $0x2,%eax
  801d72:	05 44 10 81 00       	add    $0x811044,%eax
  801d77:	8b 00                	mov    (%eax),%eax
  801d79:	01 c1                	add    %eax,%ecx
  801d7b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d7e:	89 d0                	mov    %edx,%eax
  801d80:	01 c0                	add    %eax,%eax
  801d82:	01 d0                	add    %edx,%eax
  801d84:	c1 e0 02             	shl    $0x2,%eax
  801d87:	05 44 10 81 00       	add    $0x811044,%eax
  801d8c:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d91:	89 d0                	mov    %edx,%eax
  801d93:	01 c0                	add    %eax,%eax
  801d95:	01 d0                	add    %edx,%eax
  801d97:	c1 e0 02             	shl    $0x2,%eax
  801d9a:	05 48 10 81 00       	add    $0x811048,%eax
  801d9f:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801da2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801da5:	89 d0                	mov    %edx,%eax
  801da7:	01 c0                	add    %eax,%eax
  801da9:	01 d0                	add    %edx,%eax
  801dab:	c1 e0 02             	shl    $0x2,%eax
  801dae:	05 40 10 81 00       	add    $0x811040,%eax
  801db3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801db9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dbc:	89 d0                	mov    %edx,%eax
  801dbe:	01 c0                	add    %eax,%eax
  801dc0:	01 d0                	add    %edx,%eax
  801dc2:	c1 e0 02             	shl    $0x2,%eax
  801dc5:	05 44 10 81 00       	add    $0x811044,%eax
  801dca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dd0:	eb 01                	jmp    801dd3 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801dd2:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dd3:	ff 45 e0             	incl   -0x20(%ebp)
  801dd6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801ddd:	0f 8e 1b fe ff ff    	jle    801bfe <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801de3:	a1 30 51 83 00       	mov    0x835130,%eax
  801de8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801deb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801df2:	eb 53                	jmp    801e47 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801df4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801df7:	89 d0                	mov    %edx,%eax
  801df9:	01 c0                	add    %eax,%eax
  801dfb:	01 d0                	add    %edx,%eax
  801dfd:	c1 e0 02             	shl    $0x2,%eax
  801e00:	05 48 50 80 00       	add    $0x805048,%eax
  801e05:	8a 00                	mov    (%eax),%al
  801e07:	84 c0                	test   %al,%al
  801e09:	74 39                	je     801e44 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801e0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	01 c0                	add    %eax,%eax
  801e12:	01 d0                	add    %edx,%eax
  801e14:	c1 e0 02             	shl    $0x2,%eax
  801e17:	05 40 50 80 00       	add    $0x805040,%eax
  801e1c:	8b 08                	mov    (%eax),%ecx
  801e1e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e21:	89 d0                	mov    %edx,%eax
  801e23:	01 c0                	add    %eax,%eax
  801e25:	01 d0                	add    %edx,%eax
  801e27:	c1 e0 02             	shl    $0x2,%eax
  801e2a:	05 44 50 80 00       	add    $0x805044,%eax
  801e2f:	8b 00                	mov    (%eax),%eax
  801e31:	01 c8                	add    %ecx,%eax
  801e33:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e36:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e39:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e3c:	76 06                	jbe    801e44 <free+0x3e3>
  801e3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e41:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e44:	ff 45 d8             	incl   -0x28(%ebp)
  801e47:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e4e:	7e a4                	jle    801df4 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e53:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e58:	83 ec 08             	sub    $0x8,%esp
  801e5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e61:	e8 79 15 00 00       	call   8033df <sys_free_user_mem>
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	eb 01                	jmp    801e6c <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e6b:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 68             	sub    $0x68,%esp
  801e74:	8b 45 10             	mov    0x10(%ebp),%eax
  801e77:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e7a:	e8 a5 f7 ff ff       	call   801624 <uheap_init>
	if (size == 0) return NULL ;
  801e7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e83:	75 0a                	jne    801e8f <smalloc+0x21>
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8a:	e9 37 03 00 00       	jmp    8021c6 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801e8f:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801e96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e9c:	01 d0                	add    %edx,%eax
  801e9e:	48                   	dec    %eax
  801e9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ea2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ea5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eaa:	f7 75 dc             	divl   -0x24(%ebp)
  801ead:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801eb0:	29 d0                	sub    %edx,%eax
  801eb2:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801eb5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ebc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801ec3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801eca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ed1:	e9 85 00 00 00       	jmp    801f5b <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ed6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ed9:	89 d0                	mov    %edx,%eax
  801edb:	01 c0                	add    %eax,%eax
  801edd:	01 d0                	add    %edx,%eax
  801edf:	c1 e0 02             	shl    $0x2,%eax
  801ee2:	05 48 10 81 00       	add    $0x811048,%eax
  801ee7:	8a 00                	mov    (%eax),%al
  801ee9:	84 c0                	test   %al,%al
  801eeb:	74 20                	je     801f0d <smalloc+0x9f>
  801eed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ef0:	89 d0                	mov    %edx,%eax
  801ef2:	01 c0                	add    %eax,%eax
  801ef4:	01 d0                	add    %edx,%eax
  801ef6:	c1 e0 02             	shl    $0x2,%eax
  801ef9:	05 44 10 81 00       	add    $0x811044,%eax
  801efe:	8b 00                	mov    (%eax),%eax
  801f00:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f03:	75 08                	jne    801f0d <smalloc+0x9f>
        {
            exactIdx = i;
  801f05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f0b:	eb 5b                	jmp    801f68 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f10:	89 d0                	mov    %edx,%eax
  801f12:	01 c0                	add    %eax,%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	c1 e0 02             	shl    $0x2,%eax
  801f19:	05 48 10 81 00       	add    $0x811048,%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	84 c0                	test   %al,%al
  801f22:	74 34                	je     801f58 <smalloc+0xea>
  801f24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f27:	89 d0                	mov    %edx,%eax
  801f29:	01 c0                	add    %eax,%eax
  801f2b:	01 d0                	add    %edx,%eax
  801f2d:	c1 e0 02             	shl    $0x2,%eax
  801f30:	05 44 10 81 00       	add    $0x811044,%eax
  801f35:	8b 00                	mov    (%eax),%eax
  801f37:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f3a:	76 1c                	jbe    801f58 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f3f:	89 d0                	mov    %edx,%eax
  801f41:	01 c0                	add    %eax,%eax
  801f43:	01 d0                	add    %edx,%eax
  801f45:	c1 e0 02             	shl    $0x2,%eax
  801f48:	05 44 10 81 00       	add    $0x811044,%eax
  801f4d:	8b 00                	mov    (%eax),%eax
  801f4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f55:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f58:	ff 45 e8             	incl   -0x18(%ebp)
  801f5b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f62:	0f 8e 6e ff ff ff    	jle    801ed6 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f6f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f73:	74 7d                	je     801ff2 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f75:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7f:	89 d0                	mov    %edx,%eax
  801f81:	01 c0                	add    %eax,%eax
  801f83:	01 d0                	add    %edx,%eax
  801f85:	c1 e0 02             	shl    $0x2,%eax
  801f88:	05 40 10 81 00       	add    $0x811040,%eax
  801f8d:	8b 10                	mov    (%eax),%edx
  801f8f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f92:	01 d0                	add    %edx,%eax
  801f94:	48                   	dec    %eax
  801f95:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801f98:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa0:	f7 75 bc             	divl   -0x44(%ebp)
  801fa3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fa6:	29 d0                	sub    %edx,%eax
  801fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fae:	89 d0                	mov    %edx,%eax
  801fb0:	01 c0                	add    %eax,%eax
  801fb2:	01 d0                	add    %edx,%eax
  801fb4:	c1 e0 02             	shl    $0x2,%eax
  801fb7:	05 48 10 81 00       	add    $0x811048,%eax
  801fbc:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc2:	89 d0                	mov    %edx,%eax
  801fc4:	01 c0                	add    %eax,%eax
  801fc6:	01 d0                	add    %edx,%eax
  801fc8:	c1 e0 02             	shl    $0x2,%eax
  801fcb:	05 44 10 81 00       	add    $0x811044,%eax
  801fd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd9:	89 d0                	mov    %edx,%eax
  801fdb:	01 c0                	add    %eax,%eax
  801fdd:	01 d0                	add    %edx,%eax
  801fdf:	c1 e0 02             	shl    $0x2,%eax
  801fe2:	05 40 10 81 00       	add    $0x811040,%eax
  801fe7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fed:	e9 2d 01 00 00       	jmp    80211f <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801ff2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ff6:	0f 84 ce 00 00 00    	je     8020ca <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801ffc:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802003:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802006:	89 d0                	mov    %edx,%eax
  802008:	01 c0                	add    %eax,%eax
  80200a:	01 d0                	add    %edx,%eax
  80200c:	c1 e0 02             	shl    $0x2,%eax
  80200f:	05 40 10 81 00       	add    $0x811040,%eax
  802014:	8b 10                	mov    (%eax),%edx
  802016:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802019:	01 d0                	add    %edx,%eax
  80201b:	48                   	dec    %eax
  80201c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80201f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802022:	ba 00 00 00 00       	mov    $0x0,%edx
  802027:	f7 75 c4             	divl   -0x3c(%ebp)
  80202a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80202d:	29 d0                	sub    %edx,%eax
  80202f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802032:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802035:	89 d0                	mov    %edx,%eax
  802037:	01 c0                	add    %eax,%eax
  802039:	01 d0                	add    %edx,%eax
  80203b:	c1 e0 02             	shl    $0x2,%eax
  80203e:	05 44 10 81 00       	add    $0x811044,%eax
  802043:	8b 00                	mov    (%eax),%eax
  802045:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802048:	75 47                	jne    802091 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80204a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80204d:	89 d0                	mov    %edx,%eax
  80204f:	01 c0                	add    %eax,%eax
  802051:	01 d0                	add    %edx,%eax
  802053:	c1 e0 02             	shl    $0x2,%eax
  802056:	05 48 10 81 00       	add    $0x811048,%eax
  80205b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80205e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802061:	89 d0                	mov    %edx,%eax
  802063:	01 c0                	add    %eax,%eax
  802065:	01 d0                	add    %edx,%eax
  802067:	c1 e0 02             	shl    $0x2,%eax
  80206a:	05 44 10 81 00       	add    $0x811044,%eax
  80206f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802075:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802078:	89 d0                	mov    %edx,%eax
  80207a:	01 c0                	add    %eax,%eax
  80207c:	01 d0                	add    %edx,%eax
  80207e:	c1 e0 02             	shl    $0x2,%eax
  802081:	05 40 10 81 00       	add    $0x811040,%eax
  802086:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80208c:	e9 8e 00 00 00       	jmp    80211f <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802091:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802094:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802097:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80209a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80209d:	89 d0                	mov    %edx,%eax
  80209f:	01 c0                	add    %eax,%eax
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	c1 e0 02             	shl    $0x2,%eax
  8020a6:	05 40 10 81 00       	add    $0x811040,%eax
  8020ab:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b0:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020b3:	89 c2                	mov    %eax,%edx
  8020b5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020b8:	89 c8                	mov    %ecx,%eax
  8020ba:	01 c0                	add    %eax,%eax
  8020bc:	01 c8                	add    %ecx,%eax
  8020be:	c1 e0 02             	shl    $0x2,%eax
  8020c1:	05 44 10 81 00       	add    $0x811044,%eax
  8020c6:	89 10                	mov    %edx,(%eax)
  8020c8:	eb 55                	jmp    80211f <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020ca:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020d1:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8020d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020da:	01 d0                	add    %edx,%eax
  8020dc:	48                   	dec    %eax
  8020dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e8:	f7 75 d0             	divl   -0x30(%ebp)
  8020eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020ee:	29 d0                	sub    %edx,%eax
  8020f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8020f3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020f9:	01 d0                	add    %edx,%eax
  8020fb:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802100:	76 0a                	jbe    80210c <smalloc+0x29e>
            return NULL;
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
  802107:	e9 ba 00 00 00       	jmp    8021c6 <smalloc+0x358>
        va = start;
  80210c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80210f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802112:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802115:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802118:	01 d0                	add    %edx,%eax
  80211a:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80211f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802126:	eb 5e                	jmp    802186 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802128:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80212b:	89 d0                	mov    %edx,%eax
  80212d:	01 c0                	add    %eax,%eax
  80212f:	01 d0                	add    %edx,%eax
  802131:	c1 e0 02             	shl    $0x2,%eax
  802134:	05 48 50 80 00       	add    $0x805048,%eax
  802139:	8a 00                	mov    (%eax),%al
  80213b:	84 c0                	test   %al,%al
  80213d:	75 44                	jne    802183 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80213f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802142:	89 d0                	mov    %edx,%eax
  802144:	01 c0                	add    %eax,%eax
  802146:	01 d0                	add    %edx,%eax
  802148:	c1 e0 02             	shl    $0x2,%eax
  80214b:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802154:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802156:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802159:	89 d0                	mov    %edx,%eax
  80215b:	01 c0                	add    %eax,%eax
  80215d:	01 d0                	add    %edx,%eax
  80215f:	c1 e0 02             	shl    $0x2,%eax
  802162:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802168:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80216b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80216d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802170:	89 d0                	mov    %edx,%eax
  802172:	01 c0                	add    %eax,%eax
  802174:	01 d0                	add    %edx,%eax
  802176:	c1 e0 02             	shl    $0x2,%eax
  802179:	05 48 50 80 00       	add    $0x805048,%eax
  80217e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802181:	eb 0c                	jmp    80218f <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802183:	ff 45 e0             	incl   -0x20(%ebp)
  802186:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80218d:	7e 99                	jle    802128 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80218f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802192:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802196:	52                   	push   %edx
  802197:	50                   	push   %eax
  802198:	ff 75 d4             	pushl  -0x2c(%ebp)
  80219b:	ff 75 08             	pushl  0x8(%ebp)
  80219e:	e8 de 0e 00 00       	call   803081 <sys_create_shared_object>
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8021a9:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8021ad:	75 07                	jne    8021b6 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8021af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021b4:	eb 10                	jmp    8021c6 <smalloc+0x358>
    if (r < 0)
  8021b6:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8021ba:	79 07                	jns    8021c3 <smalloc+0x355>
        return NULL;
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c1:	eb 03                	jmp    8021c6 <smalloc+0x358>
    return (void*)va;
  8021c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021ce:	e8 51 f4 ff ff       	call   801624 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021d3:	83 ec 08             	sub    $0x8,%esp
  8021d6:	ff 75 0c             	pushl  0xc(%ebp)
  8021d9:	ff 75 08             	pushl  0x8(%ebp)
  8021dc:	e8 ca 0e 00 00       	call   8030ab <sys_size_of_shared_object>
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8021e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8021eb:	7f 0a                	jg     8021f7 <sget+0x2f>
        return NULL;
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	e9 28 03 00 00       	jmp    80251f <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8021f7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8021fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802201:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802204:	01 d0                	add    %edx,%eax
  802206:	48                   	dec    %eax
  802207:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80220a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80220d:	ba 00 00 00 00       	mov    $0x0,%edx
  802212:	f7 75 d8             	divl   -0x28(%ebp)
  802215:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802218:	29 d0                	sub    %edx,%eax
  80221a:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80221d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802224:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80222b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802232:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802239:	e9 85 00 00 00       	jmp    8022c3 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80223e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802241:	89 d0                	mov    %edx,%eax
  802243:	01 c0                	add    %eax,%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	c1 e0 02             	shl    $0x2,%eax
  80224a:	05 48 10 81 00       	add    $0x811048,%eax
  80224f:	8a 00                	mov    (%eax),%al
  802251:	84 c0                	test   %al,%al
  802253:	74 20                	je     802275 <sget+0xad>
  802255:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802258:	89 d0                	mov    %edx,%eax
  80225a:	01 c0                	add    %eax,%eax
  80225c:	01 d0                	add    %edx,%eax
  80225e:	c1 e0 02             	shl    $0x2,%eax
  802261:	05 44 10 81 00       	add    $0x811044,%eax
  802266:	8b 00                	mov    (%eax),%eax
  802268:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80226b:	75 08                	jne    802275 <sget+0xad>
        {
            exactIdx = i;
  80226d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802270:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802273:	eb 5b                	jmp    8022d0 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802275:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802278:	89 d0                	mov    %edx,%eax
  80227a:	01 c0                	add    %eax,%eax
  80227c:	01 d0                	add    %edx,%eax
  80227e:	c1 e0 02             	shl    $0x2,%eax
  802281:	05 48 10 81 00       	add    $0x811048,%eax
  802286:	8a 00                	mov    (%eax),%al
  802288:	84 c0                	test   %al,%al
  80228a:	74 34                	je     8022c0 <sget+0xf8>
  80228c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80228f:	89 d0                	mov    %edx,%eax
  802291:	01 c0                	add    %eax,%eax
  802293:	01 d0                	add    %edx,%eax
  802295:	c1 e0 02             	shl    $0x2,%eax
  802298:	05 44 10 81 00       	add    $0x811044,%eax
  80229d:	8b 00                	mov    (%eax),%eax
  80229f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022a2:	76 1c                	jbe    8022c0 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8022a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a7:	89 d0                	mov    %edx,%eax
  8022a9:	01 c0                	add    %eax,%eax
  8022ab:	01 d0                	add    %edx,%eax
  8022ad:	c1 e0 02             	shl    $0x2,%eax
  8022b0:	05 44 10 81 00       	add    $0x811044,%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8022ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022c0:	ff 45 e8             	incl   -0x18(%ebp)
  8022c3:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8022ca:	0f 8e 6e ff ff ff    	jle    80223e <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8022d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8022d7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8022db:	74 7d                	je     80235a <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8022dd:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8022e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e7:	89 d0                	mov    %edx,%eax
  8022e9:	01 c0                	add    %eax,%eax
  8022eb:	01 d0                	add    %edx,%eax
  8022ed:	c1 e0 02             	shl    $0x2,%eax
  8022f0:	05 40 10 81 00       	add    $0x811040,%eax
  8022f5:	8b 10                	mov    (%eax),%edx
  8022f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022fa:	01 d0                	add    %edx,%eax
  8022fc:	48                   	dec    %eax
  8022fd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802300:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802303:	ba 00 00 00 00       	mov    $0x0,%edx
  802308:	f7 75 b8             	divl   -0x48(%ebp)
  80230b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80230e:	29 d0                	sub    %edx,%eax
  802310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802316:	89 d0                	mov    %edx,%eax
  802318:	01 c0                	add    %eax,%eax
  80231a:	01 d0                	add    %edx,%eax
  80231c:	c1 e0 02             	shl    $0x2,%eax
  80231f:	05 48 10 81 00       	add    $0x811048,%eax
  802324:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232a:	89 d0                	mov    %edx,%eax
  80232c:	01 c0                	add    %eax,%eax
  80232e:	01 d0                	add    %edx,%eax
  802330:	c1 e0 02             	shl    $0x2,%eax
  802333:	05 44 10 81 00       	add    $0x811044,%eax
  802338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80233e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802341:	89 d0                	mov    %edx,%eax
  802343:	01 c0                	add    %eax,%eax
  802345:	01 d0                	add    %edx,%eax
  802347:	c1 e0 02             	shl    $0x2,%eax
  80234a:	05 40 10 81 00       	add    $0x811040,%eax
  80234f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802355:	e9 2d 01 00 00       	jmp    802487 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80235a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80235e:	0f 84 ce 00 00 00    	je     802432 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802364:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80236b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80236e:	89 d0                	mov    %edx,%eax
  802370:	01 c0                	add    %eax,%eax
  802372:	01 d0                	add    %edx,%eax
  802374:	c1 e0 02             	shl    $0x2,%eax
  802377:	05 40 10 81 00       	add    $0x811040,%eax
  80237c:	8b 10                	mov    (%eax),%edx
  80237e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802381:	01 d0                	add    %edx,%eax
  802383:	48                   	dec    %eax
  802384:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802387:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80238a:	ba 00 00 00 00       	mov    $0x0,%edx
  80238f:	f7 75 c0             	divl   -0x40(%ebp)
  802392:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802395:	29 d0                	sub    %edx,%eax
  802397:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80239a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239d:	89 d0                	mov    %edx,%eax
  80239f:	01 c0                	add    %eax,%eax
  8023a1:	01 d0                	add    %edx,%eax
  8023a3:	c1 e0 02             	shl    $0x2,%eax
  8023a6:	05 44 10 81 00       	add    $0x811044,%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023b0:	75 47                	jne    8023f9 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8023b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b5:	89 d0                	mov    %edx,%eax
  8023b7:	01 c0                	add    %eax,%eax
  8023b9:	01 d0                	add    %edx,%eax
  8023bb:	c1 e0 02             	shl    $0x2,%eax
  8023be:	05 48 10 81 00       	add    $0x811048,%eax
  8023c3:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8023c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c9:	89 d0                	mov    %edx,%eax
  8023cb:	01 c0                	add    %eax,%eax
  8023cd:	01 d0                	add    %edx,%eax
  8023cf:	c1 e0 02             	shl    $0x2,%eax
  8023d2:	05 44 10 81 00       	add    $0x811044,%eax
  8023d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8023dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e0:	89 d0                	mov    %edx,%eax
  8023e2:	01 c0                	add    %eax,%eax
  8023e4:	01 d0                	add    %edx,%eax
  8023e6:	c1 e0 02             	shl    $0x2,%eax
  8023e9:	05 40 10 81 00       	add    $0x811040,%eax
  8023ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f4:	e9 8e 00 00 00       	jmp    802487 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8023f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023ff:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802405:	89 d0                	mov    %edx,%eax
  802407:	01 c0                	add    %eax,%eax
  802409:	01 d0                	add    %edx,%eax
  80240b:	c1 e0 02             	shl    $0x2,%eax
  80240e:	05 40 10 81 00       	add    $0x811040,%eax
  802413:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802415:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802418:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80241b:	89 c2                	mov    %eax,%edx
  80241d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802420:	89 c8                	mov    %ecx,%eax
  802422:	01 c0                	add    %eax,%eax
  802424:	01 c8                	add    %ecx,%eax
  802426:	c1 e0 02             	shl    $0x2,%eax
  802429:	05 44 10 81 00       	add    $0x811044,%eax
  80242e:	89 10                	mov    %edx,(%eax)
  802430:	eb 55                	jmp    802487 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802432:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802439:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80243f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802442:	01 d0                	add    %edx,%eax
  802444:	48                   	dec    %eax
  802445:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802448:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80244b:	ba 00 00 00 00       	mov    $0x0,%edx
  802450:	f7 75 cc             	divl   -0x34(%ebp)
  802453:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802456:	29 d0                	sub    %edx,%eax
  802458:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80245b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80245e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802461:	01 d0                	add    %edx,%eax
  802463:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802468:	76 0a                	jbe    802474 <sget+0x2ac>
            return NULL;
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
  80246f:	e9 ab 00 00 00       	jmp    80251f <sget+0x357>
        va = start;
  802474:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802477:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80247a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80247d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802480:	01 d0                	add    %edx,%eax
  802482:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802487:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80248e:	eb 5e                	jmp    8024ee <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802490:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802493:	89 d0                	mov    %edx,%eax
  802495:	01 c0                	add    %eax,%eax
  802497:	01 d0                	add    %edx,%eax
  802499:	c1 e0 02             	shl    $0x2,%eax
  80249c:	05 48 50 80 00       	add    $0x805048,%eax
  8024a1:	8a 00                	mov    (%eax),%al
  8024a3:	84 c0                	test   %al,%al
  8024a5:	75 44                	jne    8024eb <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8024a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024aa:	89 d0                	mov    %edx,%eax
  8024ac:	01 c0                	add    %eax,%eax
  8024ae:	01 d0                	add    %edx,%eax
  8024b0:	c1 e0 02             	shl    $0x2,%eax
  8024b3:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8024b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024bc:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8024be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024c1:	89 d0                	mov    %edx,%eax
  8024c3:	01 c0                	add    %eax,%eax
  8024c5:	01 d0                	add    %edx,%eax
  8024c7:	c1 e0 02             	shl    $0x2,%eax
  8024ca:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024d3:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8024d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024d8:	89 d0                	mov    %edx,%eax
  8024da:	01 c0                	add    %eax,%eax
  8024dc:	01 d0                	add    %edx,%eax
  8024de:	c1 e0 02             	shl    $0x2,%eax
  8024e1:	05 48 50 80 00       	add    $0x805048,%eax
  8024e6:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8024e9:	eb 0c                	jmp    8024f7 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024eb:	ff 45 e0             	incl   -0x20(%ebp)
  8024ee:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8024f5:	7e 99                	jle    802490 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8024f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fa:	83 ec 04             	sub    $0x4,%esp
  8024fd:	50                   	push   %eax
  8024fe:	ff 75 0c             	pushl  0xc(%ebp)
  802501:	ff 75 08             	pushl  0x8(%ebp)
  802504:	e8 bf 0b 00 00       	call   8030c8 <sys_get_shared_object>
  802509:	83 c4 10             	add    $0x10,%esp
  80250c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  80250f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802513:	79 07                	jns    80251c <sget+0x354>
        return NULL;
  802515:	b8 00 00 00 00       	mov    $0x0,%eax
  80251a:	eb 03                	jmp    80251f <sget+0x357>
    return (void*)va;
  80251c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
  802524:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802527:	e8 f8 f0 ff ff       	call   801624 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80252c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802530:	75 13                	jne    802545 <realloc+0x24>
		return malloc(new_size);
  802532:	83 ec 0c             	sub    $0xc,%esp
  802535:	ff 75 0c             	pushl  0xc(%ebp)
  802538:	e8 c4 f1 ff ff       	call   801701 <malloc>
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	e9 f4 05 00 00       	jmp    802b39 <realloc+0x618>
	if (new_size == 0)
  802545:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802549:	75 18                	jne    802563 <realloc+0x42>
	{
		free(virtual_address);
  80254b:	83 ec 0c             	sub    $0xc,%esp
  80254e:	ff 75 08             	pushl  0x8(%ebp)
  802551:	e8 0b f5 ff ff       	call   801a61 <free>
  802556:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802559:	b8 00 00 00 00       	mov    $0x0,%eax
  80255e:	e9 d6 05 00 00       	jmp    802b39 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802569:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	79 74                	jns    8025e4 <realloc+0xc3>
  802570:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802577:	77 6b                	ja     8025e4 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802579:	83 ec 0c             	sub    $0xc,%esp
  80257c:	ff 75 0c             	pushl  0xc(%ebp)
  80257f:	e8 7d f1 ff ff       	call   801701 <malloc>
  802584:	83 c4 10             	add    $0x10,%esp
  802587:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80258a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80258e:	75 0a                	jne    80259a <realloc+0x79>
			return NULL;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
  802595:	e9 9f 05 00 00       	jmp    802b39 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80259a:	83 ec 0c             	sub    $0xc,%esp
  80259d:	ff 75 08             	pushl  0x8(%ebp)
  8025a0:	e8 e0 11 00 00       	call   803785 <get_block_size>
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8025ab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b1:	39 d0                	cmp    %edx,%eax
  8025b3:	76 02                	jbe    8025b7 <realloc+0x96>
  8025b5:	89 d0                	mov    %edx,%eax
  8025b7:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8025ba:	83 ec 04             	sub    $0x4,%esp
  8025bd:	ff 75 c0             	pushl  -0x40(%ebp)
  8025c0:	ff 75 08             	pushl  0x8(%ebp)
  8025c3:	ff 75 c8             	pushl  -0x38(%ebp)
  8025c6:	e8 56 eb ff ff       	call   801121 <memmove>
  8025cb:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8025ce:	83 ec 0c             	sub    $0xc,%esp
  8025d1:	ff 75 08             	pushl  0x8(%ebp)
  8025d4:	e8 88 f4 ff ff       	call   801a61 <free>
  8025d9:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8025dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025df:	e9 55 05 00 00       	jmp    802b39 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8025e4:	a1 30 51 83 00       	mov    0x835130,%eax
  8025e9:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8025ec:	72 09                	jb     8025f7 <realloc+0xd6>
  8025ee:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8025f5:	76 0a                	jbe    802601 <realloc+0xe0>
		return NULL;
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fc:	e9 38 05 00 00       	jmp    802b39 <realloc+0x618>
	uint32 oldsz = 0;
  802601:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802608:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80260f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802616:	eb 50                	jmp    802668 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802618:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80261b:	89 d0                	mov    %edx,%eax
  80261d:	01 c0                	add    %eax,%eax
  80261f:	01 d0                	add    %edx,%eax
  802621:	c1 e0 02             	shl    $0x2,%eax
  802624:	05 48 50 80 00       	add    $0x805048,%eax
  802629:	8a 00                	mov    (%eax),%al
  80262b:	84 c0                	test   %al,%al
  80262d:	74 36                	je     802665 <realloc+0x144>
  80262f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802632:	89 d0                	mov    %edx,%eax
  802634:	01 c0                	add    %eax,%eax
  802636:	01 d0                	add    %edx,%eax
  802638:	c1 e0 02             	shl    $0x2,%eax
  80263b:	05 40 50 80 00       	add    $0x805040,%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802645:	75 1e                	jne    802665 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802647:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264a:	89 d0                	mov    %edx,%eax
  80264c:	01 c0                	add    %eax,%eax
  80264e:	01 d0                	add    %edx,%eax
  802650:	c1 e0 02             	shl    $0x2,%eax
  802653:	05 44 50 80 00       	add    $0x805044,%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80265d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802660:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802663:	eb 0c                	jmp    802671 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802665:	ff 45 ec             	incl   -0x14(%ebp)
  802668:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80266f:	7e a7                	jle    802618 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802671:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802675:	75 0a                	jne    802681 <realloc+0x160>
		return NULL;
  802677:	b8 00 00 00 00       	mov    $0x0,%eax
  80267c:	e9 b8 04 00 00       	jmp    802b39 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802681:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80268e:	01 d0                	add    %edx,%eax
  802690:	48                   	dec    %eax
  802691:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802694:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802697:	ba 00 00 00 00       	mov    $0x0,%edx
  80269c:	f7 75 bc             	divl   -0x44(%ebp)
  80269f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026a2:	29 d0                	sub    %edx,%eax
  8026a4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8026a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026ad:	75 08                	jne    8026b7 <realloc+0x196>
		return virtual_address;
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	e9 82 04 00 00       	jmp    802b39 <realloc+0x618>
	if (req < oldsz)
  8026b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026bd:	0f 83 cd 02 00 00    	jae    802990 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8026c9:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8026cc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026d2:	01 d0                	add    %edx,%eax
  8026d4:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8026d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026da:	89 d0                	mov    %edx,%eax
  8026dc:	01 c0                	add    %eax,%eax
  8026de:	01 d0                	add    %edx,%eax
  8026e0:	c1 e0 02             	shl    $0x2,%eax
  8026e3:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8026e9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026ec:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8026ee:	83 ec 08             	sub    $0x8,%esp
  8026f1:	ff 75 b0             	pushl  -0x50(%ebp)
  8026f4:	ff 75 ac             	pushl  -0x54(%ebp)
  8026f7:	e8 e3 0c 00 00       	call   8033df <sys_free_user_mem>
  8026fc:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8026ff:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802706:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80270d:	eb 64                	jmp    802773 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  80270f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802712:	89 d0                	mov    %edx,%eax
  802714:	01 c0                	add    %eax,%eax
  802716:	01 d0                	add    %edx,%eax
  802718:	c1 e0 02             	shl    $0x2,%eax
  80271b:	05 48 10 81 00       	add    $0x811048,%eax
  802720:	8a 00                	mov    (%eax),%al
  802722:	84 c0                	test   %al,%al
  802724:	75 4a                	jne    802770 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802726:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802729:	89 d0                	mov    %edx,%eax
  80272b:	01 c0                	add    %eax,%eax
  80272d:	01 d0                	add    %edx,%eax
  80272f:	c1 e0 02             	shl    $0x2,%eax
  802732:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802738:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80273b:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80273d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802740:	89 d0                	mov    %edx,%eax
  802742:	01 c0                	add    %eax,%eax
  802744:	01 d0                	add    %edx,%eax
  802746:	c1 e0 02             	shl    $0x2,%eax
  802749:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80274f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802752:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802754:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802757:	89 d0                	mov    %edx,%eax
  802759:	01 c0                	add    %eax,%eax
  80275b:	01 d0                	add    %edx,%eax
  80275d:	c1 e0 02             	shl    $0x2,%eax
  802760:	05 48 10 81 00       	add    $0x811048,%eax
  802765:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80276e:	eb 0c                	jmp    80277c <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802770:	ff 45 e4             	incl   -0x1c(%ebp)
  802773:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80277a:	7e 93                	jle    80270f <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80277c:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802780:	0f 84 8d 01 00 00    	je     802913 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802786:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80278d:	e9 74 01 00 00       	jmp    802906 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802792:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802795:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802798:	0f 84 64 01 00 00    	je     802902 <realloc+0x3e1>
				if (uhp_frees[k].free)
  80279e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027a1:	89 d0                	mov    %edx,%eax
  8027a3:	01 c0                	add    %eax,%eax
  8027a5:	01 d0                	add    %edx,%eax
  8027a7:	c1 e0 02             	shl    $0x2,%eax
  8027aa:	05 48 10 81 00       	add    $0x811048,%eax
  8027af:	8a 00                	mov    (%eax),%al
  8027b1:	84 c0                	test   %al,%al
  8027b3:	0f 84 4a 01 00 00    	je     802903 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8027b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027bc:	89 d0                	mov    %edx,%eax
  8027be:	01 c0                	add    %eax,%eax
  8027c0:	01 d0                	add    %edx,%eax
  8027c2:	c1 e0 02             	shl    $0x2,%eax
  8027c5:	05 40 10 81 00       	add    $0x811040,%eax
  8027ca:	8b 08                	mov    (%eax),%ecx
  8027cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027cf:	89 d0                	mov    %edx,%eax
  8027d1:	01 c0                	add    %eax,%eax
  8027d3:	01 d0                	add    %edx,%eax
  8027d5:	c1 e0 02             	shl    $0x2,%eax
  8027d8:	05 44 10 81 00       	add    $0x811044,%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	01 c1                	add    %eax,%ecx
  8027e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027e4:	89 d0                	mov    %edx,%eax
  8027e6:	01 c0                	add    %eax,%eax
  8027e8:	01 d0                	add    %edx,%eax
  8027ea:	c1 e0 02             	shl    $0x2,%eax
  8027ed:	05 40 10 81 00       	add    $0x811040,%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	39 c1                	cmp    %eax,%ecx
  8027f6:	75 7a                	jne    802872 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8027f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027fb:	89 d0                	mov    %edx,%eax
  8027fd:	01 c0                	add    %eax,%eax
  8027ff:	01 d0                	add    %edx,%eax
  802801:	c1 e0 02             	shl    $0x2,%eax
  802804:	05 40 10 81 00       	add    $0x811040,%eax
  802809:	8b 10                	mov    (%eax),%edx
  80280b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80280e:	89 c8                	mov    %ecx,%eax
  802810:	01 c0                	add    %eax,%eax
  802812:	01 c8                	add    %ecx,%eax
  802814:	c1 e0 02             	shl    $0x2,%eax
  802817:	05 40 10 81 00       	add    $0x811040,%eax
  80281c:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80281e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802821:	89 d0                	mov    %edx,%eax
  802823:	01 c0                	add    %eax,%eax
  802825:	01 d0                	add    %edx,%eax
  802827:	c1 e0 02             	shl    $0x2,%eax
  80282a:	05 44 10 81 00       	add    $0x811044,%eax
  80282f:	8b 08                	mov    (%eax),%ecx
  802831:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802834:	89 d0                	mov    %edx,%eax
  802836:	01 c0                	add    %eax,%eax
  802838:	01 d0                	add    %edx,%eax
  80283a:	c1 e0 02             	shl    $0x2,%eax
  80283d:	05 44 10 81 00       	add    $0x811044,%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	01 c1                	add    %eax,%ecx
  802846:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802849:	89 d0                	mov    %edx,%eax
  80284b:	01 c0                	add    %eax,%eax
  80284d:	01 d0                	add    %edx,%eax
  80284f:	c1 e0 02             	shl    $0x2,%eax
  802852:	05 44 10 81 00       	add    $0x811044,%eax
  802857:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802859:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80285c:	89 d0                	mov    %edx,%eax
  80285e:	01 c0                	add    %eax,%eax
  802860:	01 d0                	add    %edx,%eax
  802862:	c1 e0 02             	shl    $0x2,%eax
  802865:	05 48 10 81 00       	add    $0x811048,%eax
  80286a:	c6 00 00             	movb   $0x0,(%eax)
  80286d:	e9 91 00 00 00       	jmp    802903 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802872:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802875:	89 d0                	mov    %edx,%eax
  802877:	01 c0                	add    %eax,%eax
  802879:	01 d0                	add    %edx,%eax
  80287b:	c1 e0 02             	shl    $0x2,%eax
  80287e:	05 40 10 81 00       	add    $0x811040,%eax
  802883:	8b 08                	mov    (%eax),%ecx
  802885:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802888:	89 d0                	mov    %edx,%eax
  80288a:	01 c0                	add    %eax,%eax
  80288c:	01 d0                	add    %edx,%eax
  80288e:	c1 e0 02             	shl    $0x2,%eax
  802891:	05 44 10 81 00       	add    $0x811044,%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	01 c1                	add    %eax,%ecx
  80289a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80289d:	89 d0                	mov    %edx,%eax
  80289f:	01 c0                	add    %eax,%eax
  8028a1:	01 d0                	add    %edx,%eax
  8028a3:	c1 e0 02             	shl    $0x2,%eax
  8028a6:	05 40 10 81 00       	add    $0x811040,%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	39 c1                	cmp    %eax,%ecx
  8028af:	75 52                	jne    802903 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8028b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028b4:	89 d0                	mov    %edx,%eax
  8028b6:	01 c0                	add    %eax,%eax
  8028b8:	01 d0                	add    %edx,%eax
  8028ba:	c1 e0 02             	shl    $0x2,%eax
  8028bd:	05 44 10 81 00       	add    $0x811044,%eax
  8028c2:	8b 08                	mov    (%eax),%ecx
  8028c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028c7:	89 d0                	mov    %edx,%eax
  8028c9:	01 c0                	add    %eax,%eax
  8028cb:	01 d0                	add    %edx,%eax
  8028cd:	c1 e0 02             	shl    $0x2,%eax
  8028d0:	05 44 10 81 00       	add    $0x811044,%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	01 c1                	add    %eax,%ecx
  8028d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028dc:	89 d0                	mov    %edx,%eax
  8028de:	01 c0                	add    %eax,%eax
  8028e0:	01 d0                	add    %edx,%eax
  8028e2:	c1 e0 02             	shl    $0x2,%eax
  8028e5:	05 44 10 81 00       	add    $0x811044,%eax
  8028ea:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8028ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028ef:	89 d0                	mov    %edx,%eax
  8028f1:	01 c0                	add    %eax,%eax
  8028f3:	01 d0                	add    %edx,%eax
  8028f5:	c1 e0 02             	shl    $0x2,%eax
  8028f8:	05 48 10 81 00       	add    $0x811048,%eax
  8028fd:	c6 00 00             	movb   $0x0,(%eax)
  802900:	eb 01                	jmp    802903 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802902:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802903:	ff 45 e0             	incl   -0x20(%ebp)
  802906:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80290d:	0f 8e 7f fe ff ff    	jle    802792 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802913:	a1 30 51 83 00       	mov    0x835130,%eax
  802918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80291b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802922:	eb 53                	jmp    802977 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802924:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802927:	89 d0                	mov    %edx,%eax
  802929:	01 c0                	add    %eax,%eax
  80292b:	01 d0                	add    %edx,%eax
  80292d:	c1 e0 02             	shl    $0x2,%eax
  802930:	05 48 50 80 00       	add    $0x805048,%eax
  802935:	8a 00                	mov    (%eax),%al
  802937:	84 c0                	test   %al,%al
  802939:	74 39                	je     802974 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80293b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80293e:	89 d0                	mov    %edx,%eax
  802940:	01 c0                	add    %eax,%eax
  802942:	01 d0                	add    %edx,%eax
  802944:	c1 e0 02             	shl    $0x2,%eax
  802947:	05 40 50 80 00       	add    $0x805040,%eax
  80294c:	8b 08                	mov    (%eax),%ecx
  80294e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802951:	89 d0                	mov    %edx,%eax
  802953:	01 c0                	add    %eax,%eax
  802955:	01 d0                	add    %edx,%eax
  802957:	c1 e0 02             	shl    $0x2,%eax
  80295a:	05 44 50 80 00       	add    $0x805044,%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	01 c8                	add    %ecx,%eax
  802963:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802966:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802969:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80296c:	76 06                	jbe    802974 <realloc+0x453>
  80296e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802971:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802974:	ff 45 d8             	incl   -0x28(%ebp)
  802977:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80297e:	7e a4                	jle    802924 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802980:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802983:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	e9 a9 01 00 00       	jmp    802b39 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802990:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	01 d0                	add    %edx,%eax
  802998:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  80299b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029a2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8029a9:	eb 57                	jmp    802a02 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8029ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029ae:	89 d0                	mov    %edx,%eax
  8029b0:	01 c0                	add    %eax,%eax
  8029b2:	01 d0                	add    %edx,%eax
  8029b4:	c1 e0 02             	shl    $0x2,%eax
  8029b7:	05 48 10 81 00       	add    $0x811048,%eax
  8029bc:	8a 00                	mov    (%eax),%al
  8029be:	84 c0                	test   %al,%al
  8029c0:	74 3d                	je     8029ff <realloc+0x4de>
  8029c2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029c5:	89 d0                	mov    %edx,%eax
  8029c7:	01 c0                	add    %eax,%eax
  8029c9:	01 d0                	add    %edx,%eax
  8029cb:	c1 e0 02             	shl    $0x2,%eax
  8029ce:	05 40 10 81 00       	add    $0x811040,%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029d8:	75 25                	jne    8029ff <realloc+0x4de>
  8029da:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029dd:	89 d0                	mov    %edx,%eax
  8029df:	01 c0                	add    %eax,%eax
  8029e1:	01 d0                	add    %edx,%eax
  8029e3:	c1 e0 02             	shl    $0x2,%eax
  8029e6:	05 44 10 81 00       	add    $0x811044,%eax
  8029eb:	8b 10                	mov    (%eax),%edx
  8029ed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029f0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029f3:	39 c2                	cmp    %eax,%edx
  8029f5:	72 08                	jb     8029ff <realloc+0x4de>
		{
			adjIdx = j; break;
  8029f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029fd:	eb 0c                	jmp    802a0b <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029ff:	ff 45 d0             	incl   -0x30(%ebp)
  802a02:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802a09:	7e a0                	jle    8029ab <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802a0b:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802a0f:	0f 84 d6 00 00 00    	je     802aeb <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a15:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a18:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a1b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a1e:	83 ec 08             	sub    $0x8,%esp
  802a21:	ff 75 a0             	pushl  -0x60(%ebp)
  802a24:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a27:	e8 cf 09 00 00       	call   8033fb <sys_allocate_user_mem>
  802a2c:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a32:	89 d0                	mov    %edx,%eax
  802a34:	01 c0                	add    %eax,%eax
  802a36:	01 d0                	add    %edx,%eax
  802a38:	c1 e0 02             	shl    $0x2,%eax
  802a3b:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a41:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a44:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a49:	89 d0                	mov    %edx,%eax
  802a4b:	01 c0                	add    %eax,%eax
  802a4d:	01 d0                	add    %edx,%eax
  802a4f:	c1 e0 02             	shl    $0x2,%eax
  802a52:	05 40 10 81 00       	add    $0x811040,%eax
  802a57:	8b 10                	mov    (%eax),%edx
  802a59:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a5c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a5f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a62:	89 d0                	mov    %edx,%eax
  802a64:	01 c0                	add    %eax,%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	c1 e0 02             	shl    $0x2,%eax
  802a6b:	05 40 10 81 00       	add    $0x811040,%eax
  802a70:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a72:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a75:	89 d0                	mov    %edx,%eax
  802a77:	01 c0                	add    %eax,%eax
  802a79:	01 d0                	add    %edx,%eax
  802a7b:	c1 e0 02             	shl    $0x2,%eax
  802a7e:	05 44 10 81 00       	add    $0x811044,%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a88:	89 c2                	mov    %eax,%edx
  802a8a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802a8d:	89 c8                	mov    %ecx,%eax
  802a8f:	01 c0                	add    %eax,%eax
  802a91:	01 c8                	add    %ecx,%eax
  802a93:	c1 e0 02             	shl    $0x2,%eax
  802a96:	05 44 10 81 00       	add    $0x811044,%eax
  802a9b:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802a9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802aa0:	89 d0                	mov    %edx,%eax
  802aa2:	01 c0                	add    %eax,%eax
  802aa4:	01 d0                	add    %edx,%eax
  802aa6:	c1 e0 02             	shl    $0x2,%eax
  802aa9:	05 44 10 81 00       	add    $0x811044,%eax
  802aae:	8b 00                	mov    (%eax),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	75 14                	jne    802ac8 <realloc+0x5a7>
  802ab4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ab7:	89 d0                	mov    %edx,%eax
  802ab9:	01 c0                	add    %eax,%eax
  802abb:	01 d0                	add    %edx,%eax
  802abd:	c1 e0 02             	shl    $0x2,%eax
  802ac0:	05 48 10 81 00       	add    $0x811048,%eax
  802ac5:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802ac8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802acb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ace:	01 c2                	add    %eax,%edx
  802ad0:	a1 88 50 83 00       	mov    0x835088,%eax
  802ad5:	39 c2                	cmp    %eax,%edx
  802ad7:	76 0d                	jbe    802ae6 <realloc+0x5c5>
  802ad9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802adc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802adf:	01 d0                	add    %edx,%eax
  802ae1:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	eb 4e                	jmp    802b39 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802aeb:	83 ec 0c             	sub    $0xc,%esp
  802aee:	ff 75 0c             	pushl  0xc(%ebp)
  802af1:	e8 0b ec ff ff       	call   801701 <malloc>
  802af6:	83 c4 10             	add    $0x10,%esp
  802af9:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802afc:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802b00:	75 07                	jne    802b09 <realloc+0x5e8>
		return NULL;
  802b02:	b8 00 00 00 00       	mov    $0x0,%eax
  802b07:	eb 30                	jmp    802b39 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802b09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b0f:	39 d0                	cmp    %edx,%eax
  802b11:	76 02                	jbe    802b15 <realloc+0x5f4>
  802b13:	89 d0                	mov    %edx,%eax
  802b15:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b18:	83 ec 04             	sub    $0x4,%esp
  802b1b:	50                   	push   %eax
  802b1c:	52                   	push   %edx
  802b1d:	ff 75 cc             	pushl  -0x34(%ebp)
  802b20:	e8 cf 06 00 00       	call   8031f4 <sys_move_user_mem>
  802b25:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b28:	83 ec 0c             	sub    $0xc,%esp
  802b2b:	ff 75 08             	pushl  0x8(%ebp)
  802b2e:	e8 2e ef ff ff       	call   801a61 <free>
  802b33:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b36:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b47:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b4b:	0f 84 33 03 00 00    	je     802e84 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b54:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b59:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b5c:	83 ec 08             	sub    $0x8,%esp
  802b5f:	ff 75 08             	pushl  0x8(%ebp)
  802b62:	ff 75 d8             	pushl  -0x28(%ebp)
  802b65:	e8 7d 05 00 00       	call   8030e7 <sys_delete_shared_object>
  802b6a:	83 c4 10             	add    $0x10,%esp
  802b6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b70:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b74:	0f 88 0d 03 00 00    	js     802e87 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b81:	e9 ef 02 00 00       	jmp    802e75 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b89:	89 d0                	mov    %edx,%eax
  802b8b:	01 c0                	add    %eax,%eax
  802b8d:	01 d0                	add    %edx,%eax
  802b8f:	c1 e0 02             	shl    $0x2,%eax
  802b92:	05 48 50 80 00       	add    $0x805048,%eax
  802b97:	8a 00                	mov    (%eax),%al
  802b99:	84 c0                	test   %al,%al
  802b9b:	0f 84 d1 02 00 00    	je     802e72 <sfree+0x337>
  802ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba4:	89 d0                	mov    %edx,%eax
  802ba6:	01 c0                	add    %eax,%eax
  802ba8:	01 d0                	add    %edx,%eax
  802baa:	c1 e0 02             	shl    $0x2,%eax
  802bad:	05 40 50 80 00       	add    $0x805040,%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bb7:	0f 85 b5 02 00 00    	jne    802e72 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc0:	89 d0                	mov    %edx,%eax
  802bc2:	01 c0                	add    %eax,%eax
  802bc4:	01 d0                	add    %edx,%eax
  802bc6:	c1 e0 02             	shl    $0x2,%eax
  802bc9:	05 44 50 80 00       	add    $0x805044,%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd6:	89 d0                	mov    %edx,%eax
  802bd8:	01 c0                	add    %eax,%eax
  802bda:	01 d0                	add    %edx,%eax
  802bdc:	c1 e0 02             	shl    $0x2,%eax
  802bdf:	05 48 50 80 00       	add    $0x805048,%eax
  802be4:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802be7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802bf5:	eb 64                	jmp    802c5b <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802bf7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bfa:	89 d0                	mov    %edx,%eax
  802bfc:	01 c0                	add    %eax,%eax
  802bfe:	01 d0                	add    %edx,%eax
  802c00:	c1 e0 02             	shl    $0x2,%eax
  802c03:	05 48 10 81 00       	add    $0x811048,%eax
  802c08:	8a 00                	mov    (%eax),%al
  802c0a:	84 c0                	test   %al,%al
  802c0c:	75 4a                	jne    802c58 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802c0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c11:	89 d0                	mov    %edx,%eax
  802c13:	01 c0                	add    %eax,%eax
  802c15:	01 d0                	add    %edx,%eax
  802c17:	c1 e0 02             	shl    $0x2,%eax
  802c1a:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c23:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c28:	89 d0                	mov    %edx,%eax
  802c2a:	01 c0                	add    %eax,%eax
  802c2c:	01 d0                	add    %edx,%eax
  802c2e:	c1 e0 02             	shl    $0x2,%eax
  802c31:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c37:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c3a:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3f:	89 d0                	mov    %edx,%eax
  802c41:	01 c0                	add    %eax,%eax
  802c43:	01 d0                	add    %edx,%eax
  802c45:	c1 e0 02             	shl    $0x2,%eax
  802c48:	05 48 10 81 00       	add    $0x811048,%eax
  802c4d:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c56:	eb 0c                	jmp    802c64 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c58:	ff 45 ec             	incl   -0x14(%ebp)
  802c5b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c62:	7e 93                	jle    802bf7 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c64:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c68:	0f 84 8d 01 00 00    	je     802dfb <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c6e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c75:	e9 74 01 00 00       	jmp    802dee <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c80:	0f 84 64 01 00 00    	je     802dea <sfree+0x2af>
					if (uhp_frees[k].free)
  802c86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c89:	89 d0                	mov    %edx,%eax
  802c8b:	01 c0                	add    %eax,%eax
  802c8d:	01 d0                	add    %edx,%eax
  802c8f:	c1 e0 02             	shl    $0x2,%eax
  802c92:	05 48 10 81 00       	add    $0x811048,%eax
  802c97:	8a 00                	mov    (%eax),%al
  802c99:	84 c0                	test   %al,%al
  802c9b:	0f 84 4a 01 00 00    	je     802deb <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802ca1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca4:	89 d0                	mov    %edx,%eax
  802ca6:	01 c0                	add    %eax,%eax
  802ca8:	01 d0                	add    %edx,%eax
  802caa:	c1 e0 02             	shl    $0x2,%eax
  802cad:	05 40 10 81 00       	add    $0x811040,%eax
  802cb2:	8b 08                	mov    (%eax),%ecx
  802cb4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cb7:	89 d0                	mov    %edx,%eax
  802cb9:	01 c0                	add    %eax,%eax
  802cbb:	01 d0                	add    %edx,%eax
  802cbd:	c1 e0 02             	shl    $0x2,%eax
  802cc0:	05 44 10 81 00       	add    $0x811044,%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	01 c1                	add    %eax,%ecx
  802cc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ccc:	89 d0                	mov    %edx,%eax
  802cce:	01 c0                	add    %eax,%eax
  802cd0:	01 d0                	add    %edx,%eax
  802cd2:	c1 e0 02             	shl    $0x2,%eax
  802cd5:	05 40 10 81 00       	add    $0x811040,%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	39 c1                	cmp    %eax,%ecx
  802cde:	75 7a                	jne    802d5a <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802ce0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ce3:	89 d0                	mov    %edx,%eax
  802ce5:	01 c0                	add    %eax,%eax
  802ce7:	01 d0                	add    %edx,%eax
  802ce9:	c1 e0 02             	shl    $0x2,%eax
  802cec:	05 40 10 81 00       	add    $0x811040,%eax
  802cf1:	8b 10                	mov    (%eax),%edx
  802cf3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802cf6:	89 c8                	mov    %ecx,%eax
  802cf8:	01 c0                	add    %eax,%eax
  802cfa:	01 c8                	add    %ecx,%eax
  802cfc:	c1 e0 02             	shl    $0x2,%eax
  802cff:	05 40 10 81 00       	add    $0x811040,%eax
  802d04:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d09:	89 d0                	mov    %edx,%eax
  802d0b:	01 c0                	add    %eax,%eax
  802d0d:	01 d0                	add    %edx,%eax
  802d0f:	c1 e0 02             	shl    $0x2,%eax
  802d12:	05 44 10 81 00       	add    $0x811044,%eax
  802d17:	8b 08                	mov    (%eax),%ecx
  802d19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d1c:	89 d0                	mov    %edx,%eax
  802d1e:	01 c0                	add    %eax,%eax
  802d20:	01 d0                	add    %edx,%eax
  802d22:	c1 e0 02             	shl    $0x2,%eax
  802d25:	05 44 10 81 00       	add    $0x811044,%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	01 c1                	add    %eax,%ecx
  802d2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d31:	89 d0                	mov    %edx,%eax
  802d33:	01 c0                	add    %eax,%eax
  802d35:	01 d0                	add    %edx,%eax
  802d37:	c1 e0 02             	shl    $0x2,%eax
  802d3a:	05 44 10 81 00       	add    $0x811044,%eax
  802d3f:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d41:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d44:	89 d0                	mov    %edx,%eax
  802d46:	01 c0                	add    %eax,%eax
  802d48:	01 d0                	add    %edx,%eax
  802d4a:	c1 e0 02             	shl    $0x2,%eax
  802d4d:	05 48 10 81 00       	add    $0x811048,%eax
  802d52:	c6 00 00             	movb   $0x0,(%eax)
  802d55:	e9 91 00 00 00       	jmp    802deb <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5d:	89 d0                	mov    %edx,%eax
  802d5f:	01 c0                	add    %eax,%eax
  802d61:	01 d0                	add    %edx,%eax
  802d63:	c1 e0 02             	shl    $0x2,%eax
  802d66:	05 40 10 81 00       	add    $0x811040,%eax
  802d6b:	8b 08                	mov    (%eax),%ecx
  802d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d70:	89 d0                	mov    %edx,%eax
  802d72:	01 c0                	add    %eax,%eax
  802d74:	01 d0                	add    %edx,%eax
  802d76:	c1 e0 02             	shl    $0x2,%eax
  802d79:	05 44 10 81 00       	add    $0x811044,%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	01 c1                	add    %eax,%ecx
  802d82:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d85:	89 d0                	mov    %edx,%eax
  802d87:	01 c0                	add    %eax,%eax
  802d89:	01 d0                	add    %edx,%eax
  802d8b:	c1 e0 02             	shl    $0x2,%eax
  802d8e:	05 40 10 81 00       	add    $0x811040,%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	39 c1                	cmp    %eax,%ecx
  802d97:	75 52                	jne    802deb <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d9c:	89 d0                	mov    %edx,%eax
  802d9e:	01 c0                	add    %eax,%eax
  802da0:	01 d0                	add    %edx,%eax
  802da2:	c1 e0 02             	shl    $0x2,%eax
  802da5:	05 44 10 81 00       	add    $0x811044,%eax
  802daa:	8b 08                	mov    (%eax),%ecx
  802dac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802daf:	89 d0                	mov    %edx,%eax
  802db1:	01 c0                	add    %eax,%eax
  802db3:	01 d0                	add    %edx,%eax
  802db5:	c1 e0 02             	shl    $0x2,%eax
  802db8:	05 44 10 81 00       	add    $0x811044,%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	01 c1                	add    %eax,%ecx
  802dc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc4:	89 d0                	mov    %edx,%eax
  802dc6:	01 c0                	add    %eax,%eax
  802dc8:	01 d0                	add    %edx,%eax
  802dca:	c1 e0 02             	shl    $0x2,%eax
  802dcd:	05 44 10 81 00       	add    $0x811044,%eax
  802dd2:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802dd4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd7:	89 d0                	mov    %edx,%eax
  802dd9:	01 c0                	add    %eax,%eax
  802ddb:	01 d0                	add    %edx,%eax
  802ddd:	c1 e0 02             	shl    $0x2,%eax
  802de0:	05 48 10 81 00       	add    $0x811048,%eax
  802de5:	c6 00 00             	movb   $0x0,(%eax)
  802de8:	eb 01                	jmp    802deb <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802dea:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802deb:	ff 45 e8             	incl   -0x18(%ebp)
  802dee:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802df5:	0f 8e 7f fe ff ff    	jle    802c7a <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802dfb:	a1 30 51 83 00       	mov    0x835130,%eax
  802e00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e0a:	eb 53                	jmp    802e5f <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802e0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e0f:	89 d0                	mov    %edx,%eax
  802e11:	01 c0                	add    %eax,%eax
  802e13:	01 d0                	add    %edx,%eax
  802e15:	c1 e0 02             	shl    $0x2,%eax
  802e18:	05 48 50 80 00       	add    $0x805048,%eax
  802e1d:	8a 00                	mov    (%eax),%al
  802e1f:	84 c0                	test   %al,%al
  802e21:	74 39                	je     802e5c <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e26:	89 d0                	mov    %edx,%eax
  802e28:	01 c0                	add    %eax,%eax
  802e2a:	01 d0                	add    %edx,%eax
  802e2c:	c1 e0 02             	shl    $0x2,%eax
  802e2f:	05 40 50 80 00       	add    $0x805040,%eax
  802e34:	8b 08                	mov    (%eax),%ecx
  802e36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e39:	89 d0                	mov    %edx,%eax
  802e3b:	01 c0                	add    %eax,%eax
  802e3d:	01 d0                	add    %edx,%eax
  802e3f:	c1 e0 02             	shl    $0x2,%eax
  802e42:	05 44 50 80 00       	add    $0x805044,%eax
  802e47:	8b 00                	mov    (%eax),%eax
  802e49:	01 c8                	add    %ecx,%eax
  802e4b:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e51:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e54:	76 06                	jbe    802e5c <sfree+0x321>
  802e56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e5c:	ff 45 e0             	incl   -0x20(%ebp)
  802e5f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e66:	7e a4                	jle    802e0c <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6b:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e70:	eb 16                	jmp    802e88 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e72:	ff 45 f4             	incl   -0xc(%ebp)
  802e75:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e7c:	0f 8e 04 fd ff ff    	jle    802b86 <sfree+0x4b>
  802e82:	eb 04                	jmp    802e88 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e84:	90                   	nop
  802e85:	eb 01                	jmp    802e88 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e87:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e88:	c9                   	leave  
  802e89:	c3                   	ret    

00802e8a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e8a:	55                   	push   %ebp
  802e8b:	89 e5                	mov    %esp,%ebp
  802e8d:	57                   	push   %edi
  802e8e:	56                   	push   %esi
  802e8f:	53                   	push   %ebx
  802e90:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e9f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ea2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ea5:	cd 30                	int    $0x30
  802ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ead:	83 c4 10             	add    $0x10,%esp
  802eb0:	5b                   	pop    %ebx
  802eb1:	5e                   	pop    %esi
  802eb2:	5f                   	pop    %edi
  802eb3:	5d                   	pop    %ebp
  802eb4:	c3                   	ret    

00802eb5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802eb5:	55                   	push   %ebp
  802eb6:	89 e5                	mov    %esp,%ebp
  802eb8:	83 ec 04             	sub    $0x4,%esp
  802ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  802ebe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ec1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ec4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	6a 00                	push   $0x0
  802ecd:	51                   	push   %ecx
  802ece:	52                   	push   %edx
  802ecf:	ff 75 0c             	pushl  0xc(%ebp)
  802ed2:	50                   	push   %eax
  802ed3:	6a 00                	push   $0x0
  802ed5:	e8 b0 ff ff ff       	call   802e8a <syscall>
  802eda:	83 c4 18             	add    $0x18,%esp
}
  802edd:	90                   	nop
  802ede:	c9                   	leave  
  802edf:	c3                   	ret    

00802ee0 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ee0:	55                   	push   %ebp
  802ee1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 02                	push   $0x2
  802eef:	e8 96 ff ff ff       	call   802e8a <syscall>
  802ef4:	83 c4 18             	add    $0x18,%esp
}
  802ef7:	c9                   	leave  
  802ef8:	c3                   	ret    

00802ef9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802ef9:	55                   	push   %ebp
  802efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802efc:	6a 00                	push   $0x0
  802efe:	6a 00                	push   $0x0
  802f00:	6a 00                	push   $0x0
  802f02:	6a 00                	push   $0x0
  802f04:	6a 00                	push   $0x0
  802f06:	6a 03                	push   $0x3
  802f08:	e8 7d ff ff ff       	call   802e8a <syscall>
  802f0d:	83 c4 18             	add    $0x18,%esp
}
  802f10:	90                   	nop
  802f11:	c9                   	leave  
  802f12:	c3                   	ret    

00802f13 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f13:	55                   	push   %ebp
  802f14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 00                	push   $0x0
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 04                	push   $0x4
  802f22:	e8 63 ff ff ff       	call   802e8a <syscall>
  802f27:	83 c4 18             	add    $0x18,%esp
}
  802f2a:	90                   	nop
  802f2b:	c9                   	leave  
  802f2c:	c3                   	ret    

00802f2d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f2d:	55                   	push   %ebp
  802f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	52                   	push   %edx
  802f3d:	50                   	push   %eax
  802f3e:	6a 08                	push   $0x8
  802f40:	e8 45 ff ff ff       	call   802e8a <syscall>
  802f45:	83 c4 18             	add    $0x18,%esp
}
  802f48:	c9                   	leave  
  802f49:	c3                   	ret    

00802f4a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f4a:	55                   	push   %ebp
  802f4b:	89 e5                	mov    %esp,%ebp
  802f4d:	56                   	push   %esi
  802f4e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f4f:	8b 75 18             	mov    0x18(%ebp),%esi
  802f52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	56                   	push   %esi
  802f5f:	53                   	push   %ebx
  802f60:	51                   	push   %ecx
  802f61:	52                   	push   %edx
  802f62:	50                   	push   %eax
  802f63:	6a 09                	push   $0x9
  802f65:	e8 20 ff ff ff       	call   802e8a <syscall>
  802f6a:	83 c4 18             	add    $0x18,%esp
}
  802f6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f70:	5b                   	pop    %ebx
  802f71:	5e                   	pop    %esi
  802f72:	5d                   	pop    %ebp
  802f73:	c3                   	ret    

00802f74 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f74:	55                   	push   %ebp
  802f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f77:	6a 00                	push   $0x0
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 00                	push   $0x0
  802f7f:	ff 75 08             	pushl  0x8(%ebp)
  802f82:	6a 0a                	push   $0xa
  802f84:	e8 01 ff ff ff       	call   802e8a <syscall>
  802f89:	83 c4 18             	add    $0x18,%esp
}
  802f8c:	c9                   	leave  
  802f8d:	c3                   	ret    

00802f8e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f8e:	55                   	push   %ebp
  802f8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	ff 75 0c             	pushl  0xc(%ebp)
  802f9a:	ff 75 08             	pushl  0x8(%ebp)
  802f9d:	6a 0b                	push   $0xb
  802f9f:	e8 e6 fe ff ff       	call   802e8a <syscall>
  802fa4:	83 c4 18             	add    $0x18,%esp
}
  802fa7:	c9                   	leave  
  802fa8:	c3                   	ret    

00802fa9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802fa9:	55                   	push   %ebp
  802faa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802fac:	6a 00                	push   $0x0
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 00                	push   $0x0
  802fb2:	6a 00                	push   $0x0
  802fb4:	6a 00                	push   $0x0
  802fb6:	6a 0c                	push   $0xc
  802fb8:	e8 cd fe ff ff       	call   802e8a <syscall>
  802fbd:	83 c4 18             	add    $0x18,%esp
}
  802fc0:	c9                   	leave  
  802fc1:	c3                   	ret    

00802fc2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	6a 00                	push   $0x0
  802fcf:	6a 0d                	push   $0xd
  802fd1:	e8 b4 fe ff ff       	call   802e8a <syscall>
  802fd6:	83 c4 18             	add    $0x18,%esp
}
  802fd9:	c9                   	leave  
  802fda:	c3                   	ret    

00802fdb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fdb:	55                   	push   %ebp
  802fdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 00                	push   $0x0
  802fe4:	6a 00                	push   $0x0
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 0e                	push   $0xe
  802fea:	e8 9b fe ff ff       	call   802e8a <syscall>
  802fef:	83 c4 18             	add    $0x18,%esp
}
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 00                	push   $0x0
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	6a 0f                	push   $0xf
  803003:	e8 82 fe ff ff       	call   802e8a <syscall>
  803008:	83 c4 18             	add    $0x18,%esp
}
  80300b:	c9                   	leave  
  80300c:	c3                   	ret    

0080300d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80300d:	55                   	push   %ebp
  80300e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803010:	6a 00                	push   $0x0
  803012:	6a 00                	push   $0x0
  803014:	6a 00                	push   $0x0
  803016:	6a 00                	push   $0x0
  803018:	ff 75 08             	pushl  0x8(%ebp)
  80301b:	6a 10                	push   $0x10
  80301d:	e8 68 fe ff ff       	call   802e8a <syscall>
  803022:	83 c4 18             	add    $0x18,%esp
}
  803025:	c9                   	leave  
  803026:	c3                   	ret    

00803027 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803027:	55                   	push   %ebp
  803028:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 11                	push   $0x11
  803036:	e8 4f fe ff ff       	call   802e8a <syscall>
  80303b:	83 c4 18             	add    $0x18,%esp
}
  80303e:	90                   	nop
  80303f:	c9                   	leave  
  803040:	c3                   	ret    

00803041 <sys_cputc>:

void
sys_cputc(const char c)
{
  803041:	55                   	push   %ebp
  803042:	89 e5                	mov    %esp,%ebp
  803044:	83 ec 04             	sub    $0x4,%esp
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80304d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803051:	6a 00                	push   $0x0
  803053:	6a 00                	push   $0x0
  803055:	6a 00                	push   $0x0
  803057:	6a 00                	push   $0x0
  803059:	50                   	push   %eax
  80305a:	6a 01                	push   $0x1
  80305c:	e8 29 fe ff ff       	call   802e8a <syscall>
  803061:	83 c4 18             	add    $0x18,%esp
}
  803064:	90                   	nop
  803065:	c9                   	leave  
  803066:	c3                   	ret    

00803067 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803067:	55                   	push   %ebp
  803068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80306a:	6a 00                	push   $0x0
  80306c:	6a 00                	push   $0x0
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	6a 14                	push   $0x14
  803076:	e8 0f fe ff ff       	call   802e8a <syscall>
  80307b:	83 c4 18             	add    $0x18,%esp
}
  80307e:	90                   	nop
  80307f:	c9                   	leave  
  803080:	c3                   	ret    

00803081 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803081:	55                   	push   %ebp
  803082:	89 e5                	mov    %esp,%ebp
  803084:	83 ec 04             	sub    $0x4,%esp
  803087:	8b 45 10             	mov    0x10(%ebp),%eax
  80308a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80308d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803090:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	6a 00                	push   $0x0
  803099:	51                   	push   %ecx
  80309a:	52                   	push   %edx
  80309b:	ff 75 0c             	pushl  0xc(%ebp)
  80309e:	50                   	push   %eax
  80309f:	6a 15                	push   $0x15
  8030a1:	e8 e4 fd ff ff       	call   802e8a <syscall>
  8030a6:	83 c4 18             	add    $0x18,%esp
}
  8030a9:	c9                   	leave  
  8030aa:	c3                   	ret    

008030ab <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8030ab:	55                   	push   %ebp
  8030ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8030ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	6a 00                	push   $0x0
  8030b6:	6a 00                	push   $0x0
  8030b8:	6a 00                	push   $0x0
  8030ba:	52                   	push   %edx
  8030bb:	50                   	push   %eax
  8030bc:	6a 16                	push   $0x16
  8030be:	e8 c7 fd ff ff       	call   802e8a <syscall>
  8030c3:	83 c4 18             	add    $0x18,%esp
}
  8030c6:	c9                   	leave  
  8030c7:	c3                   	ret    

008030c8 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8030c8:	55                   	push   %ebp
  8030c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	6a 00                	push   $0x0
  8030d6:	6a 00                	push   $0x0
  8030d8:	51                   	push   %ecx
  8030d9:	52                   	push   %edx
  8030da:	50                   	push   %eax
  8030db:	6a 17                	push   $0x17
  8030dd:	e8 a8 fd ff ff       	call   802e8a <syscall>
  8030e2:	83 c4 18             	add    $0x18,%esp
}
  8030e5:	c9                   	leave  
  8030e6:	c3                   	ret    

008030e7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8030ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	6a 00                	push   $0x0
  8030f2:	6a 00                	push   $0x0
  8030f4:	6a 00                	push   $0x0
  8030f6:	52                   	push   %edx
  8030f7:	50                   	push   %eax
  8030f8:	6a 18                	push   $0x18
  8030fa:	e8 8b fd ff ff       	call   802e8a <syscall>
  8030ff:	83 c4 18             	add    $0x18,%esp
}
  803102:	c9                   	leave  
  803103:	c3                   	ret    

00803104 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803104:	55                   	push   %ebp
  803105:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	6a 00                	push   $0x0
  80310c:	ff 75 14             	pushl  0x14(%ebp)
  80310f:	ff 75 10             	pushl  0x10(%ebp)
  803112:	ff 75 0c             	pushl  0xc(%ebp)
  803115:	50                   	push   %eax
  803116:	6a 19                	push   $0x19
  803118:	e8 6d fd ff ff       	call   802e8a <syscall>
  80311d:	83 c4 18             	add    $0x18,%esp
}
  803120:	c9                   	leave  
  803121:	c3                   	ret    

00803122 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803122:	55                   	push   %ebp
  803123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	50                   	push   %eax
  803131:	6a 1a                	push   $0x1a
  803133:	e8 52 fd ff ff       	call   802e8a <syscall>
  803138:	83 c4 18             	add    $0x18,%esp
}
  80313b:	90                   	nop
  80313c:	c9                   	leave  
  80313d:	c3                   	ret    

0080313e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80313e:	55                   	push   %ebp
  80313f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	50                   	push   %eax
  80314d:	6a 1b                	push   $0x1b
  80314f:	e8 36 fd ff ff       	call   802e8a <syscall>
  803154:	83 c4 18             	add    $0x18,%esp
}
  803157:	c9                   	leave  
  803158:	c3                   	ret    

00803159 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803159:	55                   	push   %ebp
  80315a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 00                	push   $0x0
  803162:	6a 00                	push   $0x0
  803164:	6a 00                	push   $0x0
  803166:	6a 05                	push   $0x5
  803168:	e8 1d fd ff ff       	call   802e8a <syscall>
  80316d:	83 c4 18             	add    $0x18,%esp
}
  803170:	c9                   	leave  
  803171:	c3                   	ret    

00803172 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803172:	55                   	push   %ebp
  803173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803175:	6a 00                	push   $0x0
  803177:	6a 00                	push   $0x0
  803179:	6a 00                	push   $0x0
  80317b:	6a 00                	push   $0x0
  80317d:	6a 00                	push   $0x0
  80317f:	6a 06                	push   $0x6
  803181:	e8 04 fd ff ff       	call   802e8a <syscall>
  803186:	83 c4 18             	add    $0x18,%esp
}
  803189:	c9                   	leave  
  80318a:	c3                   	ret    

0080318b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80318b:	55                   	push   %ebp
  80318c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80318e:	6a 00                	push   $0x0
  803190:	6a 00                	push   $0x0
  803192:	6a 00                	push   $0x0
  803194:	6a 00                	push   $0x0
  803196:	6a 00                	push   $0x0
  803198:	6a 07                	push   $0x7
  80319a:	e8 eb fc ff ff       	call   802e8a <syscall>
  80319f:	83 c4 18             	add    $0x18,%esp
}
  8031a2:	c9                   	leave  
  8031a3:	c3                   	ret    

008031a4 <sys_exit_env>:


void sys_exit_env(void)
{
  8031a4:	55                   	push   %ebp
  8031a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8031a7:	6a 00                	push   $0x0
  8031a9:	6a 00                	push   $0x0
  8031ab:	6a 00                	push   $0x0
  8031ad:	6a 00                	push   $0x0
  8031af:	6a 00                	push   $0x0
  8031b1:	6a 1c                	push   $0x1c
  8031b3:	e8 d2 fc ff ff       	call   802e8a <syscall>
  8031b8:	83 c4 18             	add    $0x18,%esp
}
  8031bb:	90                   	nop
  8031bc:	c9                   	leave  
  8031bd:	c3                   	ret    

008031be <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
  8031c1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031c7:	8d 50 04             	lea    0x4(%eax),%edx
  8031ca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031cd:	6a 00                	push   $0x0
  8031cf:	6a 00                	push   $0x0
  8031d1:	6a 00                	push   $0x0
  8031d3:	52                   	push   %edx
  8031d4:	50                   	push   %eax
  8031d5:	6a 1d                	push   $0x1d
  8031d7:	e8 ae fc ff ff       	call   802e8a <syscall>
  8031dc:	83 c4 18             	add    $0x18,%esp
	return result;
  8031df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8031e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031e8:	89 01                	mov    %eax,(%ecx)
  8031ea:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	c9                   	leave  
  8031f1:	c2 04 00             	ret    $0x4

008031f4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8031f4:	55                   	push   %ebp
  8031f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8031f7:	6a 00                	push   $0x0
  8031f9:	6a 00                	push   $0x0
  8031fb:	ff 75 10             	pushl  0x10(%ebp)
  8031fe:	ff 75 0c             	pushl  0xc(%ebp)
  803201:	ff 75 08             	pushl  0x8(%ebp)
  803204:	6a 13                	push   $0x13
  803206:	e8 7f fc ff ff       	call   802e8a <syscall>
  80320b:	83 c4 18             	add    $0x18,%esp
	return ;
  80320e:	90                   	nop
}
  80320f:	c9                   	leave  
  803210:	c3                   	ret    

00803211 <sys_rcr2>:
uint32 sys_rcr2()
{
  803211:	55                   	push   %ebp
  803212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	6a 00                	push   $0x0
  80321a:	6a 00                	push   $0x0
  80321c:	6a 00                	push   $0x0
  80321e:	6a 1e                	push   $0x1e
  803220:	e8 65 fc ff ff       	call   802e8a <syscall>
  803225:	83 c4 18             	add    $0x18,%esp
}
  803228:	c9                   	leave  
  803229:	c3                   	ret    

0080322a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80322a:	55                   	push   %ebp
  80322b:	89 e5                	mov    %esp,%ebp
  80322d:	83 ec 04             	sub    $0x4,%esp
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803236:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	6a 00                	push   $0x0
  803242:	50                   	push   %eax
  803243:	6a 1f                	push   $0x1f
  803245:	e8 40 fc ff ff       	call   802e8a <syscall>
  80324a:	83 c4 18             	add    $0x18,%esp
	return ;
  80324d:	90                   	nop
}
  80324e:	c9                   	leave  
  80324f:	c3                   	ret    

00803250 <rsttst>:
void rsttst()
{
  803250:	55                   	push   %ebp
  803251:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803253:	6a 00                	push   $0x0
  803255:	6a 00                	push   $0x0
  803257:	6a 00                	push   $0x0
  803259:	6a 00                	push   $0x0
  80325b:	6a 00                	push   $0x0
  80325d:	6a 21                	push   $0x21
  80325f:	e8 26 fc ff ff       	call   802e8a <syscall>
  803264:	83 c4 18             	add    $0x18,%esp
	return ;
  803267:	90                   	nop
}
  803268:	c9                   	leave  
  803269:	c3                   	ret    

0080326a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80326a:	55                   	push   %ebp
  80326b:	89 e5                	mov    %esp,%ebp
  80326d:	83 ec 04             	sub    $0x4,%esp
  803270:	8b 45 14             	mov    0x14(%ebp),%eax
  803273:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803276:	8b 55 18             	mov    0x18(%ebp),%edx
  803279:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80327d:	52                   	push   %edx
  80327e:	50                   	push   %eax
  80327f:	ff 75 10             	pushl  0x10(%ebp)
  803282:	ff 75 0c             	pushl  0xc(%ebp)
  803285:	ff 75 08             	pushl  0x8(%ebp)
  803288:	6a 20                	push   $0x20
  80328a:	e8 fb fb ff ff       	call   802e8a <syscall>
  80328f:	83 c4 18             	add    $0x18,%esp
	return ;
  803292:	90                   	nop
}
  803293:	c9                   	leave  
  803294:	c3                   	ret    

00803295 <chktst>:
void chktst(uint32 n)
{
  803295:	55                   	push   %ebp
  803296:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803298:	6a 00                	push   $0x0
  80329a:	6a 00                	push   $0x0
  80329c:	6a 00                	push   $0x0
  80329e:	6a 00                	push   $0x0
  8032a0:	ff 75 08             	pushl  0x8(%ebp)
  8032a3:	6a 22                	push   $0x22
  8032a5:	e8 e0 fb ff ff       	call   802e8a <syscall>
  8032aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8032ad:	90                   	nop
}
  8032ae:	c9                   	leave  
  8032af:	c3                   	ret    

008032b0 <inctst>:

void inctst()
{
  8032b0:	55                   	push   %ebp
  8032b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8032b3:	6a 00                	push   $0x0
  8032b5:	6a 00                	push   $0x0
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	6a 00                	push   $0x0
  8032bd:	6a 23                	push   $0x23
  8032bf:	e8 c6 fb ff ff       	call   802e8a <syscall>
  8032c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8032c7:	90                   	nop
}
  8032c8:	c9                   	leave  
  8032c9:	c3                   	ret    

008032ca <gettst>:
uint32 gettst()
{
  8032ca:	55                   	push   %ebp
  8032cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032cd:	6a 00                	push   $0x0
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 00                	push   $0x0
  8032d3:	6a 00                	push   $0x0
  8032d5:	6a 00                	push   $0x0
  8032d7:	6a 24                	push   $0x24
  8032d9:	e8 ac fb ff ff       	call   802e8a <syscall>
  8032de:	83 c4 18             	add    $0x18,%esp
}
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032e6:	6a 00                	push   $0x0
  8032e8:	6a 00                	push   $0x0
  8032ea:	6a 00                	push   $0x0
  8032ec:	6a 00                	push   $0x0
  8032ee:	6a 00                	push   $0x0
  8032f0:	6a 25                	push   $0x25
  8032f2:	e8 93 fb ff ff       	call   802e8a <syscall>
  8032f7:	83 c4 18             	add    $0x18,%esp
  8032fa:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8032ff:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803304:	c9                   	leave  
  803305:	c3                   	ret    

00803306 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803306:	55                   	push   %ebp
  803307:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803311:	6a 00                	push   $0x0
  803313:	6a 00                	push   $0x0
  803315:	6a 00                	push   $0x0
  803317:	6a 00                	push   $0x0
  803319:	ff 75 08             	pushl  0x8(%ebp)
  80331c:	6a 26                	push   $0x26
  80331e:	e8 67 fb ff ff       	call   802e8a <syscall>
  803323:	83 c4 18             	add    $0x18,%esp
	return ;
  803326:	90                   	nop
}
  803327:	c9                   	leave  
  803328:	c3                   	ret    

00803329 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803329:	55                   	push   %ebp
  80332a:	89 e5                	mov    %esp,%ebp
  80332c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80332d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803330:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803333:	8b 55 0c             	mov    0xc(%ebp),%edx
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	6a 00                	push   $0x0
  80333b:	53                   	push   %ebx
  80333c:	51                   	push   %ecx
  80333d:	52                   	push   %edx
  80333e:	50                   	push   %eax
  80333f:	6a 27                	push   $0x27
  803341:	e8 44 fb ff ff       	call   802e8a <syscall>
  803346:	83 c4 18             	add    $0x18,%esp
}
  803349:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80334c:	c9                   	leave  
  80334d:	c3                   	ret    

0080334e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80334e:	55                   	push   %ebp
  80334f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803351:	8b 55 0c             	mov    0xc(%ebp),%edx
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	6a 00                	push   $0x0
  803359:	6a 00                	push   $0x0
  80335b:	6a 00                	push   $0x0
  80335d:	52                   	push   %edx
  80335e:	50                   	push   %eax
  80335f:	6a 28                	push   $0x28
  803361:	e8 24 fb ff ff       	call   802e8a <syscall>
  803366:	83 c4 18             	add    $0x18,%esp
}
  803369:	c9                   	leave  
  80336a:	c3                   	ret    

0080336b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80336b:	55                   	push   %ebp
  80336c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80336e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803371:	8b 55 0c             	mov    0xc(%ebp),%edx
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	6a 00                	push   $0x0
  803379:	51                   	push   %ecx
  80337a:	ff 75 10             	pushl  0x10(%ebp)
  80337d:	52                   	push   %edx
  80337e:	50                   	push   %eax
  80337f:	6a 29                	push   $0x29
  803381:	e8 04 fb ff ff       	call   802e8a <syscall>
  803386:	83 c4 18             	add    $0x18,%esp
}
  803389:	c9                   	leave  
  80338a:	c3                   	ret    

0080338b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80338b:	55                   	push   %ebp
  80338c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80338e:	6a 00                	push   $0x0
  803390:	6a 00                	push   $0x0
  803392:	ff 75 10             	pushl  0x10(%ebp)
  803395:	ff 75 0c             	pushl  0xc(%ebp)
  803398:	ff 75 08             	pushl  0x8(%ebp)
  80339b:	6a 12                	push   $0x12
  80339d:	e8 e8 fa ff ff       	call   802e8a <syscall>
  8033a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8033a5:	90                   	nop
}
  8033a6:	c9                   	leave  
  8033a7:	c3                   	ret    

008033a8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8033a8:	55                   	push   %ebp
  8033a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8033ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	6a 00                	push   $0x0
  8033b3:	6a 00                	push   $0x0
  8033b5:	6a 00                	push   $0x0
  8033b7:	52                   	push   %edx
  8033b8:	50                   	push   %eax
  8033b9:	6a 2a                	push   $0x2a
  8033bb:	e8 ca fa ff ff       	call   802e8a <syscall>
  8033c0:	83 c4 18             	add    $0x18,%esp
	return;
  8033c3:	90                   	nop
}
  8033c4:	c9                   	leave  
  8033c5:	c3                   	ret    

008033c6 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8033c6:	55                   	push   %ebp
  8033c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8033c9:	6a 00                	push   $0x0
  8033cb:	6a 00                	push   $0x0
  8033cd:	6a 00                	push   $0x0
  8033cf:	6a 00                	push   $0x0
  8033d1:	6a 00                	push   $0x0
  8033d3:	6a 2b                	push   $0x2b
  8033d5:	e8 b0 fa ff ff       	call   802e8a <syscall>
  8033da:	83 c4 18             	add    $0x18,%esp
}
  8033dd:	c9                   	leave  
  8033de:	c3                   	ret    

008033df <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8033df:	55                   	push   %ebp
  8033e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 00                	push   $0x0
  8033e8:	ff 75 0c             	pushl  0xc(%ebp)
  8033eb:	ff 75 08             	pushl  0x8(%ebp)
  8033ee:	6a 2d                	push   $0x2d
  8033f0:	e8 95 fa ff ff       	call   802e8a <syscall>
  8033f5:	83 c4 18             	add    $0x18,%esp
	return;
  8033f8:	90                   	nop
}
  8033f9:	c9                   	leave  
  8033fa:	c3                   	ret    

008033fb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8033fb:	55                   	push   %ebp
  8033fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8033fe:	6a 00                	push   $0x0
  803400:	6a 00                	push   $0x0
  803402:	6a 00                	push   $0x0
  803404:	ff 75 0c             	pushl  0xc(%ebp)
  803407:	ff 75 08             	pushl  0x8(%ebp)
  80340a:	6a 2c                	push   $0x2c
  80340c:	e8 79 fa ff ff       	call   802e8a <syscall>
  803411:	83 c4 18             	add    $0x18,%esp
	return ;
  803414:	90                   	nop
}
  803415:	c9                   	leave  
  803416:	c3                   	ret    

00803417 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803417:	55                   	push   %ebp
  803418:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80341a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	6a 00                	push   $0x0
  803422:	6a 00                	push   $0x0
  803424:	6a 00                	push   $0x0
  803426:	52                   	push   %edx
  803427:	50                   	push   %eax
  803428:	6a 2e                	push   $0x2e
  80342a:	e8 5b fa ff ff       	call   802e8a <syscall>
  80342f:	83 c4 18             	add    $0x18,%esp
}
  803432:	90                   	nop
  803433:	c9                   	leave  
  803434:	c3                   	ret    

00803435 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803435:	55                   	push   %ebp
  803436:	89 e5                	mov    %esp,%ebp
  803438:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80343b:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803442:	72 09                	jb     80344d <to_page_va+0x18>
  803444:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80344b:	72 14                	jb     803461 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80344d:	83 ec 04             	sub    $0x4,%esp
  803450:	68 d8 49 80 00       	push   $0x8049d8
  803455:	6a 15                	push   $0x15
  803457:	68 03 4a 80 00       	push   $0x804a03
  80345c:	e8 10 d0 ff ff       	call   800471 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803469:	29 d0                	sub    %edx,%eax
  80346b:	c1 f8 02             	sar    $0x2,%eax
  80346e:	89 c2                	mov    %eax,%edx
  803470:	89 d0                	mov    %edx,%eax
  803472:	c1 e0 02             	shl    $0x2,%eax
  803475:	01 d0                	add    %edx,%eax
  803477:	c1 e0 02             	shl    $0x2,%eax
  80347a:	01 d0                	add    %edx,%eax
  80347c:	c1 e0 02             	shl    $0x2,%eax
  80347f:	01 d0                	add    %edx,%eax
  803481:	89 c1                	mov    %eax,%ecx
  803483:	c1 e1 08             	shl    $0x8,%ecx
  803486:	01 c8                	add    %ecx,%eax
  803488:	89 c1                	mov    %eax,%ecx
  80348a:	c1 e1 10             	shl    $0x10,%ecx
  80348d:	01 c8                	add    %ecx,%eax
  80348f:	01 c0                	add    %eax,%eax
  803491:	01 d0                	add    %edx,%eax
  803493:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803499:	c1 e0 0c             	shl    $0xc,%eax
  80349c:	89 c2                	mov    %eax,%edx
  80349e:	a1 84 50 83 00       	mov    0x835084,%eax
  8034a3:	01 d0                	add    %edx,%eax
}
  8034a5:	c9                   	leave  
  8034a6:	c3                   	ret    

008034a7 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
  8034aa:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8034ad:	a1 84 50 83 00       	mov    0x835084,%eax
  8034b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b5:	29 c2                	sub    %eax,%edx
  8034b7:	89 d0                	mov    %edx,%eax
  8034b9:	c1 e8 0c             	shr    $0xc,%eax
  8034bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8034bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c3:	78 09                	js     8034ce <to_page_info+0x27>
  8034c5:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8034cc:	7e 14                	jle    8034e2 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8034ce:	83 ec 04             	sub    $0x4,%esp
  8034d1:	68 1c 4a 80 00       	push   $0x804a1c
  8034d6:	6a 21                	push   $0x21
  8034d8:	68 03 4a 80 00       	push   $0x804a03
  8034dd:	e8 8f cf ff ff       	call   800471 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8034e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e5:	89 d0                	mov    %edx,%eax
  8034e7:	01 c0                	add    %eax,%eax
  8034e9:	01 d0                	add    %edx,%eax
  8034eb:	c1 e0 02             	shl    $0x2,%eax
  8034ee:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8034f3:	c9                   	leave  
  8034f4:	c3                   	ret    

008034f5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8034f5:	55                   	push   %ebp
  8034f6:	89 e5                	mov    %esp,%ebp
  8034f8:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	05 00 00 00 02       	add    $0x2000000,%eax
  803503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803506:	73 16                	jae    80351e <initialize_dynamic_allocator+0x29>
  803508:	68 40 4a 80 00       	push   $0x804a40
  80350d:	68 66 4a 80 00       	push   $0x804a66
  803512:	6a 2f                	push   $0x2f
  803514:	68 03 4a 80 00       	push   $0x804a03
  803519:	e8 53 cf ff ff       	call   800471 <_panic>
	dynAllocStart = daStart;
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803526:	8b 45 0c             	mov    0xc(%ebp),%eax
  803529:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80352e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803535:	eb 36                	jmp    80356d <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353a:	c1 e0 04             	shl    $0x4,%eax
  80353d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803542:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	c1 e0 04             	shl    $0x4,%eax
  80354e:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803553:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	c1 e0 04             	shl    $0x4,%eax
  80355f:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80356a:	ff 45 f4             	incl   -0xc(%ebp)
  80356d:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803571:	7e c4                	jle    803537 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803573:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80357a:	00 00 00 
  80357d:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803584:	00 00 00 
  803587:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80358e:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803591:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803598:	e9 1b 01 00 00       	jmp    8036b8 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  80359d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a0:	89 d0                	mov    %edx,%eax
  8035a2:	01 c0                	add    %eax,%eax
  8035a4:	01 d0                	add    %edx,%eax
  8035a6:	c1 e0 02             	shl    $0x2,%eax
  8035a9:	05 88 d0 81 00       	add    $0x81d088,%eax
  8035ae:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8035b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b6:	89 d0                	mov    %edx,%eax
  8035b8:	01 c0                	add    %eax,%eax
  8035ba:	01 d0                	add    %edx,%eax
  8035bc:	c1 e0 02             	shl    $0x2,%eax
  8035bf:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8035c4:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8035c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035cc:	89 d0                	mov    %edx,%eax
  8035ce:	01 c0                	add    %eax,%eax
  8035d0:	01 d0                	add    %edx,%eax
  8035d2:	c1 e0 02             	shl    $0x2,%eax
  8035d5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035da:	8b 00                	mov    (%eax),%eax
  8035dc:	85 c0                	test   %eax,%eax
  8035de:	74 2b                	je     80360b <initialize_dynamic_allocator+0x116>
  8035e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e3:	89 d0                	mov    %edx,%eax
  8035e5:	01 c0                	add    %eax,%eax
  8035e7:	01 d0                	add    %edx,%eax
  8035e9:	c1 e0 02             	shl    $0x2,%eax
  8035ec:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035f1:	8b 10                	mov    (%eax),%edx
  8035f3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035f6:	89 c8                	mov    %ecx,%eax
  8035f8:	01 c0                	add    %eax,%eax
  8035fa:	01 c8                	add    %ecx,%eax
  8035fc:	c1 e0 02             	shl    $0x2,%eax
  8035ff:	05 84 d0 81 00       	add    $0x81d084,%eax
  803604:	8b 00                	mov    (%eax),%eax
  803606:	89 42 04             	mov    %eax,0x4(%edx)
  803609:	eb 18                	jmp    803623 <initialize_dynamic_allocator+0x12e>
  80360b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80360e:	89 d0                	mov    %edx,%eax
  803610:	01 c0                	add    %eax,%eax
  803612:	01 d0                	add    %edx,%eax
  803614:	c1 e0 02             	shl    $0x2,%eax
  803617:	05 84 d0 81 00       	add    $0x81d084,%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803623:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803626:	89 d0                	mov    %edx,%eax
  803628:	01 c0                	add    %eax,%eax
  80362a:	01 d0                	add    %edx,%eax
  80362c:	c1 e0 02             	shl    $0x2,%eax
  80362f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 2a                	je     803664 <initialize_dynamic_allocator+0x16f>
  80363a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80363d:	89 d0                	mov    %edx,%eax
  80363f:	01 c0                	add    %eax,%eax
  803641:	01 d0                	add    %edx,%eax
  803643:	c1 e0 02             	shl    $0x2,%eax
  803646:	05 84 d0 81 00       	add    $0x81d084,%eax
  80364b:	8b 10                	mov    (%eax),%edx
  80364d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803650:	89 c8                	mov    %ecx,%eax
  803652:	01 c0                	add    %eax,%eax
  803654:	01 c8                	add    %ecx,%eax
  803656:	c1 e0 02             	shl    $0x2,%eax
  803659:	05 80 d0 81 00       	add    $0x81d080,%eax
  80365e:	8b 00                	mov    (%eax),%eax
  803660:	89 02                	mov    %eax,(%edx)
  803662:	eb 18                	jmp    80367c <initialize_dynamic_allocator+0x187>
  803664:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803667:	89 d0                	mov    %edx,%eax
  803669:	01 c0                	add    %eax,%eax
  80366b:	01 d0                	add    %edx,%eax
  80366d:	c1 e0 02             	shl    $0x2,%eax
  803670:	05 80 d0 81 00       	add    $0x81d080,%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80367c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80367f:	89 d0                	mov    %edx,%eax
  803681:	01 c0                	add    %eax,%eax
  803683:	01 d0                	add    %edx,%eax
  803685:	c1 e0 02             	shl    $0x2,%eax
  803688:	05 80 d0 81 00       	add    $0x81d080,%eax
  80368d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803693:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803696:	89 d0                	mov    %edx,%eax
  803698:	01 c0                	add    %eax,%eax
  80369a:	01 d0                	add    %edx,%eax
  80369c:	c1 e0 02             	shl    $0x2,%eax
  80369f:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036aa:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036af:	48                   	dec    %eax
  8036b0:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036b5:	ff 45 f0             	incl   -0x10(%ebp)
  8036b8:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8036bf:	0f 8e d8 fe ff ff    	jle    80359d <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036c5:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8036cc:	e9 9d 00 00 00       	jmp    80376e <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8036d1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036d7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036da:	89 c8                	mov    %ecx,%eax
  8036dc:	01 c0                	add    %eax,%eax
  8036de:	01 c8                	add    %ecx,%eax
  8036e0:	c1 e0 02             	shl    $0x2,%eax
  8036e3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036e8:	89 10                	mov    %edx,(%eax)
  8036ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036ed:	89 d0                	mov    %edx,%eax
  8036ef:	01 c0                	add    %eax,%eax
  8036f1:	01 d0                	add    %edx,%eax
  8036f3:	c1 e0 02             	shl    $0x2,%eax
  8036f6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036fb:	8b 00                	mov    (%eax),%eax
  8036fd:	85 c0                	test   %eax,%eax
  8036ff:	74 1c                	je     80371d <initialize_dynamic_allocator+0x228>
  803701:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803707:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80370a:	89 c8                	mov    %ecx,%eax
  80370c:	01 c0                	add    %eax,%eax
  80370e:	01 c8                	add    %ecx,%eax
  803710:	c1 e0 02             	shl    $0x2,%eax
  803713:	05 80 d0 81 00       	add    $0x81d080,%eax
  803718:	89 42 04             	mov    %eax,0x4(%edx)
  80371b:	eb 16                	jmp    803733 <initialize_dynamic_allocator+0x23e>
  80371d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803720:	89 d0                	mov    %edx,%eax
  803722:	01 c0                	add    %eax,%eax
  803724:	01 d0                	add    %edx,%eax
  803726:	c1 e0 02             	shl    $0x2,%eax
  803729:	05 80 d0 81 00       	add    $0x81d080,%eax
  80372e:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803736:	89 d0                	mov    %edx,%eax
  803738:	01 c0                	add    %eax,%eax
  80373a:	01 d0                	add    %edx,%eax
  80373c:	c1 e0 02             	shl    $0x2,%eax
  80373f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803744:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803749:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80374c:	89 d0                	mov    %edx,%eax
  80374e:	01 c0                	add    %eax,%eax
  803750:	01 d0                	add    %edx,%eax
  803752:	c1 e0 02             	shl    $0x2,%eax
  803755:	05 84 d0 81 00       	add    $0x81d084,%eax
  80375a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803760:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803765:	40                   	inc    %eax
  803766:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80376b:	ff 4d ec             	decl   -0x14(%ebp)
  80376e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803772:	0f 89 59 ff ff ff    	jns    8036d1 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803778:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  80377f:	00 00 00 
}
  803782:	90                   	nop
  803783:	c9                   	leave  
  803784:	c3                   	ret    

00803785 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803785:	55                   	push   %ebp
  803786:	89 e5                	mov    %esp,%ebp
  803788:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	83 ec 0c             	sub    $0xc,%esp
  803791:	50                   	push   %eax
  803792:	e8 10 fd ff ff       	call   8034a7 <to_page_info>
  803797:	83 c4 10             	add    $0x10,%esp
  80379a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  80379d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a0:	8b 40 08             	mov    0x8(%eax),%eax
  8037a3:	0f b7 c0             	movzwl %ax,%eax
}
  8037a6:	c9                   	leave  
  8037a7:	c3                   	ret    

008037a8 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037a8:	55                   	push   %ebp
  8037a9:	89 e5                	mov    %esp,%ebp
  8037ab:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037ae:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037b5:	76 16                	jbe    8037cd <alloc_block+0x25>
  8037b7:	68 7c 4a 80 00       	push   $0x804a7c
  8037bc:	68 66 4a 80 00       	push   $0x804a66
  8037c1:	6a 59                	push   $0x59
  8037c3:	68 03 4a 80 00       	push   $0x804a03
  8037c8:	e8 a4 cc ff ff       	call   800471 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8037cd:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037d4:	eb 08                	jmp    8037de <alloc_block+0x36>
		allocSize <<= 1;
  8037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d9:	01 c0                	add    %eax,%eax
  8037db:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e4:	73 09                	jae    8037ef <alloc_block+0x47>
  8037e6:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8037ed:	76 e7                	jbe    8037d6 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8037ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037f6:	eb 03                	jmp    8037fb <alloc_block+0x53>
		listIndex++;
  8037f8:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037fe:	ba 08 00 00 00       	mov    $0x8,%edx
  803803:	88 c1                	mov    %al,%cl
  803805:	d3 e2                	shl    %cl,%edx
  803807:	89 d0                	mov    %edx,%eax
  803809:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80380c:	72 ea                	jb     8037f8 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803811:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803814:	e9 f4 00 00 00       	jmp    80390d <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381c:	c1 e0 04             	shl    $0x4,%eax
  80381f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803824:	8b 00                	mov    (%eax),%eax
  803826:	85 c0                	test   %eax,%eax
  803828:	0f 84 dc 00 00 00    	je     80390a <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80382e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803831:	c1 e0 04             	shl    $0x4,%eax
  803834:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80383e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803842:	75 14                	jne    803858 <alloc_block+0xb0>
  803844:	83 ec 04             	sub    $0x4,%esp
  803847:	68 9d 4a 80 00       	push   $0x804a9d
  80384c:	6a 6b                	push   $0x6b
  80384e:	68 03 4a 80 00       	push   $0x804a03
  803853:	e8 19 cc ff ff       	call   800471 <_panic>
  803858:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	85 c0                	test   %eax,%eax
  80385f:	74 10                	je     803871 <alloc_block+0xc9>
  803861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803869:	8b 52 04             	mov    0x4(%edx),%edx
  80386c:	89 50 04             	mov    %edx,0x4(%eax)
  80386f:	eb 14                	jmp    803885 <alloc_block+0xdd>
  803871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803874:	8b 40 04             	mov    0x4(%eax),%eax
  803877:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80387a:	c1 e2 04             	shl    $0x4,%edx
  80387d:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803883:	89 02                	mov    %eax,(%edx)
  803885:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803888:	8b 40 04             	mov    0x4(%eax),%eax
  80388b:	85 c0                	test   %eax,%eax
  80388d:	74 0f                	je     80389e <alloc_block+0xf6>
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	8b 40 04             	mov    0x4(%eax),%eax
  803895:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803898:	8b 12                	mov    (%edx),%edx
  80389a:	89 10                	mov    %edx,(%eax)
  80389c:	eb 13                	jmp    8038b1 <alloc_block+0x109>
  80389e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a1:	8b 00                	mov    (%eax),%eax
  8038a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038a6:	c1 e2 04             	shl    $0x4,%edx
  8038a9:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8038af:	89 02                	mov    %eax,(%edx)
  8038b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c7:	c1 e0 04             	shl    $0x4,%eax
  8038ca:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d7:	c1 e0 04             	shl    $0x4,%eax
  8038da:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038df:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	83 ec 0c             	sub    $0xc,%esp
  8038e7:	50                   	push   %eax
  8038e8:	e8 ba fb ff ff       	call   8034a7 <to_page_info>
  8038ed:	83 c4 10             	add    $0x10,%esp
  8038f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8038f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8038fa:	48                   	dec    %eax
  8038fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038fe:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803905:	e9 8f 02 00 00       	jmp    803b99 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80390a:	ff 45 ec             	incl   -0x14(%ebp)
  80390d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803911:	0f 8e 02 ff ff ff    	jle    803819 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803917:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	75 14                	jne    803934 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803920:	83 ec 04             	sub    $0x4,%esp
  803923:	68 bc 4a 80 00       	push   $0x804abc
  803928:	6a 77                	push   $0x77
  80392a:	68 03 4a 80 00       	push   $0x804a03
  80392f:	e8 3d cb ff ff       	call   800471 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803934:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803939:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80393c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803940:	75 14                	jne    803956 <alloc_block+0x1ae>
  803942:	83 ec 04             	sub    $0x4,%esp
  803945:	68 9d 4a 80 00       	push   $0x804a9d
  80394a:	6a 7a                	push   $0x7a
  80394c:	68 03 4a 80 00       	push   $0x804a03
  803951:	e8 1b cb ff ff       	call   800471 <_panic>
  803956:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803959:	8b 00                	mov    (%eax),%eax
  80395b:	85 c0                	test   %eax,%eax
  80395d:	74 10                	je     80396f <alloc_block+0x1c7>
  80395f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803962:	8b 00                	mov    (%eax),%eax
  803964:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803967:	8b 52 04             	mov    0x4(%edx),%edx
  80396a:	89 50 04             	mov    %edx,0x4(%eax)
  80396d:	eb 0b                	jmp    80397a <alloc_block+0x1d2>
  80396f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803972:	8b 40 04             	mov    0x4(%eax),%eax
  803975:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80397a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397d:	8b 40 04             	mov    0x4(%eax),%eax
  803980:	85 c0                	test   %eax,%eax
  803982:	74 0f                	je     803993 <alloc_block+0x1eb>
  803984:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803987:	8b 40 04             	mov    0x4(%eax),%eax
  80398a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80398d:	8b 12                	mov    (%edx),%edx
  80398f:	89 10                	mov    %edx,(%eax)
  803991:	eb 0a                	jmp    80399d <alloc_block+0x1f5>
  803993:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80399d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b0:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8039b5:	48                   	dec    %eax
  8039b6:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8039bb:	83 ec 0c             	sub    $0xc,%esp
  8039be:	ff 75 dc             	pushl  -0x24(%ebp)
  8039c1:	e8 6f fa ff ff       	call   803435 <to_page_va>
  8039c6:	83 c4 10             	add    $0x10,%esp
  8039c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8039cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039cf:	83 ec 0c             	sub    $0xc,%esp
  8039d2:	50                   	push   %eax
  8039d3:	e8 a0 dc ff ff       	call   801678 <get_page>
  8039d8:	83 c4 10             	add    $0x10,%esp
  8039db:	85 c0                	test   %eax,%eax
  8039dd:	74 14                	je     8039f3 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8039df:	83 ec 04             	sub    $0x4,%esp
  8039e2:	68 e4 4a 80 00       	push   $0x804ae4
  8039e7:	6a 7f                	push   $0x7f
  8039e9:	68 03 4a 80 00       	push   $0x804a03
  8039ee:	e8 7e ca ff ff       	call   800471 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8039f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039f9:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8039fd:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a02:	ba 00 00 00 00       	mov    $0x0,%edx
  803a07:	f7 75 f4             	divl   -0xc(%ebp)
  803a0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a0d:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a18:	e9 a7 00 00 00       	jmp    803ac4 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a1d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a23:	01 d0                	add    %edx,%eax
  803a25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a28:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a2c:	75 17                	jne    803a45 <alloc_block+0x29d>
  803a2e:	83 ec 04             	sub    $0x4,%esp
  803a31:	68 0c 4b 80 00       	push   $0x804b0c
  803a36:	68 88 00 00 00       	push   $0x88
  803a3b:	68 03 4a 80 00       	push   $0x804a03
  803a40:	e8 2c ca ff ff       	call   800471 <_panic>
  803a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a48:	c1 e0 04             	shl    $0x4,%eax
  803a4b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a50:	8b 10                	mov    (%eax),%edx
  803a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a55:	89 10                	mov    %edx,(%eax)
  803a57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a5a:	8b 00                	mov    (%eax),%eax
  803a5c:	85 c0                	test   %eax,%eax
  803a5e:	74 15                	je     803a75 <alloc_block+0x2cd>
  803a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a63:	c1 e0 04             	shl    $0x4,%eax
  803a66:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a6b:	8b 00                	mov    (%eax),%eax
  803a6d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a70:	89 50 04             	mov    %edx,0x4(%eax)
  803a73:	eb 11                	jmp    803a86 <alloc_block+0x2de>
  803a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a78:	c1 e0 04             	shl    $0x4,%eax
  803a7b:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a84:	89 02                	mov    %eax,(%edx)
  803a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a89:	c1 e0 04             	shl    $0x4,%eax
  803a8c:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a95:	89 02                	mov    %eax,(%edx)
  803a97:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa4:	c1 e0 04             	shl    $0x4,%eax
  803aa7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803aac:	8b 00                	mov    (%eax),%eax
  803aae:	8d 50 01             	lea    0x1(%eax),%edx
  803ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab4:	c1 e0 04             	shl    $0x4,%eax
  803ab7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803abc:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	01 45 e8             	add    %eax,-0x18(%ebp)
  803ac4:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803acb:	0f 86 4c ff ff ff    	jbe    803a1d <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad4:	c1 e0 04             	shl    $0x4,%eax
  803ad7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803adc:	8b 00                	mov    (%eax),%eax
  803ade:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803ae1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ae5:	75 17                	jne    803afe <alloc_block+0x356>
  803ae7:	83 ec 04             	sub    $0x4,%esp
  803aea:	68 9d 4a 80 00       	push   $0x804a9d
  803aef:	68 8d 00 00 00       	push   $0x8d
  803af4:	68 03 4a 80 00       	push   $0x804a03
  803af9:	e8 73 c9 ff ff       	call   800471 <_panic>
  803afe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b01:	8b 00                	mov    (%eax),%eax
  803b03:	85 c0                	test   %eax,%eax
  803b05:	74 10                	je     803b17 <alloc_block+0x36f>
  803b07:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b0a:	8b 00                	mov    (%eax),%eax
  803b0c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b0f:	8b 52 04             	mov    0x4(%edx),%edx
  803b12:	89 50 04             	mov    %edx,0x4(%eax)
  803b15:	eb 14                	jmp    803b2b <alloc_block+0x383>
  803b17:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b1a:	8b 40 04             	mov    0x4(%eax),%eax
  803b1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b20:	c1 e2 04             	shl    $0x4,%edx
  803b23:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803b29:	89 02                	mov    %eax,(%edx)
  803b2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b2e:	8b 40 04             	mov    0x4(%eax),%eax
  803b31:	85 c0                	test   %eax,%eax
  803b33:	74 0f                	je     803b44 <alloc_block+0x39c>
  803b35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b38:	8b 40 04             	mov    0x4(%eax),%eax
  803b3b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b3e:	8b 12                	mov    (%edx),%edx
  803b40:	89 10                	mov    %edx,(%eax)
  803b42:	eb 13                	jmp    803b57 <alloc_block+0x3af>
  803b44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b47:	8b 00                	mov    (%eax),%eax
  803b49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b4c:	c1 e2 04             	shl    $0x4,%edx
  803b4f:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b55:	89 02                	mov    %eax,(%edx)
  803b57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b6d:	c1 e0 04             	shl    $0x4,%eax
  803b70:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b75:	8b 00                	mov    (%eax),%eax
  803b77:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b7d:	c1 e0 04             	shl    $0x4,%eax
  803b80:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b85:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b8a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b8e:	48                   	dec    %eax
  803b8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b92:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803b96:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803b99:	c9                   	leave  
  803b9a:	c3                   	ret    

00803b9b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803b9b:	55                   	push   %ebp
  803b9c:	89 e5                	mov    %esp,%ebp
  803b9e:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  803ba4:	a1 84 50 83 00       	mov    0x835084,%eax
  803ba9:	39 c2                	cmp    %eax,%edx
  803bab:	72 0c                	jb     803bb9 <free_block+0x1e>
  803bad:	8b 55 08             	mov    0x8(%ebp),%edx
  803bb0:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803bb5:	39 c2                	cmp    %eax,%edx
  803bb7:	72 19                	jb     803bd2 <free_block+0x37>
  803bb9:	68 30 4b 80 00       	push   $0x804b30
  803bbe:	68 66 4a 80 00       	push   $0x804a66
  803bc3:	68 98 00 00 00       	push   $0x98
  803bc8:	68 03 4a 80 00       	push   $0x804a03
  803bcd:	e8 9f c8 ff ff       	call   800471 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd5:	83 ec 0c             	sub    $0xc,%esp
  803bd8:	50                   	push   %eax
  803bd9:	e8 c9 f8 ff ff       	call   8034a7 <to_page_info>
  803bde:	83 c4 10             	add    $0x10,%esp
  803be1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803be7:	8b 40 08             	mov    0x8(%eax),%eax
  803bea:	0f b7 c0             	movzwl %ax,%eax
  803bed:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803bf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803bf7:	eb 03                	jmp    803bfc <free_block+0x61>
		listIndex++;
  803bf9:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bff:	ba 08 00 00 00       	mov    $0x8,%edx
  803c04:	88 c1                	mov    %al,%cl
  803c06:	d3 e2                	shl    %cl,%edx
  803c08:	89 d0                	mov    %edx,%eax
  803c0a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c0d:	72 ea                	jb     803bf9 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c19:	75 17                	jne    803c32 <free_block+0x97>
  803c1b:	83 ec 04             	sub    $0x4,%esp
  803c1e:	68 0c 4b 80 00       	push   $0x804b0c
  803c23:	68 a2 00 00 00       	push   $0xa2
  803c28:	68 03 4a 80 00       	push   $0x804a03
  803c2d:	e8 3f c8 ff ff       	call   800471 <_panic>
  803c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c35:	c1 e0 04             	shl    $0x4,%eax
  803c38:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c3d:	8b 10                	mov    (%eax),%edx
  803c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c42:	89 10                	mov    %edx,(%eax)
  803c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c47:	8b 00                	mov    (%eax),%eax
  803c49:	85 c0                	test   %eax,%eax
  803c4b:	74 15                	je     803c62 <free_block+0xc7>
  803c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c50:	c1 e0 04             	shl    $0x4,%eax
  803c53:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c58:	8b 00                	mov    (%eax),%eax
  803c5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c5d:	89 50 04             	mov    %edx,0x4(%eax)
  803c60:	eb 11                	jmp    803c73 <free_block+0xd8>
  803c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c65:	c1 e0 04             	shl    $0x4,%eax
  803c68:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c71:	89 02                	mov    %eax,(%edx)
  803c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c76:	c1 e0 04             	shl    $0x4,%eax
  803c79:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c82:	89 02                	mov    %eax,(%edx)
  803c84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c91:	c1 e0 04             	shl    $0x4,%eax
  803c94:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c99:	8b 00                	mov    (%eax),%eax
  803c9b:	8d 50 01             	lea    0x1(%eax),%edx
  803c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca1:	c1 e0 04             	shl    $0x4,%eax
  803ca4:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ca9:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cae:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cb2:	40                   	inc    %eax
  803cb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cb6:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cbd:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cc1:	0f b7 c8             	movzwl %ax,%ecx
  803cc4:	b8 00 10 00 00       	mov    $0x1000,%eax
  803cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  803cce:	f7 75 e8             	divl   -0x18(%ebp)
  803cd1:	39 c1                	cmp    %eax,%ecx
  803cd3:	0f 85 ed 01 00 00    	jne    803ec6 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdc:	c1 e0 04             	shl    $0x4,%eax
  803cdf:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ce4:	8b 00                	mov    (%eax),%eax
  803ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ce9:	eb 2a                	jmp    803d15 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cee:	83 ec 0c             	sub    $0xc,%esp
  803cf1:	50                   	push   %eax
  803cf2:	e8 b0 f7 ff ff       	call   8034a7 <to_page_info>
  803cf7:	83 c4 10             	add    $0x10,%esp
  803cfa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cfd:	75 06                	jne    803d05 <free_block+0x16a>
				tmp = b;
  803cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d02:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d08:	c1 e0 04             	shl    $0x4,%eax
  803d0b:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d10:	8b 00                	mov    (%eax),%eax
  803d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d19:	74 07                	je     803d22 <free_block+0x187>
  803d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1e:	8b 00                	mov    (%eax),%eax
  803d20:	eb 05                	jmp    803d27 <free_block+0x18c>
  803d22:	b8 00 00 00 00       	mov    $0x0,%eax
  803d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d2a:	c1 e2 04             	shl    $0x4,%edx
  803d2d:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d33:	89 02                	mov    %eax,(%edx)
  803d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d38:	c1 e0 04             	shl    $0x4,%eax
  803d3b:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d40:	8b 00                	mov    (%eax),%eax
  803d42:	85 c0                	test   %eax,%eax
  803d44:	75 a5                	jne    803ceb <free_block+0x150>
  803d46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d4a:	75 9f                	jne    803ceb <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4f:	c1 e0 04             	shl    $0x4,%eax
  803d52:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d5c:	e9 cc 00 00 00       	jmp    803e2d <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d64:	8b 00                	mov    (%eax),%eax
  803d66:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d6c:	83 ec 0c             	sub    $0xc,%esp
  803d6f:	50                   	push   %eax
  803d70:	e8 32 f7 ff ff       	call   8034a7 <to_page_info>
  803d75:	83 c4 10             	add    $0x10,%esp
  803d78:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d7b:	0f 85 a6 00 00 00    	jne    803e27 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d85:	75 17                	jne    803d9e <free_block+0x203>
  803d87:	83 ec 04             	sub    $0x4,%esp
  803d8a:	68 9d 4a 80 00       	push   $0x804a9d
  803d8f:	68 b5 00 00 00       	push   $0xb5
  803d94:	68 03 4a 80 00       	push   $0x804a03
  803d99:	e8 d3 c6 ff ff       	call   800471 <_panic>
  803d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803da1:	8b 00                	mov    (%eax),%eax
  803da3:	85 c0                	test   %eax,%eax
  803da5:	74 10                	je     803db7 <free_block+0x21c>
  803da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803daa:	8b 00                	mov    (%eax),%eax
  803dac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803daf:	8b 52 04             	mov    0x4(%edx),%edx
  803db2:	89 50 04             	mov    %edx,0x4(%eax)
  803db5:	eb 14                	jmp    803dcb <free_block+0x230>
  803db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dba:	8b 40 04             	mov    0x4(%eax),%eax
  803dbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dc0:	c1 e2 04             	shl    $0x4,%edx
  803dc3:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803dc9:	89 02                	mov    %eax,(%edx)
  803dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dce:	8b 40 04             	mov    0x4(%eax),%eax
  803dd1:	85 c0                	test   %eax,%eax
  803dd3:	74 0f                	je     803de4 <free_block+0x249>
  803dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd8:	8b 40 04             	mov    0x4(%eax),%eax
  803ddb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dde:	8b 12                	mov    (%edx),%edx
  803de0:	89 10                	mov    %edx,(%eax)
  803de2:	eb 13                	jmp    803df7 <free_block+0x25c>
  803de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de7:	8b 00                	mov    (%eax),%eax
  803de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dec:	c1 e2 04             	shl    $0x4,%edx
  803def:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803df5:	89 02                	mov    %eax,(%edx)
  803df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0d:	c1 e0 04             	shl    $0x4,%eax
  803e10:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e15:	8b 00                	mov    (%eax),%eax
  803e17:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1d:	c1 e0 04             	shl    $0x4,%eax
  803e20:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e25:	89 10                	mov    %edx,(%eax)
			b = next;
  803e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e31:	0f 85 2a ff ff ff    	jne    803d61 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e3a:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e43:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e4d:	75 17                	jne    803e66 <free_block+0x2cb>
  803e4f:	83 ec 04             	sub    $0x4,%esp
  803e52:	68 0c 4b 80 00       	push   $0x804b0c
  803e57:	68 bc 00 00 00       	push   $0xbc
  803e5c:	68 03 4a 80 00       	push   $0x804a03
  803e61:	e8 0b c6 ff ff       	call   800471 <_panic>
  803e66:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e6f:	89 10                	mov    %edx,(%eax)
  803e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e74:	8b 00                	mov    (%eax),%eax
  803e76:	85 c0                	test   %eax,%eax
  803e78:	74 0d                	je     803e87 <free_block+0x2ec>
  803e7a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e82:	89 50 04             	mov    %edx,0x4(%eax)
  803e85:	eb 08                	jmp    803e8f <free_block+0x2f4>
  803e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e92:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ea1:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803ea6:	40                   	inc    %eax
  803ea7:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803eac:	83 ec 0c             	sub    $0xc,%esp
  803eaf:	ff 75 ec             	pushl  -0x14(%ebp)
  803eb2:	e8 7e f5 ff ff       	call   803435 <to_page_va>
  803eb7:	83 c4 10             	add    $0x10,%esp
  803eba:	83 ec 0c             	sub    $0xc,%esp
  803ebd:	50                   	push   %eax
  803ebe:	e8 fe d7 ff ff       	call   8016c1 <return_page>
  803ec3:	83 c4 10             	add    $0x10,%esp
	}
}
  803ec6:	90                   	nop
  803ec7:	c9                   	leave  
  803ec8:	c3                   	ret    

00803ec9 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803ec9:	55                   	push   %ebp
  803eca:	89 e5                	mov    %esp,%ebp
  803ecc:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803ecf:	83 ec 04             	sub    $0x4,%esp
  803ed2:	68 68 4b 80 00       	push   $0x804b68
  803ed7:	6a 07                	push   $0x7
  803ed9:	68 97 4b 80 00       	push   $0x804b97
  803ede:	e8 8e c5 ff ff       	call   800471 <_panic>

00803ee3 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803ee3:	55                   	push   %ebp
  803ee4:	89 e5                	mov    %esp,%ebp
  803ee6:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803ee9:	83 ec 04             	sub    $0x4,%esp
  803eec:	68 a8 4b 80 00       	push   $0x804ba8
  803ef1:	6a 0b                	push   $0xb
  803ef3:	68 97 4b 80 00       	push   $0x804b97
  803ef8:	e8 74 c5 ff ff       	call   800471 <_panic>

00803efd <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803efd:	55                   	push   %ebp
  803efe:	89 e5                	mov    %esp,%ebp
  803f00:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803f03:	83 ec 04             	sub    $0x4,%esp
  803f06:	68 d4 4b 80 00       	push   $0x804bd4
  803f0b:	6a 10                	push   $0x10
  803f0d:	68 97 4b 80 00       	push   $0x804b97
  803f12:	e8 5a c5 ff ff       	call   800471 <_panic>

00803f17 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803f17:	55                   	push   %ebp
  803f18:	89 e5                	mov    %esp,%ebp
  803f1a:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803f1d:	83 ec 04             	sub    $0x4,%esp
  803f20:	68 04 4c 80 00       	push   $0x804c04
  803f25:	6a 15                	push   $0x15
  803f27:	68 97 4b 80 00       	push   $0x804b97
  803f2c:	e8 40 c5 ff ff       	call   800471 <_panic>

00803f31 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803f31:	55                   	push   %ebp
  803f32:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803f34:	8b 45 08             	mov    0x8(%ebp),%eax
  803f37:	8b 40 10             	mov    0x10(%eax),%eax
}
  803f3a:	5d                   	pop    %ebp
  803f3b:	c3                   	ret    

00803f3c <__udivdi3>:
  803f3c:	55                   	push   %ebp
  803f3d:	57                   	push   %edi
  803f3e:	56                   	push   %esi
  803f3f:	53                   	push   %ebx
  803f40:	83 ec 1c             	sub    $0x1c,%esp
  803f43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f53:	89 ca                	mov    %ecx,%edx
  803f55:	89 f8                	mov    %edi,%eax
  803f57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f5b:	85 f6                	test   %esi,%esi
  803f5d:	75 2d                	jne    803f8c <__udivdi3+0x50>
  803f5f:	39 cf                	cmp    %ecx,%edi
  803f61:	77 65                	ja     803fc8 <__udivdi3+0x8c>
  803f63:	89 fd                	mov    %edi,%ebp
  803f65:	85 ff                	test   %edi,%edi
  803f67:	75 0b                	jne    803f74 <__udivdi3+0x38>
  803f69:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6e:	31 d2                	xor    %edx,%edx
  803f70:	f7 f7                	div    %edi
  803f72:	89 c5                	mov    %eax,%ebp
  803f74:	31 d2                	xor    %edx,%edx
  803f76:	89 c8                	mov    %ecx,%eax
  803f78:	f7 f5                	div    %ebp
  803f7a:	89 c1                	mov    %eax,%ecx
  803f7c:	89 d8                	mov    %ebx,%eax
  803f7e:	f7 f5                	div    %ebp
  803f80:	89 cf                	mov    %ecx,%edi
  803f82:	89 fa                	mov    %edi,%edx
  803f84:	83 c4 1c             	add    $0x1c,%esp
  803f87:	5b                   	pop    %ebx
  803f88:	5e                   	pop    %esi
  803f89:	5f                   	pop    %edi
  803f8a:	5d                   	pop    %ebp
  803f8b:	c3                   	ret    
  803f8c:	39 ce                	cmp    %ecx,%esi
  803f8e:	77 28                	ja     803fb8 <__udivdi3+0x7c>
  803f90:	0f bd fe             	bsr    %esi,%edi
  803f93:	83 f7 1f             	xor    $0x1f,%edi
  803f96:	75 40                	jne    803fd8 <__udivdi3+0x9c>
  803f98:	39 ce                	cmp    %ecx,%esi
  803f9a:	72 0a                	jb     803fa6 <__udivdi3+0x6a>
  803f9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fa0:	0f 87 9e 00 00 00    	ja     804044 <__udivdi3+0x108>
  803fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  803fab:	89 fa                	mov    %edi,%edx
  803fad:	83 c4 1c             	add    $0x1c,%esp
  803fb0:	5b                   	pop    %ebx
  803fb1:	5e                   	pop    %esi
  803fb2:	5f                   	pop    %edi
  803fb3:	5d                   	pop    %ebp
  803fb4:	c3                   	ret    
  803fb5:	8d 76 00             	lea    0x0(%esi),%esi
  803fb8:	31 ff                	xor    %edi,%edi
  803fba:	31 c0                	xor    %eax,%eax
  803fbc:	89 fa                	mov    %edi,%edx
  803fbe:	83 c4 1c             	add    $0x1c,%esp
  803fc1:	5b                   	pop    %ebx
  803fc2:	5e                   	pop    %esi
  803fc3:	5f                   	pop    %edi
  803fc4:	5d                   	pop    %ebp
  803fc5:	c3                   	ret    
  803fc6:	66 90                	xchg   %ax,%ax
  803fc8:	89 d8                	mov    %ebx,%eax
  803fca:	f7 f7                	div    %edi
  803fcc:	31 ff                	xor    %edi,%edi
  803fce:	89 fa                	mov    %edi,%edx
  803fd0:	83 c4 1c             	add    $0x1c,%esp
  803fd3:	5b                   	pop    %ebx
  803fd4:	5e                   	pop    %esi
  803fd5:	5f                   	pop    %edi
  803fd6:	5d                   	pop    %ebp
  803fd7:	c3                   	ret    
  803fd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fdd:	89 eb                	mov    %ebp,%ebx
  803fdf:	29 fb                	sub    %edi,%ebx
  803fe1:	89 f9                	mov    %edi,%ecx
  803fe3:	d3 e6                	shl    %cl,%esi
  803fe5:	89 c5                	mov    %eax,%ebp
  803fe7:	88 d9                	mov    %bl,%cl
  803fe9:	d3 ed                	shr    %cl,%ebp
  803feb:	89 e9                	mov    %ebp,%ecx
  803fed:	09 f1                	or     %esi,%ecx
  803fef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ff3:	89 f9                	mov    %edi,%ecx
  803ff5:	d3 e0                	shl    %cl,%eax
  803ff7:	89 c5                	mov    %eax,%ebp
  803ff9:	89 d6                	mov    %edx,%esi
  803ffb:	88 d9                	mov    %bl,%cl
  803ffd:	d3 ee                	shr    %cl,%esi
  803fff:	89 f9                	mov    %edi,%ecx
  804001:	d3 e2                	shl    %cl,%edx
  804003:	8b 44 24 08          	mov    0x8(%esp),%eax
  804007:	88 d9                	mov    %bl,%cl
  804009:	d3 e8                	shr    %cl,%eax
  80400b:	09 c2                	or     %eax,%edx
  80400d:	89 d0                	mov    %edx,%eax
  80400f:	89 f2                	mov    %esi,%edx
  804011:	f7 74 24 0c          	divl   0xc(%esp)
  804015:	89 d6                	mov    %edx,%esi
  804017:	89 c3                	mov    %eax,%ebx
  804019:	f7 e5                	mul    %ebp
  80401b:	39 d6                	cmp    %edx,%esi
  80401d:	72 19                	jb     804038 <__udivdi3+0xfc>
  80401f:	74 0b                	je     80402c <__udivdi3+0xf0>
  804021:	89 d8                	mov    %ebx,%eax
  804023:	31 ff                	xor    %edi,%edi
  804025:	e9 58 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  80402a:	66 90                	xchg   %ax,%ax
  80402c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804030:	89 f9                	mov    %edi,%ecx
  804032:	d3 e2                	shl    %cl,%edx
  804034:	39 c2                	cmp    %eax,%edx
  804036:	73 e9                	jae    804021 <__udivdi3+0xe5>
  804038:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80403b:	31 ff                	xor    %edi,%edi
  80403d:	e9 40 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  804042:	66 90                	xchg   %ax,%ax
  804044:	31 c0                	xor    %eax,%eax
  804046:	e9 37 ff ff ff       	jmp    803f82 <__udivdi3+0x46>
  80404b:	90                   	nop

0080404c <__umoddi3>:
  80404c:	55                   	push   %ebp
  80404d:	57                   	push   %edi
  80404e:	56                   	push   %esi
  80404f:	53                   	push   %ebx
  804050:	83 ec 1c             	sub    $0x1c,%esp
  804053:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804057:	8b 74 24 34          	mov    0x34(%esp),%esi
  80405b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80405f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804067:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80406b:	89 f3                	mov    %esi,%ebx
  80406d:	89 fa                	mov    %edi,%edx
  80406f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804073:	89 34 24             	mov    %esi,(%esp)
  804076:	85 c0                	test   %eax,%eax
  804078:	75 1a                	jne    804094 <__umoddi3+0x48>
  80407a:	39 f7                	cmp    %esi,%edi
  80407c:	0f 86 a2 00 00 00    	jbe    804124 <__umoddi3+0xd8>
  804082:	89 c8                	mov    %ecx,%eax
  804084:	89 f2                	mov    %esi,%edx
  804086:	f7 f7                	div    %edi
  804088:	89 d0                	mov    %edx,%eax
  80408a:	31 d2                	xor    %edx,%edx
  80408c:	83 c4 1c             	add    $0x1c,%esp
  80408f:	5b                   	pop    %ebx
  804090:	5e                   	pop    %esi
  804091:	5f                   	pop    %edi
  804092:	5d                   	pop    %ebp
  804093:	c3                   	ret    
  804094:	39 f0                	cmp    %esi,%eax
  804096:	0f 87 ac 00 00 00    	ja     804148 <__umoddi3+0xfc>
  80409c:	0f bd e8             	bsr    %eax,%ebp
  80409f:	83 f5 1f             	xor    $0x1f,%ebp
  8040a2:	0f 84 ac 00 00 00    	je     804154 <__umoddi3+0x108>
  8040a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8040ad:	29 ef                	sub    %ebp,%edi
  8040af:	89 fe                	mov    %edi,%esi
  8040b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040b5:	89 e9                	mov    %ebp,%ecx
  8040b7:	d3 e0                	shl    %cl,%eax
  8040b9:	89 d7                	mov    %edx,%edi
  8040bb:	89 f1                	mov    %esi,%ecx
  8040bd:	d3 ef                	shr    %cl,%edi
  8040bf:	09 c7                	or     %eax,%edi
  8040c1:	89 e9                	mov    %ebp,%ecx
  8040c3:	d3 e2                	shl    %cl,%edx
  8040c5:	89 14 24             	mov    %edx,(%esp)
  8040c8:	89 d8                	mov    %ebx,%eax
  8040ca:	d3 e0                	shl    %cl,%eax
  8040cc:	89 c2                	mov    %eax,%edx
  8040ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040d2:	d3 e0                	shl    %cl,%eax
  8040d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040dc:	89 f1                	mov    %esi,%ecx
  8040de:	d3 e8                	shr    %cl,%eax
  8040e0:	09 d0                	or     %edx,%eax
  8040e2:	d3 eb                	shr    %cl,%ebx
  8040e4:	89 da                	mov    %ebx,%edx
  8040e6:	f7 f7                	div    %edi
  8040e8:	89 d3                	mov    %edx,%ebx
  8040ea:	f7 24 24             	mull   (%esp)
  8040ed:	89 c6                	mov    %eax,%esi
  8040ef:	89 d1                	mov    %edx,%ecx
  8040f1:	39 d3                	cmp    %edx,%ebx
  8040f3:	0f 82 87 00 00 00    	jb     804180 <__umoddi3+0x134>
  8040f9:	0f 84 91 00 00 00    	je     804190 <__umoddi3+0x144>
  8040ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  804103:	29 f2                	sub    %esi,%edx
  804105:	19 cb                	sbb    %ecx,%ebx
  804107:	89 d8                	mov    %ebx,%eax
  804109:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80410d:	d3 e0                	shl    %cl,%eax
  80410f:	89 e9                	mov    %ebp,%ecx
  804111:	d3 ea                	shr    %cl,%edx
  804113:	09 d0                	or     %edx,%eax
  804115:	89 e9                	mov    %ebp,%ecx
  804117:	d3 eb                	shr    %cl,%ebx
  804119:	89 da                	mov    %ebx,%edx
  80411b:	83 c4 1c             	add    $0x1c,%esp
  80411e:	5b                   	pop    %ebx
  80411f:	5e                   	pop    %esi
  804120:	5f                   	pop    %edi
  804121:	5d                   	pop    %ebp
  804122:	c3                   	ret    
  804123:	90                   	nop
  804124:	89 fd                	mov    %edi,%ebp
  804126:	85 ff                	test   %edi,%edi
  804128:	75 0b                	jne    804135 <__umoddi3+0xe9>
  80412a:	b8 01 00 00 00       	mov    $0x1,%eax
  80412f:	31 d2                	xor    %edx,%edx
  804131:	f7 f7                	div    %edi
  804133:	89 c5                	mov    %eax,%ebp
  804135:	89 f0                	mov    %esi,%eax
  804137:	31 d2                	xor    %edx,%edx
  804139:	f7 f5                	div    %ebp
  80413b:	89 c8                	mov    %ecx,%eax
  80413d:	f7 f5                	div    %ebp
  80413f:	89 d0                	mov    %edx,%eax
  804141:	e9 44 ff ff ff       	jmp    80408a <__umoddi3+0x3e>
  804146:	66 90                	xchg   %ax,%ax
  804148:	89 c8                	mov    %ecx,%eax
  80414a:	89 f2                	mov    %esi,%edx
  80414c:	83 c4 1c             	add    $0x1c,%esp
  80414f:	5b                   	pop    %ebx
  804150:	5e                   	pop    %esi
  804151:	5f                   	pop    %edi
  804152:	5d                   	pop    %ebp
  804153:	c3                   	ret    
  804154:	3b 04 24             	cmp    (%esp),%eax
  804157:	72 06                	jb     80415f <__umoddi3+0x113>
  804159:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80415d:	77 0f                	ja     80416e <__umoddi3+0x122>
  80415f:	89 f2                	mov    %esi,%edx
  804161:	29 f9                	sub    %edi,%ecx
  804163:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804167:	89 14 24             	mov    %edx,(%esp)
  80416a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80416e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804172:	8b 14 24             	mov    (%esp),%edx
  804175:	83 c4 1c             	add    $0x1c,%esp
  804178:	5b                   	pop    %ebx
  804179:	5e                   	pop    %esi
  80417a:	5f                   	pop    %edi
  80417b:	5d                   	pop    %ebp
  80417c:	c3                   	ret    
  80417d:	8d 76 00             	lea    0x0(%esi),%esi
  804180:	2b 04 24             	sub    (%esp),%eax
  804183:	19 fa                	sbb    %edi,%edx
  804185:	89 d1                	mov    %edx,%ecx
  804187:	89 c6                	mov    %eax,%esi
  804189:	e9 71 ff ff ff       	jmp    8040ff <__umoddi3+0xb3>
  80418e:	66 90                	xchg   %ax,%ax
  804190:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804194:	72 ea                	jb     804180 <__umoddi3+0x134>
  804196:	89 d9                	mov    %ebx,%ecx
  804198:	e9 62 ff ff ff       	jmp    8040ff <__umoddi3+0xb3>
